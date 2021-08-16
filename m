Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3B5D3ED750
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 15:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240681AbhHPNbO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 09:31:14 -0400
Received: from mail-bn7nam10on2079.outbound.protection.outlook.com ([40.107.92.79]:29025
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241005AbhHPN3M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Aug 2021 09:29:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G1cXMy/YoAkT/xdDG0QPdQUodrtMBNFVAQgycLxgI3ylk9c2pdVqGtdFuhaKt5SZPvJVL6iqrUDnx5pWQduD4bMAtx+AkFhXVfi8ecUtFEkumM130jrbORashj+Zf5mqCswgm89h9dd7NI2GhlxOe9gepvxxnZ+S4jJgUotUmTT1OPbfPtT71aLxEW5f1792PAKtuTpkHSx8FP3LPu9+B6qzQYJpqahWBu/Vd2vUhEQ7CmLJW7mtGvWg2NM7MislFOYA63N7nbVHdK0EPTsHOKyiAFe+28rg1DI4FtpoT6xVxa5ns8jb1gImcPkDK4xF8F3s36z5qJk4NPfs5LmwiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x+C1x96+bNrOUiO/cYfsnanaIcSqz5m0ElE3dtkxq3w=;
 b=L6Yc6WT67lkPfHIRAV57YD8D9+dotCwbtdEkuuH2jTY+Sejt0MdGopBwNafP1uaAibpH9iwbaGy7lGqLOPN3uWLbzEKC8yp2qe2l33SVTefgfPxa8j+kFLnY4LdsfJDTOtvDeuXK3tFTdVfAW/19lzoSuv+nNJMffXrD++K3AxLjgTuoDiTQfMoMlu5JNJY79vrqVdXcqi3HFOpuedUXlgpLwnrq2FZxbN3oXI5aQR7pqyYQNnB9bpmwCawp85BfQ8G4UPeknrVKhDa9M0r9AjTJfJ4ZjLFwm4WMNjwebXqgRycF3ZE47r421rAqPPJBul4YXcDEafbGN4ac36LZKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x+C1x96+bNrOUiO/cYfsnanaIcSqz5m0ElE3dtkxq3w=;
 b=zzGV8UADhmEjsm1ey5ImJxdOHAs14Mru6gvv2b9L2f3EPiTkuASct9v2OnpzbNTZQibeaQUtBYg5MUmD2nWADG67dn6rGM6AsjV8dgyWAWaHhHzcScdz0jRrNS6hZPvd+nCX6g9jvM4yIntJUgkftLqKtlzaX9HlMY2+1N/eIJc=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.21; Mon, 16 Aug
 2021 13:27:56 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73%7]) with mapi id 15.20.4415.023; Mon, 16 Aug 2021
 13:27:56 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, ehabkost@redhat.com, mst@redhat.com,
        richard.henderson@linaro.org, jejb@linux.ibm.com, tobin@ibm.com,
        dovmurik@linux.vnet.ibm.com, frankeh@us.ibm.com,
        dgilbert@redhat.com, kvm@vger.kernel.org
Subject: [RFC PATCH 04/13] hw/acpi: Don't include mirror vcpus in ACPI tables
Date:   Mon, 16 Aug 2021 13:27:40 +0000
Message-Id: <00e8dca71ff6da4efadbcc8db7a7a3e538b09638.1629118207.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1629118207.git.ashish.kalra@amd.com>
References: <cover.1629118207.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN6PR01CA0013.prod.exchangelabs.com (2603:10b6:805:b6::26)
 To SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN6PR01CA0013.prod.exchangelabs.com (2603:10b6:805:b6::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend Transport; Mon, 16 Aug 2021 13:27:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b0b99e3a-c86e-4ea3-b1fc-08d960b9a891
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB27673818A9C13E6D7669FA0B8EFD9@SN6PR12MB2767.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x6cgDSXiHf1eBGVEe6xtgS4TX4S2boFJKcPdvULNSE4D0Djc/2FA70AlAeEXIfzHzXoImvN+JZ7av/+grP1pTyRNQviuMl0cG5ma3c07XaY1zC0FgBwPvCz+tiFKMM/NiRQj36korhWfyMvrkwIJYMh7VQAICtO/R9FJUe3DeoSMoyB9K2E7Dcy/HBUUAf/FbEh3Me3rWQ9kexRpYsMSLIGx34x8fRf5N6h4fiORoqi2uj6OT9VYgWBdNGMn3goIEYNlweY49IHo41xDKs3DoLHDzfnrges+0hOxjz6QAWP50S03dK2GKZIBIv3NEsINqrT/+y4Mhd+jMZHj0317ZpIVBxEfeZ9csHG36gbf/fKjtCOCo9SCfim3ShV+uPaRygTYg7Y5BzaGTT9Iu3r7gf0BQqF15m/XWOQ8OD/Toq3QZQ03aJ9iJEEaAKaaMdVVgva6INYcRGr47/AoZHiUlBBp5GyxmG7ylS8bBJjegwfH00nnOiAYYNAQUiO3aeGyhx0xGhinWdRm/TepbAB0qPynJ2cnv0k1EPQO2t8J3N4rDhIMaOaPWwsUQHTSjqhQz4HvverJnUbuiCZPZZHhQWjwgG24qkN2ZfCdSJ09pBvqJoBP4JxIyT1zct+O8huDJQIISzvHkVejAodC8lDwQFLkKxQiB/vYhj1JRRuw86OcmliT6/Kp3vJIvI8Eh4HsWgZqRoH86/Xv/+b4viJ2wQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(376002)(136003)(396003)(478600001)(2616005)(26005)(956004)(186003)(4326008)(7696005)(52116002)(36756003)(316002)(66946007)(7416002)(66556008)(66476007)(2906002)(5660300002)(38350700002)(38100700002)(6666004)(8676002)(6916009)(86362001)(6486002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KTNbZPQLQwy8n1khFDD0bTEqhn2j3IJpG2xI6CRQcrfoPeh9kmktDgMtKr06?=
 =?us-ascii?Q?tz4795FRnGVMVNA9pscbzjTBQgoZQly+dsh9kxT4A729FcAf2CRxAKivQeqL?=
 =?us-ascii?Q?Brk16LM0bYKMKjbF6tln1INyHBNsWC8wvIMMNgqYUY1myLCkqwZ5MLw0RudA?=
 =?us-ascii?Q?s9fuTA/iYJw2xvnXS3LugddgHpAQ5kiDV49ADok4F40XkPlI+BXz+yZJpBo0?=
 =?us-ascii?Q?xn8/bcIGB1apEACiUuMvGcp0XoTadRyAHHMshyAtUcrPksVc7kkK55FrFcRk?=
 =?us-ascii?Q?FVfrmse0ZscLqvI3CG45GVDvfPUogHmAVWyro9Bn3RSKjvDrwZYPn7KfTWSO?=
 =?us-ascii?Q?EZmxNWwJ42D0P1+uV1lI+dN1jl0hLNPMlTaaHaBoUZe0E1pCJXJHWEeTvBd9?=
 =?us-ascii?Q?7VrqFbrt07qx73lNRu5Ak+cL0ydLuTQjeBSzA0GcKB1q5xkFqCFIvK+nFn5l?=
 =?us-ascii?Q?tqzAGgbjyxy7HHf3zl1ky1n1XlsgBt0WTpkJHGvrdpSMulHD6m/CaSivxEvo?=
 =?us-ascii?Q?4DiHm9rhxTdREq1P5Svtg7Pzr+151EIylG4Ule+kf9YWgCjZ9yHuYauGS9Se?=
 =?us-ascii?Q?BwtekvXSt2tb0fV0RN52vQGN7ynDxy2niL6QCZgzkn+FUAl3bt1UFQ0k4dTS?=
 =?us-ascii?Q?bD9GU4rSO9Q3a02nkHWdtXieRndcu+Gw6sS6mFOWBkBR02A7zqMmxX9Mx80x?=
 =?us-ascii?Q?NiGR0Tti8ycpPiYi5mlm/EPkb7JZ1q2RPbdIO0OLSwyNszotWnQfJtwxyCG1?=
 =?us-ascii?Q?0/rvsd8JdFd+SGIiXJz25Jehso71uddwbhJFtGFgbLaBIL82a9Jys9dLqAmM?=
 =?us-ascii?Q?KUpoKtl8F0roxn6sq/QrJlz7ZLkHH2SFk1PV3lkHZl6LVlOfOuKF+TSQlIT1?=
 =?us-ascii?Q?G6daCrs/9uWk5Ir2J/aFvjnxvVF2ZzSmkwlAR5gY+nGDTKZcwvpspSbI15FC?=
 =?us-ascii?Q?/seK5HFxfNUt661EciVZDEOVTeuZOI72jxiOn6KkQerwRu7P/T5k2foZSh8l?=
 =?us-ascii?Q?H9xxu6hCHE+FrgUwnKzMA2MOEiwoWYgD736BzPWsJvXYG4tS7vP/v52p2Qej?=
 =?us-ascii?Q?EM+6eC5WRWUYDxa0vV5gfVHriYUaedGrUfYs1OvefCaQTR1A/os6NUU0Czp4?=
 =?us-ascii?Q?gqV2759+TmH8k0ejgNb9WENFmvnkAmdXeDrX/Zvr3bgx53xLpqQ+ujmASHB3?=
 =?us-ascii?Q?nKFreAWH1dWj6D8QHsCPjB8LW1j/oAkEFeqrqfoUD2oW4cLPZ+KbuAsvmaWY?=
 =?us-ascii?Q?3NyhRVzvccRMeLE4n81I+apVY82xbgk0RM/3TG8Fswn/jTMiadvbYp2qaqz6?=
 =?us-ascii?Q?0n24k4cBJYZr620Z/F7diDv9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0b99e3a-c86e-4ea3-b1fc-08d960b9a891
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2021 13:27:56.5311
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nO3ib5Uw49hFzlkGqxflxScJgYqMx7B4G3G1Yxy1TbiAq8riIZMal8GGL4vGGJj30Fqt32NUDvpED4Lt6sGKkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2767
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tobin Feldman-Fitzthum <tobin@linux.ibm.com>

By excluding mirror vcpus from the ACPI tables, we hide them from the
guest OS.

Signed-off-by: Tobin Feldman-Fitzthum <tobin@linux.ibm.com>
Signed-off-by: Dov Murik <dovmurik@linux.vnet.ibm.com>
Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 hw/acpi/cpu.c         | 10 ++++++++++
 hw/i386/acpi-build.c  |  5 +++++
 hw/i386/acpi-common.c |  5 +++++
 3 files changed, 20 insertions(+)

diff --git a/hw/acpi/cpu.c b/hw/acpi/cpu.c
index f82e9512fd..8ac2fd018e 100644
--- a/hw/acpi/cpu.c
+++ b/hw/acpi/cpu.c
@@ -435,6 +435,11 @@ void build_cpus_aml(Aml *table, MachineState *machine, CPUHotplugFeatures opts,
 
         method = aml_method(CPU_NOTIFY_METHOD, 2, AML_NOTSERIALIZED);
         for (i = 0; i < arch_ids->len; i++) {
+            if (arch_ids->cpus[i].mirror_vcpu) {
+                /* don't build objects for mirror vCPUs */
+                continue;
+            }
+
             Aml *cpu = aml_name(CPU_NAME_FMT, i);
             Aml *uid = aml_arg(0);
             Aml *event = aml_arg(1);
@@ -650,6 +655,11 @@ void build_cpus_aml(Aml *table, MachineState *machine, CPUHotplugFeatures opts,
 
         /* build Processor object for each processor */
         for (i = 0; i < arch_ids->len; i++) {
+            if (arch_ids->cpus[i].mirror_vcpu) {
+                /* don't build objects for mirror vCPUs */
+                continue;
+            }
+
             Aml *dev;
             Aml *uid = aml_int(i);
             GArray *madt_buf = g_array_new(0, 1, 1);
diff --git a/hw/i386/acpi-build.c b/hw/i386/acpi-build.c
index a33ac8b91e..3c0a8b47ef 100644
--- a/hw/i386/acpi-build.c
+++ b/hw/i386/acpi-build.c
@@ -1928,6 +1928,11 @@ build_srat(GArray *table_data, BIOSLinker *linker, MachineState *machine)
     srat->reserved1 = cpu_to_le32(1);
 
     for (i = 0; i < apic_ids->len; i++) {
+        if (apic_ids->cpus[i].mirror_vcpu) {
+            /* don't build objects for mirror vCPUs */
+            continue;
+        }
+
         int node_id = apic_ids->cpus[i].props.node_id;
         uint32_t apic_id = apic_ids->cpus[i].arch_id;
 
diff --git a/hw/i386/acpi-common.c b/hw/i386/acpi-common.c
index 1f5947fcf9..80aefbc920 100644
--- a/hw/i386/acpi-common.c
+++ b/hw/i386/acpi-common.c
@@ -91,6 +91,11 @@ void acpi_build_madt(GArray *table_data, BIOSLinker *linker,
     madt->flags = cpu_to_le32(1);
 
     for (i = 0; i < apic_ids->len; i++) {
+        if (apic_ids->cpus[i].mirror_vcpu) {
+            /* don't build objects for mirror vCPUs */
+            continue;
+        }
+
         adevc->madt_cpu(adev, i, apic_ids, table_data);
         if (apic_ids->cpus[i].arch_id > 254) {
             x2apic_mode = true;
-- 
2.17.1

