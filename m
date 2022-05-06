Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08CA551D082
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 07:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377391AbiEFFSU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 01:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233865AbiEFFST (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 01:18:19 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5174B5DA1B
        for <kvm@vger.kernel.org>; Thu,  5 May 2022 22:14:37 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id q8so6474607oif.13
        for <kvm@vger.kernel.org>; Thu, 05 May 2022 22:14:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=stonybrook.edu; s=sbu-gmail;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c0nEKw7lh6bk0d4ZaWDPViAVcNdo9TFCtSzNN6UQrzk=;
        b=tdOhULz2pE8HPPLnrbu2lizNbpqZ2i7FxfoLqfqZq9UVJebPsrsy4lz/dW18iK/0CL
         Nl6Jv3arYX28X++HjETuhjJhDxu+RbKNli52elDre0OGbb9O2iy8WAdaHniibMxzDe57
         wfmBovE4/y6iQc+n4Lv4StzbJnJ2g8nj0FeA0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c0nEKw7lh6bk0d4ZaWDPViAVcNdo9TFCtSzNN6UQrzk=;
        b=R+oSTIDEj2eNdNxGMeEJw6sZL8yvIsBhBh1dpYEHavjRCm3TU/P2lKHcV6OSfSY80l
         4Yn/QuWDNbyytoYNnAPlp0II6K7qV6/Ykme+QIJLoddxpGVmi7X/NI4zSmOFxH9MDdnL
         XbbL7iFO0dmSiXaZar7ZjUnGZ6fDxxQ6V+MEIoOAzj3Na7pi1UQFxhH2zN1GzsA3SWXV
         MkA1SPZ6tFHjQYnUt1LyR0kJBcyOY40RiIpTv32shKwCkJPxrYPwRLgzAT3XJM5JgfuI
         lcCzdQza+JtWV0n0cWONPIAa7nJpfDVVIzLkl0iOMpgrSNMK4Rxb/XGCEvT8nx3W5SVj
         HaXQ==
X-Gm-Message-State: AOAM530RSI+UZ6rR8SYe5QoHXrh4jn8GjSYBoXuPLl/S6nJVkJd/fifU
        eyPBL9du2W22mS/K1qKLEC7/QuUnwiwKhbWk500avg==
X-Google-Smtp-Source: ABdhPJwuALi2iWmoSybTuKHYdy2mBcKq3/qObN2GscVYxf+0ctGoXZukys2Yj/BGLLCNKpGraqUgaXdlpTLtgLn3BrA=
X-Received: by 2002:a05:6808:158f:b0:325:ea8f:5901 with SMTP id
 t15-20020a056808158f00b00325ea8f5901mr735239oiw.37.1651814076658; Thu, 05 May
 2022 22:14:36 -0700 (PDT)
MIME-Version: 1.0
References: <CAJGDS+GM9Aw6Yvhv+F6wMGvrkz421kfq0j_PZa9F0AKyp5cEQA@mail.gmail.com>
 <YnGUazEgCJWgB6Yw@google.com>
In-Reply-To: <YnGUazEgCJWgB6Yw@google.com>
From:   Arnabjyoti Kalita <akalita@cs.stonybrook.edu>
Date:   Fri, 6 May 2022 10:44:25 +0530
Message-ID: <CAJGDS+F0hB=0bj8spt9sophJyhdXTkYXK8LXUrt=7mov4s2JJA@mail.gmail.com>
Subject: Re: Causing VMEXITs when kprobes are hit in the guest VM
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dear Sean,

Thank you very much for your answer.

I managed to set a Hardware Breakpoint using the API you provided, in
userspace, and managed to get a VMEXIT of type "KVM_EXIT_DEBUG". I
will not re-inject the #BP since I do not necessarily want the guest
to do anything with it. All I will do is just record the CPU ID of the
cpu (in userspace) that caused this breakpoint and let the guest
continue execution.

Best Regards,
Arnabjyoti Kalita

On Wed, May 4, 2022 at 2:15 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Sun, May 01, 2022, Arnabjyoti Kalita wrote:
> > Hello all,
> >
> > I intend to run a kernel module inside my guest VM. The kernel module
> > sets kprobes on a couple of functions in the linux kernel. After
> > registering the kprobes successfully, I can see that the kprobes are
> > being hit repeatedly.
> >
> > I would like to cause a VMEXIT when these kprobes are hit. I know that
> > kprobes use a breakpoint instruction (INT 3) to successfully execute
> > the pre and post handlers. This would mean that the execution of the
> > instruction INT 3 should technically cause a VMEXIT.
>
> No, it should cause #BP.  KVM doesn't intercept #BP by default because there's no
> reason to do so.
>
> > However, I do not get any software exception type VMEXITs when these kprobes
> > are hit.
> >
> > I have used the commands "perf kvm stat record" and "perf kvm stat
> > report --event=vmexit" to try and observe the VMEXIT reasons and I do
> > not see any VMEXIT of type "EXCEPTION_NMI" being returned in the
> > period that the kprobe was being hit.
> >
> > My host uses a modified Linux kernel 5.8.0 while my guest runs a 4.4.0
> > Linux kernel. Both the guest and the host use the x86_64 architecture.
> > I am using QEMU version 5.0.1. What changes are needed in the Linux
> > kernel to make sure that I get an exception in the form of a VMEXIT
> > whenever the kprobes are hit?
>
> This can be done entirely from userspace by enabling KVM_GUESTDBG_USE_SW_BP, e.g.
>
>         struct kvm_guest_debug debug;
>
>         memset(&debug, 0, sizeof(debug));
>         debug.control = KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_SW_BP;
>         ioctl(vcpu->fd, KVM_SET_GUEST_DEBUG, &debug);
>
> That will intercept #BP and exit to userspace with KVM_EXIT_DEBUG.  Note, it's
> userspace's responsibility to re-inject the #BP if userspace wants to forward the
> #BP to the guest.
>
> There's a bit more info in Documentation/virt/kvm/api.rst under KVM_SET_GUEST_DEBUG.
