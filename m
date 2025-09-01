Return-Path: <kvm+bounces-56456-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 10345B3E6AE
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 16:08:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BFFF8170795
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 14:08:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1DB733CEA0;
	Mon,  1 Sep 2025 14:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vS+9b1Um"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503F52D6E53
	for <kvm@vger.kernel.org>; Mon,  1 Sep 2025 14:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756735678; cv=none; b=jwxsInp9uV4dH3JBtjRIRmbGcpYrcUDp9JxJMGOSLIuTwAMX4XKJ15RFmKbvjiiX9FrA/t9/zWzAmTA6yqL1XRXy4/W7RGf3wSOAZkFqJdlXtVcdooBa7IFfGK8CTVfkRFOnaYub62Gu3RBQjIRy1OAUNTAS7XyaGswU5sLpjuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756735678; c=relaxed/simple;
	bh=vvQSn4FMxbfbKgtHlus5M010PTwtgO+jZyhezKln8Jo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N3+cANHamywunuRP47RGK1PJ8W9qR0jokLQEVLY+gZTZMM/FTLxZRFf1zKP/m0O8hF90xMJ/oqgWrlqOj9Wvg6DVQbJPm/IxYUlrJUdmvjydMjJN5OiOaf33koQgClkwTRyyB5R+tGx/e13l537N5oKRNKrrhhPmOdrazsrg2JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=vS+9b1Um; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-afedbb49c26so671666566b.2
        for <kvm@vger.kernel.org>; Mon, 01 Sep 2025 07:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756735674; x=1757340474; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2PHE4tDWICMpABeUd1pZW5Ag69gQXLtV4C2FyAibqdA=;
        b=vS+9b1UmiZySk0TQsd9+iWVZwNlfEkgSQ+BsgZw9n4Ifiiy+3D3x4OGn6K/OGBYwjr
         F35NmkuwFSbTeWoH9fJONm6hVkCWHXyFx98sQ761zvjKiWRhX0vIh3ZTegS4xY4uuVgG
         qXzJPENMg5cGP8IqfyJZBVw2A1RuMFVCNeFbkBsIF+cQgC02FIP6IXAugdSs5wtBoU+y
         v1Djn2gWz8RdjyrzubJtA52eBZwfec5JAuFQv8KkKTRBe9o3GQ+HHFOgjIOO0ls+j5Fp
         a9IZScF0g//9HsLS6vAa37Vp9dpCppvlHaDHT7N/dtbbzyDdRvM2Jf1akwgiS532ygFV
         9urw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756735674; x=1757340474;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2PHE4tDWICMpABeUd1pZW5Ag69gQXLtV4C2FyAibqdA=;
        b=iBiquXlCrlxF9G7IXPFeVOTCm000EFgaynh42sxdNWt3Pol/PwGjrdrP6J12KlrbEH
         lIQDrutTIaUFvX37Icn8KDq439H0aW8QDO7Hw5C1sjxdGpNB1yVae9BhLy+u1U6TGptI
         gaONjV1eogzhLDQ4Fx6ANZXkARWQK/OJ+egyo2IoDsr5Q3SV+WKEJ3wbVQXWBKqYyYt6
         Y3q8Fj1K1ITEkzNSWAARWiW41iSCJ+b3ploazDbpU6fDmNgU5v5sIs/Kh0M82IljSjWD
         EjIel3vrK0u6ZkXROVEn5CzcSftuwSbkNfYNvxxxN0DidAaEh94sPyIY8NHSwef7rhGv
         UooQ==
X-Forwarded-Encrypted: i=1; AJvYcCVqC59DgEFzMoXpq1wHcLJjrA4LlCnQ7boX+Srn3f1x2DLMFvgi6UBGK0lm2fatbpYh7oU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzwVCGzxWr+OgRCgBkqRpfI+2J+Tuza1zygkRmEEVpSI8GmssJa
	RxTEpYkP91/AJ7n0pnuAu6Q3wH2RwPk7wgDAK/9RrhyucjZn62OQRWT7vhGU7yoV+cRvnzw9mAq
	7FiuDk5YPOtYIsiJoXbb735o76qGAj5b8JSYBuQ0XTw==
X-Gm-Gg: ASbGncts0Ry9TLtvnn8xS5EuGRu+aUJiaYXTbQiHRyBu95ixu7mD5qj9vs4EzhJkGfv
	Uoj1zqWK+1U0B6ipzJKKuBKei1t8XOcA42lOQ7ASc7k4RhFgTWRoDEKJY2mE9Wcg+qi4ILBRbD2
	EHKvjB130QWP6iBA5lZcPV1SLX6tjRrQ1vQEo+XmYxiZrQ0Ccesr706OmDA/w16vU90LDXro7Hm
	B6aIePf
X-Google-Smtp-Source: AGHT+IFa9gNH32L7LfNpQ84Q5k35yE8UFMrugw7g5Fr7brDLMyX4Gt/1jIU8YVDpAnKuizEsRUUeIfpvuAtvPnZMatg=
X-Received: by 2002:a17:906:c10d:b0:b04:20c0:b219 with SMTP id
 a640c23a62f3a-b0420c0b768mr464735266b.64.1756735674498; Mon, 01 Sep 2025
 07:07:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250901132626.28639-1-philmd@linaro.org> <20250901132626.28639-2-philmd@linaro.org>
In-Reply-To: <20250901132626.28639-2-philmd@linaro.org>
From: Manos Pitsidianakis <manos.pitsidianakis@linaro.org>
Date: Mon, 1 Sep 2025 17:07:28 +0300
X-Gm-Features: Ac12FXyXcB9TTDyJP7s_K0eNH_-x4lszy9_5dAVZ56g7L8xKCQskrvBjXzM-6Cc
Message-ID: <CAAjaMXYN2E8quZxyB3pE88o_erJZrQ4LXFO22jrx+mzRHjb5zA@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] target/ppc/kvm: Avoid using alloca()
To: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>, qemu-ppc@nongnu.org, 
	Peter Maydell <peter.maydell@linaro.org>, Harsh Prateek Bora <harshpb@linux.ibm.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Nicholas Piggin <npiggin@gmail.com>, 
	Chinmay Rath <rathc@linux.ibm.com>, kvm@vger.kernel.org, 
	Glenn Miles <milesg@linux.ibm.com>, Thomas Huth <thuth@redhat.com>, 
	=?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	=?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 1, 2025 at 4:27=E2=80=AFPM Philippe Mathieu-Daud=C3=A9 <philmd@=
linaro.org> wrote:
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
> --
> 2.51.0
>
>

Reviewed-by: Manos Pitsidianakis <manos.pitsidianakis@linaro.org>

