Return-Path: <kvm+bounces-43722-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BC009A95604
	for <lists+kvm@lfdr.de>; Mon, 21 Apr 2025 20:36:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9F8E93A7739
	for <lists+kvm@lfdr.de>; Mon, 21 Apr 2025 18:35:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27EE01E5B9C;
	Mon, 21 Apr 2025 18:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="uNxFMoAG"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2049.outbound.protection.outlook.com [40.107.223.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF9818DF86
	for <kvm@vger.kernel.org>; Mon, 21 Apr 2025 18:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745260558; cv=fail; b=aiI0gqyIonc6sw6djwegkQbPmb45oLOq4lLc3MPoTvFsraS4Xtmy8KF0O4BBaETHSDN6tHTGF8CMD0XAUI3AAd/+MXc9GVCvN42XhRFHneoLNwx7z87QCvxK0pFDrbRtY31KLQMcB0kHojDzKSmvwOX64MsTm41svMVH92iuh/A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745260558; c=relaxed/simple;
	bh=K04xTNpzBHdcql942h6zAH4D3MZY//VEe70eA1jGnUQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SoOUmOrieH1DbghjPiNVAMG/7r3yzCHWMSbd55LFaM9dRFgQ9YpSqPND4xHHPHXDK1kdhPFfYdxB5HTir9Vd5nZ+oz0BR1mBF/N5I5/zTVt5vXu6rDBL8QsvMzkIzB+fu8k+k+xzDOE8YjFtleMXFqSEvqb2IgeGa2cOPFlKJN4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=uNxFMoAG; arc=fail smtp.client-ip=40.107.223.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FYSIPbzBA15smYI6wa8aJtkh6orN8d4resei3jE9jBRc41DYdWafoN2r6iG6fsIZjsTIS7ySTmE6bBqGsZr3NohjUgTt5nhYqHkMg7Lfr+8sa5nt/wbOTIp5JU8+bMen6oxYJtXuuzbmd4Vjuy7hBl5+0nmGH8HnUeCzBo6lyHldsF18iSMNfVqpr9v6ANve1No6c/+rZUpxpe7INz9t98sCI5qkmmH5RXonVypu2CxYFigNNwSAh/5kv37+zCg5sq7i0irclwwWaGtZdRIVDifAM/fdW+rc4YipIDkf9tVaz2aI+ytsiuW029IcjukntNPW9a4FUQ26TCsnIO9P2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QKVveVAO+A3c3UYmz96vyRQq4MmYOIrCeoA8Dz7aQkc=;
 b=YWjytLRAIt4UrQGPgj4GHo6lqg1hLC06VMHXfyyMXOhXyImfKHH/IQut9KhNatpWJ+V2HgqlGnNITu9s228N2KTWKvB3PXLIzWFs8BpU7QnRTRjPCiLmtV3u5DxlX4MY7SDaJlzsTMHE8nj1btN76nHsCKCrK0DpWd9o2rDlU/SwpKps9E7BvYNG8/KSB3kA48CFQh4jc8wpA96lPhYbwTszNoaLqS+d6tJfCAGDwOuQlp+Jw15w6snJMvjNvIGS8tDsDCHpCmaj/SPAyzDz6E7mll/QzrypyZ0qzNvzBfXfh1FVqRiK4SBcG1f2c/U3JYg5X3sQCZlHdsXf90bumw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QKVveVAO+A3c3UYmz96vyRQq4MmYOIrCeoA8Dz7aQkc=;
 b=uNxFMoAGTt9cUaH0NhRvn5u/1Eei+MmzaKPPS1BsUb9rWeDal/ppTXkS25GKaXPxLB/DANT7asl1VuL+hVOTjRZ1W46rUTb9sJ+QJibpU2ShoYL1raZX0NkxQBrkKwPnmSpNZKJbJ9a0tRv3Ob/9XUYDWEb4qr+Flwph2NMh+PU=
Received: from BL1PR13CA0123.namprd13.prod.outlook.com (2603:10b6:208:2bb::8)
 by LV8PR12MB9155.namprd12.prod.outlook.com (2603:10b6:408:183::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8655.35; Mon, 21 Apr
 2025 18:35:51 +0000
Received: from BN2PEPF00004FBE.namprd04.prod.outlook.com
 (2603:10b6:208:2bb:cafe::90) by BL1PR13CA0123.outlook.office365.com
 (2603:10b6:208:2bb::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8655.15 via Frontend Transport; Mon,
 21 Apr 2025 18:35:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN2PEPF00004FBE.mail.protection.outlook.com (10.167.243.184) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8655.12 via Frontend Transport; Mon, 21 Apr 2025 18:35:50 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 21 Apr
 2025 13:35:50 -0500
Date: Mon, 21 Apr 2025 13:35:33 -0500
From: Michael Roth <michael.roth@amd.com>
To: Sean Christopherson <seanjc@google.com>
CC: <kvm@vger.kernel.org>
Subject: Re: Untested fix for attributes vs. hugepage race
Message-ID: <20250421183533.rnoif5ky37umyw3e@amd.com>
References: <Z__AAB_EFxGFEjDR@google.com>
 <20250418001237.2b23j5ftoh25vhft@amd.com>
 <aAJsDVg5RNfSpiYX@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aAJsDVg5RNfSpiYX@google.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN2PEPF00004FBE:EE_|LV8PR12MB9155:EE_
X-MS-Office365-Filtering-Correlation-Id: f9b515f5-128b-49d7-bb87-08dd8103578d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2LJ+YHYEv83AAVAoqlW4Rissk5OK7wtCYV55exXeWfiVZ6hxr0ePp3yJoXSb?=
 =?us-ascii?Q?X9lHz0AH49AdBqINPQW55jmAlpUqS2SM9nzOqZzM/By4evjfapvbpJwbdy6m?=
 =?us-ascii?Q?U0/gDuYM2KgA3k5u4hc7bVmCSjO4x4WrtSQkFUce9FMBeG6TkrXJ523/0pb9?=
 =?us-ascii?Q?sedsULuKosGNmpEC6KHjS/i6H3nT6nl4LNDXSd8dJBEULNll87KH0SHEgFW4?=
 =?us-ascii?Q?qxQ3r1y9hkkyTajZPjqIzfN6L8/BFzWVz6Il6TYC1NdRE0Ipyyp9CvRjilou?=
 =?us-ascii?Q?YWWHxhfx0OSrB3RK8by9IhOHnYWFGYsE5cejyTeThXLZd4kJFjEX8yg8MqK9?=
 =?us-ascii?Q?MWmEvz/XdnroHnmxUE7v84G57wTEHF+Xx+8jzRVievhdeuJPNa1PK+nEk8G5?=
 =?us-ascii?Q?AB2A9sHsRbol2qmJCe5YEhJ6ZNj+FTnIRVoZ5DoosWcvShiB/CMZgwFvoAVB?=
 =?us-ascii?Q?+1S5YRJDYLiDNPD2cf3U9dUhclprllmgDn96dlMA6UaZ8hJjh3PjdoD2WzSS?=
 =?us-ascii?Q?8e4cbA5BDuUYjU62SPhIL+DafsXGl74pBq+tuZrmFDlpZK/HGoTLiCfCFnXN?=
 =?us-ascii?Q?3lTg9Z3dXkCYWwuqfb8ted51itpqO1Hw/HhgTAbjJ9/FiIfYLBoz9pX0y2BN?=
 =?us-ascii?Q?jwXPUbmYjgLpUpCuHljKZ+DCkDVEoFf7apcvlmFCJoSJHmS+5GcRfGBqkr8z?=
 =?us-ascii?Q?iPwV8x5OR2ULuhiXOn4Akd7BC/wsFTreoqTP5fSVSrBgFcAWH1t6YVIEwZkC?=
 =?us-ascii?Q?Vj9vCH/Cl8YTMukWs8xa/MAT70572U4uSh5LrFr38g6Ziiuo++WF4I992hN1?=
 =?us-ascii?Q?hHB+vpdb6jNiiZ+hdZREkgJXDxj8tF4rD8svULR1HAHJ6gO/IV5NQlSa9ej7?=
 =?us-ascii?Q?MZJ6wcTwC96xYlWmlT3mNo2YeA2Jn50kxrmI4iA1BQ1Kdw7HSeE7EhBaU33O?=
 =?us-ascii?Q?vBXJ1URqtXBAl1UYmEwbAun6tmejNuhkMRMZHGmhsPQmVY6rUDZl9c9CIQgJ?=
 =?us-ascii?Q?NJEs14fCzoVTsvPa1L77m84yE4HmpR+6f92iwIBFSoKXSiQaj6amkE82lDj6?=
 =?us-ascii?Q?EVmMFNkHG7CGPjqZAAlU/MYX6SzLOn/pzmgRzpx07NYIXuyOvq6Qx6vlt4xO?=
 =?us-ascii?Q?74z894Iz1ksBObiyuY3OACMzhuEAYCe5XpdAmh2ApyCUoKlDnQVw2L8wo/PS?=
 =?us-ascii?Q?T/jqj44litZJMlUxOYyc0bKoPydvCQzr2EzLDBdwuDfXhtcasUwzbexPRQgo?=
 =?us-ascii?Q?CjBbkh0/2vESbiAzjXNIffNv6cX8mIMI24L0nFZ3uaF+9A6WIqVtjLa6z8Nz?=
 =?us-ascii?Q?+TRENWdDW4B+Bln1bGvhhbVxegvsK2wseBlaB/JSC22pK0XEUSnmamEscIH0?=
 =?us-ascii?Q?6Ill6qfk5S+av5uU4L2eJpINlsDGKnwDY0LZe4RJpfHNG7geHzXD8c4b21b3?=
 =?us-ascii?Q?5Z4eiUtjA+LUX77hWvivLz9Ef9ugbzO2s0IHbE2RFmwjMrjliRpiDdnjpC88?=
 =?us-ascii?Q?BMkCF7GaS6gyDY3M5bo2YfpcqirqKdoFGEQx?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2025 18:35:50.9801
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f9b515f5-128b-49d7-bb87-08dd8103578d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN2PEPF00004FBE.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9155

On Fri, Apr 18, 2025 at 08:13:17AM -0700, Sean Christopherson wrote:
> 
> That all looks good to me.  And to ensure we don't go off the rails due to bad
> inputs (which are supposed to be fully validated by common KVM), we could add a
> WARN to detect a non-exclusive range->end.
> 
> So this?
> 
> 	if (WARN_ON_ONCE(range->end <= range->start))
> 		return false;
> 
> 	/*
> 	 * If the head and tail pages of the range currently allow a hugepage,
> 	 * i.e. reside fully in the slot and don't have mixed attributes, then
> 	 * add each corresponding hugepage range to the ongoing invalidation,
> 	 * e.g. to prevent KVM from creating a hugepage in response to a fault
> 	 * for a gfn whose attributes aren't changing.  Note, only the range
> 	 * of gfns whose attributes are being modified needs to be explicitly
> 	 * unmapped, as that will unmap any existing hugepages.
> 	 */
> 	for (level = PG_LEVEL_2M; level <= KVM_MAX_HUGEPAGE_LEVEL; level++) {
> 		gfn_t start = gfn_round_for_level(range->start, level);
> 		gfn_t end = gfn_round_for_level(range->end - 1, level);
> 		gfn_t nr_pages = KVM_PAGES_PER_HPAGE(level);
> 
> 		if ((start != range->start || start + nr_pages > range->end) &&
> 		    start >= slot->base_gfn &&
> 		    start + nr_pages <= slot->base_gfn + slot->npages &&
> 		    !hugepage_test_mixed(slot, start, level))
> 			kvm_mmu_invalidate_range_add(kvm, start, start + nr_pages);
> 
> 		if (end == start)
> 			continue;
> 
> 		if ((end + nr_pages) <= (slot->base_gfn + slot->npages) &&
> 		    !hugepage_test_mixed(slot, end, level))
> 			kvm_mmu_invalidate_range_add(kvm, end, end + nr_pages);
> 	}

Looks good! Re-tested with this version of the patch and it seems to address
the original issue.

Tested-by: Michael Roth <michael.roth@amd.com>

Thanks,

Mike

