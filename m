Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C50AB5F4D24
	for <lists+kvm@lfdr.de>; Wed,  5 Oct 2022 02:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbiJEAoF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 20:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiJEAoA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 20:44:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50EC55F9B0
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 17:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664930637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QwBaOLJJCT/9xbJEvotrX8w1rBdSF+2LsI3ctC6olUg=;
        b=eO+zQttgBJnfNaN3TQeh6Chcf6RtRoMIqkicTIvKdwau8NtRb7R1LvAoUKMrlugP1cy8wv
        UEEW8l4l0JFVt7lDY7Ql/0lO2qxs8Z4lOxxEI/o4N0pfdiAPNxfce7PVJxgE/gGGyozLZL
        4kc59acCyJQDDJnG9X7qglsSU7JSuFk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-410-begs_CPHOx6d5sQzf1EA3A-1; Tue, 04 Oct 2022 20:43:53 -0400
X-MC-Unique: begs_CPHOx6d5sQzf1EA3A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 91920185A7AA;
        Wed,  5 Oct 2022 00:43:52 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-56.bne.redhat.com [10.64.54.56])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3C11A39DB3;
        Wed,  5 Oct 2022 00:43:37 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvmarm@lists.linux.dev
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        peterx@redhat.com, catalin.marinas@arm.com, bgardon@google.com,
        shuah@kernel.org, andrew.jones@linux.dev, will@kernel.org,
        dmatlack@google.com, pbonzini@redhat.com, zhenyzha@redhat.com,
        james.morse@arm.com, suzuki.poulose@arm.com,
        alexandru.elisei@arm.com, oliver.upton@linux.dev,
        seanjc@google.com, shan.gavin@gmail.com
Subject: [PATCH v5 3/7] KVM: x86: Allow to use bitmap in ring-based dirty page tracking
Date:   Wed,  5 Oct 2022 08:41:50 +0800
Message-Id: <20221005004154.83502-4-gshan@redhat.com>
In-Reply-To: <20221005004154.83502-1-gshan@redhat.com>
References: <20221005004154.83502-1-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is no running vcpu and available per-vcpu dirty ring when
pages become dirty in some cases. One example is to save arm64's
vgic/its tables during migration. This leads to our lost tracking
on these dirty pages.

Fix the issue by reusing the bitmap to track those dirty pages.
The bitmap is visited by KVM_GET_DIRTY_LOG and KVM_CLEAR_DIRTY_LOG
ioctls. KVM_CAP_DIRTY_LOG_RING_ALLOW_BITMAP is used to advertise the
new capability.

Suggested-by: Marc Zyngier <maz@kernel.org>
Suggested-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 Documentation/virt/kvm/api.rst | 17 ++++++++---------
 include/uapi/linux/kvm.h       |  1 +
 virt/kvm/kvm_main.c            | 24 +++++++++---------------
 3 files changed, 18 insertions(+), 24 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 32427ea160df..4f5e09042f8a 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8019,8 +8019,8 @@ guest according to the bits in the KVM_CPUID_FEATURES CPUID leaf
 (0x40000001). Otherwise, a guest may use the paravirtual features
 regardless of what has actually been exposed through the CPUID leaf.
 
-8.29 KVM_CAP_DIRTY_LOG_RING/KVM_CAP_DIRTY_LOG_RING_ACQ_REL
-----------------------------------------------------------
+8.29 KVM_CAP_DIRTY_LOG_{RING, RING_ACQ_REL, RING_ALLOW_BITMAP}
+--------------------------------------------------------------
 
 :Architectures: x86
 :Parameters: args[0] - size of the dirty log ring
@@ -8104,13 +8104,6 @@ flushing is done by the KVM_GET_DIRTY_LOG ioctl).  To achieve that, one
 needs to kick the vcpu out of KVM_RUN using a signal.  The resulting
 vmexit ensures that all dirty GFNs are flushed to the dirty rings.
 
-NOTE: the capability KVM_CAP_DIRTY_LOG_RING and the corresponding
-ioctl KVM_RESET_DIRTY_RINGS are mutual exclusive to the existing ioctls
-KVM_GET_DIRTY_LOG and KVM_CLEAR_DIRTY_LOG.  After enabling
-KVM_CAP_DIRTY_LOG_RING with an acceptable dirty ring size, the virtual
-machine will switch to ring-buffer dirty page tracking and further
-KVM_GET_DIRTY_LOG or KVM_CLEAR_DIRTY_LOG ioctls will fail.
-
 NOTE: KVM_CAP_DIRTY_LOG_RING_ACQ_REL is the only capability that
 should be exposed by weakly ordered architecture, in order to indicate
 the additional memory ordering requirements imposed on userspace when
@@ -8119,6 +8112,12 @@ Architecture with TSO-like ordering (such as x86) are allowed to
 expose both KVM_CAP_DIRTY_LOG_RING and KVM_CAP_DIRTY_LOG_RING_ACQ_REL
 to userspace.
 
+NOTE: There is no running vcpu and available vcpu dirty ring when pages
+becomes dirty in some cases. One example is to save arm64's vgic/its
+tables during migration. The dirty bitmap is still used to track those
+dirty pages, indicated by KVM_CAP_DIRTY_LOG_RING_ALLOW_BITMAP. The ditry
+bitmap is visited by KVM_GET_DIRTY_LOG and KVM_CLEAR_DIRTY_LOG ioctls.
+
 8.30 KVM_CAP_XEN_HVM
 --------------------
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 0d5d4419139a..a1f10bc5fe8b 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1178,6 +1178,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_S390_ZPCI_OP 221
 #define KVM_CAP_S390_CPU_TOPOLOGY 222
 #define KVM_CAP_DIRTY_LOG_RING_ACQ_REL 223
+#define KVM_CAP_DIRTY_LOG_RING_ALLOW_BITMAP 224
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 5b064dbadaf4..505e3840cf0c 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1617,7 +1617,7 @@ static int kvm_prepare_memory_region(struct kvm *kvm,
 			new->dirty_bitmap = NULL;
 		else if (old && old->dirty_bitmap)
 			new->dirty_bitmap = old->dirty_bitmap;
-		else if (!kvm->dirty_ring_size) {
+		else {
 			r = kvm_alloc_dirty_bitmap(new);
 			if (r)
 				return r;
@@ -2060,10 +2060,6 @@ int kvm_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log,
 	unsigned long n;
 	unsigned long any = 0;
 
-	/* Dirty ring tracking is exclusive to dirty log tracking */
-	if (kvm->dirty_ring_size)
-		return -ENXIO;
-
 	*memslot = NULL;
 	*is_dirty = 0;
 
@@ -2125,10 +2121,6 @@ static int kvm_get_dirty_log_protect(struct kvm *kvm, struct kvm_dirty_log *log)
 	unsigned long *dirty_bitmap_buffer;
 	bool flush;
 
-	/* Dirty ring tracking is exclusive to dirty log tracking */
-	if (kvm->dirty_ring_size)
-		return -ENXIO;
-
 	as_id = log->slot >> 16;
 	id = (u16)log->slot;
 	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_USER_MEM_SLOTS)
@@ -2237,10 +2229,6 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
 	unsigned long *dirty_bitmap_buffer;
 	bool flush;
 
-	/* Dirty ring tracking is exclusive to dirty log tracking */
-	if (kvm->dirty_ring_size)
-		return -ENXIO;
-
 	as_id = log->slot >> 16;
 	id = (u16)log->slot;
 	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_USER_MEM_SLOTS)
@@ -3305,7 +3293,7 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
 	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 
 #ifdef CONFIG_HAVE_KVM_DIRTY_RING
-	if (WARN_ON_ONCE(!vcpu) || WARN_ON_ONCE(vcpu->kvm != kvm))
+	if (WARN_ON_ONCE(vcpu && vcpu->kvm != kvm))
 		return;
 #endif
 
@@ -3313,7 +3301,7 @@ void mark_page_dirty_in_slot(struct kvm *kvm,
 		unsigned long rel_gfn = gfn - memslot->base_gfn;
 		u32 slot = (memslot->as_id << 16) | memslot->id;
 
-		if (kvm->dirty_ring_size)
+		if (kvm->dirty_ring_size && vcpu)
 			kvm_dirty_ring_push(&vcpu->dirty_ring,
 					    slot, rel_gfn);
 		else
@@ -4485,6 +4473,12 @@ static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 		return KVM_DIRTY_RING_MAX_ENTRIES * sizeof(struct kvm_dirty_gfn);
 #else
 		return 0;
+#endif
+	case KVM_CAP_DIRTY_LOG_RING_ALLOW_BITMAP:
+#ifdef CONFIG_HAVE_KVM_DIRTY_RING
+		return 1;
+#else
+		return 0;
 #endif
 	case KVM_CAP_BINARY_STATS_FD:
 	case KVM_CAP_SYSTEM_EVENT_DATA:
-- 
2.23.0

