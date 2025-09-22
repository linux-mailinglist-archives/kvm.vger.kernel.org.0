Return-Path: <kvm+bounces-58428-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BBDF4B93827
	for <lists+kvm@lfdr.de>; Tue, 23 Sep 2025 00:48:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A5CFC19082D6
	for <lists+kvm@lfdr.de>; Mon, 22 Sep 2025 22:49:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DA393128AC;
	Mon, 22 Sep 2025 22:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fVLN91ws"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F7A22F8BF4;
	Mon, 22 Sep 2025 22:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758581319; cv=fail; b=bKXuQ9t33FFdQfRkRD/ZPCxdD9MtB9/dLToJcztIKyDrL3d7/DPT7WDCyolsUS9fmrgkWLBuPEudwN4v35H1JbOGWaD6piXNJxTTXqpLMF1bibInIAUIE0il5RLxbNZX2rhTd85Q0GJ2W1geTDZiY+5cc0IKzjqgJjtySXK5Ep0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758581319; c=relaxed/simple;
	bh=rx/fEhBWFYF4j0THMX/ZE2VpyavSFdE9gPvmdTz+f9M=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GQ27883wasG0vRGIJpuEV1dauYe38CA1r7T6BvEpssIQ/IDLWTOAVHuItyY+ICANkC1KpAjDyVYbjnkKqXOaGtZAPJnyxaTi5CWn95YY4uERZJxqnhKMab5dX232kdyWBDmoLZOmb8Y2h+vNc3daeahhHgXN6MFSVCPd5Dop9m4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fVLN91ws; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758581318; x=1790117318;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rx/fEhBWFYF4j0THMX/ZE2VpyavSFdE9gPvmdTz+f9M=;
  b=fVLN91wsbrgkUnZXAeG6S8aBXrIlvGF5V46D/7sDORMz7P1DtOl1STn4
   jmCIUKn6H/fKJjBazhxizLMwrWzP3hnvNGljankRr+JZ8SXEDRgOCVtTy
   I7hV4Ssl/5PcUdBLEiOTYF8ukyEaO+l9Bcl3rmPZgJLXLruOEtnPza0jW
   zLnHr4GUZ9uYRnCTUE5l6WDTV97ZRpvr6LhX2ll7cCESX4WDWbET1YNGN
   6PVtX5MvrYWAsGm2DeQLiuEkyooq8R1cqDt15Urfy3b7rkPDEfLWO5O6t
   XpETPA11Xg/gLPk3M5B6si2ebb0AEFnD+d9qOwxjGhonejbijMPTy6uLS
   A==;
X-CSE-ConnectionGUID: 2jwiF0eZRUK5hFoztxf/dA==
X-CSE-MsgGUID: 6+F7+/2TQJ+TvvYPZOizAA==
X-IronPort-AV: E=McAfee;i="6800,10657,11561"; a="60552264"
X-IronPort-AV: E=Sophos;i="6.18,286,1751266800"; 
   d="scan'208";a="60552264"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 15:48:37 -0700
X-CSE-ConnectionGUID: tPIRibKTTe+l4hQwqBL7qw==
X-CSE-MsgGUID: KslYxIruRByp93yLtfxqKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,286,1751266800"; 
   d="scan'208";a="181847985"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2025 15:48:36 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Sep 2025 15:48:35 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Mon, 22 Sep 2025 15:48:35 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.40) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 22 Sep 2025 15:48:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=auXz6Ar7j+Q8GyRuWnQM2iJsi0mlEU6RtPGfMVPEhZy8eu7A2Ml6oSEghWKX56C7lFC5R14vhGgbbnw2dCXAD6w7U87Nk1+jyhdsXc/pGSAIsMm+bvNwrKfrL4m+EdD+qQWBuT4oY7zfJ4yrC8yFP6gZSDL015LWNxtMNZMJ0DE7gLRil1mIlKf+/uVUznK1bPSDd+oFw8llpR3Sbuy5uqCd0JvSmYrR2eBTgB1jAvafpMI50KsuTsISy2nZpGZ+EybToTccEqxu+VaV8kWLS0xZRQCoBAOzK5HWkVcD1fso2tuRs5MV50I4dunCsnRW+HU48FhcQKnq/aW6dETMZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TFOID/tv52raxjtz/HnK2Bg+Q6bavFG9Nn8RyUILFVg=;
 b=OttXWPT0ENi1vqApga89CZvpeo7V+dLSPEyMsrJmNmufl5b0D0OaHNYoXg30UwehMRqJXz8kC1kXHbwXSqIz1M4fOIdf4Ckq8SXao4S6BifcL/Uz0mrwkOlw5Gr5d1FYwPLvzLgz8dc60w2b+9J531TZxDL/3b8TnaiLr1KjEKcXuBmQDQMPfCNZot+7AVXQYszwCBI6I+0xfhhI19rXlUEtIQNtMW5Qd5WXPqDmcgXIRWWm7kBk10Ole1cJAbEz8fyezzpfNyXgucjTXqfM0Y6jD/EpQ+TdLBoELDrIIdTsZCJhoOkbQ8wJsicmrSoHfd/iHV2uT4wtO3CvJjp+GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by IA1PR11MB6219.namprd11.prod.outlook.com (2603:10b6:208:3e9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.19; Mon, 22 Sep
 2025 22:48:33 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.9137.018; Mon, 22 Sep 2025
 22:48:33 +0000
Message-ID: <0c110b5f-de24-4ffd-bc9c-3597493bab7d@intel.com>
Date: Mon, 22 Sep 2025 15:48:29 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 09/10] fs/resctrl: Introduce interface to modify
 io_alloc Capacity Bit Masks
To: "Moger, Babu" <bmoger@amd.com>, Babu Moger <babu.moger@amd.com>,
	<corbet@lwn.net>, <tony.luck@intel.com>, <Dave.Martin@arm.com>,
	<james.morse@arm.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<bp@alien8.de>, <dave.hansen@linux.intel.com>
CC: <x86@kernel.org>, <hpa@zytor.com>, <kas@kernel.org>,
	<rick.p.edgecombe@intel.com>, <akpm@linux-foundation.org>,
	<paulmck@kernel.org>, <pmladek@suse.com>,
	<pawan.kumar.gupta@linux.intel.com>, <rostedt@goodmis.org>,
	<kees@kernel.org>, <arnd@arndb.de>, <fvdl@google.com>, <seanjc@google.com>,
	<thomas.lendacky@amd.com>, <manali.shukla@amd.com>, <perry.yuan@amd.com>,
	<sohil.mehta@intel.com>, <xin@zytor.com>, <peterz@infradead.org>,
	<mario.limonciello@amd.com>, <gautham.shenoy@amd.com>, <nikunj@amd.com>,
	<dapeng1.mi@linux.intel.com>, <ak@linux.intel.com>,
	<chang.seok.bae@intel.com>, <ebiggers@google.com>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>
References: <cover.1756851697.git.babu.moger@amd.com>
 <ef9e7effe30f292109ecedb49c2d8209a8020cd0.1756851697.git.babu.moger@amd.com>
 <1cd5f0a7-2478-41b8-97cc-413fa19205dd@intel.com>
 <7c6a4f7e-e810-4d81-b01d-b0cbf644472f@amd.com>
From: Reinette Chatre <reinette.chatre@intel.com>
Content-Language: en-US
In-Reply-To: <7c6a4f7e-e810-4d81-b01d-b0cbf644472f@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P220CA0018.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::23) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|IA1PR11MB6219:EE_
X-MS-Office365-Filtering-Correlation-Id: cbb4de37-01ed-42a4-6b7f-08ddfa2a2873
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NGlUY0lnaFBTTEV6YmRSTDVJNCszYVQyY0NBMlRVaEZYek4wNGRBL2ozdzA2?=
 =?utf-8?B?N0JjeEJRNWMxYkZndnJZckdIbDFNR1hROEZ0c08zamJWRlM5bjcxOHNDU2Fh?=
 =?utf-8?B?clhoNUFZRG0vdnRIL1RZajJBbEFLRk53UHoxZmNEby9qa2RTUnY4T0N4bnRE?=
 =?utf-8?B?NHhlQkNoOWx4TXNMQ2ZZWDc1V3dMZ2lDRGpwVUp5NlZTb0RtMjRUY3pBUXlN?=
 =?utf-8?B?aExoQkNxQTJpd1Zqc1p5QmI1MHdaQm5LTi9UczVidmtTTEUrR2cwN04vcUhk?=
 =?utf-8?B?RnFLRzNVOEgyYlo2VHYrRlprSGFhV0g4Z2tVL2pCVkFKNW5JQzNZSGU5RlFz?=
 =?utf-8?B?N25XZE5mSUNmL3pCSE01K0ZIOFU0SUE1bDdWTU1saEdPUEFBalJvSHFiQjZM?=
 =?utf-8?B?b1R3MlptWjhOdVd1eGdpd2R2bVJzcmhWMEtQVFN0eUNGZGF6ZW1mU3cybTh5?=
 =?utf-8?B?S2ZXWlBxeTZTN2RsOVFveEpweGFuTm5XMDlsSG1ZV0g4OHRxcFpXQ3RuZmRu?=
 =?utf-8?B?YjV2b3pYOE1La2VUTllzUldNWThWcEJaVWY1bnE3L1M3N3NwNXV4VHBXd2Vy?=
 =?utf-8?B?MkxSdEZGQ3YxeUpSMThHT0U2YzFOQlBOQVAvTFhOTHA4MjlhOUExTUNwbzBN?=
 =?utf-8?B?cDlGUzlZV0JaeXVuQVNDWHVXc3RramYxdXk5eTQ4OG1KbWhIQWZ4Z3dOaTNC?=
 =?utf-8?B?ZzJicGdkOVZMMnM0WFh3SytRVVg1UEpjNEJoVTN6c1FQZzFjUmEwT1Z0RUZN?=
 =?utf-8?B?WnFFS2ZhT1l6c1BLNlNqSksvRTNIeW8wbVEvR3dOU205MUZDRzdKY0dtRmhs?=
 =?utf-8?B?SFRhdDFLcWhZNnNINE1KbThDSFBzQ3p1Y0x1V3YwS1ZDWWhjMERvT2huMDZG?=
 =?utf-8?B?L3NtWFNOZk1RanhUVlpNY0pVZHpUMG5lRi9aYjNTL0hBbjc1ZGR6Z0EvWTBY?=
 =?utf-8?B?aHJUZFMyVXZPTW9odFpzdy9RNlJTTXNXZnhjeTM0cndtVkF3a2VxY21RZFp5?=
 =?utf-8?B?bE9OVm9JUTVrNWZlM0UyUEQ4b1FtV2U1ZTFPNGlkbkJrdmo1MVMxZys0a1VJ?=
 =?utf-8?B?NmRPbEdNQiswUS9NdllxdkFLdGZSbzNUSVFGS3RPelRtOGtFODlnNlI5VFFq?=
 =?utf-8?B?VXZUcUk5RmdvcHp4T2pUS0xLdllEZjYzTlBTRitlK1M3dzQxRVFQZFRSZ1Nq?=
 =?utf-8?B?ZWQ3b0JnVURKbEY1RnF2ekluSVEySWwydDQ2N0tRZkNLS3phUFNKeWt3dEpI?=
 =?utf-8?B?SHNhUjBacGxLci9pdGxUc3ZURE50aklwQ0Vwc0NjSUhRNFlwSVBUTldzb0FB?=
 =?utf-8?B?T3p4a1NkUG9NU1dVQjYxc0R6eFRienFULzB2Q09VNWl4ZHZFUjJIOFJkaENK?=
 =?utf-8?B?WEF0Nm5JQkUzMWhlRnpjU1VkcmlzV3psVmxOTE01WmZUWitzQmJjaDAwWFdZ?=
 =?utf-8?B?WGptZTk5RFpSd1lvTCs0V0hnVmVxOWN2U3pmUzhaMjVmQXBCOFRWUGExeEdj?=
 =?utf-8?B?MXlwNndmTFA3Sm13bDNtaVNnUDRleERKMGFOLzJOZjRlOVlHWDBqWEdITERT?=
 =?utf-8?B?S1poaTl2NS9SblNDOXQ3MGFQN0NXdjZDWklPeVdCMGhMd05aY3YvTVpPNHNL?=
 =?utf-8?B?bGpsKzNubnZRcXpKcTNrbjVnRW1RSWRkVWtvSjlDWW9pZ2NqUHpGMUlqTGs4?=
 =?utf-8?B?Mk90Rng5eWo3clVERmpVOUIvQm0rWWpJcU1CeHlyd1RCdzNFT242K1YzNEhG?=
 =?utf-8?B?MHU3a0Vhb21IczNJR29XcVFFaVgxb2g2Z1Y1bWUrTWFUMGw2aERxV2g3V1A0?=
 =?utf-8?B?MjRDd1NybUJsd0V4a0pzc3BoSEMwYURRTExUdVBtTmMrZWJTNUZ2WlRqeHdp?=
 =?utf-8?B?SEJNNnRFZ1VFVThQb0lUVVdFT1V4M3FhcUwyU3R6ZUprUldjdmg4cWQyM0sr?=
 =?utf-8?B?dDVPRnlMcUN2ZmFTanl5aTEzNElIOEJJVW1sMUM1MnNuVzY5dzdCM2tyVm5W?=
 =?utf-8?B?NjlTVU5CNVhBPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c3NkR25uRXR5NUFLYUNBakNFa1BleklIRTZsb1VTbmEwWWg0SXBxb2NWY013?=
 =?utf-8?B?eWpvc2VBTXRNZFJIMHR5cElZTTJzcnp2MkdOQVd4dDdza2lLNUpwbGFRV3Ex?=
 =?utf-8?B?SlhSK0RQRnYyL09lRVlVN1dNMXVPWk1TT0RnYUJtL294dE1ST2VyUUYySFcv?=
 =?utf-8?B?b0doQnQ0ejNOWmMzMzlyaEkxUlQ4RHV0S1BhSm5mdkhkWWR1WnJsTDFrYjlT?=
 =?utf-8?B?ZHlQTEZkM0NSSU5peHRnVVRtRzh2L2p6dzc1WXdTYTF0RFJWT1RnQXNSaWhn?=
 =?utf-8?B?dmNlbE9mNG1ybjBNOUlDU3pFREZ1Q1BQR3lTSjNTSW1rU293c2hVTmxQNzZV?=
 =?utf-8?B?RTg2TktPTi9pNlloMzFwY1dYcm4xeFFDcE1zRGM0TER4ZzZCNWVXZmVtdEE0?=
 =?utf-8?B?ZWhUKzhuSEVyRUJnZWUvOFFhRFdxVDVna0FBdDBIY1A2UDdBR2JKSlhWSUgw?=
 =?utf-8?B?V0VEekVNQTJ4R2MrME1BYUgrOE9kc1NOMy8zdTBmUDMrYXgwdVBRWnZiY1Vv?=
 =?utf-8?B?QzNma1prNGRvZGg3YTFKMiswTWdUcXQyb3M1OEVMVGxubW5uRzZqb0RJQ2wx?=
 =?utf-8?B?YXZCQm9wZWJkeXMrQlJ1Y3ZvTEpFTnF3TVVnd29zQzI3YnZrYVphcGtMQ2FI?=
 =?utf-8?B?elErUkJxUitRNGxaMXRvbUczcnRvN1k1UFdVMEl0MGJaR2lIS0Uzc1JPV3RU?=
 =?utf-8?B?L1VpaG11MWplTklsYkt3SGdZMUFaZlh5Tm9jNFNndFVWWWE4ekdncWhPNE9W?=
 =?utf-8?B?T3pCaGpzSTBUZUpNSVNjcnpVZ09iYzh3ejZ6ZlZJdmVUWW82dlVidXI1SmVv?=
 =?utf-8?B?K3plY0NZNC92RjVpWTdReFdPb3h4Y0JYbVBCenRVNm83cmdkcVBUTUFuM2hH?=
 =?utf-8?B?aXB5NjJYQVFZeEpZbkU2cHMzV2tZRm93elh1MUNsendWSE00RWxBRlZXL2w3?=
 =?utf-8?B?bTR2bS9uY04wZ3pRUldDMG1FRzU3U0hBUlRFU0VqclVUWklVemR2K0ExSmlI?=
 =?utf-8?B?U05QaHNUNS9nU1NUektGR0lYLzRQNXR5N1Y1TjFsVm0wUVZhb2grWGk5dmFl?=
 =?utf-8?B?bmZyNG9ubFc0WVhYUHFYaHZRbTVGY1ZVUEFMSFN4MWwwNHJpUUtsakhGb3pM?=
 =?utf-8?B?TGY1VXlra3ozZ2VDWnFrSjVIaGtPR1VEaDdHQzE0L2tzN2NkRjR0ekVEWVBK?=
 =?utf-8?B?VWZWaldtYjhBQ1lLNXNYT0VpTDdvK0ZCU3F0dzl1S0ozVXpPTHhLV3ovb3VH?=
 =?utf-8?B?bXhGa0ZOcVZSUVlXSTMxN3BrY2hoRWFuR1dOR1hzK1AyODN1dGxtcENjdDg1?=
 =?utf-8?B?bXNVYjd6Qk43R3lsNnE1bVBxN2krU3JVN0hLTjVPOHIvL09VZXRYamRpSnox?=
 =?utf-8?B?alpITTBtc2thYTY4Q1lGR3NibTFyRFlUMlArWXRTZGFuNjEwb0ZwYjRjRzEw?=
 =?utf-8?B?UFlCSmg4Q0tVQmQwejR6bjZTeDlaUlVxeVcyYmVITTFaWXlHZmVMeWtTN0lB?=
 =?utf-8?B?TGpaWUVoTzg2LysvUTNJQlZuTytiOFVmby8yUVJCcDlPbnM4TjVhK1FES2Jl?=
 =?utf-8?B?d2FVdmtLcWlQYnFOL0d4dVBpTi80RHFNU3dyVGdMQmdDRFQrMldKcTVSekZo?=
 =?utf-8?B?RklDdk9PWXQzSlZNWGs1VVRGbzBLVi9PREo0cUlJQ013VlBUNTcyeGU4eEdG?=
 =?utf-8?B?TldmSlN0bnNlNVJZQ083NUZGQU9KVzFuM1dIaUtFdFZEcmdTWEt6V1dLN29p?=
 =?utf-8?B?clN6KzhPaXZkUzlsVjFzUU1HYzlEVDhMOFBjSlZySEk0NVVGZ2dYbWlhcVdZ?=
 =?utf-8?B?dU5JYnRJR1doV2l4TUxTaVRoNWVhWjZyYU9IU1A1dmxJL1RwTnI4cld2VGhv?=
 =?utf-8?B?RVdQZGwyUndDVTM0cVhCNTFkV3ptM2lIaTkxMS9sTFJlTlh1WFg1N2V2WUlQ?=
 =?utf-8?B?ZFpqeEI3WnRMSzNTdGM1Q0Z2REhzM2RkUXFpWGVXRzFoYXNwdXBsNlVDcUp2?=
 =?utf-8?B?aDFueURrNDQrN0NzM1crQnVSaG5Id3d1Q20zdVBIQXlDK0R1QmdsWHAzMWVO?=
 =?utf-8?B?YjhDT1VRUGoralQ5enQ1d0tnQ3JHTUVuUFRiNU9Ma2R3TXNpNVd6MmVybXBM?=
 =?utf-8?B?THhlUWdXL2RVSUE3dmJybktycXlnb0hzNll5QkxRMC9PckpDKzgySUpuVExJ?=
 =?utf-8?B?dVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cbb4de37-01ed-42a4-6b7f-08ddfa2a2873
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2025 22:48:33.2146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yf1Z9G86O6d71rTN1+mDMOeHTCZ8Yb4/UuJvVWHx5+SCrh9qxEce/2I7szzFARhKigdm/ehUNAngnW1Q+0ESM3jHkMJhESLeoPQhJDQWd90=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6219
X-OriginatorOrg: intel.com

Hi Babu,

On 9/19/25 1:49 PM, Moger, Babu wrote:
 
> Here is the updated full changelog.
> 
> fs/resctrl: Introduce interface to modify io_alloc Capacity Bit Masks

I do not think it is necessary to use upper case if not following it
by the acronym. I also think "bitmask" is usually one word? So:
	fs/resctrl: Introduce interface to modify io_alloc capacity bitmasks

> 
> The io_alloc feature in resctrl enables system software to configure the
> portion of the cache allocated for I/O traffic. When supported, the
> io_alloc_cbm file in resctrl provides access to Capacity Bit Masks (CBMs) allocated for I/O devices.
> 
> Enable users to modify io_alloc CBMs via io_alloc_cbm resctrl file when the feature is enabled.

(nit) can be made more specific with:

	Enable users to modify io_alloc CBMs by writing to the io_alloc_cbm resctrl
	file when the io_alloc feature is enabled.

> 
> Mirror the CBMs between CDP_CODE and CDP_DATA when CDP is enabled to present consistent I/O allocation information to user space and keep both resource types synchronized.

I think "and keep both resource types synchronized" is redundant considering the sentence
starts with "Mirror the CBMs"?

Reinette


