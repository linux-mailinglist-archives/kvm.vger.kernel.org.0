Return-Path: <kvm+bounces-72252-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SF4LF8Uxomke0wQAu9opvQ
	(envelope-from <kvm+bounces-72252-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 01:07:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CC01B1BF583
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 01:07:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D05743041D6E
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 00:07:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39FA814D719;
	Sat, 28 Feb 2026 00:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4ecAiPt/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F302C38DF9
	for <kvm@vger.kernel.org>; Sat, 28 Feb 2026 00:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772237241; cv=none; b=Sxs0VwXj3roZWfkLPXgOLcUW7yxXqkSfHmn1X4gh0TquSBbBfQGLtw70ILT3EYvGzvE6rM9cj7TBoGKVDAkLwZ9FBT9uBS5H3oCFLz2UnhV4XAcG4zMDIaujQkwiYSQUYX+MlSM8GaBlCwufoqPFUEfFgHy5JxGucVqhRQTPjzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772237241; c=relaxed/simple;
	bh=jL9GteoOWWgXkwI4VcYLSAaGM4KHutruotNHJppWhmE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TuVCheFBxZ2Z9KFrVjNcxCuFHA94rRS/75qGKr8Cn+MOlLaS5z3LeNyjRNyerWWdW37QA9/x6GMOw6jyD25XxHVMOHktO0YdEbadX2o0OOHBEVFCmVuK27G7Tc1SGfhUOfek1fp52MnfQDEkUhEds3aTqis898uvX8oJK9gHaa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4ecAiPt/; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c70f8010fc0so9408470a12.2
        for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 16:07:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772237238; x=1772842038; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1Rk2j9mMZvm5I21CFq9daaZ0tGleTEgRj/BEZaesZVs=;
        b=4ecAiPt/C0TLbkaAvCN9gfspyvRtPQHCWk/mcjc7jey1QvCNtyiNxnDO0aIJnXx0hL
         Hmx1uESpvICwPpRV+dbNsw/Dbny9rs2IynKSE+zWoCwPodgNJebNosp1AT4kgcJUCVPz
         mHqK8XM/auaWxKCkE3AoFiuKScYLlm6q/rzUSl+b/wyDKL+0kFK2g4myfdIVtNhoIMtM
         1nNSXFlBXpXHBdu8bTVV2pw++gy8Tqt8K+G7hd+II6YXYJiLGuA0AIM/42KxAQqdVLTh
         2P0MbRT0twMOaPJTZ0+wEoHSaDCaqtCKqeqfoxnmtPp+ARxlMknI76TynBOMwtzdr8er
         secg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772237238; x=1772842038;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1Rk2j9mMZvm5I21CFq9daaZ0tGleTEgRj/BEZaesZVs=;
        b=PwJHz4TTJsc8x7Rmc1fG+M4E54WTo5rv6ei0EZcpZv+Okc7u/81qhyusYifEg2YmDg
         q5395l7tROaJOs7U3WMXLhPnmJAOUr5hRxGDWnaSuktEjQT08QWR2uqTCOhDTZLGkHIM
         OOGnaDkt0S0ZDucUef7Bg7dK1QSKmMs93oNuK1r+AheZZe8/CmuYsi7x52hysOY1F9Fn
         lLf8hfk4myrsBHjntqMEDv1sSElBoZ/RBXxL/pQGMVSWri+Cc5nxbeJlpH9mpWFIu9hK
         VxIYxCEf/+6OZ9HyHjFghi0JH+34Cq07j+uuDn031kNFAUZO33tzQCYFBX7gef7cYGKa
         CT/g==
X-Forwarded-Encrypted: i=1; AJvYcCVYc1bUNnNBTZmrSrQY0wn9+9cBTlQAvJ/W6d7yosvHvcruzWficDgk7edm645QaKni7tY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyqycxRG+mOjFtSux4p65d06Dc8kzJPYIkev7SlIsgR7V0DTlp5
	on+emyoTFTRqc7NNC534KdN2EOXwDeLi/9MEzEo8A8n56yA3m4pHKCEkHVClpX04pDZ4NNaQPR3
	cfs177Q==
X-Received: from pgmm15.prod.google.com ([2002:a05:6a02:550f:b0:c66:c17e:9c4f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:9cca:b0:394:f482:badf
 with SMTP id adf61e73a8af0-395c3a1bbf3mr4226790637.11.1772237238200; Fri, 27
 Feb 2026 16:07:18 -0800 (PST)
Date: Fri, 27 Feb 2026 16:07:16 -0800
In-Reply-To: <20260224223405.3270433-17-yosry@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260224223405.3270433-1-yosry@kernel.org> <20260224223405.3270433-17-yosry@kernel.org>
Message-ID: <aaIxtBYRNCHdEvsV@google.com>
Subject: Re: [PATCH v6 16/31] KVM: nSVM: Unify handling of VMRUN failures with
 proper cleanup
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72252-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: CC01B1BF583
X-Rspamd-Action: no action

On Tue, Feb 24, 2026, Yosry Ahmed wrote:
> There are currently two possible causes of VMRUN failures emulated by
> KVM:
> 
> 1) Consistency checks failures. In this case, KVM updates the exit code
>    in the mapped VMCB12 and exits early in nested_svm_vmrun(). This
>    causes a few problems:
> 
>   A) KVM does not clear the GIF if the early consistency checks fail
>      (because nested_svm_vmexit() is not called). Nothing requires
>      GIF=0 before a VMRUN, from the APM:
> 
> 	It is assumed that VMM software cleared GIF some time before
> 	executing the VMRUN instruction, to ensure an atomic state
> 	switch.
> 
>      So an early #VMEXIT from early consistency checks could leave the
>      GIF set.
> 
>   B) svm_leave_smm() is missing consistency checks on the newly loaded
>      guest state, because the checks aren't performed by
>      enter_svm_guest_mode().

This is flat out wrong.  RSM isn't missing any consistency checks that are
provided by nested_vmcb_check_save().

	if (CC(!(save->efer & EFER_SVME)))                                    <=== irrelevant given KVM's implementation
		return false;

	if (CC((save->cr0 & X86_CR0_CD) == 0 && (save->cr0 & X86_CR0_NW)) ||  <== kvm_set_cr0() in rsm_enter_protected_mode()
	    CC(save->cr0 & ~0xffffffffULL))
		return false;

	if (CC(!kvm_dr6_valid(save->dr6)) || CC(!kvm_dr7_valid(save->dr7)))   <== kvm_set_dr() in rsm_load_state_{32,64}
		return false;

	/*
	 * These checks are also performed by KVM_SET_SREGS,
	 * except that EFER.LMA is not checked by SVM against
	 * CR0.PG && EFER.LME.
	 */
	if ((save->efer & EFER_LME) && (save->cr0 & X86_CR0_PG)) { 
		if (CC(!(save->cr4 & X86_CR4_PAE)) ||                         <== kvm_set_cr4() in rsm_enter_protected_mode()
		    CC(!(save->cr0 & X86_CR0_PE)) ||                          <== kvm_set_cr0() in rsm_enter_protected_mode()
		    CC(!kvm_vcpu_is_legal_cr3(vcpu, save->cr3)))              <== kvm_set_cr3() in rsm_enter_protected_mode()
			return false;
	}

	/* Note, SVM doesn't have any additional restrictions on CR4. */
	if (CC(!__kvm_is_valid_cr4(vcpu, save->cr4)))                         <== kvm_set_cr4() in rsm_enter_protected_mode()
		return false;

	if (CC(!kvm_valid_efer(vcpu, save->efer)))                            <== __kvm_emulate_msr_write() in rsm_load_state_64()
		return false;

Even if RSM were missing checks on the L2 state being loaded, I'm not willing to
take on _any_ complexity in nested VMRUN to make RSM suck a little less.  KVM's
L2 => SMM => RSM => L2 is fundamentally broken.  Anyone that argues otherwise is
ignoring architecturally defined behavior in the SDM and APM.

If someone wants to actually put in the effort to properly emulating SMI => RSM
from L2, then I'd be happy to take on some complexity, but even then it's not at
all clear that it would be necessary.

> 2) Failure to load L2's CR3 or merge the MSR bitmaps. In this case, a
>    fully-fledged #VMEXIT injection is performed as VMCB02 is already
>    prepared.
> 
> Arguably all VMRUN failures should be handled before the VMCB02 is
> prepared, but with proper cleanup (e.g. clear the GIF).

Eh, so long as KVM cleans up after itself, I don't see anything wrong with
preparing some of vmcb02.

So after staring at this for some time, us having gone through multiple attempts
to get things right, and this being tagged for stable@, unless I'm missing some
massive simplification this provides down the road, I am strongly against refactoring
this code, and 100% against reworking things to "fix" SMM.

And so for the stable@ patches, I'm also opposed to all of these:

  KVM: nSVM: Refactor minimal #VMEXIT handling out of nested_svm_vmexit()
  KVM: nSVM: Call nested_svm_init_mmu_context() before switching to VMCB02
  KVM: nSVM: Call nested_svm_merge_msrpm() from enter_svm_guest_mode()
  KVM: nSVM: Make nested_svm_merge_msrpm() return an errno
  KVM: nSVM: Call enter_guest_mode() before switching to VMCB02
  KVM: nSVM: Drop nested_vmcb_check_{save/control}() wrappers

unless they're *needed* by some later commit (I didn't look super closely).

For stable@, just fix the GIF case and move on.

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index d734cd5eef5e..d9790e37d4e8 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1036,6 +1036,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
                vmcb12->control.exit_code    = SVM_EXIT_ERR;
                vmcb12->control.exit_info_1  = 0;
                vmcb12->control.exit_info_2  = 0;
+               svm_set_gif(svm, false);
                goto out;
        }

Sorry for not catching this earlier, I didn't actually read the changelog until
this version.  /facepalm

