Return-Path: <kvm+bounces-11663-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BD81879444
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 13:38:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B416AB24098
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 12:38:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0DED557307;
	Tue, 12 Mar 2024 12:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mzdlro3R"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63014811;
	Tue, 12 Mar 2024 12:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710247102; cv=fail; b=RgqAG99czZ2gU562RQlWYMT3WsX82cwlgErNEaK8zWjEJyBh9xj1Pxc1+XxeN1rlcHojonD6yrZBbwbeATmxroBhDtknyiu3XaNvbTtTApXcPoetAY0aq/T9aDeaggTclHv1H01bL8ZA/AH0qpBFT++J3TzzedxxxiraYYpM3Zs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710247102; c=relaxed/simple;
	bh=3KXKfFbhzlI89OC2GqSOS3qAIgZJovbJt+iIusuby18=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=U7002kyKGpef4VJi7ufrfU4oR7c1diV/usO60TLNmpuXxgRzfSu14Ti6NiAnWZjaAErg5TMdB9SrcnL1q8GTX3LcoS61JrGtVgyfSpO8MaWcXYZ1jrAislhoL/OiQTu3lFwsVjTlCJO3DY+T8HfnmBlaEQxiWgxiELL3KidriHE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mzdlro3R; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710247100; x=1741783100;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=3KXKfFbhzlI89OC2GqSOS3qAIgZJovbJt+iIusuby18=;
  b=mzdlro3RVR2G6D8QafTYrHjGwepLGBYT0nGtrXq5C65bUXVIGLKr/nAh
   Woef283elfI8DO6clnNFKVeNXoTz1BeUyJYFKDGoLJp7VerW4ZDMU1hQa
   wHoNVPZAChuotwW2kpbn/LNsy23gdcVVa7eewPNzrLJ++TbCYR7p0wtBJ
   IdWCGrlK4EjQejSI6JMuEr55lXUrIlkKlISTlclGal/AI5vgvUbo86MUz
   V4Vr5NNtV/j/bCezaydtD8qBOdH/4i1FJlVGnnNhG0okCebEy6TxrDuSa
   K85cC+fxQp8JdsnTetjUGcPrcoLQhywQCiqZpcw9zAAX+CPaDZ4UJIeSm
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11010"; a="5078224"
X-IronPort-AV: E=Sophos;i="6.07,119,1708416000"; 
   d="scan'208";a="5078224"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2024 05:38:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,119,1708416000"; 
   d="scan'208";a="16178086"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Mar 2024 05:38:19 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 12 Mar 2024 05:38:18 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 12 Mar 2024 05:38:18 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 12 Mar 2024 05:38:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ObKTa8xDMkbrDNS70EUhFSbeBaja1E9aDL8HVMdmJKRNK18jNd8zc2OTZKxYgr5kPyz0nbZXDjnIOutUaxBG/uwmCClb98S8+4wj7zAhU8KR1yK7Br4kxNS2lGs2RJFfF5Keh/hFavHVdnQ0nRSw/4AZ5BgPTfynAqrX547u+m1L9rozDDHOzw1lTigyw7YH+UkIk2irezYEVl1GoEBeagHuehlo0yZM3zLDfY6UFMH1pJaOMZGjO95Y9CcZyrOlb79y3Mih7ruDy+RkL6MNpMZcpPvFGx40EtRcv8DHeWYrRcipWO08SI5RoILWUcGmsILrXE160XXEVh3Frm9Fnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3KXKfFbhzlI89OC2GqSOS3qAIgZJovbJt+iIusuby18=;
 b=IFB0vAlMP5zaqVohwJrSJrcDA/Eb3YTeZpgw0GIGnjWLjLtPgizoezeYYX7k8uH2hdzrhWmGB1O8gzXkls7V/ejOmamkQSp+e0fgHN73PpBIr4FuW8rxXzSnPZgHjR1CXPwP8/JPqglwAG+a9TnKETAgHp8BoTIeH3N/78JzgM6saI+h+S/eTqczAnz/2ulX0bOOltNbACDBoa1X5RZNuC7gi2iBDLpdOFTw8UjXRg50EcuWNxTGH6weEYS06g75AaGH3y548elUUfbukTfp96TAzRAslFoTLviCFcVBWif6fnTmy3W8pQS+mpyKOhqEkvbVw3yJehe+TeUZNVnBKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB6528.namprd11.prod.outlook.com (2603:10b6:8:8f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.17; Tue, 12 Mar
 2024 12:38:15 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7386.015; Tue, 12 Mar 2024
 12:38:15 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "federico.parola@polito.it"
	<federico.parola@polito.it>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"dmatlack@google.com" <dmatlack@google.com>
Subject: Re: [RFC PATCH 6/8] KVM: x86: Implement kvm_arch_{,
 pre_}vcpu_map_memory()
Thread-Topic: [RFC PATCH 6/8] KVM: x86: Implement kvm_arch_{,
 pre_}vcpu_map_memory()
Thread-Index: AQHaa/6D7nn573Vr+E2nz60+bAfcD7EzPxoAgADdMoA=
Date: Tue, 12 Mar 2024 12:38:15 +0000
Message-ID: <6b38d1ea3073cdda0f106313d9f0e032345b8b75.camel@intel.com>
References: <cover.1709288671.git.isaku.yamahata@intel.com>
	 <66a957f4ec4a8591d2ff2550686e361ec648b308.1709288671.git.isaku.yamahata@intel.com>
	 <Ze-TJh0BBOWm9spT@google.com>
In-Reply-To: <Ze-TJh0BBOWm9spT@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM4PR11MB6528:EE_
x-ms-office365-filtering-correlation-id: ef88fe5f-bc29-42d5-6c98-08dc429149e5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5GPNdFTE7FkGFybX/w3aR9Vw5t8bcDh2/tlJVEc7y8y/GE6KhgSAxAAkj1vAjKUX2rid3helzXrZmvkGSuDYvo8ypUUQ91uAukufQ6y/zEddKlJfsqzEoaW2l9FvWgzckCUY62N9x++m9hksODaU1BKwkJaUl7FTQx8jZ+8RUCNlQCU2IyySc6q8tdlNfE1DUaornrPnON8sTGhAHKxSEA/QOUclP4s8cLunidPnTKP8vFvOyeW0871o5Lu0GXMeV9NLxkQr1/vV6FbR+vVrB8QfdVKsMUmUhXJOl4WngFw0FoMkd4G9r1pdhTJzMtwHFqaaYePvnedwDzbN4fsVSKkMzSMFB3n5OygGkEUWNFcl3zEgRPU7FjSjdNDcZm3Wh/u3EySXuQSCVTkCZQEhCVkS89I3SWYLsiizdcYjvkjGZQ+BwYLmm+Xo57dEAsdREAnts6Fi+qOMsdu2NY7+JUvHoBh8+4/r2oDypBWPDkDq8xQAFm92Wod9hu5KZWeNfgQlDh5vc2X++mPZi3wR6qxD6jD+AXmSYSBXVVFPNOzsm2TDPV9xk34IquCyBX/XeNGPLJixyj/TvCl/ELCoY68t7nsQJWFdTPCq97l6AYQRjed6EHXOiL+TiRmRO8blspuI9pYaMkMSfM900Cq8S3IznESUxXU+pFaznV9BfHUazvLJM1BAm6EP1M63YzcNb8HqFbNRCKyqhkzVQCIh7JhWx/QUyFPgrDB29p/DQUo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TmNYaDZYT2ZEY1czbkpYN1BweERCajA4ZmlFYmN3V2s2cWxTN0U0Z3BuQm1U?=
 =?utf-8?B?L2pQbGhTSWdMU3hFQlJFSE5rYlBQT3NyV1BnYjNOQmtlRWdDclZFNDd2dVhs?=
 =?utf-8?B?WmpXU1E5UkJ6YlJFOVVUNThTVjQwRlc5N3F5SmgrK3A4MGd2VE0rRlR1Qlgx?=
 =?utf-8?B?TG82bmVIb3FaU0pVdEtCWGl5NXc3Z2V3KzhOcHZUbjZtWWJmWWpTeFNhZHEx?=
 =?utf-8?B?VnJtL2IxTUh4TWxjMjJPSWFXQWNnUG9WNnBDdTB0Uk8xWU9XNW1QOHQzbytt?=
 =?utf-8?B?Y1gzSzhGWFBlMFJ4eUxVb0QrVU1ybE1RWEFPWlpIYWRHWEswN3d3dWo5c3lM?=
 =?utf-8?B?UFEzTHNMdUdrK2pHRjl1MEN5cE9pNEdPai9uZnR3M3RYTHVJTVc2RDJnR1Y1?=
 =?utf-8?B?Y3FUK2F3UDc2Y2kvVHFXMlR5anc2UGFlUzJORHJhTmlleEwyU0kzTHZGTnM5?=
 =?utf-8?B?dHZ2VjYvMmVxcVJXS3J2R1JXRlZUc2ExWHdtOWZlMkNpTkhWVnVHU1l5S2NY?=
 =?utf-8?B?ZFdhY0k2aWRrWFBTd05HWVFpbGFDbGVHd1phSWpOcnh2RXpXNTFXelhXSGEy?=
 =?utf-8?B?Y2VJWDJrNHNVUTJsVkxTYlhTSUdzWmo1Vy9rcllENW5ldE00b29BUUM1QVNy?=
 =?utf-8?B?aXAybHFIS1lyVkl5ZlEwWFI5VCtqYTloeUtEaHNMRDZ0TGJhamk4aDFXdlRz?=
 =?utf-8?B?Q2t5dk5xL0VjWjVEM3JvNGtSR2pteHRUMWdaaW5QemN1UTcyeEVsMWhSbG80?=
 =?utf-8?B?aDNEcExzRmR6R0o4ZjRmUHEwSVdsRlB2RkdhTHFET2MyL0wyRHJValM1RVhU?=
 =?utf-8?B?RlFHMThuU3VmczJ4WlZ0TzVWQTZUdkJsNklwb1pLa3M1QjcvaEJhR0R5bVBB?=
 =?utf-8?B?YzhTVk9rZWUwbVNHcnZ4bnQ2UERXZGwrRk5TdWtMVEl5WjVIa0tVOEF0YjVI?=
 =?utf-8?B?Q1lDaTRLUzZrMWVHOUNoQ3F1NS9wYUZja3RWQzdVbWlNc0dnMkZjc2gxbDlr?=
 =?utf-8?B?OGpzTlMzTzhOSHhWcHkxRjJmaFpVdHpJTFJVMVVFNHpoLzNlTndmaTRxSndO?=
 =?utf-8?B?OWxwaGZEL3BUY2VSSml5RUxwVGJ2RzZnTEdXbGVKY05JWGdQTjBML0FTWXgy?=
 =?utf-8?B?d2NkMWRKY3VDQzFMRjlhRUFUNHc0SFRBWG1mRjNNaEU1bGhzSjZBRDQ0NjdM?=
 =?utf-8?B?dzFnaVdMeUdPazJ3T1h2VjFaMzZnTUZ1TmRlMEpiSlRIbDk4UUdsMzdsUGYv?=
 =?utf-8?B?WWlRNHlFZk1ESTR0QjQ1UHRKcWZFSFFHRlVLd3cvd1NHZXE2YzExazBaL2ZI?=
 =?utf-8?B?WWpUVVBXYlQya3Vja2JXeWM3TDZUU0JrdHA5ZlJBSXc1WjhLM2NaQi9WZE5M?=
 =?utf-8?B?UFFIVzEyUHVmNzkySW92TFNFMi9CTWFEK2FUUDNEMTdDZE1WRG8xMG5RLzlj?=
 =?utf-8?B?WFprNS9LQ0NueVozbDI0dlBrcURoZXZtaFVDcGpEaXhLTXc1eWlMblRuMTFj?=
 =?utf-8?B?RW0xOGU3aUkxejJ3VXoxOTljSDhTSmcwd2U0YlJJdnlNcWw5WmpuNGUvZFpY?=
 =?utf-8?B?S3V1eXNhUkxIdVRvRG10eDFCMTR5L2YxVURTYXVkNGpLMUdYYTh0VHBkbHVB?=
 =?utf-8?B?Z3VoTlVwRU45ZjZIUE5GMC9MbUNRVkpxWlVtSWxwazFTMHAzNzhEc3NMdFQw?=
 =?utf-8?B?aHlSSFl0Ky9KWlgzK1FCRGg4S0M4UmxlTTViYUJoMkFnbGp3SDA1OGtRQnk0?=
 =?utf-8?B?YytvL1FTdUJiSCsrYmx2N21xeTBSanZNb1cwd1BNTVFmQnpWZVdwQWFCSWgz?=
 =?utf-8?B?bGNEWWFUTnpaT3kxWXYzbGNFeCtoN3VhWTA1K1hWK2ZRSXZjRTAwWVpqeisx?=
 =?utf-8?B?N1NKU0JTUWk5VHNmOWNIK3VEUXNZV0xFZlQyVG9Qa29rSFB2U096cmFyQ05l?=
 =?utf-8?B?ejVEMEdnTmJqVEFnL3VqbURNVFdNSjJ2SVBOeWE5RWFVczc0N0tnVGpleVU1?=
 =?utf-8?B?VEtqWEt4KzNKekZ0K084TGd1RXg0bnV0eEtnOGdwN1J2QXhscXExUS9oN09F?=
 =?utf-8?B?NXJUbnhOUHQ1dHU2SFlNamVWbmk4QWVLRytsTUdacDJuR2FEeVFiMVJoamNq?=
 =?utf-8?B?SmFXVjg0N3UvdXl0VU9YSGVmUjdKUVhPY041dmh6QWdQS3loTytFWHV2bW9M?=
 =?utf-8?B?UUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C78DC4EA4C2EBE48B06307092E9BE3C6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef88fe5f-bc29-42d5-6c98-08dc429149e5
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2024 12:38:15.6731
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tBD8FQlhWyIIni8LSBa+0JwTsEJpHIujRF52CZezUfQIXfMkILkMmMiKV9iJFlevai/LY/D3pWjA4N2NCGDNUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6528
X-OriginatorOrg: intel.com

DQo+IA0KPiBXYWl0LiBLVk0gZG9lc24ndCAqbmVlZCogdG8gZG8gUEFHRS5BREQgZnJvbSBkZWVw
IGluIHRoZSBNTVUuICBUaGUgb25seSBpbnB1dHMgdG8NCj4gUEFHRS5BREQgYXJlIHRoZSBnZm4s
IHBmbiwgdGRyICh2bSksIGFuZCBzb3VyY2UuICBUaGUgUy1FUFQgc3RydWN0dXJlcyBuZWVkIHRv
IGJlDQo+IHByZS1idWlsdCwgYnV0IHdoZW4gdGhleSBhcmUgYnVpbHQgaXMgaXJyZWxldmFudCwg
c28gbG9uZyBhcyB0aGV5IGFyZSBpbiBwbGFjZQ0KPiBiZWZvcmUgUEFHRS5BREQuDQo+IA0KPiBD
cmF6eSBpZGVhLiAgRm9yIFREWCBTLUVQVCwgd2hhdCBpZiBLVk1fTUFQX01FTU9SWSBkb2VzIGFs
bCBvZiB0aGUgU0VQVC5BREQgc3R1ZmYsDQo+IHdoaWNoIGRvZXNuJ3QgYWZmZWN0IHRoZSBtZWFz
dXJlbWVudCwgYW5kIGV2ZW4gZmlsbHMgaW4gS1ZNJ3MgY29weSBvZiB0aGUgbGVhZiBFUFRFLCAN
Cj4gYnV0IHRkeF9zZXB0X3NldF9wcml2YXRlX3NwdGUoKSBkb2Vzbid0IGRvIGFueXRoaW5nIGlm
IHRoZSBURCBpc24ndCBmaW5hbGl6ZWQ/DQo+IA0KPiBUaGVuIEtWTSBwcm92aWRlcyBhIGRlZGlj
YXRlZCBURFggaW9jdGwoKSwgaS5lLiB3aGF0IGlzL3dhcyBLVk1fVERYX0lOSVRfTUVNX1JFR0lP
TiwNCj4gdG8gZG8gUEFHRS5BREQuICBLVk1fVERYX0lOSVRfTUVNX1JFR0lPTiB3b3VsZG4ndCBu
ZWVkIHRvIG1hcCBhbnl0aGluZywgaXQgd291bGQNCj4gc2ltcGx5IG5lZWQgdG8gdmVyaWZ5IHRo
YXQgdGhlIHBmbiBmcm9tIGd1ZXN0X21lbWZkKCkgaXMgdGhlIHNhbWUgYXMgd2hhdCdzIGluDQo+
IHRoZSBURFAgTU1VLg0KDQpPbmUgc21hbGwgcXVlc3Rpb246DQoNCldoYXQgaWYgdGhlIG1lbW9y
eSByZWdpb24gcGFzc2VkIHRvIEtWTV9URFhfSU5JVF9NRU1fUkVHSU9OIGhhc24ndCBiZWVuIHBy
ZS0NCnBvcHVsYXRlZD8gIElmIHdlIHdhbnQgdG8gbWFrZSBLVk1fVERYX0lOSVRfTUVNX1JFR0lP
TiB3b3JrIHdpdGggdGhlc2UgcmVnaW9ucywNCnRoZW4gd2Ugc3RpbGwgbmVlZCB0byBkbyB0aGUg
cmVhbCBtYXAuICBPciB3ZSBjYW4gbWFrZSBLVk1fVERYX0lOSVRfTUVNX1JFR0lPTg0KcmV0dXJu
IGVycm9yIHdoZW4gaXQgZmluZHMgdGhlIHJlZ2lvbiBoYXNuJ3QgYmVlbiBwcmUtcG9wdWxhdGVk
Pw0KDQo+IA0KPiBPciBpZiB3ZSB3YW50IHRvIG1ha2UgdGhpbmdzIG1vcmUgcm9idXN0IGZvciB1
c2Vyc3BhY2UsIHNldCBhIHNvZnR3YXJlLWF2YWlsYWJsZQ0KPiBmbGFnIGluIHRoZSBsZWFmIFRE
UCBNTVUgU1BURSB0byBpbmRpY2F0ZSB0aGF0IHRoZSBwYWdlIGlzIGF3YWl0aW5nIFBBR0UuQURE
Lg0KPiBUaGF0IHdheSB0ZHBfbW11X21hcF9oYW5kbGVfdGFyZ2V0X2xldmVsKCkgd291bGRuJ3Qg
dHJlYXQgYSBmYXVsdCBhcyBzcHVyaW91cw0KPiAoS1ZNIHdpbGwgc2VlIHRoZSBTUFRFIGFzIFBS
RVNFTlQsIGJ1dCB0aGUgUy1FUFQgZW50cnkgd2lsbCBiZSAhUFJFU0VOVCkuDQo+IA0KPiBUaGVu
IEtWTV9NQVBfTUVNT1JZIGRvZXNuJ3QgbmVlZCB0byBzdXBwb3J0IEBzb3VyY2UsIEtWTV9URFhf
SU5JVF9NRU1fUkVHSU9ODQo+IGRvZXNuJ3QgbmVlZCB0byBmYWtlIGEgcGFnZSBmYXVsdCBhbmQg
ZG9lc24ndCBuZWVkIHRvIHRlbXBvcmFyaWx5IHN0YXNoIHRoZQ0KPiBzb3VyY2VfcGEgaW4gS1ZN
LCBhbmQgS1ZNX01BUF9NRU1PUlkgY291bGQgYmUgdXNlZCB0byBmdWxseSBwcmUtbWFwIFREWCBt
ZW1vcnkuDQo+IA0KPiBJIGJlbGlldmUgdGhlIG9ubHkgbWlzc2luZyBwaWVjZSBpcyBhIHdheSBm
b3IgdGhlIFREWCBjb2RlIHRvIGNvbW11bmljYXRlIHRoYXQNCj4gaHVnZXBhZ2VzIGFyZSBkaXNh
bGxvd2VkLg0KPiANCg0K

