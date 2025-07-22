Return-Path: <kvm+bounces-53112-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 23A02B0D7A2
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 13:01:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 048943B32A3
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 11:01:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF2B22E11C9;
	Tue, 22 Jul 2025 11:01:28 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from baidu.com (mx24.baidu.com [111.206.215.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C6F242D89;
	Tue, 22 Jul 2025 11:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.206.215.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753182088; cv=none; b=qCxb1WX03YK+UiovcaGK5ZYbwag9H3F3JfdhGingyMKJMyz8jvValCcgLI8cR9sbtB4940pWDy15AK91C0VLgaiCjqcBYe25MC0pFq83l1e1kZr976CfWB5uU3SJGD+NJFO0xbiOPZWzTLw2Y8j0Jm0//Sa/LNb/CC5OCwT5flI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753182088; c=relaxed/simple;
	bh=x33Wf6vItZfglOSVoF+PqC8gJ1yZX1FY368sstgNcGE=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Sb/gmOf/n9x278h0SNuvBNspBgzXUL156NO2sFOY6i7cglopKwTrrWuqyaibF5idOmGeZytpA8aCEhOHBJqmud5vUi7b8V4zueC9OsQtQCmisrv7mjwZydST7E970kiBZt+KZq12OERwTWCZWzeX8o2pWShemGZg+wpsqsYWsuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=111.206.215.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
From: lirongqing <lirongqing@baidu.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <vkuznets@redhat.com>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, <hpa@zytor.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH][v2] x86/kvm: Prefer native qspinlock for dedicated vCPUs irrespective of PV_UNHALT
Date: Tue, 22 Jul 2025 19:00:05 +0800
Message-ID: <20250722110005.4988-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: bjhj-exc14.internal.baidu.com (172.31.4.12) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
X-FEAS-Client-IP: 172.31.50.47
X-FE-Policy-ID: 52:10:53:SYSTEM

From: Li RongQing <lirongqing@baidu.com>

The commit b2798ba0b876 ("KVM: X86: Choose qspinlock when dedicated
physical CPUs are available") states that when PV_DEDICATED=1
(vCPU has dedicated pCPU), qspinlock should be preferred regardless of
PV_UNHALT.  However, the current implementation doesn't reflect this: when
PV_UNHALT=0, we still use virt_spin_lock() even with dedicated pCPUs.

This is suboptimal because:
1. Native qspinlocks should outperform virt_spin_lock() for dedicated
   vCPUs irrespective of HALT exiting
2. virt_spin_lock() should only be preferred when vCPUs may be preempted
   (non-dedicated case)

So reorder the PV spinlock checks to:
1. First handle dedicated pCPU case (disable virt_spin_lock_key)
2. Second check single CPU, and nopvspin configuration
3. Only then check PV_UNHALT support

This ensures we always use native qspinlock for dedicated vCPUs, delivering
pretty performance gains at high contention levels.

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
diff with v1: rewrite the changelog

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


