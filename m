Return-Path: <kvm+bounces-61247-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id F0288C12281
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 01:24:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 709344EA699
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 00:24:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7505C1DE3AC;
	Tue, 28 Oct 2025 00:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="opHDT9iy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAFA01D130E
	for <kvm@vger.kernel.org>; Tue, 28 Oct 2025 00:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761611091; cv=none; b=B+OUDyVz9wNTxb3rfR/QmmuZD6s50zyMBl42/uBz7vembFCbVBFpdkAE5L2Wa1dL/yZmDHSaMZsZRzYRK/2yG97M8I/5coUZ1sSSwi6UjbXRRIlMfRUZUwKqALkkLnmFjWAotBvyHQJbBSp6R80pQXW5VBBNyFIItLLVURiLTVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761611091; c=relaxed/simple;
	bh=atAI6y76jJfrPd92qsZ3/Jh+Tjki2McZ31Qx30kvvN4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rZTXLyO2eYLPIN5MxYs7T0e/3lQPoSNJt2EMo3xz9E/sD8hyQrIG0F8Sq4Bl8SQ+hbEHVxdHmOsujimI5lrmsC//85i9ppatJHAYPODFuj1Y7t8ApsnnRbb8PY1eM5647pHyrlDDUmQLeT4RCq2qSRWQFgGEt1IR9HNE+i4vjxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=opHDT9iy; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-33bbbb41a84so12116184a91.1
        for <kvm@vger.kernel.org>; Mon, 27 Oct 2025 17:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761611089; x=1762215889; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yxsHXELdqyxJojPRQnigfV5qRDfj6h3fT9Q5pk8hxSk=;
        b=opHDT9iyBaUTo88eQe2YD40CyPYVeZHYcRJdEMhMXRWuUQHgXqLpnoOwFOcVsKeq6A
         afrIyky346Y0THfc5YcodMRPC7Tpidunb9zutBd83m06pxz2wuZBePTJAqaxlIQCbF5k
         nLdhmVPnQaysxOUGCRbV+HYoho7smokabivL6fJrxmyHTrzdpEf9++k2Fc4bcYCRMm44
         /BwxICkweykThB9PvFYJdpLVO9NZUJ+zIh+z0ibalmkUrJrual+GUpeX1striWlEt4rb
         lO+ZL8ZKe7txWMyYxI44Vx4hppedCWPsUBzV4JpugWLexkGhxCBOMTqhvR7aH896XMOb
         ofLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761611089; x=1762215889;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yxsHXELdqyxJojPRQnigfV5qRDfj6h3fT9Q5pk8hxSk=;
        b=k53Hux8h9Yk+k8H2Rgc8O3SjRGGJKhjosxBM+FGMjeMnalnmkRuvtbfYOm82tijgLp
         PYPFqg6QfXeejuav3XSfQ9boxDoJrQh/lMlCovjk2MNvL/84WEbSwnONMYR07MRQq+VJ
         x2UntXmjdJIu2N18jpKa89XpYWUl8NYVcwH0b0GmDMgFihTAfpiJR+yBTbgoa83kTcyo
         yUgnc3wz3KibIqAT3cADB6yi9rL4qfWTDltNib4l0V24hseiHLwN4CgGiqb9HqIoZJvn
         0JSLApuuvBRLcGrRc9lq3vmW6mew/v4+LNzmhaxedLpf0pnNwcYttdgv85hjPlUFS5/h
         es1A==
X-Forwarded-Encrypted: i=1; AJvYcCUZHgBAyukw6Bg83RqfIjOnWVpVrJ41WgtFBepSDszhlnR5m5Hn34sTX+PH5g2GoZI5hzI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwdtT9u2ksUoDP8eYZeeTOe5AJex52vBu8puBEw3GkB4B/X+6BG
	QuNOEACstOw1W5qlNccNSKdrVzi6j6uj9v3j9SW2MX7qqLf7v/ljIP+T2VQ2LxRmPqmZVbJHY2k
	bD5m8dA==
X-Google-Smtp-Source: AGHT+IFpMn97Za4SpK3cWhd+eILnGdcKWrPEoax0ckLz8nifzOnGOLK/4bRjAJ22FW6F3RlIfFK/8TaM56U=
X-Received: from pjyj23.prod.google.com ([2002:a17:90a:e617:b0:339:ae3b:2bc7])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4f48:b0:32e:9281:7c7b
 with SMTP id 98e67ed59e1d1-340279e5095mr1785783a91.3.1761611089180; Mon, 27
 Oct 2025 17:24:49 -0700 (PDT)
Date: Mon, 27 Oct 2025 17:24:47 -0700
In-Reply-To: <71043b76fc073af0fb27493a8e8d7f38c3c782c0.1761606191.git.osandov@fb.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <71043b76fc073af0fb27493a8e8d7f38c3c782c0.1761606191.git.osandov@fb.com>
Message-ID: <aQANT9rvO9FMmmkG@google.com>
Subject: Re: [PATCH] KVM: SVM: Don't skip unrelated instruction if INT3 is replaced
From: Sean Christopherson <seanjc@google.com>
To: Omar Sandoval <osandov@osandov.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	Gregory Price <gourry@gourry.net>, kernel-team@fb.com
Content-Type: text/plain; charset="us-ascii"

"INT3/INTO", because the code handles both.

On Mon, Oct 27, 2025, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> We've been seeing guest VM kernel panics with "Oops: int3" coming from

No pronouns please, "we" relies too much on context and that context can be lost
over time, or might be interpreted differently by readers, etc.

> static branch checks. I found that the reported RIP is one instruction
> after where it's supposed to be, and I determined that when this
> happens, the RIP was injected by __svm_skip_emulated_instruction() on
> the host when a nested page fault was hit while vectoring an int3.

I definitely appreciate the gory details, but please capture just the technical
details of the bug and fix.  A play-by-play of the debugging process is useful
(and interesting!) for bug reports and cover letters, but it's mostly noise for
future readers that usually care about what was changed and/or what the code is
doing.

> Static branches use the smp_text_poke mechanism, which works by
> temporarily inserting an int3, then overwriting it. In the meantime,
> smp_text_poke_int3_handler() relies on getting an accurate RIP.
> 
> This temporary int3 from smp_text_poke is triggering the exact scenario
> described in the fixes commit: "if the guest executes INTn (no KVM
> injection), an exit occurs while vectoring the INTn, and the guest
> modifies the code stream while the exit is being handled, KVM will
> compute the incorrect next_rip due to "skipping" the wrong instruction."
> 
> I'm able to reproduce this almost instantly by patching the guest kernel
> to hammer on a static branch [1] while a drgn script [2] on the host
> constantly swaps out the memory containing the guest's Task State
> Segment.

I would actually just say "TSS".  Normally I'm all for spelling out acronyms on
their first use, but in this case I think TSS is more obviously a "thing" than
Task State Segment, e.g. I had a momentary brain fart and was wondering what you
meant by swapping out a segment :-).

> The fixes commit also suggests a workaround: "A future enhancement to
> make this less awful would be for KVM to detect that the decoded
> instruction is not the correct INTn and drop the to-be-injected soft
> event." This implements that workaround.

Please focus on the actual change.  Again, I love the detail, but that was a _lot_
to get through just to see "Sorry, but the princess is in another castle." :-D

E.g. I think this captures everything in about the same word count, but with a
stronger focus on what the patch is actually doing.

  When re-injecting an soft interrupt from an INT3, INT0, or (select) INTn
  instruction, discard the exception and retry the instruction if the code
  stream is changed (e.g. by a different vCPU) between when the CPU executes
  the instruction and when KVM decodes the instruction to get the next RIP.

  As effectively predicted by commit 6ef88d6e36c2 ("KVM: SVM: Re-inject
  INT3/INTO instead of retrying the instruction"), failure to verify the
  correct INTn instruction was decoded can effectively clobber guest state
  due to decoding the wrong instruction and thus specifying the wrong next
  RIP.

  The bug most often manifests as "Oops: int3" panics on static branch
  checks when running Linux guests.  Linux's static branch patching uses
  he kernel's "text poke" code patching   mechanism.  To modify code while
  other CPUs may be executing said code, Linux (temporarily) replaces the
  first byte of the original instruction with an int3 (opcode 0xcc), then
  patches in the new code stream except for the first byte, and finally
  replaces the int3 the first byte of the new code stream.  If a CPU hits
  the int3, i.e. executes the code while it's being modified, the guest
  kernel will gracefully handle the resulting #BP, e.g. by looping until
  the int3 is replaced, by emulating the new instruction, etc.

  E.g. the bug reproduces almost instantly by hacking the guest kernel to
  provide a convenient static branch[1], while running a drgn script[2] on
  the host to constantly swap out the memory containing the guest's TSS.

> [1]: https://gist.github.com/osandov/44d17c51c28c0ac998ea0334edf90b5a
> [2]: https://gist.github.com/osandov/10e45e45afa29b11e0c7209247afc00b
> 
> Fixes: 6ef88d6e36c2 ("KVM: SVM: Re-inject INT3/INTO instead of retrying the instruction")

Cc: stable@vger.kernel.org

> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
> Based on Linus's current tree.
> 
>  arch/x86/kvm/svm/svm.c | 40 ++++++++++++++++++++++++++++++++++++----
>  1 file changed, 36 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 153c12dbf3eb..4d72c308b50b 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -271,8 +271,29 @@ static void svm_set_interrupt_shadow(struct kvm_vcpu *vcpu, int mask)
>  
>  }
>  
> +static bool emulated_instruction_matches_vector(struct kvm_vcpu *vcpu,
> +						unsigned int vector)
> +{
> +	switch (vector) {
> +	case BP_VECTOR:
> +		return vcpu->arch.emulate_ctxt->b == 0xcc ||
> +		       (vcpu->arch.emulate_ctxt->b == 0xcd &&
> +			vcpu->arch.emulate_ctxt->src.val == BP_VECTOR);
> +	case OF_VECTOR:
> +		return vcpu->arch.emulate_ctxt->b == 0xce;

Hmm, unless I'm missing something, this should handle 0xcd for both.

> +	default:
> +		return false;
> +	}
> +}
> +
> +/*
> + * If vector != 0, then this skips the instruction only if the instruction could
> + * generate an interrupt with that vector. If not, then it fails, indicating
> + * that the instruction should be retried.
> + */
>  static int __svm_skip_emulated_instruction(struct kvm_vcpu *vcpu,
> -					   bool commit_side_effects)
> +					   bool commit_side_effects,
> +					   unsigned int vector)
>  {
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	unsigned long old_rflags;
> @@ -293,8 +314,18 @@ static int __svm_skip_emulated_instruction(struct kvm_vcpu *vcpu,
>  		if (unlikely(!commit_side_effects))
>  			old_rflags = svm->vmcb->save.rflags;
>  
> -		if (!kvm_emulate_instruction(vcpu, EMULTYPE_SKIP))
> +		if (vector == 0) {
> +			if (!kvm_emulate_instruction(vcpu, EMULTYPE_SKIP))
> +				return 0;
> +		} else if (x86_decode_emulated_instruction(vcpu, EMULTYPE_SKIP,
> +							   NULL,
> +							   0) != EMULATION_OK ||

I think I would rather handle this in kvm_emulate_instruction(), not in the SVM
code.  x86_decode_emulated_instruction() really shouldn't be exposed outside of
x86.c, the use in gp_interception() is all kinds of gross. :-/

The best idea I can come up with is to add an EMULTYPE_SKIP_SOFT_INT, and use that
to communicate to the kvm_emulate_instruction() that it should verify the
to-be-skipped instruction.  I don't love the implicit passing of the vector via
vcpu->arch.exception.vector, but all of this code is quite heinous, so I won't
loose sleep over it.

Compile-tested only, but something like this?

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 2bfae1cfa514..eca4704e3934 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2154,6 +2154,7 @@ u64 vcpu_tsc_khz(struct kvm_vcpu *vcpu);
 #define EMULTYPE_PF                (1 << 6)
 #define EMULTYPE_COMPLETE_USER_EXIT (1 << 7)
 #define EMULTYPE_WRITE_PF_TO_SP            (1 << 8)
+#define EMULTYPE_SKIP_SOFT_INT     ((1 << 9) | EMULTYPE_SKIP)
 
 static inline bool kvm_can_emulate_event_vectoring(int emul_type)
 {
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f14709a511aa..82e97f2f8635 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -272,6 +272,7 @@ static void svm_set_interrupt_shadow(struct kvm_vcpu *vcpu, int mask)
 }
 
 static int __svm_skip_emulated_instruction(struct kvm_vcpu *vcpu,
+                                          int emul_type,
                                           bool commit_side_effects)
 {
        struct vcpu_svm *svm = to_svm(vcpu);
@@ -293,7 +294,7 @@ static int __svm_skip_emulated_instruction(struct kvm_vcpu *vcpu,
                if (unlikely(!commit_side_effects))
                        old_rflags = svm->vmcb->save.rflags;
 
-               if (!kvm_emulate_instruction(vcpu, EMULTYPE_SKIP))
+               if (!kvm_emulate_instruction(vcpu, emul_type))
                        return 0;
 
                if (unlikely(!commit_side_effects))
@@ -311,7 +312,7 @@ static int __svm_skip_emulated_instruction(struct kvm_vcpu *vcpu,
 
 static int svm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
 {
-       return __svm_skip_emulated_instruction(vcpu, true);
+       return __svm_skip_emulated_instruction(vcpu, EMULTYPE_SKIP, true);
 }
 
 static int svm_update_soft_interrupt_rip(struct kvm_vcpu *vcpu)
@@ -331,7 +332,7 @@ static int svm_update_soft_interrupt_rip(struct kvm_vcpu *vcpu)
         * in use, the skip must not commit any side effects such as clearing
         * the interrupt shadow or RFLAGS.RF.
         */
-       if (!__svm_skip_emulated_instruction(vcpu, !nrips))
+       if (!__svm_skip_emulated_instruction(vcpu, EMULTYPE_SKIP_SOFT_INT, !nrips))
                return -EIO;
 
        rip = kvm_rip_read(vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 593fccc9cf1c..500f9b7f564e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9351,6 +9351,23 @@ static bool is_vmware_backdoor_opcode(struct x86_emulate_ctxt *ctxt)
        return false;
 }
 
+static bool is_soft_int_instruction(struct x86_emulate_ctxt *ctxt, u8 vector)
+{
+       if (WARN_ON_ONCE(vector != BP_VECTOR && vector != OF_VECTOR))
+               return false;
+
+       switch (ctxt->b) {
+       case 0xcc:
+               return vector == BP_VECTOR;
+       case 0xcd:
+               return vector == ctxt->src.val;
+       case 0xce:
+               return vector == OF_VECTOR;
+       default:
+               return false;
+       }
+}
+
 /*
  * Decode an instruction for emulation.  The caller is responsible for handling
  * code breakpoints.  Note, manually detecting code breakpoints is unnecessary
@@ -9461,6 +9478,10 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
         * injecting single-step #DBs.
         */
        if (emulation_type & EMULTYPE_SKIP) {
+               if ((emulation_type & EMULTYPE_SKIP_SOFT_INT) &&
+                   !is_soft_int_instruction(ctxt, vcpu->arch.exception.vector))
+                       return 0;
+
                if (ctxt->mode != X86EMUL_MODE_PROT64)
                        ctxt->eip = (u32)ctxt->_eip;
                else

