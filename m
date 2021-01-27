Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE913062DD
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 19:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344376AbhA0R7b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 12:59:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54002 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344366AbhA0R7T (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 Jan 2021 12:59:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611770272;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1XOu+dEnl7Iy4FBd4URUgzw1f2EtHwRM8d4SBoHgF3s=;
        b=T9Yn/c6BhdVN3d9RMEAE6gqpziNgnfLISQF6zr6hE45afiMbLvfwZowJY653d9InOzyrvI
        YQhFBnmHWXm1XAFArP1+2Bb+DDOIrQCc0lIh7KniwNs3BzErfc7l9FWHnF3gX6PPKyPtuX
        KfdzY3fkbkYG2UKDO5EosdxUydywvWc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-489-LhCyXgkYNr6WWn5IQHT1lg-1; Wed, 27 Jan 2021 12:57:50 -0500
X-MC-Unique: LhCyXgkYNr6WWn5IQHT1lg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A757C180E48B;
        Wed, 27 Jan 2021 17:57:48 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B740B707B6;
        Wed, 27 Jan 2021 17:57:42 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
Subject: [PATCH 3/5] KVM: Make the maximum number of user memslots configurable
Date:   Wed, 27 Jan 2021 18:57:29 +0100
Message-Id: <20210127175731.2020089-4-vkuznets@redhat.com>
In-Reply-To: <20210127175731.2020089-1-vkuznets@redhat.com>
References: <20210127175731.2020089-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The maximum number of user memslots is now a per-VM setting but there is
no way to change it. Intoduce KVM_CAP_MEMSLOTS_LIMIT per-VM capability to
set the limit.

When the limit is set, it becomes impossible to manage memslots whose id
is greater or equal so make sure there are no such slots.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 Documentation/virt/kvm/api.rst | 16 ++++++++++++++++
 include/uapi/linux/kvm.h       |  1 +
 virt/kvm/kvm_main.c            | 30 ++++++++++++++++++++++++++++++
 3 files changed, 47 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 99ceb978c8b0..551236fc1261 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6038,6 +6038,22 @@ KVM_EXIT_X86_RDMSR and KVM_EXIT_X86_WRMSR exit notifications which user space
 can then handle to implement model specific MSR handling and/or user notifications
 to inform a user that an MSR was not handled.
 
+7.22 KVM_CAP_MEMSLOTS_LIMIT
+----------------------
+
+:Architectures: all
+:Target: VM
+:Parameters: args[0] is the maximum number of memory slots
+:Returns: 0 on success; E2BIG when set above global KVM_CAP_NR_MEMSLOTS; EINVAL
+          when there is an existing slot with id >= limit
+
+This capability overrides the default maximum number of memory slots, available
+per target VM. The limit can be changed at any time, however, when lowered, no
+memory slots with id ('slot' in 'struct kvm_userspace_memory_region') greater
+than the requested value should exist or EINVAL is returned. The maximum allowed
+value can be queried by checking system KVM_CAP_NR_MEMSLOTS capability. Per-VM
+KVM_CAP_NR_MEMSLOTS capability represents the currently set limit.
+
 8. Other capabilities.
 ======================
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 374c67875cdb..f68b0cde801a 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1058,6 +1058,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ENFORCE_PV_FEATURE_CPUID 190
 #define KVM_CAP_SYS_HYPERV_CPUID 191
 #define KVM_CAP_DIRTY_LOG_RING 192
+#define KVM_CAP_MEMSLOTS_LIMIT 193
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 5adb1b694304..da2cbfe9c9ee 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1412,6 +1412,31 @@ static int kvm_vm_ioctl_set_memory_region(struct kvm *kvm,
 	return kvm_set_memory_region(kvm, mem);
 }
 
+static int kvm_set_memslots_max(struct kvm *kvm, u64 max)
+{
+	struct kvm_memory_slot *memslot;
+	int r = 0, as_id;
+
+	if (max > KVM_USER_MEM_SLOTS)
+		return -E2BIG;
+
+	mutex_lock(&kvm->slots_lock);
+	for (as_id = 0; as_id < KVM_ADDRESS_SPACE_NUM; as_id++) {
+		kvm_for_each_memslot(memslot, __kvm_memslots(kvm, as_id)) {
+			if (memslot->id >= max) {
+				r = -EINVAL;
+				break;
+			}
+		}
+	}
+	if (!r)
+		kvm->memslots_max = max;
+
+	mutex_unlock(&kvm->slots_lock);
+
+	return r;
+}
+
 #ifndef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
 /**
  * kvm_get_dirty_log - get a snapshot of dirty pages
@@ -3664,6 +3689,7 @@ static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
 	case KVM_CAP_CHECK_EXTENSION_VM:
 	case KVM_CAP_ENABLE_CAP_VM:
 	case KVM_CAP_HALT_POLL:
+	case KVM_CAP_MEMSLOTS_LIMIT:
 		return 1;
 #ifdef CONFIG_KVM_MMIO
 	case KVM_CAP_COALESCED_MMIO:
@@ -3789,6 +3815,10 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
 	}
 	case KVM_CAP_DIRTY_LOG_RING:
 		return kvm_vm_ioctl_enable_dirty_log_ring(kvm, cap->args[0]);
+	case KVM_CAP_MEMSLOTS_LIMIT:
+		if (cap->flags)
+			return -EINVAL;
+		return kvm_set_memslots_max(kvm, cap->args[0]);
 	default:
 		return kvm_vm_ioctl_enable_cap(kvm, cap);
 	}
-- 
2.29.2

