Return-Path: <kvm+bounces-69420-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MI/zOLOOeml+7wEAu9opvQ
	(envelope-from <kvm+bounces-69420-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 23:33:23 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4244FA9935
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 23:33:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id BF9043030133
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 22:33:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DDD8343D7B;
	Wed, 28 Jan 2026 22:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nHzYjR21"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9C82857CD;
	Wed, 28 Jan 2026 22:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769639588; cv=fail; b=RIhb58CWXUrj7JaUFHUcW1KWHT7X/aj4k4wmysp6kswMZwZAT9O3dw5QBd4rkpkUWoJ7ASg1IsTgE+ZqIPsdu+7lTFgTZhf+shCfGUZqmIMXluGnB4HOHiVD4A7Vip//YJalk/kl6VScc444XcB1zkToKV3jpHq04md1xOF3KBI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769639588; c=relaxed/simple;
	bh=QLKEhhhmaHh2VJ82wtDGVBRVW15+cDdb7338c4+qRuk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ga2+TiayQC28H+5p/hj4CNmqzANouj6CNolQrZIqJfoi1KLEGm71cC6HS64eBK7cFd7kZbAb3llKcmxpGiOR+AFhL9II5uSnWJlMj55zyim3j+BMhF/55pX0W3GGiKj8Jktx+4DHAhD1R9uHHyqUsENLP6z7M6iy4x11DW3aqK8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nHzYjR21; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769639587; x=1801175587;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=QLKEhhhmaHh2VJ82wtDGVBRVW15+cDdb7338c4+qRuk=;
  b=nHzYjR21R4P8pQFi7FVmYWZB6BJzDpSEKPiCzadpUncsGuVbz47xKYcM
   rte8wNH8ZfDBKLWpMqHYjhHsOTWYKEv7HJhHAHVcje48hE5eZMhkJxwc6
   9QyP3vqV7fyMwtMBGFGW3055UxZMUq5exz+1Z2rNDGCFNww6RxP4SxX0u
   PVwd0Q3pxHD8XXQv9LfeApT5oiY4cDD442IXcrVzzjxmg2+yEj51PPzc3
   Auct4i+Fnixd0R4HUHc3vTqrj8jcX8k3zZzvvxs4jh6bLrmN73EoSHBoq
   36dXIidX6BIjRp+aw6MICk9tqdsO3n0yRRqiy3DAP0/FgFyEwkh/OcdPa
   w==;
X-CSE-ConnectionGUID: lTrY8MEiRfyD4QRwZqyzpA==
X-CSE-MsgGUID: NXi3+oXRQ1SPWa5DyBRNxA==
X-IronPort-AV: E=McAfee;i="6800,10657,11685"; a="81980148"
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="81980148"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 14:33:06 -0800
X-CSE-ConnectionGUID: I/yxpw6rS3i/GDOmWKZXAQ==
X-CSE-MsgGUID: FMARjT0LRWeTlbUZDvxgkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="207634941"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 14:33:07 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 28 Jan 2026 14:33:05 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 28 Jan 2026 14:33:05 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.23) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 28 Jan 2026 14:33:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BDru9IcKNMxOljaKDFH9EpBRKxn4M8PN2ORZE7VY7+HPJA6Uszl+mstZrc7Ote/QqRb977ypYqbHb9i/OQkEWqJ1pokjAyuWvD5ben9hKGnIV/d+FLFooJ7D78C0f0XsJQmX3X7Y9eBe3/2mX3eVumozpQJZmto5PsLAX8095yyk8KJnd2nGYdeRZOUCm53Eoq4Lyy/Ie4nM57Q81UYtvN1UTAEiosnSGDILL6hBLStkGxeIZWEiSvOOn6dN5vXWWnW7H4kLGqU5AnIoVkOdc46X+vp/OAuxPrYz+v8EPK9qpCkiQmbbA8sqv+hqzype53+FQyy+vY+biKquhiiIEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QLKEhhhmaHh2VJ82wtDGVBRVW15+cDdb7338c4+qRuk=;
 b=J9tszv2vUWc5qqeraGIQPeKHdYHUaik83W5j/935KiWCUV9MIVp8px7HmBBrxNNPLBN78sewhQR4DXSmPMOk0PdYkm4Lld7awjKeeSnhAKjxkuApU6kDOASuYm2wiNi2xez14ZWtLZSCJO/18h923cAXZmaY9/XGR6K8oc6hRlfAL1wZ9uOQdU9IikVdyF0sgl1Hmik04Rpi8wtnCTYkSbe80mOnoZ66ZYxH0urvXYK2IYcc9QweZx6vzSiUwifJc6vLRCWe4m8rcmjgNmMgxBRiW+It8DU8bXJZ00B+1KhlUT6oP4NyH/RTyNjDpZ/FTUn4d/Ndky3k8FeD4XwADA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH8PR11MB6611.namprd11.prod.outlook.com (2603:10b6:510:1ce::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.8; Wed, 28 Jan
 2026 22:33:02 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9564.007; Wed, 28 Jan 2026
 22:33:02 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Gao, Chao" <chao.gao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "kas@kernel.org"
	<kas@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"Verma, Vishal L" <vishal.l.verma@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"hpa@zytor.com" <hpa@zytor.com>, "sagis@google.com" <sagis@google.com>,
	"Chen, Farrah" <farrah.chen@intel.com>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "paulmck@kernel.org"
	<paulmck@kernel.org>, "Annapurve, Vishal" <vannapurve@google.com>,
	"yilun.xu@linux.intel.com" <yilun.xu@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v3 13/26] x86/virt/seamldr: Allocate and populate a module
 update request
Thread-Topic: [PATCH v3 13/26] x86/virt/seamldr: Allocate and populate a
 module update request
Thread-Index: AQHcjHkYth7yej19Fki+xmlQ4+sdCLVlXveAgAIaq4CAALmIgA==
Date: Wed, 28 Jan 2026 22:33:01 +0000
Message-ID: <7d9ef614838fb5b40305aae7e66003e0bb319b53.camel@intel.com>
References: <20260123145645.90444-1-chao.gao@intel.com>
	 <20260123145645.90444-14-chao.gao@intel.com>
	 <fc3e72ec4443afd79ccade31e9e0036e645e567b.camel@intel.com>
	 <aXny+UkkEzU425k6@intel.com>
In-Reply-To: <aXny+UkkEzU425k6@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH8PR11MB6611:EE_
x-ms-office365-filtering-correlation-id: c19ecbf7-3033-4bd5-ec04-08de5ebd3259
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?eWNxSnlyRWVYemRieHVWSFBTZUtsZG1raHhJdEZEL1c0UmcvaXVtbE1EN05P?=
 =?utf-8?B?OVdoM0dPdHQxU1JvdTUwbXpESW1FUlJWQnVGY2pjU1RBQ0NLUVFkekFld0lp?=
 =?utf-8?B?ZHBSQlJzSTEreXk4NmZsL3dYWnpWd0lNcmpPOGRsNC9PK1M0c0w3emZKV0dY?=
 =?utf-8?B?Qi9EZFl4eHpzN1l5ZUFWWVJBVm5ibUEyYjVuam1ubXJxMVZ4L1hhR0UzQmpP?=
 =?utf-8?B?c0NRaGphWG9HOWV2em5FSzBoNVpLUUxaUzV5N1FmU3NLeFB2dElhZkxjRi85?=
 =?utf-8?B?Ukp4Q0M0NDJqUEFxd2pmRHJwcGFpVzlKcHJVMlRJOXllRWhPRWU4TThML3FK?=
 =?utf-8?B?aFllQ2xPVGpwa1BUekd3dU9YMkZyVWpUTTA1bjFUMTRMUGc5bUNyc3ZyY3Rz?=
 =?utf-8?B?OXBJZXR0TDBIS2pXY3VISlp4M0M5N09yT1FaVWpnZ2ZqZ2Z4ZmNUaGZkMDBk?=
 =?utf-8?B?cm9wQ2pULzZ1WmNBSHFYcm0rWCtmcXl5cHpIUE50Z2xXYzA1YzBiaDNoNHlt?=
 =?utf-8?B?OFpjVXZLc3RmbXYwOUVjb1pMK1hHWlptdFMwdlJEMWI3c1NjV2RNT1lWZ0tx?=
 =?utf-8?B?OFdsaGd2MjdWRWlEQ25iakxaM3hrUlltR3RDNVBQMzFWSzZQVVAxZFZnZTZC?=
 =?utf-8?B?S2EvQlRkMVhyWGIvcUg2czdFZVI4MUl0TU50TXd6VXl4dXNaTjBWWS95QmRr?=
 =?utf-8?B?Q3N1WW0zN3J6c3BKc1pWcUQvWXlnbFF4bEhvYk0zV3FjRFloZWtObmhPbmY3?=
 =?utf-8?B?ekNRTVE4ZEZ6YjMzTnFVZG52SjQxYWw5SVhPcmhVckY1R3VWbzg5ajdXb1kw?=
 =?utf-8?B?TmhXWkxoK0JzbC9XalcwZU1zY3FaMmtCLzJZeEtKVFgweEhjK1lPYmVWRzFU?=
 =?utf-8?B?bithRFJjeE9FUDF5bHczdnpoYWJuR2RXNlVkZ1h1aHQrblVVY3RKeCsvZE9R?=
 =?utf-8?B?QlhuR0wyV2VwS1YwbTAwNnh0UmwvcFMyYXBUVjZsMkNvUHlIVlJxVG9JNm0x?=
 =?utf-8?B?U0I4WmJpZXdncFFpZzRORXhhTThMcGRyOFNOK09kcDUvYjQwOGorYnBTUm1N?=
 =?utf-8?B?VzhtV1k4WVhZaGtSVzRMUjNFUVE2dzl4NkNwL0RsNTNXSG5PaG9mUk9tVVdH?=
 =?utf-8?B?WXVLa3pPK3NqdVdXTjU5ZGs5ZEk2Z0l6MmEyK2o1S0tTQzhiQkdqa1Z0WHRD?=
 =?utf-8?B?Y2pKQzhUOFBoeHRJTjZMdGtjY29yVjVXWkRyamJJTDVneHZVNk1OR1hxWkh0?=
 =?utf-8?B?NFoyMk5oK0xUd29YQm5VWnRBZzQzdWVPQjdzQjFrbGRjRkpibWxtd0ZJRjFo?=
 =?utf-8?B?SDk4SnBmT0JNSUVsVUpFVkh6dG5DM3h3UWN2ZGFNMThrbDZheGRod0svM0lH?=
 =?utf-8?B?dlFMTVd1UjBkWVBzYVhWT3hTaDRkZkhLTE1DL0JVQnJNNk5IT3VIZVpJSVdL?=
 =?utf-8?B?ZmltQTNSYXdlT3cvZEVrTXZyVHljSFAyZnF5UXE0clFlWWk1dEllaWNMRE0v?=
 =?utf-8?B?SHZ2Tm5nZFY5eVJscWhvMnUrK1E4L2JaQWw5b1NNUk44UTd2TUhWQmxLaFgz?=
 =?utf-8?B?Q1RuU3hvNnIxTkVwOVlaOG55aTdVK2ZleFp6N2ExdFhLbXBuMXltZER6RmdK?=
 =?utf-8?B?ZkhuK1NxcnBpSlo2UUx2akpubGxjc0pZYVU4SHhoMExjVURISUZnb1BVTHk5?=
 =?utf-8?B?QlBJREFWT1dhRlpURVZFbzFQRk04cndpZ2xHOTV3OGl0a1hKQkRjZGlEQ1VU?=
 =?utf-8?B?ZnZGeU1mSHprU1Y0YXNPdHMrSTM2c2JYTVdKcjR4WGlTbCtyekRDZVhsYksx?=
 =?utf-8?B?ZGJWdXhpL3JsY3R6ekdHTFJONytSOUdsUWRLUzgwTzFUNVlSZkFnaUxZWnpm?=
 =?utf-8?B?OWJsNldsRVpQaElXN1l1ZjliVFcxTy9vdTVkY0JGU25sZHJHckMrUlhaeWNk?=
 =?utf-8?B?VzdhMi8wdjBQS282NUlDTTkvcVBhYVdkWUZHME1ycWZNazZqTUlvcFY2U2tD?=
 =?utf-8?B?UkNsNFI5ZmFXcU01UHVBeHd0ZUptditzL2s2M1VvMlM2NFJHeGlMWEFXUVJp?=
 =?utf-8?B?dnNnNkhqYk5HeGo0MkVXcFREcGtzM1EvSE04R2lPaEFMVUdzQjhoVG9lMDI1?=
 =?utf-8?B?VzBVOE9DM3NxdnJnYkFrWjZRSmFiVDUrM1paNUY5dmhZVGlWQk5hU0JBdDk1?=
 =?utf-8?Q?j5Que/Hzsl0elNavY2spXpo=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cFVVZjc1emlwbmkzQi91V0RyUXh2K0RMZDF3VCtLSTQ5M1BQWEFOY3FXZ3FQ?=
 =?utf-8?B?ZDRVTnEzQ3NiaWs3OU9NZ0VOY2gwNzBVN1RWUDNrY3ZMaEJYaGRKK2RFcCtD?=
 =?utf-8?B?cGJ4dVNVZ0E5bHNqNHF2MUpqL2dBMmVaREdIcEZZSVBtd3Z5TGxGWVVRRzQw?=
 =?utf-8?B?Vk0vRXlPaElsbXIzVzNWOHNuZzJ6WFI5TlR0MXZrZTNrSXBhOUhUWm9UYmZY?=
 =?utf-8?B?d0VzQXNwUlJnbzBKRG5IYUxrMFB1THR2dXdWYW4vZERSMHZjQjFLQXRBbFdK?=
 =?utf-8?B?VkR3ZFBQdUNhRTg4ZmdzTklLUUd2VEtWemQ2T2FQT3hvc3QrMy8wSFhBL1lG?=
 =?utf-8?B?WTM3bGdHVzJZczA3WkIxVFE4ZlNVSzBEMFdqcFRrT1JGMjJUeVhVNXFzWWEz?=
 =?utf-8?B?UU80UWpINDBMN2syeWwvVFdhS3V5ZlRiZjh3V2REblZBdzJnLzhXc2pHS3Fh?=
 =?utf-8?B?OCtWMWJ1d1BqckoyZU1tMDFBSXQ5Wld2TEZpY1RlMDE2N2dKMllZejByN29R?=
 =?utf-8?B?bFNtOVNRQUdFQWZoV2ZPVGx3MkQ1bnNIZDVDakRRdHVkdUJNRmV3a1lwS0Ja?=
 =?utf-8?B?dG1mZHZoYkgydzNKSUZlSUVwcHVWRURSb3lXNnh0REJmaWZhT1NhVlJiZWNK?=
 =?utf-8?B?aG9QZC9URjZEaVVoSHloK3dCNWcrV3pxMGxyT0dEMmZpdUdnR1JQYktnREww?=
 =?utf-8?B?aXlYMU1oVDhWVXZ5d1hSQWhQMGZHNkhyVDhVVTZyREhxemlEUUpZZWEzbGRV?=
 =?utf-8?B?QUo3aXVQRjQyWjJ6MFVML3N2ZWpjVE4zTGdMR1VWaU8vQkl5QWkyQmYxVVds?=
 =?utf-8?B?cm1JNXlsQXFacTFvYURVakxFTkN6bytYOGRCY0xEK2YxalNIOCs4Zjg1RnpU?=
 =?utf-8?B?dXFwWHBjdFFWZUQ1MTFsKzlRb2sreGgyS1FDMUhLeEZ5VHE0VzFwNi9rUlJU?=
 =?utf-8?B?ZVBOZXNORkZHUjVnQU1sYkU1SXdpNWovSnlJeWpCNzZaQVlSNmRxaFJpblBH?=
 =?utf-8?B?OG1jSTdGWGw1OWY4empQRUJuR2ZVZzZ3ODE0emM4Wi9FVmZzWjJMbFJUak42?=
 =?utf-8?B?Qkl6N1NxR0I2RkRmSHJDRlU3Wk1PSVBzS0d4NjN4YXVWQVlab3dRQlk4Vzdy?=
 =?utf-8?B?ZDV2cWFhU1QxUjZVSnpvS01QNEh3RzhSdWVkdmg2NGJLTHpXWExDSTBUZ1NG?=
 =?utf-8?B?MzJFOFZyOUw5OHZxRG1JMGNCcmpBYWl4bE40SkJyNjV1L0ppTmF5eFZhazlw?=
 =?utf-8?B?czhKeTVjYjloY29HVVBnaGlYamZTZk1HMEpBNkUxWTlybkJxK1lUdkxNZk5X?=
 =?utf-8?B?ekJZVys5UHkxR0lkZzBkNDNSc3ZEbWRodXo2Rmw3MEpZeXQwK1JjS0RQQXJq?=
 =?utf-8?B?UzJCaCsrM1lEZHBEQnlCaXNJOXNHNTBhUCtlblczczRpWmw3OC9LUFZGM1No?=
 =?utf-8?B?R0dBblZTWnQ3ZWdCc2pMS0E2bzVIQ21Ta1dSRklyaGFIZWx0SDIwdnE3VTlU?=
 =?utf-8?B?RVJlaGVxTENFNG1DdnVLN2JUUlVPdVA2Q0I2T0Qva0poOVZ3b3ZlbmlVWGYx?=
 =?utf-8?B?cmNCaERkNWJ6ZEpVUW92cFk0aWxDdmk0VHQ2UmFVbWlKK05vNHYxYzhhcGh0?=
 =?utf-8?B?WVVjdVlEWWtRc3Z2dTRnSi9DNHFqVE52UnhVUk94Ti9DdVNNb1FtcG9RYVY1?=
 =?utf-8?B?QmsvUEpMQi81M1hzb0IwSm5TNkJlOTB1bVZNbk1qbEtucHJrN3dTRVUzSXRs?=
 =?utf-8?B?T3YrVGFpTFh2c0ZiWFZyTGI3QjN5bGtRQnZocUNVcWNyU3JSTFZBSHB3c0Z4?=
 =?utf-8?B?RThSd0lUSEFBNHNuMEQvUDFkeEU0Ykw5ODBOMGVmd0dBMkJsVUg1WHlTc0NS?=
 =?utf-8?B?Sk81NzIyVUxPdFRjSFFreHpOMUFMMGdrQ1MwNWRzRU1LS1dEWkFRa1RZTit5?=
 =?utf-8?B?NDQ1Y3pVVnhwckZ0eEsyWEUzcG13clJuT0NqNnZKUURxejI5bGh3b01jSlFM?=
 =?utf-8?B?MGVoVG9zb1RSUDhMZVg3bkt1OHlIWm4rU1o1cHNqUXI2SWxhM05WZHRwSElp?=
 =?utf-8?B?R3dXMS9mSkx3K1JIcUp1UUJHYkt0ai9idHgvcDFvSnpkZGVpWDlmUERxTDJt?=
 =?utf-8?B?WGFjeU9BZjRHY1E5dkVVbUpvclBlV0UxVzFleURwb0M3UzNHaGpmMGhwWkp0?=
 =?utf-8?B?dE0xdDg3bzNiWE5TYVNxQ2V4K0xSTmZPL2l0KzRLck1WQzY4dHZZQVllQk45?=
 =?utf-8?B?Y3VJR05qbG1ia0ZKZmZpQ3RCUncvaHcxNzdZc2tSVnpGcURCZUIxbHdiNm9q?=
 =?utf-8?B?M29ObG95Zk5iWTMwL2JIVVBjdFlIcFBaUkE1Tk1TSURsMGxKajBmZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F58D1B468B41274B986805233DFC42B3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c19ecbf7-3033-4bd5-ec04-08de5ebd3259
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2026 22:33:01.9743
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fW0hRRrHJTHnPYNPvLZs4TcdAk7dphSUXdvXHhLw1FWyLWLgMWA3SmZZkOl6t1VcT3berepsJH+GEoYiJJuUnw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6611
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69420-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[24];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 4244FA9935
X-Rspamd-Action: no action

T24gV2VkLCAyMDI2LTAxLTI4IGF0IDE5OjI4ICswODAwLCBHYW8sIENoYW8gd3JvdGU6DQo+IE9u
IFR1ZSwgSmFuIDI3LCAyMDI2IGF0IDExOjIxOjA2QU0gKzA4MDAsIEh1YW5nLCBLYWkgd3JvdGU6
DQo+ID4gDQo+ID4gPiArLyoNCj4gPiA+ICsgKiBBbGxvY2F0ZSBhbmQgcG9wdWxhdGUgYSBzZWFt
bGRyX3BhcmFtcy4NCj4gPiA+ICsgKiBOb3RlIHRoYXQgYm90aCBAbW9kdWxlIGFuZCBAc2lnIHNo
b3VsZCBiZSB2bWFsbG9jJ2QgbWVtb3J5Lg0KPiA+ID4gKyAqLw0KPiA+ID4gK3N0YXRpYyBzdHJ1
Y3Qgc2VhbWxkcl9wYXJhbXMgKmFsbG9jX3NlYW1sZHJfcGFyYW1zKGNvbnN0IHZvaWQgKm1vZHVs
ZSwgdW5zaWduZWQgaW50IG1vZHVsZV9zaXplLA0KPiA+ID4gKwkJCQkJCSAgIGNvbnN0IHZvaWQg
KnNpZywgdW5zaWduZWQgaW50IHNpZ19zaXplKQ0KPiA+ID4gK3sNCj4gPiA+ICsJc3RydWN0IHNl
YW1sZHJfcGFyYW1zICpwYXJhbXM7DQo+ID4gPiArCWNvbnN0IHU4ICpwdHI7DQo+ID4gPiArCWlu
dCBpOw0KPiA+ID4gKw0KPiA+ID4gKwlCVUlMRF9CVUdfT04oc2l6ZW9mKHN0cnVjdCBzZWFtbGRy
X3BhcmFtcykgIT0gU1pfNEspOw0KPiA+ID4gKwlpZiAobW9kdWxlX3NpemUgPiBTRUFNTERSX01B
WF9OUl9NT0RVTEVfNEtCX1BBR0VTICogU1pfNEspDQo+ID4gPiArCQlyZXR1cm4gRVJSX1BUUigt
RUlOVkFMKTsNCj4gPiA+ICsNCj4gPiA+ICsJaWYgKCFJU19BTElHTkVEKG1vZHVsZV9zaXplLCBT
Wl80SykgfHwgc2lnX3NpemUgIT0gU1pfNEsgfHwNCj4gPiA+ICsJICAgICFJU19BTElHTkVEKCh1
bnNpZ25lZCBsb25nKW1vZHVsZSwgU1pfNEspIHx8DQo+ID4gPiArCSAgICAhSVNfQUxJR05FRCgo
dW5zaWduZWQgbG9uZylzaWcsIFNaXzRLKSkNCj4gPiA+ICsJCXJldHVybiBFUlJfUFRSKC1FSU5W
QUwpOw0KPiA+ID4gKw0KPiA+IA0KPiA+IEJhc2VkIG9uIHRoZSB0aGUgYmxvYiBmb3JtYXQgbGlu
ayBiZWxvdywgd2UgaGF2ZSANCj4gPiANCj4gPiBzdHJ1Y3QgdGR4X2Jsb2INCj4gPiB7DQo+ID4g
CS4uLg0KPiA+IAlfdTY0IHNpZ3N0cnVjdFsyNTZdOyAvLyAyS0Igc2lnc3RydWN0LGludGVsX3Rk
eF9tb2R1bGUuc28uc2lnc3RydWN0DQo+ID4gCV91NjQgcmVzZXJ2ZWQyWzI1Nl07IC8vIFJlc2Vy
dmVkIHNwYWNlDQo+ID4gCS4uLg0KPiA+IH0NCj4gPiANCj4gPiBTbyBpdCdzIGNsZWFyIFNJR1NU
UlVDVCBpcyBqdXN0IDJLQiBhbmQgdGhlIHNlY29uZCBoYWxmIDJLQiBpcyAicmVzZXJ2ZWQNCj4g
PiBzcGFjZSIuDQo+ID4gDQo+ID4gV2h5IGlzIHRoZSAicmVzZXJ2ZWQgc3BhY2UiIHRyZWF0ZWQg
YXMgcGFydCBvZiBTSUdTVFJVQ1QgaGVyZT8gDQo+IA0KPiBHb29kIHF1ZXN0aW9uLiBCZWNhdXNl
IHRoZSBzcGFjZSBpcyByZXNlcnZlZCBmb3Igc2lnc3RydWN0IGV4cGFuc2lvbi4NCj4gDQo+IFRo
ZSBfX2N1cnJlbnRfXyBTRUFNTERSIEFCSSBhY2NlcHRzIG9uZSA0S0IgcGFnZSwgYnV0IGFsbCBf
X2V4aXN0aW5nX18NCj4gc2lnc3RydWN0cyBhcmUgb25seSAyS0IuwqANCj4gDQoNCk9oIEkgc2Vl
Lg0KDQpJIHRoaW5rIHdlIGhhdmUgdHdvIHBlcnNwZWN0aXZlcyBoZXJlOiAxKSB3aGF0IFAtU0VB
TUxEUiBBQkkgcmVxdWlyZXMgZm9yDQptb2R1bGUgYW5kIHNpZ3N0cnVjdDsgMikgaG93IGRvZXMg
dGhlIGtlcm5lbCBnZXQgdGhlbSBhbmQgcGFzcyB0bw0KYWxsb2Nfc2VhbWxkcl9wYXJhbXMoKS4N
Cg0KSUlVQywgSSBub3cgdW5kZXJzdGFuZCBhbGxvY19zZWFtbGRyX3BhcmFtcygpIGlzIGV4cGVj
dGluZyB0aGUgJ21vZHVsZScsDQonbW9kdWxlX3NpemUnLCAnc2lnJyBhbmQgJ3NpZ19zaXplJyB0
byBtZWV0IFAtU0VBTUNBTEwncyBBQkkuDQoNClRoZW4gd291bGQgaXQgYmUgYmV0dGVyIHRvIGFk
ZCBhIGNvbW1lbnQgZm9yIHRoZSBjaGVja3Mgb2YgJ21vZHVsZScsDQonbW9kdWxlX3NpemUnLCAn
c2lnJyBhbmQgJ3NpZ19zaXplJyBpbiBhbGxvY19zZWFtbGRyX3BhcmFtcygpIChiZWxvdyBjb2Rl
KQ0KdGhhdCBpdCBpcyBQLVNFQU1DQUxMIEFCSSB0aGF0IGhhcyB0aGVzZSByZXF1aXJlbWVudD8N
Cg0KCWlmICghSVNfQUxJR05FRChtb2R1bGVfc2l6ZSwgU1pfNEspIHx8IHNpZ19zaXplICE9IFNa
XzRLIHx8DQoJICAgICFJU19BTElHTkVEKCh1bnNpZ25lZCBsb25nKW1vZHVsZSwgU1pfNEspIHx8
DQoJICAgICFJU19BTElHTkVEKCh1bnNpZ25lZCBsb25nKXNpZywgU1pfNEspKQ0KCQlyZXR1cm4g
RVJSX1BUUigtRUlOVkFMKTsNCg0KT3RoZXJ3aXNlIGl0J3MgYSBiaXQgY29uZnVzaW5nIGJlY2F1
c2UgdGhlc2UgNCBhcmd1bWVudHMgYXJlIHBhc3NlZCB0bw0KYWxsb2Nfc2VhbWxkcl9wYXJhbXMo
KSByaWdodCBmcm9tIHRoZSBsYXlvdXQgb2YgJ3N0cnVjdCB0ZHhfYmxvYicgd2hpY2ggaXMgYQ0K
InNvZnR3YXJlLW9yZ2FuaXplZCIgc3RydWN0dXJlIHdoaWNoLCB0aGVvcmV0aWNhbGx5LCBjb3Vs
ZCBoYXZlIG5vdGhpbmcgdG8NCmRvIFAtU0VBTUxEUiBBQkkuDQoNCg0KPiBzbywgdGR4X2Jsb2Ig
Y3VycmVudGx5IGRlZmluZXMgYSAyS0Igc2lnc3RydWN0IGZpZWxkDQo+IGZvbGxvd2VkIGJ5IDJL
QiBvZiByZXNlcnZlZCBzcGFjZS4gV2UgYW50aWNpcGF0ZSB0aGF0IHNpZ3N0cnVjdHMgd2lsbA0K
PiBldmVudHVhbGx5IGV4Y2VlZCA0S0IsIHNvIHdlIGFkZGVkIHJlc2VydmVkM1tOKjUxMl0gdG8g
YWNjb21tb2RhdGUgZnV0dXJlDQo+IGdyb3d0aC4NCj4gDQo+IFlvdSdyZSByaWdodC4gVGhlIGN1
cnJlbnQgdGR4X2Jsb2IgZGVmaW5pdGlvbiBkb2Vzbid0IGNsZWFybHkgaW5kaWNhdGUgdGhhdA0K
PiByZXNlcnZlZDIvMyBhcmUgYWN0dWFsbHkgcGFydCBvZiB0aGUgc2lnc3RydWN0Lg0KPiANCj4g
RG9lcyB0aGlzIHJldmlzZWQgdGR4X2Jsb2IgZGVmaW5pdGlvbiBtYWtlIHRoYXQgY2xlYXJlciBh
bmQgYmV0dGVyIGFsaWduIHdpdGgNCj4gdGhpcyBwYXRjaD/CoA0KPiANCg0KWWVzIGl0J3MgY2xl
YXJlciwgZnJvbSB0aGUgcGVyc3BlY3RpdmUgdGhhdCBob3cgaXQgbWF0Y2hlcyB5b3VyIGNvZGUg
dG8NCmNhbGN1bGF0ZSAnc2lnX3NpemUnLg0KDQo+IFRoZSBpZGVhIGlzIHRvIG1ha2UgdGR4X2Js
b2IgZ2VuZXJpYyBlbm91Z2ggdG8gY2xlYXJseSByZXByZXNlbnQ6DQo+IGEgNEtCIGhlYWRlciwg
Zm9sbG93ZWQgYnkgNEtCLWFsaWduZWQgc2lnc3RydWN0LCBmb2xsb3dlZCBieSB0aGUgVERYIE1v
ZHVsZQ0KPiBiaW5hcnkuIEN1cnJlbnQgU0VBTUxEUiBBQkkgZGV0YWlscyBvciBjdXJyZW50IHNp
Z3N0cnVjdCBzaXplcyBhcmUgaXJyZWxldmFudC4NCj4gDQo+IHN0cnVjdCB0ZHhfYmxvYg0KPiB7
DQo+ICAgICAgICAgX3UxNiB2ZXJzaW9uOyAgICAgICAgICAgICAgLy8gVmVyc2lvbiBudW1iZXIN
Cj4gICAgICAgICBfdTE2IGNoZWNrc3VtOyAgICAgICAgICAgICAvLyBDaGVja3N1bSBvZiB0aGUg
ZW50aXJlIGJsb2Igc2hvdWxkIGJlIHplcm8NCj4gICAgICAgICBfdTMyIG9mZnNldF9vZl9tb2R1
bGU7ICAgICAvLyBPZmZzZXQgb2YgdGhlIG1vZHVsZSBiaW5hcnkgaW50ZWxfdGR4X21vZHVsZS5i
aW4gaW4gYnl0ZXMNCj4gICAgICAgICBfdTggIHNpZ25hdHVyZVs4XTsgICAgICAgICAvLyBNdXN0
IGJlICJURFgtQkxPQiINCj4gICAgICAgICBfdTMyIGxlbmd0aDsgICAgICAgICAgICAgICAvLyBU
aGUgbGVuZ3RoIGluIGJ5dGVzIG9mIHRoZSBlbnRpcmUgYmxvYg0KPiAgICAgICAgIF91MzIgcmVz
ZXJ2ZWQwOyAgICAgICAgICAgIC8vIFJlc2VydmVkIHNwYWNlDQo+ICAgICAgICAgX3U2NCByZXNl
cnZlZDFbNTA5XTsgICAgICAgLy8gUmVzZXJ2ZWQgc3BhY2UNCj4gICAgICAgICBfdTY0IHNpZ3N0
cnVjdFs1MTIgKyBOKjUxMl07IC8vIHNpZ3N0cnVjdCwgNEtCIGFsaWduZWQNCj4gDQo+IAleXl5e
Xl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl5eXl4NCj4gICAg
ICAgICBfdTggIG1vZHVsZVtdOyAgICAgICAgICAgICAvLyBpbnRlbF90ZHhfbW9kdWxlLmJpbiwg
NEtCIGFsaWduZWQsIHRvIHRoZSBlbmQgb2YgdGhlIGZpbGUNCj4gfQ0KPiANCj4gDQo+ID4gDQoN
CkEgc2lkZSB0b3BpYzoNCg0KSSBjaGVja2VkIHRoZSBTRUFNTERSLklOU1RBTEwuICBJdCBhcHBl
YXJzIHRoZSBvbmx5IHJlcXVpcmVtZW50IG9mIHRoZQ0KU0lHU1RSVUNUIGlzIGl0IGlzIDRLIGFs
aWduZWQuICBUaGVyZSdzIG5vIHdoZXJlIGluIHRoZSBBQkkgKGNlcnRhaW5seSBub3QNCmluIFNF
QU1MRFJfUEFSQU1TKSB0byB0ZWxsIGhvdyBkb2VzIFNFQU1MRFIuSU5TVEFMTCB2ZXJpZmllcyB0
aGUgc2l6ZSBvZg0KU0lHU1RSVUNULg0KDQpJcyB0aGlzIHJpZ2h0Pw0KDQpXaGVuIHdlIGJ1bXBp
bmcgU0lHU1RSVUNUIHRvIGEgbGFyZ2VyIHNpemUsIGRvIHdlIGhhdmUgc29tZSBraW5kYQ0KZW51
bWVyYXRpb24gdGhhdCByZXBvcnRzIHN1Y2g/DQoNCkZyb20geW91ciBwYXRjaCAyNCwgSUlVQyBJ
IGRvbid0IHNlZSBzdWNoIGVudW1lcmF0aW9uIG9yIGV4cGxpY2l0IG9wdC1pbiwNCmJlY2F1c2Ug
eW91IGp1c3QgY2hhbmdlcyB0aGUgbGF5b3V0IG9mIFNFQU1MRFJfUEFSQU0gdy9vIGV2ZW4gY2hh
bmdpbmcgaXQncw0KdmVyc2lvbi4NCg0KWy4uLl0NCg0KPiA+IEJ1dCBJIHRoaW5rIGlmIHdlIGFk
ZCAnc2lnc3RydWN0JyB0byB0aGUgJ3N0cnVjdCB0ZHhfYmxvYicsIGUuZy4sDQo+ID4gDQo+ID4g
c3RydWN0IHRkeF9ibG9iIHsNCj4gPiAJdTE2CXZlcnNpb247DQo+ID4gCS4uLg0KPiA+IAl1NjQJ
cnN2ZDJbNTA5XTsNCj4gPiAJdTY0CXNpZ3N0cnVjdFsyNTZdOw0KPiA+IAl1NjQJcnN2ZDNbMjU2
XTsNCj4gPiAJdTY0CWRhdGE7DQo+ID4gfSBfX3BhY2tlZDsNCj4gPiANCj4gPiAuLiB3ZSBjYW4g
anVzdCB1c2UNCj4gPiANCj4gPiAJc2lnCQk9IGJsb2ItPnNpZ3N0cnVjdDsNCj4gPiAJc2lnX3Np
emUJPSAySyAob3IgNEsgSSBkb24ndCBxdWl0ZSBmb2xsb3cpOw0KPiA+IA0KPiA+IHdoaWNoIGlz
IGNsZWFyZXIgdG8gcmVhZCBJTUhPPw0KPiANCj4gVGhlIHByb2JsZW0gaXMgaGFyZC1jb2Rpbmcg
dGhlIHNpZ3N0cnVjdCBzaXplIHRvIDJLQi80S0IuIFRoaXMgd2lsbCBzb29uIG5vDQo+IGxvbmdl
ciBob2xkLg0KPiANCj4gQnV0DQo+IAlzaWcJCT0gYmxvYi0+ZGF0YTsNCj4gCXNpZ19zaXplCT0g
YmxvYi0+b2Zmc2V0X29mX21vZHVsZSAtIHNpemVvZihzdHJ1Y3QgdGR4X2Jsb2IpOw0KPiANCj4g
ZG9lc24ndCBtYWtlIHRoYXQgYXNzdW1wdGlvbiwgbWFraW5nIGl0IG1vcmUgZnV0dXJlLXByb29m
Lg0KDQpTdXJlLiAgSSBhbSBjZXJ0YWlubHkgZmluZSB3aXRoIG1ha2luZyBpdCBmdXR1cmUtcHJv
b2YgKGFsYmVpdCBhcmd1YWJseSB5b3UNCmNvdWxkIGFsc28gY2hhbmdlIHRoZSB3YXkgdGhhdCBo
b3cgc2lnX3NpemUgaXMgY2FsY3VsYXRlZCBpbiB0aGUgZnV0dXJlLA0KaS5lLiwgaW4geW91ciBw
YXRjaCAyNCkuDQoNCkJ1dCB0aGUgcmVhbCBwb2ludCBpcyB0aGUgY29kZSBoZXJlIG5lZWRzIHRv
IHJlZmxlY3QgdGhlICdzdHJ1Y3QgdGR4X2Jsb2InDQpkZXNjcmlwdGlvbiBpbiB0aGUgZG9jLiAg
QnV0IHdpdGggdGhlIGN1cnJlbnQgZG9jIEkgZG9uJ3Qgc2VlIHRoZXkgbWF0Y2ggdG8NCmVhY2gg
b3RoZXI6DQoNCiAgVGhlIGRvYyBzYXlzIFNJR1NUUlVDVCBpcyAySyBidXQgdGhlIGNvZGUgc2F5
cyBpdCdzIDRLLg0KDQpTbyBJIHRoaW5rIHlvdSBuZWVkIHRvIHVwZGF0ZSB0aGUgJ3N0cnVjdCB0
ZHhfYmxvYicgZGVzY3JpcHRpb24gaW4gdGhlIGRvYw0KdG8ganVzdGlmeSBzdWNoIGNvZGUuDQoN
CkJ0dywgSSB0aGluayB0aGUgbGluaw0KDQogIGh0dHBzOi8vZ2l0aHViLmNvbS9pbnRlbC90ZHgt
bW9kdWxlLWJpbmFyaWVzL2Jsb2IvbWFpbi9ibG9iX3N0cnVjdHVyZS50eHQNCg0KaXMgc3ViamVj
dCB0byBjaGFuZ2UsIGJvdGggdGhlIGxpbmsgaXRzZWxmIGFuZCBpdCdzIGNvbnRlbnQuDQoNCkRv
IHlvdSB0aGluayB3ZSBzaG91bGQganVzdCBtYWtlIHRoZSBsYXlvdXQgb2YgJ3N0cnVjdCB0ZHhf
YmxvYicgYXMgYQ0KZG9jdW1lbnRhdGlvbiBwYXRjaCBhbmQgaW5jbHVkZSB0aGF0IHRvIHRoaXMg
c2VyaWVzPw0K

