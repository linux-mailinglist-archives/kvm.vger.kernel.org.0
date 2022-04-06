Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83D284F5E1A
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 14:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbiDFMmW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 08:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231628AbiDFMll (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 08:41:41 -0400
Received: from mail.codelabs.ch (mail.codelabs.ch [IPv6:2a02:168:860f:1::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9263C188542
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 01:42:48 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.codelabs.ch (Postfix) with ESMTP id E956B220003;
        Wed,  6 Apr 2022 10:37:05 +0200 (CEST)
Received: from mail.codelabs.ch ([127.0.0.1])
        by localhost (fenrir.codelabs.ch [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id USzK58Cg8Xho; Wed,  6 Apr 2022 10:37:04 +0200 (CEST)
Received: from skyhawk.codelabs.local (unknown [IPv6:2a02:169:803:0:f7fb:8040:b3e4:bffe])
        by mail.codelabs.ch (Postfix) with ESMTPSA id ACB1A220001;
        Wed,  6 Apr 2022 10:37:04 +0200 (CEST)
From:   Reto Buerki <reet@codelabs.ch>
To:     dwmw2@infradead.org
Cc:     x86@kernel.org, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, joro@8bytes.org,
        tglx@linutronix.de, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        maz@misterjones.org, decui@microsoft.com
Subject: [PATCH] x86/msi: Fix msi message data shadow struct
Date:   Wed,  6 Apr 2022 10:36:24 +0200
Message-Id: <20220406083624.38739-2-reet@codelabs.ch>
In-Reply-To: <20220406083624.38739-1-reet@codelabs.ch>
References: <20201024213535.443185-13-dwmw2@infradead.org>
 <20220406083624.38739-1-reet@codelabs.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The x86 MSI message data is 32 bits in total and is either in
compatibility or remappable format, see Intel Virtualization Technology
for Directed I/O, section 5.1.2.

Fixes: 6285aa50736 ("x86/msi: Provide msi message shadow structs")
Signed-off-by: Reto Buerki <reet@codelabs.ch>
Signed-off-by: Adrian-Ken Rueegsegger <ken@codelabs.ch>
---
 arch/x86/include/asm/msi.h | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/msi.h b/arch/x86/include/asm/msi.h
index b85147d75626..d71c7e8b738d 100644
--- a/arch/x86/include/asm/msi.h
+++ b/arch/x86/include/asm/msi.h
@@ -12,14 +12,17 @@ int pci_msi_prepare(struct irq_domain *domain, struct device *dev, int nvec,
 /* Structs and defines for the X86 specific MSI message format */
 
 typedef struct x86_msi_data {
-	u32	vector			:  8,
-		delivery_mode		:  3,
-		dest_mode_logical	:  1,
-		reserved		:  2,
-		active_low		:  1,
-		is_level		:  1;
-
-	u32	dmar_subhandle;
+	union {
+		struct {
+			u32	vector			:  8,
+				delivery_mode		:  3,
+				dest_mode_logical	:  1,
+				reserved		:  2,
+				active_low		:  1,
+				is_level		:  1;
+		};
+		u32	dmar_subhandle;
+	};
 } __attribute__ ((packed)) arch_msi_msg_data_t;
 #define arch_msi_msg_data	x86_msi_data
 
-- 
2.30.2

