Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25DB446F974
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 04:07:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236124AbhLJDLR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 22:11:17 -0500
Received: from out28-74.mail.aliyun.com ([115.124.28.74]:54337 "EHLO
        out28-74.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234022AbhLJDLQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 22:11:16 -0500
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.09338807|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.00451464-0.000264178-0.995221;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047211;MF=haibiao.xiao@zstack.io;NM=1;PH=DS;RN=5;RT=5;SR=0;TI=SMTPD_---.M8-E82q_1639105659;
Received: from Rickylss-Ubuntu..(mailfrom:haibiao.xiao@zstack.io fp:SMTPD_---.M8-E82q_1639105659)
          by smtp.aliyun-inc.com(10.147.42.16);
          Fri, 10 Dec 2021 11:07:40 +0800
From:   "haibiao.xiao" <haibiao.xiao@zstack.io>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        alexandru.elisei@arm.com,
        "haibiao.xiao" <xiaohaibiao331@outlook.com>
Subject: [PATCH v2 kvmtool] Makefile: Calculate the correct kvmtool version
Date:   Fri, 10 Dec 2021 11:07:08 +0800
Message-Id: <20211210030708.288066-1-haibiao.xiao@zstack.io>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: "haibiao.xiao" <xiaohaibiao331@outlook.com>

Command 'lvm version' works incorrect.
It is expected to print:

    # ./lvm version
    # kvm tool [KVMTOOLS_VERSION]

but the KVMTOOLS_VERSION is missed:

    # ./lvm version
    # kvm tool

The KVMTOOLS_VERSION is defined in the KVMTOOLS-VERSION-FILE file which
is included at the end of Makefile. Since the CFLAGS is a 'Simply
expanded variables' which means CFLAGS is only scanned once. So the
definetion of KVMTOOLS_VERSION at the end of Makefile would not scanned
by CFLAGS. So the '-DKVMTOOLS_VERSION=' remains empty.

I fixed the bug by moving the '-include $(OUTPUT)KVMTOOLS-VERSION-FILE'
before the CFLAGS.

Signed-off-by: haibiao.xiao <xiaohaibiao331@outlook.com>
Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index bb7ad3e..9afb5e3 100644
--- a/Makefile
+++ b/Makefile
@@ -17,6 +17,7 @@ export E Q
 
 include config/utilities.mak
 include config/feature-tests.mak
+-include $(OUTPUT)KVMTOOLS-VERSION-FILE
 
 CC	:= $(CROSS_COMPILE)gcc
 CFLAGS	:=
@@ -559,5 +560,4 @@ ifneq ($(MAKECMDGOALS),clean)
 
 KVMTOOLS-VERSION-FILE:
 	@$(SHELL_PATH) util/KVMTOOLS-VERSION-GEN $(OUTPUT)
--include $(OUTPUT)KVMTOOLS-VERSION-FILE
-endif
+endif
\ No newline at end of file
-- 
2.32.0

