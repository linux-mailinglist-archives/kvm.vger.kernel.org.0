Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8FB6394E5B
	for <lists+kvm@lfdr.de>; Sun, 30 May 2021 00:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbhE2WOZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 29 May 2021 18:14:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40954 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229483AbhE2WOY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 29 May 2021 18:14:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622326367;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qZpXiKZr8r6ctktJSLDdB4Xb33zSqSy1JUUZ+FTU9cU=;
        b=crEiMQePS3gxS7q0LL5T5uo57eMEsWKI2AvSjcNc0EcKocv0cGN4E+YmC3wTN4nAGjGlyl
        A9O8BON9i9Cwb4ZEpIEvJL9sYLPwfGEOOKpEvqHyxoaOQ9gNH1K1sh2Zhwzk8WBlOzUblc
        nV8eN7sHQApDu0WVVWsKgKYFdTOOrpw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-Ea9hShcUOFKLD438Roh56Q-1; Sat, 29 May 2021 18:12:45 -0400
X-MC-Unique: Ea9hShcUOFKLD438Roh56Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 38BB8800D62;
        Sat, 29 May 2021 22:12:43 +0000 (UTC)
Received: from starship (unknown [10.40.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2386D1E6;
        Sat, 29 May 2021 22:12:34 +0000 (UTC)
Message-ID: <4c3ef411ba68ca726531a379fb6c9d16178c8513.camel@redhat.com>
Subject: Re: [PATCH] KVM: X86: fix tlb_flush_guest()
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Date:   Sun, 30 May 2021 01:12:33 +0300
In-Reply-To: <YK/FGYejaIu6EzSn@google.com>
References: <20210527023922.2017-1-jiangshanlai@gmail.com>
         <78ad9dff-9a20-c17f-cd8f-931090834133@redhat.com>
         <YK/FGYejaIu6EzSn@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-05-27 at 16:13 +0000, Sean Christopherson wrote:
> +Maxim - A proper fix for this bug might fix your shadow paging + win10 boot
>          issue, this also affects the KVM_REQ_HV_TLB_FLUSH used for HyperV PV
> 	 flushing.

Still crashes with this patch sadly (tested now on my AMD laptop now).

This win10 boot bug without TDP paging is 100% reproducible,
although it crashes sometimes a bit differently, sometimes VM reboots right
at start of the boot, sometimes it just hangs forever, 
sometimes the VM bluescreens (with various reasons). 
This makes sense for random paging related corruption though.
 
I'll look at this patch more carefully soon.
 
I also have another bug which I put aside as well due to complexity
which involves running hyperv itself nested and and then migrating
the L1, which leads the hyperv VM bluescreen sooner or later,
(I don't remember anymore if that was both on intel and AMD or only intel,
but this didn’t involve any npt/ept disablement),
so I'll see if this patch helps with this bug as well.

Thanks,
	Best regards,
		Maxim Levitsky


> 
> On Thu, May 27, 2021, Paolo Bonzini wrote:
> > On 27/05/21 04:39, Lai Jiangshan wrote:
> > > From: Lai Jiangshan <laijs@linux.alibaba.com>
> > > 
> > > For KVM_VCPU_FLUSH_TLB used in kvm_flush_tlb_multi(), the guest expects
> > > the hypervisor do the operation that equals to native_flush_tlb_global()
> > > or invpcid_flush_all() in the specified guest CPU.
> > > 
> > > When TDP is enabled, there is no problem to just flush the hardware
> > > TLB of the specified guest CPU.
> > > 
> > > But when using shadowpaging, the hypervisor should have to sync the
> > > shadow pagetable at first before flushing the hardware TLB so that
> > > it can truely emulate the operation of invpcid_flush_all() in guest.
> > 
> > Can you explain why?
> 
> KVM's unsync logic hinges on guest TLB flushes.  For page permission modifications
> that require a TLB flush to take effect, e.g. making a writable page read-only,
> KVM waits until the guest explicitly does said flush to propagate the changes to
> the shadow page tables.  E.g. failure to sync PTEs could result in a read-only 4k
> page being writable when the guest expects it to be read-only.
> 
> > Also it is simpler to handle this in kvm_vcpu_flush_tlb_guest, using "if
> > (tdp_enabled).  This provides also a single, good place to add a comment
> > with the explanation of what invalid entries KVM_REQ_RELOAD is presenting.
> 
> Ya.  
> 
> KVM_REQ_MMU_RELOAD is overkill, nuking the shadow page tables will completely
> offset the performance gains of the paravirtualized flush.
> 
> And making a request won't work without revamping the order of request handling
> in vcpu_enter_guest(), e.g. KVM_REQ_MMU_RELOAD and KVM_REQ_MMU_SYNC are both
> serviced before KVM_REQ_STEAL_UPDATE.
> 
> Cleaning up and documenting the MMU related requests is on my todo list, but the
> immediate fix should be tiny and I can do my cleanups on top.
> 
> I believe the minimal fix is:
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 81ab3b8f22e5..b0072063f9bf 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3072,6 +3072,9 @@ static void kvm_vcpu_flush_tlb_all(struct kvm_vcpu *vcpu)
>  static void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu)
>  {
>         ++vcpu->stat.tlb_flush;
> +
> +       if (!tdp_enabled)
> +               kvm_mmu_sync_roots(vcpu);
>         static_call(kvm_x86_tlb_flush_guest)(vcpu);
>  }
>  
> 


