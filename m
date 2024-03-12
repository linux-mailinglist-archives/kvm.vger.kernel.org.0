Return-Path: <kvm+bounces-11645-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D4F6878F11
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 08:31:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EDCCC1F225C3
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 07:31:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 368AB69965;
	Tue, 12 Mar 2024 07:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AngP16cd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117715788F;
	Tue, 12 Mar 2024 07:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710228664; cv=fail; b=h0RyK+LRkPMqgUbCIfa0W2Sqd2SA/MGH8oPjH9MXz9/01qW7Ikysk2AHaUMQSd86piALSUV2iGRxtdl82SKoUn3D064NVCGVjaE7XYDBPvcMCLbfIeg9azX78bkeHP6tem7NIkNWcKg/NHFsP7p2uWSxiimomG3SW4gHP8c9PAA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710228664; c=relaxed/simple;
	bh=rqDCORJ8YISxqDgWfFTOE6hQP5C3Img1RPNDoATtc3c=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GNgrJHy7AK9dyr2/kzyWPBb+tsFKBJxJxT+/i6bUSEoyHkL3pE6HQf84dZdCslxa5y2t+36wApKd8Ac0i9rkVWMIVV9pF/k6mySqeK9nKcJIB6RdTRezWr6Dg3MoVDHuXrOyq/NmVAVuCcRVyL3zdV2aqxGqqoiSi4aCrx0f6i0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AngP16cd; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710228662; x=1741764662;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rqDCORJ8YISxqDgWfFTOE6hQP5C3Img1RPNDoATtc3c=;
  b=AngP16cdRBlbLMx8wAByXwHzOrlkD9aYTidef9fcwnNT++kcYJDZBkvn
   T/Z9plP5IXhIXeEm2V8D0k9fPSHJNIJQcdaGtlRXXjjIWwTYqiu7EOlo1
   7XdNXFj0sqooQGFJ5knAJ4nJLRJcSOBCWTCNahWSYOLSQb3m3p8pex2zI
   Hc1LUKqQzrdCmE06kQMJ+Lp9e1DWMXtMxEa6oYaRR5ekKor8D7zSjMvCP
   gBsVOwzsF1apDFiXf3YEX9eZlG78ijRSwEX4fegEq1348H6R+xEAKdl0h
   rQzQ7ULMNzyKkqtXExy6lWwBv8/xNXhV28E98JJjvuYR2+hqP5j/pr2dW
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11010"; a="4780697"
X-IronPort-AV: E=Sophos;i="6.07,118,1708416000"; 
   d="scan'208";a="4780697"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2024 00:31:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,118,1708416000"; 
   d="scan'208";a="15937831"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Mar 2024 00:31:00 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 12 Mar 2024 00:31:00 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 12 Mar 2024 00:30:59 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 12 Mar 2024 00:30:59 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 12 Mar 2024 00:30:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ByJ2ghkftkCxsBifCmIPHXzGFs4sNDAMvXXePeFXXQPjnmGLYiigmwoalZVXV7MchA65NSSE+z+fFnvGls1R0PvVeq6eQYtwKrOWHlSFqgo5i24Jyf3h6tLnnYLjSj8C0yjXwlDdMx+0QyH/FwpAYarL5hxbGYbFAFALn4VnN5pS+PmzAjsJxgiUxeIY3bQybMBW/XyngCBHOxvmE7WnQm/CeYh7o+9s/YteUp68QGLxnHEbjCnKQOghVEwzEtntI5TdTnpgze8fyVncUDwCc+L2tRmIuj8F1FJU0JouVXmIhhwDFpFCykfsFmLXm8AXXEdvpgbYnkkRmctV1J9daw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rqDCORJ8YISxqDgWfFTOE6hQP5C3Img1RPNDoATtc3c=;
 b=GqGiDeA3O+69PfHlt4/k7f2C+IwNbKKo3nwtGuyvcPNa/wQnpttkYH08A9kiEfczkRPBRQM1+ys8lidrSn8iOreurL2mO04nruiF15kZDp7Nrw8lw6idEcIf/LTv/EoWVI9bPx65ug3601kgXti9cHwhU+IwJ0/Ra/tuFl3CErbM37maKCVxS+AMGcNWCglMZGqPSPjPqtc4DPh3a1sxNnP76XV6Dr4xIQi/PnpbdhClCtwmtBzIv/Tr4QCU21OauUaXgpMmcsKiuHTUQ+mPrWGNvGtNl3s52yR0LnFtoUBN1xKicmEAMoWsONfMlby4YdBaqXSAVUMO8DlH5qRp3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by IA0PR11MB7741.namprd11.prod.outlook.com (2603:10b6:208:400::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.17; Tue, 12 Mar
 2024 07:30:54 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::39d:5a9c:c9f5:c327]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::39d:5a9c:c9f5:c327%5]) with mapi id 15.20.7386.015; Tue, 12 Mar 2024
 07:30:48 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Sean Christopherson <seanjc@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Lai Jiangshan
	<jiangshanlai@gmail.com>, "Paul E. McKenney" <paulmck@kernel.org>, "Josh
 Triplett" <josh@joshtriplett.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "rcu@vger.kernel.org" <rcu@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Yiwei Zhang
	<zzyiwei@google.com>
Subject: RE: [PATCH 5/5] KVM: VMX: Always honor guest PAT on CPUs that support
 self-snoop
Thread-Topic: [PATCH 5/5] KVM: VMX: Always honor guest PAT on CPUs that
 support self-snoop
Thread-Index: AQHacb6EgZkVEFvOhE+zvGbU+mYd9rExwA6AgAGEHICAAGu9EA==
Date: Tue, 12 Mar 2024 07:30:48 +0000
Message-ID: <BN9PR11MB527600EC915D668127B97E3C8C2B2@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20240309010929.1403984-1-seanjc@google.com>
 <20240309010929.1403984-6-seanjc@google.com>
 <Ze5bee/qJ41IESdk@yzhao56-desk.sh.intel.com> <Ze-hC8NozVbOQQIT@google.com>
In-Reply-To: <Ze-hC8NozVbOQQIT@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|IA0PR11MB7741:EE_
x-ms-office365-filtering-correlation-id: 899a2ca1-1905-46bf-3696-08dc4266565e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /KN9PtqlZxB4hkAWEHT+RHKzHxmAP4F1w6M7cD0fTEuYDGuOt+09KnRw1z6pJBxb4UHU1Qfc7v+Ubckm+ZvUn2dP0cQ/N3IO+AzuGXQIIBW+yq9Wc6Cd/zCzuq4kwz1fc3E6A1Vo0k0vcvTpv37QMg5dYrZOoDwgE2U8zpl1PxSiOg7ZauM8Yqpmhb+2sPszqZkoP4Zk3aaKTHSuOZ0b6I59r6EwhAOWeclNTKewYjaa7ZTcFGzNzHidq2vxX+QQrdgJmBW527kGJ4bz0LPPGGUXhcR66MDundpmG/iQhV9mhBdAyGhu8Btzccr9wudCkSLMTJkOD+ZAPWhKmAgr3JEvYcu33rkprlNJHenWQlYbTexRUHP3SGS/P7QAaV1Q1eaSHDUWEPPlMa3rkPqnNvuy3BfRxuW6VT3jzItd+msUErqMYZIBR1p3PxkjJ8ShUjJJd9xKCLAAWBKJQC5np57p7TVzW8PXjvPMWSGVhIx2H1ON3xIbX7y31vdrp2hMzOiXBEaeUAUqPIyM0uY9UaSXz/e18val3z/XgDOBLQreHJ02X5QAOwMEBxPSHjWyfsyDPktm+lR9+OBN3GVxxIuYu6xmpcj0LPH80BvXnSasdccdirO7F3zu3ZuaJJxsyKFEfBWo4Zbaj8ypZLmh1L+/XPIU9w3uWdNOEr/PMY8dSuq24f2vinJe/WOYZZ2/7kVqy4kR1p9FKUSDLNj4jdRFA323tL2TA4eisoWM7po=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WUloRVozMU42K0Q0bXprdTRubFJjMnNSYmtXaEpQQWNqeGpMZXJ1RHp0TDZI?=
 =?utf-8?B?NWE3K0ZpOGFPK0Rta0UrSCsyTkw0Yzc5aG9Qb3pmNGVuLzM1dCs4bkdUT1hC?=
 =?utf-8?B?Wk4vNkIrU0JDQTZIUnRnVEU0Ullpd1BFZ0w3eS9IWEUrR1ZnUXF1WWhOSEtZ?=
 =?utf-8?B?ZlRZWlRkV09yZzZyWTYxd0VNcXBBODZ5MTQxaU9qWDBzKzBiMXZUUmxhaElk?=
 =?utf-8?B?eUk0VzQrNCttcnBJM1d6RENoWEZoOHpwb3RXL0hWQnFCZ0RZUXJhSzVUa1A5?=
 =?utf-8?B?WlQ1TFZwL1JGbjhrcUdzUnJNSzlRdzRBNWZldHNmMG9MR1hqY285WUtGZ3k2?=
 =?utf-8?B?c1pLeDc2Q0UreDVrMWtRY0o3OXZuUzlFZG9RZ3BhdWYvTzczcHJDV1psc3U2?=
 =?utf-8?B?NGRNRjFsclRRQzdlNWZBTnRFOFc3UFFDSTRKaHR4bFg4SE1sdWhZZWZWc2h4?=
 =?utf-8?B?ZDIxYnIvV25NTDloaG41bEQzTFVGWnBEMTJ3SzQxOEczSDNxVWltNnB6eUZJ?=
 =?utf-8?B?N01FalpzT0VWQXFhK3hGNHBrZXR0OUJodGlwY3VSOWh2RFllZzJaemxNb3gy?=
 =?utf-8?B?YVI3dVVJMTRCNDZOcVdZZUlFdFN5Y3NkeVlNVTg5T0VhZDRpNDNUV3dMWENM?=
 =?utf-8?B?QXo4b2Vyby9hS0N1UWRpMXc5RGJkc2ZiZWdkZ1d6ZktUZ3B3RnJ6NU9GY1JP?=
 =?utf-8?B?V2tnOWF5VTIxbnI0ajAzemQzM3dGcWNaVDhZN3ZOdTFrZnJWbHc4alRDK2xB?=
 =?utf-8?B?NExqa0FSV0NGTFJ5Y2JoSHliOHNhRjNjNVNQSkJCOUplODhEKzdFam5hR3RN?=
 =?utf-8?B?anhXaFZmYWNuUmV6ZzRpaU1iYWt2cDdiYzF2YlFGbDZMT1h1bWZpUDhSS0s5?=
 =?utf-8?B?c0V2WHVBMzN1ekNVSEs4SDVvaEovQ3g3N3dLNjZFRDg4QVRKejFrcnU5a2tj?=
 =?utf-8?B?Tm5hbmszaFpyenMwRTNYM0FNRmt6NGVIMjN6QmZYZlFnSkx2dnAzSUJMejdR?=
 =?utf-8?B?TDBsdzFseE9QcXVXY0ZOclk1S3k2dGd2aUtSS3VxcG9MM2JDZkFFTTJiMGdI?=
 =?utf-8?B?QnQ3Tm9mcUtrQ3NJSzNLekpNKzA1UFJSZzhIRkhDd2tmQWEybnoyeUJ1Q0Vm?=
 =?utf-8?B?YUZST0VTeFBOOTlqYmlzckxxVzB3cEx4TlI5d05Vb3duRU9xalg5YWhhbWUw?=
 =?utf-8?B?V0dZUFQyVzZxdkVIdVhad0pPdDdSczJ6MHdSNlg0NDA5dk9RVWZJTmlldnFu?=
 =?utf-8?B?aUFzeFpXc2NrTStCM3VNajJIQmVGSGVrYWhWME9ldlNSK0lPNVhBdHMrMDNr?=
 =?utf-8?B?cDZzSUwvYlVmTzVSdG5iNU1hRHRreW5OdVprOTQ4cmRYaVdYRnc3TkNKOHpa?=
 =?utf-8?B?RTdmRkZHb1EzTTREaE5NMXFqNy9acFBqWWNtSWZoUVp4aFFodHB1Nmozcmdv?=
 =?utf-8?B?NVZtcFgwSVgyMFEvUkR2SDBWT2dzS0ZtclZ3UXA2ajhCaXBPeVlwVzZ1aXZ5?=
 =?utf-8?B?TnNZRVJZTTA0aEo4NHZzUnc2QVppbndpN2owTGwyLzlHdUMxdnpFQWFEMmx4?=
 =?utf-8?B?R2I4QmVvMGlXbWFUMndIVUFyL0V4NXdGVzBFY1M3RUxCRkNQYXhNbVBYOHJN?=
 =?utf-8?B?WW1HbUoyTWdzOG00WHk3WWhHbythQWRzMHZHSG8vUDlxVmlOTENCV0Yrakp6?=
 =?utf-8?B?ZHFEMU1iUmZrMHEvdy9XZUpuTExPd2R4cis0WHJ6TUdMR2dxQW4rSFBSS0s0?=
 =?utf-8?B?NjFoNHFrODR1L2hvTVkzNFVmK2wva01nRnQxZklpMW5rVk8wdGxzT3pDQkFy?=
 =?utf-8?B?cjkrdElWNGdoaTJ5S3g1U3hYcEVvQ0hTd1MySzFrekkrWnAwaEFlNTVxcnhn?=
 =?utf-8?B?ckNqRE1XUFBBa09OWWhwbkdGVXBEdisvYmJ1aysxVldydXl6NzZFYlpqVDYx?=
 =?utf-8?B?NUYvS200Sy9LQkg3WkVUNkhQYWNaWWJEUDkzWUtSajJSZVAvV0dmSUVMb0xa?=
 =?utf-8?B?cSszbmF6THhjWUZxNVNvNnBSeFA1NnhUc1ZHWTQvL2lnY0RQdkc2MFFmb0hT?=
 =?utf-8?B?Sm5IcXZSMGFaWEtGN2VsUUF1bEQzL2RTRktJV2tWRjdQWDRNdXRFNDU4TEpm?=
 =?utf-8?Q?0/7BQnxAx4jUSS5S5t3hd6ezV?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 899a2ca1-1905-46bf-3696-08dc4266565e
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2024 07:30:48.2771
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oOZPAM25Q7nSJNneJ5zOEzpAKkCgEulb05IrRA+YdTs1UmmlbJ9TEKzu9ppwRO+elItgUd92xZKOxUkqbvrEPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7741
X-OriginatorOrg: intel.com

PiBGcm9tOiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gU2VudDog
VHVlc2RheSwgTWFyY2ggMTIsIDIwMjQgODoyNiBBTQ0KPiANCj4gT24gTW9uLCBNYXIgMTEsIDIw
MjQsIFlhbiBaaGFvIHdyb3RlOg0KPiA+IE9uIEZyaSwgTWFyIDA4LCAyMDI0IGF0IDA1OjA5OjI5
UE0gLTA4MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3JvdGU6DQo+ID4gPiBkaWZmIC0tZ2l0IGEv
YXJjaC94ODYva3ZtL3ZteC92bXguYyBiL2FyY2gveDg2L2t2bS92bXgvdm14LmMNCj4gPiA+IGlu
ZGV4IDE3YThlNGZkZjljNC4uNWRjNGMyNGFlMjAzIDEwMDY0NA0KPiA+ID4gLS0tIGEvYXJjaC94
ODYva3ZtL3ZteC92bXguYw0KPiA+ID4gKysrIGIvYXJjaC94ODYva3ZtL3ZteC92bXguYw0KPiA+
ID4gQEAgLTc2MDUsMTEgKzc2MDUsMTMgQEAgc3RhdGljIHU4IHZteF9nZXRfbXRfbWFzayhzdHJ1
Y3Qga3ZtX3ZjcHUNCj4gKnZjcHUsIGdmbl90IGdmbiwgYm9vbCBpc19tbWlvKQ0KPiA+ID4NCj4g
PiA+ICAJLyoNCj4gPiA+ICAJICogRm9yY2UgV0IgYW5kIGlnbm9yZSBndWVzdCBQQVQgaWYgdGhl
IFZNIGRvZXMgTk9UIGhhdmUgYSBub24tDQo+IGNvaGVyZW50DQo+ID4gPiAtCSAqIGRldmljZSBh
dHRhY2hlZC4gIExldHRpbmcgdGhlIGd1ZXN0IGNvbnRyb2wgbWVtb3J5IHR5cGVzIG9uIEludGVs
DQo+ID4gPiAtCSAqIENQVXMgbWF5IHJlc3VsdCBpbiB1bmV4cGVjdGVkIGJlaGF2aW9yLCBhbmQg
c28gS1ZNJ3MgQUJJIGlzIHRvDQo+IHRydXN0DQo+ID4gPiAtCSAqIHRoZSBndWVzdCB0byBiZWhh
dmUgb25seSBhcyBhIGxhc3QgcmVzb3J0Lg0KPiA+ID4gKwkgKiBkZXZpY2UgYXR0YWNoZWQgYW5k
IHRoZSBDUFUgZG9lc24ndCBzdXBwb3J0IHNlbGYtc25vb3AuICBMZXR0aW5nDQo+IHRoZQ0KPiA+
ID4gKwkgKiBndWVzdCBjb250cm9sIG1lbW9yeSB0eXBlcyBvbiBJbnRlbCBDUFVzIHdpdGhvdXQg
c2VsZi1zbm9vcCBtYXkNCj4gPiA+ICsJICogcmVzdWx0IGluIHVuZXhwZWN0ZWQgYmVoYXZpb3Is
IGFuZCBzbyBLVk0ncyAoaGlzdG9yaWNhbCkgQUJJIGlzIHRvDQo+ID4gPiArCSAqIHRydXN0IHRo
ZSBndWVzdCB0byBiZWhhdmUgb25seSBhcyBhIGxhc3QgcmVzb3J0Lg0KPiA+ID4gIAkgKi8NCj4g
PiA+IC0JaWYgKCFrdm1fYXJjaF9oYXNfbm9uY29oZXJlbnRfZG1hKHZjcHUtPmt2bSkpDQo+ID4g
PiArCWlmICghc3RhdGljX2NwdV9oYXMoWDg2X0ZFQVRVUkVfU0VMRlNOT09QKSAmJg0KPiA+ID4g
KwkgICAgIWt2bV9hcmNoX2hhc19ub25jb2hlcmVudF9kbWEodmNwdS0+a3ZtKSkNCj4gPiA+ICAJ
CXJldHVybiAoTVRSUl9UWVBFX1dSQkFDSyA8PCBWTVhfRVBUX01UX0VQVEVfU0hJRlQpDQo+IHwg
Vk1YX0VQVF9JUEFUX0JJVDsNCj4gPg0KPiA+IEZvciB0aGUgY2FzZSBvZiAhc3RhdGljX2NwdV9o
YXMoWDg2X0ZFQVRVUkVfU0VMRlNOT09QKSAmJg0KPiA+IGt2bV9hcmNoX2hhc19ub25jb2hlcmVu
dF9kbWEodmNwdS0+a3ZtKSwgSSB0aGluayB3ZSBhdCBsZWFzdCBzaG91bGQNCj4gd2Fybg0KPiA+
IGFib3V0IHVuc2FmZSBiZWZvcmUgaG9ub3JpbmcgZ3Vlc3QgbWVtb3J5IHR5cGUuDQo+IA0KPiBJ
IGRvbid0IHRoaW5rIGl0IGdhaW5zIHVzIGVub3VnaCB0byBvZmZzZXQgdGhlIHBvdGVudGlhbCBw
YWluIHN1Y2ggYSBtZXNzYWdlDQo+IHdvdWxkIGJyaW5nLiAgQXNzdW1pbmcgdGhlIHdhcm5pbmcg
aXNuJ3Qgb3V0cmlnaHQgaWdub3JlZCwgdGhlIG1vc3QgbGlrZWx5DQo+IHNjZW5hcmlvDQo+IGlz
IHRoYXQgdGhlIHdhcm5pbmcgd2lsbCBjYXVzZSByYW5kb20gZW5kIHVzZXJzIHRvIHdvcnJ5IHRo
YXQgdGhlIHNldHVwDQo+IHRoZXkndmUNCj4gYmVlbiBydW5uaW5nIGZvciB5ZWFycyBpcyBicm9r
ZW4sIHdoZW4gaW4gcmVhbGl0eSBpdCdzIHByb2JhYmx5IGp1c3QgZmluZSBmb3INCj4gdGhlaXIN
Cj4gdXNlIGNhc2UuDQoNCklzbid0IHRoZSAnd29ycnknIG5lY2Vzc2FyeSB0byBhbGxvdyBlbmQg
dXNlcnMgZXZhbHVhdGUgd2hldGhlciAiaXQncw0KcHJvYmFibHkganVzdCBmaW5lIGZvciB0aGVp
ciB1c2UgY2FzZSI/DQoNCkkgc2F3IHRoZSBvbGQgY29tbWVudCBhbHJlYWR5IG1lbnRpb25lZCB0
aGF0IGRvaW5nIHNvIG1heSBsZWFkIHRvDQp1bmV4cGVjdGVkIGJlaGF2aW9ycy4gQnV0IEknbSBu
b3Qgc3VyZSB3aGV0aGVyIHN1Y2ggY29kZS1sZXZlbA0KY2F2ZWF0IGhhcyBiZWVuIHZpc2libGUg
ZW5vdWdoIHRvIGVuZCB1c2Vycy4NCg0KPiANCj4gSSB3b3VsZCBiZSBxdWl0ZSBzdXJwcmlzZWQg
aWYgdGhlcmUgYXJlIHBlb3BsZSBydW5uaW5nIHVudHJ1c3RlZCB3b3JrbG9hZHMNCj4gb24NCj4g
MTArIHllYXIgb2xkIHNpbGljb24gKmFuZCogaGF2ZSBwYXNzdGhyb3VnaCBkZXZpY2VzIGFuZCBu
b24tY29oZXJlbnQNCj4gSU9NTVVzL0RNQS4NCg0KdGhpcyBpcyBwcm9iYWJseSB0cnVlLg0KDQo+
IEFuZCBhbnlvbmUgZXhwb3NpbmcgYSBkZXZpY2UgZGlyZWN0bHkgdG8gYW4gdW50cnVzdGVkIHdv
cmtsb2FkIHJlYWxseQ0KPiBzaG91bGQgaGF2ZQ0KPiBkb25lIHRoZWlyIGhvbWV3b3JrLg0KDQpv
ciB0aGV5IHJ1biB0cnVzdGVkIHdvcmtsb2FkcyB3aGljaCBtaWdodCBiZSB0YW1wZXJlZCBieSB2
aXJ1cyB0bw0KZXhjZWVkIHRoZSBzY29wZSBvZiB0aGVpciBob21ld29yay4g8J+Yig0KDQo+IA0K
PiBBbmQgaXQncyBub3QgbGlrZSB3ZSdyZSBnb2luZyB0byBjaGFuZ2UgS1ZNJ3MgaGlzdG9yaWNh
bCBiZWhhdmlvciBhdCB0aGlzIHBvaW50Lg0KDQpJIGFncmVlIHdpdGggeW91ciBwb2ludCBvZiBu
b3QgYnJlYWtpbmcgdXNlcnNwYWNlLiBCdXQgc3RpbGwgdGhpbmsgYSB3YXJuaW5nDQptaWdodCBi
ZSBpbmZvcm1hdGl2ZSB0byBsZXQgdXNlcnMgZXZhbHVhdGUgdGhlaXIgc2V0dXAgYWdhaW5zdCBh
IG5ld2x5DQppZGVudGlmaWVkICJ1bmV4cGVjdGVkIGJlaGF2aW9yIiAgd2hpY2ggaGFzIHNlY3Vy
aXR5IGltcGxpY2F0aW9uIGJleW9uZA0KdGhlIGd1ZXN0LCB3aGlsZSB0aGUgcHJldmlvdXMgaW50
ZXJwcmV0YXRpb24gb2YgInVuZXhwZWN0ZWQgYmVoYXZpb3IiIA0KbWlnaHQgYmUgdGhhdCB0aGUg
Z3Vlc3QgY2FuIGF0IG1vc3Qgc2hvb3QgaXRzIG93biBmb290Li4uDQo=

