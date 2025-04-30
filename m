Return-Path: <kvm+bounces-44987-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B7543AA5578
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 22:25:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 250C0166E8F
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 20:25:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FDD927700B;
	Wed, 30 Apr 2025 20:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XbJG3jOy"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DCAD2D0AA2
	for <kvm@vger.kernel.org>; Wed, 30 Apr 2025 20:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746044641; cv=none; b=W4Re9GVUhz9XQ+8PwFgqzmK5vdEMWnKV7XJNv5TLVlx38WvbAO7QYBWamB9/u4WKlyWNFxtbjHDwjuYUAWLpnYbQEvCC+J/6cOiBZawvHmQBcFv+tJv9xs2L7ta5arKWcEpNwYyTRjFuPG5dZCT2iwpvZt7LiK/sQWxiqukDx7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746044641; c=relaxed/simple;
	bh=e0k7kAtfuw3ZmlklUuw6SXBXSm2o7IJFdIgicj6fkHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nQI8pUry11r+wQm3wKSMHJNPR9QDW4tI+3GlMJ+sARHbLkDz2L1JFXQxbx57iZQNRGyrHNNXJVcs45GRJJGIN4fhxIAYj5YuHYbdEOO4+m7MsVDCSMuFCGF+rlvuC0Xvv+fSYEs9PMlmfCQiZc1wtPDGJTgAn707Mp/gumj8GUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XbJG3jOy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746044638;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+MZvmRfCtI61m/XdI87EqyqLvZ2yGHt28AUm8pnJCIE=;
	b=XbJG3jOynr+K0pooMGPRkVOTCg6hSOy4MCKX7KLlBKy3CR5LtTyyXUBg8N5rRDl6LTibM7
	V/nl8w3dwzYugxGC2FsU1UVY/D5TI6fPksLR06uYmB6EDtGx1p3vVn/ZiioxurzK0w+bqD
	uuojAjn7oraBIntyiouFWf6xxH2m1Tc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-587-D2VxUS_sMJ2DiK9mwB2K1A-1; Wed,
 30 Apr 2025 16:23:53 -0400
X-MC-Unique: D2VxUS_sMJ2DiK9mwB2K1A-1
X-Mimecast-MFC-AGG-ID: D2VxUS_sMJ2DiK9mwB2K1A_1746044629
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A93711800570;
	Wed, 30 Apr 2025 20:23:48 +0000 (UTC)
Received: from intellaptop.lan (unknown [10.22.80.5])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 421A71800871;
	Wed, 30 Apr 2025 20:23:43 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Will Deacon <will@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Kunkun Jiang <jiangkunkun@huawei.com>,
	Jing Zhang <jingzhangos@google.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Keisuke Nishimura <keisuke.nishimura@inria.fr>,
	Anup Patel <anup@brainfault.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Atish Patra <atishp@atishpatra.org>,
	kvmarm@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	linux-arm-kernel@lists.infradead.org,
	Peter Zijlstra <peterz@infradead.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Sebastian Ott <sebott@redhat.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Borislav Petkov <bp@alien8.de>,
	Sean Christopherson <seanjc@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Shusen Li <lishusen2@huawei.com>,
	kvm-riscv@lists.infradead.org
Subject: [PATCH v3 4/4] x86: KVM: SEV: implement kvm_lock_all_vcpus and use it
Date: Wed, 30 Apr 2025 16:23:11 -0400
Message-ID: <20250430202311.364641-5-mlevitsk@redhat.com>
In-Reply-To: <20250430202311.364641-1-mlevitsk@redhat.com>
References: <20250430202311.364641-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Implement kvm_lock_all_vcpus() and use it instead of
sev own sev_{lock|unlock}_vcpus_for_migration().

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/sev.c   | 72 +++-------------------------------------
 include/linux/kvm_host.h |  1 +
 virt/kvm/kvm_main.c      | 25 ++++++++++++++
 3 files changed, 30 insertions(+), 68 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0bc708ee2788..16db6179013d 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1882,70 +1882,6 @@ static void sev_unlock_two_vms(struct kvm *dst_kvm, struct kvm *src_kvm)
 	atomic_set_release(&src_sev->migration_in_progress, 0);
 }
 
-/* vCPU mutex subclasses.  */
-enum sev_migration_role {
-	SEV_MIGRATION_SOURCE = 0,
-	SEV_MIGRATION_TARGET,
-	SEV_NR_MIGRATION_ROLES,
-};
-
-static int sev_lock_vcpus_for_migration(struct kvm *kvm,
-					enum sev_migration_role role)
-{
-	struct kvm_vcpu *vcpu;
-	unsigned long i, j;
-
-	kvm_for_each_vcpu(i, vcpu, kvm) {
-		if (mutex_lock_killable_nested(&vcpu->mutex, role))
-			goto out_unlock;
-
-#ifdef CONFIG_PROVE_LOCKING
-		if (!i)
-			/*
-			 * Reset the role to one that avoids colliding with
-			 * the role used for the first vcpu mutex.
-			 */
-			role = SEV_NR_MIGRATION_ROLES;
-		else
-			mutex_release(&vcpu->mutex.dep_map, _THIS_IP_);
-#endif
-	}
-
-	return 0;
-
-out_unlock:
-
-	kvm_for_each_vcpu(j, vcpu, kvm) {
-		if (i == j)
-			break;
-
-#ifdef CONFIG_PROVE_LOCKING
-		if (j)
-			mutex_acquire(&vcpu->mutex.dep_map, role, 0, _THIS_IP_);
-#endif
-
-		mutex_unlock(&vcpu->mutex);
-	}
-	return -EINTR;
-}
-
-static void sev_unlock_vcpus_for_migration(struct kvm *kvm)
-{
-	struct kvm_vcpu *vcpu;
-	unsigned long i;
-	bool first = true;
-
-	kvm_for_each_vcpu(i, vcpu, kvm) {
-		if (first)
-			first = false;
-		else
-			mutex_acquire(&vcpu->mutex.dep_map,
-				      SEV_NR_MIGRATION_ROLES, 0, _THIS_IP_);
-
-		mutex_unlock(&vcpu->mutex);
-	}
-}
-
 static void sev_migrate_from(struct kvm *dst_kvm, struct kvm *src_kvm)
 {
 	struct kvm_sev_info *dst = to_kvm_sev_info(dst_kvm);
@@ -2083,10 +2019,10 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
 		charged = true;
 	}
 
-	ret = sev_lock_vcpus_for_migration(kvm, SEV_MIGRATION_SOURCE);
+	ret = kvm_lock_all_vcpus(kvm);
 	if (ret)
 		goto out_dst_cgroup;
-	ret = sev_lock_vcpus_for_migration(source_kvm, SEV_MIGRATION_TARGET);
+	ret = kvm_lock_all_vcpus(source_kvm);
 	if (ret)
 		goto out_dst_vcpu;
 
@@ -2100,9 +2036,9 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
 	ret = 0;
 
 out_source_vcpu:
-	sev_unlock_vcpus_for_migration(source_kvm);
+	kvm_unlock_all_vcpus(source_kvm);
 out_dst_vcpu:
-	sev_unlock_vcpus_for_migration(kvm);
+	kvm_unlock_all_vcpus(kvm);
 out_dst_cgroup:
 	/* Operates on the source on success, on the destination on failure.  */
 	if (charged)
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 10d6652c7aa0..a6140415c693 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1016,6 +1016,7 @@ static inline struct kvm_vcpu *kvm_get_vcpu_by_id(struct kvm *kvm, int id)
 void kvm_destroy_vcpus(struct kvm *kvm);
 
 int kvm_trylock_all_vcpus(struct kvm *kvm);
+int kvm_lock_all_vcpus(struct kvm *kvm);
 void kvm_unlock_all_vcpus(struct kvm *kvm);
 
 void vcpu_load(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 834f08dfa24c..9211b07b0565 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1392,6 +1392,31 @@ int kvm_trylock_all_vcpus(struct kvm *kvm)
 }
 EXPORT_SYMBOL_GPL(kvm_trylock_all_vcpus);
 
+/*
+ * Lock all of the VM's vCPUs.
+ * Assumes that the kvm->lock is held.
+ * Returns -EINTR if the process is killed.
+ */
+int kvm_lock_all_vcpus(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu;
+	unsigned long i, j;
+
+	kvm_for_each_vcpu(i, vcpu, kvm)
+		if (mutex_lock_killable_nest_lock(&vcpu->mutex, &kvm->lock))
+			goto out_unlock;
+	return 0;
+
+out_unlock:
+	kvm_for_each_vcpu(j, vcpu, kvm) {
+		if (i == j)
+			break;
+		mutex_unlock(&vcpu->mutex);
+	}
+	return -EINTR;
+}
+EXPORT_SYMBOL_GPL(kvm_lock_all_vcpus);
+
 void kvm_unlock_all_vcpus(struct kvm *kvm)
 {
 	struct kvm_vcpu *vcpu;
-- 
2.46.0


