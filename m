Return-Path: <kvm+bounces-14463-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A1058A29F4
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 10:57:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C594A1C20EAB
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 08:57:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37FD612C467;
	Fri, 12 Apr 2024 08:44:33 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9745D54BFE;
	Fri, 12 Apr 2024 08:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712911472; cv=none; b=Le+IiAQEBwDMj4vydkby/XdcdeNMurhtHpNpisD98CCFdHhOh6AUk/++YT71PLSTDWVV5Mlz8ChgP+nANX1+vFRvdmLtvn+eAbIxdEQTsCXJUye2WbbiKXRpQFz4Il01cW2/w5cn1vZWLqZbVG3XJ1dvfcsTOKIsma0KEIWRrv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712911472; c=relaxed/simple;
	bh=p1GPbEcvSRMPcOf4kG5PcM1bf/rdOw/qNnygDCUekK8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rjBm3Bkb5VeJ/eJ/u/AzoWZkbXaiOEKMmnrZFutMDaooGd5c4iLBaMKIY5kvtkn3pI8kVcsR7eV0tanJvp6A1kqndiRBWcC24CpoCztFUPucneCDJn5B/K8ov01V6CkBxT8cBAuCsjA0ImV+TImXRmJ30JwnsngY0ijuX30e1uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8B65C113E;
	Fri, 12 Apr 2024 01:45:00 -0700 (PDT)
Received: from e112269-lin.cambridge.arm.com (e112269-lin.cambridge.arm.com [10.1.194.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2F9883F6C4;
	Fri, 12 Apr 2024 01:44:29 -0700 (PDT)
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
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH v2 31/43] arm64: rme: Prevent Device mappings for Realms
Date: Fri, 12 Apr 2024 09:42:57 +0100
Message-Id: <20240412084309.1733783-32-steven.price@arm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240412084309.1733783-1-steven.price@arm.com>
References: <20240412084056.1733704-1-steven.price@arm.com>
 <20240412084309.1733783-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Physical device assignment is not yet supported by the RMM, so it
doesn't make much sense to allow device mappings within the realm.
Prevent them when the guest is a realm.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/kvm/mmu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index d891fc3c1a10..48c957e21c83 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1101,6 +1101,10 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
 	if (is_protected_kvm_enabled())
 		return -EPERM;
 
+	/* We don't support mapping special pages into a Realm */
+	if (kvm_is_realm(kvm))
+		return -EINVAL;
+
 	size += offset_in_page(guest_ipa);
 	guest_ipa &= PAGE_MASK;
 
-- 
2.34.1


