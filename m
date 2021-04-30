Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7DEE36F9F6
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232323AbhD3MSh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:18:37 -0400
Received: from mail-dm6nam10on2056.outbound.protection.outlook.com ([40.107.93.56]:37728
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232305AbhD3MSL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:18:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n/zqLu+xv4w5ehLPbfhyhRPYz8XxGm8qup7geqFsKeNgePhfr0k3SLTtGlT9zzY35LSy8QG6lqadwXU0wvQyBziOA6AH2GtADla5AjXz9V1MtDB32s/kw5A8xx/S+M/QcXb+YCJbN/diFFZyrFZvz5033NA7ZSwy2usIWoIOhBzco/ReAkCKSI/v1Hg58G8lFdNaPb6esaKkrBi3wu6pUPkZhlvLYEbXtkj3BepAouC/A3AKUu0meKGMpwFJ8PwOppwp57rVi9PaDrdBSVAymHxtcVhoX4vJUVRMes/YMZ40i+MzrxMJN5CmzhDpO3IvQW8pNrYP+kQafS6B5m/s6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jJXPTMPx3JnEwYWdVkobHZ5ZnGJRcDWshOurQSxwhNg=;
 b=Q6VIhVo4PAsnSbxve7HWjNLrTrjhqflmrc6imUC0odkpF2P+1UST0Dm5ivK7QFM/2kb88A2XU6ZaJbF5xc/RZfZ/lu4WgtvPvAHiI9TjO72+90aDoejrYGZpiMyt6XlAw/9MMQesZ06hUQeX61Qt/TBDTnq4+0R9XtF9b/6duBdrHe+24+eA2Fhps8oYwlEBLR3M7K2prnUyQpMxKm8QgKqKKtg/OYZXLBKE+CIPYQ6OI7J9qdvWqBQiUv19KhAD1P2Y57t7ulQkvHaXae+XPfIxbkelCQZl/LdvBejm5SyA1cOQI97gCToocwypaYoufURb2r+q9LvQuIP0H+1JpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jJXPTMPx3JnEwYWdVkobHZ5ZnGJRcDWshOurQSxwhNg=;
 b=oTDWJZyzcRO6xlpvKiK9+DEIRdoWJs0iQmjRgKwqddTGeNyWL/3xgc9Gx7UvonOojusaikDkVwi4oTYlVZPcbrl9EIIs5jIEiTZYwnS5Xk7xMTN53rrriuKc0mqIlBJV/ZPkXOnKWIEFQzET/0mbKFSm93tmQtgyltgijCmY3sg=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2640.namprd12.prod.outlook.com (2603:10b6:805:6c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21; Fri, 30 Apr
 2021 12:17:03 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:17:03 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part1 RFC v2 16/20] x86/kernel: Validate rom memory before accessing when SEV-SNP is active
Date:   Fri, 30 Apr 2021 07:16:12 -0500
Message-Id: <20210430121616.2295-17-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210430121616.2295-1-brijesh.singh@amd.com>
References: <20210430121616.2295-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0401CA0021.namprd04.prod.outlook.com
 (2603:10b6:803:21::31) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0401CA0021.namprd04.prod.outlook.com (2603:10b6:803:21::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.27 via Frontend Transport; Fri, 30 Apr 2021 12:16:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d13032a4-581b-4123-2100-08d90bd1da74
X-MS-TrafficTypeDiagnostic: SN6PR12MB2640:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB26407D2F09C24F00C466AA6FE55E9@SN6PR12MB2640.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PBu839nyKqiX2qmjH/QdJYd+UyWBUwIxwz9q1o9ujngDSa1865NgrXUqbcSglLIvHpw7HhF4McsGmcpJnwnXh2+4V2t/Ounacdp2KzNbmqIzZWQ+PslutLhgNvFuVYe65iRUFMMUxGLZDii63rmGKvIoS/cZDL7tgf6xPUnyaVNR5l0+Y7uQRzEq8uWvmnOoGUtaF7b8kmDw5aLEERpNQOR61OYVhdv/Qhue68TQsNj3HJrPl+1AD1wcDqZsNtBEZ3pM9JTyLtQOGGRaSvCwrr9/6A/ylZ1BOPZTGmpMUgfXao3TF7ix5Xt9X+kaJypp9Tf+Z0qSoyqiRRjZmYRBuOPpa9M2vnmrpuR/AYgr/6QKb3BkpICB6x8NMDpEC+ufAzTRkduK8TDaWKskb2GN/BDj1AePuYpd5i/dpaFGkhVONkos2Wh7yrcteP5EQRhX1iEX99Jw5eReVg87o3PT1G9oEC9mHLBraxHPk1PrPV/Ddmne0vfGRAXLhhHkoiX0uvYRR0svwIF8RMZk14lOKYp1HFHLV22GaCON4XTsuc2rriMJFDgDH8JfDBNFjVLmjsqfWLIpVi9p45667D08E2avPLon7ThhyyaHfVMhu3dUCQkeLmvGBQbleok11JUirjEgmkmKkHBppIgpFzaRHQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(136003)(376002)(366004)(396003)(6666004)(52116002)(7416002)(316002)(16526019)(2906002)(36756003)(186003)(26005)(38100700002)(38350700002)(66556008)(66946007)(5660300002)(1076003)(66476007)(4326008)(83380400001)(6486002)(86362001)(8936002)(956004)(44832011)(2616005)(15650500001)(8676002)(7696005)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?XdqDo8kIjuXRJIbGyk02eH5f8AbU6yJ4YRhWgPUn8DSJhUyd8Cg/CsAIZcdx?=
 =?us-ascii?Q?RYUSxYrtvei3v8Bph4cFL+MTMd4H6nTsm9mJmMphSqlW459hasFvo7tR8clf?=
 =?us-ascii?Q?Kf9BE19qMTh3oFX5Csglx3tH294Bj85daav3RVlmLSvYBlAnVT5ikyS+Y/Kd?=
 =?us-ascii?Q?2L0r5yBll5s/hivkews6Ogy/aZw5Q9hA3tEsu2TWIRldvRhamUXkj1WgBLH+?=
 =?us-ascii?Q?FLsnqc6ta3O9CRGIEVVeVSzw+ph3qXTaIdTd5MERZCPmPuJhbqEVmRXX5KCD?=
 =?us-ascii?Q?UFJUsOB9DJsu9D5Y5cvTp1gaIX9h8YloZmTJHmQijf8DnfSrQXEHLhF06gZx?=
 =?us-ascii?Q?EcdlGBaRkdHlespOWEvFolZaSv/Qy7TpOCgOcy52h9HpxR4N1v3keHIjMUSc?=
 =?us-ascii?Q?DSeJl8U2lZnRt/+2TcPgaroWw8yaG+sPV8e5Mcgenw7Av2+k0Bjv+j785isU?=
 =?us-ascii?Q?GU/J6qt0bZ8vx5hkgBCqlLs++dRBs1F4Hatn33uIDJ1AckfiOIMSwQ65wmYT?=
 =?us-ascii?Q?T0SYstHR6wx2fS3GIGP3J00v7JPqGJk189bMKZN8gyrPw+VN2/JyltoMD+nX?=
 =?us-ascii?Q?+TuG0vUQnapJ+zdTsiWKC0h3SI510jjWOCq1KhEyHsptAz/E+iOViP+TjFUg?=
 =?us-ascii?Q?ia7zoaAupM+1txMVxqtyd7OS3BrdTkzv9+30C3axf0tyxHZi66XrPBEQB4gF?=
 =?us-ascii?Q?Qw2V4T2GZT+g2BLCiilHKjCNVZTOT0B2BRV0nc6S5Zqn3E2n3Mj0WeYpLcpA?=
 =?us-ascii?Q?5J8QGs0XWZz3RuBwZUPjgxrLKTEe3g20MFukIgrvPFBHJ0btptjPZOEuRfmP?=
 =?us-ascii?Q?CB1DJgKsHm2/Rgv1OGE9qE9bG1aYNvYgca5MEX1GkxGb7ecWeoPpplA4Jh8S?=
 =?us-ascii?Q?Xwy9r3xVBvybeBSeSgfsbJ4snxRSZgVUCsaNnKJIc0+C2rHuqecsTBisEinP?=
 =?us-ascii?Q?LqRByyE2HviJiwcd+/ACXcnXhb139IO76EiWg+MhRFqBFz4O693yNTvqyLip?=
 =?us-ascii?Q?4AtTK/gffhg97YYO1sUhTcERk91Zb5tQLaJmMHVlJrXC8YA/Osr4QhTA+GDW?=
 =?us-ascii?Q?T7NvMGh717DTxxl+x3+CMg3MMFflVpyLSYHPhf6w75DX9FD+ap+pyqOCeKwK?=
 =?us-ascii?Q?gF4i3jI6Nuzjw58uT3QMQK4hF099q8Ds5fbCLIQo4XEOiLQ617NXJEebZkrl?=
 =?us-ascii?Q?da3VUSn0dXyayerAVjupGwiiCYunOywBgPwR4zRuUWTukDBK3s/snHhSArRh?=
 =?us-ascii?Q?KviGA5FwXcvgpPIbQRGbvg4khdz0p0HJi3GCCrxQ3oz5DaripXx1GyEwL9pZ?=
 =?us-ascii?Q?kT6vPXWs0qkapxkdDAdw1kNf?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d13032a4-581b-4123-2100-08d90bd1da74
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:16:59.2339
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vzqn5Z+kaIXk/YD0nxzKIc6bhn/vjkUm96jwpVZtvwHEi4733kF9HF7FR7SGEVZGGS9CdffKUyoJF5fDzPuGig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2640
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The probe_roms() access the memory range (0xc0000 - 0x10000) to probe
various ROMs. The memory range is not part of the E820 system RAM
range. The memory range is mapped as private (i.e encrypted) in page
table.

When SEV-SNP is active, all the private memory must be validated before
the access. The ROM range was not part of E820 map, so the guest BIOS
did not validate it. An access to invalidated memory will cause a VC
exception. The guest does not support handling not-validated VC exception
yet, so validate the ROM memory regions before it is accessed.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kernel/probe_roms.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/probe_roms.c b/arch/x86/kernel/probe_roms.c
index 9e1def3744f2..7638d9c8e1e8 100644
--- a/arch/x86/kernel/probe_roms.c
+++ b/arch/x86/kernel/probe_roms.c
@@ -21,6 +21,7 @@
 #include <asm/sections.h>
 #include <asm/io.h>
 #include <asm/setup_arch.h>
+#include <asm/sev.h>
 
 static struct resource system_rom_resource = {
 	.name	= "System ROM",
@@ -197,11 +198,21 @@ static int __init romchecksum(const unsigned char *rom, unsigned long length)
 
 void __init probe_roms(void)
 {
+	unsigned long start, length, upper, n;
 	const unsigned char *rom;
-	unsigned long start, length, upper;
 	unsigned char c;
 	int i;
 
+	/*
+	 * The ROM memory is not part of the E820 system RAM and is not pre-validated
+	 * by the BIOS. The kernel page table maps the ROM region as encrypted memory,
+	 * the SEV-SNP requires the encrypted memory must be validated before the
+	 * access. Validate the ROM before accessing it.
+	 */
+	n = ((system_rom_resource.end + 1) - video_rom_resource.start) >> PAGE_SHIFT;
+	early_snp_set_memory_private((unsigned long)__va(video_rom_resource.start),
+			video_rom_resource.start, n);
+
 	/* video rom */
 	upper = adapter_rom_resources[0].start;
 	for (start = video_rom_resource.start; start < upper; start += 2048) {
-- 
2.17.1

