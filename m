Return-Path: <kvm+bounces-49112-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41417AD60F1
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 23:17:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CEC9C1E0F44
	for <lists+kvm@lfdr.de>; Wed, 11 Jun 2025 21:17:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D9F8245010;
	Wed, 11 Jun 2025 21:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tX0dj0C6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0847D23AB9D
	for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 21:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749676619; cv=none; b=UUbnxG0msRyuZST8W85o8+F0bV8acy1C7WNQLy8nhGw+tgg867y+lovrDLt4UrrIwszcHus9ZwulKB4Lf/w7M/mHu+fXv/Vk7LC4LY1ExoI5vcWDkRRU62N9sHj4VMZaSqIZsbi1zbsg+RkRpRLNqwwNGIm0w1wVkuG9F7OZlGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749676619; c=relaxed/simple;
	bh=1J2BNASlNa1Dhe5jluI1gAN0W9RVPLyHfYbBUQPkC54=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Jv9cAXIaWfyhP4jHzF6szEUxcWuf5Qm64CuJ4B617Ze/NfNHSdcIADtWC8nGaeW4ty1zbrzKnHQOil5QqWF+nPm93muqb2W7RVygUX5/vESj1mxCNnHJi4jNeVIIbGAkykI3t8PE9GZ6kVNwzyZ7QRkPEel6/elP+iXBkiI2dU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--afranji.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tX0dj0C6; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--afranji.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b26cdc70befso113208a12.1
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 14:16:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749676617; x=1750281417; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=JVZUY5qeKcLxvon3A1qgzFOnqGD8w3UB+MEi0rObhNA=;
        b=tX0dj0C6FlJ+8eMNwdZODidXdYTeEqpSRvjX9G1HOn1NuSC4Z0Zn3+2CocNpvgyFJ/
         4ddOneDuYzDCBy6xehXPXgZaK5cxZ+41J+tUNhynqUKn0agFJ4SAO1DV6EsEY8zXt7kr
         wvfXG4/jMJrHxtfE7tjOC/2kwmEVrI1vh3aaR/ZvZObH7Z8uYnXePADn0bh+SU0qe6wp
         iLJL+YvTz+oj7v/eMnu70WaJ522v6jI/BK0/1ZO8aGDiOwNEmIkAdNuXW6NAB4ye+tgo
         pMkS41hMyBeHWl6Nh47llY/7Mtl3gPshfdtNc321TLrH4M17R7m7XVBswzhEK/d7rzlp
         H8FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749676617; x=1750281417;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JVZUY5qeKcLxvon3A1qgzFOnqGD8w3UB+MEi0rObhNA=;
        b=YogJMU31unCs/ab28sjlz2wJm0CwpNcr75PSStqj5HJ/jchpduBkwuQKbyMkUX8rWR
         fr+xE16jyCgNWPSmnexfQkOpz7BvODasa9q6yIupDmH0PLA4yQ5qslFBDJVlcq6MWW2m
         vhw3/p/USEIZ4ELhvT9o0ZDAKKphinz7wgubmshLHzjNd8/rwPYcmXm1i2NJcXn4OaZA
         41g0OJpyysNdvMunVP38Jrwld4Hxw5AS5Jk8jNpqcheZ1DuMv4LkAntkEyfPjHmE2PRY
         23ao1aEJkiZE2bks+nnYY//vg+dwWTSU34K3m7uz90gQaQ2T53KFPobhBkBVBdLCDnIm
         Opcg==
X-Gm-Message-State: AOJu0Yw5tHk004V98eXUbtBhitbVCjOefAlWiWl6qEhe2+zV+Ermc9qv
	IGwHH0uRTWkQj3t9fypqw6k5+gHkoRonvnhdDeaxIi/CEK0Jg0gea+UDf+CDyQH1iC8+rpKNE5f
	3r1SYOvruDtlYbPp+JkeLnW5wG/v16r1XtWVKqeGzOLmAnDosg9PQKDTqPme9VFhx2RyNMsOOJ5
	2JQ4lNPZwj68AYf/AIfnH3g/vB8WAp9oJdVLFbjQ==
X-Google-Smtp-Source: AGHT+IEJ/qdunyiMvwsT10mftztZECZsqDYMcHYykS/gDMvyJ2du0eMtdA6wuu+sltqOX8qT0k9ifIs5X5dW
X-Received: from pfble12.prod.google.com ([2002:a05:6a00:4fcc:b0:746:1d26:e8c8])
 (user=afranji job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:394b:b0:21f:775d:107e
 with SMTP id adf61e73a8af0-21f9b9f75ebmr370105637.17.1749676617125; Wed, 11
 Jun 2025 14:16:57 -0700 (PDT)
Date: Wed, 11 Jun 2025 21:16:28 +0000
In-Reply-To: <cover.1749672978.git.afranji@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <cover.1749672978.git.afranji@google.com>
X-Mailer: git-send-email 2.50.0.rc1.591.g9c95f17f64-goog
Message-ID: <884dc45a13920578973d5628c7cad79d8d50b7a2.1749672978.git.afranji@google.com>
Subject: [RFC PATCH v2 01/10] KVM: Split tdp_mmu_pages to mirror and direct counters
From: Ryan Afranji <afranji@google.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Cc: sagis@google.com, bp@alien8.de, chao.p.peng@linux.intel.com, 
	dave.hansen@linux.intel.com, dmatlack@google.com, erdemaktas@google.com, 
	isaku.yamahata@intel.com, kai.huang@intel.com, mingo@redhat.com, 
	pbonzini@redhat.com, seanjc@google.com, tglx@linutronix.de, 
	zhi.wang.linux@gmail.com, ackerleytng@google.com, andrew.jones@linux.dev, 
	david@redhat.com, hpa@zytor.com, kirill.shutemov@linux.intel.com, 
	linux-kselftest@vger.kernel.org, tabba@google.com, vannapurve@google.com, 
	yan.y.zhao@intel.com, rick.p.edgecombe@intel.com, 
	Ryan Afranji <afranji@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Sagi Shahar <sagis@google.com>

tdp_mmu_pages counts all the active pages used by the mmu. When we
transfer the state during intra-host migration we need to transfer the
mirror pages but not the direct ones. The direct pages are going to
be re-faulted as needed on the destination, but that approach doesn't
work for mirrored pages which stores information in the secure EPT.

Keeping them in separate counters makes this transfer more efficient.

Signed-off-by: Sagi Shahar <sagis@google.com>
Signed-off-by: Ryan Afranji <afranji@google.com>
---
 arch/x86/include/asm/kvm_host.h |  7 +++++--
 arch/x86/kvm/mmu/tdp_mmu.c      | 11 +++++++++--
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 999872c13722..b9966394acda 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1484,10 +1484,13 @@ struct kvm_arch {
 #ifdef CONFIG_X86_64
 #ifdef CONFIG_KVM_PROVE_MMU
 	/*
-	 * The number of TDP MMU pages across all roots.  Used only to sanity
-	 * check that KVM isn't leaking TDP MMU pages.
+	 * The number of non-mirrored TDP MMU pages across all roots.
+	 * Used only to sanity check that KVM isn't leaking TDP MMU pages.
 	 */
 	atomic64_t tdp_mmu_pages;
+
+	/* Same as tdp_mmu_pages but only for mirror pages. */
+	atomic64_t tdp_mirror_mmu_pages;
 #endif
 
 	/*
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7f3d7229b2c1..115af5e4c5ed 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -42,6 +42,7 @@ void kvm_mmu_uninit_tdp_mmu(struct kvm *kvm)
 
 #ifdef CONFIG_KVM_PROVE_MMU
 	KVM_MMU_WARN_ON(atomic64_read(&kvm->arch.tdp_mmu_pages));
+	KVM_MMU_WARN_ON(atomic64_read(&kvm->arch.tdp_mirror_mmu_pages));
 #endif
 	WARN_ON(!list_empty(&kvm->arch.tdp_mmu_roots));
 
@@ -328,7 +329,10 @@ static void tdp_account_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	kvm_account_pgtable_pages((void *)sp->spt, +1);
 #ifdef CONFIG_KVM_PROVE_MMU
-	atomic64_inc(&kvm->arch.tdp_mmu_pages);
+	if (sp->role.is_mirror)
+		atomic64_inc(&kvm->arch.tdp_mirror_mmu_pages);
+	else
+		atomic64_inc(&kvm->arch.tdp_mmu_pages);
 #endif
 }
 
@@ -336,7 +340,10 @@ static void tdp_unaccount_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	kvm_account_pgtable_pages((void *)sp->spt, -1);
 #ifdef CONFIG_KVM_PROVE_MMU
-	atomic64_dec(&kvm->arch.tdp_mmu_pages);
+	if (sp->role.is_mirror)
+		atomic64_dec(&kvm->arch.tdp_mirror_mmu_pages);
+	else
+		atomic64_dec(&kvm->arch.tdp_mmu_pages);
 #endif
 }
 
-- 
2.50.0.rc1.591.g9c95f17f64-goog


