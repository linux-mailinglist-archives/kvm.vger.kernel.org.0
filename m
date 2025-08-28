Return-Path: <kvm+bounces-55999-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AEFEB39024
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 02:37:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CDFAB7B9995
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 00:35:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8700521ABD5;
	Thu, 28 Aug 2025 00:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bzqmjBbQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1D119E7F9;
	Thu, 28 Aug 2025 00:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756341333; cv=fail; b=ZOmjjrpRxbpABYu1DWaa226P2u7fQMrSP5iP6oDeMNYaEHRMdeh8uZZ2hQtkKHqBBOqvXMG8/ciArp9TReqtMT3LD4zhFrH8qPSz9OichagAAT7TqnzJ2rwA1tRIWf1y07fJeMcbrVRikfgjTnjziwzcbEE5MaylMjMSmTAmpH0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756341333; c=relaxed/simple;
	bh=3+rl4qDauvGyV1yxkHwPWy4AojrwRe7Pr/J2pohO95I=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=UrZgQpUSRxgT5W/x91/8DAZA6yCBXVQSCmYY+5uB9jnfSSvtz7qH3mRhUHCSAd16AD328mEBaOoAQu6Do+D1DFaO2+5cfaaGergL2gS83M9AfpRFodTV4ezsJ2jqHtjOluEYf/Ucd3jCHU7n7RD8dNYejhOSBtE+kPUZFk4atPc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bzqmjBbQ; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756341332; x=1787877332;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=3+rl4qDauvGyV1yxkHwPWy4AojrwRe7Pr/J2pohO95I=;
  b=bzqmjBbQM+kI8LuLFJALyzC7wW6s82ByEDBkkb4g08lkTjY2CJMRGFgN
   sOgmjwhK1n9dP4nXVSCxe77qCcBCiEgvJPiwywiEeHtSY7X+ltk7sPVO+
   PHL4Xm3CJ3oZ2dNQDXMxk9RQurRNU7x4h7h0NeCLThY0qpavhwJSyPeFF
   naIBPIWKkIXA7qbgp7NaCy7v6E2gHimq3SLiTY1hnBmxNs6Bf8sVcnAI0
   Ts2Q91v6lSaDJQId1PKtVrloQPloYAIkED4OJNMDK6bUmwpm/VbO2f5Gv
   xwhuS2mtKFh7PTRJja6zg/qUCweCsET1YaGEMSetg3TcUIWbZ2UuKwwow
   g==;
X-CSE-ConnectionGUID: JdEuGCaATamvUasr614lDA==
X-CSE-MsgGUID: 18sjgP95QK6YweSE/SRLwA==
X-IronPort-AV: E=McAfee;i="6800,10657,11535"; a="58534850"
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="58534850"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 17:35:31 -0700
X-CSE-ConnectionGUID: IBSEiECjS+6EYKCilh+H5A==
X-CSE-MsgGUID: V4/CSFx8Tk2+BpA2ghWKZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="193626105"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2025 17:35:30 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 17:35:29 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 27 Aug 2025 17:35:29 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (40.107.92.52) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 27 Aug 2025 17:35:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BG+5sJ1KKCTXbzLezh1R3FtMSvyrXM7JcrLACPHvkoz4Kzv9Y+zIpWXtkYg+rUFIjkbEYojmVmahkW65Gr4sprVw1q/zsUB7OFibw0IJIL54gTV7odqYPaTXCAK2wJ5yMG1Gdhc9R+g499vl+6QwrM18uxDIMg4a/WE0R3J3xc03MuNuHVLlg8ERaLc+8FJYhBDIAyLiY5/AZBgSs+Vv1PiO0SSbDyhYPkz8VOD9pFQyz4eKfjQ7YJrcqIR2+S/X1cNmMH13lmkTDC7GsErkNRJnHTc8WUJ62nSS4Du9hHnQNiwdkVHfEgEFZi62ju58BHhIq9ctrtJbJNC/lDcTWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s7vhPzKfDMzV3eWmYYdGdsBRZDCJdsIjidLucwQmZHc=;
 b=Yi1XHz9laO/vB7Oj1Y1po/VBZT6savYc5WBdPmU9O/Dy3olEeo01spnhdc5ES3KXrNmIWMjVwdhFLryTqzVPzrohSGCOzrQSEdeNV7Th14DNbjAmQqB5nukOYpfcrxEn+4d/8kaMuESuu2bHRuqbFwVBXb+pReiEELhouP6x4Za9TRoJueqEb/jqxi/rmwRUoELb4sUFBnhijuXI8VX8w7tucNuTbzCgh6IJqdN10EEpkrOqyfuN2SZHl86LvGEKL1KxIEQKBQyp3k/obbltETeBg1/GkAwWIULBzFE1dIr2vTDs+R3kLOGTCGBQOKOZ3gTXMJpymZubPWjhB9tS+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by BL1PR11MB6028.namprd11.prod.outlook.com
 (2603:10b6:208:393::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.15; Thu, 28 Aug
 2025 00:35:26 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::bbd5:541c:86ba:3efa]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::bbd5:541c:86ba:3efa%7]) with mapi id 15.20.9052.019; Thu, 28 Aug 2025
 00:35:26 +0000
Date: Wed, 27 Aug 2025 19:37:12 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Michael Roth
	<michael.roth@amd.com>, Yan Zhao <yan.y.zhao@intel.com>, Ira Weiny
	<ira.weiny@intel.com>, Vishal Annapurve <vannapurve@google.com>, "Rick
 Edgecombe" <rick.p.edgecombe@intel.com>
Subject: Re: [RFC PATCH 01/12] KVM: TDX: Drop PROVE_MMU=y sanity check on
 to-be-populated mappings
Message-ID: <68afa4b8bc180_315529475@iweiny-mobl.notmuch>
References: <20250827000522.4022426-1-seanjc@google.com>
 <20250827000522.4022426-2-seanjc@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20250827000522.4022426-2-seanjc@google.com>
X-ClientProxiedBy: MW4PR03CA0217.namprd03.prod.outlook.com
 (2603:10b6:303:b9::12) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|BL1PR11MB6028:EE_
X-MS-Office365-Filtering-Correlation-Id: 14d00353-e843-4b25-e2bd-08dde5cac80e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?OxpTGh8oFsXzXsocdmEWl7eB+hDj7uM8JmT8Id6etWOy5znLVZu1QBs4369J?=
 =?us-ascii?Q?Uaka74xA2lpxwjrrPGdGgAGpe5sFrM8QI5qFjUCu4bTo5a39eLy3PzYG8Bbw?=
 =?us-ascii?Q?tpPnDBVw15990XqnrH6+hj1JY5iNdEJorHrlS+zVv9Ae1I/akZKHCVVoSWUR?=
 =?us-ascii?Q?rtrfgnhJXH0BLLNqdoqtAaGtRG1OajBHlrEWya0f3+0Mw3R6JgTT+Yu/aJug?=
 =?us-ascii?Q?K/n8pQU+dCjc9ON5Am07OYvNAcHyb5I/4eAQeOl8bUSSzzYJZkX53Q0Lhk9S?=
 =?us-ascii?Q?r0a8B6egQloBBTbpo1Rqc36UfgaawGu7HKAEtlIt7f31QmdRJFFoAaArfwLu?=
 =?us-ascii?Q?EzcRTHuDDV7NgwiCJJzjjTFhAqoYR5Yr8MllXQliEzhsJ7YeofYmTPKVp8Nn?=
 =?us-ascii?Q?RQeuOKqequJtceApzzoEmk0JYtRjnN11BN5Je9KYpChTXd5KZab+Et3qcF7J?=
 =?us-ascii?Q?oLuCu2G9+5+9IFo2SDC7yYgNFU7sbo4XHijhwnfY5/Q7SJT3ilQuKxozn6C/?=
 =?us-ascii?Q?4PYImE9ANcyLPuUOVRTy6Ny/vFoqCYXrfJ/POkVwqG/vE9xpe3uPSz4t43ab?=
 =?us-ascii?Q?JLw8p1sknjtac2OcrvlptVudUz10yf6cDBSFHsJxCwBfF7D4ErjtuU5L11x1?=
 =?us-ascii?Q?ZI7J3RN8YYQD8yAhzsMxPgzUibNwjpgeZ9O6181XtPi0M6AFn/P5DC6aCDLH?=
 =?us-ascii?Q?SpiFvY0M2kpOfTnVx4rwLbDrOfD5l/5FjvWdliTsPEMKjSZiWssdwgL2NuIv?=
 =?us-ascii?Q?LhGy7DIU2cEQwpRCVaDKakT66QgsqftGaB7qpaqG7RUZ4z4NQI2BhXmnk6Q7?=
 =?us-ascii?Q?b1PJpw3GKfsaCy8kjUy6Fd1Z68VjdXqLFRuSPmSiTLlt7OPLjdMP640W5koC?=
 =?us-ascii?Q?Ov+k4yK3+h8Beuvo1+6qcaS55DzjOQlcKkQuR2iDjtTX7YtfxbyA9KuWir9M?=
 =?us-ascii?Q?bPEG0/qIhg9cyledXt41ZuU/qCyYpw1xAIa+QLp9JvbjwRtXq/oj3QwzBody?=
 =?us-ascii?Q?2p8hMTJeun24OU6a0Uvb+thEvYjolf954sYqEQQfdMZW+dY0k1dTiaEzq133?=
 =?us-ascii?Q?wIh4jDO57EB96uhpY2aO2/bKo+R/aQzzXlYMpxBET1+C3LdW3THJL0LjMtro?=
 =?us-ascii?Q?EmjJTqmP5sOOyKQFp3C5PIiY/QOd2+UOk/VosGzmN4Li0MlQVD1VeS+BrARg?=
 =?us-ascii?Q?Wv7hDvsi8mzsoHN7StBCGB/BsNcw3HF0pwsCrcfCGkzb2qqXUIYH/BCiKSD2?=
 =?us-ascii?Q?pt9CuCtay0k/BXYtfu1dTy9GJzE4a7Fqs2+zPV+qnlKSP1UAfH/ggcLfmhFT?=
 =?us-ascii?Q?67VkqssQCbn8r3bzy+ztGxzkvDFv8fUOijTdJM/IkInRAZpJleruouGhysRj?=
 =?us-ascii?Q?C0Zw5CSgSrLJq2UIkPHjbzLp8l8bRveAgCZZe4OtrEAEXgsoJvG2ZO7rqeqM?=
 =?us-ascii?Q?1FeLRONZ2Uw=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OiO8kDW5tuevC730f5ucYwqzzuAhVbh19a8Ytl4UD8hxqxweopayNtzguGgN?=
 =?us-ascii?Q?z6oKBzZDGck8O8N0J+68fyOTNvk7TwN2+eU6PxkyD2aMJfSlMWyD0Vr8M8pN?=
 =?us-ascii?Q?aGDwAbBWlrQT7y4sI6O8cArW3FxtvfjmLGZCJc+Ai4QlY0WLEfa1hMG3q9lF?=
 =?us-ascii?Q?Q6kfI5u69XOsouwVw88slf7bkdX95m791bKOVe1LaNPpzyyVpHoKXN7xjH92?=
 =?us-ascii?Q?sIWdfHpUDSlp+YUwyXD0Wtts/AarVrv/LWZWrowW0yrqQjV90cLsgH0OYhzs?=
 =?us-ascii?Q?Gd9qeagjJLZl62vyxhRoXNN7hcD/ysloMjYvK3pepaYsazlaGGqvjpS9u0xa?=
 =?us-ascii?Q?n6DDpFdomABnCJWM49pquAeYG6CvHEeR3jur0dZNturfTod4PH4euYacCh4B?=
 =?us-ascii?Q?RcYiv4NlIAxAhUk7ls+PZOVp8kxfwwD+lxMYhOiPqENfEyxp1PQm45aN4oZ2?=
 =?us-ascii?Q?VambYFX7kmwZMiEpy71fRw9LzxNoGooLl1xcXr9iCAWMCkPnx3m0BFqbOMkv?=
 =?us-ascii?Q?sWZ7uWu653c0drXTBYGd4MsuSHknJCapCGmXKV5uAzDReVsh+rlDO7Ht/zPv?=
 =?us-ascii?Q?m5C3slHz9QY5onYXdblpP5h5qwPj0o2wL1m2BZIALK1fljeM+ynrOnMWV1e2?=
 =?us-ascii?Q?x1HrLR44TlOaDl0X6ZW2KkgBmIooL7VRTgmXAQEVxYb6d5S0gWbmt+BXA6Qx?=
 =?us-ascii?Q?DYLSnkn2KIgrt5GGqea6JaOANITyi1S26XJ1jcFwp/IBwfBRU6qm5J6mhqeM?=
 =?us-ascii?Q?JaNcea6TEJRiUx/aJYN6kRvR+7CaUVUfj2n9LYBu/xxfR5n8T906TSGifwUQ?=
 =?us-ascii?Q?FWn32z8jl1C5sfpnPTQNoJrKM2VyE8E5STUMETOGQICfszO3ZWMa45/pQqCp?=
 =?us-ascii?Q?i9WM9F3ehfekU3Pg1HG0sONPkVudqQtZPZ5W+AERT169dstq7q9+fGIMXHTS?=
 =?us-ascii?Q?hwo1j0/uNUUh/8hyfC1iJzChcYW8Vr8lzZlLsoHNso3nMc5EStmNZ636uhin?=
 =?us-ascii?Q?KgQnGa0yse5jqLn3K/LB3j6O8uYGTtdtriSEhu1q6/dJA8dyILdhGUi9QWT8?=
 =?us-ascii?Q?1MIJ6NgG/8A69rrKikovXlhp6bzeGBaDmg6hiYHlhNC5yZpdBZw0th23GuCc?=
 =?us-ascii?Q?T3APRnj+D8uNOV9uCsyTgKk3qXgV7vkhwwQC5WMkFtOaIP7njFZPvt17LPZ1?=
 =?us-ascii?Q?3gy6lAOAG7ZvprFXxzrAWes7/EL8M4QMUhu+x+EQoM8rIiqkhzYneLDShQjz?=
 =?us-ascii?Q?FP95J+vb4y2S9gWaXiWRxZlmD9PbTnFdeNVuAFUz9EYQSPKoFvygx62FQr7i?=
 =?us-ascii?Q?pkCdxT45ZCjZP4uBZs//KbrXTpvULmBcgsPlYQTKbdefsl8aaAlnuV4eIZ94?=
 =?us-ascii?Q?svsrRRn2E60jkPcm2svNlegAD74zmUyOIT5HZk6VEmRetbFqa4Ixb1yDkR6l?=
 =?us-ascii?Q?eNFcZG9o220EtdQcDJc06ZpN8WeRLN7xWkpEOEvu5SC0GmB2yGCZAUEGYWtq?=
 =?us-ascii?Q?0iG9sfoOT/MAlwyrbnmMHAFQmTDUEdMYGt2lST/UQJ/xPjuPKLOD6NWOzg/P?=
 =?us-ascii?Q?e/ABdGYM5g/aD7d9qO/NwbyUgX4xEvbcswBz2UdB?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 14d00353-e843-4b25-e2bd-08dde5cac80e
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2025 00:35:26.1830
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KNNtHatH7yOVAyqMo5jV/111gwf7ZnnB3K/Bq9HgDcHlrg+uLjBtujjbKNJlyHYBj+TX9DZwSMkQjRPqsiYpBA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB6028
X-OriginatorOrg: intel.com

Sean Christopherson wrote:
> Drop TDX's sanity check that an S-EPT mapping isn't zapped between creating
> said mapping and doing TDH.MEM.PAGE.ADD, as the check is simultaneously
> superfluous and incomplete.  Per commit 2608f1057601 ("KVM: x86/tdp_mmu:
> Add a helper function to walk down the TDP MMU"), the justification for
> introducing kvm_tdp_mmu_gpa_is_mapped() was to check that the target gfn
> was pre-populated, with a link that points to this snippet:
> 
>  : > One small question:
>  : >
>  : > What if the memory region passed to KVM_TDX_INIT_MEM_REGION hasn't been pre-
>  : > populated?  If we want to make KVM_TDX_INIT_MEM_REGION work with these regions,
>  : > then we still need to do the real map.  Or we can make KVM_TDX_INIT_MEM_REGION
>  : > return error when it finds the region hasn't been pre-populated?
>  :
>  : Return an error.  I don't love the idea of bleeding so many TDX details into
>  : userspace, but I'm pretty sure that ship sailed a long, long time ago.
> 
> But that justification makes little sense for the final code, as simply
> doing TDH.MEM.PAGE.ADD without a paranoid sanity check will return an error
> if the S-EPT mapping is invalid (as evidenced by the code being guarded
> with CONFIG_KVM_PROVE_MMU=y).
> 
> The sanity check is also incomplete in the sense that mmu_lock is dropped
> between the check and TDH.MEM.PAGE.ADD, i.e. will only detect KVM bugs that
> zap SPTEs in a very specific window.
> 
> Removing the sanity check will allow removing kvm_tdp_mmu_gpa_is_mapped(),
> which has no business being exposed to vendor code.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

[snip]

