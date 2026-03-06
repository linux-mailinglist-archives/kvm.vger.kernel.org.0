Return-Path: <kvm+bounces-72971-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WCDdHWkwqmnXMwEAu9opvQ
	(envelope-from <kvm+bounces-72971-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 02:39:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 851C521A453
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 02:39:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 5F0203013C74
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 01:39:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA86831E833;
	Fri,  6 Mar 2026 01:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="15paiwrm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FACC19B5B1
	for <kvm@vger.kernel.org>; Fri,  6 Mar 2026 01:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772761174; cv=none; b=oh7IaLSIgXZwJO+ESbGAuntxgk2WYgMwkwuzHYXrixj++CRl0q8vA91Cqsg94YQLF4enpR5J8dmjFDKbdbTmc9163U4bjsm0q75W23HYBZn4RdS0VJLeLIo/RxL/hSfZYRn0nJfUxJKErnjNUbZA9/lytbd4rz6GbhQVfq64zt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772761174; c=relaxed/simple;
	bh=M0JcElFdpqFtGRb/Zz+KHIh22rVtm6hjn2JxC2reo/E=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=U107BxeJQnQomvS/5QocNLTbkm2RP8rWgNUJ+ExKf5j8Jo6fIJAjmnRV0iaAOIyHSys04Zg1zsJeoHdMvWvWz+9iCA9zl7oVyGZgquSOY9A5eFHP3qgxQ8LgZgSoDil86zdXufZaA2wxiY7l9z8uPse6Sd4islgK6ynwkfZpylE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=15paiwrm; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2ae5031c6c5so230249085ad.3
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2026 17:39:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772761171; x=1773365971; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WF5GW9U8X6v9xtxyzDWC9k1yzZZMSQz6nKA9iuuryHw=;
        b=15paiwrmsxnnzxSTNEy5yPF8tdQXifvwAHwHvHBbq+n8ZwmRkRZr+wArUn5NPjBQ23
         5vpuXChS0ZgtulC1aU/cIHJrzk3NCeD7jxmt8GRE4wTFnriOx4A9geMXI3PKEfqqCFWi
         ql1GnzB03EjBbcbfIKI0Ain4xTcfq2xvDARydl4I9muCLRO5Bgaia7aYT4UREQNye5sS
         7yJUjSoCaFURuI5DqTghqdF1IG+ejRVUleDrtDsrtvj9W/k6taGgpKDa5W9qyt2CCIKg
         wanMbnG2qGeBS5M9bn6x/8V/CTcS/Vd7oMqHCuHBmqoSbyd6KnMnxiqr/7mrNLMhpoGW
         K50w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772761171; x=1773365971;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=WF5GW9U8X6v9xtxyzDWC9k1yzZZMSQz6nKA9iuuryHw=;
        b=KaHpMcWjxG3UXXhE8OrLYQdxwVIPDVJnydhE92sEPM3eipPq4UN1ARSW8ycy35Z5zH
         OI0eqphVlH+KzZ1YmCOBeZ0ulc5XrXIDiUKOu4Ar0Vp7BgrNNBlVJgiItRgdNtnV8CNF
         CkFnLKpkq2YONFecU/W1WEN/NfHsfN50wtUONe8xl4sHe8m+Yxb2JQHgFBqsfoFski2S
         Y/dklnF1ifFW1nEMUmqJE47LG7rkhwBLQWkm+wBrAUZVlmYwrww/Q3HpXWNFrYBfiHoY
         oKlPHLGW2VEmPORegRcwzGBv5nA/vrgAIP45hFAq/hH3sask5xnDxFuMU/ZL4jaVn2yA
         2egQ==
X-Forwarded-Encrypted: i=1; AJvYcCVnNcvYrdfUUGxVWw/LG8gaZAld6Fo4gzpGAxhU6XflHHpSFFMBUyIgyW4hPIQ3Mf2WdiA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw866pxiDea08X9hLlnC25hYCsNzhiJArqB6kEu0lpZMZN49gMH
	muKXiO/qATW2tg7Oss35rC7InZmqsusN5huRhBRMhvh/gx6Hq7hAUGVwun24ZsB2CqJtdth90Lt
	EpF/IBw==
X-Received: from plblh5.prod.google.com ([2002:a17:903:2905:b0:2ae:4060:2b13])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:ce12:b0:2aa:d67b:ef96
 with SMTP id d9443c01a7336-2ae8243b2f7mr5225265ad.31.1772761171233; Thu, 05
 Mar 2026 17:39:31 -0800 (PST)
Date: Thu, 5 Mar 2026 17:39:29 -0800
In-Reply-To: <CALMp9eQMqZa5ci6RsroNZEEpTTx_5pBPTLxk_zOBaA8_Vy4jyw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260303003421.2185681-1-yosry@kernel.org> <20260303003421.2185681-27-yosry@kernel.org>
 <CALMp9eSMtzDJn7tGtbj=zLYpcU7Tc7XjcWBRZH7Aa5YihSmN7g@mail.gmail.com>
 <CAO9r8zMhwdc6y1JPxmoJOaH8g1i7NuhPo4V1iOhsc7WFskAPFw@mail.gmail.com>
 <CALMp9eRzy+C1KmEvt1FDXJrdhmXyyur8yPCr1q2M+AfNUcvnsQ@mail.gmail.com>
 <CAO9r8zPRJGde9PruGkc1TGvbSU=N=pFMo5uc78XNJYKMX0rUNg@mail.gmail.com> <CALMp9eQMqZa5ci6RsroNZEEpTTx_5pBPTLxk_zOBaA8_Vy4jyw@mail.gmail.com>
Message-ID: <aaowUfyt7tu8g5fr@google.com>
Subject: Re: [PATCH v7 26/26] KVM: selftest: Add a selftest for VMRUN/#VMEXIT
 with unmappable vmcb12
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Yosry Ahmed <yosry@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 851C521A453
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72971-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo]
X-Rspamd-Action: no action

On Thu, Mar 05, 2026, Jim Mattson wrote:
> On Thu, Mar 5, 2026 at 4:40=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wro=
te:
> >
> > On Thu, Mar 5, 2026 at 4:05=E2=80=AFPM Jim Mattson <jmattson@google.com=
> wrote:
> > >
> > > On Thu, Mar 5, 2026 at 2:52=E2=80=AFPM Yosry Ahmed <yosry@kernel.org>=
 wrote:
> > > >
> > > > On Thu, Mar 5, 2026 at 2:30=E2=80=AFPM Jim Mattson <jmattson@google=
.com> wrote:
> > > > >
> > > > > On Mon, Mar 2, 2026 at 4:43=E2=80=AFPM Yosry Ahmed <yosry@kernel.=
org> wrote:
> > > > > >
> > > > > > Add a test that verifies that KVM correctly injects a #GP for n=
ested
> > > > > > VMRUN and a shutdown for nested #VMEXIT, if the GPA of vmcb12 c=
annot be
> > > > > > mapped.
> > > > > >
> > > > > > Signed-off-by: Yosry Ahmed <yosry@kernel.org>
> > > > > > ...
> > > > > > +       /*
> > > > > > +        * Find the max legal GPA that is not backed by a memsl=
ot (i.e. cannot
> > > > > > +        * be mapped by KVM).
> > > > > > +        */
> > > > > > +       maxphyaddr =3D kvm_cpuid_property(vcpu->cpuid, X86_PROP=
ERTY_MAX_PHY_ADDR);
> > > > > > +       max_legal_gpa =3D BIT_ULL(maxphyaddr) - PAGE_SIZE;
> > > > > > +       vcpu_alloc_svm(vm, &nested_gva);
> > > > > > +       vcpu_args_set(vcpu, 2, nested_gva, max_legal_gpa);
> > > > > > +
> > > > > > +       /* VMRUN with max_legal_gpa, KVM injects a #GP */
> > > > > > +       vcpu_run(vcpu);
> > > > > > +       TEST_ASSERT_KVM_EXIT_REASON(vcpu, KVM_EXIT_IO);
> > > > > > +       TEST_ASSERT_EQ(get_ucall(vcpu, &uc), UCALL_SYNC);
> > > > > > +       TEST_ASSERT_EQ(uc.args[1], SYNC_GP);
> > > > >
> > > > > Why would this raise #GP? That isn't architected behavior.
> > > >
> > > > I don't see architected behavior in the APM for what happens if VMR=
UN
> > > > fails to load the VMCB from memory. I guess it should be the same a=
s
> > > > what would happen if a PTE is pointing to a physical address that
> > > > doesn't exist? Maybe #MC?
> > >
> > > Reads from non-existent memory return all 1's
> >
> > Today I learned :) Do all x86 CPUs do this?
>=20
> Yes. If no device claims the address, reads return all 1s. I think you
> can thank pull-up resistors for that.

Ya, it's officially documented PCI behavior.  Writes are dropped, reads ret=
urn
all 1s.

> > > so I would expect a #VMEXIT with exitcode VMEXIT_INVALID.
> >
> > This would actually simplify the logic, as it would be the same
> > failure mode as failed consistency checks. That being said, KVM has
> > been injecting a #GP when it fails to map vmcb12 since the beginning.
>=20
> KVM has never been known for its attention to detail.

LOL, hey, we try.  Sometimes we just forget things though :-)

7a35e515a705 ("KVM: VMX: Properly handle kvm_read/write_guest_virt*() resul=
t")

> > It also does the same thing for VMSAVE/VMLOAD, which seems to also not
> > be architectural. This would be more annoying to handle correctly
> > because we'll need to copy all 1's to the relevant fields in vmcb12 or
> > vmcb01.
>=20
> Or just exit to userspace with
> KVM_EXIT_INTERNAL_ERROR/KVM_INTERNAL_ERROR_EMULATION. I think on the
> VMX side, this sort of thing goes through kvm_handle_memory_failure().

Yep, I think this is the correct fixup:

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index b191c6cab57d..78a542c6ddf1 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -1105,10 +1105,8 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
=20
        vmcb12_gpa =3D svm->vmcb->save.rax;
        err =3D nested_svm_copy_vmcb12_to_cache(vcpu, vmcb12_gpa);
-       if (err =3D=3D -EFAULT) {
-               kvm_inject_gp(vcpu, 0);
-               return 1;
-       }
+       if (err =3D=3D -EFAULT)
+               return kvm_handle_memory_failure(vcpu, X86EMUL_UNHANDLEABLE=
, NULL);
=20
        /*
         * Advance RIP if #GP or #UD are not injected, but otherwise stop i=
f

