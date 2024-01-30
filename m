Return-Path: <kvm+bounces-7478-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71173842742
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 15:54:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F1D2C285EF1
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 14:54:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42BB37E573;
	Tue, 30 Jan 2024 14:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bUWT114b"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF07A7C0AF;
	Tue, 30 Jan 2024 14:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.55.52.115
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706626482; cv=fail; b=qkEk9lf4vRZ1Y6YTFzykzTs6KGG9PHgaM8pPG7Uh8JCz6sjNtGewk/xtkRVdaNhc0rO+5Z4V1V7S8bx4fblxUxsDS860qa7Ffb8wP13LjFUeLr5YE48U4wM7sOlq0GVMbHLNGB4N4bX2vlZED2TRQzOTVLVvEzqG8Mz/zhmhGIM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706626482; c=relaxed/simple;
	bh=EQJeCW3Ujb62/CIcBGL2+c4ppQAYqPA3IKamHPKnKOc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=HPPIN+eUOQsASgHJGnhQfEUHoOZG6kVtKWxhFlhXZGcry/6ci3mc8DR25Zwo/GOWexIxSin16XSLjeEVCY1JtW6HBxJogxojK8Lyw/YA8gFa33VUkvKfyk/rMdxUhJHebZwVJWhMHufQTQDTpi5FREoqk9XSHUy3WBaBXcBers8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bUWT114b; arc=fail smtp.client-ip=192.55.52.115
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706626480; x=1738162480;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EQJeCW3Ujb62/CIcBGL2+c4ppQAYqPA3IKamHPKnKOc=;
  b=bUWT114b8SDmLeFvS7y/f0zBqr4BNZJBWsdCa5doHYjSSkgxALEMX7z5
   Al1JMRY8rnnLLfqHFtH1XMeCCP9QWeShsi/WYDMuTBAe2iqJsEe18SXRQ
   CkVPtEyOuGQYjTTSfWSKHdnMc3wM8lLEoJn9nRuEM4EYPjoF3aR7BseVp
   qsKpcZjIOCi1oZsv06Udndn+gNoPrRtuqoJZ8qy/hC7dRY9C+qKriEsAc
   IXroj9e95bR5IocGPNE9HDyRTpCPMf4WMxkJww1JqdMv7y23YFwSRANHT
   nUyFY5o9Emb8C0sSIYrJxhM7Y9QmnjtZWF7yb8S57whZhvsb6GTDFw7j4
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10968"; a="402924868"
X-IronPort-AV: E=Sophos;i="6.05,707,1701158400"; 
   d="scan'208";a="402924868"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jan 2024 06:54:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,707,1701158400"; 
   d="scan'208";a="36519690"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Jan 2024 06:54:39 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 30 Jan 2024 06:54:39 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 30 Jan 2024 06:54:39 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 30 Jan 2024 06:54:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ltDaRW7Xj+vy/PQuGZGARnesFmG3bY1sqO1bdfuvNPA/pQEcG7lzq/WWKxseZvM1xhWiNTpGFuMFrakYaCEwQmZZlrk0jyqWrCn+IPEW0quL0meAAMzPmz+sLzdOcr2Idk4EHKeEIwwAzwl5NmyymqukmtRXkawMTKjZdQ00zK1IyFLtTpoT2dj7m/dhsuJd2tOnyCPWuboZVLVAzZh612u/4VEzI0oKoTQxABQCbhuiKQ6VOf2UnnkAkUnE5vClOAj3FfYAGzoPQO7qzEH29wc/fsm1xfI/qM6bAtdqs6OhbvEurk4e+3XfIpEJbPJfirLsV87v5x8XX2F7BQh0BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jE5GSsLyIYwn3GhtkZha94w+NbW1FCHhyMohMMg/fdc=;
 b=ifobs8mTmOFFJAheV4kF+3HjlxMiwDnzmD9OX4S04Taeo51V+KBbEfih9useioskmr3ZEMjTd7Qe3YbFmLvPVvg044kd0ScGZoKJS11t1fPZ6LJir7rj9VBSRSLoCQ6QKAss/jB7pZYuAdPhLpTw+l9X/Xq1hoLySECiuW03FhaOKdz+jcFHXziBXEPJFejn1Ut1lnvIZRA2gPULldMfhpfydSi11rUsA/P1WTzvcd3aNweJhBbXSXc6g4weLqY9q/zBPqZVsVlBNo4JeGDwiHUNVFssXlR12h/t4dDm1F3MtIkAfrssaY/UNtUjPBdlpFXW02F3ANOnbhdsK9NnpA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by PH7PR11MB5862.namprd11.prod.outlook.com (2603:10b6:510:134::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.34; Tue, 30 Jan
 2024 14:54:36 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::5d67:24d8:8c3d:acba]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::5d67:24d8:8c3d:acba%5]) with mapi id 15.20.7228.029; Tue, 30 Jan 2024
 14:54:36 +0000
Message-ID: <9a26e279-0d48-4b3a-a459-874bc32f6a35@intel.com>
Date: Tue, 30 Jan 2024 22:54:20 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 06/27] x86/fpu/xstate: Create guest fpstate with guest
 specific config
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "yuan.yao@linux.intel.com" <yuan.yao@linux.intel.com>,
	"john.allen@amd.com" <john.allen@amd.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "Gao, Chao" <chao.gao@intel.com>,
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>
References: <20240124024200.102792-1-weijiang.yang@intel.com>
 <20240124024200.102792-7-weijiang.yang@intel.com>
 <c179a5f4fba9086f9d35e56ec16423558cea5b8b.camel@intel.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <c179a5f4fba9086f9d35e56ec16423558cea5b8b.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI1PR02CA0026.apcprd02.prod.outlook.com
 (2603:1096:4:1f4::11) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|PH7PR11MB5862:EE_
X-MS-Office365-Filtering-Correlation-Id: e139e2e4-71a6-4022-99a1-08dc21a3608c
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Uxq6KgNI4P6p4FVqTZTDnihsruCVstQxvKeFFYqqXLGeokl7ga7M3kQ6x43KNlO3CWZq7T9Q5rfmJeKbX943jfbqYoYjSfjzqYY1mcRsW3Tp6DlSNGbNHv7vkXRnGb0+9czV4yuXnmrCKePpHO37uGCMwwNpHs+jmB3DAxwHCJsEBj6eDaEhWF2RoADH2Vfe5eHSj+DUZPcKgpQd2qooajTjhNms/sdrlSNgs6V+SxucxGWRHtLfcztFNwX5vS2NMqowjuBrr5d0vetfj1gEt3Tb6zs8dXMv9i4pR1e4IqlV8AbRCUVSal2/CJkFnRGxhPQqbTBB+xEQXk6W4bkCB6+3ta2aUQJ9/Hx8nUVGHXBKOA6Yv3j5Fs1T08vQq0dUI9xZ1k/nyrz6EJRnCrb21UCAvS3zlBwhlEyhxhOnC4KB8FI2G+jmX5Qw6lYPe2QY20EWTG9O//B086n4hu9GeckI9ODE/j7TCz1ggxfwlXA5olt/Mali/8DWQL9FTIulU1LA6ZnG6j+RPmNpxVeoJBzj0O8HUjNSbqLeSNywD9NEgm/JHr1Wc4K9YiqJxwNVE5pzyFxnfRuDcxkTE5XcNAmtD3zn2Omc5SVvyOB65uFHjNVdoH/rEVFPSKO2z++aGFXMSkER2PBYtUk7jflEMA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(136003)(346002)(366004)(39860400002)(230922051799003)(186009)(1800799012)(451199024)(64100799003)(31686004)(26005)(5660300002)(2616005)(316002)(6506007)(66556008)(6666004)(6512007)(53546011)(66946007)(6636002)(4326008)(6862004)(66476007)(37006003)(54906003)(2906002)(8676002)(38100700002)(6486002)(86362001)(41300700001)(478600001)(8936002)(82960400001)(31696002)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V1g0S1JMejVXbnR6RmFtcm9ibDNYR20rRGw0ZW0rcjJyTS9vdDRMZ1FnV1lv?=
 =?utf-8?B?YklhaVhYZkRFVDkrcnkzWEF0RlZxUHZKeDR6MGh4SmVtRCtzUUZ1TGRtZWNG?=
 =?utf-8?B?eHM3QStuTGUzcDJuc29jbUhjU0hMNjFZS1dhaUJOY0t1aCtpRUdtZzZqVjJw?=
 =?utf-8?B?NHc0dDdKN3l3Tk0vSkp1Y09TZ3U3UTd2ZzlMZUFaT1R1cXdJVVRRV2ZDclRH?=
 =?utf-8?B?Ym9yYVpzMlhadEFPY3FYOEgrMTBzSytoS1o3L1huQjRpalNObVpMQTh1amx3?=
 =?utf-8?B?dXJhVWRFNFZMMTN6NzVmUVhoU3Z3d0JLMDZNWXhXTDBnUS9PU1hLcVNxOXNn?=
 =?utf-8?B?bWdxMXhybkRzWmRiZkV5UHQ4VTR4dWFmUmpVdmppY2RTZlpyY2JVWmRqck1R?=
 =?utf-8?B?cnpEOEdwNGI3ZFlrVGtFOCsvZVNZUGdvZEpTaXJEZTNxYS9uM1ByOVZNT2tI?=
 =?utf-8?B?elRxU2F1SVhKUkRuUTZBOXhtQ1BiVm51VE5mTXE0VXJMR2ZDTUNFZU9Ib1l2?=
 =?utf-8?B?alJabGJubHhhcndsUnRqcjA1QkM2Q3ozRUZ0VHdCZnhkSmh2TlY3SnZYMXU1?=
 =?utf-8?B?QXpUNkdCQTNNRGNKZ3hwOTB2dUprREd5ZWNWRXhsODNTeldMZUE5WUREZU5I?=
 =?utf-8?B?Zk9tbFJNNHZGUjByMEFsMHdKM1BkRFlDV3Z1MzdaTHhHK0JJNVdpM2wycjJu?=
 =?utf-8?B?Wm9tUjNKRlZmT292ZndtM2s3NWdYdlpzVmtKVlg4SktUQlBLQVFFeCswM094?=
 =?utf-8?B?SUdvNjdITm5PMXVNKzFEdmxROTYxdnNBbjkyRXo4bXVrRDVlWkllQ0ZDOGsw?=
 =?utf-8?B?MDdSdURsV0ZXTXU2ck5ha3Q2NHNPa1VOQzZhOUJ5VkcxVjhPckwzN1J0ZWww?=
 =?utf-8?B?dEVpTmFxbStBSHp5ZEtDU0VvN3dqYkhmSGg3b0NUVzEzYy92Mk01d2lZbFVS?=
 =?utf-8?B?cVpVd0JnVWJCdW0rZEpMRmVVMXBTZjIwc0g1MVVKL0I1UjB0TXhudFlISUlk?=
 =?utf-8?B?N2lwZUFDNTgzeHptYjZLYnZkZU5yYWlLQlY4eDQwSk04K003SG5nT2dveldu?=
 =?utf-8?B?Mmlwa1R3ZFhUL3RLQUl0dS9uOXpWR2pMVkZVUGVmTExxcktmWVhFRnpQbkdm?=
 =?utf-8?B?OFRiMU85Ny9sQzhVMnhyVEIxYUIzNDN0d0d2bDlSWUpkNGtmaFZnOVl6ZTc5?=
 =?utf-8?B?Nzg2Z2dNWmkxdk5BbjhrS0szSW92dXNGZUMyczR3cUxibjJsdEFkVDlDOTV1?=
 =?utf-8?B?ZldGNkVRS0FKVGNvYThzSitkMGFTNko3QUUvVi9paUM2QmdOaGdSaFBOM1k0?=
 =?utf-8?B?UVFWMmVLYnVtOHIzNHlIWFN5TU1FcElVOG1SS3hYVmtWY0YrTVYzT1dYcXlF?=
 =?utf-8?B?ckdvUlJMeFpMNU1xMC90Uk5tZTlnWXFuY3NsQ0M2ZVRPOHNFYXppVE1wWURE?=
 =?utf-8?B?N29JOUtud1dNeGFBaVBTZHhJMGpTNnJjZEtPdTBBQlZSQkZqTlZKZGEvWGlz?=
 =?utf-8?B?VU1LL1MwMk45cHNBWkt4bE9ONTg1OG5KSnBXUDRaSVh3NFRQQi81Z3pudzZB?=
 =?utf-8?B?WXQvMjRZRHNxbkViaG5GQkNDaFJMZFcvOGU1KzI0ejNQREYycjd2MGlVTVd1?=
 =?utf-8?B?SDRKRkpwRy80NjBTL0M5Y2xsK0xHSnRXQ0k1b3IrN25qY1M0SXRZMmw4VFNn?=
 =?utf-8?B?cWVLL29OUU13V25jc0dkd1pEY2kwaWhxaEJqd3NMOWVLOXBlL01BUTlpY3lv?=
 =?utf-8?B?VXExT09EeENDc054KzZWMTZFSGpkN2xjSjdlZFkwMm5aY0JhNHRMd1hWemZG?=
 =?utf-8?B?SUFwOVR6aHlleWtQQzFjRTRGSXVCYUV2WDhEZ0NrVjc0RS9ZT3RaRHlnOFlX?=
 =?utf-8?B?MFYzV3kvd2dLSlZteCtxQ0FucGl0d0RhOCtLUzZMRzI3Z0FuTkxVUEhFREpq?=
 =?utf-8?B?SkQ1V2U4K3JHT1JvVzN3VlBKYkd0V3gxZWZGZVE3bndlOXJiall1Ri9FQWRO?=
 =?utf-8?B?QmpnZjhTU1pOVnVzb0luZXV3V0g2STFDUzRuUzQ5WGZzUFNtN1hwcmNHQ3RK?=
 =?utf-8?B?SzFOZGRiT3dDald0bUhsTTkxeVprRDNKbXlpZlZTdm95SHRaSjBkODVZck80?=
 =?utf-8?B?dS9FVDhqNlRGY256Z2ZhMG54aG1VSWlCOHdISFM4U0g5SjZNbHpqT0daamF5?=
 =?utf-8?B?REE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e139e2e4-71a6-4022-99a1-08dc21a3608c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2024 14:54:36.5844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AoYa/u5NwdZtxceRRB48hQLosh14Pxda8CIKevd2zNMPtapOtNBGMiZwEiNKN3FFcivv5ykIwDJGn1I7cpG6Sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5862
X-OriginatorOrg: intel.com

On 1/30/2024 9:38 AM, Edgecombe, Rick P wrote:
> On Tue, 2024-01-23 at 18:41 -0800, Yang Weijiang wrote:
>> -bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
>> +static struct fpstate *__fpu_alloc_init_guest_fpstate(struct
>> fpu_guest *gfpu)
>>   {
>>          struct fpstate *fpstate;
>>          unsigned int size;
>>   
>> -       size = fpu_user_cfg.default_size + ALIGN(offsetof(struct
>> fpstate, regs), 64);
>> +       /*
>> +        * fpu_guest_cfg.default_size is initialized to hold all
>> enabled
>> +        * xfeatures except the user dynamic xfeatures. If the user
>> dynamic
>> +        * xfeatures are enabled, the guest fpstate will be re-
>> allocated to
>> +        * hold all guest enabled xfeatures, so omit user dynamic
>> xfeatures
>> +        * here.
>> +        */
>> +       size = fpu_guest_cfg.default_size +
>> +              ALIGN(offsetof(struct fpstate, regs), 64);
> Minor, I'm not sure the extra char warrants changing it to a wrapped
> line, but that's just my personal opinion.
>
>> +
>>          fpstate = vzalloc(size);
>>          if (!fpstate)
>> -               return false;
>> +               return NULL;
>> +       /*
>> +        * Initialize sizes and feature masks, use fpu_user_cfg.*
>> +        * for user_* settings for compatibility of exiting uAPIs.
>> +        */
>> +       fpstate->size           = fpu_guest_cfg.default_size;
>> +       fpstate->xfeatures      = fpu_guest_cfg.default_features;
>> +       fpstate->user_size      = fpu_user_cfg.default_size;
>> +       fpstate->user_xfeatures = fpu_user_cfg.default_features;
>> +       fpstate->xfd            = 0;
>>   
>> -       /* Leave xfd to 0 (the reset value defined by spec) */
>> -       __fpstate_reset(fpstate, 0);
>>          fpstate_init_user(fpstate);
>>          fpstate->is_valloc      = true;
>>          fpstate->is_guest       = true;
>>   
>>          gfpu->fpstate           = fpstate;
>> -       gfpu->xfeatures         = fpu_user_cfg.default_features;
>> -       gfpu->perm              = fpu_user_cfg.default_features;
>> +       gfpu->xfeatures         = fpu_guest_cfg.default_features;
>> +       gfpu->perm              = fpu_guest_cfg.default_features;
>> +
>> +       return fpstate;
>> +}
>> +
>> +bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
>> +{
>> +       struct fpstate *fpstate;
>> +
>> +       fpstate = __fpu_alloc_init_guest_fpstate(gfpu);
> The above two statements could be just one line and still even fit
> under 80 chars.

Indeed, the variable is redundant, I'll remove it, thanks!

>
> All the same,
>
> Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
>
>> +
>> +       if (!fpstate)
>> +               return false;
>>   


