Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40086515852
	for <lists+kvm@lfdr.de>; Sat, 30 Apr 2022 00:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239811AbiD2WZu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 18:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239749AbiD2WZr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 18:25:47 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8B8BDC9B9;
        Fri, 29 Apr 2022 15:22:28 -0700 (PDT)
Received: from zn.tnic (p5de8eeb4.dip0.t-ipconnect.de [93.232.238.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id DE3C11EC050F;
        Sat, 30 Apr 2022 00:22:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1651270943;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I4U8glVnuq6Udv8BBw4C461Q7LSCRVtHUAvx084Xn4E=;
        b=N/Gn0YPjt0yops3V1ZK6EXBLZDGlHVVpH3hnjqubvDWNhrdln4Y6d6fhyXPtbCVCilEp4g
        REKBUYhDYMOOfNf5ltdfSAHSmAwLyNbG/i9JyqOqELTJpn4zt0vnrHrI43AhD3ixHqxLm8
        X7pDC+UiwUvzwgm3Ri+Pd8twL2I9Ij4=
Date:   Sat, 30 Apr 2022 00:22:20 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Jon Kohler <jon@nutanix.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Balbir Singh <sblbir@amazon.com>,
        Kim Phillips <kim.phillips@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v3] x86/speculation, KVM: only IBPB for
 switch_mm_always_ibpb on vCPU load
Message-ID: <YmxlHBsxcIy8uYaB@zn.tnic>
References: <20220422162103.32736-1-jon@nutanix.com>
 <YmwZYEGtJn3qs0j4@zn.tnic>
 <645E4ED5-F6EE-4F8F-A990-81F19ED82BFA@nutanix.com>
 <Ymw9UZDpXym2vXJs@zn.tnic>
 <YmxKqpWFvdUv+GwJ@google.com>
 <YmxRnwSUBIkOIjLA@zn.tnic>
 <Ymxf2Jnmz5y4CHFN@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Ymxf2Jnmz5y4CHFN@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 29, 2022 at 09:59:52PM +0000, Sean Christopherson wrote:
> Correct, but KVM also doesn't do IBPB on VM-Exit (or VM-Entry),

Why doesn't it do that? Not needed?

> nor does KVM do IBPB before exiting to userspace.

Same question.

> The IBPB we want to whack is issued only when KVM is switching vCPUs.

Then please document it properly as I've already requested.

> Except that _none_ of that documentation explains why the hell KVM
> does IBPB when switching betwen vCPUs.

Probably because the folks involved in those patches weren't the hell
mainly virt people. Although I see a bunch of virt people on CC on that
patch.

>   : But stepping back, why does KVM do its own IBPB in the first place?  The goal is
>   : to prevent one vCPU from attacking the next vCPU run on the same pCPU.  But unless
>   : userspace is running multiple VMs in the same process/mm_struct, switching vCPUs,
>   : i.e. switching tasks, will also switch mm_structs and thus do IPBP via cond_mitigation.
>   :
>   : If userspace runs multiple VMs in the same process,

This keeps popping up. Who does that? Can I get a real-life example to
such VM-based containers or what the hell that is, pls?

> enables cond_ipbp, _and_ sets
>   : TIF_SPEC_IB, then it's being stupid and isn't getting full protection in any case,
>   : e.g. if userspace is handling an exit-to-userspace condition for two vCPUs from
>   : different VMs, then the kernel could switch between those two vCPUs' tasks without
>   : bouncing through KVM and thus without doing KVM's IBPB.
>   :
>   : I can kinda see doing this for always_ibpb, e.g. if userspace is unaware of spectre
>   : and is naively running multiple VMs in the same process.

So this needs a clearer definition: what protection are we even talking
about when the address spaces of processes are shared? My naïve
thinking would be: none. They're sharing address space - branch pred.
poisoning between the two is the least of their worries.

So to cut to the chase: it sounds to me like you don't want to do IBPB
at all on vCPU switch. And the process switch case is taken care of by
switch_mm().

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
