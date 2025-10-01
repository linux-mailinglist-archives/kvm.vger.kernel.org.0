Return-Path: <kvm+bounces-59296-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 42262BB0B03
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 16:23:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 529FA7B06BE
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 14:21:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D6992EACF8;
	Wed,  1 Oct 2025 14:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gdW/Z6nF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46AFC25DB1A
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 14:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759328590; cv=none; b=GTV+RT5zMY+tvq4XiLghOwEKtjAB4ZOU3tbgEiUsQMB0nq0h98BRp2cnr/BrqfG2kdG5Q6+bcqsv57UFdIACY+qdJ5APc1fT6YBEciNg6fC9a75tZVXpurkeWhBn0Lijpm7ZGTDrvHAAtBCJCUA6J0Es9EjbaubHKSkUbdVH6is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759328590; c=relaxed/simple;
	bh=FmtIBDf5zkip6g4eD/UswZPBKwOpkuCPfzBvxBmzoQ8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OeTThMtuWeAyfVgnjaOJsdw9q+i00ma8p8VaKI6CYqEBvXRKUW1fbLCWULnK9tVpKJXgWkN4KI3BDPQwsJ4gZbCFCUBlbQy2TMCTGesV+QAwSG2QbqL92lUZhNwgux17JCEOF8y/7bFkNdJH0Bs54xtRkq8tncoc4XrMkdOgaO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gdW/Z6nF; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-27d67abd215so224915ad.0
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 07:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759328587; x=1759933387; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IRDU21uoioJAyRtmdoNLfN5ywa86kEkXqLJeusadAtI=;
        b=gdW/Z6nFLRNc4cAm1wrmorxHwQiAEeA6CEMmmZFMoFH7iQaiE7CdVb3SCEmKbrACX3
         yh7X3cB3QpmsAAYdItjp8HHjJ5DsQhko1qDwxRQ2qh9RLghBlUo6Wnktvvt+VThSM+2S
         aM5aCj6W0tEGW/ue/cMXv3BHj0IjQ+HQMtWN6sEgjNHiLA0ar5a0xTd15IpA7st66D5p
         SKYoTEE4yxFyIVz6n4QHrPPyifOsgD9sFWbaHK4S/JkvuxlSdhI2LYuBkZqKfHejVDpc
         FAJzU1j9kdV7KWbsHxuFLXsMkk0md6jH93AlLp+1aEBhu/xCHKQXNh6YGWo+BO1SyZMR
         p3Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759328587; x=1759933387;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IRDU21uoioJAyRtmdoNLfN5ywa86kEkXqLJeusadAtI=;
        b=W33nlfgCKbgch/9IifuO8RQzmqkeBWIs6a5IPoD7AykdhM0KpYvhBxkBNNhOqz065+
         WzctF3fklX7iNgKQRKXpATtjPKE/aPpIqLDJmh+lHxXPjXR/TF48MyQz6uZ3CZ7lYw2u
         QMmzWHdBUuoC01JleTtQzjerNmRVPggsHHJhpfzHvF3Y2kYrtIBWEgkqPc66PdC/TNyc
         4J104XQIwzYNyT7JZJjSl8hAGBAWGSNbCB+U574DNRV+n3z+thdSnEjukFX2iKp68U4u
         HVm74Cfe28AaIPJPN7XupvfhA7KS4JeFb9ASBjMSZ+YlABQolKCJlvGMhXbT4awmmWWd
         q9lg==
X-Forwarded-Encrypted: i=1; AJvYcCVUGLBMSJ0Ti8Z1+A8h3gt7EXBIlwVYl1urqzjogWuMFz/elErnNAcg1ffhxpKbmxpjpU0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzEI+e8Hso4PKDYlycEPAIOUOaVc9sRd8ESBi2Y5n2naAuAyntz
	9AOO2YBIkqiSu79iZQX4nTP74siKaw7BVMVFfYlgVQcv+4VSWuy/Nlc2yHBKQCCMzuRG1d+pnMs
	bfFRkXsMiCwhj/Pgk99Q1RNUjUr0zoyVjjeCPBTiY
X-Gm-Gg: ASbGnctQdKcZ94jCikff7DX03TWFVmAWKDK9Q5S7zbo8QAWAGVZNw1RAMsQRBXrWwKc
	nNUOwRJGeBM2heobOMnYgliC4iFUPBTeUVL0gxG8jZAhqijByQm7X7oAYWG3gVlQDgbSo0JRyJ0
	0iaEPONA/B50Pi/n9LkJfXx6XRHL+qSttw0Y47KQWLlTzmh7862AdSXzYR1DGxUVMpLf6bDkqIC
	RZFk05C9sIWM+RwNP1RhkzfmlLRBoz6sft9ha7DnluNhcPCSv1sso99eX4zEjJLS3InXwYQXgoR
	qXn4BA==
X-Google-Smtp-Source: AGHT+IFjNi8Io1yPUrwHGeOkJcDsUObFSv7z+2KeefYqjzChvcYJ2tFoLRup7oLYrJhe7J5OIZo+sAxoga+39UD3Lok=
X-Received: by 2002:a17:903:1aac:b0:27e:e96a:4c6 with SMTP id
 d9443c01a7336-28e7fdd7471mr5306875ad.2.1759328587100; Wed, 01 Oct 2025
 07:23:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250926163114.2626257-1-seanjc@google.com> <20250926163114.2626257-2-seanjc@google.com>
 <CA+EHjTzdX8+MbsYOHAJn6Gkayfei-jE6Q_5HfZhnfwnMijmucw@mail.gmail.com>
 <diqz7bxh386h.fsf@google.com> <a4976f04-959d-48ae-9815-d192365bdcc6@linux.dev>
 <d2fa49af-112b-4de9-8c03-5f38618b1e57@redhat.com> <diqz4isl351g.fsf@google.com>
 <aNq6Hz8U0BtjlgQn@google.com> <aNshILzpjAS-bUL5@google.com>
In-Reply-To: <aNshILzpjAS-bUL5@google.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Wed, 1 Oct 2025 07:22:54 -0700
X-Gm-Features: AS18NWDxYGbjgzSZArzj-LO4RB9noYp5lSx-_UA5Ump9xA5S6PZGo7guXq4xoNo
Message-ID: <CAGtprH_JgWfr2wPGpJg_mY5Sxf6E0dp5r-_4aVLi96To2pugXA@mail.gmail.com>
Subject: Re: [PATCH 1/6] KVM: guest_memfd: Add DEFAULT_SHARED flag, reject
 user page faults if not set
To: Sean Christopherson <seanjc@google.com>
Cc: Ackerley Tng <ackerleytng@google.com>, David Hildenbrand <david@redhat.com>, 
	Patrick Roy <patrick.roy@linux.dev>, Fuad Tabba <tabba@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Nikita Kalyazin <kalyazin@amazon.co.uk>, shivankg@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 29, 2025 at 5:15=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> Oh!  This got me looking at kvm_arch_supports_gmem_mmap() and thus
> KVM_CAP_GUEST_MEMFD_MMAP.  Two things:
>
>  1. We should change KVM_CAP_GUEST_MEMFD_MMAP into KVM_CAP_GUEST_MEMFD_FL=
AGS so
>     that we don't need to add a capability every time a new flag comes al=
ong,
>     and so that userspace can gather all flags in a single ioctl.  If gme=
m ever
>     supports more than 32 flags, we'll need KVM_CAP_GUEST_MEMFD_FLAGS2, b=
ut
>     that's a non-issue relatively speaking.
>

Guest_memfd capabilities don't necessarily translate into flags, so ideally=
:
1) There should be two caps, KVM_CAP_GUEST_MEMFD_FLAGS and
KVM_CAP_GUEST_MEMFD_CAPS.
2) IMO they should both support namespace of 64 values at least from the ge=
t go.
3) The reservation scheme for upstream should ideally be LSB's first
for the new caps/flags.

guest_memfd will achieve multiple features in future, both upstream
and in out-of-tree versions to deploy features before they make their
way upstream. Generally the scheme followed by out-of-tree versions is
to define a custom UAPI that won't conflict with upstream UAPIs in
near future. Having a namespace of 32 values gives little space to
avoid the conflict, e.g. features like hugetlb support will have to
eat up at least 5 bits from the flags [1].

[1] https://elixir.bootlin.com/linux/v6.17/source/include/uapi/asm-generic/=
hugetlb_encode.h#L20

