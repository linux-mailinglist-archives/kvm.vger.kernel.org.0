Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCEA9581BA8
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 23:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbiGZV2I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 17:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiGZV2B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 17:28:01 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9922432BA0;
        Tue, 26 Jul 2022 14:27:58 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1658870876;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DXC0ivbrYOpPdY+GikVwjygrI0clyz85eHeYd1p4bKs=;
        b=DMVqvh1XK7nu+6cu7CtblPOho3P1Df/FfTU+IWUmfGKKMjzYV8hWkhAPrh2TikPX/orRek
        pohEqEYhx9ygn5h3kLaiaBdgmxUXSacnlv0Avu5XOpTc+RSk2Ig89a2GJi5+Ve0A9jgPft
        kI7Yot9VdgdhDhHyCMP9ezY1VkFWqcomKKb3zH4CIbJpd9gJc2ZDuVbOtae6Tllw3itxL1
        yI9a9eNBb8NJaD5GW78L5WxPnD4JH3yTrIm5CUwAlSpcc0xB1XnuWBjfo7d9SXISicJZQi
        3juBbOmmPTmcPUXaAmK6H5qXXXzae9elGBITd7/jC8DL9d5SiCx3ifh2H4AYnA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1658870876;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DXC0ivbrYOpPdY+GikVwjygrI0clyz85eHeYd1p4bKs=;
        b=EO76yDl0WXV0ywCuyxvQ7q6iRZaHxjdjTebzhQxGZd3E92/a2Quq8+6XnuRnYhlqaRq93W
        8ijnT/DbBADD7GAg==
To:     Sean Christopherson <seanjc@google.com>,
        Andrei Vagin <avagin@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jianfeng Tan <henry.tjf@antfin.com>,
        Adin Scannell <ascannell@google.com>,
        Konstantin Bogomolov <bogomolov@google.com>,
        Etienne Perot <eperot@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 0/5] KVM/x86: add a new hypercall to execute host system
In-Reply-To: <Yts1tUfPxdPH5XGs@google.com>
References: <20220722230241.1944655-1-avagin@google.com>
 <Yts1tUfPxdPH5XGs@google.com>
Date:   Tue, 26 Jul 2022 23:27:56 +0200
Message-ID: <87a68vtvhf.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 22 2022 at 23:41, Sean Christopherson wrote:
> +x86 maintainers, patch 1 most definitely needs acceptance from folks
> beyond KVM.

Thanks for putting us on CC. It seems to be incredibly hard to CC the
relevant maintainers and to get the prefix in the subject straight.

> On Fri, Jul 22, 2022, Andrei Vagin wrote:
>> Another option is the KVM platform. In this case, the Sentry (gVisor
>> kernel) can run in a guest ring0 and create/manage multiple address
>> spaces. Its performance is much better than the ptrace one, but it is
>> still not great compared with the native performance. This change
>> optimizes the most critical part, which is the syscall overhead.
>
> What exactly is the source of the syscall overhead, and what alternatives have
> been explored?  Making arbitrary syscalls from within KVM is mildly terrifying.

What's even worse is that this exposes a magic kernel syscall interface
to random driver writers. Seriously no.

This approach is certainly a clever idea, but exposing this outside of a
very restricted and controlled environment is a patently bad idea.

I skimmed the documentation on the project page:

  sudo modprobe kvm-intel && sudo chmod a+rw /dev/kvm

Can you spot the fail?

I gave up reading further as shortly after that gem the page failed to
render sensibly in Firefox. Hint: Graphics

What's completely missing from the cover letter _and_ from the project
documentation is which subset of KVM functionality this is actually
using and how the actual content of the "guest" looks like. It's all
blury handwaving and lots of marketing to me.

Thanks,

        tglx
