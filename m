Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4885098F4
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 09:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385794AbiDUH1r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 03:27:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385757AbiDUH1m (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 03:27:42 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF5DC10BB;
        Thu, 21 Apr 2022 00:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650525892; x=1682061892;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=OC1bR1aHL/6hCtPOV+9KHIXOV6Xbb4YnTDCVqyxUZe0=;
  b=HzWoAJ3vqVTrBnCdTyH7BqXrOa+UBnTjAWQWyM6rfh4Xd1FlArM2JotV
   mNypdf+MVQvlAlAuBl6LP5NQiAyGdHtSj5T05NAip/l2MxTSYe4yB+CQk
   6oQmTJjFdO7lzrWDbCAMhBKD+72hbq01PwleVyublwymWu5Bh77SeZ16N
   91dK9eHYBi51vEooPix9ONhLB149oRdjXNgbCfkP38yV+JwDLvDUweWy3
   wF0LxHab4ghLK0xlEzwOZHnj5FpY+Yv+FKxQPlRCAc8BW4I6Nz/lcSsRi
   f3h/ya9wjd+ELhLoMKqpijdJO6qSbt7GAYySfqvyGC/XOFTaqUBykLzg5
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="324709287"
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="324709287"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 00:24:52 -0700
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="727860208"
Received: from chenyi-pc.sh.intel.com ([10.239.159.73])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 00:24:49 -0700
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
Subject: [PATCH v6 1/3] KVM: X86: Save&restore the triple fault request
Date:   Thu, 21 Apr 2022 15:29:56 +0800
Message-Id: <20220421072958.16375-2-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220421072958.16375-1-chenyi.qiang@intel.com>
References: <20220421072958.16375-1-chenyi.qiang@intel.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For the triple fault sythesized by KVM, e.g. the RSM path or
nested_vmx_abort(), if KVM exits to userspace before the request is
serviced, userspace could migrate the VM and lose the triple fault.

Add the support to save and restore the triple fault event from
userspace. Introduce a new event KVM_VCPUEVENT_VALID_TRIPLE_FAULT in
get/set_vcpu_events to track the triple fault request.

Note that in the set_vcpu_events path, userspace is able to set/clear
the triple fault request through triple_fault_pending field.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 Documentation/virt/kvm/api.rst  |  7 +++++++
 arch/x86/include/uapi/asm/kvm.h |  4 +++-
 arch/x86/kvm/x86.c              | 15 +++++++++++++--
 3 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 72183ae628f7..e09ce3cb49c5 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1150,6 +1150,9 @@ The following bits are defined in the flags field:
   fields contain a valid state. This bit will be set whenever
   KVM_CAP_EXCEPTION_PAYLOAD is enabled.
 
+- KVM_VCPUEVENT_VALID_TRIPLE_FAULT may be set to signal that the
+  triple_fault_pending field contains a valid state.
+
 ARM64:
 ^^^^^^
 
@@ -1245,6 +1248,10 @@ can be set in the flags field to signal that the
 exception_has_payload, exception_payload, and exception.pending fields
 contain a valid state and shall be written into the VCPU.
 
+KVM_VCPUEVENT_VALID_TRIPLE_FAULT can be set in flags field to signal that
+the triple_fault_pending field contains a valid state and shall be written
+into the VCPU.
+
 ARM64:
 ^^^^^^
 
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 21614807a2cb..fd083f6337af 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -325,6 +325,7 @@ struct kvm_reinject_control {
 #define KVM_VCPUEVENT_VALID_SHADOW	0x00000004
 #define KVM_VCPUEVENT_VALID_SMM		0x00000008
 #define KVM_VCPUEVENT_VALID_PAYLOAD	0x00000010
+#define KVM_VCPUEVENT_VALID_TRIPLE_FAULT	0x00000020
 
 /* Interrupt shadow states */
 #define KVM_X86_SHADOW_INT_MOV_SS	0x01
@@ -359,7 +360,8 @@ struct kvm_vcpu_events {
 		__u8 smm_inside_nmi;
 		__u8 latched_init;
 	} smi;
-	__u8 reserved[27];
+	__u8 triple_fault_pending;
+	__u8 reserved[26];
 	__u8 exception_has_payload;
 	__u64 exception_payload;
 };
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ab336f7c82e4..c8b9b0bc42aa 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4911,9 +4911,12 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
 		!!(vcpu->arch.hflags & HF_SMM_INSIDE_NMI_MASK);
 	events->smi.latched_init = kvm_lapic_latched_init(vcpu);
 
+	events->triple_fault_pending = kvm_test_request(KVM_REQ_TRIPLE_FAULT, vcpu);
+
 	events->flags = (KVM_VCPUEVENT_VALID_NMI_PENDING
 			 | KVM_VCPUEVENT_VALID_SHADOW
-			 | KVM_VCPUEVENT_VALID_SMM);
+			 | KVM_VCPUEVENT_VALID_SMM
+			 | KVM_VCPUEVENT_VALID_TRIPLE_FAULT);
 	if (vcpu->kvm->arch.exception_payload_enabled)
 		events->flags |= KVM_VCPUEVENT_VALID_PAYLOAD;
 
@@ -4929,7 +4932,8 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 			      | KVM_VCPUEVENT_VALID_SIPI_VECTOR
 			      | KVM_VCPUEVENT_VALID_SHADOW
 			      | KVM_VCPUEVENT_VALID_SMM
-			      | KVM_VCPUEVENT_VALID_PAYLOAD))
+			      | KVM_VCPUEVENT_VALID_PAYLOAD
+			      | KVM_VCPUEVENT_VALID_TRIPLE_FAULT))
 		return -EINVAL;
 
 	if (events->flags & KVM_VCPUEVENT_VALID_PAYLOAD) {
@@ -5002,6 +5006,13 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 		}
 	}
 
+	if (events->flags & KVM_VCPUEVENT_VALID_TRIPLE_FAULT) {
+		if (events->triple_fault_pending)
+			kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
+		else
+			kvm_clear_request(KVM_REQ_TRIPLE_FAULT, vcpu);
+	}
+
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 
 	return 0;
-- 
2.17.1

