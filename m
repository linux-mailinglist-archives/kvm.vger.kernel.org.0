Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D014B398C17
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 16:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbhFBOOs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 10:14:48 -0400
Received: from mail-bn8nam11on2066.outbound.protection.outlook.com ([40.107.236.66]:15585
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231357AbhFBONu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 10:13:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B4jjmz0WyiuySqtL/qsRnRExj6eaotEfY1ckI8Xr59CXdB/SW3gn9K1K0AfW3kPo/k7TCcB25IIghkgJU7SWbU12EWAlFt1I5niL+LNWyCKHUBRyPj90z+Sp1wunYd6MoLHFw9XpD0Y3qeAAB7gmh0YEuSa6Z+ORDdxp4yL4eJoMQQ3ewLQFUHA/DwQgUONV/KYgUpVIDJeagwqM3rFhuXWtQeGTpziSb904wKd+up6Y2aJycxwTksFCAmAXWsk6kHzeGpcQ79dfT/mgrhtBR/Q+J17pDKZTUfvwSRLpydlq6G/wkjo6GR4FCea3YbHqA6CjtO9rVdGX/euhsAp9gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zvD91IGs9k4Jvq6g5vcETVczA3gK6OHl4yM/9fIXIJo=;
 b=MKAL7VFYuLEauwnIhAS/nsMO0BTrVIq78Dd/tLyPVKdGwITQINYZcA7GbNEpIZMxqRKWFv0yYO3Zs0eYgoNHjEEvA6p4ncAWLo2azMYObIaTaDrPyJ0+Ut/iih9geDINdQApb6lRzV0so8SiqW4s7A5FaX9koYorw0jtLbFRH8yn0vzHx39RW0VJ4XwAVbfsnH1auKkMcHmD+0xTrP1uWlEpuxTEGwkW2mJSr3WAq39z0/k/UcZVjcCEzfS+i2Vjsumi06BFLWIUEj9qjW7ekLm++O78yN7Vi41t1XDlmKc4A2j9eSEWyme+bJUM2p91IrX+B/49pW8zQwzUXnwYKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zvD91IGs9k4Jvq6g5vcETVczA3gK6OHl4yM/9fIXIJo=;
 b=0ICNBZF0YKrmwfRsgzeqqftlFMaGaEyMlhNi8C3GRy5HGHCMgrAudYvucWKJr83iO9D3Zd/yncJ7ZQfrB/czrguiA6MuGBu7o8JXfPVLyNiAvXEO0OteUOCVlap3CM5Y+3/rV8CSlBOpCE9dN5F23WwRjgbC7TJlpY0jMrPAuZI=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN1PR12MB2368.namprd12.prod.outlook.com (2603:10b6:802:32::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20; Wed, 2 Jun
 2021 14:11:37 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 14:11:37 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>, Peter Gonda <pgonda@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>, tony.luck@intel.com,
        npmccallum@redhat.com, Borislav Petkov <bp@suse.de>,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v3 07/37] x86/sev: Split the physmap when adding the page in RMP table
Date:   Wed,  2 Jun 2021 09:10:27 -0500
Message-Id: <20210602141057.27107-8-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210602141057.27107-1-brijesh.singh@amd.com>
References: <20210602141057.27107-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SA0PR11CA0056.namprd11.prod.outlook.com
 (2603:10b6:806:d0::31) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0056.namprd11.prod.outlook.com (2603:10b6:806:d0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Wed, 2 Jun 2021 14:11:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7da2ab06-6e82-44e5-f150-08d925d05587
X-MS-TrafficTypeDiagnostic: SN1PR12MB2368:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB236820353A6BC092BE3F353FE53D9@SN1PR12MB2368.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tIUfJ3EXUOWDlMEdYAfLX3Ww0rRlDsurS+gKAc/rY2YfioQGOu435Buq57JvXqWYFC4Pq6OAM7DbeI0zJLu/eMt+tYYuXjbKq+iijU6gLLnQtiw/ekPEfd74SRyWX6Bi+SBUHXz38VDiWUsBCd3XvTE32q4zv5VmUw96Elb8lRw7ryLjSnV6GljQqPSMtv78sjHN/xOAnTBfc5t8nlkRqs+qMw9XKE7dRR0EkF1X3MZSqiY5X7yi07CHqxjmyPTH2gduU2svehkyCvo2tDhsVUdZyaCbFABbUO6qnAS0nRrmtKHw3WIeh9pSmPikNg5bu7hZr+chT8GwAxj0N/Y/FLHHdjcvCMkVd3esFkqSuwnA470s8tWVXFKHuLXXibqRgTdoquvFZR+lHTDDznQSQiMX/ywwIcvemuJeeIw9D0Xq0qTNfqhvLSJm4YciGpDIW4pTWWZDqZwmYvqpS9aox0EmQ7iQkLiEQ6RzVRm+bnVLwfs97M6PlVRcQGR1l1SV6XN9//D7XWvnY5mbOo6ITI82eSakZv5DyJvPplO3FaHqeF5Y6KBjVoY1te5VEuYan+3i7kWMoYd07b0zoaen/tZi/AIw0JWrQNGvjgh3q2qVBS8qk20YPNJukp3DnByIRc1IV4zkMmSonb/fhvH6SA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(366004)(346002)(39860400002)(5660300002)(86362001)(6486002)(52116002)(7696005)(44832011)(38350700002)(38100700002)(956004)(2616005)(1076003)(8676002)(7416002)(8936002)(478600001)(186003)(316002)(4326008)(16526019)(26005)(66556008)(66476007)(2906002)(36756003)(54906003)(83380400001)(6666004)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?jB/qEaJppH0RXZsN5vH93CgF5ZHxvkuOTEAbL/CRqRSLX5dykJs8oSNk5cax?=
 =?us-ascii?Q?hT4hs6vKUiyiEexSE4TbAr+S+V3+0oHkvmwq2j7AihKHQ+qgALPL1zSgsXTK?=
 =?us-ascii?Q?4cTxBsM/RH20Q229zDF50TMqlol4y8kE0//o1Ivi1hS+Iw7Nct8rdPkyazUe?=
 =?us-ascii?Q?qcH01Ub53TLPs9uaQc5XH9WMtaxuzKjl1AGlQk8Cp5cD/3qyWUxtabjz221d?=
 =?us-ascii?Q?E2GfQBcl06jpB6hJ697GcxYU0zwllHRRRu81FYjz2Gt2XpXW7sQZ6eicslhl?=
 =?us-ascii?Q?0l5YQJK/x2/vpasf+9h5MXBsGxp6qy/pV8uerQYvfk1oKMDthYP7nGRxezwY?=
 =?us-ascii?Q?+YoMndGToQDIMBlDIS149EU7dOLlJN9w8dF1zJyK7YAuVU1w6aKGFa0yF60r?=
 =?us-ascii?Q?wXpQ3PT1RcKYi/nPm4Gd/PkfSj5pEsDSsd15XcfgJf3cbajkXDE4SBVYX8tu?=
 =?us-ascii?Q?g3U3UqFqzVJskUR3wrICkyWqYA9XP73j2Lm98rvypUGFoLVzhwdxsl6WGGe4?=
 =?us-ascii?Q?PmUaJ3j1krradnIlGkr+wlzN0FvYvBuV64IN6AWWIZY3He/deohNJhwBHRpj?=
 =?us-ascii?Q?1BI7iq3ts26OzKrXqF04SVvD2QRodlKoE1EualbVXBy+VClYCsrChTDIGZSR?=
 =?us-ascii?Q?3GR+w2h1VplTTcSV5x5YjJ1L4GFQG6WWKW2IlGkbaon5hE9yBXlihYMVbrDw?=
 =?us-ascii?Q?upNUPMsGojNnNtFewoqJjknwEReu521uWIAHIDqqX5ZNSaWDzc2Pi3ylyCYj?=
 =?us-ascii?Q?ZsWmjyDzcWUe4SEdozKN0esXRpVbVxiFFzIxMVuWWI+Ndb6X6kHf49x0PQEf?=
 =?us-ascii?Q?hyxqUCGtgmS9j2gy9Z41hTZwK1qqAVvme/qHT5iIvFMKxj+BKJOAzG6yZ9ES?=
 =?us-ascii?Q?dL0Y0B4OQuQN0dG9dylHS5rUCw94U3qiVj3UC7VAMsd8j+PHM6hyFDgwGpCD?=
 =?us-ascii?Q?/IKF3Nuo6TFk36oRsCZiwvUXaIv4Xoc9NGOQNcXF3JP3pnPbg0xBGVRtRxLn?=
 =?us-ascii?Q?2x2rC4XUkYNWJcseMe4ywFAvQ2s0p4uhwt8NbS8LCtBHv4XYqXyYMuIPV0t+?=
 =?us-ascii?Q?P3L6WQPdlCYn/Lz4rsmuA0obaEAYJxE40v/YC0+BVPdnnCrBIDkLE+Ffwcf2?=
 =?us-ascii?Q?YLC8eW5+pcdCTD2yPorxesbWUKNEitlLw7gkakkEtBLT2AbGIU0+bNfjto13?=
 =?us-ascii?Q?jLlPnmFdnrVuTG3B2V+i8vfvb1UU1Xp2oIlSRLCsZMIDkISHN+cjVkQslPtY?=
 =?us-ascii?Q?Ijf9o0rVPtXCtcrMAAi2r41PgvCD60BCf6igxoDiaKaWo0F5tODBslO8foT6?=
 =?us-ascii?Q?5Zabr5hyMHyNtcDC6u7IAmrE?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7da2ab06-6e82-44e5-f150-08d925d05587
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 14:11:37.0402
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tthya9+tYbJ95i1fOViX6hsv2cfxwobmcQCx60IdWENmLIPqVA3C6HbfbHskkDFqBMWkDV4mwDtXuhsw4ivx3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2368
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
During the page table walk, the host access may get into the situation
where one of the pages within the large page is owned by the guest (i.e
assigned bit is set in RMP). A write to a non-guest within the large page
will raise an RMP violation. Call set_memory_4k() to split the physmap
before adding the page in the RMP table. This ensures that the pages
added in the RMP table are used as 4K in the physmap.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kernel/sev.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 9727df945fb1..278be03c64f0 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -2256,6 +2256,12 @@ int rmpupdate(struct page *page, struct rmpupdate *val)
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

