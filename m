Return-Path: <kvm+bounces-51531-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99A46AF8446
	for <lists+kvm@lfdr.de>; Fri,  4 Jul 2025 01:35:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4164A3A7B75
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 23:35:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A31B12D46C3;
	Thu,  3 Jul 2025 23:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="SubFCM/A"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2089.outbound.protection.outlook.com [40.107.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DBCE29C351
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 23:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751585741; cv=fail; b=m7hnpUJn2oA9C/w8BDyQj2ptnOEC/JVIuWJ4mUdeEuvUX5ZDnEnYIiNwrGBIiSy4mKF/xCksVyVgsQ5hkxTcd57FZbXP+aZzNHbfcaXEF0DZoCBPusTxZ9KtI9iFID341oOkn5IdqVRbDfJgktM7ZqWXIoKAf7sGluWvE/hSbvY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751585741; c=relaxed/simple;
	bh=ge3Nd0G3D9E9dnJG//ISaxS5iW+Nqu/0kzMo/eqk6AU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=AGzVCNVsI7KoCKhgU0vqGvIF0MHVGGW4CK2kgdp7Ow+19TczypIE5LVHSWaajGVWsoLeEDjNH4ejeQziyoEyTXBn1ONRhQs4j3Pv1auG5sL6FUtRZf7+TMXrFhGTyWwQYiQYQ69bTbCVDzk3SXqeqy1D6rbOVfbsCDoRXb/IV4A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=SubFCM/A; arc=fail smtp.client-ip=40.107.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AlQ3kgjvrB6CdnzbwG3TwwWe/Yquc0FIapnhYo3QiUQR/fJZs1aMMQCdVSHQTWURyCW51M/+2w4t3vXAAV8Ij+8+ZOJpIECvTb4/SSKfY4s5n0msQHL17rd7PvT7aAVDYUvtkop/1/DZVB51Olt/nEacM1Gb2cy8mjgkfykHTOslK2h8Adc0LArALfV0SxU58WBVCoalMf6bsrrP0ppvJftyK+er8Qk/zHnj56UVSl2TOoY8cFaqS4x99rnh360+pVrYfjpP2SbckY3G0tHN7I2oTi+x/MZ6UbztRpFFjJo5DrlSaH/kjtv8erDh3V2E00GbkCXZPk22EEWHm2l7xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I4CDiBCqjqiCK7F9JV2NlUWB87Q4Q5FJQM0fOmGnRyc=;
 b=VyxRgXo6CQI//W5jciSFvSqQLISiy/niatPPpGRyUfO0sMfxeiNEigzjkAKPIxRdalJWwWcZCQWNLJGEepKU6YnIhT6tVWyeOK4QRFOXgpvlE6e3HvHYa+amstHC4DuRJMGaJW4HWAGohXczNHkV2XquoeKS5nNXz6ekBEmSHvvPSriecFI3xdbVRMhY8u8IHPQ2zE/6PYYQSM0csGPv+DQxgqehtqqW25mkJvRvwJ3dhFGjz+S84iIcPM0IYCB2WLz8AOqurOAqLgvr5+UqN/VThCGXdMX4WpP1/7lCjOpfEcnG80nmtTswnBKNfGIL82LJDQAn3hrWxTxAw4uwnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I4CDiBCqjqiCK7F9JV2NlUWB87Q4Q5FJQM0fOmGnRyc=;
 b=SubFCM/A/FkeRCqvkS7GtFC7o+MLbUI7/N7+tsQoUhN7opaEqb/UQwz0YJD2+ubn0D0lVzYzYMKNUwibSKmyFlZnciWth4WOsV2+rGj4dOhr0sCcilNL1x1UyA4fmmOZCe2i6Nf0Mtbx0EofSmDgwG6p6PtrQhZibj8waS6wjW7Btc32enRjS7x/6ZzGNycahFl/0QkIe63dBK1lPkakR5mRamstPnpiS3CebNnRHQn8+RhZOUSFUTrdiazvvRFWIv58NzeCm2/zl4tdA6GEsASs9u4uLi47JDT4gvZ2vk8N/V6mKe7KzrgKtSDqDP1CFP3uAcj+yn2b0KtT0fx3jw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DM6PR12MB4372.namprd12.prod.outlook.com (2603:10b6:5:2af::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.22; Thu, 3 Jul
 2025 23:35:35 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8880.030; Thu, 3 Jul 2025
 23:35:35 +0000
Date: Thu, 3 Jul 2025 20:35:33 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"aaronlewis@google.com" <aaronlewis@google.com>,
	"bhelgaas@google.com" <bhelgaas@google.com>,
	"dmatlack@google.com" <dmatlack@google.com>,
	"vipinsh@google.com" <vipinsh@google.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"jrhilke@google.com" <jrhilke@google.com>
Subject: Re: [PATCH] vfio/pci: Separate SR-IOV VF dev_set
Message-ID: <20250703233533.GI1209783@nvidia.com>
References: <20250626225623.1180952-1-alex.williamson@redhat.com>
 <20250702160031.GB1139770@nvidia.com>
 <20250702115032.243d194a.alex.williamson@redhat.com>
 <20250702175556.GC1139770@nvidia.com>
 <BN9PR11MB52760707F9A737186D818D1F8C43A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20250703132350.GC1209783@nvidia.com>
 <20250703142904.56924edf.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250703142904.56924edf.alex.williamson@redhat.com>
X-ClientProxiedBy: MN0PR05CA0012.namprd05.prod.outlook.com
 (2603:10b6:208:52c::35) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DM6PR12MB4372:EE_
X-MS-Office365-Filtering-Correlation-Id: e7089f76-299c-4213-6fde-08ddba8a4f13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?KNHpzUS9OZVHFTKi5gpkleh8QE2hOOT3caX4qls2p3HuihAGiq/qJvk2HEJo?=
 =?us-ascii?Q?xXmDuUB8nVRMjyViEWtoWqNesFE/qixTOP4qO6VH/W11kRKDe5POm0UxiGGr?=
 =?us-ascii?Q?7fQPMSGuOfVL5GNcjyLo4fi2Ew+EdYuTzecOGWyPRWi8tyOPHzJNuklR18tT?=
 =?us-ascii?Q?tZC1eIbZox+iI6z+ty0rk1UWgFr4IqOOfvg451JI6ArBYy3tnXHyJyQjv9on?=
 =?us-ascii?Q?0hjGJdBwNaae1SGsf5WOlSCX+C9s4XHYT76pfePCuId4AotCccACSi0SkEj5?=
 =?us-ascii?Q?12W+1Nji77wIuXENh45ti63lYsO7jb82yR0oxvU8ftP/W4InNk6V3xWHnyjq?=
 =?us-ascii?Q?p2LDlDV+/gul8b1KbwHpJEjWZ6x05u7PYtkwkebLnjSBpa7YjSOG3+/CLyJ7?=
 =?us-ascii?Q?vd13LZyWyJ8uiC1jvNchBmzdzdBdrRWUHW08CqUC34NOew/aagdi6R0B3YRa?=
 =?us-ascii?Q?AgXCyaWHpNvejU9ABr4IU5YkhJUZM0WV0mmrrwr7jt98zfVZ+m2s38FH1Spd?=
 =?us-ascii?Q?s8pPsz0xqPFMpLIJixA5hqurAZZ9y4usDrZ7XPaE7YufmKfevVad9+GUFwtz?=
 =?us-ascii?Q?DzNXvHNwUHwooqr0w0ZP28VCCA4NcBbOrLIyS2keTCVqgcs7FbAV4tXW9v8n?=
 =?us-ascii?Q?klrET2CIbbqbMj9wVO0VHZhNVt1L3jN5JBABrgVNv3uN971iVCciJGb6Abuh?=
 =?us-ascii?Q?nF1T2crXtb8vyya76FAsdIEAn5fxaTwZz9zdqCjRsw3fdJfEoe7S3xaggKk8?=
 =?us-ascii?Q?lSQgLPqdnPHsbHLDoN8E7sv+REcyZeFMof2TJN/jFbjg/dRb97N3KNx+OwSH?=
 =?us-ascii?Q?buqCPUQb27zxthlAOKs7ktfzKfMOE2VLzWEQ0XJo6yPUPAM8/piHzszd6PfM?=
 =?us-ascii?Q?iN+b1YZvGIruXXJbX7tDda/c5yMqhezyTWxuiyMIJ1oBPntWP/7B3p9qQlgO?=
 =?us-ascii?Q?5cXIgiCgpoYoJgEIeeQknfs4A/9HMRj1xpehbfS/R+YY0nFROFFsveM8GRfx?=
 =?us-ascii?Q?9e4HncwwlPVNjQneEQxOO5bzh0sY77Br8/H/ado9gKB429cdyXtvO+DCwYYa?=
 =?us-ascii?Q?bxXdueDxRfvKpHbzMjYMJB7/+SHoZ8/T4Yl0vt2kdcOD9UKJ1+wCf1LZp1Y9?=
 =?us-ascii?Q?vX1ZkXJs155oYZEbSSOFmZd8MqyCD+iEoSLuxKExUVp4trokDAqC3LYADtdD?=
 =?us-ascii?Q?wrg+qglST3p1qOj0S6CYd3hiRbEkLoxHYqdEVj4lMJI+ozYyYBrHRUCGjBQS?=
 =?us-ascii?Q?4DawVYodZjpvivOy4dQEx6V/UCiPRsjK7n1dnYRePPCl/pfT5ceg0mRC1xe/?=
 =?us-ascii?Q?KpBDR+IV+E7CtPAUl0TjO1bbZz/JtR9c17jQWKwUamOM3LgBNKYW0xgzk/9U?=
 =?us-ascii?Q?+hV+Ts9p7ffYddGKYGJjePewyGyGGnaaOrDhd16GGLlB+hfcN/dFXDefd9IF?=
 =?us-ascii?Q?G9mLVy9cCvU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZQ6QVZAQcczTn64NylIxFjyNjPqAb0fSn+crj0cExzJZYYZkVjvZTbXyJH2u?=
 =?us-ascii?Q?geN4z1ttaEsOsJtatvegu+KcWBiuJfwPy9BigkETIpxrHcv5pCbndiNx0np0?=
 =?us-ascii?Q?r8OKiaHeIRs7omoELW/F+cO1Y/ujNDhZfhY53si4Lwd2JsRtUlwuO538JraL?=
 =?us-ascii?Q?C8MQtqa6ZSQRkXGoXubkQqL2u/QWhkXJnUcTxTeW9aI7QRBDJDiFTg9QW6V8?=
 =?us-ascii?Q?LHorwWOKNGeR08Z+aAN2QtHFFgm06yyff+9bbwM7MCiz/RUyjhsxyU1LeyEz?=
 =?us-ascii?Q?MIB6GKWOvNvX7aRYjMVx4Y7lIvRzWB4TrV5cDS4VQSDPFftL5+qOxcJFep7F?=
 =?us-ascii?Q?IBmMdEJ2lxCxd3qgLsm5hwHnUJqKOUaueWzDRb8ra1Kr5XdxVflf/FM56jrA?=
 =?us-ascii?Q?BNO8WZVF0VqyDXZAp6iu1tBvPr/T8FkxjDIPgahQC8Im2GZNAjKAgqY0g2lq?=
 =?us-ascii?Q?JMqcsRiXhXI1Qb2fDSlYkvJURALOmTUgS6i2JekERhai+oK1Qold/AoMExQo?=
 =?us-ascii?Q?0bu5UANSNI/L+JeYlo60MWobxQQiCclB00CMSqNeRvjvUL8aMbayyuwPSnl/?=
 =?us-ascii?Q?6ECt+cH3QvbgyHYZ84mTaGkqnhFWoSmi3PzEJibN3i1Mmbs/c2AH/fidvINu?=
 =?us-ascii?Q?PgPf1PFQnsd/2/A0GwSceLpbyfN3jhVHPE90DjmO+jL+nfY9XLZR+RYbmN2W?=
 =?us-ascii?Q?ZYLhBLdxx9hP2rLMiFnlKhyQFB6Fw0QNZnGfmANFqx5KFNwk43fZVQDVSvnk?=
 =?us-ascii?Q?pz4QEm4DCXb7ZZdAwzx93TFRD9CyEYEYPm9gMBnUwdgUSvufNSkT46x9wP7L?=
 =?us-ascii?Q?3LOggbHP2EUGjjWg6pdsrtw+Qw0XF22bNMCMryVdkEIlc4OQkp3bCXMHohgp?=
 =?us-ascii?Q?jCn30fChzvyyd/UNF2d8Pi/DqhljZXwp89hEnaLWrGB1GkpqCgDTE7hpQ7Rm?=
 =?us-ascii?Q?3yUzic80dgMAPRJX69Ng1/C/QsCDt7h2gat3cOQ5xVVJRa6SkZM1fWhFcOcC?=
 =?us-ascii?Q?n0okJI7/DweVY4Jf/jvaon15TfBjGhw6Oosk5TtX/K5UtYeDET8sc2tuzVz7?=
 =?us-ascii?Q?gF7pwbPMRbS7gv76u7/IDfVj/vd3nXIqR3TVV1mgpUCPy5r9XL9PQ8EACd0/?=
 =?us-ascii?Q?GXqtuaaqEE954LYFBuDIS/dIhnsCh7NqTRQ3lbkgl789YsDGBA1pjbsC3kbF?=
 =?us-ascii?Q?30M2DktWQCHwY3poEByEhzbn40inLEy33nwltChRex45Tr3oAurXbLUcKpQh?=
 =?us-ascii?Q?lAO3m4iLaElL0OtrvN28ATbmdwtvGr3HKfIZZ0kWOh1UaJwGG1Aj16DSLJzj?=
 =?us-ascii?Q?y6wRbBas3DprjNKi7iZa92p9sRBlnh8kxx5x+AJejZGEChZEEfp+aC92HYUz?=
 =?us-ascii?Q?BGxjW87RGaUyBRDm4krD2fNgaHse5jHwfwerbT4QVzCNzsb8dHFNGnJZrMdv?=
 =?us-ascii?Q?Y39rAEtlxcYojRBsAVVjGbNLoJ039OyHnJdR8zyWgOheTqW3sjOWEpXrtJBv?=
 =?us-ascii?Q?1n4/ZDPndvr8VmKhoMprmbuzKaDlXQKf9Z4Ja/vR3gjA/i+6wl1ZFbMxsYSl?=
 =?us-ascii?Q?lOWLlcuuvpRrd9pHByIpXieaeK6w5Fn2x2qeCq5j?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7089f76-299c-4213-6fde-08ddba8a4f13
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2025 23:35:35.4610
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nYYI/iTd+gJcnjJXNzckv18stNXfkp+tebFCJR+6IDylaSoyelyAnKoRLqwMKs+Q
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4372

On Thu, Jul 03, 2025 at 02:29:04PM -0600, Alex Williamson wrote:

> > > Is there any reset which doesn't disable SRIOV? According to PCIe
> > > spec both conventional reset and FLR targeting a PF clears the
> > > VF enable bit.  
> > 
> > This is my understanding, I think there might be a little hole here in
> > the vfio SRIOV support?
> 
> I wrote a test case and we don't prevent a vfio-pci userspace driver
> from resetting the PF while also having open a VF, but I'm also not
> sure what problem that causes.
> 
> pci_restore_state() calls pci_restore_iov_state(), so VF Enable does get
> cleared by the reset (we don't actively tear down SR-IOV before reset),
> but it's restored. 

Oh interesting, I did not know that happened. Makes sense.

> Also, PF->bus != VF->bus, 

Unrelated, but I've been looking at this and I haven't tried it yet,
but it looked to me like:

	bus = virtfn_add_bus(dev->bus, pci_iov_virtfn_bus(dev, id));
 [.. inside virtfn_add_bus ]
	child = pci_find_bus(pci_domain_nr(bus), busnr);
	if (child)
		return child;

Will re-use the bus of the PF if they happen to have the same bus
numbers. I thought the virtual busses come up if the VF RID calculation:

	return dev->bus->number + ((dev->devfn + dev->sriov->offset +
				    dev->sriov->stride * vf_id) >> 8);

Exceeds the primary bus?

> so VFs don't get added to the PF dev_set.
> The PF will do a hot reset with just the PF group fd and of course FLR
> doesn't require proof of ownership of other devices.  

If the semantic of the hot reset check was to require userspace to
prove ownership of everything that gets reset it does seem like any
reset on a PF should also have ownership of the VFs. I think the UUID
is probably good enough for this though?

So that seems OK.

> Should we do more here?  What problem are we solving?  Thanks,

I think it is OK. I was originally worried the SRIOV would not come
back, but since it does that part seems fine.

Jason

