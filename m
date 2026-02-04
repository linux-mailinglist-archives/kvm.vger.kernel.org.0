Return-Path: <kvm+bounces-70254-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sIX6JOSGg2niowMAu9opvQ
	(envelope-from <kvm+bounces-70254-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 18:50:28 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0891CEB30A
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 18:50:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8F7773055DEC
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 17:45:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 384EE354ACE;
	Wed,  4 Feb 2026 17:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YWhDipuD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B97B34C816
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 17:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770227154; cv=none; b=jtEcHjYAWeSV6n4D13MDRelRWrM2Ilh3l8mfjXjKivtXBfSYbkp2nPMTPFDqm8vAJ33R0plOtvFnwf6UbAGxf//sAu3SoZGecxBDqvj6Kbi8KMooQxtWwEzixfJQAIf3nZpreCKPPQIQFIQUr39JvYhJ98uRoEsOQx6bFd+Kb84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770227154; c=relaxed/simple;
	bh=+MeIggCrk8fGJ1RKNFxYM0W2o3DhsfVlAilyT0wOZvo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kccco+zdqYequi7Gn5oslIKGePH9HanAd977fb1iBdWKEUsOr0/IGXn1LnxllY0R0gQLQrQlhufBemiseIc75TK7cP2F5h0JHoQxQ4FRv0EQWiYipyLWtc821+VWMCuudqQGLr/7o0RUKF5zPJk0MQv+mGQSkauPGgeEqd97EM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YWhDipuD; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c6133262e4eso4422918a12.2
        for <kvm@vger.kernel.org>; Wed, 04 Feb 2026 09:45:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770227154; x=1770831954; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ll4oe5MGd4XD/xh0ZQGRuc03SIwBCYQWH3Rrx+DBxec=;
        b=YWhDipuDZee/Kg2V2OuRbfmQ4x729k/Zg5Kxev3uUFcVnikNiU6ni71/oVCUifOGpz
         mtZ+Pdc0FdfRU2lhZpjZ7QeJaoFNXBi7Uf+3tvRAB8CZm0nybt4Y8cXJxcjQb/OYwqmm
         wZbFP1FQ7+hMWIgcBf60iUe3/PpKgUfWEE16WlcSeo0cOwjiIGQwFhQdfKdHZN8ZiWbq
         xHXkiLRF+MwZAPnXBPqyxMgqa+zGPI+TITkoopq58Y21IevGQ9AfG42g7v9DwuCJl9rB
         rJs8DMQclIiz7ReSeUIoKoeQFXd7f1hg3rT2w8P3e19/ourkwCV/2KVhPE9L5mHbmibS
         zzyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770227154; x=1770831954;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ll4oe5MGd4XD/xh0ZQGRuc03SIwBCYQWH3Rrx+DBxec=;
        b=ca8vmnVYGwCayGXt9Yp5p7GlGBWAExuHd921VZev/QFaHzVz+O9z+fS0F4g8zyaJ3/
         KWuHntf82/QgE07vT/HG4cOs44KVQTvym4CQng9KYYzzQromVGUkI3s1fugBYIuc5LNl
         RGb81VfX6AlxwK+KN8/9AUjjfjIN5ECnU81V7I2xvY2FWo6CArNVGfQmPfTViOAzb4Si
         bcKfAlol8eGKQmhRuFwEtTHvNRP9TYvwdiNdFSv7xBnwcvlE7Fhike3XB/Zlw00li+VM
         i5gjtG0oq1lqrauzzK9ko0TA6/AqVif63LzQm5bYQsUatg5OrCl/ay3vew1eq9iTSGS0
         7iFg==
X-Forwarded-Encrypted: i=1; AJvYcCVPyyJUHornZaPHusD87zKrDYa5Iw0uotgJofVh3cePdLj8V4TtgkmN501UZJhIjv5e4II=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+rGZC01/Qqyp3gBv4barTGt+lXT/fz3v+yVAOxUHsrOBrpDnE
	CxIohH6uPvJqzr6UIj+xxU9wVpWw/KhL6DkUU4zoSjSSTuW/gIejVT84F8A89Xh/99wgMVZKN13
	CYWqa3w==
X-Received: from pggr17.prod.google.com ([2002:a63:d911:0:b0:b6b:90a5:d43])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:9185:b0:38e:9405:bf03
 with SMTP id adf61e73a8af0-3937210bd90mr3954148637.35.1770227153567; Wed, 04
 Feb 2026 09:45:53 -0800 (PST)
Date: Wed, 4 Feb 2026 09:45:52 -0800
In-Reply-To: <20260112182022.771276-3-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260112182022.771276-1-yosry.ahmed@linux.dev> <20260112182022.771276-3-yosry.ahmed@linux.dev>
Message-ID: <aYOF0LNp173xAEsy@google.com>
Subject: Re: [PATCH 2/3] KVM: nSVM: Rename recalc_intercepts() to clarify
 vmcb02 as the target
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Kevin Cheng <chengkev@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
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
	TAGGED_FROM(0.00)[bounces-70254-lists,kvm=lfdr.de];
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
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 0891CEB30A
X-Rspamd-Action: no action

On Mon, Jan 12, 2026, Yosry Ahmed wrote:
> recalc_intercepts() updates the intercept bits in vmcb02 based on vmcb01
> and (cached) vmcb12.

Ah, but it does more than that.  More below.

> However, the name is too generic to make this
> clear, and is especially confusing while searching through the code as
> it shares the same name as the recalc_intercepts callback in
> kvm_x86_ops.
> 
> Rename it to nested_vmcb02_recalc_intercepts() (similar to other
> nested_vmcb02_* scoped functions), to make it clear what it is doing.
> 
> No functional change intended.
> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  arch/x86/kvm/svm/nested.c |  4 ++--
>  arch/x86/kvm/svm/sev.c    |  2 +-
>  arch/x86/kvm/svm/svm.c    |  4 ++--
>  arch/x86/kvm/svm/svm.h    | 10 +++++-----
>  4 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 2dda52221fd8..bacb2ac4c59e 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -123,7 +123,7 @@ static bool nested_vmcb_needs_vls_intercept(struct vcpu_svm *svm)
>  	return false;
>  }
>  
> -void recalc_intercepts(struct vcpu_svm *svm)
> +void nested_vmcb02_recalc_intercepts(struct vcpu_svm *svm)
>  {
>  	struct vmcb *vmcb01, *vmcb02;
>  	unsigned int i;

Drat, I should have responded to the previous patch.  Lurking out of sight is a
pre-existing bug that effectively invalidates this entire rename.

The existing code is:

  void recalc_intercepts(struct vcpu_svm *svm)
  {
	struct vmcb *vmcb01, *vmcb02;
	unsigned int i;

	vmcb_mark_dirty(svm->vmcb, VMCB_INTERCEPTS);  <======= not vmcb01!!!!!

	if (!is_guest_mode(&svm->vcpu))
		return;

When L2 is active, svm->vmcb is vmcb02.  Which, at first glance, _looks_ right,
but (the *horribly* named) recalc_intercepts() isn't _just_ recalculating
intercepts for L2, it's also responsible for marking the VMCB_INTERCEPTS dirty
(obviously).

But what isn't so obvious is that _all_ callers operate on vmcb01, because the
pattern is to modify vmcb01 intercepts, and then merge the new vmcb01 intercepts
with vmcb12, i.e. the "recalc intercepts" aspect is "part 2" of the overall
function.

Lost in all of this is that KVM forgets to mark vmcb01 dirty, and unless there's
a call buried somewhere deep, nested_svm_vmexit() isn't guaranteed to mark
VMCB_INTERCEPTS dirty, e.g. if PAUSE interception is disabled.

It's probably a benign bug in practice, as AMD CPUs don't appear to do anything
with the clean fields, but easy to fix.

As a bonus, fixing that bug yields for even better naming and code.  After the
dust settles, we can end up with this in svm.h:

  void nested_vmcb02_recalc_intercepts(struct vcpu_svm *svm);

  static inline void svm_mark_intercepts_dirty(struct vcpu_svm *svm)
  {
	vmcb_mark_dirty(svm->vmcb01.ptr, VMCB_INTERCEPTS);

	/*
	 * If L2 is active, recalculate the intercepts for vmcb02 to account
	 * for the changes made to vmcb01.  All intercept configuration is done
	 * for vmcb01 and then propagated to vmcb02 to combine KVM's intercepts
	 * with L1's intercepts (from the vmcb12 snapshot).
	 */
	if (is_guest_mode(&svm->vcpu))
		nested_vmcb02_recalc_intercepts(svm);
  }

and this for nested_vmcb02_recalc_intercepts():

  void nested_vmcb02_recalc_intercepts(struct vcpu_svm *svm)
  {
	struct vmcb_ctrl_area_cached *vmcb12_ctrl = &svm->nested.ctl;
	struct vmcb *vmcb02 = svm->nested.vmcb02.ptr;
	struct vmcb *vmcb01 = svm->vmcb01.ptr;
	unsigned int i;

	if (WARN_ON_ONCE(svm->vmcb != vmcb02))
		return;

	...
  }

with the only other caller of nested_vmcb02_recalc_intercepts() being
nested_vmcb02_prepare_control().

