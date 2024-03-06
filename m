Return-Path: <kvm+bounces-11147-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DEA287398A
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 15:44:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 34E2028B6BA
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 14:44:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1358134403;
	Wed,  6 Mar 2024 14:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M7ZTRJ9s"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A927132472;
	Wed,  6 Mar 2024 14:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709736278; cv=fail; b=GX1KztgNcgpBkie2Tq6DTATuBUljiZKdUBrDdCTcyH4k3R4Vh5CaTon9k3Rz9Viq4Fj4v+efkxOVDsQDpPnrNpRK6Yc4ccZiXuuHf1GWZDIEZ2JKIG3IRWIRyGnR1LKd2WCov9rCvBRRcna4vG86r5mipTKhhR7zeiLgp7TpfsI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709736278; c=relaxed/simple;
	bh=xdTWcr51jNdc6FA5z73Gyy/rJ5KyNzAOT2d1fMkixJA=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=ok1Dq++CLPGDThIs+VH7WgoDfvAcvuFucflhksLQ7kSgwSdpTTksjDi3OZplbXMp0Hy4eWsaR6juoh4UpYqQAzBxhmP2ni6TfWAMvI3/+M6uQ3vHyIdvL54V8JxfsewUj64nLgjC97zMcBrl6zTsQ+QmRK3XyKSjefIeR1I3LSg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=M7ZTRJ9s; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709736275; x=1741272275;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xdTWcr51jNdc6FA5z73Gyy/rJ5KyNzAOT2d1fMkixJA=;
  b=M7ZTRJ9sbg+jckOKBUCGCXMltDH/7WJLYSugbLQXIOSTKOUJWlBs+a05
   BE+knkAiNt82t4cTdR/O/E2+8MB8EpCEnWQiXqLxBMdzWj5Jq/OEOFzZ6
   UhYgafEMu3Q8v4xfUnD2gdd5vWF6sFf9YZfSqopbtM19iUEKopZUy5zMm
   yPqxnim3erfGVqiRHc0li2ag3PN6zxPC1fT+reS/o8c7n2UyYMl/cjZeD
   ldtzQDz7wOP528jIFe2z0C8GRjCybv8nopAlXOpVZiqt+69B9Bi0QsJL9
   r7DjXnHdrkPAG3HkwC9SqogB9w9qDqicdY/q+yDX38qBwXhgVwR6BsyEm
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11004"; a="21873719"
X-IronPort-AV: E=Sophos;i="6.06,208,1705392000"; 
   d="scan'208";a="21873719"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 06:44:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,208,1705392000"; 
   d="scan'208";a="9705566"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Mar 2024 06:44:34 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 6 Mar 2024 06:44:33 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 6 Mar 2024 06:44:33 -0800
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 6 Mar 2024 06:44:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=crpVvpJ0Zqq+Se9IxlPTU1WM2AUJxjSnAWFVNkzhiv3DA0nJzSikHAkeqIEq3P7rubOUWOhGVXGnFAatCzPNYDmCZQ2KQM3FoKC9vBIuPLQXgIRQvRYjudY+Lwk3eIyhEqMRbxyVKoM9weUMSkHmryoCHFpzKR5wDv3XnMlTVkyRIBEgotMxrIrFJ3ezucQYTJXF8Su4v021h50CGBnKExcXimIEcJotQAIieEMCKW9AVXU/AwIzyBARlkbdl+KjwHm3LvnzLKvyJKAQzFJkiYC+rmdqiZC1mR4NNuhZPvhATUKvrveMpJpVMoudkjT2Syu+6J1f/LuHWrMxFMDizw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MxhHDiaN4GqSQtm82M3GXIDCwz/CZif2/uptPS0EfDo=;
 b=XjEejC8DFVpWpbdpZuF2jZL3GlH6fUf5muOFJgo/ijCXYBhoWEVDqjTWl6+J/Z9yHXjRLSoFJUmGMpULrj1tXVUVddvPpWXFWy3GK5PlQ6ABYCHcFaxmUYcS3IbPOeTdfAxg3gWBADqFUt9e/c9kOYNhIbmSHMlFSWdQfm2VAn8/At81Qe1/i0HXcGnYZuiiW84Q8b0ugVIDo1dgGqSvDbomcJi6E8YbKKZteqUbEByNxgcIv+innI5DtaD1xyjN6Wsf8ka3bzcpHpGfWhRROuGaXn6zDSmbixwOgKcU1EbHL3Jmtr5ZocEBf+vkhQNCXVG8gtZb78YnX8zxsBQjEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by CY8PR11MB7135.namprd11.prod.outlook.com (2603:10b6:930:61::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7362.23; Wed, 6 Mar
 2024 14:44:29 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::3e4d:bb33:667c:ecff]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::3e4d:bb33:667c:ecff%5]) with mapi id 15.20.7362.019; Wed, 6 Mar 2024
 14:44:29 +0000
Message-ID: <d258312b-3f9c-48bd-abef-dcb9351a6a14@intel.com>
Date: Wed, 6 Mar 2024 22:44:15 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 00/27] Enable CET Virtualization
To: <dave.hansen@intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <x86@kernel.org>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<peterz@infradead.org>, <chao.gao@intel.com>, <rick.p.edgecombe@intel.com>,
	<mlevitsk@redhat.com>, <john.allen@amd.com>
References: <20240219074733.122080-1-weijiang.yang@intel.com>
Content-Language: en-US
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <20240219074733.122080-1-weijiang.yang@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0083.apcprd02.prod.outlook.com
 (2603:1096:4:90::23) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|CY8PR11MB7135:EE_
X-MS-Office365-Filtering-Correlation-Id: 61a46145-2b15-4618-eb59-08dc3debed74
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jZJLK8QHeG2zy0lyuHBmpyaTa1IatJGYMsmhQy2Z+yj9vNhCYbUozWDf+8r8dzl+TjamfhiYmbwFqNXh0krIJL5LyUe5/btPRQcRRK+QzyZHLurrP04IdFraM4ZlYGcBRyxzEsLjJtuzeV4DPcl9AKLq1qNbAj6sdPZDUGWDCUc3ZbyVCu3TZd+5HreJkzgZxed0yYWPmBWZmVzDRwaqnDJfdVK12a9o8DKgyJ0GM0JTEHaQfpvuY5ofK/BzPf9+JhzmUNNVUUu6c8YjVm71NpNMhRHcYEp4Yc3NWKBvVyOQttL49y3QcqAB8l+MRPPoqQMTRVIKTKQ2vZTnmdGTx7vhRuN2CuZDf56T5L/gPKFcGMaDbreMN1WQfHcAKYa6qyvvQroXpZCyr0ke2kTVLwiVuyhXCBgYIdZlNq3w1sPeOOFVX+sTrzPOrlqZQWT1FMiEFGmFCPaZ+X6bQXgkKDNMa0g6PdaD/UjaaDmySxS2GQsymHMXD3+Wn7N26LZcsBqtZaUfGdCthByhyojmRpbuXAsGKJKLAYdoKiHwPho7I0KoisIfYGXMh+E8VijVfuTHytJPjxoN2Uly7omV0v1O4yJpUdtsLl+1jYCowae+jsXO1XR2+5xn29aq2jtE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VlNob0ZWMlgwY0VIMm1tZmw2ak5RaGpENE4zU2pzaUZEbHl6OEpSdFJmbGtV?=
 =?utf-8?B?SmQvTzlySERvY0QwTUJvRzR1SEpDTlpTS2JheStObE5kNjNjNi9HaXAxOUlh?=
 =?utf-8?B?OWl5c0ZQUE1xV2dQTVhsQ1RQUVlySzkvR0J5MTVmZmU5ejRzTkovUTd0RWhw?=
 =?utf-8?B?QURBdnBvM01UOFI1UEpDcEdveUxUMnpmTTQ5VEdNSkdTK0x5ZDdrenk5cmtG?=
 =?utf-8?B?UDV4eWU1RUhMZEllaDdMa3dWNUU0K1oyQXZ4aEJpTi9MVFZKZTJMMzRMNEUy?=
 =?utf-8?B?VEtWVWtJczVFc3RZbDA3a0dqS2V2ZWRXVWxjM3pMNGFhTml6dTBaVS9XZ2ZK?=
 =?utf-8?B?TFBFTlNmMEMwZDcyYkxHU1dlUEpVemRWMEw3dU1XYU9haERCY2F1b1RlcUtD?=
 =?utf-8?B?c2ZtZXVQUGk1Z1JGQ0xGVWNJRjUxTDZtUm03bmN3VGsrR0d6eGNFcWxqRksz?=
 =?utf-8?B?MURlTGpLL2hJNXM2NGduQTFyZ3dMNDgxUGpJdHZhMWpXT2pyblNWOVdyNWdW?=
 =?utf-8?B?cDhEeml6QWNQWEN3WmZuUzlqRC9rSW12dTN2YU9Ob2VWcmVsTU1GYVR3a2pL?=
 =?utf-8?B?dExGdUFVeGl3OUEwZkc4NzBBYVVCS2xuRm9XY1NrQmE3WlpFNmlTWDlWV0hG?=
 =?utf-8?B?L1hKRDFUbzdHZDBKallJR0hZSDV1WUk1N0QraXFhOFhaeWNrOC9oSHJnZnZO?=
 =?utf-8?B?b0NSczRqbHMrU0JjUk9LL0l3Vk5idGVEQ1AvclNibSs5bllWbFR4SkJ1MWVF?=
 =?utf-8?B?ZmZ2SGRsSDZtWXFieE50OW5MZndUalZXUG9nQU1YNFN3ckNsajdiWkREblZ1?=
 =?utf-8?B?L2dpQStMcC9VUEN6N3h5S1I1M1BCaXMxTFJMOVlEY0JkSzBPak9FdlpJQnhu?=
 =?utf-8?B?NU52d0owZmNJSTVuMGQ3SlJZY0kySVIwZ2RaTWNTMkpCc214dVZOS2JJYjFy?=
 =?utf-8?B?Mzk1MmRaa2JEeUhxWWppNXArTWs2SnBDbURVSmo2Z3NTcTEwV2UzeGdWTncz?=
 =?utf-8?B?MWtDek5CdVpvcC9mcEsrQW8yaFcxMENQZmlWWnVlUkdLaUdBQVA2M2RKL2hV?=
 =?utf-8?B?QU0zV2ZESFY4N0d3dGpzZDNaZUZSd1NPQ241L1loVGplRDlaMERJV1gydUNh?=
 =?utf-8?B?dUpsdStLcnZOaktFNkpBZFM4aVVvMzlNNjRCREtId05yQm9HdzExQ01DcVp1?=
 =?utf-8?B?SDNxbEU4RVBMODQ1MndvcDhNR2l1RmtFMEJteDRwWGRtL2hQME4rU1lxVmFQ?=
 =?utf-8?B?UWI1ek1HWVhBVEx1UWdlK1FzSmlqQjcvREUwejRIK2tuN1l4My9mSXV5dEh4?=
 =?utf-8?B?ZW50NWdwZDcxMVUxeVlSVmxVeGVrb2E2aXJHSWVaRVJoT2duSXlMWG1ZMXla?=
 =?utf-8?B?WEd3dU83Yll2OVc1RngzZlFaQkhaNHpzQndrZVVDSVZ5SGs3aTM0Q09zKzZr?=
 =?utf-8?B?WGxzTE94bFNCQWlFYUZWVXVSZEdHRy9vZm8waEZmK2xSQVNFRXVrdlJPT0dS?=
 =?utf-8?B?WnRCbGRTMXIxK0lSbE1nZDdSVFY2ek5SVnFIUTgwd2kwZzhFNURjTXNRZWNy?=
 =?utf-8?B?VU9acXVPZDM4emptMEtCbFBrU04xN0oyMmd6UEl2TEM2NXdWK1dtcVRQaEFt?=
 =?utf-8?B?czNCR0l3enU0NCtjczNIOGQyUVo4UUY4SzRVRUZlNnJvbHZWZ2F5Z2ViZmlC?=
 =?utf-8?B?dFVRbEduRHFsbTROZnJDUWEyclN3NE5qR0tpTnBqRjFhSDBucm94aFZiQlZx?=
 =?utf-8?B?VzZrWW8zb09KTTRiR1F2YlUwOHpUYjVOWkxUTzVlYUY5L2liZHRjK1BBWExp?=
 =?utf-8?B?cHkrMlJkTWU2VDg0eEF5cm90a1VBK2hTRVFEY1dGcjU0b0xxYVBxSTlQVXk0?=
 =?utf-8?B?RW1Rc0h5YVBiRzJRVWh0Q2R4eE9hMFhZb1Z2eUtLRVRRK0tjMDBMVEVncHgw?=
 =?utf-8?B?ZngyMXF5cXFxMWRVWnlzdWlyemsxOWJTNCtWZUlVM2hsMlVnOWEyTGlaUWhC?=
 =?utf-8?B?UHZGODBOLzFKcWxJZml1ek03VWpXM3BGcmhFdEtXTTI2c2J6cUt6Ukx4dmxE?=
 =?utf-8?B?VDBGY29ONk9IWXhxRUpKbFhhOWR2dHFaNDJHT1Z1S3pZM205RUIycHV4QnVv?=
 =?utf-8?B?ekJaRzJ6QitmblQ0SVJGTkJaOERlek1zaXB4Q1ZtNytHU2ZWaXBUa3FLcEUy?=
 =?utf-8?B?dUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 61a46145-2b15-4618-eb59-08dc3debed74
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2024 14:44:29.4459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gG1Ig5zdov0vQVWy8uAKOvu+PMone3J+HxhgqBSzw0QTtrrx8gpm93X/gN+N+/okEbg2VfYqHf5vbV4QHI+wMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7135
X-OriginatorOrg: intel.com

Hi, Dave,

Could you kindly review the kernel patches(patch 1-7) at your convenience?
Rick has added RB tags on these patches, so I'd get your opinions on them.

Thanks a lot!

On 2/19/2024 3:47 PM, Yang Weijiang wrote:
> Control-flow Enforcement Technology (CET) is a kind of CPU feature used
> to prevent Return/CALL/Jump-Oriented Programming (ROP/COP/JOP) attacks.
> It provides two sub-features(SHSTK,IBT) to defend against ROP/COP/JOP
> style control-flow subversion attacks.
>
> Shadow Stack (SHSTK):
>    A shadow stack is a second stack used exclusively for control transfer
>    operations. The shadow stack is separate from the data/normal stack and
>    can be enabled individually in user and kernel mode. When shadow stack
>    is enabled, CALL pushes the return address on both the data and shadow
>    stack. RET pops the return address from both stacks and compares them.
>    If the return addresses from the two stacks do not match, the processor
>    generates a #CP.
>
> Indirect Branch Tracking (IBT):
>    IBT introduces new instruction(ENDBRANCH)to mark valid target addresses of
>    indirect branches (CALL, JMP etc...). If an indirect branch is executed
>    and the next instruction is _not_ an ENDBRANCH, the processor generates a
>    #CP. These instruction behaves as a NOP on platforms that doesn't support
>    CET.
>
> Dependency:
> =====================
> CET native series for user mode shadow stack has already been merged in v6.6
> mainline kernel.
>
> The first 7 kernel patches are prerequisites for this KVM patch series since
> guest CET user mode and supervisor mode states depends on kernel FPU framework
> to properly save/restore the states whenever FPU context switch is required,
> e.g., after VM-Exit and before vCPU thread exits to userspace.
>
> In this series, guest supervisor SHSTK mitigation solution isn't introduced
> for Intel platform therefore guest SSS_CET bit of CPUID(0x7,1):EDX[bit18] is
> cleared. Check SDM (Vol 1, Section 17.2.3) for details.
>
> CET states management:
> ======================
> KVM cooperates with host kernel FPU framework to manage guest CET registers.
> With CET supervisor mode state support in this series, KVM can save/restore
> full guest CET xsave-managed states.
>
> CET user mode and supervisor mode xstates, i.e., MSR_IA32_{U_CET,PL3_SSP}
> and MSR_IA32_PL{0,1,2}, depend on host FPU framework to swap guest and host
> xstates. On VM-Exit, guest CET xstates are saved to guest fpu area and host
> CET xstates are loaded from task/thread context before vCPU returns to
> userspace, vice-versa on VM-Entry. See details in kvm_{load,put}_guest_fpu().
> So guest CET xstates management depends on CET xstate bits(U_CET/S_CET bit)
> set in host XSS MSR.
>
> CET supervisor mode states are grouped into two categories : XSAVE-managed
> and non-XSAVE-managed, the former includes MSR_IA32_PL{0,1,2}_SSP and are
> controlled by CET supervisor mode bit(S_CET bit) in XSS, the later consists
> of MSR_IA32_S_CET and MSR_IA32_INTR_SSP_TBL.
>
> VMX introduces new VMCS fields, {GUEST|HOST}_{S_CET,SSP,INTR_SSP_TABL}, to
> facilitate guest/host non-XSAVES-managed states. When VMX CET entry/exit load
> bits are set, guest/host MSR_IA32_{S_CET,INTR_SSP_TBL,SSP} are loaded from
> equivalent fields at VM-Exit/Entry. With these new fields, such supervisor
> states require no addtional KVM save/reload actions.
>
> Tests:
> ======================
> This series passed basic CET user shadow stack test and kernel IBT test in L1
> and L2 guest.
> The patch series _has_ impact to existing vmx test cases in KVM-unit-tests,the
> failures have been fixed here[1].
> One new selftest app[2] is introduced for testing CET MSRs accessibilities.
>
> Note, this series hasn't been tested on AMD platform yet.
>
> To run user SHSTK test and kernel IBT test in guest, an CET capable platform
> is required, e.g., Sapphire Rapids server, and follow below steps to build
> the binaries:
>
> 1. Host kernel: Apply this series to mainline kernel (>= v6.6) and build.
>
> 2. Guest kernel: Pull kernel (>= v6.6), opt-in CONFIG_X86_KERNEL_IBT
> and CONFIG_X86_USER_SHADOW_STACK options. Build with CET enabled gcc versions
> (>= 8.5.0).
>
> 3. Apply CET QEMU patches[3] before build mainline QEMU.
>
> Check kernel selftest test_shadow_stack_64 output:
> [INFO]  new_ssp = 7f8c82100ff8, *new_ssp = 7f8c82101001
> [INFO]  changing ssp from 7f8c82900ff0 to 7f8c82100ff8
> [INFO]  ssp is now 7f8c82101000
> [OK]    Shadow stack pivot
> [OK]    Shadow stack faults
> [INFO]  Corrupting shadow stack
> [INFO]  Generated shadow stack violation successfully
> [OK]    Shadow stack violation test
> [INFO]  Gup read -> shstk access success
> [INFO]  Gup write -> shstk access success
> [INFO]  Violation from normal write
> [INFO]  Gup read -> write access success
> [INFO]  Violation from normal write
> [INFO]  Gup write -> write access success
> [INFO]  Cow gup write -> write access success
> [OK]    Shadow gup test
> [INFO]  Violation from shstk access
> [OK]    mprotect() test
> [SKIP]  Userfaultfd unavailable.
> [OK]    32 bit test
>
>
> Check kernel IBT with dmesg | grep CET:
> CET detected: Indirect Branch Tracking enabled
>
> Changes in v10:
> =====================
> 1. Add Reviewed-by tags from Chao and Rick. [Chao, Rick]
> 2. Use two bit flags to check CET guarded instructions in KVM emulator. [Chao]
> 3. Refine reset handling of xsave-managed guest FPU states. [Chao]
> 4. Add nested CET MSR sync when entry/exit-load-bit is not set. [Chao]
> 5. Other minor changes per comments from Chao and Rick.
> 6. Rebased on https://github.com/kvm-x86/linux commit: c0f8b0752b09
>
>
> [1]: KVM-unit-tests fixup:
> https://lore.kernel.org/all/20230913235006.74172-1-weijiang.yang@intel.com/
> [2]: Selftest for CET MSRs:
> https://lore.kernel.org/all/20230914064201.85605-1-weijiang.yang@intel.com/
> [3]: QEMU patch:
> https://lore.kernel.org/all/20230720111445.99509-1-weijiang.yang@intel.com/
> [4]: v9 patchset:
> https://lore.kernel.org/all/20240124024200.102792-1-weijiang.yang@intel.com/
>
>
> Patch 1-7:	Fixup patches for kernel xstate and enable CET supervisor xstate.
> Patch 8-11:	Cleanup patches for KVM.
> Patch 12-15:	Enable KVM XSS MSR support.
> Patch 16:	Fault check for CR4.CET setting.
> Patch 17:	Report CET MSRs to userspace.
> Patch 18:	Introduce CET VMCS fields.
> Patch 19:	Add SHSTK/IBT to KVM-governed framework.(to be deprecated)
> Patch 20:	Emulate CET MSR access.
> Patch 21:	Handle SSP at entry/exit to SMM.
> Patch 22:	Set up CET MSR interception.
> Patch 23:	Initialize host constant supervisor state.
> Patch 24:	Enable CET virtualization settings.
> Patch 25-26:	Add CET nested support.
> Patch 27:	KVM emulation handling for branch instructions
>
>
> Sean Christopherson (4):
>    x86/fpu/xstate: Always preserve non-user xfeatures/flags in
>      __state_perm
>    KVM: x86: Rework cpuid_get_supported_xcr0() to operate on vCPU data
>    KVM: x86: Report XSS as to-be-saved if there are supported features
>    KVM: x86: Load guest FPU state when access XSAVE-managed MSRs
>
> Yang Weijiang (23):
>    x86/fpu/xstate: Refine CET user xstate bit enabling
>    x86/fpu/xstate: Add CET supervisor mode state support
>    x86/fpu/xstate: Introduce XFEATURE_MASK_KERNEL_DYNAMIC xfeature set
>    x86/fpu/xstate: Introduce fpu_guest_cfg for guest FPU configuration
>    x86/fpu/xstate: Create guest fpstate with guest specific config
>    x86/fpu/xstate: Warn if kernel dynamic xfeatures detected in normal
>      fpstate
>    KVM: x86: Rename kvm_{g,s}et_msr()* to menifest emulation operations
>    KVM: x86: Refine xsave-managed guest register/MSR reset handling
>    KVM: x86: Add kvm_msr_{read,write}() helpers
>    KVM: x86: Refresh CPUID on write to guest MSR_IA32_XSS
>    KVM: x86: Initialize kvm_caps.supported_xss
>    KVM: x86: Add fault checks for guest CR4.CET setting
>    KVM: x86: Report KVM supported CET MSRs as to-be-saved
>    KVM: VMX: Introduce CET VMCS fields and control bits
>    KVM: x86: Use KVM-governed feature framework to track "SHSTK/IBT
>      enabled"
>    KVM: VMX: Emulate read and write to CET MSRs
>    KVM: x86: Save and reload SSP to/from SMRAM
>    KVM: VMX: Set up interception for CET MSRs
>    KVM: VMX: Set host constant supervisor states to VMCS fields
>    KVM: x86: Enable CET virtualization for VMX and advertise to userspace
>    KVM: nVMX: Introduce new VMX_BASIC bit for event error_code delivery
>      to L1
>    KVM: nVMX: Enable CET support for nested guest
>    KVM: x86: Don't emulate instructions guarded by CET
>
>   arch/x86/include/asm/fpu/types.h     |  16 +-
>   arch/x86/include/asm/fpu/xstate.h    |  11 +-
>   arch/x86/include/asm/kvm_host.h      |  12 +-
>   arch/x86/include/asm/msr-index.h     |   1 +
>   arch/x86/include/asm/vmx.h           |   8 +
>   arch/x86/include/uapi/asm/kvm_para.h |   1 +
>   arch/x86/kernel/fpu/core.c           |  53 +++--
>   arch/x86/kernel/fpu/xstate.c         |  44 ++++-
>   arch/x86/kernel/fpu/xstate.h         |   3 +
>   arch/x86/kvm/cpuid.c                 |  80 ++++++--
>   arch/x86/kvm/emulate.c               |  46 +++--
>   arch/x86/kvm/governed_features.h     |   2 +
>   arch/x86/kvm/smm.c                   |  12 +-
>   arch/x86/kvm/smm.h                   |   2 +-
>   arch/x86/kvm/vmx/capabilities.h      |  10 +
>   arch/x86/kvm/vmx/nested.c            | 120 ++++++++++--
>   arch/x86/kvm/vmx/nested.h            |   5 +
>   arch/x86/kvm/vmx/vmcs12.c            |   6 +
>   arch/x86/kvm/vmx/vmcs12.h            |  14 +-
>   arch/x86/kvm/vmx/vmx.c               | 112 ++++++++++-
>   arch/x86/kvm/vmx/vmx.h               |   9 +-
>   arch/x86/kvm/x86.c                   | 280 ++++++++++++++++++++++++---
>   arch/x86/kvm/x86.h                   |  28 +++
>   23 files changed, 761 insertions(+), 114 deletions(-)
>
>
> base-commit: c0f8b0752b0988e5116c78e8b6c3cfdf89806e45


