Return-Path: <kvm+bounces-8430-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 96A8484F50F
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 13:11:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 88E451C23081
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 12:11:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7893033CCF;
	Fri,  9 Feb 2024 12:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="JtL6UtM/"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13EF3286AF;
	Fri,  9 Feb 2024 12:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.236.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707480655; cv=fail; b=JF0qf+uwo7IL6hgq2p87yAFdrPhs8tMm3mKEBt5FEthARc/7Zf7bbIL+aX2pYJTHkAEPHaeXgS6HU/Rg6lEtauEjYsaBnWefoCjB0r+r09K65pi6ufGeNckuhIDOJH/GUHieJoE/vtmktg95MMsML3RGXqD+quGPYsgpfJJU1Hw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707480655; c=relaxed/simple;
	bh=Cz6CSSTbDjt1swvQsdqeFmN8vYKzeim2T6k6kTbUwn0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=MkFQ274kqBmVUvhJDKdO5tbivrO7RG9yDBG39mtBcuIe3fL7a4Uf+TnF4WkvQwLjnHq/9X3c+M7fDUn1XYL+7lge3l+BWzum4SqZ7CChx3l5XMkj58I+JVFCvgbovJth72/zcodwZFwcTZrSaQ6XLqmhMcRBPfxTR3vAEzhIomU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=JtL6UtM/; arc=fail smtp.client-ip=40.107.236.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HiIydW2QZpNobS3dgpUpmPEme+OnxDF07e53r4RNWAThwZSdtgD8vrOGSriNLEcwwyIZ4PYISag3y2qmEI8OCu16UMEDxSVBhUMYIXV9AOAhzPC+SklQ7LvpREXwZ6pVGgQaCMIR089qXJjSC7MURmorLkcx8P09fWkCwL32THH79Y4YT0tmTwoBreBuKdXOB3xDk+CRxMW3dWDy1orIVcNRnh4Erv6LGEpPrH0XhveJfmV4xqyIsfcZngARAezFR50B2h5/hJyP131PpKxJXoGwLuoudQ72mR6iP2r3Gib09z0Z4W33g/jfTzamLvRRHvgIPT8u65E3vTvBYnLO6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Am80xpNjm8AOD5xG0msvbDbslkXPnt9+U0Q+Coc2Dg=;
 b=RToAK3NqHD/XbN3x8MwJaPJ6eyeLKOY3NR2m3o3f4yae41BH8RtRCu/nXoJWG6LhgaYpozDrBuUbNnKvvogyX7VXcEQrdnvols0Wz4Nad5j9/f4WnLaiB3zfTEokuEVbNZARc1lDKCiWZhrLRrUrRQ0LhBQMx1ly4pX719N4aDM5wqIL1uzDvdAWL6FEFpteLJ7GaGTWo2Q1BnAisij+hglZYOwplQstcNJx8uIWTW4oFCpSouFhh4ltPy+sqAeOs1ONKYSsd0BmwcVN3HvKPf1SK8LeCY+yYrkdvVFjYxS1rRb8O6v75J8csRD5RsFISihR01DIy0hXJmPqs4/ZPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Am80xpNjm8AOD5xG0msvbDbslkXPnt9+U0Q+Coc2Dg=;
 b=JtL6UtM/XyDygD45viHICY9gnfwKU/lJwDJtumhIpkNayuB00Z1h2RPywPQKJ0yfgbsECkrKvvVTz104WCwo88HYH6ACXnPIP8gpzNCTbuPT4uCJQPmAlUta2hZDd959N2mbxXdFANmHj1/zwHN0Wp1s8ktkUZ9S5h5/+FznufvAinKpiQaTjUUYO0+Skz4N/lOmnrZ3odOH3VroSYYGbBg4Wy3nk7zLpqLPT4p4D3e/erHUxDxEXkGI+EMheVmMWZxGE5ETxl2fDwhAwW4vYsY/Dee2aXAwZjZhiQh5DhOI6dBIUe8TyfS73XZVfzqo5B1ztG7sEpCiyIYLTw9axQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by BL1PR12MB5304.namprd12.prod.outlook.com (2603:10b6:208:314::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.11; Fri, 9 Feb
 2024 12:10:47 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::96dd:1160:6472:9873%6]) with mapi id 15.20.7270.012; Fri, 9 Feb 2024
 12:10:47 +0000
Date: Fri, 9 Feb 2024 08:10:45 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Zeng, Xin" <xin.zeng@intel.com>
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"yishaih@nvidia.com" <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com" <shameerali.kolothum.thodi@huawei.com>,
	"Tian, Kevin" <kevin.tian@intel.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	qat-linux <qat-linux@intel.com>, "Cao, Yahui" <yahui.cao@intel.com>
Subject: Re: [PATCH 10/10] vfio/qat: Add vfio_pci driver for Intel QAT VF
 devices
Message-ID: <20240209121045.GP10476@nvidia.com>
References: <20240201153337.4033490-1-xin.zeng@intel.com>
 <20240201153337.4033490-11-xin.zeng@intel.com>
 <20240206125500.GC10476@nvidia.com>
 <DM4PR11MB550222F7A5454DF9DBEE7FEC884B2@DM4PR11MB5502.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM4PR11MB550222F7A5454DF9DBEE7FEC884B2@DM4PR11MB5502.namprd11.prod.outlook.com>
X-ClientProxiedBy: SA9PR13CA0157.namprd13.prod.outlook.com
 (2603:10b6:806:28::12) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|BL1PR12MB5304:EE_
X-MS-Office365-Filtering-Correlation-Id: 31e3291b-6b5d-451b-cd3f-08dc296825cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	lEyuhhwF4GPV15z/S9e+YeHqfNDAsaAOgLoiEtYM4zxEpWFMkD2N4Su7OhRWTOMA2JlDC5F38huu595ktYBOhbdCsbb5hq6jRXSgIQN46FDJu8x0wjOb5fmQqav8hC7JLFWmwsR6huHQJANJ0gHP2Llv/Y5riGRRXirIvR71XzFgr1/CY+/Ize8Nby/UqPukZP9QM40HcC62Ee6pJRv8/9t7fVMWVOAa1fE34K8T+Z5ftUzz8G4aJHUQN2FkxdPUBPukm4BRvR2duE/gYfSYXbm5Lh36ioXS2zHbmYTFcpY5KaX6jndIid+xLVCuQClK0r/DAD/dDfZlHzq9lrbNBSkE0y23psGuz93HfaOuJTlnTItStKnaG5/GA7YKgQF/m9+QZbr0/b06VKpgtq/tQbNumb46hr2cUM2G234sig5tTooh2qrP6mg8Az5LQvTkEbma7J2MKbDRLtcbdhS8uKDol+HZ3ICDiafwE105nZWRktPnH29DFY6HUrruBIgqMYnJSLBJN9Uhwvuru/gFBgzRNSOaQPvQ2ugreNlUwwPOLec2FlU+LEyZR91QdJxs
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(346002)(39860400002)(376002)(366004)(136003)(230922051799003)(64100799003)(186009)(451199024)(1800799012)(41300700001)(6506007)(53546011)(478600001)(6486002)(83380400001)(66476007)(5660300002)(2906002)(66946007)(66556008)(1076003)(26005)(2616005)(36756003)(33656002)(6512007)(8936002)(86362001)(8676002)(6916009)(54906003)(4326008)(38100700002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pVzv91DqIGTpjySVeuBSireeQEL8OxOfRNhGTYV+iQYU9RoyGTap8OKFRokO?=
 =?us-ascii?Q?Q9Oc+6zDIJ4+CQzjt0nuk48QPQe4encgcIhPaxmz5Oplhs05oLCgtXeoD8pK?=
 =?us-ascii?Q?C68L+/fYS0xBukgELqaPGNYKPrKMnXPesmLKTyeOs71ke737aX4BHi6+NS2H?=
 =?us-ascii?Q?lv/VDkR8efV8ZaYuF2O/JVkPvyo/utGyrL1oFz6xeXutEpCnuvP9qrQ6Q2OE?=
 =?us-ascii?Q?O/3+zdboOCn/zzJPf5Z546Ik5ejZZxomJ19A4yPfIkqDvp7iqCDH0fYSN/vo?=
 =?us-ascii?Q?czkJ8PPE86JFu+ZePJ1xEh5xJHhf/R7hEsVRT4PDwgETyA5NulCkn6ibj0jx?=
 =?us-ascii?Q?2T0gOev58jQotjWnGRPw8LCN5HqAB9hOITtbuQ3wtd0GHIkU5t7VvVznpxjL?=
 =?us-ascii?Q?ewvXuOOmRhZBq05ILeBsRsYwdInRT2jG5NFU314NUb3UaWXoXhHYTIKxsj5a?=
 =?us-ascii?Q?iQK8q9/MR2ERpUt6EhWYRG9nlithVkuedPP+9UKAP3g3+N5eDG7Z+y6Kd5sh?=
 =?us-ascii?Q?7k3Dsu2JkTVdAAmDpPo/j2+wvj/o9LzuOuhA6wCqKAO48Eu2pHKlXfEaJbEM?=
 =?us-ascii?Q?S0lX9u4fAvH7PUIEB7ZPINtFQ9GOCrIt0zySX5X+BVQxP2DFRnxGBPRSUyY8?=
 =?us-ascii?Q?PKiqQmcBPjb0RLAdjbAoDBBiumncNrf7A7Qbwa2wntbeMLU++rd39wfq3c5I?=
 =?us-ascii?Q?XQjl2sA53b7YbwCa776f3Jnv3zckcJuJIpA4RNB4EdTIVsO4NrwM0s1GLjEu?=
 =?us-ascii?Q?lwByaxUfjjtzlADXkJCrQ+BQkWPEII/Ng14Ghmuh7spwaqjUYQThOo4fba4K?=
 =?us-ascii?Q?lPonrhccgGbpYK5PegrzSmoVNUazyxMG5SLp4u5WxqxzQtgpax+/+gHoOrxD?=
 =?us-ascii?Q?A12e4jDdnfYpxH4oO2zppzKaM+kCUlyo3KjfuhK27hjGuc9nTVqOhUOlaGdv?=
 =?us-ascii?Q?cjJur3EAY5bUt+H9fLTIx9tnm8/7BKAYx/kDCH6zlrS7x7l+g3C1g5c6EVLJ?=
 =?us-ascii?Q?wc9rE3N9edU3JcdHsN72/S/ADpeG2Y/bS/eNjBxBhxQdtIQjJpz4wzzg+QsX?=
 =?us-ascii?Q?XRvzWkmEMuj9PCmfkBW4bXtzv0YX6HqjP0UZRLRf8WSxteaQl4kXLYl6zkvg?=
 =?us-ascii?Q?ZLSXQ8N036Plw+sp+QhNUKQU0X5AJV3+U2wWTJjf1j/dWYAOXpdz3tDsS/tv?=
 =?us-ascii?Q?ka8Y7KUtaFd+PX01kSvMrxCLBownfjnzW3QnD56tMRLNZD02B8jbY1WXLlu3?=
 =?us-ascii?Q?x02CEiz5us/4A6VvorvXloOqxan5wxhXnJAivDsWEgaZ8jYcaAqAWiSXpxaI?=
 =?us-ascii?Q?NMar2XBxHZBYqjaVOSNFkEfa7V5ke6aPbjt1a7dCHNpbUivuREtYTHl5gAjN?=
 =?us-ascii?Q?atYmig2cmB5+x5a80cVjN3xqQnCO7vx5j1qHQX51/ezPSnKwnvDk5jStoa33?=
 =?us-ascii?Q?1uqj7P8ZATRcOvObR4uHagvzD4GvyZ8v1Qg731DLzwHq0CWUJ/XC5X6tbBD0?=
 =?us-ascii?Q?/hkLePz31BQP0xNWdIh3w40ZB0Cz1yd2BkoUyseJ1sQEFgXfVo3qot8VBL9D?=
 =?us-ascii?Q?vyTpM8OwnICsI747ywsQvHoiDiySHCoCBddQXZgs?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31e3291b-6b5d-451b-cd3f-08dc296825cf
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2024 12:10:47.0697
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mKnkYFO6aD7cnXDw6jAttqkyZnwJGdJfcc8rhv1O5Ujm4gNVV8ntR48OFqyHL1qw
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5304

On Fri, Feb 09, 2024 at 08:23:32AM +0000, Zeng, Xin wrote:
> Thanks for your comments, Jason.
> On Tuesday, February 6, 2024 8:55 PM, Jason Gunthorpe <jgg@nvidia.com> wrote:
> > > +
> > > +	ops = mdev->ops;
> > > +	if (!ops || !ops->init || !ops->cleanup ||
> > > +	    !ops->open || !ops->close ||
> > > +	    !ops->save_state || !ops->load_state ||
> > > +	    !ops->suspend || !ops->resume) {
> > > +		ret = -EIO;
> > > +		dev_err(&parent->dev, "Incomplete device migration ops
> > structure!");
> > > +		goto err_destroy;
> > > +	}
> > 
> > Why are there ops pointers here? I would expect this should just be
> > direct function calls to the PF QAT driver.
> 
> I indeed had a version where the direct function calls are Implemented in
> QAT driver, while when I look at the functions, most of them 
> only translate the interface to the ops pointer. That's why I put
> ops pointers directly into vfio variant driver.

But why is there an ops indirection at all? Are there more than one
ops?

> > > +static void qat_vf_pci_aer_reset_done(struct pci_dev *pdev)
> > > +{
> > > +	struct qat_vf_core_device *qat_vdev = qat_vf_drvdata(pdev);
> > > +
> > > +	if (!qat_vdev->core_device.vdev.mig_ops)
> > > +		return;
> > > +
> > > +	/*
> > > +	 * As the higher VFIO layers are holding locks across reset and using
> > > +	 * those same locks with the mm_lock we need to prevent ABBA
> > deadlock
> > > +	 * with the state_mutex and mm_lock.
> > > +	 * In case the state_mutex was taken already we defer the cleanup work
> > > +	 * to the unlock flow of the other running context.
> > > +	 */
> > > +	spin_lock(&qat_vdev->reset_lock);
> > > +	qat_vdev->deferred_reset = true;
> > > +	if (!mutex_trylock(&qat_vdev->state_mutex)) {
> > > +		spin_unlock(&qat_vdev->reset_lock);
> > > +		return;
> > > +	}
> > > +	spin_unlock(&qat_vdev->reset_lock);
> > > +	qat_vf_state_mutex_unlock(qat_vdev);
> > > +}
> > 
> > Do you really need this? I thought this ugly thing was going to be a
> > uniquely mlx5 thing..
> 
> I think that's still required to make the migration state synchronized
> if the VF is reset by other VFIO emulation paths. Is it the case? 
> BTW, this implementation is not only in mlx5 driver, but also in other
> Vfio pci variant drivers such as hisilicon acc driver and pds
> driver.

It had to specifically do with the mm lock interaction that, I
thought, was going to be unique to the mlx driver. Otherwise you could
just directly hold the state_mutex here.

Yishai do you remember the exact trace for the mmlock entanglement?

Jason

