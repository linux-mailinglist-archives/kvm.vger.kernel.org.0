Return-Path: <kvm+bounces-41579-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 515E2A6AB78
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 17:51:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3D6401898A2E
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 16:49:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1283B225A20;
	Thu, 20 Mar 2025 16:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ZH7c7djE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2086.outbound.protection.outlook.com [40.107.93.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A16C4225791
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 16:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742489269; cv=fail; b=StEbVFwVvyvBhxhdmh4Q3Qb/Q8zI71uV1Yw8qbAUftXSmts6gkADtWQhPp3+ZlzD8YAairCPXwBmOcakfcFZhPZ6I1APcIZtdwvJMsLin7hbedHM4cjyimJFpxcNdRaGJIGSgis8VdqQI4ydSI+bcYtSKExuvGtDpG2XSd/dAQQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742489269; c=relaxed/simple;
	bh=K+hXUgy9lO9qrJQjvUcLAfG9ixJzxTizwHlWtXzpfpg=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eQdk/M6b+Vsr1T4weVZMJj88OEk0WxyuE9KshqJHOaBdh1cII43xYs4p/5PtpZ0pkQ4D1xtNcwZ4q2utb8Ir2zC67ArkxTpZbKJRrjh9yuRbTo9sxa8kW8DaXC6KyXwbJktqq9K3h3eyMD94cmpFCGnC+YMTMJ88r+rECbNAqY4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ZH7c7djE; arc=fail smtp.client-ip=40.107.93.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BZ1OmkOESAfwdTYeeZFBUhlXc5lZ9kXd9I+mWzIuAgBW/xyAWhxb62/E3h4/B51Iv9DQ2v0a9Eoki57ttlsBrwaCfuHpORTYIrxFDEYMJlg89lXkJ1O8K4sOLhs0c6KDGZZkvYrvp5fSiVGo+eiu1BuQ3j7fz+OLHCviNXoVUpEeh4/4bFxRMvvk0iCFZH7N8dnOUBXBm6HUH5PTKmqXEUSgw484ZdmRsxa2yolHIAO6LVUtYqFpb3+wNAOCocw2UV4+W9Z4SRjrKTUSMfZqZVmTT30s9bOrrI7m46A5tW+oj/sGPi7419ezZWwDFMQlXbSrr0b75bsJ3PbfvbZLTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=shMPHKWIS1Vgzrr1JSlHoFfvnFy5ZmjHJE1XiotL2mY=;
 b=X3hv4/ELHFRN7qpfq4w1lpFDIjycYuSiBsK925xGRBlwwJhMy3rCVPIFBFBlvv15j8BC7WY1h5FUqKQgGM8Rl7Jn1/+y3KJebrRExRPmcCGiGCAHakxBLD0gPbRj08nhvxIrLYXvyCgPXMPxYaG44WoNNzNgFMWUJ4YOHMT/6W4VjhZIlUjxJKvB5IVEvXpeWV9EAYSKpLUlyAeQEzsoeDpNhWWucTQDssveHwOpA7WS6rXBtJ3JIKYqJiPQiRNN6H0i26fWD8bO2cqc1u3dagh8npex8b86Hq1Hlh2nTunPt5A/O94lw5xDRwwgvjJN6t8tpS9LOZuo3G1NLn0Pew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=shMPHKWIS1Vgzrr1JSlHoFfvnFy5ZmjHJE1XiotL2mY=;
 b=ZH7c7djEyc0fbRfyj3wwCI5/rv9l2+vYKIMo71lU6IS/hbZSzzD5N3GAb1fROINh/3DcjeiboELQyFPXH+xEWEuB9Gcoj7Dd/oF4JSPsY17JA7BgnUdVv/EcIP2S6zopUW+HsGpnIudVgBeTbOvJcig/2a/gF2Tolwxoc+f5/idi+ZUhwtQXM87pdMPzXbCE3oeq7fDasYto+ugw2UAYCOsFFBKqetTsFQNb4kUFU1t1Cr4sfi8SB0LUQvkd8H6cqYKn0mt7qzVOg0FZQfkGFJs657X/yazl1QXzvkPCgi0EFULoV3bk8suwSdDMwQdlkvum6Oo6Gz/7p3KGQQYXMg==
Received: from SA1PR02CA0010.namprd02.prod.outlook.com (2603:10b6:806:2cf::16)
 by SJ0PR12MB6685.namprd12.prod.outlook.com (2603:10b6:a03:478::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Thu, 20 Mar
 2025 16:47:43 +0000
Received: from SA2PEPF00003F63.namprd04.prod.outlook.com
 (2603:10b6:806:2cf:cafe::2c) by SA1PR02CA0010.outlook.office365.com
 (2603:10b6:806:2cf::16) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8534.35 via Frontend Transport; Thu,
 20 Mar 2025 16:47:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 SA2PEPF00003F63.mail.protection.outlook.com (10.167.248.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.20 via Frontend Transport; Thu, 20 Mar 2025 16:47:43 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Thu, 20 Mar
 2025 09:47:35 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 20 Mar 2025 09:47:34 -0700
Received: from Asurada-Nvidia (10.127.8.13) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.14 via Frontend
 Transport; Thu, 20 Mar 2025 09:47:33 -0700
Date: Thu, 20 Mar 2025 09:47:32 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
CC: <alex.williamson@redhat.com>, <kevin.tian@intel.com>, <jgg@nvidia.com>,
	<eric.auger@redhat.com>, <kvm@vger.kernel.org>,
	<chao.p.peng@linux.intel.com>, <zhenzhong.duan@intel.com>,
	<willy@infradead.org>, <zhangfei.gao@linaro.org>, <vasant.hegde@amd.com>
Subject: Re: [PATCH v8 4/5] iommufd: Extend IOMMU_GET_HW_INFO to report PASID
 capability
Message-ID: <Z9xGpLRE8wPHlUAV@Asurada-Nvidia>
References: <20250313124753.185090-1-yi.l.liu@intel.com>
 <20250313124753.185090-5-yi.l.liu@intel.com>
 <Z9sFteIJ70PicRHB@Asurada-Nvidia>
 <444284f3-2dae-4aa9-a897-78a36e1be3ca@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <444284f3-2dae-4aa9-a897-78a36e1be3ca@intel.com>
X-NV-OnPremToCloud: AnonymousSubmission
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00003F63:EE_|SJ0PR12MB6685:EE_
X-MS-Office365-Filtering-Correlation-Id: 222190e1-ac1a-4278-6bfb-08dd67ceef5a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ykCQq0VGxddOBkf0FYjX+tZnlTBResewsYuSEtKEeQMj7+X0r7o2xxHYhG/P?=
 =?us-ascii?Q?p2ZFINXKszIcmJwcHKDjk3DJiKX/3WX8WmpSXoz4+ZcGxdYW5ZlMXLA0v1NY?=
 =?us-ascii?Q?28ezSKTd7wJOSvdgrno44ef7l0vhLpR+aSkXsfv7KVcAXJe1Vmnwg2zXV4Hk?=
 =?us-ascii?Q?uSXQWCFJoiwSgLXKYUHi4ROpLhF6uR20NweETobHs7JDQ9xYifbM+UnX0xH0?=
 =?us-ascii?Q?sXJfJ+zzDqwqiOeu2kLHLBQFK8NSDpmgvcH3YfLZLzQ/u+4gqx9ztsXcyqD+?=
 =?us-ascii?Q?ByYnl32VoNzQZ6KMndYgce/VpJcjmqmSzPK1O1W/z4HYhM4W9cYQKSfp1tYl?=
 =?us-ascii?Q?IwemsHBzi+5mC/dJTmMajNx9Ln2v8MmAqDz7eqMwA/bp/+W5YGDtMHzq6Hr3?=
 =?us-ascii?Q?s/WGtWNKMyrg0iOP6f74udjYlft6atWfCCbY64+EzD3z454eL7ND1fZosWb+?=
 =?us-ascii?Q?V262bGi1JFH0MqFXzW4yaULZYBq85PmN0UirofwbeXspUjaIRauBUtuFwQw2?=
 =?us-ascii?Q?FVyUCSKGdpd4yCq2GcqPHYEaSTmOogY/BP9gUFWzPHQ9XUmQ3d2Zkg9CmMc8?=
 =?us-ascii?Q?AERaTvQOLDs8ldHBRUtVsGeFlrdXVPsX1aSpVZp0y+T6EVcQFOiBPJRqiUA2?=
 =?us-ascii?Q?AFS54ZtCgl6Lx941a4Z1RC4EMNGhM3A0eWd9SUxDa6iHNVDqaTdphhsh4aLx?=
 =?us-ascii?Q?Bl6FgpO3zDHH8/Wacq1NoQvCttaV170PpcyHkc000d1Tig22cJAUWX8QQUJ0?=
 =?us-ascii?Q?dk1IokWhbPbj5wckWu7c2ILgpStrkUoaNnps645XXHMp4sUaLGb0b36dPmnC?=
 =?us-ascii?Q?hsEqItcENZnnSYDW3wwJfxiErbqDPWlTsjPV8UMxIP4sC58YORo8/EWQfmxu?=
 =?us-ascii?Q?S+FORuAZ7EaRLcYHpjb2rHm4h4yt4XUVVWgJeKTowMt4zPsByN2yrrd+uF9v?=
 =?us-ascii?Q?BEMHhtyhiNFboqnQhRcEJ0kaF+e/c/xBRc4HarflH66FNDqAetndTJm2Du6c?=
 =?us-ascii?Q?0QOKoNOr80BDAxFklnnlnxuoxyPFacC76fxnHYpdFOdoiYLRNQJAR8XHBYqp?=
 =?us-ascii?Q?LOO3uQDTkt1z1AJV5JOtZzABXX0F9Lc13gA676ehIcKfp0dLnZRMvpNpi7kC?=
 =?us-ascii?Q?lhgPNuRhVkQwRGFLEQQV9XXmw7ZoDdZ/snQewpBx3QAs6B2vaUmxX2GBfrzu?=
 =?us-ascii?Q?k30V+I1fjDJQSV0bErFsA9teMRvefzNHiuv0AH0+gUJ4cLoIp5EBlrIRk9F8?=
 =?us-ascii?Q?2juB9HjDuat2NuivJZxTDIyNaHv9ziisVt0wy2jgATjI7P4Q5Jay9UURQRV5?=
 =?us-ascii?Q?7Ckt26v2XLwoyYj4hh1SBy29TRDsVAwtzVFwwn53P0EjvTi9+ZKRsyYX+fAG?=
 =?us-ascii?Q?NS2D64ETBl9Dgs+WUy3f82XWDDm54BmX+S6ViSx7bixhD6NUNavN6NRudjCE?=
 =?us-ascii?Q?JIsoZMRnMRWxQPSA/nn0Vi7YucZtmC2m+2P0/XUYfkaGFYrb3MZHtGyWcoyy?=
 =?us-ascii?Q?rRKWD8XJxfQzRfI=3D?=
X-Forefront-Antispam-Report:
	CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230040)(376014)(7416014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2025 16:47:43.2145
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 222190e1-ac1a-4278-6bfb-08dd67ceef5a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003F63.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6685

On Thu, Mar 20, 2025 at 08:48:49PM +0800, Yi Liu wrote:
> On 2025/3/20 01:58, Nicolin Chen wrote:
> > On Thu, Mar 13, 2025 at 05:47:52AM -0700, Yi Liu wrote:
> > > PASID usage requires PASID support in both device and IOMMU. Since the
> > > iommu drivers always enable the PASID capability for the device if it
> > > is supported, this extends the IOMMU_GET_HW_INFO to report the PASID
> > > capability to userspace. Also, enhances the selftest accordingly.
> > 
> > Overall, I am a bit confused by the out_capabilities field in the
> > IOMMU_GET_HW_INFO. Why these capabilities cannot be reported via
> > the driver specific data structure?
> > 
> > E.g. we don't report the "NESTING" capability in out_capabilities
> > at all and that works fine since the iommu driver would reject if
> > it doesn't support.
> 
> NESTING is a bit different. Userspace needs to know underlying PASID
> cap and further expose it to guest if it wants. While NESTING is not
> from this angle. It's just for the use of userspace. So a try and fail
> is ok.

Hmm, would you please elaborate the difference more?

Also, what's that "further expose"?

> > Mind elaborate the reason for these two new capabilities? What is
> > the benefit from keeping them in the core v.s. driver level?
> 
> I view the PASID cap is generic just like the DIRTY_TRACKING cap.

Well, I actually don't get the DIRTY_TRACKING cap either. Based on
what I see from Zhenzhong's implementation in the QEMU, it totally
could be a vendor-specific cap: we can just add another PCIIOMMUOps
op for QEMU core to ask the IOMMU device model to get hw_info and
allocate a DIRTY_TRACKING-enabled HWPT to return that to the core,
instead of core detecting the out_capabilities in the common path.

In that regard, honestly, I don't quite get this out_capabilities.

> Reporting them in the driver-specific part is fine, but I doubt
> if it is better since PASID cap is generic to all vendors.

The argument could be that NESTING is generic to all vendors too,
yet we don't have that in out_capabilities :-/

Thanks
Nicolin

