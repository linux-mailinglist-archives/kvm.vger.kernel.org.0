Return-Path: <kvm+bounces-47890-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E0DFAC6D31
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 17:49:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0CD89A2350D
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 15:48:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E7C528C864;
	Wed, 28 May 2025 15:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hXy6SQQu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D050C1CF96
	for <kvm@vger.kernel.org>; Wed, 28 May 2025 15:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748447329; cv=none; b=qMZG8oIjLMtJD+zlCKMjGR/qdh8cxDFUIhho9hbXMwbG4WTxHAHFjE81lB15syIYTRI/Y2JOqEBHhH0rBhdHb+Av91nYZnJFCpSYtC49PxH0RkGw5OMXxNV/cm0xkND3BN12y7JrXRuCylGeygbjY+0RUMeDj0jyK3gTZvQp5Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748447329; c=relaxed/simple;
	bh=WIlV51wEuAd2rtYOVeO8B1eFmuqdgn/T2swun7fdn7M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mRUw12wnSxfFD2mbNMNA4gZrMg/GepwXattQZJ7EMOn5Mw31ManEE/SQn2jACCLWQlFPNxvOWDBdYqsT+jicnIKxxHlR8bbvihafnhnOVSx3VJ/Hi3/79LxpNrxMEJEbkXbFlXyiWd+ZE1Du1eGLF4MeqfwY0hMJKaD8Jpld1ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hXy6SQQu; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-70e4043c5b7so178767b3.1
        for <kvm@vger.kernel.org>; Wed, 28 May 2025 08:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748447326; x=1749052126; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qJhBrTcV/2KTHPEGx8A5eIEZm9bF8mIMQSTTxnrKh3w=;
        b=hXy6SQQumd1hR4Cxd/fcVSFX4ZnarGLP7uHEpYqyvSPteonbXsnrjc1+pLD20UYR3b
         sw/lDk8cdH9JOfHmPMLmLPnXi31u+TJK1cKirGWbG96no6Aj5EgHVpDXju1ep5UM3rkW
         ESX6oZBgV4Ai1C4apsx0LG7qiHUqG0MfFMWKusoYVjza7tpgkYTv2jNuoDE0QUP28TsX
         PEqg/ym3/+fbH0RH+ljlim3nenW6LOpGtwekBKBuvZguluUojAdzEJ0vKtBIAMdZwobV
         lpvv13JqRCd78j3rz9R4BbsFraLladzbT8QMqMIezqFs3OT9NWpfwTZRfKrmsDkLjBlS
         53kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748447326; x=1749052126;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qJhBrTcV/2KTHPEGx8A5eIEZm9bF8mIMQSTTxnrKh3w=;
        b=W6ozrHriWwlwCLCQfMU6taGk8w5DVcySR+A9hCYtPWJFWpMTo25wf+D8D1yXzFsVhd
         rDUEguB9i6WiqgD9jmIOLgm0PcrQOR4+DP+mNe1krh8zNFsxolzcbnZPY/RqOJAF1m3z
         T4U5yfb+PgNck3e/h5t/QOEyEJYDIKi8jAibWEo5EhzkIP3xdwnAD35XN+Y/9UJKjZGG
         D6vGnj8op7Z6mxONQDZLMODGRGR3JklaxaIK110/nETXjlRDUHlgvH1TFfrrFGMdPcDm
         4HeSevmMcBMaUH1n4N9pXVZ4HHs4rvGOTmqclW/NJ6B9g1/QQ7bNoaJP8UuJa8IQtXr+
         yX0w==
X-Forwarded-Encrypted: i=1; AJvYcCUw0oxO4Oq8Nu1+lOKkogy5nFcSBr3BgWlH47otZdeA86+HJHVVUubWC8SSGCpYoj4nWyw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwGGzTEZ8QHyKuoCUN0mdBkFtv8hL25zk03LPa2Kr1rmPkm08rl
	yuseF0jqFsfkx4wRwTUoi8O0Wy1ZQhXfsP0OzmeIuWUPloYZLSlCBl0Oh8QyR2FNGurVl1XcJ0Z
	pW33V1CRmevIC2vvOIjKSWDN4N86r9t2UINsDSkJU
X-Gm-Gg: ASbGnctCI/6RZkNOwWz3E7Nc+/gwoWYqvS0kDZW++eKEnx7Px0VaIWsZOUCHjEHuG9X
	zKcwUGc8NN/PiBguBPPIKlyntw1pPdLyCUcz5sPe4AUYmss0NMazUwLvXickD1nLcBDoJ45Tb6M
	Kqt2B1c+4ScucQ+audW/YJtMbtwuDNOrDzDQXNAScnJIpxuMy7y8yo6gCOsZ95zX98EZQAePh9B
	M5t3g==
X-Google-Smtp-Source: AGHT+IELfFCth5Pbkc2q+fs3hGfuRfgdVh0Gdule7jkxxm4LWUKEs85HrAmHhTzH2guxXlvKX1XFjzs03oe3LxVeaz0=
X-Received: by 2002:a05:690c:c02:b0:6fb:9280:5bf4 with SMTP id
 00721157ae682-70e2da69ba1mr219329397b3.30.1748447325426; Wed, 28 May 2025
 08:48:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250109204929.1106563-1-jthoughton@google.com> <aBqlkz1bqhu-9toV@google.com>
In-Reply-To: <aBqlkz1bqhu-9toV@google.com>
From: James Houghton <jthoughton@google.com>
Date: Wed, 28 May 2025 11:48:09 -0400
X-Gm-Features: AX0GCFuLPsZ5TxH5z7efpKpwgvPpjgQZqJBp0wjKrKAAM8LNrge9ZlG7omP9Ut0
Message-ID: <CADrL8HXjLjVyFiFee9Q58TQ9zBfXiO+VG=25Rw4UD+fbDmxQFg@mail.gmail.com>
Subject: Re: [PATCH v2 00/13] KVM: Introduce KVM Userfault
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Yan Zhao <yan.y.zhao@intel.com>, 
	Nikita Kalyazin <kalyazin@amazon.com>, Anish Moorthy <amoorthy@google.com>, 
	Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>, 
	David Matlack <dmatlack@google.com>, wei.w.wang@intel.com, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 6, 2025 at 8:13=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Thu, Jan 09, 2025, James Houghton wrote:
> >   KVM: Add KVM_MEM_USERFAULT memslot flag and bitmap
> >   KVM: Add KVM_MEMORY_EXIT_FLAG_USERFAULT
> >   KVM: Allow late setting of KVM_MEM_USERFAULT on guest_memfd memslot
> >   KVM: Advertise KVM_CAP_USERFAULT in KVM_CHECK_EXTENSION
> >   KVM: x86/mmu: Add support for KVM_MEM_USERFAULT
> >   KVM: arm64: Add support for KVM_MEM_USERFAULT
> >   KVM: selftests: Fix vm_mem_region_set_flags docstring
> >   KVM: selftests: Fix prefault_mem logic
> >   KVM: selftests: Add va_start/end into uffd_desc
> >   KVM: selftests: Add KVM Userfault mode to demand_paging_test
> >   KVM: selftests: Inform set_memory_region_test of KVM_MEM_USERFAULT
> >   KVM: selftests: Add KVM_MEM_USERFAULT + guest_memfd toggle tests
> >   KVM: Documentation: Add KVM_CAP_USERFAULT and KVM_MEM_USERFAULT
> >     details
> >
> >  Documentation/virt/kvm/api.rst                |  33 +++-
> >  arch/arm64/kvm/Kconfig                        |   1 +
> >  arch/arm64/kvm/mmu.c                          |  26 +++-
> >  arch/x86/kvm/Kconfig                          |   1 +
> >  arch/x86/kvm/mmu/mmu.c                        |  27 +++-
> >  arch/x86/kvm/mmu/mmu_internal.h               |  20 ++-
> >  arch/x86/kvm/x86.c                            |  36 +++--
> >  include/linux/kvm_host.h                      |  19 ++-
> >  include/uapi/linux/kvm.h                      |   6 +-
> >  .../selftests/kvm/demand_paging_test.c        | 145 ++++++++++++++++--
> >  .../testing/selftests/kvm/include/kvm_util.h  |   5 +
> >  .../selftests/kvm/include/userfaultfd_util.h  |   2 +
> >  tools/testing/selftests/kvm/lib/kvm_util.c    |  42 ++++-
> >  .../selftests/kvm/lib/userfaultfd_util.c      |   2 +
> >  .../selftests/kvm/set_memory_region_test.c    |  33 ++++
> >  virt/kvm/Kconfig                              |   3 +
> >  virt/kvm/kvm_main.c                           |  54 ++++++-
> >  17 files changed, 419 insertions(+), 36 deletions(-)
>
> I didn't look at the selftests changes, but nothing in this series scares=
 me.  We
> bikeshedded most of this death this in the "exit on missing" series, so f=
or me at
> least, the only real question is whether or not we want to add the uAPI. =
 AFAIK,
> this is best proposal for post-copy guest_memfd support (and not just bec=
ause it's
> the only proposal :-D).

The only thing that I want to call out again is that this UAPI works
great for when we are going from userfault --> !userfault. That is, it
works well for postcopy (both for guest_memfd and for standard
memslots where userfaultfd scalability is a concern).

But there is another use case worth bringing up: unmapping pages that
the VMM is emulating as poisoned.

Normally this can be handled by mm (e.g. with UFFDIO_POISON), but for
4K poison within a HugeTLB-backed memslot (if the HugeTLB page remains
mapped in userspace), KVM Userfault is the only option (if we don't
want to punch holes in memslots). This leaves us with three problems:

1. If using KVM Userfault to emulate poison, we are stuck with small
pages in stage 2 for the entire memslot.
2. We must unmap everything when toggling on KVM Userfault just to
unmap a single page.
3. If KVM Userfault is already enabled, we have no choice but to
toggle KVM Userfault off and on again to unmap the newly poisoned
pages (i.e., there is no ioctl to scan the bitmap and unmap
newly-userfault pages).

All of these are non-issues if we emulate poison by removing memslots,
and I think that's possible. But if that proves too slow, we'd need to
be a little bit more clever with hugepage recovery and with unmapping
newly-userfault pages, both of which I think can be solved by adding
some kind of bitmap re-scan ioctl. We can do that later if the need
arises.

> So... yes?

Thanks Sean!

> Attached are a variation on the series using the common "struct kvm_page_=
fault"
> idea.  The documentation change could be squashed with the final enableme=
nt patch.
>
> Compile tested only.  I would not be the least bit surprised if I complet=
ely
> butchered something.

Looks good! The new selftests work just fine.

