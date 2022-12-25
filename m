Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE31E655C56
	for <lists+kvm@lfdr.de>; Sun, 25 Dec 2022 05:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbiLYEMk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Dec 2022 23:12:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiLYEMh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Dec 2022 23:12:37 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C47627D;
        Sat, 24 Dec 2022 20:12:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671941556; x=1703477556;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ba85H/TzlslJ5xm3TMefgYEClE8gcOtHQUUMvUBjbwA=;
  b=YODAr1riylT2PByCMTsW8azsUAJfZrwCpOw6O8ybz060eckoQ88UoZw0
   34oIgPMk9fyQYamPsyva1dgf0g45RffNhPmPTZ7mWtG11phnx71YjFK5N
   JXCSiY4nbz/6e43/wM5Ka9vKSqKvfAxIgzdJXjN5uedL7aZgIawNxKKXO
   e7hFqRiZTp9bs+fejiFIbgXecqnFvtuO9BnwJIMYsHkFJhoHQSHyqGqtC
   DXYSp6+92MVsoKOhER4gEPhJw+eXChQporoo2T47MDwE/BgJtc3EI6F6b
   NEQ9binVbJimqOR+4pzFgptHrw2sQi3WIVXoKN8DHWXDOn8x6LLylwc04
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10571"; a="322417843"
X-IronPort-AV: E=Sophos;i="5.96,272,1665471600"; 
   d="scan'208";a="322417843"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Dec 2022 20:12:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10571"; a="684869469"
X-IronPort-AV: E=Sophos;i="5.96,272,1665471600"; 
   d="scan'208";a="684869469"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP; 24 Dec 2022 20:12:35 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sat, 24 Dec 2022 20:12:34 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sat, 24 Dec 2022 20:12:34 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sat, 24 Dec 2022 20:12:34 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sat, 24 Dec 2022 20:12:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fIUsXB6xiImbo3MTuJQkNzxCrIUIQPgfYl4L8UCiQJZcP08F2H9PypKL7fmOxkk2IbFztpFoUeNcE+wG9MItcf+0IODdmNda2QWfYOFIpyEHUXj2vNSxxqwFc3JGPpt3xCy8Z1ybHmy9N1d4HM4CQ0eWmQptXL7MxNdURTiyw+CinRl+DuLHLJtqW/mRfsQvFn3tCG6fdkL3OBzMTwfDfR0X6vjvCpoX8EtWxD97WXZ3tyLgnKWZqAwLFC5k0uqiOxlefvH215P39eRAzh6nAYYBe8bFTLMtx8AO+/vM6U5N5P9LurE1WIr8uUikRcpBO72MPN8zUv4fzlkxWZyH6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7OV+zLCYr3en7yMl+OphJSnLF7X3qkY/3LJiBvp7tto=;
 b=JLfl+GUPpaIez+oAeeaVyRLD3AV3p1cQjlB2a0l4dlU30uJ3Zf+fzK1OiVmYKB0QChXs9MKKbvmz24vu3xJY2kIzvTj4uG/PCccUfiRSk1egq41mK7f5IAmhnLouA6iH/E3Z/gvAgX492tOJmSg6vx+UK3gJE02FtjUXg+L4lBky0kBzgKn5K+4/tK8TBt8jm5CIDjKDa5zPE+tLbYlH5VD5S/p1OGh6M6mtWH8/95Rfb/pZZ5GFOV2Y6vvy9JBW7WsW7k5gBcmMyLI01lDoQu5EMqHJw/lG0C/5W52C86bspVQUV0ioYAcE2PrxvaZrtfMrFcFG1kPjYegthyG3Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by PH0PR11MB5580.namprd11.prod.outlook.com (2603:10b6:510:e5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.16; Sun, 25 Dec
 2022 04:12:30 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ae1a:fa3e:e36e:c2fe]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ae1a:fa3e:e36e:c2fe%3]) with mapi id 15.20.5944.014; Sun, 25 Dec 2022
 04:12:30 +0000
Message-ID: <f993243f-e504-cbbf-d4b9-ebf1ec64c75c@intel.com>
Date:   Sun, 25 Dec 2022 12:12:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2 12/15] KVM: x86/vmx: Disable Arch LBREn bit in #DB and
 warm reset
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>
CC:     <kan.liang@linux.intel.com>, <wei.w.wang@intel.com>,
        <seanjc@google.com>, <pbonzini@redhat.com>, <jmattson@google.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20221125040604.5051-1-weijiang.yang@intel.com>
 <20221125040604.5051-13-weijiang.yang@intel.com>
 <195c26b7-783f-fc27-1a60-b0dcd1de01ac@gmail.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <195c26b7-783f-fc27-1a60-b0dcd1de01ac@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR01CA0193.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::18) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|PH0PR11MB5580:EE_
X-MS-Office365-Filtering-Correlation-Id: 542d4d96-4e66-48df-920f-08dae62e3db4
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wlNTSuH4wnm2klI7lkf+E0y/swp7nbQjU8zVXHHvaXQmFMcMHRlqIRDEmtzBoC3YNEB9nD8or3FjO0ABmO0VvrLEJ59Jzg3IXHhigluSNSgq//PnuooTjoRmgVYgHLusQebjpxR2aZOidFSsAmhr5dlqrwE+Jq0OU/+wWw3BOaww2VMNhHVmREgNP7UpyToaR+TWVV0HQEn62pN20N+Xw4/hXZ0bGvstQTVVXs/ho2N1O7ccVa5cMPfhIV/3apUT6rS1+EBZAT3dRIS7cD2qcqgc20Lpq2csxvl46iLWWXF5JBsqf9R8EsQArd1pbKovzSIu4ql06WDxVIbq6Tqu61UGT5rOZxamUkBzUANetgbUGdPE3fFNkyCl+Z9OBNV3SQHWimgr5ypLf7C+dryAsbOGfQNM6HxaxqGdvVHBfi3pDKsotLObaksZZ38KChJl3dyUkvTK1eZYj9nTSQnw9EuBogC1wJzBP7I83FQT+Zpx/Ze6bdHW15/EuaUO+4dA3gZ2j1PYy6JQ4DP4UILythk1ZmSQOZbB8CvlZmEUBMBqWOp2/TgESSZ+PYTmX5KOI2DAN1t0Q/pRN7DaBr57YssYVrVQtH7MCqckbYW3gy9Mx3Q/ylAJeaoGWBMWlpvwXiFYH0SEXCD1MK9H3dZnQP1YhCGp0uCrk4N8O3xraXU2AidSiS5Fkhl6rdSq0v581Dq5JWWIFMGbqrzmqhvBzvM0ahRYbVUmozn0ze3Uh6k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(376002)(136003)(366004)(346002)(451199015)(66476007)(5660300002)(66946007)(66556008)(8676002)(4326008)(8936002)(41300700001)(31686004)(316002)(36756003)(6666004)(478600001)(6486002)(2906002)(6916009)(53546011)(186003)(6512007)(6506007)(26005)(2616005)(31696002)(86362001)(83380400001)(82960400001)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WGRGRGhwZUtBNTZqQWZZeUNmQitaNmRLQnpJM2E4VEJzNXllaEtWa1R6bERl?=
 =?utf-8?B?MjQrZG5GTk1tdXVyc1dMMUpLK0tZZmpXUHo1cEF6aVVGSzI2bjJvNllnM3pT?=
 =?utf-8?B?YXNMcFVFYjhpeWFiamtqVUh2Y0xvdUxQc3lsS3J3a0VnSXcxNCs5TlA0WTlF?=
 =?utf-8?B?ZWtINy9PZlduT0hveStzbjM4aDZHWENzb21sZVJmbUh4K0k2WEdWNTRYR0N5?=
 =?utf-8?B?eURXTE9xajRIc3NManRIbHRscDZQU2dhWVJ2TVVvVktUSHY2MEEvbzBnTi9U?=
 =?utf-8?B?WkdWcGFEYjhDQVZrNXZWU2RDUEN2aTd2UmhaTkEvMlRDV3hVNmxaOGIwWTN5?=
 =?utf-8?B?Z1J3bFNPOGN2cjVZUW1Jc3hvajByZ0JzS3lVdXVLQTdpVTQ4QTNXYk50RDhm?=
 =?utf-8?B?cWZxWlgvTjV5TlU1SWdyU203L1dtbVJkclFRZmJPUURMUHF1T1h4T2Z0MXlG?=
 =?utf-8?B?Z0dCOWowL3llRjRXemNyc3BPc1ZDY0dCYzVleUx3UHZBNGhBOHpsYzZLME5C?=
 =?utf-8?B?c2VQbUJxZTV1Nk5FbjFUU2d2MTJQa0gyNlVack9uNGpuVUpGN29LalhXakVk?=
 =?utf-8?B?bk8wVUtWR2RHWEZEb3ZXQU9NcmpKL2o4WkxWTWJucGh5YUtrblpJUkNiTHBq?=
 =?utf-8?B?OHJhb3Y2dE1jbmVQZnR2MWU3L2lpQ0ZaVmsrVXJ4eWlEb1U4Wm9RbmtyTlhq?=
 =?utf-8?B?RnJHM3FoYUN2YnNXdHo5cXNybXY1bGFSeHlieUx0NCtXUmNJUWRicmw2dlA3?=
 =?utf-8?B?dER6a0N6U1JYZzE0T3VHSXowQnZEb3NJeHpxcTIvMWg2QjlsUXA5cmpyWDZ1?=
 =?utf-8?B?TitIdTJjZ00xSWxTUU1INnI1ZUJMazVTcTdNR0cwc3Zsd0Y1RXBWWTZrZitj?=
 =?utf-8?B?Q3hWNW94c0piSHNMM01zblJKSmdwa0o5Nk5LVkoxZWVWZjhjQnU1RHg1MlEv?=
 =?utf-8?B?eHVodS8ybXE4NUxTVlozdCtWaWZUVnBoVXBFYjlEb255SHc4YlhvL2tOK1FQ?=
 =?utf-8?B?dGJ0OTdvbG9MbzZqUkNjUHp6R3VFK1VLWXhXQVZTNzMyRTNBVGdTcDVYeHJQ?=
 =?utf-8?B?ekxtdXJJdFI2Z1R2bGhwZ0JpekRkVHZlWDNuOEROUEx4OE5vdzd2Z2xjYlZa?=
 =?utf-8?B?QWMvWFErdnRWYUlaMjlCSVBVVFpXL3ZjSGpCU2s2WHVyVTk1UFdSWHdXejVM?=
 =?utf-8?B?OFk1RCt0ODZydnJHdWVMM0tETG9VaHBUTTJQUXJSMzdXV2NicldHT0tQYUFZ?=
 =?utf-8?B?S0V3dy9KTWt0eE0zc1JOUDVLTDh5dWdYMFR5cUk4aHZPRFFycHNIYUNodUd5?=
 =?utf-8?B?TE9zOUw2NGpOeEpNemhJdllWTmJyUzNPWUNZR0tjbHUzdm9obkRTbEoxVHpv?=
 =?utf-8?B?SUZXOStMTkgyNytrby9rWnpEUk1aRU5QeTc4VEVxbDk3YUNRSms3OEdzc2Rl?=
 =?utf-8?B?T1Q3MUxubEE4TzZlVDVIdFI2VGhZZGdIeVdvbnhZd3JYbnkyOGFJaDhIVWp5?=
 =?utf-8?B?UHJxcUNPUVI2SnkydFI1eCtnclh2YVpaT1ZTcnZXaGJkM2hOSExQQWJjSkVo?=
 =?utf-8?B?TGFGNGhZelpFRnVDd2dqUGZaSnIyQUxEZ0xLQVBxenZiYVNnY0dIRFlDb1Ba?=
 =?utf-8?B?b1BCR2xPaDU1blhpQUhmZ2VvbXdxekY0RHViTE43dnFnem4wYXVPS3B6dUZV?=
 =?utf-8?B?NVZ0Y29iY3BWNktRc0gzZlJGMUc3bTJyQmhnU20xLzRGd1dGb1BhYmlIcml2?=
 =?utf-8?B?NGduTU95cUpyVndDb3VESm5OL25RVHozZnlrRUtrN09sejV1K2hFNE83dkFy?=
 =?utf-8?B?RzZzVWF5NjNhRHIwbFdob2ZRSUYxUTNFQ2U3NkJYOVlyMVViU1JXM2JJRTdS?=
 =?utf-8?B?M1hieXFHYUxYaEJvTGg0d1Voa25Ob1BhWG9Sb2pQcmNneVZTZ093amZhUVht?=
 =?utf-8?B?QWNXNXRTS1NXMS9HZGNxbml0L3VoQmxnbURBMlhKVEhaYWhkMzg1WmxDS3Ex?=
 =?utf-8?B?RXlCTmdEcXo2WndmSHJwNFBONWtWSW5tb2JOSlhFT0l1N3dtRjViR1h4ZHVU?=
 =?utf-8?B?V2prVzk4MGZjU01taWlyYjZmMHd3UXp0UlVPTjlNWDUvam95dmFET1FnbFdG?=
 =?utf-8?B?NnQ3ZFhWMHFzdVhqUk5QeTV2WWhKYzRmWW1DWjRUemxXME8zeHFaUzF5ZVE0?=
 =?utf-8?B?SFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 542d4d96-4e66-48df-920f-08dae62e3db4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Dec 2022 04:12:30.7442
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IFkZbae/qf7T8kd5HeGwx3x7k+gkNrNmCxhkYTU57jRE7FwoswmjikKZ8CEEn0uTf/dGVUs+ep+4ywP7xwSmzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5580
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/22/2022 7:22 PM, Like Xu wrote:
> On 25/11/2022 12:06 pm, Yang Weijiang wrote:
>> +static void disable_arch_lbr_ctl(struct kvm_vcpu *vcpu)
>> +{
>> +    struct lbr_desc *lbr_desc = vcpu_to_lbr_desc(vcpu);
>> +    struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
>> +
>> +    if (kvm_cpu_cap_has(X86_FEATURE_ARCH_LBR) &&
>> +        test_bit(INTEL_PMC_IDX_FIXED_VLBR, pmu->pmc_in_use) &&
>> +        lbr_desc->event) {
>> +        u64 ctl = vmcs_read64(GUEST_IA32_LBR_CTL);
>> +
>> +        vmcs_write64(GUEST_IA32_LBR_CTL, ctl & ~ARCH_LBR_CTL_LBREN);
>> +    }
>> +}
>> +
>>   static void vmx_inject_exception(struct kvm_vcpu *vcpu)
>>   {
>>       struct kvm_queued_exception *ex = &vcpu->arch.exception;
>> @@ -1738,6 +1752,9 @@ static void vmx_inject_exception(struct 
>> kvm_vcpu *vcpu)
>>       vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, intr_info);
>>         vmx_clear_hlt(vcpu);
>> +
>> +    if (ex->vector == DB_VECTOR)
>> +        disable_arch_lbr_ctl(vcpu);
>
> Please verify this with KUT testcase, once I failed and did not confirm
> if it is a hardware issue. Good Luck.


Can  you detail what you want to verify with?



>
>>   }
