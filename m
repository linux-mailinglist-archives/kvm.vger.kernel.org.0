Return-Path: <kvm+bounces-39219-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 26CA2A45342
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 03:44:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 589CA3AD045
	for <lists+kvm@lfdr.de>; Wed, 26 Feb 2025 02:43:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4697221C9F6;
	Wed, 26 Feb 2025 02:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="MhaF4XQX"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFFB121CA01
	for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 02:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740537802; cv=none; b=Z9oKB1T7pdoMv1HFaHHgcFCaUrPXfMYj5NUQ8EgJ0RZQLWjSHaUqNG5AC+KfnY3hYGolT8BZhe8lrdc4q4iLPynIb+GoCPkRu3lnBVpmn4lXwPCBeaU7vcJdpBi4YsXT0A1TP2TF4GACgmLstbcd50ptd9qpBjIReQqLxkdd/zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740537802; c=relaxed/simple;
	bh=V2FqWIT+Z6/06b6hrfSlcFnTHsvXjpIJFLKD0J4yUCM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=WbOhROnZItAeVB43T5smaoAa/vSL0NEQ6oiTTlJGYS6b1o1fqKplFTlJbFcAGf/9JjG4Cp4PByPRi+m5TRpi7ovZtLHI4oMZpDEZ33ZvHJVS21HQgbQH7/hzTKu/81zJ2l1pvECapc3rBs8YUTloBkYAqFGMRQvuD87QsZ3VSkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=MhaF4XQX; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51Q26EqD021617
	for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 18:43:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2021-q4; bh=QnqXsEXt/JGgz9Hcnv
	hv/HXTKzsw1tyQTNw7EIVzDcM=; b=MhaF4XQXmuTkbOHZ9XU/+rsJqgKZYve7p9
	XQPVLX34yd30PxYKIjsqJJsJL3co00oocsthzbcE5ZR7AJWl+pCLshmZ/wn7BD3h
	KyroDz9mGGKPlSHZvuHCou+CpfBqX8/eFmWTqAuLiKIu9Id7Lv9tuXJToKOSGk/s
	1ohB6mjZbqraMv+xHWejKW6yGyYxHkQqD6nzxI8+if6eZCio0PhUUBA8keHqAc4s
	NNvvkGXcqLOvnh2LPQqpGvQldVhmGxSFxRFbpnbWLFon1A4qhtEAiS9eU16ARXTy
	+ct9+tZgJK0b4u1gxjZpR64hBIXnyrHhET0Zy/2za/eNcmC6t3Sg==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 451ps39s6a-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 18:43:19 -0800 (PST)
Received: from twshared7122.08.ash9.facebook.com (2620:10d:c085:208::7cb7) by
 mail.thefacebook.com (2620:10d:c08b:78::c78f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Wed, 26 Feb 2025 02:43:09 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 56E4A1875B216; Tue, 25 Feb 2025 18:43:06 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <pbonzini@redhat.com>, <seanjc@google.com>, <kvm@vger.kernel.org>
CC: <x86@kernel.org>, <virtualization@lists.linux.dev>,
        <linux-kernel@vger.kernel.org>, Keith Busch <kbusch@kernel.org>
Subject: [RFC 2/2] kvm: retry nx_huge_page_recovery_thread creation
Date: Tue, 25 Feb 2025 18:43:04 -0800
Message-ID: <20250226024304.1807955-1-kbusch@meta.com>
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
X-Proofpoint-GUID: fZi7mz0TiEA4SZb5h5ueWMAh8yWeYIuu
X-Proofpoint-ORIG-GUID: fZi7mz0TiEA4SZb5h5ueWMAh8yWeYIuu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-25_08,2025-02-25_03,2024-11-22_01

From: Keith Busch <kbusch@kernel.org>

A VMM may send a signal to its threads while they've entered KVM_RUN. If
that thread happens to be trying to make the huge page recovery vhost
task, then it fails with -ERESTARTNOINTR. We need to retry if that
happens, so we can't use call_once anymore. Replace it with a simple
mutex and return the appropriate error instead of defaulting to ENOMEM.

One downside is that everyone will retry if it fails, which can cause
some additional pressure on low memory situations. Another downside is
we're taking a mutex on every KVM run, even if we were previously
successful in starting the vhost task, but that's really not such a
common operation that needs to be optimized to avoid this lock.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 arch/x86/include/asm/kvm_host.h |  3 +--
 arch/x86/kvm/mmu/mmu.c          | 23 +++++++++--------------
 arch/x86/kvm/x86.c              |  2 +-
 3 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
index 0b7af5902ff75..597c8e66fc204 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -26,7 +26,6 @@
 #include <linux/irqbypass.h>
 #include <linux/kfifo.h>
 #include <linux/sched/vhost_task.h>
-#include <linux/call_once.h>
=20
 #include <asm/apic.h>
 #include <asm/pvclock-abi.h>
@@ -1466,7 +1465,7 @@ struct kvm_arch {
 	struct kvm_x86_pmu_event_filter __rcu *pmu_event_filter;
 	struct vhost_task *nx_huge_page_recovery_thread;
 	u64 nx_huge_page_last;
-	struct once nx_once;
+	struct mutex nx_lock;
=20
 #ifdef CONFIG_X86_64
 	/* The number of TDP MMU pages across all roots. */
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 18ca1ea6dc240..eb6b625f6f43a 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7460,34 +7460,29 @@ static bool kvm_nx_huge_page_recovery_worker(void=
 *data)
 	return true;
 }
=20
-static void kvm_mmu_start_lpage_recovery(struct once *once)
+int kvm_mmu_post_init_vm(struct kvm *kvm)
 {
-	struct kvm_arch *ka =3D container_of(once, struct kvm_arch, nx_once);
-	struct kvm *kvm =3D container_of(ka, struct kvm, arch);
 	struct vhost_task *nx_thread;
=20
+	if (nx_hugepage_mitigation_hard_disabled)
+		return 0;
+
+	guard(mutex)(&kvm->arch.nx_lock);
+	if (kvm->arch.nx_huge_page_recovery_thread)
+		return 0;
+
 	kvm->arch.nx_huge_page_last =3D get_jiffies_64();
 	nx_thread =3D vhost_task_create(kvm_nx_huge_page_recovery_worker,
 				      kvm_nx_huge_page_recovery_worker_kill,
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
-}
-
-int kvm_mmu_post_init_vm(struct kvm *kvm)
-{
-	if (nx_hugepage_mitigation_hard_disabled)
-		return 0;
-
-	call_once(&kvm->arch.nx_once, kvm_mmu_start_lpage_recovery);
-	if (!kvm->arch.nx_huge_page_recovery_thread)
-		return -ENOMEM;
 	return 0;
 }
=20
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 02159c967d29e..872498566b540 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12744,7 +12744,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned lo=
ng type)
 			     "does not run without ignore_msrs=3D1, please report it to kvm@v=
ger.kernel.org.\n");
 	}
=20
-	once_init(&kvm->arch.nx_once);
+	mutex_init(&kvm->arch.nx_lock);
 	return 0;
=20
 out_uninit_mmu:
--=20
2.43.5


