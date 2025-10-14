Return-Path: <kvm+bounces-60041-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C0CE5BDBB53
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 00:49:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0A43619A3080
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 22:50:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF59429293D;
	Tue, 14 Oct 2025 22:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K14Eq+QG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4E41E8836
	for <kvm@vger.kernel.org>; Tue, 14 Oct 2025 22:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760482185; cv=none; b=d8N282vpQHQOqQU48HZD2orB/KdGXlBUjx7Bqe4FhBgIUV7cQCenH+wTdo1mOXvw5IzNQfxbTcsga9IyIuI98G3utdV3gF/gSUIqKedx7CqvbA+TKUkJyKkLPqlbjHq9qo3TfcQSDBS8JeIajUp6XYzfdJi0aeQIcccY3R0oUdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760482185; c=relaxed/simple;
	bh=l7oLK6K7nVP3KFQ8+Qhz3JAhHUG/60YiiDorbErzqzQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Kwdh1QyMRehexgGFKplDSlj8TncUaRdTl8/iB5t3DodH7f8hH8ca8YoEbxirXrFDSPrMTpoyhxwhfDbjfjaGcrhIQhmtEQ81EZbQ18/QNMbL5SuD93jS7pQ/ItHotPod2tF9iwxUrOhfCSn9eNT5zfL6wkYI5TB+MyDYO3UDoZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K14Eq+QG; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-336b9f3b5b0so12143983a91.3
        for <kvm@vger.kernel.org>; Tue, 14 Oct 2025 15:49:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760482183; x=1761086983; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ibw0a+sRCVl9lCeWax6uOrqnVBa3D7p+tT7NohAIR4E=;
        b=K14Eq+QGZb+0N7iaU8bFC5GbFKennfrCxZfBpagnwVhPE6kkDWw2eZn2lh6SH45Ps2
         vyi6UFlzMFiyBvWuMIhzgiDdVMoecbCAhA0CJAXQLq/h6LQxDPMIs+3HOcsR9tuV1lmB
         49VKkfU4t0gRxawJGl/aUkErfdplcAXB6ytveceIK53mIGWmH6jr9Ozx3zNcB0R1cnMN
         C2UxbMHFotD8L9gA2E4XAqlBsxW+mCsraIXjVwLtsFFLpyMiTVtsrvqgkcy6/cEyyRxl
         Js4FO3FFVQJwSidlChSxvGZj2K7GtOGsuvMpLbAxpRoiN2rtq/+XiYjdDmZo6Zr4bw5N
         a3xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760482183; x=1761086983;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ibw0a+sRCVl9lCeWax6uOrqnVBa3D7p+tT7NohAIR4E=;
        b=W8JLLUB5oBowpD44FpcH8o/PY695bTZKUB56BkoZjETeIth1zr+FLZMtD70OUdXYPF
         HpQnJXdR4x5AddXA7ivYmzK31/70oF9O1zVX/vVm5Y2/oR65rvIfTXShRrcUAAUeHlT7
         xGApkeYCbgoTrrW5yF2QiO6Bmg6NwiSKF2+D5mnf+sJE1MZcaGmQOTySmexrGS+tNk0i
         b/cPArR/zNeI8nZlIBX6506SPJtB/O7kUkwwRCtsgXCV2k3/Yp8D91cRJs3up2DKGDDM
         OSqi+mwhIkN1542aXCBUVJPMvCQ4m/rPuLStxzCbS2kLvNt/EhYefyMHI2A/g/hocVGy
         EXpw==
X-Forwarded-Encrypted: i=1; AJvYcCVTk9coCNrlKO52cZIESZZe28sAKowo7h77a21pFY1sBqHLk1LCsM/MqhHN5t0pevFvYuA=@vger.kernel.org
X-Gm-Message-State: AOJu0YylWlX4nANNUo80H34GfgoOBdO2IsKZzCW1wp28gSlaraXrUcH6
	dDdFNH+s0SvK0eM2u14STU2vhX8bV+g36tge6oKxuhRkzxWDPqHjalFT7pBMX7Zc7FczqJOnCGc
	WxO5dcQ==
X-Google-Smtp-Source: AGHT+IG8ojWX/Jkelgg3C2Xp3708DzuStRitbTym8FNSNsELY4jlwlAX6BXVVeLPBUmfvW2nUlpsjaL6dVw=
X-Received: from pjwd6.prod.google.com ([2002:a17:90a:d3c6:b0:32e:e06a:4668])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1e10:b0:336:b563:993a
 with SMTP id 98e67ed59e1d1-33b513b3554mr38386547a91.23.1760482182739; Tue, 14
 Oct 2025 15:49:42 -0700 (PDT)
Date: Tue, 14 Oct 2025 15:49:41 -0700
In-Reply-To: <20251001001529.1119031-2-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251001001529.1119031-1-jmattson@google.com> <20251001001529.1119031-2-jmattson@google.com>
Message-ID: <aO7ThZJtciBPciRj@google.com>
Subject: Re: [PATCH v2 1/2] KVM: x86: Advertise EferLmsleUnsupported to userspace
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Perry Yuan <perry.yuan@amd.com>, Sohil Mehta <sohil.mehta@intel.com>, 
	"Xin Li (Intel)" <xin@zytor.com>, Joerg Roedel <joerg.roedel@amd.com>, Avi Kivity <avi@redhat.com>, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Yosry Ahmed <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="us-ascii"

On Tue, Sep 30, 2025, Jim Mattson wrote:
> CPUID.80000008H:EBX.EferLmsleUnsupported[bit 20] is a defeature
> bit. When this bit is clear, EFER.LMSLE is supported. When this bit is
> set, EFER.LMLSE is unsupported. KVM has never supported EFER.LMSLE, so
> it cannot support a 0-setting of this bit.
> 
> Pass through the bit in KVM_GET_SUPPORTED_CPUID to advertise the
> unavailability of EFER.LMSLE to userspace.

This really needs to capture the discussion/context from v1.  Without that,
saying the KVM "has never supported" LMSLE and then _partially_ disabling LSMLE
is all kinds of confusing.

> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  v1 -> v2:
>    Pass through the bit from hardware, rather than forcing it to be set.
> 
>  arch/x86/include/asm/cpufeatures.h | 1 +
>  arch/x86/kvm/cpuid.c               | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 751ca35386b0..f9b593721917 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -338,6 +338,7 @@
>  #define X86_FEATURE_AMD_STIBP		(13*32+15) /* Single Thread Indirect Branch Predictors */
>  #define X86_FEATURE_AMD_STIBP_ALWAYS_ON	(13*32+17) /* Single Thread Indirect Branch Predictors always-on preferred */
>  #define X86_FEATURE_AMD_IBRS_SAME_MODE	(13*32+19) /* Indirect Branch Restricted Speculation same mode protection*/
> +#define X86_FEATURE_EFER_LMSLE_MBZ	(13*32+20) /* EFER.LMSLE must be zero */
>  #define X86_FEATURE_AMD_PPIN		(13*32+23) /* "amd_ppin" Protected Processor Inventory Number */
>  #define X86_FEATURE_AMD_SSBD		(13*32+24) /* Speculative Store Bypass Disable */
>  #define X86_FEATURE_VIRT_SSBD		(13*32+25) /* "virt_ssbd" Virtualized Speculative Store Bypass Disable */
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index e2836a255b16..4823970611fd 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1096,6 +1096,7 @@ void kvm_set_cpu_caps(void)
>  		F(AMD_STIBP),
>  		F(AMD_STIBP_ALWAYS_ON),
>  		F(AMD_IBRS_SAME_MODE),
> +		F(EFER_LMSLE_MBZ),

Do we want to make this PASSTHROUGH_F()?  I.e. explicitly ignore any host
manipulations of CPUID state?  I can't imagine the kernel would ever clear the
bit, but I also don't see any downside to being paranoid.

This is what I have locally and will apply unless someone objects.

---
From: Jim Mattson <jmattson@google.com>
Date: Tue, 30 Sep 2025 17:14:07 -0700
Subject: [PATCH] KVM: x86: Advertise EferLmsleUnsupported to userspace

CPUID.80000008H:EBX.EferLmsleUnsupported[bit 20] is a defeature
bit. When this bit is clear, EFER.LMSLE is supported. When this bit is
set, EFER.LMLSE is unsupported. KVM has never _emulated_ EFER.LMSLE, so
KVM cannot truly support a 0-setting of this bit.

However, KVM has allowed the guest to enable EFER.LMSLE in hardware
since commit eec4b140c924 ("KVM: SVM: Allow EFER.LMSLE to be set with
nested svm"), i.e. KVM partially virtualizes long-mode segment limits _if_
they are supported by the underlying hardware.

Pass through the bit in KVM_GET_SUPPORTED_CPUID to advertise the
unavailability of EFER.LMSLE to userspace based on the raw underlying
hardware.  Attempting to enable EFER.LSMLE on such CPUs simply doesn't
work, e.g. immediately crashes on VMRUN.

Signed-off-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Nikunj A Dadhania <nikunj@amd.com>
Reviewed-by: Yosry Ahmed <yosry.ahmed@linux.dev>
Link: https://lore.kernel.org/r/20251001001529.1119031-2-jmattson@google.com
[sean: add context about partial virtualization, use PASSTHROUGH_F]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kvm/cpuid.c               | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 4091a776e37a..6bdf868c8f8e 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -338,6 +338,7 @@
 #define X86_FEATURE_AMD_STIBP		(13*32+15) /* Single Thread Indirect Branch Predictors */
 #define X86_FEATURE_AMD_STIBP_ALWAYS_ON	(13*32+17) /* Single Thread Indirect Branch Predictors always-on preferred */
 #define X86_FEATURE_AMD_IBRS_SAME_MODE	(13*32+19) /* Indirect Branch Restricted Speculation same mode protection*/
+#define X86_FEATURE_EFER_LMSLE_MBZ	(13*32+20) /* EFER.LMSLE must be zero */
 #define X86_FEATURE_AMD_PPIN		(13*32+23) /* "amd_ppin" Protected Processor Inventory Number */
 #define X86_FEATURE_AMD_SSBD		(13*32+24) /* Speculative Store Bypass Disable */
 #define X86_FEATURE_VIRT_SSBD		(13*32+25) /* "virt_ssbd" Virtualized Speculative Store Bypass Disable */
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 52524e0ca97f..d563a948318b 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1135,6 +1135,7 @@ void kvm_set_cpu_caps(void)
 		F(AMD_STIBP),
 		F(AMD_STIBP_ALWAYS_ON),
 		F(AMD_IBRS_SAME_MODE),
+		PASSTHROUGH_F(EFER_LMSLE_MBZ),
 		F(AMD_PSFD),
 		F(AMD_IBPB_RET),
 	);

base-commit: 7c8b465a1c91f674655ea9cec5083744ec5f796a
--

