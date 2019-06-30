Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30FF25AF24
	for <lists+kvm@lfdr.de>; Sun, 30 Jun 2019 08:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbfF3Gzb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 30 Jun 2019 02:55:31 -0400
Received: from mail-wr1-f54.google.com ([209.85.221.54]:34056 "EHLO
        mail-wr1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726472AbfF3Gzb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 30 Jun 2019 02:55:31 -0400
Received: by mail-wr1-f54.google.com with SMTP id u18so2182942wru.1
        for <kvm@vger.kernel.org>; Sat, 29 Jun 2019 23:55:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=od0HGtdQejkc16RH2XBKNiam3rdxQj6ExHBag0tSd8U=;
        b=Es2ebM6ZrO6ute71HomWGOavYQ1UT/i5Ex33fSQRqR9TEhI+Knf2z5pnlKPWXgR7oF
         eXxGLxYtG7Qlklj23xa+vXnHzeCb2yWUmSdZEYovYJVbZViQwop5/KplNmQXrtTMy3gt
         o3g3AgvZrCQDY11rhadUUo5wb0TdZeE0aMNlJqSeWB3VWXeUa46T2f+NmvyF5yw1guus
         NXmG3veVPK0DS/7+p0AObE3vM9EAGpxmuezgSJ+4O6R0jB2jSSKJzvvwIgQXnHZEk8Vg
         kVZ2MR3JSabKRorSvObrUDoQUreTMouIZFn7fX8bdbRabd/cIfHskjtpVvzEvKSjKidB
         dbIg==
X-Gm-Message-State: APjAAAXzrLbqcsJK1sfSRidB5TNtsn+DE42ckmpbwFK02+zWFuTeYVVm
        UwOJS+HVJEKnLwmvN1VTCDvi7A==
X-Google-Smtp-Source: APXvYqwtUxkzcoym0UpkofxXtGnzP75QiwDrbDy8PmDXSYFbOXb299mg6EFYG0jzTtjCnkpLaRRgeQ==
X-Received: by 2002:adf:dd89:: with SMTP id x9mr9227898wrl.7.1561877729065;
        Sat, 29 Jun 2019 23:55:29 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:a5c0:d60f:9764:1c58? ([2001:b07:6468:f312:a5c0:d60f:9764:1c58])
        by smtp.gmail.com with ESMTPSA id l8sm16776461wrg.40.2019.06.29.23.55.27
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sat, 29 Jun 2019 23:55:28 -0700 (PDT)
Subject: Re: KVM's SYSCALL emulation for GenuineIntel is buggy
To:     Andy Lutomirski <luto@kernel.org>, kvm list <kvm@vger.kernel.org>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <CALCETrU8k1mL=Uy_QNbT7fjtCLO8N3xgZb6zLyfdwHx6SUFPoA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a75e8b4e-c275-485f-13ac-8f4f77a311d1@redhat.com>
Date:   Sun, 30 Jun 2019 08:55:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CALCETrU8k1mL=Uy_QNbT7fjtCLO8N3xgZb6zLyfdwHx6SUFPoA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/06/19 07:16, Andy Lutomirski wrote:
> If I do SYSCALL with EFLAGS.TF set from compat mode on Intel hardware
> with -cpu host and no other funny business, the guest kernel seems to
> get #DB with the stored IP pointing at the SYSCALL instruction.  This
> is wrong -- SYSCALL is #UD, which is a *fault*, so there shouldn't be
> a single-step trap.

Yeah, the emulator doesn't try too hard to emulate Intel vs. AMD
differences.  But emulate_ud()'s mishandling

> Unless I'm missing something in the code, emulate_ud() is mishandled
> in general -- it seems to make cause inject_emulated_exception() to
> return false here:
> 
>     if (ctxt->have_exception) {
>         r = EMULATE_DONE;
>         if (inject_emulated_exception(vcpu))
>             return r;
> 
> and then we land here:
> 
>         if (r == EMULATE_DONE && ctxt->tf)
>             kvm_vcpu_do_singlestep(vcpu, &r);
> 
> if TF was set, which is wrong.
> 
> You can test this by applying the attached patch, building x86
> selftests, and running syscall_arg_fault_32 in a VM.  It hangs.  It
> should complete successfully, and it does on bare metal.

Ok, this is helpful.  inject_emulated_exception should return one of
vmexit (currently true), fault (the incorrect case), none (currently
false).  Thanks!

Paolo
