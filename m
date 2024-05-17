Return-Path: <kvm+bounces-17705-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 61B0F8C8C0F
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 20:04:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EFE82B218B5
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 18:04:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D266A13E886;
	Fri, 17 May 2024 18:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Knkm1XHQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B493813E414
	for <kvm@vger.kernel.org>; Fri, 17 May 2024 18:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715969028; cv=none; b=bqJuXPwIOBHDu/JohOke+N4mQNpDOBdCM0LiImkGnfydqrHE1pWt/V9vqEr5g88EDYcRoxiyGpZZVDql+2RIrXzj1G7ciqwWuliObH/VGtqvSpbrDAi0eA5QHzMOHi6byG2ESgQfi8ZS5BQ3o4rl+c3/6l36MLfI6vvoPJK+VhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715969028; c=relaxed/simple;
	bh=e5qiKadWZo77LQN+kQyEGARAeYAsnzqKPBmd3wtpifo=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=M6oUQNEWi7j6Eitm8I/P3kS9ZlZCqW2qUV74OwaqDNoa8IURFw9XgDuPBtZeOqIHCHycgLVJsAkUrqHVy26HESNlyyks6MCJL7mYkLcqEio8GBq/xI2JkoAC68WaqczS5tZxoyFiOFXMEGFbLkKtrJ3yqsHMamEjuzFFx8HVNhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Knkm1XHQ; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6202fd268c1so171233787b3.2
        for <kvm@vger.kernel.org>; Fri, 17 May 2024 11:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715969025; x=1716573825; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TYJ0cnc0Zl4FGmkoO88+7b2WvQHMce7LkfnJgQxYQeI=;
        b=Knkm1XHQWjxiQCffE0i+RUry+KQiwfqwL6zQRtEguKaqRPpWY3p0mZVl7Bod9IvUpN
         dlIMTcrNKHKwup/YMnsOGdFEsEo5pjLkJfuNwfWHHKCpEDlceYOFM/mNYkeYUDS0CWJV
         6g6wT7IfES7wLo9n5IMdPnbecTPnTFEYVtjsT/D3IEyh0T2GNS9ERovuaYOSBKr/mD0B
         opwB38M/c6qn+2EdW7QgjPBuWBrWURtdECcp+1UUNlLhmAUlFxslCXrwNkltUPM8KEc0
         FL6p3EwrpAieqZjz/PhownJs2WoYwqEFYcdyHVrPi9ObLvuomOXmyUGBmJJAluuJsL9z
         nydw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715969025; x=1716573825;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TYJ0cnc0Zl4FGmkoO88+7b2WvQHMce7LkfnJgQxYQeI=;
        b=w4JNpp8snJmoE16uX2/Dr4shbtjz0cnGvtGLpMEVtJNtsEznvI/N8CTIPyOMVMdx2f
         Pnw9IRF0YLVfH4euhys2RyxrF8rb6PQnJ5VkXc0gShOiYODs4Jhlus9BEhyBHEXjJMzO
         EKmVBMd7EzFPfZWl6gkB/OyC8WKAeAFYYwT3+HPgnSSNfjP+ErEKKaAhc/x4gSQ1c6BJ
         o1vQQayj5XsAchb5XMlipDH2b5haAzSKQ6Bl+jcWsgjNLqYbcToMioV35DwyyFfYtc46
         9Y2dFDsJm+0bxY4yAvDP9Sidvdu6gOhy9XyS6GPsRSYjC5+1M14b0nw+RkLhImFriIOU
         jVGQ==
X-Gm-Message-State: AOJu0YznkQ7T0l34yRwDzWKOSMhtjoc7+8tF+E2dbFvk0fMHuNW7mifN
	THdaYkTuWHch8U3vP1mu4DBg85u75TQ8D5XEgp/huC0Xy6WeLZnOO8lWwQj5dmJTpTtqic+i5yJ
	nfg==
X-Google-Smtp-Source: AGHT+IFWokv5NHdXBcUwPF1pMMwuaY9pZRDlvYpEU9fYybHuY65eGvaXjHSt2HAOe9THynPhPvsQYHX2faw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:120c:b0:dee:8562:acc3 with SMTP id
 3f1490d57ef6-dee8562aee0mr3953967276.3.1715969025660; Fri, 17 May 2024
 11:03:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 17 May 2024 11:03:41 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.0.215.g3402c0e53f-goog
Message-ID: <20240517180341.974251-1-seanjc@google.com>
Subject: [PATCH] KVM: x86: Force KVM_WERROR if the global WERROR is enabled
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"

Force KVM_WERROR if the global WERROR is enabled to avoid pestering the
user about a Kconfig that will ultimately be ignored.  Force KVM_WERROR
instead of making it mutually exclusive with WERROR to avoid generating a
.config builds KVM with -Werror, but has KVM_WERROR=n.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 2a7f69abcac3..75082c4a9ac4 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -44,6 +44,7 @@ config KVM
 	select KVM_VFIO
 	select HAVE_KVM_PM_NOTIFIER if PM
 	select KVM_GENERIC_HARDWARE_ENABLING
+	select KVM_WERROR if WERROR
 	help
 	  Support hosting fully virtualized guest machines using hardware
 	  virtualization extensions.  You will need a fairly recent
@@ -66,7 +67,7 @@ config KVM_WERROR
 	# FRAME_WARN, i.e. KVM_WERROR=y with KASAN=y requires special tuning.
 	# Building KVM with -Werror and KASAN is still doable via enabling
 	# the kernel-wide WERROR=y.
-	depends on KVM && EXPERT && !KASAN
+	depends on KVM && ((EXPERT && !KASAN) || WERROR)
 	help
 	  Add -Werror to the build flags for KVM.
 

base-commit: 4aad0b1893a141f114ba40ed509066f3c9bc24b0
-- 
2.45.0.215.g3402c0e53f-goog


