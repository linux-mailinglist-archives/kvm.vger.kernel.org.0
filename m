Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B78F1BC361
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 17:25:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728552AbgD1PY5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 11:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727875AbgD1PRq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Apr 2020 11:17:46 -0400
Received: from theia.8bytes.org (8bytes.org [IPv6:2a01:238:4383:600:38bc:a715:4b6d:a889])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6EA1C03C1AB;
        Tue, 28 Apr 2020 08:17:46 -0700 (PDT)
Received: by theia.8bytes.org (Postfix, from userid 1000)
        id 8AC1029C; Tue, 28 Apr 2020 17:17:42 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v3 02/75] KVM: SVM: Add GHCB Accessor functions
Date:   Tue, 28 Apr 2020 17:16:12 +0200
Message-Id: <20200428151725.31091-3-joro@8bytes.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200428151725.31091-1-joro@8bytes.org>
References: <20200428151725.31091-1-joro@8bytes.org>
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
index f36288c659b5..e4e9f6bacfaa 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -333,4 +333,65 @@ struct __attribute__ ((__packed__)) vmcb {
 
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

