Return-Path: <kvm+bounces-23289-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 46A5B948657
	for <lists+kvm@lfdr.de>; Tue,  6 Aug 2024 01:49:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BA92A1F23AFD
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2024 23:49:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FCF616DC0F;
	Mon,  5 Aug 2024 23:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I1ICNsAr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B2AE14F9F1;
	Mon,  5 Aug 2024 23:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722901740; cv=fail; b=MoX6yuP9u1ZM9QTJfDVNxSA3NJC30qc5C6wegdA4/tzGXEbjlRKuDfO4GgPrwed6Fe240EKUw/mXYIXHv2BIuUmMkCiAgHQ4NimQeJb81/e5dcAJpARVcLZ5rKOppX3kX0GMhd5CGc7djLpXrhUkv22vOK0Dr0Fqqlj7GmJ8YBk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722901740; c=relaxed/simple;
	bh=/6pHTPqoBhoSApQ2Z7ob8aISlEKrrKYQ1Ufy43jjZZM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dFaUTJ97fEebuaKwMwMFacOLI8gejfwAqkPIKHueSKpFgxH9t2OYRu7qIeI4sZR6eI0sHHB/kriGlyGsll+SrpfIrp0IKt0TzNc4VMC0pNZLC7eNC0+KZMIyiMPVehBbg3IYZcODGRNNIchXoLmTsQ5KAH7u1hKFkBmIB4sSf0c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I1ICNsAr; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1722901738; x=1754437738;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=/6pHTPqoBhoSApQ2Z7ob8aISlEKrrKYQ1Ufy43jjZZM=;
  b=I1ICNsArgfEwkTU+jo0MhMiqygE0YVFPgnZqfqpey0YEJI+/X2m4w5A2
   5642UvPwFJ5IZX/65N16MjlyfTQjNhc0bdt4rIq4Oh//wIj/7ePcGtCrx
   UuZwnt9Cub4IJeFZdwco6baLQ9ebNVAoxpjXuWCRbiEb9VY34V4aXQl+8
   UJyHhd/qPvU+dnC3/7IinjhB8GW/TMjxJyDKmacfOXkRmLlRvPPFh4dcT
   3/q7XlETAAL1hMdQd8OJlyZsIZRyUljvaERh4o3ads/wCnsJ59xInDu3L
   8pQv7Vb0SQ1poCDAId8jzfwf3sPTc1JVICCrCEYS8eqyGIXz9Ool2Npco
   g==;
X-CSE-ConnectionGUID: 6hu79YqHRraEkCFdDalymg==
X-CSE-MsgGUID: MW8MRiB9R2a8dr0zGqKZXw==
X-IronPort-AV: E=McAfee;i="6700,10204,11155"; a="43419382"
X-IronPort-AV: E=Sophos;i="6.09,266,1716274800"; 
   d="scan'208";a="43419382"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2024 16:48:57 -0700
X-CSE-ConnectionGUID: 6pqqXHdhQr6lymJArIEBJw==
X-CSE-MsgGUID: ewoNLBBCTUWjJRDg87FnbQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,266,1716274800"; 
   d="scan'208";a="61179767"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Aug 2024 16:48:58 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 5 Aug 2024 16:48:56 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 5 Aug 2024 16:48:56 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 5 Aug 2024 16:48:56 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 5 Aug 2024 16:48:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g/Epp0PmkZvUgOdN/7llA802i2vVoOSWxurWWM/lcN7stl64LTAm6wO2EJda34kbiCfcFpqNrQuuLlArl1CN0UN5ieYzMAvMNV58gPBS5ZW1mtMC0GQt/zGiZcCdQ9qLgEOt1IbS479yTrxJczMadTek/108D/sXh5j8P3i8OXAiEAsG9MeK19GNWIbXPewHhpEap+L7HOQFDlZSOnRKb57L6MMFiYas2qkCMmOubkct0RBTA2C5eoQxQ9D6/f5qnr8g7G2miBNgSvw9iTpsJkvDwFtoJ5CAf6O844Bcqgy91XGJi3Y032YENmaeSzVsMneUVV2Y94DzRmwAWoObbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rjiwF/FTraQDwLt2sYprZYzv7Ik9Njan2wjavTCADm0=;
 b=eflLPAtqkVM8fNT3SMTuW6JjPxLCG1JUYac01DvM93Fleb8aD/QIFDmGVtHD/D4D2R9x9NA3tTnuw5ERRspoYOlmWD7kTicLV0t6Pa9SH/9ROyA4B7/j4qaogH8dHso304QLd7gd7QntxwlSZFtzzrRtM5di1n8fMHngkgFTUh7QP1sC++U6aylOI6nxYenFOSbj6pnexVfg9c0gEzeRS22k0GZf6eZCXgHbCBDoypvgG+TQ9yJP0VhzaBQwfXcGe5wg74u9JFAUOJpS2g4VmX7FzVdwWbBw3yfKg692LVCi2T9XIkCP20SbCTVSY9EHEi03pL/IQfA8E7sRUws9cA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by MW4PR11MB6888.namprd11.prod.outlook.com (2603:10b6:303:22d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.29; Mon, 5 Aug
 2024 23:48:53 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%4]) with mapi id 15.20.7828.021; Mon, 5 Aug 2024
 23:48:53 +0000
Date: Mon, 5 Aug 2024 16:48:50 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Kai Huang <kai.huang@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@linux.intel.com>, <bp@alien8.de>, <tglx@linutronix.de>,
	<peterz@infradead.org>, <mingo@redhat.com>, <hpa@zytor.com>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <dan.j.williams@intel.com>
CC: <x86@kernel.org>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <isaku.yamahata@intel.com>,
	<chao.gao@intel.com>, <binbin.wu@linux.intel.com>, <kai.huang@intel.com>
Subject: Re: [PATCH v2 05/10] x86/virt/tdx: Move field mapping table of
 getting TDMR info to function local
Message-ID: <66b164e1eb593_4fc72948f@dwillia2-xfh.jf.intel.com.notmuch>
References: <cover.1721186590.git.kai.huang@intel.com>
 <5fae6d65a9fe68ac85799164866c25305c7a93be.1721186590.git.kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5fae6d65a9fe68ac85799164866c25305c7a93be.1721186590.git.kai.huang@intel.com>
X-ClientProxiedBy: MW4P220CA0003.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::8) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|MW4PR11MB6888:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b965a02-61a2-4bb6-3b68-08dcb5a929c1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?wlj0TvP4lvWw4v5CKVsjfsy/cc+SkT6O45Oh5bi7okQ4HQ1v3cHUVl7xll+j?=
 =?us-ascii?Q?4O0nGXQSTqOwWEtmUTHu6FqYhPS2UpUGntrJv/E0M5CUmCu1Ox2s244DPdfN?=
 =?us-ascii?Q?D4gkl+zgJHt4UX+ptWLqWGiRyIFVUFRwOozLRr2WnsY+zhS52N25AckYcmER?=
 =?us-ascii?Q?ohoaYemdVhkBMY+jCfRZfAI/r4TTZsbTe25bWEfvF8N68qeyrbFDfcluMTHT?=
 =?us-ascii?Q?+ma3K8JNGyTmhk9Y/OpiYUVGTyAlHtrQ3HDSwuVErIsVD04OW0XoNq7TJD3Q?=
 =?us-ascii?Q?Imv7o+V9p+O1eoM/zMUbp2MRjcfTgD+W/CZX4c7lNQ9TUeLIkUGLuIHuBknz?=
 =?us-ascii?Q?oIn0VVQpBHOOBsisOLLoCa7Fd3Q7Xb3aBd3FaAgDi/mF8GesPKB0hlpxxJ+a?=
 =?us-ascii?Q?MCLcknT+Qg5Zr1iA67A71ZUsBAvu2g6XWD+EwtXaGcxExgVb74zemrryBNLQ?=
 =?us-ascii?Q?WaCsfx7kn/Nk+xYBrfNY8tL+/VbWU/aFz33u/mpuEWly7/fZw2ppEkxVmuh0?=
 =?us-ascii?Q?ThmUDBqfFA2NHmIhLGNLodKZr019ytUgUPBXjTA6meVgYhIiKP8PaKE1SnVP?=
 =?us-ascii?Q?uYKqc9U1RutR1wElk41eshMw+yjtOkOr/JaFKb2eagYmc/obZyzJCjpX0vsZ?=
 =?us-ascii?Q?V71tgyNe0dDl457VVSSBRMbtaq4RGCNku6qOsmzwpIOl5VLaORIyuavg3SsK?=
 =?us-ascii?Q?qUyUmZkqYGI0hGDBsYe+ToXu00hH1S3W7uxQHdZVRcNn253wdAp+9HK+Xm8Z?=
 =?us-ascii?Q?e9jzNy2inHHy//JZ6KJzr/3VuyZsj4niPjzVyITZTEe59o/WiLVPRd2tvWij?=
 =?us-ascii?Q?fEHMtVwo7il/Yz5yBFM9rpdq7u6BCFagAfim3YDR/4LKYSX04gI6JOrG3zlj?=
 =?us-ascii?Q?CScV2f6EelsPJxAmT2WJ8jpOMSXPpRVzPC5EM19st5xEzPOlPNxVZnPh1FD6?=
 =?us-ascii?Q?CPqO4+ws9fjOve4kyk5LWEfgG0Zp1MDWhvq992CcdLplqJlMTvnym/HJ2RJl?=
 =?us-ascii?Q?VXla1xEe/3rN2zLsnILwiQPy6Tlackqghe3j30ZigDd447M3DKpdrg6P4J24?=
 =?us-ascii?Q?0UIYpbxD2KPKksnPD+wYb7pLvZnl8I44v8v+vKDIjFcJ7blosl19858odsQm?=
 =?us-ascii?Q?tzTOTpLklMxc6MvwOzalFzWsUrRxqFtxdUNPEdcA/39VpV7hSJcLdgTJgmnq?=
 =?us-ascii?Q?jwCgsxpWpo3alGNhOkqQep0AKD5sZOFUKd2ZrwuhLLyPVv8iaPcas6fsfxz4?=
 =?us-ascii?Q?J96ldYaadPJ6Vrkxq+FyLu2SLsMTQayMIouJ7UZH6ZYlX3OmBhcjU18yeSST?=
 =?us-ascii?Q?678QGtRIvKQ3hBUgpju+37Wj1LQglaKcFlqMed2AATBpew+2sLHog5u4PQ/p?=
 =?us-ascii?Q?Fys564GmVFhMaX/e0i8xLXJ7lJv0?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?J6FbEWXULVRWIClwb3Zjl2IKICTx2q39y/KsioHtKYrozj2N7AsbNGHG5FUb?=
 =?us-ascii?Q?4V9HoMmCoCoQGYxhI9V9wpPjRImIF9Gmz9jHGhX6/LlX1PJLjUwykStZ5eto?=
 =?us-ascii?Q?B83aJcNiub7oz5ArR2ukvMgv4YtBQjQAUuCPmXy/wU9I3SIPysw4ByA8ADCx?=
 =?us-ascii?Q?O/vCF246qjzrYqd1JVPNx5V9m03Wsh3TZT4KvzrudC2vmsss+DFsyKsKNimG?=
 =?us-ascii?Q?loOXqsaZWgvpNIfwSpjTByN4QNvg5S31fqlAKpbs47Zd2W9WZpLWNBtQEg4Q?=
 =?us-ascii?Q?u0q12yNDKbzv0qFLKa+zVrPG7K8BBM+8imjZU1mHRnW/YN5sMaE4VvthCn7u?=
 =?us-ascii?Q?24Mnyu0t3bnSOwcE6gWFPlxyPXsc2HTrsoMSaI4j2LvR073W2JkpMeQWj8d3?=
 =?us-ascii?Q?ydkCSGv0Q8QYUC4SNzA5WV7V+l4QvVhk/O/Ey1prK6uMYPQPDlFfWvxlXUOC?=
 =?us-ascii?Q?os1tGf1HdwZFsY250v0yPAESmA/jbTQLOYn8xC2lPgdtPAww1zQF3uSem81z?=
 =?us-ascii?Q?VBlaLlOYYp+2vAG8+yAayfYYDvoYWXhzyBC9Wk4vrbkGORn2ipsoOo2lMA2l?=
 =?us-ascii?Q?Wtzd3dgrHGF06sS0ribtgq9PtGioNhy7RT9z7sEDpWduCv2GorTRsdFM01Jq?=
 =?us-ascii?Q?EFat5ANaZ36Yg2Xf3i1KEOsqssuFpaW4xAtjybir8PEcq7b4OORL7sHKPNy3?=
 =?us-ascii?Q?6quzuvcYk8sbWyzzOy2P6HCzIeWtT0IPBQFfZtWyg9h+0uzbCNk0eZxB76wV?=
 =?us-ascii?Q?31NVyiUBovaz+9vAL+THx8UH5zfWcawdaRXmUcx3qygtOiOruXr4tQ/KRolb?=
 =?us-ascii?Q?BbZ2saCEXPLrvVgb0LjvQUXiPL2ryR67VpN19Owti3HAsz5RioqrIp+K/KxQ?=
 =?us-ascii?Q?aR+phwf9IIYiYkuyFu7PkGF8VbQJFp2H3r5oiUU7Ry+1l88tpf1ypBYFBo35?=
 =?us-ascii?Q?WQigkqwvXhBAG+y8Uyz7K1kqIwZE8WSu7kX08XB3YAMszd/Evq7nrgOZHxN4?=
 =?us-ascii?Q?9VnDz80fTS5BySURbuZUmFKzD1K7ZEeXPQTyVylD9HRDU/SU8V/m1uaVMrR9?=
 =?us-ascii?Q?4DzgxtUdiZYRi8Apzn37NnElw8qf7kLa6jFEQFcGiDiiiwPB/OlC4L1wImuh?=
 =?us-ascii?Q?UvFLDJG585k/kRwWUld9J0TCTkYPwq/hsKOBL8iPVVYxq/uSF0hDu7VrrTXS?=
 =?us-ascii?Q?iLX8n1dEsN+xzliSFTM+ixRvzPn3K2wek2pDriQU6B4e+YEVydBTawVNA8nb?=
 =?us-ascii?Q?MBP5FTijpLlV/opPnJT1suuKHdHihdBWv1aZJMQK3gLS3RxIlNEQTQGwnYU6?=
 =?us-ascii?Q?pDGig10x3vUrtXQy9yFPPizx1Y/8Z5HeetaG5rej+4Isudxfxx8viqdWD9yw?=
 =?us-ascii?Q?Lfa3/5fV6N3adw2GLz8GojCz3O0ZQH+5Vcv1L2JosM7HdY2gvJtiWga60jm9?=
 =?us-ascii?Q?FerRukb3T2m3Q8Qna299flL7GHRl63ESLW6A6p3aXZ611LIV852q5pqGNYKj?=
 =?us-ascii?Q?/AbMObxdRsI4BBtewl6viO4rawHX2QbNJO+0GQg8gr0JOWFGuIicQ8oZ8CFR?=
 =?us-ascii?Q?TPS4HNrAE6bbAqQl2/qoAB7R37i+BsXgIZt9fLhFw9bVAD7q/DmqqMQ+it0q?=
 =?us-ascii?Q?Kw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b965a02-61a2-4bb6-3b68-08dcb5a929c1
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2024 23:48:53.5421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g2XTmtzea9XL2SsIlG1Hqrivzzj7m0Te03IMKOR1aZi/4LqY54V02ARJydhMRHtpr4dIkumPUFtgFrpsYrFTKycPpjr3wVkevmtoeMv2Md0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6888
X-OriginatorOrg: intel.com

Kai Huang wrote:
> For now the kernel only reads "TD Memory Region" (TDMR) related global
> metadata fields to a 'struct tdx_tdmr_sysinfo' for initializing the TDX
> module.  The kernel populates the relevant metadata fields into the
> structure using a "field mapping table" of metadata field IDs and the
> structure members.
> 
> Currently the scope of this "field mapping table" is the entire C file.
> Future changes will need to read more global metadata fields that will
> be organized in other structures and use this kind of field mapping
> tables for other structures too.
> 
> Move the field mapping table to the function local to limit its scope so
> that the same name can also be used by other functions.
> 
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
> ---
> 
> v1 -> v2:
>  - Added Nikolay's tag.
> 
> ---
>  arch/x86/virt/vmx/tdx/tdx.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
> index 50d49c539e63..86c47db64e42 100644
> --- a/arch/x86/virt/vmx/tdx/tdx.c
> +++ b/arch/x86/virt/vmx/tdx/tdx.c
> @@ -322,17 +322,17 @@ static int stbuf_read_sysmd_multi(const struct field_mapping *fields,
>  #define TD_SYSINFO_MAP_TDMR_INFO(_field_id, _member)	\
>  	TD_SYSINFO_MAP(_field_id, struct tdx_tdmr_sysinfo, _member)
>  
> -/* Map TD_SYSINFO fields into 'struct tdx_tdmr_sysinfo': */
> -static const struct field_mapping fields[] = {
> -	TD_SYSINFO_MAP_TDMR_INFO(MAX_TDMRS,		max_tdmrs),
> -	TD_SYSINFO_MAP_TDMR_INFO(MAX_RESERVED_PER_TDMR, max_reserved_per_tdmr),
> -	TD_SYSINFO_MAP_TDMR_INFO(PAMT_4K_ENTRY_SIZE,    pamt_entry_size[TDX_PS_4K]),
> -	TD_SYSINFO_MAP_TDMR_INFO(PAMT_2M_ENTRY_SIZE,    pamt_entry_size[TDX_PS_2M]),
> -	TD_SYSINFO_MAP_TDMR_INFO(PAMT_1G_ENTRY_SIZE,    pamt_entry_size[TDX_PS_1G]),
> -};
> -
>  static int get_tdx_tdmr_sysinfo(struct tdx_tdmr_sysinfo *tdmr_sysinfo)
>  {
> +	/* Map TD_SYSINFO fields into 'struct tdx_tdmr_sysinfo': */
> +	static const struct field_mapping fields[] = {
> +		TD_SYSINFO_MAP_TDMR_INFO(MAX_TDMRS,		max_tdmrs),
> +		TD_SYSINFO_MAP_TDMR_INFO(MAX_RESERVED_PER_TDMR, max_reserved_per_tdmr),
> +		TD_SYSINFO_MAP_TDMR_INFO(PAMT_4K_ENTRY_SIZE,    pamt_entry_size[TDX_PS_4K]),
> +		TD_SYSINFO_MAP_TDMR_INFO(PAMT_2M_ENTRY_SIZE,    pamt_entry_size[TDX_PS_2M]),
> +		TD_SYSINFO_MAP_TDMR_INFO(PAMT_1G_ENTRY_SIZE,    pamt_entry_size[TDX_PS_1G]),
> +	};
> +
>  	/* Populate 'tdmr_sysinfo' fields using the mapping structure above: */
>  	return stbuf_read_sysmd_multi(fields, ARRAY_SIZE(fields), tdmr_sysinfo);

Same symbol namespace benefits from skipping the array indirection
altogether.

