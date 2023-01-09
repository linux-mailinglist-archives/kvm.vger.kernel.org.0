Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7586627E3
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 14:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233336AbjAIN6z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 08:58:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237245AbjAIN6n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 08:58:43 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1008B25C0
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 05:58:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UVO2e2uduiSQW+WwZlIGMEO/zIL214lsMiV7MfoSfucZK1G2Vq+G9Y4JPRbrN/1VtRSVKMoyxdIzeWfLDwx2HUBQ+GC5Cdq262cb87f+m7u09fCNcyXeG2PcCqK1cHAuiV5BLP3e8fRfvXbygCEOpKR4x7SK7y8rLPtufnVtn9naZCBLw8wHQW56aXak3AfeT9/Yxz1PI+Wa9WrOlDzyoGJWsm2DQ1hGfjESpV08k0QGQxWyvOiT6i0no7bK8tpS0hZUdm+N/MAqsxqUH7xAe2/Kv2kml421p+H6IYMAWH9YPNtWJPQU/P3MShzF3KCLXHB9B+hsDkwZZmL4oRvYRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qull4C2jLLpKgmWE4OFUu/C2BBbArsJkYEXikFTMzFM=;
 b=UZ6CRklNffnIAkWQOntYxBzSWPo+SjcZ8bdb7O2ueQnLyUikN5HqyxNrm9lATogc7LUml75ZxE5RSYtAO+EUoQe5sBTkB9s7d7fjyR/zNDv2bfCNeuTuJmFpkL32oAkag4Fgmxq2IYvd4kZwx7LFdng7nleoNDWUPeAGQKikMJBgzAt9hz2DA0OSQ0cSOVRcCnHQBM5r1FNihxafeq4HVd6LYu0uLOZPX8jCpam1mx4P/lSf01n3DR+Eg9wmMRT2pob+w0+X9BhJKSyMYwC1Qc/dok99Q5ZhS33qMlxwiubvTarkigYDTkQft1tdqnODrZ/sjpfJ1s4wwb+2Q5XOCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qull4C2jLLpKgmWE4OFUu/C2BBbArsJkYEXikFTMzFM=;
 b=JMdtkE2tVObx6mkQs9KQLasENK5rvxI3ZJ9i54mesOydGWq/ahMR8VjPUL58cXoM9kywJhWuXT9QMZ518QHmoTUrKXFbNcWHk25NwQdx/8Y1r4VtAxVmQFdgdHn/hy02fIjMmxKkFgDeMMax0mv97hyHVlT+tE9Ev4EuHl7x++0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 SN6PR01MB3887.prod.exchangelabs.com (2603:10b6:805:27::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18; Mon, 9 Jan 2023 13:58:38 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::6b5b:1242:818c:e70d]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::6b5b:1242:818c:e70d%6]) with mapi id 15.20.5986.018; Mon, 9 Jan 2023
 13:58:37 +0000
Message-ID: <3d630420-d485-44b7-d274-58c41fb46d7c@os.amperecomputing.com>
Date:   Mon, 9 Jan 2023 19:28:30 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 3/3] KVM: arm64: nv: Avoid block mapping if max_map_size
 is smaller than block size.
Content-Language: en-US
From:   Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, scott@os.amperecomputing.com,
        darren@os.amperecomputing.com
References: <20220824060304.21128-1-gankulkarni@os.amperecomputing.com>
 <20220824060304.21128-4-gankulkarni@os.amperecomputing.com>
 <87wn6ads39.wl-maz@kernel.org>
 <eadac5ec-6b61-9afe-3117-50fd9569ad4a@os.amperecomputing.com>
In-Reply-To: <eadac5ec-6b61-9afe-3117-50fd9569ad4a@os.amperecomputing.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR03CA0220.namprd03.prod.outlook.com
 (2603:10b6:610:e7::15) To DM8PR01MB6824.prod.exchangelabs.com
 (2603:10b6:8:23::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR01MB6824:EE_|SN6PR01MB3887:EE_
X-MS-Office365-Filtering-Correlation-Id: 50c616e1-389d-49ae-4c5d-08daf2499b2f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gF1RoUWllaOS8HPrz7RtLHNhwlW9b0rOhNQDqBujUR92TWaWtOoWs8aYW6XVi3c9ySjUX9Segr7KhwV3SflskFXLocBeB0XD6pn5Mq6kLwQ+sISuEM4kOX5Bpe4sDzfF3f0gnssJKbXLnYUo36Jbng5Exq2jWPS50gEjriM/kJaPxU54+fC3/4yO0Vujf1hxbzpS11wziAwZ7Rba+d6YYltZaxtcX6xU84+ZYxieZ55/ymcs8WTA37A4LZhrtSUfoDMLtVlz6WV4ahO/alQCq1o4ICyW1MnRhexFbglOBfMZlnVsEvSAONKBokOjqzfdWLYNvY1c8IpFsEszRJgveJ+Qxyj36V7ojRMY6Qw0QUNlGyzQondDBRWr/vmmRcoFwk6lhGeYy2hfeG6O41hGFtdTRwwitifsiqmgPzDcecRXInl5PPwuskX3o8jFD6mrPU29eBkccqeRV/7uYJW0p13d8g4Mefyw0+mSppV+cUxWgNM8soYs6ff+hqV0EtPrR6o8GbzHJ5L3+GyYZurYC/NGgfrBqP2opOmEGRZjlk909AxGnPaiBqwFo/GSJuNFsR4DF7GKUKEbBj+zTZ1/T7PAiXo+iD5JJdB+F0Dlo1XcK4/gX3vIgYV4SVliJK891PFyq4mXn4Xyq4WffNJ1pM7EGFBwXngS+X1iajQ8zNdnMtPzyBm8AEqql9j7DdRe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(376002)(346002)(39850400004)(366004)(451199015)(41300700001)(31686004)(8936002)(5660300002)(2906002)(66946007)(8676002)(6916009)(66556008)(66476007)(6512007)(316002)(6666004)(107886003)(6486002)(478600001)(6506007)(53546011)(26005)(4326008)(186003)(2616005)(31696002)(86362001)(83380400001)(38100700002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VjcySEJKaHR6SU9RZk9RSFZENTltS0NZaHZtK1RhTmhEanVqNC9nVW9ZWDdM?=
 =?utf-8?B?bUxjYnRhVFROMllwOHJxaXFxMUVud2lMMUNsd05oUUpaSG1xRzlabzg5U21M?=
 =?utf-8?B?QjNpRFlQbUhNUFZ1OVUvbGxLdG1uMGgwWDJQRzdCNTRveFMyNzNIR1dVSk1t?=
 =?utf-8?B?RmtveEVvMHkzNWZnT0lOVkZaSUNTL3pXYXhqNWh2Z2pmYzZTWDNXR25sZjY3?=
 =?utf-8?B?em1MMWg3OWtuUWR1d1E3Nk5JVjJpVURNUjBKKzh0eVZ5dlhDdld3R2lWZHhM?=
 =?utf-8?B?aHd2OU5Cbk9jNUdJRHNWMjZXZEpTNHIyZW5GR0hTZ2VsSU8zSnFyMHY3anV6?=
 =?utf-8?B?d3MxeEVsSnpvNmFpYno3cEI5VzNZSTNXaUJZcmtlSVVYeVJYbEhyaVFPWWFD?=
 =?utf-8?B?cnYraFg4V2ZJOUs2MWFTcHpPVEhjZ2RNN051b010VnRjNDRiclFXQ25VYWlW?=
 =?utf-8?B?UGEyTFo5NytrNDhzTVk0UmRLNWkzRWNWZlZPM2xYcUFpRWVKVy9kQU9zempD?=
 =?utf-8?B?UjEyTFowMFY5aFAwL29xcU1adGgyZHlmWXdkTVYvSG4zZUlIOEpnL3ozcVg1?=
 =?utf-8?B?RUwrcmdWVVdMZU5pL2daZ2ZGSTBZTFFwaU1MdDhoTkFaNk83Mm10REZNUCtq?=
 =?utf-8?B?RVU0dDFWMC9sMFhUSnRORGlsZHlsZmJBQ0NHKzFDTzU2UzF3RjRBTWpWU1lp?=
 =?utf-8?B?OFplaUdTSlI4eDBIL3BXc3AyWDVxS3QxVWVvTHVzOWd5ODRPT3A2aWJmQXdU?=
 =?utf-8?B?cFZLbWJtck5TZGNOd1hOQXpqeTNYOGZGcGx6SlkvOGY2dm5ZQ0hRbzBJb2dE?=
 =?utf-8?B?ZmpYQTlNNU1TWmcxTlBmVm84VmY5SEtEQi9VWXdXMkpzb0lmYVhjaXhka3E4?=
 =?utf-8?B?NXIxNGtLSmhrbWhCS0Jkd0hQblRmRW5jWWxwN0d1QnhVU3J4c1dLY0FocDZM?=
 =?utf-8?B?enpHVFNFbml6WWxoWi8zVDdYeGdaaGNsRW1IdjBWUHVlS2VVL0NOcXBTZXNs?=
 =?utf-8?B?Rmxtb0ppZUVxeEk0bFdXc0doMnA2UHpPWERwVWVBOTBCTC9QeXdFcnE5SUY4?=
 =?utf-8?B?TWJYdHd0a3FHSGZTeno4aXdkQVJUT202d0VYZjIzVXc2cVZPa0VWK2tEWTFz?=
 =?utf-8?B?aEViWGt5VmkxSzVaK2ZaeDNsWUc3VTU0UjM0QjRmUWJ2TXN4dDhPcnNRcUFl?=
 =?utf-8?B?cW1yUHZCaWZxYXdVeDZtY2VZdHlDL1JRdmpHdWtZNFVIV1VNeFVtY3pPRXR3?=
 =?utf-8?B?VHFvNTE3M0hUL3hDMSthUGhHNjI1bDcxL3A0N1RjajRhTW12TzVhYlR2MzM5?=
 =?utf-8?B?QXNVQzhQZG1iekNYMmdsSC9IWFdpcXgwTVRlQmx1TzlDV2hVaFpOM0tsOW5B?=
 =?utf-8?B?cXdjd0xGZmFSZUdpeE95UGxEaW9zNWEzbEJvTVlmVVJzclJFN2dpUjJoY0ty?=
 =?utf-8?B?RzhYSzNaNEVvSXhoUUhScm16ZWtQODJYd2VUM0ZPZWxtM3BKS1lUSkxKczhW?=
 =?utf-8?B?Y0lEdHNvb3lGUURITzFLQkVsbHExZlJsMk9McG5FVXhQa1VmenRGQlRmVnFV?=
 =?utf-8?B?T3o2ZWZWT0FCc1paaU0zeXI5emY0NWt3RnRoVWxaU2xtdEtoZzc3aFFiMjNx?=
 =?utf-8?B?L0F5amgyWFJQLy85MHBBZGJnWlUrY3NwcXliQm5aK3QxdW0rOTYzK1loM3NP?=
 =?utf-8?B?SlZ2aHF4eVI2RDdUclNybFZ2R2dUNzNtNno2TlJjRWZBTjk3NVJzZHE3WjR4?=
 =?utf-8?B?dHBxNHBoYUk3VGltRzVoSzlUc1NNbnU5S3JlWTN6eUs3N3Q3NXVremRwSzY3?=
 =?utf-8?B?eUU0eUxFLzRMdDRzdnkwcnFqaDFydVVmcjRCMUM5VTFjK3gxL2FLTnFVaGtC?=
 =?utf-8?B?eFdzazZaK0dhY0VOdXYvcWVoY0R6c25Ga3ZwSFd2VUNBS1FSNEpmMWpsS1Rr?=
 =?utf-8?B?NnBTWU9uRSt5K3JGR1NhSXdjMTUrTG9BTEFPMjFZM3Q3a1hNb3JMYWhReGE1?=
 =?utf-8?B?WmRrWlJ5YW5uQUxNTHVIVHlPZDBON2thdU9FTndtT2RxRnU3V29Va3paUWNF?=
 =?utf-8?B?MlMyNlVPTEVDSllhenVwUTAvMkZKOWd4N1puQkNKTGQ4SWY1cXl0em9FTHEr?=
 =?utf-8?B?RFRYK1NCQVJGTHZ2UnJrVUtCZDdQOVJSRFFiVDlaOFdUMEp4dkdsL0YySEh2?=
 =?utf-8?Q?ZtsWZvOEnlA+h3xf5E6b6RY=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50c616e1-389d-49ae-4c5d-08daf2499b2f
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2023 13:58:37.7855
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KmpJzjUMMiB7DL/5vAy92UUtwk2rDbUWDF/wY+la7InpMW10jD7aDCfb1IfWh9peivW2hD5wovjDoXYAgPEtYR6A2pfbSKd6dUK3tW2xmihHGu+mT/rmKXC8AmNaJ26F
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR01MB3887
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 03-01-2023 09:56 am, Ganapatrao Kulkarni wrote:
> 
> 
> On 29-12-2022 11:12 pm, Marc Zyngier wrote:
>> On Wed, 24 Aug 2022 07:03:04 +0100,
>> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>>
>>> In NV case, Shadow stage 2 page table is created using host hypervisor
>>> page table configuration like page size, block size etc. Also, the 
>>> shadow
>>> stage 2 table uses block level mapping if the Guest Hypervisor IPA is
>>> backed by the THP pages. However, this is resulting in illegal 
>>> mapping of
>>> NestedVM IPA to Host Hypervisor PA, when Guest Hypervisor and Host
>>> hypervisor are configured with different pagesize.
>>>
>>> Adding fix to avoid block level mapping in stage 2 mapping if
>>> max_map_size is smaller than the block size.
>>>
>>> Signed-off-by: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
>>> ---
>>>   arch/arm64/kvm/mmu.c | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>>> index 6caa48da1b2e..3d4b53f153a1 100644
>>> --- a/arch/arm64/kvm/mmu.c
>>> +++ b/arch/arm64/kvm/mmu.c
>>> @@ -1304,7 +1304,7 @@ static int user_mem_abort(struct kvm_vcpu 
>>> *vcpu, phys_addr_t fault_ipa,
>>>        * backed by a THP and thus use block mapping if possible.
>>>        */
>>>       if (vma_pagesize == PAGE_SIZE &&
>>> -        !(max_map_size == PAGE_SIZE || device)) {
>>> +        !(max_map_size < PMD_SIZE || device)) {
>>>           if (fault_status == FSC_PERM && fault_granule > PAGE_SIZE)
>>>               vma_pagesize = fault_granule;
>>>           else
>>
>> That's quite a nice catch. I guess this was the main issue with
>> running 64kB L1 on a 4kB L0? Now, I'm not that fond of the fix itself,
>> and I think max_map_size should always represent something that is a
>> valid size *on the host*, specially when outside of NV-specific code.
>>
> 
> Thanks Marc, yes this patch was to fix the issue seen with L1 64K and L0 
> 4K page size.
> 
>> How about something like this instead:
>>
>> @@ -1346,6 +1346,11 @@ static int user_mem_abort(struct kvm_vcpu 
>> *vcpu, phys_addr_t fault_ipa,
>>            * table uses at least as big a mapping.
>>            */
>>           max_map_size = min(kvm_s2_trans_size(nested), max_map_size);
>> +

Would be good to add brief comment about the changes.
>> +        if (max_map_size >= PMD_SIZE && max_map_size < PUD_SIZE)
>> +            max_map_size = PMD_SIZE;
>> +        else if (max_map_size >= PAGE_SIZE && max_map_size < PMD_SIZE)
>> +            max_map_size = PAGE_SIZE;
>>       }
>>       vma_pagesize = min(vma_pagesize, max_map_size);
>>
>>
>> Admittedly, this is a lot uglier than your fix. But it keep the nested
>> horror localised, and doesn't risk being reverted by accident by
>> people who would not take NV into account (can't blame them, really).

I agree, it makes sense to keep the changes specific to NV under nested 
scope.

>>
>> Can you please give it a go?

This diff works as well.
> 
> Sure, I will try this and update at the earliest.
>>
>> Thanks,
>>
>>     M.
>>
> 
> Thanks,
> Ganapat

Thanks,
Ganapat
