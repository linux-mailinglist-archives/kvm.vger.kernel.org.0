Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A939B2A3C9F
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 07:09:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727468AbgKCGJE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 01:09:04 -0500
Received: from mga02.intel.com ([134.134.136.20]:52366 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725958AbgKCGJE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Nov 2020 01:09:04 -0500
IronPort-SDR: ggwdjie/9LDoMciHG+juR5HTGhOuf7bDPd2GmzyIonu+BBgVWJwz7Nxv5x/a/SQjaNQW4e7U6g
 oPSuzuAmrKwQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9793"; a="155992441"
X-IronPort-AV: E=Sophos;i="5.77,447,1596524400"; 
   d="scan'208";a="155992441"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2020 22:09:03 -0800
IronPort-SDR: ibJSAcIICb1zvAAFmRkFWQJgwkG/GIRz518Zx/VvRMV+DBH0LeWqzjlwyhD8CIKyOq6pLpo9hn
 W7Uodn9f0c1w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,447,1596524400"; 
   d="scan'208";a="353093840"
Received: from shzintpr01.sh.intel.com (HELO [0.0.0.0]) ([10.239.4.80])
  by fmsmga004.fm.intel.com with ESMTP; 02 Nov 2020 22:09:00 -0800
Subject: Re: [PATCH] KVM: VMX: Enable Notify VM exit
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>
References: <20201102061445.191638-1-tao3.xu@intel.com>
 <CALCETrVqdq4zw=Dcd6dZzSmUZTMXHP50d=SRSaY2AV5sauUzOw@mail.gmail.com>
From:   Tao Xu <tao3.xu@intel.com>
Message-ID: <a5f500ee-51f8-54a7-d927-0e8eee644e26@intel.com>
Date:   Tue, 3 Nov 2020 14:08:59 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CALCETrVqdq4zw=Dcd6dZzSmUZTMXHP50d=SRSaY2AV5sauUzOw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/3/20 12:43 AM, Andy Lutomirski wrote:
> On Sun, Nov 1, 2020 at 10:14 PM Tao Xu <tao3.xu@intel.com> wrote:
>>
>> There are some cases that malicious virtual machines can cause CPU stuck
>> (event windows don't open up), e.g., infinite loop in microcode when
>> nested #AC (CVE-2015-5307). No event window obviously means no events,
>> e.g. NMIs, SMIs, and IRQs will all be blocked, may cause the related
>> hardware CPU can't be used by host or other VM.
>>
>> To resolve those cases, it can enable a notify VM exit if no
>> event window occur in VMX non-root mode for a specified amount of
>> time (notify window).
>>
>> Expose a module param for setting notify window, default setting it to
>> the time as 1/10 of periodic tick, and user can set it to 0 to disable
>> this feature.
>>
>> TODO:
>> 1. The appropriate value of notify window.
>> 2. Another patch to disable interception of #DB and #AC when notify
>> VM-Exiting is enabled.
> 
> Whoa there.
> 
> A VM control that says "hey, CPU, if you messed up and livelocked for
> a long time, please break out of the loop" is not a substitute for
> fixing the livelocks.  So I don't think you get do disable
> interception of #DB and #AC.  I also think you should print a loud
> warning and have some intelligent handling when this new exit
> triggers.
> 
>> +static int handle_notify(struct kvm_vcpu *vcpu)
>> +{
>> +       unsigned long exit_qualification = vmcs_readl(EXIT_QUALIFICATION);
>> +
>> +       /*
>> +        * Notify VM exit happened while executing iret from NMI,
>> +        * "blocked by NMI" bit has to be set before next VM entry.
>> +        */
>> +       if (exit_qualification & NOTIFY_VM_CONTEXT_VALID) {
>> +               if (enable_vnmi &&
>> +                   (exit_qualification & INTR_INFO_UNBLOCK_NMI))
>> +                       vmcs_set_bits(GUEST_INTERRUPTIBILITY_INFO,
>> +                                     GUEST_INTR_STATE_NMI);
> 
> This needs actual documentation in the SDM or at least ISE please.
> 
Notify VM-Exit is defined in ISE, chapter 9.2:
https://software.intel.com/content/dam/develop/external/us/en/documents/architecture-instruction-set-extensions-programming-reference.pdf

I will add this information into commit message. Thank you for reminding me.
