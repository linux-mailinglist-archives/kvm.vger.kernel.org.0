Return-Path: <kvm+bounces-18841-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 53A048FC13A
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 03:21:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D0482B2126D
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 01:21:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6A3E2BD0D;
	Wed,  5 Jun 2024 01:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c4PHbCR8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E8433F7;
	Wed,  5 Jun 2024 01:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717550471; cv=none; b=QegKhq+jJmOsrsTSTJJjzGVfuTQyAtoqrY4g8YoAy+/zC4O5WKFT2QYd4L7uIc5BtKFTZTASACwMtxpUlZC64xIgtmpcWQkjhOTu8TRDeYQOXo8mXiKu4EkBZujoNFcuwY9voFuSHEjauQquVaVVPnsictzj91q7cTICXOnMZrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717550471; c=relaxed/simple;
	bh=wz2Ien1IfsELglJbQoIx/KfWEA1p0Mi30bbod3vlcmM=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=dR2cFTy1ue3w1OVQeUgwLnXGQFtYAgtq+AlJ/VtP5l9t/NOh/0nFxnKuoQfa+ffUnAam9qWs4nzqd1B4povpXrCVz3EJNIPxbo/2qEw3ya3Q+WvY55tRAVTDumm2pufvHWeT6UkeTCLemDzhzwxHZwp1el0AVy/XMjvBjZhEM10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c4PHbCR8; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2c1def9b4b3so3612369a91.0;
        Tue, 04 Jun 2024 18:21:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717550469; x=1718155269; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pABbP+BA1mtq5hO5aRQWiuQi7iiEhfelj9Ec0CA3pMM=;
        b=c4PHbCR8zC5PLvCU+xuQQ8tv9FNVeS2Xb3t/hiOWGqq1p0fruZODRmJU5zyRYCYYrY
         WvR7BWO0I9DGkpGnh3dE7Ejn05ApTP+y3os1vUQpN/a6PLtTh0P6xBMZ6EByvKpHW1fJ
         iJnXHXbpKxFXALzrr+XhD8SlMeCwnM0ZsAV2JJjso6veWdnxrJC2dka3Kidlr5EmJoEh
         SgHtSFnEhH4oDeH0bics51i5/ms5Fe01/4S8ZSQFtJX3J7aMBKKigPVajTloUavBbVib
         3HnvuvelojumQWu513Dq5w92G9jJ1wS09yyHJWuUSwlniG9TnJ0NNHnHKSmQZwNh++iK
         pqJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717550469; x=1718155269;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pABbP+BA1mtq5hO5aRQWiuQi7iiEhfelj9Ec0CA3pMM=;
        b=A4TKzOsMzCukY9JfNmfB9S9evSfQqsRwuM6QNOqkMlymzDC1Nd9gNC42yWhVlz1TPC
         Ej8jk8XZ1RxBVeESO3ffDNRJIektbGyDS/xXhYbu9JE5nM2iJudQc50AuB/VQZh2q5ez
         SLxUS+906Jb6YRY3lGk88QYuFik1HqBL3QV5kWdH0sgFGM10uPGq79mhA/eZ4Sl/y7po
         ys/px5gXvS1UHq4TRTqb8/mA+3o9SJVt2wcyxwsnqEkOqYy/tSirrbHwx8R/0QrTB90v
         grNykOEOPfwh1lIdSbevm/iSUzvoYH3V+8G4AGOgda4Z8PVhyTDP2IhoFmSWu/OvY3jx
         ASuQ==
X-Forwarded-Encrypted: i=1; AJvYcCWthm6yBKGdl+iN9z02epxXE16h9a6gGnr//6yr3NQrICIp/CTR6v8bi0OQeVXpmKZtaa6D84jsZqPCBzeeFcP3jEfXJzh20Y/r3Q==
X-Gm-Message-State: AOJu0Yw0FuPHjZifv+P26d8NkemccTkqZMKaGpz3WCfM/KltgZYVTUJN
	MDmN0G1uLCwLmd4FOxH1XQaEsjW/0ypa96wk2T2acwx8K23zo2Y0FxDmeg==
X-Google-Smtp-Source: AGHT+IHbKxezO4tJeUOjEfflKlPYdstybt9D5djwtLYog70+97qkWqlsvepaD0bYDn8+hDrF1rUTAA==
X-Received: by 2002:a17:90a:8d0a:b0:2bd:fcda:ef2e with SMTP id 98e67ed59e1d1-2c27db18b71mr1263149a91.22.1717550468855;
        Tue, 04 Jun 2024 18:21:08 -0700 (PDT)
Received: from localhost (110-175-65-7.tpgi.com.au. [110.175.65.7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c28066d68asm174897a91.12.2024.06.04.18.21.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jun 2024 18:21:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 05 Jun 2024 11:21:03 +1000
Message-Id: <D1ROTQ8S7W3G.3V7M7B6AMQWOR@gmail.com>
Cc: <kvm@vger.kernel.org>, "Janosch Frank" <frankja@linux.ibm.com>, "Nico
 Boehr" <nrb@linux.ibm.com>, "Steffen Eiden" <seiden@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 1/3] s390x/Makefile: snippets: Add
 separate target for the ELF snippets
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Marc Hartmayer" <mhartmay@linux.ibm.com>, <linux-s390@vger.kernel.org>,
 "Thomas Huth" <thuth@redhat.com>
X-Mailer: aerc 0.17.0
References: <20240604115932.86596-1-mhartmay@linux.ibm.com>
 <20240604115932.86596-2-mhartmay@linux.ibm.com>
In-Reply-To: <20240604115932.86596-2-mhartmay@linux.ibm.com>

On Tue Jun 4, 2024 at 9:59 PM AEST, Marc Hartmayer wrote:
> It's unusual to create multiple files in one target rule, and it's even m=
ore
> unusual to create an ELF file with a `.gbin` file extension first, and th=
en
> overwrite it in the next step. It might even lead to errors as the input =
file
> path is also used as the output file path - but this depends on the objco=
py
> implementation. Therefore, create an extra target for the ELF files and l=
ist it
> as a prerequisite for the *.gbin targets.

I had some pain trying to figure out another ("pretty printing") patch
that changed some s390x/Makefile because of this. As far as I can tell
it looks good.

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

>
> Signed-off-by: Marc Hartmayer <mhartmay@linux.ibm.com>
> ---
>  s390x/Makefile | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 23342bd64f44..784818b2883e 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -153,14 +153,18 @@ $(SNIPPET_DIR)/asm/%.o: $(SNIPPET_DIR)/asm/%.S $(as=
m-offsets)
>  $(SNIPPET_DIR)/c/%.o: $(SNIPPET_DIR)/c/%.c $(asm-offsets)
>  	$(CC) $(CFLAGS) -c -nostdlib -o $@ $<
> =20
> -$(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.o $(SNIPPET_DIR)/asm/fla=
t.lds
> +$(SNIPPET_DIR)/asm/%.elf: $(SNIPPET_DIR)/asm/%.o $(SNIPPET_DIR)/asm/flat=
.lds
>  	$(CC) $(LDFLAGS) -o $@ -T $(SNIPPET_DIR)/asm/flat.lds $<
> -	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data" -=
j ".bss" --set-section-flags .bss=3Dalloc,load,contents $@ $@
> +
> +$(SNIPPET_DIR)/asm/%.gbin: $(SNIPPET_DIR)/asm/%.elf
> +	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data" -=
j ".bss" --set-section-flags .bss=3Dalloc,load,contents $< $@
>  	truncate -s '%4096' $@
> =20
> -$(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS)=
 $(SNIPPET_DIR)/c/flat.lds
> +$(SNIPPET_DIR)/c/%.elf: $(SNIPPET_DIR)/c/%.o $(snippet_lib) $(FLATLIBS) =
$(SNIPPET_DIR)/c/flat.lds
>  	$(CC) $(LDFLAGS) -o $@ -T $(SNIPPET_DIR)/c/flat.lds $< $(snippet_lib) $=
(FLATLIBS)
> -	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data" -=
j ".bss" --set-section-flags .bss=3Dalloc,load,contents $@ $@
> +
> +$(SNIPPET_DIR)/c/%.gbin: $(SNIPPET_DIR)/c/%.elf
> +	$(OBJCOPY) -O binary -j ".rodata" -j ".lowcore" -j ".text" -j ".data" -=
j ".bss" --set-section-flags .bss=3Dalloc,load,contents $< $@
>  	truncate -s '%4096' $@
> =20
>  %.hdr: %.gbin $(HOST_KEY_DOCUMENT)


