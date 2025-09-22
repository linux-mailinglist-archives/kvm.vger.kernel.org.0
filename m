Return-Path: <kvm+bounces-58409-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C4B3B92A44
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 20:48:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E29517B3651
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 18:46:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8B3A31A07C;
	Mon, 22 Sep 2025 18:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ibykTrsi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62EB14315A
	for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 18:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758566868; cv=none; b=qb7wKN5uXTZyOUM8S92QnGTq4odN6o6HCj7yBHG0DQksrYfYV4T0AauNuWKiRM1QAWWxPBEv+YHzuwqbjuNmVLH5lTULKZItH/pyHlJDQZyZwA1E0ig3MpClB0O2UbMdJdxB03wh5r8EheTupR1MPWZ0Ot/nQmR+DPha2Mzv5Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758566868; c=relaxed/simple;
	bh=wbUDsEuejmM6LgX1Hj/KaKt6+BgZxwAmcKIRV/X+mqg=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=ZXOFC6cm2QyJ3jtXchM0Rhnes8vKkiAVrkY2fsrU941E8tXQHib4Og9E9BvuvUZ7X7Bz63DgI5Qads31Fl6/7JukYq69JdbvIaKYhNJ2cQuYGctnNzoYUNPcNsoXFsBDiS0tFozuwKbY0Qi9vo/JG5uC4RSGDe1WfmjZ0XCar+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ibykTrsi; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32eaeba9abaso6689714a91.3
        for <kvm@vger.kernel.org>; Mon, 22 Sep 2025 11:47:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758566867; x=1759171667; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K0UpDKhoRLh7dpDRy6uigY5bqnigEpXRuNEVRYUji54=;
        b=ibykTrsiEQ9g1/6kxHx/Q1acSJJXFaHcXOKCDaNqQLEiua1USuPlNhdKc40QEQcUzS
         o85tbF9F+kGzuV4Y90aeWKo+Y7QREladumcqLoaxiIRuOrBYyg/7/2Lc0Ry0q/5Xpj0z
         yWt6ilF6Pj7B0XiCN4239GwRgUd2zCM8J8+ATf70mNPgbvTKwAYV03A5UuH6bXCnzIfl
         F9a2bqMTJ5hp/BSw/lgs54rsT0cDYx5n8wsn6p/AqxHGOaN9r/O+xJ9bocZnRO74Z4CP
         ftt/+LK1na0WSOnck1cYRuIV6yKXkOr259pGENt35r2cHR5NlOikZzVh4Zqd4ow9hEiu
         Kgpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758566867; x=1759171667;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K0UpDKhoRLh7dpDRy6uigY5bqnigEpXRuNEVRYUji54=;
        b=TY1siy7PSxLJqt9b8J5o3yAxF3mSCcIiYsji7lQ0+yFUCGwfOxkg0C2HavSNeNIuGT
         ZAK6uZTo2mU8nMWS22ksBXk6JnLHqC6dQkxgxOoY5Kj1FaKXzFtLGxmWpxW2RBFYLnIR
         ZH9kivqcInx7lPF5ybqHAi+RP57u3ZneVvxzD+T7ZgmEeN1gqnEO4HuN2ASl9Jrgy/m4
         xkqyxs0595OElV7PSRlUgMPxM1/dNqwVMvcGKeVBPHvcr52HszEK/T/SSzBn0pkj+D7f
         c/383eOgM569BlaTZW7IMhv1usWVBOTolgnCcss8arhLMwBeEe8MVCHdukZOX7rFXgtC
         3KGQ==
X-Gm-Message-State: AOJu0YxJT/IZ/fvxQ+wz8ilux+oZqDE9OBXz37I9t54kbIpDd7C+VkuG
	WjiI9FLgkt6V2NGfGYYQITrDPoAQ7DtHzJQ8pCtLI1R6hQSrfq+GFoKmZPl8ReEjxx1S6+qHOlt
	Z50xzZw==
X-Google-Smtp-Source: AGHT+IEjlvdFs7P6ZUHLEhAT6cz3bcJ8IRMZO+Skz6MNKFJhZvvHWfyBM2xfHi4RsFjemOBmhymu89gdFCc=
X-Received: from pjbqn13.prod.google.com ([2002:a17:90b:3d4d:b0:31f:2a78:943])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5109:b0:32e:e18a:368c
 with SMTP id 98e67ed59e1d1-33097fdca4dmr15334777a91.7.1758566866504; Mon, 22
 Sep 2025 11:47:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 22 Sep 2025 11:47:43 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.534.gc79095c0ca-goog
Message-ID: <20250922184743.1745778-1-seanjc@google.com>
Subject: [PATCH (CET v16 26.5)] KVM: x86: Initialize allow_smaller_maxphyaddr
 earlier in setup
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Initialize allow_smaller_maxphyaddr during hardware setup as soon as KVM
knows whether or not TDP will be utilized.  To avoid having to teach KVM's
emulator all about CET, KVM's upcoming CET virtualization support will be
mutually exclusive with allow_smaller_maxphyaddr, i.e. will disable SHSTK
and IBT if allow_smaller_maxphyaddr is enabled.

In general, allow_smaller_maxphyaddr should be initialized as soon as
possible since it's globally visible while its only input is whether or
not EPT/NPT is enabled.  I.e. there's effectively zero risk of setting
allow_smaller_maxphyaddr too early, and substantial risk of setting it
too late.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---

As the subject suggests, I'm going to slot this in when applying the CET
series as this is a dependency for disabling SHSTK and IBT if
allow_smaller_maxphyaddr.  Without this, SVM will incorrectly clear (or not)
SHSTK.  VMX isn't affected because !enable_ept disables unrestricted guest,
which also clears SHSTK and IBT, but as the changelog calls out, there's no
reason to wait to initialize allow_smaller_maxphyaddr.

https://lore.kernel.org/all/20250919223258.1604852-28-seanjc@google.com

 arch/x86/kvm/svm/svm.c | 30 +++++++++++++++---------------
 arch/x86/kvm/vmx/vmx.c | 16 ++++++++--------
 2 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 54ca0ec5ea57..74a6e3868517 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5413,6 +5413,21 @@ static __init int svm_hardware_setup(void)
 			  get_npt_level(), PG_LEVEL_1G);
 	pr_info("Nested Paging %s\n", str_enabled_disabled(npt_enabled));
 
+	/*
+	 * It seems that on AMD processors PTE's accessed bit is
+	 * being set by the CPU hardware before the NPF vmexit.
+	 * This is not expected behaviour and our tests fail because
+	 * of it.
+	 * A workaround here is to disable support for
+	 * GUEST_MAXPHYADDR < HOST_MAXPHYADDR if NPT is enabled.
+	 * In this case userspace can know if there is support using
+	 * KVM_CAP_SMALLER_MAXPHYADDR extension and decide how to handle
+	 * it
+	 * If future AMD CPU models change the behaviour described above,
+	 * this variable can be changed accordingly
+	 */
+	allow_smaller_maxphyaddr = !npt_enabled;
+
 	/* Setup shadow_me_value and shadow_me_mask */
 	kvm_mmu_set_me_spte_mask(sme_me_mask, sme_me_mask);
 
@@ -5492,21 +5507,6 @@ static __init int svm_hardware_setup(void)
 
 	svm_set_cpu_caps();
 
-	/*
-	 * It seems that on AMD processors PTE's accessed bit is
-	 * being set by the CPU hardware before the NPF vmexit.
-	 * This is not expected behaviour and our tests fail because
-	 * of it.
-	 * A workaround here is to disable support for
-	 * GUEST_MAXPHYADDR < HOST_MAXPHYADDR if NPT is enabled.
-	 * In this case userspace can know if there is support using
-	 * KVM_CAP_SMALLER_MAXPHYADDR extension and decide how to handle
-	 * it
-	 * If future AMD CPU models change the behaviour described above,
-	 * this variable can be changed accordingly
-	 */
-	allow_smaller_maxphyaddr = !npt_enabled;
-
 	kvm_caps.inapplicable_quirks &= ~KVM_X86_QUIRK_CD_NW_CLEARED;
 	return 0;
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 509487a1f04a..ace8208fc1be 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8479,6 +8479,14 @@ __init int vmx_hardware_setup(void)
 		return -EOPNOTSUPP;
 	}
 
+	/*
+	 * Shadow paging doesn't have a (further) performance penalty
+	 * from GUEST_MAXPHYADDR < HOST_MAXPHYADDR so enable it
+	 * by default
+	 */
+	if (!enable_ept)
+		allow_smaller_maxphyaddr = true;
+
 	if (!cpu_has_vmx_ept_ad_bits() || !enable_ept)
 		enable_ept_ad_bits = 0;
 
@@ -8715,14 +8723,6 @@ int __init vmx_init(void)
 
 	vmx_check_vmcs12_offsets();
 
-	/*
-	 * Shadow paging doesn't have a (further) performance penalty
-	 * from GUEST_MAXPHYADDR < HOST_MAXPHYADDR so enable it
-	 * by default
-	 */
-	if (!enable_ept)
-		allow_smaller_maxphyaddr = true;
-
 	return 0;
 
 err_l1d_flush:

base-commit: d44fa096b63659f2398a28f24d99e48c23857c82
-- 
2.51.0.534.gc79095c0ca-goog


