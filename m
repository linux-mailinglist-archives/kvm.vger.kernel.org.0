Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 091433F3089
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 18:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237025AbhHTQBc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Aug 2021 12:01:32 -0400
Received: from mail-bn8nam08on2041.outbound.protection.outlook.com ([40.107.100.41]:41272
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241373AbhHTQA6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Aug 2021 12:00:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VFOr+4Wo1wkk7o+vltwygUNXB/r6MYOCrKvd93o3gcA4TLe+lFncfvRL76k8r1peGHFinz5kfivSlbmsKApLK7NGw/80EEJ5VniRFukN6QgQ7QMGEBITvrvs69Fdz8D5CD8hSgOEKvT7VIpFic5rad95m6+TvUhspprh7icUN90Ao6O3hHFK3Mis571I0wXa6GCUxQbJ2NdVr7vZHcf2v7X04pakaFroyjYiCo0anNmD8gxWfDloIe7AucBdvBAANeFRAMiBhuA515NLbaGGqiYvfpJ557WQXOmIlTi7F5N5Szzlj5AQdlA2SC0eb/G7guzwC02+CHdlyG+WmYimSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IJrrzVCkQVOXzXVT/Ya7UFXdwNx89qrDzohEsUIxUCA=;
 b=ZK2q0k8G2bg/clGTbSXl3ZW8nWQsHdylW7VpRDFBo0SAjuRLa8nCUy61VuIIHfmJ0B+UCfHn43eeUFs/g2PPIthhNS38nz9HHu/o8cMCvYkpUzdaluqee4mi5d3nRNCEXZelHhgmoWbO5IzQkPWXy8LPFyth/EwMda0g8kg1gAeGvzttEBiA/vvZEP7LGS1HekCm0mUt6AGkc0Wu6u0WsqOwOMYacqTeFJmQP+vCWUReAR8M91MSCwXVIIHpB3YG8JdGazjz/MnNoYruq00h6JsmNg0R4sNyy746aSbllrOUqeZMtCD5+JHMng8Of5njGwhRDsKgrCTvR80M4uPmOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IJrrzVCkQVOXzXVT/Ya7UFXdwNx89qrDzohEsUIxUCA=;
 b=utHhDfyW93VOQmHziTvbs5JbrsnzCtNpOl/1U3BHZgtuHpfFLCJVDieXajulEQ7tVLi/IAbP4BI7dxpY+HWoZtefq0j1e16g0j+0wqx249LlUeNRLW+JgRMfpAbssS24BU5Hphwyd4wzDkWqKGlvwy4b39OiUOm173FlN9sUE6U=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4384.namprd12.prod.outlook.com (2603:10b6:806:9f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Fri, 20 Aug
 2021 16:00:01 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::78b7:7336:d363:9be3%6]) with mapi id 15.20.4436.019; Fri, 20 Aug 2021
 16:00:01 +0000
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
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 v5 06/45] x86/sev: Invalid pages from direct map when adding it to RMP table
Date:   Fri, 20 Aug 2021 10:58:39 -0500
Message-Id: <20210820155918.7518-7-brijesh.singh@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210820155918.7518-1-brijesh.singh@amd.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::11) To SN6PR12MB2718.namprd12.prod.outlook.com
 (2603:10b6:805:6f::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN7P222CA0013.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:124::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Fri, 20 Aug 2021 15:59:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7d4ea761-e2f1-4a5b-1fb9-08d963f39122
X-MS-TrafficTypeDiagnostic: SA0PR12MB4384:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB438451508971918753BBC82BE5C19@SA0PR12MB4384.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 854yK61wcPQkSmFZ0uargEhAZ56Ohqnnvoqs4EdFMBkRzN1nhzr37ND1xoNFN8TR+O4/TL3SXXAHdZauIWumSwSH4ZK3YlXsIq2kxuWUDBanhUYsMK6ZFU2/l2FAuaBmW0ZoMQHCPPJQ3TgnSzRq0os2q50veNnWmetHEF9RkfnsHCv7BGem1lGqhHdga1Y+44yoSTnqgiQ80by3XTlSzGN4uxxeLA9wc3W4hZf/CBiDpAb7cmkBbm+KvI8x2oFC2FcgjvvC3782rUypXKw+yOKZZVqXp3/Nxt7XWzSmilen2Bjo7YoVTEGB3zhgV2Wqg15cOxDvHa+CnL0g1GaKQ48WW3USGrRkG7rpGEwHvf+aNT2uFBvkZbmusScx8quA3s5oh4VQvxZbhGpzARKZLDMqXsqjww0clbTSw9dGjm8pOFmzKLgo+QiPGV693q2fDBbxVEeMooW7w/gqISBjRxEZA2ZdtcL3y4vl5eu6+7bN6+9ufPApbXiOFtpIOFCBjxJ88Ib1yFGswIH2+y14uX30KtU2DjiAQ8dLtTm+Grbu/Px6Lh5kz2V8TvBD25fcbVmJ8ZtfLQdok/iAPuEP3CFIQ2qIxJ1p+/DemgR5jIgsD53sEJcbQ6CfWNyxicHJ7jhJL0kEI4quoF9KBOjdoLI08ZHefHLFJb/5heiyoAhvtDq3dvhCCI9kQ0YDojt6TARPa979xML+ETjCidV1WQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(396003)(366004)(346002)(136003)(5660300002)(6666004)(52116002)(66946007)(44832011)(36756003)(7416002)(66476007)(7406005)(6486002)(956004)(8936002)(316002)(2906002)(186003)(4326008)(478600001)(86362001)(26005)(54906003)(38100700002)(38350700002)(7696005)(1076003)(8676002)(83380400001)(2616005)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dcC4wpN8TNay8mUrluDHmBnJtPU0yqYhslgy8fZFeaDNMZK8YR5a4NNH1j9x?=
 =?us-ascii?Q?G9YOm+hHQ2dRpL778vb3JJ/VD1PyZ8W5TFUpqH8mojVh9N4O+zpVIgQwLGqg?=
 =?us-ascii?Q?ffcbPgToOQQ49GGwJUaL18caHKJZSGriYuqQ+el5wjypQovJBz2Pbllp9IF7?=
 =?us-ascii?Q?TfvW0nYsoxZdatVBf79KSeYim1Tf5a07eQJGMyDoQm0xRVNwcIYICB8fnp9H?=
 =?us-ascii?Q?/TmMcsQv8EiKEnJFPqEQ0QvukbOyq7gBvOhC5tvb8JOlO2pnlr1Ebuc+xWWd?=
 =?us-ascii?Q?o7v5tssY1FwEpJsem1W6YLGOy/0h+xj7HBwChNXss7eD4xRy3eFxsQaoR49o?=
 =?us-ascii?Q?kx75ohvS19KsTCtzZQUCbzmn3v2cAyUkAAcMRUw+9jpIiYzyXp4yHqkvzIzs?=
 =?us-ascii?Q?EFbki+LuzEdkAdmBSB55NxX2rw/QCCcGEOb3ygU0xYbBun2LiIclXFPDLHvG?=
 =?us-ascii?Q?Pz4cQ7VNngpjnOLQS3mX0rc0nDG7QlwZDx/Nkq9lnBcLzQdMogvRXBO2NhZZ?=
 =?us-ascii?Q?rQy6+yykfBC29gZKfOcQm6hYe/d7omlv2caOu6qlAwUOu/1XYdCg7TRdgLXZ?=
 =?us-ascii?Q?7JckOURyxnUAcX2ScKIGKuzKeTcd//HIYE9F3sxWgqrYMqXj57VXrbjaEIrr?=
 =?us-ascii?Q?0l2n6AtXnS4B05Os0tzSilFultXdSnxhFdV1MSNafiGg0MoYMj7vNzmUIJ1z?=
 =?us-ascii?Q?avjk0XyIr0JgxtYXlc2mIiS/9FSZgdVSl7eCbazPrWjQcZmh10I9FaHcYioF?=
 =?us-ascii?Q?tTc12rpd0paZhmU+jiipL2L07ZGkBTGIwZR6LVjOJ33JDxENNCFKEUgOM8sQ?=
 =?us-ascii?Q?4n8EeGtiy5SmcaCteWJf0rcdEK3Xz8oyyd1Djbq/p/j8NDwbpWNKNUzIWrOa?=
 =?us-ascii?Q?Ph4HzCKtrn46z2txK4VNR5x/8bBNLKXD1mlnnE1uCevgWj4WUOVOMPHncpzO?=
 =?us-ascii?Q?OLMW3MZsvKsewkLgXekCj01bZ4bmgrtPvebTJ3cZeTryrb3PofNLzKQPC2ft?=
 =?us-ascii?Q?IszSLHEmk/1MX8/Y2oRPar5M7Ci5yVxUl+z9R1YKPWOR/ykaX6VftsyDBiaS?=
 =?us-ascii?Q?009JwyCmid8C5oa+MlRkX83NMbikKHTg1WxcCUH1e3OwB5Yp1mAA2pMz4Nn4?=
 =?us-ascii?Q?PhjDRmTlqXPbgJEemnPRy1ZgxQYS91D9J6XfvGN9Qx6f3wUwZW9WfPrqetPT?=
 =?us-ascii?Q?pQb9OyA3t2li0o0GcIOUhoP8A+mMg2MucSeKyl980TPmyDLjmtNmgHzyUa4M?=
 =?us-ascii?Q?ndSmGLzN37LLlapBQfYJ2Aoy70alwnMVfIyCDxg5eFG2FxrR1v74wlPUiEOF?=
 =?us-ascii?Q?X1yGjVnPkID7MbhZMdOtmDsR?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d4ea761-e2f1-4a5b-1fb9-08d963f39122
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2021 16:00:01.5069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: J8m9Auk9ybXVFCd98YPnnwUCFjTK1WtfUAPthg1tq7QO0xYblXGvS1NceMIKRX7tPWW8WvRLcIYXtfvBcvSemg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4384
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The integrity guarantee of SEV-SNP is enforced through the RMP table.
The RMP is used with standard x86 and IOMMU page tables to enforce memory
restrictions and page access rights. The RMP check is enforced as soon as
SEV-SNP is enabled globally in the system. When hardware encounters an
RMP checks failure, it raises a page-fault exception.

The rmp_make_private() and rmp_make_shared() helpers are used to add
or remove the pages from the RMP table. Improve the rmp_make_private() to
invalid state so that pages cannot be used in the direct-map after its
added in the RMP table, and restore to its default valid permission after
the pages are removed from the RMP table.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kernel/sev.c | 61 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 60 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index 8627c49666c9..bad41deb8335 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -2441,10 +2441,42 @@ int psmash(u64 pfn)
 }
 EXPORT_SYMBOL_GPL(psmash);
 
+static int restore_direct_map(u64 pfn, int npages)
+{
+	int i, ret = 0;
+
+	for (i = 0; i < npages; i++) {
+		ret = set_direct_map_default_noflush(pfn_to_page(pfn + i));
+		if (ret)
+			goto cleanup;
+	}
+
+cleanup:
+	WARN(ret > 0, "Failed to restore direct map for pfn 0x%llx\n", pfn + i);
+	return ret;
+}
+
+static int invalid_direct_map(unsigned long pfn, int npages)
+{
+	int i, ret = 0;
+
+	for (i = 0; i < npages; i++) {
+		ret = set_direct_map_invalid_noflush(pfn_to_page(pfn + i));
+		if (ret)
+			goto cleanup;
+	}
+
+	return 0;
+
+cleanup:
+	restore_direct_map(pfn, i);
+	return ret;
+}
+
 static int rmpupdate(u64 pfn, struct rmpupdate *val)
 {
 	unsigned long paddr = pfn << PAGE_SHIFT;
-	int ret;
+	int ret, level, npages;
 
 	if (!pfn_valid(pfn))
 		return -EINVAL;
@@ -2452,11 +2484,38 @@ static int rmpupdate(u64 pfn, struct rmpupdate *val)
 	if (!cpu_feature_enabled(X86_FEATURE_SEV_SNP))
 		return -ENXIO;
 
+	level = RMP_TO_X86_PG_LEVEL(val->pagesize);
+	npages = page_level_size(level) / PAGE_SIZE;
+
+	/*
+	 * If page is getting assigned in the RMP table then unmap it from the
+	 * direct map.
+	 */
+	if (val->assigned) {
+		if (invalid_direct_map(pfn, npages)) {
+			pr_err("Failed to unmap pfn 0x%llx pages %d from direct_map\n",
+			       pfn, npages);
+			return -EFAULT;
+		}
+	}
+
 	/* Binutils version 2.36 supports the RMPUPDATE mnemonic. */
 	asm volatile(".byte 0xF2, 0x0F, 0x01, 0xFE"
 		     : "=a"(ret)
 		     : "a"(paddr), "c"((unsigned long)val)
 		     : "memory", "cc");
+
+	/*
+	 * Restore the direct map after the page is removed from the RMP table.
+	 */
+	if (!ret && !val->assigned) {
+		if (restore_direct_map(pfn, npages)) {
+			pr_err("Failed to map pfn 0x%llx pages %d in direct_map\n",
+			       pfn, npages);
+			return -EFAULT;
+		}
+	}
+
 	return ret;
 }
 
-- 
2.17.1

