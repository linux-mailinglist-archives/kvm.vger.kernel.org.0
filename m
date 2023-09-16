Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A35877A2E0A
	for <lists+kvm@lfdr.de>; Sat, 16 Sep 2023 07:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238715AbjIPFY0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sat, 16 Sep 2023 01:24:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238713AbjIPFX6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 16 Sep 2023 01:23:58 -0400
Received: from ex01.ufhost.com (ex01.ufhost.com [61.152.239.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72A5F1BCD
        for <kvm@vger.kernel.org>; Fri, 15 Sep 2023 22:23:49 -0700 (PDT)
Received: from EXMBX166.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX166", Issuer "EXMBX166" (not verified))
        by ex01.ufhost.com (Postfix) with ESMTP id 345D224E18D;
        Sat, 16 Sep 2023 13:23:47 +0800 (CST)
Received: from EXMBX061.cuchost.com (172.16.6.61) by EXMBX166.cuchost.com
 (172.16.6.76) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Sat, 16 Sep
 2023 13:23:47 +0800
Received: from localhost.localdomain (115.135.198.49) by EXMBX061.cuchost.com
 (172.16.6.61) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Sat, 16 Sep
 2023 13:23:43 +0800
From:   Tan En De <ende.tan@starfivetech.com>
To:     <kvm@vger.kernel.org>
CC:     <will@kernel.org>, <julien.thierry.kdev@gmail.com>,
        Tan En De <ende.tan@starfivetech.com>
Subject: [kvmtool] pci: Deregister KVM_PCI_CFG_AREA on pci__exit
Date:   Sat, 16 Sep 2023 13:23:03 +0800
Message-ID: <20230916052303.1003-1-ende.tan@starfivetech.com>
X-Mailer: git-send-email 2.38.1.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [115.135.198.49]
X-ClientProxiedBy: EXCAS062.cuchost.com (172.16.6.22) To EXMBX061.cuchost.com
 (172.16.6.61)
X-YovoleRuleAgent: yovoleflag
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM_PCI_CFG_AREA is registered with kvm__register_mmio during pci__init,
but it isn't deregistered during pci__exit.

So, this commit is to kvm__deregister_mmio the KVM_PCI_CFG_AREA on pci__exit.

Signed-off-by: Tan En De <ende.tan@starfivetech.com>
---
 pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/pci.c b/pci.c
index b170885..340674c 100644
--- a/pci.c
+++ b/pci.c
@@ -532,6 +532,7 @@ int pci__exit(struct kvm *kvm)
 {
 	kvm__deregister_pio(kvm, PCI_CONFIG_DATA);
 	kvm__deregister_pio(kvm, PCI_CONFIG_ADDRESS);
+	kvm__deregister_mmio(kvm, KVM_PCI_CFG_AREA);
 
 	return 0;
 }
-- 
2.34.1

