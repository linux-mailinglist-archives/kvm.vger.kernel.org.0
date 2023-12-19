Return-Path: <kvm+bounces-4758-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 77784817FF5
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 03:51:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id ECD771F240D8
	for <lists+kvm@lfdr.de>; Tue, 19 Dec 2023 02:51:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 997FE6FC4;
	Tue, 19 Dec 2023 02:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="inkivkYl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83FE163AC
	for <kvm@vger.kernel.org>; Tue, 19 Dec 2023 02:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1702954280; x=1734490280;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=yVU5R3GV/2oSmr+561vZm9AufOacgWn86MBKFa0WHAY=;
  b=inkivkYli0eGjdodY42cS504bVy+qk0fNYeLLTL2QXQLg/DoA1gn+LU8
   1TekppWCvBMmpkZZ2dq5Y5rqf9JQFqsHXrsr/gUgXU5BGKQosOSootX+F
   XqWe4wz84MR4NTA0IP+TWuITZuTstWMbFF4Hy7npB0MV+f7UaZ7QZ31Q3
   7i7Dx+rcTywYOvv/UvLxYTby7on3pxOlWmOaKyglGtnmjizq21OzPIBfC
   AGc2ZkB1j5UpN9qIYlN7te26Fh7Ii+vLVEwcZgQ0ZvTCyQEql63CDgtQ8
   DLUs39QNscVIqH2PYwkMzofTmSYvw07faxVUazrWAhOiWmetusJlgHiQu
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10928"; a="459939860"
X-IronPort-AV: E=Sophos;i="6.04,287,1695711600"; 
   d="scan'208";a="459939860"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Dec 2023 18:51:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,287,1695711600"; 
   d="scan'208";a="17436061"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 18 Dec 2023 18:51:21 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 18 Dec 2023 18:51:19 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 18 Dec 2023 18:51:18 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 18 Dec 2023 18:51:18 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 18 Dec 2023 18:51:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FBiwR0oCcXQdYutVpm16tEdXzYzbV8uvc3l/46bnznE5HJMfX3MkkAj5ydHmkFLhLVOx3JMnSNfd5mTpoxpNkL0G9q5hMUWPwAi5crKgWkpBVo0/c9DCESgqCG+USYBz4IDneg7qGJwqhimfWTpFGTWLWVHvex1D+Dij8VGepgEQ945iVvWWdGR1nbY7hVQZ4oHhbJ8TRDEq26FzgAfdjPitY91Q5eZ17qksjjhVFr+yNOw9DeWGsPGPjGFDUCBKLdRPX60fAkM738GG5samnC3ZGB4qoLwlNKMSXZF84+wJ+d66Mg9bvnUfoZ0W7X5qY/pEZVo1TTG5rcDe0rS5wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TVubmkRiyHZRg/ItsbTiAhAnLziBYPfYG73xOZ+hpHM=;
 b=BfDdIgaiGOPoJ19GYJHlqjbhf2G5r3RCDQIn4sC1MOAFk6jSDlzxum28mrEGZLLFBXW37QR9/QSzWklP9ctFOeTXY2QHITqA0zElZz2qeLYjKV05hj7PM+HLsEh4JMVMtrgkyx6rgceQv191JDSvyCKnDjU1jB2Npot5z89kRfQ/LzXNcyQ7c6nBkkVYbTA/SsJYeXeuXEpP9ytFlvsMcplfvrLppu/aLX7nDyndcTYJcs7D9RK2Iec6LRlHiLXCcbYdGL+fS6oCy76rjAp7IX2BGndYEUTIfm5qjvZVT3+cq5z6N/5PojvLCBnMVrChEk7fvGxXXZqieCMte6UBGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by LV3PR11MB8483.namprd11.prod.outlook.com (2603:10b6:408:1b0::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7091.38; Tue, 19 Dec
 2023 02:51:16 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::66ec:5c08:f169:6038]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::66ec:5c08:f169:6038%3]) with mapi id 15.20.7091.034; Tue, 19 Dec 2023
 02:51:16 +0000
Date: Tue, 19 Dec 2023 10:51:05 +0800
From: Chao Gao <chao.gao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Tao Su <tao1.su@linux.intel.com>, <kvm@vger.kernel.org>,
	<pbonzini@redhat.com>, <eddie.dong@intel.com>, <xiaoyao.li@intel.com>,
	<yuan.yao@linux.intel.com>, <yi1.lai@intel.com>, <xudong.hao@intel.com>,
	<chao.p.peng@intel.com>
Subject: Re: [PATCH 1/2] x86: KVM: Limit guest physical bits when 5-level EPT
 is unsupported
Message-ID: <ZYEFGQBti5DqlJiu@chao-email>
References: <20231218140543.870234-1-tao1.su@linux.intel.com>
 <20231218140543.870234-2-tao1.su@linux.intel.com>
 <ZYBhl200jZpWDqpU@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZYBhl200jZpWDqpU@google.com>
X-ClientProxiedBy: SG2PR01CA0194.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::22) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|LV3PR11MB8483:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f1ea84a-a2d6-4637-eef4-08dc003d5e35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: laDKXqQGwuHtkq9TEfhmQ9B/YlVWlCtDay66ytmSh9T+oNaB/zD6xk0NRaaOI2GKQpbMG+wL866PpM0gOFsW3YvxO4EkvyZUOUADrMPwlsOOUZCsyMJvk/HO1/MOGtT7bZBIxpr8DnQM11tsv2NfH81obYyHz4jOZgU6TrVk2dbLsTW5NpKP+CM8CPWQ3DqcfM3OY5kZRvB9UHh+inpLvsqNelAoWjhOLzJYuKXcghOV0kxwK6aYNM+pe9Vf2M7CCY+200SbM5kvLcRRvDxwbsT3n/KX0xv8ub+6JWjByxjjDm7RcmA+894B7YixL1yUgH3dOWblpOPMjqQg9KnLO4PZcwEGnZh2CejG8a+qIrNzqSNIAwpa5EqCId/Nnx3l2UU2bAqUObv6EYCaNSeByCfUqC1eZOor3zbUhTNvmmY2/GmIMTk0RshB4mJjLkqNc4bgCQj1hszWwtgvmotn9SrTkzVIHuZz21rUKXH8kJYXIO19NS+tjIZ3osyaXzPvZg2rxL1KdItv3J240SXgLGHnQG+1fpSR6m96HqD5oFli3PZxhKJrPJraFc56nwhy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7916004)(136003)(396003)(366004)(346002)(376002)(39860400002)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(66946007)(316002)(6916009)(66556008)(83380400001)(6506007)(66476007)(38100700002)(2906002)(4326008)(8676002)(8936002)(5660300002)(33716001)(44832011)(6666004)(9686003)(6512007)(26005)(478600001)(6486002)(86362001)(41300700001)(82960400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?l25f1zuptLgpHpr9zG9JfW4+W4SoKWtS0W+vX9KfQmwh5gLZk0LTgArQvlmA?=
 =?us-ascii?Q?lfArgNIydw8NmEnuN8bsRYsYMiZPH7IClEdH1DssStPTnLzyTYIQVdfMdtQN?=
 =?us-ascii?Q?Lf1H7cbcyH00P91zj6pqjo96OjHeRp3HLX7rwingIpOrNGVhetqmHVKC9wg2?=
 =?us-ascii?Q?++knsirvM68sisNcarN8Nnr/qoBB7Yzf35k65TNioQSYyixBf8ftZSZn/Kgi?=
 =?us-ascii?Q?X0GsGinbDgue1qGG4Ns6e9A6LUzJyx9JSFPNdTMFEqiPzmc5Mj2HipHEH0+t?=
 =?us-ascii?Q?giiPNYBuEV5IExUTs3thYD9cYFKmedJa5bBO5+N7uGKFx+L7mSLQDb/YF9Rv?=
 =?us-ascii?Q?JIwIa9uHoD4yXuxIfShIXKj3hXEputxaSJJUF5boyu8shJQehbSviodZrXs2?=
 =?us-ascii?Q?YylUNMr3avEw+h4+3AEvaLpna9ZH8AN4L2IcCKePrdPXHzFhlor8Me0gea23?=
 =?us-ascii?Q?NHhMFCX3Bg2lpGah4xGJLdUlJEGdUJns5eEGOwJZ1J6eajv+htybjuSX0xtE?=
 =?us-ascii?Q?DhIFOtGyE+q51UsscqTj5n+te+GTCizL6cfFvCB6m3nliRgjMFv5GVaebRGz?=
 =?us-ascii?Q?6EQvCCNrnQkMJaQdqMUeRqY35WjJzL7uUg7K+8sZ8KMdtimIMXS2unEiBZvS?=
 =?us-ascii?Q?71yD1IDEz+HUautPs3N0Vy119vK2HcStnr+lHe6PanxB47vvBGWdptahtNvg?=
 =?us-ascii?Q?Gyac7mHxK5xLxiLN1TzOaIfbP0z8/AAnlrc6J4a53UmM8hxRajgzJOR4Jwql?=
 =?us-ascii?Q?FLA68cFqopXEnsLZZuA36vt6CY4d6ejVDiC+n1wV/TEpdQ60AAWr6A9Qtre9?=
 =?us-ascii?Q?yCqPZcSgo1ItlDJEBau1OvCSxw0ukidLdoG1JqQDhw/e/XgPBHmXgMbwjBBF?=
 =?us-ascii?Q?q0rWkDX9aaPmO94r8C/HwqeU+77LqwOlWAXamcbfWGnDtvXOvJBA5y8kKl+3?=
 =?us-ascii?Q?0DeJnmGdcuoBFJ6tUD2TyRH/TsXXJCMkXE9COuQziyoH+s38/BUeX29AONLb?=
 =?us-ascii?Q?GLqdeJD6n9OgDK2DO+7N1/yLq6kElm0cer+I5ZL5ETdjnuZVt2pmDiZIsrEL?=
 =?us-ascii?Q?TIqwiJOfAKsCaZ6S/Dw8ZCgzB9ttv/U3tBL99itvdSd9WcARSDwlN2e+xc4Y?=
 =?us-ascii?Q?/QD2eyNDHWN+OtAAE6ltxk90J2E9rFhioqxmc1N7CHyQ1piaDKt0aA5rNB04?=
 =?us-ascii?Q?lT/3uYJMPitXc5f6LyGT36aWKfvZob01PC2SF/OsXaLY9yA1VIeZN1cjlsy3?=
 =?us-ascii?Q?DfisrMHLZBxRPfwAz+XNYi3OmTYx7XXs7/4YrzW2cEBNl+iFm3X8a7UMcaQI?=
 =?us-ascii?Q?/EpKcnFWXuFdmYcIDSvjUdqMac0JA/qCjRpfnzC6Ao0AIOXqSLIUuuVmXdvw?=
 =?us-ascii?Q?aDbrrO2WBFbX5X8z4w+OOdR1EMFL1dtMYpjO+oXMFS1zZ9ycbiXEuUYd9OPP?=
 =?us-ascii?Q?WkAkYygNHz/PQLHVPv2OBopIEFkvzHxbWnz82syhFxT2I+Dr313FI67wJ5tw?=
 =?us-ascii?Q?2ky+gMmQyYvqCPGIucN6+FXrRPvu/Mwn2Z5629vwiVQj9s8xnlqSklluGQPV?=
 =?us-ascii?Q?JF9bVYvxU6pimgd08xIqsrrSf6DMY5/ExMo0eSX1?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f1ea84a-a2d6-4637-eef4-08dc003d5e35
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2023 02:51:15.4578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bMuRVHyq97dG5jUX7CWXIDowwJtehN2AVhu1mOaAdS8t68MIAndtrdw7DV5d/gRtxZG37y9ILx7Mnhl0VCaUgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8483
X-OriginatorOrg: intel.com

On Mon, Dec 18, 2023 at 07:13:27AM -0800, Sean Christopherson wrote:
>On Mon, Dec 18, 2023, Tao Su wrote:
>> When host doesn't support 5-level EPT, bits 51:48 of the guest physical
>> address must all be zero, otherwise an EPT violation always occurs and
>> current handler can't resolve this if the gpa is in RAM region. Hence,
>> instruction will keep being executed repeatedly, which causes infinite
>> EPT violation.
>> 
>> Six KVM selftests are timeout due to this issue:
>>     kvm:access_tracking_perf_test
>>     kvm:demand_paging_test
>>     kvm:dirty_log_test
>>     kvm:dirty_log_perf_test
>>     kvm:kvm_page_table_test
>>     kvm:memslot_modification_stress_test
>> 
>> The above selftests add a RAM region close to max_gfn, if host has 52
>> physical bits but doesn't support 5-level EPT, these will trigger infinite
>> EPT violation when access the RAM region.
>> 
>> Since current Intel CPUID doesn't report max guest physical bits like AMD,
>> introduce kvm_mmu_tdp_maxphyaddr() to limit guest physical bits when tdp is
>> enabled and report the max guest physical bits which is smaller than host.
>> 
>> When guest physical bits is smaller than host, some GPA are illegal from
>> guest's perspective, but are still legal from hardware's perspective,
>> which should be trapped to inject #PF. Current KVM already has a parameter
>> allow_smaller_maxphyaddr to support the case when guest.MAXPHYADDR <
>> host.MAXPHYADDR, which is disabled by default when EPT is enabled, user
>> can enable it when loading kvm-intel module. When allow_smaller_maxphyaddr
>> is enabled and guest accesses an illegal address from guest's perspective,
>> KVM will utilize EPT violation and emulate the instruction to inject #PF
>> and determine #PF error code.
>
>No, fix the selftests, it's not KVM's responsibility to advertise the correct
>guest.MAXPHYADDR.

In this case, host.MAXPHYADDR is 52 and EPT supports 4-level only thus can
translate up to 48 bits of GPA.

Here nothing visible to selftests or QEMU indicates that guest.MAXPHYADDR = 52
is invalid/incorrect. how can we say selftests are at fault and we should fix
them?

