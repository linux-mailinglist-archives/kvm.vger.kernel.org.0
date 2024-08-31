Return-Path: <kvm+bounces-25602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 44B20966D5D
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 02:20:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 68F991C21617
	for <lists+kvm@lfdr.de>; Sat, 31 Aug 2024 00:20:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E0FA14B940;
	Sat, 31 Aug 2024 00:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FrIfmNBw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB3A13C3CD
	for <kvm@vger.kernel.org>; Sat, 31 Aug 2024 00:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725063380; cv=none; b=AhG16eTcBkuc2wKzMfWZhBU2dGEpckfknWALsn25q4fPtuJhOgiE9pLDchftmXE3LmyzgMbEf8XvNliy0OzE3WV/PAp+i2mXGkuuxaNY6mlEV7rRt2WUD3pVXn0xiGkwnLYKvZ999ciH8TIQZbtlNLKFciHzncgNR9qDSzJpBYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725063380; c=relaxed/simple;
	bh=nHlj+xD/ONShNKxAH4EaHG4dggMKZLPwwDJ8pS5wCL4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gqXbDTGgmHJsA2MqZxZzOEAnATkHt8rEzCE8H/BZHuRdT8X4LFqpLCJ6dfzU8ljOUq6ok8jkXJHkf0MkRpU7HCgzZjqh9W3gvBsS/u/w8wV5J/oz3cLXlrRjoLAtLMjrPCJ1K/kKDNrrCQsLrX4fydGLWt28EjCtIHgYiAl0YB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FrIfmNBw; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2021ab2b5e6so21041465ad.0
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2024 17:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725063378; x=1725668178; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=hU77OYTkUMLfRxkahmddxieOilGttKEAZ+XNkDI94lk=;
        b=FrIfmNBwOJ/nIvezraVFZufKwvOVxQm1l8/QO+M9mFHsqLxlCK9p75qcKmyXEmfgA0
         wBSG6N0VwE2b8qshg+LYXO/XWXbWVREW+OinUSKFWDO3flfDWkJG+tWnAKPozOtzbtoS
         qUUDHH/emk6lvMftMWezRoik4HA8WZUiLPoZb/3FLkq9uqg26uB1VqRobM/a5rrMlCuR
         u4wifjqarxdc+A+lGa9R58RXuVfPjnEM0FdEo1tUeH3Q8L9wChZ371DlQfe5AIu3jR2J
         f4kWaKrNtz8vDcmzJyrmDp1itu9+KdFkcBm+VDruDl9UzbukGbjJwJ3Upvxky9bh/H5z
         1u0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725063378; x=1725668178;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hU77OYTkUMLfRxkahmddxieOilGttKEAZ+XNkDI94lk=;
        b=Rr9d7tOFtaKaFal5FMQEy4ilFy1NUdXBUVzMR9TqZ5K2P6X4mvLHVBi9/wLJj9qsqn
         u2oebDopziVdk3Dmp2IOEns+mzYKcTKatMyw+ZZtJjQkoPDdg8lqEWPgNvd7hgz7SZts
         qGd1n5MAXbOKkC1m8DaqjDCcw5zsg1Gj6Rxq38WSZps1zmynewev8nIdSNPGOAWqHqlR
         5Vg1IOoZr7A+ee1JISNPxM/JvMQTBqeo8so27a7aGYFVfijTvetHRXyMIDDa1J94ZGiL
         rkf6a3juqjEZMI34h0PLR4pZB0CbmgrnmZqlKoopcfY1L38NE0hDsGZ5WQSuVva5yVDJ
         appg==
X-Gm-Message-State: AOJu0YyE5344V3gomr2lWBBmz0RfegmceeSbNkqptoAvuGQCEHFEiYB4
	UX+uTgK2krF6XObKakC72VxZJD9HBHD21DyPwXeaLuObzz2+eiQQ36QVs0+RAAjF5sI2NLEka82
	Mog==
X-Google-Smtp-Source: AGHT+IHblxeHkSJzB63Sh5fAMNGdMNQ2SfoqcaQ/5BRDjPe/OytJTEsD0IQrqIW87OaHEx0tHfAmrT3IG7M=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:1d1:b0:202:70f:641a with SMTP id
 d9443c01a7336-20527626efdmr976465ad.2.1725063378157; Fri, 30 Aug 2024
 17:16:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 30 Aug 2024 17:15:33 -0700
In-Reply-To: <20240831001538.336683-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240831001538.336683-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.469.g59c65b2a67-goog
Message-ID: <20240831001538.336683-19-seanjc@google.com>
Subject: [PATCH v2 18/22] KVM: x86: Update retry protection fields when
 forcing retry on emulation failure
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yuan Yao <yuan.yao@intel.com>, Yuan Yao <yuan.yao@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"

When retrying the faulting instruction after emulation failure, refresh
the infinite loop protection fields even if no shadow pages were zapped,
i.e. avoid hitting an infinite loop even when retrying the instruction as
a last-ditch effort to avoid terminating the guest.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h | 10 +++++++++-
 arch/x86/kvm/mmu/mmu.c          | 12 +++++++-----
 arch/x86/kvm/x86.c              |  2 +-
 3 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2c3f28331118..4aa10db97f6f 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2135,7 +2135,15 @@ int kvm_get_nr_pending_nmis(struct kvm_vcpu *vcpu);
 void kvm_update_dr7(struct kvm_vcpu *vcpu);
 
 int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn);
-bool kvm_mmu_unprotect_gfn_and_retry(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa);
+bool __kvm_mmu_unprotect_gfn_and_retry(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
+				       bool always_retry);
+
+static inline bool kvm_mmu_unprotect_gfn_and_retry(struct kvm_vcpu *vcpu,
+						   gpa_t cr2_or_gpa)
+{
+	return __kvm_mmu_unprotect_gfn_and_retry(vcpu, cr2_or_gpa, false);
+}
+
 void kvm_mmu_free_roots(struct kvm *kvm, struct kvm_mmu *mmu,
 			ulong roots_to_free);
 void kvm_mmu_free_guest_mode_roots(struct kvm *kvm, struct kvm_mmu *mmu);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4910ac3d7f83..aabed77f35d4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2713,10 +2713,11 @@ int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
 	return r;
 }
 
-bool kvm_mmu_unprotect_gfn_and_retry(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa)
+bool __kvm_mmu_unprotect_gfn_and_retry(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
+				       bool always_retry)
 {
 	gpa_t gpa = cr2_or_gpa;
-	bool r;
+	bool r = false;
 
 	/*
 	 * Bail early if there aren't any write-protected shadow pages to avoid
@@ -2727,16 +2728,17 @@ bool kvm_mmu_unprotect_gfn_and_retry(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa)
 	 * skipping the unprotect+retry path, which is also an optimization.
 	 */
 	if (!READ_ONCE(vcpu->kvm->arch.indirect_shadow_pages))
-		return false;
+		goto out;
 
 	if (!vcpu->arch.mmu->root_role.direct) {
 		gpa = kvm_mmu_gva_to_gpa_write(vcpu, cr2_or_gpa, NULL);
 		if (gpa == INVALID_GPA)
-			return false;
+			goto out;
 	}
 
 	r = kvm_mmu_unprotect_page(vcpu->kvm, gpa_to_gfn(gpa));
-	if (r) {
+out:
+	if (r || always_retry) {
 		vcpu->arch.last_retry_eip = kvm_rip_read(vcpu);
 		vcpu->arch.last_retry_addr = cr2_or_gpa;
 	}
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 09fc43699b15..081ac4069666 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8882,7 +8882,7 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	 * guest to let the CPU re-execute the instruction in the hope that the
 	 * CPU can cleanly execute the instruction that KVM failed to emulate.
 	 */
-	kvm_mmu_unprotect_gfn_and_retry(vcpu, cr2_or_gpa);
+	__kvm_mmu_unprotect_gfn_and_retry(vcpu, cr2_or_gpa, true);
 
 	/*
 	 * Retry even if _this_ vCPU didn't unprotect the gfn, as it's possible
-- 
2.46.0.469.g59c65b2a67-goog


