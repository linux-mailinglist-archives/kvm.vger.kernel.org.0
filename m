Return-Path: <kvm+bounces-18237-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6472E8D2471
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 21:17:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 16EAC28BBBF
	for <lists+kvm@lfdr.de>; Tue, 28 May 2024 19:17:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E89A176FD2;
	Tue, 28 May 2024 19:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="viVzdojg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6C8174EFA
	for <kvm@vger.kernel.org>; Tue, 28 May 2024 19:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716923775; cv=none; b=lCH5AFMwFHzZiSpX5Y1aG/Q8JywZZu/E+Tn1+adEmfIhQ0LQzj4j7we0aFPlOqO4dWEkjprG5xzzlQ0//KKYoZFEmX9PZmAPn2HEPj9y8IDdZArOE0794ydn6FmVq8YdptQ0evBE4zoG3HeE/CCX+uMIf1JrCaF9KLi1tZBosWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716923775; c=relaxed/simple;
	bh=ag7+h70RDNCub6CI9FhMvv9doD/tLeJlJWjTiOiUnAE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Mzn8QAst0DgPIr0YSMwqqGnbp4dt8rcNGDKS/4ScrraPq4OIv/jgjQmVGfZhD6WoBXrGs1lpjrnZoqUlb2o6CKM6mlGw/vqoL5ptUZhR0tSPLTHJtgJMgCTdmcp1mUFtLrUUtO+LEoJtoid/eSzkb1pchclPHM3DpaYKn6XUjBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=viVzdojg; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-df52a2535d5so1629094276.0
        for <kvm@vger.kernel.org>; Tue, 28 May 2024 12:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716923773; x=1717528573; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aN1FoCckBsPH3nlr2F+fxU8+3rgvDDBf83ZZTupmDzY=;
        b=viVzdojgJrWKjqTJr5Izw239q1ePp6TGp5Ng4+2J1ZBKYzp1Q5vdvLiaPr+X+zsujL
         OenUB1emtOYJB40+qpa9UulYOpd//+GI6WTtyFKPru4x/E4X5IuLATSB+5pVXE2We5gZ
         X4kojHm4A9VvBmbKwT6iPtnBsWLBak9V6I5BR1qUzfYBF0LJj2Jzh1gNml1u4saDvued
         EOj4eHTt+pr56Gl/LzD1hJUzUusxiiGQ97hVG62ed8Yu+UX57r21cJIKRV+VDlwjMEdH
         L0t910eLNg7jRLgk8BefxA7L7r5I2kC0KSWPX7FnLSmWFck+WIq+HZxCOIxSG9NzzoSX
         dMdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716923773; x=1717528573;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aN1FoCckBsPH3nlr2F+fxU8+3rgvDDBf83ZZTupmDzY=;
        b=rwqpUyuKh3Qd1iT+POaj6AW+ar962zTRiz7mQivqr5avyBbhpkrBlLIh3/to3rBg8x
         XOIbXeqinA/eP26axqjXMXGNTjTo+Gdi8hCssG/b2WTyJaUi5UyDFarBYDY2gwZlQmy1
         DibrLVXVZhXxF1ZQmGWGROmpZGb8LTiheDZPNVXWLYY75jSmtxR63PlVcjQL8z73zSpU
         8eot0BCmi+cmsZUdZdFrBSqxlCN21RQLzfoX4IcwMfnpuI78P1NmLLO7c29+/3Cg2mru
         3/TBvSCeFNdh5G0FP1+N/m/W/i/gxEJBefoaRBF7uOOpRFth9EtyloezkzqUFGAXTgqw
         AkrA==
X-Forwarded-Encrypted: i=1; AJvYcCV+sFcLd+g5zk4AgUm12fUb4nx1+AkXt+9tN8HTdcaJWhDc51hRSr+6gK/H/mAl8/ZQ7/p2Ep/EjeVw7Lp5UnK78bPr
X-Gm-Message-State: AOJu0YyAy1OJGytCixfpqhheknioKducW5+j2JpcJQAS87kb3fYnwKlf
	f6vFxGCNm0o/x8n9HGNGEory+XZ65vGBlevRXeSPeFbcR/xlhk94b0b+labV+NOvgjG+pwvz2K9
	xcw==
X-Google-Smtp-Source: AGHT+IEYffSoUdZ4cg7KX8v+KoP4uvokISlIeu5qUtxtXAQ85EyWGJZei7jVgr6jZvnufr8gfWsoMUgR1K8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:10c3:b0:df7:943d:f935 with SMTP id
 3f1490d57ef6-df7943e55a0mr788014276.2.1716923773190; Tue, 28 May 2024
 12:16:13 -0700 (PDT)
Date: Tue, 28 May 2024 12:16:11 -0700
In-Reply-To: <c77f3931-31b2-4695-bd74-c69cba9b96c1@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240522014013.1672962-1-seanjc@google.com> <20240522014013.1672962-4-seanjc@google.com>
 <c77f3931-31b2-4695-bd74-c69cba9b96c1@intel.com>
Message-ID: <ZlYte16cvQpPGHkx@google.com>
Subject: Re: [PATCH v2 3/6] KVM: x86: Fold kvm_arch_sched_in() into kvm_arch_vcpu_load()
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>, 
	Huacai Chen <chenhuacai@kernel.org>, Michael Ellerman <mpe@ellerman.id.au>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Fri, May 24, 2024, Kai Huang wrote:
> > @@ -1548,6 +1548,9 @@ static void svm_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> >   	struct vcpu_svm *svm = to_svm(vcpu);
> >   	struct svm_cpu_data *sd = per_cpu_ptr(&svm_data, cpu);
> > +	if (vcpu->scheduled_out && !kvm_pause_in_guest(vcpu->kvm))
> > +		shrink_ple_window(vcpu);
> > +
> 
> [...]
> 
> > @@ -1517,6 +1517,9 @@ void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> >   {
> >   	struct vcpu_vmx *vmx = to_vmx(vcpu);
> > +	if (vcpu->scheduled_out && !kvm_pause_in_guest(vcpu->kvm))
> > +		shrink_ple_window(vcpu);
> > +
> 
> Nit:  Perhaps we need a kvm_x86_ops::shrink_ple_window()?  :-)

Heh, that duplicate code annoys me too.  The problem is the "old" window value
comes from the VMCS/VMCB, so either we'd end up with multiple kvm_x86_ops, or
we'd only be able to consolidate the scheduled_out + kvm_pause_in_guest() code,
which isn't all that interesting.

Aha!  Actually, VMX already open codes the functionality provided by VCPU_EXREG_*,
e.g. has vmx->ple_window_dirty.  If we add VCPU_EXREG_PLE_WINDOW, then the info
get be made available to common x86 code without having to add new hooks.  And
that would also allow moving the guts of handle_pause()/pause_interception() to
common code, i.e. will also allow deduplicating the "grow" side of things.

