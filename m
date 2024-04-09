Return-Path: <kvm+bounces-13993-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DA73989DD21
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 16:45:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 90A4D1F213F8
	for <lists+kvm@lfdr.de>; Tue,  9 Apr 2024 14:45:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5130A131740;
	Tue,  9 Apr 2024 14:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bxsvC2k3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E77EF1304BD
	for <kvm@vger.kernel.org>; Tue,  9 Apr 2024 14:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712673856; cv=none; b=CGdoCc/8dhTvRKT7ON6UbY9pEbLO7Q3GogmRh4GZANlxDfrTPuDIMeArOB/uzandCjw5TzIVmtXvgOILvFYx+Ya2rLZNhpD5KkLHznxLz8Gwk5E1vTjpCJpYAEBu3H45kArz5jcG5sNhzdNP7qymIE/z+xnx41gtjgWm1o+CfOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712673856; c=relaxed/simple;
	bh=LN+SrPFAB1QQDGS0sQ1uUZWJejE7/O/ikNPcHErmpgo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cOC3sO2m9l4R7r0+ixIsiHcfD6lzctoOphnjhqk1fULGYDFbyntWc2CJ0kwXbkHhT7vAq1yHiBqeGPDZ9Fi0Zgp3f/tW5kM9D/LhV3/qCXuyiNUDm6EYSb+wsI0jE2bcS3QsmZlpYC7tlNZWrWcy99lGa1xU45ZOuPOFnD7Nqu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bxsvC2k3; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712673853;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q0yAbVSZ34mp5kejpKRkl/DoY4HVDAy2aW2h14uuvCc=;
	b=bxsvC2k3mZVd8gGS+enQCkcFdCdgiXURuxPy/tK00A2LpsaY2tKXMHw0mmQWP6ZP9o2Naq
	8o4k7XNxbCt+3jbYZNQYt1Gq/3ngHjzqh44DZiSvt1alHzgOq4z3BESboQr/7qde1Yu9QC
	MpMItgRJa+oTBD5aCXWpGSBoYNBYBV4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-534-QsZzhEh0OFakTJPBAoBgrw-1; Tue, 09 Apr 2024 10:44:12 -0400
X-MC-Unique: QsZzhEh0OFakTJPBAoBgrw-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-414aa7bd274so33465665e9.1
        for <kvm@vger.kernel.org>; Tue, 09 Apr 2024 07:44:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712673851; x=1713278651;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q0yAbVSZ34mp5kejpKRkl/DoY4HVDAy2aW2h14uuvCc=;
        b=q6WPucVkLmabK3Llcs87juPYpKdHjIBzBq2ll5kl/t/d9oNoYe/gF6FKCqkPQPgX0f
         RTjZ68IVFLjv49H3MxCeSTYSEl/ZwklGWtJF11k2K6zVvkpWVZUa2CxWER7JAszeFA3+
         RF9Hf5rBp3bvDyo8XHP1f9ThMdINN07BEMXCEZZ/C8K39kol26P95Eb8mJb/YvzpbU6H
         MC01r+hiqA+Swf2cvcYJMLNmBhSmUdHK2YOm3Pa9dMh48xhHtJKk0IyPG1rmBMgXUWko
         X3zkvzIp9o4sNIZPmKBTh+/gRIcXRxYUUQbPk94s+c5ENowB+8yTW1AHu//x4QJ/TR15
         2fJQ==
X-Forwarded-Encrypted: i=1; AJvYcCVKpv+hRpzUGwyEjy2coMhtYbdSx4xkl9syaNvFebL4DHbCptqi3DdkdlNgDT6aiQ4d9E68wNu4wXkp3VzeGbPz+yMr
X-Gm-Message-State: AOJu0Yywzg/iJIwGJDdHnO/+kJwUtCeDs7JN+JLO7qPgygZRbVBNQh9a
	L+/ssSBTjDTl5Z1arKJMidPiPoyqDR/WIOw9Z2o1Ozsjd9+NiuUmizsO51kF6oHVkU6zeI6V38K
	6mc+KMkGjRhzs0wPi/9s98+DptphuLUlaGtoK0aCbZjMyr7QtT/t2obvq4xInw+912Bry02cTN5
	jnMcdqQU/K/wERSudJQ62SyhK4
X-Received: by 2002:a5d:5f43:0:b0:346:ad0:7e6a with SMTP id cm3-20020a5d5f43000000b003460ad07e6amr2743684wrb.36.1712673851244;
        Tue, 09 Apr 2024 07:44:11 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEB5i0c/rvPebMeztdIAxfzC9J2VD+HmaBLODURlTNuBLFEQTLFKctXKTnuSH/Ewfhllb127kdqpMOHzAxDD2w=
X-Received: by 2002:a5d:5f43:0:b0:346:ad0:7e6a with SMTP id
 cm3-20020a5d5f43000000b003460ad07e6amr2743674wrb.36.1712673850960; Tue, 09
 Apr 2024 07:44:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240404121327.3107131-1-pbonzini@redhat.com> <20240404121327.3107131-8-pbonzini@redhat.com>
 <43d1ade0461868016165e964e2bc97f280aee9d4.camel@intel.com> <ZhSYEVCHqSOpVKMh@google.com>
In-Reply-To: <ZhSYEVCHqSOpVKMh@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 9 Apr 2024 16:43:59 +0200
Message-ID: <CABgObfZAJ50Z30VzFLdSrQFOEaPxpyFWuvVr1iGogjhs2_+bGA@mail.gmail.com>
Subject: Re: [PATCH v5 07/17] KVM: x86: add fields to struct kvm_arch for CoCo features
To: Sean Christopherson <seanjc@google.com>
Cc: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"michael.roth@amd.com" <michael.roth@amd.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 9, 2024 at 3:21=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
> > I'm a little late to this conversation, so hopefully not just complicat=
ing
> > things. But why not deduce has_private_mem and has_protected_state from=
 the
> > vm_type during runtime? Like if kvm.arch.vm_type was instead a bit mask=
 with
> > the bit position of the KVM_X86_*_VM set, kvm_arch_has_private_mem() co=
uld
> > bitwise-and with a compile time mask of vm_types that have primate memo=
ry.
> > This also prevents it from ever transitioning through non-nonsensical s=
tates
> > like vm_type =3D=3D KVM_X86_TDX_VM, but !has_private_memory, so would b=
e a little
> > more robust.
>
> LOL, time is a circle, or something like that.  Paolo actually did this i=
n v2[*],
> and I objected, vociferously.

To be fair, Rick is asking for something much less hideous - just set

 kvm->arch.vm_type =3D (1 << vm_type);

and then define kvm_has_*(kvm) as !!(kvm->arch.vm_type & SOME_BIT_MASK).

And indeed it makes sense as an alternative. It also feels a little
bit more restrictive and the benefit is small, so I think I'm going to
go with this version.

Paolo


