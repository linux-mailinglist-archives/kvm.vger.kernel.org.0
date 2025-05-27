Return-Path: <kvm+bounces-47789-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 618DEAC4EBC
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 14:34:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1D95217AF84
	for <lists+kvm@lfdr.de>; Tue, 27 May 2025 12:34:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 044BE26FDB3;
	Tue, 27 May 2025 12:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PQklDIep"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6420825A350;
	Tue, 27 May 2025 12:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748349255; cv=fail; b=opV//pCnhRonhhxdFKcA7yqN76RLL/20oY7wzmU9rQgEzKovvK3DBqiFCBqEd0v1FPWF+0cuelIKiNfvPFSx/vpGcxMIAPkBSVa3fdiv4ipPz6I8iLWiiSAhoLSdNm7sgZAtJS65sGgRoD9VZk6UuPp+MrfOC1qcqLgQnPIoBzQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748349255; c=relaxed/simple;
	bh=c61g55rR+X559/0iUrr/lrTYGtCMBCBiUXjqIUKS0xs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=r4mGdWa33Cwd9iz3B64Q7+A/RXqs4LlJa/8MECn03vXyOIblaBYjJXJDvReU6zJTFkSJgErPu6hZ3IBPQkocMPESeeOwx1aFokLdRXEFnrsCGQwew85h5g6LcDpSoTX5Mdf0M3skWshToJODUZtKPSUNBCOHOLpBMiQJW3KMZf8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PQklDIep; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748349254; x=1779885254;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=c61g55rR+X559/0iUrr/lrTYGtCMBCBiUXjqIUKS0xs=;
  b=PQklDIepctpsQ/74PGTe2FitiNw5pACm4p2HM7B3fR8PV01YIC2yh6A+
   g9ha/Wn5prVHcOC68o8FoFqAoddUXtzE5pcPDZcNYipvO/MPKvU9gjPjm
   a9IGGm+I92YDni8KLfBzZCQOveYOiJfuXMD/5mpidB418w1aNETsnUY/E
   N7bLaWqspHDJqfffEPhSxxazk2vZ/I9PQQLgtPZ7BVsjXgDKNkld0ct0o
   04FPtTY1KTE4YY3+20M8OJ2MsojpUVpmsmTzX9bpVpBifO0hL7MLhzFdd
   H/+yYn4xyYktQCRYKZAm+yPH0JSASysvCqwDIItyrkVaA9eJN46U/Lf3o
   w==;
X-CSE-ConnectionGUID: RrxMicJKRTmZ/IhSk1Z2SQ==
X-CSE-MsgGUID: 7C7x5Au3Rs65QUyh6RfIwg==
X-IronPort-AV: E=McAfee;i="6700,10204,11446"; a="49588499"
X-IronPort-AV: E=Sophos;i="6.15,318,1739865600"; 
   d="scan'208";a="49588499"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2025 05:34:13 -0700
X-CSE-ConnectionGUID: Gxld24I/TUymfUE6YTxs2g==
X-CSE-MsgGUID: DrPg+yhgS1W9YMr6BsH+RA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,318,1739865600"; 
   d="scan'208";a="143761617"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 May 2025 05:34:12 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 27 May 2025 05:34:12 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 27 May 2025 05:34:12 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (40.107.237.62)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Tue, 27 May 2025 05:34:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VDzoP441LoD2kQmW2OxS5+wBCxGszpCUbMih+fv83nM1YBvLovGWfncgjlOaWIV3yFTLhhN+EaqWUde2SnxZKeTctj0P5dsnG2t4N4l1C2Nui00y8NfllNdyJ4sctjGwMF7fElLs+DFYFlcNyPXWRE8fZWfefB8/aO/FSvMP4OwHjWvI3Bfre0ve/qyow4927PpFSXPd32xMtW1+r/5T+JmY64V+SNzThncqRh3h5GxAo+GE7+y52JCc7IOO4k6jGNllVtjVrpx6eEGXurMXOuLpDYLevrgUtjaua2yMM78Qs5QuANSRmBSUukPejw5sAH7MwLuyAo/AB6VnoKYe6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c61g55rR+X559/0iUrr/lrTYGtCMBCBiUXjqIUKS0xs=;
 b=JLwdbn3isRwJ8RuSyTbXgmMbeSkiIQjypccrV8YvB8FfMZl5j8Q1XTNT5Zd3Ai/4C9kxFe1SKmzsSE58pKTfYBSSCcIALj5Go+ZTAp9KEMFN94/+Z9zChsB5bybrE6WhaJY5C08ObU9PZaqZizsdTeSizaPhBNnqRTuYdCNJx1E/lhukVzzOuCoHTLufvjbMtRxoogEyuQo13W8XwUwQo8ehnxRps8xHzbSscVjIhTzxgktH92F09bV1/XjWXDEmISK2G95UJFy37iSI6NXyeQrUNbmau4y+bOcfbJtRy9K4VINWley4yMEgmpkTFRhce50VTrwbMKVlHrk/dhQIcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SA3PR11MB7609.namprd11.prod.outlook.com (2603:10b6:806:319::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.27; Tue, 27 May
 2025 12:34:07 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8769.025; Tue, 27 May 2025
 12:34:07 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "peterz@infradead.org" <peterz@infradead.org>, "eadavis@qq.com"
	<eadavis@qq.com>
CC: "seanjc@google.com" <seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH next V2] KVM: VMX: use __always_inline for is_td_vcpu and
 is_td
Thread-Topic: [PATCH next V2] KVM: VMX: use __always_inline for is_td_vcpu and
 is_td
Thread-Index: AQHbzuSWB445QzrMV0+LSRpU93DRp7PmUWQAgAAYFIA=
Date: Tue, 27 May 2025 12:34:07 +0000
Message-ID: <5a6187af0c4a73245ae527bc44135d4eb1a9b3c0.camel@intel.com>
References: <58339ba1-d7ac-45dd-9d62-1a023d528f50@linux.intel.com>
	 <tencent_1A767567C83C1137829622362E4A72756F09@qq.com>
	 <20250527110752.GB20019@noisy.programming.kicks-ass.net>
In-Reply-To: <20250527110752.GB20019@noisy.programming.kicks-ass.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.1 (3.56.1-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SA3PR11MB7609:EE_
x-ms-office365-filtering-correlation-id: 9c4928ce-29ff-4f16-4230-08dd9d1ac5e6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?YnB3SERmVjdXMjk5WElWN0F5MnNFSlRqbDhzY2o0S0VqbWNHUjEzU0FBblAw?=
 =?utf-8?B?WG9LOE53T3pwelFvbGtld2YzWXRNVmtLeFNMcG5PSUhDY2hjWEpYSUN6SmZK?=
 =?utf-8?B?Vmt4a2lVUmp5ckpwYkJiY2NsSXMzSDdSdUFuMVllRHFQcUtyWS9qNDBQVHhY?=
 =?utf-8?B?MC9JbHZZbDFXekh3SmJoTHB1YTFidlViQ0R3WWJuQ082cm5YMFZoanI0NDhy?=
 =?utf-8?B?dnhNaDJUOGZRWHJhSldMV2ozSmFQeCtPMWVsQnllRHAzb3RVWk5lRFViS05j?=
 =?utf-8?B?bk01VnIzNGFLNm5JSXpKWkcrTjRZMHN4dXB5dkF3cWlla0doemt6Qkp3cUtM?=
 =?utf-8?B?SVMrMWFkaFIraTREUTBXWVUwdXJzSHJQeFQyQzJDMVhJMEhLQWtHQlIzRWlo?=
 =?utf-8?B?b3M5VER1YzlrQUVXU0FnU2dUZlUvK3h2R243WWZjUWFiQ0hVbGxsRDUvZVhJ?=
 =?utf-8?B?MEVYcUh2UTU3S3hnMUZjRnBoVkdPQTd2WDl1cUFSeENsVGdFSkpJWEpjRzM4?=
 =?utf-8?B?c3g4ejJmRmRuYzdWS21Bb2ZSa09TRzZGZFRjeDc2R2NhekJFcnYvNkp3YWJK?=
 =?utf-8?B?Y2I2SHBtM3pMc0NBTWJ1cVY1UEhkZG9JcTl5VTZCMkpqRmtwd3JrRVpERnJG?=
 =?utf-8?B?RFFoWk9QMEdSUlRudzNGVHc3YWZOSzJMK3NuUk90ckhBVGdGY1c1ZkFtZUlh?=
 =?utf-8?B?YkNKQVByVlc3TkRaVW84TVZCYTdZdWpmd3FEQU5IbGN3UG5aSWNhWjZPZ1FL?=
 =?utf-8?B?WXkvMjA3RGF6U3gyVTBkcmZMMzBReEpleUxyRGhiNmpkeWJZSzJiOFZMWUVk?=
 =?utf-8?B?eUF1aFZzV1E4a2NCb2JXajJkUXh6S3U1TlozaTNvdW5lZ2gxWUVMZDFCZi9y?=
 =?utf-8?B?ZTd3anRPQkx1VXJOcFdaQTk3alcvQXhPRWcxVmNxc0xNa0lPNHk4bmlBZmRv?=
 =?utf-8?B?dVBVdUVKenpxeWhuaDY2bW9DN0tDRXNyWlpuenJOdDVHQkI4QlROZW5kb04v?=
 =?utf-8?B?QUtsdmdXNENZYTNmby9CdTcxTXZKSHhUeVZjOE5SQUxZM09YNnhFV0NNS0Qx?=
 =?utf-8?B?aDJZdXFuUjlYTTJFM1NCNFFYZGFGS2ZxbTNBVS9VNlBiTGFmSm0vaTEyUVlX?=
 =?utf-8?B?S3dPR1FWYmFXUXlzMFEzQnMwUzVVN1UvRHQ1c0NBQ3FaNE1xb2Z6TzFPR0Uw?=
 =?utf-8?B?eUZyVUY0aXZsOTY5NDNGeDZPVFpDT3dSVnRLbmloT3FBMXFBZU1nVzFTamVt?=
 =?utf-8?B?WkJhb083UmRhR2lPQm5jaW9YSGZGUHFxVCtmN0Vtd3ZuRDRYWWN1TlNYRzVi?=
 =?utf-8?B?RThNZXlnV2xnb0ExWml3eW5oSGNNRFU1cyswWnRmdTM0ZDgxL01ST3dNU0pM?=
 =?utf-8?B?d2JFYVVSYWZrRmY4VkRGcm93NlArNUxpbHdNVjEwc3JQMUljdE5mZUhNQkFU?=
 =?utf-8?B?aEl5eDArSWZWdlZyWnFKZkErWSs5MHpoMDhDRXZqQUsxYkx6WHdBSk1hV3J5?=
 =?utf-8?B?YVgvdHVtUUpMOUp4bzh5amhOWm4zSFN5dktoTDBpNStxaDA2Y3l1cVBQMFV2?=
 =?utf-8?B?cGhpejF1VThMT1RtUU9XUVc4bzM3UWZvWUdzYnQ5YWorOHlrZUU1ZFVubGUx?=
 =?utf-8?B?UDJGYkt0dlU0ellROGxFWHFUd3V0ZjdxKzI0eDZTOE9TTU9pRm5FelI5bGZS?=
 =?utf-8?B?RkNZN2JYdzVWeWE0KzJEVjAvTDNhVjIrSVR3UEZIOHk2U3ZjSlpNSmlWd2RY?=
 =?utf-8?B?WVdIMDFoT2tqclFmMHR4UjYycUgyaE5mTVVYdFhQUThNNDUyL2QzWGhCQ092?=
 =?utf-8?B?REJqL3ZCT25iR1ZBSXJOa0hIT0VMV3RjRVhiTnlRV1NhdVZVc1ozVHBtbHJV?=
 =?utf-8?B?OFBKeWNlMkc3UFpFYTlleFVtNVhkT0RVQmx6UVkyd0YwZmtObGdSVm94Nkw3?=
 =?utf-8?Q?pYTSk/W9cdw=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VVdUUUNYQjhVKy9wVDZyaVdDa1hzYm5yWWExcThLZTgzdGU0ZGNxZkRGNXVO?=
 =?utf-8?B?U3JBNlpmZlpmbzRnb3ZrMkVMVUlZM1RyUTlnMmI0UWlnWEVHRER3bUJnd1ox?=
 =?utf-8?B?V2dXMTk5eVhsODFmYktrcThrOStaejhTbmpvQ2srMnhqY2xnTjFLZStLRjdG?=
 =?utf-8?B?ZkJKSjJZVUI1OUc1YmYyMkN4THdYM2t5WlowRVZGMlFJbWlwMFM4VFBlSnVq?=
 =?utf-8?B?TzF2V3lZK0dKSzE2VktoTkdwbjQ1Zjd0Q2lESGdGbmZ0Rzd3QnFTM28zRmlR?=
 =?utf-8?B?Q0ExNUNZOStsNytwcUVXSko4OTBQYm00Z2pHTWs5K1BKV0ZIVnRUOC9ibzhv?=
 =?utf-8?B?WkRPMzZoTFdUOFdLYjltTmdhTUVkYWhQTlE4clhBV3IzQVBiRlo1M0hJR1or?=
 =?utf-8?B?V1RVSnBqWkVwNTZCZzA3M0dlMlFvRTQ0em5pK2hFTEw5cy9mQlY2VWdjUzJ2?=
 =?utf-8?B?RTZaNGFOK0lRQUplREd2UGMyZi9Oakx3T3NkNFdiQkNJQVYvUVlvTUxEUWFj?=
 =?utf-8?B?d1NVMTNDejBlWDJkVkpncHlPcTZPKyttRVNWcy9IZWVWT21oczI4RUFYaWRQ?=
 =?utf-8?B?WHVseThaeDVRNCtEMFJ3cmRQaUwyM1pBOGtyd281dWFTLy90ZFdhdTdzKzc0?=
 =?utf-8?B?RnBadi9PdXZHM1Q0WmFmRDJSdysrQWxiSXFldElWRlZVTlIwcnFKdDYwZXlG?=
 =?utf-8?B?ZW5uaFJ1cHhVZkNveTJyRkZ0Z3F3RzhZejNtK281a1c2UWpIY0NqTFZJaTlO?=
 =?utf-8?B?UnlsYXF4akM5NzRRdWVSRWlhcGswdlBoR3A3V1dhYWNDMkVMOENkNFhXL05H?=
 =?utf-8?B?UGRGc1pjaTNtL2t1dlI0VUNESDd0QWNCcFVtYTlwWVRZeW5QSFNnc0ZwSHUr?=
 =?utf-8?B?ODdxeUpsSnZPL0pCVUQrbWZMRVV0MDI2M0tleFM1d1ZEZXVtdG5KRTBrV1FQ?=
 =?utf-8?B?OFNtbXVrMzVEeGFwcUt5Z0w5THFRSDZHZ2RQZEc1NEZ3STRMa0ZSQUNYSEJJ?=
 =?utf-8?B?WlpidUxtTVJRcDlQUUxCekFGSmZSUFJ6NXBBc3VGckxxV1NhWVpxQ2ljSVNs?=
 =?utf-8?B?UUo1NmdyVVRET2NsWnhNaFJSbEQ5NkdwRU5tOExBVkY3WHp3c3IzQVpmTFdI?=
 =?utf-8?B?YldYRUxEbG82U1lJYTVab1NZcFBhNnRnNXNqTkRzSlg3Wm1nQzdtdzlJTmVo?=
 =?utf-8?B?SU9iQUdwVWJCR3ltY0NDWXdmMUVMS09TRS9pWkJQYnZTNGZEK3dXakdXYk9L?=
 =?utf-8?B?dFlMcWZOblY0TEFWQWw1MGFCY2l5eldoL283WDhuMmRNNmsrQzlKajZLSUxw?=
 =?utf-8?B?UDhJdTVVZGxwVEx4QkNUN01GamlUMlNOOXllZUt5TXF1SCtjbGtYbUM2YVpv?=
 =?utf-8?B?dHB6SWdXSzJNbmJkM2pITy9QbHJxR1VVcDJNdUgydGdIY3puUUIvVTQxL1JG?=
 =?utf-8?B?TjY2Nm96elVFaGRqbDFCZDZYWlhYTjU3WVdwdnkrQ0ZQbkxWWkFFaWdhbW9M?=
 =?utf-8?B?NjJOQnpFMTM0Y3V3NVA3U3hLRjc2Rlhtd1VsMXBKU0xpcDV1WEJ5UVZtYTQr?=
 =?utf-8?B?bk45KzBSUnI4L2p3WW9VbVNBRUtEdXFKRzQwVGwvYW5BejMwKzkwUllFeGRW?=
 =?utf-8?B?NFBQT1k5MU9XRmFKZkVDMGVRYzd1S2xpRkQ1T096cWNYbkV5bWxpUHVQNkNQ?=
 =?utf-8?B?SzZqdjVnQk9ESWJKSHBNMENsSVVTdjNGSk1wa1NHZjVYVlBzdTNrZ25yN2dU?=
 =?utf-8?B?bDlxMVVDS3ZVNUQzclErNzE1NWhJTEMrcmZ4aU1DajVFaHlOUDI0dUExSGVn?=
 =?utf-8?B?aVlyV0F0N3RuV3pWelNiVTFqWXhqU1grR3Y4alVtaUxzKzJ4UzUwWTZFYzA0?=
 =?utf-8?B?RFRGa3ZBenB2bFVyYXJxYTNGdnpxMkY2S0tPTkg3aTVDa1lrUklxaVRLWTk0?=
 =?utf-8?B?MWRaeVJjZlN5dW8vL0d3OEZRU1lqaHZmN1NTbFhlSElNUmp2SS9HOGxjN2RW?=
 =?utf-8?B?Z3BVN3R3RlpJT2dCaHYvVHlBaFBSZ0swZGcxRDdXWFVaMnlCU0pETTIrZ1Zs?=
 =?utf-8?B?eEdHZlF3UHE3TEkwQUpBcE04N0hEeVlBRzh6M3AzaDZKcVFYQ0wzYVBCdlFt?=
 =?utf-8?Q?VTtpZw2SBsbjGh8U6whgMnwV+?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C37ABF67BE9B094C842D91B3FFBA29E3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c4928ce-29ff-4f16-4230-08dd9d1ac5e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 May 2025 12:34:07.1102
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: V9E02Yjgr5wyv4RCVbSc1IBudvwD7Tx3BHy2gLRlPxIA1VGugamL57Wfr3oNR6lXqcr3DMHkC6zScj7QquvOqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7609
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA1LTI3IGF0IDEzOjA3ICswMjAwLCBQZXRlciBaaWpsc3RyYSB3cm90ZToN
Cj4gT24gVHVlLCBNYXkgMjcsIDIwMjUgYXQgMDQ6NDQ6MzdQTSArMDgwMCwgRWR3YXJkIEFkYW0g
RGF2aXMgd3JvdGU6DQo+ID4gaXNfdGQoKSBhbmQgaXNfdGRfdmNwdSgpIHJ1biBpbiBubyBpbnN0
cnVtZW50YXRpb24sIHNvIHVzZSBfX2Fsd2F5c19pbmxpbmUNCj4gPiB0byByZXBsYWNlIGlubGlu
ZS4NCj4gPiANCj4gPiBbMV0NCj4gPiB2bWxpbnV4Lm86IGVycm9yOiBvYmp0b29sOiB2bXhfaGFu
ZGxlX25taSsweDQ3Og0KPiA+ICAgICAgICAgY2FsbCB0byBpc190ZF92Y3B1LmlzcmEuMCgpIGxl
YXZlcyAubm9pbnN0ci50ZXh0IHNlY3Rpb24NCj4gPiANCj4gPiBGaXhlczogNzE3MmM3NTNjMjZh
ICgiS1ZNOiBWTVg6IE1vdmUgY29tbW9uIGZpZWxkcyBvZiBzdHJ1Y3QgdmNwdV97dm14LHRkeH0g
dG8gYSBzdHJ1Y3QiKQ0KPiA+IFNpZ25lZC1vZmYtYnk6IEVkd2FyZCBBZGFtIERhdmlzIDxlYWRh
dmlzQHFxLmNvbT4NCj4gPiAtLS0NCj4gPiBWMSAtPiBWMjogdXNpbmcgX19hbHdheXNfaW5saW5l
IHRvIHJlcGxhY2Ugbm9pbnN0cg0KPiA+IA0KPiA+ICBhcmNoL3g4Ni9rdm0vdm14L2NvbW1vbi5o
IHwgNCArKy0tDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDIgZGVsZXRp
b25zKC0pDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS92bXgvY29tbW9uLmgg
Yi9hcmNoL3g4Ni9rdm0vdm14L2NvbW1vbi5oDQo+ID4gaW5kZXggOGY0NmEwNmUyYzQ0Li5hMGM1
ZTg3ODFjMzMgMTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC94ODYva3ZtL3ZteC9jb21tb24uaA0KPiA+
ICsrKyBiL2FyY2gveDg2L2t2bS92bXgvY29tbW9uLmgNCj4gPiBAQCAtNzEsOCArNzEsOCBAQCBz
dGF0aWMgX19hbHdheXNfaW5saW5lIGJvb2wgaXNfdGRfdmNwdShzdHJ1Y3Qga3ZtX3ZjcHUgKnZj
cHUpDQo+ID4gIA0KPiA+ICAjZWxzZQ0KPiA+ICANCj4gPiAtc3RhdGljIGlubGluZSBib29sIGlz
X3RkKHN0cnVjdCBrdm0gKmt2bSkgeyByZXR1cm4gZmFsc2U7IH0NCj4gPiAtc3RhdGljIGlubGlu
ZSBib29sIGlzX3RkX3ZjcHUoc3RydWN0IGt2bV92Y3B1ICp2Y3B1KSB7IHJldHVybiBmYWxzZTsg
fQ0KPiA+ICtzdGF0aWMgX19hbHdheXNfaW5saW5lIGJvb2wgaXNfdGQoc3RydWN0IGt2bSAqa3Zt
KSB7IHJldHVybiBmYWxzZTsgfQ0KPiA+ICtzdGF0aWMgX19hbHdheXNfaW5saW5lIGJvb2wgaXNf
dGRfdmNwdShzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpIHsgcmV0dXJuIGZhbHNlOyB9DQo+ID4gIA0K
PiA+ICAjZW5kaWYNCj4gDQo+IFJpZ2h0OyB0aGlzIGlzIHRoZSAncmlnaHQnIGZpeC4gQWx0aG91
Z2ggdGhlIGJldHRlciBmaXggd291bGQgYmUgZm9yIHRoZQ0KPiBjb21waWxlciB0byBub3QgYmUg
c3R1cGlkIDotKQ0KDQoNCkhpIFBldGVyLA0KDQpKdXN0IG91dCBvZiBjdXJpb3NpdHksIEkgaGF2
ZSBhIHJlbGF0ZWQgcXVlc3Rpb24uDQoNCkkganVzdCBsZWFybmVkIHRoZXJlJ3MgYSAnZmxhdHRl
bicgYXR0cmlidXRlICgnX19mbGF0dGVuJyBpbiBsaW51eCBrZXJuZWwpDQpzdXBwb3J0ZWQgYnkg
Ym90aCBnY2MgYW5kIGNsYW5nLiAgSUlVQyBpdCBmb3JjZXMgYWxsIGZ1bmN0aW9uIGNhbGxzIGlu
c2lkZSBvbmUNCmZ1bmN0aW9uIHRvIGJlIGlubGluZWQgaWYgdGhhdCBmdW5jdGlvbiBpcyBhbm5v
dGF0ZWQgd2l0aCB0aGlzIGF0dHJpYnV0ZS4NCg0KSG93ZXZlciwgaXQgc2VlbXMgZ2NjIGFuZCBj
bGFuZyBoYW5kbGVzICJyZWN1cnNpdmUgaW5saW5pbmciIGRpZmZlcmVudGx5LiAgZ2NjDQpzZWVt
cyBzdXBwb3J0cyByZWN1cnNpdmUgaW5saW5pbmcgd2l0aCBmbGF0dGVuLCBidXQgY2xhbmcgc2Vl
bXMgbm90Lg0KDQpUaGlzIGlzIHRoZSBnY2MgZG9jIFsxXSBzYXlzLCB3aGljaCBleHBsaWNpdGx5
IHRlbGxzIHJlY3Vyc2l2ZSBpbmxpbmluZyBpcw0Kc3VwcG9ydGVkIElJVUM6DQoNCiAgZmxhdHRl
bg0KICANCiAgR2VuZXJhbGx5LCBpbmxpbmluZyBpbnRvIGEgZnVuY3Rpb24gaXMgbGltaXRlZC4g
Rm9yIGEgZnVuY3Rpb24gbWFya2VkIHdpdGggDQogIHRoaXMgYXR0cmlidXRlLCBldmVyeSBjYWxs
IGluc2lkZSB0aGlzIGZ1bmN0aW9uIGlzIGlubGluZWQgaW5jbHVkaW5nIHRoZSBjYWxscw0KICBz
dWNoIGlubGluaW5nIGludHJvZHVjZXMgdG8gdGhlIGZ1bmN0aW9uIChidXQgbm90IHJlY3Vyc2l2
ZSBjYWxscyB0byB0aGUgDQogIGZ1bmN0aW9uIGl0c2VsZiksIGlmIHBvc3NpYmxlLg0KDQpBbmQg
dGhpcyBpcyB0aGUgY2xhbmcgZG9jIFsyXSBzYXlzLCB3aGljaCBkb2Vzbid0IHNheSBhYm91dCBy
ZWN1cnNpdmUgaW5saW5pbmc6DQoNCiAgZmxhdHRlbg0KDQogIFRoZSBmbGF0dGVuIGF0dHJpYnV0
ZSBjYXVzZXMgY2FsbHMgd2l0aGluIHRoZSBhdHRyaWJ1dGVkIGZ1bmN0aW9uIHRvIGJlIA0KICBp
bmxpbmVkIHVubGVzcyBpdCBpcyBpbXBvc3NpYmxlIHRvIGRvIHNvLCBmb3IgZXhhbXBsZSBpZiB0
aGUgYm9keSBvZiB0aGUgDQogIGNhbGxlZSBpcyB1bmF2YWlsYWJsZSBvciBpZiB0aGUgY2FsbGVl
IGhhcyB0aGUgbm9pbmxpbmUgYXR0cmlidXRlLg0KDQpBbHNvLCBvbmUgIkFJIE92ZXJ2aWV3IiBw
cm92aWRlZCBieSBnb29nbGUgYWxzbyBzYXlzIGJlbG93Og0KDQogIENvbXBpbGVyIEJlaGF2aW9y
Og0KICBXaGlsZSBHQ0Mgc3VwcG9ydHMgcmVjdXJzaXZlIGlubGluaW5nIHdpdGggZmxhdHRlbiwg
b3RoZXIgY29tcGlsZXJzIGxpa2UgIA0KICBDbGFuZyBtaWdodCBvbmx5IHBlcmZvcm0gYSBzaW5n
bGUgbGV2ZWwgb2YgaW5saW5pbmcuDQoNCkp1c3Qgd29uZGVyaW5nIHdoZXRoZXIgeW91IGNhbiBo
YXBwZW4gdG8gY29uZmlybSB0aGlzPw0KDQpUaGF0IGFsc28gYmVpbmcgc2FpZCwgaWYgdGhlIF9f
ZmxhdHRlbiBjb3VsZCBhbHdheXMgYmUgInJlY3Vyc2l2ZSBpbmxpbmluZyIsIGl0DQpzZWVtcyB0
byBtZSB0aGF0IF9fZmxhdHRlbiB3b3VsZCBiZSBhIGJldHRlciBhbm5vdGF0aW9uIHdoZW4gd2Ug
d2FudCBzb21lDQpmdW5jdGlvbiB0byBiZSBub2luc3RyLiAgQnV0IGlmIGl0J3MgYmVoYXZpb3Vy
IGlzIGNvbXBpbGVyIGRlcGVuZGVudCwgaXQgc2VlbXMNCml0J3Mgbm90IGEgZ29vZCBpZGVhIHRv
IHVzZSBpdC4NCg0KV2hhdCdzIHlvdXIgb3BpbmlvbiBvbiB0aGlzPw0KDQpbMV06IGh0dHBzOi8v
Z2NjLmdudS5vcmcvb25saW5lZG9jcy9nY2MvQ29tbW9uLUZ1bmN0aW9uLUF0dHJpYnV0ZXMuaHRt
bA0KWzJdOiBodHRwczovL2NsYW5nLmxsdm0ub3JnL2RvY3MvQXR0cmlidXRlUmVmZXJlbmNlLmh0
bWwNCg==

