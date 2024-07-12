Return-Path: <kvm+bounces-21464-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F74492F3A1
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 03:44:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AA9311C22129
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 01:44:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28B0679DE;
	Fri, 12 Jul 2024 01:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NayDDShJ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805C91373;
	Fri, 12 Jul 2024 01:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720748636; cv=fail; b=PkE7f+tW7VeT2GdBMKL6EcQ/npvRFRWFfEh6Jol9UcdkZcZaUkWZfSOQupdNNYISxBYpXIUV5H54da0winDJEOnGGW0l5gySSo30v3o5095Ri3eSdoM9qYAbt9lfxlMsRG8gSW+3kQPE59I1NED+JZMXWA0xChhMmml/sJwQ1Yc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720748636; c=relaxed/simple;
	bh=3N5OV6Kxbco5cpDJ2yWlLCyPmhrJYxxe3oZR9q4BQ30=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=AdVqwr3QA1AT8OJGjzKmwesTVdchDp550e6bCPWN5HkGBQ2WLnp28UmwVwzLhw+9rQ+8EvuXb1s+/ufz+zGHzf+pAjAdfmmm4ZKYMO1G+zS8DvlyaXU2ismHSZ4eymjkcAOlRaEZXZthvwqqbPs8hifRM9N6Oslx9Iod65Soxp0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NayDDShJ; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720748636; x=1752284636;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=3N5OV6Kxbco5cpDJ2yWlLCyPmhrJYxxe3oZR9q4BQ30=;
  b=NayDDShJ54JEirrUIppDzWrDt6i9/iSdmjCcr4dFN9RvimdlH0YSwK3j
   Ao7gwy26Ow85dooYXTgBEeWPO4DcqYziepamB5IFy3cDajtdrqQNssqJv
   Q2xp2hk6urh6PVBaGNvdrUL6TrcP9LzjdFk67GP/u0GQRmM43MBuwLiAk
   Fb/iKIjw2KJnaXgLuX/jzMETvIrL56Bv87340qe4XPtqw5rE65nibJrbA
   StzVs1oodXy4ApnsidZmVZ4GY1hFdUKQEViOPy8AHcckrL9WY+ciwkqyf
   FLNAuNDKhDDJQVpf39tt5qo1hQ1H6K/rLL+rAF+KF3UKK3LEocEjZkW9y
   Q==;
X-CSE-ConnectionGUID: jV9fF/ESR8mTFx5L67eZTw==
X-CSE-MsgGUID: 5230AeNDTxG19rCgkRw4Og==
X-IronPort-AV: E=McAfee;i="6700,10204,11130"; a="18311598"
X-IronPort-AV: E=Sophos;i="6.09,201,1716274800"; 
   d="scan'208";a="18311598"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2024 18:43:55 -0700
X-CSE-ConnectionGUID: hIYKMTV4QyOwL1G516S1nA==
X-CSE-MsgGUID: JPhs97rJSoiVu0C5Tn0Dsw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,201,1716274800"; 
   d="scan'208";a="53141219"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Jul 2024 18:43:53 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Thu, 11 Jul 2024 18:43:53 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Thu, 11 Jul 2024 18:43:53 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.49) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Thu, 11 Jul 2024 18:43:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c8M3t/NMmEoR4FZ/L4ilkis/NUCdsola6ye6hsVGPo+srlsY7YvFTbV1mDmrZ4AD37lCbbf45+hHjwGkG16MBqoLRnUK5iFOx4BZ55YF6FXKmATFpm66e6GQL4auFhKt89er9fMFi5P5Mi813Myuben88t2JooxaNLMea30ioHxLOQNboF6V131Vmp1d1RzFwpbe4zffLZsVMnL3fOG4DfmPGw9+CtUv611NxfTD7IdDw+3c9Le8ywp9Yepg3sel1gw8CHKYvC2j2xf0pqRUPG9KUdskPGeNgilW4Y3glzAoCPy3Z/8ZYpKT9Ty8TSaaqiN4Z/SWQTgWTdKw0Vb9vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r7VWYNVGlSpMCUu+0/sGfpJ0Zu5CiRJ1OzMtabi7NW0=;
 b=L6oPk9V7nseVHvmuZ8AE60HnlQxmSRm9nkJ0XFujG7ht7MOeqs/DLGZN5RptOhe02qg0WVENJjbRv6m/IuEFJnoj6ikqJleKcU0akFQoDVeWSkJ9/yjum0IOy4KuvucV+oAYh0BKaS0zRRgXxOufP5H2AFEX6vMH4ly9cwuBFNKIRUtlbKORAGcKHD5JfUqDTCXUa9rjOvLFU8PTLfAXh4mYZlq0n3pw6NkO1IWTFElLNfO4zt8GKPM22tzsMFejfQvvbXyVKeue5KQE9XjJGuVpilmnM757fKDIA1Qyx9PE2y1U8LtDnH2BDKyq72Z9P2vGb0jnvcQyZX5c6mz0JA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA1PR11MB6757.namprd11.prod.outlook.com (2603:10b6:806:25c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.23; Fri, 12 Jul
 2024 01:43:50 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%2]) with mapi id 15.20.7741.033; Fri, 12 Jul 2024
 01:43:50 +0000
Date: Fri, 12 Jul 2024 09:42:29 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v3 13/17] KVM: x86/tdp_mmu: Support mirror root for TDP
 MMU
Message-ID: <ZpCKBSS6fB9s30Wp@yzhao56-desk>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240619223614.290657-1-rick.p.edgecombe@intel.com>
 <20240619223614.290657-14-rick.p.edgecombe@intel.com>
 <ZoZiopPQIkoZ0V4T@yzhao56-desk.sh.intel.com>
 <81b3bfa46a457ba19ce32e7a34b793867ebeebbe.camel@intel.com>
 <03eccdf96e917e178acbc3cc53a965328a5690b6.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <03eccdf96e917e178acbc3cc53a965328a5690b6.camel@intel.com>
X-ClientProxiedBy: SI2PR01CA0007.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::11) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA1PR11MB6757:EE_
X-MS-Office365-Filtering-Correlation-Id: d5c5c458-2f67-48b3-3e18-08dca214147f
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?nK/ncV2lBYxWVQIvRhmEARmjBd8QXN7wvovDsWrm9fbHhgPMA5gsfIp9LozW?=
 =?us-ascii?Q?NvkUXxlgZIA2v3fczG0BLiAvNGA7Wqlw9WhMCY5lkpvQaeqh3keeoa6Et12O?=
 =?us-ascii?Q?/0rcxXWAnQW2XQAtB+metarg2H9fQlmk/xQ9LbjJiCCV1Jl+El8btHUVo4gQ?=
 =?us-ascii?Q?OjRqpwUgzEbnHkU6qVXAPy6lIwpO0RjFnbSbLYdCmqH18vITcBnm2RFDva7a?=
 =?us-ascii?Q?fNxInngU08dMbh+cWHk0VIS9m7ChBAvJtnxAIN+9j2LPVTuiRlJJpUt378kZ?=
 =?us-ascii?Q?sm0O0+ImbXaz3l1+JdnsTiwaGM03OJ/37Sx69nD5zTHygMzsesPKat8WkJXY?=
 =?us-ascii?Q?92V4+hbqbcXzds4MJLkW5GPFNXWpyrJbjRN9iDwOw/Ctz8ERGVUCalT6iSJY?=
 =?us-ascii?Q?jqTqbe/RDqkIPChGLXQo8brUKjpsBJ0XGPYCgHuyM1kFIXoak+Px6cu/H49m?=
 =?us-ascii?Q?4WEJQWKGxkBjTYcKzbmgAb/9q0T891udFG+ssRAX7BOZSC9u98hrLXRU6mKs?=
 =?us-ascii?Q?nZuQMKzpfs3Awv+HYJdqfr+cDh0uEoWtVGU10Baq/8JPkhPtaax/RrLFBCKj?=
 =?us-ascii?Q?S3LSDY2q1qAgZaWjhEAOO4+Gw0Ewx7UVdXU2G2Y/3hHXalYF7m3oHV53LhUz?=
 =?us-ascii?Q?+tQjAd3CG7GgA/MR08jPbn8se3FhaXjKkz6LzKBP3SQyTtLcmpMsuHYhYFHR?=
 =?us-ascii?Q?EizmjU/Dbx7OrSy0dLwBToFa15zfuMjFJNMeLRgFW9hPFFA0WcZ3wQRx0obP?=
 =?us-ascii?Q?vWmDIfDqPmKpANXmKpAVqeMCP4G0BQ+aRHuclLxARIzLyGfTpajxZbMIIy6p?=
 =?us-ascii?Q?NtAt125Z6q7wUpr/h990MtidRhC5mQxyngE3I8JXLXT92SbAdYd8Q9minpmT?=
 =?us-ascii?Q?wri7gmF4/wTGTYjAkL70FtOp8Y+IXSDEdobTL4pFLWCIVtI+SbqmyPw1tT9A?=
 =?us-ascii?Q?LdZe/mYS5sryQKt6Nr0ksHTlW14pPs1LJGRzxE9UJfreOvdBKdAhPwjDg4hC?=
 =?us-ascii?Q?HKefdFEgwUnHQWr/KauztJXOOmTx2okdRbId6iwZwzxFmf3BWag3rNc51+Ge?=
 =?us-ascii?Q?xea/ja3q4jN/9PSWOre+7lm6sBrjj9QMES3edIEfEVsql9MC4HIkJVpT/HT0?=
 =?us-ascii?Q?dpaS1o3MGFqg94w/Vt9kZdEvn1PR52mv2HmMS63AKLLivYFAx02T1GfwFSPT?=
 =?us-ascii?Q?Fd/YaRLQZMiQ+w6KikE+wcEuN6MiC0wJbHSy6NYMUUyA3O9rsn/3M6Rjk+zU?=
 =?us-ascii?Q?p4RUzXKX7oAEnA4auSIa0u2hKBI3DkfNF15gUVa1l10GF5zrIp9wubR/NxLM?=
 =?us-ascii?Q?2dVe/E1uUYtTRBlVCSJMpQpWHSxyhagt/pVw3ltk1qxfzQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LTCWmRIv4WlPkhLCpqmHfaE9NpJdbFVSJE7lE03fDZpFoZYRK1xUNQCIq/gP?=
 =?us-ascii?Q?6NPT9h7Js7SnwLAGHVI1TL/xNNKeEdPIRQ2pkA+ViaMCX5e7m4mzoHNeTxp+?=
 =?us-ascii?Q?sxWPKrB4o2K96xF6A7FiT3DIZ1sxGuIPzcQs4xxG8EZbLFxuZnp/qsa6Byy8?=
 =?us-ascii?Q?AX7+pxYxkNLFK5gdIIu2982kdvPg7bbBoPgaoy+PKhR7gRx6/fLX4tbgSeNV?=
 =?us-ascii?Q?HPMFN5VGSKLl9Iz7refyrVuxgpE2krbvlul0K+pXKivDsA7gtc+OdPQdpX7K?=
 =?us-ascii?Q?C7EKdw/cGi4cvwAIDPu0O4NNSjrGUyZD7h/xbCEOsmaBlwb+lWcDpfRF9VdZ?=
 =?us-ascii?Q?4/wy+aTrbax6Kt9Q6uplX+9WtnNKpsE+nToTKJrobUd0Eg+ViBIAhZC+vKiR?=
 =?us-ascii?Q?7k0I9bxwm6X/0GswviOs70OaI+uH5AkGwj0p2DAQ0FG5sKjWFVR2PleUXaxU?=
 =?us-ascii?Q?KkBRF13+ndOztSuKlvD4X8Xbsu5ETH0K8qHUdE+oL0okD6PYuuHONmcRi7hb?=
 =?us-ascii?Q?x5a3MP/MniKtEOoLGdxxRWiJ+FoFcrjMAXQV0akoxAcBMqeCsRM+MLsJDmMT?=
 =?us-ascii?Q?US8w5KCKx7jZb2e1AHmL6r0k4N9yp+w348HES17b0Pe2nLiciKWk0PvM2m5K?=
 =?us-ascii?Q?ShgkXoTV1IUtpnHpHchXCdS6n37lF89pNn++Fdjmhv0WUpsdKn2gZb9eHL8G?=
 =?us-ascii?Q?hQbneISZ2pA8CYofsSvv9kR8emBTMLr9PLv2Wvw1mEl3oUJLyBAmfIDOis16?=
 =?us-ascii?Q?vT1cLAVJkO++kqKNwb5JpcAR8HrZL6rZTnqAvOsN0R6y7jF0NLi7IwE/AEjh?=
 =?us-ascii?Q?U3mm7RI2v5TT7yaJlHrG+8Owc7bueuvTMmZsZnLFMWNDw4M2c/eQp9YQ3dem?=
 =?us-ascii?Q?W9VV4Ub1rifk5qs16QPP6cuuxiVBsbaTd+MU96fm/73ALC2kDJoP0uBRWNp1?=
 =?us-ascii?Q?IeCXpj6mh/BZJj0ADvSOZ6gQsqIj5EqM3kCyU41A/SxHG9BQnHGwQbAWZHGx?=
 =?us-ascii?Q?tCC5gzgUSB7iqA0katAYfXIrftji3oowvc3G8WkiIdKoUperb9XkvinlPhzM?=
 =?us-ascii?Q?RqcgvWaz6zPlc1oMNLrEKeQAXHPvbBiaFQ+uD6fPV/itsrL1A2t227VDht8G?=
 =?us-ascii?Q?TyNkt1lIoJWfLhDVM+rlJXHazs789tfg/MsWh4EbXZrqaKrjRs9NBA4ctgxo?=
 =?us-ascii?Q?KKt4JBpOKdz4hgcxlx6DaAIAZuG+FkZRL3TP+aZVKB+m7SWOqE38gxtjPDTj?=
 =?us-ascii?Q?01D60i8xc0agiGq/xGhv37oZHBRjem9cZtFIKAtGwuee4Ct/2QM6wao5+SNR?=
 =?us-ascii?Q?wj8NWeoacfy8jSDWlSjVyhRdjMMN8Usxor7/WbSfa1c3aEd70Mxstwm1BPSu?=
 =?us-ascii?Q?Bf4fpFZqDHzjocOSeN6aNKd7QGRX0XSrPgjocAHrGa5EWsaZwSuSZjAJlZEr?=
 =?us-ascii?Q?bBYJ0N8ts8iNcgZUQtuNe64G6eYOmmjdtNxpWeIUWBxxgSqoANS+08CPW/8Q?=
 =?us-ascii?Q?Xmxxtr/KDLeWF5aUGvR4lPMFlU71gfahsiQVdEkLfv6esWsX+yU8KFxoRygf?=
 =?us-ascii?Q?05UzeD7m5Ct3crR7lAYGct2gkPzcGGorCzIYVht3?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d5c5c458-2f67-48b3-3e18-08dca214147f
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2024 01:43:50.7539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ft+PPcTlE0IB2GzbbgUvJnq7IUPrtPYuf/uw7EkVS5RPuWXc/B1BY1pD/YBfwjaQPRpyb9iCkGLDMxVwNZtt3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6757
X-OriginatorOrg: intel.com

On Fri, Jul 12, 2024 at 07:54:50AM +0800, Edgecombe, Rick P wrote:
> On Tue, 2024-07-09 at 15:38 -0700, Rick Edgecombe wrote:
> > > Could we move them to tdp_mmu.c and rename them to something like
> > > tdp_mmu_type_to_root() and tdp_mmu_fault_to_root() ?
> > 
> > tdp_mmu_get_root_for_fault() was proposed by Paolo, and tdp_mmu_get_root() was
> > discussed without comment. Not to say there is anything wrong with the names
> > proposed, but I think this is wading into bikeshedding territory at this
> > stage.
> 
> I kept thinking about this comment. On more consideration tdp_mmu_get_root() is
> a problematically terrible name since "get" usually means take a reference to
> something which is something you can do to roots and (and what
> kvm_tdp_mmu_get_root() is doing). So people might think tdp_mmu_get_root() is
> taking a reference.
Right, I have exactly the same feeling to "get".

