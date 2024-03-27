Return-Path: <kvm+bounces-12797-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5417A88DBB1
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 11:59:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C95F81F276AB
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 10:59:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A537951C47;
	Wed, 27 Mar 2024 10:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ds299Qo8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3093C3C;
	Wed, 27 Mar 2024 10:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711537169; cv=fail; b=ePFWwCf5DRpAxKhexJfRBHFZJitArKlol8WCAl/LT7A31lCxfjWS/hfe2w+WixRdflt5H4Fq6nCgdnbU6NE0h+d0miA59Q8QSByJSiJExE0cwbb0qSMDQOOLSrhCxrBXKcnDx62ehnunL/UbMRxpvIZLeb163eFprsyG0wfUnfI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711537169; c=relaxed/simple;
	bh=S+oWBWsFmYnrdk6CCE4VwDINKD71Di/Ty31iHIPPiPo=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OsjCgoOaUXEO+GhPGTRGw+0O3Zp3aZ/eFGWdEraBYN+OOkp52XDs7AKUU6whPNQZp+dDUeT33qoNZhXDQrqddLCpydAJ/xMYJwOBYAdYPUmrphDRKbHH5lU/4x3RBiTpXyd2Au0r5wfvwKWUxjf3Fjg3xsPDPOE/EAZfqbQ2cF8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ds299Qo8; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711537167; x=1743073167;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=S+oWBWsFmYnrdk6CCE4VwDINKD71Di/Ty31iHIPPiPo=;
  b=Ds299Qo8cTvWpmTEQZnMxMHkHzUGTKlIczFfVzl2LZa42JVToeLDt8q9
   d8muHuYWt1lUbIhZnNKiOu0xAIyAub7LI4Txmj9ZmI3kMReMtRCfqsGKE
   tkLDevLcBMc7aacZgpeWcGjHMOr4djK/t78E9hHfYBCYzhg/2EcjtvUcK
   ndPWF3/O475iYJFU/ffW46T7jaLXJ3aW8VgJfSkWFk5zmcMUSFVqTWwU2
   +FVYVbW2H/C93Z7KNzxFSOBHwYYUVCWNwu/8TOD9dkyJ7r5CMguA3lihF
   EMBmXRUDYbOAFfgmBbeWC8z/s0jY1JsX/CpFyWIrpUrB3TDvdoQhshyUo
   Q==;
X-CSE-ConnectionGUID: wvbVBxu5ToqE0G6o+M0+bA==
X-CSE-MsgGUID: uGvUxLAkQqKYixXA83NTmA==
X-IronPort-AV: E=McAfee;i="6600,9927,11025"; a="10431574"
X-IronPort-AV: E=Sophos;i="6.07,158,1708416000"; 
   d="scan'208";a="10431574"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 03:59:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,158,1708416000"; 
   d="scan'208";a="16103150"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Mar 2024 03:59:27 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 27 Mar 2024 03:59:26 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 27 Mar 2024 03:59:26 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 27 Mar 2024 03:59:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mncpACpO4c9Nr9O6UJg5x/R47dcjUVeZTuLi0OL9ZjLr1n2iQtVSrfr/tMUhX/8Zwm10Xbyt3oogeUgK7ndaXBQdb6vq9CavBy2R1/StppqCDv6v8MfcqoKwF6GgYRiwmwQQTCjhGSl2ft793xOxDrWAYIB9wbzX4gD1or29Xho1dN4v82/uc4HG5RvBRtkl0Ox/99ggLt9j48MRvcLGLKCMaDBNi01c1iyjnJJ/ni/3ovLrpALD5NtY8mpi5iMn3oUAxdS432CfL5w5AfPTtbrxFhKaJ60Lpi32f11DKE6HzoJe4vOoXtH/uKRoN+CDZkjYnwvL6d+v5eCaIkdwog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S+oWBWsFmYnrdk6CCE4VwDINKD71Di/Ty31iHIPPiPo=;
 b=WOYfAGMRmlWsfaNlVOoPJR7e4bcu3lQ2+2TciwLSxsdOAUGjRKc7rDSmPJ45ACDBu0/vLqGt67vIr+EQKmp9pbFkKfQ8fYOzn/1FoFnSziieY9snQmJ1wAq5hXtvjigpMkWYpX+yhfQzjlPpDkrDbK0aibujxI+4DVh+4+fzlWECHJepbwEm/WszNIn5j8DsOTm2iclEaCsUb0r9SwO5ARJF//gqi/lhQJ5AiiTOi6kA6k5O4TeIaWoyT5AjNKmAjgca2UNthBAifXpnulqLlnMJTcEOcV2AmDIeX1brEcT3WIkK+46zFHbF3uKXc6RWW8vijgXTlFgDAU56lMaRMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by DM4PR11MB6067.namprd11.prod.outlook.com (2603:10b6:8:63::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Wed, 27 Mar
 2024 10:59:24 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 10:59:24 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "luto@kernel.org" <luto@kernel.org>, "seanjc@google.com"
	<seanjc@google.com>, "x86@kernel.org" <x86@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "bp@alien8.de" <bp@alien8.de>,
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "Li, Xin3" <xin3.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Kang, Shan" <shan.kang@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 8/9] KVM: VMX: Open code VMX preemption timer rate mask
 in its accessor
Thread-Topic: [PATCH v6 8/9] KVM: VMX: Open code VMX preemption timer rate
 mask in its accessor
Thread-Index: AQHaccEFvtQhH+vFrkOHoBYSjiDforFLiCMA
Date: Wed, 27 Mar 2024 10:59:24 +0000
Message-ID: <2cda791c58f208a6fa1a2310d7954c236068750f.camel@intel.com>
References: <20240309012725.1409949-1-seanjc@google.com>
	 <20240309012725.1409949-9-seanjc@google.com>
In-Reply-To: <20240309012725.1409949-9-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|DM4PR11MB6067:EE_
x-ms-office365-filtering-correlation-id: 1c1d6915-1007-4d43-b2c5-08dc4e4cf6c9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: agP1ffNAMB606d5M2SN3/iQQTsqwqq/rqXqhxXHkpfdJlayRP9E0RiGCyweOVTaWH6CQGMZgNEYtBEHnMo3Y+Ysoc0/ilBVVQ0E6UFu2krLowV00OJndbrDJPDkl7DCafOug5tgl49Gf1cSf0QRRPUI6llcsAMFv5f9JsavOJqHXInCcACbRJIN7ebF9NP8CNWyQgISBORPvYcjIorsdgsA3DPLPk4LDdqlhLK7rrD7vFTtHLqxtz7Nz8RrBtbUwAsbI1/sy0nYIhHzqAIT/Z3Gq87Vh5S9AEtQBW0O/18+iE7Oo0SIo20smphe519139SvY09GKhM/Z/ywOUJ3IafXQf3W70jZYsIAoHzLe9GmSsSG51Nz2U2Ysl1kVSJyBp4+YCRvnKSHNrOUMIlfIhsQ3C978jiaMp4lsK9XWY5V/b/2j1K8efYw8oBcYehA+eatt5H9Stm2UV96EG8CTSUseUgDNBWUAeYpernRCfLY0CsbJF0etuvpKrmFvoiYlNP+uKVsLNLGSRb5cgfKoI3tw3CV5icMghLWliPjaWexz4uNi5TQcWDjtqNJwDj+vTLg8DnATCuFMMEAGfpFj13qPbDhrypH4EPnahy0wjCKK5Wljd0KghUkfHD5gkWjrnQqmNoN3BofeyPB0i8SmRg7fElKkNaJwk9ujWdk0kyfaYpA/yFFCUMMZXK+7RmF2FcYPhlnjP5NmeDNG7iIoFd0aAj1BipVMY18KeMEk36U=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(366007)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aFJwb0hLOWszVW5UbTlVK1hrRGpuRGU1SVBFbzNhVkNaOFJTa0ZTcE1GVVZM?=
 =?utf-8?B?cmd2WmtLaUlpT2NIQ2FQZzNIRUw2d0J1U3FQZ005bmJMRWtFcmZ2ckZDRnNS?=
 =?utf-8?B?ZnMvUjQwMnR6VkNGUm5mejRMeWlRaU0vODE1akFjQ0dPaERpd3hvdU0rZXhE?=
 =?utf-8?B?Z0xtVk9oVm5KMkc2ZjlsVDYxdTlqQ2VJakNtNXI5ZTlFSjZpQW9CRjM0dmJI?=
 =?utf-8?B?WllEc09TNDV6L0wxaHkrbzlDZGNhcWVoR2RTbUNFVE44NktCR0RYbC8vUG8w?=
 =?utf-8?B?TmxsdnlDa3hNUk82c3BEeEhvTEkvQ1ZqcWFSRTZSV0pXZml0dGVuWXN0VWdC?=
 =?utf-8?B?TG5vaVBIOUd3YjQvdmlwbnZYcHA4N3dHQ0FPeUtkNk9UUjBFYVNJNkdseUZG?=
 =?utf-8?B?TTVmTnhVSnFzWlJqZExMQWx0SjBhZk9uUzNtVGF1aWNTcmFETDlJZS9jVzFH?=
 =?utf-8?B?cWtlZlZ5UHIrVGRZK2RqOUdteDVQOEU3QXhNdnVCbmlRemtHQUd1cjZKNXR5?=
 =?utf-8?B?dm1DTUpKOS9VZGlNRVg1UFM5eUlIWStNYWZoaG42Tkp2OFVDTEhZOUhPaWxi?=
 =?utf-8?B?WDllTlZ6ZUROREVCYmJZejl0S3NQMk8xSm14OTJiMm9BMjZQUy9OdTlQUmtR?=
 =?utf-8?B?VUNtem50Y25WRzNJYmRrMVhMb3Y2R09tSHRFUnpLMmtlanZENmhyUWxmNTUy?=
 =?utf-8?B?eGt4U1drMjhyMks4Y0UvcFQ4cnlVbDI5bUJENzBuam4vZWR6MHBPRUVRWk5s?=
 =?utf-8?B?RWgvQXBrdi8weEFlSkpPL0xJRDVQa1l6ejU4VGV1QTBycHVyQlZ5bHBJZEE0?=
 =?utf-8?B?a0VTdkNFWmlSaDhHNzFxRGpVU0l5dHVuZC9Ya1FDWXhsRXpRdWQySFV6Y2dN?=
 =?utf-8?B?b2hSeVNFb2NoejN1OHZ3WGh1T0dMYjJyT2tZSlBKRFozVDVUUEVqamw4clYv?=
 =?utf-8?B?VHIrVnBTSTJOMTJhai94TEhCQms3MzZkSXhLSXE0M0drUC9VUGZGblZMUVBu?=
 =?utf-8?B?eVhDdWJySzJRUzZTMk1TSUFuVno4KzBWMGZHVnVuQytzakh1azVtci9nYXl5?=
 =?utf-8?B?cklZMTJBRHpUNzFyMW5Gd3I0VStHUUwrQ3BLaXF2b2lmeHczb1ViVjB4ZnBu?=
 =?utf-8?B?L3Bzb1Ftc3dSZEI1Rnh0WjNQTGswQXNSMWUvOWlxVVJwQlBENlIvNmdXYUtM?=
 =?utf-8?B?dlhaZ1lwWkU4N2FFWWZXZjV1WlFmYXZkOWRaVkpOVjl0MC9FaXFSQktDT2FR?=
 =?utf-8?B?ckM0c1N4bkJ1cGROdGM4R1czOXpHcisrajNnMXZjOGNTSUwyZC8ycWQ3T0dE?=
 =?utf-8?B?WE5FYTJtNjQ5bFV3Um9jd3luRjVrN0hpcHNXZ25PUVRIS3Y4Q0NEMW0wajRq?=
 =?utf-8?B?TGpNZ29xT3R3SE9US1U0NmRKNS9RQXd0VmVUNTdTTHZGWmJDOGhqMkxibUJo?=
 =?utf-8?B?UVp4VXJ6Mm9CVVh0THQ4anNXd2FNOUJjRm1QbStXSjUxbkd6OThnb1EzRnp5?=
 =?utf-8?B?VmZHb1l0ZUUxVCtOaFduZlZlWmx0U3d4SlBhQ3RsSGFkOUF2cTBQQ2E3eXgz?=
 =?utf-8?B?QjFCZ1dwUnJ1RnJFWFh3RitWT1F3STdGV1dNVXR5aEtOZ0dFRXhrZWZNcW9S?=
 =?utf-8?B?MnFOUDMrdXFBNklFZ3ZEQ1RIckhxYi9kZVBqYlJkcWh2aXU1Y1IrbHkwSU0y?=
 =?utf-8?B?bTlLZHAyRmRiRTdpb1NQbHRBS3RtTjYxMUpTMWdWamdXb0tZcjAvYmlWWG80?=
 =?utf-8?B?L2ZCY2hYa1huZGlDWWZDL0lKbndHM1lab2hzRlZ1RU4vaXFadUZGbU5sUnFv?=
 =?utf-8?B?VW9iUVBwVi9sMW1UenVrL002UjZid1JQMitkdWJIbTdCMU03NkppOVFkbm5o?=
 =?utf-8?B?YkQyVm9iMWV3L25aSGp0NEhKR241WFpVOWZqUW8zTEd6U2hxSEx6REVJTFRZ?=
 =?utf-8?B?TlB0SUZERnMwWk1VOFB3aUROMXVSR1lmK0NVWURZZ3NJb01QRS9wTkY1R1NH?=
 =?utf-8?B?Y1NhNzJzRUFMYm9ISzJ0eHdNZy9nTWRaTDhTNFQ5VU0xSVVyY0tIcjhHVkhD?=
 =?utf-8?B?NGZ0UWxkV2dwZUk1UEpkY1EwZG1FSUJvV09hSnNGZWVDSFozZ0F5QkkwRjR6?=
 =?utf-8?B?U3RCZ1VvVlN1TTFBNmt3UmUvWWcvSWJWdlJPeklZZWQxK2o1V0NDbWJpZVJ6?=
 =?utf-8?B?NEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6661C02A91171F468E0AD466F7F28A8A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c1d6915-1007-4d43-b2c5-08dc4e4cf6c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2024 10:59:24.4442
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NrvLnWqWuHBOkUavF5Oh0QVDXGIQ7xz98m3U2QiIOpZ/l/kzbNFcOo/pgamd+ePNRaJFKfLN5kLrEZ9y/WDgjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6067
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTAzLTA4IGF0IDE3OjI3IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBGcm9tOiBYaW4gTGkgPHhpbjMubGlAaW50ZWwuY29tPg0KPiANCj4gVXNlIHZteF9t
aXNjX3ByZWVtcHRpb25fdGltZXJfcmF0ZSgpIHRvIGdldCB0aGUgcmF0ZSBpbiBoYXJkd2FyZV9z
ZXR1cCgpLA0KPiBhbmQgb3BlbiBjb2RlIHRoZSByYXRlJ3MgYml0bWFzayBpbiB2bXhfbWlzY19w
cmVlbXB0aW9uX3RpbWVyX3JhdGUoKSBzbw0KPiB0aGF0IHRoZSBmdW5jdGlvbiBsb29rcyBsaWtl
IGFsbCB0aGUgaGVscGVycyB0aGF0IGdyYWIgdmFsdWVzIGZyb20NCg0KSXMgImFsbCBvdGhlciBo
ZWxwZXJzIiBiZXR0ZXI/DQoNCj4gVk1YX0JBU0lDIGFuZCBWTVhfTUlTQyBNU1IgdmFsdWVzLg0K
PiANCj4gTm8gZnVuY3Rpb25hbCBjaGFuZ2UgaW50ZW5kZWQuDQo+IA0KPiBDYzogU2hhbiBLYW5n
IDxzaGFuLmthbmdAaW50ZWwuY29tPg0KPiBDYzogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwu
Y29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBYaW4gTGkgPHhpbjMubGlAaW50ZWwuY29tPg0KPiBbc2Vh
bjogc3BsaXQgdG8gc2VwYXJhdGUgcGF0Y2gsIHdyaXRlIGNoYW5nZWxvZ10NCj4gU2lnbmVkLW9m
Zi1ieTogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+DQo+IA0KDQpSZXZp
ZXdlZC1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0K

