Return-Path: <kvm+bounces-9306-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 33EB285D979
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 14:19:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 56D241C22F94
	for <lists+kvm@lfdr.de>; Wed, 21 Feb 2024 13:19:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C40F376C62;
	Wed, 21 Feb 2024 13:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="ufCfJymE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2080.outbound.protection.outlook.com [40.107.223.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1F529AB;
	Wed, 21 Feb 2024 13:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521540; cv=fail; b=cEklc5ZVSJQkRGaeC0/XlufFIBWQMgjk6VQmYuelZ5BeVwtH2WAheUuLGUZWIZDlCQlpFj17MP0ARssjxENH+nhE6DV9mA3J7zB1XslAwjXKyZQfLjvrrosHxHMPv5VSLjFg7Wxy8NaKApyN/o8ZzCAdu65sW3xvPjyoJz4HIv0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521540; c=relaxed/simple;
	bh=bBiRsKO85da/NuM4RMwnJ/K1yN3o48hmxTg14T67kPI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=AQfxYiuaG9q2363jrOKX9pVQqB7z52inUl7Hjc2m5gLIiMz8utn1jcOkUl/F9RrjL23/QQkjyXil5cfyOsyVCiIGFvbRGL97iy4ULZNp6omfx5gXYvJQNMiEv9jd3VfaHTOvLjbD6/zZTXtUu3XzC8GQKpDIO/VYJO7txZnzInE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=ufCfJymE; arc=fail smtp.client-ip=40.107.223.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UJreTss7qU8grgPg+PywsRUMK17Du+cVD/ZqGceMdxI7bYt/ZSJ5gvTnhSqjNvgLotTSf92v4yi6AOpsoYfFLdLwTKyrYJu2r41qADH57Dc0F6hs9rtH4H9Xr20l8lakl9GfIrapAsm1GP8LhyHpgR9rXQawiTXO0RSQq5e0S8MzK9wpArk7c0jUy/yWCMlOz1euM1aVnmFG+q43s8JfW2gtTOkNQ8VDuRlxwd+cvfSlI3z9nPitScNwThfhI3M80BNWucHI0shGWfqSNgsASdaz60gslQqYNgpMdZewuY0W/qbOHTv65mx4V2dugUAwwEebPOJh+9F4sAh78pDY0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=knpEEyw0EumGTEzz7piewQ15dIp37AwJb5fuMYmcka0=;
 b=iFQtPiPN8AtgOGu0Ip1dMpJ05nTOXggQFPvH51bYgedRF4kx2T5OPcqFShGsTKJMzrkXQgk9mTJW6HY5Nx3modE+af5FSf6MF8IhPn9k38NGkkJwRcWGeLjssBmznlLp58AE1vZBeUmELpbUCthJJ+PIz1XQxyTt2pJVn9qqvHPBbgWeYA3Yj0G7tU3S3DpBF7t2NMstxKwRzccTlCnRslfQTVf2BBruieq/x0BI9u77VZoRfyKeKpK5CAQ9340hb9h9jVD/cl5Thx3F1tLtCFHuKpyZBcLm74M2mgqzM70Pn2ndYk7eNBTAhvTbRImkYUE27bHUwt2wluxVuqZq8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=knpEEyw0EumGTEzz7piewQ15dIp37AwJb5fuMYmcka0=;
 b=ufCfJymE7ul0Wsb9+QtvdjKBCWZEbR7utrbIMDaGhvPWt1QprBBUtKd41yXSQNToWe+h1YZHo1dQxCE1XVCPuw0+MrHFaaLkBCGLrtOEtmqSGfu16z2pqd3rLOVTmURDAzH6n14yRuUMB6jUs9iqlFuPGWi3D82iAGOTzCzrWmE4cJIZ7eS+7HKetQNg/Ip/y7SEwsA54FJW9NSOUy1HoOqsxcSom0sP/tgvT0OTg1F+eUY5o6mu0/5r8CrMZMB5+FS5QM3GVldwvf//B4GfFEco4w4aCCmMgWEidGW0iUQN1clLcBqeEosiyTh1i2FsZIGQaotWcpwiO7YHa0UcPA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by LV8PR12MB9205.namprd12.prod.outlook.com (2603:10b6:408:191::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.22; Wed, 21 Feb
 2024 13:18:56 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7316.023; Wed, 21 Feb 2024
 13:18:56 +0000
Date: Wed, 21 Feb 2024 09:18:56 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Zeng, Xin" <xin.zeng@intel.com>
Cc: Yishai Hadas <yishaih@nvidia.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"shameerali.kolothum.thodi@huawei.com" <shameerali.kolothum.thodi@huawei.com>,
	"Tian, Kevin" <kevin.tian@intel.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	qat-linux <qat-linux@intel.com>, "Cao, Yahui" <yahui.cao@intel.com>
Subject: Re: [PATCH 10/10] vfio/qat: Add vfio_pci driver for Intel QAT VF
 devices
Message-ID: <20240221131856.GS13330@nvidia.com>
References: <20240201153337.4033490-11-xin.zeng@intel.com>
 <20240206125500.GC10476@nvidia.com>
 <DM4PR11MB550222F7A5454DF9DBEE7FEC884B2@DM4PR11MB5502.namprd11.prod.outlook.com>
 <20240209121045.GP10476@nvidia.com>
 <e740d9ec-6783-4777-b984-98262566974c@nvidia.com>
 <DM4PR11MB550274B713F6AE416CDF7FDB88532@DM4PR11MB5502.namprd11.prod.outlook.com>
 <20240220132459.GM13330@nvidia.com>
 <DM4PR11MB5502BE3CC8BD098584F31E8D88502@DM4PR11MB5502.namprd11.prod.outlook.com>
 <20240220170315.GO13330@nvidia.com>
 <DM4PR11MB550223E2A68FA6A95970873888572@DM4PR11MB5502.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM4PR11MB550223E2A68FA6A95970873888572@DM4PR11MB5502.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR19CA0017.namprd19.prod.outlook.com
 (2603:10b6:208:178::30) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|LV8PR12MB9205:EE_
X-MS-Office365-Filtering-Correlation-Id: 701bf1aa-9b09-44e0-2d7c-08dc32dfa897
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	MO/+tQA80hfIDz1rTBJeHxqnCh+UlvbXeohQvptXWKQwU7VhraqeOK8B/XBDZDKNhdDBftYwwF5tlZrIdH1DbVjFRk+sZ9qVTeel6SoWd6WBW2ieM5JmW4rJV84kfNhwTtynfDqfrxpDFRgRk3pn0cO9iewetG5n1J4qleTds28sd+Z1clVZIeCO9DWnN/yqLJXp/WhNlfMEi0rrzj6Xaio8aD+2vC5Bv5H+hVKizHKodwA4MrvXV6+aYANtMC/svx5hQWQsi56+cA+EDrKGuNmcigsCMIYu4zn0Lw7O80tWFKPhsa9kKQkrF/L3w1zS94xaM/Rf8fin6fPGw3Aq75Sw0X+xVPxJ4Jq0H8eRdQ1swAtxpjdBRJBLXY3N87qjOo5nNEO6TTMU3ugLlBusg91cwHbe5r/qj8Bwe+Xe9BYyA/7kNGsolPl36Wrg4X7ZMfpMfjbU522QXXgNuEszU3R/+PmdIr3Ho+NO2lavUUdjlztuCVDQ1VfEwvixSKeFa9+2H8KOuCU0vkQLDEOVCfUy4O5N53llQplk49gByTY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JLBGBC1fG8jU9BeaX0vuWxgwyaGCw4/C14JfTPog29AQOiVnP/VyeoSSCLEa?=
 =?us-ascii?Q?xBXZ2Q+pyxtSRG6AMSKKpWUVwZ0tvih2qoHncu0Ps+Y9WycGAz6HG2xbm/JI?=
 =?us-ascii?Q?hhJcmbIKmduJvm1KBl4LloBackftJDvrMGXX1T8QxhZIgGymAyh9IHl2DDOd?=
 =?us-ascii?Q?CB9DCqNUPAw9uRtjwSgmb9Ta7C0BXV+CEoAQY4FkiR+pzm+dI1/V4BmZQ8N0?=
 =?us-ascii?Q?zSghKhLjCplCV0NeeD/Pp0RbbbXlSLclJEatTxpkycnOOFLwB9Iyzuli8xwS?=
 =?us-ascii?Q?hNp0kKTPqVcdIJDzAFce2HECIKrw/Z0LNvmoZd5V4BliE4b7m7LQLHRWHXk9?=
 =?us-ascii?Q?qyrvVrO/AY7/0hO/SXr9ggb/6dW9GaogktEA46uc4RVeMmEc+oZxDNOh2Ogk?=
 =?us-ascii?Q?2wCDLfdjHNJQozCc/g08YUzbLXsvZwJ6/hnEWJmewwoit47++9C2x/v5425B?=
 =?us-ascii?Q?hHj0Ie3HMCGgEJ/+sG4SVPuHZXKbYwhrMX9xzxuN4RZmMjinySJ3GnHY7YhO?=
 =?us-ascii?Q?3MpNgy8JtJT7OZz/IGPoqLwqGzYR4J4k5OiOaK7i7upaROJQdEwlWlizMo5C?=
 =?us-ascii?Q?XXwQdNAV8dGNJ+yTXf57zfOHigNEHLAdHxGg24DJ5T/UcPif2CsYNK3ltnYT?=
 =?us-ascii?Q?jOCfF+XOwRCK+tN87ZkCYmLNuTGT5RTJLRaiD3YW73WXQmFoGOL26Adaxn9D?=
 =?us-ascii?Q?TkRTIQLROmZQiDgAUCDJUgd7INoAYTH66n4AowZtgCSvd3BVT8W9XSpGXCuL?=
 =?us-ascii?Q?Aq+rNseEuFQX6H5xciXooQUQUXMxksnitvhr9VJ4rZpw7fSRbvdkDlTIcLd3?=
 =?us-ascii?Q?sYZ+CBmWSBCcCJnsDCjip8P0DAz50WwSYRWR293E1pIvwM5M+1I3nHcgLopK?=
 =?us-ascii?Q?4ErsMnMddK3txTsZsXGlEvRkx+agHZQzmS1JvY1IXwUanU5s3UXqQS/C0IjK?=
 =?us-ascii?Q?5mEkGa/tLnOwpDXV8ZdpKVjm9/zgZgs2feaEKGycZjlwbw15fAAcbDzeKN3F?=
 =?us-ascii?Q?gXUNsFFaiKXqAQgqjxciCydTf0+zLk2V7TNKNs4sdLk+QOFhnciqJM7Z3D9+?=
 =?us-ascii?Q?srmeDhpFecEp4txWYuxU3cSi8zflYeVrLXoAwTNlWUx6cJA8WIGDgjpTF/MP?=
 =?us-ascii?Q?/jdSB2WXpX5byssNUgGatQQQ1vzYx9eLTIMKIHvXxEjc2qFKGdbdfjMBiYrh?=
 =?us-ascii?Q?pGA5o38RpCkSXJPdQHkr/Nk32ZDTykGRlQCnvSYj0S4axVWK6OBUVtOFhaz9?=
 =?us-ascii?Q?6LyJl6He67pJa26eynSK+HE4fA1pG/i/pUYAawy2vMiyJkJRFOIL+QvMOfHv?=
 =?us-ascii?Q?prNveib3rKvKDB8N8AC9Exy0BxTPQ0Xcr/cEKCs98pqjzbhs13mS4Au1RjEC?=
 =?us-ascii?Q?s30fxSdxhnzaYyCAf+xv/aOW4FU2utbKOGWy0r+BcWSfcfHtgXb2tyDSH5Zi?=
 =?us-ascii?Q?L8cJVsncC0Yy5mSVvS/i+9B5bvj3I6bH2LCwfTKUtrFqfmwQp1/YkLzBouNo?=
 =?us-ascii?Q?uT/amoT2p5O+TDvq3seQ8QOqodCw7UNY3ZrhssWJ8iA9GzPmWrNfG/6SLUFC?=
 =?us-ascii?Q?bmnJacwWi+Oxjl6vMdRF3lYbdZnrWUSmyiiHZaoh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 701bf1aa-9b09-44e0-2d7c-08dc32dfa897
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2024 13:18:56.8239
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7vlSFWeicXATSEchL9ey7HHxmbial3AzuUAUCklCCclIt2sLhTlPXVBAxl3rcBd2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9205

On Wed, Feb 21, 2024 at 08:44:31AM +0000, Zeng, Xin wrote:
> On Wednesday, February 21, 2024 1:03 AM, Jason Gunthorpe wrote:
> > On Tue, Feb 20, 2024 at 03:53:08PM +0000, Zeng, Xin wrote:
> > > On Tuesday, February 20, 2024 9:25 PM, Jason Gunthorpe wrote:
> > > > To: Zeng, Xin <xin.zeng@intel.com>
> > > > Cc: Yishai Hadas <yishaih@nvidia.com>; herbert@gondor.apana.org.au;
> > > > alex.williamson@redhat.com; shameerali.kolothum.thodi@huawei.com;
> > Tian,
> > > > Kevin <kevin.tian@intel.com>; linux-crypto@vger.kernel.org;
> > > > kvm@vger.kernel.org; qat-linux <qat-linux@intel.com>; Cao, Yahui
> > > > <yahui.cao@intel.com>
> > > > Subject: Re: [PATCH 10/10] vfio/qat: Add vfio_pci driver for Intel QAT VF
> > devices
> > > >
> > > > On Sat, Feb 17, 2024 at 04:20:20PM +0000, Zeng, Xin wrote:
> > > >
> > > > > Thanks for this information, but this flow is not clear to me why it
> > > > > cause deadlock. From this flow, CPU0 is not waiting for any resource
> > > > > held by CPU1, so after CPU0 releases mmap_lock, CPU1 can continue
> > > > > to run. Am I missing something?
> > > >
> > > > At some point it was calling copy_to_user() under the state
> > > > mutex. These days it doesn't.
> > > >
> > > > copy_to_user() would nest the mm_lock under the state mutex which is
> > a
> > > > locking inversion.
> > > >
> > > > So I wonder if we still have this problem now that the copy_to_user()
> > > > is not under the mutex?
> > >
> > > In protocol v2, we still have the scenario in precopy_ioctl where
> > copy_to_user is
> > > called under state_mutex.
> > 
> > Why? Does mlx5 do that? It looked Ok to me:
> > 
> >         mlx5vf_state_mutex_unlock(mvdev);
> >         if (copy_to_user((void __user *)arg, &info, minsz))
> >                 return -EFAULT;
> 
> Indeed, thanks, Jason. BTW, is there any reason why was "deferred_reset" mode
> still implemented in mlx5 driver given this deadlock condition has been avoided
> with migration protocol v2 implementation.

I do not remember. Yishai? 

Jason

