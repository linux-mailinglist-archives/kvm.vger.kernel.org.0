Return-Path: <kvm+bounces-44626-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CF24A9FEA0
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 02:56:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA123461D78
	for <lists+kvm@lfdr.de>; Tue, 29 Apr 2025 00:56:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B01013EFF3;
	Tue, 29 Apr 2025 00:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FZg+en0g"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9848DC2C6
	for <kvm@vger.kernel.org>; Tue, 29 Apr 2025 00:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745888168; cv=none; b=nQ38Pic3NVP8+jhzoEbYWqP8lb97J/BQsLK1hgu9BnRs1eVHKtK+q8/eD7tjj3OHe7wt3fhoEHIIzzq9w+42xaqXb5RH2cUWAdf9yVgg1N5jp2ZR7wZdvxf43b+qRDmBCeNKJpdXraV6fvBr/PHHQvQ8YT9RqGSlyGfohT39MGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745888168; c=relaxed/simple;
	bh=R3qiCOKricv0V7guueM+WNlKjYrj/xlSi1gJS3t7yhU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cFs1V06hcArgKM/iHS2iET0h7uC0WrmKlvLZV6s5XYh00/Hl1gk3fIedB70kmVymVatF26kgT95ieKz866HA1hgokRbYx5x9LrS/CH5s6tlZZ0pMrNGeyXlT0mvQp5m8hikSYnHhs/irocZE+gCbFHnGggTCYH/atKb9WZPkRvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FZg+en0g; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ff6167e9ccso6255329a91.1
        for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 17:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745888166; x=1746492966; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qIfl9sldI2oYnELP7cv05KQ/pnmI23d3v+rJeb6lnZA=;
        b=FZg+en0gDpc2QXlRb2mFJdA+TzdRGyY889OIZm+qOCRrzU5pSyyWOgGVvlNGA6LWaY
         HLM8BhVYk5glD0oEkxEqbuqfd4FNHq14hSYLBetNGaO6sx6t7GHUvcbYB9Go2fiZxHkZ
         e684PYi5Hm6rAhJ61DblPZenE8XEBvd+UIjvXWxgcZXQGcnZYkH4mASzab4mNVRv6fS/
         YFKL06Uc8Z6SNzRYyMgZB1+hL34GwLTzFJKrFVWHK26wFfoOqw2Te1B2GQxM3xAKFGar
         o/jvRRjsOZbvgPY0re2ZjNSQXbbjSgOgpuUb4ZaVjCKQtEtIA1lh+ZH5KEHo/rMmPqLx
         GmsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745888166; x=1746492966;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qIfl9sldI2oYnELP7cv05KQ/pnmI23d3v+rJeb6lnZA=;
        b=fk6pIm/zQkTAr80pbe3XB9gWXo13o1GabWVRn9L8ciL9YAuXlfkTXf+u4BDurlwzWv
         DSAL19lwfHzTdAE3jLM/picIyMVNvlmxr3H1G3+grsXiFZswlyQ7JqLh3NYrA7VzGEpx
         4GHRKW74QfcAyjvuFxQvOFcdtLlt/HbhhRvaB/RTuuzwtL8FT+JIRMJNsPLdCWUfyUja
         ly2lahDoggfRVUtk0TIxyfOetOdJu/hYYEaOqt1M1MV1ptM03pfv76QWmLPoPEYKcEq6
         KJr5ps1Mn1RgYDQB2PoDa/whkonY4NtL1nfI2aIfFEv2Z5FmZ+7v8MZJG1d88CdqUWNi
         QTUw==
X-Gm-Message-State: AOJu0YxrSQAE2zM+cAIzsp0QhHHyxKqEuL+KHiELmgeQT62/naeXGhP3
	yv4nxWx8zlCqlSyYV9Rc64brDj5byS7UmBDACTDMkwscQYxzxMlgEqnq/yJYzuUrV8dWSZJjwkt
	E+A==
X-Google-Smtp-Source: AGHT+IFRDAQmXGqF9t6A1AUN9GWgCt2IQIKU/j6VszK3kGzTc9EySIp4JBSSxgQ/BZg7rQbLlNIadMMTltw=
X-Received: from pjboe15.prod.google.com ([2002:a17:90b:394f:b0:2ea:448a:8cd1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d4c1:b0:227:e74a:a05a
 with SMTP id d9443c01a7336-22de60702a3mr26654175ad.44.1745888165925; Mon, 28
 Apr 2025 17:56:05 -0700 (PDT)
Date: Mon, 28 Apr 2025 17:56:04 -0700
In-Reply-To: <CADrL8HX03P1f2E7NzufXU3enW1EXz2Bk2qNh5KQg-X1KFQed8g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250414200929.3098202-1-jthoughton@google.com>
 <20250414200929.3098202-6-jthoughton@google.com> <aAwpWwMIJEjtL5F9@google.com>
 <CADrL8HX03P1f2E7NzufXU3enW1EXz2Bk2qNh5KQg-X1KFQed8g@mail.gmail.com>
Message-ID: <aBAjpKvXoT62zG6h@google.com>
Subject: Re: [PATCH v3 5/5] KVM: selftests: access_tracking_perf_test: Use
 MGLRU for access tracking
From: Sean Christopherson <seanjc@google.com>
To: James Houghton <jthoughton@google.com>
Cc: kvm@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, mkoutny@suse.com, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Yu Zhao <yuzhao@google.com>, David Matlack <dmatlack@google.com>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 28, 2025, James Houghton wrote:
> On Fri, Apr 25, 2025 at 8:31=E2=80=AFPM Sean Christopherson <seanjc@googl=
e.com> wrote:
> >
> > On Mon, Apr 14, 2025, James Houghton wrote:
> > > By using MGLRU's debugfs for invoking test_young() and clear_young(),=
 we
> > > avoid page_idle's incompatibility with MGLRU, and we can mark pages a=
s
> > > idle (clear_young()) much faster.
> > >
> > > The ability to use page_idle is left in, as it is useful for kernels
> > > that do not have MGLRU built in. If MGLRU is enabled but is not usabl=
e
> > > (e.g. we can't access the debugfs mount), the test will fail, as
> > > page_idle is not compatible with MGLRU.
> > >
> > > cgroup utility functions have been borrowed so that, when running wit=
h
> > > MGLRU, we can create a memcg in which to run our test.
> > >
> > > Other MGLRU-debugfs-specific parsing code has been added to
> > > lru_gen_util.{c,h}.
> >
> > This fails on my end due to not being able to find the cgroup.  I spent=
 about 15
> > minutes poking at it and gave it.  FWIW, this is on our devrez hosts, s=
o it's
> > presumably similar hardware to what you tested on.
>=20
> Ah sorry, yes, this selftest needs to be patched when running the
> devrez userspace, which uses a combination of cgroup-v1 and cgroup-v2.
> Simply hard-coding the root to "/dev/cgroup/memory" (which is in fact
> a cgroup-v1 mount) should be what you need if you want to give it
> another go.
>
> > Even if this turns out to be PEBKAC or some CONFIG_XXX incompatibility,=
 there
> > needs to be better hints provided to the user of how they can some this=
.
>=20
> Yeah this can be better. I should at least check that the found
> cgroup-v2 root's cgroup.controllers contains "memory". In your case,
> it did not.
>=20
> (cgroup.controllers is not available for cgroup-v1 -- because it
> doesn't make sense -- so if I patch the selftest to check this file,
> using cgroup-v1 mounts will stop working. So, again, you'd need to
> patch the test to work on devrez.)

Or, and I know this going to sound crazy, what if we simply make the test w=
ork
with v1 or v2?  That is not hard to do, at all.  Please slot the below into=
 the
next version of the series.  Feel free to modify it as needed, e.g. to addr=
ess
other maintainer feedback.  The only thing I care about is the selftest not=
 failing.

> > And this would be a perfect opportunity to clean up this:
> >
> >         __TEST_REQUIRE(page_idle_fd >=3D 0,
> >                        "CONFIG_IDLE_PAGE_TRACKING is not enabled");
>=20
> I think the change I've already made to this string is sufficient
> (happy to change it further if you like):

Doh, I missed that your patch did already improve the skip message to spit =
out
/sys/kernel/mm/page_idle/bitmap; that part I definitely like.

> > > +               __TEST_REQUIRE(page_idle_fd >=3D 0,
> > > +                              "Couldn't open /sys/kernel/mm/page_idl=
e/bitmap. "
> > > +                              "Is CONFIG_IDLE_PAGE_TRACKING enabled?=
");
>=20
> > I can't count the number of times I've forgotten to run the test with r=
oot
> > privileges, and wasted a bunch of time remembering it's not that the ke=
rnel
> > doesn't have CONFIG_IDLE_PAGE_TRACKING, but that /sys/kernel/mm/page_id=
le/bitmap
> > isn't accessible.
> >
> > I mention that, because on a kernel with MGRLU available but disabled, =
and
> > CONFIG_IDLE_PAGE_TRACKING=3Dn, the user has no idea that they _can_ run=
 the test
> > without mucking with their kernel.
>=20
> Fair enough, I'll change the output from the test for that
> configuration to say something like: "please either enable the missing
> MGLRU features (e.g. `echo 3 > /sys/kernel/mm/lru_gen/enabled`) or
> recompile your kernel with CONFIG_IDLE_PAGE_TRACKING=3Dy."

That's still misleading.  In my case, my kernels are already built with
CONFIG_IDLE_PAGE_TRACKING=3Dy.

Looking at this again, we can do much better.  For my permissions issue, op=
en()
should fail with -EACCES, whereas the CONFIG_IDLE_PAGE_TRACKING=3Dn case sh=
ould
fail with ENOENT.  And that is easy enough to handle in open_path_or_exit()=
.

I'll send a small series to clean that up, and then will apply this series =
on top.
The resulting conflict will be trivial to resolve, so don't worry about reb=
asing
on top of my mini-series.

--
From: Sean Christopherson <seanjc@google.com>
Date: Mon, 28 Apr 2025 17:36:06 -0700
Subject: [PATCH] cgroup: selftests: Add API to find root of specific
 controller

Add an API in the cgroups library to find the root of a specific
controller.  KVM selftests will use the API to find the memory controller.

Search for the controller on both v1 and v2 mounts, as KVM selftests'
usage will be completely oblivious of v1 versus v2.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/cgroup/lib/cgroup_util.c        | 32 +++++++++++++++----
 .../cgroup/lib/include/cgroup_util.h          |  1 +
 2 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/cgroup/lib/cgroup_util.c b/tools/testi=
ng/selftests/cgroup/lib/cgroup_util.c
index 69a68f43e3fa..4e7e7329b226 100644
--- a/tools/testing/selftests/cgroup/lib/cgroup_util.c
+++ b/tools/testing/selftests/cgroup/lib/cgroup_util.c
@@ -217,7 +217,8 @@ int cg_write_numeric(const char *cgroup, const char *co=
ntrol, long value)
 	return cg_write(cgroup, control, buf);
 }
=20
-int cg_find_unified_root(char *root, size_t len, bool *nsdelegate)
+static int cg_find_root(char *root, size_t len, const char *controller,
+			bool *nsdelegate)
 {
 	char buf[10 * PAGE_SIZE];
 	char *fs, *mount, *type, *options;
@@ -237,17 +238,36 @@ int cg_find_unified_root(char *root, size_t len, bool=
 *nsdelegate)
 		strtok(NULL, delim);
 		strtok(NULL, delim);
=20
-		if (strcmp(type, "cgroup2") =3D=3D 0) {
-			strncpy(root, mount, len);
-			if (nsdelegate)
-				*nsdelegate =3D !!strstr(options, "nsdelegate");
-			return 0;
+		if (strcmp(type, "cgroup") =3D=3D 0) {
+			if (!controller || !strstr(options, controller))
+				continue;
+		} else if (strcmp(type, "cgroup2") =3D=3D 0) {
+			if (controller &&
+			    cg_read_strstr(mount, "cgroup.controllers", controller))
+				continue;
+		} else {
+			continue;
 		}
+		strncpy(root, mount, len);
+
+		if (nsdelegate)
+			*nsdelegate =3D !!strstr(options, "nsdelegate");
+		return 0;
 	}
=20
 	return -1;
 }
=20
+int cg_find_controller_root(char *root, size_t len, const char *controller=
)
+{
+	return cg_find_root(root, len, controller, NULL);
+}
+
+int cg_find_unified_root(char *root, size_t len, bool *nsdelegate)
+{
+	return cg_find_root(root, len, NULL, nsdelegate);
+}
+
 int cg_create(const char *cgroup)
 {
 	return mkdir(cgroup, 0755);
diff --git a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h b/too=
ls/testing/selftests/cgroup/lib/include/cgroup_util.h
index cbe6f0b4247d..d9e6e3090b3f 100644
--- a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
+++ b/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
@@ -21,6 +21,7 @@ static inline int values_close(long a, long b, int err)
 	return labs(a - b) <=3D (a + b) / 100 * err;
 }
=20
+extern int cg_find_controller_root(char *root, size_t len, const char *con=
troller);
 extern int cg_find_unified_root(char *root, size_t len, bool *nsdelegate);
 extern char *cg_name(const char *root, const char *name);
 extern char *cg_name_indexed(const char *root, const char *name, int index=
);

base-commit: 65a87fcc85da28361af2a5718c109dbc2f8d54a2
--

