Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAAF0747164
	for <lists+kvm@lfdr.de>; Tue,  4 Jul 2023 14:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbjGDMba (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jul 2023 08:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjGDMb2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jul 2023 08:31:28 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2136.outbound.protection.outlook.com [40.107.96.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C468E9
        for <kvm@vger.kernel.org>; Tue,  4 Jul 2023 05:31:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EVMzQUGFEAmSxXDcTa8SWO26qIn9D4qgVKBgAwcEkhBw5VHcHdi7b3cNzDQrmcjS72YZdpiGkxW3u/tG6D3dlsaoDubdLy4ISMIzcTre1ZCPx6LyyoGHBLQdxFtykS9K26h0ZxKgdW2ol1oFktnbBECqD+7IRSbK5xJS44/rJTdFxxW8zZLqR5Ycr+UmdmnwLM/hm2PJSVaPSZvZsINC47UryO41L2xAo9cmWjtKwQUXoMkkVcgqqb41X4mYFCdqcNdp6hkKixSs3FahkFesnu4igIsdJFC6N0KimeauwAFvyYHwGdtXM856iHQBcEYDOnsTKkpg21POIYFVYnWCkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/ZIHE2B9skY8pc8oL8mLprVSaWHo4mUj7WD28Gp4VlI=;
 b=L/xcZaBG1BuZv8PwhLL8evaYKxobTMYVzdq2GSfkuEulYZCfOzkx19VbNc8yaJ+nbEMGA810zNqgQqpzA0PLqLZtNHQpJnMFwimZUufF++4nMNt6l0dTg8IX4vTRXm+hN2x81yDzh73/mdrgY+788U6Ns9AHkS0vzxEdfuui1tITwBfXGIhv8FVguwsnEq2K8yf20EFB/FFHe0v2NiAYrqfshyFAW4D7sqR2ihG01LURL5IeDCJX9YKS02wv7ogS7fti+Dj4iAZCb0P2S1zr+i+7Roe/uE5uR/hJ5JDnmzOk8mEDEmBjIWMw9uoCdZ0GUxPpBUhKsWDllI6DEKsbkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ZIHE2B9skY8pc8oL8mLprVSaWHo4mUj7WD28Gp4VlI=;
 b=kBp7yfafQgxDA0V7OC55gQKQrpZMK9go6KH50dURuQsqAYhbQX7H8UdR41eI9tOP63t7OV6ODbwafLtjOvOfB+VgqtesEQ5cQU1uQjQtvPo2xtotfd+d70YwHcC0j0O/kxMTnFelMLnUTgkpn1effxIIflBiDwB3ROL6bgaMNwg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 LV2PR01MB7576.prod.exchangelabs.com (2603:10b6:408:17c::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6544.24; Tue, 4 Jul 2023 12:31:24 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::88ed:9a2b:46b7:1eb0]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::88ed:9a2b:46b7:1eb0%6]) with mapi id 15.20.6544.024; Tue, 4 Jul 2023
 12:31:24 +0000
Message-ID: <a62dba1a-86b7-45ab-f6a8-f88b224af402@os.amperecomputing.com>
Date:   Tue, 4 Jul 2023 18:01:13 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v10 00/59] KVM: arm64: ARMv8.3/8.4 Nested Virtualization
 support
Content-Language: en-US
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
From:   Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <877crmzr5j.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR05CA0067.namprd05.prod.outlook.com
 (2603:10b6:610:38::44) To DM8PR01MB6824.prod.exchangelabs.com
 (2603:10b6:8:23::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR01MB6824:EE_|LV2PR01MB7576:EE_
X-MS-Office365-Filtering-Correlation-Id: 0efb1731-c1b1-4222-3c8b-08db7c8a9451
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZpiacrPwnIDXXSYzZ/vJ6Dt6eJRu2bujbM3f+UkxPi7x2zq3tzBkolh8foWbYt3zJ7Q9K5ZRobNwbcBSpjGmHqY6SUELaz/3+iUf9PvZrn+iwUWmp1BO+b/b/lOcVfRegSWQ9gY0qg4dY0LNlq7JVUnbOzCjsXd0cZWI332hcziUwNyoAmK6U2MNGKIsTSuCtYzKRnmpBidY4z00nKR8YIQo6Ep8j5ALf+sC4ASJQO61xEFNLqCeV2JREl+kDAXQKwVsxG6Diq0trjmoVAPuoH36AZTCtBFzMvgVBamj5S/1qKA+NqhqCHHor3xG6bPryoIvTCjzhm7FuuqFT15lcVQ0K66lQIRxrndZh4bMua0ZK0VvYe/dVX1rQ+UqwbomKJP0tZMtaetEsCAu0Gmj8hUe+oBmBK26vyxxwG8T2ygg1KgmreNDckx89aA9ux0XEPBbgu+HGGb8Kj0/hM60LV5OICbhdE8V21s5HBeeLaHqdWvhjSFAYIeGRvDujpQrZWyBfcnVIlR1ExSmdsNFhK+U/Lx/oiDYirCNUw5tr1Y7sbiDXzJBNKrfMyXdTKHjmFEd8YX+DEv4asLRWU0CWXW93AeV0N6whvve/ZhDJGbVbMILIwrU+UrpRAVXloQ8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(366004)(376002)(396003)(39860400002)(451199021)(4326008)(31686004)(316002)(66946007)(66556008)(86362001)(186003)(31696002)(26005)(6512007)(66476007)(6506007)(53546011)(2616005)(2906002)(6486002)(6666004)(38100700002)(7416002)(5660300002)(478600001)(8676002)(110136005)(54906003)(8936002)(41300700001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZkdZY1MwNU9vb2RvTU1KN1dRYWlWbGc2WHd5UmVDZmxla05ZVlQ4bEhpUXVr?=
 =?utf-8?B?ckNYejFGTVA2ZGZ6b0F2N0I3L29vYjNxdE5PVUJKK2YwUGd5SGNEV28wZHA1?=
 =?utf-8?B?K0FsYUx1L3RQRzB5Sm45eDVzOW5ONHl4YU94eDFYaENYNjNTdVdGa0pzS0Zh?=
 =?utf-8?B?eTJzQy9nbE55UXBjUlZQS3k2T1MvaG1IaTdvWUpPU0ppREZOTVpCcHJXeEJR?=
 =?utf-8?B?a09rRG5hU1JSaVBidVRxb2o5WGNMckdIU1F2MVRxOHpNb3RjYzNodFlMZ0Fw?=
 =?utf-8?B?VkpvRW44NzJiMmtOZUlUcDQzZnBBeGJCR1BTSnZuWHdjelZLYlNwNy95ZnpZ?=
 =?utf-8?B?OTY3SjVMeVZiRlFTbDloSzZKa1pyakx6Z0Z3T29NQ2doSTgzUnp1cXNhb05s?=
 =?utf-8?B?N3FFK1J3NytVaExXZ2hQdFVuQkd1RHBZUmZveWxIRy9WTHBmVWNPbFp6em81?=
 =?utf-8?B?ZzBWNTlWR1lPK0FHKzltTW9KQ2FhZ3Era1U4VDhLWFc3MlZYNHh1MU1wdDgr?=
 =?utf-8?B?Y3VxdHUybWJsKzh2aGIxZEZrT1paNUNaRjZMbXUzdGxlTlovREpzNThyZGNS?=
 =?utf-8?B?VzZrY2lSNEYxMVIxUWNMZURCWDJwR1BvMWpRN2hLVWdpNjNMdk84alV3NkZ6?=
 =?utf-8?B?MHdnMHo2OHVIMUhMSUk4UnkvM3hKYUliNXJGNHdWVkNMbS9pVTgxSlUwcDlm?=
 =?utf-8?B?SFFLMnVDbyszOVNJQ2xmVnBab3gwQ3JxYWZJV3YreUUvS25IUUtzWjZoYUFT?=
 =?utf-8?B?NGtvT05Ea3JQTjA5aTlwMXQ5TGd3dUVuUGx1dVNDaGpvVEtkZU1UQ0pOUEE5?=
 =?utf-8?B?dHc5eTVwNzhvNzFzV1NzN0lqNUdhd0ZadXNiUmhZbVpwRlhYc0JwNU52N0tj?=
 =?utf-8?B?OWV0OWlsbEttSFJ0YWYzZy9IS2hjRUZ6M2VYUmZaaEJxb3JRZkQzMVhKV05n?=
 =?utf-8?B?Qm4yeVo1cmZEUWloQVFsMjlkSlpHWHVGUkt5eEtPS20wSDljWUkrSkZSQnhO?=
 =?utf-8?B?Z2kxUS9aak8xU2RsZGVwWWxTT1hXblBscXFwTGJvM1RhS1dmYnhzdmtWbE0x?=
 =?utf-8?B?TlhubmU4Z0FtdXB6VHBOUnFFMFVaRGYvOVhRNkROa3JVSEtxNjNid3B5WE1R?=
 =?utf-8?B?enpkKzZXei9WcksrTjF4WWQ4U09ZZjNnekhzbUE3ajVicmFDdWlmeWhJTC8w?=
 =?utf-8?B?eklMS0hRY2ZyTExnUTFqSTdHMURBd1VHN0dqN2k2cW96ZldMZm5lRlRjNzVu?=
 =?utf-8?B?ZkhIWFlxT0JGTEJqdFhIbTYwck9ha0lwdzB0cmJ2YTlCRldUSjk1VjJFdkhu?=
 =?utf-8?B?NGt0OFpRMWdDYlZ0WHZNTzVqYkpDSm0wUTRSQ2ZtZ2tqV29qU3BKaW5iOEZ1?=
 =?utf-8?B?SDFjcGcyOUNtMXQrblVrS25IZUZCUGhyVWMrUml5RXRvQmNISkxpZnE2eVNP?=
 =?utf-8?B?S1JXOFRvTk92NFdoV3hqOUlTbTFacm9scmNzL1V4YzQvQmQvTFlkaU9sbUhn?=
 =?utf-8?B?cGlkWWxhTE93Z09ybytvSTRXaTlNSnp6aW5TKzNqTFNxSFdOamFXR1NpS2FV?=
 =?utf-8?B?dDVUUGdHWElWc2dqVmphNnR4UHRGMGJST3dkcFFYZTdVaWxwWnZuTGh6Z3Iv?=
 =?utf-8?B?VE50US9uMWFJMWFuUThWS1FLbk5sSlVVc2YxN2hYRVpoQVBKeGUycHk0eUZT?=
 =?utf-8?B?cDc1b3NPMVV0YzRQRHNhOWxxaEVDcmdaelhOZUw4MGFYSzFmZXZ1UDFOS3I3?=
 =?utf-8?B?ZklHeE1yL0lZQnZqSWxtS0RQYk52bjNzNVlhWkhZYVlVd2hYRE9PSnBENDVE?=
 =?utf-8?B?YVI2ZytleUxzL3dQYjkrS1BaN1dMS2gxcWhqallpT1EzSmJiTW1jY1RBdndk?=
 =?utf-8?B?cGRhNU1DdTZKRWsvQ0JjenliZDYzVHB5REluVm8rMGhxODF4amFObjNLM21t?=
 =?utf-8?B?VkdKcng0Q1cxbE92R21BNlIzVXZtS0MrUlNCTUpjbjRtU1JtZVUzQktHeWN0?=
 =?utf-8?B?emZ1emJEems0UlJoODdMSHZTN0p1bUMxbzl0Wlp4RzlEeVdOVm5ER1d6R1di?=
 =?utf-8?B?TC9aYVpJNGJJVnIrQjVKeXd3NTJZN1VKMStqb1NDSG1IUmR1Zisxa3J5UWxp?=
 =?utf-8?B?dkM5Q1N4UTNEUkZ6WXV6dVZBa2MrZFBFbExMNTVjNzBpUTh1ZG5jUXZ0M0l2?=
 =?utf-8?Q?1RnE0V+QI3ZxnmMQcoIKNOQrkaGAa2iz06dqf0GtlB3/?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0efb1731-c1b1-4222-3c8b-08db7c8a9451
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2023 12:31:24.0410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RbLbIKXfEHpfpYaAM0G7D8uVaG81Cxx6LVYQzB0/ogAlwj5WGHf7qhsb3c+xQtWatZon2tp7VHva3PX+hG5cWfhzWxFgaFEy9aqDohIDq/VpAtkXnkP+21c7+P/3hOOA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR01MB7576
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hi Marc,

On 29-06-2023 12:33 pm, Marc Zyngier wrote:
> Hi Ganapatrao,
> 
> On Wed, 28 Jun 2023 07:45:55 +0100,
> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>
>>
>> Hi Marc,
>>
>>
>> On 15-05-2023 11:00 pm, Marc Zyngier wrote:
>>> This is the 4th drop of NV support on arm64 for this year.
>>>
>>> For the previous episodes, see [1].
>>>
>>> What's changed:
>>>
>>> - New framework to track system register traps that are reinjected in
>>>     guest EL2. It is expected to replace the discrete handling we have
>>>     enjoyed so far, which didn't scale at all. This has already fixed a
>>>     number of bugs that were hidden (a bunch of traps were never
>>>     forwarded...). Still a work in progress, but this is going in the
>>>     right direction.
>>>
>>> - Allow the L1 hypervisor to have a S2 that has an input larger than
>>>     the L0 IPA space. This fixes a number of subtle issues, depending on
>>>     how the initial guest was created.
>>>
>>> - Consequently, the patch series has gone longer again. Boo. But
>>>     hopefully some of it is easier to review...
>>>
>>
>> I am facing issue in booting NestedVM with V9 as well with 10 patchset.
>>
>> I have tried V9/V10 on Ampere platform using kvmtool and I could boot
>> Guest-Hypervisor and then NestedVM without any issue.
>> However when I try to boot using QEMU(not using EDK2/EFI),
>> Guest-Hypervisor is booted with Fedora 37 using virtio disk. From
>> Guest-Hypervisor console(or ssh shell), If I try to boot NestedVM,
>> boot hangs very early stage of the boot.
>>
>> I did some debug using ftrace and it seems the Guest-Hypervisor is
>> getting very high rate of arch-timer interrupts,
>> due to that all CPU time is going on in serving the Guest-Hypervisor
>> and it is never going back to NestedVM.
>>
>> I am using QEMU vanilla version v7.2.0 with top-up patches for NV [1]
> 
> So I went ahead and gave QEMU a go. On my systems, *nothing* works (I
> cannot even boot a L1 with 'virtualization=on" (the guest is stuck at
> the point where virtio gets probed and waits for its first interrupt).
> 
> Worse, booting a hVHE guest results in QEMU generating an assert as it
> tries to inject an interrupt using the QEMU GICv3 model, something
> that should *NEVER* be in use with KVM.
> 
> With help from Eric, I got to a point where the hVHE guest could boot
> as long as I kept injecting console interrupts, which is again a
> symptom of the vGIC not being used.
> 
> So something is *majorly* wrong with the QEMU patches. I don't know
> what makes it possible for you to even boot the L1 - if the GIC is
> external, injecting an interrupt in the L2 is simply impossible.
> 
> Miguel, can you please investigate this?
> 
> In the meantime, I'll add some code to the kernel side to refuse the
> external interrupt controller configuration with NV. Hopefully that
> will lead to some clues about what is going on.

Continued debugging of the issue and it seems the endless ptimer 
interrupts on Ampere platform is due to some mess up of CVAL of ptimer, 
resulting in interrupt triggered always when it is enabled.

I see function "timer_set_offset" called from kvm_arm_timer_set_reg in 
QEMU case but there is no such calls in kvmtool boot.

If I comment the timer_set_offset calls in kvm_arm_timer_set_reg 
function, then I could boot the Guest-Hypervisor then NestedVM from GH/L1.

I also observed in QEMU case, kvm_arm_timer_set_reg is called to set 
CNT, CVAL and CTL of both vtimer and ptimer.
Not sure why QEMU is setting these registers explicitly? need to dig.

> 
> Thanks,
> 
> 	M.
> 

Thanks,
Ganapat

