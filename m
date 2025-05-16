Return-Path: <kvm+bounces-46842-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 34A0AABA1EC
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 19:36:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C013F17B474
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 17:36:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18222272E69;
	Fri, 16 May 2025 17:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mav9xvmW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF03418D656;
	Fri, 16 May 2025 17:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747416985; cv=fail; b=Vbru4cvxgOI8NxURkWrrI9XIher2ZWB/0f4jslK/2dTAjPcdFm85u4drzeCL7WJNAYB92DmKbfhRdsjJVkH3ii9GOk78sy0Rees/z4lBpNmyUZKr+Md9oJWlxtkZyljxtViTCcXqFooFWYLCmI/xc2jdSEJZqRbdybzEsUdG83A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747416985; c=relaxed/simple;
	bh=YFOmjq/obXYGXkTv+fuhcJXfqEUMX3krn6N7tX4uhcQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=euBAmqIuwJFvBekx7fZ745pPpO3PDJhSTTtpfYdJSfNQH+NkIIcpkYClHN9+e1mIhSZ2s4XwxDYDVwHG1G+1GjLOX4aozGuZCz9tZOY3UwI0FSpeogUO7txJh2oqsFkimdKQLMFZh3pINAQOWxw+PppwAwSkyxkYuOyH5tLnwow=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mav9xvmW; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747416984; x=1778952984;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=YFOmjq/obXYGXkTv+fuhcJXfqEUMX3krn6N7tX4uhcQ=;
  b=mav9xvmW8imh1mkvwB19rSWMjELVvzFlBe4QXpb3VsNb0OvXf3uHWFJB
   q3qogxgI97XDa9VGZQphuiH5HvsRPVx4DVOxzSX4JvUyvDrvSysQLRYY0
   mvKbp8zRwVqo+5u6dGuMd5XHKa8bBiIESiBdMGmupPgJbbgkM6FslClb8
   qFclzOfrcud2Zfv0ssjM53A9QQkowpaKXCz6c3eeoxZnXGVXzRONqn1hh
   ybH0+eBFjbu6YEqUep2BOGdT34i8bHN4oZpAOs8H8wuY6nXVT/Uq5d/0+
   a40McHLWnUvXmMmM6Fzh4Qx5uTKPJEDFA3XW5qL3tYpEQ4zCubxlbV0Bt
   A==;
X-CSE-ConnectionGUID: +K5hiNZtS8KAekIhQra1jA==
X-CSE-MsgGUID: t3fIJ45cTXW/bnnO4ds8Dg==
X-IronPort-AV: E=McAfee;i="6700,10204,11435"; a="60789218"
X-IronPort-AV: E=Sophos;i="6.15,294,1739865600"; 
   d="scan'208";a="60789218"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 10:36:22 -0700
X-CSE-ConnectionGUID: Ur6s1KsnQ+atxwaQjeAn7A==
X-CSE-MsgGUID: oha+rezIR2u3mnyVrt8k0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,294,1739865600"; 
   d="scan'208";a="142749065"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 10:36:22 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 16 May 2025 10:36:21 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 16 May 2025 10:36:21 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 16 May 2025 10:36:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UHPWovqcn4okkBmLtsvaoBbcBUTFmaLWzUIxPU8Hc1yXvdLpxQJWTeH6OvJW3tJwgGSONMqfEiM48zyw8RQ2P+TdgpYlRdi2F8uzBerKxZ2zULew5erDiQ3rqLFutqIQvIks+Rt1KYI4Lpd6fIb8lRJBWmktv4n++iKq4F30cxmBrNco7TxTkZLoe5iwK7O7ojOaQF+41LWgVWICd4PyEgVuk9H0BXxOJHGh/utDKnuW3KyhsSmk0FHt28/hgxySarYTc4Fzz+6ImC6ElQWJShkr4JOXSj0OH+xx9gsOR8H9xGhwRLmLekbAAhoE67DP+r4di963A9I4GRjH6LLTPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YFOmjq/obXYGXkTv+fuhcJXfqEUMX3krn6N7tX4uhcQ=;
 b=p40DbyumK1O9jYqM0IbfrMy5Fm+1/GLi+WFk4kshyebN1p8aDsjMr50VYvUJHZxz6oFWsrd1DBszkGyoA2/MhiIHpS+RfDSs3EzXaf0eVsdz3lJhDdKU4NeF/InHU5c7txagov2p7gdowUUFH/TZ8Hnti3cOe/GZJT1eJ6eZwRiv/WXn9e5k8HXEP8uqVB1ytrYyxlRtIri+mnov4pj8pQVFhOys7RRNypzsUuE9jVH1Wmk4RuTcI8jLi20yBeypkgG2gOKeHfbzUm1Z84tr4EC8Or2QV4NcxjCIQCt72QqtkMDbVWPDivYf2uh1XGW7s6GBECuuX5xDdehrNwNF5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CH0PR11MB5235.namprd11.prod.outlook.com (2603:10b6:610:e2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.32; Fri, 16 May
 2025 17:35:16 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8722.020; Fri, 16 May 2025
 17:35:16 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "Li, Zhiquan1"
	<zhiquan1.li@intel.com>, "tabba@google.com" <tabba@google.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"seanjc@google.com" <seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "Du, Fan" <fan.du@intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "Shutemov, Kirill" <kirill.shutemov@intel.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 07/21] KVM: TDX: Add a helper for WBINVD on huge pages
 with TD's keyID
Thread-Topic: [RFC PATCH 07/21] KVM: TDX: Add a helper for WBINVD on huge
 pages with TD's keyID
Thread-Index: AQHbtMYReEDdaL+lSEC7fDtKyq53g7PREQCAgAOjpwCAAPORgA==
Date: Fri, 16 May 2025 17:35:16 +0000
Message-ID: <cd64ad0cdfd00cfb106923112f916b102337724e.camel@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
	 <20250424030549.305-1-yan.y.zhao@intel.com>
	 <40898a3dc6637f89b59c309d471d9f4a8f417a9e.camel@intel.com>
	 <aCarAoK2C2bcki66@yzhao56-desk.sh.intel.com>
In-Reply-To: <aCarAoK2C2bcki66@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CH0PR11MB5235:EE_
x-ms-office365-filtering-correlation-id: 6a575846-4947-46f7-8d83-08dd94a005a4
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?OSswR1k5bVFiNmRlZTRVdndGUTYrZzA4QWwxeHc2cVpwcEM1aUpKWGNkeDVN?=
 =?utf-8?B?QkgweUdIaURhL2VpWU15M2p4emZOUmdEOE1SVGJ6Vmtybnpzcnk5K0FqUmFW?=
 =?utf-8?B?emw0aTJOR09URDJnTS9QVFY3MFR6VWgvZFZLOWNsUWhqNlg2L0hYUGpQVEE1?=
 =?utf-8?B?M3lKWWwydmNBWHlScHFJemJqenMrdEd5V2cyRHowRnJ5WmU1WjYvcE5wTFJZ?=
 =?utf-8?B?L1BTMmJQTFRDK1MwWTlId2orQTJtc0t1NVlrakprdmY5dEZwZ0pOMGRrMkZG?=
 =?utf-8?B?Vi9jSEN5SEJiYVlrc0RmSzlXaVhrb1F2SmJrR2I5NWRLNVFVa3hUSDdTaGJr?=
 =?utf-8?B?dlRyK3dMSERSTDY1NUtlSm9kMlFpR0UrZmhKSkpTR2dya253Y2VBVlNqdkdH?=
 =?utf-8?B?cHUzN2FZS1lMcnF5K3pLcHFLbXN0KzFRVUQzWDBDUDEyS3dDTFdIYVhTdjU5?=
 =?utf-8?B?aURyalQ1QXF3aTVWU0NYbUNWdFdOZVo1WWUxY3dHUHVHV2tvZ1RNVWF1NUZr?=
 =?utf-8?B?am1oL2FLdWlYSlZoTVREcUJ1QU5MNTc5cE9OWmRqTWo0NzM2V0JTZVdHZHYy?=
 =?utf-8?B?WWlYZjRZRCtNN0RCcGl1SnUzTEtKaEVCR1NvRklSd1JwczNIbmUwMVJaWWVL?=
 =?utf-8?B?QjNwYk5QaEQrOHN6RVR5UlR6dENnWTJ0MUhmYlBzQTVXb1V4Ulp5MGE0TW4w?=
 =?utf-8?B?RDkxYUlBRmhmazVtMlRNWU14REtUNXBBSTZKTDJCYkJKWUpXblFTY2swSHpz?=
 =?utf-8?B?Zkp1MUlaNVBSMUhUbERMd1VOYWJnSVBadEJpSE1pcFRXdWJlcStXNXRLUms4?=
 =?utf-8?B?WU5ueHlnNVdKVXQxNjEyQlJTcUZQWXd2Q2x0OGhUdGtHTmMyUllXSnZyUUp4?=
 =?utf-8?B?bWM5anVYZFpPRnpteUlVS0YraGhjOE5ORnlRNFZuWlB2RFNISmM2b2U4eWdr?=
 =?utf-8?B?VjNLVmVEYXJPQWpFNmZ6aWk1SGhZd3hFZnJOSWVnV0xvM3ZlRkZrV25hVkZ4?=
 =?utf-8?B?VS80djF2OElXSGlCRXJqMW5XNmRLc1NXRWVZblZGcUNHRlgwWWtCaDlNU01l?=
 =?utf-8?B?TThmTEVIaGRSOWs4Y2UxVm56R2hQSDAyclZWTjZzaXVpUFFMTUdnTUY4KzEv?=
 =?utf-8?B?VzgwUHdpVU5BOVlpQjFGSWNmU1dESTBSL2V2SFR3b0hRTWZHY3FYNnR5Mm4y?=
 =?utf-8?B?QnRGTXVEMmE5d2pkU3RKcmU0QWlrNFhqUVhBSkM5MXlXODA1Z0hxR25Fai90?=
 =?utf-8?B?TmwzWW1jeWhzQlNkZEc2NmttaXRaK0NSQ2lsS1c4YXBpQk5SS29oeU05Zkgy?=
 =?utf-8?B?a2lVYmc1cXRYa0JkcXNrbjBmeVUySnNuVVBhMXhXLzJqa2NBWlpucUtBeDFj?=
 =?utf-8?B?YkFNdUVKYm9PSjlueGtNVmozZlRmSXFUam5hcjlLd0ZSMGR2d0RtQXhYTGVU?=
 =?utf-8?B?aW5paEJKMGRXeEtRMHdpVk1xVG4vOGNQV0FEM3h2MFFOOHQ1dndoTXN2aUsw?=
 =?utf-8?B?U1RoakN1U2VqaldseTZ5Mzl5UmNqZ3hIOUR6ci9Jc0hXcGwrM2JMSXovQzFS?=
 =?utf-8?B?cFhyM3RQUkhMMW5WbS80RU5LelFPZG9pRGlIUlpQVFN3L2t3dzdZM1NHdEpQ?=
 =?utf-8?B?cklxc21CRzA5SkJwS0ZaNGR5MHc3Q09CZDU4bXNTY251bTNkU28zOUZSY2J2?=
 =?utf-8?B?NlhCaGN5MUhsOCt2eWpvY1psZWxKZVRUZzVJMEt1dnR5c1Izc201cjhhZ3BF?=
 =?utf-8?B?TWJuQi9nVEZNVlZ6UjVMaUp6YkhRR3JqUmVhNlRqZExLM2k3YlNlSU53Zkkr?=
 =?utf-8?B?UG40LzdmZnNqZzZJMU9zWFJrcHRGRGhaYjUvc2RZakRMQTBFT1g2aldzQ1pl?=
 =?utf-8?B?YUNNL1BDS0g1aVV6K2N1WVJZZVUvTXpua2hld1BkSU00ZzJ0cjd5bHRaalgr?=
 =?utf-8?B?UnpLMFhjdmlLZm43V1grQ0EwcllDTmRTcGo2NVJ5dG15SlBzZG41SVl0R3Jy?=
 =?utf-8?Q?e7fyd45m/QkRzmVYvglH/2VnWIVAKM=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b2Q4amJ6cjlTQ2tkSisyVjhSNDcyNlBGU2lQaGFrK0tpT05KUWQ2ZkFsTWJa?=
 =?utf-8?B?anhXR3ovdHJUcEVDT21SeGgwS3I1ZVlyWFFsVVVzYTJHSmo4MWNGM2Zadi84?=
 =?utf-8?B?RmJlWExIa2czVkFNUk9oNEtHb0cyTnVna0VXd09RMUpDUlNQSVJQZDBiUnF5?=
 =?utf-8?B?TnBZNjFDa01GNkh2dGVkSDhvZU10S2k3V3Y5QjNtNVRTUWpEYzVlK2xxbVlv?=
 =?utf-8?B?bjRjb095bjRrNDNyMURBMTBQVmluVXdVL2t1UW5INFUrdUJZeTZwRWNMbzNF?=
 =?utf-8?B?SFBPUXlHM2sweE9td09DSEV6bXpYamhYazVEdTdsdG9FRGZSUTFWOEhFNEVD?=
 =?utf-8?B?SkVXMWFFU0tpeFJta2FGbUgrOFp5TG9kTG1Tb1E1RHpVMlFiVVU3SzlYdzlL?=
 =?utf-8?B?bDlCd05INmRGUlJGeTh4S3F0QXdnaWMxWVRPbHpxV3gyQVZtM1NSTjVNakVO?=
 =?utf-8?B?V2VmWHpKYW0rS1EyMW9jVFZuMHBLR1IyNGh5Y3BzNmQrSUFsbU15SW9kdFg5?=
 =?utf-8?B?ZlpkcC9KL0hMeTA2RzkzM09OTU9KOUNEYUwzOEovT1BtRWwwa3lPNWw4c05t?=
 =?utf-8?B?clJkbk82ZHRIS0RsYVl1UDRYdUVRK3pzTFdlemx3bVp5RlRzOVdSVGFSYTFG?=
 =?utf-8?B?VUtuMEJvaGp1N3J5WGZZMzFZN3N5OW5RUmVRSEd3K0dPVUtpRWNTTzBwSG1t?=
 =?utf-8?B?c1p6Ykp3ZGp3dW0wbHpmemxpK1Q2cWszS3NINklGV1B0WU9Mb3pOOXU2YjVj?=
 =?utf-8?B?dm1QczJZR3Niemo1d1BkajhlMFFGWGVpVkpGU0pDZGs0NW9XMG1XcGcyQ0NU?=
 =?utf-8?B?SEFlU1F2VWFSV0VwTUdVRm9zTlVqL3hZMzAreG5GY1puTmZqVVozZlhmZ0hC?=
 =?utf-8?B?dTZmTkpKUVNUSmxwTUNlYzFvdTJmbkt2NzNEK3RlVzZXRnZsV2RWdllsSUQv?=
 =?utf-8?B?VXFqcUY2QVJBd0FhS2FQVFhkNmZKaWNra2NJOGQzUTE1WTNOcDlkSFBvU0VL?=
 =?utf-8?B?aDc0UFFYS0Fia1ErbnlBWmtucGhsR0hITVNLNUVYekd1SG4xYm13SDBCYUxZ?=
 =?utf-8?B?bFpyeWk2N21kTEw4Nlc1UmxyaUdBVmZqNUFpTzVtMGRjVjBDNHpWaitRVDRO?=
 =?utf-8?B?ZTUybGlvNXpkcGxHeWxSZ3JkdER1enBYNjRURWZ2RVN3dDMzSWlBQkF5RTVi?=
 =?utf-8?B?MXVXUm1SbjNxRHRpNEFXNVozbGZxTGZJd1hQMWYyNDg4dGJONjBiZEV2SEtI?=
 =?utf-8?B?RFhyRGNCR0dVdjN1VDlsTHdzTjV2SWJLYnk0QlNxcG1zaTVYVm8rNFc4d0ph?=
 =?utf-8?B?ZUF4SmIvK0owYTU5Y3NqUW9YaUxWTSt0TEZzdW4yVVR2VnVJUHNJYVZnVHRQ?=
 =?utf-8?B?S2tUcFVIVXhPdDRmdTV4MWRwblFxd3FZbTA0Mzhob0hrUjhHWkNjOU11NHZp?=
 =?utf-8?B?WHZ3L2ZpMGNzRE80Mm8xWStpMWZxWnV2OUNiV2ZrT1ptZzIzVnMrTG5xK0tO?=
 =?utf-8?B?V3hzYnJLV2Vhb3N0RHB5SDNnTjZjMlNBRjVwWVl1anNxY25yVVFzVU5WcWVI?=
 =?utf-8?B?UzBySVQzOFJJb1p5Mkd6NXpGeGxYSnVmN3BnZWwyVEpjb0hReEpmb3lKL1FK?=
 =?utf-8?B?cEFzcUNNWGp5eXVqcUhQQ0hSd0JQK2Voa2Y1MkVWUVhpZnhMRUtIQk8yQkZB?=
 =?utf-8?B?RHorci9lNzlUVmhCc1BoRzdsOERSaFZxcVlEdTVOT0VnVlFGeUR5dm5lak5T?=
 =?utf-8?B?SEIzcEVsTFZ2MWt6emZhNnpBUG1CMWtRUnE4bm1SREpPMEZsT004OStHZnln?=
 =?utf-8?B?UFJ3ZnF1OXpndElDdTgxRHhpNU9LVU1WMHA0RDNTbWo0L2VndFJDR2Q0Q3Jm?=
 =?utf-8?B?UUNGaVA3cGVRRHpIWmFkSzc1ajNTdjV1ZDR3QUdqeUNzN1NMOTNvdjUzajl3?=
 =?utf-8?B?bGt1QzAxdVJ2SGlCcmNmVVNOSFBYT0RaSGREUEttWTlsanRUTTlsamk3NndP?=
 =?utf-8?B?OWJiWnRmOG5wTXZGVTIxY09hdWcwT1NBSHcrQmVmajY5ZmNXZzU5dVNBTExM?=
 =?utf-8?B?MlZPTEJMTTNyendhS2p3NmxWN2htYXdVNXFXWG1kUVdYS3ZndExTNGZwUThj?=
 =?utf-8?B?UXoyR0x0WG0yWFFVVlFTN3htdWx5TXlQajRXbTliK3p4ZnFOQXIxNFJSVU91?=
 =?utf-8?B?d1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EEDE11FD36957A478578C92F86BA42B9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a575846-4947-46f7-8d83-08dd94a005a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2025 17:35:16.6750
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L9LozHIQ9mOALKffnromcyH6OgbZ7lUo+dxz5pW8Xw+2WKpsJT2uf95VD2Ix/RAiMznQj6/DuYwBwGOYqz01Tr/mQ3R4wPoxAaByNwYAN2g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5235
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA1LTE2IGF0IDExOjAzICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gPiBI
bW0sIGRpZCB5b3UgY29uc2lkZXIgY2hhbmdpbmcgdGRoX3BoeW1lbV9wYWdlX3diaW52ZF9oa2lk
KCk/IEl0J3MgdGhlDQo+ID4gcGF0dGVybg0KPiA+IG9mIEtWTSB3cmFwcGluZyB0aGUgU0VBTUNB
TEwgaGVscGVycyB0byBkbyBzb21lIG1vcmUgd29yayB0aGF0IG5lZWRzIHRvIGJlDQo+ID4gd3Jh
cHBlZC4NCj4gU0VBTUNBTEwgVERIX1BIWU1FTV9QQUdFX1dCSU5WRCBvbmx5IGFjY2VwdHMgYSA0
S0IgcGFnZS4NCj4gV2lsbCBtb3ZlIHRoZSBsb29wIGZyb20gS1ZNIHRvIHRoZSB3cmFwcGVyIGlu
IHg4NiBpZiB5b3UgdGhpbmsgaXQncyBiZXR0ZXIuDQoNCkRvbid0IHdyYXAgdGhlIHdyYXBwZXJz
IHdhcyBhIHN1Z2dlc3Rpb24gZnJvbSBEYXZlLiBMZXQncyB0cnkgaXQuDQo=

