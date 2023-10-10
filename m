Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B63E37BF615
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 10:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442937AbjJJIgJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 04:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442920AbjJJIfk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 04:35:40 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F868A9;
        Tue, 10 Oct 2023 01:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1696926937; x=1728462937;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8vd+meAVtjSRzVgDs7zTq2sHPQpNFGGV0ODScm1t1Vs=;
  b=jOep2cxSlCfUZJ8I8yRb5GqKeoLQ8S+dEodBghJaZTSA0I6/dKb9XBgV
   sSFFk8Z0qJ4sgnJGuOQpu0THcEQZz4Nv6qUw/qD9uXu6kYBobw1yqzAh0
   8vnQFQfuDPHwMt7rDitGD0On6MiNTVVZhUcUNf5iz+ZtprG4m6DjesRpb
   GM9FSPEZrcA4DUW27Fm1eh1N4KUsOVZMFUhqCs1giYDJvw6aJO3APjq08
   AXd+HXndIv9u5jVJm+eoTbaDBZWxchDW6nmFy/vsUJi5a6kLbWmIRfLr2
   DvDMhesyEh5owbDILiyXygA5SDvp/YlaNn36hD5jRpb9opMRkfxKtDN0u
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10858"; a="363689836"
X-IronPort-AV: E=Sophos;i="6.03,212,1694761200"; 
   d="scan'208";a="363689836"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2023 01:35:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10858"; a="1084687203"
X-IronPort-AV: E=Sophos;i="6.03,212,1694761200"; 
   d="scan'208";a="1084687203"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2023 01:35:35 -0700
From:   isaku.yamahata@intel.com
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@intel.com, isaku.yamahata@gmail.com,
        Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-coco@lists.linux.dev, Chao Peng <chao.p.peng@linux.intel.com>
Subject: [PATCH 09/12] KVM: X86: Add debugfs to inject machine check on VM exit
Date:   Tue, 10 Oct 2023 01:35:17 -0700
Message-Id: <47c8a177d81762e0561fc47cc274076de901edbf.1696926843.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1696926843.git.isaku.yamahata@intel.com>
References: <cover.1696926843.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Isaku Yamahata <isaku.yamahata@intel.com>

The KVM/x86 handles machine-check in the guest specially.  It sets up the
guest so that vcpu exits from running guests, checks the exit reason and,
manually raises the machine check by calling do_machine_check().

To test the KVM machine check execution path, KVM wants to inject the
machine check in the context of vcpu instead of the context of the process
of MCE injection.  Wire up the MCE injection framework for KVM to trigger
MCE in the vcpu context.  Add a kvm vcpu debugfs entry for an operator to
tell KVM to inject MCE.

The operation flow is as follows:
- Set notrigger to 1 to tell the x86 MCE injector to suppress it from
  injecting machine check.
  echo 1 > /sys/kernel/debug/mce-inject/notrigger
- Set MCE parameters via x86 MCE injector debugfs
  /sys/kernel/debug/mce-inject/{addr, bank, flags, mcgstatus, misc, status}
- Tell KVM to inject MCE
  echo 1 > /sys/kernel/debug/kvm/<pid>-<vm-fd>/vcpu<vcpuid>/mce-inject

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/debugfs.c          | 22 ++++++++++++++++++++++
 arch/x86/kvm/x86.c              | 14 ++++++++++++++
 3 files changed, 37 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 17715cb8731d..9286f3d02f30 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -113,6 +113,7 @@
 	KVM_ARCH_REQ_FLAGS(31, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_HV_TLB_FLUSH \
 	KVM_ARCH_REQ_FLAGS(32, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+#define KVM_REQ_MCE_INJECT		KVM_ARCH_REQ(33)
 
 #define CR0_RESERVED_BITS                                               \
 	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
diff --git a/arch/x86/kvm/debugfs.c b/arch/x86/kvm/debugfs.c
index ee8c4c3496ed..fee208f30400 100644
--- a/arch/x86/kvm/debugfs.c
+++ b/arch/x86/kvm/debugfs.c
@@ -56,6 +56,22 @@ static int vcpu_get_tsc_scaling_frac_bits(void *data, u64 *val)
 
 DEFINE_SIMPLE_ATTRIBUTE(vcpu_tsc_scaling_frac_fops, vcpu_get_tsc_scaling_frac_bits, NULL, "%llu\n");
 
+static int vcpu_mce_inject_set(void *data, u64 val)
+{
+	struct kvm_vcpu *vcpu = (struct kvm_vcpu *) data;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (val != 1)
+		return -EINVAL;
+	kvm_make_request(KVM_REQ_MCE_INJECT, vcpu);
+	kvm_vcpu_kick(vcpu);
+	return 0;
+}
+
+DEFINE_SIMPLE_ATTRIBUTE(vcpu_mce_inject_fops, NULL, vcpu_mce_inject_set, "%llx\n");
+
 void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu, struct dentry *debugfs_dentry)
 {
 	debugfs_create_file("guest_mode", 0444, debugfs_dentry, vcpu,
@@ -76,6 +92,12 @@ void kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu, struct dentry *debugfs_
 				    debugfs_dentry, vcpu,
 				    &vcpu_tsc_scaling_frac_fops);
 	}
+
+	if (IS_ENABLED(CONFIG_X86_MCE_INJECT) &&
+	    boot_cpu_has(X86_FEATURE_MCE) && boot_cpu_has(X86_FEATURE_MCA))
+		debugfs_create_file("mce-inject", 0200,
+				    debugfs_dentry, vcpu,
+				    &vcpu_mce_inject_fops);
 }
 
 /*
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9f18b06bbda6..e4c63ded4c9a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10496,6 +10496,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	fastpath_t exit_fastpath;
 
 	bool req_immediate_exit = false;
+	bool req_mce_inject = false;
 
 	if (kvm_request_pending(vcpu)) {
 		if (kvm_check_request(KVM_REQ_VM_DEAD, vcpu)) {
@@ -10642,6 +10643,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 		if (kvm_check_request(KVM_REQ_UPDATE_CPU_DIRTY_LOGGING, vcpu))
 			static_call(kvm_x86_update_cpu_dirty_logging)(vcpu);
+
+		req_mce_inject = kvm_check_request(KVM_REQ_MCE_INJECT, vcpu);
 	}
 
 	if (kvm_check_request(KVM_REQ_EVENT, vcpu) || req_int_win ||
@@ -10676,6 +10679,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		goto cancel_injection;
 	}
 
+	if (unlikely(req_mce_inject))
+		mce_inject_lock();
 	preempt_disable();
 
 	static_call(kvm_x86_prepare_switch_to_guest)(vcpu);
@@ -10721,6 +10726,10 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		smp_wmb();
 		local_irq_enable();
 		preempt_enable();
+		if (unlikely(req_mce_inject)) {
+			kvm_make_request(KVM_REQ_MCE_INJECT, vcpu);
+			mce_inject_unlock();
+		}
 		kvm_vcpu_srcu_read_lock(vcpu);
 		r = 1;
 		goto cancel_injection;
@@ -10814,6 +10823,11 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		fpu_sync_guest_vmexit_xfd_state();
 
 	static_call(kvm_x86_handle_exit_irqoff)(vcpu);
+	if (unlikely(req_mce_inject)) {
+		mce_call_atomic_injector_chain(smp_processor_id());
+		kvm_machine_check();
+		mce_inject_unlock();
+	}
 
 	if (vcpu->arch.guest_fpu.xfd_err)
 		wrmsrl(MSR_IA32_XFD_ERR, 0);
-- 
2.25.1

