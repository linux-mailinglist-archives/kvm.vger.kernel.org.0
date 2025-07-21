Return-Path: <kvm+bounces-53018-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D68B6B0C9EB
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 19:45:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF459543B75
	for <lists+kvm@lfdr.de>; Mon, 21 Jul 2025 17:45:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DF8F213224;
	Mon, 21 Jul 2025 17:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G1Ez9BAR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10628155CB3;
	Mon, 21 Jul 2025 17:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753119942; cv=fail; b=FjiK/Yjpsn8CH/cUl0LRQpqEjq/ChbIgiiLFPLhnOmhpj0jQIpS7gBQuFBlFxmcJMxnz3y8lx24uTLMzukFygVLiY9v5oecVME/Z6zOB7ZXdtYATulJHpiZhsTC71+Z8+9mJRpHUqACU1HjyXHp5BR8iq1LJctm/vT3VldDZDFY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753119942; c=relaxed/simple;
	bh=hs2mBBmVCboXCr4SLXJhhuzVuLy4e8RbHgzd/7hzKwM=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=dGCrhWPZ7m3jBpWf9RjoEtypSOdPo66+iAy4v7K8ZQPMRvGDLOIaf2hWc9hMNtxeUNfbc27jk2PAgUX1+yJx3kCkfYF1weVJYcq6fSj+MxNpr8o3wNnSbl5dX6mfjSM5f2lsMRr2DvUu15qB0ubjJuBL9nQmzmndbL5G8gMwRoY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G1Ez9BAR; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753119941; x=1784655941;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=hs2mBBmVCboXCr4SLXJhhuzVuLy4e8RbHgzd/7hzKwM=;
  b=G1Ez9BAReVOcbmQQvToJLKsa+8/mFohjsOVGrHvjYMGy6xlVW/KSWLLp
   tDbrQ6l8j+MDjfU9t9ztyZAsr8T2pwRvrUYAJLOdNnVPyIMNesb5TP2Y+
   Rx/L7wLMgrtuL7wRgAuGeYQMeZCxeCEdDbNz4yKC6uLVmryHItK3boPdy
   aeMZ4Khz9Kax4js0PJFbyZ4BVtIPOGRHmN6W9e9klz5W8jb18OrMZSY3M
   wHHJYvJo1INa0dm4GIy3xb+tTkH4gUCVDCgQo/J7B9IzFm4aI3Af6Nh0i
   vQaAD0dmMQuUj2Fc+Aq76OS2I+yASyHfHC5BAHaMPI31F2zEk73TVw6rT
   g==;
X-CSE-ConnectionGUID: VqYofkEGRW2tz0TubL1DHQ==
X-CSE-MsgGUID: OJvLUR2zTeSfMVlORlb7hA==
X-IronPort-AV: E=McAfee;i="6800,10657,11499"; a="57965083"
X-IronPort-AV: E=Sophos;i="6.16,329,1744095600"; 
   d="scan'208";a="57965083"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 10:45:38 -0700
X-CSE-ConnectionGUID: Qt5O+TWfRyCtWouuJCh1ww==
X-CSE-MsgGUID: wSj94BBhRyiXwE0rHoMqdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,329,1744095600"; 
   d="scan'208";a="163133955"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jul 2025 10:45:38 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 21 Jul 2025 10:45:37 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Mon, 21 Jul 2025 10:45:37 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.53)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 21 Jul 2025 10:45:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fVmX2hanGk5W+a18GCcGNa4ravgtE5jwc2x1Y3UnQvwJmTFByO3owEwUahbE/Zv/cxGUVLWtXY0Z0FZ+1+2D+AeCrNrJkQHZQf/Ppls5rszK1DWVtXKg7ul1wlv2wxY2tZjGcxZFg33NiJJewqrJ5QsyD9XYRIkg2Gi29mEfptlcthvG+uUcjRxZQIEfEAkrx86gwutlulsfUDPrxF2ufIOy4haKMNsxvmuOpN6F2RM7zsim9F/vG4qmJFDoTtUB92VOk1tV29/dZRCqP7NALKfngs8KJBbH0N16sWhCPQdA6z0BvS2Q61qvgqA0kOEpUVLHSWOYMrAwx+A8qa0Hgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4gmkJrJDTUYvVeYVNEKIN3oSFvU8HPfGYgghjmYGVH4=;
 b=EfKWwDZPsXgUtmJN+mK/75TTNW78NBe2I7dvnBo1lvP1B8VzepKBIsc0Wc1QB6Bob6urVi8KxTliyZYVPOxl6P9f4Zph+PyfNFxhexB6YGJJPm90dkVKiFjk690GZhrndB3a6+deTcvprqmMRmLlKhsHwBkQLviumT+AhZmlTo1BPNcVFZGrI0Uz4qsXD5stbEPStYlaxka6xit2bBGoKxLswA/znGmi1x27nIgVavcl3FJGwI+jw32oc46BOHq+5fnNrm8qtp8J35ek+GuF4jofZ5YDC2ZowlLleaKavKOACK7RngoUtYRjJdh4o89qfY8VIO4bSfDcFkNBh+2U7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c) by LV2PR11MB5974.namprd11.prod.outlook.com
 (2603:10b6:408:14c::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8943.30; Mon, 21 Jul
 2025 17:45:07 +0000
Received: from PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::bbd5:541c:86ba:3efa]) by PH3PPF9E162731D.namprd11.prod.outlook.com
 ([fe80::bbd5:541c:86ba:3efa%5]) with mapi id 15.20.8943.029; Mon, 21 Jul 2025
 17:45:07 +0000
Date: Mon, 21 Jul 2025 12:46:44 -0500
From: Ira Weiny <ira.weiny@intel.com>
To: Vishal Annapurve <vannapurve@google.com>, Ira Weiny <ira.weiny@intel.com>
CC: Yan Zhao <yan.y.zhao@intel.com>, Sean Christopherson <seanjc@google.com>,
	Michael Roth <michael.roth@amd.com>, <pbonzini@redhat.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<rick.p.edgecombe@intel.com>, <kai.huang@intel.com>,
	<adrian.hunter@intel.com>, <reinette.chatre@intel.com>,
	<xiaoyao.li@intel.com>, <tony.lindgren@intel.com>,
	<binbin.wu@linux.intel.com>, <dmatlack@google.com>,
	<isaku.yamahata@intel.com>, <david@redhat.com>, <ackerleytng@google.com>,
	<tabba@google.com>, <chao.p.peng@intel.com>
Subject: Re: [RFC PATCH] KVM: TDX: Decouple TDX init mem region from
 kvm_gmem_populate()
Message-ID: <687e7d042afa_203db29463@iweiny-mobl.notmuch>
References: <aHCUyKJ4I4BQnfFP@yzhao56-desk>
 <20250711151719.goee7eqti4xyhsqr@amd.com>
 <aHEwT4X0RcfZzHlt@google.com>
 <aHSgdEJpY/JF+a1f@yzhao56-desk>
 <aHUmcxuh0a6WfiVr@google.com>
 <aHWqkodwIDZZOtX8@yzhao56-desk>
 <aHoQa4dBSi877f1a@yzhao56-desk.sh.intel.com>
 <CAGtprH9kwV1RCu9j6LqToa5M97_aidGN2Lc2XveQdeR799SK6A@mail.gmail.com>
 <687a959ad915e_3c99a32942b@iweiny-mobl.notmuch>
 <CAGtprH-DprCYLCYK3T7fQ23xAkTb9HdMbbp3TJ=-QgenNz8=mg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGtprH-DprCYLCYK3T7fQ23xAkTb9HdMbbp3TJ=-QgenNz8=mg@mail.gmail.com>
X-ClientProxiedBy: MW3PR05CA0014.namprd05.prod.outlook.com
 (2603:10b6:303:2b::19) To PH3PPF9E162731D.namprd11.prod.outlook.com
 (2603:10b6:518:1::d3c)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH3PPF9E162731D:EE_|LV2PR11MB5974:EE_
X-MS-Office365-Filtering-Correlation-Id: a0794909-a6ba-44e9-decd-08ddc87e54ae
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?ZmxqQ3ZGOFdhYlFDbkZyYVVGT0w4Q1FLQnhVMFNmT0Z4NFhwNEdhblkwUUEx?=
 =?utf-8?B?NnpqUG1nWmV5UUIveG52U0RYeDA0MXo3cVlNa2tNZ3VIazZDVU1UaHBzenJm?=
 =?utf-8?B?K203a29wSFNaUmJuWHlDWlFVVUl4RzQvMzZVQmZBRTVXaU9GUmdxTW80bVVq?=
 =?utf-8?B?MWJ6N3N2UURCZFdDaWRyQWkwYktsVGhJMWRCeFZZNlpueFV2Y1RlZndzSjFU?=
 =?utf-8?B?ekNRbWtVSXdDQVVKUUtpS3BScHhMSVA2M1Axdml6TDd6UFdIMzFlQmkzRFBL?=
 =?utf-8?B?VHgrQU9xVVo4VW9XRllHbWVQbFhmNHp6Q255YkYwRVk2ei90UkNnTXJ1YU4x?=
 =?utf-8?B?NDRqMEMzWDBGM3hwMmNKYlpRUi9MUk5zcVBpMzZKSFdMcDhaYnlhWWtrbFhN?=
 =?utf-8?B?SFNicG5NcTc4Yko0V1Z2eUhrY3Z4UFUwUnJyWjQ3RTlWY29EbmNNTm9FaVpS?=
 =?utf-8?B?NlNkQ0xFWUhnVHRsektQczhlZGNPeEVuNkVRMmpxWVBkeWM1U3FLajFtQUw0?=
 =?utf-8?B?NnVhRTJLMmRPTTRPSldoeVZWUWtRRzRFM3dCTmJjNTFOOXFMemVoMlE5czFs?=
 =?utf-8?B?TzY0eGhQNEtZVllVU1lOcWQ3TllHMktNaHpjMjNpOCt3bGhiQ3J2RmlwckM3?=
 =?utf-8?B?OWk1SUNFYXUzR0ozQk9IYUxjU1QwclQ5Y2s4YWpKZGdVcU4vUHp6S0NkakdK?=
 =?utf-8?B?YTlQZ1dDZ29PaUhSLzJaZVVtc1QzZ1JqdU5vTlRyQXVWWFRCQ2NrTTVoMW9p?=
 =?utf-8?B?b00wSUpmUHJXZ1Zrb0lwdkxsdGFEN1BwcWkxNDNxZTdsQ2hIaG5nWWFFVk1y?=
 =?utf-8?B?eExGUGRLUFNwYWVKMlN0Qy85N0FxUHcvUU1TcUhRL2drS0JIbW5HZ1hNRUZL?=
 =?utf-8?B?dnZDUDcxUzFkcThTZ1QrY3JyRlZPMFVydHZBTGhwYkhzeHhuVWRJRDlWSGda?=
 =?utf-8?B?NU5yblpJSFUxMVRoOEU4UGVJWTRvWUxpc0Yyd1V6cWJTZkVONE9nWm45Uno5?=
 =?utf-8?B?R0k5UFBiUWM1NjdGQlkwR0UxdnlBbG91MndYYkpCVDZsbzNaMWdyOHhxcmdp?=
 =?utf-8?B?eEVGUzNxSVMxMCtyOHFPbmQ1eHdhMWEwVEVISi8vQVpTRWxPUFFLbm5VTm5V?=
 =?utf-8?B?TVlNRDFUdkF2V1VSbHBOaXlBbXRuWWpDejdhNklYMyt4eGN3VjRmVUMrMGsr?=
 =?utf-8?B?VFFoSHorTnBsVm9FRmxPbmF4VkNjTk51aTdlNUI0dkdralU2Vmc4RDVzWG50?=
 =?utf-8?B?U1VRL3BqbG1nNzd5cDExL2g0VldnUjIzalArTjF0UDhJMGVyNm9lTVhUWEF5?=
 =?utf-8?B?VWtNQ2hyQnlRK1VvTDZCRk4xYmZ1VnRBV2svRXNaS0xwRkd3cGZYU3BnaEdk?=
 =?utf-8?B?R3N2emUrUzB2MjhBajJmcDdsaGFBTGYwUEN4R0xUSVVMSGRhdjZNRjRQdEZI?=
 =?utf-8?B?NHl5Wk5Fd0diT3JiVVgvWnNiZ0p4RFV3QnFmUVJ3WjRtbVBONnAxd1lvWHdB?=
 =?utf-8?B?VFI3R2hvOW1FOFM0VE9Kc3ZFM3lKRk5tTEVyUUNycndEK3pPU3NlUjBpN1RO?=
 =?utf-8?B?bEloZE84alYrRUZiOVAzRHJ3Umh4SnpQM256T3diTkF5U3FtRi9UY3UybG1Z?=
 =?utf-8?B?SjZYUzJySlAxRWZHR0JsQnlub3lBT1RMZUUzSDFBRWtHZ1pBNVU5bjNpZWpJ?=
 =?utf-8?B?NnE2SjkrcXBlNXM4ZURtNE1FSTdpRTViM3FxQ2RMVzc4SGdiaTVHYjIyd1Er?=
 =?utf-8?B?NllTa2JVSjhQanpxNU1QNDRiekxJRmlDdWxReTR4bmR5SDZabkx6OElXMWQx?=
 =?utf-8?B?b0piM0MrbUlQSmszVHJ1amo4aGxRNlJCZEVnMUFlczhWdXc0aWhxZXBHTFJ3?=
 =?utf-8?B?MnB6aFloOW1TMjZLVU91b2xCaDJZNDZ0WW00ZkZ3aW1ZNC92NGFic2NFNWwr?=
 =?utf-8?Q?cKEN+j0nfwc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH3PPF9E162731D.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TTlhQnRDT3h6UjJ1RFpKRUw2bHNuaVJqeXVrT29sekFqQ0RyQ0NBNFpDQmll?=
 =?utf-8?B?bnptVkI3bXYyQjdVemNGRThJSnRKNFI1aG84eUdaekszS3l1YXhianVqZXlC?=
 =?utf-8?B?d1IvOTlwUWJORlE3SW1La2haeVBORzZETU4zVlVGdE5QVlA1ZXdCbXZXREcw?=
 =?utf-8?B?VTdjZTIvN3R4RTVIZnI5TWREVWNrYU5zZDFUUjJaSDRsblZ5bmNlWHRra3pD?=
 =?utf-8?B?TjVGRWpsR2wyM01yS1lSM0FibHhCdjVUQmtvSGxXL1IvTlBFREM5eTMyR0ZG?=
 =?utf-8?B?YjQvcDdWMnFMczBWU2xJbEgvZEZUY09ScDlrNnFiRGczaVpNcFhJS2xCMm44?=
 =?utf-8?B?Qk8zOC9kMXJreFlyTWlIOTUzVng3VlRJTEFxNktTUjJuWDE1WVB4T2RHOVh0?=
 =?utf-8?B?OFl0V3p4c2dKbzczQkFqa3NmVmlsRSt4RkpUVWtCYUJFU3IwVkRhdldwVTBZ?=
 =?utf-8?B?YWJCcDJTZGdHb0grcmFDZlNOTk03L0ZrN0FtR3dmc1JKSVdKYWphM2R0dWNv?=
 =?utf-8?B?RmJNd3JiUUFQeWRabVErdHJ3QXEyWVBlbUtrNHU4ZHBxMkd6R2RRMHk3Z1p0?=
 =?utf-8?B?QThOZXhvTkZkYkdDd2hOTGdhUS85eDgrd2RxU0plcldoY2FpRm4vVjl0RzAw?=
 =?utf-8?B?SE1OVDRGM2duNSt6VEFORmFkTW94ZUVYU1RPVmhqbis2Vy9MOTFXSkl5di94?=
 =?utf-8?B?UlJ6TnNMcGV3L3E1UElwSFJQVHFhS25xa3RuY0VSNVhySG92QkxaM0J4L3Ny?=
 =?utf-8?B?Y1pWeVRkd1pGa0hiaGpCNHNGNEltVjk5RG5Zbmw3ckswUGhabDV0MEYybE0r?=
 =?utf-8?B?R0VzL3VvK0liaFlzNWxVcC91UE1jN3ZjOXdiUFhLb25oanBkOTV5WENHc3Fw?=
 =?utf-8?B?MzBCeXpZWG45bHdZakRYSklHbElONGg2aitCS0dFa3RzbDhIQnh1cWtBRmdB?=
 =?utf-8?B?eGxLU2Q4c0RsSnpNaFA3eXo4TWhiM0hFY1JHS1N2V2htWjZldndPVkRwYkcz?=
 =?utf-8?B?VE0veldodmNsRkVyNi9zOXRqTGJPZ2EwTmJwcWp5dkNINVRlM0VqUS84S2dp?=
 =?utf-8?B?aGFnZ25TazFxRk5rMzcwN2twTGo4RTNUSUpmQVpxM2cwUjQ3cFAxNnN6OWdD?=
 =?utf-8?B?aDd0MDFEZDY2ZGlBanFIbnY2bmZPYkM3eEg0b1A5ejNtL0szWC9Mb1FJcktx?=
 =?utf-8?B?a2liOXN4UzE1NWtqaUkwbC9UZ0x4STZPSTlMTjEyMFRLQjJ0QmdzSXZxRWRj?=
 =?utf-8?B?UUJtZ3VCQ3g2Wmp1Ny9wL1E5cGJKRkFoQ1oxaTcwWGR5L0tFVWZpbjJCZkN6?=
 =?utf-8?B?WHN6Q0t2Ny9vUTQxbVlWYWRKWDc5bVBpY3pjV0NORk1mWmFhWmsrSzdvY1V6?=
 =?utf-8?B?N2pyOUEvVzU4OE91VzN2RHc0a0hMcnAvS1hpNk9zQk1obnZCNGUyRU5uTEps?=
 =?utf-8?B?di9UckJCbDUyOWtjMTFZcGx6SDBHcmtHMlZ5WEdXZEI5TWlTOUc3MVBUNlJu?=
 =?utf-8?B?WUh6VU5tSnhMcUJ1V05JM2xxd2RaR0d6dDNEUmhUNkYrRkN5UUJaTlg3NVlL?=
 =?utf-8?B?QlZ1ZkRqMW5GZDM5TlpEM1F6Z2lYN3FrTFRnYlRwbEdscVRLSmVEak5yVmNW?=
 =?utf-8?B?K2ZTSmZRWmx2cFNjYW1LcmtYQzBxaFdla0orVlA0OWNuY1ZGRWxRdGl4TGpY?=
 =?utf-8?B?Z3RPQnV2Q0NLSXR2M0cxWStBWWRUWEtxaWFLNWZseEVsWVpQV1BCYitaU0xu?=
 =?utf-8?B?OUhEU3FXcmJJbTVzTUtzdDBlaWhCOERVMzhGRGV1eWZIdlNzQzQzU3dpU2NP?=
 =?utf-8?B?Yms4dHhWL2NMSnlVa05VSlRMTHdiUlU5YXk2a3puSHBoYW5CdEdjMnNWeTAx?=
 =?utf-8?B?K3JOUFpuQ1NKVHpOU0ErSlF3STQ5K1Y2OTBwYkozc1VxRDlxdi9SbE4ybGZB?=
 =?utf-8?B?SFBSUjZEdTFZaElwZUlramFRZys2UEd3OE1Pdzh4V0dZV1J4QmJWazYwMmlJ?=
 =?utf-8?B?QkY5RzFCZXBIeDVnYmpsOVo4aXQ0S0hQUDNSSzh6NnZiYlZTTmltb0xrRys5?=
 =?utf-8?B?akJCN2pkZThRek9idzg3cFNuN2xLVVJPWk4rVHlGMVZvY1QvODNkOTFCbi9v?=
 =?utf-8?Q?gOm0BCZ9ObiV1eRA5PtZ/A2xz?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a0794909-a6ba-44e9-decd-08ddc87e54ae
X-MS-Exchange-CrossTenant-AuthSource: PH3PPF9E162731D.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2025 17:45:07.0459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ojmFS5FBHOvVCfOkyB3oa6WX9+toHWWOScNZvDaS7J+xFE3fs0OBHUdrXTqfPnJT1CXi0HnLLVJ3kgL+HPNv6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR11MB5974
X-OriginatorOrg: intel.com

Vishal Annapurve wrote:
> On Fri, Jul 18, 2025 at 11:41 AM Ira Weiny <ira.weiny@intel.com> wrote:
> >
> > Vishal Annapurve wrote:
> > > On Fri, Jul 18, 2025 at 2:15 AM Yan Zhao <yan.y.zhao@intel.com> wrote:
> > > >
> > > > On Tue, Jul 15, 2025 at 09:10:42AM +0800, Yan Zhao wrote:
> > > > > On Mon, Jul 14, 2025 at 08:46:59AM -0700, Sean Christopherson wrote:
> > > > > > > >         folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &is_prepared, &max_order);
> > > > > > > If max_order > 0 is returned, the next invocation of __kvm_gmem_populate() for
> > > > > > > GFN+1 will return is_prepared == true.
> > > > > >
> > > > > > I don't see any reason to try and make the current code truly work with hugepages.
> > > > > > Unless I've misundertood where we stand, the correctness of hugepage support is
> > > > > Hmm. I thought your stand was to address the AB-BA lock issue which will be
> > > > > introduced by huge pages, so you moved the get_user_pages() from vendor code to
> > > > > the common code in guest_memfd :)
> > > > >
> > > > > > going to depend heavily on the implementation for preparedness.  I.e. trying to
> > > > > > make this all work with per-folio granulartiy just isn't possible, no?
> > > > > Ah. I understand now. You mean the right implementation of __kvm_gmem_get_pfn()
> > > > > should return is_prepared at 4KB granularity rather than per-folio granularity.
> > > > >
> > > > > So, huge pages still has dependency on the implementation for preparedness.
> > > > Looks with [3], is_prepared will not be checked in kvm_gmem_populate().
> > > >
> > > > > Will you post code [1][2] to fix non-hugepages first? Or can I pull them to use
> > > > > as prerequisites for TDX huge page v2?
> > > > So, maybe I can use [1][2][3] as the base.
> > > >
> > > > > [1] https://lore.kernel.org/all/aG_pLUlHdYIZ2luh@google.com/
> > > > > [2] https://lore.kernel.org/all/aHEwT4X0RcfZzHlt@google.com/
> > >
> > > IMO, unless there is any objection to [1], it's un-necessary to
> > > maintain kvm_gmem_populate for any arch (even for SNP). All the
> > > initial memory population logic needs is the stable pfn for a given
> > > gfn, which ideally should be available using the standard mechanisms
> > > such as EPT/NPT page table walk within a read KVM mmu lock (This patch
> > > already demonstrates it to be working).
> > >
> > > It will be hard to clean-up this logic once we have all the
> > > architectures using this path.
> >
> > Did you mean to say 'not hard'?
> 
> Let me rephrase my sentence:
> It will be harder to remove kvm_gmem_populate if we punt it to the future.

Indeed if more folks start using it.

Ira

