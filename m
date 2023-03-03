Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB5046AA124
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 22:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbjCCV2k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 16:28:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231292AbjCCV2j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 16:28:39 -0500
Received: from raptorengineering.com (mail.raptorengineering.com [23.155.224.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90064113F3
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 13:28:38 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mail.rptsys.com (Postfix) with ESMTP id F145E37E2A81DB
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 15:28:37 -0600 (CST)
Received: from mail.rptsys.com ([127.0.0.1])
        by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id FJR9yXqXDmcU for <kvm@vger.kernel.org>;
        Fri,  3 Mar 2023 15:28:37 -0600 (CST)
Received: from localhost (localhost [127.0.0.1])
        by mail.rptsys.com (Postfix) with ESMTP id 8720837E2A81D8
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 15:28:37 -0600 (CST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.rptsys.com 8720837E2A81D8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=raptorengineering.com; s=B8E824E6-0BE2-11E6-931D-288C65937AAD;
        t=1677878917; bh=x/LPKEqVCU9oQc2icWYyBd5KbfQKfd4ccf3nU9BP+Z4=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=j/3Sm92M1YN9PLk3w3abkIHwkzG4MFeZWE/fcuk60OXuGE4Z3/YeKB/ScSPPaOzLP
         8T33h4vkRNibwxkQaXiAQdBz8u29lyfGoQ1r/77y35t0ekCZW90g3wkXH2EwiA2FaH
         2lFDJ2nmDqrW+7FKY8GMNxSSvxOI6K9J5acSaqkY=
X-Virus-Scanned: amavisd-new at rptsys.com
Received: from mail.rptsys.com ([127.0.0.1])
        by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id F-3sbRhkCO1B for <kvm@vger.kernel.org>;
        Fri,  3 Mar 2023 15:28:37 -0600 (CST)
Received: from vali.starlink.edu (localhost [127.0.0.1])
        by mail.rptsys.com (Postfix) with ESMTP id 6C74437E2A81D5
        for <kvm@vger.kernel.org>; Fri,  3 Mar 2023 15:28:37 -0600 (CST)
Date:   Fri, 3 Mar 2023 15:28:37 -0600 (CST)
From:   Timothy Pearson <tpearson@raptorengineering.com>
To:     kvm <kvm@vger.kernel.org>
Message-ID: <1940263767.16280459.1677878917410.JavaMail.zimbra@raptorengineeringinc.com>
Subject: [PATCH 3/5] powerpc/pci_64: Init pcibios subsys a bit later
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 8.5.0_GA_3042 (ZimbraWebClient - GC110 (Linux)/8.5.0_GA_3042)
Thread-Index: W/WW2wreQjIlVEtt3fmQBtlfW76wbA==
Thread-Topic: powerpc/pci_64: Init pcibios subsys a bit later
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following patches are going to add dependency/use of iommu_ops which
is initialized in subsys_initcall as well.

This moves pciobios_init() to the next initcall level.

This should not cause behavioral change.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Timothy Pearson <tpearson@raptorengineering.com>
---
 arch/powerpc/kernel/pci_64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/pci_64.c b/arch/powerpc/kernel/pci_64.c
index 0c7cfb9fab04..9cd763d512ae 100644
--- a/arch/powerpc/kernel/pci_64.c
+++ b/arch/powerpc/kernel/pci_64.c
@@ -73,7 +73,7 @@ static int __init pcibios_init(void)
 	return 0;
 }
 
-subsys_initcall(pcibios_init);
+subsys_initcall_sync(pcibios_init);
 
 int pcibios_unmap_io_space(struct pci_bus *bus)
 {
-- 
2.30.2
