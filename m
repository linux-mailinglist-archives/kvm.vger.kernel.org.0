Return-Path: <kvm+bounces-58052-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F9A9B8734F
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 00:12:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 297FE62001C
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 22:12:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BFF52FD7A0;
	Thu, 18 Sep 2025 22:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="y3mWQVNa"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012025.outbound.protection.outlook.com [40.93.195.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947822C0280
	for <kvm@vger.kernel.org>; Thu, 18 Sep 2025 22:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.25
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758233544; cv=fail; b=FXbDCSpUNcBY5Nzc2Wwyc2j2NJ5OmELQSwSYw8lWAQpQ6s+BJ2Pu3z2Slz/YxPbex2rkYNoirQC+goueYpOit1Xw5V2DKeHyRmdutoFFqV3Dp/WPHTAvTzdO3uahVLbkarwd8wylD2qj9tyLZqqx/zUdcgU2izbK9HXuvltrWgY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758233544; c=relaxed/simple;
	bh=vHXTbBLcHEyefgsuDOuwM35b9UG9e56Rj1vgRzke4Nk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=A6c2bbqm9h1BiKg6+97JiwkkrzkvNCfQX0TDkJ2EprLobPgO5mb50jHwwadWztq0hF2Aoy9CEoK4Caa9558RCsdwKU+V0bMZRwOG3egL72xdZzWU4jEI1SprhOBCKUtscBKRkVBnzrtVPTVgSeBfsmOGQl5BjpERo39n9KqEjko=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=y3mWQVNa; arc=fail smtp.client-ip=40.93.195.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ngOGox4mL9C45QzfoamUwtwfVSLjYgBDnIOcxD8Uo1IKnqB3ils0B1rwx4TvrZlqgVBt46H/hUSBoWfh9o29294Z1nF5T5dGTm1wsOQBkPM5MrUf6A0eo1ubu5zaqBL+NAXvquwx2ZJ1k4iuzO9qCDgJvRuE3ju9ANlaqyEujKldhPafaHNkDFTEO1JjHRdskLG00wlwSwW+zfqg7/2wpempmySBEoyUtEI3Dp0eXOBEw3QHqVU5+wLhz3cqcLQWdX/Wti+HMvu62ozD2zoOMHKYQC4QZHUX8LqNIxFMHtqhGg1VeTXAWlDmoNVAc+wYvOYXA0VNnTfnIC4T6Yp3Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CvPNNl9Uy092Wcy1DyFBMKz43zkQY92/ci19FMEkdeg=;
 b=zUkG7nGeCR9SaZtFfZMakGBWzYf5NMJnycEb11zn5yIwrUENjhfoy5jquJPLgWGV3mKNUMPP0BWcwNyRADYMGkKLG1hagFEcissqpvAZ7N3FDhBr1j4404wLZUe9kkB/705/rTAayds0stxL+2hhEk2Zu31jyN174R++sp6iPBgjRp4gXLB5Uq3RmImfzZIUxSivbQNjXqMeuCvKH0EuWtaT0fvAggkSfGwfw9DBBydTdFwdyYHMgBrXSIiszFSUlyECDWB3eg0uwshdIk+55002ppaMEOR9O27iPf1qm1YFYX5Tv71A96/fHzLkSYSLdOVCa4RNTNXyeYLvdzZ+bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CvPNNl9Uy092Wcy1DyFBMKz43zkQY92/ci19FMEkdeg=;
 b=y3mWQVNa+UZqyphRlwrVVLj9+lJWmtC8OTC9LN7WpbSRCKadsodGP9EjAn8kP6lTWIz4pNBfe/atH0RoCGxttrPiNBTd5vNQbUDKP54hp4tk4oUmE0Wvv722T+aIZFO7QsdO1duElb0gKp4QO+jVu0MjMjn5fD9V7+mUtQ/j1j4=
Received: from SJ0PR03CA0274.namprd03.prod.outlook.com (2603:10b6:a03:39e::9)
 by DS0PR12MB7927.namprd12.prod.outlook.com (2603:10b6:8:147::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.14; Thu, 18 Sep
 2025 22:12:19 +0000
Received: from CO1PEPF000044EE.namprd05.prod.outlook.com
 (2603:10b6:a03:39e:cafe::92) by SJ0PR03CA0274.outlook.office365.com
 (2603:10b6:a03:39e::9) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9137.14 via Frontend Transport; Thu,
 18 Sep 2025 22:12:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 CO1PEPF000044EE.mail.protection.outlook.com (10.167.241.68) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9137.12 via Frontend Transport; Thu, 18 Sep 2025 22:12:18 +0000
Received: from ethanolx7e2ehost.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Thu, 18 Sep
 2025 15:12:17 -0700
From: Ashish Kalra <Ashish.Kalra@amd.com>
To: <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>
Subject: [PATCH] accel/kvm: Fix kvm_convert_memory calls crossing memory regions
Date: Thu, 18 Sep 2025 22:12:07 +0000
Message-ID: <20250918221207.42209-1-Ashish.Kalra@amd.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PEPF000044EE:EE_|DS0PR12MB7927:EE_
X-MS-Office365-Filtering-Correlation-Id: 123b661f-1fc1-4f8b-dd3e-08ddf7006ecf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|36860700013|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1e+ZnUi3bfkji3Le0oym5TlFFQOFLc/TJQLtwGL7aPDp2JJ3Tukjl31Zl8Sb?=
 =?us-ascii?Q?CdolayYJ6y4ur638F+pxhI356r72HaZMMHT4rQkF8yL8C+mePOz4Um9jcYw1?=
 =?us-ascii?Q?egbohkxUFWzyxqsWZac3oQqgANPvCgLf7JSEG2Bx8NCNjR1Qles5USD5JN9k?=
 =?us-ascii?Q?XgsGO2stCQBwqX6tZdnLUx4CzjeKRwtSpgyKwT89+pPuLtITgarZcrLlP3bK?=
 =?us-ascii?Q?XNvNfBFRD+eMDSVjZKmBj8XyTxpgUxDxf1X1iaMIkUj2lp3N5/YZgAbpjGlq?=
 =?us-ascii?Q?UfJiz5ETffgpoeHQyIBK4ETNbyF3in1rC8n80GFoWBOtiF3vtJUjRJi7wNPl?=
 =?us-ascii?Q?EYnlkGZErQeY6LSIqo7Oe5Z3N256TvjZM+Gd9KBR2fojeqzlHoOFOUpdPeqh?=
 =?us-ascii?Q?eUKHp9Ap3mTEkHd76lONrFktXUA2Vo2g+s2UpLn231rwO5vYeBI0RaeXu7oQ?=
 =?us-ascii?Q?YN0jU1JwVn7kr54YZpfgaoUIfbreJ2JzT6xuinE3PqnApDWmAeIVzvSZ/Jop?=
 =?us-ascii?Q?HwokpsTLjCcam0nSzI8ccYfZjBVFyh71DJEmuUO7B5H9YrT78VPOwp5vUuiU?=
 =?us-ascii?Q?ZDhCgBE94IDkAlMkXjdCvVnp/wMdvPvE+PpVqOtcKl1mKLsQUQ19KO7ZHjdP?=
 =?us-ascii?Q?vC7vbQRK10PJ6cjbDr8Lcf9i9wQbBkUefLSKbR9D8WzX6zT2PBhoJiBMzY5D?=
 =?us-ascii?Q?QmtU3rNFk1p0WuHq9/wcMzm3NTS+0ETaRePpv7IO9eFYgxmFQiLJqvmsL5ms?=
 =?us-ascii?Q?j6uwoAdCp7mGO+uyq0+z7Kh6qzBLtStdc97i3IVc24BTrjOhgfwH2sDhltUj?=
 =?us-ascii?Q?hWEGfsS284it4AtuZBb8WCZecRhXP44XrSQ0LbAVr+fuIUOjVKeHQ81DH3HF?=
 =?us-ascii?Q?bKl6jJDoc8yUXSi7MGLEbdI2t83bFYY+U4ofq7Y8ypBquTj37VyKZ1kNwhHY?=
 =?us-ascii?Q?kZuljEZta488WokUFw6cCfSfkMxsi3KZN5eKVvW8/Y7WQRhXdwunQoUNqEa+?=
 =?us-ascii?Q?auWgohb4JqEUoQX8G9XZ3bDCilIg1nI+KZym7nCEAl4c7Z4q19OZTGlBV7HK?=
 =?us-ascii?Q?EnnV8GyEtJKVvuRCAPxufRZP++GKpV+TRdLih+S5xXHqIUgFXhE58SuULmGe?=
 =?us-ascii?Q?dkbbtyhfzRY07uH8FeBeFYX76KJF0OVodsp0Ot1PhxzmXBkMCNH0l8ESesnq?=
 =?us-ascii?Q?OiO8cgvnN8Kju5PR8i+/pphkIJqKzAQvEF/xZvqReyOplKo+gLtDdgFwxIua?=
 =?us-ascii?Q?XUo3QTkVgLbyJ1J+CJC4c2xhEQHLlughVnk9+dwwGzbEekCSLVJfYmT2+FE1?=
 =?us-ascii?Q?/7EIAevyyxv/qdA+tkUrBVN+a3yLTyO9sf+p1AMIVXHRrEXcSFraAIBqy6V/?=
 =?us-ascii?Q?cxT41E7rbWPGFuGDVCRRaEl0J7ZqgFbQqNkGoiWS+RyaBTztNIb+BY3hyWwE?=
 =?us-ascii?Q?hJkiFdLc3dWXoZxW3Y5/wznmyg6rubxgYv6wlMQ6E/gVrRaiKa74oPgI7FJ5?=
 =?us-ascii?Q?dEAe4x2HL4Ri+QQakVW0PSZLsngg0a5PMzAD?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(36860700013)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 22:12:18.6313
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 123b661f-1fc1-4f8b-dd3e-08ddf7006ecf
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1PEPF000044EE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7927

From: Ashish Kalra <ashish.kalra@amd.com>

Page conversion call can span multiple memory regions, potentially
resulting in a conversion failure if the memory range being converted
extends beyond the boundaries of the referenced memory region.

Handle the case of page conversion call straddling across memory
regions.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 accel/kvm/kvm-all.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index 9060599cd7..54034a0568 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -3054,6 +3054,8 @@ static void kvm_eat_signals(CPUState *cpu)
 int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
 {
     MemoryRegionSection section;
+    hwaddr convert_start;
+    hwaddr convert_size;
     ram_addr_t offset;
     MemoryRegion *mr;
     RAMBlock *rb;
@@ -3071,6 +3073,11 @@ int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
         return ret;
     }
 
+    /*
+     * Page conversions can span multiple memory regions, for example, if two
+     * memory backends are added to support two different NUMA nodes/policies.
+     */
+next_memory_region:
     section = memory_region_find(get_system_memory(), start, size);
     mr = section.mr;
     if (!mr) {
@@ -3121,8 +3128,12 @@ int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
     addr = memory_region_get_ram_ptr(mr) + section.offset_within_region;
     rb = qemu_ram_block_from_host(addr, false, &offset);
 
+    convert_start = section.offset_within_region;
+    convert_size = (convert_start + size > mr->size) ?
+                   mr->size - convert_start : size;
+
     ret = ram_block_attributes_state_change(RAM_BLOCK_ATTRIBUTES(mr->rdm),
-                                            offset, size, to_private);
+                                            offset, convert_size, to_private);
     if (ret) {
         error_report("Failed to notify the listener the state change of "
                      "(0x%"HWADDR_PRIx" + 0x%"HWADDR_PRIx") to %s",
@@ -3138,9 +3149,15 @@ int kvm_convert_memory(hwaddr start, hwaddr size, bool to_private)
              */
             goto out_unref;
         }
-        ret = ram_block_discard_range(rb, offset, size);
+        ret = ram_block_discard_range(rb, offset, convert_size);
     } else {
-        ret = ram_block_discard_guest_memfd_range(rb, offset, size);
+        ret = ram_block_discard_guest_memfd_range(rb, offset, convert_size);
+    }
+
+    if (size - convert_size) {
+        start += convert_size;
+        size -= convert_size;
+        goto next_memory_region;
     }
 
 out_unref:
-- 
2.34.1


