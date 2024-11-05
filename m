Return-Path: <kvm+bounces-30748-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 564FA9BD0E4
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 16:44:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1428D287E62
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 15:44:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6120F13C8F9;
	Tue,  5 Nov 2024 15:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qdTZ4qkB"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2068.outbound.protection.outlook.com [40.107.92.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8217D3F4
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 15:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.68
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730821463; cv=fail; b=FvcXHnseoARXXrFw2O7xxNQKfVYpyCT0PWzUEkgP2RplBeUiy0IAeWzB8Vm8u1iRSkfXeSHjW8RyXJ375Kpqueh+AWkK7hqxvxL1cMqduWE4W1G6wU6+xC3Lc3gIrVAc7DXB6sEr496Uzrk23PFkvSYSfVqYvCFZDTD3pVp2/9Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730821463; c=relaxed/simple;
	bh=twOAsRc5051M7ITZNoIpCX19eT3vcT2eEjdr1dtfOkA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=u9rQzdEaruPoMb5LSMPNS4ZLkZtX/MnwttCFovvb5hr8MXI2zIGFM9GckLiIh3XagX5ajTbhdfU+IlKZ5G2eEsNUJnnDI93i/yYjQZjaZ1yyzarOJOifAfGXzQthjaS7An/shGSFBI7MICmEdQNOe9NWqEmdnd45QJlXpFnofDU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qdTZ4qkB; arc=fail smtp.client-ip=40.107.92.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uirRJ9WmG4r/09EDbOd+KZQ5qRu0VKxSGqm7p1J7VQSlu4bSxT9aeN1Sj5NA5fF3vxHBkqqbvAGoJiqHIYxB5Q56fVfHffZthqTZ1J9fbonjos+CcP6jPRSmCq+IHnolznsn8JlLKWdZwlo/tBi/iY4b3L8GjZxgcmTsqRjvLBtALW/Le7NRtEntwQlIWNiIKYBclpDvqHFhvr9fnJ+/2PJ3Xnarv4VlqGaIA7JWAT1jxqIRpbt4lbSSBF5gRYClPtaXBDiokVCg/43nxbV9yU75AlJWqw5YOVpKyoH2xNRaSjmIxrUJCVfLuSvuYuaKzsKWk+xuVurdQISwoYS9kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R5Xc/JaAjBNhsnEOKFUvsBo45EZBxkNUAsOWFLU3E/M=;
 b=AoBbNJiJ+DoqxJIDPPPI1gybBdEFPmvGqT3/2d7DFcfZpD+JDCB1U60bvDF3yoAM+MNyA/jA4vLbyo9J9F4AlG0Af0zYScJopmewsbYDZzs2LQa2504UbOclDLxFp4u141cBEwwaXxYhWp66amRADhJUdDVBnbGuNRDcXzJkCog60hMGS8UvPxJslkzIrl7+06UzuohWO4F0kOfWxT5ZjV0q6AHR/v4fccHhQ6lpMNazxfsDI7o1sfp+isP3MwSVHtXItNxVXTAdHhAwXIFIX+YrwhSLC6of0Q1OHJOcF3MmXF3UaMbRUGD6MrQABaq/QRjAGkXBurDGQ4yTl2eFdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R5Xc/JaAjBNhsnEOKFUvsBo45EZBxkNUAsOWFLU3E/M=;
 b=qdTZ4qkBOUDUP72ooraeAI+KDnfl0Mpp1Dku2BcrMd6urnvsWkne31w27kwCSb9k0taW7SmCFj2SQ2SW4ZEU0YatHLpXWQIJMcDom+SZYFqaEqaNJYVWS7KmRL/RgG0OlBYn6m6zLWYEUEEjOk5g0Q8o9msDzJodbNyvFMdaqEoa9r3AVlE3snBarfMpt0m2RO/aUhoEWJSOWz4Xz2aOT/6ERuDi/gjfbktTfluP7otOaMkkbiBSK3PcAaUWdf6t+yWR+u8e25dewuk6HfJrBuBi2V96/G2UAmmIhogTmrvawDyeKBbeen/ibrZ6CF5LMiSDooROCjkgz4coZ6GOGg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DS0PR12MB7701.namprd12.prod.outlook.com (2603:10b6:8:133::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.18; Tue, 5 Nov
 2024 15:44:18 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.8137.018; Tue, 5 Nov 2024
 15:44:18 +0000
Date: Tue, 5 Nov 2024 11:44:17 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: joro@8bytes.org, kevin.tian@intel.com, baolu.lu@linux.intel.com,
	alex.williamson@redhat.com, eric.auger@redhat.com,
	nicolinc@nvidia.com, kvm@vger.kernel.org,
	chao.p.peng@linux.intel.com, iommu@lists.linux.dev,
	zhenzhong.duan@intel.com, vasant.hegde@amd.com, will@kernel.org
Subject: Re: [PATCH v3 7/7] iommu: Remove the remove_dev_pasid op
Message-ID: <20241105154417.GK458827@nvidia.com>
References: <20241104132033.14027-1-yi.l.liu@intel.com>
 <20241104132033.14027-8-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241104132033.14027-8-yi.l.liu@intel.com>
X-ClientProxiedBy: BN9PR03CA0564.namprd03.prod.outlook.com
 (2603:10b6:408:138::29) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DS0PR12MB7701:EE_
X-MS-Office365-Filtering-Correlation-Id: 93d865c8-375f-46d2-2487-08dcfdb0b59d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zjBlSfacghsmndNFvU21xItgg9ZpfGtLkQraOn0Vnc+e7r5BRGAgrvkOg3ZK?=
 =?us-ascii?Q?WscEok8IZ7uc2UWDtVtS1BtZqv8Vwsl9DPD9ov5RMpHzHnj/QulmkacFCzyr?=
 =?us-ascii?Q?519sndxE/NgrXG84XRuPY5FSQjPBWhz6BjvNNt840oakkrqdYOFnX3T2G1MR?=
 =?us-ascii?Q?rRW4el102gBo4AH43PqUke6eceNTF69qDI5LPWJ7BmsoNdN3VUiJuXyzeaN6?=
 =?us-ascii?Q?bJHChMTFmVt2nJ9bOH3TQ0DuVo7olAe7KoDj2x1zhmOAC0O8sTN3N3HGnYJS?=
 =?us-ascii?Q?m4nUAe4woc3cDBhR0W21HCGPLSZSVOvFegX3NaUn8WH/MjpOKcJFxpXVrb2I?=
 =?us-ascii?Q?3VjSZ195pIfBoa+1FHCQkl15b71mHbjO0FS3iVpa3gTypD3BGL7xiyrUN9bE?=
 =?us-ascii?Q?LjT7bSV8ytP+DHCCcLTEf57Ke8vBVLcB6dknOgXaTOzehKoi5Vj5/9Qc7Jk7?=
 =?us-ascii?Q?mFg9MaoSVEtlbJ8TImuOVp/8b3Qm77EcPCVvclfKF53UXaCi+us+aqrpcyzT?=
 =?us-ascii?Q?/17UGbLA7VQbeejE/m6Gr94RBAwf0T0N3XkTtvJe/7Hj1fcfarNVvGa9Ws2Y?=
 =?us-ascii?Q?pH60mO/NwlUstm5pNaaQ+rMGEiH4WJ4krtD0SDyYORmLSRu/BjqGAKcSNBso?=
 =?us-ascii?Q?vQcBNC8dcE6vfoAh7m4ty0MiEcNxW8LaLXfsp0YL0m019MfnJx3ebIAcxpO8?=
 =?us-ascii?Q?TFRsnccMRPWSKyi7wmyc/uvfL1E2Is4N75k+ucQD94YjiQi8mxGOiMV+C1zD?=
 =?us-ascii?Q?pRR71BoFiqP74BjUdxiUo83X0I4R2DTf7Hm7eQ28lK4b0o1YlJCoq5nKDZvD?=
 =?us-ascii?Q?ClyySzF66VShW4JkwCbyv1kSBfbuqn3QiN9NUUTMP+BVQ0Ornj/Dss7Co0PR?=
 =?us-ascii?Q?bC6NBcIy85qHTNHLbYemjLTEIw6M722pmCusJu6qSDnPIzH1piJ9WTjEhfpK?=
 =?us-ascii?Q?SyELsNuN8SxCmOdEWiN8iKPhJyk7KmDhCgT7EPn2taoMyb8uqTdyttTn4+Vk?=
 =?us-ascii?Q?HqbwGjHh2yI1/Sq2R6r4If/vPKKA2XzA/r3s7KfDWHlG0CzT8D2STyNEhoEH?=
 =?us-ascii?Q?iaSzQRaaN/SbqKf+e0qqnDyN1OCLZQwe/SuYRSmzvj1BXr58rMBebKO9cit3?=
 =?us-ascii?Q?bsLW67s0ZSE5Cm5lqAtWO3tNuV+GhcFHXiTtIspvBoD+125qPw7Rter7vqIL?=
 =?us-ascii?Q?wAefH74TrSX5Q6ZguHE7lNSYVtj+JwHGkfrWdDFX9TdJS2AMgRITY3UzsRnF?=
 =?us-ascii?Q?fS3SoaRSMUH6bj9gxT/IH/W8SoOWkoh6o2j+DFbz4d8OSSHsQpACUhiwCXwW?=
 =?us-ascii?Q?ZTU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cBEulN7pIdDRXArTcfEy9MUxeJzoMWU3NEGLAvE8NLVwDGnjEzn2esc2Amkx?=
 =?us-ascii?Q?kIG6315wDHduzdYSJJUNWTiG/6WZOzFMMKoSK/HtFmaRNo/BbbmIwNTAnMlw?=
 =?us-ascii?Q?lA/42mC4zuTmyo8OUcu6egl7gJFd/tCtyHGsg24T2JhG5EGknoqRxpAlN58n?=
 =?us-ascii?Q?d0tk+3q8iH1gxuUxhCMhkiXRj2/O8w8gW2U8dhLcm0Xxyek1NBxPJoNZvISC?=
 =?us-ascii?Q?eBarWo7fwjFIcK0Ycsp6FQ2oKqqzVaLZ3q3H9sfZtNsbFhUB/gdkaOGAulw4?=
 =?us-ascii?Q?JDHsoZ+H7J30n5mnH+90q2oSp0lbvkQkan82gJuHL7GVbbmPXj6YZ/Amy6Mm?=
 =?us-ascii?Q?lbyO+sTtFx+DUIDtEFe7XqV6P4/Ci07uiiDfFodrweR0iHnAsNmvskGMckzJ?=
 =?us-ascii?Q?VKsBWIK7slYrdsCs0F95gWLOAq57gVz0GAod3MN/BmSA9V/uUdQsuUekAg/g?=
 =?us-ascii?Q?RuRmSN79k8L9/fkKwEI9G7wciNUm1v7jzeX2SzP2OWAqd4mkIrAVBku5AB2l?=
 =?us-ascii?Q?xCrAO8t0/lwI0T00VUSbm4Gb4hUug67EHuide1aT8ZE/8TIUGU5NAURBBjKP?=
 =?us-ascii?Q?CiJpRzAi9YQWBwJ5+8C9UpMT01Kklq35cCmUkZHg2al08NMBycxKCM2JRSnc?=
 =?us-ascii?Q?71kCGCtPGvhEUECol6SM50G75dr63it0DzpEbDCH8oli3oSg+s4FF7Gmcezw?=
 =?us-ascii?Q?exdKY/rS2KJB0DygSsYWZZ3tQ44U9is8GiGqpD4HYCTQPaX/LAB9fh215OCU?=
 =?us-ascii?Q?eFi6+E2MtsGOOOfGwI01f2UYReHhcQg20tGI6NFElZ4u7QfVMXCRRgOUu0qW?=
 =?us-ascii?Q?BOXVkJW64vb/Y9ASXiUM650tZQmTPA+rJxOM8fTEZ1b5RYwGOgBrSbuMerxA?=
 =?us-ascii?Q?R4kQpQ41dJp0nQkKEqHX9P8QnXoAbXrp5lcqYcufp3b0PkWOKygaNf8ywh7r?=
 =?us-ascii?Q?7rL5jTNTrcX4SDDYZxYDisu8gGSJa/0h/0LlopHRgU2V4pWpliyAPlNw/Jad?=
 =?us-ascii?Q?GperpysgZxIk3Bo7F4p572vnlMK+pa5DQ2yLHuOxT+XGgRPE8kF9jX2KWF6e?=
 =?us-ascii?Q?59yzVYmbJKsjMk3txYa7ulrinjn5Pg0gCy4edV5oTgNdtUUdvYIoZ+1UpEln?=
 =?us-ascii?Q?AWOO3l1ZgWI3ELVbsGQ+pNQmzWJgqAd7WizQa3qf6haK4Eyi5gFB79brD5MT?=
 =?us-ascii?Q?YX3X9YImM4bzojFbUSEv6b6HN13JZEr2dX0+pWYuAzgL5Pva9JsWJb9C2CiZ?=
 =?us-ascii?Q?jGkRTE6rwHgg1Xvwwb61Swe5M0bioRQD0iU9636mYqy/MKosgetA+g9G+pJy?=
 =?us-ascii?Q?oXErtAmyeekvjWWGdvqbiY/Cp/q+SdEJFFllq7SiTILmXx/60OMrW/vF8gbx?=
 =?us-ascii?Q?JaUSAr8YPswBc3V0dgHUkQipJUIUb1qU5AxSOqASHnkA153zLQCCHAmpi7Vt?=
 =?us-ascii?Q?mTn0uYNOEePg8SCKLc9VZHEm7C+twUvodylRb2mEG9uChXum92iyC7073y06?=
 =?us-ascii?Q?KMQAjDYB7wEq0Dg1kWiyJ/3DU+bYZKWDI+Yb2i6S+TQQTKQU006MQ44h1Dn5?=
 =?us-ascii?Q?Xn/ir1KMs0cN2A694lQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93d865c8-375f-46d2-2487-08dcfdb0b59d
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 15:44:18.5404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vr9sQK7qR+dNtq4KJhTjzS2nvATqPkBYsutiLeiiL5S6FKKZz+BTpdtBiAZ7hRo0
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7701

On Mon, Nov 04, 2024 at 05:20:33AM -0800, Yi Liu wrote:
> The iommu drivers that supports PASID have supported attaching pasid to the
> blocked_domain, hence remove the remove_dev_pasid op from the iommu_ops.
> 
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/iommu/iommu.c | 17 ++++-------------
>  include/linux/iommu.h |  5 -----
>  2 files changed, 4 insertions(+), 18 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

