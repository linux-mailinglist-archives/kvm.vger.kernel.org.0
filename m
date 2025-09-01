Return-Path: <kvm+bounces-56446-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C1207B3E502
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 15:31:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 872443B1B41
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 13:30:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7882B322C7C;
	Mon,  1 Sep 2025 13:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wl/TPMhO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com [209.85.219.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EACED198A11
	for <kvm@vger.kernel.org>; Mon,  1 Sep 2025 13:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756733449; cv=none; b=RuHZX6F97OPvtiaRK8E441vW+09MvvVteEgkwZxRarhDRJxjL+xuIEkGyrfXTYK6tS9jvCK1Fms/RGlKLCuLR8KhAeHpXIgABvS2NB3J4es8HnAsaOGJHixyJLsMR8OWmrD9pwOB3BwBirt/1WhbLSzbEfMvVyGfea7IEGJT+8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756733449; c=relaxed/simple;
	bh=CBYs5qj/qBT/hua+1vjHcbhyFEZE6eeWlMj/5w7ZU3A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FU/hm+3+V8/K/8MlQioqzJQGqkzvbTC98ieJSbWXqC762d9397qZjcbbo4Axpbo8aoUcekc5LbIYQscAk3QxjnwELp/x7Ki2Y7vOe4WQJ67xISqGeZCPW0p3KQlr5yQhEPdFV3CScxFLnArmsljDlTtWO11TT1d4fQIWEIyH4pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wl/TPMhO; arc=none smtp.client-ip=209.85.219.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-yb1-f182.google.com with SMTP id 3f1490d57ef6-e98b7071cc9so883567276.3
        for <kvm@vger.kernel.org>; Mon, 01 Sep 2025 06:30:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756733447; x=1757338247; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3wewDKBxoOFdqvc7S2uy/Z6NBdCATlYzXKB/aUZXycw=;
        b=wl/TPMhOUOd2CW3hhW7WMnuc62gwzIi2tzYzuwLfrORV/d/nUQe6fXxbWdrT0ZG+pZ
         EBoSnepwZJ4aHetyYrBLIwMHPet2C9Cplvrhw/RfKpQBppRH0YyfuTw/ceB+yopdkIOZ
         /CxFpvi+Z5wm/tbRgB2T8KOD37k1MO4/XRU11ptcfcPFJMmYHp7FBXZvdxKVi7VlBoP3
         89iZ+gc8q8uJqKORoTL4mjInOYJt0V5T0CHeY8IEYrKSlZlBYyssz25W/ckg7pWmVmpu
         wnSE76tfKzeo6DCADPumKQTBAWt4WCJG2ONugX+/rS0LKeoQxCiA3jCQWCgJ5qLSK7fg
         7ZKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756733447; x=1757338247;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3wewDKBxoOFdqvc7S2uy/Z6NBdCATlYzXKB/aUZXycw=;
        b=EE6MLY8++QBXCTe039QVoquR/LKvQjfl6ppy3zddkxah1qlToqBd3QCc7Azdla0Zvv
         2rHhXPxCZKKvAfv/Vyjoqu2DmTKuJbas/yMVFYZwuO8Ce+3u6YOSvV3ZtSJcyzLzeO8/
         AAmIDfPxDxizj3owQziKCOM8OlEOnu78TEmFPGaOohOKwFsUD0RKaJHteS7kL1gAFoj/
         +XDiaiBajkKdpUGaZZOaq6S1sRB6xAT3vanf5mImZ9tOUnV5LdYZN+rQ4oFuk8eC1L/1
         R+InvOpHB130iyYQo66V6koooiflgByFkd7akDXfuPKtfFzEW/+onJZkhPRiI1fCXxQD
         aYiQ==
X-Forwarded-Encrypted: i=1; AJvYcCVWWT+XgCFB65tv0lZhq2Bz+uyWaK2+gYWdSqaFumMHOika3Dyxsk8VyQ2BrB3Ckhfos6A=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy31X/ViQQ9/ha7bPdagBuLUyc8KUWkLGMr1wTk2T6XAdBgbA1p
	RIpCxN/DqbC0G+ZGbyTfK/QdqY9BRWaEVGFHweKexJyBHJMvdibLaeg0mGxau5zMZnTjJ51rhoN
	BMBP6MX5oUeQNsJ49FuiGIyw1ccTyrfhpQX/J+qBKFQ==
X-Gm-Gg: ASbGnctKA6oqh+zTTZYXiRA/pWWi5tLbKTnB7f7nmdct1uhYyR0GcT0S/CmD/jANvK8
	4jv6XM5J3femge97z/F1yCYHGsOISVT22B69ZNUuHFFCSyAifFObWKeaSc5pzU5sAp4U7iEyDPa
	hpFP3XS2/H/STTC4TQpFSRQ0j5UHcSWqWbnZWkUBq7HCK7XOyarQjqdZwf6PZmDBwwzMO5qY9LY
	oqSf9rn
X-Google-Smtp-Source: AGHT+IGzjinj1Be9uhF4e9coeqgVzYuT4x2ZSFoce3lK5RZMIpoiIrsyrN+OSeim8sWHmwNEAkHYp47S9Ww/3rxmKDs=
X-Received: by 2002:a05:690c:dcd:b0:721:30a5:3bf1 with SMTP id
 00721157ae682-7227636c956mr97919527b3.16.1756733446963; Mon, 01 Sep 2025
 06:30:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250901132626.28639-1-philmd@linaro.org> <20250901132626.28639-2-philmd@linaro.org>
In-Reply-To: <20250901132626.28639-2-philmd@linaro.org>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Mon, 1 Sep 2025 14:30:35 +0100
X-Gm-Features: Ac12FXwmkA9tdz4_ZeSzqYzgko3ZQfxuJ-MQJ-B3TXNsqo3Nq-CJMU_3_X1R4CI
Message-ID: <CAFEAcA-AysYGvuVL07DBaRvhFzRpCgO8cO6oeQUXEPRNhRoCGA@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] target/ppc/kvm: Avoid using alloca()
To: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>, qemu-ppc@nongnu.org, 
	Harsh Prateek Bora <harshpb@linux.ibm.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	Nicholas Piggin <npiggin@gmail.com>, Chinmay Rath <rathc@linux.ibm.com>, kvm@vger.kernel.org, 
	Glenn Miles <milesg@linux.ibm.com>, Thomas Huth <thuth@redhat.com>, 
	=?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	=?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 1 Sept 2025 at 14:26, Philippe Mathieu-Daud=C3=A9 <philmd@linaro.or=
g> wrote:
>
> kvmppc_load_htab_chunk() is used for migration, thus is not
> a hot path. Use the heap instead of the stack, removing the
> alloca() call.
>
> Reported-by: Peter Maydell <peter.maydell@linaro.org>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> ---
>  target/ppc/kvm.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
> index d145774b09a..937b9ee986d 100644
> --- a/target/ppc/kvm.c
> +++ b/target/ppc/kvm.c
> @@ -2760,11 +2760,10 @@ int kvmppc_save_htab(QEMUFile *f, int fd, size_t =
bufsize, int64_t max_ns)
>  int kvmppc_load_htab_chunk(QEMUFile *f, int fd, uint32_t index,
>                             uint16_t n_valid, uint16_t n_invalid, Error *=
*errp)
>  {
> -    struct kvm_get_htab_header *buf;
>      size_t chunksize =3D sizeof(*buf) + n_valid * HASH_PTE_SIZE_64;
> +    g_autofree struct kvm_get_htab_header *buf =3D g_malloc(chunksize);
>      ssize_t rc;
>
> -    buf =3D alloca(chunksize);
>      buf->index =3D index;
>      buf->n_valid =3D n_valid;
>      buf->n_invalid =3D n_invalid;

Reviewed-by: Peter Maydell <peter.maydell@linaro.org>

thanks
-- PMM

