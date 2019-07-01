Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 268B42A9DF
	for <lists+kvm@lfdr.de>; Sun, 26 May 2019 15:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbfEZNc4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 26 May 2019 09:32:56 -0400
Received: from mga14.intel.com ([192.55.52.115]:7991 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726953AbfEZNcz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 26 May 2019 09:32:55 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 May 2019 06:32:54 -0700
X-ExtLoop1: 1
Received: from likexu-e5-2699-v4.sh.intel.com ([10.239.48.178])
  by FMSMGA003.fm.intel.com with ESMTP; 26 May 2019 06:32:53 -0700
From:   Like Xu <like.xu@linux.intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: [RESEND PATCH v3] KVM: x86: Add Intel CPUID.1F cpuid emulation support
Date:   Sun, 26 May 2019 21:30:52 +0800
Message-Id: <20190526133052.4069-1-like.xu@linux.intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add support to expose Intel V2 Extended Topology Enumeration Leaf for
some new systems with multiple software-visible die within each package.

Per Intel's SDM, when CPUID executes with EAX set to 1FH, the processor
returns information about extended topology enumeration data. Software
must detect the presence of CPUID leaf 1FH by verifying (a) the highest
leaf index supported by CPUID is >= 1FH, and (b) CPUID.1FH:EBX[15:0]
reports a non-zero value.

Co-developed-by: Xiaoyao Li <xiaoyao.li@linux.intel.com>
Signed-off-by: Xiaoyao Li <xiaoyao.li@linux.intel.com>
Signed-off-by: Like Xu <like.xu@linux.intel.com>
Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
==changelog==
v3:
- Refine commit message and comment

v2: https://lkml.org/lkml/2019/4/25/1246

- Apply cpuid.1f check rule on Intel SDM page 3-222 Vol.2A
- Add comment to handle 0x1f anf 0xb in common code
- Reduce check time in a descending-break style

v1: https://lkml.org/lkml/2019/4/22/28

 arch/x86/kvm/cpuid.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 80a642a0143d..f9b41f0103b3 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -426,6 +426,11 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 
 	switch (function) {
 	case 0:
+		/* Check if the cpuid leaf 0x1f is actually implemented */
+		if (entry->eax >= 0x1f && (cpuid_ebx(0x1f) & 0x0000ffff)) {
+			entry->eax = 0x1f;
+			break;
+		}
 		entry->eax = min(entry->eax, (u32)(f_intel_pt ? 0x14 : 0xd));
 		break;
 	case 1:
@@ -545,7 +550,11 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
 		entry->edx = edx.full;
 		break;
 	}
-	/* function 0xb has additional index. */
+	/*
+	 * Per Intel's SDM, 0x1f is a superset of 0xb, thus they can be handled
+	 * by common code.
+	 */
+	case 0x1f:
 	case 0xb: {
 		int i, level_type;
 
-- 
2.21.0

