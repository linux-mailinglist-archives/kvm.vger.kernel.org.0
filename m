Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F207916A98D
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 16:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727691AbgBXPPC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 10:15:02 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34369 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727299AbgBXPPC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 10:15:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582557301;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jg+g+BXJiV7d1uJkYnBUd3r7wI4Gy8xbFcG43fhnWLQ=;
        b=MjPCk1YENRpelnTFujXrQQP/Nxamn1m9M0G4fjI7nRPS/bC4ws3hhKAi+dY/ZMCYanLbli
        F8iLUh4ZeUY7ADqSjww1ofXfN96qVxC1WD+qnaQAJMCkxceDuGTzkGo2mfwqK+2MfmKs1z
        EDKtLsv8X2by2YFrxgTBDLn0fcsJ5+k=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-33-tZeqMcJUMy6xL08vdXN5XQ-1; Mon, 24 Feb 2020 10:14:59 -0500
X-MC-Unique: tZeqMcJUMy6xL08vdXN5XQ-1
Received: by mail-wr1-f70.google.com with SMTP id t3so3956660wrp.2
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2020 07:14:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=jg+g+BXJiV7d1uJkYnBUd3r7wI4Gy8xbFcG43fhnWLQ=;
        b=Wk9mX00hz6LqsdhuJzObn4ku+uR0L8HW123xHiRG/5NNav07qgTVWu2hxGlft8H1oi
         VxO+WeExQclzQQkot0qOWtu3OL07Z+Eauyoo0AusBX3c48Ld/izfiP6xbWxNfTwmvDI3
         feo0DCsvBfIw8gXF34QXWvFDIQfunvOWGkeBFdb2Wv7lIeL2ktz6kAE/pgfqW3/f/1LF
         DL5XxlmseY4QId90SjXRLPOgtu7RbhyA7oLCSCk4D3wzxj8c+qWGHHoeCmjJ+w85qsgd
         J36HUY/LVqqL4k9/+LyHy8pr5HwI6pnwrVF9/rhze1wCrX4SK8lBkBAKabY8MiPpbv9T
         axLg==
X-Gm-Message-State: APjAAAXiWQ+X10M+zlST8VSmMjGUjeO4Wb9AaWwdjTAUTc6USoWlbo6G
        6AyPEZ5kUccwiogcNFoQ8pMG2nEMV5WR+3epXs0wa53cIF2Y7OhhRfxbEdSErCRSKVilCpUp4WR
        j0zlK3iI0AUvc
X-Received: by 2002:a7b:cd8e:: with SMTP id y14mr22903083wmj.150.1582557298488;
        Mon, 24 Feb 2020 07:14:58 -0800 (PST)
X-Google-Smtp-Source: APXvYqx32jEI8eqwdcHOq9gcGNlIOblbxYGYoKXK2wgkEIbGrTKfs/u12V+bccJRiGIWo+p7euzzaQ==
X-Received: by 2002:a7b:cd8e:: with SMTP id y14mr22903065wmj.150.1582557298259;
        Mon, 24 Feb 2020 07:14:58 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id y8sm18017619wma.10.2020.02.24.07.14.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 07:14:57 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 30/61] KVM: x86: Handle MPX CPUID adjustment in VMX code
In-Reply-To: <20200201185218.24473-31-sean.j.christopherson@intel.com>
References: <20200201185218.24473-1-sean.j.christopherson@intel.com> <20200201185218.24473-31-sean.j.christopherson@intel.com>
Date:   Mon, 24 Feb 2020 16:14:56 +0100
Message-ID: <874kvgow3z.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Move the MPX CPUID adjustments into VMX to eliminate an instance of the
> undesirable "unsigned f_* = *_supported ? F(*) : 0" pattern in the
> common CPUID handling code.
>
> Note, VMX must manually check for kernel support via
> boot_cpu_has(X86_FEATURE_MPX).
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/cpuid.c   |  3 +--
>  arch/x86/kvm/vmx/vmx.c | 14 ++++++++++++--
>  2 files changed, 13 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index cb5870a323cc..09e24d1d731c 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -340,7 +340,6 @@ static int __do_cpuid_func_emulated(struct kvm_cpuid_array *array, u32 func)
>  static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry)
>  {
>  	unsigned f_invpcid = kvm_x86_ops->invpcid_supported() ? F(INVPCID) : 0;
> -	unsigned f_mpx = kvm_mpx_supported() ? F(MPX) : 0;
>  	unsigned f_umip = kvm_x86_ops->umip_emulated() ? F(UMIP) : 0;
>  	unsigned f_intel_pt = kvm_x86_ops->pt_supported() ? F(INTEL_PT) : 0;
>  	unsigned f_la57;
> @@ -349,7 +348,7 @@ static inline void do_cpuid_7_mask(struct kvm_cpuid_entry2 *entry)
>  	/* cpuid 7.0.ebx */
>  	const u32 kvm_cpuid_7_0_ebx_x86_features =
>  		F(FSGSBASE) | F(BMI1) | F(HLE) | F(AVX2) | F(SMEP) |
> -		F(BMI2) | F(ERMS) | f_invpcid | F(RTM) | f_mpx | F(RDSEED) |
> +		F(BMI2) | F(ERMS) | f_invpcid | F(RTM) | 0 /*MPX*/ | F(RDSEED) |
>  		F(ADX) | F(SMAP) | F(AVX512IFMA) | F(AVX512F) | F(AVX512PF) |
>  		F(AVX512ER) | F(AVX512CD) | F(CLFLUSHOPT) | F(CLWB) | F(AVX512DQ) |
>  		F(SHA_NI) | F(AVX512BW) | F(AVX512VL) | f_intel_pt;
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 3ff830e2258e..143193fc178e 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7106,8 +7106,18 @@ static void vmx_cpuid_update(struct kvm_vcpu *vcpu)
>  
>  static void vmx_set_supported_cpuid(struct kvm_cpuid_entry2 *entry)
>  {
> -	if (entry->function == 1 && nested)
> -		entry->ecx |= feature_bit(VMX);
> +	switch (entry->function) {
> +	case 0x1:
> +		if (nested)
> +			cpuid_entry_set(entry, X86_FEATURE_VMX);
> +		break;
> +	case 0x7:
> +		if (boot_cpu_has(X86_FEATURE_MPX) && kvm_mpx_supported())
> +			cpuid_entry_set(entry, X86_FEATURE_MPX);
> +		break;
> +	default:
> +		break;
> +	}
>  }
>  
>  static void vmx_request_immediate_exit(struct kvm_vcpu *vcpu)

The word 'must' in the description seems to work like a trigger for
reviewers, their brains automatically turn into 'and what if not?' mode
:-)

So do I understand correctly that kvm_mpx_supported() (which checks for
XFEATURE_MASK_BNDREGS/XFEATURE_MASK_BNDCSR) may actually return true
while 'boot_cpu_has(X86_FEATURE_MPX)' is false? Is this done on purpose,
i.e. why don't we filter these out from vmcs_config early, similar to
SVM?

The patch itself looks good, so
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

