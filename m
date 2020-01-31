Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEBB114F0AD
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2020 17:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbgAaQiP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 Jan 2020 11:38:15 -0500
Received: from foss.arm.com ([217.140.110.172]:37356 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726761AbgAaQiO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 31 Jan 2020 11:38:14 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 56AD111FB;
        Fri, 31 Jan 2020 08:38:14 -0800 (PST)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com [10.1.196.63])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4F1013F68E;
        Fri, 31 Jan 2020 08:38:13 -0800 (PST)
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com, maz@kernel.org,
        andre.przywara@arm.com, vladimir.murzin@arm.com,
        mark.rutland@arm.com
Subject: [kvm-unit-tests PATCH v4 05/10] arm64: timer: Make irq_received volatile
Date:   Fri, 31 Jan 2020 16:37:23 +0000
Message-Id: <20200131163728.5228-6-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200131163728.5228-1-alexandru.elisei@arm.com>
References: <20200131163728.5228-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The irq_received field is modified by the interrupt handler. Make it
volatile so that the compiler doesn't reorder accesses with regard to
the instruction that will be causing the interrupt.

Suggested-by: Andre Przywara <andre.przywara@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arm/timer.c b/arm/timer.c
index e758e84855c3..82f891147b35 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -109,7 +109,7 @@ static void write_ptimer_ctl(u64 val)
 struct timer_info {
 	u32 irq;
 	u32 irq_flags;
-	bool irq_received;
+	volatile bool irq_received;
 	u64 (*read_counter)(void);
 	u64 (*read_cval)(void);
 	void (*write_cval)(u64);
-- 
2.20.1

