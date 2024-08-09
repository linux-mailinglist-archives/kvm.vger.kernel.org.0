Return-Path: <kvm+bounces-23770-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0287094D6F1
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 21:09:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 80A8D1F22F88
	for <lists+kvm@lfdr.de>; Fri,  9 Aug 2024 19:09:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04EC619D084;
	Fri,  9 Aug 2024 19:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2aj6Uc0I"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE1519CD0E
	for <kvm@vger.kernel.org>; Fri,  9 Aug 2024 19:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723230244; cv=none; b=L1Gv1RWmIglj1dC0wyFnVxPICOemilbk6iaebT2ujMm5D+g9yFcmRQeXqDSEi2VV6iPqEcblTVOGUdHYg4tfgMlx2Dx9e1dhSfySVJGHNcN+SYcbWxoPp2AvyqSBynPTMUH5vEvkeeAysXwdIcXsYB5bqO5zGE9o9Slt7/gHAzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723230244; c=relaxed/simple;
	bh=wdr9ikZ2JhMxx8FpdS0bIMEmE4PRqH0Dmh2wTfd07I4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=quR07azwxuU/n5ta3ZzOFquuD/wLtY17vcn1TiN27vGuFxYjWDsTuBDNuzw0vGTFfbDA/5T3ArLecmzbvrhLNXfeI6lsnMhJp0ABsZt2Fxnj9Ha9ne8PuM4uGOXVHnTc1CRCfiy+9dpAG2ThT8MLTqXFj74RRhOK5fz2gyKMLVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2aj6Uc0I; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1fca868b53cso22260005ad.1
        for <kvm@vger.kernel.org>; Fri, 09 Aug 2024 12:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723230242; x=1723835042; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=hf4PmVOwr+xgGzCTD+kiITxVr7NtARshe+47djUw/5w=;
        b=2aj6Uc0IInxiJX19I7lJV4RpJs1v5/uEgbZQgFQkDhsJy88ojCNPP+nnq9l9yKT+mB
         b7DsWcVVuasuJ5W6oMUlMouj9lf6JxsowqjmKOWvGkmEs6dWEP/ow9MPOpPIRNYHQk9/
         9xiIrhBD1AAHx4inIH/3iFdo4mZnl0UYoA8UHbgr9amfpiPbwaXTGdQpjc9r1vmZF1QV
         51hfj4D/SiwzawxRihQiJ1/aA9nBk07e5yfdyQrsMpmDN4sEO3ybcWoOXlHcNi+yXFgs
         G4gTBObGpyfJYzb/txflIgwFXtKJLKkJoxiepvIGe0wrgY1EDhI18IRQQ0yaeZOWd+su
         YcTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723230242; x=1723835042;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hf4PmVOwr+xgGzCTD+kiITxVr7NtARshe+47djUw/5w=;
        b=qioZE6+C6VQ0fQIgmzM5To7HlGXr0NXiWqZZ8tw4rgLovWgGMbpfYl2o1HPx3eAcXP
         0bu8FylsPvzoYVTbHbakcT16vGbq7jUyD2kgBojHJmbagL2Py/fqB3vtuKuzpj/iV5CI
         BwDI6nTYRkw4V+Rd3F7yExQfd2AT5ZUiV8+YoDW44lnqzB3iKuYn9q3TjwU6km4XJPPA
         XrN1Zy43Kuu2Qg16pvEGNmSm8VcBdPGA6goo6yBM81QTgvDI41YMyS0TQDSOdpMSHVkU
         YaE2DxxNK+evNaQJS6Quojln+IbxiPqdc3tWhSYmXcFs1lr2xiK+TtBpCBu6TZKwrlmd
         24Fg==
X-Gm-Message-State: AOJu0YxFGZkxEAPqiVpGAwN/LEEckqWpAl4UXhOQE3NmnrElTOYvWSJJ
	fQ8t2E6PZa1ywRcte/tJOVUNTG6Te7Uxjvx2Yw7b/0+t4549E5t1Juh1Zfvj0hOWrQCjh+NYvLr
	r4w==
X-Google-Smtp-Source: AGHT+IGF6pq1ifYV6Vpt8CaGEEk4qft1uIN5zn189JX1iQA8F6BtQ2QllI81BNCavpgKD3Lyc31lvkGgw54=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:fa8e:b0:1f6:2964:17b8 with SMTP id
 d9443c01a7336-200ae584d14mr701195ad.10.1723230242082; Fri, 09 Aug 2024
 12:04:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  9 Aug 2024 12:03:16 -0700
In-Reply-To: <20240809190319.1710470-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240809190319.1710470-1-seanjc@google.com>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
Message-ID: <20240809190319.1710470-20-seanjc@google.com>
Subject: [PATCH 19/22] KVM: x86: Update retry protection fields when forcing
 retry on emulation failure
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Peter Gonda <pgonda@google.com>, Michael Roth <michael.roth@amd.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerly Tng <ackerleytng@google.com>
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
index 25a3d84ca5e2..b3a2793fc89c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2132,7 +2132,15 @@ int kvm_get_nr_pending_nmis(struct kvm_vcpu *vcpu);
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
index d3c0220ff7ee..59af085a6e8e 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -2731,22 +2731,24 @@ int kvm_mmu_unprotect_page(struct kvm *kvm, gfn_t gfn)
 	return r;
 }
 
-bool kvm_mmu_unprotect_gfn_and_retry(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa)
+bool __kvm_mmu_unprotect_gfn_and_retry(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
+				       bool always_retry)
 {
 	gpa_t gpa = cr2_or_gpa;
-	bool r;
+	bool r = false;
 
 	if (!vcpu->kvm->arch.indirect_shadow_pages)
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
index ddeda91b0530..65531768bb1e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8888,7 +8888,7 @@ static bool reexecute_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 	 * guest to let the CPU re-execute the instruction in the hope that the
 	 * CPU can cleanly execute the instruction that KVM failed to emulate.
 	 */
-	kvm_mmu_unprotect_gfn_and_retry(vcpu, cr2_or_gpa);
+	__kvm_mmu_unprotect_gfn_and_retry(vcpu, cr2_or_gpa, true);
 
 	/*
 	 * Retry even if _this_ vCPU didn't unprotect the gfn, as it's possible
-- 
2.46.0.76.ge559c4bf1a-goog


