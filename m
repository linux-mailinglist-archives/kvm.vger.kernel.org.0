Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 114AA3ED786
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 15:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238358AbhHPNfF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 09:35:05 -0400
Received: from mail-sn1anam02on2052.outbound.protection.outlook.com ([40.107.96.52]:36975
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241244AbhHPNch (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Aug 2021 09:32:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DKJAqkHUK9i2rN0jj8OFTlO7MH0seoUfmZ4+jSPKxSld533Melk5nxWyN0CZKh3fM06ZyE6iG4meGe1j6/YUC2+vTSr0nZoQUK64Vlm64UOG/TSEkRvTlrs+WYqDLG3TwbmwJjy964szl27C8aca/3GZyuBPvT7OPglX8B0qNLd1YYJfU/MXbNEYt2HybJwoIoGgr22c3w+t1HLJeEISaS6SVgGUszhNeKvmxOGDD3MmhAm733QE9D+QVwjZ9pjdemcZXbdmmUan3ZIKqLXNPBPYkhjD1YQxNxpjwxTO9B5RQI8sSbfhOVRt3Sw9Gf/PkruTB4+xFf04WedlkdTtqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+xFMMs7EhKJGclsHESr1BTV0iV+z2FpocNYFaFpdGdY=;
 b=MCBdld4QYMcJ5yDX+8TbCbdQHCSRl9WZIIVBS/xj0zgCO931rgeJVUCWPh/qD3JHxrkqDqY1Ax6Vj9F6bbM0uZxq9c4xt/QwBUAuFpPPNtx1IxJjto/C/DIT8gmlNm5FqqVWM8jvu1+d1QPMby6aRXalgsxOkL18AOsF0sPHsi2BHYIq9QtkNyuJyJMQnOyrI33bApt9ae1MWDlVHF2jNjAYoCUqt9r1ifDSXjknRzi+PmsRxgnBWxcDi0BP50ffEao2INfQ6F7sykgy8HKRUjGx6ZlNxw378va96QZJ8EUh8FIFxFKAbB8e0lHbAGgkRaGG4MRIOKxp8WH8lXUAJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+xFMMs7EhKJGclsHESr1BTV0iV+z2FpocNYFaFpdGdY=;
 b=jllUpix2OIeYwerIG7Bx2ZIlxMBFiifDBha9QybzuCIFb4NFC7nxeLFJEZZrqC7ES602FT5iITwtNouPE6s5RQgb683GhVtbKsY6c/X4yC9rczRR3YPkaU9Zdzmb2EghpOyg2ny7eBTC3K5wvzYULODeaprWA8LstZxbqcy3OFw=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SA0PR12MB4495.namprd12.prod.outlook.com (2603:10b6:806:70::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Mon, 16 Aug
 2021 13:31:27 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73%7]) with mapi id 15.20.4415.023; Mon, 16 Aug 2021
 13:31:27 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, ehabkost@redhat.com, mst@redhat.com,
        richard.henderson@linaro.org, jejb@linux.ibm.com, tobin@ibm.com,
        dovmurik@linux.vnet.ibm.com, frankeh@us.ibm.com,
        dgilbert@redhat.com, kvm@vger.kernel.org
Subject: [RFC PATCH 12/13] hw/acpi: disable modern CPU hotplug interface for mirror vcpu's
Date:   Mon, 16 Aug 2021 13:31:15 +0000
Message-Id: <0044c129b82676f619484c2ff65cf6f127bbc99a.1629118207.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1629118207.git.ashish.kalra@amd.com>
References: <cover.1629118207.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN2PR01CA0039.prod.exchangelabs.com (2603:10b6:804:2::49)
 To SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN2PR01CA0039.prod.exchangelabs.com (2603:10b6:804:2::49) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16 via Frontend Transport; Mon, 16 Aug 2021 13:31:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f1bec4ac-9616-4aed-c3a3-08d960ba2661
X-MS-TrafficTypeDiagnostic: SA0PR12MB4495:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4495B02545D770B7557578D58EFD9@SA0PR12MB4495.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rDptCcn2dvD5yKPyc9fVXVWYM3JXUz7oYAP4PsGxD0xhia1x0xtZvDyETqWP46zn3plb3e4emWVGQ4s/2d1SkmvbGOKo58tD2GD29CIhHmPPp3CZQj5Lvv1fUZJgLlI4IGAL9ONv78a/cGc2z0xzzWAemInUREi5+NRwNJE04PF9XV6B+T83sHYvoWWCRRBC46VOkm3u+zUY0QEEBOJSIqd3fd9exGT8A/u5RfhjnFUJvaXbgiWm+1O2m/80LCltEAHgRCSsib6Wwgar8Wh91vce7BoDwMCYfuVmKO77Cr4kqzriVnjfqcihr0Xh7uYywLOcCrYEYFWH2xSaID3GOwIuh5psyCzkjRh9+/0ZDHRGLWcV5+f/RaebydDlcCDc4LTeL2A6tG6IBxOHd5b5WmtFAWICztOEWj8N845giIUpStj6PgY8OVnaTt36f+jvfbtHFV0obtKoMYocSWSabHMC2WmtbOyTcEVuwGD9tsrLimibQfjL2kPMNjOnaUeH+dzbAq8lR4Jdp8mh7opnOdJn2IumgzuCyidg6yzMfqrgL9p7+UXUeZeQSfg+rruzjk6taILEkeilXq0XxnUuotOKfolPlYhUjXikfYyn4ZcMBMxM7wsyXaDI8NBJjl/qzxI85oL4bCYtQ+uX3r7OS0+RV00WcimAvmQpiw70E1u5JzRuT/zlCYxLqMGuK21z
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(396003)(346002)(366004)(136003)(38350700002)(38100700002)(6486002)(6916009)(478600001)(26005)(7416002)(36756003)(8936002)(8676002)(2906002)(5660300002)(86362001)(7696005)(52116002)(6666004)(66946007)(66476007)(316002)(4326008)(83380400001)(956004)(186003)(2616005)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zp0kskwOwzqybvAlhl4CQsTKc8N99JklU3cdB4lWThuYtQ61/2mdzpaZ3KMX?=
 =?us-ascii?Q?krS/Ua5SiiwFg1jYsU5vjqlmeYklO7RqWFinqp6wfM0KGKVbuNK51P7ITnHP?=
 =?us-ascii?Q?WDVgrUSA18oXjX9Ac7pcitA1nyuY/Dl5bt2DEZ6cTMLZehZ3nrcr3Dp4FUpe?=
 =?us-ascii?Q?VIapApgW7OdhYgMYSD2Q9Q7hllWU2RHVK6ypwAN8LGHcATygiEv2NXSevN3r?=
 =?us-ascii?Q?r46Klu4hGlW9ZQgKkjdnIy9GoNuBqLqAQGfQzGKNuSvv/dWfWb5+CnZ/XZ6N?=
 =?us-ascii?Q?Yer8FsyA8E6fSlwCS6VA+Vch52qodBdUrrXlHboDLWe2JFF61jB4ZocK+iln?=
 =?us-ascii?Q?ofF+DaJA/3andMKucOdnEWlOzmy3hzeHljOcP7HdpmUMeH4r05XBobhY8dI3?=
 =?us-ascii?Q?7zFuJEWhfCUvP+zIA0Gd4azyGj4XK0PP28YSo7KV9XNAgSrfOMAstxL7Z4Z4?=
 =?us-ascii?Q?m+uCLIgMJNfru/cLSMkaybSlfTJmV6u1bld5xrX+ow69Aqn0Yn4nR9QwSIzE?=
 =?us-ascii?Q?wdKdNzst4997DGUOtCNnxUNFXDS4Fw9tbRljzCEGLyV/rLcvMT8T/8l8SGT8?=
 =?us-ascii?Q?JTz6svdmM15RUVDmOtRF0muUmdzfu0JdG4UKyHvkeVyr8fraNZ8aNVjAc75f?=
 =?us-ascii?Q?7Efmcv6ir2Tt2ev8aawl97G674nex8nMDNCcHUaPRjVfRiqJVwFvhKx21Lh2?=
 =?us-ascii?Q?fsKv0wX+rC518mars87U3k8hbnF8/7Tg2zDUmPVJnJaTvluZNkmcYyM57qkK?=
 =?us-ascii?Q?VKgyghtTjkw61I7VR/098z3fNoC0mszWC0ePV9wVLn2b8cu6Em+TM+bXKBbU?=
 =?us-ascii?Q?WSafbjfCpUqQWARgYbC/TjkEkknEY0euPrT9B6xfoPqukdBFX1LDfc1p0V63?=
 =?us-ascii?Q?lDi93cGAEKdI9MMLRDGAFfwuyiBEZ8ADIUHZ3a5E9cb5tisXVYRTMiv27nMd?=
 =?us-ascii?Q?ok5P6/lP4saM5wY1Fh9gMgSuEIQa6BQggyj/l/l26jepxOVvsi33yXILiJZ6?=
 =?us-ascii?Q?L6015sKmR54wrpDJRlOrHi20Oh8Webkw0Dt+QCG/y0tzl+0IkVOvsTaQVdjs?=
 =?us-ascii?Q?pqIBX1VFngQNiwA2GDrNM1KXZfm7s0u1TSzetlE8q9W1Rt9TvDL/Ksdjqzd1?=
 =?us-ascii?Q?hIwxaA3gatJdw2HDsO2+2lIlE3DrFVyYgJ1rM4Lb4P01FQ1AjxTVZdtc7U/a?=
 =?us-ascii?Q?LM48DEYL16m5xGxFYXrHW+0fy3y+rcQ+Yku9A9Immg3hJbNTxrYBnOpe9Lym?=
 =?us-ascii?Q?2O0mCYDzwVlY1HYjG8YF8ZGL0A/9RmrZzq85GPxMp4MaDQ9c7htHRlz6bJ3r?=
 =?us-ascii?Q?CSBbrZLe+8R8D8aqJ3ysQ1Um?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1bec4ac-9616-4aed-c3a3-08d960ba2661
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2021 13:31:27.5909
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: T/ODy6XAzRHp95l64Cv+OS6kmfKwkRWKu3UjmmP0Jc1bRdqJIU1yuE3nrgY2tZZxn9the8ViKheQFtlVxmfLCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4495
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

OVMF expects both fw_cfg and the modern CPU hotplug interface to
return the same boot CPU count. We reduce the fw_cfg boot cpu count
with number of mirror vcpus's. This fails the OVMF sanity check
as fw_cfg boot cpu count and modern CPU hotplug interface boot
count don't match, hence disable the modern CPU hotplug interface.

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 hw/acpi/cpu.c         | 11 ++++++++++-
 include/hw/acpi/cpu.h |  1 +
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/hw/acpi/cpu.c b/hw/acpi/cpu.c
index 8ac2fd018e..6cfaf2b450 100644
--- a/hw/acpi/cpu.c
+++ b/hw/acpi/cpu.c
@@ -86,7 +86,12 @@ static uint64_t cpu_hotplug_rd(void *opaque, hwaddr addr, unsigned size)
     case ACPI_CPU_CMD_DATA2_OFFSET_R:
         switch (cpu_st->command) {
         case CPHP_GET_NEXT_CPU_WITH_EVENT_CMD:
-           val = 0;
+           /* Disabling modern CPUHP interface for mirror vCPU support */
+           if (!cpu_st->mirror_vcpu_enabled) {
+               val = 0;
+           } else {
+               val = -1ULL;
+           }
            break;
         case CPHP_GET_CPU_ID_CMD:
            val = cdev->arch_id >> 32;
@@ -226,6 +231,10 @@ void cpu_hotplug_hw_init(MemoryRegion *as, Object *owner,
     state->dev_count = id_list->len;
     state->devs = g_new0(typeof(*state->devs), state->dev_count);
     for (i = 0; i < id_list->len; i++) {
+        /* Disabling modern CPUHP interface for mirror vCPU support */
+        if (id_list->cpus[i].mirror_vcpu) {
+            state->mirror_vcpu_enabled = TRUE;
+        }
         state->devs[i].cpu =  CPU(id_list->cpus[i].cpu);
         state->devs[i].arch_id = id_list->cpus[i].arch_id;
     }
diff --git a/include/hw/acpi/cpu.h b/include/hw/acpi/cpu.h
index 999caaf510..e7949e86b8 100644
--- a/include/hw/acpi/cpu.h
+++ b/include/hw/acpi/cpu.h
@@ -33,6 +33,7 @@ typedef struct CPUHotplugState {
     uint8_t command;
     uint32_t dev_count;
     AcpiCpuStatus *devs;
+    bool mirror_vcpu_enabled;
 } CPUHotplugState;
 
 void acpi_cpu_plug_cb(HotplugHandler *hotplug_dev,
-- 
2.17.1

