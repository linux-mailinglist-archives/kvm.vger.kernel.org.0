Return-Path: <kvm+bounces-39584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EB5E1A48176
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 15:35:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 74D423ABD8B
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 14:31:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C848A237702;
	Thu, 27 Feb 2025 14:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hwlUcGLQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F45D23496B;
	Thu, 27 Feb 2025 14:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740666582; cv=fail; b=SOdodwkWvCgrzJ03a9bKcCZcbzxXi2FJCXxIJHQa2VT1AvmYgxujiI23INiJts4RKLopr/kijYhPjEVYYUSF1vfzz4IdTmPo/O3WnVabsXEGDEnIZPMIlbXWhmnB7qYXmNAgd93REqociK5oGagsOx03OdoA1ea7Pw62VpHvsyA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740666582; c=relaxed/simple;
	bh=PhMs0KXK0guk3uxb3JrShEtfGC1SsSPdyKMXoQETDlA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HKSuc56nSdMNzFNLzYRHQT7ozUnn6tbveHnOtPidDOZXGXE/Kl56m09B8djR8114874cfNJsxsZ22CvDD5DZ6HYezp1pWOtbzRJxQ6hGBnftUlE/eXKiKxT0cafr3bv9d/gnzcFRstxfn96fnp/eV8IyvDgkyeG3orNSSdHXF/Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hwlUcGLQ; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740666581; x=1772202581;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=PhMs0KXK0guk3uxb3JrShEtfGC1SsSPdyKMXoQETDlA=;
  b=hwlUcGLQ5GQlMwWIvU1ydMZp+mSJQE3it6WEk2sGgrjgPFcdmf36UASY
   eIEJBxufyd+v+kNWJ/dM5a2KomQpXwJ+Mnag4///JImC/9txYd5M2Zab5
   +t4YWR81Tz3CoRZ3aW4z/SKrXsxb4oKURzhScdWQyVtKnDcRrZDeiwoqB
   Picy9v4RXz3wmezSMLIt8QH28iI2QVDuY57keI0RduEOKPkg7haGndYl+
   SlQ66BglxE10gbC/MJwr7rikX2pxaOqNYOPIK9GkLtLYhxBR74ZebDGsx
   kBVG2tn2I+tUvUbQLYqL4R0Ft/EF9BqRHm2SXGV4WO8HkZPO32xPuTKcy
   w==;
X-CSE-ConnectionGUID: j2l4AXEsT0e7eTR8f8TVng==
X-CSE-MsgGUID: MorF6dfgSfGx0lU3umt6+Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11358"; a="40733880"
X-IronPort-AV: E=Sophos;i="6.13,319,1732608000"; 
   d="scan'208";a="40733880"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2025 06:29:41 -0800
X-CSE-ConnectionGUID: IRURFL1eS+qZ0vUklDdd7A==
X-CSE-MsgGUID: DTwalpK3RFe+LpjZLQdgLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="116908854"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2025 06:29:40 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 27 Feb 2025 06:29:39 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 27 Feb 2025 06:29:39 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 27 Feb 2025 06:29:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k1Uj+FPdnZ1kee7RS3UJ4t4jpqDpDLBekX52QWPssVayAKTjpZLFFOLlOMgJg50ls/mfHe4WPa6/ka1tOkCHOFqoGeqHC+vcX7BnyOLHTJN8uDGHtCruTmeJgIq1OAZKg84Zy4JUFqmg0A9veNR6JFyc8dEGZ8GB2OKScEDDv5UysCV8jMcnvEaoP0jODvHjKbay6Xyd+/vOx6eD3A+wG0zceeQ0C+uEEXkcVgEXZ6wV29SKbNo4oy/MMlHp78wCr5WD44y7t91J/lNFkc0+FqLr09xPJTdRdt9R35WFpbsb0xsCHEAP/2lXyV3Rb0gq3U9NBi+NN+ER038FRwztcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=52jQdDA87hWObYAMr7A10tmDG3uuKGQZmSakAtGiHM4=;
 b=QOzyuyaFsZmcdTfcriEbuU+iqKpV7zvHM70d3gt4GbNQAL1isH9lF3oWS0x4RHbN46MCjBtCcx4B+djRfSYxuPanV7bPmI+BkuOvDUik0jZxfAUNkRw+ypoVgW8zPR1M1V7JUDjBSIFFHfWTLHxwwjsGKJwR7hz1vx2d2CGRb2FAQPQrZLR9na5Q+kovkmtx6cqM2bXaZt5Dw/vGc1yWagtOzGacF1u7KqqW4AWmWqF8FM+XM4/RA9Z/aQp1ZJuDZTh87NK2QHcJh40qhPYplTGzf39nk0d2u41gv4wSJA4yoPdIML1VA1oNiRkYvFQB+mEBI7icG0FKqTIi07vUdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3605.namprd11.prod.outlook.com (2603:10b6:a03:f5::33)
 by PH0PR11MB7635.namprd11.prod.outlook.com (2603:10b6:510:28e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8489.22; Thu, 27 Feb
 2025 14:29:23 +0000
Received: from BYAPR11MB3605.namprd11.prod.outlook.com
 ([fe80::1c0:cc01:1bf0:fb89]) by BYAPR11MB3605.namprd11.prod.outlook.com
 ([fe80::1c0:cc01:1bf0:fb89%4]) with mapi id 15.20.8489.019; Thu, 27 Feb 2025
 14:29:23 +0000
Message-ID: <bac63116-916f-46f8-ae5b-945b43d181bc@intel.com>
Date: Thu, 27 Feb 2025 16:29:13 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 07/12] KVM: TDX: restore host xsave state when exit
 from the guest TD
To: Xiaoyao Li <xiaoyao.li@intel.com>, <pbonzini@redhat.com>,
	<seanjc@google.com>
CC: <kvm@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
	<kai.huang@intel.com>, <reinette.chatre@intel.com>,
	<tony.lindgren@linux.intel.com>, <binbin.wu@linux.intel.com>,
	<dmatlack@google.com>, <isaku.yamahata@intel.com>, <nik.borisov@suse.com>,
	<linux-kernel@vger.kernel.org>, <yan.y.zhao@intel.com>, <chao.gao@intel.com>,
	<weijiang.yang@intel.com>
References: <20250129095902.16391-1-adrian.hunter@intel.com>
 <20250129095902.16391-8-adrian.hunter@intel.com>
 <5cbb181c-f226-4d50-8b92-04775e8b65e0@intel.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <5cbb181c-f226-4d50-8b92-04775e8b65e0@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MRXP264CA0021.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:15::33) To BYAPR11MB3605.namprd11.prod.outlook.com
 (2603:10b6:a03:f5::33)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3605:EE_|PH0PR11MB7635:EE_
X-MS-Office365-Filtering-Correlation-Id: d355b296-8ea6-45d4-27e2-08dd573b2188
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Q1pCcE93NlRKejdqWHRQT2xuNEpxUEQ4VjR4Kys0VVFUeTV0UklJSEpxRjZO?=
 =?utf-8?B?MmdIaHFIUXVNVXB2VVZKdWhQdENDandvVm9TY2k5aUNsYUVSWnE0aFZSZ1gr?=
 =?utf-8?B?N3RXM0pHck9ZaTkxQUxRSy80RkdLaGxRQUNxOTFlS3hFRkhHTWVhaXJHNWdY?=
 =?utf-8?B?YXNDYTBVYVRLcmhidWpNU3BCcjNsMXdsWE1HazVhekxhZk0xSmMzR2hTSGRy?=
 =?utf-8?B?bno2SThOdlZPeUFtSU9vWFduMmJ1UmJ6ZXpkM1VmeDFVY2NURXhmZEplMmY0?=
 =?utf-8?B?WHpTcWJValFNTjFnbGp0RWNXNTdZWitnQjJnSFBtNG9kZzc5ZDczSmZPM1NH?=
 =?utf-8?B?VmFrTUNvQUt4RWh0dTFWdXM3QnI3czc2MmtPbGF0MUViYzNlNDlxMWI2bGhE?=
 =?utf-8?B?Si8rUkowRy9OMjEyRWswVEV5K01UM2tMQngydWU4NWFsKzdheEJ1aHdRbFkw?=
 =?utf-8?B?bnlGTjEyTnhKUjg0elRJeUxZc3MvOWpBUmN2TnBVdnlwZWlBRGZMZlNvS1ho?=
 =?utf-8?B?cmhKTDFVNzc2Sjl2U0FDR1JLa1hzQUVMMklyNzQ4ZEhxZHNwQ1FWU3VBZERn?=
 =?utf-8?B?bGJ3VlF0a2kyMUFwS0p2bmFuWXg5eFJiTEovakc4WDdvbnUwWDVvV0Z4ek1k?=
 =?utf-8?B?MGE1N1p6K29jS085MFRJeTVUdCttWkl4MUYvZ3pmTG1xU1gvUkp2MEczUnJ1?=
 =?utf-8?B?R253aUNEd0c4YXlmZUl2ZVFOb3JITDF2a1g3VkhDZGIvSG54aUt1ZmFpS0xE?=
 =?utf-8?B?RFoyTVQzWExjUkR5UG03MWZaalRJMm1jU2F5UmtzVHlwWjhJbituZlpnRm5L?=
 =?utf-8?B?Nzd6VU1aT2ZGWUJSQU5kWDBrOEE5czJraVpMNXoxNytWeDZKNVdpcXBIL0FM?=
 =?utf-8?B?bUN1bmVYejdTRUk4TkJtTVJLUVAwSmd6TFF3QzdXZ3k2b3l6VHZJRHBmVGIy?=
 =?utf-8?B?NXVSekQrRW1jR0ZVaVZjcUxwajBNZkJiRGJaWmVzVFF1T2x2N0dOalVGR09Q?=
 =?utf-8?B?VExBQ3JSaWF0ZENSZy9QbEFrUklaaklhdjBkelUrcVM4dURoRzE5QTl0QW9R?=
 =?utf-8?B?L3FQVGwxMWE1SGFPVmlhT1VuNFZ5eXFOdTZVdGd4M0Y2bDMzV3ozdVZ6MGty?=
 =?utf-8?B?azVuempwQlc4Q3V0OVJoYlBFU05salVUY2JmMi9pZWFHTnhMQm53SmJqOUZC?=
 =?utf-8?B?VVVkUytjWXRZa3RpSjdSUVBtcTdyMGFQdnUvTEFYS1c4L0hIdUFkY3JQeW5Y?=
 =?utf-8?B?RkhwS3RzU2FmN3RUVld2UG5DUEJ0bWFSM3IwUmN6Wk1MQlhsbFlKZEd5QkhV?=
 =?utf-8?B?dmVKc0d2cHB5aS91dHV4VHR5UGJ0MmM5WGZVNXVYYzVzSnNlbE54Tm05cVNU?=
 =?utf-8?B?VVowUFlHTWFmYzZDc09XaUd1Tk10alZ4bzhzODdCNExWempRTmc3UmR1RHZ4?=
 =?utf-8?B?Zk9henhEYjUyTm00SVVaNFRJSTJsajJVR005K0xkWnd6dFgvWjFFc0xPWWhG?=
 =?utf-8?B?bXJuSjRnVVRiMUM2QUM3UXBDYlIrTUJYdU0vbGtQMWlJbTFTTzdVc2NsbHY4?=
 =?utf-8?B?b0NyRjZSZnNvWitoczlhVFQ2REtZT21jRGt3Z3hvbjlXMHhBNXpUeExFbk9p?=
 =?utf-8?B?ckt4UUhva1plSFc1UG8zMGNLZnlVSk9iZ0luRXE4elZ6ZWNwYVFtdDBISGZQ?=
 =?utf-8?B?R0J1bGo4alNPVXM5L3p4Nllxd3ZBQi9Nek55VGRLM1RXa3ZabmZYajNQTVR1?=
 =?utf-8?B?K3RjMlkyVWlxZHZrZS9LM3hUYUVCQktka0JzdWQ4Z3lrbXF1L0ZZVGZ1Ky9C?=
 =?utf-8?B?dnZKUnRLWlBsNDBOSHl5V0swWGJBa0crMVRYMEM5N2hScGIySVhyT3ZCUDIr?=
 =?utf-8?Q?+e869mzFmjwCn?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3605.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WkxNdmpPcTNna3oycnJJTGVvMmVXc1FTN1BjQ3dra1MvMHFBUjFMckk4ejNt?=
 =?utf-8?B?cG5tN0pYclFwNDF5eUQxTGszTjRLdXRUZjRPSWhvYmJidkIzUnE5SjMrbmlx?=
 =?utf-8?B?M1BxOUpoREJPZkpDME04eDE0aFJHa1BURmxqN3ZCL2J1bnl0MzV5SHAvVmtn?=
 =?utf-8?B?Z3JieDFnUGJqNDMveElFY004Tk9LcGFucW5XSjJ1NGF3T1RBZDJyY2JlMW5q?=
 =?utf-8?B?QkRxSWYvZjlqTm84bW9ONUg0Vk5lUmpLR0tvelNRK3ZKa0YxZnRadmV3QUpG?=
 =?utf-8?B?ckthUzU0S2FLdFdFM1BYWENiTE9oVC9oTEY5bGlIZ2dIclNhZW04NXpJL0FH?=
 =?utf-8?B?WG1SU1NteVBvOTQzV2Z6U25ZN21IZGFDblRiRjNUdHhxTVpaY2N6SC9WcStU?=
 =?utf-8?B?aWNRMUl0NDJhdDZVblMwVEY5eTEyUjdKNlFNTTJiZVY2ME9uU3hZbHBpUjZi?=
 =?utf-8?B?OUgxYis5MkJqUXQ2Z0djc1lvRHkrQ2pHN2xtSXJ1ME9Qa2NKYXI4SXJmUHZ6?=
 =?utf-8?B?b3RDSTQ3RkVtcy80SjBIMFU2c3Izb2o0VTJZRm5xTThORm4rci9leXRGV1BN?=
 =?utf-8?B?VVFjOTA5WS9XQ1FOcGRKNjVyOEs1Y2liZ09CSjg5ZFI3eGhnb0VqL1piYk9E?=
 =?utf-8?B?dkp4SVM4UkN0a1V2MmVTdDFNVGwvNlQydXpEMUZPOEtQSFk2ejlRQmJHeisv?=
 =?utf-8?B?WlplRElocFdIQ2txVHhPM1lsOTFWR1RNbXcrM29DVDFrOG1PYy9sMmR3K2Rt?=
 =?utf-8?B?WExROWRnVHdRanYvSkI5YmVjcUtiTFY3SEJMOUNTWWg5d0t4ckRqaXVRblMx?=
 =?utf-8?B?dzFoMG9RSmNFeTFhSUllTmovRFQ1Z3JwMjJkUUpkWmJlaDh1UEJwR0c3Tk1D?=
 =?utf-8?B?bzdBd0VoQUlrS2VqREh6eGtWNlVuREVhN3RaZ2FiQndEK1M1cW1RYS9YWkdn?=
 =?utf-8?B?UzcxbkVZc1pSZ2VCTU9YM1NjbC8valQ2SmlGcDJEVkh1S1FsN1o4K0ZFdGY3?=
 =?utf-8?B?dFZuV093aUdsTmRWM1lEbm5nSFZVSmpxSlJnSVNERVg5NG41TlFkb2h0QlZ0?=
 =?utf-8?B?SDFVWlBIYmlVUlYwZXF1WG5YZ1FnblNwOFlWLzZLdm0zbmdaQW1ialltWmNN?=
 =?utf-8?B?WTlkWVBvbEhFK01oZHdjU3ZyS2JQR2RSK1UyUmJnVVBMdURLZXdnSWVxeTF6?=
 =?utf-8?B?R1J5Y2pmeWhLaVpVZERSVUtHVFBqbTh1c0Y5UTFrcllEZU01SmgxY0ZqdVI3?=
 =?utf-8?B?aDhST2JVdWx1eGZJTW9sbWZrWjhFREl6WUpqODZOMWl5c0NnOXFSYkVMVjJY?=
 =?utf-8?B?VlZGYmVjenVwNzE5WDNSb3VQamo5QzFCVFRuQmF6SlpOWUlBQnVFcENqM2k4?=
 =?utf-8?B?TEZnSjJOQ0lLeUhQbEFiMGlyVTFtTyt6U0V6eDdFVTQralBib2Q1U29jL2pF?=
 =?utf-8?B?S2F0VjZzTTlMaExhMVdxWWFybENRMEFwcGRidDgwVHkvMmNtOE0xaE5UZHNu?=
 =?utf-8?B?dmIvT1ZVRnRjT2djdnZyUS9oQzF4RCttYUlNQUhGMFc4VFpjVUpaYk9QaUpt?=
 =?utf-8?B?aUtETTIvY0lFbHFXcjNrS2loeVQ4bjVEcEtxMjRDOFNUeDd2LzkzU1ZURE10?=
 =?utf-8?B?NFhkZGVqallGQzFnM1pXdmI5RnNWUC9BWm5tVGs0eUhaN3M5bGdOYkFyeExT?=
 =?utf-8?B?Ym9LQmhaQXVrL0ptb085WHNtcFdKOXk0cXJ6ZkFVSzRBUWVuM3BES0lpNERq?=
 =?utf-8?B?Z1lzVVgxeGNmNVRLZjVISDBFQ2FYQkZRMWd2N2V5TFRGZVI1UXVtazhMR3d3?=
 =?utf-8?B?VjNXTWtoUkVTZE10bHM5MkUxeDhnK2R6NG4xckFZUG1IRUxKa1A5cWQ0cWZz?=
 =?utf-8?B?aXNqTFJFcHF5WUlsQy9ubDdOek9tT3lDTmIrbS9lNjUvckJLOWkvU2craWxy?=
 =?utf-8?B?ZG9LK01uMlhaSmZ0d24rVytqaUhDTHhqNzg5cmEwWnBIc1lObjB0N1VDVnIv?=
 =?utf-8?B?MWQ5eVYvSFEwMDh3RC8vYUVQYThJdTBCdjBxSnIzbXBQQVRuQkdDK1JJaUp4?=
 =?utf-8?B?enhIdkdMekN1RHVmak1qaFlvdE02RUdlWGlKUTVPTkFIM1RReEV4SkQ4RUY0?=
 =?utf-8?B?enNmZWg4dTBjZDJHL1Vnc3NyRGs5R0JMMFh6d3N6Z25Gb3dWTXJFMElySVdm?=
 =?utf-8?B?aVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d355b296-8ea6-45d4-27e2-08dd573b2188
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3605.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2025 14:29:23.6910
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IaQPmLSuEeGCMBERfQxUAZ8j7dqVw6LODgiqVaINLBBtWfMPMrwDTBhJNQ3N8uIHee1ZzWwf6B3kYq6c6x5ErQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7635
X-OriginatorOrg: intel.com

On 25/02/25 08:43, Xiaoyao Li wrote:
> On 1/29/2025 5:58 PM, Adrian Hunter wrote:
>> From: Isaku Yamahata <isaku.yamahata@intel.com>
>>
>> On exiting from the guest TD, xsave state is clobbered.  Restore xsave
>> state on TD exit.
>>
>> Set up guest state so that existing kvm_load_host_xsave_state() can be
>> used. Do not allow VCPU entry if guest state conflicts with the TD's
>> configuration.
>>
>> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> ---
>> TD vcpu enter/exit v2:
>>   - Drop PT and CET feature flags (Chao)
>>   - Use cpu_feature_enabled() instead of static_cpu_has() (Chao)
>>   - Restore PKRU only if the host value differs from defined
>>     exit value (Chao)
>>   - Use defined masks to separate XFAM bits into XCR0/XSS (Adrian)
>>   - Use existing kvm_load_host_xsave_state() in place of
>>     tdx_restore_host_xsave_state() by defining guest CR4, XCR0, XSS
>>     and PKRU (Sean)
>>   - Do not enter if vital guest state is invalid (Adrian)
>>
>> TD vcpu enter/exit v1:
>>   - Remove noinstr on tdx_vcpu_enter_exit() (Sean)
>>   - Switch to kvm_host struct for xcr0 and xss
>>
>> v19:
>>   - Add EXPORT_SYMBOL_GPL(host_xcr0)
>>
>> v15 -> v16:
>>   - Added CET flag mask
>> ---
>>   arch/x86/kvm/vmx/tdx.c | 72 ++++++++++++++++++++++++++++++++++++++----
>>   1 file changed, 66 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
>> index 3f3d61935a58..e4355553569a 100644
>> --- a/arch/x86/kvm/vmx/tdx.c
>> +++ b/arch/x86/kvm/vmx/tdx.c
>> @@ -83,16 +83,21 @@ static u64 tdx_get_supported_attrs(const struct tdx_sys_info_td_conf *td_conf)
>>       return val;
>>   }
>>   +/*
>> + * Before returning from TDH.VP.ENTER, the TDX Module assigns:
>> + *   XCR0 to the TD’s user-mode feature bits of XFAM (bits 7:0, 9, 18:17)
>> + *   IA32_XSS to the TD's supervisor-mode feature bits of XFAM (bits 8, 16:10)
>> + */
>> +#define TDX_XFAM_XCR0_MASK    (GENMASK(7, 0) | BIT(9) | GENMASK(18, 17))
>> +#define TDX_XFAM_XSS_MASK    (BIT(8) | GENMASK(16, 10))
>> +#define TDX_XFAM_MASK        (TDX_XFAM_XCR0_MASK | TDX_XFAM_XSS_MASK)
> 
> No need to define TDX-specific mask for XFAM. kernel defines XFEATURE_MASK_* and you can define XFEATURE_XCR0_MASK and XFEATURE_XSS_MASK with XFEATURE_MASK_*.

Curently, those masks are being added only when the (host) kernel uses them.

> 
>>   static u64 tdx_get_supported_xfam(const struct tdx_sys_info_td_conf *td_conf)
>>   {
>>       u64 val = kvm_caps.supported_xcr0 | kvm_caps.supported_xss;
>>   -    /*
>> -     * PT and CET can be exposed to TD guest regardless of KVM's XSS, PT
>> -     * and, CET support.
>> -     */
>> -    val |= XFEATURE_MASK_PT | XFEATURE_MASK_CET_USER |
>> -           XFEATURE_MASK_CET_KERNEL;
>> +    /* Ensure features are in the masks */
>> +    val &= TDX_XFAM_MASK;
> 
> It's unncessary.
> 
> kvm_caps.supported_xcr0 | kvm_caps.supported_xss must be the subset of TDX_XFAM_MASK;

The code has changed in kvm-coco-queue.

> 
>>       if ((val & td_conf->xfam_fixed1) != td_conf->xfam_fixed1)
>>           return 0;
>> @@ -724,6 +729,19 @@ int tdx_vcpu_pre_run(struct kvm_vcpu *vcpu)
>>       return 1;
>>   }
>>   +static bool tdx_guest_state_is_invalid(struct kvm_vcpu *vcpu)
>> +{
>> +    struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
>> +
>> +    return vcpu->arch.xcr0 != (kvm_tdx->xfam & TDX_XFAM_XCR0_MASK) ||
>> +           vcpu->arch.ia32_xss != (kvm_tdx->xfam & TDX_XFAM_XSS_MASK) ||
>> +           vcpu->arch.pkru ||
>> +           (cpu_feature_enabled(X86_FEATURE_XSAVE) &&
>> +        !kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE)) ||
>> +           (cpu_feature_enabled(X86_FEATURE_XSAVES) &&
>> +        !guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVES));
> 
> guest_cpu_cap_has() is better to put into the path when userspace configures the vcpu model. So that KVM can return error to userspace earlier before running the vcpu.

The purpose of the function is to protect host state from being
restored incorrectly, which is why it is called before tdx_vcpu_enter_exit().
i.e. it is protecting against unexpected changes to guest state information
that do not match TD configuration.  That is largely because the KVM code base
is quite complex and the consequences of messing up host state are dire.
guest_cpu_cap_has() is very quick, so there is not really any reason
not to use it here.

> 
>> +}> +
>>   static noinstr void tdx_vcpu_enter_exit(struct kvm_vcpu *vcpu)
>>   {
>>       struct vcpu_tdx *tdx = to_tdx(vcpu);
>> @@ -740,6 +758,8 @@ static noinstr void tdx_vcpu_enter_exit(struct kvm_vcpu *vcpu)
>>     fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
>>   {
>> +    struct vcpu_tdx *tdx = to_tdx(vcpu);
>> +
>>       /*
>>        * force_immediate_exit requires vCPU entering for events injection with
>>        * an immediately exit followed. But The TDX module doesn't guarantee
>> @@ -750,10 +770,22 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
>>        */
>>       WARN_ON_ONCE(force_immediate_exit);
>>   +    if (WARN_ON_ONCE(tdx_guest_state_is_invalid(vcpu))) {
>> +        /*
>> +         * Invalid exit_reason becomes KVM_EXIT_INTERNAL_ERROR, refer
>> +         * tdx_handle_exit().
>> +         */
>> +        tdx->vt.exit_reason.full = -1u;
>> +        tdx->vp_enter_ret = -1u;
>> +        return EXIT_FASTPATH_NONE;
>> +    }
>> +
>>       trace_kvm_entry(vcpu, force_immediate_exit);
>>         tdx_vcpu_enter_exit(vcpu);
>>   +    kvm_load_host_xsave_state(vcpu);
>> +
>>       vcpu->arch.regs_avail &= ~TDX_REGS_UNSUPPORTED_SET;
>>         trace_kvm_exit(vcpu, KVM_ISA_VMX);
>> @@ -1878,9 +1910,23 @@ static int tdx_vcpu_get_cpuid(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
>>       return r;
>>   }
>>   +static u64 tdx_guest_cr0(struct kvm_vcpu *vcpu, u64 cr4)
>> +{
>> +    u64 cr0 = ~CR0_RESERVED_BITS;
>> +
>> +    if (cr4 & X86_CR4_CET)
>> +        cr0 |= X86_CR0_WP;
>> +
>> +    cr0 |= X86_CR0_PE | X86_CR0_NE;
>> +    cr0 &= ~(X86_CR0_NW | X86_CR0_CD);
>> +
>> +    return cr0;
>> +}
>> +
>>   static int tdx_vcpu_init(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
>>   {
>>       u64 apic_base;
>> +    struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
>>       struct vcpu_tdx *tdx = to_tdx(vcpu);
>>       int ret;
>>   @@ -1903,6 +1949,20 @@ static int tdx_vcpu_init(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
>>       if (ret)
>>           return ret;
>>   +    vcpu->arch.cr4 = ~vcpu->arch.cr4_guest_rsvd_bits;
> 
> when userspace doesn't configure XFEATURE_MASK_PKRU in XFAM, it seems kvm_load_host_xsave_state() will skip restore host's PKRU value.

That's correct.

> 
> Besides, vcpu->arch.cr4_guest_rsvd_bits depends on KVM_SET_CPUID*, we need enfore the dependency that tdx_vcpu_init() needs to be called after vcpu model is configured.

Sean had some code to freeze the CPU model, hence the subsequent TODO.
refer https://lore.kernel.org/all/Z4FZKOzXIdhLOlU8@google.com/
Anything that matters will be caught by tdx_guest_state_is_invalid().

> 
>> +    vcpu->arch.cr0 = tdx_guest_cr0(vcpu, vcpu->arch.cr4);
>> +    /*
>> +     * On return from VP.ENTER, the TDX Module sets XCR0 and XSS to the
>> +     * maximal values supported by the guest, and zeroes PKRU, so from
>> +     * KVM's perspective, those are the guest's values at all times.
>> +     */
> 
> It's better to also call out that this is only to make kvm_load_host_xsave_state() work for TDX. They don't represent the real guest value.

It is to provide a reasonable value not just for
kvm_load_host_xsave_state().

Note Sean wrote the comment.

This patch set is owned by Paolo now, so it is up to him.

> 
>> +    vcpu->arch.ia32_xss = kvm_tdx->xfam & TDX_XFAM_XSS_MASK;
>> +    vcpu->arch.xcr0 = kvm_tdx->xfam & TDX_XFAM_XCR0_MASK;
>> +    vcpu->arch.pkru = 0;
>> +
>> +    /* TODO: freeze vCPU model before kvm_update_cpuid_runtime() */
>> +    kvm_update_cpuid_runtime(vcpu);
>> +
>>       tdx->state = VCPU_TD_STATE_INITIALIZED;
>>         return 0;
> 


