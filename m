Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9B60447FB1
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 13:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239688AbhKHMsZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 07:48:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239766AbhKHMsD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 07:48:03 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC77EC061205;
        Mon,  8 Nov 2021 04:45:18 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id o4so1818104pfp.13;
        Mon, 08 Nov 2021 04:45:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=A67VzkmpsIFHrMc7f+Wcqjp1h4M3PhJUyuzd6es3l8k=;
        b=ior0MqkaAdyC8qtt4GdN3bBd5naygoiB1I5aUn42nUjZf+//ZMNgD4wkZjz3LkIX5t
         Em5k2wmYSIeBFaBawG5yyh3K+ttB1S3+Tu4lMrybruJdbMLVS0i4wVR0A++h5LVD/x/q
         g1NEZXGjrw9e974izCJYxAsW3+F9uEEQlnP0NxIwRsajB3MHDs1BiricEaCkVTDWbGwA
         HdpgqPVUJW97Gab3DDMd2eOaaQYJ622BfOakQ5HW5Cj6gQK1YM2ZqPis+Nr80suZkRI1
         6UU+NMovtTEJ3UKYNGlwKBSOEPFa3Fk2dHMQec2d96H3tiAWQD1tNsfBRjNIo6lM2v5H
         USGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=A67VzkmpsIFHrMc7f+Wcqjp1h4M3PhJUyuzd6es3l8k=;
        b=kGBT6TKzJkaAnzz5qVCYT901HNzyrd6Ed/qrQlDHzBA2Mkz0PA8lXckcpw9FEAT5ad
         YeS3e9v0Xo4fK5honVtXOVlQs9oq/g+wey7eQ4A7kgMDKCJ7y831OmrXtnOaFo0vhHCz
         gjT13X9SOjboe2xpG7uIBfGrzBmB33jyVIFdhu7eTVMKLbytpar2HaqOjTVxDWuxFoNt
         ufai7sSpKICY5yle5mHvvtB4fpa0jDhrtZq2Wu+SH/HUnHkphZ1xmNCRy3nARFFGPwHp
         ln9F1fPlShtbV5sB5b/7AzfcKxbUThsTjkPsAnrzKWct+U9yO8fx468sKQB91QllRQq3
         uC0A==
X-Gm-Message-State: AOAM533DemuEaqcez63mQPfaTTA7gUTtwZDg4wIzLzoGtttEeFxzPj5U
        3wVMM/GPsyo3iUGS32b8dY1LkSkx2xk=
X-Google-Smtp-Source: ABdhPJyrCaHCoYJa/M4qW3UJPuMmHCWK9221dY7LSGNAk5BYlEYMpTA+Uuyd/R1XdMbfTKqgH7ZpXg==
X-Received: by 2002:a63:6a43:: with SMTP id f64mr88271pgc.393.1636375518181;
        Mon, 08 Nov 2021 04:45:18 -0800 (PST)
Received: from localhost ([47.88.60.64])
        by smtp.gmail.com with ESMTPSA id z30sm5607212pfg.30.2021.11.08.04.45.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Nov 2021 04:45:17 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 12/15] KVM: VMX: Reset the bits that are meaningful to be reset in vmx_register_cache_reset()
Date:   Mon,  8 Nov 2021 20:44:04 +0800
Message-Id: <20211108124407.12187-13-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20211108124407.12187-1-jiangshanlai@gmail.com>
References: <20211108124407.12187-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

Add meaningful bits as VMX_REGS_AVAIL_SET and VMX_REGS_DIRTY_SET.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
---
 arch/x86/kvm/vmx/vmx.h | 37 +++++++++++++++++++++++++++----------
 1 file changed, 27 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index e7db42e3b0ce..465aa415c3cb 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -437,16 +437,33 @@ BUILD_CONTROLS_SHADOW(secondary_exec, SECONDARY_VM_EXEC_CONTROL)
 
 static inline void vmx_register_cache_reset(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.regs_avail = ~((1 << VCPU_REGS_RIP) | (1 << VCPU_REGS_RSP)
-				  | (1 << VCPU_EXREG_RFLAGS)
-				  | (1 << VCPU_EXREG_PDPTR)
-				  | (1 << VCPU_EXREG_SEGMENTS)
-				  | (1 << VCPU_EXREG_CR0)
-				  | (1 << VCPU_EXREG_CR3)
-				  | (1 << VCPU_EXREG_CR4)
-				  | (1 << VCPU_EXREG_EXIT_INFO_1)
-				  | (1 << VCPU_EXREG_EXIT_INFO_2));
-	vcpu->arch.regs_dirty = 0;
+/*
+ * VMX_REGS_AVAIL_SET - The set of registers that will be updated in cache on
+ *			demand.  Other registers not listed here are synced to
+ *			the cache immediately after VM-Exit.
+ *
+ * VMX_REGS_DIRTY_SET - The set of registers that might be outdated in
+ *			architecture. Other registers not listed here are synced
+ *			to the architecture immediately when modifying.
+ */
+#define VMX_REGS_AVAIL_SET	((1 << VCPU_REGS_RIP) |\
+				(1 << VCPU_REGS_RSP) |\
+				(1 << VCPU_EXREG_RFLAGS) |\
+				(1 << VCPU_EXREG_PDPTR) |\
+				(1 << VCPU_EXREG_SEGMENTS) |\
+				(1 << VCPU_EXREG_CR0) |\
+				(1 << VCPU_EXREG_CR3) |\
+				(1 << VCPU_EXREG_CR4) |\
+				(1 << VCPU_EXREG_EXIT_INFO_1) |\
+				(1 << VCPU_EXREG_EXIT_INFO_2))
+
+#define VMX_REGS_DIRTY_SET	((1 << VCPU_REGS_RIP) |\
+				(1 << VCPU_REGS_RSP) |\
+				(1 << VCPU_EXREG_PDPTR) |\
+				(1 << VCPU_EXREG_CR3))
+
+	vcpu->arch.regs_avail &= ~VMX_REGS_AVAIL_SET;
+	vcpu->arch.regs_dirty &= ~VMX_REGS_DIRTY_SET;
 }
 
 static inline struct kvm_vmx *to_kvm_vmx(struct kvm *kvm)
-- 
2.19.1.6.gb485710b

