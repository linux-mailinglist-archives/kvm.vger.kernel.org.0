Return-Path: <kvm+bounces-23797-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CD2294D7B2
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 21:50:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B39251F21DF1
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 19:50:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16CBE19B3E2;
	Fri,  9 Aug 2024 19:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SNmfM4vo"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05CDA19CD0B
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 19:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723232664; cv=none; b=gRrspGhy/wiFANl9ncxQy7pDNppPahzx85vQWleriy+NqmdDoiNNgzZHrEIqOE7C6RbvqTO59mC4OxPtJlbOhFTXMchGO2esTNzOzSmgnv41gYIUqV3U8Qq9e6WMRe3gkSBic88H84DYausBq2ChaFIbF0FoALHmDjlfLdlDvT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723232664; c=relaxed/simple;
	bh=DAzHpkMD+wsg+IgGyvY1zUDoM4DEg8WSG8aKxUnrcM0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=URsr5V0j0WXzC2OMCATC7b+nLzRwxIqfFH13ISmqpg1zwuVEJVLpHVwKFskKuRy6R4joBahicdYAHLZaxLzpCZeoMqwMDDW6Kc832VBrhs4zFfHfw0L9LQUA3d2kegIm0hvXJcI9j+qMpybbR2C3Z1WmhfUixwViWzSLG4QD+O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SNmfM4vo; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7a3c6dd559aso2628728a12.1
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 12:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723232662; x=1723837462; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=8pI2Dk2CV1cTItnOXgPwVCgdPRwBcss9J2eOD4s9n2E=;
        b=SNmfM4voWXCyX9uc9PSsvFRT3o6CR1p7akCFejZ3L16cl0dRqL4ZZAHEpyQIHLz7OB
         oHxKLn61By1WM6WA4UzQWCZw8vPjAot5+XnYQZElx1cMYOKbBcJi3ZonX5oNDPgjk9MD
         rFUP1825C4QGb6A9X2oB3bjzorR/sOYtuyj7OtfCR4j9I9/4qY2WgnQGAKA83xopTliv
         Anm1wsZ0D9ErP0cZjnLFZwZdLaHxLS//YNzB3SeC2WAG3QuzLGywocwgPRQIDz0oGDEy
         t1dL+qCgLbPE7QdDkPyKxKOVm03BvAip+HArlxweMRIls9mJ5mN5lGfPEJgh1xNU/ubb
         jMLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723232662; x=1723837462;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8pI2Dk2CV1cTItnOXgPwVCgdPRwBcss9J2eOD4s9n2E=;
        b=H8Q9ugmJ++v5g8Y7GF/ZpcFAVf36/PjQJDUFOlwVkZWuBe9ERERFDPWyvFF6Fxg7tq
         CPTfdAroxZwG/4uCCTTUpbAudYHELXh9jPUUnkFGO2on20qdxn82oH7Myoh51+v5tMu9
         690GmAIEwGRAERWVxvdZKIYV/NIij8VCNNf07f0xpjUHlwAvdgNU+v4MmzZzdF8GqUUe
         EY5HtW863eCpD8fosbezykHFuiClAI3yLCr+anud1BsVNDQLg4HaodJx+KWPDPN4uYww
         SIP70T2rpmW4tBhru4gme8jcSImXtmnYCl8RCZlBsjMZjxKsKi06+Q+RmszmtoUPfOTq
         2ubg==
X-Gm-Message-State: AOJu0YwJZCetFGj2nq1GAobyBnleYvDLSQNz0kuQJw+CFeOQwCTcA1qR
	sRyTw357dr+fmTK5C87+bOAhWxwVgPcqDD+QVJsRs2QsGWN5A3Lbkhgjdb8f5TzF54w0D2OSEcz
	dUA==
X-Google-Smtp-Source: AGHT+IFfyFmWIFbiqu94F+TDoLpelUA2Pyb+SCf4Vx96bmcRj1adsvoVMyySdsBmrnDzs3PRgMYuDO6IScE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:9c0c:b0:2c9:967d:94a4 with SMTP id
 98e67ed59e1d1-2d1e80e6a81mr12876a91.5.1723232662118; Fri, 09 Aug 2024
 12:44:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  9 Aug 2024 12:43:34 -0700
In-Reply-To: <20240809194335.1726916-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809194335.1726916-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240809194335.1726916-23-seanjc@google.com>
Subject: [PATCH 22/22] ***HACK*** KVM: x86: Don't take mmu_lock when aging gfns
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, Peter Xu <peterx@redhat.com>, 
	James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"

DO NOT MERGE, this is a horrific hack, breaks TDP MMU, etc.

Not-signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 2 ++
 arch/x86/kvm/vmx/vmx.c | 2 ++
 virt/kvm/kvm_main.c    | 7 ++++---
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c115d26844f7..e5c5d0f9a69d 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -5300,6 +5300,8 @@ static __init int svm_hardware_setup(void)
 	if (!boot_cpu_has(X86_FEATURE_NPT))
 		npt_enabled = false;
 
+	npt_enabled = false;
+
 	/* Force VM NPT level equal to the host's paging level */
 	kvm_configure_mmu(npt_enabled, get_npt_level(),
 			  get_npt_level(), PG_LEVEL_1G);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f18c2d8c7476..28f3493d6391 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8419,6 +8419,8 @@ __init int vmx_hardware_setup(void)
 	    !cpu_has_vmx_invept_global())
 		enable_ept = 0;
 
+	enable_ept = 0;
+
 	/* NX support is required for shadow paging. */
 	if (!enable_ept && !boot_cpu_has(X86_FEATURE_NX)) {
 		pr_err_ratelimited("NX (Execute Disable) not supported\n");
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index d0788d0a72cc..1b9b5dea2ac8 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -642,10 +642,11 @@ static __always_inline kvm_mn_ret_t __kvm_handle_hva_range(struct kvm *kvm,
 			gfn_range.slot = slot;
 
 			if (!r.found_memslot) {
-				r.found_memslot = true;
-				KVM_MMU_LOCK(kvm);
-				if (!IS_KVM_NULL_FN(range->on_lock))
+				if (!IS_KVM_NULL_FN(range->on_lock)) {
+					r.found_memslot = true;
+					KVM_MMU_LOCK(kvm);
 					range->on_lock(kvm);
+				}
 
 				if (IS_KVM_NULL_FN(range->handler))
 					goto mmu_unlock;
-- 
2.46.0.76.ge559c4bf1a-goog


