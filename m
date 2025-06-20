Return-Path: <kvm+bounces-50144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A84DAE2197
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 19:52:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C48DD1C25BC0
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 17:50:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCE202EA74B;
	Fri, 20 Jun 2025 17:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Gh5bFFz9"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E9932E2657;
	Fri, 20 Jun 2025 17:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750441659; cv=fail; b=CMqOMEWdhlXujpJCtE3S9eLPmPhNztTpV4tNP3am3Fkjx1VOP8yykFXJq2okYkO11kDZ+3cUd3IGB+OtGohch8D9SVbBvUFckmMbqHK4dgRp3ljdY7XHfPvCyZyUZH1O+XZYR8HU1Q6PoTekqbkcSuSEvCmsdbgLh36Nm6aDqGs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750441659; c=relaxed/simple;
	bh=Xc9KAkJoOeJ8EKPNdYK4K9yxC51/0LnLKJ5c+ilRnKQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jjpXmg4QS8NMS+1X+gIA/j/iKf0Rv/E/V8kfqyJjP+AeD7gxNt9bEtrqRPPGl6Ek0LANRKcZynS8z1OQx825IfyXjLa0Xotufgq5ocu44ZKLMfEDYeRM3OQRmv3M8pGtr25ibRwd2YcfWLGao3VneYcWi6n6buCmerRbt4NHqS4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Gh5bFFz9; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750441657; x=1781977657;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Xc9KAkJoOeJ8EKPNdYK4K9yxC51/0LnLKJ5c+ilRnKQ=;
  b=Gh5bFFz9UGA8kbR0qUOiPZrFLZ3H4b+b2ya/8Zdsk+QkM7DdzD++VQ0R
   9AZPYpN9oDNEPvKmlFot3zv2C7d98Xd6P8wJg5f8xR7bQV5rrYyPJhKQj
   1My0wsR4x5kPtF51PcBpKFqwLe0UTa04AkZ5uZO6qRyn1djL8qwIu52BR
   Divk0CqKzh25XYg0tVHduQ+PRFqQSOA/cWMAstC0cBJq373+oEyfjXp+L
   8aIfxgHQV+RWsfcMyRrvkHGZyTgDoQ0UYsiI2gKST67k89UPU6tIxYd/i
   MdEYpQANU5LYUfQhHFodMyVChscru9T5mnjTWg7JaUFGk2uDdiLPDMov7
   A==;
X-CSE-ConnectionGUID: sCG8OHUESPSJqsYKVG7yhA==
X-CSE-MsgGUID: fnBiC5DxRZO0d3WGpyozIg==
X-IronPort-AV: E=McAfee;i="6800,10657,11469"; a="63320953"
X-IronPort-AV: E=Sophos;i="6.16,252,1744095600"; 
   d="scan'208";a="63320953"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2025 10:47:35 -0700
X-CSE-ConnectionGUID: qN2R6yWtSsGMB3iJxBURXA==
X-CSE-MsgGUID: iXAkfFsySNmIXM3knyOjzg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,252,1744095600"; 
   d="scan'208";a="155274148"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2025 10:47:35 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 20 Jun 2025 10:47:34 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Fri, 20 Jun 2025 10:47:34 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (40.107.96.87) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Fri, 20 Jun 2025 10:47:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r4VkxL6Jxj8fs9svHb0MZOVXYti8aGhimelsEHbZCrvuSYaU6/t5lw5KRjUOlw1Hr44YwsUx5xJuntp5gZ0hUx6BfBZ+PbdfpgwzXuJPsQwm1gQde8kZVHc/Tb8UNvUuqPr9G8kCIUt/oHrXTfKFiqUUWs/uK3begK1/sJ5BKbLesBnslN+oeFdhxLoxSk4QaSwTUyakBe5Lm2lJF/7n0/tK6ts7MqPe5524HejJ5MOdk9wGZzduxEVtkuzHWHtmEx8GZm8i3Se1PKNSuQ/Tm9ZKVzS3QHraFj0quV6hYVDKRSTNBTGpGjm6N+IUo06/QFhgEz1iNdD/iwIrR+AiDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xc9KAkJoOeJ8EKPNdYK4K9yxC51/0LnLKJ5c+ilRnKQ=;
 b=cUB1KoEqKesdiXtKPmNCkCe1OEs64HoC4b7mGx5nNWGOdML41M1dDtgxTXPr+PvUjhCkA9asNCh+8M1TsuyQTbsxvvfp7p3GX6yklkWiuK1R55KDZ6TIptE1D9XJLE2u7uCxaw57nk5AhgU456ANq9fZXljYXQ3IaUx3Z5gOxqdZve751tPO7auN0IPhEsVqKlQcr/yjq3F94wtXOdOD0Tj0cgF/vl1fQaTetXSBLvXlcUgYy/dAXDqoKoiQTO1AMV5PXro5XpXvpVmAkkraL45KwegH5UJbtTkjoPkQwiyCmhg0c79LZrTfUQmdRl7I0nsYEwl8uFfyUXzniAJtNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CYYPR11MB8330.namprd11.prod.outlook.com (2603:10b6:930:b8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.20; Fri, 20 Jun
 2025 17:47:03 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8835.027; Fri, 20 Jun 2025
 17:47:02 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
CC: "mikko.ylinen@linux.intel.com" <mikko.ylinen@linux.intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>,
	"Yao, Jiewen" <jiewen.yao@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Lindgren, Tony" <tony.lindgren@intel.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Shutemov, Kirill"
	<kirill.shutemov@intel.com>
Subject: Re: [PATCH v2 0/3] TDX attestation support and GHCI fixup
Thread-Topic: [PATCH v2 0/3] TDX attestation support and GHCI fixup
Thread-Index: AQHb4URRJBiJIKCzU0ewimtplhoU/bQLQ0gAgACw3ACAAAydgIAATPSAgAAGaYA=
Date: Fri, 20 Jun 2025 17:47:02 +0000
Message-ID: <e6fedf41180a98068c0b410b628f14cb85cad93f.camel@intel.com>
References: <20250619180159.187358-1-pbonzini@redhat.com>
	 <3133d5e9-18d3-499a-a24d-170be7fb8357@intel.com>
	 <CABgObfaN=tcx=_38HnnPfE0_a+jRdk_UPdZT6rVgCTSNLEuLUw@mail.gmail.com>
	 <b003b2c8-66fc-4600-9873-aa5201415b94@intel.com>
	 <CABgObfadU2_XLM8yGQrx9rDswfW3Dby10_nxzTBUdYGASQuOaw@mail.gmail.com>
In-Reply-To: <CABgObfadU2_XLM8yGQrx9rDswfW3Dby10_nxzTBUdYGASQuOaw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CYYPR11MB8330:EE_
x-ms-office365-filtering-correlation-id: 71df22f0-e143-48c2-5ed0-08ddb0227704
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bjdPSjBQM1VKM0VkUFprQUwzM3czdER5dTRxTXgwN0wzV24veUplekd2aEI4?=
 =?utf-8?B?d09XckZ5V0NEWXNmUTVMVm8rK3NHK1RjZmhYeEVHZHFvc3dXcWtsdW1MaFVG?=
 =?utf-8?B?UDUyQ0lWdDhZblQrZmgvd3JNZXdEd2o5R2d5WlIxdHA1bkZRSFdjRXVsa3p1?=
 =?utf-8?B?SkV5djY1Nm5wQW56RTBsamJYSnFkcHo3MWRXWDQycFJsS3pySVZ0ekRUNTAz?=
 =?utf-8?B?bjFvd2Fwd1V4cjlBcC9kWWYvaSt2d05nRmhNTktuWGU0REJVM1VUQ2lYWERp?=
 =?utf-8?B?VkV4RThVbEYwbkFGNUp2WEo2N3JyN0hHU0ZiSm1CbFRobVBDZjFzeVBUaE9F?=
 =?utf-8?B?anJJcktlN0ZFcEV2c0g4S2lDdFFnZ2FNZjhkK3lINnVoUHlaYnJZUzJlbk9D?=
 =?utf-8?B?R3hpNUFYbHZUVHhidHR0Y3VwVjFGUlJLdHd3cmE4NHJGZjBYU1ZGSVE5MTVJ?=
 =?utf-8?B?S2szQjRESzBPUytIVUJ2SEtjYU1iWHMzelBPR29XUjNlN3FSOEx3R0FtRTZP?=
 =?utf-8?B?NnpZQWNIU3hyZXhScVZtUy9iQTJsTXNCNTBoci9UM2dUTmhrK2dJbGFGbFpZ?=
 =?utf-8?B?ZFhWT29IT1RhUXJqM2I1UmpHTFg0WlJBa1hYTituYjFuM2pwUjlGNU9mc2E4?=
 =?utf-8?B?YXc2NVdrUFVMTWxJUzZUT3MvZ2Q5VzQwZGJmdG8vSVN3V2hBbUVnZit0QzNV?=
 =?utf-8?B?dEdpY0NaVkhxNGkxL1RxcjFTQkFlUHpPZ3dRSkx2K3B3aXFRQnZJa29QNzhR?=
 =?utf-8?B?dnN2ZlRMZ2ZWbm1SYk5pNXRpT0xzQkIxWnRQM0UxZlFuSmthOU0rK0JSWWVp?=
 =?utf-8?B?OHJWUUhSVnhJWUVEWlZKWlRBTlU1QWpMOVJ5d3V1cnJhcnp4bG96Wmd3bW52?=
 =?utf-8?B?TjU3L1BzZkpjL1QvV2RuRW9kQ0FmKzJ4QU5LeXU1WEorbFZFV0Q3T1NwVjd5?=
 =?utf-8?B?bGJZa0VKcGZ3S1lZTy9tTzVsclNuV0l5WkpuUWhPMkFZMXFjL1p3bHQ0KzNP?=
 =?utf-8?B?ajZNWGRMZXh0ZUpyQWFuMll0Z3doaTR4dGhVU1lMRnpld0dVejg3dE40VFRF?=
 =?utf-8?B?b2VsN1BSZVhxbnkrdSsrRWlHVmkrTWlEMFdNT21ONllVb1lnL3luSVVsVmNK?=
 =?utf-8?B?UUJteSt1L2htNTlZeWFyMVYrVlpKNkdkTGpyM0M2SERPZmU0bG42QkNxSkNi?=
 =?utf-8?B?V0piZWFyK1dlYXkxR1ZBOVJnbG05VGY4V01nejA1TElYd00xaHBkUWVOKzNn?=
 =?utf-8?B?alJJNGF3dk1nUFZIVFZhV3Z2NUdHNUhCR2IrV3lPdmU2a3F0SWMrd2lvYzNN?=
 =?utf-8?B?aE9nMG5WN3BEWHVHanpCNTQ5RlRJaElrTktHeGhOaVEyQ2sxQjFqdEFOdTh5?=
 =?utf-8?B?UWhxeHp6dWZZalE4NXkxaldIYzRoNSsvci9SbkVkeldzZkVYaWlWK2ZJZUk3?=
 =?utf-8?B?MVpmdjZBNXFQVEZnckhEYnJQWTZBTkRHQmtQYVBIZUdkTE9FOXM1dW9RNzU1?=
 =?utf-8?B?S3Q4aTNkZ1lDWmE4VDhKOGh2bkoyY0pTb1lKbkd1YVRHNVpNMlZrZG5scHFn?=
 =?utf-8?B?WXFZVldHWGhPMElZWko0Znc1UnErQVZNVlJYOFcyUi9ZaGFMbEtDVG5ENDdV?=
 =?utf-8?B?WmtFeS83cHZZVXpHbVRHK3BNOVRyMjN4MEhLSVJ4bkdXeDlXcmt2eXZaTER0?=
 =?utf-8?B?a2FwZ1lNSGVSSjQyRG1pM3d0OHo0L0VXODA4MGJKL0VDNkVUallMakVycVZx?=
 =?utf-8?B?V2FjSk5uWEU1eFliN081T215Qi84bkVsWm95K1FlRzFnNysvMnNBSHUvazdW?=
 =?utf-8?B?NHNCUms0UTM1ZVNhM0ZTRHNpbHI1bjgzQUNtRXp4dzM1ck56dlNuM05UL2hQ?=
 =?utf-8?B?dXVNR3hZaEtlRGNsWWhTOGxMdWVzOVcyTVhSUjBFSXJsSE9JbE5qbVRNWlY3?=
 =?utf-8?B?TXhtK1g5U1U0bUVlOWpkL3dBZVREa05hQzJoV05tekM1QmdWMTNVcDRMOWNy?=
 =?utf-8?B?Mm5hVmhmQnh3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SCtuVXphaldyK0xKU1FBeG1TR3JhZkQ1SzdPcFlhOUpGM3JHV1VSYXVaQWRP?=
 =?utf-8?B?S2Vtdm1hWVJxZWFOY0x5aEt2bEcwaFFGNnVwcTREeWhKSmpnMDBUemVMU3I3?=
 =?utf-8?B?R2R0UEkyOUhyK21TZ0o0Z2MxSHM1TVFLL1owU1FMdDFhcjBKZDRCamNUM1FN?=
 =?utf-8?B?Rlo0dkp4Mm9BZkxxN291TWp5QXdlaUo4SENpekg5dXJWZFlTUXVsaUt6NlFM?=
 =?utf-8?B?bTBXMUU0SUNvcUhCRUpuK2hjdE5Icm4wclVXVjhOSm5ZK3NDdEVqV3JLcnVh?=
 =?utf-8?B?V2NZK0dyV1owUmdHOG9CSnBYK0l2VVN2eC9mekswMk9FUVdVaGV5amZvWUZM?=
 =?utf-8?B?TS9RNFpJMitWRE15TVRQMXk4WHRTNmwzOEVvRzYzMmZ3SmUwbGR5UjBFWVFL?=
 =?utf-8?B?V0hKY0hsNnhFYTg0RlVuMktoYjRyZTlpdE50QlZHcmNtU3UyRitlQ3VnNzFi?=
 =?utf-8?B?RlQrNmtKQWVteW42dmRzTVRQSEd1Ty9hbS96VkdLQzhTVDNOMVFUUWpqNjZB?=
 =?utf-8?B?R1p6bkFRV1dGSjg1czQwZmNiWW9tVDcwZHFxck5CVUd3OGZsdTNVTHdoMTdR?=
 =?utf-8?B?RTM5UlhzcStHRE0zMDZEVyszVk54Vk9kaWE4UmNUTDZ5VGZUVGFpeGRlZkNP?=
 =?utf-8?B?aTVzTnV0ODBxL2x1MU4ySlVaVlFnKzVsb3BoQTR1MGJzeWdBdXltaG1reWwr?=
 =?utf-8?B?bVNsd1pWZDZtNnlteEtvV1NwRmNtd01qQUpqaDMvdERGRXFHR3hvaHhoT256?=
 =?utf-8?B?WEtJRmplYWtqM0xiS0gybHlRc0s2d2JUbk1RQ2lHTVZZYjdYaDg2RWk0UGVn?=
 =?utf-8?B?YURzRHNPU25JQ3VoZzRMUFB2NXVZZ1grNCt2bW9CWXRleEN3WTRicjA5eC9L?=
 =?utf-8?B?OWpVaFkwU3JMNWJnZmhLaTkwQjc0MldRcDF6cUIvb1ErWFdxOEFubzIyQmMy?=
 =?utf-8?B?VjJzNDFwd0VRZ1JjN1FUSElmbXJWaDdGNG9lODNXMmJrbm1FQk1ZSHZwdzFK?=
 =?utf-8?B?ZVhPL3ZlNVMxbHlvMW9vR1U0MVc0N2ZlaThHMVY4WUtDV0UyM0Y1ek9UM3RO?=
 =?utf-8?B?L1hRanQ3K1lDcDlFV3YwV2cvR2E4akVlcnR6RVZZRGZaVTdwYVpXdDdJVFJT?=
 =?utf-8?B?YW11Rnk2WEtDcHlNQ0xBaEVJcE1wWnB2UVBVaitOYkp3MWo5ZjJLdWxXSXE0?=
 =?utf-8?B?QzNucU0vMHZ1dmhqOFZheFlRK0JlaCtoWVZlb3JVVC9TbFE0dWV2UmlVKzIw?=
 =?utf-8?B?OWJRbnhDcUZyZmZHR21HT083UVRVdHE1UW8rdWQzeEoxTzNUcUplaUlnd1pW?=
 =?utf-8?B?VzN2ZFlCeXZKN0tMTSt5YXQ5Y0R6ZlFFaE1FSkFlNisreVdKeEg3MVZhVlNq?=
 =?utf-8?B?WnBwRkxTdGNxVmxuTVErN3Rud1A0VUc1V3BIUWw0bU5jSVVCQkRqYTF3ZWFy?=
 =?utf-8?B?OUpldWhKV2dwZ2Y0MEJsSmNhRVBuSlhCTzBEbDNEUkJWMDQ0ZGN6ekYwdjRy?=
 =?utf-8?B?eENDUnZjclFRQjI3WCtTOU5KSXYyK3NMaER2OUhvOWI3SnJkbGtLOThHWkt4?=
 =?utf-8?B?Z1lnZHlkREJUdVo4bWxaMkJvNlBoR29obFN2bVJrWnF4bVBPMyt0WVhMME9X?=
 =?utf-8?B?WS9idEx5d3Jxcjl2Z3ZHQmJ0bVo1U2hVVFdiNjIxQXRBL1VPODRsdnJYN04y?=
 =?utf-8?B?NHk3aEZ0UklxaFFmS2VjZjlXK2wxQ0hyUjhTdnkrTE1yS0lMSWw4b0Y2UUwz?=
 =?utf-8?B?YjVmSEdlZHh1SnhNeTg2SnRwM3BJY3AybXg3bWd6Tk5VRDhNVUNLdVNtWDFj?=
 =?utf-8?B?dHpRaE5LY0xpYUYvS2YzY3V5MEVmTUYyeEpVWSt5bXhBeEN5di9KNUdtVXlN?=
 =?utf-8?B?bEZQcnFYNEpYVVpkdDVUbENSTWFzRXZNSkozMWhKWCtUY1BKYUg1eTBpYUxM?=
 =?utf-8?B?WitmN3pOZ3E5WktKWXllMVRlY1R0Njl0SVdHTUt0OG1qQXhuTExRMmMvQllW?=
 =?utf-8?B?U3h2a1pkVnBnRDQyd3ZOaEo5M09Ndm5JQTdTR241WFBWeDZMMDFhRTcxZk5t?=
 =?utf-8?B?M1JmdW1WVWN3V29XMkpGN1BPRis5VmQ0Qkl3MVYvSDQ5T1JVQXVvbThyZlBv?=
 =?utf-8?B?OGJkYk40ZGhiUWt0cXVndWVmSGczbHkrLzl4RzRkVTFWMWdhdTczNW16Qmo5?=
 =?utf-8?B?aVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5DA770FDB49F7A4AAB9C944BC371E702@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71df22f0-e143-48c2-5ed0-08ddb0227704
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2025 17:47:02.8435
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 25jGikDpWoiOv9bE45Y0+pCcQ/uvhfb3kVnLuE7qkHKgj9Blb0VEQv6Sb+AxvzO34nRwkjfjAMxxvtTX+O7PuBXIN55Oo1rOcssYrtttr4A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR11MB8330
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA2LTIwIGF0IDE5OjI0ICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBPbiBGcmksIEp1biAyMCwgMjAyNSBhdCAyOjQ44oCvUE0gWGlhb3lhbyBMaSA8eGlhb3lhby5s
aUBpbnRlbC5jb20+IHdyb3RlOg0KPiA+ID4gVGhlIGludGVyZmFjZSBJIGNob3NlIGlzIHRoYXQg
S1ZNIGFsd2F5cyBleGl0cywgYnV0IGl0IGluaXRpYWxpemVzIHRoZQ0KPiA+ID4gb3V0cHV0IHZh
bHVlcyBzdWNoIHRoYXQgdXNlcnNwYWNlIGNhbiBsZWF2ZSB0aGVtIHVudG91Y2hlZCBmb3IgdW5r
bm93bg0KPiA+ID4gVERWTUNBTExzIG9yIHVua25vd24gbGVhdmVzLiBTbyB0aGVyZSBpcyBubyBu
ZWVkIGZvciB0aGlzLg0KPiA+ID4gDQo+ID4gPiBRdWVyeWluZyBrZXJuZWwgc3VwcG9ydCBvZiBv
dGhlciBzZXJ2aWNlcyBjYW4gYmUgYWRkZWQgbGF0ZXIsIGJ1dA0KPiA+ID4gdW5sZXNzIHRoZSBH
SENJIGFkZHMgbW9yZSBpbnB1dCBvciBvdXRwdXQgZmllbGRzIHRvIFRkVm1DYWxsSW5mbyB0aGVy
ZQ0KPiA+ID4gaXMgbm8gbmVlZCB0byBsaW1pdCB0aGUgdXNlcnNwYWNlIGV4aXQgdG8gbGVhZiAx
Lg0KPiA+IA0KPiA+IEkgbWVhbnQgdGhlIGNhc2Ugd2hlcmUgS1ZNIGlzIGdvaW5nIHRvIHN1cHBv
cnQgYW5vdGhlciBvcHRpb25hbCBURFZNQ0FMTA0KPiA+IGxlYWYgaW4gdGhlIGZ1dHVyZSwgZS5n
LiwgU2V0RXZlbnROb3RpZnlJbnRlcnJ1cHQuIEF0IHRoYXQgdGltZSwNCj4gPiB1c2Vyc3BhY2Ug
bmVlZHMgdG8gZGlmZmVyZW50aWF0ZSBiZXR3ZWVuIG9sZCBLVk0gd2hpY2ggb25seSBzdXBwb3J0
cw0KPiA+IDxHZXRRdW90ZT4gYW5kIG5ldyBLVk0gd2hpY2ggc3VwcG9ydHMgYm90aCA8R2V0UXVv
dGU+IGFuZA0KPiA+IDxTZXRFdmVudE5vdGlmeUludGVycnVwdD4uDQo+IA0KPiBZZWFoLCBJIHNl
ZSB3aGF0IHlvdSBtZWFuIG5vdy4gVXNlcnNwYWNlIGNhbm5vdCBrbm93IHdoaWNoIFREVk1DQUxM
DQo+IHdpbGwgZXhpdCwgb3RoZXIgdGhhbiBHRVRfUVVPVEUgd2hpY2ggd2Uga25vdyBpcyBpbiB0
aGUgZmlyc3QgcGFydC4NCg0KSG93IGFib3V0IHdlIGV4cG9zZSB0aGUgS1ZNIHN1cHBvcnRlZCBH
SENJIGV4aXRzIGluIEtWTV9URFhfQ0FQQUJJTElUSUVTPyBXZSBoYWQNCmJlZW4gZGlzY3Vzc2lu
ZyB0aGlzIGFzIGFuIG9wdGlvbi4gSXQgaXMgbm90IG5lZWRlZCBmb3IgdGhlIGluaXRpYWwgZml4
dXAgc2VyaWVzDQpJIHRoaW5rLg0KDQpJdCBjYW4gaW5jbHVkZSBHSENJIGNhbGxzIGhhbmRsZWQg
d2l0aGluIEtWTSwgYW5kIG9uZXMgdGhhdCBhcmUgc3VwcG9ydGVkIHZpYQ0KZXhpdHMuDQoNCj4g
DQo+IEJ5IHRoZSB3YXkgSSdtIHRlbXB0ZWQgdG8gaW1wbGVtZW50IFNldHVwRXZlbnROb3RpZnlJ
bnRlcnJ1cHQgYXMgd2VsbCwNCj4gaXQncyBqdXN0IGEgaGFuZGZ1bCBvZiBsaW5lcyBvZiBjb2Rl
Lg0KDQpTZWVtcyBvayB0byBtZS4gSW4gZ2VuZXJhbCBJIHRoaW5rIHdlIHNob3VsZCBsZWFuIHRv
d2FyZHMgaW1wbGVtZW50aW5nIHRoZQ0KbWluaW11bS4gSXQgc2VlbXMgd2UgYXJlIHN0aWxsIGlu
IHRoZSBsZWFybmluZyBwZXJpb2QgYW5kIGhhdmUgYWxyZWFkeSBoYWQgc29tZQ0KVERYIGFyY2gg
Y291cnNlIGNvcnJlY3Rpb25zLiBJZiBhIEdldFF1b3RlMiwgU2V0RXZlbnROb3RpZnlJbnRlcnJ1
cHQyLCBldGMgc2hvd3MNCnVwLCBpdCBhbGwgc3RhcnRzIHRvIGFkZCB1cC4gSGF2aW5nIGEgS1ZN
X0VYSVRfVERYIHdpbGwgaGVscCB0aGVyZSwgZnJvbSB0aGUgS1ZNDQpzaWRlIGF0IGxlYXN0Lg0K

