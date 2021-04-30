Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 320B036FAC9
	for <lists+kvm@lfdr.de>; Fri, 30 Apr 2021 14:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233437AbhD3Mob (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Apr 2021 08:44:31 -0400
Received: from mail-bn8nam12on2062.outbound.protection.outlook.com ([40.107.237.62]:59489
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232564AbhD3MnK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Apr 2021 08:43:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Baf3S7CS3IAW/StD5VsnUUT2O+Qfi5CRu07SLfkpZ6k4cPYsToAEi2xRUNcyGIDQZWGLtxmEFI4bqj1ixcuvHPBvhpva30EXMLP5NKPZzG4hrpskvOnxwhDsrr6JdLzUzUWsSLCacvCA4yw9IphssbOyfPB3sogSKrxu0c+xPHWDl4YCiL/qi2oRdRI2o9PNF9JKGlcNjuSX+pjc/9kpECtaKkS1iu4eBlei85BBSgIrw110iDfdhKkEtTXqy7WyApJgKmINfvwsguMKf4grcExdCZ+Ry5l1LadjbpxeHEDwMDsXqK6Agtwg+jltEHVsNYYmWM5JZhRLBI0thiKNrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OhJaM/GEz7s6ckHdSpaLerRzElrAVnFK5Y17gIMAoCY=;
 b=X3lliPbp3a0ov1gdWf5jdmD9sTywTjV+n38AePYnPxGQVi/RQjPS1uDa1cokhVbjFbEhhJFAr/hHlt7IPQZ/hQzGfr9LtjYpJQNuTtrkdh0ye33j5EeYvmsobua1bup9y9xAlEcD8mOBB+Vh666Ma6OlrCF8jCefzh8557P660K65qDMYLqTg67rRuVl3iGqR1oYFBSQWsQ0147CeRufFXhlHk5Lzg/rxPDGORWq05d0HPuR2XmxEtIyY0aZFwhR3pIuC1uYEnAKjPR73UNtrRr5Njra0jRkOlpzO3hox/Eg+daHNxG7iF+AFY06qPQkA6lxPispY/vPW7N43bFfEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OhJaM/GEz7s6ckHdSpaLerRzElrAVnFK5Y17gIMAoCY=;
 b=IDTaE4zTkILwGeiOdbMnu6Cnmex4tqYSx2zLJXe0cC5shLZmgVMXdjh5wmX3E018+egcDiGyWBZbdZpbQuH5Xu313RW7VghI0zqZlzIg0Qr2BFXM6vEFDILwR3xtXd/XnlK516qZ1B8Zhybw08Dudy/EcE+oFDfJIupgtG5seVs=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2718.namprd12.prod.outlook.com (2603:10b6:805:6f::22)
 by SN6PR12MB2832.namprd12.prod.outlook.com (2603:10b6:805:eb::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.24; Fri, 30 Apr
 2021 12:39:11 +0000
Received: from SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94]) by SN6PR12MB2718.namprd12.prod.outlook.com
 ([fe80::9898:5b48:a062:db94%6]) with mapi id 15.20.4065.027; Fri, 30 Apr 2021
 12:39:11 +0000
From:   Brijesh Singh <brijesh.singh@amd.com>
To:     x86@kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     tglx@linutronix.de, bp@alien8.de, jroedel@suse.de,
        thomas.lendacky@amd.com, pbonzini@redhat.com, mingo@redhat.com,
        dave.hansen@intel.com, rientjes@google.com, seanjc@google.com,
        peterz@infradead.org, hpa@zytor.com, tony.luck@intel.com,
        Brijesh Singh <brijesh.singh@amd.com>
Subject: [PATCH Part2 RFC v2 24/37] KVM: SVM: Reclaim the guest pages when SEV-SNP VM terminates
Date:   Fri, 30 Apr 2021 07:38:09 -0500
Message-Id: <20210430123822.13825-25-brijesh.singh@amd.com>
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
Received: from sbrijesh-desktop.amd.com (165.204.77.1) by SN4PR0501CA0089.namprd05.prod.outlook.com (2603:10b6:803:22::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.8 via Frontend Transport; Fri, 30 Apr 2021 12:39:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ccd6fb5-7afa-4d9a-28c7-08d90bd4f479
X-MS-TrafficTypeDiagnostic: SN6PR12MB2832:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB2832D270829177CA976B8CC4E55E9@SN6PR12MB2832.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9jy366vrO3EHvgbehwE2Xid269BaTwmRSldC2lYr86oLzVarpCyQPvoxo8428YmtFfVzApWeFPFTHH2hZUe5LjJ5HytojWz8H2QolXc7UNhVJbyCCPMhlDPwiXjJFSIAI19JyNuKTuPVTNepIQ8FvUay8+1wweXIsVqlJG8BkkEvvd5LmdDXDgy0F7OsB9Om/Ut/BseUWu4+Yg4nxwRsJ9ZwE2BgNxMrJeDTjd8n9MLqwiwf5F+5pZ8WSpB3BdSyxcBEgACtyvam3KotCCcsGhQ98bxJUxMnnVh8+BlZqIEKYhk+9M4jwBPZRLv4yG7W9MBjIHLM19O0Ui/eRnO47y7tKzKqGFJCAtoRy9C3QgiS62lMc7zUdqUfkr9hynKIS5KT1dvcYk8VdJOj3j5cmccT7hls3WxX6FAzo8vShSBohoNJ9fF29xMXCVsfF++88KigbPvOUco4aSti/huVfPCVIR0Hv84LBZJv5eZaSf8tAHStOLN7Hg3sDORGGMps4M3i4n13Dzy9wXP70LyM7gaCDyCFVronK+BrGXOHCg5jNpfJ+7pOvkhU9nFpikCEjYukBa6qqWbgKPEB3NN6bVoqQPyg+AER+F9cv302H/YvFyWQPLqrn9/AaohEScuXh80wg1nHQhO7XetTGXgpLA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2718.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(396003)(136003)(376002)(346002)(66556008)(956004)(7696005)(66476007)(2906002)(7416002)(66946007)(1076003)(52116002)(38100700002)(186003)(16526019)(4326008)(2616005)(6486002)(5660300002)(44832011)(8676002)(26005)(316002)(8936002)(36756003)(478600001)(83380400001)(86362001)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?O+rijlrRp5EzsANXAilamwWgzwJMqwv540cCck/V5DptxycDzvvD/kN7cSYg?=
 =?us-ascii?Q?FVR36l2t9nQHNhDkbNRZwVY9eWr1VoyfqPuHHewRK6SvBWpYcKJ/zEOUNz6n?=
 =?us-ascii?Q?IlVrCtK6QGdtVOyqW9I46eNuCxIiKuvSuGYCtilfz6r1RqrNJHpv+yujJ5nE?=
 =?us-ascii?Q?D5lJPIVZ6vJPCY5BRfs4feVpR34/yuUt6mBbWwfjWHlbu+ilapgCK9Y5rqWI?=
 =?us-ascii?Q?UphNaj8m70pP9aLid16TySowmfBjSjMxi5w5kV0I7kUYx0tom3YmICDrnS+S?=
 =?us-ascii?Q?UPD1KrdhalAle1TS6K6Cu5+HPHaAet4q3ZLlDzB2ngUr+k675OHyGxM8q/Yr?=
 =?us-ascii?Q?OSqP35j0zKsur13BkhRuxnvWsEnVYOWboIsxEhNWX9nntpnnaawmOAxmGR24?=
 =?us-ascii?Q?zvFAl16HTd6JxcHTrTa2Y5BuTEk+ANXdac2N8UDZ2iyHSFpyMTs4F2zjEaCA?=
 =?us-ascii?Q?6hTTY//r3IL5DejEvsKabY9dj29blKwUGirGc0Yo7BtTlKkrJRKi0a+N2mi4?=
 =?us-ascii?Q?V14Bdg9yya//8PbibKH9ohfS9J3hohDFPjsoGNhI43CQEQFJjdb5tGKFElEH?=
 =?us-ascii?Q?fjrhD2qpTL0ADnO1zFQ8WkIkkb3mT/6XUoc08i/g/LyOxm/RwVsX7gNLLYjc?=
 =?us-ascii?Q?CLMPVGzX3qnBl1+67C8QvXT35vqufmBwuwq+qPGwCqcQW4yAgBEm8K4aSsEC?=
 =?us-ascii?Q?XlXyyrfdir4yE9xlrBCqV3eXA8wkZHGe7S1YP0x1ILhO/fkfk7H2OdSa8nyP?=
 =?us-ascii?Q?7C8Ewigp2js52OerU3kBrzT8VCs2+UsbYrphyps4G5X20xbTC8zB2pENy4sr?=
 =?us-ascii?Q?H7QS+myht9cVomKBwl5jmIdDfnxWJGC3zmZ1swQ2jCVSQn+IMBVXchjiG8Pw?=
 =?us-ascii?Q?0RjBr16VFuCYnNagtSDXkDDviCIJlQknWl21IyKp9mkeDPhP7TO6HXF6TdNb?=
 =?us-ascii?Q?jMSPditzvTQCoa/wQRh7j9W7W55TAKKaGeCGx/n0dSouWB3XZ8tUp6JMMTrZ?=
 =?us-ascii?Q?5l5sBNalWJDXWvztVDh67gtoakgI0g7AIXE0QBBj+K3ef+QBWgzQCC+hr4mO?=
 =?us-ascii?Q?3G14LEGR/CdaSIYIEMLPAJFEo4E9LLpwYCpKMhgnV9iYeawWFR2T/BpflJ7Y?=
 =?us-ascii?Q?mJMq5w86MPfMM2NGkKYjyucfhIozr3kZyL7ScocOTv37pCk+tZoPvE8hGwuF?=
 =?us-ascii?Q?TsXtg8WzZDi6KCF2iok6zpqoYZSd/eb6NDlVMn68lUPX1oNUzJvBX+pn+28G?=
 =?us-ascii?Q?kozWGMFcBenXdZSMuCoDodlkCVfYCbs6E9S4dol8YfA2r5Ax04aCBQssiA8U?=
 =?us-ascii?Q?Fp8ZmRPlyTYbjBUyd9yeQkHv?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ccd6fb5-7afa-4d9a-28c7-08d90bd4f479
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2718.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2021 12:39:11.3598
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: glGq7LFJ7jyRG/3t4yHpomwtvMPnKt1AGRz4KEf0895/0kIhCOVl5FUroL7EFhu0Bq4bcScAToWpayDVUGNSkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2832
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
index d97f37df1f3b..4ce91c2583a3 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1920,6 +1920,45 @@ find_enc_region(struct kvm *kvm, struct kvm_enc_region *range)
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

