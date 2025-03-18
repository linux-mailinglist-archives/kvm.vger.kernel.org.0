Return-Path: <kvm+bounces-41345-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 31CD9A6663F
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 03:26:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 092D37A9D3E
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 02:25:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9DB518EFD1;
	Tue, 18 Mar 2025 02:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VRbh5Ua8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE8F1E50E;
	Tue, 18 Mar 2025 02:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742264758; cv=fail; b=cKbfi3oIqMnD0rLwsQSNEcU9svEhqOs/EXotfXPlMDHZSRdEVocv62bX+BZ5dHg1hfNsE7qFkas7a2x892Tj024kI95Sl3XKNfAqhstgvoNTPmxlloqDdIkJV5KH49TkM3poLO0bJYHevrrdpqVstVg1rfgx78QcwO/5EAPUgbo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742264758; c=relaxed/simple;
	bh=jm5/WB8QnMQzQdLxZSlF7QYfV/Cr5R5sBx2foug1jsk=;
	h=Date:From:To:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GpCKVKsTPtKFlkX12W2QkVg6FUlpQxLOntv0DeRpRnmS0lsGp0tIYBOb5Vb2zACHEKYFSy88yY4na80mPJ+S6JdCLARRRyxc5BbdgmNEgGGO103kyFqqRXYJ1GLLgIsJldp2B+SdjmNLuqwzNGY59G7OMV3thtPKIySwMSM0n/o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VRbh5Ua8; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742264756; x=1773800756;
  h=date:from:to:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=jm5/WB8QnMQzQdLxZSlF7QYfV/Cr5R5sBx2foug1jsk=;
  b=VRbh5Ua8E7EykqIipCzRXuA/kq1DzaFtXGK9KCfZKenUKhnZ7At8IgNS
   ao09PDZJFDM1aUPn2EpQZi0ihcyHSLqKidbDWRQD/iFsZptK//qBIybWE
   QJuDvWvFBVHoT0jvfaYbxEmoSfhtBf64fqMbg2f/+F+j1CxgY8ehoFUY5
   oNW5QgDxNDXiiBe802ioibEwXciLCut6QpJB2Rqm5aPYUXDDhDPancJuC
   Zxk0XXg+OfG0Zc1JW2rFNstRlMzWH6Q1kVxzkCj8SQEcOj5Q/izU+H5hZ
   yTt88roba5bTNBM69gHi5dACvf0AJAXGrFGfShI+zkxIRFqca4xT5gN9V
   g==;
X-CSE-ConnectionGUID: InDA+GCfQtCmMumJZIF0Ww==
X-CSE-MsgGUID: ij2XWIK7QRWkvMmj0fDWTw==
X-IronPort-AV: E=McAfee;i="6700,10204,11376"; a="43403370"
X-IronPort-AV: E=Sophos;i="6.14,255,1736841600"; 
   d="scan'208";a="43403370"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2025 19:25:56 -0700
X-CSE-ConnectionGUID: vSqQ9r+FQI6UlbuHfc7Dgg==
X-CSE-MsgGUID: YzbEdU9uTFKPo6AdhBg6iQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,255,1736841600"; 
   d="scan'208";a="126968836"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2025 19:25:56 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Mon, 17 Mar 2025 19:25:55 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 17 Mar 2025 19:25:54 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 17 Mar 2025 19:25:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ca8wnD3swvrgU4utyLAWm1CTVbk9kY59u4lWu/m0nC9yWQXUKBwBKlfrNZTqI3AJWOmTRGgKJ7x6CMlj5M25U6uV2V9ZOG1ihqBfE7suMI70mUEh/NXw3fAJrTS/iatjzzrk1memtblF05+s4nsVgcb1f7Tb2K4WWM3yRZ9K8bVzdSrlQiJGtmXhIKFFz7a0rlk4IiR885zM4lkxE82UOcGgodD2px57OkGBjPCsb2dy/7ZGjIsJtdkRlUtSzrZ9x2PXsa2zD8pwit2m+Qrrtpswbl9CTosl2bucovCirdaZ3VNqW/kfB7wqP912pXt89YCB11bCaM+Pf1GEqVO5qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DNTHwALHojZdJuCrpvxK/WVqMew/1KgKg3yfSbCqg9Y=;
 b=Qc5JOywVOnDur/rQLHNdjx6H6M0Puzv9UjpUyJbyqimPNY/2F0D7V7TLQGDQ02tBbItj24TXN8GenS8KJf6W+vclDOUtkZ2zA3bldg6mGXeRSMICKype+ZMlpknbM8EvjoDW9xQkeheWC/KOE6u7JJpiXllQQGr4ptekYmJMsonxYlcDCO4ZqHt1dyTsSmm+FAwNkw4YUtgvRbxkxWEvmf4Fz+J3YlFdnkbJ/q0o6PwNSak6EAVpS1zE3GMgJxLv6swl2TJ7py39HDmYAWETpmUINwrvjevrNzwEC5RwqGqrNrfD0T0JAi88oTokRxyn9JFpjQER2n7YWs/HAUJwDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA1PR11MB8788.namprd11.prod.outlook.com (2603:10b6:208:597::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.33; Tue, 18 Mar
 2025 02:25:38 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%5]) with mapi id 15.20.8534.031; Tue, 18 Mar 2025
 02:25:38 +0000
Date: Tue, 18 Mar 2025 10:24:05 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: David Hildenbrand <david@redhat.com>, "Shah, Amit" <Amit.Shah@amd.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Roth, Michael"
	<Michael.Roth@amd.com>, "liam.merwick@oracle.com" <liam.merwick@oracle.com>,
	"seanjc@google.com" <seanjc@google.com>, "jroedel@suse.de" <jroedel@suse.de>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "Sampat, Pratik Rajesh"
	<PratikRajesh.Sampat@amd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Kalra, Ashish" <Ashish.Kalra@amd.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "vannapurve@google.com"
	<vannapurve@google.com>
Subject: Re: [PATCH RFC v1 0/5] KVM: gmem: 2MB THP support and preparedness
 tracking changes
Message-ID: <Z9jZRdFyyr1DFkvV@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20241212063635.712877-1-michael.roth@amd.com>
 <11280705-bcb1-4a5e-a689-b8a5f8a0a9a6@redhat.com>
 <3bd7936624b11f755608b1c51cc1376ebf2c3a4f.camel@amd.com>
 <6e55db63-debf-41e6-941e-04690024d591@redhat.com>
 <Z9PyLE/LCrSr2jCM@yzhao56-desk.sh.intel.com>
 <18db10a0-bd40-4c6a-b099-236f4dcaf0cf@redhat.com>
 <Z9QQxd2TfpupOzAk@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Z9QQxd2TfpupOzAk@yzhao56-desk.sh.intel.com>
X-ClientProxiedBy: SG2PR03CA0126.apcprd03.prod.outlook.com
 (2603:1096:4:91::30) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA1PR11MB8788:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c643abe-6585-4dcb-fc39-08dd65c42bdb
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014|921020;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?p6mrIS7wfdONG3CFODJead75fe91BFDTRjZJuPAMk5VxcrSLygTd7rKyvwmM?=
 =?us-ascii?Q?Ri30XD+e1ByUoxzp420QG1vOp/4t+mwY1pNRWMKt1fy1png+fQ7PtxyNP6qv?=
 =?us-ascii?Q?myHovTCxfu/o4xrqgExEwDE8r7S14NJsW9TC3UgfXOWSUwRF0SncTh+KY8g2?=
 =?us-ascii?Q?4Fra/CN2oUfWDXp7Nl/ELWuGMiccZyyzefHEa717GX67B2uzh27jvHXbWY9Q?=
 =?us-ascii?Q?74JIiDCv0tZ3DdeBSGtg2GncS9g4Ex6E7o7SnGgGIZ1aQRRvF4XPVJvja3LC?=
 =?us-ascii?Q?9Eq3lw24PhYQQxqT8vHBJl9PzPxqbPB75nfTe2G2IbSPGJUr6paJnYnL2M1Y?=
 =?us-ascii?Q?P8sYqUQ0nD+rbMtNPXqFV6Zy/AbXFCfxi8Yr/72kW6223KR4O/y9UedfNfKQ?=
 =?us-ascii?Q?s3Wm01xK2gMSqe4QpqCKrPK5UcRzMfEYTVZs7rq60PvmkDqqfz0ylnPAld5v?=
 =?us-ascii?Q?9U/2YtOsaqrt5S2VoXoRpRKz0LITPQNavsMWha9UlsxXc59s2kQoihq5hB4t?=
 =?us-ascii?Q?MU026cyjtKXRjm5EXTIPvh7ix59nisGH3OO+SjqWFiJYQ6K9oO+KSPkDAcvy?=
 =?us-ascii?Q?Izd0cAFVdY3lAROP4IOrhS9Y7nnlppCjWfWo+rY2aCp4yvtNpfEtBILHRCoN?=
 =?us-ascii?Q?2YAKgih8g0c4yT5YEEkesle1YVRbUARFcOLPYVucYmrD507sjMGsSA3EBx0V?=
 =?us-ascii?Q?wVJJaJiGMQWIM1r10yYHeNP2qRlYvrJs1/X7btsk/cvR1G7hkWVaFdqq+PSq?=
 =?us-ascii?Q?lKxE+j980UZ6iR1vnxKxkCtAZ7xZ9UTFBozMPVOsDlqKLEIX23ChZEoHOmnR?=
 =?us-ascii?Q?BN2CDCxaS7hgI+KTuJIDtTNzuAGk7lNWW7TG3/gf9wFDYed4NwsqRs5gKKcL?=
 =?us-ascii?Q?3ex3oBmgVsQ1zhv/DPfj9FXA5GinK1l3LJRlG6Ms2qUPwgpNU6DgDV0IwyD+?=
 =?us-ascii?Q?ePwHu3zlLL8v72bXebQcw6GhdNZKH338TkUDb33dQgM4nZEZ3JUiwVS1Rg0D?=
 =?us-ascii?Q?eJh6RHRStxgNTNeL19EXa6GdTQseaMQX954Dj8ICy+s897tOwaJ3Z6sLjPsP?=
 =?us-ascii?Q?iwDdfJDU5JHM4n9c9NiSeSSXcrFlaEXCsHoxnPpkeClxoU21EYXuJuow6RM8?=
 =?us-ascii?Q?ryJC1M4OtdwDkhTLsKTrJH4DVyRqpoK4zC1dyfVDalPGZeJ9PKaTTUlJNj7C?=
 =?us-ascii?Q?uxLT5ybbRPuf7LX++9S9jvBr90GgQKnIqbQCIdLLg20euLneIEit8M4fUNlJ?=
 =?us-ascii?Q?GQmn2E/3StGCVAVogOVnmc7bX+CH7+KyTJdJRO+8IM+/qeQtYEQqos1DxzHj?=
 =?us-ascii?Q?+0+zWWsmMvaHb8xhS3X3mmj2cmH09UKEkgm00dGVOZQ7VLqDOvPRXhe1PLWn?=
 =?us-ascii?Q?3BUoW/25uvfuytkvYz3xPV0oucImcIejsbRcfv/mHD29z+z7n0oSqO9GFRQo?=
 =?us-ascii?Q?ixSRyyjO3Cc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ZZiPYQ5NqHbMjPItwcqNJc82BAhdspwoXs0Xj7HCNYL0YBD4Z/dcxxq8WULn?=
 =?us-ascii?Q?+2V6YPj33NxLGejxlzGcnBZOZ9itIm2GVOUVnj5v6ZCdoOA4vY371YAInufJ?=
 =?us-ascii?Q?3f86vaEzbNRBzpmNKumxCEngwL1gDqEqE/VaVekRojUoyOje+n08noizzYgN?=
 =?us-ascii?Q?nTg3yuwEEBn+d5+hxh4UibKAT8P7tfR9YjQWRFY4dZnxgVZMf4fD6wnVzbYh?=
 =?us-ascii?Q?6aCfp5z2R+siQ3N0XllhNRrFEKk6Oz/YCOFXAXJA7muEiISztbcD5cglf8wn?=
 =?us-ascii?Q?03ByxzSGZljAQR9CU0icK+S4c+U5YjeiVRJWt/8ATvcG0OOTXqCFWkHRnoZK?=
 =?us-ascii?Q?T2fH4Qi1L24JLqNIp0eNaP9u9KQjSikRlG1XzbUPiMWL/c5z7ZboUDY0owDJ?=
 =?us-ascii?Q?HygJdU4AHxiqstYXnvLruLFRrpe71OMHRoVpXts7zUPtS/6M1ym0XthWFysd?=
 =?us-ascii?Q?9JAk+sCvP/4dUobDwsaAMn+c37KGdTIJ22AyIJ7Bk/hvnfA5Gr2Ka6Vh6Kxn?=
 =?us-ascii?Q?QHAdYWgdnl3WOitwf39VefzkSajLuotSjYDsgHcc0Xo5hfc48q24vbPmd5kd?=
 =?us-ascii?Q?vGsh0ASyDQ7aQRcIIrFuhSG7HO0PoOgQlPI1WoemErzRmlfKLyYQKPpPvw9g?=
 =?us-ascii?Q?W1+01WmtgPyZAxwznciveUze0Vza8Fx+oeyczwyK29pRQhzdZWrcAgYvaG9f?=
 =?us-ascii?Q?gdvvwc7sVuERlGHcGzD6AYZwipTyPbO5jKFTWq/HABUJr/+BLJSuijJUJi9F?=
 =?us-ascii?Q?dW6YfyHYHojSB/tnPbdJPxnCXsb/Srw6xqjksL7ONR07aFtLRp4K43snMQAP?=
 =?us-ascii?Q?9jvq32tk0OMWemu/wZTwNLtnFO20ZcF9T5Ze0ZKL3vLsdYUzoDVuhtA89iVG?=
 =?us-ascii?Q?deVTrBeQVqX/32DtuxnkGvwVnPia5k4CDWaBrQctygEZRANDEJFVJhhy9IR2?=
 =?us-ascii?Q?pc6yS3oQFSPxjdI1VostHFpTLeX+2exgX6FfgFNcndJMShRH4pJsva939rjn?=
 =?us-ascii?Q?JS+xh1uUTkdupUdKbwhF8A4DAVaSalRwRkPTgj+dXJY3omzWw4ALtW2k0qCJ?=
 =?us-ascii?Q?Dg83p7ZZ30bxfoyxHr/g3Ax18Dp8Hub+JvCmjU/RXjRyiwl/8Fu49UD3UneK?=
 =?us-ascii?Q?cyjG1ZA+jt6RqO49Pxy/6ub7+Pv1MBBL9L+nblNMbeyD0zqAfYeRuGZeUfGO?=
 =?us-ascii?Q?Jlwc16/dVe0vsZhoCXsfcyC8LJY9wCNKS0Z5dLGfrN8LxekW7O4UlFjBVqCa?=
 =?us-ascii?Q?j/1qknCxMA+ULf0/VSyz1k7PsXESyBVrmdD2PI2YHhW/82PCrL3X6G5i2tQg?=
 =?us-ascii?Q?DwlN6cLMpGdGOvxhcuOaowSWRQn4O433qXTnoKTruT5iAFRm42bAwp82jtKM?=
 =?us-ascii?Q?vUdB4rpZygUa9kCqfpQZkFWOp1Veo2NY3ncnxDdhaYH0WVGnT6VM8Stpk9hT?=
 =?us-ascii?Q?aSG+lTjNBPkvGAUpaHite7cdoQ6Wis7Urxnbd5JhMri7GzloNZdQjTSoRQS7?=
 =?us-ascii?Q?0Awu5f7+WBTCVcRRZEDO0BpfHYF5iLgbF4Afw/vjE6waFOy1YxP6W94b9boI?=
 =?us-ascii?Q?YbzOr92nOdH68LaVQTEEQBxv+q+y4aN6nQKQJzUH?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c643abe-6585-4dcb-fc39-08dd65c42bdb
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2025 02:25:38.1961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /Ul7YzPlGMluOZCRgbDyEZ4+cYCNDcjuwmHSyUYf70KmcUZNB/z/Jlbb9OTEXBzjsft+OufEv0UBa70xCSqhPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8788
X-OriginatorOrg: intel.com

On Fri, Mar 14, 2025 at 07:19:33PM +0800, Yan Zhao wrote:
> On Fri, Mar 14, 2025 at 10:33:07AM +0100, David Hildenbrand wrote:
> > On 14.03.25 10:09, Yan Zhao wrote:
> > > On Wed, Jan 22, 2025 at 03:25:29PM +0100, David Hildenbrand wrote:
> > > > (split is possible if there are no unexpected folio references; private
> > > > pages cannot be GUP'ed, so it is feasible)
> > > ...
> > > > > > Note that I'm not quite sure about the "2MB" interface, should it be
> > > > > > a
> > > > > > "PMD-size" interface?
> > > > > 
> > > > > I think Mike and I touched upon this aspect too - and I may be
> > > > > misremembering - Mike suggested getting 1M, 2M, and bigger page sizes
> > > > > in increments -- and then fitting in PMD sizes when we've had enough of
> > > > > those.  That is to say he didn't want to preclude it, or gate the PMD
> > > > > work on enabling all sizes first.
> > > > 
> > > > Starting with 2M is reasonable for now. The real question is how we want to
> > > > deal with
> > > Hi David,
> > > 
> > 
> > Hi!
> > 
> > > I'm just trying to understand the background of in-place conversion.
> > > 
> > > Regarding to the two issues you mentioned with THP and non-in-place-conversion,
> > > I have some questions (still based on starting with 2M):
> > > 
> > > > (a) Not being able to allocate a 2M folio reliably
> > > If we start with fault in private pages from guest_memfd (not in page pool way)
> > > and shared pages anonymously, is it correct to say that this is only a concern
> > > when memory is under pressure?
> > 
> > Usually, fragmentation starts being a problem under memory pressure, and
> > memory pressure can show up simply because the page cache makes us of as
> > much memory as it wants.
> > 
> > As soon as we start allocating a 2 MB page for guest_memfd, to then split it
> > up + free only some parts back to the buddy (on private->shared conversion),
> > we create fragmentation that cannot get resolved as long as the remaining
> > private pages are not freed. A new conversion from shared->private on the
> > previously freed parts will allocate other unmovable pages (not the freed
> > ones) and make fragmentation worse.
> Ah, I see. The problem of fragmentation is because memory allocated by
> guest_memfd is unmovable. So after freeing part of a 2MB folio, the whole 2MB is
> still unmovable. 
> 
> I previously thought fragmentation would only impact the guest by providing no
> new huge pages. So if a confidential VM does not support merging small PTEs into
> a huge PMD entry in its private page table, even if the new huge memory range is
> physically contiguous after a private->shared->private conversion, the guest
> still cannot bring back huge pages.
> 
> > In-place conversion improves that quite a lot, because guest_memfd tself
> > will not cause unmovable fragmentation. Of course, under memory pressure,
> > when and cannot allocate a 2M page for guest_memfd, it's unavoidable. But
> > then, we already had fragmentation (and did not really cause any new one).
> > 
> > We discussed in the upstream call, that if guest_memfd (primarily) only
> > allocates 2M pages and frees 2M pages, it will not cause fragmentation
> > itself, which is pretty nice.
> Makes sense.
> 
> > > 
> > > > (b) Partial discarding
> > > For shared pages, page migration and folio split are possible for shared THP?
> > 
> > I assume by "shared" you mean "not guest_memfd, but some other memory we use
> Yes, not guest_memfd, in the case of non-in-place conversion.
> 
> > as an overlay" -- so no in-place conversion.
> > 
> > Yes, that should be possible as long as nothing else prevents
> > migration/split (e.g., longterm pinning)
> > 
> > > 
> > > For private pages, as you pointed out earlier, if we can ensure there are no
> > > unexpected folio references for private memory, splitting a private huge folio
> > > should succeed.
> > 
> > Yes, and maybe (hopefully) we'll reach a point where private parts will not
> > have a refcount at all (initially, frozen refcount, discussed during the
> > last upstream call).
> Yes, I also tested in TDX by not acquiring folio ref count in TDX specific code
> and found that partial splitting could work.
> 
> > Are you concerned about the memory fragmentation after repeated
> > > partial conversions of private pages to and from shared?
> > 
> > Not only repeated, even just a single partial conversion. But of course,
> > repeated partial conversions will make it worse (e.g., never getting a
> > private huge page back when there was a partial conversion).
> Thanks for the explanation!
> 
> Do you think there's any chance for guest_memfd to support non-in-place
> conversion first?
e.g. we can have private pages allocated from guest_memfd and allows the
private pages to be THP.

Meanwhile, shared pages are not allocated from guest_memfd, and let it only
fault in 4K granularity. (specify it by a flag?)

When we want to convert a 4K from a 2M private folio to shared, we can just
split the 2M private folio as there's no extra ref count of private pages;

when we do shared to private conversion, no split is required as shared pages
are in 4K granularity. And even if user fails to specify the shared pages as
small pages only, the worst thing is that a 2M shared folio cannot be split, and
more memory is consumed.

Of couse, memory fragmentation is still an issue as the private pages are
allocated unmovable. But do you think it's a good simpler start before in-place
conversion is ready?

Thanks
Yan

