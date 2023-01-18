Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC1676722CE
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 17:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbjARQSe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 11:18:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbjARQR4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 11:17:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E968A5D107
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 08:12:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674058345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HZ1wlULzl5j/Ai3C1O6Ue9p94J1f6iBTtcZuZ+g+Bqo=;
        b=WlGkZpRH0pTCZupegaO9OMdJgid+70zWX1ETdYYTLQQtV+8GdG8rNXqb1ME5hAuQygQjqQ
        lH+q17Khr7vp5uT1q4WAjik8lZIXVd1bMg+ZNRPydSUxP7fcmENqqGbfVU0noqFzyysagp
        jfkFlma7oEpeMLUJXJ35yuSXTx1Gd7Q=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-542-VKRLx5JPOFu68uZRDggqQA-1; Wed, 18 Jan 2023 11:12:24 -0500
X-MC-Unique: VKRLx5JPOFu68uZRDggqQA-1
Received: by mail-ed1-f72.google.com with SMTP id j10-20020a05640211ca00b0049e385d5830so3808982edw.22
        for <kvm@vger.kernel.org>; Wed, 18 Jan 2023 08:12:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HZ1wlULzl5j/Ai3C1O6Ue9p94J1f6iBTtcZuZ+g+Bqo=;
        b=vUY2FoKhTX8x1W+djEv7XpNTfLLSeoV908f1rOMrFuPw6s9CkHn6r5JVaaQJ1F4bcl
         bwe4jzI7EGt6xj1YMO1Diq1P5EWihLeF2u8fthxSmj6EDDoYZ21BNFxEnnF+i+d6rjli
         2Ag+8UGHIM5n91Xkc7HS5ww0T/FIL8QaI9KL8cd7F4d+6D3bawaSLh32XEanz1FZsbQL
         MsU8RtBkRmb9oKZCvfZue6BrsXBiqDC2oJGm9Zl8obgw+KADIBTI5oQNK7N527f+6rz8
         PlWKoxG08XTq7WQrWdBKl1aOU1qmHfBSWQAT1SFBOfKTI2U96LxxzG1Gk897lmfs3WrI
         0teg==
X-Gm-Message-State: AFqh2kozSpVDn3T0TC1fJh6rKR4PbZD6ZlbhTGgi1oc92gOJ3kfN+IHU
        u6UHo7H0VcA78Zn8JGljywyNiwlw1tFy7s52qWXhSojAlaK1hOFofjPM4bf3NJMtY0GAetRW8ij
        ZlkgPIsESOO3i
X-Received: by 2002:a17:906:6819:b0:872:23b8:d6f1 with SMTP id k25-20020a170906681900b0087223b8d6f1mr8508377ejr.14.1674058343004;
        Wed, 18 Jan 2023 08:12:23 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtKAcEGlfz+OoTDxJTqYaoRvDxsYwuBYrPLqc7FGOjtJ2+pTI9925aaQyiZj3eL3gcgbOWaWQ==
X-Received: by 2002:a17:906:6819:b0:872:23b8:d6f1 with SMTP id k25-20020a170906681900b0087223b8d6f1mr8508361ejr.14.1674058342793;
        Wed, 18 Jan 2023 08:12:22 -0800 (PST)
Received: from ovpn-194-7.brq.redhat.com (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id o11-20020a170906768b00b0084d242d07ffsm14495177ejm.8.2023.01.18.08.12.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 08:12:22 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Alexandru Matei <alexandru.matei@uipath.com>
Cc:     kvm@vger.kernel.org, Alexandru Matei <alexandru.matei@uipath.com>,
        Mihai Petrisor <mihai.petrisor@uipath.com>,
        Viorel Canja <viorel.canja@uipath.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH] KVM: VMX: Fix crash due to uninitialized current_vmcs
In-Reply-To: <20230118141348.828-1-alexandru.matei@uipath.com>
References: <20230118141348.828-1-alexandru.matei@uipath.com>
Date:   Wed, 18 Jan 2023 17:12:20 +0100
Message-ID: <87edrres9n.fsf@ovpn-194-7.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Alexandru Matei <alexandru.matei@uipath.com> writes:

> KVM enables 'Enlightened VMCS' and 'Enlightened MSR Bitmap' when running as
> a nested hypervisor on top of Hyper-V. When MSR bitmap is updated,
> evmcs_touch_msr_bitmap function uses current_vmcs per-cpu variable to mark
> that the msr bitmap was changed.
>
> vmx_vcpu_create() modifies the msr bitmap via vmx_disable_intercept_for_msr
> -> vmx_msr_bitmap_l01_changed which in the end calls this function. The
> function checks for current_vmcs if it is null but the check is
> insufficient because current_vmcs is not initialized. 

I'm failing to remember why evmcs_touch_msr_bitmap() needs
'current_vmcs' at all, can we just use 'vmx->loaded_vmcs->vmcs' (after
passing 'vmx' parameter to it) instead?

> Because of this, the
> code might incorrectly write to the structure pointed by current_vmcs value
> left by another task. Preemption is not disabled so the current task can
> also be preempted and moved to another CPU while current_vmcs is accessed
> multiple times from evmcs_touch_msr_bitmap() which leads to crash.
>
> To fix this problem, this patch moves vmx_disable_intercept_for_msr calls
> before init_vmcs call in __vmx_vcpu_reset(), as ->vcpu_reset() is invoked
> after the vCPU is properly loaded via ->vcpu_load() and current_vmcs is
> initialized.
>
> BUG: kernel NULL pointer dereference, address: 0000000000000338
> PGD 4e1775067 P4D 0
> Oops: 0002 [#1] PREEMPT SMP NOPTI
> ...
> RIP: 0010:vmx_msr_bitmap_l01_changed+0x39/0x50 [kvm_intel]
> ...
> Call Trace:
>  vmx_disable_intercept_for_msr+0x36/0x260 [kvm_intel]
>  vmx_vcpu_create+0xe6/0x540 [kvm_intel]
>  ? __vmalloc_node+0x4a/0x70
>  kvm_arch_vcpu_create+0x1d1/0x2e0 [kvm]
>  kvm_vm_ioctl_create_vcpu+0x178/0x430 [kvm]
>  ? __handle_mm_fault+0x3cb/0x750
>  kvm_vm_ioctl+0x53f/0x790 [kvm]
>  ? syscall_exit_work+0x11a/0x150
>  ? syscall_exit_to_user_mode+0x12/0x30
>  ? do_syscall_64+0x69/0x90
>  ? handle_mm_fault+0xc5/0x2a0
>  __x64_sys_ioctl+0x8a/0xc0
>  do_syscall_64+0x5c/0x90
>  ? exc_page_fault+0x62/0x150
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
>
> Signed-off-by: Alexandru Matei <alexandru.matei@uipath.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 32 ++++++++++++++++----------------
>  1 file changed, 16 insertions(+), 16 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index fe5615fd8295..168138dfb0b4 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4735,6 +4735,22 @@ static void __vmx_vcpu_reset(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_vmx *vmx = to_vmx(vcpu);
>  
> +	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_TSC, MSR_TYPE_R);
> +#ifdef CONFIG_X86_64
> +	vmx_disable_intercept_for_msr(vcpu, MSR_FS_BASE, MSR_TYPE_RW);
> +	vmx_disable_intercept_for_msr(vcpu, MSR_GS_BASE, MSR_TYPE_RW);
> +	vmx_disable_intercept_for_msr(vcpu, MSR_KERNEL_GS_BASE, MSR_TYPE_RW);
> +#endif
> +	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_CS, MSR_TYPE_RW);
> +	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_ESP, MSR_TYPE_RW);
> +	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_EIP, MSR_TYPE_RW);
> +	if (kvm_cstate_in_guest(vcpu->kvm)) {
> +		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C1_RES, MSR_TYPE_R);
> +		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C3_RESIDENCY, MSR_TYPE_R);
> +		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C6_RESIDENCY, MSR_TYPE_R);
> +		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C7_RESIDENCY, MSR_TYPE_R);
> +	}
> +
>  	init_vmcs(vmx);
>  
>  	if (nested)
> @@ -7363,22 +7379,6 @@ static int vmx_vcpu_create(struct kvm_vcpu *vcpu)
>  	bitmap_fill(vmx->shadow_msr_intercept.read, MAX_POSSIBLE_PASSTHROUGH_MSRS);
>  	bitmap_fill(vmx->shadow_msr_intercept.write, MAX_POSSIBLE_PASSTHROUGH_MSRS);

I think that vmx_disable_intercept_for_msr() you move uses
'vmx->shadow_msr_intercept.read'/'vmx->shadow_msr_intercept.write' from
above so there's a dependency here. Let's avoid the churn (if possible).

>  
> -	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_TSC, MSR_TYPE_R);
> -#ifdef CONFIG_X86_64
> -	vmx_disable_intercept_for_msr(vcpu, MSR_FS_BASE, MSR_TYPE_RW);
> -	vmx_disable_intercept_for_msr(vcpu, MSR_GS_BASE, MSR_TYPE_RW);
> -	vmx_disable_intercept_for_msr(vcpu, MSR_KERNEL_GS_BASE, MSR_TYPE_RW);
> -#endif
> -	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_CS, MSR_TYPE_RW);
> -	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_ESP, MSR_TYPE_RW);
> -	vmx_disable_intercept_for_msr(vcpu, MSR_IA32_SYSENTER_EIP, MSR_TYPE_RW);
> -	if (kvm_cstate_in_guest(vcpu->kvm)) {
> -		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C1_RES, MSR_TYPE_R);
> -		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C3_RESIDENCY, MSR_TYPE_R);
> -		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C6_RESIDENCY, MSR_TYPE_R);
> -		vmx_disable_intercept_for_msr(vcpu, MSR_CORE_C7_RESIDENCY, MSR_TYPE_R);
> -	}
> -
>  	vmx->loaded_vmcs = &vmx->vmcs01;
>  
>  	if (cpu_need_virtualize_apic_accesses(vcpu)) {

-- 
Vitaly

