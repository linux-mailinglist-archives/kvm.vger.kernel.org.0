Return-Path: <kvm+bounces-39647-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 38A21A48C61
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 00:07:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2644F3A514E
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 23:06:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 830DC270ED6;
	Thu, 27 Feb 2025 23:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="V0Q1F8/k"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C2523E356
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 23:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740697603; cv=none; b=fKuCb05AhM59OcJSRgymoupU4tdklel14m+u4snL+Fm/jobazXOm/VfL2Y8968ni3jPcEzX7W/J3W53TGp1SvCzgBlNKIuGK8R/dz01LRW2VkXJjczsRvgnOSZ1G+mHpwA5L17wBBDtA5I58fOeANach3fHPmveGJ3wGKndGOxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740697603; c=relaxed/simple;
	bh=A/BzAyoOxn05ksse1UTyjUhVyTuIxw9DAsG67prymIE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QtLJmz8ltx8n4fjBU5dlS4FbTKsRFUCjYN/aUbZbYBkoFRlFICSYrtr+oj7GJpupiYmPGDGVS4Gx7Xm+ppxPivhEAmOTe9nat4GRoQf+DLokTCgmLTDKK2ss5Nx5mz1nqvqniS9E1yOtaY0ajzdc8CUa9+7EBmZilipGCIgIbpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=V0Q1F8/k; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51RMbm1X032471
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 15:06:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=mUQSIe+ZB5g6/BDTv+u2v3zHU+qSX1cA/76PINODPKk=; b=V0Q1F8/kLU2B
	Mn8h7mVpnZd1KWgb7af1qM5fdw3aeTm8jFRggCfjzyOjf5sSehn+6/FWKdO6f/s8
	SK71fvE5sUdT2ONGDhI5ID5gE/aJA1VrZeAlrFI63PP4UTAfZlGTlNFRED08wTGo
	VmfgUFs1cJ6AmTvpqqpuTjlFI9OA6CxDkHwuemn5ZBHI8P2DRIIetCi67WJi+JT4
	CEjni5W5mF8J0oBtFH52CJ0rnAcdW5muvR8MzxOhGCPvamNfvZXX94514gHawhIM
	q7uoZgGkZzKzFOIrl7R0JrhF0XRkAUIpwSOrwzK1z0DCQI7bWECdC4VkvcqHuLJ5
	zXu0PkHiag==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4530qwga3s-6
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 15:06:40 -0800 (PST)
Received: from twshared40462.17.frc2.facebook.com (2620:10d:c0a8:1c::11) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Thu, 27 Feb 2025 23:06:28 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id A2B4D1888533A; Thu, 27 Feb 2025 15:06:31 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <leiyang@redhat.com>, <virtualization@lists.linux.dev>, <x86@kernel.org>,
        <netdev@vger.kernel.org>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv3 2/2] kvm: retry nx_huge_page_recovery_thread creation
Date: Thu, 27 Feb 2025 15:06:31 -0800
Message-ID: <20250227230631.303431-3-kbusch@meta.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250227230631.303431-1-kbusch@meta.com>
References: <20250227230631.303431-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: lf518XvDOzkUaWOBiIctAhsnLoy1UR1A
X-Proofpoint-GUID: lf518XvDOzkUaWOBiIctAhsnLoy1UR1A
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-27_08,2025-02-27_01,2024-11-22_01

From: Sean Christopherson <seanjc@google.com>

A VMM may send a signal to its threads while they've entered KVM_RUN. If
that thread happens to be trying to make the huge page recovery vhost
task, then it fails with -ERESTARTNOINTR. We need to retry if that
happens, so call_once needs to be retryable. Make call_once complete
only if what it called was successful.

[implemented the kvm user side]
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


