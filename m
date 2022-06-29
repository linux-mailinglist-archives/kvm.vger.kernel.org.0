Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69E5155F3F7
	for <lists+kvm@lfdr.de>; Wed, 29 Jun 2022 05:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbiF2DVC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jun 2022 23:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231573AbiF2DUn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jun 2022 23:20:43 -0400
X-Greylist: delayed 182 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 28 Jun 2022 20:20:40 PDT
Received: from cmccmta3.chinamobile.com (cmccmta3.chinamobile.com [221.176.66.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7255F6582
        for <kvm@vger.kernel.org>; Tue, 28 Jun 2022 20:20:40 -0700 (PDT)
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from spf.mail.chinamobile.com (unknown[172.16.121.93])
        by rmmx-syy-dmz-app10-12010 (RichMail) with SMTP id 2eea62bbc44f731-03558;
        Wed, 29 Jun 2022 11:17:35 +0800 (CST)
X-RM-TRANSID: 2eea62bbc44f731-03558
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[223.108.79.101])
        by rmsmtp-syy-appsvrnew07-12032 (RichMail) with SMTP id 2f0062bbc437a24-8ac3b;
        Wed, 29 Jun 2022 11:17:35 +0800 (CST)
X-RM-TRANSID: 2f0062bbc437a24-8ac3b
From:   jianchunfu <jianchunfu@cmss.chinamobile.com>
To:     clg@kaod.org, danielhb413@gmail.com, david@gibson.dropbear.id.au,
        groug@kaod.org, pbonzini@redhat.com
Cc:     qemu-ppc@nongnu.org, kvm@vger.kernel.org, qemu-devel@nongnu.org,
        jianchunfu <jianchunfu@cmss.chinamobile.com>
Subject: [PATCH] target/ppc: Add error reporting when opening file fails
Date:   Wed, 29 Jun 2022 11:15:52 +0800
Message-Id: <20220629031552.5407-1-jianchunfu@cmss.chinamobile.com>
X-Mailer: git-send-email 2.18.4
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add error reporting before return when opening file fails.

Signed-off-by: jianchunfu <jianchunfu@cmss.chinamobile.com>
---
 target/ppc/kvm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index dc93b99189..ef9a871411 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -1798,6 +1798,7 @@ static int read_cpuinfo(const char *field, char *value, int len)
 
     f = fopen("/proc/cpuinfo", "r");
     if (!f) {
+        fprintf(stderr, "Error opening /proc/cpuinfo: %s\n", strerror(errno));
         return -1;
     }
 
@@ -1906,6 +1907,7 @@ static uint64_t kvmppc_read_int_dt(const char *filename)
 
     f = fopen(filename, "rb");
     if (!f) {
+        fprintf(stderr, "Error opening %s: %s\n", filename, strerror(errno));
         return -1;
     }
 
-- 
2.18.4



