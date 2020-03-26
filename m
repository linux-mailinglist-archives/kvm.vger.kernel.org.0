Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B066193DA1
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 12:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbgCZLIv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 07:08:51 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:50368 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727688AbgCZLIv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Mar 2020 07:08:51 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jHQNH-0005bA-Jj; Thu, 26 Mar 2020 12:08:35 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 0775710069D; Thu, 26 Mar 2020 12:08:35 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Xiaoyao Li <xiaoyao.li@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, hpa@zytor.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH v6 8/8] kvm: vmx: virtualize split lock detection
In-Reply-To: <9a9c0817-9ebb-524f-44df-176a15ea3fca@intel.com>
References: <20200324151859.31068-1-xiaoyao.li@intel.com> <20200324151859.31068-9-xiaoyao.li@intel.com> <87eethz2p6.fsf@nanos.tec.linutronix.de> <6d3e7e03-d304-8ec0-b00d-050b1c12140d@intel.com> <87369xyzvk.fsf@nanos.tec.linutronix.de> <9a9c0817-9ebb-524f-44df-176a15ea3fca@intel.com>
Date:   Thu, 26 Mar 2020 12:08:34 +0100
Message-ID: <87ftdvxtjh.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Xiaoyao Li <xiaoyao.li@intel.com> writes:
> On 3/25/2020 9:41 AM, Thomas Gleixner wrote:
>> If you really want to address that scenario, then why are you needing
>> any of those completely backwards interfaces at all?
>> 
>> Just because your KVM exception trap uses the host handling function
>> which sets TIF_SLD?
>>   
> Yes. just because KVM use the host handling function.

> If you disallow me to touch codes out of kvm. It can be achieved with

Who said you cannot touch code outside of KVM? 

> Obviously re-use TIF_SLD flag to automatically switch MSR_TEST_CTRL.SLD 
> bit when switch to/from vcpu thread is better.

What's better about that?

TIF_SLD has very well defined semantics. It's used to denote that the
SLD bit needs to be cleared for the task when its scheduled in.

So now you overload it by clearing it magically and claim that this is
better.

vCPU-thread

   user space (qemu)
     triggers #AC
       -> exception
           set TIF_SLD

   iotctl()
     vcpu_run()
       -> clear TIF_SLD

It's not better, it's simply wrong and inconsistent.

> And to virtualize SLD feature as full as possible for guest, we have to 
> implement the backwards interface. If you really don't want that 
> interface, we have to write code directly in kvm to modify TIF_SLD flag 
> and MSR_TEST_CTRL.SLD bit.

Wrong again. KVM has absolutely no business in fiddling with TIF_SLD and
the function to flip the SLD bit is simply sld_update_msr(bool on) which
does not need any KVMism at all.

There are two options to handle SLD for KVM:

   1) Follow strictly the host rules

      If user space or guest triggered #AC then TIF_SLD is set and that
      task is excluded from ever setting SLD again.

   2) Track KVM guest state separately

      vcpu_run()
        if (current_has(TIF_SLD) && guest_sld_on())
          sld_update_msr(true);
        else if (!current_has(TIF_SLD) && !guest_sld_on())
          sld_update_msr(false);
        vmenter()
          ....
        vmexit()
        if (current_has(TIF_SLD) && guest_sld_on())
          sld_update_msr(false);
        else if (!current_has(TIF_SLD) && !guest_sld_on())
          sld_update_msr(true);

      If the guest triggers #AC then this solely affects guest state
      and does not fiddle with TIF_SLD.

Thanks,

        tglx
