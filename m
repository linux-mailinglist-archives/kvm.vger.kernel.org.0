Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED873655C60
	for <lists+kvm@lfdr.de>; Sun, 25 Dec 2022 05:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbiLYEad (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Dec 2022 23:30:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbiLYEaQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Dec 2022 23:30:16 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BC4265D6;
        Sat, 24 Dec 2022 20:30:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671942616; x=1703478616;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kOrODiO+gv1GIv3eiJbtUJCIZVqzA620ei6MEeNa1dw=;
  b=Grdcf6uN6wKQUmoD2pZzsv/k7FwLe0yYWc245ZL7xzXzFu+40IOp1djc
   j7Uu/jPMu8Pio06OyJHgKrgOs08jN7A9iNndDg+5qVIDMfPgXvLmZYdCd
   1qFkUNr3OY1yFUnDkMa2XwLL1+oPd2g0+6gjeSlXVRni2VSBGNquJ7SDV
   dzetLCb3LhAbI9Bv6JFVcQ+ncVln1/YAS2V2d6bY/5m8yFQW2ZyZ4uioP
   qGPMaNVEnmvvTQjt322PfCmMNcK+ooRIyK0l4Z+6IXfgU+u00Xs9VC85J
   jgA6jmCbieb44ezkHav+bW13nFJ0uyxuEhDrxShi7OvN8cow5hSWoLSyB
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10571"; a="347635140"
X-IronPort-AV: E=Sophos;i="5.96,272,1665471600"; 
   d="scan'208";a="347635140"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Dec 2022 20:30:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10571"; a="741188382"
X-IronPort-AV: E=Sophos;i="5.96,272,1665471600"; 
   d="scan'208";a="741188382"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 24 Dec 2022 20:30:15 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sat, 24 Dec 2022 20:30:15 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Sat, 24 Dec 2022 20:30:14 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Sat, 24 Dec 2022 20:30:14 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Sat, 24 Dec 2022 20:30:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V/ux/ArpLNocT8TpCdbNe15MdPGZal7Rb5xTW4ZlJQx0hdHawaryrc0ldXKPK/Srofo1bqx5a7LXzv8pldwbx/LQ6LwzGmq+KRsp0hjwLfs5mp6NnfMzeylVS6N0GIeJuqAiEG1LGRsUF9cKjEWW+aOmObZhIy2N56GUpWzwOjkBtSCjjGY2ixpC8QIu3Ye03QGv2wIjl0UCJRUuzqts9eL7IePHuFUIvdfrrulPiffZPh9SyC2HkA4rDFRYbtyIPQUNCmnjKIWkshjAgCHSN3P7V4NauGpGE8Ex20L9znoB5GAMKf2S5mYvABq50h/ELqo8cLttxAQIJt15SW6+Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kOrODiO+gv1GIv3eiJbtUJCIZVqzA620ei6MEeNa1dw=;
 b=Pldhf5De+z/zwQKhLsZhj695Wjn97VxZ3E468MtItC1cJK4qt9tibrBA7DlVSbVStjTOcipG22GMc58Q5mEIGCEqwoM9J2B3FSrzSekH/MSZVc1k7kzcJCKlekD+ACgLKyErWpJg0VYZsPEVdvFlNNcLH/2rlF0FsoacWcnCxS38kUpSsB1jG0oqMtHaA2KHkdT0nnDDvpXwr0foSg0dyeVl8mfEVNsGwVwJfSTUnkxZkQ+/sYJ2GdFceSz4H0gP1YwJeRWyTFZsSDmAYoYrMmvuZgaPYwQxf9YyradxppbDkjuC0E3EMB1NXxndnK9Keha3sVGpNZtN/omGhT+X3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7)
 by DM4PR11MB6237.namprd11.prod.outlook.com (2603:10b6:8:a9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.15; Sun, 25 Dec
 2022 04:30:11 +0000
Received: from PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ae1a:fa3e:e36e:c2fe]) by PH0PR11MB4965.namprd11.prod.outlook.com
 ([fe80::ae1a:fa3e:e36e:c2fe%3]) with mapi id 15.20.5944.014; Sun, 25 Dec 2022
 04:30:11 +0000
Message-ID: <10275797-aedb-5ad6-1b6e-6cee06a81733@intel.com>
Date:   Sun, 25 Dec 2022 12:30:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2 05/15] KVM: vmx/pmu: Emulate MSR_ARCH_LBR_DEPTH for
 guest Arch LBR
Content-Language: en-US
To:     Like Xu <like.xu.linux@gmail.com>
CC:     <kan.liang@linux.intel.com>, <wei.w.wang@intel.com>,
        <seanjc@google.com>, <pbonzini@redhat.com>, <jmattson@google.com>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20221125040604.5051-1-weijiang.yang@intel.com>
 <20221125040604.5051-6-weijiang.yang@intel.com>
 <b90aefab-e091-7656-b58b-fd2247e8e375@gmail.com>
From:   "Yang, Weijiang" <weijiang.yang@intel.com>
In-Reply-To: <b90aefab-e091-7656-b58b-fd2247e8e375@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI1PR02CA0007.apcprd02.prod.outlook.com
 (2603:1096:4:1f7::6) To PH0PR11MB4965.namprd11.prod.outlook.com
 (2603:10b6:510:34::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4965:EE_|DM4PR11MB6237:EE_
X-MS-Office365-Filtering-Correlation-Id: 49530225-e1b2-47f8-1502-08dae630b61e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B9geDVPV7aAXi2a9Us4K3+9KM9xsBxTzhn/vbxQHK8HYiug47d3EWBBiHLgCy7FF9vltClwqDjeVPvgEuJlzfdjvypcjkPAOoNG7TwZSjXD9YNKKCtUEAHuD5+R/3uOIrhZ2snu9lFTzzBnS8gn9dzWJmoApe+zSRR7KhjOEXKmYFbvpjB9dVoFo36s5FwDerG0ULqreM7tEd4C/j1R9kgsebc73zPZDPAixsCwc0dYj1PMZqU0Xs0Y6UHow7SqxC5gRYvBsxPdrPkzgU7aAL+l8OMSUgyCcRdZUdZr6comlqwyajaEykMnZke07zC5a0FWIT8t01zvT/EF3JNdEzfjR81o1WJIRRdBSKVViCB4kdknbrdlB5oPOmHBUnBuUv6biKzCF4mAw4SXwyxdZ56apKyCjLk5dAtKJgV1+va3XzBb/gpegLqtiwKi3M4vmJ3HJ9aCAAMCkH2WSP7KjwngOvx8jiRuKxLvMAwLbSr7CRqkHpajLqCvXSpDcEz4YZGTfvB+7LZ3RcFNg/sfkCpz5kybTIgGhHHfBT1WNZ9p9cfesgkTAe6EDmUP7Pc5RmoBSKkMiZAXdkwgpxwZXmwH0TojL8+QsMPvxva82g2S29wUh9LDfsxowRzSRxZZhRbuK3sdW5EhtaXCEcCx0csANoa6PEGs2sfaJc5YRc0bii4TIesiPXaPP3G1CcnXo5zf311Gqkra2gPcewMMQChvtt6jQZ3gbte6wmxs80RI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4965.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(396003)(376002)(136003)(39860400002)(451199015)(36756003)(2906002)(82960400001)(38100700002)(5660300002)(8936002)(41300700001)(4744005)(31696002)(86362001)(66946007)(66556008)(66476007)(316002)(6916009)(31686004)(6666004)(6506007)(478600001)(6486002)(6512007)(4326008)(8676002)(186003)(26005)(53546011)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bm11MTl5QkV3MDdPUmRmTmJWTU1wZHVMUjcySTRKWWVaMElSWEN6ODU3bnlQ?=
 =?utf-8?B?RTJXM0NxTm0xdHJGMEM3c2hRM2RUbnJZK1ZlL3BwQUtTVHF5blZJYWF1UWhE?=
 =?utf-8?B?ell0TzdNVTd2N3R5REdyZ2RUREZKOWxtM1RCcjRxU1htWmprM2V3ZlJGZVpY?=
 =?utf-8?B?bGxGeWRJQTNUMGI4RE4zMndPSzc3Q1pHU0dsbTVJUnlyWnNzcENxMWJLRkIr?=
 =?utf-8?B?RElYWS9pREVXUkJnMkFSNGF4bFBmSkdRbENLRURzN0RTZFhsSU1qSmdhdU5m?=
 =?utf-8?B?KzlBMlk3eHhUSjJBL2hRYVc2dWhqMElvR1RKOHp3S1hSeGpoQ0VOT2JYbDVZ?=
 =?utf-8?B?V1JqMjI1cEptRFpwYXpPNWUxUEZkelB1Ky9QMTdSVC9aSDE5RWk4dmwzMUdP?=
 =?utf-8?B?Vm5ieWlmRVhyOTN2ajVQSXdqYXQ2NjFrZTFwMnNNL1NhMGp0cjRBeU9lQjhX?=
 =?utf-8?B?MThWMmxqL3pHcHBucjBxYUsrbzBQemZOSlg4Z2ozcnF3S2hZdHJIbEFHSHds?=
 =?utf-8?B?YnE2eXR3Z3lJTmpCNi9QaFZXMFBGaElkWDUvb0xJTHQrcHpGd1V1R01Tanpi?=
 =?utf-8?B?S29haXpGQUMvVTBDT2tJRHc1aFlPeTFtSGNCZm81eVZTMEN6YnVwbVdjS3ZS?=
 =?utf-8?B?Z2d3WnprZFRpTEJHcUxrdmhyMG56VVBuNm9wUXVoS2dORi9kL09CTEdaTkJN?=
 =?utf-8?B?YkxpeDVrK2dWY01MU1k1amVxaGxWeDhqSXk0YTVaekl4bHJvemFYNGhIYkV6?=
 =?utf-8?B?QUF5RkYzRU04SkEvRkRZTmk5TEhWYnBYeGN3VW5ib3Y2U25OSno5MlJMcmxj?=
 =?utf-8?B?SzlrUUdnaVVVMXI3OFN2WG91bFlCakxHTDczQU9iMWR5YWtFVnpiMjEwb0Zw?=
 =?utf-8?B?d08wNEMxejZkUzZ5aTdpd0VUKzJlNlRDbWVrOGQrUlB4Qk53S3lLTHR2ME1L?=
 =?utf-8?B?YlFPWHlwZmFHaWdnb2VtVm1vUklKWjJhdVZ0NWMyK0w0WUhnMk13aGltMjU3?=
 =?utf-8?B?VldsLzNmUm1kdkVIY3ZxNmw3a2d0VnNVYVBrT3ZxT2YxYkVCQmhtWHJJWjJ4?=
 =?utf-8?B?bzlBc0VjeTZFbHduZ09PSU4wRkJCL0Zib3RyRSt5SmQrTEtERXc4SVB4SjJZ?=
 =?utf-8?B?RzNSc2JBUExUQ3B3TFNRNDR1em9kbWd1RjFCQWJmbnhtYzhBcWRMdmdKOERm?=
 =?utf-8?B?RytQaFl4UzZIY1Z0a3QxUlN3eHlPa1E1QVZ0eFV1aXJ0L1NtWXRHV3pYM2ZG?=
 =?utf-8?B?SlVMTmNIWXV6eWdnc2F6R0lJeXJZbURNdUZsTzV2ZTJDRkJRVEQ5UHd1Lzc0?=
 =?utf-8?B?UXcwSlh5c3JuUi9hME1RMUdPdWFBZXc3ejJQRFFaTjZReWRuUlVkRE4rUnRp?=
 =?utf-8?B?cHVwV0hzdHFtczgvbCtQNDN3WkJLQTZQQlljMjUvSkN0VW1GM0lreTFTYVhI?=
 =?utf-8?B?T29KWGtxR3VVbnJxaGh5alBSVUVpSTQ3Wk0zRnZXVVU0dGczVVdxTnBDQ1Rn?=
 =?utf-8?B?ZU03MnFud3hoSk1PUXhRa1g4QjIyMmx4TGR1ZWRBUnFRYnZZZDVDNGIvcHpE?=
 =?utf-8?B?OHFaTnR5S1FkKzRxMWNucDJSWGJFMXRSd3VzZThxTm9iZXI5NUk3YVBaUHFJ?=
 =?utf-8?B?YVBHR1VoYlZVSTczNG94cVEyRnRIaVJEUWxlc3I4cmZ0UXkyRTl1VjBNUmVn?=
 =?utf-8?B?eU14cm5rdnJwTVB0c2Voand6VVMvd2ZMbkt0MmNzT3lHdHBDUFNvTER0dHVW?=
 =?utf-8?B?dWYyVHUyaFo3bHQ1czNNMzRSVE5aUnJ5ZjNXRlRiamVTSkhudCtCeFRENHcz?=
 =?utf-8?B?SkZPUnpwb1g2dk5iTUo3YTF5ZFdhYVpVVlhtc1gzd2Q5OUN2UmJtVHk1Y2hx?=
 =?utf-8?B?UzB4QTd4L3NGb1JNNCtwZzNqUm03Zkk2S2FnNG0ySCtGaW1qb0I2enR3aWV3?=
 =?utf-8?B?aEJhaWRIcnJTUHhxbUpLck5OdFNtMFd1eHllcFl4TXF6ZnJyZ3JqSHVIakZi?=
 =?utf-8?B?RFUwVmxLT3A3L1M0b0FUbHRHekE0alR1MFUrT2ozNWJsclh6dCtwNC9YV21j?=
 =?utf-8?B?ZWJVdGR0YWY2SmVpRXRCVnVreE5nL3V2b21vbGN2Z2VDSWt4NnBqVmVuV3hm?=
 =?utf-8?B?a1lGeUZmVUtQdXlMbmlrVFZjSXVieWpaaWtBTWdTWmd1L0NtZDN4WTNENzhH?=
 =?utf-8?B?QVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 49530225-e1b2-47f8-1502-08dae630b61e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4965.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Dec 2022 04:30:11.8183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +MaVsv+Qpuv2JGTLRprYtn9t9W6tNk3w8wwDF74lD0q0+YwF5i/9KdNt5vGxHoqCb+a9C2KU6ilsn1Rf67e4Lw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6237
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 12/22/2022 7:00 PM, Like Xu wrote:
> On 25/11/2022 12:05 pm, Yang Weijiang wrote:
>> @@ -571,6 +571,9 @@ struct kvm_pmu {
>>        * redundant check before cleanup if guest don't use vPMU at all.
>>        */
>>       u8 event_count;
>> +
>> +    /* Guest arch lbr depth supported by KVM. */
>> +    u64 kvm_arch_lbr_depth;
>
> Please drop the "kvm_" prefix for per-vcpu "struct kvm_pmu".


OK, will remove it.



>
>>   };
