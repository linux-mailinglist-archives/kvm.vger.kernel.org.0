Return-Path: <kvm+bounces-43910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D14A2A98567
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 11:25:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 12DC417F866
	for <lists+kvm@lfdr.de>; Wed, 23 Apr 2025 09:25:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF15C25C800;
	Wed, 23 Apr 2025 09:25:35 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from baidu.com (mx24.baidu.com [111.206.215.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14BB1221544;
	Wed, 23 Apr 2025 09:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=111.206.215.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745400335; cv=none; b=kO+yFAJJvk6xGTU7QK9koCN7Os5yREkV2e9gpRBURXLRcPzXkbEyHsyb+xTdSR69lcnTACperkf8DCjkZ3LzJPqh3A7QlJ12iTXHDXAHL60gF/m8fc0VGLOgI4AXUtrw2RwtmQnqcGAfMvHQ2Fd92fpXpoxoZQ4bWo3VDJAoqyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745400335; c=relaxed/simple;
	bh=lzVLEKMX8Y7vReYRYvuu3tJ5AswAkhF/wsfkKCBclro=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=iOH55Y9zXLLAuC//rObm0a7kmKtAKzI08z7dQJEMZ1gS5PdVBPm79z5Pdj2aYh/P2uGR4BncdpNba5fRTYmW77/sp+i6iznO6d7seAGHFf3wlZuGUXre3zQlpISpuGv1/n0rh9f0/E+Mi/AwM7/1fVQByFmMO17fp1LFUIiRP6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com; spf=pass smtp.mailfrom=baidu.com; arc=none smtp.client-ip=111.206.215.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=baidu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baidu.com
From: lirongqing <lirongqing@baidu.com>
To: <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>, lizhaoxin <lizhaoxin04@baidu.com>
Subject: [PATCH] KVM: Use call_rcu() in kvm_io_bus_register_dev
Date: Wed, 23 Apr 2025 17:25:09 +0800
Message-ID: <20250423092509.3162-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: BJHW-Mail-Ex14.internal.baidu.com (10.127.64.37) To
 BJHW-Mail-Ex15.internal.baidu.com (10.127.64.38)
X-Baidu-BdMsfe-DateCheck: 1_BJHW-Mail-Ex15_2025-04-23 17:25:18:190
X-FEAS-Client-IP: 10.127.64.38
X-FE-Policy-ID: 52:10:53:SYSTEM

From: Li RongQing <lirongqing@baidu.com>

Use call_rcu() instead of costly synchronize_srcu_expedited(), this
can reduce the VM bootup time, and reduce VM migration downtime

Signed-off-by: lizhaoxin <lizhaoxin04@baidu.com>
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 11 +++++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 291d49b..e772704 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -203,6 +203,7 @@ struct kvm_io_range {
 #define NR_IOBUS_DEVS 1000
 
 struct kvm_io_bus {
+	struct rcu_head rcu;
 	int dev_count;
 	int ioeventfd_count;
 	struct kvm_io_range range[];
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2e591cc..af730a5 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5865,6 +5865,13 @@ int kvm_io_bus_read(struct kvm_vcpu *vcpu, enum kvm_bus bus_idx, gpa_t addr,
 	return r < 0 ? r : 0;
 }
 
+static void free_kvm_io_bus(struct rcu_head *rcu)
+{
+	struct kvm_io_bus *bus = container_of(rcu, struct kvm_io_bus, rcu);
+
+	kfree(bus);
+}
+
 int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
 			    int len, struct kvm_io_device *dev)
 {
@@ -5903,8 +5910,8 @@ int kvm_io_bus_register_dev(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
 	memcpy(new_bus->range + i + 1, bus->range + i,
 		(bus->dev_count - i) * sizeof(struct kvm_io_range));
 	rcu_assign_pointer(kvm->buses[bus_idx], new_bus);
-	synchronize_srcu_expedited(&kvm->srcu);
-	kfree(bus);
+
+	call_srcu(&kvm->srcu, &bus->rcu, free_kvm_io_bus);
 
 	return 0;
 }
-- 
2.9.4


