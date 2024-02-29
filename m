Return-Path: <kvm+bounces-10550-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 278F086D5B6
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 22:08:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5E4028E5BC
	for <lists+kvm@lfdr.de>; Thu, 29 Feb 2024 21:08:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB4F61504EA;
	Thu, 29 Feb 2024 20:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R1tYiV8W"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE69213E7F6
	for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 20:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709240184; cv=none; b=A90b0JIAVfkavijdIAI11iDO+p8h0PnL3BglfewtU0aFoiTQAZbS8W4fhhdIi8iOTj0eyLIEQj0asLdPOECfzTpl5dyRxXSO4x1KcB0335kLiF4ff9pLQBkbz5Xjkc29L4ZcaGhhHQO3QIU6uDTRVx3QPQRKSgM6VEFYTdN/Jt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709240184; c=relaxed/simple;
	bh=fV1kqpZQ/sSCXlptOjdZ28ZJ5cm/XhJs99VfeV8ikn8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mQKrORHKJGTv8ard3d48tY969zitgadfRTggIYPv4gJoL9OQtt4DSPYOhZi8ApiEi34FyudEIE26otaD2BEIO9dw9JC8d1W6tHw7BZXvXpHI05I8ChyALNccK7m0OPZyuYNGYVtsrJRlTT4PXm8l+f7ii0mUDAPbR7wA2rkDeiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R1tYiV8W; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709240181;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eiaPwrwhaqL9Ej4GtEw9LKGF9DdPVcepWFooDH+BsfA=;
	b=R1tYiV8WTKo5t2YqWMV72/F5ZATLL1JGM+73uwhdHDfwPdQDBYZk7nSF8oS0n+5sHoA7bH
	A2Kz0BXfHm056Labz7LVUZsazrtH5eXgOmChGpybJmckV0uoAjZgWQAjDA6uzWW3Bwqe3u
	4ZQzbh1egCkPpKoIji8BPAKeU7YdD44=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-321-T_TdDBK9NgCApsjnU6sEuw-1; Thu, 29 Feb 2024 15:56:17 -0500
X-MC-Unique: T_TdDBK9NgCApsjnU6sEuw-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-412b845aab2so5311495e9.1
        for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 12:56:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709240176; x=1709844976;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eiaPwrwhaqL9Ej4GtEw9LKGF9DdPVcepWFooDH+BsfA=;
        b=XWKYERaup3GfzvIzVXLUc1mSf6ecT7DfMvaVgrsZNrEg1Nqp3AL1toL7GJarVzbzSF
         jIx8sSFYgB1I96zptmr5f/RubwiH6+Ifu7FeWyxWRGMa9hwa0BXFrtpCDrHhSDTBhTIF
         0V+OfA06OBEqDSBts1yPT4J3wmdlK+Uh/VBTYpjad/jVOGgn/LPTm4sHbIUydmYZ79Lh
         dHMw4B60qU5caxklFvn+JcflvKJj+9iuoLv396WgCMNbCpTkXuW7Rg8iIzomXRsJCagz
         mKG1350UQi8X6QG7ky41+sXsPa7ddvszVO5BX+iSV+TRU8NfuqF0/YlJSCY6RLWlyJnU
         O0Lg==
X-Gm-Message-State: AOJu0YxbF6nboAfDfutgiy9TwgRV75ki5OQJkO+03Yn+RkJJSwVvt7Wy
	2f5m6eypk3MWfaAFQNemA2nD8l36G2+aZfPTgEGjXv0rRZnP+RlKv6f57G1J4mdTN/Cxfr76Lm1
	+CNmUDWOtzOOgLqZJW2DpnS+91Yjao8oAkhzRdXOPusx1urIyr1PIKn1b2U2DJOdg13dtQCWUD6
	hV6Xj8uxJxe36y2+tiHrQ5xdTl
X-Received: by 2002:a05:600c:a386:b0:412:b6c4:ac21 with SMTP id hn6-20020a05600ca38600b00412b6c4ac21mr129751wmb.41.1709240176749;
        Thu, 29 Feb 2024 12:56:16 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF/pLwxu7qVY+FEzPu28C2COXQu70si1JtMVmyrPRMvUbqeq+QPhQ4uW/IqUc+Dif1jUGUYHijFe39hpc6rWc8=
X-Received: by 2002:a05:600c:a386:b0:412:b6c4:ac21 with SMTP id
 hn6-20020a05600ca38600b00412b6c4ac21mr129737wmb.41.1709240176364; Thu, 29 Feb
 2024 12:56:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240228024147.41573-1-seanjc@google.com> <20240228024147.41573-3-seanjc@google.com>
 <CABgObfbtPJ6AAX9GnjNscPRTbNAOtamdxX677kx_r=zd4scw6w@mail.gmail.com> <ZeDPgx1O_AuR2Iz3@google.com>
In-Reply-To: <ZeDPgx1O_AuR2Iz3@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 29 Feb 2024 21:56:04 +0100
Message-ID: <CABgObfaXQR7WaUwjvBz-1yJN3fyysj1BMyY0S9L3DbizWjgrSQ@mail.gmail.com>
Subject: Re: [PATCH 02/16] KVM: x86: Remove separate "bit" defines for page
 fault error code masks
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Yan Zhao <yan.y.zhao@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Michael Roth <michael.roth@amd.com>, Yu Zhang <yu.c.zhang@linux.intel.com>, 
	Chao Peng <chao.p.peng@linux.intel.com>, Fuad Tabba <tabba@google.com>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 29, 2024 at 7:40=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
> Long story short, I think we should get to the below (I'll post a separat=
e series,
> assuming I'm not missing something).
>
>         unsigned long rflags =3D static_call(kvm_x86_get_rflags)(vcpu);
>         unsigned int pfec =3D access & (PFERR_PRESENT_MASK |
>                                       PFERR_WRITE_MASK |
>                                       PFERR_USER_MASK |
>                                       PFERR_FETCH_MASK);
>
>         /*
>          * For explicit supervisor accesses, SMAP is disabled if EFLAGS.A=
C =3D 1.
>          * For implicit supervisor accesses, SMAP cannot be overridden.
>          *
>          * SMAP works on supervisor accesses only, and not_smap can
>          * be set or not set when user access with neither has any bearin=
g
>          * on the result.
>          *
>          * We put the SMAP checking bit in place of the PFERR_RSVD_MASK b=
it;
>          * this bit will always be zero in pfec, but it will be one in in=
dex
>          * if SMAP checks are being disabled.
>          */
>         u64 implicit_access =3D access & PFERR_IMPLICIT_ACCESS;
>         bool not_smap =3D ((rflags & X86_EFLAGS_AC) | implicit_access) =
=3D=3D X86_EFLAGS_AC;
>         int index =3D (pfec | (not_smap ? PFERR_RSVD_MASK : 0)) >> 1;
>         u32 errcode =3D PFERR_PRESENT_MASK;
>         bool fault;

Sounds good.  The whole series is

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

apart from the small nits that were pointed out here and there.

Paolo


