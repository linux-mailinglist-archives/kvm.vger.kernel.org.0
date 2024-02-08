Return-Path: <kvm+bounces-8363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 66D2B84E728
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 18:54:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 999C91C2377A
	for <lists+kvm@lfdr.de>; Thu,  8 Feb 2024 17:54:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F11082D93;
	Thu,  8 Feb 2024 17:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="rXihybVg"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2054.outbound.protection.outlook.com [40.107.220.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74E27EF19;
	Thu,  8 Feb 2024 17:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707414885; cv=fail; b=XB0BYldQyw5ucNHn5p/Xn/+fsL5ulWG4iT0za2b/zf+KZjM3rbzILqe0kDCnqX7yuRt1xR7MlNaoMvPXEJj+zEV4mkUmhtj0mMJ22HJBPKhmKXYZz5UADVYHyGeFotrLGMto6vvwuPCb631eeAd37C/wLJA+UbCUcgL0kwKTI9g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707414885; c=relaxed/simple;
	bh=OIIUjliddAhyFws16WexoaNTPpgi2lyzQwxYTjn0VME=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=fiNk6ggZ+IXD32Kta2802cXcHtVjqz32CzasFILIL6xo4nhKuO8Y9QpZ+NrwlMWjDE23Og6+t/1JMhrnrNx1q0FumE3uXp2IvNvhcZyEnD7JAFPvZRnzusEfiu4tKkUrmQg0HS0NdzAxZsCSlwzWzQ3EzqyEKyAO4yuedkTAcQE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=rXihybVg; arc=fail smtp.client-ip=40.107.220.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MU3nThMZc0PjWm14Zr4Yhzb8iYlMpGIJ3//ZQDiebBiLnB0yEPwCu9U2yxWn0Gg7aGPd0Eg5mFCt3G12bp7kiAP5TvFgQhYCyXgKBkEx8oplAfpyl/dNnnPtpMtzhwD8apv8ah/QMpylvKSkwCWvT4DBCQECNcEji15hVeR9gbGopaQtg0vbwHPA0WxCxdWTxJzDElWfSKzvG7qz/sTl3Bqm8thmTIbByGPFv2KkhyxBzOOmbxtOwpxVS8NWB2y6xHRTfmGAIL6bME9iDVSm2ufWhwlI0fOs9ELe8zzKTJfwsNI7ft2n12tWEwhyL4OyLoCNp8lm2xuY7vrt7I3DWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xqxw6e5DWVT0RzmWzxNy8uivJIwSoRLJ/LuJrj+mq7c=;
 b=jhFUYlOEnij6uZpTqzo1LcrokcU0bqNwEXwwor4moGZoAyktBwFqOvWf9F25EvsWA70NUIgwiWH6CVMgmo8Z3/EPakvJ87K7RUr2u6Utk6FuL+s8GHYXqbBJJK97I+pOqAOSuHr0eO6CtCSU4Hr2ZNRJnc7+4kUOI32YNizC3UjD5OiwlgKBk1YB9RA+XyF0AqlSfbfNcGMAqLCfwiF+P0Uy2NqyeQOkMCbbiQvG2aB+QnU7AitNlwfsqsYjhYvbDzN32F90xBcKzTlbq3fDfw5+I6BJbPqfBXE3/wx2aDbKfQXleoqC/ucRuH7ynTPwZHtvuhe3R7Pif4y6FZu6Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xqxw6e5DWVT0RzmWzxNy8uivJIwSoRLJ/LuJrj+mq7c=;
 b=rXihybVg9w4tvfSBepkQ7+B3K5i+A6F8ghQFG6q2RBYpO7CGuyQ3tfXk/K1gReIYtBEBDIWee4MCidwETsC3u1WPeTo27MsrfBbQs/umtVgtGgkkfkyMEYbMvYE1E6KA/mtnlMBa4kxuAhH/XDQXZDpSY62LTd1bxMb4ZnWwmjCEDgBSoJO1ZGliElvKANZ5mfjaEYZwJz2pwZVzFfWsNdqCORo4UMehWZYNYf7/vwmBv6/GSgGpTU8U8+mqE4acLbIq1AWJKs0uw/CnoiRNI0HgNWLcm16T0BJkiglNyGOVjwxurOON+KdlU/iSbVEVM/NturL1xR0g3qVdtqQCkQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SA0PR12MB4382.namprd12.prod.outlook.com (2603:10b6:806:9a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.17; Thu, 8 Feb
 2024 17:54:39 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7270.012; Thu, 8 Feb 2024
 17:54:39 +0000
Date: Thu, 8 Feb 2024 13:54:37 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: ankita@nvidia.com, maz@kernel.org, oliver.upton@linux.dev,
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	reinette.chatre@intel.com, surenb@google.com, stefanha@redhat.com,
	brauner@kernel.org, catalin.marinas@arm.com, will@kernel.org,
	mark.rutland@arm.com, kevin.tian@intel.com, yi.l.liu@intel.com,
	ardb@kernel.org, akpm@linux-foundation.org, andreyknvl@gmail.com,
	wangjinchao@xfusion.com, gshan@redhat.com, ricarkol@google.com,
	linux-mm@kvack.org, lpieralisi@kernel.org, rananta@google.com,
	ryan.roberts@arm.com, aniketa@nvidia.com, cjia@nvidia.com,
	kwankhede@nvidia.com, targupta@nvidia.com, vsethi@nvidia.com,
	acurrid@nvidia.com, apopple@nvidia.com, jhubbard@nvidia.com,
	danw@nvidia.com, kvmarm@lists.linux.dev, mochs@nvidia.com,
	zhiw@nvidia.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v6 4/4] vfio: convey kvm that the vfio-pci device is wc
 safe
Message-ID: <20240208175437.GN10476@nvidia.com>
References: <20240207204652.22954-1-ankita@nvidia.com>
 <20240207204652.22954-5-ankita@nvidia.com>
 <20240208103022.452a1ba3.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240208103022.452a1ba3.alex.williamson@redhat.com>
X-ClientProxiedBy: SN7PR04CA0116.namprd04.prod.outlook.com
 (2603:10b6:806:122::31) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SA0PR12MB4382:EE_
X-MS-Office365-Filtering-Correlation-Id: 14dfc7ae-81a6-475c-fa85-08dc28cf0509
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	gY38sRbAX9KKtT9U/dmgvlHRYAHy4njlxSgIew5l1/HgoOLW2nT8+jH3C+fHHahwJq8w0wj6UV8y1J1D/gqmt46/LLCAeBEP29Yf6d00x7Xdh1Nz0h/yTCVT6tD8qNwmah2mkaE4gmpqS8Ntp7rX9eDeaEttZkGUMvlogr9PymMOG+1ymxx8CxdZTXhzzeh4gl6538RARrfIyY7pozer38mPQcxA/DkEbO8d479f467y2iXYPCmE9Eqf20lutuhfr+A1FdLxKIKMopWrLUGRas6Q6Sy25DupMjnC246jJ7TWd+9b7MSzYkKRM2tIqTC7NZV7Qc6J8FL9TTURMf4NkJ2FyGGDu8O4tAjelWKmZCBqUFY2i3xr1tPo5eDLAazzT9OKmlmDbOWKG84NhTZd5MHeWHvP+QuRONpwL4Id3o7m0bwECpyIwMZRhJWUTNiKctcgjV3hXPpC9ro6wXLK/MIvYAlqQarDVRoilXTZ8v9vQNdRTG325MwOC8SACofaH5E1NHPQAN7Xz/Cv3wrRFIfuSme2X3QDRexs83DuaKkEyiKROJ0MkZqCgZ4DifF7
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(396003)(136003)(346002)(366004)(230922051799003)(1800799012)(64100799003)(186009)(451199024)(41300700001)(66476007)(36756003)(8936002)(6486002)(8676002)(4326008)(316002)(66556008)(6916009)(66946007)(6506007)(2906002)(38100700002)(86362001)(7416002)(5660300002)(478600001)(6512007)(2616005)(33656002)(26005)(1076003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?r77S6RF0yHkBa4u6f2ffuw3rxX/X8gTB9T/kBpP4oZMl4E8T6scZvzX0r1r5?=
 =?us-ascii?Q?IwWN411/pgy9bNg6CBVxRlxY90JsQihr45+ROtMIDCFjhQJ8taenAsIs6ssK?=
 =?us-ascii?Q?4gIOwvDaQj9Jn+C7v/g/nw7IfLcinpMa/wT4AYe7DYsu7sLR8RuWeUAsbpQD?=
 =?us-ascii?Q?P7mSkFCDRxMvlfpQW8YjcxgfP8nx2QIqk5ZdYgIoRBXKTFTzXzcpRX7r9Jwv?=
 =?us-ascii?Q?YOS8H+qTI7f7I7vinvO8oXV199icdq3Q5IvPRHlIDJQYH66lZ0gmst02nQRk?=
 =?us-ascii?Q?2Axt6fYgATFNR3CfeIvOcfznJypDBgFxUcsXUtheDApGH8VsHZBxhpwSEwkM?=
 =?us-ascii?Q?UsRW6iFurmB9ax3TKFwXWtI+tZDbrkJimURAdnJW87t0nTtM52rIP3jK2qgk?=
 =?us-ascii?Q?GDtZUfvb/+7/danRztAjIMGZh4VXIjYcznmzJ/swSG2Pyk9Ps1nKEXeP2RT2?=
 =?us-ascii?Q?3p08PU5aSQ6K/92iHojLDcYkF0BNDOTf4EdO/HAeH/fDLxgMwdnB1enInW+S?=
 =?us-ascii?Q?MZkJW4c0taU4gpz291qbwaRMfxgYcTDU9jrs86VrILIJxJbe5F0jzKc+X4hv?=
 =?us-ascii?Q?XO6dw5+iYAAY9HCVMKVLFLXCZtEpEWqZW3KEYzLHhhjEXwOqrL8/HBPYdYG5?=
 =?us-ascii?Q?xHQ0EmEs4s5L+UhzEgUpAveeRUPTwxTe9YW7mNc57E+AUtikPL9aQ3f6+8qD?=
 =?us-ascii?Q?42a7no+ZawNPucQ7CHGdYHLch10wNaOAR9LUg0gnPrW79qNmbs8AC+yR8Ltm?=
 =?us-ascii?Q?OqQfb7DifrwHUxyXeWZG0sTQxtkb11O8c2BdiS5HJL0R6wvqOk+VLGUEhffj?=
 =?us-ascii?Q?+olYyNf/xgQE53+yuLhrUkTYj4FEGhVtS0DqhsW8Bp/PjnrQBIA0H5uON+Fi?=
 =?us-ascii?Q?pE/Gde3SiFvBacxHrjhsMY2kiGX048+0AwEN3rxTV4J6a0zgtDUgmiEGWFSh?=
 =?us-ascii?Q?C0BOl9KoNMG9R51tg1v62Bya1tyNm0gzwVwnE1J5pswl2Iydtqxc6wgfsylx?=
 =?us-ascii?Q?YIAkK4OeWapBvesKZdYfopYW50/Fx+jQd5osQmOxKjU6tykVGV1cp9bah5zo?=
 =?us-ascii?Q?AmA+Opge3rmiE1UK9SaGfngJzig/Rc6h+QcHZTfC8zYszKj+PQMsjfceI/Po?=
 =?us-ascii?Q?6dxe0oJ7l7Z0xpOctOLqhZFIx+TZ6ebsPrOBqGAeQo91OFXz4GT6sebHyoLS?=
 =?us-ascii?Q?RrLYnXmE0R9CymhYp3VII3VwbjoYS5gi8+66nSz18crSo9IYXXih2BNRAKbE?=
 =?us-ascii?Q?wH/SuTqGsKsRev9PcfD6DRFG10ZAuelzi4/JqgUHIfXjOw9nv14y7/KVOcT1?=
 =?us-ascii?Q?AvI7IKlmXnM/XPAwoGN4/YE/eXTzLOfLYw2Ul7BaSfa4P6lkGN6clThkbOPw?=
 =?us-ascii?Q?tBoqoajEtd7BUlVMBJUqeg82mnwbEpC7vtLNNPxHBcJIj4/NisBwcdlcTmUT?=
 =?us-ascii?Q?c+YgBmhPHopuZ78RgjzGdFVGS6fxFXs4Qh2PQ3MkjL/QDJdvo1c6xRWA8h1/?=
 =?us-ascii?Q?DjdgkeS+Vc6H1LZAuFHF5NFvcoQTg5dNSq5wfPM3QzC+AfMY2A3tb5l84WxU?=
 =?us-ascii?Q?YFATxeoDW4EcEre20U5+R4tHikE9llKo9VPy+ToD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14dfc7ae-81a6-475c-fa85-08dc28cf0509
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2024 17:54:38.8848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JDzxDXXfzjLbLFSHSyKpd9JhBWIRyDdWPF/tQyfg4X5BmZv18CAtdYvUlHlKjcSg
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4382

On Thu, Feb 08, 2024 at 10:30:22AM -0700, Alex Williamson wrote:
> On Thu, 8 Feb 2024 02:16:52 +0530
> <ankita@nvidia.com> wrote:
> 
> > From: Ankit Agrawal <ankita@nvidia.com>
> > 
> > The code to map the MMIO in S2 as NormalNC is enabled when conveyed
> > that the device is WC safe using a new flag VM_VFIO_ALLOW_WC.
> > 
> > Make vfio-pci set the VM_VFIO_ALLOW_WC flag.
> > 
> > This could be extended to other devices in the future once that
> > is deemed safe.
> > 
> > Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> > Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
> > Acked-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  drivers/vfio/pci/vfio_pci_core.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
> > index 1cbc990d42e0..c3f95ec7fc3a 100644
> > --- a/drivers/vfio/pci/vfio_pci_core.c
> > +++ b/drivers/vfio/pci/vfio_pci_core.c
> > @@ -1863,7 +1863,8 @@ int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma
> >  	 * See remap_pfn_range(), called from vfio_pci_fault() but we can't
> >  	 * change vm_flags within the fault handler.  Set them now.
> >  	 */
> > -	vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
> > +	vm_flags_set(vma, VM_VFIO_ALLOW_WC | VM_IO | VM_PFNMAP |
> > +			VM_DONTEXPAND | VM_DONTDUMP);
> >  	vma->vm_ops = &vfio_pci_mmap_ops;
> >  
> >  	return 0;
> 
> The comment above this is justifying the flags as equivalent to those
> set by the remap_pfn_range() path.  That's no longer the case and the
> additional flag needs to be described there.
> 
> I'm honestly surprised that a vm_flags bit named so specifically for a
> single driver has gotten this far.  

IIRC there was a small bike shed and this is what we came up
with. Realistically it should not be used by anything but VFIO and KVM
together. Generic names do sometimes invite abuse :)

> It seems like the vfio use case for
> this and associated FUD for other use cases could all be encompassed
> in

I think Ankit is talking about vfio-platform drivers by "other
devices".

This is largely why it exists at all, there is a fear that the non-PCI
VFIO devices will not be implemented the same as the PCI devices. If
any platform devices have workloads that require WC and have HW that
is safe then they will set the flag somehow in the vfio platform
drivers.

> the comment where the bit is defined and we could use a name like
> VM_ALLOW_ANY_UNCACHED or VM_IO_ANY.  Thanks,

I'd pick VM_ALLOW_ANY_UNCACHED of those two

Thanks,
Jason

