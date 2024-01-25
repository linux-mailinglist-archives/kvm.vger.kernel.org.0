Return-Path: <kvm+bounces-7013-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3021C83C3F7
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 14:44:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7460AB21C16
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 13:44:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5008D56B72;
	Thu, 25 Jan 2024 13:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="j7tRoA2m"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2048.outbound.protection.outlook.com [40.107.102.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F7455E57;
	Thu, 25 Jan 2024 13:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706190274; cv=fail; b=RzXDQLBL5KDgiOX6gE6+XvE/sGPjPLywrwPZg+SGPokScD6tHOjxlCEPy8dkGJ0CTpAhvGb3GD+SOUqTL+tS4MAt+bt/HAhTmMzsuemlzEra++xvg5QMYz2QCybusJa5PUkucGQD+MsqytuCpI+tZgf/qyqswgNRPd1TT6v3r84=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706190274; c=relaxed/simple;
	bh=UcO+UHCYzCEQSfJCJZ2wirV6Ro6dxg8e7exDNYkWZkY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pA/Ix4QOJ1Tz3LwFFD8fmp6MX42WznI3bkEQZ6nln9G2co4pObTnwJXYdrM7Y4Cm3lOm71fWchnqtXskxuNbbF2kx1zwnTcIozVPcptQUTJNFdipB21umfUIReRGVJ9MNxe9LG+cF0vl2f1OJv8YYEjc2if1vYrhKq378TxvYIw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=j7tRoA2m; arc=fail smtp.client-ip=40.107.102.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Mu+iY5RJnXsrTEWh5IMbe/PFq9xQM1ReOIolLGKvytX7GWHm928bODFvlLo0dav86CExro/O5jONXpyALBVrQdBrd8/Yh+h1kpijuWUhgQ9fdC9sAZH8FN7a1fpd/wtT0sBkBe2FBUXXTMjuZS2DP5IDiWn6ICSNL/5tExYtuEC9892czLde0ge9Ku36U+HYL1WV8KYjM8HXlyC9LzEk8wCBunlOU4jDaxULl2343usT4XMWOJS77T6KJNiNHG4ukYBShbrfdbAGqYiIoJ1dc26v3rsJ5hanEUFbFcoIfXMJj+NdG0zRBN3FTmb5zZInJiQfDX1nB+B/j22y5LI5pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vwfB+CITEtNfpCHrH3xUc1cWn8n6XBWEwkCnoNJ4VP4=;
 b=I7cGfkQ3Ik1JljBX6D5T+VmGYpkMpoPNXUErZHo7f0YOxJVBBkkg605/G7G0drNxIq/S4OhOu5hUuWRpOYGl/ReFAgyh3xSYBcXBttpO2n0fQ5mgm6OaAMu7MtZpX8vA9tVHEwNVaKjEhTIlySLLKn+ZtWyZofoIr6BLq/hVKz4LkmiMsE4IarvJIc9TtixXmOvzG8rc+zcmoXPJTDV78mZNadhLhqYQk3vEXhC01nU909uoEfs3s55uD+GYvsDGeeGGIIg33De2eviGBNoVwMb65vwh9wwTzXCnA8dW+0NckIMAK8YG711BAMglKlQUcqv7Cvir7iu7AN50hcoHuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vwfB+CITEtNfpCHrH3xUc1cWn8n6XBWEwkCnoNJ4VP4=;
 b=j7tRoA2mKZZDOo9JX33GVUoxE+dKSw5vS6BJnWM+HYeB4NYmrEm5kVYmxYhgFavZdLenmdQeEDPo1AnQfEfZmoJu798ffs0CcAate8b3dJXtWZl597XSJzURJ4beCfWTg0YbMiiDlznZlc63DJrLbhMVbrtdEOPQSm/1784oC4NBPMdauTxD3siyHwgXeqfVu8jjsnDAW3MHzPM7f4Xo9F6nJStVvLwxk3VVucpbzFvBPwswO9Vdb9d6jbE16SjtAcCXv96XnuFoIwcUJiAxhv7s1aslo+xtcedgTrQ2uur7sGZDgCaU5OvipOUclTXBrmcn1mrXhd/5oP56Se238g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB6304.namprd12.prod.outlook.com (2603:10b6:8:a2::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7228.22; Thu, 25 Jan 2024 13:44:30 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7228.022; Thu, 25 Jan 2024
 13:44:30 +0000
Date: Thu, 25 Jan 2024 09:44:29 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: Joel Granados <j.granados@samsung.com>, Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Nicolin Chen <nicolinc@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
	Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Longfang Liu <liulongfang@huawei.com>,
	Yan Zhao <yan.y.zhao@intel.com>, iommu@lists.linux.dev,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 04/16] iommu: Cleanup iopf data structure definitions
Message-ID: <20240125134429.GO1455070@nvidia.com>
References: <20240122054308.23901-1-baolu.lu@linux.intel.com>
 <20240122054308.23901-5-baolu.lu@linux.intel.com>
 <CGME20240125102328eucas1p288a2c65df13b1f60d60f363447bb8e5c@eucas1p2.samsung.com>
 <20240125102326.rgos2wizh273rteq@localhost>
 <cf1319f7-b91b-4161-8b62-2b0c03f53c16@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf1319f7-b91b-4161-8b62-2b0c03f53c16@linux.intel.com>
X-ClientProxiedBy: BL0PR02CA0094.namprd02.prod.outlook.com
 (2603:10b6:208:51::35) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB6304:EE_
X-MS-Office365-Filtering-Correlation-Id: aab47160-e73f-4e50-de81-08dc1dabc185
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	3F8voNQm263ZS5FiIfKLpgq25rsDucYJXyjThRIA/UdYyrg6RVVks435YFaV6QsOcDv4JRC4v+/6e+uIXO2nrSkeqfiYUoX4JQVnKn4hXhy81M0kov+ir+2OrsbLXjX6uOv6Ehq/uguCN8IrGsycAVD36zAaSLNj6OpMOuDyprQyBOU+YqpNXKjSIV/EphwPfE6kqDlG1hWp2ukjmfCMUEKbyHCKSjsUpkdAvMAXcA83iZRp5k6ZZQzNGwnFofEFneOle+l2qt2/MBQOD4pXnsUkySJlCy3IYQKtLxxNM33ORzPFbSNTsAG9+D/yZtaOhinY16R/z0xSU37msqtB3Ju59/aZWCSD5nvxgMW0WqWhxAfstYS5jioKzuKYZpjApYhU4sD2D3Me6QsQH4kFuVbRmIuZgGi0UBzIBxysoegDMUfQZmJck6RpEF1idicj5n7i3lZezNmJgNtnpCHRk33cX2PVcUTSaEk28AUTp1Zge3cQBOhv3sFmXdG7FEXcNW4gVULb6qjNVCCHk0gER0nZb9BHsHW+O2Ln4JYJKEd9dJmJbFXs0LTbVh3L3euq
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(346002)(376002)(396003)(136003)(366004)(230922051799003)(451199024)(186009)(64100799003)(1800799012)(41300700001)(26005)(2616005)(1076003)(6506007)(8936002)(4326008)(8676002)(83380400001)(6512007)(66476007)(6916009)(66556008)(54906003)(66946007)(6486002)(478600001)(86362001)(316002)(38100700002)(36756003)(4744005)(7416002)(33656002)(2906002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DrC3lQPiAKql/Fu+/BsVtpI8zC810ER3/xss6HkmpjZhRceDgp0DPmNTd4bX?=
 =?us-ascii?Q?2R4WxvZiaPNjceM3+PemwSmU72sqPv5JW80m1EgeT0oPgw1JSLd2YFmRJjrW?=
 =?us-ascii?Q?7DT/wVyNlmoSH7AAmIRyfNKBzeCypmM+M5ZnXWwpjs6weWc+//ItRXHl4l1Z?=
 =?us-ascii?Q?apSMuNaKLUzWiv9VRQPEWeFZMw5a6ZoatQxwyjUavof0O7ZkuelRyFXeFr2T?=
 =?us-ascii?Q?q15deU8TgcIjOmrqgVM3GdqmKYZSUefPrIhwbF8L2iW9KmbC5SLZoq9XtX/P?=
 =?us-ascii?Q?jJ2+xsBfdKas4thk3pOXW+LDfBeTdpWaRXKOs47BIA9DTssIHB41A0FTECCz?=
 =?us-ascii?Q?KpdAahpPl5NT/JS+blhjrD7hKy53DyN6mb4n9YNp8NvPik5BW5NmGQLmS7bG?=
 =?us-ascii?Q?fc7l+dKt58D4vjfobETj+84EgAOrYVWobuTE0ISyvxG6dvxepBNFwWfQ2smb?=
 =?us-ascii?Q?4hl3J4k9jiGs/xGtzUlo2N+Z2m3/Yj7mNqGqqxVJe0ZPDjSM5pirjfDOT/lq?=
 =?us-ascii?Q?VxyJScwGLtLAlKQvCpSiTrwonS3wfdHbfQXHl6EdSHg/mkh5BrP40NVhYwCA?=
 =?us-ascii?Q?uKFiL8l4slIdlkXxUpb3VzTtQkFWzy2C0KTY6175GANJTbZwKdEcPW9e8KjT?=
 =?us-ascii?Q?GqgLhLE1me7d6wYj0qXjPK8mLnIeCa6/flj0zyO9UpZwVIq8lpv24YDEil7T?=
 =?us-ascii?Q?uQae4KGWEsap4xfhbSRBPPvBRVeUVYgINqKgOIjw07wRRqQzhwr/blZyjICu?=
 =?us-ascii?Q?y0f4WsZjuSETwGtUHnLS02r2oErsaWwm7DJtQ9urilx1puFVyFUwR/kaFTOg?=
 =?us-ascii?Q?wVrmDOTaSxOMir8PR7O5N19fOpkh0cJ6w/SIMyRMBWblxHuCqJBIEJ8fBFxp?=
 =?us-ascii?Q?h1BbHdDHLjqmXWMPiGhwSKdgqNAVbLzVUqj6VqAAPtS8Eag+bbGPXuJp5LLF?=
 =?us-ascii?Q?vXAqTcrqAIpXtHlsvl8BkUjakqW1UodtqwjgjwUjJ4f0M8mi+NLctTk1mJGI?=
 =?us-ascii?Q?qBokTGro7qi9BodVAlIL5V630Bfr5QmZJbTEpoIrBRAK3psTmjzdYGNSRVSG?=
 =?us-ascii?Q?tbYBE1N2SHbsT8Wjus8VI65Vj44fGawCRIC3PFBAE3+zGTEhlChHDQgP/xKc?=
 =?us-ascii?Q?saP/b9dObxOed3eWiswQBbcWVeUmkwbmMuTSk9eg1ENp049+YyA+K6L9AktW?=
 =?us-ascii?Q?Rug0ikzIgeD6PGGL3bShPQPRUm7k7/F6fhP5jMLyQyzBf/kzixjbGY+Xh9vX?=
 =?us-ascii?Q?rSPEf/E+yO/GzLh5szqgLmi+4fWx66vZy/cHMAdc87tkG9dDbJ/vWufWtbGx?=
 =?us-ascii?Q?YtOQOz6xBuQcLw1tt8YLwUBf9K1jaqRrjleZRknnlkBPNwhaebt+F46msn9R?=
 =?us-ascii?Q?SCIwnA99vztk9TLNOBPstbPRqqydEo03T72sdTkQmBnsK9tfOdMt2PoVrMDZ?=
 =?us-ascii?Q?lHpMysK49h77AwTn9MNvCAQBfO9YHDvxUqfSWz2+SFfsa48nxIPcA+r6JYq3?=
 =?us-ascii?Q?PEOXut3g7wORopUF42+ZjRC2oPDqxLXaHSTa0jRTX14nFUHDoHucrcgIFypI?=
 =?us-ascii?Q?6Y3NgwDH423cAqQP5jBPuL6lJQVjuSv4I6Ny/1fx?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aab47160-e73f-4e50-de81-08dc1dabc185
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2024 13:44:30.3943
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KYYOP/Jv9Cr4J0NkbT/J1nGLh+8ex9juxyGHS7TpHEO3oRZOWJMm6phl4IIHNxZ1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6304

On Thu, Jan 25, 2024 at 07:33:45PM +0800, Baolu Lu wrote:
> > check. Is the drop intended? and if so, should we just get rid of
> > IOMMU_PAGE_RESP_PASID_VALID?
> 
> In my opinion, we should keep this hardware detail in the individual
> driver. When the page fault handling framework in IOMMU and IOMMUFD
> subsystems includes a valid PASID in the fault message, the response
> message should also contain the *same* PASID value. Individual drivers
> should be responsible for deciding whether to include the PASID in the
> messages they provide for the hardware.

+1

Jason

