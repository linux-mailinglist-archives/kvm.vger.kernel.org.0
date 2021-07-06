Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADB63BD89B
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 16:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232311AbhGFOpM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 10:45:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20031 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232895AbhGFOpD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 10:45:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625582543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ViCBW+aU4HmX1q30hpE32yx0uxbzc7hky1uZJpH6cmY=;
        b=TDNIJajozK27q8hSCYlmkPyQ2v09Ccu1QaM8Jg/p4HggR5ttk1lwCJ993Scvsd/1na6XJL
        CHs6LyxWdPN8V1rvvVyUDPS+Zn44OFr0T4GMr5ENNoYA/+07YV7iXH7FPoUJLpYwV/tZs7
        VqStFeZrfaKqOlVV+DE2dcc73ExDAw0=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-351-ddYcD6JSM1CNaLB1Fmjx9A-1; Tue, 06 Jul 2021 10:42:22 -0400
X-MC-Unique: ddYcD6JSM1CNaLB1Fmjx9A-1
Received: by mail-ej1-f69.google.com with SMTP id 16-20020a1709063010b029037417ca2d43so5902483ejz.5
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 07:42:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ViCBW+aU4HmX1q30hpE32yx0uxbzc7hky1uZJpH6cmY=;
        b=HL5rRSwQHTCEslokLG0/31a3slCGujJcInUy8t6gv7rtsho3LOwWVzbbMaGmiV5cpu
         vMpEKL5p0AfLuNOhzOElYI3YIJC+47ZQXf+b6PpH9SfjwriLVG421as6e9CIm+z1TmcR
         h50I5Y0yhe7T8rY/60MvdNuf3PvkhFFsxW73gOYwgLdrVrT/JvklLLFUj1CpwbX+U0mW
         bvkme1VdNuFB1pDL3/BH2to/NQCHoED22PItDhh7Z4TfJXuH3Wb26znv0JsdhVuM4UJ7
         LbZk4GzPN0ir5QoypRtzmNspA0VZDM/Ft0/dTAStJThdk4ehLdPw4hS9sSaHinHu+FF0
         Tjkg==
X-Gm-Message-State: AOAM531L6vKSzS3x1fukdsDM56XTLB5aGxHqr8syds/yOtoM4aLE9F1T
        hspUPP08GcMDlHJJwnt75AKbSrPM4ZfML1FPqvFJeKnEsSrQRuv1sZ3qEU28pmdN21qvbNiVyEu
        m9jpGry7rix2P
X-Received: by 2002:a17:907:72c9:: with SMTP id du9mr4054657ejc.497.1625582215084;
        Tue, 06 Jul 2021 07:36:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyzSGNDTuDB2nTgFFg1Qz93NY7KXXLlEt7e7B/RxiR9gDpBYM1jY+L1YBkDn5cKQmZvz3QLMQ==
X-Received: by 2002:a17:907:72c9:: with SMTP id du9mr4054632ejc.497.1625582214843;
        Tue, 06 Jul 2021 07:36:54 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id op26sm5117107ejb.57.2021.07.06.07.36.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 07:36:54 -0700 (PDT)
Subject: Re: [RFC PATCH v2 36/69] KVM: x86: Add a switch_db_regs flag to
 handle TDX's auto-switched behavior
To:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Chao Gao <chao.gao@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <1f79ce2ad686f25767711ccd6a520324dd6e1c21.1625186503.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8fd6118a-6804-4a58-138f-0c78855cc32a@redhat.com>
Date:   Tue, 6 Jul 2021 16:36:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1f79ce2ad686f25767711ccd6a520324dd6e1c21.1625186503.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/21 00:04, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Add a flag, KVM_DEBUGREG_AUTO_SWITCHED_GUEST, to skip saving/restoring DRs
> irrespective of any other flags.  TDX-SEAM unconditionally saves and
> restores guest DRs and reset to architectural INIT state on TD exit.
> So, KVM needs to save host DRs before TD enter without restoring guest DRs
> and restore host DRs after TD exit.
> 
> Opportunistically convert the KVM_DEBUGREG_* definitions to use BIT().
> 
> Reported-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Co-developed-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/include/asm/kvm_host.h | 11 ++++++++---
>   arch/x86/kvm/x86.c              |  3 ++-
>   2 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 96e6cd95d884..7822b531a5e2 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -488,9 +488,14 @@ struct kvm_pmu {
>   struct kvm_pmu_ops;
>   
>   enum {
> -	KVM_DEBUGREG_BP_ENABLED = 1,
> -	KVM_DEBUGREG_WONT_EXIT = 2,
> -	KVM_DEBUGREG_RELOAD = 4,
> +	KVM_DEBUGREG_BP_ENABLED		= BIT(0),
> +	KVM_DEBUGREG_WONT_EXIT		= BIT(1),
> +	KVM_DEBUGREG_RELOAD		= BIT(2),
> +	/*
> +	 * Guest debug registers are saved/restored by hardware on exit from
> +	 * or enter guest. KVM needn't switch them.
> +	 */
> +	KVM_DEBUGREG_AUTO_SWITCH_GUEST	= BIT(3),

Maybe remove "_GUEST"?  Apart from that,

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo

>   };
>   
>   struct kvm_mtrr_range {
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4b436cae1732..f1d5e0a53640 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9441,7 +9441,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>   	if (test_thread_flag(TIF_NEED_FPU_LOAD))
>   		switch_fpu_return();
>   
> -	if (unlikely(vcpu->arch.switch_db_regs)) {
> +	if (unlikely(vcpu->arch.switch_db_regs & ~KVM_DEBUGREG_AUTO_SWITCH_GUEST)) {
>   		set_debugreg(0, 7);
>   		set_debugreg(vcpu->arch.eff_db[0], 0);
>   		set_debugreg(vcpu->arch.eff_db[1], 1);
> @@ -9473,6 +9473,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
>   	 */
>   	if (unlikely(vcpu->arch.switch_db_regs & KVM_DEBUGREG_WONT_EXIT)) {
>   		WARN_ON(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP);
> +		WARN_ON(vcpu->arch.switch_db_regs & KVM_DEBUGREG_AUTO_SWITCH_GUEST);
>   		static_call(kvm_x86_sync_dirty_debug_regs)(vcpu);
>   		kvm_update_dr0123(vcpu);
>   		kvm_update_dr7(vcpu);
> 

