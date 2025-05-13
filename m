Return-Path: <kvm+bounces-46380-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DCB5AB5D02
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 21:18:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5E9823BB5CA
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 19:17:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 275892BF3DF;
	Tue, 13 May 2025 19:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M+8P4pJX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7381CD0C;
	Tue, 13 May 2025 19:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747163880; cv=fail; b=QAQKMtot5NKP2f4dvlqjNYaoin7DMmi3P+KKv489t4MjMKxI/5qI7y4vwPDI+woLqJr7/Z8fOS4DvlfiAk18CevSMvcFcKsfulVWKdEVyKGJ6wkBIva2gpURLwOr/fr+h93DtNQzg8DCxUgKw1kTj0sjsJJCluveJfMpoYazAOo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747163880; c=relaxed/simple;
	bh=nWOVEiV69Ov5Gi8ZqLJdZzSuKdiYAsysje7LhQQJTq8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hpPP8H+9PZHMmJbCLJMixhZ79B7e2dyAe26w+yk8McpyKn2Kb0iz4ZD15W9hKd7BPFLRPvcEtoVJv506T3HCgGRnQPAnswHa4EpB3k8Ao4YGLLukyvQS7wkUXoHRUwvvpWUVaUTPWuE3PfGExR8v942+NqWvO7PFs4LprgiAmDA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M+8P4pJX; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747163878; x=1778699878;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=nWOVEiV69Ov5Gi8ZqLJdZzSuKdiYAsysje7LhQQJTq8=;
  b=M+8P4pJXu61q5JyLrVJXf7PKBwSuPOvQZQCYme607c/STemb7F4UrRy7
   wsxxi4dlcZr5Sw7SKJWWpciC3KEQWMH+ApHDUgCAOORYy+YliFqVu9C9L
   vCFEI9utUDs/zsZyIJKxGY4emuT/EZAsc/QmPL7FDsvrL/Em7sKO3fOXT
   Mf3MiUGwnfsiyRaydafZ02JOe5cuZPDP2MXP3GHjyJ5DiyeHBENCYLJ79
   z11ButOjg72J0IGo65tpEaNL47ofyWwHYC2AJra3Mb2nPLoQxPe4ozZjy
   TpZgZrkSKERPt+7rwgQfnqxdgP41mgnjD6k+XIZtZXPA+x2HMmfZocUa4
   Q==;
X-CSE-ConnectionGUID: Dtoy79xDQV2bVLbWEQXS9w==
X-CSE-MsgGUID: Ti8SWIU1SLy83lood3bvPw==
X-IronPort-AV: E=McAfee;i="6700,10204,11432"; a="60045419"
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="60045419"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 12:17:57 -0700
X-CSE-ConnectionGUID: BhRvPMDXRtCyFOX5X77YSQ==
X-CSE-MsgGUID: cIrGj4lFRzSoZ97BuHkBZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="168742386"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 12:17:58 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 13 May 2025 12:17:56 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 13 May 2025 12:17:56 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 13 May 2025 12:17:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mnZ7HtyvzI29hgPceNAZRu4VUjeTg/oJxxNbLSGsXInguC5HF2VO0viUSlIB5n+zgUzagg3IKvI/HUVClnds98+pGmTpRZDQEAC3UtdL5OFql3HLayzLFwb8r8A2Q26S7A5ruxyrVHLrmPAaiI9Sbyju2Zx+WSAi4MCiAPpg85t2tzFN3i+GVMBk+x8x7ozALQFcReH1HIKFmEhjWmQIf9RRDrLyjoLaJHlqQr7RUDpgBC/Kl6lt2VzU4Nd4bVyG83+Yc545zJpRTxfzNR1kyAP2mbHo9i58v8Z0497/JWgehhYlmo2uUnJ8t85nTZUQes1t74ttiK7z8cjLjk6Tyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nWOVEiV69Ov5Gi8ZqLJdZzSuKdiYAsysje7LhQQJTq8=;
 b=bz/7GLcOXdBDIX02CPcPGFfpP0BT8Eoc5DID24ZQEbwD/fouhmTquCmMSEyrkq3gsjJvqgDLRyqYsxf74Ms7e+HZwkCWqsgM3OWXZ4A6u2rSmTorAW4K2i0rpOgReo7KhAQ1tCUAOir59MChprs542iHnIv4RW767HBqzmcH9qSlBWuE55xx7k1ylET5Yprm+ARMS7gmdj8ggNyvepocyvxynldHK0lDKR3SOxwELYH79lo412Jw5tXiEoaxHZXnN4RjQsBdD1lVWJc00hdDFd30vBfOQH4j58otByDOdr2gaYqMo+GqVPUj4EDMVXCTeWb8kg2km7AMsSJtqlcFUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH0PR11MB5063.namprd11.prod.outlook.com (2603:10b6:510:3d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8699.26; Tue, 13 May
 2025 19:17:40 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8722.020; Tue, 13 May 2025
 19:17:40 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>
CC: "Shutemov, Kirill" <kirill.shutemov@intel.com>, "quic_eberman@quicinc.com"
	<quic_eberman@quicinc.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "Li, Zhiquan1" <zhiquan1.li@intel.com>, "Du, Fan"
	<fan.du@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "michael.roth@amd.com"
	<michael.roth@amd.com>, "Weiny, Ira" <ira.weiny@intel.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "Peng, Chao P" <chao.p.peng@intel.com>,
	"Annapurve, Vishal" <vannapurve@google.com>, "jroedel@suse.de"
	<jroedel@suse.de>, "Miao, Jun" <jun.miao@intel.com>, "pgonda@google.com"
	<pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 05/21] KVM: TDX: Enhance tdx_clear_page() to support
 huge pages
Thread-Topic: [RFC PATCH 05/21] KVM: TDX: Enhance tdx_clear_page() to support
 huge pages
Thread-Index: AQHbtMYE/Jr/OXmOCEKX0TG3rlsFGrPRDdaA
Date: Tue, 13 May 2025 19:17:40 +0000
Message-ID: <6e9d7b566e7e67699b012ae84d83f36de32098a5.camel@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
	 <20250424030516.32740-1-yan.y.zhao@intel.com>
In-Reply-To: <20250424030516.32740-1-yan.y.zhao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH0PR11MB5063:EE_
x-ms-office365-filtering-correlation-id: f380f872-e30d-4fc2-bc5d-08dd9252d46c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?WldFQmhrTml3bWlydHJXOXVQZzJ0UmM5MzF5bDMyN3dDTjN5UjA4dS95bmd0?=
 =?utf-8?B?a2M5SjVEWXd1cG5FVVVVYVBBUUQ3Ly96ZXI0cDJCK0IzcEJVTThUL1l3alNt?=
 =?utf-8?B?dUY0Tzdla0ZZSkhTK3RoWHFla0tIZ253NWVQYWlhRWY1UE1tdk5KL2FQQXdn?=
 =?utf-8?B?cjl1cSttbFJ6dm1HdW50dUNTblpWWFJyTGJhbXVTODRZdUg1TTYzRnNPNHFW?=
 =?utf-8?B?UzZSRGNGbG5pUHNzMDNWaVMyVHdFbWVjY21rVlFUNnNNNVc2Sm9CWExwb2hm?=
 =?utf-8?B?WktWd2h0dkwyZE51Vnd6dytkNzI2aVVtamRwQW9KR2krblc3djFhWVdZaDZN?=
 =?utf-8?B?T2hPai95djdBb0loRHlJRHV2UVBCSWxNR1FkaUFHTG1ZaUFNVGZPS3ZsbHhX?=
 =?utf-8?B?RWhlM0VRanUyeVJEVDRIajNuM1dCbkJvcTdubWxxcE53QzdqblJYdjFoVSt5?=
 =?utf-8?B?LzdpdUNDSU9SdVlKQXB2SEg3SERVbUJuUVlzeE90dmVLK2lIdXZpcUpIajdM?=
 =?utf-8?B?VTU2YzVPYzlhL3lqL2pTeTlLbnJ4TktJL0E2ZjNQZlUvMjZNbXNJQkIrNm1L?=
 =?utf-8?B?SGI2NHdHMGREL0NrcTVWMkFVcE9nRDJzZkpvTkNmazFuVDJPeW5ybVliQ0Jm?=
 =?utf-8?B?MXNXZm50RFBhY1hoK21kWk8rRDgrSjlYZ3A3emxSdlJXcEppOWcweWZXbkds?=
 =?utf-8?B?Y1J2WmdEUEM4ZFVWTXJNS1BaTWVXU3R1WFg1Wlc5K3B4R2JaMlNCNTZ5VnFn?=
 =?utf-8?B?RFdoT2I2UE54VVdyN3lnMVNVbXlsNGFyYTFWamIwZ2xKZU1OMU9zaHJQbjdY?=
 =?utf-8?B?V01Da0g1dGg2ZjMrSkR0aHRqN1A5Z2V5dG5DYlZvTTMvRVl6QllSWGpqOE9s?=
 =?utf-8?B?UXgvSmY3dkNXbUVVUE43VnJXWHpkMmdnemFBT3BUeGN6UStweU5scW1NRDlP?=
 =?utf-8?B?VnQ5TDBraDNHem01dVJFMXRmLzMzNjdSU3dZY2lZcWYxQ2o1YmNPUThqL1NE?=
 =?utf-8?B?dVViOGUzRlFKeHMwaW0rYlQ2bUc2a1ZkY3dCSzBLdTN1VEdab3FsTnlNWVhJ?=
 =?utf-8?B?SDQvY0JDVUtYenMvN3JnY0pucVozS3JHMi9QYjZ3dFE4U0dabVpiTFBMZXNi?=
 =?utf-8?B?UjRBSXNBWktTVktvWFhCN01GQzU1Qks2QXluYkdsU2dVMUw4Yml1RkhTUEFm?=
 =?utf-8?B?ZHVZeG0yMWlYT05XTWg3SEFJUkpqN0c5WDR3TmRXOXJZdUoxaDJ4dExKUk5l?=
 =?utf-8?B?bmdJUzFSZDlCVzBrQWFxUWd2K0VXTllGY1lKR2dVNzBSRTRpYnlub3BwUFpv?=
 =?utf-8?B?VjZ4bXBxbFlxclNTRmpISUphV3c5RC9yNi9lYlFPeXVHSVh0TVE2OUhtU0lo?=
 =?utf-8?B?L1BHUWNaanVjTDVqbTluRmcxRmZ5K0dQak9BeXdCd0xrQmJGR1gzbFVKV0dG?=
 =?utf-8?B?bXV4elB6Tm1HVHduckhPVGxTM24ya3dlbEFuWmVlbE9xc1dLSEIySlA4UC9O?=
 =?utf-8?B?Nm9lWURsRFJXeGs5Z2t0NERMVzNzb1RxTDVZNm45K1dadHZ1bFgyL1NkaWxS?=
 =?utf-8?B?T3RCbFNxWVNjbXRjUGN1RGh2RjU2c3c2S0xRRFdSdVJTMFoxbVZxeXFjZysx?=
 =?utf-8?B?RS9panhlNk55UlMyS1llSEtZUkVDbnJIWW5BdHZYRFZFdS8vdVZXV3Jsc25M?=
 =?utf-8?B?RG1RWW8wNlhrM2Z3bXkxZFNUQStzYjYzOFF6ejlhdWlsdjhtUFlXZzdkYkRm?=
 =?utf-8?B?OURrTGd5YWc1YzJreFpzVWpDeVRzNTg0YzNjTnNZUHFxNFUrSFk1T2ZpTld2?=
 =?utf-8?B?M0FkZi9zL2dRQklSa2xRdVdYbC9QMXhFWWFOcU5qRmcySGU2QTQyUjQ3bVY3?=
 =?utf-8?B?bzlkakJzNVNsMFhRSG8rcEg2ci8zeDFUbmRtQkZQWWoySGQ1NXdEVHViMDZQ?=
 =?utf-8?B?L3lRTkJXOHo0OTZwcVhDME84b1hvVzhTcGhCTzByTjQwa1BPZkhoclh1Z2hW?=
 =?utf-8?Q?pmw2OpYRqfNUo+3M/B3qJNwFOHICSk=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RFF5SHBmRFF6TDdSYjJ0R091Wlp2c2NRVE9aMHJHR25TcURTdWp0WFpobjZY?=
 =?utf-8?B?c0xud25IVFRQeDNycEdCWGZhMHBwN0lrdDdTdFJMZ3ZLcHI2dFMyUnQ5dWZU?=
 =?utf-8?B?NnQwWUEya0QxYXFIeE5VSUFtU25iRk82NGNyQjM4N2lIVmFSSTJndFJqcGY1?=
 =?utf-8?B?MTd5VGZUdmIzU1VUVHBTcVIrSU9Meis1NFZHRytzK0pQOEVLTVV2dXlYR2V6?=
 =?utf-8?B?UFdkOGdlem5ycGVDVnRqdFdyWFh5RllxbG9JclI2MGFKQTgxY21PbVZmcmpE?=
 =?utf-8?B?dkRjT3JJdXVrV2hYSGtLUE9YdnozUWZmV2Q3YjRXZDJvSjV6c3d6aVhtRUEw?=
 =?utf-8?B?eXRHUCs5M0FVMnFkdVFadkxvcENHN3VGR0ZvT21rL0lWSVF4NFNISE55V2dW?=
 =?utf-8?B?ZWk3WFZsYTVzK1B1WFFMTCtIU3Zma0Rva2dLTkJaNjhhRVZPWTAyOWpjbi9a?=
 =?utf-8?B?OVgyZDk3b1VTdVNSRENGNElpQm5ZeTNmM3gzU3Z6UGorSDZuWkVPdDNIakJp?=
 =?utf-8?B?YTZMdHREM2sxWngvRkVkVnlBTDlVMVZjbmlNdUhZSXlscGtQaHAzK2tzNXlp?=
 =?utf-8?B?eGJpaUhwR0s3OUJjZGlEM3N1dFhRU3gzNFcyVjJxL1NFQk1XNmc1WVFWa3Zn?=
 =?utf-8?B?UHFuaFdNNHRvRjdNQXBqRDJBWDhjYjRlSlcxdkNob2grQm01ZXRoMEloeDVn?=
 =?utf-8?B?REs3ZGxmSmdjTnVPdHdRbzRxRksrSXZsVlZka045U3VQaENLRkhpd3NqS2Vu?=
 =?utf-8?B?UGN2d1hycFdJSjloNnhEUGRrcW9XNjlFajlvSG51ekVROG9ObzAxUGFhR3Rv?=
 =?utf-8?B?L0Fjc00ra210eU5NOE9ZQXY3dW9iZmlyTnV2RkFzcnYrK3JPdTk4a201UXFh?=
 =?utf-8?B?QUtYOHZNaDFxRTAwWW56Y0RRdzI1aldWOU5iOVBna2tDOFVOZmNJSWcvc3hl?=
 =?utf-8?B?Nk55MWRnbDFFcldjcFBTb09paEo3VXh3b0JVR2tERktTanJ5ZjkzZDB2SUJ4?=
 =?utf-8?B?ajhmUlJ1K3daOUtlcEJ6QzROdzBIaWZJWGZ0RHZsdnhyL250S2xNZ3U0YXBr?=
 =?utf-8?B?Rm9jMkc0bUNIVFJkTDhMekYxTTZURWVNeEVFWk8yYjM1dFk0NXN2ZWlGRkRx?=
 =?utf-8?B?bzRybUJrVkxTNjFKay9Cbm9FQU8wbFpxK3FaUXZjYXMvVEFUTVh1RWd0TzNr?=
 =?utf-8?B?SE5jVHprMklmaFNodzRoMmJFRXd3a2Fua2JjWjhXQjNvQmFURXI0Y1R5SmVt?=
 =?utf-8?B?b0NOTFBIN00rc2pXTjJYNnJSbEk3aG1vVGdNWXBoWHVCMVRmRXc4eXJVdDF6?=
 =?utf-8?B?amU0WWx6ZUxib1l0ZzN2dnFaL0ZHTGVZK3VqV0d4d05TUTFHbzN4anBvTC81?=
 =?utf-8?B?Umt5NkNRSkd2d1U5WE91OWVuTU91K0MrTEx1WndMeVY1ZVVaZkw4N3NEakdj?=
 =?utf-8?B?b2JvM1pNenJvZkFMSVpNYjRnaXNydDdHZUVKeFNFTzZzYVI5NkNFanZzVzFn?=
 =?utf-8?B?L1l4QS8yNFRqbXVLanVWK1FsMTdmOUNVUE5FQkJCZzBrVm9RT3M1Mk1kQTBR?=
 =?utf-8?B?L0V5YXVVNUZCYzVON3dvQlpjRTFoaFpUVXlQNko1Nm4zTVBFZVpZWVhtbi9v?=
 =?utf-8?B?NGlEeTAreTh2R2ZYbjY0Z3FzMm1mZWRkQzJ0T1Z5aVo3b0w4ajdEUkVXSmky?=
 =?utf-8?B?OSt1anY3TSsyTGRoaFdkaGpvenMxZ0FRd2s3Z1J6aXEraDMwZjBWTC9zczNz?=
 =?utf-8?B?QkY2S0xpTWk1Z01BR1didTYrWTRraDR1eXl6Y3kwU0liTkFFOVJOQnhoWmxv?=
 =?utf-8?B?QU1nYnc1cVhJOU5SdlVReXRvL0QyWE1HT1RUUTA5d0tlRnllc1JxUkRma296?=
 =?utf-8?B?SmowQnpUYUFJMldJSGg1dEtZOHI3RnVrNjZlOU5ubnI0VTF6dTdDWnFDWnkw?=
 =?utf-8?B?QldCdkdOdjFIU3dveDBaSTQ4eHZPREUwbzNBSWhDM2U1VkRNL0dPelhCcFNF?=
 =?utf-8?B?a1hlSW83OW80bUR2YXRBeUkxbzZ1UU9COEhBeEpWZFNaTDNDMlhKRE1QYWVM?=
 =?utf-8?B?KzFUM3NsN2dQRWFNcG1WenYxQzJRcmx1bmJOd3h0c2xKL1VwdTFybXNrMkJy?=
 =?utf-8?B?R3FsQnFraFF3aDRFNE92MW4zeGtuTlJpOGE1Z25UOXlnNGtnb09uWnJSNEJN?=
 =?utf-8?Q?y/ZQVFtcm6P6RsvYTRm6DHY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C4AA7244ADB9C14FB278F4CDC4771985@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f380f872-e30d-4fc2-bc5d-08dd9252d46c
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2025 19:17:40.5084
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XBVolsmMhaGlmhFi4wrcNAvGjkaQzTi66RxkU18ZL49sND+xILfbR0MKfbCT29VFZ7M4chsUgdyGvYm5P+mTGA7CyUKT1mfvqDdFW7suLvU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5063
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA0LTI0IGF0IDExOjA1ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gRnJv
bTogWGlhb3lhbyBMaSA8eGlhb3lhby5saUBpbnRlbC5jb20+DQo+IA0KPiBLVk0gaW52b2tlcyB0
ZHhfY2xlYXJfcGFnZSgpIHRvIHplcm8gcGFnZXMgdXNpbmcgbW92ZGlyNjRiKCkuDQo+IEluY2x1
ZGUgbGV2ZWwgaW5mb3JtYXRpb24gdG8gZW5hYmxlIHRkeF9jbGVhcl9wYWdlKCkgdG8gemVybyBh
IGh1Z2UgcGFnZS4NCj4gDQo+IFtZYW46IHNwbGl0IG91dCwgbGV0IHRkeF9jbGVhcl9wYWdlKCkg
YWNjZXB0IGxldmVsXQ0KPiANCj4gU2lnbmVkLW9mZi1ieTogWGlhb3lhbyBMaSA8eGlhb3lhby5s
aUBpbnRlbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55YW1h
aGF0YUBpbnRlbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFlhbiBaaGFvIDx5YW4ueS56aGFvQGlu
dGVsLmNvbT4NCj4gLS0tDQo+ICBhcmNoL3g4Ni9rdm0vdm14L3RkeC5jIHwgMTkgKysrKysrKysr
KysrKystLS0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDE0IGluc2VydGlvbnMoKyksIDUgZGVsZXRp
b25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3ZteC90ZHguYyBiL2FyY2gv
eDg2L2t2bS92bXgvdGR4LmMNCj4gaW5kZXggMDM4ODVjYjI4NjliLi4xMTg2MDg1Nzk1YWMgMTAw
NjQ0DQo+IC0tLSBhL2FyY2gveDg2L2t2bS92bXgvdGR4LmMNCj4gKysrIGIvYXJjaC94ODYva3Zt
L3ZteC90ZHguYw0KPiBAQCAtMjc2LDcgKzI3Niw3IEBAIHN0YXRpYyBpbmxpbmUgdm9pZCB0ZHhf
ZGlzYXNzb2NpYXRlX3ZwKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4gIAl2Y3B1LT5jcHUgPSAt
MTsNCj4gIH0NCj4gIA0KPiAtc3RhdGljIHZvaWQgdGR4X2NsZWFyX3BhZ2Uoc3RydWN0IHBhZ2Ug
KnBhZ2UpDQo+ICtzdGF0aWMgdm9pZCBfX3RkeF9jbGVhcl9wYWdlKHN0cnVjdCBwYWdlICpwYWdl
KQ0KPiAgew0KPiAgCWNvbnN0IHZvaWQgKnplcm9fcGFnZSA9IChjb25zdCB2b2lkICopIHBhZ2Vf
dG9fdmlydChaRVJPX1BBR0UoMCkpOw0KPiAgCXZvaWQgKmRlc3QgPSBwYWdlX3RvX3ZpcnQocGFn
ZSk7DQo+IEBAIC0yOTUsNiArMjk1LDE1IEBAIHN0YXRpYyB2b2lkIHRkeF9jbGVhcl9wYWdlKHN0
cnVjdCBwYWdlICpwYWdlKQ0KPiAgCV9fbWIoKTsNCj4gIH0NCj4gIA0KPiArc3RhdGljIHZvaWQg
dGR4X2NsZWFyX3BhZ2Uoc3RydWN0IHBhZ2UgKnBhZ2UsIGludCBsZXZlbCkNCj4gK3sNCj4gKwl1
bnNpZ25lZCBsb25nIG5yID0gS1ZNX1BBR0VTX1BFUl9IUEFHRShsZXZlbCk7DQo+ICsJdW5zaWdu
ZWQgbG9uZyBpZHggPSAwOw0KPiArDQo+ICsJd2hpbGUgKG5yLS0pDQo+ICsJCV9fdGR4X2NsZWFy
X3BhZ2UobnRoX3BhZ2UocGFnZSwgaWR4KyspKTsNCg0KWW91IHNob3VsZG4ndCBuZWVkIGJvdGgg
aWR4IGFuZCBuci4NCg0KPiArfQ0KDQpTaW5jZSB0ZHhfY2xlYXJfcGFnZSgpIGhhcyBhIF9fbWIo
KSwgaXQgaXMgcHJvYmFibHkgd29ydGggY2hlY2tpbmcgdGhhdCB0aGlzDQpnZW5lcmF0ZXMgZWZm
aWNpZW50IGNvZGUsIGNvbnNpZGVyaW5nIHRoZSBsb29wcyB3aXRoaW4gbG9vcHMgcGF0dGVybi4N
Cg0KPiArDQo+ICBzdGF0aWMgdm9pZCB0ZHhfbm9fdmNwdXNfZW50ZXJfc3RhcnQoc3RydWN0IGt2
bSAqa3ZtKQ0KPiAgew0KPiAgCXN0cnVjdCBrdm1fdGR4ICprdm1fdGR4ID0gdG9fa3ZtX3RkeChr
dm0pOw0KPiBAQCAtMzQwLDExICszNDksMTAgQEAgc3RhdGljIGludCB0ZHhfcmVjbGFpbV9wYWdl
KHN0cnVjdCBwYWdlICpwYWdlKQ0KPiAgDQo+ICAJciA9IF9fdGR4X3JlY2xhaW1fcGFnZShwYWdl
KTsNCj4gIAlpZiAoIXIpDQo+IC0JCXRkeF9jbGVhcl9wYWdlKHBhZ2UpOw0KPiArCQl0ZHhfY2xl
YXJfcGFnZShwYWdlLCBQR19MRVZFTF80Syk7DQo+ICAJcmV0dXJuIHI7DQo+ICB9DQo+ICANCj4g
LQ0KPiAgLyoNCj4gICAqIFJlY2xhaW0gdGhlIFREIGNvbnRyb2wgcGFnZShzKSB3aGljaCBhcmUg
Y3J5cHRvLXByb3RlY3RlZCBieSBURFggZ3Vlc3Qncw0KPiAgICogcHJpdmF0ZSBLZXlJRC4gIEFz
c3VtZSB0aGUgY2FjaGUgYXNzb2NpYXRlZCB3aXRoIHRoZSBURFggcHJpdmF0ZSBLZXlJRCBoYXMN
Cj4gQEAgLTU4OCw3ICs1OTYsNyBAQCBzdGF0aWMgdm9pZCB0ZHhfcmVjbGFpbV90ZF9jb250cm9s
X3BhZ2VzKHN0cnVjdCBrdm0gKmt2bSkNCj4gIAkJcHJfdGR4X2Vycm9yKFRESF9QSFlNRU1fUEFH
RV9XQklOVkQsIGVycik7DQo+ICAJCXJldHVybjsNCj4gIAl9DQo+IC0JdGR4X2NsZWFyX3BhZ2Uo
a3ZtX3RkeC0+dGQudGRyX3BhZ2UpOw0KPiArCXRkeF9jbGVhcl9wYWdlKGt2bV90ZHgtPnRkLnRk
cl9wYWdlLCBQR19MRVZFTF80Syk7DQoNCldoeSBub3QgdGhlIF9fdGR4X2NsZWFyX3BhZ2UoKSB2
YXJpYW50PyBUaGUgcGF0Y2ggYWRkcyBpdCwgYnV0IGRvZXNuJ3QgcmVhbGx5DQp1c2UgaXQuIEp1
c3QgaW1wbGVtZW50IGl0IGFsbCBpbiB0ZHhfY2xlYXJfcGFnZSgpIHRoZW4uDQoNCj4gIA0KPiAg
CV9fZnJlZV9wYWdlKGt2bV90ZHgtPnRkLnRkcl9wYWdlKTsNCj4gIAlrdm1fdGR4LT50ZC50ZHJf
cGFnZSA9IE5VTEw7DQo+IEBAIC0xNjIxLDcgKzE2MjksOCBAQCBzdGF0aWMgaW50IHRkeF9zZXB0
X2Ryb3BfcHJpdmF0ZV9zcHRlKHN0cnVjdCBrdm0gKmt2bSwgZ2ZuX3QgZ2ZuLA0KPiAgCQlwcl90
ZHhfZXJyb3IoVERIX1BIWU1FTV9QQUdFX1dCSU5WRCwgZXJyKTsNCj4gIAkJcmV0dXJuIC1FSU87
DQo+ICAJfQ0KPiAtCXRkeF9jbGVhcl9wYWdlKHBhZ2UpOw0KPiArDQo+ICsJdGR4X2NsZWFyX3Bh
Z2UocGFnZSwgbGV2ZWwpOw0KPiAgCXRkeF91bnBpbihrdm0sIHBhZ2UpOw0KPiAgCXJldHVybiAw
Ow0KPiAgfQ0KDQo=

