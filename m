Return-Path: <kvm+bounces-40967-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EFFEA5FC53
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 17:43:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F16F718980FE
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 16:43:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2E04269AF5;
	Thu, 13 Mar 2025 16:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="q5/I3J6W"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808C32676FD
	for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 16:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741884164; cv=none; b=BBI+MpMzfftERGDSgXxWvAKyx1JeOWZPAOmsQOilsLcdmGI90TC48wWedNtDp0gZSzAQjmCuBGGBYa1yulHfnHIqmVDPLWifp+faNpwSd0ubw+FdzfqNnnXxe5uBNJLBVxdARf+bcx9+DrngmjiTpKa5pQzxCA/iU/BsWzWgKts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741884164; c=relaxed/simple;
	bh=gCyx909i/VmdGR3y+oGr5MxeGns+Q7mtyAvdPenaCS8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KmTxaNmQb71A+CCanwKEyStiYHqcFCZw/tf88Ukrcmk+Vbk0dvCMY+BO7k1KydE8ApQRknHBjuSrzGYduhVNAmKn582RCnHznQRe9rq/bSgKwb7w5m7agd+UtBFwH6DeilhGPZX/z/1/pIvX9yjMbZAFA463tGcV6v0V0qK6UyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=q5/I3J6W; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-223fd89d036so26248445ad.1
        for <kvm@vger.kernel.org>; Thu, 13 Mar 2025 09:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741884162; x=1742488962; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mEeJf1jLjksxcxRMyFkwRUHHzj+nso1co+jY2XBogVQ=;
        b=q5/I3J6WB+kDeBqX7lB4/kjqC90z+pR5O9iILhntJBPLxAFvJumvOMVrP91Uy2afo/
         UT6HLog55EQ6SdhlAdOVvVysI6odXL+9ADV74FE7Ct78CmYKf5tadXfcL3693Rg1pHOU
         Tcm99hkPLrKlRBFT6Oa3GOfZLZf8itgYZaco60hNzsfMgxLYHnWIcmqE/c+W4+LszYUW
         lkjm/tx4JJQWXpEgFxLTTL1EHUfCFrGPzjz93c5nxxPldRPWfQMMCKQ5K6Oc2Mu4LaGl
         bi/F5HZaMx0lf1eDZtLkRJ2f7CivtJOxF6IIQbY48K8vyxoj7cNeCSEy7yDEj7xrtVa3
         Qu5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741884162; x=1742488962;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mEeJf1jLjksxcxRMyFkwRUHHzj+nso1co+jY2XBogVQ=;
        b=j/MLA8Whu7NyGe46AUEd9TMIiyFDb0nFDnspzBa83JES6cablNTYLP7eE7ORGsGmJi
         GoKz0/sRd6uNHCgX91UDTuy1bD6I5beACZbvs9eKO4qUSW3TlDMGxEYRyYpSqxKFp6nV
         +8LTH0Lz+eJU8aghakCm2FLRq1uCNCnzGlyFeKba16hLqJUcpeHwUy9ZSIPDsTZ5k3UY
         OHoxxc2GJMOhK6qh9ygoPVHebnW/Y/K5cq/mDGfFeHmTzLkBUHSDO7kHmc1ZX2/3xvU7
         nPAUrVhvhz6J4Z/iA3GwCBAwpKFazBzkges0LhsDIS3pKOMD2y8XljZptqbWoozTgjVS
         ynDQ==
X-Forwarded-Encrypted: i=1; AJvYcCX43AfPGSm3zI+ydugGizPuOPBCN8Ra4kRq0HezPOfns68e9rYF2E/6iRRGHuwlnwA8N1g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxv9cyWv7aGpfABObi9mnyWyEOxq2K/G1dE308l9KGkgoT6Kqxw
	HL3BUohSrvWqRkIH2QRo4KFcTkioSrtZSb1v02leiQHlaokFmDQAigiNImKYx90=
X-Gm-Gg: ASbGncv1cpNTBRLlomfDD0/8C2mUjt2fr+ZGGpxBGUDYDgu8cBk6vZsuJK1tOBeRyze
	ZBtYZLyrJVHc1qw/sHx5o6Ch1b8QrrFgoMnrDMg3URU0jX0HXenM3PvsIjXyP6H87ieo4YS+rFE
	J5VnYv64duzVUim0bHZtVJU2Y8ViKXvNw/AabpIREUXDkHbBzMG04xjgw3JNtFAoNmjKdnB6pnv
	/ovZNr4qQ2sUqhIB91ziB+OH33lboquajsTS08V/U3ZflLfJHg5hlrzOfSsbikVm5B1pkos/ztn
	qvkBEb8jnUELWVFzw+z35ZuUoXsmpmWE/qN1E5mgvw45sgK2dCkBJR3FSQ==
X-Google-Smtp-Source: AGHT+IEscFPBgwURkivERQ63uZlHCc12XioxFkzuW02QWXVxwQASklk7TdMNVKzsKRLZFS0yvJdJJg==
X-Received: by 2002:a05:6a00:1891:b0:736:a682:deb8 with SMTP id d2e1a72fcca58-7371f0d35cfmr310216b3a.8.1741884161761;
        Thu, 13 Mar 2025 09:42:41 -0700 (PDT)
Received: from [192.168.1.67] ([38.39.164.180])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7371169c3desm1537504b3a.155.2025.03.13.09.42.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Mar 2025 09:42:41 -0700 (PDT)
Message-ID: <9cef5cb6-feea-4be7-ab08-e0b3a8caff9c@linaro.org>
Date: Thu, 13 Mar 2025 09:42:40 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/17] make system memory API available for common code
Content-Language: en-US
To: qemu-devel@nongnu.org
Cc: Paul Durrant <paul@xen.org>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, Harsh Prateek Bora <harshpb@linux.ibm.com>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 xen-devel@lists.xenproject.org, Peter Xu <peterx@redhat.com>,
 alex.bennee@linaro.org, manos.pitsidianakis@linaro.org,
 Stefano Stabellini <sstabellini@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-ppc@nongnu.org,
 Richard Henderson <richard.henderson@linaro.org>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Palmer Dabbelt <palmer@dabbelt.com>,
 Weiwei Li <liwei1518@gmail.com>, qemu-riscv@nongnu.org,
 Alistair Francis <alistair.francis@wdc.com>,
 Anthony PERARD <anthony@xenproject.org>,
 Yoshinori Sato <ysato@users.sourceforge.jp>,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Nicholas Piggin <npiggin@gmail.com>
References: <20250313163903.1738581-1-pierrick.bouvier@linaro.org>
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
In-Reply-To: <20250313163903.1738581-1-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

patch 12 (adding xen stubs, so would need someone from hw/xen) and 15 
are missing reviews.

Thanks,
Pierrick

On 3/13/25 09:38, Pierrick Bouvier wrote:
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
>   hw/xen/xen_stubs.c                  | 56 ++++++++++++++++++++
>   page-vary-target.c                  |  2 +-
>   system/ioport.c                     |  1 -
>   system/memory.c                     | 17 ++----
>   target/ppc/tcg-excp_helper.c        |  1 +
>   target/riscv/bitmanip_helper.c      |  2 +-
>   hw/xen/meson.build                  |  3 ++
>   system/meson.build                  |  6 +--
>   22 files changed, 193 insertions(+), 126 deletions(-)
>   create mode 100644 hw/xen/xen_stubs.c
> 


