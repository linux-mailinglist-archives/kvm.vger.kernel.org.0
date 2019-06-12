Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA6DC42D0B
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2019 19:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730771AbfFLRKG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jun 2019 13:10:06 -0400
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:63229 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726384AbfFLRKF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jun 2019 13:10:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1560359405; x=1591895405;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RGV2nXv0tDBodUuIHbEss/S4uQOCZyMq1lOqu82Edzk=;
  b=fUzZrGvA6Fc5l5xPT60CAit2NcoQyNcptxu+f3h6FWfQFqRjf3sJRRJ0
   gmOawV7Nju6Yj2heEQBGIHtzbIry6rit8cIpHHoIfE70p1qYmtzIFKNGP
   9uFAtDEaxwFh0qTKR47oggejyyGkxtYWZeOl7yXtEnE42e8bBh7HfqE6Q
   w=;
X-IronPort-AV: E=Sophos;i="5.62,366,1554768000"; 
   d="scan'208";a="400444646"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1d-9ec21598.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 12 Jun 2019 17:10:03 +0000
Received: from ua08cfdeba6fe59dc80a8.ant.amazon.com (iad7-ws-svc-lb50-vlan3.amazon.com [10.0.93.214])
        by email-inbound-relay-1d-9ec21598.us-east-1.amazon.com (Postfix) with ESMTPS id 43F06A258B;
        Wed, 12 Jun 2019 17:10:02 +0000 (UTC)
Received: from ua08cfdeba6fe59dc80a8.ant.amazon.com (ua08cfdeba6fe59dc80a8.ant.amazon.com [127.0.0.1])
        by ua08cfdeba6fe59dc80a8.ant.amazon.com (8.15.2/8.15.2/Debian-3) with ESMTP id x5CH9x1s017050;
        Wed, 12 Jun 2019 19:09:59 +0200
Received: (from mhillenb@localhost)
        by ua08cfdeba6fe59dc80a8.ant.amazon.com (8.15.2/8.15.2/Submit) id x5CH9xNm017043;
        Wed, 12 Jun 2019 19:09:59 +0200
From:   Marius Hillenbrand <mhillenb@amazon.de>
To:     kvm@vger.kernel.org
Cc:     Marius Hillenbrand <mhillenb@amazon.de>,
        linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
        linux-mm@kvack.org, Alexander Graf <graf@amazon.de>,
        David Woodhouse <dwmw@amazon.co.uk>
Subject: [RFC 01/10] x86/mm/kaslr: refactor to use enum indices for regions
Date:   Wed, 12 Jun 2019 19:08:26 +0200
Message-Id: <20190612170834.14855-2-mhillenb@amazon.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190612170834.14855-1-mhillenb@amazon.de>
References: <20190612170834.14855-1-mhillenb@amazon.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The KASLR randomization code currently refers to specific regions, such
as the vmalloc area, by literal indices into an array. When adding new
regions, we have to be careful to also change all indices that may
potentially change. Avoid that risk by introducing an enum used as
indices.

Signed-off-by: Marius Hillenbrand <mhillenb@amazon.de>
Cc: Alexander Graf <graf@amazon.de>
Cc: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/mm/kaslr.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/arch/x86/mm/kaslr.c b/arch/x86/mm/kaslr.c
index 3f452ffed7e9..c455f1ffba29 100644
--- a/arch/x86/mm/kaslr.c
+++ b/arch/x86/mm/kaslr.c
@@ -41,6 +41,12 @@
  */
 static const unsigned long vaddr_end = CPU_ENTRY_AREA_BASE;
 
+enum {
+	PHYSMAP,
+	VMALLOC,
+	VMMEMMAP,
+};
+
 /*
  * Memory regions randomized by KASLR (except modules that use a separate logic
  * earlier during boot). The list is ordered based on virtual addresses. This
@@ -50,9 +56,9 @@ static __initdata struct kaslr_memory_region {
 	unsigned long *base;
 	unsigned long size_tb;
 } kaslr_regions[] = {
-	{ &page_offset_base, 0 },
-	{ &vmalloc_base, 0 },
-	{ &vmemmap_base, 1 },
+	[PHYSMAP] = { &page_offset_base, 0 },
+	[VMALLOC] = { &vmalloc_base, 0 },
+	[VMMEMMAP] = { &vmemmap_base, 1 },
 };
 
 /* Get size in bytes used by the memory region */
@@ -94,20 +100,20 @@ void __init kernel_randomize_memory(void)
 	if (!kaslr_memory_enabled())
 		return;
 
-	kaslr_regions[0].size_tb = 1 << (__PHYSICAL_MASK_SHIFT - TB_SHIFT);
-	kaslr_regions[1].size_tb = VMALLOC_SIZE_TB;
+	kaslr_regions[PHYSMAP].size_tb = 1 << (__PHYSICAL_MASK_SHIFT - TB_SHIFT);
+	kaslr_regions[VMALLOC].size_tb = VMALLOC_SIZE_TB;
 
 	/*
 	 * Update Physical memory mapping to available and
 	 * add padding if needed (especially for memory hotplug support).
 	 */
-	BUG_ON(kaslr_regions[0].base != &page_offset_base);
+	BUG_ON(kaslr_regions[PHYSMAP].base != &page_offset_base);
 	memory_tb = DIV_ROUND_UP(max_pfn << PAGE_SHIFT, 1UL << TB_SHIFT) +
 		CONFIG_RANDOMIZE_MEMORY_PHYSICAL_PADDING;
 
 	/* Adapt phyiscal memory region size based on available memory */
-	if (memory_tb < kaslr_regions[0].size_tb)
-		kaslr_regions[0].size_tb = memory_tb;
+	if (memory_tb < kaslr_regions[PHYSMAP].size_tb)
+		kaslr_regions[PHYSMAP].size_tb = memory_tb;
 
 	/* Calculate entropy available between regions */
 	remain_entropy = vaddr_end - vaddr_start;
-- 
2.21.0

