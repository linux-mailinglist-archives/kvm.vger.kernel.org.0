Return-Path: <kvm+bounces-27397-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E2472984F9F
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 02:53:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 10EE01C22B8F
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 00:53:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80F22139CE2;
	Wed, 25 Sep 2024 00:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="V2Q8Yyw8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2062.outbound.protection.outlook.com [40.107.94.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E052C13210D
	for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 00:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727225604; cv=fail; b=rtF8rTDn9cCjXaWYBavlMfcgUXW4LMyxZsoneJXAP+mMEtX6jV6w9fwQna7d8hFZWceKrb2RwKFVpdblU8sfYNTCcqMNlQfgsSsf6tFtC77tgn6r3W47UMyBhEtdvRuoz6lk5DDIG8gMuIEkOOh1Ktc5+/TyKnqBpEjvthiHDsQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727225604; c=relaxed/simple;
	bh=jcWw6HuuUzDoGSc9XTCEiCJNw/J4QaW+cqg5L9RgO3Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pDdiXAGSi7ONz+e++l+uYZV4KT2+LYCzFWNSgyak30ZP0A+FHO9wQN/zXQREmHqBPp7TfPS7hYIX1WGoasxeQvhRduO1B5Mo5IVjT1KstNE9nJn5bms9J+z/UaeZy2naNQ4YU/Gc4cToMQ/6wANjK8G+ilrN2Wz13T82/X5hox8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=V2Q8Yyw8; arc=fail smtp.client-ip=40.107.94.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Om2qevxCwnL87/QiGfqOX7BakmT8PXlPmfQLlrxYcBYqg6z5YSXZYt/5r6LyFnjF8OVGREDalCod04QZkfkQsnw3ZzDMH7OjLDPG2XowtihBeyP+hYhTaQ3RR2vduigGO8adz6txJfGfIJTZLU1O4fAzNsUaa0bmhTFR0DP4pfh6GPn5/NVbE3vqSOsXhhdMNpM8O4r2m6xpNXsMp+a/aWMwG+6pSK/kIhz6HL071eCNSUgkqE5JygjQItDYE7p/7fNs65/okL6PD7YE1wvSJCbjc6CBSGlnm5CmawrhRVUM4sVu+HLyWNMq2j/oTULNmpcBk2tH5GdmFjR7ZxovUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IXj37nLnS+1+mAu7zgZlBfr699VUmKyOjbpVXUI0fhA=;
 b=TZuyfOf7ajiH+juQJktSVEHM42SvFnIFWtVzltNCUkMiyyagQCSMpt54MOMYQ6dD1VrL9+u/FrHtVuHjSczMRMZ7ZS8FckGf/64q3NlRxn9CMB9bwIQps/SF/nsPhThEv2BVS7PMzwunRHDatFUR/0z/eVYrukM4wVl1H9gSs5inT3a40PAfvezzXfQRDEXVi6seenj+wylP+1d8bhF9lvsKkJB2gKZzgmb56NI6qUnxNuRybGc3DxotKjkGyxyBJVII4tllGpw7VECKXGX/BWZP07Z2NofIEJy8Wfru2Dcnbl5+2ic3GhqOx3DbOZkRR5V03aeJxj9M86ydgLTc7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IXj37nLnS+1+mAu7zgZlBfr699VUmKyOjbpVXUI0fhA=;
 b=V2Q8Yyw8KIiWV0YspjmcFaVx8KdkiQESj+mHsMpf0u3GG6db05n/haBnjCEVmzY0rKxsDYdYFBLe89AEk7iWyWnoTjZTMpReazUK4qCurR3s2JL8D4ZQaznd8lIqdDdONKxXsSQ4XluwWQCH3bK/1fpLNjT5UcG61CiUcceIoR4i/GqQlME8RhWKUsvUac6SeXyAlF1ZLmtiY/4VTS+SWogEUvIybhGQ378h2hlIglT/k1OVTwjD/Apz3x4NoohUWO25Y785p0K5ou1HIhyVMObtmU0/I9cldBcJ9y4zb53H4WQ2e2whUMx3sihxHG3QC77dJsCs7nilTUcG9zrDxQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH3PR12MB8659.namprd12.prod.outlook.com (2603:10b6:610:17c::13)
 by SN7PR12MB8129.namprd12.prod.outlook.com (2603:10b6:806:323::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7982.27; Wed, 25 Sep
 2024 00:53:20 +0000
Received: from CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732]) by CH3PR12MB8659.namprd12.prod.outlook.com
 ([fe80::6eb6:7d37:7b4b:1732%4]) with mapi id 15.20.7982.022; Wed, 25 Sep 2024
 00:53:20 +0000
Date: Tue, 24 Sep 2024 21:53:19 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Danilo Krummrich <dakr@kernel.org>
Cc: Zhi Wang <zhiw@nvidia.com>, kvm@vger.kernel.org,
	nouveau@lists.freedesktop.org, alex.williamson@redhat.com,
	kevin.tian@intel.com, airlied@gmail.com, daniel@ffwll.ch,
	acurrid@nvidia.com, cjia@nvidia.com, smitra@nvidia.com,
	ankita@nvidia.com, aniketa@nvidia.com, kwankhede@nvidia.com,
	targupta@nvidia.com, zhiwang@kernel.org
Subject: Re: [RFC 00/29] Introduce NVIDIA GPU Virtualization (vGPU) Support
Message-ID: <20240925005319.GP9417@nvidia.com>
References: <20240922124951.1946072-1-zhiw@nvidia.com>
 <ZvErg51xH32b8iW6@pollux>
 <20240923150140.GB9417@nvidia.com>
 <ZvHwzzp2F71W8TAs@pollux.localdomain>
 <20240924164151.GJ9417@nvidia.com>
 <ZvMZisyZFO888N0E@cassiopeiae>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZvMZisyZFO888N0E@cassiopeiae>
X-ClientProxiedBy: IA1P220CA0002.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:461::8) To CH3PR12MB8659.namprd12.prod.outlook.com
 (2603:10b6:610:17c::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR12MB8659:EE_|SN7PR12MB8129:EE_
X-MS-Office365-Filtering-Correlation-Id: 0234ee0c-3925-44d9-c5d6-08dcdcfc72f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nVMHaK1blH8Qjb7mtZBqQBYfIyQOtFEZ69l7ftaXuAjn/99t6bhqULVeqy2A?=
 =?us-ascii?Q?kBFTlUB14VWR8CLCe0dSNCVIoVUty2lvycEC/wG2zIDXlYnY+khUoOd23Ukc?=
 =?us-ascii?Q?u29jfVo7uSCH8RRFsWbuK5AU1vxTXDVL0ry9azRkI9dHtQOUeFEEcteUFSC7?=
 =?us-ascii?Q?fuL27BUSPYc4ZySgVCYqvrRW7Tl0+vgYNfuaZ9VUtj8SUZZyaW//BNij9+vg?=
 =?us-ascii?Q?93PX63v2pjrNFaUcDOVvpdgzfN59mYtQ6OeNV2e8KJbBO02iep/qb3S0giNO?=
 =?us-ascii?Q?BoDXjxl1zh72H3BbO1JaNv/c9iG4/ivdRUn7uhPJyoUze0NzPtoWlO568Gia?=
 =?us-ascii?Q?+y8FeUZcWywifvkiaD5F/dtdAQn9hhZZ0gOY6N90m39olvBFi0bm/iYQ6BAJ?=
 =?us-ascii?Q?wh9XihZ/qmExOEieM3zBLJc2X2T5LLs3gQ6d4MAXMu2vH27cP60dvdAoUX4f?=
 =?us-ascii?Q?y8lBI0PEJoqqgatmU8X1tN4xsblVk4DnJW4KPW1nyCVt5gnyi3A5k3xnHc01?=
 =?us-ascii?Q?4G3aV09P8fPFpD6efSfoSl9HGvVLVlVSE3QqARfbowwOv6LGq6WNofSYZ6Ju?=
 =?us-ascii?Q?snJlNxLOK8zaHffZ3q6FiPYKkTFXFSR99cP5U3/iFCOE4gDvTaIJ00ue4mbb?=
 =?us-ascii?Q?VZQMN9e3tb9D2Ig6fr5sMH70CWrqveaLCu6ZQj0fkqOHMh6xjmYAQNKRt86K?=
 =?us-ascii?Q?t4xrTcxu+AY0mJUGw072aewBS3w3VmIWOVfJEBL5emCDGe+0I0sN7TNbIpek?=
 =?us-ascii?Q?dGx0Mt8YJhWFfZfvfWX75wuGENGW6OGkmTP1TjH3eXtkIXulbpYoO+NwXbDf?=
 =?us-ascii?Q?JwfEscO0OnfXD/53X7zigZ8J5ByA8opa1IicehWCaTGC1quQcfN804Z4WaM4?=
 =?us-ascii?Q?BvK0eEPjYIXiMP58yKh0jjMp3tVaa5ssHfDywSXSjUM63ww0R9ysH29fou0V?=
 =?us-ascii?Q?DV3U2rJVl+gzMKhyF5x6FrclQPMQ3pwJLivl7+d+vdYxabkNiovND+wWjUXA?=
 =?us-ascii?Q?v//rDsntT/SvQP2Sm0rId4aCgtAfewSaBaZUj6CpuhZgc9KVljMc1+f2Pt4o?=
 =?us-ascii?Q?+Jzk0B74OBlcTNps7Aitapsit99tTwS3Vnnh96Jtm0uPxPeGCP4LhLWHfkS0?=
 =?us-ascii?Q?7AdCODZuYYhqLGkEpK80VJ3KlijfN8jcZyimN4t4H4d9oeAjkE1JuVGfevFR?=
 =?us-ascii?Q?6+bBjWWIGwPZTTKk4jJechprJrG/CYS+DTmYm8vuqqump+JSj7a3FNebPlAF?=
 =?us-ascii?Q?VLgQFy5QE+cRfhKw1iwtyEzJz3FlZoHIxXhVGIJFhw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR12MB8659.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mpsV5ORqrgVSkvU7rAxqoJF3JRwWBaY42couOPGo9Hg0crU+PniSXBJ09gAc?=
 =?us-ascii?Q?gDQdSkEIV3HmcnyLyKWZbkHJZ1JYhXKQz51c8Dm6vSBu1iGs/ZWbm8aG2F6T?=
 =?us-ascii?Q?69vozaOs0c4750IWpUMSBt2mO6y233HSa/qzG4lWXhSG4hAyigm592SE5V5A?=
 =?us-ascii?Q?KwN3g9xO94GWC58ersPImerXBlCQcwXkrO06GTKzeVftz22emqaacm/Q54/Z?=
 =?us-ascii?Q?s1axU0efcT02/YQznqAN9cn9eR+N/uJ2rluenXGpVswL1j6/JCGdLRpnIuQ1?=
 =?us-ascii?Q?/J4YJh/0UcZeAGvZIALGSwRFdvaUOPoMx8atm7Sank3zMCkms+WOZWKNB3Ce?=
 =?us-ascii?Q?P7nd3SQJUoBLFzIqtVwTWaToW6sspmqi+2+pGdwP/iMC+Yy3rnF0FzPYINO4?=
 =?us-ascii?Q?0AG5RzeP24wniTAKCn2NfooMIwd3TyGk18PxKLEf699Msg3qm9Z60S7Tpw42?=
 =?us-ascii?Q?2vWor18VZefR97+jMCdQoE7eb9v7FbNCn3DYZMztNLmTBmUN8HNV8Of2103h?=
 =?us-ascii?Q?2nICBHDocdDIiK3g8Ckuw4d1pnA21ufTM8fSXd+H5iKEg6E+WUyO5tzEFb2l?=
 =?us-ascii?Q?aOVRpHaaada3j7ce6f5nKsseQCOyx0vUrFnMPWsH21mF/i3qwgk/CKvmhWVf?=
 =?us-ascii?Q?5WZOn1O7TQVjMg6jl5M8G4p+MfFsdo98gu4AbrooiQbezxAkMUJkIQSo/4K3?=
 =?us-ascii?Q?S/rzjB+835x3oQ4oZhUihF+psHd+ltxgilHsojzaC5OQk/kmdmON6mb0cK/t?=
 =?us-ascii?Q?Y6hvKBukQ1uNhX1OF7qTB+oh3RR7N+oBkzACL3ANmB5+2uVSaUsXG51CRNar?=
 =?us-ascii?Q?LoXJy5t244F2h+BbAobx/7Axs9TB5Tn+hLfY0JI3pXa52eG63O+mn5v12mu2?=
 =?us-ascii?Q?JQ2ONo4j8wAIwJcu+f0K1zI9YZ4k0eADVm/fFqrATvSA7/088AWYn/Rp89HO?=
 =?us-ascii?Q?KCq2+jhfMmlSaj1+TJ++/9lpFI1o8j9AgoTqtr1NLcfBWS9JWsPryIco18T9?=
 =?us-ascii?Q?1ZemWtS0ovtkA7PNRj+AeR1tirElD8ysmuG+pFM0rqZGNHUfQNHm9dQM7ceS?=
 =?us-ascii?Q?EW7skXyv64iT4M0o2ik0OB4Hbv8C0vvhcDGplADfeN0KsqFJLrv8RB9Eevar?=
 =?us-ascii?Q?FczKJG2zlEm3ohVpuuqIY0vLhk/R6KpLYV5rWRaHCsITcE1jxFwbwpT9gxXS?=
 =?us-ascii?Q?mX+2/jq7QjSbNo0zkA5hmkRaOBvE08gn6gJlfpr9qN1YJoQ+xUux+yWPB4E5?=
 =?us-ascii?Q?8j30u/a05q82RHN0+iAw7um/H6XjY2UQXbvuBLjOL2OCWKuh/z7ZHiVKWzkn?=
 =?us-ascii?Q?d0kEpXi1wJJSielI+feg6yrhwcXaSRwH2MFp/23cPxj91VtAUskvi0OrO05r?=
 =?us-ascii?Q?wSbkcsE6NKZ6JzbkplkvsmuVlRe1k+Q2PLIObz2PIqtClinU3y5scczchVu9?=
 =?us-ascii?Q?eC5p4VUKLWNQLcFIzNEnpa/FqXJV7DyrUTKj6yV/46yVv1LQ7IFhPzjT53bq?=
 =?us-ascii?Q?UNBrcJdIwuKL6flJLdGbiQ4siK8S6NFtoRbFY1vbnK22pdwOv099VXAKoITt?=
 =?us-ascii?Q?RiRxJcMfM2RU+QxZwzs=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0234ee0c-3925-44d9-c5d6-08dcdcfc72f4
X-MS-Exchange-CrossTenant-AuthSource: CH3PR12MB8659.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Sep 2024 00:53:20.0016
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5yIA9oAVTtl0ufDxdHNT0ncqvx0Mfz24vFIQmTDNgZUvFEb3RtycmZGr7iEAbWJR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8129

On Tue, Sep 24, 2024 at 09:56:58PM +0200, Danilo Krummrich wrote:

> Currently - and please correct me if I'm wrong - you make it sound to me as if
> you're not willing to respect the decisions that have been taken by Nouveau and
> DRM maintainers.

I've never said anything about your work, go do Nova, have fun.

I'm just not agreeing to being forced into taking Rust dependencies in
VFIO because Nova is participating in the Rust Experiment.

I think the reasonable answer is to accept some code duplication, or
try to consolidate around a small C core. I understad this is
different than you may have planned so far for Nova, but all projects
are subject to community feedback, especially when faced with new
requirements.

I think this discussion is getting a little overheated, there is lots
of space here for everyone to do their things. Let's not get too
excited.

> I encourage that NVIDIA wants to move things upstream and I'm absolutely willing
> to collaborate and help with the use-cases and goals NVIDIA has. But it really
> has to be a collaboration and this starts with acknowledging the goals of *each
> other*.

I've always acknowledged Nova's goal - it is fine.

It is just quite incompatible with the VFIO side requirement of no
Rust in our stack until the ecosystem can consume it.

I belive there is no reason we can't find an agreeable compromise.

> > I expect the core code would continue to support new HW going forward
> > to support the VFIO driver, even if nouveau doesn't use it, until Rust
> > reaches some full ecosystem readyness for the server space.
> 
> From an upstream perspective the kernel doesn't need to consider OOT drivers,
> i.e. the guest driver.

?? VFIO already took the decision that it is agnostic to what is
running in the VM. Run Windows-only VMs for all we care, it is still
supposed to be virtualized correctly.

> > There are going to be a lot of users of this code, let's not rush to
> > harm them please.
> 
> Please abstain from such kind of unconstructive insinuations; it's ridiculous to
> imply that upstream kernel developers and maintainers would harm the users of
> NVIDIA GPUs.

You literally just said you'd want to effectively block usable VFIO
support for new GPU HW when "we stop further support for new HW in
Nouveau at some point" and "move the vGPU parts over to Nova(& rust)".

I don't agree to that, it harms VFIO users, and is not acknowledging
that conflicting goals exist.

VFIO will decide when it starts to depend on rust, Nova should not
force that decision on VFIO. They are very different ecosystems with
different needs.

Jason

