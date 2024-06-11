Return-Path: <kvm+bounces-19308-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7533E903939
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 12:49:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0CC3A2848B4
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2024 10:49:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9B7917966E;
	Tue, 11 Jun 2024 10:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IPXFyvIj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FF0944393;
	Tue, 11 Jun 2024 10:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718102944; cv=fail; b=EAoP+lUWWLNhjnmHJB3aR8Ig/RWxAItRoE9i/XUr/J2+EOOJzQUv0emEVmqocLOW/W5QMEtOuFf3Wgq1xCRC4MXaFt0FY85+c9rsTG0aWzQN5SLkBSjm3f3zhpk9ZKIDnoK00v7U1aR7gTHwU87ccMEoxhTE8XWSJ8AhqhJ4aXo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718102944; c=relaxed/simple;
	bh=7PhmJLfj8XHlyg6ONTOeHTLrrYi5Ldl0OLDAidb8TS8=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=ZM9wmSMVdCWLSFM0BBZc2kyW1Gy6utwiI38psOtk1nqVi5rpxuP9mchjBmu94NdDez1j2WX8Ecp8kbq3QorBnzL/Ke2CrsH++nbHAplGGatVEtqQJdgubpsDsj1S7Z9nCBjWbSZfb0a1qbmpdH/acbZUtqijVhqfVdwM9LikpRk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IPXFyvIj; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718102943; x=1749638943;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=7PhmJLfj8XHlyg6ONTOeHTLrrYi5Ldl0OLDAidb8TS8=;
  b=IPXFyvIjBUZ1+yHW5qzuZjbVXbaQweauLoRMwx32lZOnd2X7Z2d3M0Hr
   eJgeVNRKOBcxfsjFKud9/hFD4fxxJAV4flMjAKzMOmdtZWidTH/aKrsyr
   ghpT0OV47VciUIVfmWBRfXzxmh1s+gNOa7W1/Nh8zqE1a/pEfeKC9v/wR
   TdHsh74QYBvmYo3eAU1jSYcPtnwf9zl8G+O+5IU3fPHCzl0YArE2mr+wk
   Z0Am7DFLzcIOfFwhZWSBPcxrzbPI1vVdbnJVwCRfJydEBOUOfUXmoSgsc
   w8u+Om8kckhuyT/3NLuebsmBckH8wNwpaputbaz12gqAEhkrLIi3h3e9D
   g==;
X-CSE-ConnectionGUID: cY5GDTyJTUCcYsc9Kx/W2g==
X-CSE-MsgGUID: IU1nygX9RJC5mtg3r7QrbA==
X-IronPort-AV: E=McAfee;i="6600,9927,11099"; a="37325991"
X-IronPort-AV: E=Sophos;i="6.08,229,1712646000"; 
   d="scan'208";a="37325991"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2024 03:49:02 -0700
X-CSE-ConnectionGUID: FeARANRfQRuykQQmelhvZg==
X-CSE-MsgGUID: K+ac2IbpTeyo7OIandq4Jw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,229,1712646000"; 
   d="scan'208";a="39338190"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Jun 2024 03:49:03 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 11 Jun 2024 03:49:02 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 11 Jun 2024 03:49:01 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 11 Jun 2024 03:49:01 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.49) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 11 Jun 2024 03:49:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TopWEjNBty/D2gWPg0gQHUcYCnPbPoXgyH6cAy7ce59Rs1ak1vH8U22uyRD+SVw2QrD8OhOBcfnSKAwCbZjQYWPbX3Zpl09eS1ZKUt32DM97psbB37ChI/Ha/Z4wU4ao/dQPLKopqRbKQbdYcs8pWy9MTrWFWbwJt6C20MsBSgrl51vxbW3dEkX3yxJSAKthSF8+EdyQ9r3COKTPCUv8+tUkS2R3mFgiJ+UL6JWnPqPtGj+fbbp1zE9+kyE4gdE6lWPhxlRcQvjvyCvUL+4o8MXhOLhB0Po4EfwwA3FmJy4+jnroOtQ5Ue62Z7THCyRk43DfZ3qq0nSQoCVlb7k+Ww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s8jRYijHITn5qNmSI76n3GZdTpicNiSA1YBQjtji8q0=;
 b=N8/aROTvz8DbVgmZoxvzh8dLjncql5+fLGzl3GsL7GK31a51AaQ/kuqzl2ACJN7A6v5TjDvQC5/12vG9n4eeaa7FRCv7Cg9Yjyc4uG0mUectpJlLcUdwZPMXuW5JybG3r5VJUyDye7l5YAfOI5Xxabjl4D8qxbyl860bYysdRPLrF+y5N687BI6k8FkjDXBB4LySTm68wHEWG6WZqA/RVswU552O2yFNeJ1uPSfWU73H7JN7imdNZ8bgQIk4ELqJ5bIGrWuMaEY1O3EXNnZSSWzVBabmu3d4jMMPOHVxURxIJlNF+QfVgfU93Vndauor/cTMMkUtVDpJ78fggca2pA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH8PR11MB8014.namprd11.prod.outlook.com (2603:10b6:510:23a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Tue, 11 Jun
 2024 10:48:58 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.7633.036; Tue, 11 Jun 2024
 10:48:58 +0000
Date: Tue, 11 Jun 2024 18:48:48 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<daniel.sneddon@linux.intel.com>, <pawan.kumar.gupta@linux.intel.com>, "Zhang
 Chen" <chen.zhang@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC PATCH v3 09/10] KVM: VMX: Advertise
 MITI_CTRL_BHB_CLEAR_SEQ_S_SUPPORT
Message-ID: <ZmgrkMLuComwPl1X@chao-email>
References: <20240410143446.797262-1-chao.gao@intel.com>
 <20240410143446.797262-10-chao.gao@intel.com>
 <ZmepkZfLIvj_st5W@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZmepkZfLIvj_st5W@google.com>
X-ClientProxiedBy: SI2PR02CA0052.apcprd02.prod.outlook.com
 (2603:1096:4:196::18) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH8PR11MB8014:EE_
X-MS-Office365-Filtering-Correlation-Id: 390e0efa-63e8-4d78-102a-08dc8a0418f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|7416005|366007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?Qamw/f1bkExtppcH7ktS2LVoqDrRM/K3XUGVmv+RqwYs2wwdBSrGp2HNxn6x?=
 =?us-ascii?Q?hBzp38K/AVO9EI+NI+rt/iLFVsXa4MDIlw6PLuyKZFQJDcX22fAn3R7CNyTJ?=
 =?us-ascii?Q?6e2ciQKjcldk9D4WCOVAuxnKIHmNqHXVb6T0oferxUAPNZkQ2DYumfKld+Ua?=
 =?us-ascii?Q?NXJR5C79/x3gyVZh6sTT9ycEh55Myyu5Capeyos0S6tqm3kSbho5X9U5Bv5V?=
 =?us-ascii?Q?F7nj3BheBDCmqUP+O0uCZkz/+4wnIn18EzGvz0KrPWf4edPihlaIBgWtMPOq?=
 =?us-ascii?Q?GAkG2VFTcwszhhWrBavbV9RxKYC0+TI5eRaQPbnTnqMan6XC22wboi8yD9CP?=
 =?us-ascii?Q?8zaciWyfR/EHJrxbxGfs6Sk3cxbx5UbHSfnFqM1Vl0qwrFABEFTJLC3LdpKN?=
 =?us-ascii?Q?XlyYDGQSgkzdhvIYamKehLEgjn06Xs2WV/xN1Bm2sEXTXHxMuOllSpgxyIqd?=
 =?us-ascii?Q?ve+fOnd0HoV6Q/dpwvRRvrXtWaiLTEXfAK0NVsyxSxGUeVEE/6+YkH2liFfm?=
 =?us-ascii?Q?N9qOvIcjF1Kr/bYSIAhCRZPdtTK4F+JgZ8QGO+QffK13O2YIpaETyQxHl6hB?=
 =?us-ascii?Q?GF+8NTWBdVeZoBIXH2aC6RiDoeWAmX3b7W8HyF/c72fFysTjXeB5vQrbYK80?=
 =?us-ascii?Q?lGIsK83vlM7hRCoHKFhAQFQ8zk40KlmkVQ97QPDOpSCR7i/MiMjXP4Fvy0Yh?=
 =?us-ascii?Q?SLVsn0mALBDmIewzknFEJBQVClYtMup5iM+V8Dl9Bv1NkV+78L7eQBjM1AaA?=
 =?us-ascii?Q?pTp2pkIoogQ8M9HhWnSDuehBJXPDVs7s4sG3FsaLWlkuAYHB7FDWFwvGP+nC?=
 =?us-ascii?Q?1kPjvVpg7N4CzX1UlfJOoDYvpOIdDvsLHdTQ4v0bi7H84ZNnPFuXbePRKUJi?=
 =?us-ascii?Q?zNpu+FwTeWd8rfp2VN4IthEBOELrG3wZnm/gviLNMzHgxYyvCRwlaXBkdLxQ?=
 =?us-ascii?Q?xVTyK/Zi1jOM8I5TW98h9ueZrpYbj65V7fhwyto3AJOD3mzmoHOtJ4HjEuDp?=
 =?us-ascii?Q?lQBZPlG66+QfDuJRWjANvyBBE0WQZD5P80MZJPN0TKPtEWhJLB0LJAlB/Vr7?=
 =?us-ascii?Q?FQvuEgY37uv4cb/p5NZO+P+fNp2Nc8YznOC1SJD6lFmhaBZQeRsdCX9ikxp3?=
 =?us-ascii?Q?3npyFnqMnV418uspkt1KBtDo/0gCnIdmz/TcttOo8DQh3ty/N2DczWu8w4dS?=
 =?us-ascii?Q?mMZzDDemOrWVc4k/UFZIwKy+0u37qMBCNIRpTUs4WrX5nb9Pr6FefCoAEBib?=
 =?us-ascii?Q?RaGN8lLTMoX0T3oNE5X49ZTx6a20i7qlbnW6eHHxRWr8g0wmG88y26EitZF+?=
 =?us-ascii?Q?PMfDu+RepKwnPoqr0TnAPwj/?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(7416005)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?x0XMXqEPqbEiDx78DbbW0qCYhoos1/Rn3YsEO9WUVF0AVlfUpUsKAU/yi+xH?=
 =?us-ascii?Q?VmKqJbaGEJDrkFswbDvK/wzQxvmgzlNS4dOKxHqDZoPn9EHjl2gZJ727RQfX?=
 =?us-ascii?Q?pZO1RzKMFLUgqKdk1XfBBVE0ptE2dSwJvN/vZ0Omjt9ZucyAlLzN8OeSORDs?=
 =?us-ascii?Q?KBeJST6zFItlX6vLr8KW3hIdZovTMe8RhPbAou/eZPAYDfb0NiB443pujoXA?=
 =?us-ascii?Q?w6LY86u/1L/9sqa6VP101axpC/rfGbc5rNSBULwPK1GkKIV/QPRIKIrhy8Q/?=
 =?us-ascii?Q?Jqok8pBZ+FYy5o5+Kz17aFhC6tbMry/wOMm57eDfIbFMskUHYt2q3dcdB0BF?=
 =?us-ascii?Q?DKKJledEqMV2+xKXQ/si/JZoQSJfWCzsyJoopEPIKEiIFC71Liixz4GjyrE3?=
 =?us-ascii?Q?eSsQJaXkjWVxDOyvwcUvBR1CrQou6nJ2/ekIlWMS9u5S0m+TT+s8w+ELuE10?=
 =?us-ascii?Q?2/ZXJk0d0s6eAnj6RlHKyEpmSIRQVjL3RakFVk8RfRKupIqeLxafrpHiY2aM?=
 =?us-ascii?Q?Vg8Hz4dwlhnMCB0afFF08Ern4raJxD0BqSUYXvjShshXM6mfkl4HxE60WgVU?=
 =?us-ascii?Q?sEK8PrpT+wihLpLPpBCxXhiBC0Xa1bC/0lE665+H0qYDUBDReMZXKo5cMi9V?=
 =?us-ascii?Q?qaj8kBemBv2XTd/sHqqY45gH/DzUjo+svVbXtPeFGlJrrDetBIxDsbhE6XOs?=
 =?us-ascii?Q?TgMzskN1Flgq+n259134FeV+vaTxE1cGWCjf2W1vQXvo4RazTWz2phkLlzkd?=
 =?us-ascii?Q?+JfQDIjCZ2O1I4KxSsvlGaq32W3Pe3yxbdsgFwlkclJq1tf6j7VyiH1ZKNlU?=
 =?us-ascii?Q?ie0x8R87tWtz4ol+lq7Y874yBXSgJmly2QdDblruRUkAUcW8dFydofJLqHZa?=
 =?us-ascii?Q?DGlBOPsv+eZ7wJ8rADql5GUTT6qDLN3XYBw7jeGXE02s+TLbyIzSNvVeySlB?=
 =?us-ascii?Q?v8thhYPaB5L5rYaMlkpvM8JO+fD1B4M6aUrQhUw5ccnWVCj7aRqmPxx5PkT3?=
 =?us-ascii?Q?FjxqKEAY7jP8kQAOFUSgLuGHfErcmnXwF57Rc57lFgctaoJhCNawv26pj35+?=
 =?us-ascii?Q?Ijo7wHyDEAtnQNQ5ejUcGiW5mx7KfgP4xU+B/mXoMr6ZxD20qY2Bw3PrjemZ?=
 =?us-ascii?Q?1xVIkWlbxcIG60Gw90XyP9NUsxNJ3R6fo0kh3Gn8kFVmIWVsV/mw3jIMKG3E?=
 =?us-ascii?Q?mdMJbrwG6Pk0JTi4m2deG6xEf06rOAa8JSZbcI+4V++jEi8qw6SI6DPpn5+B?=
 =?us-ascii?Q?WRsrePQIxJ/u3fEV72F3quyATU/IQSldlcfl0BN+EmSKqAUYwjRDhp/x0s/o?=
 =?us-ascii?Q?Lzodgso5Xo5sjK6aYavN5pbJwriOFl5pNlo2al+zfWFMW1Yo9w1kUGW1auT/?=
 =?us-ascii?Q?0zGtx1+Z/zu2bHfWit2WreVAv0WVL313VDlBPnhmATttlm0x8T/BjUBjyH6d?=
 =?us-ascii?Q?7OkUS7/7sM0DmA3oVmLqDA6OZ+jt+tmosngDxy2piF6bN1AKOms8qGPBZAWP?=
 =?us-ascii?Q?cwIwa0SwumqOx8LKTX1DJi5Iofd7hE7xBzYboV3NnFR4Yk45Atq8njRb1SEf?=
 =?us-ascii?Q?nymiVGJUyWuboPrjMiQs9f/a1wskGZHhuRWKRexs?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 390e0efa-63e8-4d78-102a-08dc8a0418f4
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2024 10:48:58.6390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l3464oinAUriFL3XI2f4IqIlLDFJxynm6YUy0tKKQNLqLssXb/r67blwT40ur2WBQaknhf2fi6DJYrTXzbsrGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8014
X-OriginatorOrg: intel.com

>> +		if (data & MITI_CTRL_BHB_CLEAR_SEQ_S_USED &&
>> +		    kvm_cpu_cap_has(X86_FEATURE_BHI_CTRL) &&
>> +		    !(host_arch_capabilities & ARCH_CAP_BHI_NO))
>> +			spec_ctrl_mask |= SPEC_CTRL_BHI_DIS_S;
>> +
>> +		/*
>> +		 * Intercept IA32_SPEC_CTRL to disallow guest from changing
>> +		 * certain bits if "virtualize IA32_SPEC_CTRL" isn't supported
>> +		 * e.g., in nested case.
>> +		 */
>> +		if (spec_ctrl_mask && !cpu_has_spec_ctrl_shadow())
>> +			vmx_enable_intercept_for_msr(vcpu, MSR_IA32_SPEC_CTRL, MSR_TYPE_RW);
>> +
>> +		/*
>> +		 * KVM_CAP_FORCE_SPEC_CTRL takes precedence over
>> +		 * MSR_VIRTUAL_MITIGATION_CTRL.
>> +		 */
>> +		spec_ctrl_mask &= ~vmx->vcpu.kvm->arch.force_spec_ctrl_mask;
>> +
>> +		vmx->force_spec_ctrl_mask = vmx->vcpu.kvm->arch.force_spec_ctrl_mask |
>> +					    spec_ctrl_mask;
>> +		vmx->force_spec_ctrl_value = vmx->vcpu.kvm->arch.force_spec_ctrl_value |
>> +					    spec_ctrl_mask;
>> +		vmx_set_spec_ctrl(&vmx->vcpu, vmx->spec_ctrl_shadow);
>> +
>>  		vmx->msr_virtual_mitigation_ctrl = data;
>>  		break;
>
>I continue find all of this unpalatable.  The guest tells KVM what software
>mitigations the guest is using, and then KVM is supposed to translate that into
>some hardware functionality?  And merge that with userspace's own overrides?

Yes. It is ugly. I will drop all Intel-defined stuff from KVM. Actually, I
wanted to punt to userspace ...

>
>Blech.
>
>With KVM_CAP_FORCE_SPEC_CTRL, I don't see any reason for KVM to support the
>Intel-defined virtual MSRs.  If the userspace VMM wants to play nice with the
>Intel-defined stuff, then userspace can advertise the MSRs and use an MSR filter
>to intercept and "emulate" the MSRs.  They should be set-and-forget MSRs, so
>there's no need for KVM to handle them for performance reasons.

... I had this idea of implementing policy-related stuff in userspace, and I wrote
in the cover-letter:

	"""
	1. the KVM<->userspace ABI defined in patch 1

	I am wondering if we can allow the userspace to configure the mask
	and the shadow value during guest's lifetime and do it on a vCPU basis.
	this way, in conjunction with "virtual MSRs" or any other interfaces,
	the usespace can adjust hardware mitigations applied to the guest during
	guest's lifetime e.g., for the best performance.
	"""

As said, this requires some tweaks to KVM_CAP_FORCE_SPEC_CTRL, such as making
the mask and shadow values adjustable and applicable on a per-vCPU basis. The
tweaks are not necessarily for Intel-defined virtual MSRs; if there were other
preferable interfaces, they could also benefit from these changes.

Any objections to these tweaks to KVM_CAP_FORCE_SPEC_CTRL?

>
>That way KVM doesn't need to deal with the the virtual MSRs, userspace can make
>an informed decision when deciding how to set KVM_CAP_FORCE_SPEC_CTRL, and as a
>bonus, rollouts for new mitigation thingies should be faster as updating userspace
>is typically easier than updating the kernel/KVM.

Good point!

