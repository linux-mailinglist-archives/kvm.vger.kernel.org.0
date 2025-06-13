Return-Path: <kvm+bounces-49348-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F161BAD7FDD
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 02:56:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7D3277AB659
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 00:55:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA46B1CDFD4;
	Fri, 13 Jun 2025 00:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="y6Qkvmhe"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2068.outbound.protection.outlook.com [40.107.100.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E3AE72636;
	Fri, 13 Jun 2025 00:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749776189; cv=fail; b=h2CiX7yw97OziCJbX3cuGMuMFozW7vJi4Vg4NEWSUXhKbE5F/ZeefP5mYFjOAZ5lcUsWewyPhq2TfebJUId0O5THntwOey+MXX0TStM2X60DkSZ2r1wts+rI2PuEAox1TcX+e77cFWo+JbBKAe16gF6Bl4RbRkvbtxUxa86/Iw0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749776189; c=relaxed/simple;
	bh=yCnjxEyrkmIfAisftpW9ZWpOWKsGvp8hfGDglNJ0/GM=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wz1VmzPkIaEpuXzJGkWkzUV18xWm9N3Z+JtjjFfof8Zd7VJjPP7Z9nGghMke/TWq2eT1za8U3eRQg83t7Wlqrd61zJ0LD16ostJdHkBeQ4YCwntF4dDqZrrp/Y3ACpIBbtOFHJYxaf4G7SggNKELEmTV3xPuLzAp1FdeHSaHr4U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=y6Qkvmhe; arc=fail smtp.client-ip=40.107.100.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Daj3+YJw1y1S7AjOB5er1NthWcd7NBoxQ3H+fPbnFYLTmOdt9/p5LJhlODeYWED5M0bX00eIWZ6ADRaIxQ+Y612odgJRpLyCoGRmZ6kFiffZUvE2GUc7jBQehBk2/dcgn59+tVv81doxF3Ac0VdVPkcr7ctZqcW3lSg4d0maPDPAvLaAORWWqbaylQXOtxTba0QEuugNADDTHE3aXWgRPMM7XnTnwteRxneNojTtUp0wGeD8kdcXjgJr4vhQqGTCbPJADsgxMdK8yf/jpZuCVloiOBTJKMagRokm/v2GMUSkgVCQP9sXIbeVj+1jgnVwQ30yUXeOsY3cTYMmiNIlAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E6Hq8j/h5FscqUYS0v64Ey94ASqk8fJpcUbQZM2ox48=;
 b=LJQZ3SZCR/cusE4OJdZG2WIUWVBhCUmT5BsvscL/lp9toq278Jj9E7Q3fo4Uk1ay0+0cBrrvUBAm+Q+TPKVj0TvVTjoFRn9mFkDyn894GU0Yab/EoUbOfPTGxJyhVzQw/IK4bPYV5exkSXLc6/Aj2qzUoiNnLJ1o+PshTMD8fZkqQyNSOnMZu5Mr7INfcJ2TLsZzY8vDstPLJerSnywa4QM9DIVsoVcSsPMH1BLmogGR3CSP8taTcYcS3HZmXEYjEkey5OBW81ow/kwXTKtWXvRBz2ylAV8vaNOtvcsKYDseLHLHxL02rAgw+yuXZpEIJifozXK7T0MpY4jgommpJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E6Hq8j/h5FscqUYS0v64Ey94ASqk8fJpcUbQZM2ox48=;
 b=y6Qkvmhe9TEXpR5IVfDaBV/kRx4Wr7f93PkmLhvG1yChB8GHYSFw5KafEdN4xS2uFPbIDT+xNrbb1k/9GGQim10Ttn+/FUUObVpP1RmcHJKP5bHPx/lChc9y7MJCCtDSD2P+RXmolgP3Bz3rOGsRRCccV/C/OYxq238gXAq6Ris=
Received: from SJ0PR05CA0095.namprd05.prod.outlook.com (2603:10b6:a03:334::10)
 by CH3PR12MB8211.namprd12.prod.outlook.com (2603:10b6:610:125::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.18; Fri, 13 Jun
 2025 00:56:24 +0000
Received: from SJ5PEPF000001F6.namprd05.prod.outlook.com
 (2603:10b6:a03:334:cafe::39) by SJ0PR05CA0095.outlook.office365.com
 (2603:10b6:a03:334::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8835.22 via Frontend Transport; Fri,
 13 Jun 2025 00:56:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001F6.mail.protection.outlook.com (10.167.242.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8835.15 via Frontend Transport; Fri, 13 Jun 2025 00:56:23 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Thu, 12 Jun
 2025 19:56:22 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <david@redhat.com>, <tabba@google.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <ira.weiny@intel.com>,
	<thomas.lendacky@amd.com>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vbabka@suse.cz>, <joro@8bytes.org>, <pratikrajesh.sampat@amd.com>,
	<liam.merwick@oracle.com>, <yan.y.zhao@intel.com>, <aik@amd.com>
Subject: [PATCH RFC v1 3/5] KVM: guest_memfd: Call arch invalidation hooks when converting to shared
Date: Thu, 12 Jun 2025 19:53:58 -0500
Message-ID: <20250613005400.3694904-4-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250613005400.3694904-1-michael.roth@amd.com>
References: <20250613005400.3694904-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001F6:EE_|CH3PR12MB8211:EE_
X-MS-Office365-Filtering-Correlation-Id: f33da593-d4b6-4a4a-c6ca-08ddaa151e57
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lrKgzAJ9XuFmf+4C5SlTWsP5C7DPJ/OIcIfWQxu4plzTb+RoEwjm/A7rI6iS?=
 =?us-ascii?Q?zTvgNoq4xVEQQ9Qi0r+zHP0C5KoMGQzhWsBINAwLUoGAT6+Sg7mUpuCpgc6h?=
 =?us-ascii?Q?7FqFXLIIFASHQG1q8Pvy3w0JR+P9SqjF3azqNcGXQNOLUXGJN5yvfooiwaz9?=
 =?us-ascii?Q?ZSTcDlCOUcdsLS/kDkXsmwyt4wQUc4NVjCvuFJYssushh0WeKqlzlbw7QMZl?=
 =?us-ascii?Q?pt2YyCQzDfEmQNCUXMcjcv3Rvnkvrx5Gh95RlfO159qZM9jbtLHuOcdNTHRP?=
 =?us-ascii?Q?LO5Xg/+8Ylg8zEMe+iBABVqW0Pcs5CcwvBaQR9aLul4ZbbWrJ/Qr8l5sQTrY?=
 =?us-ascii?Q?40CJ1isggzrMRVyBIbawLkyh5dTyQwCluK1N4WUmvwh/OZJ0AHGWxWjwQmwY?=
 =?us-ascii?Q?jBYMKMPU/k8KtEZmrkJ+wHUDy2F0AIzWc6t1Y4f70OY0queiTsLk/Zjapxrq?=
 =?us-ascii?Q?bb/luxJe005g0C7M0g8z3RV7LIhH7x75kxjZ0Z1aJ727dpcabVkKlWjRCoa1?=
 =?us-ascii?Q?pkaIOSA/CE1MdMouq9Z3Mk03kRcdurWFIpGTcYOt8o9NYPfRCc/7dPx/da3F?=
 =?us-ascii?Q?fOGFoZauIl4D5X1v1pmEBbgnUN7CeGOP5d87KccuAaudGj+bDwaIVM1TCc/M?=
 =?us-ascii?Q?25XyKs148EkAuao2ZcYckYFAz8F0CISteq/vUjtPzVQui82LJunKmL3ukjYx?=
 =?us-ascii?Q?uyWblV8LuTFOUkDpAp9vNroge1liJZW8t7zd26Xub1wmqkSuIBaqSdngVEBO?=
 =?us-ascii?Q?/hBBmnnuV9axEM1yYcltlCvcvGEX3b2JVEcgn+W5R4Il+CaMEV3DkCAxcBlO?=
 =?us-ascii?Q?7M1kCbNfTTzqMHJ+ge7zSK4iAUo9ClsfgQRvOd8sMvnGaA4S5zq5g95fV8Gx?=
 =?us-ascii?Q?ehXhCwtPutdH84wTXfaIMgku2za1Y9kIBok3MDCbdfj8PLw23tgnsDbmgB3U?=
 =?us-ascii?Q?gapJZOmv6E28vdl1fLwUJSDNf4KqyH9DB3lONXabmYoU9NlV8sWI5/lylxeE?=
 =?us-ascii?Q?B+Q4vUpWnd+K/v+3D8hVFeLQvWUNQeTQrl4yG0PDIlkUPnFgMZsCrX9Jiqru?=
 =?us-ascii?Q?s3BGAR5+EGvzBMFl4yaMtpRrKr1ArB4sn9aHZ1hJGJTv+OSKHCZlHKLZ9Klu?=
 =?us-ascii?Q?ZBpHsm9mca5myCrVltiLBaCu/45EMn5vQa3FCT6+eVpr9xFFNVRH/RDibMU8?=
 =?us-ascii?Q?Q788PqIefgnCvCCYNcOi3JtukDHy/OU1srNE5kAlsdeYY+V9OtrNHLHRMuJs?=
 =?us-ascii?Q?1ou+Txz70ofkxHnkeYC9P6EUzgBcaI019Lt79xCmRcT+/z/lo7aEDQex9ZJi?=
 =?us-ascii?Q?H+8P1fD1GvSvCO+puYL6+oMSbWuMz9A6DrNMK3uyYOzwyY4ynPYOMXaveYf/?=
 =?us-ascii?Q?9lBE5nfitXaFgt6H4zc49L+wR7Omzzaz8/U/1TKYlWV1k/hoDzHvZtZ7eBr5?=
 =?us-ascii?Q?dKxjGyFr3UD1F5oMMwjG8GIgGS+Bb9znqhH8vh3cW13fCA1GcmwOVApEQweE?=
 =?us-ascii?Q?W6fhc6Bc86Ir1yy9iNTaXBZuseBwR1AQdCaF?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 00:56:23.5321
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f33da593-d4b6-4a4a-c6ca-08ddaa151e57
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001F6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8211

When guest_memfd is used for both shared/private memory, converting
pages to shared may require kvm_arch_gmem_invalidate() to be issued to
return the pages to an architecturally-defined "shared" state if the
pages were previously allocated and transitioned to a private state via
kvm_arch_gmem_prepare().

Handle this by issuing the appropriate kvm_arch_gmem_invalidate() calls
when converting ranges in the filemap to a shared state.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 virt/kvm/guest_memfd.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index b77cdccd340e..f27e1f3962bb 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -203,6 +203,28 @@ static int kvm_gmem_shareability_apply(struct inode *inode,
 	struct maple_tree *mt;
 
 	mt = &kvm_gmem_private(inode)->shareability;
+
+	/*
+	 * If a folio has been allocated then it was possibly in a private
+	 * state prior to conversion. Ensure arch invalidations are issued
+	 * to return the folio to a normal/shared state as defined by the
+	 * architecture before tracking it as shared in gmem.
+	 */
+	if (m == SHAREABILITY_ALL) {
+		pgoff_t idx;
+
+		for (idx = work->start; idx < work->start + work->nr_pages; idx++) {
+			struct folio *folio = filemap_lock_folio(inode->i_mapping, idx);
+
+			if (!IS_ERR(folio)) {
+				kvm_arch_gmem_invalidate(folio_pfn(folio),
+							 folio_pfn(folio) + folio_nr_pages(folio));
+				folio_unlock(folio);
+				folio_put(folio);
+			}
+		}
+	}
+
 	return kvm_gmem_shareability_store(mt, work->start, work->nr_pages, m);
 }
 
-- 
2.25.1


