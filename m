Return-Path: <kvm+bounces-36224-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 96A3CA18D15
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 08:51:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 03F103A2F9F
	for <lists+kvm@lfdr.de>; Wed, 22 Jan 2025 07:51:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8B651C1F00;
	Wed, 22 Jan 2025 07:51:33 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from baidu.com (mx22.baidu.com [220.181.50.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE0D28EC
	for <kvm@vger.kernel.org>; Wed, 22 Jan 2025 07:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.181.50.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737532293; cv=none; b=kPix+w6UnzL0RckoA9lsEBanOzvH9vKrdbyH6nWXRSZkRVr/7CXzS1g+7xPH6Yr4baPnc3AeCHsDH1ZTYwmoH49Ov1JP+F0acwUNis8iLIKGe992lkFD0sBg4gE1484Hegc8LdRkU5J4bcm2sSDgkvlhNH8hrJIoQbYgbDTcE6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737532293; c=relaxed/simple;
	bh=8aa9I87Oplk2cQJftFsp15FtO7PCgCZddDvzN5okYkw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=p2aDKvNWSF8po3C8vn3jMVTTmGZ9z/iCqM91GkVrq1D0ciVOUtm3jaD3OwwZ/mgTzuTa3wD5RpPG4T1Rl5ES+Mk/mhol2wMAnTl2CGm6Ycw1Fs2QhB3o44eOR+hlpazG5xfGhi9pjxxZV7uLDWdszFGJ1AZvIfLp64t2T8Abewk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=220.181.50.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
From: lirongqing <lirongqing@baidu.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, <hpa@zytor.com>, <kvm@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>
Subject: [PATCH] KVM: x86: use kvfree_rcu to simplify the code
Date: Wed, 22 Jan 2025 15:34:56 +0800
Message-ID: <20250122073456.2950-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: BC-MAIL-EX01.internal.baidu.com (172.31.51.41) To
 BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38)
X-Baidu-BdMsfe-DateCheck: 1_BJHW-Mail-Ex15_2025-01-22 15:35:03:385
X-Baidu-BdMsfe-DateCheck: 1_BJHW-Mail-Ex15_2025-01-22 15:35:03:400
X-FEAS-Client-IP: 10.127.64.38
X-FE-Policy-ID: 52:10:53:SYSTEM

From: Li RongQing <lirongqing@baidu.com>

The callback function of call_rcu() just calls kvfree(), so we can
use kvfree_rcu() instead of call_rcu() + callback function.

Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 arch/x86/kvm/lapic.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 3c83951..d6e62a2 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -221,13 +221,6 @@ static inline bool kvm_apic_map_get_logical_dest(struct kvm_apic_map *map,
 	}
 }
 
-static void kvm_apic_map_free(struct rcu_head *rcu)
-{
-	struct kvm_apic_map *map = container_of(rcu, struct kvm_apic_map, rcu);
-
-	kvfree(map);
-}
-
 static int kvm_recalculate_phys_map(struct kvm_apic_map *new,
 				    struct kvm_vcpu *vcpu,
 				    bool *xapic_id_mismatch)
@@ -489,7 +482,7 @@ static void kvm_recalculate_apic_map(struct kvm *kvm)
 	mutex_unlock(&kvm->arch.apic_map_lock);
 
 	if (old)
-		call_rcu(&old->rcu, kvm_apic_map_free);
+		kvfree_rcu(old, rcu);
 
 	kvm_make_scan_ioapic_request(kvm);
 }
-- 
2.9.4


