Return-Path: <kvm+bounces-23280-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B74B948615
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 01:33:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D5711C21F6A
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 23:33:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAC2116F824;
	Mon,  5 Aug 2024 23:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OGDzBdFN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6615416E870
	for <kvm@vger.kernel.org>; Mon,  5 Aug 2024 23:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722900683; cv=none; b=U5lKoSASpRyVScw0JzcPyqLjfrEXMF0ToFyYaNz7SEh7q0TstWAQL4hm0jAPkw/D2BKD9EZT+eFex6VOZSPEzSw+trGzo6ki0/MuNAZUgKu9gPdl0CPj07hzuRbfgu4hCJtzqd6JkuoWETklL0MY8HXZ1gPxM1DQYIDt64P6C0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722900683; c=relaxed/simple;
	bh=Y19HIRv//o9MKak8I1KfvyWj0H3S7faDt3jjM6M5AOI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jTtlFjzPzxgCcCABVUCNIwAnUeoS4oa46WhA8I2qrvXZSvVKrXdWbpSTRn9h9d7nT0cVZxJvP3q2s/sy9UQCKH18/cPTvkZwmZv+hcG9R+lDRv2bezn+kUR37ukGsQWq1UxiFyUlg/Z3DNDUKMpBdrWtZWFtmTi5+SOkOcfF2M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OGDzBdFN; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e0879957a99so102549276.1
        for <kvm@vger.kernel.org>; Mon, 05 Aug 2024 16:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722900681; x=1723505481; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7LQqvI770O7xKSIiWj4rWaWMVDlnXBHyDdlHU3BeMkc=;
        b=OGDzBdFNePBSAZKNLJNWq3gSFSX+02vjTDuQzVChW5G5LDPJoDppW2z1rrQZHCw+8z
         N9697+CxfwILvlRTkQIjHGRwSH7/j29unK+OOcdZ29avdLbbE+AMVJW69hRXeCnbCmi1
         gghTagiq2UiPjEsgxZ0dqZnlT+7el7jC6Nd6xAGkDJyNwUJs/AmFO1IulkiRFp8ZI6PY
         pfi1jqsXLeJds3H/TAzA1W0LSyl2J+pZpRM3gyMwdpoI4SzEi7ZW6YAo24rSxLPipZSz
         P2SjrrAl2vMxxFFllZ3SvnXMJTh132tOhquJ12Yy68QG6S5kaQghb0yYmo1kO3ETD1K3
         7mNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722900681; x=1723505481;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7LQqvI770O7xKSIiWj4rWaWMVDlnXBHyDdlHU3BeMkc=;
        b=QMJa1iGTrM9o4j62Fvv8Il2x96hx7TJ2NuVr4rFMtxeJ8GkkRSAA6WPM1rI5d+ArrY
         8Gh6j3BbjYsaN+JNk3e57Vxq5/uwd36NwkpNXtvlLUStbGRAiwF9a6Z7Vf2cbsDRnY2y
         +ZyMUlOq9F4703nN4MUcvgBSn1+VWKr8KxD936RNOiDrMlBGbvVJfHLF/QY1KhweosHe
         Jli4Z2MqFZTz3VNWp+Qau1oU5XZFmFbHsc3eTkQ1nMxoRm7E95iD3LVSEQojk+zjuYko
         Wt5nnEzhmGoT241+Fu8TR/xIuxuyNwsaS+wYkl25Y1+xmeZyEJc6sykUlcWvIJrkF5bu
         RBRQ==
X-Gm-Message-State: AOJu0YxBdDLR+q4J5/b8SjkOenjfeHVVvFTTWc3ta6H2ciBq9zs0Nx3/
	Eh7HUCbAR21Ck4Rtivizx576lPK3cD9dzM6NbbDL/Qzfq6UXpA2noYxPfzvL4EtnJHAWDFTntdk
	Ts7me5nWXtQ==
X-Google-Smtp-Source: AGHT+IGUGvN8FxaHopiTmurNsaMfZtxMiUrdQ52shFU5Cz3pxiSe8fuge1q+LRErZMHnOLoIpSCUiaTZAycF1w==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a05:6902:c0a:b0:e0b:5200:d93f with SMTP
 id 3f1490d57ef6-e0bde1fc85bmr20203276.3.1722900681306; Mon, 05 Aug 2024
 16:31:21 -0700 (PDT)
Date: Mon,  5 Aug 2024 16:31:09 -0700
In-Reply-To: <20240805233114.4060019-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240805233114.4060019-1-dmatlack@google.com>
X-Mailer: git-send-email 2.46.0.rc2.264.g509ed76dc8-goog
Message-ID: <20240805233114.4060019-3-dmatlack@google.com>
Subject: [PATCH 2/7] KVM: x86/mmu: Drop @max_level from kvm_mmu_max_mapping_level()
From: David Matlack <dmatlack@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Drop the @max_level parameter from kvm_mmu_max_mapping_level(). All
callers pass in PG_LEVEL_NUM, so @max_level can be replaced with
PG_LEVEL_NUM in the function body.

No functional change intended.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 8 +++-----
 arch/x86/kvm/mmu/mmu_internal.h | 3 +--
 arch/x86/kvm/mmu/tdp_mmu.c      | 4 +---
 3 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 901be9e420a4..1b4e14ac512b 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3127,13 +3127,12 @@ static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
 }
 
 int kvm_mmu_max_mapping_level(struct kvm *kvm,
-			      const struct kvm_memory_slot *slot, gfn_t gfn,
-			      int max_level)
+			      const struct kvm_memory_slot *slot, gfn_t gfn)
 {
 	bool is_private = kvm_slot_can_be_private(slot) &&
 			  kvm_mem_is_private(kvm, gfn);
 
-	return __kvm_mmu_max_mapping_level(kvm, slot, gfn, max_level, is_private);
+	return __kvm_mmu_max_mapping_level(kvm, slot, gfn, PG_LEVEL_NUM, is_private);
 }
 
 void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
@@ -6890,8 +6889,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 		 * mapping if the indirect sp has level = 1.
 		 */
 		if (sp->role.direct &&
-		    sp->role.level < kvm_mmu_max_mapping_level(kvm, slot, sp->gfn,
-							       PG_LEVEL_NUM)) {
+		    sp->role.level < kvm_mmu_max_mapping_level(kvm, slot, sp->gfn)) {
 			kvm_zap_one_rmap_spte(kvm, rmap_head, sptep);
 
 			if (kvm_available_flush_remote_tlbs_range())
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 1721d97743e9..fee385e75405 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -344,8 +344,7 @@ static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 }
 
 int kvm_mmu_max_mapping_level(struct kvm *kvm,
-			      const struct kvm_memory_slot *slot, gfn_t gfn,
-			      int max_level);
+			      const struct kvm_memory_slot *slot, gfn_t gfn);
 void kvm_mmu_hugepage_adjust(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
 void disallowed_hugepage_adjust(struct kvm_page_fault *fault, u64 spte, int cur_level);
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index ebe2ab3686c7..f881e79243b3 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1636,9 +1636,7 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 		    !is_last_spte(iter.old_spte, iter.level))
 			continue;
 
-		max_mapping_level = kvm_mmu_max_mapping_level(kvm, slot,
-							      iter.gfn, PG_LEVEL_NUM);
-
+		max_mapping_level = kvm_mmu_max_mapping_level(kvm, slot, iter.gfn);
 		WARN_ON(max_mapping_level < iter.level);
 
 		/*
-- 
2.46.0.rc2.264.g509ed76dc8-goog


