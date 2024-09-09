Return-Path: <kvm+bounces-26097-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C25F0970CFA
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 07:32:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E04B61C21B55
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 05:32:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C6641ACE0C;
	Mon,  9 Sep 2024 05:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J3WTguJs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4841722638;
	Mon,  9 Sep 2024 05:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725859927; cv=fail; b=daG/6OkkqzMeClkrFpC7NshFeipSUI3hJ14CFPrE+0xrqVNTAlZo95F9Tv15xpf0WGKSCbrTcy/C5/Y2JMhtlNFlauT7FP6t7K7v6NfLWhUTFQ8zoNRDv5LobP3WDnoQDLX9DJpRtXxMt17zMebSmHtXc5MOxBjFtpN2zuyk3/Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725859927; c=relaxed/simple;
	bh=59N0Dga8+2PJYeqTJfDbvHP5KTT7mXElcBB9LibIVQ4=;
	h=Date:From:To:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=fOie55UO9SiSTdAe7IV9uP1Jxyh4eOcRrv0ILrQLBekA95z56WJcQVjJ5LXS+EYJRJ++uIwyjWkfoUD2CiY9Nj4qcdAcnfPIGQHRA1HW/fl5Ec1FxireVjTOmg4F7Xch3fF1/KcYo5a3hyg1lIKH0k4Hut/XADgdoUCmXVpht6Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J3WTguJs; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725859926; x=1757395926;
  h=date:from:to:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=59N0Dga8+2PJYeqTJfDbvHP5KTT7mXElcBB9LibIVQ4=;
  b=J3WTguJsTkX7IQyM0CLzJxgDItIDH/C50TroaHkZWLf6G4KaxgzEMPa/
   sSp964YJ4R1NwIOxW7udc+8lLBSjPm3XZcktKez81u8AMpNaKRHs8aYei
   EBYA4oOW1sZ53JPn16jXuWdgiZIA3uzey8ITckM3+ja0sxXD3ATV7VeS4
   GGGKDGRqqJvDg1JZH7rwAQX1RjVqEUHVNn7pfN7Ez7zLK4Wa+zixnZ3ss
   LxvwxITT0spNQltYdNUotVAmM2KbFVYfY9WB56T7Qi6F3sIsWx6BLOngP
   clmf3KlCvl0huXDFZ3qzJh7gr8f6RL7PxDB0DTQc0G10mYaDM7tAKjXi2
   g==;
X-CSE-ConnectionGUID: DNuteNZeQKWPiziTKNaDWg==
X-CSE-MsgGUID: vaekZg8LSiam3MT4yRqvKQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11189"; a="35106387"
X-IronPort-AV: E=Sophos;i="6.10,213,1719903600"; 
   d="scan'208";a="35106387"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2024 22:32:05 -0700
X-CSE-ConnectionGUID: Ho7s/bxBSwiTj8MuErKj/Q==
X-CSE-MsgGUID: rzt3BnUiSeCFeuhA8zNFgQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,213,1719903600"; 
   d="scan'208";a="97260955"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Sep 2024 22:32:04 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 8 Sep 2024 22:32:03 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 8 Sep 2024 22:32:03 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 8 Sep 2024 22:32:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vHH1tgsCR/ItDbcY0FcZW2LcARRfggAd/KXLlDA2vvB+AvHTfj6+ZkmU/zjHWyyBvWzuLI2zXoNAF54RG4xxsd5vlsH6IcJcaIubj+wCq/+kcxP/ZHjSb6UxmkqEF4OcDXy5vopI/qInYvj4ky4aauJqQ3uKA2j1VhMKHB4X2w6WTh9BjDeQ0MsKOl7jJnm5oV1GjVtLojvU5YpRICyw8u1BmYw4Us6+dNV50jBc8Ttpupspdfko29qTp/ruUbriIf7K26ODdhnfk5XttB5vcjPLPfRy1CjpAByOOgxh1gRTLAh+7ScwARamdQpG9iM3j7PzhhaVG8kp6i/aW7mVZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WImCrVfFagMilXZ0UR31EmhxQH3AYvznSWMEHVQI/ug=;
 b=KlG8LjMpKz339Uj/Bcksj5MJ2sUM1utvWOkP7K23QuuELyZeGVKb7AoTgvrIVpDUc+5icc/OypfjYMknAvrzTWaK1F6oy0mLYey8+SOLQPtqdifBVB02u8UTVmIeapbNB67DVNqrHwX+CHoLPVEQ2KNv942dHTklouBSjNdleegTsPwIeAJKpzefuQwDKf1Zci3Sf7v97gsmkatNpQaiFeUqrbKFmZm1tiXaW8rpoNgeGwptDQZ0ncDeRzzqoxv30k2scj/WNzGJ0WIuf8NOBuOUZ1HTMP+brb3Bszq0OrxVH/sCdJLmITcrRbvDfAUMGZIwY586CyYVoH76dAiDdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA2PR11MB5017.namprd11.prod.outlook.com (2603:10b6:806:11e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.28; Mon, 9 Sep
 2024 05:32:00 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.7939.017; Mon, 9 Sep 2024
 05:32:00 +0000
Date: Mon, 9 Sep 2024 13:30:03 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>, Vitaly Kuznetsov
	<vkuznets@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, Paolo Bonzini
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>, <rcu@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Kevin Tian <kevin.tian@intel.com>, "Yiwei
 Zhang" <zzyiwei@google.com>, Lai Jiangshan <jiangshanlai@gmail.com>, "Paul E.
 McKenney" <paulmck@kernel.org>, Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH 5/5] KVM: VMX: Always honor guest PAT on CPUs that
 support self-snoop
Message-ID: <Zt6H21nzCjr6wipM@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <vuwlkftomgsnzsywjyxw6rcnycg3bve3o53svvxg3vd6xpok7o@k4ktmx5tqtmz>
 <871q26unq8.fsf@redhat.com>
 <ZtUYZE6t3COCwvg0@yzhao56-desk.sh.intel.com>
 <87jzfutmfc.fsf@redhat.com>
 <Ztcrs2U8RrI3PCzM@google.com>
 <87frqgu2t0.fsf@redhat.com>
 <ZtfFss2OAGHcNrrV@yzhao56-desk.sh.intel.com>
 <ZthPzFnEsjvwDcH+@yzhao56-desk.sh.intel.com>
 <Ztj-IiEwL3hlRug2@google.com>
 <Ztl9NWCOupNfVaCA@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Ztl9NWCOupNfVaCA@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: SG2PR04CA0202.apcprd04.prod.outlook.com
 (2603:1096:4:187::20) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA2PR11MB5017:EE_
X-MS-Office365-Filtering-Correlation-Id: 2efa5772-f4f2-479f-b2f4-08dcd090ba9f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?QRaXcXdLlNy00bJW69/Y9YFdpGw6q5mORECda8efaOXvjVKOoR3azelqg9Fi?=
 =?us-ascii?Q?bhUOIj9k7mVHfE5h8jQyIS2ULJdGm1uziKgXqQJXr4X6hSlxkw3vRdrZpYTb?=
 =?us-ascii?Q?Lg11gTbuFQSOc3gbb2GUbMItOSt+8UNp0f6uaoFS7phP6VE6KPHFYmKF3t14?=
 =?us-ascii?Q?iku3QjS5A7h+FBpfEfgj6oTCjLUdJTDX7XcEuwWLlIDtt/ftRzeaC9WqGo/l?=
 =?us-ascii?Q?mhQQa0Yft83zy9+nhaYuqf6jKmwLxNF4anreCt6EPtvVlpR3e1lk4Hcwf/9J?=
 =?us-ascii?Q?Sfo2TUV692yuykZOJLEd4fFI/kMJZ2eBs/72NgNYCCEvwznD4ISppIvEDSLI?=
 =?us-ascii?Q?baTKWXk6AvtHApuZmMyEgn8XYbTtbL8QqnWoCps0x877oCPGzH+lGh0Ajo5f?=
 =?us-ascii?Q?0pgTP1+jL94JCUrVS9VsfjsRS4fxFZE7E001dRMlNQIi4gIdXJwZFsfxn4Yt?=
 =?us-ascii?Q?ab1b8b2GTZMn9QlEE6Qk+IfoSV3ts1mnSfsedPwM2jUGqEtfpwqevFJzyNDo?=
 =?us-ascii?Q?LUL8nsy7RZqDB27uz/hUYr7xkEcx/j5NPChwJnINsPsseUZwwspxIjyLUukI?=
 =?us-ascii?Q?J0P/JXvBP0Jz8QciAQpd7n6ROH8H9egaiykAMeeqV4DFZXu2UmzpU8OR1TEz?=
 =?us-ascii?Q?U+VZGbGUGIoXCcmxzCndmsmfaYkPPHwYKi/bKy2wuroFVGC+CzUykvO3GxRa?=
 =?us-ascii?Q?i5uyvTBknmS2ufy6Q11j2J9ShMn3fLlBj6/agPRSKrj8ysJEhSnO2vUs/Nt8?=
 =?us-ascii?Q?hddOEfwTMDdsuIWRB5zSOziymWyIgoRgzQ4X0HpXL+W6F0vJC7PAfpxjaYcx?=
 =?us-ascii?Q?3YSyGescXDcrAC2EpPIPZovzGN8iPdYgLjek7tNbnVlQ+k+mRBfEnnoqx4Cg?=
 =?us-ascii?Q?/hZyAjiONV7omm+yH1T/ny2KAuivpnFpKOwyO5sl5+FhaDNFniPVpn2IXWJg?=
 =?us-ascii?Q?OuIORIW1y6SpMOBZJ820s47dRrGd/2BBPc52shcYUsXRIl1GIh3xWuBoIAOA?=
 =?us-ascii?Q?/iZKv+PFdsi7ZYKeqUPIK4RmnMK/dk5NolwHqA7lh3S+GPc+vSByrvbUMF8n?=
 =?us-ascii?Q?2yfJNsWhNDZYbX+yHCVWcMp5XjcvpNBbAluTzTQlmf0++MJkHVe8YSHJt64r?=
 =?us-ascii?Q?3NmF5M2pPhIfEBwFeLxuOPzpQoLA9zOM/V/jLdABuO9Uu206jFZd9W056L6g?=
 =?us-ascii?Q?Sw3USQTPGlvdbE+xtdIesdQHvpsUgHAZKph+WgcdqrPB60KM4OWBJiMu4tkC?=
 =?us-ascii?Q?Ftw6oWrAIt5FLESL6a1TdAfZ6BsAsqQxuJZVeopjx73fEdMDnkjDDMbztpku?=
 =?us-ascii?Q?OwPRET5XI3Q1CYpvgt0WiiG2XLntoKm0ej14L2Uit4jbHabhBCQjsNvoXAuM?=
 =?us-ascii?Q?Zt5+Zc6s8+ZCCO4MUzFBDmk36WPN9I2iSvOLoVpGi/a8o/Y80Q=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DLtdFRqK/f9voY8zRLc4CYRYzbwfjDqPCs+9XlNNFMhMW2ZbirXBhQMgpjvL?=
 =?us-ascii?Q?oKe1PArgvj2YoZSJFqKXlzyyzCQuaM4fyAfNF7y7Ng+kpiCtdHhYjT7FVbwk?=
 =?us-ascii?Q?yRkXxd0AdMV//tkR5I+yJcGCokB2EkfOTfu2IQR0p9oCLSs8HQL/mWJ2xpV8?=
 =?us-ascii?Q?EzfKBgI81/GE8YnewHI2nAL1rwhtx7/fQVozIHC3JO36ZnJJ2qQJ74u9w9mY?=
 =?us-ascii?Q?q0HNjMQKigp/TLUBuLK3P5wuZkSR7XtJtZUoRocg7jEnlLdb/XObZTA48xJp?=
 =?us-ascii?Q?oljH9xEsAnPjc0waz3fK/I2AedgMbywZN4hU6myL3RtBkdQ5QLsaubwvquAi?=
 =?us-ascii?Q?z9Gk7c/K7BDoxKKh8qTCPH5WQjMf1vF1LMIk3ci3y/JQ64K79AJjYAQx04ws?=
 =?us-ascii?Q?OSJ7ho6cmWNrA6MzjWB+xCukO+KxC2dDOxG5bOr3S+Uur/4No+vJaXxQH8UC?=
 =?us-ascii?Q?fbqYxoZ3hU31hoiFXGVR/Rkl+NOpHgGikmQ+ynRhgAjaxAPMIto/liIWkTc0?=
 =?us-ascii?Q?AWRbLb+1YWsfg+Y8iO7e0oWlbydDAFTym4a9fS6jbziU9JrVNdNGzcgSJ4pE?=
 =?us-ascii?Q?bIxGxd/L5R8ddMgWrN8BPi0wiXWlEs7EunlSaqiE3Te2H+NWmfG4mixrDqly?=
 =?us-ascii?Q?1ck/V+CY5flLECeC5NT4U/xOjrFuzMx4vTsJWrB2IDlTNgty8F0VgYdA4E6h?=
 =?us-ascii?Q?c82U+lSar4wZgtyJkVhDsfIiwEtCGmXUacgQVPhsm7t4q7AzAUsDZhoNMt9c?=
 =?us-ascii?Q?ainrXuJ4nHi7+9u9p1xWTaISlmEUAWBs3LA9fBKVCs7dF/mCUsICy67AMusP?=
 =?us-ascii?Q?QQYj/THT5oSNV347I/gHFkEX8wvjR4UWPHaVBJxlQhlrMmJNEtnIftz3Ya4G?=
 =?us-ascii?Q?jwjOcvMTHCi9WKe5e6oEB/Ub165hcr6VIZE7lFcD+N6SK3CGPNc0ypaHGhdM?=
 =?us-ascii?Q?F2JVutYFv4cxiD5vJfgjQ8QegOYFEn7JpsyPxvAbab3Y8PEHiKlf1FQg3Qf1?=
 =?us-ascii?Q?zG0yJyvSEAOZfplsOodzhCCZMwYucBHp9zUt9rABfRUPlhdEVLN2dKD8C5uf?=
 =?us-ascii?Q?lwdpEVUf2E47i8i6a1t2tAOiLVcKyuVE1AeePw9My5MmxIJ6Q61T4aAyGhk2?=
 =?us-ascii?Q?7tmccrtYgVkUgO/VSfLkPuHZQow6e2JiM1tyC+egZtfhv41kz5dkRBKk+HiT?=
 =?us-ascii?Q?dmLeYM0Tvdtwb7rAlX5pAabhRsqRv2RlMlLY6ey+6LX2BMT974k8qrDYoSzM?=
 =?us-ascii?Q?rb41nCdE0VFuq9KEnXLa3WTR3XR1bM9OoxnjlkJ6k33YuaO27GYeGtuxtNQ/?=
 =?us-ascii?Q?txBiUoPmAxaHkSe1iReubVgJbf1OQFlkD0rmgT7lyNQ5mf+f9bINUD64OLyI?=
 =?us-ascii?Q?MkkBB+pTrTbL7QKIJr1oRek/0taghAhyA38sGmMUFT62T/S4CRklzSdQlhdF?=
 =?us-ascii?Q?zgAS6xaKaD4q1/c0kVg+fu9oLSWt4V6rM8QHRqRlcAJL4BKwuGzx3FLTJrWU?=
 =?us-ascii?Q?rh5B3LcGXYgv6ivSqLSyo48tcH3fGUTvNlczd1hl7lJqLLcrDQXHfGGaX4Mx?=
 =?us-ascii?Q?nX7+UHWcfU/Yjv1PjNkKbuc5AJH9uO4wRtNIoVKv?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2efa5772-f4f2-479f-b2f4-08dcd090ba9f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2024 05:32:00.6137
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1lpw+QgXaK94j91bhbIe10TAyEBsZiqd9IeXDffkTp3Rv2DLPVWy4opE2BymFf44nl7OCEnPwqYu+7w4enyQcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5017
X-OriginatorOrg: intel.com

On Thu, Sep 05, 2024 at 05:43:17PM +0800, Yan Zhao wrote:
> On Wed, Sep 04, 2024 at 05:41:06PM -0700, Sean Christopherson wrote:
> > On Wed, Sep 04, 2024, Yan Zhao wrote:
> > > On Wed, Sep 04, 2024 at 10:28:02AM +0800, Yan Zhao wrote:
> > > > On Tue, Sep 03, 2024 at 06:20:27PM +0200, Vitaly Kuznetsov wrote:
> > > > > Sean Christopherson <seanjc@google.com> writes:
> > > > > 
> > > > > > On Mon, Sep 02, 2024, Vitaly Kuznetsov wrote:
> > > > > >> FWIW, I use QEMU-9.0 from the same C10S (qemu-kvm-9.0.0-7.el10.x86_64)
> > > > > >> but I don't think it matters in this case. My CPU is "Intel(R) Xeon(R)
> > > > > >> Silver 4410Y".
> > > > > >
> > > > > > Has this been reproduced on any other hardware besides SPR?  I.e. did we stumble
> > > > > > on another hardware issue?
> > > > > 
> > > > > Very possible, as according to Yan Zhao this doesn't reproduce on at
> > > > > least "Coffee Lake-S". Let me try to grab some random hardware around
> > > > > and I'll be back with my observations.
> > > > 
> > > > Update some new findings from my side:
> > > > 
> > > > BAR 0 of bochs VGA (fb_map) is used for frame buffer, covering phys range
> > > > from 0xfd000000 to 0xfe000000.
> > > > 
> > > > On "Sapphire Rapids XCC":
> > > > 
> > > > 1. If KVM forces this fb_map range to be WC+IPAT, installer/gdm can launch
> > > >    correctly. 
> > > >    i.e.
> > > >    if (gfn >= 0xfd000 && gfn < 0xfe000) {
> > > >    	return (MTRR_TYPE_WRCOMB << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
> > > >    }
> > > >    return MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT;
> > > > 
> > > > 2. If KVM forces this fb_map range to be UC+IPAT, installer failes to show / gdm
> > > >    restarts endlessly. (though on Coffee Lake-S, installer/gdm can launch
> > > >    correctly in this case).
> > > > 
> > > > 3. On starting GDM, ttm_kmap_iter_linear_io_init() in guest is called to set
> > > >    this fb_map range as WC, with
> > > >    iosys_map_set_vaddr_iomem(&iter_io->dmap, ioremap_wc(mem->bus.offset, mem->size));
> > > > 
> > > >    However, during bochs_pci_probe()-->bochs_load()-->bochs_hw_init(), pfns for
> > > >    this fb_map has been reserved as uc- by ioremap().
> > > >    Then, the ioremap_wc() during starting GDM will only map guest PAT with UC-.
> > > > 
> > > >    So, with KVM setting WB (no IPAT) to this fb_map range, the effective
> > > >    memory type is UC- and installer/gdm restarts endlessly.
> > > > 
> > > > 4. If KVM sets WB (no IPAT) to this fb_map range, and changes guest bochs driver
> > > >    to call ioremap_wc() instead in bochs_hw_init(), gdm can launch correctly.
> > > >    (didn't verify the installer's case as I can't update the driver in that case).
> > > > 
> > > >    The reason is that the ioremap_wc() called during starting GDM will no longer
> > > >    meet conflict and can map guest PAT as WC.
> > 
> > Huh.  The upside of this is that it sounds like there's nothing broken with WC
> > or self-snoop.
> Considering a different perspective, the fb_map range is used as frame buffer
> (vram), with the guest writing to this range and the host reading from it.
> If the issue were related to self-snooping, we would expect the VNC window to
> display distorted data. However, the observed behavior is that the GDM window
> shows up correctly for a sec and restarts over and over.
> 
> So, do you think we can simply fix this issue by calling ioremap_wc() for the
> frame buffer/vram range in bochs driver, as is commonly done in other gpu
> drivers?
> 
> --- a/drivers/gpu/drm/tiny/bochs.c
> +++ b/drivers/gpu/drm/tiny/bochs.c
> @@ -261,7 +261,9 @@ static int bochs_hw_init(struct drm_device *dev)
>         if (pci_request_region(pdev, 0, "bochs-drm") != 0)
>                 DRM_WARN("Cannot request framebuffer, boot fb still active?\n");
> 
> -       bochs->fb_map = ioremap(addr, size);
> +       bochs->fb_map = ioremap_wc(addr, size);
>         if (bochs->fb_map == NULL) {
>                 DRM_ERROR("Cannot map framebuffer\n");
>                 return -ENOMEM;
> 
> 
> > 
> > > > WIP to find out why effective UC in fb_map range will make gdm to restart
> > > > endlessly.
> > > Not sure whether it's simply because UC is too slow.
> > > 
> > > T=Test execution time of a selftest in which guest writes to a GPA for
> > >   0x1000000UL times
> > > 
> > >               | Sapphire Rapids XCC  | Coffee Lake-S
> > > --------------|----------------------|-----------------
> > > KVM UC+IPAT   |    T=0m4.530s        |  T=0m0.622s
> > 
> > Woah.  Have you tried testing MOVDIR64 and/or WT?  E.g. to see if the problem is
> > with UC specifically, or if it occurs with any accesses that immediately write
> > through to main memory.
> > 
> > > --------------|----------------------|-----------------
> > > KVM WC+IPAT   |    T=0m0.149s        |  T=0m0.176s
> > > --------------|----------------------|-----------------
> > > KVM WB+IPAT   |    T=0m0.148s        |  T=0m0.148s
> > > ------------------------------------------------------
> 
> I re-run all the tests and collected an averaged data (10 times each) as
> below (previous data was just a single-run score):
> 
> 
> T=Test execution time of a selftest in which guest writes to a GPA for
>   0x1000000UL times with WRITE_ONCE
> 
> KVM memtype  | Sapphire Rapids XCC | Coffee Lake-S
> -------------|---------------------|----------------
>  WB+IPAT     |     T=0.1511s       |    T=0.1661s
> -------------|---------------------|----------------
>  WC+IPAT     |     T=0.1411s       |    T=0.1656s
> -------------|---------------------|----------------
>  WT+IPAT     |     T=3.7527s       |    T=0.6156s
> -------------|---------------------|----------------
>  WP+IPAT     |     T=4.4663s       |    T=0.6203s
> -------------|---------------------|----------------
>  UC+IPAT     |     T=3.4632s       |    T=0.5868s
> 
> 
> T=Test execution time of a selftest in which guest writes to a GPA for
>   0x1000000UL times with movdir64b.
> 
> (Coffee Lake-S has no feature movdir64).
> 
> KVM memtype  | Sapphire Rapids XCC | Coffee Lake-S
> -------------|---------------------|----------------
>  WB+IPAT     |     T=2.6142s       |       /     
> -------------|---------------------|----------------
>  WC+IPAT     |     T=2.8919s       |       /     
> -------------|---------------------|----------------
>  WT+IPAT     |     T=3.0966s       |       /      
> -------------|---------------------|----------------
>  WP+IPAT     |     T=2.4933s       |       /     
> -------------|---------------------|----------------
>  UC+IPAT     |     T=3.4606s       |       /     
>
Up to now, I think I have root caused this issue.

Status before this update:
In either ubuntu or centos, on "Sapphire Rapids XCC"
- gdm fails to launch gnome-shell when wayland is enabled, when
  effective memory type is UC/UC-.
- gdm is able launch gnome-shell correctly when wayland is enabled, when
  effective memory type is WB or WC.
- gdm is able launch gnome-shell correctly when wayland is not enabled, with
  any effective memory type.


Update:
1. I tried KVM memtype = WT + IPAT for this framebuffer range,
   gdm fails to launch gnome-shell when wayland is enabled.

   Since the only difference between WT and WB is that write in WT is slow,
   the failure should not be self-snoop issue.


2. The current bochs driver calls ioremap() to map framebuffer range.
   On x86 architectures, ioremap() maps VA with PAT=UC- and invokes
   memtype_reserve() to reserve the memory type as UC- for the physical range.
   This reservation can cause subsequent calls to ioremap_wc() to fail to map
   the VA with PAT=WC to the same framebuffer range in
   ttm_kmap_iter_linear_io_init().
   Consequently, the operation drm_gem_vram_bo_driver_move() become
   significantly slow on platforms where UC memory access is slow.

   When host KVM honors guest PAT memory types, the effective memory type        
   for this framebuffer range is                                                    
   - WC when ioremap_wc() is used in driver probing phase                           
   - UC- when ioremap() is used.

   I measured the data below for drm_gem_vram_bo_driver_move() which
   does memset to this framebuffer range with size 0x3e8000.

     ---------------------------------------------------------------
    |                               |      in bochs_hw_init()       |
    |                               |    ioremap()   | ioremap_wc() |
    |-------------------------------|----------------|--------------|
    |     cycles of                 |    2227.4M     |   17.8M      |
    | drm_gem_vram_bo_driver_move() |                |              |
    |-------------------------------|----------------|--------------|
    |     time of                   |    1.24s       |   0.01s      |
    | drm_gem_vram_bo_driver_move() |                |              |
     ---------------------------------------------------------------

    drm_gem_vram_bo_driver_move
       ttm_bo_move_memcpy()
           ttm_kmap_iter_linear_io_init()
	       iosys_map_set_vaddr_iomem(&iter_io->dmap,
	                                 ioremap_wc(mem->bus.offset,mem->size));
	   ttm_move_memcpy
	       memset_io or
	       drm_memcpy_from_wc


   If I comment out the memset_io() and drm_memcpy_from_wc() in
   ttm_move_memcpy(), drm_gem_vram_bo_driver_move() can be very fast and gdm is
   able to launch gnome-shell and login successfully, though sometime the
   screen is a little blurred. 

3. I sent a fix at [1] to let guest bochs driver map the framebuffer
   with PAT=WC for kernel access.
   [1] https://lore.kernel.org/all/20240909051529.26776-1-yan.y.zhao@intel.com/

