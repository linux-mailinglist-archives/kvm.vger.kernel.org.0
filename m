Return-Path: <kvm+bounces-10676-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C991186E943
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 20:13:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AAC67B29373
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 19:05:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1C093B796;
	Fri,  1 Mar 2024 19:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b="uDEdkFzk"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-190b.mail.infomaniak.ch (smtp-190b.mail.infomaniak.ch [185.125.25.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFFE539AF4
	for <kvm@vger.kernel.org>; Fri,  1 Mar 2024 19:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.25.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709319837; cv=none; b=LN/VHzBKiIEz9rTcNLOzH/x9BIxYTr5vsPBllODLhJLYQVulvcj7kz+6yr4x3xfPPTOBneTmSt+qGbHl4Peh9l8CKqi/QHW656FKpnKlviMITGR9DGLVUoizcgc3zHpfQMor+T4cfDzWSC24E+9x5TCwKjOGt0FfTOax8SoMgjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709319837; c=relaxed/simple;
	bh=TUkx4ytfQJ4k3NJOll8lR8p71U6P4qHEfOZFZoOk6bs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fHWAPli/OKRpXz/H6Z/wyDUp13y+/rDTyCrGio8MIvWI7jew1yoTstyQ8m1pr2GgO7i2MOTB+Wv11Yg7ttp5WGHLu9xUC5PMBsbxt7knzWq3i5t1/JwGsbXeCGsalTUFPxs6CJQ8RqnunPpVqyvvAF+8+41/nnJlHytVnOXXMf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net; spf=pass smtp.mailfrom=digikod.net; dkim=pass (1024-bit key) header.d=digikod.net header.i=@digikod.net header.b=uDEdkFzk; arc=none smtp.client-ip=185.125.25.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=digikod.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=digikod.net
Received: from smtp-4-0000.mail.infomaniak.ch (smtp-4-0000.mail.infomaniak.ch [10.7.10.107])
	by smtp-4-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4Tmcv53N1JzRB2;
	Fri,  1 Mar 2024 20:03:45 +0100 (CET)
Received: from unknown by smtp-4-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4Tmcv21ybnzpR9;
	Fri,  1 Mar 2024 20:03:42 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
	s=20191114; t=1709319825;
	bh=TUkx4ytfQJ4k3NJOll8lR8p71U6P4qHEfOZFZoOk6bs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uDEdkFzkhYrYfiSHquIqPhmQ8zYSrXYpynf3JkvRJwjDeEGQ3k2PiNlJY0YXaSoaP
	 eNOrbNXHXo0OZpxqfD2IVickJW12oDsNYi+isIFCIr9dFgORhG90Lw3O1Vc1IU4yeZ
	 mRTQd2U4nwdz28yHoGwYHpc41F82nShL45JpjZew=
Date: Fri, 1 Mar 2024 20:03:32 +0100
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
Subject: Re: [PATCH v1 1/8] kunit: Run tests when the kernel is fully setup
Message-ID: <20240301.auba4oShaech@digikod.net>
References: <20240229170409.365386-1-mic@digikod.net>
 <20240229170409.365386-2-mic@digikod.net>
 <CABVgOSmRPJO2eAOSgFXC2WxnXyJ-zZ=MUd2dQMLqFcUsNARQJQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABVgOSmRPJO2eAOSgFXC2WxnXyJ-zZ=MUd2dQMLqFcUsNARQJQ@mail.gmail.com>
X-Infomaniak-Routing: alpha

On Fri, Mar 01, 2024 at 03:14:49PM +0800, David Gow wrote:
> On Fri, 1 Mar 2024 at 01:04, Mickaël Salaün <mic@digikod.net> wrote:
>  >
> > Run all the KUnit tests just before the first userspace code is
> > launched.  This makes it it possible to write new tests that check the
> > kernel in its final state i.e., with all async __init code called,
> > memory and RCU properly set up, and sysctl boot arguments evaluated.
> 
> KUnit has explicit support for running tests which call __init code
> (or are themselves marked __init), so I'm not keen to move _all_ tests
> here.

Makes sense.

> 
> That being said, I'm okay with running all of the other tests (ones
> not explicitly marked init) after __init.

I guess we should have to set of tests, the first one (marked with
__init) to run as it is now, and others set to run when the kernel is
fully setup.  I guess we should be able to identify the init sections
for KUnit tests and rely on that to create the two sets.  I'll work on
that in a separate patch series.

> >
> > The initial motivation is to run hardening tests (e.g. memory
> > protection, Heki's CR-pinning), which require such security protection
> > to be fully setup (e.g. memory marked as read-only).
> >
> > Because the suite set could refer to init data, initialize the suite set
> > with late_initcall(), before kunit_run_all_tests(), if KUnit is built-in
> > and enabled at boot time.  To make it more consistent and easier to
> > manage, whatever filters are used or not, always copy test suite entries
> > and free them after all tests are run.
> 
> The goal is to allow init data only for suites explicitly marked as
> such, so we should be able to split that along these lines.
> 
> And yeah, the filter code is pretty convoluted when it comes to when
> they're allocated, and it does do things like check how the suite set
> was allocated. So we do need to make any changes carefully.
> 
> As Kees suggested, I'd like to see any cleanup here as a separate patch.

Right, I'll send a v2 without this kernel init changes.

> 
> >
> > Because of the prepare_namespace() call, we need to have a valid root
> > filesystem.  To make it simple, let's use tmpfs with an empty root.
> > Teach kunit_kernel.py:LinuxSourceTreeOperations*() about the related
> > kernel boot argument, and add this filesystem to the kunit.py's kernel
> > build requirements.
> 
> I think this is a big enough change we'll need to handle it very
> carefully: there are a few places where the fact that KUnit doesn't
> require a root filesystem is documented, and possibly some other
> (non-kunit.py) runners which rely on this.
> 
> I don't think that's necessarily a blocker, but we'll definitely want
> to document it well, and make sure users are aware before this lands.

Indeed

> 
> >
> > Remove __init and __refdata markers from iov_iter, bitfield, checksum,
> > and the example KUnit tests.  Without this change, the kernel tries to
> > execute NX-protected pages (because the pages are deallocated).
> 
> We still want to support these, but we should make sure the suites are
> declared with kunit_init_test_suite().

OK

> 
> >
> > Tested with:
> > ./tools/testing/kunit/kunit.py run --alltests
> > ./tools/testing/kunit/kunit.py run --alltests --arch x86_64
> 
> FYI: This breaks arm64:
> ./tools/testing/kunit/kunit.py run --raw_output --arch arm64
> --cross_compile=aarch64-linux-gnu-
> 
> Unable to handle kernel paging request at virtual address ffffffff02016f88
> ...
> Call trace:
>  kfree+0x30/0x184
>  kunit_run_all_tests+0x88/0x154
>  kernel_init+0x6c/0x1e0
>  ret_from_fork+0x10/0x20
> Code: b25f7be1 aa0003f4 d34cfe73 8b131833 (f9400661)
> ---[ end trace 0000000000000000 ]---
> Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b

I guess it is realted to this patch, so I'll fix that with a future
series focus on these kernel init changes.

> 
> 
> >
> > Cc: Alan Maguire <alan.maguire@oracle.com>
> > Cc: Brendan Higgins <brendanhiggins@google.com>
> > Cc: David Gow <davidgow@google.com>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Luis Chamberlain <mcgrof@kernel.org>
> > Cc: Marco Pagani <marpagan@redhat.com>
> > Cc: Rae Moar <rmoar@google.com>
> > Cc: Shuah Khan <skhan@linuxfoundation.org>
> > Cc: Stephen Boyd <sboyd@kernel.org>
> > Signed-off-by: Mickaël Salaün <mic@digikod.net>
> > ---
> >  init/main.c                         |  4 +-
> >  lib/bitfield_kunit.c                |  8 +--
> >  lib/checksum_kunit.c                |  2 +-
> >  lib/kunit/executor.c                | 81 +++++++++++++++++++++--------
> >  lib/kunit/kunit-example-test.c      |  6 +--
> >  lib/kunit_iov_iter.c                | 52 +++++++++---------
> >  tools/testing/kunit/kunit_kernel.py |  6 ++-
> >  7 files changed, 96 insertions(+), 63 deletions(-)
> >
> > diff --git a/init/main.c b/init/main.c
> > index e24b0780fdff..b39d74727aad 100644
> > --- a/init/main.c
> > +++ b/init/main.c
> > @@ -1463,6 +1463,8 @@ static int __ref kernel_init(void *unused)
> >
> >         do_sysctl_args();
> >
> > +       kunit_run_all_tests();
> > +
> >         if (ramdisk_execute_command) {
> >                 ret = run_init_process(ramdisk_execute_command);
> >                 if (!ret)
> > @@ -1550,8 +1552,6 @@ static noinline void __init kernel_init_freeable(void)
> >
> >         do_basic_setup();
> >
> > -       kunit_run_all_tests();
> > -
> >         wait_for_initramfs();
> >         console_on_rootfs();
> >
> > diff --git a/lib/bitfield_kunit.c b/lib/bitfield_kunit.c
> > index 1473d8b4bf0f..71e9f2e96496 100644
> > --- a/lib/bitfield_kunit.c
> > +++ b/lib/bitfield_kunit.c
> > @@ -57,7 +57,7 @@
> >                 CHECK_ENC_GET_BE(tp, v, field, res);                    \
> >         } while (0)
> >
> > -static void __init test_bitfields_constants(struct kunit *context)
> > +static void test_bitfields_constants(struct kunit *context)
> >  {
> >         /*
> >          * NOTE
> > @@ -100,7 +100,7 @@ static void __init test_bitfields_constants(struct kunit *context)
> >                                 tp##_encode_bits(v, mask) != v << __ffs64(mask));\
> >         } while (0)
> >
> > -static void __init test_bitfields_variables(struct kunit *context)
> > +static void test_bitfields_variables(struct kunit *context)
> >  {
> >         CHECK(u8, 0x0f);
> >         CHECK(u8, 0xf0);
> > @@ -126,7 +126,7 @@ static void __init test_bitfields_variables(struct kunit *context)
> >  }
> >
> >  #ifdef TEST_BITFIELD_COMPILE
> > -static void __init test_bitfields_compile(struct kunit *context)
> > +static void test_bitfields_compile(struct kunit *context)
> >  {
> >         /* these should fail compilation */
> >         CHECK_ENC_GET(16, 16, 0x0f00, 0x1000);
> > @@ -137,7 +137,7 @@ static void __init test_bitfields_compile(struct kunit *context)
> >  }
> >  #endif
> >
> > -static struct kunit_case __refdata bitfields_test_cases[] = {
> > +static struct kunit_case bitfields_test_cases[] = {
> >         KUNIT_CASE(test_bitfields_constants),
> >         KUNIT_CASE(test_bitfields_variables),
> >         {}
> > diff --git a/lib/checksum_kunit.c b/lib/checksum_kunit.c
> > index 225bb7701460..41aaed3a4963 100644
> > --- a/lib/checksum_kunit.c
> > +++ b/lib/checksum_kunit.c
> > @@ -620,7 +620,7 @@ static void test_csum_ipv6_magic(struct kunit *test)
> >  #endif /* !CONFIG_NET */
> >  }
> >
> > -static struct kunit_case __refdata checksum_test_cases[] = {
> > +static struct kunit_case checksum_test_cases[] = {
> >         KUNIT_CASE(test_csum_fixed_random_inputs),
> >         KUNIT_CASE(test_csum_all_carry_inputs),
> >         KUNIT_CASE(test_csum_no_carry_inputs),
> > diff --git a/lib/kunit/executor.c b/lib/kunit/executor.c
> > index 689fff2b2b10..ff3e66ffa739 100644
> > --- a/lib/kunit/executor.c
> > +++ b/lib/kunit/executor.c
> > @@ -15,6 +15,8 @@ extern struct kunit_suite * const __kunit_suites_end[];
> >  extern struct kunit_suite * const __kunit_init_suites_start[];
> >  extern struct kunit_suite * const __kunit_init_suites_end[];
> >
> > +static struct kunit_suite_set final_suite_set = {};
> > +
> >  static char *action_param;
> >
> >  module_param_named(action, action_param, charp, 0400);
> > @@ -233,6 +235,21 @@ kunit_filter_suites(const struct kunit_suite_set *suite_set,
> >                 if (!filtered_suite)
> >                         continue;
> >
> > +               if (filtered_suite == suite_set->start[i]) {
> > +                       /*
> > +                        * To make memory allocation consistent whatever
> > +                        * filters are used or not, and to keep
> > +                        * kunit_free_suite_set() simple, always copy static
> > +                        * data.
> > +                        */
> > +                       filtered_suite = kmemdup(filtered_suite, sizeof(*filtered_suite),
> > +                                       GFP_KERNEL);
> > +                       if (!filtered_suite) {
> > +                               *err = -ENOMEM;
> > +                               goto free_parsed_filters;
> > +                       }
> > +               }
> > +
> >                 *copy++ = filtered_suite;
> >         }
> >         filtered.start = copy_start;
> > @@ -348,7 +365,7 @@ static void kunit_handle_shutdown(void)
> >
> >  }
> >
> > -int kunit_run_all_tests(void)
> > +static int kunit_init_suites(void)
> >  {
> >         struct kunit_suite_set suite_set = {NULL, NULL};
> >         struct kunit_suite_set filtered_suite_set = {NULL, NULL};
> > @@ -361,6 +378,9 @@ int kunit_run_all_tests(void)
> >         size_t init_num_suites = init_suite_set.end - init_suite_set.start;
> >         int err = 0;
> >
> > +       if (!kunit_enabled())
> > +               return 0;
> > +
> >         if (init_num_suites > 0) {
> >                 suite_set = kunit_merge_suite_sets(init_suite_set, normal_suite_set);
> >                 if (!suite_set.start)
> > @@ -368,41 +388,56 @@ int kunit_run_all_tests(void)
> >         } else
> >                 suite_set = normal_suite_set;
> >
> > -       if (!kunit_enabled()) {
> > -               pr_info("kunit: disabled\n");
> > +       filtered_suite_set = kunit_filter_suites(&suite_set, filter_glob_param,
> > +                       filter_param, filter_action_param, &err);
> > +
> > +       /* Free original suite set before using filtered suite set */
> > +       if (init_num_suites > 0)
> > +               kfree(suite_set.start);
> > +       suite_set = filtered_suite_set;
> > +
> > +       if (err) {
> > +               pr_err("kunit executor: error filtering suites: %d\n", err);
> >                 goto free_out;
> >         }
> >
> > -       if (filter_glob_param || filter_param) {
> > -               filtered_suite_set = kunit_filter_suites(&suite_set, filter_glob_param,
> > -                               filter_param, filter_action_param, &err);
> > +       final_suite_set = suite_set;
> > +       return 0;
> >
> > -               /* Free original suite set before using filtered suite set */
> > -               if (init_num_suites > 0)
> > -                       kfree(suite_set.start);
> > -               suite_set = filtered_suite_set;
> > +free_out:
> > +       kunit_free_suite_set(suite_set);
> >
> > -               if (err) {
> > -                       pr_err("kunit executor: error filtering suites: %d\n", err);
> > -                       goto free_out;
> > -               }
> > +out:
> > +       kunit_handle_shutdown();
> > +       return err;
> > +}
> > +
> > +late_initcall(kunit_init_suites);
> > +
> > +int kunit_run_all_tests(void)
> > +{
> > +       int err = 0;
> > +
> > +       if (!kunit_enabled()) {
> > +               pr_info("kunit: disabled\n");
> > +               goto out;
> >         }
> >
> > +       if (!final_suite_set.start)
> > +               goto out;
> > +
> >         if (!action_param)
> > -               kunit_exec_run_tests(&suite_set, true);
> > +               kunit_exec_run_tests(&final_suite_set, true);
> >         else if (strcmp(action_param, "list") == 0)
> > -               kunit_exec_list_tests(&suite_set, false);
> > +               kunit_exec_list_tests(&final_suite_set, false);
> >         else if (strcmp(action_param, "list_attr") == 0)
> > -               kunit_exec_list_tests(&suite_set, true);
> > +               kunit_exec_list_tests(&final_suite_set, true);
> >         else
> >                 pr_err("kunit executor: unknown action '%s'\n", action_param);
> >
> > -free_out:
> > -       if (filter_glob_param || filter_param)
> > -               kunit_free_suite_set(suite_set);
> > -       else if (init_num_suites > 0)
> > -               /* Don't use kunit_free_suite_set because suites aren't individually allocated */
> > -               kfree(suite_set.start);
> > +       kunit_free_suite_set(final_suite_set);
> > +       final_suite_set.start = NULL;
> > +       final_suite_set.end = NULL;
> >
> >  out:
> >         kunit_handle_shutdown();
> > diff --git a/lib/kunit/kunit-example-test.c b/lib/kunit/kunit-example-test.c
> > index 798924f7cc86..248949eb3b16 100644
> > --- a/lib/kunit/kunit-example-test.c
> > +++ b/lib/kunit/kunit-example-test.c
> > @@ -337,7 +337,7 @@ static struct kunit_suite example_test_suite = {
> >   */
> >  kunit_test_suites(&example_test_suite);
> >
> > -static int __init init_add(int x, int y)
> > +static int init_add(int x, int y)
> 
> The whole point of this function (and the example_init_test) is that
> they're marked __init, as proof we can test code which is in the init
> section.
> 
> So, either we leave this alone, or we remove it entirely. There's no
> point just removing __init.

Right

> 
> >  {
> >         return (x + y);
> >  }
> > @@ -345,7 +345,7 @@ static int __init init_add(int x, int y)
> >  /*
> >   * This test should always pass. Can be used to test init suites.
> >   */
> > -static void __init example_init_test(struct kunit *test)
> > +static void example_init_test(struct kunit *test)
> 
> As above.
> 
> >  {
> >         KUNIT_EXPECT_EQ(test, init_add(1, 1), 2);
> >  }
> > @@ -354,7 +354,7 @@ static void __init example_init_test(struct kunit *test)
> >   * The kunit_case struct cannot be marked as __initdata as this will be
> >   * used in debugfs to retrieve results after test has run
> >   */
> > -static struct kunit_case __refdata example_init_test_cases[] = {
> > +static struct kunit_case example_init_test_cases[] = {
> >         KUNIT_CASE(example_init_test),
> >         {}
> >  };
> 
> As above.
> 
> > diff --git a/lib/kunit_iov_iter.c b/lib/kunit_iov_iter.c
> > index 859b67c4d697..a77991a9bffb 100644
> > --- a/lib/kunit_iov_iter.c
> > +++ b/lib/kunit_iov_iter.c
> > @@ -44,9 +44,8 @@ static void iov_kunit_unmap(void *data)
> >         vunmap(data);
> >  }
> >
> > -static void *__init iov_kunit_create_buffer(struct kunit *test,
> > -                                           struct page ***ppages,
> > -                                           size_t npages)
> > +static void *iov_kunit_create_buffer(struct kunit *test, struct page ***ppages,
> > +                                    size_t npages)
> >  {
> >         struct page **pages;
> >         unsigned long got;
> > @@ -69,11 +68,10 @@ static void *__init iov_kunit_create_buffer(struct kunit *test,
> >         return buffer;
> >  }
> >
> > -static void __init iov_kunit_load_kvec(struct kunit *test,
> > -                                      struct iov_iter *iter, int dir,
> > -                                      struct kvec *kvec, unsigned int kvmax,
> > -                                      void *buffer, size_t bufsize,
> > -                                      const struct kvec_test_range *pr)
> > +static void iov_kunit_load_kvec(struct kunit *test, struct iov_iter *iter,
> > +                               int dir, struct kvec *kvec, unsigned int kvmax,
> > +                               void *buffer, size_t bufsize,
> > +                               const struct kvec_test_range *pr)
> >  {
> >         size_t size = 0;
> >         int i;
> > @@ -95,7 +93,7 @@ static void __init iov_kunit_load_kvec(struct kunit *test,
> >  /*
> >   * Test copying to a ITER_KVEC-type iterator.
> >   */
> > -static void __init iov_kunit_copy_to_kvec(struct kunit *test)
> > +static void iov_kunit_copy_to_kvec(struct kunit *test)
> >  {
> >         const struct kvec_test_range *pr;
> >         struct iov_iter iter;
> > @@ -145,7 +143,7 @@ static void __init iov_kunit_copy_to_kvec(struct kunit *test)
> >  /*
> >   * Test copying from a ITER_KVEC-type iterator.
> >   */
> > -static void __init iov_kunit_copy_from_kvec(struct kunit *test)
> > +static void iov_kunit_copy_from_kvec(struct kunit *test)
> >  {
> >         const struct kvec_test_range *pr;
> >         struct iov_iter iter;
> > @@ -213,12 +211,11 @@ static const struct bvec_test_range bvec_test_ranges[] = {
> >         { -1, -1, -1 }
> >  };
> >
> > -static void __init iov_kunit_load_bvec(struct kunit *test,
> > -                                      struct iov_iter *iter, int dir,
> > -                                      struct bio_vec *bvec, unsigned int bvmax,
> > -                                      struct page **pages, size_t npages,
> > -                                      size_t bufsize,
> > -                                      const struct bvec_test_range *pr)
> > +static void iov_kunit_load_bvec(struct kunit *test, struct iov_iter *iter,
> > +                               int dir, struct bio_vec *bvec,
> > +                               unsigned int bvmax, struct page **pages,
> > +                               size_t npages, size_t bufsize,
> > +                               const struct bvec_test_range *pr)
> >  {
> >         struct page *can_merge = NULL, *page;
> >         size_t size = 0;
> > @@ -254,7 +251,7 @@ static void __init iov_kunit_load_bvec(struct kunit *test,
> >  /*
> >   * Test copying to a ITER_BVEC-type iterator.
> >   */
> > -static void __init iov_kunit_copy_to_bvec(struct kunit *test)
> > +static void iov_kunit_copy_to_bvec(struct kunit *test)
> >  {
> >         const struct bvec_test_range *pr;
> >         struct iov_iter iter;
> > @@ -308,7 +305,7 @@ static void __init iov_kunit_copy_to_bvec(struct kunit *test)
> >  /*
> >   * Test copying from a ITER_BVEC-type iterator.
> >   */
> > -static void __init iov_kunit_copy_from_bvec(struct kunit *test)
> > +static void iov_kunit_copy_from_bvec(struct kunit *test)
> >  {
> >         const struct bvec_test_range *pr;
> >         struct iov_iter iter;
> > @@ -370,10 +367,9 @@ static void iov_kunit_destroy_xarray(void *data)
> >         kfree(xarray);
> >  }
> >
> > -static void __init iov_kunit_load_xarray(struct kunit *test,
> > -                                        struct iov_iter *iter, int dir,
> > -                                        struct xarray *xarray,
> > -                                        struct page **pages, size_t npages)
> > +static void iov_kunit_load_xarray(struct kunit *test, struct iov_iter *iter,
> > +                                 int dir, struct xarray *xarray,
> > +                                 struct page **pages, size_t npages)
> >  {
> >         size_t size = 0;
> >         int i;
> > @@ -401,7 +397,7 @@ static struct xarray *iov_kunit_create_xarray(struct kunit *test)
> >  /*
> >   * Test copying to a ITER_XARRAY-type iterator.
> >   */
> > -static void __init iov_kunit_copy_to_xarray(struct kunit *test)
> > +static void iov_kunit_copy_to_xarray(struct kunit *test)
> >  {
> >         const struct kvec_test_range *pr;
> >         struct iov_iter iter;
> > @@ -459,7 +455,7 @@ static void __init iov_kunit_copy_to_xarray(struct kunit *test)
> >  /*
> >   * Test copying from a ITER_XARRAY-type iterator.
> >   */
> > -static void __init iov_kunit_copy_from_xarray(struct kunit *test)
> > +static void iov_kunit_copy_from_xarray(struct kunit *test)
> >  {
> >         const struct kvec_test_range *pr;
> >         struct iov_iter iter;
> > @@ -522,7 +518,7 @@ static void __init iov_kunit_copy_from_xarray(struct kunit *test)
> >  /*
> >   * Test the extraction of ITER_KVEC-type iterators.
> >   */
> > -static void __init iov_kunit_extract_pages_kvec(struct kunit *test)
> > +static void iov_kunit_extract_pages_kvec(struct kunit *test)
> >  {
> >         const struct kvec_test_range *pr;
> >         struct iov_iter iter;
> > @@ -602,7 +598,7 @@ static void __init iov_kunit_extract_pages_kvec(struct kunit *test)
> >  /*
> >   * Test the extraction of ITER_BVEC-type iterators.
> >   */
> > -static void __init iov_kunit_extract_pages_bvec(struct kunit *test)
> > +static void iov_kunit_extract_pages_bvec(struct kunit *test)
> >  {
> >         const struct bvec_test_range *pr;
> >         struct iov_iter iter;
> > @@ -680,7 +676,7 @@ static void __init iov_kunit_extract_pages_bvec(struct kunit *test)
> >  /*
> >   * Test the extraction of ITER_XARRAY-type iterators.
> >   */
> > -static void __init iov_kunit_extract_pages_xarray(struct kunit *test)
> > +static void iov_kunit_extract_pages_xarray(struct kunit *test)
> >  {
> >         const struct kvec_test_range *pr;
> >         struct iov_iter iter;
> > @@ -756,7 +752,7 @@ static void __init iov_kunit_extract_pages_xarray(struct kunit *test)
> >         KUNIT_SUCCEED();
> >  }
> >
> > -static struct kunit_case __refdata iov_kunit_cases[] = {
> > +static struct kunit_case iov_kunit_cases[] = {
> >         KUNIT_CASE(iov_kunit_copy_to_kvec),
> >         KUNIT_CASE(iov_kunit_copy_from_kvec),
> >         KUNIT_CASE(iov_kunit_copy_to_bvec),
> > diff --git a/tools/testing/kunit/kunit_kernel.py b/tools/testing/kunit/kunit_kernel.py
> > index 0b6488efed47..e1980ea58118 100644
> > --- a/tools/testing/kunit/kunit_kernel.py
> > +++ b/tools/testing/kunit/kunit_kernel.py
> > @@ -104,12 +104,13 @@ class LinuxSourceTreeOperationsQemu(LinuxSourceTreeOperations):
> >                 self._kconfig = qemu_arch_params.kconfig
> >                 self._qemu_arch = qemu_arch_params.qemu_arch
> >                 self._kernel_path = qemu_arch_params.kernel_path
> > -               self._kernel_command_line = qemu_arch_params.kernel_command_line + ' kunit_shutdown=reboot'
> > +               self._kernel_command_line = qemu_arch_params.kernel_command_line + ' kunit_shutdown=reboot rootfstype=tmpfs'
> >                 self._extra_qemu_params = qemu_arch_params.extra_qemu_params
> >                 self._serial = qemu_arch_params.serial
> >
> >         def make_arch_config(self, base_kunitconfig: kunit_config.Kconfig) -> kunit_config.Kconfig:
> >                 kconfig = kunit_config.parse_from_string(self._kconfig)
> > +               kconfig.add_entry('TMPFS', 'y')
> 
> Can we add these to config files rather than add them here?

I initially tried that but this makes this change more complex because
of the way UML and non-UML+arch configs are managed.

> 
> 
> >                 kconfig.merge_in_entries(base_kunitconfig)
> >                 return kconfig
> >
> > @@ -139,13 +140,14 @@ class LinuxSourceTreeOperationsUml(LinuxSourceTreeOperations):
> >
> >         def make_arch_config(self, base_kunitconfig: kunit_config.Kconfig) -> kunit_config.Kconfig:
> >                 kconfig = kunit_config.parse_file(UML_KCONFIG_PATH)
> > +               kconfig.add_entry('TMPFS', 'y')
> >                 kconfig.merge_in_entries(base_kunitconfig)
> >                 return kconfig
> >
> >         def start(self, params: List[str], build_dir: str) -> subprocess.Popen:
> >                 """Runs the Linux UML binary. Must be named 'linux'."""
> >                 linux_bin = os.path.join(build_dir, 'linux')
> > -               params.extend(['mem=1G', 'console=tty', 'kunit_shutdown=halt'])
> > +               params.extend(['mem=1G', 'console=tty', 'kunit_shutdown=halt', 'rootfstype=tmpfs'])
> >                 return subprocess.Popen([linux_bin] + params,
> >                                            stdin=subprocess.PIPE,
> >                                            stdout=subprocess.PIPE,
> > --
> > 2.44.0
> >



