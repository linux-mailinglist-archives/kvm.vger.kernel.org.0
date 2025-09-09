Return-Path: <kvm+bounces-57160-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B611B50928
	for <lists+kvm@lfdr.de>; Wed, 10 Sep 2025 01:21:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E45121C62A65
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 23:21:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B5AA286885;
	Tue,  9 Sep 2025 23:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="pZ5Yu/SM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2077.outbound.protection.outlook.com [40.107.223.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F82126D4C3;
	Tue,  9 Sep 2025 23:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757460059; cv=fail; b=bxmhY30wBh6V7T8lMbEEEmAVBtNeM2OK6zrxbjzOH4y0J7ICAMpBOW1sGHC5HeMnkiGIerewcAtYCOa9JrV4yDeTxysRiMQZgSFGaxyx7Yi3gmAcdL4y+ZpnyqfFnmSlBdgl6IOw4u0pY9ko4Mhfoo5iohEsRRWltNMGkvx+g5w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757460059; c=relaxed/simple;
	bh=PBXZtrnu0tU8WGb0+yt/rk3jeyO/MyNDimURl21SHUs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=HcPwxPpgF9QamOUPfn+0wJ+7/ulc1uD5IDC8LXfabJXJ6DRUo54RiiSLvOwVCkthBTdOPEMSHJMbhyy05obN2AcqfDOkpaIcScnu8dJuh8CX8C4h/wXO1pcH0hbA6ffz4HjtyTzHK1IKThsjd/Mf43ciacjIETt8f1tdUu2LyOg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=pZ5Yu/SM; arc=fail smtp.client-ip=40.107.223.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YYOWn1K/BtZzvOKl/vPI0qfwxbWBn+s4ora0XWIHj9y9E0WLnQHZQ+FvL8XMYRLQIvzc35MQ2+Fsq01DP+uTBrxzkGAew+O2ar/t6jLN1QtFKx7jlCDsd5CAB3ZjOMpvovYbugzwAiUeTUVqOT148WMQAid8MfIans2Mfs4ph7w4BXnlA/ITjFoZLRQg6U81hd/y6n3H5JwtnY6BDTq7IB/ZOVePb1wvtLfKDJ+ysQhvSPvLc7Rn9pttFSUQ/Bsdy0NgL/pPuwhRB/pew2CrGEDKvJU0IpgKdWmyj1yBbPSGkKq4iMrJ3lcd2EJVk/ebgRAUK3ibFf2UbvZz8jwOwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FmTwkTFHIj5XANh+/Ma3WuM8978XFxS0mn23v03rGcg=;
 b=RPph51lYU4LgyoU35wn5q5COm2sVq2+3fOFr1W/ESCh6Imp3MQjRy4Z6SDK+x68V8/HmKk5GCBkCoUKjfo69Ci54wmZuHs94vx2S1ZMZmGYSqI0xm7OxYViuuOZ2JxT675dlR2eDF3hy6NrM5viM3F8IzASSLWjLb7p63nGvzfy2PjBtrIQaHecuJ9+qh5VNv1ZzgPnW8OA3w7qS9tgVNGZ6gyz9PpBAkgJh8vCakll8oOgdqwvq5val3EWYUb353kmBVIukEtyCO7DG8g9l+3HRLP1k7fNKYWXpfoZtpj35Y28QSBEfvYJI/Jc3lS5oda6qR/UZy9oLeF7CUGcTDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FmTwkTFHIj5XANh+/Ma3WuM8978XFxS0mn23v03rGcg=;
 b=pZ5Yu/SMbD+07blNQDxiQTa9kzCRpZjJ06UMvRW4/MCAUJjBjad+nfsaFPZq/ffINd21olKJMCr5rh4VIIQgwFDy2V6e70CzDPm4eImBpIOlOfRthtqghz4VH/LForBGaHeqnYFclNLrl6xUE6lpM5/hLWG5mVp5BWVjdwEAedaM8aApkkSO3GBCDimzW2A4CsSmD8coRY35cezC+QVcqwk9MX26xhEL/nT4iRTbAGLrqUSgrKPDz8dA9njZTgO3ROibwNz9dKji5bQq+kl3kVgXYKHzBwCSKCV8xTSNhso6V6RPgg03usrSSfeKdq6FGu9c2LmfinVHIR8EWVR8pA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by IA4PR12MB9785.namprd12.prod.outlook.com (2603:10b6:208:55b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 23:20:54 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 23:20:54 +0000
Date: Tue, 9 Sep 2025 20:20:52 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, linux-pci@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Donald Dutile <ddutile@redhat.com>, galshalom@nvidia.com,
	Joerg Roedel <jroedel@suse.de>, Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org, maorg@nvidia.com, patches@lists.linux.dev,
	tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
Subject: Re: [PATCH v3 06/11] iommu: Compute iommu_groups properly for PCIe
 MFDs
Message-ID: <20250909232052.GR789684@nvidia.com>
References: <6-v3-8827cc7fc4e0+23f-pcie_switch_groups_jgg@nvidia.com>
 <20250909212457.GA1508122@bhelgaas>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909212457.GA1508122@bhelgaas>
X-ClientProxiedBy: YT3PR01CA0138.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:83::25) To PH7PR12MB5757.namprd12.prod.outlook.com
 (2603:10b6:510:1d0::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|IA4PR12MB9785:EE_
X-MS-Office365-Filtering-Correlation-Id: 4070d2b7-6220-4e4e-fcfe-08ddeff78623
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gqpG05/lGUyL/8Mbh3PyA/1JaI2BLFBa9uYpGzYmqAV5Ky/WPnjyahKUi7Sy?=
 =?us-ascii?Q?hpyfW8jd5cvGImGFFwatGYR6RLCV5w1D+1WxZ9pL146eF74qC3ZldmaoWwBX?=
 =?us-ascii?Q?kn1Eb8KQUISEUivqjoAviMgURqRgkwfciuA1psG/hm46rHurnLXh8OKEAuBv?=
 =?us-ascii?Q?l17JW3j1j+cchjZjflJqDfM/MxexcNU7EPVVG3ZrGJ6WaARO4mMXuMztzcNS?=
 =?us-ascii?Q?lNADGJFH7SrCtem1EVvhn61u4V9soSAgdVmC0hRK02auM3uLp4eOQOSyaHnd?=
 =?us-ascii?Q?Od95bjiBuYIpWBcJXuVHXCyIjMd7hGJdEdkm2LTwOHL82CDXw8FFE4sfaQ6M?=
 =?us-ascii?Q?sgoz5OdnVQJi7Cg4ZLvXUK2jHMrhgODHWouRXOm0Jweanu4y7swcEKnTIg7K?=
 =?us-ascii?Q?n1r/RLZHfI7UN415POsi39eL54nS9rEPSmfGjakhjQA9eTNXCI+5stMCStew?=
 =?us-ascii?Q?vs69/iVuvim71KiseteCUjZKqS9dyc10jLg43aFs5fB79IDTuGlwKYk/fC9r?=
 =?us-ascii?Q?Q2oJE9wlgki29frXPScGQ11h0SpThKHd3EmpHNfYwp9jXE4/1E+9XSOZdPPo?=
 =?us-ascii?Q?b1AZc76mzii9V648WUkpEKUnf4WgMK5RAv24eLkLEkRqfSS4eGU0JBK61WsN?=
 =?us-ascii?Q?k9MToe7OIqa466V5o7LWLWRlmk1EHQJGb5sO2S4mixTcooYt6U4MtiG2RiGL?=
 =?us-ascii?Q?v6o4WDAe7PkADPNGpHapgLYKzzX5s12IpqSFaMYJbOZ+VnaamDhqg38cR/aV?=
 =?us-ascii?Q?t6iiUNfJ3inRR/oN5bMVmLO3mA5jwwTjaX75takUBklvoTKMqVgwosKckx9p?=
 =?us-ascii?Q?Z0xyI/Qw9diELq00I9XKQeLbMak9nBYisA77uUoXiEt7ZQrgViJ+KSgduI2R?=
 =?us-ascii?Q?a0AU/Yj1uKOrwzz8hTtJT70+rR967qrhXMFgJlhukIO7w4X2UF/IP1pUeLIG?=
 =?us-ascii?Q?O/f9kSZ+9PeYhOtOVXwN7y0FBVjcFvf25eN1YcHCd8OSgViO0t6UFkRICWh/?=
 =?us-ascii?Q?TZ3IEvxyLMevMnjXpDwQLmYiHyL7Xhqvdqe0Iti0NgOPmKV6hC5hkD/7p5ct?=
 =?us-ascii?Q?vDtv+tb6Yo3jIZU6t/JmyWxasi2P55VzXkc0D1umXdlXbEvZaAe2MghEtTGO?=
 =?us-ascii?Q?P8FHOyn+RtnRmLpx73TkzFNsUzlKOMv+G9lMSDbJdvWs3bYqzMT+WlBTd7nZ?=
 =?us-ascii?Q?ramU9YAZKgpVqvgMgSGqBCo7MKpKawojtmWtMSEHa8u60dVWyts3xZoDWt67?=
 =?us-ascii?Q?dFxHKahGZYqPUW2TpQ82ZuCFOxBVsJSdaTap+xPXcuccU8DYHeN2bLKTOB+t?=
 =?us-ascii?Q?QXTrmN9HhHe1f1D4dO13x1U/ho9gp6NSfuVNUnWe9xkIfi9TR+6A5fAazvVP?=
 =?us-ascii?Q?lAqflb0rox7tgudr/1Iv0Tek9p7lL6M2tW4asKtyUq0rvCRMp/UBlSgyVxcP?=
 =?us-ascii?Q?82YHQsS2O/k=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0YGLTQ8oJWVQLYAHP8wvxhBL9BACsVGQtEeKmhzzaTlKr8us8HWBMWQ0Z8RT?=
 =?us-ascii?Q?GmZzaOaUtnSqJQYXxewY/X2o81M4p0HCPemn+iIqQAJB/4jX1uP3oylrDP12?=
 =?us-ascii?Q?qb5zXLEvU/CmeZQIzO0soD3G3x/fkroo0jFzQWgrRe6xEneMEkZ0CtMyLcND?=
 =?us-ascii?Q?S8LtZC21+nRb2mXxRuNJxFQuTsZr5p2GzwOwm5XbnkeLSc7G5O9/SvzaZ/Ar?=
 =?us-ascii?Q?Mscx+bM08rfapMGl7tRWnD4/mlY4Z9n7BtekdHduAUaDfeABxyqOsKqImgS5?=
 =?us-ascii?Q?EpEB7CWTvFHv71qyuxezYqdkBmrXzLRuN1XL4MHzN/aQGsFP/7Q3qtiiHXP/?=
 =?us-ascii?Q?zFcglNLzKH38gJj+UTcA9t3Ajd38fS+zctLof5Gcwe3L0riH/Sv5Gzah+pY8?=
 =?us-ascii?Q?UslhH85uCbcXh3pPzih+NnpZdVCf7tIQOS6q39D3KqGuym/znZAS9i+2jAeo?=
 =?us-ascii?Q?GYK0dc7418kUBlIlthgVkymdwnMiFvVxvVmU8jwT2hP5hWYxCEnv80CGewNL?=
 =?us-ascii?Q?ylXujMAg3OMoO3CSyNEswQOIoPa2iIOnY9PrXuSJzoEdk8e+ZnMeIZ3Dl2OY?=
 =?us-ascii?Q?Qj/42Yw0h+y5SCLj06TUy2T2MOOm1xGOxkF1PLhXInb0C0FaYKwdzXl/AURm?=
 =?us-ascii?Q?SSEoDz/GYhIQrt29Mw1oKMU/Ws8uCxXx1AYmmx+Du5oArWQuQNZJOFtbI/t3?=
 =?us-ascii?Q?4t+/bruzaSBgJo4HrQ47Ba3HF9SbZ0Q9ytGBVeTfcVnX6KHsNWwY1GoqrePc?=
 =?us-ascii?Q?Eecks4XuAIS1jLKz6UTf1Me3VVj3CdcCMM7Nb8nsO4WCBmc9yRs6iES3cHx1?=
 =?us-ascii?Q?KdZ6T+v2H5H4mBxTNkCkdhgrcaErw/JGi2qMy169odbXijjTj69Yf3iksDzY?=
 =?us-ascii?Q?ZaIx+NhzKSCqwdQQlFud4ffDjAe3DC6o96niaSEuN5y9Na1nbNp4IbVGVS1D?=
 =?us-ascii?Q?kbkDZ8kmU8UyaHOpycXz8UgjakmEBUVnZtg3kMNBAMKV4tq7l3dODzglFESJ?=
 =?us-ascii?Q?+FOuAsH8D+1/KCvSadhRLCjDY2D6QftuHB7nrwwKnvTSXEeO2oJjESzH5+qr?=
 =?us-ascii?Q?lFEoCkmkq/7gfG4609cv4dVMl0MDOe71cxp98g6y8f8Gg3FEbznpKiywLjnS?=
 =?us-ascii?Q?at9UPCuAHgEggiyRBzKW3Na85389ltnzBfi1sZrywplkOp1hBthI+GaSLqMy?=
 =?us-ascii?Q?LxA0H3Qa6E+XexEXVBe0zDj6eaPLq/1+316w/9m/vbYR6VzWn74MkIEn9m4M?=
 =?us-ascii?Q?Kljg2HK9Q7moYgXhfWahN4M5B4GOGBNJ+zChkRqkci4EOovNlX1jsW7I/sFY?=
 =?us-ascii?Q?5h9lDeAK/eOu7OaTuvb6oprg2CSpaa876/sVvMhRrU2LSJWKN3RJ+cH6oJDA?=
 =?us-ascii?Q?EHFsw/NY22qDSROx4x2n6FvI0Hd0pgB9tTv+h7s5iN8O7l7FUDJbY7Hviuvr?=
 =?us-ascii?Q?NcCGZ3124m7nEnQTZnuhXQVSoz/aA/hZyOyji7GnaWMBWYP1FsqoPutRbE9w?=
 =?us-ascii?Q?LcG8CJfHsBA5rhKoP2R/Ylsr8DoHsfkFsLMaZgcYd9dusQ/F28TYdfWw1WNp?=
 =?us-ascii?Q?l16v8sx6oKatQBTIoW8=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4070d2b7-6220-4e4e-fcfe-08ddeff78623
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 23:20:54.4907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ia75wRcQxWUC8CxPc7weSY/55HauhHxFbJSOk07AOqmddUcKp7Soz8M5LGCQjAa8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR12MB9785

On Tue, Sep 09, 2025 at 04:24:57PM -0500, Bjorn Helgaas wrote:
> > 
> >                       -- MFD 00:1f.0 ACS != REQ_ACS_FLAGS
> >       Root 00:00.00 --|- MFD 00:1f.2 ACS != REQ_ACS_FLAGS
> >                       |- MFD 00:1f.6 ACS = REQ_ACS_FLAGS
> 
> REQ_ACS_FLAGS was renamed in an earlier patch.
> 
> I don't quite understand the "Root 00:00.00" notation.  I guess it
> must refer to the root bus 00?  It looks sort of like a bridge, and
> the ".00" makes it look sort of like a bus/device/function address,
> but I don't think it is.

Call it the host bridge or whatever is creating the bus segment, it
doesn't actually matter for the examples.

> > However, the PCI spec does not really support this:
> > 
> >    PCI Section 6.12.1.2 ACS Functions in SR-IOV, SIOV, and Multi-Function
> >    Devices
> > 
> >     ACS P2P Request Redirect: must be implemented by Functions that
> >     support peer-to-peer traffic with other Functions.
> 
> I would include the PCIe r7.0 spec revision, even though the PCI SIG
> seems to try to preserve section numbers across revisions.
> 
> It seems pretty clear that Multi-Function Devices that have an ACS
> Capability and support peer-to-peer traffic with other Functions are
> required to implement ACS P2P Request Redirect.
> 
> > Meaning from a spec perspective the absence of ACS indicates the absence
> > of internal loopback. Granted I think we are aware of older real devices
> > that ignore this, but it seems to be the only way forward.
> 
> It's not as clear to me that Multi-Function Devices that support
> peer-to-peer traffic are required to have an ACS Capability at all.

How do you read it that way?

6.12.1.1 is reasonably clear that "This section applies to Root Ports
and Switch Downstream Ports that implement an ACS Extended Capability
structure."

While 6.12.2.2 is less so "This section applies to Multi-Function
Device ACS Functions"

I don't know what the author's intent was, but I have a hard time
reading the "must be implemented" as optional..

Frankly PCI SIG has made a mess here :(

> Alex might remember more, but I kind of suspect the current system of
> quirks is there because of devices that do internal loopback but have
> no ACS Capability.

This is correct, there are a few cases where it was confirmed that
internal loopback exists with no ACS

But mostly we have haphazardly added ACS quirks on demand whenever
someone was annoyed by what the current algorithm did. Most of the
investigations seem to have determined there is no actual loopback
suggesting people are reading the spec as above.

So, I don't see how to make it workable to default that most compliant
systems require quirks. Effectively this is a proposal to invert that
and only quirk those we know have internal loopback without ACS..

I will fix the other remarks

Thanks,
Jason

