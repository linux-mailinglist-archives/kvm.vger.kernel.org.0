Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 095CE4FE75E
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 19:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358516AbiDLRmN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 13:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358524AbiDLRmM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 13:42:12 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.111.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E0A75DE49
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 10:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1649785191;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ILyisDs1pArJkjBWX9O0j1zgyzsJAgS2wIuLZisPEGM=;
        b=FxRc60qTdidMBUyat6OJRpmWPeBVSvs6rCGxmJQJXYDPiBKekgNtCAphRgKwVAToiHh5HK
        UEZvNDRFmQODUlC5B5KquSn/5VqipmLLNN8aq2HnWQZJ+c5/lvKhadb0DosdGMZxWbuCjN
        pSXbFfMyUzzWc2dk1CL5NZSKFl/6sfo=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2050.outbound.protection.outlook.com [104.47.13.50]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-40-cBgIx8b4Mt-wHju_cFUf7w-1; Tue, 12 Apr 2022 19:39:50 +0200
X-MC-Unique: cBgIx8b4Mt-wHju_cFUf7w-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nWWs4KhFS/qHnmbdKVJhRCcioNqYvkYZC0yOl2Z7h12p7cs6ck5iZrKDs7hZimeUFTXoT4Bu5TbnVtldoTIG7yJ/0ryCRpP/s6a32eR6T5AqNJjHwTMSk1E1xBfpi6cZGc4DiG1/smmZ/loKOMU9nGhrzMzfRaDZRNQqrjIvTkqN1EfanO7MK3c01H3PpyeopZo3MtBPlanUBw1sCpDHVjnUWb+53R/Zr7OXON0jcNhGKKBKOELog9AQ6gbWCAUSGDoocMko6fow2gxzkg/lcZTyE+n+CrEr6UID0PRiFl7/p1f8cuzP69JRD819NeRKDusC/tQGPYlawt0vC/ZqVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ILyisDs1pArJkjBWX9O0j1zgyzsJAgS2wIuLZisPEGM=;
 b=LVtbE1RC9yi7XG5z6I0kulKSXJihKPl9J1um6xWSAosJSp18Fn1epPi8TdFg6KglAfanauqBo8N5ZiT6OFuq3wxlk0+r2vP7NDx46Onfr0YzoxNNtTX+/j8C7O0hotpVPOuQPlONXIRf+crwizH+nxpU7HL7jBcrRQeMYc8osRYYpf4pik29R7cD4G5UUCu6GjxNZu/7knG9SA79Fr3NCUYMT8TkG3Tll6sJzXQmmdRnaPrqGIEb+L8gMwzJ//ZLJKO1LU6DGWammMRp4AqSGrc34CpnPaT5mepPpae6EoUihC1rlD10ih/x2trTC7fri4MB/nIueM78mU7sPhMV9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AS1PR04MB9653.eurprd04.prod.outlook.com (2603:10a6:20b:475::14)
 by HE1PR0402MB3564.eurprd04.prod.outlook.com (2603:10a6:7:84::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.18; Tue, 12 Apr
 2022 17:39:48 +0000
Received: from AS1PR04MB9653.eurprd04.prod.outlook.com
 ([fe80::ec9c:195c:337d:7af7]) by AS1PR04MB9653.eurprd04.prod.outlook.com
 ([fe80::ec9c:195c:337d:7af7%7]) with mapi id 15.20.5144.029; Tue, 12 Apr 2022
 17:39:48 +0000
Subject: Re: [kvm-unit-tests PATCH 0/9] SMP Support for x86 UEFI Tests
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        marcorr@google.com, zxwang42@gmail.com, erdemaktas@google.com,
        rientjes@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, jroedel@suse.de, bp@suse.de
References: <20220408103127.19219-1-varad.gautam@suse.com>
 <YlBIGDreEtR9u+lh@google.com>
From:   Varad Gautam <varad.gautam@suse.com>
Message-ID: <b12b6d13-6bf8-a626-3535-68061cf7327e@suse.com>
Date:   Tue, 12 Apr 2022 19:40:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <YlBIGDreEtR9u+lh@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM6P194CA0106.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:8f::47) To AS1PR04MB9653.eurprd04.prod.outlook.com
 (2603:10a6:20b:475::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 25d9c578-38cd-4858-9b7b-08da1cab70c6
X-MS-TrafficTypeDiagnostic: HE1PR0402MB3564:EE_
X-Microsoft-Antispam-PRVS: <HE1PR0402MB3564F9B36E609309C9202FACE0ED9@HE1PR0402MB3564.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mKdHnmmEMfDPJR3psSGPIqXtOjg+T1jMCgw1V7AtaUoXm3cHKNAcm0a7hzPnTvjbtkcfrNsvNE0l9B67PA6kegkP5CYjNEIWVwI8GNVoOkfWnAaqIUFLmUs24pcQI/iVd6uiSreelMqj7wKEQAPrLFb+78UYTUaODq4lah+87o/QEE+aclVyXdm9FxFDRambk/ck+A8PC1JEWY6s8g+l+zdS2etB7JFuJf/flb/Ggc6MOFQPWsUhJ0oz8YdMYCWwWWGNxPGYqigpd/9enMRhwqEaJttSJWHNSsIVm3dch80mRDivL6Hno5eTp5I+BYX9u3q2GhrR4BxrQrfLZmM23oiGfJjdYclcHxdX8jbfwv0W3vnQdcFJdicIV+mly/kzRcvf7vgcLdRoIAbqeQ6KewTPtwOkJz7v8nhI7zzXQo78ggX2du7xgmJSpPe/VxEkyoA+6eNcRju73jmtVwhMFyWuZ6nBdRSVMLB0XhKVq+X2yIhTT2IQ640eQ2W8M4KD9PYY/Ai0SR1xZD89+X3dw0ecNYDJTVbVw9VCJCm4pPFKEx6s7HIM5tZ4WI+sSafycrkk4XkQ8IQG4pV1FLeMRhRW5FYUc/OT44PLSFGpvPWLoW+mAGHC/5PN80HgZFB/p6M6jJONA8iM/5wLwnrmTZ+ytaDemGx0QEDCZOLfFTD20LekrnOc/odPocyJpHxbNeCQWkVj7n9dS+doe2Q9dDMGH8hlsH7KUaBlNgqxz1SkfjKERdbEy2akzjQvM7tBQCc5Gu+vsN5hhAiWx03r8y0SLjwep/4zIYpiAQar0q1h62nYfDWO5MhjdGPL9S9KYSSwz9cw0CTyQIqZ3M15Q/cFmJ4WVwQFZmqKrIYJIgg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS1PR04MB9653.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(66476007)(26005)(66946007)(8676002)(8936002)(186003)(4326008)(66556008)(508600001)(7416002)(6486002)(966005)(6506007)(38100700002)(53546011)(2616005)(6512007)(31686004)(2906002)(36756003)(31696002)(6666004)(316002)(6916009)(86362001)(83380400001)(44832011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?djN2SGgwZFFZaDBHWHk5SzdDL2dWNHVxMm9ncHVySjV1MGU5VXd5NXhqdVZU?=
 =?utf-8?B?MGxpcFpITkV5T3FQY3dIMHpHdFo5bDFhakRHVU4yUWVINnFuMGRtZElJcEZX?=
 =?utf-8?B?dTMyRkZUZmErN1dhU3llRGcvUWloUTYvYjdvcFJFV3YvQW1xNFJwd3hHYTNm?=
 =?utf-8?B?OU5kcTArcVBMdUY1MHZaQVdqeEFKaExLMmI2ekVpZVBZWHJjSXBwOFA4UlhX?=
 =?utf-8?B?eGFGWGVxZzJtVUhNbVJXakxaQXYvMjFzWlM5UDduaStwcXB6L1IyU0NUZTZu?=
 =?utf-8?B?bDA2dG5peTdyMm03YlFaY3VOUHhITnZObGMya21xR04yRWZEanhrNzBHanBq?=
 =?utf-8?B?b0ViR0xHcWgxNEN2djlMYkNaS3JlMDRyakovNU9kanhlWmh2ajk0SzhCNitQ?=
 =?utf-8?B?OHp6UGh2RjZ0K1FSaWVtQmJoSVFlS1JxSXRqcTdxYXVaOGdxVElrQ0tqSDZ6?=
 =?utf-8?B?djhsTjBqbGJQbS93TVRzamZnMjNRSEQvL1N1Z25GQU44UXBEcTdzYUZ6V2RM?=
 =?utf-8?B?TjRKd1lkZkc5ZU1iamt5aTREcXFtSWEzWnRWWVBKTGhXTW9INVdxbVVjMVV1?=
 =?utf-8?B?dmh1RlAvZUFjTjJlZ1Y2eFoyYW1DZU5LREFOa3VoOWI3Z2MxeFdVd01hZnJG?=
 =?utf-8?B?aGdnbjBWY0xEWFREQkxQNE5SWEhiMmVKeFF4SDVJRW53YjhTOHp2MW8ySUZp?=
 =?utf-8?B?a253WWF6VXhoY1kwZ2FoTjZpeitNaDJWcmNONWh0ZUcwOTBvQ1AyS3ZaVXlE?=
 =?utf-8?B?ZDJIaFI2WUNUb2FzWkUxdVJtUHpCQUxqam0vMW1YVjd3T2ViQlBhMldQOXNJ?=
 =?utf-8?B?SFRrR0xsUy9mdFo5VDMrSmZmQmtEaEt1NTVCMTI0TDdhOVRjNTBqNWwzV2JE?=
 =?utf-8?B?WGpOcndXTzB3SGtVSTRKSjFudGU0S3VQQ3VZT3ZrOENvUGU1b3ZFbVBIM1dD?=
 =?utf-8?B?K01McG9PN0pBYjZFdEVQOEJMT0ZpOThVU25yWFcvTGd2bnl6Vi9ZWk5xRGky?=
 =?utf-8?B?cUptRE1kUDVaOVhRZjU4MWdDOUFFVmlvb1JSRXdpWi9ycHVOR1Q5QUx3R0JN?=
 =?utf-8?B?bk9qUVpVL09XQmQ3V2xabzdGWCs0OWc4YVRURkZJUHBWY2dyTkdkQUVwbm9t?=
 =?utf-8?B?R1R5R3ZTTDA1V2pQYmhFelpPMnlBblFSb2ZZN0dUVDFSQy9uUjQxRVdLWU9k?=
 =?utf-8?B?UzVlSHBDNWFaazdIOENpY0JLNFpTL2ZWOTA4SmFnLzRDclR6NUEzZmhGWXBL?=
 =?utf-8?B?L25Od3k2UUhGSkthVE1RYS9rTkZMT1FYaVY3OExXK3lLdFNxV3Y3VmxFMlpm?=
 =?utf-8?B?OHFCbGd0TTkvVWoxcmZwS0Vyait0T3ZMQ1JRc1RCeHBZM0d3eXhKRnBRWHdl?=
 =?utf-8?B?emtVTC9Ka2tiVjB0Q0RiRGdLRTdWUEYwVjVuUS9BL21Oa2VpY0pTQ1orMGNq?=
 =?utf-8?B?NEhCcHd1SUNCMERxSlgzOGxGclpZNHEvaG90YXJjZHpOd1ZaMmthRWZGd2g3?=
 =?utf-8?B?UURDUGI2c2tDUVBLZU5HbVpQNzdtVFlFcFBQVkR3RWd4RU5ydmVlOWg2Nkx0?=
 =?utf-8?B?QmFqcHhoSzJVb2FTTnlnNmRmRyszWTB5WmhnTlhGSGNxTUZQNUp1R09pd01w?=
 =?utf-8?B?Y0V3anozRVdyL0Yvd3ZhZ3ZXdTN2bHNYUzlOTTRscVpTeGtPZDlING9zRkRs?=
 =?utf-8?B?UndXUFM3a3FPVWFDMUFaeG1FYytJVEg4RDBKWVEzdCtFWDBaajZROHVCcEpB?=
 =?utf-8?B?dmNxOFdWcllwdlRhaUpacXpodzE4UVZkM2JwN2FieTBsTlV4UHNHNFVKYmxD?=
 =?utf-8?B?S2pOYmMxd1RhTzNoS28vZ2E1Y2FmVExtcnVYbTFDK3ZRcTZOUmhXdzFhTURt?=
 =?utf-8?B?SEhzR3BvRzJvNWJRdStldW90U2RGT1Myb3NoMXdHbTg3cnduU1VJTzJLcC8y?=
 =?utf-8?B?MnRtaE1FdWlWZUxRZlNrNEY1T0lvQlVEVlc2Uzg0ZlJMVHovOXI0SWQ1enc2?=
 =?utf-8?B?VnkwM3MwSmtIb1dSTi9PSlRXSVY4YTdCNmlSNmFvOHdrUTMzd2tlTUxrL1kz?=
 =?utf-8?B?V0J6K1l6aDVObXl0YjZkVU1vK29Pd3ZNWGZNTzFrdHRmNE5jY1EvN2wybFdP?=
 =?utf-8?B?QVRhV2JQMGE4YXJFaStnWHhzOHN4OWZUN3BNanoyZTZ4MzN0TzJGbW1idnd4?=
 =?utf-8?B?VGpGNENCTDUyMktzMHFINXRtRUl3dHY0Zk9hdFkxUXM0VTg4WXdtQ1NCNTls?=
 =?utf-8?B?UjJKNXBwVFFJdHRyMnhjalgyR2IybjFFMGdaT05URy9WbGwxcVYyMGhkUXJW?=
 =?utf-8?B?d05sbU1hSi82Sm5SL3dtWFd6ekFueitqa21GWmJ6dlc2SWErY0RFUT09?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25d9c578-38cd-4858-9b7b-08da1cab70c6
X-MS-Exchange-CrossTenant-AuthSource: AS1PR04MB9653.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2022 17:39:48.7938
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YoHhBRjN9An43yBhYm76VtvbsHjlP/UHn7pJ5GnLOUJni+k8LtXPxrl15MM3llOnisHLuZad4R0CEdmfO6V7zw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0402MB3564
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

On 4/8/22 4:35 PM, Sean Christopherson wrote:
> On Fri, Apr 08, 2022, Varad Gautam wrote:
>> This series brings multi-vcpu support to UEFI tests on x86.
>>
>> Most of the necessary AP bringup code already exists within kvm-unit-tests'
>> cstart64.S, and has now been either rewritten in C or moved to a common location
>> to be shared between EFI and non-EFI test builds.
>>
>> A call gate is used to transition from 16-bit to 32-bit mode, since EFI may
>> not load the 32-bit entrypoint low enough to be reachable from the SIPI vector.
>>
>> Git branch: https://github.com/varadgautam/kvm-unit-tests/commits/ap-boot-v1
>>
>> Varad Gautam (9):
>>   x86: Move ap_init() to smp.c
>>   x86: Move load_idt() to desc.c
>>   x86: desc: Split IDT entry setup into a generic helper
>>   x86: efi, smp: Transition APs from 16-bit to 32-bit mode
>>   x86: Move 32-bit bringup routines to start32.S
>>   x86: efi, smp: Transition APs from 32-bit to 64-bit mode
>>   x86: Move load_gdt_tss() to desc.c
>>   x86: Provide a common 64-bit AP entrypoint for EFI and non-EFI
>>   x86: setup: Serialize ap_start64 with a spinlock
> 
> This series doesn't apply cleanly on upstream master.  I feel bad for asking, but
> in addition to rebasing to master, can you also rebase on top of my series[*] that
> fixes SMP bugs that were introduced by the initial UEFI support?  I don't think
> there will be semantic conflicts, but the whitespace cleanups (spaces => tabs) do
> conflict, and I'd really like to start purging the spaces mess from KUT.
> 

I'd based the v1 on [1], which is no longer required after your apic_ops percpu
conversion series [2].

I've now based my series on yours and posted a v2 here [3].

[1] https://lore.kernel.org/kvm/20220406124002.13741-1-varad.gautam@suse.com/
[2] https://lore.kernel.org/all/20220121231852.1439917-1-seanjc@google.com/
[3] https://lore.kernel.org/kvm/20220412173407.13637-1-varad.gautam@suse.com/

> Paolo / Andrew, ping on my series, it still applies cleanly.
> 
> [*] https://lore.kernel.org/all/20220121231852.1439917-1-seanjc@google.com
> 

