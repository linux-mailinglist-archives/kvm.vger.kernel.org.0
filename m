Return-Path: <kvm+bounces-27547-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 019EA986E53
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 09:56:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 57B1E1F25069
	for <lists+kvm@lfdr.de>; Thu, 26 Sep 2024 07:56:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0BAA1A4B61;
	Thu, 26 Sep 2024 07:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bz0evsI7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 967711A4AA1;
	Thu, 26 Sep 2024 07:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727337349; cv=fail; b=YIM0Ml69Vk8ZA+p6UNU+MuwVKso+b8IGVFSA7G3UeHiDL5MesCQNEEF5amGfIE6EkHhTDegT2jGcGNKPX4BHYd4qCuzDfBlanG1SdvCD8AY/LfIGrous52FjcVbegsUpo57bnuRKh6i1VIwK3b8fLvVgbyEj3/WbOOEL2jAAx70=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727337349; c=relaxed/simple;
	bh=GfvuaSeKJWsQ+pTydfiwmcwBqIai1DkqCh3x+XPAY3A=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=A5CRRTpYGqsnTx9NTisNc4KaKl8deliUAk5oGd7yii4lH5+iEBFBOuIhqOdUh9GiyilU53oyu+rP93jE9CxkGfeRClOhQQBhJTomEhSOd/Ra7exvCactkylWOc1e/IRjvZp4SJtz9nzHEIWuQH7W3uPVgX3cttU57LiXmjKfUDI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bz0evsI7; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727337348; x=1758873348;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=GfvuaSeKJWsQ+pTydfiwmcwBqIai1DkqCh3x+XPAY3A=;
  b=bz0evsI7Yl0Yu+H8GWG48Z+ZL/lCnhdoyG55JgG6BDjuhL9UaJhsMHT4
   2+MyzL2vC9xfm8iZ0bJ4aZeLiU8vA03XT0iU2MSafCTD2gjXlc2VMvAA7
   OOerDxqxjenh7OaHvvlU5RGPJt/Dz92zHsJ4dGnch4yUHrrszjliQ/KIV
   Sc08XLUcyJsUCbt+HOPzB75C3X4TXt/C0c/xO5CuV0ycPwwLqY9C2Djvq
   4VDJZujlbpKNNoU4JojtNFVroTJgR0hyjLCWCumJWs3eNSHLvpnO6WRG1
   mk1Ui+v0BaGqLZCwDafTmGuPDDMThYH9yoxN8A48e7NAuXkYAk1w1gwEX
   Q==;
X-CSE-ConnectionGUID: KdQTh/C9RbmeJv5DmPqB9A==
X-CSE-MsgGUID: sadKFvjOT+CgSNeEOFT+Wg==
X-IronPort-AV: E=McAfee;i="6700,10204,11206"; a="14038574"
X-IronPort-AV: E=Sophos;i="6.10,259,1719903600"; 
   d="scan'208";a="14038574"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2024 00:55:37 -0700
X-CSE-ConnectionGUID: Ibj6AFdyRT6EY53Wk/RVJw==
X-CSE-MsgGUID: UjwzM3G7QmKVNl6h4yY6qg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,259,1719903600"; 
   d="scan'208";a="71720804"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Sep 2024 00:55:36 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 26 Sep 2024 00:55:36 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 26 Sep 2024 00:55:35 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 26 Sep 2024 00:55:35 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 26 Sep 2024 00:55:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MjASGjbArFFuUdH9iWYzwnC4/WR2gAYFM1eFJlwxNVq8OKCSF4RSKqa2+bjInVVEbhWl54XbFo2LkA6CYvsEZ7l3B/Q5mFYIr1wbGwG1Dd3FT2Uw8e1Alxxp+LSiXO6mUWqJO7/z3XRCJfOOuZ4ItRqThNljX7WebBNNqx5ffRCun8qz1NVMgYtqdKfmr7tR7XdLAab2cFJ6jzsBQjZVoc0Vlp6Q3GvHX7Axf6oQs6HHQUd1YXzbrtpVeMESJaBdvYcjlLCGi5CHEca8sbENPt7VcAlKS0IMh2O1fcwipI+XdSl0gTF7ozlz0tEYpIMRMelrcbbaUVMc3SAfQiwZuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2cTFNDTHbJxq2hlItLHE7iikeAC+HZ6B1rE7+4ac59E=;
 b=wFA3Xp7BbKimHLGMJW/rmGVlYi7DcdugglWdgK0/urWrNghxmLVWVa1cdvmkrMNaf2A8KmrD9uCzaXchJ6Islei6J6UBF6txRinoVn9qZa2y+1H8AwwApIqHMN8u2Cw8TmQ4EvjzxGC6fK/o0GNDRH2l8KSML8n/Y6PvXzI5fnwjaxNwAdTQbiwdml8yk5JDmVv6fhLcbNIwMLyDi0asQsN1oBwX1YWsQNWQNNIzXLFyxELV8QRQV3jprBJYrDesEBrH0zjZeV/hQXUZYhFtVNhdlZ6tgnSKgAR553aumhKdgZeGz6StZqoMqAbWfj6PwxLomR741XNm4pPN9KeV7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA2PR11MB5211.namprd11.prod.outlook.com (2603:10b6:806:fb::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7982.27; Thu, 26 Sep 2024 07:55:33 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7982.022; Thu, 26 Sep 2024
 07:55:33 +0000
Date: Thu, 26 Sep 2024 15:53:28 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Isaku Yamahata <isaku.yamahata@intel.com>, <kvm@vger.kernel.org>,
	<sagis@google.com>, <chao.gao@intel.com>, <pbonzini@redhat.com>,
	<rick.p.edgecombe@intel.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86/tdp_mmu: Trigger the callback only when an
 interesting change
Message-ID: <ZvUS+Cwg6DyA62EC@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <6eecc450d0326c9bedfbb34096a0279410923c8d.1726182754.git.isaku.yamahata@intel.com>
 <ZuOCXarfAwPjYj19@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZuOCXarfAwPjYj19@google.com>
X-ClientProxiedBy: SGXP274CA0001.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::13)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA2PR11MB5211:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d8cd974-6ee3-4219-42ed-08dcde009946
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?nq30n5q+PkWyljehacV8qKrNq7yR7HMuS7Lo54aomQpvIJjmCeYd/H6Jkf1l?=
 =?us-ascii?Q?TPyU7h/+QGAgacmZ9gY0qiSF0/va9lItfmTAxvqs98M6RB2JOVN07LDlF3P6?=
 =?us-ascii?Q?r+zgAWBENJfMJcAnzd5jTqjnUyo+0K0uxVac0Eu3uU3xZHyi1yaIlWqHh18r?=
 =?us-ascii?Q?mbmwjdW9ioQkJxDzxv/ZcqfYJGNFVG7XABj343BzfXpokJZW/i/YE7DahccY?=
 =?us-ascii?Q?rJlu1sZPNFCxr27uwLq5fF3Xl6OcoHW5VJM/Zxun/8iiAAEhYjet5ugWnr9d?=
 =?us-ascii?Q?ijhsYNPKT/mUBMIVndHbLygWwnFi89xzBIMzKi4Ocf0zZYTKOKvyhdAZmxET?=
 =?us-ascii?Q?axY95nXDUDO5diGw3XnUQ3w71i812cwLPqL7AT7VR/rjG6KKkjI8kpAqtmEN?=
 =?us-ascii?Q?IGdKZkQw/K5kSOmqSHnMZgYyVxM92qvKs/WKZG4bgsIYp3jTHnaJVje0QXZn?=
 =?us-ascii?Q?OaLO5Z7Nrsfm3/dIwu9QO87PBm/itCGgQO24u8V6hXo8Bn+EEOUrGy35qhHz?=
 =?us-ascii?Q?9jteHjZV/3jCUTNboypVrYMn//Y++PLGSZgtlSyaFpNa3Bg9WdoIaQjyPI6k?=
 =?us-ascii?Q?6qZJ44jUiykSRrfpwE2Pd/I9sWMWeSH0RJigTXMRgxOc6Bi8p47B0rf5fkNt?=
 =?us-ascii?Q?6YWqOBV9ODSDecyCA/gFb8y9RAqnRHYWszJjpVfbbY+ttIbpZeKxNLgiWJXY?=
 =?us-ascii?Q?7xu0xfo9q06fCtWF0F4MFd4jGMdBlFrXl8IpT3Q+/VNsmbR3ig/AqWkOUI12?=
 =?us-ascii?Q?Vzm+UYnwJg1tDcu/l/Psq4iJMCWC+xFBfBcXO9QZ9+Av8Oaa1l+skgmVd7rH?=
 =?us-ascii?Q?M/mImqU8hB5XpBJaVg8o/jU0YU8yX8ckpXh2KDVQOqyGzzOu2FcHiwuI/JSc?=
 =?us-ascii?Q?hPPZ4JPHuVlhrkhtcnmGQa4DHnR8B2qLGqasRNWtEzG+F8WXWb53DtxHfsGQ?=
 =?us-ascii?Q?GyRoW0wvc6JWBayZDAy444CbrwqEMZTxfHzNM8bSobmHXLrGuDCdYR0a5fNm?=
 =?us-ascii?Q?VaT/C8vNWwPe77bgsPbyFiY4Qrs+mzK7teVJv0UhE0efiTA+27B0s4BO4Kcp?=
 =?us-ascii?Q?3ftpsAfl9DmZl5RrcO9oaQ2V5cG+lowHLCnxupv2vNzcwB8SXP87TiCZQiNE?=
 =?us-ascii?Q?yglT1kxRGLg/C4lqDJnOVDK+u6ZvQv1yVul6W6jFxACgwQXpw0cvUKLK7jY0?=
 =?us-ascii?Q?KbIojGf+k5LGBynYVgqdtafKnA3jK/85qme/Fp+QOd9NS666ylj4E5NtgGMo?=
 =?us-ascii?Q?kl7pOwUr9ECoD4snFVXCnthQLTTSRa5+lJcTelROquPGgXyuprrw3sQ2vcQg?=
 =?us-ascii?Q?mV0qBrEwEFnvupIj0A5JXfRnquIptuohL+VT5XPRO/9MqA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IqfCY7M2oYB2/AxsVHWnc//7/GvBAMWRR0fmnu4PM+W4Vm68ME9QRFlz0Haw?=
 =?us-ascii?Q?2zX8gomBb7iKIOfjjaIq6e8w/RNTqt5OostlM6zwudKNvWHzsazIPrertBE8?=
 =?us-ascii?Q?rIs3yYbNf4gqYBFf4zzThtuFUh1z78ogrxv6dTjytbdjLjgG5+p1bGkhDp20?=
 =?us-ascii?Q?Iu+Q5G4RH27tHocj6cB1cpZc4b+ga0W6cnEbxaFetgoAuftkounjVISyELMI?=
 =?us-ascii?Q?v4twsAfq1FFBOnzNlQY1IxQJIVhNYnMY3rpk3Z28xka7T5n5+C/mIIcSJ7fK?=
 =?us-ascii?Q?s9aoIKHjxZeOkx+8aXhw/1MtnIM0Qfnh2IqHq7MYMvQuv4BE4PsnXVdJafRa?=
 =?us-ascii?Q?/9qpy5bCJKBZu7u1AzzaTZwecqbX8oVEVUygBWKEAsKu9kXPIdzIHoBOOQ7m?=
 =?us-ascii?Q?XW9INM94MF+mCmzlhVeepiQW3RzLF02es6ZEevNAyaZlDIIcdCvaqH6fX1fT?=
 =?us-ascii?Q?INH196ST4pX5MnRumd6had220xSIFzK4MfzPjiGRjISERrHp9H+1yRg9B9zV?=
 =?us-ascii?Q?NxAJHqS3jND+WzJwAedUV+KbNActmuy6sC/yJMEwEbYZ6HAIL3Ou2zpoCQ3V?=
 =?us-ascii?Q?TGEDgwdcXuCZvMhh6VtlMDgzUDNkTUdkES3lq58GCBSqHBS0BCUNM/Q0rBGC?=
 =?us-ascii?Q?2co8ZgYbRAMJ+vQxPySww47Dwc638T+dNV1R/XJ9DutsGVSCBtyhpb57A7jO?=
 =?us-ascii?Q?YlvqW8vFKckclu6dZJU12Q48xYY9ZeSa0gWrOk2LWpRU4HsFEuXxd5Tra0Dg?=
 =?us-ascii?Q?bIKAEqLLDt843s2Iu/KPS02LiGVJ7hrVNZ18vUQiQdcF9C24IVaqJbvYlTso?=
 =?us-ascii?Q?9w8M3dAp1KTOHp/wOPifodKFSExQAVdBPfUYCkLWLV44Cp4a6eBO15VqV8Ag?=
 =?us-ascii?Q?k6rhhtj5F67pxM0oX24j9FSRGKk3rVgSYi1oC2XKkxj0xhkmUfFtf7I+WsFy?=
 =?us-ascii?Q?agms7nFH+rgT/sEGYv6//TUHc8BBr3QDS3p6+U0f7CmYtGn9kel3xZkPSGap?=
 =?us-ascii?Q?VCjE6Sxh6MkM43rpoyQ74U6GqAL7DRO9+04UHEu8dTgaLyuRwzp7zn6adRgT?=
 =?us-ascii?Q?EbC5cUxjml0KBtSwCDx0RUzlm0kuIFWzhxtBHyunEuPfGh9S+h0Mw2EsuodJ?=
 =?us-ascii?Q?hd4/ZEYtEWs2lQaWMU0YOkGIpKHWEPPJCEvKJKaqGRaMOhTgTsVGl6zz1Gyk?=
 =?us-ascii?Q?uuhv5eT04ejXNT7tqHOkTlikmLnUqDWYJGLtfNHA2LLBN9m2mdkZH3F7S2uJ?=
 =?us-ascii?Q?c9cOMglZu/Kv27HSMPAA1TyXDXR6vUpuFV0qjgESLctW2ZkIs/ACWit32cnb?=
 =?us-ascii?Q?Di0EbVmHCIwMvR8FNidVCUvUUFguIZRnE9nOO3+BJXMT2H4l4oHdy4VKOoUN?=
 =?us-ascii?Q?uCDGdLAaSKdiK/0UChxE+ToJvqmaAkIPAGKTXSG/3kFTP278WHo0WgEzbx6R?=
 =?us-ascii?Q?cel2gtvCkIO82zV31FZKTCEzQpi9LzfHkrjK3zAQLs8nuiMXpMuqmjo79AUN?=
 =?us-ascii?Q?l0QO1ptgAFZvWoqCessBnXYqoVTdfAyFrpo9ELGHeTdSO+f/IW9DUlLbz92M?=
 =?us-ascii?Q?V2vmRCIf0ayhfUjzk/86+bt8YffTZcqOY7qXNqLo?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d8cd974-6ee3-4219-42ed-08dcde009946
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2024 07:55:33.3916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uTHyp229BGTa7DW4ZQHtqq89PNiWr1++LthyYV0KS8QTsxZFaVH8/iYnudRi2/Pw4oLGtUHgbnnaqysb0aK5Gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5211
X-OriginatorOrg: intel.com

On Thu, Sep 12, 2024 at 05:07:57PM -0700, Sean Christopherson wrote:
> On Thu, Sep 12, 2024, Isaku Yamahata wrote:
> > KVM MMU behavior
> > ================
> > The leaf SPTE state machine is coded in make_spte().  Consider AD bits and
> > the present bits for simplicity.  The two functionalities and AD bits
> > support are related in this context.  unsync (manipulate D bit and W bit,
> > and handle write protect fault) and access tracking (manipulate A bit and
> > present bit, and hand handle page fault).  (We don't consider dirty page
> > tracking for now as it's future work of TDX KVM.)
> > 
> > * If AD bit is enabled:
> > D bit state change for dirty page tracking
> > On the first EPT violation without prefetch,
> > - D bits are set.
> > - Make SPTE writable as TDX supports only RXW (or if write fault).
> >   (TDX KVM doesn't support write protection at this state. It's future work.)
> > 
> > On the second EPT violation.
> > - clear D bits if write fault.
> 
> Heh, I was literally just writing changelogs for patches to address this (I told
> Sagi I would do it "this week"; that was four weeks ago).
> 
> This is a bug in make_spte().  Replacing a W=1,D=1 SPTE with a W=1,D=0 SPTE is
> nonsensical.  And I'm pretty sure it's an outright but for the TDP MMU (see below).
> 
> Right now, the fixes for make_spte() are sitting toward the end of the massive
> kvm_follow_pfn() rework (80+ patches and counting), but despite the size, I am
> fairly confident that series can land in 6.13 (lots and lots of small patches).
> 
> ---
> Author:     Sean Christopherson <seanjc@google.com>
> AuthorDate: Thu Sep 12 16:23:21 2024 -0700
> Commit:     Sean Christopherson <seanjc@google.com>
> CommitDate: Thu Sep 12 16:35:06 2024 -0700
> 
>     KVM: x86/mmu: Flush TLBs if resolving a TDP MMU fault clears W or D bits
>     
>     Do a remote TLB flush if installing a leaf SPTE overwrites an existing
>     leaf SPTE (with the same target pfn) and clears the Writable bit or the
>     Dirty bit.  KVM isn't _supposed_ to clear Writable or Dirty bits in such
>     a scenario, but make_spte() has a flaw where it will fail to set the Dirty
>     if the existing SPTE is writable.
>     
>     E.g. if two vCPUs race to handle faults, the KVM will install a W=1,D=1
>     SPTE for the first vCPU, and then overwrite it with a W=1,D=0 SPTE for the
>     second vCPU.  If the first vCPU (or another vCPU) accesses memory using
>     the W=1,D=1 SPTE, i.e. creates a writable, dirty TLB entry, and that is
>     the only SPTE that is dirty at the time of the next relevant clearing of
>     the dirty logs, then clear_dirty_gfn_range() will not modify any SPTEs
>     because it sees the D=0 SPTE, and thus will complete the clearing of the
>     dirty logs without performing a TLB flush.
But it looks that kvm_flush_remote_tlbs_memslot() will always be invoked no
matter clear_dirty_gfn_range() finds a D bit or not.

kvm_mmu_slot_apply_flags
  |kvm_mmu_slot_leaf_clear_dirty
  |  |kvm_tdp_mmu_clear_dirty_slot
  |    |clear_dirty_gfn_range
  |kvm_flush_remote_tlbs_memslot
     
>     Opportunistically harden the TDP MMU against clearing the Writable bit as
>     well, both to prevent similar bugs for write-protection, but also so that
>     the logic can eventually be deduplicated into spte.c (mmu_spte_update() in
>     the shadow MMU has similar logic).
>     
>     Fix the bug in the TDP MMU's page fault handler even though make_spte() is
>     clearly doing odd things, e.g. it marks the page dirty in its slot but
>     doesn't set the Dirty bit.  Precisely because replacing a leaf SPTE with
>     another leaf SPTE is so rare, the cost of hardening KVM against such bugs
>     is negligible.  The make_spte() will be addressed in a future commit.
>     
>     Fixes: bb18842e2111 ("kvm: x86/mmu: Add TDP MMU PF handler")
>     Cc: David Matlack <dmatlack@google.com>
>     Cc: stable@vger.kernel.org
>     Signed-off-by: Sean Christopherson <seanjc@google.com>
> 
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 3b996c1fdaab..7c6d1c610f0e 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -1038,7 +1038,9 @@ static int tdp_mmu_map_handle_target_level(struct kvm_vcpu *vcpu,
>         else if (tdp_mmu_set_spte_atomic(vcpu->kvm, iter, new_spte))
>                 return RET_PF_RETRY;
>         else if (is_shadow_present_pte(iter->old_spte) &&
> -                !is_last_spte(iter->old_spte, iter->level))
> +                (!is_last_spte(iter->old_spte, iter->level) ||
> +                 (is_mmu_writable_spte(old_spte) && !is_writable_pte(new_spte)) ||
> +                 (is_dirty_spte(old_spte) && !is_dirty_spte(new_spte))))
Should we also check is_accessed_spte() as what's done in mmu_spte_update()?

It is possible for make_spte() to make the second spte !is_dirty_spte(), e.g.
the second one is caused by a KVM_PRE_FAULT_MEMORY ioctl.

>                 kvm_flush_remote_tlbs_gfn(vcpu->kvm, iter->gfn, iter->level);
>  
>         /*
> ---
> 
> >  arch/x86/kvm/mmu/spte.h    |  6 ++++++
> >  arch/x86/kvm/mmu/tdp_mmu.c | 28 +++++++++++++++++++++++++---
> >  2 files changed, 31 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
> > index a72f0e3bde17..1726f8ec5a50 100644
> > --- a/arch/x86/kvm/mmu/spte.h
> > +++ b/arch/x86/kvm/mmu/spte.h
> > @@ -214,6 +214,12 @@ extern u64 __read_mostly shadow_nonpresent_or_rsvd_mask;
> >   */
> >  #define FROZEN_SPTE	(SHADOW_NONPRESENT_VALUE | 0x5a0ULL)
> >  
> > +#define EXTERNAL_SPTE_IGNORE_CHANGE_MASK		\
> > +	(shadow_acc_track_mask |			\
> > +	 (SHADOW_ACC_TRACK_SAVED_BITS_MASK <<		\
> > +	  SHADOW_ACC_TRACK_SAVED_BITS_SHIFT) |		\
> 
> Just make TDX require A/D bits, there's no reason to care about access tracking.
If KVM_PRE_FAULT_MEMORY is allowed for TDX and if
cpu_has_vmx_ept_ad_bits() is false in TDX's hardware (not sure if it's possible),
access tracking bit is possbile to be changed, as in below scenario:

1. KVM_PRE_FAULT_MEMORY ioctl calls kvm_arch_vcpu_pre_fault_memory() to map
   a GFN, and make_spte() will call mark_spte_for_access_track() to
   remove shadow_acc_track_mask (i.e. RWX bits) and move R+X left to
   SHADOW_ACC_TRACK_SAVED_BITS_SHIFT.
2. If a concurrent page fault occurs on the same GFN on another vCPU, then
   make_spte() in that vCPU will not see prefetch and the new_spte is
   with RWX bits and with no bits set in SHADOW_ACC_TRACK_SAVED_MASK.

> 
> > +	 shadow_dirty_mask | shadow_accessed_mask)
> > +
> >  /* Removed SPTEs must not be misconstrued as shadow present PTEs. */
> >  static_assert(!(FROZEN_SPTE & SPTE_MMU_PRESENT_MASK));
> >  
> > diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> > index 019b43723d90..cfb82ede8982 100644
> > --- a/arch/x86/kvm/mmu/tdp_mmu.c
> > +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> > @@ -503,8 +503,6 @@ static int __must_check set_external_spte_present(struct kvm *kvm, tdp_ptep_t sp
> >  	kvm_pfn_t new_pfn = spte_to_pfn(new_spte);
> >  	int ret = 0;
> >  
> > -	KVM_BUG_ON(was_present, kvm);
> > -
> >  	lockdep_assert_held(&kvm->mmu_lock);
> >  	/*
> >  	 * We need to lock out other updates to the SPTE until the external
> > @@ -519,10 +517,34 @@ static int __must_check set_external_spte_present(struct kvm *kvm, tdp_ptep_t sp
> >  	 * external page table, or leaf.
> >  	 */
> >  	if (is_leaf) {
> > -		ret = static_call(kvm_x86_set_external_spte)(kvm, gfn, level, new_pfn);
> > +		/*
> > +		 * SPTE is state machine with software available bits used.
> > +		 * Check if the change is interesting to the backend.
> > +		 */
> > +		if (!was_present)
> > +			ret = static_call(kvm_x86_set_external_spte)(kvm, gfn, level, new_pfn);
> > +		else {
> > +			/*
> > +			 * The external PTEs don't need updates for some bits,
> > +			 * but if others are changed, bug the VM.
> > +			 */
> > +			if (KVM_BUG_ON(~EXTERNAL_SPTE_IGNORE_CHANGE_MASK &
> 
> There's no reason to bug the VM.  WARN, yes (maybe), but not bug the VM.  And I
> think this should be short-circuited somewhere further up the chain, i.e. not
> just for TDX.
> 
> One idea would be to WARN and skip setting the SPTE in tdp_mmu_map_handle_target_level().
> I.e. WARN and ignore 1=>0 transitions for Writable and Dirty bits, and then drop
> the TLB flush (assuming the above patch lands).
> 
> > +				       (old_spte ^ new_spte), kvm)) {
> 
> Curly braces are unnecessary.
> 
> > +				ret = -EIO;
> > +			}
> > +		}
> > +
> > +		/*
> > +		 * The backend shouldn't return an error except EAGAIN.
> > +		 * It's hard to debug without those info.
> > +		 */
> > +		if (ret && ret != EAGAIN)
> > +			pr_debug("gfn 0x%llx old_spte 0x%llx new_spte 0x%llx level %d\n",
> > +				 gfn, old_spte, new_spte, level);
> 
> Please no.  Not in upstream.  Yeah, for development it's fine, but sprinkling
> printks all over the MMU eventually just results in stale printks, e.g. see all
> of the pgprintk crud that got ripped out a while back.
> 
> >  	} else {
> >  		void *external_spt = get_external_spt(gfn, new_spte, level);
> >  
> > +		KVM_BUG_ON(was_present, kvm);
> >  		KVM_BUG_ON(!external_spt, kvm);
> >  		ret = static_call(kvm_x86_link_external_spt)(kvm, gfn, level, external_spt);
> >  	}
> > 
> > base-commit: d2c7662a6ea1c325a9ae878b3f1a265264bcd18b
> > -- 
> > 2.45.2
> > 
> 

