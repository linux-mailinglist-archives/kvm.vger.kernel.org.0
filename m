Return-Path: <kvm+bounces-56103-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5BC9CB39B60
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 13:20:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 15077467DCD
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 11:20:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAFC930E0D5;
	Thu, 28 Aug 2025 11:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="agZ2mTOI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6909F17A2E3;
	Thu, 28 Aug 2025 11:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756380043; cv=fail; b=kDJXr47NbVBZFGOxJQbF8ttIGTmAbg4Yde160jSJTd7N8knyVDDfl7ODf9zOMPNPygQ77bL189NL1+IpaJpvjzcyHuftjTgnVvfwRz6hXLD0el/DaTsesXfmsqZBDXzd5Aow250S/xh5FSRA7bDUMgG8VLyhM6Iqyd1NSRV+tus=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756380043; c=relaxed/simple;
	bh=z0CH9GxPx/93SDopor4BQgHaOx5s2ZLotlpU0WVgKHw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bEz4YY0mst2zdlhb54UjLx+lirFXjRIp2p5CqF2MtjjM6TXn+O/R4l3Bb6bQkVm4j3MPaf7IJM2lLIX77lRdKl+Tfrw7xOX1eyYnf6chaVS3HzDVF/JQ2OH+gts/0JEp2ymILipo44Kz1ZFEo8dpSbeZquA8TPc9OItBRC70TIE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=agZ2mTOI; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756380039; x=1787916039;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=z0CH9GxPx/93SDopor4BQgHaOx5s2ZLotlpU0WVgKHw=;
  b=agZ2mTOImZZWC6vSSODvLU7E1v/DyvE0/m1JsWoU1/IQVG+YfEuuBdm9
   fIm2NqDS1d2bUyvcDtxkikwx7lckNx/rOA5i01+at6yzvcciqr/7OdVvU
   CGXepp1l6q14MtoIDGpeVNvJtmZPakHInzDQOlZQkeF12MOgLKZQOJAYq
   VCmD1/sj34lGPLHgjniI6Nrbs/S/VsG5j13S0/ES199yW7EVQrrdlOR3Q
   SCZaTIwt5CPolzunUSsg9iXWH+ak14OlTW0RKPhc6d794Z4jHVjFhKung
   ZdvEtGbUtHT3gLVhBn0skQeHWMA+4Q48iQ1SwaJbGc0inmx2tdDsxtEFs
   w==;
X-CSE-ConnectionGUID: DBBFLSG9Q3q0nc43F8GP4g==
X-CSE-MsgGUID: 73oHbLf1R8ObXuum3vBdQg==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="58587573"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="58587573"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 04:20:38 -0700
X-CSE-ConnectionGUID: oaxPnbaqRnOYz9xU3Knc2g==
X-CSE-MsgGUID: E+bCCdYvTfKTd2xr7y73gQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,217,1751266800"; 
   d="scan'208";a="169988491"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 04:20:38 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 04:20:37 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 28 Aug 2025 04:20:37 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.53)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 28 Aug 2025 04:20:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SWAZu07yiN2nw4hOPL1xBg4ZnYWQ9FizO8TZlDAYZacyW/IdUNVgxQLt27BE9dffbrM6sCGSy57Qi1b31HpeCldpVcHizQ8aYQujBBf/mgv49wzChv3YdH0hqoXl8TnADniX+FnHqXMDmZKx162vFnRLwFOQIxr7zyWmwnszyEqTlNkmK6fARZS8S9oKYOi3+Tj8dRF67Q+GSS8H0nThD7ZNcUx5MEW6oCLiNOUU+STXrqUYDdAmSaUEy36dI/TMvpaf+3jOhle7Jav1iepPR4GAYbSVDwdWgs59B8GAnxOf73n0RwWylcZE/jFehU1RAiU6A0OY0lLhscBz49FgIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z0CH9GxPx/93SDopor4BQgHaOx5s2ZLotlpU0WVgKHw=;
 b=X+XFUXtLHgZw6qQwgAwr37tySEeqYgQ9dRjb5pQgnKUJdFoeLUHDmoKXV4Arh5e9gAXcOQ+yHhACWiyTjuhLDqEjlPk+s6zkDO/BW1A98CKqnjoYbsgW6yqxtM3DlXMdt3hFFXF9qyprxTBmxwYOmFJhkcvrjJdQVEwnIQrBP1Fw+kklPjq9GOfiYrT07Chz2fYx8rbKrFZqu9AcK3hzLgDxxF0ncNflLPZQ8qRM9wbaPROyHs9oqwpsm+BPVaJyyO6jxf6YjFLx3fOAoy+qOQpeUYpfzQCPZBzr670wrIJWOG22U4IrteouqtHro5SYKrbmOPr2TjTBQpp27GsEug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by CH0PR11MB5220.namprd11.prod.outlook.com (2603:10b6:610:e3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.17; Thu, 28 Aug
 2025 11:20:30 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%4]) with mapi id 15.20.9073.016; Thu, 28 Aug 2025
 11:20:30 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "sagis@google.com" <sagis@google.com>,
	"bp@alien8.de" <bp@alien8.de>, "mingo@redhat.com" <mingo@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Weiny, Ira"
	<ira.weiny@intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"hpa@zytor.com" <hpa@zytor.com>
CC: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3] KVM: TDX: Force split irqchip for TDX at irqchip
 creation time
Thread-Topic: [PATCH v3] KVM: TDX: Force split irqchip for TDX at irqchip
 creation time
Thread-Index: AQHcF7MAb7ZcyaOXHEWwn5v1bWphJLR37BsA
Date: Thu, 28 Aug 2025 11:20:30 +0000
Message-ID: <ce2f31af27a07faebf55055b392e706464a803f1.camel@intel.com>
References: <20250828003006.2764883-1-sagis@google.com>
In-Reply-To: <20250828003006.2764883-1-sagis@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|CH0PR11MB5220:EE_
x-ms-office365-filtering-correlation-id: c2c54a8a-3c18-47d4-0651-08dde624e597
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?VDRiV3dhUUhRMEdMMjk5UG0zUHd1NWFOZndQQ1l1bm1IWkVHQW5IQURKc1Rw?=
 =?utf-8?B?d2Fld0RpaEZwWWFkSWxSU1lSbXdHS08yMGdiZlVqeHl6dForMFFuL2tMZ2NV?=
 =?utf-8?B?anpBTzNvUTlNYVRyWEd6T1RrcVloeGN4d0ZlYnQ4VksvSEtFMnZtZFBXUEg4?=
 =?utf-8?B?c3U3RFRqU29LN0IvaXhhaXNFUElCNWM2T3hUQUZ6YWdueWlnZ0xxQjRzNkxh?=
 =?utf-8?B?WElKQVVrZUpSQkRSUWtFUHBCZHIvTVcwTVNkMXJQVjZ1NmEvQlM2UFA2OG9F?=
 =?utf-8?B?R3N0ZnVhY2VSdHVZWDA1VE5nTy9SMlJ0NHM0L3c3dGhFOHJLTkN2aWVRZW85?=
 =?utf-8?B?TEVZUzhyTWFQYlRYYTVNaHprYjZDRVlZaW1mY1JiUWFKdVpabTF5TGRsdzd5?=
 =?utf-8?B?OHBPWmkvYkFlK2hjYVBoYysvQ1pRSXNpNzhrazIwOUhpd3IrZG9meVZ3bmtL?=
 =?utf-8?B?empMVU4rOTBXdjI2WHFXYTZaeG5uZFBtQXZOYU9VU3hRMWtuVEI1elE2THBI?=
 =?utf-8?B?WGZ5R3RKL1BXTERLUE5CaTRPVTFScEVPVEswendBcGRPKzhVUDdva1BQNmhi?=
 =?utf-8?B?OWJ2cmJxdkY4WlpMcmZrU2NnWXNGWjdGd0FCUFZiVEF2WWx3cjVDQmFwSTI5?=
 =?utf-8?B?WHlDdlB0Z2NWaWdaa3lhSld1K2U0RkQrZ0NEb1phb1I4R2FxYjFyeUVNUHFT?=
 =?utf-8?B?SUY5M2FkRXdITlo5MmJmc0lOT0ZYK25BeU9zSTN5clNZOTkxclFkUXpuUitu?=
 =?utf-8?B?aURObFZvSUZ4MUEyeWlnZzZsYVlLV0E0YU5BeEJtbW0wTGtvYUkrSkI0cGJq?=
 =?utf-8?B?bE1PM3RKaWhyT3A0bFVtMG1DTWtxUE95Z0Vwc1FMdVI5cWdBa203ak10RDNE?=
 =?utf-8?B?RlhJZXhhN1pzOU5BOWl2M1gwRWYwUE5KSDE4SGZFM2lTbmRMUGZDRVhvTkhQ?=
 =?utf-8?B?cXlJdzg3ZG0vcWZnUFZsS2FlZ1hLeDRMMFArKzgwWldJcWhYRnpCcnB6ZmFU?=
 =?utf-8?B?azVNZ2NKN0NUSWVjQmRvdm15bzFFa3NRVlJqb2g2ejArS0M0TDc5YVVZbGVT?=
 =?utf-8?B?cko1NXZWNWNmVG5UeFJhR2dFYkphNE5zdW02OTdMQmxVR2djT0VqUmZCbXJ4?=
 =?utf-8?B?SXpCTVJpVTVJUVcxQTQ0NUx1L0FhTndKL3N5MmZ1emFVTzdLK2krTktXRkNV?=
 =?utf-8?B?eTBUWGxBL0I2Q0FoSXZYRW1jSzgveGZvMjNYSGJnT0dRYUROLzhid3B3cnFH?=
 =?utf-8?B?Y0tuYzRtamZUYnllK0JqSXRqeFlpZEVNdFFPeWx0aCtSbjA0VTNpTW1lZmF5?=
 =?utf-8?B?czRURnZIcEtlZVlXTDBYM3R2Z3dtNEJiWGxpVVVYb2lONlYrSlc1SWY3QlIy?=
 =?utf-8?B?NTJSQklCWTlkNUZYVXc2Wms0NXRFRHR3Rld4SnFyNTFCYTRuSEwvVk52TkZp?=
 =?utf-8?B?bjE1MjE1T1BNalBOU0VvQUxDMFlzeUt5MTlRV2N1QlgwRDlubFFmV0x1QjFC?=
 =?utf-8?B?dHdoUFNkZWVsQ0FQazNSWEN1WTVYVC92RnlpdEpGVDdSRnlUVlIxa1BSZGRo?=
 =?utf-8?B?OFhEbTM0TlJoTHJHbyt6R1lWeHVFOGVBbVB5S2s3aEhaYlIvL3NJUzlIYWRo?=
 =?utf-8?B?a29FNy9nT1hDekFRd2xpYVJyQkk0THpRRnNxRDUxakhYUUdaOWV2aGxXNmlL?=
 =?utf-8?B?SzVDOERSVWREYVQwVVMyN2hlYmtVcll3ZDV5OUhGcmNGTVpEWE1UTThNcDk4?=
 =?utf-8?B?WEh0eVNOTitwVnBYYk0wcE9pYjl1ZDdESDVtK00rQWtub3pNQVVQYTZCM0w1?=
 =?utf-8?B?Yi9UYzZQVUxjbGtGbGZkV042bDY4Yis5dU9Nbm04MlhFNFI3K0ZuZ29IbFVC?=
 =?utf-8?B?R2dMYXZmYzBlR2pOSit0M1VobERkTUdZaG9sOTJuK2JnUCtzTWtIVmZCUi8w?=
 =?utf-8?B?ZkxCUnB0aVFpUm5zTWNWQ2dKbmV4NGZUcWtMdFhiSUdKY0xISURaZnVoeWVB?=
 =?utf-8?B?VFVmL2cxNXdwVVRQK1AwODQyeFdFKzE2VyswN0x2cmt5NFdDdU5rZHd0Zzcv?=
 =?utf-8?Q?5ZBcsj?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Rm9pZG1ITEI5aERraGUyV3pVSXhzOEExU3hHVXc0cW0rZmVxWjhhWTJ4WWFz?=
 =?utf-8?B?M2NvcVZSL09yTVpESTVEcEpVZXJOTWM2MmxWaS9IRzJKTDJnSEs4Zng2a3BF?=
 =?utf-8?B?RE10NWI5eVJpZi9SSXYrWksyWGxiRVVuRGIyZ3hRRzNsdWYzZHRYc0lNdUNP?=
 =?utf-8?B?MlVKNXZHdXcxcUVSRkxFYWFpSHR4MTFzai80RDZyNVFhdisrQkFVUTBLWktB?=
 =?utf-8?B?N0xSSyt3c0VMdlF1NVgrdEFtNWJQenR0cnhUTTFKdzZzRG5rUmFSZWoxSm9T?=
 =?utf-8?B?YTAySk9vRVFRajdLNUhZLzhyOFRkc3JydFZBYytKU0dmVC9xaHRWc0pVM1Vm?=
 =?utf-8?B?MENwZ1l5cC91RmYycUNkYXJtdDZpbnBpWVA0U1lyYng0a0ZTRVppRkExOHdU?=
 =?utf-8?B?TEdTN0pRLzJGVnZQQ2VnbVhJbHVZcG1na0hMS3RjTzRmV2FpOFowSWJFMmVY?=
 =?utf-8?B?Mi9YQm1mQS9GR250SHdua1hkNVUwQnpGaTBVdCtGQ2FCaDNMak9LOWthNGl4?=
 =?utf-8?B?NmRQMzNIcCsrWGFNQjF0TXMrWll2bkZPTWFVNWJrTHZZN1RGWlJnR1NGZlNx?=
 =?utf-8?B?bDBoWlE2M3pxUVg0VmNwWHN0NzA0K0JNeUlIVUxXbWR1QnNWUzRMQlZYd25T?=
 =?utf-8?B?eGFNd2NLVDJ1RjRNay9mQit3NlU3SGc2WWV6eHVYZDVXc3FLY3hzSHJMUnlR?=
 =?utf-8?B?MG9JVENIOXpOSTdLMzdkRkRJT0NHamt3RXBhNmMvMWl1TlBSMG1FaUY1Ullw?=
 =?utf-8?B?TWt0VXdwU2xoZWJPSDVuV256dUxvN0ZWYkVkTWtDY1JXbCt2M2RXTS9helI4?=
 =?utf-8?B?SXdJN2pHTjc3SWNubS9DNWF4SUp4VjNWdXNua1I3VUtxMjJ1eXdZR2dPaGZC?=
 =?utf-8?B?clAwc0EwRGFpclB5OGVmNWlGRXpPSkhqT1V3WnpVbGRQWlhMamcvaHVxdGlC?=
 =?utf-8?B?QUdvMFh1alAyMmFLajVra0pJcmtxbC9wTXQ0R29vSGFTeTRwYnF5YWRvZEpj?=
 =?utf-8?B?NGROZXFCWVA4ZFlQTHJhYkorSUJqTmQzb1RvUkR4VzVwNHVBTENuekxxZnpX?=
 =?utf-8?B?dWU3NnFiWFJPeFdRZklQZU10OFdQYnVpMXdQQmFsR002YU0zWHNyTmRZaWQv?=
 =?utf-8?B?NzBac1BQd1FMaVJhRFg4dFdmeXZxZDhPTnExdU9wSC9oUllpQ2RLRFo0ZGNs?=
 =?utf-8?B?cER4RktQTnh6NDlVb3NDSzc4WXZMT3FUdUszbVJUWnIzcmdJdDZ2UlpucXdK?=
 =?utf-8?B?RFE2QktsaVdMUkdBNmVWT3JwTVU5a0pHWVowSC9aTHBFb0lmZFhGK1YxZStk?=
 =?utf-8?B?ek13emh4am5hdnF3WGhyUE9VYTVId3pTSEJuelo0SjFJSGVRa1hlTisrSmEz?=
 =?utf-8?B?a1ZyUGhLaXdzRWZDSWFKaFp1MUJaeHowUkxuN1lQMU5wRjRuYWRnRzNOVUxY?=
 =?utf-8?B?SU9hK0VWNXJ5YTZVSUZBbG1QOXZQSkFCazRLRjM2UkQ0THl3cXJHYWQ0UFNt?=
 =?utf-8?B?N1crSTJIVVpnOWFIM20rSkJLTlNMNCsvOTFLZmxFUEI2cTZmVFkzTjhuZkt0?=
 =?utf-8?B?TC9zUUduY1ZONy9kdWNJQnpMZmlBVWQ2aDhCNmNyQ1IvOXRLUGxLRTBJU2lX?=
 =?utf-8?B?WFdRR2hucHp6M1Jzb1JsZ0VVVG5kemxCcTNFcnVKQ2t2M25rT01JZkJsUFdX?=
 =?utf-8?B?OFgvT0lwSm5WWnFvaG90bUhKelN0d3FNUkE5THBnbWtFOXQvLzdPbVZmd3pm?=
 =?utf-8?B?YTIvOTk1VHRhR2lWWE5vWHNOYVVDSUdKZ1QxZ2R6UlZTVm9uN0lPVXRnMzhu?=
 =?utf-8?B?ME9lcitvcVprWS9lRmNzUTJEZmZOVHRKNWE0cm9DR3hRaUJDODZSVHcvc0k0?=
 =?utf-8?B?My9iOWd6SXZJb01wcTJKQUxiWlM5RStuK284d3h2R2JQVWczZWcwSnZrdmRs?=
 =?utf-8?B?U0NyWUdvMFBIUmo3SXZuK0VPZWRrY1V1Y21RZHVmaW5aanNDUjJocmFQZ2VZ?=
 =?utf-8?B?Skgrd0ZlQWtMY2xmM2tpTURpUmZYaTl3YllMdDh2Z0ZsWnlabFp5WVVkNEFC?=
 =?utf-8?B?RW1NV0FraHhxSmk2ZUlVbFZJNVQwSy9ONzNhcTAyeTJaOWR1eW1qc29wK3dH?=
 =?utf-8?Q?m7uIjtevra0IEM3N/Mx/uOnOS?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <21CD90ABB383CF4289A302688D861D5F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2c54a8a-3c18-47d4-0651-08dde624e597
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2025 11:20:30.0983
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F0BBO+kGeEtLK21IvibRem8EuvJk/7Sh4CDTQZ4XuR1E12HPTEHKrF0tZ3ffX9G2EtWW3TOzU5xO5LObxrzwJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5220
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA4LTI3IGF0IDE3OjMwIC0wNzAwLCBTYWdpIFNoYWhhciB3cm90ZToNCj4g
VERYIG1vZHVsZSBwcm90ZWN0cyB0aGUgRU9JLWJpdG1hcCB3aGljaCBwcmV2ZW50cyB0aGUgdXNl
IG9mIGluLWtlcm5lbA0KPiBJL08gQVBJQy4gU2VlIG1vcmUgZGV0YWlscyBpbiB0aGUgb3JpZ2lu
YWwgcGF0Y2ggWzFdDQoJCQkJCQkgICAgICBeDQoJCQkJCQkgICAgICBtaXNzaW5nIGEgcGVyaW9k
DQo+IA0KPiBUaGUgY3VycmVudCBpbXBsZW1lbnRhdGlvbiBhbHJlYWR5IGVuZm9yY2VzIHRoZSB1
c2Ugb2Ygc3BsaXQgaXJxY2hpcCBmb3INCj4gVERYIGJ1dCBpdCBkb2VzIHNvIGF0IHRoZSB2Q1BV
IGNyZWF0aW9uIHRpbWUgd2hpY2ggaXMgZ2VuZXJhbGx5IHRvIGxhdGUNCgkJCQkJCQkJICBeDQoJ
CQkJCQkJCSAgdG9vDQo+IHRvIGZhbGxiYWNrIHRvIHNwbGl0IGlycWNoaXAuDQo+IA0KPiBUaGlz
IHBhdGNoIGZvbGxvd3MgU2VhbidzIHJlY29tbWVuZGF0aW9uIGZyb20gWzJdIGFuZCBhZGRzIGEg
Y2hlY2sgaWYNCj4gSS9PIEFQSUMgaXMgc3VwcG9ydGVkIGZvciB0aGUgVk0gYXQgaXJxY2hpcCBj
cmVhdGlvbiB0aW1lLg0KPiANCj4gWzFdIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvMjAy
NTAyMjIwMTQ3NTcuODk3OTc4LTExLWJpbmJpbi53dUBsaW51eC5pbnRlbC5jb20vDQo+IFsyXSBo
dHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sL2FLM3ZaNUh1S0tlRnV1TTRAZ29vZ2xlLmNvbS8N
Cj4gDQo+IFN1Z2dlc3RlZC1ieTogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5j
b20+DQo+IFJldmlld2VkLWJ5OiBCaW5iaW4gV3UgPGJpbmJpbi53dUBsaW51eC5pbnRlbC5jb20+
DQo+IFJldmlld2VkLWJ5OiBYaWFveWFvIExpIDx4aWFveWFvLmxpQGludGVsLmNvbT4NCj4gU2ln
bmVkLW9mZi1ieTogU2FnaSBTaGFoYXIgPHNhZ2lzQGdvb2dsZS5jb20+DQoNCkFja2VkLWJ5OiBL
YWkgSHVhbmcgPGthaS5odWFuZ0BpbnRlbC5jb20+DQo=

