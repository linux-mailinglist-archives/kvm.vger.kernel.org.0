Return-Path: <kvm+bounces-3873-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D3F4808BF0
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 16:35:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA1C5281262
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 15:35:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8A0344C9E;
	Thu,  7 Dec 2023 15:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dabbelt-com.20230601.gappssmtp.com header.i=@dabbelt-com.20230601.gappssmtp.com header.b="Vb2yv7Os"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98F2A10E4
	for <kvm@vger.kernel.org>; Thu,  7 Dec 2023 07:34:57 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id 98e67ed59e1d1-286d8dae2dbso1637005a91.1
        for <kvm@vger.kernel.org>; Thu, 07 Dec 2023 07:34:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20230601.gappssmtp.com; s=20230601; t=1701963297; x=1702568097; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nxNM9WK2tvtShQbb1K2hHNFEu7MJ8bT3CozvqGIxTXw=;
        b=Vb2yv7OsSFAJiUX8lv5KyAdhba04e7m6nZYG+42w8hABlphhKBTuxvJscSBw67MH1h
         PUBdHzzCKK6xmnJGBTY840u2mkFJaLuj0iPft8qDWj42NKrcXV3VcI9jA67k3yn5K5p5
         DEpCbusM1ZEaD1by4iC3kBSxoPv4se9ZPkWKA2w2/d91gT/bJGRdXtzBIul8wRac7b/8
         OHC83FKInWLo47OmcCSp8UCDyF8mOUQDaJ6ydVn72auj/vgNB4hQDP435w+eTx5bHeFw
         nk17fX0i9Mb08pmJbx+89TZ75bVn9RWRZyP4bi+cTl/eDaMGMptttY2t+0ySSgqQ4xzZ
         1flw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701963297; x=1702568097;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nxNM9WK2tvtShQbb1K2hHNFEu7MJ8bT3CozvqGIxTXw=;
        b=ZwY2qUqcEy2GkkvwHcdZ548Q+WPsFt/2c8YNTGmrkg0NtZD2HkF53wKYeMf3Zz5OxK
         Gq76FV1mtqHrE8lz0mitje1VDyaq+TuLuFGixg8whl7Bm0olIkLxHrDdE++gVKw7eSgx
         +jv3u1qmzuN+V2ro56t/TADD1BIKfM1wXRyuGD8tHa1MK/M/WStNvQ/S6K2b/HajjfNG
         6PJG3DC6fjYKr9m7ol787STAFMdA2FBfk1EKAKcq7QoKq9BLYFJ5/ny/POR9gUXCZ8DA
         PKbXIzr1M2UJF5sgi0r7phs2ztjQmmGOHPYEMukZjx7+7IErM6DPwn3HvHbpANqDIiux
         heYA==
X-Gm-Message-State: AOJu0YxjT2lASSm3iaMZVYaukMO+KrLHv92aQVzNmTgVKRu8RmLFxJbn
	fzg1LQp7YrgYQaHSUMhwrrI68Q==
X-Google-Smtp-Source: AGHT+IF65TZgzhTweL9gbJz3prMlwSaSPqbYrTnygSycKn7vPV8yFjNeM3gu/nqMBGL+EF94LLE7vQ==
X-Received: by 2002:a17:90b:30d7:b0:286:f3d8:de2a with SMTP id hi23-20020a17090b30d700b00286f3d8de2amr5477031pjb.45.1701963296891;
        Thu, 07 Dec 2023 07:34:56 -0800 (PST)
Received: from localhost ([12.44.203.122])
        by smtp.gmail.com with ESMTPSA id ok6-20020a17090b1d4600b00286573fc6e5sm24874pjb.4.2023.12.07.07.34.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Dec 2023 07:34:55 -0800 (PST)
Date: Thu, 07 Dec 2023 07:34:55 -0800 (PST)
X-Google-Original-Date: Thu, 07 Dec 2023 07:34:53 PST (-0800)
Subject:     Re: [PATCH 0/5] riscv: Use READ_ONCE()/WRITE_ONCE() for pte accesses
In-Reply-To: <20231002151031.110551-1-alexghiti@rivosinc.com>
CC: ryan.roberts@arm.com, glider@google.com, elver@google.com, dvyukov@google.com,
  Paul Walmsley <paul.walmsley@sifive.com>, aou@eecs.berkeley.edu, anup@brainfault.org, atishp@atishpatra.org,
  Ard Biesheuvel <ardb@kernel.org>, ryabinin.a.a@gmail.com, andreyknvl@gmail.com, vincenzo.frascino@arm.com,
  kasan-dev@googlegroups.com, linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
  kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-efi@vger.kernel.org, linux-mm@kvack.org,
  alexghiti@rivosinc.com
From: Palmer Dabbelt <palmer@dabbelt.com>
To: alexghiti@rivosinc.com
Message-ID: <mhng-079ed07b-4a53-4d32-9821-768bbb34fe58@palmer-ri-x1c9a>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

On Mon, 02 Oct 2023 08:10:26 PDT (-0700), alexghiti@rivosinc.com wrote:
> This series is a follow-up for riscv of a recent series from Ryan [1] which
> converts all direct dereferences of pte_t into a ptet_get() access.
>
> The goal here for riscv is to use READ_ONCE()/WRITE_ONCE() for all page
> table entries accesses to avoid any compiler transformation when the
> hardware can concurrently modify the page tables entries (A/D bits for
> example).
>
> I went a bit further and added pud/p4d/pgd_get() helpers as such concurrent
> modifications can happen too at those levels.
>
> [1] https://lore.kernel.org/all/20230612151545.3317766-1-ryan.roberts@arm.com/
>
> Alexandre Ghiti (5):
>   riscv: Use WRITE_ONCE() when setting page table entries
>   mm: Introduce pudp/p4dp/pgdp_get() functions
>   riscv: mm: Only compile pgtable.c if MMU
>   riscv: Suffix all page table entry pointers with 'p'
>   riscv: Use accessors to page table entries instead of direct
>     dereference
>
>  arch/riscv/include/asm/kfence.h     |   6 +-
>  arch/riscv/include/asm/kvm_host.h   |   2 +-
>  arch/riscv/include/asm/pgalloc.h    |  86 ++++++++++----------
>  arch/riscv/include/asm/pgtable-64.h |  26 +++---
>  arch/riscv/include/asm/pgtable.h    |  33 ++------
>  arch/riscv/kernel/efi.c             |   2 +-
>  arch/riscv/kvm/mmu.c                |  44 +++++-----
>  arch/riscv/mm/Makefile              |   3 +-
>  arch/riscv/mm/fault.c               |  38 ++++-----
>  arch/riscv/mm/hugetlbpage.c         |  80 +++++++++----------
>  arch/riscv/mm/init.c                |  30 +++----
>  arch/riscv/mm/kasan_init.c          | 119 ++++++++++++++--------------
>  arch/riscv/mm/pageattr.c            |  74 +++++++++--------
>  arch/riscv/mm/pgtable.c             |  71 +++++++++++------
>  include/linux/pgtable.h             |  21 +++++
>  15 files changed, 334 insertions(+), 301 deletions(-)

This has some build failures, I was just talking to Alex and he's going 
to fix them.

