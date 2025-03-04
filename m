Return-Path: <kvm+bounces-39985-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DA1BA4D412
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 07:49:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E8D387A620D
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 06:48:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4121A1F540F;
	Tue,  4 Mar 2025 06:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SGnIDFKr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B9913C67C;
	Tue,  4 Mar 2025 06:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741070934; cv=fail; b=LVwAHYxzMLwOzBIzWsbElgL6dyevnTy+bTcXmneEPAIG+nuo1OhnPI9WgR4sVAymOpORUk4nFHjdozmsAe5CGpTn2sZimBSpPtEJzjAo7wT3FfEm7KOHe36FL2uiM2B4gmLdYQPFdPFgvZw2dDjiEHRKTToLhgpG5744gCa5d8c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741070934; c=relaxed/simple;
	bh=m7vJuTnwkh6bJ/QDO3hRy5rhJSXU0GWrE/gtxXj+FYc=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GiOe2d7KgEbGUaMQiC+fJ5pOJVEmjUH1g0gaucm7So0cpscm2XtraK1RKDm4YZUnahiFpsIc4ykuzXsHsAhGVeZdJWL8Q06LZSzte027TAxqAiDG+64ot6S0KPSjrZQevAOBRb+TmfM1Rs22P8yxaRUfUijCeOgM6KFe0GWiG8k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SGnIDFKr; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741070932; x=1772606932;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=m7vJuTnwkh6bJ/QDO3hRy5rhJSXU0GWrE/gtxXj+FYc=;
  b=SGnIDFKru+DDjHUtKP+qZuOMLOT2x48Q3WWDlcrigys8jdEPltgwvUBm
   bMXynsUMPnC/UiXeJaLfAkC5ifcGcLfMdYnaSeGoZMqnz4eXZbvdWCNTB
   cys+eKKPENZAlAzhVZZN3IyOxa5kJPJlDOqT/qZU6ISTYVVYzNz48Urn9
   mQyNENQhB5rhRYMpFIaE9yJY9wLT6p1bixL0hdLr3OwJ2lsxLdHxOlB5N
   WdPdejqp1A8m7pWhjpQVDms6mW1eML1NDbIQ2qzLDp0Fv0vy4WFj7fUxp
   hTrqdq6x1q7R0XbA8AdfV7vITAWiHRTAQ3OUEVxj8OH6VD0o3U7CDEX+p
   Q==;
X-CSE-ConnectionGUID: AHyIWMFmQsq48/eudKRU1A==
X-CSE-MsgGUID: s1TkI5y9SQaDjeqRsV3VKg==
X-IronPort-AV: E=McAfee;i="6700,10204,11362"; a="53378537"
X-IronPort-AV: E=Sophos;i="6.13,331,1732608000"; 
   d="scan'208";a="53378537"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 22:48:51 -0800
X-CSE-ConnectionGUID: d3BvHj7gSRKbYJL/YggIjQ==
X-CSE-MsgGUID: EjPA1KYNQA6WYdut5RccbA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,331,1732608000"; 
   d="scan'208";a="123300084"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2025 22:48:51 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Mon, 3 Mar 2025 22:48:50 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 3 Mar 2025 22:48:50 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 3 Mar 2025 22:48:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vAvZjtxwGxudz0UfTCraM1NnpUu3zqGsftT8VlhDd+1B5EYT4JNYEje6hyyF492yvr4Hj919d2gjudHhshavMew+U6xEvD264bDpUxT4HMtcohe5Pi9piqVyltPh6buGTqxX+2VKx//HE4dTdY3J+jfK+TZur0a+hxsrq9A31nGncHQqiF165+AnjF2SOWfmNnWiRI8ERzTufvnqi3D8NUDuvtpABHLqeArh5d08xjfip6ZC45bGSB5A9N5ecp1JssTvMV3NHSL6AkCoKAWSXXq7dc/dVgr2rCy8SVonMjWioWkgXodSfYwcUAGifXVXbMX/lXn52T8aIr1uY+jJ2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DclA92XuPool9LW4eUEwZCVFUK6nD9M9cRA5YXbASWI=;
 b=glRQKBwDL3cgsKgTcD3fQxHEI84ne0okIntwfQimo62+OCOB+whYXj4mZ8rEOGxXXfTUy22yV+NkGlQw7o3DJis9hnQ4t850f6ImnC9xj0bMbWnXLKE5AO2S9po0MJxy7pTyHDAlUIrx/eG6n3QlOK5k7kxXWwl649Cc9Z3mAbC9mku7HZj/Kdyj41pXcrciONwK+dqLcnkA5CzNZ+q213CdjAxpc2lpuF9lnGzC3FAgnVBIECzGEKEYV0Tg3nh7lU398wrhstUbvZXufjn33TSYkO9vDnTn8QfjochraCpD4CAzZQ3eFQIA1x/9aMMGC/LHW5HPu5+/Wb0MGKEHZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB5964.namprd11.prod.outlook.com (2603:10b6:208:373::17)
 by CY8PR11MB7082.namprd11.prod.outlook.com (2603:10b6:930:52::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.28; Tue, 4 Mar
 2025 06:48:01 +0000
Received: from MN0PR11MB5964.namprd11.prod.outlook.com
 ([fe80::7a0e:21e8:dce9:dbee]) by MN0PR11MB5964.namprd11.prod.outlook.com
 ([fe80::7a0e:21e8:dce9:dbee%4]) with mapi id 15.20.8511.015; Tue, 4 Mar 2025
 06:48:01 +0000
Date: Tue, 4 Mar 2025 14:46:40 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <seanjc@google.com>
Subject: Re: [PATCH 1/4] KVM: x86: Allow vendor code to disable quirks
Message-ID: <Z8ah0PmLQRk/AgFE@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250301073428.2435768-1-pbonzini@redhat.com>
 <20250301073428.2435768-2-pbonzini@redhat.com>
 <Z8UCosKAJIUZ5yq/@yzhao56-desk.sh.intel.com>
 <ad542d2a-f4f3-449f-a2b9-3c0dc1d4905f@redhat.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ad542d2a-f4f3-449f-a2b9-3c0dc1d4905f@redhat.com>
X-ClientProxiedBy: SI2PR06CA0010.apcprd06.prod.outlook.com
 (2603:1096:4:186::6) To MN0PR11MB5964.namprd11.prod.outlook.com
 (2603:10b6:208:373::17)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB5964:EE_|CY8PR11MB7082:EE_
X-MS-Office365-Filtering-Correlation-Id: a5aa1c33-7650-4535-1447-08dd5ae881c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?2+KavxtFoGBr+otipznge5uH+t8AGKQccK2D1BV4sNhrI32tgxXwzVBvaLMB?=
 =?us-ascii?Q?9LhkFSH9cAMFVWR7dXpsIWEiemJALExSa/VbtQrUxuWpQoVtCyyS1TtthR9J?=
 =?us-ascii?Q?hVJ9hx2n509uG2bCV2ZbohulZr4501v7y5Ee1PoKkAj7GlKqlet+vgtI2DFX?=
 =?us-ascii?Q?qanUW59cmKDdDiioxyVxYKiNGQeWzmLmGW34XOGTHhjc+2PFlKbdbK6lC3b2?=
 =?us-ascii?Q?QrdNqQG121C7NhuDuSObNHlEwC4fm0JG4v7EXCu6bifB8wJdkUoIfKEbSKob?=
 =?us-ascii?Q?7Bx2Q8YYb9uvM3B12tk5J+VzK5byTPEQ8P8YsgN0LELGod9HHzn3cQXFe0SQ?=
 =?us-ascii?Q?3Ho0ykhgayaVpQGCv9OR8YqMkLGntrZ/deNq9MbQ7K03CuqmpPp7lV7DEMl5?=
 =?us-ascii?Q?FKj3Ns45tG5rOqj7vdof3zkfbUs2GzhjOFnqSgAulsTRwyF2Vqday54nAx1Z?=
 =?us-ascii?Q?gAtXcYlbWHqaVhwg3O4Dle1OIgbkOh19VlDIk1YcAWZweC8mj1bU0JN+oJOl?=
 =?us-ascii?Q?Mgq005ynkNeU+ygSYOmsA/tF6iIr9oOgQZWDHQ4YKIDcaLmdM//2Tc3IQNtr?=
 =?us-ascii?Q?3ZyRQc9Tx0msMYT4hZAHcvkgfImsc1B/8z011HyoAyiYvWws3LfgXg/SBEKx?=
 =?us-ascii?Q?PEU/ZvFwLsBGoJGOSsc+vkkckB3m2yyaZA/eYkQE49r6UUemREKuRiqzNTdB?=
 =?us-ascii?Q?yt3Z9tdbcNFoQhdqmVz+MzaIgr86+puhN31fIszBCKNz7IwbahlsvDjreVX0?=
 =?us-ascii?Q?VoczX07KrSPtz3u42XWiJJzKtIzFJcIeuuBdVxuEyTPj7ngSTXU1S94alUZF?=
 =?us-ascii?Q?0l/Osk9bZR+ojZgurtgs/DWyuZ2FmFJCzlfJNqBhzUw1FM+rTGQHsLUQ4KyU?=
 =?us-ascii?Q?AXqn25YBa2u040FuZIQ+uzlMZqVZSw7zlBGGUIdGECBECZmlu0MarWIciKo3?=
 =?us-ascii?Q?jcleyKCNX7F9tRAAPYx/SJ51q/nlIEUe3jZSdNg44oot13c1101PW0bP8zfg?=
 =?us-ascii?Q?k8ZiYM/4E+MFmZ7NamWrxrB6ya+YMIfHQQN3JkWEwYMkrf7xRm1/GWKFde3p?=
 =?us-ascii?Q?s7BAIn0DLNkj6nFx+EpJZlA5pASGfIq6yrbbHx3oyDNYlrzuKMykwzP6XnT6?=
 =?us-ascii?Q?3Qqcp6xSWIO8oF2Q21pipI3WaZCpuH0SzqSxzqcy1NdVnQS2IPAs5ITxyRe7?=
 =?us-ascii?Q?yEUSjaL0V/XF/Wsqd00paOS4+aW8KisbUEXvrBnYnWvUCXm63bdSOMrIkKam?=
 =?us-ascii?Q?0DBqE2k5ONc8GILbxAneXDrui8OPG5THcKEVqSS7a8prcUJ6IJ8BsWzRdIVc?=
 =?us-ascii?Q?UfGdNtWIY6DYPGBfJBUusZ6YSSb7rHALLy2zH7UL2DwZWxPiy/qpw+tgsQH8?=
 =?us-ascii?Q?mTd8MRQj4QmJbBIsYco7C7UGRwTv?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5964.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?d1T9pCofc/KpILKfTLnzP5vdag9F4YOQ2ahRQY1yQnk1Lmk5aQ4m0dtKSOdf?=
 =?us-ascii?Q?Drn5m/SqlKuAUmz9oVlC/s3hUWV4jFhamCYc1C2yOjVj8EiXAay/c+BboIc9?=
 =?us-ascii?Q?L262YiuYtzRLxTVFxgnvmd90BcxLhrWPg/dk6wSDpKk6OD4DF2r6L8lfeM09?=
 =?us-ascii?Q?63VwvkOGqCMpoWfN4Dbk2cmEVuOWD73Tl9IqUk9qfki4HY3x7G9/gjshoxmN?=
 =?us-ascii?Q?V6fvm2XpO4aLsqKCNBIIVAQ5g77QzQOGi/emcsIQDk+NwJcvnSsPA+/bsqWn?=
 =?us-ascii?Q?0vD4XMawfzR6q9FTCwDuCwwOvj3v5V2q6erL2LBf8BOuv8BP03lYniWxh30v?=
 =?us-ascii?Q?ug3grJ/ToZzrnHXm/mXY2mXCDivL73Vvj4Qx3LmUfT042xPVGB1WGvBlgxgL?=
 =?us-ascii?Q?J0YkRhVbUXZHxbOdpd+BuuLVjEEdR/cQGdtisxp3RspJjJxKU9VCiRQhPYb4?=
 =?us-ascii?Q?XybWYWPVrc4ZDEUZUf6Ag2OdjWonLn6aYO28ai3m3evN0fFatMNrWVmZ3QMB?=
 =?us-ascii?Q?46FyRnDeJb6gzQ7rqHtMzZhPBzQVx84lRtrzb9iGp6q6k33F78ZyLV3VcLAY?=
 =?us-ascii?Q?ONGBGeiJt81eyEA1I+h303BpxDfHfe4HbdytOI/ZWzk9byvjPG8INy25Mt3f?=
 =?us-ascii?Q?hHCpFI92M1O7jlRmnYDTWByuOoC64IYA4NbIGh0nPEkO5+AJHfvII1WGuKVh?=
 =?us-ascii?Q?i8Lx8Pbw/32Xthiif/VcU5tpqh++7+I4aE0UmoIVRJqvRM1CpGbKq0iCJPhO?=
 =?us-ascii?Q?14bXpXLt3y6doL1xbvBTtGXyvUeG5+iBNTCOZyq0mMtS6YYJlgzPImEDC+GJ?=
 =?us-ascii?Q?c681agZPdpYkeQXO1vEiBqPFY3Vc66hkzz/65XYkZb0RrJzdEm4mV3/nWSFp?=
 =?us-ascii?Q?SkIbpyi6uW6fhjt4t8aBQdYK6IYUWJHmIY5/xzpbKXGPXLAV7uASyQOoXapr?=
 =?us-ascii?Q?ebYGuekcK1HJGoeFWvJ+KybCExdylMDLd7rq5OWBCqNPyWYZqN/31qlA7cB+?=
 =?us-ascii?Q?fRYp1QfRE+CF2QwBPPDEPmE2mXCT4lc3huKI0gXPNxbGsppFnFNzB0FYomXr?=
 =?us-ascii?Q?2YoZHFblM/8YUeQKKO0CX5Qr1CG4o8NB/uDEJIE5mlZKmtQ1504WH+2KnmsI?=
 =?us-ascii?Q?mGzQC/mGn63p5McAEjfzgEhpwY1mZcgYZnkun4qXy1vgLbS7wrK6d+O1Oob2?=
 =?us-ascii?Q?XziR21F4siMqevqASjz5+4QlVTQCLimsSO7/PM/OcWd0LqpNjvpoqV1YkV4l?=
 =?us-ascii?Q?90hPJ5cH3A3Zfn9qhPql4IAPcUbe5xH38YCrVdiaEL0/+EQmzGtU/WN0INob?=
 =?us-ascii?Q?zqKaqx/yIPD/kc3i+m7BPUh9I0pOjKMkqJA4xqtAP0JE2vKdBD1+FKjmA14I?=
 =?us-ascii?Q?EbFvr8P81s0iiVZUE/31W0Q+hIUdbDXyyZB/FsfwVoPoAp5RI+t6g0LhPume?=
 =?us-ascii?Q?jyywhtJquMhzs/3LaGHJV15cmCEgcCgY9qGkIZm+OzaZoFb0u+JUDNCr0CrG?=
 =?us-ascii?Q?lnJVmf44CDpJD28sWBS3pwS7Geh8nnXkAL1RTjezq//WEZJRE/Vs4cml9whP?=
 =?us-ascii?Q?Fxg7tXutPh40Lypzfhaf+oYhFhs72hD5HEUbYVld?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a5aa1c33-7650-4535-1447-08dd5ae881c4
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5964.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2025 06:48:01.3509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1LKbQUHN+rx73P75V7M2E2qT0lqHiqER7sGFyJ2b7zP0sX+ntPKZsjhR2wINQHHtrQPXYuEFUp4DX4tve+GNOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7082
X-OriginatorOrg: intel.com

On Mon, Mar 03, 2025 at 05:04:40PM +0100, Paolo Bonzini wrote:
> On 3/3/25 02:15, Yan Zhao wrote:
> > On Sat, Mar 01, 2025 at 02:34:25AM -0500, Paolo Bonzini wrote:
> > > In some cases, the handling of quirks is split between platform-specific
> > > code and generic code, or it is done entirely in generic code, but the
> > > relevant bug does not trigger on some platforms; for example,
> > > KVM_X86_QUIRK_CD_NW_CLEARED is only applicable to AMD systems.  In that
> > > case, allow unaffected vendor modules to disable handling of the quirk.
> > > 
> > > The quirk remains available in KVM_CAP_DISABLE_QUIRKS2, because that API
> > > tells userspace that KVM *knows* that some of its past behavior was bogus
> > > or just undesirable.  In other words, it's plausible for userspace to
> > > refuse to run if a quirk is not listed by KVM_CAP_DISABLE_QUIRKS2.
> > > 
> > > In kvm_check_has_quirk(), in addition to checking if a quirk is not
> > > explicitly disabled by the user, also verify if the quirk applies to
> > > the hardware.
> > > 
> > > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > > Message-ID: <20250224070832.31394-1-yan.y.zhao@intel.com>
> > > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > > ---
> > >   arch/x86/kvm/vmx/vmx.c |  1 +
> > >   arch/x86/kvm/x86.c     |  1 +
> > >   arch/x86/kvm/x86.h     | 12 +++++++-----
> > >   3 files changed, 9 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > > index 486fbdb4365c..75df4caea2f7 100644
> > > --- a/arch/x86/kvm/vmx/vmx.c
> > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > @@ -8506,6 +8506,7 @@ __init int vmx_hardware_setup(void)
> > >   	kvm_set_posted_intr_wakeup_handler(pi_wakeup_handler);
> > > +	kvm_caps.inapplicable_quirks = KVM_X86_QUIRK_CD_NW_CLEARED;
> > 
> > As you mentioned, KVM_X86_QUIRK_CD_NW_CLEARED has no effect on Intel's
> > platforms, no matter kvm_check_has_quirk() returns true or false.
> > So, what's the purpose to introduce kvm_caps.inapplicable_quirks?
> 
> The purpose is to later mark IGNORE_GUEST_PAT as inapplicable, so that the
> relevant code does not run on AMD.  However you have a point here:

Or naming it kvm_caps.platform_disabled_quirks?
> 
> > One concern is that since KVM_X86_QUIRK_CD_NW_CLEARED is not for Intel
> > platforms, it's unnatural for Intel's code to add it into the
> > kvm_caps.inapplicable_quirks.
> 
> So let's instead have kvm-amd.ko clear it from inapplicable_quirks.  And
> likewise kvm-intel.ko can clear IGNORE_GUEST_PAT.
Sounds good.


