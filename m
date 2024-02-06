Return-Path: <kvm+bounces-8165-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB5F284BFF3
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 23:22:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8053FB23B92
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 22:22:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C6501C6A6;
	Tue,  6 Feb 2024 22:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YF7Fj75t"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E7E1C697;
	Tue,  6 Feb 2024 22:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707258132; cv=fail; b=rZkZT3hmAmXDbQtyAld6TOVPPDT9dLJeWTcWZqYaEhxyI3gLy7bGS32SCDApBzxobJeY5jEUerw539ck6EK935S18ylTuIDAsZysGGQOjbJhVjxXS2wwInzAt80LTfiOPp3akeFPBjUTnnDh9oRMAYrWz8KhPDJBFaTq04HOZq4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707258132; c=relaxed/simple;
	bh=Cqz8kGPxL//NBroqq+C0OUZITJfvePQpcL+W2rlAcag=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=r3bKV79XfPM0V5RpmtcGBHZ2GMq8lBuMJEAdjDZwnadofCWbwp6gfWiLILjFw80hLfw1Ll9ilSOBFFUI/FbG/HTcvuCDwk109Ina7w8MZ/Tv95MQI8bMgDbQHxvOPAZnoB2ywDAyDwMLdZp7CKKAfBB7vsfJLxSSxzL9Fp8UMqc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YF7Fj75t; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707258132; x=1738794132;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Cqz8kGPxL//NBroqq+C0OUZITJfvePQpcL+W2rlAcag=;
  b=YF7Fj75thkCR6Z6erSXhBNovkhn10NHevjY76Xt7pKE23qsNe1AjYS9T
   uS/pF16qjuD/2mqC17CMUFxYaxbPDFpg1YN63gE4ZKUkZk7cYnSOHZypq
   t6/w9LfJ5WdTda7szldSl4YCrv6yLPQqwgLxO3kAMDQcRBXqtKVgE/bsk
   dV+gTxGh0vXxYlrhhrWVynARzN5BeLy/u0xKHDHFt+rc1hrAM/vhw5ym/
   faeVxtOsG4uLF0Zs76dwqUHwDO+nmLD6TUGn2gB44t/pGFnH4rKgRh/OB
   8N7wOp3DGcxR/6T/V4KdsBdhEijAStndGON3TQ7D48rNiVvhFGx1IdwDY
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10976"; a="4672651"
X-IronPort-AV: E=Sophos;i="6.05,248,1701158400"; 
   d="scan'208";a="4672651"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2024 14:22:10 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,248,1701158400"; 
   d="scan'208";a="1148390"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Feb 2024 14:22:08 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 6 Feb 2024 14:22:07 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 6 Feb 2024 14:22:07 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 6 Feb 2024 14:22:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZExtcR6eJ3iSBGkL+yu15xYel6X2uAHZbN3bm/yHnvzwZugJHq61UauHbcBs75uDteEcWJXQF4WDTgJowSft5PZ38ixrzFQtmGqW8J5dFWg7Ia/XCh6Mio1zQfPwo8STS7SMrK143MBAFWE0eCU0UTRPspDWDuTmCBwSm7GWE2oTo3lXMQzbDT7M3/USGtXlY24SEnhUlOjfnUpc1s19v7T7PcRz46O2gW7SG79bigOryFUN1KLEUcSDGgpcjWRGXinGeVlx0yuTEvyS8UCbQBIO7FVP08PX4ONY1qxpdfNLtiiO0RsdGTwuhWR73lHOvIG20l/HjnWVsfAAOJquIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OXLNY6sair+JomdqeVh6TMTy3NmSeLnyVfCufp1BDm0=;
 b=YqBLZnudVp44maOen5ZISUR544XEGyqCrbWsM2LgZ8X6zg/2h08XNbhVvIz8Ltbq8HTqnsEYb0TO3owWKd21ygJqjjxihSPk46eveesaGyvne+6O5RfXoNEhYuaivcDyQ6W6r+rcZwAEpAGUNicv229xdBje0ICFMPXaDhci1A3KKFkqtHw70PcQwEuN47j2NP75Mxfwl7YJdJ/Ln+JgtPvXjYVy14b+vZOXmnMg4/HKv+7+kpaMbhBrbECQ4rXnmelSPYhMywzewtlxZiGZlTc7lHpjS8AxPOCO0fzXK03jQmn4GvC5elObMXzOgGJrA8st668ipODignsi5+aWPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by DS0PR11MB7925.namprd11.prod.outlook.com (2603:10b6:8:f8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.36; Tue, 6 Feb
 2024 22:22:05 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::c903:6ee5:ed69:f4fa]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::c903:6ee5:ed69:f4fa%7]) with mapi id 15.20.7249.035; Tue, 6 Feb 2024
 22:22:05 +0000
Message-ID: <ce617344-ab6e-49f3-adbd-47be9fb87bf9@intel.com>
Date: Tue, 6 Feb 2024 14:22:04 -0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 15/17] vfio/pci: Let enable and disable of interrupt types
 use same signature
Content-Language: en-US
To: Alex Williamson <alex.williamson@redhat.com>
CC: <jgg@nvidia.com>, <yishaih@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>,
	<kvm@vger.kernel.org>, <dave.jiang@intel.com>, <ashok.raj@intel.com>,
	<linux-kernel@vger.kernel.org>, <patches@lists.linux.dev>
References: <cover.1706849424.git.reinette.chatre@intel.com>
 <bf87e46c249941ebbfacb20ee9ff92e8efd2a595.1706849424.git.reinette.chatre@intel.com>
 <20240205153542.0883e2ff.alex.williamson@redhat.com>
 <5784cc9b-697a-40fa-99b0-b75530f51214@intel.com>
 <20240206150341.798bb9fe.alex.williamson@redhat.com>
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <20240206150341.798bb9fe.alex.williamson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR02CA0029.namprd02.prod.outlook.com
 (2603:10b6:303:16d::34) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|DS0PR11MB7925:EE_
X-MS-Office365-Filtering-Correlation-Id: c161a053-224f-40af-de57-08dc27620c94
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0cGOYaBHgMbamVbEMRJi4uGjb3m0wgYRBAQQquZBEeujHWEumXrQvk8493r/peyUcAHxU4lDsWRyQWIXYskBVwaRJdb2O9PeaJnQ+u6wiLUaYEjuY7v5z4Z7dTAAD02EcbBFYHAZg2tRYYKtwvubdf8CFsCs/irvqDepFHBgxpX7LlXSP+wobIea8kYmT5wE8aDRLTnZydTPmYN9Tm/uH6iPm4xTqkQudpnguVHvXhd6XPKbRkD5Xi7v/dOxcMRL7r5rHcfxrinzYradxNicHiJegJ1z8ANSGpwmqu8zM1uaaFqkw8TIBLM8hFXZ6ueQ6ghPS9Etm+AOyxPu8Fbl39fEDCEOzzums0zJqV3G41z/YzSSrduHL/k4eSM3QGLEad9ypACtsiTbg4/bLaXaVqgKVomgLG6uqqGsW/n2H7xALRgZ+DI7i6aiXSNn7OS8BnMYp573PLdk8zLkGSLg2K6k8cgcE5eP7KOfvjkd/+T6F4JtssJM25Gn0GyxIW2mjW6ToqAR5dDDrih1E18m7sj3FwSjJ+mwRWaDw8GeG00L9jPi983zfUKT2RLjMr3lVZHr1VzhwdMokh9N5JgaMhqugl57QcFSU4t10Yj6QYNOIHp8kEDkzQzbeuCbVMVT3gG6jnbT9jpzhCZGjtnLbQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(346002)(396003)(136003)(376002)(230922051799003)(1800799012)(451199024)(64100799003)(186009)(41300700001)(53546011)(6506007)(6486002)(478600001)(83380400001)(26005)(6512007)(2616005)(5660300002)(44832011)(2906002)(66476007)(6916009)(66556008)(316002)(66946007)(38100700002)(8936002)(4326008)(82960400001)(8676002)(36756003)(31686004)(31696002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VHRpSDhSekt5Qk9GRVVncjBMM1NWZnJteXl3QW9aSjVXQnd2S3ozVXRjWmN5?=
 =?utf-8?B?VGRMbDNwWE9RZUhLUjhZcHl6R2ROUTRWK2xJcTAzSlRveEFacmhyQmZBVzU4?=
 =?utf-8?B?eXdlbEEwODkwWFhlQmplQUZPL0tUOEFYWmRzT2NnM1lSa05QRXgrNE5GTWta?=
 =?utf-8?B?RFV1eEdveGtQTXArd2NIdGRmSVdLeHcvaStINjNObTlSQUZXYWx4eW8yenJL?=
 =?utf-8?B?SllhKzFZN3hpdlA4dHFSVVZjMTU5Y2srYzVGaU1icFdqdjdKZlJxeUtRUGRw?=
 =?utf-8?B?bk9KTHdZSEhvNExVRnhnY0RKaG5lLzgzanhDeTR2Ly8xVDRmTHJadVFOUWVG?=
 =?utf-8?B?L3U5cHZRaUQ3QzNlU05jR1lFYzk0OFNFdXErS1ZQM1pwUzlCWkdZbURnZHpm?=
 =?utf-8?B?SlZDK1ZRcDFETkUwaVQ2V3JRaTdrQ2J5L1NPT0NlWTZNN0dVWXk4bkdOUFox?=
 =?utf-8?B?WHJjaTR4YXcvdEdRWndVZVNYdDRDRDhQY1ZlZ1M3SHpCWGhvVVRZL2VCYlln?=
 =?utf-8?B?ZXhSYzhydHRNbmJJYjFESllnL0pJejNvK1Rzdnd2NHFtZ1hkNkpNNlpPNnUr?=
 =?utf-8?B?bnNNcHFWaGxBOUlaQWU1bHFiVnhna0dVRmpDemhrZnM0WFE0ZWszVUZtUWdK?=
 =?utf-8?B?TW4zd1h1TmI1eEJ6ZmVwOURDbWw5c1ZZaW80cU1NMytFdjNpQUJldmpWOXBN?=
 =?utf-8?B?c2lMMzZadzg3SVhzZ3RFaDNLU1dLVzNOUlMwYXNFUTBwTjBuYzZwakZ2SnRP?=
 =?utf-8?B?dkU2TGIvWjVCMXVWQ0RiM3RBQnZ2UmxhdUptb2hZR2tqU212QXdWVEtrQTVN?=
 =?utf-8?B?TlNIR2tMdzNzS0l1UHQyQWZZQ1Zza1JOZXpCei80NktsSHA1WmxVUFhPVzlJ?=
 =?utf-8?B?dXUxMytrODhRd2wrL2NuM2xXUlprS0x3RE5wM1hHaFRjNDh1QjFvYlZyY0Vi?=
 =?utf-8?B?VDFkUW5MUzlaVnpnenR5YjN4dVd2cGgxZTJoLzF1cSs0R1E4MmF2OVJSZGhl?=
 =?utf-8?B?RHlTTWl4SVQ4bGNXZ3U1cWZaNFJrcUxBWnBhbjRMclFHV0xCZ0lMVnJrZUgx?=
 =?utf-8?B?WTRpd0dxZUdsYmZEN1FpRXZlUFdKakNOcmcyN0R6VFYxbGUycWQxdFF3OGhU?=
 =?utf-8?B?TWlxTjZQL2h2THp3clNraTBCQ0lwRjR5MTJtdVBzS2RJUmNmYnRpVWJJVzIw?=
 =?utf-8?B?cm1BVHQvNEFsbTdQSTM0a2o1MzRUalN5a21ZYWQ3MkFBUTkvNXpEUjJTZ3FF?=
 =?utf-8?B?blZGVDlPQmJKekhRQ2xDM3RPcTFqMVFiTlVWbmxQR3NDckNwaGN1bzFKUVBJ?=
 =?utf-8?B?ZWJWRHBsVEoxN3hhMXNWa2xhdFp5S3FFWFJwTlkyY0ljVzhaTVRyMU9qZ2dH?=
 =?utf-8?B?U2s1YXRjYzA4Nlc3cWlCU1VGbExyVkluNWZmU0tZRzZNWkE0aWNDOUpzSmVu?=
 =?utf-8?B?TFpTRzFWZTluMFpVQldsNllYTy9IRytKaVo0OFRNT0JOVFlBVFM3Z29MVkc0?=
 =?utf-8?B?Y1FnTVZFMlpsTjd5c2dXZVRUY3Fxd2tVZGV0R09Jejg2VTlxak1QMWk0RVda?=
 =?utf-8?B?MFptcCtLN3hrRSszL1BKeVJVZlczNUpqSFZGMVZyOHc4dDNYRHdkVytlWFNH?=
 =?utf-8?B?ckF4NkxsTHNKMXNmYTdzQVJkSWQwbDhmdStuRDMxZTVWRU84YUtpZUxMdG9a?=
 =?utf-8?B?YzNLRWpXSzNYSjVaRk5VaThwcE1ZclJKbVlPUkUrN0diSTVPVW81N3p4dith?=
 =?utf-8?B?elNyMFNoTkIxQlljRjhsWmV4UlBzcEE3dE82MTVCOTFqZGNheUdJbEJKd2xu?=
 =?utf-8?B?bjNWdnJ4VVFHZlBWVmhSbWNHYW5jdXc4VFBxd1VkMVdWdjUyVE9rWDlwbTcz?=
 =?utf-8?B?WGJydS82TTRib29meFRKeHl4K0N2bFpyZFc4TTMvbS80V2NldUZONlliZDhS?=
 =?utf-8?B?T1ROR3FCRGtPamFSdkdUNVVrRHFsZjhxbzhWcCt2U0VYY2ZuQ0ZUM3FzRzNQ?=
 =?utf-8?B?d3hUUTQ0S2hWN0doNCsvZTlOUnBBSzlQQkpuZTMrQmNRTEVoY1hhZmYzUEFx?=
 =?utf-8?B?Vno0THF0ZXZSTjg3U0d6RFlWWm5vUktraXc1SGpCdStJWUw0OS96aXpNaXB1?=
 =?utf-8?B?ZWRaYzkrMUpydWswdzJVdkdKYktyVDJJTHY1Z2ZoT0MwemlZUE1WNENaMm0x?=
 =?utf-8?B?ZFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: c161a053-224f-40af-de57-08dc27620c94
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2024 22:22:05.2389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g1tbtPVMz67aww0usKMPLiR7aEF6yfb5jh6NWlk+Gidfgv+HMf7l8r8SGs+AYoYY+QO+f4rjL1haTISWOLZvS8BxYlHvEjZezcXC+6gOzSE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7925
X-OriginatorOrg: intel.com

Hi Alex,

On 2/6/2024 2:03 PM, Alex Williamson wrote:
> On Tue, 6 Feb 2024 13:46:37 -0800
> Reinette Chatre <reinette.chatre@intel.com> wrote:
> 
>> Hi Alex,
>>
>> On 2/5/2024 2:35 PM, Alex Williamson wrote:
>>> On Thu,  1 Feb 2024 20:57:09 -0800
>>> Reinette Chatre <reinette.chatre@intel.com> wrote:  
>>
>> ..
>>
>>>> @@ -715,13 +724,13 @@ static int vfio_pci_set_intx_trigger(struct vfio_pci_core_device *vdev,
>>>>  		if (is_intx(vdev))
>>>>  			return vfio_irq_set_block(vdev, start, count, fds, index);
>>>>  
>>>> -		ret = vfio_intx_enable(vdev);
>>>> +		ret = vfio_intx_enable(vdev, start, count, index);  
>>>
>>> Please trace what happens when a user calls SET_IRQS to setup a trigger
>>> eventfd with start = 0, count = 1, followed by any other combination of
>>> start and count values once is_intx() is true.  vfio_intx_enable()
>>> cannot be the only place we bounds check the user, all of the INTx
>>> callbacks should be an error or nop if vector != 0.  Thanks,
>>>   
>>
>> Thank you very much for catching this. I plan to add the vector
>> check to the device_name() and request_interrupt() callbacks. I do
>> not think it is necessary to add the vector check to disable() since
>> it does not operate on a range and from what I can tell it depends on
>> a successful enable() that already contains the vector check. Similar,
>> free_interrupt() requires a successful request_interrupt() (that will
>> have vector check in next version).
>> send_eventfd() requires a valid interrupt context that is only
>> possible if enable() or request_interrupt() succeeded.
> 
> Sounds reasonable.
> 
>> If user space creates an eventfd with start = 0 and count = 1
>> and then attempts to trigger the eventfd using another combination then
>> the changes in this series will result in a nop while the current
>> implementation will result in -EINVAL. Is this acceptable?
> 
> I think by nop, you mean the ioctl returns success.  Was the call a
> success?  Thanks,

Yes, I mean the ioctl returns success without taking any
action (nop).

It is not obvious to me how to interpret "success" because from what I
understand current INTx and MSI/MSI-x are behaving differently when
considering this flow. If I understand correctly, INTx will return
an error if user space attempts to trigger an eventfd that has not
been set up while MSI and MSI-x will return 0.

I can restore existing INTx behavior by adding more logic and a return
code to the send_eventfd() callback so that the different interrupt types
can maintain their existing behavior.

Reinette


