Return-Path: <kvm+bounces-11070-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 49BF0872904
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 21:58:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6E4901C20441
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 20:58:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F34212D1E8;
	Tue,  5 Mar 2024 20:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VItnTInX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 338B212BEAA
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 20:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709672300; cv=none; b=C8/nUqbpSzlRbItfv9G1xk2GctEGHNY7OHVHeo/svVurVw5y7wicS53Nm6Lh3uWA38WC0h6ox9XR53ZHWIF3Qwz7IIJoj65162jIBAEGA3dTIDBOnJ0WKByqWR5cQeWPZzsvUXneaboLuiMlm/UQOteLtt4Ol8hqe7Z7umB0ask=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709672300; c=relaxed/simple;
	bh=hz+ZxSOYv8PxZNrsTqx4IxtCpcRrFHGU/VQIYl36LGQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T/mATlTbvB9y5I6f+mQOHMiQU7LVli75ya7tJ+cGB/Xu9jJRfNyjbQ9IEcmruPbXXgnGOwYbDndPzgG3MBBGihLp643+c9nLeXzDbBU4O0SK166XwDBPGaM0RY/OFNU1Lvkd8ImFd+HpnDQBomGHRAGp4WtijCResFyKO98N3jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VItnTInX; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-42ee0c326e8so58311cf.0
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 12:58:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709672297; x=1710277097; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NM9bu0HcRSpvQ/lk6AsEXTNfL1CGnBbQK/LGwtIb+y4=;
        b=VItnTInX7KAkkHOMp2ynIn3AlD2CYHHFuIraqXwe9THhasvj/qOOkonyVAxlRjOTWO
         kPo8lezaR4nNpxQJfm6V4lsF68/BZH2fvpVfYyaXLccHLrbh+4MievBbhCLPf508tC2R
         ZY+RuPcM+MhOetVT04AzXndvmTqnxvlWkNOKceGo6o+gTFbn0kB6Gs/VIRXG29TB7tsK
         lW3FcunEAG/JJrDbd5B4fhdZBjc7bQSxKvqE7kGC55M4wdpEQZgfEHGhnzOBgmVV2tVC
         chFM5sxG7LVxwOm4ONNVpchwCiDfe14GHs/s1MzYCG54VSk1Pc4Oa0EsDKwAnk0Wppkn
         AKxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709672297; x=1710277097;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NM9bu0HcRSpvQ/lk6AsEXTNfL1CGnBbQK/LGwtIb+y4=;
        b=dH7Utz5J4YB1kuU/3n+jm7poQ27uAHiOnzHF+Y+KpJdjcCzZT8lK6SXXSaTfFbZi0o
         Fxj39TpcLHjNTqC1y+K/NM8nAaF/lHvWaPsMKZw4hzLh0HW0oI0Ht+wiqaI7/cKBdbdL
         3GusAY9hZrG+Vkjl5OPWdVaNG1YxG9GLaWJjpkWVZhY+NHewQtNUGpiIeAH0faJa/I3Q
         kw0TQ2cxcgpRBfBEXhtM9RY/RzMmaDsReZpM6Yf+FPe4xSoypfdthJ7K+yBIDdXbvzi3
         Xh23j32ev8+VrPPySangTFfxvldLYTKZGXJ6sgJ++JBUnqAycmPb2yWXZ4zdWSZEjFL5
         zD2Q==
X-Forwarded-Encrypted: i=1; AJvYcCXlJSm7lGufYanumYIxjAbwjh3NI/diafqr4uBHBRpw+KUVUWJDrpxET9sIRbz6P2xTDVKs9EYc0nWsGQcKoYZL9ekq
X-Gm-Message-State: AOJu0YxNYyOmlRIVlle9sdx7IDnKardWWyvmEVhPKzDKbpSR2LGKFN0e
	D3WnT9AonfN158NPErTX7gmmQZYnkuR2F7qzcKRKhaDBB8fy0vdYfsxBTO7UKfd1m+eVHK+zFjE
	cvYE05+0ENMLVbp8rkTEcGIv11Flq9h/noe+v
X-Google-Smtp-Source: AGHT+IGJuhFV2CSZhTpphuYInlBxp0BhTfrnQUeh2OvKsSqzEL4tX1NuAVfzJjBoxId+yPuVZh+Ut8IQpuDDq6mQdxI=
X-Received: by 2002:ac8:59d5:0:b0:42f:a3c:2d4c with SMTP id
 f21-20020ac859d5000000b0042f0a3c2d4cmr72229qtf.13.1709672297226; Tue, 05 Mar
 2024 12:58:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240301194037.532117-1-mic@digikod.net> <20240301194037.532117-4-mic@digikod.net>
In-Reply-To: <20240301194037.532117-4-mic@digikod.net>
From: Rae Moar <rmoar@google.com>
Date: Tue, 5 Mar 2024 15:58:05 -0500
Message-ID: <CA+GJov4BPGuuu+oivgX3Z0J8sb1bYLhrNRrex7qza45WNMtBcQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/7] kunit: Fix timeout message
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: Brendan Higgins <brendanhiggins@google.com>, David Gow <davidgow@google.com>, 
	Kees Cook <keescook@chromium.org>, Shuah Khan <skhan@linuxfoundation.org>, 
	Alan Maguire <alan.maguire@oracle.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H . Peter Anvin" <hpa@zytor.com>, 
	Ingo Molnar <mingo@redhat.com>, James Morris <jamorris@linux.microsoft.com>, 
	Luis Chamberlain <mcgrof@kernel.org>, 
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>, Marco Pagani <marpagan@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, Stephen Boyd <sboyd@kernel.org>, 
	Thara Gopinath <tgopinath@microsoft.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Wanpeng Li <wanpengli@tencent.com>, 
	Zahra Tarkhani <ztarkhani@microsoft.com>, kvm@vger.kernel.org, 
	linux-hardening@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-um@lists.infradead.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 1, 2024 at 2:40=E2=80=AFPM Micka=C3=ABl Sala=C3=BCn <mic@digiko=
d.net> wrote:
>
> The exit code is always checked, so let's properly handle the -ETIMEDOUT
> error code.

Hello!

This change looks good to me. Thanks!
-Rae

Reviewed-by: Rae Moar <rmoar@google.com>


>
> Cc: Brendan Higgins <brendanhiggins@google.com>
> Cc: David Gow <davidgow@google.com>
> Cc: Rae Moar <rmoar@google.com>
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
> Link: https://lore.kernel.org/r/20240301194037.532117-4-mic@digikod.net
> ---
>
> Changes since v1:
> * Added Kees's Reviewed-by.
> ---
>  lib/kunit/try-catch.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/lib/kunit/try-catch.c b/lib/kunit/try-catch.c
> index 73f5007f20ea..cab8b24b5d5a 100644
> --- a/lib/kunit/try-catch.c
> +++ b/lib/kunit/try-catch.c
> @@ -79,7 +79,6 @@ void kunit_try_catch_run(struct kunit_try_catch *try_ca=
tch, void *context)
>         time_remaining =3D wait_for_completion_timeout(&try_completion,
>                                                      kunit_test_timeout()=
);
>         if (time_remaining =3D=3D 0) {
> -               kunit_err(test, "try timed out\n");
>                 try_catch->try_result =3D -ETIMEDOUT;
>                 kthread_stop(task_struct);
>         }
> @@ -94,6 +93,8 @@ void kunit_try_catch_run(struct kunit_try_catch *try_ca=
tch, void *context)
>                 try_catch->try_result =3D 0;
>         else if (exit_code =3D=3D -EINTR)
>                 kunit_err(test, "wake_up_process() was never called\n");
> +       else if (exit_code =3D=3D -ETIMEDOUT)
> +               kunit_err(test, "try timed out\n");
>         else if (exit_code)
>                 kunit_err(test, "Unknown error: %d\n", exit_code);
>
> --
> 2.44.0
>

