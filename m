Return-Path: <kvm+bounces-9219-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D042085C1F0
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 18:03:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EE4C31C23F73
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 17:03:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 815D476900;
	Tue, 20 Feb 2024 17:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="alxgrhxt"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2066.outbound.protection.outlook.com [40.107.237.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2EB1C2E;
	Tue, 20 Feb 2024 17:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708448604; cv=fail; b=Bj6XESxPtWU+CqzekzR2r4F345hwUy62109vjDLZ9oGOuqpmRjttkGCmAmpgqwyBcynxOo6/Dz0rwirM8WRJDscSMWN+58rxqRcQzIkycJ3j7TWkjjj0M/4+NJ6lIjF5+pAWFneeC+zpNwJ2JW70+IFICP8s+DaZU47gxDgnyUc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708448604; c=relaxed/simple;
	bh=Du2OpseH9TohpB59gHs9Cw88wMIbqTvcchUGBfP2o8A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ll2SRKlqlK82k5m+sEc/gl6kkAJuEsGMn1lpyxmntYB4dLxPumPjsRHzWQchm1v05ZHno4yYCKNoI1YOQKICJekiMOZwjbH7UvZYrEWC/cQxE4pSq2cdtFl34WWIFB+odn1tLDG0Irr0EOUT5zLiD7p4c2AFKBhrxsuocfWEfrk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=alxgrhxt; arc=fail smtp.client-ip=40.107.237.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i85g1vbccH7Q6N4kcKmKEIceycwRHhfMlFnvzJR6mUyE/y4sM96R4hxhP0qILcdfqMfkU+Trxt9Kd97EViX5I4Q8fz0ns6YMGO4wz0SRO9/52puMbNwWE8zgPBs0ebuDyRhkEE7+289XSMm+Wdw1D1NmootlhklzrtDd9e1IsiRO3qHLivlpSgX95WXvEJ2JSvN8RSwuPFX9U/LM8QlDjKIkb25Wx4LboYzC1h/kWJTanEM4LSQ/j5eGWoTr2qYjoKMwVhjXWoPUCzJ1nnmyNme1YpjeqRk32639dk3E5NUqW0dHzGhH0NlyFQ3Hfx3zuhK0OIQ/Pv6ts2sYdV7jWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tievG4WqY2pyjvXPR3B62dm1kXkivcnYmmXA7vwYLdI=;
 b=oO0c4kpf2k2AAw6qqBSuQP2ISAzc622ATYZ63aViuzoz5f/ER7aqH+/1PawslWA2pIniv86VNWWwUqPojUbWyU5wKjqsWCn8IhzB/AN78Wy8Qv3tPhpwqETF9DBj7FHuKZtxGiMjnUd1qO9z8gh4/IiSunf3Os4xXnp5rCFsd0KxfhjyidXRzg6m+g3Npq2vEIr6SEosTAWx/ka3tyxKSoRnmSVKDQZWfjygD9qYWCyVoa/Ewn+gLGhN4jFeduUPYTZyMZIUyeHGiQfQSxfph9BU8Oh7EGQMWSytJKBXMEBNxL/88UFdLowPfGCR0kMlzoUJVyunZQU/vs2cuvfbJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tievG4WqY2pyjvXPR3B62dm1kXkivcnYmmXA7vwYLdI=;
 b=alxgrhxt2NrsYwk+wh5FdBD7IysX4oqaz7i5veM17D4bjAjSCyLEB0S2StgJbBC/Pas1Y1bL9oHapo8K/ZxIcRqnuHZv7oChiMgRNsm2Cg7jDedcIRX9Yl83OueaifCZ11SlWSmFH7HNUYYzH20/anHYDLCTgI9aWFwkQNqibt5GEMkycus8o4jht4Ve11cRnURwNtLqhxNkFykcoPLXpcekZiUm9WcTnJwoibPon6TjiVCCVhW/rg88JG6m59nRefiuHKchbgBxqehCuVFFjA59swuoMwP1yYIZA9yfUiTFYfbLBbVs/22ZnhNXucIuqhcelUF2YH+fjqHwbH9tRQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB8521.namprd12.prod.outlook.com (2603:10b6:8:17e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.19; Tue, 20 Feb
 2024 17:03:16 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7316.018; Tue, 20 Feb 2024
 17:03:16 +0000
Date: Tue, 20 Feb 2024 13:03:15 -0400
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
Message-ID: <20240220170315.GO13330@nvidia.com>
References: <20240201153337.4033490-1-xin.zeng@intel.com>
 <20240201153337.4033490-11-xin.zeng@intel.com>
 <20240206125500.GC10476@nvidia.com>
 <DM4PR11MB550222F7A5454DF9DBEE7FEC884B2@DM4PR11MB5502.namprd11.prod.outlook.com>
 <20240209121045.GP10476@nvidia.com>
 <e740d9ec-6783-4777-b984-98262566974c@nvidia.com>
 <DM4PR11MB550274B713F6AE416CDF7FDB88532@DM4PR11MB5502.namprd11.prod.outlook.com>
 <20240220132459.GM13330@nvidia.com>
 <DM4PR11MB5502BE3CC8BD098584F31E8D88502@DM4PR11MB5502.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM4PR11MB5502BE3CC8BD098584F31E8D88502@DM4PR11MB5502.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR18CA0020.namprd18.prod.outlook.com
 (2603:10b6:208:23c::25) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB8521:EE_
X-MS-Office365-Filtering-Correlation-Id: 69c4d28f-dc78-4e13-ce6b-08dc3235d4c2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	X3xwSys2v+wA7Du88sYA0n1M0hf55vb4nGFEPeEPl9HUyA2gHGc/Q4cd7k6m6TOSD0Vrs96DthFXv2fyRf4ViwiK4auF4WfxmWeFrsVUhq4wdAG8v1J3ed2mrKMXzX7Hnde4AgP9dMzTwUEy3K3mRTSXXVfu3xlTlkL9IdBJIbvFl/F4XpBnz/xyGO59/RBDW21GwlRE1ukAzDVdSa9//MXnbDQ82okD54xo5NODYK94m8U1bnZegm4AtREoKkE6Jzq0n6Bzsq3fVLBW2ZD/r1k2hqD031IzV2D6CJVGTGBBmDrY4zAqwR2GztXDvaF/jaCj56Rbu/dkRFer8m3w8UjpWasFwaiQSo7Mz/UIeoYjp4axCEXc9PxW2EO+sH+iotIs4pHo3MKhapC2Yl4BWwa4bgtbwn+CnWjc1LTelTPJaCaWgU0MD7/OgYRNFGGvxa3QXq7KpMeuxvKZCIkUnjFu6PXV1u9Bh8G4YsACy3fU8tybV3zeAZ2dtbUnfyhZ9xUYLZDy3lDhx3ljPwJkFVNW2fHsqdREvNFqr0ITBHU=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZZBB7jgT1JORmH19iJ+tQBTinmfmnfr5XScTJMgjmbd6r5aaOLJ/ghoTsKES?=
 =?us-ascii?Q?uA9SVnXwGXYw1usQPQjG7T0M+0YVwtkdkcQTrO533jRPC3Aizcl0DYevQppD?=
 =?us-ascii?Q?HfGafOg+YqR+b2h0lc/jI0/x1IKRQsIhcNWc29sFr31Vj0Ky32Ri6sHRfGNP?=
 =?us-ascii?Q?MdlW+Z+FoeaN3GEdHEPaaAD2ECvaAm+EwVRkbd8KdMZEMDDlDt8LgzIhqfLs?=
 =?us-ascii?Q?cNFtNk6YUsAUq07OUtJiqrcCGuASu6Lk6+afr2AWfdSypVHNZK4YUVg9xnFd?=
 =?us-ascii?Q?4figmZMyW+s9I7oHSRXcDS+n6yA4e+TJrUU0tPCEvXtY+rTXUnyjBI+4my/1?=
 =?us-ascii?Q?GquPPG+4G8m0fKkWjnGxz/C8wxXfh39roa0bktiOPxhBRobXjNQ3tZARzgmv?=
 =?us-ascii?Q?gLvJGz64NhBZb4WOU4efqEW6IQcKUknLi4v+l5wKl7ILERa73iVRixX6VFyS?=
 =?us-ascii?Q?fF/K5NRZulknKslm6g3BZlM0JpOh6lQTqPzKZjTkuQCky8MoGtR/hiqNbPuY?=
 =?us-ascii?Q?Aa3hdlTzBxDzizm6TZ/4XSt6SkLoANIzUegdGBeE9tlGDrsbSeB+A6YZcdSn?=
 =?us-ascii?Q?uBdjzdbts6PUFjAzHInaO5Yc2G5VibKwcVCF0AHz6lRLpydXzAwJgxeb0o1Q?=
 =?us-ascii?Q?xmfnKl0/vgiHoDxD5uzY3lpbt6pAM8qh/hf4BH1IVO7Ke3y9OLZNpqeDnBWM?=
 =?us-ascii?Q?z9y/mCNXuc1MshuMu+OGggmyvFr86NTp7JRAtNGiy7eThA4ra2f1Q9pIEYh+?=
 =?us-ascii?Q?A+WT/2f36A9F80nKvfhP3UB/VFyfMU5ZRO2r1Vl/RyW8cd4WFXrFigFix6vL?=
 =?us-ascii?Q?OKx1HfsYMuWgdg9Pl4R0tALM3LOhVyFDFAAAgHxXtxayH2hz9f9V1V5/Avh0?=
 =?us-ascii?Q?VLwaY0X1HWeg1DSqVn0p4Hcfoh5BV5ofnZAQvSUijtcjjFOC7xcHOzOf9Qe1?=
 =?us-ascii?Q?5vQf6TZpP6zweN4H8QrGOefDppNDzyICyua49d+TAPyXglMxUPHzqLHOwl7w?=
 =?us-ascii?Q?iFJ+HxiuFreBDwxbwWgFYP3KB1lbXVtDaIeRtPiUkfdDDDhWrqb8aiWheqUW?=
 =?us-ascii?Q?/ZO/8mynGjn6/3Vd/Y0hvvylXnqPAtCc9FOJh/E4nmlax+6tKjHSzcBUrqGp?=
 =?us-ascii?Q?/KDKXbxdUozjPATf8M2QXsOMt7sTHBrqq/eUz4C/85wSqz0FShUKvBDk9iNP?=
 =?us-ascii?Q?57CZ4AGpT0FkksRdxldDWs1tmgztR7CQeGar14aE5D50UO5230Hel0XcTwyC?=
 =?us-ascii?Q?/z45HIQEbpNfKWMevK5VLeRnoAMqHBK/xjs/ZQKAGuES1X6/Iy5jNnC5/ZLw?=
 =?us-ascii?Q?TmVS001KKQqXKWqCpKE3660asrijKcQ4Vm4pncHsjtJH3Wwzx/pHrKI0n0/7?=
 =?us-ascii?Q?kWMJPnjdjahAdb2IRZF3AuNBlLG3xShRIorJpFU8KjyL75bRZNgtJwDfvwlo?=
 =?us-ascii?Q?On2cbHReIRk3XRjI711QQjVW02YNyQLHtTbvpoxQxxFDgB9G2KPzRl43L2qA?=
 =?us-ascii?Q?O1g3gW66BL2KH8bTDmLDKZTH0owHmmHf0l1jDuV4aQPV6iamR2LqHTWiY2w+?=
 =?us-ascii?Q?GgIaqUxxWrPKhFm3qWRgqCxyPh3VfIL3a1vuWBlo?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69c4d28f-dc78-4e13-ce6b-08dc3235d4c2
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2024 17:03:16.6965
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sMyhgDbH3RDQnY4Kf0nDWSSP5zbwuacoU63M2+OBEtWYO78HbkCqR7I6xVIO2aYl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8521

On Tue, Feb 20, 2024 at 03:53:08PM +0000, Zeng, Xin wrote:
> On Tuesday, February 20, 2024 9:25 PM, Jason Gunthorpe wrote:
> > To: Zeng, Xin <xin.zeng@intel.com>
> > Cc: Yishai Hadas <yishaih@nvidia.com>; herbert@gondor.apana.org.au;
> > alex.williamson@redhat.com; shameerali.kolothum.thodi@huawei.com; Tian,
> > Kevin <kevin.tian@intel.com>; linux-crypto@vger.kernel.org;
> > kvm@vger.kernel.org; qat-linux <qat-linux@intel.com>; Cao, Yahui
> > <yahui.cao@intel.com>
> > Subject: Re: [PATCH 10/10] vfio/qat: Add vfio_pci driver for Intel QAT VF devices
> > 
> > On Sat, Feb 17, 2024 at 04:20:20PM +0000, Zeng, Xin wrote:
> > 
> > > Thanks for this information, but this flow is not clear to me why it
> > > cause deadlock. From this flow, CPU0 is not waiting for any resource
> > > held by CPU1, so after CPU0 releases mmap_lock, CPU1 can continue
> > > to run. Am I missing something?
> > 
> > At some point it was calling copy_to_user() under the state
> > mutex. These days it doesn't.
> > 
> > copy_to_user() would nest the mm_lock under the state mutex which is a
> > locking inversion.
> > 
> > So I wonder if we still have this problem now that the copy_to_user()
> > is not under the mutex?
> 
> In protocol v2, we still have the scenario in precopy_ioctl where copy_to_user is
> called under state_mutex.

Why? Does mlx5 do that? It looked Ok to me:

        mlx5vf_state_mutex_unlock(mvdev);
        if (copy_to_user((void __user *)arg, &info, minsz))
                return -EFAULT;

Jason

