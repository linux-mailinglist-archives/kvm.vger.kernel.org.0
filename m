Return-Path: <kvm+bounces-11883-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F1DDD87C88B
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 06:39:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E82611C21AEA
	for <lists+kvm@lfdr.de>; Fri, 15 Mar 2024 05:39:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADB7A101F2;
	Fri, 15 Mar 2024 05:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="d+Kc6n1K"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D05ADF51;
	Fri, 15 Mar 2024 05:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710481181; cv=fail; b=rH5NPR6bMzuh5W1446QbiD9AhYThxDXkmwWdXDvA75lFDgPfcc3/umiisYHwhapSBdjlGNvm0MrX6FHGCcPspNs9vuq+b7qTZC2gY7fIBRwNeNbyb3Hp8tQ5H5bgyE4ERShzdl35YJikrgjiZ6epd+w11pxNWtINoBSpbrXfCOk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710481181; c=relaxed/simple;
	bh=W3+tqwZiyLebs1Juz6egnWsZ2GroScCQ0Flj69jLqAM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GMJXHlSJUfYeSmo9TIszP8Q5oWeVTWjZNVa40bNnZwN3IPgteBYY6BdPJOeSwvHozFXVNXc7/4DSqM3CSBv331YBh/mGAaSFqoK9/exczVOfGEK52qcrE0dLoF+IYV0XqI2ytNXmXtP+htpLO/6WM0v5Lb0vvJ4/da6ggQD+zAU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=d+Kc6n1K; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710481179; x=1742017179;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=W3+tqwZiyLebs1Juz6egnWsZ2GroScCQ0Flj69jLqAM=;
  b=d+Kc6n1KZOYSmU6VQx+tpHD+JjuuWs3z9ISUf3PbSUSYnJ9ZUnp639I7
   R1Jzpf9RvSTS39jtesjAodqzElNTIhCVA1BIwCGMhpnRxJCoHvXJ8Mt8K
   jZg0ykWmTaVlDbF3lKso+/KQsPrvWSfcKThEf6Z4NaQqctqrgN9Tlx6Oj
   PcQm4BLZy4ZmzwKklcwHymGEzt421AmQ7uhHg0BAeafov5SgV/2NCybxz
   nr2vuzZ37LwQzp7st6BdBCksXISf6yIonNhBr9boHiCGXC7JwlzmQA88c
   psj6Cx2zCzvBO4gaxn8DHNcJkENg+K4Qjk9IDbNpqxv0OpgqPhGfbzSzk
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11013"; a="5191086"
X-IronPort-AV: E=Sophos;i="6.07,127,1708416000"; 
   d="scan'208";a="5191086"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 22:39:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,127,1708416000"; 
   d="scan'208";a="17280968"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Mar 2024 22:39:38 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 14 Mar 2024 22:39:37 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 14 Mar 2024 22:39:37 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 14 Mar 2024 22:39:37 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 14 Mar 2024 22:39:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GBBTwLCAGynqlLsOMypGQ8KOS7UwouXF3lGRRJjIMEkQ3LnPJ+4GArazXbKIna0LC+zJzeblfVpNOQrCMDdO/ricTgeDmHRh6WUMqXr9ndzN2xN/0dabOvFe5wIBkIdOCLxw4apItxxov64ypEo4a15EW480wzJ3+BeT8xC6VQCc+ncZ7pFx5zlsJO5Hz24KQtMN76lsxLHnXbLlfWODVmx5amNFp5C60xj6Bwv7iujmNj9lMzBf0D6xp68xNhZGFxSahTmEXs7SQ2crO5OWBIebpHnaH3Loj/M7RIFKAXryUjCdmqhvarGEB3He2bvB/uW79dIe9JyKngJpzNoDaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W3+tqwZiyLebs1Juz6egnWsZ2GroScCQ0Flj69jLqAM=;
 b=NRKUHWZiPQzKMBIO3F4CRZYlDXL3fxxrFq9GyiPENc/oQw0tjmRJQ3aUxM8t1KcVyZjbwvfn38LCiHIPA/3BbNkcEekc726k1rU/7xYjLieuZk930LqXtukucgcmUvWlTYmRNfwHzVaorQ5QFwKAiloFNm/qai0MROF8/amGIXUzbYGepfwRlBLl089YT3RoPv7Buo9jq4+VEg3byMmOtmxh4ZWls/GMaZT15idqhplVqOl6bU+tY09i41/qPh8vwnVV+gkNUbiOei7pz8QzX7AhtBsae4jeYvGwIOAuTs3jgClJiYO7kxMFDBQwNCCZaZnLh41B0sFsyXQIss0jFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH8PR11MB7096.namprd11.prod.outlook.com (2603:10b6:510:214::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.20; Fri, 15 Mar
 2024 05:39:07 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7386.015; Fri, 15 Mar 2024
 05:39:07 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [PATCH v19 034/130] KVM: TDX: Get system-wide info about TDX
 module on initialization
Thread-Topic: [PATCH v19 034/130] KVM: TDX: Get system-wide info about TDX
 module on initialization
Thread-Index: AQHaaI26NdKryYpZXEuSi/e9HKO5abE3+DmAgAA06gCAACxugIAAA9aAgAAHqQA=
Date: Fri, 15 Mar 2024 05:39:07 +0000
Message-ID: <078ed2b1c3681c6c0ada9106d481d2f7d964815a.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <eaa2c1e23971f058e5921681b0b84d7ea7d38dc1.1708933498.git.isaku.yamahata@intel.com>
	 <e88e5448-e354-4ec6-b7de-93dd8f7786b5@intel.com>
	 <15a13c5d-df88-46cf-8d88-2c8b94ff41ff@intel.com>
	 <aa1ed4c118177e3e341eebccecac3b07bf75a47d.camel@intel.com>
	 <10c41a88-d692-4ff5-a0c3-ae13a06a055c@intel.com>
In-Reply-To: <10c41a88-d692-4ff5-a0c3-ae13a06a055c@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH8PR11MB7096:EE_
x-ms-office365-filtering-correlation-id: 37294eb6-1fff-414e-f576-08dc44b23b78
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Cs+csQRhjXTrdnQV6CoWwYkHl/lA3RWsh7aBksvxezltPL9g6ZvodkwkWbF/EuSas8sPI63PY81ENK4DMhNjTEsprHc9uu3/2enkANOm0w5YzEfmGjLvoVOhupRbLkjxWJYQgEMSLNkBAJSc2GPlzEO19QebrYKX0iGjHBKA+Y/klf6pjP5dww7onEc7rAyDeJVoKsS1JGKquUHTIoPIPrBaHAYLVFwdUbaM/uRlaiZu+pI1ISkN0DtGdGC6paoOBDJsmyVxRXNha38f9VFcNf/cNntCQNzUnPewy3HULw1/bs5uceaZx6U12bt6zxAxTmZEPU5GArgHXrhOtn1c2mmivBY0CozLDE8PYV9DL2XVSCpkRXWYFrB276nY99BY4sYyfzPacYn1pzQ/24KmWNFAMoAeN775ERvwp/3abK+zj9suElpCM1Kr6D/Lvky9rdUsq15C6dHIZn52J4ZFRL7EfA1G3M4/eJbZXWHzTgoPeUlKQ0za0/8mhg/fbDqnZAh4WQE667B8QLvU1v1eZDjI9jmajS5PVUeE0AVuAWAhBMGQaj3iqY9lg25j8RbndXd0LMr/31unPzr2br+KW3tVfce/zOSAZi0qUYUfqeiGm4Mhh0gmpt7mJHl1cI1WnP+Dah4JEaAHyNaPK46T+gMfvgpjt9Y5MPdqUhTPxMb1YTF1w8vF6xxO9esedRXN/iraw8RWzXkuzPpj/fJY6cx5SU0Vkn4SFB+sIfiUmWE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RmJwYytJcWxFZTRUN3VLalhsbHNMb2RvQ1crSUtZbHJrUXcrYWZRWE5QNTZM?=
 =?utf-8?B?bC92QUt2ZXNaVmp1eCtUOTBlNUNVZDF3UllKRURobVpCZjNCbFF0eERQaWZP?=
 =?utf-8?B?Q0VlMlcrSXhZOHBKamplSTYxdTRkdmJIbmtYb1VEckg4SVUxakJLOUpsbDFp?=
 =?utf-8?B?T2V0RWRWWFliNjRNNGF0QlkxNzdIajdxTVZjckZsVURlWUJQR3VGNjNPcHJ2?=
 =?utf-8?B?dURCTmRheldVY2phMUF6MGFFTDVtZXVMSU5UaEJoYVU4UVc3ckJzaDZCdVIz?=
 =?utf-8?B?U2h6WVliaTNYeWlsdkVmV0dYSEZ2UmVCUXgwcTVSU0lNSVNqZ25jT1QrZ25R?=
 =?utf-8?B?VGM2cks1RDVkYXFwQ0Z5Y0x3OU4wdW1hWm5DKzB2VEh6aGZsSVZta28xQzBj?=
 =?utf-8?B?R0EyQ3ZDM3hKWWxKdnhaaGNKaG9zN0l4Rlg5a2dHVmNzMTY1YjI4TURKdXMr?=
 =?utf-8?B?R2ExcW9aVTJpYmIyNEl5d1h4Zkhvc3BPRjl6eEYrSzBzbzYrRUhnZnRldjNw?=
 =?utf-8?B?cHJFUk5vREhIMURFWm1aKzRoTVRUWXd0TFhwcHBSOVhZRDljRm96NWlqZ2hL?=
 =?utf-8?B?NEt5YlgrQzQzd2NGZEVoTDJXRm5STHVWbkZ5aXU3aWhmK1lnZVpySXM4YWFt?=
 =?utf-8?B?UElZTU90SlhiWXNMNVVTdk51Ri83VTlWVWFxem5kMDJiUkZMSHZ2ZWpyWnlE?=
 =?utf-8?B?cUNTRjN2Q1pjaGF5UFo2YnBDS2VwOVU0ak16U09COFFUSEJ2cVFjYXdGeG1M?=
 =?utf-8?B?RmV5ZnNDQ0RHcEJkWHpxakNtV3BjTVdmYzQ0YTdGTW1ucHRwOUZLcG5LY3k1?=
 =?utf-8?B?WEFXQWQzbmdrcjNKY3dZRnJrTnB6WUZSeXc5ZSsxY0U4alI3WUQzN0tzdGtN?=
 =?utf-8?B?TU8vYmFJTTlzMjlIZEpQRnV1VEQzb0lSd1kvQmFEMXc5S0tGRGcrbDdLRDV3?=
 =?utf-8?B?bktwcnVycjNoSVdTQWFxVkdIbjExbkZMSFN4WFdtUm5SSXIvVStScDRLSkxx?=
 =?utf-8?B?a3FQWDRZWUlYL3NsVzNYZmhpRld0NzJGNWlYdVlxbVkxamhzUndhMmdqWjJy?=
 =?utf-8?B?QzFpY3ZDOVBmMXoxMlk5d2xCbklpbFBJdjRuWDY5WUhVTTdOV2NGU04vbVNL?=
 =?utf-8?B?VXJsRk5qUk81bnhUZHB4WUczS1hsM2pSZklJQ2V0cmNHeDlINFJyWjg1ZkFE?=
 =?utf-8?B?MjJER2l0Rmpmd05iMll5QWU3YjFKbjVlSW1vTkF4dTYwTWtjM2tyYzBxcG1R?=
 =?utf-8?B?SDJoaFhQVFdsNmVjdC9LQjZWSHRnT1NSUTVhVUpoTVo2UEdQbGI0VHk3ZHhK?=
 =?utf-8?B?dnk4bkN6bTQ0b2dGWlRXOXlGN1VJeWhWU2JqKzU2bGNSOS9IenBQdDBlYlFj?=
 =?utf-8?B?RFFxT3ErUEN1TjZpZWRvb1V0eU9KbzNSeFpTeU1wZlZnaVhkV0xqdGlZbEE3?=
 =?utf-8?B?YjZnVG1Cd1lQZzRjUEpjdzZ3a2J6ZmQ3SkdHbEZHRUNSaWg2WWhRL1pJZjRB?=
 =?utf-8?B?ZFZMczYxNEZuWVpQdE9TT0p3M21HNDJZWUNYTEJ1d3hZb0o4RTZ6ZzUyL0dM?=
 =?utf-8?B?ejJ4cmxjaGdlQXhzNjl5ODFRZVJVTmtrUDJxSUFtd2dHYmxHOE0yNHJFQ1M1?=
 =?utf-8?B?NEMwS3lkSHdhTnkvNjJjWWhrT3VDaWhTRUdwY2lTMVZoM3RUWEIwbHM1WXhu?=
 =?utf-8?B?cE00NEd5K2FkVDNiZk5weXhaeStBcHJjbHY4eEdCV0p2OE5ZVUQ2NXdBYXpF?=
 =?utf-8?B?VVNuZ0VYR2dNYXUzSVhjVmNrRENBeTlkV083N2c4VG1WZy80UUxHZitDSVln?=
 =?utf-8?B?OUdFd3V3UjJ2UEMxZXFVYmFRKzlxQXVnaUpQZTVDajU1YXRRWWthQndJWXUr?=
 =?utf-8?B?OGlGSHhZQk4yM2NkekdaaUM2elcvV2EvOGpvamdxbEF1UFUxWllEZ1Z6Wm5p?=
 =?utf-8?B?NnRXbUNJc1U4QXNMMzRKeUVmMGNPVk85ZHVvN1E3UXJvc3QwQ2F2b3FTanhG?=
 =?utf-8?B?SmNSdGIwckw3MjRnT0xtUzllNGZmUzdRSC9RZ1I5TTFhL0dMbGZLTmRuUHh3?=
 =?utf-8?B?OEV5aXlaWDN5RXdSYzdTRnptQWtmZUR0V0lzOWxJdkltbFlqaGVvNFpDZ2lD?=
 =?utf-8?B?ZkoyMHZnNHhzWkdNNGZTSENxbjU3WFN4Tm52Vkd4QVpFZVk0N1hWZ3M3OUNC?=
 =?utf-8?B?SUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <43B1FE8D2DA28D4687D724B291435885@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37294eb6-1fff-414e-f576-08dc44b23b78
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2024 05:39:07.2000
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r9KKwPojiv8IbakRTlwgl0RGu0hPhSXivzwVCWydgs4U4faOes5k9hmgKHMCwx81qZ8TWi5bKd4868qf/NIkhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7096
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTAzLTE1IGF0IDEzOjExICswODAwLCBMaSwgWGlhb3lhbyB3cm90ZToNCj4g
PiBIZXJlIGlzIHdoYXQgSXNha3UgY2FuIGRvIHVzaW5nIHRoZSBjdXJyZW50IEFQSToNCj4gPiAN
Cj4gPiDCoAl1NjQgbnVtX2NwdWlkX2NvbmZpZzsNCj4gwqA+DQo+ID4gDQo+ID4gwqAJLi4uDQo+
ID4gDQo+ID4gwqAJdGR4X3N5c19tZXRhZGF0YV9maWVsZF9yZWFkKE5VTV9DUFVJRF9DT05GSUcs
ICZudW1fY3B1aWRfY29uZmlnKTsNCj4gPiANCj4gPiDCoAl0ZHhfaW5mbyA9IGt6YWxsb2MoY2Fs
Y3VsYXRlX3RkeF9pbmZvX3NpemUobnVtX2NwdWlkX2NvbmZpZyksIC4uLik7DQo+ID4gDQo+ID4g
wqAJdGR4X2luZm8tPm51bV9jcHVpZF9jb25maWcgPSBudW1fY3B1aWRfY29uZmlnOw0KPiANCj4g
RG9zZW4ndCBudW1fY3B1aWRfY29uZmlnIHNlcnZlIGFzIHRlbXBvcmFyeSB2YXJpYWJsZSBpbiBz
b21lIHNlbnNlPw0KDQpZb3UgbmVlZCBpdCwgcmVnYXJkbGVzcyB3aGV0aGVyIGl0IGlzIHU2NCBv
ciB1MTYuDQoNCj4gDQo+IEZvciB0aGlzIGNhc2UsIGl0IG5lZWRzIHRvIGJlIHVzZWQgZm9yIGNh
bGN1bGF0aW5nIHRoZSBzaXplIG9mIHRkeF9pbmZvLiANCj4gU28gd2UgaGF2ZSB0byBoYXZlIGl0
LiBCdXQgaXQncyBub3QgdGhlIGNvbW1vbiBjYXNlLg0KPiANCj4gRS5nLiwgaWYgd2UgaGF2ZSBh
bm90aGVyIG5vbi11NjQgZmllbGQgKGUuZy4sIGZpZWxkX3gpIGluIHRkeF9pbmZvLCB3ZSANCj4g
Y2Fubm90IHRvIHJlYWQgaXQgdmlhDQo+IA0KPiAJdGR4X3N5c19tZXRhZGF0YV9maWVsZF9yZWFk
KEZJRUxEX1hfSUQsICZ0ZHhfaW5mby0+ZmllbGRfeCk7DQo+IA0KPiB3ZSBoYXZlIHRvIHVzZSBh
IHRlbXBvcmFyeSB1NjQgdmFyaWFibGUuDQoNCkxldCBtZSByZXBlYXQgYmVsb3cgaW4gbXkgX3By
ZXZpb3VzXyByZXBseToNCg0KIg0KT25lIGV4YW1wbGUgdGhhdCB0aGUgY3VycmVudCB0ZHhfc3lz
X21ldGFkYXRhX2ZpZWxkX3JlYWQoKSBkb2Vzbid0IHF1aXRlIGZpdCBpcw0KeW91IGhhdmUgc29t
ZXRoaW5nIGxpa2UgdGhpczoNCg0KCXN0cnVjdCB7DQoJCXUxNiB3aGF0ZXZlcjsNCgkJLi4uDQoJ
fSBzdDsNCg0KCXRkeF9zeXNfbWV0YWRhdGFfZmllbGRfcmVhZChGSUVMRF9JRF9XSEFURVZFUiwg
JnN0LndoYXRldmVyKTsNCg0KQnV0IGZvciB0aGlzIHVzZSBjYXNlIHlvdSBhcmUgbm90IHN1cHBv
c2VkIHRvIHVzZSB0ZHhfc3lzX21ldGFkYXRhX2ZpZWxkX3JlYWQoKSwNCmJ1dCB1c2UgdGR4X3N5
c19tZXRhZGF0YV9yZWFkKCkgd2hpY2ggaGFzIGEgbWFwcGluZyBwcm92aWRlZCBhbnl3YXkuDQoi
DQoNClNvIHNvcnJ5IEkgYW0gbm90IHNlZWluZyBhIHJlYWwgZXhhbXBsZSBmcm9tIHlvdS4NCg0K

