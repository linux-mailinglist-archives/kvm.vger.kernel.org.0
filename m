Return-Path: <kvm+bounces-13612-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B795898F81
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 22:18:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AE4121C211EF
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 20:18:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B0541350D8;
	Thu,  4 Apr 2024 20:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="C11MCST4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71FA134730;
	Thu,  4 Apr 2024 20:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712261928; cv=fail; b=ZcbMdBiv99W5MpSQsYdWM7cAwNDMtNFOcHWa+2cqXRJ/0CtVf0jSUs39WMqhbJmAtG2OzG2zy282e/KHArEXdC2VW5UPkIO8ZBVFVjU8HkIbI+xGrPxcRTsAjU7j0EnnxYSIQ15EAyMERDx1i1+hgOkSCgapPNjuLRyHg7DTuj0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712261928; c=relaxed/simple;
	bh=iztWxcZjkJ9mMq0xVrhF+mQfkS1qPz47+q1b86hkeQA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MaReL6Sd2kL8U0D9M1EbIxNuevzMnPLraj/HHGEOBUnW6oeAj2odRyokNY+fY8thdrCRYoK5iOnkxk20mqfut9VjtiKbCdrQ92XNldd618+c0A0k4qm62MY2rS8ng60qu2ijLpbz8IfUeh9XkqMzwPO3tu4EBjmRs4ohcqKQGds=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=C11MCST4; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712261926; x=1743797926;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=iztWxcZjkJ9mMq0xVrhF+mQfkS1qPz47+q1b86hkeQA=;
  b=C11MCST49JsEHE0G8f7FYyA0KK5x7lrUzBrKcbewjTV0nP7I0Cz0LOog
   a9T8IsyP8HcBjhazEDeUljrMomTOek9RGSHTMy+ByPDKpjgzaLoUiiAoy
   2YPMAyniZ6/l8YSx15FuRL9N3Z35UFY3GUEg87lhdk3LqHK1jD5aCTSDx
   h7cMx1E+aoVz0a8AXtCPETUu6zZtg3wIQh6fVtZPAjDbYs/9E0uYHxIxu
   Y56e821ySALGgYpP2zzUdjb75MEITikJyOwk3fAkp4T2rvVxUZFP7Ul6k
   TKWPTE7C/m8QlRafOIRHVdouXl7ys3cdsF0zBYpLuBLKPMwNBVBEDe7El
   A==;
X-CSE-ConnectionGUID: I09iyLPBRo+O+e8q+GpT9g==
X-CSE-MsgGUID: Tau3aPLwQK2MO8pneJpxiA==
X-IronPort-AV: E=McAfee;i="6600,9927,11034"; a="7477991"
X-IronPort-AV: E=Sophos;i="6.07,180,1708416000"; 
   d="scan'208";a="7477991"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Apr 2024 13:18:46 -0700
X-CSE-ConnectionGUID: 8bJLHv6ASyqkmci6y2nEsg==
X-CSE-MsgGUID: lxHQRoocQRGBi5aIKF5f+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,180,1708416000"; 
   d="scan'208";a="50154319"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Apr 2024 13:18:45 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 4 Apr 2024 13:18:44 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 4 Apr 2024 13:18:44 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 4 Apr 2024 13:18:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MbYxuynXwxOchU0nSF510zcfHCLPFBPZ3XQ5naw4CAgQ4Gxhi9XhUBEQT9hBHfWbQ06GHDnf13mtvxwLQs3liIJpBNLL8Y5JLsH3/ByMXodRQlW3LDqswlYJrC2uPdz7e9WJXawfU4Av/WBmACBNcs9QRhW68HnWiIB9GuNbyKfW5SL1q1uow13+PQh5tpKX/qrPTU4XwClYcR0e2Www/xZVNvtELtnSXcDMPCumywt8V+caDrzc3zFhgKxU+lQERKBqNm9inoZJvbSOZPXSpL2AVWtYcwv7Q+QI2FU2OOhRIv+jhMjcjX4Pxu7MUA+c8ur5mBl0/ad/QRnISVbEHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iztWxcZjkJ9mMq0xVrhF+mQfkS1qPz47+q1b86hkeQA=;
 b=lCm6ynFZyxpFDqSr1wkdNmZLDiooCRhN8nnLkdclcWIgkFvEklRe9HQQ14yViwq/DuF08MB25vysvk0q9CMygI8VUmBi6D2X+nCxuo/28gHmE/agSJjhcrw2+0/CcuuxCxNCs4RBFnYcGXnoZFZqZN1jKmi2CIxr0c5eCJHrZhI6H75thh8lI3yNSmZws04xnKGBuORAg3821HOJiLRx/gJsP5OufF4mOE1Q0QCFntQgzTHoVeji0y1N0hRzYquam+o83jFE98zEOG1VPWUMtDVxEwwPcyZNXTwLoQh+DBbv36ilkGOSM/2kEh0cK3yHplPeE73uuOOMFqQbkCqQvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW4PR11MB7053.namprd11.prod.outlook.com (2603:10b6:303:221::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.26; Thu, 4 Apr
 2024 20:18:41 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7452.019; Thu, 4 Apr 2024
 20:18:41 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Chen, Bo2"
	<chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Aktas, Erdem"
	<erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v19 002/130] x86/virt/tdx: Move TDMR metadata fields map
 table to local variable
Thread-Topic: [PATCH v19 002/130] x86/virt/tdx: Move TDMR metadata fields map
 table to local variable
Thread-Index: AQHaaI2qQt7rnNhPukmvOGaBmFqLibFYYhiAgABnWgA=
Date: Thu, 4 Apr 2024 20:18:41 +0000
Message-ID: <d3b8d78a204fa59abf5e947a4470d8f62a64521d.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <44d9530187b4b0b1c05e150fa73fe22ab54fc911.1708933498.git.isaku.yamahata@intel.com>
	 <tlq2fqaxnwwcx2qbqb2rvspc4be6zxr7j5o6ezs7a4dvryu5fr@famk4qza3ewc>
In-Reply-To: <tlq2fqaxnwwcx2qbqb2rvspc4be6zxr7j5o6ezs7a4dvryu5fr@famk4qza3ewc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW4PR11MB7053:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9XPEkE2BdlpAv2T5wiuHu9r2Ys7F9ceYYk9ZhI+Jf8V2mdCjvKmuz+m/g68j4uyY0ZMtsB++fAEY1Fl9kgMCybKmct4xVO0cJnA8WPnXEzFHjFIqpCv3z7bLUISz+dm1ZuvJtvJ/jKj4UbP7ntA0Sr8rTPyj35WYKAAMWa1IB3rMfkoX8k/tjXoux3xyFvjC06SIdVoTBC+JADzwc/JcOE6By6eiJP02vHxXvkQB/tbU60/wDVyu7EnkUs9H5gPoTT2mhrPM80CA1Uow06r+LWJYImxKQnwfi1RwnnyR4I/uJxZTdyl7QXniBRv681E9GYiNcDwDTLVxWqOYim5eAQZAo9ZDbW8GOBnagpouZgL+xbQ1nrJK3Ube6n+tsS9A3w9Hy3DiWu2X86wU7icqPeLarf8DxrjlKST/9P5WtI2T6C8KgbVDy7gUeaH59hr7xX6ZangVvYJx3UCkqi0//B3l9XdLeOOEGd/35fV8etkKHSGB9u5YCj69NkmdDAWHAuBUouyYZG1leBYETGCqWoGyxO0dn78yafMdFvRJEZHKrl+U9RwX/NG1psdt1BZT1HxCPoxR0bSHZHFvMBMXCqc3oiZxsXSMxbnxQ5q5iCI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V0hnOG5YOFdNQU1YL1VidUhwMGRycmY0NUVSSlJBbXlxMDdFZWtJVVdIZTNz?=
 =?utf-8?B?VEUwSWRDVkhEZHZ3TzhOdHVmVzI4dis1d1VyMllVaGt3UmdGem5QVS9tY1Rt?=
 =?utf-8?B?eEx0S3Y2b1VpT1NJcm5tS2FnYk5NU1hrWEhvbVRzcGRVZTl3Q1kxdnZXZEwz?=
 =?utf-8?B?ME9ieFhWcUVjQ0xLZE9qQ0dKOWZ6M2N0cDA2OENadVpwRGZ4OWNZa2t5NnFB?=
 =?utf-8?B?Z2xHTXdHeFRpLzVQQVNhYll0QThEM05qd0p0bmV0YjFxN3RqaVp5a2crNzhV?=
 =?utf-8?B?RHpITVBKSklQK2tHL1A2dWYyMHNxbEE3SStieG1JV1Jka1hwYkVYdW01TDBk?=
 =?utf-8?B?bVpEU0IxRGZEOVhrQUdtaVVlQkpxTE1aNTZxMnMzWTNsTjd0T3JYYzRTWlZJ?=
 =?utf-8?B?bWVVMm9NK0drSXRha2JLM2gzMElWUXVncFBkMVRjd2lrY1FWbFlkYlkzeXZH?=
 =?utf-8?B?TUJVazI4R2xlWHBrUzVCaGlRUDFHRnhOc1lyQ3N1dTgzYUtOb2JuRTcraE1p?=
 =?utf-8?B?ZlhlZmViRWhQZkFtVm83K0hyb095c0U2cUdBMVhKdE1NeDNROXp2ZWM1VVFG?=
 =?utf-8?B?WFFVd3FTM1p5alhueURaanBQK1NhS0xvMkRnc3ZDMVlDQmY1WVpZYlh4WW1G?=
 =?utf-8?B?ZE8yQTZMK0FkdEFLR09aYlNvc0FUSWRqbWNwSWQwdExxTFVUbGF3YTJQU0dG?=
 =?utf-8?B?WSswclducFZ1RVVCRU1GRE54Y0xGdkxXNmpQSVppQnVYZ1J6MHVaZUx6Vk5I?=
 =?utf-8?B?a2RLbFBoYWFNbldCWGRxUUJpMkxQTnVoYThBaGlxYjU3UHpaS2czRElkSkNN?=
 =?utf-8?B?YzB3dlcyZ3N4NFZldDNReGppc29nZWZ4VTVtMi9qTHRaTzdxcGkyYUx1UjU2?=
 =?utf-8?B?Szh1MWtHYi9QYXhFSDREWUFya1ZCMUpwd3BlZlB3T1p6QWgvVmJhY2xVSk01?=
 =?utf-8?B?NGg1c3pqeDJza0RoQzM1RitweVM0aWVmYW10TlkrenJ4eG0vbks3WjE5eHNR?=
 =?utf-8?B?Vk5PRmtiR0htNEJIdzNvS0NPRWNCWEhxSmNCQ0V0RjhuYnRtRzVsaW1FYTRz?=
 =?utf-8?B?Z1RFRHFRTVN0SmpzbDdLUFRoN3NKR25vUThpVnJNRFU0YXR0bDJ4OFZJTXNt?=
 =?utf-8?B?OUJBbjdIcmIxSHJoRkI3RWJEZEl6SEFwN3ZITkpnMUNQcnFjNDFyUTkvNDJ5?=
 =?utf-8?B?eWRLd0twZWVBN0xlclE3cEFvaE9xUjYxZzRxSGpHVU9wdTc3WUwvb3dZNU50?=
 =?utf-8?B?MC8vblR0RFlqdzRNWmFTUjh5R0xTV0txbEIxM0RWQVk2VG9tN3FsVW1jNTZJ?=
 =?utf-8?B?by9nT1M5cFRSNWlEZEsvWUgrWENpMmdiWjREdjBNOGxiUTZpS1FtWEt4MDRV?=
 =?utf-8?B?NGRaeHdnc1VhTS90QS96WkZlNGpIczZVNlNKMUVqWkZCNVo4ajJnNVloRTR3?=
 =?utf-8?B?U0pwaVJHVHFnQ1ZMOW1UVHlTc1lxdEFiRTFLQTkrNzJkRE9VaEx1NHVxMElZ?=
 =?utf-8?B?VTVpRW9nTDhYR2o3S1R4WHZJSnJMS3Z2YjdrNGY0bldFVitaamsxZXdBN2FX?=
 =?utf-8?B?VHdmblRxTkIzeWl1WVNiclRPUjJuNUhRRkVPQmorSW90WFFiSlJ5bWNNZFBQ?=
 =?utf-8?B?YXFOd0lNWXZscW9URGM0K051bkV0TXFTdmF0WFBkOTFDaWVUbmZ1L1NHL0R2?=
 =?utf-8?B?QXFOaDRKNXVnS1dwZzFJQnhWNGpNQmlhK3BMTDZsdE11WGJVMU51ZktkNW0v?=
 =?utf-8?B?Z2JoR2d1UjBjb04vdDlwUTNlVmxoWXlIdHprQXUwZVB1cXpiS1lrSTUva2RI?=
 =?utf-8?B?d3pJdlBxUHg1NHBTRS84NTN1d3M1UThsYjAwandXRmcwTFFMMmN3VklpNnFu?=
 =?utf-8?B?Z3BLT0l2amlNNjFXR1NXNmpHY05LdXphTm5IOTNGbjV1cDAwVnNWWkhTZ2VH?=
 =?utf-8?B?WnVacmVXaUs3Y0Y0NEVmSHJmSmt1Rjh1WTRHQ1Y0STB2R2JrRHpYb01TdnhH?=
 =?utf-8?B?dTFjTlQ5MWsxWEtDZThIWTIxNjFjQzUyWWVpajNZS3hMSk03QnFOemp3bFpT?=
 =?utf-8?B?MEhqREE2SWVCTXh2UGcyNlhWekt2RUxaTE13anJRQUZWbEhQRGM5VDE0N3Nl?=
 =?utf-8?B?UE1GUG1yKzRKYTNMZjlSOGZUZ2w1UzliMHpoWGhVUlhDelJTT2tqVVpWNDRp?=
 =?utf-8?B?SWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <311BB2679E39F84D886A901B60358FD3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5807a455-6ed8-48c4-7242-08dc54e46b6e
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Apr 2024 20:18:41.1384
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EaT30zJiXkU+RaisptrFttDJavz6HqC3xTXbGA8LfCLHZrH5uUMxQan42sWF6g6F82pP7d8ior2jKV1DButg0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7053
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA0LTA0IGF0IDE3OjA4ICswMzAwLCBLaXJpbGwgQS4gU2h1dGVtb3Ygd3Jv
dGU6DQo+IE9uIE1vbiwgRmViIDI2LCAyMDI0IGF0IDEyOjI1OjA0QU0gLTA4MDAsIGlzYWt1Lnlh
bWFoYXRhQGludGVsLmNvbSB3cm90ZToNCj4gPiBGcm9tOiBLYWkgSHVhbmcgPGthaS5odWFuZ0Bp
bnRlbC5jb20+DQo+ID4gDQo+ID4gVGhlIGtlcm5lbCByZWFkcyBhbGwgVERNUiByZWxhdGVkIGds
b2JhbCBtZXRhZGF0YSBmaWVsZHMgYmFzZWQgb24gYQ0KPiA+IHRhYmxlIHdoaWNoIG1hcHMgdGhl
IG1ldGFkYXRhIGZpZWxkcyB0byB0aGUgY29ycmVzcG9uZGluZyBtZW1iZXJzIG9mDQo+ID4gJ3N0
cnVjdCB0ZHhfdGRtcl9zeXNpbmZvJy4gIEN1cnJlbnRseSB0aGlzIHRhYmxlIGlzIGEgc3RhdGlj
IHZhcmlhYmxlLg0KPiA+IA0KPiA+IEJ1dCB0aGlzIHRhYmxlIGlzIG9ubHkgdXNlZCBieSB0aGUg
ZnVuY3Rpb24gd2hpY2ggcmVhZHMgdGhlc2UgbWV0YWRhdGENCj4gPiBmaWVsZHMgYW5kIGJlY29t
ZXMgdXNlbGVzcyBhZnRlciByZWFkaW5nIGlzIGRvbmUuICBDaGFuZ2UgdGhlIHRhYmxlDQo+ID4g
dG8gZnVuY3Rpb24gbG9jYWwgdmFyaWFibGUuDQo+ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogS2Fp
IEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IElzYWt1IFlh
bWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5jb20+DQo+IA0KPiBSZXZpZXdlZC1ieTogS2ly
aWxsIEEuIFNodXRlbW92IDxraXJpbGwuc2h1dGVtb3ZAbGludXguaW50ZWwuY29tPg0KPiANCg0K
VGhhbmtzIEtpcmlsbC4gIEkndmUgc3BsaXQgdGhpcyBvdXQgYW5kIHNlbnQgb3V0IHYyLCBhbmQg
aGF2ZSBhZGRlZCB5b3VyIHRhZw0KdGhlcmU6DQoNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xr
bWwvY292ZXIuMTcxMTQ0NzQ0OS5naXQua2FpLmh1YW5nQGludGVsLmNvbS8NCg==

