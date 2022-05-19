Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6125E52D469
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239034AbiESNoY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230419AbiESNmq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:42:46 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE533CFCD
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 06:42:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9BE22CE2441
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 13:42:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AAEAC34119;
        Thu, 19 May 2022 13:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652967760;
        bh=xcVvqsHLiKii5TVw7ayvStaj1DRy3KpRJuyB7N0Jz0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZG/eePp/PWXECZvdHDH7DKHdJxX3dQjXjqg9wbFIsCi3gNfOfwYko+EvXS0zCQ2Px
         tyAWzxciMD+HUEqtyJgqSRCncVZxfcqIWeZWjEJVVdbwsBXkczZs06nVKYJhDOLEzZ
         w6MLdfM48ntbGr+x1yAb+tYilIgmYy6F/mUz1f4qUF/MB2GfoS9OKuv9fRflr28jbF
         kBA1KXBpwM0k9fSsvXcFWOOjSYIr38SVym8glE98/4pAQ5/W/chDZryR2ss+sRw1Vd
         j1aKjA3DWMUNHUWCMsm0gsdJcjR+AU57RXUXO8W6bRzJPrQvEhxhNlqRxr8ZGPDSjD
         qbxLUJHBg7DMQ==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oupton@google.com>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        David Brazdil <dbrazdil@google.com>
Subject: [PATCH 04/89] KVM: arm64: Ignore 'kvm-arm.mode=protected' when using VHE
Date:   Thu, 19 May 2022 14:40:39 +0100
Message-Id: <20220519134204.5379-5-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ignore 'kvm-arm.mode=protected' when using VHE so that kvm_get_mode()
only returns KVM_MODE_PROTECTED on systems where the feature is available.

Cc: David Brazdil <dbrazdil@google.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 Documentation/admin-guide/kernel-parameters.txt |  1 -
 arch/arm64/kernel/cpufeature.c                  | 10 +---------
 arch/arm64/kvm/arm.c                            |  6 +++++-
 3 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 3f1cc5e317ed..63a764ec7fec 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2438,7 +2438,6 @@
 
 			protected: nVHE-based mode with support for guests whose
 				   state is kept private from the host.
-				   Not valid if the kernel is running in EL2.
 
 			Defaults to VHE/nVHE based on hardware support. Setting
 			mode to "protected" will disable kexec and hibernation
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index d72c4b4d389c..1bbb7cfc76df 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1925,15 +1925,7 @@ static void cpu_enable_mte(struct arm64_cpu_capabilities const *cap)
 #ifdef CONFIG_KVM
 static bool is_kvm_protected_mode(const struct arm64_cpu_capabilities *entry, int __unused)
 {
-	if (kvm_get_mode() != KVM_MODE_PROTECTED)
-		return false;
-
-	if (is_kernel_in_hyp_mode()) {
-		pr_warn("Protected KVM not available with VHE\n");
-		return false;
-	}
-
-	return true;
+	return kvm_get_mode() == KVM_MODE_PROTECTED;
 }
 #endif /* CONFIG_KVM */
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 775b52871b51..7f8731306c2a 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2167,7 +2167,11 @@ static int __init early_kvm_mode_cfg(char *arg)
 		return -EINVAL;
 
 	if (strcmp(arg, "protected") == 0) {
-		kvm_mode = KVM_MODE_PROTECTED;
+		if (!is_kernel_in_hyp_mode())
+			kvm_mode = KVM_MODE_PROTECTED;
+		else
+			pr_warn_once("Protected KVM not available with VHE\n");
+
 		return 0;
 	}
 
-- 
2.36.1.124.g0e6072fb45-goog

