Return-Path: <kvm+bounces-46400-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6BBCAB5FB1
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 00:57:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 16E9D463AD1
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 22:57:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D58FA213E67;
	Tue, 13 May 2025 22:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kOwLChfl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0BD11CACF3;
	Tue, 13 May 2025 22:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747177027; cv=fail; b=l6hLDst+Vr9UvNDcdalYZqBjbUI2g8F8IpCJhAv55zApL11Lz/B+5kY2sLW0Gk5gfkTQcZmipgqz+9DHxgZBqVhc30nu9AyL4bWuuHJo7w+26fHnf2fTSKFSHrCyPgYikPR3uRpIXNh31fVpfQAGvxkVeleNQpkyaRs2cUYd9d0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747177027; c=relaxed/simple;
	bh=ab5YPOfM4DqQISF3bo9jmJGrWhxLhoyXQ2hdbbjpxl0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=GjDWt/UuT6UfSctUKAq85Gh5QpskFhYCBr0YMxlZeHGGFtQtvrsjW+i476MyHMYci/KNKNIbbqqNCmQ6yBOAoCaa/ZIPfimXmUDMrhN+dyHsHbAv2sWkFsx4CChCsdiq47+6/80p5+RQ6x3BC8AJKG39ggwXbEgVbk+3qyR80zA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kOwLChfl; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747177025; x=1778713025;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ab5YPOfM4DqQISF3bo9jmJGrWhxLhoyXQ2hdbbjpxl0=;
  b=kOwLChflD3txx2svQ7wVx5klrAIRoMtfUhbbqpKbYC6Rvk55DvtqJmZx
   0i8hfH/G5I2pJuyiQU9mJcuTyg3o/oB95WwHwkpHqqM/ys8xavhx59V9F
   SfDoFVM3L+KYHyLN9SlJuGe0jh4tMkIE+AkNj3Or/AEtmLPk++faz3WC2
   t8tfwTiKWpwDywzwD70bjuYcEZ2W8OYRqfi+RUGvsYboXJkCEPpcIhQ0m
   UYZgTpzyVgqkK0Hc9Hg5zgNRNKsPCtFomMsq0mO8qMKhiUHRmtXBb93s5
   o53gwtUZMJp29r9egUiU1POO6NPMHipb3eI+5+p9UMaSwDg9GRqzfCIIn
   g==;
X-CSE-ConnectionGUID: +dAfNOeDT2SZ1WcoiWgkEA==
X-CSE-MsgGUID: DSI+DioZR82LDJnSrd8Pkg==
X-IronPort-AV: E=McAfee;i="6700,10204,11432"; a="52713778"
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="52713778"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 15:57:04 -0700
X-CSE-ConnectionGUID: lIyMcPv5TMOs2Y7mcRBLuQ==
X-CSE-MsgGUID: IxamxzgASSC8XTB8/iyVaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="142955667"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 15:57:04 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 13 May 2025 15:57:03 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 13 May 2025 15:57:03 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 13 May 2025 15:57:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sfGk9h6jR3ReXvCz5yGVx0izZtTcQ9AgiiRxu9JBsfXqm5YP+KugX2/P+3uP3KPeMYwEhwu4M6JBGaIBRE6MplWPSEIydKegOZ5Cu2F6B9e1ZT4o43l8bvGwlagQf2nP9yHCFHr/2X5o6L1inJjHC7xPA1m7BaSepxoRwqjEOW7djiHRAE7Px9IPzS+5Z1Ht6+CzLYZXV7HG3O80b7fSOvNwyjDP/obrySaoahg/CeZU1LQwUU2a9gpbFXRqXFbRtagM6WsAYrKQtJz/syNZTJnhuFF+2VNmIERmuplVWpN/uUcBM5XRHHYj+QsvsTPLX9PcQTsA3lJkvFLzd5Uz1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ab5YPOfM4DqQISF3bo9jmJGrWhxLhoyXQ2hdbbjpxl0=;
 b=j7yxRKJf3dHc/rfnuwM9igKpkPCbyTcsw6YUgGo2+vdtP64C/u0DxcTAT/m5ee1G1xe9NPywQIAUlVSXjhhrhqF6bmke9FNckCoaVQE4B5DLp5ELFPgmKSfT3jpVrEpZj0WoqOR6NYlhDYGU7OtDrMS4HEBSRKZPo8eBlNhfd31R4TawTuDACmcIcM/VJtNpj0HzDttGiyg78IMcWJSwpjsoPPMNYHdCtRJXR3H21fyc+rbl3ufqCghmhtfOCPjGJernNKTrlT5z2wQVc2TIlu3JP2vDOx3dy2er0HH20urF2UvgTnE4oeDymBJmU1qZSng/ZsZNCJDsGYTEBRzUwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM4PR11MB5970.namprd11.prod.outlook.com (2603:10b6:8:5d::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8722.23; Tue, 13 May 2025 22:56:27 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8722.020; Tue, 13 May 2025
 22:56:27 +0000
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
Subject: Re: [RFC PATCH 16/21] KVM: x86/mmu: Introduce
 kvm_split_boundary_leafs() to split boundary leafs
Thread-Topic: [RFC PATCH 16/21] KVM: x86/mmu: Introduce
 kvm_split_boundary_leafs() to split boundary leafs
Thread-Index: AQHbtMZq5aOSX6sBB0S9hhJvW+6Xh7PRSvSA
Date: Tue, 13 May 2025 22:56:26 +0000
Message-ID: <e989353abcafd102a9d9a28e2effe6f0d10cc781.camel@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
	 <20250424030816.470-1-yan.y.zhao@intel.com>
In-Reply-To: <20250424030816.470-1-yan.y.zhao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM4PR11MB5970:EE_
x-ms-office365-filtering-correlation-id: b5c9b792-22c9-4e8e-5d7e-08dd9271646e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Rm9lVnBJaXhVa1FjU0xKd1JJVzJmMmduUW93MjVkcWxRMDBIOTN1VWY3RjJa?=
 =?utf-8?B?N3l2R2FRQ3BqM2V6U0VjU3kyU3VnNU5ucGlIeHFLT2ovUVllQStYekZZZFBB?=
 =?utf-8?B?ZXhxT3EwUldJaWVFSXB0S2ZWRlhSeWFqUmFaUU5VbDYvNkZ2bStQM1JUUjgz?=
 =?utf-8?B?K01SbzhHUm1NbU04dTNWRUszQ0FtREhYc3RSWmo3MGV5d2dNQWJubUlkcVRQ?=
 =?utf-8?B?UWFLNVQwSUdjcFJJUmtjWG5SeW1xQThvUUFQbFZHNzZZNzQ1R01tc3AyblNM?=
 =?utf-8?B?QzRlanZsdmcwUkYvOTIwZ1FRV3RpRUhEdkhKWTJXU3VhSzhYTXhnNWtTRWMy?=
 =?utf-8?B?TFlZZXV5QWxNYkdvMFdxd3kyNFFsNXJzemdRd2JKRmZlbWtjYnBUM2lGNVV2?=
 =?utf-8?B?L1JqUlhWSUo4UW1sazEvT1kyOTI2b1k4dnlrcGRHVlVWRUJjYWlLVUFUM3pM?=
 =?utf-8?B?aWxuTUUxU0VHOWU2cFZBY1RlZ3VUY1oyaTBOaTNBbGtIQjlHT1JTSUp5MEUx?=
 =?utf-8?B?SWwzR3BpNFJ2VGJkaVhlMmp5V0ZaR2w3NTV5SjVNRGYzZ3M0Z2Z4RUR2NFQ2?=
 =?utf-8?B?UmhXaS80aGpMM2ZseFVMQjF4bWU2N2dEMysyWUZMWGJpOVRibDBUTzgwUlRq?=
 =?utf-8?B?NlVMNzZpSldhQS9pdWNZTko4NlRPU3dPZy9GRktRYkRDWTk5SFhNN0JMdERF?=
 =?utf-8?B?S2NTVlJoUWJMc0EvMjZwZmxaRUE3QzhCVU5LS3FjN0dnbnJjOGhVZWlZMHp2?=
 =?utf-8?B?Zy9nLzViRXYwb0lITXJ3cmxoMmF5YWtQc0ZubDdYU01nYzhJbjBka1A0T25C?=
 =?utf-8?B?Y3hsci9ONUlFWHhseUUvN25GU2dLZ1poMm9GUDFIOGNtSVJUbjFIMjJCeC9P?=
 =?utf-8?B?cFVMb2pYTGNGdFEwRDNWVGFWUThXZTdIRE5EWVM4TEQ4U2JSYmhWcGNoajZ5?=
 =?utf-8?B?K0FraHJJdXNsYXZwTTcyVWhHR3VVc3g0cCttaVJOQ3FwRVN6QVRiY3lzQ3p6?=
 =?utf-8?B?MzgxOTRVQUVCUitZdERQRFRsRXRCWlE4dHh2TGFuU3hxdGhncVNUVWFFWldR?=
 =?utf-8?B?VEphVXhZR0h4L0dzeWZYQittU3drQmJXY2pkNEhIS0VEeXFLNUpjTytJRE1r?=
 =?utf-8?B?QzB4R2YrY1orMFBTSndjaXRtazcrbmI0YUF3MGdPQ21YcTBrSlMyaGRneTdP?=
 =?utf-8?B?aER5NXBLYmRrazV1ellRVjlTRnhDbXpwbktaTmQwNjNqS2U4emgxUjBSNkRl?=
 =?utf-8?B?b3dUTUo5MzBlL3F0ZURUc2cxZ0FmQmhyNXJic052QUJsOXpGUGFQWTV0N01h?=
 =?utf-8?B?ekdIbWxreUNQZmgvdWduc1JjUUVDQng5L2ZSdDFkd0pxQnJHV0d6NXVoWUlD?=
 =?utf-8?B?RUtITDAxWTlZT3pnM3BmcEJDZFZ6dzNBOVhpV3lrRHllZi95M01Ra1NtZDBo?=
 =?utf-8?B?aFNzQWRXRGRlVHczSVVrekVnRFFYcUZ5aGkrRC91T1JXQVZyMDJhZkZQYlJG?=
 =?utf-8?B?YmVKOEdrWlRkUFQyYUZwT05oTkNzZU43c1RmTG1EMDNRdDFKWXdIYXRMTzAy?=
 =?utf-8?B?ZmE2OEwxNUovTUNYcjg4cGR1dFgveUZDSXd0TGcySWlwN1MyWTRTY0dSWjVU?=
 =?utf-8?B?cGhrSzI1cS82VllaZWFGQmorV0RXbzI5c0w1Uzg3YWJIK1FSWTd2VVc3U2V1?=
 =?utf-8?B?NmRKb0sxalBtUUxWR2tST0UzenBTeDJjY3hIL0lEMWhZV3QzT1R0T3pWQWRE?=
 =?utf-8?B?NXRvZnlNYjRxQkh4STZYS3Z4TkRqZzgyM2laTE1wcC9lTXV3TlFTOThzWGhh?=
 =?utf-8?B?SnlnRjlaelBOUmoycTdVUVNxbTBWTEhHMk1HSlJzUVU0Wkh3REFJdzRKY2Vp?=
 =?utf-8?B?cGR3QTcyNWtrdkhVcjlKVjhKSmpETExpcFVmRVJqRU8yUGJTWXNrYkU3V05z?=
 =?utf-8?B?bG5pVnFMc1VGMzhhRU1zc3JxSDk2M1VGMTZJd1BUVmxoRzBCM2pHQTk4MlEr?=
 =?utf-8?Q?Dl7j3whH9AVtp/PfBrOv4vofYF7/fM=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T3p0Y0V0ZUtZc043aTc5SnV3WGY4cXJFNFA1S2F6ZjFUdFlyQlYvcC9hYXBV?=
 =?utf-8?B?R2Ztd09MUWlKRDFvVFVhZTNqMlh1ZEZRcVhHeEdFc0V4NmNlUC85YktsckQ3?=
 =?utf-8?B?QlN4blB2cUNwYnRhMnFuSHBlTTVQWC9ZYUpkcmFjT3hnVHMvc0xyNEQ2QWUv?=
 =?utf-8?B?QU51OEo4K0oxZ3lyNmpXdEFTSmlqcU93M24vTWhNMlFQOEZQTzhJTlBpa1Fv?=
 =?utf-8?B?TStvZkZyQXJsYmtBa0VrTlhCWEl2TjFqd3JPZXIxNzJjVTFzQUVFSm9xVUZB?=
 =?utf-8?B?R1YwUXdVckg2UzFnWEhOQkVOcnFvZWhsRjBBSCtFS2h0Q1JVQjhPSEU1LzBs?=
 =?utf-8?B?emMya3h4RnRVRWVtMkpncnl5NlFEMjE4YXd4YUVMa2EzL0tHR3hlZVY0a1lT?=
 =?utf-8?B?SmhFa0I0cU5ubHROYmRLMU9IWS9oRWpKSllHeFg0ZlhZQ0E1bXcrWEZubTlu?=
 =?utf-8?B?aU4xbGo0T2pLU09VQlBXMi9OMUZxbVJRZ3BXckpRak80Y2pUNEg2RmJMYWE0?=
 =?utf-8?B?aWYxaUVkelRuRDh1UHhaNThVM0FZNzE4S3lLaFdGY2ZxVnJsNS8wZnRiZCtS?=
 =?utf-8?B?VnVyUmt4U05SWWlmM2RmUW9odW1JaVlHZ2pDNzBINmVlZ1dvRUNlS0tBc1Z5?=
 =?utf-8?B?WXdRYlJtSElrMmJLdmRjcVM1V3JTL1BwbVZpRVZaWUpLSU5oeHBVWTUrZmxD?=
 =?utf-8?B?V1dZcDlMY0VBSEVBZkRWV1BrdXBpcjEvWm1lbC9Hb25ZelEvaFFDcnQ4T3hH?=
 =?utf-8?B?ODVEWTBtemo4TXlodStOb0xRSENGbnl6aGlQRXB5QklxckZVeUZzZldwL2lU?=
 =?utf-8?B?eHhqdmxBRGNWL2N0T3Q0NkdHYTZFWnpqNXN5am1samZ5SXVYMXM2MkpVS005?=
 =?utf-8?B?YmI4dzI5UlpYZGFCNDdrNEJKR0pBYWlVT3hkblkzdFY3ZUFEUEdteEJ5dEtR?=
 =?utf-8?B?VjZscnVuaGQvdHhzc1k4ZTY4S3NMeC94a2pxcExPekUyUHNjVmlyR2xZRHVl?=
 =?utf-8?B?cjk0REs5eGM2TnNTRXlMbTllQmRxMEMxNEh0ajZMWC94d1ZmMk84TDdldFRU?=
 =?utf-8?B?N0luOTBuaXdmMXNCbmg4TC91M2w1WG9CMy9RSFdqclMvdUs4eHF2djlGN2pU?=
 =?utf-8?B?ZzhoRTIxR0VKZFBJWUllbFV2WjRHTVlKS2JiNElSYlR3a2NIVzJ2U2hvT2VO?=
 =?utf-8?B?emNDUFNwVUVrUE01THA3SG91aUVxamVxM1lOVGFwQnNWMDF1S2dpUnoycTBV?=
 =?utf-8?B?NGdIL3F0K3Q4bTFtUDZpUWVNZWloRjdyajdMRmZha3dBR2NQYkN5d0dJQmVv?=
 =?utf-8?B?Znp1bmlraWNPb3lpTkRGa0lPMkx0WmNBNFZQRVNMR3RjdzZqd3JTdTZjQkh5?=
 =?utf-8?B?UzRqMEVjT2lKbm5hYWd0T0tqWVlzVm5PMFJCWW1UVkVIZHkzaTlZRDVUaENU?=
 =?utf-8?B?TUV1WTdTRXBpMEtVUndTVkU1alBlSDlwZjFTWFhBT1E1WDVMUVFGMW5pNmR3?=
 =?utf-8?B?eHM4M3ZVWFpkZGVzbDdlYXBpTWZ4NHRlQ3d6N3JwVDJKZDI0MlRaR2I5cnhO?=
 =?utf-8?B?bURHRHlMUFRFK0tCd215ZS95SG1ORUh1bnBuWTIyTFFjYk5OYTZCSlNGaWRw?=
 =?utf-8?B?Y0RUcXQ2UHJneHdyWDVmVkhIQm1Uc08yNzZ3ZHRPclBEdzAwZnpvOWZtejIz?=
 =?utf-8?B?ZlY0YTY0UWFmYXdlZEkwd21PUTUySGdpbHFYUUhuTStPOGcwYSthbTRZTjFm?=
 =?utf-8?B?UXZnYzl2UzgyYjNLYnQ5MVhuRXZ2Z2VjM3BYWmticEZPcGsvZkJHSDBCNEhG?=
 =?utf-8?B?ZExGQVJ0YVFTREo2Z203TEZUb2ErZUgwRXlOMXhHbnR5Nm5Wa0JsSDZhMEc0?=
 =?utf-8?B?Q214OG1SRmNIWmljTEx3dzZKRzd0R3hhalFndDBaUy9jOHFhb0kxNWIrUUoy?=
 =?utf-8?B?T2VITFJXOFFQM3hOUDgvU0VkbnRiV3g4SmNnY25veUl6ZTVBQXFzUUFDQzdr?=
 =?utf-8?B?UUhBcTN1L0thbkQ1VlVXWFB5Vzd0T21mZWFPTm9NalF0VUdKd3Zudmc1b1Na?=
 =?utf-8?B?aDZsSkVIWjlWVExzNmtFM3NLTm0vUUEvZmdXZU9wVDF3WGIybTd6b1RmckZo?=
 =?utf-8?B?OVRDNjRJUzJqTVpVNGx1bEZRbU9UZmdVN3A1VzdUZU8vTFJYTC8xUmgyME9J?=
 =?utf-8?Q?pWvLSp8y53l55MNBhsze/R4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8069C5AD8940944A8A7FDDD7A1CC9F81@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b5c9b792-22c9-4e8e-5d7e-08dd9271646e
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2025 22:56:26.9960
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zvGc5OGWWzOENjqkR7DrpZaSvbFqh/yRXSLZpGiUlQHCDXzsm4dHMFX/vaqp0YbzJJOI6X1rKLXe5RqqK5YeuUPK6Zsb4AeQicm9kUBKoVM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5970
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA0LTI0IGF0IDExOjA4ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gSW50
cm9kdWNlIGt2bV9zcGxpdF9ib3VuZGFyeV9sZWFmcygpIHRvIG1hbmFnZSB0aGUgc3BsaXR0aW5n
IG9mIGJvdW5kYXJ5DQo+IGxlYWZzIHdpdGhpbiB0aGUgbWlycm9yIHJvb3QuDQo+IA0KPiBCZWZv
cmUgemFwcGluZyBhIHNwZWNpZmljIEdGTiByYW5nZSBpbiB0aGUgbWlycm9yIHJvb3QsIHNwbGl0
IGFueSBodWdlIGxlYWYNCj4gdGhhdCBpbnRlcnNlY3RzIHdpdGggdGhlIGJvdW5kYXJ5IG9mIHRo
ZSBHRk4gcmFuZ2UgdG8gZW5zdXJlIHRoYXQgdGhlDQo+IHN1YnNlcXVlbnQgemFwIG9wZXJhdGlv
biBkb2VzIG5vdCBpbXBhY3QgYW55IEdGTiBvdXRzaWRlIHRoZSBzcGVjaWZpZWQNCj4gcmFuZ2Uu
IFRoaXMgaXMgY3J1Y2lhbCBmb3IgdGhlIG1pcnJvciByb290IGFzIHRoZSBwcml2YXRlIHBhZ2Ug
dGFibGUNCj4gcmVxdWlyZXMgdGhlIGd1ZXN0J3MgQUNDRVBUIG9wZXJhdGlvbiBhZnRlciBmYXVs
dGluZyBiYWNrIGEgR0ZOLg0KPiANCj4gVGhpcyBmdW5jdGlvbiBzaG91bGQgYmUgY2FsbGVkIHdo
aWxlIGt2bS0+bW11X2xvY2sgaXMgaGVsZCBmb3Igd3JpdGluZy4gVGhlDQo+IGt2bS0+bW11X2xv
Y2sgaXMgdGVtcG9yYXJpbHkgcmVsZWFzZWQgdG8gYWxsb2NhdGUgbWVtb3J5IGZvciBzcCBmb3Ig
c3BsaXQuDQo+IFRoZSBvbmx5IGV4cGVjdGVkIGVycm9yIGlzIC1FTk9NRU0uDQo+IA0KPiBPcHBv
cnR1bmlzdGljYWxseSwgV0FSTiBpbiB0ZHBfbW11X3phcF9sZWFmcygpIGlmIHphcHBpbmcgYSBo
dWdlIGxlYWYgaW4NCj4gdGhlIG1pcnJvciByb290IGFmZmVjdHMgYSBHRk4gb3V0c2lkZSB0aGUg
c3BlY2lmaWVkIHJhbmdlLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogWGlhb3lhbyBMaSA8eGlhb3lh
by5saUBpbnRlbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IFlhbiBaaGFvIDx5YW4ueS56aGFvQGlu
dGVsLmNvbT4NCj4gLS0tDQo+ICBhcmNoL3g4Ni9rdm0vbW11L21tdS5jICAgICB8ICAyMSArKysr
KysrDQo+ICBhcmNoL3g4Ni9rdm0vbW11L3RkcF9tbXUuYyB8IDExNiArKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKystDQo+ICBhcmNoL3g4Ni9rdm0vbW11L3RkcF9tbXUuaCB8ICAg
MSArDQo+ICBpbmNsdWRlL2xpbnV4L2t2bV9ob3N0LmggICB8ICAgMSArDQo+ICA0IGZpbGVzIGNo
YW5nZWQsIDEzNiBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdp
dCBhL2FyY2gveDg2L2t2bS9tbXUvbW11LmMgYi9hcmNoL3g4Ni9rdm0vbW11L21tdS5jDQo+IGlu
ZGV4IDBlMjI3MTk5ZDczZS4uMGQ0OWM2OWI2YjU1IDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9r
dm0vbW11L21tdS5jDQo+ICsrKyBiL2FyY2gveDg2L2t2bS9tbXUvbW11LmMNCj4gQEAgLTE2NDAs
NiArMTY0MCwyNyBAQCBzdGF0aWMgYm9vbCBfX2t2bV9ybWFwX3phcF9nZm5fcmFuZ2Uoc3RydWN0
IGt2bSAqa3ZtLA0KPiAgCQkJCSBzdGFydCwgZW5kIC0gMSwgY2FuX3lpZWxkLCB0cnVlLCBmbHVz
aCk7DQo+ICB9DQo+ICANCj4gKy8qDQo+ICsgKiBTcGxpdCBsYXJnZSBsZWFmcyBhdCB0aGUgYm91
bmRhcnkgb2YgdGhlIHNwZWNpZmllZCByYW5nZSBmb3IgdGhlIG1pcnJvciByb290DQo+ICsgKg0K
PiArICogUmV0dXJuIHZhbHVlOg0KPiArICogMCA6IHN1Y2Nlc3MsIG5vIGZsdXNoIGlzIHJlcXVp
cmVkOw0KPiArICogMSA6IHN1Y2Nlc3MsIGZsdXNoIGlzIHJlcXVpcmVkOw0KPiArICogPDA6IGZh
aWx1cmUuDQo+ICsgKi8NCj4gK2ludCBrdm1fc3BsaXRfYm91bmRhcnlfbGVhZnMoc3RydWN0IGt2
bSAqa3ZtLCBzdHJ1Y3Qga3ZtX2dmbl9yYW5nZSAqcmFuZ2UpDQo+ICt7DQo+ICsJYm9vbCByZXQg
PSAwOw0KPiArDQo+ICsJbG9ja2RlcF9hc3NlcnRfb25jZShrdm0tPm1tdV9pbnZhbGlkYXRlX2lu
X3Byb2dyZXNzIHx8DQo+ICsJCQkgICAgbG9ja2RlcF9pc19oZWxkKCZrdm0tPnNsb3RzX2xvY2sp
KTsNCj4gKw0KPiArCWlmICh0ZHBfbW11X2VuYWJsZWQpDQo+ICsJCXJldCA9IGt2bV90ZHBfbW11
X2dmbl9yYW5nZV9zcGxpdF9ib3VuZGFyeShrdm0sIHJhbmdlKTsNCj4gKw0KPiArCXJldHVybiBy
ZXQ7DQo+ICt9DQo+ICsNCj4gIGJvb2wga3ZtX3VubWFwX2dmbl9yYW5nZShzdHJ1Y3Qga3ZtICpr
dm0sIHN0cnVjdCBrdm1fZ2ZuX3JhbmdlICpyYW5nZSkNCj4gIHsNCj4gIAlib29sIGZsdXNoID0g
ZmFsc2U7DQo+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vbW11L3RkcF9tbXUuYyBiL2FyY2gv
eDg2L2t2bS9tbXUvdGRwX21tdS5jDQo+IGluZGV4IDBmNjgzNzUzYTdiYi4uZDNmYmE1ZDExZWEy
IDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni9rdm0vbW11L3RkcF9tbXUuYw0KPiArKysgYi9hcmNo
L3g4Ni9rdm0vbW11L3RkcF9tbXUuYw0KPiBAQCAtMzI0LDYgKzMyNCw4IEBAIHN0YXRpYyB2b2lk
IGhhbmRsZV9jaGFuZ2VkX3NwdGUoc3RydWN0IGt2bSAqa3ZtLCBpbnQgYXNfaWQsIGdmbl90IGdm
biwNCj4gIAkJCQl1NjQgb2xkX3NwdGUsIHU2NCBuZXdfc3B0ZSwgaW50IGxldmVsLA0KPiAgCQkJ
CWJvb2wgc2hhcmVkKTsNCj4gIA0KPiArc3RhdGljIGludCB0ZHBfbW11X3NwbGl0X2h1Z2VfcGFn
ZShzdHJ1Y3Qga3ZtICprdm0sIHN0cnVjdCB0ZHBfaXRlciAqaXRlciwNCj4gKwkJCQkgICBzdHJ1
Y3Qga3ZtX21tdV9wYWdlICpzcCwgYm9vbCBzaGFyZWQpOw0KPiAgc3RhdGljIHN0cnVjdCBrdm1f
bW11X3BhZ2UgKnRkcF9tbXVfYWxsb2Nfc3BfZm9yX3NwbGl0KGJvb2wgbWlycm9yKTsNCj4gIHN0
YXRpYyB2b2lkICpnZXRfZXh0ZXJuYWxfc3B0KGdmbl90IGdmbiwgdTY0IG5ld19zcHRlLCBpbnQg
bGV2ZWwpOw0KPiAgDQo+IEBAIC05NjIsNiArOTY0LDE5IEBAIGJvb2wga3ZtX3RkcF9tbXVfemFw
X3NwKHN0cnVjdCBrdm0gKmt2bSwgc3RydWN0IGt2bV9tbXVfcGFnZSAqc3ApDQo+ICAJcmV0dXJu
IHRydWU7DQo+ICB9DQo+ICANCj4gK3N0YXRpYyBpbmxpbmUgYm9vbCBpdGVyX3NwbGl0X3JlcXVp
cmVkKHN0cnVjdCBrdm0gKmt2bSwgc3RydWN0IGt2bV9tbXVfcGFnZSAqcm9vdCwNCj4gKwkJCQkg
ICAgICAgc3RydWN0IHRkcF9pdGVyICppdGVyLCBnZm5fdCBzdGFydCwgZ2ZuX3QgZW5kKQ0KPiAr
ew0KPiArCWlmICghaXNfbWlycm9yX3NwKHJvb3QpIHx8ICFpc19sYXJnZV9wdGUoaXRlci0+b2xk
X3NwdGUpKQ0KPiArCQlyZXR1cm4gZmFsc2U7DQo+ICsNCj4gKwkvKiBGdWxseSBjb250YWluZWQs
IG5vIG5lZWQgdG8gc3BsaXQgKi8NCj4gKwlpZiAoaXRlci0+Z2ZuID49IHN0YXJ0ICYmIGl0ZXIt
PmdmbiArIEtWTV9QQUdFU19QRVJfSFBBR0UoaXRlci0+bGV2ZWwpIDw9IGVuZCkNCj4gKwkJcmV0
dXJuIGZhbHNlOw0KPiArDQo+ICsJcmV0dXJuIHRydWU7DQo+ICt9DQo+ICsNCj4gIC8qDQo+ICAg
KiBJZiBjYW5feWllbGQgaXMgdHJ1ZSwgd2lsbCByZWxlYXNlIHRoZSBNTVUgbG9jayBhbmQgcmVz
Y2hlZHVsZSBpZiB0aGUNCj4gICAqIHNjaGVkdWxlciBuZWVkcyB0aGUgQ1BVIG9yIHRoZXJlIGlz
IGNvbnRlbnRpb24gb24gdGhlIE1NVSBsb2NrLiBJZiB0aGlzDQo+IEBAIC05OTEsNiArMTAwNiw4
IEBAIHN0YXRpYyBib29sIHRkcF9tbXVfemFwX2xlYWZzKHN0cnVjdCBrdm0gKmt2bSwgc3RydWN0
IGt2bV9tbXVfcGFnZSAqcm9vdCwNCj4gIAkJICAgICFpc19sYXN0X3NwdGUoaXRlci5vbGRfc3B0
ZSwgaXRlci5sZXZlbCkpDQo+ICAJCQljb250aW51ZTsNCj4gIA0KPiArCQlXQVJOX09OX09OQ0Uo
aXRlcl9zcGxpdF9yZXF1aXJlZChrdm0sIHJvb3QsICZpdGVyLCBzdGFydCwgZW5kKSk7DQo+ICsN
Cg0KS2luZCBvZiB1bnJlbGF0ZWQgY2hhbmdlPyBCdXQgZ29vZCBpZGVhLiBNYXliZSBmb3IgYW5v
dGhlciBwYXRjaC4NCg0KPiAgCQl0ZHBfbW11X2l0ZXJfc2V0X3NwdGUoa3ZtLCAmaXRlciwgU0hB
RE9XX05PTlBSRVNFTlRfVkFMVUUpOw0KPiAgDQo+ICAJCS8qDQo+IEBAIC0xMjQ2LDkgKzEyNjMs
NiBAQCBzdGF0aWMgaW50IHRkcF9tbXVfbGlua19zcChzdHJ1Y3Qga3ZtICprdm0sIHN0cnVjdCB0
ZHBfaXRlciAqaXRlciwNCj4gIAlyZXR1cm4gMDsNCj4gIH0NCj4gIA0KPiAtc3RhdGljIGludCB0
ZHBfbW11X3NwbGl0X2h1Z2VfcGFnZShzdHJ1Y3Qga3ZtICprdm0sIHN0cnVjdCB0ZHBfaXRlciAq
aXRlciwNCj4gLQkJCQkgICBzdHJ1Y3Qga3ZtX21tdV9wYWdlICpzcCwgYm9vbCBzaGFyZWQpOw0K
PiAtDQo+ICAvKg0KPiAgICogSGFuZGxlIGEgVERQIHBhZ2UgZmF1bHQgKE5QVC9FUFQgdmlvbGF0
aW9uL21pc2NvbmZpZ3VyYXRpb24pIGJ5IGluc3RhbGxpbmcNCj4gICAqIHBhZ2UgdGFibGVzIGFu
ZCBTUFRFcyB0byB0cmFuc2xhdGUgdGhlIGZhdWx0aW5nIGd1ZXN0IHBoeXNpY2FsIGFkZHJlc3Mu
DQo+IEBAIC0xMzQxLDYgKzEzNTUsMTAyIEBAIGludCBrdm1fdGRwX21tdV9tYXAoc3RydWN0IGt2
bV92Y3B1ICp2Y3B1LCBzdHJ1Y3Qga3ZtX3BhZ2VfZmF1bHQgKmZhdWx0KQ0KPiAgCXJldHVybiBy
ZXQ7DQo+ICB9DQo+ICANCj4gKy8qDQo+ICsgKiBTcGxpdCBsYXJnZSBsZWFmcyBhdCB0aGUgYm91
bmRhcnkgb2YgdGhlIHNwZWNpZmllZCByYW5nZSBmb3IgdGhlIG1pcnJvciByb290DQo+ICsgKi8N
Cj4gK3N0YXRpYyBpbnQgdGRwX21tdV9zcGxpdF9ib3VuZGFyeV9sZWFmcyhzdHJ1Y3Qga3ZtICpr
dm0sIHN0cnVjdCBrdm1fbW11X3BhZ2UgKnJvb3QsDQo+ICsJCQkJCWdmbl90IHN0YXJ0LCBnZm5f
dCBlbmQsIGJvb2wgY2FuX3lpZWxkLCBib29sICpmbHVzaCkNCj4gK3sNCj4gKwlzdHJ1Y3Qga3Zt
X21tdV9wYWdlICpzcCA9IE5VTEw7DQo+ICsJc3RydWN0IHRkcF9pdGVyIGl0ZXI7DQo+ICsNCj4g
KwlXQVJOX09OX09OQ0UoIWNhbl95aWVsZCk7DQoNCldoeSBwYXNzIHRoaXMgaW4gdGhlbj8NCg0K
PiArDQo+ICsJaWYgKCFpc19taXJyb3Jfc3Aocm9vdCkpDQo+ICsJCXJldHVybiAwOw0KDQpXaGF0
IGlzIHNwZWNpYWwgYWJvdXQgbWlycm9yIHJvb3RzIGhlcmU/DQoNCj4gKw0KPiArCWVuZCA9IG1p
bihlbmQsIHRkcF9tbXVfbWF4X2dmbl9leGNsdXNpdmUoKSk7DQo+ICsNCj4gKwlsb2NrZGVwX2Fz
c2VydF9oZWxkX3dyaXRlKCZrdm0tPm1tdV9sb2NrKTsNCj4gKw0KPiArCXJjdV9yZWFkX2xvY2so
KTsNCj4gKw0KPiArCWZvcl9lYWNoX3RkcF9wdGVfbWluX2xldmVsKGl0ZXIsIGt2bSwgcm9vdCwg
UEdfTEVWRUxfNEssIHN0YXJ0LCBlbmQpIHsNCj4gK3JldHJ5Og0KPiArCQlpZiAoY2FuX3lpZWxk
ICYmDQoNCkRvIHdlIG5lZWQgdGhpcyBwYXJ0IG9mIHRoZSBjb25kaXRpb25hbCBiYXNlZCBvbiB0
aGUgYWJvdmU/DQoNCj4gKwkJICAgIHRkcF9tbXVfaXRlcl9jb25kX3Jlc2NoZWQoa3ZtLCAmaXRl
ciwgKmZsdXNoLCBmYWxzZSkpIHsNCj4gKwkJCSpmbHVzaCA9IGZhbHNlOw0KPiArCQkJY29udGlu
dWU7DQo+ICsJCX0NCj4gKw0KPiArCQlpZiAoIWlzX3NoYWRvd19wcmVzZW50X3B0ZShpdGVyLm9s
ZF9zcHRlKSB8fA0KPiArCQkgICAgIWlzX2xhc3Rfc3B0ZShpdGVyLm9sZF9zcHRlLCBpdGVyLmxl
dmVsKSB8fA0KPiArCQkgICAgIWl0ZXJfc3BsaXRfcmVxdWlyZWQoa3ZtLCByb290LCAmaXRlciwg
c3RhcnQsIGVuZCkpDQo+ICsJCQljb250aW51ZTsNCj4gKw0KPiArCQlpZiAoIXNwKSB7DQo+ICsJ
CQlyY3VfcmVhZF91bmxvY2soKTsNCj4gKw0KPiArCQkJd3JpdGVfdW5sb2NrKCZrdm0tPm1tdV9s
b2NrKTsNCj4gKw0KPiArCQkJc3AgPSB0ZHBfbW11X2FsbG9jX3NwX2Zvcl9zcGxpdCh0cnVlKTsN
Cj4gKw0KPiArCQkJd3JpdGVfbG9jaygma3ZtLT5tbXVfbG9jayk7DQo+ICsNCj4gKwkJCWlmICgh
c3ApIHsNCj4gKwkJCQl0cmFjZV9rdm1fbW11X3NwbGl0X2h1Z2VfcGFnZShpdGVyLmdmbiwgaXRl
ci5vbGRfc3B0ZSwNCj4gKwkJCQkJCQkgICAgICBpdGVyLmxldmVsLCAtRU5PTUVNKTsNCj4gKwkJ
CQlyZXR1cm4gLUVOT01FTTsNCj4gKwkJCX0NCj4gKwkJCXJjdV9yZWFkX2xvY2soKTsNCj4gKw0K
PiArCQkJaXRlci55aWVsZGVkID0gdHJ1ZTsNCj4gKwkJCWNvbnRpbnVlOw0KPiArCQl9DQo+ICsJ
CXRkcF9tbXVfaW5pdF9jaGlsZF9zcChzcCwgJml0ZXIpOw0KPiArDQo+ICsJCWlmICh0ZHBfbW11
X3NwbGl0X2h1Z2VfcGFnZShrdm0sICZpdGVyLCBzcCwgZmFsc2UpKQ0KDQpJIHRoaW5rIGl0IGNh
bid0IGZhaWwgd2hlbiB5b3UgaG9sZCBtbXUgd3JpdGUgbG9jay4NCg0KPiArCQkJZ290byByZXRy
eTsNCj4gKw0KPiArCQlzcCA9IE5VTEw7DQo+ICsJCS8qDQo+ICsJCSAqIFNldCB5aWVsZGVkIGlu
IGNhc2UgYWZ0ZXIgc3BsaXR0aW5nIHRvIGEgbG93ZXIgbGV2ZWwsDQo+ICsJCSAqIHRoZSBuZXcg
aXRlciByZXF1aXJlcyBmdXJ0ZXIgc3BsaXR0aW5nLg0KPiArCQkgKi8NCj4gKwkJaXRlci55aWVs
ZGVkID0gdHJ1ZTsNCj4gKwkJKmZsdXNoID0gdHJ1ZTsNCj4gKwl9DQo+ICsNCj4gKwlyY3VfcmVh
ZF91bmxvY2soKTsNCj4gKw0KPiArCS8qIExlYXZlIGl0IGhlcmUgdGhvdWdoIGl0IHNob3VsZCBi
ZSBpbXBvc3NpYmxlIGZvciB0aGUgbWlycm9yIHJvb3QgKi8NCj4gKwlpZiAoc3ApDQo+ICsJCXRk
cF9tbXVfZnJlZV9zcChzcCk7DQoNCldoYXQgZG8geW91IHRoaW5rIGFib3V0IHJlbHlpbmcgb24g
dGRwX21tdV9zcGxpdF9odWdlX3BhZ2VzX3Jvb3QoKSBhbmQgbW92aW5nDQp0aGlzIHRvIGFuIG9w
dGltaXphdGlvbiBwYXRjaCBhdCB0aGUgZW5kPw0KDQpPciB3aGF0IGFib3V0IGp1c3QgdHdvIGNh
bGxzIHRvIHRkcF9tbXVfc3BsaXRfaHVnZV9wYWdlc19yb290KCkgYXQgdGhlDQpib3VuZGFyaWVz
Pw0KDQo+ICsJcmV0dXJuIDA7DQo+ICt9DQo+ICsNCj4gK2ludCBrdm1fdGRwX21tdV9nZm5fcmFu
Z2Vfc3BsaXRfYm91bmRhcnkoc3RydWN0IGt2bSAqa3ZtLCBzdHJ1Y3Qga3ZtX2dmbl9yYW5nZSAq
cmFuZ2UpDQo+ICt7DQo+ICsJZW51bSBrdm1fdGRwX21tdV9yb290X3R5cGVzIHR5cGVzOw0KPiAr
CXN0cnVjdCBrdm1fbW11X3BhZ2UgKnJvb3Q7DQo+ICsJYm9vbCBmbHVzaCA9IGZhbHNlOw0KPiAr
CWludCByZXQ7DQo+ICsNCj4gKwl0eXBlcyA9IGt2bV9nZm5fcmFuZ2VfZmlsdGVyX3RvX3Jvb3Rf
dHlwZXMoa3ZtLCByYW5nZS0+YXR0cl9maWx0ZXIpIHwgS1ZNX0lOVkFMSURfUk9PVFM7DQoNCldo
YXQgaXMgdGhlIHJlYXNvbiBmb3IgS1ZNX0lOVkFMSURfUk9PVFMgaW4gdGhpcyBjYXNlPw0KDQo+
ICsNCj4gKwlfX2Zvcl9lYWNoX3RkcF9tbXVfcm9vdF95aWVsZF9zYWZlKGt2bSwgcm9vdCwgcmFu
Z2UtPnNsb3QtPmFzX2lkLCB0eXBlcykgew0KDQpJdCB3b3VsZCBiZSBiZXR0ZXIgdG8gY2hlY2sg
Zm9yIG1pcnJvciByb290cyBoZXJlLCBpbnN0ZWFkIG9mIGluc2lkZQ0KdGRwX21tdV9zcGxpdF9i
b3VuZGFyeV9sZWFmcygpLg0KDQo+ICsJCXJldCA9IHRkcF9tbXVfc3BsaXRfYm91bmRhcnlfbGVh
ZnMoa3ZtLCByb290LCByYW5nZS0+c3RhcnQsIHJhbmdlLT5lbmQsDQo+ICsJCQkJCQkgICByYW5n
ZS0+bWF5X2Jsb2NrLCAmZmx1c2gpOw0KPiArCQlpZiAocmV0IDwgMCkgew0KPiArCQkJaWYgKGZs
dXNoKQ0KPiArCQkJCWt2bV9mbHVzaF9yZW1vdGVfdGxicyhrdm0pOw0KPiArDQo+ICsJCQlyZXR1
cm4gcmV0Ow0KPiArCQl9DQo+ICsJfQ0KPiArCXJldHVybiBmbHVzaDsNCj4gK30NCj4gKw0KPiAg
LyogVXNlZCBieSBtbXUgbm90aWZpZXIgdmlhIGt2bV91bm1hcF9nZm5fcmFuZ2UoKSAqLw0KPiAg
Ym9vbCBrdm1fdGRwX21tdV91bm1hcF9nZm5fcmFuZ2Uoc3RydWN0IGt2bSAqa3ZtLCBzdHJ1Y3Qg
a3ZtX2dmbl9yYW5nZSAqcmFuZ2UsDQo+ICAJCQkJIGJvb2wgZmx1c2gpDQo+IGRpZmYgLS1naXQg
YS9hcmNoL3g4Ni9rdm0vbW11L3RkcF9tbXUuaCBiL2FyY2gveDg2L2t2bS9tbXUvdGRwX21tdS5o
DQo+IGluZGV4IDUyYWNmOTlkNDBhMC4uODA2YTIxZDRmMGUzIDEwMDY0NA0KPiAtLS0gYS9hcmNo
L3g4Ni9rdm0vbW11L3RkcF9tbXUuaA0KPiArKysgYi9hcmNoL3g4Ni9rdm0vbW11L3RkcF9tbXUu
aA0KPiBAQCAtNjksNiArNjksNyBAQCB2b2lkIGt2bV90ZHBfbW11X3phcF9hbGwoc3RydWN0IGt2
bSAqa3ZtKTsNCj4gIHZvaWQga3ZtX3RkcF9tbXVfaW52YWxpZGF0ZV9yb290cyhzdHJ1Y3Qga3Zt
ICprdm0sDQo+ICAJCQkJICBlbnVtIGt2bV90ZHBfbW11X3Jvb3RfdHlwZXMgcm9vdF90eXBlcyk7
DQo+ICB2b2lkIGt2bV90ZHBfbW11X3phcF9pbnZhbGlkYXRlZF9yb290cyhzdHJ1Y3Qga3ZtICpr
dm0sIGJvb2wgc2hhcmVkKTsNCj4gK2ludCBrdm1fdGRwX21tdV9nZm5fcmFuZ2Vfc3BsaXRfYm91
bmRhcnkoc3RydWN0IGt2bSAqa3ZtLCBzdHJ1Y3Qga3ZtX2dmbl9yYW5nZSAqcmFuZ2UpOw0KPiAg
DQo+ICBpbnQga3ZtX3RkcF9tbXVfbWFwKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgc3RydWN0IGt2
bV9wYWdlX2ZhdWx0ICpmYXVsdCk7DQo+ICANCj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgv
a3ZtX2hvc3QuaCBiL2luY2x1ZGUvbGludXgva3ZtX2hvc3QuaA0KPiBpbmRleCA2NTVkMzZlMWY0
ZGIuLjE5ZDdhNTc3ZTdlZCAxMDA2NDQNCj4gLS0tIGEvaW5jbHVkZS9saW51eC9rdm1faG9zdC5o
DQo+ICsrKyBiL2luY2x1ZGUvbGludXgva3ZtX2hvc3QuaA0KPiBAQCAtMjcyLDYgKzI3Miw3IEBA
IHN0cnVjdCBrdm1fZ2ZuX3JhbmdlIHsNCj4gIGJvb2wga3ZtX3VubWFwX2dmbl9yYW5nZShzdHJ1
Y3Qga3ZtICprdm0sIHN0cnVjdCBrdm1fZ2ZuX3JhbmdlICpyYW5nZSk7DQo+ICBib29sIGt2bV9h
Z2VfZ2ZuKHN0cnVjdCBrdm0gKmt2bSwgc3RydWN0IGt2bV9nZm5fcmFuZ2UgKnJhbmdlKTsNCj4g
IGJvb2wga3ZtX3Rlc3RfYWdlX2dmbihzdHJ1Y3Qga3ZtICprdm0sIHN0cnVjdCBrdm1fZ2ZuX3Jh
bmdlICpyYW5nZSk7DQo+ICtpbnQga3ZtX3NwbGl0X2JvdW5kYXJ5X2xlYWZzKHN0cnVjdCBrdm0g
Kmt2bSwgc3RydWN0IGt2bV9nZm5fcmFuZ2UgKnJhbmdlKTsNCj4gICNlbmRpZg0KPiAgDQo+ICBl
bnVtIHsNCg0K

