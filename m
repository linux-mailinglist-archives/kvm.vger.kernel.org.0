Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15BDE454B23
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 17:38:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239181AbhKQQlV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 11:41:21 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39451 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239110AbhKQQlQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Nov 2021 11:41:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637167096;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jd3NpCL7UsvXt7gboF4Fdo/6dE8LgX9djgu7Kgt2UjM=;
        b=BJ1fdn4g9XY97arBZEL/J9hy2Voe4Bepc5xNQfWssFxFHTzNxCeAyk1W8bWOGWPdARKAkH
        rlbiii2bMqRRyL5hVhU0nMfqUiXOlFmOE+fMSoFALQt8Mbbt+l4YDdlgJ/6AmBjCsfcQ72
        bnUcm2Lbvd2tcoTmEV02thG7t+oM/Fg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-256-IgV-ZvV_NnK9pgwdPoJ_kg-1; Wed, 17 Nov 2021 11:38:13 -0500
X-MC-Unique: IgV-ZvV_NnK9pgwdPoJ_kg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3A1281006AA9;
        Wed, 17 Nov 2021 16:38:12 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C3F0418A50;
        Wed, 17 Nov 2021 16:38:11 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pgonda@google.com, seanjc@google.com
Subject: [PATCH 3/4] KVM: SEV: cleanup locking for KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM
Date:   Wed, 17 Nov 2021 11:38:08 -0500
Message-Id: <20211117163809.1441845-4-pbonzini@redhat.com>
In-Reply-To: <20211117163809.1441845-1-pbonzini@redhat.com>
References: <20211117163809.1441845-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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
index 21ac0a5de4e0..f9256ba269e6 100644
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
 
 
@@ -1666,15 +1675,6 @@ int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
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
@@ -1682,13 +1682,13 @@ int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
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
@@ -1728,13 +1728,11 @@ int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
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


