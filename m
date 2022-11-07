Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2BFF620265
	for <lists+kvm@lfdr.de>; Mon,  7 Nov 2022 23:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232416AbiKGWka (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Nov 2022 17:40:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231883AbiKGWk3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Nov 2022 17:40:29 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2043.outbound.protection.outlook.com [40.107.223.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 331DA205D3;
        Mon,  7 Nov 2022 14:40:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=erkLvg4MOAXQ1qZcxc40QSe2EmrQyOFTHl/gpJ9Rsde6k57RtExYmQ1T3BQr3qyB0FEXKwBke6dnjk6nen6aV0qxj+NMycSRmLKOclLI+y+BKuHP+Zf+gepW6xWQSb0klHl5B62aszp3yFdr+ihsdpY4ZJN40+Hny9ocrUOHixUCgSgg5Z1d9Toii4RCjJWrW0KDl0rTALf5TklgsFhJQPXI58IR2n+GpRLs/cIMOVPOaTMfHWWK+txXDiazgi+Outb2hvAdPA3zAktAzgr3ComWH4PfH2yWjPASBVXH9rHRqjzjNHqBLjpuG9e+0ZiAPSnYx9IJMVoSDguurw9hNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kwTMJ0zseElRsF8yynnzP6Hxm8pgGmAwqEgXqciqQzg=;
 b=eMkYjH/QTZ6GQz/NTHjXG7eX3xDld/TnlgAQK/Z/sgiSuiuOEBGYH5mBAfbSsBSZKvvkGWfkbfQzPQHch9AtA8vEEcQ0F2Te4gK0BK1v8lbTorbf64M7ym85lhZUgCQzw7wtfyKU6wNqAeOPAxAaVUFuuLady4oOeO7Odgj+yjKPv/sk/EEnsFUApwJPRpoHCarsiXOvrg5vyvVrfmA6NCNJvwWGb65TsHMfU9YMvKh7RYLCS1JbKQw4MtOT/LiQldWtQM6UfPnx1PtKwHuHxme+78JkpS8ooE8KuRADz9qjaw30XcTDS0XpR1DbpuVgFFTba4nQ7cRHNJdwSqcAKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kwTMJ0zseElRsF8yynnzP6Hxm8pgGmAwqEgXqciqQzg=;
 b=1wb0H5k2IDrI6d9g+gHmk2XHV5EnS/sycs231wbkp3lwLLTiXcW+YuRqSfsFjwBYq31kWT12C1rI2mYTw8UtJTJLbsqFGDbGjdk/QWVvO4Lj9OOTnvabxhMKZLl09EM3/2wcuTsxhhqnWcbNx0Hb59N1kRJ1dez9LSvbfvEqjls=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6263.namprd12.prod.outlook.com (2603:10b6:8:95::17) by
 CH0PR12MB5347.namprd12.prod.outlook.com (2603:10b6:610:d6::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.25; Mon, 7 Nov 2022 22:40:21 +0000
Received: from DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::6f5:7c8f:32d9:e72c]) by DS7PR12MB6263.namprd12.prod.outlook.com
 ([fe80::6f5:7c8f:32d9:e72c%3]) with mapi id 15.20.5791.026; Mon, 7 Nov 2022
 22:40:21 +0000
Message-ID: <3ee385a8-b4f4-0124-42e1-0f5c2a393456@amd.com>
Date:   Mon, 7 Nov 2022 16:40:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Content-Language: en-US
To:     David Laight <David.Laight@ACULAB.COM>,
        'Borislav Petkov' <bp@alien8.de>
Cc:     "x86@kernel.org" <x86@kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Juergen Gross <jgross@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tony Luck <tony.luck@intel.com>,
        Babu Moger <Babu.Moger@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20221104213651.141057-1-kim.phillips@amd.com>
 <20221104213651.141057-3-kim.phillips@amd.com> <Y2WJjdY3wwQl9/q9@zn.tnic>
 <49e01e4d819a4e3aa1ef13da6bc654e4@AcuMS.aculab.com>
From:   Kim Phillips <kim.phillips@amd.com>
Subject: Re: [PATCH 2/3] x86/speculation: Support Automatic IBRS
In-Reply-To: <49e01e4d819a4e3aa1ef13da6bc654e4@AcuMS.aculab.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0360.namprd03.prod.outlook.com
 (2603:10b6:610:11a::11) To DS7PR12MB6263.namprd12.prod.outlook.com
 (2603:10b6:8:95::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6263:EE_|CH0PR12MB5347:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d190b40-13f8-409a-6872-08dac1110d51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d5/uiX4kPkVjNtoRKiaT4vOrR/dCiPjAUoEqxS7o9xWHIBdc5TpysoYtPWSJyzo4TJlTr7Svma9RhmyshIAAK56DiAsOkoM8G16Q7XljmXGnx77GW3EtsyuSXumRvjbYPpjuy7+0ZbwPeZi8BOi0MfQvih50CX32GXqbTTWQBguJdDEcYYBmwko4RncTah5NXO0eyhhKNv3PoC/zyow5steKEcQ2V1Dk14jGZ07b0M82IJkenCk8aGw93mVD/1IupeZXeOfor6OrkYIZPoxu5U9gVYCQiNrkUSThxjUNBJ54eip+QSHMNTJL3vYcJCYZSKmdvE6TA9bSN1OYhOnRYiIicwFT7DqlHCzozYiICz6AWQT2nMEEJ7SEbQG3Z+5GcCvDj81u9Ksijmm/d20hBIUlaB+jBZiVST5DgBWS14FhJ8YhugJMPmOPVfB6mFlYO+SYXqB3YvPjTJ0ptjtqd/a1uZzHp7paHNQdpu2zcOnKnrDrvGiNyzsk5lzdKniqlp+hzuNxc6eAMh/1T/jLk28LyV83MJlDHSVN2xinFar7P9Wzr6xyfe7lsk1Cct/6ETGJz0uzF9fGrpTf10AHvzPg1EmR+sKqDcqpz7Uqw3NNjbyK0bOWRzo+KrS5nnp42WT3Ngw95fJkrjjv+DcAlnKB7CTecAai19WW8KIAFlkpkcAH0EXiDxDYpCgD8NWPJuTa4S7j16j0D6dB3/EVJ8x6LXnRhG8Snymb7Mui8NjBgFYY8ya4H1qkDZeDyQmxI+4QlfBPHWIIGWeO/L2eVint3VQFfSlqHoQW+xzRRtA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6263.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(366004)(376002)(136003)(39860400002)(451199015)(7416002)(66556008)(8676002)(66946007)(4326008)(66476007)(110136005)(2906002)(83380400001)(8936002)(44832011)(4744005)(6486002)(478600001)(316002)(5660300002)(36756003)(2616005)(6512007)(186003)(53546011)(31686004)(26005)(38100700002)(41300700001)(54906003)(31696002)(86362001)(6506007)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L050L3JjajM5eEhuRndOSVFpY0pqQnJnckFYcnlldHFhVkEyOWZzYlFUczBa?=
 =?utf-8?B?UU4rRE93ZDFxRitaV0kwMTdKVUpaMkVaRUVLWW9VSEdmdDlVaXMxb3RDQlM1?=
 =?utf-8?B?a21GZlFCVG5vZFBrTGZ4NDBvYkFkK0twS05KWUh0SXJDU09GZkZnNUFSWUdm?=
 =?utf-8?B?MWdRMDBKZWtueWVRa1Z5Yk4zVWFNOWFJTXRGM0xCWmlxWDV0QVlic0pnRi82?=
 =?utf-8?B?Ynppc2ZWa0ZtRkx2SVprc1lPcXBUQ1BHK3pINTdKUXZxQStuZm1YcDBHY29I?=
 =?utf-8?B?eEx5UUVycFVSQ2VVUzR6eDBBQzJLTlo5ZlZJdzZDSXdJZ0ZFd2JxNjFmUUVi?=
 =?utf-8?B?bFVTdlc4UDJZZzdxcGpuR0RkaXd3V0UyVVRxTGwxdHVXZ3BZczE5S1ZmWnNC?=
 =?utf-8?B?S0F2UWJ6VEhPYkRnL0RYUGRCb3NLWUZMNFRleCszd1ozS1VPL2JYVXN3eDc4?=
 =?utf-8?B?WVJ5TGU1anNFR1lqMXA5a3JTVHcyc05zTnlMWFp6c2x5clNuUTN4NWtjZlVJ?=
 =?utf-8?B?TG9vN3dTV1ZtYnU2M1JQaUlVSkpLQWZqTWhYYVltV041b0JWeUN4bnRMRlhS?=
 =?utf-8?B?K1BKaG9MaVZGc3lYOGdaemtmNUgwQUpIMUM2dEhYZElCd0w2cG9YOW9YWjZ5?=
 =?utf-8?B?Z08zUWlQbWRXbHM2OWZubXVvTnBXMWsvVXRwazBsSERHVG4rYU1ZVDBuakFC?=
 =?utf-8?B?eFlKWGFZVXQ4aWhRaFFMR1FTZitkNW1Mbnh6RE5oWFF2OW9NU0xSc1Q2cDZw?=
 =?utf-8?B?VWxnSTJPQW5iaE5rdSs0TktJMTNxUGlYck9Qc2ZSS1RqOTRBUHd2Wmd0b2VS?=
 =?utf-8?B?R243UytQVUtnWEp3S3BVTmJCL09DQ0dEZkI0SCs3L1AxM3g1MjNzTEQ1YWlJ?=
 =?utf-8?B?MzlYcWRVaFQ1U1N5QlU4MmkraFdmMWx4c21qajFDS2gxSmJxdXVRY1I1WGNl?=
 =?utf-8?B?dGpxK293R2d0cnpOVm54SEZ4dTZmaFNLQnhmZGNvL01JNzlHdkFha1VVVmtL?=
 =?utf-8?B?UTY4Yzc4QXY0N05HUDg4OHgrYXJLMnc5T2R4TVE1T0xCdmczdFZla0ZpcTdI?=
 =?utf-8?B?K3E5WEZJMDdITWZRa2pxTVhrUDVZcytjM1JLTkh5dVBmaFBIT0t5N0FxWW05?=
 =?utf-8?B?M2RNOTNMVWM4dkY3WjlRRWtwWi8yam5lVm9ZQjVUL1k2R1dSYVhEQ29xNjAz?=
 =?utf-8?B?SlNNeFlOUk8xMnp1RjgvQ1E2dzh2UDFzdHNWeWJyVHpJM2NpNk92WFVpTVFo?=
 =?utf-8?B?d0tYSWVQRndHTzVmT0hTdDRQM2hybEg5WEtaNTB0U0dCdllxc09WMlo0YUNh?=
 =?utf-8?B?cXVzcWZ2aCtRZFlYUEJhL3IrYThORnRpeWtYWkIvQWphNlFyOUNYM0wxTzRi?=
 =?utf-8?B?Z2c5eW5lWDkreFNaODJoWFFPU3N4QnJUeDVDZVJlU0lZdjhrcGVxdnJrbFJL?=
 =?utf-8?B?dDg5ei9CV2tmbjNmUWs3VEh4dFZ2UjEzMUZZaUlUWGZnbHYvMzJyS3p3ODBM?=
 =?utf-8?B?bnlyaW1vWGl4dzBaWDJrcFJoZC9Gakd0MEJpcjJ6YzVPRG5oeml0anFGY3Z3?=
 =?utf-8?B?NDRFcjJnZG80dHBtR2ZTRC9OTDlMQkd5b0hSV3ZLcUVtSk1GYktOczBJaktU?=
 =?utf-8?B?cWVsdFJYWVM4UlhuNDBqS3ZqU1JGcHAwcUhFcVAweXJVWXp6M0ZselJrV003?=
 =?utf-8?B?eHdRWmxVMk5tcFU4ZEtPckJpSWhNcENvbWJhcm9vaFIyZGJyTUdhV051WTg5?=
 =?utf-8?B?M0lMdDNFM1dEMkY4bDBMV09uaS9LL08wTzVSMk1WRVMwdEpmakVIVGVTRk5Q?=
 =?utf-8?B?TzNkMmVENmJpclVYL2ZxVWJtamRTcmZvOTlTeG1xc3cxMlgwbXZPTG1vZmJl?=
 =?utf-8?B?aExvbk5UeG8xOFNHUUQ3RTNFUVdtWU1yRFZjZXRwOHpXK2hYQUJiQTZLT242?=
 =?utf-8?B?bEUrYlBlMyt2RG9QR3Z5VklxMVExMVJXZTMxSFFLdVNtdXhzdTNOYWVlK2ZR?=
 =?utf-8?B?cndYSTk5ZVlpakdNWmtNZ3hRNU53b2MrQWZlM2w1MVpNN0lObTYxQS9tNFAv?=
 =?utf-8?B?UytFekplbkh0c0JEOXJmVmdxeGlSRHA5THdHYjQ4VllyM2lqMEY1RW5saEZW?=
 =?utf-8?Q?sWTU8Q7KS/SXo7SiF3rNcbzmi?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d190b40-13f8-409a-6872-08dac1110d51
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6263.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 22:40:20.9327
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /bz9D8HGU8tRqLq3FAIqduVWallu+/Xbh96KT93UvFFISijQHp6lvIJ9AMLOkYJ+pfJApOu6Jt/ZbxxBnKPolg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5347
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/5/22 6:39 AM, David Laight wrote:
> From: Borislav Petkov
>> Sent: 04 November 2022 21:52
>>
>> On Fri, Nov 04, 2022 at 04:36:50PM -0500, Kim Phillips wrote:
>>>   - Allow for spectre_v2=autoibrs in the kernel command line,
>>>     reverting to auto-selection if the feature isn't available.
>>
>> Why?
>>
>> What the whole logic here should do is enable autoibrs when detected
>> automatically, without the need for the user to even select it as it is
>> the superior mitigation.
> 
> The only useful option is to allow a different option be
> selected for code testing.
> So maybe you want an option for completeness - for when
> an 'even better' option is available.

This is true.

Kim
