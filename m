Return-Path: <kvm+bounces-11694-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 884B1879D32
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 22:04:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC4E51C218D3
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 21:04:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C11D114372D;
	Tue, 12 Mar 2024 21:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Rlv61143"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A8D8142909;
	Tue, 12 Mar 2024 21:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710277413; cv=fail; b=ggfckNIrZVzHClYt00nR5KVe8sUJpTsb5Tzx4CxAnf8QfKQ2pvNVZc8jutRZyf45Z+HIHZcgbvO7IUQebBct7gHw3O4BLxuka7sfmkx49Q7QjSteTvjTM0bfz67DS3snIPSK05C2uiobZZ0lZunFxAFU6GCVjedRx2Gu/y1FDUk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710277413; c=relaxed/simple;
	bh=zjptgliIExyv0ByxTjSVIFmuPraaiyLv+ReJOiGn/tI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Peoel/BB60aB5ImiFPhH6h84y/YMuOPn1LQ+KRVxm5cRxyccfnWZJsne/8cEWtDLMCPKLJHfsVBsp28LFHO8zRveanjBwHh97EycueF0al+2dSly/9ijtVvd50q7WlT5c4gI03lMJJfCsR5GuIsvS86DArWwE28iOzjRxW+GyrQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Rlv61143; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710277412; x=1741813412;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=zjptgliIExyv0ByxTjSVIFmuPraaiyLv+ReJOiGn/tI=;
  b=Rlv61143+00GhIJbbANQXu+SxkgK4fLgnt5RG5BglMM7cPn0iS+qxiho
   IPTfhu4eNDXsM6q6f+Em31y0Q/RC9Q9K1lMTS0yfrLP0ZCyTbNtOcbUTn
   PNpYg6b0k//mSbPnP20vEMnZQ5UYXimotYbgJ+Rp8keCjjNh44nCOKDeW
   F8B2z/7SpLL5r+4cz8XvkkCcXPEXZ+ejaExy4FJmLUkIHzn6Qs+LQl/kl
   /OeUXXv4BlBckRs0trdD+U8sE1GXSbH5kbqYk0fp1mH4+uZpQxU6RJL5Y
   ZfLGUYfxcwOoNKKCVQ9EeyOgmQBnqY5En/wwZF8G5PaGSjyq+8+/BAYqI
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11011"; a="4872977"
X-IronPort-AV: E=Sophos;i="6.07,119,1708416000"; 
   d="scan'208";a="4872977"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2024 14:03:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,119,1708416000"; 
   d="scan'208";a="11757443"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Mar 2024 14:03:30 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 12 Mar 2024 14:03:29 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 12 Mar 2024 14:03:29 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 12 Mar 2024 14:03:29 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 12 Mar 2024 14:03:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J3WRESX48wdlgg7aHPsGJvGhmWwJPmOQl6fbBDaTJDL+vg2cJxheWvcWware234/kIaac7uErVsgXYv41Hlg8FduSRoqmmrRLj3YyiZoFoDUKScI+rt3vaDKPjpeDSrCWO9lYY4f724MQ3hudSd3MYzTpZ7Q/fyeN+zGLrBkMcUTgOrSj7AYBVYBGZb3UTB8+YhEO3x0QCsnPiwmK+LgxGKrapSxlpM9krNHBY/q87UIw5rSoEHIg/J9oub1Ck1s8PnGfW5JLHBl3xuyTpdFR1DL/4NCxvLA1dbajRVDZYgRnbwccGMbmcNi4eP6uzXXf4pF7li4U1LRe6ZZUskKrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zjptgliIExyv0ByxTjSVIFmuPraaiyLv+ReJOiGn/tI=;
 b=nqScLDRJHY2mXU2V5906pkWdOlEWD6kZdPcniG8Sfha2cLXCYSyzbtf1xrTKdgpMkRKx0Ve6g/SiKdeiOmgdgTJFwQLBRoRsEFVfp9yR5VJ+G83PQW+JPshtarp8bUwLH1hMZ+x8F472OH8vRSm6CXLs4Y6OCaxDhtkr4l5GQGPcf71D4swOUqCrkq8v87Wm/JV+LKoUPQIUHDfPNFnBaMRmR00BbCGRvQoSF6cylIpZrZ4KWGrj3vz2Ts0fQO/TvThNqGTBm9ma1VoFzwsbUIM4vqcarnaVtXJ60ZQAdFiy4Qy9Q+B+RRj3kBEWFTF+bTyjiZJInEbQVsXUDSvYyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA0PR11MB7331.namprd11.prod.outlook.com (2603:10b6:208:435::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.16; Tue, 12 Mar
 2024 21:03:27 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7386.015; Tue, 12 Mar 2024
 21:03:27 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
Subject: Re: [PATCH 07/21] KVM: VMX: Introduce test mode related to EPT
 violation VE
Thread-Topic: [PATCH 07/21] KVM: VMX: Introduce test mode related to EPT
 violation VE
Thread-Index: AQHaadPTZSSbmeiFDEazmSR4Wgc6m7EzZ4eAgAEAwoCAAEV+AA==
Date: Tue, 12 Mar 2024 21:03:27 +0000
Message-ID: <74d38bf8d327ab7c9ec4809ba12c59ac98c316d8.camel@intel.com>
References: <20240227232100.478238-1-pbonzini@redhat.com>
	 <20240227232100.478238-8-pbonzini@redhat.com>
	 <6d0f2392-bc93-445d-9169-65221fb55329@intel.com>
	 <ZfCIz8JIziuvl8Xp@google.com>
In-Reply-To: <ZfCIz8JIziuvl8Xp@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|IA0PR11MB7331:EE_
x-ms-office365-filtering-correlation-id: 86cc5e4d-5252-4746-bab1-08dc42d7dcdc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Yr09r0vAApNJhc/vd4Q9vD8u+wxA8yDXJUoVWQd+mpnsKc3/0RY0j/IuxBe1ypeVGvIRXV8II8VJMsoj1SuBqhGJbMm4RDhtFw1z3kXGoCn+3jFzGtl2cA7sR9OaAZd7hbjRMbgSvU4mf67g/R4tw7nZD8i4MfUNFXmmD8L51e6cy5FEJAksHjaxSrb7E1B8HeOQWPzFIW05IHTUVVnWl+nFwbYfTFdNHYhFpC1bBjYS308WI0BG1eXgrvq9ptAG6Y01NmW+nqx3n1Sbw1egPRZ2xz0tlKR9NNjw+pov1CcH9VdIInwtE50floyV3dyZfjwW92PGqXiIKL/bWiRiwKRfvWYggSoiAirzCzqH/g1zWFUobU1MAHezilMZZhGYuFCIr6iCTC9FmE7sKG0nRwqeY0YsNKIR6Cfk+jLLyRJqVmGPeR3T6BenX+Gb1NGSzqYNhWwx+m2clYPby1/7Bl4v3XDMXOFTkOSuu5ZMnj6r1HVxAOvX3clTgJcIQ6L207UiKlK5Fg9yzk1gIhzwRLrkVZDyd6xt4GW818jev6j0STa6djsnP+FT+XYst7Lf9Wgy3XWmW2Iu6XgsOCB2AA//LBtetgD/G/9/ZdyWd9j+lqI4Avgdjg2iDR8tAbftZ0oCZaM6GoSgfO2naVzqzphl4UslvjTstzEqwZ3b5/Wo7Ooul6Rgus9ukrwQJ5NIUB+1eflrmSszQ6WU0oFrKw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NTZVNmZQTFh6YXRsK2V0YmxJS08zbW1GQnNrWmRpcmR1L0N0bFU2WnNBTVI3?=
 =?utf-8?B?V0pzZHEreml6RlJCWFB4bXlUbEhrL0FuSnJJenV4ejBvUHlSVzQwRU5xcVpy?=
 =?utf-8?B?bGllZE1tNXZVZUlTTUppSEJHbElLL0g0YVc4ZlpmbEllN0xUdVJ6QUtGcFpu?=
 =?utf-8?B?YmNRVXcweXd3eTlNMVI0QSs4dUpqaDhTS0FRbUZvQmpWaGhiUHVoM2FDWWFJ?=
 =?utf-8?B?NEU0VHVCazNIMFRHZTBFelRaQjF1djhpT3NaS0s0d2x1d2VSSkhKeGlhTndO?=
 =?utf-8?B?Mi8rall3VTdVejNIRHZ5eGtGNHBqV3Z3OWxxNWQ3VGplQlZSWTZYbVhVd0Rz?=
 =?utf-8?B?Ni95QWNZWVdPRmtuV3RDcFpqaGVCUmo5MlVpSmxGazdYQVBaZ0MwaDlZMGo4?=
 =?utf-8?B?MDBvdnUzbGs4WDA5NzhaTGRsMVdkclk0YkZDekI2K3dWaC82ZHNtYlF4MHh5?=
 =?utf-8?B?VzFuZFhQMXViWFZGQU9RT09UOE5QbkNiK2dLVUhqaTVoN2RDeFVkVFJmMzZk?=
 =?utf-8?B?K0doVHNIUndLWXlUZEE3U1hkYzhZV1AvU0ZnR3RRbDF3UmtNUzArNlhDV0Jx?=
 =?utf-8?B?OHRJdmVzTktuQk84VVZiMHlpSjNUSnN2N0tGaWhQL3F5eEtlWm1tdlcyM0Zy?=
 =?utf-8?B?VmJLK2ROU3VVeHdDRHBDYVlDYzRxWGhMODZUV05DL1NjaHoxRjVXelYwOGpw?=
 =?utf-8?B?VDJnWE5sN3NqRjFiMXpCVmZhL202emhxTEluYzdOODlOa2FoNkZROVFGRGU0?=
 =?utf-8?B?L095c3hSdmpnZGpOd2JKbkgvd1hLakhUZUUvaloyd3Y4UWVpNnJySmI5UE5y?=
 =?utf-8?B?ZXpiSjd1U0NvVGFkM1BmSmdsVU9PQnRoUzFZdmg1cnhDL1pvUjlsb1FUM0th?=
 =?utf-8?B?dlhpd3pydThETEZXNG9FcHVnN0MwNElhRUUwV3BPUkNsekx6bVQwbWcyb0x5?=
 =?utf-8?B?dnhpUHVsTy9hajlIZlZaYmFVWWlGK0lhK1ZLdmVHMmRhNGZyWmtXSTVxakRY?=
 =?utf-8?B?a1p1aExaWE11MHlCQXhkd0pHZnhoTFBnU1dpaVBDVnh5YlRJL1pCYWQ1dzdY?=
 =?utf-8?B?Qmk3V1pOb3hua1JPM2c3WTBOVGlFaE43ZlF3bk15VzVDR1B3dFlCSW1GSHo0?=
 =?utf-8?B?WGc4dEduU0thaEdCZU0yTVR0NVc3UG1TRDBTZFZ0V1IvaVZpTzVkcmlLc0l3?=
 =?utf-8?B?R0JTaFNJTEkxNFlyZmR5eHNwcWtBTnBkc0tNdHFUZHFnaThMTDdPNDU3L1dj?=
 =?utf-8?B?UDdSR04ycWpsUEYyMklEYmtETGFiMERMRFhpTmVDb1RSU0hTNFBNNGx4aXpS?=
 =?utf-8?B?OEhKcUlpTVFaUHlONUVCam1JNTh4U2F3dUgxdXlJTWg3bmpvdkZHaitBRTVx?=
 =?utf-8?B?Qyt4TzczQnpzeEd6S3l4MTJ3MDNKOGpJUnpnUXlEVFVwN0xPRUx4SG1pbzBv?=
 =?utf-8?B?Y3d0TlNSd21xTHNtZDFKb1Y0eDU5UE1xeWxlYzNheEk4dzA1cTZteVJQTnNl?=
 =?utf-8?B?SzFCVG5MNE0rRTdhajAzY0dLVDdhOXZPeVpVT2RqMWxwajBobHNUbjBsRkFK?=
 =?utf-8?B?ZVNZNTRRbTc0cVpPUFMzVHc3dEhkNWxURkFCeTZXMCtYa0hTdDd0TTJ1aHFj?=
 =?utf-8?B?N3AvYWp1dFFDVGhtVytEaTc3N3FwWTZDeTcwaHpjNEdFQkNtcG5kUEZmeTdQ?=
 =?utf-8?B?S0IwOFhlS1RDTG5UTE5uUHZJVUxNWi9Fb2x6dmFkR29hbWVuSGk2UGlJRW9P?=
 =?utf-8?B?WGJHV05McVVGQ0FEbEcvOWpuQTdaNGR2MVJ2Tzl2cHppMVVnRWtDbXJmS3hS?=
 =?utf-8?B?SHloWjU2T1B0VG9YZlpXNE5idkpRRDV2MUFkS0ZzcEJSMkppVjV4TXNQMXkz?=
 =?utf-8?B?RDUzUkZJRDB2T2Q4aStHTTBSVVFJQy9zL3VYcTluUmdDVVlBQVhSS0JJTEVF?=
 =?utf-8?B?VFpwT3QydGJER25POWdTOE1NRXVzRlBBSHNvZGRvaTAzeTNkbUpoVndnUGM3?=
 =?utf-8?B?bjdYamVWRHNpOG5XMy90b0NZSkNUeVZ0Vyt4Q3lpckZURkF4N3NicVJaRTMv?=
 =?utf-8?B?TDRFMnJTdGQ2SEtBVE1RWjcwT1RLQVZISEZGd0RzQjFWOWtoUmNHbU4xcXg3?=
 =?utf-8?B?ckJGbHVweGNGdGVpVE5sYmhNQzU4d2diNlBtYko2dmlCa1JvTk9MeDgyaHgw?=
 =?utf-8?B?NEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6D1EE7704DEACD4A8CD5BC4716347175@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86cc5e4d-5252-4746-bab1-08dc42d7dcdc
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2024 21:03:27.0543
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IqEKD3SKKdpMkgXaVNM9TnhgWHKi4FzbbcBTh9iNIycGAh/Z35WQu7uGYgqjlMNjjL5nD9oFcFx0BY+YFVoEBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7331
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTAzLTEyIGF0IDA5OjU0IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUdWUsIE1hciAxMiwgMjAyNCwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIDI4
LzAyLzIwMjQgMTI6MjAgcG0sIFBhb2xvIEJvbnppbmkgd3JvdGU6DQo+ID4gPiBGcm9tOiBJc2Fr
dSBZYW1haGF0YSA8aXNha3UueWFtYWhhdGFAaW50ZWwuY29tPg0KPiA+ID4gDQo+ID4gPiBUbyBz
dXBwb3J0IFREWCwgS1ZNIGlzIGVuaGFuY2VkIHRvIG9wZXJhdGUgd2l0aCAjVkUuICBGb3IgVERY
LCBLVk0gdXNlcyB0aGUNCj4gPiA+IHN1cHByZXNzICNWRSBiaXQgaW4gRVBUIGVudHJpZXMgc2Vs
ZWN0aXZlbHksIGluIG9yZGVyIHRvIGJlIGFibGUgdG8gdHJhcA0KPiA+ID4gbm9uLXByZXNlbnQg
Y29uZGl0aW9ucy4gIEhvd2V2ZXIsICNWRSBpc24ndCB1c2VkIGZvciBWTVggYW5kIGl0J3MgYSBi
dWcNCj4gPiA+IGlmIGl0IGhhcHBlbnMuICBUbyBiZSBkZWZlbnNpdmUgYW5kIHRlc3QgdGhhdCBW
TVggY2FzZSBpc24ndCBicm9rZW4NCj4gPiA+IGludHJvZHVjZSBhbiBvcHRpb24gZXB0X3Zpb2xh
dGlvbl92ZV90ZXN0IGFuZCB3aGVuIGl0J3Mgc2V0LCBCVUcgdGhlIHZtLg0KPiA+IA0KPiA+IEkg
YW0gd29uZGVyaW5nIGZyb20gSFcncyBwb2ludCBvZiB2aWV3LCBpcyBpdCBPSyBmb3IgdGhlIGtl
cm5lbCB0bw0KPiA+IGV4cGxpY2l0bHkgc2VuZCAjVkUgSVBJLCBpbiB3aGljaCBjYXNlLCBJSVVD
LCB0aGUgZ3Vlc3QgY2FuIGxlZ2FsbHkgZ2V0IHRoZQ0KPiA+ICNWRSB3L28gYmVpbmcgYSBURFgg
Z3Vlc3Q/DQo+IA0KPiBPb2gsIGZ1bi4gIFNob3J0IGFuc3dlcjogdGhlcmUncyBub3RoaW5nIHRv
IHdvcnJ5IGFib3V0IGhlcmUuDQo+IA0KPiBMZWdhbGx5LCBuby4gIFZlY3RvcnMgMC0zMSBhcmUg
cmVzZXJ2ZWQuICBIb3dldmVyLCBJIGRvIF90aGlua18gdGhlIGd1ZXN0IGNvdWxkDQo+IHRlY2hu
aWNhbGx5IHNlbmQgSVBJcyBvbiB2ZWN0b3JzIDE2LTMxLCBhcyB0aGUgbG9jYWwgQVBJQyBkb2Vz
bid0IG91dHJpZ2h0IHJlamVjdA0KPiBzdWNoIHZlY3RvcnMuICBCdXQgc3VjaCBzb2Z0d2FyZSB3
b3VsZCBiZSBpbiBjbGVhciB2aW9sYXRpb24gb2YgdGhlIFNETS4NCj4gDQo+ICAgMTEuNS4yIFZh
bGlkIEludGVycnVwdCBWZWN0b3JzDQo+ICAgDQo+ICAgVGhlIEludGVsIDY0IGFuZCBJQS0zMiBh
cmNoaXRlY3R1cmVzIGRlZmluZSAyNTYgdmVjdG9yIG51bWJlcnMsIHJhbmdpbmcgZnJvbQ0KPiAg
IDAgdGhyb3VnaCAyNTUgKHNlZSBTZWN0aW9uIDYuMiwg4oCcRXhjZXB0aW9uIGFuZCBJbnRlcnJ1
cHQgVmVjdG9yc+KAnSkuIExvY2FsIGFuZA0KPiAgIEkvTyBBUElDcyBzdXBwb3J0IDI0MCBvZiB0
aGVzZSB2ZWN0b3JzIChpbiB0aGUgcmFuZ2Ugb2YgMTYgdG8gMjU1KSBhcyB2YWxpZA0KPiAgIGlu
dGVycnVwdHMuDQo+ICAgDQo+ICAgV2hlbiBhbiBpbnRlcnJ1cHQgdmVjdG9yIGluIHRoZSByYW5n
ZSBvZiAwIHRvIDE1IGlzIHNlbnQgb3IgcmVjZWl2ZWQgdGhyb3VnaA0KPiAgIHRoZSBsb2NhbCBB
UElDLCB0aGUgQVBJQyBpbmRpY2F0ZXMgYW4gaWxsZWdhbCB2ZWN0b3IgaW4gaXRzIEVycm9yIFN0
YXR1cw0KPiAgIFJlZ2lzdGVyIChzZWUgU2VjdGlvbiAxMS41LjMsIOKAnEVycm9yIEhhbmRsaW5n
4oCdKS4gVGhlIEludGVsIDY0IGFuZCBJQS0zMg0KPiAgIGFyY2hpdGVjdHVyZXMgcmVzZXJ2ZSB2
ZWN0b3JzIDE2IHRocm91Z2ggMzEgZm9yIHByZWRlZmluZWQgaW50ZXJydXB0cywNCj4gICBleGNl
cHRpb25zLCBhbmQgSW50ZWwtcmVzZXJ2ZWQgZW5jb2RpbmdzIChzZWUgVGFibGUgNi0xKS4gSG93
ZXZlciwgdGhlIGxvY2FsDQo+ICAgQVBJQyBkb2VzIG5vdCB0cmVhdCB2ZWN0b3JzIGluIHRoaXMg
cmFuZ2UgYXMgaWxsZWdhbC4NCj4gDQo+ICAgV2hlbiBhbiBpbGxlZ2FsIHZlY3RvciB2YWx1ZSAo
MCB0byAxNSkgaXMgd3JpdHRlbiB0byBhbiBMVlQgZW50cnkgYW5kIHRoZSBkZWxpdmVyeQ0KPiAg
IG1vZGUgaXMgRml4ZWQgKGJpdHMgOC0xMSBlcXVhbCAwKSwgdGhlIEFQSUMgbWF5IHNpZ25hbCBh
biBpbGxlZ2FsIHZlY3RvciBlcnJvciwNCj4gICB3aXRob3V0IHJlZ2FyZCB0byB3aGV0aGVyIHRo
ZSBtYXNrIGJpdCBpcyBzZXQgb3Igd2hldGhlciBhbiBpbnRlcnJ1cHQgaXMgYWN0dWFsbHkNCj4g
ICBzZWVuIG9uIHRoZSBpbnB1dC4NCg0KSSBoYXRlIHRoZSAibWF5IiBoZXJlIDotKQ0KDQo+IA0K
PiB3aGVyZSBUYWJsZSA2LTEgZGVmaW5lcyB0aGUgdmFyaW91cyBleGNlcHRpb25zLCBpbmNsdWRp
bmcgI1ZFLCBhbmQgZm9yIHZlY3RvcnMNCj4gMjItMzEgc2F5cyAiSW50ZWwgcmVzZXJ2ZWQuIERv
IG5vdCB1c2UuIiAgVmVjdG9ycyAzMi0yNTUgYXJlIGV4cGxpY2l0bHkgZGVzY3JpYmVkDQo+IGFz
ICJVc2VyIERlZmluZWQgKE5vbi1yZXNlcnZlZCkgSW50ZXJydXB0cyIgdGhhdCBjYW4gYmUgZ2Vu
ZXJhdGVkIHZpYSAiRXh0ZXJuYWwNCj4gaW50ZXJydXB0IG9yIElOVCBuIGluc3RydWN0aW9uLiIN
Cj4gDQo+IEhvd2V2ZXIsIElOVG4gaXMgZmFyIG1vcmUgaW50ZXJlc3RpbmcgdGhhbiBJUElzLCBh
cyBJTlRuIGNhbiBkZWZpbml0ZWx5IGdlbmVyYXRlDQo+IGludGVycnVwdHMgZm9yIHZlY3RvcnMg
MC0zMSwgYW5kIHRoZSBsZWdhbGl0eSBvZiBzb2Z0d2FyZSBnZW5lcmF0aW5nIHN1Y2ggaW50ZXJy
dXB0cw0KPiBpcyBxdWVzdGlvbmFibGUuICBFLmcuIEtWTSB1c2VkIHRvICJmb3J3YXJkIiBOTUkg
Vk0tRXhpdHMgdG8gdGhlIGtlcm5lbCBieSBkb2luZw0KPiBJTlRuIHdpdGggdmVjdG9yIDIuDQo+
IA0KPiBLZXkgd29yZCAiaW50ZXJydXB0cyIhICBJUElzIGFyZSBoYXJkd2FyZSBpbnRlcnJ1cHRz
LCBhbmQgSU5UbiBnZW5lcmF0ZXMgc29mdHdhcmUNCj4gaW50ZXJydXB0cywgbmVpdGhlciBvZiB3
aGljaCBhcmUgc3ViamVjdCB0byBleGNlcHRpb24gYml0bWFwIGludGVyY2VwdGlvbjoNCj4gDQo+
ICAgRXhjZXB0aW9ucyAoZmF1bHRzLCB0cmFwcywgYW5kIGFib3J0cykgY2F1c2UgVk0gZXhpdHMg
YmFzZWQgb24gdGhlIGV4Y2VwdGlvbg0KPiAgIGJpdG1hcCAoc2VlIFNlY3Rpb24gMjUuNi4zKS4g
SWYgYW4gZXhjZXB0aW9uIG9jY3VycywgaXRzIHZlY3RvciAoaW4gdGhlIHJhbmdlDQo+ICAgMOKA
kzMxKSBpcyB1c2VkIHRvIHNlbGVjdCBhIGJpdCBpbiB0aGUgZXhjZXB0aW9uIGJpdG1hcC4gSWYg
dGhlIGJpdCBpcyAxLCBhIFZNDQo+ICAgZXhpdCBvY2N1cnM7IGlmIHRoZSBiaXQgaXMgMCwgdGhl
IGV4Y2VwdGlvbiBpcyBkZWxpdmVyZWQgbm9ybWFsbHkgdGhyb3VnaCB0aGUNCj4gICBndWVzdCBJ
RFQuIFRoaXMgdXNlIG9mIHRoZSBleGNlcHRpb24gYml0bWFwIGFwcGxpZXMgYWxzbyB0byBleGNl
cHRpb25zIGdlbmVyYXRlZA0KPiAgIGJ5IHRoZSBpbnN0cnVjdGlvbnMgSU5UMSwgSU5UMywgSU5U
TywgQk9VTkQsIFVEMCwgVUQxLCBhbmQgVUQyLg0KPiANCj4gd2l0aCBhIGZvb3Rub3RlIHRoYXQg
ZnVydGhlciBzYXlzOg0KPiANCj4gICBJTlQxIGFuZCBJTlQzIHJlZmVyIHRvIHRoZSBpbnN0cnVj
dGlvbnMgd2l0aCBvcGNvZGVzIEYxIGFuZCBDQywgcmVzcGVjdGl2ZWx5LA0KPiAgIGFuZCBub3Qg
dG8gSU5UIG4gd2l0aCB2YWx1ZSAxIG9yIDMgZm9yIG4uDQo+IA0KPiBTbyB3aGlsZSBhIG1pc2Jl
aGF2aW5nIGd1ZXN0IGNvdWxkIGdlbmVyYXRlIGEgc29mdHdhcmUgaW50ZXJydXB0IG9uIHZlY3Rv
ciAyMCwNCj4gaXQgd291bGQgbm90IGJlIGEgdHJ1ZSAjVkUsIGkuZS4gbm90IGFuIGV4Y2VwdGlv
biwgYW5kIHRodXMgd291bGQgbm90IGdlbmVyYXRlDQo+IGFuIEVYQ0VQVElPTl9OTUkgVk0tRXhp
dC4gIEkuZS4gdGhlIEtWTV9CVUdfT04oKSBjYW4ndCBiZSB0cmlnZ2VyZWQgYnkgdGhlIGd1ZXN0
DQo+IChhc3N1bWluZyBoYXJkd2FyZSBpc24ndCBicm9rZW4pLg0KPiANCg0KQWgsIHJpZ2h0LCBz
b2Z0d2FyZS1pbnRlcnJ1cHRzIGJ1dCBub3QgZXhjZXB0aW9ucy4gwqANCg0KVGhhbmtzIGZvciB0
aGUgZnVsbCBleHBsYW5hdGlvbiENCg==

