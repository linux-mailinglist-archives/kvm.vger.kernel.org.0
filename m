Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCAA4D42A2
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 09:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240403AbiCJIfZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 03:35:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240419AbiCJIfU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 03:35:20 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A67C565499;
        Thu, 10 Mar 2022 00:34:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646901255; x=1678437255;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=1Ci8wmc4QnWVvGCglhDZfZ44ul1gd+Bv3nt/tjac9mI=;
  b=k60P1MdEhfTIxqUOGtdquyiLPf0VRnFc31XM0LKv5hnvYcBl6BqJC9ZT
   4XFbcONLhEJZPmHUp7eBJMh8z2wOvZjO5pOFnq0kARXA+XNLXE/3fuqR2
   qtRjyi11Yaac4Bigb471LPSipUNPfIY6PfzZ1d8VoDbPnY9UCU0KDLFYi
   V+wKzehb2u9AL59H1nLCgDUBjK2p66rhrCPSeqgjNBZx28tOg/svYW695
   dJctxB7zqKjLy+hgd0d9ZLgHik60uk2ZkHz5ygZ0qobINPkQE0O7gCEhv
   6GPNmt5wrVmLG3Y1a/SMkak7nQTPT5qn8nUnwp+TnIVqfhJbLwUvDKGwz
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10281"; a="235800161"
X-IronPort-AV: E=Sophos;i="5.90,169,1643702400"; 
   d="scan'208";a="235800161"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 00:34:15 -0800
X-IronPort-AV: E=Sophos;i="5.90,169,1643702400"; 
   d="scan'208";a="513891471"
Received: from chenyi-pc.sh.intel.com ([10.239.159.73])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 00:34:12 -0800
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
Subject: [PATCH v4 3/3] KVM: Add document for KVM_CAP_X86_NOTIFY_VMEXIT and KVM_EXIT_NOTIFY
Date:   Thu, 10 Mar 2022 16:40:01 +0800
Message-Id: <20220310084001.10235-4-chenyi.qiang@intel.com>
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

Add brief documentation for KVM_CAP_X86_BUS_LOCK_EXIT, as well as the
new field in kvm_run struct for the exit reason KVM_EXIT_NOTIFY.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 Documentation/virt/kvm/api.rst | 39 ++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index d1971ef613e7..7c0f33cf5881 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6196,6 +6196,26 @@ array field represents return values. The userspace should update the return
 values of SBI call before resuming the VCPU. For more details on RISC-V SBI
 spec refer, https://github.com/riscv/riscv-sbi-doc.
 
+::
+
+    /* KVM_EXIT_NOTIFY */
+    struct {
+  #define KVM_NOTIFY_CONTEXT_INVALID	(1 << 0)
+      __u32 data;
+    } notify;
+
+Used on x86 systems. When the VM capability KVM_CAP_X86_NOTIFY_VMEXIT is
+enabled and the parameter is non-negative, a VM exit generated if no event
+window occurs in VM non-root mode for a specified amount of time. In some
+special case, e.g. VM context invalid, it should exit to userspace with the
+exit reason KVM_EXIT_NOTIFY for further handling. The "data" field contains
+the more detailed info.
+
+Valid values for 'data' are:
+
+  - KVM_NOTIFY_CONTEXT_INVALID -- the VM context is corrupted and not valid
+    in VMCS. It would run into unknown result if resume the target VM.
+
 ::
 
 		/* Fix the size of the union. */
@@ -7082,6 +7102,25 @@ resource that is controlled with the H_SET_MODE hypercall.
 This capability allows a guest kernel to use a better-performance mode for
 handling interrupts and system calls.
 
+7.31 KVM_CAP_X86_NOTIFY_VMEXIT
+------------------------------
+
+:Architectures: x86
+:Target: VM
+:Parameters: args[0] is the value of notify window
+:Returns: 0 on success, -EINVAL if hardware doesn't support notify VM exit.
+
+This capability allows userspace to configure the notify VM exit on/off
+in per-VM scope during VM creation. Notify VM exit is disabled by default.
+When userspace provides a non-negative value in args[0], VMM would enable
+this feature to trigger VM exit if no event window occurs in VM non-root
+mode for a specified of time (notify window). The notify window is just
+determined by args[0].
+
+This capability is aimed to mitigate the threat that malicious VMs can
+cause CPU stuck (due to event windows don't open up) and make the CPU
+unavailable to host or other VMs.
+
 8. Other capabilities.
 ======================
 
-- 
2.17.1

