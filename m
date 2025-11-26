Return-Path: <kvm+bounces-64768-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 084E5C8C369
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 23:28:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 65D203AC42A
	for <lists+kvm@lfdr.de>; Wed, 26 Nov 2025 22:28:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6C5E33FE2F;
	Wed, 26 Nov 2025 22:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jXMTrfD+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 469402E5405;
	Wed, 26 Nov 2025 22:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764196100; cv=fail; b=hgKNEzLmvpERToiFcm3RvtDxAWOVG16rdNo8TebR8i1dBR8mNGcm5WNIXqAAEwzIvWAEYN4XT4qglItcUyGs6sAvG4ABb1GCqH0CWtf++YlrUHQ+eF5/u+JhEMdu6HC77OEnA3LisKCphAGfwddEA6Kqa3xMfV9pJUSEhtASjhI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764196100; c=relaxed/simple;
	bh=u4/C2cWYzQN7c9d5Blh1hAMiW6w3T1U2vMI2EajvKYQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FNp/aQuVjGBeq6283q9o9DmBIxViTyGFFsxxkJ7tl4AFFWdO6Kz8mwZgP2Lmw/nu7oW0NGP1Ad/9pAtTSqnIrvSLKTcFF0yRa6FRoOfmLdh6sMyvneBx2/EN2LlVglDh7HBiqZbVTRQHa0nWyDDz7D98W0VFN/aW/Swo0V4ZdvA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jXMTrfD+; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764196100; x=1795732100;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=u4/C2cWYzQN7c9d5Blh1hAMiW6w3T1U2vMI2EajvKYQ=;
  b=jXMTrfD+4EeO/olhT2iUXslqnfYtFA/xLB0BsIKKdCzYYTZgH8KHJhmm
   wHOrFUkSw2uW5QHZxP3F8SzXxSYQXP2QeamEaYLKVzrlEfoehqd8Q23oJ
   XutXhf1DhfLGSYWM08QSsJGW8lh531l3Ps1+cLXc0SeON8buLnd4emt8V
   lVWd+Jc+BoI4o7mIgyJBpun1iIlNID2XS+4eJFLyNQOH9B365wzt1RavW
   BvZS/I6lt9KJu0tZdwkh44++KkQNZ3pGtLWo4z9BoPEpPZgYF4/sDN9Ld
   GIWRZf8ZR6dWRq66QUVWnX2USrsWWJwFu/Zwye0fNqB6u5NCMq8/AVNy9
   g==;
X-CSE-ConnectionGUID: zVpl0ZCCQ8eczSihZavcrQ==
X-CSE-MsgGUID: 8zTuDkpUQ5e5A8KehQ+zoQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11625"; a="66134594"
X-IronPort-AV: E=Sophos;i="6.20,229,1758610800"; 
   d="scan'208";a="66134594"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 14:28:19 -0800
X-CSE-ConnectionGUID: kgxzFENfQEC7s1C2QCAB0g==
X-CSE-MsgGUID: GEJBjdttTlWTtjuweVTy8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,229,1758610800"; 
   d="scan'208";a="197394919"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Nov 2025 14:28:18 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 26 Nov 2025 14:28:17 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 26 Nov 2025 14:28:17 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.58) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 26 Nov 2025 14:28:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=smh6WJcZ+V2aWGLecJMrG2N8FSTmfScaGQ3957K5KlpMKItL6z1RvLhzL18rLTtrjEdy3EaYs4DVQwQa9mfVLSU4sVkog7SUajXMZyQLWjAQBvPDgpK+ID/nWIqM5LU/uQxAd5FmwQt4Kgh141QhUeOwJBlRqJUGWdGXDQ6LjHWIISl7GfNX9TA7tYr86aCtO0dTCndBHGdhb35s89q2omV24wfyRvfsFwIxStN5Q71fMYABjr48p7PvFYuqMSwuNGX+eMv9LsnkFmpPhJLXvobcoPnHOX+m5uwcHmOBhfUAn+aTJNJkwz8CTMvu8xBDG7XElqqU5iPvCE6q8WShQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u4/C2cWYzQN7c9d5Blh1hAMiW6w3T1U2vMI2EajvKYQ=;
 b=c/JaIZlbZenygjTsPTjXAS1L6p3XMIguN2LNn9Cy2yxoYV7p61cZYpM9Xbj2YzPcHOt+EFLZ83/mxJcfJZ5th/JxdsxcHdgLA4L8JzmPw2PFFAbBbZD22heXd9rRcZLsZT5kU+gNgp0dULEKOTdBSmd1WiSRyXAFzxnBB5fu80B6YjU72JqUWq6mrkrl+Con1gRpX96XXZinH+z6AyITRikJ+/NC/RCJwOrLVPzBHwF3LlHqk2RPYA/0W3Whf2A31LBGte2W1cVdXmmhwvqL7x1+amHiYD9sm5/FOkJFlKCwwZkSUjPYF7HSnRuwCxspL7141WALf5DO0cotZGlHxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH8PR11MB7046.namprd11.prod.outlook.com (2603:10b6:510:216::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.18; Wed, 26 Nov
 2025 22:28:08 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9366.009; Wed, 26 Nov 2025
 22:28:08 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "Wu, Binbin" <binbin.wu@intel.com>,
	"kas@kernel.org" <kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "Annapurve, Vishal" <vannapurve@google.com>, "Gao,
 Chao" <chao.gao@intel.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>
Subject: Re: [PATCH v4 07/16] x86/virt/tdx: Add tdx_alloc/free_page() helpers
Thread-Topic: [PATCH v4 07/16] x86/virt/tdx: Add tdx_alloc/free_page() helpers
Thread-Index: AQHcWoEIh3ODz6GbaUW93Yfuwe0KJ7UDEL+AgAKCH4A=
Date: Wed, 26 Nov 2025 22:28:08 +0000
Message-ID: <67d55b24ef1a80af615c3672e8436e0ac32e8efa.camel@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
	 <20251121005125.417831-8-rick.p.edgecombe@intel.com>
	 <12144256-b71a-4331-8309-2e805dc120d1@linux.intel.com>
In-Reply-To: <12144256-b71a-4331-8309-2e805dc120d1@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH8PR11MB7046:EE_
x-ms-office365-filtering-correlation-id: 9c5be8cc-8864-490d-c42b-08de2d3b1348
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?NTByOFExS05CcXMyK0ZPN3pWbGZOOEE1eUhTZnRPZitTdDdTRERpT2Y5RWhN?=
 =?utf-8?B?MUp0L1cybDRYK2F6VnhVL3lUTjFDd0tkNGoxSWNlVVpBTDV0bTNiZmxob214?=
 =?utf-8?B?alNxcm9zSUZ2K0FHRkltS2Z1QXNpMVFraERvbWdkRUhwZ0NvYm9UTjlDNHJi?=
 =?utf-8?B?L29hcDhPa1hJaTZOeVVFRUFzSWsyU1QvK3FrQ2JsQlozQnJRTlJxZS94ZXBZ?=
 =?utf-8?B?YU1vZE56dWFWNVJUMnl3ZzRjcDAreHR0cTBUbXZZYjRicWxzVU5OQlZPSFRB?=
 =?utf-8?B?UTJNNjdpRStvaU5YQ3BGMXZlbGlGS3diSXd4QUc4KzY0enluTlBtOTd5OE83?=
 =?utf-8?B?RkFsYmRwUUJFZ1gyTkJUdDk1OVdrWGorQWdxWVBlN2NNQzNmSUpnUC91SHUy?=
 =?utf-8?B?UmxNdzY0d3pzY1FLTFlBVFZGOEx3emJTV3JJYUE4djdWYWY2bWM3cHNEcStK?=
 =?utf-8?B?Q0xRYVJpVzBqM3kybnlQL1d0WVFMczdjQkM2cFNiWjRXRkMvbThFbTJiN0cz?=
 =?utf-8?B?dnVBVmtXS2JWODFXb0Z1dzQxN1ZJcnYyT3h1ZzArRk54QWNXS2RsWEM5alMr?=
 =?utf-8?B?SE1TcHdWS1BPQ1h4Y3E3aEpteDRyNGxTL0NkVU1nRCtHdUlpeG1xNFNmUC8y?=
 =?utf-8?B?dFp1MzhwZzFENzhwVnZDK1Z6QS9hWVgvOHhWYjlRSGdCMlFLOTFGNUFqVWNB?=
 =?utf-8?B?YVZYeC9FYnprYjRoSitUNkpQUzI4cFUxTEZWNUpoSi9PQkhzSG1ybzh2WDZt?=
 =?utf-8?B?b1RCVS9DT3U2L2pQUU9yeEFFdVNEMTZhK0lTaFZXWndWTURJbklsNlpEbmVq?=
 =?utf-8?B?Z29BcEpYRWdvRHpRUVlZTGFmbVU1dnBwYXM1SjhITi9tWEo1S254UUcxK01v?=
 =?utf-8?B?dGhmNTVrRUk3b2FIb0xnck0vT0JZRlF5TnI4U3JhNjFHR2d5WXVNVUhHYWZu?=
 =?utf-8?B?eWlHSzNSOFZra3NnM1N6K0tUYitmemt2aGFBaEVaa0cwQ2FOSXdKelAySEJn?=
 =?utf-8?B?c3loV0xlV2RLZE1qZnJUd1p3b3FxbXBteUFkdWpVRXhCSVZVdGhzL0p3MmJJ?=
 =?utf-8?B?K3hEZXdpVEtMekJCdUxxeUtNZmYxYWV6cnFSOGY0MWFpbXRMMmdjSmhRbWkr?=
 =?utf-8?B?OHUrM3VyNU0zNlR1TEZLNnRkUUZoZVdKakVFRkhqcVd0czlISVZURHFneFNa?=
 =?utf-8?B?NW9BaktBWFJ6OG9DUmx5QlZMNCtPaEd6TjB5N3Q3cmRJcTBvRmJvcUhmTDF1?=
 =?utf-8?B?QWdjV2YrVkg4bXBMTUhPMkhPTzgrRzRId3k5ZmhMbnlVTnlkQWhuM1IyQUdW?=
 =?utf-8?B?SW5XbHkxWEhWQlNzdzN4MTB5cUxVVndPTTJEZXJFZXlBcm81VHRFQ0pxcjd3?=
 =?utf-8?B?a2xxb0hsV0tNMzYrak1Ec0NRb21tUUlNNnFLU3VIM3F6dzRUQ1VnNEVkR1g5?=
 =?utf-8?B?OE5yZk02aFQ5UzlNZ3FVU1RnSXluRjdPOXFkbkNyMG5tTU5QS3VZNjFJejEx?=
 =?utf-8?B?bi9oT0F5d01zeEFPdzFsTGxyQmZTZWZLN09yem4rVWx0WXBCa2p6d25NQnVV?=
 =?utf-8?B?a3dhMWVlTlhJRWwyZS8yMVpIdnJwSTRoVnc5dTZDeVNTcEFlb1JrS0VPNnJB?=
 =?utf-8?B?Vk1tRnlOb0VwMUxieE91cExHckF1YllsRDhsQkdvOUdORitjTmNGWGtPbGlR?=
 =?utf-8?B?SDhrNm5RS25DalBvSUl3T2tpRHBqcVptYTU5S2FYZWIxV3NGTTBzbGFCazJH?=
 =?utf-8?B?SmQ3citodzU2YWhKMTBKeVgrUDRHL1dpLzhMdG9KQWtqdEJJcGpMbHpwS0RE?=
 =?utf-8?B?a0xCTmJKTElwV2dEd09CYTJOWDlPSWNQTndKdXI0bER2S3MvK2xRb2RzSUhz?=
 =?utf-8?B?TU1sQS9kNC8zdHJCb2xOU054T3RPSHVBTWdWbU1RRTFJSXpqTUxxNEpYYkJU?=
 =?utf-8?B?bXJ6bEVsclRqdXJhS1RKckJ2ZE9TQ0ltS01qc1FRZjJFek5VYUFoZ21NMWdn?=
 =?utf-8?B?N28yM0ZNR1E5Q0hTQmhPVFRyNHRleHVYOXhsWmpIR3I5ejAxWTV5bXZSdWlK?=
 =?utf-8?Q?ojOdnD?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZWk1QjRobjh2UmM0WFRyamVEaVgrTnJBbVMzWlpFazR6bmVObEFJdEZWNllr?=
 =?utf-8?B?elJKK1prZlpmMzNzMURtaEZ3UmdwaTJSdUd3V1g5MmNmSlRTNE9kSmhlZGlR?=
 =?utf-8?B?VlErTm8zaEt0NVduZGkxTjBZNTNjRFJTU3l2Sk9TRWJEUDJKcjNIWG1VZER3?=
 =?utf-8?B?K0NrT2ZSaDNXSEg5WSt5TUpiTkVXNGdZalIxYzViVzBFZ0xrNzIzQ2VwVnQx?=
 =?utf-8?B?cFNyYUhta1JYcUdEazBTU2g1VG1wbnFYcjBpelJlL1I2Z3VnODVtS2VIcEhU?=
 =?utf-8?B?ODFZU1hOMVovc2lmd3pENGF0VytIcjBOUVRwajhGL1NSUGx2azA1T3Z2M0JK?=
 =?utf-8?B?RmFzK0o3RnpyME9mQjFBYmJnZ1FDLzExaTFFY3FxeUVYcU9UaWFqTHExVzlw?=
 =?utf-8?B?RkcwRTJBNDY2R29HK2dPM3JHTVdoUWNERVZ4MllDbWtKYnlLYW5jWXFLTTdR?=
 =?utf-8?B?Skd0TlRWVkM1TDQ3ZHBxNzhCeXpPdzgzOE9HTVdpbUFpSXBLZWJUS1F6cjZh?=
 =?utf-8?B?c0twUmJyazNvVjlBcTdUb1VCQmZMaWhnYzVPVEswRmhkK3dQQmdDWHgzYlAr?=
 =?utf-8?B?YzVKM2NwL28va0hvMGZYcFNpd09md0JuVzNpdm50VE50T2JlM1c2NytBbjcx?=
 =?utf-8?B?UDRCejM3a1FxN1J5Q3grNld4K3lmWlpWdW5Dc0Jhek0rTHgxT3hQdmEwd2VG?=
 =?utf-8?B?WmhwcERxQWJiTk92RGpZZFNoT0Jha1ZIZDFKVFgwTi9RL2ZtZzNXUVMrNkJN?=
 =?utf-8?B?ZWhlVkFWc0hlbDM1MDQyelRzZ3BmOE1BU0FjREFkZTRqY2R5UEl2azRZTy81?=
 =?utf-8?B?RkxYR0tobWNjZ0FJUlVlcVd6UThkNG1uOXVBaWZqMExpSEhFSWFrNkZVQlZJ?=
 =?utf-8?B?NHpYUXRPUXBuTDduQ1crNTV5RUtLMk1HWWxPZFJjMWlxT1VrQUZRQ2xLdS9w?=
 =?utf-8?B?dC9OYTFDWE9Bd1RWSGpzSHYwL3pGTVFWYWhGS1NMV0I1V2QveVk2UTY2eTIw?=
 =?utf-8?B?bjYzU2VqWmowQVhwNHBNcWc0M1VPYXdFL25rek5lZ1FBMVlXMmtNSXVwR25v?=
 =?utf-8?B?cjFRbXBpcHp5RXZEaHZNNFVCd0JNbUk4WVgyWndkYi9oNk9mbTlZbnVGZzFY?=
 =?utf-8?B?UzFuNnE1bnI4TGVPOVFEandtejhocXllQzU5S0h2bTNYNEFOYUhTY0Y2dE9C?=
 =?utf-8?B?NklDZnBaYzQrTXpqRzBWM3JKZGlmaVVXWVl0YmViemFGTDlMM1owbEhiQU96?=
 =?utf-8?B?b2ljQnVXOUpxcGZlY3ROb3kraC9aUkNzOGJieDJHdGVZa014YzBTSDdxbGVK?=
 =?utf-8?B?b1VCZDhDeURpb0lvQ3RJVG5FcjdPbDF2Sy9hYStqa1lMSXBmNDdZaW5Xc2M2?=
 =?utf-8?B?bG45NEw1bnBDbTBaMEJpeVRtcW1TYjZvVjJBZFhqY3pCVUlPZlRUc3BWMmNk?=
 =?utf-8?B?VDN0VzJSYTdvZVJIS1huOVo1K2dlUlh1bkp1SHgzM0Y2Q1hWWno4S0FSNkdz?=
 =?utf-8?B?VThHMDRjZnBLTVlmOG82eDF0UHA2UG9MMldqRjRuSWZOQWdVaXRxTWhGdk1v?=
 =?utf-8?B?QVpiYzBDSDdGLzl1alg4aFNKVHUvZ2xEcmdSZHVqZEtacjhsMnEwT3FpaGo2?=
 =?utf-8?B?RGl5SDRuVlVpYkFxdUx6SFIrZk1iZy9YZ0QrbEx1U3QvMERsYStmZHFlWlJU?=
 =?utf-8?B?bU9LcVV5RFZsSjdQbHBhOVBWNDNwblBUWHdZTnVPZ0ZFZjRHTG1JdXB0L1Rl?=
 =?utf-8?B?Q1BLWE5qZ1dqSWFqeTd4Yk5qK1AvSTJFeUZxek9yUEp2WkRWc3VJQkJNeCtN?=
 =?utf-8?B?bFVFK3QxM3ZKa2hRVU8yMUtsaDZLM3lXTFF2dmNDUGFET0hJWitJaDBhNnBu?=
 =?utf-8?B?bkk5VUVrMVlobzFQeW1RelVoOEhjV3BtY0o1WExRSm1MOVJ3dFFCeis5aVlm?=
 =?utf-8?B?RUllaTZyTW9kMEFHOG0xODNKNnc3bGJYWWQ3UXVIeEdMTlZvZlA1enRSZDNW?=
 =?utf-8?B?VHFQRnVXN1RyWHZSc2hpWnMyaDFFeDg5SkU2TzFwaWpkWXU2THpSTjl3Y3Q5?=
 =?utf-8?B?QkpUMXk0Zy9XNHhXbk8rRWUwL0V2M0pJMGJ6YUdQa3o4bWUvVkYxOFBPSzZ4?=
 =?utf-8?B?ZWM1amZlYTR4S0RYTWp1N1dleVB6QW8ya2NBeTFrcDF4aXI1dHpFL0dyQXlR?=
 =?utf-8?B?WHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F07BF06607454B449C14CC41B3138AB0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c5be8cc-8864-490d-c42b-08de2d3b1348
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Nov 2025 22:28:08.2458
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3IGIxqaxFFc9f0IuImBpUqe7DK79tE6QAsyxLvdvlkU/xWFbEYMJKU2aT/HsdO8k/oRJJO/ASPaSGlPvyH/U6anxeYFRP7+CLefEohSJM38=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7046
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTExLTI1IGF0IDE2OjA5ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+IA0K
PiBPbiAxMS8yMS8yMDI1IDg6NTEgQU0sIFJpY2sgRWRnZWNvbWJlIHdyb3RlOg0KPiBbLi4uXQ0K
PiA+ICAgDQo+ID4gKy8qIE51bWJlciBQQU1UIHBhZ2VzIHRvIGJlIHByb3ZpZGVkIHRvIFREWCBt
b2R1bGUgcGVyIDJNIHJlZ2lvbiBvZiBQQSAqLw0KPiAgwqAgwqAgwqAgwqAgwqAgXsKgIMKgIMKg
IMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKgIMKg
IMKgXg0KPiAgwqAgwqAgwqAgwqAgwqAgb2bCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDC
oCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoCDCoDJNQg0KDQpTb3VuZHMgZ29vZC4NCg0K
PiA+ICtzdGF0aWMgaW50IHRkeF9kcGFtdF9lbnRyeV9wYWdlcyh2b2lkKQ0KPiA+ICt7DQo+ID4g
KwlpZiAoIXRkeF9zdXBwb3J0c19keW5hbWljX3BhbXQoJnRkeF9zeXNpbmZvKSkNCj4gPiArCQly
ZXR1cm4gMDsNCj4gPiArDQo+ID4gKwlyZXR1cm4gdGR4X3N5c2luZm8udGRtci5wYW10XzRrX2Vu
dHJ5X3NpemUgKiBQVFJTX1BFUl9QVEUgLyBQQUdFX1NJWkU7DQo+ID4gK30NCj4gPiArDQo+ID4g
Ky8qDQo+ID4gKyAqIFRoZSBURFggc3BlYyB0cmVhdHMgdGhlIHJlZ2lzdGVycyBsaWtlIGFuIGFy
cmF5LCBhcyB0aGV5IGFyZSBvcmRlcmVkDQo+ID4gKyAqIGluIHRoZSBzdHJ1Y3QuIFRoZSBhcnJh
eSBzaXplIGlzIGxpbWl0ZWQgYnkgdGhlIG51bWJlciBvciByZWdpc3RlcnMsDQo+ID4gKyAqIHNv
IGRlZmluZSB0aGUgbWF4IHNpemUgaXQgY291bGQgYmUgZm9yIHdvcnN0IGNhc2UgYWxsb2NhdGlv
bnMgYW5kIHNhbml0eQ0KPiA+ICsgKiBjaGVja2luZy4NCj4gPiArICovDQo+ID4gKyNkZWZpbmUg
TUFYX1REWF9BUkdfU0laRShyZWcpIChzaXplb2Yoc3RydWN0IHRkeF9tb2R1bGVfYXJncykgLSBc
DQo+ID4gKwkJCSAgICAgICBvZmZzZXRvZihzdHJ1Y3QgdGR4X21vZHVsZV9hcmdzLCByZWcpKQ0K
PiANCj4gVGhpcyBzaG91bGQgYmUgdGhlIG1heGltdW0gbnVtYmVyIG9mIHJlZ2lzdGVycyBjb3Vs
ZCBiZSB1c2VkIHRvIHBhc3MgdGhlDQo+IGFkZHJlc3NlcyBvZiB0aGUgcGFnZXMgKG9yIG90aGVy
IGluZm9ybWF0aW9uKSwgaXQgbmVlZHMgdG8gYmUgZGl2aWRlZCBieSBzaXplb2YodTY0KS4NCg0K
T29wcywgcmlnaHQuDQoNCj4gDQo+IEFsc28sICJTSVpFIiBpbiB0aGUgbmFtZSBjb3VsZCBiZSBj
b25mdXNpbmcuDQoNClllcyBMRU5HVEggaXMgcHJvYmFibHkgYmV0dGVyLg0KDQo+IA0KPiA+ICsj
ZGVmaW5lIFREWF9BUkdfSU5ERVgocmVnKSAob2Zmc2V0b2Yoc3RydWN0IHRkeF9tb2R1bGVfYXJn
cywgcmVnKSAvIFwNCj4gPiArCQkJICAgIHNpemVvZih1NjQpKQ0KPiA+ICsNCj4gPiArLyoNCj4g
PiArICogVHJlYXQgc3RydWN0IHRoZSByZWdpc3RlcnMgbGlrZSBhbiBhcnJheSB0aGF0IHN0YXJ0
cyBhdCBSRFgsIHBlcg0KPiA+ICsgKiBURFggc3BlYy4gRG8gc29tZSBzYW5pdHljaGVja3MsIGFu
ZCByZXR1cm4gYW4gaW5kZXhhYmxlIHR5cGUuDQo+IHNhbml0eWNoZWNrcyAtPiBzYW5pdHkgY2hl
Y2tzDQo+IA0KPiA+ICsgKi8NCj4gWy4uLl0NCj4gPiArLyogU2VyaWFsaXplcyBhZGRpbmcvcmVt
b3ZpbmcgUEFNVCBtZW1vcnkgKi8NCj4gPiArc3RhdGljIERFRklORV9TUElOTE9DSyhwYW10X2xv
Y2spOw0KPiA+ICsNCj4gPiArLyogQnVtcCBQQU1UIHJlZmNvdW50IGZvciB0aGUgZ2l2ZW4gcGFn
ZSBhbmQgYWxsb2NhdGUgUEFNVCBtZW1vcnkgaWYgbmVlZGVkICovDQo+ID4gK2ludCB0ZHhfcGFt
dF9nZXQoc3RydWN0IHBhZ2UgKnBhZ2UpDQo+ID4gK3sNCj4gPiArCXU2NCBwYW10X3BhX2FycmF5
W01BWF9URFhfQVJHX1NJWkUocmR4KV07DQo+ID4gKwlhdG9taWNfdCAqcGFtdF9yZWZjb3VudDsN
Cj4gPiArCXU2NCB0ZHhfc3RhdHVzOw0KPiA+ICsJaW50IHJldDsNCj4gPiArDQo+ID4gKwlpZiAo
IXRkeF9zdXBwb3J0c19keW5hbWljX3BhbXQoJnRkeF9zeXNpbmZvKSkNCj4gPiArCQlyZXR1cm4g
MDsNCj4gPiArDQo+ID4gKwlyZXQgPSBhbGxvY19wYW10X2FycmF5KHBhbXRfcGFfYXJyYXkpOw0K
PiA+ICsJaWYgKHJldCkNCj4gPiArCQlnb3RvIG91dF9mcmVlOw0KPiA+ICsNCj4gPiArCXBhbXRf
cmVmY291bnQgPSB0ZHhfZmluZF9wYW10X3JlZmNvdW50KHBhZ2VfdG9fcGZuKHBhZ2UpKTsNCj4g
PiArDQo+ID4gKwlzY29wZWRfZ3VhcmQoc3BpbmxvY2ssICZwYW10X2xvY2spIHsNCj4gPiArCQkv
Kg0KPiA+ICsJCSAqIElmIHRoZSBwYW10IHBhZ2UgaXMgYWxyZWFkeSBhZGRlZCAoaS5lLiByZWZj
b3VudCA+PSAxKSwNCj4gPiArCQkgKiB0aGVuIGp1c3QgaW5jcmVtZW50IHRoZSByZWZjb3VudC4N
Cj4gPiArCQkgKi8NCj4gPiArCQlpZiAoYXRvbWljX3JlYWQocGFtdF9yZWZjb3VudCkpIHsNCj4g
PiArCQkJYXRvbWljX2luYyhwYW10X3JlZmNvdW50KTsNCj4gDQo+IFNvIGZhciwgYWxsIGF0b21p
YyBvcGVyYXRpb25zIGFyZSBpbnNpZGUgdGhlIHNwaW5sb2NrLg0KPiBNYXkgYmUgYmV0dGVyIHRv
IGFkZCBzb21lIGluZm8gaW4gdGhlIGNoYW5nZSBsb2cgdGhhdCBhdG9taWMgaXMgbmVlZGVkIGR1
ZSB0bw0KPiB0aGUgb3B0aW1pemF0aW9uIGluIHRoZSBsYXRlciBwYXRjaD8NCg0KWWVhLCBJIHJl
YWxseSBkZWJhdGVkIHRoaXMuIENoYW5naW5nIHRvIGF0b21pY3MgaXMgbW9yZSBjaHVybiwgYnV0
IGRvaW5nIHBhcnQgb2YNCnRoZSBvcHRpbWl6YXRpb25zIGVhcmx5IGlzIHdlaXJkIHRvby4gSSB0
aGluayBJIG1pZ2h0IGdvIHdpdGggdGhlIG1vcmUgY2h1cm4NCmFwcHJvYWNoLg0KDQo+IA0KPiA+
ICsJCQlnb3RvIG91dF9mcmVlOw0KPiA+ICsJCX0NCj4gPiArDQo+ID4gKwkJLyogVHJ5IHRvIGFk
ZCB0aGUgcGFtdCBwYWdlIGFuZCB0YWtlIHRoZSByZWZjb3VudCAwLT4xLiAqLw0KPiA+ICsNCj4g
PiArCQl0ZHhfc3RhdHVzID0gdGRoX3BoeW1lbV9wYW10X2FkZChwYWdlLCBwYW10X3BhX2FycmF5
KTsNCj4gPiArCQlpZiAoIUlTX1REWF9TVUNDRVNTKHRkeF9zdGF0dXMpKSB7DQo+ID4gKwkJCXBy
X2VycigiVERIX1BIWU1FTV9QQU1UX0FERCBmYWlsZWQ6ICUjbGx4XG4iLCB0ZHhfc3RhdHVzKTsN
Cj4gDQo+IENhbiB1c2UgcHJfdGR4X2Vycm9yKCkuDQoNCk5vdCBpbiBhcmNoL3g4NiwgcGx1cyBp
dCBiZWNhbWUgVERYX0JVR19PTigpIGluIHRoZSBjbGVhbnVwIHNlcmllcy4NCg0KPiANCj4gQXNs
bywgc28gZm9yIGluIHRoaXMgcGF0Y2gsIHdoZW4gdGhpcyBTRUFNQ0FMTCBmYWlsZWQsIGRvZXMg
aXQgaW5kaWNhdGUgYSBidWc/DQoNClllcy4gVGhpcyBzaG91bGQgc2V0IHJldCB0byBhbiBlcnJv
ciB2YWx1ZSB0b28uIFllcyBTRUFNQ0FMTCBmYWlsdXJlIGluZGljYXRlcyBhDQpidWcsIGJ1dCBp
dCBzaG91bGQgYmUgaGFybWxlc3MgdG8gdGhlIGhvc3QuIHRkeF9wYW10X2dldCgpIHJldHVybnMg
YSBmYWlsdXJlIHNvDQp0aGUgY2FsbGluZyBjb2RlIGNhbiBoYW5kbGUgaXQuIFRoZSB0ZHhfcGFt
dF9wdXQoKSBpcyBhIGxpdHRsZSB3ZWlyZGVyLiBXZSBjYW4NCmhhdmUgdGhlIG9wdGlvbiB0byBr
ZWVwIHRoZSByZWZjb3VudCBlbGV2YXRlZCBpZiByZW1vdmUgZmFpbHMuIFRoaXMgbWVhbnMgRFBB
TVQNCnN0YXlzIGFkZGRlZCBmb3IgdGhpcyAyTUIgcmFuZ2UuIEkgdGhpbmsgaXQgaXMgb2sgZm9y
IDRLQiBndWVzdCBtZW1vcnkuIEl0DQpiYXNpY2FsbHkgbWVhbnMgYSBEUEFNVCBwYWdlIHdpbGwg
c3RheSBpbiBwbGFjZSBmb3JldmVyIGluIHRoZSBjYXNlIG9mIGEgYnVnLA0Kd2hpY2ggaXMgdGhl
IGN1cnJlbnQgbm9uLWR5bmFtaWMgUEFNVCBzaXR1YXRpb24uIFNvIEknbSBub3Qgc3VyZSBpZiBh
IGZ1bGwgV0FSTg0KaXMgbmVlZGVkLg0KDQpCdXQgSSdtIGp1c3QgcmVhbGl6aW5nIHRoYXQgdGhl
IHBhZ2UgaXQgaXMgYmFja2luZyBjb3VsZCByZWZvcm0gaXQncyB3YXkgaW50byBhDQoyTUIgcGFn
ZS4gVGhlbiwgYWZ0ZXIgdGhlIFREWCBodWdlIHBhZ2VzIHNlcmllcywgaXQgY291bGQgZW5kIHVw
IGdldHRpbmcgbWFwcGVkDQphcyAyTUIgcHJpdmF0ZSBtZW1vcnkuIEluIHdoaWNoIGNhc2UgdGhl
IFBBTVQuUkVNT1ZFIG5lZWRzIHRvIHN1Y2NlZWQgYmVmb3JlDQphZGRpbmcgdGhlIHBhZ2UgYXMg
Mk1CLiBIbW0sIG5lZWQgdG8gY2hlY2sgVERYIGh1Z2UgcGFnZSBzZXJpZXMsIGJlY2F1c2UgSSB0
aGluaw0KdGhpcyBpcyBub3QgaGFuZGxlZC4gU28gd2hlbiBURFggaHVnZSBwYWdlcyBjb21lcywg
YSBXQVJOIG1pZ2h0IGJlIG1vcmUNCmFwcHJvcHJpYXRlLg0KDQpXZSBtaWdodCBuZWVkIHRvIG1h
a2UgdGR4X3BhbXRfcHV0KCkgcmV0dXJuIGFuIGVycm9yIGZvciBodWdlIHBhZ2VzLCBhbmQgdHJl
YXQNCmZhaWx1cmUgbGlrZSB0aGUgb3RoZXIgVERYIHJlbW92ZSBmYWlsdXJlcywgb3IgbWF5YmUg
anVzdCBhIFdBUk4uIEknZCBsZWFuDQp0b3dhcmRzIGp1c3QgdGhlIFdBUk4uIERvIHlvdSBoYXZl
IGFueSBiZXR0ZXIgaWRlYXM/DQoNCj4gDQo+ID4gKwkJCWdvdG8gb3V0X2ZyZWU7DQo+ID4gKwkJ
fQ0KPiA+ICsNCj4gPiArCQlhdG9taWNfaW5jKHBhbXRfcmVmY291bnQpOw0KPiA+ICsJfQ0KPiA+
ICsNCj4gPiArCXJldHVybiByZXQ7DQo+IA0KPiBNYXliZSBqdXN0IHJldHVybiAwIGhlcmUgc2lu
Y2UgYWxsIGVycm9yIHBhdGhzIG11c3QgYmUgZGlyZWN0ZWQgdG8gb3V0X2ZyZWUuDQoNClllcy4N
Cg0KPiANCj4gPiArb3V0X2ZyZWU6DQo+ID4gKwkvKg0KPiA+ICsJICogcGFtdF9wYV9hcnJheSBp
cyBwb3B1bGF0ZWQgb3IgemVyb2VkIHVwIHRvIHRkeF9kcGFtdF9lbnRyeV9wYWdlcygpDQo+ID4g
KwkgKiBhYm92ZS4gZnJlZV9wYW10X2FycmF5KCkgY2FuIGhhbmRsZSBlaXRoZXIgY2FzZS4NCj4g
PiArCSAqLw0KPiA+ICsJZnJlZV9wYW10X2FycmF5KHBhbXRfcGFfYXJyYXkpOw0KPiA+ICsJcmV0
dXJuIHJldDsNCj4gPiArfQ0KPiA+ICtFWFBPUlRfU1lNQk9MX0dQTCh0ZHhfcGFtdF9nZXQpOw0K
PiA+ICsNCj4gPiANCj4gWy4uLl0NCg0K

