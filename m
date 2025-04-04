Return-Path: <kvm+bounces-42703-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 640BCA7C46B
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 22:01:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E10C91B61D63
	for <lists+kvm@lfdr.de>; Fri,  4 Apr 2025 19:59:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DCB0226D11;
	Fri,  4 Apr 2025 19:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1pN65nSV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC65522578D
	for <kvm@vger.kernel.org>; Fri,  4 Apr 2025 19:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743795619; cv=none; b=Pd3MgJbTbyrJnph4DJ4wojBV+PNTyg0hK9eevGii81wF7bRr3DPxE5stA3NBgo+8uTT/dghzZXAw6OsaFSObwCErtWoFi3yifKpID4lcVrTKto02Lr/cDHVdRpqr0t7CRPXhCjegKlL5red3pFEziDx3Lt9cpR9CdU+pXadruOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743795619; c=relaxed/simple;
	bh=8CNUPuQxWruAqazLiQ2U7Se/O49wV/nzU7fAMxK6IVw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KBJz1oGtbOgmvR7g7rowtMkIuL3JIMYRD1SSIWyBdRqcvZ9xsBY7CLGicIPNfYaxmyjTs2/0Ifov3KJjFORJc1ahwAx9wBpPTaOSfXFukTgRb2tZVwXc+NpN5E0gKd1reoxspM8WWYaC7jw2UqYAbDLBS9s6sQk7aA+fyIVyKww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1pN65nSV; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-736c0306242so3285780b3a.1
        for <kvm@vger.kernel.org>; Fri, 04 Apr 2025 12:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743795616; x=1744400416; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=HPznh6CGxUFhqaGN+tuF1KZuEdkc3IM8iRC+hka4d9I=;
        b=1pN65nSVS2GahCTQdEV5p277Xunym8GA5pPvb3mn/dhq/gkiSaQhCvoTJzMv8QU/7H
         zUPbLfqdmda8r8bbWRYv6NS0eO2czKXIfhp9d5oqXhMAW4mO+DnCQKFjOsxmyRXIIDL2
         cHIO59zrJ9i7PnPN/wsPDdd55ZuU2UNGTH4mFao5NFM93BvKo0OnBTQ6By9Y/y2Nqwh/
         WxFKuu/x5xYPjmlG5+NTD/7mKfhidUoxjA1Zi8N/nuBKHSyAHT+0pej2Q3b0TWRxYi0z
         s/rIQpF8ELF0IleRujmCThprLJ2ryfnlvZ2cteXjrEQ/MCV2qAajZnUXW1lxCDgKfbD6
         hNQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743795616; x=1744400416;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HPznh6CGxUFhqaGN+tuF1KZuEdkc3IM8iRC+hka4d9I=;
        b=HoZm1l7hSabfKbZI7mL2/iWXiz4SuJ/vt1q5rUdbYj1/nVjd93/pBfyIK0W58ygobC
         XJjfjOgWJj4y63eysyPGkQfh59F0tKfzgXT+ZZjHTpSRyyK+B8aD6RRPowNqHzmUTBvI
         tDxSoQweqb248BumcMSpqmI6akDZcgzNX2dHkE8Mo6bzfNUlESqKaKZrolC8EftNjMj1
         oCVXOCCPJOM3AYLnmG8cmR9fydX9OohRPBXsWIGH803KUeithnTTzbXBQMyWlCrMxIwP
         s5DXOFE1dlYZmAyckWb+aZkt53Mk9Un39oC+g31Z/2xWvD+ArtrrrLzwgfzn+z5fPe2N
         uI3A==
X-Gm-Message-State: AOJu0YwVWFDFgiwLS63x/mSlnJLSwwriUFYqYdz7k3E7esqOyGPG+Cgj
	WTk1nxUxEp+iNXxjfkQuYiI1wRNVk34bhQcOGAuc6DSDYHUsHmfKrW/PdMzdwilAAuEWqt/e29G
	WVQ==
X-Google-Smtp-Source: AGHT+IHdDhY3q1PoCzEN393Qre591g1t5JRHt7vREsmAZfu9y83GvrelcK4mphnOUkWNilXZrFXu1h6Tod0=
X-Received: from pfbhb19.prod.google.com ([2002:a05:6a00:8593:b0:737:79:e096])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:244c:b0:736:546c:eb69
 with SMTP id d2e1a72fcca58-739e492c849mr5818791b3a.9.1743795616257; Fri, 04
 Apr 2025 12:40:16 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  4 Apr 2025 12:38:32 -0700
In-Reply-To: <20250404193923.1413163-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250404193923.1413163-1-seanjc@google.com>
X-Mailer: git-send-email 2.49.0.504.g3bcea36a83-goog
Message-ID: <20250404193923.1413163-18-seanjc@google.com>
Subject: [PATCH 17/67] KVM: SVM: Drop redundant check in AVIC code on ID
 during vCPU creation
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>, 
	Lu Baolu <baolu.lu@linux.intel.com>
Cc: kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	David Matlack <dmatlack@google.com>
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

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/avic.c | 47 +++++++++++++++++------------------------
 1 file changed, 19 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index ba8dfc8a12f4..344541e418c3 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -265,35 +265,19 @@ void avic_init_vmcb(struct vcpu_svm *svm, struct vmcb *vmcb)
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
-	 * hardware.  Do so immediately, i.e. don't defer the update via a
-	 * request, as avic_vcpu_load() expects to be called if and only if the
-	 * vCPU has fully initialized AVIC.  Immediately clear apicv_active,
-	 * as avic_vcpu_load() assumes avic_physical_id_cache is valid, i.e.
-	 * waiting until KVM_REQ_APICV_UPDATE is processed on the first KVM_RUN
-	 * will result in an NULL pointer deference when loading the vCPU.
+	 * hardware.  Immediately clear apicv_active, i.e. don't wait until the
+	 * KVM_REQ_APICV_UPDATE request is processed on the first KVM_RUN, as
+	 * avic_vcpu_load() expects to be called if and only if the vCPU has
+	 * fully initialized AVIC.
 	 */
 	if ((!x2avic_enabled && id > AVIC_MAX_PHYSICAL_ID) ||
 	    (id > X2AVIC_MAX_PHYSICAL_ID)) {
@@ -302,6 +286,9 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 		return 0;
 	}
 
+	BUILD_BUG_ON((AVIC_MAX_PHYSICAL_ID + 1) * sizeof(*table) > PAGE_SIZE ||
+		     (X2AVIC_MAX_PHYSICAL_ID + 1) * sizeof(*table) > PAGE_SIZE);
+
 	if (WARN_ON_ONCE(!vcpu->arch.apic->regs))
 		return -EINVAL;
 
@@ -320,9 +307,7 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 	}
 
 	/* Setting AVIC backing page address in the phy APIC ID table */
-	entry = avic_get_physical_id_entry(vcpu, id);
-	if (!entry)
-		return -EINVAL;
+	table = page_address(kvm_svm->avic_physical_id_table_page);
 
 	/* Note, fls64() returns the bit position, +1. */
 	BUILD_BUG_ON(__PHYSICAL_MASK_SHIFT >
@@ -330,9 +315,9 @@ static int avic_init_backing_page(struct kvm_vcpu *vcpu)
 
 	new_entry = avic_get_backing_page_address(svm) |
 		    AVIC_PHYSICAL_ID_ENTRY_VALID_MASK;
-	WRITE_ONCE(*entry, new_entry);
+	WRITE_ONCE(table[id], new_entry);
 
-	svm->avic_physical_id_cache = entry;
+	svm->avic_physical_id_cache = &table[id];
 
 	return 0;
 }
@@ -1018,6 +1003,9 @@ void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	if (WARN_ON(h_physical_id & ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK))
 		return;
 
+	if (WARN_ON_ONCE(!svm->avic_physical_id_cache))
+		return;
+
 	/*
 	 * No need to update anything if the vCPU is blocking, i.e. if the vCPU
 	 * is being scheduled in after being preempted.  The CPU entries in the
@@ -1058,6 +1046,9 @@ void avic_vcpu_put(struct kvm_vcpu *vcpu)
 
 	lockdep_assert_preemption_disabled();
 
+	if (WARN_ON_ONCE(!svm->avic_physical_id_cache))
+		return;
+
 	/*
 	 * Note, reading the Physical ID entry outside of ir_list_lock is safe
 	 * as only the pCPU that has loaded (or is loading) the vCPU is allowed
-- 
2.49.0.504.g3bcea36a83-goog


