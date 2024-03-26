Return-Path: <kvm+bounces-12673-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76D0F88BD38
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 10:04:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9AEDF1C36B1F
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 09:04:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 230D05D497;
	Tue, 26 Mar 2024 09:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="IZBmrADh"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-190d.mail.infomaniak.ch (smtp-190d.mail.infomaniak.ch [185.125.25.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4DA6524A5
	for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 09:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.25.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711443782; cv=none; b=KHoN2S8GphgfYTzaBMvzodxAu3cHqqmfFgB4cbdbIDhBDZImOHwCt/+Q9MQC58ZaHfCXoCo6B6dh58FNan3MU08W86EbyC3NiNu3UVH+2iznJSnq9VK2lZQmX4/BV1eYylU8srG+XSEyv1lB6E9vcsBchoUpHy/dhTm1WZTrT60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711443782; c=relaxed/simple;
	bh=aG1FdaTbcKd3XGgGWnmx/xvaQsHHK4Rz/c5f2D3Q9m0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l0w8PXyEqEWsDjppqrh4PytRam8o48Q1AbSRciy6Q+H/qvMw8dlLUZ9NRMQnA+IKD5KDI6SHymbKIqQGPpWxGEEwD/rSRAA5xjOnonl/PM+waO6Kwq1ELC+MSoxIkNYKHWoCjGovbE5SC3cAge175rTqL/WH36aYdIPtM7nXtrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=IZBmrADh; arc=none smtp.client-ip=185.125.25.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Received: from smtp-3-0001.mail.infomaniak.ch (smtp-3-0001.mail.infomaniak.ch [10.4.36.108])
	by smtp-4-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4V3kNF53NkzZBV;
	Tue, 26 Mar 2024 10:02:53 +0100 (CET)
Received: from unknown by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4V3kND05yKzMppKc;
	Tue, 26 Mar 2024 10:02:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
	s=20191114; t=1711443773;
	bh=aG1FdaTbcKd3XGgGWnmx/xvaQsHHK4Rz/c5f2D3Q9m0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IZBmrADhOaPt+S5+Ai5jbfmQE6NDEfhlQ7oPI5KvdxY6OFxpZqdyc/bT9FtkXBfR6
	 aF4p1CvP1HyDpI7noNPncdLGg4YV1hCzZZ9kkE16vyFVLnQKlUCxqBlsP+0Vj3fgyL
	 h1vzPtWDDxEvqYWWo+GxoH+jFFPSjPNKofKIbZeA=
Date: Tue, 26 Mar 2024 10:02:51 +0100
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: David Gow <davidgow@google.com>
Cc: Brendan Higgins <brendanhiggins@google.com>, 
	Rae Moar <rmoar@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Alan Maguire <alan.maguire@oracle.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H . Peter Anvin" <hpa@zytor.com>, 
	Ingo Molnar <mingo@redhat.com>, James Morris <jamorris@linux.microsoft.com>, 
	Kees Cook <keescook@chromium.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>, Marco Pagani <marpagan@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Stephen Boyd <sboyd@kernel.org>, Thara Gopinath <tgopinath@microsoft.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Wanpeng Li <wanpengli@tencent.com>, Zahra Tarkhani <ztarkhani@microsoft.com>, kvm@vger.kernel.org, 
	linux-hardening@vger.kernel.org, linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-um@lists.infradead.org, x86@kernel.org
Subject: Re: [PATCH v3 4/7] kunit: Handle test faults
Message-ID: <20240326.ieB8Phit1Ob8@digikod.net>
References: <20240319104857.70783-1-mic@digikod.net>
 <20240319104857.70783-5-mic@digikod.net>
 <CABVgOSksVq5_AeObEBZFAezZpiQ41C7ZHWEtRBR_1d2UQQYXbw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABVgOSksVq5_AeObEBZFAezZpiQ41C7ZHWEtRBR_1d2UQQYXbw@mail.gmail.com>
X-Infomaniak-Routing: alpha

On Sat, Mar 23, 2024 at 03:37:21PM +0800, David Gow wrote:
> On Tue, 19 Mar 2024 at 18:49, Mickaël Salaün <mic@digikod.net> wrote:
> >
> > Previously, when a kernel test thread crashed (e.g. NULL pointer
> > dereference, general protection fault), the KUnit test hanged for 30
> > seconds and exited with a timeout error.
> >
> > Fix this issue by waiting on task_struct->vfork_done instead of the
> > custom kunit_try_catch.try_completion, and track the execution state by
> > initially setting try_result with -EINTR and only setting it to 0 if
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
> > Cc: Shuah Khan <skhan@linuxfoundation.org>
> > Reviewed-by: Kees Cook <keescook@chromium.org>
> > Reviewed-by: David Gow <davidgow@google.com>
> > Tested-by: Rae Moar <rmoar@google.com>
> > Signed-off-by: Mickaël Salaün <mic@digikod.net>
> > Link: https://lore.kernel.org/r/20240319104857.70783-5-mic@digikod.net
> > ---
> >
> > Changes since v2:
> > * s/-EFAULT/-EINTR/ in commit message as spotted by Rae.
> > * Add a comment explaining vfork_done as suggested by David.
> > * Add David's Reviewed-by.
> > * Add Rae's Tested-by.
> >
> > Changes since v1:
> > * Add Kees's Reviewed-by.
> > ---
> >  include/kunit/try-catch.h |  3 ---
> >  lib/kunit/try-catch.c     | 19 ++++++++++++-------
> >  2 files changed, 12 insertions(+), 10 deletions(-)
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
> > index cab8b24b5d5a..7a3910dd78a6 100644
> > --- a/lib/kunit/try-catch.c
> > +++ b/lib/kunit/try-catch.c
> > @@ -18,7 +18,7 @@
> >  void __noreturn kunit_try_catch_throw(struct kunit_try_catch *try_catch)
> >  {
> >         try_catch->try_result = -EFAULT;
> > -       kthread_complete_and_exit(try_catch->try_completion, -EFAULT);
> > +       kthread_exit(0);
> 
> It turns out kthread_exit() is not exported, so this doesn't work if
> KUnit is built as a module.
> 
> I think the options we have are:
> - Add EXPORT_SYMBOL(kthread_exit).

I'll go this way. This should not be an issue because
kthread_complete_and_exit() can already (only) call kthread_exit() if
the completion is NULL, but directly calling kthread_exit() is cleaner.

> - Keep using out own completion, and kthread_complete_and_exit()
> - try_get_module() before spawning the thread, and use
> module_put_and_kthread_exit().
> 
> I think all of these would be okay, but I could've missed something.
> 
> -- David

