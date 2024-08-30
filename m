Return-Path: <kvm+bounces-25553-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F81A966791
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 19:04:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 47340285977
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2024 17:04:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87B651B8EB3;
	Fri, 30 Aug 2024 17:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="WGMc+XNp"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2057.outbound.protection.outlook.com [40.107.236.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1862D67A0D;
	Fri, 30 Aug 2024 17:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725037476; cv=fail; b=bezeb4nbKUssA5U9jJK1mSFSw1MldOWRVtkloFbyZTD1psVfk3xo619Hok29WqpyhLvAn5ZHLrGF9VSqHFAPxNBREyAlJeKueAblT2DANWwo+ZZg28rFcwlEh7l9LnSARi7BV5ffJEmIEtQCzOY+44oaqK2PaAI+dRGIXUh+vKM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725037476; c=relaxed/simple;
	bh=lf86LdoTzD8e7C0KJdQgL1W+GxTC4liQEOm57hTr+74=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Ye4f4pa3fGQoJtXcWVay5m55ECsHbeaNgbOE0f/CpDh1raEEjPKnuPHkZnprl8On4xasH8ExAikKDvqfvVeB0jBF9SRUu+zo/4lc6RJPhkCeSbXMogcpIdVNm00V3v4e8p+7U+QyyYzpJcXcA4SZScWpVzgmRB+EYL1KhNjMmPs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=WGMc+XNp; arc=fail smtp.client-ip=40.107.236.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ShnQ6YowapHu9kQ1bsjF3MzCDdfECuQZTFkCiO4O5Rt1oEzhxmcgzz7AS122wuoEGzQHjSB9UlsArIydPfuHua1nZni6E8lKsPlfvyMdKkMcNFP3q55kozR/1NKQMdYaGjrodTTX6gfrAZWEHEVPZn+Fdrx5J4O+73NJtlVWXFlQ6k8RX8N7dWbnEDXQ5v1wR7khD2skG4OZ7bgtIvHQZ4impKJhglaJjqJtnVnwnwV/GwojesLrV77WxcUu+9Jr4QbMJEMPVVO1IXzSfMUKmBMLAV6XaTs/6pmCdiiL59Xq1BVPnf5vnxVTASEP3HcZTaLwoMDIzQPch2yUMzQCBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=v76mt9ivoXJ21elSgahzdPDOlnRh/KKYsAiM79vh8e0=;
 b=Bg/ofVqH3AWQfKSmiUYxba89mhBaBUqUw8ozeaZx3WRpvZ7D4p4PfFsA0Jnli9cemILDaQSRD3g6Mi+42fIfuWDZk9Yfww+QEvuWzKJkSnFtNjCuE4q3rZm1wj3RM5ORUWZBJNoSYVRms2RTQFkv0EMgVHq/OE7bApWBJ6i2iiAP1YDIZXUawdNY4Ewh1zRI2j3RkxGVDHCr9NgorRo3RfHhtbhABfJNUOTpX2guRVOr2HDjdKbIx7bswvlAadrZNuvWvZbIweDTjVoJn8AEp/RfgAK7nEqzxnRc7z2TOCV13tiBzcXmOF8C1ThnmgKtcWUt+aceFi66dt5auVAgRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v76mt9ivoXJ21elSgahzdPDOlnRh/KKYsAiM79vh8e0=;
 b=WGMc+XNpZWUT2/fQ2n1pOuyFmrTDKjYrOpKkBxo+JYKzLnfJk1Ydrzy9kbdoBO8wmwuM2Sq0rxF1puCUCghECAzP4MYg9/nFqqjzfAXSl/jXxhH87PJJWQiDb4i1gbMs9yeddtve7KuQYmcvZu/huPJMoWVxu2D+vk4TFP46j5hoGOZoIUO8gzZa8IoQixrSEtVrHRjnpWxNheMrEURPDZ+CzYW3RFDbZ9zovW5+64IUsv8QYqHcC6Ly0NbP67NZJi8bFf4Mw20AJEwIR1VXzRTH9HEjw7iEwx68erTyQp3taTBLHVseFEMcmCB0AfTeQyLPgp6L6uZIX95BiF7SFw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB7763.namprd12.prod.outlook.com (2603:10b6:610:145::10)
 by CH3PR12MB9281.namprd12.prod.outlook.com (2603:10b6:610:1c8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7897.28; Fri, 30 Aug
 2024 17:04:27 +0000
Received: from CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8]) by CH3PR12MB7763.namprd12.prod.outlook.com
 ([fe80::8b63:dd80:c182:4ce8%3]) with mapi id 15.20.7897.027; Fri, 30 Aug 2024
 17:04:27 +0000
Date: Fri, 30 Aug 2024 14:04:26 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: acpica-devel@lists.linux.dev, Hanjun Guo <guohanjun@huawei.com>,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v2 8/8] iommu/arm-smmu-v3: Support IOMMU_DOMAIN_NESTED
Message-ID: <20240830170426.GV3773488@nvidia.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <8-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <ZtHuoDWbe54H1nhZ@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZtHuoDWbe54H1nhZ@google.com>
X-ClientProxiedBy: MN2PR05CA0052.namprd05.prod.outlook.com
 (2603:10b6:208:236::21) To CH3PR12MB7763.namprd12.prod.outlook.com
 (2603:10b6:610:145::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB7763:EE_|CH3PR12MB9281:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d2631d9-c04e-4c9f-323c-08dcc915ce78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?TaTwIfXlZHw+vHwQqx23DuJwq6Lys77i3HcftLgYAIG1/RPu770vLgohytLZ?=
 =?us-ascii?Q?tZz/huHN3WOrP+9Rr/yThJz9kpDCkDGHxoh8o0lICW3D1U/lP8ZjSWVwsyi9?=
 =?us-ascii?Q?vTsNwO3tXN0eHQU27EdM+U15wUmmVylw1JREufPD5Q0mz9gIvUnN7/M0/19T?=
 =?us-ascii?Q?t2NJKrZZarLCCERABGxLutB1diFQb5feXAnGlyq5icUi1KXWzuU2AMV4QlCL?=
 =?us-ascii?Q?xvsz5eBpIbp6vZfwjvtXcKlUWXOr38LexsDQSsAU65vq/C8HYpeuBHeV3WSg?=
 =?us-ascii?Q?prQbJznTV666aFbJA+nfFfWDjo/869xbrmr84HGqJ208B5onunAoegUjnyNo?=
 =?us-ascii?Q?y3vzqdLlWA9pHy71riFABJMaDXt99IFzkYnoEgYJFjPr1Rjv6NJSy+ABt7kS?=
 =?us-ascii?Q?YiywArAjOc+5tpIJ7wsnMLy/niBlAzIBJVBwpzJsSI8pC4ftdAtzcOlOzpav?=
 =?us-ascii?Q?CR8yygHrmzHwmcExg4kfYNNAZyNwdeJzSCUYiGQi7R07bge+tdkbkCmJwszm?=
 =?us-ascii?Q?cdvGaBEp4un687du/FHLdJJ0dDXyWRnHg+NO2nZ0wRObTzBj5WRYXl4t1Lhu?=
 =?us-ascii?Q?D3bpNSaqJp1Oqccar1RqNFkU8nUjnhn/NyPEMNvqfCCHJ3B73ixBmKDl+QSp?=
 =?us-ascii?Q?9XhHLE/Au/1TdQSTrBx+W+DDTENj4RGuWtoDNtgKI9QKkc+RYhnVjrK5SE3a?=
 =?us-ascii?Q?ptS6DnbFHrsDMFmmJc7alg8/GXlDHpOPggBVSsk4SVuhFS2jRmgBDXlMsmIl?=
 =?us-ascii?Q?dENlnN46BoioaMJDTOtuF+dLFNVbhrrlxO98YS++cwc/a478OaIuwrN/ZaFS?=
 =?us-ascii?Q?AMJz+/fn7ilhZtGzysX26au3mWnR0pVRdRR85q6ibz44jLaudiSUujAoC63/?=
 =?us-ascii?Q?jizel5lemdmE+dC53ppzdIH13KntSCAZdx300TtyDoW2PTnldOnrYkOIek0f?=
 =?us-ascii?Q?4AcrbA7fP8zfnavDez/bzbw3cLWDxBrdktdm1lYiBqUDSqYKWjBlpgRaX4rO?=
 =?us-ascii?Q?4nIdSHD8+6qvSH/C1JA2qyHS0kwXJeKL/CEqIe9FxKl9g0c8h13Vvk3kym6E?=
 =?us-ascii?Q?jGiTFyJuP9RVcpHrkQb9b98bhz6m1Y/+jthGGxbgTuMRKyz1d1h/6h8uit6T?=
 =?us-ascii?Q?7/JnHi1qnB9EJWH6eDEdIJEn/BsvDDhUoa7iA9G1AiGGho6ypo4pVNQ4y/Xc?=
 =?us-ascii?Q?6HD0dFTm/pLnltjzKdd45zdAO3GYkpmO5JkXHh8nevCKxoco8LB5kOqTQKzP?=
 =?us-ascii?Q?vDeBw9tsyPDMWILFDfvWGf1wclWUdSRP7Uihv+sUQvAwKufZ0nJ+R+TIFwLT?=
 =?us-ascii?Q?irq2+RG8TyDp70TOvBWKI3Dlh7C+1N3vf0n7FE/i07llgcvLS19m/qibUONk?=
 =?us-ascii?Q?PJlWQW8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB7763.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yvwH3E3+LkGU+wTRnoFZnFtbPw0b+ru2BU9xzMhr17O8FnG0UXKkpyPXNFTA?=
 =?us-ascii?Q?WmCXf9tt8o1RKZ6gjHDXxiiMuwD7R2WEij+48UowRJtE+cEufS7v9Y4oAa2m?=
 =?us-ascii?Q?EwdnmdklESx21kqe+OjbIZGCILgeWWr2W5s6o4E2R7l2EtBtIDz8f1f+XtXr?=
 =?us-ascii?Q?8uLkjkuKfkDPHejdpWcSTT+IbsY7sqOvj4nQH4HQZ2WNjEzMKMRFs4aljoBZ?=
 =?us-ascii?Q?KhkVBJx2RBmIz/2L1ep9dRwC22s/SSYtqgsp8MJj8WTY4fhK2ora7BvuzqkM?=
 =?us-ascii?Q?DqJhtQsIUZtHf5YMHiziYMEkNEaRCZnvp6ep9vSAV/Ad5K2SwL3W+yEasV6f?=
 =?us-ascii?Q?UfOIulzt47duzDBoGesHTJnReS/SZuWVyQzb5QoThFubdhSfN91dWCkXjtNP?=
 =?us-ascii?Q?V4F5fKv5TW4WZg0lvRacfAmzS0jC+Sh9gAyv3LaqrDpN4wgtTVV6O4e2i/md?=
 =?us-ascii?Q?FIIf6w8VxuCHU4yjKVyYQ/af3sjerN6oIqwVJjGbuI2cqqMag3YTx/1ARaH1?=
 =?us-ascii?Q?R94ZRRHZjqSwUUbRI9goFmvY6CBkTrKP32322bNuPxnY+vrkTup3Oab48Rvr?=
 =?us-ascii?Q?vBuKGWrhFEzluoLX2aG5QUYOXYVaLhhhkD2dYYFrUA9ix9B6Zh5bJMu2KfHo?=
 =?us-ascii?Q?yb4J7IDazSc4B8j+zDhzaKaYRb+9rVNbSCNCZ1T8VxzzwOCOLZp7+3ggkk0P?=
 =?us-ascii?Q?i+dS+WGQ+InR+2mM+AoyXwYTzrbs7zOmiG2lQqDsp1n8oPn9oiE9jPVNlYpf?=
 =?us-ascii?Q?R39vjdNNLzbomaZR/dNeolV8MLYMtgcS5Mg7LbnbbMy43tBH3kFziAc1w41z?=
 =?us-ascii?Q?A/TSXOcrhVl0HuYUN6Yq+XeaNd/+8uTjZtnVZJSYDZcgopsCEAzQzyYY5ool?=
 =?us-ascii?Q?cRCyfmcs4mUUFKmyagTHGh5+1QfIt8jszZmK10GKVAXWqBcU1jutqjgYqE8w?=
 =?us-ascii?Q?yjYCoK1iz2CbDHi3ThjGDznH4+EZsXzHkKeRSXFDGLvaJjw2G6CwjR2uZWD0?=
 =?us-ascii?Q?gHONAgciM0mGD2RKBA84+idrPocjNdgTi6FocIk/sCsjboxc0N6N/nJH+7d4?=
 =?us-ascii?Q?ThelAYbAejDI/y55/SzNUfMvlVB4xmrmkfYt4qobmPnZSZQwWbI8Mmu3UU6h?=
 =?us-ascii?Q?x4cmtgtKVvBVyXLZ1zyyCrId2I5xS0qFkcz03bq0yCRhSaXdWeUX9VL4ncde?=
 =?us-ascii?Q?6a+fcvp+94uncsvi+dc0pRgEGqj6Kps+a4cQ0hN+dLALD39OlS2M6wIRM9ca?=
 =?us-ascii?Q?FiNll/GrCUuIZUkzMqz6EUuebOXEhfXEHq0hKPQp//paTA29hCivSwveOwht?=
 =?us-ascii?Q?6GxvCAQ3IemdAnujiRjLqA9f+Xg2ttzFsPl9PC4EXSPPoJt5xWm1plx+gDJC?=
 =?us-ascii?Q?ckjpG84Du0sdfZAF+KLpedbxiaG8/24Y1bgoSgx2LtuDkC+P3WP1Qh3OYT8r?=
 =?us-ascii?Q?kR+VzK5M7rrzUzs//mLGO2WPD+9T33Tkw2c+jylM5D6uGFyASyfcNTviDWUz?=
 =?us-ascii?Q?DGGVNsuriA9hRm7ymyTbxODta74y6gkx853xsVHJQfyi35MNpmNeLnNs367q?=
 =?us-ascii?Q?KLN6tKuFmllCa8KepXWzvJsiVYbt5MdMiSBfIAkX?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d2631d9-c04e-4c9f-323c-08dcc915ce78
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB7763.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2024 17:04:27.6687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iP+Jcb5G/tcXG0EkUD+Sppmy7jFUvgPxNwq9ksZQi14aNRedR5RywLsdbJaF4Kf9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9281

On Fri, Aug 30, 2024 at 04:09:04PM +0000, Mostafa Saleh wrote:
> Hi Jason,
> 
> On Tue, Aug 27, 2024 at 12:51:38PM -0300, Jason Gunthorpe wrote:
> > For SMMUv3 a IOMMU_DOMAIN_NESTED is composed of a S2 iommu_domain acting
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
> > For the IOTLB we follow ARM's guidance and issue a CMDQ_OP_TLBI_NH_ALL to
> > flush all ASIDs from the VMID after flushing the S2 on any change to the
> > S2.
> > 
> > Similarly we have to flush the entire ATC if the S2 is changed.
> > 
> 
> I am still reviewing this patch, but just some quick questions.
> 
> 1) How does userspace do IOTLB maintenance for S1 in that case?

See

https://lore.kernel.org/linux-iommu/cover.1724776335.git.nicolinc@nvidia.com

Patch 17

Really, this series and that series must be together. We have a patch
planning issue to sort out here as well, all 27 should go together
into the same merge window.

> 2) Is there a reason the UAPI is designed this way?
> The way I imagined this, is that userspace will pass the pointer to the CD
> (+ format) not the STE (or part of it).

Yes, we need more information from the STE than just that. EATS and
STALL for instance. And the cachability below. Who knows what else in
the future.

We also want to support the V=0, Bypass and Abort STE configurations
under the nesting domain (V, CFG required) so that the VIOMMU can
remain affiliated with the STE in all cases. This is necessary to
allow VIOMMU event reporting to always work.

Looking at the masks:

STRTAB_STE_0_NESTING_ALLOWED = 0xf80fffffffffffff
STRTAB_STE_1_NESTING_ALLOWED = 0x380000ff

So we do use alot of the bits. Reformatting from the native HW format
into something else doesn't seem better for VMM or kernel..

This is similar to the invalidation design where we also just forward
the invalidation command as is in native HW format, and how IDR is
done the same.

Overall this sort of direct transparency is how I prefer to see these
kinds of iommufd HW specific interfaces designed. From a lot of
experience here, arbitary marshall/unmarshall is often an
antipattern :)

> Making user space messing with shareability and cacheability of S1 CD access
> feels odd. (Although CD configure page table access which is similar).

As I understand it, the walk of the CD table will be constrained by
the S2FWB, just like all the other accesses by the guest.

So we just take a consistent approach of allowing the guest to provide
memattrs in the vSTE, CD, and S1 page table and rely on the HW's S2FWB
to police it.

As you say there are lots of memattr type bits under direct guest
control, it doesn't necessarily make alot of sense to permit
everything in those contexts and then add extra code to do something
different here.

Though I agree it looks odd, it is self-consistent.

Jason

