Return-Path: <kvm+bounces-56830-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B0ACFB43DE6
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 15:59:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D23DE1C21A39
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 13:59:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A899D3064A2;
	Thu,  4 Sep 2025 13:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="KhjG8Hfu"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2043.outbound.protection.outlook.com [40.107.236.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2273A307488
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 13:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756994322; cv=fail; b=j+eJKwXQok9hvW4WaZjXvHXenAtoUICEGUEEWdxFsg57IPsU/E/6rTqyQGpa7BHXIr1I9Rr/9sHfIaEX8tISf4WSvhga8n5S8lW54dIaV53loKNnMEueUcD/O9kI+GL7yQjQ/ev8UbxB1ms7nWcOx4yFaObUvdMsZ9r6CBzdcIU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756994322; c=relaxed/simple;
	bh=ABgg5C6iKlkZfvRUXUJmqmuzpgBIeMGf8iSgMxUAhkA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=NbIAsbYK62k5UROVTLmB+wyBQ9nKasK+qIaKpDVv1TeCiOY8gd0xwY9Wp5d97LVWT3ymrs1GUliKw3gX5gvRz1zvkBOvxtxM8ZoZXZ9wM8Yf0Gw88RJa/+wXygHOzeHMq3yrZFt44VOmJRV3bo5F1wWMIOXTCoVWsEyyYSfTHqY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=KhjG8Hfu; arc=fail smtp.client-ip=40.107.236.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MP+joPmCx4UTG1usGCDRPBZwDV2zazRH6zErrldkvZeaVrtiDLAe2DZ+VSKVRLPNOMD8gGfQAAMrA0x/qWm35O/jgnWymm1ZLYz3CGLL9X818/zgkJWW1qN6ufydko1Jn/BtwAyYKkMAgB+lJKCqK+rWgVqaQCq+pF0gvS8AU00n43u62zhJSmvgz1ztoIJAd4jqWAM7YmazrKgfJM12vh+qnogd3KE3bUAxZg7tl4Zw+fgqke9qXYMNiqorJCFdAnKSkfYFE9VbME/ijoRpOaru1yiSptc45S6N1OLlHV3WcV+S3hqHrobM2Ne+Hr0R+olgRhBzyFdV9J6jfD8nhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kkA/yVb7PNNM1TUS7cQq5WE/ZNAgDlrUpMknEk7JL/Y=;
 b=cLJI8ZIErRC5h2HhJ5bWVQp8VFiGils8kaYxF07/cYWW5tGSgtH7h+arAUIgOiVW3aKqzHiBLZ6+VRnvp9J4YLxReoUusAG0ludA9wfrg/eG1K9I2yrB9RmcKSB1uc736Rmk332fTQiuTsByFcxMZUXDFA5NJJ6Uut1lBdKMu1n4BYUjJDlCm5l9Kd7u9UEu2TdXDfIG8+vPkzeh+RKR1VbJMk3A88z6cmdiXxhYjmatNrGxDaL0JtvIwdQKCQmUzBwxfEtHa1ge7nBLGQ1ER3wPg5rjL9uLCV4vHm+n2NxbZiWmoVijGcSLB2KY4g5AL/yf5QD+8ym38yi1KVuvTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kkA/yVb7PNNM1TUS7cQq5WE/ZNAgDlrUpMknEk7JL/Y=;
 b=KhjG8HfuAN379Yn/g7Vrua+0ES17xDcaQZLVyntvQUJTx2Z7pedVoWaDsgbaVAwcAtP75ex7zgp9ZdRvLrVkCBa2yY/E6DXQVIhluOI0X6lW408NaZ+Fq9ZrjL/VnYkIGYKvytt+FKxuFRsdD1sM56ePGVL8g0QzAjd1EMBB1vSS8tHBXJ6hnb7j+pItCoXLTOS9JQtL4nQotUn56eIWYQFWBkXtEIoXd/q4NOMVBmdhDq+x5sB1QRmP7z3M+fv5Oh1++T3znV7Gu4N6BXJeOauSFc8d2h4OdH22KezROyaD9FZI0hQ25deDi+fZgZAQQj1qolso/N+hDLkQalBBpQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by BL3PR12MB6428.namprd12.prod.outlook.com (2603:10b6:208:3b7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Thu, 4 Sep
 2025 13:58:37 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9094.017; Thu, 4 Sep 2025
 13:58:36 +0000
Date: Thu, 4 Sep 2025 10:58:34 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Danilo Krummrich <dakr@kernel.org>
Cc: Zhi Wang <zhiw@nvidia.com>, kvm@vger.kernel.org,
	alex.williamson@redhat.com, kevin.tian@intel.com, airlied@gmail.com,
	daniel@ffwll.ch, acurrid@nvidia.com, cjia@nvidia.com,
	smitra@nvidia.com, ankita@nvidia.com, aniketa@nvidia.com,
	kwankhede@nvidia.com, targupta@nvidia.com, zhiwang@kernel.org,
	acourbot@nvidia.com, joelagnelf@nvidia.com, apopple@nvidia.com,
	jhubbard@nvidia.com, nouveau@lists.freedesktop.org
Subject: Re: [RFC v2 03/14] vfio/nvidia-vgpu: introduce vGPU type uploading
Message-ID: <20250904135834.GN470103@nvidia.com>
References: <20250903221111.3866249-1-zhiw@nvidia.com>
 <20250903221111.3866249-4-zhiw@nvidia.com>
 <DCJWXVLI2GWB.3UBHWIZCZXKD2@kernel.org>
 <DCJX0ZBB1ATN.1WPXONLVV8RYD@kernel.org>
 <20250904121544.GL470103@nvidia.com>
 <DCK0Y92W1QSY.1O2U2K3GV61QW@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DCK0Y92W1QSY.1O2U2K3GV61QW@kernel.org>
X-ClientProxiedBy: YT4PR01CA0291.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10e::15) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|BL3PR12MB6428:EE_
X-MS-Office365-Filtering-Correlation-Id: dd83fb08-04a3-4f1a-7d24-08ddebbb244d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2c9u47W7kLL9vlyq6NCsZ3IMFzwxQY332/BxrQnmA+kCI3FDPuQK4uQCKxxp?=
 =?us-ascii?Q?47mv97k6pGby+FHqWJkp7RUneMjxR7Vj3/EsbfjZs6yNk3J9UgVtn286BUzP?=
 =?us-ascii?Q?WZtXVSX+5I22wQDTa6qud8gmkrgDHyfTgwSqMZGQCiPscbF3IQMs3L1G5Gi1?=
 =?us-ascii?Q?X/hBfw2sEOoUg+0/NTlQL2zWs5QjnHqTaPkSDWMa1lRSspff/xIupbt0HxkS?=
 =?us-ascii?Q?xfaAJ+lcRnyQjecZY/CE2+x26phPsJYWzjIMSkYiLRI/Nn5szSU0TIY8uYAH?=
 =?us-ascii?Q?yJo/M33aFzvXofMyyyHECt5vAllkFY3ng8DvAcjpBHsAxJ0/R+xa+/ci1liO?=
 =?us-ascii?Q?v243LiqrZtZ80oIrNPV525b2M/GiS+HwYw7uUXqb3pJFesBTI0hylxNg4SU5?=
 =?us-ascii?Q?Fpr4OjRwPYrZ3wRL7geUXCKa/J8Ga7B6GXkEp4aaWJVOzm9KI7dh00dB4B1X?=
 =?us-ascii?Q?B+/hbQJhHxgrD4hFPmohLIKB8lkhQzzJqs8e/DR4Mn6tVjzBKLNVhYzd3Ut9?=
 =?us-ascii?Q?lzaWkRZOqSFuNH2YbFt8gVwCuDOh0D8wRl9n2jXhLvGavhU+EYfe+zEXKtOP?=
 =?us-ascii?Q?MjqCLoy7sJIXyEwD3sC2jouBXvPgz4qaid3fViF88lEkBxcocrGiWTrhM9wB?=
 =?us-ascii?Q?8S85J9M0bCAA2D9nex8aVK47PZsDrmLmUnOXVpIQ2G/f7XiK7V8wnaCrNWgE?=
 =?us-ascii?Q?WR7nqD8O3ZPTXU6z2vYMpUcMOOeWned7RaLsDVS/PzimESFAU9cJP9R5w8k/?=
 =?us-ascii?Q?YjXaSxorY2gIB/q+uZpBJzDG8Vqu6MlBvMLljVzC1yLa8c/ecz/hNyOmHVa+?=
 =?us-ascii?Q?vtgXRvJpHYVwt+Z7Gp3FsvFchA9Efhm189a7oNvi/QfTQu8w6VR6S47L8RKm?=
 =?us-ascii?Q?f6HtWMH85PFhzGsGmJ5uULGDAzntVunFT/5lBzbp28nvPEFT2moGi+i/fZVf?=
 =?us-ascii?Q?bwE/K1B6ZJo+cxhohi7zt8qlpGWVmrFXy6isdXIFTIHS6sNwltqiYhPohIqO?=
 =?us-ascii?Q?TI025RRU7t8QTKS57opuppBe74QdcTR0EKA5JFF78Pbu+35ZoVGo7FpVSBQK?=
 =?us-ascii?Q?b/lSzBx43Ub/TifekTEVMOOz8RIJFNEXjIaTpGFCESVA3I1m3YFuA9SE/bul?=
 =?us-ascii?Q?nKiPttApBNQSI9uYkS0MGj8kDM3iWPlsfHGAZ+KC/G67oXR2kScVXH5AgCx1?=
 =?us-ascii?Q?R0r5Rzr55m8N2itlU08d/9dwZn0yafawsD/kCMIOqQ2LSEeQx36BgGVjbwBc?=
 =?us-ascii?Q?j4haC157flYDBPg8VoRLSYSLD/iZgMpXUst0P+J1H/KK9Pww+qsu0pgA8gub?=
 =?us-ascii?Q?0K263nxn7mFg37My7Yz4m0Yjx1yqDig3wAsDJse0r9/hrxzNR9wSr+LW6hSY?=
 =?us-ascii?Q?LgT8Ou5C6zc5NJpBKH+3zWJ4V0Y2/wW4voruaGw5U/q+D/Nn3y9nTOrib17m?=
 =?us-ascii?Q?MkL2L+ncIS8=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gVHMQGzWv4YXviT3N0r1FB5rZcsdLkzddshsg1hroFNKbDWZ1fZO47i0647R?=
 =?us-ascii?Q?wUXhsm5eEsvLz+kK04SRMU7sqaI1x+uLrlnTHPSCAc4Xox3K9UeS56QK9ozQ?=
 =?us-ascii?Q?kF6/NSIK8Vq0Av3+wwhvNGZWXguEUHF2aHwPf9ipiTuMsO4EuRPrG02My31O?=
 =?us-ascii?Q?p6i3kMJBO7kp1aD87NqnbMh6Z+k319h5IQr4clrW1hUi+2Vmz/SCNh2G1BdG?=
 =?us-ascii?Q?3KfTGJQ1I2WWdyoLCUjuMTNEoTYPUCiVtKZDsQPmKTCXxyIuP5TIKKAFrsOl?=
 =?us-ascii?Q?Fj61zKpw6JJnAK6ETRAD2a4z+1Wf6zAn1RSN7bWIRj2V1EGcPWdGixrmj7f0?=
 =?us-ascii?Q?9+CsDBqD3aIm1Q0Xh1B+/aJgSHc5CJm2Wxly6UIu5t8oY5pi6JHMvp/Zqxvb?=
 =?us-ascii?Q?SN9YQjscmJRfmJyesWVlBkfFvaLcGHKboVz/ZpxobX8QfASKQvWZnxDorNtx?=
 =?us-ascii?Q?r4vI6KCWxwm+gg1uZJMvRVcU3/3Sdf3Z/6C3EX0SHX1VIMkqgzGyZv1EGuTV?=
 =?us-ascii?Q?XffRfv2uGVi86+FGjO06t9aqLTwB6rqAW8czmwpVlWImGON2fFjt5tGdd1V3?=
 =?us-ascii?Q?ifKGPdxD55iFX1Ie3niPd9OG0DVJ9ndxLvJf9vh5jacf5vdSSPRqoBiUlS5Y?=
 =?us-ascii?Q?wSsy+PmcWqPFN+UoBhM6VilBgwbLMCkZqRbuW5u9QuVY+gKlgcGCLeYqDMPp?=
 =?us-ascii?Q?PXXflitYwpIPyKWlAeArqGTRyBGUsqpLaIXra4cLTvEqSWulIPOgKxi55WSK?=
 =?us-ascii?Q?XPKc+gb81M8j6qaKxsV+rvV7yrZytTwv1xvbG5Qq3qK2g4H7Se12TmvPfjBP?=
 =?us-ascii?Q?cZaMxV+2o4kUyhjVpD9ZF0snLWR1GfJXupXACoOUhWe9mCl6TyWMgtnx29hc?=
 =?us-ascii?Q?jeOA8/XfOIOrqCzW2x/xkX5PCCaFMhYiM8fpVxvWPTg7PV4cY6HwSPlC0rm9?=
 =?us-ascii?Q?EbndaHD5cPhk/kElfCHgkFrWGdO1FeZvZ421bb5gZFoftpX1TIXoJm0MoV8g?=
 =?us-ascii?Q?qf4V1Hcj3H3ywtioqWaE0qyzSEME4Uy6DzKQpmLB3QpoBxna0SQV+sJWmA58?=
 =?us-ascii?Q?01f416g1Jz+icnCKMwMj1YUU4kjM4VE6MyYfuDvXoWTNJ99fEXkdqxScuoNM?=
 =?us-ascii?Q?rFEWz+HtaeH66dB1ek2lYPrhm1MOaYUMP9qxmn8WYXmGxydzJALs5aeR+hun?=
 =?us-ascii?Q?liMUVB/DXoC4E3mrSdt3TRzQO0OQeP3VizxY332Kh17athZpb7wiNgUnGw3W?=
 =?us-ascii?Q?WsB3Rh3HvQ25FSZBgjwzJMRQum1/5mjpwH5j0bS0+nurwnRpO3ZdXzbKk0/F?=
 =?us-ascii?Q?7f43kOqEHCd2eJmZWdoH3MGLN7ViE2/idQihNHik59DUiZVLaTRMR29I7mMT?=
 =?us-ascii?Q?4gTreMdpudk/6pWyyBhlbjuQICiZ4GNCU+n2dTP8SBkUk0+1cZaSY165CZJI?=
 =?us-ascii?Q?47AQIXNgTp6BvYMaqymxMGQYry1aFjYcAxbuyfCHrJKSZTHGbiQreUMUl8iK?=
 =?us-ascii?Q?8UNHqdUlfkuza44eZQxFWTzGmfx7c81ARhoWoFkl553go6LqmAcPevXcUCN0?=
 =?us-ascii?Q?6m2F1YLRl1grKm/tZT4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd83fb08-04a3-4f1a-7d24-08ddebbb244d
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 13:58:35.9220
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GNl1bsEbLthEpAVuDgDMNVyrojpV12GdsiLhcRa536M2XLq3bgmnH+ogyzuBn220
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6428

On Thu, Sep 04, 2025 at 02:45:34PM +0200, Danilo Krummrich wrote:
> On Thu Sep 4, 2025 at 2:15 PM CEST, Jason Gunthorpe wrote:
> > On Thu, Sep 04, 2025 at 11:41:03AM +0200, Danilo Krummrich wrote:
> >
> >> > Another note: I don't see any use of the auxiliary bus in vGPU, any clients
> >> > should attach via the auxiliary bus API, it provides proper matching where
> >> > there's more than on compatible GPU in the system. nova-core already registers
> >> > an auxiliary device for each bound PCI device.
> >
> > The driver here attaches to the SRIOV VF pci_device, it should obtain the
> > nova-core handle of the PF device through pci_iov_get_pf_drvdata().
> >
> > This is the expected design of VFIO drivers because the driver core
> > does not support a single driver binding to two devices (aux and VF)
> > today.
> 
> Yeah, that's for the VF PCI devices, but I thought vGPU will also have some kind
> of "control instance" for each physical device through which it can control the
> creation of VFs?

I recall there is something on the PF that is independent of the VFs,
but it is hard to stick that in an aux device, it will make the the
lifetime model very difficult since aux devices can become unbound at
any time while the vf is using it. It is alot easier to be part of
the PF driver somehow..

Then userspace activities like provisioning VFs I hope we will see
that done through fwctl as the networking drivers are doing. I see
this series is using request_firmware() to get VF profiles and some
sysfs, which seems inconsisent with any other VF provisioning scheme
in the kernel.

Jason

