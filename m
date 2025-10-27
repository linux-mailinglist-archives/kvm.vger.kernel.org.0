Return-Path: <kvm+bounces-61210-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54C3BC0FBEC
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 18:46:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 324FF42542E
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 17:46:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 782222D640D;
	Mon, 27 Oct 2025 17:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dLMxV1Q4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203401E2614;
	Mon, 27 Oct 2025 17:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761587172; cv=fail; b=MIKsxOVtT86p/q+sscR1YhUlQxHVC9uPDzasLaONeo5IP0zc1/ORshtJyS/8iDkToC378UxGOHwLpBfNlQJZaNSeLbRXoxDeG9PXynuC6JQkVfV1fP4Rtfs35/ZkltkH9cuw3iARD66BTdDE4Sh3vwO653UbqunsD1fonyHvLXs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761587172; c=relaxed/simple;
	bh=Mp1iuvKHe4V619dMUpC9CWwsWWkKcia9U2+OntVFvlM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=h2fCXSxLTWV9dHGviQRhBUC5IKdA8AqpktZGBHLf9/Dj6nYezISzO4Q3C4Kxg/FPRGQ5tr5wGXF3BeVcfL+V5x6qWLEwtXQ1KJ3pvDa1PKQJBoLbD8Q7+sR8TKqmLCmCK5Clw1a/RCT955xbSOsohDnt2jtJQGxh9W8ynWrt9rc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dLMxV1Q4; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761587171; x=1793123171;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Mp1iuvKHe4V619dMUpC9CWwsWWkKcia9U2+OntVFvlM=;
  b=dLMxV1Q43ciRdrvLiK6HMFxCxsTgiePetfCNu1ukAfO3fK9gWpkO1Msx
   C3eDfT44nZteaeAp4OGMxlrqncQ8iw2TwhRfnm2qPQ1/JHbJjiGhnnh8C
   wzreZLPMwQ81oXLOZrmSEKL/dbmpmvI4xDMyPbDoaEb/Idu23p+P0hy5e
   DSEjIEHsD5kXdxFovAj+Kr8b3jsr0CYtqJB/BBuvxB3Vh0XRWKHTSoJ1z
   AZxsLHM95qKwF1V4BTHe0na9HHKnktBFoM9zkJqxhwVSRE32454GaV9Xn
   eKUn9wffQb06agNdnfi1bJ7cEzx9oM9omJR0jTEy8OxMGJsPGC5hcTVeR
   g==;
X-CSE-ConnectionGUID: uSA2iEj1Sle4NJ7E2TMNzg==
X-CSE-MsgGUID: yLSx0foRSu+3CLFt19L1Ew==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="63574256"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="63574256"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 10:46:11 -0700
X-CSE-ConnectionGUID: eVV39gGuRz6oIGW4Xe8Tgg==
X-CSE-MsgGUID: SYLLQZlIQISYWZG1kT6LAQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,259,1754982000"; 
   d="scan'208";a="215762901"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 10:46:11 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 27 Oct 2025 10:46:10 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 27 Oct 2025 10:46:10 -0700
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.18) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 27 Oct 2025 10:46:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vJuqLjo1uOKpXYP2FS7IQ3kWXe11SWHrMvPi2DQTuludpKNoQBMuTsQtmX5eR+RqvCoCeFWZOedEbCpdoby8ea2jSUlJLqK5VaZUs0izy2NUlRYcrpjiW5T7SQzw8bboX5UGUItP2JD4HEFsxd3pKWiP46eZN01tFMRRo9wkC6UZQQjvuyvkKdTH0DnfH5JvV7d0YPJM74IeD1HVnEu20pq2+WvXcuuHg/J3f/o4dGCl7GGZZIzcz5WVjImWG9DJCS1G/eUrbGhK6V7Q3u2grxlJAiOsu0bB+CSc7EKealc284FTkWLtlK4FyoWILOPZT/MuhvpQPGtJMj3FfGL5UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Mp1iuvKHe4V619dMUpC9CWwsWWkKcia9U2+OntVFvlM=;
 b=tlpiks8IUlGwmTeR4b8+hIhLfZrI8ZnICRc9oBAWOiNOHA2fgzWIiEstvERB+0Y9i3D8/GCPSOXWS7U4+8fgnzYp2NnzchFLjUNrmiNSbsYiNXIv0TBl7eh7mAngoq6J2rCJuy9+N1EKAFlYFnt8J0xExy2ukS3vDMFVU8wmi9h96NyHBwgyJupFGvqo6Nw9XMibYnxoaVX/NU3PW8G/JQc7Iyf5Gj4XpMKIjg0t8HEyDEwuL04G3jXfAlaEPMX4tIJ0vpurNV2JpFBq7joAM7tTruZV3Wr74E8rE20mjaa64Nptt4mgy8lsjgZlbJvJUBilI3BE5/Q/D5o+LHgtgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by BL3PR11MB6481.namprd11.prod.outlook.com (2603:10b6:208:3bc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Mon, 27 Oct
 2025 17:46:03 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9253.017; Mon, 27 Oct 2025
 17:46:03 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
	"kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-mips@vger.kernel.org"
	<linux-mips@vger.kernel.org>, "linux-riscv@lists.infradead.org"
	<linux-riscv@lists.infradead.org>, "linuxppc-dev@lists.ozlabs.org"
	<linuxppc-dev@lists.ozlabs.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "palmer@dabbelt.com"
	<palmer@dabbelt.com>, "x86@kernel.org" <x86@kernel.org>,
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>, "aou@eecs.berkeley.edu"
	<aou@eecs.berkeley.edu>, "Annapurve, Vishal" <vannapurve@google.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"maddy@linux.ibm.com" <maddy@linux.ibm.com>, "maobibo@loongson.cn"
	<maobibo@loongson.cn>, "maz@kernel.org" <maz@kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"anup@brainfault.org" <anup@brainfault.org>, "Huang, Kai"
	<kai.huang@intel.com>, "frankja@linux.ibm.com" <frankja@linux.ibm.com>,
	"pjw@kernel.org" <pjw@kernel.org>, "zhaotianrui@loongson.cn"
	<zhaotianrui@loongson.cn>, "ackerleytng@google.com" <ackerleytng@google.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "Weiny, Ira" <ira.weiny@intel.com>,
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>,
	"imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>, "kas@kernel.org"
	<kas@kernel.org>
Subject: Re: [PATCH v3 24/25] KVM: TDX: Guard VM state transitions with "all"
 the locks
Thread-Topic: [PATCH v3 24/25] KVM: TDX: Guard VM state transitions with "all"
 the locks
Thread-Index: AQHcPv2w81uMmlMzI0yEAMgtbEXDh7TRHKOAgABz5gCABDjwgIAAi6mA
Date: Mon, 27 Oct 2025 17:46:03 +0000
Message-ID: <77d8a0d9541ce3fc2b2c76b58add50d152b52e39.camel@intel.com>
References: <20251017003244.186495-1-seanjc@google.com>
	 <20251017003244.186495-25-seanjc@google.com>
	 <aPtOtzGLigbY0Vqw@yzhao56-desk.sh.intel.com> <aPuv8F8iDp3SLb9q@google.com>
	 <aP86sdBZxXm5I17f@yzhao56-desk.sh.intel.com>
In-Reply-To: <aP86sdBZxXm5I17f@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|BL3PR11MB6481:EE_
x-ms-office365-filtering-correlation-id: f8821a0e-0fcf-40c1-7f9d-08de1580b2c2
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?dXk5ZEtxdlBmK0pnOFF3RHJ1TmJvbUNIRWlob1l6WWorOFdVQTY4enZkMnJI?=
 =?utf-8?B?Zy81aVpMYzNiNHV6OXFKYWx5V1lxZ01EN0hoalkxR3VwakwyV2xKbEFKbUlk?=
 =?utf-8?B?L2lScC9lNXMyQXY5dTNvUExRR2V0ZExVWWlEc3diSVh2b3EzTUliWFdKSzVp?=
 =?utf-8?B?YVdhRGxqdWtoa3poRlF1M2dKZ01sR3lLVE9zc3VMU1ZGN0J0ZzdjakZjblBu?=
 =?utf-8?B?Nk5kN0s2VVVZaEMxbldGTk1oUDMzSnN0V1UraEJ3SS81cnR2ZlpJdEhETEpP?=
 =?utf-8?B?UGtDNS9LQzVpenRaZU5ZWXcvT3Avb0pSczhJc2xlNDFQbDRwSkR1UXBSZDdC?=
 =?utf-8?B?UGlqbXR6T3F2U0NwaHpqVW4vamF5eWlQb0Q4Nkh4b3N6c3V3Tk9EdFJ3TnBB?=
 =?utf-8?B?T3A1dHV5UENOMU91aTFCVUQ5OGtBQ3NES25LN0N2Y0JkOFQvL3kvYnYrNWQ4?=
 =?utf-8?B?UVFkZHF6S2RxTzdib2l3VHY0U0tDWENmR29uMU9DRlMvdk8vZFhoZW9NOW1t?=
 =?utf-8?B?Y3g2ckhiL0l1Z0FwbW1mWGsyTnkzcHQyM08wRUVSZGkzMjI4T0xxdFNPYVRs?=
 =?utf-8?B?QnFiK2dQRlZUWHJMZ2txbmsxNSt5QmpzWU9YSTFPZ1gwVnlNRDJXQWpJZXBR?=
 =?utf-8?B?Y3pMN2FJOGliOW16ZERaaEJ2ZlgzTldlM0JKbndRTTVXZW1wdFVucmxtamZ1?=
 =?utf-8?B?bGdjbFZMRUhwM09VcGo1RkU4bVl6WmhUM2VGbktIRHJOaTNBNm5sdkJpUGRQ?=
 =?utf-8?B?UUVxRENKS1Rta3BVbmtBTW1NRnRJUFgwUzE3d2FHL0VRUjFjYko5QjRQeHIz?=
 =?utf-8?B?WUZlN0p5MmwwUVVQSmtUQmsxeUxtQ0dkUWhzTndxNW1wcnAvbzNpK0U1YjFF?=
 =?utf-8?B?QlpBSXN4Y3p6SmRLY2xmOXlDTXdTWkdvbzFObWsyaUZ1M3haNGtETVFlYTVt?=
 =?utf-8?B?MVU2aWJsTW5nQVBCMVM0bTNqaEtlYi8xWjRPUHNYR3o5QlNjN0F1Nm9VeHBl?=
 =?utf-8?B?MW9iQ0M1RG1xV2txNmVPdzRPaS82YnZNNlpKYmVXVEZQeENTMVZublRBdm9i?=
 =?utf-8?B?SWlDc25SbVV0eTd4SkNtK3dFYTFXeHVTY0NqdUNINmFTNFpabGdvUDNGeWhJ?=
 =?utf-8?B?ZWsxdVNyclA5RmdxemFPTVBIaUx3ZFdhMTRXR1gzblRoUDUyM0R4UEl5bHhI?=
 =?utf-8?B?TFBtb09MWWV3U3owK3B1bkhvT2lQRHVIWWxQejYzLytQRGQ5V1lnWWVoZUxz?=
 =?utf-8?B?QlV5KzMvTHpIMERWYVc5bzV3Z3lSQjRnMmxyLzRFWjZlaGpKUlMxZEJ3dmRN?=
 =?utf-8?B?YkJxN05SVWpPOThaNy80RWlnZ3pPRjN6NjFKYWIvWStEcWI3czhMbDcwNDlC?=
 =?utf-8?B?eUN0NTMvM08wTERHYXJyWldSa2praTlPUm5ROWZZQlFGMy83blRGRzFLRjhp?=
 =?utf-8?B?aW4vL3gzYmI4c0EzZ3VHU052QUZRcmdqVmJDRWNVNXVoeXpkL2Q3QThrcERC?=
 =?utf-8?B?dHd3V1NSVlVwc05rbTM5Z3d0Q0VRaEZ1RUxLRDZITTFiT01LaXppTmlOb1Yx?=
 =?utf-8?B?TC96cC9STTJYaEJNR1FwaUtsdGh5d0tYUjM0SnJFVnl1dUpqRXp4dmNFcVVO?=
 =?utf-8?B?b3o0bUMxaHdaWFpQc3RBRjdRMFc3UG1Ebk41SEdhRmx5T3VJajFLT2RVanNh?=
 =?utf-8?B?TGtCZXYrSS9PK2VGSU8wOHpDQnRwYXRjbnFVNWNEZVpoM0tIUVZIYXN4dkRp?=
 =?utf-8?B?MHJDVkJFT1VpakRCd3IvY3NQYlJTbFNSWHU3TENUY2xYYmYxVCtXUFVBMzVq?=
 =?utf-8?B?eUVMYjkxUSt6WVE0YWRuNUIyTTF4YjVRVk5sVkIrYUdZWkgrL3MzTnZVZTk5?=
 =?utf-8?B?VnNJd0ZqMEZnM09hekFjNWRpYS9jTFFNNk9WZ3doeEhrVUx1dVNJUU84MEYv?=
 =?utf-8?B?L2RZalpjRnVJaDFiR0h2Q0tPY1pEenJ6SXgyN3YvZEVXRmdLYmhBam1qWVNJ?=
 =?utf-8?B?eEducjQ0NGowZytESHRmeFVXWlhnZzZrMmZ0bThEblRqMWcxVVFPQkt3YjV0?=
 =?utf-8?Q?p+fhFx?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N3c2TWhkM1pkSVZ5MmI4SXdFSjFFN043SkhLdnp6V2kwR09uL09OYlJmcEk0?=
 =?utf-8?B?b0dMcTAzekNsU0NGb2lMWE9zU3VSTWhZOGFFNTYvYXNLd2VLTWhFMlUwOVl0?=
 =?utf-8?B?MGY0dGt6V29uSUtnQndOdVR0VEdBS29hdmxTbWNYa0s0UEtobXgxYU82Y29T?=
 =?utf-8?B?dTZuNStkYUFiVmMySkY1a2RJSHJYeFhFYWhFMVF4WklmdHV5emNMWFNtQncw?=
 =?utf-8?B?b0FnUnFpazM3b3IxYlBoam1GQjIrZFM5ajdHRU9INUp4S2t2UWRpWWFnTzVQ?=
 =?utf-8?B?eFBkaUpzUGJCR1Yxb3VpcDg4NTl5bDZpZ2VJY0RWSkhwR0dJMXppUWJKSlpT?=
 =?utf-8?B?OUY3eU5uR3FlOVgxN2tVUFI4eUtLaFJ4Z3poc0JUSEJQdHcxQVhhcUZHSzdQ?=
 =?utf-8?B?Sk5BS0d5ZkNpb0IxTGV5RUhobjBXYVRSZGVhZTZhSTlvcnZTN0lscGFaZ2U0?=
 =?utf-8?B?M2VPN3ZpL0c3Vi82U210bmpEUDJKU0ROT2lXU1NhU1dMU3BTbTZoeHBiK0R1?=
 =?utf-8?B?akxpcDVQU3ZnT3hrRU5YUUd3VGo1YzJrVUVUcmFVWC9HVXRFblEwelRUNUZE?=
 =?utf-8?B?YXgzajZLQXdQWnZwRjlFdEcxUnBESk4wRGdaejlZS2U1OXpwd2MxTy96bkdW?=
 =?utf-8?B?d3p4UzRMSlViNUV5UVpQQXcrUVNTNjVLRkduUWVHd3l1UUlySE16MmFQaTRY?=
 =?utf-8?B?ekpXYW1CVFUybEZpYWlkL2ZhZ3IwSHBMR3ErSkxkbjRoM0xIaGlzRkd4eStk?=
 =?utf-8?B?OHlMb3hXTFBuQ3d1V0NGQkNsMFVBakxMZXpSY2x0dVJEKzdpdE9jUStFVmVV?=
 =?utf-8?B?M0VRa3AxYTQ0Ny9Weit5RFZvTkpQSnRkKzh4ZVlpenluNEFRWkN0RGxUbDhR?=
 =?utf-8?B?dzErVmw4Z25uTU1OM0Jsb0k1U3piMUdISHV0SWJNYktzRHl5Uy9vTlkzYndw?=
 =?utf-8?B?Q080WDU1dHduV09BY0tFMC9BUXlvenBGY2gzajNBUW5jckVQeXF3cTNteVNU?=
 =?utf-8?B?Z2wyRUtDVUxieE1iNEZ2U2NMNFAvS05OTFp5eWFiTVFGYmw2OHErQndIOGRO?=
 =?utf-8?B?QTdQWkQrTVZaSEdXSnU1YmQ5bUtQTURERmJyTlluK3JuVVVIN1U5Y01hWmdx?=
 =?utf-8?B?Y2Z2Qk9yZ2J6ZWt3VnhJVGRKQzFwMmtzRlRXNDF6Tnl0VFlCZFVLVGg3bmhV?=
 =?utf-8?B?Tis0b2hNK2FJZSs4TlJrbDNrTzhSYnd5Q3VyWHFreGRUUm9vT2xqd1E5Z2FE?=
 =?utf-8?B?MUp6eEhhc3A5aVhqZ3g0T3JqZnFHYnBkV0VNTFdRWmdwWEhyNDZrK1k1czVl?=
 =?utf-8?B?NkRSY3hUeUpvK3FSTHJBM0QwSG1oWVJHT1NOVXFmOTBpWmh5clRNdDhDUWpS?=
 =?utf-8?B?Uk1CY3dnU2Q0YWhzdjdWQ0VScTBBRW1RMjJlSEZmVnl0RkxCekRtSjdtcTFH?=
 =?utf-8?B?L0JyeGVydGR6RWJXbWFtSG1xOWRabjJQQkVQSlIvTDhJLys0Wng0WlAzNlFP?=
 =?utf-8?B?V0x3YStBSHZjYi9oM1B4djZUcFN0ZjV3MVZESlA1b2FmQUVsRGRsaWMybitx?=
 =?utf-8?B?bTR3cGt3Z2RUN0g3azNZQWo4M1RRTVZrTGFPWlhKWURjcC9wMnBvRGp5Sy9s?=
 =?utf-8?B?Y2IrNzMzOURjenZlWnh5NjMzeTJiNUlKUU15ZXd4M2hKTHV6dS9IU2RUYWJT?=
 =?utf-8?B?YlYvcEZ4a2NFblB1YW4vSmk1M01aKy9lQzd0dTBXQ1BLMHlxc3phbG9kSm1j?=
 =?utf-8?B?djZuZHFpZjRZUWZPRm44ZGZqeTdpUThYKzlQTWI5bFJWcjFuVDJtUHhRRE9V?=
 =?utf-8?B?dEJZaVdiN3lwM1NhNjYvRFBsemV5clR2S0tJYkpBTlVvTEdIVHNzRmh6TVNm?=
 =?utf-8?B?VUdTMmdFTys0OGhYaWw5TFRpdHZEa2dlNDU4TXFsaE55WmlUQlRXMUtUTjhV?=
 =?utf-8?B?S3B2SDN4RVRaN1NJV1FSQUI3bkFTZkRtaFJZLzlGY3htSjZXTGJRRHRPQU5x?=
 =?utf-8?B?UVJIcVdKWmRhZnNlVlNsQmVmVkx1YkxsdTBqSnN6M1FJTEhEbVhZOFBPMGNu?=
 =?utf-8?B?YzJJMUxjYVRWUE9OeVlnczlDVWJCZTRMZGUxR3pYdGVBTUV3T2JGRmpPcXFI?=
 =?utf-8?B?LzRBQUc4Y2oremdZMk5EQWI1d3dqbVR4TklQN0pFeUtvam9xaVpJOEQ4MUFR?=
 =?utf-8?B?M3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7E74CACA40C74B4496811EE9A1AEB7E0@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8821a0e-0fcf-40c1-7f9d-08de1580b2c2
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2025 17:46:03.1926
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1E5E2DSGU9EI1M2zDmZ3E1l9Iw742vEDZwLlfYEUrGxZPQtiGwFyYLcSvwCoGiOrFEGeSxnfjgMHgT0L/v/5FLmP/V3pW0Iayy2dqb/zhXA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6481
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTEwLTI3IGF0IDE3OjI2ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gPiBV
Z2gsIEknZCByYXRoZXIgbm90P8KgIFJlZnJlc2ggbWUsIHdoYXQncyB0aGUgc3Rvcnkgd2l0aCAi
djEiP8KgIEFyZSB3ZSBub3cgb24NCj4gPiB2Mj8NCj4gTm8uLi4gV2UgYXJlIG5vdyBvbiB2MS4N
Cj4gQXMgaW4gWzFdLCBJIGZvdW5kIHRoYXQgVERYIG1vZHVsZSBjaGFuZ2VkIFNFQU1DQUxMIFRE
SF9WUF9JTklUIGJlaGF2aW9yIHRvDQo+IHJlcXVpcmUgZXhjbHVzaXZlIGxvY2sgb24gcmVzb3Vy
Y2UgVERSIHdoZW4gbGVhZl9vcGNvZGUudmVyc2lvbiA+IDAuDQo+IA0KPiBUaGVyZWZvcmUsIHdl
IG1vdmVkIEtWTV9URFhfSU5JVF9WQ1BVIHRvIHRkeF92Y3B1X3VubG9ja2VkX2lvY3RsKCkgaW4g
cGF0Y2gNCj4gMjIuDQo+IA0KPiBbMV0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsL2FMYTM0
UUNKQ1hHTGslMkZmbEB5emhhbzU2LWRlc2suc2guaW50ZWwuY29tLw0KDQpMb29raW5nIGF0IHRo
ZSBQREYgZG9jcywgVERSIGV4Y2x1c2l2ZSBsb2NraW5nIGluIHZlcnNpb24gPT0gMSBpcyBjYWxs
ZWQgb3V0IGF0DQpsZWFzdCBiYWNrIHRvIHRoZSBvbGRlc3QgQUJJIGRvY3MgSSBoYXZlIChNYXJj
aCAyMDI0KS4gTm90IHN1cmUgYWJvdXQgdGhlDQphc3NlcnRpb24gdGhhdCB0aGUgYmVoYXZpb3Ig
Y2hhbmdlZCwgYnV0IGlmIGluZGVlZCB0aGlzIHdhcyBkb2N1bWVudGVkLCBpdCdzIGENCmxpdHRs
ZSBiaXQgb3VyIGJhZC4gV2UgbWlnaHQgY29uc2lkZXIgYmVpbmcgZmxleGlibGUgYXJvdW5kIGNh
bGxpbmcgaXQgYSBURFggQUJJDQpicmVhaz8NCg0KU2VhbiwgY2FuIHlvdSBlbGFib3JhdGUgd2h5
IHRha2luZyBtbXVfbG9jayBpcyBvYmplY3Rpb25hYmxlIGhlcmUsIHRob3VnaD8NCg0KTm90ZSwg
bXlzZWxmIChhbmQgSSB0aGluayBZYW4/KSBkZXRlcm1pbmVkIHRoZSBsb2NraW5nIGJ5IGV4YW1p
bmluZyBURFggbW9kdWxlDQpzb3VyY2UuIEZvciBteXNlbGYsIGl0J3MgcG9zc2libGUgSSBtaXNy
ZWFkIHRoZSBsb2NraW5nIG9yaWdpbmFsbHkuDQoNCkFsc28sIEknbSBub3Qgc3VyZSBhYm91dCBz
d2l0Y2hpbmcgZ2VhcnMgYXQgdGhpcyBwb2ludCwgYnV0IGl0IG1ha2VzIG1lIHdvbmRlcg0KYWJv
dXQgdGhlIHByZXZpb3VzbHkgZGlzY3Vzc2VkIG9wdGlvbiBvZiB0cnlpbmcgdG8ganVzdCBkdXBs
aWNhdGUgdGhlIFREWCBsb2Nrcw0Kb24gdGhlIGtlcm5lbCBzaWRlLiBPciBwZXJoYXBzIG1ha2Ug
c29tZSBraW5kIG9mIGRlYnVnIHRpbWUgbG9ja2RlcCB0eXBlIHRoaW5nDQp0byBkb2N1bWVudC9j
aGVjayB0aGUgYXNzdW1wdGlvbnMgaW4gdGhlIGtlcm5lbC4gU29tZXRoaW5nIGFsb25nIHRoZSBs
aW5lcyBvZg0KdGhpcyBwYXRjaCwgYnV0IHRvIG1hcCB0aGUgVERYIGxvY2tzIHRvIEtWTSBsb2Nr
cyBvciBzb21ldGhpbmcuIEFzIHdlIGFkZCBtb3JlDQp0aGluZ3MgKERQQU1ULCBldGMpLCBpdCBk
b2Vzbid0IHNlZW0gbGlrZSB0aGUgVERYIGxvY2tpbmcgaXMgZ2V0dGluZyB0YW1lci4uLg0KDQo=

