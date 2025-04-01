Return-Path: <kvm+bounces-42393-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 52273A78156
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 19:21:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D728C3A77E7
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 17:20:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BF6120E703;
	Tue,  1 Apr 2025 17:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EXwt/qe+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9850720AF89;
	Tue,  1 Apr 2025 17:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743528047; cv=fail; b=r9MfGzALXFOcPVK8WyPd6Qb8pqwo/ic0GgBmubgySqWaLXVc0suekbb7HA4d+5dNtFHYGQP0EcEyxCpSsU7umuXT3M8p1b33RcsvL06RIl/KIGUiamQ68t5enCUstkaSt9r3JepzieGo0JclteO5HbC+0f3/J9ODfjefSyJQkYs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743528047; c=relaxed/simple;
	bh=D4On4YwiXVAXZvBsPTRVhe9cyTlJ+VWdHC6s2aKCa3k=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=boFuc8La4xzWeMnAnJsrACZesoERjie2Omh2MegP2L1dghK/hGnhcZ5ohPpmqmsj5t2m7ZX+e0lkI+ASyOB8KqGzVGFCzgu6DIfiHoNU14z9aKiR7lYSWN/Y/DbqpHukSwLXns59ZOIXAY0LQJtLVhHzVCVmE5OJcB9dAJtGAtI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EXwt/qe+; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743528045; x=1775064045;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=D4On4YwiXVAXZvBsPTRVhe9cyTlJ+VWdHC6s2aKCa3k=;
  b=EXwt/qe+ln5bMjAjO8uX/YYX+QrcLXcBv0lAZfD29kq4S07fxw/hpUEB
   3Axqv4BLj6pzTHcxL+M+EH4V0MLsZIJxeiE8dYxY3OkM7Y6kFQ+6CknTK
   kJmGOA8atWNGAj/yakcmLREB+E4+YMJhh8i+ZN8/a0fbekFmM1/lZr4jV
   kRGWTU7nHZrIkj2rlPQLplP0tMoGjyKdpF+upW6MCtqf8Ckt3Kc6coHet
   IG5Ld5I6r/pD+Cnml6ogPgLmBhnBCXusfUCXO/njJ7V9RuY+lq/TeCn1e
   LuQoVt0OF+A6mCYtVeVB7El7iAWx6fBstDe0kWPKfg9FF8YbBtf2SQz5h
   g==;
X-CSE-ConnectionGUID: jmARL7abTueOsWoheU67Jg==
X-CSE-MsgGUID: X8hpi4RvRG+Jvub+mCFb1w==
X-IronPort-AV: E=McAfee;i="6700,10204,11391"; a="67338713"
X-IronPort-AV: E=Sophos;i="6.14,293,1736841600"; 
   d="scan'208";a="67338713"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2025 10:20:45 -0700
X-CSE-ConnectionGUID: muVQe3rCRzi2yRw+xBLp0w==
X-CSE-MsgGUID: TwS7kzHYQPq5qIy0jPL7qQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,293,1736841600"; 
   d="scan'208";a="127268981"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Apr 2025 10:20:44 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 1 Apr 2025 10:20:43 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 1 Apr 2025 10:20:43 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 1 Apr 2025 10:20:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UHizWvq8bYB8ToXETj3LYy6f+Y2lryDl+6DY2erptJDOllkyi3DFpf93KeS5+aGseeNGilsqVVvPwt1Wov26yxDPbnn1zHv6xjiXRPvwYvhmP0zmJrG2f0pMo3O5KvzFPbnbWf26TlCEeRodE5P+pXg86z+IAa+/QkmbrwqBwKIdwivQx3EAT2ML2I30YMUZ+mIMEYLjwi3CUNkGXlQa0LKXhmCEGXtpyU3o0Q1Nq95nY4Bc6sf+mRdOGMK/rCMYDDL7iMvN84F5SOq2C/W8p8BoDCjYUguDmX/5/Gjtzf+lgzKaHVxSy4E6ae3M+otSWPhCd1sla/jmdx19lrDnSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qQTHvvGED6eTSKnSdQrDGzxika6hpebVeyZZ2YCMAh4=;
 b=of05yS6JGq0rvLrj1XMgbIXCMK+iuCjsSOOQmP4GsdJoOBNfz/8aDkiDEsBaYRBVyOGoiqLLdzNfCOLrmymKttBUO7q4r8X9Jmb/8IKZNCUyaCpBwbcJrJTiCAARQKX43gHYBEhBx66Pq/oN/PTn7aazti9Ms526J6Wrb8tzRIgWUtyul31lPIB8l1XbZ07zHzcAgx8yJu6r15nD2Ifo2rI4dQ+NoJuflMpdmagNYMXrTY4o+7FsTh+oq6e4N4jOjMMrazcNiNC/y0oWDZvIqKpMoyR6XFwjOP1Iy3OW30kXAvsTJGOkZrl4cGHJ10gyg2vdnTDY2vZRJJzZgT9SJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) by
 DS0PR11MB8070.namprd11.prod.outlook.com (2603:10b6:8:12d::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8534.50; Tue, 1 Apr 2025 17:20:09 +0000
Received: from DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9]) by DS0PR11MB7925.namprd11.prod.outlook.com
 ([fe80::b1ef:c95b:554d:19c9%6]) with mapi id 15.20.8534.043; Tue, 1 Apr 2025
 17:20:08 +0000
Message-ID: <dc6617e5-2f97-431a-b3bf-6c87203a9301@intel.com>
Date: Tue, 1 Apr 2025 10:20:05 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/8] Introduce CET supervisor state support
To: Chao Gao <chao.gao@intel.com>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <tglx@linutronix.de>,
	<dave.hansen@intel.com>, <seanjc@google.com>, <pbonzini@redhat.com>
CC: <peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>, <bp@alien8.de>,
	<xin3.li@intel.com>, Adamos Ttofari <attofari@amazon.de>, Aruna Ramakrishna
	<aruna.ramakrishna@oracle.com>, Dave Hansen <dave.hansen@linux.intel.com>,
	Eric Biggers <ebiggers@google.com>, "H. Peter Anvin" <hpa@zytor.com>, "Ingo
 Molnar" <mingo@redhat.com>, Li RongQing <lirongqing@baidu.com>, Maxim
 Levitsky <mlevitsk@redhat.com>, Mitchell Levy <levymitchell0@gmail.com>,
	"Samuel Holland" <samuel.holland@sifive.com>, Stanislav Spassov
	<stanspas@amazon.de>, Uros Bizjak <ubizjak@gmail.com>, Vignesh
 Balasubramanian <vigbalas@amd.com>, Zhao Liu <zhao1.liu@intel.com>
References: <20250318153316.1970147-1-chao.gao@intel.com>
Content-Language: en-US
From: "Chang S. Bae" <chang.seok.bae@intel.com>
In-Reply-To: <20250318153316.1970147-1-chao.gao@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BYAPR08CA0020.namprd08.prod.outlook.com
 (2603:10b6:a03:100::33) To DS0PR11MB7925.namprd11.prod.outlook.com
 (2603:10b6:8:f8::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7925:EE_|DS0PR11MB8070:EE_
X-MS-Office365-Filtering-Correlation-Id: ced170c1-c656-48ae-8474-08dd714173cd
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?N2dhNklxd3U1Y1pQQi9yZVg2SVFDd3lzWDVpckU0YWJoVWpob3F2MlhUS3Yv?=
 =?utf-8?B?bVhXSG8xaGYxQVB3NWR5ZldEc3ozemlpSEdBQllSZ3JRNHEvNzhMMWhTd09t?=
 =?utf-8?B?THZDY2tCRVdlOUVnZ01TOWdsSVZFR0hVeVFFa3BMQU5aWGFKUTN6Mlp4bW1z?=
 =?utf-8?B?dTVaSWtDd1RjV2Z2ZGJaajA1QWoyVW1yQlpYMFZhR3JyTjVTMVFnWEdqeXFp?=
 =?utf-8?B?RDN4OFJpY1UzbVJYNzdBbHFhTzFlNEFHM25LTVU3bnE4bFlCUWZVSmZkd1Np?=
 =?utf-8?B?UkFIRlJwbDBwYTBvUFBJQnlhSGJpRHk3Rm81QktlYmZ6b0FXSDQxWFFMeWV4?=
 =?utf-8?B?YXM4a0Nta0pvSm8rbjNSTjduU2J0b1FINTFvZlFkbHJIeUplT2o3d2J2REFN?=
 =?utf-8?B?YnRKb1VHSUptdWNUeXpZMHZEakl5bnZtWmVWSXFnU1VvMlV1dTVFS2NWQUs4?=
 =?utf-8?B?VElFRUJuVGZZUGJXRGlxbWw1bkdsQXN2dWNXbFc4OXhkUG0zTVNaTXJPTCs0?=
 =?utf-8?B?ZWpLblRFTy9jTGtxV0lrM09lV2tZd2ptUUdUMS85b2IyU2RoekdDQThEWEtE?=
 =?utf-8?B?T1RhV1k3NVgyVmVCSFhKcDE1b0pFN3BORlkxNGhxMU1PKzRTR0xQQkVuK1p4?=
 =?utf-8?B?bUxFa1NOLzJPRnMvUDVTZys3RTc3N09qKytIM2UzWUoxLzE0RFJNZTYremtJ?=
 =?utf-8?B?OFhvaFUwTEN3KzB4S1lGRFFYMjJDMk9GaDFmOU9ReGdjenkza2hqQ1pVUFlP?=
 =?utf-8?B?WFhoeXlVVmt3ajFDK1JZY0l5QUlTZ2wrWWkrOWxTeHloMXBlNXVVaEdheVVn?=
 =?utf-8?B?MnEyZWQrS3g0MURJUzRXWVNTUzBhR3I3cUllL3BNNC9PTUlCem9ma3pTT3Rm?=
 =?utf-8?B?ak80VnNrczlDcHROVUtRRm1wS1JIVXVXK2NLUXpuTS9xT3lsRHJyeWVDc3Ny?=
 =?utf-8?B?eHN1ZkhVbkd3WGhabDZsb1pCTU9TWWh5ejRGM1V1ZkhUNGl4UDlQWlB1OGUz?=
 =?utf-8?B?WGczTC9yN0F3dmtFRHhqWlhvaWsvc2JrQUhNUnJUbjNTTHpKcjA5Zytkb0M1?=
 =?utf-8?B?aFhvSEJvQXRMYVBzekFMNzBUM3RQMmNUekVxbDIwcTUweWRud01ML2hzV3pV?=
 =?utf-8?B?SXFsdHNMc2hmbGlwKzNaVlZBTUdiWk5xL3EzWmNNeGx0cmZrYW9sQXVSVEdz?=
 =?utf-8?B?dVgrUGV1NDRJWjdac2EwMTFjL0FpQ2s1OUJlZXczK0tweVg1TE54M2Y0bFlO?=
 =?utf-8?B?WTlCeDFqNGg2cnF0c0xwWTAwbTVpeHBhaFhJL1NIWG5vbTBPOGZ5Yk82dHdL?=
 =?utf-8?B?UkZRcFdIQnl2NmJyVFBQYVBLYWg4dTFRNkJTRHF0S0crVFBXUDJiblNXSzRO?=
 =?utf-8?B?dmpsSW9ydDYvamg1R3FmdmRYZG9Od2tvcHc4a09OSkc2c2xJT2RubUdjU1Ir?=
 =?utf-8?B?b3JsK2VYbHZWamo1M3Y2WlM0akJHWFgwOEg3YzlFckJiUXZBeXkvOWlXeXJu?=
 =?utf-8?B?SUx0SWx2bXFxYVhxMWx5Vi9vQUR0bVZaKytmNnRqcSt2bzk0RXhER0twNUlO?=
 =?utf-8?B?RjJTRjF1Q0hEekN2ellEZFVxMktNWXQ0V0R3WjRmeUJVR3JjY1RFRmNGMDhO?=
 =?utf-8?B?QjBQbHhBK0pTQ3hacVdLbkJRTDMzbmM0eWI1Y3lRZW9zOEt6Y3VKdUR1T3VV?=
 =?utf-8?B?N0dTYWxYaGN4bkp0ckxna21aM1Jyc2EveVpZUkF6dUtvb0FkUkp4ajREcC90?=
 =?utf-8?B?akhLVzZZaVQ1TEowMTFic1ZUNDZJYUl5aE5sRjA2Z0RjZDJyeHN6NXdlc2hm?=
 =?utf-8?B?UkN0dnFCTlBGK1htYzNYQmEwT09HWlBDb0R1Y2hqZ0twVnFPODBKYTNCUkhX?=
 =?utf-8?Q?GWsA6V8RdmE6H?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7925.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?anpoaFpCMWp5ZlNCRTFYdUFFZFJSaHVqUmp0ZnZDaUpmdW9BLy9Ja1RkdVRD?=
 =?utf-8?B?L1BwZ3FvUXc3alI0ZFVUYlhpdGxySTNldE1obGNqREFwS3REK3NHMGNNUlkz?=
 =?utf-8?B?SU4rc2Ixbmo4eWhzM21RdTV1WVQySnY3ZkQyN0J5MmtOem56ZkUvRDh6eG5a?=
 =?utf-8?B?dktyTGVHRXlRQlAxaHp6TDFkdEZTWkI4OTZFQVpzY3prdnArdzFGVXFpcHJn?=
 =?utf-8?B?Z0prRzEvaFB3amQrOFZQRXc5VEIyZElHTG1QUTF6Y0lqL1lhQmtTcGRoYUxS?=
 =?utf-8?B?cE94dENNMlErSG9WS2FYZkxsNHl3akpDQ2FJVDhDRCtVUE91QXArUllzdVhT?=
 =?utf-8?B?MXFCZWtlZHFHVkp4MEJwNXVZTG5LQkk3VnV1NEF5QTRRQnAvV2xjNHdzWjhV?=
 =?utf-8?B?VmVEUkpqMFM3MzBaUjNpakZCRXFjQSs1SHNObC8yWlh2U280UUlGbXVQRlpC?=
 =?utf-8?B?MWN5bThMZWEweVlrSWM2Qm1NclZKUlZqZFArbktIRlllV2NkWitIeHNnZ2th?=
 =?utf-8?B?RjRnbG5IOUJEQU40TGZ4OEpraGJURHRtNW1IaE9sYmVlcUFJMTFkUnVRYW53?=
 =?utf-8?B?czJtT0JYVVVmekcrSUpBcklmL0liSEtWTHRuV0xtL3BycVFFMmNoSVBiZ3Y1?=
 =?utf-8?B?YkU1c0I3WmR3VXA0RjVjajNIa3RIUXBQY2w2M29YS0pselowRFh4b1dzRWVH?=
 =?utf-8?B?dUJnOTQvSUlPR01ObEQ4MlZicDUwTUpVaENPQndWWmV0MlFaTzVNQW5jS3lw?=
 =?utf-8?B?QVIyNURpTFlJUWgyMCtUTEJmbWZ1bDN4NXdtRjNEMnBFZjNvczN1VzROS3Nw?=
 =?utf-8?B?TEtwaWljWlZOUVNaRDhBU214aFA0aUVIekZKS01QK3hTQWZITk90dUxFRHMz?=
 =?utf-8?B?dXdoT3BRL0dVSWNkbVU5VllBMnFIbjJyQkJJUHloTW1LTTlhYWZHTEx3ZjMz?=
 =?utf-8?B?aHVNT2tDeDRhR0R0RGdzbndTMnBTSDJpZHpZeGZIRGF6VGVRWVAzTmZXdENU?=
 =?utf-8?B?dzFUSUUvZVRobWhVVHgzM1RycFppQ0dieGMvdzZaVm1kdmNDclNxcDJyNFB6?=
 =?utf-8?B?M09wUm9VVVVUMXVhdm9qT3ZuaSswdHRLMUV4dEs2ZFlPSlU1VWE1QXRNVS9Y?=
 =?utf-8?B?L1EvTmVIbjRUZnJZY3F4RzFTdThndmlnK3RlNjVHV2x6UGxiZHQ3cmtPaXNi?=
 =?utf-8?B?SmNzb3Y2Tng1TXZJVCtDNVJIcjN4MmVaTlpLdytPUDgxemVLbG5GbTFYWjgy?=
 =?utf-8?B?QVZidnRTZmY4M1ZwT2x5YlBmbFIxNzY3YmZZWEFLam5JZmJrNDdDT0o2WHBC?=
 =?utf-8?B?OXd2QlNaZHpJZFk2bkxTYk1ZNEVqSjRBa3FkUFBSQmYwVzU1K1RyU1gyajJw?=
 =?utf-8?B?YnZBZE1RYjVTWmlnbFZqcTdrVmc5YnMrNkFJY2FxdHN0Y0NqZm9JbUVTZ3l1?=
 =?utf-8?B?eVVPUHV5bWpSRGZCbmFxSjJNUGhoQ0RWMGZ0ZWE1ald4bTFwMG53RG5XdkdG?=
 =?utf-8?B?RnJCenROL242ZWNCSUtNTVhBdzF3Yi9pMzFZQnNIeHlHZ3BBdDFPMmxsOFRE?=
 =?utf-8?B?dXh1cXNzSWpGQTFlQjkvRGVYQy9WTU9jVFQydFlUZnZVZHZPMTB5cWQ3aisr?=
 =?utf-8?B?UzZSVmF6RTEyazUzL0llcEtoQkpTWSsra3paVSsyRDMycDZUSXZCNTZvVlFG?=
 =?utf-8?B?NU0ydjcyWEI0T3dwU0E1N3BvR0Z0TFoyVGtqc2F0UE9QRjkyYkVwaXZtM2pM?=
 =?utf-8?B?WEMybndiZGhidzZvWFh1UTBLQ204aHZjaXBkSkFscG5HL1EyeStxdk83YUJQ?=
 =?utf-8?B?c0tTQWgwb2FYc2UzK1g0bGZ6ejBoYXhmc0p1ZHFJWGo2NDZWa3JuTUk5RGlt?=
 =?utf-8?B?Z1FFd3RMSWRRZ0Q2ZEw0ekNtdDBaaDMrbWNwSEZSaHZ4M09DbVYyc2xCRy8v?=
 =?utf-8?B?Y3dsT2hmRUY3MVQ1ZVFYVEdRQ2pOUzdsWmExckxkS1d4REc2amlMNk1vTlNM?=
 =?utf-8?B?c1Y2K1N4SkJLQVVBcDY5b1dPd3lQeGFnUVh4aWRhUUZsNHRjZHNEQnBMN2pm?=
 =?utf-8?B?MUZEMFdmVjhnV3prdTR1RU9HWmZXUDNScUVuQm1GTVRhL3BTaFlMcXJlbVlU?=
 =?utf-8?B?SW93Mlh5aFVZUEFkMnhGQ3laZWlJdmRZdzR5QnJWdGx3bFZiais1Nnc1SU9F?=
 =?utf-8?B?MWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: ced170c1-c656-48ae-8474-08dd714173cd
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7925.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2025 17:20:08.7859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: isZFXifywSvGNn65zrP7OB5YREdz7MijhY97Z2f44uQnbj7O5xtHMt4Qxiktxc4Ly3EVLs7RsiYZ4SNTQ+TytnyO5YSXX5WREcC5VVm2lTg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8070
X-OriginatorOrg: intel.com

On 3/18/2025 8:31 AM, Chao Gao wrote:
> 
>   arch/x86/include/asm/fpu/types.h  | 58 ++++++++++++++++++++++---------
>   arch/x86/include/asm/fpu/xstate.h |  9 +++--
>   arch/x86/kernel/fpu/core.c        | 36 ++++++++++++-------
>   arch/x86/kernel/fpu/xstate.c      | 42 +++++++++++++++-------
>   arch/x86/kernel/fpu/xstate.h      |  2 ++
>   5 files changed, 102 insertions(+), 45 deletions(-)

Hi Chao Gao,

I've left a few comments on your patches. It looks like the structure of 
your patch set has been shifting between postings. I’d recommend 
reviewing the build-up of changes more carefully — see my reply on patch3.

Additionally, your approach to the ongoing discussion comes across as 
somewhat reserved. Since you’re presenting a counterpoint to the 
maintainer’s suggestion, I’d encourage you to articulate your reasoning 
more clearly (see my comment on patch 7).

Most of other feedback focuses on refining individual changes. 
Specifically, your upcoming modifications to the initialization sequence 
do not look super clear. My suggestions in patch 4 reflect my 
interpretation, but please consider whether there's a clearer way to 
present the new configuration settings.

Thanks,
Chang

