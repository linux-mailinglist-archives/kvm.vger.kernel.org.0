Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC6E4B1756
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2019 04:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728277AbfIMCrA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Sep 2019 22:47:00 -0400
Received: from mga07.intel.com ([134.134.136.100]:58605 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726781AbfIMCqP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Sep 2019 22:46:15 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Sep 2019 19:46:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; 
   d="scan'208";a="176159513"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 12 Sep 2019 19:46:13 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        James Harvey <jamespharvey20@gmail.com>,
        Alex Willamson <alex.williamson@redhat.com>
Subject: [PATCH 04/11] KVM: x86/mmu: Revert "Revert "KVM: MMU: show mmu_valid_gen in shadow page related tracepoints""
Date:   Thu, 12 Sep 2019 19:46:05 -0700
Message-Id: <20190913024612.28392-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190913024612.28392-1-sean.j.christopherson@intel.com>
References: <20190913024612.28392-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that the fast invalidate mechanism has been reintroduced, restore
tracing of the generation number in shadow page tracepoints.

This reverts commit b59c4830ca185ba0e9f9e046fb1cd10a4a92627a.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kvm/mmutrace.h | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/mmutrace.h b/arch/x86/kvm/mmutrace.h
index d8001b4bca05..e9832b5ec53c 100644
--- a/arch/x86/kvm/mmutrace.h
+++ b/arch/x86/kvm/mmutrace.h
@@ -8,16 +8,18 @@
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM kvmmmu
 
-#define KVM_MMU_PAGE_FIELDS \
-	__field(__u64, gfn) \
-	__field(__u32, role) \
-	__field(__u32, root_count) \
+#define KVM_MMU_PAGE_FIELDS			\
+	__field(unsigned long, mmu_valid_gen)	\
+	__field(__u64, gfn)			\
+	__field(__u32, role)			\
+	__field(__u32, root_count)		\
 	__field(bool, unsync)
 
-#define KVM_MMU_PAGE_ASSIGN(sp)			     \
-	__entry->gfn = sp->gfn;			     \
-	__entry->role = sp->role.word;		     \
-	__entry->root_count = sp->root_count;        \
+#define KVM_MMU_PAGE_ASSIGN(sp)				\
+	__entry->mmu_valid_gen = sp->mmu_valid_gen;	\
+	__entry->gfn = sp->gfn;				\
+	__entry->role = sp->role.word;			\
+	__entry->root_count = sp->root_count;		\
 	__entry->unsync = sp->unsync;
 
 #define KVM_MMU_PAGE_PRINTK() ({				        \
@@ -29,8 +31,9 @@
 								        \
 	role.word = __entry->role;					\
 									\
-	trace_seq_printf(p, "sp gfn %llx l%u %u-byte q%u%s %s%s"	\
+	trace_seq_printf(p, "sp gen %lx gfn %llx l%u %u-byte q%u%s %s%s"\
 			 " %snxe %sad root %u %s%c",			\
+			 __entry->mmu_valid_gen,			\
 			 __entry->gfn, role.level,			\
 			 role.gpte_is_8_bytes ? 8 : 4,			\
 			 role.quadrant,					\
-- 
2.22.0

