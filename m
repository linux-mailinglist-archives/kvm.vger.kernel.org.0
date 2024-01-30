Return-Path: <kvm+bounces-7430-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E4FD841CC4
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 08:39:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0981C1F27A64
	for <lists+kvm@lfdr.de>; Tue, 30 Jan 2024 07:39:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA5E253E3A;
	Tue, 30 Jan 2024 07:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nATXN0NI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C8553803;
	Tue, 30 Jan 2024 07:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706600336; cv=fail; b=EIxb6ssw9UTJmvmkkK9piFk2iKhqKvZlWdp6YHpy94PtaYUMtFfC2f9v4qqkqSR4jw0xy1BIZrlIaUbSUDEeAaAsToIYGIl0Hoy52yp7iLGlo0kPTq5toi/9bye2SjmrXPjbjn8xiFJREN9ZOEnhg9fH3wz0OFTeJSQAw0YL72U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706600336; c=relaxed/simple;
	bh=NUBJ021WZWy3ibD1umDy+uZijVTaX+jkL3q1AB4StCc=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=V/vGyuMEAnPIDoId2DfEcERO/1ogMaZ5GKO2UbGNFMO2herYU/1tJ9Xt68sIcuPenwMo7n0EShl3XIpTGy0MY4XCTe3QDFj3GEyWyo21RDT4dVCVAF+tEIdL7R6Ey8lk84jlWTCruFMSZOYnYpnLnw1F7Ol141yAnNm1lnb3aFc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nATXN0NI; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706600334; x=1738136334;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NUBJ021WZWy3ibD1umDy+uZijVTaX+jkL3q1AB4StCc=;
  b=nATXN0NIOLRbryei43LOwSrdwcYmVRFM6xFVynsVXWFWVw2CSTw2qhG7
   b3rmLjvyEaiy7L4mMyV7qQegeDQYl6AllaR3jKBqrzIktOTw4QItfSr3K
   hPIetc1jSlj/2CRPb4VY6+CSaf/DBbqIX1FTC09+lcjJYPqpsVK5EBZJa
   noDZ4efG7VSJeYBUUXeNgiV/C6z1LOrsrDkSTkHjc92yGjDugx3Aeu3TO
   t2gE8V1pcLOem1eZ2oApHFKTk4vM5Xw4pcN2FGZJkx5l+axcjqQSMY56/
   qepXSb5PJFHCcbhH8/l/oDTG+djslaxirfWJYnp60cvvcg0xvU5thGt9T
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10968"; a="21713814"
X-IronPort-AV: E=Sophos;i="6.05,707,1701158400"; 
   d="scan'208";a="21713814"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jan 2024 23:38:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10968"; a="1119169635"
X-IronPort-AV: E=Sophos;i="6.05,707,1701158400"; 
   d="scan'208";a="1119169635"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 Jan 2024 23:38:53 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 29 Jan 2024 23:38:52 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 29 Jan 2024 23:38:52 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 29 Jan 2024 23:38:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=keWb5dQ5Dk1UY614GAelB7cY9OOazR/4YlcFAh5QDDP2/R2oY9jPbXAm6UjW0XfpnkXE+oLpaO+TnkIRuxG59G5UuigSXGCihwuq+w6RNqkWLGp9BpgQKVfGyg6gNvZ1/nAKRcS+5ZURiCaOzezfwHX0qfgaIc2a5iXqKx+7ZduZK5msW7AAxXtovxCDK4FbAQB8MW5FjLj4h4HpJxkspNSBX5BlBmHiGU9MWLDwWt4DgYRH3l1fRQKXG6o7vHr0VQr9GrOIvxKjgtjoEVKhG5U9ZJteDhe1XdLpUdutF18Qvx9rzj4RXzFBXJnoJMYqFKcrBtqTXb4Udw5Gyzi7qQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L2SHxYIc1gegGA/mOiHhXbOO4B+RpfCMAZC38NLlRz8=;
 b=cs6SqQVHuqtCmr4gQSnRdBrFoUIGFc4Aaer401+c2sSEPbM1QZuXdFPorIslQYF9cMWCcS7O/RrGhk+gP3ZBjnRKuHb3/Gom15/vhLhFCkMBmhhreCWOB6R+FZ5vzJkhYasB4uHhRN9vLfVn0IZNzj1tOaqx8x+/1rzJeA/y7G7Rt/wNnOyGflclwR/rC0InyB/Sg4c+wRua4FwWwYpZ4ArAB8T8n0A/egBqikh5M9MFsd0FOO7po5MJ2yhlSjSKdBzmnfbXMR1NRCGl2tUVcqt+CFK0QbwD5J4uOpTMOLtbWFM7YesJF52VvUX2DJmIYWfNsODVvlYcr8GoSdbbQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DS7PR11MB6269.namprd11.prod.outlook.com (2603:10b6:8:97::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.22; Tue, 30 Jan
 2024 07:38:50 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::5d67:24d8:8c3d:acba]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::5d67:24d8:8c3d:acba%5]) with mapi id 15.20.7228.029; Tue, 30 Jan 2024
 07:38:50 +0000
Message-ID: <073cc3da-63ef-4913-9c20-f4fa090751cd@intel.com>
Date: Tue, 30 Jan 2024 15:38:36 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 26/27] KVM: nVMX: Enable CET support for nested guest
To: Chao Gao <chao.gao@intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<yuan.yao@linux.intel.com>, <peterz@infradead.org>,
	<rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>, <john.allen@amd.com>
References: <20240124024200.102792-1-weijiang.yang@intel.com>
 <20240124024200.102792-27-weijiang.yang@intel.com>
 <ZbdOB5YWX8CGsEHC@chao-email>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZbdOB5YWX8CGsEHC@chao-email>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR01CA0021.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::19) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DS7PR11MB6269:EE_
X-MS-Office365-Filtering-Correlation-Id: 728c258e-b963-4376-7233-08dc21667ff7
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VlN3Kopctm6eoAhpLRQZ7Zx0sW09T+gQ+ZYFIrKnRks5KpiHUOtIRhgNenXvsH+a0ac8rqpYZxQYV69Kp+kqXSrJSnhera2goDqqAqbQHIhwiV4gA7TtcYjwsx8/oaa1LaYlCsTCGXwORZqMxBxdX59Wk1d7Urr/rCBKu2KLgHeRa/d1iIfI/lSJbGZ2NxsfWge2LYyyrWcbMvHbu9Im01p37mxSXoogtF4P31HRO9DFSJj6fT8g0KC+0jPdU8De+ERQvrvI9u1dqWDzac0K/XFKr2XPYsynUxtxMrJYqoo4IS9Vf9ge2gpGiCYUqgCUEyaPTRD52TxEh6yiC7UqZCMidunc3PK7yR7iXu7mH2ebOXbrztPmcUNP+xkY5/O4BB48+9IbKIjVaaabI987Trcqaa/vEuB14fT1csMi3cPY6Px8OBQD+8vRqqDAZ4qHrQC7m0QpzjKGQaGlvD0ihi54HCpik+9/jhPAL8DPVc+AdzGM4h6i0S3rUOPW+yb+mc+Nj1PLjnhAqjCtE1QikfQ5ytI2Wyf5pAHEodgQgdltxsn2XzB1DtQNJ+7dZWNDKWfbZ7fIRz9++9faY5dirZaraoh/rEWvfhwCo9qdt61oWyN7jk1zlb3f150tsvPwECnOKCyCEEh9X1/uXWqOQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(366004)(346002)(396003)(136003)(230922051799003)(186009)(64100799003)(1800799012)(451199024)(8676002)(6862004)(4326008)(8936002)(86362001)(2906002)(5660300002)(31696002)(66476007)(66946007)(66556008)(37006003)(6636002)(316002)(36756003)(38100700002)(82960400001)(53546011)(6506007)(6486002)(6512007)(478600001)(6666004)(83380400001)(26005)(2616005)(41300700001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ajM4Z092end2YkNXcXU1dUs1RENZVnRHaDVvUDMyTFVsb1h2Q2JzNGR4VVpY?=
 =?utf-8?B?eWZQaUlhK09scGtib0VHbi81UWRGK2ZoalVZelVsd0dPanNOR2RUWDFNeGVh?=
 =?utf-8?B?K2puSjlnTmtzZHkrbDJGMjFleEZXcXVDbHF2Sm9RbXRCUGlUaURRVWtBN0xL?=
 =?utf-8?B?SHloZlcwOVAza21CN1I4TkpxcDZRYUFjQnRWaXVCOGpNZUVxR2dJUmhFQ3ZJ?=
 =?utf-8?B?aGJTWFo0eTFDSW0wN2YyWDIyUkxOYjhCbzlISkQya0M1NGVkVnJRenFHcVZ2?=
 =?utf-8?B?dHl4OVBkWE1KVjNsZ3lGUE9idzU4V3NFZTJqTy9Wc2Q5UjltdWhleXVReVhx?=
 =?utf-8?B?WmdWQlIzTlU1U3hlUEg1Y0JycG5JQ0tVcGpZRWdYUWp6endqY2c5alM4ODhC?=
 =?utf-8?B?OFZqS2ZyRGdvaTdUVklFWVE4UERRbGZyKzFJUDc2V1ZxQ2xJZG1qeDIwcDRT?=
 =?utf-8?B?cGEwc25xblgxaWRkbUZzTVA2QU80a1ZJTzBsYmRHcmVYN011WXV2VzhzTDBL?=
 =?utf-8?B?bFNuc0lyWFNVMVgwOEI3K0hJTmdKR3hBc0o0QUhHYjNEQ2pLT0RBcUxJUTRE?=
 =?utf-8?B?TGtoOUt3Z3FEOXdqRGtFUVRpaWFtVmlwMy9SK1JZemlrekxrZ29IZVpZdkZ1?=
 =?utf-8?B?MmNzSzEybDBYQUtmdkxmQVZNa2FQK1pRbDZsb3BSNjdJSXBWTjZXRVdKMXFC?=
 =?utf-8?B?dnZHbGh2ZmNndnlvVjZzL3BZSnB6Z0dFUmVKOVFuclhiSjVxa09GQW1MdW9Z?=
 =?utf-8?B?bFF3bVN5UFlaYTlLWGpaTFgzNWpkclpQRWEyTi9MUngxSXRkS3IxMlRmUG04?=
 =?utf-8?B?djB6S2JydkU4a1Rxc2JZNGFIL3hpQW1YaEsxSlQ3N3ZwV0cyeEdtVllNZndp?=
 =?utf-8?B?NkhJZ3U1S2xxN29EZHBNMFIvWU9WYnZIOTRrR2FhTEtXbXQ5UjlTL29xY0p6?=
 =?utf-8?B?WEFoZzJvUmRhOElSN2dLSlZRZUI0eTBqWWxMVjNrWTNoNDdOMjF3eEV6L0JD?=
 =?utf-8?B?RzdxTXA4ZkhJVGtMNHFlOE43V01HSkhEUWtBUjNZdkc2TGNrdzdTNnNzQldy?=
 =?utf-8?B?WFpzU2NnbG9lZk9vRVU4MHRuS1pTTWZKQUEwSjlpUG1nNDV4NUFkT2VhTHBv?=
 =?utf-8?B?NXJSTXZlLzVLL1NaR1ZReHFkZDk0dDlBZlRKK0FIZVQvaVorT2ZtQkIrUkx2?=
 =?utf-8?B?VGU5OU9Dckl2aXdaMzZBRDcybmM1OTI4ZlQwdkFIVy9mNHRMUC94NlBpL0k5?=
 =?utf-8?B?eUtsQnFHYktINDlVRGRrcE93VGxRaFhmMjY3VEdwNjI3YzJQcUFVM3Yxa1pt?=
 =?utf-8?B?NUk0L2laaTZkZkpPZUw3TGg2Qm5OWFhjTzBrYitFVW5SK0ZieWhmd2NtSHBx?=
 =?utf-8?B?UGhZaG9jQ2xidEhteE5aRDQyYTYxTFNzbzFINHdSMWN5cHp5MXd6OG5qVzRa?=
 =?utf-8?B?SmYxZG05ckx2U0tvNTVQeXhOdFJNQVo3QjVYNmZwaktjYkVtNkRjc2NLSk5B?=
 =?utf-8?B?dzNBYWdDVmR4cTNDQ0hwKzVmdzdqN0d4VG45VmV0TXp1aWdjS2JIcWhZZGtT?=
 =?utf-8?B?VisyN045MnV4b21VOVlSVGlZKytWRDd4c3ZMVmxCT3lpdGJ6SGFMZllha1dt?=
 =?utf-8?B?TEw3YTJFYnVMSHpQbUdvSlhLNThnNUg3TTllNDRzTWVoTFdmdGdhbEFSUDM1?=
 =?utf-8?B?NVdqbEtsNWx1KzcyK0lyc1FRV28wQ09MZXVlOGMzZmpTQUlkeUo3a0xNV0R6?=
 =?utf-8?B?WEx1c0tNUit1eUNzdE9mRGw2YXVjbVRSNDdvWGpMdERER0JrWXBnM3p0dFps?=
 =?utf-8?B?TXFXMXlSUjB3Uis1NVg1VGg1by9EMk42RmI4R01MbFk2b1JJbGovaGQyNGV0?=
 =?utf-8?B?WFJFSlZFdGNTSE1xaGdvU3NlcVEzSXNtc1BKMjZCMW5MaldiK2I5MTB3bWxa?=
 =?utf-8?B?d1hnRXN1RVpwK1M5cEhoMjRPNVk3enovU2tNREJhUUtFV1QyclFVankrMmxH?=
 =?utf-8?B?ZElrdHdzNkwvZzBveWxFQ0k1eVdFQTlrU0czSnFHQmttWnBsbkRZdFA0OEND?=
 =?utf-8?B?aXdhOVJsSG1kQmlxNGJyU21DOXJBc3dZU3hBT2JONnNxbndlRkZ5ZllLUExC?=
 =?utf-8?B?U291T09GK21Da25FVVNpUEZOb0luSi9Xd0ozekFibnVxdElYWlI0a3RNSjlN?=
 =?utf-8?B?R2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 728c258e-b963-4376-7233-08dc21667ff7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2024 07:38:50.0266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +s3sz6E1cNvb651If1kl2NAillTEaH3Rq2UZfwHmQubP6CUtc6oWPU/C4kYOIQ4q6HkKgv2QkuHueosesIvdhg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6269
X-OriginatorOrg: intel.com

On 1/29/2024 3:04 PM, Chao Gao wrote:
> On Tue, Jan 23, 2024 at 06:41:59PM -0800, Yang Weijiang wrote:
>> Set up CET MSRs, related VM_ENTRY/EXIT control bits and fixed CR4 setting
>> to enable CET for nested VM.
>>
>> vmcs12 and vmcs02 needs to be synced when L2 exits to L1 or when L1 wants
>> to resume L2, that way correct CET states can be observed by one another.
>>
>> Suggested-by: Chao Gao <chao.gao@intel.com>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
>> ---
>> arch/x86/kvm/vmx/nested.c | 57 +++++++++++++++++++++++++++++++++++++--
>> arch/x86/kvm/vmx/vmcs12.c |  6 +++++
>> arch/x86/kvm/vmx/vmcs12.h | 14 +++++++++-
>> arch/x86/kvm/vmx/vmx.c    |  2 ++
>> 4 files changed, 76 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index 468a7cf75035..e330897a7e5e 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -691,6 +691,28 @@ static inline bool nested_vmx_prepare_msr_bitmap(struct kvm_vcpu *vcpu,
>> 	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>> 					 MSR_IA32_FLUSH_CMD, MSR_TYPE_W);
>>
>> +	/* Pass CET MSRs to nested VM if L0 and L1 are set to pass-through. */
>> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>> +					 MSR_IA32_U_CET, MSR_TYPE_RW);
>> +
>> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>> +					 MSR_IA32_S_CET, MSR_TYPE_RW);
>> +
>> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>> +					 MSR_IA32_PL0_SSP, MSR_TYPE_RW);
>> +
>> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>> +					 MSR_IA32_PL1_SSP, MSR_TYPE_RW);
>> +
>> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>> +					 MSR_IA32_PL2_SSP, MSR_TYPE_RW);
>> +
>> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>> +					 MSR_IA32_PL3_SSP, MSR_TYPE_RW);
>> +
>> +	nested_vmx_set_intercept_for_msr(vmx, msr_bitmap_l1, msr_bitmap_l0,
>> +					 MSR_IA32_INT_SSP_TAB, MSR_TYPE_RW);
>> +
>> 	kvm_vcpu_unmap(vcpu, &vmx->nested.msr_bitmap_map, false);
>>
>> 	vmx->nested.force_msr_bitmap_recalc = false;
>> @@ -2506,6 +2528,17 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
>> 		if (kvm_mpx_supported() && vmx->nested.nested_run_pending &&
>> 		    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
>> 			vmcs_write64(GUEST_BNDCFGS, vmcs12->guest_bndcfgs);
>> +
>> +		if (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_CET_STATE) {
>> +			if (guest_can_use(&vmx->vcpu, X86_FEATURE_SHSTK)) {
>> +				vmcs_writel(GUEST_SSP, vmcs12->guest_ssp);
>> +				vmcs_writel(GUEST_INTR_SSP_TABLE,
>> +					    vmcs12->guest_ssp_tbl);
>> +			}
>> +			if (guest_can_use(&vmx->vcpu, X86_FEATURE_SHSTK) ||
>> +			    guest_can_use(&vmx->vcpu, X86_FEATURE_IBT))
>> +				vmcs_writel(GUEST_S_CET, vmcs12->guest_s_cet);
>> +		}
> I think you need to move this hunk outside the outmost if-statement, i.e.,
>
> 	if (!hv_evmcs || !(hv_evmcs->hv_clean_fields &
> 			   HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1)) {

Yes, I should move them to the  end of the function, will do it, thanks!

>
> otherwise, the whole block may be skipped (e.g., when evmcs is enabled and
> GUEST_GRP1 is clean), leaving CET state not context-switched.
>
> And if VM_ENTRY_LOAD_CET_STATE of vmcs12 is cleared, L1's values should be
> propagated to vmcs02 on nested VMenter; see pre_vmenter_debugctl in struct
> nested_vmx. I believe we need similar handling for the three CET fields.

The code used to be there, but I thought it's not the valid usage model, so removed them.
After a second thought, I think I shouldn't assume L1's CET usage, just check the flags and
sync CET states between L2<-->L1. Will add the handling, thanks!

>
>> 	}
>>
>> 	if (nested_cpu_has_xsaves(vmcs12))
>> @@ -4344,6 +4377,15 @@ static void sync_vmcs02_to_vmcs12_rare(struct kvm_vcpu *vcpu,
>> 	vmcs12->guest_pending_dbg_exceptions =
>> 		vmcs_readl(GUEST_PENDING_DBG_EXCEPTIONS);
>>
>> +	if (guest_can_use(&vmx->vcpu, X86_FEATURE_SHSTK)) {
>> +		vmcs12->guest_ssp = vmcs_readl(GUEST_SSP);
>> +		vmcs12->guest_ssp_tbl = vmcs_readl(GUEST_INTR_SSP_TABLE);
>> +	}
>> +	if (guest_can_use(&vmx->vcpu, X86_FEATURE_SHSTK) ||
>> +	    guest_can_use(&vmx->vcpu, X86_FEATURE_IBT)) {
>> +		vmcs12->guest_s_cet = vmcs_readl(GUEST_S_CET);
>> +	}
> unnecessary braces.

Will remove it.



