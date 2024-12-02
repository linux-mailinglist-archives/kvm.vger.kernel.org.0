Return-Path: <kvm+bounces-32800-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B0F199DF916
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 03:55:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1EBCAB2185E
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 02:55:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B28852AEFB;
	Mon,  2 Dec 2024 02:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fNliz7pp"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA41E46BF;
	Mon,  2 Dec 2024 02:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733108096; cv=fail; b=BpGLpKWdc4ft64mizCH0+zr6nQWUMIX13uoRWQ6PPFUoKhNrJ2dPkQ5RW3EAXd0oiV2oF2EcjQvepnpBge8Wrx/+ycoB4xnasb/FGYgXrYDfmvsRdLgtWW3LXVgtBD84SmDq8Xft20lnOVkTj6ZJgYCX7FaLas6vPv2SYRpnnpU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733108096; c=relaxed/simple;
	bh=HeToAYt9fa8A4uQJdCeNgcVZ4SbQItnEfyvZYJxhT+E=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=twWs8xUGPZfn/nArNmcFiMH9lFj/N1eQIb3e15FOlFWUYWIpZvyb5GltQFvsyOoUPfaFyqVqlJlWlm1q18MWCKlxTHZK0dGSoCT1yBRX1927LX1gfinZ/TY1Ib5ZzXVAwfO1pBRKlfj+38ZxnSXkPnpHuRqWtL3T2YOvYKUtDsQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fNliz7pp; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733108094; x=1764644094;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=HeToAYt9fa8A4uQJdCeNgcVZ4SbQItnEfyvZYJxhT+E=;
  b=fNliz7ppxZ9wqsvJgi1kQu0zkN9CgtybfNHSYKTwZr7Nqh9Wj7BP7KXp
   nRmqVaVKKmtxZjNHg/GaMs7w60EIp9Ee3nCCvZ7WqoHHMMPMIOKexGlT8
   ye1kE50ylGBNNS4zkLuAUVaApKKMwoE1BWmDL6jCRRwqicBym2DIxoyAO
   6NooakPdSYES6El7jouFhQ6YmriSjbxYNatGJ8ccys0BjUyJFvR27A3ar
   QoqiEF0goNNbp0czr8JUe3ngbIw5AoE+1OROX42af7hj/8rOFCu45m01a
   BaXh3kRUHGalIgQOIQBTCnH81CWc+zQjoXfGrVKQxHPHHigBbZvGL9vlB
   A==;
X-CSE-ConnectionGUID: aHuOswJiR0i1ag0GRRRPvg==
X-CSE-MsgGUID: 2l5U99C8QAa31ygvAMdatA==
X-IronPort-AV: E=McAfee;i="6700,10204,11273"; a="43934027"
X-IronPort-AV: E=Sophos;i="6.12,201,1728975600"; 
   d="scan'208";a="43934027"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2024 18:54:54 -0800
X-CSE-ConnectionGUID: 3He6foSoQvi4eWGfDNYFyA==
X-CSE-MsgGUID: dVFgKNiXRHutLIiEDcFGSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,201,1728975600"; 
   d="scan'208";a="97405190"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 01 Dec 2024 18:53:06 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Sun, 1 Dec 2024 18:53:04 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Sun, 1 Dec 2024 18:53:04 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.47) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sun, 1 Dec 2024 18:53:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HyjUWUuuUud1lOyKERdk0zfjEWlAzExbymI+aJ4ZaNn3RKLr0kaGmtxjPtvNlXhjC2Wq8LEo9TsK86/IvR+Etz3NDjI0J/HZL4t+dkg9Mm8neWWtN1xM1RulzOB/8dK1HZ4KuS+TsLm4HC9NNRD2wTXKeHjnRlkWf60ibGAGLYA8DO6yf0ChifuexHCQv8p3r2TKm1A3z/zkIRv03VJcZxrOsVa8Kgi33QfpZ9kZO8enBHny1K9rudWJf6tEUljBOUiA+3U1TuB+qxcuFsY4O/dw89tKebcbI6gLT/ZsdK5XH1+Xg5cv73xlgPSyszLzyJD2wflVUqZejefiWvhZ1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DKFDcaiUb1QaH3Uykl0jtxFJHeMj8YGeloki3wVHHaA=;
 b=Ke6MES0jChmlRUjAYchg1eDX9cXnQBsRgyyomqqkngjQWsv0DRPqOCmTiaNHGjtd55AbY/Nm9qcPMD9RJrq7agkmod0GpSG0yyCFlsgdJgtNPMd7Ij4E5ie8ZDLvfLqsOLcrWXcuJhAsq+sU6sRDlujWpYCW6Pl81ZUcOit0akPwpVO4+RKZ8ECqk0cwxckZsMMPG2urXMF7l67s9+d/pu9C7b1wBaiL8QYuG18h0uYD/HpIWIf6mcaz0KE6zGhznHeWQ0GXCQWPo8BzpOA62zVFNg93/INwTFzlANoVYAp91U3sN6LZA2J2iRyXgZuY2T3xcVeW/bM7MA2vdPuC0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB8665.namprd11.prod.outlook.com (2603:10b6:8:1b8::6) by
 IA0PR11MB7953.namprd11.prod.outlook.com (2603:10b6:208:40d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.17; Mon, 2 Dec
 2024 02:53:02 +0000
Received: from DS0PR11MB8665.namprd11.prod.outlook.com
 ([fe80::8e7e:4f8:f7e4:3955]) by DS0PR11MB8665.namprd11.prod.outlook.com
 ([fe80::8e7e:4f8:f7e4:3955%6]) with mapi id 15.20.8207.017; Mon, 2 Dec 2024
 02:53:01 +0000
Date: Mon, 2 Dec 2024 10:52:48 +0800
From: Chao Gao <chao.gao@intel.com>
To: Adrian Hunter <adrian.hunter@intel.com>
CC: <pbonzini@redhat.com>, <seanjc@google.com>, <kvm@vger.kernel.org>,
	<dave.hansen@linux.intel.com>, <rick.p.edgecombe@intel.com>,
	<kai.huang@intel.com>, <reinette.chatre@intel.com>, <xiaoyao.li@intel.com>,
	<tony.lindgren@linux.intel.com>, <binbin.wu@linux.intel.com>,
	<dmatlack@google.com>, <isaku.yamahata@intel.com>, <nik.borisov@suse.com>,
	<linux-kernel@vger.kernel.org>, <x86@kernel.org>, <yan.y.zhao@intel.com>,
	<weijiang.yang@intel.com>
Subject: Re: [PATCH 4/7] KVM: TDX: restore host xsave state when exit from
 the guest TD
Message-ID: <Z00hAGYg1BQsiHJ5@intel.com>
References: <20241121201448.36170-1-adrian.hunter@intel.com>
 <20241121201448.36170-5-adrian.hunter@intel.com>
 <Z0AbZWd/avwcMoyX@intel.com>
 <a42183ab-a25a-423e-9ef3-947abec20561@intel.com>
 <Z0UwWT9bvmdOZiiq@intel.com>
 <5f4e8e8d-81e8-4cf3-bda1-4858fa1f2fff@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5f4e8e8d-81e8-4cf3-bda1-4858fa1f2fff@intel.com>
X-ClientProxiedBy: SI1PR02CA0032.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::12) To DS0PR11MB8665.namprd11.prod.outlook.com
 (2603:10b6:8:1b8::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB8665:EE_|IA0PR11MB7953:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ad7ab09-4b2a-44b3-0bd3-08dd127c6f07
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?N1RLalp5WjdqOWpxNVZjMDlrWGNHZUc3QjdHY21Icm5oR2QwUGJjRGJ1WDkv?=
 =?utf-8?B?b3MwQTBqU2dFNjFRQ1BKbWFsTE43VGFFMTlxQ3M3Tm04bFBtSHpqSE9GaHJF?=
 =?utf-8?B?TmZrc1laV0JJa3NhOTVLUUhhUE12K3RBa2ZLaGQyTktOMW81ZytDT1phQ2NM?=
 =?utf-8?B?cUFKSFRqMzF1K2RvbmRqOHYrREhqUmpJRWpYdlhKdXB2Z2laWVZxY2RpT1VY?=
 =?utf-8?B?ZHpEaWFvU2s4SUtLZUJCWGhTV3VvZ0ZwSmVhUkJrM0tmWDc1bmdMdnYxZTA1?=
 =?utf-8?B?UXZkbjArTVZkd3VEVURrbGNXTTRrVUc5OEZuZlJoQzYxWHlQbFIwVksxSzB1?=
 =?utf-8?B?NWYvV1R2cHFZMFJKUEE4UjRmbjJmYllmY3pmSndvWE45akY3cDdxVm10Zm9t?=
 =?utf-8?B?cytoL3MvVTNicjBuZDl4Mkd2ZjdGVGxhS3JJWkhQcDdSTkVRRVpucEI3ZmJh?=
 =?utf-8?B?MTR2T1c1SlliSW5CNkU2N3hrek5VTkFKT1M1cGZTZEZpK0N5VUExWGNqVm5T?=
 =?utf-8?B?dW96bGtrdWljUUlDMnhSd2t6RTNjRlhUWExlU01yaithRUxuSnIrOVZWYTJY?=
 =?utf-8?B?TzZjZnJjNXQ3bmlUL1JhSnNCR0IyZWJQZ2tSdytIQkdaUjhIOGt5bEVwNFU3?=
 =?utf-8?B?S0pVUndxREtGMUp1UG8ybWVaYVRPdU5YQU5rN3FrbFNIOXRrWGs4ZGF5RU9u?=
 =?utf-8?B?cERhL1Q5ZlExUmxOZUdDNXNXMzJXRmZwek01aXJmVjROWU5rRUFaM1BBU1lk?=
 =?utf-8?B?ZUpFWnF5c1h3SjVkL0F1dEpXOVZHRnEwTEdCQk5HbUI4dXlTbFZCeDFhU2lH?=
 =?utf-8?B?Z0YzL3dWK3NOTHBmM3dDZjVnNGlHQk56U2hvMkZjRE1VL21YaEprTldjWndz?=
 =?utf-8?B?WHFCUWpKNlBSR3hYamc3dld5MUhWVTIreUZmS2ZhaVY1a1RlR0ZGYW90UlBX?=
 =?utf-8?B?cnJzUFZtcEFaRGVYQWlNSks5SFByUTdGVVhpdWZuQkxsd25NLzRoLy9VVjlD?=
 =?utf-8?B?WkhMVHUveUtOcW84bTJLVmZocmhsQmxoRjB0U2ZJaWdVMExDaEpIdWZnWUd6?=
 =?utf-8?B?QVpQVE1kZTJHZUMwMkxlU1lLY0d6RCs0di92WCtKNE1jbnRaMTlBS1U2Y3Zi?=
 =?utf-8?B?dU1zZmxYeXpaZWNmZW12UThSWURNVnpmSVZ1VEYvbGdQOFljb1BVUlpqU2t5?=
 =?utf-8?B?SGJjMEdQaDc1NVFheHVjTlhwUDViUkRvRG1jQ0Y3cVl4N1NwWmJpdFdJSXV2?=
 =?utf-8?B?NGFBUFpwNkZadkhURjByeTlZSTE1WTF1bDd5V3RHTGxYNXEvZ2g1ZUNlbDli?=
 =?utf-8?B?YkZIVWZGbXk5TXpHaDRnQjNnaGljQVpHanNyRzV4Y09sL1NObExqaUtmamxx?=
 =?utf-8?B?c1g3SUlZc0xUaWJBNlBlMzJNa050Uk96a1ZhK2hLOENqeWJ0aFljL0R4eW5a?=
 =?utf-8?B?ZlpkZFJ5R1Z2T1ZQaDZ2MUFBODRob2F6YTRjUCtMNFQyeTkweFByTVRNcFZ4?=
 =?utf-8?B?d3NGTjhTNEU5QnBwWTg2aWp0WnJESnNQYlJlbDhzZzNqdERhcHV1aVBoaGZt?=
 =?utf-8?B?b0ExLzlXL0pWdmZzbWh4bENGQmhsUTBmZGVJMnRHcE5hS2VuTjZrTDhja3ds?=
 =?utf-8?B?N2tVdEpJWm1XVVRabkZUYzYrc2pwNW1QbWNoMk4zVWErSkJpd2NCSG1xcnRR?=
 =?utf-8?B?dzhaR0wzMERoMDVwUENxVGE5a2diM1pNYThYUS9kQlB6d3RWaXdKek5tU2d2?=
 =?utf-8?B?b2JGZngrUEJiRVBkUnJuc0RTcitxcUVlWmtRYnJKMjFDNVpHNXp1bWs1c2Vo?=
 =?utf-8?B?NmYrSkRSUVdWZlhCMGhiZz09?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB8665.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UE1Ua0k3a0ZVNm95SkdBcitBQkdwLzNVMzRCZVVqdU4yeVJQYUhuTkdxSVlq?=
 =?utf-8?B?cUdLTmVvVCtQY0JJb3E0Qmh1dVlLbzBRVTgvdDlneXQzYlNIa3RXNFcvWG5r?=
 =?utf-8?B?a1RSOXBVMGtqek12QUNSc2dWWlZha3BKSm5TQ2RrN0tzeWxTRnVneVREQllt?=
 =?utf-8?B?dFR6ZW1GcjBzYnBUbjV2TWp2UHIzdDEwVEdRMElFZTc5amkxQlFJUW1MeURS?=
 =?utf-8?B?Y3lRVmovd0xweS9YNzl6T2NxbTMrWVQ5cUFFTW5IbjNsNVF4L005bW8vUStr?=
 =?utf-8?B?dDkwSEFCR2hLKzBYOG11VStYQitqMUZITEtsRktVNHdZMlUzSmROSEhBNVR5?=
 =?utf-8?B?Z05YcFRlU0FkSVM2WkZCN0FvanFLaFFrSFd3c09JbmlSR0xPQTh6QUpMeWFN?=
 =?utf-8?B?NVEybHJCWU9hN3ROM05Pd0NSS0dxZmhaNGpxSnZwRVBnMzlFUUNmdC93bWpD?=
 =?utf-8?B?Q1orUHF4OWpHRDNzTUJYd3JCR2F4Mlk2dTNCSFEzemdlTUl1bTdleXZmOVhB?=
 =?utf-8?B?VzVSOWxQbnY2eWdldllnT2FNM3l3Z1RDU3FWeEpvOTd0dWhjeURYVW1COFJs?=
 =?utf-8?B?clJtZnNMYWFJN2tNSi9UUmEzRU9wVEVNbUxBS2l3d2VneHR4RnRpam1ocC9x?=
 =?utf-8?B?RlJsU0F0RWxZam82Rk00YzJYRUdhY3FrZlFiczdhcnArc0h2RlFFOXJ1OHBo?=
 =?utf-8?B?RC9LL0g2V0NpYTRtOTFYY2ZuRkdyZ1liWmxUVmVycU5HTzJaYWk3VjJ3ajFr?=
 =?utf-8?B?UGJFZ0d0TnVpL1BLWUVlSXJvVndXSzdBaE9QZVFkRjd5L2J5bzV0WXhYQm1R?=
 =?utf-8?B?ZDZOcXY1YjBKcHdEdHo2WjJNSWpBdVZvbmxYeS9zVlBXV25LNEhLT3R1V0dn?=
 =?utf-8?B?U0NPSEwyb085UGVMdDliN1RDZUo3RXFwaTQwbHpIc2twQU1vbXBuMElZZ2ln?=
 =?utf-8?B?UFZacXBPd3UyUkJTOEhSYU9xYldRK2lvNnlXR0ZKK3RmSXVQV3hLT2dMM0d0?=
 =?utf-8?B?UFBYeVgwNm8wZHhBS2pkV0VZNlFJWHhXKzJsVVFLckVFTEtLdmVKeHZON1kv?=
 =?utf-8?B?TXNYcStGQzlzQlM4ODZzQlNWMTV1blNtRlY1MG1CQlBNY0ZsTmJWa1FQeG5O?=
 =?utf-8?B?RnZtOUJaYS8vRDVoSVJ3UHdQQ0ZPb2FLSm5Xc1FmVTY0Z3BhT25pZmJ5c2g1?=
 =?utf-8?B?NHJsUy9CMWROTCtpTjFCenJFVURRcUNoOHRhSXVkdWJDUW9sTStBbDlrL3I4?=
 =?utf-8?B?c1M5Z3FPVlc3SDRuUmREeUtvZWZCUUorYmlWQXZjcUVoMkYzNkdmNjRBMkxP?=
 =?utf-8?B?RWNZOEY2WER6cERoWHZOWVRkT3N2eEJsNVBCNDBKZDVpMFQrSVlmNU5PS1hu?=
 =?utf-8?B?eDhySmlxcmo1ZzFibFc0UFdrUjQ1c0VDWnVPOFI4MkdjUlltb1FHdnJqSUZS?=
 =?utf-8?B?NU04dVRVK0ozd1ZseGkybFBtcVhJVVZvZlRPd1ozQjRNR2p0ek5TbDN5N2F2?=
 =?utf-8?B?b2MxN2NuNmxLV1BRMFlYdk5EdklEQk9ESkVlUUkvelJ3VXVCa1dSV05URlQ4?=
 =?utf-8?B?S0dOZjg4SkpTYzBtWXN5Yml1dXE0cy9obENBOG54TWpZVy8zM1d1N1kwOTJQ?=
 =?utf-8?B?ZHFVUFVMaDFJaWRReEp0NE5NdmN4bXcyb3BsZFRlWWFHb1NzQzRzOERaS0Jt?=
 =?utf-8?B?c0lFZitRSFJQaTRwR3FGVWZxUFF5eVpNRXhQdDh1RDZEdDRyYThBSGsrYXZJ?=
 =?utf-8?B?UlIxeG4vTVFKM1Q0RWRTOG54TkdaT3QzaGFoa3l6ajFoZGdiWDRKMCtKRVBM?=
 =?utf-8?B?Ynp1K0MvNnhJb084eDBTcm12cU5sdWc4aWFKTVd4Q0h4OCtRZTdFNkVFTml5?=
 =?utf-8?B?d0dGRVNtNFJCcy9zbVRzN3Z2U1FXdGdWbXhxTnRSeWVyMWQrQUllbUk5M21I?=
 =?utf-8?B?VFc5MW1xaFJ1NFBvQlFHcVphYWhFWFhWRlVtNXhqRk1CTkYybFZPNzlpL2FE?=
 =?utf-8?B?TjdSaU1lOTllKzlMUWk0Y3NEY21reXp0cU5vRW9sWHE2eWFWcERaczdkYWpK?=
 =?utf-8?B?U1loR1dnOFliQTdoemRBRU5hVFJBWHZYdjN4dXNocmxuWlhyb0xZOWc3czZl?=
 =?utf-8?Q?IvGZuHtfccBhmky9mQae/BlfA?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ad7ab09-4b2a-44b3-0bd3-08dd127c6f07
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB8665.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2024 02:53:01.7534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4IInb6Fqj45FqNVbfozJ/35XzIvN8/jLr9eAmUytdo8FpElEQ4Z7lXQRTIQjdEs6FWbkUZB+NdAQ7tpoj73xbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7953
X-OriginatorOrg: intel.com

>>> /* 
>>> * Before returning from TDH.VP.ENTER, the TDX Module assigns:
>>> *   XCR0 to the TD’s user-mode feature bits of XFAM (bits 7:0, 9)
>>> *   IA32_XSS to the TD's supervisor-mode feature bits of XFAM (bits 8, 16:10)

TILECFG state (bit 17) and TILEDATA state (bit 18) are also user state. Are they
cleared unconditionally?

>>> */
>>> #define TDX_XFAM_XCR0_MASK	(GENMASK(7, 0) | BIT(9))
>>> #define TDX_XFAM_XSS_MASK	(GENMASK(16, 10) | BIT(8))
>>> #define TDX_XFAM_MASK		(TDX_XFAM_XCR0_MASK | TDX_XFAM_XSS_MASK)

