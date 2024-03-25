Return-Path: <kvm+bounces-12586-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B15F88A4D0
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 15:40:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CBBF91C3C036
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 14:40:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48AB316EBF5;
	Mon, 25 Mar 2024 11:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="l7lGnvSl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404271553B0;
	Mon, 25 Mar 2024 11:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711365273; cv=fail; b=cQrR1vC/0ke9yx8z4mHnn4VFBzHStIjQLhgxzIze4HUTVEbc3eODwAkTafTYau5W4C+kRWZOOzKiQvv7sH482ar0m4LAX/wE5ykXdDwEpWO6WjFQQ55ht67im053tJrV8zBJRB1OtQcYOneapyFus5mX1rHAsTbch7w8HShvy5U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711365273; c=relaxed/simple;
	bh=EinLgOuo93YcD1q34mSDGQgzQf6Cevi/WNcgpJ4+hSk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Jcz/qbExR+ibydPmgr6kJsWjq9872lFegpWgrljUWf6YpGUT/au8v8VtDU7BlAm/a0jaLw1Ay67IGtUjRy9ITR9cUrHxAKqQzjBvq6UHWm9U7wABUFdUtJO5CFQUak0/cqxx5ZH06nFhKk3JIfmuUQtFm7FhrpoKNsvSHJLzfcg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=l7lGnvSl; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711365271; x=1742901271;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=EinLgOuo93YcD1q34mSDGQgzQf6Cevi/WNcgpJ4+hSk=;
  b=l7lGnvSlnAktCk11bqRdKE8VhZxGb2Sw7vcJTcxStamxtqTU0uq5DCvP
   bu6DcgukMBogYDyc79Z9BUAUj1WiXiZUfbgBvNDIPPrpcu5cSItPlecHI
   18CfSBX3GIUDC2B4b/5M//RE4hTpDpzspBkA6REL8vLpEdHYkaMegy95/
   D8IWamsVgwSs9AYq4nEGfGYI9U26F/H9ryrzaHCYeWhsAqdhTQqAVv3Tb
   Ywx986vdztWYmZwUMYZ5TFpkSguufSEpyM0m/lfU7yTiekvPAMrR7wUbr
   X4p+m3VnBzs6QOvJ+fpAxAsmpk4dt8KTRsHat2eCs4hf6h+1h+irl4Jvl
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11023"; a="6541723"
X-IronPort-AV: E=Sophos;i="6.07,153,1708416000"; 
   d="scan'208";a="6541723"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2024 04:14:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,153,1708416000"; 
   d="scan'208";a="15531083"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa007.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Mar 2024 04:14:30 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 25 Mar 2024 04:14:29 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 25 Mar 2024 04:14:28 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 25 Mar 2024 04:14:28 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 25 Mar 2024 04:14:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FfHRQtFX8Dxyx0sjGnsrLedwcbtnooC6rARxaUxI8ZM/CIZGszBNmlFmexoNgaU/H7b5CrfpJMuDgXoj9YFo5ETuOmpXWGMPiyC3rR9ToPyKAVE97sWoEm/VRvBXPVQnVfaLWJVC4YHpis4U5OBUrNaoBD2iKtoH11byrPVW61GkF2VCuznjG0W0XHViz/OvPWBrFrOfK/f57/861vNqZW5X+3DfROFp14UEfZKM8hFWmcPeIUDTlzogrmJPvgBFaG9KFZ2c0n7rVG5mGCXFZ3QarfUGDU7Q3RU49goBccNLMFT2RwuYU98TBpMSlP0LofJTZOohaqiZYeabyNAQCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EinLgOuo93YcD1q34mSDGQgzQf6Cevi/WNcgpJ4+hSk=;
 b=hktPcZb69zFVhvcfg8tLEoUvoRJdMdPoetosfaAuONnpe9yPSLg2Men8zRo28hK79EwsUmrd/25M5zvQEyOMXsKYOz0IcfFq28Df/eGqNMyO/LyVlQkGEilIPj6KhVFiNFdhx95xH+0yoaYpDqkdCFr8Qs1O1Y/PSpE0XTkL46VCXaFmxiR4V+44NpBAMnvsjnRQ9IbVhhyHUhRUcTw0v96DAYsS02n5JopAmeTxGgM43jwDB7CXeoKGVUU745KvRBB+yxmfdAEgDaWtjaTxGQIk8IBc4Xxecktxk0HjnlscZrQl9leQC4FbDXsc2MJyTp7UJlCIFnVkPzIONoonAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW4PR11MB5909.namprd11.prod.outlook.com (2603:10b6:303:168::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Mon, 25 Mar
 2024 11:14:21 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7409.028; Mon, 25 Mar 2024
 11:14:21 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v19 130/130] RFC: KVM: x86, TDX: Add check for
 KVM_SET_CPUID2
Thread-Topic: [PATCH v19 130/130] RFC: KVM: x86, TDX: Add check for
 KVM_SET_CPUID2
Thread-Index: AQHaaI3pGtqdMwRKM0+4jyn/TYFtbbFC+UEAgACFugCAAJXEAIAEZUyA
Date: Mon, 25 Mar 2024 11:14:21 +0000
Message-ID: <bea6cb485ba67f0160c6455c77cf75e5b6f8eaf8.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <d394938197044b40bbe6d9ce2402f72a66a99e80.1708933498.git.isaku.yamahata@intel.com>
	 <e1eb51e258138cd145ec9a461677304cb404cc43.camel@intel.com>
	 <cfe0def93375acf0459f891cc77cb68d779bd08c.camel@intel.com>
	 <f019df484b2fb636b34f64b1126afa7d2b086c88.camel@intel.com>
In-Reply-To: <f019df484b2fb636b34f64b1126afa7d2b086c88.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW4PR11MB5909:EE_
x-ms-office365-filtering-correlation-id: 22e7641b-0c21-4ebf-2ee2-08dc4cbcb8a8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5erwxqLkJkDr9X6kc7BhAiNPEvuNGgSbQosvLiqDYQ5SfbyV6dfcW7idl0kA1uD7zCAFtyyoG0GYT7yjpCG5TqapFKzuGkCXhxmujj4cz5wxieHJ+YBPhrNXMcySzlOEDbGEkUICsLQOdwk4XHeivbuQpwRridLPUSikxCIAY00FHjgmOk/XsR5JQcYstWrBjxaf+CUVlZ/3af5DZ/UYD7mjRLbFi/1XbpdVAD9UOZorR63/CFMrhBORHBnaqZ7lf7iS+4ZEBJ3oeQpfy//g2qMPJcEzKXzg6+99ECifWyjm5GoFidYTpXPxueOSZAnN1XY5h47/nx1Nv+gPipUnf2986jJbsvv5Nw2LoDg6KP2sRNZB+r6mSjM2gkM64sI8hUNmaImBZu/C5UXx7W9GMzv0kOfliXV6zdanZkniaDwE/BzBpkyDBCLWvUP+MmTezLmg9sPfKHDdzr+f7Owl55LiXJRaZ6AkIu5D4LfIC4vHsFy0RxbxxiFHPjc60wm7rFmzAQy2Kl/3+VSDftWd56/ssW1X22ose7A7pHjpLZro3d1ZjjzI2HWC5+xRNRk1LS/NPgnsatdECeqVh2siZ6IxmTPug2l/tYK69NOfsle/Pc7b0u7IB1MGuxQjY5LIi5iX/s8pXCpzpWSJWKf4jo05UWfTIVh2qgKoG7t9FT58ffUsJdIw1xd3Y+HJ8tajjQjUo5QCAY2O4DzsOTGz76DBNGn0+GsXh/xVauDJtX4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eG55eitMaFoydk1SRDBDUUNzV2RKOHppbUNIYUQ0eEtTUVJWaEVzZmF0aDZT?=
 =?utf-8?B?THBZRU92Z3U0OHlsdERiVVYwZ1RXNjBCUzRUeXVRRnRManBJVmRaTVJ1dFVJ?=
 =?utf-8?B?eHNKNjczREYzbG5jUURYYmcwbTVSRGpWNDZwd0hBRnFwaVMxczNCSDI4Uk5O?=
 =?utf-8?B?WjJZdk5BbFBGd08yaDI0UjQraW5IYjV1K0Zxck5TQzFBeHpmWkJKK2RicDU5?=
 =?utf-8?B?WXNMRDZabGxnenJaeVhDbkUySkN4V1VVYVZCNG5TT3pxUHRTUldOdWhaVkV1?=
 =?utf-8?B?SEpZUkYwRERvQmh2T21Bb0RtaEhKUlZvVlV4bmd1NEhISXZwWXZaN2ZSVXVX?=
 =?utf-8?B?VDRxeFI2MDBaeEV1WExySkJHbXpPQVZSS2l0RExZZzRoVHBOT1poRElzd2dF?=
 =?utf-8?B?bnRsUHFUNWdQSGNMZVlNNW9vRjluSERZVGJ3T1VlTzFaam50TndXSnRZSzR4?=
 =?utf-8?B?QXpjTDZxa3d4Rmk0VGFDSmtCZnVRTlIwOUlHSXpnRjBTVjFoZnpaRm9JenIv?=
 =?utf-8?B?RENiS1AxMWhrdjJSeWUyYVFTOVZ2cS9wZndGQ3I5Y3EyR0Fqang4a0dQZVdy?=
 =?utf-8?B?L01Db0hnVlpSWjJFZFRYTnIvRTU5UThiUFROU2NIUXN6VWdxMTF0MDF4QlNF?=
 =?utf-8?B?ZGNveHhmRnJZM05Pd0dsNlZGWXROMSt3ME15Q09GU0tTVGY0d1dML3FEVzRG?=
 =?utf-8?B?RFdWQUhCeTd2UnR4L0ptdm1XaEU1cmR2RnJvenhKUUU3bXB1K2U3NnE0ejBO?=
 =?utf-8?B?ZnFIQkZCeUNkaTg1ekhmMi9YMFRsZDd2R2NSckdGTC9RbHZoNGsxZmEzZzhW?=
 =?utf-8?B?ZitKVTljWVZ3TitTZGl2aldpTnhDWGtpY0VnNVR6YjJCaGlNYnJWN3VWM3dB?=
 =?utf-8?B?UW01bWhiY2Q1bkFxd2g0Zks1Y2dFTDVOQTBjMEc2S29Ta04wVy9wb0ExS2tG?=
 =?utf-8?B?R3RWMDVPTkR0azcyR2h4UmVjbHhxQWRKcGZLVFFhWGw4clZPQUd0ZTkvK0p3?=
 =?utf-8?B?REQydUZpZExxUlBsSE5QNERiMVM0eFQ5V3ZBQVRoY3FNTERxTXZRc0lKL1F5?=
 =?utf-8?B?QVJ1bXEzdUxpaVBkVEFCMzlQR1BXelIxS0F0V2ZFUXh3NXRPMWhiZFliTEJT?=
 =?utf-8?B?QjNpZ2xRcnVIYmg1cmVac2dmdDBNT0V3Y0w1eW9kMWtXZldJS3ZWNEZHaWo4?=
 =?utf-8?B?VUg3WVhCeWlNcDh4akJYSnRTKzhHL1dkOVA5blZ0dWdXTkd4cnR4d0w3TDFJ?=
 =?utf-8?B?V3F3QU85Z3FZRkc3aWtxYThiRlZnSHcvd25CWTZjdDBGbks0cVd6MlFhSldy?=
 =?utf-8?B?VXpuSkdMSE1Xd0ZlYTc5bFpyYmNodTdneVRaLzVDdUJlZnlJQ1JGMVhUNDgx?=
 =?utf-8?B?c1VNMXQ5N3BPd0xkMUI4OGRNbTFzdWJwdXh4SFppWVM5QnV3QklVQ1RnYi9n?=
 =?utf-8?B?eThjcFQvdmZzMjJISk9YeEFMTHFMNlJTc3p4dVdNQUNaenFhZFZvL0lXNmxm?=
 =?utf-8?B?dVN0cXI3b2N0eHQ2VFk5VHFIQnF4cmJUT2JkWFZ5bDZlbGJlaFdrSURTeGJk?=
 =?utf-8?B?VUFLeThoVGlzN2trUjljVDJlcHpSNFhvN29tdkRBTEh1MmFTY2VLVHMxOXg4?=
 =?utf-8?B?QXBmTm9CMTh4VisyUFFoNWFpYVZzTjJYeFh3bXVwSjMyN0pWWko0TDE5YlJ3?=
 =?utf-8?B?OW9TejlCYXJBU09mbk1VQmJsZC9VTEpCQkF4Q3lZanF4ZUJJd0pOSWo0d2dZ?=
 =?utf-8?B?cm96K0haNERyMlJqOFc2UHp0RnlBdGliMXBJQllKQW1ZRC9qZEFVdU5TU0ZQ?=
 =?utf-8?B?VkZmT2w5Q2pUNUt5UStOK2xCYS81Q1NId0JaclUyYUNKVUdrc0E3Ky9BdEtu?=
 =?utf-8?B?SldtREhYS3RndTRldEJuaENGbUlHdXRvVUJrbk1hNVhUZ1RuUzVzanorTktL?=
 =?utf-8?B?WTl6enhFRVE0STJKL1BnQ0Zhd2RNRkxUZm1RS0lVME9Da3VwNXVpdWhIV2Jv?=
 =?utf-8?B?NC9pVFlORm8vOVpIUkp2WFdod2lwbWxXTEZYNzV6aDlGTUtTRXFqeDZaZVNy?=
 =?utf-8?B?QW55TEY1eTRjNEQ0RXhxUDI4NHJDd1lDM244MTgyT0duZVJqcVhUMnJhOVVz?=
 =?utf-8?B?V0ExdjQ4a0JKUVhSM3plZ2JJOXZuZzJYeHdTbFllOUk3RzRWL0M5R1JGdWVD?=
 =?utf-8?B?WFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <90B14E875990B94A93BA37B6C2F40265@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22e7641b-0c21-4ebf-2ee2-08dc4cbcb8a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2024 11:14:21.5009
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WndrtX+82qqbXOLxGpYsnhRx85Wc6Rdn/DjFLmbktUvYrPVYH/Aver9SRkqzSB6T1bsFKJJKAcfo+1kAcog2kw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5909
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTAzLTIyIGF0IDE2OjA2ICswMDAwLCBFZGdlY29tYmUsIFJpY2sgUCB3cm90
ZToNCj4gT24gRnJpLCAyMDI0LTAzLTIyIGF0IDA3OjEwICswMDAwLCBIdWFuZywgS2FpIHdyb3Rl
Og0KPiA+ID4gSSBzZWUgdGhhdCB0aGlzIHdhcyBzdWdnZXN0ZWQgYnkgU2VhbiwgYnV0IGNhbiB5
b3UgZXhwbGFpbiB0aGUNCj4gPiA+IHByb2JsZW0NCj4gPiA+IHRoYXQgdGhpcyBpcyB3b3JraW5n
IGFyb3VuZD8gRnJvbSB0aGUgbGlua2VkIHRocmVhZCwgaXQgc2VlbXMgbGlrZQ0KPiA+ID4gdGhl
DQo+ID4gPiBwcm9ibGVtIGlzIHdoYXQgdG8gZG8gd2hlbiB1c2Vyc3BhY2UgYWxzbyBjYWxscyBT
RVRfQ1BVSUQgYWZ0ZXINCj4gPiA+IGFscmVhZHkNCj4gPiA+IGNvbmZpZ3VyaW5nIENQVUlEIHRv
IHRoZSBURFggbW9kdWxlIGluIHRoZSBzcGVjaWFsIHdheS4gVGhlIGNob2ljZXMNCj4gPiA+IGRp
c2N1c3NlZCBpbmNsdWRlZDoNCj4gPiA+IDEuIFJlamVjdCB0aGUgY2FsbA0KPiA+ID4gMi4gQ2hl
Y2sgdGhlIGNvbnNpc3RlbmN5IGJldHdlZW4gdGhlIGZpcnN0IENQVUlEIGNvbmZpZ3VyYXRpb24g
YW5kDQo+ID4gPiB0aGUNCj4gPiA+IHNlY29uZCBvbmUuDQo+ID4gPiANCj4gPiA+IDEgaXMgYSBs
b3Qgc2ltcGxlciwgYnV0IHRoZSByZWFzb25pbmcgZm9yIDIgaXMgYmVjYXVzZSAic29tZSBLVk0N
Cj4gPiA+IGNvZGUNCj4gPiA+IHBhdGhzIHJlbHkgb24gZ3Vlc3QgQ1BVSUQgY29uZmlndXJhdGlv
biIgaXQgc2VlbXMuIElzIHRoaXMgYQ0KPiA+ID4gaHlwb3RoZXRpY2FsIG9yIHJlYWwgaXNzdWU/
IFdoaWNoIGNvZGUgcGF0aHMgYXJlIHByb2JsZW1hdGljIGZvcg0KPiA+ID4gVERYL1NOUD8NCj4g
PiANCj4gPiBUaGVyZSBtaWdodCBiZSB1c2UgY2FzZSB0aGF0IFREWCBndWVzdCB3YW50cyB0byB1
c2Ugc29tZSBDUFVJRCB3aGljaA0KPiA+IGlzbid0IGhhbmRsZWQgYnkgdGhlIFREWCBtb2R1bGUg
YnV0IHB1cmVseSBieSBLVk0uwqAgVGhlc2UgKFBWKSBDUFVJRHMNCj4gPiBuZWVkIHRvIGJlDQo+
ID4gcHJvdmlkZWQgdmlhIEtWTV9TRVRfQ1BVSUQyLg0KPiANCj4gUmlnaHQsIGJ1dCBhcmUgdGhl
cmUgYW55IG5lZWRlZCB0b2RheT/CoA0KPiANCg0KSSBhbSBub3Qgc3VyZS4gIElzYWt1IG1heSBr
bm93IGJldHRlcj8NCg0KPiBJIHJlYWQgdGhhdCBTZWFuJ3MgcG9pbnQgd2FzDQo+IHRoYXQgS1ZN
X1NFVF9DUFVJRDIgY2FuJ3QgYWNjZXB0IGFueXRoaW5nIHRvZGF5IHdoYXQgd2Ugd291bGQgd2Fu
dCB0bw0KPiBibG9jayBsYXRlciwgb3RoZXJ3aXNlIGl0IHdvdWxkIGludHJvZHVjZSBhIHJlZ3Jl
c3Npb24uIFRoaXMgd2FzIHRoZQ0KPiBtYWpvciBjb25zdHJhaW50IElJVUMsIGFuZCBtZWFucyB0
aGUgYmFzZSBzZXJpZXMgcmVxdWlyZXMgKnNvbWV0aGluZyoNCj4gaGVyZS4NCj4gDQo+IElmIHdl
IHdhbnQgdG8gc3VwcG9ydCBvbmx5IHRoZSBtb3N0IGJhc2ljIHN1cHBvcnQgZmlyc3QsIHdlIGRv
bid0IG5lZWQNCj4gdG8gc3VwcG9ydCBQViBDUFVJRHMgb24gZGF5IDEsIHJpZ2h0Pw0KPiANCj4g
U28gSSdtIHdvbmRlcmluZywgaWYgd2UgY291bGQgc2hyaW5rIHRoZSBiYXNlIHNlcmllcyBieSBn
b2luZyB3aXRoDQo+IG9wdGlvbiAxIHRvIHN0YXJ0LCBhbmQgdGhlbiBleHBhbmRpbmcgaXQgd2l0
aCB0aGlzIHNvbHV0aW9uIGxhdGVyIHRvDQo+IGVuYWJsZSBtb3JlIGZlYXR1cmVzLiBEbyB5b3Ug
c2VlIGEgcHJvYmxlbSBvciBjb25mbGljdCB3aXRoIFNlYW4ncw0KPiBjb21tZW50cz8NCj4gDQo+
IA0KDQpUbyBjb25maXJtLCBJIG1lYW4geW91IHdhbnQgdG8gc2ltcGx5IG1ha2UgS1ZNX1NFVF9D
UFVJRDIgcmV0dXJuIGVycm9yIGZvciBURFgNCmd1ZXN0Pw0KDQpJdCBpcyBhY2NlcHRhYmxlIHRv
IG1lLCBhbmQgSSBkb24ndCBzZWUgYW55IGNvbmZsaWN0IHdpdGggU2VhbidzIGNvbW1lbnRzLg0K
DQpCdXQgSSBkb24ndCBrbm93IFNlYW4ncyBwZXJmZXJlbmNlLiAgQXMgaGUgc2FpZCwgSSB0aGlu
ayAgdGhlIGNvbnNpc3RlbmN5DQpjaGVja2luZyBpcyBxdWl0ZSBzdHJhaWdodC1mb3J3YXJkOg0K
DQoiDQpJdCdzIG5vdCBjb21wbGljYXRlZCBhdCBhbGwuICBXYWxrIHRocm91Z2ggdGhlIGxlYWZz
IGRlZmluZWQgZHVyaW5nDQpUREguTU5HLklOSVQsIHJlamVjdCBLVk1fU0VUX0NQVUlEIGlmIGEg
bGVhZiBpc24ndCBwcmVzZW50IG9yIGRvZXNuJ3QgbWF0Y2gNCmV4YWN0bHkuDQoiDQoNClNvIHRv
IG1lIGl0J3Mgbm90IGEgYmlnIGRlYWwuIA0KDQpFaXRoZXIgd2F5LCB3ZSBuZWVkIGEgcGF0Y2gg
dG8gaGFuZGxlIFNFVF9DUFVJRDI6DQoNCjEpIGlmIHdlIGdvIG9wdGlvbiAxKSAtLSB0aGF0IGlz
IHJlamVjdCBTRVRfQ1BVSUQyIGNvbXBsZXRlbHkgLS0gd2UgbmVlZCB0byBtYWtlDQp2Y3B1J3Mg
Q1BVSUQgcG9pbnQgdG8gS1ZNJ3Mgc2F2ZWQgQ1BVSUQgZHVyaW5nIFRESC5NTkcuSU5JVC4NCg0K
MikgaWYgd2UgZG8gY29uc2lzdGVuY3kgY2hlY2ssIHdlIGRvIGEgZm9yIGxvb3AgYW5kIHJlamVj
dCB3aGVuIGluLWNvbnNpc3RlbmN5DQpmb3VuZC4NCg0KSSdsbCBsZWF2ZSB0byB5b3UgdG8ganVk
Z2UgOi0pDQoNCg==

