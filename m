Return-Path: <kvm+bounces-50874-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE2BFAEA5C1
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 20:50:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B2433A1A3C
	for <lists+kvm@lfdr.de>; Thu, 26 Jun 2025 18:49:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B482E2EF287;
	Thu, 26 Jun 2025 18:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lwouzXTo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7253F2EE60A;
	Thu, 26 Jun 2025 18:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750963804; cv=fail; b=KzNRdmgelGjgS2YaeXVWxIBzPVlsNGA2qZ1D1TgexYPwcscnFeRCoKkQHt6d7Ed5Ep2Doda7caPyuX7Li8Npg032KPF9U1H4inm/J/pSSgKaytl4kgxqniUmyGbuiOMp6nIFL97TTgwViZkmFMX391xa170AgXqpua6Mhs4sOHw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750963804; c=relaxed/simple;
	bh=MMj7hbMZVPSM070CIAh7XxmLcANjYHZt/KqPinCaWDU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Gfr4I3DsBgbHGzejbBJkjcZgiKg4ygcZNVItERY7deAw39GdD5zulHVgvy7deYRXpMPCm52ITPRTBwnTlCHRX1yVbpktmt2vAvflE3lNP+yClAk/LQiXZXdKhWgsPS43+YsTQAFUwXxhSNu4OgvRRrSFlJHkYyWMqj2DWPdSA8Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lwouzXTo; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750963804; x=1782499804;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=MMj7hbMZVPSM070CIAh7XxmLcANjYHZt/KqPinCaWDU=;
  b=lwouzXToAV1POGwx1Cep+JNGLbeyk0oylBoMFm77vYKuATzaQAbgAKO+
   O3QF2p+VIz688qlVW2U8BymV5/ghaxV+U5l+IKhK0b6vf45sio7fmrmBV
   TamNmkLgN8I8mVp6e1VohRDkVLL0L6y70OQorJDSjUEhpPEJAKDSdefBL
   O/SfIAGnoZv4B64vVj5t+miA/NCEhq1KhcIeLwyBUDQI2grammdK+VpCQ
   BdbMdvzJbBJSIn3j/a6h9cSkvHHr4zBZ1T9ZArj97/CpcCJaLbkxD7cuO
   69FsXyK+IdDb/H7SeUP8IrUFJiDK93VlcskRfSPQxo99JpzUZ66HHG3Hx
   w==;
X-CSE-ConnectionGUID: DCX/Oh/dTjie2VoYHY9MXw==
X-CSE-MsgGUID: aydSi/CISU6dASvtJSRyqg==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="70703513"
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="70703513"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 11:50:03 -0700
X-CSE-ConnectionGUID: MhXM/mtIQz6VKqSA3+nCBQ==
X-CSE-MsgGUID: QYEgr9R7RSa9msoPL9IBig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,268,1744095600"; 
   d="scan'208";a="156623743"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 11:49:59 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 26 Jun 2025 11:49:57 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 26 Jun 2025 11:49:57 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (40.107.243.84)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 26 Jun 2025 11:49:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YZPUElHptW820Az+0k5modaodz1KDfR5cC/LDmXqPYdDLnUC2a2MIaUW5c43BkgwYcCBb1MwaoqesS9B+Nxrm9r6Gg5ckrr7rbdoXDMSNDeL7Dr0USP1ey9uB9W+cb7MaVTKO7zdIIcoadLM1vft3auADFoSzCygLUUO+MfbTfHW4t6Z/ti3fGAH6fh64lS/orD9qXESAH0FSenQeaEhp1JSvFieYY0lo+WjOyBq6imjYXTOXKhRO1y4txVz2dVmeS5PQb9tPMvTRXba+B1oDuSNe/h6/mpsfQlJKuitNitU4lhpM1YcFpnsV8DVoQcZthDi3vEjYHAFCil0DVjvDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MMj7hbMZVPSM070CIAh7XxmLcANjYHZt/KqPinCaWDU=;
 b=dhKvO76nX+hNwcAdIFhVcXE6Q/ymEGzUH39pnGGzoje7+H8+tHfF5lZRGma7R0GwDiHnpt7cS5d4OXYig5u5uY0u7ZdPOCQVK0IUG4KGOdW9jQ53JCNQVFkmIzZPtvw/kVd3sLg4jockNpsySg0hnG/mzA62RfBxfyyUAljBNNOEt6vKJgwQw5qPhEdpjLJDOYoTW0/qtTDcOLx0pYvn3SZAVGDl1vCFK1EMRZ+5pn2UrWZJbkmjacPbV0K0zb8sqtB9zjVI17jZPQB7zjVln5PA6FLovYWcyuYakq4FREWBgpvASxMzByRdf8Bxpw68D6mDDgrFzMPApUuOHQZWVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM3PPF8ABC16DA2.namprd11.prod.outlook.com (2603:10b6:f:fc00::f36) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.30; Thu, 26 Jun
 2025 18:49:41 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8857.025; Thu, 26 Jun 2025
 18:49:41 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "Huang, Kai"
	<kai.huang@intel.com>, "bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org"
	<peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>
CC: "seanjc@google.com" <seanjc@google.com>, "x86@kernel.org"
	<x86@kernel.org>, "sagis@google.com" <sagis@google.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "ashish.kalra@amd.com" <ashish.kalra@amd.com>,
	"Chen, Farrah" <farrah.chen@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>
Subject: Re: [PATCH v3 4/6] x86/virt/tdx: Remove the !KEXEC_CORE dependency
Thread-Topic: [PATCH v3 4/6] x86/virt/tdx: Remove the !KEXEC_CORE dependency
Thread-Index: AQHb5ogNy7eq/Kqi+0KtoBEaJvf4dLQVyRQA
Date: Thu, 26 Jun 2025 18:49:41 +0000
Message-ID: <4f8688425ae2c436c407f5a3c987b9e9bbc6a543.camel@intel.com>
References: <cover.1750934177.git.kai.huang@intel.com>
	 <a80915684a5eaec7a27ac1900dc5125a36b330ab.1750934177.git.kai.huang@intel.com>
In-Reply-To: <a80915684a5eaec7a27ac1900dc5125a36b330ab.1750934177.git.kai.huang@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM3PPF8ABC16DA2:EE_
x-ms-office365-filtering-correlation-id: 07c0e326-64f9-4944-74a9-08ddb4e23597
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?MFFKQStpOUFEemRPVmFwbkI2dDhGNnpLajIrTEV1ei9SVUtjMDlkZFc1N2pP?=
 =?utf-8?B?NThaV3VuSnUrTmZpUUFHVEltZG1mOWo3RlRsRHllUTUrUDVTWnZ5MFR5NFN3?=
 =?utf-8?B?WGltL3Z0UlUrM2wxakE3SnlUWGowbHU0d1RxN1JGWVNieEZQamJ6M0s5VGIy?=
 =?utf-8?B?T3NUT1FkWi9MUmxub2I3THRWRW1mQ29mL0lFc3FJSzhuZUFjcUxjV0pMVnJL?=
 =?utf-8?B?VUxBcURmczdSZlZZcktnQTdmUkJsTWlKclFnUDVBOWpZUmhiMWF6SzNsTnht?=
 =?utf-8?B?dzUrU2Y4ZVEveHYyWEN6SmJncFVYZXdHWWMzcXhlaXhDcHg0M2hBcVVtVDRh?=
 =?utf-8?B?YWlZQ0hDRTVzbVhvUkFPTHhhckcrbzFnTGVvREJXM0F2TGowcDRtOFRHU3dE?=
 =?utf-8?B?SXZzMm1ZV2p0aGpJT1dMTjFVTldkSGpNVC9majI1ZlBjQ1NlUi85bzlQZzFM?=
 =?utf-8?B?a2NOMW8rQ3FDdEJpZlVOK0R0c1I0c09MdjdKQnd6UGF1L0htam5IbGxWd1Q1?=
 =?utf-8?B?TEM3NFNWMVRMK1BwbTVVdFpFWXRBRUVFNExHcDdmcGlrWUJnaVowQ2pYZlVU?=
 =?utf-8?B?NG10SHJVT0czV0Y5MTN2TzZuZDZoZDljWEI0b3dOQUZ6cE0xM3RuVU8rdEl6?=
 =?utf-8?B?eG83UDd0QUV1d05vZk4rd1VNMzlMbHlJQVZpK2U1cVNISkVnZVBLMEFJYmpk?=
 =?utf-8?B?QVUvRHg0YlQzdnJrMFVsd1ZuMHVuZlBUVm1lOEI3TWpWemFtOUgySzdzdkFT?=
 =?utf-8?B?ZDVlN3QybjhpZXdabG8rV3IxSW1FaXR3R2N1WXcxQUhZVjdvdCtrWmoyRTR5?=
 =?utf-8?B?NkZCbldJa2kyOWVlR29ZanltcUdFNzBQTlJWVUdBNUQ0YS9xUU9WcU5hN3c0?=
 =?utf-8?B?bm56SWJCdTdIaTF2Qmg5blRjOXlrZFZNQkNmNWE3V05QL2JGcDV2UUxiSjNS?=
 =?utf-8?B?Z1ZPaWdUeE51OE1tS1piMUhmR3UwMnlFU1dNaGgxaTJudXpqRjJMN2VFaWIw?=
 =?utf-8?B?Zi9lcEJwZVRZeTM5VEFYMm45dFh0NGwvYWgvajk3VXdzV3hLS1VoemowTEt1?=
 =?utf-8?B?eSsvb3B0bHdGM3pxOWFhNW1jQ1I5WDlXNVZTeXJFbkVTL0tEb3RoL1o5OVo2?=
 =?utf-8?B?dEEzOC9wbDB0SHdpcWxwRFBRTVM3MGFTZlNoZTg2cVo2UTlZUjIwbGlkK1ZH?=
 =?utf-8?B?NHJxNFhSKy8wT3hTcjJHSWdMT0plYnZ4ZU1mME1kZVl5ZjhPdEd1SnJ1MjlP?=
 =?utf-8?B?WmZUck8rNCt5eHB3ZnpkWWR4cytNaUhuV0dLSmpyakRCcUVIaS9ZTm54VFRC?=
 =?utf-8?B?VmxwdE8rRisyRmFwRDgzRjdSMzlQNDFaSGVxMTkwZG1ZSmFMQXVXcFZXZHpJ?=
 =?utf-8?B?NEN6ZHp2TVd1dlI3Wk5jS0lJaWRya044ZVVmSExPc2tNcnYvMG10c1V3aWRK?=
 =?utf-8?B?VnhaUU5MczA2M1U0bFY5WFpCSzNiMVp3S2dERWE2NmEvWkJsdXJmdkgwd0tj?=
 =?utf-8?B?dStFaWROTDd2QUtJaWd5TGtIbmlKbWFmK250TCsvTUdvMDBCeFdyMW9ja3JR?=
 =?utf-8?B?THhjakorTW9RaXdNT1p6K1JmdlB2WHVUbXlmckJRdHI4L2FOQkE1aFlvOU44?=
 =?utf-8?B?RElHLzNaM0k5TUNGQTZSN3FhSm5hU3loWlh0VnhsN0t4RWU2Nyt4R0hFTml1?=
 =?utf-8?B?bzAwNC9hU05KS3dJb3hyc0ZKeWppNUhETXFRK244SUE0cjlMb28rVytSZERN?=
 =?utf-8?B?VXJrb1kzZDlCcGJYQU82eDI1NnFJc1BXWWU3WDVxR3A3UVVZVmhoSEJBa3lW?=
 =?utf-8?B?VVRYcGJaTnhHNTErZEhSY0JaRmVJNlhRb0hmWVJ6Q2N0UTJ6d0NRSi9IWnF4?=
 =?utf-8?B?WHIxb2xzQkk1TDVrQ0VlZzhQODdGbzIyZW84N05VZmcyS2JqOGtSUXdxazBX?=
 =?utf-8?B?YUlmZGkrYUR0dGJrUHRNOFdJVXNVTFB2REo0aU9Wb0dEZjM2YnNweDl6K1J6?=
 =?utf-8?Q?UnNmg3qy/A8pmvGZETQOLY7xnLvctA=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?djkrVHNyajF0TWt3bTdMMWNkaVdLcTlFakJqdVRrekM2dk15T2FJNmxGRTJU?=
 =?utf-8?B?V3dJV0x6UGlYbCtONVpQR1NNT3B5dWZYS2tVUnhoakk2SGNkUDN3SUlYb1Vi?=
 =?utf-8?B?azJMQWsxZzZGOUY3ckZ5dGc4VGFPMmVoSXMyWnN6Z2NyQ2ZiS25DRVR6VTQ0?=
 =?utf-8?B?WHJQQmRQWDFvQWRQNzhVRk4rVkZ1YkUvdkxwWkdqbEVtWktkb3hKcGtFbWZZ?=
 =?utf-8?B?bkk3Vzg1UXBrRWorNHlpRHpRV0NsSzlpRXpjclpPTUxxQXNzdXA1VGRPKzhv?=
 =?utf-8?B?ai9Sb04xdklqMUJZNEl6VkNXUGZVdVcxdFFHQjV2TnlmS0NnWmppRUJsWTZK?=
 =?utf-8?B?clJnZTNYVUVjMi8yVUt4UlIwTVhHNUpWc29PMlEwcDFZSnVkTnZRWjNJam4r?=
 =?utf-8?B?K1NxTzZhTmZEZXVCWDAzUGJiU21QcnpEbVY4M3lJcnovZUU1Nnp0VHgzQk5P?=
 =?utf-8?B?eU83V2lyZmkwYThCNEZTdmRNVWNwYXFMdVpYRjZ3akVMczdkR3hnaDVLU3Qw?=
 =?utf-8?B?Tm8raEZlSEdlRzd5a2U4OWxvSEV4ek9ZNEl1RXVuTUFVTlVpczIyeVVzUm9i?=
 =?utf-8?B?TUJDWVU0THFONGFmdzNMTXJXWnZjM0gvN1ByWXpwS0thOVY2U3hna0xZQjlU?=
 =?utf-8?B?RFRGUXJmaXkranRLa2ZZQmpmVmNuNGszQ3VWUWRtQjhsd2FLd3oraUZtbTEz?=
 =?utf-8?B?RkhzTHRIeHhMclZkajRieUtPQmt5eTlJVkRXZ21heTRlWGRNNzJkL0FsNWtF?=
 =?utf-8?B?RkhKSVQ4bmtUSTRVWlg3SG5SSXpTakFFalRKcTFQOUhHS0pHd3M3Sk4xdnVr?=
 =?utf-8?B?aWxXMGltS3NWcWRUY20wZWYwNS94aHRJMXVMWWVITEh5dVlxRVhndFRkVTJI?=
 =?utf-8?B?WVpyb1k2UWlRQlRDTmdPdzZvYURVYmg3eEVwQW4vY0RTQkVuZ3RUbE1oOWxi?=
 =?utf-8?B?M1lnUm1KL0JNOTBmNFhKVkdtMGZMWkd1NVRTdHh4bmRMRUxCODl5akViRWNG?=
 =?utf-8?B?QW5wQllBSnVuczRZcHpNOWlWd3pPdUlYdDNlYkVIM2FrbHBna3JVbUgwMTRj?=
 =?utf-8?B?bHRhS3F2Vjhob0lDekd3WTdTWTAxNEx5NWppMzVpRmFXMWpHWStsNG1HSEh2?=
 =?utf-8?B?Nk9wblZ5ZFdlblhCVWE1aFh3ays4MjJQcnR5c3BQamFidW9NVUZQcEt2Uzhi?=
 =?utf-8?B?V1pmb2Fub3VBMVVGRG1nbEkxRUxLMUNMVzVheUduR3dUUjN5djk0T0s3RlBI?=
 =?utf-8?B?am5TaGFEN25GRGY1cXRvVXhFQnRFekkzczgxRXhra1VueXIycFVGQ2JtOXJ0?=
 =?utf-8?B?RXh3NlYyR0ljNC9GaUZMSFdkRGQxRFdQQjdVYzJGV0F6TkpxMG9KR3dwZFlF?=
 =?utf-8?B?M0loRFlzbGhIRE9JMnFFNlpVU2s3b3hEKy9xOUpvaUxrL2piSGpDNVhJTlE1?=
 =?utf-8?B?bXVrQjJESHBVUGtRSUtlSzJ6amlJbVdYNjM1UFVDbjQvWm1YTlcwdlIvMTZa?=
 =?utf-8?B?TE8yMVZpRlY1aWtIVnFVNW9iY05KY1JHSHNwOVpwdTk2Z1BSUmlGd2dPV08y?=
 =?utf-8?B?RW5hYldPTjRtcjJSbTNKWXMrcmM2Rzc1UFM1RUZsaGxBWHNVVHo1SGkvdFI5?=
 =?utf-8?B?ajhGem9pZFByb3MxL052d1MvYkZETUtramJqS0QyQ0tZQ0RDUHhWQ2hPUGpP?=
 =?utf-8?B?YkpxTzIxaDY1UGgzUVVzWFBnNHRVNFhFcFNRcE9ZcjMyelQzcFR3NC9zYW9T?=
 =?utf-8?B?ZThHdXovelVkYVRUcjdYVExFSmh1ZmlrazlqVnFFVVRrRlQzR2pZR1pWUmtm?=
 =?utf-8?B?VHVzUG9RRWFHZHFYTWlpSnRuR2xoUEtiMlIyem02MjRTYUxKaTNSKzJxZWd1?=
 =?utf-8?B?aURsS0xadW52MVFjdzh1R2tPTkpUSmtEWXJxMi8zQ0t5aVVKYk00eE1KY0xh?=
 =?utf-8?B?S3BGUktsdUEybVR2YlJBemZnNDUrWnEwZndWRkpUY0hhWG1paVRVOHpWODJo?=
 =?utf-8?B?OUwzTVlheWw3allFODYzM05COU51eit4UUFDK1F4N2VnMXhLRXMyMVhWSDA5?=
 =?utf-8?B?bk9OMlVQSW50Nk5HY0kzOThmZEN1V0ZNZ003N3hPbDZtNENyMEluYU5lZGgw?=
 =?utf-8?B?eEZEbmRnN3daMnFoM3YwNDA0bE14MVlrK1FOc1gzVTc1WllxNWM1VElFeVUz?=
 =?utf-8?B?dmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FD560F079FB5F64088D252BB0AE40C49@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07c0e326-64f9-4944-74a9-08ddb4e23597
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2025 18:49:41.1079
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vthYvjAGVmQJQKKqZEneIHcwzB8gXh8b5ms829DafVbypxZBsAhmA4X9M+xM4N4NsJghy3PWP1uYEAViZaSVl73YoY4hV9cPoIwp7FmffTA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF8ABC16DA2
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA2LTI2IGF0IDIyOjQ4ICsxMjAwLCBLYWkgSHVhbmcgd3JvdGU6DQo+IER1
cmluZyBrZXhlYyBpdCBpcyBub3cgZ3VhcmFudGVlZCB0aGF0IGFsbCBkaXJ0eSBjYWNoZWxpbmVz
IG9mIFREWA0KPiBwcml2YXRlIG1lbW9yeSBhcmUgZmx1c2hlZCBiZWZvcmUganVtcGluZyB0byB0
aGUgbmV3IGtlcm5lbC7CoCBUaGUgVERYDQo+IHByaXZhdGUgbWVtb3J5IGZyb20gdGhlIG9sZCBr
ZXJuZWwgd2lsbCByZW1haW4gYXMgVERYIHByaXZhdGUgbWVtb3J5IGluDQo+IHRoZSBuZXcga2Vy
bmVsLCBidXQgaXQgaXMgT0sgYmVjYXVzZSBrZXJuZWwgcmVhZC93cml0ZSB0byBURFggcHJpdmF0
ZQ0KPiBtZW1vcnkgd2lsbCBuZXZlciBjYXVzZSBtYWNoaW5lIGNoZWNrLCBleGNlcHQgb24gdGhl
IHBsYXRmb3JtcyB3aXRoIHRoZQ0KPiBURFggcGFydGlhbCB3cml0ZSBlcnJhdHVtLCB3aGljaCBo
YXMgYWxyZWFkeSBiZWVuIGhhbmRsZWQuDQo+IA0KPiBJdCBpcyBzYWZlIHRvIGFsbG93IGtleGVj
IHRvIHdvcmsgdG9nZXRoZXIgd2l0aCBURFggbm93LsKgIFJlbW92ZSB0aGUNCj4gIUtFWEVDX0NP
UkUgZGVwZW5kZW5jeS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEthaSBIdWFuZyA8a2FpLmh1YW5n
QGludGVsLmNvbT4NCj4gVGVzdGVkLWJ5OiBGYXJyYWggQ2hlbiA8ZmFycmFoLmNoZW5AaW50ZWwu
Y29tPg0KDQpSZXZpZXdlZC1ieTogUmljayBFZGdlY29tYmUgPHJpY2sucC5lZGdlY29tYmVAaW50
ZWwuY29tPg0K

