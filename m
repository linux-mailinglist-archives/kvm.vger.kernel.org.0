Return-Path: <kvm+bounces-52210-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F1C3B02725
	for <lists+kvm@lfdr.de>; Sat, 12 Jul 2025 00:45:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AADE45A060A
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 22:45:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15DFF1B0421;
	Fri, 11 Jul 2025 22:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="RWXnMA0K"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2081.outbound.protection.outlook.com [40.107.212.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951366BFCE
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 22:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.212.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752273921; cv=fail; b=SJvnD99Iwr8oEYBgMqQjBx37Yck1nyOL4V0BV3tDoyV7iX+LOrLmUHZp5a63dUWkNiyMiPdzpUKDLzHoJ88fyBIg4pxti/tF7x7S8c4QbjbuPcI8bJbfJLohWeH0qa1OEeNc4DrL8Sy7RYcbYOwNYwRnIyEsc8TBW8uYL5A5G8g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752273921; c=relaxed/simple;
	bh=hhLL/gydc+GLrf/jw00W16rKAQO9I6aNKfCBtwaGwRA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dYIpykrkF25YU635D5F2T7fQsz9gQwFDpvF1FskzNkHZEEfdGiFJ33cifHpfx/eQllqd3Ok9oNBO6dj8mrItRX+l3+79Yi7jlljWk1qLuZAuYAER9ZxYokY2N18kc74Y9inBXpcC2pJG5dIe9NKuKkSZ9GV2PcxtB6V9FLTuT3A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=RWXnMA0K; arc=fail smtp.client-ip=40.107.212.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HSPDpt65spclgMzmm/4CBH03t4AIfv6Mp36jQgZF7+5xENALwO41uIEqYZg4fA6CcfDdg9biQh7CMSBiS8drwWUVeVfpt6a5BWG468vUB5LQDNsuYab9L3STSMA8VOk29t+J1sTzzsefXSYCvgrJWTeJbh/bavdVsAtpeK+j1feIUOwriZ23HZoSf49/pmWb3idMjxkjyw6dsU2psh+Lvym56mfqqd9pdZCniP6z8SidnDl7xAKdE/ign0urAiNkUYTxJhCmNVtqEzp84SYnA3KALjpTfJF3HeS99Xgge0wEti0r8q4IjkyDdrqPS+5R4XWuS1s2slgPC8oDacUrrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CJX8TP0Q7XYQVyeeFJc7TZ74MrmUfS8MZPYKFqOJbBQ=;
 b=oYLH1m6u2H7IZz1OmMOaj7zLPxsOdoz7SWvBahz6zWu98LmKXau5okrqlNm81gVDp653Onr2tuF8NLi+gScIwCegzd8oaNiXw7k1/IPDtvQPpkmhgNEdZM/Mm21Fm/gtA0rW+UusLokWkRrTTB0MTbrs+bkkSid4K7+omAZeshoJ3sVUnpJ4dvp8xt6JhLN3e/p+RJJZcBJpimDkaAZbCkt2abu0OQPjpTb0bkotD1+J8mPosaIgenwINyeps93S2C6jM2EXWfQgAnNqdYc9wKZwjjDeIicKK5eXljULgSER8ql7EvynO87L6I6J5N9pYX3jNgchYdyRCqmsJTYp/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CJX8TP0Q7XYQVyeeFJc7TZ74MrmUfS8MZPYKFqOJbBQ=;
 b=RWXnMA0Koxi2hpd/YRRzjh+9O5w3f4a4gpNpCbb9R1AFliK6LD2XFmBxZA3EmkisbkxrJPtlnWMSRPHaSAXLiv93M/MkZAd74Rwr9OnzLHJTGRtZ52pI3Gn6LY/KlzhUVQaMlxKhmvodaEnhRcq3vEBrBOZuE8vH46bkRtkLXVqE7xmK8xT9x6osHv2HIZQRlOgIgmAV2eucuVaBq4he5luh2x9oxcrM7zvwIYNOK9L0028ZAx8F6lE0DgEqDfDwlHs4WJpCaQe5A45dQ2tdgNM+uQeoncxJTXs1iBnwNrR1mN2TdYTNZvEwxoyqV1vgvVsx1KzBv4sq8LPuahRyTg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by PH0PR12MB7864.namprd12.prod.outlook.com (2603:10b6:510:26c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.25; Fri, 11 Jul
 2025 22:45:13 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%7]) with mapi id 15.20.8901.024; Fri, 11 Jul 2025
 22:45:13 +0000
Date: Fri, 11 Jul 2025 19:45:11 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc: Ankit Agrawal <ankita@nvidia.com>,
	Brett Creeley <brett.creeley@amd.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	liulongfang <liulongfang@huawei.com>,
	"qat-linux@intel.com" <qat-linux@intel.com>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
	Xin Zeng <xin.zeng@intel.com>, Yishai Hadas <yishaih@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Terrence Xu <terrence.xu@intel.com>,
	Yanting Jiang <yanting.jiang@intel.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Zhenzhong Duan <zhenzhong.duan@intel.com>
Subject: Re: [PATCH v2] vfio/pci: Do vf_token checks for
 VFIO_DEVICE_BIND_IOMMUFD
Message-ID: <20250711224511.GJ1951027@nvidia.com>
References: <0-v2-470f044801ef+a887e-vfio_token_jgg@nvidia.com>
 <30449f7531ae42439136316321b3d60e@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30449f7531ae42439136316321b3d60e@huawei.com>
X-ClientProxiedBy: BL1P223CA0012.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::17) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|PH0PR12MB7864:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d1c87ae-1521-45bf-501b-08ddc0cc98e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9uHTmF+FOkAAQT43agiTVVPSekGsuiCp3AtmCNo5IZYqECF2Xo2oB2yhZjfU?=
 =?us-ascii?Q?t/nqAex9/Ya5DiRNZQq2Uyr3QVUl23+eKjRjJNjTPlJWKtZt5Yr0wA0okYAQ?=
 =?us-ascii?Q?8c4m2jhYGXErEIj86ex54NA+/wHIXSNBrh2u8/GpTVcniL4TJ/AqtWnOHZgQ?=
 =?us-ascii?Q?Q0iW/ji2Fm5guM/HuxFpq+aUh9FDufrmrpklEKXJuqwuWFH321Ef7ro7s+xj?=
 =?us-ascii?Q?vKhFkGX/6F8vThS2GtvBR/9MUbZcMt6FYR5qMInhhksv4oN6cZy9So1PxPcq?=
 =?us-ascii?Q?x3vWj89vf7d9TO4MDgMrjng/8DSgZNWFu4RLWDBpd4aFTxT7fJHg9dqsOlAg?=
 =?us-ascii?Q?/Rwr+rt7Xe/WPMex3B7rmwl+JT3mJpLKoq60tOhCGv826czHNCENetCQTxhL?=
 =?us-ascii?Q?B4W2SrPZw/E3fZxvtD/B+RlP5cqUF6PMtxC8nd1KjCyJPHmDEgfw9t85/lBN?=
 =?us-ascii?Q?zgZEPOJ5Pgc5HZam0JdDySDiDmLbU1dEz4sNbMVVrtfxbPR08/6SmXPVi7gq?=
 =?us-ascii?Q?XwH4bH2PB/IU0uZw6Brco4vrRx4ZfhGlLoBqz43G1b0sR/jxZDb+M0gqnTvP?=
 =?us-ascii?Q?DUPeFIN+3GJBOpiOBKabiQ9YjCxihIDG5xeGph65leriGSaoPCdo6UMNlUta?=
 =?us-ascii?Q?NmrrR1wXcPRXiK6dIO4YQrcl2kmWAHm568vqQMEftz8ONZaKoUg2PTVv4oJV?=
 =?us-ascii?Q?hvWHeXKdwVJ9vQb7nF9yYOTACZAOcHO3xLN1X5RfMHasWIuRVBisrC2McOsD?=
 =?us-ascii?Q?D8TuVeIHDDSitugSuJl/znQASgIwdeAjxDDfTfjZNRCjCTKfrHQz26CApsEc?=
 =?us-ascii?Q?ZfNn2bZWcK6teRetsSag4mTF9dQBX9h3nEpSPX4w5pMQK/gDV2T6R0osULRQ?=
 =?us-ascii?Q?bevFTz4vBBWWafN4fiyHgYGeL5HgNt68wayBqqvQnCukwCrsIyXOF5ZpSZLn?=
 =?us-ascii?Q?6NGc3UXW1mD90mj2BXDfgyOCE7fszII5Dj6NW39qEJO+efF2speeuSme7vp8?=
 =?us-ascii?Q?b9wawWjuEPjVLycbPti5QvT2fBV0I74MMkMShmX8lSal7EsQW0JPAxAoUGQq?=
 =?us-ascii?Q?BjbhyOjIMnXkubFVzfVHSraA/d/NLe7YrwbguOOmXva+4F5Rvx/1I/nOnla+?=
 =?us-ascii?Q?bSBWkxbantoE4uI+N+DbWM0TCaU+MIodbLZNCjXK6/0sishv9ah4n1wts9Fl?=
 =?us-ascii?Q?l8UC69XyidqawoWFHoK1KEfEg0574GdgsOG6WjQtl0g67Ye0OEWo1D+0UXCM?=
 =?us-ascii?Q?IFGFGJsO8l/pHdnzgdHK+6mX3bKU7s7GVAkq5g1WGhRrz9hMjN9WduH8zhSW?=
 =?us-ascii?Q?PHTsqfi+e6dlL4VRM8QEocbtkzii8AJIwL6hUiTDwGCM5ksUOzmN7HgddT4E?=
 =?us-ascii?Q?C/qYV7Myr1pQqOm5qmPyyGpP3M+ktnm1QKRDXeMpLhnu+jEKI4KCflzGN/3A?=
 =?us-ascii?Q?06tAFqaJ12o=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GrXSjQ7p+NKDDeXL4ei6dA9WL0IJyFR/Vrs2RjFBs774/I5xiYeR7naiprMY?=
 =?us-ascii?Q?VkNb7siXl86EdszhhdPTPkrcRiHNu2867mBJNFbzGxqw+xYXVETMoXQyLF8B?=
 =?us-ascii?Q?kdDTa4yMHDbqV0SyhHs9V0bQRBRHVihKfGRdO/AMGzC2VJ+7UrSVYHAAFZWR?=
 =?us-ascii?Q?7oehay2Pl8ikKnb1M275/f4GhNZ47eoXzR+lr9UsawfMUTbvUf8tv2wjp8wy?=
 =?us-ascii?Q?/5u4mzjkQJ26AYSM2bAZpY8/HLjyyuZAW+7TKvQciJMvoxKrYJjCQS+ocFBv?=
 =?us-ascii?Q?G9oHYhFOhx1Pc21Naoe6o7o+lBa+TMXcm1DeikudkKiJplEK36hobsJ7JCUI?=
 =?us-ascii?Q?XgSrTtzyWPu7iTrQblBfjjWuMTHJCDUm/33Y0Mx8NYzUex/tLcA1HaWEVpt9?=
 =?us-ascii?Q?9dqt+ll/4J31TJRr1yfxFI3Fq0GX7ECKfrJwwktVnNAHEu+f5JtESKxriAS4?=
 =?us-ascii?Q?8XtlBU2GHATgXVPuoQDjKbxXkiH0JpyJ6YtlpVGN757100ZJnJJns65EClsC?=
 =?us-ascii?Q?m9h9QSf+Sw7o3G6W0UZlnBWiej5o/4JYd2ztiI6KJZf/1jGNX25DhK9scT81?=
 =?us-ascii?Q?Eewl+xg7FQgrdfSCPYfofd3Oqy59dYCT317NRVRhJVMB2LQDOqj7CjfQBGIb?=
 =?us-ascii?Q?WESf9PW2Yh7W+lPe0dxZ8LVyGuraxBaLjNmZiBg1jDip6jag0HBPGWy3Eapn?=
 =?us-ascii?Q?rPbPbj2h/AqVBOBFe98CHyg/Py08tPtz0Scml+Cn7xfr9Fch/HJh/HrS3Yc6?=
 =?us-ascii?Q?dInHlA4T3LUOd5ygjfmz3V7UqclPQS3PpD7rV9XDVshr3vuiUsY7vHR0B/18?=
 =?us-ascii?Q?LHKi3cLP3z2CiLDX1txpSKYGeYAz14xIIOq3iShc8Zi+S1Kv3rubsYGERNm3?=
 =?us-ascii?Q?yd3kdUcuzmypTkhOTc2Pk8zKktaVI3Df0Jx+Heycx9V0539DH41J/M7l3hwz?=
 =?us-ascii?Q?XfPK4PTKycSMTP/d1HGBmiPEOO2PCZSJnQ2axNhb6NwrxNLKnMcSWWMAUQjI?=
 =?us-ascii?Q?hGU+M6oTPAE69UnBNFGdfnY6aJfnwWDMzwT0zVBK1KVarimaWrMepOTxvUet?=
 =?us-ascii?Q?bzk3eaH9feHHGL5kTyunA/FtZyGWqC5xEHJR3k+/tJqzLJtZuPspQJstFzox?=
 =?us-ascii?Q?2r2V/sWkvAt70j/SmUxiFD3WpySqvlQcDiK55gDL3xW9lrnuTvJPDKtZCsea?=
 =?us-ascii?Q?8LK/rZ/mFGany+29imk6sfpMYdO/iTDxKZ738aEbq4hxcjZgimaoDdLdeB+V?=
 =?us-ascii?Q?lGC3uRjgSSaXFPITYx3PvATZPSlG1hGSXvOUJxG8FCwZ2iAuS9FOoP0ujvqZ?=
 =?us-ascii?Q?HnmdFSXV/5hH0a/BNYy1OOrpDvpgHy8hu3K9Q4TihRLKl2O1OE72l4rxQQ/X?=
 =?us-ascii?Q?QC8GlWpbCz+fT0APqTX8K2Aoz7wTvlZ7sULQ0qn7i+tMLfaUtw6u4lffWp0r?=
 =?us-ascii?Q?X0Xq8DDRufAljm6K9m3vKI1JuJGCoJ7ze6CjMrMgaj5gUyaJTQZYNrDmt09o?=
 =?us-ascii?Q?aoB4Dsg4CbjsWkOS+mS6418BsqKfpk+EEolQsXnyTVPXrlqpeVgLin4ZFqV5?=
 =?us-ascii?Q?rqpTpLd+/qPLlhMHh6d8YryLTUQ+rDExGpRHORxJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d1c87ae-1521-45bf-501b-08ddc0cc98e2
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2025 22:45:12.9793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: grhfDQmNXYSJ8oQA6Mtnoq6a6Mr2bzcck6bQgL6iQL5BBZurpktuAvtzLWb1QwM+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7864

On Fri, Jul 11, 2025 at 12:01:49PM +0000, Shameerali Kolothum Thodi wrote:
> >  	minsz = offsetofend(struct vfio_device_bind_iommufd, out_devid);
> > 
> > -	if (copy_from_user(&bind, arg, minsz))
> > -		return -EFAULT;
> > +	ret = get_user(user_size, &arg->argsz);
> > +	if (ret)
> > +		return ret;
> > +	if (bind.argsz < minsz)
> 
> The above check should use user_size.

Woops for sure!

> With that fixed, I did a basic sanity testing with a latest Qemu(no BIND_FLAG_TOKEN flag),
> assigning a vf to a Guest. Seems to be OK.  No regression observed.
> 
> FWIW:
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>

Thanks for testing!

Jason

