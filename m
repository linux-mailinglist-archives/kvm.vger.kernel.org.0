Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3E4D78831
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2019 11:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727477AbfG2JUR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jul 2019 05:20:17 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46133 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbfG2JUQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jul 2019 05:20:16 -0400
Received: by mail-wr1-f68.google.com with SMTP id z1so60958379wru.13
        for <kvm@vger.kernel.org>; Mon, 29 Jul 2019 02:20:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uXbHp4eBJvOivXe3gCAiTk5IMqXsOx6plzKSBZNiGpQ=;
        b=bnHElU7hIKQbQfJj1pWQ6ZdQ1a6c/khnDGzBoRNLfPTf2+4hsrjC/uv2kUhsZPYrff
         oJHk1OEhoXkBQN5dmY3yUlR1YRJtovMU1B4/RW/IhbhTVBWE4PdRn9ON3Wz0tlOlXhHD
         UfYntnuBai7LRNAimqeeuRV6nnYd0HsLrAgmh4F66TJ65Mv2/lfMLm6uzMMk8mhsb/3H
         kIfSJAFJsRIApeuQ5nWfGCR1d7x5gL5puL/W0NYU+FWjvplL40CsM+I5mGj9CMAeG9hY
         sgmeQPcReL2qU5hy05ACWu9509HS+LFV+IGg5UXsm0uJkOvgj0MNToqy9XwJ6tsTMgYY
         sWyg==
X-Gm-Message-State: APjAAAUqcsseVrVQO5AFcI7Epe3w4c+ac1Pgpd3Hh9xIwgciS6DgjdJW
        aXM4Q1MRsSmVh9xL74dD7vh67w==
X-Google-Smtp-Source: APXvYqyLDdpNaY9V1WepUQO0fPV/p+GwAXZPJm4OXn15VZtBt43XB+wYaq6vIkAZVLbjYIdAAle3aw==
X-Received: by 2002:adf:e6c5:: with SMTP id y5mr124260124wrm.235.1564392014705;
        Mon, 29 Jul 2019 02:20:14 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:29d3:6123:6d5f:2c04? ([2001:b07:6468:f312:29d3:6123:6d5f:2c04])
        by smtp.gmail.com with ESMTPSA id w7sm69866212wrn.11.2019.07.29.02.20.13
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 02:20:14 -0700 (PDT)
Subject: Re: [PATCH v2 3/5] KVM: VMX: Add error handling to VMREAD helper
To:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190719204110.18306-1-sean.j.christopherson@intel.com>
 <20190719204110.18306-4-sean.j.christopherson@intel.com>
 <20190728193641.mjxrtcc6ps72z3sp@treble>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <abcf50fc-0037-446f-36a3-1bd00091ce4f@redhat.com>
Date:   Mon, 29 Jul 2019 11:20:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190728193641.mjxrtcc6ps72z3sp@treble>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/07/19 21:36, Josh Poimboeuf wrote:
> On Fri, Jul 19, 2019 at 01:41:08PM -0700, Sean Christopherson wrote:
>> @@ -68,8 +67,22 @@ static __always_inline unsigned long __vmcs_readl(unsigned long field)
>>  {
>>  	unsigned long value;
>>  
>> -	asm volatile (__ex_clear("vmread %1, %0", "%k0")
>> -		      : "=r"(value) : "r"(field));
>> +	asm volatile("1: vmread %2, %1\n\t"
>> +		     ".byte 0x3e\n\t" /* branch taken hint */
>> +		     "ja 3f\n\t"
>> +		     "mov %2, %%" _ASM_ARG1 "\n\t"
>> +		     "xor %%" _ASM_ARG2 ", %%" _ASM_ARG2 "\n\t"
>> +		     "2: call vmread_error\n\t"
>> +		     "xor %k1, %k1\n\t"
>> +		     "3:\n\t"
>> +
>> +		     ".pushsection .fixup, \"ax\"\n\t"
>> +		     "4: mov %2, %%" _ASM_ARG1 "\n\t"
>> +		     "mov $1, %%" _ASM_ARG2 "\n\t"
>> +		     "jmp 2b\n\t"
>> +		     ".popsection\n\t"
>> +		     _ASM_EXTABLE(1b, 4b)
>> +		     : ASM_CALL_CONSTRAINT, "=r"(value) : "r"(field) : "cc");
> 
> Was there a reason you didn't do the asm goto thing here like you did
> for the previous patch?  That seemed cleaner, and needs less asm.  

It's because asm goto doesn't support outputs.

Paolo

> I think the branch hints aren't needed -- they're ignored on modern
> processors.  Ditto for the previous patch.
> 
> Also please use named asm operands whereever you can, like "%[field]"
> instead of "%2".  It helps a lot with readability.
> 

