Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A800D66F76
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 15:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727415AbfGLNCq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 09:02:46 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:46705 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727045AbfGLNCq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 09:02:46 -0400
Received: by mail-qt1-f195.google.com with SMTP id h21so7901918qtn.13;
        Fri, 12 Jul 2019 06:02:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h9V1PDslHCmVXYBI8dBvQZXVzo3DG4NQfAvbqRPJOTM=;
        b=J7lMChKQxsJgULgOjlM41ZmKw7/pENfAsG/D+7sf+VNxonhUEX941qNenw/40b9zG7
         rVG1ECPv0KTEPHSduSbvLmWfZJ+xtIlOeBAw80vhWNT1W6e9pK47z2WZgTXzBo03lDot
         Ej9gQNlMhTROvHh/Fsm3tyCWwDDN6FDGlyfgx1vMH5Y5Qkbh1OwubSPv4qWROQb2tlzV
         ++UwSddk7xN7qV4RZBL8aLdqJOWGN+dS7s9wKq2jh9UCHTzLrjGPJzbgeJ6gC5pHJ9V+
         QYkNiYtacZ2pcybLds8QuhLqt8dmc+7c8nyAaxVCsk118iYHHZODX5HMlbcXXlZ8uEaF
         MBOg==
X-Gm-Message-State: APjAAAXXNEbU4hJceQdUnBJIKSFubYvE8OxOm2ZAtU6HbFRkylfwDjag
        15G2Nghh7oAQyhsK0mDf9Q/cVhXj32HOOvC9N7w=
X-Google-Smtp-Source: APXvYqx3UBdn2uY78OgPzqrMWqQ/IsUoW5hiUWWOdKRO3otUEfKOHb8iFZH28gCSq3SHGEduVDjXSYi60ntwA3HpyEk=
X-Received: by 2002:a0c:e952:: with SMTP id n18mr6222517qvo.63.1562936565085;
 Fri, 12 Jul 2019 06:02:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190712091239.716978-1-arnd@arndb.de> <20190712120249.GA27820@rkaganb.sw.ru>
In-Reply-To: <20190712120249.GA27820@rkaganb.sw.ru>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 12 Jul 2019 15:02:28 +0200
Message-ID: <CAK8P3a3+QSRQkitXiDFLYvyYvOS+Q4sXb=xA_XPeX2O2zQ5kgw@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86: kvm: avoid -Wsometimes-uninitized warning
To:     Roman Kagan <rkagan@virtuozzo.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Liran Alon <liran.alon@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 12, 2019 at 2:03 PM Roman Kagan <rkagan@virtuozzo.com> wrote:
>
> On Fri, Jul 12, 2019 at 11:12:29AM +0200, Arnd Bergmann wrote:
> > clang points out that running a 64-bit guest on a 32-bit host
> > would lead to uninitialized variables:
> >
> > arch/x86/kvm/hyperv.c:1610:6: error: variable 'ingpa' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
> >         if (!longmode) {
> >             ^~~~~~~~~
> > arch/x86/kvm/hyperv.c:1632:55: note: uninitialized use occurs here
> >         trace_kvm_hv_hypercall(code, fast, rep_cnt, rep_idx, ingpa, outgpa);
> >                                                              ^~~~~
> > arch/x86/kvm/hyperv.c:1610:2: note: remove the 'if' if its condition is always true
> >         if (!longmode) {
> >         ^~~~~~~~~~~~~~~
> > arch/x86/kvm/hyperv.c:1595:18: note: initialize the variable 'ingpa' to silence this warning
> >         u64 param, ingpa, outgpa, ret = HV_STATUS_SUCCESS;
> >                         ^
> >                          = 0
> > arch/x86/kvm/hyperv.c:1610:6: error: variable 'outgpa' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
> > arch/x86/kvm/hyperv.c:1610:6: error: variable 'param' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
> >
> > Since that combination is not supported anyway, change the condition
> > to tell the compiler how the code is actually executed.
>
> Hmm, the compiler *is* told all it needs:
>
>
> arch/x86/kvm/x86.h:
> ...
> static inline int is_long_mode(struct kvm_vcpu *vcpu)
> {
> #ifdef CONFIG_X86_64
>         return vcpu->arch.efer & EFER_LMA;
> #else
>         return 0;
> #endif
> }
>
> static inline bool is_64_bit_mode(struct kvm_vcpu *vcpu)
> {
>         int cs_db, cs_l;
>
>         if (!is_long_mode(vcpu))
>                 return false;
>         kvm_x86_ops->get_cs_db_l_bits(vcpu, &cs_db, &cs_l);
>         return cs_l;
> }
> ...
>
> so in !CONFIG_X86_64 case is_64_bit_mode() unconditionally returns
> false, and the branch setting the values of the variables is always
> taken.

I think what happens here is that clang does not treat the return
code of track the return code of is_64_bit_mode() as a constant
expression, and therefore assumes that the if() condition
may or may not be true, for the purpose of determining whether
the variable is used without an inialization. This would hold even
if it later eliminates the code leading up to the if() in an optimization
stage. IS_ENABLED(CONFIG_X86_64) however is a constant
expression, so with the patch, it understands this.

In contrast, gcc seems to perform all the inlining first, and
then see if some variable is used uninitialized in the final code.
This gives additional information to the compiler, but makes the
outcome less predictable since it depends on optimization flags
and architecture specific behavior.

Both approaches have their own sets of false positive and false
negative warnings.

       Arnd
