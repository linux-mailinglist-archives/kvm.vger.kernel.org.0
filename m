Return-Path: <kvm+bounces-31827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 632259C7F57
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 01:22:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C3BD8B22875
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2024 00:22:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9031BA42;
	Thu, 14 Nov 2024 00:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AeKMcFNe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C39917C2;
	Thu, 14 Nov 2024 00:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731543737; cv=fail; b=mdE3m2L9wq2oEtJjOrDlASAuQfFESin3vk2T8ff8L3lan9IrQBRPd/71fKj8jv/0ffzZp5q1j8+ZMQKq7kQPgXtQSoGLge/sKs9PcYtFJNwllnpwgEpCuAjdwtvL/c9MMBwD0yEY4CgJAS6z1H0mVEo7fNLxrkpMDBzqUYk7R4k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731543737; c=relaxed/simple;
	bh=pU5WGVCrFxwYFSYp/yNSHoBD2gcbKgttXcQlZvKByCI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=jTs6e8OyI1irkuxlWDMtaxuGdG/ryNEvlKGIX0VpzQLMUGJrnTXjiqWK26LR4QoeYWVf0d2ETuhkIAy/SsG6d65UvlTaf3gcwia2qvMllAvVFUS0FWasOWvepQI5igxe44LE27MyNdqY+O9l1CxIByupPgjB/TJKecVGZC1REQk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AeKMcFNe; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731543736; x=1763079736;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=pU5WGVCrFxwYFSYp/yNSHoBD2gcbKgttXcQlZvKByCI=;
  b=AeKMcFNeNQkmPy06AhaUVLG9hDipDexGR5vTz+YjysOQGINPQ8Arcq79
   emN7hcu39r0FxOH+NKYdnmXaALCTGh8OBmzdLJHMWeRP6aPLDRTO5Rccm
   Cr/kBf8UTbi+L98SaJTcQt3V3gEG5aIiyfvKOZ/UBGvRWCApXZZVR56fF
   mfb5ZJ5vMERK2+u6czOS/8kZH58FWZPTHFyN/ggcvS3Mpr5zKoN7s+py5
   ZeZeMUNI8PyIEJxMky3nQJzzF+5/bIT1UqRySRvPTkaA7OORp77z9Q0iz
   ZqylGEmcRBlBR8B5LCI0dCN1tEeuY+zayWDkNqIcXeLan973Wk/D2/yLB
   Q==;
X-CSE-ConnectionGUID: 6cHrtCMqSeas9AfCQ3O03g==
X-CSE-MsgGUID: Ep19f7cPRwO3r3YrPRxKtg==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="42578385"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="42578385"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2024 16:22:15 -0800
X-CSE-ConnectionGUID: Eb81wNjZSXuevp4E2fQCUQ==
X-CSE-MsgGUID: U65QpYyBRwmvzcZlcE5pgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,152,1728975600"; 
   d="scan'208";a="88422781"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Nov 2024 16:22:15 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 13 Nov 2024 16:22:14 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 13 Nov 2024 16:22:14 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.172)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 13 Nov 2024 16:22:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cKS48MUkmo+/PniWLnG70WIWboznMkSBkimgvc51o7VLTDXUiO+jwuJWhuusfRdVH6AlBEOPW3RIgQz0/Zy262nc0mKgXlgukt+Gz7kCmZ/BU5YaUlBdnxBEauKV8JbWGx+mWY4TZB2RhbyaWAJ0A+BX8eaZUocMk/LCVltXgnALeMKI5UDn6Frmk4/wZ0vE3oHHapE4guBOxT3ZJVMhNFnt5ssnb/IY3VFpXP5qQCFv/lKK8ses52k1sxpB4R6nhx3YmNzyATr82CSGFiXsTeB/7QMPvUs35cLx6mxOgXZIa4gJ7e0xpl0SaoLsdMlmLyGWyAkv66mYHjBUDRW60A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KC/7d//Qyi0+n4DwID5IHxfOE3luM+ZduvK4SBkQ5SI=;
 b=Ea5/04igWczE4h4XF1RJi3NBZZcVPXTtX9NM+IHvPAhO7eX+bhwqNj9SoY1jKYDsDMMDpYdhUoUQ07AKBSBrgDrqxd9goEfXH2tK+Cf9k1LrGHjOruXo+cR/Vc0FJWy/avjir0S87isWcVpICA9vcQVzkQY4rO0oYhXoTbluwzBhda38FZzYSAs0yxmKb2457Cfxii3sO4anY7Y6/IQHJKXfpU11Mirv2ppvh4/H2m5RmYnwTwiOKgEo5Xb1s1HexBT2sPodY9tro6Y87haJXXClY6OV/OwXiEEgxTpb4pMroNhb+1FUShWyN5/Nq9Ez0n81J9FKHESrawnThBvMsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ1PR11MB6154.namprd11.prod.outlook.com (2603:10b6:a03:45f::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8137.28; Thu, 14 Nov
 2024 00:22:04 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8137.027; Thu, 14 Nov 2024
 00:22:04 +0000
Message-ID: <3f9752a1-53c1-4be0-a3a0-8be25d603dc2@intel.com>
Date: Thu, 14 Nov 2024 13:21:56 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/25] x86/virt/tdx: Add SEAMCALL wrappers for TDX page
 cache management
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"seanjc@google.com" <seanjc@google.com>
CC: "Yao, Yuan" <yuan.yao@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
 <20241030190039.77971-9-rick.p.edgecombe@intel.com>
 <aff59a1a-c8e7-4784-b950-595875bf6304@intel.com>
 <309d1c35713dd901098ae1a3d9c3c7afa62b74d3.camel@intel.com>
 <ff549c76-59a3-47f6-b68d-64ef957a7765@intel.com>
 <2adb22bef3f5d2b7e606031f406528e982a6360a.camel@intel.com>
 <e00c6169-802b-452b-939d-49ce5622c816@intel.com>
 <92fcc4832bdb10be424a5bcd214c5e9e746ede44.camel@intel.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <92fcc4832bdb10be424a5bcd214c5e9e746ede44.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR17CA0018.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::31) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|SJ1PR11MB6154:EE_
X-MS-Office365-Filtering-Correlation-Id: 7a6d7475-95d3-49a9-ba45-08dd04425da0
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?M1dxbFRGZnQ4TFl2MGIvaE9KcHZ6QjkzYW5HSWViRTBVdFl2QmZ6MXRTbmo1?=
 =?utf-8?B?SVlwM0RVQkRKaGxqOWxiaUFQZ3l5ckwrTmlpUDVOM0huOFQ3MWRTRGFURmVE?=
 =?utf-8?B?THRXYWdBMmJENlM1S0NPZ2hVT0VrNk4vd0hZRzRQdTJlekZBbFVHbXRZYStv?=
 =?utf-8?B?cTlBVGZDZzVxRXZoSVJtVmtCZ2pCRXl1L0R2c3lWeG4wby84V25iUkRjUFYz?=
 =?utf-8?B?UlgyOGZGNFdHdjNTZE5aTG51WkRuR2FsTDBEcFJBT1BKUytTSkZhNzZDWTZQ?=
 =?utf-8?B?TStpVGM4Sm1PakVtMXA1TmZWY00rbldscVpFU3ZXcWxwL3VhMHIzMUR2V1hl?=
 =?utf-8?B?a1UyU0tsUC9maUVtcmk2Vy9xT0xDKzE5VlNXVDZBdU11ZlNoZm9qSU9CVVpt?=
 =?utf-8?B?NzhHNnY2WHFYY2t6K2VIbTEveklqOFhnN1NzWVBYZVByWFNLRExNTUpUNVZi?=
 =?utf-8?B?bkZLSDRaZmJWblA4TVJnU1RxNnd3ZWxMazFaNUVLUFJRczB3UlVHOEpaajdW?=
 =?utf-8?B?QWdXY3Qwek54dkNZT1YwR1VYN2RHY3E2OWllNFE5WGF2ajMzV2FsWWJYeU9R?=
 =?utf-8?B?L1RCd2FraWdhcXB0anFlQ3h5L1VCclQrK2gxMG9LRkc5WitzY0RmMklpOVo2?=
 =?utf-8?B?VWRPd1daTWtkWXNtbTRSaDZndUxlYW9TeEZ0NlgySEowT0tNb0VGcmJDd29t?=
 =?utf-8?B?U0ZPZzErMVVCVlVHdW5VaEcrTTV2Yy9LN0ZpSEdhUkFMbFlqR1pCL3RrZUN4?=
 =?utf-8?B?NU8xRUVqMGY5TDRyN2lHZEhEejMxMGN3RXhyRWVlZXc3S21uWEloQ01DcVBm?=
 =?utf-8?B?LytHb3Q2aVYrQUVrOVFhOTFWMW4zSUdJeUoycUVmMEVSalFYN1JDSUV5d2JG?=
 =?utf-8?B?RGNycGdEU0srcFpNSUtaalNZTGFnZTdObnN6QTBlVTRVSHVodWdJbm1pRUgx?=
 =?utf-8?B?bnpVdHNwc1BnOHFyZlF6YzhRa21lSVBJY09YRlZ0UnYvbEEwQURkWnUvTVV1?=
 =?utf-8?B?U1hiU252RHdTZ2RIM24yRnM2WHVCWURxQmRKNzR1UjhBREkwNFY0VStqaGpi?=
 =?utf-8?B?V281ZTRGRlJOMWUrV2VFSTJxWTJZazNjU0gyOGF5Tm9QaUhqell0V0QvVkJR?=
 =?utf-8?B?WTlZeGgybzJzVVR4R3pmZVdjZ2xZRXpZSExYSFcybW1aOSttbElKQzgrOXRi?=
 =?utf-8?B?RDdHODZaSzhWTzhnZGpIZm5ObG1iVjUxcTZzcFh1WWgxUmNJRmVxd3dpZjVj?=
 =?utf-8?B?YWpqUVR6Y1JXcUlMcE5mYUVzQ0IyNlMxUndhTm5KRUE3aWVLZW9OQUpPUzlD?=
 =?utf-8?B?Z3JqSkdmNjhXWm1wQjB2YkMzSE4rQjVacGhUdVpBams1S1JTd0xuYVgwUC82?=
 =?utf-8?B?cDdYRVlCN2NWMkxrVFZhRG12em4xVk13by9WRDFhMEdsVkFGbUp3ejNCMzd6?=
 =?utf-8?B?eTJtVTVVcDRSSDdXcWRXOStFUjgzSlg4RmFDUGtabko1OGk4V2grdEYwVjBJ?=
 =?utf-8?B?SCt0Ui83WkR1T1RZN21mL3dzN0ZZZkRRRWdEY2RaeE91SlJBTmlUTUdFVmQr?=
 =?utf-8?B?REYxdTc5TGd6bUE4dFBUb2IzZTErSDJQdjRyMzBTZEh2YXVVejl6emo4ZHNq?=
 =?utf-8?B?aUk2SVd6NnMwRFFLQTI3aUVhVitzRmpPMG1OM1dPOUQ1RVltNjlobnFHdWI0?=
 =?utf-8?B?dHdPeG9pcFZUeTBQcE1jamp0SjVod01ncERpTkxZM1RXbGNQZ0ZEVVI0OGhF?=
 =?utf-8?Q?5HxMKmv21aRWwJ111w=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eitqci9Obi9RUVY4MUpmb2ZncnFaYlNyNHFDY3h5UnpUR2RJQXJqamdLdXJx?=
 =?utf-8?B?R3o3TURYZVQvcjhZeGRLMnR0c2p2RWtxcjdkNHJtdE5qdEVrR1NBamhQSHN5?=
 =?utf-8?B?YkFuY2VUd1gzeEdKbnhuYzJmdzFOMU9BKzduYitWWDQ5dlJva3RXYnNNcnRj?=
 =?utf-8?B?eGt2T1Z0aHhYVmQ3U2VNZTUvb2sxVDdYSWVOejM4TTYyRjVYTFpCZk5TNmZk?=
 =?utf-8?B?WHBXM2xoRHVjRVNXbEkxQWhLTGlmeDRLSkN6aGJrdXZTa3loUS9KN05MV0Iy?=
 =?utf-8?B?SzhiQjJJZ05sUlJjS29wc0pmOS9ZVHVkZ3FkVHFlRmw3WXAyTFB6aTUxemxI?=
 =?utf-8?B?OE1QU2RKOGY1WnNIY0hqa1NuZ3NBNlhKOUdoalpYKytZMDhnWThKR0pXTHlq?=
 =?utf-8?B?dWFZc2xHMnRYRHU3dm13ZnUvR1djWjVtTGZLRzlNNEZqeEhSNHFTVmtoMGEv?=
 =?utf-8?B?OFA3WjlTdWhwWjU0ZW9waVRiQU5PUWx2MzFZeXJ4RjhLSnhXOWhqdHVTdURk?=
 =?utf-8?B?V3RxL3ZUYUJVNUh4QVQrMEc4NHRVL1MrbXFZejlMcmlNUUt6aU0waVc1eHpB?=
 =?utf-8?B?cStjVG5wRElyd0YwWk02ZWJmOGw0bVBhNVd0Z2ZlR1BkREsyUVFTWGlHU21F?=
 =?utf-8?B?K0swTXJCU0QvcVY2TTVUWXRMSmRpTDllQ1pVSCtzV0NpaVIwUTV6Ni9CMUFJ?=
 =?utf-8?B?WmhxV1g5TEJYUmsrU1lESU8yU0FGWGZaS3VJVE9hWk0vcWUvb0JBYktDUFla?=
 =?utf-8?B?Wi9VcVI3eUpGVmQvUHE5SU1uK1IyenRVa3dwVTl1Y1VxR1RaSXNKamcxU2RP?=
 =?utf-8?B?M2FQdEpsQXljSEJuTmQyN0p6MzlJRnVsMFJUTjByYkNWTlhuV0lCZXV4TEhD?=
 =?utf-8?B?ckNwUGdkRml2SDRFYm8ycHJuQlprZi8yZGpyUVRyYUNqakE0TjJET050NFNw?=
 =?utf-8?B?bExGWUg3WjhuTlZZNEhZQlR6Vkpvc3F6THM3NVlOKzVPQ1ZURmp5OXBFcGZh?=
 =?utf-8?B?RFNwb1dCM0d6b2JJT2wxMGRyRitxaG1PN1EybDVONTBCdFdCYytGbEU1V1ZK?=
 =?utf-8?B?RkkzMHBQOHFJRnFLR3ZsYnlwb2VEUWFLd2NpR2VRNDRnQytKMmZGZG4wQit0?=
 =?utf-8?B?VzNyTUNCK2ZscCtXdlJZUVVWOUYralQzZzgrUXQrblNIMUllK0pUTlZoWE82?=
 =?utf-8?B?YXpIanZNeHg2aWo1TE9DSC9Cdm1XczJqbEMzVFVwcG5ndmNScmVaaktuRjc0?=
 =?utf-8?B?UGpuRXVKeUFNWFZEQ1JIdDVPVEJLeGttU2ZsNXh0WGJFK2ovbFRWNStvaTF6?=
 =?utf-8?B?TmUrTnBCRVR0Q1JoWlhFSzl3UlBtZGpmNFM1MlkyTmhDeVJvbUh6Y2t4S2Vt?=
 =?utf-8?B?ZW1jbDFLL3pUVHdhRDREV0d3QnJtbW82b1V4NTJ2MzVzTHlTemN1cFlVSktI?=
 =?utf-8?B?VWVES2JMVVNZaTVJMGRxTUNjcXVZQzc4V21WZXVTVXEzM3VaSFB6Ni9oRi9V?=
 =?utf-8?B?RWhkMExCbFhxWXh5MkFMZ0p1OFNvaDRTOEo0T1ljdkYyMkYremVuaGJ4Rnpp?=
 =?utf-8?B?U1VJNkl2R2JqRDdzd1pkNGtDb1ZlbG5rZmZ2SXdRb0J3R1d5a2dmMmpSbzRa?=
 =?utf-8?B?NWhCbWZVdndkTUZvc3hhb3pHU1ppTUNxS3grYWtSQ0ZQNFY1UXNPNE1wLzcz?=
 =?utf-8?B?OHRlOVlMUjh6Z2hUUmJWNWpCRTJ3Ri9nRlVndHNvd3F1bW5UeTZnNS9KcE8w?=
 =?utf-8?B?M0s5dVhXeHJDeW44OUFTUmg4Ly9vUVFwZWlrY3h0bDBvbXBZc2JQaisxYVJs?=
 =?utf-8?B?eWV1VmgrWDZ3LzdEL0Myb2JFTDFvM09nUWFvZFVMWHhhUGhuVlRmV0tPbEdv?=
 =?utf-8?B?aUJuTWk0YmUyUllDTEVZQ3Q2cUh4ZWFnMHRtSGcwMHFLU3lRYzNlZ2NZSWli?=
 =?utf-8?B?SFdUblhERUhXb2lqYVpMQ3dwb1VzcnpHQ1FBQWlYUExxSTQzR1EwdjJOVHVJ?=
 =?utf-8?B?THgrS0dZOGdrcEdRTG1UYnVDckFPVXNVUUZMYS9vWDVlbThCY0x4cjJWOHAr?=
 =?utf-8?B?WTZoVVYrOGhrUGkwZFJxYm9IRzFrTkRMdXRPclBYYUNJS094K0QwMnM0M1ZR?=
 =?utf-8?Q?408H4BI/EpEdOjWiYcyr33GQk?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a6d7475-95d3-49a9-ba45-08dd04425da0
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2024 00:22:04.4771
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U8AIVyfBVwmo/4C/TTFYcAKiNwiOSwrYMx8zfF77YAssTJxbDauUjr46jdCuAHbeOZ/GgMonU1b7H5RjMmo6mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR11MB6154
X-OriginatorOrg: intel.com



On 14/11/2024 11:00 am, Edgecombe, Rick P wrote:
> On Wed, 2024-11-13 at 13:50 -0800, Dave Hansen wrote:
>> On 11/13/24 13:44, Edgecombe, Rick P wrote:
>>> Moving them to arch/x86 means we need to translate some things between KVM's
>>> parlance and the rest of the kernels. This is extra wrapping. Another example
>>> that was used in the old SEAMCALL wrappers was gpa_t, which KVM uses to refers
>>> to a guest physical address. void * to the host direct map doesn't fit, so we
>>> are back to u64 or a new gpa struct (like in the other thread) to speak to the
>>> arch/x86 layers.
>>
>> I have zero issues with non-core x86 code doing a #include
>> <linux/kvm_types.h>.  Why not just use the KVM types?
> 
> You know...I assumed it wouldn't work because of some internal headers. But yea.
> Nevermind, we can just do that. Probably because the old code also referred to
> struct kvm_tdx, it just got fully separated. Kai did you attempt this path at
> all?

'struct kvm_tdx' is a KVM internal structure so we cannot use that in 
SEAMCALL wrappers in the x86 core.  If you are talking about just use 
KVM types like 'gfn_t/hpa_t' etc (by including <linux/kvm_types.h>) 
perhaps this is fine.

But I didn't try to do in this way.  We can try if that's better, but I 
suppose we should get Sean/Paolo's feedback here?

