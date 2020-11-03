Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADE82A3DAC
	for <lists+kvm@lfdr.de>; Tue,  3 Nov 2020 08:29:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbgKCH3k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Nov 2020 02:29:40 -0500
Received: from mga02.intel.com ([134.134.136.20]:58283 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725968AbgKCH3j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Nov 2020 02:29:39 -0500
IronPort-SDR: s+jbcbFJJD00Rs0Dvvvl07xJaxyHV8URDvbuDSA2VTvDP7kHsZnF9KwqIdLYLZc7qUOx6qyi2n
 R61fAIZCXrTg==
X-IronPort-AV: E=McAfee;i="6000,8403,9793"; a="155999399"
X-IronPort-AV: E=Sophos;i="5.77,447,1596524400"; 
   d="scan'208";a="155999399"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2020 23:29:39 -0800
IronPort-SDR: 2JwyHF+rwKrId2o2gdW5kMJvmpmaWyM1RD2wpeRZSKOkKXWhh8O0W9HbVncpKH2lLycljKI0hc
 8O+SJu5EubFg==
X-IronPort-AV: E=Sophos;i="5.77,447,1596524400"; 
   d="scan'208";a="470690411"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.239.13.118]) ([10.239.13.118])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2020 23:29:35 -0800
Subject: Re: [PATCH] KVM: VMX: Enable Notify VM exit
To:     Tao Xu <tao3.xu@intel.com>, Andy Lutomirski <luto@amacapital.net>
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
        LKML <linux-kernel@vger.kernel.org>
References: <20201102061445.191638-1-tao3.xu@intel.com>
 <CALCETrVqdq4zw=Dcd6dZzSmUZTMXHP50d=SRSaY2AV5sauUzOw@mail.gmail.com>
 <a5f500ee-51f8-54a7-d927-0e8eee644e26@intel.com>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <a7c8cdeb-c5be-a00f-eb2f-fcc8762c07b2@intel.com>
Date:   Tue, 3 Nov 2020 15:29:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <a5f500ee-51f8-54a7-d927-0e8eee644e26@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/3/2020 2:08 PM, Tao Xu wrote:
> 
> 
> On 11/3/20 12:43 AM, Andy Lutomirski wrote:
>> On Sun, Nov 1, 2020 at 10:14 PM Tao Xu <tao3.xu@intel.com> wrote:
>>>
...
>>
>>> +static int handle_notify(struct kvm_vcpu *vcpu)
>>> +{
>>> +       unsigned long exit_qualification = 
>>> vmcs_readl(EXIT_QUALIFICATION);
>>> +
>>> +       /*
>>> +        * Notify VM exit happened while executing iret from NMI,
>>> +        * "blocked by NMI" bit has to be set before next VM entry.
>>> +        */
>>> +       if (exit_qualification & NOTIFY_VM_CONTEXT_VALID) {
>>> +               if (enable_vnmi &&
>>> +                   (exit_qualification & INTR_INFO_UNBLOCK_NMI))
>>> +                       vmcs_set_bits(GUEST_INTERRUPTIBILITY_INFO,
>>> +                                     GUEST_INTR_STATE_NMI);
>>
>> This needs actual documentation in the SDM or at least ISE please.
>>

Hi Andy,

Do you mean SDM or ISE should call out it needs to restore "blocked by 
NMI" if bit 12 of exit qualification is set and VMM decides to re-enter 
the guest?

you can refer to SDM 27.2.3 "Information about NMI unblocking Due to 
IRET" in latest SDM 325462-072US

> Notify VM-Exit is defined in ISE, chapter 9.2:
> https://software.intel.com/content/dam/develop/external/us/en/documents/architecture-instruction-set-extensions-programming-reference.pdf 
> 
> 
> I will add this information into commit message. Thank you for reminding 
> me.

