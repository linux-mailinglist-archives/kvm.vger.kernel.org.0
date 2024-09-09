Return-Path: <kvm+bounces-26109-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B856971526
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 12:18:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 13A0A2834B4
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 10:18:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B34EE1B3F2C;
	Mon,  9 Sep 2024 10:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SCjfofYs"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E63EA1B3B3E;
	Mon,  9 Sep 2024 10:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725877108; cv=fail; b=KczyVZzmJb1JC2hYVl0Kx+CB36Nf9nGIU0tPccE8g2gpkOAhRHqUVLRyDv2H8mPXJSRyp8n8kSVEh7lxyOEUIhK5VAJtOu0JOJBSCsaN4x+WmZkPe7BonFSYaMcf2PHQpXMZuOEV2Mj4EQEmMkqBsIbiy/zN1ORFJOH0P13ILiE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725877108; c=relaxed/simple;
	bh=NgaG/YxcfDgP+cqDFX+bHoPG6o/uTAIikPhrqSwbitU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=H62MpKZktMemnOsx4n9m83g46aTjpSq+NQjYG9j/r2akN3g+3sSCvxvwz7ksRTFL8pK/JY3XZqRBjaZ991shFRL5zm656uEcka1hr87JHap8sAKGAiuOM/HdnZiIjjEtUU6IP9qe09APfSIFvPxkZlJHDJx/Nt263Le/lLzj1X8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SCjfofYs; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725877107; x=1757413107;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=NgaG/YxcfDgP+cqDFX+bHoPG6o/uTAIikPhrqSwbitU=;
  b=SCjfofYsX+TAQ7IlnO9dcIqk1ria93MAvqa8E0hD/PgLJz0qL3Z2BV+y
   r1Qv6bcvPGCaXRQ1z2R6sTUKLJjSk3g1DEeoi4Vn0z/eFl3fi3lIfxKjA
   U9MeXL9liYSrBzHYkj6ySGku6ngiDmJqJkgfr30we8t5DeT1mS9q/WBRh
   gGUQ9p4699fFytK8x3MvQMTwpKOAKDad3OhTJ/S5Gl4fuOE8Ozv/amBl8
   ize+m6zt3vlgQm7C97RlRJ4rApPwHHfEFo4DZcMRHLomix3LD8mdF9mN2
   xrGs32oxlK5Qoj9fykFBl9nl8M/7tx8EEEImHbc5q1izTCH8aveW0KaZz
   g==;
X-CSE-ConnectionGUID: YcFvloEcSFCXbUfUJwIl+Q==
X-CSE-MsgGUID: S+XXM23+QHWgMsVzQXARFg==
X-IronPort-AV: E=McAfee;i="6700,10204,11189"; a="35156756"
X-IronPort-AV: E=Sophos;i="6.10,214,1719903600"; 
   d="scan'208";a="35156756"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2024 03:18:26 -0700
X-CSE-ConnectionGUID: s4G18xcvTYixzFNXiuDTXA==
X-CSE-MsgGUID: BZtxZspYRGqlRwVCA/FD+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,214,1719903600"; 
   d="scan'208";a="67152787"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Sep 2024 03:18:25 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 9 Sep 2024 03:18:25 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 9 Sep 2024 03:18:25 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 9 Sep 2024 03:18:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xyg/06aZoC2Q3kUTRSPB+pn6TqXuQegNXJGP0Efa5bGrWuLQeuTobgO6ZsZqoplLqe8cM1H3UjDD90EU8GTXELZao9UNyECpVGllgrFv73ci5MS2YznQa/0717emuxpOmJtD1sD4pTzMn7fo2IymqusDU5Fsv7l508cDosDq+fYcYpFQllt+4Mm2GUCVYSRyOBn+BH/YNuf5YuKZ5KZlewh1625SOY7o1m7G9oD5Vipq5pwoIf4IpsmLJQYcS0WKpSuUECJC3F395yBgSC9JKS1QfvWfAcGYYlMBWSHf78Xf2dAPhrvOqdTHxZbl6MRuwqQiZ0/WF4jPOZFubrd+BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NgaG/YxcfDgP+cqDFX+bHoPG6o/uTAIikPhrqSwbitU=;
 b=S5rDKvYMDrKpxFEyaye9UZ5hINnUSVKNdr6johWoSn9s4Ly6maUiVA2VtD+w7S5L43UWxqNERpC4XVV112rVz35jk0j6YetfTMkjkHXwXBdVLfBIqTcm9FO9m1WdeXbUm7adX6Z21WCYQzu4nPWUds4kE8VkviPhBwqWKwE5oKzpPmVgVOZnUfHC0hgmLUv82Kw0XARm/z40kFQzP+9EM0EXehuO22ncGl+NYJLqURPYfYtRv711+5UpGbxpJ4XZEwQWolI+HThy6vW6X5p46wiiFMNO5N4SWVDuEM/f12CmpqAzdUPX6CJDQ87tQhJ3DDecbl9o9IO99bs1IE3rIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SN7PR11MB6798.namprd11.prod.outlook.com (2603:10b6:806:262::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.20; Mon, 9 Sep
 2024 10:18:17 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7918.024; Mon, 9 Sep 2024
 10:18:16 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "peterz@infradead.org"
	<peterz@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Williams, Dan J" <dan.j.williams@intel.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>
CC: "Gao, Chao" <chao.gao@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Hunter,
 Adrian" <adrian.hunter@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v3 6/8] x86/virt/tdx: Print TDX module basic information
Thread-Topic: [PATCH v3 6/8] x86/virt/tdx: Print TDX module basic information
Thread-Index: AQHa+E/zouLDTPip2ky1ZuLNIUnY5bJLbJmAgAPl7QA=
Date: Mon, 9 Sep 2024 10:18:16 +0000
Message-ID: <ecdd33a0a20fd71113d5883e43b447c4f162005f.camel@intel.com>
References: <cover.1724741926.git.kai.huang@intel.com>
	 <ab8349fe13ad04e6680e898614055fed29a2931b.1724741926.git.kai.huang@intel.com>
	 <66db864597fa_22a2294ca@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <66db864597fa_22a2294ca@dwillia2-xfh.jf.intel.com.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SN7PR11MB6798:EE_
x-ms-office365-filtering-correlation-id: ad521e76-8255-48ab-3d46-08dcd0b8b865
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?T3ZZallBSEtKSFhGOTNDSHpyeTJOOWtuOFR0cVBaK29yckl2RXlaRVFqTmg1?=
 =?utf-8?B?ZWxkZWRaeXVqeVpRUnRxbmhhS25EbXdlUkI2dUYwSXdaZlRNbDRsRTlRVFJR?=
 =?utf-8?B?cTJudVNkVTM3MGsrL0cyRVFkQjI5WStUbmJteWk0MlFsZi9DV2pKZVBQWkE2?=
 =?utf-8?B?SkxwY01tQVM5VFlQSEs0bFhFRE9nVmRzb1BzdUtMbTIrbXBBblEzVFF3bzc2?=
 =?utf-8?B?Mm4zUFU4UzZTS3RUYU9mWkFZK1lqcTM0OUJnY2dZVVM4SHc5U0x2L0xCMzda?=
 =?utf-8?B?VjZiMGJHTllKdzQ1eGRvb1hmOTVZY2xjUCtqbDRKMWNwZ0lXS24zc28zSmxU?=
 =?utf-8?B?d3drR3FvU0g5eWNQZ2JEM1VVa3V0MU5sL04yWWJLWnNSTmdNWjFVT3RFZEdo?=
 =?utf-8?B?aXE1S1NzQ3haZXlxSHc4bDNoZ1RLdGdaV0xYQi80dlNocFJ4Vzg3aFZtd0F2?=
 =?utf-8?B?ZUV2Zk5wS0U0S2FLeGRWem5Ddy93bFlsazR4V0FqcS9STWpMcUd5dXlpV04z?=
 =?utf-8?B?TG5pYmFLazV1ek94aUdkTkJtLzY0d2NObU1ScTFrY0FKRkQrZGFoLzljZ2Vk?=
 =?utf-8?B?OTdwQ3hHZE90aVVtK0ROR2RDRk1seExFWjJqcjZERHlBVWZUK2pneU9jYzhz?=
 =?utf-8?B?bDRBcEducnFxVFFNUFY3SFVBSWlWa2czTW5KeEJyRzBWV0krTWFjNy9SUkdQ?=
 =?utf-8?B?MjJlVmJEM3Nsc29tWjhmUXoyTnpDSEd4REtrZFErdGpFMnBhb3lFK20vK1VB?=
 =?utf-8?B?cGV0T2FWOUtiaE52bWhxazQyYW0xaGd4VEphcXMzMms4UVJyeU90S28zZitC?=
 =?utf-8?B?MUxYUWZMQmg5eUViWmlnN281OWNZWGM4TGZwWStpWWFoNTlxaUNsVVBKSjNm?=
 =?utf-8?B?L1dNNmgvU3lEU3BuK0xLcWlZUnFLYjh3ODF1UC96OHd1NEF6WjJYUllCNnNu?=
 =?utf-8?B?U3JTQzdScGhQNlJDbDRGU290WEFFOVdDZTJTRlUwdHJvR0NMbFJIVWJ6WXdv?=
 =?utf-8?B?aWVWdkwzMWF5aFdEL25KbHJmOXdDSWEwcTlTRGtjTnh5dDhRTlRtcDl0dWZu?=
 =?utf-8?B?cU1CaCtSOWluWDkyWHF2dVBMSGdRR0QwUHFoSXRJVFF0dlQ3a1pCQlhUMFhN?=
 =?utf-8?B?Z1g3bTc3SWV1MWYrNXVENndqVFdFYlNZVXBXSVhOT1NsakFrNGlDNlNjUzhx?=
 =?utf-8?B?Rlk0enltVG0yZWpLVE1nd1N2WkNHdUhkc0k4c3BXSEsrVTBDL0NkeUxUdDdj?=
 =?utf-8?B?NTAwTENyWE1sT0ZRcGJHamJpcXpyMmQ2ZHdSOWRHRXR1ZnA5eUhZOFQvVHZK?=
 =?utf-8?B?cG9DL1M5MDVPUzVNQjVRV3VqNDFMQjVwT0lxdkRFaEZhUXM0bWhHQVV0bFNR?=
 =?utf-8?B?T0VxVzlVQWNQQjhkYno3MTN3ekd4UEI4bnJjWG5aVXdNZGRoWTEzUDdZM2tz?=
 =?utf-8?B?a0dTelNOb080VEZKUU1sT1JxcGUwUHJ3dGdudGJJYUxaTGkxdlF2a0FEVWk5?=
 =?utf-8?B?NXkya0gxN0FhVzFhRGZtSzgvc1Rad3JjY0pXLzU2TUFQSWl1K1ZsNXNITzRa?=
 =?utf-8?B?M3RnbUNwcDBUeEZWRjkweENGcXNGUW9uWDRBR05Od3N3VmZWbUVPN0YvdmZn?=
 =?utf-8?B?UHA4WlJNSCtzUy9oeTVkL1NBRExweWRUbURaMHN1TCtjWnlXZk53QUV1dE1L?=
 =?utf-8?B?cWROcjFzanpCSk9KZHhYVExHM241R3MwS09QdklmWHlFL0pBSDZVMmk3dWdV?=
 =?utf-8?B?MzBwNGNZdFk4ZGdNeHIzL2Mxb3RTa3M4Z3J2WlRiRExQUVJQdC95dTdnTEtU?=
 =?utf-8?B?NTM4QW0yWkVoNnhYZWNNcmVlMUZwRE55Z1pkQ1RKRExKRHVPTVp0QitObFgw?=
 =?utf-8?B?ekhkRzVldmM4eTdvaG1kLzZsS05adHByMGhCSkJ1Skd0QmNtT2JGMy90RUVO?=
 =?utf-8?Q?1zVhRibWjGk=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cmE3a0hUcHoxQVlxMXN6aEllTm9hdCtHME9zbGI1MlNtMVRKeUFsZC9Pc1FP?=
 =?utf-8?B?eDR6UWptMTRwSjlXTFpRVjJsWk9WQVhGaG9nT25ndFYyYjRya0VsbWxpTTBU?=
 =?utf-8?B?R1p4dUc2Z0UweWwxQ2RGVW9JUHZiQUx1WEF6MTVWc2E4YVVKSkgwc2lUWE1x?=
 =?utf-8?B?ajhlWmFoWU5tTlJzQzVYRE52NGc4ak5Oc1FabHZPMUsyYlUxYXpvTkU1TWxO?=
 =?utf-8?B?MDNIZUpZNDZkQVVEa1dZcm5HQjJCb1Jva2VRWllBYWR0OHp3MHFZVGNiMUdq?=
 =?utf-8?B?V01pTWZhZUswZXNPSy8vcVMybXp2UGJXU3RqaTN5blpNeVdLRTg2aWtpaU5T?=
 =?utf-8?B?Nk9Yd2tYdmVkR2dvWHJBUEJSQ1M0TXRmM0VzSk5oQ3R0MVdUZ2dZQzQ4MjNz?=
 =?utf-8?B?V0dpR1V6WTRDbGFSTmFTVzhSOXhQUWdYU0hpRDZybGptVlgxbURXYUl5bzNp?=
 =?utf-8?B?SlphTElxVzQyMGcyeE9hTS9Rcmcxc3hiRDhXbFA3VCtDZlZYZVNNUURoTWZS?=
 =?utf-8?B?ZkhFLzVSTlQ4K093N256TTg3em9sbjRHTk45R2NDQ0Nhb1Z2TEg2dXZFM0ox?=
 =?utf-8?B?KytRb0lTa0pCRXlCUjUvWldSNUhuU2JPUnlIb0ZUVnBBdWtLbHFtMVUxYzdo?=
 =?utf-8?B?VkJLQ1hSZEVPLzdJb2w1MUhRRXBNT3BsVWx0OUlhM245M1BGVzd2Rkl0ZTVy?=
 =?utf-8?B?a2IwbUEyRWVtb29IRnNFRzRZZFpLQVJnOEdldUlLMEs1RmFOOWtBRFpydG8y?=
 =?utf-8?B?c1N4NVlmVEdGUjA2Mk45M3B5eStCa3lBa3pRTGtvVkduNDVwZCtUZGFXbVdj?=
 =?utf-8?B?VlBNNWtsUGJLKytNYzIxS0dEQ3Q4cnczTHVBQm9Ma2M0eWNRMGlCVzcvOERM?=
 =?utf-8?B?NVhMTWVJanArYkhEOEVMQ3ZjeUNlYmllbEVNdEVtaTZMRk40WlNLb08xblFV?=
 =?utf-8?B?S2E1a293OGp6ay81MFV4ZnBEZ3FuNHRxY3RlSy96QTJnNEtPdldzaDlvbVNo?=
 =?utf-8?B?MDJFRFBKeThnTURLS0Q4RlJrN3VJQ1lPcGJiWnlnQSszS21xS2pIZDNvT29T?=
 =?utf-8?B?R0FqL3dQWjErU3ltV0hibHR6b09FZkpkMkJvajM1VDJBSU9SVUJKUUw3QURY?=
 =?utf-8?B?VG0xSHBYOTdBSXdpaHVSaEh4dlp4RUMyS015YUg1OVRTWUg2Z0RlaWtYNURk?=
 =?utf-8?B?RnBWaDlCVldYQWZrd3pQekVhU0JNRFJhc1VReUJrQkRoUWtFNzJNMVZwL0t6?=
 =?utf-8?B?emNWQXFZdWdEMnUvdi8yQ20zWUl4Wm9VQUVqWnM4Q3JCWHhhK3ZtOHQ2U0NL?=
 =?utf-8?B?L0tOVXZ2M2ZHRU9Gc250VTA5Zm05OXRFNlNMdVkvYUJIRHJLLzZndzZneVZx?=
 =?utf-8?B?UjVxOEIyTHBpVzdobEpKcEJrZnhYbklJRHhzQzBtVHRnMDJXeE1Rd1NKeEwr?=
 =?utf-8?B?alpENGU4VkovQkV0and3V1M2dnpFelowMUVBUEY4bVkzYS9EVjFWd3NaVXRR?=
 =?utf-8?B?aisyQ2UrVVl2cEpsZmtqZk42QVFTTnZmb25vSzBRTW9UQ3R6eDczMVMyTWtW?=
 =?utf-8?B?K1B2V24xRm9zbUxFOTRwNXBMRlJJUmRGVTRhODlyZGZSUm4rbHRWb1ptdUxx?=
 =?utf-8?B?cjFoYjJQUXVRT3JCdmtwWEJPMzhGZ2RyNTFrQVNFa3NWM21sMjc4Zkp0ZTBh?=
 =?utf-8?B?YnV3elE2K2RlRWx6OW9kMHl2dVZpVjN3V0dHNkhSZlJCanJrNzYwR3VLemZH?=
 =?utf-8?B?MEJWWnRITDExNUcvcUtvb1Z4QXRSTld3UmtoNHZCR0xwMnBXcml5QjBsWG1m?=
 =?utf-8?B?U3JRcm1ud0cxZURYb2gxeUUxYlArMVcxTlMzS1cySi9JSDgwWm1Mc1hzWjhl?=
 =?utf-8?B?eDgvenI0WjY5QVlNcXpIVmJsUU5DVG1oMTYxQ1NITnVlWE9jV1gxZFFuOGV3?=
 =?utf-8?B?SUNDdXIzWFlLbzRFYnJlVVlaVUdKaHJDTTNDTys5ekJaNTRiMkxINTZqeWkx?=
 =?utf-8?B?NTU5ekRVc3dYdVcvNk01M1FUSVhpZnV6cEZ0OHAyeCt1b2pjalh6T0ZMWjJo?=
 =?utf-8?B?OVlQSm1GeDcwY2xoUHU4S2w4d1dvYlVsb2FldmxaL1RUNkRETFdMQ3M3QjMw?=
 =?utf-8?Q?Pos8IvHQcDLAGo5VV/MI16d+T?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <73FD002D61E843488E610E924CA66AAB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad521e76-8255-48ab-3d46-08dcd0b8b865
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2024 10:18:16.5848
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VnnTefqn2acIwrwgPXHwLK/rs+BR02UDx6AllOpZNzaYFq4kFQfQ9h28wYDDRdVVAJFK1+zbjUy4duQTntMOxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6798
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA5LTA2IGF0IDE1OjQ2IC0wNzAwLCBEYW4gV2lsbGlhbXMgd3JvdGU6DQo+
IEthaSBIdWFuZyB3cm90ZToNCj4gPiBDdXJyZW50bHkgdGhlIGtlcm5lbCBkb2Vzbid0IHByaW50
IGFueSBpbmZvcm1hdGlvbiByZWdhcmRpbmcgdGhlIFREWA0KPiA+IG1vZHVsZSBpdHNlbGYsIGUu
Zy4gbW9kdWxlIHZlcnNpb24uICBJbiBwcmFjdGljZSBzdWNoIGluZm9ybWF0aW9uIGlzDQo+ID4g
dXNlZnVsLCBlc3BlY2lhbGx5IHRvIHRoZSBkZXZlbG9wZXJzLg0KPiA+IA0KPiA+IEZvciBpbnN0
YW5jZSwgdGhlcmUgYXJlIGEgY291cGxlIG9mIHVzZSBjYXNlcyBmb3IgZHVtcGluZyBtb2R1bGUg
YmFzaWMNCj4gPiBpbmZvcm1hdGlvbjoNCj4gPiANCj4gPiAxKSBXaGVuIHNvbWV0aGluZyBnb2Vz
IHdyb25nIGFyb3VuZCB1c2luZyBURFgsIHRoZSBpbmZvcm1hdGlvbiBsaWtlIFREWA0KPiA+ICAg
IG1vZHVsZSB2ZXJzaW9uLCBzdXBwb3J0ZWQgZmVhdHVyZXMgZXRjIGNvdWxkIGJlIGhlbHBmdWwg
WzFdWzJdLg0KPiA+IA0KPiA+IDIpIEZvciBMaW51eCwgd2hlbiB0aGUgdXNlciB3YW50cyB0byB1
cGRhdGUgdGhlIFREWCBtb2R1bGUsIG9uZSBuZWVkcyB0bw0KPiA+ICAgIHJlcGxhY2UgdGhlIG9s
ZCBtb2R1bGUgaW4gYSBzcGVjaWZpYyBsb2NhdGlvbiBpbiB0aGUgRUZJIHBhcnRpdGlvbg0KPiA+
ICAgIHdpdGggdGhlIG5ldyBvbmUgc28gdGhhdCBhZnRlciByZWJvb3QgdGhlIEJJT1MgY2FuIGxv
YWQgaXQuICBIb3dldmVyLA0KPiA+ICAgIGFmdGVyIGtlcm5lbCBib290cywgY3VycmVudGx5IHRo
ZSB1c2VyIGhhcyBubyB3YXkgdG8gdmVyaWZ5IGl0IGlzDQo+ID4gICAgaW5kZWVkIHRoZSBuZXcg
bW9kdWxlIHRoYXQgZ2V0cyBsb2FkZWQgYW5kIGluaXRpYWxpemVkIChlLmcuLCBlcnJvcg0KPiA+
ICAgIGNvdWxkIGhhcHBlbiB3aGVuIHJlcGxhY2luZyB0aGUgb2xkIG1vZHVsZSkuICBXaXRoIHRo
ZSBtb2R1bGUgdmVyc2lvbg0KPiA+ICAgIGR1bXBlZCB0aGUgdXNlciBjYW4gdmVyaWZ5IHRoaXMg
ZWFzaWx5Lg0KPiANCj4gRm9yIHRoaXMgc3BlY2lmaWMgdXNlIGNhc2UgdGhlIGtlcm5lbCBsb2cg
aXMgbGVzcyB1c2VmdWwgdGhlbiBmaW5kaW5nDQo+IGEgcGxhY2UgdG8gcHV0IHRoaXMgaW4gc3lz
ZnMuIFRoaXMgZ2V0cyBiYWNrIHRvIGEgcHJvcG9zYWwgdG8gaGF2ZSBURFgNCj4gaW5zdGFudGlh
dGUgYSAidGR4X3RzbSIgZGV2aWNlIHdoaWNoIGFtb25nIG90aGVyIHRoaW5ncyBjb3VsZCBob3N0
IHRoaXMNCj4gdmVyc2lvbiBkYXRhLg0KPiANCj4gVGhlIGtlcm5lbCBsb2cgbWVzc2FnZSBpcyBv
aywgYnV0IHBhcnNpbmcgdGhlIGtlcm5lbCBsb2cgaXMgbm90DQo+IHN1ZmZpY2llbnQgZm9yIHRo
aXMgdXBkYXRlIHZhbGlkYXRpb24gZmxvdyBjb25jZXJuLg0KDQpBZ3JlZSB3ZSBldmVudHVhbGx5
IG5lZWQgL3N5c2ZzIGZpbGVzIGZvciBURFggbW9kdWxlIGluZm8gbGlrZSB0aGVzZS4gIEZvciBj
YXNlDQoyKSB0aGUgZGV2ZWxvcGVyIHdobyByZXF1ZXN0ZWQgdGhpcyB1c2UgY2FzZSB0byBtZSBq
dXN0IHdhbnRlZCB0byBzZWUgdGhlIG1vZHVsZQ0KdmVyc2lvbiBkdW1wIGluIHRoZSBrZXJuZWwg
bWVzc2FnZSBzbyB0aGF0IGhlIGNhbiB2ZXJpZnksIHNvIEkgdGhpbmsgdGhpcyBpcyBhdA0KbGVh
c3QgdXNlZnVsIGZvciBkZXZlbG9wZXJzLg0KDQpQZXJoYXBzIEkgY2FuIGp1c3QgdHJpbSB0aGUg
MikgdG8gYmVsb3c/DQoNCiAgVXNlciBtYXkgd2FudCB0byBxdWlja2x5IGtub3cgVERYIG1vZHVs
ZSB2ZXJzaW9uIHRvIHNlZSB3aGV0aGVyIHRoZcKgDQogIGxvYWRlZCBtb2R1bGUgaXMgdGhlIGV4
cGVjdGVkIG9uZS4NCg0KDQo+IA0KPiBbLi5dDQo+ID4gK3N0YXRpYyB2b2lkIHByaW50X2Jhc2lj
X3N5c19pbmZvKHN0cnVjdCB0ZHhfc3lzX2luZm8gKnN5c2luZm8pDQo+ID4gK3sNCj4gPiArCXN0
cnVjdCB0ZHhfc3lzX2luZm9fZmVhdHVyZXMgKmZlYXR1cmVzID0gJnN5c2luZm8tPmZlYXR1cmVz
Ow0KPiA+ICsJc3RydWN0IHRkeF9zeXNfaW5mb192ZXJzaW9uICp2ZXJzaW9uID0gJnN5c2luZm8t
PnZlcnNpb247DQo+ID4gKw0KPiA+ICsJLyoNCj4gPiArCSAqIFREWCBtb2R1bGUgdmVyc2lvbiBl
bmNvZGluZzoNCj4gPiArCSAqDQo+ID4gKwkgKiAgIDxtYWpvcj4uPG1pbm9yPi48dXBkYXRlPi48
aW50ZXJuYWw+LjxidWlsZF9udW0+DQo+ID4gKwkgKg0KPiA+ICsJICogV2hlbiBwcmludGVkIGFz
IHRleHQsIDxtYWpvcj4gYW5kIDxtaW5vcj4gYXJlIDEtZGlnaXQsDQo+ID4gKwkgKiA8dXBkYXRl
PiBhbmQgPGludGVybmFsPiBhcmUgMi1kaWdpdHMgYW5kIDxidWlsZF9udW0+DQo+ID4gKwkgKiBp
cyA0LWRpZ2l0cy4NCj4gPiArCSAqLw0KPiA+ICsJcHJfaW5mbygiSW5pdGlhbGl6aW5nIFREWCBt
b2R1bGU6ICV1LiV1LiUwMnUuJTAydS4lMDR1IChidWlsZF9kYXRlICV1KSwgVERYX0ZFQVRVUkVT
MCAweCVsbHhcbiIsDQo+ID4gKwkJCXZlcnNpb24tPm1ham9yLCB2ZXJzaW9uLT5taW5vciwJdmVy
c2lvbi0+dXBkYXRlLA0KPiA+ICsJCQl2ZXJzaW9uLT5pbnRlcm5hbCwgdmVyc2lvbi0+YnVpbGRf
bnVtLA0KPiA+ICsJCQl2ZXJzaW9uLT5idWlsZF9kYXRlLCBmZWF0dXJlcy0+dGR4X2ZlYXR1cmVz
MCk7DQo+IA0KPiBJIGRvIG5vdCBzZWUgdGhlIHZhbHVlIGluIGR1bXBpbmcgYSByYXcgZmVhdHVy
ZXMgdmFsdWUgaW4gdGhlIGxvZy4NCj4gRWl0aGVyIHBhcnNlIGl0IG9yIG9taXQgaXQuIEkgd291
bGQgbGVhdmUgaXQgZm9yIHRoZSB0ZHhfdHNtIGRldmljZSB0bw0KPiBlbWl0Lg0KDQpUaGUgcmF3
IGZlYXR1cmVzIHZhbHVlIGlzIG1haW5seSBmb3IgZGV2ZWxvcGVycy4gIFRoZXkgY2FuIGRlY29k
ZSB0aGUgdmFsdWUNCmJhc2VkIG9uIHRoZSBzcGVjLiAgSSB0aGluayBpdCB3aWxsIHN0aWxsIGJl
IHVzZWZ1bC4NCg0KQnV0IHN1cmUgSSBjYW4gcmVtb3ZlIGl0IGlmIHlvdSB3YW50LiAgV2l0aCB0
aGlzIEknbGwgYWxzbyBkZWZlciByZWFkaW5nIHRoZQ0KdGR4X2ZlYXR1cmVzMCB0byB0aGUgcGF0
Y2ggKCJ4ODYvdmlydC90ZHg6IERvbid0IGluaXRpYWxpemUgbW9kdWxlIHRoYXQgZG9lc24ndA0K
c3VwcG9ydCBOT19SQlBfTU9EIGZlYXR1cmUiKSwgYmVjYXVzZSBpZiB3ZSBkb24ndCBwcmludCBp
dCwgdGhlbiB3ZSBkb24ndCBuZWVkDQp0byByZWFkIGl0IGluIHRoaXMgcGF0Y2guDQoNCkkgdGhp
bmsgSSBjYW4gbW92ZSB0aGF0IHBhdGNoIGJlZm9yZSB0aGlzIHBhdGNoLCBzbyB0ZHhfZmVhdHVy
ZXMwIGlzIGFsd2F5cw0KaW50cm9kdWNlZCBpbiB0aGF0IHBhdGNoLiAgVGhlbiB3aGV0aGVyIHdl
IGRlY2lkZSB0byBwcmludCB0ZHhfZmVhdHVyZXMwIGluIHRoaXMNCnBhdGNoIGRvZXNuJ3QgaW1w
YWN0IHRoYXQgcGF0Y2guDQoNCg0KDQo=

