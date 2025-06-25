Return-Path: <kvm+bounces-50703-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 87CE4AE86EE
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 16:46:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 13700189E291
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 14:46:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9580826981E;
	Wed, 25 Jun 2025 14:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ovGoKcYh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532831D5CFB
	for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 14:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750862762; cv=none; b=rRnG4f17UynPN9Gy2+u535m81XAVacOv0kX6kgJ0LeCjoDU6QBXqTA3dU9SlcncJlEVfUZv8K/SRf6bp4FR3AMudG2inmor+No+/IzTv7+C26Yg1x9bd2yMuG8RKtz2p9k3GHZP6Y6dUZY9Sa6uwNlii6vsHhjbzGhtbJmIfNhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750862762; c=relaxed/simple;
	bh=yoF0KokkjotdOYrXmuA3qqpgQr4ybWAWolZ/EmYbBWI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=exnZAackHnLkXvOEGu7aVccu8SYbXTFKJQAaDUQcdfTEAVk4Brlx39Rv2GKXBoM+kPpyoF9fSuiugypd74WOZD82KAqfX69WFqQI6u2PeiED7ohmejrqybkAhrToBXZHcOBvqepD1mLUFKO37fWaulpKpYk2Mw+0toelf0jJMJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ovGoKcYh; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b34b810fdcaso405767a12.0
        for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 07:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750862760; x=1751467560; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8ICU5+XCoFVfw+pvlSIRLwAfwbdwsLkDlJRvVC647Yk=;
        b=ovGoKcYhVYWFXj6R9Wp0vvL3VaKBY2II7n+qcC/oNDHOkKQr+96+9gXzcLjbYBxDWl
         fST3y22pA8hEbfxe8EJklJDLvkl76y8MRvyD/rRtrYbaVvmn1jc+KlAj60msg6nydvqr
         AO8DoRtb94XAs0X4qDEyFcstuYTk1ovoNIIseuawIUhPGad8Zj6kvHnZdDPE+cPEKwRq
         9vqx5YtV5C3kMazKMpUr57tjZfbMUOO+bzacnoA/Tm0nSEfHdF8FaLgp5R/3AX4jyUvl
         oGyj66FEyKzr1DCuNT84SrSzznZUNwOJPY+1p5Dbl1EqBH1GeUGgbLVplakUOZfMGH4A
         z9Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750862760; x=1751467560;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8ICU5+XCoFVfw+pvlSIRLwAfwbdwsLkDlJRvVC647Yk=;
        b=Kq6UJeBoXG/htmWEWKW0waAbMeZ2jddjFO4YBBSdS9oTFRLW8XKvP+fz5uLdMvzIgw
         Cp2EGT3on7cI14jEJXBX2gXPfve/AEJvZpOGtxa8/1cP2DzYiboAa6CSbOVqcsd1TSKc
         Aa9XMRnnI/9bZ9zh2ZZOnUVGevwhrJUPu+0G3bH3s7bOXPlTLE/HLuxoREGuMAzgvFtn
         5WGW+k6phPLaU72UeGy9eExGWT8pp5HmgSVPaEangHi51IfQTNgpx9b7R26dH+UXyQaw
         +ocIA0tpXksTxsiUxPQg7tjdF44mxvTW5JZpx+iWFp2iJvOi6LHsRW5gIGfPrDaMRpip
         wvEw==
X-Forwarded-Encrypted: i=1; AJvYcCXgzaLqQYw+N8bHOzdJh6megqs6wYRSTpmaTGGew5OvExohTNwZv9c945kZMergoJ0hltI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/OsWSxgYcsKI24K3mUsUCEuaS/tJgvmI0haOqTM6Fn7HZ1MBY
	Yw2Wl2O1afYL4LVpvT0c7gcd6FyycO0KrCyOv4/P9AILH9GlqY8AeSmj3Dz260+A+jLYtxvYvt4
	/4a4YSg==
X-Google-Smtp-Source: AGHT+IFDMtdXk5SSPSuJ3EMb+V+kr/F+ajAZV1NFxOvALvKGnoBD5whHEelbGvIw9+H52XqJQYE63qTRlc0=
X-Received: from pjbqd16.prod.google.com ([2002:a17:90b:3cd0:b0:311:485b:d057])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1d91:b0:311:abba:53c0
 with SMTP id 98e67ed59e1d1-315f26137f1mr5585885a91.9.1750862760589; Wed, 25
 Jun 2025 07:46:00 -0700 (PDT)
Date: Wed, 25 Jun 2025 07:45:59 -0700
In-Reply-To: <20250514064941.51609-1-liuyuntao12@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250514064941.51609-1-liuyuntao12@huawei.com>
Message-ID: <aFwLpyDYOsHUtCn-@google.com>
Subject: Re: [PATCH] kvm: x86: fix infinite loop in kvm_guest_time_update when
 tsc is 0
From: Sean Christopherson <seanjc@google.com>
To: Yuntao Liu <liuyuntao12@huawei.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	bpf@vger.kernel.org, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com
Content-Type: text/plain; charset="us-ascii"

On Wed, May 14, 2025, Yuntao Liu wrote:
> Call Trace:
>  <TASK>
>  kvm_get_time_scale arch/x86/kvm/x86.c:2458 [inline]
>  kvm_guest_time_update+0x926/0xb00 arch/x86/kvm/x86.c:3268
>  vcpu_enter_guest.constprop.0+0x1e70/0x3cf0 arch/x86/kvm/x86.c:10678
>  vcpu_run+0x129/0x8d0 arch/x86/kvm/x86.c:11126
>  kvm_arch_vcpu_ioctl_run+0x37a/0x13d0 arch/x86/kvm/x86.c:11352
>  kvm_vcpu_ioctl+0x56b/0xe60 virt/kvm/kvm_main.c:4188
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:871 [inline]
>  __se_sys_ioctl+0x12d/0x190 fs/ioctl.c:857
>  do_syscall_x64 arch/x86/entry/common.c:51 [inline]
>  do_syscall_64+0x59/0x110 arch/x86/entry/common.c:81
>  entry_SYSCALL_64_after_hwframe+0x78/0xe2
> 
> ioctl$KVM_SET_TSC_KHZ(r2, 0xaea2, 0x1)
> user_tsc_khz = 0x1
> 	|
> kvm_set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz)
> 	|
> 	ioctl$KVM_RUN(r2, 0xae80, 0x0)
> 		|
> 		...
> 	kvm_guest_time_update(struct kvm_vcpu *v)
> 		|
> 		if (kvm_caps.has_tsc_control)
> 			tgt_tsc_khz = kvm_scale_tsc(tgt_tsc_khz,
> 					    v->arch.l1_tsc_scaling_ratio);
> 			|
> 			kvm_scale_tsc(u64 tsc, u64 ratio)
> 			|
> 			__scale_tsc(u64 ratio, u64 tsc)
> 			ratio=122380531, tsc=2299998, N=48
> 			ratio*tsc >> N = 0.999... -> 0
> 			|
> 		kvm_get_time_scale
> 
> In function __scale_tsc, it uses fixed point number to calculate
> tsc, therefore, a certain degree of precision is lost, the actual tsc
> value of 0.999... would be 0. In function kvm_get_time_scale
> tps32=tps64=base_hz=0, would lead second while_loop infinite. when
> CONFIG_PREEMPT is n, it causes a soft lockup issue.
> 
> Fixes: 35181e86df97 ("KVM: x86: Add a common TSC scaling function")
> Signed-off-by: Yuntao Liu <liuyuntao12@huawei.com>
> ---
>  arch/x86/kvm/x86.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 1fa5d89f8d27..3e9d6f368eed 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2605,10 +2605,14 @@ static void kvm_track_tsc_matching(struct kvm_vcpu *vcpu)
>   * point number (mult + frac * 2^(-N)).
>   *
>   * N equals to kvm_caps.tsc_scaling_ratio_frac_bits.
> + *
> + * return 1 if _tsc is 0.
>   */
>  static inline u64 __scale_tsc(u64 ratio, u64 tsc)
>  {
> -	return mul_u64_u64_shr(tsc, ratio, kvm_caps.tsc_scaling_ratio_frac_bits);
> +	u64 _tsc = mul_u64_u64_shr(tsc, ratio, kvm_caps.tsc_scaling_ratio_frac_bits);
> +
> +	return  !_tsc ? 1 : _tsc;

This can be

	return _tsc ? : 1;

However, I'm 99% certain this only affects kvm_guest_time_update(), because it's
the only code that scales a TSC *frequency*, versus scaling a TSC value.  Hmm,
kvm_x86_vendor_init() also scales a frequency, but the multiplier and shift are
KVM controlled, so that calculation can never be '0.

So I think just this for a fix?  Because in all other cases, a result of '0' is
totally fine, and arguably even more correct, e.g. when used in adjust_tsc_offset_host().

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b58a74c1722d..de51dbd85a58 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3258,9 +3258,11 @@ int kvm_guest_time_update(struct kvm_vcpu *v)
 
        /* With all the info we got, fill in the values */
 
-       if (kvm_caps.has_tsc_control)
+       if (kvm_caps.has_tsc_control) {
                tgt_tsc_khz = kvm_scale_tsc(tgt_tsc_khz,
                                            v->arch.l1_tsc_scaling_ratio);
+               tgt_tsc_khz = tgt_tsc_khz ? : 1;
+       }
 
        if (unlikely(vcpu->hw_tsc_khz != tgt_tsc_khz)) {
                kvm_get_time_scale(NSEC_PER_SEC, tgt_tsc_khz * 1000LL,

