Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A52F02335C8
	for <lists+kvm@lfdr.de>; Thu, 30 Jul 2020 17:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729797AbgG3Pnq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jul 2020 11:43:46 -0400
Received: from 8bytes.org ([81.169.241.247]:34112 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728286AbgG3Pnq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jul 2020 11:43:46 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id CBEB99CE; Thu, 30 Jul 2020 17:43:44 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH v2 3/4] KVM: SVM: Add GHCB Accessor functions
Date:   Thu, 30 Jul 2020 17:43:39 +0200
Message-Id: <20200730154340.14021-4-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200730154340.14021-1-joro@8bytes.org>
References: <20200730154340.14021-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Building a correct GHCB for the hypervisor requires setting valid bits
in the GHCB. Simplify that process by providing accessor functions to
set values and to update the valid bitmap and to check the valid bitmap
in KVM.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/svm.h | 46 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 9a3e0b802716..8744817358bf 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -341,4 +341,50 @@ struct __attribute__ ((__packed__)) vmcb {
 
 #define SVM_CR0_SELECTIVE_MASK (X86_CR0_TS | X86_CR0_MP)
 
+/* GHCB Accessor functions */
+
+#define GHB_BITMAP_IDX(field)								\
+        (offsetof(struct vmcb_save_area, field) / sizeof(u64))
+
+#define GHCB_SET_VALID(ghcb, field)							\
+	__set_bit(GHB_BITMAP_IDX(field), (unsigned long *)&(ghcb)->save.valid_bitmap);	\
+
+#define DEFINE_GHCB_ACCESSORS(field)							\
+	static inline bool ghcb_##field##_is_valid(const struct ghcb *ghcb)		\
+	{										\
+		int idx = offsetof(struct vmcb_save_area, field) / sizeof(u64);		\
+		return test_bit(idx, (unsigned long *)&(ghcb)->save.valid_bitmap);	\
+	}										\
+											\
+	static inline void								\
+	ghcb_set_##field(struct ghcb *ghcb, u64 value)					\
+	{										\
+		GHCB_SET_VALID(ghcb, field)						\
+		ghcb->save.field = value;						\
+	}
+
+DEFINE_GHCB_ACCESSORS(cpl)
+DEFINE_GHCB_ACCESSORS(rip)
+DEFINE_GHCB_ACCESSORS(rsp)
+DEFINE_GHCB_ACCESSORS(rax)
+DEFINE_GHCB_ACCESSORS(rcx)
+DEFINE_GHCB_ACCESSORS(rdx)
+DEFINE_GHCB_ACCESSORS(rbx)
+DEFINE_GHCB_ACCESSORS(rbp)
+DEFINE_GHCB_ACCESSORS(rsi)
+DEFINE_GHCB_ACCESSORS(rdi)
+DEFINE_GHCB_ACCESSORS(r8)
+DEFINE_GHCB_ACCESSORS(r9)
+DEFINE_GHCB_ACCESSORS(r10)
+DEFINE_GHCB_ACCESSORS(r11)
+DEFINE_GHCB_ACCESSORS(r12)
+DEFINE_GHCB_ACCESSORS(r13)
+DEFINE_GHCB_ACCESSORS(r14)
+DEFINE_GHCB_ACCESSORS(r15)
+DEFINE_GHCB_ACCESSORS(sw_exit_code)
+DEFINE_GHCB_ACCESSORS(sw_exit_info_1)
+DEFINE_GHCB_ACCESSORS(sw_exit_info_2)
+DEFINE_GHCB_ACCESSORS(sw_scratch)
+DEFINE_GHCB_ACCESSORS(xcr0)
+
 #endif
-- 
2.17.1

