Return-Path: <kvm+bounces-9985-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E7618680CC
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 20:20:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9D25CB2D9DC
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 19:15:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27C5212FF71;
	Mon, 26 Feb 2024 19:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rFgi8hsj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2084.outbound.protection.outlook.com [40.107.93.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D2B1E4A0;
	Mon, 26 Feb 2024 19:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708974747; cv=fail; b=p4ufowPWJ91DWm6QABjp/lfgM4GWS4jyGgw443qmEUAN6kCYUhi5zQ6p6OB4j42lRV4YNODG0/4mEblKcA1po3JLt62X7ADE4H0yDOVsVqrIoKyXzx9tGtej7iIFFdzMPfYJZieH5qTfWyFKRQIUoSgVlzXWYiA5GDVKn9s27y4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708974747; c=relaxed/simple;
	bh=wrnDA23CZEACNg9kmNV+HoHpiTM9ek1f2uigq4awNI0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=cRTDneA+Yk4u4m5HXmOOrW21bu2WtAuhePXLNO7HHosx+YZuZfd7NgSYyPe7klhce88mNShy9miXzEn4mzBCr6PYDjWH26RPuAN/OgNtdWXmwo8gvX12ZgfsQwruPd3pc4PQmgnRBx1752KSVabTe09/9OS4DZrTL/t4DsF9ml4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rFgi8hsj; arc=fail smtp.client-ip=40.107.93.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QRBA86K37oLsrdFtBb7JHYP18uPHd/95QlnIxHwQrafLEmCQvHFWySvojaiWv2tKhjdakFdKFS8OYjMDKVJhWecYdrDOHSxZGg/DQkI0T9e327h91Qcu+0TC/HQxT3xvZFiFkj6zYS+nAcDB/sjneYfDbyhgaNWaLwT/z8YLaPIKiUILsiO11CFS4qpX3Po8AGpI+8BIeHygpNe/ZwyEP/d1u9qUO+Dcaiq14rqTbWLkQ5i8LKrfAexBQ4d3frjWlMNp9mJcSeIYxSmL2n0AlL0tmtQp46C9jik6uAbKa1XoDzVlaWhZfYPTrMFPEJwA3UM9Y1MJRXVIPznvuzdylw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rTCFf7kyjyyfIT/CaweZHovtbyrjFjSYlJ9dZM1SKjY=;
 b=GVRN4pdylfTBfKXKOAKx16FGDqVdehSlwfCet2XP1lbTLbPflfBO914rJAesiEUMX5GdXoZOAEtvCuxp9TCVSHJ04XcsUCtOy7FWznfTI5llW71b+QmAWZNFYwYEe2EhoVx591lohw51jSI+ii//AeMz+OCSdxR5V10UEqAu+vsSpI3h18z6TLdGPKSKnAcrK+HB5f0D+3h2LGLq55ZiPyk+hUworeiwr1j2QGYehCHp28z6o9KiS42EsxYDHyaJQl3yVl3S2jLakfUkplWAPO5EeCCj71aQPP77SoP93vafqZTNEkTNrzDaY1T9lilRZRR+KALcZ7LTWl0Oxe5sQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rTCFf7kyjyyfIT/CaweZHovtbyrjFjSYlJ9dZM1SKjY=;
 b=rFgi8hsj+L6B5ifXjersVGgXwqIuv9Hmrvcha8OGKcET5uRbEoR9qVGOwEyZhvVynC0YJh49kQ4I9IeiOadttuE0/V24W6RJftgpEXjBnwgofqhWKa2hMdjXjHcYHJ4QUufxG6/U5Ac012CmrxXibjAe+KqE863cOIqEiogiXYneIMWriiObeM5l3pNQNEfuJuWbYeNzqETt06oAI1xl22k3P0PLjIP2vwbtPZgrT9HAmckgfqtHHah8VC7+TGPAQWKhXxPbLyyRDv2J8riF+CJWRuqxYLsrQq/X+vGj3PvDlnh/o2B+dBomBYlxwC/15ZnXTvs52rkfRA9/Rt/xpg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by PH8PR12MB6940.namprd12.prod.outlook.com (2603:10b6:510:1bf::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.27; Mon, 26 Feb
 2024 19:12:22 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::2e3e:c7c0:84da:3941]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::2e3e:c7c0:84da:3941%6]) with mapi id 15.20.7316.034; Mon, 26 Feb 2024
 19:12:21 +0000
Date: Mon, 26 Feb 2024 15:12:20 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Xin Zeng <xin.zeng@intel.com>, herbert@gondor.apana.org.au,
	yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
	kevin.tian@intel.com, linux-crypto@vger.kernel.org,
	kvm@vger.kernel.org, qat-linux@intel.com,
	Yahui Cao <yahui.cao@intel.com>
Subject: Re: [PATCH v3 10/10] vfio/qat: Add vfio_pci driver for Intel QAT VF
 devices
Message-ID: <20240226191220.GM13330@nvidia.com>
References: <20240221155008.960369-1-xin.zeng@intel.com>
 <20240221155008.960369-11-xin.zeng@intel.com>
 <20240226115556.3f494157.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240226115556.3f494157.alex.williamson@redhat.com>
X-ClientProxiedBy: DM6PR01CA0020.prod.exchangelabs.com (2603:10b6:5:296::25)
 To DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|PH8PR12MB6940:EE_
X-MS-Office365-Filtering-Correlation-Id: 964b8bde-a286-41a3-7b9c-08dc36fedbb5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	qZ1eNr01hno94TIlp2pmCoVr5Uw2RdPyg3afSKhlRlfRsdqef9BzaGmJ34hwDH08Jr4ONc5a4IV0yKg17RaEc2cnro8zu/ElTgp+QPtV9GpUNjiXXXTSVnXneafHkWGybZHFGQ2J0O/IGS5ilZforU7gowZ034j0Sedu0L1ZUHPwXH4bXkZjSiCcXIJIwN6BNCrUDWkbtaCw4zqTiG5dVk2BU7nDi+S6tfHEWxcuWEg5jprPho96MJ1upkDrx3ZXkI4YGfe5lPinIloxfuSYZ/qOZuDK+LrXFUlLhsluQEuDUvl/Qm9NacgvwbxawEKwHTBa+DqQuUuePtXLRmnDriliWd16DLn4lJQhWr9Dk0Mu1GCNYwPMPipsa8IloXrtoYcUOnD0Uxotrriwbk0rHHacSMpyqqwaOnzdKjG90TBuLIhm3Y1KJxOlmYxOjdShLDGs9eMj19aaHgY9hknG+ie07rqNqpjb2JbAbokG12uAztKXkHT9RZ2KvZY05nGsrimM7RlS01xS16sgw2CmwhfVvAc4W9E+LKsSvoncxlDr+jt6sHIEJVa8ncuVK3+G2QHXlkJd83Z/jDS0gOHOCdVJIB9o5MDS5su75m7aj0R04ZSY8Y7yIsVQXNMSVSJBXVqW8TCHA9wvrDJWN9BDBg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?v7OPfwDPNM+rw9hCcWBSBp6Vbgc8i+kM6b4/G46I8GqHROVCV6ukj9Bpi2ji?=
 =?us-ascii?Q?EUfAedGCMTUOAh8f2jgu59Y74gZtmFUVb0wcJEjXdso4f6jppFieUKMYvcZW?=
 =?us-ascii?Q?tcGFCYggOz/VKP0uekP1TCJXnEiV4RbbTHfkfV6hOE0Ee5/1wXfgntuWQITQ?=
 =?us-ascii?Q?2jfmrAs4nPG7YmQZKm1TM/ei4+G8NleI3IdLf2GZo+rRVRjx3bTDgRlS6fHL?=
 =?us-ascii?Q?PbaBcFtlBkQLOMt4MOGpyONxD5IBQXnWmOo72jz5GT2GAJcxYjK+xJH+4PeY?=
 =?us-ascii?Q?k7T/KuEEefZWoFH4ijt+Ej/6Gj2GJvJdwi0MZwh5+jJNztlTPCOksCkAjff/?=
 =?us-ascii?Q?EOWvw62BE5KGuNv5ckkE04vcetTtAXxQMutGm0X0Ht/G3/yBcK9fIU9k0pRi?=
 =?us-ascii?Q?jGHFSUYabrVGun+2iDpr4jK2g7rkUcppR4SbXDB/GQ5YxX8Gu/iCzBYETN4I?=
 =?us-ascii?Q?qXJ+mOIstBGfuSaIOmEglIZh4CZux5L7OjP2Had0JWRk9MlXyJjd5EQ2H3Lk?=
 =?us-ascii?Q?xTVksvz1mumnoLW9e2iAR7mQUSu29jceijL2fpKBFD8X9DT4y5a+WxTa4EcH?=
 =?us-ascii?Q?aJVe+ch1QTvjVxhPT9nW15BEj6k5ZdFF5+COaU7/bAlXjlMCYA2A86qa1Oxi?=
 =?us-ascii?Q?Ngdwugt6IusLXPGS2nude07gYK9bQUFZhdwzvO4Cmyf47t1d/w70Tn8tl9XI?=
 =?us-ascii?Q?XE7LqO83ehCRgGteIYGvNWHAJn+Qa5B2IWpKxK3UWsLpCV58lc1AAu4HOC+Y?=
 =?us-ascii?Q?/L3yH8v0jKDW5kfe+rnXA3KOB123YhgndZZgeyLflIMxQu8LIChhYIStLVna?=
 =?us-ascii?Q?Yxqr/eCQZU6FHR1Bc7Lvd4rFdaqMSoxNNpoeJOp0PNMs1NmGkBQr2UGXnVn2?=
 =?us-ascii?Q?bXdx85gf0VYn/5Ofk67tyRRlDrV1EBQwlyFYEcfM4KFZveYtg+wcgB3k5zcx?=
 =?us-ascii?Q?dgKbig1xc7JDWk53x85EfOhOrm/X3+x60pKGa61H/Ye5vFq0GAqu+JmdgrQ2?=
 =?us-ascii?Q?M2+BbmpvP7O21uVKUbKqbDMr4cMIzxCdoms6fhwT+h/RksguU41p+v4xfGe4?=
 =?us-ascii?Q?hkVichupHYCsZLzEQecE1fV2zlN6Qa+yvB9PshhMVWOUiFSjrXAyNcJ9wpTl?=
 =?us-ascii?Q?TD3nAQPxwrTgBGhND0yVculQL/8L4a69EBIovHvIYRVV9KMxMkOjpuZVwscF?=
 =?us-ascii?Q?n8g1gBdvc4zE+bVQ7K7lAHBRZQxMmkNTQNEIJeWM7OsL2Z4XJ+8lH8v76SdW?=
 =?us-ascii?Q?mmAtAQ7H/r+flws6MM2Fd5kGoGUW/wOQWWdeYCWrmesJvmXfTlaViDcUJ1uc?=
 =?us-ascii?Q?ZGPGdGrSgX2U7Nt0pmSQbt0QMLRQH6MQpzSf7DPQFgl+aTJi71VpkB7sZbpZ?=
 =?us-ascii?Q?NzsAHeZMCm59NoiFJCiL3BQNDXsFuKPAI1hDfNQbH7o7O2Fv0i1o6SsOLJC5?=
 =?us-ascii?Q?m9zMPhE1cv4NsxnllXlZUCcLtJq7d0wMVLIKYHwGkKjVzRFZsm5uFzTIrdrW?=
 =?us-ascii?Q?vDM3GEKyXHc7wpnhl9q6bhi75mEmz8rmtBJ0c5MuYTny2/sU/G0nMVSnXFHP?=
 =?us-ascii?Q?sP0OhPJbWDYrIadnGAaXy66XURBZ3vHNK2oiuTTt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 964b8bde-a286-41a3-7b9c-08dc36fedbb5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 19:12:21.6787
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: py62IEa95OsVRUXEXRQw257WGYN+ooD7nFY0XDaKOfJoY/dgRhYD3Xl6ffy5GzZX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6940

On Mon, Feb 26, 2024 at 11:55:56AM -0700, Alex Williamson wrote:
> This will be the first intel vfio-pci variant driver, I don't think we
> need an intel sub-directory just yet.
> 
> Tangentially, I think an issue we're running into with
> PCI_DRIVER_OVERRIDE_DEVICE_VFIO is that we require driver_override to
> bind the device and therefore the id_table becomes little more than a
> suggestion.  Our QE is already asking, for example, if they should use
> mlx5-vfio-pci for all mlx5 compatible devices.

They don't have to, but it works fine, there is no reason not to.

I imagined that users would always bind the variant driver, it is why
the drivers all have "disabled" fallbacks to just be normal vfio-pci.

> I wonder if all vfio-pci variant drivers that specify an id_table
> shouldn't include in their probe function:
> 
> 	if (!pci_match_id(pdev, id)) {
> 		pci_info(pdev, "Incompatible device, disallowing driver_override\n");
> 		return -ENODEV;
> 	}

Certainly an interesting idea, doesn't that completely defeat driver
binding and new_id though?

You are worried about someone wrongly loading a mlx5 driver on, say,
an Intel device?

> (And yes, I see the irony that vfio introduced driver_override and
> we've created variant drivers that require driver_override and now we
> want to prevent driver_overrides)

Heh
 
> Jason, are you seeing any of this as well and do you have a better
> suggestion how we might address the issue?  Thanks,

I haven't heard of confusion here.. People who don't care just use
vfio-pci like the internet tells them, people who do care seem to be
very sophisticated right now..

Did the userspace tool Max sketched out to automatically parse the id
tables ever get completed? That seems like the best solution, just
automate it and remove the decision from the user.

Jason

