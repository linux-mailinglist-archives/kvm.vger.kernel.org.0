Return-Path: <kvm+bounces-25924-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CF5C96CFE7
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 09:01:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD374285E25
	for <lists+kvm@lfdr.de>; Thu,  5 Sep 2024 07:01:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65ACB1925A9;
	Thu,  5 Sep 2024 07:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lAIOBtdp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 842D6136664;
	Thu,  5 Sep 2024 07:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725519684; cv=fail; b=nM6tYb8d/bHpMXXWteMWpQojQjJI8uoqexILHQKaqQV4Z6t/BiPngj3UfK5xQUJZ6Gh3xGlgHRHuGZRYQt/2+VYnDNvoqKB4QL2zAML3yemDTo6jmKl8T1sRH3uVXNYpBzdEFI965RzsOky0h/BQFl4WIMaCFTeSBwPBo9OMLss=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725519684; c=relaxed/simple;
	bh=1PFsJD2RnzMzNt7LXMYK39aXDjJcn+QYYo8AH07zd6s=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=SuKALH6kJ06IyYT67q72MeuvyRF11ztVC/aSm2f3i38K1YQh93zNkSLm1f6W2O9MR+HTrJc7/2Sd4ERYz2vL/FetT4TmJckKMas54Flg9Fgs2CrszvabjYUipZcVFa9YG36v5NMsWlxadViR6Lo6DWQn4Pn+ZKNm7NlrbI80eT4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lAIOBtdp; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725519682; x=1757055682;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=1PFsJD2RnzMzNt7LXMYK39aXDjJcn+QYYo8AH07zd6s=;
  b=lAIOBtdpGlA4G1VTY/YxcWx7XF/EPS57fIQVQR6NLxKdu69TIJY1ZgWR
   HAysNmym+yy3rS+lNIH1FghwQjBkhupLb48S9vlUCOW7hX55G/n7X5uJ5
   1/7wLbhXJGuyV2UWGNYjD/fPfN280S9Gsp7Xh3w0O4GNZp8x/yXxO85ZM
   XrIMGZX496UYocvUVz8NyWvfT8T4WcMTNNyqxBiD1gD6X4FI9117mB8Pl
   wTmTgzqRXvBWPzIYevgt4JfhAQwFRsi4JRZF3LvMV3z/P8g4TVIPSCYHp
   Pb8A4p630EBwSg+2YTyjDo9kHAzx0y88uPOMcHdtGHmci4quQKfleulsx
   Q==;
X-CSE-ConnectionGUID: AW7DDEEOSYSet8kd5/J3Ug==
X-CSE-MsgGUID: JE2B0hs7RvKO6YzSLaSnaw==
X-IronPort-AV: E=McAfee;i="6700,10204,11185"; a="41720916"
X-IronPort-AV: E=Sophos;i="6.10,204,1719903600"; 
   d="scan'208";a="41720916"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2024 00:01:22 -0700
X-CSE-ConnectionGUID: BeDI+d/8QIWRJi4RM3i/tQ==
X-CSE-MsgGUID: foCNNBx0Qaiz0I645PnN0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,204,1719903600"; 
   d="scan'208";a="70330091"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Sep 2024 00:01:21 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 5 Sep 2024 00:01:21 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 5 Sep 2024 00:01:21 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 5 Sep 2024 00:01:21 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.43) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 5 Sep 2024 00:01:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FSOMjVDkY5Pz7cAR0V3WwGWZGaRKSohvqTBpbrJZqRtPfpL9CsS57YBO+bhpi0DNUwfDF63MPbBJLrSv1WZfG6olTdH8mjU/VjgfJzdZQY8lJ4z22Ppp8/bHptJ2MCYHrzHO/Pes9Xp7M4NRPRSKNiiDW467UkFZmT9djOzptUoGmbCKJuQDMA9D0vSTKbHsUjCkhz4PPtoDlBIf482weIzmUgO9TBFoc4XnrClHpV8DY6rm0rfDkonLOdy0Tq2Uf2CqO9JidSo0ERlGukqAWMTEidj5+rjKAxAmr/b+IK70Cj3r4yuhTBVsY99nA4RHDYFzI4GapdB0cE9w8g5Eiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nxFhIFnsjBSqu2f0on5i5lrigk0+XvL3yeXAleJqvMg=;
 b=gsRSTlpN/CORL7p4tAEQFUCPY41Gi37ALwXOZ3d8EgY5CxfBw10X8aLI0/ORzN7aacizSiU9zrwr2vUREUXA79TezbOKSLskB9lTlZss+/xwVYhuts7VeQR7ntm3qwP7Z1A9Cr4L4+LfN6mXbwVJcd19pX0HIeoUWdKcn2qcJrGNmMu7DOzB1xfebCaZ3EdGshKEHLiPUL1ANIE9P4ICh44ryJFvrGO5EwYrAHfvt6YLxbEjVcyAJrf2d3igMLZksh2m5Xb/ulxNT+DTWmXR/IeT8R6AS62Bd/k/nTW5VdwtRpTDKdJkAcZNYevp8IYfg4uRUIO2c8i59uaxYnYF/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CH0PR11MB8088.namprd11.prod.outlook.com (2603:10b6:610:184::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7918.27; Thu, 5 Sep 2024 07:01:18 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%2]) with mapi id 15.20.7918.024; Thu, 5 Sep 2024
 07:01:18 +0000
Date: Thu, 5 Sep 2024 14:59:25 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Tony Lindgren <tony.lindgren@linux.intel.com>
CC: Rick Edgecombe <rick.p.edgecombe@intel.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>, <kai.huang@intel.com>,
	<isaku.yamahata@gmail.com>, <xiaoyao.li@intel.com>,
	<linux-kernel@vger.kernel.org>, Isaku Yamahata <isaku.yamahata@intel.com>
Subject: Re: [PATCH 14/25] KVM: TDX: initialize VM with TDX specific
 parameters
Message-ID: <ZtlWzUO+VGzt7Z89@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
 <20240812224820.34826-15-rick.p.edgecombe@intel.com>
 <ZtAU7FIV2Xkw+L3O@yzhao56-desk.sh.intel.com>
 <ZtWUATuc5wim02rN@tlindgre-MOBL1>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZtWUATuc5wim02rN@tlindgre-MOBL1>
X-ClientProxiedBy: SG2P153CA0040.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c6::9)
 To DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CH0PR11MB8088:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d731578-42df-41ed-d6f0-08dccd788a6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?SynbTEXkGguK/sFpaKt5Lxbku5eFUDbfH+Fp+wsGyaybJXHMhxPhj721qj?=
 =?iso-8859-1?Q?QrJFiQhzizGoo5Bfq5SoRusb1caFm0omgjWW7HlJTGkS9BMu/ozAwBOsAc?=
 =?iso-8859-1?Q?LMkP7tHxwKFXOnLi1DyiEMaINnT3kscZ9g8rCOxY2sBEss7wenf7ke4Iyr?=
 =?iso-8859-1?Q?SnR0OlCoTIqaaRfGZjgHjL6W85tUZqcu/nWhm4DGDevnaDgzzUuxJFZhaq?=
 =?iso-8859-1?Q?29/1Eju0CxGiY+A4MBBn8AcZbmi9d1aHp7qQMuGdEml8uBjgcDbhf3gshJ?=
 =?iso-8859-1?Q?U5cocWsDJyeAt+kS7Uh8GCQ7Uvw17xVwySN87fWYwA+UHLrVDcQzDH3xTT?=
 =?iso-8859-1?Q?UU9XbcIa4NtWrAp6XlDxTaU0LEqmL7OfOKgfOxBCjPVa2J/IBHGu3xejeF?=
 =?iso-8859-1?Q?XZoaiAEgxU/1vb7h+KCqzsk8rpMZi876OihITwo/eCCjabxba8HbLcaAQq?=
 =?iso-8859-1?Q?TcZKSXEFFXwsC2HiHqfQytUdOYJs7/b3OCIeSxuP4gkDlFrHVbAv9FXlLK?=
 =?iso-8859-1?Q?Mn3ojikrf/9PSrPsr0T8Pc4WOgzhq6Yu0l9OAxVSsNp6DLdbP8lxbM5fYG?=
 =?iso-8859-1?Q?c0daL6wnEsw0T9dSE62w3bXOxz6YR6oJuMBYvMvmddj7AaE1OCT2X1V8Li?=
 =?iso-8859-1?Q?78QSKo2Rx6rSNJ7sVj91rNeBiqMH+hqsn2cyW8srs1dRUy1bVk/svu+lrV?=
 =?iso-8859-1?Q?DP3y4z42xqvV15jibXtqUbjhhuUPYCUdbGEVtGb7LDXxBUFlFOc8aRMpsH?=
 =?iso-8859-1?Q?M7k9MtsGJa5EQ8LBBGCwarSkme2kjkBu539Cn2GQhKWv6z125PQE73HmZP?=
 =?iso-8859-1?Q?28JWqITpfCfgajU0X1KBcOQHWHmQYzJ1HPZEP39jUdfLhDnw8HGNilp2Yo?=
 =?iso-8859-1?Q?7M3sWfdfGsTKPt+DHHF5tOVJJKRidSxSyCEijvHUzr6WMhmldwCD9c02sC?=
 =?iso-8859-1?Q?9eHNrTmITSGSz6CEHIca4mFEQaiH5Z8CgbsJo9E4ePPv4UB+uMO9pfVtN8?=
 =?iso-8859-1?Q?eyY9IwApDNrQGqx0FIf/IC7TQcuSMwRRl37r3Nu4HyYGlR7MvFjbYuuOTP?=
 =?iso-8859-1?Q?geOxtA+EznB4+Ch6+PTv8Rsi8Xamq9cjYjhcS7hS2bmdGhh3lw6a1b3F0l?=
 =?iso-8859-1?Q?dNI/3VeFX8NvE3BbyEH+IZxjcxzTHGyrJ0KkKIuR0poTJWmhW/SFOk2vPI?=
 =?iso-8859-1?Q?egaLUe2MsslDnAKuz8bvtxgntNUWW3iY060ACAq5BBL5w4h8HRsfs1qWke?=
 =?iso-8859-1?Q?qcMVLNRd6TAPWBFr4eVbHK8+RDm6sHyuZaMlnqL7SQAN/2JRc5NcXkIfy3?=
 =?iso-8859-1?Q?4MX/z6CSBwnbnQKR4HMiFVeEncAoqY2q/7/Azp7k23li7BjEI088bsNKv0?=
 =?iso-8859-1?Q?d/VshsX65nodVOa8WjKSAYYfU8mnZR4w=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?L4XMFa4kBXAOvKviQ1+M2ss2sThhwvXj2Eojq1Zh7FQCf/d1c+mQIq58Aw?=
 =?iso-8859-1?Q?h2HvIgefAax+UpQJY/82pgkGbl3mu4ry5rwTgqqFisku1uLEuIBPS5wpAA?=
 =?iso-8859-1?Q?QC0lOqRQz3rwQqjmzAuLCu9xJvMF1qQ72TgcPY7a00RqQNWAYZaxsPQw5p?=
 =?iso-8859-1?Q?rSaxHu/IGgDJwrFfMJerZXNfbjFx22CZD4ptsJZEqDe9/L9X0xAvbtavHg?=
 =?iso-8859-1?Q?nQIdR8BVnHXDDLTIcaBY09DLGtkNLkRydRS5ezl7oqGgjL4pSayORUPfJC?=
 =?iso-8859-1?Q?bylIUX/BOdJ6c8lmJa/bx7BvcI7VbAiMnrJAzOFsYLHnFLizKyxH8oSe0k?=
 =?iso-8859-1?Q?YFpGTZ6PlCjx30THtqiBmfQwQJAV0IPddNzDBuP87LfcFWvtcdpYGdZREp?=
 =?iso-8859-1?Q?pS2jAXCDylqEyslwLFqhKzePaMrYkdZEqj/p1gr5o6/DPpwlgoNZmltcgE?=
 =?iso-8859-1?Q?BX8Byh9SSQ7xeJHXz1fFwfBjIN9/J/8wYgXBygeH/lyuIG7wjalWgnQ3S0?=
 =?iso-8859-1?Q?efddAMuDvfGJg0NBL7ekQSJ/w7vsp6GO3xQPRVrZapCiy+kFLIuG5wNOjs?=
 =?iso-8859-1?Q?MgpcwjjBjHzh3lN/kvfpuFpNWOoQ/ITYAxO2I0XQclNzJFpWz9nYMEY4nG?=
 =?iso-8859-1?Q?H23Lu1g1lMSCAeP7ZHsbr+QKamf1dFBmGB5J/r16X2rcFbumv0blpk61vw?=
 =?iso-8859-1?Q?uyMeyGWYG1voqMjEgFatNFNaMT9+wwWXXKGmWpGEnH5vIC5jbXrXTzM38E?=
 =?iso-8859-1?Q?pBAXHxIqIew/4HiVU7/4TGqVq67gl3Ar2PasJxRUka4OAvXOS2e6OCdr3R?=
 =?iso-8859-1?Q?ckhpR96z9gKWqAfSAhuBbrIusjWYqVPLSu5zfm8sGZfS5LJwdjjLI1Dv6g?=
 =?iso-8859-1?Q?uNNUwnmT4DYVhe+XGm0UFSh7KhGCl6UyRWzGZ5u+VnhZj0hSKAPPbJD3oX?=
 =?iso-8859-1?Q?zrdNl0n2AYQRAv4ODQWADcQj5V7bOomElngQ078NKMYOmGWsNlpLGBFbWV?=
 =?iso-8859-1?Q?/RPgP2XuzXYtDVPppxvkI6VKqWQLvVabnmNWxUMpVx1H0aJrsISsEwSO3h?=
 =?iso-8859-1?Q?KHSqWDGwabSpMd0mCQl7BLwZpLMiicFEQ2qiR5lRslXC98kAZq6dx+JZ7M?=
 =?iso-8859-1?Q?NYuaV3aKrWJJXPNyOF3rl/w3lLJua/Fz5J8SaCOHejUDkL+7MDa6m5DY5r?=
 =?iso-8859-1?Q?3S8w1EdMdHzI0Z048vOSBA8qjJVK4cfJbQMzXmkrsU8F8tNIh50OXtJ15G?=
 =?iso-8859-1?Q?GxsN85mCpDA2LxwQ1EMfs4kQscawkShnuctFt/4jCmB4JB+HN+3epTrJeG?=
 =?iso-8859-1?Q?GbqvxjZGIDMyUQh/xp8DgJTLtoiy2vDHu2EI1iMtpiNSeg1C4knfpqGOx4?=
 =?iso-8859-1?Q?XRqmOrmM17x9bQ6jqpaolutBdmS9lsCCT9q9BOhYEh95MhCoB0cr+iTI7V?=
 =?iso-8859-1?Q?Heioise3iboRfWGDI/uqJd0dTo5wb93o3WFI4ZQy6boI70IwV6p4QCvRtH?=
 =?iso-8859-1?Q?oJZl/XStVptTdnUAXoESeXTr3n6NmcWagthkuYVe7dwAtq8CaGVOEjLlmJ?=
 =?iso-8859-1?Q?tcIdhS0SBEU+1+34f7DueCzTdq+tnROZMaRxVoe1psLBYWE81HnRpQpWPo?=
 =?iso-8859-1?Q?GIv8ruDt+ftOyI3gTiuqednrdgyNeS3BrT?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d731578-42df-41ed-d6f0-08dccd788a6b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2024 07:01:18.3284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gjNgHWhVhw+lwB/Ce7PPyZpEoa+zeAcJKNUrTsB8MMgKHOZXiscqsRwppIUxmq2jozK9FYGNWKSyfbFySxt5Hg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8088
X-OriginatorOrg: intel.com

On Mon, Sep 02, 2024 at 01:31:29PM +0300, Tony Lindgren wrote:
> On Thu, Aug 29, 2024 at 02:27:56PM +0800, Yan Zhao wrote:
> > On Mon, Aug 12, 2024 at 03:48:09PM -0700, Rick Edgecombe wrote:
> > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > > 
> > ...
> > > +static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
> > > +{
> ...
> 
> > > +	kvm_tdx->tsc_offset = td_tdcs_exec_read64(kvm_tdx, TD_TDCS_EXEC_TSC_OFFSET);
> > > +	kvm_tdx->attributes = td_params->attributes;
> > > +	kvm_tdx->xfam = td_params->xfam;
> > > +
> > > +	if (td_params->exec_controls & TDX_EXEC_CONTROL_MAX_GPAW)
> > > +		kvm->arch.gfn_direct_bits = gpa_to_gfn(BIT_ULL(51));
> > > +	else
> > > +		kvm->arch.gfn_direct_bits = gpa_to_gfn(BIT_ULL(47));
> > > +
> > Could we introduce a initialized field in struct kvm_tdx and set it true
> > here? e.g
> > +       kvm_tdx->initialized = true;
> > 
> > Then reject vCPU creation in tdx_vcpu_create() before KVM_TDX_INIT_VM is
> > executed successfully? e.g.
> > 
> > @@ -584,6 +589,9 @@ int tdx_vcpu_create(struct kvm_vcpu *vcpu)
> >         struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
> >         struct vcpu_tdx *tdx = to_tdx(vcpu);
> > 
> > +       if (!kvm_tdx->initialized)
> > +               return -EIO;
> > +
> >         /* TDX only supports x2APIC, which requires an in-kernel local APIC. */
> >         if (!vcpu->arch.apic)
> >                 return -EINVAL;
> > 
> > Allowing vCPU creation only after TD is initialized can prevent unexpected
> > userspace access to uninitialized TD primitives.
> 
> Makes sense to check for initialized TD before allowing other calls. Maybe
> the check is needed in other places too in additoin to the tdx_vcpu_create().
Do you mean in places checking is_hkid_assigned()?
> 
> How about just a function to check for one or more of the already existing
> initialized struct kvm_tdx values?
Instead of checking multiple individual fields in kvm_tdx or vcpu_tdx, could we
introduce a single state field in the two strutures and utilize a state machine
for check (as Chao Gao pointed out at [1]) ?

e.g.
Now TD can have 5 states: (1)created, (2)initialized, (3)finalized,
                          (4)destroyed, (5)freed.
Each vCPU has 3 states: (1) created, (2) initialized, (3)freed

All the states are updated by a user operation (e.g. KVM_TDX_INIT_VM,
KVM_TDX_FINALIZE_VM, KVM_TDX_INIT_VCPU) or a x86 op (e.g. vm_init, vm_destroy,
vm_free, vcpu_create, vcpu_free).


     TD                                   vCPU
(1) created(set in op vm_init)
(2) initialized
(indicate tdr_pa != 0 && HKID assigned)

                                          (1) created (set in op vcpu_create)

                                          (2) initialized

                                    (can call INIT_MEM_REGION, GET_CPUID here)


(3) finalized

                                 (tdx_vcpu_run(), tdx_handle_exit() can be here)


(4) destroyed (indicate HKID released)

                                         (3) freed

(5) freed


[1] https://lore.kernel.org/kvm/ZfvI8t7SlfIsxbmT@chao-email/#t


