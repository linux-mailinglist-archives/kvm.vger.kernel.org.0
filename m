Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D63F2635443
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 10:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237016AbiKWJFL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 04:05:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236960AbiKWJEy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 04:04:54 -0500
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [63.216.63.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D895DFFAAB;
        Wed, 23 Nov 2022 01:04:52 -0800 (PST)
Received: from mxct.zte.com.cn (unknown [192.168.251.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mxhk.zte.com.cn (FangMail) with ESMTPS id 4NHFZC2p6Xz4xVnf;
        Wed, 23 Nov 2022 17:04:51 +0800 (CST)
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxct.zte.com.cn (FangMail) with ESMTPS id 4NHFZ94qlgz4xyCN;
        Wed, 23 Nov 2022 17:04:49 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.40.50])
        by mse-fl2.zte.com.cn with SMTP id 2AN94heK059175;
        Wed, 23 Nov 2022 17:04:43 +0800 (+08)
        (envelope-from zhang.songyi@zte.com.cn)
Received: from mapi (xaxapp02[null])
        by mapi (Zmail) with MAPI id mid31;
        Wed, 23 Nov 2022 17:04:45 +0800 (CST)
Date:   Wed, 23 Nov 2022 17:04:45 +0800 (CST)
X-Zmail-TransId: 2afa637de22dffffffff95a3dc38
X-Mailer: Zmail v1.0
Message-ID: <202211231704457807160@zte.com.cn>
Mime-Version: 1.0
From:   <zhang.songyi@zte.com.cn>
To:     <seanjc@google.com>
Cc:     <pbonzini@redhat.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <bp@alien8.de>, <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        <hpa@zytor.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <zhang.songyi@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIGxpbnV4LW5leHRdIEtWTTogeDg2OiByZW1vdmUgcmVkdW5kYW50IHJldCB2YXJpYWJsZQ==?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl2.zte.com.cn 2AN94heK059175
X-Fangmail-Gw-Spam-Type: 0
X-FangMail-Miltered: at cgslv5.04-192.168.250.138.novalocal with ID 637DE233.000 by FangMail milter!
X-FangMail-Envelope: 1669194291/4NHFZC2p6Xz4xVnf/637DE233.000/192.168.251.13/[192.168.251.13]/mxct.zte.com.cn/<zhang.songyi@zte.com.cn>
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 637DE233.000/4NHFZC2p6Xz4xVnf
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: zhang songyi <zhang.songyi@zte.com.cn>

Return value from apic_get_tmcct() directly instead of taking
this in another redundant variable.

Signed-off-by: zhang songyi <zhang.songyi@zte.com.cn>
---
 arch/x86/kvm/lapic.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index d7639d126e6c..707970804502 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1363,7 +1363,6 @@ static u32 apic_get_tmcct(struct kvm_lapic *apic)
 {
        ktime_t remaining, now;
        s64 ns;
-       u32 tmcct;

        ASSERT(apic != NULL);

@@ -1378,10 +1377,9 @@ static u32 apic_get_tmcct(struct kvm_lapic *apic)
                remaining = 0;

        ns = mod_64(ktime_to_ns(remaining), apic->lapic_timer.period);
-       tmcct = div64_u64(ns,
-                        (APIC_BUS_CYCLE_NS * apic->divide_count));

-       return tmcct;
+       return div64_u64(ns,
+                       (APIC_BUS_CYCLE_NS * apic->divide_count));
 }

 static void __report_tpr_access(struct kvm_lapic *apic, bool write)
--
2.15.2
