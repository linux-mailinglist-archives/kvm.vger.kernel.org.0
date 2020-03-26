Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76AA7193DAA
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 12:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbgCZLK3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Mar 2020 07:10:29 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:50381 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727590AbgCZLK3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Mar 2020 07:10:29 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jHQOx-0005eh-EM; Thu, 26 Mar 2020 12:10:19 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id E9D2610069D; Thu, 26 Mar 2020 12:10:18 +0100 (CET)
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
In-Reply-To: <88b01989-25cd-90af-bfe8-c236bd5d1dbf@intel.com>
References: <20200324151859.31068-1-xiaoyao.li@intel.com> <20200324151859.31068-9-xiaoyao.li@intel.com> <87eethz2p6.fsf@nanos.tec.linutronix.de> <88b01989-25cd-90af-bfe8-c236bd5d1dbf@intel.com>
Date:   Thu, 26 Mar 2020 12:10:18 +0100
Message-ID: <87d08zxtgl.fsf@nanos.tec.linutronix.de>
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
>> Xiaoyao Li <xiaoyao.li@intel.com> writes:
>>>   static int handle_exception_nmi(struct kvm_vcpu *vcpu)
>>>   {
>>>   	struct vcpu_vmx *vmx = to_vmx(vcpu);
>>> @@ -4725,12 +4746,13 @@ static int handle_exception_nmi(struct kvm_vcpu *vcpu)
>>>   	case AC_VECTOR:
>>>   		/*
>>>   		 * Reflect #AC to the guest if it's expecting the #AC, i.e. has
>>> -		 * legacy alignment check enabled.  Pre-check host split lock
>>> -		 * support to avoid the VMREADs needed to check legacy #AC,
>>> -		 * i.e. reflect the #AC if the only possible source is legacy
>>> -		 * alignment checks.
>>> +		 * legacy alignment check enabled or split lock detect enabled.
>>> +		 * Pre-check host split lock support to avoid further check of
>>> +		 * guest, i.e. reflect the #AC if host doesn't enable split lock
>>> +		 * detection.
>>>   		 */
>>>   		if (!split_lock_detect_on() ||
>>> +		    guest_cpu_split_lock_detect_on(vmx) ||
>>>   		    guest_cpu_alignment_check_enabled(vcpu)) {
>> 
>> If the host has split lock detection disabled then how is the guest
>> supposed to have it enabled in the first place?
>> 
> It is ||

Again. If the host has it disabled, then the feature flag is OFF. So
how is the hypervisor exposing it in the first place?

Thanks,

        tglx
