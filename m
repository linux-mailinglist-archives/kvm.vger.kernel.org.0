Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A970398ED7
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 17:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbhFBPlm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 11:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231618AbhFBPll (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 11:41:41 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A70C06174A
        for <kvm@vger.kernel.org>; Wed,  2 Jun 2021 08:39:52 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id s14so1608958pfd.9
        for <kvm@vger.kernel.org>; Wed, 02 Jun 2021 08:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ql9d/9lC/Z+oDU+E2Te9dSYsTCkeZFltxB8n5ToB/Gw=;
        b=eDmjm6x3PDZ43U95ZfqC/7h/3BXiLvCQpHMtTLWt0PoVyzou8OV6f4KCKtUevfBuZv
         3svHbVtP1wOf47r0ACg9gzxYVBF6qeE7gNos1aKDY23hu1Pu9MSgE2rJPnUgj0MpGXXo
         2puFR9jQpNlLACRzjAYhoY3f1xtfTT0D1NPhDRK8OQlpNqzg3vfcs+aZ7/wnmzJTiheh
         Ph5oe532nJEhPyRFLq7lYCnbLdx3tPM++hbFtdJMu9QJ2EvAqkPhF8Qodv5vJHewFH1Y
         SMeW8kAnzhi1j0Qc5fuC007pRMRVfxRvjQRj2tOQcuC+QbnP5H+w8KMQHKGBvDPOPsxb
         7PAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ql9d/9lC/Z+oDU+E2Te9dSYsTCkeZFltxB8n5ToB/Gw=;
        b=Y66ABvWSCOPNPd4BIYbl0JnVGIwFGyuc99jWuAY4XOGHtCSsr8A3kXrBiKnYap2Pwv
         25RtzHvtXKrL4iRFcHEAH8TcD6w6oTZFR+cZcQMPUxVIPEw+HnyGBdpRvxmyoUXiCabG
         2pEtPzIKowZJNYvsrqffk0PLcSUyE0BoegZiEtXZmuSkHRQwHjXPTvGkllwJ8NuZuOFa
         nb3fYcH06R+eiH82Fp3lL0c5HotxIib2qgBISkkyZPJqD9WaCtkjfee37PnurKh1hndZ
         S8RDiywmvgIIKCFSmKJmEOKJlYcijb0IJS0lqf1qKhaPr6vqDhct9gEWLqr92Nt1glF3
         vBsw==
X-Gm-Message-State: AOAM532rU8cBLGQmgmJGnsoDytYQgvWflJApelBcIYTnnbtiRcRqGaTn
        S9eUTJvwQbOrcU8F/RIko9+wWw==
X-Google-Smtp-Source: ABdhPJyoFdBqGNzP8RjidgmmG03Wg/fcm/E0mpp8XjjIzR9WkDNNSXTACznsMKOveIcatXdp+UyYmQ==
X-Received: by 2002:a63:145e:: with SMTP id 30mr34900690pgu.174.1622648391388;
        Wed, 02 Jun 2021 08:39:51 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id o27sm156917pgb.70.2021.06.02.08.39.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 08:39:50 -0700 (PDT)
Date:   Wed, 2 Jun 2021 15:39:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH V2] KVM: X86: fix tlb_flush_guest()
Message-ID: <YLemQ++Xdvh5TVNe@google.com>
References: <4c3ef411ba68ca726531a379fb6c9d16178c8513.camel@redhat.com>
 <20210531172256.2908-1-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210531172256.2908-1-jiangshanlai@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 01, 2021, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> For KVM_VCPU_FLUSH_TLB used in kvm_flush_tlb_multi(), the guest expects
> the hypervisor do the operation that equals to native_flush_tlb_global()
> or invpcid_flush_all() in the specified guest CPU.

I don't like referencing guest code, here and in the comment.  The paravirt
flush isn't limited to Linux guests, the existing kernel code might change, and
it doesn't directly explain KVM's responsibilities in response to a guest TLB
flush.

Something like:

  When using shadow paging, unload the guest MMU when emulating a guest TLB
  flush to all roots are synchronized.  From the guest's perspective,
  flushing the TLB ensure any and all modifications to its PTEs will be
  recognized by the CPU.

  Note, unloading the MMU is overkill, but is done to mirror KVM's existing
  handling of INVPCID(all) and ensure the bug is squashed.  Future cleanup
  can be done to more precisely synchronize roots when servicing a guest
  TLB flush.
  
> When TDP is enabled, there is no problem to just flush the hardware
> TLB of the specified guest CPU.
> 
> But when using shadowpaging, the hypervisor should have to sync the
> shadow pagetable at first before flushing the hardware TLB so that
> it can truely emulate the operation of invpcid_flush_all() in guest.
> 
> The problem exists since the first implementation of KVM_VCPU_FLUSH_TLB
> in commit f38a7b75267f ("KVM: X86: support paravirtualized help for TLB
> shootdowns").  But I don't think it would be a real world problem that
> time since the local CPU's tlb is flushed at first in guest before queuing
> KVM_VCPU_FLUSH_TLB to other CPUs.  It means that the hypervisor syncs the
> shadow pagetable before seeing the corresponding KVM_VCPU_FLUSH_TLBs.
> 
> After commit 4ce94eabac16 ("x86/mm/tlb: Flush remote and local TLBs
> concurrently"), the guest doesn't flush local CPU's tlb at first and
> the hypervisor can handle other VCPU's KVM_VCPU_FLUSH_TLB earlier than
> local VCPU's tlb flush and might flush the hardware tlb without syncing
> the shadow pagetable beforehand.

Maybe reword the last two paragraphs to make it clear that a change in the Linux
kernel exposed the KVM bug?

  This bug has existed since the introduction of KVM_VCPU_FLUSH_TLB, but
  was only recently exposed after Linux guests stopped flushing the local
  CPU's TLB prior to flushing remote TLBs (see commit 4ce94eabac16,
  "x86/mm/tlb: Flush remote and local TLBs concurrently").

> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Fixes: f38a7b75267f ("KVM: X86: support paravirtualized help for TLB shootdowns")
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> ---
> Changed from V1
> 	Use kvm_mmu_unload() instead of KVM_REQ_MMU_RELOAD to avoid
> 	causing unneeded iteration of vcpu_enter_guest().
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index bbc4e04e67ad..27248e330767 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3072,6 +3072,22 @@ static void kvm_vcpu_flush_tlb_all(struct kvm_vcpu *vcpu)
>  static void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu)
>  {
>  	++vcpu->stat.tlb_flush;
> +
> +	if (!tdp_enabled) {
> +		/*
> +		 * When two dimensional paging is not enabled, the
> +		 * operation should equal to native_flush_tlb_global()
> +		 * or invpcid_flush_all() on the guest's behalf via
> +		 * synchronzing shadow pagetable and flushing.
> +		 *
> +		 * kvm_mmu_unload() results consequent kvm_mmu_load()
> +		 * before entering guest which will do the required
> +		 * pagetable synchronzing and TLB flushing.
> +		 */
> +		kvm_mmu_unload(vcpu);

I don't like the full unload, but I suppose the big hammer does make sense for a
backport since handle_invcpid() and toggling CR4.PGE already nuke everything.  :-/

> +		return;
> +	}
> +
>  	static_call(kvm_x86_tlb_flush_guest)(vcpu);
>  }
>  
> -- 
> 2.19.1.6.gb485710b
> 
