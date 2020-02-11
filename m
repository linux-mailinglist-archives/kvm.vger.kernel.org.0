Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33E8B158B63
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 09:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbgBKIkr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 03:40:47 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:52310 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727742AbgBKIkr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 03:40:47 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 945D616D4F7F1FABDD1A;
        Tue, 11 Feb 2020 16:40:45 +0800 (CST)
Received: from DESKTOP-8RFUVS3.china.huawei.com (10.173.222.27) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Tue, 11 Feb 2020 16:40:35 +0800
From:   Zenghui Yu <yuzenghui@huawei.com>
To:     <drjones@redhat.com>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>
CC:     <alexandru.elisei@arm.com>, <wanghaibin.wang@huawei.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: [kvm-unit-tests PATCH 3/3] arm64: timer: Use existing helpers to access counter/timers
Date:   Tue, 11 Feb 2020 16:39:01 +0800
Message-ID: <20200211083901.1478-4-yuzenghui@huawei.com>
X-Mailer: git-send-email 2.23.0.windows.1
In-Reply-To: <20200211083901.1478-1-yuzenghui@huawei.com>
References: <20200211083901.1478-1-yuzenghui@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We already have some good helpers to access the counter and timer
registers.  Use them to avoid open coding the accessors again.

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
---
 arm/timer.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arm/timer.c b/arm/timer.c
index 10a88f3..f5cf775 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -331,7 +331,7 @@ static void test_init(void)
 	vtimer_info.irq_flags = fdt32_to_cpu(data[8]);
 
 	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_UNKNOWN, ptimer_unsupported_handler);
-	read_sysreg(cntp_ctl_el0);
+	ptimer_info.read_ctl();
 	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_UNKNOWN, NULL);
 
 	if (ptimer_unsupported && !ERRATA(7b6b46311a85)) {
@@ -366,15 +366,15 @@ static void print_timer_info(void)
 {
 	printf("CNTFRQ_EL0   : 0x%016lx\n", read_sysreg(cntfrq_el0));
 
-	if (!ptimer_unsupported){
-		printf("CNTPCT_EL0   : 0x%016lx\n", read_sysreg(cntpct_el0));
-		printf("CNTP_CTL_EL0 : 0x%016lx\n", read_sysreg(cntp_ctl_el0));
-		printf("CNTP_CVAL_EL0: 0x%016lx\n", read_sysreg(cntp_cval_el0));
+	if (!ptimer_unsupported) {
+		printf("CNTPCT_EL0   : 0x%016lx\n", ptimer_info.read_counter());
+		printf("CNTP_CTL_EL0 : 0x%016lx\n", ptimer_info.read_ctl());
+		printf("CNTP_CVAL_EL0: 0x%016lx\n", ptimer_info.read_cval());
 	}
 
-	printf("CNTVCT_EL0   : 0x%016lx\n", read_sysreg(cntvct_el0));
-	printf("CNTV_CTL_EL0 : 0x%016lx\n", read_sysreg(cntv_ctl_el0));
-	printf("CNTV_CVAL_EL0: 0x%016lx\n", read_sysreg(cntv_cval_el0));
+	printf("CNTVCT_EL0   : 0x%016lx\n", vtimer_info.read_counter());
+	printf("CNTV_CTL_EL0 : 0x%016lx\n", vtimer_info.read_ctl());
+	printf("CNTV_CVAL_EL0: 0x%016lx\n", vtimer_info.read_cval());
 }
 
 int main(int argc, char **argv)
-- 
2.19.1


