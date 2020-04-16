Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41A731ABBA0
	for <lists+kvm@lfdr.de>; Thu, 16 Apr 2020 10:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502873AbgDPIrd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Apr 2020 04:47:33 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:4019 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2502820AbgDPIqu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 16 Apr 2020 04:46:50 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R721e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07484;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=36;SR=0;TI=SMTPD_---0TvgT7ce_1587026733;
Received: from 30.27.118.45(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0TvgT7ce_1587026733)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 16 Apr 2020 16:45:35 +0800
Subject: Re: [PATCH v2] KVM: Optimize kvm_arch_vcpu_ioctl_run function
To:     Marc Zyngier <maz@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, tsbogend@alpha.franken.de, paulus@ozlabs.org,
        mpe@ellerman.id.au, benh@kernel.crashing.org,
        borntraeger@de.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        cohuck@redhat.com, heiko.carstens@de.ibm.com, gor@linux.ibm.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        james.morse@arm.com, julien.thierry.kdev@gmail.com,
        suzuki.poulose@arm.com, christoffer.dall@arm.com,
        peterx@redhat.com, thuth@redhat.com
References: <20200416051057.26526-1-tianjia.zhang@linux.alibaba.com>
 <878sivx67g.fsf@vitty.brq.redhat.com>
 <1000159f971a6fa3b5bd9e5871ce4d82@kernel.org>
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Message-ID: <8b92fb5b-5138-0695-fb90-6c36b8dfad00@linux.alibaba.com>
Date:   Thu, 16 Apr 2020 16:45:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1000159f971a6fa3b5bd9e5871ce4d82@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020/4/16 16:28, Marc Zyngier wrote:
> On 2020-04-16 08:03, Vitaly Kuznetsov wrote:
>> Tianjia Zhang <tianjia.zhang@linux.alibaba.com> writes:
>>
>>> In earlier versions of kvm, 'kvm_run' is an independent structure
>>> and is not included in the vcpu structure. At present, 'kvm_run'
>>> is already included in the vcpu structure, so the parameter
>>> 'kvm_run' is redundant.
>>>
>>> This patch simplify the function definition, removes the extra
>>> 'kvm_run' parameter, and extract it from the 'kvm_vcpu' structure
>>> if necessary.
>>>
>>> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
>>> ---
>>>
>>> v2 change:
>>>   remove 'kvm_run' parameter and extract it from 'kvm_vcpu'
>>>
>>>  arch/mips/kvm/mips.c       |  3 ++-
>>>  arch/powerpc/kvm/powerpc.c |  3 ++-
>>>  arch/s390/kvm/kvm-s390.c   |  3 ++-
>>>  arch/x86/kvm/x86.c         | 11 ++++++-----
>>>  include/linux/kvm_host.h   |  2 +-
>>>  virt/kvm/arm/arm.c         |  6 +++---
>>>  virt/kvm/kvm_main.c        |  2 +-
>>>  7 files changed, 17 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
>>> index 8f05dd0a0f4e..ec24adf4857e 100644
>>> --- a/arch/mips/kvm/mips.c
>>> +++ b/arch/mips/kvm/mips.c
>>> @@ -439,8 +439,9 @@ int kvm_arch_vcpu_ioctl_set_guest_debug(struct 
>>> kvm_vcpu *vcpu,
>>>      return -ENOIOCTLCMD;
>>>  }
>>>
>>> -int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>>> +int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>>>  {
>>> +    struct kvm_run *run = vcpu->run;
>>>      int r = -EINTR;
>>>
>>>      vcpu_load(vcpu);
>>> diff --git a/arch/powerpc/kvm/powerpc.c b/arch/powerpc/kvm/powerpc.c
>>> index e15166b0a16d..7e24691e138a 100644
>>> --- a/arch/powerpc/kvm/powerpc.c
>>> +++ b/arch/powerpc/kvm/powerpc.c
>>> @@ -1764,8 +1764,9 @@ int kvm_vcpu_ioctl_set_one_reg(struct kvm_vcpu 
>>> *vcpu, struct kvm_one_reg *reg)
>>>      return r;
>>>  }
>>>
>>> -int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>>> +int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>>>  {
>>> +    struct kvm_run *run = vcpu->run;
>>>      int r;
>>>
>>>      vcpu_load(vcpu);
>>> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
>>> index 19a81024fe16..443af3ead739 100644
>>> --- a/arch/s390/kvm/kvm-s390.c
>>> +++ b/arch/s390/kvm/kvm-s390.c
>>> @@ -4333,8 +4333,9 @@ static void store_regs(struct kvm_vcpu *vcpu, 
>>> struct kvm_run *kvm_run)
>>>          store_regs_fmt2(vcpu, kvm_run);
>>>  }
>>>
>>> -int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run 
>>> *kvm_run)
>>> +int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>>>  {
>>> +    struct kvm_run *kvm_run = vcpu->run;
>>>      int rc;
>>>
>>>      if (kvm_run->immediate_exit)
>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>> index 3bf2ecafd027..a0338e86c90f 100644
>>> --- a/arch/x86/kvm/x86.c
>>> +++ b/arch/x86/kvm/x86.c
>>> @@ -8707,8 +8707,9 @@ static void kvm_put_guest_fpu(struct kvm_vcpu 
>>> *vcpu)
>>>      trace_kvm_fpu(0);
>>>  }
>>>
>>> -int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run 
>>> *kvm_run)
>>> +int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>>>  {
>>> +    struct kvm_run *kvm_run = vcpu->run;
>>>      int r;
>>>
>>>      vcpu_load(vcpu);
>>> @@ -8726,18 +8727,18 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu 
>>> *vcpu, struct kvm_run *kvm_run)
>>>          r = -EAGAIN;
>>>          if (signal_pending(current)) {
>>>              r = -EINTR;
>>> -            vcpu->run->exit_reason = KVM_EXIT_INTR;
>>> +            kvm_run->exit_reason = KVM_EXIT_INTR;
>>>              ++vcpu->stat.signal_exits;
>>>          }
>>>          goto out;
>>>      }
>>>
>>> -    if (vcpu->run->kvm_valid_regs & ~KVM_SYNC_X86_VALID_FIELDS) {
>>> +    if (kvm_run->kvm_valid_regs & ~KVM_SYNC_X86_VALID_FIELDS) {
>>>          r = -EINVAL;
>>>          goto out;
>>>      }
>>>
>>> -    if (vcpu->run->kvm_dirty_regs) {
>>> +    if (kvm_run->kvm_dirty_regs) {
>>>          r = sync_regs(vcpu);
>>>          if (r != 0)
>>>              goto out;
>>> @@ -8767,7 +8768,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu 
>>> *vcpu, struct kvm_run *kvm_run)
>>>
>>>  out:
>>>      kvm_put_guest_fpu(vcpu);
>>> -    if (vcpu->run->kvm_valid_regs)
>>> +    if (kvm_run->kvm_valid_regs)
>>>          store_regs(vcpu);
>>>      post_kvm_run_save(vcpu);
>>>      kvm_sigset_deactivate(vcpu);
>>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>>> index 6d58beb65454..1e17ef719595 100644
>>> --- a/include/linux/kvm_host.h
>>> +++ b/include/linux/kvm_host.h
>>> @@ -866,7 +866,7 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct 
>>> kvm_vcpu *vcpu,
>>>                      struct kvm_mp_state *mp_state);
>>>  int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
>>>                      struct kvm_guest_debug *dbg);
>>> -int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run 
>>> *kvm_run);
>>> +int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu);
>>>
>>>  int kvm_arch_init(void *opaque);
>>>  void kvm_arch_exit(void);
>>> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
>>> index 48d0ec44ad77..f5390ac2165b 100644
>>> --- a/virt/kvm/arm/arm.c
>>> +++ b/virt/kvm/arm/arm.c
>>> @@ -639,7 +639,6 @@ static void check_vcpu_requests(struct kvm_vcpu 
>>> *vcpu)
>>>  /**
>>>   * kvm_arch_vcpu_ioctl_run - the main VCPU run function to execute 
>>> guest code
>>>   * @vcpu:    The VCPU pointer
>>> - * @run:    The kvm_run structure pointer used for userspace state 
>>> exchange
>>>   *
>>>   * This function is called through the VCPU_RUN ioctl called from 
>>> user space. It
>>>   * will execute VM code in a loop until the time slice for the 
>>> process is used
>>> @@ -647,8 +646,9 @@ static void check_vcpu_requests(struct kvm_vcpu 
>>> *vcpu)
>>>   * return with return value 0 and with the kvm_run structure filled 
>>> in with the
>>>   * required data for the requested emulation.
>>>   */
>>> -int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>>> +int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
>>>  {
>>> +    struct kvm_run *run = vcpu->run;
>>>      int ret;
>>>
>>>      if (unlikely(!kvm_vcpu_initialized(vcpu)))
>>> @@ -659,7 +659,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu 
>>> *vcpu, struct kvm_run *run)
>>>          return ret;
>>>
>>>      if (run->exit_reason == KVM_EXIT_MMIO) {
>>> -        ret = kvm_handle_mmio_return(vcpu, vcpu->run);
>>> +        ret = kvm_handle_mmio_return(vcpu, run);
>>
>> I don't know much about ARM but this also seems redundant,
>> kvm_handle_mmio_return() is also able to extruct 'struct kvm_run' from'
>> 'struct kvm_vcpu'. This likely deserves it's own patch though.
> 
> Something like this (untested):
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h 
> b/arch/arm64/include/asm/kvm_host.h
> index 32c8a675e5a4..82978995bdd6 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -490,7 +490,7 @@ void handle_exit_early(struct kvm_vcpu *vcpu, struct 
> kvm_run *run,
>   void kvm_mmio_write_buf(void *buf, unsigned int len, unsigned long data);
>   unsigned long kvm_mmio_read_buf(const void *buf, unsigned int len);
> 
> -int kvm_handle_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run);
> +int kvm_handle_mmio_return(struct kvm_vcpu *vcpu);
>   int io_mem_abort(struct kvm_vcpu *vcpu, struct kvm_run *run,
>            phys_addr_t fault_ipa);
> 
> diff --git a/virt/kvm/arm/mmio.c b/virt/kvm/arm/mmio.c
> index 4e0366759726..3b2c822b4859 100644
> --- a/virt/kvm/arm/mmio.c
> +++ b/virt/kvm/arm/mmio.c
> @@ -77,9 +77,8 @@ unsigned long kvm_mmio_read_buf(const void *buf, 
> unsigned int len)
>    *                 or in-kernel IO emulation
>    *
>    * @vcpu: The VCPU pointer
> - * @run:  The VCPU run struct containing the mmio data
>    */
> -int kvm_handle_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
> +int kvm_handle_mmio_return(struct kvm_vcpu *vcpu)
>   {
>       unsigned long data;
>       unsigned int len;
> @@ -93,7 +92,7 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu, 
> struct kvm_run *run)
> 
>       if (!kvm_vcpu_dabt_iswrite(vcpu)) {
>           len = kvm_vcpu_dabt_get_as(vcpu);
> -        data = kvm_mmio_read_buf(run->mmio.data, len);
> +        data = kvm_mmio_read_buf(vcpu->run->mmio.data, len);
> 
>           if (kvm_vcpu_dabt_issext(vcpu) &&
>               len < sizeof(unsigned long)) {
> @@ -104,7 +103,8 @@ int kvm_handle_mmio_return(struct kvm_vcpu *vcpu, 
> struct kvm_run *run)
>           if (!kvm_vcpu_dabt_issf(vcpu))
>               data = data & 0xffffffff;
> 
> -        trace_kvm_mmio(KVM_TRACE_MMIO_READ, len, run->mmio.phys_addr,
> +        trace_kvm_mmio(KVM_TRACE_MMIO_READ, len,
> +                   vcpu->run->mmio.phys_addr,
>                      &data);
>           data = vcpu_data_host_to_guest(vcpu, data, len);
>           vcpu_set_reg(vcpu, kvm_vcpu_dabt_get_rd(vcpu), data);
> 
> Overall, there is a large set of cleanups to be done when both the vcpu 
> and the run
> structures are passed as parameters at the same time. Just grepping the 
> tree for
> kvm_run is pretty instructive.
> 
>          M.

Sorry, it's my mistake, I only compiled the x86 platform, I will submit 
patch again.

Thanks,
Tianjia
