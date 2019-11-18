Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 402D8FFD14
	for <lists+kvm@lfdr.de>; Mon, 18 Nov 2019 03:27:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbfKRC1c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 17 Nov 2019 21:27:32 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:41164 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726325AbfKRC1c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 17 Nov 2019 21:27:32 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D71B4E117DC0D4651E24;
        Mon, 18 Nov 2019 10:27:30 +0800 (CST)
Received: from HGHY4C002233111.china.huawei.com (10.133.205.93) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.439.0; Mon, 18 Nov 2019 10:27:23 +0800
From:   <kuhn.chenqun@huawei.com>
To:     <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        <drjones@redhat.com>
CC:     <kenny.zhangjun@huawei.com>, <kuhn.chenqun@huawei.com>,
        <pannengyuan@huawei.com>, <zhang.zhanghailiang@huawei.com>
Subject: [kvm-unit-tests PATCH] arm: Add missing test name prefix for pl031 and spinlock
Date:   Mon, 18 Nov 2019 10:27:20 +0800
Message-ID: <20191118022720.17488-1-kuhn.chenqun@huawei.com>
X-Mailer: git-send-email 2.14.1.windows.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.133.205.93]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Chen Qun <kuhn.chenqun@huawei.com>

pl031 and spinlock testcase without prefix, when running
the unit tests in TAP mode (./run_tests.sh -t), it is
difficult to the test results.

The test results：
ok 13 - Periph/PCell IDs match
ok 14 - R/O fields are R/O
ok 15 - RTC ticks at 1HZ
ok 16 - RTC IRQ not pending yet
...
ok 24 -   RTC IRQ not pending anymore
ok 25 - CPU1: Done - Errors: 0
ok 26 - CPU0: Done - Errors: 0

It should be like this：
ok 13 - pl031: Periph/PCell IDs match
ok 14 - pl031: R/O fields are R/O
ok 15 - pl031: RTC ticks at 1HZ
ok 16 - pl031: RTC IRQ not pending yet
...
ok 24 - pl031:   RTC IRQ not pending anymore
ok 25 - spinlock: CPU0: Done - Errors: 0
ok 26 - spinlock: CPU1: Done - Errors: 0

Signed-off-by: Chen Qun <kuhn.chenqun@huawei.com>
---
 arm/pl031.c         | 1 +
 arm/spinlock-test.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arm/pl031.c b/arm/pl031.c
index 5672f36..d0c9c10 100644
--- a/arm/pl031.c
+++ b/arm/pl031.c
@@ -252,6 +252,7 @@ int main(int argc, char **argv)
 		return 0;
 	}
 
+	report_prefix_push("pl031");
 	report("Periph/PCell IDs match", !check_id());
 	report("R/O fields are R/O", !check_ro());
 	report("RTC ticks at 1HZ", !check_rtc_freq());
diff --git a/arm/spinlock-test.c b/arm/spinlock-test.c
index d55471b..ff16fb0 100644
--- a/arm/spinlock-test.c
+++ b/arm/spinlock-test.c
@@ -72,6 +72,7 @@ static void test_spinlock(void *data __unused)
 
 int main(int argc, char **argv)
 {
+	report_prefix_push("spinlock");
 	if (argc > 1 && strcmp(argv[1], "bad") != 0) {
 		lock_ops.lock = gcc_builtin_lock;
 		lock_ops.unlock = gcc_builtin_unlock;
-- 
2.14.1.windows.1


