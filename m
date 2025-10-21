Return-Path: <kvm+bounces-60582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B1898BF41D8
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 02:10:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CEC003A85B7
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 00:10:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDBB8185B48;
	Tue, 21 Oct 2025 00:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YXUGICkp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883B02A1C7;
	Tue, 21 Oct 2025 00:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761005422; cv=fail; b=nsif2jzsbvxWdtZrK3nEhRW+0N8kxKE6pcb/l4nRRIDUcdcNuG+3YNvf4SA+6xfINNb4KJCgvVmdoOfEHTYRCTYXpgVKBVe7KVWV0y2pMPmT8rubwlEuVH188Q1GRQoe4NF4z/KLlKNhq08bLLIFgIwJAH29mUmve6WjSqQeIaw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761005422; c=relaxed/simple;
	bh=9PTWGiCK1olvk3ZYVMOm/Ng4+tlM7vm6nufwQRAeqCM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TR7hXMLvywkdxTqhNUzSYhgcp7/5smHNR7CbBESvHux9YW/AX9lIuKOyu/zngKmwYSAmdZlMKT1cDp0RY46DRZaqwi8UL2DFEh6r5XSqi312BcripwjNCJqscYfaauXvftNZtqSr/kDtjI6bO1VYHbgQvx/42Zc5388nl1YQdjA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YXUGICkp; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761005420; x=1792541420;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=9PTWGiCK1olvk3ZYVMOm/Ng4+tlM7vm6nufwQRAeqCM=;
  b=YXUGICkpNw8ycdjHN591hxqiwIe0ZpwR6jtVvUNzfCzHmu29qUBM1p85
   +Z9KXCH1lr7Boqc/zhsUhjEKvYWxygAcNUo3zdMmBD/e6s5xhycxE6mS5
   2rgXu5dDgthfhWhQdNTOAM0oCmlFXwXjrHeWAvZoqflzmvGok6QwaO7ns
   obLrHwUDz0QhmNY8JlV8dP5E6xv0hMYRdohZsFM68M6uQY8mJ/yjEsq5e
   nMkcp3mzCQDke8xolj1CGP79HwBITkm21fhZHNMRzTLItzOXv3q3IjahJ
   ahi9ix1wSA2ICvSBdok5fK3nQmZW5MMigMME4exCXuIS6f/0Ds/Fp97/S
   A==;
X-CSE-ConnectionGUID: 3BPamqKwQh6oLNkZibJdkQ==
X-CSE-MsgGUID: w1pB3LhBTTGKoPhwtm/OWg==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63169267"
X-IronPort-AV: E=Sophos;i="6.19,243,1754982000"; 
   d="scan'208";a="63169267"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2025 17:10:19 -0700
X-CSE-ConnectionGUID: Kb89+j8oRCS73HmnT3sVkg==
X-CSE-MsgGUID: lp3SqmtLTVaL3idC/H/WDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,243,1754982000"; 
   d="scan'208";a="183864007"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Oct 2025 17:10:19 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 20 Oct 2025 17:10:18 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 20 Oct 2025 17:10:18 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.11) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 20 Oct 2025 17:10:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lQSTuVN2+DmxVMfH0CwVvKqzLfc/IDW0dp7JrL+8fOYMgG1B014rYBNULqFutVVJx2jWaCStxMcv146hRWx/KEymkcN5F5ZAR3r9jA/iE3LXvHtT4nPBm9e2jX+HTSWtPrZMBgyO4giAj9z3GpGiwqTGNR/zELB6RR5uX+HSYziUpMF5RNbcoKEVSUOQ8BXKB9plcpjF0/5ftjifmx1HF0V6R6t7EXlyosVUP9juUwQTvl+/hCp2qyI3Y3Fe3VvZGIuwxLISoSuW4u9ZsfV6coiEy4jQo+7pn4b77EeO/OAkHD4QBn9BA1BfPmX2Kk9jjd51PgRK6HnGRCJykn7DVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9PTWGiCK1olvk3ZYVMOm/Ng4+tlM7vm6nufwQRAeqCM=;
 b=LQXwgSMEIAFzhXxGo+CnfZLacVj7yWZky1OOgiFjBkOHs7Py+FmVVjdN3hp/98l3fsJ/lIIARwsvGYHH00V2KYUrjhZMUM6goFLba2SuzwO6i9zHa2WvyoUnX0CzpUR+aPK+0mIbqnXGnqIHNzYdJGGvxxDpKFZJlgM8F2rRkppAoXzMrHCpVLIuA2QbMo5Ck2AOvCsaTlsGgegQdc+dB3nY0HsSz6tEbpVP4p7gdZghhVhDNeA1rGX2Tb+ZQkcTeQ7rsX3hy5W3nzdXqMCZe/cqwvzp4suoU9dtpaYTHx77IUz/1W5UHeXRdIW+uKog//UNqHqX0eLkdCnC2xqv7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS7PR11MB7950.namprd11.prod.outlook.com (2603:10b6:8:e0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Tue, 21 Oct
 2025 00:10:15 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.9228.016; Tue, 21 Oct 2025
 00:10:15 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "chenhuacai@kernel.org" <chenhuacai@kernel.org>, "frankja@linux.ibm.com"
	<frankja@linux.ibm.com>, "maz@kernel.org" <maz@kernel.org>,
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "pjw@kernel.org"
	<pjw@kernel.org>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
	"kas@kernel.org" <kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"maobibo@loongson.cn" <maobibo@loongson.cn>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "maddy@linux.ibm.com" <maddy@linux.ibm.com>,
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "imbrenda@linux.ibm.com"
	<imbrenda@linux.ibm.com>, "zhaotianrui@loongson.cn"
	<zhaotianrui@loongson.cn>, "anup@brainfault.org" <anup@brainfault.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Zhao, Yan
 Y" <yan.y.zhao@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Weiny, Ira"
	<ira.weiny@intel.com>, "loongarch@lists.linux.dev"
	<loongarch@lists.linux.dev>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"Annapurve, Vishal" <vannapurve@google.com>, "kvm-riscv@lists.infradead.org"
	<kvm-riscv@lists.infradead.org>, "linuxppc-dev@lists.ozlabs.org"
	<linuxppc-dev@lists.ozlabs.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-mips@vger.kernel.org"
	<linux-mips@vger.kernel.org>, "linux-riscv@lists.infradead.org"
	<linux-riscv@lists.infradead.org>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 04/25] KVM: x86/mmu: Add dedicated API to map
 guest_memfd pfn into TDP MMU
Thread-Topic: [PATCH v3 04/25] KVM: x86/mmu: Add dedicated API to map
 guest_memfd pfn into TDP MMU
Thread-Index: AQHcPv2etUwqY6GvG0e+0v2u/0T4krTLwCcA
Date: Tue, 21 Oct 2025 00:10:14 +0000
Message-ID: <d53248824d03e7dc1dd6facb67a0aab272704875.camel@intel.com>
References: <20251017003244.186495-1-seanjc@google.com>
	 <20251017003244.186495-5-seanjc@google.com>
In-Reply-To: <20251017003244.186495-5-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS7PR11MB7950:EE_
x-ms-office365-filtering-correlation-id: 206582a0-bf42-40dd-6722-08de103635cd
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|921020|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?cks2VHFnUnNUZUlpZlRwWWRpYm9wMGdxMmY5THJVYlJUMnZEWGFiZFRyUDdx?=
 =?utf-8?B?T0RqZTNVY05vemJDTmp6SUhjZUlZdUtjeHdNY2lmczB1RGJibG5hVmVQbGVF?=
 =?utf-8?B?Sy9ZMjJ0VklseWRUUnAyNmlTc2JHeEs2OSs0elNFTDhuWmhBejB6cTR3WFdr?=
 =?utf-8?B?cGFpbTJJcG1tY1RCOUZ0ZUpkR0U5RHlnQ0dVNWF2NitmZCtNVU00akVwUzN0?=
 =?utf-8?B?TkpRUUl0RE9VWGt0eTZhUWx6emVwYlAyMTN5bHJBcW9yZWNsQW51L2hia3BG?=
 =?utf-8?B?VlNDRndxZEVuWXhUMVhzSWxmUW1lK2tGd01tOVlIWEtpeW1EcEE4d2FVNjVw?=
 =?utf-8?B?NHBYTzFjaFRvUURLaFRiRUJMWGc1Rlg3U3pudjViMHRtRTl2SFFmU3pTdzNW?=
 =?utf-8?B?NTQ1UjlGQ1ZGTUpwMDJqdTZ1aWR1VDU3TVh2S2k2ODJpaHkxT3NPSDd6N2R3?=
 =?utf-8?B?clcwZ1VyT0Q5RmNJNXhWeGhYVjdpSFp4UldzeTBSUlVSaXlLNEFsaU9GUU9o?=
 =?utf-8?B?bk5oL2paR0EreSs0c2lmZzJZTFExOTdEdDR5ZHlkMXArcjNkTUozRjY0dUYr?=
 =?utf-8?B?MzFPUFRqMnFtM0RVVk9xR2ZaWTlNTHBBNTREWUpKR1J1ZzdlMTAyaWtNVUIr?=
 =?utf-8?B?OVFhZndFaDFUT011bVFrMks4N0oyL3JLV2ZxU0Q5b1BBSGRPY2RnUzNBMU9R?=
 =?utf-8?B?NlBaWXBxelhZVkZWNHJodk9pclp5ZVVXQnYycU5BNEFHbExTVDVTaDVFQXVj?=
 =?utf-8?B?N3Jrb3BGVUlNQ0ZXUkh2NHNocnFrZVMxdzNPbDVBaFJoTG9MajN0ejBJdmMw?=
 =?utf-8?B?dlpRejlKVmJWdzVJZGZXQ1VZRWN1VnEzbjN3ekZkYU92SkxHd0RCc3JyODhi?=
 =?utf-8?B?UmE3MHEvUHVkS2NkU3Nrdnl0SVRCem1raEtCQWsremZUcGJtSlFudHNUODhj?=
 =?utf-8?B?bFB1b0NxRE5UT2dvVCtzVGJSR3NOQ2lkMCtoZ0NlWWdXTklaK3VERUVCZERF?=
 =?utf-8?B?QmNtbWtSbXArVi83OEc3aWtmbVY0V3VlZmxVKzBWRjVYOEVZVEl0MTdWTVd0?=
 =?utf-8?B?MUpaV00zV0dZTnZNQklpQXJMUUl2cWtqR2R4RjhhdWs3U1lwRkQ0Qyt0UHp4?=
 =?utf-8?B?SHVTN1BOQ3lPbGV3a2M0dW5Fc2lsbHUrbytkR1FCUFVLM3ZubmtwUVVrUTRE?=
 =?utf-8?B?d2VXeWl2Z3VDZ3RmaTl5dTRvV3ZLTDdna0NqcWV5d3RISXJJMlZPNnZLR2pv?=
 =?utf-8?B?eXZYMHlIZHlsOTdoWHBkVkgwcTlhQ3pjKzJENXZGWDJnTmI4akNmVVhWb1hI?=
 =?utf-8?B?djhQSTdUMFRsR1FPeitZd2V5a3VYYVZDWGFBN3BOdlhsSEtqSFRIQ0ZqbThl?=
 =?utf-8?B?QndBSDFaSXRyNXV2ZS9WekVXbUdtOXNCQ3YySWllLzRnVURCV2VoekpOTE1D?=
 =?utf-8?B?SjVkRkZ1dm9ndUZhUFNYZUkxOFc5TEFhcnZrVVRVYkZLclRrZEhJZXhLU3Nw?=
 =?utf-8?B?SU9WRkcrdnlrakJvWHdJK3BCRnVHajZaTlZGbEFES2lSbmZsNFFSTUJuYUFX?=
 =?utf-8?B?dEdDak5PVU0rRGpsc3JBaitWb2RzMVZtdkhpUjFzN0lNT0ZQMyszckNPbDBm?=
 =?utf-8?B?ZjZGK2ZQY2dURlhoWWJ2RWRoTUQ1VUZid3Frd21rWGpmZ2RuRGVoWTluY3Z5?=
 =?utf-8?B?NFI2VHJjbmU2eGNKVHdRd25MaGs1aDZlVm5kR3lxN0NHZTFIcGswVHJWNDZr?=
 =?utf-8?B?YXJUYys2bkQrZ0FPNWhBT2RNcytBN1ZGRFlxcXNtOUU5NVNSRStBbGFmdVdP?=
 =?utf-8?B?a3E1bDdDdEFITFVMKzRqMWVCRnJHdUgxVzNKc1cwclZ3OFFOcmdpeFQrQ1dQ?=
 =?utf-8?B?WUVPbG9rc0NwZ1V6ZUVWaXVEQWJmNTAvYzZPdExwa0ZVS2o5Z3ZYbDBKd01V?=
 =?utf-8?B?VUJTOVdlZ1EvUFlWRmpXajFtKzk3NXdLQnlKU00rWnA1MEp0blRSYm5pUHIz?=
 =?utf-8?B?SjMxbEgwdlJkZ0MzSW45RTN6TnMyY2lZdHZDQlN1cDNCblNQTmZuWjBDRWhX?=
 =?utf-8?B?K3ZEQ25GUzhVcUJRWitqc0Fpa1lPWFFURit2Zz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R29lMEd5Y0xidlZCT2x5ZzdGdVF3WHdLVEVDUzJHZXlFMWpBUE44a1JrM2Fa?=
 =?utf-8?B?UVROUEhkMjErZzFZb2pRZFI5dUFERk51ZlNmNkY0TElWWFNwazczS2RNaEYx?=
 =?utf-8?B?VHg2ZjVzMGZqUDlSQ3o1c3J4WjUzYmRGdWU3TUVia3l1RGpmTGxsdmVvNGRU?=
 =?utf-8?B?YkZjUU5XdUNJdy9zSGhZbEJScUh0dit5VDBKNEU1U0UvQWl1Qll4dWFQdGp0?=
 =?utf-8?B?R2UycmVaZjNZMmMyMlFSVDVTa1hBTE5kZ2RxYzcySHQrOGhBMlNad0d5NlpI?=
 =?utf-8?B?YmlrSk0rVUcrYlNvV25TSDBzUUR5N2JXRUt0L25md2daYmtPcTNzVWtsYXJl?=
 =?utf-8?B?K0diNjREd1VwT0trcVZyUHBTNFR4VmZXUlJ1aTZ4VUcvSkVmTWJNbmFvOWxa?=
 =?utf-8?B?SW5HdSsxQkdKcmFMVEloZU1rK1ErbTIzQzBadG02OGo2c3pNUXpnS0wyM1pI?=
 =?utf-8?B?WlNJR2JacllsNlcyUWQ5clcwWUZyZ29WZjBTRHMwNFg3KzVFb2pPNitQUUs2?=
 =?utf-8?B?QzJKSUNkbFhYVDJpT0J3bzNPb0JQRlpTSkt1eTdzaGJjOG04T1IvYmNmbDM0?=
 =?utf-8?B?UDk3cEZuTjBGYkVya05tZURNQmMyR1dTTDR3Q1pocFl1NzU5VTl0MnYzRXlG?=
 =?utf-8?B?b2l5TWhzZUIyYTZSNzd5QTZVRWpzaGRTMWY5Y3VLcnptNTc3bXpyR1hpVkNP?=
 =?utf-8?B?YjExVzdtSzgrWFNaNXZEeHAxUGFtVytWVUNxb1Q4d2lBNmJoZlZQNW9EaGl6?=
 =?utf-8?B?V2V0UmFmR243NmlUL2E1VXhodzFDKzdFTkFkYmR4NEFDelZPTDREdEFvMlZm?=
 =?utf-8?B?Y3R0Qlc1eFlGcEpML2JXWk1LZ3ZaR0p5Ylk0Rk1xRzZvYmR4aXRSTkpoNmJQ?=
 =?utf-8?B?VjdweDRMSjVZUFMxY3QvaGRmaDhaZEJWZU9UMkIyOC85Ly93eTd6NkNnNnRi?=
 =?utf-8?B?REczV25ySk1UOFFxZmlNQ1IranB2SzhSMmpTZ1lSVEhIWkxoSzVKbVV3THEz?=
 =?utf-8?B?UFNwZUNXRXd3eHl2QU9tUDlTd0hMWTZoQ2JDWTVWSnRNeUg2bE9BdDR2M2JC?=
 =?utf-8?B?VW90V2NEaHg0RmQ4alIrZndhNWxWQ3d6S2dvK3J5b2JMb1k4dE5kdnZ4NWtX?=
 =?utf-8?B?NmhYc2xBcDZxNjF0S3Y5WjlkVFMrQVZGbzZDOFdNSDhjLzhpMjhodE5obWZD?=
 =?utf-8?B?bEN1SEc3ZWR6U1NaWXJwV2VaaWNOdHlvNXdZbjQ0M25DZnNGbVZoc3RMVENo?=
 =?utf-8?B?aTlFMElFYzF5Mmk2SzI3OFFJOUlkdUNPZkFEZGl1OWczMEtUcG5UaUxtdUdu?=
 =?utf-8?B?ZFlmbkZ5TXNRY1hKQXBhaGJ3Ym9OTGw0N1RsZmloNnpxTEV5Ry93YzlOWGtN?=
 =?utf-8?B?aW1JWHR0L3BlNTFGbE0rcCtOUFMvKy91K0wvWEI3R2JCckJsK3JpZUNLUVR6?=
 =?utf-8?B?U09BS3NyZkR4ZDYvSVFtVG5IamdUVFFaVmVHdHhiZ0QvSlg0WGN0dWdITHVj?=
 =?utf-8?B?T1dsRHJHWU9hVkJSc3RnL0FZSWtJZUY4RXJUR1JabS9zaWgxN0hFNlNrOUJP?=
 =?utf-8?B?WXdobGVraHlQUkFyQnZjQkxEdXcyRkh3M21RQStkQVhwbXBnSExkNUdCOVRv?=
 =?utf-8?B?OE45anNtQXVEeGpWTEh4VXdJbkdoZ3d5aVhTMnZvcjlFV0hvYmovZ3hyZUxW?=
 =?utf-8?B?YzhNOU5ZWWpDck5zSmg4VlFIa0N6UjRkZHpqY0lSa2NBRmQyQ1dVUGRWVVlF?=
 =?utf-8?B?aE05VDNNVU1CV1RibWJEbktGWGNnd2tEbHpBdkFTOGdyQzZNY1RNQnU2MlNZ?=
 =?utf-8?B?MnNLS0dIc0VveEZsUWhYamFhM2VHME5zbkpiM0txeE4rRlhQcjlBc3B4SHFN?=
 =?utf-8?B?M2J5N0lUeE82dk0wN29PYytqSlBTdGFTaElWZE5SZ3lMQlJlaXRveVZuRzND?=
 =?utf-8?B?SVNpWnFyUUJMZk82cGRVY1NRSllkYzBLb3dTL1cxUStXVEk4cFMzaUJJMEth?=
 =?utf-8?B?bEgxYldZY0x0K2loSGZyMERjUE1nMEF1cXpLaDcwSnJkdDZ6QjZUNy9NbnB4?=
 =?utf-8?B?VE1sWVdsNm5pc0pRRWFVVUNnRWoyMVFIb2hUSHpMdlQ4K1RrbUx2UnprbUoy?=
 =?utf-8?B?MkMvcmwrcE5XaVZ1aCtVdXRzVVpUVndYUEdnWTdzSVNYaWVRcmJiMEptRE42?=
 =?utf-8?B?Y3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E7BA1F734F60FA4C903C599A3F835EF7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 206582a0-bf42-40dd-6722-08de103635cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2025 00:10:14.9835
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SUDBCL4eyauyJve9w0MGkT7eYZJ5AZuiKw3QzP12sOKWypjhxzvXiSwbhktv49MeF1SaDM6l+ey//+atJK9sSTAxZl9U00v5tMfDLEdRqMY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7950
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTEwLTE2IGF0IDE3OjMyIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBBZGQgYW5kIHVzZSBhIG5ldyBBUEkgZm9yIG1hcHBpbmcgYSBwcml2YXRlIHBmbiBm
cm9tIGd1ZXN0X21lbWZkIGludG8gdGhlDQo+IFREUCBNTVUgZnJvbSBURFgncyBwb3N0LXBvcHVs
YXRlIGhvb2sgaW5zdGVhZCBvZiBwYXJ0aWFsbHkgb3Blbi1jb2RpbmcgdGhlDQo+IGZ1bmN0aW9u
YWxpdHkgaW50byB0aGUgVERYIGNvZGUuwqAgU2hhcmluZyBjb2RlIHdpdGggdGhlIHByZS1mYXVs
dCBwYXRoDQo+IHNvdW5kZWQgZ29vZCBvbiBwYXBlciwgYnV0IGl0J3MgZmF0YWxseSBmbGF3ZWQg
YXMgc2ltdWxhdGluZyBhIGZhdWx0IGxvc2VzDQo+IHRoZSBwZm4sIGFuZCBjYWxsaW5nIGJhY2sg
aW50byBnbWVtIHRvIHJlLXJldHJpZXZlIHRoZSBwZm4gY3JlYXRlcyBsb2NraW5nDQo+IHByb2Js
ZW1zLCBlLmcuIGt2bV9nbWVtX3BvcHVsYXRlKCkgYWxyZWFkeSBob2xkcyB0aGUgZ21lbSBpbnZh
bGlkYXRpb24NCj4gbG9jay4NCj4gDQo+IFByb3ZpZGluZyBhIGRlZGljYXRlZCBBUEkgd2lsbCBh
bHNvIHJlbW92aW5nIHNldmVyYWwgTU1VIGV4cG9ydHMgdGhhdA0KPiBpZGVhbGx5IHdvdWxkIG5v
dCBiZSBleHBvc2VkIG91dHNpZGUgb2YgdGhlIE1NVSwgbGV0IGFsb25lIHRvIHZlbmRvciBjb2Rl
Lg0KPiBPbiB0aGF0IHRvcGljLCBvcHBvcnR1bmlzdGljYWxseSBkcm9wIHRoZSBrdm1fbW11X2xv
YWQoKSBleHBvcnQuwqAgTGVhdmUNCj4ga3ZtX3RkcF9tbXVfZ3BhX2lzX21hcHBlZCgpIGFsb25l
IGZvciBub3c7IHRoZSBlbnRpcmUgY29tbWl0IHRoYXQgYWRkZWQNCj4ga3ZtX3RkcF9tbXVfZ3Bh
X2lzX21hcHBlZCgpIHdpbGwgYmUgcmVtb3ZlZCBpbiB0aGUgbmVhciBmdXR1cmUuDQo+IA0KPiBD
YzogTWljaGFlbCBSb3RoIDxtaWNoYWVsLnJvdGhAYW1kLmNvbT4NCj4gQ2M6IFlhbiBaaGFvIDx5
YW4ueS56aGFvQGludGVsLmNvbT4NCj4gQ2M6IElyYSBXZWlueSA8aXJhLndlaW55QGludGVsLmNv
bT4NCj4gQ2M6IFZpc2hhbCBBbm5hcHVydmUgPHZhbm5hcHVydmVAZ29vZ2xlLmNvbT4NCj4gQ2M6
IFJpY2sgRWRnZWNvbWJlIDxyaWNrLnAuZWRnZWNvbWJlQGludGVsLmNvbT4NCj4gTGluazogaHR0
cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzIwMjUwNzA5MjMyMTAzLnp3bXVmb2NkM2w3c3FrN3lA
YW1kLmNvbQ0KPiBTaWduZWQtb2ZmLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29v
Z2xlLmNvbT4NCg0KUmV2aWV3ZWQtYnk6IFJpY2sgRWRnZWNvbWJlIDxyaWNrLnAuZWRnZWNvbWJl
QGludGVsLmNvbT4NCg==

