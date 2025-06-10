Return-Path: <kvm+bounces-48815-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0C90AD3FDB
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 19:03:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC7393A4F35
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 17:02:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B2EB242D9F;
	Tue, 10 Jun 2025 17:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fwSuc28H"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49A51EBA09;
	Tue, 10 Jun 2025 17:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749574974; cv=fail; b=Pw+D4YnDCiZh5ljxJyLiYi83sxefMVPw5l1Q0RlEsl2PU7ffvj0lWDcr3JdGKfTO1pIviGuIeJ3W4HA91pg+voir0p2Ws6THyVaZf1RwVYTQi4rE3o/+6ae805aSdHkdSDupWSTYRSSxqcGqJ3VLFkz4zHsKyf4Jdqy2QgMuutE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749574974; c=relaxed/simple;
	bh=PORAgnV/6zf+mNLzF/ySRglGdHWkUQi18CAjKRV1qzo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PcTYhq5D8NSiQfHcFAGu8rHR3ZGV8VcuIHPJGCf9NMD5U7WNwf1Meg5vkVeM7XCKBUaMY88iDus3EX8d07h5KFt1MJMglJxim3Mn/03QzylA7x3YYGfJw4ZwuY+K0//tkQh2a3lEF4/jMZPGa4+mmwlTgsSrWRaal9yZU6kJdjw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fwSuc28H; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749574973; x=1781110973;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=PORAgnV/6zf+mNLzF/ySRglGdHWkUQi18CAjKRV1qzo=;
  b=fwSuc28H+gdFrty3Nhvu5y5/m59bwH6NvMeYy2np72kuxdQkOs6Ljv+W
   AWMx4hCb5WM51w4JjghGCB9roNDWEqh0h/C/WLeqJ4eJRJfk6q36eNpck
   ijK4bOZ3n4/pDV0HbHCGKqh+SsM9LgCGhyfm8AhJw4sLybaYnk6pIK6YO
   EKuMBhKTzquByhBhkWL47kxKjRGq+ItczGu/pktEHe0jzSLY7Q/bZermm
   jL/CberEQl7BJAl1sR3g/Vv/oN+BbOTTbh8ICv6pn+RYAviymL4drSRc9
   7UZxamrb1BgU2XPIoxsWtckDzbqZ833loGZyqqe0AhB2GTPs/FYR4qRR9
   w==;
X-CSE-ConnectionGUID: NJdUFocESKqyRxOGHyG2tg==
X-CSE-MsgGUID: klM2z37SSCGa8GkQXX0YIw==
X-IronPort-AV: E=McAfee;i="6800,10657,11460"; a="51840383"
X-IronPort-AV: E=Sophos;i="6.16,225,1744095600"; 
   d="scan'208";a="51840383"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 10:02:42 -0700
X-CSE-ConnectionGUID: r1K3j1JJSeyl7piOLSqazw==
X-CSE-MsgGUID: sH8rBiK1SS+juFRWOeGrCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,225,1744095600"; 
   d="scan'208";a="152038271"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2025 10:02:42 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 10 Jun 2025 10:02:41 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 10 Jun 2025 10:02:41 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (40.107.95.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 10 Jun 2025 10:02:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Qzuval81WpwkpiYssQz+uXMSmylI0gqEF9u9AU3+SaXFJioCrB+0pCOq8yTuUvSEd8cXVZLO4J6qS9aMHW3ZuDudXluBKEsVSLkOmursDlQNghQA3oy7VYghpg235eCL9pm59LuxSkFHujatQFamLbLovGcgjYTICjY2fOICq93W8NmkLohMgtD1Rn73TrxN2wJ3ZwZhd61NZStTLcXOxrlzOSMHOqmocItqDgGmj/+1Bvn8y5MNGkl2IGkDl5591ExBbO6YmUcC1Emp6e7ZPZpOG62liUCHnVSbrFjLwUvmjNi3lnpOPDdB019bfrtwtTUCftQeqilwtlKoUEMkig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PORAgnV/6zf+mNLzF/ySRglGdHWkUQi18CAjKRV1qzo=;
 b=u4v3xdsiD78f5QIYqrRYTg2ikEWwSMIcIrMOALysThbbxESBBPbVCDeg45X3hClilaPKmgwkMDir3XFkBTG5/3tiMH2BGFLd02exIILZJ133vYwJI5w2jdVA00fCmJ9vKd9RRAcnIdWSS5blpWyfG7qcT7xXHyUiqHmr+Qi7tKcmLP6+LIQMfNhMLA3o6CDzSjE8ZCKQf/gnp34c/YX9/w+ubioQu23hA21eLL1prkFI+NeZulczLr3Hv9jAln/eNB2j0xfopomEnac4vGCqZ9JdLZL1dJbQfL7VEDTHDF18RjvNVOoz7+6SF5nOKc7grOPTzgBdQ9e1p2cUfgG7Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS0PR11MB7767.namprd11.prod.outlook.com (2603:10b6:8:138::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.21; Tue, 10 Jun
 2025 17:01:41 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8813.024; Tue, 10 Jun 2025
 17:01:41 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC: "mikko.ylinen@linux.intel.com" <mikko.ylinen@linux.intel.com>, "Huang,
 Kai" <kai.huang@intel.com>, "Yao, Jiewen" <jiewen.yao@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Lindgren, Tony" <tony.lindgren@intel.com>,
	"Hunter, Adrian" <adrian.hunter@intel.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "Shutemov, Kirill"
	<kirill.shutemov@intel.com>
Subject: Re: [RFC PATCH 4/4] KVM: TDX: Check KVM exit on KVM_HC_MAP_GPA_RANGE
 when TD finalize
Thread-Topic: [RFC PATCH 4/4] KVM: TDX: Check KVM exit on KVM_HC_MAP_GPA_RANGE
 when TD finalize
Thread-Index: AQHb2a1VoiRYv/QhxESaZ6OCWq/RP7P8n1AA
Date: Tue, 10 Jun 2025 17:01:41 +0000
Message-ID: <936ccea77b474fbad1bde799ee92139356f91c5f.camel@intel.com>
References: <20250610021422.1214715-1-binbin.wu@linux.intel.com>
	 <20250610021422.1214715-5-binbin.wu@linux.intel.com>
In-Reply-To: <20250610021422.1214715-5-binbin.wu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS0PR11MB7767:EE_
x-ms-office365-filtering-correlation-id: 5d43c403-9e57-40b5-f9cc-08dda840789f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?UTdydTdiaVdWdkxZY3BvMUh6Wms3YkQ2QlVybFJNYUlVZW9WU1Y0WWEzN0Qv?=
 =?utf-8?B?ODBxTDBXaHFMWHg3YnJZaUVXYnA5NUdNWUhkK1pTL29vNm1UQ1lxS0FJU2NK?=
 =?utf-8?B?REJOdEtVbjJ0dE1FSit6SW9iRUc2aTROUkhxdzBTWXV1L2tUb2E2ZlhYUU9D?=
 =?utf-8?B?czN6SjNZZTl6KzhTU0FiSHRzWFlTQ3BpemFnMHpEV0dydVdCOHdwc1BrVTFM?=
 =?utf-8?B?Tm9vUEcwbTBHdk5YZDA2ajljWXVYV08vNXhMZCs0ZHVoRk9Fd1NKRjd2a3Fm?=
 =?utf-8?B?eTFuMTNpSGtWT2RMVkpYblNabDdYQlUrakMxUUNONjdxTmkxM0ZLbXhuUExG?=
 =?utf-8?B?eDVmS2sxRUNJNEFqZEsrV2N6UU1FRjk5UmIxbXZsejVJVmhpMmxhYVlIdStP?=
 =?utf-8?B?WnBDSStZOXRXcGEwaW90NzZnZUQ4QzcrUWFGK0VpVkVGVFhBQ0tXaksvZy9Q?=
 =?utf-8?B?VGhiNktKbWZkd0dyVlQxaVQrTkkzdFh1V2Q3dkxiVkRrNjlkNkRQakQydk91?=
 =?utf-8?B?d1Q0YmJBNHRPaHdJWS9WL2swRjU0UkhzME4wNDdpMHE0UTQvV2pCUEZXNnl3?=
 =?utf-8?B?YjJTc2tmdHdxQXRmZCtiRE50d3VDemN4THFPd3RCR3BacjhPTitBcXpUU055?=
 =?utf-8?B?bGw4czQ2RWhrK3RYYW9UZk9UTlFyVjR4cG5vdXpNQ2gzVG12a1dvTU1pbHA0?=
 =?utf-8?B?ODdUcXJYQlQraTJOMHBnUktueVZvRHBkQjdoZkZzK1YvZjhQK1UwYTVpM2Z5?=
 =?utf-8?B?VU9qQ1BCRmZFNCtadDJyVVdXRWlEaDU4RlpVV0k4dzhTWDdyNU1QVWRLU0l0?=
 =?utf-8?B?cnJ0czNuOEx2bUxPMHgvMWo2SDR5Rkc0S1pEUjdCcjVtSWhuSmVXUDlrMGFr?=
 =?utf-8?B?dFZRMGZ0WG1uUmRpVFlIWlg3RzJLQy9ya0JuQ3BmbFFFeTY3L1pCVGl6eUcy?=
 =?utf-8?B?RTZrNUJCSEx1UnZMTFBEU3hVL0VUSisrdWh6elY1UlRQZWhFWVUxVnNwVjUy?=
 =?utf-8?B?V1Vzc0xBaDkwbFRhYmw1MDdGUXdtWnZaUFIzVTlBbUNBaGVZcTBRZEdhOXVF?=
 =?utf-8?B?eUJNRHdnS2Y1ZjRRWnB5WHhXWjJPK0hMTE1kWUdLbTB1OG9wbEJJUExCZHVk?=
 =?utf-8?B?LzRGV0taR3BOTlBsK3hTTitqbXgzKzVTR3VNNnhEYktablBZdjRyVEN6eWRK?=
 =?utf-8?B?UmFHdEY0dlNVeE9LTHVoTmlDTkRvUjVlL0FTaGNVaGhXWnJPTWx0VThocVRV?=
 =?utf-8?B?aFViejVkem9rR292S0ZTVVNFanlqeXF6WFd6NENjdXBIaW5BdGQxTzhGUmUx?=
 =?utf-8?B?dEFiZGFtQWVWclJ5NGEzbS9BVk9LU1l0MzRqbjEwQUNIb0FFUUhsazJZVkkw?=
 =?utf-8?B?ZytQUkFKOE5CaUhUVGp4T1JSWEZubUc5djVFd3c1enVvekMvZ3Y4eGh5b2c2?=
 =?utf-8?B?K1VySEZNRlhLRGJmK0pzZUZPZUZvSDlLSFF0WVJJbG5mUEJqUDlBaE9TSlU3?=
 =?utf-8?B?dkhBY0x6SGpzb0hrY3BodGZ5U3NaMEg0aHg0eGVzUDZsNlBhK1NVdHNyTDda?=
 =?utf-8?B?NVFRcStTNG9TNitpc0VpSWtzbDUvRWRVNm8yN3ZkSTJBdG9TWTJnblllNDF6?=
 =?utf-8?B?ODZQVWVTelRCWVVyMWVkQjYyYk42Y1FPeUVmbzJhalVobVl1ODR3T2hvbVhx?=
 =?utf-8?B?SERXS3g1MVdDMWdhL3MrRko5NW5HOGh2d2pYNmlwajNSajBrbFVlUlhuZFc4?=
 =?utf-8?B?ajZKNEhlWHo5WVhsR0pLb21kdzJNZmFYMG1yRTZOWGFmNXJrSHBRTmx2WU9Y?=
 =?utf-8?B?ejFLK1U5N3NQL3gySUxjRHJKTEh4WGk3bzRsblFmY2IzNDBDby93SU9mRmpZ?=
 =?utf-8?B?eUI2b3hUR1NFZ0lHd0RCeENTQkozQ3I5RzQwYlczZ0d2MGxyQ1ZTRXp1ZnE0?=
 =?utf-8?B?Zy8vR29xaVF3RHJLNlU1V0dJaDlBR2dZeXRjOEhvVmtQQ3NHSU5QQ2ZvelRB?=
 =?utf-8?Q?8k7ecu/I+MS+mzT/H13m1gfe3/EX3w=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WTNNVVVYT0VQeitlNG5hVEdGLy93WWpXbmFESkRiQ1JYdzBocGZwRnJ4U1Vw?=
 =?utf-8?B?c3dCc2Ewc3lId29UTmc4VW1VOWRXR1RBVEgxcmNRdjhZMFZmb01SdU1oYkFz?=
 =?utf-8?B?UTJsQkI4NGhWY3ZFMDhzcjc3R3l1Uy90cDZ3RTJDN3puSFU5cGYzaFVZYnhr?=
 =?utf-8?B?bGdSSFArQzNQUi9UVGtWTEYrL1A5R2JhRjIrY1lMY2poTHFkdmxZME5zblJq?=
 =?utf-8?B?Z05xQVBJMitlQS9oL1k0UW51NnVOUUhON3FFUWNNZ0s0UFFNOFVEd1NadDJw?=
 =?utf-8?B?VUxGTEFvZFpKYW1Pa0FVMXR6dEU1NXBuRHRQVjJZNjhKUi9Lc2xIQ0xGSzNN?=
 =?utf-8?B?cktJQW0zL1ROQ1dkSVJLZFBFY3JIb2I0SEpIZGc2Q2pPYnNMME9tYW9jcWYr?=
 =?utf-8?B?LzdjbEcyTnNZR2s2clM1blhFanRoK1hGeks5RDZXUTA0RG94UzJET1NSR2Zq?=
 =?utf-8?B?MEtodGRxWEd1bmRnaWw0UjVzZk9CU1BHNURObElmNTYvNTVMM2V1Z0Z5NHR1?=
 =?utf-8?B?VStXeEExYjg5a1g2Rm5UTzZqNXAvRmpWK0ZDVXIyOEFSV2tlWjMwcjdzK2ww?=
 =?utf-8?B?MGowVFVOSThvSXkwK2NtQ05TTzhBYUNXVVJzUGQxR20wUTJVOXozUXdiTGhP?=
 =?utf-8?B?SnRkay9MSEt4cklpcG8rWFo2cDJKeG5yZnFFcFhqUXAyTEZncXpBY2RIaUlm?=
 =?utf-8?B?TUpIZ0FWZ3hZSk9qcVdFSFM1bWxjRnhWS1IwSXBXbkUwUTNtVEt5dmwvRU9U?=
 =?utf-8?B?WlBVOHpEV0dtQVRZMG9zUXNMZlFmMmxNS1VlZFNFKzRBYzI0ZEtqM2ttWVQr?=
 =?utf-8?B?VXBlYVB2RmNEZzI0N3hzbGhQU2ErTDZrMFhPVElDeVZFbTJNL2JTYUF5QnVs?=
 =?utf-8?B?eFJ1Y2FFTFBySnZTdDBPUDgrNHl0NnFRN3BqbmxHWDlodkJzb1BIS3Frc0h2?=
 =?utf-8?B?eFM0TkFKY1dmY1g5cUFJcDB0cVVVNWdsTTBvb05oMHlIdC82cytpOG5YVjkz?=
 =?utf-8?B?eitHTFNGTFQ2WGUxd01jbnFyQVlSUE5YcGEwZndZWG9IMWNaY0ZsZEhXdXNJ?=
 =?utf-8?B?K25wMjRienFQeWpIbnpQczZQanMyY3FqN3VjdHFTUGpoaisxSXdJcTV4d0tz?=
 =?utf-8?B?VTladlY4U3dVREc1OTlqd2pld3VEVERQdEJjY1djanVkQ0xCT1A4NndndDZv?=
 =?utf-8?B?a2ZzTXhTamM1bVczZXkyR1hTU3hYdEJEL2xRNGpQRktNN1M0MmV5Q2drbndz?=
 =?utf-8?B?b3BRaHVWc2Q3Q3RBTUd5bWJsSFF5ODdwZEZKSWZWYmlqLzkxNUMrSEJrVElu?=
 =?utf-8?B?a1lWcjEzYnlsMlNrRVl6Um9Uek1SRmlheFUySkI0SnlYMTdZbUxSSWFsMk1l?=
 =?utf-8?B?RjNNVW9QNEpDMmNmUEVCMm5LSFlNbEhRazdFVElRWmpDdW1QTCsvV0RjY3V6?=
 =?utf-8?B?SElXRlh6VXcxVjRPalU4RlJPZEVzRDBhN1lNRjNxRlBUN0taRW9tRzZFSGJE?=
 =?utf-8?B?UmlFS2NIaHVDQ2hrSDQzU2NPNDg1dXNidnY2ZEtSZDNPbXpaQk1IcnBjS2RX?=
 =?utf-8?B?QjlyR2gvcGZtNWVPbzM4MzA3eXpvcGZ3YmViWlkycFhBblV2VXU4cUh5OE1y?=
 =?utf-8?B?dmJXQ01oMEcwelFXNCtNemxYNHNLSGZJcUJMd1M4YUN5MVFtWk9jMDJaZ0xi?=
 =?utf-8?B?bFpibXJzTU4yU0hES3F5dTUwYW9XVHJuTHZKaXVCdk9jRDFDajBCb200SEN5?=
 =?utf-8?B?NDBqYXFMZzRZeDVoR2dWeGhwNTl3YkZnOVlMRElJdmY5Qk5QRlhRcHowdnY3?=
 =?utf-8?B?em1zc1NWVzkraXNSSjlpVTRlZFJMcHBXRzVscW9VcXdVZ1dWVlNPY2tpZ2hM?=
 =?utf-8?B?VGFINGc4Uk5xc3RPUXRCZGN3YWVmbkc2dUZTbnB1V0hINmQvWVRRaU1CTXFv?=
 =?utf-8?B?S3U0d1hxL1FZQ3F5cDE2bjhIOGJqakthWk5UUi9zTWNHNkZkZTdoQ2MwMHB4?=
 =?utf-8?B?aExLL1hFWHFoTG41VFFnRnUyMHFWOWMzVzhoMmtNTlErNGlMVEJhTnZhZmdN?=
 =?utf-8?B?QUc2cm9xNjFCdHpqRVZWS3dkeXpLbUdnWm05YVBhbDB3N1JOdnBrdEhNNFdu?=
 =?utf-8?B?TFloQUJZT1JLREVYUFZWK0MyK0syZ2MwaS9BdlpNb2sweXBHajg5Z0drMGlS?=
 =?utf-8?B?dEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0A7DB7E31FBAA54BAFAFA9FE0FC83335@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d43c403-9e57-40b5-f9cc-08dda840789f
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2025 17:01:41.1124
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0q/eiCIVAC3b4U5c1gIKIFQKYgLCik51uytcZeu2Mp4ae2dKPbAzFGjB46D06lQg0jxuzhympsTeDscgi6lOt7zEP/PswpY8EvcfLsXn/hQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7767
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA2LTEwIGF0IDEwOjE0ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+IENo
ZWNrIHVzZXJzcGFjZSBoYXMgZW5hYmxlZCBLVk0gZXhpdCBvbiBLVk1fSENfTUFQX0dQQV9SQU5H
RSBkdXJpbmcNCj4gS1ZNX1REWF9GSU5BTElaRV9WTS4NCj4gDQo+IFREVk1DQUxMX01BUF9HUEEg
aXMgb25lIG9mIHRoZSBHSENJIGJhc2UgVERWTUNBTExzLCBzbyBpdCBtdXN0IGJlDQo+IGltcGxl
bWVudGVkIGJ5IFZNTSB0byBzdXBwb3J0IFREWCBndWVzdHMuIEtWTSBjb252ZXJ0cyBURFZNQ0FM
TF9NQVBfR1BBDQo+IHRvIEtWTV9IQ19NQVBfR1BBX1JBTkdFLCB3aGljaCByZXF1aXJlcyB1c2Vy
c3BhY2UgdG8gZW5hYmxlDQo+IEtWTV9DQVBfRVhJVF9IWVBFUkNBTEwgd2l0aCBLVk1fSENfTUFQ
X0dQQV9SQU5HRSBiaXQgc2V0LiBDaGVjayBpdCB3aGVuDQo+IHVzZXJzcGFjZSByZXF1ZXN0cyBL
Vk1fVERYX0ZJTkFMSVpFX1ZNLCBzbyB0aGF0IHRoZXJlIGlzIG5vIG5lZWQgdG8gY2hlY2sNCj4g
aXQgZHVyaW5nIFREWCBndWVzdHMgcnVubmluZy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEJpbmJp
biBXdSA8YmluYmluLnd1QGxpbnV4LmludGVsLmNvbT4NCg0KRG8gd2UgbmVlZCB0aGlzIGNoYW5n
ZT8gSXQgc2VlbXMgcmVhc29uYWJsZSwgYnV0IEkgZG9uJ3QgdGhpbmsgd2UgbmVlZCBLVk0gdG8N
CmVuc3VyZSB0aGF0IHVzZXJzcGFjZSBjcmVhdGVzIGEgVEQgdGhhdCBtZWV0cyB0aGUgR0hDSSBz
cGVjLiBTbyBJJ20gbm90IHN1cmUNCmFib3V0IHRoZSBqdXN0aWZpY2F0aW9uLg0KDQpJdCBzZWVt
cyBsaWtlIHRoZSByZWFzb25pbmcgY291bGQgYmUganVzdCB0byBzaHJpbmsgdGhlIHBvc3NpYmxl
IGNvbmZpZ3VyYXRpb25zDQpLVk0gaGFzIHRvIHRoaW5rIGFib3V0LCBhbmQgdGhhdCB3ZSBvbmx5
IGhhdmUgdGhlIG9wdGlvbiB0byBkbyB0aGlzIG5vdyBiZWZvcmUNCnRoZSBBQkkgYmVjb21lcyBo
YXJkZXIgdG8gY2hhbmdlLg0KDQpEaWQgeW91IG5lZWQgYW55IFFFTVUgY2hhbmdlcyBhcyBhIHJl
c3VsdCBvZiB0aGlzIHBhdGNoPw0KDQpXYWl0LCBhY3R1YWxseSBJIHRoaW5rIHRoZSBwYXRjaCBp
cyB3cm9uZywgYmVjYXVzZSBLVk1fQ0FQX0VYSVRfSFlQRVJDQUxMIGNvdWxkDQpiZSBjYWxsZWQg
YWdhaW4gYWZ0ZXIgS1ZNX1REWF9GSU5BTElaRV9WTS4gSW4gd2hpY2ggY2FzZSB1c2Vyc3BhY2Ug
Y291bGQgZ2V0IGFuDQpleGl0IHVuZXhwZWN0ZWRseS4gU28gc2hvdWxkIHdlIGRyb3AgdGhpcyBw
YXRjaD8NCg==

