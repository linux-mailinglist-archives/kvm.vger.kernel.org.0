Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBBDC665BB5
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 13:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235719AbjAKMqz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 07:46:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232871AbjAKMqq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 07:46:46 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2136.outbound.protection.outlook.com [40.107.243.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF5521B9
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 04:46:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nTUPSr05MMyMBJkTaiSQtPpiZcZGZNNNcQoScwj9GFd74cqwdYBvXFz0eZdCX+yAmYAnh57D7HBVOUb44uzQr+UPxLOG9NqGO48K6Yvy61p/UWjtWOZv0JW//gRkpXlqPWjerHnCgD3oTwvPb67s/wtZuDVl65uq9w+wCTI76oGkHlJOIBOdqY5AZ3XHQCN/JdUE+HG5i7u53fgCjrV48NJktgE7MsQndSoWUrGpm6mCHNzy6TlKZoaL/+a1KzooHnwJXlr0LmksOFOFgnEm2zQTF12HDAWVgKMCgaeBJp1xN59PGLsi0aXM5l0TxGZVed3TGk2XPaYq1ZB3PrjkVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dv6VT49itW1dpmHFvwrc8g7Zsh1uaX0qfT9Xp27A19I=;
 b=b69TmliDHlDoAqgCLKZRuDsydYPo7Yxv1XbmhqnFgV/Ia3v4HXlOA50snZdVz0FQhb7E5eXa7Q+jsrZAsgAZaNwhDy2JpxT1+png+nbsLFYkPb8YRn6n+qdJPOPZADkdqcdV6Du6K471f9zUyje8LhyZ0IxYBva1a/ia3VtY7LzUMFKaMXCRtXrHI/xbMh65XhCS4O1pSVqr3jTp0kzaMb5yk2d+cdfAg9n+MksTD13R0IEkaXqQv0l8Kxs9WxrE6DQFWlGKzg5oBUQBFJulq230ZCmunDymLtXcQhrWePm1ZNXABaccwXJrUQVKnH5jleRNKhHD8FhxgFQAJ/rOUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dv6VT49itW1dpmHFvwrc8g7Zsh1uaX0qfT9Xp27A19I=;
 b=RG0T0K+Nq9pMZhBPCCyHi5/kTAKYamzeDnsCBsyMxDUT0q6CGO56JCRBJ3IoF4IvBzbwrGkICxI1mbWiecrkv9p1FigTbWbyoYdMZkC9eT2qIUhqP4zsdRcZYdQ6wss9JTH26Ymf+me/3cYQmOmhzHP85cCEMALuc+GfuWp+yJA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 DM5PR01MB2571.prod.exchangelabs.com (2603:10b6:3:3d::17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18; Wed, 11 Jan 2023 12:46:39 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::6b5b:1242:818c:e70d]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::6b5b:1242:818c:e70d%6]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 12:46:39 +0000
Message-ID: <b3895df9-8094-5548-1633-0c6a405d1c0c@os.amperecomputing.com>
Date:   Wed, 11 Jan 2023 18:16:28 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 0/3] KVM: arm64: nv: Fixes for Nested Virtualization
 issues
Content-Language: en-US
To:     Marc Zyngier <maz@kernel.org>
Cc:     catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, scott@os.amperecomputing.com,
        Darren Hart <darren@os.amperecomputing.com>
References: <20220824060304.21128-1-gankulkarni@os.amperecomputing.com>
 <6171dc7c-5d83-d378-db9e-d94f27afe43a@os.amperecomputing.com>
 <87o7r6dpi8.wl-maz@kernel.org>
 <4d952300-0681-41ff-b416-38fbae4ebea6@os.amperecomputing.com>
 <2169cc83d3015727f5f486844c8c4647@kernel.org>
From:   Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <2169cc83d3015727f5f486844c8c4647@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR02CA0048.apcprd02.prod.outlook.com
 (2603:1096:3:18::36) To DM8PR01MB6824.prod.exchangelabs.com
 (2603:10b6:8:23::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR01MB6824:EE_|DM5PR01MB2571:EE_
X-MS-Office365-Filtering-Correlation-Id: f604d366-ba47-4835-47dc-08daf3d1e1b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 57mtctWlLrAWL55Z4hHsUGP/azcaczHT96s8d00lNl7NpKbuFKd5qHJoKAPRddloAsV89U+U/rWgTYNLap3/+RTP/8E4DknOZW7BV7PRyQN7HZqN/1O1VnGLRAolx4dyjgBNYR8y6UcJib5lLbtZNPYs0QhinLMSA4wjFynQE0h3vxD/xF9/P0mXihyKYL+qYp+awgpdMXR19XUuczwDFX3acPGLTa5IBsj1dsj0gdiDiVlszA+hWWGb2CMUb2E9w5i4j9Df3c2iVYxcFFWnqUMK9YAqLSYG87r65TuTB1FbcE89WfZQGwqb6rnSTcCO5wswqmZrVKKO58sIIhBqgOhr9kqnG4aXES5I990h/RW9P5i7nWvTkIEe0ZCKbvmOYpLnZOo37HswVKgLgKpJfUzehAeZAJ+TVN7UMUTNYbIropCHVpott/mOojr3aLvKIfN2FlY2sjHmKb3nuXzyytcluapNhrFVbFsL8a6W1J2+7BE6UXJZra7BmqKQLK27RKrGSy3Za5DbsmUBPK0HsjNT0QK/WsuJn35SMtzmveaDur0pxwQlwJ6nVE5mK6NNjxY6mt58q+4JARlVXXjdVEchzfJ+FYeZlvkQwzCgM9Zdq3f2+pZh034nT1LmeKh3yKSjPEstkBPttZr6E0X2+bPvab6t4bdUTFPIurdCvQaAIoBzUm2xJGv5hQ3IkOUFoyM5K21w/SjSUodvyNFuiw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(376002)(136003)(39850400004)(366004)(451199015)(26005)(31696002)(86362001)(316002)(478600001)(6486002)(38100700002)(2906002)(5660300002)(107886003)(66946007)(4326008)(6916009)(8676002)(41300700001)(66556008)(66476007)(8936002)(83380400001)(6666004)(53546011)(6512007)(6506007)(186003)(2616005)(31686004)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Ui9GMU9BSXFUR0ZWY1F4VGoxa25JQlpHeFQ5Q0Yya3JJNGw0L3RsYlFZZTEx?=
 =?utf-8?B?a2N4ZE5rUmV6dFNFS0dtcUU4VVlCc3NvZ1Z3bkd4TWp4QWN2OHFZS3B2MDdB?=
 =?utf-8?B?S3hQK1h5em1RSWFJUmdhTFVmdGJ0Z0E5RXdLSFc5aEFHTXcycmJBY0pacnJj?=
 =?utf-8?B?Uzd1OXFBQzRxaFYrK3QzWHE2ekN2NDY3cGdPZ2VReHJWTlB5UW1JMmR5dThp?=
 =?utf-8?B?emMzQnVwbFZGNmE3RUt1dlZWbExrcGw2VnBpZG1KYkZWUEwwS2k2L2wyNDFF?=
 =?utf-8?B?K1BwTWhRd25JNWozbWhSeEtKYUtxcXdQOVRyc2l5cy9nV2ZsMXZNU1A0RmNu?=
 =?utf-8?B?eEs2eFM3REdzMWRJMTJKWHIrWTc4MUZoTkgvb3RFamR5RXVXL1NKNVRsWDNX?=
 =?utf-8?B?ZHA3ZnVEZFBrSlN0ZVpLYWR6Tm5aOEV6UWljZ1pzZG9iY25nZCtBRXpYVWxu?=
 =?utf-8?B?UndGSFF1a2NIZlJ5OHE4NHNQaHd0MW9yMHRlSVc1bWJ6eS9oRGM5Ukx0OVQw?=
 =?utf-8?B?bklBN0R3NFdxM0xHMzZscXV4NlZHbVc0L1BackhtTDJSTndTb3RlSTZVME9O?=
 =?utf-8?B?T1k2L0E4UnI1WFZENG14UkpweVVrQjU1RVhVS3BKZ3JXRTJTL0dlcWdMU05z?=
 =?utf-8?B?dmllYk14WDBjaE5QbllWNHJ0eUlKTHZrTmlEbFBrNjlteTZZa3A3emVxcUdr?=
 =?utf-8?B?Ujh2ME5RUlE1QXVJNkdhQWtNcnZpYTVScHhEeURwdEV0dE16K2daS0grRjhi?=
 =?utf-8?B?b3JjQkR4ODkwZ0s5VE11YkkxT0pGQldGQmZ5MzQxdUZJYzBoMFhmbEFEeVJL?=
 =?utf-8?B?aG9wUFVZdEhLWkpYeHNpbGYxdDdmNUw0bTFiWG1xNVRwcDNZNkRaSnM1WHBm?=
 =?utf-8?B?cjJoRFlGM09JUzQ4M3UwOEdOQk1nZ09CZzNJTVdKVFVBTERjYUovUDVOVTlG?=
 =?utf-8?B?bnMvT0p4MDU4VWpMVXAxMkdxYjhFNFY4UllyVkhUVDdGLytSQ1JQdDM2NzlO?=
 =?utf-8?B?N1hWK2FjSzdrQ3BuUmdMSXJFZTkvNm9OMjJXUVJNMFYvRjd1cENyUEx6QWZh?=
 =?utf-8?B?N3FlWVplR2VKSnZ3S3RaVFIrcmUvQkRldzBPZ3pZZVp0Zkgrc0thdkFoeE1a?=
 =?utf-8?B?eTZyY2o2ajVKYXd6VGdIclhZdGZ4aEgyK3ZhTHoyQmdEZlVWeTd4Nlg4UlIy?=
 =?utf-8?B?cTNZVGV4aXg2b2dPWXpSM3FDY0Y4eTJVdlp5QnkycVM2MFhhb21QR00wVkxI?=
 =?utf-8?B?U0JhcTlPVzJLSGVwejZTd3JhbmN0eDRtbkFIUnlERHkvZFZrbmd6d0RlbHYz?=
 =?utf-8?B?aFNpVEEya3NrT1BaS3FyZGpNWWs5NjNyTHFaRXk2MzAwU2REMlZnVU8wTUEx?=
 =?utf-8?B?VUZTamVYcG5CUm5lenp5cTNENHhLTU5Gdnl1REJ2UG9oWlpCeTVyOSs1UklS?=
 =?utf-8?B?b2R2QVhtaHJ0NkhGNGVuYkZxajN0NndMQkx2THZ4S3RhOStZeEFmWWZnQnl2?=
 =?utf-8?B?TklWY0NnVTM1a2t4Tzc4dXZPSk4wS29qWWx0c2ZPNUFSWHFIZlZpR0EyMlRv?=
 =?utf-8?B?a0Flc3kwdGNjbHk5WDZUcHZuSUdpdTFCOWtadEFxemE1cjhQblduTktTL0Ew?=
 =?utf-8?B?djVrQ0VZVHVBa2lnZFI1dSs2TjFvajVhM1J4dHBEMlAxMlhka0pWYndTMW9F?=
 =?utf-8?B?T3JvNHk0ZVZreDV4ZUN2VmcvekczS1pUOTZxUFJEREZWS0pPK0R3NGxyTFVU?=
 =?utf-8?B?V0trdHJUMWd6U0VTQUpPa3N6RXpRYVlHYUMzNmFYYjlsZ3hEak5CZXJOTjd3?=
 =?utf-8?B?NG04Z1d1Z3NBVS9RK3NHYXA5czZ0UTdZMnI2TEg1ZXZHdGFEbzJzMk8rL2pH?=
 =?utf-8?B?SUFaazU3SzhiTnpNY2NzcmdQVWFhbjlBNmxaVVlVeU9EbDdWSTV1ZWpxK2lB?=
 =?utf-8?B?ZndTSm1wamMvNzZjSVZpbUtFWnlVbyt4VkloQzllMHpjazR3QjZnZW52cVFv?=
 =?utf-8?B?cFNIZCtzeHM1VVZVMnZEM3pUV2ZUL2NOY0R1VGM2cVhLWTZwUnRjMk5scDlY?=
 =?utf-8?B?ckdyN2g4RmU4VlVHVklXd1RHcHlITkordS9xcXlWWXhueEVheDluZkcyL3hv?=
 =?utf-8?B?bkR5R0VMbGpFa1RBVHI5cVNNMHFPclM2ejVqNXhvdmE2eWI3SjBWWUljZmNx?=
 =?utf-8?Q?r0mM2wB/Ucoqnr8XPqbiwTzfWENRO/Jk9FA1N7/ZtIRY?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f604d366-ba47-4835-47dc-08daf3d1e1b1
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 12:46:39.1083
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oLd/8eExc7kgXRBumkdY9rDOOcq13KGgrlKNVGlX2kDv1PLACqI8aNwfWxsSF0Z2PSsddHmNM6EtlE06DtRbTLaFB+M9B7U+Go/PnfwtF2V6olOsDicNLxL7EsTtchrL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR01MB2571
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11-01-2023 05:09 pm, Marc Zyngier wrote:
> On 2023-01-11 08:46, Ganapatrao Kulkarni wrote:
>> On 11-01-2023 03:24 am, Marc Zyngier wrote:
>>> On Tue, 10 Jan 2023 12:17:20 +0000,
>>> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>>>
>>>> I am currently working around this with "nohlt" kernel param to
>>>> NestedVM. Any suggestions to handle/fix this case/issue and avoid the
>>>> slowness of booting of NestedVM with more cores?
>>>>
>>>> Note: Guest-Hypervisor and NestedVM are using default kernel installed
>>>> using Fedora 36 iso.
>>>
>>> Despite what I said earlier, I have a vague idea here, thanks to the
>>> interesting call traces that you provided (this is really awesome work
>>> BTW, given how hard it is to trace things across 3 different kernels).
>>>
>>> We can slightly limit the impact of the prepare/finish sequence if the
>>> guest hypervisor only accesses the active registers for SGIs/PPIs on
>>> the vcpu that owns them, forbidding any cross-CPU-to-redistributor
>>> access.
>>>
>>> Something along these lines, which is only boot-tested. Let me know
>>> how this fares for you.
>>>
>>> Thanks,
>>>
>>>     M.
>>>
>>> diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c 
>>> b/arch/arm64/kvm/vgic/vgic-mmio.c
>>> index b32d434c1d4a..1cca45be5335 100644
>>> --- a/arch/arm64/kvm/vgic/vgic-mmio.c
>>> +++ b/arch/arm64/kvm/vgic/vgic-mmio.c
>>> @@ -473,9 +473,10 @@ int vgic_uaccess_write_cpending(struct kvm_vcpu 
>>> *vcpu,
>>>    * active state can be overwritten when the VCPU's state is synced 
>>> coming back
>>>    * from the guest.
>>>    *
>>> - * For shared interrupts as well as GICv3 private interrupts, we 
>>> have to
>>> - * stop all the VCPUs because interrupts can be migrated while we 
>>> don't hold
>>> - * the IRQ locks and we don't want to be chasing moving targets.
>>> + * For shared interrupts as well as GICv3 private interrupts 
>>> accessed from the
>>> + * non-owning CPU, we have to stop all the VCPUs because interrupts 
>>> can be
>>> + * migrated while we don't hold the IRQ locks and we don't want to 
>>> be chasing
>>> + * moving targets.
>>>    *
>>>    * For GICv2 private interrupts we don't have to do anything because
>>>    * userspace accesses to the VGIC state already require all VCPUs 
>>> to be
>>> @@ -484,7 +485,8 @@ int vgic_uaccess_write_cpending(struct kvm_vcpu 
>>> *vcpu,
>>>    */
>>>   static void vgic_access_active_prepare(struct kvm_vcpu *vcpu, u32 
>>> intid)
>>>   {
>>> -    if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3 ||
>>> +    if ((vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3 &&
>>> +         vcpu == kvm_get_running_vcpu()) ||
>>
>> Thanks Marc for the patch!
>>
>> I think, you mean not equal to?
>> +           vcpu != kvm_get_running_vcpu()) ||
> 
> Yeah, exactly. I woke up this morning realising this patch was
> *almost* right. Don't write patches like this after a long day
> at work...
> 
>> With the change to not-equal, the issue is fixed and I could see the
>> NestedVM booting is pretty fast with higher number of cores as well.
> 
> Good, thanks for testing it. I'll roll up an actual patch for that
> and stick it in the monster queue.

Thanks, Please pull patch 3/3 also to nv-6.2 tree along with this patch. 
I will move my setup to nv-6.2 once these patches are in.

> 
> Cheers,
> 
>         M.


Thanks,
Ganapat
