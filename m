Return-Path: <kvm+bounces-71269-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0KyGLqwklmn0bAIAu9opvQ
	(envelope-from <kvm+bounces-71269-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 21:44:28 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 21268159810
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 21:44:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3532D3036610
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 20:44:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B189334889C;
	Wed, 18 Feb 2026 20:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YltjmhhD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB78E2DC77F
	for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 20:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771447448; cv=none; b=cD+LcqT7Cts5UDgtWrrcLWsVET2Esp6X3nbwZZ5774lPoGyKM2IaKJCuQSeX3CXmcvqFbk65hR2w/+7RHylbyDO2CoKstl8OsrZwIo+Rw27ADZ7hxxyaQL8K8rL1D8QMRnIsBKN7EchLR/ipNq6oqsi+wo2lspZCII1zg/7ucsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771447448; c=relaxed/simple;
	bh=OfPlPP2zSZfILIK52UYFTfJpu+yw235cbdO1LC+N4lU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=g9UsRYbweNteEaSjD1/zInn5m6riM9ykhoThrOmaXYSsKccuieoznuab+LnY0mFo2XCn+C0/kKzDgvluwsuZVL5FdtzaWR7oZrqurdIYblnWLkNV/cnaVsVTdyQ469bLct8eoDUCZPwQBN0ABl3VyNH4JwBWmMMj+akxi3pcftM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YltjmhhD; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-354c65f69edso219251a91.0
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 12:44:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771447446; x=1772052246; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=e92WtgjrZM3jvS8ZXOfcSH8+2aFwCmET7jJHlALYuqA=;
        b=YltjmhhDiCF4FWZa+NnR7ANfJxZQp0rzje4TonTNKalcKucCOIuSlQ0W/4XE73KhUi
         Wi/qeXb8s5ixAbQwIW8FwA3NuMJHdrocE1/Z7hi/H1rQFjmt8laEtnzQVyFmU05c06TW
         o4kbtIqsY0QKulRscV1XyMc/MVL4fpxTtHkQlalb12K7ZJHpxNppQkMJTlRmMWeEhE7r
         rC/rlIMfFUo105GFRpFvPtv+whOVgp8aLO+7zGUy+XBLyKD+vffi1uHyAAMYd4N/ykSB
         35m5lYy1NY8Q2EWLj+xANg1uaPCBotNV/l+H0dPwMMqyUuh71wYlnYZZcMkXaZGSYRhu
         4VVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771447446; x=1772052246;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=e92WtgjrZM3jvS8ZXOfcSH8+2aFwCmET7jJHlALYuqA=;
        b=gWNCeoEm8tHRmOdka96FC1lPFp7o64PNCdskkls3TClOp5i1o/UM51FJx0OhqsbwZc
         1j8kLnqfi47QrALvFmOHOyp9n4FWd9FnlwncuYCRkG6sepTj20k8yP0n2kny2DOCQ7+s
         zKabw6hQehjZyfAlggrZOri+c1unOr3Z5yWdb5NMcU6JfVgu9of8tFDKzVTsdxXPSsox
         qQw7lRc3kX5vDN7cvbG8RRkGORuHI69Q5bKlyqm9P4cW+V+58cEl8kel1EPmgp330Q5e
         v5goX4ef64jLvzjVKHnmnOERsQZtbqqSbbFl+VhEwlhKRkFI9iiwvknrisefPTJXcyAD
         Qk6Q==
X-Gm-Message-State: AOJu0Yz7kuHV/CHQshxibPkce+BtuVMtKbgsl+Wp4wFLPrJnbdCuuMII
	d1OBng53Cy84ncO/PnlJugNUX6yi/Bb7Ergj4r+KpRChMMGGyk/y9roZ57ESXwpqq3DgfECfNSg
	ilUUgHQ==
X-Received: from pjbsk10.prod.google.com ([2002:a17:90b:2dca:b0:354:c082:9b8d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3dcc:b0:354:b2f6:b4e4
 with SMTP id 98e67ed59e1d1-35888ebf8fcmr2084877a91.0.1771447445927; Wed, 18
 Feb 2026 12:44:05 -0800 (PST)
Date: Wed, 18 Feb 2026 12:44:04 -0800
In-Reply-To: <20260113003153.3344500-11-chengkev@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260113003153.3344500-1-chengkev@google.com> <20260113003153.3344500-11-chengkev@google.com>
Message-ID: <aZYklHat_pun9ure@google.com>
Subject: Re: [kvm-unit-tests PATCH V2 10/10] x86/svm: Add test for #UD when EFER.SVME=0
From: Sean Christopherson <seanjc@google.com>
To: Kevin Cheng <chengkev@google.com>
Cc: kvm@vger.kernel.org, yosryahmed@google.com, andrew.jones@linux.dev, 
	thuth@redhat.com, pbonzini@redhat.com
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71269-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[6];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 21268159810
X-Rspamd-Action: no action

On Tue, Jan 13, 2026, Kevin Cheng wrote:
> +static void svm_ud_test_handler(struct ex_regs *regs)
> +{
> +	ud_fired = true;
> +	regs->rip += 3;
> +}
> +
> +static void svm_ud_test(void)
> +{
> +	u64 efer = rdmsr(MSR_EFER);
> +
> +	handle_exception(UD_VECTOR, svm_ud_test_handler);
> +	wrmsr(MSR_EFER, efer & ~EFER_SVME);
> +
> +	insn_invlpga();

Eh, just add proper helpers, or open code the asm.  And definitely use asm_safe()
instead of wiring up a dedicated #UD handler.  Ha!  And past me even proactively
waged war on copy+paste exception handling.

Untested, but something like this should work.

	asm_safe_report_ex("invlpga %rax, %ecx", "a"(0), "c"(0));
	asm_safe_report_ex("vmrun %rax", "a"(0));
	asm_safe_report_ex("vmsave %rax", "a"(0));
	asm_safe_report_ex("vmload %rax", "a"(0));

> diff --git a/x86/unittests.cfg b/x86/unittests.cfg
> index 118e7cdd0286d..ad447e5f82f9f 100644
> --- a/x86/unittests.cfg
> +++ b/x86/unittests.cfg
> @@ -253,11 +253,19 @@ arch = x86_64
>  [svm]
>  file = svm.flat
>  smp = 2
> -test_args = "-pause_filter_test -svm_intr_intercept_mix_smi -svm_insn_intercept_test -svm_pf_exception_test -svm_pf_exception_forced_emulation_test -svm_pf_inv_asid_test -svm_pf_inv_tlb_ctl_test -svm_event_injection"
> +test_args = "-pause_filter_test -svm_intr_intercept_mix_smi -svm_insn_intercept_test -svm_pf_exception_test -svm_pf_exception_forced_emulation_test -svm_pf_inv_asid_test -svm_pf_inv_tlb_ctl_test -svm_event_injection -svm_ud_test"
>  qemu_params = -cpu max,+svm -m 4g
>  arch = x86_64
>  groups = svm
>  
> +# Disable SKINIT and SVML to test STGI #UD when EFER.SVME=0
> +[svm_ud_test]
> +file = svm.flat
> +test_args = svm_ud_test
> +qemu_params = -cpu max,-skinit,-svm-lock,+svm -m 4g

KVM doesn't support SKINIT or SVM-LOCK, carving out a separate config just to
disable things that aren't supported is pointless.  If QEMU TCG gets false
failures due to its default model emulating the interactions with SKINIT and/or
SVM-LOCK, then I'd prefer to account for that in the test, not in the config. 

> +arch = x86_64
> +groups = svm
> +
>  [svm_event_injection]
>  file = svm.flat
>  test_args = svm_event_injection
> -- 
> 2.52.0.457.g6b5491de43-goog
> 

