Return-Path: <kvm+bounces-62277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 72691C3EED9
	for <lists+kvm@lfdr.de>; Fri, 07 Nov 2025 09:19:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 6C62E4EBDC1
	for <lists+kvm@lfdr.de>; Fri,  7 Nov 2025 08:18:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90A1030F54B;
	Fri,  7 Nov 2025 08:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="khkSqkZ+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E5492857F9;
	Fri,  7 Nov 2025 08:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762503521; cv=fail; b=mne9C0k5vtFqr8rGPCCx4jNxISTRhbd9HL82B0VnRJV2D8sKT2iPn7duLnAZHkC/sn3LzzqbltAbfU641R7u23U/OOP9ybtOXXc4VO+L5IOfAbZcb/b33xzOdwcE/9fg9kth1cfSPvPYY0GjUqOcVDR4r1zBeLOIPXiXlvvP+bU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762503521; c=relaxed/simple;
	bh=SZziLEVNvZOhjZJMzV2IFcR6xCCJV9bDqU1rt8JwkKk=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UISD9zXffVprHGKmwmYQoZ7b1kWgPg1ey2kY3MlW/D1xHtuLVKjJvPiNQXq9gwC+5q6tlif4jarGIt7/gKxwN0V+L7Oy9970PKbaeQTHQrTte4OrMQ1kfsrnchpwMI0t1zmNFAr769VcAzRZ86dcfqKVfpZ6E4Fe71YpGtYTxgg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=khkSqkZ+; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762503518; x=1794039518;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=SZziLEVNvZOhjZJMzV2IFcR6xCCJV9bDqU1rt8JwkKk=;
  b=khkSqkZ+kseLxABqaDjv0gERkjvXnc+lqLEa6sen+1IxfPUACJcXwr5e
   qtnuBFQFqevol5ImbOuloVviEaBFMtLuK57t2s/ncFAF8YoMxFzCSGDRT
   hExGBcNUaE8L8LPshc9g/mLh/9u0AZJycNaYE7ke63BI+iTf7G/Ye9V2n
   6KsVechaghzhNbBZQd+88c5ot5ZyacmuPPw1xfl7SUXSku9WVflM5dYV6
   lug/uGy8wn9mOqtIuKdnjnboOyium0GfGzIuXUSyDab7tn3X79uXeL/Os
   ZkuaCEGVViFPhSDA8OBxu5otUcBoO3qUO0xzt2qexPsYWxS89yxFaCB0+
   g==;
X-CSE-ConnectionGUID: 45b7/JqZS7KaV9+rMuUJrg==
X-CSE-MsgGUID: iNSEo8u0QwOTDzwoTrKXTw==
X-IronPort-AV: E=McAfee;i="6800,10657,11605"; a="75342180"
X-IronPort-AV: E=Sophos;i="6.19,286,1754982000"; 
   d="scan'208";a="75342180"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2025 00:18:38 -0800
X-CSE-ConnectionGUID: bjoUvfxGTGW6tHwTrM5L+A==
X-CSE-MsgGUID: MtRQRBfHQd2ceqWxZDZAfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,286,1754982000"; 
   d="scan'208";a="187237993"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2025 00:18:38 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 7 Nov 2025 00:18:37 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 7 Nov 2025 00:18:37 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.8) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 7 Nov 2025 00:18:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=D0j7MgJ7vEqpvVT45Vxgj4qM9F3dmo1s/pX8/AcXS7/Eg16EQyGwM0LxjC9/yZxUr9bstgsS/YhKhFNIjdZBbk9J+KomnuWwhV0FPMyQfOHVLXcw3q7vqFG/yoxkSfjEU04k2Lvw6njjjZxGIWkYfzHcm7d7mCboel3Nnf4dDoTLyC2AM0iIhU6VurRC3wEDpFe70K+UJ1N3PD0ZlfUwIVt32ESZfH1J+vsG+nLKLgPaZBIVc4ld65l9n/fTCROFTTDcPB8SB0vb4tFhmasGzzDYCZlDs/sT4vOxWkwfJJznK52+vDZeVmHyKDVd2OdJGagUIR0JyCUn5KMURs8i+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LrnI31P2B8nf2iKOApSh4HdlbzsHcMFB7yDvMhDJ2Bc=;
 b=lhY4moorZdC+n5FyzRsYr+pkcLhZ8HCZh8UwFSCGMVzBid1HrcZLBmobqezoPKdeI32If9Y+zi/xKugA3a0TfjHHAIPqiTYjm/8NrW9JFBWOHDj3FoUqBIuLlXCGruHiaqxHovkY+buV31Dkd5eMeuRg/4vioyMRM9ejots9ksxkjmNeCoNKdYRq+mDOyPnyatQqC2FTrCjZ/2BnzPPOBWY3WRSND9BBiLmrsXIBc2ajoq81KKgT6h1siN48yu5Ei2BHn8s16/AmxbyT+CQ1QeDiKJtvne1XV97kKLmgg1qAjYPOwRhObYXOrolG88SsuX4fAMdMH192rQCP7i3XwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH0PR11MB4806.namprd11.prod.outlook.com (2603:10b6:510:31::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.13; Fri, 7 Nov
 2025 08:18:34 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.9298.010; Fri, 7 Nov 2025
 08:18:34 +0000
Date: Fri, 7 Nov 2025 16:18:22 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, "Kirill A. Shutemov"
	<kas@kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>, Yan Zhao
	<yan.y.zhao@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Rick Edgecombe
	<rick.p.edgecombe@intel.com>, Hou Wenlong <houwenlong.hwl@antgroup.com>
Subject: Re: [PATCH v5 3/4] KVM: x86: Leave user-return notifier registered
 on reboot/shutdown
Message-ID: <aQ2rTgWwqWvoqnIL@intel.com>
References: <20251030191528.3380553-1-seanjc@google.com>
 <20251030191528.3380553-4-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20251030191528.3380553-4-seanjc@google.com>
X-ClientProxiedBy: SI2PR01CA0011.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::6) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH0PR11MB4806:EE_
X-MS-Office365-Filtering-Correlation-Id: a0ee1b97-06a2-4a72-0840-08de1dd63e76
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?rq45dIfbUM1VWNPpZWTee5ygQaA5D6kmQtrll0Dh0v9A1uiALr2zvkydma9B?=
 =?us-ascii?Q?IQt8Ue4hOtco6tgbVGNwY2hTOJuSa7r2Lcq5bimnq/f3KGsoYykapUh5mPM2?=
 =?us-ascii?Q?y4/wOC5A+WaFiC8a6HFB8Njum8FyMBDrCDQAojHejFMHQgvUWjrSUkFwzy/s?=
 =?us-ascii?Q?rQpgBnIbjvGIp9F2ugPRfApRixRkF79l/yiQyWP7G0bBUjdpPeCLil4i0uJ0?=
 =?us-ascii?Q?xOYsfo8t2u3Bf8oQ4qPboIEJQ2hqyUk1gC/0EsOdGEmDTkxF24yJVbCBfWCH?=
 =?us-ascii?Q?LXHjwwAeO4fOlcslslxPGIu56D7PORq5JNex7fXupKTkUXJZytk4tdN/W2HR?=
 =?us-ascii?Q?laDGqzcA4nh2dMz/oSaD+E/zFqF6wT17DMq98TiGCfzv4rj1GEGrhNv4GmkP?=
 =?us-ascii?Q?WKIyaY2gK46UYdJY/y/cKUJ4wXEjswUgRWiPLnpsjLsbsWjyyL0Kw/d6gQFj?=
 =?us-ascii?Q?8zQvrYUdr8s2QysA3a49JQbLjcnPK9ZzADVNrSOy36dSKSi/C9rFvyzECRIO?=
 =?us-ascii?Q?e9KTj8zezCH/dG8mHjoneAM3EChSwdPZm2eHFUMeoD9rddAgHVwQErigw2Ea?=
 =?us-ascii?Q?au+9TzzwaKdPmU/eEtr99vxwlyjGv1ybrOn0M5l6E7wVdyQU7oteD9AYn064?=
 =?us-ascii?Q?VYM3qx3aPEL3bWWIX6jx47qXq2OE+9+H7Wtu3dgnaGFgpx2LwuD+ybgMj+uu?=
 =?us-ascii?Q?mYVFx7AQitxuIv3meRNmNAuJW0wnAawEVcCPmO2Sey5HE98/nAMd3MISNzRU?=
 =?us-ascii?Q?DMNkTNxOqrrXYHqjOHJqwDaJLSjtYY8+XIu70Y/Sq+p0aA+KH3LWUKLSrmlL?=
 =?us-ascii?Q?ZLrxrxYn0cSjf4nsKjK+Q4Ci7a+1nYBB61z/jnogRC6YseHRvxD1RIuW7YDR?=
 =?us-ascii?Q?v6cRacARJjvEe2UkcfJrA8/DYo/XDrEYcHlTxmUM218UcrWcXj1XxTDQwl1+?=
 =?us-ascii?Q?7x6Cfmq/0LEIedOCpL1kqrNa4agyzcVeiMus31zlzSOaTSRsVn2ZjhHkYjO3?=
 =?us-ascii?Q?phDOA3RRe7Up0LlHCoKr+4lEhLNZQY6YWJvoo3AYIEreYWDB4cPYv4vBFtHO?=
 =?us-ascii?Q?qCer3rf3noSxTlxyBwIEThr21zmuV9fVhYEpMGrPC59hHOpc/9hp6uyZ9NCK?=
 =?us-ascii?Q?k8q33w22qQBKSzHIrf/XFJ5DIYrCIXNzfJTJimgh9bujz228VTTQE+5DkpWx?=
 =?us-ascii?Q?v3g5mVEQ8jwqLf/3saiNoiEP1wrLlDar/aTabZPW5lPBfLrZcXVdXtc6ivEF?=
 =?us-ascii?Q?TqJB2im+TXpXZ0gGsxJ0iD8O+kE6tSon4CvQPKl+IS7JCcG3Vy8faB1ZkyJn?=
 =?us-ascii?Q?nmnOXirJkW7APe+02B2HrKshhR8rM6jDwiUSrvyKAwtK2+nLn05poL5CfB8c?=
 =?us-ascii?Q?n5Z3IUdRyDVs5SwfF8VdE+FgwrIkXOwb3EgjvSfeDvR9ehF4tohDbNYhEc8c?=
 =?us-ascii?Q?eJx5bWMfLHC0AYxgkXVYNw3RcVTbEP38?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eS6eqmCl1emNvori5YTIuHFM8W70uz/QAcxf/Uiy4zDD0clL/x0uPg7HfYH1?=
 =?us-ascii?Q?vj/V3D0+uDXM3CNI6DbWF2yp3B0xxC2/vXHpuw2YXmmL1ONsNNE9gvramTF0?=
 =?us-ascii?Q?qeJUUNnyD4gVJXLjbOyFWexOShfovTcF/CpOq9PINvUIUvay0GNtWr0qMv45?=
 =?us-ascii?Q?Sy6MDP2qIdxE3opZtn3XmUVHV7xxkgyxDrWppJd5KdcwN345FVBd0KDKWRXx?=
 =?us-ascii?Q?MDgZLg3Bdvy2Yt/VZOvDqF0HPd0loF1JpjEOF3Vvy+ECXNqMnidgCUwzDWB2?=
 =?us-ascii?Q?saumalpFZM9uUd2X3WRufkvZuv0T3h/r137tmuKlZe0AZaVs89SXtULU8qYV?=
 =?us-ascii?Q?GXSRNCby59zNkAeP/tLyl2+3OO2ontlRk1Pk8xxksRVvOM47DtfwFEQ9zvnm?=
 =?us-ascii?Q?6XU42JwN5CnNTEywPn8upGgHl1j5MO7R/hzcGCV7hU8RCTyRptu4fPovYPd0?=
 =?us-ascii?Q?tzc5Jv6GoyiyYOMmTo/nPkxAsmxZSANVCsE7XglOUHWoyLFITwqwr8aTRuN0?=
 =?us-ascii?Q?HLwNaTH+vo9O9c7zhsoyf3PvwHlbpb72bBuFU0y3HJENogj2FQc4yyfK53N0?=
 =?us-ascii?Q?VvfOx6Zdcnnqkb6cxQAzEk/bDomXeN6knwYTf3gtAdJHYWB53NmnyN02v3TH?=
 =?us-ascii?Q?ggCisJAVNYyazBs7E6bfvrdhMp27EtHoVzB9RC5Sb1bliRrzzWvcoulklFVa?=
 =?us-ascii?Q?eKMgako03K22r6eVS3p+/15Icsi49MF8oIH1YB4AQNnYAJD+2Bbz2Q/1llZl?=
 =?us-ascii?Q?HmXO1OIjnVenjXWzXitpVjUWs98O0hioRbIn3tcxMTyFkRxoj/CTev8OkdX5?=
 =?us-ascii?Q?jSxsw5N34aPnCDgn1kXOpKBoIRgiKTMnFTUP1aocswB1t539jSONMrJSUSs1?=
 =?us-ascii?Q?va/TC/RpTfIM5eKoTi+f4/CnEWN8SZaTrBzlMssvK7Ed6PAbjUiIJilXuRe4?=
 =?us-ascii?Q?Q3hmy8TcR2UJZfz4K1/CQkL9W6x/VbUZWCgFQCoAJMKzWizvre4ySwIAwFok?=
 =?us-ascii?Q?I8eHB5ZnLJwIjQ/DGrPeFf/DLOer/9eagC519L7zMSjgylajIJ54F3t05CgW?=
 =?us-ascii?Q?PR0JI12sCmIEle/MRA3bURGkVr9b9nyfGMFwRgknNXxGEqmGGrfKM+DxjXer?=
 =?us-ascii?Q?962+LKw1FIuRYF9WMkzvwmSgpIJhYYK3xXD9WamRYLA+Sx2hN34lPetBaRHw?=
 =?us-ascii?Q?IlFcvKK6OaN85QU7KVuI8VlyesBOlUGDBHiO2Uwu/0ne+HnYliVCtycTW1HB?=
 =?us-ascii?Q?LLfTVUmZSuDTXCabQ2wj/M9Y1lKXpVz5WyzE3+pMWbcvs7vxcOqlDnFFuw3D?=
 =?us-ascii?Q?YMtmnkOgTia8hvuMCIiBbPvlOtHt7NwwaftdrXqWeidPzVhMuYiETvQjlUJD?=
 =?us-ascii?Q?q+FcA1xShja5MMU1nyMmx2U0XteZWyFDFzba+pELDwDJk5ip28zyhtCDsCqg?=
 =?us-ascii?Q?HWyrc3/vzjaz1VvaBU34u13M1MrAUFkehhrw+ZEU3WsmPiYisF0Od95Cdbjc?=
 =?us-ascii?Q?tP/D81bOT13TlFa33jyr7w1GEcdKZcPVEtPv7Zz7JDBMQP2W1WYD5ffCV3VD?=
 =?us-ascii?Q?mLl+mUTLUFmc6odLGh/SBq1EbBQbwQzcb+dU6HlG?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a0ee1b97-06a2-4a72-0840-08de1dd63e76
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2025 08:18:34.4794
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mzUYVhGZeRbzPRnvdAP44own/i+xegPde8rEZIgt6B6QI0Xph4pm8y3i1CE4KKlDKZHjhHtd4rlWbKf7zeNxzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4806
X-OriginatorOrg: intel.com

On Thu, Oct 30, 2025 at 12:15:27PM -0700, Sean Christopherson wrote:
>Leave KVM's user-return notifier registered in the unlikely case that the
>notifier is registered when disabling virtualization via IPI callback in
>response to reboot/shutdown.  On reboot/shutdown, keeping the notifier
>registered is ok as far as MSR state is concerned (arguably better then
>restoring MSRs at an unknown point in time), as the callback will run
>cleanly and restore host MSRs if the CPU manages to return to userspace
>before the system goes down.
>
>The only wrinkle is that if kvm.ko module unload manages to race with
>reboot/shutdown, then leaving the notifier registered could lead to
>use-after-free due to calling into unloaded kvm.ko module code.  But such
>a race is only possible on --forced reboot/shutdown, because otherwise
>userspace tasks would be frozen before kvm_shutdown() is called, i.e. on a
>"normal" reboot/shutdown, it should be impossible for the CPU to return to
>userspace after kvm_shutdown().
>
>Furthermore, on a --forced reboot/shutdown, unregistering the user-return
>hook from IRQ context doesn't fully guard against use-after-free, because
>KVM could immediately re-register the hook, e.g. if the IRQ arrives before
>kvm_user_return_register_notifier() is called.
>
>Rather than trying to guard against the IPI in the "normal" user-return
>code, which is difficult and noisy, simply leave the user-return notifier
>registered on a reboot, and bump the kvm.ko module refcount to defend
>against a use-after-free due to kvm.ko unload racing against reboot.
>
>Alternatively, KVM could allow kvm.ko and try to drop the notifiers during
>kvm_x86_exit(), but that's also a can of worms as registration is per-CPU,
>and so KVM would need to blast an IPI, and doing so while a reboot/shutdown
>is in-progress is far risky than preventing userspace from unloading KVM.
>
>Signed-off-by: Sean Christopherson <seanjc@google.com>
>---
> arch/x86/kvm/x86.c | 16 +++++++++++++++-
> 1 file changed, 15 insertions(+), 1 deletion(-)
>
>diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>index bb7a7515f280..c927326344b1 100644
>--- a/arch/x86/kvm/x86.c
>+++ b/arch/x86/kvm/x86.c
>@@ -13086,7 +13086,21 @@ int kvm_arch_enable_virtualization_cpu(void)
> void kvm_arch_disable_virtualization_cpu(void)
> {
> 	kvm_x86_call(disable_virtualization_cpu)();
>-	drop_user_return_notifiers();
>+
>+	/*
>+	 * Leave the user-return notifiers as-is when disabling virtualization
>+	 * for reboot, i.e. when disabling via IPI function call, and instead
>+	 * pin kvm.ko (if it's a module) to defend against use-after-free (in
>+	 * the *very* unlikely scenario module unload is racing with reboot).
>+	 * On a forced reboot, tasks aren't frozen before shutdown, and so KVM
>+	 * could be actively modifying user-return MSR state when the IPI to
>+	 * disable virtualization arrives.  Handle the extreme edge case here
>+	 * instead of trying to account for it in the normal flows.
>+	 */
>+	if (in_task() || WARN_ON_ONCE(!kvm_rebooting))
>+		drop_user_return_notifiers();
>+	else
>+		__module_get(THIS_MODULE);

This doesn't pin kvm-{intel,amd}.ko, right? if so, there is still a potential
user-after-free if the CPU returns to userspace after the per-CPU
user_return_msrs is freed on kvm-{intel,amd}.ko unloading.

I think we need to either move __module_get() into
kvm_x86_call(disable_virtualization_cpu)() or allocate/free the per-CPU
user_return_msrs when loading/unloading kvm.ko. e.g.,

From 0269f0ee839528e8a9616738d615a096901d6185 Mon Sep 17 00:00:00 2001
From: Chao Gao <chao.gao@intel.com>
Date: Fri, 7 Nov 2025 00:10:28 -0800
Subject: [PATCH] KVM: x86: Allocate/free user_return_msrs at kvm.ko
 (un)loading time

Move user_return_msrs allocation/free from vendor modules (kvm-intel.ko and
kvm-amd.ko) (un)loading time to kvm.ko's to make it less risky to access
user_return_msrs in kvm.ko. Tying the lifetime of user_return_msrs to
vendor modules makes every access to user_return_msrs prone to
use-after-free issues as vendor modules may be unloaded at any time.

kvm_nr_uret_msrs is still reset to 0 when vendor modules are loaded to
clear out the user return MSR list configured by the previous vendor
module.

Signed-off-by: Chao Gao <chao.gao@intel.com>
---
 arch/x86/kvm/x86.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bb7a7515f280..ab411bd09567 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -575,18 +575,17 @@ static inline void kvm_async_pf_hash_reset(struct
kvm_vcpu *vcpu)
		vcpu->arch.apf.gfns[i] = ~0;
 }
 
-static int kvm_init_user_return_msrs(void)
+static int __init kvm_init_user_return_msrs(void)
 {
	user_return_msrs = alloc_percpu(struct kvm_user_return_msrs);
	if (!user_return_msrs) {
		pr_err("failed to allocate percpu user_return_msrs\n");
		return -ENOMEM;
	}
-	kvm_nr_uret_msrs = 0;
	return 0;
 }
 
-static void kvm_free_user_return_msrs(void)
+static void __exit kvm_free_user_return_msrs(void)
 {
	int cpu;
 
@@ -10044,13 +10043,11 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops
*ops)
		return -ENOMEM;
	}
 
-	r = kvm_init_user_return_msrs();
-	if (r)
-		goto out_free_x86_emulator_cache;
+	kvm_nr_uret_msrs = 0;
 
	r = kvm_mmu_vendor_module_init();
	if (r)
-		goto out_free_percpu;
+		goto out_free_x86_emulator_cache;
 
	kvm_caps.supported_vm_types = BIT(KVM_X86_DEFAULT_VM);
	kvm_caps.supported_mce_cap = MCG_CTL_P | MCG_SER_P;
@@ -10148,8 +10145,6 @@ int kvm_x86_vendor_init(struct kvm_x86_init_ops
*ops)
	kvm_x86_call(hardware_unsetup)();
 out_mmu_exit:
	kvm_mmu_vendor_module_exit();
-out_free_percpu:
-	kvm_free_user_return_msrs();
 out_free_x86_emulator_cache:
	kmem_cache_destroy(x86_emulator_cache);
	return r;
@@ -10178,7 +10173,6 @@ void kvm_x86_vendor_exit(void)
 #endif
	kvm_x86_call(hardware_unsetup)();
	kvm_mmu_vendor_module_exit();
-	kvm_free_user_return_msrs();
	kmem_cache_destroy(x86_emulator_cache);
 #ifdef CONFIG_KVM_XEN
	static_key_deferred_flush(&kvm_xen_enabled);
@@ -14361,8 +14355,14 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_rmp_fault);
 
 static int __init kvm_x86_init(void)
 {
+	int r;
+
	kvm_init_xstate_sizes();
 
+	r = kvm_init_user_return_msrs();
+	if (r)
+		return r;
+
	kvm_mmu_x86_module_init();
	mitigate_smt_rsb &= boot_cpu_has_bug(X86_BUG_SMT_RSB) &&
cpu_smt_possible();
	return 0;
@@ -14371,6 +14371,7 @@ module_init(kvm_x86_init);
 
 static void __exit kvm_x86_exit(void)
 {
+	kvm_free_user_return_msrs();
	WARN_ON_ONCE(static_branch_unlikely(&kvm_has_noapic_vcpu));
 }
 module_exit(kvm_x86_exit);
-- 
2.47.3



