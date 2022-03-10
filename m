Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB9CA4D42A3
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 09:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240404AbiCJIfL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 03:35:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240395AbiCJIfK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 03:35:10 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A53AF6007C;
        Thu, 10 Mar 2022 00:34:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646901249; x=1678437249;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=0vgaltpLANjnEV3KkRyk4QfDmirQxEdPtwOwveOGkU0=;
  b=YO/MpOCmzR2FrnMBCiho7bwv7w7SWHdjd9hItUx1jQPgevU/H2MBH6St
   8dD9JsvBFPNP+9UHSJDpNWRDQ/79wZ/g9/clIs+tnn55/jxnBmjZlO5e6
   vxASCR0kLqVdCz20fkRW57FhF7b7uV4D5WcvueV2qRA9+cJQFw3miwbc1
   hVzWT7H2xtVDifYOxUuioxXfi5jcC6li8xJoYTt1HmwPaFssL/pELeIN5
   FCKycXcHN8us3+Li50NevIrX+TjyblYkUqDk5i0ME80c4JXQFFYzuT3U3
   rn/80AAlmIu6Zf9a4EEw1zGdEmrzAfZvEzemil6Mqj3/PflIfBGr6E5+v
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="235800128"
X-IronPort-AV: E=Sophos;i="5.90,169,1643702400"; 
   d="scan'208";a="235800128"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 00:34:09 -0800
X-IronPort-AV: E=Sophos;i="5.90,169,1643702400"; 
   d="scan'208";a="513891430"
Received: from chenyi-pc.sh.intel.com ([10.239.159.73])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 00:34:06 -0800
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
Subject: [PATCH v4 1/3] KVM: X86: Extend KVM_SET_VCPU_EVENTS to inject a SHUTDOWN event
Date:   Thu, 10 Mar 2022 16:39:59 +0800
Message-Id: <20220310084001.10235-2-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220310084001.10235-1-chenyi.qiang@intel.com>
References: <20220310084001.10235-1-chenyi.qiang@intel.com>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In some fatal case, the target vcpu would run into unexpected behavior
and should get shutdown (e.g. VM context is corrupted and not valid in
VMCS). User space would be informed in such case. To kill the target
vcpu, extend KVM_SET_VCPU_EVENTS ioctl to inject a synthesized SHUTDOWN
event with a new bit set in flags field. KVM would accordingly make
KVM_REQ_TRIPLE_FAULT request to trigger the real shutdown exit. Noting
that the KVM_REQ_TRIPLE_FAULT request also applies to the nested case,
so that only the target L2 vcpu would be killed.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 Documentation/virt/kvm/api.rst  | 3 +++
 arch/x86/include/uapi/asm/kvm.h | 1 +
 arch/x86/kvm/x86.c              | 6 +++++-
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 691ff84444bd..d1971ef613e7 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1241,6 +1241,9 @@ can be set in the flags field to signal that the
 exception_has_payload, exception_payload, and exception.pending fields
 contain a valid state and shall be written into the VCPU.
 
+KVM_VCPUEVENT_SHUTDOWN can be set in flags field to synthesize a SHUTDOWN
+event for a vcpu from user space.
+
 ARM/ARM64:
 ^^^^^^^^^^
 
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index bf6e96011dfe..44757bd6122d 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -325,6 +325,7 @@ struct kvm_reinject_control {
 #define KVM_VCPUEVENT_VALID_SHADOW	0x00000004
 #define KVM_VCPUEVENT_VALID_SMM		0x00000008
 #define KVM_VCPUEVENT_VALID_PAYLOAD	0x00000010
+#define KVM_VCPUEVENT_SHUTDOWN		0x00000020
 
 /* Interrupt shadow states */
 #define KVM_X86_SHADOW_INT_MOV_SS	0x01
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4fa4d8269e5b..53c8592066c8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4903,7 +4903,8 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 			      | KVM_VCPUEVENT_VALID_SIPI_VECTOR
 			      | KVM_VCPUEVENT_VALID_SHADOW
 			      | KVM_VCPUEVENT_VALID_SMM
-			      | KVM_VCPUEVENT_VALID_PAYLOAD))
+			      | KVM_VCPUEVENT_VALID_PAYLOAD
+			      | KVM_VCPUEVENT_SHUTDOWN))
 		return -EINVAL;
 
 	if (events->flags & KVM_VCPUEVENT_VALID_PAYLOAD) {
@@ -4976,6 +4977,9 @@ static int kvm_vcpu_ioctl_x86_set_vcpu_events(struct kvm_vcpu *vcpu,
 		}
 	}
 
+	if (events->flags & KVM_VCPUEVENT_SHUTDOWN)
+		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
+
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 
 	return 0;
-- 
2.17.1

