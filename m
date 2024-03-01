Return-Path: <kvm+bounces-10589-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DE4F86DBEA
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 08:15:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8FEAF1F2676C
	for <lists+kvm@lfdr.de>; Fri,  1 Mar 2024 07:15:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8AE5C69953;
	Fri,  1 Mar 2024 07:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4vCe/dfa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C65169313
	for <kvm@vger.kernel.org>; Fri,  1 Mar 2024 07:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709277307; cv=none; b=EIudqSnEdI732OhogzpUtfqgEAvE7b8BCo/PNbtbhqem5uQglST1JHmQTNOE4ws+Kxe1BFLS0/yRxn21oJA/dquw3rhd/njN/xNmdh6Wu5+xO6UK5SKEG7SKTyUhkjB99DzcGv6jAb68LcpWKkNy+WzHsWQOb8bQobYLohlQ3v0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709277307; c=relaxed/simple;
	bh=BALXzIrHxZaFQZLm7nXmuuP49LyteFwRkDMyy43E0zU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ocw8vv0OFNf/9WJ0+4UKOCT3pPbyXaGbq7YoIyQzuwVXVDIlEKPMaZHjl4oY7ymnvIBd2e58UAsPmSGPHIiFaS4LJXRladdmTa0Oe552rtXg0r9lyaTtY3n2N3l/SQAOFLEAkgrW+y29i0Q7Sz6XGTDtOXuf5xVNR8UqROvIeCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4vCe/dfa; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-565223fd7d9so3662a12.1
        for <kvm@vger.kernel.org>; Thu, 29 Feb 2024 23:15:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709277303; x=1709882103; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=K7cJZN1OvXg9xUpvvCB1MHuMEdnkUgC9fi1qgyK/kuc=;
        b=4vCe/dfaHNkKdTguviyMo+QjvrZu0MaNmNFZEXDtPfW4ZQBTPUNoaKCO/vKbVIYARF
         igLnDt5FBl8A56wNys9pmgNSO67C8MowXArSe8GJDN3A0B5DLSHsvOiSbaXNbgtU+gZP
         U3exseioiTXHvk8pIUJMBfMcki/an0KVgCiyIcI3EtQV67cK+p+Zjh4iDTYrh0KpVMA9
         fa5e2CqAR57esnUClOfMalF1yYXanFybM1S84XhFTxVinCbl88e99h73c3D1Dqn+HC4B
         MR5WRg5o0W56PQLfOjESCKqGeoX9/rS+3/UGDuEDqGygeWQtUtpiXM00stDN6gBxNqEQ
         E83Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709277303; x=1709882103;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K7cJZN1OvXg9xUpvvCB1MHuMEdnkUgC9fi1qgyK/kuc=;
        b=AUxPS3iWCNZNi5fIhB4qvas8H6XBr/SpGRfVaKUrXkb7QKUVlXd2abvVgRtvQL4ToZ
         /HkHrJ787IcfZgTgpDXETrbV8XJL3A2sGv36nQIwkPBW0pZ5bYupBHDYr8m+5lKh/n6M
         BIJZsxWxekZzucAYWgVsvKKtOw6ijd/S2miaTH8Ad6IHcFMhxAsOaEb+3enimg/4fW3e
         YuzjNmzSODhpfdO8jNOlPj4f9mQjR5VU18WhaNnGEM+rAlS8R5o5vJ6TQeZsvumbxBzj
         zn5UD0PIg5uGxJCc3Ik1W0PQERNC/k2rNSAVRQPsEfoZFkxyNpne2Hn17SEHKOZAgiAQ
         MYrg==
X-Forwarded-Encrypted: i=1; AJvYcCVueCI9p+ZR7w5z5Is+Pwz0q/p+RGjUmk6lc9qW0ftGG1cqkdrSZ9/a44PGa9+v5tV56h2EJzQ/9Ufed40MYkcLYQvz
X-Gm-Message-State: AOJu0YyB5Ql8xSNBEB9LjLGDTDb2AL7q29dN1Vg/q4A95LU36Nwk0gvp
	IGVGZ1iy8HyQCrRvzmoY6/yOXw5Kj15RmTxbcaZThfAda6rYsUfcMSApqhbcbBPnz/Tk54RkpIa
	XHCs1kEpMJOX6geKBGKl08Du/EohF0Smocv6Y
X-Google-Smtp-Source: AGHT+IHOG4rPLpAEc0vIpHY37ANfxO6LPEz9QKFzdS0SX0EdjoGz8r3Of/tsLF0emViQPuPOFlb5hjqDNo1tCjOQXPU=
X-Received: by 2002:a05:6402:350e:b0:563:f48a:aa03 with SMTP id
 b14-20020a056402350e00b00563f48aaa03mr111499edd.2.1709277303243; Thu, 29 Feb
 2024 23:15:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240229170409.365386-1-mic@digikod.net> <20240229170409.365386-2-mic@digikod.net>
In-Reply-To: <20240229170409.365386-2-mic@digikod.net>
From: David Gow <davidgow@google.com>
Date: Fri, 1 Mar 2024 15:14:49 +0800
Message-ID: <CABVgOSmRPJO2eAOSgFXC2WxnXyJ-zZ=MUd2dQMLqFcUsNARQJQ@mail.gmail.com>
Subject: Re: [PATCH v1 1/8] kunit: Run tests when the kernel is fully setup
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: Brendan Higgins <brendanhiggins@google.com>, Kees Cook <keescook@chromium.org>, 
	Rae Moar <rmoar@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
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
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
	boundary="000000000000839cca06129422da"

--000000000000839cca06129422da
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 1 Mar 2024 at 01:04, Micka=C3=ABl Sala=C3=BCn <mic@digikod.net> wro=
te:
 >
> Run all the KUnit tests just before the first userspace code is
> launched.  This makes it it possible to write new tests that check the
> kernel in its final state i.e., with all async __init code called,
> memory and RCU properly set up, and sysctl boot arguments evaluated.

KUnit has explicit support for running tests which call __init code
(or are themselves marked __init), so I'm not keen to move _all_ tests
here.

That being said, I'm okay with running all of the other tests (ones
not explicitly marked init) after __init.
>
> The initial motivation is to run hardening tests (e.g. memory
> protection, Heki's CR-pinning), which require such security protection
> to be fully setup (e.g. memory marked as read-only).
>
> Because the suite set could refer to init data, initialize the suite set
> with late_initcall(), before kunit_run_all_tests(), if KUnit is built-in
> and enabled at boot time.  To make it more consistent and easier to
> manage, whatever filters are used or not, always copy test suite entries
> and free them after all tests are run.

The goal is to allow init data only for suites explicitly marked as
such, so we should be able to split that along these lines.

And yeah, the filter code is pretty convoluted when it comes to when
they're allocated, and it does do things like check how the suite set
was allocated. So we do need to make any changes carefully.

As Kees suggested, I'd like to see any cleanup here as a separate patch.

>
> Because of the prepare_namespace() call, we need to have a valid root
> filesystem.  To make it simple, let's use tmpfs with an empty root.
> Teach kunit_kernel.py:LinuxSourceTreeOperations*() about the related
> kernel boot argument, and add this filesystem to the kunit.py's kernel
> build requirements.

I think this is a big enough change we'll need to handle it very
carefully: there are a few places where the fact that KUnit doesn't
require a root filesystem is documented, and possibly some other
(non-kunit.py) runners which rely on this.

I don't think that's necessarily a blocker, but we'll definitely want
to document it well, and make sure users are aware before this lands.

>
> Remove __init and __refdata markers from iov_iter, bitfield, checksum,
> and the example KUnit tests.  Without this change, the kernel tries to
> execute NX-protected pages (because the pages are deallocated).

We still want to support these, but we should make sure the suites are
declared with kunit_init_test_suite().

>
> Tested with:
> ./tools/testing/kunit/kunit.py run --alltests
> ./tools/testing/kunit/kunit.py run --alltests --arch x86_64

FYI: This breaks arm64:
./tools/testing/kunit/kunit.py run --raw_output --arch arm64
--cross_compile=3Daarch64-linux-gnu-

Unable to handle kernel paging request at virtual address ffffffff02016f88
...
Call trace:
 kfree+0x30/0x184
 kunit_run_all_tests+0x88/0x154
 kernel_init+0x6c/0x1e0
 ret_from_fork+0x10/0x20
Code: b25f7be1 aa0003f4 d34cfe73 8b131833 (f9400661)
---[ end trace 0000000000000000 ]---
Kernel panic - not syncing: Attempted to kill init! exitcode=3D0x0000000b


>
> Cc: Alan Maguire <alan.maguire@oracle.com>
> Cc: Brendan Higgins <brendanhiggins@google.com>
> Cc: David Gow <davidgow@google.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Luis Chamberlain <mcgrof@kernel.org>
> Cc: Marco Pagani <marpagan@redhat.com>
> Cc: Rae Moar <rmoar@google.com>
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Cc: Stephen Boyd <sboyd@kernel.org>
> Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
> ---
>  init/main.c                         |  4 +-
>  lib/bitfield_kunit.c                |  8 +--
>  lib/checksum_kunit.c                |  2 +-
>  lib/kunit/executor.c                | 81 +++++++++++++++++++++--------
>  lib/kunit/kunit-example-test.c      |  6 +--
>  lib/kunit_iov_iter.c                | 52 +++++++++---------
>  tools/testing/kunit/kunit_kernel.py |  6 ++-
>  7 files changed, 96 insertions(+), 63 deletions(-)
>
> diff --git a/init/main.c b/init/main.c
> index e24b0780fdff..b39d74727aad 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -1463,6 +1463,8 @@ static int __ref kernel_init(void *unused)
>
>         do_sysctl_args();
>
> +       kunit_run_all_tests();
> +
>         if (ramdisk_execute_command) {
>                 ret =3D run_init_process(ramdisk_execute_command);
>                 if (!ret)
> @@ -1550,8 +1552,6 @@ static noinline void __init kernel_init_freeable(vo=
id)
>
>         do_basic_setup();
>
> -       kunit_run_all_tests();
> -
>         wait_for_initramfs();
>         console_on_rootfs();
>
> diff --git a/lib/bitfield_kunit.c b/lib/bitfield_kunit.c
> index 1473d8b4bf0f..71e9f2e96496 100644
> --- a/lib/bitfield_kunit.c
> +++ b/lib/bitfield_kunit.c
> @@ -57,7 +57,7 @@
>                 CHECK_ENC_GET_BE(tp, v, field, res);                    \
>         } while (0)
>
> -static void __init test_bitfields_constants(struct kunit *context)
> +static void test_bitfields_constants(struct kunit *context)
>  {
>         /*
>          * NOTE
> @@ -100,7 +100,7 @@ static void __init test_bitfields_constants(struct ku=
nit *context)
>                                 tp##_encode_bits(v, mask) !=3D v << __ffs=
64(mask));\
>         } while (0)
>
> -static void __init test_bitfields_variables(struct kunit *context)
> +static void test_bitfields_variables(struct kunit *context)
>  {
>         CHECK(u8, 0x0f);
>         CHECK(u8, 0xf0);
> @@ -126,7 +126,7 @@ static void __init test_bitfields_variables(struct ku=
nit *context)
>  }
>
>  #ifdef TEST_BITFIELD_COMPILE
> -static void __init test_bitfields_compile(struct kunit *context)
> +static void test_bitfields_compile(struct kunit *context)
>  {
>         /* these should fail compilation */
>         CHECK_ENC_GET(16, 16, 0x0f00, 0x1000);
> @@ -137,7 +137,7 @@ static void __init test_bitfields_compile(struct kuni=
t *context)
>  }
>  #endif
>
> -static struct kunit_case __refdata bitfields_test_cases[] =3D {
> +static struct kunit_case bitfields_test_cases[] =3D {
>         KUNIT_CASE(test_bitfields_constants),
>         KUNIT_CASE(test_bitfields_variables),
>         {}
> diff --git a/lib/checksum_kunit.c b/lib/checksum_kunit.c
> index 225bb7701460..41aaed3a4963 100644
> --- a/lib/checksum_kunit.c
> +++ b/lib/checksum_kunit.c
> @@ -620,7 +620,7 @@ static void test_csum_ipv6_magic(struct kunit *test)
>  #endif /* !CONFIG_NET */
>  }
>
> -static struct kunit_case __refdata checksum_test_cases[] =3D {
> +static struct kunit_case checksum_test_cases[] =3D {
>         KUNIT_CASE(test_csum_fixed_random_inputs),
>         KUNIT_CASE(test_csum_all_carry_inputs),
>         KUNIT_CASE(test_csum_no_carry_inputs),
> diff --git a/lib/kunit/executor.c b/lib/kunit/executor.c
> index 689fff2b2b10..ff3e66ffa739 100644
> --- a/lib/kunit/executor.c
> +++ b/lib/kunit/executor.c
> @@ -15,6 +15,8 @@ extern struct kunit_suite * const __kunit_suites_end[];
>  extern struct kunit_suite * const __kunit_init_suites_start[];
>  extern struct kunit_suite * const __kunit_init_suites_end[];
>
> +static struct kunit_suite_set final_suite_set =3D {};
> +
>  static char *action_param;
>
>  module_param_named(action, action_param, charp, 0400);
> @@ -233,6 +235,21 @@ kunit_filter_suites(const struct kunit_suite_set *su=
ite_set,
>                 if (!filtered_suite)
>                         continue;
>
> +               if (filtered_suite =3D=3D suite_set->start[i]) {
> +                       /*
> +                        * To make memory allocation consistent whatever
> +                        * filters are used or not, and to keep
> +                        * kunit_free_suite_set() simple, always copy sta=
tic
> +                        * data.
> +                        */
> +                       filtered_suite =3D kmemdup(filtered_suite, sizeof=
(*filtered_suite),
> +                                       GFP_KERNEL);
> +                       if (!filtered_suite) {
> +                               *err =3D -ENOMEM;
> +                               goto free_parsed_filters;
> +                       }
> +               }
> +
>                 *copy++ =3D filtered_suite;
>         }
>         filtered.start =3D copy_start;
> @@ -348,7 +365,7 @@ static void kunit_handle_shutdown(void)
>
>  }
>
> -int kunit_run_all_tests(void)
> +static int kunit_init_suites(void)
>  {
>         struct kunit_suite_set suite_set =3D {NULL, NULL};
>         struct kunit_suite_set filtered_suite_set =3D {NULL, NULL};
> @@ -361,6 +378,9 @@ int kunit_run_all_tests(void)
>         size_t init_num_suites =3D init_suite_set.end - init_suite_set.st=
art;
>         int err =3D 0;
>
> +       if (!kunit_enabled())
> +               return 0;
> +
>         if (init_num_suites > 0) {
>                 suite_set =3D kunit_merge_suite_sets(init_suite_set, norm=
al_suite_set);
>                 if (!suite_set.start)
> @@ -368,41 +388,56 @@ int kunit_run_all_tests(void)
>         } else
>                 suite_set =3D normal_suite_set;
>
> -       if (!kunit_enabled()) {
> -               pr_info("kunit: disabled\n");
> +       filtered_suite_set =3D kunit_filter_suites(&suite_set, filter_glo=
b_param,
> +                       filter_param, filter_action_param, &err);
> +
> +       /* Free original suite set before using filtered suite set */
> +       if (init_num_suites > 0)
> +               kfree(suite_set.start);
> +       suite_set =3D filtered_suite_set;
> +
> +       if (err) {
> +               pr_err("kunit executor: error filtering suites: %d\n", er=
r);
>                 goto free_out;
>         }
>
> -       if (filter_glob_param || filter_param) {
> -               filtered_suite_set =3D kunit_filter_suites(&suite_set, fi=
lter_glob_param,
> -                               filter_param, filter_action_param, &err);
> +       final_suite_set =3D suite_set;
> +       return 0;
>
> -               /* Free original suite set before using filtered suite se=
t */
> -               if (init_num_suites > 0)
> -                       kfree(suite_set.start);
> -               suite_set =3D filtered_suite_set;
> +free_out:
> +       kunit_free_suite_set(suite_set);
>
> -               if (err) {
> -                       pr_err("kunit executor: error filtering suites: %=
d\n", err);
> -                       goto free_out;
> -               }
> +out:
> +       kunit_handle_shutdown();
> +       return err;
> +}
> +
> +late_initcall(kunit_init_suites);
> +
> +int kunit_run_all_tests(void)
> +{
> +       int err =3D 0;
> +
> +       if (!kunit_enabled()) {
> +               pr_info("kunit: disabled\n");
> +               goto out;
>         }
>
> +       if (!final_suite_set.start)
> +               goto out;
> +
>         if (!action_param)
> -               kunit_exec_run_tests(&suite_set, true);
> +               kunit_exec_run_tests(&final_suite_set, true);
>         else if (strcmp(action_param, "list") =3D=3D 0)
> -               kunit_exec_list_tests(&suite_set, false);
> +               kunit_exec_list_tests(&final_suite_set, false);
>         else if (strcmp(action_param, "list_attr") =3D=3D 0)
> -               kunit_exec_list_tests(&suite_set, true);
> +               kunit_exec_list_tests(&final_suite_set, true);
>         else
>                 pr_err("kunit executor: unknown action '%s'\n", action_pa=
ram);
>
> -free_out:
> -       if (filter_glob_param || filter_param)
> -               kunit_free_suite_set(suite_set);
> -       else if (init_num_suites > 0)
> -               /* Don't use kunit_free_suite_set because suites aren't i=
ndividually allocated */
> -               kfree(suite_set.start);
> +       kunit_free_suite_set(final_suite_set);
> +       final_suite_set.start =3D NULL;
> +       final_suite_set.end =3D NULL;
>
>  out:
>         kunit_handle_shutdown();
> diff --git a/lib/kunit/kunit-example-test.c b/lib/kunit/kunit-example-tes=
t.c
> index 798924f7cc86..248949eb3b16 100644
> --- a/lib/kunit/kunit-example-test.c
> +++ b/lib/kunit/kunit-example-test.c
> @@ -337,7 +337,7 @@ static struct kunit_suite example_test_suite =3D {
>   */
>  kunit_test_suites(&example_test_suite);
>
> -static int __init init_add(int x, int y)
> +static int init_add(int x, int y)

The whole point of this function (and the example_init_test) is that
they're marked __init, as proof we can test code which is in the init
section.

So, either we leave this alone, or we remove it entirely. There's no
point just removing __init.

>  {
>         return (x + y);
>  }
> @@ -345,7 +345,7 @@ static int __init init_add(int x, int y)
>  /*
>   * This test should always pass. Can be used to test init suites.
>   */
> -static void __init example_init_test(struct kunit *test)
> +static void example_init_test(struct kunit *test)

As above.

>  {
>         KUNIT_EXPECT_EQ(test, init_add(1, 1), 2);
>  }
> @@ -354,7 +354,7 @@ static void __init example_init_test(struct kunit *te=
st)
>   * The kunit_case struct cannot be marked as __initdata as this will be
>   * used in debugfs to retrieve results after test has run
>   */
> -static struct kunit_case __refdata example_init_test_cases[] =3D {
> +static struct kunit_case example_init_test_cases[] =3D {
>         KUNIT_CASE(example_init_test),
>         {}
>  };

As above.

> diff --git a/lib/kunit_iov_iter.c b/lib/kunit_iov_iter.c
> index 859b67c4d697..a77991a9bffb 100644
> --- a/lib/kunit_iov_iter.c
> +++ b/lib/kunit_iov_iter.c
> @@ -44,9 +44,8 @@ static void iov_kunit_unmap(void *data)
>         vunmap(data);
>  }
>
> -static void *__init iov_kunit_create_buffer(struct kunit *test,
> -                                           struct page ***ppages,
> -                                           size_t npages)
> +static void *iov_kunit_create_buffer(struct kunit *test, struct page ***=
ppages,
> +                                    size_t npages)
>  {
>         struct page **pages;
>         unsigned long got;
> @@ -69,11 +68,10 @@ static void *__init iov_kunit_create_buffer(struct ku=
nit *test,
>         return buffer;
>  }
>
> -static void __init iov_kunit_load_kvec(struct kunit *test,
> -                                      struct iov_iter *iter, int dir,
> -                                      struct kvec *kvec, unsigned int kv=
max,
> -                                      void *buffer, size_t bufsize,
> -                                      const struct kvec_test_range *pr)
> +static void iov_kunit_load_kvec(struct kunit *test, struct iov_iter *ite=
r,
> +                               int dir, struct kvec *kvec, unsigned int =
kvmax,
> +                               void *buffer, size_t bufsize,
> +                               const struct kvec_test_range *pr)
>  {
>         size_t size =3D 0;
>         int i;
> @@ -95,7 +93,7 @@ static void __init iov_kunit_load_kvec(struct kunit *te=
st,
>  /*
>   * Test copying to a ITER_KVEC-type iterator.
>   */
> -static void __init iov_kunit_copy_to_kvec(struct kunit *test)
> +static void iov_kunit_copy_to_kvec(struct kunit *test)
>  {
>         const struct kvec_test_range *pr;
>         struct iov_iter iter;
> @@ -145,7 +143,7 @@ static void __init iov_kunit_copy_to_kvec(struct kuni=
t *test)
>  /*
>   * Test copying from a ITER_KVEC-type iterator.
>   */
> -static void __init iov_kunit_copy_from_kvec(struct kunit *test)
> +static void iov_kunit_copy_from_kvec(struct kunit *test)
>  {
>         const struct kvec_test_range *pr;
>         struct iov_iter iter;
> @@ -213,12 +211,11 @@ static const struct bvec_test_range bvec_test_range=
s[] =3D {
>         { -1, -1, -1 }
>  };
>
> -static void __init iov_kunit_load_bvec(struct kunit *test,
> -                                      struct iov_iter *iter, int dir,
> -                                      struct bio_vec *bvec, unsigned int=
 bvmax,
> -                                      struct page **pages, size_t npages=
,
> -                                      size_t bufsize,
> -                                      const struct bvec_test_range *pr)
> +static void iov_kunit_load_bvec(struct kunit *test, struct iov_iter *ite=
r,
> +                               int dir, struct bio_vec *bvec,
> +                               unsigned int bvmax, struct page **pages,
> +                               size_t npages, size_t bufsize,
> +                               const struct bvec_test_range *pr)
>  {
>         struct page *can_merge =3D NULL, *page;
>         size_t size =3D 0;
> @@ -254,7 +251,7 @@ static void __init iov_kunit_load_bvec(struct kunit *=
test,
>  /*
>   * Test copying to a ITER_BVEC-type iterator.
>   */
> -static void __init iov_kunit_copy_to_bvec(struct kunit *test)
> +static void iov_kunit_copy_to_bvec(struct kunit *test)
>  {
>         const struct bvec_test_range *pr;
>         struct iov_iter iter;
> @@ -308,7 +305,7 @@ static void __init iov_kunit_copy_to_bvec(struct kuni=
t *test)
>  /*
>   * Test copying from a ITER_BVEC-type iterator.
>   */
> -static void __init iov_kunit_copy_from_bvec(struct kunit *test)
> +static void iov_kunit_copy_from_bvec(struct kunit *test)
>  {
>         const struct bvec_test_range *pr;
>         struct iov_iter iter;
> @@ -370,10 +367,9 @@ static void iov_kunit_destroy_xarray(void *data)
>         kfree(xarray);
>  }
>
> -static void __init iov_kunit_load_xarray(struct kunit *test,
> -                                        struct iov_iter *iter, int dir,
> -                                        struct xarray *xarray,
> -                                        struct page **pages, size_t npag=
es)
> +static void iov_kunit_load_xarray(struct kunit *test, struct iov_iter *i=
ter,
> +                                 int dir, struct xarray *xarray,
> +                                 struct page **pages, size_t npages)
>  {
>         size_t size =3D 0;
>         int i;
> @@ -401,7 +397,7 @@ static struct xarray *iov_kunit_create_xarray(struct =
kunit *test)
>  /*
>   * Test copying to a ITER_XARRAY-type iterator.
>   */
> -static void __init iov_kunit_copy_to_xarray(struct kunit *test)
> +static void iov_kunit_copy_to_xarray(struct kunit *test)
>  {
>         const struct kvec_test_range *pr;
>         struct iov_iter iter;
> @@ -459,7 +455,7 @@ static void __init iov_kunit_copy_to_xarray(struct ku=
nit *test)
>  /*
>   * Test copying from a ITER_XARRAY-type iterator.
>   */
> -static void __init iov_kunit_copy_from_xarray(struct kunit *test)
> +static void iov_kunit_copy_from_xarray(struct kunit *test)
>  {
>         const struct kvec_test_range *pr;
>         struct iov_iter iter;
> @@ -522,7 +518,7 @@ static void __init iov_kunit_copy_from_xarray(struct =
kunit *test)
>  /*
>   * Test the extraction of ITER_KVEC-type iterators.
>   */
> -static void __init iov_kunit_extract_pages_kvec(struct kunit *test)
> +static void iov_kunit_extract_pages_kvec(struct kunit *test)
>  {
>         const struct kvec_test_range *pr;
>         struct iov_iter iter;
> @@ -602,7 +598,7 @@ static void __init iov_kunit_extract_pages_kvec(struc=
t kunit *test)
>  /*
>   * Test the extraction of ITER_BVEC-type iterators.
>   */
> -static void __init iov_kunit_extract_pages_bvec(struct kunit *test)
> +static void iov_kunit_extract_pages_bvec(struct kunit *test)
>  {
>         const struct bvec_test_range *pr;
>         struct iov_iter iter;
> @@ -680,7 +676,7 @@ static void __init iov_kunit_extract_pages_bvec(struc=
t kunit *test)
>  /*
>   * Test the extraction of ITER_XARRAY-type iterators.
>   */
> -static void __init iov_kunit_extract_pages_xarray(struct kunit *test)
> +static void iov_kunit_extract_pages_xarray(struct kunit *test)
>  {
>         const struct kvec_test_range *pr;
>         struct iov_iter iter;
> @@ -756,7 +752,7 @@ static void __init iov_kunit_extract_pages_xarray(str=
uct kunit *test)
>         KUNIT_SUCCEED();
>  }
>
> -static struct kunit_case __refdata iov_kunit_cases[] =3D {
> +static struct kunit_case iov_kunit_cases[] =3D {
>         KUNIT_CASE(iov_kunit_copy_to_kvec),
>         KUNIT_CASE(iov_kunit_copy_from_kvec),
>         KUNIT_CASE(iov_kunit_copy_to_bvec),
> diff --git a/tools/testing/kunit/kunit_kernel.py b/tools/testing/kunit/ku=
nit_kernel.py
> index 0b6488efed47..e1980ea58118 100644
> --- a/tools/testing/kunit/kunit_kernel.py
> +++ b/tools/testing/kunit/kunit_kernel.py
> @@ -104,12 +104,13 @@ class LinuxSourceTreeOperationsQemu(LinuxSourceTree=
Operations):
>                 self._kconfig =3D qemu_arch_params.kconfig
>                 self._qemu_arch =3D qemu_arch_params.qemu_arch
>                 self._kernel_path =3D qemu_arch_params.kernel_path
> -               self._kernel_command_line =3D qemu_arch_params.kernel_com=
mand_line + ' kunit_shutdown=3Dreboot'
> +               self._kernel_command_line =3D qemu_arch_params.kernel_com=
mand_line + ' kunit_shutdown=3Dreboot rootfstype=3Dtmpfs'
>                 self._extra_qemu_params =3D qemu_arch_params.extra_qemu_p=
arams
>                 self._serial =3D qemu_arch_params.serial
>
>         def make_arch_config(self, base_kunitconfig: kunit_config.Kconfig=
) -> kunit_config.Kconfig:
>                 kconfig =3D kunit_config.parse_from_string(self._kconfig)
> +               kconfig.add_entry('TMPFS', 'y')

Can we add these to config files rather than add them here?


>                 kconfig.merge_in_entries(base_kunitconfig)
>                 return kconfig
>
> @@ -139,13 +140,14 @@ class LinuxSourceTreeOperationsUml(LinuxSourceTreeO=
perations):
>
>         def make_arch_config(self, base_kunitconfig: kunit_config.Kconfig=
) -> kunit_config.Kconfig:
>                 kconfig =3D kunit_config.parse_file(UML_KCONFIG_PATH)
> +               kconfig.add_entry('TMPFS', 'y')
>                 kconfig.merge_in_entries(base_kunitconfig)
>                 return kconfig
>
>         def start(self, params: List[str], build_dir: str) -> subprocess.=
Popen:
>                 """Runs the Linux UML binary. Must be named 'linux'."""
>                 linux_bin =3D os.path.join(build_dir, 'linux')
> -               params.extend(['mem=3D1G', 'console=3Dtty', 'kunit_shutdo=
wn=3Dhalt'])
> +               params.extend(['mem=3D1G', 'console=3Dtty', 'kunit_shutdo=
wn=3Dhalt', 'rootfstype=3Dtmpfs'])
>                 return subprocess.Popen([linux_bin] + params,
>                                            stdin=3Dsubprocess.PIPE,
>                                            stdout=3Dsubprocess.PIPE,
> --
> 2.44.0
>

--000000000000839cca06129422da
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIPqgYJKoZIhvcNAQcCoIIPmzCCD5cCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg0EMIIEtjCCA56gAwIBAgIQeAMYYHb81ngUVR0WyMTzqzANBgkqhkiG9w0BAQsFADBMMSAwHgYD
VQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UE
AxMKR2xvYmFsU2lnbjAeFw0yMDA3MjgwMDAwMDBaFw0yOTAzMTgwMDAwMDBaMFQxCzAJBgNVBAYT
AkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMSowKAYDVQQDEyFHbG9iYWxTaWduIEF0bGFz
IFIzIFNNSU1FIENBIDIwMjAwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCvLe9xPU9W
dpiHLAvX7kFnaFZPuJLey7LYaMO8P/xSngB9IN73mVc7YiLov12Fekdtn5kL8PjmDBEvTYmWsuQS
6VBo3vdlqqXZ0M9eMkjcKqijrmDRleudEoPDzTumwQ18VB/3I+vbN039HIaRQ5x+NHGiPHVfk6Rx
c6KAbYceyeqqfuJEcq23vhTdium/Bf5hHqYUhuJwnBQ+dAUcFndUKMJrth6lHeoifkbw2bv81zxJ
I9cvIy516+oUekqiSFGfzAqByv41OrgLV4fLGCDH3yRh1tj7EtV3l2TngqtrDLUs5R+sWIItPa/4
AJXB1Q3nGNl2tNjVpcSn0uJ7aFPbAgMBAAGjggGKMIIBhjAOBgNVHQ8BAf8EBAMCAYYwHQYDVR0l
BBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMBIGA1UdEwEB/wQIMAYBAf8CAQAwHQYDVR0OBBYEFHzM
CmjXouseLHIb0c1dlW+N+/JjMB8GA1UdIwQYMBaAFI/wS3+oLkUkrk1Q+mOai97i3Ru8MHsGCCsG
AQUFBwEBBG8wbTAuBggrBgEFBQcwAYYiaHR0cDovL29jc3AyLmdsb2JhbHNpZ24uY29tL3Jvb3Ry
MzA7BggrBgEFBQcwAoYvaHR0cDovL3NlY3VyZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvcm9vdC1y
My5jcnQwNgYDVR0fBC8wLTAroCmgJ4YlaHR0cDovL2NybC5nbG9iYWxzaWduLmNvbS9yb290LXIz
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
7xDrOPfX3COqq162RFg/MFcGA1UdIARQME4wCQYHZ4EMAQUBATBBBgkrBgEEAaAyASgwNDAyBggr
BgEFBQcCARYmaHR0cHM6Ly93d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wDAYDVR0TAQH/
BAIwADCBmgYIKwYBBQUHAQEEgY0wgYowPgYIKwYBBQUHMAGGMmh0dHA6Ly9vY3NwLmdsb2JhbHNp
Z24uY29tL2NhL2dzYXRsYXNyM3NtaW1lY2EyMDIwMEgGCCsGAQUFBzAChjxodHRwOi8vc2VjdXJl
Lmdsb2JhbHNpZ24uY29tL2NhY2VydC9nc2F0bGFzcjNzbWltZWNhMjAyMC5jcnQwHwYDVR0jBBgw
FoAUfMwKaNei6x4schvRzV2Vb4378mMwRgYDVR0fBD8wPTA7oDmgN4Y1aHR0cDovL2NybC5nbG9i
YWxzaWduLmNvbS9jYS9nc2F0bGFzcjNzbWltZWNhMjAyMC5jcmwwDQYJKoZIhvcNAQELBQADggEB
AK0lDd6/eSh3qHmXaw1YUfIFy07B25BEcTvWgOdla99gF1O7sOsdYaTz/DFkZI5ghjgaPJCovgla
mRMfNcxZCfoBtsB7mAS6iOYjuwFOZxi9cv6jhfiON6b89QWdMaPeDddg/F2Q0bxZ9Z2ZEBxyT34G
wlDp+1p6RAqlDpHifQJW16h5jWIIwYisvm5QyfxQEVc+XH1lt+taSzCfiBT0ZLgjB9Sg+zAo8ys6
5PHxFaT2a5Td/fj5yJ5hRSrqy/nj/hjT14w3/ZdX5uWg+cus6VjiiR/5qGSZRjHt8JoApD6t6/tg
ITv8ZEy6ByumbU23nkHTMOzzQSxczHkT+0q10/MxggJqMIICZgIBATBoMFQxCzAJBgNVBAYTAkJF
MRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMSowKAYDVQQDEyFHbG9iYWxTaWduIEF0bGFzIFIz
IFNNSU1FIENBIDIwMjACEAHS+TgZvH/tCq5FcDC0n9IwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZI
hvcNAQkEMSIEIASJ+m9zwGY3bBpD8CXJMWHo/Cohm+dcDcc3nC/ml1p1MBgGCSqGSIb3DQEJAzEL
BgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI0MDMwMTA3MTUwM1owaQYJKoZIhvcNAQkPMVww
WjALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkq
hkiG9w0BAQowCwYJKoZIhvcNAQEHMAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCRHMqW
U6spu56AD5w4J+l3ZM56Trc2Z+dnzt0PpUC8U5kYAYKC96dqAzerPoVDQTagPWq5I+lRbCsSn00F
Th+vjydg72B5qNeF7gv1g24QxcaaOoL8YWwQwYRwsoebc9gZ0gPHuGdXFIGKLEC55cVyyTswR2wz
aKlCVGtuvztUYru5pppfoO/wYJFBPqGYRXhhvkQB2aQt6LxuTBoGU2fzUoRSKQmCCvRwokStzXt3
sUMCY4TM2+raXVxY2nOXsHg3yK8IY3XBU6GlddP2e9hJ8DhTeTr3ygyXHjJxEs5EoAQ3Lnz2M3jS
dg/80cAEUddb8U27dhXzVMxViEszMR7M
--000000000000839cca06129422da--

