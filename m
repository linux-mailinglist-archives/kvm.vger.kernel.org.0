Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 161DC2DDEF3
	for <lists+kvm@lfdr.de>; Fri, 18 Dec 2020 08:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727184AbgLRHQn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Dec 2020 02:16:43 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:9903 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbgLRHQn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Dec 2020 02:16:43 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Cy0WF2G7Zz7D0b;
        Fri, 18 Dec 2020 15:15:21 +0800 (CST)
Received: from DESKTOP-FPN2511.china.huawei.com (10.174.187.192) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Fri, 18 Dec 2020 15:15:49 +0800
From:   Jingyi Wang <wangjingyi11@huawei.com>
To:     <drjones@redhat.com>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>
CC:     <maz@kernel.org>, <wanghaibin.wang@huawei.com>,
        <yuzenghui@huawei.com>, <eric.auger@redhat.com>,
        <wangjingyi11@huawei.com>
Subject: [kvm-unit-tests PATCH] arm64: microbench: fix unexpected PPI
Date:   Fri, 18 Dec 2020 15:15:42 +0800
Message-ID: <20201218071542.15368-1-wangjingyi11@huawei.com>
X-Mailer: git-send-email 2.14.1.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.187.192]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For the origin value of CNTV_CVAL_EL0 architecturally UNKNOWN, we may
receive an unexpected PPI before we actual trigger the timer interrupt.
So we should set ARCH_TIMER_CTL_IMASK in timer_prep.

Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
---
 arm/micro-bench.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arm/micro-bench.c b/arm/micro-bench.c
index 362f93e..95c418c 100644
--- a/arm/micro-bench.c
+++ b/arm/micro-bench.c
@@ -227,7 +227,7 @@ static bool timer_prep(void)
 	}
 
 	writel(1 << PPI(TIMER_VTIMER_IRQ), gic_isenabler);
-	write_sysreg(ARCH_TIMER_CTL_ENABLE, cntv_ctl_el0);
+	write_sysreg(ARCH_TIMER_CTL_IMASK | ARCH_TIMER_CTL_ENABLE, cntv_ctl_el0);
 	isb();
 
 	gic_prep_common();
-- 
2.19.1

