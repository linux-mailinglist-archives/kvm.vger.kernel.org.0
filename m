Return-Path: <kvm+bounces-11069-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F0ADB8728FF
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 21:58:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 157C7B29931
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 20:58:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C492112C55A;
	Tue,  5 Mar 2024 20:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ITZvfUJr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1C312AAE7
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 20:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709672286; cv=none; b=KHyEGk2u0ZVzFQhFQoE96vRy7xNUlDX+onEwgz4s8VXAOS5aS5Oh/EgH+gBQu9F58V5A3nxTJDVYnewDT2TZc3LoxY9XvLCIZrd1OjkWfGui4V9ltlgWJcvPHu05jIJrg+7DjvB8Ptt7INh3HrMVkWrYdUsMaJ6bWX9hs7f03Eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709672286; c=relaxed/simple;
	bh=wWG/Kgy0jS1x5qSuFdcHkkq/gavTMiUaXVlXVaHjyIQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nCUgzISZbQF2yG9ZattxABJPMZ6tXDqmb+4nz/ewrpPB8Dpkw7G1F4rXCr7KjFqVPs23C+/w4jVb2Rv+solqzmjKb+NrrCGAlmyjIIi8fZVk2ov/kt+8uOKSm6luQ4CD03t1YUH8rU+O1HVj1ueA0moU5Z/7mrtEFOjj75tJx0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ITZvfUJr; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-42ef8193ae6so82101cf.1
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 12:58:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709672283; x=1710277083; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WxiO4n45vzilrBo9kDMmtmLfT3QtdcOwiJ3TQqHhtUU=;
        b=ITZvfUJraFd5Y8WZ0O2trYqgAs5xl8lqnJTECVALowK09cCrh1igdXQpaDBOzvMoRO
         WcPIibKjwXXeq2m7cWRpDwuqTveNL+JZtgBDSBpxVbxOO1BPPCUqn+hSYPjBlIOyCEfJ
         SgG1wfga3dAyR/5yP/Kzq/i9Vpjfn+EFwz1Qa1bFTUMsvvWQROxj8bpVBrIwgOGjxuak
         WvN275O+tmeQOvxrJGgxdUPdbMcR/J7E82VV7c88yAcfDf1TvFwclC9ExtoewAqD/pa9
         uvbPaFoekaJDVNQGCW7vOaJUqI0UrqcOiNzb7oUBaIYJ0jCyZ91IbXMfEtYQietkumQV
         q8Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709672283; x=1710277083;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WxiO4n45vzilrBo9kDMmtmLfT3QtdcOwiJ3TQqHhtUU=;
        b=tWW8UmrWLgJ80CK152dI5iKV8as42yqALErkF+Dn7n4kek6XkDNmORn4AGUvITygbx
         PGvTrvO0CwGK6g/0QeaEbvuT57dnD34XzGD+ZJFe1yJdA5IuVoheVo7KkDZ7KLZV2JTC
         3RHn5uYXwExaZKLKn1A3Et8pa17lIcg/rZnNZNE5WA8kqEPtRMeHaDOc0Zf8+L2MtN9s
         xuGUedr19kA6BJxi6Xq00e9+Yx45c5m+a4LqUfsBapODyH7iA3R969Z5a3UBTuB2vPov
         ey9TYvRC/OecfFC+YSVBJdr3Dk7GjRQ/8mLTGmuGDYzWyPSOYwmlfguton9mqX7XtQSR
         /25g==
X-Forwarded-Encrypted: i=1; AJvYcCUeQCSPew0LKDN+BLEfk0XDGEl5XWkOEQn4+qfDUbXwPW1C0DZguyiqKLtDDB8TxO9ssAM6s8AzCNyRP4v4ZGq47kGq
X-Gm-Message-State: AOJu0YybZkR0tCd2pNlec96BjLyj2wAmWLkDnOpnPHtcKNecBCjQYfoM
	hr0T/WWmg9GaZGYB2zAjy8KME9Djnl0J2XqGQgB49vgrwBqQJ6Xna0EaqaJdHe/nwXFA102KwV2
	POyLvcnsYAP3SOpwmln0z5oiEx0hUDkksBCYF
X-Google-Smtp-Source: AGHT+IHGajjUdBLk7kb5aU5IzN9BFfXaz7kyHr0r9Hfw9dnJJ6/Mro4cDB9qMZ+LQnnYDduac+wAa+5vLvNmFAFMPZ8=
X-Received: by 2002:a05:622a:489:b0:42e:ef12:8025 with SMTP id
 p9-20020a05622a048900b0042eef128025mr263015qtx.25.1709672283186; Tue, 05 Mar
 2024 12:58:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240301194037.532117-1-mic@digikod.net> <20240301194037.532117-3-mic@digikod.net>
In-Reply-To: <20240301194037.532117-3-mic@digikod.net>
From: Rae Moar <rmoar@google.com>
Date: Tue, 5 Mar 2024 15:57:51 -0500
Message-ID: <CA+GJov46__vOS9m7Jz9tw+nxd1LFh_a=g1SR=BjUzR9HT65Vew@mail.gmail.com>
Subject: Re: [PATCH v2 2/7] kunit: Fix kthread reference
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
> There is a race condition when a kthread finishes after the deadline and
> before the call to kthread_stop(), which may lead to use after free.

Hello!

I have tested this patch and it looks good to me.

Thanks!
-Rae

Reviewed-by: Rae Moar <rmoar@google.com>




>
> Cc: Brendan Higgins <brendanhiggins@google.com>
> Cc: David Gow <davidgow@google.com>
> Cc: Rae Moar <rmoar@google.com>
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
> Link: https://lore.kernel.org/r/20240301194037.532117-3-mic@digikod.net
> ---
>
> Changes since v1:
> * Added Kees's Reviewed-by.
> ---
>  lib/kunit/try-catch.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/lib/kunit/try-catch.c b/lib/kunit/try-catch.c
> index a5cb2ef70a25..73f5007f20ea 100644
> --- a/lib/kunit/try-catch.c
> +++ b/lib/kunit/try-catch.c
> @@ -11,6 +11,7 @@
>  #include <linux/completion.h>
>  #include <linux/kernel.h>
>  #include <linux/kthread.h>
> +#include <linux/sched/task.h>
>
>  #include "try-catch-impl.h"
>
> @@ -65,14 +66,15 @@ void kunit_try_catch_run(struct kunit_try_catch *try_=
catch, void *context)
>         try_catch->context =3D context;
>         try_catch->try_completion =3D &try_completion;
>         try_catch->try_result =3D 0;
> -       task_struct =3D kthread_run(kunit_generic_run_threadfn_adapter,
> -                                 try_catch,
> -                                 "kunit_try_catch_thread");
> +       task_struct =3D kthread_create(kunit_generic_run_threadfn_adapter=
,
> +                                    try_catch, "kunit_try_catch_thread")=
;
>         if (IS_ERR(task_struct)) {
>                 try_catch->try_result =3D PTR_ERR(task_struct);
>                 try_catch->catch(try_catch->context);
>                 return;
>         }
> +       get_task_struct(task_struct);
> +       wake_up_process(task_struct);
>
>         time_remaining =3D wait_for_completion_timeout(&try_completion,
>                                                      kunit_test_timeout()=
);
> @@ -82,6 +84,7 @@ void kunit_try_catch_run(struct kunit_try_catch *try_ca=
tch, void *context)
>                 kthread_stop(task_struct);
>         }
>
> +       put_task_struct(task_struct);
>         exit_code =3D try_catch->try_result;
>
>         if (!exit_code)
> --
> 2.44.0
>

