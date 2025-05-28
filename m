Return-Path: <kvm+bounces-47905-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CDE4DAC70E3
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 20:25:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 76AC31C0131A
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 18:26:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B272A217F35;
	Wed, 28 May 2025 18:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gSb6Q8lw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1863B28E573
	for <kvm@vger.kernel.org>; Wed, 28 May 2025 18:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748456739; cv=none; b=JruIAv0AtBDqLyLS0gpf3uOkRmCJuoqbIC2I1VrQGPGLCBMS52MUJFhrdkX+fPGwMAS/T7ynam7slZFJgSfE56rfaZoCzCXqhW9oIn1MwgywghOlSk3noCclv3pgZ45ntzbuTBd8R6SpVyv6zk7t0n/3UpfKle8647uqdaHBOM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748456739; c=relaxed/simple;
	bh=TrwTeeb3eSq6peBGpyS2fjLOHTgsDFfooNNEDI35gec=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RN3RZG7+piJM5dG9wN0A+YgJ40OdSAVwjb4ssqW9x/XGuucu7unssZi13l+OhJiqtcVcIywkWsWkrvVeMMMOtU1HsqX9bafoR19/Jn/daJRO7VrVPjJ0XHbGB87HqHL0b0ghWs/cw5Pg5lQ27q9roZz9uOUGr5HAiAiNvIru7jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gSb6Q8lw; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-b0db0b6a677so121328a12.2
        for <kvm@vger.kernel.org>; Wed, 28 May 2025 11:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748456737; x=1749061537; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lVVqFr1BE8q6eml8zA1z0lK7aGNcSUfClXnZn98OgHk=;
        b=gSb6Q8lw7pXUBBIqXjElAS7OXbzu82FDWVRV3vh6FJWCWMqO45j0aiu9z7xaVFKrPr
         K9mfYHPbGDYrShdyVXl2hTdJQIw5THDggbaiK8U1FREaSToTACTR4Swjbps8QxZgW854
         cO/+7Q2Cevo+4StQO+zeeSq6RuILwl7zKGk3DBm7ng4mwaSGOf14GX6vvjzfPo+NiJ7w
         qgxL253czsdTsjp6p36f13uW0ojgCeGPSwztettCeRJSPzT97SWTp++FwuL6CAyS9zyV
         7Py6Y09VAIQpiNsze0f8IS7B1D+JR76kAbe6GE6CiTMlZq4gLCqqHhObh9pqjwamfjXW
         Svag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748456737; x=1749061537;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lVVqFr1BE8q6eml8zA1z0lK7aGNcSUfClXnZn98OgHk=;
        b=Z8rKQjctSyrnZxSnPFoo/G173q0aj0gWomTnKDsZfmrJrnnWNkrhNankBOGV2ZZwGQ
         oq5CsIjuPnP88mY3sUz5/vVIN3YZK1bZS6SxRDzj55+LSMnLjfgutkk8Ex5TCGPelg+i
         O2THXYQ/JmSEQPm9ItJ0AyVKD6XghAv41KtdAhylw/VX7INt1V8YVAdTnph/XiEvl9OL
         OZQ5kSeyKrgvOrvk/Ey1qpN5UuLKzwoXwidhS/Npyeu0drGcMdCrqN0HK0J8VkbI0jZg
         ROPQiU0RDVbsjU0c75/385W5Y9+vr8j4I+rAL5p5YraB22wjBQmZdZMr0MlTwKQCZzFw
         +t2A==
X-Gm-Message-State: AOJu0YzarBvIlxiR/zrEfiTfqHqNueTcJhTQ67FyGbzpRPT0x1jthxMV
	vnFRWcDaKDYnlBFuqn1VXf4JuJrNWqIfeXYZ6FbKyRkE1sz9w9naSji8hnbUo1ljgOlPoGsSB3l
	rolnBNmevblCVKoz3Pfml6+n82GZT7PPhyj3gZ+lY
X-Gm-Gg: ASbGncvEFuTsp0BvCeuGWIwK63P8vvhnm/k/6XJCmFlkB3EPQkphKkH8xGgYkTfM/4V
	hqYGubEiMnlllyD/rMGjOtwuV4WzMRExWdZsrHgz88yry/HW0yTtwqVQr2Rl3Y1AbUDCOgHfM5n
	K/rEPYKhPZLPRtrNfDCOhyHyq03CleZFvuY1Ty56etoLibIWiAXv7v1qCWIBAAdU6cDGuJqgf1N
	A==
X-Google-Smtp-Source: AGHT+IFijwOh+awYdgO4HAk/X8m/A4OWZUBHS7nOP52Vw8xKVE09sTMEC6FE21p5hEzwxtb4ty4X3loZKiHFU1jBNbA=
X-Received: by 2002:a17:90b:3852:b0:30e:8c5d:8ed with SMTP id
 98e67ed59e1d1-3110f31a4fbmr26532549a91.19.1748456737021; Wed, 28 May 2025
 11:25:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250515220400.1096945-1-dionnaglaze@google.com>
 <20250515220400.1096945-2-dionnaglaze@google.com> <aCZtdN0LhkRqm1Vn@google.com>
 <CAAH4kHai8JStj+=HUiPVxbH9P79GorviG2GykEP7jQ=NB2MbUQ@mail.gmail.com> <aC4ZJyRPpX6eLKsC@google.com>
In-Reply-To: <aC4ZJyRPpX6eLKsC@google.com>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Wed, 28 May 2025 11:25:23 -0700
X-Gm-Features: AX0GCFte05v61MvXwGYneIeTEvRS5b_Es3A7BflZae2g4_6rbG1Vveaf5-F60xY
Message-ID: <CAAH4kHZkuD4UsXRGED6qecfAkeFpd8sLc+0osDhnKP4T5VmSYQ@mail.gmail.com>
Subject: Re: [PATCH v5 1/2] kvm: sev: Add SEV-SNP guest request throttling
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-coco@lists.linux.dev, Thomas Lendacky <Thomas.Lendacky@amd.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <jroedel@suse.de>, Peter Gonda <pgonda@google.com>, 
	Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, May 21, 2025 at 11:19=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> On Fri, May 16, 2025, Dionna Amalie Glaze wrote:
> > > > @@ -4015,6 +4042,12 @@ static int snp_handle_guest_req(struct vcpu_=
svm *svm, gpa_t req_gpa, gpa_t resp_
> > > >
> > > >       mutex_lock(&sev->guest_req_mutex);
> > > >
> > > > +     if (!__ratelimit(&sev->snp_guest_msg_rs)) {
> > > > +             svm_vmgexit_no_action(svm, SNP_GUEST_ERR(SNP_GUEST_VM=
M_ERR_BUSY, 0));
> > > > +             ret =3D 1;
> > > > +             goto out_unlock;
> > >
> > > Can you (or anyone) explain what a well-behaved guest will do in in r=
esponse to
> > > BUSY?  And/or explain why KVM injecting an error into the guest is be=
tter than
> > > exiting to userspace.
> >
> > Ah, I missed this question. The guest is meant to back off and try agai=
n
> > after waiting a bit.  This is the behavior added in
> > https://lore.kernel.org/all/20230214164638.1189804-2-dionnaglaze@google=
.com/
>
> Nice, it's already landed and considered legal VMM behavior.
>
> > If KVM returns to userspace with an exit type that the guest request wa=
s
> > throttled, then what is user space supposed to do with that?
>
> The userspace exit doesn't have to notify userspace that the guest was th=
rottled,
> e.g. KVM could exit on _every_ request and let userspace do its own throt=
tling.
>
> I have no idea whether or not that's sane/useful, which is why I'm asking=
.  The
> cover letter, changelog, and documentation are all painfully sparse with =
respect
> to explaining why *this* uAPI is the right uAPI.
>
> > It could wait a bit before trying KVM_RUN again, but with the enlighten=
ed
> > method, the guest could at least work on other kernel tasks while it wa=
its
> > for its turn to get an attestation report.
>
> Nothing prevents KVM from providing userspace a way to communicate VMM_ER=
R_BUSY,
> e.g. as done for KVM_EXIT_SNP_REQ_CERTS:
>
> https://lore.kernel.org/all/20250428195113.392303-2-michael.roth@amd.com
>
> > Perhaps this is me not understanding the preferred KVM way of doing thi=
ngs.
>
> The only real preference at play is to not end up with uAPI and ABI that =
doesn't
> fit "everyone's" needs.  It's impossible to fully future-proof KVM's ABI,=
 but we
> can at least perform due diligence to ensure we didn't simply pick the th=
e path
> of least resistance.
>
> The bar gets lowered a tiny bit if we go with a module param (which I thi=
nk we
> should do), but I'd still like an explanation of why a fairly simple rate=
limiting
> mechanism is the best overall approach.

Before I send out a revised patchset with changed commit text, what do
you think about the following

    The AMD-SP is a precious resource that doesn't have a scheduler other
    than a mutex lock queue. To avoid customers from causing a DoS, a
    kernel module parameter for rate limiting guest requests is added.
[Addition:]
    The kernel module parameter is a lower bound kernel-imposed rate limit
    for any SEV-SNP VM-initiated guest request. This does not preclude the
    addition of a new KVM exit type for SEV-SNP guest requests for
    userspace to impose any additional throttling logic. The default value =
of
    0 maintains the previous behavior that there is no imposed rate limit o=
n
    guest requests.


We could still ask Michael to change KVM_EXIT_SNP_REQ_CERTS  to
KVM_EXIT_SNP_GUEST_REQ
and for the exit structure to include msg_type as well as the
gfn+npages when the kind is an extended request for an attestation
report so that we don't need to have two exit types.

Regardless of that change for additional throttling opportunities, I
think the system-wide imposed lower bound is important for quelling
noisy neighbors to some degree.


--=20
-Dionna Glaze, PhD, CISSP, CCSP (she/her)

