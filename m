Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D191B23CDEE
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 19:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728774AbgHER6t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 13:58:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:45308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729072AbgHER5o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 13:57:44 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01FEB2250E;
        Wed,  5 Aug 2020 17:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596650235;
        bh=auCGx6XCpPj3YqEfR6NXLz5q29tOXX3dB0MRke0HUQQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dq0mTS5ldx9HxUmrCnD0/17fGX0zXjqZ6in/6TXrm92Pc61ToxKYi1AR+F+gYHNTQ
         n6YBKphf2pcDLWZK+nIM00efMICQMG1YOV26GFBe54ICAMPhw9vRlmi7OFhmAUE4H8
         hV7YhEKHnG4vhcQ2XZsG/wLq4PhPK4OPOPCq2q+4=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k3Nf7-0004w9-IK; Wed, 05 Aug 2020 18:57:13 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Scull <ascull@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        David Brazdil <dbrazdil@google.com>,
        Eric Auger <eric.auger@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peng Hao <richard.peng@oppo.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com
Subject: [PATCH 02/56] KVM: arm64: Allow ARM64_PTR_AUTH when ARM64_VHE=n
Date:   Wed,  5 Aug 2020 18:56:06 +0100
Message-Id: <20200805175700.62775-3-maz@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200805175700.62775-1-maz@kernel.org>
References: <20200805175700.62775-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, graf@amazon.com, alexandru.elisei@arm.com, ascull@google.com, catalin.marinas@arm.com, christoffer.dall@arm.com, dbrazdil@google.com, eric.auger@redhat.com, gshan@redhat.com, james.morse@arm.com, mark.rutland@arm.com, richard.peng@oppo.com, qperret@google.com, will@kernel.org, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel-team@android.com
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

