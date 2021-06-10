Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 911743A26F8
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 10:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbhFJI2U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 04:28:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46622 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229942AbhFJI2S (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 10 Jun 2021 04:28:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623313581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IxDiLLKbBP7VVWgtaIeDaWWb6I6XeS9OjppFccyzfog=;
        b=GyvllgCeKBdWp0E696/MsEswPevKbNSgPXZkxyyYO433GlLJcGXWxENrsQzxEhL8rfxGtN
        H7Ut9Xa0hYHuvjuwimgmvaQka0Q0vtKPTPKahrZsnIi83cPCcetmlKZB6GxvOHvrF3Ze6E
        bAvfuB3x3F4va51C197Vvs4t/khbddo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-120-_3J16DQ8OfyyWExKhdzcOQ-1; Thu, 10 Jun 2021 04:26:19 -0400
X-MC-Unique: _3J16DQ8OfyyWExKhdzcOQ-1
Received: by mail-wm1-f69.google.com with SMTP id v25-20020a1cf7190000b0290197a4be97b7so2761052wmh.9
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 01:26:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=IxDiLLKbBP7VVWgtaIeDaWWb6I6XeS9OjppFccyzfog=;
        b=OLGih2pT7Q5lDpi3RTR+U0OXyhNoQHpYtSrB1vEal8h7d3A+z/F6fO1xfJN+LgJLdx
         BA4YvVBQfRJj/hhDFY1MfHzXLrLvEHvlf3/T8y+mXVMIu4PkV3G1/dVGPrkCyBp4yDtB
         aIlu21c5g+FsGDQHCadrxrQhux5CCzy8BgiVQTWDZBBCE46NUjQetXDPyCqOa4NqPItc
         2yT3jwR0Eer7tZtoCaR3/+stms6fPqlA7foIMin8nP3giF7cu2x3PxdjBS7FlSSsS/BM
         st4id71nsaq+KLTZVfmAqvrPS6mtMs/W1j7veMEe4Y7FrOzn4e6daQWtQBqf957OMQ+C
         HCiQ==
X-Gm-Message-State: AOAM53336OICC9w/4L01UOeeDqEeKl/CvlepYvrPIW3/zEjU5BPbK0GZ
        DMqRcWzZLZerPYRakm3Qy4qki0luhaYs98jEP4swK3cqxkjwnLKdg43LtkJ6upmR9WKnKIQ6/iC
        xVthjXWTdRMHy
X-Received: by 2002:a1c:a484:: with SMTP id n126mr13928939wme.34.1623313578633;
        Thu, 10 Jun 2021 01:26:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz4mp8AEpvc2ZmmFyARIcMXmgGfN8Rf5IGJjfKAPH7g/9Kk7QuOX4mU92zI6A+N6A5GmzQ2vg==
X-Received: by 2002:a1c:a484:: with SMTP id n126mr13928922wme.34.1623313578440;
        Thu, 10 Jun 2021 01:26:18 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id m23sm2159738wmc.29.2021.06.10.01.26.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 01:26:17 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+fb0b6a7e8713aeb0319c@syzkaller.appspotmail.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 2/9] KVM: x86: Emulate triple fault shutdown if RSM
 emulation fails
In-Reply-To: <20210609185619.992058-3-seanjc@google.com>
References: <20210609185619.992058-1-seanjc@google.com>
 <20210609185619.992058-3-seanjc@google.com>
Date:   Thu, 10 Jun 2021 10:26:16 +0200
Message-ID: <87eedayvkn.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <seanjc@google.com> writes:

> Use the recently introduced KVM_REQ_TRIPLE_FAULT to properly emulate
> shutdown if RSM from SMM fails.
>
> Note, entering shutdown after clearing the SMM flag and restoring NMI
> blocking is architecturally correct with respect to AMD's APM, which KVM
> also uses for SMRAM layout and RSM NMI blocking behavior.  The APM says:
>
>   An RSM causes a processor shutdown if an invalid-state condition is
>   found in the SMRAM state-save area. Only an external reset, external
>   processor-initialization, or non-maskable external interrupt (NMI) can
>   cause the processor to leave the shutdown state.
>
> Of note is processor-initialization (INIT) as a valid shutdown wake
> event, as INIT is blocked by SMM, implying that entering shutdown also
> forces the CPU out of SMM.
>
> For recent Intel CPUs, restoring NMI blocking is technically wrong, but
> so is restoring NMI blocking in the first place, and Intel's RSM
> "architecture" is such a mess that just about anything is allowed and can
> be justified as micro-architectural behavior.
>
> Per the SDM:
>
>   On Pentium 4 and later processors, shutdown will inhibit INTR and A20M
>   but will not change any of the other inhibits. On these processors,
>   NMIs will be inhibited if no action is taken in the SMI handler to
>   uninhibit them (see Section 34.8).
>
> where Section 34.8 says:
>
>   When the processor enters SMM while executing an NMI handler, the
>   processor saves the SMRAM state save map but does not save the
>   attribute to keep NMI interrupts disabled. Potentially, an NMI could be
>   latched (while in SMM or upon exit) and serviced upon exit of SMM even
>   though the previous NMI handler has still not completed.
>
> I.e. RSM unconditionally unblocks NMI, but shutdown on RSM does not,
> which is in direct contradiction of KVM's behavior.  But, as mentioned
> above, KVM follows AMD architecture and restores NMI blocking on RSM, so
> that micro-architectural detail is already lost.
>
> And for Pentium era CPUs, SMI# can break shutdown, meaning that at least
> some Intel CPUs fully leave SMM when entering shutdown:
>
>   In the shutdown state, Intel processors stop executing instructions
>   until a RESET#, INIT# or NMI# is asserted.  While Pentium family
>   processors recognize the SMI# signal in shutdown state, P6 family and
>   Intel486 processors do not.
>
> In other words, the fact that Intel CPUs have implemented the two
> extremes gives KVM carte blanche when it comes to honoring Intel's
> architecture for handling shutdown during RSM.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/emulate.c     | 12 +++++++-----
>  arch/x86/kvm/kvm_emulate.h |  1 +
>  arch/x86/kvm/x86.c         |  6 ++++++
>  3 files changed, 14 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 5e5de05a8fbf..0603a2c79093 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -2683,7 +2683,7 @@ static int em_rsm(struct x86_emulate_ctxt *ctxt)
>  	 * state-save area.
>  	 */
>  	if (ctxt->ops->pre_leave_smm(ctxt, buf))
> -		return X86EMUL_UNHANDLEABLE;
> +		goto emulate_shutdown;
>  
>  #ifdef CONFIG_X86_64
>  	if (emulator_has_longmode(ctxt))
> @@ -2692,14 +2692,16 @@ static int em_rsm(struct x86_emulate_ctxt *ctxt)
>  #endif
>  		ret = rsm_load_state_32(ctxt, buf);
>  
> -	if (ret != X86EMUL_CONTINUE) {
> -		/* FIXME: should triple fault */
> -		return X86EMUL_UNHANDLEABLE;
> -	}
> +	if (ret != X86EMUL_CONTINUE)
> +		goto emulate_shutdown;
>  
>  	ctxt->ops->post_leave_smm(ctxt);
>  
>  	return X86EMUL_CONTINUE;
> +
> +emulate_shutdown:
> +	ctxt->ops->triple_fault(ctxt);
> +	return X86EMUL_UNHANDLEABLE;

I'm probably missing something, but what's the desired effect of both
raising KVM_REQ_TRIPLE_FAULT and returning X86EMUL_UNHANDLEABLE here?

I've modified smm selftest to see what's happening:

diff --git a/tools/testing/selftests/kvm/x86_64/smm_test.c b/tools/testing/selftests/kvm/x86_64/smm_test.c
index 613c42c5a9b8..cf215cd2c6e2 100644
--- a/tools/testing/selftests/kvm/x86_64/smm_test.c
+++ b/tools/testing/selftests/kvm/x86_64/smm_test.c
@@ -147,6 +147,11 @@ int main(int argc, char *argv[])
                            "Unexpected stage: #%x, got %x",
                            stage, stage_reported);
 
+               if (stage_reported == SMRAM_STAGE) {
+                       /* corrupt smram */
+                       memset(addr_gpa2hva(vm, SMRAM_GPA) + 0xfe00, 0xff, 512);
+               }
+
                state = vcpu_save_state(vm, VCPU_ID);
                kvm_vm_release(vm);
                kvm_vm_restart(vm, O_RDWR);

What I see is:

        smm_test-7600  [002]  4497.073918: kvm_exit:             reason EXIT_RSM rip 0x8004 info 0 0
        smm_test-7600  [002]  4497.073921: kvm_emulate_insn:     1000000:8004: 0f aa
        smm_test-7600  [002]  4497.073924: kvm_smm_transition:   vcpu 1: leaving SMM, smbase 0x1000000
        smm_test-7600  [002]  4497.073928: kvm_emulate_insn:     0:8004: 0f aa FAIL
        smm_test-7600  [002]  4497.073929: kvm_fpu:              unload
        smm_test-7600  [002]  4497.073930: kvm_userspace_exit:   reason KVM_EXIT_INTERNAL_ERROR (17)

If I change X86EMUL_UNHANDLEABLE to X86EMUL_CONTINUE tripple fault is
happening indeed (why don't we have triple fault printed in trace by
default BTW???):

        smm_test-16810 [006]  5117.007220: kvm_exit:             reason EXIT_RSM rip 0x8004 info 0 0
        smm_test-16810 [006]  5117.007222: kvm_emulate_insn:     1000000:8004: 0f aa
        smm_test-16810 [006]  5117.007225: kvm_smm_transition:   vcpu 1: leaving SMM, smbase 0x1000000
        smm_test-16810 [006]  5117.007229: bputs:                vcpu_enter_guest: KVM_REQ_TRIPLE_FAULT
        smm_test-16810 [006]  5117.007230: kvm_fpu:              unload
        smm_test-16810 [006]  5117.007230: kvm_userspace_exit:   reason KVM_EXIT_SHUTDOWN (8)

So should we actually have X86EMUL_CONTINUE when we queue
KVM_REQ_TRIPLE_FAULT here?

(Initially, my comment was supposed to be 'why don't you add
TRIPLE_FAULT to smm selftest?' but the above overshadows it)

>  }
>  
>  static void
> diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
> index 3e870bf9ca4d..9c34aa60e45f 100644
> --- a/arch/x86/kvm/kvm_emulate.h
> +++ b/arch/x86/kvm/kvm_emulate.h
> @@ -233,6 +233,7 @@ struct x86_emulate_ops {
>  	int (*pre_leave_smm)(struct x86_emulate_ctxt *ctxt,
>  			     const char *smstate);
>  	void (*post_leave_smm)(struct x86_emulate_ctxt *ctxt);
> +	void (*triple_fault)(struct x86_emulate_ctxt *ctxt);
>  	int (*set_xcr)(struct x86_emulate_ctxt *ctxt, u32 index, u64 xcr);
>  };
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 54d212fe9b15..cda148cf06fa 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -7123,6 +7123,11 @@ static void emulator_post_leave_smm(struct x86_emulate_ctxt *ctxt)
>  	kvm_smm_changed(emul_to_vcpu(ctxt));
>  }
>  
> +static void emulator_triple_fault(struct x86_emulate_ctxt *ctxt)
> +{
> +	kvm_make_request(KVM_REQ_TRIPLE_FAULT, emul_to_vcpu(ctxt));
> +}
> +
>  static int emulator_set_xcr(struct x86_emulate_ctxt *ctxt, u32 index, u64 xcr)
>  {
>  	return __kvm_set_xcr(emul_to_vcpu(ctxt), index, xcr);
> @@ -7172,6 +7177,7 @@ static const struct x86_emulate_ops emulate_ops = {
>  	.set_hflags          = emulator_set_hflags,
>  	.pre_leave_smm       = emulator_pre_leave_smm,
>  	.post_leave_smm      = emulator_post_leave_smm,
> +	.triple_fault        = emulator_triple_fault,
>  	.set_xcr             = emulator_set_xcr,
>  };

-- 
Vitaly

