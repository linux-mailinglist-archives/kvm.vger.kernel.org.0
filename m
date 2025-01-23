Return-Path: <kvm+bounces-36425-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F0489A1AA8C
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 20:45:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3A6DE16B30E
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2025 19:45:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 907101ADC88;
	Thu, 23 Jan 2025 19:45:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Dc9K9YFc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30201B3948;
	Thu, 23 Jan 2025 19:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737661500; cv=fail; b=EsoZBnNPCFWkJtUdW++8ahRhAADFm8nP022wJlXGJfSZjQe4vFGMpiP7wUJekintJkkMl4NPkjXel29G/28T6n7+TYOfV6dXm7/to9hyInuRThGeDzsDMJ46hx0VRbP09RZt8v8JQGe64oQmwXft7Ke8oeWVH+IlLA28e0PxTE8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737661500; c=relaxed/simple;
	bh=xdpkuZhJBXZ99Ykru/q1r3/YJ+uR0DLuoRs14lmziL8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fGMTS4z9A1tXO3QZ6RCvi0dLSQgE3NKzdPrDQeBkqSQaxSqmSuhRydKKfmkzXH3r8WccagiB7t0TbF25OQp9AtEDZz6xG4X3x4w3DHTLbP/WMQ3I/uzJ3d+e8YVsH0+rmTfXkuuG2ZqdHb8Dl4JCTfBy5D77bOJSbladEXEkTm0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Dc9K9YFc; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737661500; x=1769197500;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=xdpkuZhJBXZ99Ykru/q1r3/YJ+uR0DLuoRs14lmziL8=;
  b=Dc9K9YFcU+tgbHd69qJ8DzftbchhRjvTOLM/Dunphh56GoSmCQO4oEhn
   qGfuoz2vVSyq2DbM7lfGO6VVa+QfYzxcz5Oyr9o6bzdDThxOFob52WTtC
   0Xp8HiyxouaYnCPm3PLIdfvBVlnO6K4ZIrCfjtdpdymGVOjKDxsFjG7ID
   euwtUt0RzoLH+B/oPoUNEVbJ+8kPAxC5b8zNOS9kUZ8tjDP52cNeSXLnw
   24lqHNtEE1xYVvhwoW8DofquYwasdrp3VmfnFrUna+XN2SQxoCLL4Bl7/
   U/g4c3e0rMWunWwd+tUA2flO+9PEjTjPza2C64jyMi8eYsEe+ZVD/M834
   A==;
X-CSE-ConnectionGUID: Kl6NF9KdQIuiRfmFaTqjzQ==
X-CSE-MsgGUID: vMJTDbcFQAC/IbGpIzndXw==
X-IronPort-AV: E=McAfee;i="6700,10204,11324"; a="49581547"
X-IronPort-AV: E=Sophos;i="6.13,229,1732608000"; 
   d="scan'208";a="49581547"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2025 11:44:47 -0800
X-CSE-ConnectionGUID: zjaZSjqFTn2Y5qVG8LJePw==
X-CSE-MsgGUID: eIocrEwbSaC9beeOlIZZKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,229,1732608000"; 
   d="scan'208";a="107559506"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 23 Jan 2025 11:44:46 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Thu, 23 Jan 2025 11:44:45 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Thu, 23 Jan 2025 11:44:45 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 23 Jan 2025 11:44:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iefSiR5j/8/U4OOfZ9IMBOtWDpoHBmjRsZ8LJ21hB1PAG2tvTW7ZNu3V1XkfMhaC/QTEhvQHXYD1O2Yp5mN4zKRUWPwYLAi4t5R8C4oHpoHoaKdeEiSBnxNl0xoh/wHHxD/K7v4k44ZhMXqBTQM7zYUBmzinyY2bhlmFTDNDg6zE5Gn8+/QawnICqGdH7zDOcT0Us+eFn/j3Kik30l39MqAz6aJmTz7VnDbBs6B5EwMWadCbBJx/ezx8Z/8DysqnZ582KfikM3b4EybzTC0bVwb4/0uU6lL774NlcNA9+Slz5vZb0dtoD5OpgF9EGhy6jeqkONVeO8KUfWIC/ZjXdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xdpkuZhJBXZ99Ykru/q1r3/YJ+uR0DLuoRs14lmziL8=;
 b=xWTbyD9MzMZXBqfCnuWmZQHHOQGM04TuBinXgL1rVPt9B0Wl6WjwKTW1tWWVQ3rbOlZOG5AjNci3sxYGLiq9XKS7jeF86pfbOl2zb63UHMyVi1y3xf7sa+Dshobn3JEVJrQRVgFaa+rNajNPT9fHTo0TYXfiM2h8eQliJjiBpfGkmLz6aZtkcM3+zDyrwwQerhIBsBs3lmphLufgzj3nBVVhfDEAdNxDgBLpapN80BNpVxdfu9FZ3SnNhwEGE0+HCmxDWUcQsUwwCttt2LofqvtMyJgUiqpu3RY1u97R7yPwL7xncTKG9XuC33HyQty/+DPNhj+d/rjy0XY+q3cLLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by LV1PR11MB8820.namprd11.prod.outlook.com (2603:10b6:408:2b2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.20; Thu, 23 Jan
 2025 19:44:03 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8356.020; Thu, 23 Jan 2025
 19:44:03 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>
CC: "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Huang, Kai" <kai.huang@intel.com>, "Zhao,
 Yan Y" <yan.y.zhao@intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>
Subject: Re: [PATCH v2 24/25] KVM: x86: Introduce KVM_TDX_GET_CPUID
Thread-Topic: [PATCH v2 24/25] KVM: x86: Introduce KVM_TDX_GET_CPUID
Thread-Index: AQHbKv5FM3B1aLjYHk6i9GmMdsvqorMP32yAgBJPmACAAL3EAIACW4kA
Date: Thu, 23 Jan 2025 19:44:03 +0000
Message-ID: <30ae7206798d37f2887fc76f26a4c586fd7d9699.camel@intel.com>
References: <20241030190039.77971-1-rick.p.edgecombe@intel.com>
	 <20241030190039.77971-25-rick.p.edgecombe@intel.com>
	 <9e7d3f5c-156b-4257-965d-aae03beb5faa@intel.com>
	 <2227406cbc6ca249c78e886c301dd39064053cc4.camel@intel.com>
	 <71bf1ef3-ade3-4a0c-9ec3-d095e652731a@intel.com>
In-Reply-To: <71bf1ef3-ade3-4a0c-9ec3-d095e652731a@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|LV1PR11MB8820:EE_
x-ms-office365-filtering-correlation-id: 7efb7569-0d1f-43d6-d1fb-08dd3be64a50
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Y2d2VTRGN1RqV2tTTENzWmhjeXQzSCtFUUEvcFRsQlljcHY1T2JnelhvZnpL?=
 =?utf-8?B?ZTZ2bHhvRXN1UStoTlJLK0I2RXdMOHlBQm1mQUFzTmhhM1RkaWZJL2c5Z0hO?=
 =?utf-8?B?RjBSQWlnRWlQanV5dDZ5c3lIVStHKzQ2L0g5bFpQbEduUFJmN1VaYlNMNXVI?=
 =?utf-8?B?R2NGVHl0TXlEdFhhNks5d0llUnZ4Z0o0RU1vcjM2UTRZdGUxbDBmcmE5S09t?=
 =?utf-8?B?VERXdXNzTmdTQmx2elk4VWZUdDJxWGhrN0hvWE40enVWQy9FQXh1MHZITnFh?=
 =?utf-8?B?UzJrcVpSSFBVcUVNMUwvWWRBNEdra080T0EwRVZqR1hNNlE1bGJtQUIzeGFK?=
 =?utf-8?B?TkJreXlQYktWcXBQdE55OXBUTVhEd056c1VUaFJSUnNHTGhxeUF5c1dHUndG?=
 =?utf-8?B?UCsxWktHeG1tWUhWa0dVOWV6VGo3enlhZjYzMlpMVGo5SEoyYko5MzFHcTRv?=
 =?utf-8?B?NGVFWVZocWVrWEUrbzNKYW5sTzA3UGpBUWhpUlhLYmlXVS9YSkNxWkhxN0Zy?=
 =?utf-8?B?Q2NpdS9NZmlUVGZQenpGekRGckUwQWdDd2Q4SlVSYkdtUm9aNmVtTzFJZmhC?=
 =?utf-8?B?TWJsSUd4QjJmVWZ5N1l5SFBMeDh2cTQwQzdlNmpXT3ZXMkZzVzlJczZUMU9z?=
 =?utf-8?B?b2pROWh3K0luQ1JrSXJTUVpNMDlZZWNsWVZkZmM4M2xKd2c4UGswaXBpaWFE?=
 =?utf-8?B?RytTeTFmRENiUDVSa01nNWVudE12cEdIWUlBQkRxZUNhWXB6VTl4em91dzJF?=
 =?utf-8?B?VTJva250QzdmZ1J6MWgzZTd0S095dWx4M2Z5U0RkZldCcGp5NkMraDZqY01U?=
 =?utf-8?B?TXlvWVREcjdiWlR5by85Q1RNTEJDSWVQZlNEa09OVndGU3NTSXI5YTVtNU04?=
 =?utf-8?B?OGo4akY3R0ZkUXhaTWFlM09hcC9UT2taMGJUa01BMDlXN3FpckhsU3pqSUVr?=
 =?utf-8?B?d0srMHd1UHZSdWVjZ0xlWUplb1Y1cmxxNXVBNWdlS0FxQUVPa2VEVFhKWnhK?=
 =?utf-8?B?aEUxTUxLVHJKV041Q2FKcXZUMVhTSkxQK21zekRDZVpKWFhWeVFYcGg4SFls?=
 =?utf-8?B?ZlRjVFB6S1lGTHIxUjh2UUdaUElaR1FQdXN3UmJ0QUJDMW9meFdGT2Q0UmJv?=
 =?utf-8?B?M2ovNHV0cE1IZ1lCUjFQdnBZTEhRNHFXd09FRk1iVWIrNStoK2NKN2N0Skxj?=
 =?utf-8?B?bFRFNHVsOFRaSWJFYVo5MmNRcVc5OU9WVUhYU09oNXdJSjhBR0xvakxkL2Fr?=
 =?utf-8?B?azZLWU9uOC9BellYNlYweDhUZmZFVlF3cU9iNUtwWGhscjQxNXVwMmFzcURD?=
 =?utf-8?B?WElJeDR6elhCY3ZFVVV6OHlpMVlKVVpCS1RUczBUWWxTd3krU2NwT05oSExq?=
 =?utf-8?B?MEhabFBtNjRwRmhkeEt0RWJkRjB4d1B4ZHliVUFhcGE3c01NNmNTOEZhY0xN?=
 =?utf-8?B?b0RYQzhkTGJkRHk0VHVhZzJsQzJQVFJPbTlmaEhFa1BxRjdPdGowVXQ1V2dG?=
 =?utf-8?B?VlpZVWp1Wm83VEtaTEFFZ1hvOXp2SkxtV1RDR0NaR0FQUlM1OFJpbGMxVjR1?=
 =?utf-8?B?REdTQms0RjZUaVpXRWYyak1uY3lkSFNyOG1EdnBmdzBGNHFKVUxoa3o5N3pW?=
 =?utf-8?B?VWFCWHZ3YTNyemczK1U1SzBDa0xkNStRNGRuZ3B0UVpiakJTcW9sMVBjTm9x?=
 =?utf-8?B?SFl2MHF5MHBtdktVRlpybjZ1NVdxYldaamxURzFzdjUxZkY4K1NlSzE0VUN1?=
 =?utf-8?B?YkpnSWVKUW9OSE9PRWJYOUNYRDg1OUczZ3lmNWhlYjFwM1VIZnFOK3JSck5u?=
 =?utf-8?B?aU5rK1Y1L3MrRGgvVTQ1OEM2MGs2cFdLTlpEVXREUjNjMS8vTnQ4QzFuRGR4?=
 =?utf-8?B?aXkyTUxWZVpsRWVwYTl0aGpGd3dRVlhsaFU5M0czMW1IN3Fiam4yR1RMajF1?=
 =?utf-8?Q?PGQg+Xw8gJ3d2yrwYfeB9YECSGISgViy?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d2lqTWEwelFZeVVWbThURWFNQnAxMDZmZGVxamlFRmZLOXNpYWVZTXV0MWtH?=
 =?utf-8?B?QzJ5R1JzZi8yRGRtZU1hQUdMUUthTEFwd0crSzBrNDUwZDRPczBCTEtmKytz?=
 =?utf-8?B?NDZMRlJZQWRqMTlTM3I3ZWRyd2xmVnlxM0NsaGZhazNNcFBXRFVYWmlVL0dC?=
 =?utf-8?B?TGk4K2lxclFnTjZxcUNudm53bExub3pGUjNBeUtkY2VLcjY3V2JMdUtad0gx?=
 =?utf-8?B?ek5xQnZQTVJSZWFXMWx4NDR4K0MyemMvYmdNSU11cENremlLbmVHdXZuUEx0?=
 =?utf-8?B?MTlhd1BZZDJFYkZoalVsa2M1ZzcvOFE0T2pPV01tRnZwdERrNk1CSDNuTUxW?=
 =?utf-8?B?ZXNKdFE3Z2RITWFRaVo2QkQ1NllGdnpsR1NMN3V5d05pRDdoME1QYnd4S0g0?=
 =?utf-8?B?M0hEZ2NTWmFrUkxMbUZUQ3BEZkxQLzREOG1jTmpvWnJ3SmhvaStIVDY1c0ov?=
 =?utf-8?B?c0pJbW15VHNZT01sOUo0VklacFBoM0YwREYrZGw2aEQrUDI5YWZhRGIzVTdp?=
 =?utf-8?B?RFBRUExmQk93bXhpWUp4Q2dPcjFtcVp5dEp4T3BCdFBqSzY1dGl2UWE0NXVD?=
 =?utf-8?B?RHZKcHNqQ3Q2ckRYWWl6blRTcVZJcmFIT0NESDJRcENnSVFvU3lMM3dST0xW?=
 =?utf-8?B?UUJQeUE5YWk2WXJkd0IwaEFxbUZPUVdjdDZiWTRRdC85M1JFTEQ0ZUV5NjUr?=
 =?utf-8?B?VGN0ZFQxTzBXeUhpVWR5Um5WUWNvRUpRV0dBZWZCejl6bmdqbEVQZHQzZG1M?=
 =?utf-8?B?dG5pMEtVSU5DeThjT3FCVFIzcEpVNnZIQnByc0dMSk9hWGZWUzhHVmIzSnBj?=
 =?utf-8?B?Vzk4eExOU0orbXUzY0ZCUnFyVFQ4UmpEREdWUkNFRllnMzlRZ2IvRVptTmZ2?=
 =?utf-8?B?N3NMVC8yemxicldsZkJqMW5qbWhKd0hYdk4vNEJWVUx3Vm5scjBQb1A0a1RE?=
 =?utf-8?B?bEdSNFZYb3VVWlR3NmJ5YWhuRXRlZFRLdmFUWDdhVTFaYVBQSXo5ako1WlBv?=
 =?utf-8?B?UnBvSHAwVG1tODRVL0pLVTdhZld2c0NhVDZZSEs3bUFZODM2VWdsdzR6RmRL?=
 =?utf-8?B?Y2hLdUFacFlPQ2V3dUVjZWVEdHdkb0VCK1VtS1dQSFZqYys5K3YwTzRtSEZn?=
 =?utf-8?B?ZHcrTWVmbC9iWk0vZnphR1lYQU42OTExL2h2U25jM0s5ZUo3OVV6cG9yNUZ4?=
 =?utf-8?B?d3pxSGx1VE5qc3paUjI0VjN1T1RNeWV3ck8yblNIaWdLcGdTbDY0V1haNTRo?=
 =?utf-8?B?UTBUWTRYaEpkMk0zelBQdzA5VFNRZEtENUNqcE56K2EzVHFReHFrNzljV0dL?=
 =?utf-8?B?SCtwZWVUUzlZWC8vbzZ4cUxJb21ORDZ1YnVDNEh1UkZYTzZnS0xmRHZZeGV0?=
 =?utf-8?B?TmxKV2xQcVBjRktxeXdWVEh1Um83R3VMclNsdWgvTVU0ajBQTTJKREhCTzZp?=
 =?utf-8?B?YlA2ZUw3dVlnTFBmb0pNbGhJWFJmU2g5MGl3SEk4UG11WllwZTdBUmFCMC9k?=
 =?utf-8?B?RWJydGVRUEh2Uk45UWVqTHJzTUZ3VkxsSnhFUUV3TnNKNFc0NHh3alJ0M1Mr?=
 =?utf-8?B?M0E1aGV4YXNETXcrS3o5SklLOTRxOFNYeWxVc0ZtWUtBQ3VjM3BhazJuSXY2?=
 =?utf-8?B?Q1RiSFZEeHV4MWlnL1l1U2dacmRWc1p4cVZ5MXIyQjhMTEVKQzNiWjNGOGVC?=
 =?utf-8?B?cjVnRHdmcUlPcGlvNkRxVU1taU5jSWxBNjE3cmdJNGhWR09RdDk1NXNCaFZ5?=
 =?utf-8?B?b0Z4M3pEb3E0eGRKN3ZmSFpKR1U5K0JmK09KdzZkU3hhc01xQVBKYWZMLzVD?=
 =?utf-8?B?eDRsZ2Z1MG1uNHhudGtGQkQzWjFoZUZ6ajZnNldkTTh5cEdHVWQxeThPclVH?=
 =?utf-8?B?eGVIUjhCSk5sSTVZM2ZKRitaZStlSEtJOHJWZlhuS01Xb0NiQ0ZKQVpwZlJ5?=
 =?utf-8?B?Q1BMekJsN3RTRDV6OW4yODR1WmpzSzYwNDhNeGYyNXV1N3F0YVk0Q3JBTS93?=
 =?utf-8?B?MTBsQk5MN0pzNzV6Y3Z1NFNsT1E2TkVKdnpMVTZ4cUhWaGlRczFDRkhoNGNS?=
 =?utf-8?B?YWNwbkhYQmd6a3N6TnBBSlZWWmlrbTBRQ1dtK3ZFWlRib09MM2JYck83aVNS?=
 =?utf-8?B?UGlkeXdDeE5JUzZPOTgzcm8vdUVaMHN1NW84L0NzblV2MmkzaHlFSklPNW5L?=
 =?utf-8?B?WGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0F6F2F20C08826479E78E8D38D27843B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7efb7569-0d1f-43d6-d1fb-08dd3be64a50
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2025 19:44:03.1720
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: K8eLQZtrfGGqH87NwqiJniovUxZx/1E9Fw+KA598S+n8JlY5I4DYOKIrRLNkZZdIideJ5yy/vvdJ6VreG3Z600qxU11HrUteCEXWIiRHQIs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV1PR11MB8820
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTAxLTIyIGF0IDE1OjQzICswODAwLCBYaWFveWFvIExpIHdyb3RlOg0KPiA+
IFNpbmNlIHdlIGFyZSBub3QgZmlsdGVyaW5nIGJ5IEtWTSBzdXBwb3J0ZWQgZmVhdHVyZXMgYW55
bW9yZSwgbWF5YmUganVzdCB1c2UNCj4gPiB0aGUNCj4gPiBtYXggbGVhZiBmb3IgdGhlIGhvc3Qg
Q1BVLCBsaWtlOg0KPiANCj4gaG9zdCB2YWx1ZSBpcyBub3QgbWF0Y2hlZCB3aXRoIHRoZSB2YWx1
ZSByZXR1cm5lZCBieSBURFggbW9kdWxlLg0KPiBJLmUuLCBPbiBteSBTUFIgbWFjaGluZSwgdGhl
IGJvb3RfY3B1X2RhdGEuY3B1aWRfbGV2ZWwgaXMgMHgyMCwgd2hpbGUgDQo+IFREWCBtb2R1bGUg
cmV0dXJucyAweDIzLiBJdCBhdCBsZWFzdCBmYWlscyB0byByZXBvcnQgdGhlIGxlYWYgMHgyMSB0
byANCj4gdXNlcnNwYWNlLCB3aGljaCBpcyBhIGFsd2F5cyB2YWxpZCBsZWFmIGZvciBURCBndWVz
dC4NCg0KR29vZCBwb2ludCwgd2UgY2FuIHVzZSB0aGUgY3B1aWQgbGV2ZWwgcmVhZCBmcm9tIHRo
ZSBURC4NCg==

