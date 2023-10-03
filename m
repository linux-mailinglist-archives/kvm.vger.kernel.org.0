Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68E197B60D6
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 08:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230296AbjJCGgp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 02:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjJCGgo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 02:36:44 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2057.outbound.protection.outlook.com [40.107.102.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B00C58E;
        Mon,  2 Oct 2023 23:36:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kt9W3h5zvQo9Bu7fsL3L+GIDO727eU9pigJJhBjoQQLjjh6/oFRw3ucmP6z/u/hL0vHa/OrJa4Y3NV6J+WyKHyoXGIg5eYAZPsPO+59h1Q58u5tb1HqVOeRpBG2AiPtoT7qapVqKN3MT5Nxb5cLalkuZD13u7szAUAXoL13IEakkmJ5IUKP1RAPi0y6IgcA/mUakS1tkb4DMq5zM/KPu7UhQZukV4QA049Tf9+C5vRrJ+7D1fCIjs4Q9gBjnQA5JKYYpnauBzjKPmDHs6ktZJuAVdkmRJAi/7i+y7Zxw8aaf0hEhi8DAciRyTWftkxQlzJOOLEmRRdHWRJmM978G8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3xxKAg0PIb61KY+HwHmXrOVRDacwz6BPcVGu1O/vqco=;
 b=JEgXrEUe3jBK5RZj7ClAyqV+3mgkdPnQ8invEhFE9Qrk/RIXvE/vfARPgpSe3jjFfQ7C769VCjteWyLQy28Dh29xfScrveavUseh6hNvbamXMILwnKtELiqPF+Q0JXkZgIbQaDW0CBqrrsc49qQY5mLQvJFX4xlcAHu9Ix1lXbbTlSbVOxoccGYaYpQXe9j055ReJUpm9Wk4p8uHSiQtBpjM1vdbqmw8spZMzvQenfGOVyw+lEUOM7MP9B1pZ4cyLl/Nu5XzLE+1mXGvL9zjLFsvkpvjFwC4GFdvC3IcMM1bRt+OhEbMCGrnRPZb+EY60+oGYRnNOb4h6hJ/v3+6aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3xxKAg0PIb61KY+HwHmXrOVRDacwz6BPcVGu1O/vqco=;
 b=xT1aDz6FYNO/m4gAENlfwzmxO+oWwrlAxl0toVgnYOUXAifrJZNqEmM0X1fJeZGlD0Ct6atIoyNxWRpFWejs/NyYhPzPR4nBcWSIEL5Lbt9d98dl+xxOu6t5ob4t4vwuCeuOhSJKhNws2xdiJ4mU10mqg/Ci4ab8KVdMI6HGaoc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from PH7PR12MB6588.namprd12.prod.outlook.com (2603:10b6:510:210::10)
 by CH3PR12MB8969.namprd12.prod.outlook.com (2603:10b6:610:17c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6838.31; Tue, 3 Oct
 2023 06:36:38 +0000
Received: from PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::a4ed:10a6:876a:10d7]) by PH7PR12MB6588.namprd12.prod.outlook.com
 ([fe80::a4ed:10a6:876a:10d7%3]) with mapi id 15.20.6838.024; Tue, 3 Oct 2023
 06:36:38 +0000
Message-ID: <a34053f8-233f-3ea3-0f74-863f8de2e7b2@amd.com>
Date:   Tue, 3 Oct 2023 12:06:12 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
From:   Ravi Bangoria <ravi.bangoria@amd.com>
Subject: Re: [Patch v4 07/13] perf/x86: Add constraint for guest perf metrics
 event
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Dapeng Mi <dapeng1.mi@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Like Xu <likexu@tencent.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>, kvm@vger.kernel.org,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhang Xiong <xiong.y.zhang@intel.com>,
        Lv Zhiyuan <zhiyuan.lv@intel.com>,
        Yang Weijiang <weijiang.yang@intel.com>,
        Dapeng Mi <dapeng1.mi@intel.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Manali Shukla <manali.shukla@amd.com>,
        Ravi Bangoria <ravi.bangoria@amd.com>
References: <20230927033124.1226509-1-dapeng1.mi@linux.intel.com>
 <20230927033124.1226509-8-dapeng1.mi@linux.intel.com>
 <20230927113312.GD21810@noisy.programming.kicks-ass.net>
 <ZRRl6y1GL-7RM63x@google.com>
 <20230929115344.GE6282@noisy.programming.kicks-ass.net>
 <957d37c8-c833-e1d3-2afb-45e5ef695b22@amd.com>
 <20231002122909.GC13957@noisy.programming.kicks-ass.net>
Content-Language: en-US
In-Reply-To: <20231002122909.GC13957@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0153.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:26::8) To PH7PR12MB6588.namprd12.prod.outlook.com
 (2603:10b6:510:210::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB6588:EE_|CH3PR12MB8969:EE_
X-MS-Office365-Filtering-Correlation-Id: ddb88878-350b-4370-06d1-08dbc3db0d16
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dNjXJHkegZ6ozQOd2QgzTozwGaECYoLyZe3MFYL6MCMvX/vxqx1InnT2hFkROi2J65HBpf6qxQbc9V3DP0rj3poMz/YrylkqjO7GM9oxe7GHLv3iX1zgKAzSaBjxHh0+6ttKKZF4YuwroEwnYpdAGkRTipWUNx5TfrDshr02HAuVKFpSRB5xt/dTOEDoukgjzyWSYo3R11GMuDTah4wEbJlqm3he2MIfni92OEa0JrXOjz9o/ylKloYKiqBuZw1mpXPjFJxm09MRtRI3ibVgH0VnSwWJkR0XSiMXcuQEIwclBVoCfQMzoZ+LebjVQ/7LdJw8B7quhGCvXPtzi95K8ZtvTDOngBHEqG3vFFuC471vkPeNa/t5hYQ3Zb5BhuTAowg+oSr4PZsLN01L1kqudrugj0Omr5/vNoeAPR6Z/If1Eo5IrNJaRAQD+RbRcTHFF5A7Hkc+fzbExBA2dEJg/aQxyvDoy6/RCVPDw1CBbzofiNa5rSOfHmY2mHY/n4D1LnfoSJtNhuh1mqdN7v8q06gJ9soP58t8+3cfZroe3i9Y4d/cFPJ5u30zuZKBmBG062jnbNLR+iGidDCJArpNQH3bxZZ1449py0XHPE5UDil2wze+qrTFoK03w8tiaXlnNYuHlBYnjlyL/9izo9GhsQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB6588.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(376002)(39860400002)(346002)(396003)(136003)(230922051799003)(186009)(1800799009)(451199024)(64100799003)(31686004)(53546011)(2616005)(6486002)(6512007)(6506007)(31696002)(38100700002)(36756003)(86362001)(478600001)(7416002)(26005)(2906002)(966005)(6666004)(4326008)(8676002)(316002)(8936002)(41300700001)(66476007)(5660300002)(54906003)(44832011)(66946007)(6916009)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TDlOeWNLNGl3Ylh3eWhRQmlvRjY0MFVuUXdDYlQvbWNEbEowVW5kOHc4M1dq?=
 =?utf-8?B?WEVpRW8yaEdRdW5RcmdtTDJGdW94UkZjUGUvRXF4Mk5kTzlmdk9Jd0RYZVBl?=
 =?utf-8?B?dTFwRDdZbWx0ZzJzU29OV201T3lobm10WFN4OWt3akJxU2haWm1adG1kMnVM?=
 =?utf-8?B?MEt5TndXa2RVWUNwV0R1d3J2L3lOUEJlMkU1VU1RNkh0YWhKRzRGaUpUUGZp?=
 =?utf-8?B?a2dwOHFWNCtWdnRtYytHaXJVMmttL3p6SVg3bEhjWGRYK2c5Q01SMG8zNFZJ?=
 =?utf-8?B?M1lrdzdmd2NMM0txZHh1aHc3NGNGU0tMdU9pa0dBemkzaE5HZDNwVHM5ZWwx?=
 =?utf-8?B?Z0ZKZUJKS25HM0FFZDQ3cm04eldCajRmTDVBVlQwRndkZG41WHo4dVM4SHB6?=
 =?utf-8?B?bXpBalBsZE1ZaFF4TXVvem0yQXdDWk1keDFPS0ZKR29kb2lYQmxUWmdycUV2?=
 =?utf-8?B?NFhnQmZUOFYzQlpNenhMWVlsNDk2ZXZzUG53ck1TSkZ1eGMzdG1ndW1xbDJ5?=
 =?utf-8?B?aDE0SkkwOW9WQ0VHa1NYYnNRd3JDcS9TRmRGQjZnTFA4TCtpUWQ2TDNFa01h?=
 =?utf-8?B?VDFyY3JVM2Y0bm5oOGl4TG9nRzZJbjcrMCtVMXpjYnB6eHdKaFVJOFFTaUxI?=
 =?utf-8?B?WEpDUkQvUFBSMi96dGdoS2NJazdBL1VsWWdMUjlwVXVCakphTTl4VDRiRW56?=
 =?utf-8?B?c0RsMUNOS2hYMGt6dW5LdWxDbWpNQUpYNGpnVTZreExJTmJiblZKRjNwRXhn?=
 =?utf-8?B?SnBoc0poT1d4aE1pYTYxK1cvVkIxZzV6T2w5SVRGeEpDVXNLdDZnM1M2MUdU?=
 =?utf-8?B?dmdzZlR5OWdzQU54cVl5WW1JWXdMZ0hWNU9BVTQ2bWwvaU5KZmZLd1VsaThE?=
 =?utf-8?B?eFBLVjAxYS9Mb3RhL1BTckNMUVVlclhhQWZ5cmE5Y1RUNUxPR29IaHlzbTRX?=
 =?utf-8?B?LzJaWW45eExoTHQwN2xIR3o3WmhvMTJWTnRGWURMTjV4OTN3d1o3Y2pJaUgr?=
 =?utf-8?B?bitOaFdoUGcraGZzanUwQnhTakZyRkhXUXVEN3R2SnF4OVIrcjltSVU0VXhl?=
 =?utf-8?B?QlhjajEwQ05HNU9pcGZvZmZhYkN0bTFCUjVabXpGNnZXZ3gvSEk1TDNpbzVa?=
 =?utf-8?B?ZUc1UnlLVVJKenFQeWd6ZXJ3SnZLUU9IOC9IbFJpaExFMTllTHYvVjFLOEts?=
 =?utf-8?B?Y0hHWGdrYUpOeHk0OUlaclRzWTA0U3d2clp2amNjdW1tVmZGZ2V2aitxUG9s?=
 =?utf-8?B?NVJ0ZkFwVnY3T0hydHVBZlNodllBWHJFMFFXUGhJSlEvMHRzRlMxSlhEN3Ja?=
 =?utf-8?B?cFBkQnJVMktPVDBheEJnYzIrRDJicnFJVEc1bVRsdDJzZTQwUnJmUEFxd29C?=
 =?utf-8?B?RzBTa2htK01Gd1hBU1BobkIxWUp0ZGtmZnNLZjE0Qi9kK1ptK0VoNU9wcXVR?=
 =?utf-8?B?RkVtKzZkYVRJUmx1UlozaUJjUzhjdVlPangxTmRUTys5dWZxWHd0SEZmbTNG?=
 =?utf-8?B?WGNJRXFxT1VTT2U0a1pLaUpPVVhKRDNLZjFSQ3BvbTlhSHA3aVRzY2RjRzFZ?=
 =?utf-8?B?MFI3MWFKY0RIZGk3Z2RXZDZIM3R4V3ZHd2lTU0Y2MzJ1U1JQZkoveVpwaWxI?=
 =?utf-8?B?N0dQSjNlVS9WeUgwZmtNMXNwTUVKaUErSlhvQ0k2TktVaXlvWDFtMDZoK3VD?=
 =?utf-8?B?SG1wZFVXUlp5NVMzV1RQRk90eHlTb293RDRUKytyZXdod3ZvSDRjc0NXU3dv?=
 =?utf-8?B?c3NGZmdoTmczZ284THBFY2FnM0ExWmpNWVJpZU5KbjJjUmtlbTdNSzE4ZTJN?=
 =?utf-8?B?OUFybjFkOFVjY2FVSkNmcGlYNXBmUlZZRGpSUDNsUU82T0taNktYalJDRnFn?=
 =?utf-8?B?UG1OK0l3VXJ5bldrVHBxN1R0d29Qd0ttaGFOdzlVSWJDdjFTVk1xUmh2dHBn?=
 =?utf-8?B?OXV1eFd6MEdDUndrRG5YeWI2TU8wa2gvTDZjc2dsSmNFOGpQZEp0S1JicFk1?=
 =?utf-8?B?aEVXTmxKMGcyWFpMTXUremNOMllBclduTng2SHZMVk5kSlFWUGJNT2d0SlpB?=
 =?utf-8?B?Y3Y4bms1dXR4djZxWE02NGJRNHpnb0QyaTZpekdZZmU0VVhsQ2k2Tk81aHFM?=
 =?utf-8?Q?5xJSr2yVrN8dlePQNZ28MRuzs?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddb88878-350b-4370-06d1-08dbc3db0d16
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB6588.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Oct 2023 06:36:19.1407
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W0qNnjrZ1fLW53Bayv42D0WkQVaALQJVRzfA7S7s6l0dBsoJS9+5yWrAkgRE+DVcteoaTs2fqc86WqkH14T5eQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8969
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02-Oct-23 5:59 PM, Peter Zijlstra wrote:
> On Fri, Sep 29, 2023 at 08:50:07PM +0530, Ravi Bangoria wrote:
>> On 29-Sep-23 5:23 PM, Peter Zijlstra wrote:
> 
>>> I don't think you need to go that far, host can use PMU just fine as
>>> long as it doesn't overlap with a vCPU. Basically, if you force
>>> perf_attr::exclude_guest on everything your vCPU can haz the full thing.
> 
> ^ this..
> 
>> How about keying off based on PMU specific KVM module parameter? Something
>> like what Manali has proposed for AMD VIBS? Please see solution 1.1:
>>
>> https://lore.kernel.org/r/3a6c693e-1ef4-6542-bc90-d4468773b97d@amd.com
> 
> So I hadn't read that, but isn't that more or less what I proposed
> above?

Yes, it's pretty much same as:

   "Like I wrote, all we need to do is ensure vCPU tasks will never have a
   perf-event scheduled that covers guest mode. Currently this would be
   achievable by having event creation for both:

    - CPU events without attr::exclude_guest=1, and
    - task events for vCPU task of interest without attr::exclude_guest=1

   error with -EBUSY or something."

Thanks,
Ravi
