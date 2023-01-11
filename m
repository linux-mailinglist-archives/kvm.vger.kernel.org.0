Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8F87665674
	for <lists+kvm@lfdr.de>; Wed, 11 Jan 2023 09:49:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236094AbjAKIt2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Jan 2023 03:49:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232515AbjAKItJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Jan 2023 03:49:09 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2106.outbound.protection.outlook.com [40.107.100.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 162C5D133
        for <kvm@vger.kernel.org>; Wed, 11 Jan 2023 00:49:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mMthE0XWACTmEdBS/6rCIih1XZFz8FaW8EMY4tXQZYrIVlLguC5pfjfPMvDYHIsLDkX/ZC4+ud42BrTy4Rno7P2GB4yteFV02EPs+yMPLL7OeSoj0sQlfhKDtYQsbiJnQDzQ5CUJT37OX7xZz2REIu2inu76L7jPPt9NyREn64PzESU59FEjK/iooLjs09iNw2BtcykWLThsYhJCqSJA7LEXDkxQmN2myJ+SkWIS1SjTS/yiIT1WYd2xyeln7I9tIeomFESemE2nARpWPatyEaw2CJ9IbiffvruxqeKzgPpA4NMFg+oOR08IzPwUteblhO5vNszj3VxKGtBm0186lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XFjEiL+rZ23ym2OvVi1W3m1sRu9ohKYnUMUNxA8M8xU=;
 b=f2w/Mow8ivl5PwpsVxXmCWtyKvhT0vor6XlTmN10G1PKoKt33Dqo1ZSINPMsTyKVAA/oWDtGTnRIaNyo9lpDVpbQVX7JUbCUUmsAIo6bSryOc11a3GDXouf6OLM/9PcMxriCr/w2F8ELtcGv0mT/f12bnw5ysKvkvnN7m5WjvpX8I7RqlEPSmK5kaCv6pvYgX+uJ3iuk5n4hBVxjt3t55ODCW5NZ4TexalKjOGDI1sbXN6dd0m72yqATST2eBU2VlElRqLNtc+Q8rL8ZCd1Bxxqib9RDhZVr36bqX3AjF+RzujuVg0WwIWeoJfzzTOLZU2AlSG4qFLBpjY0mvZTlgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=os.amperecomputing.com; dmarc=pass action=none
 header.from=os.amperecomputing.com; dkim=pass
 header.d=os.amperecomputing.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=os.amperecomputing.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XFjEiL+rZ23ym2OvVi1W3m1sRu9ohKYnUMUNxA8M8xU=;
 b=LHsyHNnwspeSsjmtM+EHr2MkYQ4YQJP2jGNArEZb3hlFNQ9B8XwiNPQrPnsaSBYE6ffonJkza+/wEBLfQ+25ZQvobUwaqCjog7QgZgOX/GRDeM3UY7jWXqsw0K/lmEDyLJJwtWcLB34zMnUqk+Oc6fvyreQ/tc1BqBGzXUmAXUU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=os.amperecomputing.com;
Received: from DM8PR01MB6824.prod.exchangelabs.com (2603:10b6:8:23::24) by
 BN6PR0101MB3170.prod.exchangelabs.com (2603:10b6:405:31::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6002.13; Wed, 11 Jan 2023 08:49:05 +0000
Received: from DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::6b5b:1242:818c:e70d]) by DM8PR01MB6824.prod.exchangelabs.com
 ([fe80::6b5b:1242:818c:e70d%6]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 08:49:05 +0000
Message-ID: <b8928355-9448-a6b3-1be8-05d29ea6f121@os.amperecomputing.com>
Date:   Wed, 11 Jan 2023 14:18:55 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 0/3] KVM: arm64: nv: Fixes for Nested Virtualization
 issues
Content-Language: en-US
From:   Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     catalin.marinas@arm.com, will@kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, scott@os.amperecomputing.com,
        Darren Hart <darren@os.amperecomputing.com>
References: <20220824060304.21128-1-gankulkarni@os.amperecomputing.com>
 <6171dc7c-5d83-d378-db9e-d94f27afe43a@os.amperecomputing.com>
 <87o7r6dpi8.wl-maz@kernel.org>
 <4d952300-0681-41ff-b416-38fbae4ebea6@os.amperecomputing.com>
In-Reply-To: <4d952300-0681-41ff-b416-38fbae4ebea6@os.amperecomputing.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR06CA0230.apcprd06.prod.outlook.com
 (2603:1096:4:ac::14) To DM8PR01MB6824.prod.exchangelabs.com
 (2603:10b6:8:23::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR01MB6824:EE_|BN6PR0101MB3170:EE_
X-MS-Office365-Filtering-Correlation-Id: 528aca17-0c56-4a2b-6e86-08daf3b0b1e0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2cGvaPruEFi0KsHm5gTFm4toHpLk0jqtcUQ0qGvmC86Dv8utjKJXgMx5LK4EEGrCfHYsPDl8HMrGjgJtZUu5guas13QGAvtWmkYjiu8VX3A+WAwOPLtaaxQSU42jnmLDjqjpalagKFvZyshOloOP14qPN1LsgEZ0YVXr9t3xb4143GbqcAGRXh3X6KK5CzBYma0uJugbzFAGZkOa/Z2M/ZtbfDDGqQtF1n9JsXw8Z8UoPfKZqocbLgz7akxQjHQPqA4EIarVNTvncqmeDxN/AUgR389LVLWcqBHPddOoM5Ivgv+zWJMAmQkdS04gsGZpwCCtFMVINXg6hsv8zaKai9TVUyISjQ2nrQauYSQIYVtax/bcA71Th+jWvF1KPmToV3TCz8WF4pVdAQkpI1kfcosmqFCKuW89N7wAfeSa+UdW/zzGV6B4ZFTEWkBJgidVZceOlDSv40iiDyf+jq3mFeyr6r9qeHTgy4msLrjC6IZNcjZPjL83nJAs6lWpqQFiwHJOgJDqZSjdWbDy5RPVLkeAgQC0yXRkr1Hf9P6EXob9dKV5izmxBgXxxYuot0CtxXKMFBUiw6MLl9tv4Hdf2RFm/M+ApiJ+NZgvVZoCDHD4N2ny0nAjDhIOc54XDbLzy0mnq/RHyjhe0vq9IF48V+m7OE1PIoypv0HHcK+q86Azit3BET+p1TcIHlm0R6H3zzyOVcoyZ+9VP+UzJiThrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR01MB6824.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39850400004)(136003)(396003)(376002)(346002)(451199015)(31686004)(107886003)(6666004)(8936002)(41300700001)(66556008)(66476007)(66946007)(6916009)(8676002)(4326008)(316002)(2616005)(2906002)(5660300002)(31696002)(6486002)(86362001)(478600001)(186003)(26005)(53546011)(6512007)(6506007)(83380400001)(38100700002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QmE3OWEvenV1SmtDeUVNS0gycUpoRlY5RWRIbGV6ZG1GZlAyUkNmams1UGs4?=
 =?utf-8?B?WVBNdUpldVpadkFNSEsyc1l3TisxbGQ1WEo1VGVqeXBWbW9VWUlDdDhPY1c4?=
 =?utf-8?B?TUdabEZlYUJ3K2ZodEJ4WEd2WVdzbTZJeDdPT2JRRWc4cDZEY25CQ3RjQmQ1?=
 =?utf-8?B?TW84NEF3T1V6QmZGL0p1TXh3QmxnTzdVclhFelg3VUZndm5ZUktRclNOZisz?=
 =?utf-8?B?c0FzTW50V3N5NHpSYWRvNW1QM1pkdmRzaUh2MnJ1ZjkvbjFWRG1icDhQYVFz?=
 =?utf-8?B?UHBzZUlHdGZ6MmxDQVlRMWt3ajlrWWpBUG5xdzc4enEybTMyUGQySWJ5dm9J?=
 =?utf-8?B?M1VudnRTcjFkUndxWkFYY29pT2s5OG1EdVNmZ0hPK0FPYkJVcTBiUTkvS1dm?=
 =?utf-8?B?NlRSQkxhdkY0YmoyRVJrM0hQVzA4RG0wbW1MWW1nTmRuaHZUQjA4SmIzU3l3?=
 =?utf-8?B?R0VFclIvN3dYMXB5ZHZBZDJncUplenhoamxLN1VOY3lYSGFYUzZHSGNSZ3cr?=
 =?utf-8?B?elk4WXJUOWtRSVo2RkFWbFF2ejlKYlQvTU9kdEIwQkt3UTdpdTFWaG5uTTNj?=
 =?utf-8?B?NlRvYlVRN3JqZCt3eHh1bVVHTTJlY2szSHdHZkVzMmhLNHVhWDRzQ2E0aVlG?=
 =?utf-8?B?aU5pT0E4UHQ0SEFkL2dsNlhXSTdxS3ZqQVFaZWY4Z3lTRHBnZGtjS0V1M1hm?=
 =?utf-8?B?MHNKbkx1Y1hJcWNGTFJranJxd0tlaGtPZkpwMUpmdklzSkYyQkZGaS9ocWVI?=
 =?utf-8?B?Z3ZtNktxRkZ2KzVzampqUEFZeUR2VnhXMkRLcHkzTVc3STZOeUMvc2VjbGpO?=
 =?utf-8?B?NHF5SFpMS3B0UnBSc1JvYk9UM0hrRXlGMjlzbVdUV2hRSEFhbTJ5dmU2Z0tB?=
 =?utf-8?B?eERoTzQvQ1ZzRHRoRFgyVzBuUFJDeVVEZmlmOTZlcmd3a1pOS0xjL0RoUDhX?=
 =?utf-8?B?YmN0TlBaTEJVem9VbSt4MmJ2TWtRdFUzMXNwSlhVKzZ6WFEwU2pOYmR2YnVJ?=
 =?utf-8?B?R3o0MUVab3cra09UME1qVmZhanYvdFBDOHdCSHFyZUFOdXJHWXowcHpYbTFa?=
 =?utf-8?B?ZTVWd1h4N1NIKzFBZXlTU3NkQVBKbUF2UmJnV3Z0V213azBxV1UzeHI1STFK?=
 =?utf-8?B?UEpJMjgySnpFNUI1bkNGeTdVL2NoaFp4MjZmUWQxV1FLcGg3RGFOeWxPMmtV?=
 =?utf-8?B?WFNSK0RhZW9WZUJuaWNpNEhHTUx1R0psR25WMEdNaEhHYXlrdlBpNnNYT3F3?=
 =?utf-8?B?VWp4bVRrYjExcjlNK1ZxOVlwK0dYakx6eWdiakV3Z3lYanJxWjN0WkMydlAx?=
 =?utf-8?B?YlBqc1VZSDRzOVVWS25Oc3NVMy9qN0hmYVdWakU5TUtTbk9nV0w2SzhBc2JN?=
 =?utf-8?B?VVIvRzBOdm1GQmc0QmpzL0hMb3IvQXEzS01WRGpJdjN5WFZhUmZ5aGM4dUVD?=
 =?utf-8?B?QTZUc0RtT3hEVW1ZdmdjMWttaHE5K2cxc3JMZ2xvMFpoa2l4eTNHeHNNalFq?=
 =?utf-8?B?QkNQZWtXVGdsS0I5bWFrbW1LQ3BnMEp5WVcyZ0w1N3dCR0lpQU5QMnZTYkJ5?=
 =?utf-8?B?Wi9HUkdVVUx6dU9LaUdqYmlpSllBNHVCb1B1UHF6eU1ma3pqcGNJRUx2SjdY?=
 =?utf-8?B?UWhtWG5yTk5EUWgvQy9wZjlGa1NuUlNzdXdvcjAwRE16M1VUbnExUkc2Nm9p?=
 =?utf-8?B?WktpWVdwNlpnSWRnS0g4U0JWWE85NlRsYzJmRlliNjZDaDdpTXZuKytEMzI3?=
 =?utf-8?B?S2l6c1E2ajlYWHJjUWVkbU1BRkJNQitwUTkvWGJhSjkyV3d1eEQyUnVYdTE3?=
 =?utf-8?B?RkI0OSs1UkRQeW4vRjZKMGc1Y3VBZHRhTyt5SVB3ZDBHOW9lQVdHbzNRT0dU?=
 =?utf-8?B?aWxVVlQ0Z05MaklEOS9WUHZ0S2lsZGFCTis0NVZ5NktiYnp1SFpYZ3lOdFZi?=
 =?utf-8?B?cHVUWHBnWnFFTE1PZ3ZFU2kvbWgxRFVKWHorN0IzcUNMUjBNYUF5WE0vQzZ1?=
 =?utf-8?B?aEZub0w4cVNhenpSZjZxZ0s1UVVmelR2c2ZUS0tzSlVjclBjMnhUUFZnVm1y?=
 =?utf-8?B?QW04OVBUeCtkY2pmQXVBR2NlOFZtT1MrVlhLM2V3alBLZGxnSWVialU2WkRn?=
 =?utf-8?B?OVpYSHNmcUUwTzR3MHV6M2plMVp3dUdDWExhLzVNN2NrdlM2UXZHa1hkaUlu?=
 =?utf-8?Q?PAP6ZJsQSowM9ny3bcYO5kE=3D?=
X-OriginatorOrg: os.amperecomputing.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 528aca17-0c56-4a2b-6e86-08daf3b0b1e0
X-MS-Exchange-CrossTenant-AuthSource: DM8PR01MB6824.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jan 2023 08:49:05.1821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3bc2b170-fd94-476d-b0ce-4229bdc904a7
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 57tev0IPDdf0sy2yoDY8qqMjcTAFk74D9V1IKVqBfN2iMCbe66BiH0jPkzemdTfB2dwMYyGU0a5dwv71aTVbWNsSIHySUt4G/TQJOTBmK83iyzL36oThJnTqD+6LLR+z
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



On 11-01-2023 02:16 pm, Ganapatrao Kulkarni wrote:
> 
> 
> On 11-01-2023 03:24 am, Marc Zyngier wrote:
>> On Tue, 10 Jan 2023 12:17:20 +0000,
>> Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com> wrote:
>>>
>>> I am currently working around this with "nohlt" kernel param to
>>> NestedVM. Any suggestions to handle/fix this case/issue and avoid the
>>> slowness of booting of NestedVM with more cores?
>>>
>>> Note: Guest-Hypervisor and NestedVM are using default kernel installed
>>> using Fedora 36 iso.
>>
>> Despite what I said earlier, I have a vague idea here, thanks to the
>> interesting call traces that you provided (this is really awesome work
>> BTW, given how hard it is to trace things across 3 different kernels).
>>
>> We can slightly limit the impact of the prepare/finish sequence if the
>> guest hypervisor only accesses the active registers for SGIs/PPIs on
>> the vcpu that owns them, forbidding any cross-CPU-to-redistributor
>> access.
>>
>> Something along these lines, which is only boot-tested. Let me know
>> how this fares for you.
>>
>> Thanks,
>>
>>     M.
>>
>> diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c 
>> b/arch/arm64/kvm/vgic/vgic-mmio.c
>> index b32d434c1d4a..1cca45be5335 100644
>> --- a/arch/arm64/kvm/vgic/vgic-mmio.c
>> +++ b/arch/arm64/kvm/vgic/vgic-mmio.c
>> @@ -473,9 +473,10 @@ int vgic_uaccess_write_cpending(struct kvm_vcpu 
>> *vcpu,
>>    * active state can be overwritten when the VCPU's state is synced 
>> coming back
>>    * from the guest.
>>    *
>> - * For shared interrupts as well as GICv3 private interrupts, we have to
>> - * stop all the VCPUs because interrupts can be migrated while we 
>> don't hold
>> - * the IRQ locks and we don't want to be chasing moving targets.
>> + * For shared interrupts as well as GICv3 private interrupts accessed 
>> from the
>> + * non-owning CPU, we have to stop all the VCPUs because interrupts 
>> can be
>> + * migrated while we don't hold the IRQ locks and we don't want to be 
>> chasing
>> + * moving targets.
>>    *
>>    * For GICv2 private interrupts we don't have to do anything because
>>    * userspace accesses to the VGIC state already require all VCPUs to be
>> @@ -484,7 +485,8 @@ int vgic_uaccess_write_cpending(struct kvm_vcpu 
>> *vcpu,
>>    */
>>   static void vgic_access_active_prepare(struct kvm_vcpu *vcpu, u32 
>> intid)
>>   {
>> -    if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3 ||
>> +    if ((vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3 &&
>> +         vcpu == kvm_get_running_vcpu()) ||
> 
> Thanks Marc for the patch!
> 
> I think, you mean not equal to?
Sorry, I did not see your follow up email.

> +           vcpu != kvm_get_running_vcpu()) ||
> 
> With the change to not-equal, the issue is fixed and I could see the 
> NestedVM booting is pretty fast with higher number of cores as well.
> 
>>           intid >= VGIC_NR_PRIVATE_IRQS)
>>           kvm_arm_halt_guest(vcpu->kvm);
>>   }
>> @@ -492,7 +494,8 @@ static void vgic_access_active_prepare(struct 
>> kvm_vcpu *vcpu, u32 intid)
>>   /* See vgic_access_active_prepare */
>>   static void vgic_access_active_finish(struct kvm_vcpu *vcpu, u32 intid)
>>   {
>> -    if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3 ||
>> +    if ((vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3 &&
>> +         vcpu == kvm_get_running_vcpu()) ||
> 
> Same, not equal to.
>>           intid >= VGIC_NR_PRIVATE_IRQS)
>>           kvm_arm_resume_guest(vcpu->kvm);
>>   }
>>
> 
> 
> Thanks,
> Ganapat
