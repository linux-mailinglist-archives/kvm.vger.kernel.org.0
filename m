Return-Path: <kvm+bounces-38076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C875A34A3A
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 17:40:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7ACD63B439A
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2025 16:29:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5722F24BC11;
	Thu, 13 Feb 2025 16:18:13 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B90F270EC4;
	Thu, 13 Feb 2025 16:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739463492; cv=none; b=jrbLzJPtnbfpAVv2s0Kn/zCgBtfy20xbxJIthB5UXXT3nk2Xww8ya8gZElEfoh2vvVA+/Xj9h+m7fu8E7dcAVWpMX5HbiPD6vBkCkSEVHYEBS3sMpULIBbrilQiKIO5VCmbldZ4WVGZBrUx0UoruAB/o8ZdBvYeodXRDS6UY+20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739463492; c=relaxed/simple;
	bh=AI55fZuPVUZGp2C0JL68eLNSM71xTAytlCMCsAaP3qo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IB2gnuwhDMrX51T+08xPk236hWIrJAwrKae29snOXbb4YfPUt+J38lViKRk45AnmwlaKfMv2R61OJoVmEeHTx/vhnYXgc4wIDOA16ma/nlcwmIhene3+GrgjrnVmvA4R76/hypR9/4t1e8/WSJ25qpJ9+8gN6+/pYqCrh8ycTc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9BC2226BA;
	Thu, 13 Feb 2025 08:18:31 -0800 (PST)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.32.44])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 180C73F6A8;
	Thu, 13 Feb 2025 08:18:06 -0800 (PST)
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
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
Subject: [PATCH v7 45/45] WIP: Enable support for PAGE_SIZE>4k
Date: Thu, 13 Feb 2025 16:14:25 +0000
Message-ID: <20250213161426.102987-46-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250213161426.102987-1-steven.price@arm.com>
References: <20250213161426.102987-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We now support host page sizes greater than 4k. For this to work
reliably the guest must be enlightened enough to make sharing requests
at a granule at least as big as the host. Which today means the guests
PAGE_SIZE must be equal or greater than the host.

Note that RTT tables are still allocated using the host's page size, so
most of the page will be wasted as only the first 4k are actually
delegated to the RMM. This is the main reason why this is still WIP - I
haven't yet implemented an appropriate allocator for this.

Large page sizes are also only very minimally tested, so expect bugs!

Signed-off-by: Steven Price <steven.price@arm.com>
---
New patch for v7
---
 arch/arm64/kvm/rme.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
index a3eddf6917ad..4ae348ee9376 100644
--- a/arch/arm64/kvm/rme.c
+++ b/arch/arm64/kvm/rme.c
@@ -144,6 +144,7 @@ static int find_map_level(struct realm *realm,
 	return level;
 }
 
+/* FIXME: This conflates pages and granules */
 static phys_addr_t alloc_delegated_granule(struct kvm_mmu_memory_cache *mc)
 {
 	phys_addr_t phys = PHYS_ADDR_MAX;
@@ -171,6 +172,7 @@ static phys_addr_t alloc_delegated_granule(struct kvm_mmu_memory_cache *mc)
 	return phys;
 }
 
+/* FIXME: This conflates pages and granules */
 static void free_delegated_granule(phys_addr_t phys)
 {
 	if (WARN_ON(rmi_granule_undelegate(phys))) {
@@ -1694,10 +1696,6 @@ int kvm_init_realm_vm(struct kvm *kvm)
 
 void kvm_init_rme(void)
 {
-	if (PAGE_SIZE != SZ_4K)
-		/* Only 4k page size on the host is supported */
-		return;
-
 	if (rmi_check_version())
 		/* Continue without realm support */
 		return;
-- 
2.43.0


