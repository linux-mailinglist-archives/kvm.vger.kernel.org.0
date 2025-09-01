Return-Path: <kvm+bounces-56455-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 34E9EB3E6A3
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 16:06:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 511EE3A8B11
	for <lists+kvm@lfdr.de>; Mon,  1 Sep 2025 14:06:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D31A335BB7;
	Mon,  1 Sep 2025 14:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kPFZEmva"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C879B1E3DCF
	for <kvm@vger.kernel.org>; Mon,  1 Sep 2025 14:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756735565; cv=none; b=sM9fymjjDdZ0kyr7FJZQa1hCTbq6hY4G67Wwf/jF90htEW03kkT/AtESXiAHlA/VdgVtWE7SpBuj3jtJOmj2dG8XzJfsl4sbdssWWnhcKvALDm6G7FmXevyWrJJA/YWLTdPU57/SzAH+vNngx4wUE6RJAudKKlIdShVAdJBNeTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756735565; c=relaxed/simple;
	bh=Z8r51LzaCqdM7YaSOwlv1z4L0d3GGajpW6BE8+RXYOc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sDx+/v+RkZEHw5Fh7M2/rRu0g/81XB4eynU+YbcnLVXFiKSCaCIlOvjP86Ro1UktSQyHs/70Wo25pD6lGmvryW5D5RR9Xgwoc2ypWNvk/XkAAidvIkXOFyc6r1RXdTMXDEASCznq64HO/JGrCPMJzTzb9zXajkUs9h6f3gfL+q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kPFZEmva; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-aff0365277aso452406766b.1
        for <kvm@vger.kernel.org>; Mon, 01 Sep 2025 07:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756735561; x=1757340361; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5dVCqf8Omc57edO6ZGy5stUhcPri4shQMFyY5oMwnIg=;
        b=kPFZEmvaQ/TnWrSvdhJmzVpJWG6O4pnn6FdS97zA506jFCtiXV58u1F2IbXaVxu6eT
         HutJ7AKs2WM+dWPuT2ROlc2Ky5bpTHzvfVQINqDFtMemB8w4867QYIH858CRLVCPBKA0
         Egne0N5vY36UtZBLLHeSToNLJ+0RLPF8gf2IzwmZpWR605PvvQDq3JJRkIubCNi1KJdB
         2rIZBsHtnUsL9FjR+ePbQwNFCkSGRIfLoQuBVWxFih8KkBhcIEyY1gsVPX7cx8zttMdg
         2Wj5v2uMIFjKa7/7S8jTQpPrWQXU4RH2l5MykbATUgywLbiRui9HJqUa3uGzYg1v2Mdk
         Gr6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756735561; x=1757340361;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5dVCqf8Omc57edO6ZGy5stUhcPri4shQMFyY5oMwnIg=;
        b=QcF6Kkg1ae4Raq+XSFuSkNu0mMQlAoUdpYJQWzQ4shAZb1wJw0ZkU5OFt0zDjcHsze
         0Zw98ofDIEJbF/nSmbGa4K0nD3MmNTz+xyxri1wBV6MxTGQVIc7ytKwCAHIaevM9Kq9v
         Jlc5xeJ4v7od8QnMAhFh11/tXaP9qa9lbEMo+VKIQi8Xx5vaaYWw8N4DYAwh8+66v5Sh
         UDq7j7daLJPvDud7AJ73DHyOsYl2BlGnPG9E6csBpAQBaq0LHQ1E90k9s62XPljL4UhW
         8sXMuycxGiW3dVMlDJc9m8g++9jXAqFFYqYrSZ280W0AQkMGnLiJS/pQPodw2DPzBIv8
         Rd7w==
X-Forwarded-Encrypted: i=1; AJvYcCXt+EGoTSBLCo2Auajkt4zrzKCWOW/FXmHjH3O8gZPyc63wlaND4tDRa6Jvr1sbJnT2jFU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5hZonHbxq9sitaQ3yIeTT8rl874GNzTSCa3FHmed2h7HczxsQ
	CguAypIsBlGgJihjQzy2DBaOQJuVKNOaUMVsKohfeirIH30+plsuBCTFDUP5Ggf7Nzp/axnng1P
	Nj9hfnre/nz3fYUE9xwyBb3BgUonrnLxGJoR8GzTVMQ==
X-Gm-Gg: ASbGncs75ZsoyCzzbLNTsqcRzy3tA15FHEe8AvEiatAqm6Z98bELMsdClBxUHFf2zkV
	h6HW0wJBZnnBj4DbHt+WsqOc2UwQdGqsriPuct7FtufSqaDFzXIWMrcFxjfon75OmFFEDFBvsCr
	dvJIcrq3xNahTH8cDlPTk2YheQOgREQKf5utp8+KOThfO4ywN1trFacXjp2rM5n6kF2lCzwOYo6
	8KGrtgMnG1p9eH7Rto=
X-Google-Smtp-Source: AGHT+IGMeylbGJEekwN2ny17r3fJ+X/GcbBYAcRcZM87PGqLjW5l6AKwKuc5xgj8Pb9qGNIdZ245B42T8nqD2u5a9Cg=
X-Received: by 2002:a17:907:1c9f:b0:afd:d62f:aa4a with SMTP id
 a640c23a62f3a-b010817fdf5mr782036466b.9.1756735560902; Mon, 01 Sep 2025
 07:06:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250901132626.28639-1-philmd@linaro.org> <20250901132626.28639-4-philmd@linaro.org>
In-Reply-To: <20250901132626.28639-4-philmd@linaro.org>
From: Manos Pitsidianakis <manos.pitsidianakis@linaro.org>
Date: Mon, 1 Sep 2025 17:05:34 +0300
X-Gm-Features: Ac12FXxpkS8-8lPh-jGklotJxuIKPXB7BvPFc2gMZW6beg-1Gs9p0zFbwrCtuCk
Message-ID: <CAAjaMXbDSwXjTFb5nPrK7tWyjbDtxm3mgxOwUK7yMUOG61y6qQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] docs/devel/style: Mention alloca() family API is forbidden
To: =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>, qemu-ppc@nongnu.org, 
	Peter Maydell <peter.maydell@linaro.org>, Harsh Prateek Bora <harshpb@linux.ibm.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Nicholas Piggin <npiggin@gmail.com>, 
	Chinmay Rath <rathc@linux.ibm.com>, kvm@vger.kernel.org, 
	Glenn Miles <milesg@linux.ibm.com>, Thomas Huth <thuth@redhat.com>, 
	=?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	=?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>, 
	Markus Armbruster <armbru@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 1, 2025 at 4:27=E2=80=AFPM Philippe Mathieu-Daud=C3=A9 <philmd@=
linaro.org> wrote:
>
> Suggested-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> ---

Reviewed-by: Manos Pitsidianakis <manos.pitsidianakis@linaro.org>

>  docs/devel/style.rst | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/docs/devel/style.rst b/docs/devel/style.rst
> index d025933808e..941fe14bfd4 100644
> --- a/docs/devel/style.rst
> +++ b/docs/devel/style.rst
> @@ -446,8 +446,8 @@ Low level memory management
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
>
>  Use of the ``malloc/free/realloc/calloc/valloc/memalign/posix_memalign``
> -APIs is not allowed in the QEMU codebase. Instead of these routines,
> -use the GLib memory allocation routines
> +or ``alloca/g_alloca/g_newa/g_newa0`` APIs is not allowed in the QEMU co=
debase.
> +Instead of these routines, use the GLib memory allocation routines
>  ``g_malloc/g_malloc0/g_new/g_new0/g_realloc/g_free``
>  or QEMU's ``qemu_memalign/qemu_blockalign/qemu_vfree`` APIs.
>
> --

If you wanna dust off your perl, you could also add this to checkpatch.pl :=
)

