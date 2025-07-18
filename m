Return-Path: <kvm+bounces-52880-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D338AB0A17D
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 13:03:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AAD8816F350
	for <lists+kvm@lfdr.de>; Fri, 18 Jul 2025 11:03:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 708A82BE656;
	Fri, 18 Jul 2025 11:03:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from baidu.com (mx24.baidu.com [111.206.215.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D7C2AD14;
	Fri, 18 Jul 2025 11:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.206.215.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752836607; cv=none; b=HNNgoXB1kQ5ny4Ii7wh34E4LcC/cCUTipcxOYto/C8jg4WlPNlE5A6WX5GdgufxZNUXwzGBr+Q42M+s4TLxR2G37VmCOVFKeacU/X8Uvvh2vmTsWGrmiIBgUYvjbUqX0w8ECDZ4aU/9M+yPhwTte+Bf6akXq2vmM2l1qxdYPE5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752836607; c=relaxed/simple;
	bh=qDkhYkrGTILVWAr/MYvLU0ABsOv1ngXhgVMbnsF+LEU=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=a3eaBQ7dXB5rup9zFMEJ+WmjkqfSAwpyXVyRd+O9YN3wFS2WQXNAK3U+rhSW7JK2ouPY3TxACWHs5GzXjW5Qx5S2Flv/lNykGBfYG36KBSmbKozHqoOroxU5txywoFhtzq3VTyF1lDXMRaxlnROG4z9pmK9P7P4DLEzs6OAzk+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=111.206.215.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
From: lirongqing <lirongqing@baidu.com>
To: <pbonzini@redhat.com>, <vkuznets@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH] x86/kvm: Reorder PV spinlock checks for dedicated CPU case
Date: Fri, 18 Jul 2025 17:49:36 +0800
Message-ID: <20250718094936.5283-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: bjhj-exc4.internal.baidu.com (172.31.3.14) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
X-FEAS-Client-IP: 172.31.50.47
X-FE-Policy-ID: 52:10:53:SYSTEM

From: Li RongQing <lirongqing@baidu.com>

When a vCPU has a dedicated physical CPU, typically, the hypervisor
disables the HLT exit too, rendering the KVM_FEATURE_PV_UNHALT feature
unavailable, and virt_spin_lock_key is expected to be disabled in
this configuration, but:

The problematic execution flow caused the enabled virt_spin_lock_key:
- First check PV_UNHALT
- Then check dedicated CPUs

So change the order:
- First check dedicated CPUs
- Then check PV_UNHALT

This ensures virt_spin_lock_key is disable when dedicated physical
CPUs are available and HLT exit is disabled, and this will gives a
pretty performance boost at high contention level

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 arch/x86/kernel/kvm.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index 921c1c7..9cda79f 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -1073,16 +1073,6 @@ static void kvm_wait(u8 *ptr, u8 val)
 void __init kvm_spinlock_init(void)
 {
 	/*
-	 * In case host doesn't support KVM_FEATURE_PV_UNHALT there is still an
-	 * advantage of keeping virt_spin_lock_key enabled: virt_spin_lock() is
-	 * preferred over native qspinlock when vCPU is preempted.
-	 */
-	if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT)) {
-		pr_info("PV spinlocks disabled, no host support\n");
-		return;
-	}
-
-	/*
 	 * Disable PV spinlocks and use native qspinlock when dedicated pCPUs
 	 * are available.
 	 */
@@ -1101,6 +1091,16 @@ void __init kvm_spinlock_init(void)
 		goto out;
 	}
 
+	/*
+	 * In case host doesn't support KVM_FEATURE_PV_UNHALT there is still an
+	 * advantage of keeping virt_spin_lock_key enabled: virt_spin_lock() is
+	 * preferred over native qspinlock when vCPU is preempted.
+	 */
+	if (!kvm_para_has_feature(KVM_FEATURE_PV_UNHALT)) {
+		pr_info("PV spinlocks disabled, no host support\n");
+		return;
+	}
+
 	pr_info("PV spinlocks enabled\n");
 
 	__pv_init_lock_hash();
-- 
2.9.4


