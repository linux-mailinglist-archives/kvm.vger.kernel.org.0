Return-Path: <kvm+bounces-71774-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aGvqBaF1nmnCVQQAu9opvQ
	(envelope-from <kvm+bounces-71774-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 05:08:01 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F6821917C2
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 05:08:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 06E9F3114702
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 04:04:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBE7A288517;
	Wed, 25 Feb 2026 04:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="B2y451HU";
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="B2y451HU"
X-Original-To: kvm@vger.kernel.org
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A43155C82;
	Wed, 25 Feb 2026 04:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771992288; cv=none; b=bnYkM7mLIU5ZyqH0Ete27Q6D+Z/K9wB2oQCqOe3EvchOhVSdMlMkjNeZ/SdCnt/9w6M65KgNRiof0lrBS9X1xKzkqSCiGmy0Bz0mn8tvM7+Pxdze+GDzSaSxuqpC0NSKex/ouI3Z4cqsynitR2yf/MpnUo3DUzG74/xxWYVOG90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771992288; c=relaxed/simple;
	bh=voEJcoQCKNtyb+28m9h9kyPfcUdhzcknOw2borK/8qI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fbkC8G3CwkIulBSoIWn923lV3dgGuPwRDbw9pZ5sSSDw7W7w8rLejH4erot3Dkx1AWqqsMfQjTr91qnHEe/C4o1n18Em67AWyXrQZ1a8X83HGIU19yWVTEpDTRIps8V/GfqFTyJT6Cuk0dgKvzAXAeprnXTt9OBK/QAwM0GdqII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=B2y451HU; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=B2y451HU; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ZRrDjoJKZySvl4mUR1OtU1XI2sBKG1GkryYlKYWQWdg=;
	b=B2y451HUycQ9dcUrfiQGE84kOB1DQQPxwuGjiHjatdRVbuiM5t21r6bOcOWsZMnfO2zxYtRqZ
	4waQ7AJgdgXOfVQXyhaUMQudgfARDi46NUtrOXb5wX0OwyixXyEYAmd0WKydaHAyjroS7a1Njfr
	io/9+BLba68wVqGTeAVNpbI=
Received: from canpmsgout04.his.huawei.com (unknown [172.19.92.133])
	by szxga01-in.huawei.com (SkyGuard) with ESMTPS id 4fLLZ62g2tz1BFqR;
	Wed, 25 Feb 2026 12:04:14 +0800 (CST)
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ZRrDjoJKZySvl4mUR1OtU1XI2sBKG1GkryYlKYWQWdg=;
	b=B2y451HUycQ9dcUrfiQGE84kOB1DQQPxwuGjiHjatdRVbuiM5t21r6bOcOWsZMnfO2zxYtRqZ
	4waQ7AJgdgXOfVQXyhaUMQudgfARDi46NUtrOXb5wX0OwyixXyEYAmd0WKydaHAyjroS7a1Njfr
	io/9+BLba68wVqGTeAVNpbI=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4fLLSl4bvKz1prKZ;
	Wed, 25 Feb 2026 11:59:35 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id B463A40569;
	Wed, 25 Feb 2026 12:04:24 +0800 (CST)
Received: from huawei.com (10.50.163.32) by kwepemr100010.china.huawei.com
 (7.202.195.125) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.36; Wed, 25 Feb
 2026 12:04:23 +0800
From: Tian Zheng <zhengtian10@huawei.com>
To: <maz@kernel.org>, <oupton@kernel.org>, <catalin.marinas@arm.com>,
	<corbet@lwn.net>, <pbonzini@redhat.com>, <will@kernel.org>,
	<zhengtian10@huawei.com>
CC: <yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>,
	<liuyonglong@huawei.com>, <Jonathan.Cameron@huawei.com>,
	<yezhenyu2@huawei.com>, <linuxarm@huawei.com>, <joey.gouly@arm.com>,
	<kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <skhan@linuxfoundation.org>,
	<suzuki.poulose@arm.com>, <leo.bras@arm.com>
Subject: [PATCH v3 2/5] KVM: arm64: Add support to set the DBM attr during memory abort
Date: Wed, 25 Feb 2026 12:04:18 +0800
Message-ID: <20260225040421.2683931-3-zhengtian10@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20260225040421.2683931-1-zhengtian10@huawei.com>
References: <20260225040421.2683931-1-zhengtian10@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemr100010.china.huawei.com (7.202.195.125)
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[huawei.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[huawei.com:s=dkim];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71774-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_NONE(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[zhengtian10@huawei.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,huawei.com:mid,huawei.com:dkim,huawei.com:email];
	DKIM_TRACE(0.00)[huawei.com:+];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_TWELVE(0.00)[22];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 9F6821917C2
X-Rspamd-Action: no action

From: eillon <yezhenyu2@huawei.com>

This patch adds support to set the DBM (Dirty Bit Modifier) attribute
in S2 PTE during user_mem_abort(). This bit, introduced in ARMv8.1,
enables hardware to automatically promote write-clean pages to write-dirty.
This prevents the guest from being trapped in EL2 due to missing write
permissions.

Signed-off-by: eillon <yezhenyu2@huawei.com>
Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 4 ++++
 arch/arm64/kvm/hyp/pgtable.c         | 6 ++++++
 2 files changed, 10 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index c201168f2857..d0f280972a7a 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -93,6 +93,8 @@ typedef u64 kvm_pte_t;

 #define KVM_PTE_LEAF_ATTR_HI_S2_XN	GENMASK(54, 53)

+#define KVM_PTE_LEAF_ATTR_HI_S2_DBM	BIT(51)
+
 #define KVM_PTE_LEAF_ATTR_HI_S1_GP	BIT(50)

 #define KVM_PTE_LEAF_ATTR_S2_PERMS	(KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R | \
@@ -248,6 +250,7 @@ enum kvm_pgtable_stage2_flags {
  * @KVM_PGTABLE_PROT_R:		Read permission.
  * @KVM_PGTABLE_PROT_DEVICE:	Device attributes.
  * @KVM_PGTABLE_PROT_NORMAL_NC:	Normal noncacheable attributes.
+ * @KVM_PGTABLE_PROT_DBM:	Dirty bit management attribute.
  * @KVM_PGTABLE_PROT_SW0:	Software bit 0.
  * @KVM_PGTABLE_PROT_SW1:	Software bit 1.
  * @KVM_PGTABLE_PROT_SW2:	Software bit 2.
@@ -263,6 +266,7 @@ enum kvm_pgtable_prot {

 	KVM_PGTABLE_PROT_DEVICE			= BIT(4),
 	KVM_PGTABLE_PROT_NORMAL_NC		= BIT(5),
+	KVM_PGTABLE_PROT_DBM			= BIT(6),

 	KVM_PGTABLE_PROT_SW0			= BIT(55),
 	KVM_PGTABLE_PROT_SW1			= BIT(56),
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 0e4ddd28ef5d..5b4c46d8dc74 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -739,6 +739,9 @@ static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot p
 	if (prot & KVM_PGTABLE_PROT_W)
 		attr |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;

+	if (prot & KVM_PGTABLE_PROT_DBM)
+		attr |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
+
 	if (!kvm_lpa2_is_enabled())
 		attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S2_SH, sh);

@@ -1361,6 +1364,9 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
 	if (prot & KVM_PGTABLE_PROT_W)
 		set |= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W;

+	if (prot & KVM_PGTABLE_PROT_DBM)
+		set |= KVM_PTE_LEAF_ATTR_HI_S2_DBM;
+
 	ret = stage2_set_xn_attr(prot, &xn);
 	if (ret)
 		return ret;
--
2.33.0


