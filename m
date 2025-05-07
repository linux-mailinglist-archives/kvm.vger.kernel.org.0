Return-Path: <kvm+bounces-45760-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BC0A6AAEC85
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 21:54:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4C0C5036B6
	for <lists+kvm@lfdr.de>; Wed,  7 May 2025 19:54:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57A4728EA61;
	Wed,  7 May 2025 19:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sbtzz4Pt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB86E28EA42
	for <kvm@vger.kernel.org>; Wed,  7 May 2025 19:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746647655; cv=none; b=LKv1emaiRo2MoyQc+5a5pCCFDcE0fP5CL12IdvLTGiDjR5TXsr0zp0wagzlDXHtvx2gdlj9xutb3/Ihjt9eaM8ruxsBRSVnNLbQdNq2RQDia1GfD9wB11nxpvKhJHog2dE4mxtJZRt0ogiRyHwdwxGgDttVyHXwrKKH9R8TS1hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746647655; c=relaxed/simple;
	bh=ShCZQy3vwzU3oVYIy5G1J6HsKi2QzRESgVWfZ0AigQM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=beKcpELRVsT1DS+LbiPj0ANsbSxRrg3fWn7A4M8qAG1pbVv+IfCJHs4PkPYHvKw/MxndEBfaP4yo9+HwV6UOLjfkqaoTG2INtkYrTJ62a+lda+82XRIGpfYBXUzfHBAiS2mbZPCfAEYONfHx0exXqHb46hg1c3lxRUc9aVkyC50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sbtzz4Pt; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-22e45821fd7so2163425ad.0
        for <kvm@vger.kernel.org>; Wed, 07 May 2025 12:54:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746647653; x=1747252453; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Gv+Oxn8PfjqeEuzl+oehSEMgyEiLBPURZlNYVnoBUuM=;
        b=sbtzz4PtRk4g7ipsYs0rKV4yHieTfjcX2gp9VIh8skyXb9kWqRbm6pNTwR8U4pUXX9
         +e+zGB15j//eG6fanHZTAYd37PH+droxMF/d+g2fe6nAseb5lN0UDspxK4MPHm0Hb+ZM
         qjfyWHrDNiqYs7AKKdtA11/m0E1SobgGawztx8qPx1VtfmY9s3+xx+h5xhycSNy2++qO
         dZNK+l7yu8gNDevr0+vX3fqvhJQf01euwXjx6GNHYqAYarwC0cpBXbKGuzWQjZikoGD7
         8egSoIaVAw+zJqorKNzkKTLN9/NQkJBkga2aH33UBN4/xjCSbpZ2NdaV4KVg5t4lqZy5
         HsRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746647653; x=1747252453;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Gv+Oxn8PfjqeEuzl+oehSEMgyEiLBPURZlNYVnoBUuM=;
        b=ot9DNIiNp4fDuqDhteUkT+4r4zCPnIVNGvGpJ6QSMB+SvQ6DKYRSVsoi3V5nXSIy46
         Ba2FuPLVUkvKLUDA6naXIYKED7Vcf52IRtelLNJCk3zTwztKBrc3EZFSvAgVEh6rYghi
         2LQpQ3Nbbxr+j8w72tVVJ8nO19iSVI77tspx6ysRVexXrDMbC+iXFEbhVj4lFyVpXaFt
         rUQeV+D6uca4TBzEYqRuuAIakyRRSKJG77bwTaFkmc9o+2pcUZC6mIQc7ESA0HpvvIjT
         LDrGMnwAMhsD+rO0cKEHXvZtsKJ5UsjSoKgwTUBMx+RFOjAR0AZa2sh9wAKKLRAZyI1M
         Nwjw==
X-Forwarded-Encrypted: i=1; AJvYcCW3W1WBjDDFy8TlXUNKya7LDs1dwA/O011xfN7EBikc4AJoYurS1Ix0hxABam+/YZL3q8A=@vger.kernel.org
X-Gm-Message-State: AOJu0YwK6VVCYK3GyU9hpMqAfLAhCCu7V406UsuDPxPJ2g+Skf3fmCnW
	HBylG6BWYgoOj/i37eG+xjgbiBY1ibq8+sup/mXdGMmsi5iLAd/ObJ83lhMj72VNqVBnF9oUkPB
	tjw==
X-Google-Smtp-Source: AGHT+IHgI7//spCyyYGB/KDC1e01Q+VcOlcRx9o432n13LkemmOBG7vR6DZ0ZZrjX2rAdSSc+5oGThA5PDY=
X-Received: from plbjk16.prod.google.com ([2002:a17:903:3310:b0:229:2f8a:aac5])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:db0c:b0:224:912:153
 with SMTP id d9443c01a7336-22e5ea28001mr76488695ad.5.1746647653247; Wed, 07
 May 2025 12:54:13 -0700 (PDT)
Date: Wed, 7 May 2025 12:54:06 -0700
In-Reply-To: <CALMp9eS5hqD-F8k=4YOGFedOWjgc=rDvqP+98gOrn9ne68NNpA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250321221444.2449974-1-jmattson@google.com> <20250321221444.2449974-3-jmattson@google.com>
 <aBAqzZOiCCYWgOrM@google.com> <CALMp9eS5hqD-F8k=4YOGFedOWjgc=rDvqP+98gOrn9ne68NNpA@mail.gmail.com>
Message-ID: <aBu6XkrAelyMqrsB@google.com>
Subject: Re: [PATCH v3 2/2] KVM: selftests: Test behavior of KVM_X86_DISABLE_EXITS_APERFMPERF
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 07, 2025, Jim Mattson wrote:
> On Mon, Apr 28, 2025 at 6:26=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> > > +     /*
> > > +      * This test requires a non-standard VM initialization, because
> > > +      * KVM_ENABLE_CAP cannot be used on a VM file descriptor after
> > > +      * a VCPU has been created.
> >
> > Hrm, we should really sort this out.  Every test that needs to enable a=
 capability
> > is having to copy+paste this pattern.  I don't love the idea of expandi=
ng
> > __vm_create_with_one_vcpu(), but there's gotta be a solution that isn't=
 horrible,
> > and anything is better than endly copy paste.
>=20
> This is all your fault, I believe. But, I'll see what I can do.

Ha, that it is, both on the KVM and the selftests side.

Unless you already have something clever in hand, just keep what you have. =
 I poked
at this a bit today, and came to the conclusion that trying to save two liv=
es of
"manual" effort isn't worth the explosion in APIs and complexity.  I was th=
inking
that the only additional input would be the capability to enable, but most =
usage
also needs to specify a payload, and this pattern is used in a few places w=
here
a selftest does more than toggle a capability.

What I really want is the ability to provide a closure to all of the "creat=
e with
vCPUs" APIs, e.g.


	vm =3D vm_create_with_one_vcpu(&vcpu, guest_code, magic() {
		vm_enable_cap(vm, KVM_CAP_X86_DISABLE_EXITS,
			      KVM_X86_DISABLE_EXITS_APERFMPERF);
	});

But even if we managed to make something work, I'm not sure it'd be worth t=
he
plumbing.

One thing that would make me less annoyed would be to eliminate the @vcpu_i=
d
param, e.g.

  static inline struct kvm_vcpu *vm_vcpu_add(struct kvm_vm *vm, void *guest=
_code)
  {
	return __vm_vcpu_add(vm, vm->nr_vcpus++, guest_code);
  }

so that at least this pattern doesn't have '0' hardcoded everywhere.  But t=
hat's
an annoying cleanup due to __vm_vcpu_add() not being a strict superset of
vm_vcpu_add(), i.e. would require a lot of churn.

So for this series, just keep the copy+pasted pattern.

> > > +      */
> > > +     vm =3D vm_create(1);
> > > +
> > > +     TEST_REQUIRE(kvm_can_disable_aperfmperf_exits(vm));
> >
> >         TEST_REQUIRE(vm_check_cap(vm, KVM_CAP_X86_DISABLE_EXITS) &
> >                      KVM_X86_DISABLE_EXITS_APERFMPERF);
> > > +
> > > +     vm_enable_cap(vm, KVM_CAP_X86_DISABLE_EXITS,
> > > +                   KVM_X86_DISABLE_EXITS_APERFMPERF);
> > > +
> > > +     vcpu =3D vm_vcpu_add(vm, 0, guest_code);
> > > +
> > > +     host_aperf_before =3D read_dev_msr(msr_fd, MSR_IA32_APERF);
> > > +     host_mperf_before =3D read_dev_msr(msr_fd, MSR_IA32_MPERF);
> > > +
> > > +     for (i =3D 0; i < NUM_ITERATIONS; i++) {
> > > +             uint64_t host_aperf_after, host_mperf_after;
> > > +             uint64_t guest_aperf, guest_mperf;
> > > +             struct ucall uc;
> > > +
> > > +             vcpu_run(vcpu);
> > > +             TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
> > > +
> > > +             switch (get_ucall(vcpu, &uc)) {
> > > +             case UCALL_DONE:
> > > +                     break;
> > > +             case UCALL_ABORT:
> > > +                     REPORT_GUEST_ASSERT(uc);
> > > +             case UCALL_SYNC:
> > > +                     guest_aperf =3D uc.args[0];
> > > +                     guest_mperf =3D uc.args[1];
> > > +
> > > +                     host_aperf_after =3D read_dev_msr(msr_fd, MSR_I=
A32_APERF);
> > > +                     host_mperf_after =3D read_dev_msr(msr_fd, MSR_I=
A32_MPERF);
> > > +
> > > +                     TEST_ASSERT(host_aperf_before < guest_aperf,
> > > +                                 "APERF: host_before (%lu) >=3D gues=
t (%lu)",
> > > +                                 host_aperf_before, guest_aperf);
> >
> > Honest question, is decimal really better than hex for these?
>=20
> They are just numbers, so any base should be fine. I guess it depends
> on which base you're most comfortable with. I could add a command-line
> parameter.

Nah, don't bother, pick whatever you like.  I was genuinely curious if one =
format
or another made it easier to understand the output.

