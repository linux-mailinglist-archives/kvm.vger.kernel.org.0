Return-Path: <kvm+bounces-11840-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DD04B87C4E0
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 22:53:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4D34F1F2202E
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 21:53:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75795768F4;
	Thu, 14 Mar 2024 21:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JtCnrK6U"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E76C76037;
	Thu, 14 Mar 2024 21:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710453186; cv=fail; b=fMRmaSyzrn6/2YFdKZZnViF3XGT0UqvJxrPYafa9qdLoy4gJ2bB4N0ibFCMAbomtlhR5ulGaIJ5K3oV2uiEYiYaoup1/RaXFRdOOItRI+G9rxSVR8uhp4rlWpU7GqsOBBoaB2VhSmFGVh8EQnXT7IiE8q5cMEZ6jFYUoXBXRP1o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710453186; c=relaxed/simple;
	bh=FNUhtBzXwvhDjSj24Cm+C0I7X/o6SdtUt1K62Za86ak=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AJAYWTPtWMkwenFt6ooUPTGi36oeYIh2GFw9l9JNVsdAeLmJjD61xyQPb4H1C8lyEYXv9680+y26q0llrTSVtf3Mh7WLL/xXsF8QQ67ulpR9xc0jIfPhjxqRyjvwgy8QLJTO26zmMVwQdQKUsgDGUrUo3EGYv+67+yy9ff+KZLI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JtCnrK6U; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710453185; x=1741989185;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=FNUhtBzXwvhDjSj24Cm+C0I7X/o6SdtUt1K62Za86ak=;
  b=JtCnrK6UIHLsHY0xm8vqY/BxJUi5LL5LG4OAsJspj5D1TW3pNbrXNQLi
   EHWOY8bLyI8pYwMWyJJ7+lvYomFL7FHVGAuiNX3UiJ4PJhBVH252fVwo0
   zCEeje5vXANs6/Apw37M8LL//gHhlC2anAAWTZDImVi4bEaV7xoeb4VTX
   iX6a/DOMfuGg5S1Xd6+yjbKJqM8U/4LEKKPr6Ln9YcnAQDW6SIJZfx0uQ
   hZu0fM8HAfFkOOerwh93s26cS6ViKf27ogxJyY9+2GQtUVJGk3fz1DZKd
   PVqhcJFPwZSs/4VwFzwnapY9wqL4TJtiw6X6vZ8LzJDvLFhLurlorGaMf
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11013"; a="9085164"
X-IronPort-AV: E=Sophos;i="6.07,126,1708416000"; 
   d="scan'208";a="9085164"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2024 14:53:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,126,1708416000"; 
   d="scan'208";a="43348644"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Mar 2024 14:53:04 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 14 Mar 2024 14:53:03 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 14 Mar 2024 14:53:02 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 14 Mar 2024 14:53:02 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 14 Mar 2024 14:53:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RtbMCYbpDSlBlvnt/Ey+frt0G5GILI+Ij5AoHCC6bzUA/nPAbZ2BKH7qObEjgrUbuOkqG+GGOf0gEzIYcEJrv1Ut45rh0XzPXCfS0altSrxLQAbQeAmHKBnyZXljX0+n/j5zTr2210c1QdZXs/ghVa/qbHvLjzZmVJFiVeXvnOB2dZSwYSUfTGt23JbYZZFqfCkBpVV5sT49p11lvB1eUPiuTDHDnCUylg1ifhqTkGOe/mchADZgHyM0vHrnWBKNpVTFnmfqVy+2YBtBTQzDk04P3MrnrY2x9/FnWcb2hjo53kGTTbsx9gFk7jSFRDzh8Uwjrx5BBFVWDCFvMfiR6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FNUhtBzXwvhDjSj24Cm+C0I7X/o6SdtUt1K62Za86ak=;
 b=dincaWWwWPnNQ0z8WisJlAPR+oLACxCgsCyS0qhCSKOMtAvzVBoS0gzZycIO2smF3hpZICbjRRAk/fUnL46ZWXsQ4WEUn1QPg/L6KwWiuJKqxAJJGZohTbmorG6m6xsmZ+MkAFnQmHNWFHjab/krzdMycdWvYNZ+j1Li2wVRHuurDJ9kP/xCMbti/a7JR8UAGgntiRt3NtVeqWzWe2C2saL9kGldaE6Vrf7xqOmRD6aTGlMtZGefudV/7H1TJAeqAYphB9/5842+6SDLSru198l1SetDU3oE6SsOOn/0RnX43gDFKAjHEVip2YSfveQYyZaaC2MwzugWIyHYCn7GLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV2PR11MB5976.namprd11.prod.outlook.com (2603:10b6:408:17c::13)
 by MW4PR11MB6984.namprd11.prod.outlook.com (2603:10b6:303:22e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.17; Thu, 14 Mar
 2024 21:52:58 +0000
Received: from LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::4f6f:538b:6c36:92f6]) by LV2PR11MB5976.namprd11.prod.outlook.com
 ([fe80::4f6f:538b:6c36:92f6%7]) with mapi id 15.20.7386.017; Thu, 14 Mar 2024
 21:52:58 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Yuan, Hang" <hang.yuan@intel.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>
Subject: Re: [PATCH v19 058/130] KVM: x86/mmu: Add a private pointer to struct
 kvm_mmu_page
Thread-Topic: [PATCH v19 058/130] KVM: x86/mmu: Add a private pointer to
 struct kvm_mmu_page
Thread-Index: AQHadYhHvzdNxEnyc0eILiymig0CabE3ipcAgAA+S4A=
Date: Thu, 14 Mar 2024 21:52:58 +0000
Message-ID: <b0e82a9c262ba335cc27bc9921b8f86bb0a6676f.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <9d86b5a2787d20ffb5a58f86e43601a660521f16.1708933498.git.isaku.yamahata@intel.com>
	 <50dc7be78be29bbf412e1d6a330d97b29adadb76.camel@intel.com>
	 <20240314181000.GC1258280@ls.amr.corp.intel.com>
In-Reply-To: <20240314181000.GC1258280@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV2PR11MB5976:EE_|MW4PR11MB6984:EE_
x-ms-office365-filtering-correlation-id: 8b485805-5b85-4c87-7f27-08dc44711cf7
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QyhbAHTMUuwUCxhJyQlkGuED2HHWmrPmbpYpF2tohZ0z1riOUh3Lu6EpR+YiFLdBW0GyqOI7GJDg7VCqIUoqAkhf9gQv6rFzoQ647U2P58ZobwQuEwvXQwUsdLsRqbkSf8X2MMMEfhnfmbVF3aaJHdbGaH1wtIPRVx27dI1mYp4MFMiTPlN1UraEukCjVfFpqpLKHXzgmg6Z1DxQtPeEXEGwLvrv/ozdAsHKChPWvqoaXITHbEkPZ150ZfhvF3pM42XIVMdiOsxMBc+tPttuQmb2EQtLe2OleJBYut71ldOw1LM7MjAT7FNZLSrnrLl0qMJs3m6D5k2DO5sGWMQgY5SlqauHXbIUygDGIrI0VZGCFy69d1xzptRxGCU54XvnpnkITRG/KaA/fYi9bPyXlXK0yN0lTrbrrVT9Xc+ChAelhGmNgRnRuSHg0BrZIgXPbS77gzus6dZ9EXBujxgPFWF5gYxbi6wV9cXEzaANEbTKd+3w1+yocNWoMbgpbg+sVBrvl1Mm+tyRmu+sk/uRQew+bHv37C/ShbsuRMRrTRhNIm0qVgm8pZIxjbM+zbtErsKV810YHpHkBke6qtA50W8QOX9HBne3xq9+WsQgFa5+AVs/mqbwyp9NStzVDjVjvVNTw2p/UrXx2irMoCEcTQO0dT5hxEkAMz4xwCcyDmcRn422/sepnYBiFk/VHYhDlVC/LwlW0Oej9/t7hUM8+7Iu5zZHn7G3ycLfB1kiO4o=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR11MB5976.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MThCcGlaWUVnU0R5U3AwaVJwZkUrQXNWK3pNclN1ZTYxeHhJZExsbjlibmFx?=
 =?utf-8?B?Ump1VTlpazFHQU5UUnRxY3dUWEloM2p6ejZlSmtpeGtGUzl2NmRGOW5CL1gw?=
 =?utf-8?B?T0J0Uml2bms5VjhLalpyWFQyUjAxZ0RXSVlLdUxQZUt4VnB5VVQyOU00cXdQ?=
 =?utf-8?B?WHI0WU9zVnRwS0xWZ1FhRVg2UFZXeEJWRnROWGg4VVk5bVRhckg2T0h4QmRU?=
 =?utf-8?B?cXBaMkYxSVNPR3N1MXpHMU4rV2ZpbFRsR1VrTEpNV0hBZWlaZ1N4bXZFYm5T?=
 =?utf-8?B?NGt2T3FFblcvZFltMXA1TmdRWDJ6TVRHNTVTUHAyWU1EcGQzdXZCZ0F1T25Q?=
 =?utf-8?B?NytuNUFwRnNoK2prZk5GUWpDd0NJMmt5R1lsV3JqSFhCNHYxcjhiZWpmNmJk?=
 =?utf-8?B?VlFDSjBiZ1k5STVvZGhvZW0vbmJKQzNuclVEbzdFU1c4UENVMC93T2dIV0VJ?=
 =?utf-8?B?K2txLzZNOFNPbmd4TGRnM0I0bEREZk9qdVUyejdhS1ZuRm5rUHZFVzRkKzBS?=
 =?utf-8?B?MUo1Rm1iTHVCNzdXNlE5bEx6T1AwL1lJQ3IrZDEyMDU0a3hwVkZoQUQwc05v?=
 =?utf-8?B?Y3FxeTM0QXRCcXBuK3JRNjN4dnd2WjJZTlFpQkJuMXEzWWhFZ2ZJMWs1TnZO?=
 =?utf-8?B?RnFzdkhWNVhOQXQ0OEV1cE5PakRJcnBPcnpBcVpxNEszbURVMEd6cC9VTlU4?=
 =?utf-8?B?WUp4Vi9iRHY4OUgzbU5xMXFzOC9Nb1VqRjl4YVpNdkhha1ZvckE3THF3Rndy?=
 =?utf-8?B?UlhqcGV5ZWJLWGFVVmN0SnhSVXN0d2FSdjRPYk1BRlpzU0ZhRm1ScU5MVFZ1?=
 =?utf-8?B?cHAyU1VaTEtVSmFPUkE5alFWMVdGOVlkckVQaUE0Y3BWVW1JOFhjR05mcnFR?=
 =?utf-8?B?RDRXN1pyZEFKbHMvSThhZnhOY2tWbjBkeEtIZlBFem9zYXNLZE1hUmwrM3M4?=
 =?utf-8?B?RnFsUUNSNGpCeURSdHoxNW5zdjFuM1pnMTdKV0lRNnFlejR0c3BVcHhJUk9q?=
 =?utf-8?B?OXJyMmZPM0xTUWsxR1ZDeTVuU1hBdnJxNEdXVkUyRktkY0IvckFVbE9VdnZh?=
 =?utf-8?B?TGszZ2tZTjFzTndPNFUzRHBuU1A3S09QZGN5MnhXeVUxbUlRc2UxY1VFMWtv?=
 =?utf-8?B?MVE3ZlZRd2hoVE85bC8rMzMzRVdjbjBDaWZXcTZBY3BmNk9IbVJETUJ1Y3lE?=
 =?utf-8?B?YVROby9QdUZSUDR2cE9ySDRWYW9WMEpLYTN2VjdxVjFoMml6bmx0QzczbFlZ?=
 =?utf-8?B?M2t2QTh1RUNpU29Wb0JVYmlnZ2h0ODZkcWtxV3EvbTdPWDAweG9zb0pwTy9U?=
 =?utf-8?B?TlBDSlFJVkVaeEkzcHNWRnp3TXR2eGNvd1ZRaVB0d1pKZkVEUmFoZHhXVlow?=
 =?utf-8?B?TXVCRUtSL1JmM2hBTWZCL1B3c2VkVmRha1h1V2FPNlVsVjRMM2RGQ3JLZ1J2?=
 =?utf-8?B?Q0s4T2ZQczRBdENERDhPTThNVHlTWVcxV3Rrd3VqVHppM2ZNekF0SGtZVDVm?=
 =?utf-8?B?T0FVaGNIdURHL1FtbUQ0aGpJeHUrUmxyR2ozbWQwL0VoRWwzTlFvWm5IZVhh?=
 =?utf-8?B?TzRPcHFXd2o0anZmYytNTHFnYjVQa3FtNFl6dHl6TTc2RHNDM1hvSUYxUFdO?=
 =?utf-8?B?NTIrWGQxSnlKSFEzdVFmbmh4MjcvRWE2aXR6OS9VVVlMejV4aER4N1FQQk9o?=
 =?utf-8?B?VVJHZ1lhODVrNWduc01waWNUY0pjMnBTQTR2K3hVaVFUOFdPcUVuUllNNlB2?=
 =?utf-8?B?ZFhISnl3Njc1bU5uNGR5WE1EWXRLblBreEY1NTZFUXJxenZmVklNNW1mRnI4?=
 =?utf-8?B?dzNkZ2ZlUVpxSmFjNDNTRDBOUDdXTnhZcTFWQXQ0UHcyWFYzK3hhRk1MZzhn?=
 =?utf-8?B?czhHeVlVTlM0Yk1idWczRkZzK05JZGhFZFVEQ0VOam1qY0JYVk5ZNndVZHZi?=
 =?utf-8?B?OW44RmkxOUp1bHYxc01FZmNMOGxmbzdiQkVzQVYzZ0VkdjE3SHUyeFJzVFVL?=
 =?utf-8?B?akFRd1B2MFZaMUpsR0MzaWhmV3dyUUQxZ0tHUGttaVBhd3oxamNKMmZ3Rk8z?=
 =?utf-8?B?VFlnTjREcE5FSTRINTBuTTBFQ3NwU21VbE1nMnFRelgvcHZPVGluc01hcFNl?=
 =?utf-8?B?SUlMVmRqTzQ5Q2pLTlVta2tqMjVEL1lOREtIN3h4ellpRkZUMTNQd1RnMFVN?=
 =?utf-8?Q?4i6CfT3sAes0nst/DSBsgnQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CE3015DA96AEAF4C8FFF4032BBBC8CB9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV2PR11MB5976.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b485805-5b85-4c87-7f27-08dc44711cf7
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Mar 2024 21:52:58.7201
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: a04Zmn1sY3n5Vo3vp9jOuq8mMt/zsg+M2HuiOyT6SRiXhjVEUBuv8/fZK0SzITHHGTiiYnlo+MxsFXIWOa81k/0i9ZaxXuIEAMBy5OKzsUI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6984
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTAzLTE0IGF0IDExOjEwIC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gPiBJIHRoaW5rIHRoZSBwb2ludCBvZiBwdXR0aW5nIHRoZXNlIGluIGEgdW5pb24gaXMgdGhh
dCB0aGV5IG9ubHkNCj4gPiBhcHBseQ0KPiA+IHRvIHNoYWRvdyBwYWdpbmcgYW5kIHNvIGNhbid0
IGJlIHVzZWQgd2l0aCBURFguIEkgdGhpbmsgeW91IGFyZQ0KPiA+IHB1dHRpbmcNCj4gPiBtb3Jl
IHRoYW4gdGhlIHNpemVvZih2b2lkICopIGluIHRoZXJlIGFzIHRoZXJlIGFyZSBtdWx0aXBsZSBp
biB0aGUNCj4gPiBzYW1lDQo+ID4gY2F0ZWdvcnkuDQo+IA0KPiBJJ20gbm90IHN1cmUgaWYgSSdt
IGZvbGxvd2luZyB5b3UuDQo+IE9uIHg4Nl82NCwgc2l6ZW9mKHVuc2lnbmVkIGludCkgPSA0LCBz
aXplb2YoYXRvbWljX3QpID0gNCwNCj4gc2l6ZW9mKHZvaWQgKikgPSA4Lg0KPiBJIG1vdmVkIHdy
aXRlX2Zsb29kaW5nX2NvdW50IHRvIGhhdmUgOCBieXRlcy4NCg0KQWgsIEkgc2VlLiBZZXMgeW91
IGFyZSB3cml0ZSBhYm91dCBpdCBzdW1taW5nIHRvIDguIE9rLCB3aGF0IGRvIHlvdQ0KdGhpbmsg
YWJvdXQgcHV0dGluZyBhIGNvbW1lbnQgdGhhdCB0aGVzZSB3aWxsIGFsd2F5cyBiZSB1bnVzZWQg
d2l0aA0KVERYPw0KDQo+IA0KPiANCj4gPiBCdXQgdGhlcmUgc2VlbXMgdG8gYmUgYSBuZXcgb25l
IGFkZGVkLCAqc2hhZG93ZWRfdHJhbnNsYXRpb24uDQo+ID4gU2hvdWxkIGl0IGdvIGluIHRoZXJl
IHRvbz8gSXMgdGhlIHVuaW9uIGJlY2F1c2UgdGhlcmUgd2Fzbid0IHJvb20NCj4gPiBiZWZvcmUs
IG9yIGp1c3QgdG8gYmUgdGlkeT8NCj4gDQo+IE9yaWdpbmFsbHkgVERYIE1NVSBzdXBwb3J0IHdh
cyBpbXBsZW1lbnRlZCBmb3IgbGVnYWN5IHRkcCBtbXUuwqAgSXQNCj4gdXNlZA0KPiBzaGFkb3dl
ZF90cmFuc2xhdGlvbi7CoCBJdCB3YXMgbm90IGFuIG9wdGlvbiBhdCB0aGF0IHRpbWUuwqAgTGF0
ZXIgd2UNCj4gc3dpdGNoZWQgdG8NCj4gKG5ldykgVERQIE1NVS7CoCBOb3cgd2UgaGF2ZSBjaG9p
Y2UgdG8gd2hpY2ggbWVtYmVyIHRvIG92ZXJsYXkuDQo+IA0KPiANCj4gPiBJIHRoaW5rIHRoZSBj
b21taXQgbG9nIHNob3VsZCBoYXZlIG1vcmUgZGlzY3Vzc2lvbiBvZiB0aGlzIHVuaW9uDQo+ID4g
YW5kDQo+ID4gbWF5YmUgYSBjb21tZW50IGluIHRoZSBzdHJ1Y3QgdG8gZXhwbGFpbiB0aGUgcHVy
cG9zZSBvZiB0aGUNCj4gPiBvcmdhbml6YXRpb24uIENhbiB5b3UgZXhwbGFpbiB0aGUgcmVhc29u
aW5nIG5vdyBmb3IgdGhlIHNha2Ugb2YNCj4gPiBkaXNjdXNzaW9uPw0KPiANCj4gU3VyZS7CoCBX
ZSdkIGxpa2UgdG8gYWRkIHZvaWQgKiBwb2ludGVyIHRvIHN0cnVjdCBrdm1fbW11X3BhZ2UuwqAg
R2l2ZW4NCj4gc29tZQ0KPiBtZW1iZXJzIGFyZSB1c2VkIG9ubHkgZm9yIGxlZ2FjeSBLVk0gTU1V
cyBhbmQgbm90IHVzZWQgZm9yIFREUCBNTVUsDQo+IHdlIGNhbiBzYXZlDQo+IG1lbW9yeSBvdmVy
aGVhZCB3aXRoIHVuaW9uLsKgIFdlIGhhdmUgb3B0aW9ucy4NCj4gLSB1NjQgKnNoYWRvd2VkX3Ry
YW5zbGF0aW9uDQo+IMKgIFRoaXMgd2FzIG5vdCBjaG9zZW4gZm9yIHRoZSBvbGQgaW1wbGVtZW50
YXRpb24uIE5vdyB0aGlzIGlzIG9wdGlvbi4NCg0KVGhpcyBzZWVtcyBhIGxpdHRsZSBtb3JlIHN0
cmFpZ2hmb3J3YXJkLCBidXQgSSdtIG9uIHRoZSBmZW5jZSBpZiBpdCdzDQp3b3J0aCBjaGFuZ2lu
Zy4NCg0KPiAtIHBhY2sgdW5zeW5jX2NoaWxkcmVuIGFuZCB3cml0ZV9mbG9vZGluZ19jb3VudCBm
b3IgOCBieXRlcw0KPiDCoCBUaGlzIHBhdGNoIGNob3NlbiB0aGlzIGZvciBoaXN0b3JpY2FsIHJl
YXNvbi4gT3RoZXIgdHdvIG9wdGlvbiBpcw0KPiBwb3NzaWJsZS4NCj4gLSB1bnN5bmNfY2hpbGRf
Yml0bWFwDQo+IMKgIEhpc3RvcmljYWxseSBpdCB3YXMgdW5pb25lZCB3aXRoIG90aGVyIG1lbWJl
cnMuIEJ1dCBub3cgaXQncyBub3QuDQo+IA0KPiBJIGRvbid0IGhhdmUgc3Ryb25nIHByZWZlcmVu
Y2UgZm9yIFREWCBzdXBwb3J0IGFzIGxvbmcgYXMgd2UgY2FuIGhhdmUNCj4gdm9pZCAqLg0KDQo=

