Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A35451E49A
	for <lists+kvm@lfdr.de>; Sat,  7 May 2022 08:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349750AbiEGGeq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 May 2022 02:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237563AbiEGGem (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 May 2022 02:34:42 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E82545AD3
        for <kvm@vger.kernel.org>; Fri,  6 May 2022 23:30:56 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id 31-20020a9d0822000000b00605f1807664so6376648oty.3
        for <kvm@vger.kernel.org>; Fri, 06 May 2022 23:30:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=stonybrook.edu; s=sbu-gmail;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c60QwCwYOZd9x5F++AArzxjWSksdn1S0CiIe5STHZcU=;
        b=rS+PF3vTJDgmZK9tK/gh9TX82EAzGNiN6M8GWloaCyJWr2+xSAdX82QATJ7xgKSuwd
         OjMMTnpjdldbjfbii9LIw+EWt4Ikakn8eZxIuHeaxEC974nccc+neZFpkCxgmmTQYuzs
         aSxzUbIy60CdI1wJIXI833v6uoZSPk27x1wcs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c60QwCwYOZd9x5F++AArzxjWSksdn1S0CiIe5STHZcU=;
        b=l3AmyJb41/Tgouy68euKNPRk0AgtTckSwGcOJIJ822UyETTH1JZ2gH2KPaPvuF8Rjk
         +kDvllYkrYECBBi6Sx3pM88s0HeQUwJDpQISFkmY316xThbxPrSKR3hS4ovsTyYA4lLY
         RBpdF+6Nl1wjnl4yHOkfjjAL5r9ZWkJBiQb2bmSaukJXaZw87sURK7LDwIsnpnygu+B2
         8P3iYHZDVevU/SsH1+1CStHIkUU/WO6HvjaVkYM3xx6fHKxKzlZZXBjIYPVNtWDd9ES0
         cabjm5EyoijTVxUWYbRKDxZSys64nqPomdJf9boCboFneJpDFEZg04lewkU3Kv97eDRR
         vNuw==
X-Gm-Message-State: AOAM530VGXzzbuo8fnryVAYIPeVML1bx9uEo4/kYi056vlKWhD/xFZpx
        r/P6IcrGA28MSMAWdL9USYr8U3uyRn6FFDXLRORN2bo+kJKo9w==
X-Google-Smtp-Source: ABdhPJz89cXm5Zdr89jFPoGF1+z1cNjXKzNuRPEhG0v6/R2X4KMpNeFqfXTUN+vtZizkejYcjnCgNoLP9Xfp5FFcnkA=
X-Received: by 2002:a05:6830:4111:b0:606:4ed1:c10a with SMTP id
 w17-20020a056830411100b006064ed1c10amr2335482ott.377.1651905055460; Fri, 06
 May 2022 23:30:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAJGDS+GM9Aw6Yvhv+F6wMGvrkz421kfq0j_PZa9F0AKyp5cEQA@mail.gmail.com>
 <YnGUazEgCJWgB6Yw@google.com> <CAJGDS+F0hB=0bj8spt9sophJyhdXTkYXK8LXUrt=7mov4s2JJA@mail.gmail.com>
In-Reply-To: <CAJGDS+F0hB=0bj8spt9sophJyhdXTkYXK8LXUrt=7mov4s2JJA@mail.gmail.com>
From:   Arnabjyoti Kalita <akalita@cs.stonybrook.edu>
Date:   Sat, 7 May 2022 12:00:44 +0530
Message-ID: <CAJGDS+E5f2Xo68dsEkOfchZybU1uTSb=BgcTgQMLe0tW32m5xg@mail.gmail.com>
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

Dear Sean and all,

When a VMEXIT happens of type "KVM_EXIT_DEBUG" because a hardware
breakpoint was triggered when an instruction was about to be executed,
does the instruction where the breakpoint was placed actually execute
before the VMEXIT happens?

I am attempting to record the occurrence of the debug exception in
userspace. I do not want to do anything extra with the debug
exception. I have modified the kernel code (handle_exception_nmi) to
do something like this -

case BP_VECTOR:
    /*
     * Update instruction length as we may reinject #BP from
     * user space while in guest debugging mode. Reading it for
     * #DB as well causes no harm, it is not used in that case.
     */
      vmx->vcpu.arch.event_exit_inst_len = vmcs_read32(VM_EXIT_INSTRUCTION_LEN);
      kvm_run->exit_reason = KVM_EXIT_DEBUG;
      ......
      kvm_run->debug.arch.pc = vmcs_readl(GUEST_CS_BASE) + rip;
      kvm_run->debug.arch.exception = ex_no;
      kvm_rip_write(vcpu, rip + vmcs_read32(VM_EXIT_INSTRUCTION_LEN));
   <---Change : update RIP here
      break;

This allows the guest to proceed after the hardware breakpoint
exception was triggered. However, the guest kernel keeps running into
page fault at arbitrary points in time. So, I'm not sure if I need to
handle something else too.

I have modified the userspace code to not trigger any exception, it
just records the occurence of this VMEXIT and lets the guest continue.

Is this the right approach?

Thank you very much.

Best Regards,
Arnabjyoti Kalita


On Fri, May 6, 2022 at 10:44 AM Arnabjyoti Kalita
<akalita@cs.stonybrook.edu> wrote:
>
> Dear Sean,
>
> Thank you very much for your answer.
>
> I managed to set a Hardware Breakpoint using the API you provided, in
> userspace, and managed to get a VMEXIT of type "KVM_EXIT_DEBUG". I
> will not re-inject the #BP since I do not necessarily want the guest
> to do anything with it. All I will do is just record the CPU ID of the
> cpu (in userspace) that caused this breakpoint and let the guest
> continue execution.
>
> Best Regards,
> Arnabjyoti Kalita
>
> On Wed, May 4, 2022 at 2:15 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Sun, May 01, 2022, Arnabjyoti Kalita wrote:
> > > Hello all,
> > >
> > > I intend to run a kernel module inside my guest VM. The kernel module
> > > sets kprobes on a couple of functions in the linux kernel. After
> > > registering the kprobes successfully, I can see that the kprobes are
> > > being hit repeatedly.
> > >
> > > I would like to cause a VMEXIT when these kprobes are hit. I know that
> > > kprobes use a breakpoint instruction (INT 3) to successfully execute
> > > the pre and post handlers. This would mean that the execution of the
> > > instruction INT 3 should technically cause a VMEXIT.
> >
> > No, it should cause #BP.  KVM doesn't intercept #BP by default because there's no
> > reason to do so.
> >
> > > However, I do not get any software exception type VMEXITs when these kprobes
> > > are hit.
> > >
> > > I have used the commands "perf kvm stat record" and "perf kvm stat
> > > report --event=vmexit" to try and observe the VMEXIT reasons and I do
> > > not see any VMEXIT of type "EXCEPTION_NMI" being returned in the
> > > period that the kprobe was being hit.
> > >
> > > My host uses a modified Linux kernel 5.8.0 while my guest runs a 4.4.0
> > > Linux kernel. Both the guest and the host use the x86_64 architecture.
> > > I am using QEMU version 5.0.1. What changes are needed in the Linux
> > > kernel to make sure that I get an exception in the form of a VMEXIT
> > > whenever the kprobes are hit?
> >
> > This can be done entirely from userspace by enabling KVM_GUESTDBG_USE_SW_BP, e.g.
> >
> >         struct kvm_guest_debug debug;
> >
> >         memset(&debug, 0, sizeof(debug));
> >         debug.control = KVM_GUESTDBG_ENABLE | KVM_GUESTDBG_USE_SW_BP;
> >         ioctl(vcpu->fd, KVM_SET_GUEST_DEBUG, &debug);
> >
> > That will intercept #BP and exit to userspace with KVM_EXIT_DEBUG.  Note, it's
> > userspace's responsibility to re-inject the #BP if userspace wants to forward the
> > #BP to the guest.
> >
> > There's a bit more info in Documentation/virt/kvm/api.rst under KVM_SET_GUEST_DEBUG.
