Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8C74191E76
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 02:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727285AbgCYBOA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 21:14:00 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:46700 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727119AbgCYBOA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 21:14:00 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jGuHy-0000My-WD; Wed, 25 Mar 2020 01:52:59 +0100
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 7A272100C51; Wed, 25 Mar 2020 01:52:58 +0100 (CET)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Xiaoyao Li <xiaoyao.li@intel.com>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, hpa@zytor.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org
Cc:     Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>
Subject: Re: [PATCH v5 1/9] x86/split_lock: Rework the initialization flow of split lock detection
In-Reply-To: <02ff2436-340c-540a-86b8-fa5f4ff7bb3b@intel.com>
References: <20200315050517.127446-1-xiaoyao.li@intel.com> <20200315050517.127446-2-xiaoyao.li@intel.com> <87zhc7ovhj.fsf@nanos.tec.linutronix.de> <87lfnqq0oo.fsf@nanos.tec.linutronix.de> <beb9ab5c-a50d-2ec6-1c23-e426508cdf4e@intel.com> <87tv2edp1a.fsf@nanos.tec.linutronix.de> <02ff2436-340c-540a-86b8-fa5f4ff7bb3b@intel.com>
Date:   Wed, 25 Mar 2020 01:52:58 +0100
Message-ID: <87blolz251.fsf@nanos.tec.linutronix.de>
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
> On 3/24/2020 6:29 PM, Thomas Gleixner wrote:
>> -	switch (sld_state) {
>> +	switch (state) {
>>   	case sld_off:
>>   		pr_info("disabled\n");
>> -		break;
>> -
>> +		return;
> Here, when sld_off, it just returns without 
> setup_force_cpu_cap(X86_FEATURE_SPLIT_LOCK_DETECT).
>
> So for APs, it won't clear SLD bit in split_lock_init().

Trivial fix:

static void split_lock_init(void)
{
	split_lock_verify_msr(sld_state != sld_off);
}

You just need to remove the __init annotation from split_lock_verify_msr().

Thanks,

        tglx
