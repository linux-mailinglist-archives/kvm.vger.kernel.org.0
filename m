Return-Path: <kvm+bounces-20447-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EC68C915D1A
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 04:58:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1BF721C204FA
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 02:58:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78AB945038;
	Tue, 25 Jun 2024 02:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ASx7GAVc"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A77D2B9AE;
	Tue, 25 Jun 2024 02:58:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719284326; cv=none; b=rhvSAaPR9ihHnewV1zcvSadaVlc74Y4DKa4ifACndFFkxvV9wLMRNPD85IB1woVy1ByUX46DT9anlV10SK4TxS7N7+uq3GH2sIraKBQPtwr/UUKh5UpEXMh8Y0JN/UXJOTFnbSHgTfYm4aNWP1H6PvyDIBS+/fbG7HiwtSjSpks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719284326; c=relaxed/simple;
	bh=Noj5XaK/HbP6hHRe/vKRlZItg1JtwFjpFjoxWhtgKeM=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=INmiaSrLSxYYJj+9Jnm1JSWAkxtO9XiuobEFAKPLq0BV2cofSLImSHYiqnqphaqrZ2Uiq2rdBGH8+0p4mEd8u53hxdg3WOWnodA9aRzV4rR6yMhfrdzSa9Kr/T8CQVxXyO6X9zxvnToFE0C1tKR3mVuQ+eqOfrlRK3fCuokH/wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ASx7GAVc; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-1f65a3abd01so40770595ad.3;
        Mon, 24 Jun 2024 19:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719284324; x=1719889124; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=838f2JcawVbBM4tDzvickHRjyuMOaKBCu6mLh0Pp5Mw=;
        b=ASx7GAVc7ugfDVqcSAnaAlKm7JeB9gBa4yAxKrDH4mXjJk2SZtZ3cT6ra3hJTLiikw
         PlhhSUAPLDUcRlxq9Z/9h8y4xQNxpoic2d/4lkXryWawAGRXLIZb2xf0KsM1W+i/Vfyv
         2hCcWG2anldPPp2S17igZfwGTj82dF9zOvoUx3CT2pRDbtQTi3c2J6097NWfuo8J4+d7
         Wg8MzgVRfTmIqwJPjOMCI+GxzD6ghkNihrSgFy1lzZ0DBFp9WB7TNN22s9GEYiOHaiVy
         +0vYo0FqsH7UCcy7HEyMqYJBnTmnOOS3USZd7K8bkomzxeApKmIEmWvUYLuv8fMgqeJe
         hj7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719284324; x=1719889124;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=838f2JcawVbBM4tDzvickHRjyuMOaKBCu6mLh0Pp5Mw=;
        b=g16e3J88FOnrUt4dSAX5jwUq+5VN4DepnvymFyR0Kcm5UXRotqTiCLdI7PskwYI539
         KZaQaSQ1VszNScey7Ce6D0VrlTenVQ4PNuN+CftTLuqO+cEmmCpImgXC4rSHHUitgr2B
         WX8x6my9ol+ASB+IfG8gUkWKQRe3d4YBMielZooSnOAsiDEwr3Gq2L69KiFeu8+aGyUL
         l/3xGMZYZprw4SvMgwikWwHBljdQUnW5jhnqIkzK8nQmHJmDdhcwEBQ6Rt+Q2T+p+kYw
         dKrKVfgDnSd9ID3r4QrMUzPbCUQxRk2zwclEf5e8cxwhOvoNTPq09ytVGndE7ECY8gn4
         0eww==
X-Forwarded-Encrypted: i=1; AJvYcCVSH1nC70enK6hn3H2d6wnPeyABIuHIeIt6bdvUsPx1pmoiD+bSA1JlXX0MqkX8dOCrFu7qli8GSfp2+YAqfyJJ6+T7jSbUPtRjMm7HG/kl+8OQehwbwB26nwfzc5O0uA==
X-Gm-Message-State: AOJu0YwEoO7LI17KlRpyAHXtsjqJphPCEhRQIJOEhFSNe43MC+gsKEAi
	KhdqUvcEfF1inW2kks03JWbFdCIVwjwE6HVBVDQbsZg52KPVWaP5
X-Google-Smtp-Source: AGHT+IHMq5IwDjOK2l/InwFZ38QKS5CztpaQeE6ie9P/e3aebyxBpYA3x6iwjUgzrR4NgVWGD9Zdew==
X-Received: by 2002:a17:903:1c6:b0:1f7:19b7:98bd with SMTP id d9443c01a7336-1fa239e92bdmr89005165ad.6.1719284324453;
        Mon, 24 Jun 2024 19:58:44 -0700 (PDT)
Received: from localhost (118-211-5-80.tpgi.com.au. [118.211.5.80])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f9eb2f0545sm69568225ad.27.2024.06.24.19.58.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jun 2024 19:58:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 25 Jun 2024 12:58:38 +1000
Message-Id: <D28RFC6SAHQ1.2FQ6D9RNOWB3R@gmail.com>
Cc: "Andrew Jones" <andrew.jones@linux.dev>, <kvm@vger.kernel.org>,
 <linux-s390@vger.kernel.org>, "David Hildenbrand" <david@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v3 6/7] s390x: Use library functions for
 snippet exit
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Nina Schoetterl-Glausch" <nsg@linux.ibm.com>, "Claudio Imbrenda"
 <imbrenda@linux.ibm.com>, "Janosch Frank" <frankja@linux.ibm.com>,
 =?utf-8?q?Nico_B=C3=B6hr?= <nrb@linux.ibm.com>, "Thomas Huth"
 <thuth@redhat.com>
X-Mailer: aerc 0.17.0
References: <20240620141700.4124157-1-nsg@linux.ibm.com>
 <20240620141700.4124157-7-nsg@linux.ibm.com>
In-Reply-To: <20240620141700.4124157-7-nsg@linux.ibm.com>

On Fri Jun 21, 2024 at 12:16 AM AEST, Nina Schoetterl-Glausch wrote:
> Replace the existing code for exiting from snippets with the newly
> introduced library functionality.
>

Is like for like AFAIKS

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> ---
>  s390x/sie-dat.c            | 11 +++--------
>  s390x/snippets/c/sie-dat.c | 19 +------------------
>  2 files changed, 4 insertions(+), 26 deletions(-)
>
> diff --git a/s390x/sie-dat.c b/s390x/sie-dat.c
> index 9e60f26e..c8f38220 100644
> --- a/s390x/sie-dat.c
> +++ b/s390x/sie-dat.c
> @@ -27,23 +27,18 @@ static void test_sie_dat(void)
>  	uint64_t test_page_gpa, test_page_hpa;
>  	uint8_t *test_page_hva, expected_val;
>  	bool contents_match;
> -	uint8_t r1;
> =20
>  	/* guest will tell us the guest physical address of the test buffer */
>  	sie(&vm);
> -	assert(vm.sblk->icptcode =3D=3D ICPT_INST &&
> -	       (vm.sblk->ipa & 0xff00) =3D=3D 0x8300 && vm.sblk->ipb =3D=3D 0x9=
c0000);
> -
> -	r1 =3D (vm.sblk->ipa & 0xf0) >> 4;
> -	test_page_gpa =3D vm.save_area.guest.grs[r1];
> +	assert(snippet_is_force_exit_value(&vm));
> +	test_page_gpa =3D snippet_get_force_exit_value(&vm);
>  	test_page_hpa =3D virt_to_pte_phys(guest_root, (void*)test_page_gpa);
>  	test_page_hva =3D __va(test_page_hpa);
>  	report_info("test buffer gpa=3D0x%lx hva=3D%p", test_page_gpa, test_pag=
e_hva);
> =20
>  	/* guest will now write to the test buffer and we verify the contents *=
/
>  	sie(&vm);
> -	assert(vm.sblk->icptcode =3D=3D ICPT_INST &&
> -	       vm.sblk->ipa =3D=3D 0x8300 && vm.sblk->ipb =3D=3D 0x440000);
> +	assert(snippet_is_force_exit(&vm));
> =20
>  	contents_match =3D true;
>  	for (unsigned int i =3D 0; i < GUEST_TEST_PAGE_COUNT; i++) {
> diff --git a/s390x/snippets/c/sie-dat.c b/s390x/snippets/c/sie-dat.c
> index 9d89801d..26f045b1 100644
> --- a/s390x/snippets/c/sie-dat.c
> +++ b/s390x/snippets/c/sie-dat.c
> @@ -10,28 +10,11 @@
>  #include <libcflat.h>
>  #include <asm-generic/page.h>
>  #include <asm/mem.h>
> +#include <snippet-guest.h>
>  #include "sie-dat.h"
> =20
>  static uint8_t test_pages[GUEST_TEST_PAGE_COUNT * PAGE_SIZE] __attribute=
__((__aligned__(PAGE_SIZE)));
> =20
> -static inline void force_exit(void)
> -{
> -	asm volatile("diag	0,0,0x44\n"
> -		     :
> -		     :
> -		     : "memory"
> -	);
> -}
> -
> -static inline void force_exit_value(uint64_t val)
> -{
> -	asm volatile("diag	%[val],0,0x9c\n"
> -		     :
> -		     : [val] "d"(val)
> -		     : "memory"
> -	);
> -}
> -
>  int main(void)
>  {
>  	uint8_t *invalid_ptr;


