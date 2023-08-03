Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA3A376DC6E
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 02:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjHCAOZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 20:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjHCAOY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 20:14:24 -0400
Received: from mailtransmit04.runbox.com (mailtransmit04.runbox.com [IPv6:2a0c:5a00:149::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A6ACE4C
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 17:14:22 -0700 (PDT)
Received: from mailtransmit02.runbox ([10.9.9.162] helo=aibo.runbox.com)
        by mailtransmit04.runbox.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <mhal@rbox.co>)
        id 1qRLyt-003Bzv-61; Thu, 03 Aug 2023 02:14:19 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=rbox.co;
        s=selector1; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID;
        bh=IMQDFJIkfKnwYtJ6mv8Y8A1YfnrZI8Kox++gEWmy8T4=; b=AdT47cjjR1uWrT9LyFTKpwh9Mj
        L6G3lb7TMLV3WOGKDsIWh29FzKYIkHLUbP5pEX+jLZRE6NRbeHvG+bpB4NFzdXxS9ksxrmnx84DUa
        YQkAyelMj5Kf88smYgp0AkvajDFX7+EZjHw5iVlmW5DeJPmUDNGlfABIHbmIl2A/mgf6GY1m7X2YH
        WMlznU24z5lHDYVNEdduSE4duKMKgZVUBGbp0zs9ECKyzX7VU2HGdNdZbseDW9Sim7o+QdtdFj1RI
        yFHe/JZSH+zJlX5k36zDpj7TrUP6TmPI3/IfbBu9GSIhBzdlSTA61fdb+Xajo0BGq4L7tFT+jmxvR
        vpX9yUeg==;
Received: from [10.9.9.73] (helo=submission02.runbox)
        by mailtransmit02.runbox with esmtp (Exim 4.86_2)
        (envelope-from <mhal@rbox.co>)
        id 1qRLys-0007ks-JL; Thu, 03 Aug 2023 02:14:18 +0200
Received: by submission02.runbox with esmtpsa  [Authenticated ID (604044)]  (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        id 1qRLya-0008EN-6i; Thu, 03 Aug 2023 02:14:00 +0200
Message-ID: <38f69410-d794-6eae-387a-481417c6b323@rbox.co>
Date:   Thu, 3 Aug 2023 02:13:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] KVM: x86: Fix KVM_CAP_SYNC_REGS's sync_regs() TOCTOU
 issues
Content-Language: pl-PL, en-GB
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org, shuah@kernel.org
References: <20230728001606.2275586-1-mhal@rbox.co>
 <20230728001606.2275586-2-mhal@rbox.co> <ZMhIlj+nUAXeL91B@google.com>
 <7e24e0b1-d265-2ac0-d411-4d6f4f0c1383@rbox.co> <ZMqr/A1O4PPbKfFz@google.com>
From:   Michal Luczaj <mhal@rbox.co>
In-Reply-To: <ZMqr/A1O4PPbKfFz@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/2/23 21:18, Sean Christopherson wrote:
> On Tue, Aug 01, 2023, Michal Luczaj wrote:
>> All right, so assuming the revert is not happening and the API is not misused
>> (i.e. unless vcpu->run->kvm_valid_regs is set, no one is expecting up to date
>> values in vcpu->run->s.regs), is assignment copying
>>
>> 	struct kvm_vcpu_events events = vcpu->run->s.regs.events;
>>
>> the right approach or should it be a memcpy(), like in ioctl handlers?
> 
> Both approaches are fine, though I am gaining a preference for the copy-by-value
> method.  With gcc-12 and probably most compilers, the code generation is identical
> for both as the compiler generates a call to memcpy() to handle the the struct
> assignment.
> 
> The advantage of copy-by-value for structs, and why I think I now prefer it, is
> that it provides type safety.  E.g. this compiles without complaint
> 
> 	memcpy(&events, &vcpu->run->s.regs.sregs, sizeof(events));
> 
> whereas this
> 
> 	struct kvm_vcpu_events events = vcpu->run->s.regs.sregs;
> 
> yields
> 
>   arch/x86/kvm/x86.c: In function ‘sync_regs’:
>   arch/x86/kvm/x86.c:11793:49: error: invalid initializer
>   11793 |                 struct kvm_vcpu_events events = vcpu->run->s.regs.sregs;
>         |                                                 ^~~~
> 
> The downside is that it's less obvious when reading the code that there is a
> large-ish memcpy happening, but IMO it's worth gaining the type safety.

Sure, that makes sense. I was a bit concerned how a padding within a struct
might affect performance of such copy-by-value, but (obviously?) there's no
padding in kvm_sregs, nor kvm_vcpu_events...

Anyway, while there, could you take a look at __set_sregs_common()?

	*mmu_reset_needed |= kvm_read_cr0(vcpu) != sregs->cr0;
	static_call(kvm_x86_set_cr0)(vcpu, sregs->cr0);
	vcpu->arch.cr0 = sregs->cr0;

That last assignment seems redundant as both vmx_set_cr0() and svm_set_cr0()
take care of it, but I may be missing something (even if selftests pass with
that line removed).

thanks,
Michal

