Return-Path: <kvm+bounces-46908-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 57AD6ABA5D4
	for <lists+kvm@lfdr.de>; Sat, 17 May 2025 00:12:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 286601BC1C25
	for <lists+kvm@lfdr.de>; Fri, 16 May 2025 22:12:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A93DC27F758;
	Fri, 16 May 2025 22:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EHNNcnnT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FEF51E6DC5;
	Fri, 16 May 2025 22:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747433552; cv=fail; b=XYOljRbR1mAVMTh2zHyvBB3a7Fog1nxNX+xfPgm9QFTaCmFqJpf6zu0DkTfXNbdmEosVTkF8o/63mN0ClstYg9YFqcQQTeq0rEIYX6xn403Ck/a1z3V5CR4QYL1qYUKRz/aPTL5GabiVHenQzauXRGp8LTrRjEDRgjy3FoL9I/w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747433552; c=relaxed/simple;
	bh=wXkSvG1Hs258B94ONdEcY124hW1EbHDXp7OSg7xxv+w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=O9G3AtTSxKhEWdZ1xyVnzDM7NQckKN00Ldpf1qXFqhZZb91/s3PA0QDUUGq1p9/49p8FG7+whl76MSg7U7X8lHRKBncnQGGdSi9KeLEOnBLmFkP3PG+XAYT1q5dIFP2EjLSCJKoFOq9CJWqZl7lTDVKGLhi8fYR/7ENozy5MT/E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EHNNcnnT; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747433551; x=1778969551;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=wXkSvG1Hs258B94ONdEcY124hW1EbHDXp7OSg7xxv+w=;
  b=EHNNcnnTOmkF1MKmQG7ooiMZpBhbfuVlMCa08Q6fNBuF4S4qd6z6fzGp
   ZQ+T4MlvLxNxakAsEtrN8EdawLMgDyWiR+K7G2rcdnPXM1Jo1DWSFG0tO
   v+3rk/g7obfw9WmF/y0E5Y/lfYTRpeNdzX+ifWJbCjCczGRpIdZf3f119
   4rxJ8Qy0vM+JL104zBdlXZVDkczGreXt0BHZ3OFG4H4ZuWXhtfaJHWT6m
   e4SzcfetBzgQbmnO3f6vdEk3UQOtez/s8f2HS0WcmQz0fuyOcSxDDHGP0
   18t5Z6quVQ67BpxQ8kp0YOgEEJqEReFM93XJqtuC8g6rGG8xtsmM2QrS7
   w==;
X-CSE-ConnectionGUID: qsOposW3Q0+fvGO9fcZFxg==
X-CSE-MsgGUID: 0ucZR0oCRA6tviZnrX0j5A==
X-IronPort-AV: E=McAfee;i="6700,10204,11435"; a="49116107"
X-IronPort-AV: E=Sophos;i="6.15,295,1739865600"; 
   d="scan'208";a="49116107"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 15:12:31 -0700
X-CSE-ConnectionGUID: GnMmunY2R1maiwLrSX/CXg==
X-CSE-MsgGUID: 8yk4g2aeQ62wpnhVc1ir4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,295,1739865600"; 
   d="scan'208";a="144057881"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 May 2025 15:12:30 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Fri, 16 May 2025 15:12:29 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Fri, 16 May 2025 15:12:29 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.43) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 16 May 2025 15:12:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Y85z/F7qWEFSDeoZBQjdCJ9XU1ag7m3/k3bDleYf+sUaJND25xktBJUyFDOFxCLpmlFWa3rT+AmkF9iX+2tPwFIMEm7THw6aeNadTi5J/3HVNZtpNLsxbLyjTzepLDnuKOgLrvhH2hapB6RGoJ/cboHt0UX18yQRynkJWhXcwj0HBTrINZ1wd0ScJQIt5DkSc67kRCSTLfNFcva/zaW13bssPtF3y0gHdP0qAWHCn75jNqLdCAImZrWj+1z/eDF54tvBEU1LYgyekDEXxoPVtQouf7Ev8c6oW4q+ADHSkGo6l7fo4cjM0BvMvSXNfbZ+mBSoU5exm+O+NmY/oiBS1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wXkSvG1Hs258B94ONdEcY124hW1EbHDXp7OSg7xxv+w=;
 b=rA9XN2Ha3I/RTQc9OzfIKl+ZL1/WHj1PHJLz3U7Qdlz/IfMktbmvlE6wfqwFLd5RHqx9yF7Q9Y+PX2tgnpBiMPz24MVVzLr2pIIxKrFMvlltUBzFRl02zRLHkbXgyfUWWLJpumWkm4939ejRk1mBUbrdEOuWtGnjn8QxuOH1j3rbqFB8GfCsb200SME/rL/IBWN0nOplThKJ4QHjaNEpUGJWm7HiguT9kwiyBerjswvSfL+LubJbQ7dCmgWdrcbFwvXkBTqgFhY3vfXsMkyYA7ihxay9MFwKF+ddk7jjCBHGameYZPhe1F0Jcuqe4xZzIv8wWiOHPLWWYoMZlmL32g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by BN9PR11MB5290.namprd11.prod.outlook.com (2603:10b6:408:137::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.33; Fri, 16 May
 2025 22:11:59 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8722.020; Fri, 16 May 2025
 22:11:59 +0000
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
Subject: Re: [RFC PATCH 14/21] KVM: x86/tdp_mmu: Invoke split_external_spt
 hook with exclusive mmu_lock
Thread-Topic: [RFC PATCH 14/21] KVM: x86/tdp_mmu: Invoke split_external_spt
 hook with exclusive mmu_lock
Thread-Index: AQHbtMZXtCmug//st0iewCdVRT7MSrPRTdqAgAPPNYCAANh4AA==
Date: Fri, 16 May 2025 22:11:59 +0000
Message-ID: <11de62c95f7866fcecdba4c2d9462c77bab3bf83.camel@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
	 <20250424030744.435-1-yan.y.zhao@intel.com>
	 <b5af66343b3f5d4083ee875017c7449dea922006.camel@intel.com>
	 <aCcCl6nSvYpSK1A2@yzhao56-desk.sh.intel.com>
In-Reply-To: <aCcCl6nSvYpSK1A2@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|BN9PR11MB5290:EE_
x-ms-office365-filtering-correlation-id: b6feac00-faa2-492e-4922-08dd94c6adb2
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?akRiVEdUcGJrUHAyQjVrOVNxSE1HU0hQNXdQWG5PZ243WHpUREFhOHlLUHk3?=
 =?utf-8?B?NU84ZUtTRjlBcDdTMWs0d1N3dVdWNXNlTmhrS04zUncrcTBZeWpWRmNrV2xZ?=
 =?utf-8?B?Q2FyL2c5VUhJSld0ejBDczhic25hR1NqTjhvdWx1VVhvSGZpWmNlUDczUFB0?=
 =?utf-8?B?TzVlWHhkWlJITVk2Zm5QZTRib0o1L2d1eUh4T054d1U3eWEvN3Z0NFhMTUlF?=
 =?utf-8?B?TE9sT2NQekl2MFBYMmRQWkFFc2RNRDhEVjZ2NXN6UEZudVdrdTJ5dXl0cGMw?=
 =?utf-8?B?cUtFa3FRZmgzK1ovTDFXNEVTMVdkNzBIelZIZFhWOW13UWtwdW54aUZJSyta?=
 =?utf-8?B?TjlObjBISEw2cUlOVk85MWgvTXJQaGRhNWNTNW5jWVR2VmtNeVVhTHpwQmdP?=
 =?utf-8?B?VnFwLzlJbXU1ZWI2dU0yU3NnWTBVWGVoa3FQM2lnM3dDWFp2K1BFbmhoTXZl?=
 =?utf-8?B?TmZSZWcyY2EwOW9uOEp4YitXS1pnSVJXaDB3dmpEdzVReEZUM3FYc24xVGJP?=
 =?utf-8?B?L2FtSWpTYjM0bEQ0RUVPWW94VmdoL1Y4YXBLZ2NSUVA2cXlDR0p4eXVCOXU4?=
 =?utf-8?B?MzUwZmtnSHFWK0dZNG9iaXRMeDlKREdmaXRWTUgvNmVxQkhVaHVkSjhYdzRF?=
 =?utf-8?B?Q3FzUWk4NUE5TFBQV0tKTUw1Q1dYSlZxMjFyT0I1THo1cnMveWg0bzF5eWpS?=
 =?utf-8?B?UkkzdXAzT3FqRFJ1RXhzdkJ2YTViSVFibDc4RzFTTXV0MHBDNmY0RnIva01Q?=
 =?utf-8?B?WmM1UHA2eDFid1NMRVkzTHJ6RnFFTXB2R2QySW5Bc2lLVy9qZk93V1JyR2tN?=
 =?utf-8?B?Y0ZQMjN0RGNlNUQyRTN2ZkloNGptemFQNmN2ZGFjR1p1enk5QnZtUmpqbjlx?=
 =?utf-8?B?YzUxR3ZuaVRFM3pnMXhTMWVqcmZybGZYd1YwaEFXOU93dEh1SUx3MXhEN29a?=
 =?utf-8?B?ckVmZ29yUmE2TTlhSXF6Y2FvQnFrZHgzMGVZTVNFS0JoUmF3QkNnWG1VN0Vo?=
 =?utf-8?B?aE8vWEtBOE1mM0d2b1hRY0pzYlNZYWZSVmhTSDRYUStjb3J5MnRYeWoyWW1G?=
 =?utf-8?B?L29WdThrNTdMS09Bd1JscjY5dEpqR3ZDckhValZVVURnWktheDluMU9nRjVp?=
 =?utf-8?B?SHA4S0xQQUlJcFZLcDNsNGlzSWllc0w3K2FqY1ZhNnlkYWV5N1c1VmQwSWtB?=
 =?utf-8?B?TDdDZVVKUjgwTWIxUENUcVp2SDYyQlNFc3k0emFBQlNzUGxJdkJVdDJSOVFs?=
 =?utf-8?B?elpRWnFtSjdqQVl6b2FlQXhWOEFYRnJNdFBvdjdzU0FTaUVQY2hGK2JJN2dN?=
 =?utf-8?B?ZmlpaXF3cGh4emF6V3RyQnEzcy9iYlNJblBORHcweXFXL085RnhWZEorbHBD?=
 =?utf-8?B?bUN4Z0d2cXNnMDg1aGZvQk42WitKZXViWEpENllyL1dlTElCOTV4WWFaM2Z4?=
 =?utf-8?B?YXpiZnZrREQrU3hVUk9SU3VaeVVUb2doODl4cEUxMXREOHJnam5oVnd2dFB4?=
 =?utf-8?B?YTBqYzdiOUxQSlhoQUlVZDExWmVyZEdaMHlZK25NTXhZbVVMYVVhbVJyZzNq?=
 =?utf-8?B?TTNSNVZCTHlITmRmZ1RIK0M2enQ5L0d6SlJ6T1ZOOUVPaFRWMlpGKytpa0tN?=
 =?utf-8?B?a1hYM0VBZk40U2ZSTHZXdVdyRHNXMmdDUnpzb0pZdjhmYTNMSWR6RFBJZEhr?=
 =?utf-8?B?QzZJM0hPVm1KTThSMXJ0N0czN3hGTmZUNjZPVzdzbExvOXpRTW1vQklxZWFo?=
 =?utf-8?B?bFV5dXNSZWlLSS8yRlJhUDlLUm81eGtmd2JYb2ljYW1UY2dWTXdSSjZ0UFBX?=
 =?utf-8?B?M3A1aW9PRVkvUjlxMEtYckRlSVIzbXlaU3krcUk2Ykh2SElTMVBJQ2JuUE12?=
 =?utf-8?B?ZkkxMWN0NnIrTVUvdDVJN2hvMXRLNEpxcDU3aUV0MUZwRUtOOVJLMm90Sjdi?=
 =?utf-8?B?a3ZCOVNGUng5Z0QxQzVvZXdqMWNLL1g3djVnZmtjajV0bU5rTHlxeWxXaVF3?=
 =?utf-8?Q?b/4yJPTUh+KRpabbejXdlqMPhIaIuU=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S0ZOa2ZHY1JvN0hJTlRjbmswbnpwYW5jREVVYk1ZKzFGcnloSnZRT3kxeVV5?=
 =?utf-8?B?RmU3cmNHRUlsZEFNZHgwL1pPTlE0b284VnVTTk1TaXhsS2o1eFIvNThoNzI1?=
 =?utf-8?B?SmgrdEtGZjVMZjNMWVFIalZ5bm5kcFBQRTJtVGZzMERFUVpLdmVSak1RcmJ5?=
 =?utf-8?B?cTVST0swWkJ2VWp5T0tnQU5mYzZFOUMzUVVJQSt1d1E0dHF2RUFySDNzdFIw?=
 =?utf-8?B?ZTF1MkhaMW1SeGg2SHZxVTNDZmptdXF3UjB5WXNGUWFWMUQ0bHRPRm9ZZkVJ?=
 =?utf-8?B?UTI4SnE1RTR1RGhFUlQ1VWxWZ2J4UWhod0VYUXhpbTlaMVBSUjVWUGlFeWxG?=
 =?utf-8?B?b1htbEpHY3NRdXkzVVY1ekJPbTNlVkhrUDkzV3oxYnBrM25hNkhMMDQ3WFM2?=
 =?utf-8?B?VC8wdFhFVGRvYUpKTFNBL2ZZUGtuaWlmVmRwVmNGdTZvS011TjRzU1FoU0N1?=
 =?utf-8?B?YkF5Y0pXajhrd1lQMmo3ekJXd1dQZ1pmdi9KaGQzdWYwN0dRZ2FZbElJNytF?=
 =?utf-8?B?eU44b0lTYnBFa2VSTGtqcHQwc0NlMnFFK3JxWGkyTDQ0TEhaakpuZFJ6UlE2?=
 =?utf-8?B?RU5QTWJRRFhGdlRGdkFzd2hlR29WSTU0L0FGeWpMM01QSklXcTgwUU0zdW8v?=
 =?utf-8?B?a1p3T1ErSEs1RE50bkNNNWZwMlk4a0Q1TitvQkFWTkY5bkFUV3R0RVE3SnZM?=
 =?utf-8?B?MGU5emYxdWh4MDVlVzdJY1c3MHBjczRDS1F3WWs0V1dFSWlxYUFsNWJ1Ky9D?=
 =?utf-8?B?QzJoYnhGc3VtSzB5Z3hqeVJWbnpsc09xa3VEYzliaUFQYmo4ZGFiQ3FFTlFT?=
 =?utf-8?B?UDFTQlNLYXFQVmVQVll4NHR4NVBXV3M2TERucVZBL1pvT1p1T3RCMFl3NW5u?=
 =?utf-8?B?L2thZWpXTFFLd3pQQ0FTV3c4Q0ppejUzbm5LRzZBM2VORDNJS0t6M3BEZDQ4?=
 =?utf-8?B?ZVVJRkRITVpPT3E3bUJHTG5XWVQzSGRFSWNNYWFWVEViWlNIVDZ0dHdiT3Uy?=
 =?utf-8?B?clZyRGlOYlVXYjcvaERqS1JWSVpvSmtRbW15R201RU9rUkNrY3RlZnVrWXdo?=
 =?utf-8?B?dDBRUCtrVzI3OGNYRnhjV0J1M0NQZDJITDJaTHBJMDkxNUhqRFFqM1JlYkp2?=
 =?utf-8?B?TnQydGI1U2xBZEpSUEJKbFN6bzM4dUxCcUFKbjJ5UUk4ZUN0RWRVd3pYL2xM?=
 =?utf-8?B?eXJHSitxc1l2SE5HOEF1dUV6T1RtUTNIY1VtcU9MOWdIQzUrZWtMS0JpaU15?=
 =?utf-8?B?UUJkVWhxRU8zQThpejBBeTVlamFlRmp1ME9kN3BiMWF2UjE0L1o2dnRCK3c5?=
 =?utf-8?B?UDJMd0JzM2lmL2NuNzQrZjNuSWZ1Qmc5WnIwbXJYcUpQK2xHemZTQUpKMHZ2?=
 =?utf-8?B?K3c1UjlXUFV0WGIrbHlVOFpCS0lEZjlyU3NyRW5tcTZRWUJkRFBXeVkxdUF2?=
 =?utf-8?B?YURrMFYrNzVXck11alNpK0dRYjljb01udER4bVBkMnFuS21RNVloblBRbFh2?=
 =?utf-8?B?UVdpazZwTUtRTTIzVCs4M1ZDWm5rWEdjYjFHYWdQRGEwVkliM3NSNE4xMlYv?=
 =?utf-8?B?SGhsOUNXMnhSdEg1SHVPVU1UaDd0bVk4aEttbzFEMi9FTHU2SVU0Q0c5dDJL?=
 =?utf-8?B?anRxckptRWUvcDEwcndxajhlcjBSZk44UHpHWnE2MHNLTEJnakN1QlBVUnFR?=
 =?utf-8?B?T29vY1F4aHlLQ3FJTDRnME1QN0FkbFR5ckwwKzBlWk1qZVdaQ0Rjd0oyQXJB?=
 =?utf-8?B?eUp0OVJXMGxvTVJ3THI0TVRBZTNDVEd6RDhKajZxMDdZS2x2NnRub0tsSGJV?=
 =?utf-8?B?dU41RHdkSkV4REtmN2dBc3A0b3B5dGpIemZBaEVpUW90ZFNwWWM0QkNaemZR?=
 =?utf-8?B?MExKNFkycWJzdnZ0dmVnWWVRQUl6cnV3M2pwNFVoZHMrT0tTNUgzcXkweWlh?=
 =?utf-8?B?UkF3TjVraHlDdTdPZk03NExHeW9zaEQvbHI4YlVsTTQzTXlzY1M3SHhYcVBU?=
 =?utf-8?B?YkJiWUJCRVdFZDRxVE9LQVRQSWp1bXdubmpDRmJ0WUQ5VjBkenFMV0FSSlFm?=
 =?utf-8?B?Z3VFd0xEK3ZETCtTcEhJS1BicW5DbjNXWHJVRmUyRmpKN0VudUs4ZUlZREEr?=
 =?utf-8?B?RkpQbUwzazN3aFh0OXVwRmE5WUR0dXVMT3U5RlpzWHB3WGRiYklwYmprWXFl?=
 =?utf-8?B?Z1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <819AA92FA2CEF94888C45E9885D0389B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6feac00-faa2-492e-4922-08dd94c6adb2
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2025 22:11:59.4603
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CQlKBBqEUBILw10XvTvDC3mSfvt3/WgJ+jr+gqaj+JkNZHs5qNXF8NQMuW8qQQ1Pj7iZ1Eq1yVFP7z4HNBeHdXnvEMp2GAZcvXtqzyNSgDk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5290
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA1LTE2IGF0IDE3OjE3ICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gPiBT
aG91bGRuJ3QgdGhpcyBCVUdfT04gYmUgaGFuZGxlZCBpbiB0aGUgc3BsaXRfZXh0ZXJuYWxfc3B0
IGltcGxlbWVudGF0aW9uPyBJDQo+ID4gZG9uJ3QgdGhpbmsgd2UgbmVlZCBhbm90aGVyIG9uZS4N
Cj4gT2suIEJ1dCBrdm1feDg2X3NwbGl0X2V4dGVybmFsX3NwdCgpIGlzIG5vdCBmb3IgVERYIG9u
bHkuDQo+IElzIGl0IGdvb2QgZm9yIEtWTSBNTVUgY29yZSB0byByZWx5IG9uIGVhY2ggaW1wbGVt
ZW50YXRpb24gdG8gdHJpZ2dlciBCVUdfT04/DQoNCkl0IGVmZmVjdGl2ZWx5IGlzIGZvciBURFgg
b25seS4gQXQgbGVhc3QgZm9yIHRoZSBmb3Jlc2VlYWJsZSBmdXR1cmUuIFRoZSBuYW1pbmcNCmJh
c2ljYWxseSBtZWFucyB0aGF0IHBlb3BsZSBkb24ndCBoYXZlIHRvIHNlZSAiVERYIiBldmVyeXdo
ZXJlIHdoZW4gdGhleSBsb29rIGluDQp0aGUgTU1VIGNvZGUuDQoNCj4gDQo+ID4gDQo=

