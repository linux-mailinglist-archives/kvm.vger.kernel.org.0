Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A296A42DB69
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 16:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231839AbhJNOZl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 10:25:41 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:42922 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230030AbhJNOZl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 10:25:41 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634221415;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J704+ZpmNiG6G+UV4gpbHRzSAjI0YA9l6NLka/xr/hM=;
        b=4XDFt/meAmEBqm2bXsSOvDvyeCn7FSTkyTiJP66ZC7rw4BltuOrBvoYSkya9pThKCN7S0Q
        wUTx/D3oknBz3lXPGIrx6EcIro1ftGRrLmXT8y0JOZ8VxNM/GBGr2JOybwG32kBoB8ejUK
        brf2Dmzo+n5A9YZzYksICGsf4fScM5MU9z8rr8cZZP91SjbW8bWSPFdfiS/4IuQKLLs7oo
        tEKtDgTwer/rEFF4WSkjwlHo04Uo32icxKy7gwVbnGElsmyyTFt6eHIcym81Xbi90Q8AF/
        RuWtmtqkCkjRPClhuORlNsFvcGunfLB3OfVj9phCO56UgPkvbzYXUU3vyO6PWg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634221415;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J704+ZpmNiG6G+UV4gpbHRzSAjI0YA9l6NLka/xr/hM=;
        b=1JT1nsyY6wMrFXLqEVVa6oy17JxPi1RepbaCts8WFUOt/rePuWTvfp7zPLQ+tw1YVmFEaK
        1DSVP9v4mKpc7BCQ==
To:     Paolo Bonzini <pbonzini@redhat.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     "x86@kernel.org" <x86@kernel.org>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "seanjc@google.com" <seanjc@google.com>,
        Andrew Cooper <andrew.cooper3@citrix.com>
Subject: Re: [patch 13/31] x86/fpu: Move KVMs FPU swapping to FPU core
In-Reply-To: <0a5aa9d3-e0d4-266e-5e25-021a5ea9c611@redhat.com>
References: <871r4p9fyh.ffs@tglx>
 <ec9c761d-4b5c-71e2-c1fc-d256b6b78c04@redhat.com> <875ytz7q2u.ffs@tglx>
 <0a5aa9d3-e0d4-266e-5e25-021a5ea9c611@redhat.com>
Date:   Thu, 14 Oct 2021 16:23:34 +0200
Message-ID: <87tuhj65y1.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 14 2021 at 14:26, Paolo Bonzini wrote:
> On 14/10/21 14:23, Thomas Gleixner wrote:
>>> In principle I don't like it very much; it would be nicer to say "you
>>> enable it for QEMU itself via arch_prctl(ARCH_SET_STATE_ENABLE), and for
>>> the guests via ioctl(KVM_SET_CPUID2)".  But I can see why you want to
>>> keep things simple, so it's not a strong objection at all.
>> Errm.
>> 
>>     qemu()
>>       read_config()
>>       if (dynamic_features_passthrough())
>> 	request_permission(feature)             <- prctl(ARCH_SET_STATE_ENABLE)
>> 
>>       create_vcpu_threads()
>>         ....
>> 
>>         vcpu_thread()
>> 	 kvm_ioctl(ENABLE_DYN_FEATURE, feature) <- KVM ioctl
>> 
>> That's what I lined out, right?
>> 
>
> I meant prctl for QEMU-in-user-mode vs. ioctl QEMU-in-guest-mode (i.e. 
> no prctl if only the guest uses it).  But anyway it's just abstract 
> "beauty", let's stick to simple. :)

It's not about simple. It's about correctness in the first place.

The prctl() is process wide and grants permission. If that permission is
not granted, e.g. by a seccomp rule, then the vCPU threads cannot use it
either. We are _not_ making exceptions for KVM just because it's KVM.

Trying to pretend that the usermode thread does not need it is just
illusion. The kernel representation of that very usermode vCPU thread must
have a large fpstate. It still can have XFD set, but that's a detail.

So what you are trying to sell me has nothing to do with beauty at all
except when your definition of beauty originates from a tunnel of horrors.

Thanks,

        tglx
