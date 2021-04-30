Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ACA036F9F2
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232616AbhD3MSU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:18:20 -0400
Received: from mail-dm6nam10on2049.outbound.protection.outlook.com ([40.107.93.49]:15328
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232370AbhD3MSD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:18:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BmYnU7uJqJGIMUesfgA9lmADT2Uf8/Px7O6mCmVAlyHvn1C2UcQbLY1WKx4BqbkiRfduY4BQqtDwpNlvzqp4OL6i5nFgJINB4sjaAbO5Bq5EWWIgBbbmebuRmSnTDHzK5kAwIrrytXI73XaslTKBw9Wj5Z5bqHhpoleTFomYtfIbNivi4GKH00CR5M4UIinF/XgkMBA6RWEtpXnwwseRkAPc5CP4gINeoLjDHahge6B3OV/WJ27B2fcsYVr+QjoJp5eTtOmeO1Hn+bWJaYW9lEo4uilwv2+CmNpFtpozAeJ+JwjDhyrAr4MHVbMcrQ7F+roPP9fcM5JTcfbJh8g/2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TbJJjZxt+H9lBygplsUUgKsUuokN/yfU2BWEKMxvu1g=;
 b=WLjMDWP97Wi0tBQ902yGIzoEnCN7NnI7XbBOP/DCWT4fHXq7jqP8XrolCv0buwolmGYFH8c4b6kM4UKoSRV4lfGscb/ySVJspQix20grnFH9qp3+jq5YAevjZ3FpwcZ99hUp8bh89HjWFnYJgUtuB1nx6oS+g5pRRwUjzqMdg2VhWA5whxggsIMtdzygEj8NjDmyAPKAaNeZOY7giD3gm4ldNdtqp4pO3hWSM0yOBLkFpSN90mElcRJ5kvn1M3f26E2GDgyHKzOej6dSus2xmD1YO73pYSnw8spWP9AHdKW5eyvfd54HhykVGPlQc8+jE/CsLqiqUyxbhvM1zXJ3rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TbJJjZxt+H9lBygplsUUgKsUuokN/yfU2BWEKMxvu1g=;
 b=m7SyN6gc4G8kXFbgekAXyI1EHf+8ivxBLgffaUdP5V0rqhYRJDArg3W9okg3ph+I7Hib2L5jHwiWkzde3CcX9G6FkUaVYjQsFweu8j6gXEh0834M1mp1TXMBxRhjGQ6D+oBr3Nwnl2W3s11nWhW2FRyNMR4eitmsaE9Bu8ZJpdE=
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
Subject: [PATCH Part1 RFC v2 15/20] x86/kernel: Make the bss.decrypted section shared in RMP table
Date:   Fri, 30 Apr 2021 07:16:11 -0500
Message-Id: <20210430121616.2295-16-brijesh.singh@amd.com>
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
X-MS-Office365-Filtering-Correlation-Id: 5c15b01e-c070-4d2d-c049-08d90bd1da0a
X-MS-TrafficTypeDiagnostic: SN6PR12MB2640:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB26404DBE67F05A3A452C0BE5E55E9@SN6PR12MB2640.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lcWY5cl6WWrlgFeQp358uftiF+VVJNVFNwAPJEogEfyl9J8LlHOynN9aEttvIFImGogna+tPB3pSh2797Q6QxiPT+5AnGd3f6+vXljvPxTfxg4HBuIQ+LRY/DozsMD5xXsb6LHldTsLVdyFWcn7hT4nfCLoFR9Qlf62gD4JcTi9Zhe3nejG+s7e0P285vyoeJHCWXLl7HbfyKSY4i/XQD6W5NfwLWuecOgSDuRGOTo5py8Fdrgvu2ezHkllfNMEejzRP20+WHxNr+5eczmO/Ece540ArTW1SOoiLPeDf4rhA+X7arw9tsBGoGMV+gQyyERES/4jBsGn4RNAY0uq/JzuFsISsG48kz31KY60IecoI34vH1GfDYOeL+pdQDnKL0/7KELMqJdfIvDI9+GYjHC1CvxsO+D2BU2B4MtcugpJC5loBLDb6OAuvsCF2pu9P0ujqSqF8a1BCimAgjc0oIbCNwjwF5S9hca7NPlOEE4I6hn40eB2VzCZ4xUMTRclW0xDisVjmK9eu+9O+9EfPP2CExfjGrtZ/oVUA1rYnOspQcmGJVZvU6LW/y5eqsAj+zeGM7yp7w+BXt+PuOXsVFK21BBG2Yy7jBe865i2ZOSgMl3grDChdcENnZVdMN9G68vhMklsWGl2qjl8CaOlDcg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(136003)(376002)(366004)(396003)(6666004)(52116002)(7416002)(316002)(16526019)(2906002)(36756003)(186003)(26005)(38100700002)(38350700002)(66556008)(66946007)(5660300002)(1076003)(66476007)(4326008)(83380400001)(6486002)(86362001)(8936002)(956004)(44832011)(2616005)(8676002)(7696005)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?1v26ecbgcwYZfW+H0fN4UY+DaXDjexWZqchYOpEUtO7z4r5Czn3jl+g5jTLA?=
 =?us-ascii?Q?Yas+7e9GRDagr3XhSdoVyrAZdZMDSNiMCDeC2XQUiyWj97OSN9dZhwe8vd6a?=
 =?us-ascii?Q?9mewt9x5WCiZGCjf1HsuvgPwgr5pDiLX1JnWKrzILDvnSduugOZqNQRcJ1AL?=
 =?us-ascii?Q?Uj7avswfd57i5T9Vv3slrJnfiLwa3xiYGDanhDWmQQzxXGfaXPz1010RdU15?=
 =?us-ascii?Q?L0ZtMGkqzbduvobT8oP+zfDuMTJsgJ+jJ0gelq31TRtLCvgwwTEHDTVZVg1x?=
 =?us-ascii?Q?biGBzWj0l67B24KsG9Gemo2V2Jctg2hBV6FSaIkBbb+K9zWKRAtRNEbpARFE?=
 =?us-ascii?Q?+1+HbVECxggJ8UM5udgwG2eGJnrgSdwIjEs7OTTGYNcF6T870Vwg3la1kwAs?=
 =?us-ascii?Q?Bw9D/xv/1cprorhHz8FHAIv6cNVpPr7EvSl8G23iQERiyyaPgacyLbox4/tm?=
 =?us-ascii?Q?ViNkqd7kPWQp6Yqn28yNMPQhB2UA65+Ugh6p/N0sfrUkGH0j8f7HT/y5+UGH?=
 =?us-ascii?Q?SBNF6v2RQpD7+dakW+u1Qoi0HlVmI6faHZ4h7S+ECOj3ycgJXtr0YVToLmhY?=
 =?us-ascii?Q?wHE/YR3ONBGCAO6ID0fEHuAGxTsHL1JJxDecYpnDkqMDdhRHJxpE5e5ABso6?=
 =?us-ascii?Q?s0vANoIJnH9ayVLLsV16t+rKwDnzQeuyPKPX+0t15SSM1AHdbVpVcg+4IWeT?=
 =?us-ascii?Q?0fasc31SbIHAlYF3BYYBavxjUmFsqZT/b/TYe5pO1Yh+5fP9DMM9x1/HG2Sb?=
 =?us-ascii?Q?VRonGYrkR1RPOXk7FCk0DiEHaKIZwSqRX91UbovbOV6HPfLlEXPJx1hzJeep?=
 =?us-ascii?Q?mrHYAsUIAr1xk1y6lJ8yg2rI7sHS1LE5reoAO96XvUAU1dN4CVVx9EcUFI3h?=
 =?us-ascii?Q?bzI9aXKuG/zPfy6SSypymR9F2LGnTUEhFFPMlWp1MxiIE21lLR0WmchE3K3F?=
 =?us-ascii?Q?7FinrWSuTncHmxcnkOIw75Mrzn+vlu20eDWitLqeJ84Ov/FCavcO3HNOUSLq?=
 =?us-ascii?Q?+cvEchrWdq4hxOXXzA2DcHwNFE/0Z2vkEGrE3KP/hVSKdK54oXRMto2QkymN?=
 =?us-ascii?Q?aVqxRtcylLfV1xmeFG1AUQsc/iAmF4+bKt81Oqm/Pv53vPZNvbPrhMXGs/1a?=
 =?us-ascii?Q?/apfK6dxiqnc+3YGiVqUMtr2uZUOPm3PgcG2E1xVzrCaPY9H9phBbKsQddIx?=
 =?us-ascii?Q?/rca0eI7E5HMkJ+qP604d/S6NqlCwRJByR/N1FmfccUoY+owd62Zv8XPglCC?=
 =?us-ascii?Q?7DqXFx2tutgrraAc2LSwoWYqCkQhDSj1RqkIZEFAN0H59PweqHRhprL3+MN3?=
 =?us-ascii?Q?cfxMTRyaWlipAZvjRSJkTNg5?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c15b01e-c070-4d2d-c049-08d90bd1da0a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:16:58.5492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8jcYuFPe3YWzkxgespfZS8Pg4q9yVIleD1MYpB4l85PD3OusC7llKSbtMqyFlZJWaem4RYE0z2S/0CnuxTw6eg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2640
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The encryption attribute for the bss.decrypted region is cleared in the
initial page table build. This is because the section contains the data
that need to be shared between the guest and the hypervisor.

When SEV-SNP is active, just clearing the encryption attribute in the
page table is not enough. The page state need to updated in the RMP table.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kernel/head64.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index de01903c3735..f4c3e632345a 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -288,7 +288,14 @@ unsigned long __head __startup_64(unsigned long physaddr,
 	if (mem_encrypt_active()) {
 		vaddr = (unsigned long)__start_bss_decrypted;
 		vaddr_end = (unsigned long)__end_bss_decrypted;
+
 		for (; vaddr < vaddr_end; vaddr += PMD_SIZE) {
+			/*
+			 * When SEV-SNP is active then transition the page to shared in the RMP
+			 * table so that it is consistent with the page table attribute change.
+			 */
+			early_snp_set_memory_shared(__pa(vaddr), __pa(vaddr), PTRS_PER_PMD);
+
 			i = pmd_index(vaddr);
 			pmd[i] -= sme_get_me_mask();
 		}
-- 
2.17.1

