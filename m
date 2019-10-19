Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB24ADD7D2
	for <lists+kvm@lfdr.de>; Sat, 19 Oct 2019 11:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725992AbfJSJzm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Oct 2019 05:55:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725937AbfJSJzm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Oct 2019 05:55:42 -0400
Received: from big-swifty.lan (78.163-31-62.static.virginmediabusiness.co.uk [62.31.163.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4010F222C2;
        Sat, 19 Oct 2019 09:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571478941;
        bh=NIhQTmaSfZdOFxlsYacZmWRGnEWsqvAAqOXU5n1fBjc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Ke1oSPhBBMSE/PKuHl0F96K39z/y/L2tu7iwYUo/hIR0eOS9mV/NP7807EKmNR7j
         hcCy70w0ARPX++VLoxQv+SMqs5Gk/oECK0KwHPRMSI3SZ2C+hhJGJZXimwyPPR86tS
         yGoynaIh12/EeSYLwt8Nzb6h2ZD/8fku07bANjmA=
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>
Subject: [PATCH v2 5/5] arm64: Enable and document ARM errata 1319367 and 1319537
Date:   Sat, 19 Oct 2019 10:55:21 +0100
Message-Id: <20191019095521.31722-6-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191019095521.31722-1-maz@kernel.org>
References: <20191019095521.31722-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Now that everything is in place, let's get the ball rolling
by allowing the corresponding config option to be selected.
Also add the required information to silicon_errata.rst.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 Documentation/arm64/silicon-errata.rst |  4 ++++
 arch/arm64/Kconfig                     | 10 ++++++++++
 2 files changed, 14 insertions(+)

diff --git a/Documentation/arm64/silicon-errata.rst b/Documentation/arm64/silicon-errata.rst
index 17ea3fecddaa..0808be134fce 100644
--- a/Documentation/arm64/silicon-errata.rst
+++ b/Documentation/arm64/silicon-errata.rst
@@ -70,8 +70,12 @@ stable kernels.
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A57      | #834220         | ARM64_ERRATUM_834220        |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-A57      | #1319537        | ARM64_ERRATUM_1319367       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A72      | #853709         | N/A                         |
 +----------------+-----------------+-----------------+-----------------------------+
+| ARM            | Cortex-A72      | #1319367        | ARM64_ERRATUM_1319367       |
++----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A73      | #858921         | ARM64_ERRATUM_858921        |
 +----------------+-----------------+-----------------+-----------------------------+
 | ARM            | Cortex-A55      | #1024718        | ARM64_ERRATUM_1024718       |
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 950a56b71ff0..b2877ed09307 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -538,6 +538,16 @@ config ARM64_ERRATUM_1286807
 	  invalidated has been observed by other observers. The
 	  workaround repeats the TLBI+DSB operation.
 
+config ARM64_ERRATUM_1319367
+	bool "Cortex-A57/A72: Speculative AT instruction using out-of-context translation regime could cause subsequent request to generate an incorrect translation"
+	default y
+	help
+	  This option adds work arounds for ARM Cortex-A57 erratum 1319537
+	  and A72 erratum 1319367
+
+	  Cortex-A57 and A72 cores could end-up with corrupted TLBs by
+	  speculating an AT instruction during a guest context switch.
+
 	  If unsure, say Y.
 
 config ARM64_ERRATUM_1463225
-- 
2.20.1

