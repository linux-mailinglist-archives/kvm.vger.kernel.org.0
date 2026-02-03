Return-Path: <kvm+bounces-69987-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0MkUGgTNgWl1JwMAu9opvQ
	(envelope-from <kvm+bounces-69987-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 11:25:08 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id E067AD78AC
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 11:25:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8156830D6BD9
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 10:22:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC92F318139;
	Tue,  3 Feb 2026 10:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f8brQY0G"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D59158535;
	Tue,  3 Feb 2026 10:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770114127; cv=fail; b=AIYf8lbYMZMYKmcc1oyPq4b45NgQhFfVU1Taz/CPO6wB28ROk9I/g6YAIm4nf4RSfqHD8LEM1C/ixxJ/cs8mmIcnf5cQBeOkHcb0Mt6q8GbXVDf0SNlr4jZw0aiPoeNOoun20Me5OzqRhbSK3PdGNU0bZzCn1pN8fOLs8yX9kC8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770114127; c=relaxed/simple;
	bh=9fEs5NYhLUcUx24egVdSK2465l9zc7/XczO/3pPzKto=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=YRUXVRtiEiv9lMZRvWo2ZJlb06So2pSgVcXgrwNytqy6R6vee2hONpqS+YOC3ECqR4BaTjV0eSKwlSGgqMSxFuiTPewt3o25dn1+BwoK8a51oMpBMpBk14XlNOebYfKdvxycssoyTa0CoYio2rHaJcv8WXxsy7YJc7hvzPphT5k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f8brQY0G; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770114126; x=1801650126;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=9fEs5NYhLUcUx24egVdSK2465l9zc7/XczO/3pPzKto=;
  b=f8brQY0GZ9t6A8MMuDbig/xwnA32dRRVF7MqTBc/NOXU/sD6+1Z+Yjw9
   KJxvb74I4HK9yxHdKXdKhhf6eIbbveWtdKJGFwlNjylJH50vs51SoxP5J
   s0h4B308IezAwIPCDMSJBclaY6Vjppb1O0OksEEfSxmfT3DLFg5vzNDHs
   XfFQ4RSApKf45Th9j3fLt1O4m628AzjsP9I/xFdY7IZ0wLBnrSbKR1yfJ
   OdLYw8WgZVI3U6eKfR1rp/uTZQbzfngk8WfEvXax5XesEmfWDUBpRyRrK
   51UTrtZmE/FiX2uxrSLw1qRq6dKR+U6sNGkmWnGqpmhpistOZzKF96jih
   g==;
X-CSE-ConnectionGUID: R6X5D6i7QZ+MEX6Oz5Nv1Q==
X-CSE-MsgGUID: hUAg2Bw7SlCkJmZIglmf8g==
X-IronPort-AV: E=McAfee;i="6800,10657,11690"; a="81910858"
X-IronPort-AV: E=Sophos;i="6.21,270,1763452800"; 
   d="scan'208";a="81910858"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 02:22:05 -0800
X-CSE-ConnectionGUID: GDcQ2LF0RgizFOjTpDMEFQ==
X-CSE-MsgGUID: O4PgIf/oTES5OqShiQ1izQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,270,1763452800"; 
   d="scan'208";a="232727269"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2026 02:22:05 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 3 Feb 2026 02:22:04 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 3 Feb 2026 02:22:04 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.29) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 3 Feb 2026 02:22:03 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bpZ/fwTcm4Ki4ClfZdrjmg5l5Pz5VL8Bgpdx3kjxqTKvYQtKRUSoUbp3cOXdcp5ngSAGD534tr6/QGuSPc1rNzpEuyQ5hDWAtRRkKQRAxnBqWMEBRvHlRsRvd90nZkGwkVRGWs4/mZVnauZTv3j6O7YDRjQq7Hj9ikdtbu5EqINCzjJBtKRxj/kvnVF1nZCzz/foD3K8KwKfMEO6iOpmHeiBPQDw5uPeUkJRPfOgrmbZKIM1k/kRRVzmtVNlBrSgjxKL/RSkqpdjHJxKEfuggIAb9HM0+glTZvQ9LpU3uzIT5qFaOuC6QZaxgRuHCJRc6zCxXX0YNT3uGIlcUUnFiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j40wJE8KhTbHMN47b+MFdwds66f5UBExVpyyVkBj/fQ=;
 b=h2/uZnVwHTohr1J6Szpx8aUrGFgI7724bgcfeCqv/3Ea6IXawtwHGj9vqr1sJ9q9t8Z8S1FMpAbmW6uqL9wyixIyJERe0+L+H+h6OoFXvCxNg8IfnULkGnfKx3/B1dLXS+VIvkA35bEK/JRSrCrRBdV/9d61gWN8aOovZP7QQbCBFWOxiguQZoFPeGrIg4exJ7Hx39aeo6bmrfIztn4ZPXQaoxbkqQgtGb0gjcIwhpK7kuiS23IpjFaewBf29pEmkxwvm/dunBAm/gHJuwVifYIHKgBCysYpsJqRQYMH1We2gfAMqznmxzrxU3ZAiohJKz+fYjBlQ7mTYc3eC6Bsow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CY5PR11MB6413.namprd11.prod.outlook.com (2603:10b6:930:37::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9564.16; Tue, 3 Feb 2026 10:21:56 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9564.016; Tue, 3 Feb 2026
 10:21:56 +0000
Date: Tue, 3 Feb 2026 18:19:01 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
	<x86@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, Paolo Bonzini
	<pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>, Kai Huang
	<kai.huang@intel.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, "Vishal
 Annapurve" <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>,
	Sagi Shahar <sagis@google.com>, Binbin Wu <binbin.wu@linux.intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Subject: Re: [RFC PATCH v5 05/45] KVM: TDX: Drop
 kvm_x86_ops.link_external_spt(), use .set_external_spte() for all
Message-ID: <aYHLlTPeo2fzh02y@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260129011517.3545883-1-seanjc@google.com>
 <20260129011517.3545883-6-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260129011517.3545883-6-seanjc@google.com>
X-ClientProxiedBy: KU1PR03CA0022.apcprd03.prod.outlook.com
 (2603:1096:802:18::34) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CY5PR11MB6413:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b512107-dd97-40a5-099a-08de630e0e9b
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?oz0gXCtiOV78A4pNsQ+PURJzntUqwYadXD9CBbOMIP0QO4Eimrm6D+fBFud9?=
 =?us-ascii?Q?q4g5WG79D952+BCm3i1iKNg+a0p5QD/fwkK1ApbDi/XzNth7vxEhZ7fytgth?=
 =?us-ascii?Q?vVDNi0pCeinsnmY/yHzGyM6tW28SDiFF7lSbIi0reSDWbtJLG/i/BZHZATDa?=
 =?us-ascii?Q?UIYcTCPFw475ag3PDsNKoeH0zoheZvj9tcEB3w8XBorkVzN+IaOaNsrj7qtx?=
 =?us-ascii?Q?znoSw4UcvIjCkDO0aeJHhy2jP1F3S3jbp+SoBa9i7tfRplWH0b9aZGD7Rbeh?=
 =?us-ascii?Q?eZqVCtR8jj1MfX2HL5ikX0l6Z3OwZ3NWuhLKzP4VpQw/Bxg91bmmumsxRrGK?=
 =?us-ascii?Q?+LcbWPTQWFyzpBJEQSwWiOS8lA8nmtZVLVWqe40zEqCL6TDb6JJeAmzr455R?=
 =?us-ascii?Q?LianW3jepWZB0cbokFx6dhZT8v3Hs2NByFvBjJTuSY5d+duRn+i+naKhBeCF?=
 =?us-ascii?Q?hej6tSqk8li5MQyYLdFXqMaDgAp/F9rTcs3Mvpmb6uN+IBWajh9lxm1p8d5X?=
 =?us-ascii?Q?8BGmmJogUJSn/QArVGQfxuozbV3xnn8I0xrs/bSdc8HoLtuqPB1TLfFkW9zi?=
 =?us-ascii?Q?O5XF5CxcN30teiIBwNt0+rKK87qDc+eBiKPRBJOpNVXEG1GJxNLNEhiWNwz6?=
 =?us-ascii?Q?LTQrJAqMdh2y2hSi4Y9lYudyJpWXG6hOpcnRjKppxO/ZrXV56mdBxFLTziUE?=
 =?us-ascii?Q?arxI62RE+gkJdrE/i6L7q8Pr+9iVDXJCGkwNlMMhKjxVK1UyMBjoo6Zvi592?=
 =?us-ascii?Q?Vm3KnyDciCwTJj2D28qf0u9mpSUpCtwE+j6ZXGLudIS/YElC488Ph8XCqBOO?=
 =?us-ascii?Q?Njo2RYnYW0MGXx33p5R4gpmDNOm82AmTYuZHeJ+iGOvHtX3I3KqWU6PGPLl0?=
 =?us-ascii?Q?NZQchGzG+BsM6M/bz80LGVzqD+xQZegD23j7TsJWgqaqt1S4Pw4NH8NGYGPo?=
 =?us-ascii?Q?gxXwdjlRcWmVoT1mxnLzUMc49U+pDdG4NFqGDNV97YvOY6APFKgRBaWrwr1O?=
 =?us-ascii?Q?jsELb2iXEpPI5iyLGR6JcSVD1jAXqtW0FdXDdTVt/RezkQsCeBEcaC1BtR55?=
 =?us-ascii?Q?dVYWt6IHtCbl+4/Ko6F9UHLYTzUNYrbVqeuCD+JWRp6tZnkpzPaDvlqarc4L?=
 =?us-ascii?Q?0V4V+neeKs6DtvQoh13TenkSNXYfYpjs//yJIG+aJohQwtZRfEbdcnkv/6nK?=
 =?us-ascii?Q?QKC1XC2lWWjblaE+G7tNgfX/TiMRs6K37hZ+auPJkBsdLBLWo9C5Xp6GBoLz?=
 =?us-ascii?Q?BQnx117DMTMSFznLFviEevcR+NTUeeeqLrPB4wBpfOlnTyYc4sV8j4CQaPMt?=
 =?us-ascii?Q?wQnhynUWLGNnrcY690ECz4cTTh0lXfPkwoujuD7Fpqh3yQ4iyCM4njAGnkgS?=
 =?us-ascii?Q?mxFU3do/oTbY7HWIllhD0VK3wBcx4WKKUuwFyWwBhxdA/gfDZngtTV4EVC1i?=
 =?us-ascii?Q?9XmhXC7ePtd0l4RG7atBt7Aw69/PR4Y7+xxwPJ750UzyRq0OLj6hYjZY3QzR?=
 =?us-ascii?Q?Lpm/9u3nV3SzXw7JWe+GjZatX1fM64Wgo4iCaBAXhM273hKFMbD9/P3nocP7?=
 =?us-ascii?Q?q/ByfyGEc2GQQvMyym0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mw72yntqyprRMYG8ein6wZouzaj+Q++Hmju/lwnZod3tnpd7M6t31hmhzyQW?=
 =?us-ascii?Q?uFR3OwPF4X1i3WSqRbuuCVWW03LuIlGAyA99v5+/aGrPVGA7UKEjWFzpFSDe?=
 =?us-ascii?Q?PWdoYiaed5euzkC5KDsBMBT4KwVOrqwGgXPK8tSWFQFkZmkt0B4gI2KsXQrR?=
 =?us-ascii?Q?1lfnatBbNAHYhCt9h2PiQFqrdOZsmWEdCDOES8PP/7rh5DvnOlEM9/M4XGpn?=
 =?us-ascii?Q?pawNOKh8J58udN0CoNJbwWN5iCjWDD+2HhaV+rn8rMyJhERr5riXbrjec+a0?=
 =?us-ascii?Q?Uu/GMpodgtPZ9oQMvymLmk6KAUz2bEyZm8Vaou1LetQS9CvBcVOEKpbfn3IS?=
 =?us-ascii?Q?V7cfv/F0lBjq9Z2LEgEhAOextC1a+Sp2PMzTCOmoFjROFr/i35FWpKHvpkuM?=
 =?us-ascii?Q?Zd8GhuVhzkKYmQj57sCXVyI6CE+4QTeINMjHKprZ1JWlK1Fcnpx6UKeQuaOh?=
 =?us-ascii?Q?Ngq0Stkxr+L8RURGyMb+OGVr2SDqcaq1bANvWFO5GybrM8/XbzOb9FgncTdr?=
 =?us-ascii?Q?Tl7Iw5HFZuUGYFQ3Mc0KkaErbCPWlcGQuNmZHljqQLadZ3K9uQ80rnFt8S8f?=
 =?us-ascii?Q?0Ikm0YMffLFdMHI/9Oxcf9XNnA+0DHQtXXiU1/OH2VIuYPgPVVJ11A31sH6Y?=
 =?us-ascii?Q?yRBCB1eaMSaV88EpXwHRnSlNdR97+yjViKoYxn+NEGlzwXHv3iBUODHcaYe7?=
 =?us-ascii?Q?V3db+k7AEisORH9lnoHIW4nMGAkK6nkqV0Di14m47pfTHj8IU3lx+RCewUaS?=
 =?us-ascii?Q?LlRrDpcxBnyJFKRdjzM7QbSIKzasj4uBZ4n7ppdrzHk5R+54eIvRVTF21Ysw?=
 =?us-ascii?Q?8n4eCwFGa6y0zhDTRTVgyr/wDFBixcYtWmH9LELCWcAuZH8Kc3iOkZHPam3n?=
 =?us-ascii?Q?gfD+CqVHh00KFlAR1fqZHYX/erseYru9vFr6SeLazCtamNnRBjOkEl/K+H+l?=
 =?us-ascii?Q?0D4TVqMYyAcyv2pgJ3P/aFJK/mbtlhMh/dgqvPBELcv90G9SFAbrdkHCORVc?=
 =?us-ascii?Q?MFI8eUzTs9XuFWFDQUgkmYXtZvkJl9Bo+MmxVEIBKPEevXwIHr567zNquLFz?=
 =?us-ascii?Q?YT9L0LTHhLTX/CtTy3i54EJrMnIQsCtPTP0BFq0wUxp4X3gSnqhUmdKG3MX1?=
 =?us-ascii?Q?L99WHG4iDpCqUNllT1kkQyS/cSm5pnAgechVf5/gati+hV1XWFDVP430OYz1?=
 =?us-ascii?Q?ZhqLknw1r8ia2lQ9gNya5rO7sPl17NXf45OhNL4KNvvcXjcQCp7m8Y/biZsr?=
 =?us-ascii?Q?DpEZmUSQIfj3arH657SM+fFqQOpn28Jh/E8dOEp3nPj0hX5XbNgDHSXNAtKF?=
 =?us-ascii?Q?Oq//VjBnELFQiRYEof4EMO7QuOlNZm/V2p2edcnRofic1N5IqkUe8UQNn+Ss?=
 =?us-ascii?Q?YwUjegYZ0yLe/xbagWyhOMig1aK62wXstI5ozqETvz7QVVCdwSPYCT1IliZZ?=
 =?us-ascii?Q?PdJGqPabd+wocad6klgxCkuF5kXUPyA09vGtzi1okPloVraVmyIymCx3hvz4?=
 =?us-ascii?Q?K7pkOfwgVl6mLqALV3/TRfINrNozwUxgXct5t9TfklEtFAkbx8jeHZYa3XP9?=
 =?us-ascii?Q?n54GIkBE87AF9qXhsX3l/R+Dilq5BhFhJXcIBudJOnTbzQptNs80Kb4OW/ZZ?=
 =?us-ascii?Q?578ESuSdKk+pRKN8BviRaftyFvf0u/Lp2bjHb201sF/wB3Z7coxmYAiCwHFS?=
 =?us-ascii?Q?ofdqay222z49stIVTq+zo1lXA7m25TRRQ3GYOERZeb4t5lDFCbVuFDlcwTU5?=
 =?us-ascii?Q?Jz/boBs8ag=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b512107-dd97-40a5-099a-08de630e0e9b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2026 10:21:56.0911
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C8MsWHRwsBMTRuEQXvqJRX/OtZLMUpzjMJejS0DxsKjMAFJEGsjExWoQT4PsXQaj/7mKUP0BroiTmkQcauGMUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6413
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69987-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[10];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[19];
	DKIM_TRACE(0.00)[intel.com:+];
	MISSING_XM_UA(0.00)[];
	HAS_REPLYTO(0.00)[yan.y.zhao@intel.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yan.y.zhao@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:replyto,intel.com:dkim,yzhao56-desk.sh.intel.com:mid];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: E067AD78AC
X-Rspamd-Action: no action

On Wed, Jan 28, 2026 at 05:14:37PM -0800, Sean Christopherson wrote:
> Drop the dedicated .link_external_spt() for linking non-leaf S-EPT pages,
> and instead funnel everything through .set_external_spte().  Using separate
> hooks doesn't help prevent TDP MMU details from bleeding into TDX, and vice
> versa; to the contrary, dedicated callbacks will result in _more_ pollution
> when hugepage support is added, e.g. will require the TDP MMU to know
> details about the splitting rules for TDX that aren't all that relevant to
> the TDP MMU.
> 
> Ideally, KVM would provide a single pair of hooks to set S-EPT entries,
> one hook for setting SPTEs under write-lock and another for settings SPTEs
> under read-lock (e.g. to ensure the entire operation is "atomic", to allow
> for failure, etc.).  Sadly, TDX's requirement that all child S-EPT entries
> are removed before the parent makes that impractical: the TDP MMU
> deliberately prunes non-leaf SPTEs and _then_ processes its children, thus
> making it quite important for the TDP MMU to differentiate between zapping
> leaf and non-leaf S-EPT entries.
> 
> However, that's the _only_ case that's truly special, and even that case
> could be shoehorned into a single hook; it's just wouldn't be a net
> positive.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/include/asm/kvm-x86-ops.h |  1 -
>  arch/x86/include/asm/kvm_host.h    |  3 --
>  arch/x86/kvm/mmu/tdp_mmu.c         | 37 +++---------------
>  arch/x86/kvm/vmx/tdx.c             | 61 ++++++++++++++++++++----------
>  4 files changed, 48 insertions(+), 54 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
> index c18a033bee7e..57eb1f4832ae 100644
> --- a/arch/x86/include/asm/kvm-x86-ops.h
> +++ b/arch/x86/include/asm/kvm-x86-ops.h
> @@ -94,7 +94,6 @@ KVM_X86_OP_OPTIONAL_RET0(set_tss_addr)
>  KVM_X86_OP_OPTIONAL_RET0(set_identity_map_addr)
>  KVM_X86_OP_OPTIONAL_RET0(get_mt_mask)
>  KVM_X86_OP(load_mmu_pgd)
> -KVM_X86_OP_OPTIONAL_RET0(link_external_spt)
>  KVM_X86_OP_OPTIONAL_RET0(set_external_spte)
>  KVM_X86_OP_OPTIONAL_RET0(free_external_spt)
>  KVM_X86_OP_OPTIONAL(remove_external_spte)
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index e441f270f354..d12ca0f8a348 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1853,9 +1853,6 @@ struct kvm_x86_ops {
>  	void (*load_mmu_pgd)(struct kvm_vcpu *vcpu, hpa_t root_hpa,
>  			     int root_level);
>  
> -	/* Update external mapping with page table link. */
> -	int (*link_external_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
> -				void *external_spt);
>  	/* Update the external page table from spte getting set. */
>  	int (*set_external_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
>  				 u64 mirror_spte);
> diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
> index 0feda295859a..56ad056e6042 100644
> --- a/arch/x86/kvm/mmu/tdp_mmu.c
> +++ b/arch/x86/kvm/mmu/tdp_mmu.c
> @@ -495,31 +495,17 @@ static void handle_removed_pt(struct kvm *kvm, tdp_ptep_t pt, bool shared)
>  	call_rcu(&sp->rcu_head, tdp_mmu_free_sp_rcu_callback);
>  }
>  
> -static void *get_external_spt(gfn_t gfn, u64 new_spte, int level)
> -{
> -	if (is_shadow_present_pte(new_spte) && !is_last_spte(new_spte, level)) {
> -		struct kvm_mmu_page *sp = spte_to_child_sp(new_spte);
> -
> -		WARN_ON_ONCE(sp->role.level + 1 != level);
> -		WARN_ON_ONCE(sp->gfn != gfn);
> -		return sp->external_spt;
> -	}
> -
> -	return NULL;
> -}
> -
>  static int __must_check set_external_spte_present(struct kvm *kvm, tdp_ptep_t sptep,
>  						 gfn_t gfn, u64 *old_spte,
>  						 u64 new_spte, int level)
>  {
> -	bool was_present = is_shadow_present_pte(*old_spte);
> -	bool is_present = is_shadow_present_pte(new_spte);
> -	bool is_leaf = is_present && is_last_spte(new_spte, level);
> -	int ret = 0;
> -
> -	KVM_BUG_ON(was_present, kvm);
> +	int ret;
>  
>  	lockdep_assert_held(&kvm->mmu_lock);
> +
> +	if (KVM_BUG_ON(is_shadow_present_pte(*old_spte), kvm))
> +		return -EIO;
Why not move this check of is_shadow_present_pte() to tdx_sept_set_private_spte()
as well? 

Or also check !is_shadow_present_pte(new_spte) in TDP MMU?

  	
>  	 * We need to lock out other updates to the SPTE until the external
>  	 * page table has been modified. Use FROZEN_SPTE similar to
> @@ -528,18 +514,7 @@ static int __must_check set_external_spte_present(struct kvm *kvm, tdp_ptep_t sp
>  	if (!try_cmpxchg64(rcu_dereference(sptep), old_spte, FROZEN_SPTE))
>  		return -EBUSY;
>  
> -	/*
> -	 * Use different call to either set up middle level
> -	 * external page table, or leaf.
> -	 */
> -	if (is_leaf) {
> -		ret = kvm_x86_call(set_external_spte)(kvm, gfn, level, new_spte);
> -	} else {
> -		void *external_spt = get_external_spt(gfn, new_spte, level);
> -
> -		KVM_BUG_ON(!external_spt, kvm);
> -		ret = kvm_x86_call(link_external_spt)(kvm, gfn, level, external_spt);
> -	}
> +	ret = kvm_x86_call(set_external_spte)(kvm, gfn, level, new_spte);
>  	if (ret)
>  		__kvm_tdp_mmu_write_spte(sptep, *old_spte);
>  	else
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 5688c77616e3..30494f9ceb31 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1664,18 +1664,58 @@ static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
>  	return 0;
>  }
>  
> +static struct page *tdx_spte_to_external_spt(struct kvm *kvm, gfn_t gfn,
> +					     u64 new_spte, enum pg_level level)
> +{
> +	struct kvm_mmu_page *sp = spte_to_child_sp(new_spte);
> +
> +	if (KVM_BUG_ON(!sp->external_spt, kvm) ||
> +	    KVM_BUG_ON(sp->role.level + 1 != level, kvm) ||
> +	    KVM_BUG_ON(sp->gfn != gfn, kvm))
> +		return NULL;
Could we remove the KVM_BUG_ON()s, and ...

> +	return virt_to_page(sp->external_spt);
> +}
> +
> +static int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
> +				     enum pg_level level, u64 mirror_spte)
> +{
> +	gpa_t gpa = gfn_to_gpa(gfn);
> +	u64 err, entry, level_state;
> +	struct page *external_spt;
> +
> +	external_spt = tdx_spte_to_external_spt(kvm, gfn, mirror_spte, level);
> +	if (!external_spt)
add a KVM_BUG_ON() here?
It could save KVM_BUG_ON()s and have KVM_BUG_ON() match -EIO :)

And as Rick also mentioned, better to remove external in external_spt, e.g.
something like pt_page.

And mirror_spte --> new_spte?

> +		return -EIO;
> +
> +	err = tdh_mem_sept_add(&to_kvm_tdx(kvm)->td, gpa, level, external_spt,
> +			       &entry, &level_state);
> +	if (unlikely(tdx_operand_busy(err)))
> +		return -EBUSY;
> +
> +	if (TDX_BUG_ON_2(err, TDH_MEM_SEPT_ADD, entry, level_state, kvm))
> +		return -EIO;
> +
> +	return 0;
> +}
> +
>  static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
>  				     enum pg_level level, u64 mirror_spte)
>  {
>  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
>  	kvm_pfn_t pfn = spte_to_pfn(mirror_spte);
>  
> +	if (KVM_BUG_ON(!is_shadow_present_pte(mirror_spte), kvm))
> +		return -EIO;
> +
> +	if (!is_last_spte(mirror_spte, level))
> +		return tdx_sept_link_private_spt(kvm, gfn, level, mirror_spte);
> +
>  	/* TODO: handle large pages. */
>  	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
>  		return -EIO;
>  
> -	WARN_ON_ONCE(!is_shadow_present_pte(mirror_spte) ||
> -		     (mirror_spte & VMX_EPT_RWX_MASK) != VMX_EPT_RWX_MASK);
> +	WARN_ON_ONCE((mirror_spte & VMX_EPT_RWX_MASK) != VMX_EPT_RWX_MASK);
Also check this for tdx_sept_link_private_spt()?

  
>  	/*
>  	 * Ensure pre_fault_allowed is read by kvm_arch_vcpu_pre_fault_memory()
> @@ -1695,23 +1735,7 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
>  	return tdx_mem_page_aug(kvm, gfn, level, pfn);
>  }
>  
> -static int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
> -				     enum pg_level level, void *private_spt)
> -{
> -	gpa_t gpa = gfn_to_gpa(gfn);
> -	struct page *page = virt_to_page(private_spt);
> -	u64 err, entry, level_state;
>  
> -	err = tdh_mem_sept_add(&to_kvm_tdx(kvm)->td, gpa, level, page, &entry,
> -			       &level_state);
> -	if (unlikely(tdx_operand_busy(err)))
> -		return -EBUSY;
> -
> -	if (TDX_BUG_ON_2(err, TDH_MEM_SEPT_ADD, entry, level_state, kvm))
> -		return -EIO;
> -
> -	return 0;
> -}
>  
>  /*
>   * Ensure shared and private EPTs to be flushed on all vCPUs.
> @@ -3592,7 +3616,6 @@ void __init tdx_hardware_setup(void)
>  	 */
>  	vt_x86_ops.vm_size = max_t(unsigned int, vt_x86_ops.vm_size, sizeof(struct kvm_tdx));
>  
> -	vt_x86_ops.link_external_spt = tdx_sept_link_private_spt;
>  	vt_x86_ops.set_external_spte = tdx_sept_set_private_spte;
>  	vt_x86_ops.free_external_spt = tdx_sept_free_private_spt;
>  	vt_x86_ops.remove_external_spte = tdx_sept_remove_private_spte;
> -- 
> 2.53.0.rc1.217.geba53bf80e-goog
> 

