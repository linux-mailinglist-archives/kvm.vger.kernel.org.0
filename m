Return-Path: <kvm+bounces-11662-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id ACDC38793FA
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 13:16:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 24423B245D4
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 12:16:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C7F57AE5F;
	Tue, 12 Mar 2024 12:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="qAo3RkH4"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-190c.mail.infomaniak.ch (smtp-190c.mail.infomaniak.ch [185.125.25.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F717A73F
	for <kvm@vger.kernel.org>; Tue, 12 Mar 2024 12:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.25.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710245766; cv=none; b=N/9M2/eX0lrYN/zmTGFsIDuWyi+QQcorN6dN84sLl8B0pcqt6cUCMOzhni0sxQZCWyJCMsuk4C1opWXxhJXuOSq9mDKyKdH+An6lJjih1lPvwoGDxcGFvaSlZCgl5Dqq9TH/K61SC+foQu6ci676lTfxpH9sbWeWfQN4VBM8/Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710245766; c=relaxed/simple;
	bh=toSAL6LOqqiAcHCFf2a7KtT/GkwF4PILGROHmUBWIwU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C0QSyTfYItHGxtebj/2ADCdkC8858Rd8gAmte6U4y+3bRHaTgzJH0gbRfv6umCxTA+UupkikchShbmnafT5iOHuhnSxRn3+V4+rE8YUKnBImhJfOW8zwxjz241Kopyf2cCJBBqkpSo0eZdS84WTtp416iJZiQvCXmmpfep9UwgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=qAo3RkH4; arc=none smtp.client-ip=185.125.25.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Received: from smtp-4-0001.mail.infomaniak.ch (unknown [10.7.10.108])
	by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4TvCKR2dbfzMq0WP;
	Tue, 12 Mar 2024 13:15:55 +0100 (CET)
Received: from unknown by smtp-4-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4TvCKQ0rNKzhRP;
	Tue, 12 Mar 2024 13:15:54 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
	s=20191114; t=1710245755;
	bh=toSAL6LOqqiAcHCFf2a7KtT/GkwF4PILGROHmUBWIwU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qAo3RkH4vnvOXezdBsHKVdull/R1EkYTke/fr8cEyftmemu+MgRBRD/0RcN+EPCaG
	 EUdqDuICfGoyovJLyRKBQ5wMhZjn3FSHKL9MM4TRX7SU5KCMHkdmzm5XJt5suSvpBx
	 8B6TWfN5IyjrCbk70Iong7MQSOB1Kknnk8bSCZSo=
Date: Tue, 12 Mar 2024 13:15:43 +0100
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: David Gow <davidgow@google.com>
Cc: Brendan Higgins <brendanhiggins@google.com>, 
	Kees Cook <keescook@chromium.org>, Rae Moar <rmoar@google.com>, 
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
Subject: Re: [PATCH v2 6/7] kunit: Print last test location on fault
Message-ID: <20240312.ku4TaiC9uosh@digikod.net>
References: <20240301194037.532117-1-mic@digikod.net>
 <20240301194037.532117-7-mic@digikod.net>
 <CABVgOSk_vea-LrPwJet6hQ4D3PBQOLVg32nZ_gE4c9kgGDEEnQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABVgOSk_vea-LrPwJet6hQ4D3PBQOLVg32nZ_gE4c9kgGDEEnQ@mail.gmail.com>
X-Infomaniak-Routing: alpha

On Tue, Mar 12, 2024 at 12:54:48PM +0800, David Gow wrote:
> On Sat, 2 Mar 2024 at 03:40, Mickaël Salaün <mic@digikod.net> wrote:
> >
> > This helps identify the location of test faults.
> >
> > Cc: Brendan Higgins <brendanhiggins@google.com>
> > Cc: David Gow <davidgow@google.com>
> > Cc: Rae Moar <rmoar@google.com>
> > Cc: Shuah Khan <skhan@linuxfoundation.org>
> > Reviewed-by: Kees Cook <keescook@chromium.org>
> > Signed-off-by: Mickaël Salaün <mic@digikod.net>
> > Link: https://lore.kernel.org/r/20240301194037.532117-7-mic@digikod.net
> > ---
> 
> I like the idea of this, but am a little bit worried about how
> confusing it might be, given that the location only updates on those
> particular macros.
> 
> Maybe the answer is to make the __KUNIT_SAVE_LOC() macro, or something
> equivalent, a supported API.
> 
> One possibility would be to have a KUNIT_MARKER() macro. If we really
> wanted to, we could expand it to take a string so we can have a more
> user-friendly KUNIT_MARKER(test, "parsing packet") description of
> where things went wrong. Another could be to extend this to use the
> code tagging framework[1], if that lands.
> 
> That being said, I think this is still an improvement without any of
> those features. I've left a few comments below. Let me know what you
> think.

This patch adds opportunistic markers to test code.  Because an uncaught
fault would be a bug, I think in practice nobody would use
KUNIT_MARKER() explicitly.  I found _KUNIT_SAVE_LOC() to be useful while
writing tests or debugging them.  With this patch, it is still possible
to call KUNIT_SUCCESS() if someone wants to add an explicit mark, and I
think it would make more sense.

> 
> Cheers,
> -- David
> 
> [1]: https://lwn.net/Articles/906660/
> >
> > Changes since v1:
> > * Added Kees's Reviewed-by.
> > ---
> >  include/kunit/test.h  | 24 +++++++++++++++++++++---
> >  lib/kunit/try-catch.c | 10 +++++++---
> >  2 files changed, 28 insertions(+), 6 deletions(-)
> >
> > diff --git a/include/kunit/test.h b/include/kunit/test.h
> > index fcb4a4940ace..f3aa66eb0087 100644
> > --- a/include/kunit/test.h
> > +++ b/include/kunit/test.h
> > @@ -301,6 +301,8 @@ struct kunit {
> >         struct list_head resources; /* Protected by lock. */
> >
> >         char status_comment[KUNIT_STATUS_COMMENT_SIZE];
> > +       /* Saves the last seen test. Useful to help with faults. */
> > +       struct kunit_loc last_seen;
> >  };
> >
> >  static inline void kunit_set_failure(struct kunit *test)
> > @@ -567,6 +569,15 @@ void __printf(2, 3) kunit_log_append(struct string_stream *log, const char *fmt,
> >  #define kunit_err(test, fmt, ...) \
> >         kunit_printk(KERN_ERR, test, fmt, ##__VA_ARGS__)
> >
> > +/*
> > + * Must be called at the beginning of each KUNIT_*_ASSERTION().
> > + * Cf. KUNIT_CURRENT_LOC.
> > + */
> > +#define _KUNIT_SAVE_LOC(test) do {                                            \
> > +       WRITE_ONCE(test->last_seen.file, __FILE__);                            \
> > +       WRITE_ONCE(test->last_seen.line, __LINE__);                            \
> > +} while (0)
> 
> Can we get rid of the leading '_', make this public, and document it?
> If we want to rename it to KUNIT_MARKER() or similar, that might work
> better, too.

We can do that but I'm not convinced it would be useful.

> 
> > +
> >  /**
> >   * KUNIT_SUCCEED() - A no-op expectation. Only exists for code clarity.
> >   * @test: The test context object.
> > @@ -575,7 +586,7 @@ void __printf(2, 3) kunit_log_append(struct string_stream *log, const char *fmt,
> >   * words, it does nothing and only exists for code clarity. See
> >   * KUNIT_EXPECT_TRUE() for more information.
> >   */
> > -#define KUNIT_SUCCEED(test) do {} while (0)
> > +#define KUNIT_SUCCEED(test) _KUNIT_SAVE_LOC(test)
> >
> >  void __noreturn __kunit_abort(struct kunit *test);
> >
> > @@ -601,14 +612,16 @@ void __kunit_do_failed_assertion(struct kunit *test,
> >  } while (0)
> >
> >
> > -#define KUNIT_FAIL_ASSERTION(test, assert_type, fmt, ...)                     \
> > +#define KUNIT_FAIL_ASSERTION(test, assert_type, fmt, ...) do {                \
> > +       _KUNIT_SAVE_LOC(test);                                                 \
> >         _KUNIT_FAILED(test,                                                    \
> >                       assert_type,                                             \
> >                       kunit_fail_assert,                                       \
> >                       kunit_fail_assert_format,                                \
> >                       {},                                                      \
> >                       fmt,                                                     \
> > -                     ##__VA_ARGS__)
> > +                     ##__VA_ARGS__);                                          \
> > +} while (0)
> >
> >  /**
> >   * KUNIT_FAIL() - Always causes a test to fail when evaluated.
> > @@ -637,6 +650,7 @@ void __kunit_do_failed_assertion(struct kunit *test,
> >                               fmt,                                             \
> >                               ...)                                             \
> >  do {                                                                          \
> > +       _KUNIT_SAVE_LOC(test);                                                 \
> >         if (likely(!!(condition_) == !!expected_true_))                        \
> >                 break;                                                         \
> >                                                                                \
> > @@ -698,6 +712,7 @@ do {                                                                               \
> >                 .right_text = #right,                                          \
> >         };                                                                     \
> >                                                                                \
> > +       _KUNIT_SAVE_LOC(test);                                                 \
> >         if (likely(__left op __right))                                         \
> >                 break;                                                         \
> >                                                                                \
> > @@ -758,6 +773,7 @@ do {                                                                               \
> >                 .right_text = #right,                                          \
> >         };                                                                     \
> >                                                                                \
> > +       _KUNIT_SAVE_LOC(test);                                                 \
> >         if (likely((__left) && (__right) && (strcmp(__left, __right) op 0)))   \
> >                 break;                                                         \
> >                                                                                \
> > @@ -791,6 +807,7 @@ do {                                                                               \
> >                 .right_text = #right,                                          \
> >         };                                                                     \
> >                                                                                \
> > +       _KUNIT_SAVE_LOC(test);                                                 \
> >         if (likely(__left && __right))                                         \
> >                 if (likely(memcmp(__left, __right, __size) op 0))              \
> >                         break;                                                 \
> > @@ -815,6 +832,7 @@ do {                                                                               \
> >  do {                                                                          \
> >         const typeof(ptr) __ptr = (ptr);                                       \
> >                                                                                \
> > +       _KUNIT_SAVE_LOC(test);                                                 \
> >         if (!IS_ERR_OR_NULL(__ptr))                                            \
> >                 break;                                                         \
> >                                                                                \
> > diff --git a/lib/kunit/try-catch.c b/lib/kunit/try-catch.c
> > index c6ee4db0b3bd..2ec21c6918f3 100644
> > --- a/lib/kunit/try-catch.c
> > +++ b/lib/kunit/try-catch.c
> > @@ -91,9 +91,13 @@ void kunit_try_catch_run(struct kunit_try_catch *try_catch, void *context)
> >
> >         if (exit_code == -EFAULT)
> >                 try_catch->try_result = 0;
> > -       else if (exit_code == -EINTR)
> > -               kunit_err(test, "try faulted\n");
> > -       else if (exit_code == -ETIMEDOUT)
> > +       else if (exit_code == -EINTR) {
> > +               if (test->last_seen.file)
> > +                       kunit_err(test, "try faulted after %s:%d\n",
> > +                                 test->last_seen.file, test->last_seen.line);
> 
> It's possibly a bit confusing to just say "after file:line",
> particularly if we then loop or call a function "higher up" in the
> file. Maybe something like "try faulted: last line seen %s:%d" is
> clearer.

OK

> 
> > +               else
> > +                       kunit_err(test, "try faulted before the first test\n");
> 
> I don't like using "test" here, as it introduces ambiguity between
> "kunit tests" and "assertions/expectations" if we call them both
> tests. Maybe just "try faulted" here, or "try faulted (no markers
> seen)" or similar?

I agree that "try faulted" would be enough.  I'm totally OK for you to
update this patch directly. Please let me know if you'd prefer me to
send another version with these fixes though.

Do you plan to merge this patches with the v6.9 merge window?

> 
> 
> > +       } else if (exit_code == -ETIMEDOUT)
> >                 kunit_err(test, "try timed out\n");
> >         else if (exit_code)
> >                 kunit_err(test, "Unknown error: %d\n", exit_code);
> > --
> > 2.44.0
> >



