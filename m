Return-Path: <kvm+bounces-44602-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 05D1BA9FA01
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 21:55:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 181D23B82C4
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 19:55:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED5812973D4;
	Mon, 28 Apr 2025 19:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3KKFYV3+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com [209.85.219.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D96518DF62
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 19:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745870120; cv=none; b=Wjp+rUL1/Y0s7Ag6n4T65Bt2+fSa0AZodrhDp+CQOJjuQp06QG59+PGJEiDxhb/9W4CeEZ2kaRPu0NMo5QO8Nx5tiKCMAylz4X0RuptrM8AqI48PMZWIarYKkVojC4LzSlr186EvQOTIbj6l7I4ZnRmjjnY/UdFAdxVmYmbzAr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745870120; c=relaxed/simple;
	bh=Ul2mCutafIkcCO47yAMR6kqOc2J45J0V3vs2YNHmMwc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AOP36DpUj/FdSYT6XYQt1cSOEwJuRWEL4qzLHh6EOofX19FXJNj8KAvOFAbnlzdlPRiPWShh1D4cyTpzc0yG99+I8fxn2Bv1cz3boRO1bdt6zLJmCIy2LbMs4NC3xMxBfaBXdkIwDOg3mD6QN3U6vyK7qDRiCOPlsT/OSgeQxBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3KKFYV3+; arc=none smtp.client-ip=209.85.219.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yb1-f177.google.com with SMTP id 3f1490d57ef6-e7297c3ce7aso3769921276.0
        for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 12:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745870117; x=1746474917; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sfHwTscWO/jloUEDudbJlwyzGCxdwaIO+zKhNAi9qAo=;
        b=3KKFYV3+p3v2jSotn8S17qNg6iLfFORgrecvlTs+F5PXcg3qYHRkP+rkOpwB4Zcgu8
         EGrXOBlVNHj4qNBjxRbUUBTvDzQn/D0nMSdiJCfRjfpNNO5EczooJ5nOZIJ3Qi1E1YR7
         ttqujG29KAMjVSQilHTNUi0vsk7hmJxXme5Szn73wM4/eOMr4s2YvH/a89vUmF6kJvCc
         7pXsjJHngHJD+AA3p0cL/0aYRsT+uz4UdOvcL0wcf4yk/rBHiv7cek36resku5ov9gg+
         bgklrDEDQnwZTY+uf2+yYqZ4AKvkRjjMMwybUicw7IrIzAPq2bkA1yB2COkVYw3io9Cr
         VoYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745870117; x=1746474917;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sfHwTscWO/jloUEDudbJlwyzGCxdwaIO+zKhNAi9qAo=;
        b=X2kcUumqvvELg/o3Ag7ztQaYFG9F8+H5xIf7ZD+L4ZF2/bYDhpbnZLXeF+cXGdA2qW
         zRdNSSsdlcfVUTdaC46ag+DeRVkY0OiOcs87eD+D9eusd592bCFO8enw0YGCFk8oF5XQ
         6cB14hxhtPdy0SIxJ6Egw1rngFNj7MKw5mw95OxoPYDxpribCxh4JuiKWkOYOEbLIpiG
         nqq9hytLjg79szII4jl75lKElU+1ed1eKVQ6JR2+bq1iX4NTbgBNORZz1hinR1IKz3oA
         ukYDKSTUcrgm7M/+Rm8i5zAZbNtdV+UQ964VMdC7I0ZIcTwxaaxxyNK80Wd5evuz4Xod
         0R6A==
X-Gm-Message-State: AOJu0YzKvt7c7Zz/YzbhXiqLSRKy+hspkausQbkAyq/RHg2ZkE6jslDK
	M++DIwUZ4Y+9hZvDnfNWU0OlCwozULESQDvX3B6m/zrkuiIdA6mQWrB6E3MUyudpEytZtyLyO1i
	0Ol1IrNkkJWKaOScxp7oEYaC5ClU6QP0483LG
X-Gm-Gg: ASbGncvvOJNKMwupfGKz4d51jICxYpbvsL5zKR8YbM6/EyvxeN1qzIq5rTbU6+vXtuE
	seoXX26CkTEgV3yTNH0ltft6Nj70m2vPOPma2+GaNxwDOf0qm8+sGhciR2bFlkCjbzLowDngSDK
	xK7LUz98DD2MEDaH9oiXiTaafLyjpX2vhZu/vxgexAPKQKxqCqJ1Mq0x32ZqFGosy88KA=
X-Google-Smtp-Source: AGHT+IF5bOE8NaQox434M5XmykiOoFpfiOOstY8512J8SiE44O+53iDRI95fhIJQcDKl1pHA+A5H/zkhcUhoVNEAjiw=
X-Received: by 2002:a05:6902:158e:b0:e6e:667:911d with SMTP id
 3f1490d57ef6-e73233a6dc2mr13962923276.21.1745870117123; Mon, 28 Apr 2025
 12:55:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250414200929.3098202-1-jthoughton@google.com>
 <20250414200929.3098202-6-jthoughton@google.com> <aAwpWwMIJEjtL5F9@google.com>
In-Reply-To: <aAwpWwMIJEjtL5F9@google.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 28 Apr 2025 15:54:41 -0400
X-Gm-Features: ATxdqUFyYu3QFWzs4o008gMYEtq4uvUsSn7Emn7MJoROAS3_0BzmZZrNMQlZ_Ss
Message-ID: <CADrL8HX03P1f2E7NzufXU3enW1EXz2Bk2qNh5KQg-X1KFQed8g@mail.gmail.com>
Subject: Re: [PATCH v3 5/5] KVM: selftests: access_tracking_perf_test: Use
 MGLRU for access tracking
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, mkoutny@suse.com, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Yu Zhao <yuzhao@google.com>, David Matlack <dmatlack@google.com>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 25, 2025 at 8:31=E2=80=AFPM Sean Christopherson <seanjc@google.=
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
> This fails on my end due to not being able to find the cgroup.  I spent a=
bout 15
> minutes poking at it and gave it.  FWIW, this is on our devrez hosts, so =
it's
> presumably similar hardware to what you tested on.

Ah sorry, yes, this selftest needs to be patched when running the
devrez userspace, which uses a combination of cgroup-v1 and cgroup-v2.
Simply hard-coding the root to "/dev/cgroup/memory" (which is in fact
a cgroup-v1 mount) should be what you need if you want to give it
another go.

> Even if this turns out to be PEBKAC or some CONFIG_XXX incompatibility, t=
here
> needs to be better hints provided to the user of how they can some this.

Yeah this can be better. I should at least check that the found
cgroup-v2 root's cgroup.controllers contains "memory". In your case,
it did not.

(cgroup.controllers is not available for cgroup-v1 -- because it
doesn't make sense -- so if I patch the selftest to check this file,
using cgroup-v1 mounts will stop working. So, again, you'd need to
patch the test to work on devrez.)

> And this would be a perfect opportunity to clean up this:
>
>         __TEST_REQUIRE(page_idle_fd >=3D 0,
>                        "CONFIG_IDLE_PAGE_TRACKING is not enabled");

I think the change I've already made to this string is sufficient
(happy to change it further if you like):
> > +               __TEST_REQUIRE(page_idle_fd >=3D 0,
> > +                              "Couldn't open /sys/kernel/mm/page_idle/=
bitmap. "
> > +                              "Is CONFIG_IDLE_PAGE_TRACKING enabled?")=
;

> I can't count the number of times I've forgotten to run the test with roo=
t
> privileges, and wasted a bunch of time remembering it's not that the kern=
el
> doesn't have CONFIG_IDLE_PAGE_TRACKING, but that /sys/kernel/mm/page_idle=
/bitmap
> isn't accessible.
>
> I mention that, because on a kernel with MGRLU available but disabled, an=
d
> CONFIG_IDLE_PAGE_TRACKING=3Dn, the user has no idea that they _can_ run t=
he test
> without mucking with their kernel.

Fair enough, I'll change the output from the test for that
configuration to say something like: "please either enable the missing
MGLRU features (e.g. `echo 3 > /sys/kernel/mm/lru_gen/enabled`) or
recompile your kernel with CONFIG_IDLE_PAGE_TRACKING=3Dy."

> =3D=3D=3D=3D Test Assertion Failure =3D=3D=3D=3D
>   lib/lru_gen_util.c:229: stats->memcg_id > 0
>   pid=3D423298 tid=3D423298 errno=3D2 - No such file or directory
>      1  0x0000000000408b45: lru_gen_read_memcg_stats at lru_gen_util.c:22=
9
>      2  0x0000000000402e4c: run_test at access_tracking_perf_test.c:421
>      3  0x0000000000403694: for_each_guest_mode at guest_modes.c:96
>      4  0x00000000004023dd: run_test_in_cg at access_tracking_perf_test.c=
:467
>      5  0x000000000041ba65: cg_run at cgroup_util.c:362
>      6  0x0000000000402042: main at access_tracking_perf_test.c:583
>      7  0x000000000041c753: __libc_start_call_main at libc-start.o:?
>      8  0x000000000041e9ac: __libc_start_main_impl at ??:?
>      9  0x0000000000402280: _start at ??:?
>   Couldn't find memcg: access_tracking_perf_test
> Did the memcg get created in the proper mount?
> Destroying cgroup: /sys/fs/cgroup/access_tracking_perf_test

Thanks for taking a look!

