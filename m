Return-Path: <kvm+bounces-40339-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8144A56B0E
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 16:02:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7AAD8177B17
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 15:02:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 954EE21C187;
	Fri,  7 Mar 2025 15:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FsUHngrx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D3C82E3361
	for <kvm@vger.kernel.org>; Fri,  7 Mar 2025 15:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741359763; cv=none; b=jO7lTr+kUjxExm4iuleEwGRbk+oZCXsqqID4Iujd+0vFQUfNhR2fOm1Wp4BgW++DLhJEx2eNeBe0qD+Z5tZcD+c76jjHUoBvldbXNGOU3NqAKp8P6KEIH3JogAsY8hK2VQBeumU4qgl8xTaFR7kSc8tC3Tiejio5U8m6+mnpRXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741359763; c=relaxed/simple;
	bh=/CqtL46hs9Sn9XtjnQtnzpwEcuZGxBycCOlQy6JckL8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qqDigG6bjtHnaTRGmzvlL5GCiGfSXFI0vvfHUFqJk4RlZDSC/Kz6Ys79SLn77qx00KW2DrjOjpLawPeSzTRZPmHCUpRetW+JcbqunHJyC8OOc3mHBFGnJNeYTJQeiFHS0t0fRJ5lWk5d1t4zWXEwDm7pVmbZzdbMdJVrovuYdBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FsUHngrx; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ff4b130bb2so3446775a91.0
        for <kvm@vger.kernel.org>; Fri, 07 Mar 2025 07:02:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741359761; x=1741964561; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8p9/fq/nM+pr2NlVgvqJ7GCWcpETpYSDd5iEoMo788I=;
        b=FsUHngrxXCywmDSJa9hL/9zsqQo5AjsoYN9LuBW053qYTzLkTK8CW+8H6r1pvVR7S5
         jQhFyzpkDw/xaxXrCqXuMwp/jOCq4G9lrshZ8Kaths7MMPTIBt/o9wDspWW11/Ryucxk
         BiREI5x/QN6TWI+289OCY/ETO6TYJxHR5o+ZfkSB8ubEqWL0wa4L3dI9iKdnHZmgic0v
         kJ3Tl2faU3Dz4G0c/8P5+i5oNzHqo2qPC25Kl0I2oBZbuDK2jcR1JM0ENjOwBs/BIkP3
         Ya/lVzXWiwpq6eNUdYHyip6oxX6ER35x6YiFse6OMs971c436Vnrl84CLpN14L9wbmZ6
         OPRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741359761; x=1741964561;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8p9/fq/nM+pr2NlVgvqJ7GCWcpETpYSDd5iEoMo788I=;
        b=I/l/nhTYgr4ap0/cbeiHsQ97BC3dFCK8DzkDaBF7cWuwshconVQKl/1Sc4pInpk+xJ
         h486MRFiOJT4wGOych4PXiN3Q+9qy8enBojh2iI6nrNWGmSCRpC/WeUwfuo8voTQx0uW
         tR/P+bimn5A88Da1jIUkgMIhzn1Zr2zayKMAlCWj65FkGInNzpHreJqMRft26RCcPCVB
         btF3ohO2bTtxcR0z8+MklLuCbsAK5OEj6cIlZg9i0W1oLLisqAwa3Nclj8YhyqSz0bKW
         4rMun+TQYgbdV4CYxKmcB2y68zyxrFqsdCFUgQ3jQ7GbcLytdL5MYcVZ/Vcj/PTQExf/
         w1TA==
X-Gm-Message-State: AOJu0YwJuqIuVjPeCvGNZfF7ypD+evjQaAdb4KqjkBgSVIUSdnaxrf5f
	bMlGHFGTzpaxPOx/pv5oGBaOu/fP6wVE29DBA5QYrc1woSs7YqkwZmRNQA3rTyeEA4T17ziPisZ
	A6g==
X-Google-Smtp-Source: AGHT+IGVQ4cg/Vi/nSKbSvruTswaX4BW6St/JWA/Tpijs0lJZx0Aae/mTyaI4ditO9P+2u0QbEdPJNvO1OU=
X-Received: from pjbqn14.prod.google.com ([2002:a17:90b:3d4e:b0:2ea:9d23:79a0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d605:b0:2ee:db8a:2a01
 with SMTP id 98e67ed59e1d1-2ff7cf128cdmr5320710a91.30.1741359761542; Fri, 07
 Mar 2025 07:02:41 -0800 (PST)
Date: Fri, 7 Mar 2025 07:02:36 -0800
In-Reply-To: <44961459-2759-4164-b604-f6bd43da8ce9@stanley.mountain>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <44961459-2759-4164-b604-f6bd43da8ce9@stanley.mountain>
Message-ID: <Z8sKjFrSJVLsLbQw@google.com>
Subject: Re: [bug report] KVM: VMX: Use GPA legality helpers to replace open
 coded equivalents
From: Sean Christopherson <seanjc@google.com>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, Mar 07, 2025, Dan Carpenter wrote:
> Hello Sean Christopherson,
> 
> Commit 636e8b733491 ("KVM: VMX: Use GPA legality helpers to replace
> open coded equivalents") from Feb 3, 2021 (linux-next), leads to the
> following Smatch static checker warning:
> 
> 	arch/x86/kvm/vmx/nested.c:834 nested_vmx_check_msr_switch()
> 	warn: potential user controlled sizeof overflow 'addr + count * 16' '0-u64max + 16-68719476720'
> 
> arch/x86/kvm/vmx/nested.c
>     827 static int nested_vmx_check_msr_switch(struct kvm_vcpu *vcpu,
>     828                                        u32 count, u64 addr)
>     829 {
>     830         if (count == 0)
>     831                 return 0;
>     832 
>     833         if (!kvm_vcpu_is_legal_aligned_gpa(vcpu, addr, 16) ||
> --> 834             !kvm_vcpu_is_legal_gpa(vcpu, (addr + count * sizeof(struct vmx_msr_entry) - 1)))
>                                                          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> Do we support kvm on 32bit systems?

"Support" might be a bit of a strong word, but yes, KVM is supposed to work on
32-bit systems.  Even if we ignore 32-bit, not explicitly checking the count is
silly.  There's an explicit limit on @count, and it's architecturally capped at
4096.  I suspect the only reason KVM doesn't check it here is because exceeding
the limit isn't listed in the SDM as consitency check.

But the SDM does say that exceeding the limit results in undefined behavior,
"(including a machine check during the VMX transition)".  I.e. KVM can quite
literally do whatever it wants.  And KVM does check the limit later on.

I can't think of any ordering weirdness that would result in an early check, so
assuming testing comes through clean, I'll post this:

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index d06e50d9c0e7..64ea387a14a1 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -824,12 +824,30 @@ static int nested_vmx_check_apicv_controls(struct kvm_vcpu *vcpu,
        return 0;
 }
 
+static u32 nested_vmx_max_atomic_switch_msrs(struct kvm_vcpu *vcpu)
+{
+       struct vcpu_vmx *vmx = to_vmx(vcpu);
+       u64 vmx_misc = vmx_control_msr(vmx->nested.msrs.misc_low,
+                                      vmx->nested.msrs.misc_high);
+
+       return (vmx_misc_max_msr(vmx_misc) + 1) * VMX_MISC_MSR_LIST_MULTIPLIER;
+}
+
 static int nested_vmx_check_msr_switch(struct kvm_vcpu *vcpu,
                                       u32 count, u64 addr)
 {
        if (count == 0)
                return 0;
 
+       /*
+        * Exceeding the limit results in architecturally _undefined_ behavior,
+        * i.e. KVM is allowed to do literally anything in response to a bad
+        * limit.  Immediately generate a consistency check so that code that
+        * consumes the count doesn't need to worry about extreme edge cases.
+        */
+       if (count > nested_vmx_max_atomic_switch_msrs(vcpu))
+               return -EINVAL;
+
        if (!kvm_vcpu_is_legal_aligned_gpa(vcpu, addr, 16) ||
            !kvm_vcpu_is_legal_gpa(vcpu, (addr + count * sizeof(struct vmx_msr_entry) - 1)))
                return -EINVAL;
@@ -940,15 +958,6 @@ static int nested_vmx_store_msr_check(struct kvm_vcpu *vcpu,
        return 0;
 }
 
-static u32 nested_vmx_max_atomic_switch_msrs(struct kvm_vcpu *vcpu)
-{
-       struct vcpu_vmx *vmx = to_vmx(vcpu);
-       u64 vmx_misc = vmx_control_msr(vmx->nested.msrs.misc_low,
-                                      vmx->nested.msrs.misc_high);
-
-       return (vmx_misc_max_msr(vmx_misc) + 1) * VMX_MISC_MSR_LIST_MULTIPLIER;
-}
-
 /*
  * Load guest's/host's msr at nested entry/exit.
  * return 0 for success, entry index for failure.
@@ -965,7 +974,7 @@ static u32 nested_vmx_load_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
        u32 max_msr_list_size = nested_vmx_max_atomic_switch_msrs(vcpu);
 
        for (i = 0; i < count; i++) {
-               if (unlikely(i >= max_msr_list_size))
+               if (WARN_ON_ONCE(i >= max_msr_list_size))
                        goto fail;
 
                if (kvm_vcpu_read_guest(vcpu, gpa + i * sizeof(e),
@@ -1053,7 +1062,7 @@ static int nested_vmx_store_msr(struct kvm_vcpu *vcpu, u64 gpa, u32 count)
        u32 max_msr_list_size = nested_vmx_max_atomic_switch_msrs(vcpu);
 
        for (i = 0; i < count; i++) {
-               if (unlikely(i >= max_msr_list_size))
+               if (WARN_ON_ONCE(i >= max_msr_list_size))
                        return -EINVAL;
 
                if (!read_and_check_msr_entry(vcpu, gpa, i, &e))


