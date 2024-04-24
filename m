Return-Path: <kvm+bounces-15739-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E8A88AFD38
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 02:12:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9F73BB23446
	for <lists+kvm@lfdr.de>; Wed, 24 Apr 2024 00:12:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C09D23D0;
	Wed, 24 Apr 2024 00:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="boJoVewX"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2061.outbound.protection.outlook.com [40.107.243.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03FE51859
	for <kvm@vger.kernel.org>; Wed, 24 Apr 2024 00:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.61
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713917550; cv=fail; b=kjf/R2O7Vdmj1WuADxQVPGMh12vS3z9FD95apKENyCUWBk1cZRbiUZXH0fK4mtfscHMo6bD92cg1cGStiHIADdx/UGfcuikDLTDdZcgSY63mcIS1IgTvc9vCYcPOawg5TL4plRBrLp//hs03JNjRfvu+w3rv/e646gWdXpFBhW8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713917550; c=relaxed/simple;
	bh=VRsbsI4FegI/0NmRCu5qI/pFC8Orq/0aYQVW8wkEzJM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=qQoWEGfE8Wgfb2dJFkGJXAEbPfy5AHWv5aB7IkzRzo8L/QT9h+jrq/3Hn3LssJFe0/TEsAlv0IhDaQRlfl2PsqF3mmEsfsHOnE0Fsm1gyv4l1jALdjeXRoPvv0DOuxG2oAkMHyhVxz5OfkGZUnErLDAyO/RBjZL/rLjfm50LMXQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=boJoVewX; arc=fail smtp.client-ip=40.107.243.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UQGWXUf6iGfdmg0bbCe+hneVOwv8z0/HrfIePhQ1V3oXvqYfojvAJYnkMLwtOHx52oqGMKTJDN3dWqf0Y+ee0gUYe83V2Pk4cIynPD4sRw9LPu8uX1CKYs+C425bnvBXQIMeBZ7sou0NLdU5m7d0XeFiGuKN5CUb9tAO7HC+yHJc0iBj2XfsPcUXLCI7oziLsne5aIoH3U6QSuqGwJfffE6L5dzIxlONwPkLRsa4AqhDGmh53MxE9elevKjpMGSEWK5RFlwb1sGGbn45qjXE8umFWw0lO3+3SaU1OMf8hdOpPFZ6+pOVpw9WspFoF51xFWnDokY2IzImH5B4jTnIeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0aaSNdcZfn1d/+Ejlsd3XJcE9wEkstK0SoYDiiVE07g=;
 b=YfiKVg3vN2cGCt4OISSLfMY61l6nEihG3ZpcR1iy7/gmOv6afSYMh6ilYhpWhkxzTZYAeDnw0DzUyUaxOAYqdPbLK6ii4Lt8g/ZpJ2+wr++OmqhSLYcdPkvEV0+RcyI9agaKVTu7yMIptsshhjTUciG3+5jBAiWcFqBk7dE5WpXVWkqC0JS1bVanhbdg/pT/ck12lpvj92aOyPOOWxyOfNd96OIjej+Bp/iWypOv0Uey3n9XutST5H0p8R8VzMuKX1XyCWd+QoZq6T5TZo2HYbc8QEFaJWzUCDpae7XL9hqNa/abMd6B/ZXL2e4iORYuffbUXsLv8Ml0I6dXtB4GPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0aaSNdcZfn1d/+Ejlsd3XJcE9wEkstK0SoYDiiVE07g=;
 b=boJoVewXEQUEcIrGq1SrsNjPg68o9gEllftqV3ynts1t4rs/CPdlH7NXtAtHwdaEHq3aQUC1nrdiyKRnPYbyuq1HjQVZtZe4sOEPX8rJSzDQSmiFYTa2U1a22NMhafzgcU+T3huB/rWegl8OxIZseVH0Y2QVIOxX1LVkMNTSzBUstLP64C4OVnbQ70Z1+pEESs43PpbX1/i3VbKJbXPyWLMmz12cNmy8EOsAPM9zBC7dndOcMrihW0GNw2BH/znPbake3gT77SV4T4SCGu9FClu/hfHZmnaE2m0h/VEAchPhZWEzTOWHHB3OQaL91kcTPv3vihMCkO0FXWsyxBZQjg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by CY5PR12MB6226.namprd12.prod.outlook.com (2603:10b6:930:22::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Wed, 24 Apr
 2024 00:12:26 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::c296:774b:a5fc:965e%3]) with mapi id 15.20.7519.021; Wed, 24 Apr 2024
 00:12:24 +0000
Date: Tue, 23 Apr 2024 21:12:21 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	"Liu, Yi L" <yi.l.liu@intel.com>,
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
Message-ID: <20240424001221.GF941030@nvidia.com>
References: <20240417122051.GN3637727@nvidia.com>
 <20240417170216.1db4334a.alex.williamson@redhat.com>
 <BN9PR11MB52765314C4E965D4CEADA2178C0E2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <4037d5f4-ae6b-4c17-97d8-e0f7812d5a6d@intel.com>
 <20240418143747.28b36750.alex.williamson@redhat.com>
 <BN9PR11MB5276819C9596480DB4C172228C0D2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240419103550.71b6a616.alex.williamson@redhat.com>
 <BN9PR11MB52766862E17DF94F848575248C112@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20240423120139.GD194812@nvidia.com>
 <BN9PR11MB5276B3F627368E869ED828558C112@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276B3F627368E869ED828558C112@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: SN6PR05CA0029.namprd05.prod.outlook.com
 (2603:10b6:805:de::42) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|CY5PR12MB6226:EE_
X-MS-Office365-Filtering-Correlation-Id: bf41faf6-ee06-4294-8086-08dc63f3377e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uJu18PDtncz1fQOozaSs74x7xjhq6FP8S5mN7fQLr67r12EzJnqBItA0LPka?=
 =?us-ascii?Q?ixFLOcFmNMNGZmMwAatCVFKOc7U2NwVHEW2wMg85diIS4NhcSJx0Yzzk/2BD?=
 =?us-ascii?Q?O2ivnHU7ttC7uELJZ5ZuDEQNychGWgc5FOfy0lm5altIaNE2LsmhXe4d1QSu?=
 =?us-ascii?Q?o/b+jE+yiGMvxOPeYbD+3hJlQDz5zWWlvLOHjuR6wwjSHYjoCjULEZ1XhWR2?=
 =?us-ascii?Q?FQ4ldRXDCIdv1SltpwOsKhUjbvRLyyn+YbAfhfupDLvpOgqlKZyPa4ukizOk?=
 =?us-ascii?Q?JIdPIsvy9YwXFub7bjucc3yft0w8I8SUfRdcCPohLn7kcX7UK27+2uNjtzT+?=
 =?us-ascii?Q?PcKNMPMTlCdkgCTJ3uwkJqumth3UM0nOXG3TFbvpaDxiq3YZb6HmNwkaNlAR?=
 =?us-ascii?Q?MdTv2UbkmNI3vPlmzRqq0DxQTXEYE+4bcKtU9jvCGUjxoSHFi5YV/UKv2eY1?=
 =?us-ascii?Q?U/22dSFP1YwfkZj7OlaCRlFxqlIz+Jmg/kDiBD5aPBIoDfPn4HN2ejBRYUf8?=
 =?us-ascii?Q?+G3h1fNlCAT6TOWjv4htgGLv+eL/dgKTW1+8QlYVRTkL92ewsKl6Ry61p+O0?=
 =?us-ascii?Q?zHPZ3jLVHCxSZos1fp/0AmDPLNGRFZfXBj2mxuBXvUTcdOCUzSjpR8k0TN81?=
 =?us-ascii?Q?fbIb+51JU4uVuJ4N4f6XjubN9a1BXm/xnK7A5sdiesr1F0BeJQm3M0mvg8W0?=
 =?us-ascii?Q?CmJ/EqcnzzfHMgYtcVQV6rXhZZPbPeDtxQTCeH2WTdsZEtXOI7dXVLYLHKdx?=
 =?us-ascii?Q?1sqlR1eBI429jLXV/nasUQfVTLF6lG8hdJKyeK5OZMgzdSiJThMWW+bS48cq?=
 =?us-ascii?Q?zieQ407y38CD938hP8nNqkaHOr7ZitVLWW7IsM2TkOOTZawfc1r8pcVJJ8ga?=
 =?us-ascii?Q?Vs6Cz5DzheSPMg/yNpuF1wNZXOHkSKoc+9gB2N82aQbfqpV7fOWYXEjFgDFd?=
 =?us-ascii?Q?0uWjQtmH/PRinonDVIonsD+oiTx1gzkeV8q1m+qiRbuXDaTyz0JXzsANrgVB?=
 =?us-ascii?Q?vYsdcKJkEO7xg8kOPGOrRupCFcbSFcgdKvNvfOODmOPMYUkpGxRccq5xH9cm?=
 =?us-ascii?Q?7uHbgEW4xMZ6UlbPQf/NLSWf52MNJacWcuqLlTyMw7OpIDu6xY0HeuINXQGQ?=
 =?us-ascii?Q?YBWcLrX3I3SQO2SDNZpUxOO3h8hCpDmMaAOOpAExapQGXfeGyl43c3oJe096?=
 =?us-ascii?Q?q1UISz+82AgrCnB7AStxMwLf3sUxodwfiw+KjDn1A5oBLe/kvrm4X/1ctnbd?=
 =?us-ascii?Q?kfaj7n61mz8rdBsjrhhRxHUgPdL5nkYFErcXp+a8Fw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HTXoc24X/JlPICB88eqNhZ21KcS0ed439Qc2c6URFY+cdNH3bJx9z2E2VYA8?=
 =?us-ascii?Q?O6tde+8q7Og90t1nGQEAV71c6wFuPD2ZMpZwaBz+DPnjnuOA/Y6BV0lNERiz?=
 =?us-ascii?Q?AjJ5pJ6OR8BtsleXJ4ZTlsHiZe9PzAXAreL5+tvtiaOemOSA8XdiPj8wY9Xq?=
 =?us-ascii?Q?l01PUnXMtHFX/xSKhwsBizJdu1ryFE+66/my6PsKMksZPLj1txw/mjtblU+2?=
 =?us-ascii?Q?82pLPEFG00aO1z1vtSuv5EcXa+THdztCeZT7WpBzz6Rl0o4jOGre/z1EvjgP?=
 =?us-ascii?Q?tf6kgQzDWw7WDf4lRyLKDbZJ2YU5OGP4sWuPRUKjlVLmUUtwuIlhCCaD0xxD?=
 =?us-ascii?Q?KYYnwt17exrgsFcoKOP/HwL7oAkqV6vOrzVNiz8s8br5415K/W4JJr7TanCd?=
 =?us-ascii?Q?k6BUIENBv2NWab1Ac5uMG22VJDisYdm/hjsVzvBY5VAD9q8jwzpVe6broOdp?=
 =?us-ascii?Q?mAqBDDXfJSS+Hw4to7Hbpmvn0/JHwCbQ5Cvh+vbAhdzBIvyvccGTtuJLZH8z?=
 =?us-ascii?Q?LxlybMJx/M3E4HMsjBFc2oNx0udA/QfayWK/Hb/5UWx7MkiO+JMSrhaRvyje?=
 =?us-ascii?Q?TscPIPXg8l3+nDYt7eLiReK/1+Qpfr+xlMTjjViA3m2rvQEMXwd5zx2gIvkx?=
 =?us-ascii?Q?GqaJiwY4oCClwTLnXT0bRYZZSo/pLGTjq0hklnjizKudjAtgCJ5Lznr8jpGe?=
 =?us-ascii?Q?HUwtklzVxn31nFhcRAvCkBX2KogTmxKNY0K3fO5rZoMxBd3UoxjUhuOkVOfr?=
 =?us-ascii?Q?KrKvEjZs3qEGbpxNqwX7YPeUCmF/VpAQPiNuAOmb/NgteNFKgutxHTevxjnN?=
 =?us-ascii?Q?ZBB9ycDA2V06LBPs1nDY8IVCl7QP+ZlswmzQzl5/YlkIlZ+QNGaxCYMy+UA6?=
 =?us-ascii?Q?F9bzBnmxQI9Nvqb0xXlZPKLyz6rOheXziV8x50FgFUnkOO23ENHAWKmozLQq?=
 =?us-ascii?Q?3CfAb5qps+fx8N2+HSk2PYAhTxa6s9Anzi0w0paJFII8j99GY2tesZn63WVY?=
 =?us-ascii?Q?oozGlha8KiZoP4QmhXXGpDq1Httl0pfN+JPotWxyTMBc6+LwQ8KEzA9b9NuH?=
 =?us-ascii?Q?AbkzwrNvZ6a7I9QLCDppVJBnA5IHAxkZe3MMP1aJ+wfgNg8Y3026JlUhOus0?=
 =?us-ascii?Q?nMqRhy6MGxLHUuCPh+1iB9pYWicZW3eQYN2GhjuXhAjsg/AV4qvO+vWMpS7r?=
 =?us-ascii?Q?zeLvR+3xaB9GDIPRx8cKc6IG9U0NN4/xzZBIN9s4uD0IRvdCuKeY+x1HYqhe?=
 =?us-ascii?Q?/D5rSgClwanhneTZwpVcoOZ6CjrwDR6EPngCtyVxu42DQSIxwJWXW0o7gua7?=
 =?us-ascii?Q?OQjmj0uUkmhnz6P3/p3zuGYrrRw8o10wr/bNO3AFisqrsrLNjz6FfUmyDrSh?=
 =?us-ascii?Q?cQnSgSgjNDisvFLtW1lpqztlNt31imTDg0IVZAj0iMypwDOO6hgI4zffMqOl?=
 =?us-ascii?Q?lzB0bVq74iS+xgqToNhP1NMjmIda8N1SICABWd72iFZClQlYU7vdbW/wtW3T?=
 =?us-ascii?Q?w5vPN/wixfTpNujxGDQAGb1Esn/8VxYC8Rp+LOSpuw1U2UQ6nykF5Mdqyoz1?=
 =?us-ascii?Q?Af2Pntumr4eWHn4sUgw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bf41faf6-ee06-4294-8086-08dc63f3377e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2024 00:12:24.0389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vt50hiAUBSiKBL8dveupmqwICirvdMpXI3Jj8e7q6pv+UY85IKkLnripHMDLO7vV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6226

On Tue, Apr 23, 2024 at 11:47:50PM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Tuesday, April 23, 2024 8:02 PM
> > 
> > On Tue, Apr 23, 2024 at 07:43:27AM +0000, Tian, Kevin wrote:
> > > I'm not sure how userspace can fully handle this w/o certain assistance
> > > from the kernel.
> > >
> > > So I kind of agree that emulated PASID capability is probably the only
> > > contract which the kernel should provide:
> > >   - mapped 1:1 at the physical location, or
> > >   - constructed at an offset according to DVSEC, or
> > >   - constructed at an offset according to a look-up table
> > >
> > > The VMM always scans the vfio pci config space to expose vPASID.
> > >
> > > Then the remaining open is what VMM could do when a VF supports
> > > PASID but unfortunately it's not reported by vfio. W/o the capability
> > > of inspecting the PASID state of PF, probably the only feasible option
> > > is to maintain a look-up table in VMM itself and assumes the kernel
> > > always enables the PASID cap on PF.
> > 
> > I'm still not sure I like doing this in the kernel - we need to do the
> > same sort of thing for ATS too, right?
> 
> VF is allowed to implement ATS.
> 
> PRI has the same problem as PASID.

I'm surprised by this, I would have guessed ATS would be the device
global one, PRI not being per-VF seems problematic??? How do you
disable PRI generation to get a clean shutdown?

> > It feels simpler if the indicates if PASID and ATS can be supported
> > and userspace builds the capability blocks.
> 
> this routes back to Alex's original question about using different
> interfaces (a device feature vs. PCI PASID cap) for VF and PF.

I'm not sure it is different interfaces..

The only reason to pass the PF's PASID cap is to give free space to
the VMM. If we are saying that gaps are free space (excluding a list
of bad devices) then we don't acutally need to do that anymore.

VMM will always create a synthetic PASID cap and kernel will always
suppress a real one.

An iommufd query will indicate if the vIOMMU can support vPASID on
that device.

Same for all the troublesome non-physical caps.

> > There are migration considerations too - the blocks need to be
> > migrated over and end up in the same place as well..
> 
> Can you elaborate what is the problem with the kernel emulating
> the PASID cap in this consideration?

If the kernel changes the algorithm, say it wants to do PASID, PRI,
something_new then it might change the layout

We can't just have the kernel decide without also providing a way for
userspace to say what the right layout actually is. :\

> Does it talk about a case where the devices between src/dest are
> different versions (but backward compatible) with different unused
> space layout and the kernel approach may pick up different offsets
> while the VMM can guarantee the same offset?

That is also a concern where the PCI cap layout may change a bit but
they are still migration compatible, but my bigger worry is that the
kernel just lays out the fake caps in a different way because the
kernel changes.

At least if the VMM is doing this then the VMM can include the
information in its migration scheme and use it to recreate the PCI
layout withotu having to create a bunch of uAPI to do so.

Jason

