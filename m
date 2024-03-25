Return-Path: <kvm+bounces-12629-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 958E588B66B
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 01:57:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9369BB3B37C
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 22:34:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D4FE82D89;
	Mon, 25 Mar 2024 22:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cIMceJFm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B223141232;
	Mon, 25 Mar 2024 22:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711405928; cv=fail; b=j/2xj4jQKFJxUV8gAuMv6vwzP2uglYBHT6pv53vKTEdlVjgU52McGaxhWq/0jv9UCJaXLD7z/14obJSWKYM5KpUtnGT/HrJwbPEWq5pU2/CtDtRs8uBdw0nD9JQpoEeGffnvlh+DYghzjay27UFD2Ha/rfMs0kA3MlgHnDwfyvA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711405928; c=relaxed/simple;
	bh=Ig4dEGaXP8Hh3a0SNXVo3EqpKvRXt6Gjt/SeS02IehQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=b8l9DmUJBfw2QkBNElxklK49g86C88b789i6Hd1suKrf13LIT+p3Md4zaxVpBm6d70hjBgXFqamUgmUWUdp8OnK95LYDsPlyxLbqaVcvMHZwEL1opuMzsmVQET1GutEQ8RWzkIX9LzlxKKKiqSFcLDBn8oAoUC9rX75fJLKOA/U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cIMceJFm; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711405927; x=1742941927;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ig4dEGaXP8Hh3a0SNXVo3EqpKvRXt6Gjt/SeS02IehQ=;
  b=cIMceJFmSlLtU6cDveXdoL4TK7ch757iAupY8esMHJTgvc2v9vQQMNTP
   5MqveDRD/qRP/pTtysSuzDIXeLdTdzsosJGIdM9bNBA1QGuCBrIMwbZPy
   +pxliNCbDMbKf45owQTof2qd+JTO5CsA3fpf9/g58SEc0KMHk+/HwBJgL
   0n0+fcdqcVO1tJ/3R+TOKmggf6yBQJgZ18qQKNh4lO0QJ463KCM7IBCX5
   J5PIx5/xD7hcgKYpUU1n8jiK2V4CIfS/pv0POqPuhlPbD+YbhS+iWWWk9
   791O70xMLCFd0+eV2hsfaqQP2OrWRbAq4GK1LWC5VHfQC3udi5JCGmVkL
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11024"; a="17830359"
X-IronPort-AV: E=Sophos;i="6.07,154,1708416000"; 
   d="scan'208";a="17830359"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2024 15:32:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,154,1708416000"; 
   d="scan'208";a="20483500"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Mar 2024 15:32:03 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 25 Mar 2024 15:32:02 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 25 Mar 2024 15:32:02 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 25 Mar 2024 15:32:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oA+bQXzKLle0EnLKMeuOSGtYb/0arswQecr1BJLw9DpDRcdCY6wELzRXj/Vxy9C99XuL9VPMUxGD0MYexv01MfYbgwjGB/D7j5+PY9TDXskGj0ZH90A5NBtMIwvQMakfTOzEVB1FxCeu4Ik9OE7iE+IGgfdqtrsiWZP++/cU1ASg0B75D1pFEs5/SwOEpWNlHoGJbWFooFM4wklRczPkJZKwXvcb7JtHHVsaCZRW2WnQCMPNfImek2XIcHSZVsf9ycBvk5Q0qJja/xYQFDqOOY4aaYSwtNhWbUfgf4PlhECIA6RRMhHTCAEo2LpHPuxZUJYiR7csfuwH+po6Ra3a5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ig4dEGaXP8Hh3a0SNXVo3EqpKvRXt6Gjt/SeS02IehQ=;
 b=InjxDRbsx9XBFWfsefzDl5L4us+OKZ6pns44l82VXCicdlZjujm3pSFC9Muh77wPSSe7xD2BvoKRJ92ogHAI9UTbgF08+pL5snsy6EMxE+Amwcs1KYcZOqr5U4xJsK4DcoDrHHLUcJWgGyWcEQ9rCF0aDqaT1z0k821TdbnrOyE3e8GS0CqeOebfUTDTlPRcjzzhKWzUBWiNqFmpTvCEr9cYQiuZuaRouMC/Jr+SsjiSIJp/YB4Or79R9Yh9NM4GYcvEDW81QV/OXZM6V3jR0stfp7C6aVN5JzWk6reLBk9NrvHKJYmiWjnwtcDslpbRxEXIEJBRmPa8Ldw/LOpkHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS0PR11MB7851.namprd11.prod.outlook.com (2603:10b6:8:fb::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Mon, 25 Mar
 2024 22:31:59 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7409.028; Mon, 25 Mar 2024
 22:31:59 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Chen, Bo2"
	<chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Aktas, Erdem"
	<erdemaktas@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: RE: [PATCH v19 130/130] RFC: KVM: x86, TDX: Add check for
 KVM_SET_CPUID2
Thread-Topic: [PATCH v19 130/130] RFC: KVM: x86, TDX: Add check for
 KVM_SET_CPUID2
Thread-Index: AQHaaI3pGtqdMwRKM0+4jyn/TYFtbbFC+UEAgACFugCAAJXEAIAEZUyAgABIR4CAAHLKEA==
Date: Mon, 25 Mar 2024 22:31:59 +0000
Message-ID: <BL1PR11MB5978F5ABCD661D22A29F04DFF7362@BL1PR11MB5978.namprd11.prod.outlook.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <d394938197044b40bbe6d9ce2402f72a66a99e80.1708933498.git.isaku.yamahata@intel.com>
	 <e1eb51e258138cd145ec9a461677304cb404cc43.camel@intel.com>
	 <cfe0def93375acf0459f891cc77cb68d779bd08c.camel@intel.com>
	 <f019df484b2fb636b34f64b1126afa7d2b086c88.camel@intel.com>
	 <bea6cb485ba67f0160c6455c77cf75e5b6f8eaf8.camel@intel.com>
 <1f463eb3ae517ee8f68986ee4781a29dea3c5a89.camel@intel.com>
In-Reply-To: <1f463eb3ae517ee8f68986ee4781a29dea3c5a89.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS0PR11MB7851:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zNeoQ2lymJPj3PVE1UecDtr0VRmuYgJrYHYPerUgrvyCbnmCjmSNfYd1IUgAeYs+bM6eDAFms83r4ix2wWSATST1F/X7TU/4vfg+L963qEqAutEG0zXPk2OVAaHbDCZHJBPsDvCEsfVaJDW/r6sJjRngPNBV+hEV5H+aaNSypfk4Hho+530mRf0/P4pTeOLx7x/hOuGQG75M6eEHD+GBBgO4zkx6Rj60ZvZ1Ol83DJn2ZFoY0XmKoFnuNGsrLdJcSX/PZa/GzsRFPvAsagij85MXh42frcrZ2O4r9MzlmFiMm2KaM/j90LyV4jNgMo/xDwG4WVhBBE8bCpv+QMZe+uPVKn2PIFJl4ftZPqx3bMgsLMfcodagEzyd7nrLShknbrFY229tuiu1NAK0aYcXp7xlKIFA5mPQpPMEkHJSiqheZqifR13DJwyIVovUi5Wd/3DjYEIEUOsiJdbJcz4C9e6DFt1Ue2OOShnmEWbExsS3k9oQrktw+b8mbtgri6hcXCZ0UTYYePq4r3c4su+PJcuJyIOxCugJNjaGsbLSoevABemXFR3/OPIWANHRZjnurHaRxu+OTQis6kmOsViDTD9u1NeXfStw2m5zsEjceZTrbmeFzqEm829z8c7BZPfW5o43HhsRe+m5MIjGRQtbFTq3ygvx8BINLwla6Cpuojs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VHlENUU2T0ZSKzIwUVY2Vk1zZzN3UTNBUWpVRjJvNE1OQjFCU2dPSDlTWld5?=
 =?utf-8?B?dFA0SU5WRmZKNkZOWThHYlJ4ejRLbVJkcVJTa3pLZnVIY2xKellxRUpXVzNv?=
 =?utf-8?B?c3JEeDlMaFlERmJkYTR3VmdXTjNUemdTK29IVlFuNzNtcmpiM3VBSDN5eGRN?=
 =?utf-8?B?djFuOVpwVWJoM2RCbGpWc1VRakFNdVBpcXhacnpGcG5zOWFWWHNLRTAxZXdI?=
 =?utf-8?B?K2l4YlNXZkdsK2MvNDl6U0l3aVd5bDQxOWRiR0Q2R0x6ajdNc0lTZEZ2T21p?=
 =?utf-8?B?eEZQSlpBcWQyODJoY2dnOVdxZndUalJOUngzQ0NKSHNEeUtwWGpQN01rS2k5?=
 =?utf-8?B?dzE2WGxBeXIyMkEvYjg4bVZLQWtwTkhKT1B3S0VwOG5EZVhDdkpTMGZzWVh1?=
 =?utf-8?B?b2IzRUk1dXJ4U3dvK1VXeHZrNzU1K2w1L2RVKzkwRHg4eFpQMUhwOVRlaWJY?=
 =?utf-8?B?V0dQc3FtTVNmQUU0MlpYeHhvVE9pemJzNDJZenAvWnVPYStBNXNkUWJNWXU5?=
 =?utf-8?B?dHNzWkVTQ1c3V0RITHFhcXU2Zm81azFmMy9BOS9oWXVmVmJua0RyUVJBcERP?=
 =?utf-8?B?TUxrUTgyS1V1NTJ1RENIWUdTc3dFUEZ6SVNvRURwUWU3ZEYxbmxjc0wxNXdI?=
 =?utf-8?B?L3VmdzJjUVVmZEpEUVBJVm40N3J2Ry9OUkx5YkRoU09yY25ZRnV1WThPZThG?=
 =?utf-8?B?Vy85NW1YS1JITGZ5NVhtVDQvNksxNFlRdm1lYzRQNlJtRE5qVmppZ0JPV1VN?=
 =?utf-8?B?cVZHZlNJeHpqMVVXenBrdldLNVZxUWtoVjEyVUFYQVZQZEl2MVpVTEVlRTF6?=
 =?utf-8?B?OXFpbWtEKzdwcGtibndIekJiTDFVSXBpcmF5QXVlWlFPMys0clluUERSUE15?=
 =?utf-8?B?VC9kYzdVMWJNMW5Ldks4eFlsb0VMTW1MUXVteENCZDVQYm9qZXg2RFZyalFq?=
 =?utf-8?B?RXcwMWxBMU5OUkM4a25rcEFjK1lUM3djcTk2R1JNVWNTK2Y5eTFoSlBOZlgw?=
 =?utf-8?B?aDg1ckx2VlVwM0JWaE12L1V4Tmw5MHZLdFhhMmlrdkI1eEZML2dOMG9NT2xD?=
 =?utf-8?B?SXF5NTNIZTFzTmNaTHhTTFZTUEUreU55R2FKdmF1YnVXd3BEQWFZYlRXTmpW?=
 =?utf-8?B?TGtHUWJ6OWdxZkNTU1RYaVQzdmVJQlRPcFp4SlZFL1o1eVZ2RE53SWdiNkE3?=
 =?utf-8?B?U3JFME5kd3RhSXJiamFDbXBocURVMGUzM0JVQnFTcjIyUzM4dnFaUTkwTXJv?=
 =?utf-8?B?OC9mQ0ZlTnUwMDk2WUtCaElheVgzYnhLamxiVFNrUFViRWtrank4SzlrL1VV?=
 =?utf-8?B?THJuQTB5N3pUbXNycjZ5bVNvUjZQS2VQemtWZGUzR0V1QUJmeHdQbDBqaXlX?=
 =?utf-8?B?L2ZQUWFCeXkwWnY5Q2VxcnVPNU1iSHc5SXZ6R3l2aFFJSFFwNU9YYi9CVU9G?=
 =?utf-8?B?K1M1VDl5d05lek9ReklkWWhhaUE5eEIzMm1NQTVHV2hxOGcxRGl4em5YUXN1?=
 =?utf-8?B?d3R2V2QvcFdoQWpNcERCemNpTlV0eHdTNmJ1UytsTDdSZHZoRG9CT0RQMFVI?=
 =?utf-8?B?T3J3LzBSejlxRnI1cmdNdFlteU1KalR2U2pjREx2RmVtVmtQL2FyY3hjdjV0?=
 =?utf-8?B?a0hIZmd3NnRhTlllQVF2MzlxVDdJUnNvREwrTmtoQmtkL2VpNjBMWkxncGdw?=
 =?utf-8?B?UEZLMzdSUnVtTUdGOFoxZFRkeHJzNEEwSWFqR2RyRC9TSlVuMEFGM1F1QUhp?=
 =?utf-8?B?ejYvU1VkNk4vNGZZd1BxcFQ4WThmdEczVk1YVEhUUEtYWXRmT3E5Y2N1YUMy?=
 =?utf-8?B?cGdyNldyYmVna2ZRVkVrUVVVbVpoZ0hKQXdtaEUrMFhUUkFueXliQm9oVjJp?=
 =?utf-8?B?T24ySmp4MlNoL0xuNDN5aXlXaDZqVUt5UHBtTTJyL2U1TG9tVVVFdVFzQWxX?=
 =?utf-8?B?N1RPQUYrTmp6SjdBKzFWelpjSXRpREN1ZEFISXJIQjdzVXMySDFTVEIrMkIx?=
 =?utf-8?B?cG85YnV1ZW1taGV6YXJTSlpzNUtFYVRPYmJCU0hBV2xRdmwwNE5XbUJ5TjRM?=
 =?utf-8?B?OWRxcDZEZUphTDFyZmlibmNrWDduci9xRXJORXJjS05PcjZ6T3ArcWkvb3A4?=
 =?utf-8?Q?jlPQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01414a4d-0f39-4055-32cf-08dc4d1b627a
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2024 22:31:59.0993
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Rx0RJeazWw8m/UkCnUzbkTGW0JxxDBDGnjaCONeyl1b+hpFGOgR67zdAxyhb+VCsb1g1Cw2i/XlMgtvyJKbJ8w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7851
X-OriginatorOrg: intel.com

PiBPbiBNb24sIDIwMjQtMDMtMjUgYXQgMTE6MTQgKzAwMDAsIEh1YW5nLCBLYWkgd3JvdGU6DQo+
ID4gVG8gY29uZmlybSwgSSBtZWFuIHlvdSB3YW50IHRvIHNpbXBseSBtYWtlIEtWTV9TRVRfQ1BV
SUQyIHJldHVybiBlcnJvcg0KPiA+IGZvciBURFggZ3Vlc3Q/DQo+ID4NCj4gPiBJdCBpcyBhY2Nl
cHRhYmxlIHRvIG1lLCBhbmQgSSBkb24ndCBzZWUgYW55IGNvbmZsaWN0IHdpdGggU2VhbidzIGNv
bW1lbnRzLg0KPiA+DQo+ID4gQnV0IEkgZG9uJ3Qga25vdyBTZWFuJ3MgcGVyZmVyZW5jZS7CoCBB
cyBoZSBzYWlkLCBJIHRoaW5rwqAgdGhlDQo+ID4gY29uc2lzdGVuY3kgY2hlY2tpbmcgaXMgcXVp
dGUgc3RyYWlnaHQtZm9yd2FyZDoNCj4gPg0KPiA+ICINCj4gPiBJdCdzIG5vdCBjb21wbGljYXRl
ZCBhdCBhbGwuwqAgV2FsayB0aHJvdWdoIHRoZSBsZWFmcyBkZWZpbmVkIGR1cmluZw0KPiA+IFRE
SC5NTkcuSU5JVCwgcmVqZWN0IEtWTV9TRVRfQ1BVSUQgaWYgYSBsZWFmIGlzbid0IHByZXNlbnQg
b3IgZG9lc24ndA0KPiA+IG1hdGNoIGV4YWN0bHkuDQo+ID4gIg0KPiA+DQo+IFllYSwgSSdtIGp1
c3QgdGhpbmtpbmcgaWYgd2UgY291bGQgdGFrZSB0d28gcGF0Y2hlcyBkb3duIHRvIG9uZSBzbWFs
bCBvbmUgaXQNCj4gbWlnaHQgYmUgYSB3YXkgdG8gZXNzZW50aWFsbHkgYnJlYWsgb2ZmIHRoaXMg
d29yayB0byBhbm90aGVyIHNlcmllcyB3aXRob3V0DQo+IGFmZmVjdGluZyB0aGUgYWJpbGl0eSB0
byBib290IGEgVEQuIEl0DQo+ICpzZWVtcyogdG8gYmUgdGhlIHdheSB0aGluZ3MgYXJlIGdvaW5n
Lg0KPiANCj4gPiBTbyB0byBtZSBpdCdzIG5vdCBhIGJpZyBkZWFsLg0KPiA+DQo+ID4gRWl0aGVy
IHdheSwgd2UgbmVlZCBhIHBhdGNoIHRvIGhhbmRsZSBTRVRfQ1BVSUQyOg0KPiA+DQo+ID4gMSkg
aWYgd2UgZ28gb3B0aW9uIDEpIC0tIHRoYXQgaXMgcmVqZWN0IFNFVF9DUFVJRDIgY29tcGxldGVs
eSAtLSB3ZQ0KPiA+IG5lZWQgdG8gbWFrZSB2Y3B1J3MgQ1BVSUQgcG9pbnQgdG8gS1ZNJ3Mgc2F2
ZWQgQ1BVSUQgZHVyaW5nDQo+IFRESC5NTkcuSU5JVC4NCj4gDQo+IEFoLCBJIG1pc3NlZCB0aGlz
IHBhcnQuIENhbiB5b3UgZWxhYm9yYXRlPyBCeSBkcm9wcGluZyB0aGVzZSB0d28gcGF0Y2hlcyBp
dA0KPiBkb2Vzbid0IHByZXZlbnQgYSBURCBib290LiBJZiB3ZSB0aGVuIHJlamVjdCBTRVRfQ1BV
SUQsIHRoaXMgd2lsbCBicmVhayB0aGluZ3MNCj4gdW5sZXNzIHdlIG1ha2Ugb3RoZXIgY2hhbmdl
cz8gQW5kIHRoZXkgYXJlIG5vdCBzbWFsbD8NCj4gDQoNCihzb3JyeSByZXBseWluZyBmcm9tIG91
dGxvb2sgZHVlIHRvIHNvbWUgaXNzdWUgdG8gbXkgbGludXggYm94IGVudmlyb25tZW50KQ0KDQpJ
dCBib290ZWQgYmVjYXVzZSBRZW11IGRvZXMgc2FuZSB0aGluZywgaS5lLiwgaXQgYWx3YXlzIHBh
c3NlcyB0aGUgY29ycmVjdCBDUFVJRHMgaW4gS1ZNX1NFVF9DUFVJRDIuDQoNClBlci1TZWFuJ3Mg
Y29tbWVudHMsIEtWTSBzaG91bGQgZ3VhcmFudGVlIHRoZSBjb25zaXN0ZW5jeSBiZXR3ZWVuIENQ
VUlEcyBkb25lIGluIFRESC5NTkcuSU5JVCBhbmQgS1ZNX1NFVF9DUFVJRDIsIG90aGVyd2lzZSBp
ZiBRZW11IHBhc3NlcyBpbi1jb25zaXN0ZW50IENQVUlEcyBLVk0gY2FuIGVhc2lseSBmYWlsIHRv
IHdvcmsgd2l0aCBURC4NCg0KVG8gZ3VhcmFudGVlIHRoZSBjb25zaXN0ZW5jeSwgS1ZNIGNvdWxk
IGRvIHR3byBvcHRpb25zIGFzIHdlIGRpc2N1c3NlZDoNCg0KMSkgcmVqZWN0IEtWTV9TRVRfQ1BV
SUQyIGNvbXBsZXRlbHkuDQoyKSBTdGlsbCBhbGxvdyBLVk1fU0VUX0NQVUlEMiBidXQgbWFudWFs
bHkgY2hlY2sgdGhlIENQVUlEIGNvbnNpc3RlbmN5IGJldHdlZW4gdGhlIG9uZSBkb25lIGluIFRE
SC5NTkcuSU5JVCBhbmQgdGhlIG9uZSBwYXNzZWQgaW4gS1ZNX1NFVF9DUFVJRDIuDQoNCjEpIGNh
biBvYnZpb3VzbHkgZ3VhcmFudGVlIGNvbnNpc3RlbmN5LiAgQnV0IEtWTSBtYWludGFpbnMgQ1BV
SURzIGluICd2Y3B1Jywgc28gdG8gbWFrZSB0aGUgZXhpc3RpbmcgS1ZNIGNvZGUgY29udGludWUg
dG8gd29yaywgd2UgbmVlZCB0byBtYW51YWxseSBzZXQgJ3ZjcHUtPmNwdWlkJyB0byB0aGUgb25l
IHRoYXQgaXMgZG9uZSBpbiBUREguTU5HLklOSVQuIA0KDQoyKSB5b3UgbmVlZCB0byBjaGVjayB0
aGUgY29uc2lzdGVuY3kgYW5kIHJlamVjdCBLVk1fU0VUX0NQVUlEMiBpZiBpbi1jb25zaXN0ZW5j
eSBmb3VuZC4gIEJ1dCBvdGhlciB0aGFuIHRoYXQsIEtWTSBkb2Vzbid0IG5lZWQgdG8gYW55dGhp
bmcgbW9yZSBiZWNhdXNlIGlmIHdlIGFsbG93IEtWTV9TRVRfQ1BVSUQyLCB0aGUgJ3ZjcHUnIHdp
bGwgaGF2ZSBpdHMgb3duIENQVUlEcyBwb3B1bGF0ZWQgYW55d2F5Lg0KDQo=

