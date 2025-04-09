Return-Path: <kvm+bounces-42977-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A918A81AA2
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 03:43:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9F4641B82E43
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 01:42:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33ACB17A2FA;
	Wed,  9 Apr 2025 01:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Pis5AP2F"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B153082899
	for <kvm@vger.kernel.org>; Wed,  9 Apr 2025 01:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744162929; cv=none; b=VYJm6brdufXDUkrL84Sep5FS+uuq9W3eBBM2zqYeQmOTnI6kTvpR8zkYasV5yzFr3NNu98kK7fVwy6WirwYrnWO+cA0gx9AUwJ7OWTG7UqTVfzj3NEk46rI+Dgz/vRYlIF9vzTdHVhaYZQif0kO7fQlCWqCMuCp6cDoLf6KkzlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744162929; c=relaxed/simple;
	bh=z+wS1qgLXSHAVQOurV7aKrgTqPvBaXmiIuNq8wN5fmo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=e9htP4orgpkIRG+YEluXvslJwye6rGNvGowBTAHPAoNFcEuZkf0Xkoy0HBMnsqDdT/eoSuLlM+zHzR9I9VeCkrum6IJblXGnAwLqIxtSMf2PTyAuFVWh62XTeePrYF6q8NdA4V1bRy8B8720coJ7rjz6TF57VE4mog1FaT/1Q2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Pis5AP2F; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744162926;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vnuRl7pX40qfpQY8we1PeXSyE5JlXKbBJtvXtdb+Rj4=;
	b=Pis5AP2FzPntavLwvoqy80hbmJ0rwyCDQAklHPwaoLY/mC532BzxT5dTzHaUUHeA2Ze73l
	c8PadohQqj9t9KeDzPV0h2iVOT/4TkVDgO3BtIqIyvrEgwGpAoVt62SrywoIixWQLvQRi0
	3A8v9HI1YMtEHkigF6AFPYKthFAp724=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-686-KEvlSNwBOry_feClk1BOow-1; Tue,
 08 Apr 2025 21:42:03 -0400
X-MC-Unique: KEvlSNwBOry_feClk1BOow-1
X-Mimecast-MFC-AGG-ID: KEvlSNwBOry_feClk1BOow_1744162919
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A66A5180034D;
	Wed,  9 Apr 2025 01:41:58 +0000 (UTC)
Received: from starship.lan (unknown [10.22.65.191])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3D7991801766;
	Wed,  9 Apr 2025 01:41:52 +0000 (UTC)
From: Maxim Levitsky <mlevitsk@redhat.com>
To: kvm@vger.kernel.org
Cc: Alexander Potapenko <glider@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	kvm-riscv@lists.infradead.org,
	Oliver Upton <oliver.upton@linux.dev>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Jing Zhang <jingzhangos@google.com>,
	Waiman Long <longman@redhat.com>,
	x86@kernel.org,
	Kunkun Jiang <jiangkunkun@huawei.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Anup Patel <anup@brainfault.org>,
	Albert Ou <aou@eecs.berkeley.edu>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Zenghui Yu <yuzenghui@huawei.com>,
	Borislav Petkov <bp@alien8.de>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Keisuke Nishimura <keisuke.nishimura@inria.fr>,
	Sebastian Ott <sebott@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Atish Patra <atishp@atishpatra.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Will Deacon <will@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	linux-riscv@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Joey Gouly <joey.gouly@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Andre Przywara <andre.przywara@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sean Christopherson <seanjc@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH v2 2/4] KVM: x86: move sev_lock/unlock_vcpus_for_migration to kvm_main.c
Date: Tue,  8 Apr 2025 21:41:34 -0400
Message-Id: <20250409014136.2816971-3-mlevitsk@redhat.com>
In-Reply-To: <20250409014136.2816971-1-mlevitsk@redhat.com>
References: <20250409014136.2816971-1-mlevitsk@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Move sev_lock/unlock_vcpus_for_migration to kvm_main and call the
new functions the kvm_lock_all_vcpus/kvm_unlock_all_vcpus
and kvm_lock_all_vcpus_nested.

This code allows to lock all vCPUs without triggering lockdep warning
about reaching MAX_LOCK_DEPTH depth by coercing the lockdep into
thinking that we release all the locks other than vcpu'0 lock
immediately after we take them.

No functional change intended.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/sev.c   | 65 +++---------------------------------
 include/linux/kvm_host.h |  6 ++++
 virt/kvm/kvm_main.c      | 71 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 81 insertions(+), 61 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 0bc708ee2788..7adc54b1f741 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1889,63 +1889,6 @@ enum sev_migration_role {
 	SEV_NR_MIGRATION_ROLES,
 };
 
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
@@ -2083,10 +2026,10 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
 		charged = true;
 	}
 
-	ret = sev_lock_vcpus_for_migration(kvm, SEV_MIGRATION_SOURCE);
+	ret = kvm_lock_all_vcpus_nested(kvm, false, SEV_MIGRATION_SOURCE);
 	if (ret)
 		goto out_dst_cgroup;
-	ret = sev_lock_vcpus_for_migration(source_kvm, SEV_MIGRATION_TARGET);
+	ret = kvm_lock_all_vcpus_nested(source_kvm, false, SEV_MIGRATION_TARGET);
 	if (ret)
 		goto out_dst_vcpu;
 
@@ -2100,9 +2043,9 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
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
index 1dedc421b3e3..30cf28bf5c80 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1015,6 +1015,12 @@ static inline struct kvm_vcpu *kvm_get_vcpu_by_id(struct kvm *kvm, int id)
 
 void kvm_destroy_vcpus(struct kvm *kvm);
 
+int kvm_lock_all_vcpus_nested(struct kvm *kvm, bool trylock, unsigned int role);
+void kvm_unlock_all_vcpus(struct kvm *kvm);
+
+#define kvm_lock_all_vcpus(kvm, trylock) \
+	kvm_lock_all_vcpus_nested(kvm, trylock, 0)
+
 void vcpu_load(struct kvm_vcpu *vcpu);
 void vcpu_put(struct kvm_vcpu *vcpu);
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 69782df3617f..71c0d8c35b4b 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1368,6 +1368,77 @@ static int kvm_vm_release(struct inode *inode, struct file *filp)
 	return 0;
 }
 
+
+/*
+ * Lock all VM vCPUs.
+ * Can be used nested (to lock vCPUS of two VMs for example)
+ */
+int kvm_lock_all_vcpus_nested(struct kvm *kvm, bool trylock, unsigned int role)
+{
+	struct kvm_vcpu *vcpu;
+	unsigned long i, j;
+
+	lockdep_assert_held(&kvm->lock);
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+
+		if (trylock && !mutex_trylock_nested(&vcpu->mutex, role))
+			goto out_unlock;
+		else if (!trylock && mutex_lock_killable_nested(&vcpu->mutex, role))
+			goto out_unlock;
+
+#ifdef CONFIG_PROVE_LOCKING
+		if (!i)
+			/*
+			 * Reset the role to one that avoids colliding with
+			 * the role used for the first vcpu mutex.
+			 */
+			role = MAX_LOCK_DEPTH - 1;
+		else
+			mutex_release(&vcpu->mutex.dep_map, _THIS_IP_);
+#endif
+	}
+
+	return 0;
+
+out_unlock:
+
+	kvm_for_each_vcpu(j, vcpu, kvm) {
+		if (i == j)
+			break;
+
+#ifdef CONFIG_PROVE_LOCKING
+		if (j)
+			mutex_acquire(&vcpu->mutex.dep_map, role, 0, _THIS_IP_);
+#endif
+
+		mutex_unlock(&vcpu->mutex);
+	}
+	return -EINTR;
+}
+EXPORT_SYMBOL_GPL(kvm_lock_all_vcpus_nested);
+
+void kvm_unlock_all_vcpus(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu;
+	unsigned long i;
+	bool first = true;
+
+	lockdep_assert_held(&kvm->lock);
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (first)
+			first = false;
+		else
+			mutex_acquire(&vcpu->mutex.dep_map,
+					MAX_LOCK_DEPTH - 1, 0, _THIS_IP_);
+
+		mutex_unlock(&vcpu->mutex);
+	}
+}
+EXPORT_SYMBOL_GPL(kvm_unlock_all_vcpus);
+
+
 /*
  * Allocation size is twice as large as the actual dirty bitmap size.
  * See kvm_vm_ioctl_get_dirty_log() why this is needed.
-- 
2.26.3


