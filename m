Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D662C9187D
	for <lists+kvm@lfdr.de>; Sun, 18 Aug 2019 19:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbfHRRxj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 18 Aug 2019 13:53:39 -0400
Received: from inca-roads.misterjones.org ([213.251.177.50]:58464 "EHLO
        inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726089AbfHRRxj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 18 Aug 2019 13:53:39 -0400
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why)
        by cheepnis.misterjones.org with esmtpsa (TLSv1.2:AES256-GCM-SHA384:256)
        (Exim 4.80)
        (envelope-from <maz@kernel.org>)
        id 1hzPMv-0007XI-97; Sun, 18 Aug 2019 19:53:29 +0200
Date:   Sun, 18 Aug 2019 18:53:26 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Radim =?UTF-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>,
        Tangnianyao <tangnianyao@huawei.com>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>
Subject: Re: [PATCH 2/2] KVM: Call kvm_arch_vcpu_blocking early into the
 blocking sequence
Message-ID: <20190818185326.63f3ea9d@why>
In-Reply-To: <a7250b9a-60e9-b04c-5515-e506aea46515@redhat.com>
References: <20190802103709.70148-1-maz@kernel.org>
        <20190802103709.70148-3-maz@kernel.org>
        <a7250b9a-60e9-b04c-5515-e506aea46515@redhat.com>
Organization: Approximate
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, rkrcmar@redhat.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, james.morse@arm.com, joro@8bytes.org, Suravee.Suthikulpanit@amd.com, tangnianyao@huawei.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2 Aug 2019 12:46:33 +0200
Paolo Bonzini <pbonzini@redhat.com> wrote:

> On 02/08/19 12:37, Marc Zyngier wrote:
> > When a vpcu is about to block by calling kvm_vcpu_block, we call
> > back into the arch code to allow any form of synchronization that
> > may be required at this point (SVN stops the AVIC, ARM synchronises
> > the VMCR and enables GICv4 doorbells). But this synchronization
> > comes in quite late, as we've potentially waited for halt_poll_ns
> > to expire.
> > 
> > Instead, let's move kvm_arch_vcpu_blocking() to the beginning of
> > kvm_vcpu_block(), which on ARM has several benefits:
> > 
> > - VMCR gets synchronised early, meaning that any interrupt delivered
> >   during the polling window will be evaluated with the correct guest
> >   PMR
> > - GICv4 doorbells are enabled, which means that any guest interrupt
> >   directly injected during that window will be immediately recognised
> > 
> > Tang Nianyao ran some tests on a GICv4 machine to evaluate such
> > change, and reported up to a 10% improvement for netperf:
> > 
> > <quote>
> > 	netperf result:
> > 	D06 as server, intel 8180 server as client
> > 	with change:
> > 	package 512 bytes - 5500 Mbits/s
> > 	package 64 bytes - 760 Mbits/s
> > 	without change:
> > 	package 512 bytes - 5000 Mbits/s
> > 	package 64 bytes - 710 Mbits/s
> > </quote>
> > 
> > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > ---
> >  virt/kvm/kvm_main.c | 7 +++----
> >  1 file changed, 3 insertions(+), 4 deletions(-)
> > 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index 887f3b0c2b60..90d429c703cb 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -2322,6 +2322,8 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
> >  	bool waited = false;
> >  	u64 block_ns;
> >  
> > +	kvm_arch_vcpu_blocking(vcpu);
> > +
> >  	start = cur = ktime_get();
> >  	if (vcpu->halt_poll_ns && !kvm_arch_no_poll(vcpu)) {
> >  		ktime_t stop = ktime_add_ns(ktime_get(), vcpu->halt_poll_ns);
> > @@ -2342,8 +2344,6 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
> >  		} while (single_task_running() && ktime_before(cur, stop));
> >  	}
> >  
> > -	kvm_arch_vcpu_blocking(vcpu);
> > -
> >  	for (;;) {
> >  		prepare_to_swait_exclusive(&vcpu->wq, &wait, TASK_INTERRUPTIBLE);
> >  
> > @@ -2356,9 +2356,8 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
> >  
> >  	finish_swait(&vcpu->wq, &wait);
> >  	cur = ktime_get();
> > -
> > -	kvm_arch_vcpu_unblocking(vcpu);
> >  out:
> > +	kvm_arch_vcpu_unblocking(vcpu);
> >  	block_ns = ktime_to_ns(cur) - ktime_to_ns(start);
> >  
> >  	if (!vcpu_valid_wakeup(vcpu))
> >   
> 
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Thanks for that. I've pushed this patch into -next so that it gets a
bit of exposure (I haven't heard from the AMD folks, and I'd like to
make sure it doesn't regress their platforms).

	M.
-- 
Without deviation from the norm, progress is not possible.
