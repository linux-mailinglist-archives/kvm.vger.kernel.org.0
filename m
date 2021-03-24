Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD51347E97
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 18:06:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237117AbhCXRF0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 13:05:26 -0400
Received: from mail-bn8nam11on2078.outbound.protection.outlook.com ([40.107.236.78]:50401
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236991AbhCXRE4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 13:04:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hnhL2GWWb++3z+SgRuNKWAwzNndz3bqYahuGsnARLsCmvtO7gf9ILA1rEVv2uhMALPPhCUI7E7hSciglFfSm61rArI44MfauYhmKRX6VseuaC/xrsIBYQQlK0cFb9tq7yvZE3E19qVxFN7Uq80dDZftC69TWNEsCzv92Fur8odGCS0s/S57/uULReCwlfZAmRmuHt1DPuUcUSDTxBtM2R/jalPzsed3F9h7c+0fY2opzfS4UYvoBmRidHKmFwp/Zs2pxVwzcO9RFWq+AX+4O0FEreG7cf+CIr+OZXIyecxO7fS8DorhQd0mTJ3hhcVpH4aJbqdM7YrXWNQQJ/0o+Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A8bf57MDVmdHiaGAaqUquc6Hxo51aEZoGT7xxVA24Rc=;
 b=Fto2tyuIyMI65690jClJA3/OlWqw/+4QxXfE9Jyi6g8q3n9yIGLflCbktL7c/IE5cIFqArL46W334eewmbbvuBXak1Pv7z/rF6Knz+DDNKs33Yt8+Yr6aFV1bnXXQ/6oYFaZz+faGFI2Qp3W//mVyMWFNTbW0ZbcMMDaXC8kisGkJYGj6hiVdBHuwDBW6AbnUKamWc2eGdCw24XiXVJsX8MpOLgCZTL/R9TPHiKW2nfKmDUoxWDyXNS5sq0xh4g77W8LJLnWhi5ItvcRkBk5OnTAWFL73snU8eU7c6JrzNcjWiui0ck2xKZXIv6iNR6/+NldEAOTGRhFHstPjJtF9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A8bf57MDVmdHiaGAaqUquc6Hxo51aEZoGT7xxVA24Rc=;
 b=YWOjpPwEGhs9VXvJifblobJu24Ex033HYoexLgDq6efYhuRR2KDW1+9QNYtRYZ891iW+Bl5cqYeRhGPY38zpb/e0Jj7Z3h0KrKL624FvBRyupvrrXu71jqBHfDt0d+Abrkl/x0nPsLaY4gGqdj218zUPHo/5iHiaO3oxCy8BTN8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4557.namprd12.prod.outlook.com (2603:10b6:806:9d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Wed, 24 Mar
 2021 17:04:54 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::30fb:2d6c:a0bf:2f1d%3]) with mapi id 15.20.3955.027; Wed, 24 Mar 2021
 17:04:54 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org
Cc:     ak@linux.intel.com, herbert@gondor.apana.org.au,
        Brijesh Singh <brijesh.singh@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [RFC Part2 PATCH 04/30] x86/mm: split the physmap when adding the page in RMP table
Date:   Wed, 24 Mar 2021 12:04:10 -0500
Message-Id: <20210324170436.31843-5-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210324170436.31843-1-brijesh.singh@amd.com>
References: <20210324170436.31843-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0210.namprd11.prod.outlook.com
 (2603:10b6:806:1bc::35) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0210.namprd11.prod.outlook.com (2603:10b6:806:1bc::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Wed, 24 Mar 2021 17:04:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 73a31ea9-7f51-4e92-814f-08d8eee6f1af
X-MS-TrafficTypeDiagnostic: SA0PR12MB4557:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4557DA7DF3966DAA5B469652E5639@SA0PR12MB4557.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l65OYkmUCtuthcaIltPrsDTDzChNSDdkNdpR6OB+msGuJarNMeKgy3JYXS0kjwJ88thtkO/Z1OAffvq90/nVPyVcCuN7RKDuIIZYwOFiuZL10aqQJTeO7liQVH/l0fEjhUU8jOUphD84sUPMyb205TqIAC0BJv5GoekQy/lnWlPD5ScKzUNiy8cfIeDFyZLLWPsx8psFG8hZ1eXX+xPYpAe4xbViUe16HAnzmYQ12xkrplBx6Wh7zf+bBMjTbHsSZ85sIOek8Ne35uv5QgFFjDZ6je6e8PedCI4K7gL9eTAgCAAWV/TaxFfpZJ/pw+HIo+lneWszRnvb/+VGep23J+b9MFD2Ihv+08PEEaHSE84y+vOVFSGHyMTzNsV1dku30h7jsyTRB3F79gLCoIKYN/oE/lXRNI80ocfOaAzj8H2qvVTDyJOzkp8zCjqIAduCOT1YOSV6JtdaOoy0PSYXaxUHMoUe3zJsfilYXj4JPnTWS27LuF/+T5X82atwur5xil+TvIWhtfw65ywr+rY56tc+6eytjmjibHGuVgMOItNT66dwdPxstOiywm+C8QgA4BlREfJ1spiZP6NHcjC3b/xked1JXgK67+pvb4BWWZ4dh68uRm6g9OIbJEs9V9J0MQqFiJymF4r7m6GDjgegYo51V0T/KgAZQ7wwqhE5rOg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(396003)(346002)(136003)(39860400002)(86362001)(54906003)(186003)(44832011)(6666004)(4326008)(38100700001)(26005)(316002)(66476007)(8676002)(16526019)(1076003)(2616005)(83380400001)(5660300002)(6486002)(956004)(52116002)(8936002)(478600001)(7416002)(7696005)(66556008)(36756003)(66946007)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?JBTAY+acsWekW9eXsReuzp+I0EH7YSzTRzI8lWToBZyBxJ7eVUt+RsVAR4AS?=
 =?us-ascii?Q?kiut9rUG//9FNpcu1KdwutbwzJ23ayycKFotlYA2C9iHvsU8KbMCZoAypiXq?=
 =?us-ascii?Q?9HMr8C+owSTkHEXNOQB1lo/zu28WVcoSBigkl2pANNPmABHNJ2ENyF86it3l?=
 =?us-ascii?Q?iwFLq0ibdSHB6VzADiH5dRxt1sD+6iX56sgb6pHn12eH4qtIPNnbLvoPPDse?=
 =?us-ascii?Q?IUpAtAth9qJfyiWIuYvt+SsuTx2Hpb0v+3zKK5LnQvlkk2IWw+cg2bsW4XAF?=
 =?us-ascii?Q?sqoe06OFdwZE8Qg1ncMd9TNSKoLUGTgR/FEZeflctyl3/81dCKtnmzo8imhD?=
 =?us-ascii?Q?OTOga2zXkRmxix0LylpFnP1J4NkCs9tSeoduggbGGx5cVIZLPGO1UjatB55/?=
 =?us-ascii?Q?g3O/VEsWaKm93Z2TOGjbs+XE2TAJtnajhR05W4FclD/7qmvZNhsTvies6We8?=
 =?us-ascii?Q?Vt+h+h3KYJcch2W7qjThoKZi72RAHx9jqoUjBWGR1t+J/j8ygHZH1ZlxTjM/?=
 =?us-ascii?Q?eGo07fViFQA+RiEhN5vOVywECFBOQNBGenlPUSM5C2ZpfdZexW4Dk2k6ZZdX?=
 =?us-ascii?Q?fN7WI3gZKvLSM7V33yR9AwRTkps6PBfZrE9QNO/l9ah5MAcu5QxapUkt5Pwt?=
 =?us-ascii?Q?0f4CjS9AoAcGAMdJAFMM3HJ0kj2Zho6PMnMzDOPNz3ltyLqxL2+Jub8JlfUe?=
 =?us-ascii?Q?+oInVQc5o9A/8L1F4bEIkorHbJQSWO4SYyGpbN61SWhrwwZ2SuYVqmAea2a9?=
 =?us-ascii?Q?85j5kyeK6bCBC8RXcZxQ2vNJHR2/aPUuqrcr4nRQsdai8n+bV/CI/GQA9Ebj?=
 =?us-ascii?Q?ivNyAxqxTYyL8hDVHNSmrgVy8ltF3M600Zp6o/jAL8vaeHjpX3tuUCsdpQUW?=
 =?us-ascii?Q?cOtpP8d5+6wA2E7xuIVBKu+PM54UJH+JxdBk578Pg6wEskBd32pQGCec+EAv?=
 =?us-ascii?Q?x2mliW1WD+3DqBbptvtvZgb8h91flk6h3ked0V+l/lYr8hTxU6rj0kAcdpw+?=
 =?us-ascii?Q?sq/6bfmy5NU6bBisrzYhospwul8TEBLgo6GLJazWgMOvU6nP7RKFaoZj5rzf?=
 =?us-ascii?Q?xKaLvCC3kwwrUAm9o5uyAuye//R8/+upA7CFXwp49yvf5A4JMfPAUzAg/Tlo?=
 =?us-ascii?Q?FCfhWkFPal5z9svvQuK7fGZiGc8UtdQ2a/iQ1uAiis1KidVxw/5mtoHnQwZv?=
 =?us-ascii?Q?XUfTouR35YK1hGUMqDsjMP+tFltGdDruWRNySqnnbCi50N5+4M9UthwoP8pR?=
 =?us-ascii?Q?zFc/1CsqdjSu8yJ3smh4lCb8jLBjhwwFSq/poZxIPY1HSrnRTEh3sKfgCl9M?=
 =?us-ascii?Q?YWehfG03y99XD722wz5TwqrG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73a31ea9-7f51-4e92-814f-08d8eee6f1af
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2021 17:04:53.9563
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nw3XjxSR7e9xx7NAj8ohZyeektuVxWN/ssYx8W90rWwJMv4Zf2Fh2JkCqC48C+GI8IOdRR2Lkp9yNF7IQmSTAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4557
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The integrity guarantee of SEV-SNP is enforced through the RMP table.
The RMP is used in conjuntion with standard x86 and IOMMU page
tables to enforce memory restrictions and page access rights. The
RMP is indexed by system physical address, and is checked at the end
of CPU and IOMMU table walks. The RMP check is enforced as soon as
SEV-SNP is enabled globally in the system. Not every memory access
requires an RMP check. In particular, the read accesses from the
hypervisor do not require RMP checks because the data confidentiality
is already protected via memory encryption. When hardware encounters
an RMP checks failure, it raise a page-fault exception. The RMP bit in
fault error code can be used to determine if the fault was due to an
RMP checks failure.

A write from the hypervisor goes through the RMP checks. When the
hypervisor writes to pages, hardware checks to ensures that the assigned
bit in the RMP is zero (i.e page is shared). If the page table entry that
gives the sPA indicates that the target page size is a large page, then
all RMP entries for the 4KB constituting pages of the target must have the
assigned bit 0. If one of entry does not have assigned bit 0 then hardware
will raise an RMP violation. To resolve it, we must split the page table
entry leading to target page into 4K.

This poses a challenge in the Linux memory model. The Linux kernel
creates a direct mapping of all the physical memory -- referred to as
the physmap. The physmap may contain a valid mapping of guest owned pages.
During the page table walk, we may get into the situation where one
of the pages within the large page is owned by the guest (i.e assigned
bit is set in RMP). A write to a non-guest within the large page will
raise an RMP violation. To workaround it, we call set_memory_4k() to split
the physmap before adding the page in the RMP table. This ensures that the
pages added in the RMP table are used as 4K in the physmap.

The spliting of the physmap is a temporary solution until we work to
improve the kernel page fault handler to split the pages on demand.
One of the disadvtange of splitting is that eventually, we will end up
breaking down the entire physmap unless we combine the split pages back to
a large page. I am open to the suggestation on various approaches we could
take to address this problem.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: x86@kernel.org
Cc: kvm@vger.kernel.org
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/mm/mem_encrypt.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/mm/mem_encrypt.c b/arch/x86/mm/mem_encrypt.c
index 7a0138cb3e17..4047acb37c30 100644
--- a/arch/x86/mm/mem_encrypt.c
+++ b/arch/x86/mm/mem_encrypt.c
@@ -674,6 +674,12 @@ int rmptable_rmpupdate(struct page *page, struct rmpupdate *val)
 	if (!static_branch_unlikely(&snp_enable_key))
 		return -ENXIO;
 
+	ret = set_memory_4k((unsigned long)page_to_virt(page), 1);
+	if (ret) {
+		pr_err("SEV-SNP: failed to split physical address 0x%lx (%d)\n", spa, ret);
+		return ret;
+	}
+
 	/* Retry if another processor is modifying the RMP entry. */
 	do {
 		asm volatile(".byte 0xF2, 0x0F, 0x01, 0xFE"
-- 
2.17.1

