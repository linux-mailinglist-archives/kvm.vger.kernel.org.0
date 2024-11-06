Return-Path: <kvm+bounces-30843-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 04E4F9BDD90
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 04:28:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F0F4D1C22F08
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2024 03:28:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A41B190079;
	Wed,  6 Nov 2024 03:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bzgX1+w3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1802264D;
	Wed,  6 Nov 2024 03:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730863683; cv=fail; b=oQaYWmXT3238PhP7DN4BBPCvM145msDcAexO9OfYG+Qas2fv5a0L0QQSlylN5ETRu4daIMkbNXrS1vW9wgl1e8kGFgJXjhwm5MgJPyK1FlR+TygEzYf09+2aVbrTSsd8BIvpjSYqreC9FJZvaLnQHyiptdqIx2wEP+KMh2xQd30=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730863683; c=relaxed/simple;
	bh=z2I91KDb0Xj/zef3ZA2pzstw/ZtFormoJszHNjqVT3k=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=E5Mess6RGZDbLQcZ4drPoln6E3nloCqgy7a3kXucIBCUN6bPh0pTdZXg129azSt06vqf7fp18rXtnp5L5RIWfKi+DMmZPvzMrCbVoahHP7dMEeXvUBqBWF/HQODmHKKMgt0fPlnH1aJyYaJ/w5nmfnAlTzvc78XaEuuSeQBCllI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bzgX1+w3; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730863682; x=1762399682;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=z2I91KDb0Xj/zef3ZA2pzstw/ZtFormoJszHNjqVT3k=;
  b=bzgX1+w3MhUDTWRi96Ks7FrxlePHog/u5V5/9M8xGIO/x7kpY0tSusTf
   hvH5zssDLdbDOPVBINbso/impmXv0txSDK6VuPvaXlOa3lbsAWvH6rjxV
   6ufRJ1dpWoYZ/YA+Fn0aphVsE+8WLwwXBLNFQ2wQDyphM+ZaQn0qU+egq
   dGhYn3ikNxXK7LdpuPUTN+GPE2JuDgju50GTdoVKL/LXR0sU9yzcmDWCL
   rlg24CVPcLYSO69zTk0VrCJx1c2pJJAjQmxOdiT7a/+43ztxyY870JWAf
   LLGcKq2QTmJ1LVeBh3LvucRcYv57OhPHsX5CLY7Oow0iy9hY16UgeP91c
   Q==;
X-CSE-ConnectionGUID: ZrY/SQwIRQWFsYM4He3LZg==
X-CSE-MsgGUID: M2STjTMGS0iTvHE5vFOCNw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41747305"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41747305"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 19:28:02 -0800
X-CSE-ConnectionGUID: E8JLThSwSwSoyWJdl/h9NQ==
X-CSE-MsgGUID: AoV9SvYGRZiMnMLp6lw5kQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,261,1725346800"; 
   d="scan'208";a="84210230"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 05 Nov 2024 19:21:05 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 5 Nov 2024 19:21:04 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 5 Nov 2024 19:21:04 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 5 Nov 2024 19:21:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nHPbYJHnsSOO0+DE3xSfHCzs2oYo1tUnEyxIQtK2PsXM1W0dA2gPhHilt0hXaKvq/xY27m6PeInMdxVMqgmoaZoE503oFav1xPEAui9pbRNlD34aD8rWY8TYXLIiP7lUYcEJyHTVwCw/OHWEUHTkamX50nhdrfZP1sHUhQQLaeO9zKewq+wbTYHMMFGQiHegTZ4WLr0beJwPNzDaC6AHNH9UWdYn/5CwCeNpOhkp2I9QGH/sn63UJPs+/rqn1yjveRQlKNxPh8rKGiK3KTQbgVlsZSqZvVqVp3+Hpq4UgwPWUyapyzQTJdHlC9gh0pdmxb3V+4yg7sWpNEC94JB7tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z2I91KDb0Xj/zef3ZA2pzstw/ZtFormoJszHNjqVT3k=;
 b=GSxICuG8E52MkAhIqqPZOXgvAnq8DjkG2JkIfHNXah0UyR/2pQJhNtUwJt++7/rsICVOETFgf3DNeze8tSUwshRFONlHXURzwjJ0lw9FdAygwL2ozPVGNJFIftaE1p6y+j5dQ4aqWhfXPldw+fQfEkoh83w3B8NA1Hi4+9aF4xUND2f6JjAc0m453ohRpZL1oqZdqKb/oeQuVVRSRea0nOU8kVP4T7/xZGs7tS1EDMTe62l+luFJpgdntVYfuT2sALKAkrKV8q+eOVe3u9zYwcUsPdJ1MxK9pBG+JxmdNPdCAmJGZ0vHUn9zXd/eIn/h3E5v7Z+b5qjavwLidATF6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by BN9PR11MB5244.namprd11.prod.outlook.com (2603:10b6:408:135::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.31; Wed, 6 Nov
 2024 03:20:55 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.8114.028; Wed, 6 Nov 2024
 03:20:55 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Yang, Weijiang" <weijiang.yang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "peterz@infradead.org"
	<peterz@infradead.org>, "john.allen@amd.com" <john.allen@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "mlevitsk@redhat.com"
	<mlevitsk@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v10 00/27] Enable CET Virtualization
Thread-Topic: [PATCH v10 00/27] Enable CET Virtualization
Thread-Index: AQHaYwfwUq77Vfr47kSTqCeNyaqv3bGDeEgAgAbx4wCBIC/lgIAAeyGAgAAahQA=
Date: Wed, 6 Nov 2024 03:20:55 +0000
Message-ID: <00a94b5e31fba738b0ad7f35859d8e7b8dceada7.camel@intel.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
	 <ZjLP8jLWGOWnNnau@google.com>
	 <0d8141b7-804c-40e4-b9f8-ac0ebc0a84cb@intel.com>
	 <838cbb8b21fddf14665376360df4b858ec0e6eaf.camel@intel.com>
	 <8e9f8613-7d3a-4628-9b77-b6ad226b0872@intel.com>
In-Reply-To: <8e9f8613-7d3a-4628-9b77-b6ad226b0872@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|BN9PR11MB5244:EE_
x-ms-office365-filtering-correlation-id: 4bd7921b-fdd8-48f7-09b8-08dcfe1206aa
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bVlFMzdvbjJFTWJVaGZYdlNLUWhxeFBGVmNSa0ZnRkZZbjJmMkRHZGw0dmlB?=
 =?utf-8?B?OUVWZzBYOEJlRkRvdk1aUllaT2tqQ294OHQwM3M3MStBSDBhREp1bmtiUmxx?=
 =?utf-8?B?UFJUQUpMNnZ0T05wR2NYcVJjMXRTL21OY0tCWkgzMVFiVlVKZXNNUVZadGdj?=
 =?utf-8?B?V1JUY0x2N0JSS2h4anZJZk55NElJVTVLYlE3ZE1XcFVpV0NwbHc3NUV3Y00x?=
 =?utf-8?B?TGhKWnhOVUNZK2lYZjVuWlRmTW13YTJjTlRRRWdUazg5Z3crWUl3M3Ava0dv?=
 =?utf-8?B?S1Zacmt0WjBNQThOcjBadS8zQmtwcWhnUlQwOGhuamloSVR3MjI1NHFJY2xu?=
 =?utf-8?B?REVDam1ESVlZcDVUOGp4cGhsNnFGNWRHMklib1lUT1hETmU4YmZiYkkydzdE?=
 =?utf-8?B?emplNTQ1Y1hmOU9EVXk5cWtUbXNlVXo3WkRvaVBIQnM4eTlVY0FOeENnNDc1?=
 =?utf-8?B?Y3BHdVNMV2ZxcjRWaFh6Tmo2WTlsaGE4aXZjVEpyY0JIcWVIajVMMjJUblFo?=
 =?utf-8?B?ZnhDVkNqSDVUUHlLeVJuZ080WTBza3ZEL1pCQVJmb1FiVWYyOUhXSWRuaVNv?=
 =?utf-8?B?TCtRUDJIZXZuT3ViQlUycVRIanptTXNpNjM5UU5WNWQwZE1NZVM2aDY0cXJL?=
 =?utf-8?B?VnV5RHRwbWpZOUpxb2luc0svR1JlSXFpZVFXRzUvcXVvQlBHZjM0dm1taWxY?=
 =?utf-8?B?L2hsdVlqWVZLb1NIRnlxaUhobWNlSGR2WVk5UzlPallYZkt4SmlPaHpMaS9E?=
 =?utf-8?B?Zk1LSWV5ZmVFSGRLVW1leEFTMmJrWndUVE1NcjJvRm1HaHRpRHlSOG9FakN6?=
 =?utf-8?B?OHRPc0FkNjdVcUpPbTJ5YXQyNktwM2xGRS8vTHJzYUxGZlRHN3p2eEM1WFRu?=
 =?utf-8?B?R1pRelhOS2wxbERLd280OERrSlFGZnRWdENaZy9JZHpyakl4aFhkdnBRTUhw?=
 =?utf-8?B?OXFFMXNFVTk5YmhUTUYybVlhSzROQW9GSmJndVRpektMb0tuNTVKUi9TYlZk?=
 =?utf-8?B?eWVnamp0U3RPeUlJL1ZtRW9SVjNFdFFvQlh0MkFINU9aVlhFRlJLNUhUMHJV?=
 =?utf-8?B?QURTU3duNGtlZnNOOVRiY2dkRDNKbHp0WWRFMGtmLzZYbnF6STM2ZEpQRXNS?=
 =?utf-8?B?a0duR2FGT2FUOTUyNVFzM0dnZ1VZNUxPY29Cand0NXVwdEdXWjIyOXdyUnhR?=
 =?utf-8?B?TnhtSTl4ZDU5Q3dVT1B3QUR5Z2d5UWpWVS9aVlk3WStBa3RtaGJkT3Njd29H?=
 =?utf-8?B?K1QyalBFMTdHNnRsVCsyb05xV2p6TFZ4ME9oTWExWHBpZlZuTTdrZ0YxN1B2?=
 =?utf-8?B?c0YzUFB4RUVyMGZpQ0VMQWErSmEzMnpERHJLZTBNb2tkZlNBNlpkU0g4ZE1Z?=
 =?utf-8?B?MFJ5RXBWOGJXdFJPZEJVM01md0dkTm1wdGNUYU0xd1pEWitDYklYZE9xQ0dC?=
 =?utf-8?B?MFV6Mmh2Zk1CcEREVXJHY05lM2w2L2tQR2pZRWJVQVdsRGtGWVJ3bFAzUjBa?=
 =?utf-8?B?YTdudXFUL25Jb2JzT2ZhaU5xVkVtNDBYN3lHMlRVbm1IRkJXNkxSdVJPQisv?=
 =?utf-8?B?Wnp0Y0JCZjlydnlsUWRTSTF3K2lnKzRoM05FL2l2dzNUNjZuODljZThNVzBM?=
 =?utf-8?B?ZnBLaEtSbmNWSjY4c08wQUt5UnphSzVpKzVEaWVENlFsU1lBZXZqWU5hdGxh?=
 =?utf-8?B?Y1ZseWVucmhuLzdqT2NaSkNiT1lVMFd6SDZnSndhRkpoN2MvZEV1cUQ1aDdj?=
 =?utf-8?B?aDlocWtnVHlkM01idkdxSjUxdDk1b3A2V0VsK09YVmdBWkFWcGJ4VkRPUmRH?=
 =?utf-8?B?ZFBGS1lJZDBCMlN3ZDVHSEsyMzZRVVJBZGZNY1hCazMwNm5ORkZOMEdJSzZp?=
 =?utf-8?Q?5FjZ/xKPU5Vgm?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T3F4L2hFZjBBNzRqemZha3VKOWNOa3VmTzRzc0szVURHcU9wU0NIWVpBUjVI?=
 =?utf-8?B?V2NDV2pJN3dmMUxMay84dkU3WmFOajlyenlaRi9NSXBmSTRxWFBJZ3FLWTJz?=
 =?utf-8?B?R21MemlDcGdMZ05WZitXR1N3d0YrTmhKbU5VY0kzdndHN0JvQ09LS3pVQWVP?=
 =?utf-8?B?SXVQbG1QSEhxSmw5cU5ZNHVrbkp3emIyclJRc1RBNDRDRklZWXA1Y2JnSkZ2?=
 =?utf-8?B?Z0EvMENsSEFEZXZvamhWcUJ3Y0Z1Nm5QZGJXWklibGwwakY0QXpnUjNuSm4v?=
 =?utf-8?B?YS9FdXh0SHhiQjVlbk11dVQ1NEcvVENFY3VsWml6a0FsYTZoOXdFQmRobTJP?=
 =?utf-8?B?ejlvVGo0bWFkUkkxakQvd2N6Vms0WGQ2blpxSUw2dk92TDNmUGNIWVpPUFpq?=
 =?utf-8?B?V2NjTGVUYWFvRG1HLzNkcDRIYllCMXlkM2pQakxRYnJwK0VyTDdRd3AwYUpj?=
 =?utf-8?B?dUxkSFptRDlQblA1RWxjVEJnMHg4TW4wVUhuZkJ4bkxYdzVVUDVIbTlHRnFU?=
 =?utf-8?B?alhxVUU2NXYrZVN6bzdSRzRSR0QyNjJEcXdQbXBuSHl5eGxmOXUzb0ZmaWVF?=
 =?utf-8?B?cUZDRHNTU2k2TzZTU1NhN3kwV2hnYzdPR0IyOXpmdThzQVl1VkM1WXJGVFRt?=
 =?utf-8?B?TXFsc1c0b3luRUh2Y2cyaUJ2cElUK2NSZjZ3bzR4MWhPTFdaeVhEZmN4bWdW?=
 =?utf-8?B?Q25HZTNoMW1kWDBIRHJ0ajhCcHh1TTFrSXBQR0hrd3lVVlZGUFFqS1lNcGEx?=
 =?utf-8?B?a2liNERvQWxSZ3cyZThOUGNRNW9KNGRleGlaQkJ0V21qenB6RVFqeEZSY0RG?=
 =?utf-8?B?aURsZkZjK0JOZURlVDkxSEMwakkraDlRN0NKY1lTd2hKekNYemY1WjNGUUdB?=
 =?utf-8?B?UWgwQUJQbXAyazB6Z2lpVng5SWdCUkw0NlZXSkQvQjBoeDdWMVVqcTlrTXBW?=
 =?utf-8?B?MEpXcFkxTysyanZQRkQ1cG9CNVlLZFlURktKQ05QNFRUR2FFL1B4dzdnUHBS?=
 =?utf-8?B?bmN2UUFTN2Nma0hoSmtodFJhTTA3Z1B5TGFxSWdldVA3SVVZSG5IYVBmd1lE?=
 =?utf-8?B?czN6ejljUXhXWnI3NTh6cnI0Y0tFZC9kMVAySUh0MzZhUkhRWUF5NzlmaE5j?=
 =?utf-8?B?VmF1R29jSlFDTVpaYmFKenNuVHRyWUg1SzQrSWQ0VlNZK1pvSFhCT216b3M5?=
 =?utf-8?B?cTdTTkNOeFQ4VmJvNGU0WWVWZ0lrTTdCd1NDZ2E3VXZWVFJkMWdvWkZ0T3Az?=
 =?utf-8?B?M1BUS0VGb2dLRU85TkRzbHArUFRUdGpVZk9TYVJOWEc2VFljdTZKL1YyUWNv?=
 =?utf-8?B?TGJ3cWJySUw0aFpZb0tFcm5ON0ljQm44VlhvNGFRcjlpbHhmaGpncUV2bitW?=
 =?utf-8?B?eURwZ2ZQblhXVWQydHlWekdlTVQxcCtrVmJUOVhBVmJNei9hcHd1QkRqZDBv?=
 =?utf-8?B?VGswank3UjFLZTJ3TlAzaHQ2TTRBemhIN3g4UnE4eGFxTnNWeTdHUmtiSWpB?=
 =?utf-8?B?YWwyTWJXRnU0aDJKd1Q4NFo2SE1DbzRGV1pPb0dVdEpubVViV0lNM2JiY0pJ?=
 =?utf-8?B?OVFUWEJCWUNCRnBCeDIrU0VBd3djRmx3Z1pwaGowQ2ZQQzNITW9TMGlKbGNa?=
 =?utf-8?B?L0Q0MHlIUHZjZ0NTZWw1bE5yK1REdGM2clRKVGFpbWtJRWNNQ1NWZjBtOGRt?=
 =?utf-8?B?NkU1YlZGMWRDdDNtYUZmY0VReFZhQTJkK0hHTWtqR3N1NXBJY0RsMHlnc0dR?=
 =?utf-8?B?WUEwcEF4S013azdEMUZMVDRlZW03bXZObzhOeUJmbGtSaEZHbEJyeSs4L295?=
 =?utf-8?B?NGcycnk0aWorcmVFeGlzdmpjS0Z3eWVja1dseTF2UlhLM2xLcmtxYi9QR0lC?=
 =?utf-8?B?Qjlpekh1SU5pc1RaUVZOeGdxNUxOS0pDSmtzb1JhU21QeVlPVTQzYUVCRjdC?=
 =?utf-8?B?dHBmWFU0L1orLzhLOWZUMnk4d1NDbnAzNnV5ZVBGdGIxa1lUbnJITE1CejJj?=
 =?utf-8?B?cVZYa2RiM3RxRGMwMXFqUFRXOGhzUnBrL3Jrc29kcUlJbm9VTHBWaG1iMFpL?=
 =?utf-8?B?VHdrOWpJc3BTcU5DU0h3cTg0TnFsdGorQXRibjVOTkF4eUgxZ1BpRW5UdEZH?=
 =?utf-8?B?MkJDVWQ0UXFYa1EvVlJJTUlnQmoyYkRXcVpXSitJeTZMWENiVFFEYUdBYnk5?=
 =?utf-8?B?dWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AFE498B739F9384B9C74F6E943E5E753@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bd7921b-fdd8-48f7-09b8-08dcfe1206aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2024 03:20:55.4206
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SruZpRv3q1qBv7kKwEXtF2bdu12irV+brZNV8UD5BiiFYC9mRSSstmq1ogqycr3EKTSTQeLLOiSzEjKRDsvMSlCAMbY2qAbUIlYTYy49Bqk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5244
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTExLTA2IGF0IDA5OjQ1ICswODAwLCBZYW5nLCBXZWlqaWFuZyB3cm90ZToN
Cj4gPiA+IEFwcHJlY2lhdGVkIGZvciB5b3VyIHJldmlldyBhbmQgY29tbWVudHMhDQo+ID4gSXQg
bG9va3MgbGlrZSB0aGlzIHNlcmllcyBpcyB2ZXJ5IGNsb3NlLiBTaW5jZSB0aGlzIHYxMCwgdGhl
cmUgd2FzIHNvbWUNCj4gPiBkaXNjdXNzaW9uIG9uIHRoZSBGUFUgcGFydCB0aGF0IHNlZW1lZCBz
ZXR0bGVkOg0KPiA+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvMWMyZmQwNmUtMmU5Ny00
NzI0LTgwYWItODY5NWFhNDMzNGU3QGludGVsLmNvbS8NCj4gDQo+IEhpLCBSaWNrLA0KPiBJIGhh
dmUgYW4gaW50ZXJuYWwgYnJhbmNoIHRvIGhvbGQgYSB2MTEgY2FuZGlkYXRlIGZvciB0aGlzIHNl
cmllcywgd2hpY2gNCj4gcmVzb2x2ZWQgU2VhbidzIGNvbW1lbnRzDQo+IGZvciB0aGlzIHYxMCwg
d2FpdGluZyBmb3Igc29tZW9uZSB0byB0YWtlIG92ZXIgYW5kIGNvbnRpbnVlIHRoZSB1cHN0cmVh
bSB3b3JrLg0KPiANCj4gPiANCj4gPiBUaGVuIHRoZXJlIHdhcyBhbHNvIHNvbWUgZGlzY3Vzc2lv
biBvbiB0aGUgc3ludGhldGljIE1TUiBzb2x1dGlvbiwgd2hpY2gNCj4gPiBzZWVtZWQNCj4gPiBw
cmVzY3JpcHRpdmUgZW5vdWdoOg0KPiA+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2t2bS8yMDI0
MDUwOTA3NTQyMy4xNTY4NTgtMS13ZWlqaWFuZy55YW5nQGludGVsLmNvbS8NCj4gPiANCj4gPiBX
ZWlqaWFuZywgaGFkIHlvdSBzdGFydGVkIGEgdjIgb24gdGhlIHN5bnRoZXRpYyBNU1Igc2VyaWVz
PyBXaGVyZSBkaWQgeW91DQo+ID4gZ2V0IHRvDQo+ID4gb24gaW5jb3Jwb3JhdGluZyB0aGUgb3Ro
ZXIgc21hbGwgdjEwIGZlZWRiYWNrPw0KPiANCj4gWWVzLCBTZWFuJ3MgcmV2aWV3IGZlZWRiYWNr
IGZvciB2MSBpcyBhbHNvIGluY2x1ZGVkIGluIG15IGFib3ZlIHYxMSBjYW5kaWRhdGUuDQoNCk5p
Y2UsIHNvdW5kcyBsaWtlIGFub3RoZXIgdmVyc2lvbiAod2hpY2ggY291bGQgYmUgdGhlIGxhc3Qp
IGlzIGJhc2ljYWxseSByZWFkeQ0KdG8gZ28uIFBsZWFzZSBsZXQgbWUga25vdyBpZiBpdCBnZXRz
IHN0dWNrIGZvciBsYWNrIG9mIHNvbWVvbmUgdG8gdGFrZSBpdCBvdmVyLg0K

