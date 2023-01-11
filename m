Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1349066566F
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 09:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232120AbjAKIqz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 03:46:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231997AbjAKIqx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 03:46:53 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2098.outbound.protection.outlook.com [40.107.94.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9349ADF3C
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 00:46:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VbFAO0f6p5hQYyWmlU+UBHb0OZXaUs4E7G5utpBzlE9USuireX0C7MnhV8wDA8oQXNsCIILz2jroHrW5AdslUtUp78ZC9/TbNdFUfqH3p1nkOXJIKby70X5TaCOzLQNYssu/dtLlPvslPO2dQvv6xjnXeUxuxFro9vmSTT9WrPCEQt7d6u64yJhnbDWnhEGGS4n4VJsRoP3RVIYd4TfoN2wYRAIGXEM/jEJff9JiKetjFViz01Ft2jPDxHtkhTtHZSKs54scTseAByS3Bl6duXcSczCsMa965U9+iqs1YhATR2lqYfJR0pB9QBZ5SEnTE0cBrGIWR1ixlyacowBFxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EpIS/gAafYoDsH5YgF943ojJjftohLLkp9nj7SEQYmc=;
 b=f2PP+ieGWYWDka9vXSDeDB7BHwq4zJP816LjuaXQfzY2SE92O2NLXzWtg+rIGYAnyU+Vc8L0kOwANZXhTX83EA0VYn/Bkio0UNJgLCnu4WpguZx4JW8LO/KkZhdAdkXczbAzM0xRTUt1iWWPtCUwpZ6DyxD2d80u7qcw3TmdigT3K8v3If5bQjMaLk8UOrGeoyeqJhV7pqTTqzXxPmktmw7b2f8rx2zjmHn6XRIClIOFMqQ8wWRJhY0mRB/f7X9hkfXi6Q2gtxkN5NtTx8QyoZnH0WfcIYGbH+Y0DRFQXr5X2WcOOJlhQlpazLUeDQr79ME7xZDKhlmMvlO7JbP+AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EpIS/gAafYoDsH5YgF943ojJjftohLLkp9nj7SEQYmc=;
 b=klqbczXgpFGML/UMS5t2v29IKA5HGMhmcqOc4/0/dzuRe7dzme1ZDD5DxVmkFMLglaC6laPgUh36Y7Yw2kV/UCkx57wtNMQcod8HGoXyCmK6dqCqtMK+2C2zeGVdmgEXbFFq2hg/gHTyLJM6QwP2ViQ71JO1sUk3UruQphJa4RE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 BN6PR0101MB3170.prod.exchangelabs.com (2603:10b6:405:31::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13; Wed, 11 Jan 2023 08:46:48 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::6b5b:1242:818c:e70d]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::6b5b:1242:818c:e70d%6]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 08:46:48 +0000
Message-ID: <4d952300-0681-41ff-b416-38fbae4ebea6@os.amperecomputing.com>
Date:   Wed, 11 Jan 2023 14:16:37 +0530
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
From:   Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
In-Reply-To: <87o7r6dpi8.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR06CA0182.apcprd06.prod.outlook.com (2603:1096:4:1::14)
 To DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR01MB6824:EE_|BN6PR0101MB3170:EE_
X-MS-Office365-Filtering-Correlation-Id: e67f8fd5-c041-479d-c26b-08daf3b06043
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fJAn/XY0Mbd8honjB08Sbgqch2HLGIFOcv8aJaa6PWntDWoellk6mE+VPK2q1kp8cO2YVJFJzkqVgJUj+ShtgIvGUGn4bgjabx5vFAMfiNd+EVQLN2LetQqrLGq11+ikbD8Zx89oHCid9vqtm7S8K8BsqRG5z6/FzfpJe84+aUCpaP7jxDszEoOBBG6+hpe/07c38sVIHX3WoRe05NyMI6XzG7gco22mMWlNUNx37603BLxnBD1wgdt8rVOyy+3kSI9tu6ssGNHY/9VO0H4jz0EgB29xAtxlGO5spMcbkIkP6fVtAaGE9wi0t6RpDD+hgiTk6voiSbHRPupOxhv++udlz0ec1RguxQToMBplzxJyiVFRFbNEgwTdPEeTt3krDXaP6+VgxTcVJLmOrMiKGtswuvSaIR7W/lfQJt0t9AJtgdbKu64HfVOx2Qu0VeMXHnSlrkoQdrbEzM+QVc7dZlF9X9a/imA1HKzVjGX40JEslB79ssbyRQwBBwRdebvYjxTG5fkgDbkyTK5XQDDIJZ2fVofyhqXPkl3AqRk9IAGZa/9PbZ4c7MH/o9HfFmVN0GU1Mf4e5+9ry6EweC+AmMc0ROGfdzKQn+SVqN4T8zBYNGk6P3JQDa6CuR8S5/gc8O3syMQ7Lb0T/TwZs3vM9h+SkalUmq5Oz9iyzkKNTkMJOB5NyaHVs4IDxyM4MrRs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39850400004)(136003)(396003)(376002)(346002)(451199015)(31686004)(107886003)(6666004)(8936002)(41300700001)(66556008)(66476007)(66946007)(6916009)(8676002)(4326008)(316002)(2616005)(2906002)(5660300002)(31696002)(6486002)(86362001)(478600001)(186003)(26005)(53546011)(6512007)(6506007)(83380400001)(38100700002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dlNkQmd5MDdKRXlIei8yaGhtd0J5c2NrcmFHbmxqWlF2ZU5uT0xMdVdPME5Y?=
 =?utf-8?B?WXBjdFRObVVpZzl5Y1RRVzRNOGhycHlYRThIK1JXQk4yTUMrY0taZ0dvbTlo?=
 =?utf-8?B?cWd2VmxDSFV0TDRDbVhBa0EwZHBoZ2dXM08xQkhEaENBK29NWU5vWEhZa0Jo?=
 =?utf-8?B?cm1RSXhGckhnWVVaUGllVVF2TU54blhyeml2NE1tUjd1YTRBN0JWa1NvRlpB?=
 =?utf-8?B?SE5yemtsazR1Z1NRVXl5REE2WjBOOTBQV1hPQUYxTmNPOE44QW1zRGIrN05a?=
 =?utf-8?B?ZUVad0FEWW5zaHFNVTFkc01Da0ZCd3hEOEdzZUl4S3N5S1JuYUhXVWNqNnJP?=
 =?utf-8?B?U0lseXhhS0xwYU1hbW42N3puK0tJTkd2K1FJY2tqclc5bnZKbE5XQjlwZVE4?=
 =?utf-8?B?WE1nZ1YvQWdtZHE2REhhWWdHdDJxTmRwQmJ1T2pmT1JPU2JVakV3WjVOcEc0?=
 =?utf-8?B?WmMrUFNPZ1NPZmpNTUhKSko4eDJpRmF3VkZnVzdvMkVnSGpuazJmYklQMEht?=
 =?utf-8?B?MmxSL0NncHZXSk9CUlUvd1BoeDVNYnZ4bjhMdmZpUXhwMTV3ZFFNdncwQTMy?=
 =?utf-8?B?Q3ZWNTdoSEFpa3hUMC9kQ1JJaDJaTmlUZzhOTWRWS016cVN1QmM3aXdNUDlX?=
 =?utf-8?B?U3JzODVZQjFxSkFod1JBN3NyR3RyOEljT3VOWU81YWVlY05XdjNydmIrMTFu?=
 =?utf-8?B?VHd2NVRKSEZWUlZMWVBFRi9hbGV2VmZraENYSWxFb2t0dllUQnFUaFJta09S?=
 =?utf-8?B?bU4yWWxobENST2h6YmE5ZlY4eldrNm85NW14N3hydFBkUjdqS0FXWU9vWERL?=
 =?utf-8?B?czMwYjJvdFVybE5JV1c4akxUTjZWaXhxSitBenY4MkV5RXFiQ3ozN3UzdFJG?=
 =?utf-8?B?YWhiQ29wcDY1SVh1dzd6dmVTR1FhYzRLTmhEQjlsRktWU3dwNnViS0FCeTUz?=
 =?utf-8?B?YTVnbUo5T09UYUoyL1kzNnRmU0NnSG9jUEJsbXNsbkFTTC9sKytJU3VSOG0r?=
 =?utf-8?B?dG5WNWR1Q3NteWJXZjY3bzVOSVdyQjdWYUtraTVMdjdCOG1JeTgrcUxzdW1C?=
 =?utf-8?B?QjRIaU55MVhWVTQyU09JVG1McWVSalRnMklQQXBXNWVpS1cvZjlPak5Ibmp4?=
 =?utf-8?B?SWhnVExlWXZqcFBIMkM3TjNUTXBYQXk1N3JhRE1BZUZhejk3U2JEcFlZNTNH?=
 =?utf-8?B?N0JlS1ptS25QdWZ6OGdNY0ZtQzNjN3h0R1NjZjJqekFJTTdVWUMvTHAwd3V4?=
 =?utf-8?B?VTE1M3lFRFA1cVJnV3k1b0NmUWYxbkFESGh1VU1ZT0hKUWs5VHpvcW4vNDhp?=
 =?utf-8?B?WlpUYm5sai9xSTg0VWhGZGlQd3d3a0J4TEhyWnd3THk5STk5SWpwNjRSMXd4?=
 =?utf-8?B?UHFHb2pLME4vOXhKMmVQS3N2eDMyUFFnNmp0OE5IQmVkQTE1MTRrRFR4QkZh?=
 =?utf-8?B?L0VzbTBTQjAyNU9TY0FGL0FYdW1iM0gwblJROHJMOHZsWG5UOCtsTW5aWkRn?=
 =?utf-8?B?cWpMNWFsNDAyRWpSbFFFaWVrTmlYMU9BTi94VGlld3NlemMrQUlXQTZjN091?=
 =?utf-8?B?Q29mWnVmYWJVOVhJVmlTNEFtcTFNQjJuUGFlbFp6MHZnUDJHU252eG1oUlkz?=
 =?utf-8?B?ZDdaNERSQWlqS3IvMnRtK0xWc3dQWjVyTVJxWHdpeVkvS1RUUG5pRE9oTG1a?=
 =?utf-8?B?WEEzQUVITFpuRW1mWFJKYllobUs1M1JIRVA2QysvVmtjdUxZOGZDTVNFTm05?=
 =?utf-8?B?NnI1L29IUFZNZEh2YUlBcjVvWXJJM0V3YXNhckVRUWdleHpucyswb2trRTBP?=
 =?utf-8?B?T1hYaTFWYUxxZjlPS1M3RkpGZHZxS3FRRm9GK3NIRElsRHJBYllnSUhIbzV0?=
 =?utf-8?B?citRZWh0empPS1pYZjdtNnRsbXZkR1l5Q04zcHpod09rSnl6OGFVWHYvMzVM?=
 =?utf-8?B?NHk3eHJLbE0reUlPak5xSUU3Y2FMbFZaeHk3TFBIc3lxKzB1T3p3eDAwZFpk?=
 =?utf-8?B?clFkZHVzWEd6dDdmTmZ2ZGNNdWRZa0FpOFNVSHdUWEhZWFVmOGJITnF0Mjl1?=
 =?utf-8?B?WVlKeUtRMWF6Z2lhZ1o3bXFBak16Y1k4T2RrQkJRMlloaElSTFlXVldXaW01?=
 =?utf-8?B?bnQxMzFaUkxIT0c5OGZLTHlFS1BxWCthN01DakNwZmhtRWxsMVlzMklFN3RN?=
 =?utf-8?Q?wJCxswBgW6emDlKausojdV4=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e67f8fd5-c041-479d-c26b-08daf3b06043
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 08:46:48.2599
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YbJXHVXFjDjgbuTpQdefEfiJrv4YYbsxs+xYVJW00lw+sXvif3TJhnkV9S/3gbGu4lVwgI560rqFFhf2wkJz1Q+lUGRm0Exi1qhTfVj06g9bSZ4mQp+TynDLqIN0yr8f
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR0101MB3170
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11-01-2023 03:24 am, Marc Zyngier wrote:
> On Tue, 10 Jan 2023 12:17:20 +0000,
> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>
>> I am currently working around this with "nohlt" kernel param to
>> NestedVM. Any suggestions to handle/fix this case/issue and avoid the
>> slowness of booting of NestedVM with more cores?
>>
>> Note: Guest-Hypervisor and NestedVM are using default kernel installed
>> using Fedora 36 iso.
> 
> Despite what I said earlier, I have a vague idea here, thanks to the
> interesting call traces that you provided (this is really awesome work
> BTW, given how hard it is to trace things across 3 different kernels).
> 
> We can slightly limit the impact of the prepare/finish sequence if the
> guest hypervisor only accesses the active registers for SGIs/PPIs on
> the vcpu that owns them, forbidding any cross-CPU-to-redistributor
> access.
> 
> Something along these lines, which is only boot-tested. Let me know
> how this fares for you.
> 
> Thanks,
> 
> 	M.
> 
> diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmio.c
> index b32d434c1d4a..1cca45be5335 100644
> --- a/arch/arm64/kvm/vgic/vgic-mmio.c
> +++ b/arch/arm64/kvm/vgic/vgic-mmio.c
> @@ -473,9 +473,10 @@ int vgic_uaccess_write_cpending(struct kvm_vcpu *vcpu,
>    * active state can be overwritten when the VCPU's state is synced coming back
>    * from the guest.
>    *
> - * For shared interrupts as well as GICv3 private interrupts, we have to
> - * stop all the VCPUs because interrupts can be migrated while we don't hold
> - * the IRQ locks and we don't want to be chasing moving targets.
> + * For shared interrupts as well as GICv3 private interrupts accessed from the
> + * non-owning CPU, we have to stop all the VCPUs because interrupts can be
> + * migrated while we don't hold the IRQ locks and we don't want to be chasing
> + * moving targets.
>    *
>    * For GICv2 private interrupts we don't have to do anything because
>    * userspace accesses to the VGIC state already require all VCPUs to be
> @@ -484,7 +485,8 @@ int vgic_uaccess_write_cpending(struct kvm_vcpu *vcpu,
>    */
>   static void vgic_access_active_prepare(struct kvm_vcpu *vcpu, u32 intid)
>   {
> -	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3 ||
> +	if ((vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3 &&
> +	     vcpu == kvm_get_running_vcpu()) ||

Thanks Marc for the patch!

I think, you mean not equal to?
+           vcpu != kvm_get_running_vcpu()) ||

With the change to not-equal, the issue is fixed and I could see the 
NestedVM booting is pretty fast with higher number of cores as well.

>   	    intid >= VGIC_NR_PRIVATE_IRQS)
>   		kvm_arm_halt_guest(vcpu->kvm);
>   }
> @@ -492,7 +494,8 @@ static void vgic_access_active_prepare(struct kvm_vcpu *vcpu, u32 intid)
>   /* See vgic_access_active_prepare */
>   static void vgic_access_active_finish(struct kvm_vcpu *vcpu, u32 intid)
>   {
> -	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3 ||
> +	if ((vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3 &&
> +	     vcpu == kvm_get_running_vcpu()) ||

Same, not equal to.
>   	    intid >= VGIC_NR_PRIVATE_IRQS)
>   		kvm_arm_resume_guest(vcpu->kvm);
>   }
> 


Thanks,
Ganapat
