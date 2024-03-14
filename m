Return-Path: <kvm+bounces-11814-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 854F087C2E1
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 19:38:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 24CB11F21BC3
	for <lists+kvm@lfdr.de>; Thu, 14 Mar 2024 18:38:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A19B774E11;
	Thu, 14 Mar 2024 18:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dZ0Pu03x"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525E51E480
	for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 18:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710441491; cv=none; b=IBGbhAGe3a/HdY/NKxzqx+jLJBaaqQCduhzCW37G0TEqwOGNnkw9Ph7XovytdMwPAMC5F1+/M0bRSzt5q8Z4o/o5fBtxF31f3ZbD5T2GseyQW4PdovzLka4yNGAVkmriKRSsIO7N4tG8maFD6NnEQPPfJi2nOt1HzfCvAQ1gA34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710441491; c=relaxed/simple;
	bh=Sy3Ocyywo4dC2ab/PEmi6xwF/x3KCht5GPnpxYBLfdY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=eY+vRH2hzRBk2Ujrv5DR/qb+OZ/yLb/2pZQYPAU7IoAT/QRu3Ni7Tinwld52GN6wfArKA+kD4PPxOJa+6X7c6f9WUZ95zyAtryP13rHak+licXmxasIx8ZpMQSmTh2D52SNFSAiLfKP9iHpNAqZIucJoumvfyYkjqZdIjR4NPz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dZ0Pu03x; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-60a0b18e52dso15302397b3.1
        for <kvm@vger.kernel.org>; Thu, 14 Mar 2024 11:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710441489; x=1711046289; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1XYJ7yiCtpnjjL7rWLIdC2OAlAqP3qehoMMVqNfcku0=;
        b=dZ0Pu03xfi4x7+l668oqOi1tCkXCQEYPVWdYJCZF5aspNKXaJ7BvE5tOG2R+t4KVgk
         qWCMWcmjzX6gDQqySusKh9AAuQMxXgBb03TNu+A22xDbV1LwDUGq7EAcwkvkDPRFAQ27
         79MH9pLwDHIPHxwAL4FtVWxQvmebfu3LwVEn+ZfM+1L046dwNbce1rtj4s97EQyc40DO
         RZ3ezHRvgH0wbrEoGNPFqmgdkU3HCbwfY/OzZVaJoNKG6kBt7MRDL5CijHJnleRXZeo9
         /cWj+Z0itEXB5laFsdMnCuy+StGIIJMcdfwQdtth8bUBvoy//ylK2OKmaXGun87rEqyD
         9cYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710441489; x=1711046289;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1XYJ7yiCtpnjjL7rWLIdC2OAlAqP3qehoMMVqNfcku0=;
        b=iMPwCLT/Ix3PiBogO6JfC1j1qj8i3/P3Y4Zzk9BT2WyWlOVan5GywwIY302ZfZXypi
         WWP3gC611WhdVO6eJWZbx7IHIZMQl4G436BsAb631Um4c2i6N1PFq2ktfcgl7O78S2Wf
         Civ2b+VzX/qmFUovT376hrQgYjuvJLK4mIaT4233r+9Bfigex/4csraeo4hIoIs/0nis
         fsbmSka4nsKOyhX6NwvSRijoYpBNsgIcDv9f/oJSv8fVg0n5KVCD8tEUyJmOBHC+7Yl/
         7+B5UIy56oOega8+OHBG75pGp2YIKldCJKcJjPWghlNcWrzCLLH6zYfLLHxtrt495eC/
         wRKw==
X-Gm-Message-State: AOJu0YwxbQ6uiGmPI0rc8aDae26U1zQ140TPO4hGSSyUcvZkzt1k2PXm
	9O6b25pEg8qG2yjW3TF/7HTMeFGD0SfvpTLhTVQzBpYQkKgN+Uny3VCMTpEj11bYusppnJ53m5e
	z0g==
X-Google-Smtp-Source: AGHT+IG0og3Q54ZAyEcdVlCBcIhLJRcWqFxI19oMJyI6eSeU5q6zLIISJPiN9kZgNCQNUie7WtclvNy+An4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:4e8a:0:b0:60a:3c86:f1ea with SMTP id
 c132-20020a814e8a000000b0060a3c86f1eamr1613279ywb.2.1710441489435; Thu, 14
 Mar 2024 11:38:09 -0700 (PDT)
Date: Thu, 14 Mar 2024 11:38:08 -0700
In-Reply-To: <CABgObfa3By9GU9_8FmqHQK-AxWU3ocbBkQK0xXwx2XRDP828dg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240308223702.1350851-1-seanjc@google.com> <20240308223702.1350851-5-seanjc@google.com>
 <CABgObfa3By9GU9_8FmqHQK-AxWU3ocbBkQK0xXwx2XRDP828dg@mail.gmail.com>
Message-ID: <ZfNEEFmTkx-RVuix@google.com>
Subject: Re: [GIT PULL] KVM: x86: MMU changes for 6.9
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 14, 2024, Paolo Bonzini wrote:
> On Fri, Mar 8, 2024 at 11:37=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> >  - Zap TDP MMU roots at 4KiB granularity to minimize the delay in yield=
ing if
> >    a reschedule is needed, e.g. if a high priority task needs to run.  =
Because
> >    KVM doesn't support yielding in the middle of processing a zapped no=
n-leaf
> >    SPTE, zapping at 1GiB granularity can result in multi-millisecond la=
g when
> >    attempting to schedule in a high priority.
> >
>=20
> Would 2 MiB provide a nice middle ground?

Not really?

Zapping at 2MiB definitely fixes the worst of the tail latencies, but there=
 is
still a measurable difference between 2MiB and 4KiB.  And on the other side=
 of the
coing, I was unable to observe a meaningful difference in total runtime by =
zapping
at 2MiB, or even 1GiB, versus 4KiB.

In other words, AFAICT, there's no need to shoot for a middle ground becaus=
e trying
to zap at larger granularities doesn't buy us anything.

