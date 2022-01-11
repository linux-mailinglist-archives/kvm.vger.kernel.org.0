Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BDF748B10F
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 16:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240010AbiAKPk7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 10:40:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239773AbiAKPk6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jan 2022 10:40:58 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B54B9C061748
        for <kvm@vger.kernel.org>; Tue, 11 Jan 2022 07:40:58 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id i129-20020a255487000000b006107b38b495so25426715ybb.16
        for <kvm@vger.kernel.org>; Tue, 11 Jan 2022 07:40:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=T42iHV28VeOQOSr6+/jPZLYHOPmxU90EiajYoOWkuKs=;
        b=CXKrmFoMgA/idPVTdcgeKlKj97I4kSjTasFYbuJfvU0rRxnErMfkEWCGxaaLForzZ0
         XD0jnj24uOAzP/cU4djQ4KSiZk0n7TN79KMPRxCB6FaRbX4BEk/Rklaggh0kzyPJ/1nS
         VJOqmreHtxrx+85ZpjMO1csw4IhJvLpBDMFY1VSBkuQgDeNUS7Ru6n6aGxktaGbnithE
         waFKcVc89ifkaMdq6kAu2mrI4chpPfpRS8XGw1nZsE+zQtjLzjhUZ6tOWsi+ljMQkWCs
         807atYnm9TPYV3fEAOfABR1MpdLTWXNK/cTT2DjhiRXLdDXfrH5jDWVtUupDE3gsaZX9
         HbJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=T42iHV28VeOQOSr6+/jPZLYHOPmxU90EiajYoOWkuKs=;
        b=erHFSM9rlKzgttlmJTy9FgQV9/dm5Kivbx4hCCCEmo/uVjccccCo6ViEb72VEZuRSG
         BKjzzga0+751X4nU8QnOj+cE7KmVrISv8DFHRmjsC88nznDrpE1xRB7ZfixNG5isJVWx
         C6iMHDq9oYs3wRQ1tG2pQnrBOrrOWwtpcjSaIOh5kX/U6TXA59MF2yRfIrFs+v6hTUjn
         o/ofh5l1fEQJwpj2oiNYRYGaY8LGBBnujdrHgbMhlqmVsNNnrbr/HINVTqLb+DqznFYn
         WTOfOiwqtJWxuNE/5cM1mZ8yOgG6jdnuDOiQGOfQ6N312KMyTWqwyBKIY86EZXVEHxni
         1NQQ==
X-Gm-Message-State: AOAM5326pCBlWY8ENpch664PTF84bN+f7HOMBL/ex8Q+P9Iqlh8soeKe
        0cZTteTep68MyBQa2Dcz7zAqL7Zz1iNve3VWSRrefUhtQGtN/pqmlsuO6MJhCEYdd79QQKRyQ12
        xXIwIh/jB5nlI7NQL/IeS6qsToD5afLD+pBMCklxuUfuZKsEOuQTRyM5JtQ==
X-Google-Smtp-Source: ABdhPJyxFwn9MvYTDU9n4J/DClDNTiWQjW15TZxBxG09HzMX1+Shm2icLskC2lCjrznUlV5XCw2DiSv9AT8=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:4f78:6ed1:42d2:b0a7])
 (user=pgonda job=sendgmr) by 2002:a25:680e:: with SMTP id d14mr2781511ybc.522.1641915657861;
 Tue, 11 Jan 2022 07:40:57 -0800 (PST)
Date:   Tue, 11 Jan 2022 07:40:48 -0800
Message-Id: <20220111154048.2108264-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.34.1.575.g55b058a8bb-goog
Subject: [PATCH] KVM: SEV: Allow SEV intra-host migration of VM with mirrors
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Orr <marcorr@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For SEV-ES VMs with mirrors to be intra-host migrated they need to be
able to migrate with the mirror. This is due to that fact that all VMSAs
need to be added into the VM with LAUNCH_UPDATE_VMSA before
lAUNCH_FINISH. Allowing migration with mirrors allows users of SEV-ES to
keep the mirror VMs VMSAs during migration.

Adds a list of mirror VMs for the original VM iterate through during its
migration. During the iteration the owner pointers can be updated from
the source to the destination. This fixes the ASID leaking issue which
caused the blocking of migration of VMs with mirrors.

Signed-off-by: Peter Gonda <pgonda@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Orr <marcorr@google.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 arch/x86/kvm/svm/sev.c                        | 45 ++++++++++++-----
 arch/x86/kvm/svm/svm.h                        |  4 ++
 .../selftests/kvm/x86_64/sev_migrate_tests.c  | 48 +++++++++++++------
 3 files changed, 70 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 322553322202..e396ae04f891 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -258,6 +258,7 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		goto e_free;
 
 	INIT_LIST_HEAD(&sev->regions_list);
+	INIT_LIST_HEAD(&sev->mirror_vms);
 
 	return 0;
 
@@ -1623,22 +1624,41 @@ static void sev_unlock_vcpus_for_migration(struct kvm *kvm)
 	}
 }
 
-static void sev_migrate_from(struct kvm_sev_info *dst,
-			      struct kvm_sev_info *src)
+static void sev_migrate_from(struct kvm *dst_kvm, struct kvm *src_kvm)
 {
+	struct kvm_sev_info *dst = &to_kvm_svm(dst_kvm)->sev_info;
+	struct kvm_sev_info *src = &to_kvm_svm(src_kvm)->sev_info;
+	struct kvm_sev_info *mirror, *tmp;
+
 	dst->active = true;
 	dst->asid = src->asid;
 	dst->handle = src->handle;
 	dst->pages_locked = src->pages_locked;
 	dst->enc_context_owner = src->enc_context_owner;
+	dst->num_mirrored_vms = src->num_mirrored_vms;
 
 	src->asid = 0;
 	src->active = false;
 	src->handle = 0;
 	src->pages_locked = 0;
 	src->enc_context_owner = NULL;
+	src->num_mirrored_vms = 0;
 
 	list_cut_before(&dst->regions_list, &src->regions_list, &src->regions_list);
+	list_cut_before(&dst->mirror_vms, &src->mirror_vms, &src->mirror_vms);
+
+	/*
+	 * If this VM has mirrors we need to update the KVM refcounts from the
+	 * source to the destination.
+	 */
+	if (dst->num_mirrored_vms > 0) {
+		list_for_each_entry_safe(mirror, tmp, &dst->mirror_vms,
+					  mirror_entry) {
+			kvm_get_kvm(dst_kvm);
+			kvm_put_kvm(src_kvm);
+			mirror->enc_context_owner = dst_kvm;
+		}
+	}
 }
 
 static int sev_es_migrate_from(struct kvm *dst, struct kvm *src)
@@ -1708,15 +1728,6 @@ int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
 
 	src_sev = &to_kvm_svm(source_kvm)->sev_info;
 
-	/*
-	 * VMs mirroring src's encryption context rely on it to keep the
-	 * ASID allocated, but below we are clearing src_sev->asid.
-	 */
-	if (src_sev->num_mirrored_vms) {
-		ret = -EBUSY;
-		goto out_unlock;
-	}
-
 	dst_sev->misc_cg = get_current_misc_cg();
 	cg_cleanup_sev = dst_sev;
 	if (dst_sev->misc_cg != src_sev->misc_cg) {
@@ -1738,7 +1749,7 @@ int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
 		if (ret)
 			goto out_source_vcpu;
 	}
-	sev_migrate_from(dst_sev, src_sev);
+	sev_migrate_from(kvm, source_kvm);
 	kvm_vm_dead(source_kvm);
 	cg_cleanup_sev = src_sev;
 	ret = 0;
@@ -2009,9 +2020,10 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
 	source_sev = &to_kvm_svm(source_kvm)->sev_info;
 	kvm_get_kvm(source_kvm);
 	source_sev->num_mirrored_vms++;
+	mirror_sev = &to_kvm_svm(kvm)->sev_info;
+	list_add_tail(&mirror_sev->mirror_entry, &source_sev->mirror_vms);
 
 	/* Set enc_context_owner and copy its encryption context over */
-	mirror_sev = &to_kvm_svm(kvm)->sev_info;
 	mirror_sev->enc_context_owner = source_kvm;
 	mirror_sev->active = true;
 	mirror_sev->asid = source_sev->asid;
@@ -2050,10 +2062,17 @@ void sev_vm_destroy(struct kvm *kvm)
 	if (is_mirroring_enc_context(kvm)) {
 		struct kvm *owner_kvm = sev->enc_context_owner;
 		struct kvm_sev_info *owner_sev = &to_kvm_svm(owner_kvm)->sev_info;
+		struct kvm_sev_info *mirror, *tmp;
 
 		mutex_lock(&owner_kvm->lock);
 		if (!WARN_ON(!owner_sev->num_mirrored_vms))
 			owner_sev->num_mirrored_vms--;
+
+		list_for_each_entry_safe(mirror, tmp, &owner_sev->mirror_vms,
+					  mirror_entry)
+			if (mirror == sev)
+				list_del(&mirror->mirror_entry);
+
 		mutex_unlock(&owner_kvm->lock);
 		kvm_put_kvm(owner_kvm);
 		return;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index daa8ca84afcc..b9f5e33d5232 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -81,6 +81,10 @@ struct kvm_sev_info {
 	u64 ap_jump_table;	/* SEV-ES AP Jump Table address */
 	struct kvm *enc_context_owner; /* Owner of copied encryption context */
 	unsigned long num_mirrored_vms; /* Number of VMs sharing this ASID */
+	union {
+		struct list_head mirror_vms; /* List of VMs mirroring */
+		struct list_head mirror_entry; /* Use as a list entry of mirrors */
+	};
 	struct misc_cg *misc_cg; /* For misc cgroup accounting */
 	atomic_t migration_in_progress;
 };
diff --git a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
index 80056bbbb003..cb1962c89945 100644
--- a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
+++ b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
@@ -341,37 +341,57 @@ static void test_sev_mirror_parameters(void)
 
 static void test_sev_move_copy(void)
 {
-	struct kvm_vm *dst_vm, *sev_vm, *mirror_vm, *dst_mirror_vm;
-	int ret;
+	struct kvm_vm *dst_vm, *dst2_vm, *dst3_vm, *sev_vm, *mirror_vm,
+		      *dst_mirror_vm, *dst2_mirror_vm, *dst3_mirror_vm;
 
 	sev_vm = sev_vm_create(/* es= */ false);
 	dst_vm = aux_vm_create(true);
+	dst2_vm = aux_vm_create(true);
+	dst3_vm = aux_vm_create(true);
 	mirror_vm = aux_vm_create(false);
 	dst_mirror_vm = aux_vm_create(false);
+	dst2_mirror_vm = aux_vm_create(false);
+	dst3_mirror_vm = aux_vm_create(false);
 
 	sev_mirror_create(mirror_vm->fd, sev_vm->fd);
-	ret = __sev_migrate_from(dst_vm->fd, sev_vm->fd);
-	TEST_ASSERT(ret == -1 && errno == EBUSY,
-		    "Cannot migrate VM that has mirrors. ret %d, errno: %d\n", ret,
-		    errno);
 
-	/* The mirror itself can be migrated.  */
 	sev_migrate_from(dst_mirror_vm->fd, mirror_vm->fd);
-	ret = __sev_migrate_from(dst_vm->fd, sev_vm->fd);
-	TEST_ASSERT(ret == -1 && errno == EBUSY,
-		    "Cannot migrate VM that has mirrors. ret %d, errno: %d\n", ret,
-		    errno);
+	sev_migrate_from(dst_vm->fd, sev_vm->fd);
+
+	sev_migrate_from(dst2_vm->fd, dst_vm->fd);
+	sev_migrate_from(dst2_mirror_vm->fd, dst_mirror_vm->fd);
+
+	sev_migrate_from(dst3_mirror_vm->fd, dst2_mirror_vm->fd);
+	sev_migrate_from(dst3_vm->fd, dst2_vm->fd);
+
+	kvm_vm_free(dst_vm);
+	kvm_vm_free(sev_vm);
+	kvm_vm_free(dst2_vm);
+	kvm_vm_free(dst3_vm);
+	kvm_vm_free(mirror_vm);
+	kvm_vm_free(dst_mirror_vm);
+	kvm_vm_free(dst2_mirror_vm);
+	kvm_vm_free(dst3_mirror_vm);
 
 	/*
-	 * mirror_vm is not a mirror anymore, dst_mirror_vm is.  Thus,
-	 * the owner can be copied as soon as dst_mirror_vm is gone.
+	 * Run similar test be destroy mirrors before mirrored VMs to ensure
+	 * destruction is done safely.
 	 */
-	kvm_vm_free(dst_mirror_vm);
+	sev_vm = sev_vm_create(/* es= */ false);
+	dst_vm = aux_vm_create(true);
+	mirror_vm = aux_vm_create(false);
+	dst_mirror_vm = aux_vm_create(false);
+
+	sev_mirror_create(mirror_vm->fd, sev_vm->fd);
+
+	sev_migrate_from(dst_mirror_vm->fd, mirror_vm->fd);
 	sev_migrate_from(dst_vm->fd, sev_vm->fd);
 
 	kvm_vm_free(mirror_vm);
+	kvm_vm_free(dst_mirror_vm);
 	kvm_vm_free(dst_vm);
 	kvm_vm_free(sev_vm);
+
 }
 
 int main(int argc, char *argv[])
-- 
2.34.1.575.g55b058a8bb-goog

