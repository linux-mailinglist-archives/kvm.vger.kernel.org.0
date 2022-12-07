Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F9CC646247
	for <lists+kvm@lfdr.de>; Wed,  7 Dec 2022 21:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbiLGUSw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 15:18:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiLGUSu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 15:18:50 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D999F7B4FC
        for <kvm@vger.kernel.org>; Wed,  7 Dec 2022 12:18:49 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id v13-20020a17090a6b0d00b00219c3be9830so2802677pjj.4
        for <kvm@vger.kernel.org>; Wed, 07 Dec 2022 12:18:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=F9KglUcXmpEUXeveFw3ftmZ0RpIkPUbK5Iynq+rmQ1U=;
        b=tAjLHPlVK35YfaW2yOjGrAtE3p9qUpYRayuwMdxaaJHaPqpWoNW9QRWCpAeChY0vuE
         ICzGaY3CQbe9QSWxJcgTiiM8gZ/rYfB/hH+NJCBRLPZq6E5WdL75oU4huveP1cE9h8ME
         x6p9vrlZnhUPrpBuNzpm4dOCHH4lr9x8tQiWrDzbkpL8Sm7JbMrEbT7KjnuY+qCMm5Ru
         HBv6joBMzj99LQtln3dMN77YXAJj3hs9UNXmyYKipo30HBjHuAIPRbhyBMzaAZXvJgXy
         HAYbTqEdB+xgV46G9XhFPl2On+vIvke69Amb/51T0gbyayb/p4AfaARmSe2JvqCJkvHe
         tcVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F9KglUcXmpEUXeveFw3ftmZ0RpIkPUbK5Iynq+rmQ1U=;
        b=GQyT1ih1uQGuQL7yHvp7GVmhADkQo7iJBJlF4ZYivoFqYFteASQwpKkn5QWgL1Avge
         Hvgy++G2EKOoJwpBtJl+APkBvpJRUPgSnatH3CkduLHw5vVgU5MFTP+3Ga55Zioxurc0
         XQ3HeG1brX/9walCCMzqU4322uHjl0RH2WjFFji2yVDXBbugNeyGkbgIso0pM9Lg5UA7
         UoXAPSBU6KfsPv4l7QqmEYt+KZcXly5PNtjsSQmEOVfEACJ2ItPgVqWfwsnZgLLsAEFi
         ACHbwcs/Unr+KcAXD/ThaHNoUSYHbz4CJqJFCWQNzCm2jHTQQy+YDKJgyennlpdVwr5x
         y+1g==
X-Gm-Message-State: ANoB5pluTaU98OCONIQVRCqVzDdWXCEF4aaW4wszbqFd2+Ig6eEBWUaY
        blgflrGTF/4f9zpVjxa9qURd/g==
X-Google-Smtp-Source: AA0mqf4pHk1KVYrkiUB2wVKGvoX4gw4UiVGdwFBWVpKd/8hxna4ynvmzbJmceYsIx64lVFs3s8bqeg==
X-Received: by 2002:a05:6a20:e185:b0:a7:882e:3a18 with SMTP id ks5-20020a056a20e18500b000a7882e3a18mr1511159pzb.1.1670444329178;
        Wed, 07 Dec 2022 12:18:49 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id k85-20020a628458000000b0057725613627sm4801503pfd.142.2022.12.07.12.18.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 12:18:48 -0800 (PST)
Date:   Wed, 7 Dec 2022 20:18:45 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jon Kohler <jon@nutanix.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: X86: set EXITING_GUEST_MODE as soon as vCPU exits
Message-ID: <Y5D1JWutV7+nARxS@google.com>
References: <20221129182226.82087-1-jon@nutanix.com>
 <Y4j9u6YEpJ/px6kj@google.com>
 <B9071742-7C64-40F4-8A93-D61DC1FD4CE5@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <B9071742-7C64-40F4-8A93-D61DC1FD4CE5@nutanix.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 05, 2022, Jon Kohler wrote:
> 
> > On Dec 1, 2022, at 2:17 PM, Sean Christopherson <seanjc@google.com> wrote:
> >> Changing vcpu->mode away from IN_GUEST_MODE as early as possible
> > 
> > Except this isn't as early as possible.  If we're going to bother doing something
> > like this, my vote is to move it into assembly.
> 
> In vmenter.S, tacking on to call vmx_spec_ctrl_restore_host seemed like the
> most logical place after handling all of the state saves and RSB work. Are you
> saying put it even closer to the exit, meaning before the FILL_RETURN_BUFFER?

Yes, assuming that's safe, in which case it's truly the "as early as possible"
location.

> >> gives IPI senders as much runway as possible to avoid ringing
> >> doorbell or sending posted interrupt IPI in AMD and Intel,
> >> respectively. Since this is done without an explicit memory
> >> barrier, the worst case is that the IPI sender sees IN_GUEST_MODE
> >> still and sends a spurious event, which is the behavior prior
> >> to this patch.
> > 
> > No, worst case scenario is that kvm_vcpu_exiting_guest_mode() sees EXITING_GUEST_MODE
> > and doesn't kick the vCPU.  For "kicks" that set a request, kvm_vcpu_exit_request()
> > will punt the vCPU out of the tight run loop, though there might be ordering issues.
> > 
> > But whether or not there are ordering issues is a moot point since there are uses
> > of kvm_vcpu_kick() that aren't accompanied by a request, e.g. to purge the PML
> > buffers.  In other words, kvm_vcpu_kick() absolutely cannot have false negatives.
> > We could modify KVM to require a request when using kvm_vcpu_kick(), but that's
> > a bit of a hack, and all of the possible ordering problems is still a pile of
> > complexity I'd rather avoid.
> > 
> > No small part of me thinks we'd be better off adding a dedicated flag to very
> > precisely track whether or not the vCPU is truly "in the guest" for the purposes
> > of sending IPIs.  Things like kicks have different requirements around IN_GUEST_MODE
> > than sending interrupts, e.g. KVM manually processes the IRR on every VM-Enter and
> > so lack of an IPI is a non-issue, whereas missing an IPI for a kick is problematic.
> > In other words, EXITING_GUEST_MODE really needs to mean "existing the run loop".
> 
> Do you mean:
> “one small part” (as in give this a shot, maybe), 
> or 
> “no small part” (as in good-god-don’t-do-this!)

Neither.  "No small part" as in "Most of my brain", i.e. "I haven't completely
thought things through, but I think we'd be better off adding a dedicated flag".

> I’m assuming you meant one small part :) sure, how about something like:
> 
> To my earlier comment about when to do this within a few instructions, I don’t want
> to clobber other stuff happening as part of the enter/exit, what if we repurposed/renamed
> vmx_update_host_rsp and vmx_spec_ctrl_restore_host to make them “do stuff before
> entry” and “do stuff right after entry returns” functions. That way we wouldn’t have to
> add another other function calls or change the existing control flow all that much.

I'd prefer not to wrap vmx_update_host_rsp(), that thing is a very special
snowflake.

I don't see why we'd have to add function calls or change the existing control
flow anyways.  The asm flows for VMX and SVM both take the vCPU in the form of
@vmx and @svm, so accessing the proposed excution mode field is just a matter of
adding an entry in arch/x86/kvm/kvm-asm-offsets.c.

And now that kvm-asm-offsets.c exists, I think it makes sense to drop the @regs
parameter for __vmx_vcpu_run(), e.g. to roughly match __svm_vcpu_run().

With that done as prep, accessing the vCPU immediately before/after VM-Enter and
VM-Exit is easy.

As a rough, incomplete sketch for VMX:

diff --git a/arch/x86/kvm/vmx/vmenter.S b/arch/x86/kvm/vmx/vmenter.S
index 766c6b3ef5ed..f80553e34f26 100644
--- a/arch/x86/kvm/vmx/vmenter.S
+++ b/arch/x86/kvm/vmx/vmenter.S
@@ -102,7 +102,7 @@ SYM_FUNC_START(__vmx_vcpu_run)
         * an LFENCE to stop speculation from skipping the wrmsr.
         */
 
-       /* Load @regs to RAX. */
+       /* Load @vmx to RAX. */
        mov (%_ASM_SP), %_ASM_AX
 
        /* Check if vmlaunch or vmresume is needed */
@@ -125,7 +125,11 @@ SYM_FUNC_START(__vmx_vcpu_run)
        mov VCPU_R14(%_ASM_AX), %r14
        mov VCPU_R15(%_ASM_AX), %r15
 #endif
-       /* Load guest RAX.  This kills the @regs pointer! */
+
+       /* Mark the vCPU as executing in the guest! */
+       movb $IN_GUEST_MODE, VCPU_EXECUTION_MODE(_%ASM_AX)
+
+       /* Load guest RAX.  This kills the @vmx pointer! */
        mov VCPU_RAX(%_ASM_AX), %_ASM_AX
 
        /* Check EFLAGS.ZF from 'testb' above */
@@ -163,9 +167,11 @@ SYM_INNER_LABEL(vmx_vmexit, SYM_L_GLOBAL)
        /* Temporarily save guest's RAX. */
        push %_ASM_AX
 
-       /* Reload @regs to RAX. */
+       /* Reload @vmx to RAX. */
        mov WORD_SIZE(%_ASM_SP), %_ASM_AX
 
+       movb $IN_HOST_MODE, VCPU_EXECUTION_MODE(_%ASM_AX)
+
        /* Save all guest registers, including RAX from the stack */
        pop           VCPU_RAX(%_ASM_AX)
        mov %_ASM_CX, VCPU_RCX(%_ASM_AX)
@@ -189,9 +195,12 @@ SYM_INNER_LABEL(vmx_vmexit, SYM_L_GLOBAL)
        xor %ebx, %ebx
 
 .Lclear_regs:
-       /* Discard @regs.  The register is irrelevant, it just can't be RBX. */
+       /* Pop @vmx.  The register can be anything except RBX. */
        pop %_ASM_AX
 
+       /* Set the execution mode (again) in case of VM-Fail. */
+       movb $IN_HOST_MODE, VCPU_EXECUTION_MODE(_%ASM_AX)
+
        /*
         * Clear all general purpose registers except RSP and RBX to prevent
         * speculative use of the guest's values, even those that are reloaded


> In “do before” we could set something like vcpu->non_root_mode = true
> In “do after” we could set vcpu->non_root_mode = false
> 
> Or perhaps something like (respectively)
> vcpu->operational_state = NON_ROOT_MODE
> vcpu->operational_state = ROOT_MODE
>
> Using the root/non-root moniker would precisely track when the whether the 
> vCPU is in guest, and aligns with the language used to describe such a state
> from the SDM.
> 
> Thoughts?

No, we should use KVM-defined names, not VMX-defined names, because we'll want
the same logic for SVM.  If we first rename GUEST_MODE => RUN_LOOP, then we can
use IN_GUEST_MODE and IN_HOST_MODE or whatever.
