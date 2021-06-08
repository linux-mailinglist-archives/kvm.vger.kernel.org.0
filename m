Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B64DB39EA89
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 02:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbhFHAFs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 20:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbhFHAFr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Jun 2021 20:05:47 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845DCC061574
        for <kvm@vger.kernel.org>; Mon,  7 Jun 2021 17:03:55 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id z26so14326193pfj.5
        for <kvm@vger.kernel.org>; Mon, 07 Jun 2021 17:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IVWQgeX8pxlPHrLZhyIQOUyk32oPka7/Ok9wquneuoc=;
        b=Ol4qpEgDIRD1zOE2YUXoiJNlh5o+lnZA3J+y4ZiDMg9mBTlFekRKvftKjplB57vOGS
         TIdiGy5yk+xcIXO8qHxDGW0is6yeWrFtQkdnfWAMv9MFPWt4p0KSLTrrhOjvFcXZb5d9
         u5F3NwIQzF8ZQ8v7vjIknS+fJJM5v9lDdgo+Cd81XDftFEecY8XJ3zExAghbAX3AcIjr
         NWNR0L98HMFI5qZ2C/AwdeWQwKOK4IVVjXVq4+10APp1FtKCIscpWzoige2P7jfGihjO
         CE/1Uscrv5+z7Lz9+K8FDdx0iRNIje7PPDrMDVVb1HucAHuayhEJ9vLZrJyFgPC4WXzB
         HjvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IVWQgeX8pxlPHrLZhyIQOUyk32oPka7/Ok9wquneuoc=;
        b=XWqzq5Mx69a3u17jJd6VZs5ygsGAZmaqMzzCD1896E0wN2dScRnzDbAxMU2wgahSSG
         hwQfXDXWGbJw5HU1loBskV2NoqUNc7RAh01wflCbrx+ddCX4h3G+8t9Hvr14johRgwra
         teb55cVJkrsPeLTdfj04lfSp+VZY6+7oTtUnTQGRE1ow4EVC6k3UAnCT0l9QvFI3+9wq
         mdi+kcc41Ws1sBKAMukQ0Q+Yt4wqTru5mdGL+q59U80P1CiBFDKc0g67FgQnc2ROHdYT
         N6tr2rad6qkChfWXnTiCnKr+QfORtn5LSot3Cbd9EZbkNOBHUPIGrdFpUGxpLIuydFvR
         PeEA==
X-Gm-Message-State: AOAM532x3FogBWBUjRdR8qA5wA7umT6UufEGn/6KrNBnoWmzTZBPLMG2
        uH/LtRtLyrgKez61da3NJb1joQ==
X-Google-Smtp-Source: ABdhPJxTozExjjLKbJyxYHs8dbaFsP+SQMKFxw4vr3iruvl1doGg6Q/XZTvNayb+HXuWk07p27LZcg==
X-Received: by 2002:a62:ab16:0:b029:2ed:8599:7df8 with SMTP id p22-20020a62ab160000b02902ed85997df8mr11976528pff.31.1623110634641;
        Mon, 07 Jun 2021 17:03:54 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id d14sm13067495pjc.56.2021.06.07.17.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jun 2021 17:03:53 -0700 (PDT)
Date:   Tue, 8 Jun 2021 00:03:50 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH V2] KVM: X86: fix tlb_flush_guest()
Message-ID: <YL6z5sv7cnsbZhvT@google.com>
References: <4c3ef411ba68ca726531a379fb6c9d16178c8513.camel@redhat.com>
 <20210531172256.2908-1-jiangshanlai@gmail.com>
 <9d457b982c3fcd6e7413065350b9f860d45a6e47.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d457b982c3fcd6e7413065350b9f860d45a6e47.camel@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 08, 2021, Maxim Levitsky wrote:
> So this patch *does* fix the windows boot without TDP!

Woot!

> Tested-by: Maxim Levitsky <mlevitsk@redhat.com>
> Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Lai,

I have a reworded version of your patch sitting in a branch that leverages this
path to fix similar bugs and do additional cleanup.  Any objection to me gathering
Maxim's tags and posting the version below?  I'm more than happy to hold off if
you'd prefer to send your own version, but I don't want to send my own series
without this fix as doing so would introduce bugs.

Thanks!

Author: Lai Jiangshan <laijs@linux.alibaba.com>
Date:   Tue Jun 1 01:22:56 2021 +0800

    KVM: x86: Unload MMU on guest TLB flush if TDP disabled to force MMU sync
    
    When using shadow paging, unload the guest MMU when emulating a guest TLB
    flush to all roots are synchronized.  From the guest's perspective,
    flushing the TLB ensures any and all modifications to its PTEs will be
    recognized by the CPU.
    
    Note, unloading the MMU is overkill, but is done to mirror KVM's existing
    handling of INVPCID(all) and ensure the bug is squashed.  Future cleanup
    can be done to more precisely synchronize roots when servicing a guest
    TLB flush.
    
    If TDP is enabled, synchronizing the MMU is unnecessary even if nested
    TDP is in play, as a "legacy" TLB flush from L1 does not invalidate L1's
    TDP mappgins.  For EPT, an explicit INVEPT is required to invalidate
    guest-physical mappings.  For NPT, guest mappings are always tagged with
    an ASID and thus can only be invalidated via the VMCB's ASID control.
    
    This bug has existed since the introduction of KVM_VCPU_FLUSH_TLB, but
    was only recently exposed after Linux guests stopped flushing the local
    CPU's TLB prior to flushing remote TLBs (see commit 4ce94eabac16,
    "x86/mm/tlb: Flush remote and local TLBs concurrently").
    
    Tested-by: Maxim Levitsky <mlevitsk@redhat.com>
    Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
    Fixes: f38a7b75267f ("KVM: X86: support paravirtualized help for TLB shootdowns")
    Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
    [sean: massaged comment and changelog]
    Signed-off-by: Sean Christopherson <seanjc@google.com>

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 1cd6d4685932..3b02528d5ee8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3072,6 +3072,18 @@ static void kvm_vcpu_flush_tlb_all(struct kvm_vcpu *vcpu)
 static void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu)
 {
        ++vcpu->stat.tlb_flush;
+
+       if (!tdp_enabled) {
+               /*
+                * Unload the entire MMU to force a sync of the shadow page
+                * tables.  A TLB flush on behalf of the guest is equivalent
+                * to INVPCID(all), toggling CR4.PGE, etc...  Note, loading the
+                * MMU will also do an actual TLB flush.
+                */
+               kvm_mmu_unload(vcpu);
+               return;
+       }
+
        static_call(kvm_x86_tlb_flush_guest)(vcpu);
 }
 

> More notes from the testing I just did:
>  
> 1. On AMD with npt=0, the windows VM boots very slowly, and then in the task manager
> I see that it booted with 1 CPU, although I configured it for 3-28 vCPUs (doesn't matter how many)
> I tested this with several win10 VMs, same pattern repeats.

That's very odd.  Maybe it's so slow that the guest gives up on the AP and marks
it as dead?  That seems unlikely though, I can't imagine waking APs would be
_that_ slow.

> 2. The windows nag screen about "we beg you to open a microsoft account" makes the VM enter a live lock.
> I see about half million at least VM exits per second due to page faults and it is stuck in 'please wait' screen
> while with NPT=1 it shows up instantly. The VM has 12 GB of ram so I don't think RAM is an issue.
>  
> It's likely that those are just result of unoptimized code in regard to TLB flushes,
> and timeouts in windows.
> On my Intel laptop, the VM is way faster with EPT=0 and it boots with 3 vCPUs just fine
> (the laptop has just dual core CPU, so I can't really give more that 3 vCPU to the VM)

Any chance your Intel CPU has PCID?  Although the all-contexts INVPCID emulation
nukes everything, the single-context INVPCID emulation in KVM is optimized to
(a) sync the current MMU (if necessary) instead of unloading it and (b) free
only roots with the matching PCID.  I believe all other forms of TLB flushing
that are likely to be used by the guest will lead to KVM unloading the entire
MMU and rebuilding it from scratch.
