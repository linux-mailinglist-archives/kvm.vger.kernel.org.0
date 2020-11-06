Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91DD62A91F3
	for <lists+kvm@lfdr.de>; Fri,  6 Nov 2020 10:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbgKFJBJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Nov 2020 04:01:09 -0500
Received: from mga09.intel.com ([134.134.136.24]:4564 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725835AbgKFJBH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Nov 2020 04:01:07 -0500
IronPort-SDR: rrAk2ORiCrykh8+ON32mIGX+rJYwi3aFtKJmM2dKy3KrDb+KV2dwdrHokm63ZW3UP+owWElZ25
 vSsdAXBRjIsA==
X-IronPort-AV: E=McAfee;i="6000,8403,9796"; a="169670258"
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="169670258"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2020 01:01:07 -0800
IronPort-SDR: CUDRVOnnYZPsvzsw9aOifp7mwsG94ijXtVR5wzREv2lElIa1aJEp/8+EURYKfs0jLQhUkP4bon
 PNdrSODFafew==
X-IronPort-AV: E=Sophos;i="5.77,456,1596524400"; 
   d="scan'208";a="472000383"
Received: from chenyi-pc.sh.intel.com ([10.239.159.72])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2020 01:01:04 -0800
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 4/4] KVM: X86: Add the Document for KVM_CAP_X86_BUS_LOCK_EXIT
Date:   Fri,  6 Nov 2020 17:03:15 +0800
Message-Id: <20201106090315.18606-5-chenyi.qiang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201106090315.18606-1-chenyi.qiang@intel.com>
References: <20201106090315.18606-1-chenyi.qiang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce a new capability named KVM_CAP_X86_BUS_LOCK_EXIT, which is
used to handle bus locks detected in guest. It allows the userspace to
do custom throttling policies to mitigate the 'noisy neighbour' problem.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 Documentation/virt/kvm/api.rst | 45 +++++++++++++++++++++++++++++++---
 1 file changed, 42 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 36d5f1f3c6dd..16fae38feb55 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4869,9 +4869,11 @@ local APIC is not used.
 	__u16 flags;
 
 More architecture-specific flags detailing state of the VCPU that may
-affect the device's behavior.  The only currently defined flag is
-KVM_RUN_X86_SMM, which is valid on x86 machines and is set if the
-VCPU is in system management mode.
+affect the device's behavior. Current defined flags:
+  /* x86, set if the VCPU is in system management mode */
+  #define KVM_RUN_X86_SMM     (1 << 0)
+  /* x86, set if bus lock detected in VM */
+  #define KVM_RUN_BUS_LOCK    (1 << 1)
 
 ::
 
@@ -6014,6 +6016,43 @@ KVM_EXIT_X86_RDMSR and KVM_EXIT_X86_WRMSR exit notifications which user space
 can then handle to implement model specific MSR handling and/or user notifications
 to inform a user that an MSR was not handled.
 
+7.22 KVM_CAP_X86_BUS_LOCK_EXIT
+-------------------------------
+
+:Architectures: x86
+:Target: VM
+:Parameters: args[0] defines the policy used when bus locks detected in guest
+:Returns: 0 on success, -EINVAL when args[0] contains invalid bits
+
+Valid bits in args[0] are::
+
+  #define KVM_BUS_LOCK_DETECTION_OFF      (1 << 0)
+  #define KVM_BUS_LOCK_DETECTION_EXIT     (1 << 1)
+
+Enabling this capability on a VM provides userspace with a way to select
+a policy to handle the bus locks detected in guest. Userspace can obtain
+the supported modes from the result of KVM_CHECK_EXTENSION and define it
+through the KVM_ENABLE_CAP.
+
+KVM_BUS_LOCK_DETECTION_OFF and KVM_BUS_LOCK_DETECTION_EXIT are supported
+currently and mutually exclusive with each other. More bits can be added in
+the future.
+
+With KVM_BUS_LOCK_DETECTION_OFF set, bus locks in guest will not cause vm exits
+so that no additional actions are needed. This is the default mode.
+
+With KVM_BUS_LOCK_DETECTION_EXIT set, vm exits happen when bus lock detected
+in VM. KVM just exits to userspace when handling them. Userspace can enforce
+its own throttling or other policy based mitigations.
+
+This capability is aimed to address the thread that VM can exploit bus locks to
+degree the performance of the whole system. Once the userspace enable this
+capability and select the KVM_BUS_LOCK_DETECTION_EXIT mode, KVM will set the
+KVM_RUN_BUS_LOCK flag in vcpu-run->flags field and exit to userspace. Concerning
+the bus lock vm exit can be preempted by a higher priority VM exit, the exit
+notifications to userspace can be KVM_EXIT_BUS_LOCK or other reasons.
+KVM_RUN_BUS_LOCK flag is used to distinguish between them.
+
 8. Other capabilities.
 ======================
 
-- 
2.17.1

