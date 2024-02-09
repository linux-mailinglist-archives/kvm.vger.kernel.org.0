Return-Path: <kvm+bounces-8384-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ADAED84EE92
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 02:22:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5AE2E1F2556A
	for <lists+kvm@lfdr.de>; Fri,  9 Feb 2024 01:22:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 088D4184D;
	Fri,  9 Feb 2024 01:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UdddsD1f"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7B715C9
	for <kvm@vger.kernel.org>; Fri,  9 Feb 2024 01:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707441743; cv=none; b=TslMfoiG6UqEiHvaqXTyeisdAHkh9wYPn7tkR0xLvJNdaiTuqnL70AygvEyz6jKP/WCtU8WNPbAY3kFugkou7/5uObQSoN+eIyKt+56oYVyL7XJ1GaLTVjXHAPf3NIG+RbB6RdMpFS77Y163rFOCeZJXYQsskpFAEGJ4cjJ1spc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707441743; c=relaxed/simple;
	bh=/TR1cJLKRZ7qu6VO47XamR64YLXHPgzQDbOxb2ul2qk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IEH2dNkcAkqaVGaiC7UQtb+v9FftJu1so+n3Lo3v4SR6FomQvsXSssTKK/V13Y1DaU6Y2vjXP7B1joixMXe7KlxmTpjstAg9pBH1PfMl2iVWPh4wcRSRS+DbN26okThpL4nvvlpO9YPYgupMZPsNWnLGCiu9OaYippDwnmruY5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UdddsD1f; arc=none smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-21433afcc53so198964fac.3
        for <kvm@vger.kernel.org>; Thu, 08 Feb 2024 17:22:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707441741; x=1708046541; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1bYUdUfxiMsyMg1eLJUlGCPzcBcDEpAd2dqR1EO83KU=;
        b=UdddsD1fBbXOxSUqWITiN5lS9SjZzZjih5wF3GPtsig80IRXjv45YYww2xItbGiHl4
         r1voBM6fB/21FvG12LQ1cIIuH0DqfN6uiVU5MZaTZElouuXwqUsgr6x+smZ8vMgcC2u1
         8hhp87r+bfKU79dS82YWRzPrlMTjUkVLVaN83gVZlIrn0gxPOr70mRjqtWpwuA9P+F5x
         81gMwsK+aL8fF3VRrGsb8Ajx5RQPy67A9jBrmckVcqEKRvjl7zkg+qy+pqS/DOAai8mN
         vntItSW0YvKPVq7mrywkvsfWJaOIg6iBK2q7gfLyNNRaJNeqi6JzCh6EoxPfGQotKa/y
         jWsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707441741; x=1708046541;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1bYUdUfxiMsyMg1eLJUlGCPzcBcDEpAd2dqR1EO83KU=;
        b=UNECH7JGYuqOIBS2RNbya/i9slQrfFRQx44pZJkFwYhc34TW03sGLdzWuThUVE9wbb
         ejg3IkH+RALXtZT1fpnL/trM9PBrUx6vBZdBKtp8WlaxFqzFd0tupvJNEGceXyr/ujRL
         n03KuN/Tp5xfdfF+NT0NDUJV72A1AMOX+92Yxf6qdsc8qu0RDB5sswgJnqJkUagDq55g
         a1FqnLCm4cuwAImIzHW1dNfAWuqjSybn2aXbnnS9aZWEkeYBq5hweYhWYcB4s+0jKmo0
         MJS3PwNaBtALv8pYNWlwmDlcZrSZFTsTGX3XSSPPWbqC/PQIAw9hrDT0kWlIqa2u5efe
         rAGA==
X-Gm-Message-State: AOJu0Yw0tXiiOAYMck/0NvbEN96SGV02CuxSUf35T2SqvF3xbAapWdJD
	zZN2gcAv3jGJVzQ11ATHCD3ohQnu2F7bvJ6MqSgh67ULQM86FLFFzQT/egIjfltMMgJsRjzxXLa
	0OE6EiEkIk4dXvKCc1XNcyv+w9Roe0uOOdxzx
X-Google-Smtp-Source: AGHT+IFSxFEFm392BLtgCppQjIi7plXowCwt6ua6fM2hmnZz5cd9La9OdUzvHyKYI93f8vW4Jx6A2frmFsO0KFzpH1Q=
X-Received: by 2002:a05:6870:4725:b0:218:5017:af07 with SMTP id
 b37-20020a056870472500b002185017af07mr208303oaq.0.1707441740910; Thu, 08 Feb
 2024 17:22:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com> <20231109210325.3806151-10-amoorthy@google.com>
 <CADrL8HXLF+EQZt+oXJAiatoJNzz2E-fiwUSJj=YpHzGQxL00mQ@mail.gmail.com> <CAF7b7mrALBBWCg+ctU867BjQhtLQNuX=Yo8u9TZEuDTEtCV6qw@mail.gmail.com>
In-Reply-To: <CAF7b7mrALBBWCg+ctU867BjQhtLQNuX=Yo8u9TZEuDTEtCV6qw@mail.gmail.com>
From: Anish Moorthy <amoorthy@google.com>
Date: Thu, 8 Feb 2024 17:21:43 -0800
Message-ID: <CAF7b7mr12opfJTTBC_kt1yoUWTKAV91Q8MrHk8_0ttQsXn9G9w@mail.gmail.com>
Subject: Re: [PATCH v6 09/14] KVM: arm64: Enable KVM_CAP_EXIT_ON_MISSING and
 annotate an EFAULT from stage-2 fault-handler
To: James Houghton <jthoughton@google.com>
Cc: seanjc@google.com, kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	oliver.upton@linux.dev, pbonzini@redhat.com, maz@kernel.org, 
	robert.hoo.linux@gmail.com, dmatlack@google.com, axelrasmussen@google.com, 
	peterx@redhat.com, nadav.amit@gmail.com, isaku.yamahata@gmail.com, 
	kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 31, 2024 at 2:38=E2=80=AFPM Anish Moorthy <amoorthy@google.com>=
 wrote:
>
> On Tue, Jan 30, 2024 at 3:58=E2=80=AFPM James Houghton <jthoughton@google=
.com> wrote:
> >
> > I think that either (1) we move this kvm_prepare_memory_fault_exit
> > logic into the previous patch[1], or (2) we merge this patch with the
> > previous one. IIUC, we can only advertise KVM_CAP_MEMORY_FAULT_INFO on
> > arm64 if this logic is present.
>
> Actually (sorry, about-face from our off-list chat), *does* it make
> sense to merge these two patches?

As per [1]: yes, it makes sense to move the kvm_prepare_memory_fault_exit()=
.

So for the next version, the description is also going to change a bit to

> KVM: arm64: Implement and advertise KVM_CAP_EXIT_ON_MISSING
>
> Prevent the stage-2 fault handler from faulting in pages when
> KVM_MEM_EXIT_ON_MISSING is set by allowing its  __gfn_to_pfn_memslot()
> call to check the memslot flag. This effects the delivery of stage-2
> faults as vCPU exits (see KVM_CAP_MEMORY_FAULT_INFO), which userspace
> can attempt to resolve without terminating the guest.

> Delivering stage-2 faults to userspace in this way sidesteps the
> significant scalabiliy issues associated with using userfaultfd for the
> same purpose.

[1] https://lore.kernel.org/kvm/ZcP_JHsMJUlvjAs1@linux.dev/#t

