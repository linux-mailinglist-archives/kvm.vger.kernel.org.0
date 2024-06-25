Return-Path: <kvm+bounces-20445-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 189F6915C5D
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 04:43:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 57830B2122A
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 02:43:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BAD145010;
	Tue, 25 Jun 2024 02:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="erINmCMI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61A881CFB6;
	Tue, 25 Jun 2024 02:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719283404; cv=none; b=ll2pA/RAdiGdEDxo4CgoAgEAy8OTyNY8YDz/Im/OSNSozhU9Dde/Ps1phu/Ppqj6JOjRgWMQUkInA3DX83HNDmdSp5KngLRkJTLBpd22LMo3t9Iii9WhoCq0OAav3TrgV+sHjOAnQ/9vg/NL6/MGAE5P6ke8qOGpTvJXJtvhXso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719283404; c=relaxed/simple;
	bh=NH1d6FllHRDT9A4at65fsgIIjgW2x1KoX+wZ9K1s22U=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=jg2+3M5IccT12aqGx8PWAr7qarzCEGpFiHbkbqX87hQ9RbO0ulJZzjdHBbVZbimk17k1G8c1hBPldPkWZqR8aJnVVsMq+8/pKBWdP89GEsbsAoVVp92grL9Y1z7JJ1UmbBLnH02VFL0nFNd75DbCAS/eGu4kHWagipWL6jCCEcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=erINmCMI; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1fa55dbf2e7so9730405ad.2;
        Mon, 24 Jun 2024 19:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719283403; x=1719888203; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Kr7tF63N5BMp1j43qKZedfO+2GV1kYYtaTr2hW0Smk=;
        b=erINmCMIntCpwmXXp4N0HFr92VgU6p24Nsw/TSvGLmMGNRgY1KNtRZukQm2qNjiKt8
         DNVD5gU3uvFKkDpczbxFNVnvBxN48iVmXIc6CFkCrWyk6pCf7ZVDIys5Sla0aUlpCngM
         nbdgNnNHxdg9E/zdBMPyX/yZMjbfJE7Itco0rgYsR2Hu6OPHEhN10g29SZJwxTyyEv5d
         n0MVdf1jm5S4t5GwF3P+WMNCgpv1IfJzYyouvujdY08DUtFnslNjA8Utvg6NPc9/3mfK
         XzdFOi9YweU+YgFDQvKnnmn3i5l8D50u8z4ccM8HJ6UpUjMxs05RHIu62sFX9F8IgvMI
         fuvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719283403; x=1719888203;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1Kr7tF63N5BMp1j43qKZedfO+2GV1kYYtaTr2hW0Smk=;
        b=pECVE81eOwMlje+TcUZe63twmSeVMnAkD8kJfA3dDGyVHLUhBvi7Akbsr2YaqSfpBJ
         ioDLljX2W5RkIMC3JIGw3M3EicH5O9RJvVXuQ7oh5MhpH4UTsqi7NNjcrmkPKeFy1Eei
         P45FwqW/Fo/0DeBUPThuWcZE0q7sKrIME/gJpYgwTyiet+cVX8mA9MPKKHj8K+VC/nW6
         lpPGiuq9QF0/0PLjx4eMB5wGXHv76Z/BT8uuQ6MbA1Y4vgs3mUy6Yb1iG23Ac6jAjK5t
         VRTnTncsFOTvay3SPqEpNwE0722kBla8VK8f6SXz5YR2MKGjJfRiZIf64Lfa9VtiMSdm
         4JdA==
X-Forwarded-Encrypted: i=1; AJvYcCWVT1R5YriXhyzNcWTpw58hhgncn3GxqseIdJiWQxxq4POkx0a0ksxSOiSDMeOaVgnVSiqzRdFJSEb2K7aVAszhWKPb
X-Gm-Message-State: AOJu0YxAc2IpTT7cpYoMWF3zE/IjrbynmsHS+zylX4Cr0Hb+JTcw0MXe
	mT21EEyRBEzdwx5nANtudUYXPrKe1+GeX+YJp3b+SweJzRpqyr3K
X-Google-Smtp-Source: AGHT+IHTtkMkn11Wwz7WoQBF/cxI9sba1pLidzdhArnJm9oP2UBylUi4tiIZfYV9lRBZwlS67Arl+Q==
X-Received: by 2002:a17:902:dacb:b0:1f9:f021:f2ea with SMTP id d9443c01a7336-1fa15943c09mr89256435ad.63.1719283402564;
        Mon, 24 Jun 2024 19:43:22 -0700 (PDT)
Received: from localhost (118-211-5-80.tpgi.com.au. [118.211.5.80])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f9eb3c8b21sm69486065ad.158.2024.06.24.19.43.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jun 2024 19:43:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 25 Jun 2024 12:43:16 +1000
Message-Id: <D28R3KHKTK6E.36HBUYZEGH2YA@gmail.com>
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

Would you add a "memory" clobber to these maybe? In theory I think
gcc can move even volatile asm around unless there are depdendencies.
Maybe I am overly paranoid.

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

You have barriers here, but couldn't the diag get moved before a prior
store by the guest?

Silly question since I don't understand the s390x arch or snippet design
too well... the diag here causes a guest exit to the host. After the
host handles that, it may resume guest at the next instruction? If that
is correct, then the barrier here (I think) is for when the guest
resumes it would not reorder subsequent loads from guest memory before
the diag, because the host might have modified it.

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
> +}
> +
> +void snippet_check_force_exit_value(struct vm *vm, uint64_t value_exp)
> +{
> +	uint64_t value;
> +
> +	if (snippet_is_force_exit_value(vm)) {
> +		value =3D snippet_get_force_exit_value(vm);
> +		report(value =3D=3D value_exp, "guest forced exit with value (0x%lx =
=3D=3D 0x%lx)",
> +		       value, value_exp);

This is like kvm selftests guest/host synch design, which is quite
nice and useful.

> +	} else {
> +		report_fail("guest forced exit with value");
> +	}

Guest forced exit without value? And do you also need to check for non-valu=
e force
exit to distinguish from a normal snippet exit?

Thanks,
Nick

