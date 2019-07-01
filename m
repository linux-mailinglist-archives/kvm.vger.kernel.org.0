Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E770041E37
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 09:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407629AbfFLHuD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 03:50:03 -0400
Received: from mga12.intel.com ([192.55.52.136]:41179 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405233AbfFLHuD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 03:50:03 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Jun 2019 00:50:03 -0700
X-ExtLoop1: 1
Received: from likexu-e5-2699-v4.sh.intel.com ([10.239.48.178])
  by orsmga003.jf.intel.com with ESMTP; 12 Jun 2019 00:50:00 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>,
        sean.j.christopherson@intel.com, xiaoyao.li@linux.intel.com,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5] KVM: x86: Add Intel CPUID.1F cpuid emulation support
Date:   Wed, 12 Jun 2019 15:47:38 +0800
Message-Id: <20190612074738.21309-1-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add support to expose Intel V2 Extended Topology Enumeration Leaf for
some new systems with multiple software-visible die within each package.

Because unimplemented and unexposed leaves should be explicitly reported
as zero, there is no need to limit cpuid.0.eax to the maximum value of
feature configuration but limit it to the highest leaf implemented in
the current code. A single clamping seems sufficient and cheaper.

Reported-by: kbuild test robot <lkp@intel.com>
Co-developed-by: Xiaoyao Li <xiaoyao.li@linux.intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@linux.intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>

---

==changelog==

v5:
- Fixed sparse warnings: ncompatible types in comparison expression

v4: https://lkml.org/lkml/2019/6/5/1029
- Limited cpuid.0.eax to the highest leaf implemented in KVM

v3: https://lkml.org/lkml/2019/5/26/64
- Refine commit message and comment

v2: https://lkml.org/lkml/2019/4/25/1246

- Apply cpuid.1f check rule on Intel SDM page 3-222 Vol.2A
- Add comment to handle 0x1f anf 0xb in common code
- Reduce check time in a descending-break style

v1: https://lkml.org/lkml/2019/4/22/28

---
 arch/x86/kvm/cpuid.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index e18a9f9f65b5..d0dafaecf05b 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -426,7 +426,8 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 
 	switch (function) {
 	case 0:
-		entry->eax = min(entry->eax, (u32)(f_intel_pt ? 0x14 : 0xd));
+		/* Limited to the highest leaf implemented in KVM. */
+		entry->eax = min(entry->eax, (u32)0x1f);
 		break;
 	case 1:
 		entry->edx &= kvm_cpuid_1_edx_x86_features;
@@ -546,7 +547,11 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 		entry->edx = edx.full;
 		break;
 	}
-	/* function 0xb has additional index. */
+	/*
+	 * Per Intel's SDM, the 0x1f is a superset of 0xb,
+	 * thus they can be handled by common code.
+	 */
+	case 0x1f:
 	case 0xb: {
 		int i, level_type;
 
-- 
2.21.0

