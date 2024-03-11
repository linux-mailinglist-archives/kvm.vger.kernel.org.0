Return-Path: <kvm+bounces-11594-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF74B8789FB
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 22:21:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D2FAB1C20F81
	for <lists+kvm@lfdr.de>; Mon, 11 Mar 2024 21:21:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 142BC6AAD;
	Mon, 11 Mar 2024 21:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fe9JsAcN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F25E57305
	for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 21:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710192088; cv=none; b=XyJn6rXMa8bbJyJp0XCgq0dC9k5KMgZmbNEP+0ELIrkn48RXTumuLH+NmKvN70pCcsuN9IZP/5Mr8TQ3MRoYX8y2wjJIGUcGs3UGKUILh/thEBrlGrXlcboE6ETAbMQz0fuRZr0L7gBaNcWXShdmAJvTtIHgxT0C46u6gSaujPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710192088; c=relaxed/simple;
	bh=A6ntQXftXcfk9NPKtChVN+Afbvy2gvAYMqZPZc9sTXM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y0F+0jEFJeAwyilT9dA63Jpt1nBdhSLkesYMw8vFkd0EQYP1pY9v9h5UQtqvn/qudjSU0oAQrjtg7FCxg2BEd2GXGhbrKakSpOr/nYVw8KlfUPWLjvUb0cH4MFQbqT5oaESKPBICy9N5pWgnK5v3e5AzeJkzbP/P+odRBwL90JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fe9JsAcN; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-42ef8193ae6so20631cf.1
        for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 14:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1710192084; x=1710796884; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TWb2A9iIkGs3AmFlz53bU5Efj9ZUWJhfOe0zRp0tGRc=;
        b=fe9JsAcNoppnf2NHLwSLwh8xceOCZguLT1vqJQ+vx3TMH5gp7+Py1/+ZZry+jaxZye
         JHnSqCJuoIbruT0jYmEiG323JHDGZ8R7TVUwotAERoHvoFFlMVgp3dJ5KxXkjIa0EAKg
         TPJdrO9vzTPwNmTdW1NucQCPjgzu5HccyYZHjQCWA74O4VJ+WJJaiISObYdBZrhlmkzE
         xjXPvyRTnOluHpoP54BbvKobb0OAaRr9TvbZ48GSe4ZJgKxyx8NC0OQMfYXpkhT2Kuq4
         mpBNA4XsZVI0Eam65OS7N7erBrL7+lWXvFJm6Tr8yf3M7KiYXs45AjTgcguK0UgXvIsT
         N9Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710192084; x=1710796884;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TWb2A9iIkGs3AmFlz53bU5Efj9ZUWJhfOe0zRp0tGRc=;
        b=HW1AWFsDlMiUqeWbGqgS1iQ2bpFwJykJJbdUmpyeAm0zaxVjA8zcBUNa1JB5xiyiit
         sdXJbahOs35Hn1YGG5css8ANxqS8NQd7LZAQK7m4idSDj4cCWXIZ29J573z0b1lVP4G4
         leJ+d1cUSZ6VgheRLC1wAB8g5ZmDlTcZuwmX50uCQlafNeHDg1H4zSkIoplW6UmsPHue
         EYD+70ZOtje7CcwV09uZqkYmSmfyjjgQa/5gtBg8x7WiWCIjCyeLEhQYXKRgwdP7v3fT
         NpeJKk9JE95cituOfbnvkaJ1LvKIuxpLdWg5t+tnsjz8FK0Ctx1vxKa3NBdmyKyGokf/
         F1sw==
X-Forwarded-Encrypted: i=1; AJvYcCWd4Ch3YV8dd6F7UydVnswk9IKaJC8yuzOzKEI+13VkkvHEz7Pov0zZeFSv/iV59+QnDN2iL084Xv6xm0aaqLYSSldp
X-Gm-Message-State: AOJu0Yz6sMywQdwPzcB7TZ59gXCJIYkgKgYkIZ3UK3nuwfDx5tHlZk/I
	1eiaIXjP9Xw05AXbuyJR17Ya33xZZNwRIV+qVafQ/4+7APnZGfHQQ1RMShvOAye0x+sdtBWfNnN
	wAKFKpKf/eQlxjDN1gg9ru2G1O5AvG73Ot10T
X-Google-Smtp-Source: AGHT+IGiw3N/c7EMgtHBYf+GhpaM4BMFpUmbsLp7eZNB/I9uRFUCN7Phn/vKm3/rRq1HFpGOLfkrYTvw5DSVfzOksbM=
X-Received: by 2002:ac8:748f:0:b0:42f:213a:dc9b with SMTP id
 v15-20020ac8748f000000b0042f213adc9bmr36743qtq.19.1710192084473; Mon, 11 Mar
 2024 14:21:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240301194037.532117-1-mic@digikod.net> <20240301194037.532117-5-mic@digikod.net>
In-Reply-To: <20240301194037.532117-5-mic@digikod.net>
From: Rae Moar <rmoar@google.com>
Date: Mon, 11 Mar 2024 17:21:11 -0400
Message-ID: <CA+GJov7in4o6bXt_JDqeGjjD08yOweiUshesS4cUWTHYfgJAwQ@mail.gmail.com>
Subject: Re: [PATCH v2 4/7] kunit: Handle test faults
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
> Previously, when a kernel test thread crashed (e.g. NULL pointer
> dereference, general protection fault), the KUnit test hanged for 30
> seconds and exited with a timeout error.
>
> Fix this issue by waiting on task_struct->vfork_done instead of the
> custom kunit_try_catch.try_completion, and track the execution state by
> initially setting try_result with -EFAULT and only setting it to 0 if

Hello!

Thanks for your patch! This has been tested and seems pretty good to
me but I just have a few questions. First, do you mean here "setting
try_result with -EINTR"  instead?

But happy to add the tested-by.

Tested-by: Rae Moar <rmoar@google.com>

Thanks!
-Rae

> the test passed.
>
> Fix kunit_generic_run_threadfn_adapter() signature by returning 0
> instead of calling kthread_complete_and_exit().  Because thread's exit
> code is never checked, always set it to 0 to make it clear.
>
> Fix the -EINTR error message, which couldn't be reached until now.
>
> This is tested with a following patch.
>
> Cc: Brendan Higgins <brendanhiggins@google.com>
> Cc: David Gow <davidgow@google.com>
> Cc: Rae Moar <rmoar@google.com>
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
> Link: https://lore.kernel.org/r/20240301194037.532117-5-mic@digikod.net
> ---
>
> Changes since v1:
> * Added Kees's Reviewed-by.
> ---
>  include/kunit/try-catch.h |  3 ---
>  lib/kunit/try-catch.c     | 14 +++++++-------
>  2 files changed, 7 insertions(+), 10 deletions(-)
>
> diff --git a/include/kunit/try-catch.h b/include/kunit/try-catch.h
> index c507dd43119d..7c966a1adbd3 100644
> --- a/include/kunit/try-catch.h
> +++ b/include/kunit/try-catch.h
> @@ -14,13 +14,11 @@
>
>  typedef void (*kunit_try_catch_func_t)(void *);
>
> -struct completion;
>  struct kunit;
>
>  /**
>   * struct kunit_try_catch - provides a generic way to run code which mig=
ht fail.
>   * @test: The test case that is currently being executed.
> - * @try_completion: Completion that the control thread waits on while te=
st runs.
>   * @try_result: Contains any errno obtained while running test case.
>   * @try: The function, the test case, to attempt to run.
>   * @catch: The function called if @try bails out.
> @@ -46,7 +44,6 @@ struct kunit;
>  struct kunit_try_catch {
>         /* private: internal use only. */
>         struct kunit *test;
> -       struct completion *try_completion;
>         int try_result;
>         kunit_try_catch_func_t try;
>         kunit_try_catch_func_t catch;
> diff --git a/lib/kunit/try-catch.c b/lib/kunit/try-catch.c
> index cab8b24b5d5a..c6ee4db0b3bd 100644
> --- a/lib/kunit/try-catch.c
> +++ b/lib/kunit/try-catch.c
> @@ -18,7 +18,7 @@
>  void __noreturn kunit_try_catch_throw(struct kunit_try_catch *try_catch)
>  {
>         try_catch->try_result =3D -EFAULT;
> -       kthread_complete_and_exit(try_catch->try_completion, -EFAULT);
> +       kthread_exit(0);
>  }
>  EXPORT_SYMBOL_GPL(kunit_try_catch_throw);
>
> @@ -26,9 +26,12 @@ static int kunit_generic_run_threadfn_adapter(void *da=
ta)
>  {
>         struct kunit_try_catch *try_catch =3D data;
>
> +       try_catch->try_result =3D -EINTR;
>         try_catch->try(try_catch->context);
> +       if (try_catch->try_result =3D=3D -EINTR)
> +               try_catch->try_result =3D 0;
>
> -       kthread_complete_and_exit(try_catch->try_completion, 0);
> +       return 0;

Really my only question is why we do not need to still do a
kthread_exit(0) here? I realize we are not checking the thread's exit
code but isn't it safer to call kthread_exit(). I'm new to kthread so
I am not too sure.

>  }
>
>  static unsigned long kunit_test_timeout(void)
> @@ -58,13 +61,11 @@ static unsigned long kunit_test_timeout(void)
>
>  void kunit_try_catch_run(struct kunit_try_catch *try_catch, void *contex=
t)
>  {
> -       DECLARE_COMPLETION_ONSTACK(try_completion);
>         struct kunit *test =3D try_catch->test;
>         struct task_struct *task_struct;
>         int exit_code, time_remaining;
>
>         try_catch->context =3D context;
> -       try_catch->try_completion =3D &try_completion;
>         try_catch->try_result =3D 0;
>         task_struct =3D kthread_create(kunit_generic_run_threadfn_adapter=
,
>                                      try_catch, "kunit_try_catch_thread")=
;
> @@ -75,8 +76,7 @@ void kunit_try_catch_run(struct kunit_try_catch *try_ca=
tch, void *context)
>         }
>         get_task_struct(task_struct);
>         wake_up_process(task_struct);
> -
> -       time_remaining =3D wait_for_completion_timeout(&try_completion,
> +       time_remaining =3D wait_for_completion_timeout(task_struct->vfork=
_done,
>                                                      kunit_test_timeout()=
);
>         if (time_remaining =3D=3D 0) {
>                 try_catch->try_result =3D -ETIMEDOUT;
> @@ -92,7 +92,7 @@ void kunit_try_catch_run(struct kunit_try_catch *try_ca=
tch, void *context)
>         if (exit_code =3D=3D -EFAULT)
>                 try_catch->try_result =3D 0;
>         else if (exit_code =3D=3D -EINTR)
> -               kunit_err(test, "wake_up_process() was never called\n");
> +               kunit_err(test, "try faulted\n");
>         else if (exit_code =3D=3D -ETIMEDOUT)
>                 kunit_err(test, "try timed out\n");
>         else if (exit_code)
> --
> 2.44.0
>

