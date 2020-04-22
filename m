Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D07411B43CD
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 14:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728584AbgDVMBI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 08:01:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:43988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728520AbgDVMBB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Apr 2020 08:01:01 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FCD920784;
        Wed, 22 Apr 2020 12:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587556861;
        bh=AQq7xJ8ZXi/72v13Wk8lju6LWb73SYKYdW77HCXIWmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SMKFgOqk+7AULQcu5u3eefXN6EgwWt6Pkr+gKByGKM1cgz43z6o49iekRTrgPk56M
         2PESre9yTOKLKaOGXUo2KNouZtsJQbMMNJQj/uguKi1oH4SvDDjjyOXufPAAH0JTMA
         9LGW2qSkywB9fKbQQ1BUWyQ9l2kVo22KNRY2WMLo=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jRE3n-005UI7-Cp; Wed, 22 Apr 2020 13:00:59 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Dave Martin <Dave.Martin@arm.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        George Cherian <gcherian@marvell.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 05/26] arm64: Document SW reserved PTE/PMD bits in Stage-2 descriptors
Date:   Wed, 22 Apr 2020 13:00:29 +0100
Message-Id: <20200422120050.3693593-6-maz@kernel.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200422120050.3693593-1-maz@kernel.org>
References: <20200422120050.3693593-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com, christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu, alexandru.elisei@arm.com, gcherian@marvell.com, prime.zeng@hisilicon.com, will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Advertise bits [58:55] as reserved for SW in the S2 descriptors.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/pgtable-hwdef.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
index 6bf5e650da788..7eab0d23cdb52 100644
--- a/arch/arm64/include/asm/pgtable-hwdef.h
+++ b/arch/arm64/include/asm/pgtable-hwdef.h
@@ -177,10 +177,12 @@
 #define PTE_S2_RDONLY		(_AT(pteval_t, 1) << 6)   /* HAP[2:1] */
 #define PTE_S2_RDWR		(_AT(pteval_t, 3) << 6)   /* HAP[2:1] */
 #define PTE_S2_XN		(_AT(pteval_t, 2) << 53)  /* XN[1:0] */
+#define PTE_S2_SW_RESVD		(_AT(pteval_t, 15) << 55) /* Reserved for SW */
 
 #define PMD_S2_RDONLY		(_AT(pmdval_t, 1) << 6)   /* HAP[2:1] */
 #define PMD_S2_RDWR		(_AT(pmdval_t, 3) << 6)   /* HAP[2:1] */
 #define PMD_S2_XN		(_AT(pmdval_t, 2) << 53)  /* XN[1:0] */
+#define PMD_S2_SW_RESVD		(_AT(pmdval_t, 15) << 55) /* Reserved for SW */
 
 #define PUD_S2_RDONLY		(_AT(pudval_t, 1) << 6)   /* HAP[2:1] */
 #define PUD_S2_RDWR		(_AT(pudval_t, 3) << 6)   /* HAP[2:1] */
-- 
2.26.1

