Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFEC7626A9
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 00:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233088AbjGYWZ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 18:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233380AbjGYWXw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 18:23:52 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35F1C26B6;
        Tue, 25 Jul 2023 15:19:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690323569; x=1721859569;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oacKdQeMh8QuirRSr8ipRHm85rmLeDu5QPcTK7AXcqY=;
  b=PqQffRyldbnRumqqjYLFc4M1uBnuIfa5rDEBDQN2uQO06gmo0CMTFlqY
   B0V0ULRV3IjsxZ8OWtpbb3rr0m7T9Qf9bJzS3avWM6mfaaGB/9gpZ64nZ
   aFjUMp31P+7qHg1XPQ+TovhvERSxKcVpGN6WekmFFZsDxBlIHr38h+xXj
   BXGRsxbRmbag6l3AcnFdj2a6EGEejXZO0dIK601po+mgxoLQWn5SansEf
   YZk8nHFe2jUFcXaYYZNCw8szkHUwAr3gutMrDwQ4POu8KmroCH1Zvb9dq
   KwwnBfy70bA7emS69CARyekmn5s+lMB0z+qHyOedv+F+od4vHJ5YTKbFv
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="367882800"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="367882800"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:16:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10782"; a="840001978"
X-IronPort-AV: E=Sophos;i="6.01,231,1684825200"; 
   d="scan'208";a="840001978"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jul 2023 15:16:12 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        hang.yuan@intel.com, tina.zhang@intel.com
Subject: [PATCH v15 113/115] RFC: KVM: x86: Add x86 callback to check cpuid
Date:   Tue, 25 Jul 2023 15:15:04 -0700
Message-Id: <8787693c245ceeeada515fcca5ef78da3a1a7343.1690322424.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1690322424.git.isaku.yamahata@intel.com>
References: <cover.1690322424.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

The x86 backend should check the consistency of KVM_SET_CPUID2 because it
has its constraint.  Add a callback for it.  The backend code will come as
another patch.

Suggested-by: Sean Christopherson <seanjc@google.com>
Link: https://lore.kernel.org/lkml/ZDiGpCkXOcCm074O@google.com/
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm-x86-ops.h | 2 ++
 arch/x86/include/asm/kvm_host.h    | 1 +
 arch/x86/kvm/cpuid.c               | 6 +++++-
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index ba9cc4ac9093..aaa7db45d809 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -20,6 +20,8 @@ KVM_X86_OP(hardware_disable)
 KVM_X86_OP(hardware_unsetup)
 KVM_X86_OP_OPTIONAL_RET0(offline_cpu)
 KVM_X86_OP(has_emulated_msr)
+/* TODO: Once all backend implemented this op, remove _OPTIONAL_RET0. */
+KVM_X86_OP_OPTIONAL_RET0(vcpu_check_cpuid)
 KVM_X86_OP(vcpu_after_set_cpuid)
 KVM_X86_OP(is_vm_type_supported)
 KVM_X86_OP_OPTIONAL(max_vcpus);
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 291d36a668e5..304c01945115 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1590,6 +1590,7 @@ struct kvm_x86_ops {
 	void (*hardware_unsetup)(void);
 	int (*offline_cpu)(void);
 	bool (*has_emulated_msr)(struct kvm *kvm, u32 index);
+	int (*vcpu_check_cpuid)(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2, int nent);
 	void (*vcpu_after_set_cpuid)(struct kvm_vcpu *vcpu);
 
 	bool (*is_vm_type_supported)(unsigned long vm_type);
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 09b83f7c228d..de10a2de1dd5 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -123,6 +123,7 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu,
 {
 	struct kvm_cpuid_entry2 *best;
 	u64 xfeatures;
+	int r;
 
 	/*
 	 * The existing code assumes virtual address is 48-bit or 57-bit in the
@@ -150,7 +151,10 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu,
 	if (!xfeatures)
 		return 0;
 
-	return fpu_enable_guest_xfd_features(&vcpu->arch.guest_fpu, xfeatures);
+	r = fpu_enable_guest_xfd_features(&vcpu->arch.guest_fpu, xfeatures);
+	if (r)
+		return r;
+	return static_call(kvm_x86_vcpu_check_cpuid)(vcpu, entries, nent);
 }
 
 /* Check whether the supplied CPUID data is equal to what is already set for the vCPU. */
-- 
2.25.1

