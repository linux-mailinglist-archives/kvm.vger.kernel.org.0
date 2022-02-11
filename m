Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3B44B2DD1
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 20:38:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350365AbiBKTgz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 14:36:55 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243842AbiBKTgy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 14:36:54 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F40F7CF6
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 11:36:52 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id z14-20020a170902ccce00b0014d7a559635so3818954ple.16
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 11:36:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=zy8kaC+s0PszdMQxxh4E+7ubC1nD5KHx5j/eMOqBAow=;
        b=JiCIxl5i3Ow+wOb4bP2eoyQ42zIMIRopdcAT4C7bWYkxWZEFZqp4ZDUyf2t9iW/Idf
         xqvV6/j//1tjrAH8Sba1HTFqLbAz6iwaXPoDKgTqzc+zF9VVg4b8ssLmmyHYWJunFhHS
         I1yeBR06BZifoC0AuTTcVjG7ITaNP/WQVrCbdbhGryCNsqLQMXh/qT1OiLio66A2zlRx
         Xman4rinqMsFSqhrrRu8H8gipBRUB9IRjUvT3UZvFIWlmmcwduNtXnmoWCNbjzVkD7ir
         WYyglKnisaBJxXc+vnLCc0DJqO/8tDY1ApEizlV24YHHvufEl4baobBWXGT6fwR2hofA
         1XVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=zy8kaC+s0PszdMQxxh4E+7ubC1nD5KHx5j/eMOqBAow=;
        b=gXExZD6yfBrrAXgSYxmk5bp4zIoJtfzbtyCdwPiwQFd9jGssf9+38tvx3dgvGzqIsK
         U5Haxr3azOpb0cxmWnBOkCWqHMDRi3fDK733awXZewAqyJsiiBZye0wDegcWIUu3Pe4o
         bM4Sih+o+afgxb00P3v2r2/feAkyO9nI5X1SayMuFKpU0EYNqDtQvZi2lreZB5j3j9/x
         nHi/EmvJHoAFyZ7xnMCSEgyeOaZdtyl51W06V0KcZd/LtlUUaSEX3tBdNhAII6uHRSCU
         8QiBzMOup2dxGG/rSsMZepSZJG5MZ2ZMs3L6KMRyJo+AnwuQh3plN927y0WQx/idqG2C
         Dhlg==
X-Gm-Message-State: AOAM530VAevcjNI9txqJWz/Zi8rxfJadvRsXtd+qVZEWX1ONsWiJdvxj
        U/4I9utW9Knck29sNmsvVsmbA1/R7C02jFfTiW/rrI7J1/JKCrm3VKRpq4Sg075CwgKZ+xelDLs
        X2oPfLI90k0eyQ3QwVJ/FRaP89lD3SKng1Ej6iWEJAoM0mAOW9jRYU7miBw==
X-Google-Smtp-Source: ABdhPJyAMbyL4iI7CoYtgGuNgzIoXiwUTHsNehN1OTYlUO3jvreKcpoidDHRhbggAqc+2qgSEksPGCgd+fY=
X-Received: from pgonda1.kir.corp.google.com ([2620:15c:29:203:ce5a:31e5:3a1e:6c1f])
 (user=pgonda job=sendgmr) by 2002:a17:902:b60f:: with SMTP id
 b15mr2982475pls.88.1644608212269; Fri, 11 Feb 2022 11:36:52 -0800 (PST)
Date:   Fri, 11 Feb 2022 11:36:34 -0800
Message-Id: <20220211193634.3183388-1-pgonda@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
Subject: [PATCH v2] KVM: SEV: Allow SEV intra-host migration of VM with mirrors
From:   Peter Gonda <pgonda@google.com>
To:     kvm@vger.kernel.org
Cc:     Peter Gonda <pgonda@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
Cc: Marc Orr <marcorr@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---

base commit: f6ae04ddb347 

V2:
 * Remove union have different list head and list entry members. 
 * Simplify list deletion on destruction.
 * Added list updating when mirrors are intra-host migrated.

---
 arch/x86/kvm/svm/sev.c                        | 56 +++++++++++++------
 arch/x86/kvm/svm/svm.h                        |  3 +-
 .../selftests/kvm/x86_64/sev_migrate_tests.c  | 47 +++++++++++-----
 3 files changed, 73 insertions(+), 33 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f4d88292f337..d7337d099ece 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -258,6 +258,7 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		goto e_free;
 
 	INIT_LIST_HEAD(&sev->regions_list);
+	INIT_LIST_HEAD(&sev->mirror_vms);
 
 	return 0;
 
@@ -1623,9 +1624,12 @@ static void sev_unlock_vcpus_for_migration(struct kvm *kvm)
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
@@ -1639,6 +1643,31 @@ static void sev_migrate_from(struct kvm_sev_info *dst,
 	src->enc_context_owner = NULL;
 
 	list_cut_before(&dst->regions_list, &src->regions_list, &src->regions_list);
+
+	/*
+	 * If this VM has mirrors, "transfer" each mirror's refcount of the
+	 * source to the destination (this KVM).  The caller holds a reference
+	 * to the source, so there's no danger of use-after-free.
+	 */
+	list_cut_before(&dst->mirror_vms, &src->mirror_vms, &src->mirror_vms);
+	list_for_each_entry_safe(mirror, tmp, &dst->mirror_vms,
+				 mirror_entry) {
+		kvm_get_kvm(dst_kvm);
+		kvm_put_kvm(src_kvm);
+		mirror->enc_context_owner = dst_kvm;
+	}
+
+	/*
+	 * If this VM is a mirror, remove the old mirror from the owners list
+	 * and add the new mirror to the list.
+	 */
+	if (is_mirroring_enc_context(dst_kvm)) {
+		struct kvm_sev_info *owner_sev_info =
+			&to_kvm_svm(dst->enc_context_owner)->sev_info;
+
+		list_del(&src->mirror_entry);
+		list_add_tail(&dst->mirror_entry, &owner_sev_info->mirror_vms);
+	}
 }
 
 static int sev_es_migrate_from(struct kvm *dst, struct kvm *src)
@@ -1708,15 +1737,6 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
 
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
@@ -1738,7 +1758,8 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
 		if (ret)
 			goto out_source_vcpu;
 	}
-	sev_migrate_from(dst_sev, src_sev);
+
+	sev_migrate_from(kvm, source_kvm);
 	kvm_vm_dead(source_kvm);
 	cg_cleanup_sev = src_sev;
 	ret = 0;
@@ -2008,10 +2029,10 @@ int sev_vm_copy_enc_context_from(struct kvm *kvm, unsigned int source_fd)
 	 */
 	source_sev = &to_kvm_svm(source_kvm)->sev_info;
 	kvm_get_kvm(source_kvm);
-	source_sev->num_mirrored_vms++;
+	mirror_sev = &to_kvm_svm(kvm)->sev_info;
+	list_add_tail(&mirror_sev->mirror_entry, &source_sev->mirror_vms);
 
 	/* Set enc_context_owner and copy its encryption context over */
-	mirror_sev = &to_kvm_svm(kvm)->sev_info;
 	mirror_sev->enc_context_owner = source_kvm;
 	mirror_sev->active = true;
 	mirror_sev->asid = source_sev->asid;
@@ -2019,6 +2040,7 @@ int sev_vm_copy_enc_context_from(struct kvm *kvm, unsigned int source_fd)
 	mirror_sev->es_active = source_sev->es_active;
 	mirror_sev->handle = source_sev->handle;
 	INIT_LIST_HEAD(&mirror_sev->regions_list);
+	INIT_LIST_HEAD(&mirror_sev->mirror_vms);
 	ret = 0;
 
 	/*
@@ -2041,7 +2063,7 @@ void sev_vm_destroy(struct kvm *kvm)
 	struct list_head *head = &sev->regions_list;
 	struct list_head *pos, *q;
 
-	WARN_ON(sev->num_mirrored_vms);
+	WARN_ON(!list_empty(&sev->mirror_vms));
 
 	if (!sev_guest(kvm))
 		return;
@@ -2049,11 +2071,9 @@ void sev_vm_destroy(struct kvm *kvm)
 	/* If this is a mirror_kvm release the enc_context_owner and skip sev cleanup */
 	if (is_mirroring_enc_context(kvm)) {
 		struct kvm *owner_kvm = sev->enc_context_owner;
-		struct kvm_sev_info *owner_sev = &to_kvm_svm(owner_kvm)->sev_info;
 
 		mutex_lock(&owner_kvm->lock);
-		if (!WARN_ON(!owner_sev->num_mirrored_vms))
-			owner_sev->num_mirrored_vms--;
+		list_del(&sev->mirror_entry);
 		mutex_unlock(&owner_kvm->lock);
 		kvm_put_kvm(owner_kvm);
 		return;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 15920d2de2cc..e8db88e9825e 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -79,7 +79,8 @@ struct kvm_sev_info {
 	struct list_head regions_list;  /* List of registered regions */
 	u64 ap_jump_table;	/* SEV-ES AP Jump Table address */
 	struct kvm *enc_context_owner; /* Owner of copied encryption context */
-	unsigned long num_mirrored_vms; /* Number of VMs sharing this ASID */
+	struct list_head mirror_vms; /* List of VMs mirroring */
+	struct list_head mirror_entry; /* Use as a list entry of mirrors */
 	struct misc_cg *misc_cg; /* For misc cgroup accounting */
 	atomic_t migration_in_progress;
 };
diff --git a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
index 80056bbbb003..2e5a42cb470b 100644
--- a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
+++ b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
@@ -341,35 +341,54 @@ static void test_sev_mirror_parameters(void)
 
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
 }
-- 
2.35.1.265.g69c8d7142f-goog
