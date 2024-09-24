Return-Path: <kvm+bounces-27384-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F8F99849DB
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 18:42:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A28991C235D9
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2024 16:42:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D3D41ABEB7;
	Tue, 24 Sep 2024 16:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="Wj9U1e5F"
X-Original-To: kvm@vger.kernel.org
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2051.outbound.protection.outlook.com [40.107.96.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A231AB6F6
	for <kvm@vger.kernel.org>; Tue, 24 Sep 2024 16:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.96.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727196119; cv=fail; b=nO493leQVSzmgu+04xIgwrCkUWQ+AP61xXS9sHIQemjmVXYRDURW89X/3Qz3VTXC/ss2SgTHtXmsGZia1kCXupZSvSA8kT35W+oOXt/SfJSeCNYcwH6f7zysxOms1Y/9I0lDJ/Vk+vFIC8bx3/Uvfw9vseGdS9uAreJEFtHyTZQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727196119; c=relaxed/simple;
	bh=sCS0FlXhzwBYTtMAf77YPwejbFryTPSjzJU5JH9i+K4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=MxMJ7QWezEaIVU/0ETzNWFB1cps8H2IYgRJcs8NC4TNxsKg2wlIn7H/o+Ke32jAtoC8EGDtp3n/u3Mpa9Pbfc7ue6pxf56Jz1IEyiDPOVSxTZXVpC38RvLqxL7a4gTGoqHHhu3AqVCxfFTGlhdtt+MkP1ozVn8hDf1djWrjAlFc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=Wj9U1e5F; arc=fail smtp.client-ip=40.107.96.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u1FIsGrTOCk58+5SlQy3S99DCMawUhElrgrbP46MLQ5RpHD2jK5hoXwJtQetmPf24XWDNK6EvlfihLLvK9uByy2L/Or8bNn+ErKJeMJxsXhlNqVyskUWk83XjFq2xX+DNaN7ONcelXtE6bTYOA7UTty8fIJJn905ONHj0zwjx2HvNPUmW6Dx93kJeUtw0cLwQDTCD0fJjauAvrY65elWLMfqCSTJS+Fq1m99Ns0gz/QLV6JJwfXvp9VGrMsNCv+ePG6vXjXb6D2iHZy08WQ90Dv5R9B9WV1zKmdbI4526qlkssxShIbASHJcpLjPtQu5l0s9IaLVufdto9T+B5ku3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4X4NXFLDFBRIGmcqSFAq/c+XH3o35limhligv9qa8xY=;
 b=pH9jM3kNhL2++w340PJSMMmpv7jRq4k+bbiuHjuMkmQT9LD5TMQ/rss3Vc3fsIBiC0S+wy6VHdBnJ8QSxMeUFMbwK4a6/y97reHBR2lgtuVVQ0zs7fb808iyRaC+bneN2NmmhSWBs2IPNamW0IHbi8TbLtGQ532oi7O7+kZa5UA9s5n8h04nlXoDS3jko1BTbgQAjaBsbMRIR1oYbL3+vrjA17utsneHZZVQcTLY6icoAPZvu1A8uGc32TL5xOtmuAEUxRbEFHTZQp57mGIlfhSri9Gxqrcw+Tysy2142uZPdE1LYixxTvUHHlbxuMN9x9xaEuGpAYFk4ZnQnpzwVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4X4NXFLDFBRIGmcqSFAq/c+XH3o35limhligv9qa8xY=;
 b=Wj9U1e5FEFWsLnpR84zNop61lNTnboDpmt6zx6T+w/aFuTvo102Yh6rSXEIxpL0tM3C+jLxBUupJ0FrAUQWjmtBLgQtvKZ5K9FxbnpVlqgMnA2YTpgn+0UQXPpYd2D5IkskWBM2aFaxSdqKXE5iAZxr6TAv3aRY5Yl6bnRPsdDpXAhJUPqIsotDHWD9qxPfOZSRA9569olCuoXQCV7X54JJITvIf0j7jGMcUnB/DpX1gnjSlF6So23DzDGsFwVSYD0lIfRvZdEqpkPg4ZpB7y7m00xi4oMA5XNR0jmFImM0H7nze5eVHSg3ZGkFhian/xcce3T2lv2fb0Y9TwqasZw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by DM4PR12MB5818.namprd12.prod.outlook.com (2603:10b6:8:62::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.25; Tue, 24 Sep
 2024 16:41:53 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.7982.022; Tue, 24 Sep 2024
 16:41:53 +0000
Date: Tue, 24 Sep 2024 13:41:51 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Danilo Krummrich <dakr@kernel.org>
Cc: Zhi Wang <zhiw@nvidia.com>, kvm@vger.kernel.org,
	nouveau@lists.freedesktop.org, alex.williamson@redhat.com,
	kevin.tian@intel.com, airlied@gmail.com, daniel@ffwll.ch,
	acurrid@nvidia.com, cjia@nvidia.com, smitra@nvidia.com,
	ankita@nvidia.com, aniketa@nvidia.com, kwankhede@nvidia.com,
	targupta@nvidia.com, zhiwang@kernel.org
Subject: Re: [RFC 00/29] Introduce NVIDIA GPU Virtualization (vGPU) Support
Message-ID: <20240924164151.GJ9417@nvidia.com>
References: <20240922124951.1946072-1-zhiw@nvidia.com>
 <ZvErg51xH32b8iW6@pollux>
 <20240923150140.GB9417@nvidia.com>
 <ZvHwzzp2F71W8TAs@pollux.localdomain>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZvHwzzp2F71W8TAs@pollux.localdomain>
X-ClientProxiedBy: MN2PR06CA0006.namprd06.prod.outlook.com
 (2603:10b6:208:23d::11) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|DM4PR12MB5818:EE_
X-MS-Office365-Filtering-Correlation-Id: c5f082a5-9b5d-4220-18f3-08dcdcb7cb5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WTceFln66tr1Ur6L0zISxfLhUQsfqhJ55KSIAOKBVLhqT3Z3mNHbX2c/EiUQ?=
 =?us-ascii?Q?oHm25OfGY64Nb4UKBKLtoYkW3EGIgRowlWJe69w0FyxL6da+fq6CVWSO47fP?=
 =?us-ascii?Q?iBP/p7iW/QnuqECwiKTYlP2el4BAzED8RIuzHI60wObOy73mL8YhYp6R2YRe?=
 =?us-ascii?Q?+LN8X2I6mrr+ypRhqWW3apV6cJP0f6t+cElS/wK+CSulgn4C3EvJSUpp/6HS?=
 =?us-ascii?Q?tjytdG1Yh7RcHU/vkBowTtq7NlgRr1imFMy7U+swphoA5qJgchoJS6RGPFMY?=
 =?us-ascii?Q?xxOlwitXIIg8DAiIC9Rf4uKVplJhEnRFPW9+W2uEz3fZso5cVrsqf6QAc23H?=
 =?us-ascii?Q?beEy6erXINvM5tt1UlJszgLcnuMV/RSDTOirYj/zJmfJQRHeZnJVRk45FXxu?=
 =?us-ascii?Q?7boEpSg+vxI1beFRyjfY0aYL5bVCFV8xKrA4n4FC0UqTNFP4lzwHZW7bOfNc?=
 =?us-ascii?Q?IP6xLKNgmxLl9imeiPSk2GkVCF1gK8QkANAtZXV0AmndI4Ea+MGytKkL0JNg?=
 =?us-ascii?Q?BbxUne8vN0Z8niekXhpO6U2hKgAmiDziIxUzJnATJ7HAkVxt5Z0il4ecW+f8?=
 =?us-ascii?Q?jiZUyWWKTzhuS0qLsM1o1PtSifnqQm2HqNfKPlqjX+Lqe2sajaG9/uLdUuZm?=
 =?us-ascii?Q?TmcXdFwSiwa9EIDUc91WrKdoL1aF0Akv9PTtrYm/bHJvudbFXoRV3lNohQ6t?=
 =?us-ascii?Q?XK3MPd+8qskexw3AdwNZFcmRCXaz7XNMGSiee3BqNN7zZtHbYpYLFksMylO3?=
 =?us-ascii?Q?7Oa3FRG9TYG5JLEgTaLlPijIk7JSXOJOKjJtoU76IJiz0slgCq7ouE52q9B6?=
 =?us-ascii?Q?33Cx9RDjhbwRrBCtfqvGSHPg+2Lzh5b1XpK1XGNen6jwnXbubjDnw/sOpi39?=
 =?us-ascii?Q?nbp5S3IlmHLI1bvShL0laD207KeT499pFZkBGk5d4EiQHKMuvus7a1+lvESt?=
 =?us-ascii?Q?EQ2PwpRK/hZ+sClcNdn+BC11bQcg0yMC7WFVKQkFyknXTOR7eCUNiCkrKCLj?=
 =?us-ascii?Q?hisNUVLpyD1TQ8msjDPaWnJWvoNEUkCQD1sSuDueHQhqh4Bp+BewbPscZFr7?=
 =?us-ascii?Q?VY9haQSu7+fIP9bejpkXLueO/qTC/dF30Ia7d5TYag6B1jgiFNAyjkQEG/Lq?=
 =?us-ascii?Q?3Mtormq4yEW7B2t+tzDRx/NsGTpQ9VPu9gAzLevDKFXKofB07141lFc+xt6S?=
 =?us-ascii?Q?w3SdI7zwuYHyH+pOvv7NVRN3xx+aPSIVW3qFaCVyqcaMkb2S9aTshxEGgP0R?=
 =?us-ascii?Q?qPBk6c8XcPkKB8Sq19/d7nuXs0urcfEs7Eq01TtON7dGao9HtUzXhEcdJAU6?=
 =?us-ascii?Q?vv/NoLelVkCtKTnQ14dENJXHGNVdrPudWMizq8magMydIw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Pmlqy5a3ps/n2APmtUTOV2pNZoDP3ooY+NNPsTQtVL2zG1k5kHRRAAMUG/Qj?=
 =?us-ascii?Q?JH5PKJxUXDj3cJIreYYQ1KUmA0Sp7+y+X0lUkPyhuvufnbup3pym/DFFGi32?=
 =?us-ascii?Q?VUz++C7FMsyvrXc02yabzmPBtvTwB9IDo+IuKaDxlnksXydaI6DORpqmmigQ?=
 =?us-ascii?Q?ZpDyOoTFgschLHdP3tWyUINC8yvsJdZA0P7z7vVJKsrQ3ixM2Kxzabp7STRx?=
 =?us-ascii?Q?evaSnHp7AEAAhGmsln7Xcm9ZFEWg+MRwUQQTmh0ZKbVIN5JnHDIUY/0HAmcI?=
 =?us-ascii?Q?S0138nOaCOrjevlLxJqRIAZgn8oO+M+YK4/gSsTfpLVfajX4HIJfXIWIlUJ/?=
 =?us-ascii?Q?Ic3/yznhiqv/SSEkVZD8UP89fI9tdac/jGrQstkBuC93AAFMV+6MmpcMYX0J?=
 =?us-ascii?Q?i+3X8SlsanTc1JGahJk3M5tXbYIdAFhhUUNPe82EJx0rfTAUzqYYkN5rdUNv?=
 =?us-ascii?Q?1EXGoYBrcJCSFKFj3AwkAjXdsRpuHHWF/Om/TDmbZirA6tI1IfKx10Jp8JI9?=
 =?us-ascii?Q?4bRdnod0CEnhrUKw3FkKdx2O5owyauEXc+aMtSZYq32DINwlmgV3CWvWnqL7?=
 =?us-ascii?Q?VtX9LXntr4jaQdkXkvhkbBouESTw4yKdpbotVER/DmB74tcvfn6+kIlS3lID?=
 =?us-ascii?Q?nyYCAflo6ZLWTilIxIukGnAPVxcoFw0hHlETo/xqyQPewXjb0fO00OlS5BFa?=
 =?us-ascii?Q?8l9FFCrxHPKRkKNgi6rRxtUobyNjIKdg0cPl/CdNoYGPYbvKuwx+RCaeDBLJ?=
 =?us-ascii?Q?lv7A4FHFozen/MAopJht7Z3smhhZWtC7VeDdpwj7AkdcXT59UN9cVkIjVJtq?=
 =?us-ascii?Q?onhW37RiAO9NJcxkdjvThtKiAVj4VQuRopPBtcU/NE2I5XCzspDAIddvIdXr?=
 =?us-ascii?Q?+NDqbOUsPsesNjqIHJuQKUhpVGaSJnKTWZ4J2SRIoYEtHvHnT3zeyr55zy3G?=
 =?us-ascii?Q?Om4Y5HLItWKjzf2pEFHqhzZ9UrOAlVexm0UEYesKS+V6IRYHgjfalTMwNncc?=
 =?us-ascii?Q?PFm4ueY6Hik+8FAbV31GhwO+lLXXxdaSH6sgrsv9f/TtWX4NCNS6jCNO7auL?=
 =?us-ascii?Q?PTRTHBL2OxAM1VJGNWse7fxtaEotB8fPcyYqlGKKvCASHwxymX2pOm88+BB3?=
 =?us-ascii?Q?Sagdx3DIzFH/fESUFEpxC8tj43b5rJUrIeO1rlLLG9IFDKjcdbJFZQ1gfzfL?=
 =?us-ascii?Q?eHU0N9Y8OzA1FRiX+hZLdDk3BEqruodY0UW+z/r2e3MPS0UzA/8PmmyBsSD2?=
 =?us-ascii?Q?QMs+PsBiUwpmi1mBB/Lq7OOeJdXO1iszE4XQpbLoDNeWapioei5qkhB6w6jl?=
 =?us-ascii?Q?VlQqIbWKRvnb1hvqaQk1qDKwmBMzun8bFyfloIiR8KhghAEM0HvU08Oda9Hi?=
 =?us-ascii?Q?6WX9sBTk/cbb65EsJyoR8kGe4g8hDfQLcVQTQXhuTv4N7qmK5GF7yiJ3HFSq?=
 =?us-ascii?Q?Ni28fOeZcLUvgqP5JXUo9QXxH7NvyvZVi2r/LmKQie+TJ5k2VmH4xoV21UC4?=
 =?us-ascii?Q?b+jSGAlIr6O57Jdhak09QosylUeG8xncaI9x77/CUTGLfNHAUSPwX8sC//yW?=
 =?us-ascii?Q?Y7M09xvfjT/gt4zni18=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5f082a5-9b5d-4220-18f3-08dcdcb7cb5e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2024 16:41:53.0703
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: egadkeR5QZHhFwTlV/6b0EXk2ytKLvjcj4gLFTMPSUT6wxBvm+fqSab3PKvaGXjG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5818

On Tue, Sep 24, 2024 at 12:50:55AM +0200, Danilo Krummrich wrote:

> > From the VFIO side I would like to see something like this merged in
> > nearish future as it would bring a previously out of tree approach to
> > be fully intree using our modern infrastructure. This is a big win for
> > the VFIO world.
> > 
> > As a commercial product this will be backported extensively to many
> > old kernels and that is harder/impossible if it isn't exclusively in
> > C. So, I think nova needs to co-exist in some way.
> 
> We'll surely not support two drivers for the same thing in the long term,
> neither does it make sense, nor is it sustainable.

What is being done here is the normal correct kernel thing to
do. Refactor the shared core code into a module and stick higher level
stuff on top of it. Ideally Nova/Nouveau would exist as peers
implementing DRM subsystem on this shared core infrastructure. We've
done this sort of thing before in other places in the kernel. It has
been proven to work well.

So, I'm not sure why you think there should be two drivers in the long
term? Do you have some technical reason why Nova can't fit into this
modular architecture?

Regardless, assuming Nova will eventually propose merging duplicated
bootup code then I suggest it should be able to fully replace the C
code with a kconfig switch and provide C compatible interfaces for
VFIO. When Rust is sufficiently mature we can consider a deprecation
schedule for the C version.

I agree duplication doesn't make sense, but if it is essential to make
everyone happy then we should do it to accommodate the ongoing Rust
experiment.

> We have a lot of good reasons why we decided to move forward with Nova as a
> successor of Nouveau for GSP-based GPUs in the long term -- I also just held a
> talk about this at LPC.

I know, but this series is adding a VFIO driver to the kernel, and a
complete Nova driver doesn't even exist yet. It is fine to think about
future plans, but let's not get too far ahead of ourselves here..

> For the short/mid term I think it may be reasonable to start with
> Nouveau, but this must be based on some agreements, for instance:
> 
> - take responsibility, e.g. commitment to help with maintainance with some of
>   NVKM / NVIDIA GPU core (or whatever we want to call it) within Nouveau

I fully expect NVIDIA teams to own this core driver and VFIO parts. I
see there are no changes to the MAINTAINERs file in this RFC, that
will need to be corrected.

> - commitment to help with Nova in general and, once applicable, move the vGPU
>   parts over to Nova

I think you will get help with Nova based on its own merit, but I
don't like where you are going with this. Linus has had negative
things to say about this sort of cross-linking and I agree with
him. We should not be trying to extract unrelated promises on Nova as
a condition for progressing a VFIO series. :\

> But I think the very last one naturally happens if we stop further support for
> new HW in Nouveau at some point.

I expect the core code would continue to support new HW going forward
to support the VFIO driver, even if nouveau doesn't use it, until Rust
reaches some full ecosystem readyness for the server space.

There are going to be a lot of users of this code, let's not rush to
harm them please.

Fortunately there is no use case for DRM and VFIO to coexist in a
hypervisor, so this does not turn into a such a technical problem like
most other dual-driver situations.

Jason

