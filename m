Return-Path: <kvm+bounces-56125-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A3CA7B3A37C
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 17:06:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 79EA49875DA
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 15:02:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF5CB261B9C;
	Thu, 28 Aug 2025 15:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M/gqv+tJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E3C1E0E1F;
	Thu, 28 Aug 2025 15:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756393322; cv=fail; b=BG6QRRFL4i9HUUzXSfLw+TRdxAp8+kWzkj41WSeifFzFH/wGdT8dD9e2ySNGmDTW9/0lG6F52Q5Rf3XQPMww8q0BMGoM33bRBHWJZTkkfS8EdfiFzlWNXLZYBkcYixC/v8As44aEDbuk+7xi96drAtvgeW2R6+U/+EA/qhI3ew4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756393322; c=relaxed/simple;
	bh=H+wd3oSgAhXlL+5QHeTppb5ytpKIuhhyGWuSEBqqYrU=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=HWQsOgI9o0rewsoteUf9906+MK5zodX6CQ1LQTIcIPLG4iA3u5SUFmdr7zyNp5998VtP2js7jYzB8C4p66WYHmR+4kKTPOiDbNlp8S3y+PwxYDvnVOMRFEP0o8laXmZ1kqe1k3sGDMUIDkUKO0YnRR5/TQkSFcO3/ipf2rvuTI0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M/gqv+tJ; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756393320; x=1787929320;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=H+wd3oSgAhXlL+5QHeTppb5ytpKIuhhyGWuSEBqqYrU=;
  b=M/gqv+tJqW9HOL565fS8diudoY8HEV78etbVwZdtXXjfvlv8poNqPgN8
   jDrjRT3OMmVWKHaYN9Hrc31/geWx4q7ob9KrBog9YmaTjyzhhsSBS3x6t
   zeq9U1P6U6C/hf9AAIu9DACyCZyD0RKESRVmN90VOFSu0tPtQQnkUzX5v
   t5PUFZp1lN4WA/KmyZPqGLcStRxnOHn4J2C+B2u0xv+BYG4yZa29FN/MQ
   G4pIgb8wQ5/x+0EI1bhy3vnT6o1APCB34ee6SjJKjOnT/nLmy/lccWkjt
   wInqFEK1rAt+HOaiCvcJ00f1rPh9PiG2aDH89eSuFjz5tCt2KmF7m6wh2
   w==;
X-CSE-ConnectionGUID: JIq8IsQZRfmDofVKQxs+WQ==
X-CSE-MsgGUID: R4M0pWogRPCzhZ9Yzvw7Zw==
X-IronPort-AV: E=McAfee;i="6800,10657,11536"; a="61297328"
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="61297328"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 08:01:47 -0700
X-CSE-ConnectionGUID: ywPSkNtGRp+04jsmCYOxEw==
X-CSE-MsgGUID: eqMFv40ZTx+/JaERr1lhYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="193796652"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 08:01:46 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 08:01:46 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 28 Aug 2025 08:01:46 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.77)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 08:01:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wrz3chbvjhtgQn3M7KTGR5ArTIj2Z2upjXbaFLets3ZiEBZ/SoT7yXcWni2cMDMO77AfmcYaR2yummBMy7tpB+ouJ/oPwjRZ4kV6BpQG8m+N1R1X03Ua/+DavQa/l80yEMsAYMaD5bw8kC318Mr/uqDIPdqFFcRJSuYP5maDxE61JF8j12xuKUArt43Zf9AxOp082VK4GNCWljNMkJyqqjJkR1+QmmRZr9sNubXMJ690vQsjkPvHtCyGVbU8VeifIwqBiEr9Ew4fm3SEVj1t6pN95nLVSg3BUX6WLNiXROM9XqaT+6wlQujWN/RZZwKIhN1PKyftetHdKWBjB3O1Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U3X0YQD09/J9ZH4jyDN+c8ONJ99emL4Qaes3vlCfRBQ=;
 b=xbAPpGuYyaoHYqRqRzLTW3bY1eBjlT/ofDmWEqod6gIoDuKf+9hgYpyvaB26k6jnOQv5Q4nLrgKVquyb8AXKSZC1sy4lSiAZCttsO8n9CGumamZO54s7hRARwBYKYNT+us/UjwJ0sA0Xa/GdEg9/8N1RkKJRBONRgBGjLJavQVHpQFtxMsHvcsYhiUtgXkCiml5CHVVMxA8y6xe07wetrsIJLed9OeRx3EHHrq4Xgm4LOoN6wOiH6j5Gisw6jftu/T/DBMMhnwoiJgArQU/NbYsaYJoi52/jvwWuvjsau4ZbnDz/ONbTECvIP9IkSVa6mm5ZPAGAuumkqSAKkPitlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by DM4PR11MB7279.namprd11.prod.outlook.com
 (2603:10b6:8:109::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Thu, 28 Aug
 2025 15:01:35 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::bbd5:541c:86ba:3efa]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::bbd5:541c:86ba:3efa%7]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 15:01:35 +0000
Date: Thu, 28 Aug 2025 10:03:22 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Michael Roth
	<michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, Ira Weiny
	<ira.weiny@intel.com>, Vishal Annapurve <vannapurve@google.com>, "Rick
 Edgecombe" <rick.p.edgecombe@intel.com>
Subject: Re: [RFC PATCH 08/12] KVM: TDX: Use atomic64_dec_return() instead of
 a poor equivalent
Message-ID: <68b06fbaa32ad_2114829458@iweiny-mobl.notmuch>
References: <20250827000522.4022426-1-seanjc@google.com>
 <20250827000522.4022426-9-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250827000522.4022426-9-seanjc@google.com>
X-ClientProxiedBy: MW2PR16CA0045.namprd16.prod.outlook.com
 (2603:10b6:907:1::22) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|DM4PR11MB7279:EE_
X-MS-Office365-Filtering-Correlation-Id: 865f826f-b3ec-4911-2b95-08dde643c7f5
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?qc9oPyGoJh6WcotiaVud84BOOcO46xkQFG62LKDpA4GUS/f7HMWSklxTSwoL?=
 =?us-ascii?Q?6BSmA3J2ejoff73zK2EHnLdo5NgZ4cSPpfJ1Cs4jZwzfocj3C7xc4vWDcsBA?=
 =?us-ascii?Q?H0zmaXrG3Q9CNEvuGiajlRrV/Quh4lPQ5bzc8hS2LsOzSJz0XfXpowgQAiMU?=
 =?us-ascii?Q?Wwo9rXM9JgxY3RnHBWcl4uP6euGPCRhKuKoxinqoJiuMTROYXlOBRodYKRhY?=
 =?us-ascii?Q?9m8a5MtSadXdceS0Eh1wOBXpGByImXpbjQyW2Lzh0dyd15tXB71TkEA/OHuQ?=
 =?us-ascii?Q?e0APYKIDolOVS2xoIx80xLAecOVW8/7Aq+3RB3xj1eSXbMF3sIOblj71rQ1b?=
 =?us-ascii?Q?Ppa8BxWpnVlTy9jrjv55yG5wrqha1lB9QipnKg+FFQPCPm/8TUxLpN7zg6sE?=
 =?us-ascii?Q?hltHjn7I6CbuGgtXvBvIZQ2ISNAx9UecxXJVcc+4y9EU7DGP3pzke159cKbX?=
 =?us-ascii?Q?9AnDZo6MndK1zlCLA4uwmDPABcWSoNv8IhI6MzcCkSkawo29mMXdbbuk0yrM?=
 =?us-ascii?Q?p2zgwglSnxSo5pnsxCH2HOoxnuxmrouRO2CVaB8z3iyrMC6Gp18acS7XME+X?=
 =?us-ascii?Q?dYS79LRBuLXCt7nblnhHTnNYs/atok1Vwvhdo7UOJnBTkB7jC2APIzibyibP?=
 =?us-ascii?Q?F36phD16OSzYJV+2UNSZroWorb8HB96s8i0io9Iz1qxl0MUcs5eiyqOibyJB?=
 =?us-ascii?Q?g8Q+yFVmCubLPv+iACxUxbap9SpMoEGpaDzFQF50tMimmuJwd1t4HAQEsYO0?=
 =?us-ascii?Q?MKZAr2O2D9wfjKA88z3o+elEDKvcRAXuCiglDpeM+T3w7t85hLKWgZSPrjmO?=
 =?us-ascii?Q?E2AauT7fAz9ADTcTNVwHO2LrRkPi76OSEbdwuvOyORKbmB23OFqniHi7FxJI?=
 =?us-ascii?Q?LUpgP3/ZVMr5VTriQxuEj2ujPVIUgxfxcw1N6fRl8qjPcFoown/zlIUNn6Kl?=
 =?us-ascii?Q?WL13gXsfbbN9pKdG+Icqs6dIAjVIp5c3hjUUcrc5QlxwuFz46fhJQ4/E/y1f?=
 =?us-ascii?Q?AV5aXvtAO01kJ5BlYB9d9yLNybiBQfNQQyDVJ6oeoIsJbxSzW+PRQyDnlU2a?=
 =?us-ascii?Q?uAHfhBGFygm9ixKSNyFKisUs2ne8w2ZUX0wzQ6Q87dGRFyjyCqImFcrpj2C4?=
 =?us-ascii?Q?3oYLNhhMryLhXlRNXOti5oLBk3PxhhgEv/S7Pqa+cLhVrWoi8mY19Z7PiHq+?=
 =?us-ascii?Q?pdGFeug80+aCelg0JKU7oq348y0uG/A365oxsxld/4rJLP18UI2Zz8WKIFCU?=
 =?us-ascii?Q?d0hbc+de8ngzm7SpDY40SdUXfcgEbanqI2MfMLuyUYpAz4mvdXMbErMU1QFp?=
 =?us-ascii?Q?qMUiYmb9viivFRQioiHWy8Rok2+tK+taaHzg358SZAapRNc7cU4kAIvldZVi?=
 =?us-ascii?Q?gud49F1a3fMC5/ZBN5Nk4HXmK1Ty5pPEBCnZBBNttn4484H/GsJ7ZsBH4ltm?=
 =?us-ascii?Q?3J0c9YJpRIA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?O2OI73ju352aXXINDX4xVoOTO1ZtZTKDdWRjiozb/5aHiWAhnkVM45xtqTqt?=
 =?us-ascii?Q?js24u4WpLbZ8avG0ocQSgL1yVeK2AHMIRz+ys5kT1vuSH1u/r0T+jQGHsw5a?=
 =?us-ascii?Q?+XFiN3OC08uv+nHYSv+/NgwlFyIXUH7YgJLGjNWIlOkbSxxZf/Ju240HSp+n?=
 =?us-ascii?Q?VMV4NGRCBP6IXvnRfEv3coHZ0T9pfl3MQUVdjo8yx/CGcd2lQDzKenFTV6NQ?=
 =?us-ascii?Q?FIZGntsYXttDqKdLKOeEjV8zmIT05emtSfxB+aGScwL3qXFMphJVqfXle7o7?=
 =?us-ascii?Q?z5eL1uMYTU9ixL+YQey7+juAIarVaZ/t/EaRrurmiQzA4gse5nlLzlulPUXJ?=
 =?us-ascii?Q?vBZC4AeNgzSjYVYLRV29PvmwgnGSXvF9wA5YtDOKQn5H4o0S8vtLnZowb9wo?=
 =?us-ascii?Q?IkbPTCzDTOQH6kL09oFRXkGhZSsKzxfhhIb+3dZI/zvQx0yIz+kpleT3kfXB?=
 =?us-ascii?Q?+S1F4d+iRtsQzbrh6vqcJ325MOfjdM6JkIBPp8ypTxibsjknXyqPW6gYbVV0?=
 =?us-ascii?Q?xkS61eHQCxe4vS5+LvRTy9KnPvugVDK4ebCmPTDJPzGBKQK4HIdNz3uXeTye?=
 =?us-ascii?Q?M1Zr4Tfce7LiGQPJlHFhDzezSw7KlO9XnJxw0sEFzf+fntp8hB4KM5AO2DXV?=
 =?us-ascii?Q?XgQZkT7myvb1zxz6bRCYlcxu4zULlQ3FbzPvIi3WMj1/N7OLG3DwYAinfC2J?=
 =?us-ascii?Q?bFnVIESDPfHaE89/hRrKB2B0PGWzcXcfw3XDLeTkMmSoQ9VRexyZuEtOEsLX?=
 =?us-ascii?Q?K/xPRAIzRyfL2RD3XTfZiai7A8EeDyzdPBnGHgzyG6lDmS7F8nlARAdlI1Wk?=
 =?us-ascii?Q?2mJPd/T/Y6dYuPtPlmuXCfsUHGIHfkxcYOmYwwA+0mN6QeyxNq1E4M1zYLJt?=
 =?us-ascii?Q?S9tQEl2Mj4Ttkqj6ysKPfTXH2RTgCnr3pS+zyDfaehfHCJcBnCQMz/BvSFSJ?=
 =?us-ascii?Q?eyS82/lodyB3KhMpkUlrmqr1+IoggCaE9tpye8kTFv4F9/7kecwNVJI+SZoS?=
 =?us-ascii?Q?5Znt8B+AyR7TTPKtVbKcH1NDsLl17K+ujMTixXi4rfFscKCmIFCZNVKg+wBO?=
 =?us-ascii?Q?aD8TCrpQ4mVdZSEIqrqMBkmoumd9t6TCQxDA8UogmEYIWozaHiLn2l8zjsy0?=
 =?us-ascii?Q?nDeyVlHeWphQ+Mp/Z5jH5Vyc2KBd9EdKYQJkvU+lu4X/UzBulpghEgwslaQ0?=
 =?us-ascii?Q?sfOv7+sg3jYUA2W2RUh26FUJc9enAZRabT0BSRenZBO8e4HOj0jcRXbwDM4h?=
 =?us-ascii?Q?dQ5V8glQRDNz1BS2F0M5y9KB2650KxuAf7g1Jeh/Khl6xENGFWA2Acas3kaM?=
 =?us-ascii?Q?5KHnf8UPXB26t/S+NXTHt683YfdGVTgtVHSngzKtUja8UkbLZ5IR4ZTKdATK?=
 =?us-ascii?Q?ED/BDVc0wwFECUOMTiJV4sqPPV55J0zutTX0TbH/txXzePXC7sZ9G4EGHBif?=
 =?us-ascii?Q?pmUsOKXbPYj4lgrC0GKqN3XnAPSpAkQGbGEEY1/uQU9O7y4An9jeGKS0qk/S?=
 =?us-ascii?Q?2vbJQwFUzHPm8axTgypYPBvf7Ga6YQlP1tBsE8OCZgg1j2dZrwDP7s/CbZ+i?=
 =?us-ascii?Q?uVLsdqVKHgbiHxGP++jhBnBexJchbSsyxLxq79ze?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 865f826f-b3ec-4911-2b95-08dde643c7f5
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 15:01:35.0299
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S/Y90fHWvg8EQUOJBauzWR7npxj+jPSsQnuEQ5pNXsSl8aOdt1oZzef/sC8n9zZoOmEDV9oRk0Hm91xdFUBm9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7279
X-OriginatorOrg: intel.com

Sean Christopherson wrote:
> Use atomic64_dec_return() when decrementing the number of "pre-mapped"
> S-EPT pages to ensure that the count can't go negative without KVM
> noticing.  In theory, checking for '0' and then decrementing in a separate
> operation could miss a 0=>-1 transition.  In practice, such a condition is
> impossible because nr_premapped is protected by slots_lock, i.e. doesn't
> actually need to be an atomic (that wart will be addressed shortly).
> 
> Don't bother trying to keep the count non-negative, as the KVM_BUG_ON()
> ensures the VM is dead, i.e. there's no point in trying to limp along.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

[snip]

