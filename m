Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50FF312E23
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 14:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbfECMqZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 08:46:25 -0400
Received: from foss.arm.com ([217.140.101.70]:60620 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727997AbfECMqZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 08:46:25 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A26C816A3;
        Fri,  3 May 2019 05:46:24 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6B2773F220;
        Fri,  3 May 2019 05:46:21 -0700 (PDT)
From:   Marc Zyngier <marc.zyngier@arm.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc:     =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Amit Daniel Kachhap <amit.kachhap@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Julien Grall <julien.grall@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Kristina Martsenko <kristina.martsenko@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "zhang . lei" <zhang.lei@jp.fujitsu.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Subject: [PATCH 29/56] arm64/sve: Clarify vq map semantics
Date:   Fri,  3 May 2019 13:44:00 +0100
Message-Id: <20190503124427.190206-30-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190503124427.190206-1-marc.zyngier@arm.com>
References: <20190503124427.190206-1-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Dave Martin <Dave.Martin@arm.com>

Currently the meanings of sve_vq_map and the ancillary helpers
__bit_to_vq() and __vq_to_bit() are not clearly explained.

This patch makes the explanatory comment clearer, and removes the
duplicate comment from fpsimd.h.

The WARN_ON() currently present in __bit_to_vq() confuses the
intended use of this helper.  Since these are low-level helpers not
intended for general-purpose use anyway, it is better not to make
guesses about how these functions will be used: rather, this patch
removes the WARN_ON() and relies on callers to use the helpers
sensibly.

Suggested-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/fpsimd.h | 4 ----
 arch/arm64/kernel/fpsimd.c      | 7 ++++++-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index ad6d2e41eb37..df62bbd33a9a 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -92,7 +92,6 @@ extern u64 read_zcr_features(void);
 
 extern int __ro_after_init sve_max_vl;
 extern int __ro_after_init sve_max_virtualisable_vl;
-/* Set of available vector lengths, as vq_to_bit(vq): */
 extern __ro_after_init DECLARE_BITMAP(sve_vq_map, SVE_VQ_MAX);
 
 /*
@@ -107,9 +106,6 @@ static inline unsigned int __vq_to_bit(unsigned int vq)
 
 static inline unsigned int __bit_to_vq(unsigned int bit)
 {
-	if (WARN_ON(bit >= SVE_VQ_MAX))
-		bit = SVE_VQ_MAX - 1;
-
 	return SVE_VQ_MAX - bit;
 }
 
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 577296bba730..56afa40263d9 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -135,10 +135,15 @@ static int sve_default_vl = -1;
 /* Maximum supported vector length across all CPUs (initially poisoned) */
 int __ro_after_init sve_max_vl = SVE_VL_MIN;
 int __ro_after_init sve_max_virtualisable_vl = SVE_VL_MIN;
-/* Set of available vector lengths, as vq_to_bit(vq): */
+
+/*
+ * Set of available vector lengths,
+ * where length vq encoded as bit __vq_to_bit(vq):
+ */
 __ro_after_init DECLARE_BITMAP(sve_vq_map, SVE_VQ_MAX);
 /* Set of vector lengths present on at least one cpu: */
 static __ro_after_init DECLARE_BITMAP(sve_vq_partial_map, SVE_VQ_MAX);
+
 static void __percpu *efi_sve_state;
 
 #else /* ! CONFIG_ARM64_SVE */
-- 
2.20.1

