Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3EFA3448B9
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 16:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbhCVPGz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 11:06:55 -0400
Received: from foss.arm.com ([217.140.110.172]:33486 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231637AbhCVPGV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Mar 2021 11:06:21 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9DAA31063;
        Mon, 22 Mar 2021 08:06:20 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DE1A33F719;
        Mon, 22 Mar 2021 08:06:19 -0700 (PDT)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     drjones@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     andre.przywara@arm.com
Subject: [kvm-unit-tests PATCH v2 1/6] arm64: Remove unnecessary ISB when writing to SPSel
Date:   Mon, 22 Mar 2021 15:06:36 +0000
Message-Id: <20210322150641.58878-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322150641.58878-1-alexandru.elisei@arm.com>
References: <20210322150641.58878-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Software can use the SPSel operand to write directly to PSTATE.SP.
According to ARM DDI 0487F.b, page D1-2332, writes to PSTATE are
self-synchronizing and no ISB is needed:

"Writes to the PSTATE fields have side-effects on various aspects of the PE
operation. All of these side-effects are guaranteed:
- Not to be visible to earlier instructions in the execution stream.
- To be visible to later instructions in the execution stream."

Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/cstart64.S | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arm/cstart64.S b/arm/cstart64.S
index 0428014aa58a..fc1930bcdb53 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -54,7 +54,6 @@ start:
 	/* set up stack */
 	mov	x4, #1
 	msr	spsel, x4
-	isb
 	adrp    x4, stackptr
 	add     sp, x4, :lo12:stackptr
 
-- 
2.31.0

