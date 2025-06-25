Return-Path: <kvm+bounces-50620-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 92B26AE784D
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 09:17:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3773E5A4771
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 07:14:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2531320102B;
	Wed, 25 Jun 2025 07:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LLXjGJ5l"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7B2258CC4;
	Wed, 25 Jun 2025 07:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750835470; cv=fail; b=hFK9QbmmBHa0aVF67fmS2CTf2HuhTZaQk5mruusvfRiYnEHScfdiz0izTnOH4bKU4kdZbdbcVeMyoqp38jRhjYQIZuVMBcLHiZIYDV3F0edN2H8C+6jcTg562Ng6DRG6xkSPwqV8wffaOXHHYitlOiI9lZzy6x3eZerUB8TnmIo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750835470; c=relaxed/simple;
	bh=MigJe81znybV6IuVvzkHoxWeoJYH60X7azkDcUooyT8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=HRaGpt8OQi8I2Hj8QulXsTAjPCfblFX8rPvvT8f9s6Os5+9OdXCvOe4uftfZofjQcZKLXvyCD1T51ITF/OWQCtha4tg0j+OWTxxC456SbbwsT1sGfbHAIOdWpd9LujtmIQx2H8Y6zV+fcOQEqnBwUkuGeEiPpQZ9vYWjsKk/Ol8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LLXjGJ5l; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750835468; x=1782371468;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=MigJe81znybV6IuVvzkHoxWeoJYH60X7azkDcUooyT8=;
  b=LLXjGJ5l3xRUzzWnCrrsFQgAqOM5p1ALLtzWrcF21ZghX2d2tgXrVADh
   9s9XfYfspUODZTnL4gIJyHVsaeBiHs/Fa+ujGCVLynVYnR00plf2JtyQL
   WY/9PwuiReXh3EjCjQc/fNw5TlCx0AY7dS+xcndkZaRojKAIRpGHBqWOa
   z7uPAQtaQOF9MuCDO3wtneFi4zo4FnSQkMEC6yDXVN+/xgSJPeVGKLNkd
   Fah2Oo9ta2U9fgiviJ6fw7CI1ggo5yKSMhUYFhjeGfv4icDN1M9jg2Lhl
   iWFj06wPPYuJ6g25FGOZOCp1h7+mE9mmWfYsFYUBipO3Jf+iSlc974b3c
   w==;
X-CSE-ConnectionGUID: hBKyneCLT7Smhyywi0mWYw==
X-CSE-MsgGUID: fb27KPyoQza0e2FOIlFCiA==
X-IronPort-AV: E=McAfee;i="6800,10657,11474"; a="75631083"
X-IronPort-AV: E=Sophos;i="6.16,264,1744095600"; 
   d="scan'208";a="75631083"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 00:11:08 -0700
X-CSE-ConnectionGUID: z2irc/fpRImIONten7Ztvg==
X-CSE-MsgGUID: a0t1BrwKS/OAHWxd+Hwn8w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,264,1744095600"; 
   d="scan'208";a="151884476"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 00:11:08 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 00:11:07 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 25 Jun 2025 00:11:07 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.86)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 00:11:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XF6GOBo0UIcJgM30+CSgfZehav8seiTjvv4qk7NvKkAiVXXegAmDvkLaMRRrXQYcya281IKBqs8ASt9gfqnMO4KHMYXoefgDqgVw5meR2v9YgmW/Ir4zXq33XtmIUakXNV/vk7LOQ2ERsjdhKe0Eq9MPJaRLNmlNH5GEnjJKOKQnrKvX3x1IE4C6HTyw+PjoX4rAa7AYXzUnzCPAwZ1M3kRaezGaZTz1hplU6nbLDUIKA2+rGvyYicptNNhrp47TdGFSGxLymDRp+BLa2aMIWQFHpLhKSWDxJntiK62dNHnb8BFYwi3/ZIolWgSUjxLHW7W/kwg9imKMTi84N7j2pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MVknbu8fzUmEV6c/I4VFe85Rqg8T/KBG7Kjyrj/e+ag=;
 b=UbnmWV+oLeV0uuM65GqX2S7FTm+ekE01HgIs2Ex3cM+m31htpqncLlkeOjxXHg1iSFkJ2IoNzCvfbHgSyC1a1P7fG78ImcU0XKkfsHyMhaXUqVpf2lGiIz0sa3G454xvNZiByQH5ljfbvEXwJKnhZW/Mm44jCFnScSVmGN0atZgODnYZxH9yFMFUlIa9CiKMbb0or9oz/8CNy4PvkNTenX+0D3FiGWIe9EF01hNpBcdqakXM4o9A5UM/pyhYAAxqg8UU5+0B3EZjsHzYTWm0D0OfSAGDZPvS4RyWNrhU1KPdWWu7xQpL8i7L8NBolGHJmEuwxui3OkMOPD8DHfWx/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CYYPR11MB8306.namprd11.prod.outlook.com (2603:10b6:930:c6::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8857.27; Wed, 25 Jun 2025 07:11:03 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8857.025; Wed, 25 Jun 2025
 07:11:03 +0000
Date: Wed, 25 Jun 2025 15:08:28 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Ackerley Tng <ackerleytng@google.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Du, Fan" <fan.du@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "Shutemov, Kirill"
	<kirill.shutemov@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Annapurve, Vishal"
	<vannapurve@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 08/21] KVM: TDX: Increase/decrease folio ref for huge
 pages
Message-ID: <aFugbDVJJDrK4n9V@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <9169a530e769dea32164c8eee5edb12696646dfb.camel@intel.com>
 <aFDHF51AjgtbG8Lz@yzhao56-desk.sh.intel.com>
 <6afbee726c4d8d95c0d093874fb37e6ce7fd752a.camel@intel.com>
 <aFIGFesluhuh2xAS@yzhao56-desk.sh.intel.com>
 <0072a5c0cf289b3ba4d209c9c36f54728041e12d.camel@intel.com>
 <aFkeBtuNBN1RrDAJ@yzhao56-desk.sh.intel.com>
 <draft-diqzh606mcz0.fsf@ackerleytng-ctop.c.googlers.com>
 <diqzy0tikran.fsf@ackerleytng-ctop.c.googlers.com>
 <c69ed125c25cd3b7f7400ed3ef9206cd56ebe3c9.camel@intel.com>
 <diqz34bolnta.fsf@ackerleytng-ctop.c.googlers.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <diqz34bolnta.fsf@ackerleytng-ctop.c.googlers.com>
X-ClientProxiedBy: SI2PR01CA0037.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::9) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CYYPR11MB8306:EE_
X-MS-Office365-Filtering-Correlation-Id: 50e920e0-a853-41a6-4c84-08ddb3b771cd
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|13003099007;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?vqLZoQqpLGfcn7PnEfI6OAQ/F+yHSX3Cinp+lA0sj5wYf3XWNtKK/pyjmJ?=
 =?iso-8859-1?Q?UVGxY+t+MT8rGprcYumdtAoXPR+Y1WN1GvDsrUpVL+ajuAp63F8a6sf+DL?=
 =?iso-8859-1?Q?1dllTIJH1SbECcwsuDNbwLSDL2hICrITgU8/umaN4LFQw0HxGPukuxMfZh?=
 =?iso-8859-1?Q?7TODuHrQTm3wum3qo+t6XXFyJ61QqhtN62gwAK971ivrLNAiBLozrkwnLe?=
 =?iso-8859-1?Q?1B4elRcT6GNC12LEM5dLxZuqAgure761h+/mkrTFSRB448WyMdIQbL2976?=
 =?iso-8859-1?Q?jC8vv31P3F4bd1QAlcd02SvY1zlH3JvBuQO0QWDKh1XE23mEHRVaK1vlvF?=
 =?iso-8859-1?Q?CJ75TpcEAv8MLhctGTKJ/NKwu2mungOyCquUQW1vBcq1tYHpzKMFFdB83o?=
 =?iso-8859-1?Q?C64+2NeVU9f0MUugaExOvu6QTHXSdQXHk5PexfXBugTcSrScoB/Uwb+U8h?=
 =?iso-8859-1?Q?cvGT6KRxh25i/nx6StXkb4MJy3VZ1Va/P682x3dn3n4/hynNg7M7RYMc1b?=
 =?iso-8859-1?Q?Va99owwwjANaEX+paTnE+Ga/TYnDX6hwD+RYe5hr36cEutRBPL/ot7AkRq?=
 =?iso-8859-1?Q?CX20R6Yidb72Cxk7ApSvLseK9A1osS+rL4uGIC/l2n99CoIImsZRvMrSK9?=
 =?iso-8859-1?Q?19Lu1JFhM3RpBgoul2jvW6Rgi7RQ2Owl3uImkMo56BteZ/oCwnYia5+sAf?=
 =?iso-8859-1?Q?1RoEJtjv0dSMOKKU/o4xq6G8uwaQZvwZDVxMjbNiMmuJ3JbDHdiRfqp8oO?=
 =?iso-8859-1?Q?/cPHfGl1RJtC4iCcwlj4NlG7WPkNtw02+DbjhOkF6GlBnFnMTC+SGeH1wS?=
 =?iso-8859-1?Q?6sBeDPu3TXY7tG2TPNvuDVk6jWrEhwT72JyzqwD8s23KpyuFVU/gKLGLRg?=
 =?iso-8859-1?Q?OyH/RPNd2O1hTQRnbn+K+r/Kf5pmfsllGIgGYFssB28WJL59NTN/YrwOJN?=
 =?iso-8859-1?Q?/p8aLrktGaha7CKSIu2aksCyEfvOVsMp+eIr5Lg2NEKiTnP2cwiF0PfE5M?=
 =?iso-8859-1?Q?BAVNfyblXIhDt+Qb98Cps7CRuUeyGl65II0Ltbw6bHeAwo3B/rrOaPE2qV?=
 =?iso-8859-1?Q?ckJXajlSZZI4YOEnajQwCkF3GQpdiMkzz1dA8m/1sVYjTmFrcKskuB+Bs/?=
 =?iso-8859-1?Q?9VKf6IFdhERt/1INIJDpiwtBUo7doq1HMeaeGM9u+419FtjqX14IJjU1Wt?=
 =?iso-8859-1?Q?IpFuDa+ko3svO/fpty0IP6VSRIdOGWvdy0oP+PXX7MJantN0xLSg85MwpU?=
 =?iso-8859-1?Q?b8uhWJBG+PH0gNjYk2+ZtLoM3Afjjy8YkAwuMGnFK7W8Pb8pnv9GSnyFvQ?=
 =?iso-8859-1?Q?iGDYNxRkptQGnMy+oY17irKCmzpTl78ywUZ3kJYJ+WCG9q5wsoS5caMS4w?=
 =?iso-8859-1?Q?A2MjRn4o4lHSCbJkfwfxDXH+scv3fYe4/UIT0o88SCKd8vMbbYBC2+kqxc?=
 =?iso-8859-1?Q?rzwrRmJOnnQK+9r2?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(13003099007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?fTR3r5p2YyrJoZO1NeYngJiSJ6dCqXKQqzyoxhHgEguiymCIWeX0W65DcI?=
 =?iso-8859-1?Q?/lIPO+32o9tDwQHGeZYDrvgeMI1L6UfPKhGiByvC6/msptJmoQ+HPiYWZ8?=
 =?iso-8859-1?Q?L71jdUNeiE4kGVcB/XNO6ajlrm4kbbWz0uJ5ittMkE0ViHXo6mrga2HS2/?=
 =?iso-8859-1?Q?pHe/ZjOBo6WmgLXHzjN/BBPPxnMTp5xRF+7ekR/vOYt/KGx/24/wx8dOMx?=
 =?iso-8859-1?Q?ywniV3waAa2+0noMDQQnD9Dc9AckER/pAZV90+dTtgkz/kr5kxp0RV4AyV?=
 =?iso-8859-1?Q?HZxhDZ007DqT7Bm0tkcMgHZIVuFjFIZO0ZVB1W5k1mXeBXTv7CXq5Kq/aV?=
 =?iso-8859-1?Q?lhw15HOa3ufpb3Gqb3qVO1VmWXeQ5lst5zs0p1+5uZ3K+qqvNQFAi3Dncv?=
 =?iso-8859-1?Q?C3m5pWA7VyjRb4J4fpzlV8kJRxAJIKTMgw3pm143+i4dLOX85TAwR2Mc39?=
 =?iso-8859-1?Q?kuoxlCuqYSgKDiEFWP6MBtLmLVeki/txL9N9MmuvcIMxBH8YG67UoFPUM6?=
 =?iso-8859-1?Q?m8c+lm3hzjoFg5APnF38wXsoqebTv+SbB2yb7eR+39TwZKSJpV+eT/gQ07?=
 =?iso-8859-1?Q?JiMD9i6e+1HFFDeG08wsLOTvBs/WVXp339fuXHSRG7W7liTbMfwGt7vdmi?=
 =?iso-8859-1?Q?d4T/wNFNVir8zv+NHav2bxE9/EvgTvesraaI+1pEfTdogkPEa/ZQUFkWTr?=
 =?iso-8859-1?Q?1Mal+oam1lHfwVVUyaBws9U8Kc7o9NMHxUcp0C0qMPCAC2jy7byKTHwV5P?=
 =?iso-8859-1?Q?CT0ofsKGD3bTiFubUkwGtUDKPUZotMj0MX+wKFevk18enSqD19t4t5a/Fe?=
 =?iso-8859-1?Q?BAHliZCIN0PY7ZJsNyHf971vjcDuMKpJKSoHGTLeyXCxAmw9zo1+3VcXlm?=
 =?iso-8859-1?Q?m932jgqz84bV7NeFYamdW7j1jPB/OfpY3wptT5HqCOcAR1zc/QljXBNXat?=
 =?iso-8859-1?Q?SuXxa2ALt+1QhGj2GOtwZjP21339kAXEfQf7jHcjipbvt5TevHmiCF143H?=
 =?iso-8859-1?Q?dYt8ePUguZFTpz1pbvCoZlN7MFKCosoTKjboAR8rrCfvxtWr5uw8J4psxt?=
 =?iso-8859-1?Q?1tUMJ+sPJgUn7A2IduVsI13VIxcJekKMrqoRMKsnluhMiUj8OUE/5YU5rf?=
 =?iso-8859-1?Q?7tUq8qb2KYmGAVwcqTTthnPCklO+tI+ABCKhHSwQ1/MFIkisfYwc0pERO9?=
 =?iso-8859-1?Q?lq+8r/4dN3xPPGw+mI32o8XdpM/U48ksSfHLoMydrZWYF9Mt747oilHkuX?=
 =?iso-8859-1?Q?ptnDUQgM7T+Qv01XdWUqnMQF2ZwNxk03XQ7KnYNWOoD09jSf4vz8gpUVID?=
 =?iso-8859-1?Q?IR5M33MdZeS8o7gnn/SiRzbv2I66dgp7e8TRofy6yWHT2RH2qS1bPPFhEN?=
 =?iso-8859-1?Q?fNiga2nAv8P7YkPP61WwBqTM3VbtAat7o+832CIfsy9P7jumoiQQ0KW5WM?=
 =?iso-8859-1?Q?CvahgCYIiqAEhBrn+niEXKkCciUSRip9ijZ5b6A447Pr3ugIU8TB7hpAMw?=
 =?iso-8859-1?Q?g3qV64jgqqj4qbQYjzcwN4cDvex+gklcGfCxgMzBYeMS+aW9n0Now+2XKn?=
 =?iso-8859-1?Q?EldMmtpOJyPO7O/1HnBPgLYCdZc6JEqYCIDN0kHaopRvNzfhZXu+pcIQkt?=
 =?iso-8859-1?Q?LOW5u5rwSfdl/aXVEIbHddWPLXRwvgNAto?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 50e920e0-a853-41a6-4c84-08ddb3b771cd
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2025 07:11:02.8437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nRKleMcq3y01cAh7PHHccLiRgLLtfr0ewCZRHXsYYiijqd4vy3GiCjmZiIDYBHdcvC5yAtvr2N3hUoleICNUuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR11MB8306
X-OriginatorOrg: intel.com

On Tue, Jun 24, 2025 at 04:30:57PM -0700, Ackerley Tng wrote:
> "Edgecombe, Rick P" <rick.p.edgecombe@intel.com> writes:
> 
> > On Mon, 2025-06-23 at 15:48 -0700, Ackerley Tng wrote:
> >> Let me try and summarize the current state of this discussion:
> >> 
> >> Topic 1: Does TDX need to somehow indicate that it is using a page?
> >> 
> >> This patch series uses refcounts to indicate that TDX is using a page,
> >> but that complicates private-to-shared conversions.
> >> 
> >> During a private-to-shared conversion, guest_memfd assumes that
> >> guest_memfd is trusted to manage private memory. TDX and other users
> >> should trust guest_memfd to keep the memory around.
> >> 
> >> Yan's position is that holding a refcount is in line with how IOMMU
> >> takes a refcount when a page is mapped into the IOMMU [1].
> >> 
> >> Yan had another suggestion, which is to indicate using a page flag [2].
> >> 
> >> I think we're in agreement that we don't want to have TDX hold a
> >> refcount while the page is mapped into the Secure EPTs, but taking a
> >> step back, do we really need to indicate (at all) that TDX is using a
> >> page?
> >> 
> >> In [3] Yan said
> >> 
> >> > If TDX does not hold any refcount, guest_memfd has to know that which
> >> > private
> >> > page is still mapped. Otherwise, the page may be re-assigned to other
> >> > kernel
> >> > components while it may still be mapped in the S-EPT.
> >> 
> >> If the private page is mapped for regular VM use as private memory,
> >> guest_memfd is managing that, and the same page will not be re-assigned
> >> to any other kernel component. guest_memfd does hold refcounts in
> >> guest_memfd's filemap.
> >> 
> >> If the private page is still mapped because there was an unmapping
> >> failure, we can discuss that separately under error handling in Topic 2.
> >> 
> >> With this, can I confirm that we are in agreement that TDX does not need
> >> to indicate that it is using a page, and can trust guest_memfd to keep
> >> the page around for the VM?
> >
> > Minor correction here. Yan was concerned about *bugs* happening when freeing
> > pages that are accidentally still mapped in the S-EPT. My opinion is that this
> > is not especially risky to happen here vs other similar places, but it could be
> > helpful if there was a way to catch such bugs. The page flag, or page_ext
> > direction came out of a discussion with Dave and Kirill. If it could run all the
> > time that would be great, but if not a debug config could be sufficient. For
> > example like CONFIG_PAGE_TABLE_CHECK. It doesn't need to support vmemmap
> > optimizations because the debug checking doesn't need to run all the time.
> > Overhead for debug settings is very normal.
> >
> 
> I see, let's call debug checking Topic 3 then, to separate it from Topic
> 1, which is TDX indicating that it is using a page for production
> kernels.
> 
> Topic 3: How should TDX indicate use of a page for debugging?
> 
> I'm okay if for debugging, TDX uses anything other than refcounts for
> checking, because refcounts will interfere with conversions.
> 
> Rick's other email is correct. The correct link should be
> https://lore.kernel.org/all/aFJjZFFhrMWEPjQG@yzhao56-desk.sh.intel.com/.
> 
> [INTERFERE WITH CONVERSIONS]
> 
> To summarize, if TDX uses refcounts to indicate that it is using a page,
> or to indicate anything else, then we cannot easily split a page on
> private to shared conversions.
> 
> Specifically, consider the case where only the x-th subpage of a huge
> folio is mapped into Secure-EPTs. When the guest requests to convert
> some subpage to shared, the huge folio has to be split for
> core-mm. Core-mm, which will use the shared page, must have split folios
> to be able to accurately and separately track refcounts for subpages.
> 
> During splitting, guest_memfd would see refcount of 512 (for 2M page
> being in the filemap) + 1 (if TDX indicates that the x-th subpage is
> mapped using a refcount), but would not be able to tell that the 513th
> refcount belongs to the x-th subpage. guest_memfd can't split the huge
> folio unless it knows how to distribute the 513th refcount.
In my POC, https://lore.kernel.org/all/aE%2Fq9VKkmaCcuwpU@yzhao56-desk.sh.intel.com/
kvm_gmem_private_has_safe_refcount() was introduce to check the folio ref count.
It rejects private-to-shared conversion after splitting and unmapping KVM's
secondary page tables if the refcount exceeds a valid threshold.

Though in
https://lore.kernel.org/all/aFJjZFFhrMWEPjQG@yzhao56-desk.sh.intel.com/, we
agreed that "EAGAIN is not the right code in case of "extra" refcounts held by
TDX", this does not imply that rejecting the conversion itself is incorrect.

This is why we are exploring alternative solutions instead of having TDX hold
the page refcount.

So, either a per-page flag, per-folio flag or solutions e,f,g should be good.

IMO, regardless of the final choice, guest_memfd needs to identify problematic
folios to:
- reject the private-to-shared conversion
- prevent further recycling after kvm_gmem_free_folio()

> One might say guest_memfd could clear all the refcounts that TDX is
> holding on the huge folio by unmapping the entire huge folio from the
> Secure-EPTs, but unmapping the entire huge folio for TDX means zeroing
> the contents and requiring guest re-acceptance. Both of these would mess
> up guest operation.
> 
> Hence, guest_memfd's solution is to require that users of guest_memfd
> for private memory trust guest_memfd to maintain the pages around and
> not take any refcounts.
> 
> So back to Topic 1, for production kernels, is it okay that TDX does not
> need to indicate that it is using a page, and can trust guest_memfd to
> keep the page around for the VM?
If the "TDX does not need to indicate that it is using a page" means "do not
take page refcount", I'm ok.

> >> 
> >> Topic 2: How to handle unmapping/splitting errors arising from TDX?
> >> 
> >> Previously I was in favor of having unmap() return an error (Rick
> >> suggested doing a POC, and in a more recent email Rick asked for a
> >> diffstat), but Vishal and I talked about this and now I agree having
> >> unmapping return an error is not a good approach for these reasons.
> >
> > Ok, let's close this option then.
> >
> >> 
> >> 1. Unmapping takes a range, and within the range there could be more
> >>    than one unmapping error. I was previously thinking that unmap()
> >>    could return 0 for success and the failed PFN on error. Returning a
> >>    single PFN on error is okay-ish but if there are more errors it could
> >>    get complicated.
> >> 
> >>    Another error return option could be to return the folio where the
> >>    unmapping/splitting issue happened, but that would not be
> >>    sufficiently precise, since a folio could be larger than 4K and we
> >>    want to track errors as precisely as we can to reduce memory loss due
> >>    to errors.
> >> 
> >> 2. What I think Yan has been trying to say: unmap() returning an error
> >>    is non-standard in the kernel.
> >> 
> >> I think (1) is the dealbreaker here and there's no need to do the
> >> plumbing POC and diffstat.
> >> 
> >> So I think we're all in support of indicating unmapping/splitting issues
> >> without returning anything from unmap(), and the discussed options are
> >> 
> >> a. Refcounts: won't work - mostly discussed in this (sub-)thread
> >>    [3]. Using refcounts makes it impossible to distinguish between
> >>    transient refcounts and refcounts due to errors.
> >> 
> >> b. Page flags: won't work with/can't benefit from HVO.
> >
> > As above, this was for the purpose of catching bugs, not for guestmemfd to
> > logically depend on it.
> >
> >> 
> >> Suggestions still in the running:
> >> 
> >> c. Folio flags are not precise enough to indicate which page actually
> >>    had an error, but this could be sufficient if we're willing to just
> >>    waste the rest of the huge page on unmapping error.
> >
> > For a scenario of TDX module bug, it seems ok to me.
> >
> >> 
> >> d. Folio flags with folio splitting on error. This means that on
> >>    unmapping/Secure EPT PTE splitting error, we have to split the
> >>    (larger than 4K) folio to 4K, and then set a flag on the split folio.
> >> 
> >>    The issue I see with this is that splitting pages with HVO applied
> >>    means doing allocations, and in an error scenario there may not be
> >>    memory left to split the pages.
> >> 
> >> e. Some other data structure in guest_memfd, say, a linked list, and a
> >>    function like kvm_gmem_add_error_pfn(struct page *page) that would
> >>    look up the guest_memfd inode from the page and add the page's pfn to
> >>    the linked list.
> >> 
> >>    Everywhere in guest_memfd that does unmapping/splitting would then
> >>    check this linked list to see if the unmapping/splitting
> >>    succeeded.
> >> 
> >>    Everywhere in guest_memfd that allocates pages will also check this
> >>    linked list to make sure the pages are functional.
> >> 
> >>    When guest_memfd truncates, if the page being truncated is on the
> >>    list, retain the refcount on the page and leak that page.
> >
> > I think this is a fine option.
> >
> >> 
> >> f. Combination of c and e, something similar to HugeTLB's
> >>    folio_set_hugetlb_hwpoison(), which sets a flag AND adds the pages in
> >>    trouble to a linked list on the folio.
> >> 
> >> g. Like f, but basically treat an unmapping error as hardware poisoning.
> >> 
> >> I'm kind of inclined towards g, to just treat unmapping errors as
> >> HWPOISON and buying into all the HWPOISON handling requirements. What do
> >> yall think? Can a TDX unmapping error be considered as memory poisoning?
> >
> > What does HWPOISON bring over refcounting the page/folio so that it never
> > returns to the page allocator?
> 
> For Topic 2 (handling TDX unmapping errors), HWPOISON is better than
> refcounting because refcounting interferes with conversions (see
> [INTERFERE WITH CONVERSIONS] above).
> 
> > We are bugging the TD in these cases.
> 
> Bugging the TD does not help to prevent future conversions from being
> interfered with.
> 
> 1. Conversions involves unmapping, so we could actually be in a
>    conversion, the unmapping is performed and fails, and then we try to
>    split and enter an infinite loop since private to shared conversions
>    assumes guest_memfd holds the only refcounts on guest_memfd memory.
We should bail out conversion even with the HWPOISON.
e.g.,
1. user triggers private-to-shared ioctl to convert 4K page A within a 2MB folio
   B to shared.
2. kvm_gmem_convert_should_proceed() executes kvm_gmem_split_private() and
   kvm_gmem_zap().
3. kvm_gmem_convert_should_proceed() checks kvm_gmem_has_invalid_folio()
   (Suppose TDX sets HWPOISON to page A or folio B after kvm_gmem_zap(), then
     kvm_gmem_has_invalid_folio() should return true).
4. Return -EFAULT.

If we allow the actual conversion to proceed after step 3, folio B will be split
into 4KB folios, with page A being converted to a shared 4KB folio, which
becomes accessible by userspace.

This could cause a machine check (#MC) on certain platforms. We should avoid
this scenario when possible.


> 2. The conversion ioctl is a guest_memfd ioctl, not a VM ioctl, and so
>    there is no check that the VM is not dead. There shouldn't be any
>    check on the VM, because shareability is a property of the memory and
>    should be changeable independent of the associated VM.
> 
> > Ohhh... Is
> > this about the code to allow gmem fds to be handed to new VMs?
> 
> Nope, it's not related to linking. The proposed KVM_LINK_GUEST_MEMFD
> ioctl [4] also doesn't check if the source VM is dead. There shouldn't
> be any check on the source VM, since the memory is from guest_memfd and
> should be independently transferable to a new VM.
> 
> [4] https://lore.kernel.org/lkml/cover.1747368092.git.afranji@google.com/T/

