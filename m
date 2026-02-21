Return-Path: <kvm+bounces-71433-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id V9HxMvb1mGlKOgMAu9opvQ
	(envelope-from <kvm+bounces-71433-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 21 Feb 2026 01:01:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B31116B7B5
	for <lists+kvm@lfdr.de>; Sat, 21 Feb 2026 01:01:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A18043021E70
	for <lists+kvm@lfdr.de>; Sat, 21 Feb 2026 00:01:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ED3DBA45;
	Sat, 21 Feb 2026 00:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EPsb4b6n"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94EBC256D;
	Sat, 21 Feb 2026 00:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771632102; cv=fail; b=P61e/kEFR/pjK2UVp+KBsNvic5bugbVZgRq0D5MW7jFeeca+TLaPgfLFGBOoICD++lONXrv2U9pMYRU7JQ0NuMaPfO1C0AHZyf98ImmZqYnoK9yZ2OvSGnKFu+fgudBFn1KXmPcBz0xcSnRo6BjrIEUyvxMWDYu3lOiVb7NcICg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771632102; c=relaxed/simple;
	bh=8w5yd7I2QurBIp5CPONXsHKdj9VGhnc73Z19MSgrjHQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TdCBPV6sWZX9KeeNII5vVP53fGNJUHWqj+VybNSLBvOzfVjovwFZ2ggEX84BeY1+ROCAkS5rH+NNw6kgXhMsxfaSXIsEAAwL3rayg5tgIf/ktPQ1Xo9RfXErJqv/OdQpgUoADftu9DMxVnFssfvBBXrEd/yayJ9JgN4KYyH6he4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EPsb4b6n; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771632101; x=1803168101;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=8w5yd7I2QurBIp5CPONXsHKdj9VGhnc73Z19MSgrjHQ=;
  b=EPsb4b6nMd/OTA1XheWGbS/9J9zeuGmbLmj3BGiE/lSN/3CsmZWqddCt
   gK+335qeKYpgJCHQGZdBb8J9GU08i6irudZKGgbwYoT0dDW0Z9urSfql2
   P7SPMKuWGJ1WkL4JbcAzrmZ2CXLvibw9QrmN6Mw7NwTWqqrO1OizioiEc
   tb5VHEi4pCIqqnmxSVTav6RCnGveq7bXeYYO5c5JxeYkA/Kgi/aLKQIev
   OR7GoN+yxo4dXZcLrRJQqkjNOL/HGbxBhaaRXfZD2enqf6sD/Jh7pmwLR
   tgXwrv8/6tbnc9NszgJ3+oWhK3GYuTR4CvxKv757C3J+6XOHU0yNSy0zC
   w==;
X-CSE-ConnectionGUID: EzMPTN2/Tw6JvowH2GDATg==
X-CSE-MsgGUID: aRBRCkJPRHy3yBK010Rqog==
X-IronPort-AV: E=McAfee;i="6800,10657,11707"; a="75338531"
X-IronPort-AV: E=Sophos;i="6.21,302,1763452800"; 
   d="scan'208";a="75338531"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2026 16:01:41 -0800
X-CSE-ConnectionGUID: JPB1Z71vQOeEQoHniBLzPQ==
X-CSE-MsgGUID: NGekgwjUR+SJrz0Wqfp7fQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,302,1763452800"; 
   d="scan'208";a="214999786"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2026 16:01:41 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 20 Feb 2026 16:01:40 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Fri, 20 Feb 2026 16:01:40 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.64) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Fri, 20 Feb 2026 16:01:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UZqcH/tujultx7zQY/MyE36me5+APHl4YPjvXaj6fxVEXQo90CSvoPC0EakEyMBbgeotKySgv0PzhMweKZ7cwyRyG7yZcWlK7EFLi6JZSBAzv66k6quMTYHxS5//ogJucy4mYIYfginlXtuOZ4AQtiJ9dFPYwoSdAAfta7IjBOjTQBqD5e8wpeSw3wdBuz8lrwaz2BgI3+/pjjbZk2QcyqzvQoyUR7p5e5CMJBgVfcUNxH7QK88LuMMuPBKYhrd81D/6VbIEbmFwrjhhPLI+dqEtKrSsb1VjHNeVR88bM41axP/Ihspz9Y2drKEhh8DrHWuUz3f+kKQyF6vW+c9AMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8w5yd7I2QurBIp5CPONXsHKdj9VGhnc73Z19MSgrjHQ=;
 b=l8JbYH341CfjiEc2smKNy0NYQ05bCsMVe2cRS2AHb/jf6HzZA2nI5WrEzBY04Z6IkHMmHuGZrGOr7DelVvl0Nyk5IWiLmgM11UW5OR3WgwsmBckR29mtLqO1LHnIjpNvY/Ynf2Cn12xOuKIHUhsnG7zwA+LFDJyin+SWdlfJ9ZxT6/cALWUDmbdD/dsuIqtN6vkB41dyKlV9ebONzbK9NpdB+BrH1yJZUm7FJhgv8ZXpWUYKjZZIntrVsbeEs572V0qlywIDrA3/blYuzdN2r+oS+De7ZDccKRTWKAK9yBZeH0Oe0cIr2nrSd3t0+fU311PqZcDBvimrXPMVwnlIfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA1PR11MB8248.namprd11.prod.outlook.com (2603:10b6:208:447::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.17; Sat, 21 Feb
 2026 00:01:38 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9632.010; Sat, 21 Feb 2026
 00:01:38 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86/mmu: Don't create SPTEs for addresses that
 aren't mappable
Thread-Topic: [PATCH] KVM: x86/mmu: Don't create SPTEs for addresses that
 aren't mappable
Thread-Index: AQHcoTXoP5tM7QU8XUq1kA8eNcmjl7WKjnqAgAFCVYCAAHdDgA==
Date: Sat, 21 Feb 2026 00:01:37 +0000
Message-ID: <dbf47f0eb749e88d2f2e73d2caba0a679ad8bc81.camel@intel.com>
References: <20260219002241.2908563-1-seanjc@google.com>
	 <c06466c636da3fc1dc14dc09260981a2554c7cc2.camel@intel.com>
	 <aZiR1cQxbDpRkQNn@google.com>
In-Reply-To: <aZiR1cQxbDpRkQNn@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA1PR11MB8248:EE_
x-ms-office365-filtering-correlation-id: db16003e-e4bf-44c8-f98b-08de70dc626e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?dVJtQVUybmVJR1RRVklheUc3cERZZ0ZDU2d5TnJObkJPYklKcTNiMFFMVDFM?=
 =?utf-8?B?aXJSK2lLQURJdEhFN1pQNFB1Q0hlQ21vQmVkYk1OL0htNWo0ciswdmhrendw?=
 =?utf-8?B?TlVtNmxHalZvekVoUVlSWkoyTnlFNnZLMUNLUmlUNWd6U1BkcjdNL1ZZRFc2?=
 =?utf-8?B?aHVsdk5HSzZIbWo2VHZLY2RCMU5yaXAxTFVXdkl3ODkzbGliRXZnL1pPQlcz?=
 =?utf-8?B?em15ZGtEa3owNGl4VGdxTHdpRzR2SWs2cWNLZXZzclI3azlRNFpYNjRrdUJl?=
 =?utf-8?B?RXBkalBJSzQva1R0T0Z1cXFNT3BaTkVVNlFiSld2dmNRMHJESHFDYUNVQWJt?=
 =?utf-8?B?ZTJubmVoWnpCcDJvTUF6YUVJSFRHNHphemtNNytEZHRWdEFNb2VsdE05M1hx?=
 =?utf-8?B?MzdSTTJUVElXejkrU2Q4M25OQnYxWlFrbXRuRGM4WjN2Z0hPcERUOWZHKy9B?=
 =?utf-8?B?b1g3OStrV3hpamJQRk9jWXd6eE95N0pOL2o3VkR0WHlBNTdTcE9WeWo1RFl1?=
 =?utf-8?B?VGpJRTRLaHpBbmd1eEx1QVdpQzYzNU4wV1VVSldRVVNDRFdFYnIvR25RcGRh?=
 =?utf-8?B?YVdSL0d2YWo2Y3Bpa1ZTSGRuT0xka28ySktQOXB2QlI1cGZIZWtkeVFBUDVX?=
 =?utf-8?B?U0FJM2R0ZCtIMjZmaWRkSHVFKzIvazFUZjlDUkVLTzdoVDVqOXFtcWF3cnB3?=
 =?utf-8?B?STBhUzJPL2hJd1lMQ2oxTVBNRy8zYTVDdnhyTUpjT09QUjJTZEN6S0JTaW1w?=
 =?utf-8?B?dGdvSHBRWmdGUzdYUmhqcytHYlJSdjBia2J1RXhFT2xjYWQ5RkRyUXZXZ3g1?=
 =?utf-8?B?YlN6M0hqb09tOU5tMU0vaUNSekljaEVKZjJmOW5RcXFrZmZYYnR6ZFVNTkt1?=
 =?utf-8?B?NnNITTNNUVRDMVZlUTdPOGpVaXBpN04wVmg1RnM0enZqU0gyN3AxUCtZVUpS?=
 =?utf-8?B?MzVidWUwQzBIT21DN3BnZEt3RVlKQUl5THZJQ3A1cm5TWms2MXA2d3lzc0RT?=
 =?utf-8?B?dm5ZbWlIUzZRZERnempwWWQydzROWmVlYzl0b0hiV2FMeEpZaHRwR3V6UE9D?=
 =?utf-8?B?eExVUTRBbDZGQ2c1SnllcEJ3K0o2bmZKUkdSc0xZM1M3QytQTWFWbnYrR3No?=
 =?utf-8?B?QS9mV0tubmswbk1WbWNVeGJwbERqOHdDY29PTStQZklyQmhJMmpJR2xRckQy?=
 =?utf-8?B?S3dWT2RlVVB1NzZ5UFJDc3FKRTVKbkMwc3EzQzkxR2RtRlVlY3V0c05EbTg2?=
 =?utf-8?B?ekZmY3ROZlhTaTArZDJtNG5KNkt3NDBMdHFSR29PUklmRjQzOHJaZWM2aEhQ?=
 =?utf-8?B?bGdVV3lEZTVUOE1raFlKSWNyWlRtZFZTYWpxYWxNZWluVGk4VGhhcUVPQlRI?=
 =?utf-8?B?bk9sZ1lUYU81VG1iajNkdStaV2htKzFNdVFNK2wrSC9PelZiMWljTWx6RXRC?=
 =?utf-8?B?YmJUeWI2dGk4bXEydFhBcE1MRTkxRjBaay9MWUhrTlpSbmZVb25GVVY0VE9n?=
 =?utf-8?B?WmhjOTlhVEU5di9uZW5VQW9KQzNDcCtvRlpleGpBM2FJQ0RieUM1b0g3ay9r?=
 =?utf-8?B?UlRmMnM1SFdYQU9BUDlUa1BiRUYzdmxJUGlQa3ExbllkOTFBbGZPR0Y1eTlz?=
 =?utf-8?B?bk51aWFWUGR5RE85cWpaUFo0cEdGOUY1OE5UMm5WblRJU1RNTHlQVE43VndT?=
 =?utf-8?B?M2ZheG5hb2hSRy9rVUFQMFZlU2x0NDVUUjk5OTNjQVJoQ0J3cVVKb29DS3p0?=
 =?utf-8?B?SWErNzg4T01TQ0kyU1RSbzByTHNwZGJRR05QcHJ0YUF5VFZWbUR4UlJYZHJD?=
 =?utf-8?B?TlpSbFV2NTZ4SlRoaDhmVloxRzliQ1kzOTQyOGtnNk41WS9jVTBRT3U5VVpI?=
 =?utf-8?B?bmNLMFYzbWF5R1NQUmJkMVVnNk9taklWamtnaGxPY0tTZTZNRXhZMWErMW0z?=
 =?utf-8?B?RWhhUXZJaHlQYnIwQnFIdENkVXVOUTJYeDloTFEzR21oQVBGR3NtZEhjL1da?=
 =?utf-8?B?a1FKMDNNanNqdlJHTytNVnI4L2c1ZDVFamExeEhCcXVZMHY0K2Z3cTgvc0or?=
 =?utf-8?B?T2tKRmJUTCtmQW9nTzVDV2s1UUZJMDQzVHpXUzBRaXBDLzJWMFZtQ1FqQ2tm?=
 =?utf-8?B?TVlYbExZSzBOWUV4eVZWbzN2UzUvYURHVEVsRnpmbmE0V2psS0hnV3ZPRXZ1?=
 =?utf-8?Q?JqqTZi/pHMn+78Gpv3Xw+tQ=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QXVqZ1N6bjhEVzJ3WTN4YXMydkFCMlBUb2U3ak5VYmoxYnRmbThOemk3cERm?=
 =?utf-8?B?RVZpWHJ2MFVQdGVLQk12M09YSjVGL3Bhc1EvZ21OL0ZNOW1vMmEwMTJRV0Js?=
 =?utf-8?B?YVhyaVBFS1JnYktVaHdzcUZLZWFDY2d3SU5pd240WkJMRVFFcUlIaTVVYkRv?=
 =?utf-8?B?L0RlL0ZEenVRZ0psMGpRQXc1dzBwVnZFYWEwQTE0dlNXc1N0WGw1YmVUWDZB?=
 =?utf-8?B?alJDeFJodVg4NURMU3ZBS2FsMUdKQUJXZnVHZVYzMXlnc0FPNUVXcUdTK0Mz?=
 =?utf-8?B?bHo0QVMyVk1XeE9YZnBBN3hveGdXY0tSZFBGZFhvZElVcy92b3cwcEFoUisw?=
 =?utf-8?B?UWtxMmFucWFpUVVhbHRnY01UZ3RHMlNJZ0lVU0p4dTVZLzhFVEt2SG1keEhB?=
 =?utf-8?B?VytiYTUxUzBQWmR4dDNidEdBczJkNG5TNWRLYkVEenJBK2QraU9CZVdxcmYz?=
 =?utf-8?B?bDVSZzZrcXEweTczY0N4MWF6NjRhK1BqWkJMLzRhdUc5anljN1lBVHJOQjU0?=
 =?utf-8?B?Q0I2MWswTmptcm9na0NkWkJwZXhXMlloSHg0alhpRldzbDdzL0k5WWl1T01U?=
 =?utf-8?B?YXVlU1dLM2JOL25oRGhTZXZHQlROM0tlYkZ6bHA0ZUxHNUIxTHlxd0tDSDRH?=
 =?utf-8?B?emZJRnh5eFUzTWFPZlRON3JWZzN3TjZ6N2UzQmZ2c3JRRzZwVjVhZDhYZFU4?=
 =?utf-8?B?Y3N2aG5IMDR3OEUvR21PNWlJZ3BWeTYzdXBuRmhFaUFycTh3MEorZElYMzJa?=
 =?utf-8?B?VnoreGNrK3ZtRFJqbjVNQWltK1B3dDlqSzh4YnZxOExGZjVBbkxiR0oyUStD?=
 =?utf-8?B?MXFqNlVVdGhCa20zYlBmV3dWdmNyTjdNV1gzUENnS2RFYURVTTZXSUhSaytz?=
 =?utf-8?B?bEpoeFg2Sk1tbUQ1alJHOWJ0YUFqWjRRclJ0WVU1Z0tFd1V1UXA5U290SHQ2?=
 =?utf-8?B?ZTRwcnIzdzhNQ01RWjYvZ1lQQ05EbjJzMFJHYmYyeXF5K3gxNHR1RU1YYU1C?=
 =?utf-8?B?K3RUT01uTjREZHZRaUNjYmtyalE4ZCtFQ1A5MEVobDlzbXNHYjNISkhJdWQ5?=
 =?utf-8?B?QzNNWXVicnhYbGRJais1eEhWRWgxa2J2VGdiYTVkYUNyTXcwQWc5ekw5ZXRx?=
 =?utf-8?B?L0lEc1ltcjdJVklXRkJDZ056TjJqLzY3RHlaVm01RjVlWitST0hZbkh3Wllo?=
 =?utf-8?B?bEkzaC95dmo1eHpFVy9FTmwxZVE3UUN6UkRKK21RTUZQdC8xczVNeSs2V09U?=
 =?utf-8?B?YkZ4eEhWTGU1YXBzcDMwMFdTbHhvMTF4cFlpVUFLTE55TGRJeG5BUUlNbjJx?=
 =?utf-8?B?cDJ0UWV2QUtZYUw2SlBVNDZGN3hlTmdnY0VGT0ZFbTBjRlZIaGpRNUZ6YmJK?=
 =?utf-8?B?Y3lxV2w1K2xzOGx1cnFaazdIeFRwblI4Mk41QkE2UHpRNmYxajgvdUkxSXZs?=
 =?utf-8?B?clMydTJuN29zOE8xaU5adHcwYmVHaG1zSERQQ2w3Ukd0NEY5bG9FRkt0TjUy?=
 =?utf-8?B?Z0NsOEYxQjYxenZIR1pNeXhRWWxyQ3RUWEVKeWRoVk13UzVYdVo0bWZ2WW5S?=
 =?utf-8?B?cW0yUHJmTzBXUTgxVUp0b3dBOHcrckpCMlJuYWE0cW9IZVVqYmtpQXBBTEhY?=
 =?utf-8?B?VVZBZkZKdnBzVy9UK2tscHR6eHd0bzJyQUdTVGIwQ0tEWHV6QzdNeWhzSUxJ?=
 =?utf-8?B?OXBMVFd5ODVxU0U4YTE4cVZycUpkemdVcmdDK0FJRzVzRlJOVDVIS3dIMXRG?=
 =?utf-8?B?N0Z5RTJISHVFN2ZTdFNKV2NKanNLaDhFTG5sY1FKS09ZdUJSM1Awd3hiaTVJ?=
 =?utf-8?B?bWZuNVg5WHdZcmxYWHN6aEdoVW92eFF5V2R5VE84Q2pyRERYbmZRd054eDQx?=
 =?utf-8?B?MzlTWlRTK1ZmSXFjV1ZtcDE4RVhKMmxka0JITTBtbWlYWkZqNlpJSFkzT2pl?=
 =?utf-8?B?WWMzTkZKSzNBUmo4L1Z2di83WmFTemxMdmNlNmpBK0V1WWU1blhvU3M3WHQ4?=
 =?utf-8?B?VHBnZjZnVERhY1hvenB1UURZc3lxNklIVm5ZTVNyalJidzh6NEFQY3labEth?=
 =?utf-8?B?Rjh0TDV5bmczQ25jQ3VBbWJpREttUVBHbi9kMC9nd3RTcjBGZE5PbEEybnlD?=
 =?utf-8?B?QzJQUVFyQlBDRWFkcU9GczZJdVNpZVJpeFpwOHBscHdVZ2pMdW9ETTBnWC9v?=
 =?utf-8?B?UHVYLzFOMmxNVDRoak43NU04aXdwWmVXdWt3Z3BPd0FFajBIbS92ck9RQlBk?=
 =?utf-8?B?WFhxenltSnZrQVZXak5keGpGNDNDUHIwZ0hCQzkybFJBMW8yUncyS25WbUkz?=
 =?utf-8?B?ZG5DMGdJWXZKTGIySGpwNGcwNHJnVWNYVmxROUVxWisyOXRQMkY3eDlaVmFa?=
 =?utf-8?Q?Xr7+trmO49Jg30J0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FC8819D31E83D249A69F0BBA4CCB1DAC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db16003e-e4bf-44c8-f98b-08de70dc626e
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2026 00:01:37.9529
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WYaMYxxmDB3p0XfsYmo8VhM8U5gvp5tbGwEV2nmUjjTGnLZqDvQhKE4taVV/wTEn4xtWZ1/35iH4gZFXfbUaIKOyQlNm3QfTD/fK3MFpc/M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8248
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_EQ_ADDR_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71433-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[rick.p.edgecombe@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	NEURAL_HAM(-0.00)[-0.995];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 0B31116B7B5
X-Rspamd-Action: no action

T24gRnJpLCAyMDI2LTAyLTIwIGF0IDE2OjU0ICswMDAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+ID4gPiBEaWQgeW91IGNvbnNpZGVyIHRoZSBwb3RlbnRpYWwgbWlzbWF0Y2ggYmV0
d2VlbiB0aGUgR0ZOIHBhc3NlZCB0bw0KPiA+ID4gPiBrdm1fZmx1c2hfcmVtb3RlX3RsYnNfcmFu
Z2UoKSBhbmQgdGhlIFBURSdzIGZvciBkaWZmZXJlbnQgR0ZOcyB0aGF0DQo+ID4gPiA+IGFjdHVh
bGx5ID4gPiBnb3QgdG91Y2hlZC4gRm9yIGV4YW1wbGUgaW4gcmVjb3Zlcl9odWdlX3BhZ2VzX3Jh
bmdlKCksIGlmDQo+ID4gPiA+IGl0IGZsdXNoZWQgdGhlID4gPiB3cm9uZyByYW5nZSB0aGVuIHRo
ZSBwYWdlIHRhYmxlIHRoYXQgZ290IGZyZWVkIGNvdWxkDQo+ID4gPiA+IHN0aWxsIGJlIGluIHRo
ZSA+ID4gaW50ZXJtZWRpYXRlIHRyYW5zbGF0aW9uIGNhY2hlcz8NCj4gPiANCj4gPiBJIGhhZG4n
dCB0aG91Z2h0IGFib3V0IHRoaXMgYmVmb3JlIHlvdSBtZW50aW9uZWQgaXQsIGJ1dCBJIGF1ZGl0
ZWQgYWxsIGNvZGUNCj4gPiA+IHBhdGhzIGFuZCBhbGwgcGF0aHMgdGhhdCBsZWFkIHRvIGt2bV9m
bHVzaF9yZW1vdGVfdGxic19yYW5nZSgpIHVzZSBhID4NCj4gPiAic2FuaXRpemVkIiBnZm4sIGku
ZS4gS1ZNIG5ldmVyIGVtaXRzIGEgZmx1c2ggZm9yIHRoZSBnZm4gcmVwb3J0ZWQgYnkgdGhlID4N
Cj4gPiBmYXVsdC4NCg0KRG9oLCBzb3JyeS4NCg0KPiA+IMKgIFdoaWNoIG1lc2hlcyB3aXRoIGEg
bG9naWNhbCBhbmFseXNpcyBhcyB3ZWxsOiBLVk0gb25seSBuZWVkcyB0byBmbHVzaCB3aGVuDQo+
ID4gPiByZW1vdmluZy9jaGFuZ2luZyBhbiBlbnRyeSwgYW5kIHNvIHNob3VsZCBhbHdheXMgZGVy
aXZlIHRoZSB0by1iZS1mbHVzaGVkDQo+ID4gPiByYW5nZXMgdXNpbmcgdGhlIGdmbiB0aGF0IHdh
cyB1c2VkIHRvIG1ha2UgdGhlIGNoYW5nZS4NCj4gPiANCj4gPiBBbmQgdGhlICJiYWQiIGdmbiBj
YW4gbmV2ZXIgaGF2ZSBUTEIgZW50cmllcywgYmVjYXVzZSBLVk0gbmV2ZXIgY3JlYXRlcyA+DQo+
ID4gbWFwcGluZ3MuDQoNCk9oLiBJIHdhcyB1bmRlciB0aGUgaW1wcmVzc2lvbiB0aGF0IHRoZSBm
YXVsdCBnZXRzIGl0cyBHUEEgYml0cyBzdHJpcHBlZCBhbmQNCmVuZHMgdXAgbWFwcGluZyB0aGUg
cGFnZSB0YWJsZSBtYXBwaW5nIGF0IGEgd3JvbmcgZGlmZmVyZW50IEdQQS4gU28gaWYgc29tZQ0K
b3B0aW1pemVkIEdGTiB0YXJnZXRpbmcgZmx1c2ggd2FzIHBvaW50ZWQgYXQgdGhlIHVuc3RyaXBw
ZWQgR1BBIHRoZW4gaXQgY291bGQNCm1pc3MgdGhlIEdQQSB0aGF0IGFjdHVhbGx5IGdvdCBtYXBw
ZWQgYW5kIG1hZGUgaXQgaW50byB0aGUgVExCLiBBbnl3YXksIGl0IHNlZW1zDQptb290Lg0KDQo+
ID4gDQo+ID4gRldJVywgZXZlbiBpZiBLVk0gc2NyZXdlZCB1cCBzb21ldGhpbmcgbGlrZSByZWNv
dmVyX2h1Z2VfcGFnZXNfcmFuZ2UoKSwgaXQgPg0KPiA+IHdvdWxkbid0IGh1cnQgdGhlIF9ob3N0
Xy7CoCBCZWNhdXNlIGZyb20gYSBob3N0IHNhZmV0eSBwZXJzcGVjdGl2ZSwgS1ZNIHg4NiA+DQo+
ID4gb25seSBuZWVkcyB0byBnZXQgaXQgcmlnaHQgaW4gdGhyZWUgcGF0aHM6IGt2bV9mbHVzaF9z
aGFkb3dfYWxsKCksDQo+ID4gX19rdm1fZ21lbV9pbnZhbGlkYXRlX2JlZ2luKCksIGFuZA0KPiA+
IGt2bV9tbXVfbm90aWZpZXJfaW52YWxpZGF0ZV9yYW5nZV9zdGFydCgpLg0KDQoNCg==

