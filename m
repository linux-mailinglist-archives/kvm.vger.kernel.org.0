Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2317326CC5
	for <lists+kvm@lfdr.de>; Sat, 27 Feb 2021 11:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbhB0Kml (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 27 Feb 2021 05:42:41 -0500
Received: from foss.arm.com ([217.140.110.172]:43000 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230075AbhB0Kmf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 27 Feb 2021 05:42:35 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0D085106F;
        Sat, 27 Feb 2021 02:41:49 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6AF133F73B;
        Sat, 27 Feb 2021 02:41:48 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     drjones@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests PATCH 1/6] arm64: Remove unnecessary ISB when writing to SPSel
Date:   Sat, 27 Feb 2021 10:41:56 +0000
Message-Id: <20210227104201.14403-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210227104201.14403-1-alexandru.elisei@arm.com>
References: <20210227104201.14403-1-alexandru.elisei@arm.com>
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
2.30.1

