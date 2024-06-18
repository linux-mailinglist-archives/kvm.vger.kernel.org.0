Return-Path: <kvm+bounces-19832-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 23EA790C037
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 02:13:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2B1F61C21B6A
	for <lists+kvm@lfdr.de>; Tue, 18 Jun 2024 00:13:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0673ED53C;
	Tue, 18 Jun 2024 00:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P5nbKwfx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB7F848D;
	Tue, 18 Jun 2024 00:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718669577; cv=fail; b=Rlu5vbxYl27055+8/kKeK7eY6eJDklEwrrIOWFqn6Y9t6JUcXPoiklZ667a0QHisWcrYvNh20wYpdTKnRLeNLKD1Wfs7DfnzY+ra9VfJUstIbIUkoF1mdh3FAI6oU/l4KsPtnqci2HSX/Gh6VCeSlHuvGhkS0pI5L/+KSJJYHeE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718669577; c=relaxed/simple;
	bh=xqmBrB8rUsUKyOQjq5f/6Ma5046AYL1IPEtORKMZWF8=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=DKA4wtiOdMof0IVPsyuxT5kqmbxJ/efBGFvWGykro5FJ4zrD+O82bxmp8ndQbtfoKEoGPmEcWCQaI5aacaT/7EJLLS6yh2sSGD5uis977Qwf0qrWoEgxcihTEAggZ+ZXBzq7ZyFS75hQkyr2dxXWkRXWX7zCO/kOuXEF/zda41c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P5nbKwfx; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718669576; x=1750205576;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xqmBrB8rUsUKyOQjq5f/6Ma5046AYL1IPEtORKMZWF8=;
  b=P5nbKwfxa9f9eDqY2nItQY4iaCS7p1m0t9RN5q9jTeX8xZmEs/yrOxau
   5/b3W6lJLkW4wwfxhhJs+OxMuag5mJgiS351vd+0pGnT+0eBK5Vtkbbi/
   VBVj/1ilr+zwpUHApggosT3RxXUG/YbmA1D8B1pRpZhUwR7uHcjvwrZb0
   Mpv1IN+dqwEy2/v6lTKc3TKpscgp8r7OtVq7v69BHS0IkoMKWgFxihxXw
   R4A3CGRZwflvTmOmWIUOuClJGA5KyRWugMdYH2519q5twcBCDMiZwXhN9
   DKCubfAKGR1mUmlmM36Zt93I9Q5PgKttMcBDQrjH8MYjUOFrOxMDDIust
   Q==;
X-CSE-ConnectionGUID: g/zgtAbOSuK1wqTvBa05yg==
X-CSE-MsgGUID: ppwxuv+DShW5JD5WjylcWg==
X-IronPort-AV: E=McAfee;i="6700,10204,11106"; a="15353622"
X-IronPort-AV: E=Sophos;i="6.08,246,1712646000"; 
   d="scan'208";a="15353622"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2024 17:12:55 -0700
X-CSE-ConnectionGUID: ERdo9jNjTSaZ2gxxxF3Yiw==
X-CSE-MsgGUID: Gjx2npjESxac668TlJboEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,246,1712646000"; 
   d="scan'208";a="72111490"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Jun 2024 17:12:54 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 17 Jun 2024 17:12:54 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 17 Jun 2024 17:12:54 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 17 Jun 2024 17:12:54 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 17 Jun 2024 17:12:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uft0uoIOSRvuAHN+/zrghqQdOHuGL3dOACxLQqc//3PwDqYrioxy8YCwdCvvZAvVbHYG3eYrMOnP7NVYQVKLIK5iJkOhpS0efHutNKCwLbfOrVGFhKQ+OaDg/dIRFvu5U4kYS5Wrm/li7VgNZsrBoBY3DK61iDAtSlndYm9CKtZUGTDTkaOD+6wdKexMsk+b1h2APnE70LhXObO/jy1T++3EyjzlVfchU9vjM3N6GgLrCcVUZ4qvd7pUPgkPbyvigJi6aIHwihEXBVEaYPbYSmFW9Af6kfQx7sD8jlBCh08Kr2IAnTZPy0JvuTMJPY2RFJnubprLH5XFcyAODAyvIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wjQWi8tEA6tbDSoPdI8n42fM31dBYEw/xZCVAtgtvk0=;
 b=VqrCP7hNlRhD/UZgL5C1byZhsY537EUmnQbZvwyLEizwG4CjXwTGvowg28TkilTX/iZ4UnCxkm4ChsvFdBQ9a8cg5y+vGkdurFocKavyygv+VlRrBhE+VCxnE2DF9I8wn3f9WTPdSSvkP7pwZWCytPmfBg9fNsNF/ZZOo7gwX44b8NoHe4oibJxTr0C8U8OPHfjLCvqDnxrJo/9b2OYuRggnM3kxksqMYj94dpDE/MDfPyTLz1YwERQuszeBNuDyWdfGumKnaaaRanlohYZlO1+9oIpINiBkUj2PY0NzDRxFHAN9Yyv6q5S7JcumCUPb+rq6i1AgCOCTE596Sk4jJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CY8PR11MB7797.namprd11.prod.outlook.com (2603:10b6:930:76::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.31; Tue, 18 Jun
 2024 00:12:52 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%5]) with mapi id 15.20.7677.030; Tue, 18 Jun 2024
 00:12:52 +0000
Message-ID: <0c9fd1f7-f866-467b-9e7c-e971f1d22662@intel.com>
Date: Tue, 18 Jun 2024 12:12:41 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 8/9] x86/virt/tdx: Exclude memory region hole within CMR
 as TDMR's reserved area
To: Chao Gao <chao.gao@intel.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>, <dave.hansen@intel.com>,
	<dan.j.williams@intel.com>, <kirill.shutemov@linux.intel.com>,
	<rick.p.edgecombe@intel.com>, <peterz@infradead.org>, <tglx@linutronix.de>,
	<bp@alien8.de>, <mingo@redhat.com>, <hpa@zytor.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <kvm@vger.kernel.org>, <isaku.yamahata@intel.com>,
	<binbin.wu@linux.intel.com>
References: <cover.1718538552.git.kai.huang@intel.com>
 <cfbed1139887416b6fe0d130883dbe210e97d598.1718538552.git.kai.huang@intel.com>
 <ZnAV7krcGEqyHQt2@chao-email>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <ZnAV7krcGEqyHQt2@chao-email>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0097.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::38) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|CY8PR11MB7797:EE_
X-MS-Office365-Filtering-Correlation-Id: 9fbdb10f-b476-4c65-9fff-08dc8f2b64ea
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230037|366013|376011|7416011|1800799021;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TzhZbXIzQXc2cjJFeGt2ZURZNlZPcHlQVDRnanljYUxjOUhDOFJrMkxobzRq?=
 =?utf-8?B?cXRyZE1xRUk5UFI3RUFoeHliaVp6VFVYYStqeWpoUU90QUtJUXNNNTlZSW5o?=
 =?utf-8?B?Sm5ZZ2V0RU02c3dxcXc5UUVxUVdFaGE2alVZTkg2aFB2Tyt4UVFLVFhuQ21M?=
 =?utf-8?B?eCtaRVYxczAvKzU1WGdEQ3dhRFYzbGwyNkdZZ09TaEtBYnhEMUVkbDZwY0hw?=
 =?utf-8?B?d0hvQkZ3clNVKzBuSzh0K0QzUjUvbVhqRzlnMDdwYU5IUmprU1cxTUJpK2Iz?=
 =?utf-8?B?K1ZHNEJqL0pERTVPVEVtZjNpdUowQ2tubTdqRER6bTM3T3k2SitydmJvTE5G?=
 =?utf-8?B?NGFFOU9wNzQwWUFwSWpoSlRpZGlFZUdZa0NPWnBrQWdlN05oc0h6V0JHUE13?=
 =?utf-8?B?UERTQmlNN1J3Z1pFMTBFd01zaVZDYldLVjBTSFhROW94aUJ3eWtIa0VzMGhG?=
 =?utf-8?B?UDlNM3dQRXFvb0ZiSUVWT1RwRzFZNmJjMG9TUXBaYkx0ZkNSWUE4NDFWK1hL?=
 =?utf-8?B?Q2R0YUs3TmNicjRQbmdKUmFaSDJGbTA2RDhqekd6SDluQVQ3dHNWYjBxcjNP?=
 =?utf-8?B?TlIrbHhsZFFnNG1qcC9HMEN2ekpZd1ZYYyszL2VYVlVQT0pSdGFJWjBQMTVI?=
 =?utf-8?B?MFl6Q3p5Nm1iak95S1BGQ01rSTlYOUVQbXFPMHBHOGhXekpITkVMQ0pCM1Nv?=
 =?utf-8?B?UW5XWHpSc3dFMWdmc2doWmI2ZkxLMG9RRFlWZldzOXlWbmE1YXRuMmF5eWxi?=
 =?utf-8?B?Sy9pS3UwVklzQTFDMVNhQ29aVzd6VXUvMGYza3VWT3Y1b3dIMXNEMm5WM2VV?=
 =?utf-8?B?ZWtXMjUvV3JKRXlLY1lPZTkrVkgrcnp5TFBWWWx4TGRqZnhKcUhOMWl4VUFL?=
 =?utf-8?B?a0dWSlh0SGw4WWY5Ung2Nmp5VUFGSGhKZFNmajUzZWtGVGlHVzViUG5lVFcz?=
 =?utf-8?B?M2EvZWo3azNZRTZoZTBtMzBDM09JV0ZVNW15Z3YzMnlxcUhtdEt2cmk0RDFE?=
 =?utf-8?B?bVZVVEp1TklpSE5ROUx4dmd0ZGhJcnVQSmFPbmsrUnNXRm5vZTN4S3ovM2Nu?=
 =?utf-8?B?RFVub1FINHJRRTZ4OUo5NWVYY0pLZm5KMXdIemMxekdod2UzSjRkVWRhVnh6?=
 =?utf-8?B?Z1NZeEdVbG8wU0NiaVk1TDY0Q2FDK3JUWit5b0RybWhOa3c5STduSTlpcFE0?=
 =?utf-8?B?YklzUlJmejQ5YlFlNFgrMzVzVzNjY0VLajlBMFhNSkdoNVIvNWZtUk5YZlc0?=
 =?utf-8?B?aGczZm5RZ2JzL1dMalkyNXhsR21vcVpza096THUxYWdjODRjbEw4SzVleVBk?=
 =?utf-8?B?bmVUdFlmYU1LbjJYMVF4NENMaEhqMm45TGgwbHJjSWRsQzZwcCtzRTFDY0hm?=
 =?utf-8?B?b2loNDBSakh3WFdxNmNzQlB2Zk1iRWJjSFc5bGdsSllKS1cvcEcwV0h3c0lU?=
 =?utf-8?B?TGlnc2ZuQlB1RG9KOXJvd2E5MFhSTHFlS1kxTFJxVmxjUk05QzhhcmUwbzZW?=
 =?utf-8?B?NmpmU0dZS21ldFQ2YXV6VHZzekVkZldvYTJFZTFvQm4vTm9YWTZLZHovUmNY?=
 =?utf-8?B?ZnlidVlxU3gvVVM4RVBSRnJicnFpQ2QyMVUxZlV0QzlDVVluMk5qS055MExU?=
 =?utf-8?B?QktZclhaeEUxL0h6M2QwLzh5WkpvV3VUc2Q3Y2V3T05udFNobEpnZzczUjJx?=
 =?utf-8?B?TzJ5WG9UaDRQSHpqM0xQd2ZBeDBxSytsUjVqeTFTSTlBcjZObTBFZm1obmlS?=
 =?utf-8?Q?QMtnp9o/OUnWn3pkhsa/webVLL6NBGtPNeztrsT?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(376011)(7416011)(1800799021);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dlJ4WkExSGljeGpiZXB0R1N2SDd1RHFaL2NoWTU5dmVpUnZaa2RaYk5RMUt2?=
 =?utf-8?B?NCtjVlI4WDJSNitPZ0grT2dHUzlMKzNON3o3empIVThhNjkwdnRsaUVBRFJ5?=
 =?utf-8?B?cEdFdGl3L2RiRm8waTNpcVZma2pOK2J4U21aZk8xRU5BQVFzWnYvb1dPcjkr?=
 =?utf-8?B?RUdYN0pKV2Z6RkpKcHhVK24zVlZQV2RlNHRON2p1MFRKMFUyR1BqK1NVMnAv?=
 =?utf-8?B?MTF3WU9TREpGOXR3K05Mc2tQakZyVzJWdkxYWmVVb1ZueGt3dkdOWmI1TDNX?=
 =?utf-8?B?cmFocGtmdVZQZ0tzYjBUVEdsTnp1Z29vS2VseUFHd3BJbEM0Vm9RRWIvTFJ6?=
 =?utf-8?B?SVNkcEpJeTQ0UGNjZmFRWnVVNFAzL2cwdVlXcVRIVXF1OHlTWVJlZmdvY2hP?=
 =?utf-8?B?Y2hKb0Zra3lBamg0L2NiNG4vK1JscEdCcTl1TkJobStzSEJGeVF0QlFDNnl1?=
 =?utf-8?B?TUVESnE3Z1VWT0dKMTM2VjRYV0xzNlJuSzl1bnduVE5Nc3V2QmoveXovQitL?=
 =?utf-8?B?bHZjeXYzdSs5dFNFR1k3WllFcWlYeUJBT3lIUUpFSDQ4ck1yd0U2a0VtSzZs?=
 =?utf-8?B?QjNDQmxhVkwzVE1OcGtlMjlKZWx0Y0dnMDRtQmdXVGdrYUJjaktEbE1jWTFN?=
 =?utf-8?B?WFNWWEpDRis0LzBUeVhjU01ZZWh5YmFoU1JIR1BneVRBTTdaMC9BejBId0R4?=
 =?utf-8?B?Z01pQ3JaYUV5L0Z6dHRkbFBqS2hQek5ZZ2xwTVBWR2FtZmhteXNtbDFBdlVF?=
 =?utf-8?B?SVVtMGNVYkJCUzQ5bDBmT0Y3ZFgzSVZrWE5GclJsQUsrTnllM2ZmS2ZQRldX?=
 =?utf-8?B?eDJtY2lncHk3cE9kaTFldWdabjdpSEFTSUNzdmFUTXZWU1p3Z2ZSelUyTFBo?=
 =?utf-8?B?cDBlNHFSNHFITEQ0bzA3YmVmTk5RVmdRNk9DTE1GdGRmNEZhWnRXU05zMGlj?=
 =?utf-8?B?YzdJL3JxODB3RXV4Vy9KSVVuTkRBWWZFRUZpbFhhWG1YcFAxcG9NNTk2N21I?=
 =?utf-8?B?K0xKeVRmYVBMM1BQZWJyb2VSdlRhWXhjdkhBeXNYTVNxWkNjRWY1cmkySlE2?=
 =?utf-8?B?ZnJjRFZFZ0h1ekVDdUNlc3kyQXYwNVNpTG5jcjFTQ1JIREh2SFlLRm5qWlJF?=
 =?utf-8?B?dFBHditHbkxlMDN5anF5REhueC9FNkdiblNXdzd6Qy91YjArZ3h5bTI0R0FB?=
 =?utf-8?B?RCtkN2dMdEMyVW5HTlcvdGVEenhpdDFVRHRMekJ5Y1RFMVZ4cldFd05XTk1s?=
 =?utf-8?B?VG5pUGl0Vk9DeU82UWlzYm1MUHJZZU45Wk1UK2hhNmhCaUpvT2M3KzJNNjUv?=
 =?utf-8?B?RVZNUS93Y1U3NEFPVTA5TWN6YmJoT1hqWFhNQ0RkY2dHWFNNVGhDVlQ0RXRE?=
 =?utf-8?B?TzJ5cHNoQlVoR1V4MThneUVRN3RWQmtuTzh4Q25sSFNOb0VRUzB1NmFwZ1VJ?=
 =?utf-8?B?N091OVZ0VDN0eFR5WTJLSytSYXpDT0tnSGhmZ3dqMEZlTzBqbGFJTncvaVNV?=
 =?utf-8?B?WUxoRlpTOHdxK25hb1k4UGVGZnNrcUR2ZmI2ZDZhb0VnMnhOYktwZ0I0aXFs?=
 =?utf-8?B?OUY5QUwyUGNScTF6SHFHTXhMWEQxM1FYUzkzeVEzSG1kclplTjBaQ2lUWnlh?=
 =?utf-8?B?ZlRRVXNacDJydzVxSkRGK3AzTkJITmNHVUZacnVUb0JabDA4cWZvUTBuNy8r?=
 =?utf-8?B?SVErUkpjd2JwZ20vVE1FTWlWU0pVQ3hEV25nbngrVkwwZzE2Rm1RakZncW1C?=
 =?utf-8?B?VncvUnZYU0wxK0ZYL3B1ay8zNnBYeU40by81WmsyYUF1UWkyUldhMUh3S1FN?=
 =?utf-8?B?ZzZ6OENCTXFlYzRMc3h4VElPRWp3TlREcGorSnZqODY1RE1qQitsMitpQTNp?=
 =?utf-8?B?SHYyOWVaSWx6cnpxZG1NUWk2MU9Od2NQRk5CNUhWSWJEYUo5Y0VNSE5zcVBW?=
 =?utf-8?B?ZXlxNjFpVzRtWVAvSGJzcDdpZm56ZStsaGd2RVdOVm9UVUUzSlZSVXRtV0ZF?=
 =?utf-8?B?bEsxTzUwUUNWRzh4WEV2MmFYcG5QU21qczVDS2Nlc3VFNFJ4QzNMYytGL3Aw?=
 =?utf-8?B?TEI0QkhvbDR5bkQ2eW1POEEzUzRoaGlhdWQ4RUtwS3JNYm1aUlE5SlMvUXJ6?=
 =?utf-8?Q?rgcEYReOjsVW2sgu838/ZSYhI?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 9fbdb10f-b476-4c65-9fff-08dc8f2b64ea
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2024 00:12:52.0793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 96nK5Zru5DfjSrCRJS1k4sm+FawfOOHnscwEdkxx+G24cYHO3yT+F8K5vHpi/XIi1p1jZkf+ZlnHI+8QIVIRSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7797
X-OriginatorOrg: intel.com



On 17/06/2024 10:54 pm, Chao Gao wrote:
>> +/* Return whether a given region [start, end) is a sub-region of any CMR */
>> +static bool is_cmr_subregion(struct tdx_sysinfo_cmr_info *cmr_info, u64 start,
>> +			    u64 end)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < cmr_info->num_cmrs; i++) {
>> +		u64 cmr_base = cmr_info->cmr_base[i];
>> +		u64 cmr_size = cmr_info->cmr_size[i];
>> +
>> +		if (start >= cmr_base && end <= (cmr_base + cmr_size))
>> +			return true;
>> +	}
>> +
>> +	return false;
>> +}
>> +
>> /*
>>   * Go through @tmb_list to find holes between memory areas.  If any of
> 
> The logic here is:
> 1. go through @tmb_list to find holes
> 2. skip a hole if it is in CMRs
> 
> I am wondering if the kernel can traverse CMRs directly to find holes. This
> way, the new is_cmr_subregion() can be removed. And @tmb_list can be dropped
> from a few functions e.g., tdmr_populate_rsvd_holes/areas/areas_all(). So, this
> will simplify those functions a bit.

Traversing CMRs to find reserved areas for a given TDMR sounds good to 
me logically.  The whole construct_tdmrs() assumes all TDX memory blocks 
are fully covered by CMRs anyway.

I'll try this out (validation is a bit tricky because we cannot 
reproduce this issue internally).

> 
>>   * those holes fall within @tdmr, set up a TDMR reserved area to cover
>> @@ -835,7 +932,8 @@ static int tdmr_add_rsvd_area(struct tdmr_info *tdmr, int *p_idx, u64 addr,
>> static int tdmr_populate_rsvd_holes(struct list_head *tmb_list,
>> 				    struct tdmr_info *tdmr,
>> 				    int *rsvd_idx,
>> -				    u16 max_reserved_per_tdmr)
>> +				    u16 max_reserved_per_tdmr,
>> +				    struct tdx_sysinfo_cmr_info *cmr_info)
> 
> Maybe this function can accept a pointer to tdx_sysinfo and remove
> @max_reserved_per_tdmr and @cmr_info because they are both TDX metadata and
> have only one possible combination for a given TDX module. Anyway, I don't have
> a strong opinion on this.

There are pros/cons of the two options.  Passing the @cmr_info and 
@max_reserved_per_tdmr makes this function more clear that it _exactly_ 
requires these two.  Since passing a single @tdx_sysinfo doesn't reduce 
the function arguments a lot (only one argument, and you have to get the 
two inside the function anyway), I would keep the current way unless I 
hear from something different from others.

