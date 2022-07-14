Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2835157468F
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 10:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232449AbiGNIS7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 04:18:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232210AbiGNIS5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 04:18:57 -0400
Received: from ozlabs.ru (ozlabs.ru [107.174.27.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CC229192AE;
        Thu, 14 Jul 2022 01:18:56 -0700 (PDT)
Received: from fstn1-p1.ozlabs.ibm.com. (localhost [IPv6:::1])
        by ozlabs.ru (Postfix) with ESMTP id 5528981BDD;
        Thu, 14 Jul 2022 04:18:47 -0400 (EDT)
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
To:     linuxppc-dev@lists.ozlabs.org
Cc:     kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        Deming Wang <wangdeming@inspur.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Murilo Opsfelder Araujo <muriloo@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: [PATCH kernel 2/3] powerpc/pci_64: Init pcibios subsys a bit later
Date:   Thu, 14 Jul 2022 18:18:21 +1000
Message-Id: <20220714081822.3717693-3-aik@ozlabs.ru>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220714081822.3717693-1-aik@ozlabs.ru>
References: <20220714081822.3717693-1-aik@ozlabs.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
---
 arch/powerpc/kernel/pci_64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/pci_64.c b/arch/powerpc/kernel/pci_64.c
index 19b03ddf5631..79472d2f1739 100644
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

