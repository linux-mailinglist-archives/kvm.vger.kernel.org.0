Return-Path: <kvm+bounces-15123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D5E1E8AA205
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 20:28:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A8EB281EFC
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 18:28:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F081717AD6A;
	Thu, 18 Apr 2024 18:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gcUJK8Rx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3DD178CFA
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 18:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713464890; cv=none; b=OlpIXo190KG/xpiIXEbT2/6bt3sYChLmlOe9dnZ7oOrxrU/DxjPzOzgwGcflj0ok26/zNc7BE9LJgskAZfm3jNCncbLvmhTD6JFvZBWMLTE3lzNl1jE3NB8Pox81aKubsPWcOYdPjSbrksaYgoi70B1ftngurEeBenFfXor7yqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713464890; c=relaxed/simple;
	bh=R1lVfxWdHMgZEl/GJ+t31bj2vLOAc95uyRSzDMDSSs8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TN72hT39+65p+iYvMzuHC/RsmomfUFDHMT/MyCGG2WgCpYFfBXW5VQuzM8WbdOblEGhFkvbhslWZatGD0ozFpqhwHz356Y+1sk+Qe1hYDQqKap2X3UBqSSbFwFIGa6RK1fAnWzxPrOlSKc1IWQ2dVmvD6hwj1vt4xTEhHa+g8dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gcUJK8Rx; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ab1e248aa2so1138084a91.0
        for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 11:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713464888; x=1714069688; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R1lVfxWdHMgZEl/GJ+t31bj2vLOAc95uyRSzDMDSSs8=;
        b=gcUJK8RxBPlQJ0oThEWu8gLi+vHuozTXWlVR/zfZeYB4blvYyqswvocX+jeT/dX9x4
         cKyqLC3+ID++vFeyhWudOUYu596MNcSuzv8hyShp9CCvf2zFo+FrZgO23wXlUSKqfC6h
         5jYZ69bNl6KBrJNaqPqKQsf4mh4KzUwTG+VxYNFSZ3KyW1Z0LbeSnFtuvLDUxVYzmV9q
         x9wbV9xJmTc8UHX9PJEOCUGOV2VzwBLBHFBfd+KRzMo43EenNO6IBaneXLvcjMWrwBEi
         nZDC9M6txIdOZ0etM/nGXqajLPjgEO7jN5EBF2vMkeWXWy3EadfD/TAIwnu1cuFW2FdH
         Qjsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713464888; x=1714069688;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=R1lVfxWdHMgZEl/GJ+t31bj2vLOAc95uyRSzDMDSSs8=;
        b=jrgOm7+vSDuohVT74HoHfP2jibn9VHfPXZI4Sg2zfDNH89ulI7Zx24XEfrkR6krQ6U
         vzHtazKIc6KjRR9zG6Kt3Uyxw02bEQCF1AbQgVeAv3lc455yUhrEVGc5CPtGeaVUEfpj
         25FsbaLGk3EXLBlgLkkpM6iN/aDoVpqZNpwTvtFsCRdcheMdyhiA2IERgmlKI+JyxQle
         7Be7dsaNFstIQ7Pi2nBNOs1AvlFRtOFLtdp2D56nMmAXWW5FIZRVXKv0B3g92zWit0tS
         I8wYFrU9dSYhXLLc5a15kQShPs0yX1wFBeIWr9cwBx4cG6Xmn7Xj6x0erV2AdhW6Smm0
         4qwA==
X-Forwarded-Encrypted: i=1; AJvYcCWEIP1Am3HcAJcIuD7lkLQmhv8mcibg94XXotpSz8EQOx+UKrobDMGPIBB2emIllrQ8BOxjRpcqTM0dfaIX16njYH6l
X-Gm-Message-State: AOJu0Ywikz3RujxuolmCXZsTbFo89DYdt09ewUrjnbk806WfNbX16GFq
	G3DK9RVQDRGiNSA1Bj8MCSRu+n+0PEvArZDKH9jNcgi8aeAVIYGObxozqpZDgMfwO9WQm86y1yW
	5jg==
X-Google-Smtp-Source: AGHT+IH6+dEsojfP78ePOpECHaVC9H/FxDZBqEHzlzo35Zf7DJWYV84P4QmzTSmrn+DF+gA6LVDNeaQl5WE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1914:b0:2a2:8888:807b with SMTP id
 mp20-20020a17090b191400b002a28888807bmr15304pjb.4.1713464888075; Thu, 18 Apr
 2024 11:28:08 -0700 (PDT)
Date: Thu, 18 Apr 2024 11:28:06 -0700
In-Reply-To: <61f14bc6415d5d8407fc3ae6f6c3348caa2a97e9.camel@cyberus-technology.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240416123558.212040-1-julian.stecklina@cyberus-technology.de>
 <Zh6MmgOqvFPuWzD9@google.com> <ecb314c53c76bc6d2233a8b4d783a15297198ef8.camel@cyberus-technology.de>
 <Zh6WlOB8CS-By3DQ@google.com> <c2ca06e2d8d7ef66800f012953b8ea4be0147c92.camel@cyberus-technology.de>
 <Zh6-e9hy7U6DD2QM@google.com> <adb07a02b3923eeb49f425d38509b340f4837e17.camel@cyberus-technology.de>
 <Zh_0sJPPoHKce5Ky@google.com> <Zh_4tsd5rAo4G1Lv@google.com> <61f14bc6415d5d8407fc3ae6f6c3348caa2a97e9.camel@cyberus-technology.de>
Message-ID: <ZiFmNmlUxfQnXIua@google.com>
Subject: Re: [PATCH 1/2] KVM: nVMX: fix CR4_READ_SHADOW when L0 updates CR4
 during a signal
From: Sean Christopherson <seanjc@google.com>
To: Thomas Prescher <thomas.prescher@cyberus-technology.de>
Cc: "mingo@redhat.com" <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "hpa@zytor.com" <hpa@zytor.com>, 
	Julian Stecklina <julian.stecklina@cyberus-technology.de>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "bp@alien8.de" <bp@alien8.de>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 18, 2024, Thomas Prescher wrote:
> On Wed, 2024-04-17 at 09:28 -0700, Sean Christopherson wrote:
> > On Wed, Apr 17, 2024, Sean Christopherson wrote:
> > > On Wed, Apr 17, 2024, Thomas Prescher wrote:
> > > > On Tue, 2024-04-16 at 11:07 -0700, Sean Christopherson wrote:
> > > > > Hur dur, I forgot that KVM provides a "guest_mode" stat.=C2=A0
> > > > > Userspace can do
> > > > > KVM_GET_STATS_FD on the vCPU FD to get a file handle to the
> > > > > binary stats,
> > > > > and then you wouldn't need to call back into KVM just to query
> > > > > guest_mode.
> > > > >=20
> > > > > Ah, and I also forgot that we have kvm_run.flags, so adding
> > > > > KVM_RUN_X86_GUEST_MODE would also be trivial (I almost
> > > > > suggested it
> > > > > earlier, but didn't want to add a new field to kvm_run without
> > > > > a very good
> > > > > reason).
> > > >=20
> > > > Thanks for the pointers. This is really helpful.
> > > >=20
> > > > I tried the "guest_mode" stat as you suggested and it solves the
> > > > immediate issue we have with VirtualBox/KVM.
> > >=20
> > > Note,=20
> >=20
> > Gah, got distracted.=C2=A0 I was going to say that we should add
> > KVM_RUN_X86_GUEST_MODE,
> > because stats aren't guaranteed ABI[*], i.e. relying on guest_mode
> > could prove
> > problematic in the long run (though that's unlikely).
> >=20
> > [*]
> > https://lore.kernel.org/all/CABgObfZ4kqaXLaOAOj4aGB5GAe9GxOmJmOP+7kdke6=
OqA35HzA@mail.gmail.com
>=20
> Allright. I will propose a patch that sets the KVM_RUN_X86_GUEST_MODE
> flag in the next couple of days. Do we also need a new capability for
> this flag so userland can query whether this field is actually updated
> by KVM?

Hmm, yeah, I don't see any way around that.

