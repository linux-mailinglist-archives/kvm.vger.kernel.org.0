Return-Path: <kvm+bounces-42136-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E236A73DB9
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 19:08:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F3FAD173771
	for <lists+kvm@lfdr.de>; Thu, 27 Mar 2025 18:08:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E05CF21A431;
	Thu, 27 Mar 2025 18:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0uXjl5rw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com [209.85.160.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85259219A8B
	for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 18:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743098877; cv=none; b=hM/EOTyM/CVzrOT7anDRylsqofE5zjbKcP1VJVyfcNiyUP6lRJJiqaLuOIEN0EiibfCpNnnNePSmxYwCNp8zaSM4JSU0/FjGFYkvNoxFLokhATUHaFA6ggkI2a1I7t7JOxDDjDDdFktJdH68HqHDpCbnbM8lghuVXc8vvtp5i6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743098877; c=relaxed/simple;
	bh=FFw5jVGVjWP/GUcE+gD57gEpEJu0gzTYL/Vm74NKgAE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gcikOasb+cylTKv7NU/qNaDSerqByhzW3IXkPtxOWxE0KQDXpSmemxN9+M35lPYIIxPlyU3CVIWpXAfAp1Q/v0VEKL6SQiG05c0VjRHFn/Bezp3JRCugxeZodwEUBAUc+DFkq7UO9IfnVM2ZbXuUBhe7EBoiaF5ylC5QcxMaOY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0uXjl5rw; arc=none smtp.client-ip=209.85.160.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jthoughton.bounces.google.com
Received: by mail-qt1-f201.google.com with SMTP id d75a77b69052e-4769a8d15afso20704011cf.3
        for <kvm@vger.kernel.org>; Thu, 27 Mar 2025 11:07:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1743098874; x=1743703674; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FNHhGbcNFe9IvxKegRUJgU6d0SStVr5clQydvbl1alA=;
        b=0uXjl5rwxVBQhweW9GwBi94rXFQmmkxoO2AAeTIBnZd40lrIqaxCtr3ba2Qn56xRRL
         Bflikq4fbnPrBFQlVE0qHj5r9nI8+KidyPNxdxijKukRkf80kjwb8T0Bw9Ughfbb6VoZ
         z5S/LskWMppf3wiZBf5IEDhTcOvIHaAHgdGSu7iF/Deqw6gFsYVFXuFSsT2zxPzpBY+J
         g2RkffkvQNbhKxLIFAdRnuiPu+4jYxmVQv5oMTRPKAWnzPI5xkCBbSrrSdJjrrtUxwQu
         /1A1Mf3f8xyhf0l3kJaW2kTLyt42RLp/tWYNYwS/Ce2MZs0whWd9IGeiO6JC8CO2PzXe
         SnOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743098874; x=1743703674;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FNHhGbcNFe9IvxKegRUJgU6d0SStVr5clQydvbl1alA=;
        b=JRNQYTgEoh4K5LEA+mg24Pios+voStOHaPxrxKSOZjTzlfghmsrllwmp50URA6o0Q3
         bGdbv/aVib58zwvv0ysSdAJ5lYSe2MA/rc0WoH58vHz9wSNwvyo6T4+s2zylk91z2B+V
         loE+8YJNFE5Rj1qBzwW4Gq/fNltpfKG0gGDiqYz5nZBzgYrLP/2CLOnGnCyyx4eAnveA
         OAD4eb5D10AXg/Akm5+E6FASRHPJqIRkuXjrTPzyBJ4DAIzZkEWtH+Xzmmt3etBJrFNC
         2I/kOZ76QpkZ1FUZCysdjUPjuSiT4Yi5AAVh3iV4NBskFDDNt65UAZTo2B1/TAp7FtN6
         4Kag==
X-Forwarded-Encrypted: i=1; AJvYcCWNpfsLJa3GCzP+PwG6nCGkpHicFbCaIHDo2FODVr2gz4Z5ZzuoO10y8UyRpWWVuW1+BJ0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0jibQMP8uBM2PfSnntHxqklVxO5blNYJHo6mnQE2NfbliirbX
	o+yuIvEghM7HsvVPy+P0lQ+PrRIs/tu2XDqZyrhjW8A2hcAxnLL0qZuB+03DVUYiIKYk/Vk64qL
	pk7dHyJRosHqru6ebcQ==
X-Google-Smtp-Source: AGHT+IHhR1AcX7MOyjilKRGwXaffZLhxfuTjulaccN51vv9gMpKZONM4saJU+yWDYPnnHE9lipgeoqVqPn+NMSdW
X-Received: from uau11.prod.google.com ([2002:a05:6130:634b:b0:86f:fad4:5337])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:622a:5a94:b0:476:a967:b242 with SMTP id d75a77b69052e-4776e152be4mr95011791cf.30.1743098874436;
 Thu, 27 Mar 2025 11:07:54 -0700 (PDT)
Date: Thu, 27 Mar 2025 18:07:51 +0000
In-Reply-To: <fg5owc6cvx7mkdq64ljc4byc5xmepddgthanynyvfsqhww7wx2@q5op3ltl2nip>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <fg5owc6cvx7mkdq64ljc4byc5xmepddgthanynyvfsqhww7wx2@q5op3ltl2nip>
X-Mailer: git-send-email 2.49.0.472.ge94155a9ec-goog
Message-ID: <20250327180753.1458171-1-jthoughton@google.com>
Subject: Re: [PATCH 3/5] cgroup: selftests: Move cgroup_util into its own library
From: James Houghton <jthoughton@google.com>
To: mkoutny@suse.com
Cc: axelrasmussen@google.com, cgroups@vger.kernel.org, dmatlack@google.com, 
	hannes@cmpxchg.org, jthoughton@google.com, kvm@vger.kernel.org, 
	laoar.shao@gmail.com, linux-kernel@vger.kernel.org, mlevitsk@redhat.com, 
	seanjc@google.com, tj@kernel.org, yuzhao@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 27, 2025 at 2:43=E2=80=AFAM Michal Koutn=C3=BD <mkoutny@suse.co=
m> wrote:
>
> Hello James.
>
> On Thu, Mar 27, 2025 at 01:23:48AM +0000, James Houghton <jthoughton@goog=
le.com> wrote:
> > KVM selftests will soon need to use some of the cgroup creation and
> > deletion functionality from cgroup_util.
>
> Thanks, I think cross-selftest sharing is better than duplicating
> similar code.
>
> +Cc: Yafang as it may worth porting/unifying with
> tools/testing/selftests/bpf/cgroup_helpers.h too
>
> > --- a/tools/testing/selftests/cgroup/cgroup_util.c
> > +++ b/tools/testing/selftests/cgroup/lib/cgroup_util.c
> > @@ -16,8 +16,7 @@
> > =C2=A0#include <sys/wait.h>
> > =C2=A0#include <unistd.h>
> >=20
> > -#include "cgroup_util.h"
> > -#include "../clone3/clone3_selftests.h"
> > +#include <cgroup_util.h>
>
> The clone3_selftests.h header is not needed anymore?

Ah, sorry.

We do indeed still reference `sys_clone3()` from cgroup_util.c, so it shoul=
d
stay in (as "../../clone3/clone3_selftests.h"). I realize now that it compi=
led
just fine because the call to `sys_clone3()` is dropped entirely when
clone3_selftests.h is not included.

So I'll apply the following diff:

diff --git a/tools/testing/selftests/cgroup/lib/cgroup_util.c b/tools/testi=
ng/selftests/cgroup/lib/cgroup_util.c
index d5649486a11df..fe15541f3a07d 100644
--- a/tools/testing/selftests/cgroup/lib/cgroup_util.c
+++ b/tools/testing/selftests/cgroup/lib/cgroup_util.c
@@ -18,6 +18,8 @@
=20
 #include <cgroup_util.h>
=20
+#include "../../clone3/clone3_selftests.h"
+
 /* Returns read len on success, or -errno on failure. */
 static ssize_t read_text(const char *path, char *buf, size_t max_len)
 {
diff --git a/tools/testing/selftests/cgroup/lib/libcgroup.mk b/tools/testin=
g/selftests/cgroup/lib/libcgroup.mk
index 2cbf07337c23f..12323041a5ce6 100644
--- a/tools/testing/selftests/cgroup/lib/libcgroup.mk
+++ b/tools/testing/selftests/cgroup/lib/libcgroup.mk
@@ -6,7 +6,9 @@ LIBCGROUP_O :=3D $(patsubst %.c, $(OUTPUT)/%.o, $(LIBCGROUP=
_C))
=20
 CFLAGS +=3D -I$(CGROUP_DIR)/lib/include
=20
-$(LIBCGROUP_O): $(OUTPUT)/%.o : $(CGROUP_DIR)/%.c
+EXTRA_HDRS :=3D $(selfdir)/clone3/clone3_selftests.h
+
+$(LIBCGROUP_O): $(OUTPUT)/%.o : $(CGROUP_DIR)/%.c $(EXTRA_HDRS)
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
=20
 EXTRA_CLEAN +=3D $(LIBCGROUP_O)

