Return-Path: <kvm+bounces-12945-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FAF088F5AD
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 04:04:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C12DD1C25515
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 03:04:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1739F2C857;
	Thu, 28 Mar 2024 03:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VA5GraM8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB65728DDA;
	Thu, 28 Mar 2024 03:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711595084; cv=fail; b=jSmDEhUdRR9UQZt/w1x30b8C/eXFEE0ISKxFnC4i2gLPqqdu1Tstc8ENYOHW+CRef43FqidgjfcNpjFbfRi8sMNTqXnzxd9wQqq9Wl4jLkQ/jUkHoxGwqXPozrWu9xleu406sWqQp8+onWusPjH6pnvGpkP37lTYjyhcWOPo7b0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711595084; c=relaxed/simple;
	bh=+iL73YAfrlzNFpUmJj2q0pRnKxSpimI8ZngUoOX8k+g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Aof6kI442h8Q6TFPzmSN84T6rXFfPgEQa4SqKTnPUZlSzIhY+ZzAiYcogbTzIuLf2sADRoDH5IPcsXHLJ89O9yfGFeezaEX0mwm+pN5vFobCD23kxjsPttPmzQiqNDQs7wRT8d0FbYOZBoHaUxf11G7/XGjd3NWobnNTEwExgmY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VA5GraM8; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711595082; x=1743131082;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=+iL73YAfrlzNFpUmJj2q0pRnKxSpimI8ZngUoOX8k+g=;
  b=VA5GraM8yYqEXBOO10Z5voPbwEIE+rNhKQYpWNIpiW90lwC4dAn3qeI+
   0Xq9CeFMBSiG21c0A9MsWPprtDycnW2+XnQbyESuz+zNEFaWjEWYo1O8H
   /AqNg/+wMxgxWxq4/tzfC1DR1quJVKqx8obqbJBFU0xas2KrkZ3Dp2wOH
   l6fH3O6Lzva8hsYKvSvL9gjKWh8jjI4rnCdCCw+vsMEovs+lxuT41v6tx
   M3po4rYOOdEjTg244xuG2JTMWhqe091iWB0QTJyk2Eh86xbnj/ITp94a6
   LHilud7s/ZSlxFsAbdlRleXpk9LbytbzCIPDXz4sp9Ov/CXYNtOCGmi1H
   g==;
X-CSE-ConnectionGUID: 1pg8WuALS9KVmD14swr4OQ==
X-CSE-MsgGUID: 1AhM+WPRREeocROpXQv4aA==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="6668332"
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="6668332"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 20:04:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="53961323"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Mar 2024 20:04:41 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 27 Mar 2024 20:04:40 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 27 Mar 2024 20:04:40 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 27 Mar 2024 20:04:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PJ3Q08SOtrBsb8SGRIQI1hcDdv3BD5FQSUsqYabHW9ha0iOf1TSrPsIWfTihg9w57B6XnLltOBuYMS0vxIhyD6Z/9/GzrI1hnYeTCbtbU48lxLaLOQj/9p9A10YBRY911vEqs69IkTmIyfOVLcblfzrfBdLIpLT4NwLwOiOqUdnfBvh+lPakZ1EaahFSfs7vXyNanZ3xQAuW5zBG7sVhLozDc43zMTIUqQNrVL01pNgn+l13mUXuxZlgmarvuVGJw5MFqKWKEIZDheIHonBvxqmEqYqRNy0QAkn8aKwthOJHxPuF8RDMjAsbby8jXIwcXXZNWpS9Pl/URoK8A9jIaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+iL73YAfrlzNFpUmJj2q0pRnKxSpimI8ZngUoOX8k+g=;
 b=mYe8wrDaj8zJGNHkIQtJV0C4ovmHvPMr/SsLYVcPpTXsQj6YBc1NG6tK3rZsSuUhF9vM+QQfTdlFzn55K7iFGR/VnGTMK9K7QiNAHQAl8h9dh0DND8Cz4DvHdC6jcyoURYPFzyx3pqpN1+B5Ry0fYVxWZ1Hs1mRXgcj5jxDnbclVab3U5Uq0MLBGX7dQf9gsf7oZ/B5r1S2qyNuYkDz+kZgzVOduEdteBUp9qNhPP3wXe8XCwcamgvCdpv5PYpSsU7BVmjXeukG5UqxudKNZKTLhCdoBz3gDyEewbRWSnw+F1b/+WhqClq6KKvcwMfZwHmoWYB9DZiRxKCzk8I9Btg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB7643.namprd11.prod.outlook.com (2603:10b6:510:27c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Thu, 28 Mar
 2024 03:04:38 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7409.028; Thu, 28 Mar 2024
 03:04:38 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Gao, Chao" <chao.gao@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>, "Chen, Bo2"
	<chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Yuan, Hang" <hang.yuan@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v19 059/130] KVM: x86/tdp_mmu: Don't zap private pages for
 unsupported cases
Thread-Topic: [PATCH v19 059/130] KVM: x86/tdp_mmu: Don't zap private pages
 for unsupported cases
Thread-Index: AQHadnqpCkdQcpy1UEaf8e2/el3pBrE+L/IAgAGVVQCAABCvgIABmDGAgAFrqACAABw5gIAF68uAgAAN3oCAACgcAIAADqEAgAAC4oCAAAP3AIAAMXQAgAAC04CAAI7TAIAAbmyAgACYeICAAPZDAIAAbS+AgAAKzwCAAAOVgIAAAigAgAAGu4CAABpigA==
Date: Thu, 28 Mar 2024 03:04:37 +0000
Message-ID: <783d85acd13fedafc6032a82f202eb74dc2bd214.camel@intel.com>
References: <96fcb59cd53ece2c0d269f39c424d087876b3c73.camel@intel.com>
	 <20240325190525.GG2357401@ls.amr.corp.intel.com>
	 <5917c0ee26cf2bb82a4ff14d35e46c219b40a13f.camel@intel.com>
	 <20240325221836.GO2357401@ls.amr.corp.intel.com>
	 <20240325231058.GP2357401@ls.amr.corp.intel.com>
	 <edcfc04cf358e6f885f65d881ef2f2165e059d7e.camel@intel.com>
	 <20240325233528.GQ2357401@ls.amr.corp.intel.com>
	 <ZgIzvHKobT2K8LZb@chao-email>
	 <20db87741e356e22a72fadeda8ab982260f26705.camel@intel.com>
	 <ZgKt6ljcmnfSbqG/@chao-email>
	 <20240326174859.GB2444378@ls.amr.corp.intel.com>
	 <481141ba-4bdf-40f3-9c32-585281c7aa6f@intel.com>
	 <34ca8222fcfebf1d9b2ceb20e44582176d2cef24.camel@intel.com>
	 <873263e8-371a-47a0-bba3-ed28fcc1fac0@intel.com>
	 <e0ac83c57da3c853ffc752636a4a50fe7b490884.camel@intel.com>
	 <5f07dd6c-b06a-49ed-ab16-24797c9f1bf7@intel.com>
	 <d7a0ed833909551c24bf1c2c52b8955d75359249.camel@intel.com>
	 <20ef977a-75e5-4bbc-9acf-fa1250132138@intel.com>
In-Reply-To: <20ef977a-75e5-4bbc-9acf-fa1250132138@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB7643:EE_
x-ms-office365-filtering-correlation-id: b5deaf65-f619-4838-6d3d-08dc4ed3cdf1
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ePhN9pb60x+PE8RuKhhNMDJLAzFEbTLNdEiYoXt+Fbk3OZx99XzYVzWrMWMeLsKKOxC3FTytcBMa9Twj/QvsFgpMCdxVIVVqPfW9AH0U9ZN43BNOx7mMpNdWw/PYYHxOKJdqiVv7s5PLbqcSs2Em6g3Tfe4cEoxy/9x9onPuIC8mJHGoRYF4A+FYA5OgAp0pkqxlmsq4sHDmnnPrgbKayLPDVKwhuRyAqh36Y7CA4yRVajmyBHJ9hmS65Qs7Za9mJBDeEYmCkQARALjxzbo7QIeVez05mmK1x9pEJwgPvVl9UF6gSYWLaYFc34RA0uaH9d7B+rTdmRxjVFSowogbwTcwfL7CNYr9NE4YFUVrCmC3x4ipth0iNIaVqZDbp9STnt/OuP2UC8/7hYgAXjOIbSwFhXiSk9fMRBSWihE/gT4IufnnlCtLHfWPL0fo2T/49IR1qEZvrEZBYqF3v0yioSCVinY2bZgd4yNqo1CErPwdC4u5JP3o6Fxarykv3IVhlopmVmt/pgk6t90ISvJPxLHIVXxGv6apslmJ/+g4/7MEvJ+V8f8x4lfGfJRaUZYcppuWKuW6PABVbERcjen9wovqFM8w+ygplNrbuyJ1z0u6yPxKghSTVs3pFswfloW360bTNcUY0jN/eQI+grCLuNO0Ob9W2q1jH+mgYWR6HiDPI9X5mdEvde7nNfzeBnXpqn6LFYUSvZX2i/jsb4LvVaGaYOEpOtmlIhB+tLlqQX0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZFgvdkVDMDhDMUI0T2x0WUxYV2U4UzNqdWlvV0xPU1R4c1lWTWM4VmdKcU0w?=
 =?utf-8?B?MzRMb0ZWN3kydTJSSGZOMnZlMVFwbGxaaXBzZWlLbGFsMDRkcHh3bytBL1JY?=
 =?utf-8?B?V0xPQVlTUk92TEl5MTBKaXJVc0tEMDdKNjlTU1pVQWRoWUQ3VmEvZzAxZ3Q1?=
 =?utf-8?B?RXVKMURSdDNkVkNUdWZIS0J6UkpVeXBGbjdVZUh1MTl6YWVHL3dOWkJHL1Q4?=
 =?utf-8?B?OFkvRFp0UEVxNkZUYnlQdzZYa3RWWTBwZE9OZ2I3MEN6ZUpoWjVJMXNiM3E4?=
 =?utf-8?B?WllTbzhqWm4raVhmYkY0eFdULzFqY0tHaE5nZlgzdDE3YkxXbEE4REhHZlJi?=
 =?utf-8?B?SEozMnNGOWJnMmJadSsyN3RYQm01bE1pZzI4QnZNSVdzUHYwSE43WlJUcEE1?=
 =?utf-8?B?dDBXaDJzUWdVL2NERXkyVWhUdE9PVUh1cVJBdXpkOHBzRUhRRVlOOXN2U0k2?=
 =?utf-8?B?UTZKajEvUWd4WHV2cGhtV3h2dlVvaG9jemNKd1ZwdXYwWFNBbEZvRzVjZHZz?=
 =?utf-8?B?WVpQcCtpc21xYUFndHBsM2Rnd1pkUDNmRkp3RnBFTisxRlpmdFcwdDMvRkpn?=
 =?utf-8?B?UlpiaWdIcFI3RnpLd1pCZk9MOTJvcGR6MDV6L0hBa2dPdm5KMkFYWDhCMUlU?=
 =?utf-8?B?dytpV1l2d1h6WDBidDdGcFErcmVsNWZGa2FSQkRaOW5EUU9IbG4xSWtQSXFV?=
 =?utf-8?B?dnJab0pWSUFTTlQyNWJyU0c3OS8zdmRpR21rVzJxQndYYTArbXNWTU1vUith?=
 =?utf-8?B?WnpwazJJSWVOVmZRdEFoUDZCMDR5eWFwOGt6S0xCcmtmWDN6Nmh1bnRWNHUx?=
 =?utf-8?B?TnhyUnVOU1g2dExyL2JrM2tQRUFHQlIvcHliSWQxaVNnbW9ibGpUejIyWDRK?=
 =?utf-8?B?ekY5eEhicHpodngzNTJuaFhxL1NpN3creWxJcDY4RUZ5c2pJM0xNMzJjeDlR?=
 =?utf-8?B?em5Jc2xTU2VtMHB4TkI5N0NPRm5uUUR4TnM5RWpicTRiaithTUtiZ05SbDZi?=
 =?utf-8?B?UGpGZjM0blhrNzYwSmhsQkJEdGt1dUFOQW9WaldlMEpQcEErZHpGY1I0VU43?=
 =?utf-8?B?dWpqV1MxR0JZTGU1dmpXZDBMa3VpU0JTMDF2UjY0TXA0U3Y5VktRTGRuSjBw?=
 =?utf-8?B?clgvWlVCODdqS05lNXVxc2M0T0loNVUyVkE4TmtpL2V4QUtnS0pwTzI0RlYy?=
 =?utf-8?B?NFc3UUpIRTNLTFJtbnRhVk9CTEJxb0R2SmxrQ0M2WW9ycXg4K0s0SzlHdGhO?=
 =?utf-8?B?K1lPUEN2VkZCUHVsb0xyQW5ZZ1FZbTJIMlBsRGVKdyt6bkQvdUtsUC9PeHFl?=
 =?utf-8?B?b0NKSCtKc0p6YzRzY3U0cTBpUFBzUy81SlRmYTBVa09Tc1A4T2ppeXZEQ2Ir?=
 =?utf-8?B?bVRRVms4NFd6UmVtcGJrdmRIZDVHYVJWMkhXTmZqdWZEZTVWVVNLMWZwaUIx?=
 =?utf-8?B?UGNMeG4rRHI5cHB6VExnc3dzd2VFd21DT3JoTCtzMHU2Q0RnWmtDeGVOelVp?=
 =?utf-8?B?bjd3WkZVMmFJeFZKSEhncmNvb1Rrd3djZGt0cktUR2I4SkpUR1c5MEM4S0Fn?=
 =?utf-8?B?NWtJTVBydXV2emFOM05GbzB1OFN6M2ViVnVja2tlRUdxZFNrVmRGaThiVzh4?=
 =?utf-8?B?NzZZVFZYYmUvcm0yV3RIWjY0aW40NEYxVEpnUFRNN3AvbDFyUC9HNGh6QlRO?=
 =?utf-8?B?UjlqRmRkQ3laaS9sYi9TQUpMNkJ4Y251cklhL1JtM2h2cXBHcDY0WEJpaTVw?=
 =?utf-8?B?S3M1ei9XNHczOVpUTDBJck94UTJOUXIrcjJpWUdlR3ZpTGhQazQ0OVNKT0w3?=
 =?utf-8?B?U0RPd2pwQUFvYUVvVGw5am5tUHVmZGpRMEF0VU5jLzRqQkQrUDFpKzcxMGRB?=
 =?utf-8?B?N3Jkb2tEMUsrZ0dnQjh6VDBRMitjQ3hDYmZUUVU1VENsYm5BaVN4YWozS0ZE?=
 =?utf-8?B?ZHUyN1JWOFZiUHN5K2I2TW94bHlwblQzc052WlAvNXFzUGRsMTJNdFlrUGVs?=
 =?utf-8?B?c0Y4ZzFaOGRsVys1K0RYV09ld1JVdE94QWEyZzJMZ21hUkJwcDJUL204RDZk?=
 =?utf-8?B?eXNtbUZ0U1VIaW1hZGNoUUg1cVhOd0grZlUyVUU3NmJ3SDJWQ1g5VzJzR2x0?=
 =?utf-8?B?aWdDNEpqQmpOMW9HdjlTTDB0UWNESUdYZHAxNkxWdnEycmEvdmJMS3E4K1dO?=
 =?utf-8?Q?ZBfENEikMMeyscKLDm+eJxQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <10D5E58F048A97429B34F552F4C359A6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5deaf65-f619-4838-6d3d-08dc4ed3cdf1
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2024 03:04:37.9903
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y6KN/CdD0wsLV8NnAvvOvw43MO8fn0/6TYmjkoc88PSJsX1vbI6qE+EOGKpqdDQb4DYFwJou/xNoP84JkQs2us1Pz8rMN7kyKsOD8Oh7zYc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7643
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTAzLTI4IGF0IDA5OjMwICswODAwLCBYaWFveWFvIExpIHdyb3RlOg0KPiA+
IFRoZSBjdXJyZW50IEFCSSBvZiBLVk1fRVhJVF9YODZfUkRNU1Igd2hlbiBURHMgYXJlIGNyZWF0
ZWQgaXMgbm90aGluZy4gU28gSSBkb24ndCBzZWUgaG93IHRoaXMNCj4gPiBpcw0KPiA+IGFueSBr
aW5kIG9mIEFCSSBicmVhay4gSWYgeW91IGFncmVlIHdlIHNob3VsZG4ndCB0cnkgdG8gc3VwcG9y
dCBNVFJScywgZG8geW91IGhhdmUgYSBkaWZmZXJlbnQNCj4gPiBleGl0DQo+ID4gcmVhc29uIG9y
IGJlaGF2aW9yIGluIG1pbmQ/DQo+IA0KPiBKdXN0IHJldHVybiBlcnJvciBvbiBURFZNQ0FMTCBv
ZiBSRE1TUi9XUk1TUiBvbiBURCdzIGFjY2VzcyBvZiBNVFJSIE1TUnMuDQoNCk1UUlIgYXBwZWFy
cyB0byBiZSBjb25maWd1cmVkIHRvIGJlIHR5cGUgIkZpeGVkIiBpbiB0aGUgVERYIG1vZHVsZS4g
U28gdGhlIGd1ZXN0IGNvdWxkIGV4cGVjdCB0byBiZQ0KYWJsZSB0byB1c2UgaXQgYW5kIGJlIHN1
cnByaXNlZCBieSBhICNHUC4NCg0KICAgICAgICB7DQogICAgICAgICAgIk1TQiI6ICIxMiIsDQog
ICAgICAgICAgIkxTQiI6ICIxMiIsDQogICAgICAgICAgIkZpZWxkIFNpemUiOiAiMSIsDQogICAg
ICAgICAgIkZpZWxkIE5hbWUiOiAiTVRSUiIsDQogICAgICAgICAgIkNvbmZpZ3VyYXRpb24gRGV0
YWlscyI6IG51bGwsDQogICAgICAgICAgIkJpdCBvciBGaWVsZCBWaXJ0dWFsaXphdGlvbiBUeXBl
IjogIkZpeGVkIiwNCiAgICAgICAgICAiVmlydHVhbGl6YXRpb24gRGV0YWlscyI6ICIweDEiDQog
ICAgICAgIH0sDQoNCklmIEtWTSBkb2VzIG5vdCBzdXBwb3J0IE1UUlJzIGluIFREWCwgdGhlbiBp
dCBoYXMgdG8gcmV0dXJuIHRoZSBlcnJvciBzb21ld2hlcmUgb3IgcHJldGVuZCB0bw0Kc3VwcG9y
dCBpdCAoZG8gbm90aGluZyBidXQgbm90IHJldHVybiBhbiBlcnJvcikuIFJldHVybmluZyBhbiBl
cnJvciB0byB0aGUgZ3Vlc3Qgd291bGQgYmUgbWFraW5nIHVwDQphcmNoIGJlaGF2aW9yLCBhbmQg
dG8gYSBsZXNzZXIgZGVncmVlIHNvIHdvdWxkIGlnbm9yaW5nIHRoZSBXUk1TUi7CoFNvIHRoYXQg
aXMgd2h5IEkgbGVhbiB0b3dhcmRzDQpyZXR1cm5pbmcgdG8gdXNlcnNwYWNlIGFuZCBnaXZpbmcg
dGhlIFZNTSB0aGUgb3B0aW9uIHRvIGlnbm9yZSBpdCwgcmV0dXJuIGFuIGVycm9yIHRvIHRoZSBn
dWVzdCBvcg0Kc2hvdyBhbiBlcnJvciB0byB0aGUgdXNlci4gSWYgS1ZNIGNhbid0IHN1cHBvcnQg
dGhlIGJlaGF2aW9yLCBiZXR0ZXIgdG8gZ2V0IGFuIGFjdHVhbCBlcnJvciBpbg0KdXNlcnNwYWNl
IHRoYW4gYSBteXN0ZXJpb3VzIGd1ZXN0IGhhbmcsIHJpZ2h0Pw0KDQpPdXRzaWRlIG9mIHdoYXQg
a2luZCBvZiBleGl0IGl0IGlzLCBkbyB5b3Ugb2JqZWN0IHRvIHRoZSBnZW5lcmFsIHBsYW4gdG8g
cHVudCB0byB1c2Vyc3BhY2U/DQoNClNpbmNlIHRoaXMgaXMgYSBURFggc3BlY2lmaWMgbGltaXRh
dGlvbiwgSSBndWVzcyB0aGVyZSBpcyBLVk1fRVhJVF9URFhfVk1DQUxMIGFzIGEgZ2VuZXJhbCBj
YXRlZ29yeQ0Kb2YgVERWTUNBTExzIHRoYXQgY2Fubm90IGJlIGhhbmRsZWQgYnkgS1ZNLg0K

