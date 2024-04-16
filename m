Return-Path: <kvm+bounces-14812-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CC4238A729B
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 19:48:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3F7BD1F21D0D
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 17:48:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D81EFC1F;
	Tue, 16 Apr 2024 17:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RfA5WGED"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2072.outbound.protection.outlook.com [40.107.94.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 477981327ED
	for <kvm@vger.kernel.org>; Tue, 16 Apr 2024 17:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.72
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713289677; cv=fail; b=c+PyKV0dQzQSJwcQPWVSMbXGuOS2A8aB3p2aMbguDwaipRzbhaoJiP6rfHYctx6JVlTCSCID30mhdVP5/r7qGvgPBYuJ4F77gB1NSjoSeEeH0nziuxIav+9ThlbYIEXoRuoydd0bJSBPynTNvD3b1VV9wRf5YyJL9W1H7fkcF80=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713289677; c=relaxed/simple;
	bh=/7DwJEKRilHYMOdf52Zp7/fp+PHe2kNCgTT7CYDRTE8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qW5w44c6Z6mOBAN8VBXfTIeVCxeoyyb9liC2Mw2QNb/lAxlO5dKh6DtcVu5cQ+tWnEsIPsloFoD87OOl3Ea86hofmQelGSxckvWZNtLWqhSXTuWZK1VCYe+FiNrdxhSC/FaS4SYR8ESsQJUERabMILdnIeVHO3rTLQJk+bCIp3M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RfA5WGED; arc=fail smtp.client-ip=40.107.94.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eveQySUH6He+K1hTDcOaufA8JmuDBUyi6ctAKzSvuYOIEr7K9YX26gvdVBAt4fmISZOrbe+che7XLh+rAZsMGWvMl1PwuH9I9IQXhaep9Fm0Fgdk4ucYSITdDwlfDOPoFRpm4HGiYdD+41zMut+AbtxvBxmG/aMHaeJ0rdE/oglxACD7bjPZRXBcxJ1r3LLN39l59tGXaIUXyS4fcO3h49Idn8cUCH3fnqItVA0oNiZGrxW/xPTJ5eCq7/jwC6zrxQ6e7dGhUOumssN8xSapOFOvUVwnScoaVpBGVuEl7brXqR0Mpf+xY5FfPb+hI+HSpuL/xNA3UG1obp8ZoNoCJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4taOvI/AJGReaUXVfplniaWQb8KHADJ5Ll0y8YKz1eQ=;
 b=EBBXE9b14Zld5BVG+rH+a3Rs67rauPvkjR2B0Hm0EUFX0BuJBAxeXSTX64TWIOx4pVX7t/kz6U9x9W+54BKU/siekLq9ixTki+xy82ZcX0VUVTGkjVnptpzv5raPv1HlHwziAqVzW0bFNnTJWHq8/0uqrcgPbZQeNaLKUCYhrNjAFAFB+NrCBqE0KUQ31LwTcnMdaMQElAzQXvGlsiz5/q7T43uBbYUpwOb8LAhpvzKtn3IdUxu5NEvV/JvYA6bA42hFKwIuvqg1YE9lnAuwHNoNXWePua6ox/+mrMFeXGwj0kwPAkEQMPkzfV2SOCVaW7wuA8E5I/lNTr6JNMlQeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4taOvI/AJGReaUXVfplniaWQb8KHADJ5Ll0y8YKz1eQ=;
 b=RfA5WGED+fStsgdLqdkEDPSVow4SsEMzwwfeRfDiSaSVG5hwnpQ4k+oB6eVVJK84x6H7QCjiBJuEr7UPArE578yA97CqLbI2rGRIL7gZbHzAJbxuFnS28gzczctP+f2DlCf4FOZfunz79FmAYKfH2HLBseTLipZ+TiZ0qJ8FJjHZmxi0nuH9FTijtdjTydZozAaKMk8v+xJb9eZGTKThjspkvLdHL3B84mkyfYE7uOtjD0EDZmrP6J1l7YBNTpGVZuBsObLRwRQTUV/4NwWQEX3fa9fA9mtvmImh+vK+MryZU7yP1BwujlxciPUhJnYDeA8Y7gd8JpzCbwBIa9inUw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SJ1PR12MB6313.namprd12.prod.outlook.com (2603:10b6:a03:458::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Tue, 16 Apr
 2024 17:47:51 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7452.049; Tue, 16 Apr 2024
 17:47:51 +0000
Date: Tue, 16 Apr 2024 14:47:49 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Baolu Lu <baolu.lu@linux.intel.com>
Cc: Yi Liu <yi.l.liu@intel.com>, joro@8bytes.org, kevin.tian@intel.com,
	alex.williamson@redhat.com, robin.murphy@arm.com,
	eric.auger@redhat.com, nicolinc@nvidia.com, kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
	zhenzhong.duan@intel.com, jacob.jun.pan@intel.com
Subject: Re: [PATCH v2 01/12] iommu: Pass old domain to set_dev_pasid op
Message-ID: <20240416174749.GI3637727@nvidia.com>
References: <20240412081516.31168-1-yi.l.liu@intel.com>
 <20240412081516.31168-2-yi.l.liu@intel.com>
 <3cfb2bb1-3d66-450d-b561-f8f0939645ba@linux.intel.com>
 <20240415115442.GA3637727@nvidia.com>
 <4f570287-cd11-4c89-9dd2-9bb106e343c1@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f570287-cd11-4c89-9dd2-9bb106e343c1@linux.intel.com>
X-ClientProxiedBy: SN6PR05CA0005.namprd05.prod.outlook.com
 (2603:10b6:805:de::18) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SJ1PR12MB6313:EE_
X-MS-Office365-Filtering-Correlation-Id: 99ed6252-247f-4669-b08e-08dc5e3d5664
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	iO77u/Pd0gTN4vTcliFv2LDO3PbkpBiClyLSDTmKXLCzE02KHX1LhACAUa4kkqXBHMaMejrRbtQWsqwMxZb2N0ZSzcYqnnOuZKLfv7ld4woaGZtg0hlOeayNs5LETRTr2NkqkHv1YwG+HoE15uswh6AWKrhybhmRFaOs2lo9ws8hCeRFs8NYgsv/yodmv4Rct8F57OYJhRvtpPU8RQEnftD4KROUuQuRSubV914VRHc1nJlRBytNHbcYvthXHwc0okziiHpZBzpLlQSj2uz/fK3iDTAca/IZlNrmT1el6SFiYMp8Ot47FzX2fkbTeLZ4dwd66XT9+u2Rof7sx2JXrENQNhryGvXFf58hYOAPXNYJE5L64PLwKlBJx0atQS/zFfjBaV2w+6nWUNEYtWo5eN4/66kdgQ/atCxEwaJSd27KQXukjXN1XwG+8D9eihEh8Uw5og+5cq/GwGzKLRdnZlZtCYqRmD/jFx+ZCzTaKM+3cvqIka5ryo1j5RO0l2fGWiZkpNSS16TZb0M2MJ7/8Xvivdje20VgevsfNRpjgYOINdWnqPTWlu/b2liCpf282UcYUswNDowbnO0NIEOi4OuhyG9zfXoLpWI4g3aWtVljUxDLozVlh690pHz2qp2JhO9567AddY0MmBz4wrbg+SmctxhlMuTmm4/zTGOh6n0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(376005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lOu/TItbHSayPUOgorz0f7pzRIGo20uRzpDvgVkbPi6u+9d7j7ZeWLRgsYiP?=
 =?us-ascii?Q?Zi53vQVkscXDs/0R8uqdSoxTVgIWr/wvjZG4uziG87EAUlj+zlEyUCx6cLue?=
 =?us-ascii?Q?H12cpvEDiYUZcTSKtKKWiWlJN10QjlSLTpb/tm33Tv6mqbmw8S05bsZju1Kq?=
 =?us-ascii?Q?nLMEUzLuiFOlvacrWZCDtPm/jZbNNXbGoez8Ai5bWExrS8my7toM+bMtYfMh?=
 =?us-ascii?Q?4kOrF82GBbycpboeJVWvE9+qeKt1INKNTU2hDGVvs4voA54epg8cjY48hU4K?=
 =?us-ascii?Q?HMrIUri9f1hpIk54dMC/3xnh1+TCSFKBeYuJgyMB3mNwGjkzkn8r8ZeL1rHu?=
 =?us-ascii?Q?Z7tI5RUQd4JQt7EVN9HXsW0gfXhD20bhCiRcLMScA1N3n5WGDgMtqGlfZ8b1?=
 =?us-ascii?Q?XEriskqZjx/bAozgUyLrBHyecLHwugBSFziYs/5M8ZW7T9+36GVordymAai8?=
 =?us-ascii?Q?th9e7q86bwJ0Eyvv4kpy6tiEvzSZNABL6UD/uvEEz+RWhtahX6m9318RVQGZ?=
 =?us-ascii?Q?OD5KmypDdEBC9i7x/upMEJsWvVYZOoevG6jkq+IjhnvsdiIRFoM61++KLJ3T?=
 =?us-ascii?Q?MjSEFk+/nG6vSNvIqWnU3xNnuDhYvv211yTJbu6RGl/x3i+DYoIJhLUvUuDA?=
 =?us-ascii?Q?Q19D0rwco98KiEHfEBpuXGtt53+8LMB7WDXaaP56biYC7EgDaKEUmlmPAP5i?=
 =?us-ascii?Q?HRMo4KqhLTSfxlD+kBuL750xPWjc6t69AWikXc+mJr/WHYf4qv84rra4ir8i?=
 =?us-ascii?Q?JQxzC1kBGWDQuFXPbVdc0FDXJZX/262EX4WF6UqJ0aYzRKg/uXmMwrngQh3K?=
 =?us-ascii?Q?lOnCJz/q8pm9JokPBZk5W2lPfkA4XdZ2tRSmc4CR6eH8Z44bGHAWH6UInVd+?=
 =?us-ascii?Q?gZF2MgQqfpC6WgEDthTRgy5eNDEJ0z9q2485ligR6d1NbPdDUdLm01Q5JOCI?=
 =?us-ascii?Q?N7BLZkBml27FlCqSHVr2RkKReoMCyF34Nc5Ho4+CsDK8zlEsjPv3+HDI8phX?=
 =?us-ascii?Q?Kddnjz1VGLlNprMwEA0Xq/ZoaEfKX9KoZ5AnnUvzjXatJ0jYHczjrAcbMvBZ?=
 =?us-ascii?Q?nbMkIhrCEJf78e3fJlmrZec8whSe0Ppc8cZ/oMqIc0yZQq/4b4C/Qb1D72h8?=
 =?us-ascii?Q?QmVTihOIcX6aoGbbeGKjlBc5pG4p69f8MWNmcMjFl39o4KN+e1UtpOUgPyOf?=
 =?us-ascii?Q?IolGvmGnVo0a5ajM68TZqFVYECLmKHnLV/k+nkbAR+TC3q8ydUwnjykKm2Cg?=
 =?us-ascii?Q?nbDcaJOadAzSADt1sAWAQMCnnx8hYz96ljWU/TC0+bV3XHBnnOp0kdDq8aF+?=
 =?us-ascii?Q?hw3990UWnzlBm1vlaMnJuH/RuFwHdJ/sNLQOqLmVwiEFBJN0mFEjzEZ0q++J?=
 =?us-ascii?Q?s9p4c6Me3dB0V5gPGTQ7lJ0klJKGe99pcvt62PZJM+ud71OBgd7/pJKKi9bX?=
 =?us-ascii?Q?UYI26TqqNjvLz/cZWAZbmESkQBgBdUMUcTAxblFCEbtXCDBt7fww7L5mOTdx?=
 =?us-ascii?Q?kS6FGJk5xKWgm9i/ULMrSd3gyzN6xzQLTe6mrwnklisyFouCOOUkORlfQJoK?=
 =?us-ascii?Q?b+zRX184GW2sBJxcIIg=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99ed6252-247f-4669-b08e-08dc5e3d5664
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2024 17:47:51.6820
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 93aSO3rFjWF8ec7KfsTI3mitquP2S6oKwPWJYVmQD0ldCl/EeyyszyhFpoUvC1YE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6313

On Tue, Apr 16, 2024 at 10:07:49AM +0800, Baolu Lu wrote:
> On 4/15/24 7:54 PM, Jason Gunthorpe wrote:
> > On Mon, Apr 15, 2024 at 01:32:03PM +0800, Baolu Lu wrote:
> > > On 4/12/24 4:15 PM, Yi Liu wrote:
> > > > diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> > > > index 40dd439307e8..1e5e9249c93f 100644
> > > > --- a/include/linux/iommu.h
> > > > +++ b/include/linux/iommu.h
> > > > @@ -631,7 +631,7 @@ struct iommu_ops {
> > > >    struct iommu_domain_ops {
> > > >    	int (*attach_dev)(struct iommu_domain *domain, struct device *dev);
> > > >    	int (*set_dev_pasid)(struct iommu_domain *domain, struct device *dev,
> > > > -			     ioasid_t pasid);
> > > > +			     ioasid_t pasid, struct iommu_domain *old);
> > > Is it possible to add another op to replace a domain for pasid? For
> > > example,
> > > 
> > > 	int (*replace_dev_pasid)(domain, dev, pasid, old_domain)
> > We haven't needed that in the normal case, what would motivate it
> > here?
> 
> My understanding of the difference between set_dev_pasid and
> replace_dev_pasid is that the former assumes that there is no domain
> attached to the pasid yet, so it sets the passed domain to it. For the
> latter, it simply replaces the existing domain with a new one.
> 
> The set_dev_pasid doesn't need an old domain because it's assumed that
> the existing domain is NULL. The replace_dev_pasid could have an
> existing domain as its input.

I would just pass in the NULL domain for set than make another
op. iommu drivers should be exactly the same implementation for both

> Replace also implies an atomic switch between different domains. This
> makes it subtly different from a set operation.

Well, not necessarily hitless, but at least old/new/blocked - not
something corrupt.

Jason

