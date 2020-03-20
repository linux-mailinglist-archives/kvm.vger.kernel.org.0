Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E50518C42F
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 01:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbgCTAS1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 20:18:27 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:34318 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgCTAS1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 20:18:27 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jF5MU-0002ZE-GG; Fri, 20 Mar 2020 01:18:06 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id F1537100375; Fri, 20 Mar 2020 01:18:05 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     syzbot <syzbot+00be5da1d75f1cc95f6b@syzkaller.appspotmail.com>,
        bp@alien8.de, hpa@zytor.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, rkrcmar@redhat.com,
        syzkaller-bugs@googlegroups.com, vkuznets@redhat.com,
        wanpengli@tencent.com, x86@kernel.org
Subject: Re: WARNING in vcpu_enter_guest
In-Reply-To: <cd32ee6d-f30d-b221-8126-cf995ffca52e@redhat.com>
References: <000000000000f965b8059877e5e6@google.com> <00000000000081861f05a132b9cd@google.com> <20200319144952.GB11305@linux.intel.com> <20be9560-fce7-1495-3a83-e2b56dbc2389@redhat.com> <20200319173549.GC11305@linux.intel.com> <20200319173927.GD11305@linux.intel.com> <cd32ee6d-f30d-b221-8126-cf995ffca52e@redhat.com>
Date:   Fri, 20 Mar 2020 01:18:05 +0100
Message-ID: <87k13f516q.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 19/03/20 18:39, Sean Christopherson wrote:
>>> Yep.  I worked through logic/math, mostly to gain a wee bit of knowledge
>>> about the clock stuff, and it's sound.  The KVM_SET_CLOCK from syzkaller
>>> is simply making time go backwards.
>> Actually, would it make sense to return -EINVAL for KVM_SET_CLOCK if the
>> user tries to make kvmclock_offset go backwards?
>
> No, it is possible to do that depending on the clock setup on the live
> migration source.  You could cause the warning anyway by setting the
> clock to a very high (signed) value so that kernel_ns + kvmclock_offset
> overflows.

If that overflow happens, then the original and the new host have an
uptime difference in the range of >200 hundreds of years. Very realistic
scenario...

Of course this can happen if you feed crap into the interface, but do
you really think that forwarding all crap to a guest is the right thing
to do?

As we all know the hypervisor orchestration stuff is perfect and would
never feed crap into the kernel which happily proliferates that crap to
the guest...

Seriously??

Thanks,

        tglx
