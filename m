Return-Path: <kvm+bounces-39050-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 62361A42F33
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 22:32:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2023816EBD4
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 21:32:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 045351E9917;
	Mon, 24 Feb 2025 21:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ye/QbUB5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54EF81D2F42;
	Mon, 24 Feb 2025 21:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740432721; cv=fail; b=htIeDJZOQOddA15uMj+9j++YJrAwtfmbVQr2TY1/tg5rjd+AOlYp5HyOMb9dCDhDSKLUVls+eJ+IpUdzayRXX02h4JjGsHFbjsNAB7yQtT8LsrUbZH9mmIz/gUjZD7POHFuSEefwn0IDgLdw9f47cxP46MKqpWhkpjBeFpk5QUM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740432721; c=relaxed/simple;
	bh=vWTuvqhWyvRZLIpxbhy4jNXh6XN+Zr92EvGPZBXw3R0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=EkcWGyXs2Om4+nCT0uM9Z78GudFJFAmcr5kYAYJE1lxiq40hZiWzbYuEZgYyvKjxFqQOtozByoIwNXUcaMXBB8Ftcm9jlfEFooX/yr3DKPasybcm8xHo1HaB9XMMR0QFvfGNvMWnmrnjDAwY9RS//ES46bQkm4b/8EkDGXjNQMY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ye/QbUB5; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740432719; x=1771968719;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=vWTuvqhWyvRZLIpxbhy4jNXh6XN+Zr92EvGPZBXw3R0=;
  b=Ye/QbUB5z1cdjWqMhu48b2MNkve6kGDlFnDau4PJnjRWiw51hF40q9Nf
   8BIiNzNOediL58WarP3KjnmVY3qgOfBtoyROMPN4cdmOdbBHmuuC3kciA
   vhEc9cnUol+Oi7O1WNAXeA7UgQyzubnkFA7Ap79RcAryb6+t/qs8360K5
   WardrXu60OHQHZ4jy9zhA6x9Xcvrxc9l5amNVxA3+kcpeSnXYZF+4sqIv
   1yFpFS6ZoE1ZJ1X8C5Rw1Nnoli1kiO84g35j+0+2d6/Mb2z7yMXBfYdp9
   TC7KG3BI0LhCAk5IhKKhLGuMyOKzsJR0SDWo21kBBMr7Dmx0L78anrYxA
   A==;
X-CSE-ConnectionGUID: 8HpfFwwnSwK+a8p9tLOlkA==
X-CSE-MsgGUID: vWAjcwJEQeuqsQZO5g8osg==
X-IronPort-AV: E=McAfee;i="6700,10204,11355"; a="45122404"
X-IronPort-AV: E=Sophos;i="6.13,312,1732608000"; 
   d="scan'208";a="45122404"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2025 13:31:58 -0800
X-CSE-ConnectionGUID: lJx+syCjSz+4qiTU1jfFWw==
X-CSE-MsgGUID: eCnalDtASFybacNSpKI3mw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,312,1732608000"; 
   d="scan'208";a="139420543"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2025 13:31:58 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Mon, 24 Feb 2025 13:31:57 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 24 Feb 2025 13:31:57 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 24 Feb 2025 13:31:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WEtVDGlgJGm9A2vOSNpv2r5qzS/6Tc7Tw7fmjWpF4uBrC47VgvXbHxcbGwozo6ON1w8Cix5+Pq09uoqSSb7KUJdG2bMxv63bsX9In3q120xab7lEzuWmCwT6tx3Fq652uBz5sJdT6IYhFL+xi2DTPXGuGPKHPdfSGNGtjX4+i9xtO2VotZTUS3wCnIswbUNyGiQj/YJs0BE5F/sO9JH6rZhM41VvIZvEm0T4pxZIed0Px8ggDKtKOXz2x3fdKIanxhUHQP6qDuQIEwzD+OiIUkoNAL6ko+4K1jbtZ1ncqo4BNBx1kNxey6BtJtU6vtCUSgwjvjKQMG5FFw/OtBs3+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vWTuvqhWyvRZLIpxbhy4jNXh6XN+Zr92EvGPZBXw3R0=;
 b=Xj0YnDdqWHI0mGSFdHHgXlkNM3xuK7qzrxk06aXmUZ3OtmibLbHOlbYEyTw90m3JChSod1AFDOiFKuqjiHKuJ4oSOLc54h8l695/P3T3H/yAbvkBHuW5xoROB7V+fEO/0s7pTmo/1c9GkwW5SvEAE4qYAA6r8uXMqqVw9C3vGym1emSIp8wO9+WrcDYVcMDUkdH/2bFIcNIhNObD5FYMYMT4LrwVaWYfeV3hTSijsK/lnV0j7PnIemLw6h9m7thHiATp0yedj0csAdT+NIY8M10tYYDMlQx8Iy6KdtBA3y3gMcqcu6l6favF7S6Pmxm4iJVfDbBQ7TIv0UFL15oGww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA3PR11MB8076.namprd11.prod.outlook.com (2603:10b6:806:2f0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Mon, 24 Feb
 2025 21:31:49 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%6]) with mapi id 15.20.8466.016; Mon, 24 Feb 2025
 21:31:49 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "seanjc@google.com" <seanjc@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Subject: Re: [PATCH 12/30] KVM: VMX: Initialize TDX during KVM module load
Thread-Topic: [PATCH 12/30] KVM: VMX: Initialize TDX during KVM module load
Thread-Index: AQHbg7nYI8GDjT3QHU6dqFONXgQRo7NQ1qIAgAX9swCAACs3AA==
Date: Mon, 24 Feb 2025 21:31:49 +0000
Message-ID: <2c26365b88b531756ea75a0951895cfcdb5c439b.camel@intel.com>
References: <20250220170604.2279312-1-pbonzini@redhat.com>
	 <20250220170604.2279312-13-pbonzini@redhat.com>
	 <64168d1d11afb399685067c6f8d57a738bb97eb6.camel@intel.com>
	 <03baa2d7-b872-4348-a166-a8cddb3033a5@redhat.com>
In-Reply-To: <03baa2d7-b872-4348-a166-a8cddb3033a5@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.3 (3.54.3-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA3PR11MB8076:EE_
x-ms-office365-filtering-correlation-id: b886726e-0afb-454b-6968-08dd551aa5ba
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?eWZncWJxeEVHV3FIRDhwSVgvTWtyRCtzNnY2MC9wTnMxS1QycG1sRmpiNkNZ?=
 =?utf-8?B?V2JFdU9YQldIMVRHSVNBRVd2YkNkdndoaldkVFhZM2p6Snk5S05vYUhkc25S?=
 =?utf-8?B?eHpXUWVZbzQvUGQzdS9lbWYxMzRoU0thd3ZtaWNVdjhZd2NxKytOck96ZmM3?=
 =?utf-8?B?YXcyRnNKRkJkTDBNMWNVV1pBY3JkSnZoMEIxK2Y0clh3c2tEMVlvRTB5L1g3?=
 =?utf-8?B?UWt0MC9OM25XK1pYdVFTRUMyZmNmcXNESy9GQnpBUzVpTjVxUWQ2OVdvYlpn?=
 =?utf-8?B?RHEwOWZtQUJzQlE0dVZlN2t0OWtmRXFmdUVFWVZxZlFBd1JXRjBtKzJ0OHYx?=
 =?utf-8?B?bjlkcytJWG5NV1ZCN3BJaTFnaVFNdWV3eVpyWEc3cEZFRkRCL1pkZzBDeTRw?=
 =?utf-8?B?Z1ppMzNVb2dBZkxVRFpjbkI1SW9pWEhvQ1VaVGRTSEVJd0diVHRCZFF3c2hS?=
 =?utf-8?B?dlQzL0lJRXRaRE13S25OU1YyMkN4S0FUbTkxV0NUd205STVFajc0U1pXQUJr?=
 =?utf-8?B?QlBsT1YzZGdMWDdVQ0NhZVdCK3ZaVVM1T1gzMEtxbk4wQkU3OVdFZlA1ZVg2?=
 =?utf-8?B?NUU0S09PWkRJVlpiVmcwQTJXNTJUMXRhZXFhVVR5VXg5UlhxTEFaMTgzWEZi?=
 =?utf-8?B?aHJvczVHK2RiOUcvNmlrWm9pOHk1dTVsVGJRcnB6WlpYWUVJUDgxdStrOEhR?=
 =?utf-8?B?YUZDak0wZnQ0U0J3OEdoNzh2c01QNnlUZHhnOFJMNzVxVjF5S0tza1NVdVN3?=
 =?utf-8?B?ZE5JK1ZCbGxSbXA0WkI5ejZSYW1nNjQrT051bVhpOXVJQzBDS245T280R0Fz?=
 =?utf-8?B?VkF0TW1MakYrVnlEcENMMEwxZ1pwRUpoODZQcnYya2IwcW5heGhacjg0Nnhy?=
 =?utf-8?B?ZGt6ODRYdWs4eGhsWDlsemJWQWd0Q01vVEN0d2NTdkNlQ092VXNrWnMyVzBV?=
 =?utf-8?B?RktEb2ptZU01bDNvNGd0US9rU3hmTTN0a1NZV2c3NXpMdVZIY0NHU3NxTERv?=
 =?utf-8?B?bFRwdGh0Y0xXYU8yRmN3aFNVakx1YXRGVmlRZDNGUnE5dDF6c1VGU1BxazhQ?=
 =?utf-8?B?MCtzODZtUGVuY1NEaDZ0WklqV3JYeG5LUGY4MFIvWW1GYUZsSzBzTnhUbHpK?=
 =?utf-8?B?T0o1RUJ3ejJnL2xLdzJ0cGhQa1VYODg1V29WUFhyd1dWUTFRQmFnY0wrUTRZ?=
 =?utf-8?B?MXZ3SC9BVUdscDhVMlFpTWRsOHZIMStseGp6dCtmcGMzQWN2SkFrZ0czK2Vw?=
 =?utf-8?B?WlZDWmxnaE5TSVpaM2hMQkkrWnVtMmtWQS9EUGxFWVd0czkzbnl3NmVTKzRn?=
 =?utf-8?B?UTF5SllLcGx6dFNZWTRFUmFxRjdwK1E3TkpUaVhKMzVCcDNwODJwb1cxR1dY?=
 =?utf-8?B?ZW5WZm1OaDNGSjA2L2NaQ2VOWHVWdG1GUVo4MzJOZThCTlliSmh3NzlpVFI5?=
 =?utf-8?B?QXd6dE9NQkJtd2c5eGR6V3dmNTJyZFlueVVTV3FtZkRiYjdpNzlTWEVueXY0?=
 =?utf-8?B?QzdQUEdqWW15dEhTdUw2TFZmdjFlTzlUaDVpRTdhbGIxS2JPSkhiOWZkYkgv?=
 =?utf-8?B?VENlZE9PQVpObDREQk9kMjRzYVd0YVhNcGlZVDZPY2FnOEJsOXA4TVZZZUhj?=
 =?utf-8?B?RUtIVE5YUGhiQm9NMXRwNnlaWnczckNyempTelQ0UmJSSUNibW11WGJtVUxM?=
 =?utf-8?B?b1BkdThkZ2lhV281L0ErTWpHUjM2c2QvU05oTEdZYWVvUmhqUjJpVllsdVF2?=
 =?utf-8?B?Rk5PdWZ1VStvUWprM0JYT2VMSml0UlI0ckU0ak8rK2pnSkFNa2MzbXJuSUoy?=
 =?utf-8?B?ZXM2Sm11V25xeXpJTXVpT3JwN0prRkhpUlZqcGFWNDNSWmxZWTBtOUY1eENK?=
 =?utf-8?B?V1AxNGtqZDloeDR5Smw4dWxieCtZUWplQngwZXdkZDIySkE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dlFIZXN2R1ZSYmJnaWFITWVlaWpkcUcrOTZmK1RUV2xXeE5ja09mL0xubmVT?=
 =?utf-8?B?SmQ3dHFSeGh6WEhZRlV4R3ZBNWNDaEJGVUpJa01FR1AzWGtmWVJ1dFRLbTRR?=
 =?utf-8?B?WE5Ba1oxaU1YemJrVHRyTjIrQW9RVW5uRExJc0szUUtIRU1KakRaNjVaZ3VI?=
 =?utf-8?B?ZGRHL2tOcXlFcEoxRjR1SHViTTBSSWxBMS9vcTcvb3RQRnZkMmowZ0RnVGRs?=
 =?utf-8?B?T0NJWTdVMjArWnFIRDc5S0Q5QXVpM2JJajJQZGhDOWFnRWZTZWh0TU1scUY4?=
 =?utf-8?B?TWV3dGhObTYzVGY2c3h0UG9EQTNHUXNvcWdzZFpWRi8wcEh5cEhhREVVaEth?=
 =?utf-8?B?YmdCS0p3QWU2cmtvTlgrYVM5T0cxWm83aGJwdFE2eTFoMzVreUEvZkc0bzJt?=
 =?utf-8?B?aUtubXlZam43T2cxZFV1T0lETkJhdjN4SzVpbWtoZjY1c1BydWFNSWhubE93?=
 =?utf-8?B?SE1lc0tnT29rVmc4WEdMWDhSVVFzVjQ3M1dsRHhtRHdSS2RmbUlmRGl3eWJY?=
 =?utf-8?B?eldUU2lDazlKK0QxS05QdzVyeDZIVFVTcG5hSXZpaVZzSUxua1RTd2JZUlkv?=
 =?utf-8?B?V2tyZktMcDEwcE1zOUFycUw3QXcrRWlFYUZ4ZTVZYVNzK2VWbWVsbXJaeDNF?=
 =?utf-8?B?c3VDUHd4NkNhZ2FnRDJTT1RDb25nY0lib0U3TDZUL2lnNXZmRHdUclVkZkth?=
 =?utf-8?B?d1UvOGcrT09xc2xmeFphTVFaek9rdjV3bGZYSXBUT0d6d2dzcEtxbHdZZ1ZZ?=
 =?utf-8?B?VUhCODVqK3BWWmltN3hkMlE0U0NFWE9KMVc2VjJuSmZRazA0bXZzTFJicWFt?=
 =?utf-8?B?dHNwZmg2TTVkM2QreUFMRDZqa1g1SUpFcmtmWEFUZjEydDhoVldUKzM4WXRF?=
 =?utf-8?B?TlJSZ2t2OTdBTlNnOW5EQkhnc05YSW1ORHZ0MDdlaDRrbWYyd3lrTUx6eWRl?=
 =?utf-8?B?RkJMcC8wcjRobzZJc1lZMjZ2OHV0YzFndXQrelN0a2NlczhiNWVuQ1lqOUxX?=
 =?utf-8?B?UnZhUitMamZxcHo0V0pFK3JZUHZnaUJjSGpRQnhIRnJHZmlMclUyU0JCalB3?=
 =?utf-8?B?ZXBVbFRlU2hkdUxaN0ZHUGhSNW84aWEvZEpSaXJIcmoxZ1BENXBCQXpJYjl4?=
 =?utf-8?B?ekU5eVdGdXQvekxiQ3hoQXRQaEgzRWovRXN4VnJSRzJXeTRHU1dERGJxVXN3?=
 =?utf-8?B?c0Rrdk1GSGUyYVpEamVzRDcvYnFWTURxTkY0SlRPTnVrdmo1N1BhV3hGaHc2?=
 =?utf-8?B?S0txNnFRSFJPc2FHanBCNm1EZWdvTUFadk0rQ2N6MCtFQUZpemVKeEV5dk1C?=
 =?utf-8?B?OEp3VXFJYmpmeXFTcy8wT3d4V3htek83bjBCZzYyT0FWVkZGbWFTb3pUWXlm?=
 =?utf-8?B?Nnc0VUhrNmJ1dHpZb2QwSDlEMVlHcDBYeGRQZ0NKdXFmdG5OT2Y0RDBxMFp6?=
 =?utf-8?B?djVTM0t5RC83NkNWQlE2VENuZHJKdzFNNU9SZTJWWXJCbTArOE9DVGhyQWhm?=
 =?utf-8?B?ZjI3UExvV1VnMGdabkNEaVBYYnRWcTNWUW9RQSs4VW4yMEhwSnJBMFpHY09K?=
 =?utf-8?B?QXcwUnRIQ0R1ZWVrdWhkSndNcWVGY29TdmZ0aFBFcmhwY3cvdnRjYUxYcTFi?=
 =?utf-8?B?ZEIyK3VtTjBNa28zZmxGU1NETHM5RnNsZnNTMURyWXhFemREaGV5REszRWti?=
 =?utf-8?B?Q3N4eVJib25OUUdsaXZ1VDBiUTZJeno3M0R5dlE3T1NRcDEzTlBxZm02L3FK?=
 =?utf-8?B?VTVHR0N4TVdHNlgvcGJQTEh0c1hjUVMzcUhuZDIveGdlQU83WnJhdkMyWjBW?=
 =?utf-8?B?cE12b1pudm5MbVprWmhVaU1FdUh1WlU1S1Y1Z0lHQ3dnaVQxZ0g2eXptT1VO?=
 =?utf-8?B?eVRQckZ1VnBsSHlIbm9WcjNKdDB1WGFyM01CTXA4blBxVG5jV2pzRjZ1MVBh?=
 =?utf-8?B?VzJXbS9hbjUwOWJOcmlub2R0ZTVWS2RwYjVzTGxmakFINEdKR2lpTzR4ZUpN?=
 =?utf-8?B?MnFlazM1aXhQTGZzc3FXVGhPZStaeUNJSUh4ek5JNVZ3eHhjSDYvc1B5a1dS?=
 =?utf-8?B?VTJNbXA4V1BKdnlLcnpnQTQ2bVQzbzBwbnhSeGVwRmtwcnZ2b2xtTGFBWmFa?=
 =?utf-8?Q?OifGh9WJrGlh6SFeWDJuT8OT5?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CC18CBBE2EC2DA49B3581851FBA02586@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b886726e-0afb-454b-6968-08dd551aa5ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2025 21:31:49.3910
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /C4pBwzEEiCQMBGjUUcqUgPVHQC5T1xEz/W/to2GymPP9UvKMqI6WtI1dy43EFdW97j0A3acAa8qKtIcW1FVHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB8076
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTAyLTI0IGF0IDE5OjU3ICswMTAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBPbiAyLzIxLzI1IDAwOjI3LCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+IEhpIFBhb2xvLA0KPiA+
IA0KPiA+IFRoaXMgcGF0Y2ggc3RpbGwgZG9lc24ndCBhZGRyZXNzIGEgYnVnIENoYW8gcG9pbnRl
ZCBvdXQsIHRoYXQgdGhlDQo+ID4gX19kb190ZHhfY2xlYW51cCgpIGNhbiBiZSBjYWxsZWQgZnJv
bSBfX2RvX3RkeF9icmluZ3VwKCkgd2l0aCBjcHVzX3JlYWRfbG9jaygpDQo+ID4gYmVpbmcgaG9s
ZCwgc28gd2UgbmVlZCB0byB1c2UgY3B1aHBfcmVtb3ZlX3N0YXRlX25vY2FsbHNfY3B1c2xvY2tl
ZCgpIGluDQo+ID4gX19kb190ZHhfY2xlYW51cCgpLg0KPiA+IA0KPiA+IEkgcG9zdGVkIGEgZGlm
ZiB0byBhZGRyZXNzIGhlcmU6DQo+ID4gDQo+ID4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGtt
bC80NmVhNzRiY2Q4ZWViZTI0MWExNDNlOTI4MGM2NWNhMzNjYjhkY2NlLmNhbWVsQGludGVsLmNv
bS9ULyNtMWU4NjMyOGU2OWIyN2U2Y2M5OTc4ZjkwZGY5MjMxNDRkNjk5YzM1MA0KPiA+IA0KPiA+
IEl0IHdvdWxkIGJlIGdyZWF0IGlmIHlvdSBjb3VsZCBzcXVhc2ggdG8gdGhlIGt2bS1jb2NvLXF1
ZXVlLiAgVGhlcmUgd2lsbCBiZSBzb21lDQo+ID4gbWlub3IgcmViYXNlIGNvbmZsaWN0IHRvIHRo
ZSByZXN0IHBhdGNoZXMsIHRob3VnaCwgc28gaWYgeW91IHdhbnQgbWUgdG8gc2VuZCBvdXQNCj4g
PiBmaXh1cCBwYXRjaChlcykgZm9yIHlvdSB0byBzcXVhc2ggcGxlYXNlIGRvIGxldCBtZSBrbm93
Lg0KPiA+IA0KPiA+IEJ0dywgdGhlIGRpZmYgYWxzbyBtb3ZlcyB0aGUgJ2VuYWJsZV92aXJ0X2F0
X2xvYWQnIGNoZWNrIHRvDQo+ID4ga3ZtX2Nhbl9zdXBwb3J0X3RkeCgpLCB3aGljaCBpc24ndCBy
ZWxhdGVkIHRvIHRoaXMgaXNzdWUuICBCZWxvdyBpcyB0aGUgZGlmZg0KPiA+IChhbHNvIGF0dGFj
aGVkKSB3L28gdGhpcyBjb2RlIGNoYW5nZSBidXQgb25seSB0byBhZGRyZXNzIHRoZSBhYm92ZSBi
dWcgaWYgeW91DQo+ID4gcHJlZmVyLg0KPiANCj4gVGhhbmssIEkgYXBwbGllZCB0aGlzIG9uZS4g
wqANCj4gDQoNClRoYW5rcyENCg0KPiBJbiBmYWN0IEkgdGhpbmsgd2UgY2FuIHJlbW92ZSANCj4g
a3ZtX2Nhbl9zdXBwb3J0X3RkeCgpIGFsdG9nZXRoZXIgYW5kIGlubGluZSBpdCBpbiB0ZHhfYnJp
bmd1cCgpLA0KPiBzaW5jZSB0aGVyZSBhcmUgb3RoZXIgY2hlY2tzIGxpa2UgTU9WRElSNjRCLg0K
DQpPciB3ZSBjYW4gcHV0IGFsbCB0aGUgcHJlLXJlcXVpcmVtZW50IGNoZWNrcyB0byBrdm1fY2Fu
X3N1cHBvcnRfdGR4KCkgLS0gYm90aA0Kd29yayBmb3IgbWUgOi0pDQoNCj4gDQo+IFRoZSBjb25m
bGljdHMgYXJlIG5vdCBwcm9ibGVtYXRpYyBzbyBJJ20gaGFwcHkgdG8gc29sdmUgdGhlbSBmb3Ig
eW91Lg0KDQpUaGFua3MgUGFvbG8hDQoNCg==

