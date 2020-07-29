Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53B91231F37
	for <lists+kvm@lfdr.de>; Wed, 29 Jul 2020 15:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbgG2NWt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jul 2020 09:22:49 -0400
Received: from 8bytes.org ([81.169.241.247]:33846 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727031AbgG2NWr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jul 2020 09:22:47 -0400
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 85F8C76D; Wed, 29 Jul 2020 15:22:45 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 3/4] KVM: SVM: Add GHCB Accessor functions
Date:   Wed, 29 Jul 2020 15:22:33 +0200
Message-Id: <20200729132234.2346-4-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200729132234.2346-1-joro@8bytes.org>
References: <20200729132234.2346-1-joro@8bytes.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Building a correct GHCB for the hypervisor requires setting valid bits
in the GHCB. Simplify that process by providing accessor functions to
set values and to update the valid bitmap.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/svm.h | 61 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 9a3e0b802716..0420250b008b 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -341,4 +341,65 @@ struct __attribute__ ((__packed__)) vmcb {
 
 #define SVM_CR0_SELECTIVE_MASK (X86_CR0_TS | X86_CR0_MP)
 
+/* GHCB Accessor functions */
+
+#define DEFINE_GHCB_INDICES(field)					\
+	u16 idx = offsetof(struct vmcb_save_area, field) / 8;		\
+	u16 byte_idx  = idx / 8;					\
+	u16 bit_idx   = idx % 8;					\
+	BUILD_BUG_ON(byte_idx > ARRAY_SIZE(ghcb->save.valid_bitmap));
+
+#define GHCB_SET_VALID(ghcb, field)					\
+	{								\
+		DEFINE_GHCB_INDICES(field)				\
+		(ghcb)->save.valid_bitmap[byte_idx] |= BIT(bit_idx);	\
+	}
+
+#define DEFINE_GHCB_SETTER(field)					\
+	static inline void						\
+	ghcb_set_##field(struct ghcb *ghcb, u64 value)			\
+	{								\
+		GHCB_SET_VALID(ghcb, field)				\
+		(ghcb)->save.field = value;				\
+	}
+
+#define DEFINE_GHCB_ACCESSORS(field)					\
+	static inline bool ghcb_is_valid_##field(const struct ghcb *ghcb)	\
+	{								\
+		DEFINE_GHCB_INDICES(field)				\
+		return !!((ghcb)->save.valid_bitmap[byte_idx]		\
+						& BIT(bit_idx));	\
+	}								\
+									\
+	static inline void						\
+	ghcb_set_##field(struct ghcb *ghcb, u64 value)			\
+	{								\
+		GHCB_SET_VALID(ghcb, field)				\
+		(ghcb)->save.field = value;				\
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

