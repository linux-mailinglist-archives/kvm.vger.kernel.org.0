Return-Path: <kvm+bounces-68138-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 94E28D2201D
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 02:23:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 375CE3040A79
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 01:21:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6523D248880;
	Thu, 15 Jan 2026 01:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oTSX+LgG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6AF67081A
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 01:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768440076; cv=pass; b=Qwrsv+NhBL62mMq6udfqYZm0G/Z3LdY8G3k2jlgUdSsE921Iyr5nwpTqFwZGNr6USeRBvA4dbwRBZ9SrRoJGrT+6MIBljLmYBv6vTKudejFLx6vosZevEgLxe82N8Ea9iA1URxjBwe6zWXBiUVvL4cfw7IwDgS6D8GCubAHZAnI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768440076; c=relaxed/simple;
	bh=9Vx4Yf9QlwPgcHE+BnyuwDRF989+DVeuIOgw7vMjjwc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c9BblV0cQXvwkZYdXSNUr49b96ZBlH8wrQO8mrPic/WpvNB3/TtJag55opB+B+xq1MCqKlHsMrFzrtGoG9MDX+Q82agjF6CKSOYZAmzFu7DRx4Kr8R6k5Gag5nVW+ISa4MeyzOWz08h/JqP9ABXsPFKSNekk395hd2x4nGMnpsk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oTSX+LgG; arc=pass smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-50299648ae9so34641cf.1
        for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 17:21:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768440073; cv=none;
        d=google.com; s=arc-20240605;
        b=SEHpeAI7xWixNKBLfKwpxaMMKuC4Cgul/bqdK95D6CPI/lxD9gNg02D387x4dr5TBV
         wf0yVb93actqvUMmFRuj/y9lU5MItpDVex9N3OZhd0Gnt1hxI137+wT/aSy9Is4fpWmu
         Nyc23yWB4rA1pC81I/RiacggwbgyU9TnYd/G1uNTLUsVpcZTyTqWuPSfKyc6HiLhrtqm
         V9CAQqsxrunDBiyC/X/jJE9Z03rkJQtCq2+txxzQFqdqQohLsG78lfW3/LusuhmArv71
         rE+Ebn/v+RbOKwW5NwqDZyu/sgpElV/PT7d4K/dUqFQ7sPEVKmBqqwJxq380SGVjAma3
         48wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=elZ+7z9St5n4o5etqR0ku5zcMBWid3JlUNNzB3S48Ko=;
        fh=ISHs9O8VlxMRGkCMCta8BxBZp25Jl5KVUSRmCe5Tk+U=;
        b=AsDBFxZFoj3bYt2Lq/RdvsZj3TKMdOmxEFl/bNak7LKsY7/lNOgNMrRzoNm/d7it5v
         NbNGBdhZiFjGqfOL2PGKpCTZEcAZy0jkyPQCsy0swnqQyiaLkbjWunhRGKIYaUTbOmhx
         Syj0DBd2cjZ5cJVboAUKQj5w3mhLDzFHAHHftbOEiB83csszOth5Vf8JSU1NFlQAXnkg
         44t+qUYhtUnfmRfRxSqQ5qSh5XdU2nhsTCYhpOmelXaBw9w74FwAfqMKvSZ4Z9bSoNbJ
         I4O3YhiG9nNOLrySADRdAtFfauA6KZVubD0piuc4/NVY2cxa3/RxY9l2W6yGo3TOJm6g
         N8+A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768440073; x=1769044873; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=elZ+7z9St5n4o5etqR0ku5zcMBWid3JlUNNzB3S48Ko=;
        b=oTSX+LgGoOE0/rdwRIVRyz0plETllK/++2mCk0khS/Ksn5yu1EGpCG0NyGISo9mAis
         dtknyFbox4/8CtD61WXkWbf9WpCDzCZjJZm11RDTVoKUrLZ4vk8lHjs99WFQcg5k0nHj
         DzJvEccC0SEU28JhVEufbQ8+tosPFOdrWV9Kcg1Ev5XtLgK4khu2+SuGhFMiYBivMo5h
         7E5bNQe72uHR3+iJhnNigC9DlJnfL+q40PdM/eHmBrlr4Dt6o2XBvz21nHOShC1cSLQU
         BUxuVKFP0x8yP6yyS3BSYQ7Cuk4VDUmzg6gYmTb4AGewzBHobXsjgDATr0La6giFCKMr
         O4Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768440073; x=1769044873;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=elZ+7z9St5n4o5etqR0ku5zcMBWid3JlUNNzB3S48Ko=;
        b=D6tmCCeVd51q6ear+QomjEuRN0rRw0YD7i53x84QovEJtXMG6ux538pxFkljGrnmLr
         gqLqSGDb3X6M2C7Tw99DcmGJaiHlsaEdJVejDctpYIzBi+ZRUXuO5qo8q84aAWnuwyzr
         m24jwIeiYTfWzOE2ofx3z7wCElp6rYWLF7mm0SuteTVORdacBVCEgCwY8tNMTtaOAONC
         28OGRsHh8+T63aFGTj354vUbG6pQHFh67ZRhq4ptoW5j7x9lq/IoHOVMu0bN9Bgp6UDq
         eJUOSNhc1PVvWjf7HgkqW9kzJCJty18XnEmZnvwSVWgsCtWAZfKsfJqyo3yU40APYxXG
         7TXg==
X-Forwarded-Encrypted: i=1; AJvYcCVbbFEhWxDwjwXOeheA/qIeLfczpFC4lopiVqv22yfObBwqX5uthP59j6G0QYOvNem5Iao=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxu833Yf/05zcqPILMLHfdFDLVmSiW6fZMKUW6Dhip9E/dARSKP
	reS3QZCodN44cKw/80LkCzAwSTEpa+Je+KPgRUtdlzxonDFMMyt3YwdH9LAj2AxogSFlm+hjqID
	2PyGnc6rBqni+MmaWu9QCU4jWWPRwPu/h21/40iAp
X-Gm-Gg: AY/fxX76WFFobngyvoJxs+xSOfAKPeuuugBHrKGvGK4FJ9cdfi8RZHgqQ9src5MgyUr
	p6PMdtqlVddISFmlHwOTrnIY606JMD26LPlhr/X8uqh83SJeh8q5kSe0rviZzrW8UjTp9eEARWi
	85dhC71LdpAEuJs9RMhkFDXeo4RJaUQAXIqCihvoUR8R8j7+M0Sg0GKKL1x7JuoVon909WQMcRj
	GqkI/G1YeAEroRqustVK5n8oVOJG2AVmQuIlSgW1zwG2QvJKzAGcAtjAUpOBz3mC5kaMtvsvkdQ
	SmRW024fsr7IWVZ0jvtJnceHZZ4=
X-Received: by 2002:a05:622a:120d:b0:4f3:54eb:f26e with SMTP id
 d75a77b69052e-5026ecd7aeamr2823351cf.1.1768440072287; Wed, 14 Jan 2026
 17:21:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260114003015.1386066-1-sagis@google.com> <43a0558a-4cca-4d9c-97dc-ffd085186fd9@intel.com>
 <aWe8zESCJ0ZeAOT3@google.com>
In-Reply-To: <aWe8zESCJ0ZeAOT3@google.com>
From: Sagi Shahar <sagis@google.com>
Date: Wed, 14 Jan 2026 19:21:01 -0600
X-Gm-Features: AZwV_QjdTQ51NiLFDHGPdrtD9_djmbDXN-sHxsuLIZzWSLHmOkAx6u9yZZZenTo
Message-ID: <CAAhR5DE=ypkYwqEGEJBZs5A2N9OCVaL_9Jxi5YN5X7rNpKSZTw@mail.gmail.com>
Subject: Re: [PATCH] KVM: TDX: Allow userspace to return errors to guest for MAPGPA
To: Sean Christopherson <seanjc@google.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Thomas Gleixner <tglx@kernel.org>, 
	Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	Vishal Annapurve <vannapurve@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 14, 2026 at 9:57=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Wed, Jan 14, 2026, Xiaoyao Li wrote:
> > On 1/14/2026 8:30 AM, Sagi Shahar wrote:
> > > From: Vishal Annapurve <vannapurve@google.com>
> > >
> > > MAPGPA request from TDX VMs gets split into chunks by KVM using a loo=
p
> > > of userspace exits until the complete range is handled.
> > >
> > > In some cases userspace VMM might decide to break the MAPGPA operatio=
n
> > > and continue it later. For example: in the case of intrahost migratio=
n
> > > userspace might decide to continue the MAPGPA operation after the
> > > migrration is completed
>
> migration
>
> > > Allow userspace to signal to TDX guests that the MAPGPA operation sho=
uld
> > > be retried the next time the guest is scheduled.
>
> To Xiaoyao's point, changes like this either need new uAPI, or a detailed
> explanation in the changelog of why such uAPI isn't deemed necessary.
>
> > > Signed-off-by: Vishal Annapurve <vannapurve@google.com>
> > > Co-developed-by: Sagi Shahar <sagis@google.com>
> > > Signed-off-by: Sagi Shahar <sagis@google.com>
> > > ---
> > >   arch/x86/kvm/vmx/tdx.c | 8 +++++++-
> > >   1 file changed, 7 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > > index 2d7a4d52ccfb..3244064b1a04 100644
> > > --- a/arch/x86/kvm/vmx/tdx.c
> > > +++ b/arch/x86/kvm/vmx/tdx.c
> > > @@ -1189,7 +1189,13 @@ static int tdx_complete_vmcall_map_gpa(struct =
kvm_vcpu *vcpu)
> > >     struct vcpu_tdx *tdx =3D to_tdx(vcpu);
> > >     if (vcpu->run->hypercall.ret) {
> > > -           tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OP=
ERAND);
> > > +           if (vcpu->run->hypercall.ret =3D=3D -EBUSY)
> > > +                   tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_RE=
TRY);
> > > +           else if (vcpu->run->hypercall.ret =3D=3D -EINVAL)
> > > +                   tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_IN=
VALID_OPERAND);
> > > +           else
> > > +                   return -EINVAL;
> >
> > It's incorrect to return -EINVAL here.
>
> It's not incorrect, just potentially a breaking change.
>
> > The -EINVAL will eventually be
> > returned to userspace for the VCPU_RUN ioctl. It certainly breaks users=
pace.
>
> It _might_ break userspace.  It certainly changes KVM's ABI, but if no us=
erspace
> actually utilizes the existing ABI, then userspace hasn't been broken.
>
> And unless I'm missing something, QEMU _still_ doesn't set hypercall.ret.=
  E.g.
> see this code in __tdx_map_gpa().
>
>         /*
>          * In principle this should have been -KVM_ENOSYS, but userspace =
(QEMU <=3D9.2)
>          * assumed that vcpu->run->hypercall.ret is never changed by KVM =
and thus that
>          * it was always zero on KVM_EXIT_HYPERCALL.  Since KVM is now ov=
erwriting
>          * vcpu->run->hypercall.ret, ensuring that it is zero to not brea=
k QEMU.
>          */
>         tdx->vcpu.run->hypercall.ret =3D 0;
>
> AFAICT, QEMU kills the VM if anything goes wrong.
>
> So while I initially had the exact same reaction of "this is a breaking c=
hange
> and needs to be opt-in", we might actually be able to get away with just =
making
> the change (assuming no other VMMs care, or are willing to change themsel=
ves).

Is there a better source of truth for whether QEMU uses hypercall.ret
or just point to this comment in the commit message.

>
> > So it needs to be
> >
> >       if (vcpu->run->hypercall.ret =3D=3D -EBUSY)
> >               tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_RETRY);
> >       else
> >               tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OP=
ERAND);
>
> No, because assuming everything except -EBUSY translates to
> TDVMCALL_STATUS_INVALID_OPERAND paints KVM back into the same corner its =
already
> in.  What I care most about is eliminating KVM's assumption that a non-ze=
ro
> hypercall.ret means TDVMCALL_STATUS_INVALID_OPERAND.
>
> For the new ABI, I see two options:
>
>  1. Translate -errno as done in this patch.
>  2. Propagate hypercall.ret directly to the TDVMCALL return code, i.e. le=
t
>     userspace set any return code it wants.
>
> #1 has the downside of needing KVM changes and new uAPI every time a new =
return
> code is supported.
>
> #2 has the downside of preventing KVM from establishing its own ABI aroun=
d the
> return code, and making the return code vendor specific.  E.g. if KVM eve=
r wanted
> to do something in response to -EBUSY beyond propagating the error to the=
 guest,
> then we can't reasonably do that with #2.
>
> Whatever we do, I want to change snp_complete_psc_msr() and snp_complete_=
one_psc()
> in the same patch, so that whatever ABI we establish is common to TDX and=
 SNP.
>
> See also https://lore.kernel.org/all/Zn8YM-s0TRUk-6T-@google.com.
>
> > But I'm not sure if such change breaks the userspace ABI that if needs =
to be
> > opted-in.

