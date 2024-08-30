Return-Path: <kvm+bounces-25532-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 666F196644F
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 16:40:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C525283C96
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 14:40:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D72B31B2ECA;
	Fri, 30 Aug 2024 14:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="irZkL+Y7"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2066.outbound.protection.outlook.com [40.107.102.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E2C818FDA7;
	Fri, 30 Aug 2024 14:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725028797; cv=fail; b=UQnWsmL0/B6U/2YC8tpOF/uUF+d3i+TpMBD2BOT/q+pd4Kd1MRoK5ZWrYFduo2Yr3mNQS1FLJSFAWI4rcj+OdRUS1SKIpdSd6DxoIGiFKGwr2TciRC0Ia0UNGjTVsJNrfXze4f3pYC1H6VKZfEOkGxJJ6RiSZDkuvooEDe+AQUk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725028797; c=relaxed/simple;
	bh=cAralcLKVkhLWPM8JSpMd22+FEW+QYiNva3C6WXanwo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pW4pxcdE3GmdnVgWWNrpD481wFlLLQRg9hWTp94CDm22m/s3m2gX9DfTbztpFrB+UetgGuUgsA2UbeaRa3aSPq7TpySIzmEBaWBzr1kui7LErHBq7sL7z5dgZDfXYrytW2Bg0PhchPRmXOIU6jBFNZyi387IM2cRkbvDzK1hOZQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=irZkL+Y7; arc=fail smtp.client-ip=40.107.102.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TJFGGjGK31OK2xGUdY9AL4/TfnkUbk3OqzJeQaBnVLCPk5sVyCLzW9WODl2bvpc8FiyHB30FDywtwpQXY67qE3GKyL9stNInQaXKrLx0AMA0LjTw0wrlZeYFl15zAEKYr2GKjFvJlBmUosT595mq49JJxCJf9e7tKkkDMiw/o7ZwyjwrlvAfo29T9xyLGZcwbXV1DRFHIY19AT109LN29mnBdN+VI3iijaOBzTT/pF0nsQniCGlu8+OB5zkg0dEp2ci04yP3wBz9VHFP148yqIRKUlbGUKasJ3p/tbbvizkuKVNkTECMuCHdz9JG7VsKwUjvf2PMcg8fDDikkZxRbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=If7ia5Sc1NMWmmHoDQuJH7NPltsitbR3DudHkWva5e4=;
 b=UL8CX5yS0tKoT/n1aQsi6CJvdt2Y2/H2nk8DVrEBAynlfCwBQoUa2AB82UzM6RyqSakBi0z7/7gvJJPCROXkR2LIEMMXI599mIfdlx24UDB7/4xCUS7SM1fXHqj1h/UrSr6W7lv289wTJX9szxVYJJxWPYDmkyMFETaLr2iwrWsz+pI2Es9sWT87AOXCr7XLB+/+9kSy3qElalcr3xbLgPmSwf5WcafKecbxzxMUTrgHElWIUreqhDDkhEJ0G/zKwkpNbJJcICD6sD6lXK7iw7LX1UI1CywdrPR911HMbyVi1v4Us+As5KiWSVSoofmmZlEn2oiqH+GG2SnQejFpwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=If7ia5Sc1NMWmmHoDQuJH7NPltsitbR3DudHkWva5e4=;
 b=irZkL+Y714uC7a7dEJDpHhm5p2Dmfjnx40vSc5VsTKAQJ04JB2PSx3MBF8cQ/mylcMOQUfnFBiICOYPGr0x/dA/g+Pd4rQTA/OFWStiO/J40ghY2ErEBYu+2SN1xETPYhS6IaqYE5R3PnZoeRszAAQWSqnngzpUYdXDZI1xtC1VsbVI/fYdEToDyEFy3zMRYCnuN0007F4LlBdueS00OfkIArQtK8ODPZuZiQ/6EblUL7qD4EETPy49aNXAlyGiVj0S+RBbXNOzxCv3UV4C5DdRzoGT6W6mcLTadeHpVK452kusPnzkl/NOI1SYTB+NlEQOcneCP/Gh9X7OMTXhChA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by CYYPR12MB8937.namprd12.prod.outlook.com (2603:10b6:930:cb::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.25; Fri, 30 Aug
 2024 14:39:52 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7897.027; Fri, 30 Aug 2024
 14:39:52 +0000
Date: Fri, 30 Aug 2024 11:39:51 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: "acpica-devel@lists.linux.dev" <acpica-devel@lists.linux.dev>,
	Hanjun Guo <guohanjun@huawei.com>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	Joerg Roedel <joro@8bytes.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	Len Brown <lenb@kernel.org>,
	"linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	"Moore, Robert" <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 8/8] iommu/arm-smmu-v3: Support IOMMU_DOMAIN_NESTED
Message-ID: <20240830143951.GS3773488@nvidia.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <8-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <BN9PR11MB5276AD532C8F43608A8D30048C972@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276AD532C8F43608A8D30048C972@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR14CA0022.namprd14.prod.outlook.com
 (2603:10b6:208:23e::27) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|CYYPR12MB8937:EE_
X-MS-Office365-Filtering-Correlation-Id: ae4ff7c0-b099-4715-2e17-08dcc9019bad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SiqOf3wICkspsF3SHnuL88+vp/csrezusGIh0e2dP9vnP6RioB/w7f6o8Joc?=
 =?us-ascii?Q?owPNkjoqQ1TbsiWtvP9872I5igoMIeaY1MUp1JD2dzI6+soXQMrop2NO+BnJ?=
 =?us-ascii?Q?YYxZ5lK4ysLqOGUVOflRouowKCinhd0iERJWP5kxx6IaVQPyaHbgeKM2bOD2?=
 =?us-ascii?Q?IblNGCVzTV4ouI7bmjwhJgWcLMpR7JLymAtQzwhjZ9M4RB+BQ1tgUJj1IUwS?=
 =?us-ascii?Q?xHZzaMi71XkS+Vw3CjTRqVHSeASqF3PLFUnywDkKcZu1Das9zlziVmnI1eEM?=
 =?us-ascii?Q?hwSaHXT1VUuGOuBehwF3LsQCPmfK5Pcz966+juenKMF2ib++GJ8jwBmYhrv0?=
 =?us-ascii?Q?VYjrBOSJGvdiRMnx+AlFDrmEIunCvsLmH2UCoy5cvxnEygqmxEdJauSXhWhK?=
 =?us-ascii?Q?uPzen4ejDXiuwt63aCYwvBn/kciCslFy5rbpgsOGGPwGsOMQqdBv+Dv1AD5j?=
 =?us-ascii?Q?Q5qI6edTiCNe51SLhGa3VIkOOVxDeSfTY+adDS8l2d2SEEfcxBN0K1kMoGv/?=
 =?us-ascii?Q?+cRrpXVuOv5cub0pyGnrEObN9ZGWJkbNJtRXJqaenljN9mqKiLDpg62fmwtr?=
 =?us-ascii?Q?CLRa1lBQNJgZWTAvMRwipDvr6TeXOyERfB7CzfZUGEVYFmDqLn4YI5Tce4RS?=
 =?us-ascii?Q?XZS927HJKR9mJ4WeaHA/c9XkPK3mOMvHnJVbAdlN6BtjykWzaGZx2IQTSjcx?=
 =?us-ascii?Q?E4AH1e0FPcIKzdPyOhdYPRkeiRnC4jf3CnZs0tbGNKDrQfrqniq28igz0BKu?=
 =?us-ascii?Q?x9B/2LNg4mL+DxLI9+Dtsd7/COa8tPVt22r7eU0TDUh34lSurnAU3w2isfQT?=
 =?us-ascii?Q?SrWNCKTy05+hRAr/hCcFd9h0Y/vrmjk1buo5+Gi06AjUJHVkkP9YWqZEtD59?=
 =?us-ascii?Q?DHEdzUCdKfvDM0BeeWRe9xoSUbp1wKD5RtYa7FJgd7nJ+FpltKqBanO1c2oM?=
 =?us-ascii?Q?Odsud2W423EhsaZsDwE+CWJW9/L40fyj3iR1uUFvg9qmWT6lnEsgR4/Zok4b?=
 =?us-ascii?Q?IgLGgGBzWTq9v2Z39xdpzTG84rTUoLNpb3GyFXCW2VKSNIqOYTjZkS/CL4o5?=
 =?us-ascii?Q?u9DGQNTuBSmfS9xMTKq0zWvTUdsMZRe4vfy5aIM6G064uoXRrhfs0fyjw3AZ?=
 =?us-ascii?Q?SjYgE6IK3hz3vaOXLjwhQLZNNpWa5XOhyShC21KnF7qeZYYTGJ/3r1QXNAvb?=
 =?us-ascii?Q?rOjEZ7AOStRqaxeToHl+HXvg4ehsgPJES8bYIkzXUZkef1Xlq+m35gJS4llP?=
 =?us-ascii?Q?qCvQLdF1AIum8qwbI1TANpCZoZxEJMWZIxMLkUQpOzYNUZq4O3/BuBSJu5nd?=
 =?us-ascii?Q?HtdFAmq0rajni1cFwmPNrOw3FQlXpC/J3TxUWFUBP0JFvg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MRXCoOnlsjel1D2aoxaFZKEgxbm/vFkLaCT4R2KlY4yfMSXIyn31PP94eCdo?=
 =?us-ascii?Q?CfmPwp2eZKoLxtTwd04Na0rAR6g0kWP8s6WWiXrSjp7Wbs634ci/iwwqMF0D?=
 =?us-ascii?Q?RUpMWOMDx02CbBBU353THHcimoDQYdqA8PZkJaVRpyzoIh3kXZ0APskvAGRn?=
 =?us-ascii?Q?oJCbVL2v+g/x1yp7rP1Z3ld/R4ni3uWgkP8rQ5PGSrDsik997MQsc6xRX8GE?=
 =?us-ascii?Q?lGgT0VRyToD3DXn5YF6sXe7Ld23mJtIITnDwcejvzP8B8Usu6vHntV8rU36g?=
 =?us-ascii?Q?d+b5nwwgXm6KMeR6OMqiqRSM8LYIzxw6mrxEaoC84+Xp4xuVxh4nVyfQ/HD9?=
 =?us-ascii?Q?Cp+6lRIXrRLgNn35dCwJ8mgRuwef9+C6KnDPw8dVX9kjIU8+psWAi1fAah4N?=
 =?us-ascii?Q?FA560OZKksSRuxBbqmmc8c22qLB1hJFWZESUOQbEKiWN4WZBhX+D83gAkjBu?=
 =?us-ascii?Q?81dKDZ9Z61esDOxInqw0ss7/TRsrPKEagsHVCBuJGqbMnk4hy4YEorTHV1kR?=
 =?us-ascii?Q?vq0BkVkZZ+MHgNr1zTL7B1W8MaKR0IA9/jMcw0nvZ3XD+pz2kY004hHYjys7?=
 =?us-ascii?Q?nOwbZc3oRGfYbB4N9Zurw0zmn8xr34XMQEGKaRP9G38ioXGEYt2vmfHT3GSA?=
 =?us-ascii?Q?eTXmrgtfsuFqoD09py8pSLXnDLVEhIU7ivjF5N2Tsg8vVX69Z0gtVaABS9oa?=
 =?us-ascii?Q?UKqJH8+itQzM2L0+n7+SHJCjcE/+eUNqUmMxybUQem9/SgWgcYSHhSns/WB9?=
 =?us-ascii?Q?q2PWI5192KGSsjFdqpl1wojCwQjjSmksfi19/wShhBPU2slbQcsxm+9k4BJB?=
 =?us-ascii?Q?QkoccXb02i+cO5lcj9IgZlQxlCSUbKBVMKXGeANfw7BHtmBpYq9NYtZrm882?=
 =?us-ascii?Q?yCJmBAdDfAzlKD5J3d2cNlL8tnyaqivsarhWSfclaLige4o5ckh3SuFmI44O?=
 =?us-ascii?Q?y7x0uSo8g4ujus7NiOJhvoKiyttPN2CAmJ4K8s5srMuPetBaYjGDQKcJwqJt?=
 =?us-ascii?Q?yaIxCBLYrnJRQqSs+z4/rzKucYq90QNMsxtcIVDTO3BkUf8+lpk7cjqFizmT?=
 =?us-ascii?Q?YMzi7FsLz5CjumdxkaVMoF+8jKvY5VUBpHPpym3xcrzGSw7Tg1XA7P0nzcBx?=
 =?us-ascii?Q?KoA5cy43srLLelvfbDfpUYgecfW90+sNg3ndzWbWhfVdtEY1kp1jBdTjKrKC?=
 =?us-ascii?Q?AOc00xjW+hfNpWczZDDCR+5xbYF+NDALlr1CIa9wXFtPvO3p3LiMC3ikyt2W?=
 =?us-ascii?Q?RWLQw8aaHTkrn4kN6jvKYHq0ovWRjbs5z0zlxVlsE1om9Fj11soLJgq8Uqzf?=
 =?us-ascii?Q?kHqBEkbYjD4XPDvwlfUvpuSe4S4qd4zRtAlab2OF4lljGPtOGuhP9dEVZCEn?=
 =?us-ascii?Q?Kbf4Ew7tTaxHxy/FCvO4E1AHVF2FBgWdvprhdo4dMg0qyEmT6hc+UkjXJh1a?=
 =?us-ascii?Q?MdrAxjxrM317num5V0SHrwSuAgW5BCoZv5o65Q0tL3qp5klQ4P3KI5oXwcrF?=
 =?us-ascii?Q?s9ZOAKpahUXDDwO+rSMFhA/V6zrFB3KhBnE+Fjeua+vSGuya3YjDih1MVpNj?=
 =?us-ascii?Q?utq8BFSwGNYKEqyRnN7zLBQvijAJs9QDd07LpaHA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae4ff7c0-b099-4715-2e17-08dcc9019bad
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 14:39:52.5113
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /WkHwDsm+NHqgImkNDwC3IYnEDj508U0w4kkzr596srGNLD6YZNwNeQoFaXpkD9f
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8937

On Fri, Aug 30, 2024 at 08:16:27AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Tuesday, August 27, 2024 11:52 PM
> > 
> > For SMMUv3 a IOMMU_DOMAIN_NESTED is composed of a S2
> > iommu_domain acting
> > as the parent and a user provided STE fragment that defines the CD table
> > and related data with addresses translated by the S2 iommu_domain.
> > 
> > The kernel only permits userspace to control certain allowed bits of the
> > STE that are safe for user/guest control.
> > 
> > IOTLB maintenance is a bit subtle here, the S1 implicitly includes the S2
> > translation, but there is no way of knowing which S1 entries refer to a
> > range of S2.
> > 
> > For the IOTLB we follow ARM's guidance and issue a
> > CMDQ_OP_TLBI_NH_ALL to
> > flush all ASIDs from the VMID after flushing the S2 on any change to the
> > S2.
> > 
> > Similarly we have to flush the entire ATC if the S2 is changed.
> 
> it's clearer to mention that ATS is not supported at this point.

I will also move all of this stuff to the ATS enablement patch

> > @@ -2614,7 +2687,8 @@ arm_smmu_find_master_domain(struct
> > arm_smmu_domain *smmu_domain,
> >  	list_for_each_entry(master_domain, &smmu_domain->devices,
> >  			    devices_elm) {
> >  		if (master_domain->master == master &&
> > -		    master_domain->ssid == ssid)
> > +		    master_domain->ssid == ssid &&
> > +		    master_domain->nest_parent == nest_parent)
> >  			return master_domain;
> >  	}
> 
> there are two nest_parent flags in master_domain and smmu_domain.
> Probably duplicating?

Including this

And I will rename master_domain->nest_parent to master_domain->nested_ats_flush
and it will derive from nest_domain->enable_ats.

Which I think will be much clearer..

Thanks,
Jason

