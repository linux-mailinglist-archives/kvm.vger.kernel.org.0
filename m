Return-Path: <kvm+bounces-39648-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7967EA48C64
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 00:07:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A1FE6189086F
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 23:07:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2AC523E32C;
	Thu, 27 Feb 2025 23:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="jGfJyFnA"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A315F27128D
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 23:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740697608; cv=none; b=ugNvl1eCjJu0YaoGI19bmP1gv8xHZ+pE2cwZ6EINCuK0vv+mI6RScnW4Dl2LI7l/P59ii6mswPT7iS48xaJBTd2K0nl35xL4sZIMYqcql/k8xRZxaO0pXC+oQ832ROYGHZmRViBqo0N94idXX3hf3OKviBz45fjaL+wMKfUxvT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740697608; c=relaxed/simple;
	bh=n20JTjqARi3bIKMGVpnP5071GH6mRPRCGiKcCnHkOuw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=upyZ1LJsHTfx3xg9GzrD6WXK2aEF3eCUL1H1+T26Zt2BaShFTT8EwRw9KVfONjOavu0odL0/NXmt/xB/9K+kuSViLJj0+AqJ9D02gNRbDPekceS5PMolPBDv9pGNPQZCdT9xSBKL6R9s2nfeK5aKFzdlSymGbAqcyfqDt7eCihc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=jGfJyFnA; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51RMbm1e032471
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 15:06:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2021-q4;
	 bh=vCIsZt403ulsh6i+1Y7fMucf02/XpxKVHcBj4IVeiiA=; b=jGfJyFnAQszI
	2ufui3RvKjM83ALgN63+lwWFbsbDB4L2MAQgcbedrS8irYOU9R6KNTZoAHosD9pj
	odb2mhidwdrdbHsMvoqSA4Ssw4597YjDBRGD0QdoFElP4ndpHVhGTHc+6gwTKew+
	FzvXUlbYbEK1B2MwWxbly1zZupamgNeQD9c5eA27ms2asLLXClVf+j/V3spHPMcG
	uxJH3fBpDOkAZASBzkKjYoB+mVefeYTOznEzDl2/T8atnNnkFu0qVQxYAhVFU/vO
	DP1T3BwBG8/k65iaKppmztGjEp0V0ZKE1yc+Cn0qw8pfEfRlU4xzAhzUD8xSBVGD
	zBXNJHaEYw==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4530qwga3s-13
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 15:06:45 -0800 (PST)
Received: from twshared18153.09.ash9.facebook.com (2620:10d:c0a8:fe::f072) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Thu, 27 Feb 2025 23:06:34 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 9A9C318885339; Thu, 27 Feb 2025 15:06:31 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>, <kvm@vger.kernel.org>
CC: <leiyang@redhat.com>, <virtualization@lists.linux.dev>, <x86@kernel.org>,
        <netdev@vger.kernel.org>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv3 1/2] vhost: return task creation error instead of NULL
Date: Thu, 27 Feb 2025 15:06:30 -0800
Message-ID: <20250227230631.303431-2-kbusch@meta.com>
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
X-Proofpoint-ORIG-GUID: C-6vNMll4xCMybdJAZz9RlkhkAOgBTL5
X-Proofpoint-GUID: C-6vNMll4xCMybdJAZz9RlkhkAOgBTL5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-27_08,2025-02-27_01,2024-11-22_01

From: Keith Busch <kbusch@kernel.org>

Lets callers distinguish why the vhost task creation failed. No one
currently cares why it failed, so no real runtime change from this
patch, but that will not be the case for long.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 drivers/vhost/vhost.c  | 2 +-
 kernel/vhost_task.c    | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d4ac4a1f8b81b..18ca1ea6dc240 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7471,7 +7471,7 @@ static void kvm_mmu_start_lpage_recovery(struct onc=
e *once)
 				      kvm_nx_huge_page_recovery_worker_kill,
 				      kvm, "kvm-nx-lpage-recovery");
=20
-	if (!nx_thread)
+	if (IS_ERR(nx_thread))
 		return;
=20
 	vhost_task_start(nx_thread);
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 9ac25d08f473e..63612faeab727 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -666,7 +666,7 @@ static struct vhost_worker *vhost_worker_create(struc=
t vhost_dev *dev)
=20
 	vtsk =3D vhost_task_create(vhost_run_work_list, vhost_worker_killed,
 				 worker, name);
-	if (!vtsk)
+	if (IS_ERR(vtsk))
 		goto free_worker;
=20
 	mutex_init(&worker->mutex);
diff --git a/kernel/vhost_task.c b/kernel/vhost_task.c
index 8800f5acc0071..2ef2e1b800916 100644
--- a/kernel/vhost_task.c
+++ b/kernel/vhost_task.c
@@ -133,7 +133,7 @@ struct vhost_task *vhost_task_create(bool (*fn)(void =
*),
=20
 	vtsk =3D kzalloc(sizeof(*vtsk), GFP_KERNEL);
 	if (!vtsk)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	init_completion(&vtsk->exited);
 	mutex_init(&vtsk->exit_mutex);
 	vtsk->data =3D arg;
@@ -145,7 +145,7 @@ struct vhost_task *vhost_task_create(bool (*fn)(void =
*),
 	tsk =3D copy_process(NULL, 0, NUMA_NO_NODE, &args);
 	if (IS_ERR(tsk)) {
 		kfree(vtsk);
-		return NULL;
+		return ERR_PTR(PTR_ERR(tsk));
 	}
=20
 	vtsk->task =3D tsk;
--=20
2.43.5


