Return-Path: <kvm+bounces-49757-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B1FE5ADDCA7
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 21:47:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 511707AD1AC
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 19:45:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E18E32EAB86;
	Tue, 17 Jun 2025 19:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="kNsNfLxW"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2064.outbound.protection.outlook.com [40.107.244.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7652E7167;
	Tue, 17 Jun 2025 19:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.64
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750189590; cv=fail; b=TAAz9/xu1GsNCgidLlTWIW3dZys0W4vvcs3DNkyZa2xjZTV/FgEAVLoLSlW1EBqM6DlKu/PprcLpa9EsSC+IJuiW67GMGbarKvfN6mQrrhxTg+JqNT9ChxL6gUmFh960iRZgY273AMvZ47NzCRFm5sYUEBTSNAI+jhBvQt0WbQk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750189590; c=relaxed/simple;
	bh=AGMXgtvzaJh+/cfNSo5ZreHrf+g1mzCADgGYxmgQnbc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=VYcJzu+1jkbqROUbMA41StlhhYruRGXIKpVVGbsmUDy0a+LFgIK2rSD0A4I710wuyIXvtuGrlhDb1SjSVfNynKiItUnwGuAc1HnvXL+8Eq/O8Bzbf+coOUFHDwB+8y56138srPu7Uw2NC246k1mP8JdffyE26ykENuCSxIrgeqU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=kNsNfLxW; arc=fail smtp.client-ip=40.107.244.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qq3oJSEgG1lv1a66RDONCQ5xIAUyDjWyRilaMfvwAO9fDkYFSpBgWs8mzNYfxy4FlutJYg44X7x3q5a9uaaGZgkzZv2FUO+tBiFA19o0Fw9JUxPHg4VzNGvvzK4CfAOTfYYVCSegu1Cu0OLO+YuTPtbU3Ti4e3bLLUYXpuugLRKTt8qvGroRYZ11v+RAkIyzpeUmvi1oCcBMwUDZNLQ7Lsj+WR2pDfOkJitD8I3OkvIozcDtlr2pwn5rY+s7pQdhJVnRv99CantM/x+UXc0Dvn4yxX2bjcWISyPVio0N6SCaIlNe3p9b+Etv4QWY/0wZyHrNRBb+ma+qmooPZKIOLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=adlTw0BALeWFW/5VtFYDUbT9WcsWjfcLz89yoghOEhA=;
 b=rCSHUnFVBSpE63oJeka2+sq4yyfLZag8TKkch6jdLVlhiMGVhk34o2zB+rR0B/Kiol5nSApyIwScdRDjMW3U6xxt2PneYeMcr9uGpYpgixgH+er2UFeYgqca7Net0PDf/BEbncEb+9Ob7hJ50YfhcnMHSM5I5iNN3RjYm8xy1+LMATh27ZZHLkVQcwnxx+C9NaYLNI+ke/9fRp4Cy7eHg6y946FX60aR9kiMJFEl+IHn1tT25fS24rWbJZWKIDAQ9f76xDI2lSLkSFEX8W6kbcYDqj5HsoclSj8ajTEJJ6EfE7+PPo0MwkZ0ylH3JLAz/9VHCjAauDkH1lG+yKjs3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=adlTw0BALeWFW/5VtFYDUbT9WcsWjfcLz89yoghOEhA=;
 b=kNsNfLxWer1C8EPTqwYaKTgQw5r7MR1vJdldbOU1MliW3i4YfCCRXUONx8cv5hGBH9aMVVHfRWGZ+2H77Qqb9vCaFfg1zcZaqSH+T28yIYdUj/H13tJeUAQvR7kmIfOzbctCtbbDn6kqJdQA8/huGv/mMXlYtHQwhyA0DMhUmB5KM0dmeO85iwfD/muiiqDFRXfHNnOmZFTICgxvJiysfXxBxwmbbQTkduWKjRwMCdCYRCJARSIi6dcmMtZl9kZr9pK3fYdVAURjkzzqEWHSE3Y4ifqba7P5lT/ALY40SlqSUgdi4ZWpWWp03gw6ZUGbHcL/rX+kHolRbROhFqJ/fw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by CY5PR12MB6430.namprd12.prod.outlook.com (2603:10b6:930:3a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.30; Tue, 17 Jun
 2025 19:46:23 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8835.023; Tue, 17 Jun 2025
 19:46:22 +0000
Date: Tue, 17 Jun 2025 16:46:21 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Peter Xu <peterx@redhat.com>
Cc: kernel test robot <lkp@intel.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, kvm@vger.kernel.org,
	oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Zi Yan <ziy@nvidia.com>, Alex Mastro <amastro@fb.com>,
	David Hildenbrand <david@redhat.com>,
	Nico Pache <npache@redhat.com>
Subject: Re: [PATCH 4/5] vfio: Introduce vfio_device_ops.get_unmapped_area
 hook
Message-ID: <20250617194621.GA1575786@nvidia.com>
References: <20250613134111.469884-5-peterx@redhat.com>
 <202506142215.koMEU2rT-lkp@intel.com>
 <aFGMG3763eSv9l8b@x1.local>
 <20250617154157.GY1174925@nvidia.com>
 <aFGcJ-mjhZ1yT7Je@x1.local>
 <aFHEZw1ag6o0BkrS@x1.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFHEZw1ag6o0BkrS@x1.local>
X-ClientProxiedBy: YT4PR01CA0440.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10d::16) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|CY5PR12MB6430:EE_
X-MS-Office365-Filtering-Correlation-Id: 52ed5b9e-29d1-4739-f4dd-08ddadd7a330
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bheg/ZyMqmMFdpt6TXJQMRt+wdap9olDLOX4qDexUOVC3iiXqOCCqYyYG3TE?=
 =?us-ascii?Q?Af8g6ttBPRN/Y2u1EI5p8/2OOkyQ3FZj/9sT0qpDg/1KKT1WLEhTbnazL6sT?=
 =?us-ascii?Q?g/Ajx5BcJrJEhght82KyA27BGci5a3O7R77EKDzJqnyVkooHUC60G4BYHIHU?=
 =?us-ascii?Q?XueWW7uJqOHbgncJKj8TMBGFEZFv7ZMV9bLRs6GR/dOw4fvweOr/m2dv3HvJ?=
 =?us-ascii?Q?Y00cJrFq64vWWxEapza3o7WM1V0Z/QxKXdxqN8MBi9CDmduv8R2oUAM9hB1v?=
 =?us-ascii?Q?fKJ+XfBAUEAy+BbeARTGfYf3iseXOKDWC5TCymythGwh/AjLVXiP9xsGS/u2?=
 =?us-ascii?Q?2taT3mjKM9FedE3J4qnafNQSxgEppsx5vsiYrJbFWV+P4vdZEhnyORICymdU?=
 =?us-ascii?Q?DSlUvPBntf6T44VkRpvjA51IKjCm5lUiJi/m6XEuy5vLALfEsEjboN+hn0G7?=
 =?us-ascii?Q?yT7wndI/TlqCBGQKwOXCWjjOHRZhJqa0HVCw4Qwxy9/mXJ/MNKZzIb1tLn9Z?=
 =?us-ascii?Q?9NlQ8r3EOnCX1zuqw5SVA18F22ikhD8QUJejWVzft7aV+c2mZkP8Xg5taCKX?=
 =?us-ascii?Q?ArX3/495WvZVs8aAH9Qr7rkRfFarFfuBd/yvGjy8IDZvwRHlu3EdUoTFIyh9?=
 =?us-ascii?Q?scPcH7hVmAmAP5MG3KLEYIkn8PY/TSJ1VGGaMCx0wj6yFzz9zgy3/jfo02jt?=
 =?us-ascii?Q?EMc2JpZC4OozmVX04vfv4285QiPD9H1lFdjNJ1cPASJr5s2ku/LzEEEbb4jz?=
 =?us-ascii?Q?lQJ1HaXvkVoGdTe+dBEVl9p8aWZSmx4r1+vvrZx+SPzn0292nzickRDuiNts?=
 =?us-ascii?Q?4XfI3m+goNDcGeS93xNyc0O3qNH7yFLTc2mycuYtRjCCWW+HZdFik0UslJGP?=
 =?us-ascii?Q?KdQWbm6uKmF+TGkIVecDwOcCZNXbDcbJQ3JQl0ZDZzmglK7IUQr7V0W+VeiO?=
 =?us-ascii?Q?D42n5YHBhfS9ZMCeSgdjfEYS8Tp0FGzeIgwnsjYZnmfrmtYph1qOPvTtHsmy?=
 =?us-ascii?Q?l0cFO1bb/+jKdM8iHXBq2xKl8pE8aemL14fvWns+XsM3izMDLL7nr+zJS+Xf?=
 =?us-ascii?Q?gC6b1Ny4YxeiMxnHB8gd4wTInx4Rtma7wbr5GAiVrG4tLh52tqlaHugUVkHO?=
 =?us-ascii?Q?cCZ2heN5l4VWOc1sd2Y9fhqWyR8FGTOBJyyuPJ47XhehCMFwPNXaD73jjMKB?=
 =?us-ascii?Q?oabCbz3HZ95ipJa4rKJI/m/CW3u3NlicvCpfHU3mKqLPQWH9JHHEJlU0JbhY?=
 =?us-ascii?Q?pl0d13NsMeJ1ZNJ5uCh+oOGBKdEb4CqBip0NX285dsxelfe91cL96qtV9jfA?=
 =?us-ascii?Q?3HIe4xSbF2ORJ3jUjYCC3EYTo1kQKDxBkwJgEmW6p0k0EVDTKmw7AxEZQ5fS?=
 =?us-ascii?Q?oiLU1K+qjTwkUIaye1+HrOKaOf20dOx+F37tzXvTB8/5ARC65tks8I4kiR/5?=
 =?us-ascii?Q?rZenmNtcweA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ItIvZdAWSYXMxowzTwr2iwfoUnTmgZcTAg3k30W5Xci2P8uTaoL95AILik0I?=
 =?us-ascii?Q?GA7yAuJSYzzi7SitLnyUspAjArwK4xiGvqfxbfnuI1GsDZco6D9BeGUVZLpt?=
 =?us-ascii?Q?lMD0dLea3bQKbA3QVHbZ1Gw9luDSU/xzEMvhaK73tiOVIDKBHg/TT3QiA5qt?=
 =?us-ascii?Q?MPtnIyEEZ6evZ1d3QpVzlNoicHBBK+eNShtup5AEeYweUoVVQDGQvVoRN4Yq?=
 =?us-ascii?Q?+HuN8Y8xrTH2w1Ya71fv6BCFiL6XPUaCiwB2gWd8SlBrctr54zDgfFy2cbtA?=
 =?us-ascii?Q?SjFywKVjGoLl3vdgUWpgcAS3nhwPG1YZM5CUsYBDXMM4pj/b0mNusWWMUkXe?=
 =?us-ascii?Q?3B9L8h91HYVkJMywQJP700+VsG3zVx9x4DQtS5Sxi+FQp/r2GMr/F1xdTgka?=
 =?us-ascii?Q?2lgsnDPr3RLtltor1jcGRUDQCAf/mAmo7laZvsC5SpjTlXpRdTAeAnoulc5F?=
 =?us-ascii?Q?CGtOzv4985IBt+7+pvFa/FCmBtbWrbk/Fx0rlHWyHjPPmf+fL1oxmykHsYG7?=
 =?us-ascii?Q?cL1gA+7U+DXgIfXGf4N3/WVgEgvmsMX6qgXai6FHFOH9+sK4sQYjJZmcYt5i?=
 =?us-ascii?Q?RHj0QWp0SfoRdH35T9WtFv5/gES02/4WRv7U30ft76sx0r1q/wcbJp+GuTS3?=
 =?us-ascii?Q?9Vh5nYE1BhM5Ave5b1SnPGgReW23EAnVocCrixGYFgycxf9/hSdayb4vra9k?=
 =?us-ascii?Q?ZoTH03jF/rC7era2C5/ToTwSAZehwYDFpdLYI2CIvcC++FW0ZKCOAyfqtyXj?=
 =?us-ascii?Q?CRLxxcMWX9fy2m+zQuWj3t8bTzwT9a47oapeiE3AUQnMz7qg3miFmloH94T8?=
 =?us-ascii?Q?hWv7P32Uc6RCPeezZ6tFwYd23UOEw+/rm4axG099qqgIQoVjuWZflgB+e4Go?=
 =?us-ascii?Q?o4HZVMrZr38jowP4bL9h0DSibQbtdHtgvwXR0o4z5vVBfaAaK2Lhf5tNahdM?=
 =?us-ascii?Q?wmqzqmtkm1wf6Y2G+jL+4OdiJh4FgMGDgk3HkcGQtGVMNIojxIMgov+ktP7J?=
 =?us-ascii?Q?8ZUWiK9BKiVk/GDeddJhbKEuPvxbKbVeuRoRPQF8FYWrPOXNANJEmX5om43D?=
 =?us-ascii?Q?MaaSlW+Vu19WWKqy/F935EDzMPsl1H1he2JJ7avIIEkJLCnRx3rd9hE15lEU?=
 =?us-ascii?Q?TdiE+8/EjsBZl+v+48PSSl1mw7f45LhkAKVTO5hpelNmJiG3prg4O+kizphv?=
 =?us-ascii?Q?LCkFM5ij9ikiEEWFahkT+SnA+CEDxMVGBNW09DL8tuVAmhmNZdCDUH5uCaG1?=
 =?us-ascii?Q?RcVAqinl0/uaoYccN4RCKu7I4hCYuXOSOvqDI0X86HKlGEgaERjyI2Zyx7TO?=
 =?us-ascii?Q?Ur/O24CAZc8WE7VM0xyjn+D7Qxv1HoVRxxnVTboHro7sOrNLEtfKgzkGhF1p?=
 =?us-ascii?Q?dOKdtgyZqtulXcr3JeEBia1U90ZjwviSc2j4c0eQReOMg1YWAdYH6oq6e/VK?=
 =?us-ascii?Q?Ais9HxP0dSEIqeQRN5scxUXkW4wNv2e9niS+WuHVaoMxcbGK/ad+996Vieu3?=
 =?us-ascii?Q?/+bZO9LZrakBn0S3Pd8utZzx4pnKCMltVTwOktUR2s4/XbM+JlMpUk1j3wqg?=
 =?us-ascii?Q?wzC9LOPk1RKJSis/VzdgcvHGaak808f/9m54ru6g?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 52ed5b9e-29d1-4739-f4dd-08ddadd7a330
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2025 19:46:22.8443
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eCWNLjYcF5E49aHsbFyrZ8D9aW1pmDoEqZkVXvrDGJE6airu5nJ2n0adEz1mqLnc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6430

On Tue, Jun 17, 2025 at 03:39:19PM -0400, Peter Xu wrote:
> On Tue, Jun 17, 2025 at 12:47:35PM -0400, Peter Xu wrote:
> > On Tue, Jun 17, 2025 at 12:41:57PM -0300, Jason Gunthorpe wrote:
> > > On Tue, Jun 17, 2025 at 11:39:07AM -0400, Peter Xu wrote:
> > > >  
> > > > +#ifdef CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP
> > > >  static unsigned long vfio_device_get_unmapped_area(struct file *file,
> > > >                                                    unsigned long addr,
> > > >                                                    unsigned long len,
> > > > @@ -1370,6 +1371,7 @@ static unsigned long vfio_device_get_unmapped_area(struct file *file,
> > > >         return device->ops->get_unmapped_area(device, file, addr, len,
> > > >                                               pgoff, flags);
> > > >  }
> > > > +#endif
> > > >  
> > > >  const struct file_operations vfio_device_fops = {
> > > >         .owner          = THIS_MODULE,
> > > > @@ -1380,7 +1382,9 @@ const struct file_operations vfio_device_fops = {
> > > >         .unlocked_ioctl = vfio_device_fops_unl_ioctl,
> > > >         .compat_ioctl   = compat_ptr_ioctl,
> > > >         .mmap           = vfio_device_fops_mmap,
> > > > +#ifdef CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP
> > > >         .get_unmapped_area = vfio_device_get_unmapped_area,
> > > > +#endif
> > > >  };
> > > 
> > > IMHO this also seems like something the core code should be dealing
> > > with and not putting weird ifdefs in drivers.
> > 
> > It may depend on whether we want to still do the fallbacks to
> > mm_get_unmapped_area().  I get your point in the other email but not yet
> > get a chance to reply.  I'll try that out to see how it looks and reply
> > there.
> 
> I just noticed this is unfortunate and special; I yet don't see a way to
> avoid the fallback here.
> 
> Note that this is the vfio_device's fallback, even if the new helper
> (whatever we name it..) could do fallback internally, vfio_device still
> would need to be accessible to mm_get_unmapped_area() to make this config
> build pass.

I don't understand this remark?

get_unmapped_area is not conditional on CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP?

Some new mm_get_unmapped_area_aligned() should not be conditional on
CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP? (This is Lorenzo's and Liam's remark)

So what is VFIO doing that requires CONFIG_ARCH_SUPPORTS_HUGE_PFNMAP?

Jason

