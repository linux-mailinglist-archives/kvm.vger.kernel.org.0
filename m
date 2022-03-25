Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 618E54E7E09
	for <lists+kvm@lfdr.de>; Sat, 26 Mar 2022 01:23:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiCYXyr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Mar 2022 19:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbiCYXyq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Mar 2022 19:54:46 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE0FBBAE
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 16:53:10 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id g9-20020a17090ace8900b001c7cce3c0aeso4813195pju.2
        for <kvm@vger.kernel.org>; Fri, 25 Mar 2022 16:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=K6J5hCKFL43U/5XhxlzeGfnsIRLQEw7YBWp1K+rr+2w=;
        b=IrXKFjMNe+D1F7eXvOxNIQf5EBYDyPfDwPkK4fbv8837QXNJoNrEEsvrymDayo0jZx
         ogaPXKYEYK95+zrBAlGdcbhUcsjEj9nraU8DMb60SAgLXXQgrQw4c0UgJ9nNfEdc309F
         Rg6ifOLzkNJY2jbaOpIvv/kG20NNBpjChagh4MDn9i2jRyezsZNRPZT8ODJIG+pysgFs
         0JofJXFHcyaQP6m1l9zeyTA84i8l1+Eo/znW7qHbM2UWtVoUB0/musxRVJj5cMqtrjng
         ddg6bUyxGj4eW2S4vFPxnOt4E3eP1urf9EP5SPnUU4eoUOScLwN6IK0N/wFBjzNwJLIx
         p8bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=K6J5hCKFL43U/5XhxlzeGfnsIRLQEw7YBWp1K+rr+2w=;
        b=Q47S5MuDX8ryZ5MNOfjjHY3mXVOqOI14pDZ4jCTWNL8fibReKdVE+0SyWXMVOCeUMy
         D1Glni3dDoR5/PI9SOs7tDQNBUvUVtxu/hJDlTH5hEn4uKzZHrG+GWX57ZDrxHUrBJhu
         KJj//YrCMqqzawjcqFRYTI34RKc3XpiZbJf0f9mLYfxgFIVCFNb0B5sOTj5gUV7D9a09
         ZfNo0FLjseCTWs9GoTRniF2V472fGaSAfVAn/w2tVA6eu+OAOIUkZPZLweHrgpi/AHSS
         BTcNhVv4oFd8TiuIMysz5ptE306Y/CI/ZlqUL6P9KIbFnMJt7Ee+iAD20EQNsNHVjow0
         rCxw==
X-Gm-Message-State: AOAM530rkBMk+phR/f4ZEmVszmDIq+CTfl9sXYHK3HXzaF1LpGV1lSM2
        2pWizzp4zaw9GAMLYX6dnBeWRA==
X-Google-Smtp-Source: ABdhPJxSMViDz1hssnMa6Ld2Q5tkmyRKXSD+xjxwmLAMn7QnoHaJF5VKQXRch+m7g0VoNUMMjLzl0Q==
X-Received: by 2002:a17:902:c945:b0:154:5215:1da4 with SMTP id i5-20020a170902c94500b0015452151da4mr14260623pla.169.1648252390033;
        Fri, 25 Mar 2022 16:53:10 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id p4-20020a637404000000b00375948e63d6sm6044642pgc.91.2022.03.25.16.53.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 16:53:09 -0700 (PDT)
Date:   Fri, 25 Mar 2022 23:53:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oupton@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Dunn <daviddunn@google.com>,
        Peter Shier <pshier@google.com>
Subject: Re: [PATCH 1/2] KVM: x86: Allow userspace to opt out of hypercall
 patching
Message-ID: <Yj5V4adpnh8/B/K0@google.com>
References: <20220316005538.2282772-1-oupton@google.com>
 <20220316005538.2282772-2-oupton@google.com>
 <Yjyt7tKSDhW66fnR@google.com>
 <2a438f7c-4dea-c674-86c0-9164cbad0813@redhat.com>
 <YjzBB6GzNGrJdRC2@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjzBB6GzNGrJdRC2@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 24, 2022, Oliver Upton wrote:
> On Thu, Mar 24, 2022 at 06:57:18PM +0100, Paolo Bonzini wrote:
> > On 3/24/22 18:44, Sean Christopherson wrote:
> > > On Wed, Mar 16, 2022, Oliver Upton wrote:
> > > > KVM handles the VMCALL/VMMCALL instructions very strangely. Even though
> > > > both of these instructions really should #UD when executed on the wrong
> > > > vendor's hardware (i.e. VMCALL on SVM, VMMCALL on VMX), KVM replaces the
> > > > guest's instruction with the appropriate instruction for the vendor.
> > > > Nonetheless, older guest kernels without commit c1118b3602c2 ("x86: kvm:
> > > > use alternatives for VMCALL vs. VMMCALL if kernel text is read-only")
> > > > do not patch in the appropriate instruction using alternatives, likely
> > > > motivating KVM's intervention.
> > > > 
> > > > Add a quirk allowing userspace to opt out of hypercall patching.
> > > 
> > > A quirk may not be appropriate, per Paolo, the whole cross-vendor thing is
> > > intentional.
> > > 
> > > https://lore.kernel.org/all/20211210222903.3417968-1-seanjc@google.com
> > 
> > It's intentional, but the days of the patching part are over.
> > 
> > KVM should just call emulate_hypercall if called with the wrong opcode
> > (which in turn can be quirked away).  That however would be more complex to
> > implement because the hypercall path wants to e.g. inject a #UD with
> > kvm_queue_exception().
> > 
> > All this makes me want to just apply Oliver's patch.
> > 
> > > > +	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_FIX_HYPERCALL_INSN)) {
> > > > +		ctxt->exception.error_code_valid = false;
> > > > +		ctxt->exception.vector = UD_VECTOR;
> > > > +		ctxt->have_exception = true;
> > > > +		return X86EMUL_PROPAGATE_FAULT;
> > > 
> > > This should return X86EMUL_UNHANDLEABLE instead of manually injecting a #UD.  That
> > > will also end up generating a #UD in most cases, but will play nice with
> > > KVM_CAP_EXIT_ON_EMULATION_FAILURE.
> 
> Sean and I were looking at this together right now, and it turns out
> that returning X86EMUL_UNHANDLEABLE at this point will unconditionally
> bounce out to userspace.
> 
> x86_decode_emulated_instruction() would need to be the spot we bail to
> guard these exits with the CAP.

I've spent waaay too much time thinking about this...

TL;DR: I'm in favor of applying the patch as-is.

My objection to manually injecting the #UD is that there's no guarantee that KVM
is actually handling a #UD.  It's largely a moot point, as KVM barfs on VMCALL/VMMCALL
if it's _not_ from a #UD, e.g. KVM hangs the guest if it does a VMCALL when KVM is
emulating due to lack of unrestricted guest.  Forcing #UD is probably a net positive
in that case, as it will cause KVM to ultimately fail with "emulation error" and
bail to userspace.

It is possible to handle this in decode (idea below), but it will set us up for
pain later.  If KVM ever does gain support for truly emulating hypercall, then as
Paolo said, the question of whether to emulate the "wrong" hypercall is orthogonal
to whether or not to patch.  The correct way to check if the "wrong" hypercall
should be emulated would be to query the vCPU vendor via guest's CPUID, at which
point we _do_ want to get into em_hypercall() on UD to do the CPUID check even if
the quirk is disabled.  So I agree with Paolo, make it a quirk that guards the
patching, and document that because of KVM's deficiencies, that also happens to
mean that encountering the "wrong" hypercall is fatal to the guest.  Maybe fodder
for KVM's new vCPU errata? :-)  If we fix that erratum, then the quirk can be
modified to only skip the patching.

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index be83c9c8482d..29abeaf605e2 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -5248,9 +5248,15 @@ int x86_decode_insn(struct x86_emulate_ctxt *ctxt, void *insn, int insn_len, int

        ctxt->execute = opcode.u.execute;

-       if (unlikely(emulation_type & EMULTYPE_TRAP_UD) &&
-           likely(!(ctxt->d & EmulateOnUD)))
-               return EMULATION_FAILED;
+       if (unlikely(emulation_type & EMULTYPE_TRAP_UD)) {
+               if (likely(!(ctxt->d & EmulateOnUD)))
+                       return EMULATION_FAILED;
+
+               /* blah blah blah */
+               if (ctxt->execute == em_hypercall &&
+                   !ctxt->has_quirk_fix_hypercall)
+                       return EMULATION_FAILED;
+       }

        if (unlikely(ctxt->d &
            (NotImpl|Stack|Op3264|Sse|Mmx|Intercept|CheckPerm|NearBranch|
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 1cbd46cf71f9..35d2f20d368c 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -305,6 +305,8 @@ struct x86_emulate_ctxt {
        void *vcpu;
        const struct x86_emulate_ops *ops;

+       bool has_quirk_fix_hypercall;
+
        /* Register state before/after emulation. */
        unsigned long eflags;
        unsigned long eip; /* eip before instruction emulation */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 685c4bc453b4..832f85e72978 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7915,6 +7915,8 @@ static struct x86_emulate_ctxt *alloc_emulate_ctxt(struct kvm_vcpu *vcpu)

        ctxt->vcpu = vcpu;
        ctxt->ops = &emulate_ops;
+       ctxt->has_quirk_fix_hypercall =
+               kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_FIX_HYPERCALL_INSN);
        vcpu->arch.emulate_ctxt = ctxt;

        return ctxt;
@@ -9291,16 +9293,8 @@ static int emulator_fix_hypercall(struct x86_emulate_ctxt *ctxt)
        char instruction[3];
        unsigned long rip = kvm_rip_read(vcpu);

-       /*
-        * If the quirk is disabled, synthesize a #UD and let the guest pick up
-        * the pieces.
-        */
-       if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_FIX_HYPERCALL_INSN)) {
-               ctxt->exception.error_code_valid = false;
-               ctxt->exception.vector = UD_VECTOR;
-               ctxt->have_exception = true;
-               return X86EMUL_PROPAGATE_FAULT;
-       }
+       if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_FIX_HYPERCALL_INSN))
+               return X86EMUL_CONTINUE;

        static_call(kvm_x86_patch_hypercall)(vcpu, instruction);


