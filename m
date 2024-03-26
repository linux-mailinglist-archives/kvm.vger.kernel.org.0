Return-Path: <kvm+bounces-12639-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 32B7F88B771
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 03:33:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7E26EB2292D
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 02:33:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4B33127B77;
	Tue, 26 Mar 2024 02:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GOKCQ7dk"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B8D79F3;
	Tue, 26 Mar 2024 02:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711420392; cv=fail; b=PBOq/ZpqLxkdNCn9k4DY2v8iCOnhj/3fTMJL716EG4atlxUsxQoqKIhKTEISx/47Fr/ShTClep4JRFlr28xNVmHN5ILRSfLCDfxexX287n1m07Ji+ZV9iJmKWxSHi10XXmPW1yDN8u75HtEthM9A2d2B8sFHqT0hu6+190H+mtg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711420392; c=relaxed/simple;
	bh=znYYVBL2pZouwsJRb79geron+fNq945Z/g6FPscCQ4E=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=W2je35CIBrOvijRtkZJUfya0xsyQ20yyCOvVvSMBQAIz/EBK2yy9bXGZejeepLdz6aVjr9RlF3RyT8v+hTwfwPJxaoOdNk5GW5LrV2ZvzVUpg/Ugn3rjMxt2qSJZ9lOJarTUlfWZIfg/He3vPlLCrwNE2mhLVIRvQN7qxZSR0pI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GOKCQ7dk; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711420389; x=1742956389;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=znYYVBL2pZouwsJRb79geron+fNq945Z/g6FPscCQ4E=;
  b=GOKCQ7dkIr3jom7t1GzJ7bi6KV0UdpRQOIYiRm+xCEkW/X1qXXy2Uewk
   2NM8QTCcYjZ2hrb3QiHNi5BObTR06pkk3jHwUhHZjuA+cYk/n3lQeKAQ6
   4FJRqGGFYaHSzhDdathHRTZEnFI+QjAczH5gxv+pwFuDMchGj0pF4qfl9
   1+DFqbOuV35yrVOgF1Rrxod1tyAbyNlPu9MYc9MCM8cxldcP6kjHvaBYK
   9OBUnMOkc0akWZ6p/dooFxKNSUY3D6fhn2+DjkbxiyOWf2oBqCTJMC9WC
   dbUVuEKkpUiUhozd2QMKVDTGhN2Azcyh2gd+hWVVNAYLOdfuBTo0lPdlW
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11024"; a="10247909"
X-IronPort-AV: E=Sophos;i="6.07,155,1708416000"; 
   d="scan'208";a="10247909"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2024 19:33:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,155,1708416000"; 
   d="scan'208";a="15877308"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Mar 2024 19:32:42 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 25 Mar 2024 19:32:41 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 25 Mar 2024 19:32:41 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 25 Mar 2024 19:32:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DXmAO9gXqutMlQkP1Ker2FiSbH7gD8dGvgJjyvXvXnTzA/isl45rW3R5l7P+QpsdJq0yFrzdw0QU359NVXMgKXv5h59oPqWWxwFKs6L3qR6QrkMMv/86nYz9R3RzqoyQnDAsQvNA2vZDfa8m+SAV7z0QKCM7IgWupuy74+4DmeZWg0UYeQCP7wKB2/pYzrjLCfh8UgD1V9dhCuqxs+6/7gqYO8FSI6R4z6chJkI6x4jkCFPivEhXyygHyq4v54JdhMMtJlEAHr7vukBQPvXblow4jr4PhfuXkyYNZFXR4BK+9J3lFrKA2U8N8/CQebZevRMrBikHrJSiBMWm78Ck5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u6v7LqapTjWWq5RN2dSZKelVoRWOgqAY2CGrgfHQH+4=;
 b=in8FpmWjBedYsUTGxH+3nISqRTohJ9vyv5gLjHrIxSVT5SSyF+6fLRheLsaKDOytzwZrvfjHt52eTdtpQxE4p21uuVLVMIdnTN2MSd4XOLJWLxFvKClQ2cUVdM+Zw5z7dBV7Q4t0FRx+IAEbgrqspHVy3dv3vTw3eR1Ef5beeCKQ8sWey2EbMbdA7uuSqUoiO8HP++Ldc9ccF+HBBJty6/pHBKyfBrEIGzhsK0liHp2g3J/ADE+Am3zZWX0sMOjGyjfD/Z/lD/2Sh2fqn+Qfk9IXRvBvUoee3iXz1Eg8YgcB3iJ7i/nyzU79l7vAVMr7l08YmBAJY88ipzgDzLrjCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SJ2PR11MB8403.namprd11.prod.outlook.com (2603:10b6:a03:53c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Tue, 26 Mar
 2024 02:32:38 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%6]) with mapi id 15.20.7409.028; Tue, 26 Mar 2024
 02:32:38 +0000
Date: Tue, 26 Mar 2024 10:32:28 +0800
From: Chao Gao <chao.gao@intel.com>
To: Isaku Yamahata <isaku.yamahata@intel.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Zhang, Tina"
	<tina.zhang@intel.com>, "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Chen,
 Bo2" <chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>, "Yuan,
 Hang" <hang.yuan@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v19 059/130] KVM: x86/tdp_mmu: Don't zap private pages
 for unsupported cases
Message-ID: <ZgIzvHKobT2K8LZb@chao-email>
References: <1c2283aab681bd882111d14e8e71b4b35549e345.camel@intel.com>
 <f63d19a8fe6d14186aecc8fcf777284879441ef6.camel@intel.com>
 <20240321225910.GU1994522@ls.amr.corp.intel.com>
 <96fcb59cd53ece2c0d269f39c424d087876b3c73.camel@intel.com>
 <20240325190525.GG2357401@ls.amr.corp.intel.com>
 <5917c0ee26cf2bb82a4ff14d35e46c219b40a13f.camel@intel.com>
 <20240325221836.GO2357401@ls.amr.corp.intel.com>
 <20240325231058.GP2357401@ls.amr.corp.intel.com>
 <edcfc04cf358e6f885f65d881ef2f2165e059d7e.camel@intel.com>
 <20240325233528.GQ2357401@ls.amr.corp.intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240325233528.GQ2357401@ls.amr.corp.intel.com>
X-ClientProxiedBy: SG2P153CA0019.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::6)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SJ2PR11MB8403:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C0oIvgTxjdrK8zwlVwb6KcrB4EIEKouSiqQXEMwdcfj3w3ikMcZb8W8sBI177MvXx2D2xEZz9+vEGE4tqjHudSDNyMHtqyWwVL8iActG07FLdGvIfdBq4tbqAT2Y4FeWzsG4AFJMoaIITZzF6X1PpdZmzjNCo5Lxx/5yogkBPOPXfYeAkeLv3YlfDAQYWzZhZOthYCHt6hdTVrdYDWa6nm32Pu7ByUM8o68yfA/XM3oB8wbYIOt93jIgobnvUThDuuq8M8Zq14bpZ1GhXoJuvutbetwqo/JjQrOaF6573efS8S3LocADf+GwTEShlfIxzu994mUN1DRVtrGk829xETw6hBk4pi6tjjYa/CS9uVyWyFrYXMxXxQFQtXhFOgkGZjBvXbc4lj7GQfqLvzcxM4EzSba9utUrwdsV7Q01WH2Sdxe6FWuiqDS/uzSL97GARqiFVhe54NKe4RYyzu1EYK0OTuY/cKVR3kwBahjjQQG2mpColqDIYCnHH8BLEBnbE8N8LQdb1b6zsL6+6JisLM5tv7QUe3NLfgdyx1OVif3rm27SmTFuT5a9V5XgX0QPaVG9KM0cOSKTd9fyqgyiC5l5j7ueLWnVEMY7ZcYz7wcouRi4c3WoJXbI/b6Mkobq1G8dIw04sis/QefuoTLGZAmr45oj577+8xhoS11QbDk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?Y4LzYa0NZ7ymT5zUeKwxc1ZbfP98OVXaJ4xcjFh7czwwHuZIr2axdobTKM?=
 =?iso-8859-1?Q?wU2+iy4qb6Z94UwcfpqDOGd+Ptel5jxNtRPgdRPHVhFL570JrnXzy/I995?=
 =?iso-8859-1?Q?pe6JySWA6dYks8RYKnKlLyI85vNszEcyrp2rlbKn6u4nuCBdVmb8Q+beNz?=
 =?iso-8859-1?Q?Z2PKjqLZQBpav8NeW+lu8tURRo58qM3YspRUDEuh7d+ln4f+bYJPoEjNcU?=
 =?iso-8859-1?Q?Y2stsfquk90gZqzFZ1f42WjdsqlDUTEBSkvELVUolLcrUvl8FfdYkHLNPt?=
 =?iso-8859-1?Q?B4y+tMsrE8CcSDdZHv33D1tBvWZVhkqvKn6ArC3JbUwgXDBwrnz8Ic3p3S?=
 =?iso-8859-1?Q?+BO+rudLpfXBJM4+gDJwSkPAZ1jOT6WdFyoe+KeJoa4oW+yOZdhZ8gshS8?=
 =?iso-8859-1?Q?hIxAIj1OpMFSPYanDZrt44E5bism92K2PYE74ZiqYFpIA59MwWQBXbyj9K?=
 =?iso-8859-1?Q?csYf3hz+0FU/CF4ogQccuFOegPwJt6JHq+U8IWAMeEs+kzQ8LoAT1iZWDp?=
 =?iso-8859-1?Q?Tahfp0IeHgkXtzTuSLWCHc1uAnfjT7Z37vZ+l3YLvokFxs3UJiOGP8gK/8?=
 =?iso-8859-1?Q?wEorGNH9bIFmjyK9XDvAd63eUnP/JbJ74zUtL5D7AVf0qeLO9NMfgjYpTR?=
 =?iso-8859-1?Q?NwS6dyqZNhjCyqFnFsrl14nr6HFLKJG47dvR2QabPgF4kDvOinkmTMcTH6?=
 =?iso-8859-1?Q?FJ9uKgbv/LBfoMLvTJLGQHrBfjzOFpnCfxUj3Z379rZk7axuskHRC/+7ov?=
 =?iso-8859-1?Q?FFdshdkcvUpwtliYZ/VYgBtTRsmv/YPbUmo1NpX6K0BW5sKY974KQF75lW?=
 =?iso-8859-1?Q?g3npKoIdbJKVSyRHfNrSqHypYABTr3GyZP6OddCFU6YE7jkm5dkjFOKscJ?=
 =?iso-8859-1?Q?QeWThYrym2e8hZ9MOfRl5mMhCGZl7Hq/otmB2Wo+G3acG+2Gg1ExsmWdfV?=
 =?iso-8859-1?Q?1X3qwDsUzdBQFFwfUJIji4ntqljTAF/JfXHtUJjqJiIp5xFN4o9UTLE3xm?=
 =?iso-8859-1?Q?Vg3ohniHMnntS4GQ0sjuxpMlc7O4y+ukM7+UfFUrw+Og+u+X4jpa14CXrS?=
 =?iso-8859-1?Q?3P73fRZ2AwI72lWXLoGcVqwKsNqwXqN7U+UA2yDgV/oUmEPU7kH24MiJsx?=
 =?iso-8859-1?Q?ELC7nA5WdfP4SGY9gvNGNNLrLr6Ipnk0a8KKC1VYgkaS23RVRc5MC+27sQ?=
 =?iso-8859-1?Q?iLwLP6udFH+rknrmfPvEXA+yPZCXnWC0L0joVbArdoCKehlqEZO2C9qiiB?=
 =?iso-8859-1?Q?KjbVUvaJ0wVB5uNxy7QNRM+vYg+2OI+m15ivnGZ3jfpLCS0a4G/KN0ZFoQ?=
 =?iso-8859-1?Q?O4x89UJ2XiEGlktZR0O5A4sREtOmGtZs/StJQk7ITIrbYGSJAx1fBaWxfW?=
 =?iso-8859-1?Q?7IS+JRzR2aPNnspPXXmhfdqKNf+0n6f2A6r4JO5NS2ZvwI2o+CSec4uGxm?=
 =?iso-8859-1?Q?MPV6qP2AUshGctxOcD0r1joZUkOpwBQKjGSO6qiuaOUSfP76S95gr6eW5T?=
 =?iso-8859-1?Q?wI62Mzg+sYht1D/lqLa9r8qG3wlrwMoMgBKPBMiEnemd48EcU6hFXAQoW0?=
 =?iso-8859-1?Q?AnwklzZYK10iusX1oYr6+SL2I4UeOJFJ8gXO9Zynq8m96lhSRs59ipDRs2?=
 =?iso-8859-1?Q?+aFc6Yddg6jG9PGJFMBOLtbJx6XimIlLA0?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a0f7b1bc-b635-4ec5-88a4-08dc4d3d00f4
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2024 02:32:38.5747
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8COOFe8e4hmWxtaOb9NamPnrZHOKWeZYj18kaBf/500sTRN0OEpN526KwSPVv6x25ULIt09Hrc9sc2qWHMp+5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8403
X-OriginatorOrg: intel.com

On Mon, Mar 25, 2024 at 04:35:28PM -0700, Isaku Yamahata wrote:
>On Mon, Mar 25, 2024 at 11:21:17PM +0000,
>"Edgecombe, Rick P" <rick.p.edgecombe@intel.com> wrote:
>
>> On Mon, 2024-03-25 at 16:10 -0700, Isaku Yamahata wrote:
>> > > > My understanding is that Sean prefers to exit to userspace when KVM can't handle something,
>> > > > versus
>> > > > making up behavior that keeps known guests alive. So I would think we should change this patch
>> > > > to
>> > > > only be about not using the zapping roots optimization. Then a separate patch should exit to
>> > > > userspace on attempt to use MTRRs. And we ignore the APIC one.
>> > > > 
>> > > > This is trying to guess what maintainers would want here. I'm less sure what Paolo prefers.
>> > > 
>> > > When we hit KVM_MSR_FILTER, the current implementation ignores it and makes it
>> > > error to guest.  Surely we should make it KVM_EXIT_X86_{RDMSR, WRMSR}, instead.
>> > > It's aligns with the existing implementation(default VM and SW-protected) and
>> > > more flexible.
>> > 
>> > Something like this for "112/130 KVM: TDX: Handle TDX PV rdmsr/wrmsr hypercall"
>> > Compile only tested at this point.
>> 
>> Seems reasonable to me. Does QEMU configure a special set of MSRs to filter for TDX currently?
>
>No for TDX at the moment.  We need to add such logic.

What if QEMU doesn't configure the set of MSRs to filter? In this case, KVM
still needs to handle the MSR accesses.

