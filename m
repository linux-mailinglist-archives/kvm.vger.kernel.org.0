Return-Path: <kvm+bounces-12342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F457881A6F
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 01:19:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB63F2831F7
	for <lists+kvm@lfdr.de>; Thu, 21 Mar 2024 00:19:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EB1B17FD;
	Thu, 21 Mar 2024 00:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Uz1dRDum"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BBE5653;
	Thu, 21 Mar 2024 00:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710980335; cv=fail; b=nN9kjN4cf+oTZV/QAC6/nGV5C80P3YoZSMlWtrvclHh5Dr6a4K1RVjwSHfHGJ+ePbfxy+7v51BMYiMjtPnPsTP/VYSZzcpn6KL8IIaDBlS1//fjTwfRlVmNsyW8f7Nc2fqrak5DcCU1fvTu/aUvxm50qBxGnHUHd4WzKLAAsSk0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710980335; c=relaxed/simple;
	bh=h1jeEgrLoH0xy4+VWNL65yiheLWopr1lNlfjyP5Beng=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=U7Y/989ZyGK/Qdc+rIXvomu6KULBRpIjNgpzAjniB1OSVNRKGNbdnzSjT/6I/EBbDrYPxvLVficsoMZs7AH6ESY6Vsza1atWL6Fl5Z4XEYpxy4IB7kbuBPGou4NTSYN/O7dT18iRSAjWvM/QLVHQ1KNGJOSmq8r397TgvZNfHxY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Uz1dRDum; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710980334; x=1742516334;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=h1jeEgrLoH0xy4+VWNL65yiheLWopr1lNlfjyP5Beng=;
  b=Uz1dRDumvyPjkzZGM16t3QCU3/6LxbmiTcJXTxLdItA/kArG5C/zdYXy
   D0R6ghMyNvNK/ydGlyQORAhrhYqyiTxIzzZvC6EdEh3BYvIAdFN9TY2/y
   VgbxF1p4gSW6jmIcf2ZYIOMg/FXHQ/12aeJo1XrcAz2TYIVqStOZY77jZ
   7700ivSkTMbHYvwgjaWSUT/vJ5UrGLTHfkNXXNQQgWDLbVtJn2iciOeZF
   dZ9zxRTleRxNTG4Tt/SDO3Q75YVyws9dIDTY2RHv3MY5HKiTvevg9EGCF
   s/ft4eMMy9S4zSaglxJBzRo7oxayslb5KOodLuiqlDUD9OyNgvMeM0rIl
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11019"; a="6058262"
X-IronPort-AV: E=Sophos;i="6.07,141,1708416000"; 
   d="scan'208";a="6058262"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2024 17:18:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,141,1708416000"; 
   d="scan'208";a="19023131"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 Mar 2024 17:18:53 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 20 Mar 2024 17:18:52 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 20 Mar 2024 17:18:52 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 20 Mar 2024 17:18:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kzl/yqji+AqKTmeE464fIdIEHN2CUaX5fnGE6RbS35JbzIefZzLZydYv/4oFcCX5DkBg04A83iXR95WEVoC6k8ER5G1EIIh9BCxMEo+/ccZn1qXvOI82GuecKf4cBf+tHYbus37H11n6jpUt7sHSjIdW65yZxaz7upW6GrY4xEkSyzc7WQ28DzvJiu4lF+rTpTg+vzBduBbfx6T+EydR2RGiIKQEChIgmkRKgt0uFNPvyHBgsxqcB3ag1gnX+GJoU1kchj9TkPicQQOWB6HxPBVOSOG/43hJWWJqJQnl2LYW0r6fKkm65AY5O6H5r8vpHYTk55R1cbDTaurau6ZP3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h1jeEgrLoH0xy4+VWNL65yiheLWopr1lNlfjyP5Beng=;
 b=L12iF01Dajy2Zqizf+eJ8lkxm3lb6xbtAL9ENPzBDJuPKSD2uTk7/W+XL6PViYmIgGe+RPIW9EKZ+WZc4ovqv8mhRxdS1YFO/nvNRlmIzZmakPcakTlEKL1S5IRRgj5YJUtDqt9LKtMcTYvkgMoSzURBO8nXzVa7Y1AuGp6vn1swdXSxJ717DMlrfqZYFnHi37G2BrQitMGoS5cMTvcr+8HbCkeAvAOT+eBF+Wt4LtBh5rKT+JcwUEB2BucEkqKxl9lbxhwHJ7FKZBysYVhfFC80tXng2aV9YbtFDXKehpWms+qrNPoXZE38YBQk/jEttq5oenCG4x7jkocgOwC9iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA1PR11MB5777.namprd11.prod.outlook.com (2603:10b6:806:23d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.12; Thu, 21 Mar
 2024 00:18:48 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7409.010; Thu, 21 Mar 2024
 00:18:47 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Huang, Kai"
	<kai.huang@intel.com>, "Chen, Bo2" <chen.bo@intel.com>, "sagis@google.com"
	<sagis@google.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: Re: [PATCH v19 057/130] KVM: x86/mmu: Add a new is_private member for
 union kvm_mmu_page_role
Thread-Topic: [PATCH v19 057/130] KVM: x86/mmu: Add a new is_private member
 for union kvm_mmu_page_role
Thread-Index: AQHadnqpyo/wrcmplkatsGackoL2UrFBXbmA
Date: Thu, 21 Mar 2024 00:18:47 +0000
Message-ID: <875eb07773836bf1d5668a4f28a696869e3291c2.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <3692118f525c21cbe3670e1c20b1bbbf3be2b4ba.1708933498.git.isaku.yamahata@intel.com>
In-Reply-To: <3692118f525c21cbe3670e1c20b1bbbf3be2b4ba.1708933498.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA1PR11MB5777:EE_
x-ms-office365-filtering-correlation-id: dbceadb8-ec66-44fa-f7f6-08dc493c7a44
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iS8n8fs+enh7kyd97oAdKpTp2YJK2vEAVCJFcET6inyIxEaLIp8V7GnqKogDBr8PIkdLh20IZwd8rAaVnv/HlMnWmGeTF0IflXgyr3OmPJlRdwynFU6W+owgvcbjEdd3Dsxm7EwXlpnQrducoYVH5SmlovG4ok9Rq1TP215oW4/ANv2D3gYPHZdaQBz1ov46D1hiTLhR3F7cj8EYC16S/XHOFchJ9KW4Yun/BSh14hbUfIw5abj3TfZGS5rzYOnxcw+fDECeSBvSc2MiuTsANmUS8P5E6kF4kmroDL3Q03v5fG3nRRqDKnzfr8ZulVQfZrdzFRLoOHTu2Z3MLc9Jkz5TAJxgLxZWv7U69He3K0JihY/JmHXsN5xO9rzo+wOj687q960JEJyMb5DUBzE47lYRjdRs7CKU9zADIQx3OrDFdZTSY7etOWmTwoLVcX4Kkz9vKoYH9Epflrzw6nKOnYnBlzfQl8AigruoM/COOtaR2ErxKES+123eOpom7H+WaFztuZLQYntbs3F0qAkQuZYODrNdwBghTNhACSvUlJ3w0vYURp9Xm9nz2+b7sRPq3WbveWvQUL6+A0aHIbBze7QO4K7bSabQVFdSlAPaQmyrYGA14oKNQ4oqNJRpLKPg5f7R/gcFjIYiS5uwprAsmvyl3eaTaaAIgT8x0986SiCYDc4oBQLlv3Yej8TcDKJCkYghfFthhGuGeFBkCfqrjqHkckug1FA6+wFj0iNH0Ls=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WCttYU9NSWtaOERDQUZtQjZJR20zRFluQXlGQzUxM3RNeGlNcENhNlVTUE1j?=
 =?utf-8?B?Z3BubGo0am45bG1BWVBDUW9tZWdIQjdDZjRObzM4S2Rzem1jSmZmc25tdEhK?=
 =?utf-8?B?R2pGWXlFR0phb2NSR1M3SFV5b2ZPbFpJU3hZYks2dmV6ckFQWXJRV0FFNlll?=
 =?utf-8?B?djhMYTdXVjZuSzBjQm9Bb1Y5OXU1R3RHcHJ4Zy9pVWRUbGRnR0dWVzlHcHZD?=
 =?utf-8?B?QTlHaU4xWVNyMXA0Vkh6WjZnSHlBMWFQRDBXZHFWdkhjM0VOOE9oL0Zwd0g1?=
 =?utf-8?B?Z3cxKzhxc2hCUHFOemtMVHZrOUE0QVd0MHgxOVRZUHJjb3ptQ2JQMDBaV0ND?=
 =?utf-8?B?T1lwM2huUU5mNzF6akR5S00wZjhtMmxNakdrZXE0NmdLc2NrZVVHcjJlQW1t?=
 =?utf-8?B?Vm01U3l6SGNwd2tmSjBmemwzYkd1ZlVlamxzcFJuTVdMVlpnMmNlZ0ZldThm?=
 =?utf-8?B?R3RCQUgzVHRPRHNiTFRzRGlQeEN5TUFndDhQMUJmTnU2N0g0ZzFyTnJLd2xt?=
 =?utf-8?B?cHVQWEpRdnhpSmcrK3c0MU1JVTl0a0NwQ3ZHelRKYit5SFpiRTVxU0U2bkRs?=
 =?utf-8?B?WTU3SmNrbVRSY0lUK3lnTEtaZmxWdVN4dk50SitiY000TE5mZkxDdmc0WEZE?=
 =?utf-8?B?WjhjdU1mQzZ2dUh5aUJRdXkwL1pIK0c4WmpMNkViN3VYWjQ0N2lzR0JUcTdm?=
 =?utf-8?B?Y3RreHV6Y25tbFFHdDNETUY1anpvZmkvYW5ieGpnbXZ0SmNjU1NDeXNqVmYz?=
 =?utf-8?B?c1pqS2ZuN0xzUlBxa2Y3c0JzUFNyTytIbmgvTzd0QWlqbzU2S2x4OWZtQXlI?=
 =?utf-8?B?TWRJaWRqRUJwWncvNVNGVGQ1cC84MUY4b1dXUzVmdXRTdGMwK0Q5N2NBcW53?=
 =?utf-8?B?SUFJOGkrVXJ5aCsxbzlYVzF6c0haMDhOMzVzVmhWOUVBL2lacUZUME9mbHI0?=
 =?utf-8?B?K29kdjQzNEVjV3BRWTJXN3ZUL1BZZ2hTQldYNkFIRUROMkt3VXUyRXpPeDRu?=
 =?utf-8?B?Mm4rdVlMN0xWOWpuekxQK2RibEVTRnd0UDZKQ0NRSEtoUDNML2dFcWhFam9Z?=
 =?utf-8?B?SDJ3Q0VheERvNW1IYzlzSHU0VjNkREtkMEQwWSsyZG9sVmpqQlFCRXlxamtK?=
 =?utf-8?B?ajJpdHU2S2lEVEZaeW1UVWsrVHdZV2FKeUxsa0c4bXZGK1J2cFFTOXpCdWxT?=
 =?utf-8?B?anhtTy9KemtTRXpnTCtkU0VLdzZOa1kyRGs5UUMvdFp5TXR0VzUyd3lteXdi?=
 =?utf-8?B?YzFEM01rWGhrSkN0bEVCY2JvZS9sVjVLa3pwYnc3UWZNQ1BUdUR0eDhlVnhI?=
 =?utf-8?B?YVpXSnRBV2RVZi81dmNSb092WmIzSjE3c1QzZVEva3E1NGhLL3VpeHRMZ2xQ?=
 =?utf-8?B?Tmx6ajN4dzBFdFd4RFVrWFZXYTc4Wlp1czQ4OGNHdi9RQnNaWUI2V2R0WmtD?=
 =?utf-8?B?Y0RQdG1YVGlYamJvNDFwcWxGdzNOR0pQWjFnYVNqRG9LZ3FzeHJkbnV0WHNH?=
 =?utf-8?B?eXJuYllNYy9nU1ZyMFVzODY1dVkzZDFncGNPZ0QxbkFSQjBkZEYvWkJPNzdH?=
 =?utf-8?B?bHFUekEyOU1haytoYU93bDgrUlkydE9NUWpnZTl4NVVOZDRFU2daSENhUzlt?=
 =?utf-8?B?Mk9mVEVKcGx5UCtobTcwS09IQnhsVEN2YTdkQ0w3cFJxVHBKWmY4REloQmsz?=
 =?utf-8?B?TWZkUFJlZzlCc3l6bjg0cmRiWDlkaVZOcmhRVWRuTXh3N3JrejRNYkEzMFpR?=
 =?utf-8?B?aXIzTmNqT3QxZExXTXA3MzZPS0ZjME5HM1IwN0phN29JSFJWSVI5NThaSmdS?=
 =?utf-8?B?di94MzB2ZFRpRjhWNWV5eHplc3ZKS25naG56bzErRnd5SjVuU0ptL3V1Z1pj?=
 =?utf-8?B?Sm9la0lFeFhjWnRJdVhnY0xsa2ZOVnVFb09GWFU1em9yMHlXdGJoVU12Yk1B?=
 =?utf-8?B?SFNpTTIrcHpiY01FQzFXWVNOL0ZUVDdJMWVMc0Z3VnFTTmJNamF6S0VkOHZ4?=
 =?utf-8?B?TlhoM0xTQThBVVhtOXdXK0N4RHdWT3NUZ242UGVid2hSa2txdndERUVLRENI?=
 =?utf-8?B?eER1M3RrRENyNXdSQWxLQlVEYW5hNkhSUnBGcll0L1EzRHRaUXE3alFQcm9r?=
 =?utf-8?B?d2ptV1VFTHZzVkhneU9oSWluaHdrT09JWXhXVEkzQnk1WVZVVlJaMlJEeHFX?=
 =?utf-8?B?QVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7E8478E585507941B57839070B7BD086@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbceadb8-ec66-44fa-f7f6-08dc493c7a44
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Mar 2024 00:18:47.7388
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Fi8DULOXJIdeWr2Ih/jQc61IQIDHBtRJxs3XHUuE1rlGYczXcH1XqUIzzG3igUZ4aaz4GSu/w9jF04Jgx4wFot9rNlMTuJs6cKy/USxja/4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5777
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTAyLTI2IGF0IDAwOjI1IC0wODAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+IEZyb206IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20+DQo+IA0KPiBCZWNhdXNlIFREWCBzdXBwb3J0IGludHJvZHVjZXMgcHJpdmF0ZSBtYXBwaW5n
LCBhZGQgYSBuZXcgbWVtYmVyIGluDQo+IHVuaW9uDQo+IGt2bV9tbXVfcGFnZV9yb2xlIHdpdGgg
YWNjZXNzIGZ1bmN0aW9ucyB0byBjaGVjayB0aGUgbWVtYmVyLg0KDQpJIGd1ZXNzIHdlIHNob3Vs
ZCBoYXZlIGEgcm9sZSBiaXQgZm9yIHByaXZhdGUgbGlrZSBpbiB0aGlzIHBhdGNoLCBidXQNCmp1
c3QgYmFyZWx5LiBBRkFJQ1Qgd2UgaGF2ZSBhIGdmbiBhbmQgc3RydWN0IGt2bSBpbiBldmVyeSBw
bGFjZSB3aGVyZQ0KaXQgaXMgY2hlY2tlZCAoYXNzdW1pbmcgbXkgcHJvcG9zYWwgaW4gcGF0Y2gg
NTYgaG9sZHMgd2F0ZXIpLiBTbyB3ZQ0KY291bGQgaGF2ZQ0KYm9vbCBpc19wcml2YXRlID0gIShn
Zm4gJiBrdm1fZ2ZuX3NoYXJlZF9tYXNrKGt2bSkpOw0KDQpCdXQgdGhlcmUgYXJlIGV4dHJhIGJp
dHMgYXZhaWxhYmxlIGluIHRoZSByb2xlLCBzbyB3ZSBjYW4gc2tpcCB0aGUNCmV4dHJhIHN0ZXAu
IENhbiB5b3UgdGhpbmsgb2YgYW55IG1vcmUgcmVhc29ucz8gSSB3YW50IHRvIHRyeSB0byB3cml0
ZSBhDQpsb2cgZm9yIHRoaXMgb25lLiBJdCdzIHZlcnkgc2hvcnQuDQoNCj4gDQo+ICtzdGF0aWMg
aW5saW5lIGJvb2wgaXNfcHJpdmF0ZV9zcHRlcCh1NjQgKnNwdGVwKQ0KPiArew0KPiArwqDCoMKg
wqDCoMKgwqBpZiAoV0FSTl9PTl9PTkNFKCFzcHRlcCkpDQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqByZXR1cm4gZmFsc2U7DQoNClRoaXMgaXMgbm90IHN1cHBvc2VkIHRvIGJlIE5V
TEwsIGZyb20gdGhlIGV4aXN0ZW5jZSBvZiB0aGUgd2FybmluZy4gSXQNCmxvb2tzIGxpa2Ugc29t
ZSBwcmV2aW91cyBjb21tZW50cyB3ZXJlIHRvIG5vdCBsZXQgdGhlIE5VTEwgcG9pbnRlcg0KZGVm
ZXJlbmNlIGhhcHBlbiBhbmQgYmFpbCBpZiBpdCdzIE5VTEwuIEkgdGhpbmsgbWF5YmUgd2Ugc2hv
dWxkIGp1c3QNCmRyb3AgdGhlIGNoZWNrIGFuZCB3YXJuaW5nIGNvbXBsZXRlbHkuIFRoZSBOVUxM
IHBvaW50ZXIgZGVmZXJlbmNlIHdpbGwNCmJlIHBsZW50eSBsb3VkIGlmIGl0IGhhcHBlbnMuDQoN
Cj4gK8KgwqDCoMKgwqDCoMKgcmV0dXJuIGlzX3ByaXZhdGVfc3Aoc3B0ZXBfdG9fc3Aoc3B0ZXAp
KTsNCj4gK30NCj4gKw0KDQo=

