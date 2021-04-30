Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0D536FA7F
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232562AbhD3MkE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:40:04 -0400
Received: from mail-bn8nam12on2044.outbound.protection.outlook.com ([40.107.237.44]:33505
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232389AbhD3Mjz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:39:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=njFQbClGwmvA9UPyyTSuGfOlI4T0fNydWOsKKhBzfxREHdMU7eXLca/yBIy+aouYpOm54WLTRKHToJYpyrI18mkODYsw4vopK7bMs9T5/SlOjnwGp+6OJX1nRh58i3c0OkVLvTqLhMDEqZQEab+BhbkRghH/4oe0KNsd5tc3i9PwHBXZIaSAjAD6hxoYEp8ymqw5ntbN18J0JmYhDs5tSDIQEdI3UI6E7ZuVI2X/D5b8mlahWdmFeI2VlTnMlDIBvXxgqNpoDDd72ncRkFJo8+MsOU8tS/Zwg2pEy9ZA95bEn4h38hWKGR7B+1AluhiGpAPcUlaRJ0lgWth7BeX9JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RfqACMzDJKdDBS+CBPxjIqKdFFd7BasWtVdzsmv++zA=;
 b=n+LaatdtRNUymHiVSYiDAmVFQhNEwsXqh4owZSv3kzlJok0eyDiTxPel5a0wPy0w7J5SF55foQyU49g/QjjFYNedndFpKZ/dcPXUybxSusMHPNpPHpqD+VgMgKBrJkgxLkNPe0E1V8PP22HDH4gnT6oIu+cROFD3fz8bzXZDF6ftbhogbPTgC+KpI9io2VkwZYlAd9mYHV0IBdsOYDEjnjsMVdzxltO89F29Z0tymj9jo+3rFGrpXpJ6gRisfUinpV/WjzdhWqBObD4hVmqFK88pAj9vWA0C4Fo+oDWsF1t/M916rjFl57T6Qt1iQxZxQJHN+ySn3SENuUquj1ylbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RfqACMzDJKdDBS+CBPxjIqKdFFd7BasWtVdzsmv++zA=;
 b=Sn+ae15lh16rDkkAHVT+SZYPT92Zf/GIjKyXhYrmfDdoh9Yo2EqIPvneUg6tSLYNNYnDOTf8/cpXV0krkquPU3sWVnsN8M1lobK3PK9FhNFFR2TItvCFunKPjpzFFIZVg/fgrc/a+LLlA/2mh2ekANe7+p86FcDgLV5keaeP43M=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2832.namprd12.prod.outlook.com (2603:10b6:805:eb::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Fri, 30 Apr
 2021 12:38:59 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:38:59 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v2 08/37] x86/sev: Split the physmap when adding the page in RMP table
Date:   Fri, 30 Apr 2021 07:37:53 -0500
Message-Id: <20210430123822.13825-9-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210430123822.13825-1-brijesh.singh@amd.com>
References: <20210430123822.13825-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0089.namprd05.prod.outlook.com
 (2603:10b6:803:22::27) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0501CA0089.namprd05.prod.outlook.com (2603:10b6:803:22::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8 via Frontend Transport; Fri, 30 Apr 2021 12:38:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ec064fe-4ae9-4c00-981d-08d90bd4ed5e
X-MS-TrafficTypeDiagnostic: SN6PR12MB2832:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2832BE087F0B40BAEA1DF6A6E55E9@SN6PR12MB2832.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TL8x5/uhsl28WqyANy5/w7Omb3ryz/WTsiTpmoZz41CrOcaKwMo9HZJ5Tjj1RdadiXzutQkXFaJQP9ufjFqd8yE3/D/Vginq1Qw/25NB1WGueiDrduK/YZH/1FJS9sYHrvAOwY1uv5aO+2L0dADpV5jSb5+ZL69XaBFNTEgeMrkOfqrwn/XIvqzOkXGoz/lOseIFXUJen4BpT6UvGF1kNL2gvVPBFyKNjLEj39D8zYdGnl0d0A6cfrqkX2Ee0HFNXGVsusjlPKkHw7eteVHx+GEpLMKsnDGTLryvkgDOVa7+yyhEvWPeheNPZ2JEcSywexaipy62XXEeBWcE3VHUTVhnPw/0Wia2enShCi1PBSeEeRHiHxWl49lMbRbgBELck5nc0xYFbMRJoSTfLuQoKfq0SPuqWop36k/cW6JggfPG6TqO0ydIPP2iaXvDcQGXYd4q1H+sXYuR/6rp67blJRI+zNU8yrpwg/P8O0hMxy1IxRO7GnLZLnFTQ5AyN9aUNY2kdZa6ubnlQQqBQjYF104eFCZ7UAs7dw7a/5/BrsfbmTxrRmt/cCH+LFLI2NJqUXWm10u2zjAfi0JSUIQGAtpzE9KYlfyGFK0wdvOhna1oIUCRqzFDsVHPMbHY92tHp1xmL6WGLLu8n0fBXVFtsg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(136003)(376002)(346002)(66556008)(956004)(7696005)(66476007)(6666004)(2906002)(7416002)(66946007)(1076003)(52116002)(38100700002)(186003)(16526019)(4326008)(2616005)(6486002)(5660300002)(44832011)(8676002)(26005)(316002)(8936002)(36756003)(478600001)(83380400001)(86362001)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Q49HaHlwj9gGwuIakfjM++kqt4Jhx1XrhmIB75QAuBGbSVrI2Af/F8gD6brw?=
 =?us-ascii?Q?M7ggJsz3MIOjT0W3skQCquGhqoD+DdldkrFOhgL97e07YnuEGPrw+dr/8Ql+?=
 =?us-ascii?Q?AkzW1xFYqSweutHijFO/XBJjEo7nbC5hlgdOoHwZII63YErJNCWxIJjEjlQl?=
 =?us-ascii?Q?GkBpviwBQsQzh5gW451EYeUnY8n+zJDnsWfI2/XeTppagV1b11eYPhh0gPwl?=
 =?us-ascii?Q?Ed7B39PJCE2MIBwQszJCiaHdNgDcgp2W4h9gJU9jOlZsmhwIvmmRxulHuArf?=
 =?us-ascii?Q?WmtS12zVaEXAbBLRZHIy5k/CBtn6kblOVHllyrr07AFaupYUbGH+/FJ+mj5M?=
 =?us-ascii?Q?/8HAd+b7LkWFIef+WQc/tKm8JkNY0D7B/1r0LI8VrTg101zH+E+SUQv31fyZ?=
 =?us-ascii?Q?wRjnYb18BE1vHtC56Coq4i9YPwLESgoacsYkVX0bdSPJ5tiQmRrkCpwCqY5N?=
 =?us-ascii?Q?KyW9qIH+vIG8htgeLPUYI0JzU+x4B9AhwBhkB5J/ln6Bngp05ozOChr91Q6h?=
 =?us-ascii?Q?7AyoCcYpgj15LjohJj0NUofH0N2J4JulaE6CJMlLes3mcjAeLl4yy9JA7T67?=
 =?us-ascii?Q?vjgvQhd3rOs4WY4BBWqn0bzqyn/eEK+qDntqTk/4Z5gzfzDUJm1Yb6MblQ4L?=
 =?us-ascii?Q?wTXwZfBe+UXnM4hJGcnNSLuEssyhr3EfhCFVnxRmak9ZgoWIXli/eRjsZqoq?=
 =?us-ascii?Q?YzqKeiXOyPlkoH6/+JOcM7Qzwk/j+VVqG57XN1DDZwo0itpmZHfoL2YjvHxg?=
 =?us-ascii?Q?86ectV8/tvV/847Wi5vtvmYV81vmHlWDi8EYtabRq6kufNoIrHK0Mi9KIVGL?=
 =?us-ascii?Q?mkwwBQixCwkrUPOXUd7n2kvlwfJe+LEu5NuYm0F1UnW84nOx1SR3Lc8xLYmV?=
 =?us-ascii?Q?730+8nhMe/5XMY1r2ow93auVPwoxof8DqTuhK0cU7dTwBeIMac/KMufjn2wg?=
 =?us-ascii?Q?Co3oDYC8VTXB7V8pXmb93zVmoNDvPygPxUM3f5dutBpY0lJnodBOkuEeP8Ny?=
 =?us-ascii?Q?LKy5xG9V1c1fvD4lSYsxLMCuIp0E7kozx4eFehSt0XY9AchMxYXe0OiBkcVQ?=
 =?us-ascii?Q?lLtisvOkgMdnA3PeNeWgdzkSr1VVupZoLVHxa2cEWiRjnF78gpB6YAo1/GNl?=
 =?us-ascii?Q?Qh/Fudh6tqqMUlfxeVM4ujYysdvqIoQoi6ndB8tGJtGh/Yf5/Fmbje6hJCAe?=
 =?us-ascii?Q?3t3TopY8Hf6aHewamWBFMwPm+CXKy3BQ405Jqd2lqn1jFwnAIU7HhnUnW+Xa?=
 =?us-ascii?Q?h1hQX/Rnp78Hf57DQs2G6f5SUHuY1vmAuN+XETUvn+b4rZQ0zCFqjZKCumqX?=
 =?us-ascii?Q?I9oi/AOCRlWdt6xPKwthHcuG?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ec064fe-4ae9-4c00-981d-08d90bd4ed5e
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:38:59.4596
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QRwZTKhnOy1QE4IDqmK7YZZ9/f3c+ja1rTdsa8NISNUbnZlEHa7cRhQRzghzkYhq66mDh8+3u6cJbDnfLgMsZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2832
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
will raise an RMP violation. To resolve it, split the page table entry
leading to target page into 4K.

This poses a challenge in the Linux memory model. The Linux kernel
creates a direct mapping of all the physical memory -- referred to as
the physmap. The physmap may contain a valid mapping of guest owned pages.
During the page table walk, the host access may get into the situation where
one of the pages within the large page is owned by the guest (i.e assigned
bit is set in RMP). A write to a non-guest within the large page will
raise an RMP violation. To workaround it, call set_memory_4k() to split
the physmap before adding the page in the RMP table. This ensures that the
pages added in the RMP table are used as 4K in the physmap.

The spliting of the physmap is a temporary solution until the kernel page
fault handler is improved to split the kernel address on demand. One of the
disadvtange of splitting is that eventually, it will end up breaking down
the entire physmap unless its coalesce back to a large page. I am open to
the suggestation on various approaches we could take to address this problem.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kernel/sev.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index a8a0c6cd22ca..60d62c66778b 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -1931,6 +1931,12 @@ int rmpupdate(struct page *page, struct rmpupdate *val)
 	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
 		return -ENXIO;
 
+	ret = set_memory_4k((unsigned long)page_to_virt(page), 1);
+	if (ret) {
+		pr_err("Failed to split physical address 0x%lx (%d)\n", spa, ret);
+		return ret;
+	}
+
 	/* Retry if another processor is modifying the RMP entry. */
 	do {
 		/* Binutils version 2.36 supports the RMPUPDATE mnemonic. */
-- 
2.17.1

