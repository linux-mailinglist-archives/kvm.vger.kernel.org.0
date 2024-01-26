Return-Path: <kvm+bounces-7132-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E2C6B83D78B
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 11:13:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5535A1F2D071
	for <lists+kvm@lfdr.de>; Fri, 26 Jan 2024 10:13:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54F3D22F0E;
	Fri, 26 Jan 2024 09:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hw2H9PJl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D233822EF3;
	Fri, 26 Jan 2024 09:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706261849; cv=fail; b=oBxo7GTEAJSLiTnus3Ye2jA10CUPVsMdnWtw7v1demiK48U9/Kydi4dZIDLrmHY4li+NU9casZfX0/JAADCGgP9NJLtWJzZS4z4fAUUuS/R4Zk2Ok+ehrVveBMQ5GRS4QBU5CH8X25bmg7YUJlqTzzw3IukXQ9Se9dK18bDgdyg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706261849; c=relaxed/simple;
	bh=0CjKGM/Ei7zsxQH2IiQ6WoyyD6s6YS0E1SlMSJv9H3A=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=i1v1b/Jx5JHtrVkaq3gznHbTHVNEJzCjBYaucvXg8ojc1G7rZFoKzzEqpwA4e7fVZzLyRA93LEEs83MY3KPm5LujwT9t2kUNvnkNh0o7AL8ffly7+1mlRIp9vQROeN4035krgzDll9+NzMtuR3DA6erbB5xdBlJZmhtvJMi3p4E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Hw2H9PJl; arc=fail smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706261848; x=1737797848;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=0CjKGM/Ei7zsxQH2IiQ6WoyyD6s6YS0E1SlMSJv9H3A=;
  b=Hw2H9PJlW02aEVH2NaLLHnNk7r6doNFiKvjgBLngPEDzFF0IRfWK8C0g
   7F52CMuSGvYiXhqVhdpy3voOEzWkWtM10udS8aUraso8i2ByZXwUxYH6P
   0x+xPjd57jk2SfXP0s58f/meAGfxeoJdtEnfgJkDRsneskCwSQDSspv5U
   HidB2pEsGRAzbXDyIOo5gHvnm+epCTlxyISuSVc+u9fRYVD5OJDrgPn04
   wSoCAmiFkFOnvf0qlCuFkuGV+hzKfdBrWwA3/CA2TiCIdZ+DKvnZp166x
   uVYFhtRJRvb9sytCkYgQMR6J3+/5brU898yBIgf+wtUm5qgvGEERL8t7n
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="9801142"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="9801142"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 01:37:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="910283524"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="910283524"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 26 Jan 2024 01:37:27 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Fri, 26 Jan 2024 01:37:26 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Fri, 26 Jan 2024 01:37:26 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Fri, 26 Jan 2024 01:37:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AdfnYHZmMk1OI385/sY4De7VzI1AlwniRis8ZHpk4dS3qZFka8ulqQ2eZu57ZDMQcEV/+1oMkM/hyfc2hQTFu+iPhpMT6pwbwq+uaLFPM8eeiBKzUjSakE+zqRhsnDxBFd8busNJFvpustKhnDYUVyCS0Jpt0CPJqrv5Eyl8V6OyF3ZIcePwEdw5wOD73/DF8X6vGNSXK+4Yai2QpE5skbCWPL50gCzIdd2NOVsLw6WP3t2BGIunAJyYQNFwqB0HSexFzxczaeC/2+fy+TVmOsGD7L0FZ3Ftiu67mZqZm5e/ooOKu2c2HZU3wvu/OlfFY+BmYRvKDGH2tZZm78cHLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KU1cU3dEU9WIc5D3+e53QkfSjjtLm0AN2VFlgIu1Cno=;
 b=LPV+6nVx7FTL4MBMbcD6DUFoiHKVJg8OplZHHagz017jdzUuFkWS4hRibYhsjQOWs9zy/A/qJXx6m/9QKGjIsx6W4myCNQ4sSvLFYsIheYASJjS/FzCmfnbumwYki0WXHB5tzfOceXOQWZ/q4xRHT5VMwia0CIia8eF8hVcuYvNXfEbNR/llfbNek54emVRfme3ka+1baFh9UA4hYKTn1mlP7bq9oUyzjVdWR0aLCrm/6T55XFlrJ58eouiROP1AlesWzNee7LlCXc3PuAgO7WjT/6VGDWMN9DhMbSaSyLxYX/Q0XGP6Wcmw/vmaggXVh6L5zpg8F0nHqrI6/A+sRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by PH0PR11MB4805.namprd11.prod.outlook.com (2603:10b6:510:32::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.27; Fri, 26 Jan
 2024 09:37:25 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::5d67:24d8:8c3d:acba]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::5d67:24d8:8c3d:acba%5]) with mapi id 15.20.7228.027; Fri, 26 Jan 2024
 09:37:25 +0000
Message-ID: <d717a278-640b-432d-b026-2a624700b61a@intel.com>
Date: Fri, 26 Jan 2024 17:37:19 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 23/27] KVM: VMX: Set host constant supervisor states to
 VMCS fields
Content-Language: en-US
To: Chao Gao <chao.gao@intel.com>
CC: <seanjc@google.com>, <pbonzini@redhat.com>, <dave.hansen@intel.com>,
	<kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<yuan.yao@linux.intel.com>, <peterz@infradead.org>,
	<rick.p.edgecombe@intel.com>, <mlevitsk@redhat.com>, <john.allen@amd.com>
References: <20240124024200.102792-1-weijiang.yang@intel.com>
 <20240124024200.102792-24-weijiang.yang@intel.com>
 <ZbNRz/c207HYuHxi@chao-email>
From: "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <ZbNRz/c207HYuHxi@chao-email>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR02CA0063.apcprd02.prod.outlook.com
 (2603:1096:4:54::27) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|PH0PR11MB4805:EE_
X-MS-Office365-Filtering-Correlation-Id: 49c6cced-6ec2-40f4-4500-08dc1e526726
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6mHZt06+4Cne5JnSDWE0qP9Rh/9fxJzKUsWdUvPgFKJXh/PsKuf75He1IUSFHnvM1gtw6ftgzSrI4FL6RSfThRdEn6BwHes9vO0DbHQESZKc5rvLIdmoA3SEHPheJo1q9pJpwIloYGLMDV2ODyum3kZ+rylO0zChAONJ2MUgZ8yLWFU+dN4+bMOEjKvxJFBM4AefTpnAk39uDWmsl69fhkpyzqjWW7il3bM7sW8lVn9aCW++u+zYdQnxpnP/kS2YCFoo3drCmps78SBAGfaeh1ZcemMucuFwMjYpeV4G/VA7L82bTPfeSEmJVMxn5IQ6qBjBYhveZk9HdhEJxyJ+hmbzcpqzIQI2QUFkrK2jDz46M0woOUwaHoJOhNQ9kSXfh83ai3TAA9h37+42iiDdLYOvSS6Els+ceiXp2IW4UKoTCykr5ZKbB7svQh0WqowV8QGjQxvCXKJN7ILQa9RtUkyhxTlyyLZPU/RqmPx3DlSPFN2yTPpdtqS5VxYAfmNP2zEGydt8VvK9l/EFjAhrDT8C8VRlvkG6AwZSScQ/ubNR/yVqWswgLS9gf0PlwNinW3iZl6TXXn8QPtvq9tao1gAA6axry4Yf1xd2XOHBMjpl4OCXx4vHJxyQ7p09B7DnhuMCsVGDN0VHzhoXlcCG1Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(396003)(136003)(366004)(346002)(230922051799003)(451199024)(1800799012)(64100799003)(186009)(41300700001)(26005)(2616005)(31686004)(6486002)(6636002)(37006003)(36756003)(478600001)(6506007)(6512007)(6666004)(83380400001)(53546011)(38100700002)(82960400001)(316002)(5660300002)(31696002)(2906002)(66556008)(66476007)(66946007)(86362001)(8936002)(4326008)(6862004)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZzhWR09LNjhpZVpyMy9jZlpWd1h3dEtHTklsZEQzZW9IV0ZRQkFYcUFYeTk5?=
 =?utf-8?B?WGV3R0Q3NitKekZxMWpManJxN1JrZHNkOFJQSnN6RHRiczFJMzFtcnIzT0Rn?=
 =?utf-8?B?aGxoL3c5T3JVSEZKVnZrOGJTNGpVZ1VYOGpKRUJqUGlCSFdWdWhQeEFrd1RR?=
 =?utf-8?B?ZVZESlFibGM5Vmw1ZFd3UFI5L2orTG9RSEE2Q2V0SkphZ0t6anV4Z0dwTTky?=
 =?utf-8?B?cWU5QWtveFBUZGIwNFc0NTl4MktTYjl0elNZcnliV3R1MExxdktqcnRqK1U1?=
 =?utf-8?B?NHB5V1dDL3h5WXJKb3V2Um10TzlNQ1VwMEpKS2dGbnFRei9Odkd6b3NvUFcz?=
 =?utf-8?B?amZibld0c1k4OHJxZXFGdUlKTjE2Q2dhek9HMjhrZEVBeUlHTGdvM3JUekhT?=
 =?utf-8?B?YTBDa0pNVnplK3BWWCtHbk04N29mRmlhVmFpUzZER2l0UnRTeGpXZmhuM3kv?=
 =?utf-8?B?djJKTUtlTVVKenFwVmp5ZVNCT3Rick9qdjZ2VTcxaXZRalFsM2l6b0xiQTNC?=
 =?utf-8?B?cFBsRUprcXh6SkhTb0RidXZyNkVkWTkyL2oxWWxPOGVHcEdJYmI5bDQzUVg4?=
 =?utf-8?B?MGwwYWE1YThRa2hjK2FZVTFURDMvRjJrRytyTkl5NitVTEF2bEJyWGlHSTBl?=
 =?utf-8?B?dGxoNFlzQldQQXh3NmQ4dnNCZm9KQ2I4SXlLYzRsVk1FMGZSdkJyRmdjV2xp?=
 =?utf-8?B?RzV6V0dhTUhFNXZnSzR2SlRiWXFEQVNhSUhTYytBZU82TElaS2JjWTM2UUJx?=
 =?utf-8?B?K2V0Y0ZJbmJKRmhHRE5zenZ2b2Y4RStnVDkyb3UzVjlBMVRrbDlzcklla2xH?=
 =?utf-8?B?ZVRlNlJxR0RmM1pxblZ3RUI1aTNYbktNSFBsR2tsVVUyblBWR0hVRDdBbm00?=
 =?utf-8?B?UVNzL0hTdVZUdkRUaGRIU0JqNHRMdmdnbWR3U0FEd1hISE5WRHdGSDRJS1ZN?=
 =?utf-8?B?NEZXQng2TDNSRHpxRmNGNVAvdnpHcEtyRHllY0VzbldwTGhzSHp2R0hEMUdz?=
 =?utf-8?B?anpKbVNSMGZqcVNBQ2xJSmM5RGtIY2xLMWpodUVuMXAra1l1a1YzNVRNV0Fv?=
 =?utf-8?B?b21CbEJrK2Urc3Jza0dQeHQyZCt6SWZFZ3NGU1pnUWZ5OEc5aW9lQmhZSVRm?=
 =?utf-8?B?Z2lla1g5WlpTWlJzUGdCdEtGRDBzQXJIbzl5Z3FqUjFjR0ZZUWlGVU1zYjFY?=
 =?utf-8?B?MG5STDFOMXIwOEFsQTc1M1N0RWJrMnFVMFFkbXNGUGdVcTVPWlY0K3J0Nlg0?=
 =?utf-8?B?bGViUldWdHJ6Q3ZUd0Y1VUtqMVFnaERPbzh2d25rblh3bWp5d3V6bzFYajVY?=
 =?utf-8?B?bEhtdTZWUm5PcEU2L3I5d1Rtcit4Mm42azQxRWkwN2Z5RHI3UGV4V1BJelRw?=
 =?utf-8?B?dGQ1WHNVSGloNVR4Tm84c3dzTTVXVWFPQWVLaFZiVGYvamM5NE5lcFMxcEZZ?=
 =?utf-8?B?L3VPa3NuMmVjamdVRmhubWxQcUVzT3lwL1R1TlZBUTlUNHRTS0FOYzU5bENm?=
 =?utf-8?B?WkhkamxKVHcwTW5mdjRmYXJEajlMUVFDVU1qSWxodmhpdWtyZThCelJPQ1ZE?=
 =?utf-8?B?aDVnVFIzaFRVd0lLeHJ3OGNRYnE4am9pbGtDQThnT2NhMDhMMTlDT3RIV2xs?=
 =?utf-8?B?T2lITndLSm0vWEJmOXo5U1p4bWQ3UERrLzlsZ3lmZFBNK3ZOV1JLY01TKzdq?=
 =?utf-8?B?eFlxdkpRdUd2RTkrZURTbDFlekZoMGl6ZHQzcUVJSjk2VGpBQ0h5T1ArSjBG?=
 =?utf-8?B?MVVrbUwyRjNyeU5uYWRHVmtEZmszWEswVUpaNEs1cmxuM3BjUDBHREIzWTZs?=
 =?utf-8?B?bk40S1lrR0UxOGhnMmk5YkdqRi9YQ3RoVG52MVNYb1dhYUgxNE4yZ3BNV2NR?=
 =?utf-8?B?UGN0UkV6S1N6STNqRE5hWFdIWmNmcDNnblVONFlwMUQzcGZyL0pWUUVrUjBF?=
 =?utf-8?B?V2dRZXVzYmlpR0ZBREJiUWJVYStiOUw0M3JnamdERFFjWkdSRU5EZ0gzNGxn?=
 =?utf-8?B?azU4UG5sZXlHaUdtbnhiNWNQbVlJcFIxSHN3VmM5ZHIwaEVhZTNqdnBLM05L?=
 =?utf-8?B?RmZyTWQ3R2gwVERodStzbVNyekJHMDFXYkV4MTZlYjBOeFBYZ3B5eTlyUy93?=
 =?utf-8?B?Z1NHaTNEcHJ3MnduemcyUzcxKzNKT1VkNitDclc5WFB2clByQkUzZURXVFB1?=
 =?utf-8?B?ZFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 49c6cced-6ec2-40f4-4500-08dc1e526726
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2024 09:37:25.0052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mj+1LMdrvf3pViZp8AtSN6PYMjYKfEfgNqXASYFZvQV6RrjTobTM6i42s3EtqEXV7jAy3cdb/7cinh/7PjH2Jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4805
X-OriginatorOrg: intel.com

On 1/26/2024 2:31 PM, Chao Gao wrote:
> On Tue, Jan 23, 2024 at 06:41:56PM -0800, Yang Weijiang wrote:
>> Save constant values to HOST_{S_CET,SSP,INTR_SSP_TABLE} field explicitly.
>> Kernel IBT is supported and the setting in MSR_IA32_S_CET is static after
>> post-boot(The exception is BIOS call case but vCPU thread never across it)
>> and KVM doesn't need to refresh HOST_S_CET field before every VM-Enter/
>> VM-Exit sequence.
>>
>> Host supervisor shadow stack is not enabled now and SSP is not accessible
>> to kernel mode, thus it's safe to set host IA32_INT_SSP_TAB/SSP VMCS field
>> to 0s. When shadow stack is enabled for CPL3, SSP is reloaded from PL3_SSP
>> before it exits to userspace. Check SDM Vol 2A/B Chapter 3/4 for SYSCALL/
>> SYSRET/SYSENTER SYSEXIT/RDSSP/CALL etc.
>>
>> Prevent KVM module loading if host supervisor shadow stack SHSTK_EN is set
>> in MSR_IA32_S_CET as KVM cannot co-exit with it correctly.
>>
>> Suggested-by: Sean Christopherson <seanjc@google.com>
>> Suggested-by: Chao Gao <chao.gao@intel.com>
>> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
>> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
> Reviewed-by: Chao Gao <chao.gao@intel.com>
>
> two nits below.
>
>> ---
>> arch/x86/kvm/vmx/capabilities.h |  4 ++++
>> arch/x86/kvm/vmx/vmx.c          | 15 +++++++++++++++
>> arch/x86/kvm/x86.c              | 14 ++++++++++++++
>> arch/x86/kvm/x86.h              |  1 +
>> 4 files changed, 34 insertions(+)
>>
>> diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
>> index 41a4533f9989..ee8938818c8a 100644
>> --- a/arch/x86/kvm/vmx/capabilities.h
>> +++ b/arch/x86/kvm/vmx/capabilities.h
>> @@ -106,6 +106,10 @@ static inline bool cpu_has_load_perf_global_ctrl(void)
>> 	return vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL;
>> }
>>
>> +static inline bool cpu_has_load_cet_ctrl(void)
> s/cet_ctrl/cet_state
>
>> +{
>> +	return (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_CET_STATE);
> nit: unnecessary brackets.

OK, will fix these nits.



