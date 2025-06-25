Return-Path: <kvm+bounces-50704-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9051BAE86FE
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 16:48:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C49BB1888FE1
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 14:48:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D78F26528F;
	Wed, 25 Jun 2025 14:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nRSV+km/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E992135A1;
	Wed, 25 Jun 2025 14:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750862873; cv=fail; b=FxpqV3ykEY2AidKFl94jGCXSUfHUQogSKz6TsZnvQ5QTOfVRvFDw7qhmBQMijzgq9xCBZdhkRm0z2CAw5UapgkWbG/D1YDxwO+7TVVnRkvW1MaV3rIyGKcz0+n3tBCYasF/QOKIh5R03Le+AVBfSLSPM2s5dmN4T4WkFjsEkHds=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750862873; c=relaxed/simple;
	bh=vugHevjq0Yqg0jTYQAiVZDYfytU7hcqHpl5Zzg30rvU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=mtOxH3USebl4nCQifFzeGsaCUln33Xh+FIg/1uB4Xk05e5vtLyX5/rqvvkl3iUFl4G+LVV1/VJsjO/WF3xhFLCMwo8183TJ1fJEvuJa4s8wFQfX/dIuM6AzHKRyzXE5x2Lkq/dpgazxU6zSQwpYmejJ7dE0U6hw3G5sKE7/EtpQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nRSV+km/; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750862872; x=1782398872;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=vugHevjq0Yqg0jTYQAiVZDYfytU7hcqHpl5Zzg30rvU=;
  b=nRSV+km/Jw7Kbwnslhg1MaHNk3R6eZbWOh/Fb1n05qdutup3IJzf0z6e
   B17a4pGQWbXAhXt8dAZLKkG0VpvqtViZrJikG1mzf1JPOOftvgUVPMUel
   Akf7cIdG4vBMnMXuOiygFsUcmkXUDEjoPJkSL376k+upssUj6/KhOpOdp
   hzpra5UtuWdBaUdxQJqA34e2P/NEByQN/vG6dK3eWGTaWF8NUlqkLsInE
   meMfy2usrP4rrXF6m3F9G9jXHaOuG48nspnPTOW/pcV2IwrLGakbj3VsX
   nM4A5D1Vhg0AgdkkAV+YBEJjZr3opFbHvVEt91U5Oa4yxE7/MbGP6SQc6
   w==;
X-CSE-ConnectionGUID: rhM781JnTROajEcIGOwrsQ==
X-CSE-MsgGUID: QiWVkWY7RdiNB1FsEF0zJw==
X-IronPort-AV: E=McAfee;i="6800,10657,11475"; a="64492679"
X-IronPort-AV: E=Sophos;i="6.16,265,1744095600"; 
   d="scan'208";a="64492679"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 07:47:51 -0700
X-CSE-ConnectionGUID: pOaUwlOiQH+t0E1N0kxehw==
X-CSE-MsgGUID: AMqYD+ojQ+GEuM+499dD4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,265,1744095600"; 
   d="scan'208";a="156636800"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jun 2025 07:47:51 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 07:47:50 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Wed, 25 Jun 2025 07:47:50 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.70) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Wed, 25 Jun 2025 07:47:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oSavIvm6avapctEe1RTUDd9OoefXqil4debotStHjamVDMQroE31+3h6NfV838nc98CnDL+sRI5DqNU0vHrS3rFEOdeuZnj6o+2dKaowFLT7883ivOCPGhKsp9nqvXgNd+7vvo/psOxVmFT9K0bXRBVRDPgHv4m6QL2FqoIspfBJpv9Lh7VY7Xj+e31k8bwciASJRF17pKEGJK/qFOpIyYEyMNHsVpXbmn+IDnNzqkA7uNjh/dWkB5UeRgXqEBoD6ws9LU/0HuNgf0xH+a95f2zCz7idWxWkypLQx3WGN6EfHuMnZh8ETYoJH9DL3RKnHa/8Nh0veWCdxFZgirI+ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vugHevjq0Yqg0jTYQAiVZDYfytU7hcqHpl5Zzg30rvU=;
 b=TcNfqCTivnnXnZoAlKNT8moTwUZoGsJZRDFxLC5F/TidHww2FqTtmfR9nOQ9mndYse4+Ilf21qfZXxKoqNTFfNNUNOPNFau3b/RUKdouKdkHeG8lt5PuW6b30+i/xi6zyJwD3jMkLPNECGpw1XylPtwl8BFM+m0I2QCA9ZTOhjPXpQ6PI0hmAMCHVl0foQQShOQWSmyVDz9sU9iOy7VoeoOVbj8MQ4O+JFGqBIQZl9Y3WzYWJCKTW6ALBc0x+2H8cH+v6DX7FEy/MILgFZZzAX+QEv8L5dQ9JgkzUK8dsXuS+gqNkAJTyfkZ9CMGxQgwFOn5a7eli94ZRt1b1yr5Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS7PR11MB6126.namprd11.prod.outlook.com (2603:10b6:8:9e::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8857.19; Wed, 25 Jun 2025 14:47:47 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8857.025; Wed, 25 Jun 2025
 14:47:47 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "Du, Fan" <fan.du@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"Huang, Kai" <kai.huang@intel.com>, "Shutemov, Kirill"
	<kirill.shutemov@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"david@redhat.com" <david@redhat.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "Li, Zhiquan1"
	<zhiquan1.li@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"seanjc@google.com" <seanjc@google.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Annapurve, Vishal" <vannapurve@google.com>,
	"tabba@google.com" <tabba@google.com>, "jroedel@suse.de" <jroedel@suse.de>,
	"Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Thread-Topic: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Thread-Index: AQHbtMYisXlDVaH8LEKqVl1+c9iQ77PRHICAgAN/mYCAAIg5AIAA1+mAgAPLQICAAIwTAIABF74AgADuIICAIfsagIACKESAgAALWQCAAAHGgIAABSeAgAAA3ACAAAyHAIABVQyAgAAHeoCAABSygIADYjmAgAFIQYCAACKZgIABjCaAgAQxHwCABQ5egIAAzNwAgACQ3gCAAPlVAIAAWTqA
Date: Wed, 25 Jun 2025 14:47:47 +0000
Message-ID: <0930ae315759558c52fd6afb837e6a8b9acc1cc3.camel@intel.com>
References: <aEyj_5WoC-01SPsV@google.com>
	 <4312a9a24f187b3e2d3f2bf76b2de6c8e8d3cf91.camel@intel.com>
	 <aE+L/1YYdTU2z36K@yzhao56-desk.sh.intel.com>
	 <ffb401e800363862c5dd90664993e8e234c7361b.camel@intel.com>
	 <aFC8YThVdrIyAsuS@yzhao56-desk.sh.intel.com>
	 <aFIIsSwv5Si+rG3Z@yzhao56-desk.sh.intel.com> <aFWM5P03NtP1FWsD@google.com>
	 <7312b64e94134117f7f1ef95d4ccea7a56ef0402.camel@intel.com>
	 <aFp2iPsShmw3rYYs@yzhao56-desk.sh.intel.com>
	 <a6ffe23fb97e64109f512fa43e9f6405236ed40a.camel@intel.com>
	 <aFvBNromdrkEtPp6@yzhao56-desk.sh.intel.com>
In-Reply-To: <aFvBNromdrkEtPp6@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS7PR11MB6126:EE_
x-ms-office365-filtering-correlation-id: 6ee8e4c7-5ffb-4753-ccfa-08ddb3f74087
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?K1VhdmV2OTNueDZId3VMYkhGZUpFeUpMQThIaXlmUzg2V0Qrdm5RN3ZDbDNn?=
 =?utf-8?B?cys5aFNMc2ZlV2RCYmFhSDk1ZCtLaDl4dXU3TitiemhtSWc5cG9LQzJuUHc5?=
 =?utf-8?B?U09CeTh1KzJWdWdpUjR0N3JmTHppRnNCZDJNZDd3VThvY1lBUmxzOVVlMUhq?=
 =?utf-8?B?czlFQXZ1QmljblBqRFpzOC9FeW1PaCtQOVkzd04ydEZHZ1U3L1RkUEFiZDNN?=
 =?utf-8?B?Z3NLQWh4dEtjN3h4NEhQTzRoSFpRWEp6K1BFM2k5d3ZlUUZWYXYwQjFCRWlG?=
 =?utf-8?B?YWh6enRoLzFpSEZxMHFtdGgwWWZiSmw1Z0FraGhwREhHR09jNTg5NDlDMXEv?=
 =?utf-8?B?Z0MxV1o3OE5NVW9RaUhsZTI5ekxxdkpEbXUva0lTNlhuSEloOWpoSDBVamtv?=
 =?utf-8?B?SGI2ZTVCYlZPSzNrcDU2dDJGMVpNWUs0Y3lZY1U3UE1QK2M0RHNlNGFRdjBE?=
 =?utf-8?B?eUFKd1huZDV1dnpyTzVYdmFlclczYnZUTTFIa3RRMG1TMTcvdnhtMVh6MTRE?=
 =?utf-8?B?YjFNT3RJTnZFdjdNNnRkS0dXeGlOVkxUUi8wQ2Mza244cVRBL2M1aTN4bEly?=
 =?utf-8?B?YkEvQ3M2cFhJb3VGdzFPMjF3T2M5RlNGQ2FvYlFsb3NUdWsybWdlb1ovdFh1?=
 =?utf-8?B?SUFOamFaQmRucWc3bktCZFp3YTAvL2FlTzVMNkFLVnF3THlMbmVEM1liS2p6?=
 =?utf-8?B?ck4rT2ZkQVJQQVp6amtjSEptend0R256UitFQjFuTXd0S3JHd0hHZkg1TDlk?=
 =?utf-8?B?eFVCZXNSVTIrQWhZOTJtVGJhOTdqZjhiODMzM25IMVNlRkJIVDR6d1B3Um9P?=
 =?utf-8?B?SXpJb0VWMzZUakdGaXFsMTFwbzlUY3h5SlFTcUZqVThLdFNrSkRXT1ZUbG1h?=
 =?utf-8?B?aE5LbEJrSnU0V2Y2VDhHU2ZnU0c5VkRaWmxxYTlSWE1YZ1ZnYzlxS0FROWJN?=
 =?utf-8?B?RjVrdFNNbm1EeFpmMy9LMG0xNmVXNjFQcFRNbWowTEJhRHFIalpiWk0vRG5x?=
 =?utf-8?B?VzRtdGU0cWgzeWxTeXI3ZXFXRzI4WVkrMkttOGFJNE50MG55bzI1MGltVFQ2?=
 =?utf-8?B?dzhuM1VqNnZFTU5sYnVod1BqbEhLMUF5bG0yWUV2cUlWSWlQVUpVOW1ESng3?=
 =?utf-8?B?eE1VT0txM2VRK0J1MXlsRkJLUzN4cFVNb3NVaXpLajdmVUxlZzF4U3ZFM2g2?=
 =?utf-8?B?bnBBajk1WEtTQjlsaHNHSmo1WmU5YStST0JGVkdiRG5BVzRpK2FGZmZlQXVT?=
 =?utf-8?B?MHMyVGlTaUNXeHRtYU52NzRHWU5EdzQ5VE1kWXpTRUlQWS9XbjNJbXh1WmFj?=
 =?utf-8?B?RjcrU1ZSdjJhcTZNTmpJUFN0K1ZxWWUwUHBmbFRJaUlHODIwN3VCb3pJL1ZX?=
 =?utf-8?B?MUxVTGptK2NJYTNSNWRxZzJ6cy8xcFV0dkgyekhqQU5tYjZIN2VXS1N1ZDdS?=
 =?utf-8?B?V0pSQ05PSDY5RTY4c2NDblV4aHRVeGpaSzA0MlZIR1I5RUdwT3h2K1hWTGNO?=
 =?utf-8?B?dUVhdEFsczJjandyMGxrajQxVUFLMWY4RDhXUFpycFluTDY1T1JDUTBPNnJ0?=
 =?utf-8?B?WkJnWTFGVTdrN1NmdWxicDZ3cmVRZlRESXBNOUVoZXBBUTVVU0JjVDVCTFp6?=
 =?utf-8?B?amVad1pDTkd1RXRaeUJsaDBhN3JncTIyQnczbmxmRDRjUml6VE9GOUxGanI2?=
 =?utf-8?B?b2lVdCtUUGZabjlkZEhmWm14YjY4Y3B2ZUV1eWZMcmpCVzRxUjJQb001R1Zm?=
 =?utf-8?B?MlM1eDI2am5JZ1UzSitNZ2hxK2pEVnRZakx6dmVKb1hnM1Rac3RZWnZyKzJJ?=
 =?utf-8?B?eTZ3dmFhLytLN1NzbENkVjI0bXJLSnBvWFdSWFd2VlZmSG81NElScFFXYUZQ?=
 =?utf-8?B?bnkvT21MaVlUNHlyRFRoa1pTVjVxTXcvYk00OXlRM0Vvc05DWVBkMFhibGFi?=
 =?utf-8?B?TXc0ZmZxRmlndmVmN1gxUmpBYmQwaTdmL0liUG11N3VyU0swSU1aMExxY2dw?=
 =?utf-8?Q?l8ijIOkkCxNWar6w4PWCbO7MovMgXM=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c01HK3g1Y25OUkVIanh1NHZUS0FTTUg5Yk1lZkMwUlM4azAzeUxuanpFMXlk?=
 =?utf-8?B?blRTVG9sTkJmTVJudElaM1daQzlMZThtWmUzeGFVRElFQ1BvVC9pV3lpYTZn?=
 =?utf-8?B?K2tuQzR2a1NvdlR6Q2thWDMydjkxbnUraVhyb2Y0clJnbHh4dVlwVy9KQmNU?=
 =?utf-8?B?QzJLR1kycWhySnorb256K1UrYkhZMS8zd3RjSlRra0RNRzh4WFFrMHVWOXFn?=
 =?utf-8?B?R0pJQjgybEhKQXFCc3JtdW5mREhXNmE5Q1Z4SVMyVWhXL2hCN3FlSGdMd2Jw?=
 =?utf-8?B?c0p2KzliMWpIRzNtczhCRkoxQ0IxcWFlaHlnS2ZPWTRWQmlOcUdpNG9TZzBW?=
 =?utf-8?B?bkRtSkVJL0ZYQ0c3cGRZSm10THQydTlBYW1HcUtHMkNtdnM5ZzVQWk0xZE8w?=
 =?utf-8?B?QlNwdkRnR1pqU2hrTVR0YUdoSUQ0c1lVRGZNM1JWVHdNVjVickdwZUhNc1VG?=
 =?utf-8?B?VDhXUmRuRUhiYVJzWWFOQklRYXppWmFlZE9WUU1lVm1ja0N0a05NaDR1dmRZ?=
 =?utf-8?B?LzdqMXZucEFyd0lPZTV5OEJQWHM4dml4MnNOQzdFWjE0dWhtbU5keFZ5ODJ1?=
 =?utf-8?B?K24zMGFSc1Y4TGRSZXM0bS91YUphZ0ZPNHJNRzNlUWtVam1kY3lyWHpBdTV1?=
 =?utf-8?B?SzVNYWpoMFYreFhWenpHdTE5YlgwK2dsczg4SEpYQmhmMlZXNXI1QVEzajli?=
 =?utf-8?B?eUU5ak1nSjFxVzZ5aHdpVnVEbjFnSzJNeTB3Z09tejhJTUZzcEpjSE5ycFNF?=
 =?utf-8?B?OGM4Sm1kY1V0R1hnekkwdDlXRnN4L3Z0VTBkUndLbnNGdVZkTWRwWklRRlJC?=
 =?utf-8?B?a3Jwdk54eWJBNERVTWVNVis3MWFFOFI5NUhJU0NxZlJSSU1PL0gyZjZsUSt5?=
 =?utf-8?B?WmF6N0JreUxMMjI4SjVwd053b1ZkOVMzZkVXaklzaDBCMVlPd2xUekt1WGZv?=
 =?utf-8?B?SjgwdlF2dXE2WFgvbytTRXdSbE55clZzQ3pvL0srcWp5Y2NLbHZBVG81eXBE?=
 =?utf-8?B?Z0N2QjArTzJqVW5NbUhNK2ZaY0tEMFAxWXU0SytMZzk3UjFGM1M0NVNPT0lH?=
 =?utf-8?B?a2FEdW91ZFc4UkF3UFZwUUx3eUxjMzlZMG05NGJoNzdpb0Y1NjFIMW45OUpQ?=
 =?utf-8?B?UW8wRGIvRDZtRUhzdEZ5a3BkalhlcTZtZkQxZ1NZTzJBYzh1UU9BVGZMbm9v?=
 =?utf-8?B?U0xxbFhtVmFGbDZpMXBYaTY3SkY3YUhXUTRJckM0YTZIeU9ZdnoyR2dkQ0Ix?=
 =?utf-8?B?cW5UM3d3bmVzYkxrYTk0TVZIRmkyeThQYzl4NlBSdzk2dDdJUHZzMHA4SE9F?=
 =?utf-8?B?cTBsOTdtbXEzZVlRVGZOSmY0ZjhRSzJ6c01Zd1BhWFVCUDFpVlgzWDhkdE4y?=
 =?utf-8?B?Qm94Z3phcVp4cjU1cmJOZ0V1NXoxNUxaamVDQUxlSXhXZUJhMG9HS2k0VVlW?=
 =?utf-8?B?Nnlpekx1bzF3OFFmdWY5VVlaV2NzUXRXNGZ1TWNjamQwbTBZM0tlblp5YkIx?=
 =?utf-8?B?azQyRklZMWdJK1d0QVVISFBySVZ6Z1RxaG5oU3IydHI3MTNIZTJJTWRVWnND?=
 =?utf-8?B?bkY5Z25qVGdjTzBiY2t2eE04b254VzNub0UwMnMrWC9XVnVvMitTdUd6d1Nt?=
 =?utf-8?B?TVhTV0VEb0ptOEh1Um9zb0s4aktuekFDSmExNXNkNW5uNHE4UDZhei9sOXNv?=
 =?utf-8?B?K1BsT2dldkdGTXZlWWtPL2RVODFKWUhLU3lEaHR0Rk82RXYzdnFEMUlvRXoy?=
 =?utf-8?B?R1htbDNtVk9JNDhibXdPVUdWMXNZbHRhN0xaVHh2NVpSVGpaMGU0Zk1PMlJs?=
 =?utf-8?B?S0lCZTY0aVB4clBQWGlUeEU3QzBaZDBhRkF4YjU0RVlETHhMa296SFYzU3Rx?=
 =?utf-8?B?anczVk5BaUZ0WUxBSE9ZQUVkMlBoM1lkaUFlbFIvbFgva091Zi9aanlybzF5?=
 =?utf-8?B?a0pOQXZYMldubnJ6V0kwQUJ4b0h1OFJVbmJnaTNocjk1VUdtTzEvQzhjZlRz?=
 =?utf-8?B?cVJmU0tpazVhRTdDOXlTeUN6TlNCTm5ibWhnTnV3YkRhbDRSNm1LVkNNUGJ2?=
 =?utf-8?B?ZUVnQmYxNVNXV3pXZEt1Nlo3R2cyN0E0eWwwb3NvVlFOVm5neFpoNitMalFY?=
 =?utf-8?B?ME9vZU5uTWVqVXNORkJkNVV4YWlsUXpqQnU4TlZFNE1VSzErOWJlOWxJTU1M?=
 =?utf-8?B?Q1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C5338659C12C8B488CEC4FAD67988442@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ee8e4c7-5ffb-4753-ccfa-08ddb3f74087
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2025 14:47:47.7142
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wO1TQU8JKR1x0/lhpB1l+mcmQms395er6tiCokLpOMy266W8UdYBZyqzjBIkCxUFcZjjRryRLFRhClJecbWxWFRrW6FAoxXhIj9RWUz8B58=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6126
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA2LTI1IGF0IDE3OjI4ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gT24g
V2VkLCBKdW4gMjUsIDIwMjUgYXQgMDI6MzU6NTlBTSArMDgwMCwgRWRnZWNvbWJlLCBSaWNrIFAg
d3JvdGU6DQo+ID4gT24gVHVlLCAyMDI1LTA2LTI0IGF0IDE3OjU3ICswODAwLCBZYW4gWmhhbyB3
cm90ZToNCj4gPiA+IENvdWxkIHdlIHByb3ZpZGUgdGhlIGluZm8gdmlhIHRoZSBwcml2YXRlX21h
eF9tYXBwaW5nX2xldmVsIGhvb2sgKGkuZS4gdmlhDQo+ID4gPiB0ZHhfZ21lbV9wcml2YXRlX21h
eF9tYXBwaW5nX2xldmVsKCkpPw0KPiA+IA0KPiA+IFRoaXMgaXMgb25lIG9mIHRoZSBwcmV2aW91
cyB0d28gbWV0aG9kcyBkaXNjdXNzZWQuIENhbiB5b3UgZWxhYm9yYXRlIG9uIHdoYXQgeW91DQo+
ID4gYXJlIHRyeWluZyB0byBzYXk/DQo+IEkgZG9uJ3QgZ2V0IHdoeSB3ZSBjYW4ndCB1c2UgdGhl
IGV4aXN0aW5nIHRkeF9nbWVtX3ByaXZhdGVfbWF4X21hcHBpbmdfbGV2ZWwoKQ0KPiB0byBjb252
ZXkgdGhlIG1heF9sZXZlbCBpbmZvIGF0IHdoaWNoIGEgdmVuZG9yIGhvcGVzIGEgR0ZOIHRvIGJl
IG1hcHBlZC4NCj4gDQo+IEJlZm9yZSBURFggaHVnZSBwYWdlcywgdGR4X2dtZW1fcHJpdmF0ZV9t
YXhfbWFwcGluZ19sZXZlbCgpIGFsd2F5cyByZXR1cm5zIDRLQjsNCj4gYWZ0ZXIgVERYIGh1Z2Ug
cGFnZXMsIGl0IHJldHVybnMNCj4gLSA0S0IgZHVyaW5nIHRoZSBURCBidWlsZCBzdGFnZQ0KPiAt
IGF0IFREIHJ1bnRpbWU6IDRLQiBvciAyTUINCj4gDQo+IFdoeSBkb2VzIEtWTSBuZWVkIHRvIGNh
cmUgaG93IHRoZSB2ZW5kb3IgZGV0ZXJtaW5lcyB0aGlzIG1heF9sZXZlbD8NCj4gSSB0aGluayBh
IHZlbmRvciBzaG91bGQgaGF2ZSBpdHMgZnJlZWRvbSB0byBkZWNpZGUgYmFzZWQgb24gc29mdHdh
cmUgbGltaXRhdGlvbiwNCj4gZ3Vlc3QncyB3aXNoZXMsIGhhcmR3YXJlIGJ1Z3Mgb3Igd2hhdGV2
ZXIuDQoNCkkgZG9uJ3Qgc2VlIHRoYXQgYmlnIG9mIGEgZGlmZmVyZW5jZSBiZXR3ZWVuICJLVk0i
IGFuZCAidmVuZG9yIi4gVERYIGNvZGUgaXMgS1ZNDQpjb2RlLiBKdXN0IGJlY2F1c2UgaXQncyBp
biB0ZHguYyBkb2Vzbid0IG1lYW4gaXQncyBvayBmb3IgaXQgdG8gYmUgaGFyZCB0byB0cmFjZQ0K
dGhlIGxvZ2ljLg0KDQpJJ20gbm90IHN1cmUgd2hhdCBTZWFuJ3Mgb2JqZWN0aW9uIHdhcyB0byB0
aGF0IGFwcHJvYWNoLCBvciBpZiBoZSBvYmplY3RlZCB0bw0KanVzdCB0aGUgd2VpcmQgU0laRV9N
SVNNQVRDSCBiZWhhdmlvciBvZiBURFggbW9kdWxlLiBJIHRoaW5rIHlvdSBhbHJlYWR5IGtub3cN
CndoeSBJIGRvbid0IHByZWZlciBpdDoNCiAtIFJlcXVpcmluZyBkZW1vdGUgaW4gdGhlIGZhdWx0
IGhhbmRsZXIuIFRoaXMgcmVxdWlyZXMgYW4gYWRkaXRpb25hbCB3cml0ZSBsb2NrDQppbnNpZGUg
dGhlIG1tdSByZWFkIGxvY2ssIG9yIFREWCBtb2R1bGUgY2hhbmdlcy4gQWx0aG91Z2ggbm93IEkg
d29uZGVyIGlmIHRoZQ0KaW50ZXJydXB0IGVycm9yIGNvZGUgcmVsYXRlZCBwcm9ibGVtcyB3aWxs
IGdldCB3b3JzZSB3aXRoIHRoaXMgc29sdXRpb24uIFRoZQ0Kc29sdXRpb24gaXMgY3VycmVudGx5
IG5vdCBzZXR0bGVkLg0KIC0gUmVxdWlyaW5nIHBhc3NpbmcgYXJncyBvbiB0aGUgdkNQVSBzdHJ1
Y3QsIHdoaWNoIGFzIHlvdSBwb2ludCBvdXQgd2lsbCB3b3JrDQpmdW5jdGlvbmFsbHkgdG9kYXkg
b25seSBiZWNhdXNlIHRoZSBwcmVmYXVsdCBzdHVmZiB3aWxsIGF2b2lkIHNlZWluZyBpdC4gQnV0
DQppdCdzIGZyYWdpbGUNCiAtIFRoZSBwYWdlIHNpemUgYmVoYXZpb3IgaXMgYSBiaXQgaW1wbGlj
aXQNCg0KSSdtIGNvbWluZyBiYWNrIHRvIHRoaXMgZHJhZnQgYWZ0ZXIgUFVDSy4gU2VhbiBzaGFy
ZWQgaGlzIHRob3VnaHRzIHRoZXJlLiBJJ2xsDQp0cnkgdG8gc3VtbWFyaXplLiBIZSBkaWRuJ3Qg
bGlrZSBob3cgdGhlIHBhZ2Ugc2l6ZSByZXF1aXJlbWVudHMgd2VyZSBwYXNzZWQNCnRocm91Z2gg
dGhlIGZhdWx0IGhhbmRsZXIgaW4gYSAidHJhbnNpZW50IiB3YXkuIFRoYXQgInRyYW5zaWVudCIg
cHJvcGVydHkgY292ZXJzDQpib3RoIG9mIHRoZSB0d28gb3B0aW9ucyBmb3IgcGFzc2luZyB0aGUg
c2l6ZSBpbmZvIHRocm91Z2ggdGhlIGZhdWx0IGhhbmRsZXIgdGhhdA0Kd2Ugd2VyZSBkZWJhdGlu
Zy4gSGUgYWxzbyBkaWRuJ3QgbGlrZSBob3cgVERYIGFyY2ggcmVxdWlyZXMgS1ZNIHRvIG1hcCBh
dCBhDQpzcGVjaWZpYyBob3N0IHNpemUgYXJvdW5kIGFjY2VwdC4gTWljaGFlbCBSb3RoIGJyb3Vn
aHQgdXAgdGhhdCBTTlAgaGFzIHRoZSBzYW1lDQpyZXF1aXJlbWVudCwgYnV0IGl0IGNhbiBkbyB0
aGUgemFwIGFuZCByZWZhdWx0IGFwcHJvYWNoLg0KDQpXZSB0aGVuIGRpc2N1c3NlZCB0aGlzIGxw
YWdlX2luZm8gaWRlYS4gSGUgd2FzIGluIGZhdm9yIG9mIGl0LCBidXQgbm90LCBJJ2Qgc2F5LA0K
b3Zlcmx5IGVudGh1c2lhc3RpYy4gSW4gYSAibGVhc3Qgd29yc3Qgb3B0aW9uIiBraW5kIG9mIHdh
eS4NCg0KSSB0aGluayB0aGUgYmlnZ2VzdCBkb3duc2lkZSBpcyB0aGUgTU1VIHdyaXRlIGxvY2su
IE91ciBnb2FsIGZvciB0aGlzIHNlcmllcyBpcw0KdG8gaGVscCBwZXJmb3JtYW5jZSwgbm90IHRv
IGdldCBodWdlIHBhZ2Ugc2l6ZXMuIFNvIGlmIHdlIGRvIHRoaXMgaWRlYSwgd2UgY2FuJ3QNCmZ1
bGx5IHdhaXZlIG91ciBoYW5kcyB0aGF0IGFueSBvcHRpbWl6YXRpb24gaXMgcHJlLW1hdHVyZS4g
SXQgKmlzKiBhbg0Kb3B0aW1pemF0aW9uLiBXZSBuZWVkIHRvIGVpdGhlciBjb252aW5jZSBvdXJz
ZWx2ZXMgdGhhdCB0aGUgb3ZlcmFsbCBiZW5lZml0IGlzDQpzdGlsbCB0aGVyZSwgb3IgaGF2ZSBh
IHBsYW4gdG8gYWRvcHQgdGhlIGd1ZXN0IHRvIGF2b2lkIDRrIGFjY2VwdHMuIFdoaWNoIHdlDQp3
ZXJlIHByZXZpb3VzbHkgZGlzY3Vzc2luZyBvZiByZXF1aXJpbmcgYW55d2F5Lg0KDQpCdXQgSSBt
dWNoIHByZWZlciB0aGUgZGV0ZXJtaW5pc3RpYyBiZWhhdmlvciBvZiB0aGlzIGFwcHJvYWNoIGZy
b20gYQ0KbWFpbnRhaW5hYmlsaXR5IHBlcnNwZWN0aXZlLg0KDQo+IA0KPiA+ID4gT3Igd2hhdCBh
Ym91dCBpbnRyb2R1Y2luZyBhIHZlbmRvciBob29rIGluIF9fa3ZtX21tdV9tYXhfbWFwcGluZ19s
ZXZlbCgpIGZvciBhDQo+ID4gPiBwcml2YXRlIGZhdWx0Pw0KPiA+ID4gDQo+ID4gPiA+IE1heWJl
IHdlIGNvdWxkIGhhdmUgRVBUIHZpb2xhdGlvbnMgdGhhdCBjb250YWluIDRrIGFjY2VwdCBzaXpl
cyBmaXJzdCB1cGRhdGUgdGhlDQo+ID4gPiA+IGF0dHJpYnV0ZSBmb3IgdGhlIEdGTiB0byBiZSBh
Y2NlcHRlZCBvciBub3QsIGxpa2UgaGF2ZSB0ZHguYyBjYWxsIG91dCB0byBzZXQNCj4gPiA+ID4g
a3ZtX2xwYWdlX2luZm8tPmRpc2FsbG93X2xwYWdlIGluIHRoZSByYXJlciBjYXNlIG9mIDRrIGFj
Y2VwdCBzaXplPyBPciBzb21ldGhpbmcNCj4gPiA+IFNvbWV0aGluZyBsaWtlIGt2bV9scGFnZV9p
bmZvLT5kaXNhbGxvd19scGFnZSB3b3VsZCBkaXNhbGxvdyBsYXRlciBwYWdlDQo+ID4gPiBwcm9t
b3Rpb24sIHRob3VnaCB3ZSBkb24ndCBzdXBwb3J0IGl0IHJpZ2h0IG5vdy4NCj4gPiANCj4gPiBX
ZWxsIEkgd2FzIG9yaWdpbmFsbHkgdGhpbmtpbmcgaXQgd291bGQgbm90IHNldCBrdm1fbHBhZ2Vf
aW5mby0+ZGlzYWxsb3dfbHBhZ2UNCj4gPiBkaXJlY3RseSwgYnV0IHJlbHkgb24gdGhlIGxvZ2lj
IHRoYXQgY2hlY2tzIGZvciBtaXhlZCBhdHRyaWJ1dGVzLiBCdXQgbW9yZQ0KPiA+IGJlbG93Li4u
DQo+ID4gDQo+ID4gPiANCj4gPiA+ID4gbGlrZSB0aGF0LiBNYXliZSBzZXQgYSAiYWNjZXB0ZWQi
IGF0dHJpYnV0ZSwgb3Igc29tZXRoaW5nLiBOb3Qgc3VyZSBpZiBjb3VsZCBiZQ0KPiA+ID4gU2V0
dGluZyAiYWNjZXB0ZWQiIGF0dHJpYnV0ZSBpbiB0aGUgRVBUIHZpb2xhdGlvbiBoYW5kbGVyPw0K
PiA+ID4gSXQncyBhIGxpdHRsZSBvZGQsIGFzIHRoZSBhY2NlcHQgb3BlcmF0aW9uIGlzIG5vdCB5
ZXQgY29tcGxldGVkLg0KPiA+IA0KPiA+IEkgZ3Vlc3MgdGhlIHF1ZXN0aW9uIGluIGJvdGggb2Yg
dGhlc2UgY29tbWVudHMgaXM6IHdoYXQgaXMgdGhlIGxpZmUgY3ljbGUuIEd1ZXN0DQo+ID4gY291
bGQgY2FsbCBUREcuTUVNLlBBR0UuUkVMRUFTRSB0byB1bmFjY2VwdCBpdCBhcyB3ZWxsLiBPaCwg
Z2Vlei4gSXQgbG9va3MgbGlrZQ0KPiA+IFRERy5NRU0uUEFHRS5SRUxFQVNFIHdpbGwgZ2l2ZSB0
aGUgc2FtZSBzaXplIGhpbnRzIGluIHRoZSBFUFQgdmlvbGF0aW9uLiBTbyBhbg0KPiA+IGFjY2Vw
dCBhdHRyaWJ1dGUgaXMgbm90IGdvaW5nIHdvcmssIGF0IGxlYXN0IHdpdGhvdXQgVERYIG1vZHVs
ZSBjaGFuZ2VzLg0KPiA+IA0KPiA+IA0KPiA+IEFjdHVhbGx5LCB0aGUgcHJvYmxlbSB3ZSBoYXZl
IGRvZXNuJ3QgZml0IHRoZSBtaXhlZCBhdHRyaWJ1dGVzIGJlaGF2aW9yLiBJZiBtYW55DQo+ID4g
dkNQVSdzIGFjY2VwdCBhdCAyTUIgcmVnaW9uIGF0IDRrIHBhZ2Ugc2l6ZSwgdGhlIGVudGlyZSAy
TUIgcmFuZ2UgY291bGQgYmUgbm9uLQ0KPiA+IG1peGVkIGFuZCB0aGVuIGluZGl2aWR1YWwgYWNj
ZXB0cyB3b3VsZCBmYWlsLg0KPiA+IA0KPiA+IA0KPiA+IFNvIGluc3RlYWQgdGhlcmUgY291bGQg
YmUgYSBLVk1fTFBBR0VfR1VFU1RfSU5ISUJJVCB0aGF0IGRvZXNuJ3QgZ2V0IGNsZWFyZWQNCj4g
U2V0IEtWTV9MUEFHRV9HVUVTVF9JTkhJQklUIHZpYSBhIFREVk1DQUxMID8NCj4gDQo+IE9yIGp1
c3Qgc2V0IHRoZSBLVk1fTFBBR0VfR1VFU1RfSU5ISUJJVCB3aGVuIGFuIEVQVCB2aW9sYXRpb24g
Y29udGFpbnMgNEtCDQo+IGxldmVsIGluZm8/DQoNClllcywgdGhhdCdzIHRoZSBpZGVhLiAyTUIg
YWNjZXB0cyBjYW4gYmVoYXZlIGxpa2Ugbm9ybWFsLg0KDQo+IA0KPiBJIGd1ZXNzIGl0J3MgdGhl
IGxhdHRlciBvbmUgYXMgaXQgY2FuIGF2b2lkIG1vZGlmaWNhdGlvbiB0byBib3RoIEVESzIgYW5k
IExpbnV4DQo+IGd1ZXN0LsKgIEkgb2JzZXJ2ZWQgfjI3MTAgaW5zdGFuY2VzIG9mICJndWVzdCBh
Y2NlcHRzIGF0IDRLQiB3aGVuIEtWTSBjYW4gbWFwIGF0DQo+IDJNQiIgZHVyaW5nIHRoZSBib290
LXVwIG9mIGEgVEQgd2l0aCA0R0IgbWVtb3J5Lg0KDQpPaCwgd293IHRoYXQgaXMgbW9yZSB0aGFu
IEkgZXhwZWN0ZWQuIERpZCB5b3Ugbm90aWNlIGhvdyBtYW55IHZDUFVzIHRoZXkgd2VyZQ0Kc3By
ZWFkIGFjcm9zcz8gV2hhdCBtZW1vcnkgc2l6ZSBkaWQgeW91IHVzZT8gV2hhdCB3YXMgeW91ciBn
dWVzdCBtZW1vcnkNCmNvbmZpZ3VyYXRpb24/DQoNCj4gDQo+IEJ1dCBkb2VzIGl0IG1lYW4gVERY
IG5lZWRzIHRvIGhvbGQgd3JpdGUgbW11X2xvY2sgaW4gdGhlIEVQVCB2aW9sYXRpb24gaGFuZGxl
cg0KPiBhbmQgc2V0IEtWTV9MUEFHRV9HVUVTVF9JTkhJQklUIG9uIGZpbmRpbmcgYSB2aW9sYXRp
b24gY2FycmllcyA0S0IgbGV2ZWwgaW5mbz8NCg0KSSB0aGluayBzby4gSSBkaWRuJ3QgY2hlY2sg
dGhlIHJlYXNvbiwgYnV0IHRoZSBvdGhlciBzaW1pbGFyIGNvZGUgdG9vayBpdC4gTWF5YmUNCm5v
dD8gSWYgd2UgZG9uJ3QgbmVlZCB0byB0YWtlIG1tdSB3cml0ZSBsb2NrLCB0aGVuIHRoaXMgaWRl
YSBzZWVtcyBsaWtlIGEgY2xlYXINCndpbm5lciB0byBtZS4NCg0KPiANCj4gPiBiYXNlZCBvbiBt
aXhlZCBhdHRyaWJ1dGVzLiBJdCB3b3VsZCBiZSBvbmUgd2F5LiBJdCB3b3VsZCBuZWVkIHRvIGdl
dCBzZXQgYnkNCj4gPiBzb21ldGhpbmcgbGlrZSBrdm1fd3JpdGVfdHJhY2tfYWRkX2dmbigpIHRo
YXQgbGl2ZXMgaW4gdGR4LmMgYW5kIGlzIGNhbGxlZA0KPiA+IGJlZm9yZSBnb2luZyBpbnRvIHRo
ZSBmYXVsdCBoYW5kbGVyIG9uIDRrIGFjY2VwdCBzaXplLiBJdCB3b3VsZCBoYXZlIHRvIHRha2Ug
bW11DQo+ID4gd3JpdGUgbG9jayBJIHRoaW5rLCB3aGljaCB3b3VsZCBraWxsIHNjYWxhYmlsaXR5
IGluIHRoZSA0ayBhY2NlcHQgY2FzZSAoYnV0IG5vdA0KPiA+IHRoZSBub3JtYWwgMk1CIG9uZSku
IEJ1dCBhcyBsb25nIGFzIG1tdV93cml0ZSBsb2NrIGlzIGhlbGQsIGRlbW90ZSB3aWxsIGJlIG5v
DQo+ID4gcHJvYmxlbSwgd2hpY2ggdGhlIG9wZXJhdGlvbiB3b3VsZCBhbHNvIG5lZWQgdG8gZG8u
DQo+ID4gDQo+ID4gSSB0aGluayBpdCBhY3R1YWxseSBtYWtlcyBLVk0ncyBiZWhhdmlvciBlYXNp
ZXIgdG8gdW5kZXJzdGFuZC4gV2UgZG9uJ3QgbmVlZCB0bw0KPiA+IHdvcnJ5IGFib3V0IHJhY2Vz
IGJldHdlZW4gbXVsdGlwbGUgYWNjZXB0IHNpemVzIGFuZCB0aGluZ3MgbGlrZSB0aGF0LiBJdCBh
bHNvDQo+ID4gbGVhdmVzIHRoZSBjb3JlIE1NVSBjb2RlIG1vc3RseSB1bnRvdWNoZWQuIFBlcmZv
cm1hbmNlL3NjYWxhYmlsaXR5IHdpc2UgaXQgb25seQ0KPiA+IHB1bmlzaGVzIHRoZSByYXJlIGNh
c2UuDQo+IFdyaXRlIGRvd24gbXkgdW5kZXJzdGFuZGluZyB0byBjaGVjayBpZiBpdCdzIGNvcnJl
Y3Q6DQoNCldpbGwgcmVzcG9uZCB0byB0aGlzIHBhcnQgb24geW91ciBsYXRlciBtYWlsIHdpdGgg
Y29ycmVjdGlvbnMuDQoNCg0KDQo=

