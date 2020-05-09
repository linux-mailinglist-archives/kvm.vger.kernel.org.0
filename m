Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0198F1CBCB7
	for <lists+kvm@lfdr.de>; Sat,  9 May 2020 05:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728808AbgEIDED (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 May 2020 23:04:03 -0400
Received: from mga12.intel.com ([192.55.52.136]:55127 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728798AbgEIDED (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 May 2020 23:04:03 -0400
IronPort-SDR: zpxbVdBpw8e8kSWVRQWMknKA2/MVQoDuzvZ7GxmpbkGbgg86Mn4tpWicKhN/hF8i3ca0GJBQAX
 zl1IZtoCacdA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2020 20:04:02 -0700
IronPort-SDR: nf6FiCRLs+sAUC5e2D9mMEaed8nZIYM7FPzF2WXVHDy4z1D8XnLWHYtOv0vetpW/06MEkCgmR0
 ei9dnBUfJYCw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,370,1583222400"; 
   d="scan'208";a="408311087"
Received: from lxy-dell.sh.intel.com ([10.239.159.21])
  by orsmga004.jf.intel.com with ESMTP; 08 May 2020 20:03:55 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>, peterz@infradead.org,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v9 6/8] KVM: VMX: Enable MSR TEST_CTRL for guest
Date:   Sat,  9 May 2020 19:05:40 +0800
Message-Id: <20200509110542.8159-7-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.18.2
In-Reply-To: <20200509110542.8159-1-xiaoyao.li@intel.com>
References: <20200509110542.8159-1-xiaoyao.li@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Unconditionally allow the guest to read and zero-write MSR TEST_CTRL.

This matches the fact that most Intel CPUs support MSR TEST_CTRL, and
it also alleviates the effort to handle wrmsr/rdmsr when split lock
detection is exposed to the guest in a future patch.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
---
 arch/x86/kvm/vmx/vmx.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c2c6335a998c..dbec38ad5035 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1789,6 +1789,9 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	u32 index;
 
 	switch (msr_info->index) {
+	case MSR_TEST_CTRL:
+		msr_info->data = 0;
+		break;
 #ifdef CONFIG_X86_64
 	case MSR_FS_BASE:
 		msr_info->data = vmcs_readl(GUEST_FS_BASE);
@@ -1942,6 +1945,11 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	u32 index;
 
 	switch (msr_index) {
+	case MSR_TEST_CTRL:
+		if (data)
+			return 1;
+
+		break;
 	case MSR_EFER:
 		ret = kvm_set_msr_common(vcpu, msr_info);
 		break;
-- 
2.18.2

