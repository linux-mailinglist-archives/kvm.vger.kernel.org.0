Return-Path: <kvm+bounces-66157-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C41ECC70F4
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 11:24:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AC45B30F0399
	for <lists+kvm@lfdr.de>; Wed, 17 Dec 2025 10:19:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A91135C1A0;
	Wed, 17 Dec 2025 10:15:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0BDE34887E;
	Wed, 17 Dec 2025 10:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765966528; cv=none; b=FLvEjwfYr2hIdqzQXGz5MI0VA8HLtDNx97aht7/XZxYtJqDjXPH6ghVPvjiXRM8vdri4z+VICTv0JYncH29E3zjkkJuWC2kd5Xvuw4xcZDcbCGAoEwnhYCZOlSHwBplRbC2Q9TSpNyMxKIs2Q/jCafKZJtP6d9s/jBmK8VLW26w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765966528; c=relaxed/simple;
	bh=pfEQxGpqo68tykdJuEB/jGA/uQDnF4mmqKQ1HTwBtf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h6EMODKPkX14kueOdgrToknw0WG2lWNAJ8Ad53ddiZyNC9cIU2ogGAC6xEUGSsfLNAFAcw+tQOWYKwm7XOyKuh0+wUMW3lDfrYjYwEWykQETVzmTPrSEKwA0075BDFw6vJ8hMyiSwMKSKSVR/ynGxSq+728GH8b0/WFPREosQlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 277C11517;
	Wed, 17 Dec 2025 02:15:20 -0800 (PST)
Received: from e122027.arm.com (unknown [10.57.45.201])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D7AA13F73B;
	Wed, 17 Dec 2025 02:15:22 -0800 (PST)
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
Subject: [PATCH v12 46/46] arm64: RMI: Enable realms to be created
Date: Wed, 17 Dec 2025 10:11:23 +0000
Message-ID: <20251217101125.91098-47-steven.price@arm.com>
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

All the pieces are now in place, so enable kvm_rmi_is_available when the
RMM is detected.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/kvm/rmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
index 657d70eab0ab..0e470f31d46a 100644
--- a/arch/arm64/kvm/rmi.c
+++ b/arch/arm64/kvm/rmi.c
@@ -1659,5 +1659,5 @@ void kvm_init_rmi(void)
 	if (rmi_vmid_init())
 		return;
 
-	/* Future patch will enable static branch kvm_rmi_is_available */
+	static_branch_enable(&kvm_rmi_is_available);
 }
-- 
2.43.0


