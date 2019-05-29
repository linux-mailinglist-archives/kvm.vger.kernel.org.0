Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 876562D394
	for <lists+kvm@lfdr.de>; Wed, 29 May 2019 04:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbfE2CHl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 May 2019 22:07:41 -0400
Received: from mga07.intel.com ([134.134.136.100]:46297 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725816AbfE2CHl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 May 2019 22:07:41 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 May 2019 19:07:40 -0700
X-ExtLoop1: 1
Received: from shzintpr04.sh.intel.com (HELO [0.0.0.0]) ([10.239.4.101])
  by orsmga001.jf.intel.com with ESMTP; 28 May 2019 19:07:37 -0700
Subject: Re: [PATCH v2 1/3] KVM: x86: add support for user wait instructions
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     rkrcmar@redhat.com, corbet@lwn.net, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        sean.j.christopherson@intel.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, jingqi.liu@intel.com
References: <20190524075637.29496-1-tao3.xu@intel.com>
 <20190524075637.29496-2-tao3.xu@intel.com>
 <419f62f3-69a8-7ec0-5eeb-20bed69925f2@redhat.com>
From:   Tao Xu <tao3.xu@intel.com>
Message-ID: <c1b27714-2eb8-055e-f26c-e17787d83bb6@intel.com>
Date:   Wed, 29 May 2019 10:05:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <419f62f3-69a8-7ec0-5eeb-20bed69925f2@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 29/05/2019 09:24, Paolo Bonzini wrote:
> On 24/05/19 09:56, Tao Xu wrote:
>> +7.19 KVM_CAP_ENABLE_USR_WAIT_PAUSE
>> +
>> +Architectures: x86
>> +Parameters: args[0] whether feature should be enabled or not
>> +
>> +With this capability enabled, a VM can use UMONITOR, UMWAIT and TPAUSE
>> +instructions. If the instruction causes a delay, the amount of
>> +time delayed is called here the physical delay. The physical delay is
>> +first computed by determining the virtual delay (the time to delay
>> +relative to the VM’s timestamp counter). Otherwise, UMONITOR, UMWAIT
>> +and TPAUSE cause an invalid-opcode exception(#UD).
>> +
> 
> There is no need to make it a capability.  You can just check the guest
> CPUID and see if it includes X86_FEATURE_WAITPKG.
> 
> Paolo
> 

Thank you Paolo, but I have another question. I was wondering if it is 
appropriate to enable X86_FEATURE_WAITPKG when QEMU uses "-overcommit 
cpu-pm=on"? Or just enable X86_FEATURE_WAITPKG when QEMU add the feature 
"-cpu host,+waitpkg"? User wait instructions is the wait or pause 
instructions may be executed at any privilege level, but can use 
IA32_UMWAIT_CONTROL to set the maximum time.
