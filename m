Return-Path: <kvm+bounces-15301-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 115E08AB070
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 16:13:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B4E582855A1
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 14:12:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 920DB12DDB5;
	Fri, 19 Apr 2024 14:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="lMfkX4fo"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2067.outbound.protection.outlook.com [40.107.93.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE3F12D1FE;
	Fri, 19 Apr 2024 14:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713535864; cv=fail; b=RmzSrOCAskmj5ShtwAIfgFTtsuYLF+fM1/2i87+EX1MfJKAHur+aYVFU4esHmsfrzDA7ouWghmvksdupcRlojJGd2kr8sVxn6EQ+SENOTMYKKDpo4o4Ldxsys73S7vEeghRUr6Y/F7gol2umW9ahmJX3OkVirRq+PAhwXCP2czI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713535864; c=relaxed/simple;
	bh=7iD7gCMYPRoSQB3pYMuKBjihZo/8Q8waYi30UU0vUUE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ORYuZkQJtGZpl9j93dPjgfMpfwjFGdB/Aai6gs9ri0VhwKSDHpMahgPuLTc/t3iGxG331G0kX888ikDrt529mmJ/3TaeXR2+fsiYtNHVL3QX5Nlx3kepiyYlZeSg+RM9+n3azgTayXJrHK8UZ+phYx+0ifBJiHIRWbBuP8ssd0c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=lMfkX4fo; arc=fail smtp.client-ip=40.107.93.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aWoGyMIReGMNYD8D8ARcGUzKsQSnBb3nT648eraY42ti/D2I2rGO3gerPWkXtPL906Z+qK1QWprVqMWqVF9yZ7BKHcpESMTzZYYBo99yiqZ3RYrSY9/gh+wQ3Kzh2uv64XvXVMYdZM80BWgqajYeVnNPDH76kDiV/D5PapNLJ3wHLB1Kqo/43E5ehzBW1MZ69at9sBAIlqT8q15cpOOgJgrYwIjlxne7k/UOvnBT+ZnaWLz4rwDxlfrquIEENg+TB0UokSooclU1FxluWiWLUf44RFV0qJaZf6R17YWAhC/CaYYEYgjf68RJMBeQKswZvvD3IZNjjbS5Ghhpp56ybQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H54KobjNlcc93sg1kGo5C/nFeVGvhW4qi8zFmlX5jlc=;
 b=jD0tey7F2otdXwMbsRclw6iHySaE98/YXBL9c+mQLztV+IeXjewbUFyxQxb3XyQppSNv2LtGIEFz5k74pL64DkrJad6I3OSp1AzGrLDtPhb/Q3yAPbYzPGt9KnJGchAfAtqN7l4CR0cMre7kFKngQsPg+Gf4p/sWamW5rz/15VfVeNiXqtrknw3l+gJIXzr0TIAPfhSOcDU7S+Rm6XF+cptQbx9jJQ8SFjnopFc4ty1GL+DuhyIvlGSE8lMGtlcH+Ln08UQ3ibNSvUPr29nW65YpoJ/ktdPTQISN4H2UCU5aLMPaQMJJIHzT8aTq7tu1WjEYG36J0W2Zw2iedPqybA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H54KobjNlcc93sg1kGo5C/nFeVGvhW4qi8zFmlX5jlc=;
 b=lMfkX4foMJ+iajwwsWP5NI6kRaS79YbR7iWS8M+f75m48kX32ZpUEmz7AsrcjNirZ056rDJPN4DO2A31vHXj/Tbuof0/y/G/HDkuCWo/ujs1wVRkQ3qasIosVzmeAVchwB5YQjRb7lPKiZZCx8L7tGWFdPXACjT/u+S5hA8kXmLRGOUIsRi0AQFBTonLdwjHflScxETv8NZp7DETaG4nQvbQVUwEWGjClHMPNBi7p50r+XBnq9dfg7pNiVNRfH/ce8VNZBIPqYxykoob0rB1/c2jgj8l+9Q+oKQBSLJSLO/o2zVwuiA3mAWkwECykOuSW32xIV70ewozmRt8S1TwzQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3849.namprd12.prod.outlook.com (2603:10b6:5:1c7::26)
 by DM4PR12MB9071.namprd12.prod.outlook.com (2603:10b6:8:bd::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.40; Fri, 19 Apr
 2024 14:10:59 +0000
Received: from DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222]) by DM6PR12MB3849.namprd12.prod.outlook.com
 ([fe80::6aec:dbca:a593:a222%5]) with mapi id 15.20.7472.044; Fri, 19 Apr 2024
 14:10:59 +0000
Date: Fri, 19 Apr 2024 11:10:57 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	"Zeng, Xin" <xin.zeng@intel.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"yishaih@nvidia.com" <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com" <shameerali.kolothum.thodi@huawei.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	qat-linux <qat-linux@intel.com>, "Cao, Yahui" <yahui.cao@intel.com>
Subject: Re: [PATCH v6 1/1] vfio/qat: Add vfio_pci driver for Intel QAT
 SR-IOV VF devices
Message-ID: <20240419141057.GG3050601@nvidia.com>
References: <20240417143141.1909824-1-xin.zeng@intel.com>
 <20240417143141.1909824-2-xin.zeng@intel.com>
 <20240418165434.1da52cf0.alex.williamson@redhat.com>
 <BN9PR11MB52767D5F7FF5D6498C974B388C0D2@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB52767D5F7FF5D6498C974B388C0D2@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: SA1P222CA0151.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:3c3::21) To DM6PR12MB3849.namprd12.prod.outlook.com
 (2603:10b6:5:1c7::26)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR12MB3849:EE_|DM4PR12MB9071:EE_
X-MS-Office365-Filtering-Correlation-Id: 3e2f8ef3-702e-4946-0a05-08dc607a8984
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?dTogkd9BObM07Q1snSZBcMEOmKFdGegCfzz7rUEnSxFHDVkxrHcGcR9Xgdh7?=
 =?us-ascii?Q?g10YplwQygMAO8nJcK4kMkkYTAq6Tnp6NLLk5r3RXsz1h457Xp+mgZYCnOiy?=
 =?us-ascii?Q?faRXoRCrSI95r5n+uZFLe0JiSJ3dMEZpK2yh66jtXrRtqKBnNpIA2DrcORP0?=
 =?us-ascii?Q?e9KYwIFX63uOvE4PeGlgVaC3d5q9ziOwTYIpYptnzswcUt6uxSmKAbBX9Mll?=
 =?us-ascii?Q?QeGNTfSgdSorEQvEk0zcrY7oCJNH5LwRe/DfQlq2/xzUxrDsBXeQ91ZbwavL?=
 =?us-ascii?Q?XFxtVALubq6857YdjSzuzQ7CZrW5U6ZYmKGwk47xHZ8qzgxMsqWQvtZXDdK3?=
 =?us-ascii?Q?4lELSOGCqpbyPkk4/Dl9u74uA3CX+FKihZ402QB1ALb5kIq/BCRklPj5jk6j?=
 =?us-ascii?Q?YAZj8PUBpCNTcUSpPbFn000FqNi07w3W/X0u/Q9i0Zkuxc8LwgPQHSo+yQyZ?=
 =?us-ascii?Q?243NHgRKam8f56LQZDnNSUmzFhWVECgVwgIbnH8+wlW7vck30FRBVrnF1cNi?=
 =?us-ascii?Q?eAbG4/G4Ct/50vRyeVK4qe1Ery7yz0VaKTAMGAfSfcD6GqIwRiU2OlCe9fbA?=
 =?us-ascii?Q?K/PhIIBKgjX5hffziV2kFfMjN9BrA/azruhs8T23K9cB1dg6VpYZp9h0C6EY?=
 =?us-ascii?Q?ZTqz2F5l6qDCNPLApc9iRxp1ORQpXGpcLbWPV488Sx2n9wLikBfDslIhbp6n?=
 =?us-ascii?Q?/TAjJiOPaHggbOez4mOSMr1hpQj3+7F2HBB4JqeXfB7dJKYyhkFu7W5HKSLb?=
 =?us-ascii?Q?FjOuLdg6fwoaw0+2HCBFaT9NBcKr0hC0SbMJt63F6CDxxslAtZqdphxfA3tl?=
 =?us-ascii?Q?ffULtitCDzP830+Ce33IP/7SFkE2Cld7/GuWltlDV983Bem+P70uniZwQNdT?=
 =?us-ascii?Q?Hx/1L84HtHFDfegCrKXWQFVh9E3ciirN24OIaderojLs8FjmNSwxYn/dTP0t?=
 =?us-ascii?Q?aUzvbKlKGzxZSdQLsFYoYCtKxE+yp+mFSNmHHTp9vICcxjVrKGVWEzGvOQ0M?=
 =?us-ascii?Q?mX9g53StWUdeu+I8XK2D4KnHvjPtam3mCgN7pfJyD+L+dyMjq8QifdPBDf2V?=
 =?us-ascii?Q?EjqiVYu5f4DefyM2fP+1N06SHSmTMoaMio640gnzIyQSqtbQkTn1f4BqZztP?=
 =?us-ascii?Q?vb3euSfx8+IWzmtg1YQHYSCs/JjFx9xnxXg4Zuu+EBcmWqJJQ35+PTFzmpJk?=
 =?us-ascii?Q?MMe97Y6mZbXilYAzuJr2jKwGeH+DNXxizSdbXC8jB+1CejJ1tPVTz6HT39tv?=
 =?us-ascii?Q?vmtg33bEF//3NcvnfFvnCqE/1mBXfwUEBJlJKiZQNA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3849.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BS1jnSK3MN5PWHH0ANE+lSEC/tYwTejmvIT02nPCvy/y3D9FCGp+UhWk0WqD?=
 =?us-ascii?Q?oAhVGybO4n4k7MOuFHAH6UX2mYGdXHnS452+Y6PlhxUaxgR2F+J8gys/8/l0?=
 =?us-ascii?Q?O1YmBnFcj3v5rQv3rwI71DrtdY27cJWsqoutrr7WOytpsnN2dd4JHPGjooMR?=
 =?us-ascii?Q?nD/8FXYNt8bYraNDUYvCMV3fz3U+NrBmNc63Gm2v78R72xhtoJa2wW+HQHdT?=
 =?us-ascii?Q?j3CIlz7dY4g8+6ottUSRiWNOfezBewWyyOxRZEkkH/5L2qvQL3crY5y2iKc2?=
 =?us-ascii?Q?GWJfUPjWzxd34CzEBUXDk2mpqyCaXIZYl0agg/8K4HDh2aOo+1GIoQwRFNW3?=
 =?us-ascii?Q?BAeAHhDleeG+sfJri9XfnDKLwsa+qltroqkVOGd0q9xE/c7Q9/QLoDJCXDG1?=
 =?us-ascii?Q?xgRn0CCx/9XKddWdgab7sd0dx3J/cvmLtV1wre1z0xBjlDyy+o6mo7TwVOOB?=
 =?us-ascii?Q?edWnOh3jkTu7imXCPjASDMV3Osm9GrAfIwv0945nJMVdo/WisnFit6poPYJw?=
 =?us-ascii?Q?XmZ0M4etNXgmTxZcsV2Tt7S7qEvy0mbFp39hhBI1uQVBCL4cZcbOAPzcGrkz?=
 =?us-ascii?Q?RBeV/roJD2u9oWB9xHWJ9kVYFPMon5nLzleC5wmeAv+lzI7Wklr+vFCp/v0n?=
 =?us-ascii?Q?N85BF6LwTRG9lbybViTVo5fTpikMqiQuIZQ521J1YzoZc3EUKrN9MAZi6TPY?=
 =?us-ascii?Q?WdU6fs45TmYjjUOuIZvCdf7mJTzqsBvNOE2glSk9BRdIO/lXfr/eYXnf+TU2?=
 =?us-ascii?Q?8UZI3W9MdJ4+nENs87HUL0HKiCKgz/8yyhqjaOMwihxwUeHNakrJqLRqfv+B?=
 =?us-ascii?Q?xPmqKLxSDaiRQQlMoiUa3if2778CW7kxbMvYGqA+F+RP1zo/laZssjiSmwHS?=
 =?us-ascii?Q?j2eE4IwECndad4UsLJG/fWfkpo1gLY99Cu/+NT6+IUqCbDpSRg5sq2OZ0Zct?=
 =?us-ascii?Q?BVnAOjnv/1HFcO/crXTsCaxmX/MZ7ZZWwdJr9Y7djih+FAywd1qfrDyl+BcE?=
 =?us-ascii?Q?qn559Xj/m9+fZX7FIk7uBfimy5/k/dMWjqkskjf4z1LEAnpbTZ020FTi4d31?=
 =?us-ascii?Q?Ez94j8m1qeEYuo8Lq7VyCacjXwoyNdmTxnsuTqfYcIf6LogUEyepeNgJ/iC/?=
 =?us-ascii?Q?9c3z6Jko9Hu3YIP9XkQzm9nJSWL5cM7DuDIE7k0h7t3XxV0zTDoS9Ve3fp1n?=
 =?us-ascii?Q?RIFM95i+At4ZPENIXoys888QG+Janh8tPSTz7Ohtqwe8/AWtG9pq07RXJQG6?=
 =?us-ascii?Q?a+SAgrXGv76YC56c01fTCGCBzBq79vLUUR7LJE634MbGi/u3tw8cLN4UHYhj?=
 =?us-ascii?Q?OBxS1uF6g0PG0yOoqs1L5pUZo2BcokWdA7nZnAX2TYMFcDIzM/vbjIEYkCsr?=
 =?us-ascii?Q?gCS18aGUexYolLxObM2z5YKN009mo5eXOd9/tqvFmFL14/4tfQpL4I9vGyW+?=
 =?us-ascii?Q?FMS65oolC0gvSlvsQ6p/KcPCmFYjnRnNn0gVxu4jqgzurwhi8atfQRAL99Fa?=
 =?us-ascii?Q?m0HCx2IR1yb1ORoqfRy4IBPvCAce1NnoYqhMXNHfDZdcZ9U+xlD/gl4Bq2Fc?=
 =?us-ascii?Q?wbfzmwrOk5Q09C4MfoUV1vbzzqn6h5IwjwTZPugC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3e2f8ef3-702e-4946-0a05-08dc607a8984
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3849.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2024 14:10:59.0474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZP9vOOaHyOJtHVHtVYIxO94dl3iHOk/Fxd/M/nRXFupHR07/shL0mBuwfpXCPfsN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB9071

On Fri, Apr 19, 2024 at 05:23:30AM +0000, Tian, Kevin wrote:
> > From: Alex Williamson <alex.williamson@redhat.com>
> > Sent: Friday, April 19, 2024 6:55 AM
> > 
> > On Wed, 17 Apr 2024 22:31:41 +0800
> > Xin Zeng <xin.zeng@intel.com> wrote:
> > 
> > > +
> > > +	/*
> > > +	 * As the device is not capable of just stopping P2P DMAs, suspend
> > the
> > > +	 * device completely once any of the P2P states are reached.
> > > +	 * On the opposite direction, resume the device after transiting from
> > > +	 * the P2P state.
> > > +	 */
> > > +	if ((cur == VFIO_DEVICE_STATE_RUNNING && new ==
> > VFIO_DEVICE_STATE_RUNNING_P2P) ||
> > > +	    (cur == VFIO_DEVICE_STATE_PRE_COPY && new ==
> > VFIO_DEVICE_STATE_PRE_COPY_P2P)) {
> > > +		ret = qat_vfmig_suspend(qat_vdev->mdev);
> > > +		if (ret)
> > > +			return ERR_PTR(ret);
> > > +		return NULL;
> > > +	}
> > 
> > This doesn't appear to be a valid way to support P2P, the P2P states
> > are defined as running states.  The guest driver may legitimately
> > access and modify the device state during P2P states. 
> 
> yes it's a conceptual violation of the definition of the P2P states.

It depends what suspend actually does.

Like if it halts all queues and keeps them halted, while still
allowing queue head/tail pointer updats then it would be a fine
implementation for P2P.

> > Should this device be advertising support for P2P?
> 
> Jason suggests all new migration drivers must support P2P state.
> In an old discussion [1]

I did? I don't think that is what the link says..

We've been saying for a while that devices should try hard to
implement P2P because if they don't then multi VFIO VMM's won't work
and people will be unhappy..

> But obviously we overlooked that by definition RUNNING_P2P is
> a running state so could still see state changed from either CPU
> or other devices.

Yes, incoming MMIO writes that change the state must be recorded, but
as long as DMA does not start and remains suspended then it is OK.

Jason

