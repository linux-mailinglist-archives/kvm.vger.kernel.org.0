Return-Path: <kvm+bounces-12644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 49A5F88B891
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 04:31:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C889C1F3F4E2
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 03:31:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AA96129A79;
	Tue, 26 Mar 2024 03:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mva+dV0e"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D461D53C;
	Tue, 26 Mar 2024 03:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711423894; cv=fail; b=XwE257XTXaoMPGvSHdvseghpslVLFB5MOuQksvorkUDM3YDOiva3Ml+lRqrPeu70eRnhBkiPmsn8rfHxnVxQHP12Z58vlhK/ZAco2X2FnhuOl+SDj44uuHrznsVXAfNjUehYM2f53kQN+uEfB0MQUuuRA/RsibK6WNNHknborpg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711423894; c=relaxed/simple;
	bh=Q+bdJqM9UP4QmmUJQdtUYu5xGxDtODaI1vOxbTt191c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=a5EFIdRbTniq09hSqiV3JH4bisAF/r4fTSVP7Swo1ueYDW/VAI6alYY2m1sIp1Zxh4opCHuF8OmZMmwa6zaxyr6NgJFOk1ELWm5ZEHuXnT2aq8BBjwh8UbDhjXrlPxNswgUoW5OrwFXMXFW2o2Ccqh8Qtuie5SztdEE41tc3284=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mva+dV0e; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711423892; x=1742959892;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Q+bdJqM9UP4QmmUJQdtUYu5xGxDtODaI1vOxbTt191c=;
  b=mva+dV0esENkNxzhI9bCIWvAMQ309VQxm4DqAJhGAVGHaG93KA4VOvPm
   Gd8torX5xeEh7f1ibkZLquiRKlrfkp4uUhOBksYgg7epzMa1d6yChv3lT
   8AimLLWfs0e837IH2qigTEsKO5zsRPKVKUVeZ1fHB6EdzQ7uknN05RORN
   CnQ+Gl6UiUs8/37Ivh0hS4j4P3ZDqNmRkqdu2oBiHMfqRe5TavdaO2OyF
   0EvSSF3PNutAOLtlRG+bWgoggSAnu5rqaiicIkYR4vOaUROiw5A0OUeU6
   L5yNsAqIC3OXh4ambtDOQeCT5ixRH4ZykeurC/Bin2078DBL0yb9xUtXp
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11024"; a="6319667"
X-IronPort-AV: E=Sophos;i="6.07,155,1708416000"; 
   d="scan'208";a="6319667"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2024 20:31:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,155,1708416000"; 
   d="scan'208";a="20507744"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Mar 2024 20:31:27 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 25 Mar 2024 20:31:25 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 25 Mar 2024 20:31:25 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 25 Mar 2024 20:31:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eExpTXIGPiStIeg3NrET+GIkEix3WxDbcPSKTblvpb6LFOa6+Hk4PTetxfpRXCK9jtRs7S9Sv3BGyaJ/WSMKhzxTeBQrYa8xAlZIzp/Gp/gKL5e6nYikZaJz/T0Jfly6oqqjZ+TQx1pW5EtdFMaQOMgZegtz5jZScy0c4bXUlIoKVCKCWYWjc4tBSjfqJ0XQnGOO95zr42Iq1/0TBvbFViZzYkYSvHigdfXPkZFEqMZTKdM1BZQ0jwxY5ni0Hlkg1I+0CU9Lv2j3PN2SZ9lgVrF2vnEjJUpINCnFHjwJGr5tJDCmfwf1D1NJJfBg+//0zAPw3kk6Y4mVGvtjsgjOcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q+bdJqM9UP4QmmUJQdtUYu5xGxDtODaI1vOxbTt191c=;
 b=LoVaQWvoMiJ2Z9EqovllqwFu2o8LK2JSCfqXOEd7bvTBWxznooXVKStC1I6Gj9Re5S9Ox5k1Y3rdzF6dUreze7GObIKv2UXR3ZMlxVkkFxpMuSKhcx1os3yIQ59C8D3kNse0jrmlVnWkUla3VX5U60NRxeu5JWTrTaP7QS1cQxfyUwyLwRRZ7gqci90v52zUATorDt7cUvQtr8MJFN15jG9bqkzj6oMA9kMWO8kuUMBFLUZoua1JHcm5FW774N1HBREiieMXvh9kENH57NHJE61Rjl6yIvx2sxtsP5KPtHZJjQwhiQvkgJyKExwO4YeQxhbZaHBH291vEFp8EnEY8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MW4PR11MB7054.namprd11.prod.outlook.com (2603:10b6:303:219::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Tue, 26 Mar
 2024 03:31:05 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7409.028; Tue, 26 Mar 2024
 03:31:05 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Huang, Kai"
	<kai.huang@intel.com>, "Chen, Bo2" <chen.bo@intel.com>, "sagis@google.com"
	<sagis@google.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "sean.j.christopherson@intel.com"
	<sean.j.christopherson@intel.com>
Subject: Re: [PATCH v19 052/130] KVM: x86/mmu: Track shadow MMIO value on a
 per-VM basis
Thread-Topic: [PATCH v19 052/130] KVM: x86/mmu: Track shadow MMIO value on a
 per-VM basis
Thread-Index: AQHadnqnIsGj7SY1U0KzGQ0/V4fVmrFJbxuA
Date: Tue, 26 Mar 2024 03:31:05 +0000
Message-ID: <ccca711ccd0cb52739041580a26d4ea240760b10.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <34d7a0c8724f4fce4da50fe3028373c31213aa8a.1708933498.git.isaku.yamahata@intel.com>
In-Reply-To: <34d7a0c8724f4fce4da50fe3028373c31213aa8a.1708933498.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MW4PR11MB7054:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UMUbcK5w1F4KrC6cGGAVqn+Op3VtTBa84aarXbV3m2zP2dwmCJHP0XTqQ4vxM7cLIGFcMKgTjtwBq2dtKe60T2iW9OuKHzMwmPTsFqE4UzDW4ZkFqvYHD1gUxUATDxoAG3AlwyAqzRh2zY3h3SjfDjAD1q5nLk7gfjPMFbU0m6kOW0BuKLEqNHeQW8o+pmhI/xkyo6kz5Tf6pUpfb7N5dUMRhiRWc3NTER0QBdTFp9/z0CwR8LN/h8YPk0vLKpS03QnSKZyfDZp9iFWlvyBuNJLKOArbDAwVIf1JLGdQjC0kZFgkvvh3wqi8Iuoq1q/eZ3vL3aUy+3F7nb5LKAXFwv2KZXCtrfuW+WN+HyPG8hzuoxyPpvjo/DCk88f1pwBTQ0pVk/PRqjplDZz/C2ijKKbRNd1tPVdfUZ3RM6M1HiypFOpFCpORAD8IU/PTy+yuMIHrk7lRMdkLsXDvBMVyPDk9dWav8ZGtPOKwNXuM/88FdgP/h1na+CcWQ5qFMB15ctwTGfqu84B1HzRwa/v/BD5OV6yeE5wcVNYznLwRgR0nUWSGTnISZqxN+/jbXccywTEhYzwHfd4tpp1b6mLHsYysFVte4Qvo0Atx6aHrrdOHqv00pOz5FwBHTYO6b5i8nVZg3R2WX47VfhSG6+HHe0Jr0dhzpw/9NOv0/VsO+3g=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MTVGSlB3bk1VZ3g0SUNVbTFQcE5XbDJXMVhKTGpLY1FSbHQ4MEpzaUdkUmha?=
 =?utf-8?B?VDJPbUJuYWJZTXBSckI5cFMvUDJwWUdqbWVhV25jckxCZTFtanA4ZlVhUStr?=
 =?utf-8?B?NlZaNnRna1QzQ1JlTWhlYjB3SUlvUEQ5ckR4WGlhcmVkb3c1SWNtd1JuZm9v?=
 =?utf-8?B?S3lodjlSSm9nMG01SFFlOGE5WHRpMzZaS3hwOVBFK0pZNUNPbnZyZHBaTkJo?=
 =?utf-8?B?ZXovSDFwa2NTVFpObVcxd2c5UGppd1ZlNkRzbyt0ZXg5SlFIMy9VV2tSMmEw?=
 =?utf-8?B?N1hMUlFjc1hIazZxZVdBSExvWm5jQXQxcEZSRk04RVVrdFM3bHJHUXVnRkt6?=
 =?utf-8?B?S1R1bzFaa2pqWjl1cFkxT1IxRFk5N2tRV3ZkMDNGcGZ5bzZNNVdtaTk5aHFN?=
 =?utf-8?B?QStobFZKUE9SbUtjUGw1eGF4T0NrTDNuWldoUmM2bXdTL1J5d3l6M1dlZjZY?=
 =?utf-8?B?VEVTTEo3cHRCU0NkNnBEczZrazlBQVpieXBLbnFPTHJvVGxEd0pWYVJVb2la?=
 =?utf-8?B?bU1tc3VjNTlLWXA0K0JpVVlnekQyQ25VcEdtb29oTVFteHRaVWZXQUxRSlAr?=
 =?utf-8?B?OVNWYi9lUmFCRXZpVWVQRldSZXJZejQ3YkRONG5VT1lvYXc1N20xNlBkc1ps?=
 =?utf-8?B?T1p4d1BqcVBPdUUvSzc0NjY1cEtQRS9GSWd4b1ZqejlMMVBVRFJ3VndpZkpS?=
 =?utf-8?B?QmNKTE43K2lLNm9neE10b3NSSWpWczhHaFhsUnd4VVFxVjE5UUQ0VWl6cWt1?=
 =?utf-8?B?V1dFcDAzL3BPeENLVURSTlhXbmlNT25td2JYeUIvaUduRjRwYmNQL3Q0V3Ni?=
 =?utf-8?B?N1V2bVJBT3lVMDJVSTJFeDZYRDdCZndHOHpuNjBUTCs4dndpdHR2OHhrdUlO?=
 =?utf-8?B?U0xNSnNCVy8zU0pkTndxbGRadVdtcHVYV1VTcFVpREhhajhvSkVhdytzbnFl?=
 =?utf-8?B?ektXd2dqaU5qcHVreGQ3bzBYS2ZRLzc1M1dLb3NwRlBTS2ZuTFpwcHZvWFJS?=
 =?utf-8?B?NG1QZWt5TFN1dXVlZ3F0OWZZYnRzcWpuWERtd2MvSzg3b2lrck1hUndzdUJC?=
 =?utf-8?B?eTNZWlBMSlk0NXRNQXRxc2k1QTljZlhTRlVWdHFtMjAwTTBoTTZjTmVPaDhY?=
 =?utf-8?B?RitRT0xSSXdKZERJQWFIRkFncDZZaGpTc2RzSUd0c1p3K1c3NXFHRUlwSlBr?=
 =?utf-8?B?MHQyS3ptM0J6S0NsSHI3eGdrZ21RaWlrM2RYSng1dGRISlVvaDU1UngvK09z?=
 =?utf-8?B?OHJXV2tmVlVwNDdNQU1tZ0Q3Y08zSGtLTWliUllOTnNSUUNERWszSmFoNnRi?=
 =?utf-8?B?ZjZsclZmRHdhWDM5eXpROFIxYjdsVjFZdG9xcjMwODRveFpNZmVPVUQ0RVY2?=
 =?utf-8?B?b2FmK1h0dk5hMDFXakp1ckJCbUZ3aHZjMHlnNzN2empSVzVNb2N4WTlZY1Z3?=
 =?utf-8?B?THFLWHQ5SkVra0F1cXQzYkc5SnF5OG9SS290a2FjT3JJRnpIeksvYUdtYnhM?=
 =?utf-8?B?aTFuc2RuaG40ZlZSbkZpNVNtdmY4R05nYlgzRWhMQ2ZocytUdnBjUCt5Vlp2?=
 =?utf-8?B?Umt3N2Q1dEJRMFNnTWhpM0FMRS9jb3FKblh2RnR6Y3RQUTJ3a3JLQm9JSDFq?=
 =?utf-8?B?KzZySHZPZTVYUEdqNENEZ3NxdDk4YjJ5TW9ucnlwSm9ZUXUzWmdoY2pYRDh1?=
 =?utf-8?B?THBrVG5UWDdncW5UeUh0Sm80NXAzZStPeVRUVmpEcnRGVXhCNHZ4Q28xbFds?=
 =?utf-8?B?MlpOeHl2Wmk4RmY1dVlad2dhckNoSG93M2k5YjVYcXlPUTZ4U01TZnNSWnZ3?=
 =?utf-8?B?K3BRNUlHVWg4MHd0QWEvUjJvaGN4VzV0aStwSVU4SWJabmg5M3NxOVRaYWNW?=
 =?utf-8?B?bCt2dkdiUVYrbUZ3ckJRbjdQKzkyY3Q1SW5NWmxaZU9CQy9IVmhRSEFzdjFP?=
 =?utf-8?B?eVc5VW5jL3QrNHROT3BKekpTdWlWbDlsTFpJR2hIMVAxVnJRM2FuZ3RYOUl1?=
 =?utf-8?B?eDhVaWVtZitiNVM5Ym5MSFlSWXJjTWdCT3B1V2tHS0NRSFNlVGorUGJEVTR1?=
 =?utf-8?B?RGdvYjRBQnRvdjR3ZlZDUzcwelM3ajBRL3ZsTWlrd2hkTHNMclhFaExuaUE2?=
 =?utf-8?B?UG9mSzR3VU9Xb0llSDZiWm1kcjNxUXVRMjJ1Q21zb05sTmpTS1ZYVVN6dGwr?=
 =?utf-8?Q?snqTSeJ67H88XchcvOmvJO8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C7E7337FB9E66B4BA08F487D3C95FE4F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ddad5b9-b5ae-4d21-3dbf-08dc4d452b7b
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2024 03:31:05.7220
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KOTRddnnU2Ke6sKJBvmo/ICF/o2fEH7VnAkXL0u00IHcq4N34ZwDrOnmgNoWJDmIbvxIeHRaRxuBo1jGQFvOxVjBmx1jbUVaLD3G3Hm0WUU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7054
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTAyLTI2IGF0IDAwOjI1IC0wODAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+IEZyb206IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20+DQo+IA0KPiBURFggd2lsbCB1c2UgYSBkaWZmZXJlbnQgc2hhZG93IFBURSBlbnRyeSB2YWx1
ZSBmb3IgTU1JTyBmcm9tIFZNWC7CoCBBZGQNCj4gbWVtYmVycyB0byBrdm1fYXJjaCBhbmQgdHJh
Y2sgdmFsdWUgZm9yIE1NSU8gcGVyLVZNIGluc3RlYWQgb2YgZ2xvYmFsDQo+IHZhcmlhYmxlcy7C
oCBCeSB1c2luZyB0aGUgcGVyLVZNIEVQVCBlbnRyeSB2YWx1ZSBmb3IgTU1JTywgdGhlIGV4aXN0
aW5nIFZNWA0KPiBsb2dpYyBpcyBrZXB0IHdvcmtpbmcuwqAgSW50cm9kdWNlIGEgc2VwYXJhdGUg
c2V0dGVyIGZ1bmN0aW9uIHNvIHRoYXQgZ3Vlc3QNCj4gVEQgY2FuIG92ZXJyaWRlIGxhdGVyLg0K
PiANCj4gQWxzbyByZXF1aXJlIG1taW8gc3B0ZSBjYWNoaW5nIGZvciBURFguDQoNCg0KPiBBY3R1
YWxseSB0aGlzIGlzIHRydWUgY2FzZQ0KPiBiZWNhdXNlIFREWCByZXF1aXJlcyBFUFQgYW5kIEtW
TSBFUFQgYWxsb3dzIG1taW8gc3B0ZSBjYWNoaW5nLg0KPiANCg0KSSBjYW4ndCB1bmRlcnN0YW5k
IHdoYXQgdGhpcyBpcyB0cnlpbmcgdG8gc2F5Lg0KDQo+IMKgDQo+IMKgdm9pZCBrdm1fbW11X2lu
aXRfdm0oc3RydWN0IGt2bSAqa3ZtKQ0KPiDCoHsNCj4gKw0KPiArwqDCoMKgwqDCoMKgwqBrdm0t
PmFyY2guc2hhZG93X21taW9fdmFsdWUgPSBzaGFkb3dfbW1pb192YWx1ZTsNCg0KSXQgY291bGQg
dXNlIGt2bV9tbXVfc2V0X21taW9fc3B0ZV92YWx1ZSgpPw0KDQo+IMKgwqDCoMKgwqDCoMKgwqBJ
TklUX0xJU1RfSEVBRCgma3ZtLT5hcmNoLmFjdGl2ZV9tbXVfcGFnZXMpOw0KDQo=

