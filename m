Return-Path: <kvm+bounces-9189-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D779D85BD1E
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 14:25:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 668AF1F22C9D
	for <lists+kvm@lfdr.de>; Tue, 20 Feb 2024 13:25:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 478296A330;
	Tue, 20 Feb 2024 13:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="qjJLMm7x"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2083.outbound.protection.outlook.com [40.107.96.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CACEA6A00F;
	Tue, 20 Feb 2024 13:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708435505; cv=fail; b=dWc5lnKPnTOnG1iRAxe+RMKBGih0+IiHYGKV7NXY412c/Hqs7mC52ax6KEFjabKc2OoHifi+sxtUQtRZ9Z54nS9OqEzdU6Waegar9DNjUIFbKj9azFS5vhtUlkfaLR+ls0zm4rqjvbiqaDHu4NDV+xbxSPfgFThwXrZT6yH4+kc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708435505; c=relaxed/simple;
	bh=Z6OXxAi4QoRBly2N3j9a5s82VKFbEenW/df80n7xQ6Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Gud4yyMICI4z+fcQIuZv3CeJLDhV/Eo1oDo4hjkEgoqLG3k1Ih2FDc9p+9NQyRkssRp3Ptrurgrqd44I0cQzWLhwWZq6Gn+uJAOvNQ/+a4wUz35Jf0k5Jb59RZnkhEl908FRPoI+va1r5j1gu+P313SON+JLxK1fNCdRHHD4HwM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=qjJLMm7x; arc=fail smtp.client-ip=40.107.96.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZG8UmAahMp7HpMIkxVPN3s/C+IC9nK4XNz+nN3qEVZ2ZMihRy14vag9SPrCjKdh9eiQjxvYs7/DA0aieD+168FfH85n4am9pxhM46NRX0ic1Yr9fuYvMbCPX/wqnl0KsQYML2HbU1zCTpvSyyyvV5ch5pSy4q40LzpZLfBh++WDOIYeaEIvToRZ31ytFeTvRYTz+abL6BgJXnmfnnA+Q2E1Cq8t4XUqeZnHllcIbwG95876zf2EA5ljc76cqDU+Yg+1SV4AiZ05v3ZfO5lIJBoz3bVt+7MMzXFJnFAm8K8E7TZEl+hf+lDbdKjI9KX3lJcXhkNmDo39jsrUmhi/sfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oNg335CJfsyI/rCBbmKlHwQjljN7i5TzGqwrjwBpSgM=;
 b=M6BsGXvE1u+h5Fp92LLsizsRKuu08l6K+V2vgdyicXv3rtIL6reFr3sxDKBzKuUW9ybAfpmnVV2DryvymYCaBkWLMcO6ClGd9k6dVaZAzoMaWdHgQ3WFFj1KYN2hRxMU0Dp1dUwKKhFhrETwKdKxy+jbME4bHETJfFZoAQFQ3ieNp9AQlKxF33GUnNV7B1qZHTajIncPCwK68HiCjDnGHufyuTpgcB6KUYwOGkgRNRciUxJtX2gArFlcqplAm2Pat3Uj69wgUsUj114SlOMtSaSaF1hAysXeDYI+DFGaTLyb2MLDXuPzO1bcG8428B3LrZ/75KlTYipmF3xUATxVvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oNg335CJfsyI/rCBbmKlHwQjljN7i5TzGqwrjwBpSgM=;
 b=qjJLMm7xr7XVKiQZVb7pnvWPUXNQh/zXIjg30gCMaU0ROToAhHYaxm+KCmMeJ4ScXaJpEyKbI4l23mDQvhj53SmSeKpZnZ8L9IgPCbW2AGfsmoGO7w6X7Iji9kZu5vL9Ct8UmJ5nIa+euC/x29kRSMseWw++arKhi3dyO2MW0Ioy6yPCUdOSwJXAUfwHFDw/FqU5zTYkHRYxoAmLmQpMwq0wvFUmj0oTvKLlcNKdnJUOVUglibjHiDV2g7EJQX6gCih3Hfl/rVfBPOJNPw0oyOe14KWT6CZlbgO90wsxwnHoU50+LwPB/FXDu0L5O9899v4fnUSiV7fStix6t1cuVg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SN7PR12MB6767.namprd12.prod.outlook.com (2603:10b6:806:269::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.19; Tue, 20 Feb
 2024 13:25:00 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7316.018; Tue, 20 Feb 2024
 13:25:00 +0000
Date: Tue, 20 Feb 2024 09:24:59 -0400
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
Message-ID: <20240220132459.GM13330@nvidia.com>
References: <20240201153337.4033490-1-xin.zeng@intel.com>
 <20240201153337.4033490-11-xin.zeng@intel.com>
 <20240206125500.GC10476@nvidia.com>
 <DM4PR11MB550222F7A5454DF9DBEE7FEC884B2@DM4PR11MB5502.namprd11.prod.outlook.com>
 <20240209121045.GP10476@nvidia.com>
 <e740d9ec-6783-4777-b984-98262566974c@nvidia.com>
 <DM4PR11MB550274B713F6AE416CDF7FDB88532@DM4PR11MB5502.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM4PR11MB550274B713F6AE416CDF7FDB88532@DM4PR11MB5502.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1PR13CA0321.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::26) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SN7PR12MB6767:EE_
X-MS-Office365-Filtering-Correlation-Id: cbc4f465-d323-421b-ed4b-08dc321756dd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	nHtpgBatBgo2LM8Muukwe2SjjTzB3+U20SWwV51YP22gNDfwZfzODo3fQA8vQMGgYJOnYRPWXpNsuM0sor4UQzv3qTVJVHSTvDjD62pLQGmgmWn35dG+MeU9LXOmDreUN8JXDJAD9BX9N6QnAPffWB7wCXPiGReDoIMXehL9e965k513skTZzkdOtRlOkZEq4BatG3K2tBjwLcXIRkg7qV6ugdmvarfkOLHoVWxL4BBIfsvYZmD28DbsGbj/FyxGBIqDEDvVH3onUxhTa7DWEVhr3ryIu9YLPZFsiuyI3J42FU537v5+0qlEEVU+DYUulVnxUSzmmm/s5u/LEV5n6xImAn0FDRzH3NZzhtRVv3B1A5uTc1fcmpe2wPMyuJFqmBaJq1/aGHmZ98eVCVOhZNINZvDlzci4bnZznSTaHNg1X4W5+rCnbQkMMPHOr+m1LkZkb8QEFcejg0R904UBVhQg2AuXKUKC/rcSAqJpvnc4Y6GokrdlmauVBoPvwEs673bI3nL6RsmyL4AOy1fXkoL9CoknGS/NirDx34YT3Nw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RkGLZucmsippcEPjnfHhMmkHIZFQQ3wSkoUQF3o2ukPT6X7fupEpUoIzlN0g?=
 =?us-ascii?Q?0r+wmDVdtgJVN1dfooWQmDf9BqmSJUN1Qa6zncmXyezAKOtfELf2wP3CSbrT?=
 =?us-ascii?Q?idwXoP5yyE5b8eX+coB+I5bp/tdP7/Fr2vXXWXzTDw3e+EpkSRCLOaqyiCw+?=
 =?us-ascii?Q?z0fbeqzhO/RAxNy2L9+WYesU7mDZraqoJ0DojeGX4fOTrtsaQ/x7VeBP8NtY?=
 =?us-ascii?Q?qVMcE/WmnyeZmUUCGYNCyz7IimH6y5BxYbYr9S2E5R2cLzXw0zd+9fSTUjkS?=
 =?us-ascii?Q?rX1Wt+aJwfAZVUJDwuOr3bvXqZPTyx2VC0Evz97LUjTFkrbN1jKcz4RAAWho?=
 =?us-ascii?Q?Zo5ijz2Hrh6FQm6DNAG3+ZrKrLEtCbadQPweVDZA5AEA+Twm3NPWIUxkkPbP?=
 =?us-ascii?Q?a7mCFxc6brrqg82RMKZIPWlb+JbfuGKKnmb4/qOFG8z2eqveDo1bSy/s0Jsr?=
 =?us-ascii?Q?tr2TyX+ravs10Tp98S1wsU8wqlL2ShmaMvLvW8FHSdxxWWw+bTgH80fA23vv?=
 =?us-ascii?Q?Gx6yWVPIiAEqFuanQxgSfpqYcfhATGMdxMfvH//jVU/cId1lDZ/wlYsQ/27S?=
 =?us-ascii?Q?NmJ6iArWXRkVM2Ox/26tPGo/gicNxauwfyh2euhs9bNltV160e1rQ+Vl53Gm?=
 =?us-ascii?Q?vMoX7QfFXgm23TAGux60DR7c0b5/e9M92OLB5A2cgOep644FpZ9WYl7C9yPC?=
 =?us-ascii?Q?iFv5ZwmvwXyv+oSqSu1zrkh47WCbZw/oqcVqxyIqVHQq2vtwpW0DfkHpUDQr?=
 =?us-ascii?Q?eoDEK8OZodcoJwUj8v+vIp5NvSVhpUn9unQX2LLHRNIFQ99I9zNDqrdwNwP+?=
 =?us-ascii?Q?elamr3T3qVImCpSwFuste8ZUy4dzEZXqFsB09rGwhR5TK5kJZlDQ6ERN2Tyw?=
 =?us-ascii?Q?gmGgBDuJCKw7S/N/+Ir6MkfnWDw+KNEAkXkmU2rXLGH+hRAMrQe2cjYo0ACc?=
 =?us-ascii?Q?afTOug8SNFopxFj/P3+1XUr5N5UC9pZaNowpik5bujnCs28KMDVDNKJd5tau?=
 =?us-ascii?Q?ZtxUT3qbW+iAEngJgueMDCbSFx/l/ehg4dQGVu0liR607NRLjCKBrAQ1Yx0a?=
 =?us-ascii?Q?qUTTNAw6SDPTtPg45lXUnYvyynCsUiINJipNQ3PKbLeQdKLBVmOd/Eb7/Yzj?=
 =?us-ascii?Q?ngIHax2U/OXQ/H8dvGTyun2FKn/S8MOWw0nYdDASCSBugy17+CMbxlUibsgk?=
 =?us-ascii?Q?+PvVRK+eFxeLgzLb/uxK8z37pfyTFTScLBGz+Ki+9y11rb2bAC8PiOCRkhUO?=
 =?us-ascii?Q?Z2LSPV5VVLYS845JpRobnsKeuazJK5CmoqrXbgmlcEpoCfuED8AQgThmyyP5?=
 =?us-ascii?Q?FZYYGYB90nu0D2YlC0XP9sYOU0+etMBMydJBNyGLIhHWIKW4dFzQDpoelgFn?=
 =?us-ascii?Q?i5xrOmhtybNHiGvWngKAMKiJB67G7f+HHx+RBywLSADldsHXqWXrbINnyI8w?=
 =?us-ascii?Q?DIeSqpC7cNtz0Uc/KcuXIgy3QecYm+/HTXxOrv6o+hD93k0VYK+XFrR2ZP9n?=
 =?us-ascii?Q?xhDpdJh3QNtRyUVRLYOXDQCySusl6u3wowOrfC2G9xBJEp8zcxKoZ/e0Ispa?=
 =?us-ascii?Q?7vFCU73V96kDCNK9zfVIWIPmYR9+tP/zEj4PRJcf?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbc4f465-d323-421b-ed4b-08dc321756dd
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2024 13:25:00.3952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dUT+zQw+Y4R9wlLdTjKRzh/oug6jm2YXHaE9Inr6TxApVH8bxb03+W1Fxuh57472
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6767

On Sat, Feb 17, 2024 at 04:20:20PM +0000, Zeng, Xin wrote:

> Thanks for this information, but this flow is not clear to me why it 
> cause deadlock. From this flow, CPU0 is not waiting for any resource
> held by CPU1, so after CPU0 releases mmap_lock, CPU1 can continue
> to run. Am I missing something?

At some point it was calling copy_to_user() under the state
mutex. These days it doesn't.

copy_to_user() would nest the mm_lock under the state mutex which is a
locking inversion.

So I wonder if we still have this problem now that the copy_to_user()
is not under the mutex?

Jason

