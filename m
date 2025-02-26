Return-Path: <kvm+bounces-39410-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F20AA46DB5
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 22:41:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B3C803B062C
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 21:40:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CF59265CC5;
	Wed, 26 Feb 2025 21:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="gO5fv8h7"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7AC263F26
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 21:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740605976; cv=none; b=uO4R9BY2Wo13hotWAq25sr9X1ukbOVnkyMiohRlHqPbUtrJXubpNEpRhHB+cs4vAbULPC7uOscn2MXTMLOBTncXLdxIVqXzFDN1CvfvUVRNRrn3phmfYFQg6l9C3PuyHtQxBM6tMxUSYEcaFEMnEmQ88UoEQ2YTbXKWw2USt4wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740605976; c=relaxed/simple;
	bh=V0nqe9pGk9+j+rvT7OsE68sn/woHcCy9DXCv+4P0T4s=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GczEDaYqB0tW50VGwqIPyO2Ovf+FQ4RgA7HOV5E1vgKL30ukZR2s1Alj8RiaUQ+sArW/+sstAsSaw1SE7RA6HkROVkGjDPD75Ll0XsXaoBw97opajXlTo2QKfRuSAGDmC01x3LbcoHYJYAdH1yO5JcyPV/AkVz0Xm4S+ij5JA1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=gO5fv8h7; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
	by m0089730.ppops.net (8.18.1.2/8.18.1.2) with ESMTP id 51QKcSp3018501
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 13:39:33 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=+lNJAllL67o7hUjzAbl5N9quGu7zuBmVuph1MeFnj+0=; b=gO5fv8h7LaQF
	RBnT+7NHPmaCb6v5InxilkVDqkewGj4ZDzDuB6bk+rpSeyq61Lj+BuZiWLxNOgDR
	NMP1D9XcqlFF58dfvFTKHSAhg6lgqGqm/u0qOs2wau1IHDH+q1gEImfA+RtLPDs6
	jtFnsOBcVS83e3ZgZsRMWlIBqvsMetBO9Qbgw28kogB4hs8fXRj4mIKSN8cRgbxe
	72LKtoULSmoW5wul5I1isdB9KU4o0ZmFyC6qfYtqaBMXGmxV2vUhvr4oLM7kP0WB
	RshhYYJFgIp5P1INS5+Ok8bPgQpczBZ/BaGrg3gvUu1enK1YdjOG7M93UM/cgfXQ
	abcXOs7/SQ==
Received: from mail.thefacebook.com ([163.114.134.16])
	by m0089730.ppops.net (PPS) with ESMTPS id 45257rb8d4-7
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 13:39:33 -0800 (PST)
Received: from twshared11145.37.frc1.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Wed, 26 Feb 2025 21:38:49 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 3AC4E187DD503; Wed, 26 Feb 2025 13:38:45 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <pbonzini@redhat.com>, <seanjc@google.com>, <kvm@vger.kernel.org>
CC: <x86@kernel.org>, <virtualization@lists.linux.dev>,
        <linux-kernel@vger.kernel.org>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv2 2/2] kvm: retry nx_huge_page_recovery_thread creation
Date: Wed, 26 Feb 2025 13:38:44 -0800
Message-ID: <20250226213844.3826821-3-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250226213844.3826821-1-kbusch@meta.com>
References: <20250226213844.3826821-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: cT5VWXI5yb53892JUvWQTk0bvNSMV7Jh
X-Proofpoint-ORIG-GUID: cT5VWXI5yb53892JUvWQTk0bvNSMV7Jh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-26_06,2025-02-26_01,2024-11-22_01

From: Sean Christopherson <seanjc@google.com>

A VMM may send a signal to its threads while they've entered KVM_RUN. If
that thread happens to be trying to make the huge page recovery vhost
task, it will fail with -ERESTARTNOINTR. We need to retry if that
happens, so make call_once complete only if what it called was
successful.

Based-on-a-patch-by: Sean Christopherson <seanjc@google.com>
[implemented caller side, commit log]
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 arch/x86/kvm/mmu/mmu.c    | 10 ++++------
 include/linux/call_once.h | 16 +++++++++++-----
 2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 18ca1ea6dc240..8160870398b90 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7460,7 +7460,7 @@ static bool kvm_nx_huge_page_recovery_worker(void *=
data)
 	return true;
 }
=20
-static void kvm_mmu_start_lpage_recovery(struct once *once)
+static int kvm_mmu_start_lpage_recovery(struct once *once)
 {
 	struct kvm_arch *ka =3D container_of(once, struct kvm_arch, nx_once);
 	struct kvm *kvm =3D container_of(ka, struct kvm, arch);
@@ -7472,12 +7472,13 @@ static void kvm_mmu_start_lpage_recovery(struct o=
nce *once)
 				      kvm, "kvm-nx-lpage-recovery");
=20
 	if (IS_ERR(nx_thread))
-		return;
+		return PTR_ERR(nx_thread);
=20
 	vhost_task_start(nx_thread);
=20
 	/* Make the task visible only once it is fully started. */
 	WRITE_ONCE(kvm->arch.nx_huge_page_recovery_thread, nx_thread);
+	return 0;
 }
=20
 int kvm_mmu_post_init_vm(struct kvm *kvm)
@@ -7485,10 +7486,7 @@ int kvm_mmu_post_init_vm(struct kvm *kvm)
 	if (nx_hugepage_mitigation_hard_disabled)
 		return 0;
=20
-	call_once(&kvm->arch.nx_once, kvm_mmu_start_lpage_recovery);
-	if (!kvm->arch.nx_huge_page_recovery_thread)
-		return -ENOMEM;
-	return 0;
+	return call_once(&kvm->arch.nx_once, kvm_mmu_start_lpage_recovery);
 }
=20
 void kvm_mmu_pre_destroy_vm(struct kvm *kvm)
diff --git a/include/linux/call_once.h b/include/linux/call_once.h
index 6261aa0b3fb00..ddcfd91493eaa 100644
--- a/include/linux/call_once.h
+++ b/include/linux/call_once.h
@@ -26,20 +26,26 @@ do {									\
 	__once_init((once), #once, &__key);				\
 } while (0)
=20
-static inline void call_once(struct once *once, void (*cb)(struct once *=
))
+static inline int call_once(struct once *once, int (*cb)(struct once *))
 {
+	int r;
+
         /* Pairs with atomic_set_release() below.  */
         if (atomic_read_acquire(&once->state) =3D=3D ONCE_COMPLETED)
-                return;
+		return 0;
=20
         guard(mutex)(&once->lock);
         WARN_ON(atomic_read(&once->state) =3D=3D ONCE_RUNNING);
         if (atomic_read(&once->state) !=3D ONCE_NOT_STARTED)
-                return;
+                return -EINVAL;
=20
         atomic_set(&once->state, ONCE_RUNNING);
-        cb(once);
-        atomic_set_release(&once->state, ONCE_COMPLETED);
+	r =3D cb(once);
+	if (r)
+		atomic_set(&once->state, ONCE_NOT_STARTED);
+	else
+		atomic_set_release(&once->state, ONCE_COMPLETED);
+	return r;
 }
=20
 #endif /* _LINUX_CALL_ONCE_H */
--=20
2.43.5


