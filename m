Return-Path: <kvm+bounces-17119-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DF9C18C110C
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 16:13:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 95AD3282E39
	for <lists+kvm@lfdr.de>; Thu,  9 May 2024 14:13:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57C2715E7E0;
	Thu,  9 May 2024 14:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="VLAEOHMq"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2068.outbound.protection.outlook.com [40.107.93.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EFA015250D;
	Thu,  9 May 2024 14:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715264023; cv=fail; b=V+HqQCxH9CPASfkhbwDOMM/wQuTkksKMeiQwzvtgKiDzTymoWBh45hRhaz9uu7VeiqAKKxJGmLJMYngbPyZMnzu96XYuf6+nt2ZeXhZgqulMI05HBozk8RxfkK7oDg+WCQHe1beOwOHToEN9ATsTQRlXbXoh/eSz83crksEsxXc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715264023; c=relaxed/simple;
	bh=MRx8uc+x1nmR62cR5kAmkgSYlF0/U027LBgeKSEVm3Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=p/baGux+4vlFazkdOnsT7GK1312LyTpey/0SIC7uIgbOY06nJvRYzl/stWVlisYKkBsWG6WUiW5b0mJ+hcak7hsyEVH4yJWuQvZjHE89XsKJK9Sp1Hlw4AKt9BpHcz43l9BNuWgDfVhRb/8jDEIPAbq2L1A5Yi9FR28twAioqKY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=VLAEOHMq; arc=fail smtp.client-ip=40.107.93.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SZI9ikICNChplcyWXIDy0kNzxf8DyjS6LX/yk2p4KtUlq/KdH8iJ7UYZbC8ISjWoHquoj/i1apBDybakkSHGJ57irCHu4dAq/ufV3G/Id8Ch2f5yN0vqAyiO2bMdqOXS1CBACKzPSdkSpJ2p5YtC1Cz8acsGCNm/FVhy7cDr06AJ+46OE/hqYpbxPhHcTJDTbAngF4I1UsXHMTOl6q0q58jJRPaleBcog2mTHABqFMOZfUPh/r2GeuehtPb6TprX496VUOKy+En726fd1byHBWbanTumODFxsibY32ZI7VfazcKMJN6q0ySlLelixC2oB4b9sjkjFNSvL2F4kDPGqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e812hvE32ZczTvJoiGFElhB5E3YrlIBj/F+Dy1HJ10w=;
 b=ONia94MkVrU1BXzpNOJUGb1FOvrtnVXs+QD2XDgStpujhe47dxfM+lZo27X4vwekkggwyYDkf1NhqI252QGVbHHxCGzonsiQdA7VzmM2FnGW+Wo3Iv3AP/OIWfHv9sJV6HsQy2n02INPIfbBVBafFhpQ8xnWt9we5DWz5W8lCO3mR4FpSazV3BBjjTAjAk6CMNaU8ZFu/fCbHZXSxLmpNiyJOLl+Mdrjieb93RB31aSw9hy8gQxbgQFXSzdZqXLeJPsPHEafG1jlPMuXBC2yUckWpyQ9d8WwoCCsjuTPIc7l1EJuP4xIC/slfn+Y0j3iUSV8u/8tla0RboIBbhlnhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e812hvE32ZczTvJoiGFElhB5E3YrlIBj/F+Dy1HJ10w=;
 b=VLAEOHMqsfTRqbddBh1BB3wD/35ULu5EGQAzIbfrwimy8WifynS9BjW7FRG9LUaK6HK8Nin3d58myibLaKPuftNeqe1rPlkJnLRb3GuAM8iQW0a8oNduxeSO0Jesdm5oBqWvjts8evCpXGx5Af1sgtHh5wpp85TZWFFoEu4tufX3DDoTe9ODFEXwn4SbINEsbPG1XOjvFi0xFGdQDhWRwPIie/MxD0Jw4du8b4j5RdtC25tAG3iq8wIBQO+l04mAaZmCV/FDtqXq/t4DvW6guYmlN6J8GoORLflC22J2Kv1N551aMr76fC59F1iWyy+QOGLWIOIMuspVghUe15xQAA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by SJ2PR12MB8034.namprd12.prod.outlook.com (2603:10b6:a03:4cb::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.47; Thu, 9 May
 2024 14:13:34 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7544.045; Thu, 9 May 2024
 14:13:34 +0000
Date: Thu, 9 May 2024 11:13:32 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
	alex.williamson@redhat.com, kevin.tian@intel.com,
	iommu@lists.linux.dev, pbonzini@redhat.com, seanjc@google.com,
	dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
	corbet@lwn.net, joro@8bytes.org, will@kernel.org,
	robin.murphy@arm.com, baolu.lu@linux.intel.com, yi.l.liu@intel.com
Subject: Re: [PATCH 5/5] iommufd: Flush CPU caches on DMA pages in
 non-coherent domains
Message-ID: <20240509141332.GP4650@nvidia.com>
References: <20240507061802.20184-1-yan.y.zhao@intel.com>
 <20240507062212.20535-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240507062212.20535-1-yan.y.zhao@intel.com>
X-ClientProxiedBy: BL1P221CA0018.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::30) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|SJ2PR12MB8034:EE_
X-MS-Office365-Filtering-Correlation-Id: 16387807-a4cd-47ce-1f1f-08dc70323640
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005|7416005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NQ6CCExsGug4dbFQCV8KXY0ZD/pkgNbdkr5wmn6iZpW50snDbGn0C4XclmRR?=
 =?us-ascii?Q?4rC/FXzskyIT7MTdQ8bv9lEqEO0SnVYUdAG8DJ4CR2sZPhxue1OMzisp5QUb?=
 =?us-ascii?Q?Gyen2uatIMnIdayGGTRuYrdnC3PCfp4Rg7vggz+vKBbsK5OWNrvQeugFrU4M?=
 =?us-ascii?Q?/iswF6/+okN8WXIcN+L+abTuMpEv02zPoc3EIHy0GV56JLg9pJW1pHApQcVJ?=
 =?us-ascii?Q?eWAdtCzeF43+cXQuGPDLt8xYrY92nvefAeVM2b4iwYcH08YvlZpM8UE1HMTn?=
 =?us-ascii?Q?+4UYB9mIPDuGU0tLTbFRv8/X93SEGjwtKYq4h6UgEHRtjWbbGCqxpE+21Eh5?=
 =?us-ascii?Q?JyYgEKmOogJh3MN1LWaXv1xLwxbRe3Lbjy3uH2Xr7eolEJpagW5wyTj0pBf4?=
 =?us-ascii?Q?GWoO9mZm+bTr1R0k6cwGnUnYPVUvxX+EtiWtbZtFtxvWEu5C3Wmwiq2IAA4H?=
 =?us-ascii?Q?8fHwLTbbHdxoITSnTVyUZT0llnO9hBMQ4JdGGdosmj5FAPAChTJ6g6iO1fEc?=
 =?us-ascii?Q?KQZ7qC3aU9kQzcK4f1HmoTuUbNYbx+HqreTi6GJxapOAJfGds+nppqRClAwo?=
 =?us-ascii?Q?rW/kyhdiCFjYPKVzy8xp5CwLHn/Fbsdhgr7URXKG6/CBYjy77sU+/SDKh2Pw?=
 =?us-ascii?Q?n55y61vx1G4ua2UQkdK4pvOO5YB52HtXW0dyRtMN9GG8F85w/Xpujvx4cxP0?=
 =?us-ascii?Q?esjoUGX6WmY3Pw+b2bP8PlOd8hsUa6/wLsiOHPoZraYX5efoNpp5pCKqfetv?=
 =?us-ascii?Q?Ltb6iFMgJyxJc0h4MaX0KwzId2hD4JiZPQr+wk/FC5J6KGh+dwbfXbjKGqag?=
 =?us-ascii?Q?MsEI7wqu40GFWWH1eNCAuun5zeB8fAMDe35Rh5LTTHPE0C04EMiimRgWj00s?=
 =?us-ascii?Q?fZSrli7rGdGc1EPuJv4DZ+qF/Xhstyea/AFA02Cdnff+kbvPDEEkNW0GVncZ?=
 =?us-ascii?Q?0B1FJGLoQ1lJ4B7ZBkAIfOvrDbdqr18Jh8Si1IwNfRafUlrbaHVMN6MSXrXP?=
 =?us-ascii?Q?/TngVr6oaFlH3j0Shzy6ECeT5Kcbswk91A6TvUm6AXae24dg4mNWANft4MQe?=
 =?us-ascii?Q?RFSljh7y82JtV7PXBlgS5iCUo6ZGa/axe03Nz2ou/v88ZTkKEaXlzbR9olbj?=
 =?us-ascii?Q?vUJI/z0RDyMamZMePqr9RBSfXNakxzwepDbqprz4zvU7f/EJ9VNICV4/hJNB?=
 =?us-ascii?Q?yIZ+MTDxQ7bbvyFv3iyVMQ1Hz2UEr6h9TaDtcm9VWPiMlTgfhxL66auUsi9L?=
 =?us-ascii?Q?7mCqalj2sUrlQD7t4Q/CoNS6upVUHtQo+zPh7q4w3A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GRRUUOhRLRW06riDsCfoZOt+O2mEVgvs2n0lT11bDbF/zzMBV4KjtTucua5w?=
 =?us-ascii?Q?oPnKNaSIDsWz5XG7j7Ahfi6LrgNxHF6Epp9v+G3BmFvj6B93xdh9cqttsCrC?=
 =?us-ascii?Q?y8huDRnRf15+ICDbJPSel8DPO2k+T3PucHNRq/BHP/P/A+qpWDzB5i5tlL8o?=
 =?us-ascii?Q?h41d0hKp9ls0Zfuc2oaMao1GaI+JrC6qgAtHnLm9KsRjmW/zBnNqD8c4tg45?=
 =?us-ascii?Q?4S0amTC+75543CYdl0Wsbm3H0ozEC6+73mnvI5sIznZOlf2z3myXilEVcISQ?=
 =?us-ascii?Q?t+8QYisy+4kEaFd06m+S55Wf/Sv2CSYLRzKICjs0SXOxrBHRqXX9zGziI5xG?=
 =?us-ascii?Q?tpy5iLh+a/A7QMmCEUCm2L9xc2zQsJ55cpXzI5hXAjwk87fOQ1apOJ/nxyBx?=
 =?us-ascii?Q?vnPbLhjHnLEPYACX4xiivF8E/HDcMmFHwGuU9JNWz90E8FCg+z0dZWcNN6qX?=
 =?us-ascii?Q?Qv+CzNL4pIjiMWytbfTJ/hH0RIoK/Nj/Z6pHHKACWg3jmI109KxUQNXgzn3B?=
 =?us-ascii?Q?ctmVLNOp/kS5c1ert6bZda4Y7whmv0RQZCcXE/2jxV86jeLJ/NIScoXBa1Wt?=
 =?us-ascii?Q?Md8RvOaEz8qrrFla/CuRSwAhnO6gWTCFf0o8Nb1rD2bxcpKfcM8wUV8LT5tn?=
 =?us-ascii?Q?eyRhmTmIBimFdPgOSTkRHyAjrW92eQnh8RCK2e/EN+IOfi3xIpkm11uDxsSD?=
 =?us-ascii?Q?2dDHxKdf1YtN3PGP8vfGL1CZ+DDQWqTTYreRcl4XLShd2OW74Mh5e5STsYNm?=
 =?us-ascii?Q?iByVHtgWREiLdpe2WXuzkjVnlm6J3NuAsqf6apzLUfySVqFFJczzaOVICJTZ?=
 =?us-ascii?Q?fgcug7LMT5am2iTlQPzAfun+giZjfsdqW+ULaLAj9g9LL/MzEnwyeiMKwBkn?=
 =?us-ascii?Q?uoqzqcBMd41AzAHkunWowpnjt9u9xqK5nzR66NbeVY9lugVe+d0OGSHif56h?=
 =?us-ascii?Q?4oHYii9DSAlU3U3Ah9XwlawzQkU95np4IuuXGhCE0Z63TG+RaWhb0oSXnpPq?=
 =?us-ascii?Q?vYJVM17Lw898XbQ1mY8rn1K+lTr1qWbC1fvPr+hnCmKmtsabFEQyxfeVgUoI?=
 =?us-ascii?Q?6sk6fOAMOKHkbl0TsJGH6DNBfL2ZZsY0dWD60MXqgVuqgq3cLXGkP7Fed3Q9?=
 =?us-ascii?Q?0opDiSXrLIxTxODrGAAP5auWgg8sw+XCP/MlbSmQ7phyWexqwWorygsike35?=
 =?us-ascii?Q?HnnR9m+tyf1K8Eo35HOShiHC4/A1lwLGFvWiNTpbV0yxskabXDMqGbJFQcXx?=
 =?us-ascii?Q?ovxjd3hehv/SDMGRYGwcpZOxcidx+3l8Zk2SOSR2zwMghuqPiSIafU1tZaap?=
 =?us-ascii?Q?HpECEPisYlJHdaJTSyaWdTLWLbU4lMoVgY7cbBgabXIwAzeTqTgbOGBvF3m1?=
 =?us-ascii?Q?3G7DBtzEucDRmAnX8/T+D4HrLL64685KpGtr1O3HidOGlUZtN0w0FMBb4NB3?=
 =?us-ascii?Q?ITpS8VuEEjvlPfYrs1xhHYf/5LaKuFyJSfVJ8WL3fC1ozjtBfbKLxWwQGOe5?=
 =?us-ascii?Q?4+3i8mmEQEtWTn1gyJyUWQQyYF1RIkDplbE0n44uPYvXcXLPyu/GvXmq4oyn?=
 =?us-ascii?Q?9hw3D5dKHKNZWXR4sS9ni6o6LdamMZ4UahdJTLnc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16387807-a4cd-47ce-1f1f-08dc70323640
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2024 14:13:34.6416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mGa17LiyJwrs9/A3gGXdXpO4MLf6pxSal49mZ+5NZ8k8oG6voBtvyXDh6UXIgpuf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8034

On Tue, May 07, 2024 at 02:22:12PM +0800, Yan Zhao wrote:
> diff --git a/drivers/iommu/iommufd/hw_pagetable.c b/drivers/iommu/iommufd/hw_pagetable.c
> index 33d142f8057d..e3099d732c5c 100644
> --- a/drivers/iommu/iommufd/hw_pagetable.c
> +++ b/drivers/iommu/iommufd/hw_pagetable.c
> @@ -14,12 +14,18 @@ void iommufd_hwpt_paging_destroy(struct iommufd_object *obj)
>  		container_of(obj, struct iommufd_hwpt_paging, common.obj);
>  
>  	if (!list_empty(&hwpt_paging->hwpt_item)) {
> +		struct io_pagetable *iopt = &hwpt_paging->ioas->iopt;
>  		mutex_lock(&hwpt_paging->ioas->mutex);
>  		list_del(&hwpt_paging->hwpt_item);
>  		mutex_unlock(&hwpt_paging->ioas->mutex);
>  
> -		iopt_table_remove_domain(&hwpt_paging->ioas->iopt,
> -					 hwpt_paging->common.domain);
> +		iopt_table_remove_domain(iopt, hwpt_paging->common.domain);
> +
> +		if (!hwpt_paging->enforce_cache_coherency) {
> +			down_write(&iopt->domains_rwsem);
> +			iopt->noncoherent_domain_cnt--;
> +			up_write(&iopt->domains_rwsem);

I think it would be nicer to put this in iopt_table_remove_domain()
since we already have the lock there anyhow. It would be OK to pass
int he hwpt. Same remark for the incr side

> @@ -176,6 +182,12 @@ iommufd_hwpt_paging_alloc(struct iommufd_ctx *ictx, struct iommufd_ioas *ioas,
>  			goto out_abort;
>  	}
>  
> +	if (!hwpt_paging->enforce_cache_coherency) {
> +		down_write(&ioas->iopt.domains_rwsem);
> +		ioas->iopt.noncoherent_domain_cnt++;
> +		up_write(&ioas->iopt.domains_rwsem);
> +	}
> +
>  	rc = iopt_table_add_domain(&ioas->iopt, hwpt->domain);

iopt_table_add_domain also already gets the required locks too

>  	if (rc)
>  		goto out_detach;
> @@ -183,6 +195,9 @@ iommufd_hwpt_paging_alloc(struct iommufd_ctx *ictx, struct iommufd_ioas *ioas,
>  	return hwpt_paging;
>  
>  out_detach:
> +	down_write(&ioas->iopt.domains_rwsem);
> +	ioas->iopt.noncoherent_domain_cnt--;
> +	up_write(&ioas->iopt.domains_rwsem);

And then you don't need this error unwind

> diff --git a/drivers/iommu/iommufd/io_pagetable.h b/drivers/iommu/iommufd/io_pagetable.h
> index 0ec3509b7e33..557da8fb83d9 100644
> --- a/drivers/iommu/iommufd/io_pagetable.h
> +++ b/drivers/iommu/iommufd/io_pagetable.h
> @@ -198,6 +198,11 @@ struct iopt_pages {
>  	void __user *uptr;
>  	bool writable:1;
>  	u8 account_mode;
> +	/*
> +	 * CPU cache flush is required before mapping the pages to or after
> +	 * unmapping it from a noncoherent domain
> +	 */
> +	bool cache_flush_required:1;

Move this up a line so it packs with the other bool bitfield.

>  static void batch_clear(struct pfn_batch *batch)
>  {
>  	batch->total_pfns = 0;
> @@ -637,10 +648,18 @@ static void batch_unpin(struct pfn_batch *batch, struct iopt_pages *pages,
>  	while (npages) {
>  		size_t to_unpin = min_t(size_t, npages,
>  					batch->npfns[cur] - first_page_off);
> +		unsigned long pfn = batch->pfns[cur] + first_page_off;
> +
> +		/*
> +		 * Lazily flushing CPU caches when a page is about to be
> +		 * unpinned if the page was mapped into a noncoherent domain
> +		 */
> +		if (pages->cache_flush_required)
> +			arch_clean_nonsnoop_dma(pfn << PAGE_SHIFT,
> +						to_unpin << PAGE_SHIFT);
>  
>  		unpin_user_page_range_dirty_lock(
> -			pfn_to_page(batch->pfns[cur] + first_page_off),
> -			to_unpin, pages->writable);
> +			pfn_to_page(pfn), to_unpin, pages->writable);
>  		iopt_pages_sub_npinned(pages, to_unpin);
>  		cur++;
>  		first_page_off = 0;

Make sense

> @@ -1358,10 +1377,17 @@ int iopt_area_fill_domain(struct iopt_area *area, struct iommu_domain *domain)
>  {
>  	unsigned long done_end_index;
>  	struct pfn_reader pfns;
> +	bool cache_flush_required;
>  	int rc;
>  
>  	lockdep_assert_held(&area->pages->mutex);
>  
> +	cache_flush_required = area->iopt->noncoherent_domain_cnt &&
> +			       !area->pages->cache_flush_required;
> +
> +	if (cache_flush_required)
> +		area->pages->cache_flush_required = true;
> +
>  	rc = pfn_reader_first(&pfns, area->pages, iopt_area_index(area),
>  			      iopt_area_last_index(area));
>  	if (rc)
> @@ -1369,6 +1395,9 @@ int iopt_area_fill_domain(struct iopt_area *area, struct iommu_domain *domain)
>  
>  	while (!pfn_reader_done(&pfns)) {
>  		done_end_index = pfns.batch_start_index;
> +		if (cache_flush_required)
> +			iopt_cache_flush_pfn_batch(&pfns.batch);
> +

This is a bit unfortunate, it means we are going to flush for every
domain, even though it is not required. I don't see any easy way out
of that :(

Jason

