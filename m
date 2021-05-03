Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6D4372097
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 21:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbhECTiq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 15:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbhECTiq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 May 2021 15:38:46 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4467C06174A;
        Mon,  3 May 2021 12:37:52 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1620070670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QRjECRjxk0gCtINki1a2W5i2rPrFEb8mTYWTcf6OIYs=;
        b=BoiaW9itpBPtVgzdTOBhFgLCo2NGqyL/URF7vVqPcVeHk7/YCM8i86r8kzW0R+jfmnyZjS
        aTtphJo5qWBkOkMei4JbuBaDLusvwtJfvSjVG6UZEa1/vburSP2lioSO9DMVpFU291coFj
        jQwFEK6CqwP40lEI5QMCW5YNBgZt16W6r2Nl/3N2oZdB69ImUHRFAi0I26AI6B1F8K9L5o
        +pKAYZNMafT8flf+Gk998Hn0TLSiKatGDggBcQKj6pp81NMTmln/x177nHuhaOv+SbAI8r
        iJOdATkRrpftiKERsYzMqkMNc/YpUkWxgLCGck8eNiAdlKByuFgm6p4gurAB5Q==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1620070670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QRjECRjxk0gCtINki1a2W5i2rPrFEb8mTYWTcf6OIYs=;
        b=8QTDNKcjtGKkCGlBhiQmL2RmwBgHZ1+ZygEdoaXTJxrRk9Ns3aJGKiqRbrhPNmfYwIpvip
        /s3Y9tYdmMl0u1DA==
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andi Kleen <ak@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Uros Bizjak <ubizjak@gmail.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 3/4] KVM/VMX: Invoke NMI non-IST entry instead of IST entry
In-Reply-To: <20210426230949.3561-4-jiangshanlai@gmail.com>
References: <20210426230949.3561-1-jiangshanlai@gmail.com> <20210426230949.3561-4-jiangshanlai@gmail.com>
Date:   Mon, 03 May 2021 21:37:49 +0200
Message-ID: <87k0ofk3qq.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 27 2021 at 07:09, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
>
> In VMX, the NMI handler needs to be invoked after NMI VM-Exit.
>
> Before the commit 1a5488ef0dcf6 ("KVM: VMX: Invoke NMI handler via
> indirect call instead of INTn"), the work is done by INTn ("int $2").
>
> But INTn microcode is relatively expensive, so the commit reworked
> NMI VM-Exit handling to invoke the kernel handler by function call.
> And INTn doesn't set the NMI blocked flag required by the linux kernel
> NMI entry.  So moving away from INTn are very reasonable.
>
> Yet some details were missed.  After the said commit applied, the NMI
> entry pointer is fetched from the IDT table and called from the kernel
> stack.  But the NMI entry pointer installed on the IDT table is
> asm_exc_nmi() which expects to be invoked on the IST stack by the ISA.
> And it relies on the "NMI executing" variable on the IST stack to work
> correctly.  When it is unexpectedly called from the kernel stack, the
> RSP-located "NMI executing" variable is also on the kernel stack and
> is "uninitialized" and can cause the NMI entry to run in the wrong way.
>
> So we should not used the NMI entry installed on the IDT table.  Rather,
> we should use the NMI entry allowed to be used on the kernel stack which
> is asm_noist_exc_nmi() which is also used for XENPV and early booting.

It's not used by XENPV. XENPV only uses the C entry point, but the ASM
entry is separate.

Thanks,

        tglx
