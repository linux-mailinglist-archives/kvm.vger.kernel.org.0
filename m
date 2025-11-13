Return-Path: <kvm+bounces-63006-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E8EE2C573FD
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 12:43:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E85453A7862
	for <lists+kvm@lfdr.de>; Thu, 13 Nov 2025 11:40:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7EE033FE2C;
	Thu, 13 Nov 2025 11:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MUeSOc8Z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E112DECA5;
	Thu, 13 Nov 2025 11:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763034037; cv=fail; b=OJqWfWUg8GCXr4GZ7CoPyUiPCR3BS/udBz7Pwn+HA5MECj3uTfF2qFIoe0Ewd8V2/9zpxI/a4nTI9FPw+frEcSAcUmP5DRi/6jQVl93QFvVwrptERaB1bokXgn4Li45tP3WQAdwAGj2aqrlDWJLLctv7lZ1c0B+qYeZX+z7JZEg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763034037; c=relaxed/simple;
	bh=wmGT0U9bhGSbrzRDPo4nZrxIQMZLMyJQ/9ivYU2D6Ro=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=vB+KBmp2Bi9HY+mVUbJa1tkBak5Z6vjzP5bCdmFeed2pdf4zTTfePWCSleQ/smO5E4k0qIjb6WvhVgRvoKCYW4nYb30FvU7PF8Kh9QTFOH12LsTsb4USMQNkJydnwt9WT2h8PIoeA8rxENNltqEqhFIDUNM+y+k9Mq0Xgp4fNKA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MUeSOc8Z; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763034037; x=1794570037;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=wmGT0U9bhGSbrzRDPo4nZrxIQMZLMyJQ/9ivYU2D6Ro=;
  b=MUeSOc8ZUjL0gFcZsK3kUscJl4P9BVOoWDTck6cyTtt7MDA+zFUKwgDH
   j43RtHl2uQoaZ+b1/2keZrG5EMUVXxmTXeWYGDF5K2cF1tx1bCDtCrZ80
   P4MSVQEAuZqPE6YYS7ObCPXRwp/IZ0rdQwqvCV5U1EHMfTymEdxuA5AlL
   ZS2WWEguCReT3NeXGWbY9ccSTE5kxMt70GIgMz6H2GYIg/V/dtlxgFNg/
   sPcTXKObJAb33IfpEG9S97iJTo7ByXM+rMGXoOY4dcyiSmrgts8ZAaGCm
   CXVPiAp5o3Jql0m3toMzRMSXLFMygmA/Rk4yf5ISHlQ76bJ2TJXqdpr9d
   g==;
X-CSE-ConnectionGUID: coM+el3vTpeczF6mWefckg==
X-CSE-MsgGUID: W4glqYUBQDi6ROZjtppZXw==
X-IronPort-AV: E=McAfee;i="6800,10657,11611"; a="76571179"
X-IronPort-AV: E=Sophos;i="6.19,301,1754982000"; 
   d="scan'208";a="76571179"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 03:40:36 -0800
X-CSE-ConnectionGUID: coZMRkv5QPSTI7CxDdRuZA==
X-CSE-MsgGUID: sru69rmPQIC49qnOc372HQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,301,1754982000"; 
   d="scan'208";a="226782048"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2025 03:40:36 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 03:40:35 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 13 Nov 2025 03:40:35 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.47) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 13 Nov 2025 03:40:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vjv3O57fJ3fQDtWaDlqgZAZlNgcQ3FAP2qnvw1AQBszE/KZ5xyzd6/vdDQ99Z7rCtZY6qLasCCBMv+VNyOg2QzBNJ88HFx/gVLQY7bxx+kpFWYoxZo9XwXWMD3Qe9uXN42YXije0X0eJh51LW7qogeXLPG9irAfK1nIHGO2GhDq1D207mzcQYoiQ1D5g24q+G96DW33M5WQ9Hjj5e5W2mOIJVvVyb8/a7xawDrL9hgbA6YOcNMO9t8JALcITwAee/bcn9RcAXpeOq4fQ8hEPatTFLF+GWNATKe0gSr9dRGbipAGwSUJCV+73bxeQ8woF9azjA2WzXNLV9cGBTaKjRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wmGT0U9bhGSbrzRDPo4nZrxIQMZLMyJQ/9ivYU2D6Ro=;
 b=eCb03pTlQwp1LlJ7c8/mjI/YYaGbrwzu+N7QRaI9qwWCSc4XicmTNCJJJ6jePzxeo4TWR2Zn3KwSXLQulJGj2vueSAfdNbl2KkTJFYmyROYqXVbp5SQSADiAMxHivuHBqAuVSuPhNK9xzK4SpdCyzD4STY7YKEAuoONo2iIHyuflE9K1iVVP4wvC7NgPSRpenwAEaUKFnI8WTT70AH1mB+BjOO7zs3s5vyVUgG/xs7rzs/jFTJ0PBNVA2e5wzvYs3n+7K++1YeSDFwGMM+33Zy+IUm+Mk3wnJWXfywgcg86CPHBCgVIDWnDJaN6+X7whtx4xGtbkaXrjTxSjFadcGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SA1PR11MB5779.namprd11.prod.outlook.com (2603:10b6:806:22b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.15; Thu, 13 Nov
 2025 11:40:26 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 11:40:26 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "Du, Fan" <fan.du@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "tabba@google.com" <tabba@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"Weiny, Ira" <ira.weiny@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"Miao, Jun" <jun.miao@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"pgonda@google.com" <pgonda@google.com>
Subject: Re: [RFC PATCH v2 12/23] KVM: x86/mmu: Introduce
 kvm_split_cross_boundary_leafs()
Thread-Topic: [RFC PATCH v2 12/23] KVM: x86/mmu: Introduce
 kvm_split_cross_boundary_leafs()
Thread-Index: AQHcB4AQJSSoQW12Bkmtr+PwbHPEybTt4N2AgAMGZYCAACPdgIAACniA
Date: Thu, 13 Nov 2025 11:40:26 +0000
Message-ID: <60fd8299fd992a61424747de16b12a6fd0bf7b98.camel@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
		 <20250807094358.4607-1-yan.y.zhao@intel.com>
		 <0929fe0f36d8116142155cb2c983fd4c4ae55478.camel@intel.com>
		 <aRWcyf0TOQMEO77Y@yzhao56-desk.sh.intel.com>
	 <31c58b990d2c838552aa92b3c0890fa5e72c53a4.camel@intel.com>
In-Reply-To: <31c58b990d2c838552aa92b3c0890fa5e72c53a4.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SA1PR11MB5779:EE_
x-ms-office365-filtering-correlation-id: ca558c9d-7a90-4fd8-8819-08de22a97075
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?UCszOVp1MDgwM25UeFNKZHp1UVFraWN0SkNKbHczSHR5RllHd051TmVBY2ZK?=
 =?utf-8?B?eHFmSEZpSms4S1VkaFd3cGFkY3ZvcytVZ1hFV1JVMXVoaVNibjZtOTlQYktE?=
 =?utf-8?B?TTVRNDZiT2k0T2RabkxVZ1EyR2EwUkVLUTFKc0R6T0U5aUhEazlVTlFiS3Zt?=
 =?utf-8?B?UGo0eUFZLzBoZUVxQzhlS0pyM1NkaSs3aXJQeklEWmlJTXhuQzZJVlZ2YldF?=
 =?utf-8?B?eGk4SlhZSW9HQWd4TUVhZ0ZDL2hFZVBPTmxPQVFaMkNJK1BLM3k3eHh5Sk85?=
 =?utf-8?B?QXNYak5ObzJwWVllOEEzbi9xRjc2TUxIWVF1czJ6SjU5SnVKQmx1VSt0U05y?=
 =?utf-8?B?ZGt0YzdKTjRSVVIvMEJDL3dvUHFIbGltOVNKeUhUYnYwejJkZ3VCVHdvaWla?=
 =?utf-8?B?K0ZUQWRBRGkvVjZ4Y0h0L25qT0RjMHhlWmlVRHBJcWpsNXhLbXB3TDRJSXAy?=
 =?utf-8?B?azJKR0NGTmtHT2ZEd0FuOTMra3A3S2lpMXBSbTB3SHBhYmQ2QS9TOWVFMEZN?=
 =?utf-8?B?ZW1lQ3RrSjB2d0YwbXJqR3pkM1gyeFAwU2pKQ3hpZ1pTdEJnaEFBTFFmdnJQ?=
 =?utf-8?B?OVg3VHlTb3E2d0lGb1JXUXVGZHZETHNXdkFwOTR0UWN5Y2J4Mk1DVmJLTWlw?=
 =?utf-8?B?MFhIMS9kZzIyS2c2c2dsS0tCZUdvQ2p1T1BwVXpoNU0veWF4VEFBZUQrSnhW?=
 =?utf-8?B?WXU1L0NwUFIwRHhid3NxUndmSWRuellybzJTeFBJZjd4YkVUb2I1bmNxWnFj?=
 =?utf-8?B?UEVqSU5ocUZhbXlNOFpGSTdvWW4zNUI2OVA4N3dRU1NoWWJiN2lCdExuYXlq?=
 =?utf-8?B?TG5ITlFOU1NiZEU2N0RoTUNhdy96Q2NFRWFwWXhjcGFLdDI3RHIybXFBZ2Rl?=
 =?utf-8?B?cHpzOGplMHNDVFBmMjQ4WW9WbFdNVUttSnNnOE0zbGluWGdvcFFEejVVTFFz?=
 =?utf-8?B?eEFRVGJGN1ZNT2V5M21OUVR4d1F1NVN5OUR1TmlQWVJBNzRGNnRNWXp6WTNw?=
 =?utf-8?B?VEIvL1FUWnRkNC9mcyt3eXdXc0lFNjB4UzlRSFRXTFc5M1l1Wk90c2hKZTdo?=
 =?utf-8?B?YUFiZnJvNS8rNTFraEdJbnBRdERkdDRNL1RtNjNhVlhkZXRjWGFxZktGei80?=
 =?utf-8?B?clg5RWlKdzR1QXdXZFZFeVRad0xKNkRWMnhlcmh1MTBOV1VWa0NmdUdCTDhx?=
 =?utf-8?B?T2tHSGp3VGZIak9TK1VRa2EvVENyUlNYWklDeEdrNHBtQTFDZkVBZGR0WVNw?=
 =?utf-8?B?SWViMTZFMzJSQ1dZdDNPN2F5UFZIZ0MzQ1N3OU4rZmN1cHN0elRaN3ltRGlh?=
 =?utf-8?B?QlNBSmJ2MWk4WXBXQ0crbkpXbnhhN2pXQk5qYnBMdW5pTEtQNTNWeTBiZ3Bn?=
 =?utf-8?B?dHNHdklhMndvNEZwN2RDblFCY2pRamJkZFJwQUVnWVBkNnBRUE11VTJodG1V?=
 =?utf-8?B?SEZPTUFmNmh5ckZ0aURFSWRoZFR3bCtvZVRJL1BZQnVhRnFrR2FoSkxhTzd1?=
 =?utf-8?B?TFEvR0RHaS9wUXhlTkJBRHJJTjl5UVRISi9nZWd6UVQwd2IzMHNFQ1ZuTlhS?=
 =?utf-8?B?a2picStRR21yUDNSR093VmN2dGZ6VmhwUVgvdFh2dmlMNTIwV1NLZm1LclVn?=
 =?utf-8?B?bXhRTFRnN1FTZXZHOXkyY0JRa3JQcjZoa3Qrd2hOeDBDTzArQnlRTTBuTjgv?=
 =?utf-8?B?aHZPNXZ1YWVud0FOaHFuSXF5NmVhc01pQnVmakhrOC91am9CQVZubW9MRmE1?=
 =?utf-8?B?NnFISmo0VkhHM1g0elZzNUFNR0FnS3MvalF4eENHY3Bodmc1YUFqYXZVOUY4?=
 =?utf-8?B?MFNRWTJNeVQvTGdJalBhZEt3N0lZS2s4SEZGak5QK0RORWUreWlGaXhEeGFk?=
 =?utf-8?B?Zm5GKzdlekxRT3oxaWN5enJUck5md0FXYThjUlF5ZTFDTHp0Q0UyNXFBblV3?=
 =?utf-8?B?dzBRek9NbnlpSmk0N2JZV2lkK3ByUTlUODFjTXY3dGRqVHVBQklWdTR6ZWg0?=
 =?utf-8?B?QkljODd1am9IbXAxYzBBRzlJdHZQcHFTQ0ozNXoxQ29tOUljbVhvbk1ZRGhG?=
 =?utf-8?Q?tiWB52?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VGs1ODFsQ3BzaU43Wi9HRGlDVWxmZU9pRVdaR0RSR0FKVFVhMHVZR29TanZU?=
 =?utf-8?B?SU9ITlNEa3F6aitpU1FjZ0JCci9QRm1sd1ppVU04aFVwemk3Wngyd3FwOG9Q?=
 =?utf-8?B?RjlZZ0IweHd2ZmovdkpMc2xVSEtnaUpmU29DQmh2ZGE2eG8zc1JqdUZOemdE?=
 =?utf-8?B?dFdqOTl5UUlEZWxjSG5OM3ZuTjZpbVJ5emZLd2RyTWZvVEJmdm1uYURLTkYy?=
 =?utf-8?B?NXJYRnliS1Q2RUZPWEdKZUhHaW5WMllsV1RIalBKTlR6VXBUTzAvcklXNDZz?=
 =?utf-8?B?Qm1nVUJMU2YzdzhHMlNmQk9XaHFNazk3bTFuTlhJTTh4R09Dd0tqWWVxbmNI?=
 =?utf-8?B?R3hpMVZFYjRoZm9HOFRYMW1kS0tmTzVvOHQ2cEd0YVFybFYyWjJRQUJiNW1K?=
 =?utf-8?B?SnJlelQwV3FGU0Y1d2FWMlpCNkRJczNlQmdFV1krSjJFb0pLYUp5TmY0SWxG?=
 =?utf-8?B?MDN5aUxlL09OV3lUZ2twdXFnVXVJTk45MnVLdnZFTS9oWkt6QUZURkQyU1Zz?=
 =?utf-8?B?SDdaVzhJSCtRMmNhaG1IWnhNOFlJejExaVRXdEZqUWFrSUI2alVHWDFPNEdI?=
 =?utf-8?B?eUxlMDJpTmV2c1MxNS9hN2xmSlkxSkc1TDJoejhrN1hWK05jaktINmQrd1ly?=
 =?utf-8?B?RUl0WTMzTjJhTHkzZUk0aFhobHdsWUVmcHR4clk2cEU2Qi9ZUmJZQkJqWG9B?=
 =?utf-8?B?Qlc5K0swUktHeDYwWnRwcXdsY1pLR0YveDJRczB0aG9JaFp0MjJxaFRXanRn?=
 =?utf-8?B?VDVyWmlqNGRidUtUY2pKdGF6V1V3VXlIRmRHSExKMTl5Myt4TktaRmh0ZW1o?=
 =?utf-8?B?VU9haGFVZ0VuL2liNlVKMkRXSzVhTUFRa0FJeTJIUWhmUXM2d1FydDVNdEtT?=
 =?utf-8?B?Q1NXRXpIN0Vpc0wzMk5TMHJ5Z1VWMEJCcnNkdFBzeG5jSlR6ckRSNUR2RnEy?=
 =?utf-8?B?ekFSTFhwMHgvTHdYM2xpTzFxenIvOHh0M2hZdTh3Ri8ya2NoN0srVno1aDlO?=
 =?utf-8?B?ZG9HWlhmVFI4Zk4wUm9aZFpObkVVU1Z5SE9wMDgzUlhNNHRHZUxwZ2ZaMm9s?=
 =?utf-8?B?ZEY3NDZXemtieURxS05wSU5XSHBabldvRFFraW56U3YxVFBPcWJkLzcrVnpM?=
 =?utf-8?B?c0RwUHAzdTlEYnkzRzJBeGdydWlSdFE1eTBtalRTcmNsNXJTNkk5Tjk0dmMv?=
 =?utf-8?B?emdCdW9sMmViUmdPRFh1YVA3MkF3QjZ3YnVVUTVEUjJUbEY5eEh0NngvV281?=
 =?utf-8?B?eUhEVTdzYW9RT1hBcUVnNUJuYVFLcWl5TXc0ZUdMZXdYUzl0dFhZcjRKRzBz?=
 =?utf-8?B?SW9IUGJBVnZoRHJXa1pwT0hreHBIZWtUV0QxWnlhOGg4TDlUWkh4QnlIbXRV?=
 =?utf-8?B?dVhCWVJwc1lndHY0Y0o3c1NWY3Q1WGI1eFRzQkZnUWNiK2JFQ3FkdFlXemNX?=
 =?utf-8?B?bmtnb2lGRS93ZzdYRnJKdUlwRkZhSUV1TlFVb3Vsbk43Yi9tMXlIKzJobzBI?=
 =?utf-8?B?dUVTWWNGa0N0dThBd2NMVFZJemZMWGE2cTBMNWNqdEFPY3hxSFhKZVZjKzgw?=
 =?utf-8?B?NUlmalpNZGxyNlVRYzNYbkEwb2lvUTdlam1iMVc1bFRBV2lwa2RQMmMrdFkr?=
 =?utf-8?B?YXBkUHNHYmt6Wll0TWY3L09OdHVvUTNjendKNlJ2Rno1aVM1cHQ0TU1wL0JL?=
 =?utf-8?B?OTMzTFRwN1RPeExHRVFOaS9WODdtM0tQS3RDN1BSVFVsRTJEUkx4aXJMN01Y?=
 =?utf-8?B?cW42UkF1TnpldFhKR2RUK0c3c0xlZUtieVFqNnE1S01LcnFpaXV4R2VpT1Nl?=
 =?utf-8?B?QlFMKzZVOU03cVk0Z2t0TmV2d3dUSnl6d2xDZ00vL1JYZkxNQVpwSHRYS1Rs?=
 =?utf-8?B?Q2JSOHprV3lyOGkwUFdqcEl2aFMyN1c3akxwNERPTU5TNHNLUVF1Q09ySktV?=
 =?utf-8?B?WXZKK2g2Vmp5MTJhY1ZBemc1Vkh3VVdjdnMwdHJaYXZFTTZIam5Gb1lVYnFL?=
 =?utf-8?B?RDhsSU1QQ2Q4R3l2VVBQalgwb2wvU0VnUmRZWTVoTEtvK2pTNEFISXlsWkgw?=
 =?utf-8?B?dUFjZ1ZWM3JZL0tLYVRBZDFHSWRTU0FURVBQRkRYVm1MVEcwK3FldFlFQ3Q0?=
 =?utf-8?Q?tZEjCw5jkAEtsO5I82P10SSR9?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1072B1401784AE4E8FE0E1D2903AD52A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca558c9d-7a90-4fd8-8819-08de22a97075
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2025 11:40:26.4692
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dLz7d6kcOvsi92hXYEIZCDfEsljpkmwfQDuzOXJpYWWHa3dFI12aH8Gr5+X2YRR3NfyYzRZuFlUVA7dmFA5yNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5779
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTExLTEzIGF0IDExOjAyICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOgo+IEkg
YW0gdGhpbmtpbmcgZHJvcHBpbmcgYm90aCAiSHVuayAxIiBhbmQgIkh1bmsgMyIuwqAgVGhpcyBh
dCBsZWFzdCBtYWtlcwo+IGt2bV9zcGxpdF9jcm9zc19ib3VuZGFyeV9sZWFmcygpIG1vcmUgcmVh
c29uYWJsZSwgSU1ITy4KPiAKPiBTb21ldGhpbmcgbGlrZSBiZWxvdzoKPiAKPiBAQCAtMTU1OCw3
ICsxNTU4LDkgQEAgc3RhdGljIGludCB0ZHBfbW11X3NwbGl0X2h1Z2VfcGFnZShzdHJ1Y3Qga3Zt
ICprdm0sIHN0cnVjdAo+IHRkcF9pdGVyICppdGVyLAo+IMKgc3RhdGljIGludCB0ZHBfbW11X3Nw
bGl0X2h1Z2VfcGFnZXNfcm9vdChzdHJ1Y3Qga3ZtICprdm0sCj4gwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgc3RydWN0IGt2bV9tbXVfcGFnZSAqcm9vdCwKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBnZm5fdCBzdGFydCwgZ2ZuX3QgZW5kLAo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaW50IHRh
cmdldF9sZXZlbCwgYm9vbCBzaGFyZWQpCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBpbnQgdGFy
Z2V0X2xldmVsLCBib29sIHNoYXJlZCwKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGJvb2wgb25s
eV9jcm9zc19ib3VuZGFyeSwKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGJvb2wgKnNwbGl0KQo+
IMKgewo+IMKgwqDCoMKgwqDCoMKgIHN0cnVjdCBrdm1fbW11X3BhZ2UgKnNwID0gTlVMTDsKPiDC
oMKgwqDCoMKgwqDCoCBzdHJ1Y3QgdGRwX2l0ZXIgaXRlcjsKPiBAQCAtMTU4NCw2ICsxNTg2LDkg
QEAgc3RhdGljIGludCB0ZHBfbW11X3NwbGl0X2h1Z2VfcGFnZXNfcm9vdChzdHJ1Y3Qga3ZtICpr
dm0sCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGlmICghaXNfc2hhZG93X3ByZXNl
bnRfcHRlKGl0ZXIub2xkX3NwdGUpIHx8Cj4gIWlzX2xhcmdlX3B0ZShpdGVyLm9sZF9zcHRlKSkK
PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGNvbnRpbnVl
Owo+IMKgCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKG9ubHlfY3Jvc3NfYm91
bmRhcnkgJiYgIWl0ZXJfY3Jvc3NfYm91bmRhcnkoJml0ZXIsIHN0YXJ0LAo+IGVuZCkpCj4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGNvbnRpbnVlOwo+ICsK
PiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgaWYgKCFzcCkgewo+IMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgcmN1X3JlYWRfdW5sb2NrKCk7Cj4g
wqAKPiBAQCAtMTYxOCw2ICsxNjIzLDcgQEAgc3RhdGljIGludCB0ZHBfbW11X3NwbGl0X2h1Z2Vf
cGFnZXNfcm9vdChzdHJ1Y3Qga3ZtICprdm0sCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoCBnb3RvIHJldHJ5Owo+IMKgCj4gwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgIHNwID0gTlVMTDsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCAq
c3BsaXQgPSB0cnVlOwo+IMKgwqDCoMKgwqDCoMKgIH0KCkZvcmdvdCB0byBzYXksIGlmIG5lZWRl
ZCwgd2UgY2FuIHVwZGF0ZSBAc3BsaXQgb25seSB3aGVuIGl0IGlzIGEgdmFsaWQgcG9pbnRlcjoK
CgkJaWYgKHNwbGl0KQoJCQkqc3BsaXQgPSB0cnVlOwoKVGhpcyBhbGxvd3MgdGhlIGNhbGxlciB0
byBiZSBhYmxlIHRvIGp1c3QgcGFzcyBOVUxMIHdoZW4gaXQgZG9lc24ndCBjYXJlIGFib3V0Cndo
ZXRoZXIgc3BsaXQgaGFzIGJlZW4gZG9uZS4K

