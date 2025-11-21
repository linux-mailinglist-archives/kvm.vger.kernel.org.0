Return-Path: <kvm+bounces-64090-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AFB6C78240
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 10:26:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id BB48332EA6
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 09:25:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1F5B342539;
	Fri, 21 Nov 2025 09:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="W0qaa46x"
X-Original-To: kvm@vger.kernel.org
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851272F363E;
	Fri, 21 Nov 2025 09:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763717029; cv=none; b=cQf+v4g32h+UW7yHz6ZQJ/Phdc8BGJUOKWRyBokgLZlEFpMcAeT2fE+2V8V0Qf9vCJcB1ewensvlCb0WUTmx9fcCgQpjRsg3jJ33lMTUI++hjOguSZyzdgMiSdCM4xLFiCGjJhDN/Nt/aPfGKOQoyqw1sft8eeGN9qu9/AS1LHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763717029; c=relaxed/simple;
	bh=QOaPSddJrhEQyce/cPvajTpXzTn+tjI4fHw3Qv/pDlM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jp7j6dCQm5XqQ1anuhKrVmITweXpSqZ3W/qel87WFMfcuWBKvA8yQTwgvhwkVzjWm3ttM1TSudyjIzhpKcrgaTttnc5F09HCS/w0vRO3Rmoh8o02nL9oz547fcxtCcA4GcK2UrhmUq9MUtCK4UA91qH9c5IcI2+P+fTMN1359ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=W0qaa46x; arc=none smtp.client-ip=113.46.200.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=aSmhSjVlXXSAOTMnlq2uU/cOCynmcE9Ef92ugEWwAf4=;
	b=W0qaa46xvizHT9Gu7lDEABADS4vTuORq1FbRVkx9UBjt3wRJTwB7YIe8+fmWixZM0YLuBSyD+
	2iqtZMjwWbSzIs4fPSmvFQvnMFFSTZht9yHIGLUayMzi50RK7dQe9/iVmnGZlczZIUOk5MHtJSK
	q5TOR0asMTh1EsGFZseqa3M=
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dCV924VvSzKmXQ;
	Fri, 21 Nov 2025 17:21:58 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 32376140295;
	Fri, 21 Nov 2025 17:23:44 +0800 (CST)
Received: from huawei.com (10.50.163.32) by kwepemr100010.china.huawei.com
 (7.202.195.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 21 Nov
 2025 17:23:43 +0800
From: Tian Zheng <zhengtian10@huawei.com>
To: <maz@kernel.org>, <oliver.upton@linux.dev>, <catalin.marinas@arm.com>,
	<corbet@lwn.net>, <pbonzini@redhat.com>, <will@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <zhengtian10@huawei.com>,
	<yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>, <yezhenyu2@huawei.com>,
	<xiexiangyou@huawei.com>, <zhengchuan@huawei.com>, <linuxarm@huawei.com>,
	<joey.gouly@arm.com>, <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
	<suzuki.poulose@arm.com>
Subject: [PATCH v2 2/5] KVM: arm64: Support set the DBM attr during memory abort
Date: Fri, 21 Nov 2025 17:23:39 +0800
Message-ID: <20251121092342.3393318-3-zhengtian10@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20251121092342.3393318-1-zhengtian10@huawei.com>
References: <20251121092342.3393318-1-zhengtian10@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr100010.china.huawei.com (7.202.195.125)

From: eillon <yezhenyu2@huawei.com>

Add DBM support to automatically promote write-clean pages to
write-dirty, preventing users from being trapped in EL2 due to
missing write permissions.

Since the DBM attribute was introduced in ARMv8.1 and remains
optional in later architecture revisions, including ARMv9.5.

Support set the DBM attr during user_mem_abort().

Signed-off-by: eillon <yezhenyu2@huawei.com>
Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 4 ++++
 arch/arm64/kvm/hyp/pgtable.c         | 6 ++++++
 2 files changed, 10 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 2888b5d03757..2fa24953d1a6 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -91,6 +91,8 @@ typedef u64 kvm_pte_t;

 #define KVM_PTE_LEAF_ATTR_HI_S2_XN	BIT(54)

+#define KVM_PTE_LEAF_ATTR_HI_S2_DBM	BIT(51)
+
 #define KVM_PTE_LEAF_ATTR_HI_S1_GP	BIT(50)

 #define KVM_PTE_LEAF_ATTR_S2_PERMS	(KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | \
@@ -245,6 +247,7 @@ enum kvm_pgtable_stage2_flags {
  * @KVM_PGTABLE_PROT_R:		Read permission.
  * @KVM_PGTABLE_PROT_DEVICE:	Device attributes.
  * @KVM_PGTABLE_PROT_NORMAL_NC:	Normal noncacheable attributes.
+ * @KVM_PGTABLE_PROT_DBM:	Dirty bit management attribute.
  * @KVM_PGTABLE_PROT_SW0:	Software bit 0.
  * @KVM_PGTABLE_PROT_SW1:	Software bit 1.
  * @KVM_PGTABLE_PROT_SW2:	Software bit 2.
@@ -257,6 +260,7 @@ enum kvm_pgtable_prot {

 	KVM_PGTABLE_PROT_DEVICE			= BIT(3),
 	KVM_PGTABLE_PROT_NORMAL_NC		= BIT(4),
+	KVM_PGTABLE_PROT_DBM			= BIT(5),

 	KVM_PGTABLE_PROT_SW0			= BIT(55),
 	KVM_PGTABLE_PROT_SW1			= BIT(56),
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index c351b4abd5db..ce41c6924ebe 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -694,6 +694,9 @@ static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot p
 	if (prot & KVM_PGTABLE_PROT_W)
 		attr |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;

+	if (prot & KVM_PGTABLE_PROT_DBM)
+		attr |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
+
 	if (!kvm_lpa2_is_enabled())
 		attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S2_SH, sh);

@@ -1303,6 +1306,9 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
 	if (prot & KVM_PGTABLE_PROT_W)
 		set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;

+	if (prot & KVM_PGTABLE_PROT_DBM)
+		set |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
+
 	if (prot & KVM_PGTABLE_PROT_X)
 		clr |= KVM_PTE_LEAF_ATTR_HI_S2_XN;

--
2.33.0


