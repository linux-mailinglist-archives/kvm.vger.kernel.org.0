Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EFFC581620
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 17:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbiGZPKq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 11:10:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbiGZPKk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 11:10:40 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6688B656B
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 08:10:39 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d3so5716898pls.4
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 08:10:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nEq1IaNhdkodBDzozbLgFdlJtMKKyeEDpgF5SJMm+Y8=;
        b=OWEnJwcMRH6J/QXCuwh5ay2U50ZpDhtt9UbnMucbCaA8Hn/Gf1tn7OIPJZvJJlYZph
         LW8ZsOCCLqtJX6LzYMwSle6gPv8wQUpMXg/MKvdNr6Jw/YVHewJywz77TGt6RYKsrv7s
         SaYVVhrt32cGZ4Vqk4SVa2I7QE52NbeI2bAhNurJ2VvJc9eEaSBJ74CCOhEq5pj6Lfjc
         GH7pedy/4PRnTzw3rnxOmJYwi3M2qip3MhP3oY2TjKi1A/z/1XkDjDb80k1rsXKkYTKQ
         1rS339PAXGkNqzjwoqOFEuEedlCoeFDrxQRsqQt1kR5gbNkNRVUSH9SwC4ovtagB6bu7
         dNxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nEq1IaNhdkodBDzozbLgFdlJtMKKyeEDpgF5SJMm+Y8=;
        b=I04VQpIFyXYc+v6ezmOPiEoEsYF/8NZlt3zAnSYNmGSKwlwZ/fsutSDygyaYDR7gDM
         Zugtxo7mGbA3iTHVYTK3iGnOYq+Klc88Hle5oSztyqaMYQjU0Bi/RS23joj+tksxAlA+
         5ja86yrrshKi86ne/iwH37ZGKt8nTfQk3OmHVk4R288eg1iCiqAWQdErWcUoysVyMVpj
         2XgyU/HgAbb3N/3cdV7dzozvVlrVAztMibOUtlhkYUZMJQxXGBX7tx/bWAr03frUTK4f
         7r6VsXzm+exbAhJyZ/dKx7U4HRfpTiup+RgR1SjuraJCwPLp9m+Q2Uaj1Dhc276xNoPT
         2NRA==
X-Gm-Message-State: AJIora8l5vmy13bSXmf4gKPUbXtsHGV1enXpeZ9Deu98Cu9TlVIUYETe
        LHpM8aIFUubDywVbmpNrSe0M7w==
X-Google-Smtp-Source: AGRyM1tbthc+9spb5S+wWJFbOwwDqsIQ0p+TbIcXSswRVvW+f3FRIUOzzHyQP2Y909DPGDD80G8XRA==
X-Received: by 2002:a17:902:d2d1:b0:16c:223e:a3db with SMTP id n17-20020a170902d2d100b0016c223ea3dbmr17861909plc.37.1658848238620;
        Tue, 26 Jul 2022 08:10:38 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id j1-20020a654d41000000b003fadd680908sm10389894pgt.83.2022.07.26.08.10.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 08:10:37 -0700 (PDT)
Date:   Tue, 26 Jul 2022 15:10:34 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Andrei Vagin <avagin@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jianfeng Tan <henry.tjf@antfin.com>,
        Adin Scannell <ascannell@google.com>,
        Konstantin Bogomolov <bogomolov@google.com>,
        Etienne Perot <eperot@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 0/5] KVM/x86: add a new hypercall to execute host system
Message-ID: <YuAD6qY+F2nuGm62@google.com>
References: <20220722230241.1944655-1-avagin@google.com>
 <Yts1tUfPxdPH5XGs@google.com>
 <CAEWA0a4hrRb5HYLqa1Q47=guY6TLsWSJ_zxNjOXXV2jCjUekUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEWA0a4hrRb5HYLqa1Q47=guY6TLsWSJ_zxNjOXXV2jCjUekUA@mail.gmail.com>
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

On Tue, Jul 26, 2022, Andrei Vagin wrote:
> On Fri, Jul 22, 2022 at 4:41 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > +x86 maintainers, patch 1 most definitely needs acceptance from folks beyond KVM.
> >
> > On Fri, Jul 22, 2022, Andrei Vagin wrote:
> > > Another option is the KVM platform. In this case, the Sentry (gVisor
> > > kernel) can run in a guest ring0 and create/manage multiple address
> > > spaces. Its performance is much better than the ptrace one, but it is
> > > still not great compared with the native performance. This change
> > > optimizes the most critical part, which is the syscall overhead.
> >
> > What exactly is the source of the syscall overhead,
> 
> Here are perf traces for two cases: when "guest" syscalls are executed via
> hypercalls and when syscalls are executed by the user-space VMM:
> https://gist.github.com/avagin/f50a6d569440c9ae382281448c187f4e
> 
> And here are two tests that I use to collect these traces:
> https://github.com/avagin/linux-task-diag/commit/4e19c7007bec6a15645025c337f2e85689b81f99
> 
> If we compare these traces, we can find that in the second case, we spend extra
> time in vmx_prepare_switch_to_guest, fpu_swap_kvm_fpstate, vcpu_put,
> syscall_exit_to_user_mode.

So of those, I think the only path a robust implementation can actually avoid,
without significantly whittling down the allowed set of syscalls, is
syscall_exit_to_user_mode().

The bulk of vcpu_put() is vmx_prepare_switch_to_host(), and KVM needs to run
through that before calling out of KVM.  E.g. prctrl(ARCH_GET_GS) will read the
wrong GS.base if MSR_KERNEL_GS_BASE isn't restored.  And that necessitates
calling vmx_prepare_switch_to_guest() when resuming the vCPU.

FPU state, i.e. fpu_swap_kvm_fpstate() is likely a similar story, there's bound
to be a syscall that accesses user FPU state and will do the wrong thing if guest
state is loaded.

For gVisor, that's all presumably a non-issue because it uses a small set of
syscalls (or has guest==host state?), but for a common KVM feature it's problematic.

> > and what alternatives have been explored?  Making arbitrary syscalls from
> > within KVM is mildly terrifying.
> 
> "mildly terrifying" is a good sentence in this case:). If I were in your place,
> I would think about it similarly.
> 
> I understand these concerns about calling syscalls from the KVM code, and this
> is why I hide this feature under a separate capability that can be enabled
> explicitly.
> 
> We can think about restricting the list of system calls that this hypercall can
> execute. In the user-space changes for gVisor, we have a list of system calls
> that are not executed via this hypercall.

Can you provide that list?

> But it has downsides:
> * Each sentry system call trigger the full exit to hr3.
> * Each vmenter/vmexit requires to trigger a signal but it is expensive.

Can you explain this one?  I didn't quite follow what this is referring to.

> * It doesn't allow to support Confidential Computing (SEV-ES/SGX). The Sentry
>   has to be fully enclosed in a VM to be able to support these technologies.

Speaking of SGX, this reminds me a lot of Graphene, SCONEs, etc..., which IIRC
tackled the "syscalls are crazy expensive" problem by using a message queue and
a dedicated task outside of the enclave to handle syscalls.  Would something like
that work, or is having to burn a pCPU (or more) to handle syscalls in the host a
non-starter?
