Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3944D3FC7
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 04:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239188AbiCJDnm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 22:43:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbiCJDnl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 22:43:41 -0500
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69485CC50D;
        Wed,  9 Mar 2022 19:42:40 -0800 (PST)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4KDZYD3SlWz9sVT;
        Thu, 10 Mar 2022 11:38:56 +0800 (CST)
Received: from dggpemm500003.china.huawei.com (7.185.36.56) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Mar 2022 11:42:38 +0800
Received: from [10.174.185.129] (10.174.185.129) by
 dggpemm500003.china.huawei.com (7.185.36.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Mar 2022 11:42:37 +0800
Message-ID: <b4c9648c-1f46-6dc2-3bec-6354db7f2c76@huawei.com>
Date:   Thu, 10 Mar 2022 11:42:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RESEND PATCH] KVM: x86/mmu: make apf token non-zero to fix bug
Content-Language: en-US
To:     Xinlong Lin <linxl3@wangsu.com>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
        <x86@kernel.org>
CC:     <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <wanpengli@tencent.com>, <jmattson@google.com>, <joro@8bytes.org>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <wangzhigang17@huawei.com>
References: <20220222031239.1076682-1-zhangliang5@huawei.com>
 <69d9a292-c140-ac6c-6afb-df4e383e2847@wangsu.com>
From:   "zhangliang (AG)" <zhangliang5@huawei.com>
In-Reply-To: <69d9a292-c140-ac6c-6afb-df4e383e2847@wangsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.185.129]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500003.china.huawei.com (7.185.36.56)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

No. Because '(++vcpu->arch.apf.id << 12)' may also produce zero value.

On 2022/3/10 11:34, Xinlong Lin wrote:
> 
> 
> On 2022/2/22 11:12, Liang Zhang wrote:
>> In current async pagefault logic, when a page is ready, KVM relies on
>> kvm_arch_can_dequeue_async_page_present() to determine whether to deliver
>> a READY event to the Guest. This function test token value of struct
>> kvm_vcpu_pv_apf_data, which must be reset to zero by Guest kernel when a
>> READY event is finished by Guest. If value is zero meaning that a READY
>> event is done, so the KVM can deliver another.
>> But the kvm_arch_setup_async_pf() may produce a valid token with zero
>> value, which is confused with previous mention and may lead the loss of
>> this READY event.
>>
>> This bug may cause task blocked forever in Guest:
>>   INFO: task stress:7532 blocked for more than 1254 seconds.
>>         Not tainted 5.10.0 #16
>>   "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>   task:stress          state:D stack:    0 pid: 7532 ppid:  1409
>>   flags:0x00000080
>>   Call Trace:
>>    __schedule+0x1e7/0x650
>>    schedule+0x46/0xb0
>>    kvm_async_pf_task_wait_schedule+0xad/0xe0
>>    ? exit_to_user_mode_prepare+0x60/0x70
>>    __kvm_handle_async_pf+0x4f/0xb0
>>    ? asm_exc_page_fault+0x8/0x30
>>    exc_page_fault+0x6f/0x110
>>    ? asm_exc_page_fault+0x8/0x30
>>    asm_exc_page_fault+0x1e/0x30
>>   RIP: 0033:0x402d00
>>   RSP: 002b:00007ffd31912500 EFLAGS: 00010206
>>   RAX: 0000000000071000 RBX: ffffffffffffffff RCX: 00000000021a32b0
>>   RDX: 000000000007d011 RSI: 000000000007d000 RDI: 00000000021262b0
>>   RBP: 00000000021262b0 R08: 0000000000000003 R09: 0000000000000086
>>   R10: 00000000000000eb R11: 00007fefbdf2baa0 R12: 0000000000000000
>>   R13: 0000000000000002 R14: 000000000007d000 R15: 0000000000001000
>>
>> Signed-off-by: Liang Zhang <zhangliang5@huawei.com>
>> ---
>>   arch/x86/kvm/mmu/mmu.c | 13 ++++++++++++-
>>   1 file changed, 12 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
>> index 593093b52395..8e24f73bf60b 100644
>> --- a/arch/x86/kvm/mmu/mmu.c
>> +++ b/arch/x86/kvm/mmu/mmu.c
>> @@ -3889,12 +3889,23 @@ static void shadow_page_table_clear_flood(struct kvm_vcpu *vcpu, gva_t addr)
>>       walk_shadow_page_lockless_end(vcpu);
>>   }
>>   +static u32 alloc_apf_token(struct kvm_vcpu *vcpu)
>> +{
>> +    /* make sure the token value is not 0 */
>> +    u32 id = vcpu->arch.apf.id;
>> +
>> +    if (id << 12 == 0)
>> +        vcpu->arch.apf.id = 1;
>> +
>> +    return (vcpu->arch.apf.id++ << 12) | vcpu->vcpu_id;
>> +}
>> +
>>   static bool kvm_arch_setup_async_pf(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
>>                       gfn_t gfn)
>>   {
>>       struct kvm_arch_async_pf arch;
>>   -    arch.token = (vcpu->arch.apf.id++ << 12) | vcpu->vcpu_id;
> This patch is completely OK. But I have a question, can we simplify it to
> arch.token = (++vcpu->arch.apf.id << 12) | vcpu->vcpu_id;
>> +    arch.token = alloc_apf_token(vcpu);
>>       arch.gfn = gfn;
>>       arch.direct_map = vcpu->arch.mmu->direct_map;
>>       arch.cr3 = vcpu->arch.mmu->get_guest_pgd(vcpu);
> 
> .

-- 
Best Regards,
Liang Zhang
