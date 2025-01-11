Return-Path: <kvm+bounces-35146-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DA9D7A09F3A
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 01:22:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EA1323A15D0
	for <lists+kvm@lfdr.de>; Sat, 11 Jan 2025 00:22:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB186946C;
	Sat, 11 Jan 2025 00:21:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="w9St+MBq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214B9EAE7
	for <kvm@vger.kernel.org>; Sat, 11 Jan 2025 00:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736554911; cv=none; b=CXLIsA08c/tW8EBzkHS9ewojp90+EaNdci67cRU1DNXVv8U9yHgKMTi5+8i//xNOGuwuFDhLETwUtza9KQyxEQoy59vpLvjj+1e/kfX9qdF1DR0Sev80XqvrMdmT3OkOIlfH8BAsk5FYaDeENv7d8ZtTo+jMdFq1yxrJpP/0tAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736554911; c=relaxed/simple;
	bh=Ev3gK+PEe43PeiF2FrESC5fKXliU3cvrIQ9z5coecPE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O8uzMmcvWlhamrhjx207fti4hrWQT/xui35xlVoqhnLkneWwhplmvDsX+ag5AnL0REsO4mhCg+HMwZeLxVMsi6qjA0/mhVSZgfn/ER1X7+MJaQ5EcvpRPkUbcecGfwbgJvOns7Hhb/NE5wOymF6njbgsNdFI2KxkOx+MnmsiB8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=w9St+MBq; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-467a1ee7ff2so24046841cf.0
        for <kvm@vger.kernel.org>; Fri, 10 Jan 2025 16:21:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736554909; x=1737159709; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y5s00YaBLH9Arr1+uG71alYxQA7rl6a1ZUQm7Y4z3yM=;
        b=w9St+MBqtVhnjLl2oHWRumNrBsRDByukImoWm1cx7238sVZV365iZTHEjZ+CTM49so
         uE3o/w7c/YfCxMVU3n3ZyHfq3k5YDQPkoxsv3Co9/ukMKlJv5ny70p0C4b90dasB2P0C
         b+TXNHnLJKVigZ7Gn/zTXt9yjfQ2JsssDAxbQqUr9UQsK0UHLag3JEnr8YIyTutdh0tL
         Rwy5ODAk/PfIsXjpdx9iU7vpdOlDhIPdfv+9BhtF7xeTf5w12q6RlbrSx4AQ6G3rRrTG
         JLFVAAvXgEkY9+1NTWYGfwP4ng62lNpADUhi1QrvC1R+GXgd3SunCkSNrQstEPqFy8Be
         u5vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736554909; x=1737159709;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y5s00YaBLH9Arr1+uG71alYxQA7rl6a1ZUQm7Y4z3yM=;
        b=HsDV8/t/1Dq1eiqI2Ntawxg4nFtsQ9+WXjZc5Ip21+cuGWO6kS8nuuHAYi4Qi3JDh8
         VzqMbrt0Sjd48+1j7v9989kqAfbv9XjtQh0sPn7Q0ugzOXepePUPNL2fY8+edGxzgdSU
         imUCmF1nfdFegIj26dEjunjuIE/9mm67kSlJqy3lIjAYqYjW5rMmLW055GngE5MDwcAG
         iTNre9WYfR+PA7uROH/XZrML3wJDnhUHmLrSiPhFzC5BC2eaRQpkM51AnODK6zZcx+hr
         knN4VlN4TQgQ5zFpVgjm2gfB3jv+fd1Bw6r7EyDI3hKcQtICbRigVSBHzFuJxazIPI9h
         Ca4A==
X-Forwarded-Encrypted: i=1; AJvYcCVpnruCBKFT/QWvdLcHHSGGTXGl3WaFBQKFvHBWwBXKLzsoEkZWIfLJsofb6PGIJwZ0sZI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxqce0gYJjiPsNvChbIr7Sq5F3LboqRhsi2TEygjUft5u4L/Xld
	7ObL3G1ibaYWfd89pKVHr97COWe+6bhjOC8kVYC8aUxpBYzt5i1wYwXb+JIW2F0ZjJvhwbyKdpx
	GjSe0IbjzX+tSDJKUD56fO+2H+hmsfs/O/oKTI7O79L4i6zyCx4Wc
X-Gm-Gg: ASbGncv8S9PRuS2BOjJwOIkIQ14qkLTBB10kX5ZXFSKheAdlDVhvow2DV94iANLk0sn
	P6PFNt0ElH0WyECfE958RILUdUVfTPzlmEy4=
X-Google-Smtp-Source: AGHT+IH3/FAK2UFAbE2tW1kzbC8DeT8NmfEDt12xppqZTjSsg1dgXfapvCIfLqHs6Ab7Q7MBamO8UV5fQMoh+GWPJfk=
X-Received: by 2002:ac8:5a54:0:b0:467:45b7:c49f with SMTP id
 d75a77b69052e-46c7108748cmr183145671cf.40.1736554908865; Fri, 10 Jan 2025
 16:21:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241105184333.2305744-1-jthoughton@google.com> <20241105184333.2305744-12-jthoughton@google.com>
In-Reply-To: <20241105184333.2305744-12-jthoughton@google.com>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Fri, 10 Jan 2025 16:21:12 -0800
X-Gm-Features: AbW1kvZpluToK0v4cbng-dMqjoztxCnVztAH1M0X20kkdi6Xd74KH-Ep0j8ma4g
Message-ID: <CAJD7tkbY7pCfVTaGVO_jkLz2C8cFie7HW=XbHxWVsLNxF+SaDg@mail.gmail.com>
Subject: Re: [PATCH v8 11/11] KVM: selftests: Add multi-gen LRU aging to access_tracking_perf_test
To: James Houghton <jthoughton@google.com>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 5, 2024 at 10:49=E2=80=AFAM James Houghton <jthoughton@google.c=
om> wrote:
>
> This test now has two modes of operation:
> 1. (default) To check how much vCPU performance was affected by access
>              tracking (previously existed, now supports MGLRU aging).
> 2. (-p) To also benchmark how fast MGLRU can do aging while vCPUs are
>         faulting in memory.
>
> Mode (1) also serves as a way to verify that aging is working properly
> for pages only accessed by KVM.  It will fail if one does not have the
> 0x8 lru_gen feature bit.
>
> To support MGLRU, the test creates a memory cgroup, moves itself into
> it, then uses the lru_gen debugfs output to track memory in that cgroup.
> The logic to parse the lru_gen debugfs output has been put into
> selftests/kvm/lib/lru_gen_util.c.
>
> Co-developed-by: Axel Rasmussen <axelrasmussen@google.com>
> Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
> Signed-off-by: James Houghton <jthoughton@google.com>
> ---
>  tools/testing/selftests/kvm/Makefile          |   1 +
>  .../selftests/kvm/access_tracking_perf_test.c | 366 ++++++++++++++--
>  .../selftests/kvm/include/lru_gen_util.h      |  55 +++
>  .../testing/selftests/kvm/lib/lru_gen_util.c  | 391 ++++++++++++++++++
>  4 files changed, 783 insertions(+), 30 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/include/lru_gen_util.h
>  create mode 100644 tools/testing/selftests/kvm/lib/lru_gen_util.c
>
> diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftes=
ts/kvm/Makefile
> index f186888f0e00..542548e6e8ba 100644
> --- a/tools/testing/selftests/kvm/Makefile
> +++ b/tools/testing/selftests/kvm/Makefile
> @@ -22,6 +22,7 @@ LIBKVM +=3D lib/elf.c
>  LIBKVM +=3D lib/guest_modes.c
>  LIBKVM +=3D lib/io.c
>  LIBKVM +=3D lib/kvm_util.c
> +LIBKVM +=3D lib/lru_gen_util.c
>  LIBKVM +=3D lib/memstress.c
>  LIBKVM +=3D lib/guest_sprintf.c
>  LIBKVM +=3D lib/rbtree.c
> diff --git a/tools/testing/selftests/kvm/access_tracking_perf_test.c b/to=
ols/testing/selftests/kvm/access_tracking_perf_test.c
> index 3c7defd34f56..8d6c2ce4b98a 100644
> --- a/tools/testing/selftests/kvm/access_tracking_perf_test.c
> +++ b/tools/testing/selftests/kvm/access_tracking_perf_test.c
> @@ -38,6 +38,7 @@
>  #include <inttypes.h>
>  #include <limits.h>
>  #include <pthread.h>
> +#include <stdio.h>
>  #include <sys/mman.h>
>  #include <sys/types.h>
>  #include <sys/stat.h>
> @@ -47,6 +48,19 @@
>  #include "memstress.h"
>  #include "guest_modes.h"
>  #include "processor.h"
> +#include "lru_gen_util.h"
> +
> +static const char *TEST_MEMCG_NAME =3D "access_tracking_perf_test";
> +static const int LRU_GEN_ENABLED =3D 0x1;
> +static const int LRU_GEN_MM_WALK =3D 0x2;
> +static const char *CGROUP_PROCS =3D "cgroup.procs";
> +/*
> + * If using MGLRU, this test assumes a cgroup v2 or cgroup v1 memory hie=
rarchy
> + * is mounted at cgroup_root.
> + *
> + * Can be changed with -r.
> + */
> +static const char *cgroup_root =3D "/sys/fs/cgroup";
>
>  /* Global variable used to synchronize all of the vCPU threads. */
>  static int iteration;
> @@ -62,6 +76,9 @@ static enum {
>  /* The iteration that was last completed by each vCPU. */
>  static int vcpu_last_completed_iteration[KVM_MAX_VCPUS];
>
> +/* The time at which the last iteration was completed */
> +static struct timespec vcpu_last_completed_time[KVM_MAX_VCPUS];
> +
>  /* Whether to overlap the regions of memory vCPUs access. */
>  static bool overlap_memory_access;
>
> @@ -74,6 +91,12 @@ struct test_params {
>
>         /* The number of vCPUs to create in the VM. */
>         int nr_vcpus;
> +
> +       /* Whether to use lru_gen aging instead of idle page tracking. */
> +       bool lru_gen;
> +
> +       /* Whether to test the performance of aging itself. */
> +       bool benchmark_lru_gen;
>  };
>
>  static uint64_t pread_uint64(int fd, const char *filename, uint64_t inde=
x)
> @@ -89,6 +112,50 @@ static uint64_t pread_uint64(int fd, const char *file=
name, uint64_t index)
>
>  }
>
> +static void write_file_long(const char *path, long v)
> +{
> +       FILE *f;
> +
> +       f =3D fopen(path, "w");
> +       TEST_ASSERT(f, "fopen(%s) failed", path);
> +       TEST_ASSERT(fprintf(f, "%ld\n", v) > 0,
> +                   "fprintf to %s failed", path);
> +       TEST_ASSERT(!fclose(f), "fclose(%s) failed", path);
> +}
> +
> +static char *path_join(const char *parent, const char *child)
> +{
> +       char *out =3D NULL;
> +
> +       return asprintf(&out, "%s/%s", parent, child) >=3D 0 ? out : NULL=
;
> +}
> +
> +static char *memcg_path(const char *memcg)
> +{
> +       return path_join(cgroup_root, memcg);
> +}
> +
> +static char *memcg_file_path(const char *memcg, const char *file)
> +{
> +       char *mp =3D memcg_path(memcg);
> +       char *fp;
> +
> +       if (!mp)
> +               return NULL;
> +       fp =3D path_join(mp, file);
> +       free(mp);
> +       return fp;
> +}
> +
> +static void move_to_memcg(const char *memcg, pid_t pid)
> +{
> +       char *procs =3D memcg_file_path(memcg, CGROUP_PROCS);
> +
> +       TEST_ASSERT(procs, "Failed to construct cgroup.procs path");
> +       write_file_long(procs, pid);
> +       free(procs);
> +}
> +

From the peanut gallery, I suspect you can make use of the cgroup
helpers in tools/testing/selftests/cgroup/cgroup_util.h. There are
helpers to locate the cgroup root, create cgroups, enter cgroups, etc.
You can find example uses specifically for memory cgroups (memcgs) in
tools/testing/selftests/cgroup/test_memcontrol.c.

