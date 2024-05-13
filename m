Return-Path: <kvm+bounces-17302-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C586F8C3C37
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 09:44:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 79B802818ED
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 07:44:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73064146A9E;
	Mon, 13 May 2024 07:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dHk2Znuo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E3F33985;
	Mon, 13 May 2024 07:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715586276; cv=fail; b=cCA2nwvy7RUxq8w2iTglnsHYDlK1TSU/X+T4n25jyth81yGKuSWHBaWTb6t4JOU5t/s2yvNs8ajEnnhRO9uv9ADVRGvy46UVQp+bSYv45gyz/9ERiqnpYmOz+TWcNiEdz1XKWvSE1e+8KmvqPZTUvWOIj3nNkCtFk+Jy7lE3xhY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715586276; c=relaxed/simple;
	bh=rsVOetNia7l1rrmQ6kXCFD25jNB02CX0MgWaVkVJ+cQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=reizWBo+z19OFj1X9JmAhTbIQw6E2KpRuUKh0PnE0Gys8h0SsdPrSyJTlh5CCR+MdwtYggy9zpgXc8cMQRVtei3mhfs0xu7MMVOBRiBsIUAjZsauGQemMXATD0rTIRCMfIzQFGuk1ecF7O5ttfqjYagBdu0cMILHTUDFi20Xj2k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dHk2Znuo; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715586275; x=1747122275;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=rsVOetNia7l1rrmQ6kXCFD25jNB02CX0MgWaVkVJ+cQ=;
  b=dHk2ZnuoY5e0AuT6Ivs2Mnrc+aIdnivKHt01TBCaxCBNtIOu6OSoizQ9
   5Z4fPDyUFN/ul9xK5X5XcOFHWMvOyrfGA+fMupW6+dfmPJuYn+ccM9rpR
   cqkreynbfcivCpPGqLEXj7r9SA2rigAVjK2ndh8fl+bTIav9CXg2AjDBd
   FnDjLGL187pL+UF0q6bR7Ev6d7TDr4kJkikZYY1pzYQTlULR4Ct/V6Kz4
   1Vzrln83ykgAPrFUewC/f0PiFyqPtIeNTop0OSJSCD9lRL9byGbFdH3Bo
   7GHGPRjRnmXmCmfK8vTgJqizr4cWn7h+0DhJbwSJXOMofybVWCmINxQlD
   w==;
X-CSE-ConnectionGUID: sFOOAub4S4SyeLFIZmO4zg==
X-CSE-MsgGUID: /GzsiVfVTEeFStz+86BK6Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11071"; a="14453334"
X-IronPort-AV: E=Sophos;i="6.08,157,1712646000"; 
   d="scan'208";a="14453334"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2024 00:44:34 -0700
X-CSE-ConnectionGUID: Wh1LYrn5S/+h1lrGXiv/qw==
X-CSE-MsgGUID: Bf43wcQDSgi4l7sRn8DkYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,157,1712646000"; 
   d="scan'208";a="30098526"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 May 2024 00:44:33 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 13 May 2024 00:44:32 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 13 May 2024 00:44:32 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 13 May 2024 00:44:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wz3AhFeMzmHbv8f+jNRk71DShk6dRcuoZJzqJisfeOtsAZKo+mJUyzbnazh02TZKxSVRvegEAsdughXTKVllwqhQHB3wOzStTsb3WuQ5cQdTR6hVaOsYjRYHuf9/qRr++0oVK/hw4m5sthW26cwJayjZLlvTZf2pcWnil7vGSG70WFsI4A3WhuBt/oyuGTWj7wHUeuny//t1TQ5V8Br6X7IRYVw3isBrReYybyUruunH0GcYBiXSDEeZ65ZxsGk33sIo7VjB2oBMSnOeV/nndVLATq7qI6yqb5rMBCy4CbzySsLofZDVwyeJN+dkS3iIXeXOsPq8mAlIKO8gsMsKMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5mF1kQp8WRToU3rM9W1UgFj5UZZHXO/LM4k5PSMuKl4=;
 b=V51IDnUnRWUj7M8OqZyR3eQ3Dd8EbXcGM2fsRoRlfBW3y9NDIe5iWCi7WIC7mKOzOvhcbS4NP7Qy1wbzYgELs/iHEe7PntGrzC90oHXtBdYN4JNhHkBXp23QIH/ou0utITtksWIulofkAT99x5T/CPbri4c01pWIe2cCcAe6QxnrGEOJnwpwx/D/xcg7HL0Y4nrNSgCl1SS+vvDAFgx4xv1+CooG57VYagIfASob9GjimM9Kxs0AkTuD7HWcuUdy9A34SVgcefauwnRP12y1NBx0acf390KwaksXzBAbsLvxGH9HCsspSqerGmXhIqxjSIFU/DJiA22p7wS0t+Qzww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA0PR11MB7911.namprd11.prod.outlook.com (2603:10b6:208:40e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Mon, 13 May
 2024 07:44:30 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.7544.052; Mon, 13 May 2024
 07:44:30 +0000
Date: Mon, 13 May 2024 15:43:45 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<alex.williamson@redhat.com>, <kevin.tian@intel.com>,
	<iommu@lists.linux.dev>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<dave.hansen@linux.intel.com>, <luto@kernel.org>, <peterz@infradead.org>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <bp@alien8.de>, <hpa@zytor.com>,
	<corbet@lwn.net>, <joro@8bytes.org>, <will@kernel.org>,
	<robin.murphy@arm.com>, <baolu.lu@linux.intel.com>, <yi.l.liu@intel.com>
Subject: Re: [PATCH 5/5] iommufd: Flush CPU caches on DMA pages in
 non-coherent domains
Message-ID: <ZkHEsfaGAXuOFMkq@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240507061802.20184-1-yan.y.zhao@intel.com>
 <20240507062212.20535-1-yan.y.zhao@intel.com>
 <20240509141332.GP4650@nvidia.com>
 <Zj3UuHQe4XgdDmDs@yzhao56-desk.sh.intel.com>
 <20240510132928.GS4650@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240510132928.GS4650@nvidia.com>
X-ClientProxiedBy: TYCP286CA0246.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:456::12) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA0PR11MB7911:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e29fb37-2937-4860-499d-08dc732085d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|7416005|376005;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?5lWagP4KP4lWrvg8HdDo/9jQOO99dqh1muWbyaxfX+U82yHDeFQwWUUQFQXy?=
 =?us-ascii?Q?xGPcoOU5AcrjNXkUj/rORqlb+1lQUwtH34gJEgfTGV7FS+f1RuAhMEwNLhdx?=
 =?us-ascii?Q?iBiHpO59G1PxSWuoNnupQokLV3Rp1UGTK2vXrWZr7KIX+yRPn4vcEAoT/riA?=
 =?us-ascii?Q?cqFz7G4doQBD1VzkulvCwY5DoORZvQHIxdrqhMw/RVAWnlszlOu++A5lFzND?=
 =?us-ascii?Q?6xy1wQ7us9ryJwN5FID+D21PAWqliTZBKJqJa0iZrvzD9IjADFDfh8uaoR/K?=
 =?us-ascii?Q?7enmAug1lGzPyN5n9vB25zqMcuZU3dYlPwYPxuQClrK3ErlbeANeLiX4/TMJ?=
 =?us-ascii?Q?S5bz6j3MsiU+1DzSa2silwl5ZOvjp3JjlRrGGSJxh/BOKZsOJl3wtv4XFu8c?=
 =?us-ascii?Q?aKGu5OjZgfnrlFSZ/7TaBEQssKzDjr9zdwoy4Uq6SAK+k+myC4rNuEhYOu+U?=
 =?us-ascii?Q?8BHoRtd44wlZ8oxaQjvLSRZSq126iuzC707dOujFR7Vr9T6UYwuHRaAcQbYC?=
 =?us-ascii?Q?vDrKAb/SRfhRc2qHU799fXy5F5n2vvEYxJsxb+cOQ2ql64guX6AuQP1indaK?=
 =?us-ascii?Q?4mwxJmVUHhuBLEDEts6lhSOAyrkMWQaWFVASva7AqUBBP+ftXiTPsLcgVUH/?=
 =?us-ascii?Q?L+nUNNtGGeu6kGu6J9QeFkY2Aecu5SSUIyVRlfIJ+nDXs9tAmhPBS+WPR9Fh?=
 =?us-ascii?Q?1lq7ajoMfUTIByNgBZpFrOnKVbw7Gawo3mNPFIWkYd64w+Tsz7O/opH523pM?=
 =?us-ascii?Q?lUwK9jM2wZO7Zcav4TBysn2gzVDsCiMfaOCBsRcBthOA35qHZ8Hi+mwePneV?=
 =?us-ascii?Q?hgtFU+0JunVFhaBP/Vd/4x2aVoDlv5HZUavaGHgMNjLuNUq5tJet3r8NYTee?=
 =?us-ascii?Q?ofbX9hFRE2QvA9KbrickasqqwSsIBOHshpBoUXmi+ScqSczqiD10v0svd/n3?=
 =?us-ascii?Q?KMVjvwia43plKSK9OkyENQx4XCfppWZN/H6Fl4n6gOiXgG35ozMel3xVPAlu?=
 =?us-ascii?Q?Cs5dzka/rdvQLAGg9uGOsW1s04t2DBYVAkurt3wRXLegx9w+bDfwZul1jw7f?=
 =?us-ascii?Q?kTDigEP+RJUpTbmNX1zApPsc6OYSknQ78E2GuOZvd9cdqasgoanEGcZoh88q?=
 =?us-ascii?Q?ThaSpMmLGA/wi2ftRqIdaDwlF6tq/m00wSrvs0G42evngawdBBmlnU5+EIz1?=
 =?us-ascii?Q?eQW+GK03OnSkPj45jz1S8ShMUrt1+ev8YkzQFS4NpS1/0e8rS0m4I+HI1mqN?=
 =?us-ascii?Q?b/60GosX+HUcIfLTB5mA8ya14TjBO0v1pGlTaFxppA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(7416005)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D1U/JqkziZ0BQDN7ls/LDVMk7db/+GoatxdZgstWAJcFfJZlcRNAXiXtQ3og?=
 =?us-ascii?Q?t+alJVyQyWzOOD7GRLZ1fRezyI7OnTCO2MnJ4dCQlrmGRGdKDqyruq7uW18Q?=
 =?us-ascii?Q?TfkXWcZwVIsrGhp+5TFKn9+PFpPkeM6qXdzaB2h8nndvECLc7P8H2UY134c+?=
 =?us-ascii?Q?j3NXbCP6yaxPg/IG99l/yikxmkGAjxmYk+1husYJgyhOceejERd//ZEvEUfM?=
 =?us-ascii?Q?OsFatoCnzIXm/63SSxhObWBUYXaruv56wYoPWw+KvuuLLRppTND8Bfnsc1aa?=
 =?us-ascii?Q?M0i3UrR0qsQ428KRcAaR91obfYA5kmciEnd6xiz4C+BR6zsun1oi4M4+L2Nd?=
 =?us-ascii?Q?IEy6ytZSmookTQuguJ8R3RW+rJ/mhrdqRtwAsedwdj3yVsGojYXS/vSknZqs?=
 =?us-ascii?Q?niL8EmNre7W9TYiNwVCRyhlnWHk0ztq3xc/xBHCm+DfwAqDwKCrJOm8ONt6g?=
 =?us-ascii?Q?QOfLKdWZK/kCRJ6V/hxSWt1aPW1Mocp7ENky/xQq/IvAQ3q/Dl5TjZZXCral?=
 =?us-ascii?Q?f+EEcIlDfGsfDaJNtTRZA854Ebk3OIT9wOZLuFRQVyt9/pwwSTUiKY4y3tUW?=
 =?us-ascii?Q?cJxQ7WoqAIdJhjbeQYv7JhxzYkAJ8kXcV9NQywadBMjXuzrL2F1jD1suFPI7?=
 =?us-ascii?Q?nNBp2pDlixnCWOhD/Uuuff2r+1LSIDlzkPTBhR/i5aFlvgXM8bI/ib0+rfVm?=
 =?us-ascii?Q?T5f29jC916HP4mxz8jfCgA4KKO1U2yyCJu0FP50vZbeO30dHIJNXWGzuvw63?=
 =?us-ascii?Q?CcoBQJ44bAcntmGzm051E/7nUWMQcUj5tyETLvx0U7BichpjxZ6kz+O8vqG8?=
 =?us-ascii?Q?4oi3Fj3p+byYV+s1noDc5wUDYbCKTMvBrJ/kh0I6XgEp1NGSixrdeaTLBFGR?=
 =?us-ascii?Q?bFIn6WYPagkXlaF3JwvQ8gvta7kB/qAgB6gyXCW4ce0nOq6FVUXGGH8zAMWp?=
 =?us-ascii?Q?mM8E+ccwaYTcuCdViNoOqTNsFFYW5c7HwO+6GZlpL9ZAKlMYXw5NYqO6vmOh?=
 =?us-ascii?Q?FN6NeXfg5u0N9N5lTmLM4+G5Ts53wXGWw2bDP4SwXBudkQrq+/7ILOM54YH4?=
 =?us-ascii?Q?9b5OnMdsGymaqJQW1FXYO4Ez5MhcHSAP6hDsgx6kVtS+Vk0gZ4K+NqDpbacD?=
 =?us-ascii?Q?bnZGkihk1akEErFOuYKOCoQFMulSSeIdFXS1Mz00nwXKs8IggzvWwOGkYuWB?=
 =?us-ascii?Q?DYd/7jcddKrMzCrEtiiVBGX0G/edik8mnEXx9xlLWO5DQKs215SXZlYDqbgs?=
 =?us-ascii?Q?UhdMn6D9OOrsDIHjrcXf5XJYSS6tC5YtWPXnuIChfzrM0412MadlHABJAeBe?=
 =?us-ascii?Q?w0JFl/Od407yXjr68JcJFGpzZ/RR83QpBzieVv1yZWPZuBuZHDT+WAPpBDb/?=
 =?us-ascii?Q?azEK4aYcxV3qsUi0AI2zetF3lyq9ncQkkyIdbpEv+Rqo31Lbh1S+ccM756OI?=
 =?us-ascii?Q?eLvCTkDRUKoyKDSHjfvEXk3KYsRrTqAQm57/ZyBwKEZI0Z7248W3zZ1ErZfm?=
 =?us-ascii?Q?1lMnm9pDajiLxmMOxcymWiSjjQxasWWv9rgHTVcEFOPoEzzzBPefWFhy7uHA?=
 =?us-ascii?Q?6ZObc3vLqFyIhsHs6qOPRKeJWKNzQyIWHeVf6TWZ?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e29fb37-2937-4860-499d-08dc732085d7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2024 07:44:30.3541
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V6Pmk0tQ07tWOoTeH1XrNhxBLh4lu51OMaZzbaW66zVFY2r+NuAsNxebB5qivNNid4k2BZAbGV/b9NIh6cp+zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7911
X-OriginatorOrg: intel.com

On Fri, May 10, 2024 at 10:29:28AM -0300, Jason Gunthorpe wrote:
> On Fri, May 10, 2024 at 04:03:04PM +0800, Yan Zhao wrote:
> > > > @@ -1358,10 +1377,17 @@ int iopt_area_fill_domain(struct iopt_area *area, struct iommu_domain *domain)
> > > >  {
> > > >  	unsigned long done_end_index;
> > > >  	struct pfn_reader pfns;
> > > > +	bool cache_flush_required;
> > > >  	int rc;
> > > >  
> > > >  	lockdep_assert_held(&area->pages->mutex);
> > > >  
> > > > +	cache_flush_required = area->iopt->noncoherent_domain_cnt &&
> > > > +			       !area->pages->cache_flush_required;
> > > > +
> > > > +	if (cache_flush_required)
> > > > +		area->pages->cache_flush_required = true;
> > > > +
> > > >  	rc = pfn_reader_first(&pfns, area->pages, iopt_area_index(area),
> > > >  			      iopt_area_last_index(area));
> > > >  	if (rc)
> > > > @@ -1369,6 +1395,9 @@ int iopt_area_fill_domain(struct iopt_area *area, struct iommu_domain *domain)
> > > >  
> > > >  	while (!pfn_reader_done(&pfns)) {
> > > >  		done_end_index = pfns.batch_start_index;
> > > > +		if (cache_flush_required)
> > > > +			iopt_cache_flush_pfn_batch(&pfns.batch);
> > > > +
> > > 
> > > This is a bit unfortunate, it means we are going to flush for every
> > > domain, even though it is not required. I don't see any easy way out
> > > of that :(
> > Yes. Do you think it's possible to add an op get_cache_coherency_enforced
> > to iommu_domain_ops?
> 
> Do we need that? The hwpt already keeps track of that? the enforced could be
> copied into the area along side storage_domain
> 
> Then I guess you could avoid flushing in the case the page came from
> the storage_domain...
> 
> You'd want the storage_domain to preferentially point to any
> non-enforced domain.
> 
> Is it worth it? How slow is this stuff?
Sorry, I might have misunderstood your intentions in my previous mail.
In iopt_area_fill_domain(), flushing CPU caches is only performed when
(1) noncoherent_domain_cnt is non-zero and
(2) area->pages->cache_flush_required is false.
area->pages->cache_flush_required is also set to true after the two are met, so
that the next flush to the same "area->pages" in filling phase will be skipped.

In my last mail, I thought you wanted to flush for every domain even if
area->pages->cache_flush_required is true, because I thought that you were
worried about that checking area->pages->cache_flush_required might results in
some pages, which ought be flushed, not being flushed.
So, I was wondering if we could do the flush for every non-coherent domain by
checking whether domain enforces cache coherency.

However, as you said, we can check hwpt instead if it's passed in
iopt_area_fill_domain().

On the other side, after a second thought, looks it's still good to check
area->pages->cache_flush_required?
- "area" and "pages" are 1:1. In other words, there's no such a condition that
  several "area"s are pointing to the same "pages".
  Is this assumption right?
- Once area->pages->cache_flush_required is set to true, it means all pages
  indicated by "area->pages" has been mapped into a non-coherent domain
  (though the domain is not necessarily the storage domain).
  Is this assumption correct as well?
  If so, we can safely skip the flush in iopt_area_fill_domain() if
  area->pages->cache_flush_required is true.



