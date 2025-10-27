Return-Path: <kvm+bounces-61225-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 287F6C11901
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 22:29:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BEB94425E5A
	for <lists+kvm@lfdr.de>; Mon, 27 Oct 2025 21:28:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01F0D32B99B;
	Mon, 27 Oct 2025 21:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MpZUDWOD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C10B26C3A7;
	Mon, 27 Oct 2025 21:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761600500; cv=fail; b=q878NhgWBZ9M2fzTGti259Jl6Y3WJy3saRSNH7Z/+dpJ3Ei/L+EVfYiXBKbbnHZu3utR9QjBeJMkdIEa1/Dpb2nMY9S8F71rqmIgGQIAK252v1nY7VTp0ZAxcmz6F3JdNjbkcdHXPzOoIXU7jcjcip67tSlG3iZf/xsS001PfvU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761600500; c=relaxed/simple;
	bh=0FLJC3X4g+atlxz0uCQIJIxGTYPyIghsFGq0w511agk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cU5U4kmMqcQud2IWLAHwMpLYfTUEqv7vaUzx86Ew2n/XwVYTriifgQ2Zzd+rWvlxEYrK8pkJEw/Eg8VX0LO45OX0PhVu3QgsMl+9jHP3x+SM6ScNc9JDdaUPcrjKJh5BHQJpKImPWWj7Fm4/FB1uvCRk7AF3UNt//JpJRL5+4kc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MpZUDWOD; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761600499; x=1793136499;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=0FLJC3X4g+atlxz0uCQIJIxGTYPyIghsFGq0w511agk=;
  b=MpZUDWODda2+UzHqiFIU3tbNC0+VIa9f8+tNTu1HomAx233duL74716q
   B0WFPVGKmRMyIG7X0KEydtsaaQltdfywORCEGiUyjBGd6An5yE9h61qbM
   S/r6JyNLDuwvH/n/ZQC5IW7ct/dolOiFUC2vDlYQMJ1JhScoQRxdU9INM
   Nzh+PLWAFaP5277/twgXK49vigvdKxjdNz5KDHp9n1Yj70eJjLm7bsCaW
   LwGV/RmYK28TJoWY09/peGx7RkTKRt4O8S0RKs9MTEdB23LjHftwRUQOH
   g8YKQ5OPOWe2R5AcUI6NqYl9xcMoqd2FWSh4HH8K3+tmTP2lkZ3mJfDKn
   Q==;
X-CSE-ConnectionGUID: nn5adt+cQa6dFspFBVVlGw==
X-CSE-MsgGUID: 0Lku5MuNSFq4pp+Hlbu5wQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="74293861"
X-IronPort-AV: E=Sophos;i="6.19,259,1754982000"; 
   d="scan'208";a="74293861"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 14:28:18 -0700
X-CSE-ConnectionGUID: VS5UJpZiSGqS7zIOBVJ+0w==
X-CSE-MsgGUID: /Jct9QX3TjShp2tYM+N2cg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,259,1754982000"; 
   d="scan'208";a="189528349"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2025 14:28:17 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 27 Oct 2025 14:28:17 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 27 Oct 2025 14:28:17 -0700
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.59) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 27 Oct 2025 14:28:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HHRU/oRC/T7iJxoWEWH2aJhIozYYa30+MbTELlEjbyeFH+3D9Gf/z5V9JnmzdIjKft3qI2hy2LRRFMaK36ADJxSz0TJmf51UnjrZQTQcsFap0TjWDHXc7UILQeQiQGQ8Bid60eNyk9tDY/uU7Quo64ZAKc7Gu8H/I4B9349ZEw7pL9Jy7oi0WrZLgoGt1amy2siizaPosC/J5cyVdi2GuUKCWih98Rel98fpQdwZIalHTKVeyce6Tn/9ClqnSZ5F143Y+emMD9YRgI9pg6yBqsjuWb5xSLPAFlgCWVDIXuPXdjS8U+iSQRia/z2m/oNLC/uCp1tCJaND+GgZi6KIRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0FLJC3X4g+atlxz0uCQIJIxGTYPyIghsFGq0w511agk=;
 b=S3vhFmDo9hxrKhLPsik6tvjQU0rY9o4sSDBAGX/t3G1lw7ek4twsbVn+wBqRyL0dlBpnJslzfX4mvFMido/6gUcXnU9g9sqm8vSfA6Ef9krXd4xKbCpi4DYXAh8LRIhDsi1Jc7g8qFblaZL6TfPPDfVIdBZDC2U7x1zl2n2R4tdOtsqmeYPIERhcJJZF+MSVljt20+jfFBgW7LTShm0FvhZJRgErxRkWpW3gup6DT3YyQobjXJUU/gmx9Ae60Z1BGj9lBA1vcAXlTuJIvHPcAO1GjaChBy1P/ewBYVHUOkh/L2nADSYpUb5gk48ef/4gmovdLrofOxfBK/e5Gi65OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SJ0PR11MB4829.namprd11.prod.outlook.com (2603:10b6:a03:2d3::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.18; Mon, 27 Oct
 2025 21:28:12 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9253.018; Mon, 27 Oct 2025
 21:28:12 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "ashish.kalra@amd.com"
	<ashish.kalra@amd.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kas@kernel.org"
	<kas@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"dwmw@amazon.co.uk" <dwmw@amazon.co.uk>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "sagis@google.com" <sagis@google.com>, "Chen, Farrah"
	<farrah.chen@intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"bp@alien8.de" <bp@alien8.de>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Gao, Chao" <chao.gao@intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "Williams, Dan J"
	<dan.j.williams@intel.com>
Subject: Re: [PATCH 4/7] x86/kexec: Disable kexec/kdump on platforms with TDX
 partial write erratum
Thread-Topic: [PATCH 4/7] x86/kexec: Disable kexec/kdump on platforms with TDX
 partial write erratum
Thread-Index: AQHcG1rj8xzFenegOUSY8voF4LzMlLTVayCAgAAVl4CAAQSgAIAAVSGA
Date: Mon, 27 Oct 2025 21:28:12 +0000
Message-ID: <114b9d1593f1168072c145a0041c3bfe62f67a37.camel@intel.com>
References: <20250901160930.1785244-1-pbonzini@redhat.com>
		 <20250901160930.1785244-5-pbonzini@redhat.com>
		 <CAGtprH-63eMtsU6TMeYrR8bi=-83sve=ObgdVzSv0htGf-kX+A@mail.gmail.com>
		 <811dc6c51bb4dfdc19d434f535f8b75d43fde213.camel@intel.com>
	 <ec07b62e266aa95d998c725336e773b8bc78225d.camel@intel.com>
In-Reply-To: <ec07b62e266aa95d998c725336e773b8bc78225d.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SJ0PR11MB4829:EE_
x-ms-office365-filtering-correlation-id: 5dc85f79-5339-45d9-4f9e-08de159fbb65
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?bFFDeWVhc1dHdnBaRUpPZU9oNXlrTDNaa1RDclN6VWppTFlPTzJtVnVwcjlF?=
 =?utf-8?B?Q2ZsREZ5MlpMYnVKMEJLT1N0MFlOUCt6WitQVEd5eG5DblZadi9mT1d2cjJs?=
 =?utf-8?B?SGJsLzlyUVdYMmF3dndtR245L2FmenF2eUhFdC9CNjRYamI3VDdwVHFWMitY?=
 =?utf-8?B?ZlV2L2NRVHpSZlZtamt1dkFQNVBPek5iUFJFNzZYbnZhcEYzb3ozMnhiaVdG?=
 =?utf-8?B?WGEreTZjT1V5SHUwc09raVVjUlIzZ09ydUZXUFVsWE5LbThmeHFic0g1amNr?=
 =?utf-8?B?VFFUNHdBRm1qZWZLdHdOc05ZYXNCYXB1R1REd1NoeG85VU14WmZ4VHRKaWgv?=
 =?utf-8?B?ZlZ2WkpzMnFvN2VUcVp6UmMzR3IydVZZR3ZsRWdaNlBGR3pQUUk0YkNRNGdj?=
 =?utf-8?B?SVN1MlZOR0Z4UU5lbngvQkk5MEJwMjI1eDFmaURYV2J2VFVNSW4zWUdjSzNj?=
 =?utf-8?B?Mk11aVJSUXlpakxXN1lWc2ZBTXZXS1lxbys2N01DTWh5UlhCdFhqbURNZmhK?=
 =?utf-8?B?SDRNOHIzNG5JU2tOUnpHbi96SFlHeTBYRW5LYlpLYjlYeUZLcERMWWVaeFkr?=
 =?utf-8?B?Z1A4bXVLWDRJVlZyL2I1K0RoakNxOVhVVDhXSTdyVHNTbXRmNndnYnRhZ1Az?=
 =?utf-8?B?a04wLzFCMHVPRUg0dFZXUy9JSGtaOVlGaWVzRUN5aWY4QjBYaElZRGlaOGM3?=
 =?utf-8?B?SHJHRzYwYi9KYVdIUkR2MDRiM1VmNlk0T2N5Q2JiZVkzVk80ZE04UjUyK1BS?=
 =?utf-8?B?LzdUcG5Oenk1T0VYdjlxQTRGaStmUHBjcmpGaUFWelZXK3ZBbmxrYzBtWmcw?=
 =?utf-8?B?RUFnVUdWTHkxWVVNaitDZk54VUxLbGR5N0xHd3JIT1BZTEFQaWNHOVNiV09C?=
 =?utf-8?B?azJjZUlsaXZreXBaUkdMdlBZWVdDSXdBeGg4ZWd2QVV1UnJOQTZROGFRd0Rs?=
 =?utf-8?B?ajFQMk5zaWwyRGEwMXNHREsxRmZlM0QvcUFLcjVKOU9XcDRqeHNkNUdibkQw?=
 =?utf-8?B?dVhqUGZPd2p4d2VlV3diUkVsZitLMnRqTFEvMkhWdkRNTklZQzBnTHRWYXll?=
 =?utf-8?B?M21XR3BOa2pkNFN3bEI5cUY3S3pGT1Z1dTF4Q25sVm1ZNmJRRW1wWTg2YkUz?=
 =?utf-8?B?Qkd6ellNZTNBM2kzcDNtbVU3UXdadGdTME5YeElSc3RKWWVZQnpWTkkzeVpx?=
 =?utf-8?B?WEFMQTBCTmJSd1RtM215YUplV0tFQ3p0VmkydS9NdEZWOXF2djFITzBRaCtw?=
 =?utf-8?B?Qms2a0dheVZhM1JuSVBOVWFiV2xXMW11YXlWZ3YzM0VRVDNYMFZGMXphRTQw?=
 =?utf-8?B?Q3J1dDNxeWc2S3I0UXl4SmE2cE9GL2hvY2xCbVlEMDhLRWxXMzFhR3E2Q1dr?=
 =?utf-8?B?ZnAxTFZ4SVUwUTNvcms4SU90SHFScnhHcmJhbUdwMGFoYXlEd0JmUFpnQUtk?=
 =?utf-8?B?NXBmNThZaFV1eE1GQVZqTldhVmpKSGJ4RjN3OUxPaEVWeldQSkVLSWpCVWNS?=
 =?utf-8?B?ejdlR1RjTTlwVFgvSzBNWTV5ZnVValRBRHpoZk9la05OYm9lWktjWldFMUcr?=
 =?utf-8?B?UmJkUnVTVzRZSHJJOXJFcXYzSDVLWkRGZWtrVDNXTWFMRlZJV1VnNzRQdFE3?=
 =?utf-8?B?VXp5dGpQcFpzNmE4UFBiVlkxTEpYYXFPSldzMlpJZ0dhVnRMQWxjaDgyRzlI?=
 =?utf-8?B?eThpMlVDMVpSZENlNXRvQXF6RXVaYnVNZi9udFhQSlRrRFp5UXNTSGNxNGxr?=
 =?utf-8?B?MlR6Y1lWcHNZUGRJeEhKSkZWMlFtU0V5K0FwQVNoR2tTcnpXdHA2eS9zWkpR?=
 =?utf-8?B?WG1acVlZMkIrRVBEMERRTUNyMm9ZbndyZUJIKytiblNEQzRZc2dPRGNmOHBk?=
 =?utf-8?B?Y09HeEd0M045Y2MyUmwxZUpjM2FFUWMyOExpZk40bFU4cHZRMDdhcFdISXlR?=
 =?utf-8?B?Y2pZRThJaWFXcjkyQmpCL3FNTFZyMG9teUM3STJndmo5dlc4MDhzdUE1bnJ0?=
 =?utf-8?B?am1ub2ZlSTFMTWhEMngxcGgxZ3FFUndvMlFEbjdrSWN5VmlWSTNJYkRLVHIy?=
 =?utf-8?Q?9dnCeQ?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c2RSS1pwblVkSVcrRlloV0hTTS9jdm1rNVl1RXJDS2F5OFQrOU5XZmpHRzVC?=
 =?utf-8?B?cENaNGJNbCtteWVMVk1INE9VV2cvZU5pVGF3R01FeXdSdnpFT3dDRkw2SHEr?=
 =?utf-8?B?Uk44RXF3TXB3MG56K2txbCtGT0p0ZDRTbURTamswWXFEVkc1QzBZaVlYT0V2?=
 =?utf-8?B?U1R0aEhrNDd4d1pMSk0xUGoyQkdIOFBXRVRiRVArTEVWTllGWU80UCtUc0JL?=
 =?utf-8?B?MTN4VkliZFhydEg2R1NLSFVrVTBrWEVTK1B3QTltQ0hyWW5mMGZPd2VkdEZ3?=
 =?utf-8?B?SGpNam45RDA2SXBoZmFPL1hKOUpxb1ltekZyRUpLRHZxYUdaQjFwSWNnYkwv?=
 =?utf-8?B?cWlYMHBVc09QV1B0NkpHVGpuU0dKeFpUeHkveWtOUzAyYmNNdWo2MEJHRGNI?=
 =?utf-8?B?Qm9NU0ZDYktHdFliREZvM0Zoc1p3RHFWV1daUVMrNGkzenNYUks2UFh2UHhI?=
 =?utf-8?B?dzZ5RUg5VlVhZ3ZlL2cyS0hFb240TUtVSFJVYWc4R0YwS3hwbnlRWldhd2hM?=
 =?utf-8?B?UU9FR21rRWVYb005dVdWQ1pyVEFMa2R3K0hVdHd1d1pobXBuWEZBNU5yd3RI?=
 =?utf-8?B?R0w1VXhVaDFCcHowZDlIa2xqQ1hySFRFaUZPb2hIUkJQYTBEL0dVU3dCU0Nz?=
 =?utf-8?B?N0JsZkRySlJwV0lVdzNvd0dRVXBWT2haWHpRZ0tVUmlrb0RuSSt4VldvRHM3?=
 =?utf-8?B?YnkzZXBlZUJZa0l0QzJ0cUl4bDhNUjFHdzNTQ1VBMFI2WThEZnpmb3VPUW5x?=
 =?utf-8?B?STF0NVNJQUp2R2ZhSFV4bERIVXRKVUpDdS9MYmhBdWpmNHNsOXZFVEF5TVF5?=
 =?utf-8?B?c2I4UXY3WUEreW8wWXpnMXhxVXRGRTB1OXovdU9sN1g2d0kwc3liaXNKT2VP?=
 =?utf-8?B?eHZXQ3VUQmlsd1lFWEdIYjkvdkNDdURuT1RNYlZBNmgvSFBsdm5vVmJGUlVm?=
 =?utf-8?B?TGRIenArdEVWMDRTbVBmc1ZQc05JcHBPcURxR0NPSS9KUmVpUWEwWHZzZm5C?=
 =?utf-8?B?VDJQRnE0a29lYVQ0aVNsa1JNOWtwY0h3ODFWejVwVGhhdHQ3R3d1OVc1Tms1?=
 =?utf-8?B?TWVuQVB4M1drcUhpbnl0RG5qbTRXUTVxUzZNQ1g3NnhQWHRxeC8raE50RGE5?=
 =?utf-8?B?eVdMUG1yaUlTWncxK0tuVTI4UGZLTnlPSDhMeml6aEh4VzcvdkNLY1d1eVRw?=
 =?utf-8?B?eXgxM1BPOVdxZUw0MzJSaDNTelZuYzgzSmV5Ulg0OXhrUFpvSHpMQ3hKbUVa?=
 =?utf-8?B?VlZsbkJGTEptVHZJRms4a1l3aUx2YjVUTGJWVlZjZDFoRFVBZVRSRDZ5TFlX?=
 =?utf-8?B?TXE1c2lUNlpYWEVGODkwSkUrRFJKOEV2QkNnVVc1TThlQkFia2VLZHRKN25m?=
 =?utf-8?B?bTAyUEdnRzRpZ3BBeVU4VmJDNE5Zc1puZC9zTk1qNEJoZk5JLzdOOTVSdzhY?=
 =?utf-8?B?dGFhQ3dkd0hGSE1rZS9mTjRMYmdwanF1RDg2TzVGZlhiS2I3S1ozYnpMVXJr?=
 =?utf-8?B?UDFEd3c4RU5WSCthbHMrdzJ3U3NYUE5lNGFaMXRqOTJEUmJUUFVyYng5UGFz?=
 =?utf-8?B?SGVYV212SUZ5WndBajB6RWZjcHZKQUh4d0VWaDQvSkk5S0ZYYjBubjZxRjRn?=
 =?utf-8?B?ektQbGNSbFNnWHpRZktUajU1RmFIZHdjdG1DZmE1b2RVZEtYTEdNTlgweXpk?=
 =?utf-8?B?c3FsVkg4ZHZIdFB5OXJ2UDgwVHp6MXg3RHorbGZmRlZheGxOZExHODAwdGlq?=
 =?utf-8?B?Sk9Ra3dBblh3RUh1UzlsT2d5d2xOVXkzNUQvYjRJZzFUTmRvSXQzVFg5eGhj?=
 =?utf-8?B?TktOYlJGcGtsNHl0YzkrUWlIUGpmd01hOWtmRnoveit5SGJRU3dxcHErSGFk?=
 =?utf-8?B?bkl3ZVVJQkZseGVOK1BqQVdoNGtZMXNUc3ZsdmlQbmNsRDN5cjhoV0x2MzBx?=
 =?utf-8?B?WExkdmZramZnSGhZQ3M3NlNybVJBWGpUWXlqTjFFQ0FIS244RUZpcUl3RG1h?=
 =?utf-8?B?Q3RhLzJOSzlmNDhYUjJKVWN1SnJDRnFBRUtGYUVRSzBNais0SDdDTHNPQ2Uz?=
 =?utf-8?B?eXpyMnUwYXQ4aExJYnRpbGxaRnlONUtVcXBGNEdDaGpnTFBSaGt6UWRrcWYz?=
 =?utf-8?Q?eyLTHV4qDZQ9ntoHgjECjEUjr?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2FC7D9102E84004BB5180047FF20FCA4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dc85f79-5339-45d9-4f9e-08de159fbb65
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2025 21:28:12.0817
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: epYGnXIVYvtgJaRe/ccWncW492pyPrxYdcS6Polrvb9NF6vGAp+TzZJccYZdMiXNWmbbB7HhoN3PX3pD/b2Cgw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4829
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTEwLTI3IGF0IDE2OjIzICswMDAwLCBFZGdlY29tYmUsIFJpY2sgUCB3cm90
ZToNCj4gT24gTW9uLCAyMDI1LTEwLTI3IGF0IDAwOjUwICswMDAwLCBIdWFuZywgS2FpIHdyb3Rl
Og0KPiA+ID4gDQo+ID4gPiBJSVVDLCBrZXJuZWwgZG9lc24ndCBkb25hdGUgYW55IG9mIGl0J3Mg
YXZhaWxhYmxlIG1lbW9yeSB0byBURFggbW9kdWxlDQo+ID4gPiBpZiBURFggaXMgbm90IGFjdHVh
bGx5IGVuYWJsZWQgKGkuZS4gaWYgImt2bS5pbnRlbC50ZHg9eSIga2VybmVsDQo+ID4gPiBjb21t
YW5kIGxpbmUgcGFyYW1ldGVyIGlzIG1pc3NpbmcpLg0KPiA+IA0KPiA+IFJpZ2h0IChmb3Igbm93
IEtWTSBpcyB0aGUgb25seSBpbi1rZXJuZWwgVERYIHVzZXIpLg0KPiA+IA0KPiA+ID4gDQo+ID4g
PiBXaHkgaXMgaXQgdW5zYWZlIHRvIGFsbG93IGtleGVjL2tkdW1wIGlmICJrdm0uaW50ZWwudGR4
PXkiIGlzIG5vdA0KPiA+ID4gc3VwcGxpZWQgdG8gdGhlIGtlcm5lbD8NCj4gPiANCj4gPiBJdCBj
YW4gYmUgcmVsYXhlZC7CoCBQbGVhc2Ugc2VlIHRoZSBhYm92ZSBxdW90ZWQgdGV4dCBmcm9tIHRo
ZSBjaGFuZ2Vsb2c6DQo+ID4gDQo+ID4gwqA+IEl0J3MgZmVhc2libGUgdG8gZnVydGhlciByZWxh
eCB0aGlzIGxpbWl0YXRpb24sIGkuZS4sIG9ubHkgZmFpbCBrZXhlYw0KPiA+IMKgPiB3aGVuIFRE
WCBpcyBhY3R1YWxseSBlbmFibGVkIGJ5IHRoZSBrZXJuZWwuwqAgQnV0IHRoaXMgaXMgc3RpbGwg
YSBoYWxmDQo+ID4gwqA+IG1lYXN1cmUgY29tcGFyZWQgdG8gcmVzZXR0aW5nIFREWCBwcml2YXRl
IG1lbW9yeSBzbyBqdXN0IGRvIHRoZSBzaW1wbGVzdA0KPiA+IMKgPiB0aGluZyBmb3Igbm93Lg0K
PiANCj4gSSB0aGluayBLVk0gY291bGQgYmUgcmUtaW5zZXJ0ZWQgd2l0aCBkaWZmZXJlbnQgbW9k
dWxlIHBhcmFtcz8gQXMgaW4sIHRoZSB0d28NCj4gaW4tdHJlZSB1c2VycyBjb3VsZCBiZSB0d28g
c2VwYXJhdGUgaW5zZXJ0aW9ucyBvZiB0aGUgS1ZNIG1vZHVsZS4gVGhhdCBzZWVtcw0KPiBsaWtl
IHNvbWV0aGluZyB0aGF0IGNvdWxkIGVhc2lseSBjb21lIHVwIGluIHRoZSByZWFsIHdvcmxkLCBp
ZiBhIHVzZXIgcmUtaW5zZXJ0cw0KPiBmb3IgdGhlIHB1cnBvc2Ugb2YgZW5hYmxpbmcgVERYLiBJ
IHRoaW5rIHRoZSBhYm92ZSBxdW90ZSB3YXMgdGFsa2luZyBhYm91dA0KPiBhbm90aGVyIHdheSBv
ZiBjaGVja2luZyBpZiBpdCdzIGVuYWJsZWQuDQoNClllcyBleGFjdGx5LiAgV2UgbmVlZCB0byBs
b29rIGF0IG1vZHVsZSBzdGF0dXMgZm9yIHRoYXQuDQo=

