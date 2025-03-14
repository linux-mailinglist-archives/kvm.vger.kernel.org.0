Return-Path: <kvm+bounces-41105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0025FA617E7
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 18:35:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 86DC21746D4
	for <lists+kvm@lfdr.de>; Fri, 14 Mar 2025 17:35:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5553A2046A2;
	Fri, 14 Mar 2025 17:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="v19CkvCi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0652054F0
	for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 17:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741973592; cv=none; b=oPzPfQgVU836YIhLYWeOnL5sV94XlYArBGEPc2v7QzcsFeuSGIjbj+pX5KqrfnwWMb+/VbCfU4Yu2mOwyIMRk2ImcVBNmc4P37KgKxEIpw7h0qzGwVdj1ZaDf5tL9IrNNGK07OiY39gkY0MdrpHjMJCmdXMx0TUjqCWLNGSEyKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741973592; c=relaxed/simple;
	bh=l73aXHmTc4+dgEpqReT2KciC+w5lREjWVFGjqNdeGz4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YfKn7uAEqANrJZ75DGPuQPtRKvifEIQpZxhT0d/mvNDT8EAXqAPI+S3PJ7LaVWJDbYd0SNiXdJVuYu1H6keCGBKYeIR4uGzaAS+DomxCfWYGWlPo0uHPaZ7UhPlgLWAFvE9GyCgtWVxIHpPzrGmyUZ2/IayyD4eEGA9uQkJA9Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=v19CkvCi; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-225b5448519so44966665ad.0
        for <kvm@vger.kernel.org>; Fri, 14 Mar 2025 10:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741973590; x=1742578390; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lfJn8ylcc7bIMXo6FULC7ghWGBlTsQARiadKWN33xhk=;
        b=v19CkvCi+J3Z0amszjMWuaLs3Lz2DQi74RWphEIunrFoj45lvmlNW4wt7KgjbGer7T
         wam6cfgSTRjlo28Tw4vgvakygz0cC0zu+hY9VIl4X4XtHacD8ebqREiS8JpUjR5OhmEN
         mcQWDJKpN9XS77S3DIwrk2uAty7gLbLvgd7QU8pUlnshWi3bT90Ih6ERt1NwwAgi2bJO
         WeHgKhErYTZTN9kabkGgWv5E5/hgTmasyi8rc9rKeoExxSxoGHH7FvV3eMTRXoMzSyLL
         BQL78ctW4tc0eszAKT0ejGRb4OObyiRItp3d4dpISSCBjqR8vTfA1QW/qxTCViuZYHia
         3/9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741973590; x=1742578390;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lfJn8ylcc7bIMXo6FULC7ghWGBlTsQARiadKWN33xhk=;
        b=krl2dDRcKFlJRsb1lgIAI4RWpM8U/bnBoNTdR7jx4f9kJXcZTNDWw9pLESJdgVvR4L
         CUNM0KOZ5jjU/seFZgaZAv8Y/O6gO5FNrJ9wZe70fEpPsb+bwTD8fAtoD3uwdenLT4QQ
         vPzSner1tEdy0hPlGVXDDhTKwlaCG5vgvWYyjPvPuTTSpV++in0oE3bsQWgiAIDANrWZ
         FRGHTpAW9/kMQq7hcBWjGvI6/5MU3Lgb4kNbpMYi65xY00Z/RhyRXZR914vfLSZfO6Lw
         UBvji5J8PjYxOsCutLvVQfm3apouVGc7J+GkT1WhSs7sVSofYvRPrTWp820VnsPrOxdF
         buXw==
X-Forwarded-Encrypted: i=1; AJvYcCUBPgI6t+yx6hkm3JTBSSGq3HmmrB1suUxhaMGsLCFgSivpStxIf4r4u1FOjSB21om2y3k=@vger.kernel.org
X-Gm-Message-State: AOJu0YyfpeyO2Ug/WHf841dmUkkUV0+Bnkay37xAKKwkKCVJNQ2r3Zq/
	saHYmCJPLeALC4Cvo9np1DD6IKldVzsU/SqOGXy42BpG9mUwzqSoc3p4azuUDNU=
X-Gm-Gg: ASbGncu7pDdUY2XZZ78KtPdYPbtVJJftc7UwO1kctUePVhYVVwZjPTajAfKMeKoxJ2M
	2GEQKv0uPzJdz+0qh441+BsDZfid6YlNZCiGQMghc15k5zxjm9lpUCzE88mJEt0fjOAAVwxLlvE
	szKZG4e73MsuRBBmh/9fzZBdkJA34pf2sHs93+qS4a3JH40DGtOfZhagInizrGTqveL3KqOEgre
	Vb7Cej+iradjV6N6IE9ZMnRgggQylKKI1ZyYKZGe7JX/oDUJg4XZbI0Vdr98vnFuCJjp0agqXGX
	uVkGiODNuL5LDvGLbXW/BIiFoDJcb8SlJey6GM5wGreypvcECaPrfkWEAA==
X-Google-Smtp-Source: AGHT+IGn7+0AN3fVzzoc32npzDlWCxdUi65DSAZ1hRH63zOg5rpmzCsnUJT+UaYhzI2QTzM024e55A==
X-Received: by 2002:a17:902:da90:b0:21f:2ded:76ea with SMTP id d9443c01a7336-225e0afa014mr36590685ad.36.1741973590244;
        Fri, 14 Mar 2025 10:33:10 -0700 (PDT)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-225c6bbe4c5sm31163235ad.192.2025.03.14.10.33.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Mar 2025 10:33:09 -0700 (PDT)
Message-ID: <5951f731-b936-42eb-b3ff-bc66ef9c9414@linaro.org>
Date: Fri, 14 Mar 2025 10:33:08 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 00/17] make system memory API available for common code
Content-Language: en-US
To: qemu-devel@nongnu.org
Cc: qemu-ppc@nongnu.org, Yoshinori Sato <ysato@users.sourceforge.jp>,
 Paul Durrant <paul@xen.org>, Peter Xu <peterx@redhat.com>,
 alex.bennee@linaro.org, Harsh Prateek Bora <harshpb@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>,
 Alistair Francis <alistair.francis@wdc.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Richard Henderson <richard.henderson@linaro.org>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 Nicholas Piggin <npiggin@gmail.com>,
 Daniel Henrique Barboza <danielhb413@gmail.com>, qemu-riscv@nongnu.org,
 manos.pitsidianakis@linaro.org, Palmer Dabbelt <palmer@dabbelt.com>,
 Anthony PERARD <anthony@xenproject.org>, kvm@vger.kernel.org,
 xen-devel@lists.xenproject.org, Stefano Stabellini <sstabellini@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Weiwei Li <liwei1518@gmail.com>
References: <20250314173139.2122904-1-pierrick.bouvier@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20250314173139.2122904-1-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

one patch is missing review:
[PATCH v5 12/17] hw/xen: add stubs for various functions.

Regards,
Pierrick

On 3/14/25 10:31, Pierrick Bouvier wrote:
> The main goal of this series is to be able to call any memory ld/st function
> from code that is *not* target dependent. As a positive side effect, we can
> turn related system compilation units into common code.
> 
> The first 5 patches remove dependency of memory API to cpu headers and remove
> dependency to target specific code. This could be a series on its own, but it's
> great to be able to turn system memory compilation units into common code to
> make sure it can't regress, and prove it achieves the desired result.
> 
> The next patches remove more dependencies on cpu headers (exec-all,
> memory-internal, ram_addr).
> Then, we add access to a needed function from kvm, some xen stubs, and we
> finally can turn our compilation units into common code.
> 
> Every commit was tested to build correctly for all targets (on windows, linux,
> macos), and the series was fully tested by running all tests we have (linux,
> x86_64 host).
> 
> v2:
> - reorder first commits (tswap change first, so memory cached functions can use it)
> - move st/ld*_p functions to tswap instead of bswap
> - add define for target_words_bigendian when COMPILING_PER_TARGET, equals to
>    TARGET_BIG_ENDIAN (avoid overhead in target code)
> - rewrite devend_memop
> - remove useless exec-all.h in concerned patch
> - extract devend_big_endian function to reuse in system/memory.c
> - rewrite changes to system/memory.c
> 
> v3:
> - move devend functions to memory_internal.h
> - completed description for commits removing cpu.h dependency
> 
> v4:
> - rebase on top of master
>    * missing include in 'codebase: prepare to remove cpu.h from exec/exec-all.h'
>    * meson build conflict
> 
> v5:
> - remove extra xen stub xen_invalidate_map_cache()
> - edit xen stubs commit message
> 
> Pierrick Bouvier (17):
>    exec/tswap: target code can use TARGET_BIG_ENDIAN instead of
>      target_words_bigendian()
>    exec/tswap: implement {ld,st}.*_p as functions instead of macros
>    exec/memory_ldst: extract memory_ldst declarations from cpu-all.h
>    exec/memory_ldst_phys: extract memory_ldst_phys declarations from
>      cpu-all.h
>    exec/memory.h: make devend_memop "target defines" agnostic
>    codebase: prepare to remove cpu.h from exec/exec-all.h
>    exec/exec-all: remove dependency on cpu.h
>    exec/memory-internal: remove dependency on cpu.h
>    exec/ram_addr: remove dependency on cpu.h
>    system/kvm: make kvm_flush_coalesced_mmio_buffer() accessible for
>      common code
>    exec/ram_addr: call xen_hvm_modified_memory only if xen is enabled
>    hw/xen: add stubs for various functions
>    system/physmem: compilation unit is now common to all targets
>    include/exec/memory: extract devend_big_endian from devend_memop
>    include/exec/memory: move devend functions to memory-internal.h
>    system/memory: make compilation unit common
>    system/ioport: make compilation unit common
> 
>   include/exec/cpu-all.h              | 66 -----------------------
>   include/exec/exec-all.h             |  1 -
>   include/exec/memory-internal.h      | 21 +++++++-
>   include/exec/memory.h               | 30 ++++-------
>   include/exec/ram_addr.h             | 11 ++--
>   include/exec/tswap.h                | 81 +++++++++++++++++++++++++++--
>   include/system/kvm.h                |  6 +--
>   include/tcg/tcg-op.h                |  1 +
>   target/ppc/helper_regs.h            |  2 +
>   include/exec/memory_ldst.h.inc      |  4 --
>   include/exec/memory_ldst_phys.h.inc |  5 +-
>   cpu-target.c                        |  1 +
>   hw/ppc/spapr_nested.c               |  1 +
>   hw/sh4/sh7750.c                     |  1 +
>   hw/xen/xen_stubs.c                  | 51 ++++++++++++++++++
>   page-vary-target.c                  |  2 +-
>   system/ioport.c                     |  1 -
>   system/memory.c                     | 17 ++----
>   target/ppc/tcg-excp_helper.c        |  1 +
>   target/riscv/bitmanip_helper.c      |  2 +-
>   hw/xen/meson.build                  |  3 ++
>   system/meson.build                  |  6 +--
>   22 files changed, 188 insertions(+), 126 deletions(-)
>   create mode 100644 hw/xen/xen_stubs.c
> 


