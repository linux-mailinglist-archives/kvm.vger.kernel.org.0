Return-Path: <kvm+bounces-24976-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E57BC95D9F9
	for <lists+kvm@lfdr.de>; Sat, 24 Aug 2024 01:57:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4B0DFB21CF1
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 23:57:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D88811CB305;
	Fri, 23 Aug 2024 23:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dfExpEFV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF431C93A8
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 23:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724457416; cv=none; b=kKWttqR4Lky5ijb9SVKDiwYs0Sd3Qg6VSZTjW2YnV3OsYO3Pen4mL2M+PaB2C1hgcj7GdqQSMa+ZQ+YFtQlZCeyoo5U4QhA6b3Je4cYLiKfhiaIHb+8H+84JjygxItXxJh2Vff2wBHh85ZgICMZhorW/YY889o6+7sYQWD56BqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724457416; c=relaxed/simple;
	bh=IAZfIIsjLVHrJ/iB//I8yM+zpSJpgSCSqDvCypt7OcI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GgRj6ZC0fGPvXwZPROUsUrtLgVPNP2q+csvPk1mQaXvEhkWHrgbgic17XpavYEnCoc/LSL8aeathIBuerpU+mmW3s9CIgqXRfAOjR7jzdVWzIDDfj79UV97DYZQ671SAC/TGwb+8EISBvO2gUiLdDOOL2+mtAFsbuusNv00fJpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dfExpEFV; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--dmatlack.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e13e682bee1so4292607276.2
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 16:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724457413; x=1725062213; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9tP2LsacPhuXWkmFDMCvVM/elGS1eLYh0YjQ3JXjio4=;
        b=dfExpEFVeK4IQ1FBj5nN209CTN/3gnkzzKXST0VR5es7x/dww4zhs6cjF5VJZqTqef
         p0h1vnCKslmE0JevmnSyVgtFcEl3vFqqK6KAU7Rj/HNWMtVVWYIbjE17uApPrpIQG2qW
         oggYuBWYJyFsvM0zga6AcuS6QfKKna6ra/mwAei441pIf3UHEkWznX3VPYPe9d/h+9C6
         +w/SxWi4FRWRYPV2bHikso0BIfCIq0NaZhsVXr0qm5iPFzWKydX7Iqq4HJcYaLWOQeNQ
         T0ryUAzwq5XZbjEwf0Z40f8v+WI/xdnbMIe8vKfE+RsNCwp8a+8HwE7PF1OHJenHQdqp
         F8hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724457413; x=1725062213;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9tP2LsacPhuXWkmFDMCvVM/elGS1eLYh0YjQ3JXjio4=;
        b=azvaaE6oIWdz1T8G11qiQQcWIn4Rn+ePG7H3bVHVTSE9e7HVk6kULfoVTGrRxgq0Qq
         V6LGTcoJUZWcCxnFFgxgwpxl1x3Cl5hBN8sFnEaWdHDcX1PZ9NwSSAu+lKhLToubcUHo
         GqZKKLr2kMv9lqBrFluVSfUZMJeER5hZJxcOH7c/xWhpnUxNU6e786YxQvKzEgs3ADPB
         oD4KBMJ20+h2yH6/lJyTo14uH+wukwe2Br7DL3oAcGaiTBia/1iTbiPpBMWGp2tcaRKF
         0nT/Iu7gvNRiosZNVcTPygD8Ev9bie6iYjnqqYuJtaQ8/htSwMModGwd7ThSK2EX2b8z
         /Z1w==
X-Gm-Message-State: AOJu0YyBa6RMPrE73L6zlf6k0XbzVgJ75YhaJOFrWpMun6sUFlNuwv2T
	/+2IPSIVA3NbnDIk2xO2DcT3Cr9UwzTLkVeTPGVjCuxL1Nbvo/dFAk0CDuqjND2vivQ8CDJaNLQ
	cihocw3lCYg==
X-Google-Smtp-Source: AGHT+IELbN/Fsx+rJIMPCi9JVWaJsSoU3JIVulpnNsaE1LIruNUdAyJQ5DzjUlV8JQYo5Kx87i4nFHwPp1dY5Q==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:a25:8305:0:b0:e11:6e58:e6a9 with SMTP id
 3f1490d57ef6-e17a865db0emr152981276.12.1724457413681; Fri, 23 Aug 2024
 16:56:53 -0700 (PDT)
Date: Fri, 23 Aug 2024 16:56:43 -0700
In-Reply-To: <20240823235648.3236880-1-dmatlack@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240823235648.3236880-1-dmatlack@google.com>
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <20240823235648.3236880-2-dmatlack@google.com>
Subject: [PATCH v2 1/6] KVM: x86/mmu: Drop @max_level from kvm_mmu_max_mapping_level()
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
 arch/x86/kvm/mmu/tdp_mmu.c      | 3 +--
 3 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d25c2b395116..2e92d9e9b311 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3109,13 +3109,12 @@ static int __kvm_mmu_max_mapping_level(struct kvm *kvm,
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
@@ -6877,8 +6876,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
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
index 3c55955bcaf8..2a843b9c8d81 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1655,8 +1655,7 @@ static void zap_collapsible_spte_range(struct kvm *kvm,
 		if (iter.gfn < start || iter.gfn >= end)
 			continue;
 
-		max_mapping_level = kvm_mmu_max_mapping_level(kvm, slot,
-							      iter.gfn, PG_LEVEL_NUM);
+		max_mapping_level = kvm_mmu_max_mapping_level(kvm, slot, iter.gfn);
 		if (max_mapping_level < iter.level)
 			continue;
 
-- 
2.46.0.295.g3b9ea8a38a-goog


