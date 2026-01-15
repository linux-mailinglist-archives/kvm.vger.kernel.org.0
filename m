Return-Path: <kvm+bounces-68141-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0013BD22035
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 02:25:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A13A9308E632
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 01:22:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7033D246778;
	Thu, 15 Jan 2026 01:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cUTkv3or"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA6D9223702
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 01:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768440153; cv=pass; b=drxFcWRSsPnayKSxg/jOmtfbn1UeoeA1HaWIfOYVVER+KLJRPst+lL1EZUwQgFxPaDO4ZVnTTJ244jr1yBpaSYixWP9QoWd5BfeeBbes+K89N1KUjEfYbZ/IJY78klDOKaREvbflyv/26MZvcNddNb/EbPp0RszCSuRgsRBkAN0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768440153; c=relaxed/simple;
	bh=Bnim1PgEw5wqREk32FnL86aokygw8Ib577rInchTGa0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fHIGqNcHGGOYMVTjSErrRe9ysOkLkFpJTMpTjh0wO9DxVP4S0/mNuNOjqfhLjJL4yq59ZyzRWo2tKh7ftespwvk2RESmDkQq1Gf/oTD5mLciSzaXSUe0ywtXNOLT9DHJTRhHKi4EXq8KhERe8uc+FJLaBYMP5rFOekmA5zAF1no=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cUTkv3or; arc=pass smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-50299648ae9so34951cf.1
        for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 17:22:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768440151; cv=none;
        d=google.com; s=arc-20240605;
        b=eKEz8j2uLke2Kr8GfJBw2KAN9XqvqXT31zjz899sm914nifNYVnkBMhPvcuki9ZaL8
         10Nt+u1rNHZStKfY2rpuMfEV4W8NbdggNyyRBk2KDdFk1pWDVEX/ZDKl66NcVE/qXvj6
         owQSLGKFxYcRFtWrZGhbyVc+ItfirlPS41EaUhygkUOWxylAzQaumteEyy/qM9OVeA0L
         tkMq1sPC757VW8q+sP3/sek0eDNmYF3E7ixGA3Q5/rFGVS8LfLaXGr7x70wEtXESMH2r
         Pm4oOxJb/60iS1AdzFqg6SzLJ7Z5x6Qg2NHlRgmT3wGYUNYIKbYHfyjg/eaYTQhMIhV4
         wuFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sFi2PWseoVJquVrwoMhwmvEVm3PHBthNk0di0Pcowfg=;
        fh=+cG7iOsrlPOB+lYbPERIhTj49DzgzguSqKSL4Dx+St8=;
        b=WDLcUcsUMR1113QLgbM1gfjt3H2nfuGk6W1Ez9e4nVfAc0B8LZKhC1rHEJNFBnNeLk
         84sJ7gWU/JPg9BcYdS3bKvZGxcS5tuHU10a2VH6S8y8A0BYZck6HWNhISrOlIIPzSTh3
         93uCKkMzM5ChaphaQTkHw2EAeJg/ZGUFMoo+jnb4xvFM1Uhfv9XCdAcCzLZjfqZjz+Wq
         9X1M/WwZzbUryh1tp8eyEi+BTrdaKcumy234ewuRPCNrtazqWRwayQK4wNi+zD5fnos2
         1CRVoG1KD43rA2S1AWOsh+1RTnZvqM2QLh41P4LkBbxSv5KmZaZk0IAi/0vUXbclGHpZ
         AJTQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768440151; x=1769044951; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sFi2PWseoVJquVrwoMhwmvEVm3PHBthNk0di0Pcowfg=;
        b=cUTkv3or6c5A2HA6111vTg7+O1gq6dO9KUd44awwDVnFPMP9gGKZAk73dmFbssE/ik
         Gi73UolmTpE3bipiXxxt9oKpQ0m3j+Mv4Ycgm6quj/emyaKIaxhNiJDdGx/ikckSPUh4
         6QdjGlk+GB9vXVwHP6Cm0J7q/X2TbXBArtWlbQK1gVOquJvU3KysFAUyPPjtEhskcYs3
         31MYbu0dJjBBKT/j2ucPgwEiPfIx6fvpE+PvjpwcVwWY+/SH893BI21o5BZno2FXfWvF
         8lJPXCnviTJ5etDSN7KK5md3N4zmOuaviYFvCwKiIMdWqchx4Tx8wJMbt187A07kWVh8
         rIKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768440151; x=1769044951;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sFi2PWseoVJquVrwoMhwmvEVm3PHBthNk0di0Pcowfg=;
        b=NXOoJ/iDrTcpH53oHiCavPGuctgGLkr55tLS64wAkkkyFEjD09o2oNNM3N/IC/sO/V
         NWjP072V0t6aPjRztwas8Zn5OQ3tf8DHQBBOE0OpaKc0DfQr3I4x+xljZqKZN2MhwFo1
         SPb6GEvoCuykClo79kpVfaU4viuQtPenySHetExgOy0xAYa7Co6cwmDstAk3zIleWVUX
         g0802A+/qegbbWT6JSxqJacIijaxuvm84UAoPgm8ETW3r/eRkjVCySfhhgNtXj6BRoxn
         yqBo/uP+RH3uW83R5IkxB9/ACtg1vMxhABE6QOG9v6Fkajtkp75yu1oCSgWsT2Z90boh
         YTqQ==
X-Forwarded-Encrypted: i=1; AJvYcCWx0q44qSdAYHWOBnoaH5lr5L/idocFxDzSsLNFT9exVmX2xB821N7HKJ3tFoQ58O9uqB0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9FrcsSlXhRD3tKJuZRm7YQ7f17+3RokwAnkh1AsVIqH3v/SpH
	Se7S+vSGSYElJdxHpxiUygAVBBh6WMAjUCuE+JD3vHYYKq7KHI9ZJAi1avGxEAnBhr+bAOBTdYa
	nvHjKowQKOGGZgD6Ctktue+opZdQSt/RJxVHoozF6
X-Gm-Gg: AY/fxX7a4YRzQIqWUODdvirqoYSwS6PRCniDu6IaiJx2E3rh8tylgg+sShphktmkxYP
	4ztEUZGreW9FsLVHUAeITmYX6Tf49bVpTb216FAidXqN00VPFtoG7mLLzoiTLpq04xFziAZA+IQ
	cRbyRpZh7zXZZjbMDux/rRqxt3xYpV4u7LhqGelxnJEvynk/l9gi+6IXNFFWl6LTjIj/w70N2vX
	19plTOd0KX/yF0JbLcQ6LeOwJU0Vqen25ad7iZnBIYR944UPyph0YqY0S1wDp19nrSiY13v7H6k
	PUWXosSZASlmU8wJuF7a4LPh8Vk=
X-Received: by 2002:a05:622a:10b:b0:4ff:c109:6a4 with SMTP id
 d75a77b69052e-501debdf6bemr5297681cf.4.1768440150607; Wed, 14 Jan 2026
 17:22:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260114003015.1386066-1-sagis@google.com> <43a0558a-4cca-4d9c-97dc-ffd085186fd9@intel.com>
 <aWe8zESCJ0ZeAOT3@google.com> <aWgPFQOQRr3xcMjh@google.com>
In-Reply-To: <aWgPFQOQRr3xcMjh@google.com>
From: Sagi Shahar <sagis@google.com>
Date: Wed, 14 Jan 2026 19:22:19 -0600
X-Gm-Features: AZwV_QiJtsMlwE9fwof0hDggEeZkKPE35Uk4FvzQENJq3Az30USGqu48l1mKWN8
Message-ID: <CAAhR5DHN+MTXX8v6LMWsQzKfpRefFwNO62hH+4iKiMpaSKiYvQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: TDX: Allow userspace to return errors to guest for MAPGPA
To: Sean Christopherson <seanjc@google.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Thomas Gleixner <tglx@kernel.org>, 
	Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	Vishal Annapurve <vannapurve@google.com>, Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 14, 2026 at 3:48=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> +Mike
>
> On Wed, Jan 14, 2026, Sean Christopherson wrote:
> > On Wed, Jan 14, 2026, Xiaoyao Li wrote:
> > > On 1/14/2026 8:30 AM, Sagi Shahar wrote:
> > > So it needs to be
> > >
> > >     if (vcpu->run->hypercall.ret =3D=3D -EBUSY)
> > >             tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_RETRY);
> > >     else
> > >             tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OP=
ERAND);
> >
> > No, because assuming everything except -EBUSY translates to
> > TDVMCALL_STATUS_INVALID_OPERAND paints KVM back into the same corner it=
s already
> > in.  What I care most about is eliminating KVM's assumption that a non-=
zero
> > hypercall.ret means TDVMCALL_STATUS_INVALID_OPERAND.
> >
> > For the new ABI, I see two options:
> >
> >  1. Translate -errno as done in this patch.
> >  2. Propagate hypercall.ret directly to the TDVMCALL return code, i.e. =
let
> >     userspace set any return code it wants.
> >
> > #1 has the downside of needing KVM changes and new uAPI every time a ne=
w return
> > code is supported.
> >
> > #2 has the downside of preventing KVM from establishing its own ABI aro=
und the
> > return code, and making the return code vendor specific.  E.g. if KVM e=
ver wanted
> > to do something in response to -EBUSY beyond propagating the error to t=
he guest,
> > then we can't reasonably do that with #2.
> >
> > Whatever we do, I want to change snp_complete_psc_msr() and snp_complet=
e_one_psc()
> > in the same patch, so that whatever ABI we establish is common to TDX a=
nd SNP.
> >
> > See also https://lore.kernel.org/all/Zn8YM-s0TRUk-6T-@google.com.
>
> Aha!  Finally.  I *knew* we had discussed this more recently.  The SNP se=
ries to
> add KVM_EXIT_SNP_REQ_CERTS uses a similar pattern.  Note its intentional =
use of
> positive values, because that's what userspace sees in errno.  This code =
should
> do the same.  Oh, and we need to choose between EAGAIN and EBUSY...
>
>         switch (READ_ONCE(vcpu->run->snp_req_certs.ret)) {
>         case 0:
>                 return snp_handle_guest_req(svm, control->exit_info_1,
>                                             control->exit_info_2);
>         case ENOSPC:
>                 vcpu->arch.regs[VCPU_REGS_RBX] =3D vcpu->run->snp_req_cer=
ts.npages;
>                 return snp_req_certs_err(svm, SNP_GUEST_VMM_ERR_INVALID_L=
EN);
>         case EAGAIN:
>                 return snp_req_certs_err(svm, SNP_GUEST_VMM_ERR_BUSY);
>         case EIO:
>                 return snp_req_certs_err(svm, SNP_GUEST_VMM_ERR_GENERIC);
>         default:
>                 break;
>         }
>

I think EAGAIN makes more sense semantically in this case. So
something like this?

-               tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPER=
AND);
+               if (vcpu->run->hypercall.ret =3D=3D EAGAIN)
+                       tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_RETR=
Y);
+               else if (vcpu->run->hypercall.ret =3D=3D EINVAL)
+                       tdvmcall_set_return_code(vcpu,
TDVMCALL_STATUS_INVALID_OPERAND);
+               else
+                       return -EINVAL;
+

>
> https://lore.kernel.org/all/20260109231732.1160759-2-michael.roth@amd.com

