Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80850409FAC
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 00:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244286AbhIMWdN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 18:33:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58056 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236280AbhIMWdM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Sep 2021 18:33:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631572315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+pe8dfj+kOBWXRxJxkk96MAr31FNxCfZh5AoAgmpL0s=;
        b=AvGcAwm6kO1TbqQU1eMWmwNOe+X+/wkWdgfCvLZT8fAmmr6qb71g+SzsoBh0OSWfhs55Mm
        Tgv32zovq5uYU1M5a0GY+t+qRyuhxkUKTVkFKgwtfpuWt7p6kTVdpakEdHCj/9eejictSQ
        AeY1eXCkoHz1e/5erlPGV6NhPQPfqy8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-263-19kveWv6O4eHzsLcN6Q6gg-1; Mon, 13 Sep 2021 18:31:54 -0400
X-MC-Unique: 19kveWv6O4eHzsLcN6Q6gg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 155DE1006AA0;
        Mon, 13 Sep 2021 22:31:53 +0000 (UTC)
Received: from starship (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 641B95C1D1;
        Mon, 13 Sep 2021 22:31:44 +0000 (UTC)
Message-ID: <974f204f02daab3d4e8e02b74514d01f92aeb88a.camel@redhat.com>
Subject: Re: [PATCH 2/7] KVM: X86: Synchronize the shadow pagetable before
 link it
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org
Date:   Tue, 14 Sep 2021 01:31:43 +0300
In-Reply-To: <YT+5WZsT4bfFSezR@google.com>
References: <20210824075524.3354-1-jiangshanlai@gmail.com>
         <20210824075524.3354-3-jiangshanlai@gmail.com>
         <YTFhCt87vzo4xDrc@google.com>
         <0103c8b2cccea601bd3474f47d982b37e9536921.camel@redhat.com>
         <YT+5WZsT4bfFSezR@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 2021-09-13 at 20:49 +0000, Sean Christopherson wrote:
> On Mon, Sep 13, 2021, Maxim Levitsky wrote:
> > On Thu, 2021-09-02 at 23:40 +0000, Sean Christopherson wrote:
> > > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > > index 4853c033e6ce..03293cd3c7ae 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -2143,8 +2143,10 @@ static struct kvm_mmu_page *kvm_mmu_get_page(struct kvm_vcpu *vcpu,
> > >  			kvm_make_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu);
> > >  		}
> > > 
> > > -		if (sp->unsync_children)
> > > -			kvm_make_request(KVM_REQ_MMU_SYNC, vcpu);
> > > +		if (sp->unsync_children) {
> > > +			kvm_make_all_cpus_request(KVM_REQ_MMU_SYNC, vcpu);
> > 
> > I don't know the KVM mmu well so I miss something here most likely,
> > but why to switch to kvm_make_all_cpus_request?
> > 
> > MMU is shared by all VCPUs, and the process of its syncing should also do
> > remote TLB flushes when needed?
> > 
> > Another thing I don't fully understand is why this patch is needed. If we
> > link an SP which has unsync children, we raise KVM_REQ_MMU_SYNC, which I
> > think means that *this* vCPU will sync the whole MMU on next guest entry,
> > including these unsync child SPs. Could you explain this?
> 
> Answering all three questions at once, the problem is that KVM links in a new SP
> that points at unsync'd SPs _before_ servicing KVM_REQ_MMU_SYNC.  While the vCPU
> is guaranteed to service KVM_REQ_MMU_SYNC before entering the guest, that doesn't
> hold true for other vCPUs.  As a result, there's a window where a different vCPU
> can consume the stale, unsync SP via the new SP.
> 
Thank you, now I understand!

Best regards,
	Maxim Levitsky

