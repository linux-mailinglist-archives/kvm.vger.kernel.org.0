Return-Path: <kvm+bounces-50270-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C3BCDAE352E
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 07:50:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 77001188BC9B
	for <lists+kvm@lfdr.de>; Mon, 23 Jun 2025 05:51:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1383F1DACB1;
	Mon, 23 Jun 2025 05:50:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Tfzvbtz9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A29C1C862B
	for <kvm@vger.kernel.org>; Mon, 23 Jun 2025 05:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750657850; cv=fail; b=OjU3bpx+gE+ROEqfYk/cTmEAsAtgYGTIqqRRap1QsR+xvyLshZJIPTR5y3boOeR50rhX4dvyhp+cZUJhuqKHO37WR1PnFQmX7CHpL9jCZgKOHuH5kEIhZFUp+vLtoB8BaSShHbQmNoDdJqQ2mNRgg7FlFBxv+3mM+xA5wAjjE90=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750657850; c=relaxed/simple;
	bh=RUDEgg1tI6ghg83QhK5xE9XHHIDCHRZRjyUEhKmx7Pc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=tcwPVarN+Ka+9ulJ0siqH8+jDA5YBxhlmtLZWjcB9s38lt27bB0++UNW2R69ZzxfYIfWBsBSflJ2iNWUEJrK8ygnGQFlY7LoqcNCZqja/+yN74OR8RFLt7WORi5oRTrNyXYg4qiJHFQRAfgFNNdn5j9Qd99h6u16wHukSSzlJZE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Tfzvbtz9; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750657847; x=1782193847;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=RUDEgg1tI6ghg83QhK5xE9XHHIDCHRZRjyUEhKmx7Pc=;
  b=Tfzvbtz9wCMwXwswb+FZ5WEYyyAjko4k9WIItZcFYq03hBiNGjikvVFq
   m9Cn55NoA2kFlaLqOlMLFkFKQnRqzjHUWgio3Cmb01rzLSdCMYFYqipPm
   SmVuHdEO6kl2ZxQwLFT0X1ZskIvQg9aHZmssm/gplx/ds8oHNxx64UjMY
   F8uI8rj8ijxgG/W+YzHC0qV+ECx1NS1GT8iaxTm4IIZV1KWlLbUXP/6y+
   H2nZK2UAaYu07KFskYKcLjk5dSX7NLrKYbDfd7DOwrpiRpQovp3Eq7zqx
   FsM1Lsq/v0H6spJwoWU5ko54q/IZ6xJ2vaLxRcBucX1gP1KfRh9eK1+gO
   A==;
X-CSE-ConnectionGUID: L34CHD8nRwOTfeZ3pvB+3A==
X-CSE-MsgGUID: sDraZnJTSXmkI6/NY/bOZQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11472"; a="40457774"
X-IronPort-AV: E=Sophos;i="6.16,258,1744095600"; 
   d="scan'208";a="40457774"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2025 22:50:44 -0700
X-CSE-ConnectionGUID: uJAWTZdYSb28YRXxw2w8iA==
X-CSE-MsgGUID: Nb4+T8ZMRAiT80tn8EB4+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,258,1744095600"; 
   d="scan'208";a="156036371"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2025 22:50:45 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 22 Jun 2025 22:50:43 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Sun, 22 Jun 2025 22:50:43 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.65)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 22 Jun 2025 22:50:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OyYWa9br+NEcTsrj8GN5vYc1EsCMLu0mjHyZyjqHdFvZA//U6yALpIuTWpCSBhRVc/y+7ekjMXGRHi6mOO5cDq8muPoBV5mMW1Gyvgp20rXvuAlzCwRSAwUyfZXYTp9YQMFir+cvZA/A6HyiVR4RG4yrwFwU0P66/KcvmXxJwl2/tqcjLWjuwonM09aA9ynUMhi5JSbB1yfY6yga39HIaflMhAGf+q+zkrP5xpXeTn8/hmXgqAjPnNHHC5KbcJxZCMQ42aBrtTcwVokfG5wT3+AgMV13Z/wvHk4Ao6oeaAU+xL0loXsvkF/6acG6Wm/HnkbF17MwN3tkZUx2Blgp8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RUDEgg1tI6ghg83QhK5xE9XHHIDCHRZRjyUEhKmx7Pc=;
 b=NKfgXvkXR4nPF7AWxEPJKDjPaPMih3andndDxuMcR7+vUmasNeJpkkfmj/GXOwBrQQKFvNeD8sRieXuw5n6MVK9PLBwKl+bxL9lSms5J6fMKaLitDPFEwxJOIAe5SBpXLef9Zx3ibDU5k2bGaEzqOBINvB4qgPyMYPsDc3vrUy96XeaFESKaWwnpPjEnSuhfFl/o3KTWutNGe03swo/YdtN3xCtOkQgLPWO8BGCHmrdyDuGdzE6pGXaQ11tFRxbSrsyRUXK2SSn0qF11chI2mJaLI7gDHckiVmV9aSbYN0/OJ71kH7c2OSAXqp/IbNn//vTM1NyDrQfqt5DS9DaW1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by IA1PR11MB6515.namprd11.prod.outlook.com (2603:10b6:208:3a1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.20; Mon, 23 Jun
 2025 05:50:41 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8835.025; Mon, 23 Jun 2025
 05:50:41 +0000
Date: Mon, 23 Jun 2025 13:50:33 +0800
From: Chao Gao <chao.gao@intel.com>
To: Mathias Krause <minipli@grsecurity.net>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
	<seanjc@google.com>, <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH 8/8] x86/cet: Test far returns too
Message-ID: <aFjrKU21CMJHR193@intel.com>
References: <20250620153912.214600-1-minipli@grsecurity.net>
 <20250620153912.214600-9-minipli@grsecurity.net>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250620153912.214600-9-minipli@grsecurity.net>
X-ClientProxiedBy: SI2PR01CA0040.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::14) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|IA1PR11MB6515:EE_
X-MS-Office365-Filtering-Correlation-Id: cb6364e6-bb91-4755-530d-08ddb219e34e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?b/mUc+VJdKNZ4xLeFswX4dV44lYKXX8SCPgQOnVY1gSeFOSRLzyPt+vlVdxZ?=
 =?us-ascii?Q?aQi80Xq+egn1E2Ub5vxpUJJABa22b8ovaH0WNpXxSimoH+M2pC8sG+ZqnqAq?=
 =?us-ascii?Q?tXj+kNxtqgDtfeEhVixJV5TzcvEbq841ssT+vMCgmoU4q+mhFH8GhW9joV/F?=
 =?us-ascii?Q?lMXZKbY247ho0shlm/GepwWiqNI7sqmYmXT+l5tqdHSBU9XQsviK4SlJtBDU?=
 =?us-ascii?Q?6hzH9pq4ydApEO4M5o60Zm01tq1UWMjbiR+1upy1I+PjOk2zywYvNvmbC6IF?=
 =?us-ascii?Q?TnetxgDlCU7U4im4pAi/lWTR1ulaZknmUUdXcBElfANW+yU6Eq7am//3Bm/R?=
 =?us-ascii?Q?lh2PYrb5QoKOUSmK4kcczDXTOA3GrJpMEMf55NnJLDCB3JwwKshTW2vx8QEV?=
 =?us-ascii?Q?CQK+bEM1RrLLWMNiZsAaNGUwRKOGGxefTTwdQKpy4cj1aQ4ptwjIPrq728le?=
 =?us-ascii?Q?0VH3ydR7dMFYcdO479Of7KKZWC0QvdWAoO172BFmRp4lqvBCIpAD4pO5zJ/5?=
 =?us-ascii?Q?xOQojEDmfXAhgz9KfsYYQxaoIGoTZ68BAZBU2Jee2BFl9n0AzRepVZpvRUJB?=
 =?us-ascii?Q?sR4T6S0k8J18s9yaZUhv0Ogh4NsXUU794N6gtyCFJU0xNT1bffCSCaJ9Uu/B?=
 =?us-ascii?Q?ZPNI/IyezQRcyA4D/KYFEK3Fj11f5J1h98bfo8BSjpUocaG/2RmGWE5GTnO+?=
 =?us-ascii?Q?lt5RE4mezir4m+BOXuUYvwQwFWNMkja3qabwflC3I8XITUJ8UwqB3Q6km9Nt?=
 =?us-ascii?Q?/fUzlzk+2EwvPOvy5suDzNbILZIa6HffWvERrY6/7vgKRt9oxBL+qqkHMd9W?=
 =?us-ascii?Q?+LdBuoVVmkr3X5KKLHTLPZ0txjufEG0PmFRuJveWqQEBOrGEx8qZPBTmlzIe?=
 =?us-ascii?Q?A9GEFhSfetVQVlF9ghERNLtDtRE+Yt1P4+aHDcL0ogX+2PqDoJwKcsPMzpeP?=
 =?us-ascii?Q?eIb4eZxwnHpHPN7rU0c0Dg7lBMz136+3zNC6gK65t48HXMpNXLriqL1YjID6?=
 =?us-ascii?Q?Tm1toognwPGV1gESu8HbCIYCh+BDMDG3fCx6BsVVxE18m2hUaBWp+17EDcqI?=
 =?us-ascii?Q?WjR41mjownUSWhgVAhUh3+C7o2JmOKL76C2ENCoHWCsq+vx4yXwiAi8rtg0W?=
 =?us-ascii?Q?rkRYNymfbf4OTrLdsRfCAnQhcBYJbYzhyg/8hrQLPjb9xegGB4YiNDZP0fBW?=
 =?us-ascii?Q?wNUZEDU1xd1oTmufPKR820b+/fCSNFHE9VDvX7Wk4STYJKr7/93SCv4tzYvd?=
 =?us-ascii?Q?U+Cw312UHw8eAHgpRQaKRfic65PvkDyZbWCoFZZUEVFmp5L1B4HY7oHuC1y/?=
 =?us-ascii?Q?RTunTjOMYvWojBg0+3nLSE+Kfx/r+rWqFgn0ZY/GVv9yA4CynuXyin5zNZVm?=
 =?us-ascii?Q?YEyYjhBTaGG4nEbVFXpSUZit49iNk+mtqPxwkHIPF0qgPguX1g=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gc7F2Lzu1FWUc3s7txinm7QyxFmb7ENct79K+SMzUznABJf7pkQl2+3nIM+D?=
 =?us-ascii?Q?9i9uFPNuBcR3MEwpFDVal7oXzOTyVae2h7h0bmZOXpcNkzulJMGjvteVNvse?=
 =?us-ascii?Q?41tQWhXzb4Tr9jtjHPCktvLiBE+yFszNEvNxd0WtaMHn4S9OJLm9UyTmK/mn?=
 =?us-ascii?Q?1zGbQCToJk1o8EW5OfoJgXZE6dnpKzzvFFpG5wkx7MhOcuJ7QzEKjeUEEV+Q?=
 =?us-ascii?Q?GNxwPgUzuABb7uEemrqiPk/5uAjAQnR/lYcdFUVU/cbrCkjJMNA/DllIwAtq?=
 =?us-ascii?Q?RXLexWqize29n+5qZ/fy1uP11wBsg8F1qmog1iI6wO5bga06HE+LBB0kfT9J?=
 =?us-ascii?Q?2h7c+Z1k/Qj6ptLTd8fLhK3aNxYIULrlXqzLmv14/8juXEVDiEyc2REhOTw/?=
 =?us-ascii?Q?K0sjk6ZppTRZz7PpdQVXSxUlM13bq4C/R1Dt+gK98ALO3m1nm3/PHbEG3b4K?=
 =?us-ascii?Q?KpoMW0W3wrvcWvdyccNsOfa3lh2XMIIx3IX4OH3YPgZERP/a7DjET+KPhChd?=
 =?us-ascii?Q?Vbcv593iMT1XTh6yIzHLF7IZTDoKYfdEqZ8HEr50jT+06bi0TvEa9lgie7q9?=
 =?us-ascii?Q?ldOixJgif/CP2zBzIJSXXGiVJlat8Ww1AjFQE0aYm6trXfrI3DOCvoieTNba?=
 =?us-ascii?Q?eVnNox3h4/JjRUf0qEvT7fLcObKUhrzfChxUMZhZQESgiS//jQhXSDFOD3q6?=
 =?us-ascii?Q?lC5xxUcYZcC28iEJUljYtVAmLxQrQDcoDpMpMgNDovFA2tEcg2qmJXBHl/7h?=
 =?us-ascii?Q?mIZHt6mTD41Unb/luL4PBUiADuu1pNtdrpZ7dJku7rQxdDoros+VjSGc22gk?=
 =?us-ascii?Q?Q3oeS689/R6FQNVkgi6aXNO1rS2miUUeTdUlnR00i3Tz03wmG7YcvP+i2+k6?=
 =?us-ascii?Q?xYS26/0dSC1AFYX53ctFA9Zf7cOT1xPnegCgQkPcMbCwd1gqcx2om6HAvcRf?=
 =?us-ascii?Q?NX9WMkkxVPePm64JcP90NGZL7/BXdJh37jm0h9i7GhzKqitqLIaTSkM9HXVx?=
 =?us-ascii?Q?PyouL5fVrzV1AR6IJjOpdlKD4V9SnPFaJ0yWnBOxIotV278zU40TR7dp2QvP?=
 =?us-ascii?Q?+DX/aNccdNHoEefa4/axL/hdB+9h6XXmSAHNr/43GWgwByhacreF+KXNvwjs?=
 =?us-ascii?Q?0aKlcnYCrni88AVZd3mNlenohnUYdeZItuaDBu8o9wkCowYkEtP6r7L8/SK5?=
 =?us-ascii?Q?UTC+iryGMXAmZAZm+spN1PVvOLqb9qx4ErnekPupc0U4yBxLroRzSg2wSNsY?=
 =?us-ascii?Q?6uUyVZ/S0WMjRw3Y0I2QyB459mKz8bJOOOzOKDnMSXthNKoW/P66aSRITNVe?=
 =?us-ascii?Q?PDxLZegL2exB37giP/BVvLRz3RcidG/1C/Wta+8AOeOZ09MLg5IdNI/jibFS?=
 =?us-ascii?Q?TgWZmtM0R9fYPtnbN+0JzaueKKtV+0h/K82ihfqXdSh98NH3rzkvyFHdbWaJ?=
 =?us-ascii?Q?bWgkH3lwNnHiRXoACKDYgEDEeaGFBQV1KhG+sMBYbwx+jTNhl5WR+jnSJNB8?=
 =?us-ascii?Q?K3iPiShxaeMvM5+g975/P7pcPXJiK9OLFzjBjZk5VKd7i9irFVs9eP5EfIOg?=
 =?us-ascii?Q?Mog6CO+OPd7hPJS2YXex3Iu2zNLgLxTPleRozcUl?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cb6364e6-bb91-4755-530d-08ddb219e34e
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2025 05:50:41.6538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tFvCRLwYkTXpp5eMNolkQomKEtu1Eim0+/yhVg3YOzG04ynjwC/OHJX16qImpghKgOsGHn4A2raqiPIuS4+GEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6515
X-OriginatorOrg: intel.com

On Fri, Jun 20, 2025 at 05:39:12PM +0200, Mathias Krause wrote:
>Add a test for far returns which has a dedicated error code.
>
>Signed-off-by: Mathias Krause <minipli@grsecurity.net>

Tested-by: Chao Gao <chao.gao@intel.com>

