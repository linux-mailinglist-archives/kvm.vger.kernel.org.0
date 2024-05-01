Return-Path: <kvm+bounces-16342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EEC448B8BDD
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 16:28:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1DA781C211F4
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 14:28:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5130012F399;
	Wed,  1 May 2024 14:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yIkInVr+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C62612F369
	for <kvm@vger.kernel.org>; Wed,  1 May 2024 14:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714573705; cv=none; b=sEVBbkAuNe2d7XQWWHcY3FO5Nc2XKwTq9ipuggiA7b9avpWhSh6tSaO5LkD1v0t6nfMbn2Ax0QnvK8oW+tgBM/cdJ7j9+c8tM+DAV3LYXO9+KhuEMAzjpXkinYSBEnAS2bXH4IBlvPcHdbwYISPahHVCveasy1Y/pMs5unZATO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714573705; c=relaxed/simple;
	bh=ejN7GdpXckHQzIXsC1FJGXtUzTE2KYdclj/fn/dJjrg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WZntnB/le90MRoOi22DWhk0zLQGMtcPUD81bhoKZNyoPYez77Slyv1s1gPAhqASjev1voIp4ZJwPQKEnviEWednXVUazTDQdSBUBVQgYQAIZD5K1mOhTKqviMnwi9qkJHL0jquPR26HNvBQb3zj6HwVfc3XpC2z11sogX16Y/Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yIkInVr+; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61acc68c1bdso9075827b3.1
        for <kvm@vger.kernel.org>; Wed, 01 May 2024 07:28:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714573703; x=1715178503; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XN3PxGtZEQXNqntUnTfIz5xk/K9LwEoscNdYQ+/jCbc=;
        b=yIkInVr+T2n9SqoReSpWC6KAI3dtuyHyqF3lQtWvSow7T07+bGmZXWhr/D/jWWZXG6
         y5ZV3CtlY7DKLyOvsYU6R6PJEVtXlb7/7A9mGgIzZ9hd7/gk/cq5vAVqwlZDuMscRWO6
         Vnwf7MeCNZcfoEDWziDkYZnzDHrdhSgL76ACkpU3JdjLixdwGCn7HzKMUQf8l4EDgYSV
         0w+HSrjqbZIiH4EpBEitkRRrP5CLRz8UTk0lEwQlqJfcsZTOM/OcQY84IkuRhl+I1eFb
         BN/E5oDtYLo6Oya7cu9vWEiLyVucoQrrOdBqFqpSL6yIQ6uPPmq8t57yEaeKrneSN0Gf
         f/0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714573703; x=1715178503;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XN3PxGtZEQXNqntUnTfIz5xk/K9LwEoscNdYQ+/jCbc=;
        b=gWh6GJLdRKtWDHKp3sEnBKeS9As6iGfSyRAfqPpz9KlWCzU2ccOn7fF65ej5rHKoOD
         zyxlFgZ1KmauanpVjq+FviAo7q9btArLvXlybZfu56c+HL6R7pBAKd+TrPYnjDNuKEYY
         xwQaurJDGHskx3Zj3Q6KEMONniz1o32QPBPhQp5Yw1ri3ryUsfc1IktPCVN266gMP3M8
         +3Q3cfN9uWfvltWL3LvU8zqZvZJxNm5u48OeApJLw0pfJAhc/JVLpC7Mb8fCWr5R6xJ5
         TwAtVnR78czvZOTkNnWHSsHmGiLXS63dXF0oFqwdXCVNafhZqlRD44lJTD4joV97vP1C
         I66Q==
X-Forwarded-Encrypted: i=1; AJvYcCVHcOh7254gq4622aPsHyEIb8YAuI/ZpV+W0/XGvcZXZ2SHX5Cr2qKayv1YAGn2se1sbHWw4eGaTtwUc3v8sLc+ouR0
X-Gm-Message-State: AOJu0Yzk+GBcUipX3++lt4sG+WSPA+qE3NvECeUI6RolIBdfegkaGg6a
	89WV03uNB/R8tbiiOYTqhW66dDre2PxMPj1pR/0Yed9NfxgRXcl5wP2FRzHgXJezjQOkwmeyMLj
	R3w==
X-Google-Smtp-Source: AGHT+IHUezc4IZyZaMpXPcKS4Nl6spB8OORkXUO8w6Eu/n8Z2MEF5bQ0emcAkaZbOCNg6hB5INRjxf830ZQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:a283:0:b0:de5:a44c:25af with SMTP id
 c3-20020a25a283000000b00de5a44c25afmr1319848ybi.5.1714573703105; Wed, 01 May
 2024 07:28:23 -0700 (PDT)
Date: Wed, 1 May 2024 07:28:21 -0700
In-Reply-To: <ZjGMn5tlq8edKZYv@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240430193157.419425-1-seanjc@google.com> <ZjGMn5tlq8edKZYv@linux.dev>
Message-ID: <ZjJRhQhX_12eBvY-@google.com>
Subject: Re: [PATCH 0/4] KVM: Fold kvm_arch_sched_in() into kvm_arch_vcpu_load()
From: Sean Christopherson <seanjc@google.com>
To: Oliver Upton <oliver.upton@linux.dev>
Cc: Marc Zyngier <maz@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, May 01, 2024, Oliver Upton wrote:
> On Tue, Apr 30, 2024 at 12:31:53PM -0700, Sean Christopherson wrote:
> > Drop kvm_arch_sched_in() and instead pass a @sched_in boolean to
> > kvm_arch_vcpu_load().
> > 
> > While fiddling with an idea for optimizing state management on AMD CPUs,
> > I wanted to skip re-saving certain host state when a vCPU is scheduled back
> > in, as the state (theoretically) shouldn't change for the task while it's
> > scheduled out.  Actually doing that was annoying and unnecessarily brittle
> > due to having a separate API for the kvm_sched_in() case (the state save
> > needed to be in kvm_arch_vcpu_load() for the common path).
> > 
> > E.g. I could have set a "temporary"-ish flag somewhere in kvm_vcpu, but (a)
> > that's gross and (b) it would rely on the arbitrary ordering between
> > sched_in() and vcpu_load() staying the same.
> 
> Another option would be to change the rules around kvm_arch_sched_in()
> where the callee is expected to load the vCPU context.
> 
> The default implementation could just call kvm_arch_vcpu_load() directly
> and the x86 implementation can order things the way it wants before
> kvm_arch_vcpu_load().
> 
> I say this because ...
> 
> > The only real downside I see is that arm64 and riscv end up having to pass
> > "false" for their direct usage of kvm_arch_vcpu_load(), and passing boolean
> > literals isn't ideal.  But that can be solved by adding an inner helper that
> > omits the @sched_in param (I almost added a patch to do that, but I couldn't
> > convince myself it was necessary).
> 
> Needing to pass @sched_in for other usage of kvm_arch_vcpu_load() hurts
> readability, especially when no other architecture besides x86 cares
> about it.

Yeah, that bothers me too.

I tried your suggestion of having x86's kvm_arch_sched_in() do kvm_arch_vcpu_load(),
and even with an added kvm_arch_sched_out() to provide symmetry, the x86 code is
kludgy, and even the common code is a bit confusing as it's not super obvious
that kvm_sched_{in,out}() is really just kvm_arch_vcpu_{load,put}().

Staring a bit more at the vCPU flags we have, adding a "bool scheduled_out" isn't
terribly gross if it's done in common code and persists across load() and put(),
i.e. isn't so blatantly a temporary field.  And because it's easy, it could be
set with WRITE_ONCE() so that if it can be read cross-task if there's ever a
reason to do so.

The x86 code ends up being less ugly, and adding future arch/vendor code for
sched_in() *or* sched_out() requires minimal churn, e.g. arch code doesn't need
to override kvm_arch_sched_in().

The only weird part is that vcpu->preempted and vcpu->ready have slightly
different behavior, as they are cleared before kvm_arch_vcpu_load().  But the
weirdness is really with those flags no having symmetry, not with scheduled_out
itself.

Thoughts?

static void kvm_sched_in(struct preempt_notifier *pn, int cpu)
{
	struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);

	WRITE_ONCE(vcpu->preempted, false);
	WRITE_ONCE(vcpu->ready, false);

	__this_cpu_write(kvm_running_vcpu, vcpu);
	kvm_arch_vcpu_load(vcpu, cpu);

	WRITE_ONCE(vcpu->scheduled_out, false);
}

static void kvm_sched_out(struct preempt_notifier *pn,
			  struct task_struct *next)
{
	struct kvm_vcpu *vcpu = preempt_notifier_to_vcpu(pn);

	WRITE_ONCE(vcpu->scheduled_out, true);

	if (current->on_rq) {
		WRITE_ONCE(vcpu->preempted, true);
		WRITE_ONCE(vcpu->ready, true);
	}
	kvm_arch_vcpu_put(vcpu);
	__this_cpu_write(kvm_running_vcpu, NULL);
}

