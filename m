Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C354185A3A
	for <lists+kvm@lfdr.de>; Sun, 15 Mar 2020 06:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbgCOFXY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Mar 2020 01:23:24 -0400
Received: from mga18.intel.com ([134.134.136.126]:47872 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727730AbgCOFXV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Mar 2020 01:23:21 -0400
IronPort-SDR: Sd0DPl26CYvLgBDyIisYuvhPGJHJg0ZmizQxT8Ew1WfJVzPPidFHxUpUCl4FdeGHI7vAwZhNG5
 ZHxM8DfRANew==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2020 22:23:21 -0700
IronPort-SDR: ZyTeTgLw9ULAIr4k9xGanbUfhvpwDfug6jF/P085ZYpRNLywqVbAfb4GqVucOfWJHpQSeowJTS
 PgD+EJxNwrtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,555,1574150400"; 
   d="scan'208";a="267194278"
Received: from lxy-clx-4s.sh.intel.com ([10.239.43.160])
  by fmsmga004.fm.intel.com with ESMTP; 14 Mar 2020 22:23:17 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        hpa@zytor.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
Cc:     Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v5 8/9] kvm: vmx: Enable MSR_TEST_CTRL for intel guest
Date:   Sun, 15 Mar 2020 13:05:16 +0800
Message-Id: <20200315050517.127446-9-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200315050517.127446-1-xiaoyao.li@intel.com>
References: <20200315050517.127446-1-xiaoyao.li@intel.com>
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
index 3fb132ad489d..107c873b23c2 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1831,6 +1831,9 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	u32 index;
 
 	switch (msr_info->index) {
+	case MSR_TEST_CTRL:
+		msr_info->data = vmx->msr_test_ctrl;
+		break;
 #ifdef CONFIG_X86_64
 	case MSR_FS_BASE:
 		msr_info->data = vmcs_readl(GUEST_FS_BASE);
@@ -1984,6 +1987,12 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
index e64da06c7009..f679453dcab8 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -225,6 +225,7 @@ struct vcpu_vmx {
 #endif
 
 	u64		      spec_ctrl;
+	u64		      msr_test_ctrl;
 	u32		      msr_ia32_umwait_control;
 
 	u32 secondary_exec_control;
-- 
2.20.1

