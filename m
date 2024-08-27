Return-Path: <kvm+bounces-25198-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D35C7961860
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 22:13:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 039D31C23117
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 20:13:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B0EE1D362A;
	Tue, 27 Aug 2024 20:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="IoEbQxvg"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2077.outbound.protection.outlook.com [40.107.95.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B95212EAE6;
	Tue, 27 Aug 2024 20:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.95.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724789572; cv=fail; b=KGj68RDhZXoNLZgVgCSeRAhz8BZIrhYzj2XzKPQUrsSNlqNqtadRwgzhoK0dRIoLfr0daK8FQNaw4vlk94pPGaOHM+NgvD6Pxrp8khvbJzJ+lX5qnSwgz7mpRqYbjl/0x5TbYzSRSE6pxuy8i5++mAnr2Hhjk9oYyb7/vrx1N6M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724789572; c=relaxed/simple;
	bh=t/4piX2AZMe2JRHIcqOGMLXInoNa3pAZJ0kDRfULMOc=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EUHjfSyHo8yPefOX/KYYbV+010CU3nPIWbZj0XMuQbYtRpP+s7YnD8v3HedG4HUYjkYQM4FZGCHbf1yumiAMyU25krVjMtIqsdZj/SZRB07VHowXDVMpIinWFHuhumvxTtj3MH+wW3aLxYe3Q5r6V80cevwjtCRAHMoznrC64ek=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=IoEbQxvg; arc=fail smtp.client-ip=40.107.95.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Di6Go0uPVFSxrcvNhpaVej27lpLBsWePDz2SQkZaX9ngepf4KU0++9SfDazub1mCTHbv0AWqG3QjMtWlT6btBGehnj+EYj08SQ2mHQWkjvah2DKfHqr4BbuwN9NNTT50uvr568PHOAepb9Gn6Pd0nudeShZsYr4Ib+5ESP8m1N7+wXS6UnmDg85woUgufxq8wHlJ7LqjIN7rd2MnLa1y9SnVbPnFrCzSCP37/pkaIOq7ldRlGZeySMvglfBhsT1TplgDeK3TB4wJJHzuqT7/PS4AHU8xEdBBiI+RvqlACsf6scwVQZ6unI5rUZzubmCLigtWuQsx4g4DdVT7tnBS5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TL0cGEPoyYO19D122nKczwZQNc0bMXZvL84ljv08pdM=;
 b=op4Pcf/8p3VVkNPYe9Hpav/LOiEKeFNgsOyk7HNVmNWsEvQOr0LNQBxNdR9QI7VP5SkIgscOvfdyk/Ow5ERpihgOFHBRRNHG5cQ70fw3zCAcxgMxnucFIwZFZWULnxOcQnGGXJM0g3/XucrAYbK77TsQv8phJLkz6vm4i+Vbs7CV7lsGACSKrzNw77Yw0Yt3FOvwluDtXxgje7VJsuCl8ia3DcVhYLXMXnUSpqNYGKKbdtRmVmJDkX2yzni13tRRlGZ/ONrGk1HHeEkAgf0/XARYRBOJMx9uNjXsCyESQeGUSEyeM/cDCY44AbfoRTRy5lM+u+XBwamHx7hIn//YIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=lists.linux.dev smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TL0cGEPoyYO19D122nKczwZQNc0bMXZvL84ljv08pdM=;
 b=IoEbQxvgiTkuhJn4X5tj+8Og3z4QeYEXJxntgCMxh3YO8a+XIvCHaXVjbxMrJedukz7ssRZ66IPfa+DtSFiduDhV9tDNlsctEt+8xRHNEEOCL3QY5W6yLWTICffTR6kuBRRHIhuhtD44gfQgGH39XpHLPYo1z72f4aiZGRhxI5ZxzfLLYuAz0V+8qjj8jQJfkbOFCw/3xTdGcwNAZO9vzEtcCRiMGt37T3erHKKg88VnZJz6hCqpSuHDhr8r+wvs9etYlMgefgYMt/8oN03rhpGYLLlhTLOJvesx3RkluvJxFoWM2l6McyoE1pC/ybCbJiOsnBVwuILtrOG5vMImMA==
Received: from BL0PR02CA0020.namprd02.prod.outlook.com (2603:10b6:207:3c::33)
 by SA0PR12MB4368.namprd12.prod.outlook.com (2603:10b6:806:9f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.25; Tue, 27 Aug
 2024 20:12:47 +0000
Received: from CH2PEPF00000142.namprd02.prod.outlook.com
 (2603:10b6:207:3c:cafe::1c) by BL0PR02CA0020.outlook.office365.com
 (2603:10b6:207:3c::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.25 via Frontend
 Transport; Tue, 27 Aug 2024 20:12:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CH2PEPF00000142.mail.protection.outlook.com (10.167.244.75) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.13 via Frontend Transport; Tue, 27 Aug 2024 20:12:46 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 27 Aug
 2024 13:12:31 -0700
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4; Tue, 27 Aug
 2024 13:12:31 -0700
Received: from Asurada-Nvidia (10.127.8.13) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.4 via Frontend
 Transport; Tue, 27 Aug 2024 13:12:29 -0700
Date: Tue, 27 Aug 2024 13:12:27 -0700
From: Nicolin Chen <nicolinc@nvidia.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <acpica-devel@lists.linux.dev>, Hanjun Guo <guohanjun@huawei.com>,
	<iommu@lists.linux.dev>, Joerg Roedel <joro@8bytes.org>, Kevin Tian
	<kevin.tian@intel.com>, <kvm@vger.kernel.org>, Len Brown <lenb@kernel.org>,
	<linux-acpi@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	"Lorenzo Pieralisi" <lpieralisi@kernel.org>, "Rafael J. Wysocki"
	<rafael@kernel.org>, Robert Moore <robert.moore@intel.com>, Robin Murphy
	<robin.murphy@arm.com>, Sudeep Holla <sudeep.holla@arm.com>, Will Deacon
	<will@kernel.org>, "Alex Williamson" <alex.williamson@redhat.com>, Eric Auger
	<eric.auger@redhat.com>, Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>, Michael Shavit <mshavit@google.com>,
	<patches@lists.linux.dev>, Shameerali Kolothum Thodi
	<shameerali.kolothum.thodi@huawei.com>, Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 5/8] iommu/arm-smmu-v3: Report
 IOMMU_CAP_ENFORCE_CACHE_COHERENCY for CANWBS
Message-ID: <Zs4zK/5TPHs555Vt@Asurada-Nvidia>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <5-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000142:EE_|SA0PR12MB4368:EE_
X-MS-Office365-Filtering-Correlation-Id: 5168f874-1f85-4524-6e4a-08dcc6d49e46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|82310400026|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4XjPfHDgHoUFL98wSgESy3ahbTm8hX01oHfnhEzO7LMVwocP76oFf5kpbe79?=
 =?us-ascii?Q?pgBamQfT3HdeBTuStp/tE/RPOuedUSQvrzSmTuQPTctFyEOCHdEXVT4RQ4Hi?=
 =?us-ascii?Q?DPufzwKVuX4aQKXxG5txue4TMu2sJyG934CNiz0czhwN4mL9r3VfUzpZb+jW?=
 =?us-ascii?Q?2Z9Nfaj3NWUuHswOwDA8FdOsXN29uLDUHw1wWJ9GlWX+e64GJ8ATrQ+Mus1H?=
 =?us-ascii?Q?i4NJGvWGdJfJbfjO0yBU3UB3TP9WB2Zu6rFoDDqW6756cvHgWaBstg8UxggT?=
 =?us-ascii?Q?xRvKRr6RXfr+lPXvZUVJxIgQzrWhDCwU/VpdnW8kkM2bwJLS1JKcMjSN5HZv?=
 =?us-ascii?Q?cIoRRziuhNhCR5/SOfGQ1dhcHcr0cQYnL0/hU+E7ujDYJSmPgF7iVs/Yl7eg?=
 =?us-ascii?Q?Wh1vrg630yMLDG/Wn7bn5teJbSswlBH/XC9yEPJWo1+jTwsm9IeO++iDi1JW?=
 =?us-ascii?Q?NJj6rSdYW3ufSn7aGWJyNvQed8MtxL1iiEEPtBLRuB2AES8Wg0aq63nC886u?=
 =?us-ascii?Q?LkBYvCZobWmartalIvAjYkFxcXaiMUpzIS72bQECYNNXboIIVZgFF6v/wXOE?=
 =?us-ascii?Q?Ud8is5IzDz1QkvWmnO9vh655VFdR4bAZHOY+MhMfRWt870PSoO6jcIR4z+d8?=
 =?us-ascii?Q?tJqxk0ZIqSlMb+zOOsVbBec34DRoQpMoNdiymJSuWRIaKr0yTuxheK3uWXJB?=
 =?us-ascii?Q?9FkGxAStC0PCKDl5XSrmxqkctVlys+yqBCHQ+gvHcpgTn+RdblbD+XXPWqN3?=
 =?us-ascii?Q?0GDMr8eIOra8RKN+BMGzlE3P1HIPj1913CFFE10wR6jz7B+VKMwc9Qp5F3Tf?=
 =?us-ascii?Q?7Q8SClOmompenZQKj3+wL9znqwsEyLUc/Gx2nXIjJRx68KRsmxWlZl+FRf7s?=
 =?us-ascii?Q?y/noTsTXalg4kSOd5wZpdkdCNTiXe/bEXLim2SySv7MEeeKienUp7Y2Gn3kS?=
 =?us-ascii?Q?pjJEskBIME4KfrorS9qgyH+iuGQkcIRK9CldQO49s7NmfGG0VQH9CbEDMgXi?=
 =?us-ascii?Q?gcV6DpfcrTXD4gbl8fpdd1NbMtT+2IFZi9knUQmxHnyt8FYl/LHleGihOfCb?=
 =?us-ascii?Q?XwwSVbpzP/y/HZ+keapW4MABOpJrR691oOjp+b1Ryjq5d1KQyZqYrF3+D3yI?=
 =?us-ascii?Q?/O4PArT/lJRG1TAz4a7/ijSO3zvmDIlUBNkGsRkmIugLWIPnqiowHjc7MLIF?=
 =?us-ascii?Q?yXpdkF8/Q5fdZrLpScqsXFKdISCJnmuwKRqU5EJrppsUo8QN7jzxTWG2olyz?=
 =?us-ascii?Q?kiAHfidGrJ5xFS3q7rL9MMk63ZjBNPUN96b8eI877MEtjrUE+3uV8l6SlGbv?=
 =?us-ascii?Q?go+1TIJmETqT2XbdtpRpZiClRIXjhtTH57281LUP60sLtiT29BuNU88L2Eha?=
 =?us-ascii?Q?5KJjnRDiXxN+HffWW655aMGgOnjeNS0GfOr8GeYeP1geLvJQJkd3PiZJDOl0?=
 =?us-ascii?Q?FwKne6jQt9GqT/R+vAQJ7fk2/7Bmtud/?=
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(82310400026)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2024 20:12:46.8831
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5168f874-1f85-4524-6e4a-08dcc6d49e46
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000142.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4368

On Tue, Aug 27, 2024 at 12:51:35PM -0300, Jason Gunthorpe wrote:
> HW with CANWBS is always cache coherent and ignores PCI No Snoop requests
> as well. This meets the requirement for IOMMU_CAP_ENFORCE_CACHE_COHERENCY,
> so let's return it.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>

With two very ignorable nits:

> @@ -2693,6 +2718,15 @@ static int arm_smmu_attach_prepare(struct arm_smmu_attach_state *state,
>  		 * one of them.
>  		 */
>  		spin_lock_irqsave(&smmu_domain->devices_lock, flags);
> +		if (smmu_domain->enforce_cache_coherency &&
> +		    !(dev_iommu_fwspec_get(master->dev)->flags &
> +		      IOMMU_FWSPEC_PCI_RC_CANWBS)) {

How about a small dev_enforce_cache_coherency() helper?

> +			kfree(master_domain);
> +			spin_unlock_irqrestore(&smmu_domain->devices_lock,
> +					       flags);
> +			return -EINVAL;

kfree() doesn't need to be locked.

Thanks
Nicolin

