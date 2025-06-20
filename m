Return-Path: <kvm+bounces-50099-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 99C4AAE1D99
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 16:39:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A1CB87AAFC6
	for <lists+kvm@lfdr.de>; Fri, 20 Jun 2025 14:38:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51A0D28FAA5;
	Fri, 20 Jun 2025 14:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="prQ6WZeM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3E22951D5
	for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 14:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750430360; cv=none; b=U6rk2/n7PY5lI0E2dVlWlscsoJTqIEoGaI+c9U+ZRuJinfG/I/5Rikb8dh872DqRgmmGk8E0CwUCwPTh3ti+oVGV4icgXfxkjIvPVGkH6RSRJ5w0rUwJ5797SVC/qm5kHPA4efBhArMzm41VPGpbR1EHWFXpZ95f5cYJUK5TYvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750430360; c=relaxed/simple;
	bh=f0ERDdgXgTFaM2bAnZ1S200y/0WNSgNRatRYt7yg6uI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dcOO5pSRpOun7Dg+KQ2y3Ddsnx4y3qo7z3uPcaB70nJGgSU7fVPUeMN3PkSrp63EiWUpPQbOf8k27yLrIJXV40FopInfCv0/DAAZ6VlWomedpv8rs505dDP6Fm8vFYoB+lKCaoxEr0x6ceI9/j25RDLLJELXBAkGLLesqhG3MeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=prQ6WZeM; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3138c50d2a0so2643109a91.2
        for <kvm@vger.kernel.org>; Fri, 20 Jun 2025 07:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750430358; x=1751035158; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9hYeG/lN/dobWu+WOAuHe6WhQ/AJqqM1f1NumulS6iw=;
        b=prQ6WZeM43BAwpR9FC90IHzjncCnp6YhwukGsupN30bc+kL1HWYuCbMQM3a1oqsaN5
         z11t9avcrlAINPKbWyeZi8HosYfkJnskirPNingt5EAbMnk5OdCQvoY8H6OtvYJrM+N5
         HsReVGPJzD7fSRzB+/F5gCI6x0QUV4SOL1vaC/vwEMU23TbOzgNLOwtkU8VwnKmAYIxv
         ibqbooNpJBa3MzsF5HL7Ie0IzdH/cyjYSBlPopVArDP/QM1tmsyyrvxZaxuvLnoN+FYT
         2g1iRK/D3+75Z5BaH9O0386RwYVnT7RaAap7KTG+5MMpcG3LBB7N4WPm1qoOjwPKUJx3
         NY9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750430358; x=1751035158;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9hYeG/lN/dobWu+WOAuHe6WhQ/AJqqM1f1NumulS6iw=;
        b=mFw80YTEXBPWJpNreViYBqnwDASJ9eVX8193pKhhAuyLWYHJpU8BCBTpcDDnAJ3Sou
         wO3F1qr5CqzbVci1seenLt2bpItyVhz9xwpYChOqclkmQD2Smq5wIKpQBMOdQYKcKFSA
         4trTfzaKuo6hLbFt7FiTOauqOaH0jSMbYo2NnJxXOXjnrHuQ2oOzuRO5rhkaPGJiD02K
         f0m1uHqhd5Z/UpP7XNae2JuWZO/Bzu4cL2uNGXnIjoNWDpV8aTvt1nUioOK4eEh5itRF
         vN+fzdjdxDWX9LBYmzUFyL3VFR3/di0FRYTwJFVNGkdpeJZNJgMbN0noSlmFqfNsCyIu
         Llfw==
X-Forwarded-Encrypted: i=1; AJvYcCVBtONyTsgu0UaboHqwNC1GnqjlG/CHGM7NVW+p1hFOnB3IiV02GwFK/EL9NHNGozG/5m4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6dPpaNRrMRGpMRK4xqnnkJGoruz9NQbTPfMkOKHZ08L6TiQwD
	J3EGlGKmT+Xcveca2xE26dj6l2+0wVl0aEYaX5M0Ym4cgYw0DKuZodPofx0WnFfQcEfp9bOb4Ac
	ZI1g3Xw==
X-Google-Smtp-Source: AGHT+IEu/kAyF65SAfQsKleZ41Vg0owDojNFVAMM/0F6gElDwFbB1sj7AbPvBVKqQ3YY8zBgnoMiSm1QDmM=
X-Received: from pjbee15.prod.google.com ([2002:a17:90a:fc4f:b0:314:d44:4108])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2e87:b0:312:51a9:5d44
 with SMTP id 98e67ed59e1d1-3159d61a5c5mr5175181a91.5.1750430358355; Fri, 20
 Jun 2025 07:39:18 -0700 (PDT)
Date: Fri, 20 Jun 2025 07:39:16 -0700
In-Reply-To: <2eqjnjnszlmhlnvw6kcve4exjnpy7skguypwtmxutb2gecs3an@gcou53thsqww>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250611224604.313496-2-seanjc@google.com> <20250611224604.313496-19-seanjc@google.com>
 <2eqjnjnszlmhlnvw6kcve4exjnpy7skguypwtmxutb2gecs3an@gcou53thsqww>
Message-ID: <aFVylP1XzMoqocOx@google.com>
Subject: Re: [PATCH v3 17/62] KVM: SVM: Add enable_ipiv param, never set
 IsRunning if disabled
From: Sean Christopherson <seanjc@google.com>
To: Naveen N Rao <naveen@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <joro@8bytes.org>, 
	David Woodhouse <dwmw2@infradead.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	Sairaj Kodilkar <sarunkod@amd.com>, Vasant Hegde <vasant.hegde@amd.com>, 
	Maxim Levitsky <mlevitsk@redhat.com>, Joao Martins <joao.m.martins@oracle.com>, 
	Francesco Lavra <francescolavra.fl@gmail.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 19, 2025, Naveen N Rao wrote:
> On Wed, Jun 11, 2025 at 03:45:20PM -0700, Sean Christopherson wrote:
> > From: Maxim Levitsky <mlevitsk@redhat.com>
> >=20
> > Let userspace "disable" IPI virtualization for AVIC via the enable_ipiv
> > module param, by never setting IsRunning.  SVM doesn't provide a way to
> > disable IPI virtualization in hardware, but by ensuring CPUs never see
> > IsRunning=3D1, every IPI in the guest (except for self-IPIs) will gener=
ate a
> > VM-Exit.
>=20
> I think this is good to have regardless of the erratum. Not sure about VM=
X,
> but does it make sense to intercept writes to the self-ipi MSR as well?

That doesn't work for AVIC, i.e. if the guest is MMIO to access the virtual=
 APIC.

Regardless, I don't see any reason to manually intercept self-IPIs when IPI
virtualization is disabled.  AFAIK, there's no need to do so for correctnes=
s,
and Intel's self-IPI virtualization isn't tied to IPI virtualization either=
.
Self-IPI virtualization is enabled by virtual interrupt delivery, which in =
turn
is enabled by KVM when enable_apicv is true:

  Self-IPI virtualization occurs only if the =E2=80=9Cvirtual-interrupt del=
ivery=E2=80=9D
  VM-execution control is 1.

