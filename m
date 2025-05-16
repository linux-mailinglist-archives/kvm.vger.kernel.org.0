Return-Path: <kvm+bounces-46909-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B06FABA5D6
	for <lists+kvm@lfdr.de>; Sat, 17 May 2025 00:17:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0FC8818965F0
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 22:17:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DC5227FB2F;
	Fri, 16 May 2025 22:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JNjUrRuC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81C319CC3D;
	Fri, 16 May 2025 22:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747433816; cv=fail; b=QS4bgQytCuBrfXQ0/EB5jXjQGVjxPk9gHgDtoVCQpRtx9gdCGXRzzBJPexGGosNEwOFgRWYYiBKFqrD2I+B67Walxp/nVrVYBxm9j9cqeFnP7dtiAlOUBb1Gi1WltOMau1ndjNzAIZ48vryUhfe4LJyH5oTwu57LuOr5x4J/tUY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747433816; c=relaxed/simple;
	bh=7RvkUsgeWmLzOjQ5HKhFSlIFG9AfiX0wgxdkzTbW2pY=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dMICOV/Tb5r6xBZRlA2e0PQbjUAPQ7oPPdzfZ3fzVBb9c1ZE2PcKJGSLThTDVrDsH9AiMIWNtPG0tYfO9CQlBcdMkGLx8QF19xkP8oypnnNOnaF31+d8xLDoH6VgYeyrg7OJX5EzlD8A0bNI6N2K9jL7ovDP00xEjEB55gpnr3g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JNjUrRuC; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747433815; x=1778969815;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-id:content-transfer-encoding:mime-version;
  bh=7RvkUsgeWmLzOjQ5HKhFSlIFG9AfiX0wgxdkzTbW2pY=;
  b=JNjUrRuCwqa3gW9JCxchte66rhWCbMgv88B8OuczASxMFCU9bG0pzVpn
   GXDvZ0coQ5gVesKyXutWFAgajz9gle5V6Pi8JsOzysDgR65pa3uPYReds
   S4Y4PtOo81DjzlS7Zk1t2hZId2HNiqey3L95OuJA/lOb6GLt+jDmQAupK
   5Wl1gWVImaj80U0Np1z/u0E/XBtMSJd+avjelu2Boo0/OkG9hlpzKJB34
   ul+JhFvrZGhy/kFCJLTro9ERMY8v0k3a1rpUYCV2z8krS5lXzbikxTcU5
   wiNIJD2Gykx6KZszyGCnIJM8U18bj/J+V6nS7axkI7PvnhRb8DS29cLeF
   Q==;
X-CSE-ConnectionGUID: +KGEBArsQ6S1tvEA3kFTmQ==
X-CSE-MsgGUID: VHKrjQXoQfiqeGvOGcnuyw==
X-IronPort-AV: E=McAfee;i="6700,10204,11435"; a="60055102"
X-IronPort-AV: E=Sophos;i="6.15,295,1739865600"; 
   d="scan'208";a="60055102"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 15:16:54 -0700
X-CSE-ConnectionGUID: m/eMxCwDTgusCJ9TiLCA1w==
X-CSE-MsgGUID: kFPzpGbMTgCD4YxteCCtcg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,295,1739865600"; 
   d="scan'208";a="144058657"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 15:16:53 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 16 May 2025 15:16:52 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 16 May 2025 15:16:52 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 16 May 2025 15:16:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e9vM2nN1pVASc1lU3XDjHQabxsEjuYaJlffBgAriAPNJ25JT2dyNQ/qTUX31qAZW9/KMZimk2vBCr6xQPoYmFfwOgmEFCZd+0FGcsh60x13F8WQderS8M+Eij0A0lBaU1Ljz4lVAXhsiOnNS5CmI97lNuqIRnC37Ej2ljuvUFNM3r2KvTLcLJpa5txmbwgc7+ru3AJwgQejvBDwCbOj11qjKzRhw2pf9HLYQMZicCufPyC2vCtNhEsDu4n3EA4w+bvdotUoSYsIFX2LnDXFzMEzR3bODpb2hufwR6Cw86APEKlp8wIBhOtcl7/AhKupARaCSlY+SDPrkTVENBqqDrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7RvkUsgeWmLzOjQ5HKhFSlIFG9AfiX0wgxdkzTbW2pY=;
 b=YDmGWVvgxPIRfKmk5xk/dmNu14dD7DTOKMGL82S3AQfAaRIrsDQPT/4nafNXBK2UC21xUnrG4HaMhBUQvrrkynGVUSmvh5Ni5DVjzL5dzx+M3yk05PfTvP5/dIbPsfA7xOuRaoLmhefN3Wamz8q/hZS0O0F09uN8g2B7JAjOhbTLxOegVKgqNhTn4ev8yoeVH92gXvlXDuXgRh29EU93Rg0FgU4yx6kCbTwjkSeVqCtdiYYxy916U/ld7jU0IlnLaf0SlUbOtLe/udlIS5hwN5Ohf5o5UX/7gG071dHtA1dd00hDGSinDDCNmHBfThicy+f4bhr9KgqafPlecW15nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM4PR11MB7206.namprd11.prod.outlook.com (2603:10b6:8:112::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.33; Fri, 16 May
 2025 22:16:48 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8722.020; Fri, 16 May 2025
 22:16:48 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"Hansen, Dave" <dave.hansen@intel.com>, "david@redhat.com"
	<david@redhat.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "tabba@google.com" <tabba@google.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "seanjc@google.com" <seanjc@google.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "Du, Fan" <fan.du@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 16/21] KVM: x86/mmu: Introduce
 kvm_split_boundary_leafs() to split boundary leafs
Thread-Topic: [RFC PATCH 16/21] KVM: x86/mmu: Introduce
 kvm_split_boundary_leafs() to split boundary leafs
Thread-Index: AQHbtMZq5aOSX6sBB0S9hhJvW+6Xh7PRSvSAgAO44ICAAEJ5AIAAsJOA
Date: Fri, 16 May 2025 22:16:48 +0000
Message-ID: <e731cff1fb840aef22f406e620b28414c583f225.camel@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
	 <20250424030816.470-1-yan.y.zhao@intel.com>
	 <e989353abcafd102a9d9a28e2effe6f0d10cc781.camel@intel.com>
	 <aCbtbemWD6RBOBln@yzhao56-desk.sh.intel.com>
	 <aCclMAY0C5OXjt4/@yzhao56-desk.sh.intel.com>
In-Reply-To: <aCclMAY0C5OXjt4/@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM4PR11MB7206:EE_
x-ms-office365-filtering-correlation-id: 8ba547ce-24d0-42d6-66aa-08dd94c759ea
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?UTlXTjFtaWQxZldLTHR5TXFBYS9SOE5NWmVCc0QrZk15OTJQV0N1c1hON0FG?=
 =?utf-8?B?MVBtT0pkeU1OcTk2dWVJekp1RmhDY05QL0hrQ3NwaUFMcGdNVkRFRm4vcUJv?=
 =?utf-8?B?OE92TmdXRVBNUko1K3hWU1dkMVdxSDUwVE5ONVZCMGVVSUlacWFNQ2N1aGk0?=
 =?utf-8?B?NW5aUjRzUno2SWUveXZJK3JQSG9SMDEySE5Yazk3Mjh3WDVnSmVSOExaRWJl?=
 =?utf-8?B?aVdYOTAwek9pbDBwOHpWRUhYSm9EM0ZUMlQrbkZMd3FWeU5tVEdrNmgxaHlK?=
 =?utf-8?B?QnJTUmttTWxBdXRVSlU0UmdiWUlOYWFSVU9PRlpidnU3S0dtWjJhTmVkQk0w?=
 =?utf-8?B?eWlTRDZHK3Y5T1lGSlMrNUI5V1NvbjhsRGdPd3JZb1VyQVFjOXVKTjAzOFBl?=
 =?utf-8?B?RHduRnJUcGduS2xPdUZ6SFovcWZsUytzMkdqRUhZZWRmTUQ4MTZDUi9ZMEVt?=
 =?utf-8?B?c2N0UzE4N2dRQTJmWUFMVVV4K3VGOU9hc21QbVF1cHlZdDNpVTB3TTQrR1NQ?=
 =?utf-8?B?cEdWbnNZNElGYmJpZnJUb01uV2ZldmcyUUJHRWtCNEprUTF1U0VIRU9UWDkv?=
 =?utf-8?B?eC83S3VMYTVodjBsdFFYY294Mm1mVTh0OHhYak4rVVR3N1dVVmZZVXZBUlVT?=
 =?utf-8?B?Vm5Ycjd3ZlNiQ0lLMXA5QjRrMVA0dkxYdHI5cTYzRkxLUzJhbk9rdlJOVndI?=
 =?utf-8?B?Znlic2xHVGZKcVNmUXExZ041Y09wUCs0SEtVMjJBbGNTeVZ0SjQ5VGxjcUhz?=
 =?utf-8?B?dytzSFhMTEVTMVpaL3FuTjQ2OCtWRkE4b00zQUg1YVZjem1ROWdSU0I2WnZE?=
 =?utf-8?B?eGZGNXJsdXlQY3kvNU52QisxNEtKU1lyQzkxSi9SakJqNGUrRnV6dXUyWURV?=
 =?utf-8?B?NHBvNkhIdWJUam1oZE1CMFFLUUFNcWFIcC9uZERrKzhTb3ZxRklQcG9PbEVV?=
 =?utf-8?B?ZmF4aEtIR2NRUHhqVks0bzJOdm1tYm80OUg3RjlmVXZpU3pqZkNlNGMwMVI4?=
 =?utf-8?B?ZG5pTG9pYkJRZjdtYVg3d1kyUnljd0NLRzU5Vmd6TURidzlrSlhBL0RCZ3dk?=
 =?utf-8?B?OC9wZUY5WkdjWUgwUENhSGhFZlJyV1N3UHQ4U2l0K3hvTTJZZW9mN2owL0hj?=
 =?utf-8?B?dDluK3hXWGI3STJqNXBkQWxDVzdZbFpWQUZIS3cwMXRsVTJEVCtvSnZhMnNz?=
 =?utf-8?B?UzFlLzk4b3MxT0ozL2M5N2o5QkJ6cmJtLzZGVHNJZE5nRWxYUjcxRU1td0o3?=
 =?utf-8?B?UU1xZGJBbHFlcWFFM2ZRYlpUVzdUZjZNUGdQUEU2M3FJa0lSSGZPbjlwSzZp?=
 =?utf-8?B?aGI3dGRXbXZ3eWNHK2ZBSUZ4RGpVQXdkSXFLeGtsMC9BS01aLzNOanZyaHM4?=
 =?utf-8?B?a2FZTFdDcWpwQnptZFAycmc5R21YN1Z2TC9Xbi9BQmV2aVJFaGZ0cUYvWDQv?=
 =?utf-8?B?Qk5QbEsvN3FWU2xabDRlMlZCOTRycndFdkxlMlRxN3BBb3RkMHc2N2Q2U1VQ?=
 =?utf-8?B?ZjVlZWxmS1VpaExGNmV5eXF1MWFWWkl2cWNEcE5YZ0hsWnA4WEJac2pLaDdv?=
 =?utf-8?B?d2JmTVRnQjFKZ2VxRjgvd2NZL1Nnb0F0SERBQWxoZ0JpWkN4aEhVRzd0M0dX?=
 =?utf-8?B?aDIzWnN3OEk2SE53elc3V3RYZnJBcG1ZaUFtd1M2NnJRM1Z0ODRyaVdkcWtp?=
 =?utf-8?B?OUZNS09rWEJvUk5JQW10ZU5GSTJQQjJ0dmt2MktpQWhlSUVXUXY4a2k0UVkw?=
 =?utf-8?B?ODJiRzVyS1pxSFBxZ2I3NG1wQU5KMGJPaUM3OGh1RjFsZWp3WUtvYkpIZlAx?=
 =?utf-8?B?dUMvY0tscm81NXdoZnVsRjkxODA3b0FtWFVHTXQ4bXYxcklwZW42UE92TnVJ?=
 =?utf-8?B?VTlHSkkrSk9JbDV1aGwwK21TM2djUmxSajZ0Vmc4MGlPYm9kUG9MeFpqQ2lj?=
 =?utf-8?B?WlJMM3UwOWRKbitWY2F3ZW5YUTNIS3NRQUNpQ2N3aGY1ZHVEaE8rY25IZHBG?=
 =?utf-8?Q?rrqhR2qQSOyMDkbV4WMkbTTDFp0K1Y=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Ty8rK2p1VEJ3YWNSR0JvdExXa09oUnRPdXdPWVo4ZG5DYTJqejZUbThFK0pN?=
 =?utf-8?B?MFdMMUlnRldQWk11N0FPcTEyZWV0bFR6SWNmNUZQcTlKcmtwb1NzMmxZZ2NQ?=
 =?utf-8?B?NWZGN3lmZWMxWmhKVWhCRll6b3FSbmx3alIxc0RCR00zMm5DNkdKQ0o3V2Y4?=
 =?utf-8?B?a09QOHhlMTNHVWh4SVFVbXdxYmkzWmdNaWdIY2hjU2ZTMm5Bc1BiSCtDTkJ3?=
 =?utf-8?B?YWtETDhCY0J0RDFqNEl2MlMzLzRvaCsrNVozbk8wd093N3E3LzZyYXFJUkl2?=
 =?utf-8?B?R0VHSmVNMkM1dGI2dzh4REw2UUVva3RodlZueThIK3FTc2dwVkJMTXhZdm9J?=
 =?utf-8?B?cEZsczZweHhLQjlhVHpwb2owQWdkUWhicVR5NWJuNThMUzFqMkRhb0UrZStD?=
 =?utf-8?B?blB4ZDVRVFB0dDVTeGZYTXRILy9iYzJ5bWRVVnhTenkwOGpKbGphN09XUWpY?=
 =?utf-8?B?ZVVISjNCTXJUdEp0RmxaaGxCYk45YjBMRDlNR0JJNFRsYTRLRjZMVWxiQ1hx?=
 =?utf-8?B?RVRRcUZtMVRnWGY2MjN1MUFTbGV3U0F5MWJVWmhZeGlYUHljK0NuU0JJNDBX?=
 =?utf-8?B?RFdJV21QRTB6cTd1Yko4ZmxOVWRXT2hnamxlcnJHZVBGOFdZRllFbDViMzFD?=
 =?utf-8?B?cTB0VDlYUWxvLzc1MkRIT1o1Y3p6OEdza0JPaXNRVlllNXFxcHdVNmE0OWRB?=
 =?utf-8?B?MHI5bnRMcVhRblZtT0JYRDM5L1VjRWVWNjU3dkQ4WVAvMlY1SFloalJVZ1BQ?=
 =?utf-8?B?ZmQ3eTJYOEV5SW9veTZ1SzJvTGV0d1kxOGdEajljdGJTcGpjVHE3b1JpTlh0?=
 =?utf-8?B?cm9ZQlBQQzVCNHpFMzR1R2JRei9pcXRlMWszTVM4bEZ5SXRMeXlqN1FFYlFz?=
 =?utf-8?B?NFJyM3hhUmNMNTArcEF2UmEvSThpbXlzVW0xZFM2aUhrelFSZVJWVWNMcEJv?=
 =?utf-8?B?MDRPWWNjTlhoY2NvZ0l4K3E4QmY2TmVaRmcvOWZjcE9mM2ZaMXh6eWZKVXBr?=
 =?utf-8?B?ak1UUGtlb1lEQ1JCL2hycldYVXVRK3VZZkFTZWVOMS9rTFdnRnZ4bU9GSDY2?=
 =?utf-8?B?T0c0VkVFOUt5MGZiWnpLTUJ4NlU5VFFRa3JhMElVYVdKTmZtRXBqd3hzd1N3?=
 =?utf-8?B?by8xNVV4TFNnU0ZyNGxFR3RBanR3d2I3NVNIUy84eWFPL2NvRGpIQTRjcVkz?=
 =?utf-8?B?VCtyOFNYUFkzek9jKzNNY282bG9oRE5wSWwwVjVkckJtN0xDdmI1KzErd25v?=
 =?utf-8?B?eXN6Y2YrL3EyUlphMU45OGsrVytKeFdiS0Z6b3BEZUc5RTM5M0Iramh6QTdX?=
 =?utf-8?B?QkxCMURwSGZrRzdTVk52MHhyc1hXNXJxT0gxbnFMdy9FUGo2ZEFKdkVjYytW?=
 =?utf-8?B?ZGV1MGlaQnl0am1WeldaTSsxaTVuS0NScDRCellBL2ZVU1AwQzR1VzdhdjUy?=
 =?utf-8?B?RE1zejRhRW8wbk9OMWxnZkgvNXFFV1pLc3BtZmJ4Y2tjb1B0YUhLQkcyMUZ6?=
 =?utf-8?B?VThIV0VQUFRIeC92aUIzNFRaNE1jZEl4Ykk2OGM2bWtQVktqRDJha3BneC9T?=
 =?utf-8?B?YkY2MnJUdUI4ODJ6eDFZQTZXU2RZMm1KQ2FiRDVzSGx0S1R0cU56Smp1WEgv?=
 =?utf-8?B?UzFMR3R5WmZ4dmVBc2Z0SDQ5eG1pbVJCb2NET2d2elRxRU9rcnZ6TlFuZGRN?=
 =?utf-8?B?dktWUUwyRjZTWG9SbHpHTVVrTjEvaGhJcDJCQTgzUmpFcHpHYWtVcGFiWWhv?=
 =?utf-8?B?cFdmZEVldk91KzAxNVRkS3RJZUltdFFHTWJmdHd3UmlUSE8rSlZFVllDSUFP?=
 =?utf-8?B?MEduT1JPVkFPVUtJbEc4T2ZNUHowR1NYb214a21UcjFwRWhndWxOeHVHd0lp?=
 =?utf-8?B?Tm9FZDV5YmVRNkpvNmVTa2xJREx0c09MQmN6YlBwM0Y2R3RlYk5mbzlQQ3VM?=
 =?utf-8?B?TzllbGxDeTIyR3h5NzBaZHhSQVl3R1RoaDBmTEJuNzU0WFFocEpDNzQrYmM4?=
 =?utf-8?B?SFc1VytERllGNy8xSk8rdHQxRk9oSDQ1VTI1a1VPOGNaK3hjanJwRnI2M2N0?=
 =?utf-8?B?bG9xRjY1QXMvRi9FR1c4OC9TOWd4aTl5OERYNFAvWE5qd05RcFlrbjZiMDNw?=
 =?utf-8?B?UnNzY3d3ZlhtK0FaKzhZNndQN293eHdobG9acit4ZU8zbEUxc2xzWVV0ZXVm?=
 =?utf-8?B?TVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <49975038B27818408F1A46EC8CB0E2CB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ba547ce-24d0-42d6-66aa-08dd94c759ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2025 22:16:48.3962
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WiIzEDhUtliF85XTUGNvzk0XKP28Jy5LvRaah5ZzWeY1AeePa1FBKbKOkwGy28Uvl7buJjKNt4m7pc+J26nh9jMBz1aC+lCeJkDEmo9cd/8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7206
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA1LTE2IGF0IDE5OjQ0ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gPiA+
IFdoYXQgZG8geW91IHRoaW5rIGFib3V0IHJlbHlpbmcgb24gdGRwX21tdV9zcGxpdF9odWdlX3Bh
Z2VzX3Jvb3QoKSBhbmQNCj4gPiA+IG1vdmluZw0KPiA+ID4gdGhpcyB0byBhbiBvcHRpbWl6YXRp
b24gcGF0Y2ggYXQgdGhlIGVuZD8NCj4gPiA+IA0KPiA+ID4gT3Igd2hhdCBhYm91dCBqdXN0IHR3
byBjYWxscyB0byB0ZHBfbW11X3NwbGl0X2h1Z2VfcGFnZXNfcm9vdCgpIGF0IHRoZQ0KPiA+ID4g
Ym91bmRhcmllcz8NCj4gPiBUaG91Z2ggdGhlIHR3byBnZW5lcmFsbHkgbG9vayBsaWtlIHRoZSBz
YW1lLCByZWx5aW5nIG9uDQo+ID4gdGRwX21tdV9zcGxpdF9odWdlX3BhZ2VzX3Jvb3QoKSB3aWxs
IGNyZWF0ZSBzZXZlcmFsIG1pbm9yIGNoYW5nZXMgc2NhdHRlcmluZw0KPiA+IGluIHRkcF9tbXVf
c3BsaXRfaHVnZV9wYWdlc19yb290KCkuDQo+ID4gDQo+ID4gZS5nLiB1cGRhdGUgZmx1c2ggYWZ0
ZXIgdGRwX21tdV9pdGVyX2NvbmRfcmVzY2hlZCgpLCBjaGVjaw0KPiA+IGl0ZXJfc3BsaXRfcmVx
dWlyZWQoKSwgc2V0ICJpdGVyLnlpZWxkZWQgPSB0cnVlIi4NCj4gPiANCj4gPiBTbywgaXQgbWF5
IGJlIGhhcmQgdG8gcmV2aWV3IGFzIGEgaW5pdGlhbCBSRkMuDQo+ID4gDQo+ID4gSSBwcmVmZXIg
dG8gZG8gdGhhdCBhZnRlciBQYW9sbyBhbmQgU2VhbiBoYXZlIHRha2VuIGEgbG9vayBvZiBpdCA6
KQ0KPiANCj4gT2gsIEkgbWlnaHQgbWlzdW5kZXJzdG9vZCB5b3VyIG1lYW5pbmcuDQo+IFllcywg
aWYgbmVjZXNzYXJ5LCB3ZSBjYW4gcHJvdmlkZSBhIHNlcGFyYXRlIHBhdGNoIGF0IHRoZSBlbmQg
dG8gY29tYmluZSBjb2RlDQo+IG9mDQo+IHRkcF9tbXVfc3BsaXRfaHVnZV9wYWdlc19yb290KCkg
YW5kIHRkcF9tbXVfc3BsaXRfYm91bmRhcnlfbGVhZnMoKS4NCg0KSG1tLCBJJ20gbm90IHN1cmUg
aWYgdGhleSB3aWxsIGxvb2sgYXQgdGhpcyB2ZXJzaW9uIG9yIHdhaXQgdW50aWwgSW50ZWwgZm9s
a3MNCndvcmsgdGhyb3VnaCBpdCBhIGJpdC4gQXMgZm9yIHJldmlld2FiaWxpdHksIHRoZSBsb2cg
Y291bGQgc2ltcGx5IGV4cGxhaW4gdGhhdA0KdGRwX21tdV9zcGxpdF9odWdlX3BhZ2VzX3Jvb3Qo
KSBpcyB0aGUgc2ltcGxlIG9wdGlvbiBhbmQgYW4gb3B0aW1pemF0aW9uIHBhdGNoDQp3aWxsIGZv
bGxvdy4gSSB0aGluayBpdCdzIGhlbHBmdWwgdG8gc2VwYXJhdGUgb3B0aW1pemF0aW9uIGZyb20g
aW1wbGVtZW50YXRpb24uDQpJdCBjYW4gYmUgY29uZnVzaW5nIHdoYXQgaXMgZm9yIHdoaWNoIHB1
cnBvc2UuDQo=

