Return-Path: <kvm+bounces-59019-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DC90BAA151
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 18:59:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 23CBD1892C6C
	for <lists+kvm@lfdr.de>; Mon, 29 Sep 2025 16:59:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B94B30C617;
	Mon, 29 Sep 2025 16:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sroCapCm"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5033093A6
	for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 16:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759165139; cv=none; b=orzOTlVeirSxRGDtnbdpjKXdP+CpZfurEb4/q20toGI4brdVoonoe7gRhsKpBI/6FPRyQALZYt8zTIwXBGUVm4ofPTSXDARsD5MCn3x7BYEuST/yRyaRhq1Wkjt4GyH+HpnTMf/+vUEYlKmIdWbjhED5UVQ06SlPSssCrr7UyLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759165139; c=relaxed/simple;
	bh=ME/QKdR1oM3jHT6BV3x6e8zSt+6Ap/IPvgcm0w4m5KY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=NqBEQxknmSLWfcLc3QJ9QG0FUxzOZ0P/n0O6+1mKNpfL4n28LrmqDjMkt5Q1iaieo6DCm8qj0OOXJI/TEXlZbs99jphstzSPZJJqZRY90QoHCE+iV/To3iwQPinn49gwFdeaDYG5AgBqUHotdHGRphYjVzXXFRpQbktfHs9Bu/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sroCapCm; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3fc36b99e92so3596840f8f.0
        for <kvm@vger.kernel.org>; Mon, 29 Sep 2025 09:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759165135; x=1759769935; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B0S6EILPN7ffIU403Vjsy+sm3b2HrDWxSRYwj6LQPxs=;
        b=sroCapCmRuT9jvvUEoK4hfALTDuw3Be04W6Yg9fYJt9VqW3yZi12DhtjBL6fBq9LYh
         5czro/Wg+CFts+QL/GHJ7ufDxhpDtyr/VVpDQPNzUIm5kZdvzwNiADQEBN+Sk5TrbdTs
         lXo0oszmRhVXH86WJKFFItyHVZiZkPxMPaW7jwyRoTUKjOkGqoLhsiW5yfUmwsiH5GNG
         6WOQRaDYCSZ/U9ezgmY+Xcz+Te0ELCXtcfYSrAd+UhKSL+AqNMfKLXr2QqKv/6xL9Tw3
         H2oup+4Rxli10vV6V+D5HebPbQdg3u68JMQSyCbTnqm/PsLywIhThR06NC6WGAS7126H
         PS1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759165135; x=1759769935;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=B0S6EILPN7ffIU403Vjsy+sm3b2HrDWxSRYwj6LQPxs=;
        b=RN26wlRey8a5UvhsKQHMG89VElaf8wdLQY/75BfgNDZ51NUdeaHiZlFwqQGyixnuJ3
         Tqli3DmBLJzCZuEaSfnGYENEZwiDbuhMb2jw2giqXOBVLMRCLny8/nttfIXDCpBxWdYY
         kxbtKOTbYrdaAZskmer9JLLApiWzWe9kajjeiuFf/EUNKjm3xfW6yACt6m4js9as7Hn7
         fHRPqlBxkq9hFCWyn+EhDHLljzWDeZa64khctHR+HXE52rXN8H8Q36bDsdQzqkB+ujUp
         vjGY9ltLhnHfW1r4UtdgS3MoffY+ITf+QMqwxjVgO8TDyQk40mQ9lyiWf/KahtFw1XVj
         06GQ==
X-Forwarded-Encrypted: i=1; AJvYcCV+1M6IiIlHlEgJ3PC/XHZiO2N+O4izKc0olcYgu7RhXbtVmtHe8Qs6YIgbTqrIbqHB19E=@vger.kernel.org
X-Gm-Message-State: AOJu0YxaOUtMMuXiu2MA+RkjHbolw/X05s2WfD2CMjkzZuhtR/iQ7vMY
	C5SNand310VHebi+TInC2GPGOAFm0AvgRFzpWdM1655kd37deyjjXAl2W5e/Wr+iROQ=
X-Gm-Gg: ASbGnct7gAzTxP6Vv/QOKEK/91B3ZkRGfThk0XMzoXOgycO5UMfk0Y1bRwW5duYzqQ6
	UHDQRZUuN6rAV//Vvb+D8QAjTFBloO8FiR7oISq4rg5duAF47lAmfQgA7O+kh8iN8mnkknbukkA
	Jzlf+26eJZ0Kz9OJLxnJA7vwx5rVaanqMxKtEdEGyyDsZn/88Y/JX5bKS91Nyi5Ps4KkheuPony
	EKaf9jgwnSX1Id7/p6HE2xIUZ4xKxsutm1fBLLI6VBhr/UdBjsIpJHb9yIknHA8r66AW0AfZMSf
	5VV/ZJ/6eKM2CsNyyMvu99x+QfgkxjIVkwCuD5fldAvUT8/jNJrkT6+xDhu4uYb++r8jH7tGeRe
	zllNxKz9kGbEcA6dyFn+E718=
X-Google-Smtp-Source: AGHT+IH2fA59YHeZ+ymUy+20ZdxLapcCSwGaTQZySF6RUlu+W+xpISnyvkhcUOy2xZVW+sXHaCiDow==
X-Received: by 2002:a5d:5f96:0:b0:3e8:f67:894f with SMTP id ffacd0b85a97d-42411da986cmr1265597f8f.26.1759165135585;
        Mon, 29 Sep 2025 09:58:55 -0700 (PDT)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb7203b8asm19257053f8f.9.2025.09.29.09.58.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Sep 2025 09:58:54 -0700 (PDT)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 063085F83A;
	Mon, 29 Sep 2025 17:58:54 +0100 (BST)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org,  Fabiano Rosas <farosas@suse.de>,  "Maciej S.
 Szmigiero" <maciej.szmigiero@oracle.com>,  Richard Henderson
 <richard.henderson@linaro.org>,  "Michael S. Tsirkin" <mst@redhat.com>,
  Paolo Bonzini <pbonzini@redhat.com>,  David Hildenbrand
 <david@redhat.com>,  kvm@vger.kernel.org,  Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH 2/6] system/ramblock: Move ram_block_is_pmem() declaration
In-Reply-To: <20250929154529.72504-3-philmd@linaro.org> ("Philippe
	=?utf-8?Q?Mathieu-Daud=C3=A9=22's?= message of "Mon, 29 Sep 2025 17:45:25
 +0200")
References: <20250929154529.72504-1-philmd@linaro.org>
	<20250929154529.72504-3-philmd@linaro.org>
User-Agent: mu4e 1.12.14-dev1; emacs 30.1
Date: Mon, 29 Sep 2025 17:58:53 +0100
Message-ID: <87zfadjiuq.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> writes:

> Move ramblock_is_pmem() along with the RAM Block API
> exposed by the "system/ramblock.h" header. Rename as
> ram_block_is_pmem() to keep API prefix consistency.
>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> ---
>  include/system/ram_addr.h | 2 --
>  include/system/ramblock.h | 5 +++++
>  migration/ram.c           | 3 ++-
>  system/physmem.c          | 5 +++--
>  4 files changed, 10 insertions(+), 5 deletions(-)
>
> diff --git a/include/system/ram_addr.h b/include/system/ram_addr.h
> index 15a1b1a4fa2..53c0c8c3856 100644
> --- a/include/system/ram_addr.h
> +++ b/include/system/ram_addr.h
> @@ -99,8 +99,6 @@ static inline unsigned long int ramblock_recv_bitmap_of=
fset(void *host_addr,
>      return host_addr_offset >> TARGET_PAGE_BITS;
>  }
>=20=20
> -bool ramblock_is_pmem(RAMBlock *rb);
> -
>  /**
>   * qemu_ram_alloc_from_file,
>   * qemu_ram_alloc_from_fd:  Allocate a ram block from the specified back=
ing
> diff --git a/include/system/ramblock.h b/include/system/ramblock.h
> index 8999206592d..12f64fbf78b 100644
> --- a/include/system/ramblock.h
> +++ b/include/system/ramblock.h
> @@ -108,4 +108,9 @@ void ram_block_attributes_destroy(RamBlockAttributes =
*attr);
>  int ram_block_attributes_state_change(RamBlockAttributes *attr, uint64_t=
 offset,
>                                        uint64_t size, bool to_discard);
>=20=20
> +/**
> + * ramblock_is_pmem: Whether the RAM block is of persistent memory

missed a rename

Otherwise:

Reviewed-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>


> + */
> +bool ram_block_is_pmem(RAMBlock *rb);
> +
>  #endif
> diff --git a/migration/ram.c b/migration/ram.c
> index 7208bc114fb..91e65be83d8 100644
> --- a/migration/ram.c
> +++ b/migration/ram.c
> @@ -53,6 +53,7 @@
>  #include "qemu/rcu_queue.h"
>  #include "migration/colo.h"
>  #include "system/cpu-throttle.h"
> +#include "system/ramblock.h"
>  #include "savevm.h"
>  #include "qemu/iov.h"
>  #include "multifd.h"
> @@ -4367,7 +4368,7 @@ static bool ram_has_postcopy(void *opaque)
>  {
>      RAMBlock *rb;
>      RAMBLOCK_FOREACH_NOT_IGNORED(rb) {
> -        if (ramblock_is_pmem(rb)) {
> +        if (ram_block_is_pmem(rb)) {
>              info_report("Block: %s, host: %p is a nvdimm memory, postcop=
y"
>                           "is not supported now!", rb->idstr, rb->host);
>              return false;
> diff --git a/system/physmem.c b/system/physmem.c
> index ae8ecd50ea1..3766fae0aba 100644
> --- a/system/physmem.c
> +++ b/system/physmem.c
> @@ -43,6 +43,7 @@
>  #include "system/kvm.h"
>  #include "system/tcg.h"
>  #include "system/qtest.h"
> +#include "system/ramblock.h"
>  #include "qemu/timer.h"
>  #include "qemu/config-file.h"
>  #include "qemu/error-report.h"
> @@ -1804,7 +1805,7 @@ void qemu_ram_msync(RAMBlock *block, ram_addr_t sta=
rt, ram_addr_t length)
>=20=20
>  #ifdef CONFIG_LIBPMEM
>      /* The lack of support for pmem should not block the sync */
> -    if (ramblock_is_pmem(block)) {
> +    if (ram_block_is_pmem(block)) {
>          void *addr =3D ramblock_ptr(block, start);
>          pmem_persist(addr, length);
>          return;
> @@ -3943,7 +3944,7 @@ int ram_block_discard_guest_memfd_range(RAMBlock *r=
b, uint64_t start,
>      return ret;
>  }
>=20=20
> -bool ramblock_is_pmem(RAMBlock *rb)
> +bool ram_block_is_pmem(RAMBlock *rb)
>  {
>      return rb->flags & RAM_PMEM;
>  }

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

