Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 760542C004
	for <lists+kvm@lfdr.de>; Tue, 28 May 2019 09:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbfE1HVw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 May 2019 03:21:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:57195 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726879AbfE1HVw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 May 2019 03:21:52 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 May 2019 00:21:51 -0700
X-ExtLoop1: 1
Received: from shzintpr03.sh.intel.com (HELO [0.0.0.0]) ([10.239.4.100])
  by orsmga001.jf.intel.com with ESMTP; 28 May 2019 00:21:48 -0700
Subject: Re: [PATCH v2 1/3] KVM: x86: add support for user wait instructions
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        kvm <kvm@vger.kernel.org>, linux-doc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, jingqi.liu@intel.com
References: <20190524075637.29496-1-tao3.xu@intel.com>
 <20190524075637.29496-2-tao3.xu@intel.com>
 <20190527103003.GX2623@hirez.programming.kicks-ass.net>
 <43e2a62a-e992-2138-f038-1e4b2fb79ad1@intel.com>
 <CANRm+CwnJoj0EwWoFC44SXVUTLdE+iFGovaMr4Yf=OzbaW36sA@mail.gmail.com>
From:   Tao Xu <tao3.xu@intel.com>
Message-ID: <072dd34e-0361-5a06-4d0b-d04e8150a3bb@intel.com>
Date:   Tue, 28 May 2019 15:19:30 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CANRm+CwnJoj0EwWoFC44SXVUTLdE+iFGovaMr4Yf=OzbaW36sA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 28/05/2019 14:11, Wanpeng Li wrote:
> On Tue, 28 May 2019 at 13:16, Tao Xu <tao3.xu@intel.com> wrote:
>>
>>
>> On 27/05/2019 18:30, Peter Zijlstra wrote:
>>> On Fri, May 24, 2019 at 03:56:35PM +0800, Tao Xu wrote:
>>>> This patch adds support for UMONITOR, UMWAIT and TPAUSE instructions
>>>> in kvm, and by default dont't expose it to kvm and provide a capability
>>>> to enable it.
>>>
>>> I'm thinking this should be conditional on the guest being a 1:1 guest,
>>> and I also seem to remember we have bits for that already -- they were
>>> used to disable paravirt spinlocks for example.
>>>
>>
>> Hi Peter,
>>
>> I am wondering if "1:1 guest" means different guests in the same host
>> should have different settings on user wait instructions?
>>
>> User wait instructions(UMONITOR, UMWAIT and TPAUSE) can use in guest
>> only when the VMCS Secondary Processor-Based VM-Execution Control bit 26
>> is 1, otherwise any execution of TPAUSE, UMONITOR, or UMWAIT causes a #UD.
>>
>> So with a capability to enable it, we use qemu kvm_vm_ioctl_enable_cap()
>> to enable it. The qemu link is blew:
>> https://lists.gnu.org/archive/html/qemu-devel/2019-05/msg05810.html
>>
>> By using different QEMU parameters, different guests in the same host
>> would have different features with or without user wait instructions.
>>
>> About "disable paravirt spinlocks" case, I am wondering if it uses
> 
> Please refer to a4429e53c9 (KVM: Introduce paravirtualization hints
> and KVM_HINTS_DEDICATED) and b2798ba0b87 (KVM: X86: Choose qspinlock
> when dedicated physical CPUs are available)
Hi Wanpeng,

Thank you! This information really helped me. After I read the code in 
KVM/QEMU, I was wondering that with qemu command-line "-cpu 
host,+kvm-hint-dedicated", then in KVM, 
"kvm_hint_has_feature(KVM_HINTS_DEDICATED)" will be true, am I right?

Tao
