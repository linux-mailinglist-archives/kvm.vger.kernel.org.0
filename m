Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8C975ECEA0
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 22:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233033AbiI0Ufq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 16:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233088AbiI0Ufm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 16:35:42 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0971675CC3;
        Tue, 27 Sep 2022 13:35:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JEaCCAO4XpBsVGW3iqGVlUiarmz8D0pJR5xA9bP6V9qI9Yf0RTyYFwsIU094Igs1nyIT8BWgEAnvMxpCIxnwBC9NjBvwTAKSTP+wJSk3hnyzzjmDNibfGurpCFgtiip0sh6Fz1JQ+n55EV7ZwXf5P6+LxtqBieRyBkFp3cULSRIg9zvCX4rbXZwN8VTW9xpCYKfOlymkjuyr5RFO3HYB7aRaYP32owP7Wu8RJmohbLFAh+zjqxhtqo8QinMZE5BM4K6uYC9plyUgtDCszvaTCkMt5xLPQAloQaIija1y11/SCsmTSzQon6y08J7/ZMNV72TNUUUJxESplJLoBly+JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hK6ziGEFD2JaZaoZBh+/PtTNDnHsRlrBMC70cohUWSU=;
 b=S+DiJgoHhpCS3QFolneyxQ1EEvssDh/GCBt0GkSQEzVAZVBO7MMLPE9X9H6Re3kXhmdu8V9T19CyRrdKdaY845i7El8qClhvOu1iWlQmZyi+kygtI8Lkf23hiwABn5gHNRPd3kDYk0ZK+wkOd/KAoVMmtp+tUs+zFZyaq4+TbGlLwB3iQQ+KOe/aR6Ih54H+tfFvCDmgXgZ73GIIy6YT2Wa7XPW8qvRzlwu+pkU1s1osoC5pEzAu8+9fG4xJxkOzOtHrxo5xn+M0oBoczF9/dejKqJT3l42LqTIQMMMof7fwSe0f4xS/zVnuLSHblMy1Y4Xn3wYvMYphAMYdJmwfRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hK6ziGEFD2JaZaoZBh+/PtTNDnHsRlrBMC70cohUWSU=;
 b=4eqP4IMTiWi5L84dp52IiWhAe1oX+J10HKWfcqgV0IN8g/C0KY/tgmtmc6h1Lg0uuR/0XeP1gf7QWM3COy3Iwkp1ZjCmc5QEZ8o6ZzNs2N8szlWLdYniAkEOMr2FVJ5TEbXRUOrrsfXizaJixveFH9kMpAbzV0azcTxFAqpC3ME=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 DM4PR12MB5817.namprd12.prod.outlook.com (2603:10b6:8:60::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5654.26; Tue, 27 Sep 2022 20:35:37 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::25cf:e07f:d3b6:af7b]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::25cf:e07f:d3b6:af7b%6]) with mapi id 15.20.5654.025; Tue, 27 Sep 2022
 20:35:37 +0000
Message-ID: <735b709a-7e3a-4517-1f9b-6022b18be99d@amd.com>
Date:   Tue, 27 Sep 2022 15:35:32 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH] KVM: x86: Un-inhibit APICv/AVIC when switching to x2APIC
 mode
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, jon.grimm@amd.com
References: <20220909195442.7660-1-suravee.suthikulpanit@amd.com>
 <YyUOb5X8yO4BbYSf@google.com>
 <93df5f91adc31138640e3e7c5ab037b73b8af5ff.camel@redhat.com>
From:   "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
In-Reply-To: <93df5f91adc31138640e3e7c5ab037b73b8af5ff.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR02CA0009.namprd02.prod.outlook.com
 (2603:10b6:207:3c::22) To DM8PR12MB5445.namprd12.prod.outlook.com
 (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5445:EE_|DM4PR12MB5817:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b6f40e8-3392-4f3c-990f-08daa0c7d575
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GUFXKzzOTBUHB1lwbayi0gnowGCVdpUxATocMY4HN8IjsdQyHV3t2459Dq/pTA1wFHY48I9H/bbDd/h5amQus5k0XwlrxdzonGe42UuGbmJJ6V3xcc+RUf9gOulAplWGak2wxUJUxph0ycC4sRKmWfnbFRcIv0A3GM7MRklcRJMYmezm/nDfUzkkwYKJzkDRfr4awpXeaHJZ6phis6WsSMmuSF7rJW43Ajxq7Vh9cq1UwtQbZGXHjBU0VmucW8ETE7kPV721mj6uMIP15D4cWVKKrnsHhao6gRFqb8Ipwi0I1S0yqYBaFF29cmA28SshbcJQIAfvlyWpPkkOD3acob5FC7i6XWJAV0+SKXR6pHSrX60nOEnzO6S93H1P+evoyLH7GljghinlFLAehSZzlZtWAyminU41XH5mI6Qpme3P39bSkSUOxbe591oUAYI9zAnLBBVjh+9cmJuZ35IlTJ7aFjCAu0SSXBEI9HhEJW5e8nfTRZmnfRPcaLMVuPE/NRgmvZPaDCiWjekPiN0nkcx6v0GYybzZ1x9U/Mb75g/orun0HKfA3cxCQIoeFE5HyikLcPnnLy5se7J68zgXECZObBrk1Uj3GdKLD3dVOvWkcuK7cRZ7Rrrv96ye4UNF0+DsHTeF715qLbCK/mNkPvp0i79sNj7yVYKZeNszs+XLkOMgaEQps2/Wg6WiHtwxQ+Ih4+gdz8kGqym7GqFvP/AuUwXXb7d/KEgglHJrOYj52M8dZj32C8jz43VdpOCWlqS7PGoU9LyHnPWaeTrUDvjk3qnJMKbvxwrzlbb8XDQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(366004)(376002)(396003)(39860400002)(451199015)(8936002)(5660300002)(86362001)(31696002)(2906002)(6506007)(6486002)(83380400001)(26005)(53546011)(6512007)(6666004)(478600001)(110136005)(2616005)(41300700001)(4326008)(8676002)(66556008)(66476007)(186003)(66946007)(316002)(38100700002)(36756003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?anEzd2tpWVlNeW51d0dkUEs1MmZIOHpwVUxwNEpMQTdqcHJZcTN6N3JxVm5t?=
 =?utf-8?B?UjFyYzE0TmxMcjFldlRIVVljTTBlekQ1am41QU9aamdXQlpPR0ZGS0pySnd6?=
 =?utf-8?B?TVdETytSVEZib3FJMk0rTUZGN0xlLzRUd2tydHdRcEh3OWZkbWpHV0x5US83?=
 =?utf-8?B?TGRHc0xqWkhNZ085Z2FNbGR4YWtDNUNrR2lYcWowVkVEaVdRZE1aNWt4YWtl?=
 =?utf-8?B?dFR2ejhZeWRZYVpuTXRtbGwxU1NRWWFyTUExaTVzTkhMN2VSZzltaUNkNHdO?=
 =?utf-8?B?UURhWFhkamdaZUtRMkRPaGhBLy9tc3NtWndWa0JQeTZoekJOcGprN1M5bGly?=
 =?utf-8?B?MTd0cEJSSjRCVTh4VnFycWhZRTVRMUFLSEZRNm55NlJMNW8rcDRlRis5d252?=
 =?utf-8?B?bnY1RWtQaWV2SDZZQzk0bGpZcFVNdXNGYWN3TlpRUXFUb2FaSEhSc3pPRmpE?=
 =?utf-8?B?QWk3ZWp3ZURrRWZ0aTltZlk3S3JyMW5YbVBxTUlDWGEwK3pkakxzcEV3d0hQ?=
 =?utf-8?B?Q1BjT0hHYjNZSTdOUGxOZTNCRG9YcWY0NWtTdGRWU0ZETDFYQXg3SDNpdUpi?=
 =?utf-8?B?OGVWdGhTYnlnMWp3ajFRR1hJdUpWZUliSEhJUU80eXgzb0Q5RWZkcHpPblBp?=
 =?utf-8?B?UU90QURzMmlvS3NEK3BZU2NpZjA0UXkvRGc4VGNIVUFqZ3ZMTlRUZHFGV0Iv?=
 =?utf-8?B?eDZFTFJKTFQvWWFRZk5rRHZJeVVrRFF6aXB4TUF6Tm9WRldlV0xzU0JZb1VM?=
 =?utf-8?B?N2M0Tm9XSDRtbVF3aXByNzJoV1VPY290SXVLaWtmVEJPRFROVUNMdXJOVXdw?=
 =?utf-8?B?ZXlMZm8zcExFNFpGRU9rdTMvK3dFcjJhSzZYSmZKS1B1TGttYVJlSVBTM2Vs?=
 =?utf-8?B?ejluK0txVHJ5NHZKK3JzQWVpNXBKR0NvbldyTUhuSFdtQklKanZEcG9hcFF1?=
 =?utf-8?B?VXJITEVzalhHRFhCRWg1cXREbWlDTlp5MTZKMi96YVljZ1prVDkxdnFqYllO?=
 =?utf-8?B?V2QwbSttUWh6ZG1rZW5BQi9yczhsWmhuTS8wTXBRMFo3aVNERkltZ3NXQTB3?=
 =?utf-8?B?Tm40WTA3YjUydnFTRWRKdjR5MXpEU2JXWENLWHBOMFozSnBoUmNURmkxbE9C?=
 =?utf-8?B?ZFd2bEtZS2doQ2ppYTRMYU5NdldTcWxud2R0d0xtVUtUNkd2UVE2RWZ0b2o1?=
 =?utf-8?B?Y2tHYnRyVkd5blI2U0NoSXZqUnpuNzVsYy8zRDBEVFVJdEhhQnN2MitwSVpa?=
 =?utf-8?B?Yk9aWC9rVVQxbFEwdlVZSXV6SnFTKzdMay9jS1lHcjVjSWVncWp2NWtJbDNJ?=
 =?utf-8?B?bm9rRTNiMFNmSnhSV3kyK3VvVGIxL3FXNkZCaGt4RDJwRXVTVHV4ODg4WEY4?=
 =?utf-8?B?MFMyQld6L3Y5VExiWWd5UndCL0NsS3J1emFCWk8rU1I4Q25uNFA0MXhkT1Zi?=
 =?utf-8?B?eTBORmNOUCtOZk1tS1JpdDViV3RKckUxZjVaV0JzS2xZc1licmZieWpjVkZ0?=
 =?utf-8?B?bWVaTEIycE8wNXU3ZUlPM2lIV1FlUXFrVEtQZ2J6c2RDV0p2T3pDV3NDZDdE?=
 =?utf-8?B?TGtpUlhzQUlYTUZ2REppR3UvT3FjTDJKQ0FyMzljY1hpQmFnZVpuS3k0WHFV?=
 =?utf-8?B?OGxacU15Y3R4bEV2Y1dZWENscTBTVmlGa20vams2RStablZibXF4LzRUZ2t6?=
 =?utf-8?B?VFk5djdDd3h3Z1E2Wll0eW0zTDNuNndrblBZUXV3MnNkZWVkSzFsYzFaVWxE?=
 =?utf-8?B?dzMrMnZtMTdvV3drNnBMQVpDSmJ6MGl5eU0yM0NTaGd0UHpRZ3p1M1BYSDRJ?=
 =?utf-8?B?MGZpeDBiNlN2TjBNNCtXci9DMjhqeVJlcjB1Tmx0c0RVdklUT0dBZVBUTE02?=
 =?utf-8?B?Ni9SR2dBTVYxV2tLK2IyL21pS0FONkR5S1A2aEtqZVFXR0lqM21WRzNPU05M?=
 =?utf-8?B?b0VtcGtWL1VnQnFkeG9JQ2t2TjlLb2p1UU5pNFF4d0IzV1BodlFvcFk4b1g4?=
 =?utf-8?B?bnBmWUN4eW95RVl0MDV0dEVCbDNKMFJ0SzFNTS80WUFVNkNnRDV5cG9CN1Mv?=
 =?utf-8?B?NEdCTjZZbGhXRGM2ODBTSUE0OHh2WVVwNFRwM0JWZ0Y4SnFodWdnUTlpR1lX?=
 =?utf-8?Q?ugaONSRXySymPHgYxdPpUp/RH?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b6f40e8-3392-4f3c-990f-08daa0c7d575
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2022 20:35:36.8723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qqZbTtq13aHu4Dq2EE3RP4fgjpgbEeHu8M7mKXnGyyBt+HPw5uRt/MFmmf/ADpmdMhgpw5RNNAxBvnLp6zcQfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5817
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean / Maxim,

On 9/19/2022 2:32 AM, Maxim Levitsky wrote:
> On Sat, 2022-09-17 at 00:01 +0000, Sean Christopherson wrote:
>> On Fri, Sep 09, 2022, Suravee Suthikulpanit wrote:
>>> Currently, kvm_lapic_xapic_id_updated() checks if the xAPIC ID in
>>> the APIC_ID register differs from the vcpu ID. If so it inhibits
>>> APICv/AVIC.
>>>
>>> However, for vcpu 256 and above, the 8-bit xAPIC ID field in the APIC_ID
>>> register cannot support 32-bit x2APIC ID causing the kvm_xapic_id()
>>> to return invalid ID and fail the comparison with the vcpu ID.
>>> This causes APICv/AVIC inhibition for VM with more than 256 vcpus
>>> due to APIVC_INHIBIT_REASON_APIC_ID_MODIFIED.
>>>
>>> In this case, when guest switch to x2APIC mode, KVM needs to clear
>>> APIVC_INHIBIT_REASON_APIC_ID_MODIFIED.
>>>
>>> Fixes: 3743c2f02517 ("KVM: x86: inhibit APICv/AVIC on changes to APIC ID or APIC base")
>>> Cc: Maxim Levitsky <mlevitsk@redhat.com>
>>> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
>>> ---
>>>   arch/x86/kvm/lapic.c | 1 +
>>>   1 file changed, 1 insertion(+)
>>>
>>> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>>> index 9dda989a1cf0..750d385b770e 100644
>>> --- a/arch/x86/kvm/lapic.c
>>> +++ b/arch/x86/kvm/lapic.c
>>> @@ -374,6 +374,7 @@ static inline void kvm_apic_set_x2apic_id(struct kvm_lapic *apic, u32 id)
>>>   	kvm_lapic_set_reg(apic, APIC_ID, id);
>>>   	kvm_lapic_set_reg(apic, APIC_LDR, ldr);
>>>   	atomic_set_release(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
>>> +	kvm_clear_apicv_inhibit(apic->vcpu->kvm, APICV_INHIBIT_REASON_APIC_ID_MODIFIED);
>>
>> This isn't safe as it assumes the guest will switch _all_ vCPUs to x2APIC, e.g.
>> if one vCPU switches to x2APIC before the others then weird things will happen.
>> Part of me just wants to throw in the towel, but I think we have an easy out.
>>
>> The other funky thing to consider is KVM's x2APIC hotplug hack, where KVM
>> deliberately (and architecturally incorrectly) does not honor the aliasing behavior
>> that results when an x2APIC ID gets truncated to an xAPIC ID.  When the hack is
>> effectively enabled, KVM can actually ignore truncation because the resulting KVM
>> behavior of IPIs only getting sent to the "first" vCPU is the same as APICv/AVIC
>> behavior.  On the plus side, the existence of that godawful hack means it's extremely
>> unlikely the aliasing will break anything that anyones cares about.
>>
>> To restore APICv support for stable kernels on systems with >255 CPUs, which people
>> do care about, it probably makes sense to split the fix into two patches.  An
>> incomplete patch to ignore the truncation case that is easy to backport, and then
>> a fix for the fix to inhibit APICv/AVIC when there is unwanted aliasing (piggybacking
>> off my patch "KVM: x86: Honor architectural behavior for aliased 8-bit APIC IDs").
>> We can even get clever and fixup the Fixes: tag when doing the final application
>> so that there's a paper trail if someone wants to backport the full fix.
>>
>> Compile tested only at this point and lacks changelogs, but my thought is to do:
>>
>> From: Sean Christopherson <seanjc@google.com>
>> Date: Fri, 16 Sep 2022 16:48:03 -0700
>> Subject: [PATCH] KVM: x86: Don't inhibit APICv/AVIC if xAPIC ID mismatch is
>>   due to 32-bit ID
>>
>> Fixes: 3743c2f02517 ("KVM: x86: inhibit APICv/AVIC on changes to APIC ID or APIC base")
>> Reported-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
>> Cc: Maxim Levitsky <mlevitsk@redhat.com>
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> ---
>>   arch/x86/kvm/lapic.c | 7 ++++++-
>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>> index adac6ca9b7dc..a02defa3f7b5 100644
>> --- a/arch/x86/kvm/lapic.c
>> +++ b/arch/x86/kvm/lapic.c
>> @@ -2075,7 +2075,12 @@ static void kvm_lapic_xapic_id_updated(struct kvm_lapic *apic)
>>   	if (KVM_BUG_ON(apic_x2apic_mode(apic), kvm))
>>   		return;
>>   
>> -	if (kvm_xapic_id(apic) == apic->vcpu->vcpu_id)
>> +	/*
>> +	 * Deliberately truncate the vCPU ID when detecting a modified APIC ID
>> +	 * to avoid false positives if the vCPU ID, i.e. x2APIC ID, is a 32-bit
>> +	 * value.
>> +	 */
>> +	if (kvm_xapic_id(apic) == (u8)apic->vcpu->vcpu_id)
>>   		return;
> 
> This is the fix I had in mind for this issue, I kept it on the backlog for too much time.
> I also vote to do it this way.
> 
> Best regards,
> 	Maxim Levitsky
> 
> 
>>   
>>   	kvm_set_apicv_inhibit(apic->vcpu->kvm, APICV_INHIBIT_REASON_APIC_ID_MODIFIED);
>>
>> base-commit: 59afc619c353e67d087dc741bd828019985ffac6
>> -- 
>>
>> followed up by this later in the series:
>>
>> From: Sean Christopherson <seanjc@google.com>
>> Date: Fri, 16 Sep 2022 16:54:14 -0700
>> Subject: [PATCH] KVM: x86: Inhibit APICv/AVIC if the optimized physical map is
>>   disabled
>>
>> Fixes: TDB
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> ---
>>   arch/x86/include/asm/kvm_host.h |  6 ++++++
>>   arch/x86/kvm/lapic.c            | 13 ++++++++++++-
>>   arch/x86/kvm/svm/avic.c         |  1 +
>>   arch/x86/kvm/vmx/vmx.c          |  1 +
>>   4 files changed, 20 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index 13dadc96d9ac..6953d1a61357 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1097,6 +1097,12 @@ enum kvm_apicv_inhibit {
>>   	 */
>>   	APICV_INHIBIT_REASON_BLOCKIRQ,
>>   
>> +	/*
>> +	 * APICv is disabled because not all vCPUs have a 1:1 mapping between
>> +	 * APIC ID and vCPU, _and_ KVM is not applying its x2APIC hotplug hack.
>> +	 */
>> +	APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED,
>> +
>>   	/*
>>   	 * For simplicity, the APIC acceleration is inhibited
>>   	 * first time either APIC ID or APIC base are changed by the guest
>> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
>> index 00c89ff740e5..e9ba17aa0710 100644
>> --- a/arch/x86/kvm/lapic.c
>> +++ b/arch/x86/kvm/lapic.c
>> @@ -381,6 +381,16 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
>>   		cluster[ldr] = apic;
>>   	}
>>   out:
>> +	/*
>> +	 * The optimized map is effectively KVM's internal version of APICv,
>> +	 * and all unwanted aliasing that results in disabling the optimized
>> +	 * map also applies to APICv.
>> +	 */
>> +	if (!new)
>> +		kvm_set_apicv_inhibit(kvm, APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED);
>> +	else
>> +		kvm_clear_apicv_inhibit(kvm, APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED);
>> +
>>   	old = rcu_dereference_protected(kvm->arch.apic_map,
>>   			lockdep_is_held(&kvm->arch.apic_map_lock));
>>   	rcu_assign_pointer(kvm->arch.apic_map, new);
>> @@ -2150,7 +2160,8 @@ static void kvm_lapic_xapic_id_updated(struct kvm_lapic *apic)
>>   	/*
>>   	 * Deliberately truncate the vCPU ID when detecting a modified APIC ID
>>   	 * to avoid false positives if the vCPU ID, i.e. x2APIC ID, is a 32-bit
>> -	 * value.
>> +	 * value.  If the wrap/truncation results in unwatned aliasing, APICv
>> +	 * will be inhibited as part of updating KVM's optimized APIC maps.
>>   	 */
>>   	if (kvm_xapic_id(apic) == (u8)apic->vcpu->vcpu_id)
>>   		return;
>> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
>> index 3400046ad0b4..a1eb4e9ed3eb 100644
>> --- a/arch/x86/kvm/svm/avic.c
>> +++ b/arch/x86/kvm/svm/avic.c
>> @@ -992,6 +992,7 @@ bool avic_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason)
>>   			  BIT(APICV_INHIBIT_REASON_PIT_REINJ) |
>>   			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |
>>   			  BIT(APICV_INHIBIT_REASON_SEV)      |
>> +			  BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED) |
>>   			  BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |
>>   			  BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED) |
>>   			  BIT(APICV_INHIBIT_REASON_X2APIC);
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index c9b49a09e6b5..414485d03ee7 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -7996,6 +7996,7 @@ static bool vmx_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason)
>>   			  BIT(APICV_INHIBIT_REASON_ABSENT) |
>>   			  BIT(APICV_INHIBIT_REASON_HYPERV) |
>>   			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |
>> +			  BIT(APICV_INHIBIT_REASON_PHYSICAL_ID_ALIASED) |
>>   			  BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED) |
>>   			  BIT(APICV_INHIBIT_REASON_APIC_BASE_MODIFIED);
>>   
>>
>> base-commit: c8ecd2ebbc283d377188ee6c94cf3f811a4ff501

Sorry for taking a while to test this patch. This is working now w/ 
x2AVIC w/ 512 vCPUs.

Thanks,
Suravee
