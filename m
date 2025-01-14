Return-Path: <kvm+bounces-35438-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 50E40A10FE4
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 19:23:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DDA1B7A3912
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 18:22:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A78D1FA15A;
	Tue, 14 Jan 2025 18:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="ieLERKxQ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD93D232458
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 18:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736878966; cv=none; b=p6GObqg7NxW7EcO5zm9Dd+szaHknAl1dazoTajpGLCJDzlVjpLSQuVUzlTPDBjqym1trzNaRHx1lpeZ4LA8GDEC72A2D7b0e4LFWrzQ9zmrnAvYG9jvhvuRu2VUdRn5TOfVGZRWaVgj2UHiefmheJNMo2zST8cld53gshcdb9X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736878966; c=relaxed/simple;
	bh=Z0lime3e2R0jhvU6ZibVA8s6c/Jk1bq7YA9glNsBWqg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=XWvOiJWcpYe5NInDqySGMO830PQK09mj8E7Vtj8itu5VZBG0I48+5DD//bLljgCNJ+bz/wDAdh27ulXl3JyFgwxbs36wtOnUDPO8ZSLouui6YUrjnlOg/tH4v0MAW+q/YcezyqIX+iAJetMNZ5djNNHnkeQ2nz3u5lQLcWeQglc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=ieLERKxQ; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50EI2UjP021448
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 10:22:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2021-q4; bh=tzv7kDexPXjkVr0dQP
	3l+Fuqia3TwSfGwjQ2QmPRY/w=; b=ieLERKxQneBOJl3guPcXjMREkksodcD5Ed
	PUHeaTyYJOYcFx80X93qdxo8aS7H89HRblfX1ylxj50VjObQ+Si29cDiwYfAAE5c
	rltTYUW1jMCt7BLD7Q4AK/q5yInU9mfYiju1JSsLxKTdKMVs7lDZ2sIAFPKMZqAd
	YI3HZV3TM40sNC+NsdagGcwcUXYwCv7ypOGjoYkdjNzll3sSmWycShj8yxDk1Rq4
	GMfrI0gukhv7Acw5adlOHjyWiymAEElp/XdWwgct7hwBE7CHz+7m9t2wqSxuzSDZ
	5zF9jLhvhobgIihedmXNtBS2H+dHyW+i+xfHgG+Hi+Ze0Kj38mAA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 445vuur5un-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 10:22:43 -0800 (PST)
Received: from twshared3815.08.ash9.facebook.com (2620:10d:c0a8:1c::11) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Tue, 14 Jan 2025 18:22:41 +0000
Received: by devbig638.nha1.facebook.com (Postfix, from userid 544533)
	id 8A60016E4BE2B; Tue, 14 Jan 2025 10:22:31 -0800 (PST)
From: Keith Busch <kbusch@meta.com>
To: <kvm@vger.kernel.org>, <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <tj@kernel.org>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [PATCH] kvm: defer huge page recovery vhost task to later
Date: Tue, 14 Jan 2025 10:22:29 -0800
Message-ID: <20250114182229.1861709-1-kbusch@meta.com>
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
X-Proofpoint-GUID: HUqotXtHUD9D3WkIFsxgOGtlFf0kp6uU
X-Proofpoint-ORIG-GUID: HUqotXtHUD9D3WkIFsxgOGtlFf0kp6uU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-05_03,2024-10-04_01,2024-09-30_01

From: Keith Busch <kbusch@kernel.org>

Some libraries ensure they are single threaded before forking. This
assumption breaks after making kvm hugepage recovery thread a vhost task
of the user process. The minijail library used by crosvm is one such
affected application.

Defer the task to after the first VM_RUN call, which occurs after the
parent process has forked all its jailed child processes and should be
safe to start the vhost task.

Link: https://lore.kernel.org/kvm/Z2RYyagu3phDFIac@kbusch-mbp.dhcp.thefac=
ebook.com/
Fixes: d96c77bd4eeba46 ("KVM: x86: switch hugepage recovery thread to vho=
st_task")
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 arch/x86/kvm/mmu/mmu.c   |  2 ++
 arch/x86/kvm/x86.c       |  9 ++++-----
 include/linux/kvm_host.h |  1 -
 virt/kvm/kvm_main.c      | 15 ---------------
 4 files changed, 6 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 2401606db2604..422b6b06de4fe 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7415,6 +7415,8 @@ int kvm_mmu_post_init_vm(struct kvm *kvm)
 {
 	if (nx_hugepage_mitigation_hard_disabled)
 		return 0;
+	if (kvm->arch.nx_huge_page_recovery_thread)
+		return 0;
=20
 	kvm->arch.nx_huge_page_last =3D get_jiffies_64();
 	kvm->arch.nx_huge_page_recovery_thread =3D vhost_task_create(
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c79a8cc57ba42..263363c46626b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11463,6 +11463,10 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcp=
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
@@ -12740,11 +12744,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned l=
ong type)
 	return ret;
 }
=20
-int kvm_arch_post_init_vm(struct kvm *kvm)
-{
-	return kvm_mmu_post_init_vm(kvm);
-}
-
 static void kvm_unload_vcpu_mmu(struct kvm_vcpu *vcpu)
 {
 	vcpu_load(vcpu);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 401439bb21e3e..a219bd2d8aec8 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1596,7 +1596,6 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu=
);
 bool kvm_arch_dy_runnable(struct kvm_vcpu *vcpu);
 bool kvm_arch_dy_has_pending_interrupt(struct kvm_vcpu *vcpu);
 bool kvm_arch_vcpu_preempted_in_kernel(struct kvm_vcpu *vcpu);
-int kvm_arch_post_init_vm(struct kvm *kvm);
 void kvm_arch_pre_destroy_vm(struct kvm *kvm);
 void kvm_arch_create_vm_debugfs(struct kvm *kvm);
=20
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index de2c11dae2316..adacc6eaa7d9d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1065,15 +1065,6 @@ static int kvm_create_vm_debugfs(struct kvm *kvm, =
const char *fdname)
 	return ret;
 }
=20
-/*
- * Called after the VM is otherwise initialized, but just before adding =
it to
- * the vm_list.
- */
-int __weak kvm_arch_post_init_vm(struct kvm *kvm)
-{
-	return 0;
-}
-
 /*
  * Called just after removing the VM from the vm_list, but before doing =
any
  * other destruction.
@@ -1194,10 +1185,6 @@ static struct kvm *kvm_create_vm(unsigned long typ=
e, const char *fdname)
 	if (r)
 		goto out_err_no_debugfs;
=20
-	r =3D kvm_arch_post_init_vm(kvm);
-	if (r)
-		goto out_err;
-
 	mutex_lock(&kvm_lock);
 	list_add(&kvm->vm_list, &vm_list);
 	mutex_unlock(&kvm_lock);
@@ -1207,8 +1194,6 @@ static struct kvm *kvm_create_vm(unsigned long type=
, const char *fdname)
=20
 	return kvm;
=20
-out_err:
-	kvm_destroy_vm_debugfs(kvm);
 out_err_no_debugfs:
 	kvm_coalesced_mmio_free(kvm);
 out_no_coalesced_mmio:
--=20
2.43.5


