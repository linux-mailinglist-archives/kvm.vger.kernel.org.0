Return-Path: <kvm+bounces-46783-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B2E42AB98D6
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 11:30:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2AC957AB89F
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 09:29:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E0D41A01B9;
	Fri, 16 May 2025 09:30:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MU3MjsJa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0FED1922FA;
	Fri, 16 May 2025 09:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747387841; cv=fail; b=ra+ky4j8A5ZJ91EIbY1jGv+6yASOVaCK2krAHBucA+Ohau3Eh95DzDGVTUOl0T56X6G29vLGxqip+fsOQfffvzvH7nQfnvkAbBeIXAKkoNfBkPggQmcUy+BBdXShgzp9JDhteOOVw1Le+zunFeoAj3df84CnL0sQSdIBOh2j90g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747387841; c=relaxed/simple;
	bh=eiAtgxOr+STImoHIOWpdbTUumKRu3rZpScrKMjeUMkI=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=AqXzFHswgoIrcVLU7xUmnRtdu70IpDxD1ibusWLb7Np+Ji/zZFreeoHN68yJeBaG/Y+ZhX6pI3Q/Kk4WAimJEbdl8dF+KfdlM58TJFMEUBBzUf54aF08zjX5BBTaFiUO1KllAY1LkF9WrJ9za0/mKpX6KLuyHut/rS33tOvdd6k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MU3MjsJa; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747387840; x=1778923840;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=eiAtgxOr+STImoHIOWpdbTUumKRu3rZpScrKMjeUMkI=;
  b=MU3MjsJaIN1b8ojNb59Ol73QcVEungSTo/4F87DutylMzyZZZ9Vqs/vX
   8Xy0WgUSPAYP+c7Do8KPntj4DQnQoUX6PS7KzCVsE0c3YTwbCT+pm441o
   /jVBoLaQ2QYX69hzxmhzVOLmImoVnF05e/OocFoU3/hFU3wbylaRE84Ni
   0PNQc5jBdEyB1aZO8MvXebpBR4MviP2OgTVU0kStYxhs+Z/j4p/yev0D0
   QFLnNFpPM5UkmBsjjMIfsTnXBpTyQXfnpY8ZoU3pLeLd0BHlIesz3w2vT
   lZjZNbuk1S+KNbFq9mZx7oiVTioqGrAxv5TbxwPulHgNccDeMN4bs5XMZ
   A==;
X-CSE-ConnectionGUID: 1pT0TH1RSA6pf2zbQIdHzw==
X-CSE-MsgGUID: n1YNuJiNQPesb7JRo6B9jg==
X-IronPort-AV: E=McAfee;i="6700,10204,11434"; a="49337998"
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="49337998"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 02:30:39 -0700
X-CSE-ConnectionGUID: y5ENxcxjQBObrm1xqSopZg==
X-CSE-MsgGUID: j9qKd3yhTyWIqet5vd81WA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,293,1739865600"; 
   d="scan'208";a="139184926"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 02:30:39 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 16 May 2025 02:30:38 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 16 May 2025 02:30:38 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 16 May 2025 02:30:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ojqAiwNpmduEDNBLbJOCEDZ11LeE9uQIRdwkPayLTtD96ELCrwo/bRpTB5kQIyBfBff6JMupR11Uhu5flTFWfnc3GO5CVKsVWzymBOdkjljr5Fbzk91Y8jOLonhcv6mhTx0ZXy9JjEtf7kUGOvWldK8ZfLuO5VI/w8BFVtZIYKL0EZru+mTPq/W0U2YJ3HnQlrVp4lFWqz+q5TjF+sLtEneezwElOkbWJNwzuw3n+xetZdBk/qroDa97mIq7CCqB4d29hykVDb7a1oTJJzBChQscYCYjjS17Y82b8GWA09RgbEAjYV0y+/7fU9X9kKaFhk6wgif2J6JNDdQmMCHjaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cYRZM4+Eo20I9hF5/lGkCYbb3VCSdT8rAqf4nFH+J1I=;
 b=b4lBHpGve3qfL4bFZ8DqTwDzvRO4FH38lqsV1r+Ssa3qf8ra9h/75lbcJ902SKJFA/kLo/gvZGYK6zdgsG++QE8ukRj+a7Qt5WkwhpIiurS/JOr9Sagfo/1eA1svbyfnngwdUdmh6mxx4rYyjOkddNcC7D5BXUiL7Dc2vb75iKOCs2RVZLLcHWGnoTgljeVUJGNv2P7nhM1fHfsf3K35Sw6qcWC9FTOarP7NsNB0is5UxWlJfNXhqkZ1nk9xm1tTy6nyaYjed0OHYs5ozLjuBi6kj8o0phDYVkh3u99DZiFI6yFQr0QCJCLDu1JmH6KJU9rvh3HOaqwBW2xrXfABrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 BY1PR11MB7982.namprd11.prod.outlook.com (2603:10b6:a03:530::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.32; Fri, 16 May
 2025 09:30:31 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%6]) with mapi id 15.20.8722.031; Fri, 16 May 2025
 09:30:30 +0000
Date: Fri, 16 May 2025 17:28:21 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen,
 Dave" <dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "Weiny, Ira" <ira.weiny@intel.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "jroedel@suse.de"
	<jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com"
	<pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Message-ID: <aCcFNWiX7qFzTLF+@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
 <20250424030618.352-1-yan.y.zhao@intel.com>
 <dc20a7338f615d34966757321a27de10ddcbeae6.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <dc20a7338f615d34966757321a27de10ddcbeae6.camel@intel.com>
X-ClientProxiedBy: SI2P153CA0004.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::23) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|BY1PR11MB7982:EE_
X-MS-Office365-Filtering-Correlation-Id: 8afae64c-2cbd-4b4d-db1e-08dd945c4cfb
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?M8/8SrSDO818t+v/y2FEmPrDnaUNmKMg/1tRQwSVWZp5Pdh7ZdkeFwhGf0fA?=
 =?us-ascii?Q?kuViWfTDtUtaAjvO22Vf11RY36Iu82ZkTfDDB2hekov9W60eE0MA4tW5k53L?=
 =?us-ascii?Q?PUwJdknLNQYm+e5bvlSu+2/bacRraBYknqWNomCkqaHBlR/dgYX4oERm4ZIk?=
 =?us-ascii?Q?/2Jl4tG6FU2fGuYIWRkXcj0W6f56g2eYQ/QM59PNCxsej4abz45qZhSc3QLT?=
 =?us-ascii?Q?fueEcLo3zN99TCii6G61M3hnSijqdXlHhNFcO1I0jx1VXkeTl57alsY4094n?=
 =?us-ascii?Q?a9d6AGA+STj2DnijExtphzLZRzlfC0YKwNx58cBMkLzkoWZlmhCK5kNzGwJQ?=
 =?us-ascii?Q?t7XE1lfX3USz21nk4jzAWszFldncEi42SM7PXMMBQlgYduUrFZ22qngzQyxB?=
 =?us-ascii?Q?RLKrOKYoOzYmDmIGmN0lUfCCRhz93d52X5SYhwow3/OYZg/4Sn2axrHO8XFP?=
 =?us-ascii?Q?5Lb0ypqb4Z0+SbN5z8iQ8o/pqa7dqX+Lo9TZAl+fcgFKKvg8gHiLeCIV4hRU?=
 =?us-ascii?Q?kwNMd+kslUvl2BVNOprG+Q+8FAi5IXsSHDFZfJu6L2G/P88c13ygMw74BeJT?=
 =?us-ascii?Q?57KXF8RoPp+UUbtUPkGDGQO+0zOtECfsZB2Rav4P5PrShkPgM2BBJHv+YNvM?=
 =?us-ascii?Q?rbW6ZcacL5IywQu2qch2Vf0OOPXhJrg6N6X3vedKWj2pzgatnBMAM2QC9bOX?=
 =?us-ascii?Q?A7AMhd7jj3UA9aeEZRdIADJcZDGbJYa6n98OiZ7byIUraPAkiwVqxffL1REC?=
 =?us-ascii?Q?ieTUALdOjEeiQTky0s5PfNikTQvOL0yoA3Ha14azmF5qGyTppp7ogZ3iuGvj?=
 =?us-ascii?Q?JG+oYRTpkaCotSlYT58WKL0rhrVOTR8HFE5qqRCS/d2/hCMyTr8rzvxIIyFJ?=
 =?us-ascii?Q?xZcyADbTeaSD///k0HppsN5vYYyuFae6NKE/RDN8TxcbqbhCRh/v00fAQ7Wh?=
 =?us-ascii?Q?1IxyepROUV8d/UvQZ+HXmRKNA30PKG5A7pWbqBtF0FeAC7ZBn6KrglLvSaLC?=
 =?us-ascii?Q?BDpoVjMPmvaVRxm/d6xFcivvzYwB62CuQ2VDjlFzB9j6+Z19ivzQX+859Tv3?=
 =?us-ascii?Q?U643+WBRND3vKuwfC6fBfFxdk1wTYtqZHI+0Kk4+YlS/RExRdvQprQOWMJAH?=
 =?us-ascii?Q?r48dhp/sgTNElmQaKGlE0Ayr8dA6GAbvejhEZA+AOUzsGJ2ckG3nECQc2Wle?=
 =?us-ascii?Q?pj+ZgP3Rvx39zS7n28EQIpE1FHzFeYxB1sdLTejyViYrajzbs9Lfw3Xaf0Lb?=
 =?us-ascii?Q?F+ApBg/QeG+3Jzn3Y2nK6OHth0Ty+Wc+UCD1PNtUne8zNLxHBR23w1hbuAuV?=
 =?us-ascii?Q?ZtQ1zCUgScad1FvJxKEog7Ytp3eTQlppAnYRuYSnD+9qee2wfKs4l45j8J3e?=
 =?us-ascii?Q?S5tHWGNDrykCFa2ox+Uen7Dd8vWHEkwFP20FSc3NC0WTBgCDAGPwl9Jd1vb3?=
 =?us-ascii?Q?dT6opIC/LGY=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vmOoXs7iR7mBM0lwqGbFDTovL5s3ElCLli89yX/QG8t+HtlPjTdu8O4lpjft?=
 =?us-ascii?Q?NPehwclx4ouJtLipZz3zKrdt5IX2t9OS9ZH0OqdFOiSxnKnRA4MyzWZjW148?=
 =?us-ascii?Q?0jFYuvUyftzcK3/IhPo/6CoIKjs4gjAuPKX+K6wq7fRz/xw1yG8GlpKGlWAm?=
 =?us-ascii?Q?zVot6OZFgAQr7f+OA8ARtnCfgDSSlAfPLhdyeLa57xAprnACiNXm28kN8YdA?=
 =?us-ascii?Q?cZ3ipV0S5HRho8EJYtOIO5QhcpmdRO2XUWnL0s+u3Mwtf2Zw+d0oTn/M6sI4?=
 =?us-ascii?Q?RXBqBlSCFR8fffRK/JgIHSJ0l6aJYFW8ReoAn2EHPHBe+7ZVnYz0d7bbgyQi?=
 =?us-ascii?Q?DiDYgXyqWdafEZCaKKrVuUs3HjiaQA944Um5zgumM75ndCvV/Zf++mFj0IY1?=
 =?us-ascii?Q?iEDNSVDQa9BUdPDGQ1ziMcbpimfQ3mxjDt/oNe3JNe3uGVKF4Q3W4NsQydvU?=
 =?us-ascii?Q?jZvrCwH3VDtHcDtU7d641sI3WJhjD38gZmEKLiRssTiDGqU3zbRY6hKxxXaz?=
 =?us-ascii?Q?79+5GzrwWVomMIGc/MoodZVMBKXh0iuJtgA1ONwA3+1B+rAURtxPVAM6x+cP?=
 =?us-ascii?Q?IqJc65XepKZcr6AVpJPCTLeRyCsb6SBo9zXL00c0t47Lja/OTJTsb2IFxdKv?=
 =?us-ascii?Q?l15atjjmg+aQUdAGa8vgVC+XRkNx3pxOVA/+HrDNsCi5gAOGd/xCUNHHzLY/?=
 =?us-ascii?Q?nn4E9alyXRfPQmxgCGRRldG4kj9TWEoBx7K6W9dnBao81AbkzWUAio7BzcI0?=
 =?us-ascii?Q?RLkVITeqJMfvVvaFDcjWrltwSTqBpd5XdJPVTgf6xb9btmcs5kByX0EjcTXN?=
 =?us-ascii?Q?HFwnVDT7Hn/PTy4YQzgvlYHMx6AMtqkcmq5u9+76BcmdyvfarBHzPZ+0krrN?=
 =?us-ascii?Q?QWChw4Um8ITXANrxjUKDXi3R9WxqDcO13PRK+4fLOaGpQHT9qxjdwzMcC1j1?=
 =?us-ascii?Q?unZHCFUZsz45xnbZwJgiNzo7m0I0kWrq+9/fwfwtkNJENqwqwCnPrwP4b0re?=
 =?us-ascii?Q?ya2MOXKwxxJMAdsf9lGsDNCPvq/68ZXbnGptLo8DVzARC14kohE0qlQPDOrI?=
 =?us-ascii?Q?nK/rBYq+U9DhbBfr5Y0sSNub/3RqqFzEgV8GY52tOfPkx5JP7L+pVXV/iFLF?=
 =?us-ascii?Q?ORHTJNs5OvhtGMHxTBN6Uu6X00n2AIT1PAQbiEI5etATpp2jSEWrPAXzE896?=
 =?us-ascii?Q?Q6UpD2ygtZO8IQue1VMV4az+KEeP2DqwlYCCVx3cEV0abomqHGsUGwWy/eh9?=
 =?us-ascii?Q?n/+M7OpKNK5RVWgS1bVrxLRJo0GrL9HcIXUC+DEe+i3/nQHcXFLKh/xWFdr3?=
 =?us-ascii?Q?Qdg1PXQKdnBSnYA8Hp9ws4sfuVxZ3q14INhRGjyv1duEmcGej8lzo66j15EY?=
 =?us-ascii?Q?yg/UDJcP+e4hfHNO9HNC5VzKyuFFY2radoMBt0Zmk+zhQboqX5R0PRNtNoqe?=
 =?us-ascii?Q?5YyJgKdZHWMSE+H5I3g/d9cXTA1dlvjZJ6Omef2C7/iSZ+zcNNbxN+7VpmhV?=
 =?us-ascii?Q?sYlLOwsBYHQZYSnTadwhlIYZHQdiYOzwVmzrMRyy9CMWwNLfFiHF4FthEZtk?=
 =?us-ascii?Q?Hw93Jx+pKG1b58375CHty7RY/8zwfARfzVfYlD26?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8afae64c-2cbd-4b4d-db1e-08dd945c4cfb
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 May 2025 09:30:30.8288
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WxABQ4OEG8HofKAZIx4FjuQ0Y2INM6kvPVeqN2ROJ7iF0SgJxjrRZ0WdEBIgEP94kP55NXVRg8bOwBrQvncznA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY1PR11MB7982
X-OriginatorOrg: intel.com

On Wed, May 14, 2025 at 04:10:10AM +0800, Edgecombe, Rick P wrote:
> On Thu, 2025-04-24 at 11:06 +0800, Yan Zhao wrote:
> > Allow TDX's .private_max_mapping_level hook to return 2MB after the TD is
> > RUNNABLE, enabling KVM to map TDX private pages at the 2MB level. Remove
> > TODOs and adjust KVM_BUG_ON()s accordingly.
> > 
> > Note: Instead of placing this patch at the tail of the series, it's
> > positioned here to show the code changes for basic mapping of private huge
> > pages (i.e., transitioning from non-present to present).
> > 
> > However, since this patch also allows KVM to trigger the merging of small
> > entries into a huge leaf entry or the splitting of a huge leaf entry into
> > small entries, errors are expected if any of these operations are triggered
> > due to the current lack of splitting/merging support.
> > 
> > Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> > ---
> >  arch/x86/kvm/vmx/tdx.c | 16 +++++++---------
> >  1 file changed, 7 insertions(+), 9 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index e23dce59fc72..6b3a8f3e6c9c 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -1561,10 +1561,6 @@ int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
> >  	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> >  	struct page *page = pfn_to_page(pfn);
> >  
> > -	/* TODO: handle large pages. */
> > -	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
> > -		return -EINVAL;
> > -
> >  	/*
> >  	 * Because guest_memfd doesn't support page migration with
> >  	 * a_ops->migrate_folio (yet), no callback is triggered for KVM on page
> > @@ -1612,8 +1608,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
> >  	gpa_t gpa = gfn_to_gpa(gfn);
> >  	u64 err, entry, level_state;
> >  
> > -	/* TODO: handle large pages. */
> > -	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
> > +	if (KVM_BUG_ON(kvm_tdx->state != TD_STATE_RUNNABLE && level != PG_LEVEL_4K, kvm))
> 
> It's not clear why some of these warnings are here and some are in patch 4.
Patch 4 contains only changes for !TD_STATE_RUNNABLE stage.
This patch is to allow huge page after TD_STATE_RUNNABLE.
So, relaxed the condition to trigger BUG_ON in this patch, i.e.,
before this patch, always bug on level > 4K;
after this patch, only bug on level > 4K before TD is runnable.

> >  		return -EINVAL;
> >  
> >  	if (KVM_BUG_ON(!is_hkid_assigned(kvm_tdx), kvm))
> > @@ -1714,8 +1709,8 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
> >  	gpa_t gpa = gfn_to_gpa(gfn) & KVM_HPAGE_MASK(level);
> >  	u64 err, entry, level_state;
> >  
> > -	/* For now large page isn't supported yet. */
> > -	WARN_ON_ONCE(level != PG_LEVEL_4K);
> > +	/* Before TD runnable, large page is not supported */
> > +	WARN_ON_ONCE(kvm_tdx->state != TD_STATE_RUNNABLE && level != PG_LEVEL_4K);
> >  
> >  	err = tdh_mem_range_block(&kvm_tdx->td, gpa, tdx_level, &entry, &level_state);
> >  
> > @@ -1817,6 +1812,9 @@ int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
> >  	struct page *page = pfn_to_page(pfn);
> >  	int ret;
> >  
> > +	WARN_ON_ONCE(folio_page_idx(page_folio(page), page) + KVM_PAGES_PER_HPAGE(level) >
> > +		     folio_nr_pages(page_folio(page)));
> > +
> >  	/*
> >  	 * HKID is released after all private pages have been removed, and set
> >  	 * before any might be populated. Warn if zapping is attempted when
> > @@ -3265,7 +3263,7 @@ int tdx_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
> >  	if (unlikely(to_kvm_tdx(kvm)->state != TD_STATE_RUNNABLE))
> >  		return PG_LEVEL_4K;
> >  
> > -	return PG_LEVEL_4K;
> > +	return PG_LEVEL_2M;
> 
> Maybe combine this with patch 4, or split them into sensible categories.
Sorry to bring confusion.

As explained in the patch msg, this patch to return PG_LEVEL_2M actually needs
to be placed at the end of the series, after patches for page splitting/merging.

As inital RFC, it's placed earlier to show changes to enable basic TDX huge page
(without splitting/merging).

> >  }
> >  
> >  static int tdx_online_cpu(unsigned int cpu)
> 

