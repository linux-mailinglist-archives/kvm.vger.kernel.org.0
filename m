Return-Path: <kvm+bounces-57674-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A3F12B58E49
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 08:13:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B205E1BC5A29
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 06:13:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 471352DF138;
	Tue, 16 Sep 2025 06:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b="FzY0ibwo"
X-Original-To: kvm@vger.kernel.org
Received: from out198-24.us.a.mail.aliyun.com (out198-24.us.a.mail.aliyun.com [47.90.198.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C513288535;
	Tue, 16 Sep 2025 06:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=47.90.198.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758003201; cv=none; b=ZfZf/FEafLptiXQzwhQc7pxnV/9/hsQLNllnvJdMDpAMO8j/AV38B4OhGEO0QEh+MIX+/EsYLOS85Eq1GT3gAm7k0wxsNWCadu7R9v1+COr4k32X7BFpFaDFsjLd4WAr8cfUmz8Tb7wAH+tkhn7BjAjJkOQNh/VCOKWNnZaWDJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758003201; c=relaxed/simple;
	bh=Jj3VcnP5GhTgVyclz+OXfTM1oG4PlIzfdeeAJCBhy0c=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=RBgufeimpC4hhUWDv3CQlTibRE7Zp3XgUx8aYOSXmAkvD4xLqE7PtpOmhwRuQkHo/EHp+zoKg3jtLHxTfZS4SggQKv4ovHwnXCpEeaDxDYOSW0veDOjWBPilA/jE2gs1+zelpYsvyZ8A7jxmwlNZLrKBjmEHXrR+HBDv3SUky7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com; spf=pass smtp.mailfrom=antgroup.com; dkim=pass (1024-bit key) header.d=antgroup.com header.i=@antgroup.com header.b=FzY0ibwo; arc=none smtp.client-ip=47.90.198.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=antgroup.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=antgroup.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=antgroup.com; s=default;
	t=1758003180; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=k1Haa/kl7NEIeuhPSnztrSkWerox59Eu0w5i3tHuS9E=;
	b=FzY0ibwojHQi7g7EqBcWGlQJsac+NxDXjOqV/Rh9HRAAVS/pLAl8mmC+sY0fV7oe84OdX0/ZP00BOx8oTevzVfJ7i8ZMQ9b8GaP0yFCcICPu/6WSXS/6G1vMiuZZVv44iFvvpcAXIpDWyrs/sNK1y4kUq6hNnKSfN3sfXGj0CTw=
Received: from localhost(mailfrom:houwenlong.hwl@antgroup.com fp:SMTPD_---.eg7KpKq_1758002859 cluster:ay29)
          by smtp.aliyun-inc.com;
          Tue, 16 Sep 2025 14:07:39 +0800
From: Hou Wenlong <houwenlong.hwl@antgroup.com>
To: kvm@vger.kernel.org
Cc: Chao Gao <chao.gao@intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] KVM: Disable IRQs in kvm_online_cpu()/kvm_offline_cpu()
Date: Tue, 16 Sep 2025 14:07:35 +0800
Message-Id: <15fa59ba7f6f849082fb36735e784071539d5ad2.1758002303.git.houwenlong.hwl@antgroup.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After the commit aaf12a7b4323 ("KVM: Rename and move
CPUHP_AP_KVM_STARTING to ONLINE section"), KVM's hotplug callbacks have
been moved into the ONLINE section, where IRQs and preemption are
enabled according to the documentation. However, if IRQs are not
guaranteed to be disabled, it could theoretically be a bug, because
virtualization_enabled may be stale (with respect to the actual state of
the hardware) when read from IRQ context, making the callback
potentially reentrant. Therefore, disable IRQs in kvm_online_cpu() and
kvm_offline_cpu() to ensure that all paths for
kvm_enable_virtualization_cpu() and kvm_disable_virtualization_cpu() are
in an IRQ-disabled state.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 virt/kvm/kvm_main.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 18f29ef93543..cf8dddeed37e 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -5580,6 +5580,8 @@ __weak void kvm_arch_disable_virtualization(void)
 
 static int kvm_enable_virtualization_cpu(void)
 {
+	lockdep_assert_irqs_disabled();
+
 	if (__this_cpu_read(virtualization_enabled))
 		return 0;
 
@@ -5595,6 +5597,8 @@ static int kvm_enable_virtualization_cpu(void)
 
 static int kvm_online_cpu(unsigned int cpu)
 {
+	guard(irqsave)();
+
 	/*
 	 * Abort the CPU online process if hardware virtualization cannot
 	 * be enabled. Otherwise running VMs would encounter unrecoverable
@@ -5605,6 +5609,8 @@ static int kvm_online_cpu(unsigned int cpu)
 
 static void kvm_disable_virtualization_cpu(void *ign)
 {
+	lockdep_assert_irqs_disabled();
+
 	if (!__this_cpu_read(virtualization_enabled))
 		return;
 
@@ -5615,6 +5621,8 @@ static void kvm_disable_virtualization_cpu(void *ign)
 
 static int kvm_offline_cpu(unsigned int cpu)
 {
+	guard(irqsave)();
+
 	kvm_disable_virtualization_cpu(NULL);
 	return 0;
 }
@@ -5648,7 +5656,6 @@ static int kvm_suspend(void)
 	 * dropped all locks (userspace tasks are frozen via a fake signal).
 	 */
 	lockdep_assert_not_held(&kvm_usage_lock);
-	lockdep_assert_irqs_disabled();
 
 	kvm_disable_virtualization_cpu(NULL);
 	return 0;
@@ -5657,7 +5664,6 @@ static int kvm_suspend(void)
 static void kvm_resume(void)
 {
 	lockdep_assert_not_held(&kvm_usage_lock);
-	lockdep_assert_irqs_disabled();
 
 	WARN_ON_ONCE(kvm_enable_virtualization_cpu());
 }

base-commit: a6ad54137af92535cfe32e19e5f3bc1bb7dbd383
-- 
2.31.1


