Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4022FF173
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 18:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729337AbhAURLZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 12:11:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31407 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732764AbhAURFf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 12:05:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611248648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wDqjq1H9v8ghcGa3bJeTD9dliqNL4xtCFKkD6bW/J1U=;
        b=hYuQQMpBzSF7q38gQ1wti+T7VbDnFnL1X6PmnyF9uQdxQVsfRVLnumalF/crAzJmu7xYIv
        WrfUMH2Na46pQdX62Byn+tcO+MGemO4CQs3JdsF4nOooyjKkbVNd6iv+k598g722tCZKHJ
        AF+If+AoxZoEHn3bOyfEdheJQFtiWlk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-355-Y8KW-VbFNfGkSVA-CyONCQ-1; Thu, 21 Jan 2021 12:04:06 -0500
X-MC-Unique: Y8KW-VbFNfGkSVA-CyONCQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EEA251936B65;
        Thu, 21 Jan 2021 17:04:04 +0000 (UTC)
Received: from starship (unknown [10.35.206.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B42926E51B;
        Thu, 21 Jan 2021 17:04:01 +0000 (UTC)
Message-ID: <c6b1dec841182178c41a564fb822a615acc97762.camel@redhat.com>
Subject: Re: [PATCH v2 3/3] KVM: VMX: read idt_vectoring_info a bit earlier
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Borislav Petkov <bp@alien8.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>
Date:   Thu, 21 Jan 2021 19:04:00 +0200
In-Reply-To: <YADhzRqE6QHmTOkx@google.com>
References: <20210114205449.8715-1-mlevitsk@redhat.com>
         <20210114205449.8715-4-mlevitsk@redhat.com> <YADhzRqE6QHmTOkx@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-01-14 at 16:29 -0800, Sean Christopherson wrote:
> On Thu, Jan 14, 2021, Maxim Levitsky wrote:
> > This allows it to be printed correctly by the trace print
> 
> It'd be helpful to explicitly say which tracepoint, and explain that the value
> is read by vmx_get_exit_info().  It's far from obvious how this gets consumed.
> 
> > that follows.
> > 
> 
> Fixes: dcf068da7eb2 ("KVM: VMX: Introduce generic fastpath handler")
> 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> >  arch/x86/kvm/vmx/vmx.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index 2af05d3b05909..9b6e7dbf5e2bd 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -6771,6 +6771,8 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
> >  	}
> >  
> >  	vmx->exit_reason = vmcs_read32(VM_EXIT_REASON);
> > +	vmx->idt_vectoring_info = vmcs_read32(IDT_VECTORING_INFO_FIELD);
> 
> Hrm, it probably makes sense to either do the VMREAD conditionally, or to
> zero idt_vectoring_info in the vmx->fail path.  I don't care about the cycles
> on VM-Exit consistency checks, just that this would hide that the field is valid
> if and only if VM-Enter fully succeeded.  A third option would be to add a
> comment saying that it's unnecessary if VM-Enter failed, but faster in the
> common case to just do the VMREAD.

Allright, I will add this.

Best regards,
	Maxim Levitsky


> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 2af05d3b0590..3c172c05570a 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6774,13 +6774,15 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
>         if (unlikely((u16)vmx->exit_reason == EXIT_REASON_MCE_DURING_VMENTRY))
>                 kvm_machine_check();
> 
> +       if (likely(!(vmx->exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY)))
> +               vmx->idt_vectoring_info = vmcs_read32(IDT_VECTORING_INFO_FIELD);
> +
>         trace_kvm_exit(vmx->exit_reason, vcpu, KVM_ISA_VMX);
> 
>         if (unlikely(vmx->exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY))
>                 return EXIT_FASTPATH_NONE;
> 
>         vmx->loaded_vmcs->launched = 1;
> -       vmx->idt_vectoring_info = vmcs_read32(IDT_VECTORING_INFO_FIELD);
> 
>         vmx_recover_nmi_blocking(vmx);
>         vmx_complete_interrupts(vmx);
> 
> 
> > +
> >  	if (unlikely((u16)vmx->exit_reason == EXIT_REASON_MCE_DURING_VMENTRY))
> >  		kvm_machine_check();
> >  
> > @@ -6780,7 +6782,6 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
> >  		return EXIT_FASTPATH_NONE;
> >  
> >  	vmx->loaded_vmcs->launched = 1;
> > -	vmx->idt_vectoring_info = vmcs_read32(IDT_VECTORING_INFO_FIELD);
> >  
> >  	vmx_recover_nmi_blocking(vmx);
> >  	vmx_complete_interrupts(vmx);
> > -- 
> > 2.26.2
> > 


