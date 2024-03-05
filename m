Return-Path: <kvm+bounces-11068-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EB308728FC
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 21:58:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DFA4BB25954
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 20:58:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D554F12BEBB;
	Tue,  5 Mar 2024 20:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VBWqCKDG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21B0824A1D
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 20:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709672272; cv=none; b=ih9PZwSSPDiIEa5u9xMiIzLGxyV23/SALz1NgrfjI/LndAxPO4iyQiCM+v1Q3LgVNUULUSR+nGBTaGA7q4LeNvJcnfNYk1XagXlpxyphh1NwTcBHf1oDk7gVnPe8XmdIfxP5Nf8MUe9acgeUt788yxlfppUjLpRrTlcYydavA4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709672272; c=relaxed/simple;
	bh=4y2L0boXZTMV4TDb8hO8PgzieZmUzq9lbLSb3KvG8k0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZvfgiWROTpk9SO/2OF0/5AdrLtlkmkjhOhbrt4zRiyn8c9QHax/rpFsSpb8G8z8aULVctdxzQuZeevQYVMpBqW4IhiGz6wrb/DSXz8HQ+NF1NFEofCgoFjU5f8BY7m/f5zOySJADCa98uMecD7toxKFOvAdKzTZK1GYIjFi+YGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VBWqCKDG; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-42f024b809cso69541cf.0
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 12:57:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709672268; x=1710277068; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DMppHw7KV/r56VUSnIREU2O979JxXuHNtcifN4Olhis=;
        b=VBWqCKDGDtqfSjtVb345vt3+W6a38qDDSmcNfrprRiqVm5KKVxFG1eaTAs9zIWM7nw
         XkfOxDepJJzr4XmZd2u0E14fT33iq5bTYaYJAj3YXIw3pmu04FxywWf4wDtLfOOe835A
         8kzpzXszReLLvUFCmeHlZGEqYf+80F8kAuEVgvBt84uIPsSTZBAmHO6jNpzDHrfodkz5
         c6WNZ/4ukxpBT5QAY192A537hKlu+uJfMgubl5uWcaSnP+OBxYno6lBa2Na//z/s/1se
         X7EpWXiF+JDkISNr909WYap/KO8NOmEeRwkBSjEq4MPYqu9SXDfRAV7It/+xUW8waKIf
         +byg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709672268; x=1710277068;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DMppHw7KV/r56VUSnIREU2O979JxXuHNtcifN4Olhis=;
        b=wMnC1fxy+fMiVDKWGHbsAMPrD/RGx5Rrapka+zlHOPk2mcmNi/uvjjDPQsdemKqCdA
         AKqK1BcGOjyNmBr/idarcVVcy/bPVTfreBVl8/+Uf2mWhhKbr5qPc0wQ29jr2eFOUtHC
         DymdaC0QGL/XsR5C8dRUXcapzJOZ5wzu92kdhxjcvcxFgmKfwni0s2/ly4dqfBQujzV4
         UBNKEUrFisP64nBZzYyKD2DSY7yVidHJZjnMpf8LW45HhBGjkbz95T3gbrz1dkt61y+M
         EBkYp3+9zLsRtYlzqp+StNUED7/KSkqwlj5WkwYr9mEkWCNdDFr51mmbdt8/UQYtaGmW
         VM9g==
X-Forwarded-Encrypted: i=1; AJvYcCXBvSPqogCblkF5OmJEQ8px/REuFR7x0Vehisei66rvc+C+HM/90cvPaoI800X7mSLpYE+/4rl6VHGGKkm49qAK07Av
X-Gm-Message-State: AOJu0YzuQ3srEQSwe8dYHf6DHUqarQrmSi/Kn+7eJjDFrNWjn+fYBsRo
	Bk1GFxv5cgIJbiTIsW3HIi9m8eSlTWmqGzw18ZdteHyEryZm7k7flNIv7rUtvCI5HDg/7UsqXlH
	qr8cse+vsw8JHW6BsmXEW6b5gpoWoplaBWbtB
X-Google-Smtp-Source: AGHT+IHUUnMvT3jqlx4mYU0Zq3/oVljYM3tgXS+x8Lb6hAUG4wgFseZ7U1lT7XFjP+BusQQ9kBXfhI9r5cdZ6lf7hXM=
X-Received: by 2002:a05:622a:28c:b0:42e:6de9:cd13 with SMTP id
 z12-20020a05622a028c00b0042e6de9cd13mr258781qtw.3.1709672267992; Tue, 05 Mar
 2024 12:57:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240301194037.532117-1-mic@digikod.net> <20240301194037.532117-2-mic@digikod.net>
In-Reply-To: <20240301194037.532117-2-mic@digikod.net>
From: Rae Moar <rmoar@google.com>
Date: Tue, 5 Mar 2024 15:57:35 -0500
Message-ID: <CA+GJov4U+bXK3Q2cmXtsdnrNNiwuDmxsU4-ghVM_8M1vjyMVWA@mail.gmail.com>
Subject: Re: [PATCH v2 1/7] kunit: Handle thread creation error
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
> Previously, if a thread creation failed (e.g. -ENOMEM), the function was
> called (kunit_catch_run_case or kunit_catch_run_case_cleanup) without
> marking the test as failed.  Instead, fill try_result with the error
> code returned by kthread_run(), which will mark the test as failed and
> print "internal error occurred...".

Hello!

I have tested this and this fix looks good to me. Thanks!
-Rae

Reviewed-by: Rae Moar <rmoar@google.com>


>
> Cc: Brendan Higgins <brendanhiggins@google.com>
> Cc: David Gow <davidgow@google.com>
> Cc: Rae Moar <rmoar@google.com>
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
> Link: https://lore.kernel.org/r/20240301194037.532117-2-mic@digikod.net
> ---
>
> Changes since v1:
> * Added Kees's Reviewed-by.
> ---
>  lib/kunit/try-catch.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/lib/kunit/try-catch.c b/lib/kunit/try-catch.c
> index f7825991d576..a5cb2ef70a25 100644
> --- a/lib/kunit/try-catch.c
> +++ b/lib/kunit/try-catch.c
> @@ -69,6 +69,7 @@ void kunit_try_catch_run(struct kunit_try_catch *try_ca=
tch, void *context)
>                                   try_catch,
>                                   "kunit_try_catch_thread");
>         if (IS_ERR(task_struct)) {
> +               try_catch->try_result =3D PTR_ERR(task_struct);
>                 try_catch->catch(try_catch->context);
>                 return;
>         }
> --
> 2.44.0
>

