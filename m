Return-Path: <kvm+bounces-62237-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D503C3D13E
	for <lists+kvm@lfdr.de>; Thu, 06 Nov 2025 19:33:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 515924E37EB
	for <lists+kvm@lfdr.de>; Thu,  6 Nov 2025 18:33:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7910B350A16;
	Thu,  6 Nov 2025 18:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vyFqBeDD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5073F34DB65
	for <kvm@vger.kernel.org>; Thu,  6 Nov 2025 18:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762453975; cv=none; b=Y2Fvv73YP5FBP1mep2VN07BSU2SmjTD8e37XmlnosgwiOYpiHQDdAzFlmG0x6DW/XOwRir1U5JiK0yKPlkDdIBwvs3tKY8Rq94NTLNOtGFqtnMhmnaYo3nGayk/RHkjZ9tGYsOnz1uU9iE1aqR82sPSkc7ARNqnwAZ8wB6YfIGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762453975; c=relaxed/simple;
	bh=sVQLIpPNNK87Swax1RQ2kNXix0G9QJSkyvr+/9F+uA0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Z5TfGiyHJosoRwurYpG9hAJ0nEYNw76SkUFeTmTvDWZTL+tE8QDsAgcgJAEdq+l119LnpwonGANzjZpKA9qmqpJ82JRz2GafIwyHiMKW591F9B92lemktgwF7n5jqWM9Rn8lrV90tb2D1CQBPpgIpyrfFU6ga6k+oiR0a1cu230=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vyFqBeDD; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-29557f43d56so16455335ad.3
        for <kvm@vger.kernel.org>; Thu, 06 Nov 2025 10:32:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762453974; x=1763058774; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ILtqOILvGty/pMJ9/qXl6knV0E74S+U/rmoIpSy5GYU=;
        b=vyFqBeDDe69xCrA8XH6jbdMtDtWCDf6vNkTEWY19Sro76iSwUxBDs2bRsRyAT/R/kY
         gZUyzIdDt5+5xw0BFq3GnEeUNLJd1WnhF8ReURyyk2PQNwZBxbycAgSKONBFig6JnFp9
         MnhqKl/DsvFW7nXPatVqho34xK5gZ3tv+HvlNkNkCoymgUHAUrQYtnhfVeL2dtoEiNgn
         oDJZ1MHgcioTotR1DaKg2xzNLqsF40b0g+9oTt8jfLkQcapgdX0usblqwgoIhxXgJtjO
         WXuPVe2nxEjQKYhzqVrOOj/rWXdWavAXEPX8gvAF+D1KrdLxq6o16GA+gMqOXKSPYe0g
         978g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762453974; x=1763058774;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ILtqOILvGty/pMJ9/qXl6knV0E74S+U/rmoIpSy5GYU=;
        b=QqhBCYEQUnCYV1/LLHUbfJElh/kpvWTzOcqMHIkhkfca3sM/6wdBCShuGztJSO1vQu
         HyDue7C7YMG3YTdQ07gNKyJrfM9i4kxhCnFNBYCcBu9O7a9oCkj0+zFPv54oJvasOEHh
         jr18ipGaHvTlZ6p21FKrlsM0haYTAKZAfSbxuxKnigbS0NRy6ffGdg8zUpSl0LKb3vgB
         jVPVjwIiRxwzahgAPJZ0+vqPiX+QlosHVPZ2/0hbeQ20mIEr37Zqp149bHjYevYxB8Sr
         JmFWaTX4+igOpH3tLgIxu47BHrhCEBCmUCe52pPR6A086wQKBZUdp2I4mrG1qDAG1JAE
         uFVA==
X-Forwarded-Encrypted: i=1; AJvYcCX1Sbbpnle6SAcOD4oRHecNUNm5Ganv1W0u39yXxFm+3KiLQRbZ4KP05x3q6nMK/hjF3Yg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxO0ml5/2vm0qRYnSQpaav6M83qwy2mexkS0COhLmfcNa+RMufd
	kfVev5OmiOerwzBSWLgsvd6wu/zMUyLeckCYXNnjDHLPtmeepwHf9e84eNyVTn0sNihfAgzflaG
	gT38+kg==
X-Google-Smtp-Source: AGHT+IHxhdirp/8jMYvdEMpulJuVcQ8tfoz/G82tmND5n6uBXi9xqwvXWzZIhBm3NMCpdYEMxyVrG89AQwM=
X-Received: from plbm10.prod.google.com ([2002:a17:902:d18a:b0:267:dbc3:f98d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:b10:b0:295:a1a5:bb0f
 with SMTP id d9443c01a7336-297c03a8e41mr6156695ad.18.1762453973700; Thu, 06
 Nov 2025 10:32:53 -0800 (PST)
Date: Thu, 6 Nov 2025 10:32:52 -0800
In-Reply-To: <CAFULd4Z=PKeyzaER51CE7Zm4a-yeiru=HcBFx8E4J5hx3io=Tw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251106011330.75571-1-seanjc@google.com> <CAFULd4Z=PKeyzaER51CE7Zm4a-yeiru=HcBFx8E4J5hx3io=Tw@mail.gmail.com>
Message-ID: <aQzp1I1D8CfUSEug@google.com>
Subject: Re: [PATCH] KVM: SVM: Ensure SPEC_CTRL[63:32] is context switched
 between guest and host
From: Sean Christopherson <seanjc@google.com>
To: Uros Bizjak <ubizjak@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 06, 2025, Uros Bizjak wrote:
> On Thu, Nov 6, 2025 at 2:13=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
> >  998:
> > -
> >         /* Now restore the host value of the MSR if different from the =
guest's.  */
> > -       movl PER_CPU_VAR(x86_spec_ctrl_current), %eax
> > -       cmp SVM_spec_ctrl(%_ASM_DI), %eax
> > +#ifdef CONFIG_X86_64
> > +       mov SVM_spec_ctrl(%rdi), %rdx
> > +       cmp PER_CPU_VAR(x86_spec_ctrl_current), %rdx
> >         je 901b
> > -       xor %edx, %edx
> > +       mov PER_CPU_VAR(x86_spec_ctrl_current), %rdx
> > +       movl %edx, %eax
> > +       shr $32, %rdx
>=20
> The above code can be written as:
>=20
> mov PER_CPU_VAR(x86_spec_ctrl_current), %rdx
> cmp SVM_spec_ctrl(%rdi), %rdx

Gah, that's obvious in hindsight.

> je 901b
> movl %edx, %eax
> shr $32, %rdx
>=20
> The improved code will save a memory read from x86_spec_ctrl_current.
>=20
> > +#else
> > +       mov SVM_spec_ctrl(%edi), %esi
> > +       mov PER_CPU_VAR(x86_spec_ctrl_current), %eax
>=20
> Can the above two instructions be swapped, just to be consistent with
> x86_64 code?
>=20
> > +       xor %eax, %esi
>=20
> > +       mov SVM_spec_ctrl + 4(%edi), %edi
> > +       mov PER_CPU_VAR(x86_spec_ctrl_current + 4), %edx
>=20
> ... and the above two insns.

Ya, will do.  Thanks!

