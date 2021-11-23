Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8DE045996A
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 01:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231572AbhKWAym (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 19:54:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:35722 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233071AbhKWAyX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Nov 2021 19:54:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637628676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oOn0fYV16hnZrv2lsOAPlaO5UTPcRV+iWSX7d4CLJxg=;
        b=GotRGS+SZYGTQ0t5BRU/lpEuh/3vxVOkqRJAT031G4ljX8wKU04A22E/HLhWrYm/Qpb5/T
        3WTTgiTag/g0/u5yTbzF+qQL330DIy0CQ/tImGLTSBCPA/aClTkfHjII/qh4xWdPHee3qM
        OuKv0MWkdIkPBb8QPRpH7GuKx2lSd2k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-217-Bl_iQ0CeNfeAXZiQOz7LZQ-1; Mon, 22 Nov 2021 19:50:42 -0500
X-MC-Unique: Bl_iQ0CeNfeAXZiQOz7LZQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C0B8018125C1;
        Tue, 23 Nov 2021 00:50:41 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 617D360C13;
        Tue, 23 Nov 2021 00:50:41 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pgonda@google.com
Subject: [PATCH 10/12] KVM: SEV: Prohibit migration of a VM that has mirrors
Date:   Mon, 22 Nov 2021 19:50:34 -0500
Message-Id: <20211123005036.2954379-11-pbonzini@redhat.com>
In-Reply-To: <20211123005036.2954379-1-pbonzini@redhat.com>
References: <20211123005036.2954379-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

VMs that mirror an encryption context rely on the owner to keep the
ASID allocated.  Performing a KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM
would cause a dangling ASID:

1. copy context from A to B (gets ref to A)
2. move context from A to L (moves ASID from A to L)
3. close L (releases ASID from L, B still references it)

The right way to do the handoff instead is to create a fresh mirror VM
on the destination first:

1. copy context from A to B (gets ref to A)
[later] 2. close B (releases ref to A)
3. move context from A to L (moves ASID from A to L)
4. copy context from L to M

So, catch the situation by adding a count of how many VMs are
mirroring this one's encryption context.

Fixes: 0b020f5af092 ("KVM: SEV: Add support for SEV-ES intra host migration")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/sev.c                        | 22 ++++++++++-
 arch/x86/kvm/svm/svm.h                        |  1 +
 .../selftests/kvm/x86_64/sev_migrate_tests.c  | 37 +++++++++++++++++++
 3 files changed, 59 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 025d9731b66c..89a716290fac 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1696,6 +1696,16 @@ int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
 	}
 
 	src_sev = &to_kvm_svm(source_kvm)->sev_info;
+
+	/*
+	 * VMs mirroring src's encryption context rely on it to keep the
+	 * ASID allocated, but below we are clearing src_sev->asid.
+	 */
+	if (src_sev->num_mirrored_vms) {
+		ret = -EBUSY;
+		goto out_unlock;
+	}
+
 	dst_sev->misc_cg = get_current_misc_cg();
 	cg_cleanup_sev = dst_sev;
 	if (dst_sev->misc_cg != src_sev->misc_cg) {
@@ -1987,6 +1997,7 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
 	 */
 	source_sev = &to_kvm_svm(source_kvm)->sev_info;
 	kvm_get_kvm(source_kvm);
+	source_sev->num_mirrored_vms++;
 
 	/* Set enc_context_owner and copy its encryption context over */
 	mirror_sev = &to_kvm_svm(kvm)->sev_info;
@@ -2019,12 +2030,21 @@ void sev_vm_destroy(struct kvm *kvm)
 	struct list_head *head = &sev->regions_list;
 	struct list_head *pos, *q;
 
+	WARN_ON(sev->num_mirrored_vms);
+
 	if (!sev_guest(kvm))
 		return;
 
 	/* If this is a mirror_kvm release the enc_context_owner and skip sev cleanup */
 	if (is_mirroring_enc_context(kvm)) {
-		kvm_put_kvm(sev->enc_context_owner);
+		struct kvm *owner_kvm = sev->enc_context_owner;
+		struct kvm_sev_info *owner_sev = &to_kvm_svm(owner_kvm)->sev_info;
+
+		mutex_lock(&owner_kvm->lock);
+		if (!WARN_ON(!owner_sev->num_mirrored_vms))
+			owner_sev->num_mirrored_vms--;
+		mutex_unlock(&owner_kvm->lock);
+		kvm_put_kvm(owner_kvm);
 		return;
 	}
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 5faad3dc10e2..1c7306c370fa 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -79,6 +79,7 @@ struct kvm_sev_info {
 	struct list_head regions_list;  /* List of registered regions */
 	u64 ap_jump_table;	/* SEV-ES AP Jump Table address */
 	struct kvm *enc_context_owner; /* Owner of copied encryption context */
+	unsigned long num_mirrored_vms; /* Number of VMs sharing this ASID */
 	struct misc_cg *misc_cg; /* For misc cgroup accounting */
 	atomic_t migration_in_progress;
 };
diff --git a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
index d265cea5de85..29b18d565cf4 100644
--- a/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
+++ b/tools/testing/selftests/kvm/x86_64/sev_migrate_tests.c
@@ -294,6 +294,41 @@ static void test_sev_mirror_parameters(void)
 	kvm_vm_free(vm_no_vcpu);
 }
 
+static void test_sev_move_copy(void)
+{
+	struct kvm_vm *dst_vm, *sev_vm, *mirror_vm, *dst_mirror_vm;
+	int ret;
+
+	sev_vm = sev_vm_create(/* es= */ false);
+	dst_vm = aux_vm_create(true);
+	mirror_vm = aux_vm_create(false);
+	dst_mirror_vm = aux_vm_create(false);
+
+	sev_mirror_create(mirror_vm->fd, sev_vm->fd);
+	ret = __sev_migrate_from(dst_vm->fd, sev_vm->fd);
+	TEST_ASSERT(ret == -1 && errno == EBUSY,
+		    "Cannot migrate VM that has mirrors. ret %d, errno: %d\n", ret,
+		    errno);
+
+	/* The mirror itself can be migrated.  */
+	sev_migrate_from(dst_mirror_vm->fd, mirror_vm->fd);
+	ret = __sev_migrate_from(dst_vm->fd, sev_vm->fd);
+	TEST_ASSERT(ret == -1 && errno == EBUSY,
+		    "Cannot migrate VM that has mirrors. ret %d, errno: %d\n", ret,
+		    errno);
+
+	/*
+	 * mirror_vm is not a mirror anymore, dst_mirror_vm is.  Thus,
+	 * the owner can be copied as soon as dst_mirror_vm is gone.
+	 */
+	kvm_vm_free(dst_mirror_vm);
+	sev_migrate_from(dst_vm->fd, sev_vm->fd);
+
+	kvm_vm_free(mirror_vm);
+	kvm_vm_free(dst_vm);
+	kvm_vm_free(sev_vm);
+}
+
 int main(int argc, char *argv[])
 {
 	if (kvm_check_cap(KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM)) {
@@ -301,6 +336,8 @@ int main(int argc, char *argv[])
 		test_sev_migrate_from(/* es= */ true);
 		test_sev_migrate_locking();
 		test_sev_migrate_parameters();
+		if (kvm_check_cap(KVM_CAP_VM_COPY_ENC_CONTEXT_FROM))
+			test_sev_move_copy();
 	}
 	if (kvm_check_cap(KVM_CAP_VM_COPY_ENC_CONTEXT_FROM)) {
 		test_sev_mirror(/* es= */ false);
-- 
2.27.0


