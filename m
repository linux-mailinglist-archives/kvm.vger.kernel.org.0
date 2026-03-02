Return-Path: <kvm+bounces-72441-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aEeLAUgdpmmeKQAAu9opvQ
	(envelope-from <kvm+bounces-72441-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 00:29:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DBD51E6A61
	for <lists+kvm@lfdr.de>; Tue, 03 Mar 2026 00:29:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 40E89315D18B
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2026 23:22:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4A7F3382C3;
	Mon,  2 Mar 2026 23:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VLlh3XJ/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7805331A7B
	for <kvm@vger.kernel.org>; Mon,  2 Mar 2026 23:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772493772; cv=none; b=pesAgHI8Ty3nzTeKqAIthbLHKTfiRfekqu5JV9XUbOe6j84T5NnL7D7P/BtVVdM8ceHs0BKxpIRl1obfHEnQ8RjKXmkoGl8RAWHIm71cR3AgcvDczj8aFXnQmOkLNTumkfUn29dA53q3v7LJ3tZcLkPuyeKslRhdp1MpSHzCkWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772493772; c=relaxed/simple;
	bh=XQxSl3O1Eyae0Df2yUx6VgVUmrQa7UPWnlc9wzLzFNM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GR8lxwaunUr+7J7ZFw6rXviLSWGp5VW0l81a+LLoW9c2EkaocYRE3ewWuDSywsnAkq5WEKvHhfqIDRcpzB0MlsjQA1BCfEYqdh/3BCzpHiflefMVlwqkTgpApGexPdRNnKWRWxEsLT94/wOxAC/FLbYR/qqeYhhZUTmk5F0l23U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VLlh3XJ/; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3597baf976dso8773664a91.3
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2026 15:22:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772493769; x=1773098569; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=b7QinaCQVNXT8p32KVuTREOQfi+HlQYnbR0yXpcOwU4=;
        b=VLlh3XJ/nC+tNyEAXE+dj3KfM+8ZTa073sO54f/nR1eDN46Z72B6pz6G0FQ91Tb5Vk
         3OGGpahuPqOmPaNqACuLLLWIFFrKZSvO0AEx3Ngn0KcQs6wfwYt8gSU++bYml1v4danr
         UalZ34sr835WwooQbrOk2UDtKgcBSrKfCfqVpCX/9ILus6648B/BOyES5klVMCwFKNY+
         XuvZ4IcG+HUKN7LHjOYFyhPwgifW428An3eGHYDq/77j5a6aaDbRCVNmyr4H0fYS/syB
         0vbIFD4vLBdMwjQMtP31tF/GQXwiNFnODI2kjMtwIpFNrj+AVqpfeZtEpggtBmFYOFv5
         4TNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772493769; x=1773098569;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b7QinaCQVNXT8p32KVuTREOQfi+HlQYnbR0yXpcOwU4=;
        b=XILqpIRs1vkGvvIKahk/Xc8tp0pJUifmhV2I+6yF8IQ2LeAitUGG8YJePWsl9IQdem
         YYr8XiCNZy0d37xt/f6VDaehEmPvrFjMSn5SgYuJyjXgz6JkHYc2qnHIIJXtngT8LAwA
         LdFGX8lf45iUEsh2e+YJXG0L2S+XiflkD54nqAbhJwaFPLcnfHjy/FaC/9SCYs3yWshJ
         Z4JtX1bbM2d3AkTTzNbofw4GQRN9IHQQEEF2QHrmXSO2fKC6QSUHW3p9fL/KbJ5BOpc3
         JatZ1kgZdXAbPasEYdZpWnru8eBwliG0/BbriDWvJNZRbcAUhjkk5TMK5vQZS1zYZgpX
         zZMw==
X-Forwarded-Encrypted: i=1; AJvYcCW3pYlB3aSZ1Akfq/9cGHD+cf6Z4xqolVluuo6e4iOqjcSxTkBt7fFM+OuUNAekQmGApbg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxY3FphZCrIFwsSZb8xljuvgMwZLHt/0HuiyRdxowyBJJ6BLEGS
	xnon7qOrUe3PDkZJGx4gS2BeW2uJePcVoTA/VUlBrlA0VPLPKzAOFt4Ja8BqVVBlPrq66TrLtlY
	WFrFpnQ==
X-Received: from pjqc15.prod.google.com ([2002:a17:90a:a60f:b0:358:f40b:c72b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:524a:b0:359:df9:c9f9
 with SMTP id 98e67ed59e1d1-35965c3af23mr11813683a91.7.1772493768578; Mon, 02
 Mar 2026 15:22:48 -0800 (PST)
Date: Mon, 2 Mar 2026 15:22:47 -0800
In-Reply-To: <CAO9r8zOFWHZ5LHRRKL4KU8TctjNs+vQYDr9OoBmao=eG9Q8C2w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260227011306.3111731-1-yosry@kernel.org> <20260227011306.3111731-4-yosry@kernel.org>
 <aaG_o58_0aHT8Xjg@google.com> <aaHHg2-lcpvkejB8@google.com>
 <CAO9r8zMdyvAJUvnxH0Scb6z3L51Djb1qpMAzX3M9g7hOkB=ZOQ@mail.gmail.com>
 <aaHf9Lxx8ap_3DRI@google.com> <CAO9r8zOFWHZ5LHRRKL4KU8TctjNs+vQYDr9OoBmao=eG9Q8C2w@mail.gmail.com>
Message-ID: <aaYbx59lQf5beYSv@google.com>
Subject: Re: [PATCH 3/3] KVM: x86: Check for injected exceptions before
 queuing a debug exception
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Queue-Id: 4DBD51E6A61
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72441-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Fri, Feb 27, 2026, Yosry Ahmed wrote:
> > > That being said, I hate nested_run_in_progress. It's too close to
> > > nested_run_pending and I am pretty sure they will be mixed up.
> >
> > Agreed, though the fact that name is _too_ close means that, aside from the
> > potential for disaster (minor detail), it's accurate.
> >
> > One thought is to hide nested_run_in_progress beyond a KConfig, so that attempts
> > to use it for anything but the sanity check(s) would fail the build.  I don't
> > really want to create yet another KVM_PROVE_xxx though, but unlike KVM_PROVE_MMU,
> > I think we want to this enabled in production.
> >
> > I'll chew on this a bit...
> 
> Maybe (if we go this direction) name it very explicitly
> warn_on_nested_exception if it's only intended to be used for the
> sanity checks?

It's not just about exceptions though.  That's the case that has caused a rash
of recent problems, but the rule isn't specific to exceptions, it's very broadly
Thou Shalt Not Cancel VMRUN.

I think that's where there's some disconnect.  We can't make the nested_run_pending
warnings go away by adding more sanity checks, and I am dead set against removing
those warnings.

Aha!  Idea.  What if we turn nested_run_pending into a u8, and use a magic value
of '2' to indicate that userspace gained control of the CPU since nested_run_pending
was set, and then only WARN on nested_run_pending==1?  That way we don't have to
come up with a new name, and there's zero chance of nested_run_pending and something
like nested_run_in_progress getting out of sync.

---
 arch/x86/include/asm/kvm_host.h |  6 +++++-
 arch/x86/kvm/svm/nested.c       |  3 ++-
 arch/x86/kvm/vmx/nested.c       |  4 ++--
 arch/x86/kvm/x86.c              |  7 +++++++
 arch/x86/kvm/x86.h              | 10 ++++++++++
 5 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 19b3790e5e99..a8d39b3aff6a 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1104,8 +1104,12 @@ struct kvm_vcpu_arch {
 	 * can only occur at instruction boundaries.  The only exception is
 	 * VMX's "notify" exits, which exist in large part to break the CPU out
 	 * of infinite ucode loops, but can corrupt vCPU state in the process!
+	 *
+	 * For all intents and purposes, this is a boolean, but it's tracked as
+	 * a u8 so that KVM can detect when userspace may have stuffed vCPU
+	 * state and generated an architecturally-impossible VM-Exit.
 	 */
-	bool nested_run_pending;
+	u8 nested_run_pending;
 
 #if IS_ENABLED(CONFIG_HYPERV)
 	hpa_t hv_root_tdp;
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index c2d4c9c63146..77ff9ead957c 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1138,7 +1138,8 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	/* Exit Guest-Mode */
 	leave_guest_mode(vcpu);
 	svm->nested.vmcb12_gpa = 0;
-	WARN_ON_ONCE(vcpu->arch.nested_run_pending);
+
+	kvm_warn_on_nested_run_pending(vcpu);
 
 	kvm_clear_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
 
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 031075467a6d..5659545360dc 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5042,7 +5042,7 @@ void __nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 	vmx->nested.mtf_pending = false;
 
 	/* trying to cancel vmlaunch/vmresume is a bug */
-	WARN_ON_ONCE(vcpu->arch.nested_run_pending);
+	kvm_warn_on_nested_run_pending(vcpu);
 
 #ifdef CONFIG_KVM_HYPERV
 	if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
@@ -6665,7 +6665,7 @@ bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu)
 	unsigned long exit_qual;
 	u32 exit_intr_info;
 
-	WARN_ON_ONCE(vcpu->arch.nested_run_pending);
+	kvm_warn_on_nested_run_pending(vcpu);
 
 	/*
 	 * Late nested VM-Fail shares the same flow as nested VM-Exit since KVM
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index db3f393192d9..30ff5a755572 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -12023,6 +12023,13 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	if (r <= 0)
 		goto out;
 
+	/*
+	 * If userspace may have modified vCPU state, mark nested_run_pending
+	 * as "untrusted" to avoid triggering false-positive WARNs.
+	 */
+	if (vcpu->arch.nested_run_pending == 1)
+		vcpu->arch.nested_run_pending = 2;
+
 	r = vcpu_run(vcpu);
 
 out:
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 94d4f07aaaa0..d3003c8be961 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -188,6 +188,16 @@ static inline bool kvm_can_set_cpuid_and_feature_msrs(struct kvm_vcpu *vcpu)
 	return vcpu->arch.last_vmentry_cpu == -1 && !is_guest_mode(vcpu);
 }
 
+/*
+ * WARN if a nested VM-Enter is pending completion, and userspace hasn't gained
+ * control since the nested VM-Enter was initiated (in which case, userspace
+ * may have modified vCPU state to induce an architecturally invalid VM-Exit).
+ */
+static inline void kvm_warn_on_nested_run_pending(struct kvm_vcpu *vcpu)
+{
+	WARN_ON_ONCE(vcpu->arch.nested_run_pending == 1);
+}
+
 static inline void kvm_set_mp_state(struct kvm_vcpu *vcpu, int mp_state)
 {
 	vcpu->arch.mp_state = mp_state;

base-commit: a68a4bbc5b9ce5b722473399f05cb05217abaee8
--

