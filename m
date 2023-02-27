Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B62DD6A3D05
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 09:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231759AbjB0I3g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 03:29:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231660AbjB0I2s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 03:28:48 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A751BAEE;
        Mon, 27 Feb 2023 00:25:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677486343; x=1709022343;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kQr2gKQ7trKpItl8kDnUbyR3cFkXgDJ0drMXkUnVsks=;
  b=fvgYKTtDnnBbNpIOX7eX+qMrZU/fn3PjinkXvSqOvNS/1W00B7NMd8Fc
   xX5WPk8/wUFKoiVBFQeDBNklj/A0AIhhbinG6xJXqA4aH6vf3fdYwNdM3
   PVP3F4XkW786iQIu/rSYHk1Oahhf03/z1Ztp9HGyvk71py4hyjGkbYWN8
   oKkgpOw0k/o16BDOXBwtV+eCaYJa06KKt9G3SqfOQsDBdWTzmGd4VddlJ
   VrSyUN8kwl9t9qWYRwYS/PsZazuZk+i7zk8jgS51QpuUnqLJMQd3KIzVH
   3WkFF/IRFS8Xwd5p7HVoEJqze3YBQ8GdVcac6dS8j79JosdviQZi2Ozfo
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="317608994"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="317608994"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:16 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10633"; a="783242347"
X-IronPort-AV: E=Sophos;i="5.97,331,1669104000"; 
   d="scan'208";a="783242347"
Received: from ls.sc.intel.com (HELO localhost) ([143.183.96.54])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 00:24:16 -0800
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v12 075/106] KVM: x86: Split core of hypercall emulation to helper function
Date:   Mon, 27 Feb 2023 00:23:14 -0800
Message-Id: <de9d55ffe25c566032eb44304d435e16a426c370.1677484918.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1677484918.git.isaku.yamahata@intel.com>
References: <cover.1677484918.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
index 2051ae6da619..301059b2e882 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2085,6 +2085,10 @@ static inline void kvm_clear_apicv_inhibit(struct kvm *kvm,
 	kvm_set_or_clear_apicv_inhibit(kvm, reason, false);
 }
 
+unsigned long __kvm_emulate_hypercall(struct kvm_vcpu *vcpu, unsigned long nr,
+				      unsigned long a0, unsigned long a1,
+				      unsigned long a2, unsigned long a3,
+				      int op_64_bit);
 int kvm_emulate_hypercall(struct kvm_vcpu *vcpu);
 
 int kvm_mmu_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa, u64 error_code,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1b10f54c8acf..94416992868b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9731,26 +9731,15 @@ static int complete_hypercall_exit(struct kvm_vcpu *vcpu)
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
@@ -9759,11 +9748,6 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
 		a3 &= 0xFFFFFFFF;
 	}
 
-	if (static_call(kvm_x86_get_cpl)(vcpu) != 0) {
-		ret = -KVM_EPERM;
-		goto out;
-	}
-
 	ret = -KVM_ENOSYS;
 
 	switch (nr) {
@@ -9822,6 +9806,34 @@ int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
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
+	op_64_bit = is_64_bit_hypercall(vcpu);
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

