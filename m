Return-Path: <kvm+bounces-15036-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DE1008A8FC5
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 02:02:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 993C32824AC
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 00:02:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E2BF1C3D;
	Thu, 18 Apr 2024 00:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j0zLqSC4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C10C181;
	Thu, 18 Apr 2024 00:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713398538; cv=fail; b=D6P8fbe7Uy2VxJWV9A+7IhYme8FVkMYEQ6ylpIIS+AQTkmdDz5WquFEqsjx/e26CxZXNJjqiNuGBzL1wvYdj8yFxtdagiiiVoSMXOV4XvZRQsVqlyaSpTPg3rSBz12xGAaSqP22/ZRqwQ37IJCREdNk2zuP/x+JsBfAlLfKDC2I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713398538; c=relaxed/simple;
	bh=9EOHWc+BTXnzYqbehBusgLvdbGgFuniXMdXmF/xO05E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=SH9mTOg1qiPNu+GnPRmLM53kAEx2wuNo+vEY1STvvEiMYkciGqDEc761QtHl3gaEu2qbPnier1AWxftf9hkFs1yttRBUVgdXBGOZmOwhcNIzPHs5s4I/Fk35ONB8cF4Sy3CBZ1uVFv+BDYZfT8IXUwCutpwL4HG8pqa1ew8y8x4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j0zLqSC4; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713398538; x=1744934538;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=9EOHWc+BTXnzYqbehBusgLvdbGgFuniXMdXmF/xO05E=;
  b=j0zLqSC4+kGcHq9IiT79lKcpKhxOnAgJazuDeuMVKs0SoFG0HETkx/5h
   e4DwvU4o40B5cCo1aQnQJ8JASBaktl7AWpZEQiqb37ovN1X4sOPG2ce4W
   kkuOrYmtWbMDdFmXY4R17RQ42mQ8jvNBggY7C8zLeP+7lAWCUteVINjkJ
   ZkZBR9+D0+NDWw61qcYNb32o2yuJHIInRkA6NSkWnQw3986A/q8dwVu6x
   xyHlnjFN4A+V7sNMOFPy4TK3MKSZMk/PYBoGpiEt31Dfn21yF3QrItoMG
   Ce7N6YpiMmu913LmW8JpuMYVoKRSwCwsPNbGrOhG2mqestMQPLH6ulZ3l
   g==;
X-CSE-ConnectionGUID: g8yJYg4NQaKWwrwRWTtyvw==
X-CSE-MsgGUID: gD6c6dDLSWycu+Ma1tcQUw==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="9468282"
X-IronPort-AV: E=Sophos;i="6.07,210,1708416000"; 
   d="scan'208";a="9468282"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 17:01:08 -0700
X-CSE-ConnectionGUID: 8cnowzMTTwu+jQqZ9CV05g==
X-CSE-MsgGUID: c7+n5dRzRnK3VIzbb1HTUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,210,1708416000"; 
   d="scan'208";a="27450304"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Apr 2024 17:01:08 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Apr 2024 17:01:07 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 17 Apr 2024 17:01:06 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 17 Apr 2024 17:01:06 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 17 Apr 2024 17:01:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mXp8XYhz7S06CuphVWwAdahxiQb6YgOCWRbDkC+bXwq4OH8khFSVIo4Swu8WXlSVmmTyb76Z2mt7LsTN8O/6zxJ09ByTWGI8t78sGhRMBthknM2jKC5xm3QGAy3IJQny0JC7OO1yJMsvF92npPNWP8rmmUL1+Sr0guZ2Fnao5lQq3/UdU0M95//XROUSBpijjhlcHOTcoZY4UOm9faMtbxSt59aQXFMZViFdfbYjQ9gQfNBr8mZEJY2sdvYrHz/R6BPBWmLGRamIWx8Vx4XcHNtIy58FU7ZZiC3I14RKiQ1dZuHdh5Dlt2j382wGaVyjISkwX56OV/s6tkZlVAK7CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9EOHWc+BTXnzYqbehBusgLvdbGgFuniXMdXmF/xO05E=;
 b=dio0z/u1PsO60EgihIdAI2dsZ4PMH8BoZFjheyBJgeLmPZcRzyC0DD1gPsxO125eQ0NpD44i2dvQFipPAhqn/r4jLF9ZVrU1YLqlPHwb6R9xtvXhQ4NZrNTMChX+erKTJKSjMmJ8e0H8k9XIiuqUH/OtQJbAH37u0oH0Owsh0R1SuD0HHama6jiVgT6YMduZ38Lc9vbp6utV6NueqUBcXsJRin6aaSvPXnkiHIHslgKsPqYXlYSXFVW2RFgckuQi45Y8/d2SqQcmPY41VtIROWXwHhH1YGHuMjc39yHryFIdQPsoQ57JhPRYti+5mjx5LgAQ8/T/803UhPNrNu75RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CY8PR11MB7875.namprd11.prod.outlook.com (2603:10b6:930:6c::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.50; Thu, 18 Apr
 2024 00:01:03 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7472.027; Thu, 18 Apr 2024
 00:01:03 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v3 0/7] KVM: Guest Memory Pre-Population API
Thread-Topic: [PATCH v3 0/7] KVM: Guest Memory Pre-Population API
Thread-Index: AQHakNzaTxX4DImU70ihdbj0RK/TqrFtJUCA
Date: Thu, 18 Apr 2024 00:01:03 +0000
Message-ID: <65cdc0edae65ae78856fbeef90e77f21e729cf06.camel@intel.com>
References: <20240417153450.3608097-1-pbonzini@redhat.com>
In-Reply-To: <20240417153450.3608097-1-pbonzini@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CY8PR11MB7875:EE_
x-ms-office365-filtering-correlation-id: 7e95d20e-9e02-456c-4c34-08dc5f3aa338
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 47FAizTJprwxInKrKehMnJAg7Ju6rL6TM09ornX19ngElbqAlum1un7kwfwrNZHV2Lce93h6gidpJH0Z1r9FFZdw8wB3SKyfpKVX43Rk8Y/rpGuG48B5XOFQFkGe4U1ZnbIClxRFCpEadPJrUOoN94bPD1RZyjbAkWn4radbzaNDi31eUnuGu9HdroEBIIpk+1HRJb3caDoa9aSYxw2gaMhHerUssZ4AyZoTqUPBL8FZzcaJP5jkPMI7NSUZS55i0yrzWCUXqs8l+j7DssDDGJzK56ZLi7U9bLhuXpKTJmUYeAIgAhYlYDE2ckznOT0NGWCC3BRVgc6d4iOBoj+7GzirSJFBV/8jX8dBLemIZMCz6U59ua1irGX4P61DCnewOS6HGZQIQH3zQHFwASueQ+NbgP5Ey7N/XyyJaswZoDiHGStgbsyi1dozNlajh8siGAGZZteXjSiVDFKKnior/zHvkvRrqeOtu1wyV/nY4i35ZLqN5x8AOvSg3EbKQOlRkPTjgIj1BffwFpKdWYuxlD6wZOG9OorPdUy+7pOqdy/2c2e/iScNxNQa9euq8qi9BvHW/Q2GaZtAbEuJ0UNRpmcuD0UFbQGD+o5PehDGtZbNfTr/m8bzVnMCqbqDUORyyq7oGE26YOsFigxTiwoMOTwRz0uFQjvnlMzc0lJVHizyiFbmUYUtu24IruD3t9RpWrwfGuQHC51DW2K3WckIOnPWNz3quxuXMnRgbeysSxk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K2t4NTRhQUhiTXB0bi9VdHpnYmlwNDk1cElKVUFnUmh1b0I2Z3JXZ1d2NFV1?=
 =?utf-8?B?clhLYTNlL0tETWc0RTlVdXdIT3RRai9SaWtobHhKc2c1dDFIV3NpR280WkhW?=
 =?utf-8?B?V2F3b0pVMUxReW44Ynh3SGVndjhMSlhIeVpDdWxtMENZd21XOGFPYWU4bldv?=
 =?utf-8?B?OG1wTlFlSExMc2diZXdaa1REejgrbWJFdHpZWUVsemJNc3ZLNi9RNzVEV01L?=
 =?utf-8?B?ZzNtSW5hd1hGOGN1T2NJNzRTQkx1OEVxN2dzNUplU3dNQmY1aGJwODVkaTRS?=
 =?utf-8?B?YjhlZ2V2WkcwdW9CeUNrWHAyN1Z4Z3k3eUcybFREa01IZnREMDl0czJoNmtj?=
 =?utf-8?B?S0NiZThyYjh6eU0xajZwQjB0cVJDbjJWeWN6Tkk5NHhLSHYxVHBmZmh3WWJa?=
 =?utf-8?B?OCtranZDRTMwUDFjUmNVeG1MWThMNTc0Y2MwQThpQ2FkS1NGSkhFOHpHUXlO?=
 =?utf-8?B?WjdmRnJHeWpVYlBrNXU1ZTZnSDZMaXMrc2prTTVMOWVaZzRUdjR2RnZSNmlj?=
 =?utf-8?B?SHBSeGFZb1ljY3UxTStRUmI3QVRDZGZidnpWL3NYT0phNHhSc3pFLzlRbEI3?=
 =?utf-8?B?ZCttWDZyUXNDQ1JDMDEyT0IxdDlKV3FUcTNRa0lJQ3NWbmY5MlVOTzdCbU0w?=
 =?utf-8?B?WVZGSkVMR3FmU0hMcmNzcERSWkNFdEo4MzBQdkdRWm0ySmxGTFZhczk2N3lZ?=
 =?utf-8?B?b2YyM095RldIb3BqYW1FYXFZZnBoc252Wko2RUw5MDAvdExRa2pMbnMwTFBZ?=
 =?utf-8?B?c2Q1b3RnclBtUENnUDBCMXlBYmxFSTVoK0RlL0lZbFNhOU1vQzA0bUJqc1po?=
 =?utf-8?B?cFI4aGJ6U3JxYUtJeHo2dDArN2d3OFdjVUlmTHJRNzd2LzlPNzR3SExhOThN?=
 =?utf-8?B?WEFsMS92U2ZQeWhhWTNjdlBvZ3BnNkZuSE56WndDRDFaRXRIWTBKcG0vZHBX?=
 =?utf-8?B?ZTdWQk91Y1A4REZWUHdEK1EvZnltcUNtNHNqZUxjRmwzMGh5OU10d0ZpUks4?=
 =?utf-8?B?WFllNDFoUG9TTkY0RjBXOU94V29HL2loMVJCWHVtd1VqNkJpZ0kyazJGVUFr?=
 =?utf-8?B?QzQwdHhLUU5tRzJXbGFPMlM1ZElTTjVZVnd6SFh0S0l4SDBwbyt5bTZaRkpp?=
 =?utf-8?B?blBPZGxwTXhzWGVzUzRkTzdqNGU2M3dzVHRReEE3aGxtREpUZDJWL29SVGdY?=
 =?utf-8?B?cmVLSFBmZjNXRkxwUjJQWnRmYXpGcWhVR29ZNVRjZ2t4T0VPK1hyUWpNZG9v?=
 =?utf-8?B?aHlLWnZQRXlrWkJsUUhjc0dzWUNKM0piSndhZzd1YkNjYXRGZ1BpNmJQczJB?=
 =?utf-8?B?RHlMb0xydHlpa1lCb3JGc0hQb2pTeUVxWWpWUUtORGl2YTNOWGxVYVJOQm55?=
 =?utf-8?B?UGtyYWZoNlJ3L1dSdUJmb1VxZmEzQ0pQOG90cHJpQ1NqOWx4QUJscEk1Rmor?=
 =?utf-8?B?TXgvU0d3KzAxQTFnQ1gxeVhaUmpWL09oZ0FsZkh6R0luUDJHNm91dTl3QVJ1?=
 =?utf-8?B?Z3YxVlZHUjhKUm5ITFZHbXh2ZG5XOENjdGFMRkxMODBZcVlRcEdnclBaUlBi?=
 =?utf-8?B?bjJZcG4rNzc4WHc3OGUwV0RWa2xFdG1PR1FPMnNXWUhhcTBiNVlBK1N1eTlJ?=
 =?utf-8?B?TmV4V0lGeHA1NTFaQU15cEdQMkR5NmVLcEtUcUZRZFlGZFhPcENnRHdDZytB?=
 =?utf-8?B?TS9GbVNndVpYUHNBdVZUWWJSV3IxTm9MOVFqUXBQMTJRYkpRZmRuWElhN0ZY?=
 =?utf-8?B?TmU0RWxVcEdHZ2FmTW5VWDFFa3VkMWtyOW1RQU42YlJCWHU2emFOQkloUWRC?=
 =?utf-8?B?Z1dKVFlIVkhkMG5wSTBSWG9Pa3BwUUdEN050dzBGb09sQ0xoK1R3bzM1NnRR?=
 =?utf-8?B?VnlDMnB4ZGp1cUdRa1lPK1RHeUxMbnJUNnQ5TGxKbnBySTdRQXRaU2tJYklr?=
 =?utf-8?B?VlpBY0o2eDhYc0JyWWhDdVVLVy9VUlJla095Y2ZhdE5GNkE1NWtwSFdRdTYy?=
 =?utf-8?B?UE84S1BWWldqNVpsbWUrYkoxdTlaa3VmdEtnWTBDNEdBeW56Tk0wRWpLeVZ0?=
 =?utf-8?B?VXRJU08vSXBWZDRnb3YrclloR3NrWmNmMzhpZ2F3bm1uYmxKMUNYVFNIT3lj?=
 =?utf-8?B?Y1FJT1hwS2FSRzlTcThLS1YvRThKM2JLZ2dRWmtWU3FsakVBeDF2bmxSUERE?=
 =?utf-8?B?alE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <53BE058538737B42AB121967669815B1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e95d20e-9e02-456c-4c34-08dc5f3aa338
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2024 00:01:03.0262
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KkxfcTUO2ppEBqlX+k+aXFOwmcCEBhxMn+i8ZoyV8sm1X+eZhwTYNDHPu0TFa+6/OAyQomAMwbOxjLnnmq7M/WvOY14GS07OVbWxhB5qgG8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7875
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA0LTE3IGF0IDExOjM0IC0wNDAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiANCj4gQ29tcGFyZWQgdG8gSXNha3UncyB2MiwgSSBoYXZlIHJlZHVjZWQgdGhlIHNjb3BlIGFz
IG11Y2ggYXMgcG9zc2libGU6DQo+IA0KPiAtIG5vIHZlbmRvci1zcGVjaWZpYyBob29rcw0KDQpU
aGUgVERYIHBhdGNoZXMgYnVpbGQgb24gdGhpcywgd2l0aCB0aGUgdmVuZG9yIGNhbGxiYWNrIGxv
b2tpbmcgbGlrZToNCg0KIg0KaW50IHRkeF9wcmVfbW11X21hcF9wYWdlKHN0cnVjdCBrdm1fdmNw
dSAqdmNwdSwNCgkJCSBzdHJ1Y3Qga3ZtX21hcF9tZW1vcnkgKm1hcHBpbmcsDQoJCQkgdTY0ICpl
cnJvcl9jb2RlKQ0Kew0KCXN0cnVjdCBrdm1fdGR4ICprdm1fdGR4ID0gdG9fa3ZtX3RkeCh2Y3B1
LT5rdm0pOw0KCXN0cnVjdCBrdm0gKmt2bSA9IHZjcHUtPmt2bTsNCg0KCWlmICghdG9fdGR4KHZj
cHUpLT5pbml0aWFsaXplZCkNCgkJcmV0dXJuIC1FSU5WQUw7DQoNCgkvKiBTaGFyZWQtRVBUIGNh
c2UgKi8NCglpZiAoIShrdm1faXNfcHJpdmF0ZV9ncGEoa3ZtLCBtYXBwaW5nLT5iYXNlX2FkZHJl
c3MpKSkNCgkJcmV0dXJuIDA7DQoNCgkvKiBPbmNlIFREIGlzIGZpbmFsaXplZCwgdGhlIGluaXRp
YWwgZ3Vlc3QgbWVtb3J5IGlzIGZpeGVkLiAqLw0KCWlmIChpc190ZF9maW5hbGl6ZWQoa3ZtX3Rk
eCkpDQoJCXJldHVybiAtRUlOVkFMOw0KDQoJKmVycm9yX2NvZGUgPSBURFhfU0VQVF9QRkVSUjsN
CglyZXR1cm4gMDsNCn0NCiINCg0Ka3ZtX2lzX3ByaXZhdGVfZ3BhKCkgY2hlY2sgaXMgYWxyZWFk
eSBoYW5kbGVkIGluIHRoaXMgc2VyaWVzLg0KDQpUaGUgaW5pdGlhbGl6ZWQgYW5kIGZpbmFsaXpl
ZCBjaGVja3MgYXJlIG5pY2UgZ3VhcmQgcmFpbHMgZm9yIHVzZXJzcGFjZSwgYnV0DQpzaG91bGRu
J3QgYmUgc3RyaWN0bHkgcmVxdWlyZWQuDQoNClRoZSBURFhfU0VQVF9QRkVSUiBpcyAoUEZFUlJf
V1JJVEVfTUFTSyB8IFBGRVJSX1BSSVZBVEVfQUNDRVNTKS4gVGhlDQpQRkVSUl9XUklURV9NQVNL
IGRvZXNuJ3Qgc2VlbSB0byBiZSByZXF1aXJlZC4gSXNha3UsIHdoYXQgd2FzIHRoZSBpbnRlbnRp
b24/DQoNCkJ1dCwgSSB0aGluayBtYXliZSB3ZSBzaG91bGQgYWRkIGEgaG9vayBiYWNrIGluIHRo
ZSBURFggc2VyaWVzIGZvciB0aGUgZ3VhcmQNCnJhaWxzLg0K

