Return-Path: <kvm+bounces-72263-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qPoLLsI/ommq1AQAu9opvQ
	(envelope-from <kvm+bounces-72263-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 02:07:14 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 20F6A1BF9F3
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 02:07:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CBF5A3091CAA
	for <lists+kvm@lfdr.de>; Sat, 28 Feb 2026 01:05:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 590C72D978B;
	Sat, 28 Feb 2026 01:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YyPxNJ2T"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7B4285C89
	for <kvm@vger.kernel.org>; Sat, 28 Feb 2026 01:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772240739; cv=none; b=rydn0ONn7K8yJ9FDGvFb8OTf1bK/ZIwgAq+EYRN/lzVHc6PcZ6D6r9Ao2b5VF9vXvUXMdXoOiD4XMrBp7Sh45BfdWUXY+VyJ8h9T/xVTmp65MZS1e59xzPfbvvJTKu/vqDVwNCF0Yn5jEcA+kKRR37qthu/x/MBcxsRMi+0LuL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772240739; c=relaxed/simple;
	bh=1zUnvMi3DhR4TRKA6QhomrBPmg9vrIoA4cSt9CrQaQI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=R38CQZFlqb+uS4Co48US7r8zvSS4TlY5qN/HauvcyJCGzjdXoZ6EhHqC52/qA8EJH3Cmoi1pgaHZFwgWUJXqQp47wPDS7/xzi4mDyuoz0natOZ/7LfeubLtfu0j7XXiCvLb1NAYJOdRAPCpNtn9QwxM3d2yKgYJs/riz7oiBB7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YyPxNJ2T; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c6e1d32a128so1538735a12.3
        for <kvm@vger.kernel.org>; Fri, 27 Feb 2026 17:05:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772240736; x=1772845536; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D7Xd6qG6AlycAVEj6etoW+v6AvuZE8R530E1vnavVsw=;
        b=YyPxNJ2TMH3jPTC5RkOuLBQJ4Mp2ZVYb03RHjjvm/VSP7qPu/ZD8NFCFKlG7J13HCp
         hUaHiPfftAxHbmWFYhIyJDcf3q2puidCfLuIVeAcquJ2izdjTD4BWyCYSBZB83iG5I9E
         4zGTEsytwPXPtB7mA1BJ4EZfyUQbht4LQPptc6ET/tsT6aFb2s52eq/WoocmQ+sybqIl
         Ve4e/YdTCj9fnwJ8jhZy5Ltdag1QapoU0XgcL8uOd0wj8EoNf/XMI5r5ganatL0lipxo
         +kVivj3MnBhbfmlLRICat1+ZnoPdXVUq+t3ry3KyWYLqaDAo31JkxgFSyLSILVZbQ8jr
         QsVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772240736; x=1772845536;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=D7Xd6qG6AlycAVEj6etoW+v6AvuZE8R530E1vnavVsw=;
        b=mN24dRzrQMTJGbx1TG/9r2uEOjzdfngLcHkPNJ8IIH5vvHPA5hqV0TasV6y7etPWa4
         mpa+xxAPjgGlYFcaAzlR6jGnWYC19zy53gxrB7z4eQL9Em1Bxwd1Og0yecF/7vSovETN
         hPU2+8PfeZ5yq1TK2fMPEx8wu4QWkVJ3MTlwLl8ah2qHupI/x+kgeZPoa/OfGp6yW/NI
         P+34bB8BmYFldQWvqCNL4zBcK6ZUQF6FBHYu6/Do+bJmzc7uc/4E5fJnbcgyzx5XGwbd
         Ekrrabs/I/W+H65eZ85JKQOyPdEC8sndrDEnKNED32skJGxFPUr+C/CloZaCrH5OKwah
         Yo8w==
X-Forwarded-Encrypted: i=1; AJvYcCWqJKyqfVQyPTDqA1nf7xQ/xnaGv4lgfb+akibkT6Y/wnNwUz54q2qhFoYIl2aHuohyZO8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwINB4fOPk+p8HAzirI9/RaD3zR87fNeUawybphi9rOuKGMzU/4
	y6Bp8P3fv48jjJUy47wF//R1LHLtZYKCJis9raLh9JOwFgh6OD372GelqnHqRkgSdD9lmcqe4Ni
	ughB0Dg==
X-Received: from pjha10.prod.google.com ([2002:a17:90a:480a:b0:356:5127:89c6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:d817:b0:392:e5eb:f0d
 with SMTP id adf61e73a8af0-395c3b193bcmr4323896637.66.1772240735482; Fri, 27
 Feb 2026 17:05:35 -0800 (PST)
Date: Fri, 27 Feb 2026 17:05:34 -0800
In-Reply-To: <CAO9r8zMRkFfxm_zs88uc_ijARrU4XxHQQZAQFmC_t0H9qdbM-A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260224223405.3270433-1-yosry@kernel.org> <20260224223405.3270433-17-yosry@kernel.org>
 <aaIxtBYRNCHdEvsV@google.com> <CAO9r8zMRkFfxm_zs88uc_ijARrU4XxHQQZAQFmC_t0H9qdbM-A@mail.gmail.com>
Message-ID: <aaI_XogE98GvJjAU@google.com>
Subject: Re: [PATCH v6 16/31] KVM: nSVM: Unify handling of VMRUN failures with
 proper cleanup
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
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
	TAGGED_FROM(0.00)[bounces-72263-lists,kvm=lfdr.de];
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
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5]
X-Rspamd-Queue-Id: 20F6A1BF9F3
X-Rspamd-Action: no action

On Fri, Feb 27, 2026, Yosry Ahmed wrote:
> On Fri, Feb 27, 2026 at 4:07=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > So after staring at this for some time, us having gone through multiple=
 attempts
> > to get things right, and this being tagged for stable@, unless I'm miss=
ing some
> > massive simplification this provides down the road, I am strongly again=
st refactoring
> > this code, and 100% against reworking things to "fix" SMM.
>=20
> For context, this patch (and others you quoted below) were a direct
> result of this discussion in v2:
> https://lore.kernel.org/kvm/aThIQzni6fC1qdgj@google.com/. I didn't
> look too closely into the SMM bug tbh I just copy/pasted that verbatim
> into the changelog.

Well fudge.  I'm sorry.  I obviously got a bit hasty with the whole svm_lea=
ve_smm()
thing.  *sigh*

> As for refactoring the code, I didn't really do it for SMM, but I
> think the code is generally cleaner with the single VMRUN failure
> path.

Except for the minor detail of being wrong :-)

And while I agree it's probably "cleaner", I think it's actually harder for
readers to understand, especially for readers that are familiar with nVMX. =
 E.g.
having a separate #VMEXIT path for consistency checks can actually be helpf=
ul,
because it highlights things that happen on #VMEXIT even when KVM hasn't st=
arted
loading L2 state.

> That being said..
>=20
> > And so for the stable@ patches, I'm also opposed to all of these:
> >
> >   KVM: nSVM: Refactor minimal #VMEXIT handling out of nested_svm_vmexit=
()
> >   KVM: nSVM: Call nested_svm_init_mmu_context() before switching to VMC=
B02
> >   KVM: nSVM: Call nested_svm_merge_msrpm() from enter_svm_guest_mode()
> >   KVM: nSVM: Make nested_svm_merge_msrpm() return an errno
> >   KVM: nSVM: Call enter_guest_mode() before switching to VMCB02
> >   KVM: nSVM: Drop nested_vmcb_check_{save/control}() wrappers
> >
> > unless they're *needed* by some later commit (I didn't look super close=
ly).
> >
> > For stable@, just fix the GIF case and move on.
>=20
> .. I am not sure if you mean dropping them completely, or dropping
> them from stable@.

My preference is to completely drop these:

  KVM: nSVM: Unify handling of VMRUN failures with proper cleanup
  KVM: nSVM: Refactor minimal #VMEXIT handling out of nested_svm_vmexit()
  KVM: nSVM: Call nested_svm_init_mmu_context() before switching to VMCB02
  KVM: nSVM: Call nested_svm_merge_msrpm() from enter_svm_guest_mode()
  KVM: nSVM: Call enter_guest_mode() before switching to VMCB02

> I am fine with dropping the stable@ tag from everything from this
> point onward, or re-ordering the patches to keep it for the missing
> consistency checks.

And then moving these to the end of the series (or at least, beyond the sta=
ble@
patches):

  KVM: nSVM: Make nested_svm_merge_msrpm() return an errno
  KVM: nSVM: Drop nested_vmcb_check_{save/control}() wrappers

> If you mean drop them completely, it's a bit of a shame because I
> think the code ends up looking much better, but I also understand
> given all the back-and-forth, and the new problem I reported recently
> that will need further refactoring to address (see my other reply to
> the same patch).

After paging more of this stuff back in (it's been a while since I looked a=
t the
equivalent nVMX flow in depth), I'm quite opposed to aiming for a unified #=
VMEXIT
path for VMRUN.  Although it might seem otherwise at times, nVMX and nSVM d=
idn't
end up with nested_vmx_load_cr3() buried toward the end of their flows pure=
ly to
make the code harder to read, there are real dependencies that need to be t=
aken
into account.

And there's also value in having similar flows for nVMX and nSVM, e.g. wher=
e most
consistency checks occur before KVM starts loading L2 state.  VMX just happ=
ens to
architecturally _require_ that, whereas with SVM it was a naturally consequ=
ence
of writing the code.

Without the unification, a minimal #VMEXIT helper doesn't make any sense, a=
nd
I don't see any strong justification for shuffling around the order.

