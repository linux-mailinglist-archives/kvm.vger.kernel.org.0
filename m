Return-Path: <kvm+bounces-53181-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 48F4DB0EAED
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 08:47:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 392951C821AF
	for <lists+kvm@lfdr.de>; Wed, 23 Jul 2025 06:48:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A6A01E7C12;
	Wed, 23 Jul 2025 06:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GvGSPOWd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14E34191493;
	Wed, 23 Jul 2025 06:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753253251; cv=fail; b=qQxYH+apCYmR4wsJer1FazJiP60wB32xGgOVc7RTP/Cx+UYboGKihoFjlyOnWECWhLEfQXftV6qN5xmIOj4aeQCYBPWLZcTFvAAz/dr4Jgq2Rlx3NIaWep6LwQsM3gXJ/3Q73rlkM9W4AJNBxYt3tQgwPlhetKayi1sJOBZnhAs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753253251; c=relaxed/simple;
	bh=amSBsXpURkVVdMCjIcxMUzDxJsfYVzMat/BfY0/2HxA=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Jwo7Y1dadD+xRxuExqivzfqEdGrstd6sGquo61JMUfRo+8Mqvlqd5MnpVRB+HJ8MkWswRgxojYX+FVbC4w47xW+i8YGA19IPS4zLpTSudmVe1tsBPMzY/YFHOWPJ/wGyBV8UQNsUEaDXPV88HbYHyiBH5VNck6C4NDOTjPqUXhs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GvGSPOWd; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753253250; x=1784789250;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=amSBsXpURkVVdMCjIcxMUzDxJsfYVzMat/BfY0/2HxA=;
  b=GvGSPOWd2iyh6r5T+vJAPB32VHNSntRHuckRru8wSSQac65LSW+sh//D
   qqjV6Jqh2YBUZ0xJCvQdbt48gxyQvanibXETCbmb6DNLylbgIGWf1zozp
   UshxbUwEgNCKBR6227NCFZBs88GC0Qob5akQf5Gc1bSAIM9pobz8AnsQ7
   N7b6IO0VDrI1g++atbFaqNjwebDGn5JCIs19UNWC6EDjN0nHDlBz2D7TY
   BwHX2O8DQzMbb0YIokaeMasHxCjMN+TnGSuJBmBuJ/3UMPdG5RoiZdXH1
   u2Na4X0QXhNf7fHJxRG4ccq8ulYwqKMMRSz85Pcby3ZvQ02adObPkbh6R
   Q==;
X-CSE-ConnectionGUID: c21r9SJjQuK+lfRBqxKUcA==
X-CSE-MsgGUID: ulYhVplJRZej/6bM/u87PA==
X-IronPort-AV: E=McAfee;i="6800,10657,11500"; a="55677624"
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="55677624"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 23:47:27 -0700
X-CSE-ConnectionGUID: 5XtGoEVPSZS0LHKWeBTFaA==
X-CSE-MsgGUID: 3KbYpG2RTmChAxjUrDDPLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,333,1744095600"; 
   d="scan'208";a="163584228"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 23:47:27 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 22 Jul 2025 23:47:26 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Tue, 22 Jul 2025 23:47:26 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.77) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Tue, 22 Jul 2025 23:47:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SdJeV0tvCBChasd8CP51trk72mXoBWu481H0LdS1MAj2UDxqqXtrCKCQdmcdmuuuDyyTuh8Nytc5LK/PNCePIdAwfs3DDmfSw1Y+R7W/JJn6RstlPmL0sK8m/ygCyHYW17hmk3xylD0FGC5UAoHlsl6RdSR/E8nRg2edJXE/OAk2B44V41Msy+PZQnP2NEHRnLH08GDWtpvwN++GrMGXYPPZX7czyyC5WxkTDCFyHmH9ai5F0ec/KiSLZ8XLwWo6fFOOWt4xDDYjFGmqPhsHWy+gVT4yhOyeRVOyKCFqYjpCwG4ViRIkeh48xALiCAVtjxMRXJGuc+EUg4x69ZedHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uAMoDoYkY4YmumuDiMyBTEIsoyJdzyu0xhOPbV1uVno=;
 b=DOUEbmJf9NPeHkRMYK3zGmE8KW+LgfsjaTbJPY82tkIwFiNiArQ8qShN9Vgo2VoZ2npy5pSyZGwrkcaTBo0j/9QcmeMiyBbQG2OU+oX2Zaq6b+Zi1iVvFP6mABivhhHbIF9urHg/21gKzsS2QXHP9/QOkyDelknYDN2Bs8rHXg6qcfvRYn4j4Dd2AP849RJpNaLzINCO8NKJ+7e05/iDMbq089hXwNCRQoqS98vlKiSQi2OePJmHWs9lDuq0PppEt1BUirj7TOeS91tn5P2OwOfrU1qK83MRNey/9uhVopUGRfXe380CWLmDunU/I/CekXVejQsniRwcBK02jvx0Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH7PR11MB5886.namprd11.prod.outlook.com (2603:10b6:510:135::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Wed, 23 Jul
 2025 06:47:22 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%4]) with mapi id 15.20.8964.019; Wed, 23 Jul 2025
 06:47:22 +0000
Date: Wed, 23 Jul 2025 14:47:09 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "ashish.kalra@amd.com"
	<ashish.kalra@amd.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mingo@redhat.com" <mingo@redhat.com>, "dwmw@amazon.co.uk"
	<dwmw@amazon.co.uk>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "kas@kernel.org" <kas@kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "peterz@infradead.org" <peterz@infradead.org>,
	"sagis@google.com" <sagis@google.com>, "Chen, Farrah"
	<farrah.chen@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>, "Williams,
 Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v4 3/7] x86/virt/tdx: Mark memory cache state incoherent
 when making SEAMCALL
Message-ID: <aICFbbfK29Y21thJ@intel.com>
References: <cover.1752730040.git.kai.huang@intel.com>
 <ac704fa28a814b8ef5cca14296045c14b1fdd5d5.1752730040.git.kai.huang@intel.com>
 <aH+lx0vJE5KA7ifd@intel.com>
 <322fed1cba5355ec3ab27ad721ff8142e9361aff.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <322fed1cba5355ec3ab27ad721ff8142e9361aff.camel@intel.com>
X-ClientProxiedBy: SG2P153CA0004.APCP153.PROD.OUTLOOK.COM (2603:1096::14) To
 CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH7PR11MB5886:EE_
X-MS-Office365-Filtering-Correlation-Id: 333c842d-cf5f-41af-4c99-08ddc9b4c6a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?t5Smu/dzvxrRZC8tGy9QeuiRzDSpQQUwgJpGDpmVv5VP5/R0vn6/Dkx0LroE?=
 =?us-ascii?Q?Slvr9xzqdkmZYI2Hw7g8ElkfO5M9I7TfJiF+y/1RT1/bgFm3r2mgjswBOcO5?=
 =?us-ascii?Q?nX9Jf8B46OcuRtMbpRj1cZ/2BWozNaAr3nYOrvErfzkZFubSWSl6JOVR+5Y3?=
 =?us-ascii?Q?DoRvfRY3RHUzBWlllYh0e2HvJUQaHk/43fYIdVV+IRDYoLyCsk1Uri5k7saF?=
 =?us-ascii?Q?vMzerb0yS09nblQpFBwz3rGMgykQU4HEAgcYOeSVyAN0hK4p6mRNGLwyd+8a?=
 =?us-ascii?Q?PrhlXmtKxPNBC4CcJIxQSfTVMn4rud2aByLmss3s1CvC1GS43KaxLmeKEgCS?=
 =?us-ascii?Q?kv7ybazFzyliRtEBfthRjVhuNjvzJj6uzxOdVLg59xwfzsUUL2Pkb8fyKU4J?=
 =?us-ascii?Q?0SCu8rCPaJtiqV5IEiSe50/8kFJh06BXjhGvVvdCZWe+kr8HmA9yd3akI/B5?=
 =?us-ascii?Q?KmN6XD4HChQV0YYXT3QMbGE5EXwAwjWajqUu9pCLoEL5XjXVFqbqP7LUgZqF?=
 =?us-ascii?Q?K49bAgPiL+aX2a68FkLzXvEnQJ4UVXkXmTtNAhYaAW7zW/kjeDZKH1OOLkjr?=
 =?us-ascii?Q?M1/TES73UxjE5SIoiLT2UkXStS40aKZ4m8PFd6A+6krjHCADWYGZ2UelEw9M?=
 =?us-ascii?Q?dfAfjIVjFurIoBMk0zfPXN3SRDYF5AnrRBvxhyGNK+QBv1FK+eoIs3NMr6w8?=
 =?us-ascii?Q?zrdvQlTPIxCNmcGNy+YEbR1KOA0oJJbp7DNMj2+N7XkXQW6bjALWfMcZfTAa?=
 =?us-ascii?Q?P90amIDPs04tMz0Eh5VrHsKGCHgMPiPaMjoIxKUxGIEHzbcvYEHyUW3Dy+hw?=
 =?us-ascii?Q?2V1Bfy0/51vkL8O4Frw9pu88kULQnULIq32gtk4XAnkTSrFcw9uYYhCaW5uG?=
 =?us-ascii?Q?p+/p5T+xBijvfuBzn3mC9ZYC+opdMI2AqE8c2vq1s6x4nSbbLTWhzh0oTiNf?=
 =?us-ascii?Q?G8ZsPW8aH4ImhD04g3yHrjD7wHNoomWXm0rS9vdiO4ZGVghP3na9pCpjEhj/?=
 =?us-ascii?Q?39AtBeZdffqrKCYa8JF6aI59SC2GQdrCShhnhWKohUSP1kjlUoL55LKnvDDv?=
 =?us-ascii?Q?VmyGXntIvKUENx5xR07aBe72Hl8pUSIHfP/cJ1fHOjFuDEt6npJhGod4vlwM?=
 =?us-ascii?Q?TZ374zxaXOUooXiOGXDxPwYeS9Gfq17F0A83rGvFy7qalRrE0s3alkNA7rlV?=
 =?us-ascii?Q?4s2J82XDKe/gzdCDe+xmII5p7x89O5SjWc8R+BDfc4sGjsYAruuIOP89YCZT?=
 =?us-ascii?Q?BmL6l+5FVkrLj/MWxxfEIjAq/w96WNTJ4GqMRaKi0ZhIV1xQcG5Frs1yAuyo?=
 =?us-ascii?Q?cPHIUQLmP70VDszFM2523P/nSg2qdt9ltMFwqC+Lu/a5M+0CvyepHgkGtDW2?=
 =?us-ascii?Q?9ks/neTpB+Id1A/l4xKLqq+S8PBSwwEc6WYCqwSuX9X6770Ew4fDaUTSv2rF?=
 =?us-ascii?Q?jQInB2JuRJA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5B1Oap3r1MW4kuDOoHU9CRe9in3AWlEwpztdCZngyAKx6vuqhvcymFu7PbXW?=
 =?us-ascii?Q?dMWafUEzs263GEWdsWyNLXn7rK0ssBkHouU6EIA9Iw+Ta+9rrgtqVInXa6zW?=
 =?us-ascii?Q?4gs36nV9NjStrcHZnTb7NUKAPyqeopvIMEAaTxrmzTkAo52637ZVyvQfAP7x?=
 =?us-ascii?Q?NnL5oB/aIBwTKTz1C9oJCcp/P7iWDDecqf+mp+3/zpt7IC7YxlL4c34RgbCI?=
 =?us-ascii?Q?LUgMgeVLui1sezd328guhHSGYn3btcPi4lOmJwQV4Fu3K3OJRN4/0lB5SvaS?=
 =?us-ascii?Q?GoziRumCQcO+bzxRIiYBJkbSJ6ugWKirCfyac0Jhu6I9nkyTRgfTHeV2j2JH?=
 =?us-ascii?Q?5qUkHwqfK9gzsmaPV1sng5MXAIF9LYXRa++Zt627sxAfTQ1vMk9kXOmiFXaq?=
 =?us-ascii?Q?6npLUNk8jn2R2FRCIV42kfgRJLzS+R/VQhSf9utvwzoF54xeXkk+coBZMyw9?=
 =?us-ascii?Q?eTyX4yzNVO5jxOsh3zEFzBpFR3nxRI+sOULarX+It9ycRwdn5inkJXgFR1G7?=
 =?us-ascii?Q?3yBgIk7tEtCDNeW7loobhZFREF/Pj8yYLOqjQvUZhliRNc+VwPWZsWP8CnGE?=
 =?us-ascii?Q?GMPCWrZznz0AodkRWBWyJvBY2Bpt+Ce2vx1e5OjM+MIYFWTcEO2X5hA3m01O?=
 =?us-ascii?Q?WRPw0x42DwKwdzumw6h+Dc57/GWFuwbxkJbRT9aK2Axc6IA0hoWygzfG04qq?=
 =?us-ascii?Q?AqHrK6TlGafaEDGvRD1BJ2mmcdFYhlTHd2U8Tmi7H7FVzsnfUl2ylqcbfvwI?=
 =?us-ascii?Q?2x8GAvRWv8NUdoWkKVW7qWy8j19BsyPVPA5beVNRCSP+6G4DKER7vTakmJcP?=
 =?us-ascii?Q?bNUCMrU+TFSN+r121DkbjQyLiqGDtUkPcAYtc5q17qS2dkDQHLCz+vqIhQ/l?=
 =?us-ascii?Q?zJ6iiH4fFr8Judv5XByEhDzOCKJl/sk+ey9kTh3ahpvNKFHKXYRoXbkRoQL3?=
 =?us-ascii?Q?7LStstLs9wgnuPZNL+bcHZutAFjm+a6CLoZEB3ZKK9pWdyUOXeDCGNZhl+JI?=
 =?us-ascii?Q?CDwO6ibrf+78amj8BA+DPG3IKrVfAQEA9mLORwhahPWPY1bTDj3IWUl2tr3+?=
 =?us-ascii?Q?WPiJz4W3AEOf6p6cJGNUoj9+vmJczXAKzwp6L4Uz0uPbGFA4hz4VVC5Sxv1P?=
 =?us-ascii?Q?rCIZp75BH9sbT5OEtRnkogtRJvubC5aPHEfWYAIcuq0HCF9txjaAA9MF1LSN?=
 =?us-ascii?Q?+qtCsxhvp7zvc+3a29A7PE3Igaw9jMxCUi8rCHhR1n/Wk81B1puxXI6LoRAO?=
 =?us-ascii?Q?6iu0G6+/02Hb96QxJ4EBInMmNjAyuqcoAhp46umEnUs2IATWflVwPPG6h2gP?=
 =?us-ascii?Q?FourupQ5YWRciZXRtQbT2kVa8RHeD7tLeVLrJE55cOo54re5U2P91L7o6ZnO?=
 =?us-ascii?Q?nyBAzwwBQJYftu4B57H05ynQ3OCxOHV7fUnvJluVgwUBMamAkc3QeHGuXKQl?=
 =?us-ascii?Q?/Og5wTjTq4onkKjod7NhXSy1o2IGFLY1fqhG+dvNDcP9MN4zOW/ndKgfJnWr?=
 =?us-ascii?Q?sIvhyq2nGimHR3XplfB0Yoxl/Yp3f8K89T74ZRny18S8RkGx0oBYzTIN3XSl?=
 =?us-ascii?Q?RbUyMdZ7Yh/GZo5ERSeJdtQMTyaPq6GoD1pJWuub?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 333c842d-cf5f-41af-4c99-08ddc9b4c6a3
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2025 06:47:22.2138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g5qRwXOuOhDVyv+URXUrMpWtVNNItOp7XxlDaSSvaHCJ4JuP5PT2c8soxkWwOt4O5y/0z3DfCXr4h4EcWhFOhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5886
X-OriginatorOrg: intel.com

>> And tracking cache incoherent state at the per-CPU level seems to add
>> unnecessary complexity. It requires a new do_seamcall() wrapper, setting the
>> flag on every seamcall rather than just the first one (I'm not concerned about
>> performance; it just feels silly), and using preempt_disable()/enable(). In my
>> view, per-CPU tracking at most saves a WBINVD on a CPU that never runs
>> SEAMCALLs during KEXEC, which is quite marginal. Did I miss any other benefits?
>
>The cache state is percpu thus a percpu boolean is a natural fit.  Besides
>the benefit you mentioned, it fits better if there are other cases which
>could also lead to an incoherent state:
>
>https://lore.kernel.org/lkml/eb2e3b02-cf5e-4848-8f1d-9f3af8f9c96b@intel.com/
>
>Setting the boolean in the SEAMCALL common code makes the logic quite
>simple:
>
>  If you ever do a SEAMCALL, mark the cache in incoherent state.
>
>Please see Dave's comment here:
>
>https://lore.kernel.org/lkml/31e17bc8-2e9e-4e93-a912-3d54826e59d0@intel.com/
>
>The new code around the common SEAMCALL is pretty marginal comparing to
>the SEAMCALL itself (as you said), and it's pretty straightforward, i.e.,
>logically less error prone IMHO, so I am not seeing it silly.

Sure, let's follow Dave's suggestion.

For anyone else who has the same question, see the discussion here:

https://lore.kernel.org/lkml/9a9380b55e1d01c650456e56be0949b531d88af5.camel@intel.com/
https://lore.kernel.org/lkml/6536c0cf614101eda89b3fe861f95ad0c1476cfd.camel@intel.com/

Both options, per-CPU variable and global variable, were evaluated, and the
agreed approach is to use the per-CPU variable. Apologize for the noise.

