Return-Path: <kvm+bounces-67276-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id DDE75D00144
	for <lists+kvm@lfdr.de>; Wed, 07 Jan 2026 22:00:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 99A6C302EA1B
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 20:59:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33A01339705;
	Wed,  7 Jan 2026 20:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EuRXHug6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19B631B812
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 20:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767819575; cv=none; b=BhsbMBZljMP94Ybcm5GunJ4ltvI3lUylx5qUdHg+xBib6aHPaaSzs+ybzIfM19ysPtMJ7HOJhQDhqS9CXXp2ubWWI5MMZ0d3MpZfl1pM0Atz0qRqDr7pc1Z9I23eJBrhr2qrdTotPo5JvragL4Hws7JKfaiMzCGApk4LXX8Mel4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767819575; c=relaxed/simple;
	bh=MLkNJszNusBrTOHlQpBu7l0P2OlfeNYwSYZ0QSj8880=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=slW0Fjr7oVnlecs3XhevEZgjPkjVA6toygvgt5KvdT6FLHZypPF/lEBFLe9AHe8kXNcClFo15BGxd11Y7TwW96Q/pN7jGv4yvWX3oNiSdFX9kxfRxAVC4VqN3hNI5iy1AAd2obbuREkZIh9RCsKO6+3VbU5U1xNf9QL0miZZbIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EuRXHug6; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b6ce1b57b9cso2045414a12.1
        for <kvm@vger.kernel.org>; Wed, 07 Jan 2026 12:59:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767819573; x=1768424373; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=eCHuzfEUF46GF2Ib834+ZGBAqYkYT8KqnjlTeeLh8S8=;
        b=EuRXHug62t8AuApmlhwthizf1qj9pa5SjN5AaJjsDNi3Cltzny6N5ircy0hXLqeTcN
         PfH2VsAFEGjNyinjI/w/UUO4u3pNqPWzmy1BmDv6JYPAc9QR3tiXsNuh0/sag30GnHlf
         6jNT/q+NnwzxHkGeK4W9YzIeCv2qZTGBUXts5DuGPR5ZcyTZzN+QaT5JCtUBwjFAWMjt
         CGGyvphoDD3gYJdXimg7fSdShgizh/wLrz3+/5ulqlrlvIPOZTWoJaaGSm2L5qHoSZFk
         wCTGeC7+YZyNi7S4bFLfvAODK/5RfI4g2LDF6q3AuwbU20F2SwKLueZtvWhr1fWo6KdY
         sN2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767819573; x=1768424373;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eCHuzfEUF46GF2Ib834+ZGBAqYkYT8KqnjlTeeLh8S8=;
        b=anXMpnt4CqGOJtuHlyRdcnI7yAF6W67qMtP/F5fSf3gj+xPQkRNhB6LqMjIdBRjZGP
         EgzsIDeymaOI1pKsof+XlyiLHZoWSLWY5KRvo1VY+o7wq4pdZKmOzpY5JQObsYckftZy
         9t5c4MxnnslyRa2EAfO99Kid88P/IgQgAbyDaM/rvd+T7s9i7vTlQjCHu7HKJDSxIZMw
         9Anbktv9hC9keFNqBgY45GQc1CfTP0JrqT1doeMZBx6E8CbiU4h2wxGXF+6Niv55v7aJ
         LbNVAskbgzxxbOSM2FxPG916pNxaZ/WiUZi1czXsamVZlhK++d1OiDIsNDyvD9aQqDpM
         BlXQ==
X-Forwarded-Encrypted: i=1; AJvYcCVEsU8OmguOax4E0VrDAu1QoC1QiVLpTXgiu+GaPXa2gthIhAJJX94fPRVFdvUXF3JeKV8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzVeEp6ENZtAp/lPfEcWLoLQBgiCgnnGf17Yle/TMvME20HhNzT
	vq63zYPKabgBlhqfz4RKJ1Zyk1OJooam3Z2N9my5RIaIb7mxMQYIc0tJ1f0Lm/0oORjqr8/cdTz
	FRuSrFg==
X-Google-Smtp-Source: AGHT+IF3BPWr3E6fSPMeah7Z7bWoAywC7enuAGjDXFcbNNqTWWKntThrviFsjEM5fkkAEnqFXSfZ+Mv/6aY=
X-Received: from plbkr7.prod.google.com ([2002:a17:903:807:b0:2a0:ad03:ae6a])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3d86:b0:366:14b0:4b0d
 with SMTP id adf61e73a8af0-3898f9aa409mr3469772637.73.1767819573223; Wed, 07
 Jan 2026 12:59:33 -0800 (PST)
Date: Wed, 7 Jan 2026 12:59:31 -0800
In-Reply-To: <ttwq52yzpaymiygr3qgq3cmpghsakb4zdm6yf7qmp5dvvmylar@6ymzjweesi2x>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251230205641.4092235-1-seanjc@google.com> <iwe37tgg2nc2vc5shdlh3zhs4t3mxmuknf4uo3n3p7mz3o5qdn@sxjo33ussf2s>
 <ttwq52yzpaymiygr3qgq3cmpghsakb4zdm6yf7qmp5dvvmylar@6ymzjweesi2x>
Message-ID: <aV7JM22lr8e7_oJ6@google.com>
Subject: Re: [PATCH] KVM: x86: Disallow setting CPUID and/or feature MSRs if
 L2 is active
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kevin Cheng <chengkev@google.com>
Content-Type: text/plain; charset="us-ascii"

On Wed, Jan 07, 2026, Yosry Ahmed wrote:
> On Wed, Jan 07, 2026 at 08:47:02PM +0000, Yosry Ahmed wrote:
> > On Tue, Dec 30, 2025 at 12:56:41PM -0800, Sean Christopherson wrote:
> > > Extend KVM's restriction on CPUID and feature MSR changes to disallow
> > > updates while L2 is active in addition to rejecting updates after the vCPU
> > > has run at least once.  Like post-run vCPU model updates, attempting to
> > > react to model changes while L2 is active is practically infeasible, e.g.
> > > KVM would need to do _something_ in response to impossible situations where
> > > userspace has a removed a feature that was consumed as parted of nested
> > > VM-Enter.
> > 
> > Another reason why I think this may be needed, but I am not sure:
> > 
> > If kvm_vcpu_after_set_cpuid() is executed while L2 is active,
> > KVM_REQ_RECALC_INTERCEPTS will cause
> > svm_recalc_intercepts()->svm_recalc_instruction_intercepts() in the
> > context of L2. While the svm_clr_intercept() and svm_set_intercept()
> > calls explicitly modify vmcb01, we set and clear
> > VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK in svm->vmcb->control.virt_ext. So
> > this will set/clear the bit in vmcb02.
> > 
> > I think this is a bug, because we could end up setting
> > VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK when we shouldn't (e.g. L1 doesn't set
> > in vmcb12, or the X86_FEATURE_V_VMSAVE_VMLOAD is not exposed to L1).
> > 
> > Actually as I am typing this, I believe a separate fix for this is
> > needed. We should be probably setting/clearing
> > VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK on svm->vmcb01.control.
> > 
> > Did I miss something?
> 
> If the analysis above is correct, then a separate fix is indeed required
> because we can end up in the same situation from
> kvm_vm_ioctl_set_msr_filter() -> KVM_REQ_RECALC_INTERCEPTS.

Ouch.  Yep, svm_recalc_instruction_intercepts() should always operate on vmcb01.

