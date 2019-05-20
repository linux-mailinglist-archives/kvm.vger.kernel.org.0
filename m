Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0852316F
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 12:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731674AbfETKgl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 06:36:41 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36403 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731667AbfETKgl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 06:36:41 -0400
Received: by mail-wm1-f66.google.com with SMTP id j187so12490874wmj.1
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 03:36:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3xXPvZpyjHsgmFWoKd9d5EDj4j0NbyZe+58R2bsw9kA=;
        b=oNw9H9H9fQpU3/Sd0kQtXIXgyR497agOFlZ3vBeN+DWDX8NV9VgYshGK4ceC1zdw0P
         NU73hOenr4wqmDwfjVwxMba88+iprjQ1NPZd5/xvtewvYf53/DRGspZCyTJ4+TRM5p/L
         Zn57Uy/ERwRcC/nfxPdyOyhiR3E0yqRGxwaIjMbGQ2dXr4znu9VIOPcfThHftOGWQuVR
         BhvSepzbQ73pYaL9GNixmepFBMInADNkvBS6fhOgoGkcpHEJWjESo5XVuxF+kBpAyVzk
         T4ZJ63MnGKTQhCECIOezJc/PheYDDl+HKaXv0V7/r240GDM7v4icojWPzkrIZX+vJUck
         zBTw==
X-Gm-Message-State: APjAAAVRb4P/o525OdLg1H9qQTm18giagZMVepaedeF7akOko5FBZRoZ
        Z/VmsTRy3pw39IW/ooUVJh+fmOAwe/8=
X-Google-Smtp-Source: APXvYqwFrpHwMAG0+wlGu82qSp+aU4+gtbOAlaZFMGwiFeMGZZMWNYjWlOJtHuNt4/KLKgezSbLeSw==
X-Received: by 2002:a1c:ca19:: with SMTP id a25mr11412291wmg.105.1558348598772;
        Mon, 20 May 2019 03:36:38 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac04:eef9:b257:b844? ([2001:b07:6468:f312:ac04:eef9:b257:b844])
        by smtp.gmail.com with ESMTPSA id m10sm9686930wmf.40.2019.05.20.03.36.38
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 03:36:38 -0700 (PDT)
Subject: Re: [PATCH 4/4] KVM: nVMX: Fix using __this_cpu_read() in preemptible
 context
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
References: <1558082990-7822-1-git-send-email-wanpengli@tencent.com>
 <1558082990-7822-4-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4874aa09-7f46-7ca5-5d32-1d7b1cb1eef3@redhat.com>
Date:   Mon, 20 May 2019 12:36:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1558082990-7822-4-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/05/19 10:49, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
>  BUG: using __this_cpu_read() in preemptible [00000000] code: qemu-system-x86/4590
>   caller is nested_vmx_enter_non_root_mode+0xebd/0x1790 [kvm_intel]
>   CPU: 4 PID: 4590 Comm: qemu-system-x86 Tainted: G           OE     5.1.0-rc4+ #1
>   Call Trace:
>    dump_stack+0x67/0x95
>    __this_cpu_preempt_check+0xd2/0xe0
>    nested_vmx_enter_non_root_mode+0xebd/0x1790 [kvm_intel]
>    nested_vmx_run+0xda/0x2b0 [kvm_intel]
>    handle_vmlaunch+0x13/0x20 [kvm_intel]
>    vmx_handle_exit+0xbd/0x660 [kvm_intel]
>    kvm_arch_vcpu_ioctl_run+0xa2c/0x1e50 [kvm]
>    kvm_vcpu_ioctl+0x3ad/0x6d0 [kvm]
>    do_vfs_ioctl+0xa5/0x6e0
>    ksys_ioctl+0x6d/0x80
>    __x64_sys_ioctl+0x1a/0x20
>    do_syscall_64+0x6f/0x6c0
>    entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> Accessing per-cpu variable should disable preemption, this patch extends the 
> preemption disable region for __this_cpu_read().
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 0c601d0..8f6f69c 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2792,14 +2792,13 @@ static int nested_vmx_check_vmentry_hw(struct kvm_vcpu *vcpu)
>  	      : "cc", "memory"
>  	);
>  
> -	preempt_enable();
> -
>  	if (vmx->msr_autoload.host.nr)
>  		vmcs_write32(VM_EXIT_MSR_LOAD_COUNT, vmx->msr_autoload.host.nr);
>  	if (vmx->msr_autoload.guest.nr)
>  		vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, vmx->msr_autoload.guest.nr);
>  
>  	if (vm_fail) {
> +		preempt_enable();
>  		WARN_ON_ONCE(vmcs_read32(VM_INSTRUCTION_ERROR) !=
>  			     VMXERR_ENTRY_INVALID_CONTROL_FIELD);
>  		return 1;
> @@ -2811,6 +2810,7 @@ static int nested_vmx_check_vmentry_hw(struct kvm_vcpu *vcpu)
>  	local_irq_enable();
>  	if (hw_breakpoint_active())
>  		set_debugreg(__this_cpu_read(cpu_dr7), 7);
> +	preempt_enable();
>  
>  	/*
>  	 * A non-failing VMEntry means we somehow entered guest mode with
> 


Queued, thanks.

Paolo
