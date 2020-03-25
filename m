Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED291191EA2
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 02:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727253AbgCYBmG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 21:42:06 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:46726 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727189AbgCYBmG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 21:42:06 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jGv3I-00018S-NH; Wed, 25 Mar 2020 02:41:53 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id C5E67100C51; Wed, 25 Mar 2020 02:41:51 +0100 (CET)
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
In-Reply-To: <6d3e7e03-d304-8ec0-b00d-050b1c12140d@intel.com>
References: <20200324151859.31068-1-xiaoyao.li@intel.com> <20200324151859.31068-9-xiaoyao.li@intel.com> <87eethz2p6.fsf@nanos.tec.linutronix.de> <6d3e7e03-d304-8ec0-b00d-050b1c12140d@intel.com>
Date:   Wed, 25 Mar 2020 02:41:51 +0100
Message-ID: <87369xyzvk.fsf@nanos.tec.linutronix.de>
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
> On 3/25/2020 8:40 AM, Thomas Gleixner wrote:
>>>   		if (!split_lock_detect_on() ||
>>> +		    guest_cpu_split_lock_detect_on(vmx) ||
>>>   		    guest_cpu_alignment_check_enabled(vcpu)) {
>> 
>> If the host has split lock detection disabled then how is the guest
>> supposed to have it enabled in the first place?
>
> So we need to reach an agreement on whether we need a state that host 
> turns it off but feature is available to be exposed to guest.

There is a very simple agreement:

  If the host turns it off, then it is not available at all

  If the host sets 'warn' then this applies to everything

  If the host sets 'fatal' then this applies to everything

Make it simple and consistent.

>>> +	if (static_cpu_has(X86_FEATURE_SPLIT_LOCK_DETECT) &&
>>> +	    guest_cpu_split_lock_detect_on(vmx)) {
>>> +		if (test_thread_flag(TIF_SLD))
>>> +			sld_turn_back_on();
>> 
>> This is completely inconsistent behaviour. The only way that TIF_SLD is
>> set is when the host has sld_state == sld_warn and the guest triggered
>> a split lock #AC.
>
> Can you image the case that both host and guest set sld_state == sld_warn.
>
> 1. There is guest userspace thread causing split lock.
> 2. It sets TIF_SLD for the thread in guest, and clears SLD bit to re- 
> execute the instruction in guest.
> 3. Then it still causes #AC since hardware SLD is not cleared. In host 
> kvm, we call handle_user_split_lock() that sets TIF_SLD for this VMM 
> thread, and clears hardware SLD bit. Then it enters guest and re-execute 
> the instruction.
> 4. In guest, it schedules to another thread without TIF_SLD being set. 
> it sets the SLD bit to detect the split lock for this thread. So for 
> this purpose, we need to turn sld back on for the VMM thread, otherwise 
> this guest vcpu cannot catch split lock any more.

If you really want to address that scenario, then why are you needing
any of those completely backwards interfaces at all?

Just because your KVM exception trap uses the host handling function
which sets TIF_SLD?
 
Please sit down, go back to the drawing board and figure it out how to
solve that without creating inconsistent state and duct tape functions
to deal with that.

I'm not rewriting the patches for you this time.

> Do you need me to spin a new version of patch 1 to clear SLD bit on APs 
> if SLD_OFF?

I assume you can answer that question yourself.

Thanks,

        tglx



