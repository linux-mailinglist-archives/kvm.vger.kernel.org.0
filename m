Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51A5C1A73E4
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 08:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406140AbgDNGuf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 02:50:35 -0400
Received: from mga03.intel.com ([134.134.136.65]:58687 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406124AbgDNGu3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Apr 2020 02:50:29 -0400
IronPort-SDR: cHHVIXbmnJQ/NpaGsGVRUx8Xq/sLqN2wA9Dxale4yhwzCThU3U+una7ZqKUF38EULAKYJLxoz5
 gEdzUsavbhgg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2020 23:50:28 -0700
IronPort-SDR: NFCO0sF3wtqP7E5YlLAA9JDGose3LeqY/P+nXKAZMvepxhzkHcf16o3MHZ1gvdWHxc93Xpwby7
 u8bFvPBrXRqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,381,1580803200"; 
   d="scan'208";a="277158366"
Received: from lxy-clx-4s.sh.intel.com ([10.239.43.132])
  by fmsmga004.fm.intel.com with ESMTP; 13 Apr 2020 23:50:23 -0700
From:   Xiaoyao Li <xiaoyao.li@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: [PATCH v8 2/4] kvm: vmx: Enable MSR TEST_CTRL for guest
Date:   Tue, 14 Apr 2020 14:31:27 +0800
Message-Id: <20200414063129.133630-3-xiaoyao.li@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200414063129.133630-1-xiaoyao.li@intel.com>
References: <20200414063129.133630-1-xiaoyao.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index 83050977490c..ae394ed174cd 100644
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
2.20.1

