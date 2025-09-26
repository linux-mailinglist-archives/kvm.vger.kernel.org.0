Return-Path: <kvm+bounces-58839-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C3012BA228D
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 03:47:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 80031627435
	for <lists+kvm@lfdr.de>; Fri, 26 Sep 2025 01:47:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5115B1BD9CE;
	Fri, 26 Sep 2025 01:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="crp245Bx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79DB1C8FE;
	Fri, 26 Sep 2025 01:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758851222; cv=fail; b=YCYsiaB51OVj7gM2UBoQMLjgP9Pv5dCWRaOYgtJ9H4/m6gTfWuXjT9FvNH9DwTSI81IPapxXsPtP8i1fyBVjgOLWwFD/9UHLUIloUxcrVtzx3oR/3kxd0L+hv1W/dj6vmrPKOP/cy6zYbD3C4o0JtxUzpLhiUou1uEsmMe+1oXo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758851222; c=relaxed/simple;
	bh=kcP8Uc0xUT5Ue6Md0lz+jLJjJxJXe+v7aJ5WXyxGlZA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=fzJKXf/dgIWfGTqLEMUWer6kjbb08jjP+M+Gjd36qUoihEa7gRO2cuf3dImfmWjnmZXzkr38bQOFTlByWsmu5VsA3NXz0e87Hi8ATRiUYVoZtfAtQOdmOVzFKmE8zbMVZlJkB2OB8cxcj+IbdrSjxbW/J07S46RzR8r8mE/kN+I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=crp245Bx; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758851220; x=1790387220;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=kcP8Uc0xUT5Ue6Md0lz+jLJjJxJXe+v7aJ5WXyxGlZA=;
  b=crp245BxrvDkv2BALZqB52l77bto4uIN71hy91tOpyeLaY9bxO1W357h
   mINEnN0v8Yt1M/a0m+kGiVNZeT/oHd0p0w17HG3NU0oubIYiy1VsCy/TA
   pV7cYBhqz6Hk1tMrPgU8Ek3vU3WYMn9IrGah0FPZWorKXPEZRG47KF28J
   bw/mBGU4URwFe9Onntuxce/9SIUNtztO8mLgVvnGwnZqAlDO6AUX/eOvi
   qyon5Y0oQsDLUiuZdn4uE6+aON+KSiwNY+L+tW2+0jtfwLbgFkuTChFJR
   cl1apkHH9zJ/0qy1fJ2qtGKTVHoWC+0v1yg8HiGLSZpW89x5HMdBbdXeV
   A==;
X-CSE-ConnectionGUID: UBmpws0fQ4iTdhDUTGj4qw==
X-CSE-MsgGUID: GeEiU9+QTmaM6N585HPw3w==
X-IronPort-AV: E=McAfee;i="6800,10657,11564"; a="61102140"
X-IronPort-AV: E=Sophos;i="6.18,293,1751266800"; 
   d="scan'208";a="61102140"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 18:46:59 -0700
X-CSE-ConnectionGUID: 7t38FaliTSywE1r726n0yQ==
X-CSE-MsgGUID: lV9QjBrFQpCSduA9LjVZPg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,293,1751266800"; 
   d="scan'208";a="177940756"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2025 18:46:00 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 25 Sep 2025 18:45:59 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 25 Sep 2025 18:45:59 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.18) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 25 Sep 2025 18:45:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rgr7zXgn5kMhwwi9cpi9j93hvVht4JhUEP/IwcFOQFLrs1TTwkDyEReVCxpQX8jIGrG2oE9jNS+sd8bPBPYT3jjhbnhj8KRSqdDmT+NGmdxLmGrf694IQVjv/E8/WbKBzf+Q9GLvpzu4Cln+RNEU2Q2bOQwrNoekpKRe47Po9eTGMWU5N63A0UfiGk++ob4/w0PdZeYmDryHEFhJ03W3N6dTd8lyvtxSG5pBIvZXmMIIPaXTkU3BgFEXLdEx0pB6PBCNrtrk+th2nB6HVQxcFTkPM1hkg8NYUMS14IKvvh5EGRnWvHt833HhslBcQg7wBl4wdN37shbCKQcdXIFPSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iquPIcQq+houUIw148Jc6lo1cFY0k0G8HlgGTqjExJM=;
 b=pmJLtyuGjLYGuoZYY05kpqCwAhiBjm3oKfpY5rqHy68G8K8vzUtQzaBHHgC5mfusWtzDR+R8XkV+NFvOfR0sWio0gUOw9d4KWmvAMETulY0eEpaM1GGdGhe269IMiQK4zQ814xiUT+3tEqiZiybVpsD7Bp1DdbQiir7Nnbxqrvp67xcapMUPprEZPcc29oZJnpsryYLAcMr7GynZybDe5fOfuIWFJheNaUjJBj1ZHMO/iihFeNwADkRVje04mVoSQwIsxa6vCp0cvIs5FHrGhl6/fjoaR1eebwfaL0zUaaFbyieNTZiRP+eZPDYdeBhy3ckYPhkLHwTpu22QWNcHvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH8PR11MB6903.namprd11.prod.outlook.com (2603:10b6:510:228::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.9; Fri, 26 Sep 2025 01:45:57 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9160.008; Fri, 26 Sep 2025
 01:45:56 +0000
Date: Fri, 26 Sep 2025 09:44:49 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
CC: <kas@kernel.org>, <bp@alien8.de>, <chao.gao@intel.com>,
	<dave.hansen@linux.intel.com>, <isaku.yamahata@intel.com>,
	<kai.huang@intel.com>, <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <mingo@redhat.com>, <pbonzini@redhat.com>,
	<seanjc@google.com>, <tglx@linutronix.de>, <x86@kernel.org>,
	<vannapurve@google.com>
Subject: Re: [PATCH v3 12/16] x86/virt/tdx: Add helpers to allow for
 pre-allocating pages
Message-ID: <aNXwEft+ioM9Ut8Q@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
 <20250918232224.2202592-13-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250918232224.2202592-13-rick.p.edgecombe@intel.com>
X-ClientProxiedBy: TPYP295CA0034.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:7::14) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH8PR11MB6903:EE_
X-MS-Office365-Filtering-Correlation-Id: d8ff147c-485a-4f58-11ab-08ddfc9e6fc0
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?rETd9Bnn9ONpdPsQGk3b/AJruXPGrBofFVGaOlP8GF5k9J95AuDkIJgYpA/k?=
 =?us-ascii?Q?DCmehb9n3ENM4I/hcqb/yrR4I3IFUolSxANkbhEJNH+JPVU0e5XcDnMsBj7c?=
 =?us-ascii?Q?u8OGslPoYXQbLIyk8aAEvqVkxNtXFhvoEkmXxQXs0SWmNqPVuiheDVZIqBq/?=
 =?us-ascii?Q?bo3ye2UAKV9Pbifb0KX1v5Q5geabIYHBSE+hbHfbvvbEMz9VlzAHzalc7wMP?=
 =?us-ascii?Q?XTQteZmoClzWccFCbxedSiqsoQK92HyRDlB30w7tTaowT24XVRJVy3Ha0jTE?=
 =?us-ascii?Q?BPZYsktjdiNnl8LhnJtYM3E05hXO/vjud8i6MbfzE65IagTiIQhdjfRLmbwj?=
 =?us-ascii?Q?enTTvhfxqngoR4EK0KpYv/dBh2YK0MZo8go6Ll1myYrmNIGp8uO+71hzb1Dm?=
 =?us-ascii?Q?4kyqEIpgL/u782kV5Lsg/likJIbCm/Iln6PiVEcHwiDxEIG+wxygqbrdH1hU?=
 =?us-ascii?Q?cK/L/O2INWySnLOItgda5zaIoKMmC9wGaRUARgUyYKaSOefDEYM8OV3+EYod?=
 =?us-ascii?Q?1/wrjnkIDbe2Lkvv2T1oxo86xbdwOxbuOUBwgbzW9UNDLaUX8/4ygx365aM5?=
 =?us-ascii?Q?3GlmKMlqGOIPax13pDQkT8zXlqdcdmQ1v45EwQ26vuwTiGTJhtRLwNVZwco0?=
 =?us-ascii?Q?xIYQct9dyfMVvGifByoyZZB19EFiWqO00QRFjEwiYc5rCAUeGx9GjYt0jXpL?=
 =?us-ascii?Q?zfZCMKujqA3HDllJPvE6FDy/qE1Zp6yNDwqKWNdngR9nHCOPmebLuDEhaaP4?=
 =?us-ascii?Q?mO0xcJSgic6gPdEmu3q4lUPIgQxPf47IvZMTVY86OCFAID0S9sRZxQl45PQy?=
 =?us-ascii?Q?8miyZE3sYXwAVYd4h0zSWtf88kx2DHoDLezTxE1TK+X+aeOQnIQ3k7rJlFUJ?=
 =?us-ascii?Q?b7bP2z2KLS0BXYTaoVNYqcvrUCudw3RmFfrqIgvQF/zPHmh0Fr492625z4JA?=
 =?us-ascii?Q?hkSw4jRkIgpuGayrXRHG44XOvo5Xx3VXUciI0omOSezw5EBHnaIEb3idVOEB?=
 =?us-ascii?Q?bJ94MQTX1Mfr6H34vLapTerdF9g4LtQioN5hA/TpdylZv5RskRo8sQc9Rwlr?=
 =?us-ascii?Q?2zErBupsyXdFlv4n/Pr7Nn/hd/cnbeLsn1nDKz7lVXkCd1AigPIc/s9jJIYZ?=
 =?us-ascii?Q?rOJHKH/4vs5D6aBV+B0EJTtfChw8ll47gmjTEUbOODcezmThNmYumSLqB9HQ?=
 =?us-ascii?Q?dRGyene7/vJh46tEgE9wdo2hU/vt00GqPtizqTAJ/iiSc6Fi2x2mVuBVBoB7?=
 =?us-ascii?Q?DErxdzqjaJz2xY9C+vrOwWtVyS76ln9V/QgrGp9pMms+neWiNSVXYi583LFU?=
 =?us-ascii?Q?ehn5pvVoAcsaRQ9ISqwCvllSCn1OEoFHJdAJk6erBIX4CdFpNxrKdnJ+bPHR?=
 =?us-ascii?Q?hMDtepVHjQ0YKcnmh/NUCVIyIluoSifHqPJbpd3EsaEjlRwb/hg7Ul/ieQ5C?=
 =?us-ascii?Q?Cz0eCRwdR2Y=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?goG6TWTFeDbnP6MSWNjjuEH/Ki3mB6cCl0SjY02kq9smUif2vMlp2F4aWjYi?=
 =?us-ascii?Q?QyDd1xy0vZ79zgIGXYuR6STxLzKIRJKdt5bui+tK9SvAqYj1hIMzXPwQACH2?=
 =?us-ascii?Q?MS+GeyUTWGqX0QmpRtxrByGaCMhgkL3ahTbOvIGVYqbSDKiE1ayMzb29qWWa?=
 =?us-ascii?Q?AYjtRbr4UwnxW7eYou3l+ZEpAR09GMUOTVUTWUaruRuEbW7qe2N+ZBiHKviI?=
 =?us-ascii?Q?+3dl11i9nspaxYV10zZgQgFqd4ICSHHZknDxsp8GQN9/kQ9exLqwqL1Wc3wO?=
 =?us-ascii?Q?aOx+4vAZo5pco4NhbOteqDcNQNb/HZg9V7+jQVFfl29s3rSshX+LkdBCHauQ?=
 =?us-ascii?Q?fqp8dKFR/c4bdGG4xAJdfoyCQxC18SAhvikTi2h81zzW3+qTbX8kWAtTSPEv?=
 =?us-ascii?Q?zZ+pEPyFrvfD5hsP7+6G2clX6QukwcQN/z9ZxULhjmm2l9LMs62mGNYUfGew?=
 =?us-ascii?Q?pWQmLSfe6hK8q5MkjPm0MXGVAlkJy3nrw8VB1VlT/FqnJfT8wYRyxtmtNeWA?=
 =?us-ascii?Q?XWnexQUZ7p+yj1H/mtIVZJePdRzBxqjP6jH2XYf5ha2G/Pj5rhBLOv4lXfz3?=
 =?us-ascii?Q?Qh3/qgyjBgCPOaH3X9gMxnPv9kxEdW2BghsBpy7ttwVawEjY6YqOmiSLDyY4?=
 =?us-ascii?Q?LPhbQkEqeh0ar7qHTbZ84rNpQfFYVXKrLG8n7zoRPbqYIBj9jfJg009gMGwj?=
 =?us-ascii?Q?J6c/ueM+tsZf4PWXBbuwcWxp0WDlcNPbuPq6krS+4f0ikr1+BPy/ayplvFb1?=
 =?us-ascii?Q?6hEVY6g6udsQHyrJCmhTFS8IH8yOgkRnf6mrWkchNIxjKfmlgPfT3XvUa12b?=
 =?us-ascii?Q?H+jFcGmPCR8neGDCK/F5PCGNebodGadPKttLob8Flv+/rAf2Y+3aPo2P5RpD?=
 =?us-ascii?Q?ZQEDhzNNgxh3UvJK0I8u61er6OhXktt2/OVbrhEdpAUWjSiF968sYxgYPqH5?=
 =?us-ascii?Q?oo49EH/ilegV7lDxg0W8CulXDady3KYP9bCqKMfhgcX/hoF+Zh65NgJCXecy?=
 =?us-ascii?Q?KsATeCsxl97a/tsXEZYNmoaj9KxXosFm5kP+liGouQxhEs82yRAzPGdA6nfR?=
 =?us-ascii?Q?iLKc/b1qVH4FOH1jVrGCdh1lpvHtUCFWDNyLOh4Vyc+vtyoeDSWcy3COyqz3?=
 =?us-ascii?Q?KB64oaLpOOqnAFhZfAl1y5qWfaJ+ySvZ2HH9HqKLGm6MahTHB0PKZsM60ZGu?=
 =?us-ascii?Q?x8kKsCNw6CxPGcTxujq73hAO+zDEadkSIXVIOROL91FsIpF2MxvhwTrrfzmX?=
 =?us-ascii?Q?yhOk9d5P3NE55RAkPoLxSUBcE9KH+9om8gskbBpNv6vmW2O7snqGyIpF5wSt?=
 =?us-ascii?Q?TFQB1POzm9KZVG8TUmCxGTxO3k6SoROvy9u0BSZ8Yse+zgBZ6zEpR3GqOnYT?=
 =?us-ascii?Q?rUnQdflniQ65XdxLPNNA7IpstGSw1UHzrP8u6viTK0eGFjCkVa4vNFyUZh8/?=
 =?us-ascii?Q?witQM3ThYWgWqp+vMVlWQ2iWil+m1Cglr4+REu8MOGb0bAHsw+ZF4F+YPxC6?=
 =?us-ascii?Q?k4Kj8HKmOpEW/i8XGQko6934BXX8/XtrNf0T9iYgm8d1MgRdEum08ZEOPUIn?=
 =?us-ascii?Q?qok7PKTtPyXDoduSDaynUe/5HGP/bkFzsPccYgfR?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d8ff147c-485a-4f58-11ab-08ddfc9e6fc0
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2025 01:45:56.8202
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oRGs8Y3HkaUW/z0KZXfcZtsa80GcQ2OzdUWh7gkB0l74D+UgqI3cfq2E3sHtj+Opjqn5xocM1kS01TPp0kziSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6903
X-OriginatorOrg: intel.com

On Thu, Sep 18, 2025 at 04:22:20PM -0700, Rick Edgecombe wrote:
> In the KVM fault path pagei, tables and private pages need to be
> installed under a spin lock. This means that the operations around
> installing PAMT pages for them will not be able to allocate pages.
> 
> Create a small structure to allow passing a list of pre-allocated pages
> that PAMT operations can use. Have the structure keep a count such that
> it can be stored on KVM's vCPU structure, and "topped up" for each fault.
> This is consistent with how KVM manages similar caches and will fit better
> than allocating and freeing all possible needed pages each time.
> 
> Adding this structure duplicates a fancier one that lives in KVM 'struct
> kvm_mmu_memory_cache'. While the struct itself is easy to expose, the
> functions that operate on it are a bit big to put in a header, which
> would be needed to use them from the core kernel. So don't pursue this
> option.
> 
> To avoid problem of needing the kernel to link to functionality in KVM,
> a function pointer could be passed, however this makes the code
> convoluted, when what is needed is barely more than a linked list. So
> create a tiny, simpler version of KVM's kvm_mmu_memory_cache to use for
> PAMT pages.
> 
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
> ---
>  arch/x86/include/asm/tdx.h  | 43 ++++++++++++++++++++++++++++++++++++-
>  arch/x86/kvm/vmx/tdx.c      | 16 +++++++++++---
>  arch/x86/kvm/vmx/tdx.h      |  2 +-
>  arch/x86/virt/vmx/tdx/tdx.c | 22 +++++++++++++------
>  virt/kvm/kvm_main.c         |  2 --
>  5 files changed, 72 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
> index 439dd5c5282e..e108b48af2c3 100644
> --- a/arch/x86/include/asm/tdx.h
> +++ b/arch/x86/include/asm/tdx.h
> @@ -17,6 +17,7 @@
>  #include <uapi/asm/mce.h>
>  #include <asm/tdx_global_metadata.h>
>  #include <linux/pgtable.h>
> +#include <linux/memory.h>
>  
>  /*
>   * Used by the #VE exception handler to gather the #VE exception
> @@ -116,7 +117,46 @@ int tdx_guest_keyid_alloc(void);
>  u32 tdx_get_nr_guest_keyids(void);
>  void tdx_guest_keyid_free(unsigned int keyid);
>  
> -int tdx_pamt_get(struct page *page);
> +int tdx_dpamt_entry_pages(void);
> +
> +/*
> + * Simple structure for pre-allocating Dynamic
> + * PAMT pages outside of locks.
> + */
> +struct tdx_prealloc {
> +	struct list_head page_list;
> +	int cnt;
> +};
> +
> +static inline struct page *get_tdx_prealloc_page(struct tdx_prealloc *prealloc)
> +{
> +	struct page *page;
> +
> +	page = list_first_entry_or_null(&prealloc->page_list, struct page, lru);
> +	if (page) {
> +		list_del(&page->lru);
> +		prealloc->cnt--;
> +	}
> +
> +	return page;
> +}
> +
> +static inline int topup_tdx_prealloc_page(struct tdx_prealloc *prealloc, unsigned int min_size)
> +{
> +	while (prealloc->cnt < min_size) {
> +		struct page *page = alloc_page(GFP_KERNEL);
> +
> +		if (!page)
> +			return -ENOMEM;
> +
> +		list_add(&page->lru, &prealloc->page_list);
> +		prealloc->cnt++;
> +	}
> +
> +	return 0;
> +}
> +
> +int tdx_pamt_get(struct page *page, struct tdx_prealloc *prealloc);
>  void tdx_pamt_put(struct page *page);
>  
>  struct page *tdx_alloc_page(void);
> @@ -192,6 +232,7 @@ static inline int tdx_enable(void)  { return -ENODEV; }
>  static inline u32 tdx_get_nr_guest_keyids(void) { return 0; }
>  static inline const char *tdx_dump_mce_info(struct mce *m) { return NULL; }
>  static inline const struct tdx_sys_info *tdx_get_sysinfo(void) { return NULL; }
> +static inline int tdx_dpamt_entry_pages(void) { return 0; }
>  #endif	/* CONFIG_INTEL_TDX_HOST */
>  
>  #endif /* !__ASSEMBLER__ */
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 6c9e11be9705..b274d350165c 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1593,16 +1593,26 @@ static void tdx_unpin(struct kvm *kvm, struct page *page)
>  static void *tdx_alloc_external_fault_cache(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_tdx *tdx = to_tdx(vcpu);
> +	struct page *page = get_tdx_prealloc_page(&tdx->prealloc);
>  
> -	return kvm_mmu_memory_cache_alloc(&tdx->mmu_external_spt_cache);
> +	if (!page)
> +		return NULL;
> +
> +	return page_address(page);
>  }
>  
>  static int tdx_topup_external_fault_cache(struct kvm_vcpu *vcpu)
>  {
>  	struct vcpu_tdx *tdx = to_tdx(vcpu);
> +	struct tdx_prealloc *prealloc = &tdx->prealloc;
> +	int min_fault_cache_size;
>  
> -	return kvm_mmu_topup_memory_cache(&tdx->mmu_external_spt_cache,
> -					  PT64_ROOT_MAX_LEVEL);
> +	/* External page tables */
> +	min_fault_cache_size = PT64_ROOT_MAX_LEVEL;

min_fault_cache_size = PT64_ROOT_MAX_LEVEL - 1?
We don't need to allocate page for the root page.

> +	/* Dynamic PAMT pages (if enabled) */
> +	min_fault_cache_size += tdx_dpamt_entry_pages() * PT64_ROOT_MAX_LEVEL;
> +
What about commenting that it's
tdx_dpamt_entry_pages() * ((PT64_ROOT_MAX_LEVEL - 1) + 1) ?
i.e.,
(PT64_ROOT_MAX_LEVEL  - 1) for page table pages, and 1 for guest private page.


> +	return topup_tdx_prealloc_page(prealloc, min_fault_cache_size);
>  }
>  
>  static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
> diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
> index cd7993ef056e..68bb841c1b6c 100644
> --- a/arch/x86/kvm/vmx/tdx.h
> +++ b/arch/x86/kvm/vmx/tdx.h
> @@ -71,7 +71,7 @@ struct vcpu_tdx {
>  	u64 map_gpa_next;
>  	u64 map_gpa_end;
>  
> -	struct kvm_mmu_memory_cache mmu_external_spt_cache;
> +	struct tdx_prealloc prealloc;
>  };
>  
>  void tdh_vp_rd_failed(struct vcpu_tdx *tdx, char *uclass, u32 field, u64 err);
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index c25e238931a7..b4edc3ee495c 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -1999,13 +1999,23 @@ u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page)
>  EXPORT_SYMBOL_GPL(tdh_phymem_page_wbinvd_hkid);
>  
>  /* Number PAMT pages to be provided to TDX module per 2M region of PA */
> -static int tdx_dpamt_entry_pages(void)
> +int tdx_dpamt_entry_pages(void)
>  {
>  	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
>  		return 0;
>  
>  	return tdx_sysinfo.tdmr.pamt_4k_entry_size * PTRS_PER_PTE / PAGE_SIZE;
>  }
> +EXPORT_SYMBOL_GPL(tdx_dpamt_entry_pages);
> +
> +static struct page *alloc_dpamt_page(struct tdx_prealloc *prealloc)
> +{
> +	if (prealloc)
> +		return get_tdx_prealloc_page(prealloc);
> +
> +	return alloc_page(GFP_KERNEL);
> +}
> +
>  
>  /*
>   * The TDX spec treats the registers like an array, as they are ordered
> @@ -2032,12 +2042,12 @@ static u64 *dpamt_args_array_ptr(struct tdx_module_args *args)
>  	return (u64 *)((u8 *)args + offsetof(struct tdx_module_args, rdx));
>  }
>  
> -static int alloc_pamt_array(u64 *pa_array)
> +static int alloc_pamt_array(u64 *pa_array, struct tdx_prealloc *prealloc)
>  {
>  	struct page *page;
>  
>  	for (int i = 0; i < tdx_dpamt_entry_pages(); i++) {
> -		page = alloc_page(GFP_KERNEL);
> +		page = alloc_dpamt_page(prealloc);
>  		if (!page)
>  			return -ENOMEM;
>  		pa_array[i] = page_to_phys(page);
> @@ -2111,7 +2121,7 @@ static u64 tdh_phymem_pamt_remove(unsigned long hpa, u64 *pamt_pa_array)
>  static DEFINE_SPINLOCK(pamt_lock);
>  
>  /* Bump PAMT refcount for the given page and allocate PAMT memory if needed */
> -int tdx_pamt_get(struct page *page)
> +int tdx_pamt_get(struct page *page, struct tdx_prealloc *prealloc)
>  {
>  	unsigned long hpa = ALIGN_DOWN(page_to_phys(page), PMD_SIZE);
>  	u64 pamt_pa_array[MAX_DPAMT_ARG_SIZE];
> @@ -2122,7 +2132,7 @@ int tdx_pamt_get(struct page *page)
>  	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
>  		return 0;
>  
> -	ret = alloc_pamt_array(pamt_pa_array);
> +	ret = alloc_pamt_array(pamt_pa_array, prealloc);
>  	if (ret)
>  		return ret;
>  
> @@ -2228,7 +2238,7 @@ struct page *tdx_alloc_page(void)
>  	if (!page)
>  		return NULL;
>  
> -	if (tdx_pamt_get(page)) {
> +	if (tdx_pamt_get(page, NULL)) {
>  		__free_page(page);
>  		return NULL;
>  	}
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index f05e6d43184b..fee108988028 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -404,7 +404,6 @@ int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
>  {
>  	return __kvm_mmu_topup_memory_cache(mc, KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE, min);
>  }
> -EXPORT_SYMBOL_GPL(kvm_mmu_topup_memory_cache);
>  
>  int kvm_mmu_memory_cache_nr_free_objects(struct kvm_mmu_memory_cache *mc)
>  {
> @@ -437,7 +436,6 @@ void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
>  	BUG_ON(!p);
>  	return p;
>  }
> -EXPORT_SYMBOL_GPL(kvm_mmu_memory_cache_alloc);
>  #endif
>  
>  static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
> -- 
> 2.51.0
> 

