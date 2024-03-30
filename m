Return-Path: <kvm+bounces-13143-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E94328929AF
	for <lists+kvm@lfdr.de>; Sat, 30 Mar 2024 09:22:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5FFAEB224C6
	for <lists+kvm@lfdr.de>; Sat, 30 Mar 2024 08:22:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE93A883C;
	Sat, 30 Mar 2024 08:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="rREIqdkB"
X-Original-To: kvm@vger.kernel.org
Received: from AUS01-ME3-obe.outbound.protection.outlook.com (mail-me3aus01olkn2175.outbound.protection.outlook.com [40.92.63.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71FBB66B
	for <kvm@vger.kernel.org>; Sat, 30 Mar 2024 08:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.63.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711786924; cv=fail; b=TGXokbD+UrCyxL4U4EWvDZAqAHw/68pPntWNhVrGRaijNXxmf35YjCyz31+djAH6v7x1GDPMXo4n1ZGupOEksJ4wJM2l29NtdLwOHie9UtkZFQTxPV+maK2gzMCH7KMKGbsnk5GS4R6Jx8HAFUOapspK0BGWoerLJgFNDurFhrc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711786924; c=relaxed/simple;
	bh=V1DBkVUK2mIDL9T31t+jZi3EgsYXtXUzAvPWyE5/9gs=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=s4efu+PZvo0ncNsT4Y61pHvRQSugo+Lrit6wkAFRViCVCXIlOp3bp5b3VNOJgOjff+JJRFr4+h4N+k/r64KqQbR32EbkZXnd0tHm85nD8Ry/I0Da/mQyq1Tf83UN5XlDqMGjoTtro41qpCsWaqAnXT4ZUHHfikrjWOrArV1hzCc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=rREIqdkB; arc=fail smtp.client-ip=40.92.63.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XCtLa5Tx2KXxO0yjWQIMJvFOtrp9jftaFJNCAsgtWUUX3VMLDEQZppDgTOAPbmrKJSUgdhYZA9xMHjadOrcipjaFK/0RQsFtg0da0YzXuFhvjZaBS9xeZ87q/bmOXlBLktVm7tF7tgUZil7XCzdZqeCL2oyriY8A9Bq4D0soS8SBICAHjTKMmrBBTwQAF0TcZ10krPqKuCSJmS4vcngCrmy/ATyhtwNpWmrhvDlzhDBDn1KsPjYZ/4wShm6KYu8SAZhPTClCezC9u+KgfiVZT84R9o82LqFmN5HQ+Yl2DGO0HOzJ/q5aniAOx3wieaJwyBDLD0s0CKLKybRot1Bsrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8QwNNOxKgQ+gkrpfb6sJ8RKpfrB4ExwIld5U2FE5emQ=;
 b=k+DjZHLaTEH0qDABzckFUak5wANBpDXkilwMi8MPCbRL3A7IR7sDBHwqQf8jhDkU2W9ACBwtUP0UzSYoPIGoTtgsK/4m7l3CPwnyuBAsPjXdi1HKYw8WzHN4KNzYF8AbW+/uxota7hIdf1AXl20GpJJTkobp3fkQ959koPAbBhcLz2Hicbit/v1COz4qpiQxv5y97G1oyaOalHVQTh1X1MkOpjePLKWXRn07qZ8WgMXB8f/p4Smvo0B+LWmwnl3QfoOI8iyr7WR9ojgDVp2guPsiaGR4W4AjV1vkz+TpyjUm2x2SbSoaQwQWseoMW6n/1dL/oAqBh3NLFHixeBxGlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8QwNNOxKgQ+gkrpfb6sJ8RKpfrB4ExwIld5U2FE5emQ=;
 b=rREIqdkBxbfTvaCv06g/DYG+ePjUMsk3jy2K+nBKGJ8WNQRczGQrlGBa2AkyKc0c56xf/byXmWINSiD8wVCTHZcyXFvDLtFOm8WYTZ4BezSLzJT9a3V2TYuAa4M5LcaApQaAM06exor8uOSdPq3/Rvno1ThRiRecwE+72nyGY4sx89t9O3xQTttsF3SMFiAWD6qsB2ZhQNjM1UroxeSRXVQog8zOCnNYdyOHHEYYEUQNxRBZSxpOgydJr1jGw2wMeSxj65YU8030HQ+k4a15j0w8aeEgYfs8NCpJEdFt3V2VhPV9wtztSbT3ie1uup+wxu25HvEtAwtAN54HUsqwRA==
Received: from SY6P282MB3733.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:1bc::5) by
 SY4P282MB1449.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:c7::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7409.42; Sat, 30 Mar 2024 08:21:59 +0000
Received: from SY6P282MB3733.AUSP282.PROD.OUTLOOK.COM
 ([fe80::d207:a033:8a13:9090]) by SY6P282MB3733.AUSP282.PROD.OUTLOOK.COM
 ([fe80::d207:a033:8a13:9090%6]) with mapi id 15.20.7409.042; Sat, 30 Mar 2024
 08:21:59 +0000
From: Sicheng Liu <lsc2001@outlook.com>
To: kvm@vger.kernel.org
Cc: will@kernel.org,
	julien.thierry.kdev@gmail.com,
	Sicheng Liu <lsc2001@outlook.com>
Subject: [PATCH kvmtool v2] x86: Fix some memory sizes when setting up bios
Date: Sat, 30 Mar 2024 08:21:28 +0000
Message-ID:
 <SY6P282MB3733CDCCC1B9B2A16FFA2975A3392@SY6P282MB3733.AUSP282.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN: [Stx5kCSoaTQmq8kGgEnEIJJ1pEWjdTFp]
X-ClientProxiedBy: SGAP274CA0017.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b6::29)
 To SY6P282MB3733.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:1bc::5)
X-Microsoft-Original-Message-ID: <20240330082128.142075-1-lsc2001@outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SY6P282MB3733:EE_|SY4P282MB1449:EE_
X-MS-Office365-Filtering-Correlation-Id: ad064523-489c-407a-21e0-08dc509277ce
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	9C7r8LKzeHV/OYknLPz9JhLDqz22CzbReHFhcL3Oy6eirLPWNYj7BC3BK/HLoytk2k/2l3rW85o3BJCi5YqDw6gc8TGZ8V3emHmK1s1anbBeOOQTXDIL7sKAowoocl6LvBJ/pT56xLfJZbmKdb0hWiS61gykUHtxhr+O3WUy3IdUQ9CbP3b+w+rSXM6Njt/FDHXiV83mJ/p6H5vmk9tkbmaCMeeFlBAjTjB/Jp2sGCWEpIsZk/vY+yQ4XQhVjwrRGrlXHzTCYDM3orUVEl2GaWQo4lsfcizuY/nKARujISsbjfoNyQ2p2Ngnpw6NyDiZ0Masvet2QL1pgYpEUB5kOGR8KPA1iz766HIu/iOEMwLn22j0C27BnWsWe+SS2QvT5RILPk0PXs/GjsjaeGEQs+tKELYGZHuQGueSSPHjgnReHqCLakOCipvhVNhYu6VQoffLrr4AGvcNCHLYKhFSbphrAxuM4yX8RnPEUcEcgODU+FBbLwvrjj6RGF+neFlFAypYrQOzHmTQ0AYXhE8EBu365TAd+u3AZGBqXIj498YqiqZM7owDbsFLjW1+WbLAAq9hKngtmzpf060cdT3vzUEcksqe5e3waEbgJ40nfRb6XPsxRBey9mhJChyD0rhr
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KVNj+kXY4k+xX1azV72ERum3sdKvtPSCKeKLYfGqNL+bKfo53w0UbzJ954DZ?=
 =?us-ascii?Q?3y6z8+to+bQdPIqGqcl//mJQ/4vNeJuPx3MceHQyViS/+cvATHXZaXyYkHN5?=
 =?us-ascii?Q?9Y44B27zn5+rUCAIAYZT7EJWmxpI0Kqz+Hn5k4Ms8PL9hNh2BnftwMO4jFPu?=
 =?us-ascii?Q?YQdibwhOoh5yxxbEnr4sPrqiMEfzlcN6fl+VkR9JbYtvlodMDNueCkKiWuOP?=
 =?us-ascii?Q?AjbZ98LpB5xxX3YTgl0QgG7E4YXU/FQ2Ztqm26waxERSZk2kFxqKL3y593Le?=
 =?us-ascii?Q?SN0DZvUn5/pPFFcZK+UlfE/lNfp0v54CQLVRkwQN8TWZrK0jX4TwZ1HhdU6l?=
 =?us-ascii?Q?nzrWl2I/0qGWQlsNsXBgPHrM9o4bz+La3Zq6vsYq7cJsGSDb4UbHyKTbQe6l?=
 =?us-ascii?Q?CoX1GapUT5li4lJbNQrFbBaixT0L65kanjzNFYjzpU0EtMssqy5+0HPUCfNo?=
 =?us-ascii?Q?1jJi5fQVXcjlEFkhSdFes8MrUHpQKGfX3EZgqHr+JwY5dUcwUwVWRvPjln98?=
 =?us-ascii?Q?fvTBSBCmWgb+eed0CrXizODUL+iOjlCWctdeTJGKQxsFVfE93ApyNnDRH+5w?=
 =?us-ascii?Q?4VMgYJSGHw6inIi44XOWy04QQX4Zrs6lYp/6RfbgC/HtseXU2fFo/RiWsxTD?=
 =?us-ascii?Q?WtiqgSoy/sP/htSGrRKClhFwimtdYnco0x+fV3VTbO6AkYV2lHaTIVnV6VOQ?=
 =?us-ascii?Q?Ob0B7KLJMZepF7pZBkfs4E3uN5mBolc0e03h46RSa5BcRx4WSMvi3j+ZyZsG?=
 =?us-ascii?Q?yDAm/Fza5UnELtfhKyyD9ybka4f0hrvAfDirqPLBmuX07iQbpewpB8H5DfIl?=
 =?us-ascii?Q?sxVtbbZ9oV69r566KazNR+cPcrKI/65xCPH2vwVyO+S7cOT0eAG77H3xST4T?=
 =?us-ascii?Q?IzCWyVGeAFR7y5sU3W4Hmw4VDPIgwJVeX0uXJz4WeUqxICMAJHO5T8LEoJmG?=
 =?us-ascii?Q?6ooGPdCJzLH268IpFXywQqmPxitY+o5hjQtTpJUjy2+5tafaj+fyUGCCUAS2?=
 =?us-ascii?Q?/xSS10jtZp5gVHgi4tJYDx4ZQd4SbxeiI77Yol02cfW7+wNhYm7lSf7PAygT?=
 =?us-ascii?Q?qbXIilOHbbHLSXUWDB0CSlNnHzoT3ZRYoY3HKiNfZVGGH/7439VuMF/bMwO3?=
 =?us-ascii?Q?DPE8RPqbtcM9o1bFX+tDIQEWR5ais/fkveHL9M82kMHLc4373s99Pw6tc7Hb?=
 =?us-ascii?Q?s2OWIVJ8jUC4WIGGNhofC92wcycW4ccReHoyzp4ftxc96srmeTPk7Rlcp1k?=
 =?us-ascii?Q?=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad064523-489c-407a-21e0-08dc509277ce
X-MS-Exchange-CrossTenant-AuthSource: SY6P282MB3733.AUSP282.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2024 08:21:58.9339
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SY4P282MB1449

In e820_setup(), the memory region of MB_BIOS is [MB_BIOS_BEGIN, MB_BIOS_END],
so its memory size should be MB_BIOS_SIZE (= MB_BIOS_END - MB_BIOS_BEGIN + 1).
The same thing goes for BDA, EBDA, MB_BIOS and VGA_ROM in setup_bios().
By the way, a little change is made in setup_irq_handler() to avoid using
hard coding.

Changes since v1:
- Adopt Will's suggestions
- A little change in setup_irq_handler()

Signed-off-by: Sicheng Liu <lsc2001@outlook.com>
---
 x86/bios.c             | 13 +++++++------
 x86/include/kvm/bios.h |  3 +++
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/x86/bios.c b/x86/bios.c
index 5ac9e24ae0a8..916fe7ddff46 100644
--- a/x86/bios.c
+++ b/x86/bios.c
@@ -1,3 +1,4 @@
+#include "kvm/bios.h"
 #include "kvm/kvm.h"
 #include "kvm/boot-protocol.h"
 #include "kvm/e820.h"
@@ -45,7 +46,7 @@ static void setup_irq_handler(struct kvm *kvm, struct irq_handler *handler)
 		.offset		= handler->address - MB_BIOS_BEGIN,
 	};
 
-	DIE_IF((handler->address - MB_BIOS_BEGIN) > 0xffffUL);
+	DIE_IF((handler->address - MB_BIOS_BEGIN + 1) > MB_BIOS_SIZE);
 
 	interrupt_table__set(&kvm->arch.interrupt_table, &intr_desc, handler->irq);
 }
@@ -75,7 +76,7 @@ static void e820_setup(struct kvm *kvm)
 	};
 	mem_map[i++]	= (struct e820entry) {
 		.addr		= MB_BIOS_BEGIN,
-		.size		= MB_BIOS_END - MB_BIOS_BEGIN,
+		.size		= MB_BIOS_SIZE,
 		.type		= E820_RESERVED,
 	};
 	if (kvm->ram_size < KVM_32BIT_GAP_START) {
@@ -132,16 +133,16 @@ void setup_bios(struct kvm *kvm)
 	 * we definitely don't want any trash here
 	 */
 	p = guest_flat_to_host(kvm, BDA_START);
-	memset(p, 0, BDA_END - BDA_START);
+	memset(p, 0, BDA_SIZE);
 
 	p = guest_flat_to_host(kvm, EBDA_START);
-	memset(p, 0, EBDA_END - EBDA_START);
+	memset(p, 0, EBDA_SIZE);
 
 	p = guest_flat_to_host(kvm, MB_BIOS_BEGIN);
-	memset(p, 0, MB_BIOS_END - MB_BIOS_BEGIN);
+	memset(p, 0, MB_BIOS_SIZE);
 
 	p = guest_flat_to_host(kvm, VGA_ROM_BEGIN);
-	memset(p, 0, VGA_ROM_END - VGA_ROM_BEGIN);
+	memset(p, 0, VGA_ROM_SIZE);
 
 	/* just copy the bios rom into the place */
 	p = guest_flat_to_host(kvm, MB_BIOS_BEGIN);
diff --git a/x86/include/kvm/bios.h b/x86/include/kvm/bios.h
index edeab17fdd1b..6f4338d50717 100644
--- a/x86/include/kvm/bios.h
+++ b/x86/include/kvm/bios.h
@@ -21,9 +21,11 @@
 
 #define BDA_START			0x00000400
 #define BDA_END				0x000004ff
+#define BDA_SIZE			(BDA_END - BDA_START + 1)
 
 #define EBDA_START			0x0009fc00
 #define EBDA_END			0x0009ffff
+#define EBDA_SIZE			(EBDA_END - EBDA_START + 1)
 
 #define E820_MAP_START			EBDA_START
 
@@ -43,6 +45,7 @@
 #define VGA_ROM_MODES			(VGA_ROM_OEM_STRING + VGA_ROM_OEM_STRING_SIZE)
 #define VGA_ROM_MODES_SIZE		32
 #define VGA_ROM_END			0x000c7fff
+#define VGA_ROM_SIZE			(VGA_ROM_END - VGA_ROM_BEGIN + 1)
 
 /* we handle one page only */
 #define VGA_RAM_SEG			(VGA_RAM_BEGIN >> 4)
-- 
2.25.1


