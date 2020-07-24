Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42A1D22CA90
	for <lists+kvm@lfdr.de>; Fri, 24 Jul 2020 18:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbgGXQD7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jul 2020 12:03:59 -0400
Received: from 8bytes.org ([81.169.241.247]:59226 "EHLO theia.8bytes.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726704AbgGXQD7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jul 2020 12:03:59 -0400
Received: from cap.home.8bytes.org (p5b006776.dip0.t-ipconnect.de [91.0.103.118])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by theia.8bytes.org (Postfix) with ESMTPSA id 246337AA;
        Fri, 24 Jul 2020 18:03:57 +0200 (CEST)
From:   Joerg Roedel <joro@8bytes.org>
To:     x86@kernel.org
Cc:     Joerg Roedel <joro@8bytes.org>, Joerg Roedel <jroedel@suse.de>,
        hpa@zytor.com, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
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
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v5 02/75] KVM: SVM: Add GHCB Accessor functions
Date:   Fri, 24 Jul 2020 18:02:23 +0200
Message-Id: <20200724160336.5435-3-joro@8bytes.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200724160336.5435-1-joro@8bytes.org>
References: <20200724160336.5435-1-joro@8bytes.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
2.27.0

