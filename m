Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9414F7D91
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 13:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238195AbiDGLJl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 07:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234265AbiDGLJi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 07:09:38 -0400
X-Greylist: delayed 94491 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 07 Apr 2022 04:07:36 PDT
Received: from mail.codelabs.ch (mail.codelabs.ch [109.202.192.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5CF75007D;
        Thu,  7 Apr 2022 04:07:35 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.codelabs.ch (Postfix) with ESMTP id 8AC6B220002;
        Thu,  7 Apr 2022 13:07:32 +0200 (CEST)
Received: from mail.codelabs.ch ([127.0.0.1])
        by localhost (fenrir.codelabs.ch [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id H1ereBzHd7rt; Thu,  7 Apr 2022 13:07:31 +0200 (CEST)
Received: from skyhawk.codelabs.ch (unknown [IPv6:2a02:168:860f:0:34fa:d8d6:c16a:a546])
        by mail.codelabs.ch (Postfix) with ESMTPSA id 6A8E3220001;
        Thu,  7 Apr 2022 13:07:31 +0200 (CEST)
From:   Reto Buerki <reet@codelabs.ch>
To:     tglx@linutronix.de, dwmw2@infradead.org
Cc:     x86@kernel.org, kvm@vger.kernel.org,
        iommu@lists.linux-foundation.org, joro@8bytes.org,
        pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, maz@misterjones.org,
        decui@microsoft.com
Subject: [PATCH] x86/msi: Fix msi message data shadow struct
Date:   Thu,  7 Apr 2022 13:06:47 +0200
Message-Id: <20220407110647.67372-1-reet@codelabs.ch>
In-Reply-To: <87pmltzwtr.ffs@tglx>
References: <87pmltzwtr.ffs@tglx>
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
Co-developed-by: Adrian-Ken Rueegsegger <ken@codelabs.ch>
Signed-off-by: Adrian-Ken Rueegsegger <ken@codelabs.ch>
Signed-off-by: Reto Buerki <reet@codelabs.ch>
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

