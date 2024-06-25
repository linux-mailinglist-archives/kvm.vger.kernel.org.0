Return-Path: <kvm+bounces-20446-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 581EF915D15
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 04:57:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CAC691F262EB
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 02:57:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 873AC45023;
	Tue, 25 Jun 2024 02:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XEAoZVrg"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A31A23BB;
	Tue, 25 Jun 2024 02:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719284239; cv=none; b=VySznfnc1bVTQHyvuyHoV3TDLugxU8vzhY09WHlegLMcGnnbJAWk8JYLyG3tbg9WaCwZiAPEviZsQFLSqJioHQdw7lwPeZntUH4EJf+nZPfunw/q88aqYzIrDfT+TxzGP4hjUEsH9x2msU4Lp4ysiLwy0EPkziXNKEnjc9VhnF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719284239; c=relaxed/simple;
	bh=LPx4jxFKTBCj2ZOBhinBWv8MZi8vb3XtDVkoSZN+9rY=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=Ii8fogWUvkacOfLchJ5dDYOu2ZeP3w73bsOWBT9gnh9Nc5HMEUadJ8MFBdhpp7xYtfeXCVnvRUDBajssRUCWoWdsQE8/XlU1ZkDUOHDladcv0+3A1IA4+wnOw8MlWabknjiCTwY3Z6rKpuWwGTApARoFW7XIxYfOg6t9IrmC0a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XEAoZVrg; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1f4a5344ec7so33915415ad.1;
        Mon, 24 Jun 2024 19:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719284237; x=1719889037; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wWz+Y0j6PeoTTfbxlnxO9wezH/WywGRu4YJBpaWkC+Y=;
        b=XEAoZVrg8R9A+VH4pacpMnr3giEj3Xqcq6W3ydfAjGUdqrKRvE3n5r3rZpZm1lINiV
         tfPrtI45nPzLoDRhG17Cwu2yoLz2p0JeRFng+/Ok2EDsGNSHFO4bqcSOrBKegGbcvhUv
         i389rKgViJiD9RQW7bVY/ariecxoNtwnuAefY7ED47sjbk4lFxkCBCLFycQX42Uy8Kod
         sMfljyUujO2/x8QUlEktsdfhKJ5phtIfIBqDprVk6/SHO8InGbIk+t6fjwv8yKfu02aD
         8DFQ49Sxa7ZCubiBch2ataVw5Dz/RZhj5hBUBDQxGIcgjvJyN38x6+ZMAK3G2y8Xivro
         15ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719284237; x=1719889037;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=wWz+Y0j6PeoTTfbxlnxO9wezH/WywGRu4YJBpaWkC+Y=;
        b=Ap/AN/WvSAidsPuOcVV5oQH1MHOMjrY8N0uVuiXEShJyX7QJRZFdgqlIYeeQRCI2Yg
         S36E7pnb4vBYWyLzpqj9Minl7XT4ch4hRBzTAGnLJVlJb8evHJFPL0IKAx8bJ7LZowaj
         5tdfdkN5+agrwlmY8SjYM9yGvEOlSI/0uxFr0AtxrjHBOS+pEZ78NhqPkq61O05ZAT+J
         RFjNn7HFNqakxaGrxMMRUMdPbm/QSnosWvZQOQ639jF5rfsYOsQWhxHo7HVqa/pm95mu
         XbJBaKdCs+N9EmFI/wGRIvy9YA35OieZIvrK+UDZzJgX0ynDQS3gJ3UWlvZcL93l6ZC+
         Zxgw==
X-Forwarded-Encrypted: i=1; AJvYcCVOeh2XExJzCUMd366Rv/YIbNCf/KXj3X91ZsfFkd3IDxRMzdxh+NARzGzI1Cr2OwFW6ebAiSjkbhHjAGvy8fl4aSKU
X-Gm-Message-State: AOJu0YweMBnb8Ks1YTmIooOY1TbMy0O0m18twVKknBVXLd+qsaq4bdpZ
	QKiIInUsEgKpC+xdRPMGtJT8OFa6qaFzo+OYRlHuitv58Od4FDdvh+3vnQ==
X-Google-Smtp-Source: AGHT+IFBN9yXXY/XOdILlX38gRlBjmtVhNEfMgW9uKIlr4mJRojx6XeT7T6IihmoIUZ4kAxca4X3sQ==
X-Received: by 2002:a17:903:2351:b0:1f9:9b6d:e3f9 with SMTP id d9443c01a7336-1fa0fb49831mr89217785ad.29.1719284237448;
        Mon, 24 Jun 2024 19:57:17 -0700 (PDT)
Received: from localhost (118-211-5-80.tpgi.com.au. [118.211.5.80])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f9eb31f669sm70028755ad.63.2024.06.24.19.57.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jun 2024 19:57:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 25 Jun 2024 12:57:11 +1000
Message-Id: <D28RE8616U75.1D66ANONJOCI6@gmail.com>
Cc: <linux-s390@vger.kernel.org>, "David Hildenbrand" <david@redhat.com>,
 "Andrew Jones" <andrew.jones@linux.dev>, <kvm@vger.kernel.org>
Subject: Re: [kvm-unit-tests PATCH v3 5/7] s390x: Add library functions for
 exiting from snippet
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Nina Schoetterl-Glausch" <nsg@linux.ibm.com>, "Thomas Huth"
 <thuth@redhat.com>, "Claudio Imbrenda" <imbrenda@linux.ibm.com>,
 =?utf-8?q?Nico_B=C3=B6hr?= <nrb@linux.ibm.com>, "Janosch Frank"
 <frankja@linux.ibm.com>
X-Mailer: aerc 0.17.0
References: <20240620141700.4124157-1-nsg@linux.ibm.com>
 <20240620141700.4124157-6-nsg@linux.ibm.com>
In-Reply-To: <20240620141700.4124157-6-nsg@linux.ibm.com>

On Fri Jun 21, 2024 at 12:16 AM AEST, Nina Schoetterl-Glausch wrote:
> It is useful to be able to force an exit to the host from the snippet,
> as well as do so while returning a value.
> Add this functionality, also add helper functions for the host to check
> for an exit and get or check the value.
> Use diag 0x44 and 0x9c for this.
> Add a guest specific snippet header file and rename snippet.h to reflect
> that it is host specific.
>
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> ---
>  s390x/Makefile                          |  1 +
>  lib/s390x/asm/arch_def.h                | 13 ++++++++
>  lib/s390x/snippet-guest.h               | 26 +++++++++++++++
>  lib/s390x/{snippet.h =3D> snippet-host.h} | 10 ++++--
>  lib/s390x/snippet-host.c                | 42 +++++++++++++++++++++++++
>  lib/s390x/uv.c                          |  2 +-
>  s390x/mvpg-sie.c                        |  2 +-
>  s390x/pv-diags.c                        |  2 +-
>  s390x/pv-icptcode.c                     |  2 +-
>  s390x/pv-ipl.c                          |  2 +-
>  s390x/sie-dat.c                         |  2 +-
>  s390x/spec_ex-sie.c                     |  2 +-
>  s390x/uv-host.c                         |  2 +-
>  13 files changed, 97 insertions(+), 11 deletions(-)
>  create mode 100644 lib/s390x/snippet-guest.h
>  rename lib/s390x/{snippet.h =3D> snippet-host.h} (92%)
>  create mode 100644 lib/s390x/snippet-host.c
>
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 23342bd6..12445fb5 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -111,6 +111,7 @@ cflatobjs +=3D lib/s390x/css_lib.o
>  cflatobjs +=3D lib/s390x/malloc_io.o
>  cflatobjs +=3D lib/s390x/uv.o
>  cflatobjs +=3D lib/s390x/sie.o
> +cflatobjs +=3D lib/s390x/snippet-host.o
>  cflatobjs +=3D lib/s390x/fault.o
> =20
>  OBJDIRS +=3D lib/s390x
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 745a3387..db04deca 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -504,4 +504,17 @@ static inline uint32_t get_prefix(void)
>  	return current_prefix;
>  }
> =20
> +static inline void diag44(void)
> +{
> +	asm volatile("diag	0,0,0x44\n");
> +}
> +
> +static inline void diag9c(uint64_t val)
> +{
> +	asm volatile("diag	%[val],0,0x9c\n"
> +		:
> +		: [val] "d"(val)
> +	);
> +}
> +
>  #endif
> diff --git a/lib/s390x/snippet-guest.h b/lib/s390x/snippet-guest.h
> new file mode 100644
> index 00000000..3cc098e1
> --- /dev/null
> +++ b/lib/s390x/snippet-guest.h
> @@ -0,0 +1,26 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Snippet functionality for the guest.
> + *
> + * Copyright IBM Corp. 2023
> + */
> +
> +#ifndef _S390X_SNIPPET_GUEST_H_
> +#define _S390X_SNIPPET_GUEST_H_
> +
> +#include <asm/arch_def.h>
> +#include <asm/barrier.h>
> +
> +static inline void force_exit(void)
> +{
> +	diag44();
> +	mb(); /* allow host to modify guest memory */
> +}
> +
> +static inline void force_exit_value(uint64_t val)
> +{
> +	diag9c(val);
> +	mb(); /* allow host to modify guest memory */
> +}
> +
> +#endif /* _S390X_SNIPPET_GUEST_H_ */
> diff --git a/lib/s390x/snippet.h b/lib/s390x/snippet-host.h
> similarity index 92%
> rename from lib/s390x/snippet.h
> rename to lib/s390x/snippet-host.h
> index 910849aa..230b25b0 100644
> --- a/lib/s390x/snippet.h
> +++ b/lib/s390x/snippet-host.h
> @@ -1,13 +1,13 @@
>  /* SPDX-License-Identifier: GPL-2.0-only */
>  /*
> - * Snippet definitions
> + * Snippet functionality for the host.
>   *
>   * Copyright IBM Corp. 2021
>   * Author: Janosch Frank <frankja@linux.ibm.com>
>   */
> =20
> -#ifndef _S390X_SNIPPET_H_
> -#define _S390X_SNIPPET_H_
> +#ifndef _S390X_SNIPPET_HOST_H_
> +#define _S390X_SNIPPET_HOST_H_
> =20
>  #include <sie.h>
>  #include <uv.h>
> @@ -144,4 +144,8 @@ static inline void snippet_setup_guest(struct vm *vm,=
 bool is_pv)
>  	}
>  }
> =20
> +bool snippet_is_force_exit(struct vm *vm);
> +bool snippet_is_force_exit_value(struct vm *vm);
> +uint64_t snippet_get_force_exit_value(struct vm *vm);
> +void snippet_check_force_exit_value(struct vm *vm, uint64_t exit_exp);
>  #endif
> diff --git a/lib/s390x/snippet-host.c b/lib/s390x/snippet-host.c
> new file mode 100644
> index 00000000..44a60bb9
> --- /dev/null
> +++ b/lib/s390x/snippet-host.c
> @@ -0,0 +1,42 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Snippet functionality for the host.
> + *
> + * Copyright IBM Corp. 2023
> + */
> +
> +#include <libcflat.h>
> +#include <snippet-host.h>
> +#include <sie.h>
> +
> +bool snippet_is_force_exit(struct vm *vm)
> +{
> +	return sie_is_diag_icpt(vm, 0x44);
> +}
> +
> +bool snippet_is_force_exit_value(struct vm *vm)
> +{
> +	return sie_is_diag_icpt(vm, 0x9c);
> +}
> +
> +uint64_t snippet_get_force_exit_value(struct vm *vm)
> +{
> +	struct kvm_s390_sie_block *sblk =3D vm->sblk;
> +
> +	assert(snippet_is_force_exit_value(vm));
> +
> +	return vm->save_area.guest.grs[(sblk->ipa & 0xf0) >> 4];

Hmm, you have a nice instr struct that you made earlier and now you're
back to mask and shift... What about exposing that struct and add a
function to create it so you could do grs[sblk_to_instr(sblk).r1]
here... Just a thought.

Thanks,
Nick

