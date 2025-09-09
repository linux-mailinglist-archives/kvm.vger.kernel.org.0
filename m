Return-Path: <kvm+bounces-57104-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 985AFB4FA7F
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 14:19:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 387CB441BD0
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 12:19:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 440E4322A3B;
	Tue,  9 Sep 2025 12:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="bo7JAqor"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2044.outbound.protection.outlook.com [40.107.93.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C510B2C15A8
	for <kvm@vger.kernel.org>; Tue,  9 Sep 2025 12:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757420332; cv=fail; b=FyvGYAxaDdeKIpUTLfe/H3OwdNTYk/Jt/iYvjL6FJ3L68PmH3n739QwRxpEN5YD46s9P47N3PFDlT5Nbv+X6EuIryFdaQvanE24kfPd2EB1BjTvRN2rwMgmlfP79BbL3TEUJ/FrQww+QUj08N3ZxRI0jgZot/HgTj39SqO2X5O0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757420332; c=relaxed/simple;
	bh=K0mqeOV+nkHU5LQyoBCkZr1uI7t4rIWKRQO6PP2RiqM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=FLqsyOjKV+WZA/Qy0Vj8iG8HvbCrtRgBpjY2+URmVFfu7cANWvMa3E54hRAesWHGzwSzW0mTTy8k/O5U+/23jnPJlRHlQlnbnj1t2aMKkAG5HMnmUEBpZ47WisNepI4y+rQtPQxL/iVYYveT+nXVmetnpSbXEjWnnJsb0XLzQgc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=bo7JAqor; arc=fail smtp.client-ip=40.107.93.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PNj9kUtMoErlJFZtXsHP3fiWUaqwPLznStJ75Pn8kOZFFdDRqv/t/rvoSKJvAj0RhWOO+8/IPS9jweX2dc35GI4NizSXaPJnKrrk9pvrVnbfdrCm7rIr/4e3E339eDVqy49nNyscuQw7HLMs+LMB/rZMmq9Gj/j2vDYX2ptpc17PGoIulsMcx+pc9LecB4gXrhF2699YYgCFIOgxgo7hrNkvrVwlSWsoXOGT8Bn/0rMas3q6igp/O53p3Aj1Hs0Mv597Fm8GBTaZviy3daim5dis6kNGm9Uz3je8yKqRbkzy3ekQeUzjuwMxsPAmMUO9hxralQqBe50vtOEkRMY+eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WVCOGvZ5b5uUBSnjwe3m9l+f/P+cLPmZ+s25le3XI5k=;
 b=HjEIR5750nG8IfqH11nptbnYx1MR9C6N7PRPzCcfrnaIGhX62Rd69D2qh43Sr79FXTudxOGpNYHK4ScBh0MePDDCFShmV/cdnR7vEKv/YbdvrU2KRd8NHVvVCWdIRc9QrgR+vOsd0ge11LRKKcEvAWuZAncHuaV7TTulIp1fyC7C86zeRHKrcgfZlZBbb5eGvBpQ+XvKM78oNcIdZWKm0kXE2BXFGrK+cEoLZsB072BoKGGcpmQIdMFwsXsmtfOvEqhO46fQdjFMwt2ZmqyLLw7Esmd+AmabC1fEUkbc57EIa1mAFN5srFsQ9sIIOkkzfGInnVmUi79+km1C69s+cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WVCOGvZ5b5uUBSnjwe3m9l+f/P+cLPmZ+s25le3XI5k=;
 b=bo7JAqorrV2kZl3IQdFBZNX+2nNX9hPveb/HuuFhZ16Muzi053mb0lcQ3ihxC1GjS5EcwsqZwl+5VyPXt4y9CVOrlhPg3UEMMroI5sGew8ICtGeVM1fWA+9iVsoxHU86f2MQVjddsUbNbZZWAu1LghcV401AApAQAt6tI8SvHPDGyWMq8mOMaalLDnRgRK6j5BKd5kWFn1XhRBsVeYbKowOiC3FN3xiZZ2S0UyaolOIHwLxNHEJS8SWgfHel0ublwJjxv0xciURbK7OMdxDMSkV2FO/24X5Ud4NPy3nlb6d2m70D0Gznn3PYg1o9AS28R06/ozCHUeTLgGw2cJQLjA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by DM4PR12MB6061.namprd12.prod.outlook.com (2603:10b6:8:b3::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.22; Tue, 9 Sep 2025 12:18:47 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 12:18:46 +0000
Date: Tue, 9 Sep 2025 09:18:45 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Donald Dutile <ddutile@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Lu Baolu <baolu.lu@linux.intel.com>, galshalom@nvidia.com,
	Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
	tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
Subject: Re: [PATCH v3 03/11] iommu: Compute iommu_groups properly for PCIe
 switches
Message-ID: <20250909121845.GI789684@nvidia.com>
References: <3-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
 <3634c854-f63f-4dc0-aa53-0b18c5a7ea1c@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3634c854-f63f-4dc0-aa53-0b18c5a7ea1c@redhat.com>
X-ClientProxiedBy: MN0PR03CA0023.namprd03.prod.outlook.com
 (2603:10b6:208:52f::22) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|DM4PR12MB6061:EE_
X-MS-Office365-Filtering-Correlation-Id: 01717973-7155-4035-00ed-08ddef9b0676
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?t/l9x4V+sZGLUCpC+RLww5IDWStlmEvt9h8Tuh0r9xPVPhsExN5hpZ4k69r6?=
 =?us-ascii?Q?UOZ4Xu9BuA7FgIfpaKs1k/lKkZ2IorkVedbSsZ0D7NtxAYDYIOqPeFEPHSFd?=
 =?us-ascii?Q?IruPNbpS0WZlcuNH17X5cs/vIQX5vPqXSlWw2HukNVe2eqrcL4ZDR9VVQ+Dm?=
 =?us-ascii?Q?jMHe7/jaITAvXBy/XGMTpqThZWwxH/UJhrLgaNLzj1tTgmwoekcYct1mJO9d?=
 =?us-ascii?Q?V/Wf49Mq1Q6SN0TyHnjBdH5Z0OyceAq0BduKWkteVdVCpE4abjwbEjr8JQr9?=
 =?us-ascii?Q?SFfuujebd9NZZA8sBfVFEFzgbY/OLOVMZTYHJBfkBby9HC01lAhLE0o75DzF?=
 =?us-ascii?Q?5SreVBaAQDEoaUkq7Z/Z7ey3WRnxfrFYG8AGXqcbd62wsALwYc2ZXNHAcZcA?=
 =?us-ascii?Q?4SWj6RunGa8fXa8+vnCuT61Vpgdwpq+5MjrsvBzcXF5ZL7uhZhlfk8Lrgv8C?=
 =?us-ascii?Q?XkxtXISpqfxRILwasYxwlaDxvnLQY+W1kbtvqbJvkjz4iC4VgAvUYib6bNLe?=
 =?us-ascii?Q?ZErTladC42Aej53CEkXQqtvlQurX2W97Mgeah5jqGjervth6tSvSAPXIfjOo?=
 =?us-ascii?Q?yjGzBL0m3pjyzHyFWXe1jF2W5Vg/45JKrBMGClT6Ww2yZLUYxyp/HiYz+QkH?=
 =?us-ascii?Q?h+X8tuZwI96rmazn94Sl2mVr2cvcMAiENUoCM7t8+m9gddBIva8LrxiXSL5a?=
 =?us-ascii?Q?Di2Kktnlg6WJbTO0K5GI/wv+jWjtmnrXVnHB9g8KZONTXcHSamVCFVH5iHoA?=
 =?us-ascii?Q?4o2kE8TomHMMAzhXlcI/MjufLv+/q6AAOY9+3xn/kmoiLhL/PWpemTomwsza?=
 =?us-ascii?Q?/nx2M4y2BZHP7lDCLuIHeWv9croBleaBtsLmG972GnwI26MJj8ZqPDfoI4FC?=
 =?us-ascii?Q?Qtwz78TZZ3gTMt2l5zR3pvMSRAfbCOgqRHJg91q69X1uiLEP4iCrxpvp+H1d?=
 =?us-ascii?Q?MtNtlh7MMG7gbTju4IZCAq2t9E1DxBN5YlHEvikJ5z2AxofL7JtZ7dQON9WG?=
 =?us-ascii?Q?PdJXbardH+PtLif1hTBRoV8bzvkeo66DNNO1nCNYP7yEVfYHXLPk6+qwaroV?=
 =?us-ascii?Q?5ISx36HKkIUFrqA61+dmGP5DC8P+RVSjvUMFJn0Dp7XF9es3RDKx1Z8SvSdE?=
 =?us-ascii?Q?SfNMKMwpIc8Pws/Cq8Qoq335Mbi8HcR5L/wj/hBUU70ma3TI7LZ6j4CEBZyY?=
 =?us-ascii?Q?OOBfXzeMyTEnr5VWs9OpivYuAJGD16Ph1npG6wk8fz7XIbX66Vfh0kGYNFro?=
 =?us-ascii?Q?wt1CSN3X4Zp8hG9PqPRGWKxq0H8AU5mLbMNbq8/AodHEXMsGq+ynUSRKnnVu?=
 =?us-ascii?Q?qHNTwHaF3MBR8HsFRAPtW4nZTBxdFSft3+wCQ0J+d4YRP1RaAmiKOiC65gpA?=
 =?us-ascii?Q?rkKV3DVyw3kUP/Oa6r1f2ud2FRQ4kpDKFpnAuCZ4vCPqHMejOhpeXkGdZoIH?=
 =?us-ascii?Q?YuY/mxPZWVQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TTsMnqxpiO5qIMDEUbWJNN+JBcLwgHYk9FH+P3QbnrLvKLowNJdK5Qa+Ahqk?=
 =?us-ascii?Q?PO3yMTSobf1yDbdwyweTXQsAbeyj+dv7o1A0HS1sPO1VapvabzqwJxQzxCvO?=
 =?us-ascii?Q?cFz+e7DoyS5t0vnntsFu1OYRl30mLfC0+0PDOVQDk/ZWIoY8nZGADErdT0Jh?=
 =?us-ascii?Q?Y+WUucLePnj7tBbWw4KMgTTZm9gEzD4kbn1kBThA3tttnxvTrr3hP61P4aXy?=
 =?us-ascii?Q?4h8tURSwq31AbVj8R/XP7d+PLFvVGUUcBo6od75Qp2CSqFhkz3/xVdUfhtx5?=
 =?us-ascii?Q?/UjFm8MlNwggZhlbtGyZVYVSC5Qgxd3hFWGZXTMgTs8A0Ao49r2+iSSovhFR?=
 =?us-ascii?Q?OCJEcr9+iFkG+DlEt5grXn60Id4o5XjThkp4A48eziDjCVeAOD4PMLf40PGW?=
 =?us-ascii?Q?psose1fvhzSRnBa0Pz8q+rahL2pr8yMBdwMUXVMxgoWZRbUMiRGybulvt8kG?=
 =?us-ascii?Q?Vr3B9pvK4/NIGD8pIpDwPESkyolZ8lCz3R5gzIEu2u4UhsI2Fzbmb0ImJ+4r?=
 =?us-ascii?Q?uAB4Ao4vEiU0pmgwknJZPtExKOMaiYSuTnt0KkGxPQVOcRLljC7XWKn8Pqcd?=
 =?us-ascii?Q?DIwmky7+5thwcG4Z0w18+ZbrlBh1VA0QYoOi/wJjZQBwhsPgoIZkm6XgRk6t?=
 =?us-ascii?Q?bPqxxeNPJUlwqbtQEuc8rDbdnWYz6D0ZeU3Ah4Y/lyYcgSP1YePLj9IicrEv?=
 =?us-ascii?Q?JTszKznT5GL5FAh5AtDTA4JD/iyCQPR3bQlZxTVnne1sSxxc1CuH6m9SWyDQ?=
 =?us-ascii?Q?ZAnmIOFoRpcplFVH+ziPwY8n4DRkJDUUvfenliv7WKEpGGb0b9/P72NSo2yB?=
 =?us-ascii?Q?jgtaFYCgzb9CKODdnNpoYCFSfjm9a63DmHHppJlLJkMzlzyXNgZgCCAi7QgH?=
 =?us-ascii?Q?+mqK0LJbwyuoyWBz7BIqo4CrIk5lHxqn3bW1WDLAxXmKeKwXLPskJjltr1uz?=
 =?us-ascii?Q?/8816zrhsWHCCMWpXu46luLIxl3dzy4xEWjXFtlabq69XAtDTBJw10DHgfKR?=
 =?us-ascii?Q?8h1z/JNgqeC5jV5f5rr4pog0w74BNc5YkLqBx8cgMYfxluIrh2lrnwtBMEIP?=
 =?us-ascii?Q?75UgpQ7cggTCHOrIuYrTphBA9UkuEwsKLbW5h34r/V4DcRIXY79V1CiP4WVs?=
 =?us-ascii?Q?DtYFRsvGQ/ayaE3Qz9lGs2UsAmgF/AOt0gnPLdZozlrHKd7pQ7gJX62jVnFh?=
 =?us-ascii?Q?z/ZvM4gBTQB8viMB9FheK8xp2rbJKoyGz6E0ImqIff0P0ll8KjBBec649mVz?=
 =?us-ascii?Q?dAOG25CqEDf1W3oXjwY/NP9eZTaW+s9wCooYksp1rQHrorh6BSa4fGDrOSbT?=
 =?us-ascii?Q?wBfTEZrcDmu27ZVstpWZLsZpYWF246xSD7B6LwTjU/Cy8g70FZJlJvQAZRzZ?=
 =?us-ascii?Q?GHyQ/gvV3gZjrfzRfxivy7PFUwzUgc4+CqyrrejhHRvCjnszM1DqQnIA1UzV?=
 =?us-ascii?Q?yqGi6B+bwwlg9kKVXYQ7/cJiFZaKG1u9ylZGdpPhLrkbzIWBxYFBpAbbJG7K?=
 =?us-ascii?Q?yoma0/gORNkWmSx2wEcsC7+Ekf2RoddJsQv6HWvUaw8mSCHLZ2wPo60396lb?=
 =?us-ascii?Q?iYfnB9FhL1cC6JOfVbM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01717973-7155-4035-00ed-08ddef9b0676
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 12:18:46.5697
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uz8h2CJDFVWH4ozGlOiaXLsJXiUIMxJi4H+slfumePYcM8TgfhBNneRpVENC9SNs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6061

On Tue, Sep 09, 2025 at 12:14:00AM -0400, Donald Dutile wrote:

> > -/*
> > - * Use standard PCI bus topology, isolation features, and DMA alias quirks
> > - * to find or create an IOMMU group for a device.
> > - */
> > -struct iommu_group *pci_device_group(struct device *dev)
> > +static struct iommu_group *pci_group_alloc_non_isolated(void)

> Maybe iommu_group_alloc_non_isolated() would be a better name, since that's all it does.

The way I've organized it makes the bus data a per-bus thing, so
having pci in the name when setting BUS_DATA_PCI_NON_ISOLATED is
correct.

What I did was turn iommu_group_alloc() into 

static struct iommu_group *iommu_group_alloc_data(u32 bus_data)

Then

struct iommu_group *iommu_group_alloc(void)
{
	return iommu_group_alloc_data(0);
}

And instead of pci_group_alloc_non_isolated() it is just:

	return iommu_group_alloc_data(BUS_DATA_PCI_NON_ISOLATED);

So everything is setup generically if someday another bus would like
to have its own data.

Jason

