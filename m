Return-Path: <kvm+bounces-12466-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A13B8865CC
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 05:38:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0D6BFB23944
	for <lists+kvm@lfdr.de>; Fri, 22 Mar 2024 04:38:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 020D9883D;
	Fri, 22 Mar 2024 04:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G2W8xS4H"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E80337E6;
	Fri, 22 Mar 2024 04:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711082271; cv=fail; b=TfnVyKhRDmmo4XB2msjO84zy4cDfVyRd1bP9f5iPsoXj7UB5U6d0Ykuos83uEy0VCaeHfJcWn+whiORC460uLSV5FxbP7ya5Dw1h9aEgCn9jwksWayhQBHI3l7oownvcRwVe1IhbcYwTnTkQhhZNTRvtVks7uNOD9GRfNGIwtI8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711082271; c=relaxed/simple;
	bh=65kqL4mNSgApEN5rvrVTHcc3wD/jEWQByfHdF8qBZMs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YDo6tgcOsZ7XE43r5EAiIsQnpPzLSuA2Ll441mjKYKHO7+UbRt0JjC/MG9b9esG1x+6DUxcboun02VrHWBNaJODcxPF4VTmTS7U/b+uYVVehGsvYpDIHkBlKI0uJh6YCq9OVnu4CHsUZQa2h5FOCp1a/WinDjIMOYZXXmqHop1Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G2W8xS4H; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711082269; x=1742618269;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=65kqL4mNSgApEN5rvrVTHcc3wD/jEWQByfHdF8qBZMs=;
  b=G2W8xS4HiQrAj3B5bc0WxYSCcDdfJGGtN8Jnr5S+RKmUTOtrB9zA7Igr
   SW86eGW0iZCmFZN5HJrMKJo0tSz5YAnfYXAz7DfnWCHZtLf1Agl6iyAS7
   u1WKhoJoXaYE6HBTkajYonK6v2fPW9k/G8veNB42VcjvmAlu59Kk/DYiG
   +MvIlHrFq9NnKtr1I+r5sQZ6WwT1FzxtM9oo2OnIc4/Td8xKhzcK7l44M
   Xuc1ymCwMVMn7MYjdM+3MdItZQfuNMgqZsI4+cVd4UYULT4UQITFhJImJ
   TC4gOuYEBVtEfLBt1omhpeTQSGiLjEiqTC8RSsI4nJCBzUSBgPnUZqrTA
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11020"; a="6228614"
X-IronPort-AV: E=Sophos;i="6.07,144,1708416000"; 
   d="scan'208";a="6228614"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 21:37:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,144,1708416000"; 
   d="scan'208";a="45758767"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 21 Mar 2024 21:37:48 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 21 Mar 2024 21:37:48 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 21 Mar 2024 21:37:47 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 21 Mar 2024 21:37:47 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 21 Mar 2024 21:37:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OGPmHJknztxMJyoloqMI9hP7yU6NNOcL19DcURTdol8ktoCXj/19EsxCgZ3BQ7OEbGuYrNTkb1iPSND/XNu4PeJOrGmZfvzJyiMAtycQefayZ59F8jUGbCIZwTBj0WzehnGd0tzf4MnAoOPxd9C5cMHHiGViXOFa/vHGXJJmo6dLqMKUY7nXHftFKyQERJm5S/8zLiBBzpxCd3c+V6TzH4Cts2RaExrrJAJA42KTyP5OGJ+3Auaoo2DBIJkjCxgo+z3xNiDdhIylDEP7Qjt2kRzNdQp8ofgpiq5tHbJDbosQ773T3W1jJB2Hzgg8HpyrsEdo3j6DvTXDqHln8M2YSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=65kqL4mNSgApEN5rvrVTHcc3wD/jEWQByfHdF8qBZMs=;
 b=E3XpGuBdaid8KZHcBE0oeVip/iiUT0YZLa54m5MUyE1irOm5v/RBK7qZ0OZkaRqUmuWc+iQ9iTHKPY+qlf6+Kj3yY7Ye5GAVt86uwCAJIMitJDUkQF/YDeI4PUps/HJhNWU4fJF84qkM1xD2lYBESx5D8mpOjHJZYppUmOHGlJ7tBkq5NPTchTwXzV4A+fwndFs0EUXxHtBcvj78PZfb3WgUtcpGZYnpvMp1MXs2gDgJdTiCw7LOvbcStgn6mUWURtsUZd9Qithsi4wGIb3mdyJliHb/lfAR0RCCklnApW0gfrQDXuetFerjDLLqyrBb4wFQe9yXyKj134UeWDaskw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA1PR11MB7272.namprd11.prod.outlook.com (2603:10b6:208:428::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.11; Fri, 22 Mar
 2024 04:37:44 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7409.010; Fri, 22 Mar 2024
 04:37:40 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"Yuan, Hang" <hang.yuan@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Yao, Yuan" <yuan.yao@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v19 030/130] KVM: TDX: Add helper functions to print TDX
 SEAMCALL error
Thread-Topic: [PATCH v19 030/130] KVM: TDX: Add helper functions to print TDX
 SEAMCALL error
Thread-Index: AQHaaI26FrHcdX+u0kqmKjY/lD3kJ7E/6iGAgAFl74CAABZHgIABniYAgABPvQA=
Date: Fri, 22 Mar 2024 04:37:40 +0000
Message-ID: <1fd0ff586a0f42cf04508e155ae5011859bcb14b.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <1259755bde3a07ec4dc2c78626fa348cf7323b33.1708933498.git.isaku.yamahata@intel.com>
	 <315bfb1b-7735-4e26-b881-fcaa25e0d3f3@intel.com>
	 <20240320215013.GJ1994522@ls.amr.corp.intel.com>
	 <76e918cf-44ef-4e9b-9e56-84256b637398@intel.com>
	 <20240321235214.GV1994522@ls.amr.corp.intel.com>
In-Reply-To: <20240321235214.GV1994522@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|IA1PR11MB7272:EE_
x-ms-office365-filtering-correlation-id: a7800d83-1c18-4c23-bb3b-08dc4a29cf0c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Bifx1p851Y5CjTdvKoaHUj/TI7mR/dQW9Tt6YLlOIUIXTFxWTNMF6lI21nNmfrKqFiG1XgAqBMfSQQHRXy1aXRCupDAgFN+LpzU/tqfdX3iYClgv4QUS49VrQNKdkmECcejsG2xMnTiMLwaX+z5+jxY/qusjOSIvXk6Shvg0MUCQJmQ1xHw0WaRRqDnm14GGQXpDozilU8+pwXbOTZMT/PdIVduwTi17geDykt5RtY/H/YhEPgsmIVZCi86HVsLxigixgA+VqQZJMrTWD4JmVfGmSSqr4U5vP/S6EiKfPNfRDdZ52bksw+2R8FY8wQIxvCTxKuZCZaXjPX90bsCvRNzexLwXB1KBGmPgeo+/WG8WMAZF5i1UhhnqnSC0FktGxsDVGvtfZwzlKLhqEfNXztAXXmXtaBQcLFNAbXYmkYVg2L+HFOeKeyDkNc5lzTHPgn4XM6IOnaY2sFP+4nlTnpt82i+sNYiBntkj2rt0qcwInsdWwC2Ch1jAjQJLzMG6n3fQS+DT0S8lysAwhRFF7SRwug9JYWySUoyJBhKMawbVMrCJowD7FAWmS5ZeXYLPJSLX/ByESkiap4BHszqHElJbUg3eNCWArMulUcMngJ3FugroORvLzzVBdC2AZAhhA6xbssOC9tSvBGJP82OPl+uF90Sfpl/cof2fRr9bm/ARpE777uyacQtn+T/lXFGiadZhUR8cM4ur5NF3eVHw6mSNjIeEktHFaKz3N0D43PE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cDh6WWxqYXRiRUE3MjNZNjUvR3lPcTh4eVNxZmJpeFlDNHFuQWZOem1SNEVW?=
 =?utf-8?B?RXNxbGJud0NYd3BUWnZpZFYzQkZPdjZmSWR1NG9jN0czaG83akdPWFo1VjVJ?=
 =?utf-8?B?Mi9kVzEvTytFTXgxREZiQnRTVlQwbmdHV1VIdDhScnk2Y3Fqbi9YUzVFc1hX?=
 =?utf-8?B?RVZMRnJnTjdLT3ZHR3ZTM3RCelgzd3FsdXNobWVFdGZKclNBajFxREY3bHBJ?=
 =?utf-8?B?Vy9UdDc1Q0thL204L0M3SFoyekxrbndoMlNUWUZ0TTUxdlRDbkcyUTllKzBp?=
 =?utf-8?B?aFNiK01odWF6MnVTZkxGSFVRci90aW9oMFJpQi9qTTZhNjQza2JQWFlDdzFP?=
 =?utf-8?B?NGxIVzlZaUp1ZWg0U29DckdPZ3E2a2VlVWpvT1pRQ3ovMmhrL3hVUVVkRFBi?=
 =?utf-8?B?dmdkNjBmcEx0TUVpQ01SbmlUYzEwd2ZQUlFScVdsUU1tLzh4Rk83dU5MS0NL?=
 =?utf-8?B?ZVE3UVF1V1ltbGdkMHpKdXZsOWZNZWN3V0hhSWZock9pTmlWOTdaQVQ3aElm?=
 =?utf-8?B?emw1eUdubWsvWG1Mb3BURC9rQjJ0TVplc0JjaEkrcTA5dEN6MEhMUWd6UU5h?=
 =?utf-8?B?VnBJNU5sQmFmSG5la3dVZlBMcGg4cEo4eE5SUzNJbmNPM25tK1hBR3BySE84?=
 =?utf-8?B?WHJDZGM2aEFpMm1MZHhrMGlxclh6dk1lZloycVdTREIwUTZodEhISWJyR1Zu?=
 =?utf-8?B?eFExWEdKZStCV2ZWTmxsMENsTGN2NTRvaCtUWExraXpsWW5VSlFEaVE2cnJo?=
 =?utf-8?B?YkZ3ejJ3T2Rjd3poOEt5Y1NEYnpKRVBCQ3dFVzBzOUZ4a1gyeEcwVGlFa21k?=
 =?utf-8?B?UlNPZVEraDFtSGRVeDF5SWxET045dXZoNEZvRDAvYkc5RGR6SmFNMWQxK21u?=
 =?utf-8?B?QnFhTHV3VFpscHZCeHduaHZyOHJwVy9pNW9xNXFaRXYrZ2ZzY1o2ZVFQZ0Ez?=
 =?utf-8?B?Ly9QSVMzRjhmNVQzUEFHaGtlZXduMmFyem53U3RmYTBIa1B4ZXFFWlVpNXBT?=
 =?utf-8?B?eXljdXhYbmo1VVhDMEY4OVBSS1ZyZEVvbkZ1aEdnSk5NVzBlRDRDZi9ycDZC?=
 =?utf-8?B?bG15Z2Rpb1ZwVjRHeS9XbTV0MEVVYWcwajBLNGpaTXl2enc3RVE3ZWpQazRp?=
 =?utf-8?B?blNZS1hKVUtMZndBS010Zkk4TjBxbzBZbm1Id01iZUo5eUg4NFVZa05Cc0FC?=
 =?utf-8?B?TlJBU0tYYitCU0pVMTAxK29BT3J4elRUYXd1RWc2U1VsYjVYMkt3ZEtFbVFu?=
 =?utf-8?B?dXdGTmpMcHMvVDJ2ZmJJTm44M3gvQ1J4WEQwQ3ZuNUhDUXpLc1RFY1Z0MUNx?=
 =?utf-8?B?d3g0bG9RWWxFK1ZkWmxoQ1IySEQyOGtlbGtTdjdjUUVLY21leHF2aUVPdVQr?=
 =?utf-8?B?NVdxTEdVU292djZXTWlHa2pKZDVhK0dpeld6aUFhT0RydlMxUjl0UWQzQ3ZO?=
 =?utf-8?B?L2V4MW02eFIwTTZPcjErSGhTaHlDWm9Jd1UrMUQ4VVBEZHZRaTd1MWh0UXQr?=
 =?utf-8?B?eDNIaUhhOWhod2E0eXc2dExMNUZ1aVFSNXhjWE5rc1oyK1R2ZzNBcUdkOGNY?=
 =?utf-8?B?YmdWRzZHZFNNK2tqaGc0b2syVUhmekFyb1NqaUFDd1dEL3M1N2YrTEQ5Sk85?=
 =?utf-8?B?dUo0bGk4anJsd1d4N29Pb2R2bHJ5eXZBMmc4a1JSckp5Z2FZNTh3U1FiSlJD?=
 =?utf-8?B?Y3FFUjluOXRTOXJaRjhIWFZ0VjFBdkVpeFg2dS9SYTYxdU5hbndSS1JWbkVx?=
 =?utf-8?B?R3BTaDVBNGxEK0dnYVo5a1g0NlFGODdxdGJhOTdyakJ2K2Yvc2VvVjMwOGtO?=
 =?utf-8?B?Z0NjZkZrZ0NkZUZrSEZJaUFJSzVmVkgzbFpVdWJhcGdsRkhPSXltS1dRUHRI?=
 =?utf-8?B?b1RVengvRTFpRnVZS2dlcy9CZVJMLzhIOWNxWDQ5bHFndUJZV2NiU0JJV2Vh?=
 =?utf-8?B?M2tNMERjckkxMFVtN0xNS2kyVG9uL2V0L3cxd0szOUVPdy9ERVNRNFFkcDZw?=
 =?utf-8?B?MEdwL0Fnd3R3N0Q5ekVBLzU1Q05kdUJRU3U4S0ZGNHUrTHlFTUJNelpyTkZ4?=
 =?utf-8?B?TUMyZTRDVmRVTmt1czZvbWJLRGc4RkZiWmZldHc2cmhiZzhZbURPWkN6S0Fp?=
 =?utf-8?B?aDN0VDVNQUhyNFFJeVdsdnlPSGlJVzhxbnREUkltRGhxZ3B5REE1bXNlQUFx?=
 =?utf-8?B?NkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0E034FA4C6488C4ABD3E11FE2299CF59@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7800d83-1c18-4c23-bb3b-08dc4a29cf0c
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Mar 2024 04:37:40.7368
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dFDSk8HGiu3bWyS/eWxI/t3INBcErpHWQe/FV6RuZqOSWli0pf8YuE6DEoegnbPv2jKTsCDqicqXD2aEQf6Ogw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7272
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTAzLTIxIGF0IDE2OjUyIC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gT24gVGh1LCBNYXIgMjEsIDIwMjQgYXQgMTI6MDk6NTdQTSArMTMwMCwNCj4gIkh1YW5nLCBL
YWkiIDxrYWkuaHVhbmdAaW50ZWwuY29tPiB3cm90ZToNCj4gDQo+ID4gPiBEb2VzIGl0IG1ha2Ug
c2Vuc2U/DQo+ID4gPiANCj4gPiA+IHZvaWQgcHJfdGR4X2Vycm9yKHU2NCBvcCwgdTY0IGVycm9y
X2NvZGUpDQo+ID4gPiB7DQo+ID4gPiAgICAgICAgICBwcl9lcnJfcmF0ZWxpbWl0ZWQoIlNFQU1D
QUxMICgweCUwMTZsbHgpIGZhaWxlZDogMHglMDE2bGx4XG4iLA0KPiA+ID4gICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIG9wLCBlcnJvcl9jb2RlKTsNCj4gPiA+IH0NCj4gPiANCj4gPiBTaG91
bGQgd2UgYWxzbyBoYXZlIGEgX3JldCB2ZXJzaW9uPw0KPiA+IA0KPiA+IHZvaWQgcHJfc2VhbWNh
bGxfZXJyKHU2NCBvcCwgdTY0IGVycikNCj4gPiB7DQo+ID4gCS8qIEEgY29tbWVudCB0byBleHBs
YWluIHdoeSB1c2luZyB0aGUgX3JhdGVsaW1pdGVkKCkgdmVyc2lvbj8gKi8NCj4gDQo+IEJlY2F1
c2UgS1ZNIGNhbiBoaXQgc3VjY2Vzc2l2ZSBzZWFtY2FsbCBlcm9ycnMgZS5nLiBkdXJpbmcgZGVz
dXRydWN0aW5nIFRELA0KPiAoaXQncyB1bmludGVudGlvbmFsIHNvbWV0aW1lcyksIHJhdGVsaW1p
dGVkIHZlcnNpb24gaXMgcHJlZmVycmVkIGFzIHNhZmUgZ3VhcmQuDQo+IEZvciBleGFtcGxlLCBT
RUFNQ0FMTCBvbiBhbGwgb3Igc29tZSBMUHMgKFRESF9NTkdfS0VZX0ZSRUVJRCkgY2FuIGZhaWwg
YXQgdGhlDQo+IHNhbWUgdGltZS4gIEFuZCB0aGUgbnVtYmVyIG9mIExQcyBjYW4gYmUgaHVuZHJl
ZHMuDQoNCkkgbWVhbiB5b3UgY2VydGFpbmx5IGhhdmUgYSByZWFzb24gdG8gdXNlIF9yYXRlbGlt
aXRlZCgpIHZlcnNpb24uICBNeSBwb2ludCBpcw0KeW91IGF0IGxlYXN0IGV4cGxhaW4gaXQgaW4g
YSBjb21tZW50Lg0KDQo+IA0KPiANCj4gPiAJcHJfZXJyX3JhdGVsaW1pdGVkKC4uLik7DQo+ID4g
fQ0KPiA+IA0KPiA+IHZvaWQgcHJfc2VhbWNhbGxfZXJyX3JldCh1NjQgb3AsIHU2NCBlcnIsIHN0
cnVjdCB0ZHhfbW9kdWxlX2FyZ3MgKmFyZykNCj4gPiB7DQo+ID4gCXByX2Vycl9zZWFtY2FsbChv
cCwgZXJyKTsNCj4gPiAJDQo+ID4gCXByX2Vycl9yYXRlbGltaXRlZCguLi4pOw0KPiA+IH0NCj4g
PiANCj4gPiAoSG1tLi4uIGlmIHlvdSBsb29rIGF0IHRoZSB0ZHguYyBpbiBURFggaG9zdCwgdGhl
cmUncyBzaW1pbGFyIGNvZGUgdGhlcmUsDQo+ID4gYW5kIGFnYWluLCBpdCB3YXMgYSBsaXR0bGUg
Yml0IGFubm95aW5nIHdoZW4gSSBkaWQgdGhhdC4uKQ0KPiA+IA0KPiA+IEFnYWluLCBpZiB3ZSBq
dXN0IHVzZSBzZWFtY2FsbF9yZXQoKSBmb3IgQUxMIFNFQU1DQUxMcyBleGNlcHQgVlAuRU5URVIs
IHdlDQo+ID4gY2FuIHNpbXBseSBoYXZlIG9uZS4uDQo+IA0KPiBXaGF0IGFib3V0IHRoaXM/DQo+
IA0KPiB2b2lkIHByX3NlYW1jYWxsX2Vycl9yZXQodTY0IG9wLCB1NjQgZXJyLCBzdHJ1Y3QgdGR4
X21vZHVsZV9hcmdzICphcmcpDQo+IHsNCj4gICAgICAgICBwcl9lcnJfcmF0ZWxpbWl0ZWQoIlNF
QU1DQUxMICgweCUwMTZsbHgpIGZhaWxlZDogMHglMDE2bGx4XG4iLA0KPiAgICAgICAgICAgICAg
ICAgICAgICAgICAgICBvcCwgZXJyb3JfY29kZSk7DQo+ICAgICAgICAgaWYgKGFyZykJDQo+ICAg
ICAgICAgCXByX2Vycl9yYXRlbGltaXRlZCguLi4pOw0KPiB9DQo+IA0KDQpGaW5lIHRvIG1lLg0K
DQpPciBjYWxsIHByX3NlYW1jYWxsX2VycigpIGluc3RlYWQuICBJIGRvbid0IGNhcmUgdG9vIG11
Y2guDQo=

