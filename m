Return-Path: <kvm+bounces-52269-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EF127B0376A
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 08:53:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 14942189B92B
	for <lists+kvm@lfdr.de>; Mon, 14 Jul 2025 06:53:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B88B229B36;
	Mon, 14 Jul 2025 06:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iyccYiWn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7B87E0E8;
	Mon, 14 Jul 2025 06:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752475986; cv=fail; b=jwy79cNPLlSh0sQNv1AKfDA1ngmnyan6SGHeKo0jLijcmWupc9exTHCVq7lLpg6JgJ4DFiIoZtVVC7HIsn4aWtlCzHPwBJrv87OVa5PJcvPOcAfha1+6Fl/+GmWTX/A9tVTksHrKIboaQgUeT7+28Y8gwYEFXl72hmPslnU97sk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752475986; c=relaxed/simple;
	bh=ALkqaaE2gqMQINyu+vJLMYGsDx8rkmC+GXkpEl0KYFQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=YxVrp9injWkyRXfpJZLLAbc7bDUuDFXuDgTa8DTXpcrKW1flXKTmpSnfmJjOG12Uzh3nU8n6SvTWgtLzHqoxjS5PrG7Iuap+uMvda+VLS79KTEYYr8Lb+AENg/nnedF3K3+KualHeCW78jZL5fJDf6W939ae6CE17AR0zlh+FUs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iyccYiWn; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752475985; x=1784011985;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=ALkqaaE2gqMQINyu+vJLMYGsDx8rkmC+GXkpEl0KYFQ=;
  b=iyccYiWnL/62FACuSV1p7Yl9n4oyz+1jMJAcTGdjYIcs6K6K4ttnOYG+
   RRBAPmsGTB+hD82lEvUPvAjfxkQP92prSt/sA003k0yTF7uxJM2Em3it8
   6QW4BKzXFVd57Uqm6dj5BGAUgRrA9HZNHcIgYVRiI6IIM5xUe0gomG0un
   1wrnh7zavhW1tlB9olGmzkqovE4Ft9A+mvKHrvtGgae+LgdpPg8+PrdIL
   AmDhua1lqaW2KeiJNs8R/u7e6ubfTqfU53Yx+LisLRt40fMNxULq9S/+O
   Yu+Nco5e07NhGngarId0PvT0wZRG/cjGCAOhfQXdVKLMJMcsMc715mALD
   w==;
X-CSE-ConnectionGUID: 8SykRz8DQmGJvMxaEY3rKw==
X-CSE-MsgGUID: djOfprM4Q5uZ6G5jQHsD/Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="64919467"
X-IronPort-AV: E=Sophos;i="6.16,310,1744095600"; 
   d="scan'208";a="64919467"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2025 23:53:04 -0700
X-CSE-ConnectionGUID: x0W3UoxNQP2p2UesLxIbaw==
X-CSE-MsgGUID: DMLFULsSRK+K7jWcmmiXMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,310,1744095600"; 
   d="scan'208";a="160875891"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jul 2025 23:53:03 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 13 Jul 2025 23:53:02 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Sun, 13 Jul 2025 23:53:02 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (40.107.220.50)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Sun, 13 Jul 2025 23:53:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pxFlU4sodYxHijDYthos8xU0xQx3jd/Z5iIOe2obNDwPosBlTQTXrXbB2rIKSiQKO3ySYdHJooD3E1F1ozBztBJgcC0NlobFcx8JPT6p5juDAufmFBhh6GQkP7h9qRt2GtrkIQtYcXdZqgUVAKzI9Xt0vEE0pVcL3qckCPN4OKj9i4MiWv+rCrhRskYyjXddMLjzSuJYbTbau2slXOQIwoI4mxG1Mdg2teLbsWCm46O2I4Om6iCksSSZYAgwHIoqetUfy589rJNHOlSs+XSaMi4hFHMzAUIYO5VJMUqPW6y+fHEmcfzVmvfrcqtTpSp0IB1RhtEVAYUo8duDahUR0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=STcljaRcjv4clQeBPHmompy3QVbO3StiXKSaD8rxaVg=;
 b=m/z/HNwhtfnf7oMHTQvIK2F70kexiZQncFrJoBPajP/Vq1JS7/oAYhMMM5SnRILDWkyuckTofWz3h9SFFJXoTV8ddkG3FRgyN3U+2yeZTVwcNByT3PaAlbyHCbfTM3ItZ5jWWF6tFJoyH7rXBfWtAkqDSQGF6AVOhP5c38ykaayPmHjWTLGB3fzE/T2I1GBAVogs2t1Lxkm+FmRg1H8e8fcYjLpKhCGtYgjKcX93xHz7pCGZ+GMMsvJejr8ij+GuKhtw0pflg3MvjQ76CYRj67i8qTa6hbKMPodDjgpEoy2wOftb+PINp0p2UJ9Bfd599bu3WasGSgqUDL8aLROxlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 PH7PR11MB8569.namprd11.prod.outlook.com (2603:10b6:510:304::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.25; Mon, 14 Jul
 2025 06:52:30 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8922.028; Mon, 14 Jul 2025
 06:52:30 +0000
Date: Mon, 14 Jul 2025 14:15:16 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Michael Roth <michael.roth@amd.com>, <pbonzini@redhat.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <kai.huang@intel.com>,
	<adrian.hunter@intel.com>, <reinette.chatre@intel.com>,
	<xiaoyao.li@intel.com>, <tony.lindgren@intel.com>,
	<binbin.wu@linux.intel.com>, <dmatlack@google.com>,
	<isaku.yamahata@intel.com>, <ira.weiny@intel.com>, <vannapurve@google.com>,
	<david@redhat.com>, <ackerleytng@google.com>, <tabba@google.com>,
	<chao.p.peng@intel.com>
Subject: Re: [RFC PATCH] KVM: TDX: Decouple TDX init mem region from
 kvm_gmem_populate()
Message-ID: <aHSgdEJpY/JF+a1f@yzhao56-desk>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250703062641.3247-1-yan.y.zhao@intel.com>
 <20250709232103.zwmufocd3l7sqk7y@amd.com>
 <aG_pLUlHdYIZ2luh@google.com>
 <aHCUyKJ4I4BQnfFP@yzhao56-desk>
 <20250711151719.goee7eqti4xyhsqr@amd.com>
 <aHEwT4X0RcfZzHlt@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <aHEwT4X0RcfZzHlt@google.com>
X-ClientProxiedBy: SI2PR01CA0020.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::6) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|PH7PR11MB8569:EE_
X-MS-Office365-Filtering-Correlation-Id: 05530ff4-9c6a-4f6d-4662-08ddc2a30029
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?P6TIqZN3AMjVdhotmqFYD1UwdzXsMfZ4ikRWRAq735361wzI4SMG+RhMm21G?=
 =?us-ascii?Q?M66V05Eqm9c/73/yp1jtAwVjQ2Qma0+ANsjLXWhARk/X4qMeVeL4Fg4Aqyg+?=
 =?us-ascii?Q?txRrQxnXG+JC/viSHhYtfqQoWzJ8GvwThwv00fSooyvPrOK4PvIvcETD2fgI?=
 =?us-ascii?Q?nsaxY+cSp/8euIONpyqarHN551eSIahylXwQkFcrpQo0U/o23Kw3TvSn0867?=
 =?us-ascii?Q?CLEm49Hjd75kRwet8/nlNhPC5vlyMDYfixbb13TXHTxJeI/KBCymctt3dkrz?=
 =?us-ascii?Q?fY9nVp1ZtTsRl6mFx31gKRq5ud/DrxnoISjT5UKjsTdXYIotdiIAc6LOu/99?=
 =?us-ascii?Q?hTWUdFkK4BtxpH3gU995ekkytk0VGNYU9PTAMxfGIbs+AyrHMyglOGjS0gie?=
 =?us-ascii?Q?S6H1t5ORut6QRX9KNV3HPLrfyVgQmVSvQJfVZax4lJRcXOChOPrhwhKRLVZF?=
 =?us-ascii?Q?UGJXX/wJJJWw7u/w8ul2SyZTgI5XYJKONE66XOhHuFSpRNfV27R28DUp+BTc?=
 =?us-ascii?Q?0sDRNIWTt0O+5N0X2OtOr3mrq8Ek/EPIwSf+Rjg3qzSvuCkDXxc+U5p6tZKv?=
 =?us-ascii?Q?6HecND5AoeeQ6GaBb3RD4USZnwyLs+HyrTN4o9ozKHo94fO85yxj+B3TP4+j?=
 =?us-ascii?Q?mcW5Wmd6fnEAyoXg2dhwPsH+KmvYMfDwbOLON6fZMAksd875DeMxA3Ob+tzI?=
 =?us-ascii?Q?rICzSVp8ntB/3bhw488qu6Q6gZY0Yhlhm35swW8w/mPIDWVEJ7Zf5YF4eva3?=
 =?us-ascii?Q?w1nZrAVvvHHMA18tESdmKh1YDJOqtFjMxjTuWdlQGqrtyZLBdG/OPnM2/brk?=
 =?us-ascii?Q?p4c/LPzdlw1ZnFOLTXDR+VULs3eG/R624TiNPh1a7uh32gY3YpHDesXXAipF?=
 =?us-ascii?Q?BhrxdO7LWn7zhS8w4UlZ98g1ZOJGIDRVplNRDZCgoZRPSeqQsQ1mzxt9815l?=
 =?us-ascii?Q?VBk41KPzNtwBVM9VOyLj9lSddRLbLQH+VnAErZrOOCMvMKsaJQPYlYt3oN2v?=
 =?us-ascii?Q?lFSQlEYv2IrRh1LuV7XN2a9eoI9T/lgALA03MtZKY49xFoPvbLrSmYiny0N1?=
 =?us-ascii?Q?oVe8TvSlHxsKcj6vEQgFab7isE7PfPkdsJB6V/6ntxvOrfLwr3zFvthXF/xn?=
 =?us-ascii?Q?tUH7VjDdBSEbghLeO/MHsTJA6w7lSOq83cvVZ8oMK8i6JeMiykuO8vRMgXkN?=
 =?us-ascii?Q?GLRsbyJvMQt6O2KLIij9fVvkyOZ35/pUHAMB6GM81n+ruGxOPfZElDaVUQJk?=
 =?us-ascii?Q?hrlLyS+gmITq08oTiG6GaVDrVN6g/wz/6PztWS6IB49/OczjN1fMRR5xct42?=
 =?us-ascii?Q?r3Vl4k/vZDJjR2/3GKgn3lMXn60LkB7kDRKgJFAUACiwVKg3qXEH2yy/7T5u?=
 =?us-ascii?Q?h1znguzgU2lD6yenbKfTJCtX2tsrSQN/W56bZY98ouuSE11n6d3KFRFE1Nn9?=
 =?us-ascii?Q?N/OQU1DRBKA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tJcw7UvJDFaZ0ZgvSo/Cm4CmdR0a7rdVlbJylOWonAsdFwr3OFozr0Ttz1Yv?=
 =?us-ascii?Q?3FfJ7xkRbAoLulRZqn3YDrkarOyGDomQShFwjIZmPHUHWsF4wQBvQz2Q0pRv?=
 =?us-ascii?Q?YYnpK7h2+zkstgS6Tw2B9z3FKNE/Sp/5h2PnQLJtb1k017z16xIKITpnaX3H?=
 =?us-ascii?Q?AvdeVnfZrq0V6W5gluxtqiIjYh8kCZPKcd7rSOZlsafLhm4T0I9rNAOwQNv2?=
 =?us-ascii?Q?aYUl3EeBbMMkM4dbEGma/Wg4LUIHzojcTfBnmf34dUVuR9aZjwip8SLH1bSk?=
 =?us-ascii?Q?KSLZ665bnFZHYzZ+JXDMsVsVIFgcIK1I6ECUhYXLgfXct2Wh5cY/BudR9l9t?=
 =?us-ascii?Q?cKweQ7XTns/s4mo8fOTSHbaPUHyn6M5Vot5L7ujA5i2Bc6Jfc34NcotPz1Dk?=
 =?us-ascii?Q?oISmsy2wGOCkI/+Ja6AxfPjD7XDa0nBXGbzvVRjgOdj2Qg5T5aYXlb8qhI6U?=
 =?us-ascii?Q?yg9WrwertjF6DFtIHJOY0D6HXh/iBbP5xtTaci830Yl5L9zD2q7EHLDPyaqo?=
 =?us-ascii?Q?uB5n6G07XwwrgnMLuRz2Sq/rCxAptERYnC+E4Vf5zmvkhtfiLsJDGVqy8EFm?=
 =?us-ascii?Q?gZowh78KK8mbfPlPyHnVGRIAGUiQIgGEHa2fpdf5joZ2erZTVDkaMYiDCR1q?=
 =?us-ascii?Q?4GFNqvvTXblHpPFu/nv4ylTv2iyZ2L+PhllahSJCBvSqReG+jaDU4I+FGbXq?=
 =?us-ascii?Q?9BBBeWhKREgrz3jE3GdjitXGs9JPy8dquulYC/QDyjxWlLwttxfKSP8sWII3?=
 =?us-ascii?Q?W88iD1UpJqdw3xmtkDcQeii4tm/oQqQnZ3hVjnW8RiEjY6yrO68TQyZiGVAs?=
 =?us-ascii?Q?aWMcgJj+oceCbmf2sDPrvufObK3pgooNrz6cJxjoTd4vBXmoRR+LyvyWtwke?=
 =?us-ascii?Q?P1d9s5yaTLpR3reVNjwey6DhmSnuxUVVcBAVIKV7CjVvYAReVxw3Eyg7Uqvw?=
 =?us-ascii?Q?shA034uMDoI5dmL5CwlWxfvDqlw67e+bFaMjhAxqFm5NhrNQ406Q9MySNSYE?=
 =?us-ascii?Q?ekXrLiu0v6IvjuySASPuaxs7tyugfHSuJ2Nv1fAFM462qb76JQVoDTjoYMuJ?=
 =?us-ascii?Q?y7GrtszATCxjpkJ1e7UffnYKgxIwVc+WYUZY3ILYXJiBSUPbB1Mx3o7fKWvp?=
 =?us-ascii?Q?ro6iwU1IG0jwg8HM/0bbzwZZdD3nzRQZ8lNR+TKHUYKvJv2+JgaVXIJ50Gkz?=
 =?us-ascii?Q?HonKAU44Cf+qO35SVKJ/uOb2YwjwbHW+TyzzBVUfnjJqVyhX2qGWkzmi25UD?=
 =?us-ascii?Q?dB4JyjTahB6kIeLC8T+dXWpo/sjHR8EHux92wZoYtrZldRNVw+fDFUu2W24w?=
 =?us-ascii?Q?mDagAzftUz/mS81A/Dog56Uy1nzueohnDP+RD2eOZPbhMyh3kJ3PO+WnHvvc?=
 =?us-ascii?Q?1/tcWPfqi6I50W+QMdwSG8sl0S8j++Q76IkjWtH8ptzu0oGV+iGRgaHs2Y8G?=
 =?us-ascii?Q?STXEiGvGrPN4X1+JhbsxU1C18L5OvU9OFT1X/BlR2VZAo4wt+7v6xlsfi47y?=
 =?us-ascii?Q?G81uyT6Hk6oD/v7PrLdj+pNNFlRE3h1uYbpJ+RnOMdFwt8QT9MxE9j7MWPDf?=
 =?us-ascii?Q?+3Mwe6UGeBVK6qdDn0VxPKhHRyBFoEKYGyUeMixn?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 05530ff4-9c6a-4f6d-4662-08ddc2a30029
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2025 06:52:29.7437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sqKjaJN5W2eNznv7pMtm+H9w+oD7CvrOX/SnSP0BKeE1fvr2Xzj+CgYiQJbXvnW78+SYCsgY5FTBEzjdBQkkUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8569
X-OriginatorOrg: intel.com

On Fri, Jul 11, 2025 at 08:39:59AM -0700, Sean Christopherson wrote:
> On Fri, Jul 11, 2025, Michael Roth wrote:
> > On Fri, Jul 11, 2025 at 12:36:24PM +0800, Yan Zhao wrote:
> > > Besides, it can't address the 2nd AB-BA lock issue as mentioned in the patch
> > > log:
> > > 
> > > Problem
> > > ===
> > > ...
> > > (2)
> > > Moreover, in step 2, get_user_pages_fast() may acquire mm->mmap_lock,
> > > resulting in the following lock sequence in tdx_vcpu_init_mem_region():
> > > - filemap invalidation lock --> mm->mmap_lock
> > > 
> > > However, in future code, the shared filemap invalidation lock will be held
> > > in kvm_gmem_fault_shared() (see [6]), leading to the lock sequence:
> > > - mm->mmap_lock --> filemap invalidation lock
> > 
> > I wouldn't expect kvm_gmem_fault_shared() to trigger for the
> > KVM_MEMSLOT_SUPPORTS_GMEM_SHARED case (or whatever we end up naming it).
> 
> Irrespective of shared faults, I think the API could do with a bit of cleanup
> now that TDX has landed, i.e. now that we can see a bit more of the picture.
> 
> As is, I'm pretty sure TDX is broken with respect to hugepage support, because
> kvm_gmem_populate() marks an entire folio as prepared, but TDX only ever deals
> with one page at a time.  So that needs to be changed.  I assume it's already
In TDX RFC v1, we deals with multiple pages at a time :)
https://lore.kernel.org/all/20250424030500.32720-1-yan.y.zhao@intel.com/

> address in one of the many upcoming series, but it still shows a flaw in the API.
> 
> Hoisting the retrieval of the source page outside of filemap_invalidate_lock()
> seems pretty straightforward, and would provide consistent ABI for all vendor
> flavors.  E.g. as is, non-struct-page memory will work for SNP, but not TDX.  The
> obvious downside is that struct-page becomes a requirement for SNP, but that
> 
> The below could be tweaked to batch get_user_pages() into an array of pointers,
> but given that both SNP and TDX can only operate on one 4KiB page at a time, and
> that hugepage support doesn't yet exist, trying to super optimize the hugepage
> case straightaway doesn't seem like a pressing concern.

> static long __kvm_gmem_populate(struct kvm *kvm, struct kvm_memory_slot *slot,
> 				struct file *file, gfn_t gfn, void __user *src,
> 				kvm_gmem_populate_cb post_populate, void *opaque)
> {
> 	pgoff_t index = kvm_gmem_get_index(slot, gfn);
> 	struct page *src_page = NULL;
> 	bool is_prepared = false;
> 	struct folio *folio;
> 	int ret, max_order;
> 	kvm_pfn_t pfn;
> 
> 	if (src) {
> 		ret = get_user_pages((unsigned long)src, 1, 0, &src_page);
get_user_pages_fast()?

get_user_pages() can't pass the assertion of mmap_assert_locked().

> 		if (ret < 0)
> 			return ret;
> 		if (ret != 1)
> 			return -ENOMEM;
> 	}
> 
> 	filemap_invalidate_lock(file->f_mapping);
> 
> 	if (!kvm_range_has_memory_attributes(kvm, gfn, gfn + 1,
> 					     KVM_MEMORY_ATTRIBUTE_PRIVATE,
> 					     KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
if (kvm_mem_is_private(kvm, gfn)) ? where

static inline bool kvm_mem_is_private(struct kvm *kvm, gfn_t gfn)
{
        struct kvm_memory_slot *slot;

        if (!IS_ENABLED(CONFIG_KVM_GMEM))
                return false;

        slot = gfn_to_memslot(kvm, gfn);
        if (kvm_slot_has_gmem(slot) && kvm_gmem_memslot_supports_shared(slot))
                return kvm_gmem_is_private(slot, gfn);

        return kvm_get_memory_attributes(kvm, gfn) & KVM_MEMORY_ATTRIBUTE_PRIVATE;
}


> 		ret = -EINVAL;
> 		goto out_unlock;
> 	}
> 
> 	folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &is_prepared, &max_order);
If max_order > 0 is returned, the next invocation of __kvm_gmem_populate() for
GFN+1 will return is_prepared == true.

> 	if (IS_ERR(folio)) {
> 		ret = PTR_ERR(folio);
> 		goto out_unlock;
> 	}
> 
> 	folio_unlock(folio);
> 
> 	if (is_prepared) {
> 		ret = -EEXIST;
> 		goto out_put_folio;
> 	}
So, skip this check of is_prepare?

> 
> 	ret = post_populate(kvm, gfn, pfn, src_page, opaque);
Pass in the slot to post_populate() as well?

TDX may need to invoke hugepage_set_guest_inhibit(slot, gfn, PG_LEVEL_2M)
in tdx_gmem_post_populate() if kvm_tdp_mmu_map_private_pfn() does not check
the hook private_max_mapping_level for max_level as in
https://lore.kernel.org/all/aG_pLUlHdYIZ2luh@google.com.

> 	if (!ret)
> 		kvm_gmem_mark_prepared(folio);

	if (!ret && !is_prepared)
 		kvm_gmem_mark_prepared(folio);

	?

> out_put_folio:
> 	folio_put(folio);
> out_unlock:
> 	filemap_invalidate_unlock(file->f_mapping);
> 
> 	if (src_page)
> 		put_page(src_page);
> 	return ret;
> }
> 
> long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long npages,
> 		       kvm_gmem_populate_cb post_populate, void *opaque)
> {
> 	struct file *file;
> 	struct kvm_memory_slot *slot;
> 	void __user *p;
> 	int ret = 0;
> 	long i;
> 
> 	lockdep_assert_held(&kvm->slots_lock);
> 	if (npages < 0)
> 		return -EINVAL;
> 
> 	slot = gfn_to_memslot(kvm, start_gfn);
> 	if (!kvm_slot_can_be_private(slot))
> 		return -EINVAL;
> 
> 	file = kvm_gmem_get_file(slot);
> 	if (!file)
> 		return -EFAULT;
> 
> 	npages = min_t(ulong, slot->npages - (start_gfn - slot->base_gfn), npages);
> 	for (i = 0; i < npages; i ++) {
> 		if (signal_pending(current)) {
> 			ret = -EINTR;
> 			break;
> 		}
> 
> 		p = src ? src + i * PAGE_SIZE : NULL;
> 
> 		ret = __kvm_gmem_populate(kvm, slot, file, start_gfn + i, p,
> 					  post_populate, opaque);
> 		if (ret)
> 			break;
> 	}
> 
> 	fput(file);
> 	return ret && !i ? ret : i;
> }

