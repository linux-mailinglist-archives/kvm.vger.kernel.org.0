Return-Path: <kvm+bounces-41635-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 36DBCA6B1B2
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 00:41:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B36788A4288
	for <lists+kvm@lfdr.de>; Thu, 20 Mar 2025 23:40:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AECD721D3DD;
	Thu, 20 Mar 2025 23:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="J46txKu2"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2078.outbound.protection.outlook.com [40.107.94.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6754215770
	for <kvm@vger.kernel.org>; Thu, 20 Mar 2025 23:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742514065; cv=fail; b=R6Wr0gt/R8zkcn2AUpSCt7y06HyAzxgOWy5hM/+0ixJSqT7lqGbzIa8PpwEpKs4mVkGtec8LCaczpGXfeuFVAelCZ/M8NTLpsG1nR01TSDLQ/f4Ij8ebAZKddw4Yu/kHoGXTtFoVJ/I7KeHfqZb2OnPO1GCcYtFuvmEnJkJh64I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742514065; c=relaxed/simple;
	bh=dNNOKkSjBXjjGjpq48Z1JetLE31Qpz174qzhBdRTmQk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gkotXfENOfNzIBTIcvu7L3GTo3sT/sE+vRvWAty/c3Gddhlavj5GlHHpM/LAgGIKbPH5n7/nWjaJBJZk4twkplAN2fV/VA6fptSR6TLJRLfAhGZah2DzcrdQ/ouVbHoYeCNVWbM5x4N/NZfwt4Ky+gJaKzg1wtju1UXhkqGW41U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=J46txKu2; arc=fail smtp.client-ip=40.107.94.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ZlYCJi67XmU/9XHa+O2zpDmdr/DmeNzTlxiIMuJ5ncv9elhXFMJBXRu9xyFgFr8ykBhR1W0FUvo/ZJ4kc27jVspROthlPXHtxlMj56A5q6oJN5njD4MnC3fTs16yh2o/mwXdPuwr/0T2T1mAFp12wNXavmkwQRGCH3hQTP30lTV8ATidikkvaCfcODYIG2OA+CvMyN+pUY/bph4W1Ow5JUIkvt2h8NnHrCHqSqKmM9Bmjb0ptmuybYU26kgwxa88CaDLh4JBompNYBCAZmvbCGAEmDIK80D8m1H+2RFbTzMvP6PV7ogNeJLaWJEnAR+OxBiBAVkEJGmuzijLmIwOpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9zjkoov3W7cZtZcgLhn+f5sYhDCclA/flbKwfQNyebA=;
 b=e+cDGdV9rKAg+PkhYhCJztayKuSl3BXeHP3IgXXehD+5/hlGjkn6TEoIl85Job9URKDVTOKTDY+STpNPQJYd20lQclv51NNISmbGCJc17lIdtYl4jS0RuoSKQtEx+M+P1fF6W8Y418pTwvtXstjRx9mvGyRVvHjL7mNFLv2eIi5b88rlWYOJOi8IxmyD44FN0P3qGbqLy9bI4WFwkf32c8UDa6K00wX3uv3dZoqfjn2yWrgpvcYK2dzNj5k9pOXqiAIT0tF1Q6ANoRwI0PrA8deGvGkcKpPUEewSvs+RD3D3lWOcUFrAZwErbvfQYEx13cXddp5OzYRDGrCGOTGBHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9zjkoov3W7cZtZcgLhn+f5sYhDCclA/flbKwfQNyebA=;
 b=J46txKu2+9DFWrL40vHuirEXOSXZXOgiYiEpmJ4zxkOReBMLkyC6Mrgnh7IzCbnCKL9osiKLo5oevlgvb0+3gplL9gsv8Kfs7p8/E7RU/ljqLoZG7kPYHGmJYRu5g3UdJlPnzEPVBjHMX6VOnWbc5RHt5cNimQD4L1ZmCDOq11VXA/4ZL1KbzXTTklhRWo4ITeEC7GIBsbIdvqTHNBJxBYk7zCXaaJYGYwY57GRlNRgA3aa5pwO0AIgb4O5I7H14bSFjnEvjvjdIRCffu+hffqrLithYh4IFGjeDPO1XeiNGvLOdIoFcQxCyHTLtj/l9Mn3MvuNf4r/yc6ZkItJuDw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH7PR12MB6761.namprd12.prod.outlook.com (2603:10b6:510:1ab::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.34; Thu, 20 Mar
 2025 23:40:58 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8534.036; Thu, 20 Mar 2025
 23:40:58 +0000
Date: Thu, 20 Mar 2025 20:40:57 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: Yi Liu <yi.l.liu@intel.com>, alex.williamson@redhat.com,
	kevin.tian@intel.com, eric.auger@redhat.com, kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com, zhenzhong.duan@intel.com,
	willy@infradead.org, zhangfei.gao@linaro.org, vasant.hegde@amd.com
Subject: Re: [PATCH v8 4/5] iommufd: Extend IOMMU_GET_HW_INFO to report PASID
 capability
Message-ID: <20250320234057.GS206770@nvidia.com>
References: <20250313124753.185090-1-yi.l.liu@intel.com>
 <20250313124753.185090-5-yi.l.liu@intel.com>
 <Z9sFteIJ70PicRHB@Asurada-Nvidia>
 <444284f3-2dae-4aa9-a897-78a36e1be3ca@intel.com>
 <Z9xGpLRE8wPHlUAV@Asurada-Nvidia>
 <20250320185726.GF206770@nvidia.com>
 <Z9x0AFJkrfWMGLsV@Asurada-Nvidia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z9x0AFJkrfWMGLsV@Asurada-Nvidia>
X-ClientProxiedBy: MN0PR05CA0019.namprd05.prod.outlook.com
 (2603:10b6:208:52c::26) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH7PR12MB6761:EE_
X-MS-Office365-Filtering-Correlation-Id: a90a9593-d9ef-4cfd-004c-08dd6808aa7d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fbNVPBBXlcMwrRMcK/1R6zM/2Y2b/k050t5QewVFuvfcm0k/Cyw9NN8hCXnP?=
 =?us-ascii?Q?Bj9Mg3RHAW0SOtaSlUHkRmq+LKIcylWPsAMe2NgH8F308zy0AwgOhFgi4ok0?=
 =?us-ascii?Q?VSE5H/v4ZqC0fR57KG+PRXhsYFWKlzLkA7AzW5dXuDYxZf0y2HUOBdwT243c?=
 =?us-ascii?Q?p2JyGSnk2c3x/DztA1u3SRZ0czGPhvMdXCLVncUhrIXUTYoDDN3kxp/Q3yY1?=
 =?us-ascii?Q?o9KLXdrqYDjye15HvNdhl1cVTTSVSBv35l6M791/wDReB18ew/iWQo7aOPey?=
 =?us-ascii?Q?LeRd3dNkjZxq6zdhedr+PK7YoFfhiYlbU9yQFyEG+r3UvXG0EWGlpyQ4WrOm?=
 =?us-ascii?Q?4ytoijVqqXHvcgnxzEkjGekUsGH3TZ9fjr5H0bVih+d9c+1vI4X910o+JaSz?=
 =?us-ascii?Q?9BPXbY2B+Rq1xJD+ilwKSk8kbmDyfRVsdUmaK7WMiF6QmtXfVRDjsOkCRtjC?=
 =?us-ascii?Q?07UUflY6DTo/Mdi56pNgS4v5ZI2Ib7H0LD367yjIqBK6XaSAFqC9Goe1Rkds?=
 =?us-ascii?Q?Il9R/0izHZzOAFijo7vvrcxZD1AEztmT4vYiGnfAnzQey37EZGLr7eY0kg7f?=
 =?us-ascii?Q?oV6ElbvoMylWMEfwil7tS1060Ols4/7lqxuYxe9HYFDUBwOPY5Fz1neMY4e/?=
 =?us-ascii?Q?yASwgHHY8XCKEbcqdFCOJ2D19SdSwCD0hUKQkrXb2WgLdW62MTIdNP32DjuZ?=
 =?us-ascii?Q?seEIt9mlbo7lZ7RRDkW/xxZGXHLn0K6zV/LhvFAf8ihKnpV8ZGg+VLjl6tSn?=
 =?us-ascii?Q?9Ysqgpxdpz54rQi0pSsGWVIXQ39veB3c8dBLZ+vDqAKMvMYqp9VOIas/Dep7?=
 =?us-ascii?Q?UOnfBInJQ+IixDeU7t272NcgH7EabH8vwa4Fxq/QAX727l/8uuJtTqn5WeND?=
 =?us-ascii?Q?Q9yNaAFC5Z7i9get9vgO5v4t59OU6no/azA1zingF8IuqUGYKbsIUqDhL6j+?=
 =?us-ascii?Q?oh5NBbOjA+oQcbqyMZjo3KcQqCxZx7Wu3bPAuuLa0uTe9f35ftkKwbgtvPN2?=
 =?us-ascii?Q?eAQxyWlY0IazEE079XAva1EDWNsTSVpy+3v6f9pFFGfSOfzQ9RzZtQer1f3K?=
 =?us-ascii?Q?u2CrteR+axhGHxWmp283Q3baB/GplWFWz+gFF1sEd1wgzpC5jyHq987EGnXA?=
 =?us-ascii?Q?UR+kuwlTQ7Qn79SULyn77lNr5M0nDJmtWhrgMr/GJsl63yXT5BE5279rEhuZ?=
 =?us-ascii?Q?9xla5R4PskVLRg9BMObi3YeT2GOTmOgtr6qmyQGOZsjSDsCr+cmToxdOLYy6?=
 =?us-ascii?Q?flsLcQe5vGJGaCm1H+tk4Y21WzgmqSy9qg37iDlju7CXW4S5CmWoPrsgdVKT?=
 =?us-ascii?Q?lvEbQd0rlLYMXnBMkXL9LKEKoPWTu8Q+ylhYbVcschv5lKyGn1PzGPm9lQEH?=
 =?us-ascii?Q?HZyrU9r/gheBT5V78rtP4XSfLSnw?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?M54edRtbzveCbgQGAA/kRbvkB0VV48idd4Ik2LNWbDIkO7EYeJRoyS1CbBRY?=
 =?us-ascii?Q?u8gwziV0qj1ZmUQCJnpLeTRHiFTSMn0HOxZuNcuEorzzJwumyotraBnr94ut?=
 =?us-ascii?Q?Us2m+wqJ+i+6UdjU4nAMmpMX7BMO3VjtOsyYSEgH6q7+w+CxtXj1LzoehmKj?=
 =?us-ascii?Q?qxRMkdrxdOcmYLKdNeBHKO9+t0/YaomXVDlZGAmyeZHRRr7I9ouLcHRuZSTW?=
 =?us-ascii?Q?q2OVv9nfExibX9oEfcchIpb3aPRWgbJWnlJ4Jbs5dfbq7RxOAqQ3ruJGNHYi?=
 =?us-ascii?Q?U1rd51HtWV8z2+04XgcqpYytge3jORijG7zKU9bKxP7LYuJxQz5A8zIIyQAC?=
 =?us-ascii?Q?eLC8Yl2RkG64CJKUfadp59373p3SKzK75jbhIiaGfLCZvJ13Nc4QIpUWuCxS?=
 =?us-ascii?Q?mBR+BjA/gmZgGM6IX6aStvciUOGpo/sLV8hMsi36erMHIsws3WnHPgj+41zh?=
 =?us-ascii?Q?394/+kSZkigou6kwSyJtTITUKWQmt2WUmPPnyiH07fwKuHxGpRr70UC+6LG+?=
 =?us-ascii?Q?85GyH3tyD4yijjHt8jWeFiOL3BzPYsX//o2AczxMs8Z83qGXa8Yuz2S/sSJ6?=
 =?us-ascii?Q?XsUmOIDBZK/DNFxMSYT/suIMzpSIbKRdeND43zogNbvodft46iGj/HKZWxqq?=
 =?us-ascii?Q?+59JaFzbK4Gy3HI+00mwQPronQ5ExGkCluhw+Co+R1hJCBe4fkD8u4aFT+b6?=
 =?us-ascii?Q?8M4q3ZqsPvKm2C2UbmxqqS5uVdXoa+v3He2EYZSJ4KPNC8OsQhYWzxZHL1hy?=
 =?us-ascii?Q?pFL4CWTThRriJxrZZlJY+1l2gKRzlEOyDhF8+U+QHc7EP9sWEEyQUJIUcnUE?=
 =?us-ascii?Q?LV6v1+pjKGqS1AhyhY7p7VrVXzzMgCN4kxPFknvylpi5bW5ULNGbsLQIE5bP?=
 =?us-ascii?Q?6l9fgDjCk0CVvnwJXzQOkHqWjDye+u9P9e5Nd0mnq8Wb3PvaFa3IT2ACtiuM?=
 =?us-ascii?Q?YAa1BWZngC5RiikzjcsyuCoIe2OOWyKQ8mM/b3WDv+KXeBpNBy14OCQuR5jn?=
 =?us-ascii?Q?3eH0QO7I9u7TcNxRiEDpTDPHJubEdroP6WQW5Q39WRWYdykYWbYWswpe9z+n?=
 =?us-ascii?Q?CLEmMUzTxkVL7yV3L9ECVsn2MsVF8KQ7CrsXdbLuaTCqHX2KLgYhiqcxojzc?=
 =?us-ascii?Q?et98yfnwo0mEs0LiDyVm+Uzw8/qs7PAejH8FrPhb5mSHFeEH3oUX3zan/SyX?=
 =?us-ascii?Q?7ckkmzlu6L8Bl8ZvrCfUQkZ2EGCI3cwl5x/FTY5g2NS5zcaf976mcwA3eIc/?=
 =?us-ascii?Q?FZBdTryUhMt2YJiZMz/Str+y7sCJS2uYLxJU/G8qMfcooq694sNFaO7Ag9ev?=
 =?us-ascii?Q?1jpD8KNSqBYALLCNMLj9sQQgTlC7LSPuaqyOTjCF3QXS4zsxqGGi6sqdhGPq?=
 =?us-ascii?Q?62ghEWPqZ5GDeI6jWnna+yaPkYPdLQ+Ole0/Pa3EBfoS7MviSBbh+Xg2DhAg?=
 =?us-ascii?Q?6JMrI8tS0JLbVJMEvKSO5/P7+S1OagdaSXrMVdeiGKdKmEgCsAPWBYoGAcNP?=
 =?us-ascii?Q?2wtnUiqUH10scoo9PjC6JD30bRbg8WCT2fjxoyK1F3bOEfmNFxnjOi3Ry9Nt?=
 =?us-ascii?Q?ZBIB3NjNtZWByGulDEb0fGT2lbs8eundhqxY1jvm?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a90a9593-d9ef-4cfd-004c-08dd6808aa7d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2025 23:40:58.7145
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2N9ZvX6BcFRdvrRBEAiuqfvmYSFEoPNR7pdRCMxf9p3CQ41C70wOBjmNmfqch07/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6761

On Thu, Mar 20, 2025 at 01:02:54PM -0700, Nicolin Chen wrote:
> On Thu, Mar 20, 2025 at 03:57:26PM -0300, Jason Gunthorpe wrote:
> > On Thu, Mar 20, 2025 at 09:47:32AM -0700, Nicolin Chen wrote:
> > 
> > > In that regard, honestly, I don't quite get this out_capabilities.
> > 
> > Yeah, I think it is best thought of as place to put discoverability if
> > people want discoverability.
> > 
> > I have had a wait and see feeling in this area since I don't know what
> > qemu or libvirt would actually use.
> 
> Both ARM and Intel have max_pasid_log2 being reported somewhere
> in their vendor data structures. So, unless user space really
> wants that info immediately without involving the vendor IOMMU,
> this max_pasid_log2 seems to be redundant.

I don't expect that PASID support should require a userspace driver
component, it should work generically. So generic userspace should
have a generic way to get the pasid range.

> Also, this patch polls two IOMMU caps out of pci_pasid_status()
> that is a per device function. Is this okay?

I think so, the hw_info is a per-device operation

> Can it end up with two devices (one has PASID; the other doesn't)
> behind the same IOMMU reporting two different sets of
> out_capabilities, which were supposed to be the same since it the
> same IOMMU HW?

Yes it can report differences, but that is OK as the iommu is not
required to be uniform across all devices? Did you mean something else?

Jason

