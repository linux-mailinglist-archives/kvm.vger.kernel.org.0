Return-Path: <kvm+bounces-63173-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E7BAC5AF24
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 02:45:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8A34D4E4DE3
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 01:45:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B8862638B2;
	Fri, 14 Nov 2025 01:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XPNaUHd5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9DD7239E7E;
	Fri, 14 Nov 2025 01:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763084702; cv=fail; b=iC0vKEPSX/a0j2HBTu2bQhd6v+qru+Gd/MeXWpemEAmYvj6gITdfjSWq7irBdCLOJsGhWpecfqvppVLXdC9a12fUzOa7QW08hz/iaxZ6epo+YTxLpBubW8h/yVlTH+yPm7Re24XkgJ59OKOeP3j/VmhfKOHOL6MvTj+pTY6tOk4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763084702; c=relaxed/simple;
	bh=kDgFdrd3qGUMECBmh20OPqZ+gzCzqRaV27Mv5u7K53E=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=h9cyzUoc3t7SDEqys8tDzjUfS6+oGD6Ec3UM5dhLalMxJ+we3J7Mtn87LXpD7Zcmz+k+iz7wFn2qb7ZL6c40Ic25GEJR3ULg2FjIq2AJig1f/gGj2/JP/wfmt0p6mbhgnE8azOuF58QkeHVru+Txbd4kXZL6j5RbDqBtuugJNT8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XPNaUHd5; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763084701; x=1794620701;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=kDgFdrd3qGUMECBmh20OPqZ+gzCzqRaV27Mv5u7K53E=;
  b=XPNaUHd5VobYrNhMx8OKRgN/MRyAho1QrDWQXdzE+V+0bAQHW6ropeHD
   zPlLearabyRsVhHJrezpg/E02WcavE89WgWYgHaoibx3B0GMmUwCdTdK1
   fDM7GVoejh6pCo8ldgKhg+6HCRzFXtj4oaGc+L31C4cl45HoqJPUOR/ER
   Yrd/SSO6cyIy1SaIBH2cgACNk+9W9o+PxPyuXeKk+8tQUWwvIi6Te+tBS
   Bdh5oeXCEzeZBlb9wf3i/aspS3+M+Xxgsoy4av9QrYVwxBApCQ9Uwmj+J
   pM/u9Qa1F96+q9rdUORlf+Cy+Fots2uRm6Q4zalhsg1NgA7keeE/bbmON
   A==;
X-CSE-ConnectionGUID: uufE/vfgTIKd9Rh5GuY8rQ==
X-CSE-MsgGUID: MvSZxHvCQ3iIYTxKM0MJ2g==
X-IronPort-AV: E=McAfee;i="6800,10657,11612"; a="52744649"
X-IronPort-AV: E=Sophos;i="6.19,303,1754982000"; 
   d="scan'208";a="52744649"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 17:45:00 -0800
X-CSE-ConnectionGUID: Ds11AjUgTeSqtQvQtvcRsA==
X-CSE-MsgGUID: D4LTF1ErRfmZh8ru2iDmww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,303,1754982000"; 
   d="scan'208";a="188942888"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 17:45:00 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 17:44:59 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 13 Nov 2025 17:44:59 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.44) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 17:44:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=t46VD0ropvaE7m7FsI17W8tZVaNmbvoDQL3yfdAZ6CkcpkxM3V+bFYPbGxBCFcLPjRxnVZO0gqk7WeB8D6gsuWUB3qvthpxYt3AVbvND495dtvIMvd7gwPzGeAvJjoXAXYjOVNUWsrRFC9bUTQGxEEYR4+QmplbW4RYQJpdJIaIeYBxfnR8rDg46iU2tW2712kC7bJ/A1Mpia3Tch2Re4GKSO9gzDHVe6840jjusfEJCtdQ1qFYbbout03Z3FiBnLUiKj0sTXkr+xruKxrol7NvNzNdH4Vkjt+y5Nrk3Ys25hnRBzN+70po+9iqx+fw+4Q1Mw6D1cKijcORanDxb6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kpBVO6k0cZ/POI4WhSfrh1q/o5tROClE5pMy80/s3Ic=;
 b=JokGG2GUn7ZCTmZFcoQf0uLng9Mzu4E9w+17AbD2JhhYGctd7g9kqfXJrmFkRJTc1FhIejTapoYUAPWSrVOwpLODQrmrEIw1XaBUf9jvHEXaOCfvCocop45YdK2/KPUQT/MXLS5ULVAjAr1ehMik0pdION6Cvr3FQ+IvYeRCSVw16q6kvNF7nUzjvcYsAQN0uuqVx+51Pyz/qMxONx6MBcZXqOTOpEFVTUnmB/sqvr9VX+rqFJI9WirLUpPAYpP3WqvkYs9FxPdHl6o2YX8VTl+FVMD+tpNJs3FswUTDIQu4USb7vPMTmbe4bo5JCu266dJOu+iVRNw20XKV/HMk8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA1PR11MB6967.namprd11.prod.outlook.com (2603:10b6:806:2bb::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.17; Fri, 14 Nov
 2025 01:44:51 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.9298.012; Fri, 14 Nov 2025
 01:44:51 +0000
Date: Fri, 14 Nov 2025 09:42:43 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Du, Fan" <fan.du@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>, "kas@kernel.org"
	<kas@kernel.org>, "michael.roth@amd.com" <michael.roth@amd.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Peng, Chao P" <chao.p.peng@intel.com>, "zhiquan1.li@intel.com"
	<zhiquan1.li@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "Miao, Jun"
	<jun.miao@intel.com>, "x86@kernel.org" <x86@kernel.org>, "pgonda@google.com"
	<pgonda@google.com>
Subject: Re: [RFC PATCH v2 14/23] KVM: TDX: Split and inhibit huge mappings
 if a VMExit carries level info
Message-ID: <aRaJE6s8AihGfh8w@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
 <20250807094423.4644-1-yan.y.zhao@intel.com>
 <183d70ae99155de6233fb705befb25c9f628f88f.camel@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <183d70ae99155de6233fb705befb25c9f628f88f.camel@intel.com>
X-ClientProxiedBy: KU0P306CA0038.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:29::19) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA1PR11MB6967:EE_
X-MS-Office365-Filtering-Correlation-Id: 0475411d-2b02-4773-275a-08de231f671b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?7NJ31F497YSeGBJ1ZGydNOER48t34ESHUO8uL2Okj904rQ6HLANh5gAXvk?=
 =?iso-8859-1?Q?KT1Zt0VAlPjZ3sr4nFom+bJRBrwoCcSuv37NQz9vI0g6hlnQmSSZx7b1lD?=
 =?iso-8859-1?Q?8Ab7ArXIVbgLK8AjG8wKf9c6jyylUayFjmpBpbo9gBmBhLv8/caxRXY0eC?=
 =?iso-8859-1?Q?8cuI4fQ0AKT6OOSl0SaZi3EHwQy0F59P3YZ6xsPtOVXb1qeE5jI8QTu8N5?=
 =?iso-8859-1?Q?4q4mMzgRjheZEi6/wJdZNMdqTldECyVEV12dBOHuQXmYyXdFcvvErDGYeU?=
 =?iso-8859-1?Q?bvs1gQfh4n4dbCwieiTjwYAhEtoRXLHEYMay14L/OO3gsur/JRTsrpMwwM?=
 =?iso-8859-1?Q?TqiQ9hiiAFKLS7iSLM/cCV0fbmns8knXmPl7Wi3hFOqMsCXb0jcoKTInNR?=
 =?iso-8859-1?Q?48RsQ8PHri8fZDwEWWCoT6jogZGodNFcLsaxYgzsio+RSQ6Hdlkm6E2K5n?=
 =?iso-8859-1?Q?FIqiTCzetdbPsDo+e3wz/MOm+Dg9CDGKmDwzA+J3wkPLfpvcWT8H973StA?=
 =?iso-8859-1?Q?JQw4/tL5llrzhF6+rioABTaJDWVjgKx3vPTYSvUEh5pnMZaUwe8BzlWgrH?=
 =?iso-8859-1?Q?G47Rdbq/sQX5pQEFW5FJ9WZE3DYAD1SpOsTHKmGhvHlka9cQY7G/1yOHxn?=
 =?iso-8859-1?Q?soUqbTm2r5tfZfGBCOltFNNQN7c/iBKZ2P7l6fK/tGQJB16TvjFYtTmhmw?=
 =?iso-8859-1?Q?UcjO3ryk5DLfQ8TWwOEXAbENMJ1gGB38po8K87yZ58x7+AKlL9Hf6DwTr3?=
 =?iso-8859-1?Q?R6YD6kBrRXJVMAIzUE6F/uv+mDndA56/JHpZifVcaTcgOh/wsr++drCTEQ?=
 =?iso-8859-1?Q?89BodCS1OovY3DqXWkZ2wvBzlDx+udT/FnfjiaNLGpKH7mbBtJ9PJVWIRS?=
 =?iso-8859-1?Q?rckTb/bBSZFRw2qyKceoW8mQ3BQkWvI8asPO2F/3n9uhwiUQmnSaIPRJgP?=
 =?iso-8859-1?Q?vquD5eUo+OAhiR6yepE9cQiGIgLpy+j5DbS2D+4D4Ew3V82sykRxzVzSbf?=
 =?iso-8859-1?Q?BihUjJvSaAH+1WOJEPe0Y9Cc6fi7VudEOeZa/QzN8/HJZrRRwiJ1Bm6AOg?=
 =?iso-8859-1?Q?5YqyZqTZui1Bv3YWvIUGmXwdE9Hiyq1QmNk0YqAV4M7Kn3bvjGPt8ro6fK?=
 =?iso-8859-1?Q?3Or+FK9Cemuj8lq2o7r7kVn9VOqtQIUuH4gNdTBNItDCBx/0VHuYJeqCDW?=
 =?iso-8859-1?Q?k/j894Cax8jDPeoa/Ohb8a8xAIDc1IANWGR5S3H06nm1WndrwguvrwYb9m?=
 =?iso-8859-1?Q?dx+7UeGUgoNfFtacvtpuD6nKmFP2OUl4MQWvu6H4H6GtEQf05nrc+sd4oS?=
 =?iso-8859-1?Q?0i0YVCXcDQEZAA+izpCz6q7F+2qiJ3eshmzgggVEjx/MJBCIX5Y0z2QY+M?=
 =?iso-8859-1?Q?hJR/vwharXA7nQphTOAVaMj70VSICnkiWQXaaPLUtoqqTLLwyxQkfdpA6Z?=
 =?iso-8859-1?Q?kiW2Uxw/B9mgoPtLfj1c1WO0Pluu96xwQ9yX/nUmc17iynkBBOFFB3e8eM?=
 =?iso-8859-1?Q?+cn7lIKHAJAFLMn6gb7bVj?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?OrO/y0ph/uiAufH8lINyHlSDQYPhlPI0X52ZCS+c0UtQjm5F1eujB81jOp?=
 =?iso-8859-1?Q?64qdhZPtsPoNIDxbILb1HGBaNUl+TVGq4Yox9RKrrVe9jGlljHki4kZn41?=
 =?iso-8859-1?Q?3+USOVAmLk16C1LWP7o6qx9uqoUXONTpL7AUwZln1a10I2gTAYE0bx/hZD?=
 =?iso-8859-1?Q?LGdwNgT8iKb4U7lWPwH4syMLACAG2m1PbP0gidXZYQ0ahBWwzpzxu5j9pl?=
 =?iso-8859-1?Q?blXTLWfbqD4QVNOJPkHEE/UkaftLX/olatxYmHqwdKGDI1VEMUlbMY1gDa?=
 =?iso-8859-1?Q?oO6eXKUmb6uTeO9loAKdSiXt4qzPx7JMaa86l3KG45yEEx633Adkw6vDw2?=
 =?iso-8859-1?Q?xKy8B3YNsF3Cg1Cfm6lCuQFCHbdJB2oBd0d+qQA5VdeGXdVNlfHfeKZrjR?=
 =?iso-8859-1?Q?Sr4ihpnN440nE2neXAx2quW8/2Y9SCEp9l/cgMwGi1ImPC12igQnVnA/u7?=
 =?iso-8859-1?Q?tWW1YxY9ss9caFqnDo9YK83gAKRmh6E4o2DgstAuOco0xvBsAip+Sqpm/0?=
 =?iso-8859-1?Q?krEpLyFthg+McZ750zyQhzE0Oy5Ee43wGCB6WLdHA0S2p//V+WAW7ZZ5J9?=
 =?iso-8859-1?Q?cN0+VUxwgcOswcllQgRx03yXhVhwTRLID+Tnj1w72u2uBZIfIgZKkkKSyW?=
 =?iso-8859-1?Q?9LIY3CdFCkLm0j6p412JxEzC6tHeBKw5COsXjzGGiJBUtv+2HT/jBdAnV8?=
 =?iso-8859-1?Q?1fE77KT6vgYMTy1SdqKeIkrlMycmS0s0gNzUWo/FF2x294ibOaeFxuSHWr?=
 =?iso-8859-1?Q?mwdi/dWUQO6idy+F50Ks5V3aNxVqq8M67MWhpb5z7Xx/mwobdvSyOgIy+A?=
 =?iso-8859-1?Q?pqZCTNwTb1pV10huErPK1D4RErN1gOSW5Abll94G19bG0r3VjFFPuwJRjh?=
 =?iso-8859-1?Q?PRy9Yjn9rWqDJjnKk2O3FNegrMMYkMqphT0Tql3n6RK4mrMlrb2SvsWOUv?=
 =?iso-8859-1?Q?7pSv9DZW4Ed5Fe+j7dvOimPsCYvYJBfZ1aaoB5Xh/XYRCdkOBAIiRU1qXr?=
 =?iso-8859-1?Q?8/0TW3BE77WLKyjZtQOTlBwUNfzvNzsU4pDG30mUBOM3GAt9xYCtNsPxod?=
 =?iso-8859-1?Q?vV8clzYyaR9yxmHAoNPUCzuOTa6A57Q+Xevp0OKoqu9I888QSOfnORIqfB?=
 =?iso-8859-1?Q?4VudNTyTTnQdAcpcDN+4nI6zA+zAOOgkT4dOLKZshYpJz4by/nG3Txvzdk?=
 =?iso-8859-1?Q?nLDSDqWG5H0PR3plWhvj8CUhlxVJTsXbRpSM24jYWKii0wvBIOsbXTaAE6?=
 =?iso-8859-1?Q?b1iHgVYo2UUccXx5Sw3WIa9jXEq9NDRx/dzL0OpD6f+wN+ef21uY0q80/9?=
 =?iso-8859-1?Q?/Kyvy2CNTdvv5T4VRLUO2x01dHjX2Jhgx+3Tybsv56us83dT7ZZmOIi7ji?=
 =?iso-8859-1?Q?Xr5CKePKlByG1tyEHH+ajKrMFSshLnfnWFqfrrfZJ5Rt02psPq2ljjR9mr?=
 =?iso-8859-1?Q?KTFS/OJec0+d+MhnMA8cyZDtc95tvnY8uYPhhQWzkk8zzsG97bY/aRK4t/?=
 =?iso-8859-1?Q?CWo74AeO3asps7r2EXvt44cnUd7WoBltIpZytAzMLDQuyG/pv/9nhUV++3?=
 =?iso-8859-1?Q?WvwUV9gk+9iHqAP+nLNyLP33Z2JG3kYeSKMJvQEXLd0+jD3B6SUoK/QPI5?=
 =?iso-8859-1?Q?Z6FSLVXHSmrHsh5ipZVnllb95i2/WZCvWi?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0475411d-2b02-4773-275a-08de231f671b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2025 01:44:51.6746
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rwkYlGg1IOzXanPpzJcE0VVH2kZZjrv/QYr3XJqdvReuFOgwJopstoTUstU2HPoAMwJqQvfsPcuPmeGpdzPNTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6967
X-OriginatorOrg: intel.com

On Tue, Nov 11, 2025 at 06:55:45PM +0800, Huang, Kai wrote:
> On Thu, 2025-08-07 at 17:44 +0800, Yan Zhao wrote:
> > @@ -2044,6 +2091,9 @@ static int tdx_handle_ept_violation(struct kvm_vcpu *vcpu)
> >  		 */
> >  		exit_qual = EPT_VIOLATION_ACC_WRITE;
> >  
> > +		if (tdx_check_accept_level(vcpu, gpa_to_gfn(gpa)))
> > +			return RET_PF_RETRY;
> > +
> 
> I don't think you should return RET_PF_RETRY here.
> 
> This is still at very early stage of EPT violation.  The caller of
> tdx_handle_ept_violation() is expecting either 0, 1, or negative error code.
Hmm, strictly speaking, the caller of the EPT violation handler is expecting
0, >0, or negative error code.

vcpu_run
  |->r = vcpu_enter_guest(vcpu);
  |        |->r = kvm_x86_call(handle_exit)(vcpu, exit_fastpath);
  |        |  return r;
  |  if (r <= 0)
  |     break;

handle_ept_violation
  |->return __vmx_handle_ept_violation(vcpu, gpa, exit_qualification);

tdx_handle_ept_violation
 |->ret = __vmx_handle_ept_violation(vcpu, gpa, exit_qual); 
 |  return ret;

The current VMX/TDX's EPT violation handlers returns RET_PF_* to the caller
since commit 7c5480386300 ("KVM: x86/mmu: Return RET_PF* instead of 1 in
kvm_mmu_page_fault") for the sake of zero-step mitigation.

This is no problem, because

enum {
        RET_PF_CONTINUE = 0,
        RET_PF_RETRY,
        RET_PF_EMULATE,
        RET_PF_WRITE_PROTECTED,
        RET_PF_INVALID,
        RET_PF_FIXED,
        RET_PF_SPURIOUS,
};

/*
 * Define RET_PF_CONTINUE as 0 to allow for
 * - efficient machine code when checking for CONTINUE, e.g.
 *   "TEST %rax, %rax, JNZ", as all "stop!" values are non-zero,
 * - kvm_mmu_do_page_fault() to return other RET_PF_* as a positive value.
 */
static_assert(RET_PF_CONTINUE == 0);

