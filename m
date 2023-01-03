Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90A0D65C923
	for <lists+kvm@lfdr.de>; Tue,  3 Jan 2023 23:06:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238486AbjACWG3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Jan 2023 17:06:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238474AbjACWGW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Jan 2023 17:06:22 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67F11DF45
        for <kvm@vger.kernel.org>; Tue,  3 Jan 2023 14:05:55 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id jl4so27811889plb.8
        for <kvm@vger.kernel.org>; Tue, 03 Jan 2023 14:05:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DBiYj/CqsyiaH9RFwmnSJOy5jZp1JD0bvTrCVeBY6Vc=;
        b=cgIA6FRWsIO7xTeGspHM8BHSDhhSgEypArJtwFK8ITVgXCpxM4k8TUqoyidjrojGM3
         sYLvJ25aruHGjO74Pjyie5zNBNn+QkG5akOFEXk+QPajkKNJEZODog5/J+HGuBxr9yK/
         2KzCAtcs4E3zghWp9Neaulo3M1HcBXFVcTwePYym9V8w10C+OxT9VSt4oBVJFUuXkqlV
         lADb1U2tHC5mRsBdEL7SXR+7EBeZrYijdeauYt/JNDZ9SYdgA9qk8Z1O3hn7btJo4Pp+
         E+8tuvhLVV2pOgSdqChQd3H1u/xMot8y9EyD2yHOpBRnLrXec0nmRxpvNPlCNNkj+OFt
         +3XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DBiYj/CqsyiaH9RFwmnSJOy5jZp1JD0bvTrCVeBY6Vc=;
        b=bWOu6rEYR8rixUUPnqbheN4XUdVFOTAA0ZHcHyl9xb+DqZZEqgIJk7eA33x9J+80JX
         PPulkwd4m61ynIv8Bpo6ObXa11JEsPIlxwyzPNagsUR61KrfHLkeUE8Auj4lI9V/QeZO
         XqhVCyqHKjqDd3TvJdPMTQMG+lQAVitgphAdYTzUDKk5uuR20wJHpJoWNefVMNbDW6Jm
         aP/mAgYiLW1XCNvprSuma0KBzICEGyk3FK1mUuDBS7rWJ5wJJHlqN+s2pz7EtQWgl6MK
         kukpXXzfcVnFelqMuWB/A2jR4bg63JuH1AjpQGb53wmJvk2MS+VM5NyRw2kWMGcgHqQ/
         JgpQ==
X-Gm-Message-State: AFqh2kpecXMRroRGDl0FSO6Zkl69RUQmxvsFM2saNezZsqHURQwAsXmi
        b3CQsZSYc0Abpxsy7SGIdcpZwQ==
X-Google-Smtp-Source: AMrXdXvfE5QAa6UJpfajzQnsKPvXC4FRWqWAGMNqrygmLUemDR/lANU8kq+G2Flg/nu8aeHDTQMULg==
X-Received: by 2002:a17:90a:6395:b0:226:5758:a57f with SMTP id f21-20020a17090a639500b002265758a57fmr158179pjj.2.1672783554791;
        Tue, 03 Jan 2023 14:05:54 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id y15-20020a17090ad70f00b00218daa55e5fsm19518447pju.12.2023.01.03.14.05.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 14:05:53 -0800 (PST)
Date:   Tue, 3 Jan 2023 22:05:50 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     bugzilla-daemon@kernel.org
Cc:     kvm@vger.kernel.org
Subject: Re: [Bug 216867] New: KVM instruction emulation breaks LOCK
 instruction atomicity when CMPXCHG fails
Message-ID: <Y7SmvpSjkvwjlrnO@google.com>
References: <bug-216867-28872@https.bugzilla.kernel.org/>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-216867-28872@https.bugzilla.kernel.org/>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 30, 2022, bugzilla-daemon@kernel.org wrote:
 
> My code performs the following experiment repeatedly on 3 CPUs:
> 
> * Initially, "ptr" at address 0xb8000 (VGA memory mapped I/O) is set to 0
> * CPU 0 writes 0x12345678 to ptr, then increases counter "count0".
> * In an infinite loop, CPU 1 tries exchanges ptr with register EAX (contains 0)
> using the XCHG instruction. If CPU 1 sees 0x12345678, it increases counter
> "count1".
> * CPU 2's behavior is similar to CPU 1, except it increases counter "count2"
> when it sees 0x12345678.
> 
> Ideally, after each experiment there should always be count1 + count2 = count0.
> However, in KVM, there may be count1 + count2 > count0. This because CPU 0
> writes 0x12345678 to ptr once, but CPU 1 and CPU 2 both get 0x12345678 in XCHG.
> Note that XCHG instruction always implements the locking protocol.
> 
> There is also a deadlock after running the experiment a few times. However I am
> not trying to explain it for now.

Is the suspect deadlock in userspace, the guest, or in the host kernel?

> Guessed cause:
> 
> I guess that KVM emulates the XCHG instruction that accesses 0xb8000. The call
> stack should be:
> 
> ...
>  x86_emulate_instruction (arch/x86/kvm/x86.c)
>   x86_emulate_insn (arch/x86/kvm/emulate.c)
>    writeback (arch/x86/kvm/emulate.c)
>     segmented_cmpxchg (arch/x86/kvm/emulate.c)
>      emulator_cmpxchg_emulated (arch/x86/kvm/x86.c, ->cmpxchg_emulated)
>       emulator_try_cmpxchg_user (arch/x86/kvm/x86.c)
>        ...
>         CMPXCHG instruction
> 
> Suppose CPU 2 wants to write 0 to ptr using writeback(), and expecting ptr to
> already contain 0x13245678. However, CPU 1 changes the content of ptr to 0. So
> * The CMPXCHG instruction fails (clears ZF).
> * emulator_try_cmpxchg_user returns 1.
> * emulator_cmpxchg_emulated() returns X86EMUL_CMPXCHG_FAILED.
> * segmented_cmpxchg() returns X86EMUL_CMPXCHG_FAILED.
> * writeback() returns X86EMUL_CMPXCHG_FAILED.
> * x86_emulate_insn() returns EMULATION_OK.
> 
> Thus, I think the root cause of this bug is that x86_emulate_insn() ignores the
> X86EMUL_CMPXCHG_FAILED error. The correct behavior should be retrying the
> emulation using the updated value (similar to load-linked/store-conditional).

KVM does retry the emulation, albeit in a very roundabout and non-robust way.
On X86EMUL_CMPXCHG_FAILED, x86_emulate_insn() skips the EIP update and doesn't
writeback GPRs.  x86_emulate_instruction() is flawed and emulates single-step, but
the "eip" written should be the original RIP, i.e. shouldn't advance past the
instructions being emulated.  The single-step mess should be fixed, but I doubt
that's the root cause here.

Is there a memslot for 0xb8000?  I assume not since KVM is emulating (have you
actually verified that, e.g. with tracepoints?).  KVM's ABI doesn't support
atomic MMIO operations, i.e. if there's no memslot, KVM will effectively drop
the LOCK semantics.  If that's indeed what's happening, you should see

  kvm: emulating exchange as write

in the host dmesg (just once though).
