Return-Path: <kvm+bounces-14788-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D9A78A6F6A
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 17:12:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 296C51F222D8
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 15:12:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A45912FF9B;
	Tue, 16 Apr 2024 15:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HHalxJwg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DAB812FF99;
	Tue, 16 Apr 2024 15:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713280369; cv=fail; b=IMDMYadcS6YeOOXOr7/jW79tIdrwaTuqWuxMUMwKDuGR6gvrLprG9EADalVTPCXmn12Nx4iFGl3XlZShiUX9LjTdd++AmG6CwvJ8WdpDA5xCFSybO750+Hkl09bOyVpHPrULSnYMnBRVPEMaFT4zwuq0vVG9/vegboXWuM3CzvU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713280369; c=relaxed/simple;
	bh=PKhL04rP/bUKcS+hGQhuhtHooX3GoXZAivL8Lx2Z8so=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Z0C2EiL7qlS2igavztntfq1qGXPPVMiR+rs/GqFkVTaYdmCNKGLwN/jL7J5z/3Pmybpl8l1qjAUPwJDfCg2KmecTrV/SkUNQca5T2mKh/88q28q5Huy8u2hSQbRnSA3kUbZ1Mc1mzH5QbbxHaGOq9n+zMjhGDzV/jyj6oe3BQL8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HHalxJwg; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713280367; x=1744816367;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=PKhL04rP/bUKcS+hGQhuhtHooX3GoXZAivL8Lx2Z8so=;
  b=HHalxJwgN2+czWkoFBxIFp+vnLPrzBBgwsrYZaLPSIriyRrOSLRNLuxg
   RMYLy011JPFHwt/bQtEiqOWxYBVd9I58/uc1jDe+0qxtaWykuUNCOVNdb
   1MlIkbaSQmL1UN55umo9otuYfgdShwn0cHjI6V0ZD3wohzmFrMz88CLeB
   4xQOIxmGMA+Vp2PhdOkO3Mais4GGJYgs/v+Cqs7jUYjI/B8ynDqOHFczr
   zabduF/9oL5OGa2+R53JYzg15tDF+hsCfzggpHiMQKxvzhWkX9rR1AJEi
   hjvNqp9P8pYfTpY0JEfuKVoV8p6WvD4uRrm8Wz3s06vZEv1cAzBYWMtwq
   Q==;
X-CSE-ConnectionGUID: 0mQwOvLVRquTVyQ/jxNGbw==
X-CSE-MsgGUID: BSr3pZVtSH+QPKipapplSw==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="19433158"
X-IronPort-AV: E=Sophos;i="6.07,206,1708416000"; 
   d="scan'208";a="19433158"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 08:12:45 -0700
X-CSE-ConnectionGUID: JyyP2uqLRwWatmFbu1E0Lw==
X-CSE-MsgGUID: nYpoJzsmRfSjGIrqoT7Gww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,206,1708416000"; 
   d="scan'208";a="22356369"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Apr 2024 08:12:44 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Apr 2024 08:12:43 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 16 Apr 2024 08:12:43 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 16 Apr 2024 08:12:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l84MqYL6Ar/BS6inM9Awcnpz2+Aci7zBiyjUic/s5MNE0FEiVk/RxuCKmoTuEgnU4fLQ7H6A07C07CrJgI4Kv5k6nHHJmVXTSkRn3FOxIJSgL541VXAV/8lXyAmBu2jzSU6IsRy+KT0UdF3Vxnl72o7p+p1HdM0jBjszHZ8N8Qz9I0ojQghw6B+ucdLM/vteuzXtHbXferDI0MUSVzOLtT+AgJk4e7So4Kvm1Qoeb3H6zMUbXUH7HrSmUJkZdpqKn7ehsgOWfSfccIp94dk9LC2zCS42qmplFkvLWtk3JKo58xQIX8uAbrnOYs6Ru0M7qt/Fp9cRqWwOnoc9a9K8Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PKhL04rP/bUKcS+hGQhuhtHooX3GoXZAivL8Lx2Z8so=;
 b=NgI84yKK/nZMMIVqwEFrN14eEIHz22y7bJkKxl5CJc9QkeRacvFFGCd7KTJvcDmNnfKC/j1emQTmkIOA4RMjaYua01J6sZSvTN9rEb8QKmAcnDnLxkbHJue7SlI/EpJpny/PTp4aQgB/TYvQF4doiWCCX9e1V3TCLLsjGbjTvIfzbUuSr3WKbLl9TWhJ0q8MeJsEuRQ76IShL32wo8MqDWXU4krfWuX4xEKaNecqVer7w/PaMQDVT9zJGrUayQFGJpxxcCoGMHKsh7WOeuLubi4JrK6kA7z75KCPMqrALUFiOgm1k3hOJxDWaFNzw2lWhrGKdt1Ba1JLG1TAoHJ5GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH8PR11MB7989.namprd11.prod.outlook.com (2603:10b6:510:258::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.27; Tue, 16 Apr
 2024 15:12:34 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7472.027; Tue, 16 Apr 2024
 15:12:34 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "federico.parola@polito.it"
	<federico.parola@polito.it>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: Re: [PATCH v2 06/10] KVM: x86: Implement kvm_arch_vcpu_map_memory()
Thread-Topic: [PATCH v2 06/10] KVM: x86: Implement kvm_arch_vcpu_map_memory()
Thread-Index: AQHaj4x+tUvGbQVUbUCoXcGmCE+l/rFrAeqA
Date: Tue, 16 Apr 2024 15:12:34 +0000
Message-ID: <75b213fd73fcb5872703f89a9c6bb67ea91e3bd7.camel@intel.com>
References: <cover.1712785629.git.isaku.yamahata@intel.com>
	 <7138a3bc00ea8d3cbe0e59df15f8c22027005b59.1712785629.git.isaku.yamahata@intel.com>
In-Reply-To: <7138a3bc00ea8d3cbe0e59df15f8c22027005b59.1712785629.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH8PR11MB7989:EE_
x-ms-office365-filtering-correlation-id: 4abdfea7-829e-4ec6-c274-08dc5e27a4e9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2BjAkHW2miLU6Mh4plS5OtYwSoFdF/wM8YXh0KNgF2n98PV1Qzziec1RXZ9nl885Uzdo6WKo/oYWbbRrOnN1RYKdqiZaKOIBuPAFQrhF9Kz4MZaCTbyvP/UDD+imB0WCZ/0zbfjGZJkHWvqu1LQ1Z/ZIsXJl6Mov5+9tKcqQGKldpVN9+FJSVp/9YaZrKnT+68qfexNfCpBUUMIQw2pfNJManrLFQ1HhUfh4Ku0YVyOXNv3pkOGyUMvWZZJAx0xb1ik2n6T+vZeFNJjiWa3E5rO2mIb1dz4phY9rkHqD+geGc9JrHWYAjp5PcXti3Fw5nQV9WuOoaR75faCvEHl5gJCHM/2PCU5xHfC8w7m1xJ9M4J9u9GqBqA25dAsMT66znX+uXDwWz1c+gzKNegyAqdMZ+zu7YhoOoTZDkB/eTyzaZGKSOxxAW0Tfsl5vl9DsdD2akXZVL5BY2KU96UW+2VTev7W9wqQLqmI6wJsRZ5sA13TYyP1/cfLeL/JoSJjYxYzNYmy6GaX1J5I65iED44G2ygA7WZsVKXq6phKTkjWWNKdQqBf65vkMI6Cot5zxOHQ03v6Ek4SKWrbEeeTzQwYW/CTSj6D0nNo37QmxYuSN9zsek6pfd9w2kni76wAVSdjxSnuYML2cdAdim6axvclLobI7pDzpoNHHFfX2xLoLjR9k6L0siwAE9UVJBGMrlwAp9uYdFSNe8fqwCV6f+CQMO7TxV9BS/dNHtaZeqQ0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z0FhKzhuT1JtbjZuMlBZSzhzdjhubkVZa0x6QkxVZHU4MktoTG52dTdJajQw?=
 =?utf-8?B?YzR6MTBVUUN0NmNreG1qamhBS2l1V1IwQm9mbVRIRGhYL3lhb0JYUnpBRmpK?=
 =?utf-8?B?bHVFRDVBU2pidmpqSHIyY3NVOHovVXNpREc0OU1sL1dwVkFSUFhXS2xMK0dT?=
 =?utf-8?B?RXNwMUZXOFM4eDhHYjFvUXVrK3Vhc0FZOE9SUkZBMzVYV3lrdldoRDRsdTZZ?=
 =?utf-8?B?bDV5Z0ZBNURoS3VXbjcrWmowcHkvVis0QjdudEhweVp3ekhXVmQ3d1FrNS8w?=
 =?utf-8?B?c2dObmNTU0F1R1I0Mkk2aGI2L0RVSGQyUVdaRmhVMlVkaU1FZ3F0cjczZVhu?=
 =?utf-8?B?RVZSYTNuc2lNQ2FmZkF1U0lPS2JWR1ZmdW56RnFYUTlFcXQwRUpBcllTWjBt?=
 =?utf-8?B?TXhLdmtJeVVIMTlYWTV1cGEwTHppSE5zN01jSGloL1dLOG92anZGaU9yOHdj?=
 =?utf-8?B?N3FESXV3ZHc1Sjc0Y3FNYlI0Mmx2QVZ3Wnp6Tm9HZlh6YVIvNWFpYThTdndp?=
 =?utf-8?B?SzY2UmNJaEZDeVQ1ODFFUGtJN3lNZmQ0aDZUZ3R0ajVLV0s3OFVNWFRzaURu?=
 =?utf-8?B?R3RrTCtuR3VSV3pwMnRvOXp3TEdpZHZZQ3FwM1JWZUovSXEyMnJkNHd3TUJh?=
 =?utf-8?B?eVFHbHBUK3gxK2dEUXQvZUQvUG9OK1IrR1E0TkY5KzU1eEk2ME04RXVXUTlP?=
 =?utf-8?B?T2d2UCtxcmdHU0VSTnZKTGhmU3FzTDVGdE1PZTh5a2dCLzJUc2JOOUVIdFFO?=
 =?utf-8?B?RnBLZWcwNXk5M3hIZUtDNjRxeGsvTG9xYnljUG1DREdmMm56N3psNTNCbnFE?=
 =?utf-8?B?cmFVenN2NUE5QS9XdzZWbWsxajNRSktMM2lKbkNRc3luQ2owWi9BOHA3THNa?=
 =?utf-8?B?SjRGb0Z6TDkzWmxyNVZzalJBcmtLM2tETEIvMFViZEdXRUdYV3IvaXhhVmE1?=
 =?utf-8?B?OERRN0k2RlFTWG5yb2szR3k4VXR2LzNqMG1ZaXM3UDZTV2FxVk9MMmxjOGNF?=
 =?utf-8?B?dkRPUGNlWUJ6UXN3QUI0dWhJS2NEWVdtS1FTR285KzlvZ1BZMjZlNTA4M3Vs?=
 =?utf-8?B?WEZKOHpRdHZRVVJkbmd3amVPMUZmbGZZbld4a2JCdWV4aEd3elcvTmFKQWM4?=
 =?utf-8?B?QjdQUnk3dzlRU09jUW1zS3dRbHBSeXczQXRUdkorOHQ3NHo3azBEcytIVTBK?=
 =?utf-8?B?RWVMMGE2S0lFNmplb2YwUVo2R1pDakgzRkhmZUpGd28xcUtGdmpRL3FDOGlx?=
 =?utf-8?B?UHcvNU1FOFRUZWVNbFMyVWtIbUM3ZlE4bm5JbFVwRXQzT3lSL0VId3NwbW54?=
 =?utf-8?B?L2RrekFFc1dSeUxtSkw5aVMxMHhRK24raUlsejFiSXZwNmlBU2tPZHpTVk4z?=
 =?utf-8?B?Zys2SnBDZ3BqSzdIRkc3N01kMEwvY3BTUCtaaHJCMVl4ZTR1UE1QbUE0anhu?=
 =?utf-8?B?UktzYlJwZ0dRUlVHbjhCWHlkcG9xMUpIQjVHWnZPWjdCdE5mb2dBUEhFWkVH?=
 =?utf-8?B?ZmtVZXVPR0UwbVNQUDJGOUZlYmxoNEF1SlRBQTVhVTRQaVEvOGE1MmxoaWw0?=
 =?utf-8?B?R3pxRVl2a2JQZU1FZnZuZkFjb3oxb2lOMkh5cFdUZHdDdk5FUFpkOWxXZjRC?=
 =?utf-8?B?OER5L1BJQmxmRWFWY2UrWmtWMDMzbFg0UTNxK1JKTitPTDVqd1VuK0o2RTI0?=
 =?utf-8?B?THNESlN6ZEpNVDZuZjZFWFFGVFRZbDMrcmd1cFhuTmp3anpqQXJWUVppLzZj?=
 =?utf-8?B?TmtyeEVpVldqcDJneVA0K1JydjZMakkveTVUczVVWTdpM1JzNGs0d0hXTmZB?=
 =?utf-8?B?ZHNpNWhTRHp1U2l0VkxsVUhCR3FKMDdYYVJ5NnkvTmk4YmwzQTgyK2xiQ2tU?=
 =?utf-8?B?SDhKSGEvdkw4RWgxRTAwRlhhQVlaWENrK3NaeDJxbU5BQXRJVzlEa0JDTFBm?=
 =?utf-8?B?amxuaVpieXJPVDU1cE5hek5NblhJYVpid2FWN0ExSTExYytvZnhaejRRVlV1?=
 =?utf-8?B?dDR6QlliQ0phTmJ2c1dqa2gvUWhvUkpaSDVobDlxUTArSVVQaUg0VkRNUmIr?=
 =?utf-8?B?Rk9VRFI2RW1mVnZISmM0Z090K2txazlKSDdjZFd0eWxPdWFZeXlLREQ1enNw?=
 =?utf-8?B?ZGFMZ0N3dHRZaTJnUWJsUmt2SGRXdnZ0c0dYb1hMSmdVT2JyRWd5aDFjeGNs?=
 =?utf-8?Q?Y5VEeZ/jB8Cin6rCchOSbCo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FE94546FEDA1A24B82FCB2B906FCDB04@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4abdfea7-829e-4ec6-c274-08dc5e27a4e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2024 15:12:34.3244
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ub1Ni5FzaeY/coWdpuWpmIzp/5ceS6wBqmXGvxcjirwAD8wjP/NyC/aHKPk1q9ZNFFLhEfyNZblkJ1G0GWSuSExpVlaAH0JmVVWaeUL3Kkk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7989
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA0LTEwIGF0IDE1OjA3IC0wNzAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6Cj4gRnJvbTogSXNha3UgWWFtYWhhdGEgPGlzYWt1LnlhbWFoYXRhQGludGVsLmNv
bT4KPiAKPiBXaXJlIEtWTV9NQVBfTUVNT1JZIGlvY3RsIHRvIGt2bV9tbXVfbWFwX3RkcF9wYWdl
KCkgdG8gcG9wdWxhdGUgZ3Vlc3QKPiBtZW1vcnkuwqAgV2hlbiBLVk1fQ1JFQVRFX1ZDUFUgY3Jl
YXRlcyB2Q1BVLCBpdCBpbml0aWFsaXplcyB0aGUgeDg2Cj4gS1ZNIE1NVSBwYXJ0IGJ5IGt2bV9t
bXVfY3JlYXRlKCkgYW5kIGt2bV9pbml0X21tdSgpLsKgIHZDUFUgaXMgcmVhZHkgdG8KPiBpbnZv
a2UgdGhlIEtWTSBwYWdlIGZhdWx0IGhhbmRsZXIuCj4gCj4gU2lnbmVkLW9mZi1ieTogSXNha3Ug
WWFtYWhhdGEgPGlzYWt1LnlhbWFoYXRhQGludGVsLmNvbT4KPiAtLS0KPiB2MjoKPiAtIENhdGNo
IHVwIHRoZSBjaGFuZ2Ugb2Ygc3RydWN0IGt2bV9tZW1vcnlfbWFwcGluZy4gKFNlYW4pCj4gLSBS
ZW1vdmVkIG1hcHBpbmcgbGV2ZWwgY2hlY2suIFB1c2ggaXQgZG93biBpbnRvIHZlbmRvciBjb2Rl
LiAoRGF2aWQsIFNlYW4pCj4gLSBSZW5hbWUgZ29hbF9sZXZlbCB0byBsZXZlbC4gKFNlYW4pCj4g
LSBEcm9wIGt2bV9hcmNoX3ByZV92Y3B1X21hcF9tZW1vcnkoKSwgZGlyZWN0bHkgY2FsbCBrdm1f
bW11X3JlbG9hZCgpLgo+IMKgIChEYXZpZCwgU2VhbikKPiAtIEZpeGVkIHRoZSB1cGRhdGUgb2Yg
bWFwcGluZy4KPiAtLS0KPiDCoGFyY2gveDg2L2t2bS94ODYuYyB8IDMwICsrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKwo+IMKgMSBmaWxlIGNoYW5nZWQsIDMwIGluc2VydGlvbnMoKykKPiAK
PiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3g4Ni5jIGIvYXJjaC94ODYva3ZtL3g4Ni5jCj4g
aW5kZXggMmQyNjE5ZDNlZWU0Li4yYzc2NWRlMzUzMWUgMTAwNjQ0Cj4gLS0tIGEvYXJjaC94ODYv
a3ZtL3g4Ni5jCj4gKysrIGIvYXJjaC94ODYva3ZtL3g4Ni5jCj4gQEAgLTQ3MTMsNiArNDcxMyw3
IEBAIGludCBrdm1fdm1faW9jdGxfY2hlY2tfZXh0ZW5zaW9uKHN0cnVjdCBrdm0gKmt2bSwgbG9u
Zwo+IGV4dCkKPiDCoMKgwqDCoMKgwqDCoMKgY2FzZSBLVk1fQ0FQX1ZNX0RJU0FCTEVfTlhfSFVH
RV9QQUdFUzoKPiDCoMKgwqDCoMKgwqDCoMKgY2FzZSBLVk1fQ0FQX0lSUUZEX1JFU0FNUExFOgo+
IMKgwqDCoMKgwqDCoMKgwqBjYXNlIEtWTV9DQVBfTUVNT1JZX0ZBVUxUX0lORk86Cj4gK8KgwqDC
oMKgwqDCoMKgY2FzZSBLVk1fQ0FQX01BUF9NRU1PUlk6Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqByID0gMTsKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGJyZWFr
OwoKU2hvdWxkIHdlIGFkZCB0aGlzIGFmdGVyIGFsbCBvZiB0aGUgcGllY2VzIGFyZSBpbiBwbGFj
ZT8KCj4gwqDCoMKgwqDCoMKgwqDCoGNhc2UgS1ZNX0NBUF9FWElUX0hZUEVSQ0FMTDoKPiBAQCAt
NTg2Nyw2ICs1ODY4LDM1IEBAIHN0YXRpYyBpbnQga3ZtX3ZjcHVfaW9jdGxfZW5hYmxlX2NhcChz
dHJ1Y3Qga3ZtX3ZjcHUKPiAqdmNwdSwKPiDCoMKgwqDCoMKgwqDCoMKgfQo+IMKgfQo+IMKgCj4g
K2ludCBrdm1fYXJjaF92Y3B1X21hcF9tZW1vcnkoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LAo+ICvC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgc3Ry
dWN0IGt2bV9tZW1vcnlfbWFwcGluZyAqbWFwcGluZykKPiArewo+ICvCoMKgwqDCoMKgwqDCoHU2
NCBlbmQsIGVycm9yX2NvZGUgPSAwOwo+ICvCoMKgwqDCoMKgwqDCoHU4IGxldmVsID0gUEdfTEVW
RUxfNEs7Cj4gK8KgwqDCoMKgwqDCoMKgaW50IHI7Cj4gKwo+ICvCoMKgwqDCoMKgwqDCoC8qCj4g
K8KgwqDCoMKgwqDCoMKgICogU2hhZG93IHBhZ2luZyB1c2VzIEdWQSBmb3Iga3ZtIHBhZ2UgZmF1
bHQuwqAgVGhlIGZpcnN0Cj4gaW1wbGVtZW50YXRpb24KPiArwqDCoMKgwqDCoMKgwqAgKiBzdXBw
b3J0cyBHUEEgb25seSB0byBhdm9pZCBjb25mdXNpb24uCj4gK8KgwqDCoMKgwqDCoMKgICovCj4g
K8KgwqDCoMKgwqDCoMKgaWYgKCF0ZHBfZW5hYmxlZCkKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgcmV0dXJuIC1FT1BOT1RTVVBQOwoKSXQncyBub3QgY29uZnVzaW9uLCBpdCdzIHRo
YXQgeW91IGNhbid0IHByZS1tYXAgR1BBcyBmb3IgbGVnYWN5IHNoYWRvdyBwYWdpbmcuCk9yIHlv
dSBhcmUgc2F5aW5nIHdoeSBub3QgdG8gc3VwcG9ydCBwcmUtbWFwcGluZyBHVkFzPyBJIHRoaW5r
IHRoYXQgZGlzY3Vzc2lvbgpiZWxvbmdzIG1vcmUgaW4gdGhlIGNvbW1pdCBsb2cuIFRoZSBjb2Rl
IHNob3VsZCBqdXN0IHNheSBpdCdzIG5vdCBwb3NzaWJsZSB0bwpwcmUtbWFwIEdQQXMgaW4gc2hh
ZG93IHBhZ2luZy4KCj4gKwo+ICvCoMKgwqDCoMKgwqDCoC8qIHJlbG9hZCBpcyBvcHRpbWl6ZWQg
Zm9yIHJlcGVhdGVkIGNhbGwuICovCj4gK8KgwqDCoMKgwqDCoMKga3ZtX21tdV9yZWxvYWQodmNw
dSk7Cj4gKwo+ICvCoMKgwqDCoMKgwqDCoHIgPSBrdm1fdGRwX21hcF9wYWdlKHZjcHUsIG1hcHBp
bmctPmJhc2VfYWRkcmVzcywgZXJyb3JfY29kZSwgJmxldmVsKTsKPiArwqDCoMKgwqDCoMKgwqBp
ZiAocikKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIHI7Cj4gKwo+ICvC
oMKgwqDCoMKgwqDCoC8qIG1hcHBpbmctPmJhc2VfYWRkcmVzcyBpcyBub3QgbmVjZXNzYXJpbHkg
YWxpZ25lZCB0byBsZXZlbC1odWdlcGFnZS4KPiAqLwo+ICvCoMKgwqDCoMKgwqDCoGVuZCA9ICht
YXBwaW5nLT5iYXNlX2FkZHJlc3MgJiBLVk1fSFBBR0VfTUFTSyhsZXZlbCkpICsKPiArwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgS1ZNX0hQQUdFX1NJWkUobGV2ZWwpOwo+ICvCoMKgwqDC
oMKgwqDCoG1hcHBpbmctPnNpemUgLT0gZW5kIC0gbWFwcGluZy0+YmFzZV9hZGRyZXNzOwo+ICvC
oMKgwqDCoMKgwqDCoG1hcHBpbmctPmJhc2VfYWRkcmVzcyA9IGVuZDsKPiArwqDCoMKgwqDCoMKg
wqByZXR1cm4gcjsKPiArfQo+ICsKPiDCoGxvbmcga3ZtX2FyY2hfdmNwdV9pb2N0bChzdHJ1Y3Qg
ZmlsZSAqZmlscCwKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgdW5zaWduZWQgaW50IGlvY3RsLCB1bnNpZ25lZCBsb25nIGFyZykKPiDCoHsKCg==

