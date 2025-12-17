Return-Path: <kvm+bounces-66144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B8F4DCC71F4
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 11:38:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1D041304C2B0
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 10:31:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD1343557E3;
	Wed, 17 Dec 2025 10:14:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82CBD355049;
	Wed, 17 Dec 2025 10:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765966469; cv=none; b=trtcpt6UqWKD0lGzW3hcc/YhGDCAqqX/K0wbLPpm/i2iNuKmS3OJ6ecXG2qCKjqiPHsIzDjzulSXVfyLnf6xoiBei+bM8LMGks4E4ckgmK0TR4fDLB/aDk4TzCrd6Oh5FFLyDIShvrN4Eb4MTpvXtHXT347i0d+PPmLrEGNNmno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765966469; c=relaxed/simple;
	bh=ewiyLDx1L7cn3+oZh4//VxrS1pilT9/HTRhgkorSti4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RA+d9WKRB3X9AI652CkGbrUmPzZ96DaVt++ihRtzIENMQPutyIapBE2Hw5xBzIDRS/uoXHnt43idXzgTarfCOkwog90BgqyWIl7WXboB2//D4eOx3uoq4RSTaHG+/DgxQYMlv+ed8QN+QGPlD+UuQE7vZzRsTxkUEc0Mpl+UXsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 01E4B1517;
	Wed, 17 Dec 2025 02:14:19 -0800 (PST)
Received: from e122027.arm.com (unknown [10.57.45.201])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 38B123F73B;
	Wed, 17 Dec 2025 02:14:22 -0800 (PST)
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
Subject: [PATCH v12 33/46] arm64: RMI: Always use 4k pages for realms
Date: Wed, 17 Dec 2025 10:11:10 +0000
Message-ID: <20251217101125.91098-34-steven.price@arm.com>
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

Guest_memfd doesn't yet natively support huge pages, and there are
currently difficulties for a VMM to manage huge pages efficiently so for
now always split up mappings to PTE (4k).

The two issues that need progressing before supporting huge pages for
realms are:

 1. guest_memfd needs to be able to allocate from an appropriate
    allocator which can provide huge pages.

 2. The VMM needs to be able to repurpose private memory for a shared
    mapping when the guest VM requests memory is transitioned. Because
    this can happen at a 4k granularity it isn't possible to
    free/reallocate while huge pages are in use. Allowing the VMM to
    mmap() the shared portion of a huge page would allow the huge page
    to be recreated when the memory is unshared and made protected again.

These two issues are not specific to realms and don't affect the realm
API, so for now just break everything down to 4k pages in the RMM
controlled stage 2. Future work can add huge page support without
changing the uAPI.

Signed-off-by: Steven Price <steven.price@arm.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
Changes since v7:
 * Rewritten commit message
---
 arch/arm64/kvm/mmu.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 860c42aabcf0..c30d7be27361 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1762,11 +1762,14 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	write_fault = kvm_is_write_fault(vcpu);
 
 	/*
-	 * Realms cannot map protected pages read-only
+	 * Realms cannot map protected pages read-only, also force PTE mappings
+	 * for Realms.
 	 * FIXME: It should be possible to map unprotected pages read-only
 	 */
-	if (vcpu_is_rec(vcpu))
+	if (vcpu_is_rec(vcpu)) {
 		write_fault = true;
+		force_pte = true;
+	}
 
 	exec_fault = kvm_vcpu_trap_is_exec_fault(vcpu);
 	VM_WARN_ON_ONCE(write_fault && exec_fault);
-- 
2.43.0


