Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F38C33021EF
	for <lists+kvm@lfdr.de>; Mon, 25 Jan 2021 06:51:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbhAYFvC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jan 2021 00:51:02 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:37157 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725821AbhAYFt5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Jan 2021 00:49:57 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=alex.shi@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UMkx0Sj_1611553746;
Received: from IT-FVFX43SYHV2H.local(mailfrom:alex.shi@linux.alibaba.com fp:SMTPD_---0UMkx0Sj_1611553746)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 25 Jan 2021 13:49:07 +0800
Subject: Re: 3 preempted variables in kvm
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>, yj226063@alibaba-inc.com
References: <b6398228-31b9-ca84-873b-4febbd37c87d@linux.alibaba.com>
 <YAsnvA1Q5AlXLd1W@google.com>
From:   Alex Shi <alex.shi@linux.alibaba.com>
Message-ID: <c14cac63-6a4c-1b5d-6a32-e16117141e94@linux.alibaba.com>
Date:   Mon, 25 Jan 2021 13:49:04 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.0; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <YAsnvA1Q5AlXLd1W@google.com>
Content-Type: text/plain; charset=gbk
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Sean,

Thanks a lot for the detailed explanations.
Yes, they are all meaningful variables on x86. But for more archs, guess the lock
issue on different arch's guest are similar. Maybe a abstraction on the point would
be very helpful. Any comments?

Thanks
Alex

ÔÚ 2021/1/23 ÉÏÎç3:30, Sean Christopherson Ð´µÀ:
> On Fri, Jan 22, 2021, Alex Shi wrote:
>> Hi All,
>>
>> I am newbie on KVM side, so probably I am wrong on the following.
>> Please correct me if it is.
>>
>> There are 3 preempted variables in kvm:
>>      1, kvm_vcpu.preempted  in include/linux/kvm_host.h
>>      2, kvm_steal_time.preempted
>>      3, kvm_vcpu_arch.st.preempted in arch/x86
>> Seems all of them are set or cleared at the same time. Like,
> 
> Not quite.  kvm_vcpu.preempted is set only in kvm_sched_out(), i.e. when the
> vCPU was running and preempted by the host scheduler.  This is used by KVM when
> KVM detects that a guest task appears to be waiting on a lock, in which case KVM
> will bump the priority of preempted guest kernel threads in the hope that
> scheduling in the preempted vCPU will release the lock.
> 
> kvm_steal_time.preempted is a paravirt struct that is shared with the guest.  It
> is set on any call to kvm_arch_vcpu_put(), which covers kvm_sched_out() and adds
> the case where the vCPU exits to userspace, e.g. for IO.  KVM itself hasn't been
> preempted, but from the guest's perspective the CPU has been "preempted" in the
> sense that CPU (from the guest's perspective) is not executing guest code.
> Similar to KVM's vCPU scheduling heuristics, the guest kernel uses this info to
> inform its scheduling, e.g. to avoid waiting on a lock owner to drop the lock
> since the lock owner is not actively running.
> 
> kvm_vcpu_arch.st.preempted is effectively a host-side cache of
> kvm_steal_time.preempted that's used to optimize kvm_arch_vcpu_put() by avoiding
> the moderately costly mapping of guest.  It could be dropped, but it's a single
> byte per vCPU so worth keeping even if the performance benefits are modest.
> 
>> vcpu_put:
>>         kvm_sched_out()-> set 3 preempted
>>                 kvm_arch_vcpu_put():
>>                         kvm_steal_time_set_preempted
>>
>> vcpu_load:
>>         kvm_sched_in() : clear above 3 preempted
>>                 kvm_arch_vcpu_load() -> kvm_make_request(KVM_REQ_STEAL_UPDATE, vcpu);
>>                 request dealed in vcpu_enter_guest() -> record_steal_time
>>
>> Except the 2nd one reuse with KVM_FEATURE_PV_TLB_FLUSH bit which could be used
>> separately, Could we combine them into one, like just bool kvm_vcpu.preempted? and 
>> move out the KVM_FEATURE_PV_TLB_FLUSH. Believe all arch need this for a vcpu overcommit.
> 
> Moving KVM_VCPU_FLUSH_TLB out of kvm_steal_time.preempted isn't viable. The
> guest kernel is only allowed to rely on the host to flush the vCPU's TLB if it
> knows the vCPU is preempted (from its perspective), as that's the only way it
> can guarantee that KVM will observe the TLB flush request before enterring the
> vCPU.  KVM_VCPU_FLUSH_TLB and KVM_VCPU_PREEMPTED need to be in the same word so
> KVM can read and clear them atomically, otherwise there would be a window where
> KVM would miss the flush request.
> 
