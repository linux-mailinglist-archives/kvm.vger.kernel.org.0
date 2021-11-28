Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D753460A90
	for <lists+kvm@lfdr.de>; Sun, 28 Nov 2021 23:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242101AbhK1WVu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 Nov 2021 17:21:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28910 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231842AbhK1WTu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 28 Nov 2021 17:19:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638137792;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4dDgSQ/8TweS/kg7WcZSSnDUpsnRjzcTHNmiNwKkyh0=;
        b=hBzaokjeQgrg8fhwWn0/f7oLf+E0Q7B6ZQYVORMZO9MQukQ2WlBlt4OD9xParZ/XOh8TVv
        g58zcdJ1vbyOtQw7J3X9qdLvWnM6XWBprWwnbc5s1XeYbkBM4xZK65Ms9q7qHNEXLg6pLO
        PU6lrEZNUUmGA88PElCPdqsvFx7xQlI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-95-8nKb2QCzNQClj-d059dZtw-1; Sun, 28 Nov 2021 17:16:29 -0500
X-MC-Unique: 8nKb2QCzNQClj-d059dZtw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 935911808322;
        Sun, 28 Nov 2021 22:16:24 +0000 (UTC)
Received: from starship (unknown [10.40.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0B8E810016F2;
        Sun, 28 Nov 2021 22:16:02 +0000 (UTC)
Message-ID: <4e883728e3e5201a94eb46b56315afca5e95ad9c.camel@redhat.com>
Subject: Re: [PATCH v2 11/43] KVM: Don't block+unblock when halt-polling is
 successful
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>
Date:   Mon, 29 Nov 2021 00:16:01 +0200
In-Reply-To: <cceb33be9e2a6ac504bb95a7b2b8cf5fe0b1ff26.camel@redhat.com>
References: <20211009021236.4122790-1-seanjc@google.com>
         <20211009021236.4122790-12-seanjc@google.com>
         <cceb33be9e2a6ac504bb95a7b2b8cf5fe0b1ff26.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2021-10-27 at 16:40 +0300, Maxim Levitsky wrote:
> On Fri, 2021-10-08 at 19:12 -0700, Sean Christopherson wrote:
> > Invoke the arch hooks for block+unblock if and only if KVM actually
> > attempts to block the vCPU.  The only non-nop implementation is on x86,
> > specifically SVM's AVIC, and there is no need to put the AVIC prior to
> > halt-polling as KVM x86's kvm_vcpu_has_events() will scour the full vIRR
> > to find pending IRQs regardless of whether the AVIC is loaded/"running".
> > 
> > The primary motivation is to allow future cleanup to split out "block"
> > from "halt", but this is also likely a small performance boost on x86 SVM
> > when halt-polling is successful.
> > 
> > Adjust the post-block path to update "cur" after unblocking, i.e. include
> > AVIC load time in halt_wait_ns and halt_wait_hist, so that the behavior
> > is consistent.  Moving just the pre-block arch hook would result in only
> > the AVIC put latency being included in the halt_wait stats.  There is no
> > obvious evidence that one way or the other is correct, so just ensure KVM
> > is consistent.
> > 
> > Note, x86 has two separate paths for handling APICv with respect to vCPU
> > blocking.  VMX uses hooks in x86's vcpu_block(), while SVM uses the arch
> > hooks in kvm_vcpu_block().  Prior to this path, the two paths were more
> > or less functionally identical.  That is very much not the case after
> > this patch, as the hooks used by VMX _must_ fire before halt-polling.
> > x86's entire mess will be cleaned up in future patches.
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > ---
> >  virt/kvm/kvm_main.c | 7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> > 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index f90b3ed05628..227f6bbe0716 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -3235,8 +3235,6 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
> >  	bool waited = false;
> >  	u64 block_ns;
> >  
> > -	kvm_arch_vcpu_blocking(vcpu);
> > -
> >  	start = cur = poll_end = ktime_get();
> >  	if (do_halt_poll) {
> >  		ktime_t stop = ktime_add_ns(ktime_get(), vcpu->halt_poll_ns);
> > @@ -3253,6 +3251,7 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
> >  		} while (kvm_vcpu_can_poll(cur, stop));
> >  	}
> >  
> > +	kvm_arch_vcpu_blocking(vcpu);
> >  
> >  	prepare_to_rcuwait(wait);
> >  	for (;;) {
> > @@ -3265,6 +3264,9 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
> >  		schedule();
> >  	}
> >  	finish_rcuwait(wait);
> > +
> > +	kvm_arch_vcpu_unblocking(vcpu);
> > +
> >  	cur = ktime_get();
> >  	if (waited) {
> >  		vcpu->stat.generic.halt_wait_ns +=
> > @@ -3273,7 +3275,6 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
> >  				ktime_to_ns(cur) - ktime_to_ns(poll_end));
> >  	}
> >  out:
> > -	kvm_arch_vcpu_unblocking(vcpu);
> >  	block_ns = ktime_to_ns(cur) - ktime_to_ns(start);
> >  
> >  	/*
> 
> Makes sense.
> 
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> 
> Best regards,
> 	Maxim Levitsky


So...

Last week I decided to study a bit how AVIC behaves when vCPUs are not 100% running
(aka no cpu_pm=on), to mostly understand their so-called 'GA log' thing.
 
(This thing is that when you tell the IOMMU that a vCPU is not running,
the IOMMU starts logging all incoming passed-through interrupts to a ring buffer,
and raises its own interrupt, which’s handler is supposed to wake up the VM's vCPU.)
 
That led to me discovering that AMD's IOMMU is totally busted after a suspend/resume cycle,
fixing which took me few days (and most of the time I worried that it's some sort of a BIOS bug which nobody would fix,
as the IOMMU interrupt delivery was totally busted after resume, sometimes even power cycle didn't help
to revive it - phew...). 
Luckily I did fix it, and patches are waiting for the review upstream.
(https://www.spinics.net/lists/kernel/msg4153488.html)
 
 
Another thing I discovered that this patch series totally breaks my VMs, without cpu_pm=on
The whole series (I didn't yet bisect it) makes even my fedora32 VM be very laggy, almost unusable,
and it only has one passed-through device, a nic).
 
If I apply though only the patch series up to this patch, my fedora VM seems to work fine, but
my windows VM still locks up hard when I run 'LatencyTop' in it, which doesn't happen without this patch.
 
 
So far the symptoms I see is that on VCPU 0, ISR has quite high interrupt (0xe1 last time I seen it),
TPR and PPR are 0xe0 (although I have seen TPR to have different values), and IRR has plenty of interrupts
with lower priority. The VM seems to be stuck in this case. As if its EOI got lost or something is preventing
the IRQ handler from issuing EOI.
 
LatencyTop does install some form of a kernel driver which likely does meddle with interrupts (maybe it sends lots of self IPIs?).
 
100% reproducible as soon as I start monitoring with LatencyTop.
 
 
Without this patch it works (or if disabling halt polling),
 
but I still did manage to lockup the VM few times still, after lot of random clicking/starting up various apps while LatencyTop was running,
etc, but in this case when I dump local apic via qemu's hmp interface the VM instantly revives, which might be either same bug
which got amplified by this patch or something else.
That was tested on the pure 5.15.0 kernel without any patches.
 
It is possible that this is a bug in LatencyTop that just got exposed by different timing.
 
The windows VM does have GPU and few USB controllers passed to it, and without them, in pure VM mode, as I call it,
the LatencyTop seems to work.
 

Tomorrow I'll give it a more formal investigation.
 
Best regards,
	Maxim Levitsky


