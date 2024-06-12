Return-Path: <kvm+bounces-19373-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4042D90483B
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 03:19:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DA3E61F23E59
	for <lists+kvm@lfdr.de>; Wed, 12 Jun 2024 01:19:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C870F391;
	Wed, 12 Jun 2024 01:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pEjXY8GE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE6E1865
	for <kvm@vger.kernel.org>; Wed, 12 Jun 2024 01:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718155130; cv=none; b=dgg3n0Y6Q6YHFucgMCZiU9Q7tnAF5gbAt2R2/MeXFZE7m5Kq7PDZCQ1rPKkjzibuP761esdh4gAVRUmItbOGNKXSLPGay9xbpD6F+zdx0j8POEbo/tc+GRfYAhAgyAqYw2wvHwJ7lrCnjZiuEl82apYmjt/yjjEPR7sj3TPtHQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718155130; c=relaxed/simple;
	bh=NRQ5vxw0MkZ7yLnvDJPYGw9jB/h83t9zD3AKH0/y8IA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=HGlxpZu1wyDWF+s9r6dljviYOp0E85+3O5HYQaMXZFRZdPAuqorO2KjkEYkiKOM3ONkAVcsCrUehIQ2KjWb2Y72s3rSm+sxC+bDc6v+wMfHeNENjeLRu65W+HuTueoV7cYG2t8hbRlFvrKV7gzsLXNQyomUSDOy32Rd9MEgwKPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pEjXY8GE; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-1f70c39d17fso2900915ad.1
        for <kvm@vger.kernel.org>; Tue, 11 Jun 2024 18:18:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718155128; x=1718759928; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gH/VrRThVAqNqdnAJ8qqfFFTLj74e8FaAJgriK6mdbo=;
        b=pEjXY8GEgFrzWkl7rtBJyniHlxYyMCahyYeu+gYkmCZJtQ/kw3QIwMy7zAC2V5/Rg0
         /7hgTzSJv9dWgreG+nbPJx7T2H9LI5eLwc8Fk8wg/+1Cq6zOUlzEzJ8AAnCNNQhQCySG
         OQPBKUDVm2yQqLeAPxQa9oM+UnmYuZfqE+IBsGLBcxmC3J6rPQj1jeVxzoJCl7c9yZWh
         yZUexog9dPhQndsTK6KpPQP3YWllg46NlThtb6MxcWjPwC2KLjfj8tkxOmRjYvsPoJdZ
         XRngwc8gCuiEIR5PyFo+w19DVFDTJ9f0wpT8Q7BZ91jASm+UHQNrGrD5CDjTp5t6wF1a
         ArdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718155128; x=1718759928;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gH/VrRThVAqNqdnAJ8qqfFFTLj74e8FaAJgriK6mdbo=;
        b=AvnkEDNZvjIau1MoQk/+246uO0GYxmYWz4hnriLNv/ej5wNabvOHhZ5t357eTjpjip
         OJYjznVkNm7SIKCfDOKbMJj3x7HJGUuHdSJD6YyCzNy0cS8/XiyE8wHkaaxxGbxaRIfg
         O8IlFFvdzKjevLcmgAbghvDonQP0IOKkhOmNu1vG4Uo66fEFm2HylKojf4BxsV4A3h29
         r8/UYZ+S6dhZm6sUi1aZb2H5SG265x8jH4kxU7Z0s/zg9Tv6DftcqH2EHOv2NetJ0N8L
         3TQKLQbA7oo1ZrgRfxGSWcg4d0CX35JlL6EbUQwd6zSvrcqnWDga+AG72mb/22HNfSPS
         7hUA==
X-Forwarded-Encrypted: i=1; AJvYcCUvymJFVYwZIbVuTWROwoP+TojivqasHE8+MLnypnDmNs7v5JpscOrM+eqb8zE2sHbRG56Hj72rAJhYQrZ3TktVeLiY
X-Gm-Message-State: AOJu0YxxJjqB+c4F+MfokRl1dfrGCYD6hBAVPDv6iVJnODrGibtvheZf
	y9QJcbeLq4qp3Tgt9TKkdZL8xR9PWqXhiQGRdIJiIFYufz16STicAFSEf0ABSYpeVMA+bZbBtkG
	yGw==
X-Google-Smtp-Source: AGHT+IFA7Nf2gM73IakGhMLgjpKn7tnJ0y7JJoAyUgWaeTxteQw7ecnDkGCPi06xyYh6rqY8tUOLbz5+Rl4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:ce82:b0:1f7:516:4235 with SMTP id
 d9443c01a7336-1f83b1af087mr431195ad.6.1718155127840; Tue, 11 Jun 2024
 18:18:47 -0700 (PDT)
Date: Tue, 11 Jun 2024 18:18:27 -0700
In-Reply-To: <20240522014013.1672962-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240522014013.1672962-1-seanjc@google.com>
X-Mailer: git-send-email 2.45.2.505.gda0bf45e8d-goog
Message-ID: <171813751765.307375.7908491276602596005.b4-ty@google.com>
Subject: Re: [PATCH v2 0/6] KVM: Fold kvm_arch_sched_in() into kvm_arch_vcpu_load()
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, Huacai Chen <chenhuacai@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anup Patel <anup@brainfault.org>, 
	Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Tue, 21 May 2024 18:40:07 -0700, Sean Christopherson wrote:
> Drop kvm_arch_sched_in() and instead add and use kvm_vcpu.scheduled_out
> to communicate to kvm_arch_vcpu_load() that the vCPU is being scheduling
> back in.
> 
> While fiddling with an idea for optimizing state management on AMD CPUs,
> I wanted to skip re-saving certain host state when a vCPU is scheduled back
> in, as the state (theoretically) shouldn't change for the task while it's
> scheduled out.  Actually doing that was annoying and unnecessarily brittle
> due to having a separate API for the kvm_sched_in() case (the state save
> needed to be in kvm_arch_vcpu_load() for the common path).
> 
> [...]

Applied to kvm-x86 generic, thanks!

[1/6] KVM: Add a flag to track if a loaded vCPU is scheduled out
      https://github.com/kvm-x86/linux/commit/d1ae567fb8b5
[2/6] KVM: VMX: Move PLE grow/shrink helpers above vmx_vcpu_load()
      https://github.com/kvm-x86/linux/commit/5d9c07febb86
[3/6] KVM: x86: Fold kvm_arch_sched_in() into kvm_arch_vcpu_load()
      https://github.com/kvm-x86/linux/commit/8fbb696a8f53
[4/6] KVM: Delete the now unused kvm_arch_sched_in()
      https://github.com/kvm-x86/linux/commit/2a27c4314007
[5/6] KVM: x86: Unconditionally set l1tf_flush_l1d during vCPU load
      https://github.com/kvm-x86/linux/commit/ef2e18ef3750
[6/6] KVM: x86: Drop now-superflous setting of l1tf_flush_l1d in vcpu_run()
      https://github.com/kvm-x86/linux/commit/3dee3b187499

--
https://github.com/kvm-x86/linux/tree/next

