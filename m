Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F46A24953B
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 08:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgHSGrw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 02:47:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:36140 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727073AbgHSGrq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Aug 2020 02:47:46 -0400
IronPort-SDR: TvRUC8zywBbtAr21VekCpp5HD52CuCFokSRn/weJlmy8I78BkNGwgPf0vindC8l0QCy1wEiNFB
 BQPG6MweMVxA==
X-IronPort-AV: E=McAfee;i="6000,8403,9717"; a="142873205"
X-IronPort-AV: E=Sophos;i="5.76,330,1592895600"; 
   d="scan'208";a="142873205"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2020 23:47:33 -0700
IronPort-SDR: 58a6xx6FEMbLzrjrfMBBUMYU1daOkqD/lqtSUYEw9ti1LoZpRTLXkJWfpt8l/1sYrKQwEZNPeQ
 C11kjIhJH+Sg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,330,1592895600"; 
   d="scan'208";a="310679303"
Received: from lxy-dell.sh.intel.com ([10.239.159.21])
  by orsmga002.jf.intel.com with ESMTP; 18 Aug 2020 23:47:30 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>, peterz@infradead.org,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v10 6/9] KVM: VMX: Enable MSR TEST_CTRL for guest
Date:   Wed, 19 Aug 2020 14:47:04 +0800
Message-Id: <20200819064707.1033569-7-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <20200819064707.1033569-1-xiaoyao.li@intel.com>
References: <20200819064707.1033569-1-xiaoyao.li@intel.com>
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
index 46ba2e03a892..e113c9171bcc 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1832,6 +1832,9 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	u32 index;
 
 	switch (msr_info->index) {
+	case MSR_TEST_CTRL:
+		msr_info->data = 0;
+		break;
 #ifdef CONFIG_X86_64
 	case MSR_FS_BASE:
 		msr_info->data = vmcs_readl(GUEST_FS_BASE);
@@ -1995,6 +1998,11 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
2.18.4

