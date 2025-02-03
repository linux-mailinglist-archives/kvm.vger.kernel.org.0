Return-Path: <kvm+bounces-37187-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E0286A26763
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 00:01:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 278C2188329B
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 23:01:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4759E211477;
	Mon,  3 Feb 2025 23:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QW7/RHXm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9078F2B2D7;
	Mon,  3 Feb 2025 23:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738623681; cv=fail; b=Q0Cgmoj4Rgdsjx9bqapUbKar10G2EZLDBEjEcccCxbz8OUlntSuBwV69VJymW5T15HBot9wTXoH1jwSEccIq69rZOmpbmDPAN9xRS9+ELH/KEkji3fQbgza/7WGXK2QJHUCVna+iB6tXNGs7NAgy1VJKBeldjxiehtdLzf/3jG0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738623681; c=relaxed/simple;
	bh=ZHU9/weN3gMWYHAIV5FpgCBMH3G/UGj1EC1lLXIYSes=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gQ8MohwSdnqjzS7cSwnvaZ+pnhaUnLnASzS9GeSTnzjaIP/u/ggeqR6K+A2z5QbJbxBBqIphdvxw4ZM+q4lLFacuKvuq6ph6JPil1WwF0hS0t8Pd2L8KuwOz8eRttxo43LE0AE7bO66iRQMUeDky6l+JG7RD+nUXDVTj7UhpvQQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QW7/RHXm; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1738623680; x=1770159680;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ZHU9/weN3gMWYHAIV5FpgCBMH3G/UGj1EC1lLXIYSes=;
  b=QW7/RHXmmu2JqbiO6k8Zu3ehvK436jlVme8P2kAmz9fYxKfg6MYyjh0U
   rXiLlK2sBoGgvIIV3KTepkuqjhQEN+Hu9DEeY+gRtuXl98HJ2RcWnH17l
   Ls1YdzpnnonxEaQOa3rspVa1OvSmRrMF2sVw56tMk4PpIbH1DXocOVJa1
   i3R4cHnBdF2bcNOp+8KFYaBZKLqzxKIP+ilQAOEgzVwxOI3+wjN8JNb1Y
   6ueXytSSXEN50yAKfmIf1FqwTyx+3fgEyNBWL/vY+rGIFmjaoXKszH+LX
   cdp0I9RGoeOahXBt5+NTjUCw908pqf7V79DFxEKYgLcMa+UznJwpANaJz
   Q==;
X-CSE-ConnectionGUID: tey3RAjARBq8h5Yft8N/vQ==
X-CSE-MsgGUID: rSofoJ8XR6qsMUC3NJPHrA==
X-IronPort-AV: E=McAfee;i="6700,10204,11335"; a="49743583"
X-IronPort-AV: E=Sophos;i="6.13,257,1732608000"; 
   d="scan'208";a="49743583"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2025 15:01:14 -0800
X-CSE-ConnectionGUID: EADL+xdTRxm5ytzvcLHoEA==
X-CSE-MsgGUID: VpTbTYebRwOhf7ouo8mn/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,257,1732608000"; 
   d="scan'208";a="115404471"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Feb 2025 15:01:14 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 3 Feb 2025 15:01:13 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 3 Feb 2025 15:01:13 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 3 Feb 2025 15:01:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yZNdSjNFEC5rTD3YGq3lrQ+Yq4bIbXZ6g+NyrWU4qT9KWk6Wd2PJzdO/jJydMh2rPlB4ROiSCMSLo36PvkZNjVsfYNNgKL9MK6rOID8NdSnynACLLaygzHe74VcoX/fu7L0cbW+t4wIdWBP34WrtmCj5hrmL9rrvOVE3RYuANewxSVPz8JOty0+r4tOdcNCvm404/wpexHoAeQRTtUys9YJq1z9+7a4jEK4lngbQWH+STzMiKs4aNVFKHIMBnPVK4OYESYwylTqRQ5EkIbpOCP5huow61/qzxRWg9x0P5EuwefQrm/v3IPXPlF02lwmTxCVGt9ivhduEbiBgezV7WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZHU9/weN3gMWYHAIV5FpgCBMH3G/UGj1EC1lLXIYSes=;
 b=kvTv6QvbR/VkupIwOOXElDEw99DlTVij02oBFdFhtF0MNWs6gfrIppjfohC5+/J8tuLiDDjGWt/28YWDllwAlat0+ktDeamu/wei618mYfbYuKtoHTNXByFszw//s+ZBsLDPjEBEl4UqCC2dvavMGi1HBPoEi1OLjtaHiV8dUc3iCBGSKv7KSprG1ePZsA0Y3YEHuOLAHJfIWoU78tAZWLt7YY+l9jpsJeu+Yny2Z8zTIIAHjTsXAEyE6dqQCsaBfmiEjfE/94bzzoGCui5mX2AcuJhSnovtXRLtGLj5nyh85CfJZ1FiQc/2jwAbMUjWA4tMUhVEBfxpgN0bduNKfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by BL1PR11MB6049.namprd11.prod.outlook.com (2603:10b6:208:391::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.24; Mon, 3 Feb
 2025 23:01:10 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8398.025; Mon, 3 Feb 2025
 23:01:10 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "thomas.lendacky@amd.com"
	<thomas.lendacky@amd.com>, "dionnaglaze@google.com" <dionnaglaze@google.com>,
	"Wu, Binbin" <binbin.wu@intel.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"vkuznets@redhat.com" <vkuznets@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"jgross@suse.com" <jgross@suse.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 0/2] x86/kvm: Force legacy PCI hole as WB under SNP/TDX
Thread-Topic: [PATCH 0/2] x86/kvm: Force legacy PCI hole as WB under SNP/TDX
Thread-Index: AQHbdeRiwegNjOp2EEirKtkE9yTgJLM14ykAgAAmtACAAClbgA==
Date: Mon, 3 Feb 2025 23:01:10 +0000
Message-ID: <0102090cd553e42709f43c30d2982b2c713e1a68.camel@intel.com>
References: <20250201005048.657470-1-seanjc@google.com>
	 <dbbfa3f1d16a3ab60523f5c21d857e0fcbc65e52.camel@intel.com>
	 <Z6EoAAHn4d_FujZa@google.com>
In-Reply-To: <Z6EoAAHn4d_FujZa@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|BL1PR11MB6049:EE_
x-ms-office365-filtering-correlation-id: 7142fa60-4fe3-404a-af86-08dd44a6a679
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?TmgrK2Q3QVcxY1pxQnR2K1VpREdSVGNJeHR1STFUczZPeCsrSmh6SWRIcnhL?=
 =?utf-8?B?MEl3akZZTXd5NmpFM21qS2hoWkdHQTV1QzdMMzZFZm5Eczg5L1RnSFJOZGh2?=
 =?utf-8?B?OTJmQzJHYUtKT1EwMmZKZU9FTkQ5REJ5Z3NCaVlUUG9oWXd6Uk1JUGhJRDdp?=
 =?utf-8?B?YjlZRWVmWFo4aGVBSTBZdW4rd3Z5MSt1V2FQQkJuWThzMmlXTHFoaWpLVXFm?=
 =?utf-8?B?bzVjRTJrdTI1dmhmWFpvODRIVHRacmkrdXgxb2pYcGxGeWIrM0Y2L3E4UzhL?=
 =?utf-8?B?bE5NWkhmZm96eDhwcVJ3eEtEZDFCK1FDZ1E0b01ySEtVWFgweG5PbTRySjZq?=
 =?utf-8?B?YWlMYXNEaWljMlJ4d1dWRy9ZSDZXeFdaa0F3eU5tK01qZDJ6Yzd1NzFhRVNX?=
 =?utf-8?B?MURZVlJGZXR5eHlYeW53KzRmc0ZoMVFSUlpkNXc5YkJHdG5uZ29qRSt4Rkd5?=
 =?utf-8?B?R0xSb3RjcDNhc2NiNEk3alJoS2dmWVNRd2dSVDI3ZG9qQjY0S0FUOTZNOXdR?=
 =?utf-8?B?VHN3bFkrNXE4VkxnK09QcElybWpRRUlhZWVwZ09Bak96UzVlMHVSb0Fqa1Bq?=
 =?utf-8?B?bmdjcHEyYlpESjNCdmZJQThteUhGK2VkTkJtWlIvSTQ2N1RkbEhrZDVmOTQr?=
 =?utf-8?B?M2dsa0dubHdjakVtWXFXNDVvbGlEUHR2TG56U2tkWktobkVzdTVXUFNuR0l2?=
 =?utf-8?B?dEJHOFFpY2M5Q25KNlduZGZZWnkxZWdjQzdTZmF1QTF2STBjSjhQdnp3VVRW?=
 =?utf-8?B?RTdSenlOa3BteDB2U1dzRlhteW9vMEowWXJBbHJrU1lmWEJhK0ZQTmJBUFRW?=
 =?utf-8?B?ZzR4d3VQc1RTNEorOUVFOEcvczhLL250b3ZkclNpS0hEUm03anVyMFhqLytH?=
 =?utf-8?B?Z0tiejYvbjVNaUdEaW9aZ0R4aDZSWWIzdFIrZ1huSzRJWVJCSWpLdnZ3aHl5?=
 =?utf-8?B?clUvNFpGSFIxQkh5UGdwWUF5U0psdjBvcXIrTEtPQ24yekZJdGdXbUY4eEJZ?=
 =?utf-8?B?VnFVclQxcStBVjlVbFAzQStmSmhmNVpIak0zMUlYRHdQalFXblJ5MmRLVTlx?=
 =?utf-8?B?REIybVc5TzJtWCtBbjZ3TXhWUzRZbnE2cFk0VDdyNDVWRU95Zi9VYlJQOE1x?=
 =?utf-8?B?c2N1SExlUEJjQ0N2cTh3Tnc4dzE3Ym1BS2h2TjFEbzloRTBJQWVvcjJ6TVRt?=
 =?utf-8?B?ZVowbHJtQXVRbjNXN2RZVFh2NkNTcEdQRTRaVG94Q0NSZUpTdW05aGZoRklv?=
 =?utf-8?B?bU9namc5VXhoN2hFdy9aRkRoRUJLTUpLUWc5dUVHbDZnL1o2djltNERWb04x?=
 =?utf-8?B?bG5MRkJLVk04WGNrQTI5Mk1yRm9xQlJWMzk2S1hXengraG1kKzV5TGVScGtF?=
 =?utf-8?B?aWVqRjcxbjN1b3BBeWdPb05FaVB0czI4ck9RUS9vejV0OUUvTkVMaTBUODhH?=
 =?utf-8?B?NFV1MmovZzJHVDY0Z2x4V2tWeU42ZE41R2R0TTNnZEV6d1FURER3NktBUjNJ?=
 =?utf-8?B?QTBRK2p1UEpqQTZkNXdjZ3hGOHdkUjU0SllRS1ZjWnJYU3F6aDBVNmRtTkh5?=
 =?utf-8?B?YktDR21YWmdRTWorRmJZRmFLWWFaZUE5cVB6a1BFdmxOL2lOVXZzaWRMdk9o?=
 =?utf-8?B?TUc3NnRJNGk4V3RZcGFZNUFUTytDOFppNGpDY1BEWHhJM0pxRlRYL1dRV21y?=
 =?utf-8?B?MWU2aXpxWjZCL3VzM1dBUWlKWjRXcHNHYkFpMlF0eGhKZUdiVFA1RUprbU5q?=
 =?utf-8?B?Z0plRE9OS0hlVUVEMVFsTnBNbGZWam5QTmpKYjFzVDlIbXZmaDdPeXFsVC84?=
 =?utf-8?B?cXhKRzIxMjBTbnI0bEM0TEU1UW8xTldDd2VEenN4SktsMGI2dzJiQWJ2WU1W?=
 =?utf-8?B?NTBCYzIrVExrcXFtOHl2WTN1TlFDWjE5bW9CUjJpYTFaWVhYVk16YVgxOGZh?=
 =?utf-8?Q?+GbrgQ9S62oGeJdM8DGVuPLnW3uEwh2n?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OGpybFJVTElrampMU2Q0d2NHT1lNZGNESWVtLzlhUXlWZ2JINnlQSVYyNTdN?=
 =?utf-8?B?QzR2Zkg4eU8xdW5QSjV1Q1VpWUVLRnNJMFRmd0NRVnIzUUVOL3UrNm5NUFc4?=
 =?utf-8?B?aHozNEpxRHdEMTJLTjB1ZlkvTWN0SUhpRE01ZWNpYnVqNGNOVTRJQk92b3Zu?=
 =?utf-8?B?c0JQZWIxSDFGdEU3dW0xcURIREJGNE1kTW1iVEh2TVNKa2FpeWZSYzRYcWdi?=
 =?utf-8?B?SkRNZ2hUYWdoNzdrOW5UcGlSU0xzOUVKU3dPYkVERWN4aDRlS20zZERaUUs1?=
 =?utf-8?B?OFdPZFMwMWd2VUZZSkRHakR0SjFaWWIwWlo4VGNKZW5OT3lXUy9pWTFVUm9Q?=
 =?utf-8?B?T0xIblN4VExCcGtLWVdqaStIc0V0VWlSRFpKZkpyOXZmdmVBSG9QcllnRExE?=
 =?utf-8?B?a00yNmdJSGVwNXBUSm5PbDdLYXNZZlZBS215anNzZjlFREE4ZTVBWUc2UGpQ?=
 =?utf-8?B?dUxwTW5LcjJCNWJlemZRSWRmSUI1dDdpUXZ1WE9wV0U4aDBjdmFBOVdOSXpq?=
 =?utf-8?B?eVBxSi9XMG5hRmFCSEhBRTdNR2JoVjlYSlh3TDJxeTJLNUVTSFBKR01HZWg0?=
 =?utf-8?B?ZDN5TFJoMndXdkhuUDFWVEo5aUJmbmQvenk1OGZhUU1pU1Nnb1FxSWYzNmVD?=
 =?utf-8?B?bnlqZFRHeHpoUTFOQTJ4YWFhQTVCQnk5RVdiYUdCNDVwZElFMXQvVXpzTGVz?=
 =?utf-8?B?Zi9HYU5oR0hIT0l3ZG42N0duU3JBR3drbUhYOW94aWhjL3I1bXFkTnFJV1pZ?=
 =?utf-8?B?Y0xCS2xzdnJRRnVzYWExZlczVGFHRk9QSG5hSzJWZzNGeTB4djFPWUZURC83?=
 =?utf-8?B?N0p5MTJraG1GRml3a3ptWUtFVDhjYlRlMVA1QjJaSStvaHh5STlMKzJ3Z0xD?=
 =?utf-8?B?V2UxQmdocTRJS1RNejNEQno5N0ZUUFZ3WWM3bkNkTy9jNS9wblh5T2dlSDZn?=
 =?utf-8?B?dEFUU1lxcXZneEZ1ZTUrY3Z5Q3R2UW0wajFONHpYdmtHOGJ3dWlpODVBZE9x?=
 =?utf-8?B?V2dGemRuTVliN1FqTlhQZXdjWCt6bHhGMmdoRDAxVndMc1lZcUNianZ5aFZz?=
 =?utf-8?B?cVgybkhjbWxOKzBRQzFBdnBUdFpNSEx6cGFOT0JXbi9POHZEdmFnTFR1SlRv?=
 =?utf-8?B?VStIUERyOEp1eVUzcmNEOUJPY2w5TzNaQStmTmV5Mmt3WUhzYzBKUEM3YXRl?=
 =?utf-8?B?R1JsQlExcUxvaEN6c29ObTg5R2R2b2VuQUhnQVhnSWJ0TkNFaXozeWZQdWhE?=
 =?utf-8?B?SlNBSzZvUCtJME1rTmFqUDM1V3NzNFFtZWQ5SmdXak1KelhNQXR1Q0xWc1NB?=
 =?utf-8?B?MUt3NHlTS1NJNU16Nll1NFNtWjd1cDduR093bW1TclpRZmJMMThQL1pNMG9U?=
 =?utf-8?B?MUlUUm5sNHhpTjR4S1BXbTh2M2NEVmRuK0N5ZTBPSEIzQ1lwbDRMOXI0N0FM?=
 =?utf-8?B?RnFCWXhSUFpoYWV6dXI0OVVaOENsM3NCWlNNOU5pajNrWUFIbVNRZ3VoNS9q?=
 =?utf-8?B?anBGZTRvUzJ1ZmNSblQzRGU4S1dndVBtbHRRQlQ3cHpMdWh5MURyaFJvcnYx?=
 =?utf-8?B?OXhQZ2RENTNlOGs4RFdyWGwvQW1SL0FMa3FIcDU1UVo1ZmxweWFhUVNGbFhv?=
 =?utf-8?B?MFhwREZYWDhuRGdBZjIwOTJxMnF5dXgxc0ljZGpLYmVob2RpdWdSZDN6dEI5?=
 =?utf-8?B?ZHlHNFhxWDYzdlhzWHF1SkxiTEhZN2xZVDExUEZocHgvOVhhZ0tNV1pEbENY?=
 =?utf-8?B?Z2hHSlMzUnJ5bmZ6L1Znd0V2T3lMS3JYOG5UeDFJYlEraEJ2TGtUNUV4OUxF?=
 =?utf-8?B?TExVZ1pXUVNFc0IwbTVCVFZWV0RwYXVxMGlHZ0hJK1poQnlTbk54c2gxTDRG?=
 =?utf-8?B?SGhibWFsVTMrRXRrK2JHT1hLTVpmOWgyWmtRZnZSZGMyVWFEdlc1WlJSVkdE?=
 =?utf-8?B?ZzlWQ2J4azJ3dHFPcXQ0ZUI1dzZTTVc2eXJjUXJ0eTlhb1pER0lHWHpSeDhh?=
 =?utf-8?B?WWQyVlpOSG10RTJZMUN6VFpjaUFINlowakovTVpYbXV1OXBaT1hiSmJIWkgy?=
 =?utf-8?B?MVVDSk42TjB0bFpmbmNXZDVTeFIzRTJ6K3gwZm5pbERIbHQ1dVdHRWpyMnIy?=
 =?utf-8?B?OXJoZnhhTHFBS1RFMHkxeXh0R2N3TWEyejNWUVVCWFVqYndaSDUwc0lXckJl?=
 =?utf-8?B?QXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0EE2566321396D48B5220E25C895D5DF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7142fa60-4fe3-404a-af86-08dd44a6a679
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2025 23:01:10.4456
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gPk1QIvgyS9eq4R14H8Jzz8OuNayYkMuJYJSa4j83pD4iNih4ylVaRXVmpLJmR9c3ii4ZFm6ivFBPXv1eK0/5y2LUWS7R6/49m4eSWrffFE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB6049
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTAyLTAzIGF0IDEyOjMzIC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IFNpbmNlIHRoZXJlIGlzIG5vIHVwc3RyZWFtIEtWTSBURFggc3VwcG9ydCB5ZXQs
IHdoeSBpc24ndCBpdCBhbiBvcHRpb24gdG8NCj4gPiBzdGlsbA0KPiA+IHJldmVydCB0aGUgRURL
SUkgY29tbWl0IHRvbz8gSXQgd2FzIGEgcmVsYXRpdmVseSByZWNlbnQgY2hhbmdlLg0KPiANCj4g
SSdtIGZpbmUgd2l0aCB0aGF0IHJvdXRlIHRvbywgYnV0IGl0IHRvbyBpcyBhIGJhbmQtYWlkLsKg
IFJlbHlpbmcgb24gdGhlDQo+ICp1bnRydXN0ZWQqDQo+IGh5cGVydmlzb3IgdG8gZXNzZW50aWFs
bHkgY29tbXVuaWNhdGUgbWVtb3J5IG1hcHMgaXMgbm90IGEgd2lubmluZyBzdHJhdGVneS4gDQo+
IA0KPiA+IFRvIG1lIGl0IHNlZW1zIHRoYXQgdGhlIG5vcm1hbCBLVk0gTVRSUiBzdXBwb3J0IGlz
IG5vdCBpZGVhbCwgYmVjYXVzZSBpdCBpcw0KPiA+IHN0aWxsIGx5aW5nIGFib3V0IHdoYXQgaXQg
aXMgZG9pbmcuIEZvciBleGFtcGxlLCBpbiB0aGUgcGFzdCB0aGVyZSB3YXMgYW4NCj4gPiBhdHRl
bXB0IHRvIHVzZSBVQyB0byBwcmV2ZW50IHNwZWN1bGF0aXZlIGV4ZWN1dGlvbiBhY2Nlc3NlcyB0
byBzZW5zaXRpdmUNCj4gPiBkYXRhLg0KPiA+IFRoZSBLVk0gTVRSUiBzdXBwb3J0IG9ubHkgaGFw
cGVucyB0byB3b3JrIHdpdGggZXhpc3RpbmcgZ3Vlc3RzLCBidXQgbm90IGFsbA0KPiA+IHBvc3Np
YmxlIE1UUlIgdXNhZ2VzLg0KPiA+IA0KPiA+IFNpbmNlIGRpdmVyZ2luZyBmcm9tIHRoZSBhcmNo
aXRlY3R1cmUgY3JlYXRlcyBsb29zZSBlbmRzIGxpa2UgdGhhdCwgd2UgY291bGQNCj4gPiBpbnN0
ZWFkIGRlZmluZSBzb21lIG90aGVyIHdheSBmb3IgRURLSUkgdG8gY29tbXVuaWNhdGUgdGhlIHJh
bmdlcyB0byB0aGUNCj4gPiBrZXJuZWwuDQo+ID4gTGlrZSBzb21lIHNpbXBsZSBLVk0gUFYgTVNS
cyB0aGF0IGFyZSBmb3IgY29tbXVuaWNhdGlvbiBvbmx5LCBhbmQgbm90DQo+IA0KPiBIYXJkICJu
byIgdG8gYW55IFBWIHNvbHV0aW9uLsKgIFRoaXMgaXNuJ3QgS1ZNIHNwZWNpZmljLCBhbmQgYXMg
YWJvdmUsIGJvdW5jaW5nDQo+IHRocm91Z2ggdGhlIGh5cGVydmlzb3IgdG8gY29tbXVuaWNhdGUg
aW5mb3JtYXRpb24gd2l0aGluIHRoZSBndWVzdCBpcyBhc2luaW5lLA0KPiBlc3BlY2lhbGx5IGZv
ciBDb0NvIFZNcy4NCg0KSG1tLCByaWdodC4NCg0KU28gdGhlIG90aGVyIG9wdGlvbnMgY291bGQg
YmU6DQoNCjEuIFNvbWUgVERYIG1vZHVsZSBmZWF0dXJlIHRvIGhvbGQgdGhlIHJhbmdlczoNCiAt
IENvbjogTm90IHNoYXJlZCB3aXRoIEFNRA0KDQoyLiBSZS11c2UgTVRSUnMgZm9yIHRoZSBjb21t
dW5pY2F0aW9uLCByZXZlcnQgY2hhbmdlcyBpbiBndWVzdCBhbmQgZWRrMjoNCiAtIENvbjogQ3Jl
YXRpbmcgbW9yZSBoYWxmIHN1cHBvcnQsIHdoZW4gaXQncyB0ZWNobmljYWxseSBub3QgcmVxdWly
ZWQNCiAtIENvbjogU3RpbGwgYm91bmNpbmcgdGhyb3VnaCB0aGUgaHlwZXJ2aXNvcg0KIC0gUHJv
OiBEZXNpZ24gYW5kIGNvZGUgaXMgY2xlYXINCg0KMy4gQ3JlYXRlIHNvbWUgbmV3IGFyY2hpdGVj
dHVyYWwgZGVmaW5pdGlvbiwgbGlrZSBhIGJpdCB0aGF0IG1lYW5zICJNVFJScyBkb24ndA0KYWN0
dWFsbHkgd29yazoNCiAtIENvbjogVGFrZXMgYSBsb25nIHRpbWUsIG5lZWQgdG8gZ2V0IGFncmVl
bWVudA0KIC0gQ29uOiBTdGlsbCBib3VuY2luZyB0aHJvdWdoIHRoZSBoeXBlcnZpc29yDQogLSBQ
cm86IE1vcmUgcHVyZSBzb2x1dGlvbg0KDQo0LiBEbyB0aGlzIHNlcmllczoNCiAtIFBybzogTG9v
a3Mgb2sgdG8gbWUNCiAtIENvbnM6IEFzIGV4cGxhaW5lZCBpbiB0aGUgcGF0Y2hlcywgaXQncyBh
IGJpdCBoYWNreS4NCiAtIENvbnM6IENvdWxkIHRoZXJlIGJlIG1vcmUgY2FzZXMgdGhhbiB0aGUg
bGVnYWN5IFBDSSBob2xlPw0KDQoNCkkgd291bGQga2luZCBvZiBsaWtlIHRvIHNlZSBzb21ldGhp
bmcgbGlrZSAzLCBidXQgMiBvciA0IHNlZW0gdGhlIG9ubHkgZmVhc2libGUNCm9uZXMgaWYgd2Ug
d2FudCB0byByZXNvbHZlIHRoaXMgc29vbi4NCg==

