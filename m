Return-Path: <kvm+bounces-19613-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CE5D4907C4D
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 21:19:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 64942287AA6
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2024 19:19:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE9DD156886;
	Thu, 13 Jun 2024 19:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oAZM3koF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67944156872
	for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 19:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718306249; cv=none; b=qDDw6fTr+ISFAbvu/tnJ1KcjKEcs4jjld4Duuq5z7GNz/zFRo4zxPv0te1eEEpdEm9VkkaPL0RhmEtWLOkpeX6/x4Fl5btfR/7E6n+szZjpVLxMOe1YcdjWXXODLsTs7Q/z4aCexjre+C67zEqCp7HRKkn6hDWcCZYGft1pLLuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718306249; c=relaxed/simple;
	bh=WK0O8EnFbOwkpXmWKUkM/27ZG7npYR+IRP8iuvWgRXE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WFidc9j2DKFZn6KFiANUYPDJh7/MKd+qUpOBYMK1u4X9T+tOUyI3FuZxH+6ixIqSYPGImCfe/YT5irG3fJMTl4rFVZHTPTjVDtNNEt/sZ8AQCDFOKgzuax7i759o66eou1xScyupaq+QSRa6fHiHhyWxHe+M9bQ/i6zfNWvbfiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oAZM3koF; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-70428cb18c3so1208208b3a.0
        for <kvm@vger.kernel.org>; Thu, 13 Jun 2024 12:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718306247; x=1718911047; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mws2MIaSpabprW+K0B5XGTiUggUTIjO34wnCF45aV+E=;
        b=oAZM3koFsS51+9F1eTsmeQAh9lkGDoMGSC8wU67ETdcYyjQqS0Lssqq9Z4IkfYEoQ2
         ToDY2/GhpKzGeOEama1y7KJTrpExsCnjTBM9CzMFWbb5LSRp6csH/MKb7su4pEBY9QvI
         JFPykggbrtMwUFtzB4p6J4zfdBGvioxKlBeyvbVVnCh9S3OWj9zYv+N0tqM/shjnliN3
         jbmnPr9X4Wwx++p5ucMUjwkX3CMXuiDBnvbzF0iEBtPfBOXt793RwZWDHrIHEdnRdpI0
         QQ4sEq8W85UFs9DiZKzyLmvmg/6BUWmZiqVIPk08vy3qQ63eo5BmA7I6Adx4b6wR+9+9
         OH5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718306247; x=1718911047;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mws2MIaSpabprW+K0B5XGTiUggUTIjO34wnCF45aV+E=;
        b=iIQuRaCWTN8qVugy8rCMz0zmrvRv6zAUVGbQfGEIlj7XlhKvprf35h6DihHuAB/1xg
         jY046J/byUjgwsMwuUcFp5OdZabZsaXoTMhYpbQFWeLqgRBmIL+M2f36sOuKPD9pw37q
         cQeEks8ZVGzySPg79pWR5ByLuRMznNb6r06/K4wfScR4R/S9yFvI2ugrtVmhWyzsZJwe
         2kLL8DVvwd72Dis0jrKfMn5M94qjaS46ChAE8yIAK7eh5pBftBijZDN8N141DQiZoV9I
         b+JVI7sS+Jln7q4UsHjBiZD1NgXexPGZC90sUF2FUvV0HD2tZsjm7lvdC3JSjcZNu48g
         mfwQ==
X-Forwarded-Encrypted: i=1; AJvYcCVxqjWveS34AmhyVJLkDRsZBSX/RtFr74T0GTXtIVhaHDeCOUy1SH7ZCS1V16gCPKytLZlCH4jYjlJT9dnE9mjqnHy+
X-Gm-Message-State: AOJu0YztvleGReTGQbG+Ml+Xqonw0F1FNusUogCMYhpcOWufCk86EMu2
	vtNj/B6hTyzu9IQs1h0sbniXxEgo/pwMe4KaBbn9tVN3Sih0e1lNjAyXvau0jlpyuD626Lzyagr
	Kiw==
X-Google-Smtp-Source: AGHT+IGLEmys20qbkgdABrkxxvz+kgf995x6jgSnv4NUe3WC6bbRVbCvqXkmtYi3k70EMue7mRQDd5lVWWc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:3319:b0:705:c8b8:c517 with SMTP id
 d2e1a72fcca58-705d710ba55mr28066b3a.1.1718306246532; Thu, 13 Jun 2024
 12:17:26 -0700 (PDT)
Date: Thu, 13 Jun 2024 12:17:25 -0700
In-Reply-To: <20240613021920.46508-1-flyingpeng@tencent.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240613021920.46508-1-flyingpeng@tencent.com>
Message-ID: <ZmtFxVTnzS8z3n5m@google.com>
Subject: Re: [PATCH]  KVM/x86: increase frame warning limit in emulate when
 using KASAN or KCSAN
From: Sean Christopherson <seanjc@google.com>
To: flyingpenghao@gmail.com
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, 
	Peng Hao <flyingpeng@tencent.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Jun 13, 2024, flyingpenghao@gmail.com wrote:
> From: Peng Hao <flyingpeng@tencent.com>
> 
>  When building kernel with clang, which will typically
>  have sanitizers enabled, there is a warning about a large stack frame.
> 
> arch/x86/kvm/emulate.c:3022:5: error: stack frame size (2520) exceeds limit (2048)
> in 'emulator_task_switch' [-Werror,-Wframe-larger-than]
> int emulator_task_switch(struct x86_emulate_ctxt *ctxt,
>     ^
> 599/2520 (23.77%) spills, 1921/2520 (76.23%) variables
> 
> so increase the limit for configurations that have KASAN or KCSAN enabled for not
> breaking the majority of builds.

Overriding -Wframe-larger-than in KVM isn't maintainble or robust, and KVM shouldn't
discard the userspace configuration.

Can you provide the relevant pieces of your .config?  KVM already guards against
KASAN, so maybe it's just KCSAN that's problematic?  If that's the case, then I
believe the below two patches will do the trick.

If KVM_WERROR is enabled because WERROR is enabled, then that's working as intended,
i.e. the problem is in the config, not in KVM.

From: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Jun 2024 12:03:13 -0700
Subject: [PATCH 1/2] KVM: x86: Disallow KVM_WERROR if KCSAN and/or KMSAN is
 enabled

Extend KVM_WERROR's incompatibility list to include KCSAN and KMSAN, in
addition to the existing KASAN restriction.  Like KASAN, KCSAN and KMSAN
require more memory and can cause problems with FRAME_WARN.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/Kconfig | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 80e5afde69f4..e12733574e92 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -61,13 +61,14 @@ config KVM
 
 config KVM_WERROR
 	bool "Compile KVM with -Werror"
-	# Disallow KVM's -Werror if KASAN is enabled, e.g. to guard against
-	# randomized configs from selecting KVM_WERROR=y, which doesn't play
-	# nice with KASAN.  KASAN builds generates warnings for the default
-	# FRAME_WARN, i.e. KVM_WERROR=y with KASAN=y requires special tuning.
-	# Building KVM with -Werror and KASAN is still doable via enabling
-	# the kernel-wide WERROR=y.
-	depends on KVM && ((EXPERT && !KASAN) || WERROR)
+	# Disallow KVM's -Werror if one or more sanitizers that requires extra
+	# memory is enabled, e.g. to guard against randomized configs selecting
+	# KVM_WERROR=y.  Sanitizers often trip FRAME_WARN in KVM, i.e. enabling
+	# sanitizers+KVM_WERROR typically requires a hand-tuned config.
+	#
+	# Note, building KVM with -Werror and sanitizers is still doable via
+	# enabling the kernel-wide WERROR=y.
+	depends on KVM && ((EXPERT && (!KASAN && !KCSAN && !KMSAN)) || WERROR)
 	help
 	  Add -Werror to the build flags for KVM.
 

base-commit: e4e9e1067138e5620cf0500c3e5f6ebfb9d322c8
-- 
2.45.2.627.g7a2c4fd464-goog

From 2e20a81fbafb10eae6727fdf314404b67b449492 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 13 Jun 2024 12:06:36 -0700
Subject: [PATCH 2/2] KVM: x86: Disallow KVM_WERROR with sanitizers iff
 FRAME_WARN is enabled

Allow KVM_WERROR to be enabled alongside sanitizers if FRAME_WARN is
disabled, as the sanitizers are problematic only because they increase the
stack footprint and cause FRAME_WARN to fire, i.e. KVM isn't fundamentally
incompatible with the sanitizers.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/Kconfig | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index e12733574e92..34f047426a71 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -62,13 +62,14 @@ config KVM
 config KVM_WERROR
 	bool "Compile KVM with -Werror"
 	# Disallow KVM's -Werror if one or more sanitizers that requires extra
-	# memory is enabled, e.g. to guard against randomized configs selecting
-	# KVM_WERROR=y.  Sanitizers often trip FRAME_WARN in KVM, i.e. enabling
-	# sanitizers+KVM_WERROR typically requires a hand-tuned config.
+	# memory is enabled and FRAME_WARN is also enabled, e.g. to guard
+	# against randomized configs selecting KVM_WERROR=y.  Sanitizers often
+	# trip FRAME_WARN in KVM, i.e. enabling sanitizers+KVM_WERROR typically
+	# requires a hand-tuned config.
 	#
 	# Note, building KVM with -Werror and sanitizers is still doable via
 	# enabling the kernel-wide WERROR=y.
-	depends on KVM && ((EXPERT && (!KASAN && !KCSAN && !KMSAN)) || WERROR)
+	depends on KVM && ((EXPERT && ((!KASAN && !KCSAN && !KMSAN) || FRAME_WARN=0)) || WERROR)
 	help
 	  Add -Werror to the build flags for KVM.
 
-- 
2.45.2.627.g7a2c4fd464-goog


