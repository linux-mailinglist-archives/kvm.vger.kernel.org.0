Return-Path: <kvm+bounces-60537-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C29FBF1F9F
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 17:03:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id DA81A4EF859
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 15:03:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 324DF23D7CA;
	Mon, 20 Oct 2025 15:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e35AFnFe"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6FE44CB5B
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 15:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760972612; cv=none; b=JThoPQ+dHCnaVK1uTpMDaFY28sbjdKSzALxzq/57XZqKgRmy9ENRH5OemUffUGXpmCLPuwfSPSoFdi29tnyO6p4QUV2JiDgLuISPsvIAvyFrQJeFczHWtbG6Pvm7DXGhcOVCFmO345wJH/d5N1BOEgq8NPpPOYlMI6UKywhws+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760972612; c=relaxed/simple;
	bh=Ld62GVjO/0NV57t3vSm3KGieiENM0xCoBlbxOiv91fg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QBF8CeOLsVPgzkjCm+ydCaXGKfmV4F3J29nDBS4d5VSmQtuHUzVxagn/4Z1VyzGbWhgiGSs2TFsQjV4NaUvpwH6EbwXSt6Uj0Cn18nh7emj/mgXLERKoZCfQi0uzNvhGOnOzYZGPHy4c0IZAfmk8JQRbkKxzf1maUgPStdJqI9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e35AFnFe; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-33baf262850so4410884a91.0
        for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 08:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760972610; x=1761577410; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zL0bQ6/3gvtRqbV4MzYKUtzArdDuysj5d7SMlb+pduA=;
        b=e35AFnFemYsnBGNC2uxdM1dNeyCMY3iQ8JELi04iuF71QlccfJFrUW2CjVoh2CvVbL
         9Ebyq/kuISacnvH8YlmHxaVYIUhGhYi5QjKD2ZMPzNGKEVxGZS9oOIBbLL9ZrPJmwiuk
         0VblPQqMtmUH9ITSl2B7d51xiJCuz2NNdna/rgwm95dfTv0rGEGtYMEKRvzYrdkQROcI
         MR/xPUrchRSlzgY9ZRiLVJjZktoIFejjEqbAK86aPcZkV2S7ih0ChzbormR9rXHql9qe
         gpWfrLefKYxQtDG1fnFecxRwkJW9j36nXFslLE8RKRiiHcz2lY+TQJXEK6htXuZ1MlLO
         eQ+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760972610; x=1761577410;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zL0bQ6/3gvtRqbV4MzYKUtzArdDuysj5d7SMlb+pduA=;
        b=GPNZ21ExNR8DVeefmz7hS5z1YPS7CK8uwH4WvQJFChWBYNnphUt9E/CnfWeu5vKuZ5
         cvPxPXkB+2q+JNan17TmmGZVHDNdYfJH/HbGn4OCHyOktuBkyfqIFjsyxcJZE3oi7tb0
         ktdb9J2PBal+Y4La1+SAzcmbyiaffDhft0576g4EKpJsXOfuZGP2pgw/iA8r/O6tJCVA
         y882jfykEJkrv0C2R9ps03+p3QE56JBA/uIEu+IyKo8vsj2p12u+8f2JVBBKmqIfj9cH
         Nfy+LGbZIS1UQp1jlibdcH6G6gjqcibskFcGlf9uiF3Z0anmoqyxJo/EN0M1i1vHVQ+V
         m4Ng==
X-Forwarded-Encrypted: i=1; AJvYcCWXE2JOotveENN0f090ga+ppiczKS7khBG2dV66QgxU0BNNafwETzBwZJHvJIYu51/evrA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+7HQWND72W9iaY/ixpTlY9OwIHHHkbbt1+GYOspvemyWN/PnX
	Nn6/t0OxfVkQprg248aQAs9fIwANvDqAoTxyu3YI0Del1R9zOHfPRFg+7k/OigmOh8Dy4dJnJor
	tS06T3g==
X-Google-Smtp-Source: AGHT+IED+ZoRV9Gme3Hg8UT2kzR82Ieuz1hE30z96B//E9xmEt9U0Wk3RrQY+Fn044AfyylP6vcAWu/QPzk=
X-Received: from pjff13.prod.google.com ([2002:a17:90b:562d:b0:33d:69cf:1f82])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:ec8b:b0:32b:6145:fa63
 with SMTP id 98e67ed59e1d1-33bcf860229mr21306555a91.4.1760972609985; Mon, 20
 Oct 2025 08:03:29 -0700 (PDT)
Date: Mon, 20 Oct 2025 08:03:28 -0700
In-Reply-To: <0a49bd9b-e4d8-42eb-854c-e8730b5a58b7@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251016182148.69085-1-seanjc@google.com> <20251016182148.69085-3-seanjc@google.com>
 <46eb76240a29cb81b6a8aa41016466810abef559.camel@intel.com>
 <aPJ8A8u8zIvp-wB4@google.com> <38ac916f7c3ae7520708f37389f5524d9278c648.camel@intel.com>
 <0a49bd9b-e4d8-42eb-854c-e8730b5a58b7@intel.com>
Message-ID: <aPZPQCFNn__Vzz3O@google.com>
Subject: Re: [PATCH v2 2/2] KVM: TDX: WARN if a SEAMCALL VM-Exit makes its way
 out to KVM
From: Sean Christopherson <seanjc@google.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Kai Huang <kai.huang@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, Dan J Williams <dan.j.williams@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	Rick P Edgecombe <rick.p.edgecombe@intel.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Oct 20, 2025, Xiaoyao Li wrote:
> On 10/18/2025 4:58 AM, Huang, Kai wrote:
> > On Fri, 2025-10-17 at 10:25 -0700, Sean Christopherson wrote:
> > > On Fri, Oct 17, 2025, Kai Huang wrote:
> > > > While this exit should never happen from a TDX guest, I am wondering why
> > > > we need to explicitly handle the SEAMCALL?  E.g., per "Unconditionally
> > > > Blocked Instructions" ENCLS/ENCLV are also listed, therefore
> > > > EXIT_REASON_ELCLS/ENCLV should never come from a TDX guest either.
> > > 
> > > Good point.  SEAMCALL was obviously top of mind, I didn't think about all the
> > > other exits that should be impossible.
> > > 
> > > I haven't looked closely, at all, but I wonder if we can get away with this?
> > > 
> > > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > > index 097304bf1e1d..4c68444bd673 100644
> > > --- a/arch/x86/kvm/vmx/tdx.c
> > > +++ b/arch/x86/kvm/vmx/tdx.c
> > > @@ -2149,6 +2149,8 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
> > >                   */
> > >                  return 1;
> > >          default:
> > > +               /* All other known exits should be handled by the TDX-Module. */
> > > +               WARN_ON_ONCE(exit_reason.basic <= c);
> > >                  break;
> > >          }
> > 
> > Not 100% sure, but should be fine?  Needs more second eyes here.
> > 
> > E.g., when a new module feature makes another exit reason possible then
> > presumably we need explicit opt-in to that feature.
> > 
> > Don't quite follow 'exit_reason.basic <= c' part, though.  Maybe we can
> > just unconditional WARN_ON_ONCE()?
> > 
> > Or we can do things similar to VMX:
> > 
> >          vcpu_unimpl(vcpu, "vmx: unexpected exit reason 0x%x\n",
> >                      exit_reason.full);
> > 
> > Or just get rid of this patch :-)
> 
> I agree to it.
> 
> WARN_ON_ONCE() seems not provide more information except that we can
> identify quickly there is TDX module bug when it gets hit.

WARNs are helpful for fuzzing, e.g. with syzkaller, where userspace isn't going
to complain or even log anything if KVM_RUN fails.

> But it's not too hard to get these information from the
> KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON with vp_enter_ret in data[0].
> 
> And if we add WARN_ON_ONCE() here, we need to evaluate if it needs to update
> "EXIT_REASON_TDCALL" everytime a new EXIT reason is introduced.
> e.g., currently the largest exit reason number defined in SDM is 79 (for
> WRMSRLIST) and it is actually handled by TDX module and KVM cannot receive
> it from a TD vcpu.

Hmm, to some extent this is a case of "don't let perfect be the enemy of good
enough".  Just because we can't WARN on _all_ unexpected exits doesn't make
WARNing on the others useless.

That said, I agree that making the WARN conditional on the exit reason would be
a maintenance burden.  And I also agree with the implied "rule" that TDX should
follow whatever VMX is doing (and ideally SVM would behavior identically as well).

At the very least, we should consolidate that code.  And then we can have a broader
discussion on how exactly to add a WARN.  E.g. if for some reason we can't WARN
unconditionally, we could add an off-by-default module param.

I'll drop this patch and post a mini-series with the below to start a general
conversation on whether or not to WARN on unexpected exits.

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 48598d017d6f..4fbe4b7ce1da 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2167,6 +2167,7 @@ void __kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu,
 void kvm_prepare_emulation_failure_exit(struct kvm_vcpu *vcpu);
 
 void kvm_prepare_event_vectoring_exit(struct kvm_vcpu *vcpu, gpa_t gpa);
+void kvm_prepare_unexpected_reason_exit(struct kvm_vcpu *vcpu, u64 exit_reason);
 
 void kvm_enable_efer_bits(u64);
 bool kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index f14709a511aa..83e0d4d5f4c5 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3451,13 +3451,8 @@ static bool svm_check_exit_valid(u64 exit_code)
 
 static int svm_handle_invalid_exit(struct kvm_vcpu *vcpu, u64 exit_code)
 {
-       vcpu_unimpl(vcpu, "svm: unexpected exit reason 0x%llx\n", exit_code);
        dump_vmcb(vcpu);
-       vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-       vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
-       vcpu->run->internal.ndata = 2;
-       vcpu->run->internal.data[0] = exit_code;
-       vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
+       kvm_prepare_unexpected_reason_exit(vcpu, exit_code);
        return 0;
 }
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 326db9b9c567..079d9f13eddb 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2145,11 +2145,7 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
        }
 
 unhandled_exit:
-       vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-       vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
-       vcpu->run->internal.ndata = 2;
-       vcpu->run->internal.data[0] = vp_enter_ret;
-       vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
+       kvm_prepare_unexpected_reason_exit(vcpu, vp_enter_ret);
        return 0;
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 1021d3b65ea0..08f7957ed4c3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6642,15 +6642,8 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
        return kvm_vmx_exit_handlers[exit_handler_index](vcpu);
 
 unexpected_vmexit:
-       vcpu_unimpl(vcpu, "vmx: unexpected exit reason 0x%x\n",
-                   exit_reason.full);
        dump_vmcs(vcpu);
-       vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
-       vcpu->run->internal.suberror =
-                       KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
-       vcpu->run->internal.ndata = 2;
-       vcpu->run->internal.data[0] = exit_reason.full;
-       vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
+       kvm_prepare_unexpected_reason_exit(vcpu, exit_reason.full);
        return 0;
 }
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b4b5d2d09634..c826cd05228a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9110,6 +9110,18 @@ void kvm_prepare_event_vectoring_exit(struct kvm_vcpu *vcpu, gpa_t gpa)
 }
 EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_prepare_event_vectoring_exit);
 
+void kvm_prepare_unexpected_reason_exit(struct kvm_vcpu *vcpu, u64 exit_reason)
+{
+       vcpu_unimpl(vcpu, "unexpected exit reason 0x%llx\n", exit_reason);
+
+       vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+       vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
+       vcpu->run->internal.ndata = 2;
+       vcpu->run->internal.data[0] = exit_reason;
+       vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_prepare_unexpected_reason_exit);
+
 static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
 {
        struct kvm *kvm = vcpu->kvm;

