Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13E37398C24
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 16:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232040AbhFBOPM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 10:15:12 -0400
Received: from mail-dm6nam12on2047.outbound.protection.outlook.com ([40.107.243.47]:30304
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231618AbhFBOOK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 10:14:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a6moAQP4uLmV+lHrtETHP+z+SVUQoH9R5VOPmG7sGMolc2iKUAtrwKvDjfeQSa1WPY8qd6A/4bQUXvWx/raKjEf4g9oz8S2sncX3sI2Kx9WkTFD8sGenL8epl1RG3/1LEbkwy/6meGr9Ak32YUo59bB8fUpJ/BNzV2utfqKU688OwdNw+TGad0GO5czVxV55Lb7Sf/m7ka4+I2TTrcE/N82hMtz52qX2DcETWXAQNogYFrq2GWWcmIBKBKEnmtfx7lj9KtpP65OmVuxFK+QH091rL9jVqtyrnTcJD+Qq1MhrDmly6Tm8IvxtFB117rZgZwXB77cnFvqSZj4NcUYS2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wLzPWTu/lzqc1c2enHjemO8mERzlZ61QbqhAo6RqLwI=;
 b=hgzIsyS3j9MVGJSvSgzB64m6+32w54P9sfnthZreTW6uIcrbfYjdg5zXn7H/p8UH2swNjqT9OceQSSQUqrlIW3q/fsgz6YuskTDm/h8RwsJIm7ZTNDlbzFtsof/ytk9eKYdDxpoN9w3UdrNx/TeJ/6blk90HD3CUHeaDWNo10MDdKwOLN84FYdHGY9scSs2iWZwG3m00kzeRcj37Z0XvKLU0g85wnUbUy+GQ/H7HvIPGFZ1t0oVmhUc2BkpF3meqF6IkoowX6aUy4xOAqRVQU9Q10lXKBv994qkbRoX4vKi0bzuRg7NlI8NDyhpqgdqNoWoLG0+Yt1S0lZuB9waLVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wLzPWTu/lzqc1c2enHjemO8mERzlZ61QbqhAo6RqLwI=;
 b=LL7Vnowl/OF6MPWWw3ZIyMH+hjdpnS42x6Y1fyF7m4NqAYj3L6k/d7/kM2llk0TUfO/aRth29UgzNrTI0wjmve8pVFooBk/L7r05X+PNGYEs7aUvILep5v7xRCy20ZU1SMSKbcO7871LZEagNyclXOi2F4+dkkMMZm/x9q9GCck=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SA0PR12MB4592.namprd12.prod.outlook.com (2603:10b6:806:9b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22; Wed, 2 Jun
 2021 14:11:57 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4173.030; Wed, 2 Jun 2021
 14:11:57 +0000
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
Subject: [PATCH Part2 RFC v3 22/37] KVM: SVM: Reclaim the guest pages when SEV-SNP VM terminates
Date:   Wed,  2 Jun 2021 09:10:42 -0500
Message-Id: <20210602141057.27107-23-brijesh.singh@amd.com>
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
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SA0PR11CA0056.namprd11.prod.outlook.com (2603:10b6:806:d0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.20 via Frontend Transport; Wed, 2 Jun 2021 14:11:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e954e55b-3a07-44a9-9c3e-08d925d0616c
X-MS-TrafficTypeDiagnostic: SA0PR12MB4592:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB4592A2DD5DA47F17021A4F67E53D9@SA0PR12MB4592.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: npGq16S65B9X2/+7SXjsE1UxZCMl18Zm1xGQYNjBkZ/j5HHjeH5baz/ix2WEQwdguOVYW4Y3yvMA9K+4o/DLkqxxoJRFfGDfm+g5xBD8l+dZ8Gd5/Ny4kkBiAdKI1QBHQvdRZ30QebflT9AzmXQSeushGS4/aplUerzPH61fDSirNOfTrCPaTGmvCWRPrPLqvNX2w0iHp8fSGXwhffTtpd+M5MWvzNR/S89oY/en8B7Rs4yJ5Occ7iYmf9iQpPORzK8foHQxVGacLO1rWM1c2azB85L64SI41bNDioR25UjD1Szw4TN3YW5EYuMGfA/l1EjAuFK4XNcbmdEApc8GY+ZqugjqKHe0Kyo9Bc9MCdtTBzZZpHn15h/9M0hzCRRWtF6c5t4VUCnxM67KYfD8D+KphYKDdWZS2YFE76W2kaNrul5eMu7hEx6muvyC2oO6rZcwFiOjKRyMZ4I6vvKtihLE0gpk/aNffcmTeaaTX/nG/FfEqY6FP80v75wA2AnuKGki7VsAiNYaiDtDDvm1jKDORpOc/AyCAeGoOhthHgwx1sG0qZCt14QcnGPKaiOMriaUGleddpQPiovFNCAkB326ohubWD8jQMVvObnQ1LMsSJd+TcPm33u7F+GRst1k1qXjEBv0OMskGpLtAnKnzg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(39860400002)(366004)(376002)(956004)(8936002)(8676002)(36756003)(478600001)(54906003)(83380400001)(1076003)(44832011)(2616005)(6666004)(38350700002)(38100700002)(5660300002)(66476007)(66556008)(2906002)(66946007)(4326008)(26005)(86362001)(186003)(7696005)(52116002)(16526019)(6486002)(7416002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?JIxappckPtM37e+a+/PINahscU3GX54Bnyn4Sia4OS68XRXvHCQ8EXOq0kVI?=
 =?us-ascii?Q?Q//vjG7MWO6NYvLcSMY3Ctr4atseJ5JoUnfGCDUm12CphfUsHFFgxMPT1RXH?=
 =?us-ascii?Q?1BvZ+v1utwTmGygtI1Ek99Ru1GZZRYRI8DGUKip5pKeYcH3vwNT0wWU5bY3e?=
 =?us-ascii?Q?pss9a/rj5dReloA+0A2u1MsTSRNvBNSy+O4C8KnCsnICa45lktLrai4zPETC?=
 =?us-ascii?Q?hrsfJdOJGxWuuLS4D6AuO6OLR85Kjv/WW0rX4gBocoqpNc07MyYMynSHIaAk?=
 =?us-ascii?Q?i1Af9BDq5tUlvqZP95E0JsJrsKLq7giUoOz0f0ic4HdgGSTTYTpJ7Mxms+i8?=
 =?us-ascii?Q?prd8Hl8nzdg8tzkTp9m7DgyYpeLQvexXEXjBCyRTDwFkUDH41mvzpNvQVVqP?=
 =?us-ascii?Q?2WAEqL1T69Qt/b64BuzsRTgIh0s6OxQuB/AfRLgIce8oQlbd/6AW3H90zM49?=
 =?us-ascii?Q?7EV3iUjQARZ81MHZQ28GOo4U1BcweNt56eUyP5Hpr5joLecTYq3CjS6gjPGf?=
 =?us-ascii?Q?z2Ok5HBOM4lSFEPtYwWoIL90B+AyKZO4WDM+x9jNnlLoXzOfyIMuuWiaDCwg?=
 =?us-ascii?Q?yWUQRLfD0FvnWc6uHxllWwgOVp75imw0XVBUW2G92woriwd54BSAmukA5ypj?=
 =?us-ascii?Q?bxhmGEVykgU6+WWghxcwRDh87+DyjI6o2+Op+y2HACRACQHZEbDburSwdADH?=
 =?us-ascii?Q?gu4YsUnwEvpDNUtg4hJ8LJDt6C8D82tpEHMOX4yapyWlrT0fdTgE1ghaP080?=
 =?us-ascii?Q?k8Y0od1P3gNGuVmmqYkdZmWd2/u7YyT3au0c2caJq7KrQyTLHLmTqT1KyNlP?=
 =?us-ascii?Q?XlRlF0GR5PN9n470UxVNLqyJulKLhMtAYIYZVn/Gb3nTnOinN9auxni8i+9l?=
 =?us-ascii?Q?Z5nyfHgSlcmSppMVc8Ei2+8qa1AWLAocWSQ6k4tnVuWLri1UvVYPKIDl1/Nu?=
 =?us-ascii?Q?1aI0OjGC69YFN37lVAPa1A5QClhPUCwPZ8bAJkCtuUYum1FGStX3tyjpl/If?=
 =?us-ascii?Q?jEFm+Fb7buN/lPvr5ATiFl3whxQu0cmWa0KIx7O/2hvVpxxCvm06qFPOvInI?=
 =?us-ascii?Q?nXIvL2h8EVp1bslnddjq0+vr0Cj0+Y+TNt+K1C+llXuiyHbOl4wFfPycMCf2?=
 =?us-ascii?Q?kShEq0JWWnahwo9fo152ak9mZUv2wCkPydO+MaN3Mq9FC1DcFwmqAUYI7/Vn?=
 =?us-ascii?Q?iaDjvMuvGJa8rFIu5KiLDP6Nj+oAvkfRd/9Vuxiqo3T9AzfngKVpsjomTwcp?=
 =?us-ascii?Q?MyKTWGhbmQ+Q7x0KPeFkWjzAGqhnwH2YyESnD2iMKC2eX03A54pV2/GZjJQe?=
 =?us-ascii?Q?ypLaTYnDpg916no4OYTcpTrm?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e954e55b-3a07-44a9-9c3e-08d925d0616c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 14:11:57.0267
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XKjIPjHm9+ORAb0b1gchE0jziKzDutohu6+f7LfVjs7HCC9E4IW2VB77Ki4kFfcQgldvO51InrPfH/Hj6Rpiug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4592
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The guest pages of the SEV-SNP VM maybe added as a private page in the
RMP entry (assigned bit is set). The guest private pages must be
transitioned to the hypervisor state before its freed.

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/svm/sev.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index dc9343ecca14..6b7c8287eada 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1918,6 +1918,45 @@ find_enc_region(struct kvm *kvm, struct kvm_enc_region *range)
 static void __unregister_enc_region_locked(struct kvm *kvm,
 					   struct enc_region *region)
 {
+	struct rmpupdate val = {};
+	unsigned long i, pfn;
+	struct rmpentry *e;
+	int level, rc;
+
+	/*
+	 * The guest memory pages are assigned in the RMP table. Unassign it
+	 * before releasing the memory.
+	 */
+	if (sev_snp_guest(kvm)) {
+		for (i = 0; i < region->npages; i++) {
+			pfn = page_to_pfn(region->pages[i]);
+
+			if (need_resched())
+				schedule();
+
+			e = snp_lookup_page_in_rmptable(region->pages[i], &level);
+			if (unlikely(!e))
+				continue;
+
+			/* If its not a guest assigned page then skip it. */
+			if (!rmpentry_assigned(e))
+				continue;
+
+			/* Is the page part of a 2MB RMP entry? */
+			if (level == PG_LEVEL_2M) {
+				val.pagesize = RMP_PG_SIZE_2M;
+				pfn &= ~(KVM_PAGES_PER_HPAGE(PG_LEVEL_2M) - 1);
+			} else {
+				val.pagesize = RMP_PG_SIZE_4K;
+			}
+
+			/* Transition the page to hypervisor owned. */
+			rc = rmpupdate(pfn_to_page(pfn), &val);
+			if (rc)
+				pr_err("Failed to release pfn 0x%lx ret=%d\n", pfn, rc);
+		}
+	}
+
 	sev_unpin_memory(kvm, region->pages, region->npages);
 	list_del(&region->list);
 	kfree(region);
-- 
2.17.1

