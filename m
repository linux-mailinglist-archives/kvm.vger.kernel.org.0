Return-Path: <kvm+bounces-21041-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B02B928526
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 11:34:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6D1861C24F4F
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2024 09:34:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0B45146A89;
	Fri,  5 Jul 2024 09:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P6rLgX99"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2AC135A69;
	Fri,  5 Jul 2024 09:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720172042; cv=none; b=FOxUrFVU22uLv7EJYwY8CmGk1pE+5e5n5MtvDA24QAKFOqNRZFZzgwTK9ehhoF2mrDfejNO5L46etlvPll4/Xc8cG0D5H9DgZfGBjJiVTTIt+z6LzYwVR5Kd040G1QYvp/biZGe79Uq/J5WaKpBqHdOX24d3qjnskQVjfr4ch1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720172042; c=relaxed/simple;
	bh=//R3KJ2TmEUALF2xuwB2dmF10o7ZvOnc4OH75BUi3nA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NuYMBOFYFe+Xz8oEWQgKqNh/EcDx3xbU8kAM8bIXjdkJX9gOoLfLLZRrTwQSQv+KChMRAVypaeRTvU6L6k9bTvKP9D/ynG/oEfZfvYUdy7xizvg8p5n9N+FfWtamuLbmKNNG4O/H0aTN+mnwvzoFUYHbwsDu6sV0Q9e/nBoBrig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P6rLgX99; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 675E4C4AF0B;
	Fri,  5 Jul 2024 09:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720172042;
	bh=//R3KJ2TmEUALF2xuwB2dmF10o7ZvOnc4OH75BUi3nA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=P6rLgX99HiBLWg81cA1IJQWfn1CzGaskGIxlxDIjwiZsBxaSXYsKV7zmUHipLEqC5
	 V9lRTIeVyZVzUIgF33Z9vpN2oLoE3j/GzVAKhiDMoIkLU6hTU+qxIkEZnp4H2kQnDM
	 VI9WIHsc9JCiv+XQRhHUhBm1IZdVOYmfomT8ga9bdB+LcWuP3IPJHGdO/GFfR1eleC
	 zXCcgA5pp2AIv+FIpaGoj61m8oo2JmbjQLYFvQprwnp3yrBjjCokh8EyOaZsXJICAB
	 nHlXvdvXpUnXl8oFnQ6dFSJmkMbKhzEHxbIXLepIzDDWwqSVgUqPtaLoO4Kq8mETzN
	 rmdaBR7CMtjXw==
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-57ccd1111b0so1039734a12.3;
        Fri, 05 Jul 2024 02:34:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVovcJFmeHd6ryRCdnLQgEU6fQkYj/HH3afYNf5klUg2feoMwmACgqzbXpLCTP+NLLpWuZLE8SCGtH8t/JB7Ii9ohFHXXQSDDOfraZcHmIDIIYxPNN9kKBsVQtmtZoZQ3HP
X-Gm-Message-State: AOJu0YwEDpKXJAH3JmJWjcW2Wzoqr52Nj+gSzB8wnKj6qsmFKHKQtWxy
	SCFeKNPx072Ed0QINXt7CeADLEpEzx/jNnWWqWtZtqOTRNOuZTbitZ5EHVyUvZMvJwgk065M73q
	CILmDjuv19FYJIYjnBi84FNe3BsI=
X-Google-Smtp-Source: AGHT+IFb2JnXJEpZ/8ZNLh3sUIwAnpsOHgPBjHuN17UBwVrsYs5tsKVu3GpfDIgPIRcizOeSQcGzoENl7XHq7IPf16s=
X-Received: by 2002:a05:6402:4312:b0:58f:44fa:a2b9 with SMTP id
 4fb4d7f45d1cf-58f44faa6c8mr1770485a12.16.1720172040928; Fri, 05 Jul 2024
 02:34:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240624071422.3473789-1-maobibo@loongson.cn>
In-Reply-To: <20240624071422.3473789-1-maobibo@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Fri, 5 Jul 2024 17:33:48 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4FSKo2+go0aW_4-a06q2FA4cNL_ksSNZoKzd=r+TSykw@mail.gmail.com>
Message-ID: <CAAhV-H4FSKo2+go0aW_4-a06q2FA4cNL_ksSNZoKzd=r+TSykw@mail.gmail.com>
Subject: Re: [PATCH v3 0/7] LoongArch: KVM: VM migration enhancement
To: Bibo Mao <maobibo@loongson.cn>
Cc: Tianrui Zhao <zhaotianrui@loongson.cn>, WANG Xuerui <kernel@xen0n.name>, 
	Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, WANG Rui <wangrui@loongson.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Series applied, thanks.

Huacai

On Mon, Jun 24, 2024 at 3:14=E2=80=AFPM Bibo Mao <maobibo@loongson.cn> wrot=
e:
>
> This patchset is to solve VM migration issues, the first six patches are
> mmu relative, the last patch is relative with vcpu interrupt status.
>
> It fixes potential issue about tlb flush of secondary mmu and huge page
> selection etc. Also it hardens LoongArch kvm mmu module.
>
> With this patchset, VM successfully migrates on my 3C5000 Dual-Way
> machine with 32 cores.
>  1. Pass to migrate when unixbench workload runs with 32 vcpus, for
> some unixbench testcases there is much IPI sending.
>  2. Pass to migrate with kernel compiling with 8 vcpus in VM
>  3. Fail to migrate with kernel compiling with 32 vcpus in VM, since
> there is to much memory writing operation, also there will be file
> system inode inconsistent error after migration.
>
> ---
> v2 ... v3:
>  1. Merge patch 7 into this patchset since it is relative with VM
> migration bugfix.
>  2. Sync pending interrupt when getting ESTAT register, SW ESTAT
> register is read after vcpu_put().
>  3. Add notation about smp_wmb() when update pmd entry, to elimate
> checkpatch warning.
>  4. Remove unnecessary modification about function kvm_pte_huge()
> in patch 2.
>  5. Add notation about secondary mmu tlb since it is firstly used here.
>
> v1 ... v2:
>  1. Combine seperate patches into one patchset, all are relative with
> migration.
>  2. Mark page accessed without mmu_lock still, however with page ref
> added
> ---
> Bibo Mao (7):
>   LoongArch: KVM: Delay secondary mmu tlb flush until guest entry
>   LoongArch: KVM: Select huge page only if secondary mmu supports it
>   LoongArch: KVM: Discard dirty page tracking on readonly memslot
>   LoongArch: KVM: Add memory barrier before update pmd entry
>   LoongArch: KVM: Add dirty bitmap initially all set support
>   LoongArch: KVM: Mark page accessed and dirty with page ref added
>   LoongArch: KVM: Sync pending interrupt when getting ESTAT from user
>     mode
>
>  arch/loongarch/include/asm/kvm_host.h |  5 ++
>  arch/loongarch/include/asm/kvm_mmu.h  |  2 +-
>  arch/loongarch/kvm/main.c             |  1 +
>  arch/loongarch/kvm/mmu.c              | 67 ++++++++++++++++++++-------
>  arch/loongarch/kvm/tlb.c              |  5 +-
>  arch/loongarch/kvm/vcpu.c             | 29 ++++++++++++
>  6 files changed, 86 insertions(+), 23 deletions(-)
>
>
> base-commit: 50736169ecc8387247fe6a00932852ce7b057083
> --
> 2.39.3
>
>

