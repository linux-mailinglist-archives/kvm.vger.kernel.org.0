Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F15BD12DEC
	for <lists+kvm@lfdr.de>; Fri,  3 May 2019 14:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727970AbfECMpE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 May 2019 08:45:04 -0400
Received: from usa-sjc-mx-foss1.foss.arm.com ([217.140.101.70]:60102 "EHLO
        foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727959AbfECMpE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 May 2019 08:45:04 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D73E2165C;
        Fri,  3 May 2019 05:45:03 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com (filthy-habits.cambridge.arm.com [10.1.197.61])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9F29A3F220;
        Fri,  3 May 2019 05:45:00 -0700 (PDT)
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
Subject: [PATCH 06/56] arm64/sve: Clarify role of the VQ map maintenance functions
Date:   Fri,  3 May 2019 13:43:37 +0100
Message-Id: <20190503124427.190206-7-marc.zyngier@arm.com>
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

The roles of sve_init_vq_map(), sve_update_vq_map() and
sve_verify_vq_map() are highly non-obvious to anyone who has not dug
through cpufeatures.c in detail.

Since the way these functions interact with each other is more
important here than a full understanding of the cpufeatures code, this
patch adds comments to make the functions' roles clearer.

No functional change.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Julien Thierry <julien.thierry@arm.com>
Reviewed-by: Julien Grall <julien.grall@arm.com>
Tested-by: zhang.lei <zhang.lei@jp.fujitsu.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kernel/fpsimd.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 62c37f0ac946..f59ea677cd42 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -647,6 +647,10 @@ static void sve_probe_vqs(DECLARE_BITMAP(map, SVE_VQ_MAX))
 	}
 }
 
+/*
+ * Initialise the set of known supported VQs for the boot CPU.
+ * This is called during kernel boot, before secondary CPUs are brought up.
+ */
 void __init sve_init_vq_map(void)
 {
 	sve_probe_vqs(sve_vq_map);
@@ -655,6 +659,7 @@ void __init sve_init_vq_map(void)
 /*
  * If we haven't committed to the set of supported VQs yet, filter out
  * those not supported by the current CPU.
+ * This function is called during the bring-up of early secondary CPUs only.
  */
 void sve_update_vq_map(void)
 {
@@ -662,7 +667,10 @@ void sve_update_vq_map(void)
 	bitmap_and(sve_vq_map, sve_vq_map, sve_secondary_vq_map, SVE_VQ_MAX);
 }
 
-/* Check whether the current CPU supports all VQs in the committed set */
+/*
+ * Check whether the current CPU supports all VQs in the committed set.
+ * This function is called during the bring-up of late secondary CPUs only.
+ */
 int sve_verify_vq_map(void)
 {
 	int ret = 0;
-- 
2.20.1

