Return-Path: <kvm+bounces-26046-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F4C196FE86
	for <lists+kvm@lfdr.de>; Sat,  7 Sep 2024 01:37:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B061E1F244D6
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2024 23:37:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB44815B55E;
	Fri,  6 Sep 2024 23:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Sjfav1V6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0136F1B85FB;
	Fri,  6 Sep 2024 23:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725665818; cv=fail; b=IANNm4cWuEpU4p/M0LQY2u4DOyRu9pIXfv6EZPmE0EpEK+aImYDcaYltQEwH68NXtVTCYHo7rTEGIXEvxeWmh+pe2jNfiyLum/E4bTyaZiTVNJOf8pYJHLBkc//V63vfUygMiHJ4xVhQNdgMBtWBx7c3qrfQAZ2L3fOFQB9qv8Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725665818; c=relaxed/simple;
	bh=QOTvAa13mUTCCghxgB05MK/u/n5rzqjZvqz78QEKfk0=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Heyc66FsBZ+h+XkU0wnRmXaiqI4Kq1gr5bMfHDxRh2+XpC73cZ6TTtoTuR6Kiab1fxLsCDLtgK5buiST6H6ARV+8D7kxwTz91ycTYlAgejmJXGYYmv0v9ikcm/jLDLBvsejKGzLzThzjSNJ46Dasvax8u+Ut5qzTfui/QQmKRvg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Sjfav1V6; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725665816; x=1757201816;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=QOTvAa13mUTCCghxgB05MK/u/n5rzqjZvqz78QEKfk0=;
  b=Sjfav1V6przLZwhd7wMG9Ks3W7oQ0pdticMJnQSE5s4Mt9S/8m7QX0jz
   Hm9cA8oM5fOBHSbw1dOJoWrxiCmUEozWYUXMpKkBYI2liZiScO1br8yoF
   AHeLbJouBy768szMHssOkT73bZffvw8mnl1NLRzu6gePn+BI4N9WKNXXd
   sjH11PeAGshcxJOe+PrACWJDVcfcBaFJhXOr1JRY89zh2Vz2knIjSOdJJ
   Dgw8QJ9jfiHNJPGfLETZtmbHPqxu1ek1dN1jVi/fq+aMmNIxkUtgsaXzV
   VK57NmyEIhtTC5sFxjmmFUf1wUpQL0FE7nhtHa98INHsw+didTDamIaJS
   Q==;
X-CSE-ConnectionGUID: 90AwESVNRBqACSPItaRTEg==
X-CSE-MsgGUID: rwvoa6hnSXK0e1dXcc9cag==
X-IronPort-AV: E=McAfee;i="6700,10204,11187"; a="24549248"
X-IronPort-AV: E=Sophos;i="6.10,209,1719903600"; 
   d="scan'208";a="24549248"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2024 16:36:55 -0700
X-CSE-ConnectionGUID: GULiOwAjQ2auSvw2QarFuQ==
X-CSE-MsgGUID: u+JX49BqRsyAS9E/1Tom6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,209,1719903600"; 
   d="scan'208";a="66334650"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Sep 2024 16:36:55 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 6 Sep 2024 16:36:54 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 6 Sep 2024 16:36:54 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 6 Sep 2024 16:36:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AG5uDsJlyKElz6QO/Z9uuMh099w5GZSB9x6wm+4rXx+4/9gMp/YTX7DxkHCgMdvmbIgbJx+bucmhUuzUcKunvOmDS7wavVeTUA6Df4KNGmUmXPo5f8fMSpaBniK54NQHraTe0F0nMtcKC1mssdYV83Lzn1HnbfRQnTNPK8bHVYsqWWj7WBPB+gBcD6bcAO0jlA3Rlhlz302UmZblP1xPTvfGtdMJBz4oAM9/Ek+WbhAvGSgh/HlVMnElFqJHmp4AbrfZzQxUghmjLDJCBAI+poq6W4rXSP5qy/Lp+6AFkyqLV11gP1zh8FROoH6OitM75L+iUisAE6HLdtsrAakNHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GVNt0o1PoZ+DQ9DnBxguJGqhIGXZOg/LZmT6SJEFk1I=;
 b=YOZAfGveJ6pvMKMCXTdclswYFNVQx3Q6CLesaHt3cvTSbEmPsrVEC+PX960ARjbD+283iyO5cAZYBmSr4JDorwMM7pHoI1dDNTdmzkCE3a0vrJ1OqaxlZpn8UaA8RBktP/+VOWEOY834DQTmEKYqF5hAy44TKpMxFisCrb+F1m7sZoZKrScH/LCT/R16cZOKEzIbzXodKNZyCrCVDcJK8ruIUm1XnPSnLt51u3v2zPa3+qepPaxug1wR0HOSxoB3YZiKaowPyHJRJFmEgcJg2XgVOxebOEWOkakNidc0UsUr/MpQ3cUzguuY/xwN+1s2JEb47YYD5HL9PCPO7vhpVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DM6PR11MB4529.namprd11.prod.outlook.com (2603:10b6:5:2ae::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.27; Fri, 6 Sep
 2024 23:36:51 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::6b05:74cf:a304:ecd8%6]) with mapi id 15.20.7918.024; Fri, 6 Sep 2024
 23:36:50 +0000
Date: Fri, 6 Sep 2024 16:36:48 -0700
From: Dan Williams <dan.j.williams@intel.com>
To: Kai Huang <kai.huang@intel.com>, <dave.hansen@intel.com>,
	<kirill.shutemov@linux.intel.com>, <tglx@linutronix.de>, <bp@alien8.de>,
	<peterz@infradead.org>, <mingo@redhat.com>, <hpa@zytor.com>,
	<dan.j.williams@intel.com>, <seanjc@google.com>, <pbonzini@redhat.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <isaku.yamahata@intel.com>,
	<chao.gao@intel.com>, <binbin.wu@linux.intel.com>, <adrian.hunter@intel.com>,
	<kai.huang@intel.com>
Subject: Re: [PATCH v3 8/8] x86/virt/tdx: Don't initialize module that
 doesn't support NO_RBP_MOD feature
Message-ID: <66db92101b565_22a229498@dwillia2-xfh.jf.intel.com.notmuch>
References: <cover.1724741926.git.kai.huang@intel.com>
 <0996e2f1b3e5c72150708b10bff57ad726c69e4b.1724741926.git.kai.huang@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0996e2f1b3e5c72150708b10bff57ad726c69e4b.1724741926.git.kai.huang@intel.com>
X-ClientProxiedBy: MW3PR06CA0021.namprd06.prod.outlook.com
 (2603:10b6:303:2a::26) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DM6PR11MB4529:EE_
X-MS-Office365-Filtering-Correlation-Id: 3533e1dd-593b-45ad-2184-08dcceccc832
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?fUlVz2rtir3vktTlmKMqte2CZTVQ2ZEB+U0Fu/iNpMRl8yp0lEq223NnS5gj?=
 =?us-ascii?Q?u/+3cx2BKjx09BXTv9clgbIcDIaL6k1sIp4pmkibLO2aJHelnafJbTD1zVYl?=
 =?us-ascii?Q?QtESf90HwAqUNqTppmkFB3PoCYuNTUyV1ntYu6I++ZZsnuvsAl587ear7tNd?=
 =?us-ascii?Q?uB2ySd8TgGN8gq33rs+qz2qav0ddUfiaPlilNPdGrcb6pyUzFFpy/1/SSusQ?=
 =?us-ascii?Q?rMD3X1g7fCHV4rxFhLuAqMgdnZA70ocjnVhfsiVLEvvOUxCJ23ekbelq/BEM?=
 =?us-ascii?Q?+XeH7vpPtKNzFvx66/qAJRxZGuqucF2mqbhNDXFIPRxPGOCDZaciifEyazJT?=
 =?us-ascii?Q?BRILqrsGom24U+c73AmIAjB2TJ0WE+mI1WQ64krH/N+b6VTMYj+QGgIa+Z3E?=
 =?us-ascii?Q?8ptmaI3DdE+QOwLI+9D7jxpPxXILcWTPn8HACVU7s0gDogJmZ3ebRTXtuh58?=
 =?us-ascii?Q?lEZu68rQjHbSKsFVqvJ4KXS8vJQXagM6UMm7N0EvqgRNzz4erCrt31sPapB7?=
 =?us-ascii?Q?ZL+yXaibIcQyK68+5axGwEg7Jp+bgtqPeDc/ttVNlikYcQPQcVxRvOeiPPbl?=
 =?us-ascii?Q?Eu6A3SlU/blNdl/YuZRLm7AZQnmEbjmAX/nsg7ndg6Cbik8BXh81smOUSqal?=
 =?us-ascii?Q?pfLiy+xBw7iuJ/pJVOix8jhJxXc2IIno0XLqzN0Al8+49hyl9/w18EWkMQsT?=
 =?us-ascii?Q?iCW20doNeQMeoUsGOuY6bEXe+X6g0YSCQ8IjecakSAYAUs7R2k0Uxi3OtO3g?=
 =?us-ascii?Q?gDhB/eInKdE5Q3Pw0Mpn8PGp8LQBlJrVFQPT8u9CFIhTNVc+UXTXjTyJ7PNz?=
 =?us-ascii?Q?/Xdya3hR7lAqJ9Kg6/mvJ8DcQWLFirzHMIBPpgSuH0wwsrFD1qRwuSFqxIg5?=
 =?us-ascii?Q?QOWA4AIq7Bth7Ul5xODmIsV8dcXsNkl1WntsRXV6y7jU8uG+wVayptqhekyv?=
 =?us-ascii?Q?A77DsmOk3TIWyUimHOfSF/dj8BnWSf2GO9+ujaZEiImziTaTzgVYhPRnlxCH?=
 =?us-ascii?Q?0ysz0knYZnmu9SR9LU+2rU5GKQjqfV3mZfk/dxPVrbjdYlRCovkMIymA4HtU?=
 =?us-ascii?Q?6s32o0EVoS6wHeZgDAFezYjcCUiQ5YodujFv8yDFSKdSap0QbFUh7N3M/Z/R?=
 =?us-ascii?Q?Z5ONH7yKxpRXr2yplNrE7+NLyUKx0eOwMOEjSR267mndQqGcyTp+705P1VAP?=
 =?us-ascii?Q?i6wSW33wwjNhnha+qYSbSseviCzHEbkj+U2HhKn40sx4WBw81pCfcg27Pjgp?=
 =?us-ascii?Q?5a7DlgXQ3guislxwgo5R7mAX510eM1Aay5UWzA9eFpQZnrdF4eEQz/smDZCR?=
 =?us-ascii?Q?vg111oMqqkbjElv473xlQdRWqPsFTaC21TRUHnsU31pyn+P09owZKlvY8RbZ?=
 =?us-ascii?Q?L1fGIBH2xoskHvJbIt3VpoBF46FbEi6bBMCzWOoPGOs0ukmmzw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LhHZgR+gRRhNCrP8kot3B9pcYcEbGV2bNQ7tD4b5WJI/fprZ7KmLjzxy73Z2?=
 =?us-ascii?Q?cNl+tPiaxHg9N5gu7vUoHzzTNvXhxGH0phjN/pJKajLxHB8QEUwf5nHzNDCN?=
 =?us-ascii?Q?Q+Fl6ympFrKcFaWkpv5aYm1itdu18uW+Jfmzn39+2W1GgDsLMAa5He+4GIdF?=
 =?us-ascii?Q?kILgDbI+omf5WqXN7fvrcokMFpRe7+ZzAPyaMZ3wAwE1rG/lSZckfVPtE076?=
 =?us-ascii?Q?Hz3ntqupt+J31GMWoRrMjzjedS3EzG5Oa17WTa1YY8bmG4idOLQTtY45AQns?=
 =?us-ascii?Q?stP51OMQDUiKPByOfiie5IwQtBaUCds613OmwI0Jy6TpwchwEDp5zi39NDiz?=
 =?us-ascii?Q?w66JD6ekSIa+xIuvLiTly7LzXlRou0pWHfLU7+kHFyo2g22TYX/+zJ89XAfJ?=
 =?us-ascii?Q?7EKQBt7GqRam+X4b/pTUg6y6Dx5lrK65ZZX3CvAE5MiyD5Nr1ahpTaFzwIET?=
 =?us-ascii?Q?qHdzlHP5MdgeR/K32Neg4YT9zSKrRRNCgk7P7dhUvJiJMTtjvoyLzXfv2ffx?=
 =?us-ascii?Q?LXJzIqq1+MUW62K81pfGtkHUrRM9281SGuudPTz6/bhOnyzFi543VnaljYEK?=
 =?us-ascii?Q?29E4uFAsmVi9G6jNLgRCo6JVi4Hub5JfIQtSZJsM58K/g+kCcMbO6sThT/Yv?=
 =?us-ascii?Q?JVelYVgAisg6Y9s3/Aj0zs0xAyOd303J8ZlxoLDqUwO55MfdsIM8hiDKOife?=
 =?us-ascii?Q?P2f8fq8z5miNPBt78N/fIqcS4Drq4S/Vlb9VgOUoU0TToH6H8wbsiR99Vqul?=
 =?us-ascii?Q?v+O95CyaGWbzomT9b5/0HVHSzj7nnIf2OsGQZ84VWxaIOv+MoY0q3phHDOFM?=
 =?us-ascii?Q?atGW9AkMiBsj86gjYjeSqzEzgYU9ptKwCH4kZpBS7ycKTz8PqRo7mw0rHwei?=
 =?us-ascii?Q?DoRD0DfQI1a5bL+fJjI44IXYKbs7NGhyO4lCsWTuFyFWmgyH1hG0fvL0Gwpx?=
 =?us-ascii?Q?31ukZCufIaGA2FiB11M+VBc/jP/fOb4SxcAsCUj2cSpf6BtLneT/28ADM80R?=
 =?us-ascii?Q?J02/VAZjduTh/1ZOxyNeV3YqEcxkWJXOPrczHL2D7JsyyUSxlhHSIHJ3Wz21?=
 =?us-ascii?Q?Agx9g1PhxYSKfCTBoRJW24gf58IeU3kwWsjLmN3duzQx8CPio7AgVfHVuKn/?=
 =?us-ascii?Q?EtKvbtWuCflunOgmsSKuASI8PtW5qlDW9o2jihkSVQgXgNFlmQr+TsHu0nXC?=
 =?us-ascii?Q?gcBeyXdJsVtl8u0IqFB1/aurMRmH9j44mlJEvzr/yv9m6daeGY13Q22Pmdex?=
 =?us-ascii?Q?XNg2jIeZUFvT2MPMuGAgCqmh03bcimlXmEiF7k+F4xJWOsjwVBUz54mX0OAZ?=
 =?us-ascii?Q?f2HBQ3dunFw0kvWecuag/RsijQHKjaQPf7An/3UBlRNStxU3++o1Ou+J1SSO?=
 =?us-ascii?Q?RXAmPQ5pK3WlRCsI5yfz4AWAuoUHc9XIWyzk0HRvyj+TP1qVn3wwSuqt5wtI?=
 =?us-ascii?Q?Txc5Ru0vcNb36eMBy8E/QbcyARF6fzO7HDPaffF4PADhArOSvdR0ijRTVmDF?=
 =?us-ascii?Q?CZXUBZ3Zamrykm+jD2uU9f5RDKkEUmhq950hpeNLQ2ZJZGT9L08aXUqQVVxu?=
 =?us-ascii?Q?QyhPwNs0c6MQSudBXOlrR0L+4xXTEC+FYFT5Aii3zYvcmClKuk0USwWGOWKQ?=
 =?us-ascii?Q?5g=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3533e1dd-593b-45ad-2184-08dcceccc832
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2024 23:36:50.8520
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +9AGAQXY3Oz7RC8bulOFZjxaCopuNoreXAH1d6/NdETO0JmP2JZ8A0UGWgIU4FNFII4TYuRlykJkzPFkT4/SCEegCgeuPg2mZtpycIX76Gk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4529
X-OriginatorOrg: intel.com

How about:

    Subject: x86/virt/tdx: Require the module to assert it has the NO_RBP_MOD mitigation

...to avoid the double negative.

Kai Huang wrote:
> Old TDX modules can clobber RBP in the TDH.VP.ENTER SEAMCALL.  However
> RBP is used as frame pointer in the x86_64 calling convention, and
> clobbering RBP could result in bad things like being unable to unwind
> the stack if any non-maskable exceptions (NMI, #MC etc) happens in that
> gap.
> 
> A new "NO_RBP_MOD" feature was introduced to more recent TDX modules to
> not clobber RBP.  This feature is reported in the TDX_FEATURES0 global
> metadata field via bit 18.
> 
> Don't initialize the TDX module if this feature is not supported [1].
> 
> Link: https://lore.kernel.org/all/c0067319-2653-4cbd-8fee-1ccf21b1e646@suse.com/T/#mef98469c51e2382ead2c537ea189752360bd2bef [1]

Trim this to the direct message-id format, but otherwise:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

