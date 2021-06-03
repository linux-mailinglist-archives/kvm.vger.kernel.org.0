Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C58839AA0E
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 20:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbhFCSfq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 14:35:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:51172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229817AbhFCSfo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 14:35:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B51D613DC;
        Thu,  3 Jun 2021 18:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622745240;
        bh=8rzvn6RTUZ+Fwle5zCQTw7SSxwCeA8VzLr8wda4TNzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=knMwvqEDfg1TqKq+8mJzto8ZkP9NHA83kO8aFVRApvuOlPy9xFn72QrTIAgylo6Ma
         3v6ZqrpoCULuBEn8DmxDjf1InP1TggNgxD1zfvlh8Om1ATNdLqijRLa+F4MVdQsQEC
         d1Dud6Nte9sawAg+6/fFb37Y2xITBxlb7HbBFoZi/ouDnQglK6DIiH4fs2oAmIFIQ4
         KYlAhqnNYpCVRKpKMJrwt0K02poML1UyEJASdpEsCJe5m9sdWJiY9UcOl5iaJn3U/d
         899ah8ctyb0RvqKAFoXKS0tbkSuiTzr+JVK4q7wbodfJ+ZkAetwAykwg9/9knRGtUK
         8alKJHF/yy/2A==
From:   Will Deacon <will@kernel.org>
To:     kvmarm@lists.cs.columbia.edu
Cc:     Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fuad Tabba <tabba@google.com>,
        Quentin Perret <qperret@google.com>,
        Sean Christopherson <seanjc@google.com>,
        David Brazdil <dbrazdil@google.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/4] KVM: arm64: Ignore 'kvm-arm.mode=protected' when using VHE
Date:   Thu,  3 Jun 2021 19:33:44 +0100
Message-Id: <20210603183347.1695-2-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210603183347.1695-1-will@kernel.org>
References: <20210603183347.1695-1-will@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ignore 'kvm-arm.mode=protected' when using VHE so that kvm_get_mode()
only returns KVM_MODE_PROTECTED on systems where the feature is available.

Cc: David Brazdil <dbrazdil@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 Documentation/admin-guide/kernel-parameters.txt |  1 -
 arch/arm64/kernel/cpufeature.c                  | 10 +---------
 arch/arm64/kvm/arm.c                            |  6 +++++-
 3 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index cb89dbdedc46..e85dbdf1ee8e 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2300,7 +2300,6 @@
 
 			protected: nVHE-based mode with support for guests whose
 				   state is kept private from the host.
-				   Not valid if the kernel is running in EL2.
 
 			Defaults to VHE/nVHE based on hardware support.
 
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index efed2830d141..dc1f2e747828 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1773,15 +1773,7 @@ static void cpu_enable_mte(struct arm64_cpu_capabilities const *cap)
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
index 1cb39c0803a4..8d5e23198dfd 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2121,7 +2121,11 @@ static int __init early_kvm_mode_cfg(char *arg)
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
2.32.0.rc0.204.g9fa02ecfa5-goog

