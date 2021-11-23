Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71669459956
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 01:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232824AbhKWAx7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 19:53:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:21423 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231868AbhKWAxt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Nov 2021 19:53:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637628641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8cV6ZMwdlOkcuV7/J9Zb/5KWuRIKTymicEAEEDOodn0=;
        b=im4GSYveMOq6RjW0FtG1hFTWWWOVRF/vysX3LznHNUcc7ZGpjEKeTm3p5maHdmJgK0A9jH
        RjKdLYRb3VHdKs2SCuxjhZ5sSIF10rfOfBBbiMpsqNn/5Mw3HYez2NeIMdhdqxtcVFdbfr
        +6Ykr3VK+cKsimluqixMbq/NoYmpOZI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-361-i84tZXa3Ma-j75hWoU6yMg-1; Mon, 22 Nov 2021 19:50:40 -0500
X-MC-Unique: i84tZXa3Ma-j75hWoU6yMg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E1FE81DDE1;
        Tue, 23 Nov 2021 00:50:38 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 84CD05C1C5;
        Tue, 23 Nov 2021 00:50:38 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pgonda@google.com, Sean Christopherson <seanjc@google.com>
Subject: [PATCH 05/12] KVM: SEV: cleanup locking for KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM
Date:   Mon, 22 Nov 2021 19:50:29 -0500
Message-Id: <20211123005036.2954379-6-pbonzini@redhat.com>
In-Reply-To: <20211123005036.2954379-1-pbonzini@redhat.com>
References: <20211123005036.2954379-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Encapsulate the handling of the migration_in_progress flag for both VMs in
two functions sev_lock_two_vms and sev_unlock_two_vms.  It does not matter
if KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM locks the source struct kvm a bit
earlier, and this change 1) keeps the cleanup chain of labels smaller 2)
makes it possible for KVM_CAP_VM_COPY_ENC_CONTEXT_FROM to reuse the logic.

Cc: Peter Gonda <pgonda@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/sev.c | 50 ++++++++++++++++++++----------------------
 1 file changed, 24 insertions(+), 26 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 75955beb3770..23a4877d7bdf 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1543,28 +1543,37 @@ static bool is_cmd_allowed_from_mirror(u32 cmd_id)
 	return false;
 }
 
-static int sev_lock_for_migration(struct kvm *kvm)
+static int sev_lock_two_vms(struct kvm *dst_kvm, struct kvm *src_kvm)
 {
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct kvm_sev_info *dst_sev = &to_kvm_svm(dst_kvm)->sev_info;
+	struct kvm_sev_info *src_sev = &to_kvm_svm(src_kvm)->sev_info;
 
 	/*
-	 * Bail if this VM is already involved in a migration to avoid deadlock
-	 * between two VMs trying to migrate to/from each other.
+	 * Bail if these VMs are already involved in a migration to avoid
+	 * deadlock between two VMs trying to migrate to/from each other.
 	 */
-	if (atomic_cmpxchg_acquire(&sev->migration_in_progress, 0, 1))
+	if (atomic_cmpxchg_acquire(&dst_sev->migration_in_progress, 0, 1))
 		return -EBUSY;
 
-	mutex_lock(&kvm->lock);
+	if (atomic_cmpxchg_acquire(&src_sev->migration_in_progress, 0, 1)) {
+		atomic_set_release(&dst_sev->migration_in_progress, 0);
+		return -EBUSY;
+	}
 
+	mutex_lock(&dst_kvm->lock);
+	mutex_lock(&src_kvm->lock);
 	return 0;
 }
 
-static void sev_unlock_after_migration(struct kvm *kvm)
+static void sev_unlock_two_vms(struct kvm *dst_kvm, struct kvm *src_kvm)
 {
-	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
+	struct kvm_sev_info *dst_sev = &to_kvm_svm(dst_kvm)->sev_info;
+	struct kvm_sev_info *src_sev = &to_kvm_svm(src_kvm)->sev_info;
 
-	mutex_unlock(&kvm->lock);
-	atomic_set_release(&sev->migration_in_progress, 0);
+	mutex_unlock(&dst_kvm->lock);
+	mutex_unlock(&src_kvm->lock);
+	atomic_set_release(&dst_sev->migration_in_progress, 0);
+	atomic_set_release(&src_sev->migration_in_progress, 0);
 }
 
 
@@ -1665,15 +1674,6 @@ int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
 	bool charged = false;
 	int ret;
 
-	ret = sev_lock_for_migration(kvm);
-	if (ret)
-		return ret;
-
-	if (sev_guest(kvm)) {
-		ret = -EINVAL;
-		goto out_unlock;
-	}
-
 	source_kvm_file = fget(source_fd);
 	if (!file_is_kvm(source_kvm_file)) {
 		ret = -EBADF;
@@ -1681,13 +1681,13 @@ int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
 	}
 
 	source_kvm = source_kvm_file->private_data;
-	ret = sev_lock_for_migration(source_kvm);
+	ret = sev_lock_two_vms(kvm, source_kvm);
 	if (ret)
 		goto out_fput;
 
-	if (!sev_guest(source_kvm)) {
+	if (sev_guest(kvm) || !sev_guest(source_kvm)) {
 		ret = -EINVAL;
-		goto out_source;
+		goto out_unlock;
 	}
 
 	src_sev = &to_kvm_svm(source_kvm)->sev_info;
@@ -1727,13 +1727,11 @@ int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
 		sev_misc_cg_uncharge(cg_cleanup_sev);
 	put_misc_cg(cg_cleanup_sev->misc_cg);
 	cg_cleanup_sev->misc_cg = NULL;
-out_source:
-	sev_unlock_after_migration(source_kvm);
+out_unlock:
+	sev_unlock_two_vms(kvm, source_kvm);
 out_fput:
 	if (source_kvm_file)
 		fput(source_kvm_file);
-out_unlock:
-	sev_unlock_after_migration(kvm);
 	return ret;
 }
 
-- 
2.27.0


