Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A06D2B5033
	for <lists+kvm@lfdr.de>; Mon, 16 Nov 2020 19:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727701AbgKPSuO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Nov 2020 13:50:14 -0500
Received: from mail-mw2nam12on2086.outbound.protection.outlook.com ([40.107.244.86]:42592
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726379AbgKPSuO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Nov 2020 13:50:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KTOU+9YCMrtygaUDmGfFMwe9C0uPpQmHMO1PUynpe9WzCrrip+gZh0sQ3wrlKumPnI3CDeCiHCOA0yMnBFxRSDE4sT4UudBrMoyDsGK3y2kh0YBdHRGRwKJcFONze5buux8CmBf31V0byyPouCyyTaQ0CkozyLo2TgaAiiwr57FcK9rQJCPYnGAFbohse5VTD1M84ohKA8nBICfLPahTPPdZR8GeGDW70FMumPUgakeMesdvw8rbe/Y+zkjrwMkkLFC0e6wXVFBuRhKatiDeGKkM7iCsCuZlz12dr6R1N2rSI2oOrsIrI4qHCUPgEUqJh9T+FW4/fsXk52PkYiBY3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E5FKvuV7dK42OTt7madEqo7FSPeGOdl5x57m9gGBvns=;
 b=RVUQ97Q3YDEbGYcVD7Fr+t3ma+Gs9FYOi7D7KfBL1X5JykcDlGJsZUZml35c/HmRSUBaApqxKc9WxJS2cmwY8rEZy1Akycbcz74LiZPHwsp7k8W1cPjG/6va6X5m5cb/PPAiKKBPfpJn9T0iO86WMxdD01JSzysLafN1Zoip8IS8il8Xy//iVB7arf+++r2gfJQWY67eb9jqKoeFQnFD+WbuP7cbRjqK7/vvFFPje7UG8irxtOJ/64SQbJgA5w1OAr26fMu5EwhFhbCyI8bLOKyz8UiIauktZ4F8Jfx5aXTckzt9l1N9AYb5a9G04vG3hEuAg3pNizL58kvpS8lICQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E5FKvuV7dK42OTt7madEqo7FSPeGOdl5x57m9gGBvns=;
 b=jQQnOyx/HibRfW7xHCvi/+y6hCkxK56su7w30g7VSqctp0w8qHxPaLEaNw0uwXTdFHa9K/32IcOZcb+twLg+CNResMIdYYRN59S+YQMXHbMh+lBHeU28nwc1nPzg4fZBWy/9TJlFDYzX3dH6TtBnEM2EDXXM1V7NDjv1K2/RdHI=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4557.namprd12.prod.outlook.com (2603:10b6:806:9d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25; Mon, 16 Nov
 2020 18:50:11 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::d8f2:fde4:5e1d:afec%3]) with mapi id 15.20.3541.025; Mon, 16 Nov 2020
 18:50:11 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     pbonzini@redhat.com
Cc:     qemu-devel@nongnu.org, rth@twiddle.net, armbru@redhat.com,
        dgilbert@redhat.com, ehabkost@redhat.com, kvm@vger.kernel.org,
        mst@redhat.com, marcel.apfelbaum@gmail.com, mtosatti@redhat.com,
        Thomas.Lendacky@amd.com, brijesh.singh@amd.com,
        ssg.sos.patches@amd.com
Subject: [PATCH 03/11] exec: add ram_debug_ops support
Date:   Mon, 16 Nov 2020 18:49:55 +0000
Message-Id: <eeb1393a933c5443941ae795478a7bc33f843cf1.1605316268.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605316268.git.ashish.kalra@amd.com>
References: <cover.1605316268.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: DM3PR12CA0106.namprd12.prod.outlook.com
 (2603:10b6:0:55::26) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by DM3PR12CA0106.namprd12.prod.outlook.com (2603:10b6:0:55::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25 via Frontend Transport; Mon, 16 Nov 2020 18:50:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 41e74837-d425-4122-c3c9-08d88a607237
X-MS-TrafficTypeDiagnostic: SA0PR12MB4557:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB45577765AD342D814D57BE3E8EE30@SA0PR12MB4557.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WJI3bg1m/mSUuPFXcDIby6l/qs8S7TlRxtJOX9YTvh5284v6tgzh1oC45cxpI3lIKzJY3AWTUx1QdjjoZaAMakFfUa8JvbEiq8kqyRSj/tH475RxXsip4+RlGrdfZHiz1Jz9dy1Fw+ktrlHWjlQ+7zTvOZkbn2s2E6AFdUAaPHUztftaZeQHOt2b1PyGMMVPPq+Te1V5ov3qufgaPEHgRHm7VDpgA6LdN32E7r8HKV4mv57iyA3tQM9Ga/SYE7CJ2UlhDe/90kSzZxrXvvzmlcwI/T95xdmo2N0pN6yaVs267dIlS14Y4zznY/KvNKOM9HadE1Pwk45G8AlEtiUMNA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(346002)(376002)(39860400002)(66946007)(36756003)(86362001)(2616005)(956004)(8936002)(83380400001)(66476007)(66556008)(5660300002)(6666004)(2906002)(6486002)(478600001)(7696005)(8676002)(6916009)(16526019)(186003)(26005)(52116002)(316002)(7416002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: bIH5PEvDzOZj1VxX8Y7/ds/xsElogeWyrjD982ymPZciapD9+ZH7Y/QUGD91C2ajUe7iJ933ezWWEAnXM0496Ckq7KolL6JSlVGOqUgpWyDq4WHos8jQykbm3DpXC2K6TyrelCaHe1nloQqxhmB0X8tdXKBbiEaWr35nvCa2z8irjY7xI107VNLFYJgV36cVMTIDE+EzW+G1inPs3QfPuUjuY4aq2osNil3uJhQ5lQNkxJRRMXWA85w1Tt90YyYHk1kRJ+PpkFcolMclRn/vkxetwbqlfC2f93WbT36VEjl3BWlkz/iJluFhxJxD25qz7HErDAMGqMGXMbtS4FIDavaJx7/A1/fipMRUze9Xq4kEEqObn7RILIkDkgCNwLQtxBoirUwB4WXfnhxW1Af2j/ofbB0N26Wld1PTlNhach/AX0vWOYwJiRdF0eqiV17uYnBltK4kR+iaHdBEy8eiZNOanaVRjhVK5+vsu9ryDd/JsK5OdGVWkerUxySIl0UgVBLwwtRNTAegGGVgO9qrQpFZ+saGHspluoI9p9gqBEEwjG5HMQVY+Mr0BEOVe+TnPaM0tUEb9G8TMcnIUdPqFu31SGPEXA9wFlK/6jAl4e8jk2rRNDg8L6qVH0QFL92CNVLa/ngW+3hqtBIV0GG0z0y7TqsmngDAbJD0uXz7y9YNoOxo3yFdLYSJdVXwYDbMUi48WsJWIeZFeKJ5D53tNW98iflj4HlvnIR8N6eAA6OyoJNGTtFzN2SIF3WE3pLOwbPJRO9KJrxKRgJ6WMWQs9Cvp1xLbsH74mti3NG895RrQM4bWlrhmWwpIUoRE5JS2AeVO2C2fVX31AAR1l7WFR6Ge7hVkTKGM6RQw/hxHjLYkpiYpg5ErC9fkWYQOtLhW0/RzMbTNBZyeBYTBBW0pg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41e74837-d425-4122-c3c9-08d88a607237
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2020 18:50:11.3054
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BjvVvtrnKk5QncjVwpenMSWC2hg4jZvzneiOkC55JRUc3IzujcRD328RJMftaUyEiNtbfgdj9kCia9N3HooDsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4557
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Brijesh Singh <brijesh.singh@amd.com>

From: Brijesh Singh <brijesh.singh@amd.com>

Currently, guest memory access for debugging purposes is performed using
memcpy(). Extend the 'struct MemoryRegion' to include new callbacks that
can be used to override the use of memcpy() with something else.

The new callbacks can be used to display the guest memory of an SEV guest
by registering callbacks to the SEV memory encryption/decryption APIs.

Typical usage:

mem_read(uint8_t *dst, uint8_t *src, uint32_t len, MemTxAttrs *attrs);
mem_write(uint8_t *dst, uint8_t *src, uint32_t len, MemTxAttrs *attrs);

MemoryRegionRAMReadWriteOps ops;
ops.read = mem_read;
ops.write = mem_write;

memory_region_init_ram(mem, NULL, "memory", size, NULL);
memory_region_set_ram_debug_ops(mem, ops);

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 include/exec/memory.h | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/include/exec/memory.h b/include/exec/memory.h
index 73deb4b456..2fb4193358 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -402,6 +402,18 @@ struct IOMMUMemoryRegionClass {
 typedef struct CoalescedMemoryRange CoalescedMemoryRange;
 typedef struct MemoryRegionIoeventfd MemoryRegionIoeventfd;
 
+/* Memory Region RAM debug callback */
+typedef struct MemoryRegionRAMReadWriteOps MemoryRegionRAMReadWriteOps;
+
+struct MemoryRegionRAMReadWriteOps {
+    /* Write data into guest memory */
+    int (*write) (uint8_t *dest, const uint8_t *src,
+                  uint32_t len, MemTxAttrs attrs);
+    /* Read data from guest memory */
+    int (*read) (uint8_t *dest, const uint8_t *src,
+                 uint32_t len, MemTxAttrs attrs);
+};
+
 /** MemoryRegion:
  *
  * A struct representing a memory region.
@@ -445,6 +457,7 @@ struct MemoryRegion {
     const char *name;
     unsigned ioeventfd_nb;
     MemoryRegionIoeventfd *ioeventfds;
+    const MemoryRegionRAMReadWriteOps *ram_debug_ops;
 };
 
 struct IOMMUMemoryRegion {
@@ -1060,6 +1073,20 @@ void memory_region_init_rom_nomigrate(MemoryRegion *mr,
                                       uint64_t size,
                                       Error **errp);
 
+/**
+ * memory_region_set_ram_debug_ops: Set access ops for a give memory region.
+ *
+ * @mr: the #MemoryRegion to be initialized
+ * @ops: a function that will be used when accessing @target region during
+ *       debug
+ */
+static inline void
+memory_region_set_ram_debug_ops(MemoryRegion *mr,
+                                const MemoryRegionRAMReadWriteOps *ops)
+{
+    mr->ram_debug_ops = ops;
+}
+
 /**
  * memory_region_init_rom_device_nomigrate:  Initialize a ROM memory region.
  *                                 Writes are handled via callbacks.
-- 
2.17.1

