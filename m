Return-Path: <kvm+bounces-66145-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B0E1CC71D3
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 11:36:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 251C531285DF
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 10:28:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53090355812;
	Wed, 17 Dec 2025 10:14:32 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 842EE3557F6;
	Wed, 17 Dec 2025 10:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765966471; cv=none; b=FomvVpI1zssfok5VYO5bPxunqvyAFGNM8VHdFlTLZfIBp/P3hjtPLjVm9rvfXmDqecfHDxXAuIj2uMR916bVDgAYqBZDasT3KZpZhKjygAax8iZaksQ4gpf6i41KfujNiZVOkL2jfQGJdL444HnAI79k7P/sIlUZE/frz7DIeQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765966471; c=relaxed/simple;
	bh=rdPt8xNcSUP/UQ/AbU+k+qgPVbeD+q1e322e9EPsXMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KZKJ9rozFeR00HCUpWNI9h9/WGVzXve9QB95/3YJHq3sdLXFiK7+Y7bToRCQcUqQItjjaCcf8nGXuFhzm+fCEFg3VG3YaoNQaWuoTHQEAgBGuY/DCKKaEFFUThqYSJwK5EE1zjzG1aEeqRHG0PocsudBJEvxrHMyCtiwXKfDUGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 097FD168F;
	Wed, 17 Dec 2025 02:14:23 -0800 (PST)
Received: from e122027.arm.com (unknown [10.57.45.201])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 731543F73B;
	Wed, 17 Dec 2025 02:14:26 -0800 (PST)
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>
Subject: [PATCH v12 34/46] arm64: RMI: Prevent Device mappings for Realms
Date: Wed, 17 Dec 2025 10:11:11 +0000
Message-ID: <20251217101125.91098-35-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251217101125.91098-1-steven.price@arm.com>
References: <20251217101125.91098-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Physical device assignment is not supported by RMM v1.0, so it
doesn't make much sense to allow device mappings within the realm.
Prevent them when the guest is a realm.

Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes from v6:
 * Fix the check in user_mem_abort() to prevent all pages that are not
   guest_memfd() from being mapped into the protected half of the IPA.
Changes from v5:
 * Also prevent accesses in user_mem_abort()
---
 arch/arm64/kvm/mmu.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index c30d7be27361..e71ef41fb6b1 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1221,6 +1221,10 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 	if (is_protected_kvm_enabled())
 		return -EPERM;
 
+	/* We don't support mapping special pages into a Realm */
+	if (kvm_is_realm(kvm))
+		return -EPERM;
+
 	size += offset_in_page(guest_ipa);
 	guest_ipa &= PAGE_MASK;
 
@@ -1955,6 +1959,15 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		return ret;
 	}
 
+	/*
+	 * For now we shouldn't be hitting protected addresses because they are
+	 * handled in private_memslot_fault(). In the future this check may be
+	 * relaxed to support e.g. protected devices.
+	 */
+	if (vcpu_is_rec(vcpu) &&
+	    kvm_gpa_from_fault(kvm, fault_ipa) == fault_ipa)
+		return -EINVAL;
+
 	if (nested)
 		adjust_nested_fault_perms(nested, &prot, &writable);
 
-- 
2.43.0


