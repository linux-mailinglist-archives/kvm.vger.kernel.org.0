Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E30AA7D22D
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2019 02:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728544AbfHAANn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Jul 2019 20:13:43 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36193 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726417AbfHAANm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Jul 2019 20:13:42 -0400
Received: by mail-wr1-f68.google.com with SMTP id n4so71646784wrs.3
        for <kvm@vger.kernel.org>; Wed, 31 Jul 2019 17:13:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=di1CbJV8AoCoXfsvq5UpSjzqXIQkfCIKrUbqfdd0AvI=;
        b=hWQenAlWiIhPHgH9WNKToqB+OZx/RXEWESdbTxI9sHXgjcHT91XpFCwitK4O0ObmMU
         H9ADz1DEoqpXwv+98B2b3MTNULXAOKRIoGhuw/Acxep8r7PkW9YLC00xKHjqi21szrTk
         VSu/gaSXFtZXZmxdI0VjDRteLpw1LB6kB+NgZuuHad6gIQkAEJSk6pD66gXCF2ePSHSl
         QsG7dBijN9/FqJV2r95zsHn3IgHmVsahudLMyfgiF4rKjmdr7qqRoMAMY0mhZ2DVBjX2
         wDDBxW6vmvfSa7tNQQzzMfBoAn7iFk/KcLrqKolm0ttsTq9KmcyFFYTCqV+9FtmOAXJU
         dpvA==
X-Gm-Message-State: APjAAAVB7H5kxGPhDDsMRRURj20TVTzhlRxOI5al5+gPk73/uKK5u+mc
        C8lREzMnTPuhgmB/KSYY4xorAg==
X-Google-Smtp-Source: APXvYqzxFazYeZJBnkG+SpKM3qQhT56YpMVSEbuFJQpGvOQyo/0PWWK3YBsxhva+ttJSLjvQLUamKA==
X-Received: by 2002:adf:ed41:: with SMTP id u1mr130219031wro.162.1564618420470;
        Wed, 31 Jul 2019 17:13:40 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:91e7:65e:d8cd:fdb3? ([2001:b07:6468:f312:91e7:65e:d8cd:fdb3])
        by smtp.gmail.com with ESMTPSA id j10sm121657303wrd.26.2019.07.31.17.13.39
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 17:13:39 -0700 (PDT)
Subject: Re: [PATCH RFC 3/5] x86: KVM: svm: clear interrupt shadow on all
 paths in skip_emulated_instruction()
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20190620110240.25799-1-vkuznets@redhat.com>
 <20190620110240.25799-4-vkuznets@redhat.com>
 <CALMp9eQ85h58NMDh-yOYvHN6_2f2T-wu63f+yLnNbwuG+p3Uvw@mail.gmail.com>
 <87ftmm71p3.fsf@vitty.brq.redhat.com>
 <36a9f411-f90c-3ffa-9ee3-6ebee13a763f@redhat.com>
 <CALMp9eQLCEzfdNzdhPtCf3bD-5c6HrSvJqP7idyoo4Gf3i5O1w@mail.gmail.com>
 <20190731233731.GA2845@linux.intel.com>
 <CALMp9eRRqCLKAL4FoZVMk=fHfnrN7EnTVxR___soiHUdrHLAMQ@mail.gmail.com>
 <20190731235637.GB2845@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <46f3cf18-f167-f66e-18b4-b66c8551dcd8@redhat.com>
Date:   Thu, 1 Aug 2019 02:13:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190731235637.GB2845@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/08/19 01:56, Sean Christopherson wrote:
> On Wed, Jul 31, 2019 at 04:45:21PM -0700, Jim Mattson wrote:
>> On Wed, Jul 31, 2019 at 4:37 PM Sean Christopherson
>> <sean.j.christopherson@intel.com> wrote:
>>
>>> At a glance, the full emulator models behavior correctly, e.g. see
>>> toggle_interruptibility() and setters of ctxt->interruptibility.
>>>
>>> I'm pretty sure that leaves the EPT misconfig MMIO and APIC access EOI
>>> fast paths as the only (VMX) path that would incorrectly handle a
>>> MOV/POP SS.  Reading the guest's instruction stream to detect MOV/POP SS
>>> would defeat the whole "fast path" thing, not to mention both paths aren't
>>> exactly architecturally compliant in the first place.
>>
>> The proposed patch clears the interrupt shadow in the VMCB on all
>> paths through svm's skip_emulated_instruction. If this happens at the
>> tail end of emulation, it doesn't matter if the full emulator does the
>> right thing.
> 
> Unless I'm missing something, skip_emulated_instruction() isn't called in
> the emulation case, x86_emulate_instruction() updates %rip directly, e.g.:

Indeed.  skip_emulated_instruction() is only used when the vmexit code
takes care of emulation directly.

Paolo

> 	if (writeback) {
> 		unsigned long rflags = kvm_x86_ops->get_rflags(vcpu);
> 		toggle_interruptibility(vcpu, ctxt->interruptibility);
> 		vcpu->arch.emulate_regs_need_sync_to_vcpu = false;
> 		kvm_rip_write(vcpu, ctxt->eip);
> 		if (r == EMULATE_DONE && ctxt->tf)
> 			kvm_vcpu_do_singlestep(vcpu, &r);
> 		if (!ctxt->have_exception ||
> 		    exception_type(ctxt->exception.vector) == EXCPT_TRAP)
> 			__kvm_set_rflags(vcpu, ctxt->eflags);
> 
> 		/*
> 		 * For STI, interrupts are shadowed; so KVM_REQ_EVENT will
> 		 * do nothing, and it will be requested again as soon as
> 		 * the shadow expires.  But we still need to check here,
> 		 * because POPF has no interrupt shadow.
> 		 */
> 		if (unlikely((ctxt->eflags & ~rflags) & X86_EFLAGS_IF))
> 			kvm_make_request(KVM_REQ_EVENT, vcpu);
> 	}
> 

