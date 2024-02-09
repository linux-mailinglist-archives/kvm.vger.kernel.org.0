Return-Path: <kvm+bounces-8510-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0233085002A
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 23:40:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B9B59281A74
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 22:40:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC5252E3E4;
	Fri,  9 Feb 2024 22:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PUn8RCu/"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A60922083
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 22:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707518440; cv=none; b=ouENQCsMIjVShVQdym1Ny5zZkkakG1V0+4ia7BC9FxgPHIU5+06Oyc4kKpMYaV2qsyJi4Ps358y+9x1z7U5tIRCZCylVdSgDQJbnWZbJyneE7ljuo1TKMBkXazYokL8dtsg3ONs0RVKhTyBN3/qLeH6Fm6WoQFo0rAcv1xr1LlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707518440; c=relaxed/simple;
	bh=5mTur19Rxbo1EgoDaluJz65rrbAQAX8fLUiZ9Ef5FE0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=opnqNLY1oWEX+ytGxA4uTsqOOc3OsdLyxzMO0wPoskq+seGWAX/BISUMS3rTewhotB1pzaP6GOLVZfWj0bdUEfPXKUpogSQ31ZYZpJCG65Pn/1UYN0ZzkaP0nciY2PM3u0WwTg69Q5ftnXzrem0BiX2AjhHCCI3WxS2L7nrm/rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PUn8RCu/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707518438;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0VQrsHUE/LptBa5nKpmriIWMNQMle8yxHNuy/INIktI=;
	b=PUn8RCu/8j+HXrPaOS0YiILrvRGviNGA+YEvg72EgVcbLqa6KuFgn25mJ91B+pFIjNzfk9
	mcfdhRKP1snD0uWAvzG+wP8qWC1af5IkG2RH2VMp19XB+RfGX+d9H0yJvofWsa3NfeeoDs
	nKJoOSpmLkJNa1qhbKqz3nfJxkmSfHk=
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com
 [209.85.222.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-131-3KT0b-P5Nfun6rHXpPO50g-1; Fri, 09 Feb 2024 17:40:36 -0500
X-MC-Unique: 3KT0b-P5Nfun6rHXpPO50g-1
Received: by mail-ua1-f71.google.com with SMTP id a1e0cc1a2514c-7d5bbbe57b8so737001241.1
        for <kvm@vger.kernel.org>; Fri, 09 Feb 2024 14:40:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707518435; x=1708123235;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0VQrsHUE/LptBa5nKpmriIWMNQMle8yxHNuy/INIktI=;
        b=YnhihRYb1/2d9kV34pXXERMMCUwJJQw75UzRCv9yIsKIaokC4yvBbdRnunyal3mb9a
         4Sgay7jYQeMgJy76tfcNM+yEQcux+HEMBS1dhszK1dPwVSefyK+p3lnWdSwRanUsjFdW
         tD54Uek4VP19acOfktD/3NTcEaCymj4K5p9wfurF8WF/swMytWhaA2mJCpOJbmr3thX+
         NJOAdO/B5Oh3UGKzp+RBxqezJPV/p7zUhYb+jbCaxeLxjGnbKafxX5LQsravNwyRLkti
         XyksUEbhEHq/HDKWvLi5ZjFbpoDtAs+PBDGEMeGZib0JNXB+TyvSyMVST5/eRj4+jgzU
         ysfQ==
X-Forwarded-Encrypted: i=1; AJvYcCXI/eDQ/MdF2Jb7s/02eMrWb+C7jamcbGVTU0GNBaI3GV2OIuxc5mcoW18WbLSMq4gq7zsWnv4G3xk0dd4lZ1xjbNY/
X-Gm-Message-State: AOJu0YzZFW8uueTzk9/NHXw5GokZWcBlbUVbWGtMIN1qzl6rctMy8zC3
	dElAU+OMh9Y4mOKONIMJardvvB2jdyfqJUL+ntJf2Ky9q764sF5U31idgJeU/ma6nP1UjVkcVnY
	tguHZPXIk1m2otU+wq3U0m9ZPo8ITQnwy+qQzFCI28C8MQjmZtEaQYCu8rHIBgrYR8INFBADcKu
	iKdycPV4lTN9CmJDlDc/Xsk6aN
X-Received: by 2002:a05:6102:198a:b0:46d:295d:1d9c with SMTP id jm10-20020a056102198a00b0046d295d1d9cmr966944vsb.21.1707518435613;
        Fri, 09 Feb 2024 14:40:35 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGDT5FseOqjE7EgYc0WV0xo2jicn+bWaOOKx90vB2jZwvCrR/EUTmLrqEEMbxIhn/R3Z0xvt66ZxrXlXADlWgM=
X-Received: by 2002:a05:6102:198a:b0:46d:295d:1d9c with SMTP id
 jm10-20020a056102198a00b0046d295d1d9cmr966937vsb.21.1707518435345; Fri, 09
 Feb 2024 14:40:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240209183743.22030-1-pbonzini@redhat.com> <ZcZ_m5By49jsKNXn@google.com>
In-Reply-To: <ZcZ_m5By49jsKNXn@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 9 Feb 2024 23:40:23 +0100
Message-ID: <CABgObfaum2=MpXE2kJsETe31RqWnXJQWBQ2iCMvFUoJXJkhF+w@mail.gmail.com>
Subject: Re: [PATCH 00/10] KVM: SEV: allow customizing VMSA features
To: Sean Christopherson <seanjc@google.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, michael.roth@amd.com, 
	aik@amd.com, isaku.yamahata@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 9, 2024 at 8:40=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
> On Fri, Feb 09, 2024, Paolo Bonzini wrote:
> > The idea that no parameter would ever be necessary when enabling SEV or
> > SEV-ES for a VM was decidedly optimistic.
>
> That implies there was a conscious decision regarding the uAPI.  AFAICT, =
all of
> the SEV uAPIs are direct reflections of the PSP invocations.  Which is wh=
y I'm
> being so draconian about the SNP uAPIs; this time around, we need to actu=
ally
> design something.

You liked that word, heh? :) The part that I am less sure about, is
that it's actually _possible_ to design something.

If you end up with a KVM_CREATE_VM2 whose arguments are

   uint32_t flags;
   uint32_t vm_type;
   uint64_t arch_mishmash_0; /* Intel only */
   uint64_t arch_mishmash_1; /* AMD only */
   uint64_t arch_mishmash_2; /* Intel only */
   uint64_t arch_mishmash_3; /* AMD only */

and half of the flags are Intel only, the other half are AMD only...
do you actually gain anything over a vendor-specific ioctl?

Case in point being that the SEV VMSA features would be one of the
fields above, and they would obviously not be available for TDX.

kvm_run is a different story because it's the result of mmap, and not
a ioctl. But in this case we have:

- pretty generic APIs like UPDATE_DATA and MEASURE that should just be
renamed to remove SEV references. Even DBG_DECRYPT and DBG_ENCRYPT
fall in this category

- APIs that seem okay but may depend on specific initialization flows,
for example LAUNCH_UPDATE_VMSA. One example of the problems with
initialization flows is LAUNCH_FINISH, which seems pretty tame but is
different between SEV{,-ES} and SNP. Another example could be CPUID
which is slightly different between vendors.

- APIs that are currently vendor-specific, but where a second version
has a chance of being cross-vendor, for example LAUNCH_SECRET or
GET_ATTESTATION_REPORT. Or maybe not.

- others that have no hope, because they include so many pieces of
vendor-specific data that there's hardly anything to share. INIT is
one of them. I guess you could fit the Intel CPUID square hole into
AMD's CPUID round peg or vice versa, but there's really little in
common between the two.

I think we should try to go for the first three, but realistically
will have to stop at the first one in most cases. Honestly, this
unified API effort should have started years ago if we wanted to go
there. I see where you're coming from, but the benefits are marginal
(like the amount of userspace code that could be reused) and the
effort huge in comparison. And especially, it's much worse to get an
attempt at a unified API wrong, than to have N different APIs.

This is not a free-for-all, there are definitely some
KVM_MEMORY_ENCRYPT_OP that can be shared between SEV and TDX. The
series also adds VM type support for SEV which fixes a poor past
choice. I don't think there's much to gain from sharing the whole INIT
phase though.

Paolo


