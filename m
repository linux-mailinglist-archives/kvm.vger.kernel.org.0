Return-Path: <kvm+bounces-13144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A32038929BC
	for <lists+kvm@lfdr.de>; Sat, 30 Mar 2024 09:42:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0F8ADB216A3
	for <lists+kvm@lfdr.de>; Sat, 30 Mar 2024 08:42:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B06D08C04;
	Sat, 30 Mar 2024 08:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b="Ro9ZDPi7"
X-Original-To: kvm@vger.kernel.org
Received: from AUS01-SY4-obe.outbound.protection.outlook.com (mail-sy4aus01olkn2148.outbound.protection.outlook.com [40.92.62.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B492D1C0DC8
	for <kvm@vger.kernel.org>; Sat, 30 Mar 2024 08:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.92.62.148
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711788127; cv=fail; b=UnoDwBxmszj93VJH0T5viO1oWdujGz/qvkxvRJcdctqe1xvi2fzZEDqP2algde/GTOV38QbCQUC80zVlpPrVybZvgXXNVD4OJqhhNDgV2mIEJwDOi8nb9B7lif3Yl/zbdut6Wqih9nM6vzFqgGI2dDTXctNUDa+0mUnyqX81kO0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711788127; c=relaxed/simple;
	bh=f75gNNxWuDV3tY1mKVNSxMJV8cebMGH1YF/nm9RtP6g=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=lF67GJ/wCAdJSiT2nNH9nTtfbZpT7gLXZuL3YJnPsc5hmkj/u6wYP9DhvPQQdLObrBqYxmvd3QWxbkX+CvJYayo4BZ5pX3v1kS6puY6+PsMv3yGL+QHh+qO6c717xmRXKwjh6TrLrVK+PaqNUKKiCYDeUHLKifov8RzUgPjZP4I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com; spf=pass smtp.mailfrom=outlook.com; dkim=pass (2048-bit key) header.d=outlook.com header.i=@outlook.com header.b=Ro9ZDPi7; arc=fail smtp.client-ip=40.92.62.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=outlook.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=outlook.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BINSldr/39f+kmHTZNvHVHiJLeIcNFDBxR4hTbTlOk+NRLBfX9RGDjJG5xQ9UsdzZrk4B9op8TDcsAj8kvn+i2/TaLuz1TKpZDx0f/bT8p2iXgb19ueiXeQH7vifl31Tj03HyRA7Osz/cvCeZe7YbfrPf2jL3fEa/Udn0qf4foqNaFXFT1Sq8aqbGoXkMAxTTdftiLjNiD7wNOHFw4wYts1nn3j5eY9aWTqeBno3D/bQfT85uPFLKMeWaRuDAdBZgNOmrNq5sZlb3H9VbdlnLfxR6PIMq5sIk4KdfDECX7KdDex8Ah/LxKXVEKHISD5eVISvIu5bXQiI/p/Nkkt1VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H0ISCWZP1VbGz7NJ1ZwrXAU2Ym67thwK+z0d58nijrY=;
 b=oDEvXL6cjJ2DgHsS1oHBYSl8gGE+AREg+78lHiWyIzoTMPs3oX+YVVWVlPpJatHOHgI9dM7ckqDH+gZbv88QpE4NWf4hN8qxA2E70lQoKJk/kfPyX/RMfzVx8AJ7X8pXbN0krS52+g0IgtM9np49TS+5H9fWC0WLmKGACJkbWRWTLFjCuB9ftBVGmoraGQXBf3suPtW/KjC2HWrd3cHTq65fip9DBxB7G1mfaGQXfzGEaBKf7zk1GyhWJKxHySb7A/HNgBBo/V/iVxHhRAreGj6y7iTIPlkw4xuiSh0jDfA68gGI9JQB9G/dmzDY9fLAKgq+KH16pbf62OKGEVCUUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H0ISCWZP1VbGz7NJ1ZwrXAU2Ym67thwK+z0d58nijrY=;
 b=Ro9ZDPi7O/zWS8VAc+JSljydA6qo2A9U0GmNA2wx0/5YTHYoaCNgq3UDoh2WTb0tpId03SRB/1dlp+/3/pdUnpcN0sFe9f/aGsO02Gqa8htWJ9wLY/xU66EJ6N7P2Q3Jvus3RhxUtufL5Ebi1e+BleCQ8w3mL/xLPMIupfOoalpFxGL7wra90lMVUTIBbPwtWhG3dN1msRd8PfdzcaZVjZRQy4+PQ2OtVrxNhA9BUtp0U5va2YrQhYGeKElYWa8AWViX4queWL31K0igg71qsLQ2d1Jw4dl5PdJzNeXkndEF1t+9y0NpeKLKfOKdaGmEUYopFt4L6W0wV3LNyNiuwg==
Received: from SY6P282MB3733.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:1bc::5) by
 SYYP282MB1039.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:be::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7409.43; Sat, 30 Mar 2024 08:42:02 +0000
Received: from SY6P282MB3733.AUSP282.PROD.OUTLOOK.COM
 ([fe80::d207:a033:8a13:9090]) by SY6P282MB3733.AUSP282.PROD.OUTLOOK.COM
 ([fe80::d207:a033:8a13:9090%6]) with mapi id 15.20.7409.042; Sat, 30 Mar 2024
 08:42:02 +0000
From: Sicheng Liu <lsc2001@outlook.com>
To: kvm@vger.kernel.org
Cc: will@kernel.org,
	julien.thierry.kdev@gmail.com,
	Sicheng Liu <lsc2001@outlook.com>
Subject: [PATCH kvmtool v3] x86: Fix some memory sizes when setting up bios
Date: Sat, 30 Mar 2024 08:41:49 +0000
Message-ID:
 <SY6P282MB373318D6241D56E074B040DFA3392@SY6P282MB3733.AUSP282.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN: [nRckLqyPAJcOnnIj3TjGBNv6g5rXI7Kp]
X-ClientProxiedBy: PS2PR03CA0020.apcprd03.prod.outlook.com
 (2603:1096:300:5b::32) To SY6P282MB3733.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:1bc::5)
X-Microsoft-Original-Message-ID: <20240330084149.144280-1-lsc2001@outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SY6P282MB3733:EE_|SYYP282MB1039:EE_
X-MS-Office365-Filtering-Correlation-Id: 2eae3d6e-1fdd-428d-6f7f-08dc50954505
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	5WbwJr/ZMYuva66YHD3fx0X1j14ub3zMgkivlB2JaFeH4CsV1YexPE3l2nDSzJqjn1BS7RSdLhS/Beqi0g7crbtbx9GdB0LF4i61ALhNpWJS/0s0YTmidL4uB3FC6XPWNGjyquoxGgGCeJW+YwBkRNY93fey5hYhWMbYZQgU2sH/ZLaEBr1I7nW8HPy4PwO+NcU7k+2wmzvLgOXFwkzPVkaPNu/N34KUjnO0z/54Ku2Y6wZF2n5lMAWq0QgIRXO+ozxqiNGUVbS6MqJ1K+AA9FOJy6jo8BY+WTE9kZmDNwrwUFlLPjHDuxLQVPvQ1n6q2KHSRXkmnjJd3mNjuKTxxHIT4VFqaHQek3FvR6sc3ShgsoHyw7JXEFJlpXzUBOhhgvIDT4C0OTTOL8nr+YvEl26WikhJVEiPSxMXXaPEk0RULw7vvnWpBsxZpKhqHiLdSuoYHCpLKiDKvvjdOnWP8Jt+aEBzJINQ5pQFwWA8bYGV+zClUH6qz2zTE3eSc73pI/uvY3fbrD1EdNajYYlne+hyo9sKUlGmOMxYZrDWtBfjvJ9hdbBz5z7C80735FCmI4hbo/LZuV+7eUWDFfNIBXcGJYeaHFGzaIS5XrIq+mHj3Gt6NUn8JyOFXeCVUfSA
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pBl7gKtncnz17xflyI9it80+uO4GwACoDxp2bn31YnJAh2u3qrsYCtZa9Gde?=
 =?us-ascii?Q?LGt0sKYBmK/Q62ZnDL2DAckwdu74wR8a9dNJFksP1cCtZmdnNYyePQR+QPbo?=
 =?us-ascii?Q?nnO9TN7cvcGGAOfzyqWji+jZJ0EsBKtuHiSXQplp1iEgq0VjRXdeliX7JiT7?=
 =?us-ascii?Q?kcefI7rS1hKKDJA1HfU0wysWjWek43pev37OKtQLcCsRgM+/qs33ODTMjUUC?=
 =?us-ascii?Q?aO4gvecFqWIDr/uWIl7A5Wxn+0pk7shb0yL8ct2DlAogzGGcA5xJ3Ag4HftW?=
 =?us-ascii?Q?e/Ffbp9iWcQUod2/EpaZDaH3iJ4BbHkhCV878EWlpT7szZSoryCTB5yxq7d9?=
 =?us-ascii?Q?LrEAUHqLD3njU5q1xGxYLj2W+yzRNnePg7KU+/CLc3yrt+ONqm7ylyGha8m0?=
 =?us-ascii?Q?kQO2+9ICdrtp7nud5hA7I7FlKY+DCe8fuKJot1Z9BqIA1TVeQhijyLW1CFuf?=
 =?us-ascii?Q?xFXzJVCBRqEAj6+lGiKJgcf/6j4u1V2DPTZE4IzGs4a3jUEGLc+jzi8S8U6U?=
 =?us-ascii?Q?a+ywoMpU0OLHHo/dZZ1RQFiwt+9NNwAq3BUngv5EGbDxVAwD1fpuNAonAah0?=
 =?us-ascii?Q?fX7Q/XwtDVCvSch9txrwWD+kgOnDIIIHmeRwai8Y8sEmNzr3L8V+1SSk7vul?=
 =?us-ascii?Q?Z8J1fuKkpeEngYi2FcsehewO7L6fjxGeWqLPDediDJ8x86loLugMvKG9N5ye?=
 =?us-ascii?Q?xFly812Q5sk4bhLT1bx56SGTHpfO6COrdzATbNivwb39oysBDYFuAj2ZHodu?=
 =?us-ascii?Q?PjaYifwTS5bxsO9FbemYO61NljZAhIZHhB1lR4X3eU09I2Bjvo2K7Dmue6hN?=
 =?us-ascii?Q?WNppcBEa2G96PwUtmCpxgYg4Ib3Uba39OBxlrvNJLBvBtYSUXmopgU7Jiz/B?=
 =?us-ascii?Q?RqexKi64zY+/DJPA9J/CgI3j1u0LTDiYDO2+bvESz+hnPYNzKbmwbfUwF2Q6?=
 =?us-ascii?Q?G/TZDM3Y3k2XI/sWRrC3vv3a8Tuf6u59Ieq0E1JaEyMKWLsMtEOIf5Ov2tXY?=
 =?us-ascii?Q?Jn393jqoVmE3sCaLNzqDnXcjM5CvYRlOgHw5iNvpVw9So/M8TZiSTfCNN2zF?=
 =?us-ascii?Q?77RLaAupe+urpqYLX0W3xPM2r+krGj3HM6C9Oe4L9qk1uCjlB63AX4bGWxoN?=
 =?us-ascii?Q?QdZMDKY/ktmXYzk/Pi4r6Xo14fK3jO8r5/9JkQaAFbswGq0p5y2TfiUv0bvk?=
 =?us-ascii?Q?LzjyaABi4gcogCeM05a0o9sHr7l1Z0HfKhMWi3tsExRtROlMXCUpX8ugIfI?=
 =?us-ascii?Q?=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2eae3d6e-1fdd-428d-6f7f-08dc50954505
X-MS-Exchange-CrossTenant-AuthSource: SY6P282MB3733.AUSP282.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2024 08:42:02.1327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SYYP282MB1039

Sorry for this resending. Delete redundant auto-added header "kvm/bios.h".

In e820_setup(), the memory region of MB_BIOS is [MB_BIOS_BEGIN, MB_BIOS_END],
so its memory size should be MB_BIOS_SIZE (= MB_BIOS_END - MB_BIOS_BEGIN + 1).
The same thing goes for BDA, EBDA, MB_BIOS and VGA_ROM in setup_bios().
By the way, a little change is made in setup_irq_handler() to avoid using
hard coding.

Changes since v1:
- Adopt Will's suggestions
- A little change in setup_irq_handler()

Changes since v2:
- Delete redundant headers

Signed-off-by: Sicheng Liu <lsc2001@outlook.com>
---
 x86/bios.c             | 12 ++++++------
 x86/include/kvm/bios.h |  3 +++
 2 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/x86/bios.c b/x86/bios.c
index 5ac9e24ae0a8..0f8dd2415a11 100644
--- a/x86/bios.c
+++ b/x86/bios.c
@@ -45,7 +45,7 @@ static void setup_irq_handler(struct kvm *kvm, struct irq_handler *handler)
 		.offset		= handler->address - MB_BIOS_BEGIN,
 	};
 
-	DIE_IF((handler->address - MB_BIOS_BEGIN) > 0xffffUL);
+	DIE_IF((handler->address - MB_BIOS_BEGIN + 1) > MB_BIOS_SIZE);
 
 	interrupt_table__set(&kvm->arch.interrupt_table, &intr_desc, handler->irq);
 }
@@ -75,7 +75,7 @@ static void e820_setup(struct kvm *kvm)
 	};
 	mem_map[i++]	= (struct e820entry) {
 		.addr		= MB_BIOS_BEGIN,
-		.size		= MB_BIOS_END - MB_BIOS_BEGIN,
+		.size		= MB_BIOS_SIZE,
 		.type		= E820_RESERVED,
 	};
 	if (kvm->ram_size < KVM_32BIT_GAP_START) {
@@ -132,16 +132,16 @@ void setup_bios(struct kvm *kvm)
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


