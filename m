Return-Path: <kvm+bounces-14959-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E63A8A8306
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 14:21:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C7A4B1F22473
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 12:21:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A72513D295;
	Wed, 17 Apr 2024 12:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="c8GosfF9"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2078.outbound.protection.outlook.com [40.107.223.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00AA29CEB
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 12:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713356457; cv=fail; b=KsJ8H0r4QfpQ1/tLyudwBFx9XTKAEz//Xp0GhAAmkP5jSmbJE6TBjqLC7YRltaPBMnAuCosGrsk3X9HUJK4vB593CjWfuZAiU5xwwrhwxCLbqi1rUBP4sq7yViBN1CI7ge8QAhk9yOtbogbSva6fFEhRUedJjjttnuQ80GDT5w8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713356457; c=relaxed/simple;
	bh=0PD8ZEK6FfOEbfwxjlAhbYt3oKdz+kV6xneDA2Jg/E8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=HooRP1FTxytQ1cvgAgBb6NTCJBQXmisHYp3FpxvXl4WtMtrnhV2tsjen1gJMJh9Htmshh+E1e4hAR4z78mo0rtwkW4L9Ac9Ug3tMHNVp8b/2WWa3tPgZoAc1uAim6Q5IckjUQP0vtm8vq9grcnKIMW24xPYxiY69Ad4vXB+SXE0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=c8GosfF9; arc=fail smtp.client-ip=40.107.223.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b2ou/pnHq0Cnx/78eDXasIkTebeP5kJ85xtYXDAR+TDj6d/Hpq2BWYrJnX0zY227dlnmwcqCyj6HBN1/GDiJO8dZPTQkXUcEasiN60tFyRghx+uc9lq7LLVd80UjI3lM7r0VXdCoBtrC6MkhqTNznj7t6qQllEIKI++8Lm+5wNB6xuOZmqS8JZhz5BEzs7F+8bIRAVCIvJEcgpVFaNO8aClqq+z/kCX0VUa8gYuwLv+3bg6IMPtr5s/zNzvQ54ib2EbE8OVO7x15yRe2ITYwDP5u6JBc+XQZs522QbEnxtdn1fnDpiuKqMpB4zBkqkJXUMSGVFBdbkrbmHjEcsTtIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1RORpCeLyRPh5YYRNqLOL2NGA+D9eEZEkjiQsiIokxU=;
 b=JZgIAdSf51NNJijA5BJBbQeUe6PMp8mLqkeFNgL+PlKE9Oi/rLJwZzGQB+iQXXQBV1vfBfe819xUPsf1g0Tsg0tk1Q4JJDDXkNP/VMxYHjSTMQAB8K6tYI8f4q2YFgSZxLyj0cAfi6Zv6zgvZ2Q6pCpDJl85vvyGIeP/YQLqK8g0GRdxtw/oujUdX6pKidSDr7l1cR+4fJ7lvM8WYu2qH405k+ABRTnehHAL8FwgY8yQDQ2LZTweWHj5p41zT5wmtgNRVwYaVFdJ1GHVvhhew5/dHBlvm1RWNqoX2ojrvFrLzO0dkUL6kpm0+S/1BsQB70Qczo9LRVO7noMAAmrVRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1RORpCeLyRPh5YYRNqLOL2NGA+D9eEZEkjiQsiIokxU=;
 b=c8GosfF9t5GBZyIfZK4PlrWG48H+kavsTI8avyoHMfhiedYK8LBkaeIv2kg7gTcwQ896z2m5SRoxbjEFTYjPIYQZMdhltyYiy+wTyUPV5FYHoHlaSmXnCh2gL0PHTZM4IuW4U5ogaszNjwDRUpMEpUkH2AF722N896/IJYYEHSZS2j2UhbXCFdDMCmU8sv+2oKkSs41+/6SC6QpVhHDXCQbP2P0/yU6BtpW2xlF9i9i2M+ZdmcJTuVte64qCO6VBRSAya1luic832EBJsfKHOgX5NRHn7XCPnfuDSUm3StDrVyvz+bHdLTBZVVhLzCh5Eg2kluwz+QrsrL5/ePwWYg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CH3PR12MB7641.namprd12.prod.outlook.com (2603:10b6:610:150::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Wed, 17 Apr
 2024 12:20:53 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7472.037; Wed, 17 Apr 2024
 12:20:53 +0000
Date: Wed, 17 Apr 2024 09:20:51 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: "Liu, Yi L" <yi.l.liu@intel.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"joro@8bytes.org" <joro@8bytes.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>,
	"eric.auger@redhat.com" <eric.auger@redhat.com>,
	"nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
	"Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
	"Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: Re: [PATCH v2 0/4] vfio-pci support pasid attach/detach
Message-ID: <20240417122051.GN3637727@nvidia.com>
References: <20240412082121.33382-1-yi.l.liu@intel.com>
 <BN9PR11MB5276318EF2CD66BEF826F59A8C082@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240416175018.GJ3637727@nvidia.com>
 <BN9PR11MB5276E6975F78AE96F8DEC66D8C0F2@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276E6975F78AE96F8DEC66D8C0F2@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: SA9PR03CA0019.namprd03.prod.outlook.com
 (2603:10b6:806:20::24) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CH3PR12MB7641:EE_
X-MS-Office365-Filtering-Correlation-Id: a331a545-108a-45d3-2bf6-08dc5ed8d339
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	+N0khV1Vi/ohny2HrFar1WtvEj3g3SXCELqgoez9t+OtbDdmyHZNreuHRdXw3TuuOM8rgh5zsJ+3ZkghThP+qmJedrjNWovXyGH0FBmhDQrzN2XgI3Nhl8vvy1tXNUBIjfu/FLB3WaqX9pNqfnuh+9k8fbNqIp9HX78SiP5g1xBltNmy567yy2BDFwhv1YcOba/CzdCMaP1yGwYlACgmzWkYSnURFNg3IdHvZmB1ven4D5vCd070Dl+YJtyvG3cMdZUf6iuxZobjVThJpzawDWyUrYoPOyEfKev8VGj4SLkMu5IxQwcFnnn7K0+WQhUv3rsdn2ojsqzGYyNA9ZDZo9whAuGjnB97zVeCiMVlEYN0DDMKswMnvgDYLqkd0m1wiJrppp+f7yrr9Xbx5s9NA/qMc0+2VIrnp8X/ME9XHt+jUlIPM8bTiWAvp/qhSJmbWkECm667ijYfe+lGPlkaFph0lOWNg8UyENCKb6NdNyn2w6EUXFiKWzYXHBD8V3PaDh3ddzewWpAHdmrFcem131fgYThdBeRBVpwc3cGN/pCXsW693Pn7yvvtGZdukkDXL7rtLWKQsuh1n6cxT1eiR3LGoujqYE0VFHweAynXjgrqLlQQ1ATBb4mggFz17G20/PYEyHqvf6uf7/1OO6Neo6jIqhjJXqLpVG0z2Esl1ao=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?T5S6btYIdzvbgqbsiVIsDTVc2gdMafS4yQCxI71QZwnVMCiBnnGcorZY5Mqk?=
 =?us-ascii?Q?5zvbLqrLG9fCc1MV0I9Niju8hPFj+vOwiLZRrs15sUxprIEj0skmmDeLg09K?=
 =?us-ascii?Q?FR7XBeTJ0wrwX3ZWQbE7IA9SyOB3n6WsujO8qtQ3Uwljl2PNCoGV52N8NJJq?=
 =?us-ascii?Q?Dh/lA0mce4/Qapl0LK7sPZxo8yzM/zcrbso2f8dp+Yx1Pclsbe3nvUzyZaT7?=
 =?us-ascii?Q?6TpnyLslkAoOe2fbbnds2NoDh/0PNrMj8HDD1+6tuezB3NOxs559XxFgIdUL?=
 =?us-ascii?Q?9PeHVqNY1vC4IAC7RvVgYrmgbn7hkEtCDp/pSY+RrOrDoGPBBWvRER+FS+8v?=
 =?us-ascii?Q?5xYV0WVlb52LwaiPIBIeThIcqlroYmEaLsdiP9+FbF9aAMaz7tmggfSKD8Xq?=
 =?us-ascii?Q?zAxUhcD1pA4YbjGOflSJKk39NB/+hB4FsI4kCO44Vk3VnOhuMBMMjxLnU/KC?=
 =?us-ascii?Q?vSJghmPm4xviFkqGqc0aMT5sxjoDxU6iJ8wmiD8bzaR1iAd7Q27eY8aNwRSv?=
 =?us-ascii?Q?YSeD0du44Ux7iuSFoyhJmmBhHpE/hzRcaEEyDg04Ap69xpXtZxsHCrtMWFES?=
 =?us-ascii?Q?ggNgj0yUSGr/zk60aVTfnsmAde6wDlZ+6SQCjpYnxij1sNQ1RJIFAj2bQhB/?=
 =?us-ascii?Q?2HRM3TolLZ6m7mFGLUgIrj2Y+EDj6kzAiyiACXKZsTxDhIpN0A1tjIgA0GEh?=
 =?us-ascii?Q?gpum0rF0Tysv2UjICqQvJlDUd6Pc84rDpzVeeyeeubMDy2HufPCOM6MoGXj6?=
 =?us-ascii?Q?Dfv75sCXhftkgl989rcz1gQ4Tc1ATcRFYr5+IPmawGKe/KmcdCyCKg6Jw45L?=
 =?us-ascii?Q?YUf2lVXAd1A8DC+bmMjVS6NnjVxCLvrfElFoq2v8sfed+T1FvSVQiswTAtH4?=
 =?us-ascii?Q?hv4iSk69rYoQjAf3lqJbc4u2DZLrMwA1dwJoKSMeaNt3CGQBnBFf9uKLoUhl?=
 =?us-ascii?Q?H5TpoVrYxTStEOsog2OSjenC9U1xLQHRw4WgId7MGUuQUfAKeerT0wJmwbWR?=
 =?us-ascii?Q?7A3BYHzaV/mqntP5pO9rWch9yOEc8+C7++IOtp/76GjBNHVX8ZSbR+ycTSDJ?=
 =?us-ascii?Q?hzk5B4iAhwwcueWhIm+6Sgx5Zig7S2K4eS7ixSekDv4mBP8DeypNPuKh3giz?=
 =?us-ascii?Q?bWNCrlOW/wGJnI/KNuzZHhCvy/vkuISZ6ndN60oDlDsi0rax4Q5tcXyukElb?=
 =?us-ascii?Q?IYhfo8eg7k+MiUIHZockuKCIko3Ju+50Zo4tA/1U7MxHMplljeXZA1on4kE3?=
 =?us-ascii?Q?MlKTY37g7mfqyBFiM9a/fh0zdEb2BTg+wBg1ZFXb16l4HxRYQER+OGbwML4t?=
 =?us-ascii?Q?Ne1niIkRPEx9fkml4WHSjYHKPPKBA95+kWOXDx24O2uzmQ98Ad8hJQUwNPh+?=
 =?us-ascii?Q?TKu4KLcGpFzmadLNBzbF5RGxd4/0OiLbyqnJgJ8TAm5fTGXjvLc0AwDOccso?=
 =?us-ascii?Q?DjcIFSeFMbi1nlKS6EnOeAMYs8GA4XXnzKNgkQF2EgzebqBZ7XAARA+/dwPF?=
 =?us-ascii?Q?9m38casXwXIiu6OZtOZHfJTlsthKqAN0gELQx32TVpziv0JB2Ua9BFnHs1pj?=
 =?us-ascii?Q?FNL+lw8NgUeIlzxYu52GhO7BdqmPcdo7hq/JYuqU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a331a545-108a-45d3-2bf6-08dc5ed8d339
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2024 12:20:53.0591
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OGQQG46KYLN23WIj8ZyEr9wQP2a17kcCJwlwyyo8nmywQFvWL46LD4TUvvqYrIS1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB7641

On Wed, Apr 17, 2024 at 07:16:05AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, April 17, 2024 1:50 AM
> > 
> > On Tue, Apr 16, 2024 at 08:38:50AM +0000, Tian, Kevin wrote:
> > > > From: Liu, Yi L <yi.l.liu@intel.com>
> > > > Sent: Friday, April 12, 2024 4:21 PM
> > > >
> > > > A userspace VMM is supposed to get the details of the device's PASID
> > > > capability
> > > > and assemble a virtual PASID capability in a proper offset in the virtual
> > PCI
> > > > configuration space. While it is still an open on how to get the available
> > > > offsets. Devices may have hidden bits that are not in the PCI cap chain.
> > For
> > > > now, there are two options to get the available offsets.[2]
> > > >
> > > > - Report the available offsets via ioctl. This requires device-specific logic
> > > >   to provide available offsets. e.g., vfio-pci variant driver. Or may the
> > device
> > > >   provide the available offset by DVSEC.
> > > > - Store the available offsets in a static table in userspace VMM. VMM gets
> > the
> > > >   empty offsets from this table.
> > > >
> > >
> > > I'm not a fan of requesting a variant driver for every PASID-capable
> > > VF just for the purpose of reporting a free range in the PCI config space.
> > >
> > > It's easier to do that quirk in userspace.
> > >
> > > But I like Alex's original comment that at least for PF there is no reason
> > > to hide the offset. there could be a flag+field to communicate it. or
> > > if there will be a new variant VF driver for other purposes e.g. migration
> > > it can certainly fill the field too.
> > 
> > Yes, since this has been such a sticking point can we get a clean
> > series that just enables it for PF and then come with a solution for
> > VF?
> > 
> 
> sure but we at least need to reach consensus on a minimal required
> uapi covering both PF/VF to move forward so the user doesn't need
> to touch different contracts for PF vs. VF.

Do we? The situation where the VMM needs to wholly make a up a PASID
capability seems completely new and seperate from just using an
existing PASID capability as in the PF case.

If it needs to make another system call or otherwise to do that then
that seems fine to do incrementally??

Jason

