Return-Path: <kvm+bounces-42874-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33397A7F197
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 02:18:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9ACEA3AA7AA
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 00:17:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD0491388;
	Tue,  8 Apr 2025 00:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HrtumlrC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 125FB8489
	for <kvm@vger.kernel.org>; Tue,  8 Apr 2025 00:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744071483; cv=none; b=PSxE8pHnML0bEQwWFTCxBAWDIayz9VBTj3At2j6z8BGDWIxp/YYPUByRVEMz4uOYbuuA2Uss0MG1R52cwUV+Bl969WPbInR2PqHtWKXqAroDbUfgGd5QHiMzKgME/90gOxLuUTx8wSoTr+0qY/0CmxUji1arVjospjhYY9y64xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744071483; c=relaxed/simple;
	bh=zkp5qlPWYg/IdGVqahdxRSzt7Um4YhxDY62rFGi0kZ0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BhxCX6POIhw3e6ht0bAmSir3u24WISXPe5nNhIpm0RcQFdLA8o7SQNjTkl+oSsIplsMRN8zCsahkh06lcTB1rjsdiirQ0fLjFk1UDybPRARqmqw8mo+tugIoMJl9ZTdh0TTlm0uyAmRimHBFPBmYZU7rsBp+8jHw7I71Me1CUrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HrtumlrC; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-54954fa61c9so2783405e87.1
        for <kvm@vger.kernel.org>; Mon, 07 Apr 2025 17:18:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744071479; x=1744676279; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jEVGQPfc6yrZuTVK9rKBMIxWQ+bczHOfNeqGOK471bg=;
        b=HrtumlrChLOrY6wFmWUoxGyVSA5ratOuQvEXro8yVP7qxx2CGB7F53bxiPdZNkU5Ke
         PsigxLFE02+6YRenFoUATlmDmbu1Iw9XuZdwYeT1MObc7UNDeFZXyw0eu1r2QrzUQ0HN
         Pmu0z6XArP72TZCRqgXkx1rF87SjPFlticF/cTCiDxe71wWbMX7fiqr1mgCO90dbpNWS
         xSyqbs6hLfAZRDK9G2zdJ596gxAcyTXulOmhZbdJ17zDasZD4ka82b+d6K+Er0sGUUPC
         H+1ULXUdZia8b3EwWVadc1drB/GjJXV/TqTqZFXkk+8D2FsZHj3TOW9CmwMdy/UJUgtx
         qH/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744071479; x=1744676279;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jEVGQPfc6yrZuTVK9rKBMIxWQ+bczHOfNeqGOK471bg=;
        b=OQD6d4DiRzY6mCboXecJw1AI0cPJx/TEMfZt/z0Ju9iLjQwNFA9PDy1iT0cGL8gIUw
         6Cm1ikjwRQBs7UKlSD+z6dPGgjRdKx8Su/DMkcVLDmdFFYwmSyLDPWF+ecLghlP1lZik
         Z5BNKL8tkrpySTBUApL5o027DNDQAVI1VISKyUKiP7e0iOR/NNu8BGZKsoTzHMSGt69+
         UwF9eQPShCUcgQ8cpP3FTHpytl8naoopR68JQXdiQ3eTQ1wKbZaAhdx4d+KGRWVlKiYk
         kD2dHuaip71VHX3yGiEVplhJcpNkHg/7hTpoq/beKx9Kv4tYqcW1w5UJSpOEuojlagoZ
         MlXg==
X-Forwarded-Encrypted: i=1; AJvYcCU7DLmaTHQUBZjWENhfKpmfe+dKXDw8JpCnCScUfbVzXpXAvdpk5TT/0Ujh6hxuQ2mRxO0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+s9ErZ32n3v/jHJWZT1QWPBGLO3GdYe04mfkN2s8zkH+V9lCa
	7IojroZsCqHsYNV0OOX/mH545/iGtUxWBXOaca8AyHECf0NQFD9oGd4FM/xXMuozmGdoNNOCFUs
	rs4BNz7QCZGCDQGQrlitkJ+dI7ffw8JjCejsQXAE0urwzjOTwyn2V
X-Gm-Gg: ASbGncuaaTsuP4zgKsLwelBPYO9v9I87+EHuIR/59RAaYcNH3EiFkdgb6hoa8E1xnZ6
	hv2Ju0rv9onceDbC9mkmDKxfN6MVojW0p9ywWQzLtucI+bi2bsOWddMsbySsujfETG0su+f4bNg
	g7m6syVb94fAhJCtg7QdsSr2SI2pDlYz6MjwDy
X-Google-Smtp-Source: AGHT+IGuGCo4hFxybL/j3KEZeGYvOtc2MclXy+qWXTfKV79t5s+xu9SE7cA7HRjIVAvcQvwLJR3by2JLdUxUeAIFuuQ=
X-Received: by 2002:a05:6512:118b:b0:549:8f01:6a71 with SMTP id
 2adb3069b0e04-54c22808c0amr3838505e87.51.1744071478751; Mon, 07 Apr 2025
 17:17:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250331213025.3602082-1-jthoughton@google.com> <20250331213025.3602082-4-jthoughton@google.com>
In-Reply-To: <20250331213025.3602082-4-jthoughton@google.com>
From: David Matlack <dmatlack@google.com>
Date: Mon, 7 Apr 2025 17:17:31 -0700
X-Gm-Features: ATxdqUEkDxP1QjyKSLEQFfB8dkpmmYdTokou6Ni4mo7iv2ZxfsyTcHM8h3zzPxU
Message-ID: <CALzav=eUpVLeypEB2q9vgNOmREb0TCOtjGGpj7pH5o5oLvB19w@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] cgroup: selftests: Move cgroup_util into its own library
To: James Houghton <jthoughton@google.com>
Cc: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, mkoutny@suse.com, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Yu Zhao <yuzhao@google.com>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 31, 2025 at 2:30=E2=80=AFPM James Houghton <jthoughton@google.c=
om> wrote:
>
> KVM selftests will soon need to use some of the cgroup creation and
> deletion functionality from cgroup_util.
>
> Suggested-by: David Matlack <dmatlack@google.com>
> Signed-off-by: James Houghton <jthoughton@google.com>
> ---
>  tools/testing/selftests/cgroup/Makefile       | 21 ++++++++++---------
>  .../selftests/cgroup/{ =3D> lib}/cgroup_util.c  |  2 +-
>  .../cgroup/{ =3D> lib/include}/cgroup_util.h    |  4 ++--
>  .../testing/selftests/cgroup/lib/libcgroup.mk | 14 +++++++++++++
>  4 files changed, 28 insertions(+), 13 deletions(-)
>  rename tools/testing/selftests/cgroup/{ =3D> lib}/cgroup_util.c (99%)
>  rename tools/testing/selftests/cgroup/{ =3D> lib/include}/cgroup_util.h =
(99%)
>  create mode 100644 tools/testing/selftests/cgroup/lib/libcgroup.mk
>
> diff --git a/tools/testing/selftests/cgroup/Makefile b/tools/testing/self=
tests/cgroup/Makefile
> index 1b897152bab6e..e01584c2189ac 100644
> --- a/tools/testing/selftests/cgroup/Makefile
> +++ b/tools/testing/selftests/cgroup/Makefile
> @@ -21,14 +21,15 @@ TEST_GEN_PROGS +=3D test_zswap
>  LOCAL_HDRS +=3D $(selfdir)/clone3/clone3_selftests.h $(selfdir)/pidfd/pi=
dfd.h
>
>  include ../lib.mk
> +include lib/libcgroup.mk
>
> -$(OUTPUT)/test_core: cgroup_util.c
> -$(OUTPUT)/test_cpu: cgroup_util.c
> -$(OUTPUT)/test_cpuset: cgroup_util.c
> -$(OUTPUT)/test_freezer: cgroup_util.c
> -$(OUTPUT)/test_hugetlb_memcg: cgroup_util.c
> -$(OUTPUT)/test_kill: cgroup_util.c
> -$(OUTPUT)/test_kmem: cgroup_util.c
> -$(OUTPUT)/test_memcontrol: cgroup_util.c
> -$(OUTPUT)/test_pids: cgroup_util.c
> -$(OUTPUT)/test_zswap: cgroup_util.c
> +$(OUTPUT)/test_core: $(LIBCGROUP_O)
> +$(OUTPUT)/test_cpu: $(LIBCGROUP_O)
> +$(OUTPUT)/test_cpuset: $(LIBCGROUP_O)
> +$(OUTPUT)/test_freezer: $(LIBCGROUP_O)
> +$(OUTPUT)/test_hugetlb_memcg: $(LIBCGROUP_O)
> +$(OUTPUT)/test_kill: $(LIBCGROUP_O)
> +$(OUTPUT)/test_kmem: $(LIBCGROUP_O)
> +$(OUTPUT)/test_memcontrol: $(LIBCGROUP_O)
> +$(OUTPUT)/test_pids: $(LIBCGROUP_O)
> +$(OUTPUT)/test_zswap: $(LIBCGROUP_O)
> diff --git a/tools/testing/selftests/cgroup/cgroup_util.c b/tools/testing=
/selftests/cgroup/lib/cgroup_util.c
> similarity index 99%
> rename from tools/testing/selftests/cgroup/cgroup_util.c
> rename to tools/testing/selftests/cgroup/lib/cgroup_util.c
> index 1e2d46636a0ca..f047d8adaec65 100644
> --- a/tools/testing/selftests/cgroup/cgroup_util.c
> +++ b/tools/testing/selftests/cgroup/lib/cgroup_util.c
> @@ -17,7 +17,7 @@
>  #include <unistd.h>
>
>  #include "cgroup_util.h"
> -#include "../clone3/clone3_selftests.h"
> +#include "../../clone3/clone3_selftests.h"
>
>  /* Returns read len on success, or -errno on failure. */
>  static ssize_t read_text(const char *path, char *buf, size_t max_len)
> diff --git a/tools/testing/selftests/cgroup/cgroup_util.h b/tools/testing=
/selftests/cgroup/lib/include/cgroup_util.h
> similarity index 99%
> rename from tools/testing/selftests/cgroup/cgroup_util.h
> rename to tools/testing/selftests/cgroup/lib/include/cgroup_util.h
> index 19b131ee77072..7a0441e5eb296 100644
> --- a/tools/testing/selftests/cgroup/cgroup_util.h
> +++ b/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
> @@ -2,9 +2,9 @@
>  #include <stdbool.h>
>  #include <stdlib.h>
>
> -#include "../kselftest.h"
> -
> +#ifndef PAGE_SIZE
>  #define PAGE_SIZE 4096
> +#endif
>
>  #define MB(x) (x << 20)
>
> diff --git a/tools/testing/selftests/cgroup/lib/libcgroup.mk b/tools/test=
ing/selftests/cgroup/lib/libcgroup.mk
> new file mode 100644
> index 0000000000000..12323041a5ce6
> --- /dev/null
> +++ b/tools/testing/selftests/cgroup/lib/libcgroup.mk
> @@ -0,0 +1,14 @@
> +CGROUP_DIR :=3D $(selfdir)/cgroup
> +
> +LIBCGROUP_C :=3D lib/cgroup_util.c
> +
> +LIBCGROUP_O :=3D $(patsubst %.c, $(OUTPUT)/%.o, $(LIBCGROUP_C))
> +
> +CFLAGS +=3D -I$(CGROUP_DIR)/lib/include
> +
> +EXTRA_HDRS :=3D $(selfdir)/clone3/clone3_selftests.h
> +
> +$(LIBCGROUP_O): $(OUTPUT)/%.o : $(CGROUP_DIR)/%.c $(EXTRA_HDRS)
> +       $(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
> +
> +EXTRA_CLEAN +=3D $(LIBCGROUP_O)
> --
> 2.49.0.472.ge94155a9ec-goog

This works since KVM selftests already have a lib/ directory. But if
it didn't, the KVM selftests would fail to link against
lib/cgroup_util.o. To future proof against using this from other
selftests (or if someone were to add a subdirectory to
selftests/cgroup/lib), you can add a rule to create any missing
directories in the $(OUTPUT) path:

LIBCGROUP_O_DIRS :=3D $(shell dirname $(LIBCGROUP_O) | uniq)

$(LIBCGROUP_O_DIRS):
        mkdir -p $@

Then add $(LIBCGROUP_O_DIRS) as a dependency of $(LIBCGROUP_O).

