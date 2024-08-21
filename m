Return-Path: <kvm+bounces-24763-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A4BA95A1C4
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 17:47:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C047B1C22CFC
	for <lists+kvm@lfdr.de>; Wed, 21 Aug 2024 15:47:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 235071C2DD7;
	Wed, 21 Aug 2024 15:40:43 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6433D1C2DCD;
	Wed, 21 Aug 2024 15:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724254842; cv=none; b=MsmVpd4eYp4LXqrNTtWm9fxAVDg7yGEQt4tq0XYPaOrkyTCn1AGxLzv3d02jlrSPqZbRtBNMkXvF+3OvAoVU4JKSrY36EH3/1sCzLsKcPVoySWoHR52j58OJ8WItEjti40ElbMfKdk7TGNomHxmc8hslNRjh56tRzbFch8BXfL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724254842; c=relaxed/simple;
	bh=7qzxI8Qlc0Z2RLMTqv9MTzVqfg4jitNEiOqnBGTUYNI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sJWyo077TXp7iTFS/C0LR/3dkeRC8r1xVywBBwTwOjiOnIwfxdULSMh8mqYEdDtv4RMHdFuv36OOcvu8i4PrT7GUNJ1QHTuMx/QM6+wF0Y6F2WV2QTUmLT6vYVPuTJP7RSzMmgU4b8sGuo+O+SK2JIjo6pL1gy22feAde7Ct+ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 222D9152B;
	Wed, 21 Aug 2024 08:41:07 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.37.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 065403F73B;
	Wed, 21 Aug 2024 08:40:37 -0700 (PDT)
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
	Alper Gun <alpergun@google.com>
Subject: [PATCH v4 26/43] arm64: Don't expose stolen time for realm guests
Date: Wed, 21 Aug 2024 16:38:27 +0100
Message-Id: <20240821153844.60084-27-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240821153844.60084-1-steven.price@arm.com>
References: <20240821153844.60084-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It doesn't make much sense as a realm guest wouldn't want to trust the
host. It will also need some extra work to ensure that KVM will only
attempt to write into a shared memory region. So for now just disable
it.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/kvm/arm.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index c57ed4f41bbc..2d7cbd4a2483 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -429,7 +429,10 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = system_supports_mte();
 		break;
 	case KVM_CAP_STEAL_TIME:
-		r = kvm_arm_pvtime_supported();
+		if (kvm_is_realm(kvm))
+			r = 0;
+		else
+			r = kvm_arm_pvtime_supported();
 		break;
 	case KVM_CAP_ARM_EL1_32BIT:
 		r = cpus_have_final_cap(ARM64_HAS_32BIT_EL1);
-- 
2.34.1


