Return-Path: <kvm+bounces-52580-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ED28FB06EF2
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 09:31:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 24D5A1888598
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 07:31:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1AF228C02E;
	Wed, 16 Jul 2025 07:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SQ0Pn5ZP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0462627146F;
	Wed, 16 Jul 2025 07:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752651063; cv=fail; b=TZLzh44UESJWb7GsdfL1LpdDoLHxxTnK/YKjVMK8YjNrVRHYptM/Y7aCBv3GoZPYpYuBcBOekxNCHupD4xvyZQXqm4QcorQCI4/oTgenbRbH/8IYF19XCE3Pori2HVAGmthVep2T0JcQCmSaDGV+EPDMUZLJ6izn2JwA6+ryhis=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752651063; c=relaxed/simple;
	bh=TPnz0LFS2vfYzDuhxRURBBjyAFqeY3aX9OCBLN8a2IQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Akct4zx/eEZnf98g7df1elZHg+kgu7JPMry9kes3Vbvjys1klgl/qqqTC2z/VehNWXrqA7t/bxFAarJACWILxebCBAUNVc5B/63k3oqAHLBUrQ//gj6ggHc9Ec6m0g1G/tHjOtlm5bLDZqpeYOAMNVUijOh9dfJiU4qKDpl5iaA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SQ0Pn5ZP; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752651062; x=1784187062;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=TPnz0LFS2vfYzDuhxRURBBjyAFqeY3aX9OCBLN8a2IQ=;
  b=SQ0Pn5ZPE3uqYaLm2W6LSNJOpvEHdx255u5xkuL/SRxnx1JCmMluEHJP
   DpKvBSJAbwoy409fM0CL+/2mGVNefDZFkbZ9xW6d0un07XpSu3bllbjF+
   +xyHiDsimUvP5z0xwcSMSZOSo6ShZSde29kURSog5HXq8a8K4fXidvov1
   OJFis5E1XeB5r+9yq+54skk/gS2TFkoplA3iWnpHP/Kzga51wo0tjNWV/
   NzPxnYB2nkafmBGwgrnFUzGrD8+9yrSUfgKAKEn5Lhh7DcUOHizfS8k+8
   57dfE8NJLO3jl2MNO3j1W+PuAEdHQSoWd12EetY8v00vTV0QqkvzuML0O
   g==;
X-CSE-ConnectionGUID: ksJ10bGSQeW88ShllTDJ5Q==
X-CSE-MsgGUID: O4AOMTuOQWG6B5u67iBbYg==
X-IronPort-AV: E=McAfee;i="6800,10657,11493"; a="66333734"
X-IronPort-AV: E=Sophos;i="6.16,315,1744095600"; 
   d="scan'208";a="66333734"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2025 00:31:01 -0700
X-CSE-ConnectionGUID: pIVg6714RiqGhHI+J74Fvw==
X-CSE-MsgGUID: Ded67RSZRsWrSiFUUYhySg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,315,1744095600"; 
   d="scan'208";a="157522435"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2025 00:31:01 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Wed, 16 Jul 2025 00:31:00 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Wed, 16 Jul 2025 00:31:00 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.58)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 16 Jul 2025 00:30:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=stlGJ3Jbw+vC5H0V+mJJlIeovYA9WtpHeN9vM0gCe67oBPjizgEKXFq18ABkMgbnB/IIHghDIHC6K9QrVQHtCH30o148T/Bdii19n1AB/Z1IZOa5CX6HFiuDwxS4j31MwStbUOFCqmZKO1I8g7wdt3Y/XlqZqB2cWjzKzxL70i3fET756C7HqTavaa3rNf19lmvZiBWMYHUogYWEM88A9n6TOjBc1tSWm5f827UvamTzp33hIR/ConwAuvICkhGeAu46vZ2Ba412V4eoNdu1pNxhnAkD3UoNFm/a9exNHWW9fbqtZtiHIyBlXz2AOdSai54zU7VfG2X4k8Efu3usWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wKDu4CXMZ8WDpN8mh4PRNIhHMfn6E+yitRQZB9Qmu2g=;
 b=N4na5PRKE9LCKp2OzFj0cvMZdXPai4Kvd+8vclwsdJ9Sqeg39mg8P+YYMCv/7igCW6koilaMPqcWh6lXUwaAgeAQx+D1y3hgSbZio1+k5xsSqCnvbjQKEcDI3X5JAOngC26bK4CISn9SnTt2hoBicRFmp/4qsdr/i6FuI7mhQh1TmeVJHNHN4vsMQmPaJd1N9fpLWOPeyicfw8bmQGk8Q4j48tUvP8Jm8Utzwqslwmuq3ortk8CA4Yj+v/EP/H7zm+5kRCJaBRSvwH1vwzKbdJ4ofxeSn8ckyuFAdW/APlQDKG7TLMTLDuRUxh92ZI5vfWyJk61CVLl5EQSlF1iTIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by CH0PR11MB5265.namprd11.prod.outlook.com (2603:10b6:610:e0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.32; Wed, 16 Jul
 2025 07:30:47 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%6]) with mapi id 15.20.8901.033; Wed, 16 Jul 2025
 07:30:47 +0000
Date: Wed, 16 Jul 2025 15:30:33 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Paul E. McKenney" <paulmck@kernel.org>
CC: <linux-coco@lists.linux.dev>, <x86@kernel.org>, <kvm@vger.kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <eddie.dong@intel.com>,
	<kirill.shutemov@intel.com>, <dave.hansen@intel.com>,
	<dan.j.williams@intel.com>, <kai.huang@intel.com>,
	<isaku.yamahata@intel.com>, <elena.reshetova@intel.com>,
	<rick.p.edgecombe@intel.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar
	<mingo@redhat.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
	<linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 00/20] TD-Preserving updates
Message-ID: <aHdVGYxCP8s6ItTZ@intel.com>
References: <20250523095322.88774-1-chao.gao@intel.com>
 <aHDFoIvB5+33blGp@intel.com>
 <a7affba9-0cea-4493-b868-392158b59d83@paulmck-laptop>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <a7affba9-0cea-4493-b868-392158b59d83@paulmck-laptop>
X-ClientProxiedBy: SG2PR02CA0113.apcprd02.prod.outlook.com
 (2603:1096:4:92::29) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|CH0PR11MB5265:EE_
X-MS-Office365-Filtering-Correlation-Id: be63f2b2-1110-458d-b8fe-08ddc43aae73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?JEBjN6gjulUoadRw8+F10UfcW8DKk+UGbbcEgx3QzuPUaFFdL5TkZjcoz7Tz?=
 =?us-ascii?Q?zfMaKbAbENOclg8qPaP1XGeit1sFyil78OKDK9qiBPJZ8XBa17Y5SPHuE138?=
 =?us-ascii?Q?CV8H66wzIgq+2p2XDJ51xaCfTCi5XtF/siXkS2UBNoegmPgV4lUk3cNzEa5i?=
 =?us-ascii?Q?5fmMmBMPKl9gqQiQ9k84tIvkwig3gg1GtTBr2Qmq0M5qWNK+2dSJ63oaF9cX?=
 =?us-ascii?Q?9JnwqSA5UhsDqmpR004DkMz3L7snsnT1J5nRqH712sVY3A3KchskjkxbXxYj?=
 =?us-ascii?Q?BOTaR8k/+8FJ6Yo3ZOnxR/Ash6jcaFjx0A7GYiRkpoeCTmsAQdESNtlv4ADx?=
 =?us-ascii?Q?0zGmt78qNdwFig+SifxzeZkX0hQ1TeOflPGXVOVC9IuaFT/qGRYBJico93/T?=
 =?us-ascii?Q?tR33w7v3uGhZ6gvb434vy55tPUMn20lVNed8j7wzzlDKErZApQi6Tg9aBJLn?=
 =?us-ascii?Q?CyXipU3AEtJJqnpBTafYEACSnbBoyPfKDpYin6xYERRx15o0xTNofDBItDPO?=
 =?us-ascii?Q?dVjj8iGQKZlOsh+M2VbOeilRiL6O8FGDhgK4yNgyVmm29wpltclXcIYsXvrQ?=
 =?us-ascii?Q?EwUMeVC01MW5pNsLvHNzr/5ppPXaBPSuDzpIVkknLRZ2FDQOoMSZZxTikR6C?=
 =?us-ascii?Q?/YJSrzvChO5N817j7NUGvP4kthIXXB1h7q2Ni7KYGxb71OuLshFWC5ku9Yj/?=
 =?us-ascii?Q?zd86VJ2LqFpr6RpxgoeNvn9yMZa+3oJ6XcS7PwcxFILGciimTeXH6rElLk4W?=
 =?us-ascii?Q?1NxmWfycurfxbBPWLo57boGmoxbYvjtleHNKRAkenQgy0okYSQLaolusjjpY?=
 =?us-ascii?Q?Lrx43rXSiKBe9VmZzZN01ygf9Mkpwf0krmmwgFCsFTDxxZwzp7EsYLhY13lU?=
 =?us-ascii?Q?bvUW11TodVuLBwEqBLd7Y4CHweEB4rdFIrkyWnxX1o6JAHzbWJ395h4Qv9yD?=
 =?us-ascii?Q?TG43s5JMYwjatUwcnaOZfh4kDNaFNlCQ7DIhp6WTOlb31U6ISg5XdaNBmjvq?=
 =?us-ascii?Q?49A0TAp/UsVuAuG98U88mjAF3Mu1znyVOP0zGm38G2hTkoM99qNA78GjJ6ro?=
 =?us-ascii?Q?MXTRylS8zVpfJRcvY49q/81EPnLXU7HDbYg35/akScxydH7h+p7Xq9nkXZc4?=
 =?us-ascii?Q?vDGyU18lmDRCaR7KwEu7SwQLbGuUU7TPyU3OZgwxp9S+OjCqhry3h2ak0H8C?=
 =?us-ascii?Q?PHBV6EHU2r4Uui1Vx/tW0g4fqy9A+aa4lWQRr5EKZYq1F2OJ7EePAEmo9PKV?=
 =?us-ascii?Q?cFZ26FBZ1pWt5LYkKnhcWip1ifN+R3P3Uz2US8hxRbRjM55ir09vGosqwxJB?=
 =?us-ascii?Q?MdrBcukebBUVUFK1UcIR72mKxyVRIs7wqcnlarCPseGuyjCqgtsgCoaQuZqT?=
 =?us-ascii?Q?Adv89lHVe72WK3IcRjdCqSTcAK9KwSnFMt2dI6EvBdd4wo4sptynuVKgW1N/?=
 =?us-ascii?Q?KCZjJuTgBtI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?opVCtOkEuqtY6HUuE1sPLE3Bz44QqBibSERLvjHJw7me9iEC11k94ga6qpNz?=
 =?us-ascii?Q?VwH2v28/U2tzY16FtUJYYuAqDyoXyhas1MDXKxUyamaxm4ZvWaXa2XCh/1HS?=
 =?us-ascii?Q?NJFvefbheLaaoLCb3uBw58WSIq7NqPo+dN1h2s1vam0aVsvQSokyOFu9OUg6?=
 =?us-ascii?Q?NKyZyjE7xptWzvsRSc6bFBBE9yHdgn6BCXRBhYn4OtI8xoMn48gCfvghCbFJ?=
 =?us-ascii?Q?f4MY2m6vE1OPYNK2kCLy/DglLftbWEWjvdJkMxmMEG4KBUehw95LNrLMlIUw?=
 =?us-ascii?Q?RH3Qo/vww5LL2p1DsqSG2xYqSN3X1Baa43IvumFNlvXMLHHE1dUIaR16/ZcS?=
 =?us-ascii?Q?IzZIJYI1Z0MC7T8JhevyrVorw8t0Jtnllfuld1ECuVmWFP2y8wKE4Qmve9YR?=
 =?us-ascii?Q?fX+XugFcdrE3mSTrqkK4PpELZI30HLG9vNyiNUWHXug3TzHYoRupvwoJfr5v?=
 =?us-ascii?Q?m6FC80M5fSByWChOeumV/1HNm/btxdCU7cR/1CkGnqEVbawnpQgKOQg6XsSH?=
 =?us-ascii?Q?Hsb07V0hI+H5NRVsrxXdRcFQWvysFEmptzuJN+23YBsE7oo3YGGGEJHaiy3w?=
 =?us-ascii?Q?NnreILF0lot5j9uws/HVFZtG23k7fCP1mMKuu+a8/MpTIrFm/DzzUSfs0ceL?=
 =?us-ascii?Q?4Bm2KOnTLmEZRLqM8BYYWgYw/K+RPXrZM+WIrGlQEpSb5IeVUueAcIzrgJJL?=
 =?us-ascii?Q?C3de5eYR6I8PMWRLsXBuSDasf97Y7Jel3wEhocUHVXeRz/LZhu6tCTo6brAA?=
 =?us-ascii?Q?M1OghW2RtIB8l35cWWBaVQC0lQO9LCDkAS8+HFRSkPuWGwVsvUUETXihjznH?=
 =?us-ascii?Q?XmQXOK1Quk5f7P8WshKATBFSrHk0zm7Q8zlDqf2IVyfGFsIIRWbkaYOsf8GR?=
 =?us-ascii?Q?MCI4s7uDpRAnTjncuiEjsq+sk2gzVbzA9bZI2SjMpsedo6jF1Xrtd0nO0wlW?=
 =?us-ascii?Q?wejZDKHKFpxcneP8yQEeyrJV6hRIZfmTQdzbPy64DoCEUUKMXWkhGtnOwrn/?=
 =?us-ascii?Q?ZClWKeIdqH1d1uWwe0pr77ZXTztfD5eKYmK0baG3T9BroOhoNpq1769M42tH?=
 =?us-ascii?Q?TyySnYE3+iirSd9gmVmjI8/wjlSyP+pzF6DkrO7f9MWZLoolYPqJlxxJYZHi?=
 =?us-ascii?Q?7asOXf4XZruxTUAQ+Adg1Pjj2yq7+GCHJbt/ZtkrxttXc4ldCYlQ1dX7GcuM?=
 =?us-ascii?Q?YK4wkz4gEIlksbl+ekuXStTlL/lonrsAtolYt33jgHy+2ZaIx82q72i2V5N6?=
 =?us-ascii?Q?7aZ+E1EP/J8YEwg1/uYWlRAuS6JdyuuE6Cxox81imewqhZD+KUfw8AIhcdtf?=
 =?us-ascii?Q?BTkD9A4b+CZjRIiEABjXEPrsLoG1C8QtuB/VLtQFranYkG/cKFDzJx01EuMT?=
 =?us-ascii?Q?8k4+gJtKxpcxhpT8ci7f9T9x3UfDH0jD9rRfsRo4fFAW/hQVyblJS3hYM634?=
 =?us-ascii?Q?mbPCmxMtaTR9QN0x+3yhd6xrivzJQ+IQIoXijvIEa0KYkYWMbconDI4dvajl?=
 =?us-ascii?Q?M4s7lp2/CrYjBaDaV3Sa8HN378X+2KxTbGJftrJueN3xkRu5fcpphdVSkkwA?=
 =?us-ascii?Q?zlmS0Ym9LsIQSwuZ03BhVyxgDITMXYEKvM1OohDH?=
X-MS-Exchange-CrossTenant-Network-Message-Id: be63f2b2-1110-458d-b8fe-08ddc43aae73
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2025 07:30:47.2217
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I8JHnAbalppR72UlBQ8mQR5MTqa5lNB/wnRWR2KlmBykYmCf/FRszBijAaGgaZ6fhDiXrf2tcwGk5aG9jIIoIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5265
X-OriginatorOrg: intel.com

On Mon, Jul 14, 2025 at 05:21:47PM -0700, Paul E. McKenney wrote:
>On Fri, Jul 11, 2025 at 04:04:48PM +0800, Chao Gao wrote:
>> On Fri, May 23, 2025 at 02:52:23AM -0700, Chao Gao wrote:
>> >Hi Reviewers,
>> >
>> >This series adds support for runtime TDX module updates that preserve
>> >running TDX guests (a.k.a, TD-Preserving updates). The goal is to gather
>> >feedback on the feature design. Please pay attention to the following items:
>> >
>> >1. TD-Preserving updates are done in stop_machine() context. it copy-pastes
>> >   part of multi_cpu_stop() to guarantee step-locked progress on all CPUs.
>> >   But, there are a few differences between them. I am wondering whether
>> >   these differences have reached a point where abstracting a common
>> >   function might do more harm than good. See more details in patch 10.
>
>Please note that multi_cpu_stop() is used by a number of functions,
>so it is a good example of common code.  But you are within your rights
>to create your own function to pass to stop_machine(), and quite a
>few call sites do just that.  Most of them expect this function to be
>executed on only one CPU, but these run on multiple CPUs:
>
>o	__apply_alternatives_multi_stop(), which has CPU 0 do the
>	work and the rest wati on it.
>
>o	cpu_enable_non_boot_scope_capabilities(), which works on
>	a per-CPU basis.
>
>o	do_join(), which is similar to your do_seamldr_install_module().
>	Somewhat similar, anyway.
>
>o	__ftrace_modify_code(), of which there are several, some of
>	which have some vague resemblance to your code.
>
>o	cache_rendezvous_handler(), which works on a per-CPU basis.
>
>o	panic_stop_irqoff_fn(), which is a simple barrier-wait, with
>	the last CPU to arrive doing the work.
>
>I strongly recommend looking at these functions.  They might
>suggest an improved way to do what you are trying to accomplish with
>do_seamldr_install_module().

Hi Paul,

Thanks for your feedback.

Let me clarify what do_seamldr_install_module() does. Patch 10 just adds the
skeleton (sorry for only directing you to patch 10). More functions are added by
subsequent patches. Specifically:

 * TDP_SHUTDOWN (Patch 12)
	Shut down the running TDX module on any CPU while other CPUs must be idle
 * TDP_CPU_INSTALL (Patch 14)
	Load a new TDX module on all CPUs serially
 * TDP_CPU_INIT (patch 16)
	Initialize the new module on all CPUs in parallel
 * TDP_RUN_UPDATE (Patch 17)
	Import metadata from the old module on any CPU while other CPUs must be idle

And there are two requirements:
1. These steps must be executed in a lock-stepped manner, meaning all CPUs must
   complete step X before any CPU proceeds to step X+1.
2. If any CPU encounters an error, all CPUs should bail out rather than proceed
   to the next step.

>
>> >2. P-SEAMLDR seamcalls (specificially SEAMRET from P-SEAMLDR) clear current
>> >   VMCS pointers, which may disrupt KVM. To prevent VMX instructions in IRQ
>> >   context from encountering NULL current-VMCS pointers, P-SEAMLDR
>> >   seamcalls are called with IRQ disabled. I'm uncertain if NMIs could
>> >   cause a problem, but I believe they won't. See more information in patch 3.
>> >
>> >3. Two helpers, cpu_vmcs_load() and cpu_vmcs_store(), are added in patch 3
>> >   to save and restore the current VMCS. KVM has a variant of cpu_vmcs_load(),
>> >   i.e., vmcs_load(). Extracting KVM's version would cause a lot of code
>> >   churn, and I don't think that can be justified for reducing ~16 LoC
>> >   duplication. Please let me know if you disagree.
>> 
>> Gentle ping!
>
>I do not believe that I was CCed on the original.  Just in case you
>were wondering why I did not respond.  ;-)

My bad :(. I forgot to CC you when posting the series.

Btw, it seems that stop_machine.c isn't listed under any entry in MAINTAINERS.
I found your name by checking who submitted pull requests related to
stop_machine.c to Linus.

>
>> There are three open issues: one regarding stop_machine() and two related to
>> interactions with KVM.
>> 
>> Sean and Paul, do you have any preferences or insights on these matters?
>
>Again, you are within your rights to create a new function and pass
>it to stop_machine().  But it seems quite likely that there is a much
>simpler way to get your job done.
>
>Either way, please add a header comment stating what your function
>is trying to do,

Sure. Will do.

>which appears to be to wait for all CPUs to enter
>do_seamldr_install_module() and then just leave?

Emm, do_seamldr_install_module() does more than just a simple barrier-wait at
the end of the series.

>Sort of like
>multi_cpu_stop(), except leaving interrupts enabled and not executing a
>"msdata->fn(msdata->data);", correct?
>
>If so, something like panic_stop_irqoff_fn() might be a simpler model,
>perhaps with the touch_nmi_watchdog() and rcu_momentary_eqs() added.

As said above, lockstep is a key requirement. panic_stop_irqoff_fn()-like
simple model cannot meet our needs here.

>
>Oh, and one bug:  You must have interrupts disabled when you call
>rcu_momentary_eqs().  Please fix this.

Actually, interrupts are disabled in multi_cpu_stop() before it calls
msdata->fn (i.e., do_seamldr_install_module())

In this context, there are two state machines involved. The MULTI_STOP_RUN
state, part of the outer state machine, includes an inner state machine with
the following stages:
 * TDP_START
 * TDP_SHUTDOWN
 * TDP_CPU_INSTALL
 * TDP_CPU_INIT
 * TDP_RUN_UPDATE
 * TDP_DONE

I am concerned about the code duplication between do_seamldr_install_module()
and multi_cpu_stop(). But, I don't see a good way to eliminate the duplication
without adding more complexity. It seems you can also live with the duplication
if do_seamldr_install_module() truly requires another state machine, right?

