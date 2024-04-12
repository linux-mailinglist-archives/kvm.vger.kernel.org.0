Return-Path: <kvm+bounces-14475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CF7948A2A1B
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 11:01:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0CAAB1C20A5F
	for <lists+kvm@lfdr.de>; Fri, 12 Apr 2024 09:01:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78D1B55E7B;
	Fri, 12 Apr 2024 08:45:02 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCA20135A68;
	Fri, 12 Apr 2024 08:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712911502; cv=none; b=lwEsVdjz2HicJDdTQBH0MmGa2afyGXrrbTpVPsI37kgM2BqJw6YaIV81qn4h5T4RfwgrFrem2bYOE6rdeeXlosHUyuWJp0QlLzLh26aGQcdh6oiaB5OUMFwgXYEOMvgdBh5oeAdI+kJemdC0rAi3X2u3r2MC3b7ZMI3ggKRl3t0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712911502; c=relaxed/simple;
	bh=D/cy798s+xsV45CJTqoGeQMFhiJNyrqboCxmbKmTJgo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PHnmaLl2+1A6l28jQFqDvDdUEvvM+MskYS+YW9lxTBNuVjRAap51w40qg1oWZ7Q+P9o3cgdc5kd5maUl8UklNIAKzFlytpn8Sd4MuXTk+Ro3mhOZlmqQuTYnQrsLBWFL59q9xpHA53KjJIuptSTllqZTjlwRwQBvMqXdgtXNnrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B12CC339;
	Fri, 12 Apr 2024 01:45:29 -0700 (PDT)
Received: from e112269-lin.cambridge.arm.com (e112269-lin.cambridge.arm.com [10.1.194.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 551093F6C4;
	Fri, 12 Apr 2024 01:44:58 -0700 (PDT)
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
Subject: [PATCH v2 43/43] KVM: arm64: Allow activating realms
Date: Fri, 12 Apr 2024 09:43:09 +0100
Message-Id: <20240412084309.1733783-44-steven.price@arm.com>
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

Add the ioctl to activate a realm and set the static branch to enable
access to the realm functionality if the RMM is detected.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/kvm/rme.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
index 93aab6caddf5..5901d57ca9d0 100644
--- a/arch/arm64/kvm/rme.c
+++ b/arch/arm64/kvm/rme.c
@@ -1167,6 +1167,20 @@ static int kvm_init_ipa_range_realm(struct kvm *kvm,
 	return ret;
 }
 
+static int kvm_activate_realm(struct kvm *kvm)
+{
+	struct realm *realm = &kvm->arch.realm;
+
+	if (kvm_realm_state(kvm) != REALM_STATE_NEW)
+		return -EINVAL;
+
+	if (rmi_realm_activate(virt_to_phys(realm->rd)))
+		return -ENXIO;
+
+	WRITE_ONCE(realm->state, REALM_STATE_ACTIVE);
+	return 0;
+}
+
 /* Protects access to rme_vmid_bitmap */
 static DEFINE_SPINLOCK(rme_vmid_lock);
 static unsigned long *rme_vmid_bitmap;
@@ -1314,6 +1328,9 @@ int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
 		r = kvm_populate_realm(kvm, &args);
 		break;
 	}
+	case KVM_CAP_ARM_RME_ACTIVATE_REALM:
+		r = kvm_activate_realm(kvm);
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -1567,7 +1584,7 @@ int kvm_init_rme(void)
 	if (ret)
 		return ret;
 
-	/* Future patch will enable static branch kvm_rme_is_available */
+	static_branch_enable(&kvm_rme_is_available);
 
 	return 0;
 }
-- 
2.34.1


