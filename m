Return-Path: <kvm+bounces-49226-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F8C1AD6763
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 07:34:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CA36E189A4E9
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 05:34:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F7641DF270;
	Thu, 12 Jun 2025 05:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PtifOTOw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74DC13C81B
	for <kvm@vger.kernel.org>; Thu, 12 Jun 2025 05:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749706473; cv=none; b=ldsWyZxSRrB8UautxxWHiy0SrSD23MeU/08vJqRj3x2QkY5f1xWUNnivAkXNlpDIuN7LSQoIrvI9mT6QMru0KO3+PGhCmc/8UPvf4VFcpE0Nr5R1zxvrlfJzenOqH4+gE4MSnss9C/ER2Ww/c5rkybR9grSxdUO9KMazn9/FGg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749706473; c=relaxed/simple;
	bh=UiEigjrBL/PVRdzjBTfpiW4C3SupfyiHMu4I/EEz5WM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o6RHZxlMuAbC4C0kaz86m6QP0GLDZXVPrHiy68g4mVHOQ5wh8llANkcI4KfgavbfQP+hihh8cg22xNE8Tff/qVZ1LK2qiMOygDJ2Grrpv5qeHErPz56TNTWqKpjvo1QTVwdRb6KDgHYaeikSCIhF5DCSH7TgNtpVFUCPVsKKwpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PtifOTOw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749706470;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8X+KEMlrQPZXbF8BZWuOrHRVf8Is3K9LsdqXqaOk30o=;
	b=PtifOTOwEMGKX9hsspPN7/tUDGzY43BtnC0677bpOmtDJkBFT1qiZphUw7lQXc3zLkjNQJ
	2VdTYJYlfWuoYF7iV5TN3DKcSc6TfcJnIOKmSRWkf1oeGPOZHESZKUuK2TDLhOsSeGbIVt
	A8z+WSzz5rtGke5y+l+Nn6529Ul6puI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-623-YW4VXsxRNPOBQ-JJLzkElA-1; Thu, 12 Jun 2025 01:34:29 -0400
X-MC-Unique: YW4VXsxRNPOBQ-JJLzkElA-1
X-Mimecast-MFC-AGG-ID: YW4VXsxRNPOBQ-JJLzkElA_1749706468
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3a4f85f31d9so220005f8f.1
        for <kvm@vger.kernel.org>; Wed, 11 Jun 2025 22:34:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749706468; x=1750311268;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8X+KEMlrQPZXbF8BZWuOrHRVf8Is3K9LsdqXqaOk30o=;
        b=ZnIxYSe4zqHjwu5K5kKs+ddnaCSHeAYUCHTHA/oJXLJ+eeK2EuoN2F8tmfLWNUEWXi
         yErdKCFizcY1gc1kyWBIjzh59bpNdq6qs17O/vMeZA8+L6//8ryfGlW+YT4bIepmchtG
         xZOIXehAj1Po+UJjiZ8PVdyOdxZc7gN6XSpjnceG1cHUbueQ78yBHIS3/PLTIskhXEle
         hLqwGncCkZHTlGGQSandw3R1zPt/KVEz7pVOlOPtxNVO6duK6ZN9TEk6Futs6HTEjeB+
         fFqJsjClxt9RWkuddyFSDs2QuWU+8+D0nN2cug3i9oZM3Ys7PWNGmMMbdav8SRGHKO3z
         2flA==
X-Forwarded-Encrypted: i=1; AJvYcCXsiW8G5E20jfZSZVOzEqaZ5iP9EiZ0ec4zZdz/C7PCQ2rK+Z/9LoFjSs/6il0XEUx28/8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWrBw4vb0qIkBZ5twh1TiwLQj+lqbgzQnJ15R300QDzHVO4L4b
	Fm0AUMudN6PAcSmf9suRAB6IaulXhMP3ViTWi/di5FDZoXw7LqvJ4pYWOruJiOCAOD23AHcvmoY
	7PnxztbrbVSc1VgsSdmHL/5HGVnWzDBpmBBhDjpHmhgCCCdZsKxaTZx2GN8jiA/ThOKqy5cGOAD
	UnhFcgCQIHn5aCVNeAWARuyaeGRNVy
X-Gm-Gg: ASbGncsVPGqZqj5m+ATeJpi6uWMm+uljT89na1n6ha/33gQMgniQzdulax9rIS86yEb
	3gt877IzErXsBi93Z8nv9ZZjv/wbHwtQFg2B5X9eg3wBoTkRqmbUuZE/PNBQjjB4QpGqvb7Qhfo
	FQxw==
X-Received: by 2002:a05:6000:400e:b0:3a4:c909:ce16 with SMTP id ffacd0b85a97d-3a56078014fmr1332773f8f.49.1749706467812;
        Wed, 11 Jun 2025 22:34:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFUoDrNCJSqWMpRx7BQZQqyz9zBR8eq3rCWjxL1Aa1yJ0Qp62fxKUknBXS+/RHNgWEzx4rc4+UKHNvsCfYaKls=
X-Received: by 2002:a05:6000:400e:b0:3a4:c909:ce16 with SMTP id
 ffacd0b85a97d-3a56078014fmr1332754f8f.49.1749706467425; Wed, 11 Jun 2025
 22:34:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250612044943.151258-1-pbonzini@redhat.com> <cfd99e56-551b-49c5-b486-05c9f6d8cf11@intel.com>
In-Reply-To: <cfd99e56-551b-49c5-b486-05c9f6d8cf11@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 12 Jun 2025 07:34:12 +0200
X-Gm-Features: AX0GCFvR7ruY-7CJzAvpxNmfdGIN_rQ_TTVqOWRNjhewrDtkRemeydBZiVKiJtU
Message-ID: <CABgObfafukOFkeR09krA5GVb3itfpHNHjBM0aRZj5t4EKJv7Dw@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/mmu: Reject direct bits in gpa passed to KVM_PRE_FAULT_MEMORY
To: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, seanjc@google.com, 
	yan.y.zhao@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 12, 2025 at 7:29=E2=80=AFAM Xiaoyao Li <xiaoyao.li@intel.com> w=
rote:
>
> On 6/12/2025 12:49 PM, Paolo Bonzini wrote:
> > Only let userspace pass the same addresses that were used in KVM_SET_US=
ER_MEMORY_REGION
> > (or KVM_SET_USER_MEMORY_REGION2); gpas in the the upper half of the add=
ress space
> > are an implementation detail of TDX and KVM.
> >
> > Extracted from a patch by Sean Christopherson <seanjc@google.com>.
> >
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >   arch/x86/kvm/mmu/mmu.c | 3 +++
> >   1 file changed, 3 insertions(+)
> >
> > diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> > index a4040578b537..4e06e2e89a8f 100644
> > --- a/arch/x86/kvm/mmu/mmu.c
> > +++ b/arch/x86/kvm/mmu/mmu.c
> > @@ -4903,6 +4903,9 @@ long kvm_arch_vcpu_pre_fault_memory(struct kvm_vc=
pu *vcpu,
> >       if (!vcpu->kvm->arch.pre_fault_allowed)
> >               return -EOPNOTSUPP;
> >
> > +     if (kvm_is_gfn_alias(vcpu->kvm, gpa_to_gfn(range->gpa)))
> > +             return -EINVAL;
>
> Do we need to worry about the case (range->gpa + range->size) becomes ali=
as?

No, because the function only processes a single page and everything
in the non-aliased part of the address space *can* be prefaulted.

KVM's generic kvm_vcpu_pre_fault_memory() call will see the EINVAL on
a later invocation and will stop processing the part of the request
that is has the shared/direct bit set.

Paolo

>
> >       /*
> >        * reload is efficient when called repeatedly, so we can do it on
> >        * every iteration.
>


