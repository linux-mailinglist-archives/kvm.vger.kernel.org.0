Return-Path: <kvm+bounces-32341-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D2169D592B
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 06:49:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BB7B2B2264C
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2024 05:49:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2590F1632C8;
	Fri, 22 Nov 2024 05:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l+RDwGj3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5186B13C3D6;
	Fri, 22 Nov 2024 05:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732254584; cv=fail; b=M/oJw0X4U3dIO5Ar1fiD4C48gMkFz8cGBzrqjsLiQArAuHzdVZfGmtfTrHLPriENEIz2l0OwQm0qNaYHzllBggSiIrAHq4jPIo+dMvMqcaYYSIiBKyWer/9NeLoXZ0e3CJr26S0WljWWvXJh88xXDQJm+EcVPrajvgTk/WDHPPM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732254584; c=relaxed/simple;
	bh=UIGunN+BUVSXLcr416eD6J7eNc2Tr4UTjfZ2zGFaRs8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=O7l4IAuEcyfiZRIlfrSICHxM0UKPNmmOyIPqx1kkNkfM6zkGmrcoLjlO1FQO/1+NxaPjZ+UhSl/CQACvvmjLMzJc2CxG5A0HrGAcOJ5Df7wigDdV3TfJiB0yDWqpFzfcUUdYfeyPsjQJ3EdhGWENbXRStUffz551ePje0CTIkbg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l+RDwGj3; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1732254582; x=1763790582;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=UIGunN+BUVSXLcr416eD6J7eNc2Tr4UTjfZ2zGFaRs8=;
  b=l+RDwGj3s7qoBZULjQVUbE9tgWf5ZS5CBhMhlqbp6Jrw5dIn87rzR1JG
   at6jFg9PAnZENVN/QwW7zVNskGN0Zk5jU3ZH4Mo0DcEFQ2AzrksfqzJEZ
   DsddNBvzd5gFfAN/eY6ebpTw+W5qmWxPVVULDCWymf4fAci1l6e7x9aJm
   ZIQUNlLcs3/68MLPciGSqJbSAGj4NieS9YTn6ihpqTUvWLfkC0Mv80DNg
   zQMlwWVD+/CuDl+REgUJj+rV6+YS9wGJVrGKcurl3ph/9u14eZx1kM91K
   2Liq5mv2K0bSgduvnbYPNgxBaH/z2eOiCvmjP1vl8cdGj08FD5hcL3sSJ
   Q==;
X-CSE-ConnectionGUID: 8+ukmWQZQ2mpeWHWt8i+Gg==
X-CSE-MsgGUID: tfoeD/pqT5K20iYxYqHByA==
X-IronPort-AV: E=McAfee;i="6700,10204,11263"; a="19989174"
X-IronPort-AV: E=Sophos;i="6.12,174,1728975600"; 
   d="scan'208";a="19989174"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2024 21:49:41 -0800
X-CSE-ConnectionGUID: u1HAWtLsTgW/afT881c+tw==
X-CSE-MsgGUID: s6Ho/wYbRWaVKa57J+rNSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,174,1728975600"; 
   d="scan'208";a="90115818"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Nov 2024 21:49:41 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 21 Nov 2024 21:49:41 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 21 Nov 2024 21:49:41 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 21 Nov 2024 21:49:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GFLo5u182Vv5yzqVl+P8a1RAKvFshQ834eAz7pUdNLjzz8qrDUhbglhk2vVmEdF3DkcGHjJPbBXRS9jD0dhUS8qo3erX9p+85eqPoIuWkQc5UcLgyUdXJZnBSXTWT9aDpNpfpQPsXZKfAtDzeweJ8ZK/y6Js799CB15ZMayOMOuuXd8hTs602TmAA+YNibF602U5Pw78JsscdMojFDQ9GZ4eTdtFQijm/om6qaAhXYtFzrfQ8av8ntBalZlqIfBM/yItL7dkgpuWUVXPWsebyviXTRS53FxrCpHKT+pAmnwhJqv2ZaCLodfTqeDkVcNlI5VM7KdOFfDVIrdGzdHgPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qcYZW+uqbu/nvrX0JVD+d3rIvxeukNjPvSso3YkfUmc=;
 b=in6r5VBL+lYne3bYC4TIPiW8Lmy8CSdXy2E9LGF2rn7oGlijP09w+psNSemC7PFEIYoQHnZD+jdaOmeEZT8n4zvlGI5/DX0J0cOtoYmoQpI+S1GEdlolMMO4drCbB90qsnx9Cu48ugpA1y5lLhFuAejDfpbKvqPglmlOFILq/mhwgMZaiqqs4vAsoPVYbvj+heVLPlCQtULRKRwJNacM95eibehgOng7i6oW8GgIqMH9hSOri7ZCfmwDaN/DkgGrZNvOC+cx2eMi3fyxNHPHlA6thKj+RzmqCpwV9yYcfCxdySeZouu5uwt8OOBlfgqZMfuDMlhqaXUCCXgxjU8kPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CH3PR11MB7940.namprd11.prod.outlook.com (2603:10b6:610:130::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8182.18; Fri, 22 Nov
 2024 05:49:37 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%3]) with mapi id 15.20.8158.023; Fri, 22 Nov 2024
 05:49:37 +0000
Date: Fri, 22 Nov 2024 13:49:25 +0800
From: Chao Gao <chao.gao@intel.com>
To: Adrian Hunter <adrian.hunter@intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <kvm@vger.kernel.org>,
	<dave.hansen@linux.intel.com>, <rick.p.edgecombe@intel.com>,
	<kai.huang@intel.com>, <reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@linux.intel.com>, <binbin.wu@linux.intel.com>,
	<dmatlack@google.com>, <isaku.yamahata@intel.com>, <nik.borisov@suse.com>,
	<linux-kernel@vger.kernel.org>, <x86@kernel.org>, <yan.y.zhao@intel.com>,
	<weijiang.yang@intel.com>
Subject: Re: [PATCH 4/7] KVM: TDX: restore host xsave state when exit from
 the guest TD
Message-ID: <Z0AbZWd/avwcMoyX@intel.com>
References: <20241121201448.36170-1-adrian.hunter@intel.com>
 <20241121201448.36170-5-adrian.hunter@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20241121201448.36170-5-adrian.hunter@intel.com>
X-ClientProxiedBy: SI1PR02CA0031.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::11) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CH3PR11MB7940:EE_
X-MS-Office365-Filtering-Correlation-Id: 473b1c36-9bde-4d23-a5b0-08dd0ab9730f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?zJHiX9d9VoXWw47Vn9gvA7CT9aJSP0329gdf30JUgJ+ZpspvKJ2KlgAH3I9A?=
 =?us-ascii?Q?GykznnmpIgV+JerZlpMuZVQY8eYsF1EJ3oHq5DjecbUT6IPMTwuxpv99eJ5t?=
 =?us-ascii?Q?LYZifRU0G0GD06Yk4HYuGBIkihiKyDyVCZoaWSujlgF0qYLtvub9Ya7y13vF?=
 =?us-ascii?Q?uzheJUOVE3hClRRAXE0+vHmlTyM8djRMgWUzEecLDyeZ0O+Efe+o5J20lFb9?=
 =?us-ascii?Q?56lMXPpUnPVouwr33O0tLnESZJ542l1LEuQ6xRTmikAZP1OaDB7VNiJ36Ibx?=
 =?us-ascii?Q?6QEekcgowJZzOZlDaxd829BlRaHd6J4wUQhZLNJnfkbO2GQXrEMssP2cGHlM?=
 =?us-ascii?Q?1oQapXQcmhRUfW7vh+gO7ByeYhUxlne3dkumTilKSkxu46OQUokbh93t0JVa?=
 =?us-ascii?Q?Da4J2oLrcAt/IJjUcurb7mlxw+LANfpb3aIiz/6kpGuWgzRfQw/vj6gIPBQ4?=
 =?us-ascii?Q?b3VVHp8ODfY7WbQb73zzPY5uTzTrnupVH6Q/9QP0TT6prLhair7c07pI60+3?=
 =?us-ascii?Q?R5dpbH8LJdAgt6Rhxcc6mHN5rpFB3mLAgUmUpxtLKR3E8Ii+j04iNnba7qiS?=
 =?us-ascii?Q?w8hHhoYIJS082U8xpZXpBMmchmUz7OW6EAFZ+9ki20+nmMrBVp3qOeVBbjEh?=
 =?us-ascii?Q?7a/J1z7FFklgxrhXum6K2PNt/d4v962nQuDgdBJjc+NHtGFRdNEP2PqCsRv5?=
 =?us-ascii?Q?aibFr25pNoQJupFYvvZd7TFcLn9nvDOm6n3/Kkao7lHu5qDENVqqSNc3vOec?=
 =?us-ascii?Q?3ajskoQx4sJ+pGnxQhK4oWJFTLs1fn+KLnmIboNWQ/815HsZdMC8PZlSnY9Z?=
 =?us-ascii?Q?q9VpwuumYSVBPwPwL/sPfJqd1RylQeMvy22sZ5qm/JLS9xvORlWtm7J7yqZI?=
 =?us-ascii?Q?hRrXaW6RGJeLLL/nEFnH6aZN07RxnpOzjFbq3GD1vPLlW5Ogb3Bz/1V1Tyul?=
 =?us-ascii?Q?2FtONhXpt08agztpg5ZTshRvcRHkFMEEVkQkXN3KTY6N6As9Fs2C+Ej9f2n4?=
 =?us-ascii?Q?sujJ+gf/7Icy9vn0w866FRk73c9caHszDaK3UlOey7yLM83OkM23TVcIJNq8?=
 =?us-ascii?Q?EMdBGtpZ4tyjZlWWJtjODISu1XE8X67MrWR/X/a98GYuDOvutzklxT1AM8xe?=
 =?us-ascii?Q?q+fbCnFNDv4FLqK28omQfxcnz8PKPCkm1Z+Mgzu36CRlcX1xea+GkhsesKgO?=
 =?us-ascii?Q?4iQPTRJAMIM5bI1jGVjJywFEKoZl2vHpG4lN9veNhE92MzK1YxEmeb1hMNCU?=
 =?us-ascii?Q?PztuI2nuqFCVBvwueublOSXxDGTP4RxYBOH5oZcz/7PLMnhXsyvSN4ITkdKk?=
 =?us-ascii?Q?wIaMAyAO1cIMDQBZMKjThWLB6mTujSeH9drj80K/25/gZw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VdA6/JtiWNMV6F1xSkt8h23wcVupw8y673jqQOubfhvko5HksHzmQFcjCYTx?=
 =?us-ascii?Q?7A/LlbrTnfOF529CmRkv4v/3ZVpsvrQR9cKSbviIf4Jc3PnnX2O4aL+BKnLN?=
 =?us-ascii?Q?VKynRqvBIp0Fg3uqHyVUUUVaMRaPLIEeSnJYJbQyhzAG9qWaOCcwESNZYclh?=
 =?us-ascii?Q?Cmuk9BARNYpn0db4DyPV/sQ2WKyHgx6Vx7POF4J3yMr+9XfZ7cofJ8Dgj9oF?=
 =?us-ascii?Q?/Xt7wR/GP5YT5pzHXbZyU51DZBeYSwkn3Qmjgz0qNrAiIBOBiWD9W7SELDsS?=
 =?us-ascii?Q?5Mt2pwvOn5QDudpmDmsqKJfrQuscVT/L9jNPaq8yffwX/pENBCcOVyzeqWoD?=
 =?us-ascii?Q?7ypw/IKlvptqc7Qhhmm8BvDEXiU915wjkIBT1Au4+0taoc/7cs5lMKscFnJw?=
 =?us-ascii?Q?sZB5KIp+0AbyoTS5h/pJMEJeCEwHRZV51c0r2xLmM6xAP0BRXZIkVFR8ueG5?=
 =?us-ascii?Q?1MaKXN1ZWfkXPHBhPkgGpWRbFeqO5dbLYlslJAjAA5Vft8BqhUSJioScmZ67?=
 =?us-ascii?Q?GRBZLef+t9TzZivL/GfSHTz4BnfcE+CI8B6XA9TWtPBNka/7Ultyu1v9x5SW?=
 =?us-ascii?Q?/y0Y4BhfANwufj9RMsIDfxQuFWc6ZWu+WEnMQZYJyTr1VBcVSXxiDFs0/ZFw?=
 =?us-ascii?Q?Zv0oN0FHMh1j6SIi13diNZk+/W+qDLUY7aQSquIgK1A8iTJqsZ9TTsEktGcp?=
 =?us-ascii?Q?uhZrEsxuqFfCk6TUm5ggggPUecCFeFYmWd3FvB3+74xG0ZqNspJbKLHQ2zxx?=
 =?us-ascii?Q?b49OrW7TKg4cp3/hD5pe+HMf1GJgzmhIHcrEEVIDeFCPkgIQyhshOFELvoMn?=
 =?us-ascii?Q?tUhjnuaNFnCvVm0mWkeHH4s/tP+ZpWd5UnuMQp0pbJSqjHWoghNF04802aDB?=
 =?us-ascii?Q?d2wRTwYzk7wiPrImlk26a8yAHPGR/lZv530ex6wY9Z/fD4ljO10dOOZDM4n3?=
 =?us-ascii?Q?MB5YiWmlPX2n8bZrHiWQ/4jU6Aoj93PRl67hWfd345Ob6yYYP21iHvWYLwG0?=
 =?us-ascii?Q?pOde2MRLCsAgcX7iEE80G/dEOoTi+kb7WkmA4GCGPy+fu6MypJTQ+rkxGh2S?=
 =?us-ascii?Q?J3DEwFJIWeshogvhEJ3QC02hJcDO2wKT21WukhVmFRvoo6GUm045MddLNLT6?=
 =?us-ascii?Q?aju/v0NGaiRQ7i98BAj6kiJvsSiWRaE/1aRLkB1t18qbyH4q9VeLkgs2WZjn?=
 =?us-ascii?Q?bRhgAyhVkKhY6xgjKuhPF/hr45S5WZLUHO/t4Z8R5U+kVTH+ot+QbMTONblL?=
 =?us-ascii?Q?XGXno5m1/juPULOlb5m1WJGHLDCiXu1ZdEjwug9ZikhTWiNKMDYnf1eixWBO?=
 =?us-ascii?Q?9WT6U5yXvRoce4M8gIR47nBJBKqBjA27YJYVf/GBThQE3/FEIYph3Y0JcAmX?=
 =?us-ascii?Q?wCppLw3T/IUi5BXgl+NMAFpuqPG36J0PMySqYR6gqAyKYMgEo5m36AZ79TxO?=
 =?us-ascii?Q?OM66Wv4vdhMSlIolHtThoXG4o5Zb22dO8cndW0s2+OlSXCEV8Vb+LeqOvINx?=
 =?us-ascii?Q?LoLOhaCorGd7XZESvhT0xZCR98f0UUOsktsJkXSdifJUz9D3SjBI/fjeBpmo?=
 =?us-ascii?Q?659D736PWl0TtrUCTr3F2Qdm0yvD2eXwksZGM887?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 473b1c36-9bde-4d23-a5b0-08dd0ab9730f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2024 05:49:37.3512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tBzjEjt1KVzMkWcq4sAa1fSBTLe8VEyFvFww7F27Q5Ef62tFMHY356GErXTIZSojgn3j/UIg4Feevyd4OihCXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7940
X-OriginatorOrg: intel.com

>+static void tdx_restore_host_xsave_state(struct kvm_vcpu *vcpu)
>+{
>+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
>+
>+	if (static_cpu_has(X86_FEATURE_XSAVE) &&
>+	    kvm_host.xcr0 != (kvm_tdx->xfam & kvm_caps.supported_xcr0))
>+		xsetbv(XCR_XFEATURE_ENABLED_MASK, kvm_host.xcr0);
>+	if (static_cpu_has(X86_FEATURE_XSAVES) &&
>+	    /* PT can be exposed to TD guest regardless of KVM's XSS support */
>+	    kvm_host.xss != (kvm_tdx->xfam &
>+			 (kvm_caps.supported_xss | XFEATURE_MASK_PT |
>+			  XFEATURE_MASK_CET_USER | XFEATURE_MASK_CET_KERNEL)))

Should we drop CET/PT from this series? I think they are worth a new
patch/series.

>+		wrmsrl(MSR_IA32_XSS, kvm_host.xss);
>+	if (static_cpu_has(X86_FEATURE_PKU) &&

How about using cpu_feature_enabled()? It is used in kvm_load_host_xsave_state()
It handles the case where CONFIG_X86_INTEL_MEMORY_PROTECTION_KEYS is not
enabled.

>+	    (kvm_tdx->xfam & XFEATURE_MASK_PKRU))
>+		write_pkru(vcpu->arch.host_pkru);

If host_pkru happens to match the hardware value after TD-exits, the write can
be omitted, similar to what is done above for xss and xcr0.

>+}

