Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E070D532BAC
	for <lists+kvm@lfdr.de>; Tue, 24 May 2022 15:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237961AbiEXNu0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 May 2022 09:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237945AbiEXNuS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 May 2022 09:50:18 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7651595A05;
        Tue, 24 May 2022 06:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653400216; x=1684936216;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=9apCBwqmzAfODC9BKiu61l6Rp+B5ti4Es2DMtduC3rY=;
  b=jCkYf9jISSZ2GhxSQ7kEyiLfUFCYg2QFfb1uTha4EvyJo46J8C961xi5
   wxWg96dcdZrlftrS67yp0TyF4F1FMoInT1IL1dAmzc3XPDpBK0tkNRukj
   jY0vqYOlr56wNxCcxx/mI+gNPJnUphwBxEYRzmlZrg3Mm7qJ5MezAxQrY
   8sGEuNlGub0q5JU8ZeG1nGZY4JlY39gXgRT/WayIB95yGV9yo7dEndcss
   J0Vxgpir1Ef36NVNHT7ltPkJ/KXYrdmmfVhk4Bg+AmD5QcOqRH6MUfT9J
   GoLFbBdOH5pPp3b5ap3eGdIil/kyv/5+y+03hFMSYvqhO6ezFcmhp/WZi
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10356"; a="272351833"
X-IronPort-AV: E=Sophos;i="5.91,248,1647327600"; 
   d="scan'208";a="272351833"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2022 06:50:16 -0700
X-IronPort-AV: E=Sophos;i="5.91,248,1647327600"; 
   d="scan'208";a="601311981"
Received: from chenyi-pc.sh.intel.com ([10.239.159.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2022 06:50:12 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chenyi Qiang <chenyi.qiang@intel.com>
Subject: [PATCH v7 1/4] KVM: x86: Extend KVM_{G,S}ET_VCPU_EVENTS to support pending triple fault
Date:   Tue, 24 May 2022 21:56:21 +0800
Message-Id: <20220524135624.22988-2-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220524135624.22988-1-chenyi.qiang@intel.com>
References: <20220524135624.22988-1-chenyi.qiang@intel.com>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For the triple fault sythesized by KVM, e.g. the RSM path or
nested_vmx_abort(), if KVM exits to userspace before the request is
serviced, userspace could migrate the VM and lose the triple fault.

Extend KVM_{G,S}ET_VCPU_EVENTS to support pending triple fault with a
new event KVM_VCPUEVENT_VALID_FAULT_FAULT so that userspace can save and
restore the triple fault event. This extension is guarded by a new KVM
capability KVM_CAP_TRIPLE_FAULT_EVENT.

Note that in the set_vcpu_events path, userspace is able to set/clear
the triple fault request through triple_fault.pending field.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 Documentation/virt/kvm/api.rst  |  8 ++++++++
 arch/x86/include/asm/kvm_host.h |  2 ++
 arch/x86/include/uapi/asm/kvm.h |  6 +++++-
 arch/x86/kvm/x86.c              | 21 ++++++++++++++++++++-
 include/uapi/linux/kvm.h        |  1 +
 5 files changed, 36 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 23baf7fce038..d219523bdb70 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1150,6 +1150,10 @@ The following bits are defined in the flags field:
   fields contain a valid state. This bit will be set whenever
   KVM_CAP_EXCEPTION_PAYLOAD is enabled.
 
+- KVM_VCPUEVENT_VALID_TRIPLE_FAULT may be set to signal that the
+  triple_fault_pending field contains a valid state. This bit will
+  be set whenever KVM_CAP_TRIPLE_FAULT_EVENT is enabled.
+
 ARM64:
 ^^^^^^
 
@@ -1245,6 +1249,10 @@ can be set in the flags field to signal that the
 exception_has_payload, exception_payload, and exception.pending fields
 contain a valid state and shall be written into the VCPU.
 
+If KVM_CAP_TRIPLE_FAULT_EVENT is enabled, KVM_VCPUEVENT_VALID_TRIPLE_FAULT
+can be set in flags field to signal that the triple_fault field contains
+a valid state and shall be written into the VCPU.
+
 ARM64:
 ^^^^^^
 
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9cdc5bbd721f..5b264a24652d 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1174,6 +1174,8 @@ struct kvm_arch {
 	bool guest_can_read_msr_platform_info;
 	bool exception_payload_enabled;
 
+	bool triple_fault_event;
+
 	bool bus_lock_detection_enabled;
 	bool enable_pmu;
 	/*
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 21614807a2cb..24c807c8d5f7 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -325,6 +325,7 @@ struct kvm_reinject_control {
 #define KVM_VCPUEVENT_VALID_SHADOW	0x00000004
 #define KVM_VCPUEVENT_VALID_SMM		0x00000008
 #define KVM_VCPUEVENT_VALID_PAYLOAD	0x00000010
+#define KVM_VCPUEVENT_VALID_TRIPLE_FAULT	0x00000020
 
 /* Interrupt shadow states */
 #define KVM_X86_SHADOW_INT_MOV_SS	0x01
@@ -359,7 +360,10 @@ struct kvm_vcpu_events {
 		__u8 smm_inside_nmi;
 		__u8 latched_init;
 	} smi;
-	__u8 reserved[27];
+	struct {
+		__u8 pending;
+	} triple_fault;
+	__u8 reserved[26];
 	__u8 exception_has_payload;
 	__u64 exception_payload;
 };
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 04812eaaf61b..e27ccfc88d15 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4293,6 +4293,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_GET_MSR_FEATURES:
 	case KVM_CAP_MSR_PLATFORM_INFO:
 	case KVM_CAP_EXCEPTION_PAYLOAD:
+	case KVM_CAP_TRIPLE_FAULT_EVENT:
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_LAST_CPU:
 	case KVM_CAP_X86_USER_SPACE_MSR:
@@ -4939,6 +4940,10 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
 			 | KVM_VCPUEVENT_VALID_SMM);
 	if (vcpu->kvm->arch.exception_payload_enabled)
 		events->flags |= KVM_VCPUEVENT_VALID_PAYLOAD;
+	if (vcpu->kvm->arch.triple_fault_event) {
+		events->triple_fault.pending = kvm_test_request(KVM_REQ_TRIPLE_FAULT, vcpu);
+		events->flags |= KVM_VCPUEVENT_VALID_TRIPLE_FAULT;
+	}
 
 	memset(&events->reserved, 0, sizeof(events->reserved));
 }
@@ -4952,7 +4957,8 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 			      | KVM_VCPUEVENT_VALID_SIPI_VECTOR
 			      | KVM_VCPUEVENT_VALID_SHADOW
 			      | KVM_VCPUEVENT_VALID_SMM
-			      | KVM_VCPUEVENT_VALID_PAYLOAD))
+			      | KVM_VCPUEVENT_VALID_PAYLOAD
+			      | KVM_VCPUEVENT_VALID_TRIPLE_FAULT))
 		return -EINVAL;
 
 	if (events->flags & KVM_VCPUEVENT_VALID_PAYLOAD) {
@@ -5025,6 +5031,15 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 		}
 	}
 
+	if (events->flags & KVM_VCPUEVENT_VALID_TRIPLE_FAULT) {
+		if (!vcpu->kvm->arch.triple_fault_event)
+			return -EINVAL;
+		if (events->triple_fault.pending)
+			kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
+		else
+			kvm_clear_request(KVM_REQ_TRIPLE_FAULT, vcpu);
+	}
+
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 
 	return 0;
@@ -6026,6 +6041,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		kvm->arch.exception_payload_enabled = cap->args[0];
 		r = 0;
 		break;
+	case KVM_CAP_TRIPLE_FAULT_EVENT:
+		kvm->arch.triple_fault_event = cap->args[0];
+		r = 0;
+		break;
 	case KVM_CAP_X86_USER_SPACE_MSR:
 		kvm->arch.user_space_msr_mask = cap->args[0];
 		r = 0;
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index e10d131edd80..ec75b56229c7 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1153,6 +1153,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_DISABLE_QUIRKS2 213
 #define KVM_CAP_VM_TSC_CONTROL 214
 #define KVM_CAP_SYSTEM_EVENT_DATA 215
+#define KVM_CAP_TRIPLE_FAULT_EVENT 216
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.17.1

