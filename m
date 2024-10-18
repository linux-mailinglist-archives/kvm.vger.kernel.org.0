Return-Path: <kvm+bounces-29177-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A2139A42FF
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 17:54:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AABDD1C26290
	for <lists+kvm@lfdr.de>; Fri, 18 Oct 2024 15:54:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 151AD20262E;
	Fri, 18 Oct 2024 15:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rwKOOUyW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2042.outbound.protection.outlook.com [40.107.94.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1362A200B93
	for <kvm@vger.kernel.org>; Fri, 18 Oct 2024 15:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729266876; cv=fail; b=irftFbFjZIK449xZ7zw+eTXGqt7DZajJ1h6wMvepfgLfd+CYQqwCQDa4ZfaZ80cPvkKb9CKEIAe2C8hyHtrHLe+Q0w7A6AKCBTFDtuU2WXQn+Yxaph2k7S5ecmlLnINryxHrv6Th/FbK9leO3CDRVtOsB5wD3DBCLPRGHN+VEA8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729266876; c=relaxed/simple;
	bh=ne1Psq80iNDc42L+0ThuzHe8w9SiIO3SJu3DOZdYs3M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jqMb0i7bAWf3Y+TudsOBFqzMv00yDEBxaQmqa1QYt9+4DpYtonHog+8hOBEPlIcu7oGwkHSEqlfp1NelbYlz0cmlL8YagMEsp7RNLfizI60kf4CHS4r8HKSiIPx/P91LwmrnMk2cEJaN39hDV8NOniNiLFb4sAIxAIlDnC37Ypc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rwKOOUyW; arc=fail smtp.client-ip=40.107.94.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=n5ryC31KINw0B5TqxvSQvkhKI7P21eyPFXUMaBtmByyyjWqqiQF+nqA9woJIxHnqEjEnGeX2esCZnk8GVx50C1UBtveZ+G2lcKXOZkPITyocw4teY86kqLKo/la/B1Gl2wAucwiQ+5LUbqziJv5js/uuxAQbDMNhl0sm2Djmpb1q1mIR/knVdwB0R2H4ZmBx0NKdpHff4S0XVPu3l7RLanOKJt6LmE64NoQwnvgAfc+x/uhBhFgziEtWvJqjtE7f0yZ8qRtrtU+xmN99hvv+xScf8jBA4f2RswbhLQIMHTgb61M9ZAgAs0mrFc7dmUHqGUIV4Pvi/zibLPhWwm09BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZC3gH35QPhfsZ+olxVMuSuZFRwoIsL2by2XTYVRZQII=;
 b=vJCwYxocmz6E7Zi+9R5xcGAmSbyV04G6P3znPF2e2pnkgWZWHxm1xTPSWO9hgR0Z1DfthdKOd1WPAcdRSZFKIHwQsGfh8u3TllEicNPronM7upk2f/oSunqtoG2HpeXTySRrZ52u3UyUYrhutScfLtx3Jh2aFxvx5oQwHO2WgjzC7LGeMoaVd+kmBOo/RWXrs1BpAAiWUzI/Ih6mBpsMzOOQPnYlop1trLtG1LHsF+uvQJuy5F9SMbhW1koGMKjZ3AEMCd1DK/qYsufcZYbFeJdbMRvNVpzcL5kgo7q2ccRJpd79O9CpBXBdJM+ljI7myUavtv86A7q+3yMRPBYPNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZC3gH35QPhfsZ+olxVMuSuZFRwoIsL2by2XTYVRZQII=;
 b=rwKOOUyWfNEeAWUnnMptS7V3ncolOFtIoIlNgOKKC6iIepTkTx86zyR4E7t5YMD/UvH9+DZ/e2DicnSd6iAQqWM53a7+zpLybh7lBGogm/Jpn8ETLuW1ytUcw2S4wUtmwa0oNMho7kIHG+Dp54fmiZRYwxKMP3Vobj640JidA048hNkepoWepk0NBHUqif/DoGI0kCuBXALm14JyZLuBClm489jPkW4j5805+Ws4wCNRSVqvUk2x9nNZPYuEKwjWIJN6QHBGD4VkuYReQ/x8om1JzjwqzceRKrSuZ6dxacZOVl+pBSTKL+oIuhLwKcC6VyeUCls1LfTGQ3/u14/Yqg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SJ2PR12MB8784.namprd12.prod.outlook.com (2603:10b6:a03:4d0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8069.18; Fri, 18 Oct
 2024 15:54:31 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8069.020; Fri, 18 Oct 2024
 15:54:30 +0000
Date: Fri, 18 Oct 2024 12:54:29 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: joro@8bytes.org, kevin.tian@intel.com, baolu.lu@linux.intel.com,
	will@kernel.org, alex.williamson@redhat.com, eric.auger@redhat.com,
	nicolinc@nvidia.com, kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
	zhenzhong.duan@intel.com, vasant.hegde@amd.com
Subject: Re: [PATCH v2 3/3] iommu/vt-d: Make the blocked domain support PASID
Message-ID: <20241018155429.GI3559746@nvidia.com>
References: <20241018055824.24880-1-yi.l.liu@intel.com>
 <20241018055824.24880-4-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241018055824.24880-4-yi.l.liu@intel.com>
X-ClientProxiedBy: MN0PR03CA0006.namprd03.prod.outlook.com
 (2603:10b6:208:52f::26) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SJ2PR12MB8784:EE_
X-MS-Office365-Filtering-Correlation-Id: c76e787e-0fa0-4d0d-9679-08dcef8d2702
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?e/Q083rAxADvGDBRgDFckF4rvVNym3qiDH0b6av93RfD0LNP722SrEAqRXRa?=
 =?us-ascii?Q?6QJf5MIZpgYu2N/q96Ts1J6bP1d1ZrYaB+KDad3fB7+68I4ozrlGTVV+d/LZ?=
 =?us-ascii?Q?aHEJwFVql/Sx+VwhOCEu0MhR393QksRY/vmyVWpXnHHDc1D/f77KOYQwnkry?=
 =?us-ascii?Q?H/g7VD4RnX+wxcC7hm4KAWKQrksnDvwesKuKW52E5bAURysuFjvOcZ3XRQa3?=
 =?us-ascii?Q?HwTp+kj3p3rHkGeZF2lbjVJbKAg5a3m7m0U7LiYGauVmp686gHGoPX5wEk85?=
 =?us-ascii?Q?zN1SfKRZVNm4+o2JkBzgq2vxHJawClSPxsSQ2tJKckK1qlr8+jydKrrGSt8g?=
 =?us-ascii?Q?HiEJ0hAyyDiel76sv9U8ZzE2zH6G2S/5t3rkXAOBI1ZNv0G9C7iPzF/3Xrln?=
 =?us-ascii?Q?xMN+HufZH6xt5q5ZWfDPUrIaHuce/SHKJODFr1HLqpVok6mo1f1XfhjzP/p7?=
 =?us-ascii?Q?RNP/NiHX60kzYyJiDoTdxUbipROT4w/EOvy7MC0f/XHthT6ncl8Kh2DRI7YX?=
 =?us-ascii?Q?5mMGu+yFa7XExma1t/5yT/o+IDpxVybqUwLaA39c9etU60cgMcphrgDeET7C?=
 =?us-ascii?Q?62jjCoSuDNvAR/8ne91qJD90gAjl2jvSWakkOjSd9rjoFx3VbULQSKGm8JbT?=
 =?us-ascii?Q?bwaoUagheVrfBxnFnH4waWCLMOwgD1m3440mp3hvLWQinoJzIEpJ5bC8sdYL?=
 =?us-ascii?Q?d1GVAmBYzYFhOYL7cpzjVqSfes+UOpQqHjBJNvml8RCbrzIgFGL/CDVzxF48?=
 =?us-ascii?Q?hJrwk5NEsTHNPw+ZehZbakLtn0GZ06OPDFfeN5c8jPo6LTbHsSPEvURzLOnD?=
 =?us-ascii?Q?ofmBNRpoxMsYKGKIS36nIdc25T6+iYdQd8cwgtRaYyEpn8OWX0fGsc1IX2HD?=
 =?us-ascii?Q?Cdmv0yn3IT6GOXXh7TnghP1v+/gR0LBxHWlP5GQSwHaGOmr3RSaRu4mVN1+B?=
 =?us-ascii?Q?/7sYYycTkyxjaTJ55C08amgmP2aoR76Gebybo6+Ic1Ge6/soQpCNxuxH6tBB?=
 =?us-ascii?Q?1I+Zom/idBBEW5mug1fuVynh6dDvmT47hh6dQFvuO2peJdcnIsC/Eeb7ZdKx?=
 =?us-ascii?Q?bbDMs/oGfkbUNCHhz+SDT5QQtzboablGVrU3Yp55rtfz4WuV4FUPJ7wvr2wa?=
 =?us-ascii?Q?s3kuhFdwRWBtnRuK8z60CMT909N2FuTg0BN3cFx97LunqMyHWWVDiu20AxwS?=
 =?us-ascii?Q?7UyCFByimR/ylUmGlPJAIbz6XBAotWn2DnjWtoGRMEAtGDqTijRouU8k0agR?=
 =?us-ascii?Q?/m0wDqnxYwLMcfjFhujW7MbpjXkJdQKXQGMHYlWp2p0Y1SxKZ4FM7IMk4Gk2?=
 =?us-ascii?Q?TnA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qQ3DB7Fu1fwXYox6iz+U5D7x/89fEUNPX/u2N287ch0BN57tCVWmrNm4Uz7p?=
 =?us-ascii?Q?wlvdgk91cyxNuxozPiDQL5DcJBs0AMculPZP6JRcAWohF52Z7pvQKLVTcgqa?=
 =?us-ascii?Q?/RJw76CXs+K4B/29mP5pedO9m3NVW8rnOyALyMBjNlaTT2mi9RaP9/sBONBM?=
 =?us-ascii?Q?xZr8OD/xlR2OsvDPTDvwCKL5OOuDz+WhjG0VPl9ybm1Ne98LkbBQ899rdR7j?=
 =?us-ascii?Q?8oNDCiQbJnsEa6uxchPP/nYA2WQi5THUXgenibKUMdYzw1JaefrLsj7/NgQB?=
 =?us-ascii?Q?1qHf4j8VqY44Z2+/moAz7y3hlBJ06lw/W/RmYluUonAcRlsx+eW4VC0d0wow?=
 =?us-ascii?Q?nPid4/loRoOA7nR7J2IzReYfhUb+hRoQ/QP1bZrmilLwA9/mPdjobDX8jL2s?=
 =?us-ascii?Q?nJ+PUTKM80HdmKUfPFlYJ8Bar2ZxQMSDK2z3rPvtUkMoLL8pW4FkgNjhs/6P?=
 =?us-ascii?Q?FmE3n8WAT5tALM3GEVlKygVAOIyIBuE9vImi0WUeuqK7sq5l4pwT932MaH+F?=
 =?us-ascii?Q?sClQgoxnTkUp9f45SOPAthfXgf1Xh5AAvAb+d2dZwWrf02Jo2ezZGxGfNSoy?=
 =?us-ascii?Q?ziKJkJNwXWjfMAT/6t06Xc5VAYZwBYwA0fMz5A4aJD1g2TetYNGuqW9+qE/V?=
 =?us-ascii?Q?0c1U27SThlW+ZTHAmiQjWV0ZI1Pkzm2rxNLFwXnagf0rxm5JFjFo/say8PAM?=
 =?us-ascii?Q?GNvGsfEYopik6bKzN7EVnjeLFh0Cd9TSZpJJPvn4hstHYMGstsWI39Nml6EE?=
 =?us-ascii?Q?Y5I559thqQ/96zCmqIoZgST6tvamuCPe1M3hTj27attgwEt2NfCsaqnN+RLr?=
 =?us-ascii?Q?SDj8OjfnueOkf4Gw0jC8A7yOXRPgTep34X8MowxPxnw6nvW9JyOERUDJB8Go?=
 =?us-ascii?Q?EaKqINTKv7SdWMY8iJXoKWB8UVN2UcRQC6VyvgMHei56zyJ68+fmOQcR9B6D?=
 =?us-ascii?Q?5+M7r4KBnr+pWc6s9GZiecx4F7iMtREPapD5vFJHJwfDOG69Ssm3Rt/o6T7t?=
 =?us-ascii?Q?u5dv4H3avBt/tc9t2eZrTZ6TS91hmNHqLl0vgd8pt7CM0HOms39rD8KQa+M7?=
 =?us-ascii?Q?nxDGA4cJYF8bKDAeF43l+4G4L/+PseL1gHEfDJP+//igYdEPFsonkcupBL+s?=
 =?us-ascii?Q?FfpuQd/Kv6EBNxXciCvsaTDZVt26DBs6APih1q5xwkNqChgjgKgwPhIIrThN?=
 =?us-ascii?Q?ebvw/8bKQwLXuViZeI5TTqvCCPBa8e42vpSE2sY93o6ulhIQ6x5IrEYtBGyZ?=
 =?us-ascii?Q?eTOUISSFopcY4Poz33CqZ5B7VGyONIAwodqjWUakI5xZcVdaZSYNvGtiWlYQ?=
 =?us-ascii?Q?Pe+Vn9KlwaAwN67af6rOUsxU6SsApT7vfCTYiJWlgFu9nLVL361/bjbO3CuZ?=
 =?us-ascii?Q?JPef8dAhrCHEKovWJLSz5ciD9k7MWXlK5gaHswd48WccYTslLaKbZhbFcSUB?=
 =?us-ascii?Q?K3XBO/QngRd5/xsl+GeqTyFDqyY/MNZBU2B695SNSipW3OSO9mIvbgHFjyTm?=
 =?us-ascii?Q?HZw8p4Zoe/e8RNTV5kDpSVtazv95KJXD5m2RoHwY5E7oOH2+mnBWTYD6GbFD?=
 =?us-ascii?Q?yHr1Yv1pS0DGmQVh42g=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c76e787e-0fa0-4d0d-9679-08dcef8d2702
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2024 15:54:30.5965
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gsTQNnSFLVz/NN8QBkmAADeLqxqRSp1hxYUtmh2FZIAKUFP3eivvf/1gsBEjkTzF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8784

On Thu, Oct 17, 2024 at 10:58:24PM -0700, Yi Liu wrote:

> -static void intel_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
> -					 struct iommu_domain *domain)
> +static int blocking_domain_set_dev_pasid(struct iommu_domain *domain,
> +					 struct device *dev, ioasid_t pasid,
> +					 struct iommu_domain *old)
>  {
>  	struct device_domain_info *info = dev_iommu_priv_get(dev);
>  	struct intel_iommu *iommu = info->iommu;
> @@ -4292,10 +4298,12 @@ static void intel_iommu_remove_dev_pasid(struct device *dev, ioasid_t pasid,
>  				    INTEL_PASID_TEARDOWN_DRAIN_PRQ);
>  
>  	/* Identity domain has no meta data for pasid. */
> -	if (domain->type == IOMMU_DOMAIN_IDENTITY)
> -		return;
> +	if (old->type == IOMMU_DOMAIN_IDENTITY)
> +		goto out;

Just return 0

Jason

