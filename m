Return-Path: <kvm+bounces-63834-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E3A1C73D04
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 12:48:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id 5797E2B18F
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 11:48:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38FC832FA0C;
	Thu, 20 Nov 2025 11:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="PeHWe137"
X-Original-To: kvm@vger.kernel.org
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAC5A302150;
	Thu, 20 Nov 2025 11:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763639293; cv=none; b=bpGpnzVak/M9Y+z3ZMQjFvko8i6TN7oqsP5y2MBVv0v/+6+3R1RZ/SEJtM2q6akL06MLLWz5pncdrve5E/PDH+wl7RXAY1405Td2HrfwSRVrHfDi1ovl106ktxZOWju2Wk3fdEdNwuiJkX1ldRNoQ0b8YP3LBC/1gmlD5FaPi9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763639293; c=relaxed/simple;
	bh=lpM/aFPdmoHmJWDr9RVOHD6BsTR/bB5B3y+4SZNx/oU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WX8B7MaO6FqaY9JAkPwM1/0/H9kjLI85rNTWZu9WsVQi3NvGKkgCW68/UHi70uKzd3Gyxt0XdNSls7V7Ws+RWFfsOGdJFczlXKubcfcPJWCzp1UlGlA/ajT/cr6WRgGGtdpqa8N+0BjLp2tA9s/pjdkg9bAi0aOClVG+ReT39t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=PeHWe137; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=1byR2LwEKBJNO1bZd9Np4JPUrD3cOYo5PUpE4PkghMY=;
	b=PeHWe137Ll9DfO4SjAM/oIuO1cs06V4D4kAZzlgzNEz6Inplt7Oqse8382F8JMqtu+q88kANo
	mpexTPb0dqTeIN4cxs0DbPM2WNTwF4fHerO8R/JuwsIe2yCbSwqfyZpEMc70MNgMB3CULog2iH6
	9CnCYMHPDoEo1I50SR9vLEA=
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4dBxQ16jN1z1K96b;
	Thu, 20 Nov 2025 19:46:17 +0800 (CST)
Received: from dggpemf500002.china.huawei.com (unknown [7.185.36.57])
	by mail.maildlp.com (Postfix) with ESMTPS id B419E1800B2;
	Thu, 20 Nov 2025 19:48:00 +0800 (CST)
Received: from huawei.com (10.50.85.128) by dggpemf500002.china.huawei.com
 (7.185.36.57) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 20 Nov
 2025 19:47:59 +0800
From: Yue Haibing <yuehaibing@huawei.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <yan.y.zhao@intel.com>,
	<isaku.yamahata@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<yuehaibing@huawei.com>
Subject: [PATCH -next] KVM: x86: Remove unused declaration kvm_mmu_may_ignore_guest_pat()
Date: Thu, 20 Nov 2025 20:09:30 +0800
Message-ID: <20251120120930.1448593-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf500002.china.huawei.com (7.185.36.57)

Commit 3fee4837ef40 ("KVM: x86: remove shadow_memtype_mask")
removed the functions but leave this declaration.

Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
---
 arch/x86/kvm/mmu.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 9e5045a60d8b..830f46145692 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -235,8 +235,6 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 	return -(u32)fault & errcode;
 }
 
-bool kvm_mmu_may_ignore_guest_pat(struct kvm *kvm);
-
 int kvm_mmu_post_init_vm(struct kvm *kvm);
 void kvm_mmu_pre_destroy_vm(struct kvm *kvm);
 
-- 
2.34.1


