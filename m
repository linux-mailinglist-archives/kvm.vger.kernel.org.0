Return-Path: <kvm+bounces-8567-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 618EF851B28
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 18:20:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 11A7528BFEA
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 17:20:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D048B3E47B;
	Mon, 12 Feb 2024 17:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="NgVgxKbP"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2047.outbound.protection.outlook.com [40.107.237.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5599D3DB81;
	Mon, 12 Feb 2024 17:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707758411; cv=fail; b=BtMya/2xBpAFmas7kSUMKO3rGVhVaA+pwTiedOnMCH1jTIB3yR43DCaF2z60hgwspjOb2Zs5V22rZ1rYL5J3uCjRoHnYKE62ge4bEV8mAwH2BFRf4/9EfT5EfKHHGSyYyYwU77NHUouVmV1vc8+iyle8BOa7WIIaQw8OhawWdow=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707758411; c=relaxed/simple;
	bh=A3apuQ7Z9LWZXJ+rNVORm5QWHRNKNmxYYeJBgx5+QSc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=BAZtYw8Re6fMfqiIXFWSx11TVoEhe8J5rDoHofoCP1tPqpj0ZfxhcYTnCqi2DAdIRtA19XnjyxYga2UTq87ugcfFtByFSQdR0Hl4/ItIBeMhZYgKFtKMFrfU1os/zYhm4U67IyGC8dYKVbFJstO6t0sF5m+hftIqzsqM+iUAFXg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=NgVgxKbP; arc=fail smtp.client-ip=40.107.237.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LrHnMiMro2hZ+vFykjr0n/EUMdWmfRwVw5RpeqI3f9hlOoIQ3vTFNJcwtSbwfGqM4a9CqrxSy4AVw1dfgRqBEY2W9YEHRv1Bs4d5FStIBfWNMzbFhbB22bpEvvR3Ii+M/WgZSyDEIawGBRsQnm2LMyi43Y9HAf86mHD7hrKeBeZTWPWrT1UgzlTG8tqkKCtXQDVt3mtjRC0YkpSZJKOcZRtuvrhQcbhwSurFY36nPlY/X+GyqX+miXxEaPgmZSdWwFWoX+YRkZ6b1blSPUaNc0JHwcidKOtmva5mJlqj5+B2CEbWbycY2X0kW8s/Tt3Vhp892mEvVTwDVplJROCxGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VQR0BVLz67QrbRtVx1GVfNZGKvTaJlmmFmFMNVhkPPQ=;
 b=RHpwbu7jrsS6iJ5LxvuwXWp+zxUXR0BnfzxtWFwhRJUIpo7w3wIlLLSFaSblhtw8aacQlKZy4wBVQbAdXfNq0NYjrDoFZYesNXhVcVSUjmTiVeZCQBj7jxxEaVQOrHCiRry6VSjIcmh2t5YSwbRaKw4F8s4Mugi4L2UOF7aV6qAi1FE2XatCQuiNOks7ixEvYwN24F3QE3yjyGRU0qStQLvW+tzpBiRKXWJrJhnrxZpaXy8CDgtOyAgdqfCDnSFFFvN+z+ltgMYPhl3nKrz4AukF9KFWQ/GF+vDfXuv/fJcgF1f6g8tMIsSfHiBWi6mlRbOnXMZ5h2zROmQWwvRkyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VQR0BVLz67QrbRtVx1GVfNZGKvTaJlmmFmFMNVhkPPQ=;
 b=NgVgxKbPI/NYg4OyYEKJHRou9TXPOnuO3mBbayQ88K9agIBC7X9abFnw4gLJqVSHfThFr6NXz68IsIcjiFsOvq9dFPFDzKx8bpdJ4UN97Iw6tEUs8pVfIF8DmygzAnKMMuwnb35nAtjEarnuYS9bKQpv8ybtznO/SB3hOB0Vw9WU/HNoYIX17aXA7LkCDXCPs9XvxOu0H1bm/KC74Vv5Tl9B7Ww+vOVzx5a3Bql1Ga0w6O+v8xH1stxaIThmOmtMJRhZi6/8prVISGzi9JfSGL9w5lXOFAX2Xrg63pRvCAe/S2b4qJqxMEmyWea5XMKleTPISQLz32H8OMSkWSji7A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MN0PR12MB5833.namprd12.prod.outlook.com (2603:10b6:208:378::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.11; Mon, 12 Feb
 2024 17:20:03 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7292.022; Mon, 12 Feb 2024
 17:20:03 +0000
Date: Mon, 12 Feb 2024 13:20:01 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: ankita@nvidia.com, maz@kernel.org, oliver.upton@linux.dev,
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	reinette.chatre@intel.com, surenb@google.com, stefanha@redhat.com,
	brauner@kernel.org, catalin.marinas@arm.com, will@kernel.org,
	mark.rutland@arm.com, kevin.tian@intel.com, yi.l.liu@intel.com,
	ardb@kernel.org, akpm@linux-foundation.org, andreyknvl@gmail.com,
	wangjinchao@xfusion.com, gshan@redhat.com, shahuang@redhat.com,
	ricarkol@google.com, linux-mm@kvack.org, lpieralisi@kernel.org,
	rananta@google.com, ryan.roberts@arm.com, david@redhat.com,
	linus.walleij@linaro.org, bhe@redhat.com, aniketa@nvidia.com,
	cjia@nvidia.com, kwankhede@nvidia.com, targupta@nvidia.com,
	vsethi@nvidia.com, acurrid@nvidia.com, apopple@nvidia.com,
	jhubbard@nvidia.com, danw@nvidia.com, kvmarm@lists.linux.dev,
	mochs@nvidia.com, zhiw@nvidia.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v7 4/4] vfio: convey kvm that the vfio-pci device is wc
 safe
Message-ID: <20240212172001.GE4048826@nvidia.com>
References: <20240211174705.31992-1-ankita@nvidia.com>
 <20240211174705.31992-5-ankita@nvidia.com>
 <20240212100502.2b5009e4.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240212100502.2b5009e4.alex.williamson@redhat.com>
X-ClientProxiedBy: SN7PR04CA0011.namprd04.prod.outlook.com
 (2603:10b6:806:f2::16) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MN0PR12MB5833:EE_
X-MS-Office365-Filtering-Correlation-Id: 2409020f-b55a-4374-2a81-08dc2beed948
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	b47fxxQeullwu0wNom0eBjaR9/iO84pAgZqNt+30IzCDBBS0IEpfIACaN0N+RumsbptsHVE/W9TILutn1d6nBsHpSMBhG7vUj6O3wUn4dWToOlVQIWDGLo14us5T+uWlPXw48gxMHab06xLFY0mj7fAzZVE6nGUMLLMh3Fat5w3ir2fiHn7K4gXS3xBUhnSoY9okIJzbeY9fc7P7ABsDqyYKJCG0ZSd/uiqJ+Qw8aekuODrk8QYZSRMty9BDjKomjiPhppr114QR3soqEgc6c9LeUMqBXFxyi4jMLflS0DUvj4RY0guJw2F7KBBNVCvXgRhq8NLU0K8otZtcYlnVnVtLGyIWlZFAaCyAodIvuwC7rnJlxDc3HuKaPNs759aPpHXAXIkXRqiNOy4cjyXCcQIV77v46ePzASbsZg8bvAOtFf+XXgukCjroCFNxZvMAE0Y5IgjdAgtOO2Y0bR9/T/8IlRGdqhDkb0AOwPIhT82RntQR22mx1f0hvX4AP2+cxbbGRWZVhk9iHMsb+BC31e22yTOuECLodiymXzq27uf+JHhV0Omu+JLSQpZvyx/k
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(136003)(39860400002)(376002)(366004)(230922051799003)(230273577357003)(1800799012)(451199024)(186009)(64100799003)(8936002)(33656002)(6512007)(83380400001)(1076003)(478600001)(36756003)(26005)(4326008)(8676002)(2616005)(5660300002)(86362001)(66556008)(6916009)(316002)(66946007)(6506007)(38100700002)(6486002)(66476007)(41300700001)(2906002)(7416002)(7406005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hKkxzKYr2xJFhMeinkz62jk7Dq+AfHOMJn4ypocVb+FZLGMb7StH8OrOFKyZ?=
 =?us-ascii?Q?mRi7MfwefISaDyMvg9dbrCiqxfngQZrQYA/wSXXhouCm6cscfAtINy0IKic3?=
 =?us-ascii?Q?+JWGmdiq60lW5UwEOKqFFKRhE6Fuun0vvtBCI3iE+J1Q6RV/mfgdFueQ78Mk?=
 =?us-ascii?Q?z3jlGJzPzDwRCq9GItBEUhhZASkxwpWRe/8uvvLTiNpn3jdcFWgHiQumg9iF?=
 =?us-ascii?Q?eJ0VLjofyOtIXVmT1our8avBZBxyxVWqwDxxZIvoVYsML7RKOHzhW5Iqn3KQ?=
 =?us-ascii?Q?yFKB2sSEEUzkohDffX9JXxXLBIx3fcRUvo1XuxZIKpK/OTYyZSr64D9LFM/7?=
 =?us-ascii?Q?bdk5+bFs8i7FEJnuxWK47cYM0pbEStFKU3GsfgS+b5CJx2LNXdGX4q+ms8+J?=
 =?us-ascii?Q?xf++nE+6mSlmliX/cyJcbAJF28kffPSuCMLH1EMLQyruyHbDJW8FbX6RN1+j?=
 =?us-ascii?Q?ntzLKUBDC8HL9bFNtfK42AUhjPayji/jQn5auiR3JFwWMt5flEp2gO9ZahVm?=
 =?us-ascii?Q?JLjAcGAMfHQGLYchhW5ttajSpAifKctiuvDYowWHMDfTQZc2EYlfmYRQKvJS?=
 =?us-ascii?Q?e8xd8XuO9kp3LV99vVhFLZqSy34xsUWNTPt+fL0d0RSkCfjd3WxS6gdPkH7/?=
 =?us-ascii?Q?GmdzumMMijTuXqFBAYitbiGcpUsCpR3gzCeEaCNusx6OzP9f8TQlwkjo3fAB?=
 =?us-ascii?Q?20sOtGJH7S96XcfZS76XM/s+2DWWl4ejw07EclTBr6NiJ+SQSfoz+iNeXfpk?=
 =?us-ascii?Q?0kN6eEnO4FwTDBJ38RimJNWRPBIOVT1BuU+Anrrv4UOIu29E/TfB/xPYBvut?=
 =?us-ascii?Q?oQGihqeNgKJZnNO2owygqKjtRtA2sCwR/156FhprGxVQ9EHx98i4kYc4P8FB?=
 =?us-ascii?Q?LnFyx+yomga9/Lzyphb10/ab0ayaEs8k1LMDpuoGJZ6HwdRlj7m5v3vBWZaY?=
 =?us-ascii?Q?CQKBrHop87G6sWaCGiDS/1lsaP3zolmjbbp+K9HYfh7T9i+upL0STOioq1l2?=
 =?us-ascii?Q?jeXZj9YiWK7pe61euFyZkszJxyJOBjqYGxwAuX/y62k5a4+F1dscbltQMuJO?=
 =?us-ascii?Q?rsfXi4mR+c7Bh7QcHTChS4aMnzJlEe0mhC0eao5mpiKf/u03iA5Tt4N1cuhH?=
 =?us-ascii?Q?GANcl/ybPrpLSUprzu4spKIRNDMiGyg8olxgYReQRJvn3NYg69Z0FCDnusH2?=
 =?us-ascii?Q?Tbbh+Q2ja0PLZoaRWm7DcdPvI1sRGTeGYUdLXS0s//y65Yu2XRJs2ZacWMjl?=
 =?us-ascii?Q?IZXLQO1gbqJCufV85hIO022lqXQXD0sgyMiPLO765iaRoUit4lrvabp86ch1?=
 =?us-ascii?Q?xXTcnI9pF+dV0d6wSKSHvLputrNUFVl0AFNpmJK/CO4+MSEHZffz0esUhKMO?=
 =?us-ascii?Q?/LGDVqG3PqWHyDdyDWKrsQKMXu1qaIzArYlypdOHo6oxTLltgnK6CtJLXcU4?=
 =?us-ascii?Q?ehQWdr0tzFJ/nkWN6K53c/KhCtZs86A8WoEN9t84ISUqHbyz5QHcyW7WTAbq?=
 =?us-ascii?Q?AX3FzffzvcLiI0mjNdEMroYpMTcm14hkOb+octhzYgzgwMB4yfHAJ50PzQDc?=
 =?us-ascii?Q?8k67yGoKH3thUWiPQbEfGBnHgvx38z8tmz9QGb5o?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2409020f-b55a-4374-2a81-08dc2beed948
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2024 17:20:02.8712
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t4T78shQrFoSGfttqSojbTara59pg36kxNwXNAg018j6CZ49bvj7mM6pdMFZNuwc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5833

On Mon, Feb 12, 2024 at 10:05:02AM -0700, Alex Williamson wrote:

> > --- a/drivers/vfio/pci/vfio_pci_core.c
> > +++ b/drivers/vfio/pci/vfio_pci_core.c
> > @@ -1862,8 +1862,12 @@ int vfio_pci_core_mmap(struct vfio_device *core_vdev, struct vm_area_struct *vma
> >  	/*
> >  	 * See remap_pfn_range(), called from vfio_pci_fault() but we can't
> >  	 * change vm_flags within the fault handler.  Set them now.
> > +	 *
> > +	 * Set an additional flag VM_ALLOW_ANY_UNCACHED to convey kvm that
> > +	 * the device is wc safe.
> >  	 */
> 
> That's a pretty superficial comment.  Check that this is accurate, but
> maybe something like:
> 
> 	The VM_ALLOW_ANY_UNCACHED flag is implemented for ARM64,
> 	allowing stage 2 device mapping attributes to use Normal-NC
               ^^^^ 

> 	rather than DEVICE_nGnRE, which allows guest mappings
> 	supporting combining attributes (WC).  This attribute has
> 	potential risks with the GICv2 VCPU interface, but is expected
> 	to be safe for vfio-pci use cases.

Sure, if you want to elaborate more

  The VM_ALLOW_ANY_UNCACHED flag is implemented for ARM64,
  allowing KVM stage 2 device mapping attributes to use Normal-NC
  rather than DEVICE_nGnRE, which allows guest mappings
  supporting combining attributes (WC). ARM does not architecturally
  guarentee this is safe, and indeed some MMIO regions like the GICv2
  VCPU interface can trigger uncontained faults if Normal-NC is used.

  Even worse we expect there are platforms where even DEVICE_nGnRE can
  allow uncontained faults in conercases. Unfortunately existing ARM
  IP requires platform integration to take responsibility to prevent
  this.

  To safely use VFIO in KVM the platform must guarantee full safety
  in the guest where no action taken against a MMIO mapping can
  trigger an uncontainer failure. We belive that most VFIO PCI
  platforms support this for both mapping types, at least in common
  flows, based on some expectations of how PCI IP is integrated. This
  can be enabled more broadly, for instance into vfio-platform
  drivers, but only after the platform vendor completes auditing for
  safety.
 
> And specifically, I think these other devices that may be problematic
> as described in the cover letter is a warning against use for
> vfio-platform, is that correct?

Maybe more like "we have a general consensus that vfio-pci is likely
safe due to how PCI IP is typically integrated, but it is much less
obvious for other VFIO bus types. As there is no known WC user for
vfio-platform drivers be conservative and do not enable it."

Jason

