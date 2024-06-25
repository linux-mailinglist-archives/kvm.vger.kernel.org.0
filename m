Return-Path: <kvm+bounces-20440-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5274C915BEF
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 03:58:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 83E5B1C2150D
	for <lists+kvm@lfdr.de>; Tue, 25 Jun 2024 01:58:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CB6A20309;
	Tue, 25 Jun 2024 01:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gdd0kIx5"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E32210EE;
	Tue, 25 Jun 2024 01:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719280703; cv=none; b=CQWwp8fUaZc6jEYb0PxfY433Fi64RfGRgTluj91Ds0YODEu+M7lfSxv/wS7g7l00U+idPZScl/5SWWqz0AekLx81DI1g44IjzqDcJyA628yIJTD7Pmo5UHnr7eumvORxAlZqd2aMPu50Cb3MQFBm+43phXLZJuijDa2QCSHhnDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719280703; c=relaxed/simple;
	bh=KpwFigx0oOWXjMOYZz58HXc0+E7kwucLq2c7X9GenNQ=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=s/Lv3Ll8F2BiI5qsJctryNdCQ3kM12YQwOpvJsfM705foXNXHP0pGKHrJBUXJTv+wen+8PVJgjXcRcdMWVqInP2NPjpXe+jftBTUQLaHqdbyCg+EkDNA6iY+mKDR+bh3gMnlDLoDadj0VdyedSbAtQx+Sup0aeDVFHGvKiuebzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gdd0kIx5; arc=none smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-3d361cf5755so2916914b6e.2;
        Mon, 24 Jun 2024 18:58:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719280701; x=1719885501; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=39QeQrzDw8rQX3IGT/Rcm1p33OqxFDQDDDG1ZjS6TCw=;
        b=Gdd0kIx50/QOYtc9ZrzsQXyPd/8GkcC7g33K6iTL25XrVGQcTiCJI3PuvmgEt6YvBj
         ICNRzGx4AaNq6veL9ITCgZDcqJom5aZ/45zGgH3FULnmJy0h+li92w4hJNmWTN59CT8Q
         03SOmDR9PkyrEPFz4eMdQ2CCG1b0HTVAjr2gaVBzMKoBXRvmZXEnn1ld+jc1vFn3u9eE
         d+y0mwrXCEq9evLT1yq7OS3ijcV7oVqc4aIQzIOcigIEN53E9bjBQVi3NxbI9+TRW/m5
         9yAv7CGalBq6TrbJIbE6W1So7X9/x4HmXlnlytyZOfpYepN+u9DrXRoLj6IUXWns8k/U
         fzZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719280701; x=1719885501;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=39QeQrzDw8rQX3IGT/Rcm1p33OqxFDQDDDG1ZjS6TCw=;
        b=g89ckGoSmBZ+QSwJGkPeDG6SN7FjqJx8cXNepTrRDS8wqGpFmg0UK+SamO1dJnxExb
         LsyuqedYR5eTnolBbENPCOw+TvHGcPOjHD9Wh8+UtzZkCMZ932NC3be9y4bt2ycRzJ/2
         2hBfRs5iDIsx2rrlSH2K9ieWQwdi+ugleEGpq2adSPbXvvlCsIEJtPJUORLrL4IRfsOq
         Hfi9UyFPJEK6MiG74Ua+l9yzLV4arI0xlY4yCqRMB0Wm8MFy0ZvACFPJiKMDby5Q9Z3M
         EhxGojDKOg27ljkagddvRXjhUFK5HENprI2noGxn8lrV17/fJCJ5r2B4VidYkJ5DhP5W
         hIaw==
X-Forwarded-Encrypted: i=1; AJvYcCU7OVdRlBxeFTNbDzAIjt5w8BcNf1kdDBC7orfsj50LU0KA9J84hLbgHewlYinZMIkRPU3f1yAZBxhPVs4w9TIYb2GN
X-Gm-Message-State: AOJu0YzF/BGloNDL8MPtTKPurAOlLrJm6qt5TXte8TAGf5I167r259iT
	SakfN+0/Wfvwqi9ES6hYolgWWihv/HEQsulBaI8wIUKg9U0iIP74
X-Google-Smtp-Source: AGHT+IFURooh52M5Miq69+BtfwJjqssaGDXJYAr73ilbd6HecPITsbHb9J4P5exIJZCwKKVQ4XRJTA==
X-Received: by 2002:a05:6808:d52:b0:3d2:2773:581 with SMTP id 5614622812f47-3d545a54d47mr6695166b6e.47.1719280701138;
        Mon, 24 Jun 2024 18:58:21 -0700 (PDT)
Received: from localhost (118-211-5-80.tpgi.com.au. [118.211.5.80])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7068d251418sm1910610b3a.194.2024.06.24.18.58.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jun 2024 18:58:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 25 Jun 2024 11:58:15 +1000
Message-Id: <D28Q53OCJH1L.YZMTUSA3620Y@gmail.com>
Cc: <linux-s390@vger.kernel.org>, <kvm@vger.kernel.org>, "David Hildenbrand"
 <david@redhat.com>, "Andrew Jones" <andrew.jones@linux.dev>, "Thomas Huth"
 <thuth@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v3 3/7] s390x: Add sie_is_pv
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Nina Schoetterl-Glausch" <nsg@linux.ibm.com>,
 =?utf-8?q?Nico_B=C3=B6hr?= <nrb@linux.ibm.com>, "Janosch Frank"
 <frankja@linux.ibm.com>, "Claudio Imbrenda" <imbrenda@linux.ibm.com>
X-Mailer: aerc 0.17.0
References: <20240620141700.4124157-1-nsg@linux.ibm.com>
 <20240620141700.4124157-4-nsg@linux.ibm.com>
In-Reply-To: <20240620141700.4124157-4-nsg@linux.ibm.com>

On Fri Jun 21, 2024 at 12:16 AM AEST, Nina Schoetterl-Glausch wrote:
> Add a function to check if a guest VM is currently running protected.
>
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

Reviewed-by: Nicholas Piggin <npiggin@gmail.com>

> ---
>  lib/s390x/sie.h | 6 ++++++
>  lib/s390x/sie.c | 4 ++--
>  2 files changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
> index c1724cf2..53cd767f 100644
> --- a/lib/s390x/sie.h
> +++ b/lib/s390x/sie.h
> @@ -281,6 +281,12 @@ void sie_expect_validity(struct vm *vm);
>  uint16_t sie_get_validity(struct vm *vm);
>  void sie_check_validity(struct vm *vm, uint16_t vir_exp);
>  void sie_handle_validity(struct vm *vm);
> +
> +static inline bool sie_is_pv(struct vm *vm)
> +{
> +	return vm->sblk->sdf =3D=3D 2;
> +}
> +
>  void sie_guest_sca_create(struct vm *vm);
>  void sie_guest_create(struct vm *vm, uint64_t guest_mem, uint64_t guest_=
mem_len);
>  void sie_guest_destroy(struct vm *vm);
> diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
> index 40936bd2..0fa915cf 100644
> --- a/lib/s390x/sie.c
> +++ b/lib/s390x/sie.c
> @@ -59,7 +59,7 @@ void sie(struct vm *vm)
>  	/* When a pgm int code is set, we'll never enter SIE below. */
>  	assert(!read_pgm_int_code());
> =20
> -	if (vm->sblk->sdf =3D=3D 2)
> +	if (sie_is_pv(vm))
>  		memcpy(vm->sblk->pv_grregs, vm->save_area.guest.grs,
>  		       sizeof(vm->save_area.guest.grs));
> =20
> @@ -98,7 +98,7 @@ void sie(struct vm *vm)
>  	/* restore the old CR 13 */
>  	lctlg(13, old_cr13);
> =20
> -	if (vm->sblk->sdf =3D=3D 2)
> +	if (sie_is_pv(vm))
>  		memcpy(vm->save_area.guest.grs, vm->sblk->pv_grregs,
>  		       sizeof(vm->save_area.guest.grs));
>  }


