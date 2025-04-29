Return-Path: <kvm+bounces-44829-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 64828AA3BD1
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 00:56:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7040B468695
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 22:56:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B5872BE108;
	Tue, 29 Apr 2025 22:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Hg+JPUgi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f201.google.com (mail-vk1-f201.google.com [209.85.221.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0F42BD5B2
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 22:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745967356; cv=none; b=qrnoRsgPFdmk1S0OMhITarYSvDnWiSwwSNwRY4m3TqRD5FiyaZNpC7Z02IXdZ6GNYMbPnn9OeeBYqYCR3KU78mygYeFxUFtLpbaRb0gExb1PEQXzH5YuUR52Ra5zoT5IXEx5MdROtNpBxfov7TZXPmcp2DuoUI8rX1BCBlmNhS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745967356; c=relaxed/simple;
	bh=h3fpiKz+pE3i6o07OLUk6tXnOM7tD6i3OVlgEEr1xTw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=A2rQCwKnB/NqhINFtwoFklc/lfU7a5nuFDu6sEoPbauQ9fB8IyXGmJ1pGtFCfbs6E3gPIJD9oAZ7NVwOWFxmjEDyHZvs54arX1QmboPLowdZdZKpfIvQ3bMdqGJvjRgOZfg+ZenkE/rwAEx64QTDPPYGcAkCUo5qi99rp/MsY1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Hg+JPUgi; arc=none smtp.client-ip=209.85.221.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-vk1-f201.google.com with SMTP id 71dfb90a1353d-523ddfc9788so951163e0c.0
        for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 15:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745967352; x=1746572152; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=15+w1LKig+rz0q1ujX2cae9z+DBN+Uiv96OK22YVpKE=;
        b=Hg+JPUgiMBgEQ1CJHQHGgGWuacXDsYWz6x9GN2pd7UshngKNzZFqDa3n+uScux5pwz
         +yJch/34N5LnWqo1JRNpWorBaNm2ykhV7+mYO8zVivCQtBKor9sC75eazUJONHMr2TWw
         dQDezX43LsHC2o/67lfACqiGMIMpxqHyJYh7Vmmw4xDSG+uF9s5Su5sUzltmDXpqBbFN
         2mC5y7LbLmwjxLY9hru97jaSgIVloQE7m1jmJDYP3qH6+wePlFd/bcumbvO8GGWkf8pJ
         tMHNR7xEUZljj7+RdRTOtJ6JgBczNYHTGsr9XTo/xGqozUBz8HnXnG2gzM+nNgQuqZ0t
         lzXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745967352; x=1746572152;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=15+w1LKig+rz0q1ujX2cae9z+DBN+Uiv96OK22YVpKE=;
        b=VLllFJC3EMMZNmR31I7qbdtH6cZx2Is+8nvw0MHwuR70M6b1LKpJ0szd1vaPaA/vvI
         sjWyMtUz7oVWC0ssM3JQUJ+ICATfVfATi82qu46jRDhInAxnTETLzQNiqgS1eclB0ije
         rxhq1GTp6pbRWHeh+oEnen92GDkaXrvO0tpoTEHBtWi0HNKxNselVJYhKufPt5whXBVe
         iarvYtFvwM8vRNi0f9ckNGV12Zc+2B7E4veaJgpIZ0fLkaERBN0U4BfhQn68N8uq5u/i
         6qVPtCxxs+TPEO6Gpwa9mCk9O6cCgX5/Uc/wH1nhhbhEYfCP5vt1MUl9rG627OJQWW6/
         d60g==
X-Forwarded-Encrypted: i=1; AJvYcCVxHDAv5maztKldua1AviSODhj3P8/cgoUhP41wRfTdGyALDz6aodRZGffdi/Gh/8ic+Zs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWeZRaJr8An0/dAHBCBGhkPzwQ495tmOT4SlVGmUCHrDbMLmyq
	sUrRSAfyMtntyA64w4PlqzPDFW5nGVTPbICV4xFyQ+FI0o0F2qHtO6EKtotrAAuPIq4gftJveWZ
	GWrbJKHglu58WtvAsFg==
X-Google-Smtp-Source: AGHT+IH8/MQ9qKgb4txdq/HEmbpSuMHa1UCUOGEjmDp8HZIZ5TJWsC7v0uWPI2N95yUgO03XmzCm4O5PYHnCLQ/t
X-Received: from vkbby11.prod.google.com ([2002:a05:6122:248b:b0:52a:9a03:a241])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6122:179a:b0:527:67c7:50f with SMTP id 71dfb90a1353d-52acd8923b6mr997554e0c.11.1745967352309;
 Tue, 29 Apr 2025 15:55:52 -0700 (PDT)
Date: Tue, 29 Apr 2025 22:55:49 +0000
In-Reply-To: <aBApDSHblacSBaFH@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <aBApDSHblacSBaFH@google.com>
X-Mailer: git-send-email 2.49.0.901.g37484f566f-goog
Message-ID: <20250429225550.106865-1-jthoughton@google.com>
Subject: Re: [PATCH v3 5/5] KVM: selftests: access_tracking_perf_test: Use
 MGLRU for access tracking
From: James Houghton <jthoughton@google.com>
To: seanjc@google.com
Cc: axelrasmussen@google.com, cgroups@vger.kernel.org, dmatlack@google.com, 
	hannes@cmpxchg.org, jthoughton@google.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mkoutny@suse.com, mlevitsk@redhat.com, 
	tj@kernel.org, yosry.ahmed@linux.dev, yuzhao@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 28, 2025 at 9:19=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Mon, Apr 14, 2025, James Houghton wrote:
> > By using MGLRU's debugfs for invoking test_young() and clear_young(), w=
e
> > avoid page_idle's incompatibility with MGLRU, and we can mark pages as
> > idle (clear_young()) much faster.
> >
> > The ability to use page_idle is left in, as it is useful for kernels
> > that do not have MGLRU built in. If MGLRU is enabled but is not usable
> > (e.g. we can't access the debugfs mount), the test will fail, as
> > page_idle is not compatible with MGLRU.
> >
> > cgroup utility functions have been borrowed so that, when running with
> > MGLRU, we can create a memcg in which to run our test.
> >
> > Other MGLRU-debugfs-specific parsing code has been added to
> > lru_gen_util.{c,h}.
>
> This is not a proper changelog, at least not by upstream KVM standards. =
=C2=A0Please
> rewrite it describe the changes being made, using imperative mood/tone. =
=C2=A0From
> Documentation/process/maintainer-kvm-x86.rst:
>
> =C2=A0 Changelog
> =C2=A0 ~~~~~~~~~
> =C2=A0 Most importantly, write changelogs using imperative mood and avoid=
 pronouns.

Right. I'll rewrite the changelog properly.

>
> > @@ -354,7 +459,12 @@ static int access_tracking_unreliable(void)
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 puts("Skipping idle pa=
ge count sanity check, because NUMA balancing is enabled");
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 1;
> > =C2=A0 =C2=A0 =C2=A0 }
> > + =C2=A0 =C2=A0 return 0;
> > +}
> >=20
> > +int run_test_in_cg(const char *cgroup, void *arg)
>
> static

Will change.

>
> > +{
> > + =C2=A0 =C2=A0 for_each_guest_mode(run_test, arg);
>
> Having "separate" flows for MGLRU vs. page_idle is unnecessary. =C2=A0Giv=
e the helper
> a more common name and use it for both:
>
> static int run_test_for_each_guest_mode(const char *cgroup, void *arg)
> {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 for_each_guest_mode(run_test, arg);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> }

Applied for my next version, thanks.

>
> > =C2=A0 =C2=A0 =C2=A0 return 0;
> > =C2=A0}
> >=20
> > @@ -372,7 +482,7 @@ static void help(char *name)
> > =C2=A0 =C2=A0 =C2=A0 printf(" -v: specify the number of vCPUs to run.\n=
");
> > =C2=A0 =C2=A0 =C2=A0 printf(" -o: Overlap guest memory accesses instead=
 of partitioning\n"
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0" =C2=A0 =C2=A0 them in=
to a separate region of memory for each vCPU.\n");
> > - =C2=A0 =C2=A0 printf(" -w: Control whether the test warns or fails if=
 more than 10%\n"
> > + =C2=A0 =C2=A0 printf(" -w: Control whether the test warns or fails if=
 more than 10%%\n"
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0" =C2=A0 =C2=A0 of page=
s are still seen as idle/old after accessing guest\n"
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0" =C2=A0 =C2=A0 memory.=
 =C2=A0>0 =3D=3D warn only, 0 =3D=3D fail, <0 =3D=3D auto. =C2=A0For auto\n=
"
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0" =C2=A0 =C2=A0 mode, t=
he test fails by default, but switches to warn only\n"
> > @@ -383,6 +493,12 @@ static void help(char *name)
> > =C2=A0 =C2=A0 =C2=A0 exit(0);
> > =C2=A0}
> >=20
> > +void destroy_cgroup(char *cg)
>
> static. =C2=A0But this is a pointless wrapper, just delete it.

Will do.

> Using MGLRU on my home box fails. =C2=A0It's full cgroup v2, and has both
> CONFIG_IDLE_PAGE_TRACKING=3Dy and MGLRU enabled.
>
> =3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
> =C2=A0 access_tracking_perf_test.c:244: false
> =C2=A0 pid=3D114670 tid=3D114670 errno=3D17 - File exists
> =C2=A0 =C2=A0 =C2=A01 =C2=A00x00000000004032a9: find_generation at access=
_tracking_perf_test.c:244
> =C2=A0 =C2=A0 =C2=A02 =C2=A00x00000000004032da: lru_gen_mark_memory_idle =
at access_tracking_perf_test.c:272
> =C2=A0 =C2=A0 =C2=A03 =C2=A00x00000000004034e4: mark_memory_idle at acces=
s_tracking_perf_test.c:391
> =C2=A0 =C2=A0 =C2=A04 =C2=A0 (inlined by) run_test at access_tracking_per=
f_test.c:431
> =C2=A0 =C2=A0 =C2=A05 =C2=A00x0000000000403d84: for_each_guest_mode at gu=
est_modes.c:96
> =C2=A0 =C2=A0 =C2=A06 =C2=A00x0000000000402c61: run_test_for_each_guest_m=
ode at access_tracking_perf_test.c:492
> =C2=A0 =C2=A0 =C2=A07 =C2=A00x000000000041d8e2: cg_run at cgroup_util.c:3=
82
> =C2=A0 =C2=A0 =C2=A08 =C2=A00x00000000004027fa: main at access_tracking_p=
erf_test.c:572
> =C2=A0 =C2=A0 =C2=A09 =C2=A00x00007fa1cb629d8f: ?? ??:0
> =C2=A0 =C2=A0 10 =C2=A00x00007fa1cb629e3f: ?? ??:0
> =C2=A0 =C2=A0 11 =C2=A00x00000000004029d4: _start at ??:?
> =C2=A0 Could not find a generation with 90% of guest memory (235929 pages=
).
>
> Interestingly, if I force the test to use /sys/kernel/mm/page_idle/bitmap=
, it
> passes.
>
> Please try to reproduce the failure (assuming you haven't already tested =
that
> exact combination of cgroups v2, MGLRU=3Dy, and CONFIG_IDLE_PAGE_TRACKING=
=3Dy). I
> don't have bandwidth to dig any further at this time.

Sorry... please see the bottom of this message for a diff that should fix t=
his.
It fixes these bugs:

1.  Tracking generation numbers without hardware Accessed bit management.
    (This is addition of lru_gen_last_gen.)
1.5 It does an initial aging pass so that pages always move to newer
    generations in (or before) the subsequent aging passes. This probably
    isn't needed given the change I made for (1).
2.  Fixes the expected number of pages for guest page sizes > PAGE_SIZE.
    (This is the move of test_pages. test_pages has also been renamed to av=
oid
    shadowing.)
3.  Fixes an off-by-one error when looking for the generation with the most
    pages. Previously it failed to check the youngest generation, which I t=
hink
    is the bug you ran into. (This is the change to lru_gen_util.c.)

It might take a couple tweaks to compile in your tree. (It is just a WIP di=
ff
from when I was applying changes from your feedback, so it contains partial
changes you asked for.

> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (cg_find_unified_root(cg=
roup_root, sizeof(cgroup_root), NULL))
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 ksft_exit_skip("cgroup v2 isn't mounted\n");
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 new_cg =3D cg_name(cgroup_r=
oot, TEST_MEMCG_NAME);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printf("Creating cgroup: %s=
\n", new_cg);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (cg_create(new_cg) && er=
rno !=3D EEXIST)
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 ksft_exit_skip("could not create new cgroup: %s\n", new_cg);
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 use_lru_gen =3D true;
> > + =C2=A0 =C2=A0 } else {
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 page_idle_fd =3D open("/sys=
/kernel/mm/page_idle/bitmap", O_RDWR);
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 __TEST_REQUIRE(page_idle_fd=
 >=3D 0,
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0"Couldn't open /sys/kernel/mm/page_idle/bitmap.=
 "
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0"Is CONFIG_IDLE_PAGE_TRACKING enabled?");
> > +
> > + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 close(page_idle_fd);
> > + =C2=A0 =C2=A0 }
>
> Splitting the "check" and "execute" into separate if-else statements resu=
lts in
> some compilers complaining about new_cg possibly being unused. =C2=A0The =
compiler is
> probably being a bit stupid, but the code is just as must to blame. =C2=
=A0There's zero
> reason to split this in two, just do everything after the idle_pages_warn=
_only
> and total_pages processing. =C2=A0Code at the bottom (note, you'll have t=
o rebase on
> my not-yet-posted series, or undo the use of __open_path_or_exit()).

I have applied the below suggestion for the next version of the series. Tha=
nks.

> static int run_test_for_each_guest_mode(const char *cgroup, void *arg)
> {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 for_each_guest_mode(run_test, arg);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> }
>
> int main(int argc, char *argv[])
> {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct test_params params =3D {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .backing_src =3D =
DEFAULT_VM_MEM_SRC,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .vcpu_memory_byte=
s =3D DEFAULT_PER_VCPU_MEM_SIZE,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 .nr_vcpus =3D 1,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 };
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 int page_idle_fd;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 int opt;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 guest_modes_append_default();
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 while ((opt =3D getopt(argc, argv, "hm:b:v:os=
:w:")) !=3D -1) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 switch (opt) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 case 'm':
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 guest_modes_cmdline(optarg);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 break;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 case 'b':
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 params.vcpu_memory_bytes =3D parse_size(optarg);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 break;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 case 'v':
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 params.nr_vcpus =3D atoi_positive("Number of vCPUs", optarg);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 break;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 case 'o':
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 overlap_memory_access =3D true;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 break;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 case 's':
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 params.backing_src =3D parse_backing_src_type(optarg);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 break;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 case 'w':
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 idle_pages_warn_only =3D
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 atoi_non_negative("Idle pages warnin=
g",
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 optarg);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 break;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 case 'h':
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 default:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 help(argv[0]);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 break;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (idle_pages_warn_only =3D=3D -1)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 idle_pages_warn_o=
nly =3D access_tracking_unreliable();
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* If guest_page_size is larger than the=
 host's page size, the
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* guest (memstress) will only fault in =
a subset of the host's pages.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 total_pages =3D params.nr_vcpus * params.vcpu=
_memory_bytes /
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 max_t(uint64_t, memstress_args.guest_page_size, getpagesize());
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (lru_gen_usable()) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bool cg_created =
=3D true;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 char *test_cg =3D=
 NULL;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 int ret;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 puts("Using lru_g=
en for aging");
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 use_lru_gen =3D t=
rue;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (cg_find_contr=
oller_root(cgroup_root, sizeof(cgroup_root), "memory"))
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 ksft_exit_skip("Cannot find memory group controller\n");
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 test_cg =3D cg_na=
me(cgroup_root, TEST_MEMCG_NAME);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 printf("Creating =
cgroup: %s\n", test_cg);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (cg_create(tes=
t_cg)) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (errno =3D=3D EEXIST)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cg_created =3D false;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 else
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ksft_exit_skip("could not create new=
 cgroup: %s\n", test_cg);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /*
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* This will=
 fork off a new process to run the test within
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* a new mem=
cg, so we need to properly propagate the return
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* value up.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D cg_run(te=
st_cg, &run_test_for_each_guest_mode, &params);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (cg_created)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 cg_destroy(test_cg);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return ret;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 puts("Using page_idle for aging");
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 page_idle_fd =3D __open_path_or_exit("/sys/ke=
rnel/mm/page_idle/bitmap", O_RDWR,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0"Is CONFIG_IDLE_PAGE_TRACKING enabled?");
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 close(page_idle_fd);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 run_test_for_each_guest_mode(NULL, &params);
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 return 0;
> }

And here is the diff that make the test start working for you:

diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/tool=
s/testing/selftests/kvm/access_tracking_perf_test.c
index d4ef201b67055..d4ae29c7dfe35 100644
--- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
+++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
@@ -90,7 +90,10 @@ static int idle_pages_warn_only =3D -1;
 static bool use_lru_gen;
=20
 /* Total number of pages to expect in the memcg after touching everything =
*/
-static long total_pages;
+static long test_pages;
+
+/* Last generation we found the pages in */
+static int lru_gen_last_gen =3D -1;
=20
 struct test_params {
 	/* The backing source for the region of memory. */
@@ -265,11 +268,7 @@ static void lru_gen_mark_memory_idle(struct kvm_vm *vm=
)
 	struct timespec ts_start;
 	struct timespec ts_elapsed;
 	struct memcg_stats stats;
-	int found_gens[2];
-
-	/* Find current generation the pages lie in. */
-	lru_gen_read_memcg_stats(&stats, TEST_MEMCG_NAME);
-	found_gens[0] =3D find_generation(&stats, total_pages);
+	int new_gen;
=20
 	/* Make a new generation */
 	clock_gettime(CLOCK_MONOTONIC, &ts_start);
@@ -277,23 +276,24 @@ static void lru_gen_mark_memory_idle(struct kvm_vm *v=
m)
 	ts_elapsed =3D timespec_elapsed(ts_start);
=20
 	/* Check the generation again */
-	found_gens[1] =3D find_generation(&stats, total_pages);
+	new_gen =3D find_generation(&stats, test_pages);
=20
 	/*
 	 * This function should only be invoked with newly-accessed pages,
 	 * so pages should always move to a newer generation.
 	 */
-	if (found_gens[0] >=3D found_gens[1]) {
+	if (new_gen <=3D lru_gen_last_gen) {
 		/* We did not move to a newer generation. */
-		long idle_pages =3D lru_gen_sum_memcg_stats_for_gen(found_gens[1],
+		long idle_pages =3D lru_gen_sum_memcg_stats_for_gen(lru_gen_last_gen,
 								  &stats);
=20
-		too_many_idle_pages(min_t(long, idle_pages, total_pages),
-				    total_pages, -1);
+		too_many_idle_pages(min_t(long, idle_pages, test_pages),
+				    test_pages, -1);
 	}
 	pr_info("%-30s: %ld.%09lds\n",
 		"Mark memory idle (lru_gen)", ts_elapsed.tv_sec,
 		ts_elapsed.tv_nsec);
+	lru_gen_last_gen =3D new_gen;
 }
=20
 static void assert_ucall(struct kvm_vcpu *vcpu, uint64_t expected_ucall)
@@ -410,6 +410,14 @@ static void run_test(enum vm_guest_mode mode, void *ar=
g)
 	vm =3D memstress_create_vm(mode, nr_vcpus, params->vcpu_memory_bytes, 1,
 				 params->backing_src, !overlap_memory_access);
=20
+	/*
+	 * If guest_page_size is larger than the host's page size, the
+	 * guest (memstress) will only fault in a subset of the host's pages.
+	 */
+	test_pages =3D params->nr_vcpus * params->vcpu_memory_bytes /
+		      max(memstress_args.guest_page_size,
+			  (uint64_t)getpagesize());
+
 	memstress_start_vcpu_threads(nr_vcpus, vcpu_thread_main);
=20
 	pr_info("\n");
@@ -418,9 +426,18 @@ static void run_test(enum vm_guest_mode mode, void *ar=
g)
 	if (use_lru_gen) {
 		struct memcg_stats stats;
=20
-		lru_gen_read_memcg_stats(&stats, TEST_MEMCG_NAME);
-		TEST_ASSERT(lru_gen_sum_memcg_stats(&stats) >=3D total_pages,
-			    "Not all pages accounted for. Was the memcg set up correctly?");
+		/*
+		 * Do a page table scan now. After initial population, aging
+		 * may not cause the pages to move to a newer generation. Do
+		 * an aging pass now so that future aging passes always move
+		 * pages to a newer generation.
+		 */
+		printf("Initial aging pass (lru_gen)\n");
+		lru_gen_do_aging(&stats, TEST_MEMCG_NAME);
+		TEST_ASSERT(lru_gen_sum_memcg_stats(&stats) >=3D test_pages,
+			    "Not all pages accounted for (looking for %ld). "
+			    "Was the memcg set up correctly?", test_pages);
+		access_memory(vm, nr_vcpus, ACCESS_WRITE, "Re-populating memory");
 	}
=20
 	/* As a control, read and write to the populated memory first. */
@@ -496,7 +513,6 @@ static void help(char *name)
 void destroy_cgroup(char *cg)
 {
 	printf("Destroying cgroup: %s\n", cg);
-	cg_destroy(cg);
 }
=20
 int main(int argc, char *argv[])
@@ -541,50 +557,48 @@ int main(int argc, char *argv[])
 		}
 	}
=20
-	if (lru_gen_usable()) {
-		if (cg_find_unified_root(cgroup_root, sizeof(cgroup_root), NULL))
-			ksft_exit_skip("cgroup v2 isn't mounted\n");
-
-		new_cg =3D cg_name(cgroup_root, TEST_MEMCG_NAME);
-		printf("Creating cgroup: %s\n", new_cg);
-		if (cg_create(new_cg) && errno !=3D EEXIST)
-			ksft_exit_skip("could not create new cgroup: %s\n", new_cg);
-
-		use_lru_gen =3D true;
-	} else {
-		page_idle_fd =3D open("/sys/kernel/mm/page_idle/bitmap", O_RDWR);
-		__TEST_REQUIRE(page_idle_fd >=3D 0,
-			       "Couldn't open /sys/kernel/mm/page_idle/bitmap. "
-			       "Is CONFIG_IDLE_PAGE_TRACKING enabled?");
-
-		close(page_idle_fd);
-	}
-
 	if (idle_pages_warn_only =3D=3D -1)
 		idle_pages_warn_only =3D access_tracking_unreliable();
=20
-	/*
-	 * If guest_page_size is larger than the host's page size, the
-	 * guest (memstress) will only fault in a subset of the host's pages.
-	 */
-	total_pages =3D params.nr_vcpus * params.vcpu_memory_bytes /
-		      max(memstress_args.guest_page_size,
-			  (uint64_t)getpagesize());
-
-	if (use_lru_gen) {
+	if (lru_gen_usable()) {
+		bool cg_created =3D true;
 		int ret;
=20
 		puts("Using lru_gen for aging");
+		use_lru_gen =3D true;
+
+		if (cg_find_controller_root(cgroup_root, sizeof(cgroup_root), "memory"))
+			ksft_exit_skip("Cannot find memory cgroup controller\n");
+
+		new_cg =3D cg_name(cgroup_root, TEST_MEMCG_NAME);
+		printf("Creating cgroup: %s\n", new_cg);
+		if (cg_create(new_cg)) {
+			if (errno =3D=3D EEXIST) {
+				printf("Found existing cgroup");
+				cg_created =3D false;
+			}
+			else
+				ksft_exit_skip("could not create new cgroup: %s\n", new_cg);
+		}
+
 		/*
 		 * This will fork off a new process to run the test within
 		 * a new memcg, so we need to properly propagate the return
 		 * value up.
 		 */
 		ret =3D cg_run(new_cg, &run_test_in_cg, &params);
-		destroy_cgroup(new_cg);
+		if (cg_created)
+			cg_destroy(new_cg);
 		if (ret)
 			return ret;
 	} else {
+		page_idle_fd =3D open("/sys/kernel/mm/page_idle/bitmap", O_RDWR);
+		__TEST_REQUIRE(page_idle_fd >=3D 0,
+			       "Couldn't open /sys/kernel/mm/page_idle/bitmap. "
+			       "Is CONFIG_IDLE_PAGE_TRACKING enabled?");
+
+		close(page_idle_fd);
+
 		puts("Using page_idle for aging");
 		for_each_guest_mode(run_test, &params);
 	}
diff --git a/tools/testing/selftests/kvm/lib/lru_gen_util.c b/tools/testing=
/selftests/kvm/lib/lru_gen_util.c
index 783a1f1028a26..cab54935b160a 100644
--- a/tools/testing/selftests/kvm/lib/lru_gen_util.c
+++ b/tools/testing/selftests/kvm/lib/lru_gen_util.c
@@ -341,7 +341,7 @@ int lru_gen_find_generation(const struct memcg_stats *s=
tats,
 			min_gen =3D gen < min_gen ? gen : min_gen;
 		}
=20
-	for (gen =3D min_gen; gen < max_gen; ++gen)
+	for (gen =3D min_gen; gen <=3D max_gen; ++gen)
 		/* See if this generation has enough pages. */
 		if (lru_gen_sum_memcg_stats_for_gen(gen, stats) > pages)
 			return gen;

