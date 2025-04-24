Return-Path: <kvm+bounces-44102-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB3D4A9A69A
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 10:45:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D3EE9212F9
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 08:45:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADA4F1E0083;
	Thu, 24 Apr 2025 08:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FLEgsN+W"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A5620E700;
	Thu, 24 Apr 2025 08:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745484217; cv=fail; b=gthyoLJOGeyC2X7zHDoMsGB2SCvp6fh6JYr7AOYoWwCU0zQuU+lkNEdrYc3GBaxNRD/6Ik2phoLCVDrdviPgAHaylCFjbD4nk8XcDpua08l0ftuoPVINZn+MiqKUz7QzZ/xWO4xtnpH+L/VqT2/8zgVVDUmyjFiMDJ8lr+FXnII=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745484217; c=relaxed/simple;
	bh=EYOWwe4UKaWipw8WllJchdoqW3qI5vZ921/dD5A8TFY=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QlHEimmB/YlXXbl+FnS+yvSqJP/0mdYn/LiGLTD1k58UFZV0LobEYiMHx6aIQ/VK8XkTcSbg9RFLnp5A1VDfiEFG3J2eIO59RgEwGIxVQqaZY/1FVP26SxztrLyKDjLPB6GHgUdjFE/pTsa/dZO+V/kQjo8gxAfkv5B4ORgQUSA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FLEgsN+W; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745484216; x=1777020216;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=EYOWwe4UKaWipw8WllJchdoqW3qI5vZ921/dD5A8TFY=;
  b=FLEgsN+WY3gMAK2cv9WxBe6xElGKXLAdXdXi233OA+cln89XFuM3otIb
   /J7P/sGm6gp+RNW/1WcjAqoBCVO3a7tCvX1ZO8KBsxz/Uac7ulfq5nuRZ
   g9tkHOKwmgIRE3y96TX+am2Aa2O1kjKeJdKHS5uEfnrXoBYqTjwJNcAEd
   LFF+XJYEQm5KBQ4/4voMtqRyMA+y4Dx/GQTnxMU3vlVP2mUzX+pRh6M1m
   J/X/3BTV8MyKdlJv3whScNqcUAj/RWyAc3hJMbDe298uXA037Vz1jPE4k
   wvMqcWS3m5aEgc0snP8XU/xwpPUjmVdxJK4rAcZquY4UnQuO4R1/dW/FF
   g==;
X-CSE-ConnectionGUID: Nj688IJiRfGTzcqG6K222g==
X-CSE-MsgGUID: wuuyTB0oRX6jf1P3WofvwQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11412"; a="58468234"
X-IronPort-AV: E=Sophos;i="6.15,235,1739865600"; 
   d="scan'208";a="58468234"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2025 01:43:35 -0700
X-CSE-ConnectionGUID: SgYMNpxkTrCn9gqTfxEceA==
X-CSE-MsgGUID: 79bxD2d7QsySqYsR1OJZoA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,235,1739865600"; 
   d="scan'208";a="132291021"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2025 01:43:33 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 24 Apr 2025 01:43:32 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 24 Apr 2025 01:43:32 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 24 Apr 2025 01:43:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BkINh8kRYqeLPR/+5cXQmjI+eGdG+Picig/zjON4gOrRjfJ6G+lSOxowAvJFi5o+rtvPyZGImejaIJJvLnuUaJD+EhYQ9Rz9aQXidKTnDN17NRMvqR1gPPIMW83bEECSlw9HGzwnthOF42n22YwTPiJryoAWWnXUDG4k7B0sR7w1WJeAuokYO/WydKsfwsm8s4R6kgP/+clp7iq3u+t6Eyl0SPtu8dBRD9aDeaCYvJmrIDY0o4RJc9+bYG2u7qmnO5ERxBdjVjrxtTCVIVGZE+gLhpZBqHcTheFmIC1qbl/GI2L7FpMHbeaxIt9elk8Nj209OrMkyd7vMK71G4FIRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J4VCX2hCxqLggVifr4Y0jTYy7YH9t/B/Br1mnOwMWv8=;
 b=jmt1YJb7+HKZzxKRCF1NvyVX28gtAYW4Mxeu6KFwCat5PTMDnEhRgWME+7znthtlsZwtOePNb8NhoytHwUbKjtbufpDSqcp2NzQbWxkaPc0jzZLkLpfrcZe4N9zBZnIy6i0RCsrW+3Oci7W7W2Mhq+vSJ4zawdXx2rm1dUF+oZJu8yH7HfYumLZYwXPc0zJqwMBIWceq2Z9Z/758I+Tm4QAkdBtrTzCA1qw+RAe1WsHYdtnVOmBO2cqehz4VqlTfc2IrJTKHYLchkRjk1rKq3VAt4nIey4to+aXu0CdC/dXdTc8de/SMPZ6pYOW54jWB72UCEILDM4UHDV03q11iRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 DM4PR11MB7376.namprd11.prod.outlook.com (2603:10b6:8:100::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8678.23; Thu, 24 Apr 2025 08:43:26 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8678.021; Thu, 24 Apr 2025
 08:43:26 +0000
Date: Thu, 24 Apr 2025 16:41:30 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: <pbonzini@redhat.com>, <seanjc@google.com>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <x86@kernel.org>,
	<rick.p.edgecombe@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@intel.com>, <tabba@google.com>, <ackerleytng@google.com>,
	<quic_eberman@quicinc.com>, <michael.roth@amd.com>, <david@redhat.com>,
	<vannapurve@google.com>, <vbabka@suse.cz>, <jroedel@suse.de>,
	<thomas.lendacky@amd.com>, <pgonda@google.com>, <zhiquan1.li@intel.com>,
	<fan.du@intel.com>, <jun.miao@intel.com>, <ira.weiny@intel.com>,
	<isaku.yamahata@intel.com>, <xiaoyao.li@intel.com>,
	<binbin.wu@linux.intel.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH 02/21] x86/virt/tdx: Enhance tdh_mem_page_aug() to
 support huge pages
Message-ID: <aAn5OlQiBKNw0rH8@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030428.32687-1-yan.y.zhao@intel.com>
 <stswyrtsciz3ujhzhs72ncpozax7nawg5sbg7gbsclb5jgw5vt@y5fxmsstslca>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <stswyrtsciz3ujhzhs72ncpozax7nawg5sbg7gbsclb5jgw5vt@y5fxmsstslca>
X-ClientProxiedBy: SI2PR01CA0023.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::17) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|DM4PR11MB7376:EE_
X-MS-Office365-Filtering-Correlation-Id: de09a1db-b4d5-4ceb-60fe-08dd830c14af
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?CIwrypF9WAelsm938wWouuTU7OTlv85pFRiY5kL2sUWY8yPifs+RHTu7kyT1?=
 =?us-ascii?Q?PTcqcHJ4DXjphJGoT4iEdExYHsbey4Kn/11JrIctXL+zapGs8YYtLedjRyxd?=
 =?us-ascii?Q?z25HJtmiSOpsqhUE+a9ZtJGuwF7SNjM0CArZ82/8EEoBizq2m2cDGm7Q/OqJ?=
 =?us-ascii?Q?3VCbt02VZQoMRPpWpTc6iGJbVwr3Vn802NG3WCtdK07V0Vt7l5aq2dImVEBk?=
 =?us-ascii?Q?nm4Go/8uQ+MmKrocNI+fghIw68ocedGSXCVyRgl5784nUY6pq7ZmNyg6DZFO?=
 =?us-ascii?Q?D6RcRrKW31MBQZjCuv7M/NLvecNVKKzzxF+pWZEZeVqpmVpTKgd/LBrmPwao?=
 =?us-ascii?Q?u0Rrd/U72//ZkYpMnTFIG1RSJKs6zOGv3jS76dWDNH0KO36zvthUbztZQyaY?=
 =?us-ascii?Q?aFQVIyNYn42dlrB8qzURncScKGdiyCMGW65DU5evyjgXsODS33wrCnD1fkty?=
 =?us-ascii?Q?RQfG1z5vgy8fJ+N1vLobhy6ke6YDTCICxc6buDUlDE6PbOBefm4vcacyWmjQ?=
 =?us-ascii?Q?K/phStBfP87IxwX+lfjYc/6OePiUwchkcflwUusVIDL1E5u2dGL9y5B6yDD5?=
 =?us-ascii?Q?NHtpOh5GW2ReYGliYrbSZorhAV0zmQm9vEsA2/f9nFoJ8J3L9eFtMPc5HcFz?=
 =?us-ascii?Q?mmfC8ni1f4sa9oSSfIoR3/wzShWJWDllPNRVjUh+LOAKHvKFCEFAgNEItlTK?=
 =?us-ascii?Q?xderD68sINod/i6saLHWEoptmkmw2iGp7e6yGpCQFkSY+x+eLJr+bo81/0Mb?=
 =?us-ascii?Q?eg7TsGodvA9M5aiH/Wi5bk6X9MYAiYhZCZodHZQDPHwQ9LwEKrBSe/F/CgxH?=
 =?us-ascii?Q?L5xaVZvG9Yt4UOV1xcaphGFSAQ+oOfRxq2//8pHeigkSxsSilCicx5hW4Joy?=
 =?us-ascii?Q?RHjMzPsz2kZA2jEVgXC93C7RkFPmfalbNNX7isJyxnzus1jxX/jXkFh8/PkV?=
 =?us-ascii?Q?mpA1Egir/CRGfSfOWwqC1nMpP7zLnknle2uhvE9fd5Vg3n+q/HQNO50nIMe9?=
 =?us-ascii?Q?jvrebbqmBdO0kwB6+2Z8joCj+YK3vuJKgdBJpvT+nYUvCCtiBeVUMPmIJ60L?=
 =?us-ascii?Q?uDlrgA+re5J+91slG6bkP4osguFg6JRhEWVV8ld+LMGmhxKP9L8dkPRm/BrE?=
 =?us-ascii?Q?D3KhBlmfN50xH+7ErqUBQQZLp2csZLsegFb5j7z2/8yKYMaQic9FqveumgBK?=
 =?us-ascii?Q?mQ2Fz3rNmNFN3usL5cJchR/rM898EJyxG82yg1LXKzlc8tpLOzrwafL2hBw0?=
 =?us-ascii?Q?R9UAGKybBxbA1iqDt3AYK1xInc3P8Ksh9NeztDIYPJJukMCDrhC6vXFMo2ah?=
 =?us-ascii?Q?tL6ysB+yDgUSsDJ/agBArpuq1eQ9UnaGb6D116Es5OQYCywnV32KomI4zkCA?=
 =?us-ascii?Q?sYrb1nAhm2fddRVXhqx8LoVhMvLOyYteStDyLoEtEf4Wr1njN1kBjV5H31AZ?=
 =?us-ascii?Q?t0z2+9xpXp4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Crjhe0Rt0bxLYUbRZhRJr7AYhB3egf4cygfQEPdnhXrneO6r+43C1bCCXObU?=
 =?us-ascii?Q?0ha0xMd552WMnFEYeKfwDjBbbMAE274Ysbj94eWlGagzMdAxNYIkO+qvFJQC?=
 =?us-ascii?Q?NeJwmVO6/Lj1VV8x3gD4IFOWq3KkoQTuh1u1M7ES004wUOuxxbHmHkU7hvys?=
 =?us-ascii?Q?bPrI7fzbNzw/nd+sF+PuNIUtW9JLmz9i5uyQhFOEZP4Sc6nZy5+mQzUZBHsI?=
 =?us-ascii?Q?9WDqVTADDgFJPOmnCgb+3x9nTKJAajEhdMDXz5qP1ztwizSjNMKEqtEWWwhg?=
 =?us-ascii?Q?svbG14Tchu638avepEUgj4TgypO+R9Vh0Sk0URfQbsjeacJSbJRGdbyUhG7A?=
 =?us-ascii?Q?KrPiuRilLD4z/Q1lx9LrOrG3+5juRcfI1IbhBTEkfPugQWGNdMlD1kNpoeLG?=
 =?us-ascii?Q?0lClt+7OCpEmT2QAniTTfgfDRPRx8dCWBqn/q8olZIudijYF6yDpdRfPwhaI?=
 =?us-ascii?Q?OPrDnpDLQvBGHwI+tDgxy34SCzxoeEOWKBpge0stl3iNlfvBs4+Arl2+o86Y?=
 =?us-ascii?Q?nyXbd1kWq+/w3UekPGz32d0U1ZT4EKhzu4TFjtHa74gzPB7zc5gwlnhDlHyX?=
 =?us-ascii?Q?DQ0mn0BTETXio0rraBdfb+auRGE5xv4TxDMdtTQCk323BC2u7oEN/Gg87qgc?=
 =?us-ascii?Q?fj3sKWLmqAC3WUgYKCKcTBHf/zauq3HAI2Kf3hcHug9sePDouY4nlN7jqBET?=
 =?us-ascii?Q?D8jS0EV2O+slYnwcUnRVmEiGvV3cdUal5L1rm3cuIVFq8RduvtWZg9bqWP7/?=
 =?us-ascii?Q?mTFtqIKbCJbX69FfYtACrpJDXbjBz6luxPTu5OmliSRJ9KTZ+6KbWB3Ze+KY?=
 =?us-ascii?Q?vB54wr67OtkgJN6WVcivJTc2ef9CUjvInUYWSqa2TKaG5NW6ZI4HyncbkjwZ?=
 =?us-ascii?Q?0vcbnyjwomGKT5kslqWu/0DfUr1oPxOsIiuWXoP69/HPZ3UZiiZk4TsWfKLo?=
 =?us-ascii?Q?w2RfxKC5WLJoAwxOOJbThpwp1RtzicOO5PuIZFfm1EzrEiZKNhJwy6LYoikA?=
 =?us-ascii?Q?lLx7AoK3aHRoR5APbUa+8CK0QioXGCq0m9BCNjobNGq6ktuzSs8xcGEAnizv?=
 =?us-ascii?Q?hUdBWl0yOdMYEq/mF+Kz3vFuDizSx2nbBkIk4H68dOJlh/FxwQTxrNF+3SRe?=
 =?us-ascii?Q?+ywJ2O2on7aI1OE7043gxML1v9vKC4D55zuMyLGJMAijpul9srDvf7Q964bZ?=
 =?us-ascii?Q?ASm7oBhOdHQRZufUmq5Nv2jvNnYf3l9XqLgZUmdF/F7Xrnjl4xOWgGB7OIRX?=
 =?us-ascii?Q?aw3mFqfYpOGdNpCIz7+mnlL2/NE9fo0nSunluQyFg3ABE0JU6hmhQzvAMFrD?=
 =?us-ascii?Q?WGoEpnqd1wBOetPImG8Io7ob3jYVrmicuNDjaeAYhT0rkADZLQXBWTYXPyTO?=
 =?us-ascii?Q?HMw5HF2MtrrgXZe5qhnGIsww4GcPOQzL8QChZKIs0Bew1O+HVaEsZVUalWaY?=
 =?us-ascii?Q?feWqs5eHyredvYhNH9+yf82hmazRsL2xiWl3XbOap5by1B7s5UoKmhbWezu0?=
 =?us-ascii?Q?OoAthBfbFmdjtYQPZSf9eEDiaQ+4qXqTECbWlxQE7pjPGCvEQMEIg0Mv+I33?=
 =?us-ascii?Q?BzIcuPd0HB9T1DGKEkIGruAomoikmQhMBhoLSCd9ju8wBbdSOxs9O+z4SsGo?=
 =?us-ascii?Q?4Q=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: de09a1db-b4d5-4ceb-60fe-08dd830c14af
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2025 08:43:26.7896
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B5uoA4xKWDBAHuk+ynL1hIMzSlkOgssX/HGqX4/Xc0KxnYRfOPG6G/s/5fUPlFSi3pwUQPw4R78qObdCk1HeWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7376
X-OriginatorOrg: intel.com

On Thu, Apr 24, 2025 at 10:48:53AM +0300, Kirill A. Shutemov wrote:
> On Thu, Apr 24, 2025 at 11:04:28AM +0800, Yan Zhao wrote:
> > Enhance the SEAMCALL wrapper tdh_mem_page_aug() to support huge pages.
> > 
> > Verify the validity of the level and ensure that the mapping range is fully
> > contained within the page folio.
> > 
> > As a conservative solution, perform CLFLUSH on all pages to be mapped into
> > the TD before invoking the SEAMCALL TDH_MEM_PAGE_AUG. This ensures that any
> > dirty cache lines do not write back later and clobber TD memory.
> > 
> > Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> >  arch/x86/virt/vmx/tdx/tdx.c | 11 ++++++++++-
> >  1 file changed, 10 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> > index f5e2a937c1e7..a66d501b5677 100644
> > --- a/arch/x86/virt/vmx/tdx/tdx.c
> > +++ b/arch/x86/virt/vmx/tdx/tdx.c
> > @@ -1595,9 +1595,18 @@ u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, int level, struct page *page, u
> >  		.rdx = tdx_tdr_pa(td),
> >  		.r8 = page_to_phys(page),
> >  	};
> > +	unsigned long nr_pages = 1 << (level * 9);
> 
> PTE_SHIFT.
Yes. Thanks.

> > +	struct folio *folio = page_folio(page);
> > +	unsigned long idx = 0;
> >  	u64 ret;
> >  
> > -	tdx_clflush_page(page);
> > +	if (!(level >= TDX_PS_4K && level < TDX_PS_NR) ||
> 
> Do we even need this check?
Maybe not if tdh_mem_page_aug() trusts KVM :)

The consideration is to avoid nr_pages being too huge to cause too many
tdx_clflush_page()s on any reckless error.
 
> > +	    (folio_page_idx(folio, page) + nr_pages > folio_nr_pages(folio)))
> > +		return -EINVAL;
> > +
> > +	while (nr_pages--)
> > +		tdx_clflush_page(nth_page(page, idx++));
> > +
> >  	ret = seamcall_ret(TDH_MEM_PAGE_AUG, &args);
> >  
> >  	*ext_err1 = args.rcx;
> > -- 
> > 2.43.2
> > 
> 
> -- 
>   Kiryl Shutsemau / Kirill A. Shutemov

