Return-Path: <kvm+bounces-65976-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AF9B7CBEB05
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 16:36:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 26ED13000B3A
	for <lists+kvm@lfdr.de>; Mon, 15 Dec 2025 15:36:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C4503314BF;
	Mon, 15 Dec 2025 15:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="i2qMjrwv"
X-Original-To: kvm@vger.kernel.org
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013065.outbound.protection.outlook.com [40.93.196.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ABA432F74A;
	Mon, 15 Dec 2025 15:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.196.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765812953; cv=fail; b=NpTY+EQlp1ceEa+9zoByaLvaNzAA0qAuiHmWSXqHXdZpjrlZ/KMcSoDtQwLmPwMlnAGz4K6dCXK1qYQI0vkSgBvM18isxSE4BGxUt5UY+hPeTx+lRgNKk1Z3KbbSfPio0lQm94fkq8NMaQgCu5eHbAg9CUwVbbs1kpRJp5LM/Ac=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765812953; c=relaxed/simple;
	bh=w3EVIYE/60pFpOFnUbRacxSzyvKOtxGciEThnaRqeXo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WQxpLOGzPmOdlC/prFE5KiIMHcXRjh8IyerW3KRQi7VZkOjPnK3SpIO152KGrGWn8PnvA3ELIUMOALWzwGIrVWVoZ5WycsRVXbCxDgfn6bGZLD6yd6YA9KGe6KqgjxLqaSrWktuEsIM8/M2nqhndpJyZQ8TeULzKyLhhg/7a7pM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=i2qMjrwv; arc=fail smtp.client-ip=40.93.196.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MXOHhpybV2ehEGXTBk9Imru5INes1Nkk3zARz0Gs32AZPKvS31UxtwO99ATn4b7vNmQCb6ED2reg7vDwzRe0r4MJmmGq6P3Uf6/6td+dQz6+A5BloAaMM+47zEPc1iiNUwZHtn5a0pytLrRvzh8jiRY1vh6XLKs0RZei51UxjrAiU9fPpIaIZDYAB3GFNasYK7J5YGqeKI8ECEgYk45Wy5B/f9HRpAlX3iXCCTEDQvQwJCyp39HFZXILLma3L+fKOuIIKFj3oytGHftFJCZ34eN7YcZLF6b/0+o+YcWPyuVKNpJiTFo16HcvdATh9CQxIJCoih0hldKtpxWYXUK0yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yVgIy/5ze6wpZVJys2iQsyujhyGNdUjsYuP3eHSISbE=;
 b=p3m0FZT0ych/wDkLkJt5y8ZQ+lFNXVHJpJAWxKexlyLLQib0054aDpiT5tfwgJLRU5YHczYXnJc7T20pps0ksbxdVFeVTaFgPRCgRdPlhVp9ItvFv9OYKpIEvJ4YAcbokle+m0od+XaKSNVFt2QbGj6JXNrUHKX1JIiXxOy1QVj/jYNzKNbn+d4NEcdeDiuS5LgVCgg7fYEiykWeWPcLZ0QMGOcJ6UELhqVZooteNl64iTSQoGd6fZ6ECsR2Ozown+PEONMhf3FCI1JBAy+AHM1/oCpNpaXu/BJAjRvGV4NWfxOWQykME7pICHZSy5cxGfN1EgWXUod5h0kz/BmMlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yVgIy/5ze6wpZVJys2iQsyujhyGNdUjsYuP3eHSISbE=;
 b=i2qMjrwvVtKjwuF5/tHz18OoJFEShIDFqp38NUntJ9K2qMWvmQ88iG/3Lsh3rR2v2NSquN8aga0n/TU2vQm2VwKr7xaPGPFIFJBA9t/m9tCdEdleERW5NRQrRUOniRxPhPgriLJaZfxYQr7vM/MEO5R+FllCuLxhpXVZqQkdHtY=
Received: from SA1P222CA0160.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:3c3::6)
 by MN0PR12MB5836.namprd12.prod.outlook.com (2603:10b6:208:37b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.13; Mon, 15 Dec
 2025 15:35:41 +0000
Received: from SN1PEPF000252A3.namprd05.prod.outlook.com
 (2603:10b6:806:3c3:cafe::bd) by SA1P222CA0160.outlook.office365.com
 (2603:10b6:806:3c3::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9412.13 via Frontend Transport; Mon,
 15 Dec 2025 15:35:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF000252A3.mail.protection.outlook.com (10.167.242.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9434.6 via Frontend Transport; Mon, 15 Dec 2025 15:35:40 +0000
Received: from localhost (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Mon, 15 Dec
 2025 09:35:40 -0600
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <aik@amd.com>,
	<ira.weiny@intel.com>, <yan.y.zhao@intel.com>
Subject: [PATCH v2 3/5] KVM: SEV: Document/enforce page-alignment for KVM_SEV_SNP_LAUNCH_UPDATE
Date: Mon, 15 Dec 2025 09:34:09 -0600
Message-ID: <20251215153411.3613928-4-michael.roth@amd.com>
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
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A3:EE_|MN0PR12MB5836:EE_
X-MS-Office365-Filtering-Correlation-Id: 2447d2f2-fedd-4966-d7e6-08de3bef9a89
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NKj5KGt4RWLH1f/rT0S09Km6fy0nGUHv3Fm7o5eyq73A0JyZ+naxgIu0rELb?=
 =?us-ascii?Q?eQtjAqf3Ju690qui/V0LqWqQ7cTtp8twMKa7GnI7I5lL4IdLbQHErZF43Mdq?=
 =?us-ascii?Q?jj5ozRqLBxBKR3r49lIeb2+NIH7fu+lh77Sp5cmJfw6Y5Bp0+EWe8A3RLnMU?=
 =?us-ascii?Q?53VX7zHcXLQmeWNS1vbQ1AjGI/i189YOx7Hwl613EXjbFtNfLzZzpDgtj7Qh?=
 =?us-ascii?Q?arbhcPDzpSQUEkU069eBvqfLnEbnaFc2EZCdBw8fm7WYYQUXgT4h4MydgYS0?=
 =?us-ascii?Q?QfmdGTrpJ4ntZ+8CYUOYqKZ73jv2EbZhefH+Ch0GeIiDVOLTKKkKeD1xitBt?=
 =?us-ascii?Q?T43agul+gWHxqfrKf8PMAXAXnwfCzCHc25TjDycDr1X1Y2/lM9fHCHkHr/OL?=
 =?us-ascii?Q?nrpVY/L9Eo/7bZNo4LmG8f2Oatqjew1FiOO+6YYlkXYDJGYz34Cp19eppBf5?=
 =?us-ascii?Q?N+omFCUIkWAXyvH40xJOIAI71RDVbiOJw+wwDLdb4kGsi2DbAsXN1zK4pZ5R?=
 =?us-ascii?Q?05OJhb4JbFYpwiXJ48zFqmARf2lQ946WB3WP0eqRSv7McKbHNPAls78kCJdE?=
 =?us-ascii?Q?8ThOFkwQGrBfClFuV5Y6krtstEFi0gJ1xG09gDN8J3U+LHDa12th0K7vXopz?=
 =?us-ascii?Q?E8HWJnmV4ovN38sE3vMMVmj2/yoJrHtRn3B6WD2iUIDb2NOEtus3/xyypZ9V?=
 =?us-ascii?Q?cNWOIfmL5h+XVe8XIKmTp0JDcYt5EdfLeMcxV9y2d5MUaHg34QwgHfin1+t6?=
 =?us-ascii?Q?OI0CuuV9xa9PAgtbvZKMrscyp5Y7D+TAfn38yR2816bmZwmNqPxhbwN+RkQu?=
 =?us-ascii?Q?Xh84TCAOGwV1xqGCmPNKTK9DkxcQCup+LYV/v00+QRXnM0UXxNPqW0Raw2wY?=
 =?us-ascii?Q?LUsco0QamKWzLhJ84DFrgxtMpLdyXz6cNfmHetIjhl/7vceqyHpmd8ihqyMu?=
 =?us-ascii?Q?ZxvCiacmAcLHKOdIPmnhJEluObPCa3MGre85lCo1xcJI9vbrFkq50pRILhtN?=
 =?us-ascii?Q?zXc67M9UGkaBIk3QK18Zwe/syiJ59ynZB2GqPl55O6GcSL7SRsCSA5dFUaRn?=
 =?us-ascii?Q?l64ILlcsoOq93564T7o37otm4aHuLWIulotWXJB7hOhiV4pWULLWweptQ4qr?=
 =?us-ascii?Q?aIDwWi11+R1aY6Y9FsAv6gmQ2VlHBJbHYbipMjDHnnQ7ErVknCLWeIkMORwD?=
 =?us-ascii?Q?Rys1UeLTOgM1iyWK3Trn2tKD5zBUUDpq385jxI+xnwkQfmNhNExz6ANxSZ5q?=
 =?us-ascii?Q?65VRkSb/F1ogVKhA2vkBdOrxiNIsoNn+SS/rxIrbN/s3TxQvXcXecVekkwy1?=
 =?us-ascii?Q?v+xsuqrwr4CE3cPFYu1T34n1/VlG2EvbgUUrb1jsfRHv3udVl+LNvn5LuPuP?=
 =?us-ascii?Q?RZSDCZOwqpibMLnIE45ADy0JPbo4IeJaxVp+YWZ+06Lv/SlrlqleVsDCbo65?=
 =?us-ascii?Q?Hn1NPic0F2gJY02Ow8d033CAzZUfitb/kY5O0DcmXwc0ZMy90fbYq1GnM6yw?=
 =?us-ascii?Q?9xEi/yRHG3v7SzrVSPhXBhZVP0YiBosTGbbCDruuvXKAfUGCIho9s+xEoqkf?=
 =?us-ascii?Q?aC/LhWcpX4xIApuCDV0=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2025 15:35:40.8519
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2447d2f2-fedd-4966-d7e6-08de3bef9a89
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000252A3.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5836

In the past, KVM_SEV_SNP_LAUNCH_UPDATE accepted a non-page-aligned
'uaddr' parameter to copy data from, but continuing to support this with
new functionality like in-place conversion and hugepages in the pipeline
has proven to be more trouble than it is worth, since there are no known
users that have been identified who use a non-page-aligned 'uaddr'
parameter.

Rather than locking guest_memfd into continuing to support this, go
ahead and document page-alignment as a requirement and begin enforcing
this in the handling function.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 Documentation/virt/kvm/x86/amd-memory-encryption.rst | 2 +-
 arch/x86/kvm/svm/sev.c                               | 6 +++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
index 1ddb6a86ce7f..5a88d0197cb3 100644
--- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
+++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
@@ -523,7 +523,7 @@ Returns: 0 on success, < 0 on error, -EAGAIN if caller should retry
 
         struct kvm_sev_snp_launch_update {
                 __u64 gfn_start;        /* Guest page number to load/encrypt data into. */
-                __u64 uaddr;            /* Userspace address of data to be loaded/encrypted. */
+                __u64 uaddr;            /* 4k-aligned address of data to be loaded/encrypted. */
                 __u64 len;              /* 4k-aligned length in bytes to copy into guest memory.*/
                 __u8 type;              /* The type of the guest pages being initialized. */
                 __u8 pad0;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 362c6135401a..90c512ca24a9 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2366,6 +2366,11 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	     params.type != KVM_SEV_SNP_PAGE_TYPE_CPUID))
 		return -EINVAL;
 
+	src = params.type == KVM_SEV_SNP_PAGE_TYPE_ZERO ? NULL : u64_to_user_ptr(params.uaddr);
+
+	if (!PAGE_ALIGNED(src))
+		return -EINVAL;
+
 	npages = params.len / PAGE_SIZE;
 
 	/*
@@ -2397,7 +2402,6 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	sev_populate_args.sev_fd = argp->sev_fd;
 	sev_populate_args.type = params.type;
-	src = params.type == KVM_SEV_SNP_PAGE_TYPE_ZERO ? NULL : u64_to_user_ptr(params.uaddr);
 
 	count = kvm_gmem_populate(kvm, params.gfn_start, src, npages,
 				  sev_gmem_post_populate, &sev_populate_args);
-- 
2.25.1


