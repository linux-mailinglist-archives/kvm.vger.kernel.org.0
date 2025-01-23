Return-Path: <kvm+bounces-36392-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CEEE8A1A727
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 16:36:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 189331678E8
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 15:36:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04ECD211470;
	Thu, 23 Jan 2025 15:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="ZfLS8rsv"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607ADF4F1
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 15:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737646571; cv=none; b=WIs01mQsfX2hiQxCTM721pReX0PwUffxRjzG1tY1CmmnyuslyJ0bMfgZ/Go7+Q5SQq1PPihjX2jGFtdDx/9UyMeMOhnL8qmsiUWPzYh9jvoVG70iVw5rqi+14wnYRpm7yGtOTdgHfXHLSYCmrr+lgL6cbXK28zzMfEZ2hwhXLwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737646571; c=relaxed/simple;
	bh=IKRzKxDHgZ6HryTEn90X+Xj30h0PVrX6bIb3+5x0+WA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=pD8dkZKP6YntuePO4xz0pi65G0Nt8w32KpYI9b7H37Fbvb62o5POjqLnUSHghhMwD2bd0TpiC1o12R6QEDd6l9duWr+lYDzbYYro/IOEMmnZNThU3hFAgI+ZcF6eeXe31QEjYdqtuX0XyzOhZsSm42Ue5H3LlVbZQxsInpsVvgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=ZfLS8rsv; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.2/8.18.1.2) with ESMTP id 50NF7idh019988
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 07:36:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2021-q4; bh=lpkECEcCcGYyN5K7oo
	I8MFikOXuuefuG7+H7ZQWYQqU=; b=ZfLS8rsv+NlJ+U+V0PFDxnubpst9n45L+O
	OK+R8lpJzI+Vi5Sy/wRae/ZqnvxTxud1Run0eGrkg9I/hrutmb2sy0L0bHrqjPHV
	Z6hjX6duaWCaygwSCvLZH/AvnGDJkjsbJvTWdH//bCZoQRmiB7l9CO0fypIS4gV3
	WxHPP5HkAfGA/Dsr/BpOjk+7Eyo0lUij6EvWC+hSre0IQQ33ezGpRQ6ZQWscIsN+
	nGe+Uiek0t4YHGS/RuqwP98ouXSr1CIVZ6yWpgIYrsORMzY9s+BL5exYaVp7h3u0
	RK+8ND4hrTifdHB9GcumXq0EROGpnm7TCeL4Zq4DjF/JF08H6sfA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by m0001303.ppops.net (PPS) with ESMTPS id 44br4x86be-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Thu, 23 Jan 2025 07:36:07 -0800 (PST)
Received: from twshared8234.09.ash9.facebook.com (2620:10d:c0a8:1b::30) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Thu, 23 Jan 2025 15:35:58 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 68A4A1735FA2E; Thu, 23 Jan 2025 07:35:44 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <kvm@vger.kernel.org>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>
CC: Vlad Poenaru <thevlad@meta.com>, <tj@kernel.org>,
        Keith Busch
	<kbusch@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini
	<pbonzini@redhat.com>, Alyssa Ross <hi@alyssa.is>
Subject: [PATCH] kvm: defer huge page recovery vhost task to later
Date: Thu, 23 Jan 2025 07:35:43 -0800
Message-ID: <20250123153543.2769928-1-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 5Vx57Q8tKmtMpTGwkH7C-3OAEtMGBqsH
X-Proofpoint-ORIG-GUID: 5Vx57Q8tKmtMpTGwkH7C-3OAEtMGBqsH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-23_06,2025-01-23_01,2024-11-22_01

From: Keith Busch <kbusch@kernel.org>

Some libraries want to ensure they are single threaded before forking,
so making the kernel's kvm huge page recovery process a vhost task of
the user process breaks those. The minijail library used by crosvm is
one such affected application.

Defer the task to after the first VM_RUN call, which occurs after the
parent process has forked all its jailed processes. This needs to happen
only once for the kvm instance, so this patch introduces infrastructure
to do that (Suggested-by Paolo).

Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Tested-by: Alyssa Ross <hi@alyssa.is>
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 arch/x86/include/asm/kvm_call_once.h | 44 ++++++++++++++++++++++++++++
 arch/x86/include/asm/kvm_host.h      |  2 ++
 arch/x86/kvm/mmu/mmu.c               | 18 ++++++++----
 arch/x86/kvm/x86.c                   |  7 ++++-
 4 files changed, 65 insertions(+), 6 deletions(-)
 create mode 100644 arch/x86/include/asm/kvm_call_once.h

diff --git a/arch/x86/include/asm/kvm_call_once.h b/arch/x86/include/asm/=
kvm_call_once.h
new file mode 100644
index 0000000000000..451cc87084aa7
--- /dev/null
+++ b/arch/x86/include/asm/kvm_call_once.h
@@ -0,0 +1,44 @@
+#ifndef _LINUX_CALL_ONCE_H
+#define _LINUX_CALL_ONCE_H
+
+#include <linux/types.h>
+
+#define ONCE_NOT_STARTED 0
+#define ONCE_RUNNING     1
+#define ONCE_COMPLETED   2
+
+struct once {
+        atomic_t state;
+        struct mutex lock;
+};
+
+static inline void __once_init(struct once *once, const char *name,
+			       struct lock_class_key *key)
+{
+        atomic_set(&once->state, ONCE_NOT_STARTED);
+        __mutex_init(&once->lock, name, key);
+}
+
+#define once_init(once)							\
+do {									\
+	static struct lock_class_key __key;				\
+	__once_init((once), #once, &__key);				\
+} while (0)
+
+static inline void call_once(struct once *once, void (*cb)(struct once *=
))
+{
+        /* Pairs with atomic_set_release() below.  */
+        if (atomic_read_acquire(&once->state) =3D=3D ONCE_COMPLETED)
+                return;
+
+        guard(mutex)(&once->lock);
+        WARN_ON(atomic_read(&once->state) =3D=3D ONCE_RUNNING);
+        if (atomic_read(&once->state) !=3D ONCE_NOT_STARTED)
+                return;
+
+        atomic_set(&once->state, ONCE_RUNNING);
+        cb(once);
+        atomic_set_release(&once->state, ONCE_COMPLETED);
+}
+
+#endif /* _LINUX_CALL_ONCE_H */
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
index 2f442701dc755..e1eb8155e6a82 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -37,6 +37,7 @@
 #include <asm/kvm_page_track.h>
 #include <asm/kvm_vcpu_regs.h>
 #include <asm/hyperv-tlfs.h>
+#include <asm/kvm_call_once.h>
 #include <asm/reboot.h>
=20
 #define __KVM_HAVE_ARCH_VCPU_DEBUGFS
@@ -1466,6 +1467,7 @@ struct kvm_arch {
 	struct kvm_x86_pmu_event_filter __rcu *pmu_event_filter;
 	struct vhost_task *nx_huge_page_recovery_thread;
 	u64 nx_huge_page_last;
+	struct once nx_once;
=20
 #ifdef CONFIG_X86_64
 	/* The number of TDP MMU pages across all roots. */
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 26b4ba7e7cb5e..a45ae60e84ab4 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7447,20 +7447,28 @@ static bool kvm_nx_huge_page_recovery_worker(void=
 *data)
 	return true;
 }
=20
-int kvm_mmu_post_init_vm(struct kvm *kvm)
+static void kvm_mmu_start_lpage_recovery(struct once *once)
 {
-	if (nx_hugepage_mitigation_hard_disabled)
-		return 0;
+	struct kvm_arch *ka =3D container_of(once, struct kvm_arch, nx_once);
+	struct kvm *kvm =3D container_of(ka, struct kvm, arch);
=20
 	kvm->arch.nx_huge_page_last =3D get_jiffies_64();
 	kvm->arch.nx_huge_page_recovery_thread =3D vhost_task_create(
 		kvm_nx_huge_page_recovery_worker, kvm_nx_huge_page_recovery_worker_kil=
l,
 		kvm, "kvm-nx-lpage-recovery");
=20
+	if (kvm->arch.nx_huge_page_recovery_thread)
+		vhost_task_start(kvm->arch.nx_huge_page_recovery_thread);
+}
+
+int kvm_mmu_post_init_vm(struct kvm *kvm)
+{
+	if (nx_hugepage_mitigation_hard_disabled)
+		return 0;
+
+	call_once(&kvm->arch.nx_once, kvm_mmu_start_lpage_recovery);
 	if (!kvm->arch.nx_huge_page_recovery_thread)
 		return -ENOMEM;
-
-	vhost_task_start(kvm->arch.nx_huge_page_recovery_thread);
 	return 0;
 }
=20
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6e248152fa134..6d4a6734b2d69 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11471,6 +11471,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcp=
u)
 	struct kvm_run *kvm_run =3D vcpu->run;
 	int r;
=20
+	r =3D kvm_mmu_post_init_vm(vcpu->kvm);
+	if (r)
+		return r;
+
 	vcpu_load(vcpu);
 	kvm_sigset_activate(vcpu);
 	kvm_run->flags =3D 0;
@@ -12748,7 +12752,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned lo=
ng type)
=20
 int kvm_arch_post_init_vm(struct kvm *kvm)
 {
-	return kvm_mmu_post_init_vm(kvm);
+	once_init(&kvm->arch.nx_once);
+	return 0;
 }
=20
 static void kvm_unload_vcpu_mmu(struct kvm_vcpu *vcpu)
--=20
2.43.5


