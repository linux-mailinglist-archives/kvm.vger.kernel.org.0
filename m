Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CF4036D461
	for <lists+kvm@lfdr.de>; Wed, 28 Apr 2021 11:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238040AbhD1JBK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Apr 2021 05:01:10 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:46642 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237187AbhD1JBI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Apr 2021 05:01:08 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1619600418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ykPQW3hz29qXZdhBdbD6l3BEA7hSURF7RbxOqHRUZOM=;
        b=dycaytdaqUqsMJz0lcSKdr3b2AyLaGfUCYu6Qwwp7bfJOQu/bG1E0/8ovpbHK0c0v8Ibm3
        oJoLzyeiWRBZO/gkqafs2X8ZLc75Kdm03jT5KXpSezRldiDSkFmSV8VvZ3fq/YmVgOcdCx
        J27ya+VNaQRjAJS6Ial7KGDeulyIpHYu+wO3IV4/IcQvYNaOiwZDQGz8oFQwRBdguSCByg
        +L2oR7DOSpf8exM6NXi/wCLFy2rCdE/gV+z3ZK59sPlYJWzC4FB/qNcmyyJ5ui8kodB4i7
        +mCukb3l6re/dDxIAnBI3RdlacnjDwV2MWma/Xah4e+P7vwH6JB+/S6VTLJCfw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1619600418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ykPQW3hz29qXZdhBdbD6l3BEA7hSURF7RbxOqHRUZOM=;
        b=p1JZAU+ZEOqSR8Pbn1xQ9AQacG0Z2fQdjh8wcJLHxRjmzdtyQMyLc7jr+6ndEd1TYtsOeS
        HbHXJ318Zlbb35BA==
To:     Zelin Deng <zelin.deng@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] Guest system time jumps when new vCPUs is hot-added
In-Reply-To: <1619576521-81399-1-git-send-email-zelin.deng@linux.alibaba.com>
References: <1619576521-81399-1-git-send-email-zelin.deng@linux.alibaba.com>
Date:   Wed, 28 Apr 2021 11:00:18 +0200
Message-ID: <87lf92n5r1.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 28 2021 at 10:22, Zelin Deng wrote:

> Hello,
> I have below VM configuration:
> ...
>     <vcpu placement='static' current='1'>2</vcpu>
>     <cpu mode='host-passthrough'>
>     </cpu>
>     <clock offset='utc'>
>         <timer name='tsc' frequency='3000000000'/>
>     </clock>
> ...
> After VM has been up for a few minutes, I use "virsh setvcpus" to hot-add
> second vCPU into VM, below dmesg is observed:
> [   53.273484] CPU1 has been hot-added
> [   85.067135] SMP alternatives: switching to SMP code
> [   85.078409] x86: Booting SMP configuration:
> [   85.079027] smpboot: Booting Node 0 Processor 1 APIC 0x1
> [   85.080240] kvm-clock: cpu 1, msr 77601041, secondary cpu clock
> [   85.080450] smpboot: CPU 1 Converting physical 0 to logical die 1
> [   85.101228] TSC ADJUST compensate: CPU1 observed 169175101528 warp. Adjust: 169175101528
> [  141.513496] TSC ADJUST compensate: CPU1 observed 166 warp. Adjust: 169175101694

Why is TSC_ADJUST on CPU1 different from CPU0 in the first place?

That's broken.

Thanks,

        tglx
