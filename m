Return-Path: <kvm+bounces-12926-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 958E288F478
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 02:22:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A0412A6D83
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 01:22:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76B931CD13;
	Thu, 28 Mar 2024 01:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HeRZMZC2"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF9553C0B;
	Thu, 28 Mar 2024 01:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711588964; cv=fail; b=KoYyrFjkxfkbsL2W+drUEw7/7Gg77gx4D0fXC4E5p/vlDX02MDwqgP10PUjAwNlbbUonWFNKVCM7EzK+QUugWtmUwtwh9pQPfHv9i5EVsta02YnbywJ9IPEV/0tJ6fC/AWmJAOZCdbNH57a8ZK6BwfSfGatykh9WnQ+4HcuHLPQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711588964; c=relaxed/simple;
	bh=x0Zdo7xvh7+BUz+kjvp+LTAfK4Bt/AbIn4W5UuOM9TU=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=MT55RQ7tTxJ1vwwgcPVpgBJtwipQ51EJOjSaUOfgTcBLMtU4C3bpVp+i2Z5FeNuyHLQosVoBFf75IXFAgYy34j3Qg7+o2FunztSNIe/X6l+5XVtHAnDaCH9Mi4zB6fHcsFpo4pj18v9dOPPc8u87i5K9uLp4z0NxHsZYgBU5i9g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HeRZMZC2; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711588963; x=1743124963;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=x0Zdo7xvh7+BUz+kjvp+LTAfK4Bt/AbIn4W5UuOM9TU=;
  b=HeRZMZC2cTsNJ6/zI1n/Fyu9iCQZXwrZdpmOBd/31s5dwgbxftgL9ZP5
   Kl2o8SuTVz5SzyMn6LI8NgLy0nelg/fMurjpNXpHKAWV82XnexkGOXpqc
   phTwBMB7ha/jkK6k18LgcsNhhm12FOz5p6jS4yYPSe9utPAUKReeNq506
   9jVw9vi787LBqJ5OecIdfw568MYVIQhQcamWEPZa/Xyjsbfmee0BtBER4
   I/r2sgKUPqP3WGOEMIhCFP6tuAG+DzHDSHQ/lKVBHor4mX0kB62prHC5C
   mChRHcUVmwBNHVs9S/8UYiYkaYUEfo98msDr38yxaQnOMqtsh7vTue4ug
   g==;
X-CSE-ConnectionGUID: ZpwFSe5DQJys3OkAmFcZGQ==
X-CSE-MsgGUID: 7WSogK2cQ0iNDQP3PumjZA==
X-IronPort-AV: E=McAfee;i="6600,9927,11026"; a="10505097"
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="10505097"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 18:20:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,160,1708416000"; 
   d="scan'208";a="16505941"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Mar 2024 18:20:10 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 27 Mar 2024 18:20:09 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 27 Mar 2024 18:20:09 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 27 Mar 2024 18:20:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c0XZSzJjhPv1dAO5mFMHPuHQ6ByhaAVWLHdV6lmFAoeSuN3Z9JxJZh4RC58opVeyMu57I2fMgeYVRRNjYwg0cyADymY0CmJcwOj2f3YZYdln44FPykKDMoOnvcMXc/J3Nj60l4YNjuJMTyGjbjrGjBbTGueD71K0PKYC6FzxGfWZMSvU2Er3hLTBIhinUNB7uZe1pUGzHo66RF3PM5maBw2H7xXr8SufeifO+vaawNLphyAsSv1lTvrdyxad44Z70HBBSiwk4Ga9FtV1IgSsOqyJa8O7LgHBXEZ3D49PumXzjt+RpzNRbTQYnsxV0QtLHCjVCWJhk9tRF3pkdQNDgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KmF3rB1/osDaq3djuFPlM8o3mLRce2CEZOARCQOm8GI=;
 b=KlvMz8KnO6AzrxBKpIwqwU4VPKN7g0JZNy3z8aWy1C/uTLKcV4erAnvOSariGoPnqPwMGVpgWctJDDlBoiLke4C78X4YOrME2WsKXCmqV+xNqmWYqo5OTCbTwWCd4oLb3VovRJ208rPzWdUVbQjDnNjSZWgoXaKMQypvSPTQGCiS0YOGVSHLdTNMa1faVg8VeNke9NPVrvhL/1ls6B35C0HNceGruILfWU+8lz3LpXyysfqDEhBKoshmV8tcR1kkcCtOaSMDICfEfLvdyundtsgqC5fx4mxUwJDmopM1rMLphUJW5m2WhS3Yi2Ar7UAm65YyWnf6G9jALAJxbfAH/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by SJ0PR11MB4894.namprd11.prod.outlook.com (2603:10b6:a03:2d4::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Thu, 28 Mar
 2024 01:20:02 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::3e4d:bb33:667c:ecff]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::3e4d:bb33:667c:ecff%5]) with mapi id 15.20.7409.031; Thu, 28 Mar 2024
 01:20:02 +0000
Message-ID: <b961254e-f556-4186-91e2-76f312604e53@intel.com>
Date: Thu, 28 Mar 2024 09:19:52 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests Patch v3 01/11] x86: pmu: Remove duplicate code
 in pmu_init()
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
CC: Jim Mattson <jmattson@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Zhenyu Wang <zhenyuw@linux.intel.com>,
	"Zhang, Xiong Y" <xiong.y.zhang@intel.com>, Mingwei Zhang
	<mizhang@google.com>, Like Xu <like.xu.linux@gmail.com>, Jinrong Liang
	<cloudliang@tencent.com>, "Mi, Dapeng1" <dapeng1.mi@intel.com>
References: <20240103031409.2504051-1-dapeng1.mi@linux.intel.com>
 <20240103031409.2504051-2-dapeng1.mi@linux.intel.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <20240103031409.2504051-2-dapeng1.mi@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2PR01CA0010.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::12) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|SJ0PR11MB4894:EE_
X-MS-Office365-Filtering-Correlation-Id: 1cd8a18a-ad96-4d70-3846-08dc4ec530e5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UO4bCfCpO3FIelyRhCDqySzfrJmFJbgy+RZizRgpSoDiypoHTL1CEeshTMqWufPycc2YvnKlEcPgzuqteeOH+/8iq6ndMQdTvu3Rvycs7Okg0BmChVhBpFakOkXwZAjaWI7r88FfElHODRyLGeZuhXpNUAKlDE3myvsmYVDwTK4PHujqEtGQ57NUQ5NYNw11v8qGQ9vdFd+2nc6LLPPsq16mEcAPGa4wKZ/S8AnASLZXejvOvtlu+cxBSuX4uvloQhZ+lsZH2rbqYzO32SMlAxfFJM/g3gu+f6tPmcfGoUq1ODJH+yjnHDfs9JxYFfZaoujAd6tlCgXtEAMcYd+2rdkztVbsgiCVhPbf0R5p514kw6R5gHpvz/DxtOUsavLS6+CsE3jlZui+RZ0XOSGjq/x8t5D0BqodgPptlkqeHfOK9455bo0gna/SxpotJQ6eORI1SK6tvCRdrAFkBgyGKz6AlCgnec3tBJGEYzBmdfznT3ihSsdjNfRlbtZs6AlpKgW/iqFHXyLReJmQwj+DjufOLy8BGu0iAHBJMfpr8mwK36Diw+nj8GoDIL2BntOYnA6NmRStMPWUBY3GHRjWt74ffNo+YMRjLQKAg29OMNQ3tWPcs2CKeF173WBkMYCyyJJA8b2lzUR8UUjZwraC9r8Kbg+3pUTF4yox9wb25TQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?KytwYzVIRC9MSnI3VUtGakZSZUN2UTNCSFAveGh1aFhVa1pLdWkzUk4xQ2cz?=
 =?utf-8?B?VWZoeG9ObGo5TllzaUhnZ2FvSUkrcWpnbkIyVFBKbVpyVDhEa2M0Q3dNQSsy?=
 =?utf-8?B?TzRzdzNsaGIyUG9CazE3TDhwV2M4bGtjQWl3RzB5TmJhamNBMnA5TFgwM1NG?=
 =?utf-8?B?a3NWZEh3NS9KTHcrRUtzM093MHN6SmpQdmppTXNpTFhIeGRLY2EvTGdJTldE?=
 =?utf-8?B?cDdHSDVCN1B1ei9wakNjT1lReCt5UlkxYUVHR1kwUzh1bVhvQjNyaVFxb3cz?=
 =?utf-8?B?ZDhYTjlqeU9QSlVtTktRRmU1VUJjNXpyNDFTQ3F0N2p4U2hVSGRWYjhySXdU?=
 =?utf-8?B?NTFOTDBYcm95aFpqZXVpdkdOTUlHRGFUQWVCZWkwTjZJKzRBVm5GQjhZZ0Vk?=
 =?utf-8?B?ZjhzVC9iWmlPZlJLV3Zuc3RNV1d5V0ptd0kvS0NsTGtVR1l6ajBnOHdpSERY?=
 =?utf-8?B?WjNhTjJ0TW5Bbnl3ek9ub29xU09WWDJUeEF5azF4b1llQ2ZUckFZUmQ0Y0Ji?=
 =?utf-8?B?MFpQbTdEZFBKREdhV2orbWNOWjk5UHlrTXh5VE5DcHo2VmpGTFp6eFhRR2FG?=
 =?utf-8?B?MlZ0dnlSdGlhN1h1K2cwais0S2dKbjh4OEkvNTFXbVJVekNGdmdpYmY0Wm9p?=
 =?utf-8?B?aXA1T3hKdmcrRHoxVUFtSUhYblh2TFh2ZHdRQ251QldWbXNFaWxHZUVSNHNZ?=
 =?utf-8?B?SEtKdGkwMjB3VmdWdm5mYk40TFNkWEZCbGFIVWU1RHgvUEZRYWw4RWhESmRK?=
 =?utf-8?B?NkQxTU1WN0FEVGRGamtXVFl5Sld0OUd2cnhkRkJMbFhybkR6MDB5U2dxVlZ6?=
 =?utf-8?B?aS9ta0ZFR2ZuMVBlWXlocVI3Z01MSEwrWE5NTlBpSnJ1cXVVNFVOZENtdWU1?=
 =?utf-8?B?ZFg4dE14dDVnVnVLbFR1UjVMRGhzV29XeGs1aVFPcUdBc2d5SnRQd0JTQWZ6?=
 =?utf-8?B?RTc0UXJBVU9WZW1jTCsxV2JoNWwxcEpsSXdnRnBrOHRJUjl4NDNXdDdSR21Y?=
 =?utf-8?B?YVFYNCs3bE9LRUZwbW8zQnBuVkd0WTlzSEFXSFBDa1FNMUMzSFg0UnZyeHZX?=
 =?utf-8?B?OU5BWU0rRWZZbkFDWlYwTzhrTllpU3ZwT2o0WmwxOTA4OFNKR0t4UEdXSlFy?=
 =?utf-8?B?ejJaWmQ2WGFmUGx0Zk1QY0dsU3Jscm50UU9CSGovRjJMWjhhUk9BT2F0L3JK?=
 =?utf-8?B?dXJrUXdSV3lqOCtlcUpESjkrd1J2ZlNDMFRONmQrMzNUZTlYMXJycnBlY1BB?=
 =?utf-8?B?dU4xWnRuVUJGWU56UU9Td092cUZyejNvdFBYOFMvL0xyRU11ZHVjTlVEOE9V?=
 =?utf-8?B?QXQ3TTBtbUlCSVlFVG1oYzM5S1BPZStXTzMzbWdjUFhTVGNkY0xWVXlIcXBs?=
 =?utf-8?B?SXlZaTllTnptN0pnN2pQYnhGNEx3ZDNoMDR3Z1dUN1JDT3poNHZaQkdpakto?=
 =?utf-8?B?VW9iS3ViSFhBdWJYU3g5V0NnczlDL1QvampNeFRXQ3dpMFBGOTdHbXBlSjkv?=
 =?utf-8?B?SnF6VTVKYngrR3pGUmw3dFYyeHRIa3Fzb0hCei9jL2VhYjltWUUyL04yUXFO?=
 =?utf-8?B?eURIMklLOGNUQzBMeGU4Z29paXhJaVdkY3dqQzloTXVoN0xQNzNKREx3WnVJ?=
 =?utf-8?B?bi94ZmRlS0tIakJtMEo4elNLU2N2TStSVTFBcWMyNUdjL3NMZ2hTOW82OTRj?=
 =?utf-8?B?RWV2MlN5U0kySEVpTzFwNTZrSENzMHYxZDNKcElZNjMxay8rRHRwWUFpVFJM?=
 =?utf-8?B?bi9IYWhpTzZ1MG9CRlcxcDJQK2JUVkFVR0V2SGFpOEtOOUUwZW5aeVNodis3?=
 =?utf-8?B?RzQ0MDJCcFJKRE5oYmlxVTZINFNTMmxXcXVFRms1QWlmbEtiUDFFVHJOY0hs?=
 =?utf-8?B?dTdIT0xHUFU3UUdYL3N3N1FRcklYNTJ4U1M3MmFsYnp2TDhUU21JaDJOaFRW?=
 =?utf-8?B?c2M3aFJxV3R2NFdsME5VK0RyQVRGK3Z0cTRwdHhkRmRveHZORE5rWFd0Rmov?=
 =?utf-8?B?TTg2ZUE5VWhFMnBTcEQ3N3BXZXk0T09vTjR4SnF3WVBzMWF6eDVDNGo5M1hV?=
 =?utf-8?B?N3lzSE8wVWpnNDlHdER5VDJuM20xckJRTTNMVnBrZllXM0gzay8yU1JYbHFJ?=
 =?utf-8?B?STdrZlp0NVd6bi84aVhFNkZYcjFvQk1qczZQUlZvWmZaWlBaTjV4L3FDdDJh?=
 =?utf-8?B?Vmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cd8a18a-ad96-4d70-3846-08dc4ec530e5
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2024 01:20:02.2702
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0kbeS6g66JFriueM3Ivu2vU5ZWR7+ywQIjLXndTy+VSwFlLEeWOfHIsagbbUFD9BtyZrqGoZIPmKYbkP4W7Suw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4894
X-OriginatorOrg: intel.com

On 1/3/2024 11:13 AM, Dapeng Mi wrote:
> From: Xiong Zhang <xiong.y.zhang@intel.com>
>
> There are totally same code in pmu_init() helper, remove the duplicate
> code.
>
> Signed-off-by: Xiong Zhang <xiong.y.zhang@intel.com>
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>

Jim has already added RB tag for this patch in v2, you may add it here.

> ---
>   lib/x86/pmu.c | 5 -----
>   1 file changed, 5 deletions(-)
>
> diff --git a/lib/x86/pmu.c b/lib/x86/pmu.c
> index 0f2afd650bc9..d06e94553024 100644
> --- a/lib/x86/pmu.c
> +++ b/lib/x86/pmu.c
> @@ -16,11 +16,6 @@ void pmu_init(void)
>   			pmu.fixed_counter_width = (cpuid_10.d >> 5) & 0xff;
>   		}
>   
> -		if (pmu.version > 1) {
> -			pmu.nr_fixed_counters = cpuid_10.d & 0x1f;
> -			pmu.fixed_counter_width = (cpuid_10.d >> 5) & 0xff;
> -		}
> -
>   		pmu.nr_gp_counters = (cpuid_10.a >> 8) & 0xff;
>   		pmu.gp_counter_width = (cpuid_10.a >> 16) & 0xff;
>   		pmu.gp_counter_mask_length = (cpuid_10.a >> 24) & 0xff;


