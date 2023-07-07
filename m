Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE4974AE03
	for <lists+kvm@lfdr.de>; Fri,  7 Jul 2023 11:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232257AbjGGJrH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jul 2023 05:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231566AbjGGJrF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jul 2023 05:47:05 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2119.outbound.protection.outlook.com [40.107.223.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD0AB1BEE
        for <kvm@vger.kernel.org>; Fri,  7 Jul 2023 02:47:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YhI5mdr8lASZshiFXb2euHC3Wn5pCodLy0DCv2wtGTu++UnX8yu8v2bWhNeQG/lsl2yx7ZJ7KZzBgZJ+cDazHyLVmmNcmQUhsUGUMImNO1lm+hE7Qher2kXSB5fZU+ufJJvEE3aIJvwhGumaUxlCEcRlgXeYmiGd5093p3XzO/KjMavpjy6q4ECMfwAk3WdEOiuwbETMrQiMKlP5NLMMS04it6iBR6iXa8BJSaSLvLORgrrmygk9qQKho0fNgOMKUGmxq9YZChIrqYgZTfMYa6jbVWYeCHy0ildCrDs6Svns0zEPA306PsOtHNBtJEr/Z+nQT8bTgznrNGgZp8ovnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6bjT9UnK2Ol3R0A6OOsAJEereU+L2DbilErJit4+JsQ=;
 b=TDXnnosMsTDDWeyI9WXoUD/gIek7CIn+LTrMa9jVCQjFR0kNtnUXnXrJAhdr6BiSUARWdqZOT+Bit8LOWJ5v5m9L+SeTgh6ZBUHRxA2euGhVkLP/xUPgd1ihHZwGpCHWrA8HuJe2KRPdB2dOQH55mt7assxN/rVJ+wLsq6tFiFJVKP2Z2oTgyd3QJVvHkoYf64STcDMjjP4nkAjcgZxtP+/VeMq/Ck0JnWBypA/WZMU8Nvi5XxdjT0za45CIYe7LSaUmRdS5tzZVmsLNTgbG0gW53ggP6zBfILzxm7VB5t9uOXjnr49b+Yrec3DCm5DQNaLu9x3UCUX3OH+WuwDTUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6bjT9UnK2Ol3R0A6OOsAJEereU+L2DbilErJit4+JsQ=;
 b=PK+4nC4ZJW8zSAPHpXgVaYyY5nW7PVvElno/44gbyNnU7Di1/x1e9JOJvtuo9Nbna16RLyFfGtOGz9cLpTIbLHV07tCCxhQIXoSrXQ/ryJ1HyG+8SSbujw2nuR58WfpYNtc/TAmD4WYRdZXSjlkcybv4Op3OWQIWoGMUCqEu2IQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 DM8PR01MB7190.prod.exchangelabs.com (2603:10b6:8:9::23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6565.25; Fri, 7 Jul 2023 09:46:58 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::88ed:9a2b:46b7:1eb0]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::88ed:9a2b:46b7:1eb0%6]) with mapi id 15.20.6565.016; Fri, 7 Jul 2023
 09:46:58 +0000
Message-ID: <04ec8efb-33ff-153e-3be5-5c84a01bff2a@os.amperecomputing.com>
Date:   Fri, 7 Jul 2023 15:16:49 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v10 00/59] KVM: arm64: ARMv8.3/8.4 Nested Virtualization
 support
From:   Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
To:     Marc Zyngier <maz@kernel.org>,
        Miguel Luis <miguel.luis@oracle.com>,
        Eric Auger <eauger@redhat.com>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Jintack Lim <jintack@cs.columbia.edu>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
References: <20230515173103.1017669-1-maz@kernel.org>
 <f19bb506-3e21-2bd6-7463-9aea8ab912f5@os.amperecomputing.com>
 <877crmzr5j.wl-maz@kernel.org>
 <a62dba1a-86b7-45ab-f6a8-f88b224af402@os.amperecomputing.com>
Content-Language: en-US
In-Reply-To: <a62dba1a-86b7-45ab-f6a8-f88b224af402@os.amperecomputing.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR03CA0374.namprd03.prod.outlook.com
 (2603:10b6:610:119::34) To DM8PR01MB6824.prod.exchangelabs.com
 (2603:10b6:8:23::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR01MB6824:EE_|DM8PR01MB7190:EE_
X-MS-Office365-Filtering-Correlation-Id: b9b3e8fa-f606-4a0e-2516-08db7ecf1ae2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s+Lb9GxIxelQYQNU+ZnXp1+o8TOc7wIIDjjQJ8sj1kMbktV+KR1ths2oDg9b+nHEw6+Gao4fd86WZFJc7to5TuwHbNLU5HE8DUZnz07rxn5PVXmxLGsaDxEm8RdSo+Apzd7l8SahbUahTbCIRSFpKqXI5+Jkn7hRS2K3yK0fgtq3pPKCpPvQSu1VpAGkrOSVvmJ8bFmPpc1t5f9kJjPOzO/V0UOd4A93NP/cUz51VQ5VM1aej1ycq+w3hrXAoMwuZySG5Ru0NpdH8Ik1t3zIVbxniSNo8L1TkjrwkpoVWSVmkKnQigJiRT/6JjdG5/T6p2+DTAXNEmTSifsNNYxECB+e/HUA7RpdlJYtz+tgQxQCV4OwyENz6eAFo24/fi5dN1KqZTYEWd3+so6libz9Z7rx/p6WpL2my+YHPpEz8Dj8OnqWQaJ4X4dmNQhMas9eyP9aLCKskEOo0G4iECoPywDGtFWkswb6Gp8R6YEEk0c53IzBiIIKl1H7esKpQzo1Ef+v5NpKzJys4+fjkvCffuR3wLwL93bkcCQAjU8rI0eQKMuXQHrbWjZERTNU7YgOaIHaVQDg5X7huAVOYbnyVzXuA7ksaxRjgwuVcS4YyGmgCL31Cg7bk75KiVxP1tZY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(396003)(366004)(39850400004)(136003)(451199021)(6666004)(6486002)(478600001)(110136005)(54906003)(53546011)(6506007)(26005)(186003)(6512007)(2906002)(41300700001)(316002)(66556008)(66476007)(4326008)(66946007)(5660300002)(7416002)(8936002)(8676002)(38100700002)(86362001)(31696002)(2616005)(31686004)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NVBUTFNsYjRiYzdybzBqK21YSVBXNndZR2hEa3hGU0o1NGJPQi9Yb1k5bWs2?=
 =?utf-8?B?TmZFdVA3Wi9odExTVU9MaG9KQlovVVVjUGZxdTBuYTlrZHRwbmtiNmxrbzJ1?=
 =?utf-8?B?bEN6LytLOTBaeC8yZTFHbExCUTlwZktDUUVwR1ZIOStUR3JhWkZHRDRmME1Q?=
 =?utf-8?B?N0R6SjZ4R0RwejVQdXhMQjloMm1qbHI4VFZrSHBDUEJCbVcyKzYvSmhTT1c1?=
 =?utf-8?B?aDJhZXUvT1BrWGlqQWtCZ28vaVRidlo2VlhYV2w3VTFtejNXRXdIbXpLNUxF?=
 =?utf-8?B?VnZaVkI5Y3k4WDlqQ2FKVlA5ZVV5NE8rNzVIdVpJL0lkTlhGQzlJcm5BMDUx?=
 =?utf-8?B?RDVFV3E0YisvOXhVVUFpeTBwc08zNUJ2Rit5REttUTRLS0JNT1R1ZlNoaHpx?=
 =?utf-8?B?NEQ0RkpXQmc4ckk1VnZPNVljTE9HejFGcE5Td29uZXY2M1lwS2RXdjFQOHN5?=
 =?utf-8?B?TFFLbS9uRWZ6aUhWaHI0ZEpRdUN5WEhncnVHc1RNSGdJNktlQUxJOGNvOGVi?=
 =?utf-8?B?eTJrSnBQMWRPeXBQVnc1QVV2SXZsTngxUVpLQkw1WnNzamJzTlRmY2djVDdH?=
 =?utf-8?B?Y1AwMkd0WXJ3b0RSU1ZqaVJkbExxUGZPM3NGMVhvdWNSbk5HeGxhT01OMU8x?=
 =?utf-8?B?ME9udllEd2Q1WWsvWTJTNXlxWnUvclZCNDZrdzFlOEZhYStYbWdSWlFnSXVL?=
 =?utf-8?B?ZWJvUXZJNEZPRmlsYkVOUm9NQUdLakYwSlVLV3FlaTBkQk9GZUt2TFVMbk41?=
 =?utf-8?B?R0Z3eHl6cTFhNmxGTE9HQ3Zxc2RxeFBic1NZdjVXRE1kZ09sZVE4Sy9KNjNp?=
 =?utf-8?B?dFRLbHlRWHBoa0diaTBaVVpha0JNQzNGdHIxOWZaUWVmUkdqalExNkNVWldV?=
 =?utf-8?B?ZVhsdDV5TmQ1cDA5NjlodFlKMUc4MGVhYVVZcmFwVEZuclN3L2ZxdCtoQ1BX?=
 =?utf-8?B?cHY5dktwVlM2MzY4ZXZTdzdvK0ZwYUtZOTYxU1lOWWNQNmwwR3dwOWJJb3NQ?=
 =?utf-8?B?b1VyVmVmaThoSUN4QkJlcnhrUG9nZk5RZnMvRDlmT25YVGVlRmVoUmdMREQy?=
 =?utf-8?B?bVNvc01vZzVsVXE3VGVDRWN2S2dZSjcveTE4amtpdkZuU1pvZHdidlE1azY2?=
 =?utf-8?B?cWlKVm5tYjRaVmd0ejNjdWwrRXNaMzJwVFIrRzRPQ3JlcFFINnFYVmFQSk83?=
 =?utf-8?B?UERGL3YydmRIRGpHeFFVQUhSaUhkbU9FVU5yamhqY1RaRzBKNE5kYm9OZCt1?=
 =?utf-8?B?aTRWbHA2REhacTZLeExURFdGVHVoQ2RETzZNQ1VBeThvMmxJY1ZET0hZWmVK?=
 =?utf-8?B?QklGQ1M5eW5RZlp3SlBCd0wrMDNvUkJBVC9paVprV2FvOGV6L3JCZ1Z1ODdW?=
 =?utf-8?B?WjNLNEQyY0gwTnFqU1lYMDJzWmViTUtudmNlSnJOWlZzRDBULzR3cGl5K09n?=
 =?utf-8?B?SmQyVFliUnRIRUpTWTY5eXNlc0ErVjh6eGMxOUVzeG1nNll5YWFPMHd6Vzkv?=
 =?utf-8?B?ckQrUXFiS3RlblpvaDgyaGZCNGw2cStwRzRlSEp1ZEFMaGlPcWNkQXU3QWdR?=
 =?utf-8?B?b3VKamRMbGQ4K3VqY1REbjQyUkRyNHZKcnBzVHJBTExRZ2E1RmRqajRQbmQ1?=
 =?utf-8?B?K29RdEszMkpXQzRVbUFDUFY2NkxRZlI5bXV1VjRQYlNOeWNQVzBoelY0ZXdt?=
 =?utf-8?B?c3orVkdEY3dkWTJQSGhDWWNMR1lyS3lNWUp4QVVaUUFCYitzenR1Zm5PNUVF?=
 =?utf-8?B?aE5kTkE0cXNSQVBpWXJwWkJyVFd4Wmd4VWp6NXVyVUlzUUlMdnk3UmRpU2Fo?=
 =?utf-8?B?eWEwdDdrQTV5dlJCWG5uZHVBSUMyU2ZrMXEwNjk0K3BTNS8wcjlSbTAzQmQx?=
 =?utf-8?B?NnJzNmZFOE1SNnhUazlZZ1FxWVBMaGdRdFU2a2JmQWdheGVDaFpVNTBjZGdU?=
 =?utf-8?B?SzlGdjhmVEczaEt3ZVQ5TmlHSHMvbVJSUHJEY05QY05ldGxzOFY0QUlkTEVZ?=
 =?utf-8?B?S0tCSW5EMkI4MmRJejJjZVd6NDJCQVBLUmFhdEVkR3gvWlYwZFNpY2ROd1ZP?=
 =?utf-8?B?MHRkaVRRUVhMZ2xhSG54S0xsZ3lnWXZkeXZ5SHZsR2h1RGlnbkFRQ0Vmc005?=
 =?utf-8?B?Q2tZc0V0UGsvbGYwM1JmbVV3WjRSZTNnQ0VYT2FXNy84Qm5IcnViWWVuQWJC?=
 =?utf-8?Q?6JE+6tjyui57x9APdqTGMxiugG5OXv1XbaWR+T/ZuoGU?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9b3e8fa-f606-4a0e-2516-08db7ecf1ae2
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2023 09:46:57.9520
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rp9pONHMhh9mBHg5E7S9gi/oaMWLlUFDdlDDqFG6MBVGKmS/EGYiMQXX3GasxSW/zURlA3CqF+hBdCWTcLmFQ5qQ1NQymXhNlbIaCUreb+LGhITkcfcYUn3r9i91QHkq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR01MB7190
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 04-07-2023 06:01 pm, Ganapatrao Kulkarni wrote:
> 
> Hi Marc,
> 
> On 29-06-2023 12:33 pm, Marc Zyngier wrote:
>> Hi Ganapatrao,
>>
>> On Wed, 28 Jun 2023 07:45:55 +0100,
>> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>>
>>>
>>> Hi Marc,
>>>
>>>
>>> On 15-05-2023 11:00 pm, Marc Zyngier wrote:
>>>> This is the 4th drop of NV support on arm64 for this year.
>>>>
>>>> For the previous episodes, see [1].
>>>>
>>>> What's changed:
>>>>
>>>> - New framework to track system register traps that are reinjected in
>>>>     guest EL2. It is expected to replace the discrete handling we have
>>>>     enjoyed so far, which didn't scale at all. This has already fixed a
>>>>     number of bugs that were hidden (a bunch of traps were never
>>>>     forwarded...). Still a work in progress, but this is going in the
>>>>     right direction.
>>>>
>>>> - Allow the L1 hypervisor to have a S2 that has an input larger than
>>>>     the L0 IPA space. This fixes a number of subtle issues, 
>>>> depending on
>>>>     how the initial guest was created.
>>>>
>>>> - Consequently, the patch series has gone longer again. Boo. But
>>>>     hopefully some of it is easier to review...
>>>>
>>>
>>> I am facing issue in booting NestedVM with V9 as well with 10 patchset.
>>>
>>> I have tried V9/V10 on Ampere platform using kvmtool and I could boot
>>> Guest-Hypervisor and then NestedVM without any issue.
>>> However when I try to boot using QEMU(not using EDK2/EFI),
>>> Guest-Hypervisor is booted with Fedora 37 using virtio disk. From
>>> Guest-Hypervisor console(or ssh shell), If I try to boot NestedVM,
>>> boot hangs very early stage of the boot.
>>>
>>> I did some debug using ftrace and it seems the Guest-Hypervisor is
>>> getting very high rate of arch-timer interrupts,
>>> due to that all CPU time is going on in serving the Guest-Hypervisor
>>> and it is never going back to NestedVM.
>>>
>>> I am using QEMU vanilla version v7.2.0 with top-up patches for NV [1]
>>
>> So I went ahead and gave QEMU a go. On my systems, *nothing* works (I
>> cannot even boot a L1 with 'virtualization=on" (the guest is stuck at
>> the point where virtio gets probed and waits for its first interrupt).
>>
>> Worse, booting a hVHE guest results in QEMU generating an assert as it
>> tries to inject an interrupt using the QEMU GICv3 model, something
>> that should *NEVER* be in use with KVM.
>>
>> With help from Eric, I got to a point where the hVHE guest could boot
>> as long as I kept injecting console interrupts, which is again a
>> symptom of the vGIC not being used.
>>
>> So something is *majorly* wrong with the QEMU patches. I don't know
>> what makes it possible for you to even boot the L1 - if the GIC is
>> external, injecting an interrupt in the L2 is simply impossible.
>>
>> Miguel, can you please investigate this?
>>
>> In the meantime, I'll add some code to the kernel side to refuse the
>> external interrupt controller configuration with NV. Hopefully that
>> will lead to some clues about what is going on.
> 
> Continued debugging of the issue and it seems the endless ptimer 
> interrupts on Ampere platform is due to some mess up of CVAL of ptimer, 
> resulting in interrupt triggered always when it is enabled.
> 
> I see function "timer_set_offset" called from kvm_arm_timer_set_reg in 
> QEMU case but there is no such calls in kvmtool boot.
> 
> If I comment the timer_set_offset calls in kvm_arm_timer_set_reg 
> function, then I could boot the Guest-Hypervisor then NestedVM from GH/L1.
> 
> I also observed in QEMU case, kvm_arm_timer_set_reg is called to set 
> CNT, CVAL and CTL of both vtimer and ptimer.
> Not sure why QEMU is setting these registers explicitly? need to dig.
> 

I don't see any direct ioctl calls to change any timer registers. Looks 
like it is happening from the emulation code(target/arm/helper.c)?

>>
>> Thanks,
>>
>>     M.
>>
> 
> Thanks,
> Ganapat
> 

Thanks,
Ganapat
