Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6E6FD0B8B
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 11:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729918AbfJIJmU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 05:42:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38972 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726734AbfJIJmU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 05:42:20 -0400
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8634A2A09A1
        for <kvm@vger.kernel.org>; Wed,  9 Oct 2019 09:42:19 +0000 (UTC)
Received: by mail-wm1-f71.google.com with SMTP id k9so804390wmb.0
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2019 02:42:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2SfK+bwB/cF2Z8hlX+aReQdgBCXk+L/5n2wFayhP4Gk=;
        b=IPjB5bWHdSnAlYmsLTQhiSc4YsQdOi5QUOfr04ZiPXcFScxO+llj8jINdUvM778JRz
         7eZzXCEae2QdCDuWwvJJP00N3c0OLeQkQaGzD7iFl6yAU1YjEDxNV52tBopLzuBXoYT2
         e9JNKtepj6BWyhemnnpQ568N7Y7ZeSubD7luHMT9HihzpN3VM2j7e65YyiU8LFxRSvnS
         CJ6ysMGj5GxNX0sXb/VK55fGx6URQggglSwGKJo/7X1BAGUkMeDAewMbkZI6PJr7EPiy
         xOPfbis9ufeqfnmPX+LcyitG9yA9DDMxKn5mhiXPBcZZb2VxFtaxDuFCYrr7XcJro3ja
         awtw==
X-Gm-Message-State: APjAAAUWfk3FekPcfT+OREHYo9T8ghtzY6+CxS3vg+VdyTA67hWCdEGQ
        eeyhT1aEeRrTCxLRh3+kiELgWm5FOfDebd9cgmwxgd0fIfpstF66OHCC3pk1sKw/Rgom8tXByZ6
        TUZaTXtxcLS1h
X-Received: by 2002:a1c:a8c9:: with SMTP id r192mr1857211wme.152.1570614138030;
        Wed, 09 Oct 2019 02:42:18 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyKjouqMbMNxTFuGL86nTyCiQqhfx17sz5oE1whEuLV7eS6sbY4ojO1la5n7F9GzBChRhx60g==
X-Received: by 2002:a1c:a8c9:: with SMTP id r192mr1857192wme.152.1570614137681;
        Wed, 09 Oct 2019 02:42:17 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id c9sm1607213wrt.7.2019.10.09.02.42.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2019 02:42:17 -0700 (PDT)
Subject: Re: [PATCH] selftests: kvm: fix sync_regs_test with newer gccs
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Mattson <jmattson@google.com>
References: <20191008180808.14181-1-vkuznets@redhat.com>
 <20191008183634.GF14020@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <b7d20806-4e88-91af-31c1-8cbb0a8a330b@redhat.com>
Date:   Wed, 9 Oct 2019 11:42:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191008183634.GF14020@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/10/19 20:36, Sean Christopherson wrote:
> On Tue, Oct 08, 2019 at 08:08:08PM +0200, Vitaly Kuznetsov wrote:
>> Commit 204c91eff798a ("KVM: selftests: do not blindly clobber registers in
>>  guest asm") was intended to make test more gcc-proof, however, the result
>> is exactly the opposite: on newer gccs (e.g. 8.2.1) the test breaks with
>>
>> ==== Test Assertion Failure ====
>>   x86_64/sync_regs_test.c:168: run->s.regs.regs.rbx == 0xBAD1DEA + 1
>>   pid=14170 tid=14170 - Invalid argument
>>      1	0x00000000004015b3: main at sync_regs_test.c:166 (discriminator 6)
>>      2	0x00007f413fb66412: ?? ??:0
>>      3	0x000000000040191d: _start at ??:?
>>   rbx sync regs value incorrect 0x1.
>>
>> Apparently, compile is still free to play games with registers even
>> when they have variables attaches.
>>
>> Re-write guest code with 'asm volatile' by embedding ucall there and
>> making sure rbx is preserved.
>>
>> Fixes: 204c91eff798a ("KVM: selftests: do not blindly clobber registers in guest asm")
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>>  .../selftests/kvm/x86_64/sync_regs_test.c     | 21 ++++++++++---------
>>  1 file changed, 11 insertions(+), 10 deletions(-)
>>
>> diff --git a/tools/testing/selftests/kvm/x86_64/sync_regs_test.c b/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
>> index 11c2a70a7b87..5c8224256294 100644
>> --- a/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
>> +++ b/tools/testing/selftests/kvm/x86_64/sync_regs_test.c
>> @@ -22,18 +22,19 @@
>>  
>>  #define VCPU_ID 5
>>  
>> +#define UCALL_PIO_PORT ((uint16_t)0x1000)
>> +
>> +/*
>> + * ucall is embedded here to protect against compiler reshuffling registers
>> + * before calling a function. In this test we only need to get KVM_EXIT_IO
>> + * vmexit and preserve RBX, no additional information is needed.
>> + */
>>  void guest_code(void)
>>  {
>> -	/*
>> -	 * use a callee-save register, otherwise the compiler
>> -	 * saves it around the call to GUEST_SYNC.
>> -	 */
>> -	register u32 stage asm("rbx");
>> -	for (;;) {
>> -		GUEST_SYNC(0);
>> -		stage++;
>> -		asm volatile ("" : : "r" (stage));
>> -	}
>> +	asm volatile("1: in %[port], %%al\n"
>> +		     "add $0x1, %%rbx\n"
>> +		     "jmp 1b"
>> +		     : : [port] "d" (UCALL_PIO_PORT) : "rax", "rbx");
>>  }
> 
> To make the code truly bulletproof, is it possible to rename guest_code()
> to guest_code_wrapper() and then export 1: as guest_code?  VM-Enter will
> jump directly to the relevant code and gcc can't touch rbx.  E.g.:
> 
> 	asm volatile("1: ..."
> 		     ".global guest_code"
> 		     "guest_code: " _ASM_PTR " 1b");
> 
> Not sure if that works with how the selftests are compiled.  It may also
> be possible to simply replace '1' with 'guest_code'.

There is no practical difference with Vitaly's patch.  The first
_vcpu_run has no pre-/post-conditions on the value of %rbx:


        run->kvm_valid_regs = TEST_SYNC_FIELDS;
        rv = _vcpu_run(vm, VCPU_ID);
        TEST_ASSERT(run->exit_reason == KVM_EXIT_IO,
                    "Unexpected exit reason: %u (%s),\n",
                    run->exit_reason,
                    exit_reason_str(run->exit_reason));

	/*
	 * Then it goes on comparing regs/sregs/events, but does not
	 * check for specific values.
	 */

As soon as that first _vcpu_run succeeds, you're stuck in the in/add/jmp
loop and the compiler can't trick you anymore.

So, I'm queuing the patch.

Paolo
