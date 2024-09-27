Return-Path: <kvm+bounces-27617-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CBBA8988580
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 14:51:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4EEE11F21AEE
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2024 12:51:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5D0418C923;
	Fri, 27 Sep 2024 12:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Q1Je7z1h"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2048.outbound.protection.outlook.com [40.107.220.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C2418BC04
	for <kvm@vger.kernel.org>; Fri, 27 Sep 2024 12:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727441482; cv=fail; b=TQb8AyBaoSOGOvTTH2tu00fKcoemrjqyg2qapX9fhiVD0eJEvBFwi6GupTI9Sx01W4sT1weFyEuaZg02IE3xii3ySMH62t+OCQ62z3lGtnZJU2Nn/1I+WyTj8cEUOWp+/5OaxoqoDDDDvPurcaS9KlbvTCD/Tp8ldH2aXXb/tlo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727441482; c=relaxed/simple;
	bh=Om4ki36K3azFoY0HUQ0hoyVJ/5BhCYfXfLZgC8wX6Lc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=C7Z+kBWU/L4DdJJK9i8mmJ3wljGeK7SHsd3gxoUYDXNdND809Yy01291xVvSuw82uJJOs73GpGGjVCES8fDl0G5BbX0sW6GlYc6KSqwFbNT2xJWGvQ9gS4poKKjfl/0LmduosXJmiE8VAlOH8kg8jNtbn54bl+3uYTKgjYLpQT8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Q1Je7z1h; arc=fail smtp.client-ip=40.107.220.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y7dDrZjBuj7RIa6pl0BLZopH5BklcJeFMjlPl4SjVLLWsdCpZUDULfA2wcNw5LhKPV/Cf6hH8u3mRwMxqEiXzueJhn5KXFrkJNJTF/z3qSyTLeloLCU7KMuAiJswBAeAZW0wamLVVYnTCPcufopViZB/c0okGEJhTAOI+rmPLIHpzF88oCwyPwJdE+RcfKMcV/BeWnDHzKaFAw6HsTLyg2ysUccsl1vqJqhuvpP3ebYctsnaq4mhtpPUeYvn+531GvgxU4gY4AAy5EUOgmZHznnfS2otcJUE7x0w5p8Tk9RFlD0Kc8YpM60pjp7BNfnKibCffp0e6baxGre3xYeuoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tp0ft1zjl5rtiOdo6oiDZdTrRWk7QIF2A93xTc4a2co=;
 b=FWKZcYK/tEDW0nSNl2e74AhBe7d+CDJejrDdxMOpecDa2G64lVL3ED+cqDP0QRoOca0jhf+tNX0xi6l5sOviwgnnBkrHJf7EOJxuPh1xIRB9r+kL1oqKdNZklMKpyLctk59gw93qXuY99jwcUshl3FIlWElOv4SAJ4t4TkL8xpI6k1YOsUa57E+4q6mj1b3z2T7ZLLbtFoRwKb9YrD/cuycdjmJrCtKrdOc37iLy7thaWYkvquhIRyzr5FGH9Dv3G7uSdrkhWvT4l/T7hxrBOKQpXWJImB0sPe86/RIubGtjZ6wyDLwiZYlH7yIk9awttnaB1OYlt8ayNM8xvNrHgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tp0ft1zjl5rtiOdo6oiDZdTrRWk7QIF2A93xTc4a2co=;
 b=Q1Je7z1h4+TFu2yyhgZogz1PpsXz0Hju9scvs8GQP3bYf9INuZmo0PySkkDvsNmYe4MhLfaI8zTjkAOHINh9lw1T56mCYrqIZTF+FtsIG2A6RzuLLHT8MdEOa/TSyONe97iuwD0Wb+ZqUahFBUJn9B7aKo7jghJ2FSW4N9TCDmBne1apbQPgg4QIvaVBrvrmnlyt0mrnaEm0Eh6tS5CgvpRH7CQIhsgihu6V96P11rEfaS5HE9XBFuGxIS/bJVZHH8o9xysXR9WE+akjbRFgU14PY4hTYG1TKYmk4Jpsg+F10pHckX3B8gW3hIUFka5e5SxdaGHcghprEyP37vwzhg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by MN0PR12MB5907.namprd12.prod.outlook.com (2603:10b6:208:37b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8005.21; Fri, 27 Sep
 2024 12:51:17 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.7982.022; Fri, 27 Sep 2024
 12:51:16 +0000
Date: Fri, 27 Sep 2024 09:51:15 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Danilo Krummrich <dakr@kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Zhi Wang <zhiw@nvidia.com>,
	kvm@vger.kernel.org, nouveau@lists.freedesktop.org,
	alex.williamson@redhat.com, kevin.tian@intel.com, airlied@gmail.com,
	daniel@ffwll.ch, acurrid@nvidia.com, cjia@nvidia.com,
	smitra@nvidia.com, ankita@nvidia.com, aniketa@nvidia.com,
	kwankhede@nvidia.com, targupta@nvidia.com, zhiwang@kernel.org
Subject: Re: [RFC 00/29] Introduce NVIDIA GPU Virtualization (vGPU) Support
Message-ID: <20240927125115.GZ9417@nvidia.com>
References: <20240922124951.1946072-1-zhiw@nvidia.com>
 <ZvErg51xH32b8iW6@pollux>
 <20240923150140.GB9417@nvidia.com>
 <2024092614-fossil-bagful-1d59@gregkh>
 <20240926124239.GX9417@nvidia.com>
 <2024092619-unglazed-actress-0a0f@gregkh>
 <20240926144057.GZ9417@nvidia.com>
 <ZvXjcPOCVUSlALZZ@pollux.localdomain>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZvXjcPOCVUSlALZZ@pollux.localdomain>
X-ClientProxiedBy: BN9PR03CA0663.namprd03.prod.outlook.com
 (2603:10b6:408:10e::8) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|MN0PR12MB5907:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a530bed-074d-4ed8-7f99-08dcdef3137b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OdugAt0Gu3JS5JTIFCc6idu1u3pm+ZxRr/Uw5nrOHRmuMWEMS9PfE2b86MDk?=
 =?us-ascii?Q?tKlVuCu0jxuyL4jFmG9tKIY4CluQqxBLk54bHMxsut8e7/JJ/OEUpCIrfKqp?=
 =?us-ascii?Q?O5FSmValddiZFYkbU6M5Kfd0hTums/Fj+OH2AjP/Jn7TWnz+R7dDfrpdmteE?=
 =?us-ascii?Q?F/yWTRAwmYKdOc28C/2vLk57K52rLqp+Qvwtpq8vkQrUiEm45HOfYLOPgTXU?=
 =?us-ascii?Q?iV5bVvwGMp3DYIAXpV+oX94Aa5o5Q6a9T+k6/tK2HgP88DrHhq9FfC7ONR2l?=
 =?us-ascii?Q?uCzuPHVVPvfQSItEgJD0l4n+l3fAn/lgiuYyo8ESbmxgYYx5KuNAbUfjEy8x?=
 =?us-ascii?Q?GB8481XXf/RZ+laifKjU9MhJiHC9eyP3g2bz8sckLQSR1e+MjGj5czULXvsj?=
 =?us-ascii?Q?QTLhkif8WkpZ1HnJvEyE3a2z2vnFyHO9tfcLzFvWAiNVhkRa0a6jE3wgitNQ?=
 =?us-ascii?Q?Z9IozJUr7cksNMqaBMW5YwrH7kGrtnU4T2I5C5YuA8w7nVgv1Ax9fSiql1ur?=
 =?us-ascii?Q?VBZi5Auq6XIWtaP0lDeaoo3h2zTX0Qot3NPAUPV+d/PCZDPHFzfyu/nqOD4I?=
 =?us-ascii?Q?1mk97W06kM2ydXmqhNLEdfCYQs2N4JvsTG3TvA8ef2zfM0XREPIYiyZuDzos?=
 =?us-ascii?Q?daAbSbTaSha8jH5LRcrYt6MrneT55EmKnbJPtYMrYDyuwtrm5A2RNJtIbyxf?=
 =?us-ascii?Q?32H/3LXHTR/vQgLTSIZjXq9pUo+d0U0hVZueV3t+06O+OmS08MmCb3g0EE03?=
 =?us-ascii?Q?/joPM+tP4HpqkXscNt5/fr6D+EMzmUmHWTJ7wiRsy8LohZ+a8ZZ+cujw/3mh?=
 =?us-ascii?Q?8hjtlfReGbSFogEOnXC/5Y9v8j5PzEk/Qs2O5S6Yc+9yardmQ62Lb3aw3+cF?=
 =?us-ascii?Q?s+ndIA5j2sWR1aDHcyesycZ5r7U4HikZEcHdUIrVlldTitFPEyVXRSQES7Kw?=
 =?us-ascii?Q?AR7AC+DSVFG4uSHxkfiEhczHCUVSh0TVFIKOxVMe3D3JN6ZpQS3UERw2hHgF?=
 =?us-ascii?Q?lTZ8fBnI+h0I+m+ZVlv3b7YuJ6PlVE8mUvDxTRAWM9HsQ8rvEzk+rj5DjoxB?=
 =?us-ascii?Q?0lTjAVIt9cQdRguTtC1ex9NawuvEzF7vLfxy1EWk2R6iFzLKsfVwYEEMB85A?=
 =?us-ascii?Q?MS4R8JUlhJsOExr+tlSP1MLSDhntGv9H8lcVyN6J+qtM+kr4ywuBrNNC9pHV?=
 =?us-ascii?Q?h45adk4oWRW7T/23eYWUtSQhdC2iEPsPbgtxH/egFjag9wrAuU4owfMYrLVb?=
 =?us-ascii?Q?b3dQ29yaj2w8BeyIue8Dg8DAfT+5EJZvuHZGYvV+0/OEjJoYElCNc3U5VrQ0?=
 =?us-ascii?Q?rleVExsjgt9s3/g7whJjLbYpIP6MWl+qE9683Rd5Ba6X2Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7k9pJXKey+1F/S8SMS0cu8hEyzWT5hz0FHQEPkU1udD55FZKcw54Lcy7urye?=
 =?us-ascii?Q?L+lC/C1ItWxgFuyKzPNjoHkS/wE9PywljpboKjgRg8PStczra+Dx4/IOk6Vk?=
 =?us-ascii?Q?wfNwBqLY8lkhalNt2mxFLjsw0u0TYrjOHHrMh1xWADeioSYXe+Qe2gdq4rPv?=
 =?us-ascii?Q?WCSLuHKV7K18K46DS/M+RZruAIqsow9u4DoZYqiAl5vR+aO9I3qMdI9QUB6B?=
 =?us-ascii?Q?ooqHSlYbc4BiSkb2+inkyZx9FxQsM4g+CzjOcK2nml+cOfGyoIQMrrJbdvH4?=
 =?us-ascii?Q?h7MzgF8lTqfAQ6nFiFsj2klMlmZg/TrpfrwxKPetY1FtR3VD9xBKC3rhshLv?=
 =?us-ascii?Q?cHOV6qK0yCs08f6j7ylAFidMgpOzuF8bthVTzpEbe6NynBNsvAmCzhzuvKWB?=
 =?us-ascii?Q?oQO4qc8jkunsioL0a+U0m8fMG0dOgJfx2aK2MiZvc25HK3XLVcPvNUEMZ634?=
 =?us-ascii?Q?NnzSGKjaxH0xxan0MTnKnGmEWW46Ybt5J3k5uFIKOVTokFzyUUXwsVlz6TPd?=
 =?us-ascii?Q?ny141Cq7ei7PuvVeSJ4lfwSq7s9nLYjOsF5zIVIqk4b5XmiCTJXtshdYmIjd?=
 =?us-ascii?Q?zO5r0y0HF2C/NBGrwu2dQnUmjG3MB8fxZET8/eQH/aaNzsskfOAcaydgiH+d?=
 =?us-ascii?Q?riIcBYlYJ5DUc+WNlBuPPw5EdGrwdUEO1rqAMvUba/HB9ThMpXLq/pgeIVQC?=
 =?us-ascii?Q?jm0CijLO5VgKw3ZJpEZG8So2bfNy4uKuycf2EHiYgV0mNbGc0sdlvKTeUN3r?=
 =?us-ascii?Q?UXyOrGaKX4DLA/Eu61ua6BqncvLySjonbKnR6r4vbfDydULFUkIWuTlhZCBT?=
 =?us-ascii?Q?qeMpirWEta60Ia3w23P4xRZ3ZEj8Z6DcCFIEoHVMCWwbJ6kusKUBzz8gRFhQ?=
 =?us-ascii?Q?12r43WnYQdnXttHGmDjoN1iQIhP0eTrkDZsAcQ/bMRGKdLVRbnud3Tz5TfXh?=
 =?us-ascii?Q?2O6PbXLRwZ96FdCN9rIOPfazXWvGA7pHMYdSlPCYJXuax/cBZ8jv/2jNcqWZ?=
 =?us-ascii?Q?eaAC9g696SICoCWJ7jHBqBiZVU5O6X/Nt1uduzuFoNPlUXjwFi72yV3f5zKb?=
 =?us-ascii?Q?huHgCbWAlXVzd878HTK4yFnaCGJ9TfTPEgbcN7U820Of0qfMa2Cfp/BNUwmr?=
 =?us-ascii?Q?yYO1KS6r9M8ZZjaO2M+zUDct+qoLp4Ia6hjAtoucx7Nb4Cb5AB9hLNCAdE5E?=
 =?us-ascii?Q?tbyCy74rckiGhzFN9mn0NSqk0pewo2JkNpINb3IL3bDHP11TwxUQJigsDCrf?=
 =?us-ascii?Q?phuiy88JJBDRT8ueLwPZTZ4Ny6LKCd50EVOEAki6B/3ahbgCPuWATI/k1/P6?=
 =?us-ascii?Q?pe5w+qjaSOKvEbqVMYb4IvBP7T/q5pFkKnhnnpae1V/2GBDnn2vTlzSaJTSd?=
 =?us-ascii?Q?uCAxQ7zemjtUXJqw5F0cF9JJm9k6e+rYVtnrW5jnWf9kgM/6uOI3IPzs3524?=
 =?us-ascii?Q?ngVlw6NElhIHvlVUlWwX2+NoTV8AwQJsavEk55RILyz4+qSkkURe/cbtJkze?=
 =?us-ascii?Q?umBTxYHMnaDr2DtdzIQooAlRGmCDad04kZMzuCVFvD+Q6EQy0tNQmvdZeCvv?=
 =?us-ascii?Q?gwKdLLljTOFBYD7cLqA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a530bed-074d-4ed8-7f99-08dcdef3137b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2024 12:51:16.7151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: feRfTxILXIANOtXizwjDngzIAwP11a0DoBwkG8eJk+eXKWrqVzAVjvdX0ctagOcT
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5907

On Fri, Sep 27, 2024 at 12:42:56AM +0200, Danilo Krummrich wrote:
> On Thu, Sep 26, 2024 at 11:40:57AM -0300, Jason Gunthorpe wrote:
> > On Thu, Sep 26, 2024 at 02:54:38PM +0200, Greg KH wrote:
> > > 
> > > No, I do object to "we are ignoring the driver being proposed by the
> > > developers involved for this hardware by adding to the old one instead"
> > > which it seems like is happening here.
> > 
> > That is too harsh. We've consistently taken a community position that
> > OOT stuff doesn't matter, and yes that includes OOT stuff that people
> > we trust and respect are working on. Until it is ready for submission,
> > and ideally merged, it is an unknown quantity. Good well meaning
> > people routinely drop their projects, good projects run into
> > unexpected roadblocks, and life happens.
> 
> That's not the point -- at least it never was my point.
> 
> Upstream has set a strategy, and it's totally fine to raise concerns, discuss
> them, look for solutions, draw conclusions and do adjustments where needed.

We don't really do strategy in the kernel. This language is a bit
off putting. Linux runs on community consensus and if any strategy
exists it is reflected by the code actually merged.

When you say things like this it comes across as though you are
implying there are two tiers to the community. Ie those that set the
strategy and those that don't.

> But, we have to agree on a long term strategy and work towards the corresponding
> goals *together*.

I think we went over all the options already. IMHO the right one is
for nova and vfio to share some kind of core driver. The choice of
Rust for nova complicates planning this, but it doesn't mean anyone is
saying no to it.

My main point is when this switches from VFIO on nouveau to VFIO on
Nova is something that needs to be a mutual decision with the VFIO
side and user community as well.

> So, when you say things like "go do Nova, have fun", it really just sounds like
> as if you just want to do your own thing and ignore the existing upstream
> strategy instead of collaborate and shape it.

I am saying I have no interest in interfering with your
project. Really, I read your responses as though you feel Nova is
under attack and I'm trying hard to say that is not at all my
intention.

Jason

