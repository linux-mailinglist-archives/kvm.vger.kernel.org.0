Return-Path: <kvm+bounces-7130-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A25C483D778
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 11:11:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE9391C2F9B2
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:11:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B96F210EA;
	Fri, 26 Jan 2024 09:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="evuLDdFc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1118820DDD;
	Fri, 26 Jan 2024 09:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.55.52.115
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706261431; cv=fail; b=jKwdG7xNdw10qE7zysYbMC0oiilHlxDO0j3+rOPF/PC9oDoRY5bLBJGWAraChKxGWXHjQUww0KHpgaKTrrzGtcp3qifS4JNV0icPhZMxRD6kjgzCM/dQbAiYpl6Xvbn41Fldn46gA1XEYm6v5/nO0u2UcZka9FbDZzrMVrdla9w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706261431; c=relaxed/simple;
	bh=4QVoL39YxiLLjAZxSRaceBYegyFoTUs9rrfSyV0BegQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=TVn5uuVE6me2KO6sNXMH0fEtrUJ0buyCVFqm9yV1sl0KV2Xb8jkPFn5Z1MHyYajSIKZ0JFWrP6uh1uXZ9yimZQ+b1Ssnl95YjbtV79ltjROJEtbD7PJRXr27M/xsy3DijntFuj+pr4GMJf2JdcOY7l7EJc+nGWsuiz6kmR55dYQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=evuLDdFc; arc=fail smtp.client-ip=192.55.52.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706261429; x=1737797429;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4QVoL39YxiLLjAZxSRaceBYegyFoTUs9rrfSyV0BegQ=;
  b=evuLDdFc1rS0H1mrHoeufprczZtgbV/JhrND3+x1vDEDvN78EXVuKZsh
   8k71CcWA7F2YS3ewla3RYfdJCf3DHsgE40yLeh+v5bVy36A4zCKtvq75L
   ZWS79//Bozuu5aO5DJsgIW3YQoL37b32hjzUyXkGL6L4vqwFUvYnae5Q2
   eGV+MNKuJkbNfr2EhiyFLXx2Y5+w8jU3ev5k3pICOvrQ/J3GDYhWqgbpn
   QvnG/v28W06E9cyWwJEfAFtTfmQ20WVrcBVQ1aAp/aVST4sqT1obfgXRS
   oE0EiLwsQWywxjfSu705cjCNajdDHr6oqt33JvvRlzW+5F5DBMGDyahaW
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="402082874"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="402082874"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 01:30:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="2546263"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Jan 2024 01:30:28 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 26 Jan 2024 01:30:27 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 26 Jan 2024 01:30:27 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 26 Jan 2024 01:30:27 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 26 Jan 2024 01:30:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PHfrlh4m/t87b52tUFyhyYFRrOm7RByqYGr3d2qGI67C6IUCVFQxYiKv6iIetA2ZJGmlpsd++UssC31MtSgTID/kbBqRvyu5l7l8G5uH1ywZvhYST9v4LFxviY00TqalCn17ycLb89jHFNjYEWubL8xiT82MdYZnXy++/zLjErWmb1wdn6C27iqZggB5b1/P/4TTLaSOIXmUYqvcg/5H+0vBl0cgT4gJFpt5MJeRgUI0VpPgGsZ5kMEmrIpeCQzSWiVB994iGfZTrBnSqU6cxQZvb78SP3kgBXOZ8oQ4nYoRnTc6txEXsD+ZVBEJdzI9Hv346PTKGtcuMUQHBvRhUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GXFe2gGcbsO+ZkPz73W3kKuNbLVHFjd8UE/oGsIHshA=;
 b=BmOX4D9mLuCCDZhW8CrAtdN2QR2+JCTEVCxct48+SwlAqAemJRDGniWxFfTuWYGm87SdoSG8sv75w8EKjCHW05VOplP7CceweyvDaTdqsS4qcHdca2eQh4Yb0lBDLPjh3J68j6RgmPuf9ip/jo23buw4Z+wDYat0BYvybemdu+3NjRNNSGIasq/AeMCjhWprbKDWfxkd9yob2avAl7wVXZblI0SmIGqnypo/xycIXk8cvAoyRci/GFPFoM5s/WXIBZv5gUhMh9QKR5uCx51JVnde8gzf5aEJf88jTuajTbqsdDbjuiDUkTpPF1ec40ezWBD3ATQ5w2qYTudV2VU5nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by PH0PR11MB4805.namprd11.prod.outlook.com (2603:10b6:510:32::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.27; Fri, 26 Jan
 2024 09:30:24 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::5d67:24d8:8c3d:acba]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::5d67:24d8:8c3d:acba%5]) with mapi id 15.20.7228.027; Fri, 26 Jan 2024
 09:30:24 +0000
Message-ID: <ad97d210-0ef3-4500-b26f-65aad0a444a3@intel.com>
Date: Fri, 26 Jan 2024 17:30:09 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 13/27] KVM: x86: Refresh CPUID on write to guest
 MSR_IA32_XSS
Content-Language: en-US
To: Chao Gao <chao.gao@intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<yuan.yao@linux.intel.com>, <peterz@infradead.org>,
	<rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>, <john.allen@amd.com>,
	Zhang Yi Z <yi.z.zhang@linux.intel.com>
References: <20240124024200.102792-1-weijiang.yang@intel.com>
 <20240124024200.102792-14-weijiang.yang@intel.com>
 <ZbI+pexl9Th0KiiU@chao-email>
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZbI+pexl9Th0KiiU@chao-email>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR03CA0120.apcprd03.prod.outlook.com
 (2603:1096:4:91::24) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|PH0PR11MB4805:EE_
X-MS-Office365-Filtering-Correlation-Id: 188c4ffb-f3ce-421c-3f1a-08dc1e516c90
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LUbX6ArH4c9fjSUUmKLzxnkG9g52+2S95x/0TrjYKQe6JRSY68kNxOFU4aBuJxZoQIa/jes5PrCaKWBxXz8oYzzf+GkBdGECFgsVh0wtqR+KvXQ1mXsBdV+o14Vd7XcN696vYgGJIp1cgRLYA/B3Jp/LeEJSfLho8rCwPEOYB6l+v1TnDudGwaDH5Y6ElydQHYrrepSXfkEe+9/2YROWEAzzGur0zt58pd8hyhhFLvotOzc26PD023rbbYKl3wj3O0Ot5FxhghR/WVW400k7LW1rYdGd1KblrGh8fYJ/sK3aISy0i4Tg1rTmQcRHt6PSTnI08e+lMXpD13zCXmjXQAPE0j0IrQN/d4OoBRm6lsVcaEE6D+gyhn5m0hqArjBvdsjZRkGX9EHJ5I08nCWhzrHxXXocQFkY2H/xL1vH6nbv3nbGC5Puzd6A4hbm85bnBMDrrvVl2PBeBQ//witEbsDYSKOGSXQc5N8+dWnscWvSmUE/8wZ0fPevyjfRoSHgtvJuxwr1U2OxYNd4uIFEmey8P8f2ORqnuUKBEkyKhDUqv6/KvkpCew2CggW4RPWDPNyu4wbPfXwra0gWFI1Qyj8rvusO4hm3XZAGtOGHO7KE8G9xuzVfujXh6EHesaqrtl2H/h8lXbNapnoZyVhCzA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(396003)(136003)(366004)(346002)(230922051799003)(451199024)(1800799012)(64100799003)(186009)(41300700001)(26005)(2616005)(31686004)(6486002)(6636002)(37006003)(36756003)(478600001)(6506007)(6512007)(6666004)(83380400001)(53546011)(38100700002)(82960400001)(316002)(5660300002)(31696002)(2906002)(7416002)(66556008)(66476007)(66946007)(86362001)(8936002)(4326008)(6862004)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NFVsSGhZV1ZMc3RvVzE0bHZaR2JxM3VOU09vZzdjcytuWmNmbytPNXN6c2tt?=
 =?utf-8?B?dW5GZFZFS3FkcWplWXhjd0swaW5IWnhoQzMrblpQNGIvb1NXazh4Rlc0Y1pj?=
 =?utf-8?B?dUc4cGJ6WlNwMXJWRWtWYVZ6RlZpOXRQSDZQUHVKT2U3cXlPKy8xTmNML3Fw?=
 =?utf-8?B?NzVtWHdLcGtMQU1pT1Jkb1NSSURwQTdsRHl5elFHeHpTSkZjR1U5bjRUaDlh?=
 =?utf-8?B?V1lGRUVNcVcvVFVwQ1RoUm1jQXN3ME9KSTVRSFAwOVlYbnl0VldZYWFPZ1Iw?=
 =?utf-8?B?dUg1VTRwVjBjNHU3YU5CUzlIdGQreDNpTmI3V3NDbmFnSklWYndac2JKWnRB?=
 =?utf-8?B?NnN6WGErTnJRRHBNZkd5VHJ2UTA4UjdLVWtqVm5pUFduOGxkMk5qMWFlS1R1?=
 =?utf-8?B?SjRzakE4ZkNhZDNRUXRQdzNnUWNsU2hkZnhxU0UrTnY1MmRTUFZ5YjJFRVFu?=
 =?utf-8?B?bjdXQWt5TElKVUQ4K3AvanNQanIwYUtpRWlId0RWVWRZRGlpMnpJMzc1UGNs?=
 =?utf-8?B?aFdHNHd5U0dhU05vQll6WGJBL0FLWE51U240SUZ3WUNxUTFLb2dIcXBjYzZN?=
 =?utf-8?B?SysyN01XSE5TNEFsNWhscFI1MUJsMVgxdWg0ZlNDRHlFQXhoSkxxTjVVSWJn?=
 =?utf-8?B?OEVRODJDWFo1WjA5VGw1RHdPMUhKV0pOcGt3RVFNc1djb3F0eVZuRHFtZjVB?=
 =?utf-8?B?ZXN3ak9wWlhZMGZEbmw4YklFMHFzcS9HMU50b0F6QkpEOENtS2lQamlwc0xi?=
 =?utf-8?B?ei9EeEJsWEZxb0hRZEJTUDJoeVI5L1pUams2TDg4NVBQMW5iQ2doYWZIMXls?=
 =?utf-8?B?dDhEWVJBN20vWUVaaWNFd1h5N1YzRUJIT3FFSFVqaHFTeFVZSDFCeVVNWDZL?=
 =?utf-8?B?VTZFcjZ4Zm13dkJKdWNqUER6dVdIdGJBOW81RzZ2VVNZTFJzK280c3NNTmlU?=
 =?utf-8?B?cEFWZm1Id3VrVlVJT0lVcnZKempRZnc0a1hpdlU0aVk3MUh3KzNDMUhITjFY?=
 =?utf-8?B?aUNpajhqV0hleFF5eTdpUWRzUCttQ3dlLzBzU25pMWxuZ091TFNHZlNnaFFN?=
 =?utf-8?B?dmxFS1U4RnJJYVpyMlBoZGl0WkwvcDVWWDY2cHhBd1cyVHpNbUJScldoWnFJ?=
 =?utf-8?B?ZVVXWUhxK2Jpbk1NaEhpTzdLdXBqQ1VVSzc3azk3aUhtaWl2Qi9WVjdwV2xZ?=
 =?utf-8?B?UFhsRzU2UU10bU9MTCtNMEppWVFlVkpWd3ZsWitLS3ZiZHhwTXowU2sxbUtS?=
 =?utf-8?B?WHVKeS9TRUNaT3VDb3lEcURYN1ZONHhBU05CNHVmRnZOMVFoUlNsUExXcTEv?=
 =?utf-8?B?SU9zU3pCMUdTeUQxekdUZ0R3OEJhdVRwb3RIV1NLbGVWQ2U5RnJzNjl4VXRZ?=
 =?utf-8?B?QndoVnlhWkdINUlHcjVnQzNrM2Q1dlQ4SlpYM0h0eElWNVRZdlR2WmYySkcw?=
 =?utf-8?B?VW1PR2xOektSV2ZUQlM5Nk5EZTBSNlgyNTFEby81aXJyUnU2cEwrNDBSUzE0?=
 =?utf-8?B?VmxhY3ZXUElsd1MvbjdvMGRHU2RpWEpPQldhNUUxTXlpNW5zTHoxM1ZwamRN?=
 =?utf-8?B?WFRCclpkVHFCMXdjY3Z3SElYYmM3NUt5N1JLZHlJZUlUdWN4K3hrMnNrakt1?=
 =?utf-8?B?Q1lXUHp5dnhqN09rSklpbDFIN0FUYXlDY0ZESUkxZVU5eW5FODUyQmhBM0ww?=
 =?utf-8?B?N0xUV29kSzBsYUc5L2xqcVozSHBTd1pDYU0xdDdRRjZIMFdWOExBN0ZiVnNN?=
 =?utf-8?B?NEpXaW9sbm56Rk1lYXFRVDRyaFk1S201cUt5V0V2YXhFbG1Sd1lIUkRnTDdN?=
 =?utf-8?B?eHcvUXJ6MTNhRWFtMlNkQ21xUzhQVTJNNFRISytITGk3akZTN2VwSGErd2Mx?=
 =?utf-8?B?YTVxM0I2a2JKdmdOWXltK2ZnQ1ByQjhBQjhzZDNQTE9PMXE2Q1Fvbm5KQktQ?=
 =?utf-8?B?a1k1Y1NMdXM0NXl1SllyYUNJbzV5TmpiREl2ajdQcG85SHE5V0xVb0UrRjdK?=
 =?utf-8?B?WTBYMUhoOUVEN3J0RldRNk45VkhWWEZBV2ZBMndlb3dZVFNOK3VvQ0tjaURJ?=
 =?utf-8?B?RDdjM1pFQzd0R1ZPR0YyV1owM3dBN3N1b0F1aHNidzRRL3h1YWhZbDlwQ3ZT?=
 =?utf-8?B?ZytXUHpJQVFkbG9zYUVtTis5SE5aT2x6TWgyeDBiQW1KdS9KTStsM0N3U3h0?=
 =?utf-8?B?RHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 188c4ffb-f3ce-421c-3f1a-08dc1e516c90
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 09:30:24.5883
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HhVkQ1aIVu3szi7g8AIRTOXboqAD5qmRnBTcSvhi3vL1bKlI2hdoNIIhMf3QRLzgay/uEF/2ftwIXRyQgQ6gvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4805
X-OriginatorOrg: intel.com

On 1/25/2024 6:57 PM, Chao Gao wrote:
> On Tue, Jan 23, 2024 at 06:41:46PM -0800, Yang Weijiang wrote:
>> Update CPUID.(EAX=0DH,ECX=1).EBX to reflect current required xstate size
>> due to XSS MSR modification.
>> CPUID(EAX=0DH,ECX=1).EBX reports the required storage size of all enabled
>> xstate features in (XCR0 | IA32_XSS). The CPUID value can be used by guest
>> before allocate sufficient xsave buffer.
>>
>> Note, KVM does not yet support any XSS based features, i.e. supported_xss
>> is guaranteed to be zero at this time.
>>
>> Opportunistically modify XSS write access logic as:
>> If XSAVES is not enabled in the guest CPUID, forbid setting IA32_XSS msr
>> to anything but 0, even if the write is host initiated.
> any reason to allow host to write 0? looks we are not doing this for many
> other MSRs.

Paolo mentioned this point for many times, and the latest one can be found at:
Re: [PATCH v5 04/19] KVM:x86: Refresh CPUID on write to guest MSR_IA32_XSS - Paolo Bonzini (kernel.org) <https://lore.kernel.org/kvm/CABgObfbvr8F8g5hJN6jn95m7u7m2+8ACkqO25KAZwRmJ9AncZg@mail.gmail.com/>

For other MSRs, Sean proposed to enforce the policy in batch, but the work is delayed.

>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Co-developed-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
>> Signed-off-by: Zhang Yi Z <yi.z.zhang@linux.intel.com>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
>> ---
>> arch/x86/include/asm/kvm_host.h |  3 ++-
>> arch/x86/kvm/cpuid.c            | 15 ++++++++++++++-
>> arch/x86/kvm/x86.c              | 16 ++++++++++++----
>> 3 files changed, 28 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 40dd796ea085..6efaaaa15945 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -772,7 +772,6 @@ struct kvm_vcpu_arch {
>> 	bool at_instruction_boundary;
>> 	bool tpr_access_reporting;
>> 	bool xfd_no_write_intercept;
>> -	u64 ia32_xss;
>> 	u64 microcode_version;
>> 	u64 arch_capabilities;
>> 	u64 perf_capabilities;
>> @@ -828,6 +827,8 @@ struct kvm_vcpu_arch {
>>
>> 	u64 xcr0;
>> 	u64 guest_supported_xcr0;
>> +	u64 guest_supported_xss;
>> +	u64 ia32_xss;
>>
>> 	struct kvm_pio_request pio;
>> 	void *pio_data;
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index acc360c76318..3ab133530573 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -275,7 +275,8 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
>> 	best = cpuid_entry2_find(entries, nent, 0xD, 1);
>> 	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
>> 		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
>> -		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
>> +		best->ebx = xstate_required_size(vcpu->arch.xcr0 |
>> +						 vcpu->arch.ia32_xss, true);
>>
>> 	best = __kvm_find_kvm_cpuid_features(vcpu, entries, nent);
>> 	if (kvm_hlt_in_guest(vcpu->kvm) && best &&
>> @@ -312,6 +313,17 @@ static u64 vcpu_get_supported_xcr0(struct kvm_vcpu *vcpu)
>> 	return (best->eax | ((u64)best->edx << 32)) & kvm_caps.supported_xcr0;
>> }
>>
>> +static u64 vcpu_get_supported_xss(struct kvm_vcpu *vcpu)
>> +{
>> +	struct kvm_cpuid_entry2 *best;
>> +
>> +	best = kvm_find_cpuid_entry_index(vcpu, 0xd, 1);
>> +	if (!best)
>> +		return 0;
>> +
>> +	return (best->ecx | ((u64)best->edx << 32)) & kvm_caps.supported_xss;
>> +}
>> +
>> static bool kvm_cpuid_has_hyperv(struct kvm_cpuid_entry2 *entries, int nent)
>> {
>> #ifdef CONFIG_KVM_HYPERV
>> @@ -362,6 +374,7 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>> 	}
>>
>> 	vcpu->arch.guest_supported_xcr0 = vcpu_get_supported_xcr0(vcpu);
>> +	vcpu->arch.guest_supported_xss = vcpu_get_supported_xss(vcpu);
>>
>> 	kvm_update_pv_runtime(vcpu);
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index b3a39886e418..7b7a15aab3aa 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -3924,20 +3924,28 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>> 			vcpu->arch.ia32_tsc_adjust_msr += adj;
>> 		}
>> 		break;
>> -	case MSR_IA32_XSS:
>> -		if (!msr_info->host_initiated &&
>> -		    !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
>> +	case MSR_IA32_XSS: {
> unnecessary bracket.

Yes, will remove it.

>
>> +		/*
>> +		 * If KVM reported support of XSS MSR, even guest CPUID doesn't
> IIUC, below code doesn't check if KVM reported support of XSS MSR. so, the comment
> doesn't match what the code does.

Here I refers to what it does in patch 12.

>> +		 * support XSAVES, still allow userspace to set default value(0)
>> +		 * to this MSR.
>> +		 */
>> +		if (!guest_cpuid_has(vcpu, X86_FEATURE_XSAVES) &&
>> +		    !(msr_info->host_initiated && data == 0))
>> 			return 1;
>> 		/*
>> 		 * KVM supports exposing PT to the guest, but does not support
>> 		 * IA32_XSS[bit 8]. Guests have to use RDMSR/WRMSR rather than
>> 		 * XSAVES/XRSTORS to save/restore PT MSRs.
>> 		 */
>> -		if (data & ~kvm_caps.supported_xss)
>> +		if (data & ~vcpu->arch.guest_supported_xss)
>> 			return 1;
>> +		if (vcpu->arch.ia32_xss == data)
>> +			break;
>> 		vcpu->arch.ia32_xss = data;
>> 		kvm_update_cpuid_runtime(vcpu);
>> 		break;
>> +	}
>> 	case MSR_SMI_COUNT:
>> 		if (!msr_info->host_initiated)
>> 			return 1;
>> -- 
>> 2.39.3
>>


