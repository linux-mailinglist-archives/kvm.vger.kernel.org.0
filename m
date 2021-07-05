Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A96693BB67B
	for <lists+kvm@lfdr.de>; Mon,  5 Jul 2021 06:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbhGEEtb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jul 2021 00:49:31 -0400
Received: from out28-220.mail.aliyun.com ([115.124.28.220]:36714 "EHLO
        out28-220.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbhGEEta (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jul 2021 00:49:30 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.08799765|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0041981-0.000223123-0.995579;FP=9113306602455269698|1|1|2|0|-1|-1|-1;HT=ay29a033018047206;MF=haibiao.xiao@zstack.io;NM=1;PH=DS;RN=2;RT=2;SR=0;TI=SMTPD_---.KcFmI1S_1625460411;
Received: from Rickylss-Ubuntu..(mailfrom:haibiao.xiao@zstack.io fp:SMTPD_---.KcFmI1S_1625460411)
          by smtp.aliyun-inc.com(10.147.41.137);
          Mon, 05 Jul 2021 12:46:52 +0800
From:   "haibiao.xiao" <haibiao.xiao@zstack.io>
To:     kvm@vger.kernel.org
Cc:     "haibiao.xiao" <xiaohaibiao331@outlook.com>
Subject: [PATCH kvmtool] Makefile: 'lvm version' works incorrect. Because CFLAGS can not get sub-make variable $(KVMTOOLS_VERSION)
Date:   Mon,  5 Jul 2021 12:46:49 +0800
Message-Id: <20210705044649.14890-1-haibiao.xiao@zstack.io>
X-Mailer: git-send-email 2.30.2
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
2.30.2

