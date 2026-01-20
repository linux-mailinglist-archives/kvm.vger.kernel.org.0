Return-Path: <kvm+bounces-68554-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 29C23D3C072
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 08:30:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id EA0BD500F68
	for <lists+kvm@lfdr.de>; Tue, 20 Jan 2026 07:11:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C735536CDF8;
	Tue, 20 Jan 2026 07:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MKicF1bK"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D2F2C2363;
	Tue, 20 Jan 2026 07:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768893071; cv=fail; b=JCTA1Ndy5gpGKB8QQL6NwDbmXUv1XwNyLb4frn0XGvEor9NOC6SGszGSUGWlh8YO+p6zJCWUlLGwkhnq33Fs0DL5+ADfl3g/ofaa9oUWf0OV+FUiHzr9hjQn1x+oGEY2Ham3TXSXGT+cGbx2MxO3B2UBrrLifbEv4lrZs3gpeQI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768893071; c=relaxed/simple;
	bh=kZBY/MICjhJMiMRUv7yr5kpxAlYAVf/c84Hr+lYmpHw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TsIiguoIKaQm7pRxpk9VnxURC32TEGtepF/4m9EZUUE2xDgqCiyC3BTfeb8mBwWXel9GilF4rHPJSxxD7ax4P6PNgdx/QNObig8Wgc+LyV4KfosemBAEsOwexXrMv0EzEnmIuysdyXaabzy71Fbzjg22e7Vjc4jcc8a8/wns6ts=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MKicF1bK; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768893066; x=1800429066;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kZBY/MICjhJMiMRUv7yr5kpxAlYAVf/c84Hr+lYmpHw=;
  b=MKicF1bKhmZhL0dHcPQv8+Rw3ksEDgyEeS8JGHCRiOTTmo+zF23cLlUB
   07yo6WTql5iWZr64m8BSozVJXWoVUcmQ4+30SKxz1Qo85c2e963AcTdk3
   u4lV39Jq0jlQQ+N+kyR5A1qk/b5jkN1CkgzpQl+B2Ud8wOH40SNeVKZma
   TRf/l16NjSB0R2CvqbzSuwYQrosq+p1tzAE/e9ghZSLSeb1Z4DXsmitDP
   OLMQuqTQu+yrgMtvqXpGE+K4KxCR+pNSaMZBBE9fGy9nfDjZPKSWS62Ew
   BrMK+Jk9+JtSYoKj9fr60lFYVwUF0xtfbYvNUP730sNRknfpZBYxI2/QS
   w==;
X-CSE-ConnectionGUID: hPjHJq0IT8Ckh0FxNioR3g==
X-CSE-MsgGUID: m70AOhSFQqmXvsaGfMZBhg==
X-IronPort-AV: E=McAfee;i="6800,10657,11676"; a="81203840"
X-IronPort-AV: E=Sophos;i="6.21,240,1763452800"; 
   d="scan'208";a="81203840"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2026 23:11:03 -0800
X-CSE-ConnectionGUID: 9RRxl0CpTuG0puDHOOSDBA==
X-CSE-MsgGUID: 97j76uWNTSGqB9WNIDGB4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,240,1763452800"; 
   d="scan'208";a="205193352"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2026 23:11:03 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 19 Jan 2026 23:11:02 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Mon, 19 Jan 2026 23:11:02 -0800
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.1) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Mon, 19 Jan 2026 23:11:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xcn7Dm5fF+/wi3WfXtAu95AKBbO8pxlfjJ3g/GgQGrzYB75COPjPHWyk+N1kBC2bD3SvpGfjTxXdpLqPnrCHKdqCpSEp4TtdYpFnM5VvzUg0NZwUJJFEpZf1oBmlBIQexeSme8IGpazDIfyyL4vDFX30BgOvBSSvMJGnRfBu+1A879EkGLvH4VTqHT8z55NeUvdtC8buL+4bbYjU8MpOKfEbfaMZAZcEuLbLDOjlnUBiAPbOcC7uP9I5Gb8foOQVUJKPM70HTydQ96wK5gh51ePY6yJ+Wv04aozVOBmqSG1nXronHDbrWjOtOvmHe5kfvimX/X2AQPco7f/d5MEtLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kZBY/MICjhJMiMRUv7yr5kpxAlYAVf/c84Hr+lYmpHw=;
 b=NcG41U1y5Idnsp6H+MVghz+V/2Olepjq5dl8cvTE6MdVlodJ6aozBZd7EgSNlBeilQTkRihYnmOgWMy2RDaSpuuoS03AMswcDSC2PKX86H8xozG4IjwC+JAd6fqsN6g5UyyvGq0NoWbYonmferlQKHSQ0qfjk5ZksUlg+lJCPcgryon+K4hanBQV9UISmHaBLgvXRsALyLXQqVaOptbTj2766WQlY0tZ3tBb7TV10owxFprQvxjL0V5UrEOcEeRK+ZnU+9M11In5lJ/VVLH73S9dCvwKEyWYHSBVwbWHD1hU7UrEdVsJxXRN6xWQv7pgYFb+6Z82YwrXoZtvDangNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CH0PR11MB5521.namprd11.prod.outlook.com (2603:10b6:610:d4::21)
 by SA1PR11MB5900.namprd11.prod.outlook.com (2603:10b6:806:238::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.4; Tue, 20 Jan
 2026 07:11:00 +0000
Received: from CH0PR11MB5521.namprd11.prod.outlook.com
 ([fe80::df20:b825:ae72:5814]) by CH0PR11MB5521.namprd11.prod.outlook.com
 ([fe80::df20:b825:ae72:5814%5]) with mapi id 15.20.9520.011; Tue, 20 Jan 2026
 07:10:59 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Edgecombe, Rick
 P" <rick.p.edgecombe@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Hansen,
 Dave" <dave.hansen@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Wu,
 Binbin" <binbin.wu@intel.com>, "kas@kernel.org" <kas@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Annapurve, Vishal" <vannapurve@google.com>,
	"bp@alien8.de" <bp@alien8.de>, "Gao, Chao" <chao.gao@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v4 12/16] x86/virt/tdx: Add helpers to allow for
 pre-allocating pages
Thread-Topic: [PATCH v4 12/16] x86/virt/tdx: Add helpers to allow for
 pre-allocating pages
Thread-Index: AQHcWoELZBdGy2q3WEmEfimmygwfnLUEV7eAgAE8jQCAAESUgIBVKf6A
Date: Tue, 20 Jan 2026 07:10:59 +0000
Message-ID: <a99ec2d41087c65e6b55ac53af8dc158ec5dc059.camel@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
	 <20251121005125.417831-13-rick.p.edgecombe@intel.com>
	 <7a6f5b4e-ad7b-4ad0-95fd-e1698f9b4e06@linux.intel.com>
	 <af0e05e39229adb814601eb9ce720a0278be3c2f.camel@intel.com>
	 <9dcaa60c-6ffa-4f94-b002-3510110782dd@linux.intel.com>
In-Reply-To: <9dcaa60c-6ffa-4f94-b002-3510110782dd@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH0PR11MB5521:EE_|SA1PR11MB5900:EE_
x-ms-office365-filtering-correlation-id: 2ab92bae-57d5-41c7-91e2-08de57f31066
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?cmVlOG5ZM0s5dFAyWmlwczJMKzh5REVETUtFcngwV2hPK0MyeTdra25CSFg3?=
 =?utf-8?B?NlhLZzUzMlQzWXVYSHRVWnhnWTN3M1NPcElKa3Q3ZVNzKzVhR05mZktQQ2xZ?=
 =?utf-8?B?YWJtek1YZUxxQytha1BJQlhyV2dHZVhEeHNFYjFXeG5MdllGQlZSdi9pOXVi?=
 =?utf-8?B?b2JQR0lLOTNtSmRnY3lhRzNBZ3BVUzJWOUZXZjNTUC9lN1l5RnNzbk9oQVJq?=
 =?utf-8?B?UC8waVhmTmhlS2xPSUpWcXJ3dXM1S004WXpjUkgzZ2g1cVFxZXZ2Rkl4U0Vx?=
 =?utf-8?B?bUVXeWJ1SkNxMTlGSVZ4dmdkWlVkVHJmdTdjUktXVTlCVXUyY1RPbGtOY2NX?=
 =?utf-8?B?TEJBRGhwKzR4S3oxYW1WRWZpYmZGbVpaQloyK3FwbExpNjE0TCtuRmVtLy9z?=
 =?utf-8?B?a1B4Wk1lNjRhMEZ5T0Jxd0o4azBiVkJsY29MUGpBbUJqMFcvYzNEUFd4ZThY?=
 =?utf-8?B?Zkh4akFnUkxxRUZlcll6N0QvSitZMTM4N3QxT05DY1JnUmpCT3BxOW9nKzFY?=
 =?utf-8?B?QWlTS2RXOWdra2VWRm1tQy8zcC8wTGNiaFRBb1BuZlhDWHVVV3BtRkViWjZK?=
 =?utf-8?B?WWtQcno0QlBtd0Q4amRmdU5VNGt4aVBIdytpQW9ubnZYTUtSODA2NXRKaHhX?=
 =?utf-8?B?TTl4YytYTWxLQXd1ZmZNVFQ3Rlh0Nm1qYUJ6eUVhWWIwK1ZxMjZUREdBZFBO?=
 =?utf-8?B?ei9aN3QxWUFvdWdwWDFtcHZvR2llVmJzTGhXcFVIUEhsaVpjSzBrcFh0Wm1E?=
 =?utf-8?B?aFM1TDl5UkZmNUlIemxVZFFrR3I3V0hXWmozUUxHUUk0eWRtTGxLMWpWVXJS?=
 =?utf-8?B?L3VSQzhtSy9nRHM0STczU2ZjSDFmQThFcVhXdTJzbHJYMWZicUVsRExxNUNo?=
 =?utf-8?B?NEovbVZsa2VxQ1VkNVZES3V2QTA2RGZLTkd0ZHVrcHNOVzRxR0VxMnplUmM5?=
 =?utf-8?B?bzZRamJobDE1VlB4bUJqbUxWRWs4K2htSHkvRnREU1N6S0J5amNsZWhKZ3JO?=
 =?utf-8?B?TEFjWnhhR1VrYnBtY1ZlNHJFNGt6Nk5xaDQ3VGEzd283MGdlY3JZUXdTREU1?=
 =?utf-8?B?YUpOMlBPQ0ZoNkgvY0ZldTQ4K2VsU1RVZlY2NHArTUZ3cVV5Rk9qZmJGL09j?=
 =?utf-8?B?dlB3dUlKdW5MU05mWEtTejQvYnplV1hGUWZPN081UDRmRGpTYXNoQ2hxVnlh?=
 =?utf-8?B?ZkRBWitBNjhxNytqeWx5SVZwbXFiWTlza2VwYkJJV3NXVDVWLzZ6MHAwT1BG?=
 =?utf-8?B?U2psZ0hhK3liRUF3SEV1VFhjK29NK3l0a1ZoRUdZaUNpeG1jdkQ4aTh2ak1p?=
 =?utf-8?B?c3Jxa09qaERuZ21kTkw5OXBPVnIxV1dCbWRmczU5K2NnVEg4M1N1enRhRjhz?=
 =?utf-8?B?Yml3R200TzdBdjc5ZXdzbEZ2aTJrcThYRksvYlovbkttemUzd3ZNNUdmZFdX?=
 =?utf-8?B?VjNIbVRYYUdTWHRYWWtSckVJT0s5ckdPeHdpbklqcFFleTRwYUZyNk1CMkt3?=
 =?utf-8?B?MHdEbWxYcEZYOXUzcjNCYko2UldUclpVa0RzQjY1ZHl0a1NSdmxVT2lZclpG?=
 =?utf-8?B?SGpzVFdYSExQL2dUVzJkN3o1MlBQOTRCYWRjdkczNzE2aDFpL3k4azZXKzFZ?=
 =?utf-8?B?TUQyU0xCcC8yUmNsQ2lEeG9pczNGS2NTQk9jVHhsVU1wTXRZeXBET2ZYczdX?=
 =?utf-8?B?MXNQY2prRjRpTzI5WS9ReGt4VHE0VE1ScjhJQVZuY1FxakhGbE5GWlNsVWRa?=
 =?utf-8?B?MjErdVMxRUZwTUVyeVJXWm1Tblp1R0x5KzN2RTRUa25FVUJETFlBUU9Sb3Fh?=
 =?utf-8?B?UlpzVzhKL2ZKSVNDNFF2VGF1UzZxQVcrNXBES2FPdFNCdllOSGp3WDZkeEFK?=
 =?utf-8?B?UjRTajNmeG9BSk94cDFMWVM3S25pR2NNc3lXRVJJM2h4dk9pSFlWQnVnUGFm?=
 =?utf-8?B?UUlXVmhJOXhiYXU1SHlnSkpmcG9ZTkRjWnY5RUdndFBpZ2xGcGR0ZGx3QWdm?=
 =?utf-8?B?VTRJWGFGWTAzRDIwZ0djMEkrUHVJSExzcjBNK0szNHRTY2FQSngzRy91MEx1?=
 =?utf-8?B?aXJra2liL2FCMnNFS1BQZlZnenVYNkxIeGkxbXJVUk1DNlp5S0U0cDdBZkNu?=
 =?utf-8?B?ZFlyWTNRaGl2bStRNzFsTC9QRFlFaDhPZUkyNDJOYWd1KzNCU0MrL3lSYkhm?=
 =?utf-8?Q?ZYeXls6OkI8S1GbDFuwQ/a8=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5521.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OXZVdVlSb3pqTk9YM1VqVnVDMkkxU200WERvZXBnaGsxRlhyMU5DRTF1TmR2?=
 =?utf-8?B?VEx3OGlDaGR6L1dSUGtjN0doMGVCakdsOEhtTXhHTzVoWDF6QlJrL2hzNzEy?=
 =?utf-8?B?WElUVzYzNTdHR0RYUzZJL2lHenZLZFl4UVhpdzMwQlFTS3NJeTlJUEZaWlNx?=
 =?utf-8?B?NkEyWnJxM0VqTUV1UHlVYzVIcnZwWDlYS1IycEdjTWVGaDVCYUtxeG9Jbks2?=
 =?utf-8?B?Tng4cXlYMEh2OGViQWQ2RmtCQk0zTWJUem54aHVoU2RrMjFadWIvbGZhNFFy?=
 =?utf-8?B?MkkyOGZSdmxzVzRaazl0RXpjYWE4NGx3dlROQ0RWL0FQNkNOa0V5dVh2K0U0?=
 =?utf-8?B?V2ZwbmxPbWQ0S2VTcFlvdElMVGw0ZkFWeDR1QlAzRGZXWDFNRzJqRFE1eHR1?=
 =?utf-8?B?bkNjVWxsZnpHM25EVTFibVIxUDhGaVRNTGtaSjI1TnU4REp2VklSVzVSSjQ2?=
 =?utf-8?B?bU1HMDlsOVI5S0M2VDVmYzZ2VnRxQ0piWEFKYmI4QWtBakU3Q0FFalRaejRl?=
 =?utf-8?B?YlJPa3JoRlBKd250OEhaVWh4MzkrV1VQK1dvTzkwa05ZR0JrR1dTOFE2UVRq?=
 =?utf-8?B?TGtRSXJid25yKzNWYUl5RUc4TkFJTXgwck9EYkxHUlFaNzJscTJGMXY4RHdi?=
 =?utf-8?B?YnlWd0ZNOE9GUXVLMHkrTER5VmpsM2F2ZWtDOHpaeEo5dTJ4QVFQU3l2bUZo?=
 =?utf-8?B?aUxXNUxHQU5menBWUy8xU1NLdVpZc3R1UDZmS1VlUTRCR3E5dzRHZnBuN2Iw?=
 =?utf-8?B?ay9taU5waWtGWVVEVGN5cXpkRkgzNFhzUjdFN2d2NmIyZ3U5QlFpdGR4YzlK?=
 =?utf-8?B?M3lmdWRxRE1YTnRWOU5LTVRaMGNmNGg1NG5Ed0FYa2ZjcjVOaWFWWTN3QjF5?=
 =?utf-8?B?OXN3ZExOZkJ3OUFIbGs2NUNWYWVpUXhQVnlZbjZia1ZmbHhjT0NnVmo5RXlM?=
 =?utf-8?B?UmcvaUZHYTlsZmZJRjFPK3U3a2tWdWVFZkFTUzcrcWZib2VCNGNYb05KU3lY?=
 =?utf-8?B?aDVpVko4cThrbDNqWmZ6WEVhN2daNHkwVzJVSTlOWk0xRlJadDdGQTlVWHB3?=
 =?utf-8?B?YUNjV1JURHJIV3BBNzRNS0RwSmVaWmVrS2FEaG42UzdhWXJyVEdiMGtTTHU0?=
 =?utf-8?B?b1UzcTVYT3NrQktwamFSSERhUXk5TUdPN3pPbGtickxBZW5OclNIdnBaWVJR?=
 =?utf-8?B?ZFJWQk83bTQwNUJEc2x3d29PbWhZRVVEdy83MUVMRWN6QUpkZFk5U2I0VUJr?=
 =?utf-8?B?MHNVL0FxR2lFV1poRlQ3V2RYRGY0Rmhqazd0QitmK1RkWWRsS2x2WGVVdXY0?=
 =?utf-8?B?TDRwaVVrRUljWVMvLzlsUVRsRWxEaW5sMzc5Z1NrSSt0UXIvSjlVL0FIOXUz?=
 =?utf-8?B?bThzQnBFakJZM0d6blZWbXczSEx5YU9mSFZNYkptU20wRnJyZGgzYUV2RTF5?=
 =?utf-8?B?dDlSWmlqcHlWUzk5K2UwMUNzanB3WVU5Z0dFTkxLZ21jWUJZSkhyOGsxd2tR?=
 =?utf-8?B?aytYUWYrcXhFWExsSHNnS3B4aFpvU1BGeDVPV3JjS3hWL2RHQTdoTTBkQlFr?=
 =?utf-8?B?bXh2V3RIQ2pIRVcxVXVrbkdwQVRvNTN5bGcxU0NaSmwyUEVISmo1OER5VzZZ?=
 =?utf-8?B?aEtmSE5GWDIwc0lYL1ZGa3hmNEZWN0sycDhCUmhCaDgxTXljL05Xem9rUmlJ?=
 =?utf-8?B?RzF3cUNna2t6NUpDeWdGSm9ZREdNUEpscURPeG0vRklaVnAxNjVieGk3QmxF?=
 =?utf-8?B?NWtRa2VMMEJ0Ulo4V085OHMwSGFlckVzMWt3elZtTjRZZ1VBSkE2MUdDQlht?=
 =?utf-8?B?clFuN1RXWjE2d09aWXh4dXlBcmpKczk0d0JUSkxhOHVJRlNUYndvQy83UWMx?=
 =?utf-8?B?ckhQaml5cVZlTUxlSTBQb2h4bFM4K1E2Y3NUOWY4a2o4ZDE0d0hoQ0ZoQ0Rp?=
 =?utf-8?B?VUJab005MFlQRnZrRnBHSVRiMkFuSU5FVjlBZGNtTW51SVF5VHlGd3EzN3Mw?=
 =?utf-8?B?eVY3ZHFkR0pxcy8vcUVQZ2dOdXRxWHZ0VnJtUDZLUXd6d1JMNnpxNVBmSERF?=
 =?utf-8?B?L1BORGlsMXp1aEFBb0k4QXliZWc5VWtPNTEyajhZNHJCUlZWMVE1Vm9vS2tw?=
 =?utf-8?B?YWtaSjBlZDNNREtINUIyNlRDREYxNk96YnZnM20zSDRnK1dTVnBpbG0xeDgy?=
 =?utf-8?B?ZVRMajIzWk1IQWI4NkhDUi9tV1JWR2tDM1NBNEpXelZUeDYvZjl4UjZyWEIy?=
 =?utf-8?B?TTg5Tkp3YTgxZkoxQkpkdFR6aDZVUWpxWkZLdWZUL051UnYvOE5WU1NMMHdy?=
 =?utf-8?B?d2Y3T0pUd0JDNU9rZTE5VkhNbVhVWHBOM2lWaDdNTFFLV0RuRU4wdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F59431DB926150459C6DA86537BAC1D1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5521.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ab92bae-57d5-41c7-91e2-08de57f31066
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2026 07:10:59.6416
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UYEDMdO6nByUy4vhhRIJ7YyzlPTN+SCcqCihPfDwB9Xr1Bo5AYxAuzDifYbiept28QFcL2sQVYkXwrCMoZNOdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5900
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTExLTI3IGF0IDEwOjM4ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+IA0K
PiBPbiAxMS8yNy8yMDI1IDY6MzMgQU0sIEVkZ2Vjb21iZSwgUmljayBQIHdyb3RlOg0KPiA+ID4g
PiAgICAgDQo+ID4gPiA+ICDCoMKgIHN0YXRpYyBpbnQgdGR4X3RvcHVwX2V4dGVybmFsX2ZhdWx0
X2NhY2hlKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSwgdW5zaWduZWQgaW50IGNudCkNCj4gPiA+ID4g
IMKgwqAgew0KPiA+ID4gPiAtCXN0cnVjdCB2Y3B1X3RkeCAqdGR4ID0gdG9fdGR4KHZjcHUpOw0K
PiA+ID4gPiArCXN0cnVjdCB0ZHhfcHJlYWxsb2MgKnByZWFsbG9jID0gJnRvX3RkeCh2Y3B1KS0+
cHJlYWxsb2M7DQo+ID4gPiA+ICsJaW50IG1pbl9mYXVsdF9jYWNoZV9zaXplOw0KPiA+ID4gPiAg
ICAgDQo+ID4gPiA+IC0JcmV0dXJuIGt2bV9tbXVfdG9wdXBfbWVtb3J5X2NhY2hlKCZ0ZHgtPm1t
dV9leHRlcm5hbF9zcHRfY2FjaGUsIGNudCk7DQo+ID4gPiA+ICsJLyogRXh0ZXJuYWwgcGFnZSB0
YWJsZXMgKi8NCj4gPiA+ID4gKwltaW5fZmF1bHRfY2FjaGVfc2l6ZSA9IGNudDsNCj4gPiA+ID4g
KwkvKiBEeW5hbWljIFBBTVQgcGFnZXMgKGlmIGVuYWJsZWQpICovDQo+ID4gPiA+ICsJbWluX2Zh
dWx0X2NhY2hlX3NpemUgKz0gdGR4X2RwYW10X2VudHJ5X3BhZ2VzKCkgKiBQVDY0X1JPT1RfTUFY
X0xFVkVMOw0KPiA+ID4gSXMgdGhlIHZhbHVlIFBUNjRfUk9PVF9NQVhfTEVWRUwgaW50ZW5kZWQs
IHNpbmNlIGR5bmFtaWMgUEFNVCBwYWdlcyBhcmUgb25seQ0KPiA+ID4gbmVlZGVkIGZvciA0S0Ig
bGV2ZWw/DQo+ID4gSSdtIG5vdCBzdXJlIEkgZm9sbG93LiBXZSBuZWVkIERQQU1UIGJhY2tpbmcg
Zm9yIGVhY2ggUy1FUFQgcGFnZSB0YWJsZS4NCj4gT2gsIHJpZ2h0IQ0KPiANCj4gSUlVSUMswqAg
UFQ2NF9ST09UX01BWF9MRVZFTCBpcyBhY3R1YWxseQ0KPiAtIFBUNjRfUk9PVF9NQVhfTEVWRUwg
LSAxIGZvciBTLUVUUCBwYWdlcyBzaW5jZSByb290IHBhZ2UgaXMgbm90IG5lZWRlZC4NCj4gLSAx
IGZvciBURCBwcml2YXRlIG1lbW9yeSBwYWdlDQo+IA0KPiBJdCdzIGJldHRlciB0byBhZGQgYSBj
b21tZW50IGFib3V0IGl0Lg0KPiANCg0KQnV0IHRoZW9yZXRpY2FsbHkgd2UgZG9uJ3QgbmVlZCBh
IHBhaXIgb2YgRFBBTVQgcGFnZXMgZm9yIG9uZSA0SyBTLUVQVA0KcGFnZSAtLSB3ZSBvbmx5IG5l
ZWQgYSBwYWlyIGZvciBhIGVudGlyZSAyTSByYW5nZS4gIElmIHRoZXNlIFMtRVBUIHBhZ2VzDQpp
biB0aGUgZmF1bHQgcGF0aCBhcmUgYWxsb2NhdGVkIGZyb20gdGhlIHNhbWUgMk0gcmFuZ2UsIHdl
IGFyZSBhY3R1YWxseQ0Kb3ZlciBhbGxvY2F0aW5nIERQQU1UIHBhZ2VzLg0KDQpBbmQgQUZBSUNU
IHVuZm9ydHVuYXRlbHkgdGhlcmUncyBubyB3YXkgdG8gcmVzb2x2ZSB0aGlzLCB1bmxlc3Mgd2Ug
dXNlDQp0ZHhfYWxsb2NfcGFnZSgpIGZvciBTLUVQVCBwYWdlcy4NCg==

