Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E65F42E499
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 01:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234380AbhJNXLq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 19:11:46 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:45622 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234326AbhJNXLh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 19:11:37 -0400
Message-ID: <20211014230739.126107370@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634252970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=QVaekX9bXV3d6X1DWoFzjhPj7QWVsMVJXuCognxNjoU=;
        b=AMsMNFqGhXraF4N1pYoEZhBNpOaOIApNa2/55yFVeTvbPHdjXcxmUx6LjX4A/6+qrIVfnB
        E6tMC5OCIFE5oYAuoUfAsqIitCqrRLWX5A/1SsnUsKuZt4qvyCDiDEMxExjXJ59QLCbF6N
        f4J5y5Cpxcb5r84aOJy/ML0gzIgXKHom/GwdafmWoEjX8Fo8CHbdPhxra2AoisazvQTYEN
        sNPEqJF+WWtuHjxye7DEIm/iL818fZ279Bhd5JTsdDVazaCUurjuVSqx9bsmYrQDM0RMtG
        5Ncm8X2IQZNb1Pts1RIRMN5YElgktzK4qxoqNJ2BpvmBGdB9Igj+A97hW81pWw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634252970;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=QVaekX9bXV3d6X1DWoFzjhPj7QWVsMVJXuCognxNjoU=;
        b=ZVwuDUAKPdx/TicDk1bOeye6fC4eTCFnvXKRw9WG6Ut589rPXm2u2wl98mCHvfx+s0aTs5
        eiBf+zGdgickiSAw==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Chang S. Bae" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: [patch 1/8] x86/fpu: Provide struct fpu_config
References: <20211014225711.615197738@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 15 Oct 2021 01:09:29 +0200 (CEST)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Provide a struct to store information about the maximum supported and the
default feature set and buffer sizes for both user and kernel space.

This allows quick retrieval of this information for the upcoming support
for dynamically enabled features.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/fpu/types.h |   39 +++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/fpu/core.c       |    4 ++++
 2 files changed, 43 insertions(+)

--- a/arch/x86/include/asm/fpu/types.h
+++ b/arch/x86/include/asm/fpu/types.h
@@ -378,4 +378,43 @@ struct fpu {
 	 */
 };
 
+/*
+ * FPU state configuration data. Initialized at boot time. Read only after init.
+ */
+struct fpu_state_config {
+	/*
+	 * @max_size:
+	 *
+	 * The maximum size of the register state buffer. Includes all
+	 * supported features except independent managed features.
+	 */
+	unsigned int		max_size;
+	/*
+	 * @default_size:
+	 *
+	 * The default size of the register state buffer. Includes all
+	 * supported features except independent managed features and
+	 * features which have to be requested by user space before usage.
+	 */
+	unsigned int		default_size;
+	/*
+	 * @max_features:
+	 *
+	 * The maximum supported features bitmap. Does not include
+	 * independent managed features.
+	 */
+	u64 max_features;
+	/*
+	 * @default_features:
+	 *
+	 * The default supported features bitmap. Does not include
+	 * independent managed features and features which have to
+	 * be requested by user space before usage.
+	 */
+	u64 default_features;
+};
+
+/* FPU state configuration information */
+extern struct fpu_state_config fpu_kernel_cfg, fpu_user_cfg;
+
 #endif /* _ASM_X86_FPU_H */
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -25,6 +25,10 @@
 #define CREATE_TRACE_POINTS
 #include <asm/trace/fpu.h>
 
+/* The FPU state configuration data for kernel and user space */
+struct fpu_state_config	fpu_kernel_cfg __ro_after_init;
+struct fpu_state_config fpu_user_cfg __ro_after_init;
+
 /*
  * Represents the initial FPU state. It's mostly (but not completely) zeroes,
  * depending on the FPU hardware format:

