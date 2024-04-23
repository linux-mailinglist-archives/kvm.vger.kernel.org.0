Return-Path: <kvm+bounces-15658-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A53958AE6C2
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 14:47:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1641B284237
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 12:47:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 172A413B795;
	Tue, 23 Apr 2024 12:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bdE9s0zf"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2056.outbound.protection.outlook.com [40.107.100.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3B313AD0C
	for <kvm@vger.kernel.org>; Tue, 23 Apr 2024 12:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713876237; cv=fail; b=ckdmtTXmpqe4sbW6TeRTSEOfD6iELGunLsjGAkFaqwh4PZfNWaZliOcGj4zXwTE0jB5D72ZfKiGN7GyiQB287jkvhnHchF5McFrA+O80YeWFyPpo33UmprLqOUB1oKU6a7z/UwoXYFWqWPC23yq9WY4W94tzYzigdQlNjVYq/4g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713876237; c=relaxed/simple;
	bh=PCAjDALsxkQWmjwHfjRZK573L9HfXpSTLvooiXRTvJk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tkYb2VuNSS6deB3hxXuQu5YsfIthO+bE7B2G3Zit7tBtUjL01qvnfLankl/rblyoKvKXdMnCKvWnrJRliYokcH9UL3jOytlz8aKyfC/lh05FpUe6B/pmQVOZsHMyojEf+5OHKJm7peiSaiSVhqmWatuLtS6GplcZYOtwof9jv0A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bdE9s0zf; arc=fail smtp.client-ip=40.107.100.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bizHi21gE+soM6JyJcYqEV5DDQhh/NgOMc5LMndT8suEd59TNqeolOmdAal4RRsdDV9MtLUnj/XP+SN53egVWEFGyou0Al/Tnr9YxVfIM73fVhgR2eqtPCterbqzX3t6GpOcgkmLFSSZ9Hke535OnbCb1C3LbvSrHyNRF+Y1LslsXLAYKPd41wbhtAER8v9v/YtpEIsKBTxujckFCfh0H0ro7qCSozh1LxL6EW+e7jJ2opxtVKv/cCoXn1uTwD3AAdiOI6mbLvvk1IZiYGZN0KBX87ilYm/pwlDFNGYqRnrJcZIEMXyNvZpPL5EZ5+oscxIr+uq8Fzx62ItgVNSUHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cs1eJkxlzhGK1ssHAYy2i0wX0GBVgYoS3RWz6hmiwqI=;
 b=TAjGHr2vwCHKNq9dBkB3nIF8wUBvJMGs16qtYE5di4DW3+PL8K200fNyxIBDf3qUps9k6b2ql+3mNAqE7oWNYzeI7amcQbXU/hV14Nciro4SqfzfhpktK6A6V3Oqd2nHrPSUiYcfzDzAX6+uqDD1dZm8QHxiXQ2Mx5+VDPajT1Ej+ynOhwNTTouFynybnO+bJOD0GC+r1cHxrvWDIJerrVNYizcLoFfIDLAifbmqgW6xtmgiZAaxX6pyKOmSdm9eDj10gfU5wEYppy4fOQe/MYo3W2OFeeoCcfkVQfsfjVfEd/Y6qsnmiQai7dPamJgpCJ4lEs+SoPPjrJROhCpskw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cs1eJkxlzhGK1ssHAYy2i0wX0GBVgYoS3RWz6hmiwqI=;
 b=bdE9s0zfNDo6vwmNDdM41FJj44zNyU3S+ZzN5Ryl6AEhbWETIpel6f37YhpyQmIH2K6XEi0eN40tUNAmz9te1k1kmiXgWSwB+962n1gs1UuNbH9vGOrMfvinAd5/z0VIhaAwKdTSEKHWgPd7xRmZ/NhKviQyczYkykdGx0XU3Ms3h1er9tBl7KgBnyrWanEZ+YzLKrWe9VOSxXsj2R24Oe5BVCYaZGPYPyPO3KTUJCX+Ft7tLqHrl1eb2j4+dQ1X8d0jvZrYE6zYzoNs6golkhtQxgQhBee72mSClK5EcHErq6cSdQw8w0geYWrbZnrON7facZN1jQKtTGvkLZeKbg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by PH8PR12MB6794.namprd12.prod.outlook.com (2603:10b6:510:1c5::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Tue, 23 Apr
 2024 12:43:50 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7519.021; Tue, 23 Apr 2024
 12:43:47 +0000
Date: Tue, 23 Apr 2024 09:43:46 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: alex.williamson@redhat.com, kevin.tian@intel.com, joro@8bytes.org,
	robin.murphy@arm.com, eric.auger@redhat.com, nicolinc@nvidia.com,
	kvm@vger.kernel.org, chao.p.peng@linux.intel.com,
	iommu@lists.linux.dev, baolu.lu@linux.intel.com,
	zhenzhong.duan@intel.com, jacob.jun.pan@intel.com,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v2 2/4] vfio-iommufd: Support pasid [at|de]tach for
 physical VFIO devices
Message-ID: <20240423124346.GB772409@nvidia.com>
References: <20240412082121.33382-1-yi.l.liu@intel.com>
 <20240412082121.33382-3-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240412082121.33382-3-yi.l.liu@intel.com>
X-ClientProxiedBy: BL1PR13CA0023.namprd13.prod.outlook.com
 (2603:10b6:208:256::28) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|PH8PR12MB6794:EE_
X-MS-Office365-Filtering-Correlation-Id: 46781a00-4226-4272-7f46-08dc63930522
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ql8Aj1QSJ09Q/mvl60pcWgMxHWkMVzExnZ4itL9OLHEwJul8wQYL2WuCSiIp?=
 =?us-ascii?Q?3FeZlkO6XhS8izlg7cZE5do5TZ+uD3AaiimX5FfVHNYYSGS5GRnJ1eWJe7hp?=
 =?us-ascii?Q?4Y4i/Oxx5WkkIkKhqPssHSldW7NGtOR/xLEfG6Uxk1YHiE++zfWmAAZ+LMUb?=
 =?us-ascii?Q?bUShEGnoDUIGLjxY0AeLn4nefNbAZBaU2PqucjRgD6+HZiVCfbFx+78R/zbA?=
 =?us-ascii?Q?DWOGXXbSVFvTxcZvN7aadb7W6LYUVK5YKSpE/BjO89+QgbAjyHxIL/H1Lvdn?=
 =?us-ascii?Q?gJWVEShi56wIGriFAtomuqEps8qIk4pQvQw9apnsHQPJYZ2sGRoJ6f2W30Cq?=
 =?us-ascii?Q?n/4KlS1wN997/WbVVi4J+PFJwvoarFBYZtk8234NyqT3upJmh3PsZ65qGnCi?=
 =?us-ascii?Q?TGQipZiLCgoRKIxjAK8l/DkNuphkR0FC+vuctjnWGse6dnfP0sx/fYNlFqHe?=
 =?us-ascii?Q?7DFwjQI7ns5MaChxD7H7zjiP+a95deIKep58lfF/L7u5YRIt5pDCoBvh/huo?=
 =?us-ascii?Q?WR5qe3UUP4285LZBAiHKRyVBpLHE9hoNH8VM0wO4z1FSfp3hyrpvTicUA9QE?=
 =?us-ascii?Q?7RANN1PTqV6fuoLOjfPT1Zl0nEhMr3x/FiPYgi8y8llqGUO2VNTPyvQS4Ght?=
 =?us-ascii?Q?L/xN5yLXO/+mk0A1GzLDQ4yQsbW8vfn1JvvCJpQn7UlflWFEHQz9sihnF54h?=
 =?us-ascii?Q?jzEPLwGdXG5b19yt50B18H9UNfjOBx8GsPWYvVEFYyIcpmjbBM1zxLInJgBz?=
 =?us-ascii?Q?BumyYu54/bEQ3XctN8dMREyowEZ8UOHWiJ2PNrSBJAQmJlWY7n7hHZnS1elJ?=
 =?us-ascii?Q?dS+1mWUM9r9gjUVqrHwcyIPOWQ+TpSjezfnDyIAqhHnxItFQeNUz8E5s7YK0?=
 =?us-ascii?Q?uv22j+DpI0gIE29VPdOq1eVuLo0opWo+jDIs4imkVzKp6sRP88d3NTCmBgdW?=
 =?us-ascii?Q?rbPTf98182G1QzcPzC58XvRnaLvbUlTNjx+rDbCxg9klbrrkex1CIUoNd+Mu?=
 =?us-ascii?Q?20A+Y87Umby7k8AYvU2sWek45KZzhACLpzUsbXDiOk2F9BA8Wl99+Mfd2XAD?=
 =?us-ascii?Q?I0Gz5lBNSY/KKqs7WSfO7mlt3aHnUfzf09zIIB1ZYHejKSe88e1aWvN4NgSy?=
 =?us-ascii?Q?vs/Il7TT/a31tUe5KSNaXsxSicy76njUwNfrY0n4u1p5z+NZPxlwdN4PR0EE?=
 =?us-ascii?Q?7RNOfVGUJcYfFOtE/Z1wRdaml63G5jVuglB4pq641r+jca2LvDND7EUBrIXq?=
 =?us-ascii?Q?z9MuX68rhqTKP/YpTP1bE185so3TI3UMVgkPNRLYIg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Rp9mUJvGtGSPPHCHKFpdssy7F/FLug56YwgcZir6atUwkbS8bc148Xt0brTr?=
 =?us-ascii?Q?j0MwZb3wuSvr4LnfGTUYkZKMBnVmusihMLaKkWzebzcaEBq9ZTB3EEPpQvPP?=
 =?us-ascii?Q?BucE4vCvN2Gtyxr8DWv878wJvbGgA6TbRYFRFdw3+zGil7QFI8LiwBhNW0kw?=
 =?us-ascii?Q?Q6FKqsUhs3DLddTA5dAuTVa2pCIzvrtmYc7yBHJlmHm8c4194thWFmzmI4O7?=
 =?us-ascii?Q?pK4fAwe6oGovoSFCTp9jIBZQA99Ae7A3KxgiuzMoeSfh0RxFKjPDtsmbNr0q?=
 =?us-ascii?Q?qWPfROdv0ixZi8wLN6hIu7t4wOQKWAA0BhsHS7oy7wtnvUgeWbWk+GuzU+pK?=
 =?us-ascii?Q?HteSCYPIZZR0xd5T/SKKbAVDVOliv7xjT9zkLFGtYf6cveLw/CH5+HOfOpyX?=
 =?us-ascii?Q?yqyMdT9kGom4G2/AcVndOtphS6Vaw39+gYmN3wRiockDhtK7RsoSONG0nJ9V?=
 =?us-ascii?Q?7pzQ0s90FwLE+IoWRZMW+6SnMpd2t5XsvUD+mE36hwVaKDiOG5crkyduoJ3c?=
 =?us-ascii?Q?c1DqGyS4OyKRqqzbdhI6rPhTs5NkyWW9DTDm785LS1+17vpL8xWOTMvgBp+R?=
 =?us-ascii?Q?LQHqctgvAi3/yE1nvEW2lKEcE3NUf7EKxxHeugD2HH3GNZqCrPGuVSYmIWY6?=
 =?us-ascii?Q?csveqA7FZbPE+EPml/jyBuV5eRObatDK2BMar4WH50aX29wvmEdQadXwMHsk?=
 =?us-ascii?Q?3YvZWApAP3VlXvtmJa1EXxXeA1jsaBUkNqOqWqkJLgay0Aq9ZL9Xd2yExhOP?=
 =?us-ascii?Q?L6uxTaDwbJ1EpGuf9AGw2Pni28d5+pw+MTf9Xb16NJmQLN8cUkmVLJHD16DV?=
 =?us-ascii?Q?DwlOs4Ga5pYc+DhJqO2pSRQZbiq8b8RftalMcFjxj9T2QZOpYgIhN5IWvUNw?=
 =?us-ascii?Q?oU7yYUUo0oFfDmaPw8AO0rH+/QRz9BhPabrC3dPq/sCxTr5eheW9Ns7qNjse?=
 =?us-ascii?Q?Iba6Ys/uTIs0tF6VS1Va6gjT6v4AFBmdkiNaJoGwPPe3TuRsIpUz68Pf1Hg/?=
 =?us-ascii?Q?vPDrvp6ojS972OX3TbQVUWdyF8Ov7FOjP1pf03t280Q5ddhNTchmzGbFTLgx?=
 =?us-ascii?Q?fyJze22i5xdGvwNFzIopWars72EOl8Nnjp9TXaytpGhcAm9VE2XHvhspXuK4?=
 =?us-ascii?Q?idAPUUHzlVUdnScTVYBKCnbQqsH9EZGfAbzkhG4ihvys83zpCCeWlaT7w2tf?=
 =?us-ascii?Q?42VrQeHDKj5rQlcEnVdNmGjoc1OSJ5DRPGIXswy6j1r5qp4Hl0dqnLEUl257?=
 =?us-ascii?Q?2yX8grjOE25rkFvIm48UhWsYHE0QJOqwJLjngXYzg7IdQ/djMjPFwJoisDbF?=
 =?us-ascii?Q?yvYJ21RJW0+s9/U53XfjETbWLATAeoXPPPaQ2+UqJiNoXaRXP5gFNhEVY2IK?=
 =?us-ascii?Q?gpEJnkhomL8w1yJ/ig2RKGBBoOhkDqnIgyHU17HIu/S90Cxp8XSYdRLakxzi?=
 =?us-ascii?Q?owsFUuDdms9MYWfMUzJUbFxiwH4HKbchoUJ6fT1LVQal+dxWfl6jC4wbSx+O?=
 =?us-ascii?Q?0pf8XETsfCRSodxexuXRoH4SPX/maUVqhX6h8RgYGhv+xW9Ec1hzAt93qjaS?=
 =?us-ascii?Q?JYCc4f3SlLlAgBmriBcx5HhmsCHFyTMY+aDYFGqZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46781a00-4226-4272-7f46-08dc63930522
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Apr 2024 12:43:47.8568
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nsUSDhtwxAkM0xcoDdfLcJmXRbT+nMoo4j8rcyeks6i3qXPTAebm0ycRU8lHbqxY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6794

On Fri, Apr 12, 2024 at 01:21:19AM -0700, Yi Liu wrote:
> +int vfio_iommufd_physical_pasid_attach_ioas(struct vfio_device *vdev,
> +					    u32 pasid, u32 *pt_id)
> +{
> +	int rc;
> +
> +	lockdep_assert_held(&vdev->dev_set->lock);
> +
> +	if (WARN_ON(!vdev->iommufd_device))
> +		return -EINVAL;
> +
> +	rc = ida_get_lowest(&vdev->pasids, pasid, pasid);

A helper inline

    bool ida_is_allocate(&ida, id)

Would be nicer for that

> diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> index cb5b7f865d58..e0198851ffd2 100644
> --- a/drivers/vfio/pci/vfio_pci.c
> +++ b/drivers/vfio/pci/vfio_pci.c
> @@ -142,6 +142,8 @@ static const struct vfio_device_ops vfio_pci_ops = {
>  	.unbind_iommufd	= vfio_iommufd_physical_unbind,
>  	.attach_ioas	= vfio_iommufd_physical_attach_ioas,
>  	.detach_ioas	= vfio_iommufd_physical_detach_ioas,
> +	.pasid_attach_ioas	= vfio_iommufd_physical_pasid_attach_ioas,
> +	.pasid_detach_ioas	= vfio_iommufd_physical_pasid_detach_ioas,
>  };

This should be copied into mlx5 and nvgrace-gpu at least as well

Jason

