Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D05C4DD55E
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 08:44:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233196AbiCRHpv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 03:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233179AbiCRHpp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 03:45:45 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 193531F42D7;
        Fri, 18 Mar 2022 00:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647589467; x=1679125467;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=3QUWsALuGQYp91bXIF09ndc4AvW2iQVHi+0HN3uLFBw=;
  b=ZqdYPuyQNNwU8fHAKOST6YsOR2eYPjOIO71UAJwEGwrBc1Qre6Hr1Wdb
   QrZXSnvUguVzIeDw6RK00mdMAgK5hh/QTD60XeZpO6cGCsUE40bs4CXGW
   qGi2qdSNvxaO/t3aVUBrig1ehg76peK/1ihwjywh/X8TfQPflHv5TYW1t
   eh9Ihw5ACX2Q2akWhKIYxXvq3oTTfgbx4T97l6zjREqnHEPYai3rnR625
   ZKHoq3/4gqExKEL+ySyYwK28OCLMZmLwsByqoH3vo6jJmeQezly9JSsE8
   EKOZ9oqassWUCVCdVtVGiyM9CS5rEMr66QHTao0qyD+pFEqcOMFMpXpPt
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10289"; a="254641664"
X-IronPort-AV: E=Sophos;i="5.90,191,1643702400"; 
   d="scan'208";a="254641664"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2022 00:44:26 -0700
X-IronPort-AV: E=Sophos;i="5.90,191,1643702400"; 
   d="scan'208";a="558307288"
Received: from chenyi-pc.sh.intel.com ([10.239.159.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2022 00:44:24 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 1/3] KVM: X86: Save&restore the triple fault request
Date:   Fri, 18 Mar 2022 15:49:53 +0800
Message-Id: <20220318074955.22428-2-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220318074955.22428-1-chenyi.qiang@intel.com>
References: <20220318074955.22428-1-chenyi.qiang@intel.com>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
Fix this issue by adding a new event KVM_VCPUEVENT_TRIPLE_FAULT in
get/set_vcpu_events() to track the triple fault request.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 Documentation/virt/kvm/api.rst  | 6 ++++++
 arch/x86/include/uapi/asm/kvm.h | 1 +
 arch/x86/kvm/x86.c              | 9 ++++++++-
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 691ff84444bd..9682b0a438bd 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1146,6 +1146,9 @@ The following bits are defined in the flags field:
   fields contain a valid state. This bit will be set whenever
   KVM_CAP_EXCEPTION_PAYLOAD is enabled.
 
+- KVM_VCPUEVENT_TRIPLE_FAULT may be set to signal that there's a
+  triple fault request waiting to be serviced.
+
 ARM/ARM64:
 ^^^^^^^^^^
 
@@ -1241,6 +1244,9 @@ can be set in the flags field to signal that the
 exception_has_payload, exception_payload, and exception.pending fields
 contain a valid state and shall be written into the VCPU.
 
+KVM_VCPUEVENT_TRIPLE_FAULT can be set in flags field to signal that a
+triple fault request should be made.
+
 ARM/ARM64:
 ^^^^^^^^^^
 
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index bf6e96011dfe..d8ef0d993e86 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -325,6 +325,7 @@ struct kvm_reinject_control {
 #define KVM_VCPUEVENT_VALID_SHADOW	0x00000004
 #define KVM_VCPUEVENT_VALID_SMM		0x00000008
 #define KVM_VCPUEVENT_VALID_PAYLOAD	0x00000010
+#define KVM_VCPUEVENT_TRIPLE_FAULT	0x00000020
 
 /* Interrupt shadow states */
 #define KVM_X86_SHADOW_INT_MOV_SS	0x01
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4fa4d8269e5b..fee402a700df 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4891,6 +4891,9 @@ static void kvm_vcpu_ioctl_x86_get_vcpu_events(struct kvm_vcpu *vcpu,
 	if (vcpu->kvm->arch.exception_payload_enabled)
 		events->flags |= KVM_VCPUEVENT_VALID_PAYLOAD;
 
+	if (kvm_check_request(KVM_REQ_TRIPLE_FAULT, vcpu))
+		events->flags |= KVM_VCPUEVENT_TRIPLE_FAULT;
+
 	memset(&events->reserved, 0, sizeof(events->reserved));
 }
 
@@ -4903,7 +4906,8 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 			      | KVM_VCPUEVENT_VALID_SIPI_VECTOR
 			      | KVM_VCPUEVENT_VALID_SHADOW
 			      | KVM_VCPUEVENT_VALID_SMM
-			      | KVM_VCPUEVENT_VALID_PAYLOAD))
+			      | KVM_VCPUEVENT_VALID_PAYLOAD
+			      | KVM_VCPUEVENT_TRIPLE_FAULT))
 		return -EINVAL;
 
 	if (events->flags & KVM_VCPUEVENT_VALID_PAYLOAD) {
@@ -4976,6 +4980,9 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 		}
 	}
 
+	if (events->flags & KVM_VCPUEVENT_TRIPLE_FAULT)
+		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
+
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 
 	return 0;
-- 
2.17.1

