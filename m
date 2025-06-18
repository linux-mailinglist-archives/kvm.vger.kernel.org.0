Return-Path: <kvm+bounces-49921-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A011ADF9E6
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 01:47:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 93FC119E0CDE
	for <lists+kvm@lfdr.de>; Wed, 18 Jun 2025 23:47:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8F6329B221;
	Wed, 18 Jun 2025 23:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eYYhYTQ5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2DE155382;
	Wed, 18 Jun 2025 23:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750290442; cv=fail; b=jNFZvlqhmFvkDT/eOvGM3S6R/nIPE+6vzIXzeiHit/x3ECGuGAfOlKdXJ3gsmwl8jMoo4eUB704I4L5yy24T+9rtyxzIWtBA3rrPu7KSP8AozsCmOyIlYLws/U/6aX9+bq1drdwCJwqe9gb3op8C+mM3ZgBku24O+KR2yhABHyc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750290442; c=relaxed/simple;
	bh=+3nc+ykH6hSBiF7a067DhStlPQtAsLGKGIE8dcvBUIA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=neJA9UCiQworo77+363e2xhg5qgvGTqbdyy8F0uUJYOh4QuLs2gIYxhLRtGmw2muxGN/I56r4lEZfiWTXbj054g/0iT9LNv1pn3xhKLce3jDGvjtjAd1nK4ezh49t0J7vi32iPEV9qO8tRN0TcBqoHFr3MfZJKVQTEAIii8gl5s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eYYhYTQ5; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750290441; x=1781826441;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+3nc+ykH6hSBiF7a067DhStlPQtAsLGKGIE8dcvBUIA=;
  b=eYYhYTQ5TceKrfQevf5UFN+O2PWGMKvPcXED/m4VPWrCtO7tBjSPZlne
   BJ5J4cYUfu8iX3jTN73qQbycf7afy97e5Uo3UaTsMVOThEgWFmOWt+av2
   57DRfhkQygA5vruxIio7MiHZ4mwwLAOqAduttnfiwcbrzetNau2NHrpJP
   p3T0FvjiNE0l5lY9kbjn74HInDVcQgtXqx5RiUmXTC+hU4uvWHo+A+DUk
   ptBgjQcoXmuewBwra9YLpLdK2fycQ8UUVI65BWLLLdN0/C8PLbBzU8CHH
   5tQ2BQAxYjSUXPB2CFCRDVvnwbgVFKDLyo0Ujc9ava4NFC+fjw83xbfbE
   w==;
X-CSE-ConnectionGUID: T23BcU8BTdGusbcxtlubfA==
X-CSE-MsgGUID: wacZuBjBQXW796IKuxt08g==
X-IronPort-AV: E=McAfee;i="6800,10657,11468"; a="77936741"
X-IronPort-AV: E=Sophos;i="6.16,247,1744095600"; 
   d="scan'208";a="77936741"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 16:47:20 -0700
X-CSE-ConnectionGUID: tz9FTiLUSw+mxgWOLwsGBg==
X-CSE-MsgGUID: PFGToTDVQwGoUAeAQktJxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,247,1744095600"; 
   d="scan'208";a="149997391"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2025 16:47:19 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 16:47:19 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 18 Jun 2025 16:47:19 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.70)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 18 Jun 2025 16:47:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ndd2E06ArIFy0wtG6d1CEvKuFwCrhymCWuVJZbmvbBJAxtT2/uRSw5UuM3niuuCqEBOvPWxEAe5I/LqjNGqelB9JH8Jn24NbsetPC9+3yazy51G3IwvxTSsqnZDnOILVnXuGXQvpJztjLte1deP5Ex70piGYOnhAJr6s+abVFKUOw9rxmWk94j1zMsvg4pLgvdfCQrqrp4z6l0TkIYjjd3a6L11m5wk4By80walvF76YSxeqfMVyFbM13Cgg6X0bu0Oq+2jfYy84qUDAmIv4X3hmet4MOnItTwn0hg+8LXjuMM4A8mf1klalx4BqlEz7mFmS4rEGyhcxiDzpIUV1Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+3nc+ykH6hSBiF7a067DhStlPQtAsLGKGIE8dcvBUIA=;
 b=xfg5f4IkzkpNe+PPfgxNAgpeUnbdthCUZwQpws5ILyOlnL8jYsHCwV2j9jb89PI0wL+rZ2R0ztOideEzzkXC35tdct38+GnDGNVfQmlcIMGHzaQpratezeZnWcLgTUUALFy16ipMSbcdQdTy0trT35GdrWBxhx8fQUh9cR/Ta/eT4akJ9cL5DB/OEWe6I//w2Fug7Eh17IZDSwiyr51JAOjzpoajCUwFxOkfZ23dw6DWeEfAvhQ8roU3I6ak4WMpUhiBSBnnVHGLJt4CRO5gO+XoWX/9CZ2b45JpFGrZsSH1oXPd9UJHR65b70FJsuS+voyGxkDi5DQG/xOMXePLMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com (2603:10b6:a03:48a::9)
 by SJ0PR11MB6813.namprd11.prod.outlook.com (2603:10b6:a03:47f::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.27; Wed, 18 Jun
 2025 23:46:46 +0000
Received: from SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361]) by SJ1PR11MB6083.namprd11.prod.outlook.com
 ([fe80::acfd:b7e:b73b:9361%5]) with mapi id 15.20.8835.027; Wed, 18 Jun 2025
 23:46:45 +0000
From: "Luck, Tony" <tony.luck@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "linux-edac@vger.kernel.org"
	<linux-edac@vger.kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "Annapurve,
 Vishal" <vannapurve@google.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>, "Gao, Chao"
	<chao.gao@intel.com>, "x86@kernel.org" <x86@kernel.org>
Subject: RE: [PATCH 1/2] x86/mce: Fix missing address mask in recovery for
 errors in TDX/SEAM non-root mode
Thread-Topic: [PATCH 1/2] x86/mce: Fix missing address mask in recovery for
 errors in TDX/SEAM non-root mode
Thread-Index: AQHb4Em/xH1txe69zU+wjMA9RpcOPrQJjpYAgAAEL2CAAAH10A==
Date: Wed, 18 Jun 2025 23:46:45 +0000
Message-ID: <SJ1PR11MB6083E80CEE14BA99F7A0E237FC72A@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <20250618120806.113884-1-adrian.hunter@intel.com>
	 <20250618120806.113884-2-adrian.hunter@intel.com>
 <32c01f03f4971a76f1b7ef3634ee4e6c0ee5d899.camel@intel.com>
 <SJ1PR11MB60831B85840BD194CBFA6CBFFC72A@SJ1PR11MB6083.namprd11.prod.outlook.com>
In-Reply-To: <SJ1PR11MB60831B85840BD194CBFA6CBFFC72A@SJ1PR11MB6083.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6083:EE_|SJ0PR11MB6813:EE_
x-ms-office365-filtering-correlation-id: e72b5dae-1a1f-4ce0-a015-08ddaec26291
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?cUVCbzIyMlBlbzRTUWI1VDhubGxYQjAyaVd1WmJ6Z0QzSDNnNGNQcmhsaVMv?=
 =?utf-8?B?Zm1ibE1FRzE4TGJYeXNOYVVRUmpPY0ZBSjJIY3NhNWRuWmt6ZTJYYnlTS3h5?=
 =?utf-8?B?V0hWWnVDRkltTDRmTCtIUzBwVUk5aXIycDNCNXJtODZ6QmJaODVNTTQwUVpT?=
 =?utf-8?B?ZkcwNm14bkVQbWVueWkxVWN3QnlnREdYUkIzMlZFU2pnYXFNdFcrRWVXVXVD?=
 =?utf-8?B?MUttV0VYWXNrcGxWbUMxY1BySDIyMFNTTjZxVkJiTkZsWCtSM29NeGpyUU9R?=
 =?utf-8?B?N21oV0Z0SU1yczBpMGVrV2gvZnF6ajFRM1FtOGlMaTRuSG52SzBidHRQMU5G?=
 =?utf-8?B?Z3p5U2hpMEVMZzNtME5nY0lnMlN1dGd4eTZZS0xiMjc1cmF5SkJGYVBPQ2pp?=
 =?utf-8?B?aWhqZmVIckdud2lyMy9iZlZOL2wwT2FzWHVEWU03WHJrT1l1c2FHU0hFTWhs?=
 =?utf-8?B?dDZmR1NvUHpzS2J0cmdvWms2dEJIY2JnbGVXeC9WNjM2TkRFQkZxYmNjcENw?=
 =?utf-8?B?NTV6NHFlMFUyRlUzZGVLOUZZWnN1QkY3QStBNDRBRnliMXhDTlNPcUNnNEtw?=
 =?utf-8?B?ZVdVemFoZnphb2h3MEc2NmpWYmdqazZWWDNWMzlNci92eTduVkVqVml0ZmNy?=
 =?utf-8?B?ZmVWL29IN0tIQ0h4eGZpazBET3BWUGprNktyNFkvN1BEaHQ0dDhuRVlVV3oz?=
 =?utf-8?B?NHN2YmUvbndWbGl3UnptRU9BT1hINWw1Q2ZzVk5QUE5qNVVDaStHTUhQS3RU?=
 =?utf-8?B?UGliYWZXdDBmaDhzK0VuVmsxUVBuRmdjN3c5Q0lRRVRoMEF5QTBNRk5XZ0ky?=
 =?utf-8?B?a25QWVdwVThXWE40d1ZaVWdMd3NBMnJTWUc2NzlJZW5QV3hycWc4WXBLNTIy?=
 =?utf-8?B?L3JsYi9BZTFkNjdNT3p3V2ltN3BneHFUTHcrbUFYeHowSHN2bWRNbmZnSVc5?=
 =?utf-8?B?OFFCRjB3UWJQTjZiQWhMNjk2eUNWcm1NZm9yaWRLM3lXdzF3UEpPUjRDd2lw?=
 =?utf-8?B?ZFk1NmU4N1c0dnZXdmFxYUxjMkZVTE0xRHNUdm9nUGg5YUdFaDRSb0hpd2xJ?=
 =?utf-8?B?RG9iWkN3eUJCOWh0QVh0YmwzZWVEbHg0S0N3VEdVak9IZHJUVjdydnJFbkF6?=
 =?utf-8?B?MHp6MWdoVHFLd283eFk1YjV3WFRScVhzVEpFWWIzSVpESXpiNjZ3TFZ1QTFZ?=
 =?utf-8?B?UWt3MjJGYkM1R052RjRuOEdzaUdvOU0vbUVKRy8vNnE2bWN5VjBhYlR3WTJR?=
 =?utf-8?B?cmxXVHRNUkVkMEN5eDlXN3JQcytYeGR0SU9lV2IrUWs2T0M3OXBHTlhnUC9X?=
 =?utf-8?B?V1JIem5SbWpuRTQ1bGhrSnlZR3VTZ0NnYm9IUlZuNzF4YjI4dCtQdDZpSFV3?=
 =?utf-8?B?M1FROUVQclI4MGNpOWpRRGRkQm50NmNadFFmVnBOZDVicE1NaXJwNWlqWW5v?=
 =?utf-8?B?RFVwZXd0M0cwZERlR3J6bFg1V09YMnRtSmZBaVY1bXh2YkpsVnV1b0ovZ1Jn?=
 =?utf-8?B?emxyTEtGZExIbVYreUtSTEdya1JBcHNpQWJYdUU5bWc0REI1cjB0eFhVWU9t?=
 =?utf-8?B?TjFLYitGKzB4OUtxaU04eUpRdlVkS3h0VERWQXQybFF4WnN1ZVdyQjU2YnVD?=
 =?utf-8?B?RFlHc3hqd0FyN3pmYi9oY0JvOUFSWk00N01uMWVhajFDRVF6dk5wcVZiTmMy?=
 =?utf-8?B?aS9keU9kbzgvUkVDa2gvZ05NVXJsMWpib1BzaDlGeXJjdVZoSVZrRGs2cjR4?=
 =?utf-8?B?MGhHVStJZC9GVEVYM2ozcjk1Ryt4OWIvVG40alZZWjUyYzJXSVU1U2NpaU5m?=
 =?utf-8?B?TXo0U0hmNGUveXQ3VklYQmZQeXFGZTFrRGMyNUVoR3dKa05nbkNQZmU4SnRv?=
 =?utf-8?B?dFd6cHhvTGpCTVkrUXVkc3NRRnNRT1lsU0xjelJDaTZNRDZSeWNrUlpOSDJO?=
 =?utf-8?Q?EC4ebpGrErs=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6083.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WDhLK2laME1PYkdHV0FsTjQ3R3RZU0JhRlJQa21BdG5va2FXc2NNdWVSRlF1?=
 =?utf-8?B?N242UUZONkxiNVY3WFB1YWVBcmRsdkFMOCtIZXdla1V0VGpQTS9jQ2NyNUN1?=
 =?utf-8?B?NEk3NmNvSEVXdkJuOGpBYkVJdDlRSEJOK1NWZ0pnajdheXpPeUh1dytmMHIy?=
 =?utf-8?B?SnhpZ3BsUEhSSXdWcXBpN240WHZmRVFvazBaUERtT0xaaGpBQXpqL1NvMjk5?=
 =?utf-8?B?eXdpcFZ1L3pTZi9MMldqRU5USnQ5QmFkaTlwTUIzNHZVdkFudjdSNFdvVm01?=
 =?utf-8?B?eWVHcS9qR0Z3RmlzN2F4WUlwMCtVcVJ1b3NKSmZBN2RMemtuem1LZHB2N1JS?=
 =?utf-8?B?SURvNHJHR2pScUovcnpMS0xMTmw1T3IyUWo2NkRRa2tHZnVUdkhZdS9PNzNV?=
 =?utf-8?B?N3F4WTRnMGNZUUIvK2RVTkFnSTAxT2V2U2J1aUxiRTI2QmlSS1FENEhrNGxo?=
 =?utf-8?B?TWpPL3BHKzRUU3pzZEZrRDZoNTAzeUJ0ZEUwS0Z5U2N3NndLbFV5Q3psR0hr?=
 =?utf-8?B?VVA4TU5XbEE5SDc0Z3BMZ014ZnBnaklsQlFHNU5oMkkzQXRuT1ZLaHkxVkUy?=
 =?utf-8?B?aU5ueFk3WGhNbUw1aUNxQ3hvVXdqdHBacXpJT01XeThDN0s0TUxZbVJLcnBW?=
 =?utf-8?B?T2lNQzRNL2s4RHhOQTM4Mmp1ZXBIU3JzOWFDeXc4RnRNUktpN0cyT0RTQ0Zw?=
 =?utf-8?B?a3ZsNFdGU1IwVXFaNG1KNTVOQWM5OU1JdTRDV2FRMTViSzIrY1ZGWWJpeGMx?=
 =?utf-8?B?bGg3N2c3ZW4zVm03bXNWUnJTMVdyL2trK1NveUloZzk2NXR3YkY4bGYyaUgr?=
 =?utf-8?B?TE9TdWpLK0xmRWVlYmFlYTRxR2V1SE93QlhyTUYxbW1BV3BCd0R5eUh0R204?=
 =?utf-8?B?OENIZTVFdEFCb0Y3UEtJRTJTV0JIVnVyZUNWd285bzk1NGxGNGZhUzJTTnE3?=
 =?utf-8?B?VXFHOU44bXQrb01LYURCcGoxSTRDY0FYWURLdm9OYzVRRTE4WlU1NTNmeDV1?=
 =?utf-8?B?UjN2MFhvanc0NkwvMmRYNlpqQ3ZPUTFBUG5sbnNjaUZtMjhIeHZJZ3ZkTkx2?=
 =?utf-8?B?K1h1c01paVdEb2RGVTlqUmNjYTczaGdmU0ZrUlFzN0UvNjRiZE9RVzNuTTkv?=
 =?utf-8?B?T0JnQmhoc1FpTVl4QnNOb1ViVjFtR2RKYUU3ekxZaFBZUjcyM0pHSVArQkZ1?=
 =?utf-8?B?QnIvNFdMbjBvM1JtTXJabHZDQTY1KzVEaUhCeTdEaWtVS3BJQ1B3MXBYY1Vi?=
 =?utf-8?B?SHpyYWpLampVRHZUVzZKSE1Ldk1TTDNTK2JlNWhNbUVEN1R3VnpXWWdlbFF2?=
 =?utf-8?B?cDgyUUNac3VkNGdJZWFKSWVpdDgxS0YrM2trYThjZFdrQjlhcStLL2hzT2F2?=
 =?utf-8?B?aGZnbWdOdmVqbkFKd0FZajg3dm1VNFVsRFk0MGx1Tytuay9va3VidWVnNGll?=
 =?utf-8?B?N3ZDRFR4QmFWMEs5TldHWG54YXpJbVo0eVo0Wk1Cclozc0svNmlQZXl2MmVv?=
 =?utf-8?B?QWRpRllSTmE1cGQ5eVVhb0NrVHNQSjVQVHFqTmNKcWU3aDlpMC9oNW51QjN4?=
 =?utf-8?B?WTBFOTNtSVdSODdhdWVOSkZidEpaaG1vMTNMMDZKdzJIZHRZYlpFUE1kS1lv?=
 =?utf-8?B?S3gxMGwrWGxiUEFiR0dGZHVvL21SL3J1QUV6cGg5NmhCc0UyZnY1Zkp5Q2Ev?=
 =?utf-8?B?MnhYbVBJQXJoQjg5VlA3OWJ3UGR6MldUS2ZUZFpDdHREb1lHbEVEdk53OFhh?=
 =?utf-8?B?Zmx1Vzc3U3pEREdSTW13MXVKY0hFcUFTK1QxNElocWgyZkZVY09wN2VMQllC?=
 =?utf-8?B?Y0szT0NXTHAvUE4rMmppL09NbERzZm5MVTBpUUtGK0xEUi9yU25zdU9oS3Rk?=
 =?utf-8?B?SWhCekRzdFlEd0RzVGNaeVlNUllvK2ZzK2NpcnR3REtSOWlsMWNGOFc1RHZK?=
 =?utf-8?B?YVFpNFg0eXd1RUY2UmI4dFhzZUgzbzRLSzFkUWJ0dmRuMy9ndmV6cWk5dFI0?=
 =?utf-8?B?c0VobHBlNytNOHBDRGNMek9aU1U0QXI3SVlNdmd6Z0JyRjk2M1dwckZxOXFD?=
 =?utf-8?B?Y3FlNTFJUENnaE5vVXZiRWxnNkswbzhPbVNPYXpMRm94WG00Tm1Fb01Qc3Fv?=
 =?utf-8?Q?vjwHfVLDp2Z8bVXVE5mJUFWsk?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6083.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e72b5dae-1a1f-4ce0-a015-08ddaec26291
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2025 23:46:45.6980
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LNjnApz6LhzcxPZJx1IXXu432klcGOTtvWzVvAqrupPgOrwwFF7YT1QZ/ZAUC20tTXGWA1awUtmmUybu856Fcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6813
X-OriginatorOrg: intel.com

PiBJdCdzIHNvcnQgb2YgaGludGVkIGF0IGluIHRoZSBTRE0gVm9sIDNCIEZpZ3VyZSAxNy03LiBJ
QTMyX01DaV9BRERSIE1TUg0KPiB3aXRoIHRoZSBmb290bm90ZSBpbiB0aGUgZGlhZ3JhbToNCj4N
Cj4gICAiVXNlZnVsIGJpdHMgaW4gdGhpcyBmaWVsZCBkZXBlbmQgb24gdGhlIGFkZHJlc3MgbWV0
aG9kb2xvZ3kgaW4gdXNlIHdoZW4gdGhlDQo+ICAgIHRoZSByZWdpc3RlciBzdGF0ZSBpcyBzYXZl
ZC4iDQo+DQo+IE1heWJlIHRoZXJlIGlzIHNvbWV0aGluZyBtb3JlIGV4cGxpY2l0IGluIGRvY3Vt
ZW50YXRpb24gZm9yIG1lbW9yeSBlbmNyeXB0aW9uPw0KDQoNClNlY3Rpb24gNS4xIGluIA0KaHR0
cHM6Ly9zb2Z0d2FyZS5pbnRlbC5jb20vc2l0ZXMvZGVmYXVsdC9maWxlcy9tYW5hZ2VkL2E1LzE2
L011bHRpLUtleS1Ub3RhbC1NZW1vcnktRW5jcnlwdGlvbi1TcGVjLnBkZg0KDQpzaG93cyBob3cg
dGhlIHVwcGVyIGJpdHMgb2YgdGhlIHBoeXNpY2FsIGFkZHJlc3MgYXJlIHVzZWQgZm9yIHRoZSA6
S2V5SUQiDQoNCi1Ub255DQo=

