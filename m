Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFFCB3749F
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 14:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727419AbfFFM5e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 08:57:34 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39648 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726693AbfFFM5e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 08:57:34 -0400
Received: by mail-wm1-f67.google.com with SMTP id z23so2326476wma.4
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2019 05:57:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=47AgoWp3Y+KlSGwbKa4y1/1rw8HVERYQ6dMeASutNnY=;
        b=nSyV6HOWXeCtHfVNcCOWXfvGHSV6faSE4gBshF8lEWjeb38FYHlFIyQVRJjv5W7MU9
         sYqeDHzY+Uc7jnJeS2Hz++jJ7RW8ven6rikKl0aCJi6DWX0Lbq+eVb8ymVzRtfDIpSM0
         4uD/tFh2p11sUlcZQffv/l5vK2147IQhaBxad/euhZffnDZlHUdLVQNGmXEnfUslYPUj
         levJ43WLF+SeYRfHbQHntjuLeFuyiLLE64F7RMhYciYkBdfTu+JqScYf0aVl3h7R/9lv
         wLY/UN+9nL1C6zATxw1wcqRaFv6vRk+f2TsWp8clq4GVEJWZtzwPKEP4epHx62WKEWZ2
         V5vQ==
X-Gm-Message-State: APjAAAUY1kHYfc3u/UJYte4F3unoVPOs3WI+WkeJhh1n2WJURuBCjxm1
        xeemckIi52QvpVA4Nzr3W/ICkDlJUBE=
X-Google-Smtp-Source: APXvYqyZT2WkEGZLoBzKp6kX4cthzbi0Y8+ILAxt120msElyaqVGfZf2TjUnr3B19JUgbLWAzP6HUg==
X-Received: by 2002:a1c:acc8:: with SMTP id v191mr27370135wme.177.1559825851786;
        Thu, 06 Jun 2019 05:57:31 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id s10sm1689306wrt.66.2019.06.06.05.57.30
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 05:57:31 -0700 (PDT)
Subject: Re: [PATCH 1/5] KVM: VMX: Fix handling of #MC that occurs during
 VM-Entry
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>
References: <20190420055059.16816-1-sean.j.christopherson@intel.com>
 <20190420055059.16816-2-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c368af05-7027-5d1b-52f0-105d50df1d83@redhat.com>
Date:   Thu, 6 Jun 2019 14:57:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190420055059.16816-2-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/04/19 07:50, Sean Christopherson wrote:
> A previous fix to prevent KVM from consuming stale VMCS state after a
> failed VM-Entry inadvertantly blocked KVM's handling of machine checks
> that occur during VM-Entry.
> 
> Per Intel's SDM, a #MC during VM-Entry is handled in one of three ways,
> depending on when the #MC is recognoized.  As it pertains to this bug
> fix, the third case explicitly states EXIT_REASON_MCE_DURING_VMENTRY
> is handled like any other VM-Exit during VM-Entry, i.e. sets bit 31 to
> indicate the VM-Entry failed.
> 
> If a machine-check event occurs during a VM entry, one of the following occurs:
>  - The machine-check event is handled as if it occurred before the VM entry:
>         ...
>  - The machine-check event is handled after VM entry completes:
>         ...
>  - A VM-entry failure occurs as described in Section 26.7. The basic
>    exit reason is 41, for "VM-entry failure due to machine-check event".
> 
> Explicitly handle EXIT_REASON_MCE_DURING_VMENTRY as a one-off case in
> vmx_vcpu_run() instead of binning it into vmx_complete_atomic_exit().
> Doing so allows vmx_vcpu_run() to handle VMX_EXIT_REASONS_FAILED_VMENTRY
> in a sane fashion and also simplifies vmx_complete_atomic_exit() since
> VMCS.VM_EXIT_INTR_INFO is guaranteed to be fresh.
> 
> Fixes: b060ca3b2e9e7 ("kvm: vmx: Handle VMLAUNCH/VMRESUME failure properly")
> Cc: Jim Mattson <jmattson@google.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 20 ++++++++------------
>  1 file changed, 8 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index d8f101b58ab8..79ce9c7062f9 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -6103,28 +6103,21 @@ static void vmx_apicv_post_state_restore(struct kvm_vcpu *vcpu)
>  
>  static void vmx_complete_atomic_exit(struct vcpu_vmx *vmx)
>  {
> -	u32 exit_intr_info = 0;
> -	u16 basic_exit_reason = (u16)vmx->exit_reason;
> -
> -	if (!(basic_exit_reason == EXIT_REASON_MCE_DURING_VMENTRY
> -	      || basic_exit_reason == EXIT_REASON_EXCEPTION_NMI))
> +	if (vmx->exit_reason != EXIT_REASON_EXCEPTION_NMI)
>  		return;
>  
> -	if (!(vmx->exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY))
> -		exit_intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
> -	vmx->exit_intr_info = exit_intr_info;
> +	vmx->exit_intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
>  
>  	/* if exit due to PF check for async PF */
> -	if (is_page_fault(exit_intr_info))
> +	if (is_page_fault(vmx->exit_intr_info))
>  		vmx->vcpu.arch.apf.host_apf_reason = kvm_read_and_reset_pf_reason();
>  
>  	/* Handle machine checks before interrupts are enabled */
> -	if (basic_exit_reason == EXIT_REASON_MCE_DURING_VMENTRY ||
> -	    is_machine_check(exit_intr_info))
> +	if (is_machine_check(vmx->exit_intr_info))
>  		kvm_machine_check();
>  
>  	/* We need to handle NMIs before interrupts are enabled */
> -	if (is_nmi(exit_intr_info)) {
> +	if (is_nmi(vmx->exit_intr_info)) {
>  		kvm_before_interrupt(&vmx->vcpu);
>  		asm("int $2");
>  		kvm_after_interrupt(&vmx->vcpu);

This is indeed cleaner in addition to fixing the bug.  I'm also applying this

-------------- 8< --------------
Subject: [PATCH] kvm: nVMX: small cleanup in handle_exception
From: Paolo Bonzini <pbonzini@redhat.com>

The reason for skipping handling of NMI and #MC in handle_exception is
the same, namely they are handled earlier by vmx_complete_atomic_exit.
Calling the machine check handler (which just returns 1) is misleading,
don't do it.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1b3ca0582a0c..da6c829bad9f 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4455,11 +4455,8 @@ static int handle_exception(struct kvm_vcpu *vcpu)
 	vect_info = vmx->idt_vectoring_info;
 	intr_info = vmx->exit_intr_info;
 
-	if (is_machine_check(intr_info))
-		return handle_machine_check(vcpu);
-
-	if (is_nmi(intr_info))
-		return 1;  /* already handled by vmx_vcpu_run() */
+	if (is_machine_check(intr_info) || is_nmi(intr_info))
+		return 1;  /* already handled by vmx_complete_atomic_exit */
 
 	if (is_invalid_opcode(intr_info))
 		return handle_ud(vcpu);

