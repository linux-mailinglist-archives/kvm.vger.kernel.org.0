Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E10915184F5
	for <lists+kvm@lfdr.de>; Tue,  3 May 2022 15:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235795AbiECNIb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 May 2022 09:08:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235788AbiECNI2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 May 2022 09:08:28 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2065.outbound.protection.outlook.com [40.107.96.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC5E03467F;
        Tue,  3 May 2022 06:04:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OS19rgOCII62gNFgKuW5K3zNPgGTSeunImxEgXepBGwomm6VMr434IjKLkRBpuBnflI5E6GsnVX7jzyuvAAWNlaoSv2Qw78V5vdRWcEssD2G1iBQfzAKBky3yD6go5TyzaSod1Q06fJz3zMoe9CDr3TlSkIpfx9onznQwS1IdRRsDAkaJPEns1ISiAvozkrJaXF/IiszrG6o1RRl/T1bLzInAA8V5k1S/tdHWXomWX7n45fR1L0C+ZRR1Qqk9Kc8v8gWHQCdh6Gcw8u8kEtirugZfSNK3fS5BJ4Pb4K959d/K0Ok8w1HLmmgqMK6JN9XhnTh/rSB3VPewbToyel0tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=azv6HKRABIwngYkThCsPNnnlXvAKugOiYcH50CduQzw=;
 b=MIK2ltu0NLTDygSijn0ttejPLXGU+vA3TX2zjrpoI1vNtfTtnrh5Fc1bGEyOZmW9xSCUIb2eDK5Df9IGq9WjhYIBVdYsBtEHAQuDfPoZOrRyNrwaIdez/k+xYsMcSyFKAKsbFr48bfS8DLq9iX66Uucrr9be2BfCFwI0G0lsThrJANPRHDCts7zVe6zcDEEXmk3I6wRfFbwPC47JJ66ILVl63S/3uHAr4urmoHAC+3oRe8hWUGYEwqpiB12gkPkr7VSMYevN1lZKgpNbf7VmygtvthW6+ntHZDrUbpHKn2XX7G3vQJER3riYTBPyu+D19vSE1xL+a9hyrrdpCaQCRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=azv6HKRABIwngYkThCsPNnnlXvAKugOiYcH50CduQzw=;
 b=R5+27YgILDFy8lr96lyozV6HfUZwOTLHjc34qBHYcdgXqh0CMSktSV1YlZunZFahEZgTrWkDqJutlsTmXzotlDcVBTvnQTWRmFAXEt6mniZ7UucN9NUZKit77xxKTXImbTL+Lss1Trlm4Ngz8jdnyBXoZGp4ywoWuWOClJBAs1Y=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 CH2PR12MB5562.namprd12.prod.outlook.com (2603:10b6:610:67::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5206.24; Tue, 3 May 2022 13:04:48 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::9894:c8:c612:ba6b]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::9894:c8:c612:ba6b%4]) with mapi id 15.20.5206.024; Tue, 3 May 2022
 13:04:48 +0000
Message-ID: <3196873f-0047-3411-d434-56d96ca31298@amd.com>
Date:   Tue, 3 May 2022 20:04:40 +0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH v2 08/12] KVM: SVM: Update AVIC settings when changing
 APIC mode
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
References: <20220412115822.14351-1-suravee.suthikulpanit@amd.com>
 <20220412115822.14351-9-suravee.suthikulpanit@amd.com>
 <abb93e2d73b7ada6cbabcd3ebbf7b38e4701ec57.camel@redhat.com>
 <9307c734-3473-0bdc-57be-c39e96bca4d8@amd.com>
 <24b74f5bd8810c7f79777ed6898baeaf47bfe3e3.camel@redhat.com>
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
In-Reply-To: <24b74f5bd8810c7f79777ed6898baeaf47bfe3e3.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: HK2P15301CA0002.APCP153.PROD.OUTLOOK.COM
 (2603:1096:202:1::12) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 939579de-bbb5-4691-7b45-08da2d058083
X-MS-TrafficTypeDiagnostic: CH2PR12MB5562:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB5562AFD05B646A4423A736FAF3C09@CH2PR12MB5562.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XfUyW58IxgbpFBlpd5QOYQpHm+WdVBEvzU75kNM/2lQmrDTr8RRCJ9677uqLsNkNQqi7ro1i6q3DrniJFL4QSDzhc4cvNqTs0NukPDN16T1YXT7F6noxVVkCD1F1kMczWGsbrDHiS2BEzjws+Hw6klb/pSXNL+GCvTDMa3b2WnmwuqTMot+yCiOdHHrEWQkiDIiwv9cf6aovxb4P9K2hQzFXhKTRK94REstoIY6PoRY+qu40jLLcYiy1S9IkkaXSXnoJBoVgZ/v5lWEyIRPS2iAJ+C4bpvHSn9BeIj5IOPXkqJ9l2XZ00etOvPqi5rCYBGlq/fddRFOor9b3/3JSSZGsFPPx4Sgl0kYNEPGKtIkHXMJDLGNI5m5Puc1m0YqcYgyIPLVKP4E7ZRcjp8kI/tKOty9YdyeuTqmtS9tT4LrPI2g4uSgBsDDcLAGzLLTW4CNxiUH3CVD6N5C0qBpEch6aUrxyardwIeB8AZsOomFtcToTgDAh7H2QobyWDEYbxHz94SpBbRFDC4COrRkwfv/kdv63npX8+odgp44OHvfcjjB9GLfa42EpLfaQsKbd7KIkZfCoNKFhNZRtiezK9ntOUMjrcpWbUsRrFjxAZZz9DASAjK2utWWw/6LAmjLU1sLgmYmdq3OYwcBEPIqE578m/WfQCQ5TSHsjpkzUB8PaHQRHQVtyQ0ojn5lPB5JdzdscorfsUV2bMyK3lFSlhCB25ZoOL7yarHfbQpwMFxA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(186003)(31686004)(31696002)(83380400001)(2906002)(2616005)(44832011)(36756003)(8936002)(15650500001)(316002)(38100700002)(86362001)(6512007)(53546011)(8676002)(66476007)(4326008)(6666004)(66556008)(66946007)(508600001)(6486002)(6506007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R1RRQnJ4MXdaU3RmOEVFVDVIeE9EWk5hTlJKZXhpb1p1YUlHNmVscGRBV29r?=
 =?utf-8?B?d1NBREZpeW5MNlI3anJGNWRLK2FmWUUwQjlpTU12Qi9tMUxSemo4T09YNzFw?=
 =?utf-8?B?UFFoRU5MUVM1enJsY0RFNlpZNGp4V3A3ZDRDOW45cHE4RnhaRDJmOFR2K3pH?=
 =?utf-8?B?STFWaUNuS3hmdm0rQmxxcldxeFhwMVpFaHJDNkgzN1oxQ1d5b1p6Q0JpV2FB?=
 =?utf-8?B?Sk55aVBrMFhnWWx5b3FiNExGVnZnT2FpOHdUZzZFWThncVRDdzlZaTdIRGRn?=
 =?utf-8?B?NHEyODlpODZVZmlUZ0FGdFdYMWQ2R0QwbWRCazhsTjlEa3R1RHRwRHlVR0tU?=
 =?utf-8?B?enZVTUJjRmRYNEU1aDU3Y05IZ01IbytYK2lFVStsTFJ6SXFBQ1hSQWMyV3hh?=
 =?utf-8?B?YnQ4alRJeGVZdUZuYzR5c2VPeUNyZ0tIaWF3NFNjSzVxSjJtdzBDWmdQR0VI?=
 =?utf-8?B?ZWlNRHB6SmFIMFIrZ25raDc0UDVsK0J5MnZ1NVlUSEc1RWY2cTJaZGRqd0s4?=
 =?utf-8?B?WUIrcmpKM05rZ0kwSXhNUmhGTFpZRXRqZ2FDV1p3ZWlUa04vMG5nTEFENkYx?=
 =?utf-8?B?RFJ4N200Z2pqT0V1ZEs5dm4wSm5DY0xNV1JpdjZzeFdtMllRU29nbW40Nm94?=
 =?utf-8?B?VXhmOXhVcVUveHJUOVBLdTN4U0NEUkpxU2R6NXN4dUdvbFVhRXF4UE9pVjVC?=
 =?utf-8?B?UEUxbDdPbWdOTkpUZTJ0RXJuZXRPbm0yaERiZGRkbXh4NlB1THdiWlJEWmg5?=
 =?utf-8?B?QUIrOURXdFJtSWMrYmRtWlYwVko5YXpRM1dUUmZGYVF2N1NHZHhEWDZ6T3lE?=
 =?utf-8?B?cU8zZlFzVVo4VjlaanIzMktZY3NWaUlmWENnMmt0eDlCalIvdllYTWFSMFVH?=
 =?utf-8?B?WGszSUI5WGRLczcxdVV1S09TODYzSWdpR3ZnNEYrdzhicUJoc1J1MHJaOWk5?=
 =?utf-8?B?bEdNYkNCdWJoOEF6Z2l6dHZ1WTRUc3BZaUxSVXRncUhyK1BSL2ROUGd5Zlda?=
 =?utf-8?B?WFNibWc0MElMV28vczVHYnh3UTd3ZWdxY1hSendSL2VDTVA1L2wzZ0RYbFRV?=
 =?utf-8?B?aWxkdWNaZGhJY0FuTW4xS2pJNjFQRDlyU3plVEtPbkpvbUdoNHJiK2RLeEk4?=
 =?utf-8?B?b3A4dEZDREFlWnhFMmV4NnlnSVRxWDN5czV0N2xvZXRwMWZobkc1OExqT1lv?=
 =?utf-8?B?eDFJb2xZNDVVQXppMG9ES280N0MxNGowSDZpTHQ2LzlhcUVzVTg5cVNMN0Fz?=
 =?utf-8?B?elBXVldGSitWQmVMblMwYXU2Z0d6N05rcTRNTEJxQmVDY0c5UTVIelJzd0dY?=
 =?utf-8?B?M3NvSkdBb292YmEvYVMyaHMvZXZCd1FPRnhJYmZWeWwzMjhNR3FZQlU2VTJG?=
 =?utf-8?B?TnpvblE5STA4QlErR1FIbVEwbzljQXJBZ1pPOUZ4ekFJVGNxaUFXUXhXSm1k?=
 =?utf-8?B?dkpwcFBtdDFOR3FYNTI4TGVaU1k2U2RkeG9GdnBKYzFLWkJxTGI3Z25JN2Jn?=
 =?utf-8?B?Yk93YWg0RG9Eb1gwcVJma0hCMm40VFloSTVBWDdJZVlwcjB2QzltdlZPaXdk?=
 =?utf-8?B?SHBJRWFRUGVqVWZaNFlaVEpjQWEyUmlnYk1GZWtVS3lvaGJGK3RPc01MalFV?=
 =?utf-8?B?TEtYckR2Q0xJNmtmaFlvTC9vam04U1QrT2hSUFRKcGdoWWNUUHdCV1pyRDI5?=
 =?utf-8?B?ZjUzQkZySWp6czBSclRadmlVVHBlOFBVUHNETVdwa3BySFFWOUZVRmwzeW1R?=
 =?utf-8?B?amZ4dWhuM1pKd09OQ1Z6NjlzMEp1V0lqV3F6R2YzVGhSaUtDMGpEaDdLd2Zw?=
 =?utf-8?B?S2loV2FxeVpScWU3dkJnMGFzaHFwNS85TGlKRGxRZVRnT2Q1TU43eDRTZlJH?=
 =?utf-8?B?L2ltS0F5aWVoQ3JLREs1NHRQYndraGVmYkpsOGhITUd4SmhkZmgrSlRyVVF3?=
 =?utf-8?B?WDk2bGYwT1QxUWVqNTdNcWxkTHdZUExyMFdMVm4zZkhiakFFSTBsZTM3Q1lZ?=
 =?utf-8?B?MzRHRFpWOG9pOFZVTEp1d0xLTUVKRnV4ZXJNSDVEd3JjMDA5am12VXY4RUNI?=
 =?utf-8?B?MmduNlVPd3VWdXpLRnhVejAzZzhGL3hFZ0twR0hNckFTc3Y0MkZtYjRqbzRk?=
 =?utf-8?B?aDZUY0F5OHdQb1Z4M1JCMjRob0dUN3NjeHY0R3lWaFhULzdkdzk4REpPMlhz?=
 =?utf-8?B?UmhQMHB3eWF5ekhXaUp5Z2U0eGJTVDdocjJGWjlsS0lRbmlVaStrbUVOMUlW?=
 =?utf-8?B?V1craWxPRUhRMjJBcEZ0VXNxYkU2VUhmbkJpNU8zQnR1dG5ROGtaMHBId0x4?=
 =?utf-8?B?UGh3ZFppMW5jYVhKQ09wTHpNVE1uMGpGMC96emxMY1JPR0dMNjV2cGNtcXVP?=
 =?utf-8?Q?H8EBwMvay7IURh8XkiqiBHEMwo8lihJlNKnkN/Mfc3shN?=
X-MS-Exchange-AntiSpam-MessageData-1: jQC9ZqTjMlGJbg==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 939579de-bbb5-4691-7b45-08da2d058083
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2022 13:04:48.7263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2pHRGCvrqhrgGIMgu3UZP93jJOaQDlrIKwY+qrb9DybfY1G82ZpXdkky0YOuAHIaMWe5UVAW42ACL0N8qYKs9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB5562
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim,

On 5/3/22 12:13 AM, Maxim Levitsky wrote:
>> In the kvm/queue branch, I found a regression on nested SVM guest, where L2 guest cannot
>> launch. The bad commit is:
>>
>> commit a4cfff3f0f8c07f1f7873a82bdeb3995807dac8c (bisect)
>> Merge: 42dcbe7d8bac 8d5678a76689
>> Author: Paolo Bonzini<pbonzini@redhat.com>
>> Date:   Fri Apr 8 12:43:40 2022 -0400
>>
>>       Merge branch 'kvm-older-features' into HEAD
>>
>>       Merge branch for features that did not make it into 5.18:
>>
>>       * New ioctls to get/set TSC frequency for a whole VM
>>
>>       * Allow userspace to opt out of hypercall patching
>>
>>       Nested virtualization improvements for AMD:
>>
>>       * Support for "nested nested" optimizations (nested vVMLOAD/VMSAVE,
>>         nested vGIF)
>>
>>       * Allow AVIC to co-exist with a nested guest running
>>
>>       * Fixes for LBR virtualizations when a nested guest is running,
>>         and nested LBR virtualization support
>>
>>       * PAUSE filtering for nested hypervisors
>>
>>       Guest support:
>>
>>       * Decoupling of vcpu_is_preempted from PV spinlocks
>>
>>       Signed-off-by: Paolo Bonzini<pbonzini@redhat.com>
>>
>> I am still working on the bisect into the merge commits.
>>
>> Regards,
>> Suravee
>>
> What happens when the guest can't launch? It sure works for me for kvm/queue
> from yesterday.
> 
> I'll test again tomorrow.

I have bisected it to this commit:

commit 74fd41ed16fd71725e69e2cb90b755505326c2e6
Author: Maxim Levitsky <mlevitsk@redhat.com>
Date:   Tue Mar 22 19:40:47 2022 +0200

     KVM: x86: nSVM: support PAUSE filtering when L0 doesn't intercept PAUSE

     Expose the pause filtering and threshold in the guest CPUID
     and support PAUSE filtering when possible:

     - If the L0 doesn't intercept PAUSE (cpu_pm=on), then allow L1 to
       have full control over PAUSE filtering.

     - if the L1 doesn't intercept PAUSE, use host values and update
       the adaptive count/threshold even when running nested.

     - Otherwise always exit to L1; it is not really possible to merge
       the fields correctly.  It is expected that in this case, userspace
       will not enable this feature in the guest CPUID, to avoid having the
       guest update both fields pointlessly.

     Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
     Message-Id: <20220322174050.241850-4-mlevitsk@redhat.com>
     Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

I can revert this one or specify pause_filter_count=0 pause_filter_thresh=0,
and then I can boot the L2 guest.

Regards,
Suravee
