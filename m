Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 149A66E4BA
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2019 13:09:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727373AbfGSLJH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jul 2019 07:09:07 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54953 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbfGSLJH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jul 2019 07:09:07 -0400
Received: by mail-wm1-f65.google.com with SMTP id p74so28383040wme.4
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2019 04:09:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jZTpt124xkvIC199mqq/Y1JoK7GIwu0z9IqI5bP/sDw=;
        b=b87U0uB0GRbwAlrHFbC6KSzwac4kCEZ0GnUjgHFehLJ37bSs7NkoAcNucRDBuLgaE2
         lIDpsps4Ef4oCZdNvag+hOK6tHk5T0Dx/nu0Ai0RkGQVVXiHfUJuysbd4iRwcA1P7lLk
         jQn7PO1+jokOwzBMmZyTcvusJNeBkpuRw16d9KrHa2X8SLuqhisXxbrx5VJTfF7Owfs1
         9BerNvQohpZF75aE1XhETTPqZq/a1HOtJd4I6CM07fvKD3bzC+6tma/uZixjnbgmyn+F
         v/cS/qRqcDuPFcDBXoW68W4EI7KN20Yd4NM9ERo/bT7fdHdamuOGJwdsnAe+gasRm87k
         sOzA==
X-Gm-Message-State: APjAAAX+InzolTXQhc/wPrB6Id8gHw+fqZrhwosSl5bh9inzcX3VJU4g
        kuXBs6MA/HWSi8Y/uYjhayD0uA==
X-Google-Smtp-Source: APXvYqy8J64o/W1vhWCroMIOpTpGntL1yVyaLhpT/aa7pg1hpD5LFTyt3PBsqrwCwNryxxXKXqVQVA==
X-Received: by 2002:a7b:c215:: with SMTP id x21mr47986773wmi.38.1563534544929;
        Fri, 19 Jul 2019 04:09:04 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:8501:6b03:f18c:74f8? ([2001:b07:6468:f312:8501:6b03:f18c:74f8])
        by smtp.gmail.com with ESMTPSA id l2sm20503956wmj.4.2019.07.19.04.09.03
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Jul 2019 04:09:04 -0700 (PDT)
Subject: Re: [5.2 regression] x86/fpu changes cause crashes in KVM guest
To:     Wanpeng Li <kernellwp@gmail.com>,
        Thomas Lambertz <mail@thomaslambertz.de>
Cc:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Rik van Riel <riel@surriel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Radim Krcmar <rkrcmar@redhat.com>, kvm <kvm@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Marc Orr <marcorr@google.com>,
        Dave Hansen <dave.hansen@intel.com>
References: <217248af-e980-9cb0-ff0d-9773413b9d38@thomaslambertz.de>
 <CANRm+CxWbkr0=DB7DBdaQOsTTt0XS5vSk_BRL2iFeAAm81H8Bg@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <3ae96202-a121-70a9-fe00-4b5bb4970242@redhat.com>
Date:   Fri, 19 Jul 2019 13:09:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CANRm+CxWbkr0=DB7DBdaQOsTTt0XS5vSk_BRL2iFeAAm81H8Bg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/07/19 10:59, Wanpeng Li wrote:
> https://lkml.org/lkml/2017/11/14/891, "The scheduler will save the
> guest fpu context when a vCPU thread is preempted, and restore it when
> it is scheduled back in." But I can't find any scheduler codes do
> this.

That's because applying commit 240c35a37 was completely wrong.  The idea
before commit 240c35a37 was that you have the following FPU states:

               userspace (QEMU)             guest
---------------------------------------------------------------------------
               processor                    vcpu->arch.guest_fpu
>>> KVM_RUN: kvm_load_guest_fpu
               vcpu->arch.user_fpu          processor
>>> preempt out
               vcpu->arch.user_fpu          current->thread.fpu
>>> preempt in
               vcpu->arch.user_fpu          processor
>>> back to userspace
>>> kvm_put_guest_fpu
               processor                    vcpu->arch.guest_fpu
---------------------------------------------------------------------------

After removing user_fpu, QEMU's FPU state is destroyed when KVM_RUN is
preempted.  So that's already messed up (I'll send a revert), and given
the diagram above your patch makes total sense.

With the new lazy model we want to hook into kvm_vcpu_arch_load and get
the state back to the processor from current->thread.fpu, and indeed
switch_fpu_return is essentially copy_kernel_to_fpregs(&current->thread.
fpu->state).

However I would keep the fpregs_assert_state_consistent in
kvm_arch_vcpu_load, and also
WARN_ON_ONCE(test_thread_flag(TIF_NEED_FPU_LOAD)) in vcpu_enter_guest.

Paolo
