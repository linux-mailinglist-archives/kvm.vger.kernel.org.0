Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7C894DD564
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 08:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233186AbiCRHqY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 03:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233185AbiCRHqX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 03:46:23 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA07D1F42E0;
        Fri, 18 Mar 2022 00:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647589498; x=1679125498;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=4qlZT+Fa4OCk7XLn6JGocR/sVD1bjrCN/O9P6N254W4=;
  b=MpIxMZ+Gd46ydlzFmq6i9kUS1gdAe1AO6jxLXweVgVuMwWEDYPvAU4aw
   JRg39MCXLYY0cO2PAww4OPrJUbVTNp39VZXsyP1HJx4n1enDUh8kczI6Z
   jHlqXGHAVcg98oXRACSt8KLyPfZhn1nRui//cy92O7Q7LAKH2oVr8s3Fc
   xjlhj+vhUCOVVkYzw9LzvYYHrJEtMqnDDH8v0lM4+Ino9nlXFTJOq4+VX
   2wqLfGJrQbtg8x+BBX7j2X1/Kyy1+HlNly/cVNZAphQMHuoczxNzIq859
   FV2ENVWvFLZuh275PETE5QLUPtyh4GW0JlhTBab2kenVAb3O5VGwAvoNZ
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10289"; a="254641687"
X-IronPort-AV: E=Sophos;i="5.90,191,1643702400"; 
   d="scan'208";a="254641687"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2022 00:44:32 -0700
X-IronPort-AV: E=Sophos;i="5.90,191,1643702400"; 
   d="scan'208";a="558307329"
Received: from chenyi-pc.sh.intel.com ([10.239.159.73])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2022 00:44:29 -0700
From:   Chenyi Qiang <chenyi.qiang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 3/3] KVM: Add document for KVM_CAP_X86_NOTIFY_VMEXIT and KVM_EXIT_NOTIFY
Date:   Fri, 18 Mar 2022 15:49:55 +0800
Message-Id: <20220318074955.22428-4-chenyi.qiang@intel.com>
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

Add brief documentation for KVM_CAP_X86_NOTIFY_VMEXIT, as well as the
new field in kvm_run struct for the exit reason KVM_EXIT_NOTIFY.

Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
---
 Documentation/virt/kvm/api.rst | 39 ++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 9682b0a438bd..d60b03b5a63e 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6199,6 +6199,26 @@ array field represents return values. The userspace should update the return
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
@@ -7085,6 +7105,25 @@ resource that is controlled with the H_SET_MODE hypercall.
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
+mode for a specified of time (notify window). The notify window is determined
+by args[0].
+
+This capability is aimed to mitigate the threat that malicious VMs can
+cause CPU stuck (due to event windows don't open up) and make the CPU
+unavailable to host or other VMs.
+
 8. Other capabilities.
 ======================
 
-- 
2.17.1

