Return-Path: <kvm+bounces-12920-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C0C0588F42C
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 01:48:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 39D181F3452B
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 00:48:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F98F17BB9;
	Thu, 28 Mar 2024 00:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SDldhHPE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEEDBEEB3;
	Thu, 28 Mar 2024 00:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711586744; cv=fail; b=itpl+eyM0miCs1eSdixhNZXkd+PIjT+VECxJZvIgKXxJygPwMp5RnFDU4U28g1QfmJW9PQCyufhMX9QpVhFTFxgEN1jkBfi+zie5+IFk4FmGBgp3mDyPTuVTdYWuOFrZnRAc1abTPgnpMHCu9ZEQIu+kRvi5eqOZ+57HvhnOu84=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711586744; c=relaxed/simple;
	bh=TbpyyAnabrals/Kfpn81axVTf8E64dwXnZhKGG31FIA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=rFhmxIHHo6LaogQAOEkJ8yk17OGT9rTr0gcymRCrnhh9naIYRgBeJLcz0fCmXWQI2220EfnYhvOjCeuLDkLtLFGXOeBP2gFYm6vqOR4HxKRFjVYaUVxEXV8kE4vJYm9GPwFptc/rC5GhINSvaJugfdtPfPP5BX/ogGKygHg3OGE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SDldhHPE; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711586743; x=1743122743;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=TbpyyAnabrals/Kfpn81axVTf8E64dwXnZhKGG31FIA=;
  b=SDldhHPEfseG0aGLEaUJhVuTZ64ZZ2y48mNhBt/i7JY4hI8Xclg5V9PC
   XOGw03Z2Zmaq7cuzG6yd5rzOCs6e6NE/3FQDeKrbm8AFNAIewZipUWrL1
   Ef7B7Szhoy/jwj+a8mVf+xSBZsD7czhtDGtRgtn6r7+eb/U96OhOIxmHv
   XyDYB5y51UtluT8V223a7WUsEyjjOg2z93KxbaAYNNUquo93Qnykh6MIp
   RmaEJOoNVGHLf7+xZGEaWzBbfraTiA2sIt2e/tvboKIND1aNUb3NuVyk8
   s2ffu9C9ykEL38c4eKPmoWELgCmKR9vCiCrPyi47kN1yDS+Mb5XakxFap
   A==;
X-CSE-ConnectionGUID: HjCetW7kQDup1sQAJuLHpQ==
X-CSE-MsgGUID: t/oQOU4aSZqmb9utQHYQIA==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="6833845"
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="6833845"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 17:45:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="21161715"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Mar 2024 17:45:41 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 27 Mar 2024 17:45:39 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 27 Mar 2024 17:45:39 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 27 Mar 2024 17:45:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FgMIX8zF9XsfplCwVB6kLRiSuj7PdQA36U3TiIHZY5dnIb57eJRDMpekdxLedH3Hop0OvZWB83dVKYcEbB1R2AQ7Ea2IWSyA0sl+5/Uly4JwBQa/Gtey+rRHBsoys3HycBFFLMbMepSTiuUd6Dc4b2GfdYciViydbPE1kS6Ee57r2E5Lx8vgJ7gi+5sjoRCzWUd6w5IesXXC9+oDlyIZVUmK1Klof30nD4P4S3XwV6RR0Z0IaUduiFAG2v56BC9VPXo2MGzoTjAg31IgqYCEw91i+iDbCzwkpA3L5LNySJ1+Du+lv5FubSk6Z5wRAtPTiA0XHduEuZVUQN+Dh3wqmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TbpyyAnabrals/Kfpn81axVTf8E64dwXnZhKGG31FIA=;
 b=cQY0KPpFv32SA4Oup+nN5VqPnMnJ+8bJONoAbu3kBfI0n/zCgsLUt5eqeDArM0YRIy82FniZh69bMqmUOCAucF4+njU/G09P3jUOkW6TV84050HPNUIWN7TWn6FTx4Lh5czH72wdn/g/FSRdWxMhi2ge2hOYv8cs/HfLrAXMXGRZ+Pkr3XIhfKbi1Z4bAbP1VvNj7hRGUyA21TzLSmvuQ8eLpkf1p7+hkxLgRxj+fB76EAm/XttOMe+BSwQL8nUoXrMwNnrxt54pOMWUVUgjuQ5ZYZrjAYNlEPuy+tTskTtP24t/kLdein4l6GFmjhJcjhAf23TMlz+BSOUwUHTz3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MW3PR11MB4748.namprd11.prod.outlook.com (2603:10b6:303:2e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Thu, 28 Mar
 2024 00:45:35 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7409.028; Thu, 28 Mar 2024
 00:45:35 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Gao, Chao" <chao.gao@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yuan, Hang"
	<hang.yuan@intel.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Subject: Re: [PATCH v19 059/130] KVM: x86/tdp_mmu: Don't zap private pages for
 unsupported cases
Thread-Topic: [PATCH v19 059/130] KVM: x86/tdp_mmu: Don't zap private pages
 for unsupported cases
Thread-Index: AQHadnqpCkdQcpy1UEaf8e2/el3pBrE+L/IAgAGVVQCAABCvgIABmDGAgAFrqACAABw5gIAF68uAgAAN3oCAACgcAIAADqEAgAAC4oCAAAP3AIAAMXQAgAAC04CAAI7TAIAAbmyAgACYeICAAPZDAIAAbS+AgAAKzwA=
Date: Thu, 28 Mar 2024 00:45:35 +0000
Message-ID: <e0ac83c57da3c853ffc752636a4a50fe7b490884.camel@intel.com>
References: <96fcb59cd53ece2c0d269f39c424d087876b3c73.camel@intel.com>
	 <20240325190525.GG2357401@ls.amr.corp.intel.com>
	 <5917c0ee26cf2bb82a4ff14d35e46c219b40a13f.camel@intel.com>
	 <20240325221836.GO2357401@ls.amr.corp.intel.com>
	 <20240325231058.GP2357401@ls.amr.corp.intel.com>
	 <edcfc04cf358e6f885f65d881ef2f2165e059d7e.camel@intel.com>
	 <20240325233528.GQ2357401@ls.amr.corp.intel.com>
	 <ZgIzvHKobT2K8LZb@chao-email>
	 <20db87741e356e22a72fadeda8ab982260f26705.camel@intel.com>
	 <ZgKt6ljcmnfSbqG/@chao-email>
	 <20240326174859.GB2444378@ls.amr.corp.intel.com>
	 <481141ba-4bdf-40f3-9c32-585281c7aa6f@intel.com>
	 <34ca8222fcfebf1d9b2ceb20e44582176d2cef24.camel@intel.com>
	 <873263e8-371a-47a0-bba3-ed28fcc1fac0@intel.com>
In-Reply-To: <873263e8-371a-47a0-bba3-ed28fcc1fac0@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MW3PR11MB4748:EE_
x-ms-office365-filtering-correlation-id: 1f301913-0717-4a1e-c485-08dc4ec0614c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GDP/J4VQDxeoiAR2ljlhwV2T6iz9N2fnI6iXIY8HVC5RokvuJlYGEtrsLvTGTy+DTgXBylpba3FSBD4ExnkUgkLOjDDAQDxaB+VUIk2mKxYMWrbfH5TZcbyYQ5Zp1QHKcO9zjf7AUNDkWA9r8+UU9p6sXf3ETwY90Zl5QARQGRasOs92kB7fxs2wE6JU9ZYaDhUCfVqlwSyPRGVf+qVrsBeffclFgIXkJrVIyLUhIa/jyZaSk/KZlQWcGlbMENspexokLcqmaOXI8QCBdQ8Y8pTUefDx0DBXdbSUtq7zzRWoBSK2/NjCQ7Iu+/WRPxlFgJZA0FN/2W6QHR3BMRspZIAXopSJv5jUHl1SIrBJ7u1YpW0LTGTcT6uNmnxggzL/na0VJrw1s+hYcLATvwN11mWIcRfifLNsC5YAQQrnYo8neB7bw+CDDhCvWolT64oj+KGP64/bX2SVj8rothRA+pN8yZGgQieqBScdrbPiQD/tVmMG9iNxp2jd++e1XMEBSe3h7U+Jtj1VxQmBC/RHSdlgAs9ucHz856GdeuYibBIu7vIDkcIEJaBQncDEkAPpq+2tajWMIqP9BCIoJzmcEDCXN/yM/ANgr5+bLS3+fgT8lz2J1XNMprRiQRciAaKdisTasaTHk0r125rYKnCwFk7N8VYQPflRq8J11gAt2II=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WjNPZ2Q5ZlR1akhET29xMGN4RGRGaVg1N2llbGNGdElhM25hK1phb0RoSlVP?=
 =?utf-8?B?ejBQSHpzTmhScWJyQjNKYjRTT2RQV2oxSVhUMDlzVDNreDFRRjNtQ3cxWUlY?=
 =?utf-8?B?eW5VZU55aUs2cnpPenBhTWFaWEVRS05iL24xSlkwVGNyZ3AvMVZ5RmcrR3JG?=
 =?utf-8?B?RzVLNnZ4QTlDNTZndkFob3N0U3ZVQ1pYM3BCRFpPdXd4TjJOVE5EUnRzdTVG?=
 =?utf-8?B?cFJ6d0RVNlBETDk3V0FaN0d6KzFSRGN0MnFGNDRlWm8xRWNsbWkwa3huNFAx?=
 =?utf-8?B?QUdseWhoVVRHdER5M25DK2dUdzVldTZmNU12TnN3MDgwL3BmNlhDM2dhaVRa?=
 =?utf-8?B?bWkvaEVEUWtjdWJxeDdGcnhvcy8vZ1JidElZM3pCZFd0cUJDcThBekdDTVRS?=
 =?utf-8?B?WlpuVHN4ZWtDVnNyWkEwREJGdXRhWExxdS9nS2lSeWpWaTdDTUVrRDhraXdv?=
 =?utf-8?B?TVpKYnJTRXZGMTBCZ1d0ejdoa1VVQ0h1ZkZORkExUzQyeGlKWEwzWHlRU3Ry?=
 =?utf-8?B?VGNCeXZ0K2dEQjU5ay93N0NjUU1vZHZ4SEJ4ZFk1RFlsaW40SS8vTVJxbytI?=
 =?utf-8?B?SUVJUnVPNWwwbld2cTYyYWhXK0w1ank1eTRhemFIZmNSV1EvNnZ6SENFQU9z?=
 =?utf-8?B?UFArWUdjTUl4NkFKSzJIK25pVzBEUGhDZlJ2Y0RRQ3VRdm8wdWZjZjZUakxv?=
 =?utf-8?B?ZGZzTnQzU3RwRWU3cDhkbVBjZW90eHFvd2h5RlJ5WEllTmQ3cnU4QnQxU01t?=
 =?utf-8?B?ejlaWllwdDdGUkFjbW4yekJkWFoza01WVmFIcENZamhVdmt4bEpFYWZsTUZw?=
 =?utf-8?B?ZnFOdjNqZzZDL2ttdzVnK3VkZEYwT09vRi85b2VUVzBDNGhjY3dlN3V3S2RH?=
 =?utf-8?B?UENudU9SankvV1FVcGxuTEkxUG90THZLVGNpR0xMdDFmMjcxRlVQenlnTTRk?=
 =?utf-8?B?clpTZDBNS2pzLzlONi9pMlhSYVZscXBMWHZtNkZIRlV5VlRFTzRoMm1YdUk2?=
 =?utf-8?B?Y3owMVROSG1aajVJalc1d3pTdDMwR0crNmIxcE5nWDVmczJjWkVaNmt5Lzl2?=
 =?utf-8?B?aVFHdlFoZkEraDhkV1hCNWZRU3FPaU8zNWpJWnphdUR5dlZsMmptbXdqUWRi?=
 =?utf-8?B?dkhhS0xZOXJZS1NQRHZlU2FHTTN3aitvd2FzbXk1NGU2ZW05UnVjZXlwWFlZ?=
 =?utf-8?B?MVVNV0lWQVJ6OXN3Qi9BbkFQUmQ0TW5JbmNFZHNBV0JQZUhYb0FsU1d3NHlU?=
 =?utf-8?B?OWhtWTIvYjl6QXdnVWkzKzZxSjlQdUJlcXM5ZTh0TGxUeEpvaWE0cnV3eTBl?=
 =?utf-8?B?V2RJUGdrbzBxdUpsZUd6VXVzQnArMVJOU1JpWHU1TUI4RG9zV1daQ2RpUEpC?=
 =?utf-8?B?WFdDSlJmank3cGV5VnMrTlFyVCs2OUlKblJkR3FrQTJiMWFRV080YkJ5WCta?=
 =?utf-8?B?Y3I1a0NDRVJsU3dENEtPWXhmSWF6NkFLb0dLMHRONG1CbVM5M2pnMjE2NWI3?=
 =?utf-8?B?TXdxUUNvczRqOTYxYWJxeGNoWWJucEptdmJoeVlkLzY4VHNteUNSSWR2aFJr?=
 =?utf-8?B?QzIwVG0yaWN6LzM4OGo0U3NXdFY0c3I3MTlMRjRGLzBtRWx4eDA3bFRsaS8z?=
 =?utf-8?B?anZNTllDTU95NFlOTUZmRDhrRTdzamhvSzR2dXRIM2NtelY3VFIyZEE0UEdF?=
 =?utf-8?B?MFZMTmNVVVJaY0ovNklDcGxhOCtVZ2Z5R2tYdU1FMmE2WkZMNSt4OHpEb1RI?=
 =?utf-8?B?YlQ2dFVjMFFTM0E3dWZ2ckVzK29XZm9VeGw2cG5LWVU1NEZmNXlBNjFVNzgy?=
 =?utf-8?B?c01PMjFCTUFNdkdJMytxZHFlZFd2WTcrM00yQVZOa3ZSdWhUZjFxTVYxK3VF?=
 =?utf-8?B?ZkdaVkYwMUVBclN0ZFBIZC9EcFlUdUcvektGVzZ5MGxMeWFCdFB4bzg0RlVL?=
 =?utf-8?B?SDZSZ3ZZcUpqK1dpaFBPRmpOZk5QaGd1d3BrOWdKUWp4VzNNdnM1ajgyRU9n?=
 =?utf-8?B?aTIrOEpjWXM1dDU2VVhqWWVZTUE1WU1TOUI4enF2eTVtU0lJUGpuaFpxY2ts?=
 =?utf-8?B?dWVEeGttMGltSVpXbzN2Mm81ajFPelZaMkJUQXJZaW9jNnYyTFM3OUJnR2RH?=
 =?utf-8?B?UE9JaXkwZXV5eWpPTlh0bERvRytDUUhFSWhpRE5nUjJpRGZ3UjlZMDlKVVBO?=
 =?utf-8?Q?KuQGbawOD10StcvN8ZmSHcU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <616832B7DF1BF94EAB4748AD339C21AE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f301913-0717-4a1e-c485-08dc4ec0614c
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2024 00:45:35.2361
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hpIdO8X9couUJ7HZH9ZEKdfKE0vsYaCurPQde4yIHFG92PAjLpuFOwjNL5IaoPHiWtPEW3hm7U7AEwcNAz8mYsP0Tl/0e6pCS2/jVa4LxHc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4748
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTAzLTI4IGF0IDA4OjA2ICswODAwLCBYaWFveWFvIExpIHdyb3RlOg0KPiAN
Cj4gVERYIHNwZWMgc3RhdGVzIHRoYXQNCj4gDQo+IMKgwqAgMTguMi4xLjQuMSBNZW1vcnkgVHlw
ZSBmb3IgUHJpdmF0ZSBhbmQgT3BhcXVlIEFjY2Vzcw0KPiANCj4gwqDCoCBUaGUgbWVtb3J5IHR5
cGUgZm9yIHByaXZhdGUgYW5kIG9wYXF1ZSBhY2Nlc3Mgc2VtYW50aWNzLCB3aGljaCB1c2UgYQ0K
PiDCoMKgIHByaXZhdGUgSEtJRCwgaXMgV0IuDQo+IA0KPiDCoMKgIDE4LjIuMS40LjIgTWVtb3J5
IFR5cGUgZm9yIFNoYXJlZCBBY2Nlc3Nlcw0KPiANCj4gwqDCoCBJbnRlbCBTRE0sIFZvbC4gMywg
MjguMi43LjIgTWVtb3J5IFR5cGUgVXNlZCBmb3IgVHJhbnNsYXRlZCBHdWVzdC0NCj4gwqDCoCBQ
aHlzaWNhbCBBZGRyZXNzZXMNCj4gDQo+IMKgwqAgVGhlIG1lbW9yeSB0eXBlIGZvciBzaGFyZWQg
YWNjZXNzIHNlbWFudGljcywgd2hpY2ggdXNlIGEgc2hhcmVkIEhLSUQsDQo+IMKgwqAgaXMgZGV0
ZXJtaW5lZCBhcyBkZXNjcmliZWQgYmVsb3cuIE5vdGUgdGhhdCB0aGlzIGlzIGRpZmZlcmVudCBm
cm9tIHRoZQ0KPiDCoMKgIHdheSBtZW1vcnkgdHlwZSBpcyBkZXRlcm1pbmVkIGJ5IHRoZSBoYXJk
d2FyZSBkdXJpbmcgbm9uLXJvb3QgbW9kZQ0KPiDCoMKgIG9wZXJhdGlvbi4gUmF0aGVyLCBpdCBp
cyBhIGJlc3QtZWZmb3J0IGFwcHJveGltYXRpb24gdGhhdCBpcyBkZXNpZ25lZA0KPiDCoMKgIHRv
IHN0aWxsIGFsbG93IHRoZSBob3N0IFZNTSBzb21lIGNvbnRyb2wgb3ZlciBtZW1vcnkgdHlwZS4N
Cj4gwqDCoMKgwqAg4oCiIEZvciBzaGFyZWQgYWNjZXNzIGR1cmluZyBob3N0LXNpZGUgKFNFQU1D
QUxMKSBmbG93cywgdGhlIG1lbW9yeQ0KPiDCoMKgwqDCoMKgwqAgdHlwZSBpcyBkZXRlcm1pbmVk
IGJ5IE1UUlJzLg0KPiDCoMKgwqDCoCDigKIgRm9yIHNoYXJlZCBhY2Nlc3MgZHVyaW5nIGd1ZXN0
LXNpZGUgZmxvd3MgKFZNIGV4aXQgZnJvbSB0aGUgZ3Vlc3QNCj4gwqDCoMKgwqDCoMKgIFREKSwg
dGhlIG1lbW9yeSB0eXBlIGlzIGRldGVybWluZWQgYnkgYSBjb21iaW5hdGlvbiBvZiB0aGUgU2hh
cmVkDQo+IMKgwqDCoMKgwqDCoCBFUFQgYW5kIE1UUlJzLg0KPiDCoMKgwqDCoMKgwqAgbyBJZiB0
aGUgbWVtb3J5IHR5cGUgZGV0ZXJtaW5lZCBkdXJpbmcgU2hhcmVkIEVQVCB3YWxrIGlzIFdCLCB0
aGVuDQo+IMKgwqDCoMKgwqDCoMKgwqAgdGhlIGVmZmVjdGl2ZSBtZW1vcnkgdHlwZSBmb3IgdGhl
IGFjY2VzcyBpcyBkZXRlcm1pbmVkIGJ5IE1UUlJzLg0KPiDCoMKgwqDCoMKgwqAgbyBFbHNlLCB0
aGUgZWZmZWN0aXZlIG1lbW9yeSB0eXBlIGZvciB0aGUgYWNjZXNzIGlzIFVDLg0KPiANCj4gTXkg
dW5kZXJzdGFuZGluZyBpcyB0aGF0IGd1ZXN0IE1UUlIgZG9lc24ndCBhZmZlY3QgdGhlIG1lbW9y
eSB0eXBlIGZvciANCj4gcHJpdmF0ZSBtZW1vcnkuIFNvIHdlIGRvbid0IG5lZWQgdG8gemFwIHBy
aXZhdGUgbWVtb3J5IG1hcHBpbmdzLg0KDQpSaWdodCwgS1ZNIGNhbid0IHphcCB0aGUgcHJpdmF0
ZSBzaWRlLg0KDQpCdXQgd2h5IGRvZXMgS1ZNIGhhdmUgdG8gc3VwcG9ydCBhICJiZXN0IGVmZm9y
dCIgTVRSUiB2aXJ0dWFsaXphdGlvbiBmb3IgVERzPyBLYWkgcG9pbnRlZCBtZSB0byB0aGlzDQp0
b2RheSBhbmQgSSBoYXZlbid0IGxvb2tlZCB0aHJvdWdoIGl0IGluIGRlcHRoIHlldDoNCmh0dHBz
Oi8vbG9yZS5rZXJuZWwub3JnL2t2bS8yMDI0MDMwOTAxMDkyOS4xNDAzOTg0LTEtc2VhbmpjQGdv
b2dsZS5jb20vDQoNCkFuIGFsdGVybmF0aXZlIGNvdWxkIGJlIHRvIG1pcnJvciB0aGF0IGJlaGF2
aW9yLCBidXQgbm9ybWFsIFZNcyBoYXZlIHRvIHdvcmsgd2l0aCBleGlzdGluZyB1c2Vyc3BhY2UN
CnNldHVwLiBLVk0gZG9lc24ndCBzdXBwb3J0IGFueSBURHMgeWV0LCBzbyB3ZSBjYW4gdGFrZSB0
aGUgb3Bwb3J0dW5pdHkgdG8gbm90IGludHJvZHVjZSB3ZWlyZA0KdGhpbmdzLg0KDQo+IA0KPiA+
ID4gPiA+IEJ1dCBndWVzdHMgd29uJ3QgYWNjZXB0IG1lbW9yeSBhZ2FpbiBiZWNhdXNlIG5vIG9u
ZQ0KPiA+ID4gPiA+IGN1cnJlbnRseSByZXF1ZXN0cyBndWVzdHMgdG8gZG8gdGhpcyBhZnRlciB3
cml0ZXMgdG8gTVRSUiBNU1JzLiBJbiB0aGlzIGNhc2UsDQo+ID4gPiA+ID4gZ3Vlc3RzIG1heSBh
Y2Nlc3MgdW5hY2NlcHRlZCBtZW1vcnksIGNhdXNpbmcgaW5maW5pdGUgRVBUIHZpb2xhdGlvbiBs
b29wDQo+ID4gPiA+ID4gKGFzc3VtZSBTRVBUX1ZFX0RJU0FCTEUgaXMgc2V0KS4gVGhpcyB3b24n
dCBpbXBhY3Qgb3RoZXIgZ3Vlc3RzL3dvcmtsb2FkcyBvbg0KPiA+ID4gPiA+IHRoZSBob3N0LiBC
dXQgSSB0aGluayBpdCB3b3VsZCBiZSBiZXR0ZXIgaWYgd2UgY2FuIGF2b2lkIHdhc3RpbmcgQ1BV
IHJlc291cmNlDQo+ID4gPiA+ID4gb24gdGhlIHVzZWxlc3MgRVBUIHZpb2xhdGlvbiBsb29wLg0K
PiA+ID4gPiANCj4gPiA+ID4gUWVtdSBpcyBleHBlY3RlZCB0byBkbyBpdCBjb3JyZWN0bHkuwqAg
VGhlcmUgYXJlIG1hbnl3YXlzIGZvciB1c2Vyc3BhY2UgdG8gZ28NCj4gPiA+ID4gd3JvbmcuwqAg
VGhpcyBpc24ndCBzcGVjaWZpYyB0byBNVFJSIE1TUi4NCj4gPiA+IA0KPiA+ID4gVGhpcyBzZWVt
cyBpbmNvcnJlY3QuIEtWTSBzaG91bGRuJ3QgZm9yY2UgdXNlcnNwYWNlIHRvIGZpbHRlciBzb21l
DQo+ID4gPiBzcGVjaWZpYyBNU1JzLiBUaGUgc2VtYW50aWMgb2YgTVNSIGZpbHRlciBpcyB1c2Vy
c3BhY2UgY29uZmlndXJlcyBpdCBvbg0KPiA+ID4gaXRzIG93biB3aWxsLCBub3QgS1ZNIHJlcXVp
cmVzIHRvIGRvIHNvLg0KPiA+IA0KPiA+IEknbSBvayBqdXN0IGFsd2F5cyBkb2luZyB0aGUgZXhp
dCB0byB1c2Vyc3BhY2Ugb24gYXR0ZW1wdCB0byB1c2UgTVRSUnMgaW4gYSBURCwgYW5kIG5vdCBy
ZWx5IG9uDQo+ID4gdGhlDQo+ID4gTVNSIGxpc3QuIEF0IGxlYXN0IEkgZG9uJ3Qgc2VlIHRoZSBw
cm9ibGVtLg0KPiANCj4gV2hhdCBpcyB0aGUgZXhpdCByZWFzb24gaW4gdmNwdS0+cnVuLT5leGl0
X3JlYXNvbj8gDQo+IEtWTV9FWElUX1g4Nl9SRE1TUi9XUk1TUj8gSWYgc28sIGl0IGJyZWFrcyB0
aGUgQUJJIG9uIA0KPiBLVk1fRVhJVF9YODZfUkRNU1IvV1JNU1IuDQoNCkhvdyBzbz8gVXNlcnNw
YWNlIG5lZWRzIHRvIGxlYXJuIHRvIGNyZWF0ZSBhIFREIGZpcnN0Lg0K

