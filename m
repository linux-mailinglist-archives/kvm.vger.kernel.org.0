Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6732203163
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 10:06:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725980AbgFVIG4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 04:06:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:42092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbgFVIGy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 04:06:54 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1AB3120809;
        Mon, 22 Jun 2020 08:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592813214;
        bh=auCGx6XCpPj3YqEfR6NXLz5q29tOXX3dB0MRke0HUQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b37ZMGbaz5WtmJvhG6Pa1s06V+Ty4K5Rf1v0tS9cSD0Qox8QqyJodBDKGz4w2b3Qp
         bMIYKnSJFiDIwz6p9QTOoZFe37QiKWObZSEa4YZvKtMu7C3AjhnOuN05utZKE7s8Zg
         Uw199VMmsnsMWr3Z9dI5ZU3Kk5ubeP7ugMqAWQKs=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jnHTg-005FG8-K2; Mon, 22 Jun 2020 09:06:52 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu
Cc:     James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Scull <ascull@google.com>,
        Dave Martin <Dave.Martin@arm.com>, kernel-team@android.com
Subject: [PATCH v2 2/5] KVM: arm64: Allow ARM64_PTR_AUTH when ARM64_VHE=n
Date:   Mon, 22 Jun 2020 09:06:40 +0100
Message-Id: <20200622080643.171651-3-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200622080643.171651-1-maz@kernel.org>
References: <20200622080643.171651-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, mark.rutland@arm.com, ascull@google.com, Dave.Martin@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We currently prevent PtrAuth from even being built if KVM is selected,
but VHE isn't. It is a bit of a pointless restriction, since we also
check this at run time (rejecting the enabling of PtrAuth for the
vcpu if we're not running with VHE).

Just drop this apparently useless restriction.

Acked-by: Andrew Scull <ascull@google.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/Kconfig | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 31380da53689..d719ea9c596d 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1516,7 +1516,6 @@ menu "ARMv8.3 architectural features"
 config ARM64_PTR_AUTH
 	bool "Enable support for pointer authentication"
 	default y
-	depends on !KVM || ARM64_VHE
 	depends on (CC_HAS_SIGN_RETURN_ADDRESS || CC_HAS_BRANCH_PROT_PAC_RET) && AS_HAS_PAC
 	# GCC 9.1 and later inserts a .note.gnu.property section note for PAC
 	# which is only understood by binutils starting with version 2.33.1.
@@ -1543,8 +1542,7 @@ config ARM64_PTR_AUTH
 
 	  The feature is detected at runtime. If the feature is not present in
 	  hardware it will not be advertised to userspace/KVM guest nor will it
-	  be enabled. However, KVM guest also require VHE mode and hence
-	  CONFIG_ARM64_VHE=y option to use this feature.
+	  be enabled.
 
 	  If the feature is present on the boot CPU but not on a late CPU, then
 	  the late CPU will be parked. Also, if the boot CPU does not have
-- 
2.27.0

