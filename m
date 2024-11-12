Return-Path: <kvm+bounces-31602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D8D19C516C
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 10:04:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0E06B1F22266
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 09:04:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 467C320CCFD;
	Tue, 12 Nov 2024 09:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XUCyvjm0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B94321F7092;
	Tue, 12 Nov 2024 09:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731402265; cv=fail; b=KwbAYEo03XCtJKFqDxFRgtREcjNToVwbVHBNTkJ54yNwgcqcWCNDB0IHiNaCfeXB6UVqFVkXEoAdbgifBFuO5NACiiZnAaD4jZC3iV9Mm71PNqtS8FnUXblQNL+x933OmxiJk+oJzDYSVhpKeCB8XX+K3W/YONs6QhXRCdL9I0o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731402265; c=relaxed/simple;
	bh=Wz+A0jAgLie9Blc684e230sV/R4XFLHUhE0W6BScHt4=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=CIyY4mcWbXlFl5KoIE5ZvcDc3+gEAcV/orlVatXycexOrtNAmp6y/Bf3Hmtg9GiBmzUfmdsaA9zxC4oR8EGPG9Enp0A1EC6NeYaxF/KphW1ZuVwyPCGYgzCMFHEGV3dxVY3uqv/Y9zc3WCvX+lFJXKV3oeTJcCoLxEDQAw6fqyc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XUCyvjm0; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731402264; x=1762938264;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Wz+A0jAgLie9Blc684e230sV/R4XFLHUhE0W6BScHt4=;
  b=XUCyvjm0UKYdh2cUITtYqL897hq14T6NmmMr5E2B3eqHlWgfyoLiqVuD
   ZmIekfG25TNywmJLsv/yIKL2ZZDHif3DlFV7q+iX+1Gmhd/KJoieyfhmp
   XuhGN6nZRUUtpxnZgW3qLi/mxDBeAKVuhDAfm9LjjAq7viXZWjTuPeqMl
   fLjloOJW7hgPnWheEt4KfPCNll+sQhvzMN5gORNNmcl8l8KWct7nWJUl6
   PyO+eLaDvRN0b29ZjOs0BZPQD57BSn+ASnqUQsNz+uJmHuL5E+1g6V15I
   Cut+8S2tzfV9ms8zWg0vmM7JK9zz3BdT3vXbIXIpo+cq2tR65diklBEE1
   A==;
X-CSE-ConnectionGUID: 5OoJcecbRhisGaS6Jw3iaw==
X-CSE-MsgGUID: Gw4PKvHqT++YloHbh07M6Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="53778886"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="53778886"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2024 01:04:24 -0800
X-CSE-ConnectionGUID: /pq0g5wSTq66X4Q+Bq0eeA==
X-CSE-MsgGUID: SyOF3M3tR5WbD6fDM+tjsg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,147,1728975600"; 
   d="scan'208";a="92291639"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Nov 2024 01:04:23 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 12 Nov 2024 01:04:22 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 12 Nov 2024 01:04:22 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.47) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 12 Nov 2024 01:04:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OhY/YrCr3iXsR4lX8lFT4vlPg5BS3NSiUf7fr8r3/uhuewUaT570Gwn/t/BJf4FgkoGZolsVgVe6i3ILvIGqkoVzEMaf7hYQD/l14ekXczAJbdmXq6OHAdMvYof0AFTkdIF7KQwLkXJy1nBBsT7k0iZtSwTseJEjQa3LFTDl2sKUJeZyav4lg/p2VKPZjOI9N3k7Gg0xOrFNtEyq+UrG2ehaOOtjE360UKOeo8u4rJKE+x6gXCeINm9PV81AiXAxY1Ls4Ql5qQ1zENC7bRUKphw+ivq9FgzIDyGCooeJ9bkBWHj2haDbnQiZyQCj9WPrL+GQanlGyA7tNw2BHB0CAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ajKdEkGGrmmAYvX063RZ1ESB1vPu0tYkNaRMMFxzJmw=;
 b=BIMx1wVsoRnFq4z7AMoaK5eM4bBw7KE0Py4azDfhHCBNcFa52Opu2L3Xrd2VUDUMSKIezL+inIm80T9ScR5QDhT7/nkOM55YAPxLR4ywAsa5fMMTvJRJsPi8ncZzXbm74H72mMVsvpwLQQYHhTgtuE+aZrqlSOSodY89IhlrQOD7aBej863egWejLT9/HB420cOaiCGFPbc/LmflxwgDsJJq5U+qnhADhpfYgWxTb1XTGswBS/4TF6258CAgN09IeGqKLnFjWgX2Q1IK2U2uvkAjbjCeX2gVzAwjl9S+z5gU7PdwsmllZbqrAANNFpeyIn2H8wcd8VEMYXhb0tTTKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH0PR11MB5110.namprd11.prod.outlook.com (2603:10b6:510:3f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.17; Tue, 12 Nov
 2024 09:04:20 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%3]) with mapi id 15.20.8137.021; Tue, 12 Nov 2024
 09:04:19 +0000
Date: Tue, 12 Nov 2024 17:04:11 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] KVM: nVMX: Honor event priority when emulating PI
 delivery during VM-Enter
Message-ID: <ZzMaCzDNJAOCMFl6@intel.com>
References: <20241101191447.1807602-1-seanjc@google.com>
 <20241101191447.1807602-6-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241101191447.1807602-6-seanjc@google.com>
X-ClientProxiedBy: SI2PR04CA0011.apcprd04.prod.outlook.com
 (2603:1096:4:197::10) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH0PR11MB5110:EE_
X-MS-Office365-Filtering-Correlation-Id: 92e2af3d-b543-4178-661e-08dd02f8fe43
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?NeQ3UcM8mghypL5vuXMqtdr3vSnOabADmlwwiGf2wMTCCHxgfVnj8PTE3C88?=
 =?us-ascii?Q?n57xKOV4uKE7un1yoZmwQPDlPXGPTwHkZHqp+GXTecSMl3Y6udsSBNUquIZd?=
 =?us-ascii?Q?a4K9YBX89N/4t0srNaQa8BH9gu6515TwWxpVHfLLb2zqs84mZO78Xdx7KHdT?=
 =?us-ascii?Q?QfSBCqHCmOXtY7Vd19qP/1WyD+ZDIQ9LhXD71YYaReag12Pf6ob1yBRoaP9f?=
 =?us-ascii?Q?PAuEMeBu8hhJRPPH8GSpuBI1QuXd6RUnfZo2rh3FdkrPLmjJX/fqxYYDLQG8?=
 =?us-ascii?Q?Odt4CjwRimpAZxZA/3P7ntJoswo50rjUHZGaQg8IcRvsdwrnCdsrZIp2XTq/?=
 =?us-ascii?Q?lllipyWvASO2SbwcAe49vXAJmZAo6m7pPR3oCPNmYdE1Er+Q/6+pPH8SfHBB?=
 =?us-ascii?Q?SP4veuAtxCN+MOhNbz5KvO3XattMf6qaEUrcAazroP5M36ewvxjQg3xmwVF4?=
 =?us-ascii?Q?MLLXQT5hkLuE5aMsBZ9MKbRAz0qmOQ08AvMJPfje/NNb3PidPNWX4YvJh99T?=
 =?us-ascii?Q?VTT9NqhmRCZkk4EfJNDrJYHxJFG99b7IhVXYlheQVAN25B18eGkyAJGhUWln?=
 =?us-ascii?Q?54a4DHM1jGs95nRmx7Uq852KgW2dk5dksq6Qp+/rH6mmL7sripQchMMr7AI4?=
 =?us-ascii?Q?y0TXsRmZmj+99rw12WHO3Xjsyq9VnkrsdkKLW3w6NQyLaalGgDdMh90rCbUI?=
 =?us-ascii?Q?TrpAnm1CwGgAP2IJt2P5hXnSdhchYacGq3UrHMOPUx0NZUBXCGxkBM4xugaZ?=
 =?us-ascii?Q?1LNH3NO2cY44CRO1D2Utgr4R6c6qOufqUoBlQxW2ZC2f0UkvGGAkGg29fGqP?=
 =?us-ascii?Q?x4eul7rGhfMv48nGs1TBoSGL1QSenj2fM9/tnW7a6aG95JoPGwybxP0V/2xt?=
 =?us-ascii?Q?A3qyXsORMagUQGNqaPopK3eG1aW/MppHxwmd6cibZr/52aWd0fICMEI/eoEL?=
 =?us-ascii?Q?SVLa6bBTidLXUQbZ3oNVfU/qrjilQdx9whGiLoq42km4rnSdI1Ns6EFDiuy6?=
 =?us-ascii?Q?xpenz46WOlzAuTI8xtS15pn4l97TErOSuvoc0C0lQEL6uz2rC9YGy+0UAaa3?=
 =?us-ascii?Q?WCejliR7mJNJtfixtYObITsg8j4hMVWRly2XJy4U92q9pjChkPlP94gXFT6l?=
 =?us-ascii?Q?CEXKpDTwNkeQJrjRptu+Tanjo1bW+KccT3Cr01y/fUbHx+C6C3QL6gDL4XQr?=
 =?us-ascii?Q?G9CkGWKhyNLbficwzQrGRw3YHMANfPGEGQykE+p0XX/2dX+fAsDz29RZMxt8?=
 =?us-ascii?Q?oE7AzXAYhdZF3lHp1s+tua3fTGl9xy/V6zFM6aKY7u5z+bnfzn63YRqg6nRP?=
 =?us-ascii?Q?/2B6Cc8Hhv+hpgChppzGLVes?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qroaaU2jXB3oEpUvDxD71OXtXCzTwoNRkH2WsWa0W/ssWvdhTe3vZB62X1/L?=
 =?us-ascii?Q?O3uoVJJVYZfNnRd9hLQmpA+hzJVZ6wp/tKjGgfmz0Y+5eOh/UrBEFY7kSxva?=
 =?us-ascii?Q?LLMwfEX/dsQ2wb9VuycYKb1dRZPeEhjffrGGAexT7PtfG/3ebaRBNsMwE1dx?=
 =?us-ascii?Q?CLarU93Cl4+zdW0dGTuvDl/UwTPDr6wewMdsp+4HH+l+Wz1VXoAFyAp+D8LR?=
 =?us-ascii?Q?ZLGUQAnaVq2v6x1GCDXzM2Mwd+bxnobRjwFURFyQHRkoqn9bKr5mWrhux152?=
 =?us-ascii?Q?KqWzOBUCtIlSl45VwTGIuGgc5danudV0gMzS+2ImP13hbsAy3wG/EP/dUI0U?=
 =?us-ascii?Q?jnKWP3rQc3uXZURVUxxs+apuPL8uwi9/7CfZX7I6M/G4ifnTtJVGnbbtaCFD?=
 =?us-ascii?Q?6oQjPnN1xI6cLzeIrrfWkF0zgqnIj/j8WEvZnwEQTSvHdnDigUWUSkfUKF5k?=
 =?us-ascii?Q?qXTn7iu4CgIOqeMntZBC6n9vyjsusTsYYqUjFSnm0n6D3Cbd6ob56fFRI7zs?=
 =?us-ascii?Q?C6bx9DfpwE5XBasJyfDt9Snwr66n10OL2Be8kbbpgy4n3u8Klc8nwAb5PeJn?=
 =?us-ascii?Q?QBgkKWsJHTpSem6rJ39hSfWmwPt5vfw4MMwMsZUP5BJ9SvlQ6SdIg+5nVOdO?=
 =?us-ascii?Q?FwVPJ76+YJnYkk+we9kCVmneRNr4E1sWqbzi8NMWSteM/Vd6Zpukx4vmxZs9?=
 =?us-ascii?Q?KaI/mWsSiShtZe8IkOoXj3ugKkw0TYVLY8DEUtY/q0jMYWu8lWN/mKvSSHhM?=
 =?us-ascii?Q?YLoeCmGZlF1/PkM8/Se6nfIX5DbbdlriUu6llivRKg5TVHc/8+4yxiiYUVDN?=
 =?us-ascii?Q?DiIPobNrR1VBIVNfpP/5p/e4aP7LczGQD9uGou2q/nRhxr8fsArnQ7jQr+Z7?=
 =?us-ascii?Q?HP7b3XWb0+xPernPCiC6WqqhkUS6DTLkhW0NvLkIEfHxRvm37fYd4nnN8CvQ?=
 =?us-ascii?Q?1HB4VwiIujm+ruvr+KakxNLNKU0Wl2dh2vkU8ckJlF+6uTVSb2DfNZXA2kDa?=
 =?us-ascii?Q?qNufNPXHv1/8euespBbwEqAN+Pmy119NRoAgj7W6RxSEYQr/1TAFghAddfT5?=
 =?us-ascii?Q?C8xQwYNuUCJjbZm+DybJOxk/6wFdl4ptdG1jskreBBACxR91rSFZamRP61/C?=
 =?us-ascii?Q?zDbtPdXX0rNbkCfhrtnb/4+4o0tKURI0YlEYgZW690hqbGpqfe8kOa6on9Hg?=
 =?us-ascii?Q?6YyJA3mSavY0UuX6Pfkz97JMJTMcUahW88ZLp2p1dHm5ZXnVkvyeH71PjPIT?=
 =?us-ascii?Q?S7KHmIXwutgjdQ1d4LPAuJby/4qBCBm7p+KMx7llriVSlspb2xpj5AGbKbru?=
 =?us-ascii?Q?jbwiaV2ay5vl3R19LnLAxt3Z0APb5EnIToZk+oXcrzRY/mhFho+YWiidYPXX?=
 =?us-ascii?Q?zy9EEXfunisPKCirqtBFfSciB9U9TbpHlq0OHT/l5cpEhhSjNC3VTzicgr1L?=
 =?us-ascii?Q?+LJia6WWzbop1+4XOO1QdWbZdXPCYApntxYBLYWRsxLsd+p86sNnQ6dziu/l?=
 =?us-ascii?Q?rNMIaGGmWnA9KMLsEqq+jhTHZsJSy6JUc57wncd9x2/vYqjlkJ0OPbSsafdH?=
 =?us-ascii?Q?KSbYJzH3gXopWXP5EtGKVvWHJBFmMwB8WL2daIx5?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 92e2af3d-b543-4178-661e-08dd02f8fe43
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2024 09:04:19.8966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hOU0tT1Q5hET4ggpFdXV4Xb3JGgrjfyegGHjIunDpDs1+VNov5CQwXoU8sN2MXlMR6uCEWlbpD93sOZ/WZxTbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5110
X-OriginatorOrg: intel.com

On Fri, Nov 01, 2024 at 12:14:47PM -0700, Sean Christopherson wrote:
>Move the handling of a nested posted interrupt notification that is
>unblocked by nested VM-Enter (unblocks L1 IRQs when ack-on-exit is enabled
>by L1) from VM-Enter emulation to vmx_check_nested_events().  To avoid a
>pointless forced immediate exit, i.e. to not regress IRQ delivery latency
>when a nested posted interrupt is pending at VM-Enter, block processing of
>the notification IRQ if and only if KVM must block _all_ events.  Unlike
>injected events, KVM doesn't need to actually enter L2 before updating the
>vIRR and vmcs02.GUEST_INTR_STATUS, as the resulting L2 IRQ will be blocked
>by hardware itself, until VM-Enter to L2 completes.
>
>Note, very strictly speaking, moving the IRQ from L2's PIR to IRR before
>entering L2 is still technically wrong.  But, practically speaking, only a
>userspace that is deliberately checking KVM_STATE_NESTED_RUN_PENDING
>against PIR and IRR can even notice; L2 will see architecturally correct
>behavior, as KVM ensure the VM-Enter is finished before doing anything
>that would effectively preempt the PIR=>IRR movement.

In my understanding, L1 can notice some priority issue in some cases. e.g.,
L1 enables NMI window VM-exit and enters L2 with a nested posted interrupt
notification. Assuming L2 doesn't block NMIs, then NMI window VM-exit should
happen immediately after nested VM-enter even before the nested posted
interrupt processing.

Another case is the nested VM-enter may inject some events (i.e.,
vmcs12->vm_entry_intr_info_field has a valid event). Event injection has
higher priority over external interrupt VM-exit. The event injection may
encounter EPT_VIOLATION which needs to be reflected to L1. In this case,
L1 is supposed to observe the EPT VIOLATION before the nested posted interrupt
processing.

