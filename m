Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB556ACAC4
	for <lists+kvm@lfdr.de>; Mon,  6 Mar 2023 18:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjCFRiQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Mar 2023 12:38:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbjCFRiN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Mar 2023 12:38:13 -0500
Received: from raptorengineering.com (mail.raptorengineering.com [23.155.224.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65ECE37737
        for <kvm@vger.kernel.org>; Mon,  6 Mar 2023 09:37:40 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mail.rptsys.com (Postfix) with ESMTP id 958C937E2D60D1;
        Mon,  6 Mar 2023 11:30:42 -0600 (CST)
Received: from mail.rptsys.com ([127.0.0.1])
        by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id HYDUPU0u9TJI; Mon,  6 Mar 2023 11:30:42 -0600 (CST)
Received: from localhost (localhost [127.0.0.1])
        by mail.rptsys.com (Postfix) with ESMTP id 33B8537E2D60CE;
        Mon,  6 Mar 2023 11:30:42 -0600 (CST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.rptsys.com 33B8537E2D60CE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=raptorengineering.com; s=B8E824E6-0BE2-11E6-931D-288C65937AAD;
        t=1678123842; bh=kiK4u61n03Ewv9GiwNQjcFB9//YPBFFbrjx8hSx1Y+c=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=KpZ/1BX9ebbx6jGZSpuBBOBFbjFdvhoRBWG9+oBSQ+x4DVjNAuBhynoMcXBJ0WxBU
         8kpfHHKMxWt77SgaObYmZNhveYByVYGIqNOo+fXDiR1HaUiu5pLHnlSrEle2YkruTt
         b04EhKOKwc0jfOXQnIddNfibXi1qpWzHOd2jzBr4=
X-Virus-Scanned: amavisd-new at rptsys.com
Received: from mail.rptsys.com ([127.0.0.1])
        by localhost (vali.starlink.edu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id BL7M-Xkg8qh2; Mon,  6 Mar 2023 11:30:42 -0600 (CST)
Received: from vali.starlink.edu (localhost [127.0.0.1])
        by mail.rptsys.com (Postfix) with ESMTP id 1362237E2D60C8;
        Mon,  6 Mar 2023 11:30:42 -0600 (CST)
Date:   Mon, 6 Mar 2023 11:30:42 -0600 (CST)
From:   Timothy Pearson <tpearson@raptorengineering.com>
To:     kvm <kvm@vger.kernel.org>
Cc:     linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Message-ID: <12303156.16998521.1678123842049.JavaMail.zimbra@raptorengineeringinc.com>
Subject: [PATCH v2 2/4] powerpc/pci_64: Init pcibios subsys a bit later
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Mailer: Zimbra 8.5.0_GA_3042 (ZimbraWebClient - GC110 (Linux)/8.5.0_GA_3042)
Thread-Index: xJigH1RzbFL1MLjO/JsgLFkXazYTjQ==
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
index fd42059ae2a5..e27342ef128b 100644
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
