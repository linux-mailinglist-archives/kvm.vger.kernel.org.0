Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D23E314F90D
	for <lists+kvm@lfdr.de>; Sat,  1 Feb 2020 17:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgBAQ6V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 1 Feb 2020 11:58:21 -0500
Received: from mga07.intel.com ([134.134.136.100]:37934 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726670AbgBAQ6U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 1 Feb 2020 11:58:20 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Feb 2020 08:58:20 -0800
X-IronPort-AV: E=Sophos;i="5.70,390,1574150400"; 
   d="scan'208";a="218922079"
Received: from xiaoyaol-mobl.ccr.corp.intel.com (HELO [10.249.174.29]) ([10.249.174.29])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 01 Feb 2020 08:58:17 -0800
Subject: Re: [PATCH 2/2] KVM: VMX: Extend VMX's #AC handding
To:     Andy Lutomirski <luto@amacapital.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20200131210424.GG18946@linux.intel.com>
 <E1F9CE39-7D61-43E1-B871-6D4BFA4B6D66@amacapital.net>
From:   Xiaoyao Li <xiaoyao.li@intel.com>
Message-ID: <b2e2310d-2228-45c2-8174-048e18a46bb6@intel.com>
Date:   Sun, 2 Feb 2020 00:58:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <E1F9CE39-7D61-43E1-B871-6D4BFA4B6D66@amacapital.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/1/2020 5:33 AM, Andy Lutomirski wrote:
> 
> 
>> On Jan 31, 2020, at 1:04 PM, Sean Christopherson <sean.j.christopherson@intel.com> wrote:
>>
>> ﻿On Fri, Jan 31, 2020 at 12:57:51PM -0800, Andy Lutomirski wrote:
>>>
>>>>> On Jan 31, 2020, at 12:18 PM, Sean Christopherson <sean.j.christopherson@intel.com> wrote:
>>>>
>>>> This is essentially what I proposed a while back.  KVM would allow enabling
>>>> split-lock #AC in the guest if and only if SMT is disabled or the enable bit
>>>> is per-thread, *or* the host is in "warn" mode (can live with split-lock #AC
>>>> being randomly disabled/enabled) and userspace has communicated to KVM that
>>>> it is pinning vCPUs.
>>>
>>> How about covering the actual sensible case: host is set to fatal?  In this
>>> mode, the guest gets split lock detection whether it wants it or not. How do
>>> we communicate this to the guest?
>>
>> KVM doesn't advertise split-lock #AC to the guest and returns -EFAULT to the
>> userspace VMM if the guest triggers a split-lock #AC.
>>
>> Effectively the same behavior as any other userspace process, just that KVM
>> explicitly returns -EFAULT instead of the process getting a SIGBUS.
> 
> 
> Which helps how if the guest is actually SLD-aware?
> 
> I suppose we could make the argument that, if an SLD-aware guest gets #AC at CPL0, it’s a bug, but it still seems rather nicer to forward the #AC to the guest instead of summarily killing it.

If KVM does advertise split-lock detection to the guest, then kvm/host 
can know whether a guest is SLD-aware by checking guest's 
MSR_TEST_CTRL.SPLIT_LOCK_DETECT bit.

  - If guest's MSR_TEST_CTRL.SPLIT_LOCK_DETECT is set, it indicates 
guest is SLD-aware so KVM forwards #AC to guest.

  - If not set. It may be a old guest or a malicious guest or a guest 
without SLD support, and we cannot figure it out. So we have to kill the 
guest when host is SLD-fatal, and let guest survive when SLD-WARN for 
old sane buggy guest.

In a word, all the above is on the condition that KVM advertise 
split-lock detection to guest. But this patch doesn't do this. Maybe I 
should add that part in v2.

> ISTM, on an SLD-fatal host with an SLD-aware guest, the host should tell the guest “hey, you may not do split locks — SLD is forced on” and the guest should somehow acknowledge it so that it sees the architectural behavior instead of something we made up.  Hence my suggestion.
> 

