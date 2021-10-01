Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E831941F2A4
	for <lists+kvm@lfdr.de>; Fri,  1 Oct 2021 19:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353908AbhJARH5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Oct 2021 13:07:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:60424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231550AbhJARHz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Oct 2021 13:07:55 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DC9561AD1;
        Fri,  1 Oct 2021 17:06:11 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1mWLz7-00EF74-O9; Fri, 01 Oct 2021 18:06:09 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc:     James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com, David Brazdil <dbrazdil@google.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH v2] KVM: arm64: Allow KVM to be disabled from the command line
Date:   Fri,  1 Oct 2021 18:05:53 +0100
Message-Id: <20211001170553.3062988-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com, dbrazdil@google.com, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Although KVM can be compiled out of the kernel, it cannot be disabled
at runtime. Allow this possibility by introducing a new mode that
will prevent KVM from initialising.

This is useful in the (limited) circumstances where you don't want
KVM to be available (what is wrong with you?), or when you want
to install another hypervisor instead (good luck with that).

Reviewed-by: David Brazdil <dbrazdil@google.com>
Acked-by: Will Deacon <will@kernel.org>
Acked-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---

Notes:
    v2: Dropped the id_aa64mmfr1_vh=0 setting so that KVM can be disabled
        and yet stay in VHE mode on platforms that require it.
        I kept the AB/RB's, but please shout if you disagree!

 Documentation/admin-guide/kernel-parameters.txt |  2 ++
 arch/arm64/include/asm/kvm_host.h               |  1 +
 arch/arm64/kvm/arm.c                            | 14 +++++++++++++-
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 91ba391f9b32..f268731a3d4d 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2365,6 +2365,8 @@
 	kvm-arm.mode=
 			[KVM,ARM] Select one of KVM/arm64's modes of operation.
 
+			none: Forcefully disable KVM.
+
 			nvhe: Standard nVHE-based mode, without support for
 			      protected guests.
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f8be56d5342b..019490c67976 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -58,6 +58,7 @@
 enum kvm_mode {
 	KVM_MODE_DEFAULT,
 	KVM_MODE_PROTECTED,
+	KVM_MODE_NONE,
 };
 enum kvm_mode kvm_get_mode(void);
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index fe102cd2e518..658171231af9 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2064,6 +2064,11 @@ int kvm_arch_init(void *opaque)
 		return -ENODEV;
 	}
 
+	if (kvm_get_mode() == KVM_MODE_NONE) {
+		kvm_info("KVM disabled from command line\n");
+		return -ENODEV;
+	}
+
 	in_hyp_mode = is_kernel_in_hyp_mode();
 
 	if (cpus_have_final_cap(ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE) ||
@@ -2137,8 +2142,15 @@ static int __init early_kvm_mode_cfg(char *arg)
 		return 0;
 	}
 
-	if (strcmp(arg, "nvhe") == 0 && !WARN_ON(is_kernel_in_hyp_mode()))
+	if (strcmp(arg, "nvhe") == 0 && !WARN_ON(is_kernel_in_hyp_mode())) {
+		kvm_mode = KVM_MODE_DEFAULT;
 		return 0;
+	}
+
+	if (strcmp(arg, "none") == 0) {
+		kvm_mode = KVM_MODE_NONE;
+		return 0;
+	}
 
 	return -EINVAL;
 }
-- 
2.30.2

