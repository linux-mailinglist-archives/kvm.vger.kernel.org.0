Return-Path: <kvm+bounces-17579-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FD8E8C819A
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 09:44:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 17001282634
	for <lists+kvm@lfdr.de>; Fri, 17 May 2024 07:44:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CF3517BDA;
	Fri, 17 May 2024 07:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cmSFoI8E"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE77317BA5;
	Fri, 17 May 2024 07:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715931883; cv=fail; b=lqN4GqCpYmEG3p7HR2DlZI6HzDKTjT84KMh3sU24CP1gwEING5gdhkQVq7ACwfjTaulshW+7F3f4D3z/2fO4Alf9S1fD1HrRgpXDdtmPs0J5mW0TFebaFtjySR3vUq2MykRFlQPMqQ582hKjRI1k/WPeN85F0r2Ho2CojY4qJSY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715931883; c=relaxed/simple;
	bh=FipCAnsd4JUCr6vD5vUtdpUjBX8Ofv+sUg9HGoct0gE=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=gZ+ql+/gdQm26bvIpn0BWrNiKM89hrTw258q7triAmvkBuYWIWvyaxY72ndFECk5tgvyv+u/0srkJIRGN5F9c+CetL+NwiHRVS0EC5H9v2ihG4ZpcEnsclQIWUdwoiNIuIMsYBiLQHUURaW4nPIIvmr2Pm90FrTWLClZh1hOijQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cmSFoI8E; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715931882; x=1747467882;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=FipCAnsd4JUCr6vD5vUtdpUjBX8Ofv+sUg9HGoct0gE=;
  b=cmSFoI8Ewbuq+1cjZ2HQW9/vio5PzE8jFVuyTfC4W9eQtPIQ3cK4Z1gp
   RmcHuFDYUxjTVSgsFT6cCDmSOemNUkfx4H4kVrWmbDIOHws0W3DfN4Cxs
   ZLwEJ0qgudC1OuYUHdSdIaJuOVF6an2rhE+p1pEmL9MqVN4al1RpKM1L2
   XvVISa+0l2lHdJPDI0rRl3FhoYPBVr+8EmS35qdaXIHTwp2H2ASi7Ri9B
   E96eKPyUJsIhs+8Xy8rDKGc+rsTw3VnXsuOtAZlv6AWMp6wQlFZwYs9eA
   AR4rXoqNjyA5OhAXJyqS4ZgFXo/aUjPz1Y7AHb9Icg1fJslbtu+Mew6xd
   g==;
X-CSE-ConnectionGUID: SHrhBzbOT8CxuxFklu5VDQ==
X-CSE-MsgGUID: KKq0ZkHPRYGaZ1aRBnPEpQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="22671628"
X-IronPort-AV: E=Sophos;i="6.08,167,1712646000"; 
   d="scan'208";a="22671628"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2024 00:44:41 -0700
X-CSE-ConnectionGUID: ChVHAhprRrmSydtj4h+HPA==
X-CSE-MsgGUID: VQy+8eU5SsKcSSh2eL9GBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,167,1712646000"; 
   d="scan'208";a="54921295"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 May 2024 00:44:40 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 17 May 2024 00:44:40 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 17 May 2024 00:44:40 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 17 May 2024 00:44:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MHr00duPVTpFtYcCR6UBrt7sspWJAnSlgo6uY4T1zwvCei/AdIn9NgMNmVALqn5e1/rV3O/CZsYUnDfTRgGO7ajhcaNzGirVPxtNWK4dPS8eyME/iugrQJAeOyFhRt7jzt+9YzTCdKgVExpIRjH2383tPCrm/uDZyUNKiAvWtGnrurQEwKLlqwsX3lGa3TKqXnuCLObzSYcYTHU9t+S6oFDrYBGtR5BC0uJTYb6Iy+XAErF8c9UYglU+2nocESdD/j8Fs8lv0n4WpFn6x9rdmcQuEsQ9xlt2K0ZzVWZFTto/4VWf5I+FMp+izUSRNE07CBrFI/D3NoKB+h6qtgyO/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LU8Jme3k/MUnrYoBoAwBheOPsXYMTl+Uw0ZLZ+muQAk=;
 b=RpqYsPrznioCTj7Elw1PyqcgUGSicYbi7OYu5h26JC0M50O3B1O97QzrSXIRd/2rstoTH7vLHGmm8C3sLk35I021pQ4SoLBbw6knffyZ/4+f/w76L+UodWo1PbST+SRWf3N9ogyDn4q3Eeuj0nnYIivDh54Fg7Iob8pp4BVgivdKAADtG8elwEUDHpX41tHcI2QFTYC3GkSUnfDsxUVLEJPtOI4qFD0/pak9BR1yq3+nc/SQ+cZxOpi8/vOgxxrou/nrkbtMhYyrIsfRVfVYu8uINabSgErr6+yDun4czUDKsVCvsHAfWfFCEblo9xWLeAO0anrP48FhTAGh7Vh+kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SA1PR11MB8544.namprd11.prod.outlook.com (2603:10b6:806:3a3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.28; Fri, 17 May
 2024 07:44:37 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%4]) with mapi id 15.20.7587.028; Fri, 17 May 2024
 07:44:36 +0000
Date: Fri, 17 May 2024 15:44:27 +0800
From: Chao Gao <chao.gao@intel.com>
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <isaku.yamahata@gmail.com>,
	<erdemaktas@google.com>, <sagis@google.com>, <yan.y.zhao@intel.com>,
	<dmatlack@google.com>
Subject: Re: [PATCH 03/16] KVM: x86/tdp_mmu: Add a helper function to walk
 down the TDP MMU
Message-ID: <ZkcK29svLIlX3Jr9@chao-email>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
 <20240515005952.3410568-4-rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240515005952.3410568-4-rick.p.edgecombe@intel.com>
X-ClientProxiedBy: KU1PR03CA0016.apcprd03.prod.outlook.com
 (2603:1096:802:18::28) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SA1PR11MB8544:EE_
X-MS-Office365-Filtering-Correlation-Id: 805396d9-f2fc-4f37-c4fb-08dc76453310
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?p7LCWGmSQZ+IiBtWotIwXQWDkMEWLc1jOwxvFGqacNN+7hooKjnlxqBdOE7o?=
 =?us-ascii?Q?UIb40uL1HWK39shNQ10G9AjoWJ0QuWq3L8gUbOjrzcFSGXxfu13wPU8+Cezo?=
 =?us-ascii?Q?kcnHm6iPN2siEUcHXEm1Of74t4QBEdj84E11Gl3FK8fXsOCHYBd6maEaVpf+?=
 =?us-ascii?Q?dX6zM5C6fgUGoGo0Qj0gZLRI9LDsrU8WPPOb21X9H+NhBxdNsEriOWwcwu7P?=
 =?us-ascii?Q?IJthxqaduYZAvj5iTO+X140h09ahJ7RMrxidcShGO621kUCOIE0DH0+D+zcq?=
 =?us-ascii?Q?tEtrmFgAkutjz31NOil5WVYtKRxvJMpKS+wQUbGjrDau8LxBlNJp0HhaEh8M?=
 =?us-ascii?Q?sj5XQlFRjl1uDp7tfCsWcu9qO6pSWyopFMlr4HRwIlnPbQ3fjlC1It9P828d?=
 =?us-ascii?Q?Nw2TOABJETkadTgOj4+h+tD+ydqGTDAQk6TyYUdfcRbTecQ+gAG6YY4n4Yhu?=
 =?us-ascii?Q?93SOFb3FiLEH67xJa72QM+OKq8PXHf1NPctFvCpHlqS/yy1PG5IChs/70TTa?=
 =?us-ascii?Q?uQumDxGfAsWd92oGtUCftXEmYRT8hq26LvvPPfEq24yYIHh7ymPkC1oWY20C?=
 =?us-ascii?Q?yaMm16gXn8M9hKLdry7g8TqJ56QYhBJrwI/dkfUlFhORsyhS9iQovb8nKv5k?=
 =?us-ascii?Q?ShMStHuauazzntgLTiHbMUFDRww2lIVpqbJD9h/R3NFQTf55tiRwFp8GIyKf?=
 =?us-ascii?Q?BB3IJIsn2QTvwhIB0BAbjJ5nofeMlrxO24jAMYULi0O/u8IW5ciAWZmoaZip?=
 =?us-ascii?Q?H6JH/BcKcTOK5Car+GX/VReRg/xkzlHBPw3XCHX/f4FptFUAZNuJQd4mi9LX?=
 =?us-ascii?Q?K3dkl5Bih8HJS12PsQ98hS0RMid8SfFVi4eThkX08Jr9jM1poBXDBu6gZCW7?=
 =?us-ascii?Q?55wVY8wTLNNO42uIBfvyIcBdJvn/NDrpHrY4VbVK8yibMWaBeKvdCeIDcm6+?=
 =?us-ascii?Q?8IIzAJswTtLLqtBhVnMrMUAyHtwXPONAo18PB4AkyaR138661GTSgZjzC7nj?=
 =?us-ascii?Q?on9kQwhkoKJUbsv9t5ipazVvt01twHiiXYaEtFDPWqiA+Ix4zf0w4mDagRaG?=
 =?us-ascii?Q?Par2OumNiG8nhHEAx8uYfbMlq5P8rDp4g/TtXd4dLwpNW3DfoAETfJwKc1Ht?=
 =?us-ascii?Q?8+yC/TtFTM8J6np/w20hhFBOMy3GLAFpfjX1D9U/A91tGEj1j1Nl0SrJtqCw?=
 =?us-ascii?Q?d8jb//ATg8HCjowvjqYMh6j3IBKof4epNvdmGqYq+EqmNd4yRy34EENOm0M?=
 =?us-ascii?Q?=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SFQeo2AHW+JgK8VOE+7TxuLDOpCrJD91iBjaRPtm7WaMdWsNGkmn0RR1+9yP?=
 =?us-ascii?Q?4l3+WTnucytCtGMjHUJL0QUlzomCre/hWcuP88QEtw8Ixd58+oyOcM6KHlSm?=
 =?us-ascii?Q?syIVFslifSh569rBpiZemaUx5T37BLE2y+yw2flMDGDflPxZ4tXvm/KpOhG8?=
 =?us-ascii?Q?7pKbRsAKo3X9ru5E+OklzbyPPlw/f6hXNctt922inVreGWxKFjp48Whv9ZpI?=
 =?us-ascii?Q?dMGNX5Cg93iYTXdg19lpEHzcntrWx2WWm3cpQFpXUNlqTJH8vA7Uh+Y8UyxQ?=
 =?us-ascii?Q?LoZxMixFJ7BE5b21bspYI4/cpu6qmXLxwtTItJLcrGFHs6iJ+4CLk2ZfQBX1?=
 =?us-ascii?Q?cicJxxJAmKb1CJ+CNzD6h1dixLZbOaEVA2m15BAy8w6umu8fWei31CqKR6W+?=
 =?us-ascii?Q?myW/ERS7oy0bK20bRajY9hveMrdtFsSe9TO+WOrPYworVJDnjwj6iix80jJ+?=
 =?us-ascii?Q?fo1NeIaveznjl2mXyZoEeJKy+VIgmdGY/q80sz/Lv2aU+YH6Swc7mHvoR7zX?=
 =?us-ascii?Q?nDHr5q9uusW9dlRFzIZ3WO8VKSqd4yy9ODdT6+dshi3xagEgB7PcrAujN7v3?=
 =?us-ascii?Q?K2O1jsfdKLccjjsRDafWE7ZH41LGbSlZEdOXyc1O6w/nhgUEeyTmPrsxGHLq?=
 =?us-ascii?Q?+QLSrvAdxoejKzS7sAdSNYNjxVvuK5NdnGWhyWrsN0d8do6S9xiToWFMRanC?=
 =?us-ascii?Q?cipQWx7595edfhQgELX5vgyab4+zIMQ4Lm1981IPYW+Pbh0URuTRyy6s4AFi?=
 =?us-ascii?Q?XC8kpSi1ZgWK800OiU3DkmGCqwRQDGjlFksStAbX9PXStHlzAIS96iOSECN2?=
 =?us-ascii?Q?fgZX0/4403CjJEoSA6UJ/sSbTGNF/I3OS6XvohHBwGPt9n3fkjstXmnZ6m4j?=
 =?us-ascii?Q?l9WaIa/T6DhNaXZWoF5xUSIqLewLXFeojfnXduZvQVAdEktsyS9NdOHWRtZH?=
 =?us-ascii?Q?G+UjfRJbUNp0GD8kPN9wfMp4TiEnFnrh7pfAW0DXZWVYw1ScL4gl2BZ1brrv?=
 =?us-ascii?Q?T2w/ua/ostSoynXPQirqgPLCg8ry5jHKuqmF6LdRWQZuUQjsw1NBZzq+1Gb5?=
 =?us-ascii?Q?9qdGpyoKMXtvJn/EZwlDvFvVisogNfIMNPFsqvYDrR2/hrQLuovQLzWkftJ3?=
 =?us-ascii?Q?bB4R/uLddxPn36pLOgeVUFB7ALl5lXk6oAvtZ/cQXY3VOBLSe5/66CHUno5N?=
 =?us-ascii?Q?R+XHhH2P5sIzV8aWPBPss+YHRCfz/fxdyMos4eLXra7IwyqUz0oIHxEDV9rl?=
 =?us-ascii?Q?VHu9cyWy1CjPctEPre+FfefNyHciM41uKyxNX3u6iDrWYsZ+Bp/hx9G+rKVo?=
 =?us-ascii?Q?srjsIu+wavklLrB6CTXKL/QsBpkchMkQHDTORUOc3B+lWCNz8wSc8bkskPX7?=
 =?us-ascii?Q?kXWkeWxhHEi5lqStWtBTJadD+8t//j5kmfSvxC8RvkSM2PcKoylcBjCBBGwM?=
 =?us-ascii?Q?IZseHVs17UXK+YKQSnKP1u0i1NnwHytoC60aIuCihQ+rajCplUt99JBOyr3a?=
 =?us-ascii?Q?Ga1BsOCLSe56L/81L1W9pnNJMiWnE2ARvaBv567ZePUwtRqMHk41z77UDbcv?=
 =?us-ascii?Q?PElTKcxDX30fQEzskgMQag/qKbAONp5DxeCQ4HGq?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 805396d9-f2fc-4f37-c4fb-08dc76453310
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2024 07:44:36.4546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: St5PV7qAmkgudEIihorgZE8inMO6NLkmR6mMSHsyXAjUW2MV7DqFB6cshz7xlZnIbrwLV/b1/4Io5czgxnutzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8544
X-OriginatorOrg: intel.com

On Tue, May 14, 2024 at 05:59:39PM -0700, Rick Edgecombe wrote:
>From: Isaku Yamahata <isaku.yamahata@intel.com>
>
>Export a function to walk down the TDP without modifying it.
>
>Future changes will support pre-populating TDX private memory. In order to
>implement this KVM will need to check if a given GFN is already
>pre-populated in the mirrored EPT, and verify the populated private memory
>PFN matches the current one.[1]
>
>There is already a TDP MMU walker, kvm_tdp_mmu_get_walk() for use within
>the KVM MMU that almost does what is required. However, to make sense of
>the results, MMU internal PTE helpers are needed. Refactor the code to
>provide a helper that can be used outside of the KVM MMU code.
>
>Refactoring the KVM page fault handler to support this lookup usage was
>also considered, but it was an awkward fit.
>
>Link: https://lore.kernel.org/kvm/ZfBkle1eZFfjPI8l@google.com/ [1]
>Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
>---
>This helper will be used in the future change that implements
>KVM_TDX_INIT_MEM_REGION. Please refer to the following commit for the
>usage:
>https://github.com/intel/tdx/commit/2832c6d87a4e6a46828b193173550e80b31240d4
>
>TDX MMU Part 1:
> - New patch
>---
> arch/x86/kvm/mmu.h         |  3 +++
> arch/x86/kvm/mmu/tdp_mmu.c | 37 +++++++++++++++++++++++++++++++++----
> 2 files changed, 36 insertions(+), 4 deletions(-)
>
>diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
>index dc80e72e4848..3c7a88400cbb 100644
>--- a/arch/x86/kvm/mmu.h
>+++ b/arch/x86/kvm/mmu.h
>@@ -275,6 +275,9 @@ extern bool tdp_mmu_enabled;
> #define tdp_mmu_enabled false
> #endif
> 
>+int kvm_tdp_mmu_get_walk_private_pfn(struct kvm_vcpu *vcpu, u64 gpa,
>+				     kvm_pfn_t *pfn);
>+
> static inline bool kvm_memslots_have_rmaps(struct kvm *kvm)
> {
> 	return !tdp_mmu_enabled || kvm_shadow_root_allocated(kvm);
>diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
>index 1259dd63defc..1086e3b2aa5c 100644
>--- a/arch/x86/kvm/mmu/tdp_mmu.c
>+++ b/arch/x86/kvm/mmu/tdp_mmu.c
>@@ -1772,16 +1772,14 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
>  *
>  * Must be called between kvm_tdp_mmu_walk_lockless_{begin,end}.
>  */
>-int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
>-			 int *root_level)
>+static int __kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
>+				  bool is_private)

is_private isn't used.

> {
> 	struct tdp_iter iter;
> 	struct kvm_mmu *mmu = vcpu->arch.mmu;
> 	gfn_t gfn = addr >> PAGE_SHIFT;
> 	int leaf = -1;
> 
>-	*root_level = vcpu->arch.mmu->root_role.level;
>-
> 	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
> 		leaf = iter.level;
> 		sptes[leaf] = iter.old_spte;
>@@ -1790,6 +1788,37 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
> 	return leaf;
> }
> 
>+int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
>+			 int *root_level)
>+{
>+	*root_level = vcpu->arch.mmu->root_role.level;
>+
>+	return __kvm_tdp_mmu_get_walk(vcpu, addr, sptes, false);
>+}
>+
>+int kvm_tdp_mmu_get_walk_private_pfn(struct kvm_vcpu *vcpu, u64 gpa,
>+				     kvm_pfn_t *pfn)

private_pfn probably is a misnomer. shared/private is an attribute of
GPA rather than pfn. Since the function is to get pfn from gpa, how about
kvm_tdp_mmu_gpa_to_pfn()?

And the function is limited to handle private gpa only. It is an artificial
limitation we can get rid of easily. e.g., by making the function take
"is_private" boolean and relay it to __kvm_tdp_mmu_get_walk(). I know TDX
just calls the function to convert private gpa but having a generic API
can accommodate future use cases (e.g., get hpa from shared gpa) w/o the
need of refactoring.

>+{
>+	u64 sptes[PT64_ROOT_MAX_LEVEL + 1], spte;
>+	int leaf;
>+
>+	lockdep_assert_held(&vcpu->kvm->mmu_lock);
>+
>+	rcu_read_lock();
>+	leaf = __kvm_tdp_mmu_get_walk(vcpu, gpa, sptes, true);
>+	rcu_read_unlock();
>+	if (leaf < 0)
>+		return -ENOENT;
>+
>+	spte = sptes[leaf];
>+	if (!(is_shadow_present_pte(spte) && is_last_spte(spte, leaf)))
>+		return -ENOENT;
>+
>+	*pfn = spte_to_pfn(spte);
>+	return leaf;
>+}
>+EXPORT_SYMBOL_GPL(kvm_tdp_mmu_get_walk_private_pfn);
>+
> /*
>  * Returns the last level spte pointer of the shadow page walk for the given
>  * gpa, and sets *spte to the spte value. This spte may be non-preset. If no
>-- 
>2.34.1
>
>

