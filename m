Return-Path: <kvm+bounces-47461-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 66FB2AC1925
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 03:04:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 41174A46F29
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 01:03:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5A3A225785;
	Fri, 23 May 2025 01:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LS6ivXm4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5D4223DFD
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 01:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747962031; cv=none; b=qE+JAzglBnLJzmC/JYpWoeN114dE8YhQfBJv8G9oaqwkMiUT8diggSSpv8WrhORhaAB7oOZiKP/OQe9eRPEvS8rsnXiHQ3P+C3GeWATYNAGGlzplY2cUmhOsX7ODMG6oTwTcNNF0/YhIVfH1B+GyRRrYbUvoVYgsyorr9KXz7ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747962031; c=relaxed/simple;
	bh=NmtIJk+NXuVQcgcHe/OX20tZuAMC4d7N9CttC/YW7ug=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nmBTlbgl42rsA+78H5Ac2WYH5WezIA7FL57Uxd+7cLWyw8Ph2jpFGvyUCax6dpGGqRz75EO1ZGl76QlW77Aak0sR7Leqh8Eo+6jp/v6QCafgKuM9gHi/DQYJrFLhSYV2NT90dBA8jKD/k0L9d/D7xUH+YhvOQsFi5Popqwyhzmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LS6ivXm4; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7391d68617cso316891b3a.0
        for <kvm@vger.kernel.org>; Thu, 22 May 2025 18:00:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747962029; x=1748566829; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=qvU0dOld0vUayuYrP2inmYflxGewHdZ05MuEuDFSsRI=;
        b=LS6ivXm4+EuxV06RRub16zmjsAur9w9j1STj5RDLyNoK1D95vro+b6HY+jHGsM9wcz
         0xFIzZnnApw+DVIIYGPOo/JEc2P8Omle85GpnJyEJCYNEwgqPSGEqEh4RqLxCaMBMWy4
         JqEzXqpQriICcesSGOxy6T6yDYjjcIlYtbMnKqx5M4s6mJjMOMM/cflZ3TXbzaghtLQk
         lq4h+u1J2p215u/ZnKoF94aJFLI9EMks+jS7A+VWXMVPLTCQS6Jd3eZsvto8HnIjPDa7
         901tcZUr/tl18xWwbiLLMPEO7q22xE9QKllJLgfbj5yGlRcD6fQUtY7w7fw9zOAEEYyh
         TI/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747962029; x=1748566829;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qvU0dOld0vUayuYrP2inmYflxGewHdZ05MuEuDFSsRI=;
        b=ZUIQEwWkm4oztUCL6UrL02OZXP7wFWS7p32/uUilS5gLLLu0KDXSrDV7MTlyyrL1pj
         atTCyAhcFYQJJKyfPwfHDXBxgyzBZ+d09GHB38ehC+ohrbUyZtRT/kvVuiRJ6awdy/jE
         HDaKy9iJHPu0raHUDiR03SW3b4wgNXhw/lz9gvB7F7oUtRnkbfaWC9b2+U6HnFM5Kq9k
         7hgjt3bWZa+i8X1Aa2Mkt4w0LAuilZbQedWDMbRrXeqzGxKrARpVB6AO9QZ7TnQuW++V
         C+OVg7f8fdGfX9t/saFNu+4UGp7O5nNuwRRPldbhF/SglkchXkyd+qf0zXl5LyVU6/ly
         2+Iw==
X-Gm-Message-State: AOJu0YzuCtT2uAtvlMbczrwKPP6jWv4wiZ4nHJYgQQKxEJDXF3pYyci2
	ZFjIHjyIRg5hIrg6Eob3fJ0YwlFHQAwVbjfWLbsqZ1n5xhs+YHMckpcFj01lBxqHXvVRFJNCold
	oxpDxQg==
X-Google-Smtp-Source: AGHT+IHUAkRGBcbeHEZC8d5MhipzP08zCSRQ2GxGmkCxhyIuuWUqgFNrdbfXKGFZCAm/KodkxoGK3IgwYXs=
X-Received: from pgah21.prod.google.com ([2002:a05:6a02:4e95:b0:b26:f984:15bc])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:78e:b0:1f0:e6db:b382
 with SMTP id adf61e73a8af0-21877a3a205mr2221344637.8.1747962029662; Thu, 22
 May 2025 18:00:29 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 22 May 2025 17:59:16 -0700
In-Reply-To: <20250523010004.3240643-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250523010004.3240643-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.1151.ga128411c76-goog
Message-ID: <20250523010004.3240643-12-seanjc@google.com>
Subject: [PATCH v2 11/59] KVM: SVM: Drop redundant check in AVIC code on ID
 during vCPU creation
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"

Drop avic_get_physical_id_entry()'s compatibility check on the incoming
ID, as its sole caller, avic_init_backing_page(), performs the exact same
check.  Drop avic_get_physical_id_entry() entirely as the only remaining
functionality is getting the address of the Physical ID table, and
accessing the array without an immediate bounds check is kludgy.

Opportunistically add a compile-time assertion to ensure the vcpu_id can't
result in a bounds overflow, e.g. if KVM (really) messed up a maximum
physical ID #define, as well as run-time assertions so that a NULL pointer
dereference is morphed into a safer WARN().

No functional change intended.

Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 37 +++++++++++++++----------------------
 1 file changed, 15 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index f0a74b102c57..948bab48083b 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -256,26 +256,12 @@ void avic_init_vmcb(struct vcpu_svm *svm, struct vmcb *vmcb)
 		avic_deactivate_vmcb(svm);
 }
 
-static u64 *avic_get_physical_id_entry(struct kvm_vcpu *vcpu,
-				       unsigned int index)
-{
-	u64 *avic_physical_id_table;
-	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
-
-	if ((!x2avic_enabled && index > AVIC_MAX_PHYSICAL_ID) ||
-	    (index > X2AVIC_MAX_PHYSICAL_ID))
-		return NULL;
-
-	avic_physical_id_table = page_address(kvm_svm->avic_physical_id_table_page);
-
-	return &avic_physical_id_table[index];
-}
-
 static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 {
-	u64 *entry, new_entry;
-	int id = vcpu->vcpu_id;
+	struct kvm_svm *kvm_svm = to_kvm_svm(vcpu->kvm);
 	struct vcpu_svm *svm = to_svm(vcpu);
+	u32 id = vcpu->vcpu_id;
+	u64 *table, new_entry;
 
 	/*
 	 * Inhibit AVIC if the vCPU ID is bigger than what is supported by AVIC
@@ -291,6 +277,9 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 		return 0;
 	}
 
+	BUILD_BUG_ON((AVIC_MAX_PHYSICAL_ID + 1) * sizeof(*table) > PAGE_SIZE ||
+		     (X2AVIC_MAX_PHYSICAL_ID + 1) * sizeof(*table) > PAGE_SIZE);
+
 	if (WARN_ON_ONCE(!vcpu->arch.apic->regs))
 		return -EINVAL;
 
@@ -309,9 +298,7 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 	}
 
 	/* Setting AVIC backing page address in the phy APIC ID table */
-	entry = avic_get_physical_id_entry(vcpu, id);
-	if (!entry)
-		return -EINVAL;
+	table = page_address(kvm_svm->avic_physical_id_table_page);
 
 	/* Note, fls64() returns the bit position, +1. */
 	BUILD_BUG_ON(__PHYSICAL_MASK_SHIFT >
@@ -319,9 +306,9 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 
 	new_entry = avic_get_backing_page_address(svm) |
 		    AVIC_PHYSICAL_ID_ENTRY_VALID_MASK;
-	WRITE_ONCE(*entry, new_entry);
+	WRITE_ONCE(table[id], new_entry);
 
-	svm->avic_physical_id_cache = entry;
+	svm->avic_physical_id_cache = &table[id];
 
 	return 0;
 }
@@ -1004,6 +991,9 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	if (WARN_ON(h_physical_id & ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK))
 		return;
 
+	if (WARN_ON_ONCE(!svm->avic_physical_id_cache))
+		return;
+
 	/*
 	 * No need to update anything if the vCPU is blocking, i.e. if the vCPU
 	 * is being scheduled in after being preempted.  The CPU entries in the
@@ -1044,6 +1034,9 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
 
 	lockdep_assert_preemption_disabled();
 
+	if (WARN_ON_ONCE(!svm->avic_physical_id_cache))
+		return;
+
 	/*
 	 * Note, reading the Physical ID entry outside of ir_list_lock is safe
 	 * as only the pCPU that has loaded (or is loading) the vCPU is allowed
-- 
2.49.0.1151.ga128411c76-goog


