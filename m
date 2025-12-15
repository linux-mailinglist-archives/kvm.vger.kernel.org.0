Return-Path: <kvm+bounces-65974-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C9E11CBEB4A
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 16:41:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 897483062E0E
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 15:35:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AD2E1DEFE9;
	Mon, 15 Dec 2025 15:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CFheW4io"
X-Original-To: kvm@vger.kernel.org
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011030.outbound.protection.outlook.com [40.93.194.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9974F26E165;
	Mon, 15 Dec 2025 15:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.194.30
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765812922; cv=fail; b=bCXVliRt/Da/k6bn6SyS2evK7Pfml86JH305tvfl2MfYYtfvISrG692LTfyR6iDeLjn0hZfT0NVfPN2oM5Cz0ewHO7SqvqdVnWmC5V++fsZbTtSBOhq/Pqgz4wN7jmiTjHmWgcR3xlAjrG2qLajWUEH4bLa8nUsdVPdzapygmME=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765812922; c=relaxed/simple;
	bh=cdf6fiVA/WJ6VI+jAJj0YQK0hhOjiwQS4Fki5fO9eJg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l/rENoinEKHytDdh2o/jnrPBoNX+9jX5AJdJj8L/G/xTiqh2DmS9QrVb4hUb7iBRRSy4Z4WM1GBKK+0p9Whkn2YvL3W+jaOg3rSnqbAl8pABxeFuuCWuOmxmGV/f3FehytFE9D+gtT2nT+N+aY+4qaLvm+8YS1CBDJrk9BY+axc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CFheW4io; arc=fail smtp.client-ip=40.93.194.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=madruixNI5l3IhfTVB7UmtTM045llDpB88aKv/AKC0oKkriiq0ml9EkWwhd081CjOf1VeURl00Evq0jWNOD8w9Do6rtMsEcEEktFqhR9567RoUNlNSB0Bmn3XXP7lg/H94j3IQ3uQyWkynHyOYjviy+dOjjuqUPjxSt60H8Kf55JtdHan2bOggSuLUlw7oukR6trTcdZD4XH/iegNus533DMg2sq26/U1B3OVa8GZYR1+Hnt+CN3FNNj3ObwEEpu+XBMqPaJMb2IFijEQOHjtftpZbJlf8aqQv4xXY2HrDAE/HlYWVy3OogS8QoSJkb4xZ2ksCnlCoHdHv++d0trTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=irE7wyRhluCK4Q3bMcDJ9eOSRgB9ZJVE+aH6Oo1N/l8=;
 b=PYErLA866GqHmATjLpivx5tZBG7aPHhk0wjZ50cNujPkGMoaU72pEZ3uxziQmyBr5tNevQWCV9TgN7gGF+5MwVErKaPl7iAd8vLp9L+ux3sdMUkG+LYyoXTpFRHwSB27+eAaSvPQNP9l1DtEQPnIB8QkI3Qi8khLSqKRhSdrBNU45NsCuotIYL/iAIqvmpDbbBZMY+TwN7TT2tOp9uLgRIj50J7Z0YuiQAx2W12wN+qWx9h/DZoRQIr+3uteukJln7gTZ3QSUgr8/7qNSTF5wTC/3ccuBlFe5CYS+fasMXE3fo8Pn8MGtxuqFfNSAT8vAFpkxNcRwh+W0cNcvRal7w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=irE7wyRhluCK4Q3bMcDJ9eOSRgB9ZJVE+aH6Oo1N/l8=;
 b=CFheW4ioqr2om0N9GPoHg2iBEEY/nhisk8Bn5Q7r7ph01uxfq0A8VG0hZn2HSVd72djPmVkJr37YRkwMCaddPYk2bi3UXwm44DFm6ppOFoz2iPlW5lZlqLbkJAD/J/sjSfBlgVUBWxcDwwzHtLVQr91QRTu6S5ovn8JYrdGWDrg=
Received: from SN7PR04CA0212.namprd04.prod.outlook.com (2603:10b6:806:127::7)
 by DS7PR12MB6046.namprd12.prod.outlook.com (2603:10b6:8:85::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.12; Mon, 15 Dec
 2025 15:35:00 +0000
Received: from SN1PEPF0002529F.namprd05.prod.outlook.com
 (2603:10b6:806:127:cafe::ac) by SN7PR04CA0212.outlook.office365.com
 (2603:10b6:806:127::7) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.13 via Frontend Transport; Mon,
 15 Dec 2025 15:34:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF0002529F.mail.protection.outlook.com (10.167.242.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Mon, 15 Dec 2025 15:34:59 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 15 Dec
 2025 09:34:58 -0600
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <aik@amd.com>,
	<ira.weiny@intel.com>, <yan.y.zhao@intel.com>
Subject: [PATCH v2 1/5] KVM: guest_memfd: Remove partial hugepage handling from kvm_gmem_populate()
Date: Mon, 15 Dec 2025 09:34:07 -0600
Message-ID: <20251215153411.3613928-2-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20251215153411.3613928-1-michael.roth@amd.com>
References: <20251215153411.3613928-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002529F:EE_|DS7PR12MB6046:EE_
X-MS-Office365-Filtering-Correlation-Id: 67216313-5ca5-422a-5788-08de3bef81fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Hz/c4+EiAzw36EVYuahFuHYzcov8vPY+3kkhzw+qVEjk5uD0MYHONsrug7HT?=
 =?us-ascii?Q?4EvkAFp6WR0CZ9DsLNcrBT87ldY9rAzFgdXM3w57YErJnbJcm2g8k35b7esv?=
 =?us-ascii?Q?iFLf9XuBsohMEE6VafgcfuK/UYSwZYJyXnhdeA2g/U6hXmlbWgqg1tV5LeHk?=
 =?us-ascii?Q?QEUzkCn2GOeFzYsmd5twlu/3bL5JST5tScYXmf4Ht3Kmj/WXxTLYw/OURSZm?=
 =?us-ascii?Q?o1eWZJVqknrz2Jar9orHv4PGKUY7du3u6bfR+O1vy7EvRJ+UKUeglko4FC1y?=
 =?us-ascii?Q?BpKEO2WvKq3oEqeKUCjvefo9OuKCYGFWgnSyFICmQ4rk+MTUzVAWyKq1WZCE?=
 =?us-ascii?Q?Xhl4hXF0FxFtoN3q2M5DQ1BIaxRG8V2IIeSmP2GK9WfnmyvVTi6BuD/EPfGn?=
 =?us-ascii?Q?XJH8fWgH9kksWkjOC+CDbJ2IOg8lxIJpWHFlfmlrc80NIY+0+nd80QASK/yt?=
 =?us-ascii?Q?VIQasYUKAE1GaDY2uGqvNnThDXmnVT9SBGCLei12PEcX4Ks2m1nCmWQMz1t0?=
 =?us-ascii?Q?MHFqrpNdGPCOyzXvA0AwHrKHEIE5+cf/m2N+etChu0rt7R9RUAmrVnN2V4Ju?=
 =?us-ascii?Q?5D2kn6S7rmXwlehXVVC7y5Tik1Uqcr1wk3tblFEO54dWNNR98yXX62LZdG/i?=
 =?us-ascii?Q?6BcDgKSJp3JaycaeWVAcCvHlktsJwT4gwaEUQVLsrdeFt1s9IyvYm0kIGNRx?=
 =?us-ascii?Q?AZfmQ2p7ZEsh0ufixdfIjxjpS2P4A43ufrKom9eDAQPIQV4c5UXWhTm16zq0?=
 =?us-ascii?Q?0F7YXNyDxhl/c+w2MIOARQZfAJOa3eylDmQ6bwG+DYreiCLjlnZ5/rJDIsOE?=
 =?us-ascii?Q?YtH3he5+UAaOgKVFS9jKbvwAFUnsp7smFIExp/Dx4JaP2lfgZa036m/L8wMy?=
 =?us-ascii?Q?1BU0YoBzoXGRAqlR5EYvjnyrC7VLgl3jlAGjjcQ5Z9nwov5JPaXx6/6nwqnp?=
 =?us-ascii?Q?vrlqx76VFKdC/mH4uSEVNr0anHCDmWEVGX+5hVnIQ1jxwQh6sTyZfKQKTXVM?=
 =?us-ascii?Q?JRMiuDHx1keAlwpOkaYj3QOba9ZdXz0Fdhph+96g5IaHduG/MkPe2OtpttcP?=
 =?us-ascii?Q?ZXkaTCrhv9vx15HFsZHHACxbRP1N6lpKdkcZ3A6Zt4vUugDFoXCz+G2hpj6L?=
 =?us-ascii?Q?uEy2Eyz0S1sBMn1e8XiRL0sn8/f40TymSSocuUJPQZ6rygGqj0ZWtKFpPfqf?=
 =?us-ascii?Q?elinlCCIp3v+M+F9dom51oRMF+tR7O+GaSQ/xLU/dpFv9xiJpp9SWYudaY/D?=
 =?us-ascii?Q?NLYTIY6YG8z/LbjSEhqrjNmF9lxO+lYAlitYnE8TDGaL9nBKUc9UwvAqM5aD?=
 =?us-ascii?Q?6icahDLDjoAkzhumtaT7raJnMjoYx2a9V2qop44DBBcIG/YxBFZdLbRTUIbQ?=
 =?us-ascii?Q?guE3jw5IrlwmkU7o4w/jR7KoKRcqb7dQsTprJ+SDCmnJdqtiDS3aI70LjCvm?=
 =?us-ascii?Q?TJLiLZiq8OahaRJbgYuOoMgv4uxacgtX6/Duz+Qy5ta1wrY97FtBX5vJFN7G?=
 =?us-ascii?Q?Nr9Xwygwo6s2Hm0bXE4XvqOv9pt0A+bB/JdyeOkJ6YOozpVcHNzzF3TzVPWS?=
 =?us-ascii?Q?nbCC60anLP7ZBY5LKH4=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2025 15:34:59.6499
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 67216313-5ca5-422a-5788-08de3bef81fb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002529F.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6046

kvm_gmem_populate(), and the associated post-populate callbacks, have
some limited support for dealing with guests backed by hugepages by
passing the order information along to each post-populate callback and
iterating through the pages passed to kvm_gmem_populate() in
hugepage-chunks.

However, guest_memfd doesn't yet support hugepages, and in most cases
additional changes in the kvm_gmem_populate() path would also be needed
to actually allow for this functionality.

This makes the existing code unecessarily complex, and makes changes
difficult to work through upstream due to theoretical impacts on
hugepage support that can't be considered properly without an actual
hugepage implementation to reference. So for now, remove what's there
so changes for things like in-place conversion can be
implemented/reviewed more efficiently.

Suggested-by: Vishal Annapurve <vannapurve@google.com>
Co-developed-by: Vishal Annapurve <vannapurve@google.com>
Signed-off-by: Vishal Annapurve <vannapurve@google.com>
Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 arch/x86/kvm/svm/sev.c   | 94 ++++++++++++++++------------------------
 arch/x86/kvm/vmx/tdx.c   |  2 +-
 include/linux/kvm_host.h |  2 +-
 virt/kvm/guest_memfd.c   | 30 +++++++------
 4 files changed, 56 insertions(+), 72 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index f59c65abe3cf..362c6135401a 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2267,66 +2267,52 @@ struct sev_gmem_populate_args {
 	int fw_error;
 };
 
-static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pfn,
-				  void __user *src, int order, void *opaque)
+static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
+				  void __user *src, void *opaque)
 {
 	struct sev_gmem_populate_args *sev_populate_args = opaque;
+	struct sev_data_snp_launch_update fw_args = {0};
 	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
-	int n_private = 0, ret, i;
-	int npages = (1 << order);
-	gfn_t gfn;
+	bool assigned = false;
+	int level;
+	int ret;
 
 	if (WARN_ON_ONCE(sev_populate_args->type != KVM_SEV_SNP_PAGE_TYPE_ZERO && !src))
 		return -EINVAL;
 
-	for (gfn = gfn_start, i = 0; gfn < gfn_start + npages; gfn++, i++) {
-		struct sev_data_snp_launch_update fw_args = {0};
-		bool assigned = false;
-		int level;
-
-		ret = snp_lookup_rmpentry((u64)pfn + i, &assigned, &level);
-		if (ret || assigned) {
-			pr_debug("%s: Failed to ensure GFN 0x%llx RMP entry is initial shared state, ret: %d assigned: %d\n",
-				 __func__, gfn, ret, assigned);
-			ret = ret ? -EINVAL : -EEXIST;
-			goto err;
-		}
+	ret = snp_lookup_rmpentry((u64)pfn, &assigned, &level);
+	if (ret || assigned) {
+		pr_debug("%s: Failed to ensure GFN 0x%llx RMP entry is initial shared state, ret: %d assigned: %d\n",
+			 __func__, gfn, ret, assigned);
+		ret = ret ? -EINVAL : -EEXIST;
+		goto out;
+	}
 
-		if (src) {
-			void *vaddr = kmap_local_pfn(pfn + i);
+	if (src) {
+		void *vaddr = kmap_local_pfn(pfn);
 
-			if (copy_from_user(vaddr, src + i * PAGE_SIZE, PAGE_SIZE)) {
-				ret = -EFAULT;
-				goto err;
-			}
-			kunmap_local(vaddr);
+		if (copy_from_user(vaddr, src, PAGE_SIZE)) {
+			ret = -EFAULT;
+			goto out;
 		}
-
-		ret = rmp_make_private(pfn + i, gfn << PAGE_SHIFT, PG_LEVEL_4K,
-				       sev_get_asid(kvm), true);
-		if (ret)
-			goto err;
-
-		n_private++;
-
-		fw_args.gctx_paddr = __psp_pa(sev->snp_context);
-		fw_args.address = __sme_set(pfn_to_hpa(pfn + i));
-		fw_args.page_size = PG_LEVEL_TO_RMP(PG_LEVEL_4K);
-		fw_args.page_type = sev_populate_args->type;
-
-		ret = __sev_issue_cmd(sev_populate_args->sev_fd, SEV_CMD_SNP_LAUNCH_UPDATE,
-				      &fw_args, &sev_populate_args->fw_error);
-		if (ret)
-			goto fw_err;
+		kunmap_local(vaddr);
 	}
 
-	return 0;
+	ret = rmp_make_private(pfn, gfn << PAGE_SHIFT, PG_LEVEL_4K,
+			       sev_get_asid(kvm), true);
+	if (ret)
+		goto out;
+
+	fw_args.gctx_paddr = __psp_pa(sev->snp_context);
+	fw_args.address = __sme_set(pfn_to_hpa(pfn));
+	fw_args.page_size = PG_LEVEL_TO_RMP(PG_LEVEL_4K);
+	fw_args.page_type = sev_populate_args->type;
 
-fw_err:
+	ret = __sev_issue_cmd(sev_populate_args->sev_fd, SEV_CMD_SNP_LAUNCH_UPDATE,
+			      &fw_args, &sev_populate_args->fw_error);
 	/*
 	 * If the firmware command failed handle the reclaim and cleanup of that
-	 * PFN specially vs. prior pages which can be cleaned up below without
-	 * needing to reclaim in advance.
+	 * PFN before reporting an error.
 	 *
 	 * Additionally, when invalid CPUID function entries are detected,
 	 * firmware writes the expected values into the page and leaves it
@@ -2336,26 +2322,20 @@ static int sev_gmem_post_populate(struct kvm *kvm, gfn_t gfn_start, kvm_pfn_t pf
 	 * information to provide information on which CPUID leaves/fields
 	 * failed CPUID validation.
 	 */
-	if (!snp_page_reclaim(kvm, pfn + i) &&
+	if (ret && !snp_page_reclaim(kvm, pfn) &&
 	    sev_populate_args->type == KVM_SEV_SNP_PAGE_TYPE_CPUID &&
 	    sev_populate_args->fw_error == SEV_RET_INVALID_PARAM) {
-		void *vaddr = kmap_local_pfn(pfn + i);
+		void *vaddr = kmap_local_pfn(pfn);
 
-		if (copy_to_user(src + i * PAGE_SIZE, vaddr, PAGE_SIZE))
+		if (copy_to_user(src, vaddr, PAGE_SIZE))
 			pr_debug("Failed to write CPUID page back to userspace\n");
 
 		kunmap_local(vaddr);
 	}
 
-	/* pfn + i is hypervisor-owned now, so skip below cleanup for it. */
-	n_private--;
-
-err:
-	pr_debug("%s: exiting with error ret %d (fw_error %d), restoring %d gmem PFNs to shared.\n",
-		 __func__, ret, sev_populate_args->fw_error, n_private);
-	for (i = 0; i < n_private; i++)
-		kvm_rmp_make_shared(kvm, pfn + i, PG_LEVEL_4K);
-
+out:
+	pr_debug("%s: exiting with return code %d (fw_error %d)\n",
+		 __func__, ret, sev_populate_args->fw_error);
 	return ret;
 }
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 2d7a4d52ccfb..4fb042ce8ed1 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3118,7 +3118,7 @@ struct tdx_gmem_post_populate_arg {
 };
 
 static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
-				  void __user *src, int order, void *_arg)
+				  void __user *src, void *_arg)
 {
 	struct tdx_gmem_post_populate_arg *arg = _arg;
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index d93f75b05ae2..1d0cee72e560 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -2581,7 +2581,7 @@ int kvm_arch_gmem_prepare(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn, int max_ord
  * Returns the number of pages that were populated.
  */
 typedef int (*kvm_gmem_populate_cb)(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
-				    void __user *src, int order, void *opaque);
+				    void __user *src, void *opaque);
 
 long kvm_gmem_populate(struct kvm *kvm, gfn_t gfn, void __user *src, long npages,
 		       kvm_gmem_populate_cb post_populate, void *opaque);
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index fdaea3422c30..9dafa44838fe 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -151,6 +151,15 @@ static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
 					 mapping_gfp_mask(inode->i_mapping), policy);
 	mpol_cond_put(policy);
 
+	/*
+	 * External interfaces like kvm_gmem_get_pfn() support dealing
+	 * with hugepages to a degree, but internally, guest_memfd currently
+	 * assumes that all folios are order-0 and handling would need
+	 * to be updated for anything otherwise (e.g. page-clearing
+	 * operations).
+	 */
+	WARN_ON_ONCE(folio_order(folio));
+
 	return folio;
 }
 
@@ -829,7 +838,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 	struct kvm_memory_slot *slot;
 	void __user *p;
 
-	int ret = 0, max_order;
+	int ret = 0;
 	long i;
 
 	lockdep_assert_held(&kvm->slots_lock);
@@ -848,7 +857,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 	filemap_invalidate_lock(file->f_mapping);
 
 	npages = min_t(ulong, slot->npages - (start_gfn - slot->base_gfn), npages);
-	for (i = 0; i < npages; i += (1 << max_order)) {
+	for (i = 0; i < npages; i++) {
 		struct folio *folio;
 		gfn_t gfn = start_gfn + i;
 		pgoff_t index = kvm_gmem_get_index(slot, gfn);
@@ -860,7 +869,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 			break;
 		}
 
-		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &is_prepared, &max_order);
+		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &is_prepared, NULL);
 		if (IS_ERR(folio)) {
 			ret = PTR_ERR(folio);
 			break;
@@ -874,20 +883,15 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 		}
 
 		folio_unlock(folio);
-		WARN_ON(!IS_ALIGNED(gfn, 1 << max_order) ||
-			(npages - i) < (1 << max_order));
 
 		ret = -EINVAL;
-		while (!kvm_range_has_memory_attributes(kvm, gfn, gfn + (1 << max_order),
-							KVM_MEMORY_ATTRIBUTE_PRIVATE,
-							KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
-			if (!max_order)
-				goto put_folio_and_exit;
-			max_order--;
-		}
+		if (!kvm_range_has_memory_attributes(kvm, gfn, gfn + 1,
+						     KVM_MEMORY_ATTRIBUTE_PRIVATE,
+						     KVM_MEMORY_ATTRIBUTE_PRIVATE))
+			goto put_folio_and_exit;
 
 		p = src ? src + i * PAGE_SIZE : NULL;
-		ret = post_populate(kvm, gfn, pfn, p, max_order, opaque);
+		ret = post_populate(kvm, gfn, pfn, p, opaque);
 		if (!ret)
 			kvm_gmem_mark_prepared(folio);
 
-- 
2.25.1


