Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64E353062DC
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 19:00:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344372AbhA0R70 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 12:59:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50718 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344345AbhA0R7K (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Jan 2021 12:59:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611770262;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bFzc083SDCVVQmZ3TEE32kOyxiqZz+UgdILDBdrPWO0=;
        b=LXeKf1+vv3y6rkApVVEYY5uUeYq1H8APwKq6v7X1OmIQG+H08PdmrcMWPEAWT8NAClAw3k
        fJC9i5TNm0Rha+1pGvWoOJUnqAIQT29q7/Mdg4LxeAWfhBCb7qttW1TGZ/PZanjGxRNR8W
        XIschmE7GqS/Xs/VQr6EE4JnHOM5faI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-345-_Z2AUTP_M0O_vX18-8mUUQ-1; Wed, 27 Jan 2021 12:57:41 -0500
X-MC-Unique: _Z2AUTP_M0O_vX18-8mUUQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AB5AD8066EA;
        Wed, 27 Jan 2021 17:57:39 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8DEB460864;
        Wed, 27 Jan 2021 17:57:37 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Subject: [PATCH 1/5] KVM: Make the maximum number of user memslots a per-VM thing
Date:   Wed, 27 Jan 2021 18:57:27 +0100
Message-Id: <20210127175731.2020089-2-vkuznets@redhat.com>
In-Reply-To: <20210127175731.2020089-1-vkuznets@redhat.com>
References: <20210127175731.2020089-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Limiting the maximum number of user memslots globally can be undesirable as
different VMs may have different needs. Generally, a relatively small
number should suffice and a VMM may want to enforce the limitation so a VM
won't accidentally eat too much memory. On the other hand, the number of
required memslots can depend on the number of assigned vCPUs, e.g. each
Hyper-V SynIC may require up to two additional slots per vCPU.

Prepare to limit the maximum number of user memslots per-VM. No real
functional change in this patch as the limit is still hard-coded to
KVM_USER_MEM_SLOTS.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/powerpc/kvm/book3s_hv.c |  2 +-
 arch/s390/kvm/kvm-s390.c     |  2 +-
 include/linux/kvm_host.h     |  1 +
 virt/kvm/dirty_ring.c        |  2 +-
 virt/kvm/kvm_main.c          | 11 ++++++-----
 5 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 6f612d240392..bea2f34e3662 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -4472,7 +4472,7 @@ static int kvm_vm_ioctl_get_dirty_log_hv(struct kvm *kvm,
 	mutex_lock(&kvm->slots_lock);
 
 	r = -EINVAL;
-	if (log->slot >= KVM_USER_MEM_SLOTS)
+	if (log->slot >= kvm->memslots_max)
 		goto out;
 
 	slots = kvm_memslots(kvm);
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index dbafd057ca6a..b8c49105f40c 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -640,7 +640,7 @@ int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
 	mutex_lock(&kvm->slots_lock);
 
 	r = -EINVAL;
-	if (log->slot >= KVM_USER_MEM_SLOTS)
+	if (log->slot >= kvm->memslots_max)
 		goto out;
 
 	r = kvm_get_dirty_log(kvm, log, &is_dirty, &memslot);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f3b1013fb22c..0033ccffe617 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -513,6 +513,7 @@ struct kvm {
 	pid_t userspace_pid;
 	unsigned int max_halt_poll_ns;
 	u32 dirty_ring_size;
+	short int memslots_max;
 };
 
 #define kvm_err(fmt, ...) \
diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
index 9d01299563ee..40d0a749a55d 100644
--- a/virt/kvm/dirty_ring.c
+++ b/virt/kvm/dirty_ring.c
@@ -52,7 +52,7 @@ static void kvm_reset_dirty_gfn(struct kvm *kvm, u32 slot, u64 offset, u64 mask)
 	as_id = slot >> 16;
 	id = (u16)slot;
 
-	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_USER_MEM_SLOTS)
+	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= kvm->memslots_max)
 		return;
 
 	memslot = id_to_memslot(__kvm_memslots(kvm, as_id), id);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8367d88ce39b..a78e982e7107 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -755,6 +755,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
 	INIT_LIST_HEAD(&kvm->devices);
 
 	BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);
+	kvm->memslots_max = KVM_USER_MEM_SLOTS;
 
 	if (init_srcu_struct(&kvm->srcu))
 		goto out_err_no_srcu;
@@ -1404,7 +1405,7 @@ EXPORT_SYMBOL_GPL(kvm_set_memory_region);
 static int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
 					  struct kvm_userspace_memory_region *mem)
 {
-	if ((u16)mem->slot >= KVM_USER_MEM_SLOTS)
+	if ((u16)mem->slot >= kvm->memslots_max)
 		return -EINVAL;
 
 	return kvm_set_memory_region(kvm, mem);
@@ -1435,7 +1436,7 @@ int kvm_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log,
 
 	as_id = log->slot >> 16;
 	id = (u16)log->slot;
-	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_USER_MEM_SLOTS)
+	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= kvm->memslots_max)
 		return -EINVAL;
 
 	slots = __kvm_memslots(kvm, as_id);
@@ -1497,7 +1498,7 @@ static int kvm_get_dirty_log_protect(struct kvm *kvm, struct kvm_dirty_log *log)
 
 	as_id = log->slot >> 16;
 	id = (u16)log->slot;
-	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_USER_MEM_SLOTS)
+	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= kvm->memslots_max)
 		return -EINVAL;
 
 	slots = __kvm_memslots(kvm, as_id);
@@ -1609,7 +1610,7 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
 
 	as_id = log->slot >> 16;
 	id = (u16)log->slot;
-	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_USER_MEM_SLOTS)
+	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= kvm->memslots_max)
 		return -EINVAL;
 
 	if (log->first_page & 63)
@@ -3682,7 +3683,7 @@ static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 		return KVM_ADDRESS_SPACE_NUM;
 #endif
 	case KVM_CAP_NR_MEMSLOTS:
-		return KVM_USER_MEM_SLOTS;
+		return kvm ? kvm->memslots_max : KVM_USER_MEM_SLOTS;
 	case KVM_CAP_DIRTY_LOG_RING:
 #if KVM_DIRTY_LOG_PAGE_OFFSET > 0
 		return KVM_DIRTY_RING_MAX_ENTRIES * sizeof(struct kvm_dirty_gfn);
-- 
2.29.2

