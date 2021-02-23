Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E96532340B
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 00:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232267AbhBWWzQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 17:55:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233544AbhBWWwL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Feb 2021 17:52:11 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6951C061786
        for <kvm@vger.kernel.org>; Tue, 23 Feb 2021 14:51:30 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id q20so9784137pfu.8
        for <kvm@vger.kernel.org>; Tue, 23 Feb 2021 14:51:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ttBsWjyLSVhAbB5Dr48jKcxza7yyyr0KgTN3fQrwYqc=;
        b=peI5aM6IZ95/RV+lZK+vuJZJEWrN2dJDppCY0s5O5C1eMe/u0uGvUdXrucQPBOssY7
         ut22yq4EIIR8hbLTUEzQ3gTJ22xM/q+qro0cq5v0HVjjD0wJLIXUVge9PppWRO3FQX2z
         j6pL7xHwxsVI/haWeP9LVgX/rwaeHjrJJf1Vt2MhihwW2NgzwhGLm/8yWgCUShAbycWc
         cRbZPKOujYMDRiQ2AiE7fjMtL5bFDErZ5PuK6Rdp0YXLTKTVr5q0XLthLm0zR/oNFjlL
         nYpKHwhXjeXLaSyi8gGtBmfrSeR7NBPQdqc73OGwwqhXcZp4IrDTDO9sgpyoxrzNPrFT
         o4cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ttBsWjyLSVhAbB5Dr48jKcxza7yyyr0KgTN3fQrwYqc=;
        b=Z3cl5SnOH+oBQgBMQFBrKWUn0L+k09VLASRejoq6e66EaaPE+nNZp/I077l/LyeSYq
         3+vI9zhw670wvCYK/Ibat5NRCllO4k01243BbyOUVWcZSXLJ93gSJsOqkwEvqVXPiHn4
         FoZu9IPuFhJGK3vQhzxMbNGmfTsZgd+BPh38s8zLYJ3IHruQZf08rP0IxUyUboiQMBup
         Oydk+BLn1a+7PA3gTB0HWGmpdkhF8OMyfE0weyuVwTh8GkjUsDQa+DhHH6MQi55jFakn
         kSSXuwN5K8uEButb6XrzOQDB/pzfMDrygv0n9jGXDqXW4QBZIqL0nNDsgSO0KsvrCtJI
         Wawg==
X-Gm-Message-State: AOAM533FUo8whiGPTTAEChrgEFlZ4xesVQPTOR7cdItf2hTmkeJxsnpu
        A1VQ/IyPfJOYWcKKlmv/u9pTxqjHQGzEKg==
X-Google-Smtp-Source: ABdhPJyv/nNxjK2cfks0xqxZ7ShsLpN+vjAq8wBNnw/7e9+HFI8TGSySz9yIOROT3agpGQdIy/HWUQ==
X-Received: by 2002:aa7:94b7:0:b029:1ed:c7e8:d7f3 with SMTP id a23-20020aa794b70000b02901edc7e8d7f3mr7062926pfl.28.1614120690132;
        Tue, 23 Feb 2021 14:51:30 -0800 (PST)
Received: from google.com ([2620:15c:f:10:c939:813f:76bc:d651])
        by smtp.gmail.com with ESMTPSA id d189sm223746pfd.42.2021.02.23.14.51.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 14:51:29 -0800 (PST)
Date:   Tue, 23 Feb 2021 14:51:19 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     David Edmondson <david.edmondson@oracle.com>
Cc:     linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH v2 1/3] KVM: x86: dump_vmcs should not assume
 GUEST_IA32_EFER is valid
Message-ID: <YDWG51Io0VJEBHGg@google.com>
References: <20210219144632.2288189-1-david.edmondson@oracle.com>
 <20210219144632.2288189-2-david.edmondson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210219144632.2288189-2-david.edmondson@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 19, 2021, David Edmondson wrote:
> If the VM entry/exit controls for loading/saving MSR_EFER are either
> not available (an older processor or explicitly disabled) or not
> used (host and guest values are the same), reading GUEST_IA32_EFER
> from the VMCS returns an inaccurate value.
> 
> Because of this, in dump_vmcs() don't use GUEST_IA32_EFER to decide
> whether to print the PDPTRs - do so if the EPT is in use and CR4.PAE
> is set.

This isn't necessarily correct either.  In a way, it's less correct as PDPTRs
are more likely to be printed when they shouldn't, assuming most guests are
64-bit guests.  It's annoying to calculate the effective guest EFER, but so
awful that it's worth risking confusion over PDTPRs.

> Fixes: 4eb64dce8d0a ("KVM: x86: dump VMCS on invalid entry")
> Signed-off-by: David Edmondson <david.edmondson@oracle.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index eb69fef57485..818051c9fa10 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5759,7 +5759,6 @@ void dump_vmcs(void)
>  	u32 vmentry_ctl, vmexit_ctl;
>  	u32 cpu_based_exec_ctrl, pin_based_exec_ctrl, secondary_exec_control;
>  	unsigned long cr4;
> -	u64 efer;
>  
>  	if (!dump_invalid_vmcs) {
>  		pr_warn_ratelimited("set kvm_intel.dump_invalid_vmcs=1 to dump internal KVM state.\n");
> @@ -5771,7 +5770,6 @@ void dump_vmcs(void)
>  	cpu_based_exec_ctrl = vmcs_read32(CPU_BASED_VM_EXEC_CONTROL);
>  	pin_based_exec_ctrl = vmcs_read32(PIN_BASED_VM_EXEC_CONTROL);
>  	cr4 = vmcs_readl(GUEST_CR4);
> -	efer = vmcs_read64(GUEST_IA32_EFER);
>  	secondary_exec_control = 0;
>  	if (cpu_has_secondary_exec_ctrls())
>  		secondary_exec_control = vmcs_read32(SECONDARY_VM_EXEC_CONTROL);
> @@ -5784,8 +5782,7 @@ void dump_vmcs(void)
>  	       cr4, vmcs_readl(CR4_READ_SHADOW), vmcs_readl(CR4_GUEST_HOST_MASK));
>  	pr_err("CR3 = 0x%016lx\n", vmcs_readl(GUEST_CR3));
>  	if ((secondary_exec_control & SECONDARY_EXEC_ENABLE_EPT) &&
> -	    (cr4 & X86_CR4_PAE) && !(efer & EFER_LMA))
> -	{
> +	    (cr4 & X86_CR4_PAE)) {
>  		pr_err("PDPTR0 = 0x%016llx  PDPTR1 = 0x%016llx\n",
>  		       vmcs_read64(GUEST_PDPTR0), vmcs_read64(GUEST_PDPTR1));
>  		pr_err("PDPTR2 = 0x%016llx  PDPTR3 = 0x%016llx\n",
> @@ -5811,7 +5808,8 @@ void dump_vmcs(void)
>  	if ((vmexit_ctl & (VM_EXIT_SAVE_IA32_PAT | VM_EXIT_SAVE_IA32_EFER)) ||
>  	    (vmentry_ctl & (VM_ENTRY_LOAD_IA32_PAT | VM_ENTRY_LOAD_IA32_EFER)))
>  		pr_err("EFER =     0x%016llx  PAT = 0x%016llx\n",
> -		       efer, vmcs_read64(GUEST_IA32_PAT));
> +		       vmcs_read64(GUEST_IA32_EFER),
> +		       vmcs_read64(GUEST_IA32_PAT));
>  	pr_err("DebugCtl = 0x%016llx  DebugExceptions = 0x%016lx\n",
>  	       vmcs_read64(GUEST_IA32_DEBUGCTL),
>  	       vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS));
> -- 
> 2.30.0
> 
