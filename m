Return-Path: <kvm+bounces-11660-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B0098793ED
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 13:15:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EB8F11F23C57
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 12:15:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BC3A7A133;
	Tue, 12 Mar 2024 12:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="AAQtm6hv"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-8fa9.mail.infomaniak.ch (smtp-8fa9.mail.infomaniak.ch [83.166.143.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3F779DD3;
	Tue, 12 Mar 2024 12:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=83.166.143.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710245722; cv=none; b=pDyZnTfTui0imSvYaBfs0cjOQBA4u+1Y/4t88eY2NLXcGPwQ0KDjHysfN4mWA8lRBat1MU1flQ9XXL/7CkztWGR9YFH6ifZtlTyZIQYWS2ihHacM98Gq3Gv5vYlo78qJ+hefAI/Y0gvTibwYrLUKzdjkmYVSvD7SjWEpSdLQ1Ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710245722; c=relaxed/simple;
	bh=UIPlBlQ2gSp7viPBKsB16/eqMI1pgjsYrWQKabWN1/s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XjVCoMLFcy4pmk0O+Q88G79kSwi9X4urXddia+O8DUIoCvSslv63nWiwjEI/2shgb06JEfxrpMl6SLkOj/OKdF8W5Bt306iuLm7XnzzYbly81GYtTs77U/0mlQz2YIoN8XofUAEhPBbmAPzUYbcqr3CUk2PVnJn1gIurtF93/8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=AAQtm6hv; arc=none smtp.client-ip=83.166.143.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Received: from smtp-3-0000.mail.infomaniak.ch (smtp-3-0000.mail.infomaniak.ch [10.4.36.107])
	by smtp-4-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4TvCJf11Fxz3my;
	Tue, 12 Mar 2024 13:15:14 +0100 (CET)
Received: from unknown by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4TvCJc1dKzzsW;
	Tue, 12 Mar 2024 13:15:12 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
	s=20191114; t=1710245714;
	bh=UIPlBlQ2gSp7viPBKsB16/eqMI1pgjsYrWQKabWN1/s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AAQtm6hvd8D/0qDhpfGiSpJYAJ7c4ZRRdmzxuwHAMDZ5D0rNCT9rpMwm0n6kBYZLn
	 MIieECao+whDew4238DUdSRRjeO6cebzxSywIl7f+OXZViuaJ/cEfbfTEn2VgfYZI/
	 vd+XiTlMZIXWiNScOcBSP9ExwIwlT9QI5LQs6vEU=
Date: Tue, 12 Mar 2024 13:15:01 +0100
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Rae Moar <rmoar@google.com>
Cc: Brendan Higgins <brendanhiggins@google.com>, 
	David Gow <davidgow@google.com>, Kees Cook <keescook@chromium.org>, 
	Shuah Khan <skhan@linuxfoundation.org>, Alan Maguire <alan.maguire@oracle.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H . Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, 
	James Morris <jamorris@linux.microsoft.com>, Luis Chamberlain <mcgrof@kernel.org>, 
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>, Marco Pagani <marpagan@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Stephen Boyd <sboyd@kernel.org>, Thara Gopinath <tgopinath@microsoft.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Wanpeng Li <wanpengli@tencent.com>, Zahra Tarkhani <ztarkhani@microsoft.com>, kvm@vger.kernel.org, 
	linux-hardening@vger.kernel.org, linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-um@lists.infradead.org, x86@kernel.org
Subject: Re: [PATCH v2 4/7] kunit: Handle test faults
Message-ID: <20240312.iuVoThuud2oi@digikod.net>
References: <20240301194037.532117-1-mic@digikod.net>
 <20240301194037.532117-5-mic@digikod.net>
 <CA+GJov7in4o6bXt_JDqeGjjD08yOweiUshesS4cUWTHYfgJAwQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+GJov7in4o6bXt_JDqeGjjD08yOweiUshesS4cUWTHYfgJAwQ@mail.gmail.com>
X-Infomaniak-Routing: alpha

On Mon, Mar 11, 2024 at 05:21:11PM -0400, Rae Moar wrote:
> On Fri, Mar 1, 2024 at 2:40 PM Mickaël Salaün <mic@digikod.net> wrote:
> >
> > Previously, when a kernel test thread crashed (e.g. NULL pointer
> > dereference, general protection fault), the KUnit test hanged for 30
> > seconds and exited with a timeout error.
> >
> > Fix this issue by waiting on task_struct->vfork_done instead of the
> > custom kunit_try_catch.try_completion, and track the execution state by
> > initially setting try_result with -EFAULT and only setting it to 0 if
> 
> Hello!
> 
> Thanks for your patch! This has been tested and seems pretty good to
> me but I just have a few questions. First, do you mean here "setting
> try_result with -EINTR"  instead?

Good catch, I indeed meant -EINTR.

> 
> But happy to add the tested-by.
> 
> Tested-by: Rae Moar <rmoar@google.com>
> 
> Thanks!
> -Rae
> 
> > the test passed.
> >
> > Fix kunit_generic_run_threadfn_adapter() signature by returning 0
> > instead of calling kthread_complete_and_exit().  Because thread's exit
> > code is never checked, always set it to 0 to make it clear.
> >
> > Fix the -EINTR error message, which couldn't be reached until now.
> >
> > This is tested with a following patch.
> >
> > Cc: Brendan Higgins <brendanhiggins@google.com>
> > Cc: David Gow <davidgow@google.com>
> > Cc: Rae Moar <rmoar@google.com>
> > Cc: Shuah Khan <skhan@linuxfoundation.org>
> > Reviewed-by: Kees Cook <keescook@chromium.org>
> > Signed-off-by: Mickaël Salaün <mic@digikod.net>
> > Link: https://lore.kernel.org/r/20240301194037.532117-5-mic@digikod.net
> > ---
> >
> > Changes since v1:
> > * Added Kees's Reviewed-by.
> > ---
> >  include/kunit/try-catch.h |  3 ---
> >  lib/kunit/try-catch.c     | 14 +++++++-------
> >  2 files changed, 7 insertions(+), 10 deletions(-)
> >
> > diff --git a/include/kunit/try-catch.h b/include/kunit/try-catch.h
> > index c507dd43119d..7c966a1adbd3 100644
> > --- a/include/kunit/try-catch.h
> > +++ b/include/kunit/try-catch.h
> > @@ -14,13 +14,11 @@
> >
> >  typedef void (*kunit_try_catch_func_t)(void *);
> >
> > -struct completion;
> >  struct kunit;
> >
> >  /**
> >   * struct kunit_try_catch - provides a generic way to run code which might fail.
> >   * @test: The test case that is currently being executed.
> > - * @try_completion: Completion that the control thread waits on while test runs.
> >   * @try_result: Contains any errno obtained while running test case.
> >   * @try: The function, the test case, to attempt to run.
> >   * @catch: The function called if @try bails out.
> > @@ -46,7 +44,6 @@ struct kunit;
> >  struct kunit_try_catch {
> >         /* private: internal use only. */
> >         struct kunit *test;
> > -       struct completion *try_completion;
> >         int try_result;
> >         kunit_try_catch_func_t try;
> >         kunit_try_catch_func_t catch;
> > diff --git a/lib/kunit/try-catch.c b/lib/kunit/try-catch.c
> > index cab8b24b5d5a..c6ee4db0b3bd 100644
> > --- a/lib/kunit/try-catch.c
> > +++ b/lib/kunit/try-catch.c
> > @@ -18,7 +18,7 @@
> >  void __noreturn kunit_try_catch_throw(struct kunit_try_catch *try_catch)
> >  {
> >         try_catch->try_result = -EFAULT;
> > -       kthread_complete_and_exit(try_catch->try_completion, -EFAULT);
> > +       kthread_exit(0);
> >  }
> >  EXPORT_SYMBOL_GPL(kunit_try_catch_throw);
> >
> > @@ -26,9 +26,12 @@ static int kunit_generic_run_threadfn_adapter(void *data)
> >  {
> >         struct kunit_try_catch *try_catch = data;
> >
> > +       try_catch->try_result = -EINTR;
> >         try_catch->try(try_catch->context);
> > +       if (try_catch->try_result == -EINTR)
> > +               try_catch->try_result = 0;
> >
> > -       kthread_complete_and_exit(try_catch->try_completion, 0);
> > +       return 0;
> 
> Really my only question is why we do not need to still do a
> kthread_exit(0) here? I realize we are not checking the thread's exit
> code but isn't it safer to call kthread_exit(). I'm new to kthread so
> I am not too sure.

This function is the body of the thread, and as we can see in the
signature it should return an integer that will then be passed to
kthread_exit() (by kthread-specific code).  It is then useless to
directly call kthread_exit() here, and it is cleaner to follow common
thread function signature.

> 
> >  }
> >
> >  static unsigned long kunit_test_timeout(void)
> > @@ -58,13 +61,11 @@ static unsigned long kunit_test_timeout(void)
> >
> >  void kunit_try_catch_run(struct kunit_try_catch *try_catch, void *context)
> >  {
> > -       DECLARE_COMPLETION_ONSTACK(try_completion);
> >         struct kunit *test = try_catch->test;
> >         struct task_struct *task_struct;
> >         int exit_code, time_remaining;
> >
> >         try_catch->context = context;
> > -       try_catch->try_completion = &try_completion;
> >         try_catch->try_result = 0;
> >         task_struct = kthread_create(kunit_generic_run_threadfn_adapter,
> >                                      try_catch, "kunit_try_catch_thread");
> > @@ -75,8 +76,7 @@ void kunit_try_catch_run(struct kunit_try_catch *try_catch, void *context)
> >         }
> >         get_task_struct(task_struct);
> >         wake_up_process(task_struct);
> > -
> > -       time_remaining = wait_for_completion_timeout(&try_completion,
> > +       time_remaining = wait_for_completion_timeout(task_struct->vfork_done,
> >                                                      kunit_test_timeout());
> >         if (time_remaining == 0) {
> >                 try_catch->try_result = -ETIMEDOUT;
> > @@ -92,7 +92,7 @@ void kunit_try_catch_run(struct kunit_try_catch *try_catch, void *context)
> >         if (exit_code == -EFAULT)
> >                 try_catch->try_result = 0;
> >         else if (exit_code == -EINTR)
> > -               kunit_err(test, "wake_up_process() was never called\n");
> > +               kunit_err(test, "try faulted\n");
> >         else if (exit_code == -ETIMEDOUT)
> >                 kunit_err(test, "try timed out\n");
> >         else if (exit_code)
> > --
> > 2.44.0
> >
> 

