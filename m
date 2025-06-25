Return-Path: <kvm+bounces-50645-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 92E49AE8075
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 12:58:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 400233AC51A
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 10:58:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A06B2BD590;
	Wed, 25 Jun 2025 10:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TWpBD2Mh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0CD29E114;
	Wed, 25 Jun 2025 10:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750849075; cv=fail; b=pvpEZC1R7hHDr9IHx375755SNRJQC5uSZ6bUoBz0ZqGQGMwT+mR3LuV6KiCfGBVFNqPOjZ3xzi/dIF4oIaTA/ScNnTSxTrzpM82Ql7/71eLdeks0uUfI+Gpw+QWxY1+ibicBMo1VKZq7DMU/jfjt2xpGA412IPUdPqb73e+o+8U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750849075; c=relaxed/simple;
	bh=9RQGHYZ8/mptf0DFRGEuA30YwFy9MQVHv65ao/JJSFs=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=NkgO98kNNstHfVCA2LYKiuFnpoX5yMBsbf5r9gx4/OAMhCN4ifmKNFiFC0/V4Kp8QgmQ7SllvztV+3d7wbqfhe7hDlBJNN3tgaaGwHs1iEDI3YYMUv2L+ZF+7L/rkOeoOKOpktvD7K/OaB+oRH5M6XVtJGFQrSvjF7O+yrUgngI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TWpBD2Mh; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750849074; x=1782385074;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=9RQGHYZ8/mptf0DFRGEuA30YwFy9MQVHv65ao/JJSFs=;
  b=TWpBD2Mhk7iahcK3bJNRwqlRjmMkHQWlt04zK3+3fTzqzl+B1SMFxG/m
   //ckvHlf7hwa92IGowhVv04hnp2vSn5JHImPMd1anm4HGPf+FcOvRIFhx
   ohUfKTSV68IDo142+kjGM/cIh/7Eamo6x9kSslA8lhAIokGUKqG5mJ3Pi
   plT9p9hcOkkVqoEI57+3stHqVXquwMCn5yI6gANR2SneNenbXSNDcnLgQ
   JevToDFj1FklVuFN+PSrGiJJCC85j6VHxCowlrbTDFFkFw28Jg8dP6LSm
   EfDTfmYYXXusxsBmsqSB5ro4L7fMBA+Ba6ppE3vntUAVhRUJ5LaHc3vmF
   g==;
X-CSE-ConnectionGUID: X25ORtLBQHGyhjrAJiEnVA==
X-CSE-MsgGUID: csP4d6pWR5+OryrKw3JhKg==
X-IronPort-AV: E=McAfee;i="6800,10657,11474"; a="64173010"
X-IronPort-AV: E=Sophos;i="6.16,264,1744095600"; 
   d="scan'208";a="64173010"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 03:57:53 -0700
X-CSE-ConnectionGUID: vM3aFAKLRg+PH7Mq0yBVpg==
X-CSE-MsgGUID: przeCYlZQNmc/QIhnKi7ZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,264,1744095600"; 
   d="scan'208";a="152892731"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 03:57:52 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 03:57:51 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 25 Jun 2025 03:57:51 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.62)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 03:57:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fLYGOW+V/jGfbpEFqG90OyVPYWbJC1HO74LNFQp7JFeCrtCDLkoknwttHJ08jNBrQalnlqaN3V+3LBOcwhmHN0s+Q27ByOpd45A6JexIYY+m1X8f3bLMZJh8PaN27UUSzksIPDarp7BxWSz7RIotj71hGR3+oUXNrmVmfGyTZ12yqc+Vhw1YsWzPd5yEndwhhEH80tm3ffMTxmyG4dH83CQ7StffaJm1uXoU09yDpCisGxOl3uLW8KuGxE+aVgL5Rzu+A1dWRn/yPCaSVoiPxNosH+TI7LlTn6CDLeNX0s9aTy+xUTzETfWMjq2X4YRdCRNe0XtyJkv67pcxPsb53w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bscGB2KteQGvcYiFrjNqISDH5/C2DPGPGn+4kgMNz1I=;
 b=u2dcOsaYqPxc7UQ6SnTbckrNop5f/mlt24GsfPI9gpS/5WnPexKb722H0UPeY6KQ6SaBeZvY07J1a0hJ40/UU5U1DgWRPaYJ/irJs0qIDXsrbDnu/1qCKVTYfVAhcltGbKMuj6wtn1VyMHe6+LKizvHBrrDZOKt6MvMhZBsYdtjgmufUAATJPzgYS4+WkVJnOiYtylqz1ybtzroI13teAmjiv/288G3mxfEIr1fMGCKN4aOG4/IPcbwQLZkAQDhpI9+p279uNqwcH8vHv2+kaNaZIZxo5bX0WW5VIbyQHoyTLTN0mMCKBQUCP/6SzYn5JCD/dDgfiqv/c0Wk4PbyNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by IA4PR11MB9012.namprd11.prod.outlook.com (2603:10b6:208:56d::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.28; Wed, 25 Jun
 2025 10:57:50 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8835.025; Wed, 25 Jun 2025
 10:57:50 +0000
Date: Wed, 25 Jun 2025 18:57:41 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<pbonzini@redhat.com>, <dapeng1.mi@linux.intel.com>
Subject: Re: [PATCH 1/2] KVM: x86: Deduplicate MSR interception enabling and
 disabling
Message-ID: <aFvWJY60b7NSXmVV@intel.com>
References: <20250612081947.94081-1-chao.gao@intel.com>
 <20250612081947.94081-2-chao.gao@intel.com>
 <aFsrHCZfB_R1Fao7@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aFsrHCZfB_R1Fao7@google.com>
X-ClientProxiedBy: SGBP274CA0024.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::36)
 To CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|IA4PR11MB9012:EE_
X-MS-Office365-Filtering-Correlation-Id: f8200087-f237-4073-c9c4-08ddb3d72084
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?w/UVvgQ+hnXw+xyCwSxp1FbEy83xVgAjQRojwy/wTq96l6RvIeJ4SMqI/fJI?=
 =?us-ascii?Q?g58T+SNkxKqpIazqXIRztTRZnkJnrzrsQ9G26W7dNZaqexPQyTIRACoTeyr3?=
 =?us-ascii?Q?V+/puD3nYBopH2uMx9lFUJ6ecD9RLsAMHGujIGn052UMTe/fZrPQEYpsvCUy?=
 =?us-ascii?Q?264eD1I+1+dX+TP9PPT7IsbbXVWuJXs62DPca/0PkIoX+PlaH7oVVbSi3KOj?=
 =?us-ascii?Q?xy3nQE/spHw2yFgQBNZo1dmSwYmmUpM8mMg1sogKeWmdSMvzR0yxJYOKKCxL?=
 =?us-ascii?Q?JoAZmxGa5tBovG+1psYnPaAT6ZG7+XdcBZmRE3sNOqd0wUTsmY5n1GLu0tLy?=
 =?us-ascii?Q?W1om6YM/Ne6FeOJiwnpMnzaWyoExkYgrToUhmO5+c42Cr1EpHRW7fGZfB0FD?=
 =?us-ascii?Q?Vu817OE5V6qdea+didxJ19j59jnSQhdLFURLB7KatcAbhV3guVQjingxBHzR?=
 =?us-ascii?Q?0LfKt+ZLJ5Hhtlwjs/0JiuRKU0x5ZyygxxHR1sLzGHkdUK7Mb5v6yzcvJ4qe?=
 =?us-ascii?Q?Ru+MFUF7ULo7s7mLlY9Pe6DQgPRGNEe9AKnyy4s+3U7rao2HyNl025i4krwm?=
 =?us-ascii?Q?dMVG0tnaF5PMuI8mAO+f9gOZqghhD/qfI8XUezcVZC3wNyxPU5wJvi1lw1iN?=
 =?us-ascii?Q?5BgxvY89yj1F/vaxg1nZt38xkIZbl5a2sm7hpBQl26n6EfylfZrCTCsIn9Cj?=
 =?us-ascii?Q?KhouZu7oCV8u5nT1+pRz/VER6UncX7NwprPxDyiwqqaf7nYi7zB2lMJ5cqFJ?=
 =?us-ascii?Q?PIofw/blnYsRgXq0/HyVJtf5PrmH95DGAlufPjgaUcYsTZRrsj4RC1mKAgqq?=
 =?us-ascii?Q?9E59BjLrwQu7MRdwZFhAv0ipoRs28D04mRF/L4F4MqR7u9UJe3d5pz8J34Nn?=
 =?us-ascii?Q?2sb6gefKRcW29suxzcmio0+PzZKOyYr55a09j7UO5XAse7adRgQtAnOEirAj?=
 =?us-ascii?Q?3tpIjMm1w4Rsg+5llyYHjajylTdz03vDKPz4L7gx6DoReRCIh99DkzDs7gkj?=
 =?us-ascii?Q?65a6DApIGMUwlVbTTwtXk2mWHx2UKQEj8p+cdZnQA9yx51T67xI7hM/a2Uuo?=
 =?us-ascii?Q?Uu8ujsTKXVkWcQp1fPjY6Cb5zzQBaaGm8fPhZ8HnrKGujj6+gmQ42sfVqbsK?=
 =?us-ascii?Q?kLjS9oWoqraJiKlQQIwDtF+a1Ec1NpNmY562etW3BUpTBlttqfBz3HzTjofU?=
 =?us-ascii?Q?5UUpgyCy682CRX0KBpa/cteOjjrbzdROlhzAWYekS28SMdJ+dPlszxQU7hMV?=
 =?us-ascii?Q?nET99lr3ko8x6CZ4rZho8wz2JF9hZ+h6yImd/pD4zfrjUqdKnM3ytva4gBTm?=
 =?us-ascii?Q?n5kuFTzaIfqu58FZSzkby7fryrVAyj7QrhFc5PxXpagM3zc8ssvrRzawSWme?=
 =?us-ascii?Q?io1HE+p8z5KDIkjsUlhdSmHPNAb9P3Gqzft8Q8QeX7anNPefsNQbYRVy37F/?=
 =?us-ascii?Q?NjcwKJal0ts=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5px3s7Q4BIXS1gh9ChAkvMhI4qEVzsrUd0gTCYHjKOijJo1qqQObwFmLXKcX?=
 =?us-ascii?Q?eCeisoKcEYDSzEFXF5jVu9hqKwlyhc2YhtuodNAdsNxQu0ZjzH1e1n25wS3u?=
 =?us-ascii?Q?tyKHicfEprKFpCFYzsVF1Zhm8qmljYZDuNofB2G0Abn6UJTgdqaeEmQs49zl?=
 =?us-ascii?Q?sglkFODBbz7WGjWDoSuxe+POdfDCwqUPSsQZXYWPOROrKvFx5ic5L61YlEAe?=
 =?us-ascii?Q?2K7B70q/mbABhDuI/5fg2GKgHQu3dx0cEt0Qxhoe5tiOew/eVl7/65FfFs9c?=
 =?us-ascii?Q?eMa6YYVZSXjkcm10I0VMEXszV4BtxA+Z9H5pU3w8+7TePZUJK0fg3mQmb8rG?=
 =?us-ascii?Q?J6A4r+pk5A19wMhC9LDJOqnhnmL30r+udKYA4k2oT1qnEmW/TesAgqHcJRW/?=
 =?us-ascii?Q?lIe0le9jgnu+7e1V4zMNYMpRb1EpfzZVeFo4dxVDJIW9UWwuRX8CXWdtRY7h?=
 =?us-ascii?Q?F63FqRZtLKGDKY729XuAtsPT20QDkLiBscNp0tUc++dRYU+thOq6fIEOkSZ9?=
 =?us-ascii?Q?PoZCcJF5Me5UdL3mRx8VhD6T6/MKpWJAIacmGc3DBktIB39cjMvRZJ58UHTX?=
 =?us-ascii?Q?pumNOVVyM7n/eetYGZH5GrU56yQNGfAMWCJ4tfuGLMy3u3lWmDIxSghKZqcc?=
 =?us-ascii?Q?DTVLGSPP2VPYHDCSmcKiH1TSvepdBlUVLudlrsGu18OU4iGE43toeddf0pLk?=
 =?us-ascii?Q?cbwvkwqHCaPW1pP34YtgkWkpltvTFeuR4iBGIIN2W7lkkR5GSDyHqkV7uZPz?=
 =?us-ascii?Q?jLpD9DpKsNEnP7k6vGIQ8O7QmduHcoE5QuO/Kkbl+cn3sIVv02PJAFqiAPp/?=
 =?us-ascii?Q?Oq708b5DmpRsqG5nSWHe/DPBqV4RR92C9rCv3pg43SAg9RMz/ZQwJkETft5T?=
 =?us-ascii?Q?eRJ+wcXUzypAE6raFJTzuPNmJuI0hebhEKf4iWY4YGKJpj0rhDA6Qz17Wgcl?=
 =?us-ascii?Q?yxm0haPGXTSzLwfKiCoYYOACi2wRpEzhosb6jbExrdITLFdQ+4IRU+aKChD6?=
 =?us-ascii?Q?oye6q7CyJZW9Kwb+fweJxm1OyQL5gTPoHmWqwMnc8pYrgIa7HFUhf5zpIq1T?=
 =?us-ascii?Q?6fs85o6MCI319GKmPL+hpJBYaSp/7vV7bYQVrbfXqNHC2ZoStlRwJNGOwf4j?=
 =?us-ascii?Q?oCRlhFEWDd5c3L2DVH4sY7ShLQCCJoiOSVes235f+MtIVpxjbPRopkB6ionc?=
 =?us-ascii?Q?CucfKE0WhxzJ2b1JgLth9tfw4zraXxxwf7ua+02s1QtO8a8cZudWGx1HLZ1Q?=
 =?us-ascii?Q?EVlSSYFIW9Det+onCq5Hddn2rsBA0pq1e9auKi5x/Svn94L3IHzZDI5DYysK?=
 =?us-ascii?Q?XReGeSJBuKy2+zniCB1r6Wnc/bry8KBGjB1/eBRyXIO9IPQW0gNZtjo9d/h2?=
 =?us-ascii?Q?Ef3XjDzQb/DqV0qts4+QWTN8OIfSpbZJNy7Rt1HncLIJnwWUsLl5A33e3aaL?=
 =?us-ascii?Q?VavVEKsEKBK7qmeoYKRqDTfzdX9s+p4HZBsryhjrJez1YFyOvWKj6v+fbQjI?=
 =?us-ascii?Q?kIdzqoWdlf/B7z89urd/B/gWuF5fN9K0Q9s5K9+E0q3xzXiUIIeXyfXUFNdL?=
 =?us-ascii?Q?WbD68dJk1OONzZTU0yiqXntnTOAyWuEUn9J+yGMx?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f8200087-f237-4073-c9c4-08ddb3d72084
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2025 10:57:50.2738
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RO4JEYB3AhFfMgoJSaUdwB02nG/8DOlN9aOqS0BTTc2Br3QzrYxSocuUA3BzegBSBu/SgqEnBB29LwliiRwcjQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9012
X-OriginatorOrg: intel.com

>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index 5453478d1ca3..cc5f81afd8af 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -685,21 +685,21 @@ static bool msr_write_intercepted(struct kvm_vcpu *vcpu, u32 msr)
>>  	return svm_test_msr_bitmap_write(msrpm, msr);
>>  }
>>  
>> -void svm_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
>> +void svm_set_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type, bool enable)
>
>I don't love "enable", because without the context of the wrapper to clarify the
>polarity, it might not be super obvious that "enable" means "enable interception".
>
>I'm leaning towards "set", which is also flawed, mainly because it conflicts with
>the "set" in the function name.  But IMO, that's more of a problem with the function
>name.
>
>Anyone have a strong opinion one way or the other?
>
>> -void svm_enable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
>> +void svm_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
>
>The wrappers can be "static inline" in the header.
>
>If no one objects to s/enable/set (or has an alternative name), I'll apply this:

Looks good to me.

