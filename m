Return-Path: <kvm+bounces-12796-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3457E88DB98
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 11:55:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DDA372993A0
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 10:55:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37A084503B;
	Wed, 27 Mar 2024 10:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YNObtzbI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3F46125;
	Wed, 27 Mar 2024 10:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711536943; cv=fail; b=c4BI88vgvdTfdm8Y1rSvoB+JIrONv6D87Jl4TKbhEdth7UbdVZxqWCsVIjEtCl9gArcbt881QXJKDcDP1sTmIN/qunuUqM6I83jQQ64el5NXQyEoCQBYv+H1BCRaTj+i6gqU0x3iYjV22upbE1L/QqLqVapwRxbcWs2FZ3gINzk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711536943; c=relaxed/simple;
	bh=efKThFxEeV19FzUHZcAlAHI+M9UVQWCayTFfYLN8RH4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HtgIA3Sj5eai8BGNU9cVQ9EZlJkgc1UQqXX9NnQedlwLiuhXKN0+7J3HUtlRsIZwlAmK4CPAljECFQj476+0zmqSKswrrCtFndBtoI5MJA/LAQ4Qe328INXelmtBiLfCRqJvt8iPMdqJkGnyux8T4ORKWCU2hqWLBiumbMfGjhI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YNObtzbI; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711536942; x=1743072942;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=efKThFxEeV19FzUHZcAlAHI+M9UVQWCayTFfYLN8RH4=;
  b=YNObtzbItFdk7TVNGpcX6036kDBV+6HOASYhWvSuF1PXkjT/jSJenjGs
   KMKqkuujeCkHSkH4tRK8rA2KH3xF9tD+QKi9Hswxn6yM/8Ogw4XE8uOsy
   bz9i42U1WFRWObveYxgMCQ2p7JneGCKtqo7SoDJB07JFKcWrUGwhZdpCh
   NnA/TrLqJwPQEel9sJbUkHvkFZ4KaXeCREbn0xGZpQ7+7lznZpGoXl7vK
   oKgpszpEtxTv6kfP3XpuR2DPHQ+Jfo7bj+KK6+R5g1lQlIeeY/bsQBRpY
   aWzaABoFEBsOilLTwGvypsPOtnh4IJDJNl+xD3UTF6UUvkuAm/t60ClLJ
   A==;
X-CSE-ConnectionGUID: oVRDcSZZS2i+3DKue17V+w==
X-CSE-MsgGUID: 4wNCnKrTQXOqwOgJHTK1Ow==
X-IronPort-AV: E=McAfee;i="6600,9927,11025"; a="6494409"
X-IronPort-AV: E=Sophos;i="6.07,158,1708416000"; 
   d="scan'208";a="6494409"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 03:55:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,158,1708416000"; 
   d="scan'208";a="16186274"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Mar 2024 03:55:40 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 27 Mar 2024 03:55:39 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 27 Mar 2024 03:55:39 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 27 Mar 2024 03:55:39 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 27 Mar 2024 03:55:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n424KhxF0XXA4MJV0we738d7RQfrC1nW226GNz/WF2eP8iOP9hDSrPNsU9R1GMqtqvKdGkDhyMsq+q+dcSrHqiOWR8ibdj2ifS6uAqNWeXyuHEOSALgcpA/bG+Pqnc7wPLKJb/c1XIS59L7qd/WHpbmvbX6BRosN0ffBZEiqDyIMOMEDBjwptEFUV+bmuvVIKB5TW1AFv6vb9zGv83hFIypdw+AmQmkXAXKnApA/QMOjVRzHzWO5Ot8oBg4/VpPoK2UOxwiLuGOdz2X9Swa3kQOOORUcHaEY3Y8utLpDJOqWi0AVLCvPGfRgEqS3GD+bU75EYnchEmPvbjtpv25SAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=efKThFxEeV19FzUHZcAlAHI+M9UVQWCayTFfYLN8RH4=;
 b=KMpFTT8vsjX7jAuG9hxm8fekMY+Od3PaUOA5yiQ2OPmDS54VSt7zEe8MK0ZmIY6m1X9frv+mM5xu6wcq0oAMunUhSzUn3Jch7eRXTNRCY+Z7ycGry1Rwe16aOU9aW813n21kvCluVkDq8a1LhdAxkuCTiBWWERT1VZsaNXN8722jjxDz7/LRf7XKVaClbe0YphTwzl/Wg1E141rGXDmpmc/MEfrg9UfDfDGCIWiSEI6LJVeqt6MNRrcKy9pM5jM2bC83ZhEL9U5lXDnsgXOhfVSB0Sirgxm5bRaWMlTprN+FdP5rAG0qjt/QZKul2q8u4vEqsxahAB1Zv2R5r0FQ0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA0PR11MB7935.namprd11.prod.outlook.com (2603:10b6:208:40e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Wed, 27 Mar
 2024 10:55:37 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 10:55:37 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "luto@kernel.org" <luto@kernel.org>, "seanjc@google.com"
	<seanjc@google.com>, "x86@kernel.org" <x86@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "bp@alien8.de" <bp@alien8.de>,
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "Li, Xin3" <xin3.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Kang, Shan" <shan.kang@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 7/9] KVM VMX: Move MSR_IA32_VMX_MISC bit defines to
 asm/vmx.h
Thread-Topic: [PATCH v6 7/9] KVM VMX: Move MSR_IA32_VMX_MISC bit defines to
 asm/vmx.h
Thread-Index: AQHaccEVb630eNJsBUuJwJJhSRd7i7FLhxSA
Date: Wed, 27 Mar 2024 10:55:37 +0000
Message-ID: <0ad522da13631d16be259d0f43e176332d5bea48.camel@intel.com>
References: <20240309012725.1409949-1-seanjc@google.com>
	 <20240309012725.1409949-8-seanjc@google.com>
In-Reply-To: <20240309012725.1409949-8-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|IA0PR11MB7935:EE_
x-ms-office365-filtering-correlation-id: 83699927-5c76-430b-61ef-08dc4e4c6f98
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fzf3WUu90VFJ13owS0R22hn13xS9w2fs/PNP+DOtz3vmxkzRXZMy+bFH/Tob8i2T6se5MjR6femiSCKl4qHQlDaS5LxK/qfm/pPRcK7nB+8rs/CEadZWlXEeBcYq1jmrtnqbxjx4FnMXO2zu+QfhgMYqw6fvLKIDXSwl8FiHGL8CjMFllOhJeIPPCyWDARth7Ivpk95yyWXj8heMlG1T1kTNpplZQwSsTr40kG5VEgZKnb7JJrD+ZUFQPBaN+7ccJLXsExW9laD9h9zvmkaMLYDq7hmgWTG7BRlZeGrTq+np+2uA4GFCIpzAyjp/ikKPyi3mnDnHW93fZ3+CpBsMLd031Xd3tzyJcSk88lm7ymEVxovBkpnmP8JXvQldoq5DsTgYV6n6AoCQUEYapIrbSBDUHwIjp/0OTEIj+ZZVTt1yocMMgEMVWmJv7CeZNlfIkuPmbPY04Lw4ICznfRcPlTW/jUKwXX+kmeQn3tbT/p8nP0cz0SAynr9ZTkgxnK9atMCO8nSZuTi2EmCbPuFe9XwYmMH/urV/3wnC4+6fMPsQxgSVHo/7qBqmX5coMHBK1ANhzKmwW9/ePZ9lLW4zq1bwohX+HxKxQ4ewmT2WYAN0YznaO44Rka/nBS83HPekQtxzLoiyzLSMr3jDld2exW0TS+CLs3UtlDiJdK6btss+hg/gwVyr2cCqZ6UpTWN66nvZWNl+Ru9U5V7sDbZ1Zja4ZGnZQWpyt7bPsguA7Wk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(366007)(1800799015)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R0FRYmFBRExoVjI1R0JWOHZ0UlJGbVJtbDhrQmEwRGh1ekZzRFM2ZzQyNnFr?=
 =?utf-8?B?NnhCUGd4VURqTUpNTlJudjcyNUVwd0FGdjBzK042U2hlS0hLTjhJbzA3T1Jy?=
 =?utf-8?B?d1NBbE1PbWFXN2RSdUNQUjNXRzhPNGo2WDl2NExVRXBEVnd3cTByZG5OdWp2?=
 =?utf-8?B?K3NUWEI2MWNuU0hWSHNoMVJ0WUVnekI5L1VaSzBLRlBOZHdkektlbFhqRnZC?=
 =?utf-8?B?SnVXV2Z6VmRWSTRZcEpWTWxQdkFpMi9ZVWJsc1BzeVhGYlhraWNOVEhFNDZ1?=
 =?utf-8?B?WUxjajlCdEpsVFRFSGV5L1A2dWIwM3k2ZGd2bTRlZnk3cGVnY0lMeVJnNEd1?=
 =?utf-8?B?UUJuKzJ1dVlTVmgyY1oxUkVoMmZoaFpKNCs5Nm9QbW5Zblp0aWs5L0ZHdEhq?=
 =?utf-8?B?UHNmdWg1b291d25saTJZb3hybWJ3TTVpQVhuLzVYcXF3cFBrWEE4ZmU0RjdZ?=
 =?utf-8?B?VmxJSFVOeitOT0pZdzdRR1VFa2lCMlNzN1p4WFlEQTdWQnRYaVZ5VzZuZVV0?=
 =?utf-8?B?dktmSnl1YXkyRkZQU3haOThwM0pXdXFXaVdiRmZSSVpKY05TNndWL3FuTmpQ?=
 =?utf-8?B?azlkYnFITXhTS1IwbjB5emZjNncvUWZnZC93Uk9aQjVhQnJmbE9KYS8rallN?=
 =?utf-8?B?dFYyQ0grbytKNkhjc2hyKzlmOE95R01wTHNtRi9ZcmhTUndRZWlxWlRiMk1R?=
 =?utf-8?B?VXNTTHBSaTVMWVNCS0RabU50cXZscktVRUROVEY0MWVqYm1PM1RVajVpMUsw?=
 =?utf-8?B?VUhPcnlaQ0lUdldDSXNlU21Pd0I3ODV2R1ZKNmw5MXNCTkw1R0FNTnhjSkdw?=
 =?utf-8?B?VU94cnlLendvNkhoRXB4NWFhRnRMNDdrTlJmRUhVZS9vK001c3ovTnRJeXNW?=
 =?utf-8?B?aCtseDljOXBtSll4dHljWUMwbVhOOTFEbzE0OFpzcVdHeW1iNUNVb2V5QTVj?=
 =?utf-8?B?dHowY3FXc3NkakY0RHN0S3ZpTm1pTFBycjlETTM4SUhnZEZ0dXJtZWk3OUFj?=
 =?utf-8?B?TnhEY0dncUxiYVdodmg0b2N4bjdrR2t5djJSUUEySm5iV0hmaEFLdWI1YXVF?=
 =?utf-8?B?TTNmOExDb3dCVVA3ZWRMcm1hVDZEaTZwYlpKWHV1elhLNW1uWndlYjcwUjdM?=
 =?utf-8?B?SzNkblRjTW00Y0h6Sys5blZZb0ZHdHY0TFV5RE8rc3Y2RDVSeEh4NXdxZXo5?=
 =?utf-8?B?bFJuR2xZQmhKbTBMY09YN2gxbG9HNHRQQ0diRnZkRXJhNk9LTW5SNUM3L25F?=
 =?utf-8?B?MUx4Z3lrQnJEYVdTZUhwQmlzRlpEYUJyV1d5bGVxNThoU0NDUktmRnVRaTFu?=
 =?utf-8?B?eEZ4NEtvNi94RFZibG1TM1JGaHJJNVRvRS9KMG9pM25wS3hwaGZyRFd6eHRv?=
 =?utf-8?B?aHFsT3d2U1I2LzBnWkRKVHoxUTQ2NUdFbVFJbHpKaUxRTlpIVkxvc09EM1lL?=
 =?utf-8?B?ZU8yODJsMzRKS2VWR2EwUUtEb25WbHoxRCtnSlNhY1dsc2NnaXlGNUZkbVAz?=
 =?utf-8?B?UDNkdmN3eExyODlCSDBmbFNjQkNaY2xwV3RrR3VzbUsxT3phdEJIc3cyQlg3?=
 =?utf-8?B?UDczWktGTWNoK1Y0VkF0dUZJV05sSEM1RFVNTjdEL0JZUThCTWh6bndrS2Q3?=
 =?utf-8?B?emFndEh4N0hzVGVjdS9QbnJWNGo0dXo2Z2RKNHFtL1J6TGVIbitzMTFKZU85?=
 =?utf-8?B?K1V1NllsaHNGdm03L0xQY1B2RXlZMk1wSXlHbEhteU1BTmNrWTUrT1hUZFZs?=
 =?utf-8?B?dGQ0UjBKNndLc3ZGeStxNG93YnZiNWdhYmhKNkV4MnBWTXlkU0h4d253OENs?=
 =?utf-8?B?dHo0TFlYNGZsamZwazhwQVpsTS9JSldjTlUvQi9GbUJBbzNScE14bGZMT3ZL?=
 =?utf-8?B?N29Vb29BKzN3RS90TUl3SFB5UDQvMkoyTGZ3aTZxZ2oxR2daY3dZL0xKZFR3?=
 =?utf-8?B?dEZKZGZZeWkzQ3ErVC9ObmpzNXVVaThneUY4RGgyRE1jMzdSZEZrZVhQdkY3?=
 =?utf-8?B?UmFGLzFKclFIY1dWVXVhWDFDWTVNVHQrZlcydUlIaFNSMUVkVHJKcE54Mmp0?=
 =?utf-8?B?YlhWd1lncWIvVU5ucUp3RnRibzkwd3NNWENHUGJwT2s4VFRYRnVGM2xTU0d3?=
 =?utf-8?B?VnQyd0NneXVOb0JNYW1LQ25QSjhGQ3lJSHZrZFJkeGN4bkVTckVXN2lJalZF?=
 =?utf-8?B?WkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5F55830D770A654BA5F4C01435B378E8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83699927-5c76-430b-61ef-08dc4e4c6f98
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2024 10:55:37.5989
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: duIf0UggCczDDePtUvVq/EC8reYwpEnjVSDBnqQ82Frv/WhzpxIQ8l+TtlYuhW5MaaU/nKH1+ro9KYHQCi7z+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7935
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTAzLTA4IGF0IDE3OjI3IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBNb3ZlIHRoZSBoYW5kZnVsIG9mIE1TUl9JQTMyX1ZNWF9NSVNDIGJpdCBkZWZpbmVz
IHRoYXQgYXJlIGN1cnJlbnRseSBpbg0KPiBtc3ItaW5keC5oIHRvIHZteC5oIHNvIHRoYXQgYWxs
IG9mIHRoZSBWTVhfTUlTQyBkZWZpbmVzIGFuZCB3cmFwcGVycyBjYW4NCj4gYmUgZm91bmQgaW4g
YSBzaW5nbGUgbG9jYXRpb24uDQo+IA0KPiBPcHBvcnR1bmlzdGljYWxseSB1c2UgQklUX1VMTCgp
IGluc3RlYWQgb2Ygb3BlbiBjb2RpbmcgaGV4IHZhbHVlcywgYWRkDQo+IGRlZmluZXMgZm9yIGZl
YXR1cmUgYml0cyB0aGF0IGFyZSBhcmNoaXRlY3R1cmFsIGRlZmluZWQsIGFuZCBtb3ZlIHRoZQ0K
PiBkZWZpbmVzIGRvd24gaW4gdGhlIGZpbGUgc28gdGhhdCB0aGV5IGFyZSBjb2xvY2F0ZWQgd2l0
aCB0aGUgaGVscGVycyBmb3INCj4gZ2V0dGluZyBmaWVsZHMgZnJvbSBWTVhfTUlTQy4NCj4gDQo+
IE5vIGZ1bmN0aW9uYWwgY2hhbmdlIGludGVuZGVkLg0KPiANCj4gQ2M6IFNoYW4gS2FuZyA8c2hh
bi5rYW5nQGludGVsLmNvbT4NCj4gQ2M6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4N
Cj4gU2lnbmVkLW9mZi1ieTogWGluIExpIDx4aW4zLmxpQGludGVsLmNvbT4NCj4gW3NlYW46IHNw
bGl0IHRvIHNlcGFyYXRlIHBhdGNoLCB3cml0ZSBjaGFuZ2Vsb2ddDQo+IFNpZ25lZC1vZmYtYnk6
IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0KPiANCg0KUmV2aWV3ZWQt
Ynk6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCg==

