Return-Path: <kvm+bounces-12436-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 79CCE8862C7
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 22:58:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2ECF8284673
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 21:58:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A8E3136664;
	Thu, 21 Mar 2024 21:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MLtTu6r/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836CA133998;
	Thu, 21 Mar 2024 21:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711058292; cv=fail; b=SB9q9gs1m/QdzAV/BlcfjPh9P+DiNqN7i+cwh/jDSlh7HN3vyW+PSouPUtIRXIx8eDYkGInaEVwk6liV6ZdWnQdn3RushMU5UHhNKXpzX1qB+EbytFozB9PQmqhvkFZyknzirfWqzqpwxwuSNi72mfNvoG79B79DlPY1oSd6lG8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711058292; c=relaxed/simple;
	bh=Lz3EL/EiVh/kKzAPRXDecYszUFsMyXW4vcxNrP+Uo8g=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KnzPm09ecGH0heBn5rbo5JQkMwPoHm3DnULlugoAbbwjWn32I13o7FV5q4AHLToPHvrBfM2gXPt1oWvC3zIdlG+T2TAZq5DJ2ne2S7wov/locTFyWvarPJE/hLfC6DwWMWRf9g7OeEocm1Yq0Tc60d0+0BeoN4Rhtn1+v9Y4vDE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MLtTu6r/; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711058290; x=1742594290;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Lz3EL/EiVh/kKzAPRXDecYszUFsMyXW4vcxNrP+Uo8g=;
  b=MLtTu6r/2APc0pSDcFx8H84cuJ/5uxFzL4G+6MhJDOUDjfB7lA+hOy9P
   rBRQIQLlrBWoI1phSg5eHHQS7Mxwc9oNniJ96UlqLUmN8nNfUqvh3jP3k
   AEc7UnP/0S4Ok69SEBNRu2gZBM0Nv51nmeVtL05gKn+cPx0NqAwfeoOjk
   GGfpRBKF43GydDdEcrWaIKORJka4PYrK3oJ4gDbQuUoj7vfqhPbEQz5vE
   qKSi88IDgg8lYX9YbAX2FSQi4G1S9mLI5mMl4sdJ9dDCsTEzWRdYrk5Tk
   yRcirtCbLm9EcuovSx8Jd6RRfcqIV/VJw9mxSKMMkzoKxN1/z/8RS6r3G
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="23537856"
X-IronPort-AV: E=Sophos;i="6.07,144,1708416000"; 
   d="scan'208";a="23537856"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 14:58:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,144,1708416000"; 
   d="scan'208";a="14638479"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Mar 2024 14:58:09 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 21 Mar 2024 14:58:07 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 21 Mar 2024 14:58:07 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 21 Mar 2024 14:58:07 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 21 Mar 2024 14:58:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mfvQA7uTjEbK0kW3cXTeV5FR6HHhtkFjmDhKCIVis4TV8Me6PIRwxQ83tEWy+P+v7W/1DG0q9GUPDEaWsFpOabWo2ZJrkB8XJdVnXffvpnpl/tHpgD13xWpblhYxwIzaanotEodgz4QpOeaxa+mbz+O6Yi6fzHSBEuG7vefqNtWsMGJ5OFZHvq+aEJaoh9pc7SUJbw5UdhHRkhbXy6muJ8/bDU5UiMfIveznPP2C8csK8dR/9w1Il5uX+kBo2AVgaSYt/3rAiRExRNzz2JLyd8Edm9yGuCclljcrMfmcheEM5rzgln08FyC3vu4NS2UmjSBG6RegnxO/rEdyBodnAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bDN4783ooIeJWxbdI7YJF0x3OrBHauAFmoco861NWRU=;
 b=NdySKqqRF6jP+yiboYhuYajIVOIx7pYW88JPtUnswRP7k5/Yy8XDAhphQm29GR0VO+F+lTGaVHoFSvv47jDUPtXPwyb0bs0XIBFaVRez7T7OeJ89diCNXsA8zcrnY/3+SNuzZ9EIioxzCBMoNctqPxdWLv8EfCXNbGWtz8jPDrUXtAA7Maw4o5Cz0MxkWLWbM7Id4ane2TUY4bJFhEQvIQEH1K4sP5wYoU9SSDFHdI33PeB3fPhvB1dn/oDQCEq1uaf1aTlJ597hZViqShCvSGE9dwZZF/RTQqGNzdRGLnRQwuYtp1t09YGnUZlMjKcygcUF7ZeCpa4hYhP0t/wf0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH8PR11MB6683.namprd11.prod.outlook.com (2603:10b6:510:1c6::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.24; Thu, 21 Mar
 2024 21:58:04 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7409.010; Thu, 21 Mar 2024
 21:58:03 +0000
Message-ID: <b7b919eb-81fd-4f27-86c1-6e160754608e@intel.com>
Date: Fri, 22 Mar 2024 10:57:53 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 027/130] KVM: TDX: Define TDX architectural
 definitions
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, Paolo Bonzini
	<pbonzini@redhat.com>, "Aktas, Erdem" <erdemaktas@google.com>, "Sean
 Christopherson" <seanjc@google.com>, Sagi Shahar <sagis@google.com>, "Chen,
 Bo2" <chen.bo@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Zhang, Tina"
	<tina.zhang@intel.com>, Sean Christopherson
	<sean.j.christopherson@intel.com>, "Li, Xiaoyao" <Xiaoyao.Li@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <522cbfe6e5a351f88480790fe3c3be36c82ca4b1.1708933498.git.isaku.yamahata@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <522cbfe6e5a351f88480790fe3c3be36c82ca4b1.1708933498.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW2PR16CA0008.namprd16.prod.outlook.com (2603:10b6:907::21)
 To BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|PH8PR11MB6683:EE_
X-MS-Office365-Filtering-Correlation-Id: b23fcd5f-3f9c-4ef0-c6ef-08dc49f1fbae
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qSbCLxk5JU7K/W3hmN0CPYnI7q4aBI/RbXPywdIm8MY7LpqvdUQl1h44JU13SUudKa9e/TE2m+XU30qRLTIqDmnpuZCFExz47e02D1NtL3gv71UgyKd9bC2qU75txrnUbsZduTX+AhNcWMneyduO5ni22uSedbzjveVkhq+pvMT77m/f09PvOGHwyC5SNjVSPnBOtXMlODHTNODptc37gtXdj7GVidBNFw+izdwDiOnT81AZKNAtwF9vP4ezJUffd8oliGdXfEfIi5TM3xMiz72xH2GfDVO6T5VHEUFCY2g/tNR84PJdjecbMox7JE5vEuXrYkagnJRjPw07HCNnJXyj3rp1qNCMc6I60CVPLysZwDjXfWq/pkdGbXhbeET6MyqYjeCjcuHR5ri3saFj/2SzQbeGUZ3oCA/tmhJKWuOBdMiWkm40mp1RPsq2Os3HDIT/CHUZA5ngqYxRnRtxihHNPYyrGE/WCYtn1In+MEtoIaKqJbbV+U6YMBkSVpiS0o3HnguOB+ka2jzLf8k5yjLimkBgk3Z+vuswm4+ZRP14RzxgHDtJxJMLTW4AOPARmNnTG+MLMhIgDU/w2ZrVsrGZyaTTn7NM6Tl3gAq7bEDIVL59h7/5WgFy6vyZxtsvRsdxhn7D1/DEv89FWr3LfvVtwVOalTQKOdfJZ6t6WeQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UGVId25mQTc1Nzg1K284WDByZjdBYXBHMVdLblRwTVIxeXJnRUxDT2J6L3hJ?=
 =?utf-8?B?MTdYQzJ2K1FOUHo3T3QwaEU1RzdGaXRDYU5xWG83akVjYWI5MzFxUmZpaWF2?=
 =?utf-8?B?K0VHdnl6U2Z1TFY5WXJ5UVg2NVdTejQ0OFcxcFd6bHdFQzlrVXU5OC9RcDZ0?=
 =?utf-8?B?Q1N5YWVlckdla1NuREpGTUpxdEU3emx2RXAya0lqb3ZCQlI0dXNkTkpWaURF?=
 =?utf-8?B?TDg5Vm1KUFU4SmpuUUxnOG5TZHlRNUJGcWxzOUQ4TDhvbjVTeUh5QjF6NUZl?=
 =?utf-8?B?aUwvZmcwakpRdWZzZm1vT3plN1dZMUR3Y0pLbmx1SVhzdU5rS25paVlKbW50?=
 =?utf-8?B?OGMvY0ViWUs0dmxJS1JodWtMQkZzNnJ5a2d1c1ZmcGdXOU5vV0pkWnN0ZjFI?=
 =?utf-8?B?dnh0dU1xeWNMRmhhT25ZTkJ0WkNMTjhXZWZiaWtlcHd1ejYzK0xOWHB2QW0y?=
 =?utf-8?B?eGQxOFFZOERBb1BzNzFPRElTaktQaWdHQ3FKVDZhT2hXNHVCL2h3Z0J3MXB1?=
 =?utf-8?B?WG9KSEs5dnR2amt5cnhqUWJ3T0hQT3VEV1BTcTVMVThlNXZsU0xDSnpXRXFN?=
 =?utf-8?B?NWd6ZDl6M0hML05oZzdEZDVDZEJOYkRJMjZhcWk1Zm1iNWQ4UmR6Y0FVaFBJ?=
 =?utf-8?B?TkVJNk9TRWdvZE8wNW84WGRXZUsrSVZnZXFaRk5LUUFIMC9NeTZnRFZTYTQ2?=
 =?utf-8?B?TkthenpxTXByaG1peGd5UUtSbC9iRFJETGpWSy8xbjVDY21MNUExNGMrdnZh?=
 =?utf-8?B?Sjd2R2VWUDZRRXhxcDFpWklxYld0bVA2S2pLNzFBRWFObU50Vk54KzJXaUxl?=
 =?utf-8?B?WWN0SWQ0OEJFNDk3SlZ5bVFhUm5FaG5EamJmbmdHU25MWGlQT3lHSlR3MUpH?=
 =?utf-8?B?Y0FYVnhvZ0VCYlF1czZ2WXVKRnZKLzRsSWNuZlBLa1VGV09NVU8rQU01Zk1G?=
 =?utf-8?B?YVpjYnI3QXNLak5PT3NCdDhDaGY4KzJVcFVoZmR2TGtkT0hiL2pYeTVjY0Zm?=
 =?utf-8?B?WmhQQThKaUNJejBoK2dNanZGZHRmYVJ1Tk1nNEdqUGt6KzRudzRNMWxPajBE?=
 =?utf-8?B?ZHl6NjlzdHNMYkk1aGtUUWg2Z0dRc29PcXpYYnZ3VW1wVUNJbzVPa1Q2RTNY?=
 =?utf-8?B?WHAyMVcySUI1Qk94ZXBra0s3eks3UU94dURTbU5vVjZUbGRBMFNLRVRuU2NZ?=
 =?utf-8?B?Vm5oSUtVWENqUHRPSkUzajhsb21KakE5Z0o4VE9CcGxWRjNhTXN0MEVCZWgy?=
 =?utf-8?B?WW1TMVB3Vmg3a09pLzU0ZkVteG1sVGxTa1ZySFlNMElmREpkNnZJYk9vTUNN?=
 =?utf-8?B?N3lYVDdDVFI5RzZ1L3JFdEtPblEwRERGODQ0RUpvS2NvVDBJeVgxVXpDL0dW?=
 =?utf-8?B?bHhjVlNMM3E3dG5TaWV5N09SMFEvcHJOWXl4ZUxLZmp6T2N3c1V0b1pldytE?=
 =?utf-8?B?WGNDMjNkc3gzdmo3R2NFRW9UaWVlc1pvMUY3cmxqdEdQbWFobGtkUTljY3k2?=
 =?utf-8?B?Zmc1MXJpYzZJczRzamtvUnZScjRUQVNLc0F4akVyeG91cEJHUUdVNFdrSUFD?=
 =?utf-8?B?bWtwUVNVRW9JbTFpc3N4NHdISU1oYXpheVFMaDhGcUpaOXRLMUFUSXVGUFU4?=
 =?utf-8?B?M001ajBINE1SVEVjcTBtRHFseFR4NFdJY0RlS1lIYWZQRmorVUJuNWwxSVdp?=
 =?utf-8?B?bnhibGZXQkMwM0ZPWXdyZTJQRWh4cjRYZmJMcmh2Z0I0Mm9RcTdQT2tWS2Fp?=
 =?utf-8?B?bi8zS0tYQ0xYSDBuU3dnQkNNOEplQWJNRUg0UjdKdEs3M3hwa2FSTW1NWXls?=
 =?utf-8?B?L0hYR0IrZGxxZEJuKzVINDNXdEpNMkJkRnIzK3Z4Z0YxQUFPQUlyQTJadHEx?=
 =?utf-8?B?ZVRZaG9GSE92NElKbXppQzgvNGhIS0JlT3djaTlqK0Z0bnNocHVHRGtDSzMw?=
 =?utf-8?B?MmpPMmZGMmt2U3ZLYzZrelNJMUZwdEQ1a3VyMkNhNmtpcGxRUFFqOEREbUF2?=
 =?utf-8?B?QTZYMUw2RWhtUklWcGFmUW5RWFBQMXIzS2kvU3k4TnJsdXBOREhmZW1wK1hh?=
 =?utf-8?B?R2VJUlVqb25zdWxSMHZZUmY2MnU4M1dyNm1NK1RMTjA2NUdSVXFzL1RzN2NV?=
 =?utf-8?Q?OsPZIAzKrZv9dfV9Vq1sRTg2Q?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b23fcd5f-3f9c-4ef0-c6ef-08dc49f1fbae
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2024 21:58:03.9260
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s0B6KdvLtEMpFr7mynVvnU74LXrfeMzoMW77ujhkKWmm3B0TjroC/YZgAvrv4q1wKWK4I7CfmTyAA5xYCGzKbQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6683
X-OriginatorOrg: intel.com


> +/*
> + * TDX SEAMCALL API function leaves
> + */
> +#define TDH_VP_ENTER			0
> +#define TDH_MNG_ADDCX			1
> +#define TDH_MEM_PAGE_ADD		2
> +#define TDH_MEM_SEPT_ADD		3
> +#define TDH_VP_ADDCX			4
> +#define TDH_MEM_PAGE_RELOCATE		5

I don't think the "RELOCATE" is needed in this patchset?

> +#define TDH_MEM_PAGE_AUG		6
> +#define TDH_MEM_RANGE_BLOCK		7
> +#define TDH_MNG_KEY_CONFIG		8
> +#define TDH_MNG_CREATE			9
> +#define TDH_VP_CREATE			10
> +#define TDH_MNG_RD			11
> +#define TDH_MR_EXTEND			16
> +#define TDH_MR_FINALIZE			17
> +#define TDH_VP_FLUSH			18
> +#define TDH_MNG_VPFLUSHDONE		19
> +#define TDH_MNG_KEY_FREEID		20
> +#define TDH_MNG_INIT			21
> +#define TDH_VP_INIT			22
> +#define TDH_MEM_SEPT_RD			25
> +#define TDH_VP_RD			26
> +#define TDH_MNG_KEY_RECLAIMID		27
> +#define TDH_PHYMEM_PAGE_RECLAIM		28
> +#define TDH_MEM_PAGE_REMOVE		29
> +#define TDH_MEM_SEPT_REMOVE		30
> +#define TDH_SYS_RD			34
> +#define TDH_MEM_TRACK			38
> +#define TDH_MEM_RANGE_UNBLOCK		39
> +#define TDH_PHYMEM_CACHE_WB		40
> +#define TDH_PHYMEM_PAGE_WBINVD		41
> +#define TDH_VP_WR			43
> +#define TDH_SYS_LP_SHUTDOWN		44

And LP_SHUTDOWN is certainly not needed.

Could you check whether there are others that are not needed?

Perhaps we should just include macros that got used, but anyway.

[...]

> +
> +/*
> + * TD_PARAMS is provided as an input to TDH_MNG_INIT, the size of which is 1024B.
> + */

Why is this comment applied to TDX_MAX_VCPUS?

> +#define TDX_MAX_VCPUS	(~(u16)0)

And is (~(16)0) an architectural value defined by TDX spec, or just SW 
value that you just put here for convenience?

I mean, is it possible that different version of TDX module have 
different implementation of MAX_CPU, e.g., module 1.0 only supports X 
but module 1.5 increases to Y where Y > X?

Anyway, looks you can safely move this to the patch to enable CAP_MAX_CPU?

> +
> +struct td_params {
> +	u64 attributes;
> +	u64 xfam;
> +	u16 max_vcpus;
> +	u8 reserved0[6];
> +
> +	u64 eptp_controls;
> +	u64 exec_controls;
> +	u16 tsc_frequency;
> +	u8  reserved1[38];
> +
> +	u64 mrconfigid[6];
> +	u64 mrowner[6];
> +	u64 mrownerconfig[6];
> +	u64 reserved2[4];
> +
> +	union {
> +		DECLARE_FLEX_ARRAY(struct tdx_cpuid_value, cpuid_values);
> +		u8 reserved3[768];

I am not sure you need the 'reseved3[768]', unless you need to make 
sieof(struct td_params) return 1024?

> +	};
> +} __packed __aligned(1024); > +

[...]

> +
> +#define TDX_MD_ELEMENT_SIZE_8BITS      0
> +#define TDX_MD_ELEMENT_SIZE_16BITS     1
> +#define TDX_MD_ELEMENT_SIZE_32BITS     2
> +#define TDX_MD_ELEMENT_SIZE_64BITS     3
> +
> +union tdx_md_field_id {
> +	struct {
> +		u64 field                       : 24;
> +		u64 reserved0                   : 8;
> +		u64 element_size_code           : 2;
> +		u64 last_element_in_field       : 4;
> +		u64 reserved1                   : 3;
> +		u64 inc_size                    : 1;
> +		u64 write_mask_valid            : 1;
> +		u64 context                     : 3;
> +		u64 reserved2                   : 1;
> +		u64 class                       : 6;
> +		u64 reserved3                   : 1;
> +		u64 non_arch                    : 1;
> +	};
> +	u64 raw;
> +};

Could you clarify why we need such detailed definition?  For metadata 
element size you can use simple '&' and '<<' to get the result.

> +
> +#define TDX_MD_ELEMENT_SIZE_CODE(_field_id)			\
> +	({ union tdx_md_field_id _fid = { .raw = (_field_id)};  \
> +		_fid.element_size_code; })
> +
> +#endif /* __KVM_X86_TDX_ARCH_H */

