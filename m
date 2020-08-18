Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08833247CC8
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 05:28:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgHRD23 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Aug 2020 23:28:29 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:9826 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726422AbgHRD22 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Aug 2020 23:28:28 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 65EAAF6D45FC0316F09F;
        Tue, 18 Aug 2020 11:28:25 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.187.22) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Tue, 18 Aug 2020 11:28:17 +0800
From:   Keqian Zhu <zhukeqian1@huawei.com>
To:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>
CC:     Marc Zyngier <maz@kernel.org>, Steven Price <steven.price@arm.com>,
        "Andrew Jones" <drjones@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Will Deacon" <will@kernel.org>, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        <wanghaibin.wang@huawei.com>, Keqian Zhu <zhukeqian1@huawei.com>
Subject: [PATCH v2 1/2] clocksource: arm_arch_timer: Use stable count reader in erratum sne
Date:   Tue, 18 Aug 2020 11:28:13 +0800
Message-ID: <20200818032814.15968-2-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
In-Reply-To: <20200818032814.15968-1-zhukeqian1@huawei.com>
References: <20200818032814.15968-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.22]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In commit 0ea415390cd3 ("clocksource/arm_arch_timer: Use arch_timer_read_counter
to access stable counters"), we separate stable and normal count reader to omit
unnecessary overhead on systems that have no timer erratum.

However, in erratum_set_next_event_tval_generic(), count reader becomes normal
reader. This converts it to stable reader.

Fixes: 0ea415390cd3 ("clocksource/arm_arch_timer: Use
       arch_timer_read_counter to access stable counters")
Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
---
 drivers/clocksource/arm_arch_timer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 6c3e841..777d38c 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -396,10 +396,10 @@ static void erratum_set_next_event_tval_generic(const int access, unsigned long
 	ctrl &= ~ARCH_TIMER_CTRL_IT_MASK;
 
 	if (access == ARCH_TIMER_PHYS_ACCESS) {
-		cval = evt + arch_counter_get_cntpct();
+		cval = evt + arch_counter_get_cntpct_stable();
 		write_sysreg(cval, cntp_cval_el0);
 	} else {
-		cval = evt + arch_counter_get_cntvct();
+		cval = evt + arch_counter_get_cntvct_stable();
 		write_sysreg(cval, cntv_cval_el0);
 	}
 
-- 
1.8.3.1

