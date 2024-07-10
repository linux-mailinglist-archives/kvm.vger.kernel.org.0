Return-Path: <kvm+bounces-21291-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EC5D92CDC6
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 11:00:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E813B1F267AF
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2024 09:00:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8356D17C7BD;
	Wed, 10 Jul 2024 08:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DMSCRBEe"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A835517B516;
	Wed, 10 Jul 2024 08:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720601962; cv=none; b=EpCpmpN7P72Mr9B888zlJxg6LrGKv2QIIcdwCqCIFkS0ywoLGdpYkxGc6o4gkjf/Ip5axi1SILtE2IGErUWmpjKmrFVv9rG7MfmseX9xBuQD/ic8dNGES+ESWhnk4JoAqf6IB+GtAKGxZeKhgpfm9MkA3pUfwt2248ahDDkefXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720601962; c=relaxed/simple;
	bh=7wKktnoDzEHozPgtg1T55fHPeoBJ/8cTfIxSsiSqOaE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oJrUfF5DnRkszYu0a5o2aAWVLNz1W7SR2bihpFD74XQI3/0beVrFAHPARbckAD8xh3M0Vlza0XLdlM4c/sI4RMB0zKhXEBe0WEdUG3b6J2UGNqzoOJkUrsfgy/BZeBnjG8dPFvS6Bc8Z/fWbBkbmT0XYSaRqck7DMKi7+sPuBtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DMSCRBEe; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65E6FC32786;
	Wed, 10 Jul 2024 08:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720601962;
	bh=7wKktnoDzEHozPgtg1T55fHPeoBJ/8cTfIxSsiSqOaE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=DMSCRBEe0whr7fL9tq+38yscSACyliQopgxbJRMqcLvyemr2jT1dGy2EN6kayv/r9
	 CDMSX6SbYImNJUAdVLqdvtr8P9Jb2OG9ZQD0joIolDAql/j9rWll2IfPfqq/1WLJ0B
	 ZidRqEGNseNsVtztHldY9I4gxf0/TOVxLBQ9/aB2dnZBCc/SNUdyleU9SQNih6GRlD
	 yxrPq1ib82xS77spPf8gEYwg9jrsiXc15wgdBEHM8CW6Vhf2v5CFNfRZ5FwyIC1eJa
	 KZ9WkQn7/bB7ScpSQYJZJEChkUhEudVqwTuJnGyb9VkLUNG0MWpMwz+sbAic9mo1h1
	 TGU6axLnfOMgA==
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2ee920b0781so58363871fa.1;
        Wed, 10 Jul 2024 01:59:22 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUjOV9ClxU+VuL9jK1Qj1HZYiqxVe3o2pxbnjsDDEeEmxldahQjFSL8PzpMovobJlKkz2GHj0Qwvl3KyRzYM5RsDXNycBZrWNPC7p6kockhy40Qb7tFZQ9BKeV43MtOb6nA
X-Gm-Message-State: AOJu0YzWCefW9gabXSTD0MhAyOPhENKUsosEAS5t6PTmr1xECYeH8UvY
	IPRAp83vAFlgxZ16Fgje+6shtBnEZ/q5ZWqSkkeQsStbrbXQJ/LcgVmCz0n71GaPGSmCDpwM447
	qqo1hDM1CaeIyNmKu1OskZggC6B8=
X-Google-Smtp-Source: AGHT+IGsjes5a9AyumKXYwEMmmWurniv473koxkLgYFhknWuqWsxKVxqzo8eCGX8IVMnocNH2St8Lj2r5J2E/0NJiPc=
X-Received: by 2002:a05:651c:200f:b0:2ee:8555:4742 with SMTP id
 38308e7fff4ca-2eeb30fe842mr27104411fa.27.1720601960688; Wed, 10 Jul 2024
 01:59:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240710084630.2553263-1-chenhuacai@loongson.cn>
In-Reply-To: <20240710084630.2553263-1-chenhuacai@loongson.cn>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Wed, 10 Jul 2024 16:59:08 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7LKccn4s=8Wm-AaXYMJLzMMCSyLVgh7D0yQ_0uu+59QQ@mail.gmail.com>
Message-ID: <CAAhV-H7LKccn4s=8Wm-AaXYMJLzMMCSyLVgh7D0yQ_0uu+59QQ@mail.gmail.com>
Subject: Re: [GIT PULL] LoongArch KVM changes for v6.11
To: Huacai Chen <chenhuacai@loongson.cn>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
	Bibo Mao <maobibo@loongson.cn>, kvm@vger.kernel.org, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Xuerui Wang <kernel@xen0n.name>, 
	Jiaxun Yang <jiaxun.yang@flygoat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Paolo,

I'm sorry, a typo is found in the last patch "Fecth" vs "Fetch",
please ignore this PR and I will submit a new one later.

Huacai

On Wed, Jul 10, 2024 at 4:46=E2=80=AFPM Huacai Chen <chenhuacai@loongson.cn=
> wrote:
>
> The following changes since commit 256abd8e550ce977b728be79a74e1729438b49=
48:
>
>   Linux 6.10-rc7 (2024-07-07 14:23:46 -0700)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/chenhuacai/linux-loongson=
.git tags/loongarch-kvm-6.11
>
> for you to fetch changes up to b3403f8d3c3fd8398bb5f23fe4f69faa738f1399:
>
>   perf kvm: Add kvm-stat for loongarch64 (2024-07-09 16:25:51 +0800)
>
> ----------------------------------------------------------------
> LoongArch KVM changes for v6.11
>
> 1. Add ParaVirt steal time support.
> 2. Add some VM migration enhancement.
> 3. Add perf kvm-stat support for loongarch.
>
> ----------------------------------------------------------------
> Bibo Mao (10):
>       LoongArch: KVM: Sync pending interrupt when getting ESTAT from user=
 mode
>       LoongArch: KVM: Delay secondary mmu tlb flush until guest entry
>       LoongArch: KVM: Select huge page only if secondary mmu supports it
>       LoongArch: KVM: Discard dirty page tracking on readonly memslot
>       LoongArch: KVM: Add memory barrier before update pmd entry
>       LoongArch: KVM: Add dirty bitmap initially all set support
>       LoongArch: KVM: Mark page accessed and dirty with page ref added
>       LoongArch: KVM: Add PV steal time support in host side
>       LoongArch: KVM: Add PV steal time support in guest side
>       perf kvm: Add kvm-stat for loongarch64
>
> Jia Qingtong (1):
>       LoongArch: KVM: always make pte young in page map's fast path
>
>  Documentation/admin-guide/kernel-parameters.txt |   6 +-
>  arch/loongarch/Kconfig                          |  11 ++
>  arch/loongarch/include/asm/kvm_host.h           |  13 ++
>  arch/loongarch/include/asm/kvm_para.h           |  11 ++
>  arch/loongarch/include/asm/kvm_vcpu.h           |   5 +
>  arch/loongarch/include/asm/loongarch.h          |   1 +
>  arch/loongarch/include/asm/paravirt.h           |   5 +
>  arch/loongarch/include/uapi/asm/kvm.h           |   4 +
>  arch/loongarch/kernel/paravirt.c                | 145 ++++++++++++++++++=
++++
>  arch/loongarch/kernel/time.c                    |   2 +
>  arch/loongarch/kvm/Kconfig                      |   1 +
>  arch/loongarch/kvm/exit.c                       |  38 +++++-
>  arch/loongarch/kvm/main.c                       |   1 +
>  arch/loongarch/kvm/mmu.c                        |  72 +++++++----
>  arch/loongarch/kvm/tlb.c                        |   5 +-
>  arch/loongarch/kvm/vcpu.c                       | 154 ++++++++++++++++++=
+++++-
>  tools/perf/arch/loongarch/Makefile              |   1 +
>  tools/perf/arch/loongarch/util/Build            |   2 +
>  tools/perf/arch/loongarch/util/header.c         |  96 +++++++++++++++
>  tools/perf/arch/loongarch/util/kvm-stat.c       | 139 ++++++++++++++++++=
+++
>  20 files changed, 680 insertions(+), 32 deletions(-)
>  create mode 100644 tools/perf/arch/loongarch/util/header.c
>  create mode 100644 tools/perf/arch/loongarch/util/kvm-stat.c

