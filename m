Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E67967A13C5
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 04:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbjIOCXE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 22:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbjIOCXC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 22:23:02 -0400
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD4E269D;
        Thu, 14 Sep 2023 19:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694744578; x=1726280578;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IlRJpOupCvqzoLgQbZY1zCoOi577aMScJbvZoXiKEtM=;
  b=fhrkEFtdzbAHm2NqPPJzMhzZ0VSu5vH+h6TiOckGTWDRAWD9qYebR625
   fgiVbulqm1m3Ixerd1M+CvLYi+E0EwvgnUZ4RKwvOdL362m+A/aakjhej
   zT8FOMhl5h8bK8eGdv8+ah1Wx/JBU++MiJ/CUzVGWe6IucygDRQpmA+T1
   8njRpN0K4eButrSQaHs5JH65XIHWKmTbhsZbcN+r+Tt/8H6GN/dV9Sku5
   qs+dZ1H8yTow1JnSFJTckVU5dEmsHOvsFzqm/RLVMg+3N2AmM4vL50hvt
   Wocdz89/m08OD+2H05MZE8B5tA5veVZJBnk7vUjYOLMEXhdsE62m3ZUya
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="358548443"
X-IronPort-AV: E=Sophos;i="6.02,147,1688454000"; 
   d="scan'208";a="358548443"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2023 19:22:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10833"; a="888043954"
X-IronPort-AV: E=Sophos;i="6.02,147,1688454000"; 
   d="scan'208";a="888043954"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 14 Sep 2023 19:22:22 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Thu, 14 Sep 2023 19:22:55 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32; Thu, 14 Sep 2023 19:22:55 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.32 via Frontend Transport; Thu, 14 Sep 2023 19:22:55 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.49) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.32; Thu, 14 Sep 2023 19:22:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=III2pxLSNQYqOeJm25srMhnZD76/dpinYTdPMoe8hFV26Dy08I6TfAZgIxfl4bsi7PtafqrYS5bUtiBC7OYSvL40mDgTo7G6B3njLWhQeDdwgtLXtEZTo7/Rp3mPfHq6AfskQ3cYqHGHapjTvI/r2bshBgegk1n8645YlVZxXMdN+DAIiKASX7eNAYRyLJeFkO5+o0Gpu2aq0T4e9QxRIPX6I0bfH6Hlhzsa/LHxe5epVviCYaGexUtolgFqVxPHLR5re5uQQH9CAnESN+A1BmaUXgLAdKCP8R/hQ6D1RrCF9+qZ15vuqoHiBYEbBdfZCV/Eh9CWQjOjr3Om2c6iiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9qVftlHf2byRilBg+Ke1Iz+lhYxJSd6njGzVDIC0iL8=;
 b=DAR8DkFoDMHHA7iYj/1DyhEHufBe7aCumO3FXPFE3J/83Mqx1WkQyf4qyotxxkimq2serN+ryGUhYNhuVNJJgPcugVWjuFbBX4PrWlfXt5c4PSJ2h7TYt41x8lceErGr69nq9vkdXn1/HQChxumF4fsZwU2CIOkcTqtf3yQDoFyaHyVw7TgNpuDB+Gk1aCQu5EI2EPj25D+yApCwO0JRLsv1W95287pXNLA3Rwr3Rkg1stYbVel9UoQKoKB2xK36cQf/tiBcenUmlpP9qFVGTf3/KiOGXCHZdaaq/Ve/1UiTpt2Po1j65mATE4njjPsGzJYIX0ASFcWilGBOQthS9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by PH7PR11MB5887.namprd11.prod.outlook.com (2603:10b6:510:136::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.20; Fri, 15 Sep
 2023 02:22:53 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::a64d:9793:1235:dd90]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::a64d:9793:1235:dd90%7]) with mapi id 15.20.6792.021; Fri, 15 Sep 2023
 02:22:53 +0000
Message-ID: <1347cf03-4598-f923-74e4-a3d193d9d2e9@intel.com>
Date:   Fri, 15 Sep 2023 10:22:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH v6 06/25] x86/fpu/xstate: Opt-in kernel dynamic bits when
 calculate guest xstate size
Content-Language: en-US
To:     Dave Hansen <dave.hansen@intel.com>, <seanjc@google.com>,
        <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <peterz@infradead.org>, <chao.gao@intel.com>,
        <rick.p.edgecombe@intel.com>, <john.allen@amd.com>
References: <20230914063325.85503-1-weijiang.yang@intel.com>
 <20230914063325.85503-7-weijiang.yang@intel.com>
 <e0db6ffd-5d92-2a1a-bdfb-a190fe1ccd25@intel.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <e0db6ffd-5d92-2a1a-bdfb-a190fe1ccd25@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG3P274CA0015.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::27)
 To PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|PH7PR11MB5887:EE_
X-MS-Office365-Filtering-Correlation-Id: 574679d7-a698-44ee-3c37-08dbb592aa44
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ltCB8PkA9Xp8D5z/t733xl3lWcI4jmuqTHzPKYEHufqULzNmz4kelZraewx59CoCvz36f3spDxBYGZ9RbHehQXBLinS//Jx3n1wXKi64F5wJodgHdfSnlqbDgE7axrLzF/HXCyZ0c5T0YsnF8qLJ17+qFcrhf1PlmOqcGIiPgaqu0biRZmpp1hEsmgFWBxkn0GM1OZVdjec+qfr9c38NtJgA5Njtp1/QhVo0wkwr+IqNcrsBwfGQvJYbUsoTOcmi7IN5QUVZ0g6cutrfzZ54CXnzkc6G0+rIiKLgqqvaDPK89Q/0QeJdQfRc/uAK5S+jKgunzBDmt6JURBbUI4zi3+LuvgTN7KmMk4mpYo/cq75BRoIiEo8ChViICFAnsL18CwSPOoryQHp8yLNCc7noA1GlcMPR//CXB8Ch4WqBLWX3sDf3DIiDtOgER3LZKTsCXXCDe8T1jkPMcakQBgg5gStsCQbFgs/CZiZdhvLMei/szveZMjpBCCeDwJhlqoO3zZvsW+MCKVGm+oilOATRTLr2mc4QqvoeOo9WUgNgrv11VVYyGQ05bkpqq2Yt+utufAojK3NTenJbxniLzh5XCdXqMZAGbS+Al18FZrc6yxoRUHWEHqNqK/vZ1a6Wkd9p0NB1dcfbxnjC4Z3/42FstQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(366004)(39860400002)(346002)(396003)(376002)(451199024)(1800799009)(186009)(31686004)(38100700002)(36756003)(82960400001)(31696002)(86362001)(6506007)(6486002)(53546011)(6666004)(478600001)(5660300002)(66946007)(8936002)(8676002)(4326008)(66556008)(66476007)(2906002)(6512007)(83380400001)(316002)(41300700001)(26005)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cndPdVlIR04zMTQ4UjlvWDF2RXY2V0FmYTZJaEk4NkszSFNuWXV5NlZDbjcr?=
 =?utf-8?B?YU1Fay9zUUJKRlYzaU42dCtiaHR6ZzllTEhadHJtUjU4K3h3dnVmN3JGMkpS?=
 =?utf-8?B?UjlZTnlEc0FGZE1tbUNJdE9QbllKWWJCOW9ZSEtUcGpJRnl5cS9Da1pHM0FF?=
 =?utf-8?B?K2ROVk0wRDdEdU5rYW9XZEZGMnFlN1UzUWVSWU9JdDErNmxNSmF1UDArdGRJ?=
 =?utf-8?B?MlNIU25POUlrRW4vZmQxL2tHcVl6RVlwWDEzbldOQjVFV2wxc25JK01JVmV6?=
 =?utf-8?B?WW14dWl5c1NPVytsNkhYZHVjdk5hOGRpdUZzV29wejNDSUZONStlc2U3eS9C?=
 =?utf-8?B?Z3E1a2E3RUNhaVRQam5CZFlacVgrYXl5RmZZMUtnNStIVUlMbDNtZU5sbDhy?=
 =?utf-8?B?cmo3MG9hRW9UN1M1OVpKM0c4S2hmaFNsZ3ZhNVp4WEp1cHRMaFkrWElSMmVi?=
 =?utf-8?B?U3FmTTFVRjFoLzh3eXZVditacnh3d2tiSTRTRFpmVm1tMTdCQjNDczVJTWRt?=
 =?utf-8?B?MnVLWHdtODQ0aHVLcGpRbkVwUTlyNjhVTkdvbGtUbmVjajc0QlBUQkY4VTJC?=
 =?utf-8?B?cVZvV28yNitnVlFGNnR0VENzOERYUDJCT0wybHdtajB4SVZmWDRIdGxscUJw?=
 =?utf-8?B?UGZCdzlUZ3k0M1pINUVpV2R5YTlHU0UwdXkxVlI5Y29IQU5HeVQ2a2h1STk5?=
 =?utf-8?B?WFpMd0dmNHpVU3lxay8rbUNVM2NKWVBXaXZBeVllRDgxUDdxRUJnSHV1TDVL?=
 =?utf-8?B?Tms4V1dVNE5selNVOFNPdWk4Smo3TjNONjAwMkZHNkhjVUJTVXNNTjNIKys0?=
 =?utf-8?B?WVlVZHpIYXVsdytEd2hJQ1BQa0pKaGx0WDZLZVYxRWg3UEl5dUJDTnowMnI4?=
 =?utf-8?B?WkVWa1dpWEhYTVBTak1OR3dOTXE3Qzd0UEpIaVhwWktCMlZ0b2xsZHd0eDNW?=
 =?utf-8?B?WHBIYmJzY3RncVhoV0ZwSmNyS2xidGd4K3NYUDZwaXgzWWN2d2tKOTVFU28x?=
 =?utf-8?B?RmNiekNlbHRldnlSNkp2OTZ0cExyc1BkNW9sNVZwbk1YTmpKeVdXODhrQXVO?=
 =?utf-8?B?bng2NkFuVVhBTUk1ZEowU0k0Z2JkMzNWVEo3YUFzc2pXVjdCRGdkQjR4c2tu?=
 =?utf-8?B?MkNNQXdwUDJQUVJiejEwb0JYN2xsT1B4OVdmalh6V2xRNjFGTXc4QmFFL0kv?=
 =?utf-8?B?NWMrMVBGOXNaZ29SaFVkaEFoS1pGSnlXU3JJUmRtMkh3blJXS3REMjhBYUU5?=
 =?utf-8?B?ZVZYV0QvMHFxVS92NCtCbml0TE9POHgyMWFiRlRJUHdPRzlBNWhYQ3pPNGpy?=
 =?utf-8?B?WHNoUUZqbHpyYXFmNi9WdUtiQUlHanlPS3JnUnVCbVl4bzhCcFF4RHNORFRZ?=
 =?utf-8?B?Y2lVTVA4bXV2SWpkRnFmNm9CZng5c2NTc3JoN1Z0SEtleW8weFZxR1BrVkdD?=
 =?utf-8?B?b05iV2JadXIxNStoNkQzcXY1NUR3V0xwZ1JxT2NNK0VGRmlzZ2JOSVBrR0ZF?=
 =?utf-8?B?dHNZUzdyWXJCMHlYOVBGSXJDQVBMRW9mdGZIWW1oL0dCMlkwejMzMU5iL3hy?=
 =?utf-8?B?ZXlXNWpSbnIyY21LQVRRaGkveDJjc2dvcjlJT0JNTmsrRHdLYTFGdk52Y1Vn?=
 =?utf-8?B?RmRHMFh5Tm5vM3NZQ0w4VEszeUN3OFFWeEZRK2IrYnV2Y3hwUFI4bHRoSHls?=
 =?utf-8?B?N2Y2bnZmbTVtM0hpQ29OZ3l2YmpsSFVuaHhwWWdwdmRCOExveWpOblFFQ2lu?=
 =?utf-8?B?NXNoOVJVei8vcUYrWGY0TlF5blF5Y2JiK1NBZlFqcUFFWEVpTUdRWUFMQ1Y5?=
 =?utf-8?B?R3FqS3dURjR5S05zNkZsa3pXeGk4Vk1MYUNyUXdvbHp6K1V0Wlk2MzNnbXdO?=
 =?utf-8?B?dTNPUmRXdzQ2WGRvUkJyWjUveVFMcXprVE5rSUNBYkVOK0Eybnoyc2dseEhU?=
 =?utf-8?B?N2ZNckZoRExiTERQcUlOdGhybEt3aGFFR3BUMmJjUUNqQTh4Y0hmcXZOdGxM?=
 =?utf-8?B?TzFERDZYdnd0SlJna3A0QVNMbklMV0NuMnFyamdkSHFXNGVxNGlMSk9IaEI1?=
 =?utf-8?B?SDRSMW5RYnBRK01IQy9vYWdOQ2V5WHpneUd1cEw5R2VqRENiWkdoTjBsL0wy?=
 =?utf-8?B?dkpvdXpsMlBkM1NGQUZrSUF4Y1UyWDMvRStVSDJsVEI4QmYxNHl5bnRxRjBy?=
 =?utf-8?B?a3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 574679d7-a698-44ee-3c37-08dbb592aa44
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2023 02:22:53.1189
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NR13/7SSp5TInxdH+aZMQbxmEnZbTMm9KLPdvg2LPMrcq2/sI7z8uqBCIl3gZrtAwWpJ7Ma4VR1aK2OFOD5+xA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5887
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/15/2023 1:40 AM, Dave Hansen wrote:
> On 9/13/23 23:33, Yang Weijiang wrote:
>> --- a/arch/x86/kernel/fpu/xstate.c
>> +++ b/arch/x86/kernel/fpu/xstate.c
>> @@ -1636,9 +1636,17 @@ static int __xstate_request_perm(u64 permitted, u64 requested, bool guest)
>>   
>>   	/* Calculate the resulting kernel state size */
>>   	mask = permitted | requested;
>> -	/* Take supervisor states into account on the host */
>> +	/*
>> +	 * Take supervisor states into account on the host. And add
>> +	 * kernel dynamic xfeatures to guest since guest kernel may
>> +	 * enable corresponding CPU feaures and the xstate registers
>> +	 * need to be saved/restored properly.
>> +	 */
>>   	if (!guest)
>>   		mask |= xfeatures_mask_supervisor();
>> +	else
>> +		mask |= fpu_kernel_dynamic_xfeatures;
>> +
>>   	ksize = xstate_calculate_size(mask, compacted);
> Heh, you changed the "guest" naming in "fpu_kernel_dynamic_xfeatures"
> but didn't change the logic.
>
> As it's coded at the moment *ALL* "fpu_kernel_dynamic_xfeatures" are
> guest xfeatures.  So, they're different in name only.
>
> If you want to change the rules for guests, we have *ONE* place that's
> done: fpstate_reset().  It establishes the permissions and the sizes for
> the default guest FPU.  Start there.  If you want to make the guest
> defaults include XFEATURE_CET_USER, then you need to put the bit in *there*.

Yeah, fpstate_reset() is the right place to hold the guest init permits and  propagate
them here, thanks for the suggestion!

Nit, did you actually mean XFEATURE_CET_KERNEL instead of XFEATURE_CET_USER above?
because the latter is already supported by upstream kernel.

> The other option is to have the KVM code actually go and "request" that
> the dynamic states get added to 'fpu->guest_perm'.

Yes, compared with above option, it will change current userspace handling logic, i.e.,
only user xstates are dynamically requested. So I'd try above option first.

>   Would there ever be
> any reason for KVM to be on a system which supports a dynamic kernel
> feature but where it doesn't get enabled for guest use, or at least
> shouldn't have the FPU space allocated?

I haven't heard of that kind of usage for other features so far, CET supervisor xstate is the
only dynamic kernel feature now,  not sure whether other CPU features having supervisor
xstate would share the handling logic like CET does one day.


