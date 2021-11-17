Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF46454B1E
	for <lists+kvm@lfdr.de>; Wed, 17 Nov 2021 17:38:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239073AbhKQQlP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Nov 2021 11:41:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:44985 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235388AbhKQQlO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 17 Nov 2021 11:41:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637167095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4dH3cPS/yoiWi5drVaWJXM5kdVu5sv4EBn9jLGlBRRE=;
        b=M/zFnhhfGbAj7JsdbGzSS5cXr9nUOIpApR6cIYuZepAzrUsbVoYOwqsIeDiAe0A3AmR5as
        fZuqeYYbWlYKbY6sJyBG4oGxlEOUN8ejUpRtSESZR4GWohsO0uoQQaHbvFLmIKJkL7pqMb
        0AB5zrRlURTZuNQ8xFvQSI12NJshplY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-337-eW84R2ukN2qeqRbZ6V1GgQ-1; Wed, 17 Nov 2021 11:38:13 -0500
X-MC-Unique: eW84R2ukN2qeqRbZ6V1GgQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B179D18125C0;
        Wed, 17 Nov 2021 16:38:12 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 54358604CC;
        Wed, 17 Nov 2021 16:38:12 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pgonda@google.com, seanjc@google.com
Subject: [PATCH 4/4] KVM: SEV: Do COPY_ENC_CONTEXT_FROM with both VMs locked
Date:   Wed, 17 Nov 2021 11:38:09 -0500
Message-Id: <20211117163809.1441845-5-pbonzini@redhat.com>
In-Reply-To: <20211117163809.1441845-1-pbonzini@redhat.com>
References: <20211117163809.1441845-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that we have a facility to lock two VMs with deadlock
protection, use it for the creation of mirror VMs as well.  One of
COPY_ENC_CONTEXT_FROM(dst, src) and COPY_ENC_CONTEXT_FROM(src, dst)
would always fail, so the combination is nonsensical and it is okay to
return -EBUSY if it is attempted.

This sidesteps the question of what happens if a VM is
MOVE_ENC_CONTEXT_FROM'd at the same time as it is
COPY_ENC_CONTEXT_FROM'd: the locking prevents that from
happening.

Cc: Peter Gonda <pgonda@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/sev.c | 68 ++++++++++++++++--------------------------
 1 file changed, 26 insertions(+), 42 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f9256ba269e6..47d54df7675c 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1548,6 +1548,9 @@ static int sev_lock_two_vms(struct kvm *dst_kvm, struct kvm *src_kvm)
 	struct kvm_sev_info *dst_sev = &to_kvm_svm(dst_kvm)->sev_info;
 	struct kvm_sev_info *src_sev = &to_kvm_svm(src_kvm)->sev_info;
 
+	if (dst_kvm == src_kvm)
+		return -EINVAL;
+
 	/*
 	 * Bail if these VMs are already involved in a migration to avoid
 	 * deadlock between two VMs trying to migrate to/from each other.
@@ -1951,76 +1954,57 @@ int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd)
 {
 	struct file *source_kvm_file;
 	struct kvm *source_kvm;
-	struct kvm_sev_info source_sev, *mirror_sev;
+	struct kvm_sev_info *source_sev, *mirror_sev;
 	int ret;
 
 	source_kvm_file = fget(source_fd);
 	if (!file_is_kvm(source_kvm_file)) {
 		ret = -EBADF;
-		goto e_source_put;
+		goto e_source_fput;
 	}
 
 	source_kvm = source_kvm_file->private_data;
-	mutex_lock(&source_kvm->lock);
-
-	if (!sev_guest(source_kvm)) {
-		ret = -EINVAL;
-		goto e_source_unlock;
-	}
+	ret = sev_lock_two_vms(kvm, source_kvm);
+	if (ret)
+		goto e_source_fput;
 
-	/* Mirrors of mirrors should work, but let's not get silly */
-	if (is_mirroring_enc_context(source_kvm) || source_kvm == kvm) {
+	/*
+	 * Mirrors of mirrors should work, but let's not get silly.  Also
+	 * disallow out-of-band SEV/SEV-ES init if the target is already an
+	 * SEV guest, or if vCPUs have been created.  KVM relies on vCPUs being
+	 * created after SEV/SEV-ES initialization, e.g. to init intercepts.
+	 */
+	if (sev_guest(kvm) || !sev_guest(source_kvm) ||
+	    is_mirroring_enc_context(source_kvm) || kvm->created_vcpus) {
 		ret = -EINVAL;
-		goto e_source_unlock;
+		goto e_unlock;
 	}
 
-	memcpy(&source_sev, &to_kvm_svm(source_kvm)->sev_info,
-	       sizeof(source_sev));
-
 	/*
 	 * The mirror kvm holds an enc_context_owner ref so its asid can't
 	 * disappear until we're done with it
 	 */
+	source_sev = &to_kvm_svm(source_kvm)->sev_info;
 	kvm_get_kvm(source_kvm);
 
-	fput(source_kvm_file);
-	mutex_unlock(&source_kvm->lock);
-	mutex_lock(&kvm->lock);
-
-	/*
-	 * Disallow out-of-band SEV/SEV-ES init if the target is already an
-	 * SEV guest, or if vCPUs have been created.  KVM relies on vCPUs being
-	 * created after SEV/SEV-ES initialization, e.g. to init intercepts.
-	 */
-	if (sev_guest(kvm) || kvm->created_vcpus) {
-		ret = -EINVAL;
-		goto e_mirror_unlock;
-	}
-
 	/* Set enc_context_owner and copy its encryption context over */
 	mirror_sev = &to_kvm_svm(kvm)->sev_info;
 	mirror_sev->enc_context_owner = source_kvm;
 	mirror_sev->active = true;
-	mirror_sev->asid = source_sev.asid;
-	mirror_sev->fd = source_sev.fd;
-	mirror_sev->es_active = source_sev.es_active;
-	mirror_sev->handle = source_sev.handle;
+	mirror_sev->asid = source_sev->asid;
+	mirror_sev->fd = source_sev->fd;
+	mirror_sev->es_active = source_sev->es_active;
+	mirror_sev->handle = source_sev->handle;
+	ret = 0;
 	/*
 	 * Do not copy ap_jump_table. Since the mirror does not share the same
 	 * KVM contexts as the original, and they may have different
 	 * memory-views.
 	 */
 
-	mutex_unlock(&kvm->lock);
-	return 0;
-
-e_mirror_unlock:
-	mutex_unlock(&kvm->lock);
-	kvm_put_kvm(source_kvm);
-	return ret;
-e_source_unlock:
-	mutex_unlock(&source_kvm->lock);
-e_source_put:
+e_unlock:
+	sev_unlock_two_vms(kvm, source_kvm);
+e_source_fput:
 	if (source_kvm_file)
 		fput(source_kvm_file);
 	return ret;
-- 
2.27.0

