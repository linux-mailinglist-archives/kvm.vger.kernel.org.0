Return-Path: <kvm+bounces-51310-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 66E5EAF5BDD
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 16:56:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8E86F5216DA
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 14:56:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D349F30AAC8;
	Wed,  2 Jul 2025 14:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="hhqZVaHb"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2089.outbound.protection.outlook.com [40.107.212.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B7830AACD
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 14:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.89
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751468198; cv=fail; b=hOVwwzpmWQXYMI7M8y95xAdNvvHV91xW5YSVen6dxqaE17x+xSA17Si2GnyoNTsdeR/i3TkTVkcRlf8enrsQ4dNevcJ4TLPk+7uQj51DXhsIMqjMhy/nn16KpUTGDtFuolm0hzZIIU2GdIc3jnWl4fKXh7D3uwOZSUYWiikuDZg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751468198; c=relaxed/simple;
	bh=5tPvogNAycm4dYgMmeEP5tcpyUcU58PMWcE56bpYXCU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=S/aF56iFcpLP7bG5Fw0VXv80XVpShjp0bkGx9C0tMecpFmQfr7xYptVDVSQgdSmEv9n29WwoD2Tiq/gy8Syx0ichk0/QWEM/pUrU+rRfzOKYz3NFyzIzgQqIa3pLKpehn8zJLQaZGCRV+zTG9SuFnWlv+CaJQM8SuerD3EpRYpE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=hhqZVaHb; arc=fail smtp.client-ip=40.107.212.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YyAmqO4ppT7UyitBlaYuiR0aDSG5V6AYZ4/dw8p5e1Eht46vhGV9seuXQorhZiK85Qyzmv/+hQLQQJvTxheKVSiNhBC/PoQ59+idUg/xSBv2qpWebmA4X32kNJ7O/E8wE9SV0GP7fNAki/kOaHRvsENZvX9LjCfiW/6CrG2ujPdLDFcsn/LAW/Sq5poMnIfOAXdKlALt6IqJ2kfn/bnMI7SH8XbNXiGFrL3NGaSvMHyWSn/lBVLIDzbVirW2JJz5+2pF5vuCyW2CYbPmDK4vEzPTIALy7PWbUiZ1GzBP7a4f9+pG8MpY1YOz10KxgMFlATDdmt4KZp5f1CBX86IjIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gMtFKtpy/oDfqgzQFO56UTuhd/pZUhyhpEZBgo9s2F0=;
 b=gKWrYNZXPAauFbu3L3EjQyhBbXI4tkKNZhwx0iFbyRnGdgDg2b42i3IynhXlrrzdMHbK6OX7Dg3HwWuUtgKyxJ+NzX6Y+v4TLfCZVA1eqhdz7qGlHVeZG0wW+MuFFyu6E2ya9Edi46DHIYY/TzEBK46oBciIVbxXRTdzdj0tp6D4rklZk6czi3IQF784F0Df44M2f6TkxrbmowAZQGDZasNBG1FmajK0ekZi4BGHhiOqYcRKeC6pgC1bUBmEs40MWtZLzETyUf/OqOPmVbB474SlCE2o39A6fpZJjR6Gb99fCf3yY6wWHU9qCtS3a5Nz16rMxRdP0eQ052WOSkv7Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gMtFKtpy/oDfqgzQFO56UTuhd/pZUhyhpEZBgo9s2F0=;
 b=hhqZVaHb8sD99k3Cb6td60dChrwWqQcWae1LURIEFvEi+GKAxruchgpEls6+K5o/gcnXGLzy/vGqBbXnG/H9z3I64DnWnDHXs+k89FxW3tEyFMeyDX0f0qrU7rlznroP8NLCEJsW5BkYf/7v0ggt43uMzcfFRg/y68kp+RMNmRLidWgtPagGbaFJwa1z7RSSeI+K18W7VOL0ytx1uwlri90NMeWNGVp4Lcov8Ofj+q3lY98A6ka14I2w2WSJqcRRj8QEa9N8brOEDFrDGPKi7QOwgVnkVQeY3CwczcG/QdnXAXIu4lgjsUCySZi6JSq4bS2CxIng2jmTGC09hU67Xw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CH2PR12MB4309.namprd12.prod.outlook.com (2603:10b6:610:a4::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8880.29; Wed, 2 Jul
 2025 14:56:33 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8880.030; Wed, 2 Jul 2025
 14:56:33 +0000
Date: Wed, 2 Jul 2025 11:56:30 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Ankit Agrawal <ankita@nvidia.com>,
	Brett Creeley <brett.creeley@amd.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	Longfang Liu <liulongfang@huawei.com>, qat-linux@intel.com,
	virtualization@lists.linux.dev, Xin Zeng <xin.zeng@intel.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Terrence Xu <terrence.xu@intel.com>,
	Yanting Jiang <yanting.jiang@intel.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Zhenzhong Duan <zhenzhong.duan@intel.com>
Subject: Re: [PATCH] vfio/pci: Do vf_token checks for VFIO_DEVICE_BIND_IOMMUFD
Message-ID: <20250702145630.GA1139770@nvidia.com>
References: <0-v1-8639f9aed215+853-vfio_token_jgg@nvidia.com>
 <20250624140604.6330c656.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250624140604.6330c656.alex.williamson@redhat.com>
X-ClientProxiedBy: BY3PR03CA0018.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::23) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CH2PR12MB4309:EE_
X-MS-Office365-Filtering-Correlation-Id: e07fd59b-92ac-4c9d-0a8f-08ddb978a25a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?u0HIqdf2JOYkv4E+niF4lzG0HogSuAorBl2R7yHQdlHEaBLCETKGlLqPhXRK?=
 =?us-ascii?Q?6sz3OhYdtMqoc/cyBN1clowN6tZtmJdjCpwyXJVLOAZwdJer41jnkL+KhTT3?=
 =?us-ascii?Q?7GeN+MyKFLZIyLxIgp7DYG1Fj0FT7p2/fetIPtnaT3fB+Vc+S+SsdzJRJyno?=
 =?us-ascii?Q?WtaX48A3LxR7VUpQgPsXCYEZRFb4S7IjE1+QEzpxP6vDVR8RvdDR0HhLt+Vv?=
 =?us-ascii?Q?mO3KVSHlMxKASt1pa28UcHCMqGa6ZR3vwT+5C3NpdxedDRE6AbV7ft5wA2f1?=
 =?us-ascii?Q?KaBpP7YrYJwz7wDjOr2QG/PO/6H5zNQVMBtAYoqokzLv+ZZjWysmbGNQtCHI?=
 =?us-ascii?Q?ltnW6hz4cs/vFuhfGvBtcrIDL1SAhgN8WkGYmtISPuJ3yMdDVJy+p5524mHD?=
 =?us-ascii?Q?8mX74ApEpANZWSGfGnTUH9C5wY+4CIANZGZ6PAwcVWLmeP7PZ/FGmmglUQrD?=
 =?us-ascii?Q?62wNJnAXMgsFCJY87XVWRPNSXfu9EHWAflvjVF+VLGPMFpHUl1ZIwsSGasF9?=
 =?us-ascii?Q?M46nGnOGfUXkx2W9nuN96UGL1Tk8Gpxh608K0coBUwyVd6q7JDRdR9aBzLoc?=
 =?us-ascii?Q?QQZYrCesGrCRUZ0nepXO0DSdYhYJEPktHeaIomGAPfB8pGO3m5/LIU23/EK5?=
 =?us-ascii?Q?fOcG4gQHMS2T1Es/4AruNMw0600GyOQ8YKWoawE+WIQo1dhHnhB3v4iSW3fF?=
 =?us-ascii?Q?KSU8J/+2Tfni5evItzN621LISr0sCC8P53zIsdj+BI+QnR79fbRZFTS7d2OL?=
 =?us-ascii?Q?7cBnWrbBk5hSVcBjt+DnnxCc2eEW9J9leNiZeCrYARnQ8ZLJTwY0yE9Ovj9f?=
 =?us-ascii?Q?6TXaIK2mIgyyClOx2gZvSEZuE4Y0q3Sp8xMEHUPZ3u5ku2CS7R95zJjo9eTp?=
 =?us-ascii?Q?Kjq/RIicmPpOMfib98DfRpOJupv8FkP5CBwN1ONc1IqIomT6V52DRrzcwpyB?=
 =?us-ascii?Q?d2npDZrFa64U7BqJXPJp6weLaJr8rZadjgvKwJtdsdEnAkoDF1NuQre/SMO8?=
 =?us-ascii?Q?NbqYr10fEeQSJu4wFTJn8ycjdWi6G9UzvfI+5dtEf7Bj2GA4F5PQXFAnmdx4?=
 =?us-ascii?Q?XfXlAj61UGUdIxD4tGoGJL3C79JWxNLAS/RccL9wKZF4XP1OZM+hdFdYyO8a?=
 =?us-ascii?Q?zPYpD8TcP0BJDGOb1IrepVcL41xZsTKRlV8Iqg3/2nlaBLE0YxlVe5HiLyAT?=
 =?us-ascii?Q?J5yrE8/bGuOECM1EHGUOoPw9mCSv4+YkcFoGQ7u/XLzKeGD9CjzmEf3TYZKL?=
 =?us-ascii?Q?WwXU9dD4jirhCyqm/pAIUvJUKjx+xvA5ttLa3gyuXyD5ahSiVHsuOghvrvDa?=
 =?us-ascii?Q?nGgV/eJt1EO5f/F7JK5Y3QDWGb7mlVtB4NTeZiIWLfjGUF0a/T6NbpHA+3Pu?=
 =?us-ascii?Q?OtBFVEVouuX58Q1d1/JHaA7pfE8jv3XpNkZWSsFLAAV3ucPg6ARLXLsXpVwW?=
 =?us-ascii?Q?tyCxIG3bAHg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5sRLwh65N3xnDfbN19UfihdLpHxgqzFSWkTJA6oIDo1NswXeytd5HTm6iw3k?=
 =?us-ascii?Q?PngX3qLtjwThk7NmiryBIqxA1MSwQoAi5utxy2D7N/QPOImGg4Pc7PkxPIEy?=
 =?us-ascii?Q?4OTC0+hE2SVYxirnWHyxc7G4J9lWcwliLpXQbBoD4JUh3IYJHZPHC/v9dlDg?=
 =?us-ascii?Q?ga71a2S8wrt0j3k+ZHkt3mnaiDK7n32OyFV3x4Uu5Nyn8JYwP+IRgRyODl/t?=
 =?us-ascii?Q?9w7ShvdOwlTmPuQ0VvB11Q8Aiuvya0Vsp5cFkANQsYeVfMX7nPQhRYDz7JX0?=
 =?us-ascii?Q?HmF6qs+rBla3DF/nFZ/nIHhGcyXkNLG5ndaY4q2vesglqTfiUxeJR3qjCL6o?=
 =?us-ascii?Q?pq7Za8ElbfKtRi/lPeVIQeViQItTZYGSvh0PpQDwxgUn0Hw1XAzm2Nx9yXf3?=
 =?us-ascii?Q?d5EgUpjX8CashLNlGBloWG1/V5YImWLKrGo97z95NdFMDJQTEuNN9eX5ReKy?=
 =?us-ascii?Q?Cv96W1bZYEPCezEmXoS2b5cA6jQts7ecJnlFqtw77Vt48jcv2N0Pt1AqgK3U?=
 =?us-ascii?Q?FQFnzk6LS3EDvemlx8n3T/Z/xGF54lHnkFibSsuY1aWrs0542T39kCUFWY/y?=
 =?us-ascii?Q?SJbs/GiCwuXZNNmgmhHd8jriKUUmDOHNLbrPeGXOzRxp38uMmstVrgnN6UtE?=
 =?us-ascii?Q?7tOmobsOCzMnv7ryNBbqnyZL9oE2CDlQUvnHQCLR2MyEPYMuUBCUgZf04ahR?=
 =?us-ascii?Q?fFdbJmvvEtabEbM5l4zyQbp6zzTky6bZIaShOxCy+HXcfhFYZNNvAcu9wAk+?=
 =?us-ascii?Q?JIK+CtZrFX010A14VVzTgBWiPtOqksHHosrwbvPB2EBFleEFUOAWuE+LvI2M?=
 =?us-ascii?Q?ws9dP6ULDTd5fNp+Mn0mqI7ZDMWQe1ts3J3IzjYeEwPd9Ux9ogKuYCJz3MaB?=
 =?us-ascii?Q?upG+z9n50zfBqUQIWJnAYYoDf+dMWMfSL6ellLdcyc9JolzGETQJXhR3VQwB?=
 =?us-ascii?Q?SLfO2t9Cfkrc+Z+Xyd1uwZN04IVrfd+WTHikKhJMnJNVHIY9l8Fe1OlC8PQO?=
 =?us-ascii?Q?hXoCDoqdxjr9Ekxl2r2Exa8HK02mZuQfSO17rOicfV7jICQSPeLDZlLQ9wSM?=
 =?us-ascii?Q?Yhh5hRgJI0XeKx7/cbGnZtlrN6sHxKHaDK3UuqzO6sDCzhey+/ccuv3aeH6u?=
 =?us-ascii?Q?OOjXQZIDrkHjPl0QrqU6fjieYl09hBExe4X8QK4YukfnyKO6uQzKUFWvSol/?=
 =?us-ascii?Q?yZVFtraaThUchWTExNEtV84JVSMZ5bXkkrUucYDQJms3gmA6GW5B30x+usYS?=
 =?us-ascii?Q?GKpPf/yTXZyQ1vBJP/txO3uS5MHMI2U9XxNQLBO0MaIyk+kEpE1bRFq9PR3e?=
 =?us-ascii?Q?pIz97ErAW8n9xwlRjk5Xb7AxmdAR/pTreyYNHYEuaSfEuWR+iPF+m3nG3eVT?=
 =?us-ascii?Q?2CtvZwueoINWC7O+F98HI1ZjcC81FV+pkKGpRMYuqlIH+2wRXa2nFqcOjYYX?=
 =?us-ascii?Q?z+5bQ8xyAvIUCGydquUa4sd5rjeTUyyHzUHbzf83aT8V9rC1603DvuyI+6jO?=
 =?us-ascii?Q?gGA0BxGArY37NCcc+0kIKcAi6DVnenQVt1VO+AJm1dUDrRyy6iVBXdOU6Ont?=
 =?us-ascii?Q?cV59uYbssR+Ed3OKAfS/dpooSkwXUYfTsFVthxzg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e07fd59b-92ac-4c9d-0a8f-08ddb978a25a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2025 14:56:33.0816
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Dgf0AcvRaCIiNaQKjasaIPBwiqG5PhRQmKBxJLb5wKXh09w2CrskxBFa1MQE2fPj
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4309

On Tue, Jun 24, 2025 at 02:06:04PM -0600, Alex Williamson wrote:
> > This is used to control access to a VF unless there is co-ordination with
> > the owner of the PF.
> > 
> > Since we no longer have a device name pass the token directly though
> 
> s/name pass/name, pass/ s/though/through/

Got it
> > @@ -132,6 +132,7 @@ struct vfio_device_ops {
> >  	int	(*mmap)(struct vfio_device *vdev, struct vm_area_struct *vma);
> >  	void	(*request)(struct vfio_device *vdev, unsigned int count);
> >  	int	(*match)(struct vfio_device *vdev, char *buf);
> > +	int	(*match_token_uuid)(struct vfio_device *vdev, const uuid_t *uuid);
> >  	void	(*dma_unmap)(struct vfio_device *vdev, u64 iova, u64 length);
> >  	int	(*device_feature)(struct vfio_device *device, u32 flags,
> >  				  void __user *arg, size_t argsz);
> 
> Update the structure comments.

 * @match_token_uuid: Optional device token match/validation. Return 0
 *         if the uuid is valid for the device, -errno otherwise. uuid is NULL
 *         if none was provided.

> > diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> > index fbb472dd99b361..f541044e42a2ad 100644
> > --- a/include/linux/vfio_pci_core.h
> > +++ b/include/linux/vfio_pci_core.h
> > @@ -122,6 +122,8 @@ ssize_t vfio_pci_core_write(struct vfio_device *core_vdev, const char __user *bu
> >  int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma);
> >  void vfio_pci_core_request(struct vfio_device *core_vdev, unsigned int count);
> >  int vfio_pci_core_match(struct vfio_device *core_vdev, char *buf);
> > +int vfio_pci_core_match_token_uuid(struct vfio_device *core_vdev,
> > +				   const uuid_t *uuid);
> >  int vfio_pci_core_enable(struct vfio_pci_core_device *vdev);
> >  void vfio_pci_core_disable(struct vfio_pci_core_device *vdev);
> >  void vfio_pci_core_finish_enable(struct vfio_pci_core_device *vdev);
> > diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> > index 5764f315137f99..48233ec4daf7b4 100644
> > --- a/include/uapi/linux/vfio.h
> > +++ b/include/uapi/linux/vfio.h
> > @@ -901,14 +901,18 @@ struct vfio_device_feature {
> >  
> >  #define VFIO_DEVICE_FEATURE		_IO(VFIO_TYPE, VFIO_BASE + 17)
> >  
> > +#define VFIO_DEVICE_BIND_TOKEN (1 << 0)
> 
> We tend to define ioctl flags within the ioctl data structure and
> include "_FLAG_" in the name.

 */
struct vfio_device_bind_iommufd {
	__u32		argsz;
	__u32		flags;
#define VFIO_DEVICE_BIND_FLAG_TOKEN (1 << 0)
	__s32		iommufd;

> > @@ -924,6 +934,7 @@ struct vfio_device_bind_iommufd {
> >  	__u32		flags;
> >  	__s32		iommufd;
> >  	__u32		out_devid;
> > +	__aligned_u64	token_uuid_ptr;
> >  };
> 
> So we're expecting in the general case, old code doesn't set the flag,
> doesn't need a token, continues to work.

Yes

> There's potentially a narrow case of old code that should have
> required a token, which now intentionally breaks.

Yes

> We're not offering an introspection mechanism
> here, but doing so also doesn't add a lot of value. 

Right.

> Userspace needs to know the token to pass anyway.  Is that how you
> see it?

Yes, we are fixing a security bug here.
 
> Do note that QEMU already has support for this in the legacy interface
> and should just need to reparse the token from the name provided
> through the attach_device callback and pass it through to the
> iommufd_cdev_connect_and_bind() function.

Yes, that sounds right.

I will repost it and hopefully someone has an easy test environment

Jason

