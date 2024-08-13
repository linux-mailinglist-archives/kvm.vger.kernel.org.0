Return-Path: <kvm+bounces-23938-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3683A94FD2E
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 07:26:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D6F43283D9C
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 05:26:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB387249F9;
	Tue, 13 Aug 2024 05:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g0bfgZ1O"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90FCB23B0;
	Tue, 13 Aug 2024 05:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723526772; cv=fail; b=Y68nB1esoLm2fUo5kS+6mrJEJ2yJHr5QOxh0El7sbE1u3UghQVcba6/nowI7OicAHzDitvauGnLPcjvWXy8o5cI4pwwI2y0et7gi+g7rfKSXsbOQqv2PxTXdoDOARQbwm1LIEl2+KfJeupwmfIqY4rzRIe7ZlQIl2ij/ji4+EDw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723526772; c=relaxed/simple;
	bh=uwCSdIJtMmrhPAZfR+t2Ad4rGEutGcLhBTHdGJfSWpc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=l+YzsI4vJ8RtRPl4rChAKnWUC0WhGT5IDwW1eszQOr7GuUhLDu6aP4DHQZv9HxgVlDH2DAhvsUu4lZek0H8qt5FC7vSSBJRnPAQPUf/S/5yD4pAJQNNLXCA7G1yj4/WmdGevkYAXrs6Z/ryz3uD9wBYCt5KZSfi4GVU2R/penPo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g0bfgZ1O; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723526771; x=1755062771;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=uwCSdIJtMmrhPAZfR+t2Ad4rGEutGcLhBTHdGJfSWpc=;
  b=g0bfgZ1O++SdBp9W+JF+jlEF7SFQmUO3K+dZLsH8KuM2YV+JqHyC08k1
   l4Kyn508IDu2VAUZpkWrb3A3BwuAhCootr23D3iIFYpXvwhh0efzNdmuv
   249+3fJtHFV1718atc6aMP6Ayi2I0GvmQZXKDyIzqvYe2tMwq+gkEBgbJ
   7QxyXVyN8AfUJezpeejzJeKy9udBdCtQy8jMfrucb4Y3OUT7W0FBPhWpk
   fuPSkIo2TAPVoPrPZGaniYGTSJ3emAzzofEoEcevtZcMlTZwrl7HWqltg
   WvVifpszu2HxEZaJA2F45U1ztyONm+nklxo/MDBy7HWcNToohQkb5pHsY
   A==;
X-CSE-ConnectionGUID: OvvvT1hESrO1aOQsMTbebg==
X-CSE-MsgGUID: iVE4+biiT6+qPjdRvwNIGQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11162"; a="32286832"
X-IronPort-AV: E=Sophos;i="6.09,285,1716274800"; 
   d="scan'208";a="32286832"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 22:26:10 -0700
X-CSE-ConnectionGUID: kWx6PQAQTmKcDUCZ60arHw==
X-CSE-MsgGUID: ruLAqW0JS+Oap/OHibUYfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,285,1716274800"; 
   d="scan'208";a="81773982"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Aug 2024 22:26:10 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 12 Aug 2024 22:26:09 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 12 Aug 2024 22:26:09 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 12 Aug 2024 22:26:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NEjUu00P09qnpFF5imL87b2kIAut122Y6ls91Un5NkadkgHwLWD8SJhE29LQqA8ek7ANkQ9MpNMYg2i8qACmA1Qs/xeCyv5BZHvgFCDnoE4Y801/jTu52Dwhd4NMNn0qoDVm9WNv/JXaTFY07tgSBlrpKs2Qzv+/MOxFWD/U4+K9o3atYf8K5HwscCFncu9Je6w/h2bO0l5FRCHx8n6FGELwkEu9+sSBW/75VuFODaBSaG8HeQCKf/qHOcV14O78LPeyMwm75dhA4IDPQuUOaUknMwWP7RchGUA8RbQ32/PnR5dN/l/tIoUGHb1OH+Ooi/QrWp3SarHO47eQjjUo1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uwCSdIJtMmrhPAZfR+t2Ad4rGEutGcLhBTHdGJfSWpc=;
 b=QBvZvuwQtz7p08jFVJ8/3fEeRl5XKkmxgV1HQuHqmE/5UGoXbYSySqkeUXNGG8rTQBz08eYPxNYPkCL0Sw6H9okqRAEoCKGqG5S74kAAztk+v7dxH6D9XbYHzBO5v5R6sRRv0PMUgy56p9yVBauOQcUESk9taJdswud9BAw17GsRR9KBMa8leY8yZAyjgHU8R6n4ZxfY0jflulSBPDz7l0OaSphtFcoZi15Kp1imPojAzmFMFVFmTwi7R0Ea1guUdNtywDZlli6/cEqPx0FUGXKBheJUBfT2ZU3sYzT9+2tXy1Us8DV1Ja6lkfWtKdKJTmobljj+Zf0yyPmrLi5Eug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DS0PR11MB7801.namprd11.prod.outlook.com (2603:10b6:8:f2::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7828.30; Tue, 13 Aug
 2024 05:26:06 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7828.030; Tue, 13 Aug 2024
 05:26:06 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Gao, Chao" <chao.gao@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>
CC: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"seanjc@google.com" <seanjc@google.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>
Subject: Re: [PATCH 10/25] KVM: TDX: Initialize KVM supported capabilities
 when module setup
Thread-Topic: [PATCH 10/25] KVM: TDX: Initialize KVM supported capabilities
 when module setup
Thread-Index: AQHa7QnMSgyYeLEjX0apeMt0uuv4r7IkhtqAgAAhpwA=
Date: Tue, 13 Aug 2024 05:26:06 +0000
Message-ID: <185d2a6c0317fe74fdb449df62dbafcb922a74f3.camel@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
	 <20240812224820.34826-11-rick.p.edgecombe@intel.com>
	 <ZrrSMaAxyqMBcp8a@chao-email>
In-Reply-To: <ZrrSMaAxyqMBcp8a@chao-email>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3 (3.52.3-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DS0PR11MB7801:EE_
x-ms-office365-filtering-correlation-id: 09b9947b-fdc9-49f6-ad65-08dcbb586eab
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?OTVRcjBIekJENk0vVGFQcTRZZHJhcldOTjdhOGFxZ2ovRTBycUIva2pOb0NV?=
 =?utf-8?B?blE5MWpiR0J2K05ZSXFSa1J4eGNhc3hnamZFTzRZTWJKVFkzb2VsOVhHUFBp?=
 =?utf-8?B?R3ptMXQ0THlzbWlnbVZ6bVZ2NU5Na1pJcis0K1cwTDZWYWhYYjlxbGg3RXZM?=
 =?utf-8?B?a0NLakZwa25aT3pLRzRvSExvM2t5Y2prelJhdCsvMHdQc3dPZzk2YU40Wlgr?=
 =?utf-8?B?MkZ2RVRiK0pLSTFERnN6SUpqKzcrTmozSTdpNUN5ek9NSjkzbE1SQ1VFU2JU?=
 =?utf-8?B?VmNzdEdvSGZiT2FTUW45b291d09kQVVkSlJWZlNGbW5hS0Q5TVFmSld1WXhs?=
 =?utf-8?B?NE9ZUk5MYncrcGlvbDI2MWtrZEQ4bE5UTittQ2hmemJVRVp2N2wvbmpUaFRS?=
 =?utf-8?B?Tjd5OVJuTXYrRzY1UE5zOHBrcHc5NDN3dCsydzVFVFc0eTNiZnlpb0E5ZXVt?=
 =?utf-8?B?OVNsdjdpZkQrbENDUWN2Umpac0hRRlVqelJxakx0YXgvbDAwTWpuR1NDRUxQ?=
 =?utf-8?B?Yjhmb2t3bDdVVStSRlpWQUNXZWJ3WHRIdDM2dXZqdWM4N1k2azZ2ZmU5K3U2?=
 =?utf-8?B?TDZPcC9oUm5SSERzMTZWODZIa0pXZWxuZFpLbFlWcXQxSzhrd0kyQ3B0UGNv?=
 =?utf-8?B?aThJd2ZQTjdFelByS1lXc2NiV004MStuelUxb0w4WjBLLzlqbis4KytoSXZR?=
 =?utf-8?B?N3NVbTJzMzJGU09HYWxNcU5ETlgxVVY4S3dIRVZsOHVabFluVHN3ZlVTSFFO?=
 =?utf-8?B?MjAyTXcwWVBVSjRXejkwZlVTT2dXTS8xaGJ6S1R4Z2pUOGU2dm14ajUzdUlK?=
 =?utf-8?B?RXM3VGNqdTQ5aE9ud05pbnRESnJPSVVuVnR2Z3dZbThqL1JMU3Y4emFSMjQ3?=
 =?utf-8?B?bnA2S09DZmJpaUxlT1prWUZhU2Z4QjE0eEJLSDUwZkJ2TXp6WXpaTlZMSkNC?=
 =?utf-8?B?QVJNUUVzV1lFRndmOXNCRUo3bll5aWI4TnpGQyt5OWxiU29BWU1ScTR5bnBz?=
 =?utf-8?B?K01BNWF3SXhNV3hnUUtxaGtXRUhSNGtmSUJCSWQzanNPMVN2WlRqblNYMEQz?=
 =?utf-8?B?NCszR2NrZTFRNElEano2dlA3cnpOWWtkNXRZT2kyQjAyZmtLRUVVYU9xUWtl?=
 =?utf-8?B?YUNLaElSZXVNL3l1SGplTk5SdWc4dDF6eExRbDM2NGxobGVoeWdJWjdhSkV4?=
 =?utf-8?B?NlFqVUZXSWpaTkt4MDIwSitTcE9HejVxTU9QMVhRdWl0Q21nbnRMeC8zTklH?=
 =?utf-8?B?cE8rdEtoUHpoWEQrOGx2UXJVWVVwcEVNamNMSnV2TXpVUytJZFdsd1pnTEt2?=
 =?utf-8?B?S3E1RldkNDRKQ0J0Q1dLSTBZcWZJY0FkR28vSnphRFUvVk9vOUxNbFBDOFJu?=
 =?utf-8?B?OWx4WVpQc3lweStjMHNVQWtPUS9tNWh6clRveFFiOENzOHUwRUxzbjM2cStU?=
 =?utf-8?B?SHU3SmhNNzA3Nk1sd1ZtUWczWmc2VVU5NCsxUC91TjRUNVRCd3dacEhwdTM2?=
 =?utf-8?B?WEpob0lPUERXYk1XWTY3bmFGS3FmQVFTOVJYSkRZNndIMHpucUhsRk9QMy9o?=
 =?utf-8?B?NUFvaTFGV1M2eGJrcXBVVGdTTCtaaHFzcjQ3alRLbUFpR2RZK080Q2ttdnFV?=
 =?utf-8?B?UnVnbi90RVYvMnEvODdhT0I1MFZWandjaVlBYUJXbnRUazZOZUp1bjdyUjd2?=
 =?utf-8?B?dUFpSmRFc1lSaUp6UUxhM2xpR0VyajFHL2ZsV3RMY1I2MlVVSXZDMldWTGkw?=
 =?utf-8?B?NGt4UnB1UENCR2tXZTVoZzJzOEZUZ0h0dFA1WFllZVdXdEErajFHNXoyNzRl?=
 =?utf-8?B?Yk0yS2JWQTJ2S1ZOd21GVUNIVk5RZjJMWnlnU3luVnhQVHVQOXR1b0hvV0xO?=
 =?utf-8?B?VUNPWUx1Z1Z0Y3UwQm5oWkR1a1dZN05NUDI5THlXdDRNM2c9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YkthNlhVWGFPNHVxeFMzaTR4eXZ3MEVsc0hkZmUzdFhmaXV4UEIvWjJSUHdS?=
 =?utf-8?B?OFRzZkJ1SXVCMThDWVF2aVRIWlZ2ZmZhYXVROW5hVzRlNTlpTHZ4aW82Q0l4?=
 =?utf-8?B?eUJzbWllOWxuZ1JZQmwwWUZGOUZybTllSE9pRXg4eThhMFRlQTMrNTJSUmRm?=
 =?utf-8?B?NTE4WDFVNUdEbkpYLytyRDFkWUFUaXBkR1dUZlJaREhsM2NDc3hKRG1UV1Q3?=
 =?utf-8?B?bHQ1QnAva2dwM3FSTVpjdjhIZ3RrSXJtcGFJOXFaUGQ0WEd2VDByN1k3YVhS?=
 =?utf-8?B?L0hLSTFqSkxqd0dUdzJtcWJXQmhvNFBLSFFXV3pxdkQ3SXRLeWFIMTZwanJl?=
 =?utf-8?B?eTZDbFA5bzNLWkNFcW5oNjQ1Y3BxaWgyemdoVjNmL1lWZHpZNzIvc0UxUGpo?=
 =?utf-8?B?VDBnMzJ5enFvVnJmTEtIYWRJNmtoZUdPTlNUQXpyYmo3WVJFd0svR3lud0tz?=
 =?utf-8?B?d2g5RWJncDZCMG9XUHFHT1JPbUxPYTdqam1YOTVQczhteVgzcnhxb1Z6N1Zv?=
 =?utf-8?B?S3lNYXNhZyt3cGRsNVZSdHg0Q1R6bWpHd0VIVnFNQ3Fwdm52ZkhPamVqSmpV?=
 =?utf-8?B?STJ1K081YjZQZmZSV1R2Wm1IK0w4b1pVSk9wb1Rxb2w2UzFYVFl5QXF2OXNx?=
 =?utf-8?B?VkFpajg4eU1Db0Z5T1JTa1JOb1duZWtaK01kWUpORS8vc1RZdFNwUGR5dWdw?=
 =?utf-8?B?RG1UMG5Jdi91a2pSREhmdThBWm1VTlp0akNjUTl5UUJ0RUdWQXhpcm1PeVda?=
 =?utf-8?B?VE1IUkdQbFZsMmg0NDU5anlUU25zQkJFcXhyNFMxUUNxZWdnUUFFazBxSFEv?=
 =?utf-8?B?U1BCNlU3VnJkb3htY2RlUlZ4dEhGb29ib2dOand3Qkhpang1dTBzcTFZK1J0?=
 =?utf-8?B?UVFheVZZZ3Vxd3hoM3oxUVE3SlFGbXFqZHl2c1RnUXRHdUpCTmZMbkUzYlFn?=
 =?utf-8?B?aWE1UlZ2YXpneXpaYjZoMVFJaXhDZTE5NWNEZUdocXRsK2hsNWlwL0p3UnNS?=
 =?utf-8?B?N2k2czZiQ2pXRld6K3pyeFkyQk1QeEQxeVRmb3NOZjhFOHBMa214Nmwvd1py?=
 =?utf-8?B?a1pxUzVEZG8rSThzR2ptN09mL0piWXREYlhxNUlIVm5mNCtHQ2RtYzZSUjZ1?=
 =?utf-8?B?WmhnSzZhMWZHZzd4MDF6aVBjUHlMdmRuR0tCOXVaWTR5a2h0RDhiQjZlUmNN?=
 =?utf-8?B?WEJ1L1U0R1hWN3p2VUVwaWV3NEJVTlIxK1c2TmRFbzA5ZGhOY2pNc2phblY4?=
 =?utf-8?B?RDF3NUcwOFBGb0E2UTllYi95R0kvMXJIc3UwN1Vtd2l1L0hBb2hla0VvTkJy?=
 =?utf-8?B?Ti9jeU9qdXY1elg5MFBFMG5YendpOTZyWE9hNXR5U1NuQnI2dnJ4SlYrSHZp?=
 =?utf-8?B?OGptdk1FNWFnbjd3VVpLaHA4VkExUzZWemliQzZObkpyZ0tuWXowNEE1Vk10?=
 =?utf-8?B?aU1ubmkyU2g2WXU5bTk1WlcwVzNDT043dTFkSGcwMkV6dFVxRFN1SzVlOGxn?=
 =?utf-8?B?UEt3bVQrUGthQ244YWdRMzZjWFgvN0Q2S1FhWS9EbkVRNnFVL05YN3FOdlYr?=
 =?utf-8?B?UjJpTzBXdE5QL1pCQWZQaVZnbTM4VUZEWm04elRuTTVLeFdIbmFIWDdCODdP?=
 =?utf-8?B?YkpxODhKRFI4YUJ5UHAzaVdkblovRVpwZm5WYW5pT3JpUThMTVQzRi9SRmxh?=
 =?utf-8?B?Rkx6NEIyWWhza1VJK3k4TDNRY256bEpXbEluWlJPa1l1SUQ1N1BNQ2dLTHpt?=
 =?utf-8?B?YnJpVnJId1JLRVNIZ1Joak0rbi9Eemo2b1B6OXdKNEU1R3cwN0R4SVlsVkE2?=
 =?utf-8?B?SVdlRlRVdWZpakRqUnRRUlNQeGZqTTEyRXpCanFnRnl4eUFYSDlCVU9uZEwz?=
 =?utf-8?B?UmhheFRiYWptUDVadFgvdmxxbTc0TWlTOVYxUDZiUE1DZUx6VUtGWDltaVpo?=
 =?utf-8?B?VlVSRWQ0K2pTRStES2JXck1hZHYxalF0TGhPbDdzUXBIKy9WQkxqamJmak1C?=
 =?utf-8?B?YzV2QlVLU1FFMlgxTlJFY1VHd0VXTmNhMkhud3YzR2tHODRISm1WLzZvNWZk?=
 =?utf-8?B?dk1kR2hYZDJER1BFV1FhNjl1bGRQSFFiOXNkNWdjVlphaGZjTGJaaUlMMERp?=
 =?utf-8?B?dDNMZ2VwcDJMWm5sc0N0NDRlbFRDT2ZzNkNPbnJPZU1ySCtZeHQycndEQzJK?=
 =?utf-8?B?RFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3211BFD8BA8AAF4E90902C1F3977D70A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09b9947b-fdc9-49f6-ad65-08dcbb586eab
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Aug 2024 05:26:06.7620
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ijePM4YJjjfgiRrsBcX69U7BgUs/cTiwFxNQNlymBvQ1aPmzxVg69SLY7hYl8lYrzw3HjOmkdmSM6Ciae1Dudw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7801
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA4LTEzIGF0IDExOjI1ICswODAwLCBDaGFvIEdhbyB3cm90ZToNCj4gPiAr
CWZvciAoaSA9IDA7IGkgPCB0ZF9jb25mLT5udW1fY3B1aWRfY29uZmlnOyBpKyspIHsNCj4gPiAr
CQlzdHJ1Y3Qga3ZtX3RkeF9jcHVpZF9jb25maWcgc291cmNlID0gew0KPiA+ICsJCQkubGVhZiA9
ICh1MzIpdGRfY29uZi0+Y3B1aWRfY29uZmlnX2xlYXZlc1tpXSwNCj4gPiArCQkJLnN1Yl9sZWFm
ID0gdGRfY29uZi0+Y3B1aWRfY29uZmlnX2xlYXZlc1tpXSA+PiAzMiwNCj4gPiArCQkJLmVheCA9
ICh1MzIpdGRfY29uZi0+Y3B1aWRfY29uZmlnX3ZhbHVlc1tpXS5lYXhfZWJ4LA0KPiA+ICsJCQku
ZWJ4ID0gdGRfY29uZi0+Y3B1aWRfY29uZmlnX3ZhbHVlc1tpXS5lYXhfZWJ4ID4+IDMyLA0KPiA+
ICsJCQkuZWN4ID0gKHUzMil0ZF9jb25mLT5jcHVpZF9jb25maWdfdmFsdWVzW2ldLmVjeF9lZHgs
DQo+ID4gKwkJCS5lZHggPSB0ZF9jb25mLT5jcHVpZF9jb25maWdfdmFsdWVzW2ldLmVjeF9lZHgg
Pj4gMzIsDQo+ID4gKwkJfTsNCj4gPiArCQlzdHJ1Y3Qga3ZtX3RkeF9jcHVpZF9jb25maWcgKmRl
c3QgPQ0KPiA+ICsJCQkma3ZtX3RkeF9jYXBzLT5jcHVpZF9jb25maWdzW2ldOw0KPiA+ICsNCj4g
PiArCQltZW1jcHkoZGVzdCwgJnNvdXJjZSwgc2l6ZW9mKHN0cnVjdCBrdm1fdGR4X2NwdWlkX2Nv
bmZpZykpOw0KPiANCj4gdGhpcyBtZW1jcHkoKSBsb29rcyBzdXBlcmZsdW91cy4gZG9lcyB0aGlz
IHdvcms/DQo+IA0KPiAJCWt2bV90ZHhfY2Fwcy0+Y3B1aWRfY29uZmlnc1tpXSA9IHsNCj4gCQkJ
LmxlYWYgPSAodTMyKXRkX2NvbmYtPmNwdWlkX2NvbmZpZ19sZWF2ZXNbaV0sDQo+IAkJCS5zdWJf
bGVhZiA9IHRkX2NvbmYtPmNwdWlkX2NvbmZpZ19sZWF2ZXNbaV0gPj4gMzIsDQo+IAkJCS5lYXgg
PSAodTMyKXRkX2NvbmYtPmNwdWlkX2NvbmZpZ192YWx1ZXNbaV0uZWF4X2VieCwNCj4gCQkJLmVi
eCA9IHRkX2NvbmYtPmNwdWlkX2NvbmZpZ192YWx1ZXNbaV0uZWF4X2VieCA+PiAzMiwNCj4gCQkJ
LmVjeCA9ICh1MzIpdGRfY29uZi0+Y3B1aWRfY29uZmlnX3ZhbHVlc1tpXS5lY3hfZWR4LA0KPiAJ
CQkuZWR4ID0gdGRfY29uZi0+Y3B1aWRfY29uZmlnX3ZhbHVlc1tpXS5lY3hfZWR4ID4+IDMyLA0K
PiAJCX07DQoNClRoaXMgbG9va3MgZ29vZCB0byBtZS4gIEkgZGlkbid0IHRyeSB0byBvcHRpbWl6
ZSBiZWNhdXNlIGl0J3MgZG9uZSBpbiB0aGUNCm1vZHVsZSBsb2FkaW5nIHRpbWUuDQo=

