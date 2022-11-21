Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 831E8631837
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 02:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbiKUBmZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 20 Nov 2022 20:42:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiKUBmY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 20 Nov 2022 20:42:24 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 960DF2D749
        for <kvm@vger.kernel.org>; Sun, 20 Nov 2022 17:42:23 -0800 (PST)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NFqr14l4dzmW5d;
        Mon, 21 Nov 2022 09:41:53 +0800 (CST)
Received: from [10.174.187.128] (10.174.187.128) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 09:42:21 +0800
Subject: Re: [RFC PATCH 3/3] KVM: Obey kvm.halt_poll_ns in VMs not using
 KVM_CAP_HALT_POLL
To:     David Matlack <dmatlack@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Jon Cargille <jcargill@google.com>,
        Jim Mattson <jmattson@google.com>, <kvm@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
        <wangyuan38@huawei.com>
References: <20221117001657.1067231-1-dmatlack@google.com>
 <20221117001657.1067231-4-dmatlack@google.com>
 <97ccc949-254e-879d-9206-613b328c271d@huawei.com>
 <CALzav=fY6-C_Y1+8B0_hQM9X8L-SA2cEULgcp24-6f_xVLgkqw@mail.gmail.com>
 <CALzav=dxO9uN63vuhdmja5s5y1PLUOA36KdCVwVWWALgCjBpSw@mail.gmail.com>
From:   "wangyanan (Y)" <wangyanan55@huawei.com>
Message-ID: <1d4c8e5a-ea56-de93-67d0-0fa47116ad4c@huawei.com>
Date:   Mon, 21 Nov 2022 09:42:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <CALzav=dxO9uN63vuhdmja5s5y1PLUOA36KdCVwVWWALgCjBpSw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.187.128]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500023.china.huawei.com (7.185.36.83)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022/11/19 9:25, David Matlack wrote:
> On Fri, Nov 18, 2022 at 8:58 AM David Matlack <dmatlack@google.com> wrote:
>> On Fri, Nov 18, 2022 at 12:28 AM wangyanan (Y) <wangyanan55@huawei.com> wrote:
>>> Hi David,
>>>
>>> On 2022/11/17 8:16, David Matlack wrote:
>>>> Obey kvm.halt_poll_ns in VMs not using KVM_CAP_HALT_POLL on every halt,
>>>> rather than just sampling the module parameter when the VM is first
>>> s/first/firstly
>>>> created. This restore the original behavior of kvm.halt_poll_ns for VMs
>>> s/restore/restores
>>>> that have not opted into KVM_CAP_HALT_POLL.
>>>>
>>>> Notably, this change restores the ability for admins to disable or
>>>> change the maximum halt-polling time system wide for VMs not using
>>>> KVM_CAP_HALT_POLL.
>>> Should we add more detailed comments about relationship
>>> between KVM_CAP_HALT_POLL and kvm.halt_poll_ns in
>>> Documentation/virt/kvm/api.rst? Something like:
>>> "once KVM_CAP_HALT_POLL is used for a target VM, it will
>>> completely ignores any future changes to kvm.halt_poll_ns..."
>> Yes we should.
>>
>> I will do some testing on this series today and then resend the series
>> as a non-RFC with the Documentation changes.
>>
>> Thanks for the reviews.
> Initial testing looks good but I did not have time to finish due to a
> bug in how our VMM is currently using KVM_CAP_HALT_POLL. I will be out
> all next week so I'll pick this up the week after.
OK, thanks.

Yanan
>>>> Reported-by: Christian Borntraeger <borntraeger@de.ibm.com>
>>>> Fixes: acd05785e48c ("kvm: add capability for halt polling")
>>>> Signed-off-by: David Matlack <dmatlack@google.com>
>>>> ---
>>>>    include/linux/kvm_host.h |  1 +
>>>>    virt/kvm/kvm_main.c      | 27 ++++++++++++++++++++++++---
>>>>    2 files changed, 25 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>>>> index e6e66c5e56f2..253ad055b6ad 100644
>>>> --- a/include/linux/kvm_host.h
>>>> +++ b/include/linux/kvm_host.h
>>>> @@ -788,6 +788,7 @@ struct kvm {
>>>>        struct srcu_struct srcu;
>>>>        struct srcu_struct irq_srcu;
>>>>        pid_t userspace_pid;
>>>> +     bool override_halt_poll_ns;
>>>>        unsigned int max_halt_poll_ns;
>>>>        u32 dirty_ring_size;
>>>>        bool vm_bugged;
>>>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>>>> index 78caf19608eb..7f73ce99bd0e 100644
>>>> --- a/virt/kvm/kvm_main.c
>>>> +++ b/virt/kvm/kvm_main.c
>>>> @@ -1198,8 +1198,6 @@ static struct kvm *kvm_create_vm(unsigned long type, const char *fdname)
>>>>                        goto out_err_no_arch_destroy_vm;
>>>>        }
>>>>
>>>> -     kvm->max_halt_poll_ns = halt_poll_ns;
>>>> -
>>>>        r = kvm_arch_init_vm(kvm, type);
>>>>        if (r)
>>>>                goto out_err_no_arch_destroy_vm;
>>>> @@ -3490,7 +3488,20 @@ static inline void update_halt_poll_stats(struct kvm_vcpu *vcpu, ktime_t start,
>>>>
>>>>    static unsigned int kvm_vcpu_max_halt_poll_ns(struct kvm_vcpu *vcpu)
>>>>    {
>>>> -     return READ_ONCE(vcpu->kvm->max_halt_poll_ns);
>>>> +     struct kvm *kvm = vcpu->kvm;
>>>> +
>>>> +     if (kvm->override_halt_poll_ns) {
>>>> +             /*
>>>> +              * Ensure kvm->max_halt_poll_ns is not read before
>>>> +              * kvm->override_halt_poll_ns.
>>>> +              *
>>>> +              * Pairs with the smp_wmb() when enabling KVM_CAP_HALT_POLL.
>>>> +              */
>>>> +             smp_rmb();
>>>> +             return READ_ONCE(kvm->max_halt_poll_ns);
>>>> +     }
>>>> +
>>>> +     return READ_ONCE(halt_poll_ns);
>>>>    }
>>>>
>>>>    /*
>>>> @@ -4600,6 +4611,16 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
>>>>                        return -EINVAL;
>>>>
>>>>                kvm->max_halt_poll_ns = cap->args[0];
>>>> +
>>>> +             /*
>>>> +              * Ensure kvm->override_halt_poll_ns does not become visible
>>>> +              * before kvm->max_halt_poll_ns.
>>>> +              *
>>>> +              * Pairs with the smp_rmb() in kvm_vcpu_max_halt_poll_ns().
>>>> +              */
>>>> +             smp_wmb();
>>>> +             kvm->override_halt_poll_ns = true;
>>>> +
>>>>                return 0;
>>>>        }
>>>>        case KVM_CAP_DIRTY_LOG_RING:
>>> Looks good to me:
>>> Reviewed-by: Yanan Wang <wangyanan55@huawei.com>
>>>
>>> Thanks,
>>> Yanan
> .

