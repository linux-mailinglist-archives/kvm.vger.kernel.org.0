Return-Path: <kvm+bounces-10482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EDAE86C7DD
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 12:17:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 429751C21332
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 11:17:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF5D37B3D2;
	Thu, 29 Feb 2024 11:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CrknxgaF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78AD97AE4E;
	Thu, 29 Feb 2024 11:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709205442; cv=fail; b=eYCnlKwS9cJTUGok+rCAPosHZq5XZlCku/59E0TDe/xPDOGFVreI3fywIHEOJ5eMphPIYpu0ynErh0Z5FJNqbogq79jVeHwCe0X3jM/GIMmxOffX9cQbUStIFhT2C2lNGNwxIllqZ/c455rFb0CnYnCnu/rS52RtD+2V4GLpqM8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709205442; c=relaxed/simple;
	bh=pLSQW5fpE7tY2kyP9cA0wv3tUpdO/P6x7u4f01y6YTM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=IIEU3qA2BwlHHRSSoU+iiNE/LJTm6ZMWcjLZErR9C/kJpVXK9tAfl5Dcn3/ccVwjyu66CmkjUyLonDiI03eDGK4n9j0geX4uCjFT4+bRUipiEwCARgYyF0p4N6YlsVKIOfQPf0ILlbyTjzv3LSrNPnIUBBuTanJwINp3SWA5y/c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CrknxgaF; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709205440; x=1740741440;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=pLSQW5fpE7tY2kyP9cA0wv3tUpdO/P6x7u4f01y6YTM=;
  b=CrknxgaFMkE4wxIbYLtJ8HOjzM2G2y6/Hu3GG8AiiZ4A93M+Osujd/Xb
   BHAt9JL8yL2QGTrf9rvcdIG30Q0TNBgnqNevHVIWggWUA0m+TA4obXwmZ
   QCnswX14iwpxapwZV0v+3LllwWnyuD3EghlB9jrxmVGjx4eMnaWJ/GGHU
   mNZ8JyS3ssv0lpra2l4rsxbbJ6Mi2cN3N5C8I/uARLYvQ+xIBhuWLyZ95
   qGYhyXdpzAOARX+z85hnW8xahfDeIau4aleMgFQJ5K/FYP3whumcI1LNq
   2iYACGSUDcCK0C+9MO4PI2MYBz6JvxqllFvxVIJaI+hr6AqhxTOAO4VHq
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10998"; a="3832128"
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="3832128"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 03:17:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="12406262"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa004.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 Feb 2024 03:17:01 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 29 Feb 2024 03:17:00 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 29 Feb 2024 03:17:00 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 29 Feb 2024 03:17:00 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 29 Feb 2024 03:17:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gTubGu0AG7ZlREgoMZkA5RWMQjSezlFUIxSmsJ4q5I1rDr4G3hhzaskcWYuCnpxe//ltyer7WuI48fLI36kJKDKXS6xiK1HTEN04kq9mgTO8R7ohF2MRhhLjStlCMkLs4mroynOF9pntOh3sKLXp1MuqK/0vFfpO/YhUyO7jIWFUDFX3WJNFtAJmGTC7EfxRfX5QKvL7O+60mvdNHs/XWSDKFTfhV10kokxaynVntitby8XEK7/oG9aifA9YWcP5oTb+eYsTqcZ10CSffCuXzbGpJLfUbNYizZ4GYKC7UIlMzkLrsgWRT6ETLrm5c83gZH9snLPZkONHU+wH0MzHBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pLSQW5fpE7tY2kyP9cA0wv3tUpdO/P6x7u4f01y6YTM=;
 b=fpY+UOLsn4F34Zsoxj8Qj1NV+lPW17/utO8woA/cARgXrTFSr96zvFaR015Jd2abNq1udk1K/Cl3wv+xniBjcCpm0Z6UG5LHkiy537Fowo2nhji1T38TXHm0anp1mN+1IBLhOt63nv42nFAg3ZqMfLZeBpelmiF72tjDnd7xgGBf7kJ+t2pBl8Jnnl52pdQ1OUIyVl+vR3coZiO1sh32CjVnSQimbvVHJ1QcgGRJr3rjx/P7q9lozaoSe3l/BQkvOs+lF/L560Ufs+CQue69wPK4mgjrXZqqvjCAsLRct2Dk/WqsitbshTL9LKoi3D8TrTNo+Ve9M1oy3lEu1NXXTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA0PR11MB7185.namprd11.prod.outlook.com (2603:10b6:208:432::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.15; Thu, 29 Feb
 2024 11:16:53 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7339.024; Thu, 29 Feb 2024
 11:16:53 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "yu.c.zhang@linux.intel.com" <yu.c.zhang@linux.intel.com>,
	"chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tabba@google.com" <tabba@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"dmatlack@google.com" <dmatlack@google.com>
Subject: Re: [PATCH 05/16] KVM: x86/mmu: Use synthetic page fault error code
 to indicate private faults
Thread-Topic: [PATCH 05/16] KVM: x86/mmu: Use synthetic page fault error code
 to indicate private faults
Thread-Index: AQHaae/qptI2Fc8vq0Sxpr1JO81sBrEhLbaA
Date: Thu, 29 Feb 2024 11:16:53 +0000
Message-ID: <063aa825af395439cc1b3669fb326c395bd6fe42.camel@intel.com>
References: <20240228024147.41573-1-seanjc@google.com>
	 <20240228024147.41573-6-seanjc@google.com>
In-Reply-To: <20240228024147.41573-6-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|IA0PR11MB7185:EE_
x-ms-office365-filtering-correlation-id: cba325f9-aec3-40f1-28e5-08dc3917eef7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j8fANnwaLZYl/Mcx5yhKEdEZMicQ9uo3SvnkEwrRsfCuP1ra99a4h11opk4HF38+SqpkU//TJEv80zPxKYBrCER2JugOqqbUVrhe+Svwp+xh6LU8rCUEmSIkBLeYw+xYZY+7r/D4W997SOyWxOJQ6a3BbDBU2VPLpSEkVlTGSzZNgv6POqJ/7Vi5g10NzrPFC21flaHZ+/d2Dv7NjwaMARjgLMaPHBo1DuVJ0A7iFiYbrHEgs7B/jPzakE0XzIvncAp05T+pQRn9WKIy9Uoo3xVfPHnoS9Dj0wQqdZyF2DfhH3Pe44oeTh8kF805sNa62Ex5szADAVzVAuSZftcYCt79aRaAI+uNZ1AtsDMYK02xYoumTSSQDyYSW9WbTOigh5QFU4uKtbU6cPcRID2Q+/ZbVEh/J7RHWyM/p86xDMty4Z/JcNXrK8blsBG9jI1zeGhS/S1DCi9cs/XLh/8g8Nw00ShZd480pSkCVUJrOLwmWzuRAgVIgvpnMMsQZ1NW40OT19YeQezqzGMVhdNCXNzPP1L+L9vuqI2l09LKy0+3x45rMpXxi6YqQVCSMODuhoBZ0+SIbJqSHqC6J7ymqwxDJJtJ2QU8hk7SC/wPVEPYM8cjYQC7TbZnBYpUbkUobTxaol/v9TwOvY+W8WQqwsUrLLhgB7MqHLhWajQTVIJIisCI4O6r+BKKLWiecvzqYGNPQLHSVdSIs7ewkU2PqQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YW15K0xTNFdoV2tXd0pPbGpmZ3ZQcXY3OCtUNGlPYmJNR0VhcG9jQ3ozcFFm?=
 =?utf-8?B?N1g5MXNDM1FGemd0WlRxT1ErVkNwU3ZVL0tVRW41Smc4OXhjKzIvMUhtaXV5?=
 =?utf-8?B?M2ZVQ2NiTXhZdGI1Mm9TRWR3bCsxdVZnWU1sY1VDR3N5QzA0OXQyOW9Rb1ZE?=
 =?utf-8?B?UUZacGtXZ3lQL2JQUXozeHZqZ05XM0J4Ky9lcWRGNGhmbnNhb1lNWEFJZWtL?=
 =?utf-8?B?SDJ4QXVKd20wYkt5YlFTcXdBRjJMZ2YwT2pGQkVXaVRqTWh3aFdPbTVwZ1FZ?=
 =?utf-8?B?S0JzcklqVHdpUFdIMzVKamdVZmtOUzBCNmF0ZWhkTnBIYVR5NHNMR3Z3WkJS?=
 =?utf-8?B?MXBpWDd1SWx2ODNKUmtSWGNwZjF6N2VVSkZiUU9SOGZ0RTc5YWhlSkp5M01H?=
 =?utf-8?B?V3ZUMS9md1J3ODdyTFZtb1ZuQkErb1o4T05JMUNUYnhyUkRrWFNoQzZaRDlM?=
 =?utf-8?B?UXJkLzhNaVhiM1c3UWpFaUFPRGNsYjVpYmphZVVTWlVjZUVzVlFzYlFiemRj?=
 =?utf-8?B?RXplbCs3bUFzTEx6N0NHQS9CaFRNNFBhWWk0YjBITitMbHhrYUNnajhjUjNY?=
 =?utf-8?B?K2t4WXBBUW0yTnp6N1BZcTNVdmQ3TlVBMmFaTjRtSDR5OXdEcDlMbnVERFhJ?=
 =?utf-8?B?OW0rV1paRnl1Vm1WTXlPZDVDMWhSdFdtWEVyOC9iTmhLcWFjWWg3VVcvTDcw?=
 =?utf-8?B?ZjB1YTA3MEMrTDhXYXI0OFV5aDNCcU81K2V1ZWNkeDI4cXVpNDJNL3QzRFRS?=
 =?utf-8?B?TWJkanZnZU1ZNk0raHpTUkViamoyOFh1R0RkRzN4dXFDTlRLVXpDWVM3cXVH?=
 =?utf-8?B?SVdzdVhoVFdOaDVhRk0wRWdIcTdRdFgxdkl0eFBrZ0NjK3RNUTNEdENSQU0y?=
 =?utf-8?B?WUhMT0t5eUxYMFhxUnZyL1pjd1JkRUgzcnF6cXhvWE9neHN0bUJyWitYKzBY?=
 =?utf-8?B?eTNCa0docHdPbExiWjVvak0wR21OZUdyWXRPVTVOUzBralQ1WnpFbHFuVnVh?=
 =?utf-8?B?bC8ydUtPK3JVUm4wTGw4THJRK3grREM3Q3FzcFQ1SjVKLzI1Uk1MOEYxSzl5?=
 =?utf-8?B?NlBvVjYwR1YveEN5aS9kTFFjU1QvUVhKYWlXNmJkV0lRSWpudkVIcnh1NWFl?=
 =?utf-8?B?cFFnQ1h0cmprd2ZzWU10Rm5MQ1ExcjYxQVJGTXk0Y05FanNrNmZpN0tWZHg2?=
 =?utf-8?B?Rzk3cENwQ1gwd0dLYmVJRndDbzRNbFNON09PWmlNZ3MwN0s5bGwzdmo3RFg2?=
 =?utf-8?B?ZzAvZlhUcnlEYWxpeUpEdmZNUkx3TzBFcVJuWFV0TlFkeHBrMzkzd3p4RHlM?=
 =?utf-8?B?WTVYWStGVVQwdVB0OElJUnVNVjZGbGJZQWtBMlJtSytQVkE2YmxqSWIrV2F4?=
 =?utf-8?B?RU1ncGdKalBTdnR0RklFOEhlNnhqY003eS9CaGdjbENUZk9jN1BIbHdGUXJY?=
 =?utf-8?B?VjVHc1lDb3RDVGxESlUwR0c3aTY3Z1FjYlBkUXdnRDZWTnNiSUJRSWNoZkR0?=
 =?utf-8?B?SlVBU2xFR2xDUlZHWE84ZGhDeG5HY1pRc2Q0eXAxRDdzYmdpVUR0eUhtTkRv?=
 =?utf-8?B?bTAyaGhETGg3OVdOK1ptN1FEb0VPSTQ3YWRhZFVDTE5YL0tyTmdHN2lpU2lN?=
 =?utf-8?B?S0dScnhoanFwLzBRRU51dzlNcEFVbkFEV2taTkdTTmRxWHpnRWYzbkI4QVor?=
 =?utf-8?B?bHRjWWM0R2QwR3prMHFvQUx5c3ZkTTd3WXpkMUFST0oyU0NxZVA4ZEk5VDNC?=
 =?utf-8?B?cERUSmtGeGtjSEVVZzR5R2NDbW1iYnBrelhkYk0va2hYYmU1aEJCZDZ1M2Ft?=
 =?utf-8?B?bWFSNFpFUFBOVmpqYUM4UUdCb2hTTnVCUTJ4TUN4Vm9HSzAyaGUrOHAxdVBx?=
 =?utf-8?B?N1htaDgrUFFwMnF1d2tiUGcvb0VWOXBLRTRqSkFreExVc3RIczZFS0drWk5l?=
 =?utf-8?B?L3B5NWIxa1pKdFRTcjEyWngrZXNnbUZZQ1lteTlKSXUzcEgxL214SGw4Mjdl?=
 =?utf-8?B?N2o3NXlDSVUrVWNHRWI4SDlCcXJHY2E3TFZDbVluTXhJVE9URkFTZ01EdWgv?=
 =?utf-8?B?RUZUejEzSGhLMHhobXpUcHVlS2xodFYxRnBaSXI1Z1dSTVRxbUdmSWc2V3VY?=
 =?utf-8?B?WkpaSGxzVUh6YzIvYlFCbDhVaEdkVGxxV01pelpRcXpZUXd6dGJEMDhXZ2pY?=
 =?utf-8?B?YUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6D6AA48D54F91145A68FE6FDD19C42CC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cba325f9-aec3-40f1-28e5-08dc3917eef7
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Feb 2024 11:16:53.5840
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /jw26UHT/NIzA4elxK/BqP8pX2oOazXnNg4C/tHveVDByAML+dT1htFQZWnJgxb7xGqstdiA6p0Lf1AWn8jwEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7185
X-OriginatorOrg: intel.com

DQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vbW11L21tdS5jIGIvYXJjaC94ODYva3ZtL21t
dS9tbXUuYw0KPiBpbmRleCA0MDg5NjlhYzEyOTEuLjc4MDdiZGNkODdlOCAxMDA2NDQNCj4gLS0t
IGEvYXJjaC94ODYva3ZtL21tdS9tbXUuYw0KPiArKysgYi9hcmNoL3g4Ni9rdm0vbW11L21tdS5j
DQo+IEBAIC01ODM5LDE5ICs1ODM5LDMxIEBAIGludCBub2lubGluZSBrdm1fbW11X3BhZ2VfZmF1
bHQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBncGFfdCBjcjJfb3JfZ3BhLCB1NjQgZXJyDQo+ICAJ
Ym9vbCBkaXJlY3QgPSB2Y3B1LT5hcmNoLm1tdS0+cm9vdF9yb2xlLmRpcmVjdDsNCj4gIA0KPiAg
CS8qDQo+IC0JICogSU1QTElDSVRfQUNDRVNTIGlzIGEgS1ZNLWRlZmluZWQgZmxhZyB1c2VkIHRv
IGNvcnJlY3RseSBwZXJmb3JtIFNNQVANCj4gLQkgKiBjaGVja3Mgd2hlbiBlbXVsYXRpbmcgaW5z
dHJ1Y3Rpb25zIHRoYXQgdHJpZ2dlcnMgaW1wbGljaXQgYWNjZXNzLg0KPiAgCSAqIFdBUk4gaWYg
aGFyZHdhcmUgZ2VuZXJhdGVzIGEgZmF1bHQgd2l0aCBhbiBlcnJvciBjb2RlIHRoYXQgY29sbGlk
ZXMNCj4gLQkgKiB3aXRoIHRoZSBLVk0tZGVmaW5lZCB2YWx1ZS4gIENsZWFyIHRoZSBmbGFnIGFu
ZCBjb250aW51ZSBvbiwgaS5lLg0KPiAtCSAqIGRvbid0IHRlcm1pbmF0ZSB0aGUgVk0sIGFzIEtW
TSBjYW4ndCBwb3NzaWJseSBiZSByZWx5aW5nIG9uIGEgZmxhZw0KPiAtCSAqIHRoYXQgS1ZNIGRv
ZXNuJ3Qga25vdyBhYm91dC4NCj4gKwkgKiB3aXRoIEtWTS1kZWZpbmVkIHN5dGhlbnRpYyBmbGFn
cy4gIENsZWFyIHRoZSBmbGFncyBhbmQgY29udGludWUgb24sDQo+ICsJICogaS5lLiBkb24ndCB0
ZXJtaW5hdGUgdGhlIFZNLCBhcyBLVk0gY2FuJ3QgcG9zc2libHkgYmUgcmVseWluZyBvbiBhDQo+
ICsJICogZmxhZyB0aGF0IEtWTSBkb2Vzbid0IGtub3cgYWJvdXQuDQo+ICAJICovDQo+IC0JaWYg
KFdBUk5fT05fT05DRShlcnJvcl9jb2RlICYgUEZFUlJfSU1QTElDSVRfQUNDRVNTKSkNCj4gLQkJ
ZXJyb3JfY29kZSAmPSB+UEZFUlJfSU1QTElDSVRfQUNDRVNTOw0KPiArCWlmIChXQVJOX09OX09O
Q0UoZXJyb3JfY29kZSAmIFBGRVJSX1NZTlRIRVRJQ19NQVNLKSkNCj4gKwkJZXJyb3JfY29kZSAm
PSB+UEZFUlJfU1lOVEhFVElDX01BU0s7DQo+ICANCg0KSG1tLi4gSSB0aG91Z2h0IGZvciBURFgg
dGhlIGNhbGxlciAtLSBoYW5kbGVfZXB0X3Zpb2xhdGlvbigpIC0tIHNob3VsZA0KZXhwbGljaXRs
eSBzZXQgdGhlIFBGRVJSX1BSSVZBVEVfQUNDRVNTIHNvIHRoYXQgaGVyZSB0aGUgZmF1bHQgaGFu
ZGxlciBjYW4NCmZpZ3VyZSBvdXQgdGhlIGZhdWx0IGlzIHByaXZhdGUuDQoNCk5vdyBpdCBzZWVt
cyB0aGUgY2FsbGVyIHNob3VsZCBuZXZlciBwYXNzIFBGRVJSX1BSSVZBVEVfQUNDRVNTLCB0aGVu
IC4uLg0KDQo+ICAJaWYgKFdBUk5fT05fT05DRSghVkFMSURfUEFHRSh2Y3B1LT5hcmNoLm1tdS0+
cm9vdC5ocGEpKSkNCj4gIAkJcmV0dXJuIFJFVF9QRl9SRVRSWTsNCj4gIA0KPiArCS8qDQo+ICsJ
ICogRXhjZXB0IGZvciByZXNlcnZlZCBmYXVsdHMgKGVtdWxhdGVkIE1NSU8gaXMgc2hhcmVkLW9u
bHkpLCBzZXQgdGhlDQo+ICsJICogcHJpdmF0ZSBmbGFnIGZvciBzb2Z0d2FyZS1wcm90ZWN0ZWQg
Vk1zIGJhc2VkIG9uIHRoZSBnZm4ncyBjdXJyZW50DQo+ICsJICogYXR0cmlidXRlcywgd2hpY2gg
YXJlIHRoZSBzb3VyY2Ugb2YgdHJ1dGggZm9yIHN1Y2ggVk1zLiAgTm90ZSwgdGhpcw0KPiArCSAq
IHdyb25nIGZvciBuZXN0ZWQgTU1VcyBhcyB0aGUgR1BBIGlzIGFuIEwyIEdQQSwgYnV0IEtWTSBk
b2Vzbid0DQo+ICsJICogY3VycmVudGx5IHN1cHBvcnRlZCBuZXN0ZWQgdmlydHVhbGl6YXRpb24g
KGFtb25nIG1hbnkgb3RoZXIgdGhpbmdzKQ0KPiArCSAqIGZvciBzb2Z0d2FyZS1wcm90ZWN0ZWQg
Vk1zLg0KPiArCSAqLw0KPiArCWlmIChJU19FTkFCTEVEKENPTkZJR19LVk1fU1dfUFJPVEVDVEVE
X1ZNKSAmJg0KPiArCSAgICAhKGVycm9yX2NvZGUgJiBQRkVSUl9SU1ZEX01BU0spICYmDQo+ICsJ
ICAgIHZjcHUtPmt2bS0+YXJjaC52bV90eXBlID09IEtWTV9YODZfU1dfUFJPVEVDVEVEX1ZNICYm
DQo+ICsJICAgIGt2bV9tZW1faXNfcHJpdmF0ZSh2Y3B1LT5rdm0sIGdwYV90b19nZm4oY3IyX29y
X2dwYSkpKQ0KPiArCQllcnJvcl9jb2RlIHw9IFBGRVJSX1BSSVZBVEVfQUNDRVNTOw0KPiArDQo+
IA0KDQouLi4gSSBhbSB3b25kZXJpbmcgaG93IHdlIGZpZ3VyZSBvdXQgd2hldGhlciBhIGZhdWx0
IGlzIHByaXZhdGUgZm9yIFREWD8NCg==

