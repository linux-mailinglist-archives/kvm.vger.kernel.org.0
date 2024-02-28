Return-Path: <kvm+bounces-10190-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9855186A6B9
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 03:43:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 278DC286D1F
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 02:43:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BD7C21353;
	Wed, 28 Feb 2024 02:42:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gApBg6m9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F16F720B0F
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 02:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709088120; cv=none; b=NcSnT/02E9fTGMZoKYNxbCFUfIIRa6iwYkPcNYd2cv6tuMe2G9fwyOsD5SX3Yme1G5vJhsvj3Kzly/XWX8o6EBwnmLKiOYGomZr9I5IvHBUFE8kMD9aJ1W4vs8ZpDJr49Y2Myy73ENqHI6cPjEuZJFrqisVKe7fuUV96e4yLZ38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709088120; c=relaxed/simple;
	bh=Ee4P1IGzSZAbqqoC45jHzPN8hF/0X+AxCf4vkLrZ8oo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VN+5oYDgXL8LUZ1pPKX/NGjm3v3tt3RHmKM7GEuzG9BhPpTg8JtWit9iJZItYSMfD5oto0Q704nfCqxVKZ1xw6eayT+YAae3A5LYIYL8N4gdOqIQbAKTC/GZYAuK8OaNy3lFMFwL+L7tpUKTFEwlBO1llHM3m4x8wjupcbcUTI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gApBg6m9; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-60802b0afd2so4396497b3.1
        for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 18:41:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709088118; x=1709692918; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=vbRF992kdFc9tiyNuxItAbgdPRKbA7Cju3slwI3hgOA=;
        b=gApBg6m9/n4OByfbEvr+LNxa1FXhXQXl++lerlpZbBu/TZaJKN/Wrv5NAx6Y8OUYkn
         cEOnoUNmcEOBeR0upfproGY+rxMMBYjz+Q3gWoVVO0Cyc0l1n6BLT66+7GbK+6b16uez
         XvfylwSerawHTVsavbLcmWa14F7e4MqBiHV2eYY3M+M+pPlnJKVSHbDJGqmAIbOjDPug
         KKnSZueNOidQFLClvMQ4kdR8Pe25MkkKGQobd8efDml/+ZRkFjnkiPr4ary6U49yZr2n
         zMHJvS2ywYF4JwfZz2TPHZ0b4mouT7UoVQkXiZJRJUcbiYMYwueersvLCHGUPePJUk1R
         HgZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709088118; x=1709692918;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vbRF992kdFc9tiyNuxItAbgdPRKbA7Cju3slwI3hgOA=;
        b=Jc4j1y3FRmsU4NQ6VtrjLD2T6S+id8EeGpPGajspIZm5bWxFUjaXyqaydqU/47BPWc
         y03XWn3LYfRLOcAOyJT7dWxsAHNmvyCVfOuyg7SY8M4aSL33LPc77omvQAyD2q9WFhFk
         v6nNn5lRUGDjwuFDabhGpMCfptlIB9M2SNj/vu8ByoDKmVMYvW0KBzDatUUogxTPPx5L
         A3D+QYUkGmc8GPAMYk5iDfPF/ObERP6Ll+SBQXt93sdabiy6m75gCLuoUVVUTTZwz5i7
         97TFoQnckdk/IVdgVWhgHuCUSqOQChHZRerbyVFIuYHcN91rltRkHi9McPUOE/MuCUmU
         89DA==
X-Gm-Message-State: AOJu0YwAtMxthMOyYb8D+zXpSVQA1B4AtMWKgDdlQqij4/ljFdg5lMBG
	ofCzTsRVj80IQds2lMvJ2eNQTROQ4jV4AeXB6ow1oKp2UOAhqaM6/VDxkIub/6AP+53Vjr8C6wM
	Z/A==
X-Google-Smtp-Source: AGHT+IHCnZcr7IGx9UCKZXWtKEIsgWhnDoq9inJyUaTHMdVOsz14wV7APi/MVh0ZipKVxAEEBedkFmN5nhU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:4e8f:0:b0:608:ff12:4155 with SMTP id
 c137-20020a814e8f000000b00608ff124155mr292352ywb.0.1709088118014; Tue, 27 Feb
 2024 18:41:58 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 27 Feb 2024 18:41:35 -0800
In-Reply-To: <20240228024147.41573-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240228024147.41573-1-seanjc@google.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <20240228024147.41573-5-seanjc@google.com>
Subject: [PATCH 04/16] KVM: x86/mmu: Pass full 64-bit error code when handling
 page faults
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Isaku Yamahata <isaku.yamahata@intel.com>

Plumb the full 64-bit error code throughout the page fault handling code
so that KVM can use the upper 32 bits, e.g. SNP's PFERR_GUEST_ENC_MASK
will be used to determine whether or not a fault is private vs. shared.

Note, passing the 64-bit error code to FNAME(walk_addr)() does NOT change
the behavior of permission_fault() when invoked in the page fault path, as
KVM explicitly clears PFERR_IMPLICIT_ACCESS in kvm_mmu_page_fault().

Continue passing '0' from the async #PF worker, as guest_memfd() and thus
private memory doesn't support async page faults.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
[mdr: drop references/changes on rebase, update commit message]
Signed-off-by: Michael Roth <michael.roth@amd.com>
[sean: drop truncation in call to FNAME(walk_addr)(), rewrite changelog]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/mmu/mmu.c          | 3 +--
 arch/x86/kvm/mmu/mmu_internal.h | 4 ++--
 arch/x86/kvm/mmu/mmutrace.h     | 2 +-
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e2fd74e06ff8..408969ac1291 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5860,8 +5860,7 @@ int noinline kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 err
 	}
 
 	if (r == RET_PF_INVALID) {
-		r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa,
-					  lower_32_bits(error_code), false,
+		r = kvm_mmu_do_page_fault(vcpu, cr2_or_gpa, error_code, false,
 					  &emulation_type);
 		if (KVM_BUG_ON(r == RET_PF_INVALID, vcpu->kvm))
 			return -EIO;
diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 0eea6c5a824d..1fab1f2359b5 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -190,7 +190,7 @@ static inline bool is_nx_huge_page_enabled(struct kvm *kvm)
 struct kvm_page_fault {
 	/* arguments to kvm_mmu_do_page_fault.  */
 	const gpa_t addr;
-	const u32 error_code;
+	const u64 error_code;
 	const bool prefetch;
 
 	/* Derived from error_code.  */
@@ -288,7 +288,7 @@ static inline void kvm_mmu_prepare_memory_fault_exit(struct kvm_vcpu *vcpu,
 }
 
 static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
-					u32 err, bool prefetch, int *emulation_type)
+					u64 err, bool prefetch, int *emulation_type)
 {
 	struct kvm_page_fault fault = {
 		.addr = cr2_or_gpa,
diff --git a/arch/x86/kvm/mmu/mmutrace.h b/arch/x86/kvm/mmu/mmutrace.h
index ae86820cef69..195d98bc8de8 100644
--- a/arch/x86/kvm/mmu/mmutrace.h
+++ b/arch/x86/kvm/mmu/mmutrace.h
@@ -260,7 +260,7 @@ TRACE_EVENT(
 	TP_STRUCT__entry(
 		__field(int, vcpu_id)
 		__field(gpa_t, cr2_or_gpa)
-		__field(u32, error_code)
+		__field(u64, error_code)
 		__field(u64 *, sptep)
 		__field(u64, old_spte)
 		__field(u64, new_spte)
-- 
2.44.0.278.ge034bb2e1d-goog


