Return-Path: <kvm+bounces-68180-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 30F5ED247B6
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 13:30:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E0CC930A27FB
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 12:25:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6CA7396B92;
	Thu, 15 Jan 2026 12:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XBnvySQS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352E03314C2;
	Thu, 15 Jan 2026 12:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768479927; cv=fail; b=rb2DeDcvcaSY1HOyU7ou/t1kI3RZnYTiq/FCxUiQKk/9UbzVret00ES2+Jn/Cw+c+UMAagd69RXEMkdKe5/JSDAMSc9sLBeecoF4sM+BHzCsW0mgQ5c/j3GE1vLqIztLez0tY/TAQt8sP5LdLxH04ne7fi1ScMWahYEZAlFLfhY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768479927; c=relaxed/simple;
	bh=cqTlWeo3BsjOqpD5g83E7kLekooWTcsw5vdY1etmh0U=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=d7dVnDyheq1/NiZk2I27RIT8Ca2JOl1ZwbK8bWxCJtDFEjacqKQjGta+7JAuZRQtkCKVKn6ZACGABQuKzYqJzSGq42vKKeSw8L6lHZvChDYavOwtYwfKFW/PIja3VvOy1yXIznxzsoyWv1CGVGAJXqTDJk6A5Xudv26uuKQHWXE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XBnvySQS; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768479926; x=1800015926;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=cqTlWeo3BsjOqpD5g83E7kLekooWTcsw5vdY1etmh0U=;
  b=XBnvySQSw9pmlK+6b0dxGSX13wpdoXOXxLIIeWoolBwoN/tlnwYU2DEU
   FU+DYRYUPGkW/E0Xw7vY0+8/xUKcEMOvsLocaP9kygPIwlKeUHX2WjItq
   h6bNxqEs6BnznWN12bIzLX4SWmZTMe3aZF0fNfOw7RcdAGcKegvpnIWlA
   0veR/lcuolP4tIv3fpx2n3CuAzEK+BndYRA9kSB3U7mOl2D9R0juuGOPZ
   4oX40SLnoREj5GIZNJw4B4wsnkVGoMo/VSlQf7eVBND2ndan7eKfx6HYh
   o6mFa/6w3uwZKEADthQPEfDNVjsz3HrQZ2Eo4rmrhhXlV5RFockH9HPqF
   g==;
X-CSE-ConnectionGUID: ahqgPNaVTIOojuaydTCXEg==
X-CSE-MsgGUID: 87YhDqo4Th2QDBcXP3+YFw==
X-IronPort-AV: E=McAfee;i="6800,10657,11671"; a="73635533"
X-IronPort-AV: E=Sophos;i="6.21,228,1763452800"; 
   d="scan'208";a="73635533"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 04:25:26 -0800
X-CSE-ConnectionGUID: TMQmcn06RB61y+vG9SLKUA==
X-CSE-MsgGUID: BAxfsarjQTSL1eBU9HEnBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,228,1763452800"; 
   d="scan'208";a="204998612"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 04:25:26 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 15 Jan 2026 04:25:24 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 15 Jan 2026 04:25:24 -0800
Received: from BYAPR05CU005.outbound.protection.outlook.com (52.101.85.42) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 15 Jan 2026 04:25:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v/x6Z7whjBzqWN1wHs/7V/U5Zf8qyzpzoRZ7jV/k/rxgrizbKqBCSiVPaTfyGQj0wf6fj1Z2pEmDLIa8ixdBLV+LUS9CxjmphLFVsWkQdc7L4h/UVKS+crG9Yro4ZoZOLADxQ/e2+Z2O3vstbvp49hkRHA2K8W4c00FM9HaT9QJ/RpIh3988T7fjTHlebceOG4kGKawig1+9n81ntcTWa+g6Os6lZaBTG6WOG3KBfoELe8Z684fsl/STiRcu4lhycNVdZG9HX2e+0SBMgwb6CQ+vsbinldSIXqBfvoVVQ256j4S/hLaNlhKImeXULv4kTQ+MWZTTycxST6d1aJyt/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cqTlWeo3BsjOqpD5g83E7kLekooWTcsw5vdY1etmh0U=;
 b=ukHi54ujEA7M2g/VFJ9q95tuR6tfRxoINONMS0iz4vUtz5t9Le8+spetwA2rvqGcXvvHy/w2JszFrjktX1ErZyT9gdn3dbf2eu6e5xgMks30YhB+7dRKFCzcW4t2OuYw0ectkw3YKLAn+P+XWMdKwK2jK23jTC6byXNRGxk5TYWMT6f+Ssobqb8RRp1s4loXI7bpHGhFNeylnbTvqgzjI6DrRSiZFMGR7sTqwZ03/baOlBvwEh4QXossBhXfXJJMcBx4csNM68qd1Vp374ftJPquuLwRacHN+zE2/uLivFacvzO6IUfZtt6LVAxdMZVDHUE12D4uobOB9p1HvQUvBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by MW3PR11MB4556.namprd11.prod.outlook.com (2603:10b6:303:5b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.4; Thu, 15 Jan
 2026 12:25:21 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9499.005; Thu, 15 Jan 2026
 12:25:21 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Du, Fan" <fan.du@intel.com>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "Gao, Chao" <chao.gao@intel.com>,
	"Hansen, Dave" <dave.hansen@intel.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"tabba@google.com" <tabba@google.com>, "david@kernel.org" <david@kernel.org>,
	"kas@kernel.org" <kas@kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, "Peng,
 Chao P" <chao.p.peng@intel.com>, "francescolavra.fl@gmail.com"
	<francescolavra.fl@gmail.com>, "sagis@google.com" <sagis@google.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "Miao, Jun" <jun.miao@intel.com>,
	"jgross@suse.com" <jgross@suse.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 11/24] KVM: x86/mmu: Introduce
 kvm_split_cross_boundary_leafs()
Thread-Topic: [PATCH v3 11/24] KVM: x86/mmu: Introduce
 kvm_split_cross_boundary_leafs()
Thread-Index: AQHcfvaNGzJc+xBW3kWaSmjSCr7TyLVTNhiA
Date: Thu, 15 Jan 2026 12:25:21 +0000
Message-ID: <2906b4d3b789985917a063d095c4063ee6ab7b72.camel@intel.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
	 <20260106102136.25108-1-yan.y.zhao@intel.com>
In-Reply-To: <20260106102136.25108-1-yan.y.zhao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|MW3PR11MB4556:EE_
x-ms-office365-filtering-correlation-id: 738b8d1c-1128-44dc-f105-08de543126e0
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?VmUvY2JYbk10Y3dYRm1RTzNBMVFEb1JneW9GVERMN01uRXl5c2tycDAxeVVU?=
 =?utf-8?B?enhGQ1BocUdPMkViUGVuVUNZd1owTlA0U1lQa05jekZJanBNeElsVGdvSkdM?=
 =?utf-8?B?S2x1K1VHd2Fpek9PeDdYZ0NWSXBzbmVQcUNNb1BCYVRoemhYN0MxT0ZQbXVY?=
 =?utf-8?B?N1l5Nmp6T3JSVVdzcThRYUJpcFp6eGVnTDZPSGRyOUt3bnJ0MUdYTnVaZWJi?=
 =?utf-8?B?dHk2S0NvdWVHVWJrQnF0aDltS28vTXNiVVFWL3FsQXoxWVlvR3VncXpZeGwy?=
 =?utf-8?B?TFR2R0V5OCtRRW51VWZZejFLYk85STZuSHFHVmNxQytNbTIrNnEyNnNuVzFt?=
 =?utf-8?B?TXRScUtqSzM2RUZlNlFYN0VTY1o5OXY3TUtobGdZYk02UGZtOXpaMHQ4QUll?=
 =?utf-8?B?MDBNZ0J5NENLTXZCSTJFcldsYWhzSkh6clMxcCtKV2xMcTZNQzlVd0J1NW5w?=
 =?utf-8?B?VWg0NlRpTFkvMFNOa09PTSt6Mys2aGYxV3ZPdGlZcEJPWEpEbktXYTNhU2Fs?=
 =?utf-8?B?RldHdlVDWTRMNml4b3ppNHZkbHJUSDQ3dEQycEdrSmQ1SzcyK3BxWFdXN3VL?=
 =?utf-8?B?aU9JWkQxNGUyaVFLZ1JVRm1SMkJFUzlYb2VUMTYvalZjV2xaelFoWlRtTk5R?=
 =?utf-8?B?M2FoWER0QkxiSk9kL3lKbWJLZFhkWTZ5cDQwaDZTSm5iRVpDbXl6S2hXR3lL?=
 =?utf-8?B?WVkrTFZSNGdHak9Mb1hJYnlZYXF0dzVZVDhuelZIVk1XWXVpaW1yZ3ZNME4y?=
 =?utf-8?B?MVNHNnZON0txc21GaU9jc0d3TlIvRlp3LzYzRXhpTjJvVWxLaTlpa0F1WGRF?=
 =?utf-8?B?U3VXUTdFUE52TGN0cmxaalYyM3ErT3lsOXI0bVhmcGxDNEFMSzFGWGFYK1V5?=
 =?utf-8?B?USt1dVZYM24vNEpKQkk0eGNZQ0x1VTRwVWJQbk0vYlhQQnlxRHZybjAvSkZE?=
 =?utf-8?B?eFlFV01oalZNWFhwTHJ4U0RzejhaeldGTGcvcjBoek1aWElsbDNzRW1TdEdI?=
 =?utf-8?B?ZGRzNFhxbG8wWGxnVFljR3B3ZzBXYWkxaGhNSWZ1bzJ3Z21YYk5vWVZNZFBC?=
 =?utf-8?B?WDZhcElKb3R1Nis1UWJYRmtsWmlRdDFQdnQ4MFB2MDg2RzlDQlREeTNQR1hQ?=
 =?utf-8?B?bEJ0ZDVhckJvc1VHWEcvSTcyUnA2cWdkOEl4b1RETHdtdXZTSEVlcGRVNFFs?=
 =?utf-8?B?dEIxcGM2OThOYmlkdkVhS2x3Vlp2SlFxMGxsd0FaQVN4RHluU1VTWjVsekNr?=
 =?utf-8?B?eTdjQWhSNzBKY2JNb0RlMjhlTTNEV05JNktWcTY3NDF6dTZOQ0F3S09MRkpP?=
 =?utf-8?B?UnY2OU83M3EzRVlING9MYWxSNHROZVJJaUg5L3Y2YWVMZHRIeXRmc085Y1k0?=
 =?utf-8?B?T1BIM3c2TUxBZEt1ck0xT0RObjFrR0t1UnZ2VzQ5eGJnZWM0cENIZ2pJdmNS?=
 =?utf-8?B?L1htRzFuZFZNSk4rQ2Nmc2tLZVB3NitCeVUxb0ROYkpxRXBXT1MzdEVGK3Jn?=
 =?utf-8?B?WUpGRXRQQ3VLMW4rdFA3RDZNdWdlaFlDYXVEUHdaRGlHNlhvcS80Y0QyenVM?=
 =?utf-8?B?SjRudEpkbmNkeXg0MHRJUFltYzNXMlhCdDE1aUY5SFRsR3c0RTZRNE41OFZZ?=
 =?utf-8?B?V0NTd3BlbTF6ZzNUOUVtOXdRbWZ3RE5laTYvdk92Q0dsanpQcXUyTGJ0SjVy?=
 =?utf-8?B?aXlPNHQxSzlvRjJ3ZlFoQXdTeWxhQ1dvT1lYcVl3djZTcml4SDVJTGJNM0cv?=
 =?utf-8?B?aDJKcDRlYzE2VWxZMnBTYnQ2Q2Rjd0t5ZGUxQ0NzclRZNDRUYmljUnZYcmJ5?=
 =?utf-8?B?SVpkb0wydlJmNjFHVDBCWHdvdnZ3VDhCdXNRMUk2RHVzdWYwZ2Z2QzVza2VJ?=
 =?utf-8?B?dTM0c2l2M0hqS1ZReHkxMWt0Y1FPNzV4ODdZd2thNWRhbVJLS240NVFpLzl1?=
 =?utf-8?B?YXRkM3BVNFd6QVFCYUFTdWZuTklrdHgzaHE1T1B4UHJDeFFMOG0wMjNHcTdy?=
 =?utf-8?B?dWw4SmFBMk5mSjdzQVJhN2ViajF5VTNNRXpTay9PTWJYbElBOUhZYzBuTzVy?=
 =?utf-8?B?NmlnSGlxV2hvY054Yzh1SW5QVlVLYXJGMEFUU1FnV1ZhZ1d1TG5SaHBDLy94?=
 =?utf-8?B?TlFnSkgvOUVLOTB0Q2ZkM2hTUkVMa0lsOGVobS8wMWJSRjZURi9LelBUa3hG?=
 =?utf-8?Q?Yo2vQNhNzUyqUCO2vxZ00ws=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K21ZNG95NkJBYWNTb01yK0U2SXJuK2hJblJ5VXB1aWl4Q3VNZTg0Z0V4bklh?=
 =?utf-8?B?c0NTOVlZWVpxZE5nbG1lV2ZYYVYvSjJNQ3c2a3JJc2xidHhCdXYwa25BL3l2?=
 =?utf-8?B?UFdYenBJbG8wUllySFZXSG01bENBSFJOVGJiV1RpMk1VWDB1WWEwR2RqWVcr?=
 =?utf-8?B?ckVmZnVCK1g1SXZGQVdVNi9laWk4ZCtCd2FycWpCcWhvL1NaZ2VxRGRrN0Zn?=
 =?utf-8?B?Vm1jNFROcDE0Vkw2WHl2eGpXSU42Ym16TnlEUFdtc2tGdlZiU2s1K0RCcVQy?=
 =?utf-8?B?TE1aeDNic0Z1em5aQmJXY01WaVhKVDQvSUt5dloweStmdTl4TllORlhQL2Fm?=
 =?utf-8?B?L1RhUU03YVpyQnJtY3lTeEE4c2RYUVlSeFNiUVEvWVlHYmh1T0VxRGJkcVFE?=
 =?utf-8?B?QVAxc1AxaHM4Z2NxMmhGM1N5VTdhdUVHR2dwdVB4RkZsRDN3RFdWOTB1OVFa?=
 =?utf-8?B?R1VGMVVDQWlwOEI1YXVGRm5FKzdEZmlSbGphaWszOTVDcGRhbHBXUDJFSWNX?=
 =?utf-8?B?dzhwU3R1MVRIYm5UR01GZU1FemZBM1lxd3IxOXVJckJVNEdBTVZqOGZsWGxp?=
 =?utf-8?B?WWpKdFVoVFB5RFJIc3dOK1hTVUJCWFUwc0kvTk8ya1JrWHR3amdGZXJ5V1cv?=
 =?utf-8?B?V3FDY09oRUk2M3g3Qm8vb254YmRCUXdlTS9tSDJKSEFUUjRmeS9sSm5MeEV5?=
 =?utf-8?B?R05yZ0lFdUYxWlg5OCtZRVMxcGk1WGRFTnNBeVJWNjFBUzNEVlhJUjJpTFk2?=
 =?utf-8?B?d0dGUXNRemRzQm40Y0t1cm9lcVNFb2p4WVAvTFIyRHhCV0RWSWdXVlRkdEZN?=
 =?utf-8?B?aWVPZ1o2MUZJbkR4ZlRCOHMvaVh6NDlKc1NKd2g4WUJhTU9NSEN5emk4RVNM?=
 =?utf-8?B?Yzh2T0Y0WldycFlEN0w4STJwdmVPQ0Z3SzdZOW9kOWhJNXd4aWthbFdzZ0Jz?=
 =?utf-8?B?L3E2bVZ6bDJJN09PMlhjWHQzbUpyVnVIeFdaaFFKRE9FRFZJbklrK3pqMEd3?=
 =?utf-8?B?WUtvSnJqK1pGZE05RjVMd3psblcva2FMejJ4VVJjcWlsa090MXhPVnBtS0pL?=
 =?utf-8?B?N0RvaW1OTG1FZ1FEdVVrTEhJMlZ1SGRzZ1lmOVIzWjY2aStieVZQM016RFBv?=
 =?utf-8?B?V1I2eDdndzc5TUMyUjc4RGduaHlueWNGeUFPSCtES0dWaUxBY2VJS0xhZXBB?=
 =?utf-8?B?U24wWWgwamVVcFJFTytCN29RMjNRSlQyWGtGbzRsbjQ2UzFsQlZwU3B1ZENz?=
 =?utf-8?B?VWhhVVJ6NkRuclYvS29IZzkyVjB3azF5Smk4ZHNYVytWbmhBOTRSR3kwV21R?=
 =?utf-8?B?b3FSNmhwS21vOUJ4Yk9kSHd3aFdhSURZZE9uakVVN1J6ZzNhZ2JvTUFkRFZQ?=
 =?utf-8?B?YnAwL1lzdi9CNW5XTXI3aU5UWVZMVUJYZER3Z25Lb05kTlk4Z2svL1Npb2pU?=
 =?utf-8?B?eCtIZzF3WXNReUJ4cHFHUjZQU2NBVUIxMlVHUmppQzMra2NhYXZXVGt6ZXh2?=
 =?utf-8?B?Tzl0SDhRSXFSTWQ0UHpLNUxBa3ZiZmxxcUZhRVAyWTR6Qm1NS1B6U2pZRm5F?=
 =?utf-8?B?QlNHYVlTYi9QWjdHSkpUVU55OVVOZ1FrcUF2a3JLU05qSkZqSjliS0oxMUZh?=
 =?utf-8?B?UlMwWXNGVUs1VTJIbTA3SUhvVTU1ZDN6NC9XS1AwVWhkUFNRT240bkFhK1pV?=
 =?utf-8?B?TFduMlI0SENEeVZiYzQ4SUk2VlNGTlBqYWNDZGIxNTZXU3RCZHBqM2N5d25O?=
 =?utf-8?B?L0FUZ0ptZjl1elY1SE5QVTdCQzVwWDloVDV2dHYwa3cxZEp2VW1WVW1EYVZ2?=
 =?utf-8?B?TU1EYjVnOG1qZ2dSYXZ6YVdGbE12Uk45SnZXak8zWXkzeHdUZENpOUxTT1V0?=
 =?utf-8?B?YW5xaHdXME45OEpWUlNvRUNCb1pYaTZFT0JDTHJaOFZyVTJSWXdwVWJJN1No?=
 =?utf-8?B?ckN1algyeWFoTlRuU0RkUEdDVzUxTWFpek9ickZsL3JabkdWazdEVFBTQzRG?=
 =?utf-8?B?VllhanFhRHZOYlJkdWpDdGp1c0RVS2RpVzc0NWthZXBNOGJUZkljZ0FqVHJn?=
 =?utf-8?B?MTl0NXhVUXJ3aFFNTncxemo5UFZwWUFNdlI5b2w0QUxtWVBEcWpnbnVMTEUv?=
 =?utf-8?B?YXZPclhSM1BvWVVkSHVIclVKOHBIN2tPeEFqZHNNNVBkVlZBdGFXbUFaNS9q?=
 =?utf-8?B?d3VSNU5xN2lValZreXZiTTZYaDZlR2JHVnNqMTJkSEcwcHJnck9KRDRibW9y?=
 =?utf-8?B?d3QwcEkvenRFQVROQXVGVW5TbUE5bk1tNW84MXJ0K1RKdGlVZTZCaGh0ck0v?=
 =?utf-8?B?bGoydDFDT1RSKzRFYjBGQ3VrWkFPODVyMm9jZGFFbEZUeDVNdXdnUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0005F58EA8C7C54AA3B37028E5B3A18F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 738b8d1c-1128-44dc-f105-08de543126e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jan 2026 12:25:21.5001
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kvIq4YEWI9D772PGQa8ugO3kdZURj8CGwS4cChuOn9LphMgJezhQgHm82+t9r79u3M9mC8j01+F/nu8bkQB/Rg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4556
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI2LTAxLTA2IGF0IDE4OjIxICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gQEAg
LTE2OTIsMTIgKzE3MDcsMzUgQEAgdm9pZCBrdm1fdGRwX21tdV90cnlfc3BsaXRfaHVnZV9wYWdl
cyhzdHJ1Y3Qga3ZtICprdm0sDQo+IMKgDQo+IMKgCWt2bV9sb2NrZGVwX2Fzc2VydF9tbXVfbG9j
a19oZWxkKGt2bSwgc2hhcmVkKTsNCj4gwqAJZm9yX2VhY2hfdmFsaWRfdGRwX21tdV9yb290X3lp
ZWxkX3NhZmUoa3ZtLCByb290LCBzbG90LT5hc19pZCkgew0KPiAtCQlyID0gdGRwX21tdV9zcGxp
dF9odWdlX3BhZ2VzX3Jvb3Qoa3ZtLCByb290LCBzdGFydCwgZW5kLCB0YXJnZXRfbGV2ZWwsIHNo
YXJlZCk7DQo+ICsJCXIgPSB0ZHBfbW11X3NwbGl0X2h1Z2VfcGFnZXNfcm9vdChrdm0sIHJvb3Qs
IHN0YXJ0LCBlbmQsIHRhcmdldF9sZXZlbCwNCj4gKwkJCQkJCcKgIHNoYXJlZCwgZmFsc2UpOw0K
PiArCQlpZiAocikgew0KPiArCQkJa3ZtX3RkcF9tbXVfcHV0X3Jvb3Qoa3ZtLCByb290KTsNCj4g
KwkJCWJyZWFrOw0KPiArCQl9DQo+ICsJfQ0KPiArfQ0KPiArDQo+ICtpbnQga3ZtX3RkcF9tbXVf
Z2ZuX3JhbmdlX3NwbGl0X2Nyb3NzX2JvdW5kYXJ5X2xlYWZzKHN0cnVjdCBrdm0gKmt2bSwNCj4g
KwkJCQkJCcKgwqDCoMKgIHN0cnVjdCBrdm1fZ2ZuX3JhbmdlICpyYW5nZSwNCj4gKwkJCQkJCcKg
wqDCoMKgIGJvb2wgc2hhcmVkKQ0KPiArew0KPiArCWVudW0ga3ZtX3RkcF9tbXVfcm9vdF90eXBl
cyB0eXBlczsNCj4gKwlzdHJ1Y3Qga3ZtX21tdV9wYWdlICpyb290Ow0KPiArCWludCByID0gMDsN
Cj4gKw0KPiArCWt2bV9sb2NrZGVwX2Fzc2VydF9tbXVfbG9ja19oZWxkKGt2bSwgc2hhcmVkKTsN
Cj4gKwl0eXBlcyA9IGt2bV9nZm5fcmFuZ2VfZmlsdGVyX3RvX3Jvb3RfdHlwZXMoa3ZtLCByYW5n
ZS0+YXR0cl9maWx0ZXIpOw0KPiArDQo+ICsJX19mb3JfZWFjaF90ZHBfbW11X3Jvb3RfeWllbGRf
c2FmZShrdm0sIHJvb3QsIHJhbmdlLT5zbG90LT5hc19pZCwgdHlwZXMpIHsNCj4gKwkJciA9IHRk
cF9tbXVfc3BsaXRfaHVnZV9wYWdlc19yb290KGt2bSwgcm9vdCwgcmFuZ2UtPnN0YXJ0LCByYW5n
ZS0+ZW5kLA0KPiArCQkJCQkJwqAgUEdfTEVWRUxfNEssIHNoYXJlZCwgdHJ1ZSk7DQo+IMKgCQlp
ZiAocikgew0KPiDCoAkJCWt2bV90ZHBfbW11X3B1dF9yb290KGt2bSwgcm9vdCk7DQo+IMKgCQkJ
YnJlYWs7DQo+IMKgCQl9DQo+IMKgCX0NCj4gKwlyZXR1cm4gcjsNCj4gwqB9DQo+IMKgDQoNClNl
ZW1zIHRoZSB0d28gZnVuY3Rpb25zIC0tIGt2bV90ZHBfbW11X3RyeV9zcGxpdF9odWdlX3BhZ2Vz
KCkgYW5kDQprdm1fdGRwX21tdV9nZm5fcmFuZ2Vfc3BsaXRfY3Jvc3NfYm91bmRhcnlfbGVhZnMo
KSAtLSBhcmUgYWxtb3N0DQppZGVudGljYWwuICBJcyBpdCBiZXR0ZXIgdG8gaW50cm9kdWNlIGEg
aGVscGVyIGFuZCBtYWtlIHRoZSB0d28ganVzdCBiZQ0KdGhlIHdyYXBwZXJzPw0KDQpFLmcuLA0K
DQpzdGF0aWMgaW50IF9fa3ZtX3RkcF9tbXVfc3BsaXRfaHVnZV9wYWdlcyhzdHJ1Y3Qga3ZtICpr
dm0swqANCgkJCQkJICBzdHJ1Y3Qga3ZtX2dmbl9yYW5nZSAqcmFuZ2UsDQoJCQkJCSAgaW50IHRh
cmdldF9sZXZlbCwNCgkJCQkJICBib29sIHNoYXJlZCwNCgkJCQkJICBib29sIGNyb3NzX2JvdW5k
YXJ5X29ubHkpDQp7DQoJLi4uDQp9DQoNCkFuZCBieSB1c2luZyB0aGlzIGhlbHBlciwgSSBmb3Vu
ZCB0aGUgbmFtZSBvZiB0aGUgdHdvIHdyYXBwZXIgZnVuY3Rpb25zDQphcmUgbm90IGlkZWFsOg0K
DQprdm1fdGRwX21tdV90cnlfc3BsaXRfaHVnZV9wYWdlcygpIGlzIG9ubHkgZm9yIGxvZyBkaXJ0
eSwgYW5kIGl0IHNob3VsZA0Kbm90IGJlIHJlYWNoYWJsZSBmb3IgVEQgKFZNIHdpdGggbWlycm9y
ZWQgUFQpLiAgQnV0IGN1cnJlbnRseSBpdCB1c2VzDQpLVk1fVkFMSURfUk9PVFMgZm9yIHJvb3Qg
ZmlsdGVyIHRodXMgbWlycm9yZWQgUFQgaXMgYWxzbyBpbmNsdWRlZC4gIEkNCnRoaW5rIGl0J3Mg
YmV0dGVyIHRvIHJlbmFtZSBpdCwgZS5nLiwgYXQgbGVhc3Qgd2l0aCAibG9nX2RpcnR5IiBpbiB0
aGUNCm5hbWUgc28gaXQncyBtb3JlIGNsZWFyIHRoaXMgZnVuY3Rpb24gaXMgb25seSBmb3IgZGVh
bGluZyBsb2cgZGlydHkgKGF0DQpsZWFzdCBjdXJyZW50bHkpLiAgV2UgY2FuIGFsc28gYWRkIGEg
V0FSTigpIGlmIGl0J3MgY2FsbGVkIGZvciBWTSB3aXRoDQptaXJyb3JlZCBQVCBidXQgaXQncyBh
IGRpZmZlcmVudCB0b3BpYy4NCg0Ka3ZtX3RkcF9tbXVfZ2ZuX3JhbmdlX3NwbGl0X2Nyb3NzX2Jv
dW5kYXJ5X2xlYWZzKCkgZG9lc24ndCBoYXZlDQoiaHVnZV9wYWdlcyIsIHdoaWNoIGlzbid0IGNv
bnNpc3RlbnQgd2l0aCB0aGUgb3RoZXIuICBBbmQgaXQgaXMgYSBiaXQNCmxvbmcuICBJZiB3ZSBk
b24ndCBoYXZlICJnZm5fcmFuZ2UiIGluIF9fa3ZtX3RkcF9tbXVfc3BsaXRfaHVnZV9wYWdlcygp
LA0KdGhlbiBJIHRoaW5rIHdlIGNhbiByZW1vdmUgImdmbl9yYW5nZSIgZnJvbQ0Ka3ZtX3RkcF9t
bXVfZ2ZuX3JhbmdlX3NwbGl0X2Nyb3NzX2JvdW5kYXJ5X2xlYWZzKCkgdG9vIHRvIG1ha2UgaXQg
c2hvcnRlci4NCg0KU28gaG93IGFib3V0Og0KDQpSZW5hbWUga3ZtX3RkcF9tbXVfdHJ5X3NwbGl0
X2h1Z2VfcGFnZXMoKSB0bw0Ka3ZtX3RkcF9tbXVfc3BsaXRfaHVnZV9wYWdlc19sb2dfZGlydHko
KSwgYW5kIHJlbmFtZQ0Ka3ZtX3RkcF9tbXVfZ2ZuX3JhbmdlX3NwbGl0X2Nyb3NzX2JvdW5kYXJ5
X2xlYWZzKCkgdG8NCmt2bV90ZHBfbW11X3NwbGl0X2h1Z2VfcGFnZXNfY3Jvc3NfYm91bmRhcnko
KQ0KDQo/DQoNCkUuZy4sOg0KDQppbnQga3ZtX3RkcF9tbXVfc3BsaXRfaHVnZV9wYWdlc19sb2df
ZGlydHkoc3RydWN0IGt2bSAqa3ZtLMKgDQoJCQkJICAgICAJICAgY29uc3Qga3ZtX21lbW9yeV9z
bG90ICpzbG90LA0KCQkJCSAgICAJICAgZ2ZuX3Qgc3RhcnQsIGdmbl90IGVuZCwNCgkJCQkJICAg
aW50IHRhcmdldF9sZXZlbCwgYm9vbCBzaGFyZWQpDQp7DQoJc3RydWN0IGt2bV9nZm5fcmFuZ2Ug
cmFuZ2UgPSB7DQoJCS5zbG90CQk9IHNsb3QsDQoJCS5zdGFydAkJPSBzdGFydCwNCgkJLmVuZAkJ
PSBlbmQsDQoJCS5hdHRyX2ZpbHRlcgk9IDAsIC8qIGRvZXNuJ3QgbWF0dGVyICovDQoJCS5tYXlf
YmxvY2sJPSB0cnVlLA0KCX07DQoNCglpZiAoV0FSTl9PTl9PTkNFKGt2bV9oYXNfbWlycm9yZWRf
dGRwKGt2bSkpDQoJCXJldHVybiAtRUlOVkFMOw0KDQoJcmV0dXJuIF9fa3ZtX3RkcF9tbXVfc3Bs
aXRfaHVnZV9wYWdlcyhrdm0sICZyYW5nZSwgdGFyZ2V0X2xldmVsLA0KCQkJCQkgICAgICBzaGFy
ZWQsIGZhbHNlKTsNCn0NCg0KaW50IGt2bV90ZHBfbW11X3NwbGl0X2h1Z2VfcGFnZXNfY3Jvc3Nf
Ym91bmRhcnkoc3RydWN0IGt2bSAqa3ZtLA0KCQkJCQlzdHJ1Y3Qga3ZtX2dmbl9yYW5nZSAqcmFu
Z2UsDQoJCQkJCWludCB0YXJnZXRfbGV2ZWwsDQoJCQkJCWJvb2wgc2hhcmVkKQ0Kew0KCXJldHVy
biBfX2t2bV90ZHBfbW11X3NwbGl0X2h1Z2VfcGFnZXMoa3ZtLCByYW5nZSwgdGFyZ2V0X2xldmVs
LA0KCQkJCQkgICAgICBzaGFyZWQsIHRydWUpOw0KfQ0KDQpBbnl0aGluZyBJIG1pc3NlZD8NCg0K
QW5kIG9uZSBtb3JlIG1pbm9yIHRoaW5nOg0KDQpXaXRoIHRoYXQsIEkgdGhpbmsgeW91IGNhbiBt
b3ZlIHJhbmdlLT5tYXlfYmxvY2sgY2hlY2sgZnJvbQ0Ka3ZtX3NwbGl0X2Nyb3NzX2JvdW5kYXJ5
X2xlYWZzKCkgdG8gdGhlIF9fa3ZtX3RkcF9tbXVfc3BsaXRfaHVnZV9wYWdlcygpDQpjb21tb24g
aGVscGVyOg0KDQoJaWYgKCFyYW5nZS0+bWF5X2Jsb2NrKQ0KCQlyZXR1cm4gLUVPUE5PVFNVUFA7
DQoJCQkJCQ0K

