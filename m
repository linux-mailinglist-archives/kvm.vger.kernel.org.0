Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7A61914BC
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 16:38:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727675AbgCXPiF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 11:38:05 -0400
Received: from mga05.intel.com ([192.55.52.43]:40198 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728705AbgCXPhg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 11:37:36 -0400
IronPort-SDR: z0oWzUUpCpKaPzswDP7v058joYzC2gr94AQOU7YcSrP/J1QXqyfYuyXeuki1lb8E5QuvuGVk6p
 YzRVWzbiJHXA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2020 08:37:34 -0700
IronPort-SDR: Myib4pD43/1N0mjq6AfrZ5DaurCVmr9ZfbGs812H6Ub1AlmwTXbgc8ON2PiJJNWSObnPRvgVMV
 TnI171lgtaQg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,300,1580803200"; 
   d="scan'208";a="393319768"
Received: from lxy-clx-4s.sh.intel.com ([10.239.43.39])
  by orsmga004.jf.intel.com with ESMTP; 24 Mar 2020 08:37:30 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v6 7/8] kvm: vmx: Enable MSR_TEST_CTRL for intel guest
Date:   Tue, 24 Mar 2020 23:18:58 +0800
Message-Id: <20200324151859.31068-8-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200324151859.31068-1-xiaoyao.li@intel.com>
References: <20200324151859.31068-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Only enabling the read and write zero of MSR_TEST_CTRL. This makes
MSR_TEST_CTRL always available for intel guest, but guset cannot write any
value to it except zero.

This matches the truth that most Intel CPUs support MSR_TEST_CTRL, and
it also alleviates the effort to handle wrmsr/rdmsr when exposing split
lock detect to guest in the following patch.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 10 ++++++++++
 arch/x86/kvm/vmx/vmx.h |  1 +
 2 files changed, 11 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 300e1e149372..a302027f7e56 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1820,6 +1820,9 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	u32 index;
 
 	switch (msr_info->index) {
+	case MSR_TEST_CTRL:
+		msr_info->data = vmx->msr_test_ctrl;
+		break;
 #ifdef CONFIG_X86_64
 	case MSR_FS_BASE:
 		msr_info->data = vmcs_readl(GUEST_FS_BASE);
@@ -1973,6 +1976,12 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	u32 index;
 
 	switch (msr_index) {
+	case MSR_TEST_CTRL:
+		if (data)
+			return 1;
+
+		vmx->msr_test_ctrl = data;
+		break;
 	case MSR_EFER:
 		ret = kvm_set_msr_common(vcpu, msr_info);
 		break;
@@ -4283,6 +4292,7 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 
 	vmx->rmode.vm86_active = 0;
 	vmx->spec_ctrl = 0;
+	vmx->msr_test_ctrl = 0;
 
 	vmx->msr_ia32_umwait_control = 0;
 
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index be93d597306c..7ef9cc085188 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -224,6 +224,7 @@ struct vcpu_vmx {
 #endif
 
 	u64		      spec_ctrl;
+	u64		      msr_test_ctrl;
 	u32		      msr_ia32_umwait_control;
 
 	u32 secondary_exec_control;
-- 
2.20.1

