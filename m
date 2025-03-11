Return-Path: <kvm+bounces-40717-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2872EA5B7B2
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 05:04:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A12B63AF746
	for <lists+kvm@lfdr.de>; Tue, 11 Mar 2025 04:04:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F0891EDA3A;
	Tue, 11 Mar 2025 04:03:40 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D3C1EB9F3;
	Tue, 11 Mar 2025 04:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741665820; cv=none; b=S3GNwz77NI0C6kOjLvzpDCo7BJULEGAagdJA76TWLeBo7ZhiEdu8aUat2sHD2cvdqgmAqSR3CIFA8lggLK8h/CVgpYCtCqHBqLVJ6qhL/h9LXxxcwwjuiYMGrSKY2gjRam4pn7omAniHpNH6TYi/Tth9mpaWXOB7iHdHOL3yrq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741665820; c=relaxed/simple;
	bh=lKUtWeeuuNv/3bGyvIabAKg3vG9/yt8By6iM12+PVJM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UPOt7iIUQFQ2sja9tOluLbrIlEWX0b0ZLibd1MX+PilZOKE9ioaAUvbAozPRS+fkbh4ATLZ2BkKkbd85JP1FtAhl6M49ztxaB3W0gdGSFnOZMhfsV/gciq2DxRnQkbiyvXmunvO8mB1rGQ0sNudIriW6i9k12OxLDgcdfPmBkwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4ZBgB24Y5cz27gBD;
	Tue, 11 Mar 2025 12:04:10 +0800 (CST)
Received: from kwepemj500003.china.huawei.com (unknown [7.202.194.33])
	by mail.maildlp.com (Postfix) with ESMTPS id D9D2C1A016C;
	Tue, 11 Mar 2025 12:03:35 +0800 (CST)
Received: from DESKTOP-KKJBAGG.huawei.com (10.174.178.32) by
 kwepemj500003.china.huawei.com (7.202.194.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 11 Mar 2025 12:03:34 +0800
From: Zhenyu Ye <yezhenyu2@huawei.com>
To: <maz@kernel.org>, <yuzenghui@huawei.com>, <will@kernel.org>,
	<oliver.upton@linux.dev>, <catalin.marinas@arm.com>, <joey.gouly@arm.com>
CC: <linux-kernel@vger.kernel.org>, <yezhenyu2@huawei.com>,
	<xiexiangyou@huawei.com>, <zhengchuan@huawei.com>, <wangzhou1@hisilicon.com>,
	<linux-arm-kernel@lists.infradead.org>, <kvm@vger.kernel.org>,
	<kvmarm@lists.linux.dev>
Subject: [PATCH v1 2/5] arm64/kvm: support set the DBM attr during memory abort
Date: Tue, 11 Mar 2025 12:03:18 +0800
Message-ID: <20250311040321.1460-3-yezhenyu2@huawei.com>
X-Mailer: git-send-email 2.22.0.windows.1
In-Reply-To: <20250311040321.1460-1-yezhenyu2@huawei.com>
References: <20250311040321.1460-1-yezhenyu2@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemj500003.china.huawei.com (7.202.194.33)

From: eillon <yezhenyu2@huawei.com>

Since the ARMv8, the page entry has supported the DBM attribute.
Support set the attr during user_mem_abort().

Signed-off-by: eillon <yezhenyu2@huawei.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 3 +++
 arch/arm64/kvm/hyp/pgtable.c         | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 6b9d274052c7..35648d7f08f5 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -86,6 +86,8 @@ typedef u64 kvm_pte_t;
 
 #define KVM_PTE_LEAF_ATTR_HI_S2_XN	BIT(54)
 
+#define KVM_PTE_LEAF_ATTR_HI_S2_DBM	BIT(51)
+
 #define KVM_PTE_LEAF_ATTR_HI_S1_GP	BIT(50)
 
 #define KVM_PTE_LEAF_ATTR_S2_PERMS	(KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | \
@@ -252,6 +254,7 @@ enum kvm_pgtable_prot {
 
 	KVM_PGTABLE_PROT_DEVICE			= BIT(3),
 	KVM_PGTABLE_PROT_NORMAL_NC		= BIT(4),
+	KVM_PGTABLE_PROT_DBM			= BIT(5),
 
 	KVM_PGTABLE_PROT_SW0			= BIT(55),
 	KVM_PGTABLE_PROT_SW1			= BIT(56),
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index df5cc74a7dd0..3ea6bdbc02a0 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -700,6 +700,9 @@ static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot p
 	if (prot & KVM_PGTABLE_PROT_W)
 		attr |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
 
+	if (prot & KVM_PGTABLE_PROT_DBM)
+		attr |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
+
 	if (!kvm_lpa2_is_enabled())
 		attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S2_SH, sh);
 
@@ -1309,6 +1312,9 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
 	if (prot & KVM_PGTABLE_PROT_W)
 		set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;
 
+	if (prot & KVM_PGTABLE_PROT_DBM)
+		set |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
+
 	if (prot & KVM_PGTABLE_PROT_X)
 		clr |= KVM_PTE_LEAF_ATTR_HI_S2_XN;
 
-- 
2.39.3


