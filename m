Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DEEF4CDD82
	for <lists+kvm@lfdr.de>; Fri,  4 Mar 2022 20:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbiCDT7d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Mar 2022 14:59:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiCDT7L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Mar 2022 14:59:11 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32E711FC2E8;
        Fri,  4 Mar 2022 11:50:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646423442; x=1677959442;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Xy9FLI5UsDEXLA854HQ4UqPQf34e3n+2Zs96SzzxnDE=;
  b=my4S+PS6+/l4WKzD9QkWvS/miOnPPOOEwS9PVxiBb9m08qq7mMHDpUwy
   PkUoHFMj+dLGkcurlaNiyAcYangKV4xsR31hkNoGQ+fijPCSj21FPW4He
   ouBf9DS1OyM9EHvOIYeYxOfGA+2UartKY8MmUCJkQEHaLd0XrjAEej1g1
   gu5P6EvdeWvZAf72ilwuXiclAT/oFavpmNY9UHf8bjbZ8QouiItOGwN38
   UWSbYef+lV2GnJMDbKgqB8s9BJAr0Uap82W8BFQAJGA9Bi8Mbernq+sCR
   r8CWlx/EsHr4En7LPuGu9uj4IOA4d+4uK5+1oEC7Te3nWELweC6P+Qqfa
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10276"; a="253779638"
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="253779638"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:40 -0800
X-IronPort-AV: E=Sophos;i="5.90,156,1643702400"; 
   d="scan'208";a="552344519"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2022 11:50:40 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC PATCH v5 083/104] KVM: x86: Split core of hypercall emulation to helper function
Date:   Fri,  4 Mar 2022 11:49:39 -0800
Message-Id: <f3293bd872a916bf33165a2ec0d6fc50533b817f.1646422845.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1646422845.git.isaku.yamahata@intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

By necessity, TDX will use a different register ABI for hypercalls.
Break out the core functionality so that it may be reused for TDX.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  4 +++
 arch/x86/kvm/x86.c              | 54 ++++++++++++++++++++-------------
 2 files changed, 37 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 8dab9f16f559..33b75b0e3de1 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1818,6 +1818,10 @@ void kvm_request_apicv_update(struct kvm *kvm, bool activate,
 void __kvm_request_apicv_update(struct kvm *kvm, bool activate,
 				unsigned long bit);
 
+unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
+				      unsigned long a0, unsigned long a1,
+				      unsigned long a2, unsigned long a3,
+				      int op_64_bit);
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
 
 int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 314ae43e07bf..9acb33a17445 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9090,26 +9090,15 @@ static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
 	return kvm_skip_emulated_instruction(vcpu);
 }
 
-int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
+unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
+				      unsigned long a0, unsigned long a1,
+				      unsigned long a2, unsigned long a3,
+				      int op_64_bit)
 {
-	unsigned long nr, a0, a1, a2, a3, ret;
-	int op_64_bit;
-
-	if (kvm_xen_hypercall_enabled(vcpu->kvm))
-		return kvm_xen_hypercall(vcpu);
-
-	if (kvm_hv_hypercall_enabled(vcpu))
-		return kvm_hv_hypercall(vcpu);
-
-	nr = kvm_rax_read(vcpu);
-	a0 = kvm_rbx_read(vcpu);
-	a1 = kvm_rcx_read(vcpu);
-	a2 = kvm_rdx_read(vcpu);
-	a3 = kvm_rsi_read(vcpu);
+	unsigned long ret;
 
 	trace_kvm_hypercall(nr, a0, a1, a2, a3);
 
-	op_64_bit = is_64_bit_hypercall(vcpu);
 	if (!op_64_bit) {
 		nr &= 0xFFFFFFFF;
 		a0 &= 0xFFFFFFFF;
@@ -9118,11 +9107,6 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		a3 &= 0xFFFFFFFF;
 	}
 
-	if (static_call(kvm_x86_get_cpl)(vcpu) != 0) {
-		ret = -KVM_EPERM;
-		goto out;
-	}
-
 	ret = -KVM_ENOSYS;
 
 	switch (nr) {
@@ -9181,6 +9165,34 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		ret = -KVM_ENOSYS;
 		break;
 	}
+	return ret;
+}
+EXPORT_SYMBOL_GPL(__kvm_emulate_hypercall);
+
+int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
+{
+	unsigned long nr, a0, a1, a2, a3, ret;
+	int op_64_bit;
+
+	if (kvm_xen_hypercall_enabled(vcpu->kvm))
+		return kvm_xen_hypercall(vcpu);
+
+	if (kvm_hv_hypercall_enabled(vcpu))
+		return kvm_hv_hypercall(vcpu);
+
+	nr = kvm_rax_read(vcpu);
+	a0 = kvm_rbx_read(vcpu);
+	a1 = kvm_rcx_read(vcpu);
+	a2 = kvm_rdx_read(vcpu);
+	a3 = kvm_rsi_read(vcpu);
+	op_64_bit = is_64_bit_mode(vcpu);
+
+	if (static_call(kvm_x86_get_cpl)(vcpu) != 0) {
+		ret = -KVM_EPERM;
+		goto out;
+	}
+
+	ret = __kvm_emulate_hypercall(vcpu, nr, a0, a1, a2, a3, op_64_bit);
 out:
 	if (!op_64_bit)
 		ret = (u32)ret;
-- 
2.25.1

