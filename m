Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8A3B2C7442
	for <lists+kvm@lfdr.de>; Sat, 28 Nov 2020 23:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388768AbgK1Vto (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Nov 2020 16:49:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:50808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732875AbgK1TEe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 Nov 2020 14:04:34 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8ED2422409;
        Sat, 28 Nov 2020 12:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606567625;
        bh=lnhjrd1BY+4XT/salWuXAQXDGdluOebgvvtHAouCinc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fINe9zgg4BEo7DfBbGMcvdXT8bPDtBIBZgP6f6gxVZpUYSoriqEFshlbY+fjTA0A6
         QsBCMpyTQAtpWVlYOyszH/w67Itf4NHxOXc9OoMTYyOJLehFCg7qOxqG98YkGtV5uy
         NgE5A5J2H092MPpM2lp/0URKigLApTzWr8KgVVZc=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <maz@kernel.org>)
        id 1kizd1-00EHHF-S1; Sat, 28 Nov 2020 12:47:04 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kernel-team@android.com
Subject: [PATCH 1/2] arm64: Make the Meltdown mitigation state available
Date:   Sat, 28 Nov 2020 12:46:58 +0000
Message-Id: <20201128124659.669578-2-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201128124659.669578-1-maz@kernel.org>
References: <20201128124659.669578-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, will@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Our Meltdown mitigation state isn't exposed outside of cpufeature.c,
contrary to the rest of the Spectre mitigation state. As we are going
to use it in KVM, expose a arm64_get_meltdown_state() helper which
returns the same possible values as arm64_get_spectre_v?_state().

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/spectre.h |  2 ++
 arch/arm64/kernel/cpufeature.c   | 20 +++++++++++++++++---
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/spectre.h b/arch/arm64/include/asm/spectre.h
index fcdfbce302bd..52e788981f4a 100644
--- a/arch/arm64/include/asm/spectre.h
+++ b/arch/arm64/include/asm/spectre.h
@@ -29,4 +29,6 @@ bool has_spectre_v4(const struct arm64_cpu_capabilities *cap, int scope);
 void spectre_v4_enable_mitigation(const struct arm64_cpu_capabilities *__unused);
 void spectre_v4_enable_task_mitigation(struct task_struct *tsk);
 
+enum mitigation_state arm64_get_meltdown_state(void);
+
 #endif	/* __ASM_SPECTRE_H */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 6f36c4f62f69..280b10762f6b 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2846,14 +2846,28 @@ static int __init enable_mrs_emulation(void)
 
 core_initcall(enable_mrs_emulation);
 
+enum mitigation_state arm64_get_meltdown_state(void)
+{
+	if (__meltdown_safe)
+		return SPECTRE_UNAFFECTED;
+
+	if (arm64_kernel_unmapped_at_el0())
+		return SPECTRE_MITIGATED;
+
+	return SPECTRE_VULNERABLE;
+}
+
 ssize_t cpu_show_meltdown(struct device *dev, struct device_attribute *attr,
 			  char *buf)
 {
-	if (__meltdown_safe)
+	switch (arm64_get_meltdown_state()) {
+	case SPECTRE_UNAFFECTED:
 		return sprintf(buf, "Not affected\n");
 
-	if (arm64_kernel_unmapped_at_el0())
+	case SPECTRE_MITIGATED:
 		return sprintf(buf, "Mitigation: PTI\n");
 
-	return sprintf(buf, "Vulnerable\n");
+	default:
+		return sprintf(buf, "Vulnerable\n");
+	}
 }
-- 
2.28.0

