Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35992728CBA
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 03:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235551AbjFIBAH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 21:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233824AbjFIA7r (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 20:59:47 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EAF8269F
        for <kvm@vger.kernel.org>; Thu,  8 Jun 2023 17:59:43 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-ba87bd29e9dso1724482276.3
        for <kvm@vger.kernel.org>; Thu, 08 Jun 2023 17:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686272383; x=1688864383;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kfRq4neZrPjb9Lck7talXrCmxVTayuyWN8AeTYnUB40=;
        b=FMN3dhDuy89W3YL34iGrOcxlPjg1bzMkLLXo1TdyO66RGSvbHlps7gdvHr44ss3LGk
         MR0VFD1DRCFTNC9tyqK5ReMEOiPx2JNiCbTUTyUv9FMGeK9nCNoAU6WnXWYbBC+Dw27V
         niwud/7XN7pCGjqFT4B3VS+EBw+uLus4pO0EQ6k6SszjrU1zFcD9yQh/qzHLrmZknfvX
         XuK4cXbAzi1gsEYKdbrLfMfylLB6JTl2vYXAwWR55yMmpFjT1Lojk1XODC7sstmSmHo4
         uXWebCC18fjzj/uapeQiZlzXqVxfdSytOTcShko5dqCAeC6bbLhPv2RLA/d/FJo+pzzy
         govw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686272383; x=1688864383;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kfRq4neZrPjb9Lck7talXrCmxVTayuyWN8AeTYnUB40=;
        b=JU/borAVMNcYRMJwehnQPf13+I4Cej4AcM/ZPfZCQIvHGS/VJASro7UX3eo2UR/dTG
         tbDkUol822dPdzEUvo61uvrzQsnH7xrhxWsVsyve2U3uSgd+Lpcln8Ji7b5yG4N1kDM5
         s94phqoF3Y473ZG4tTZ4sYtBHEVf8Pby1l4ICsBEzLtxY1n7GBFjOPovlYy2zvu7SF40
         J5QrOBAJrLsHNY52qFjfb8bvK+zRGvDOKBvxWGIKt7lSLyCO/Wt0YP6qnr47uPzeHVS2
         6lIHscDQ6l+n76wXSxPXDFoCMJokCi46cFkGD1x4c7NBatHduOxnWLciB6qNsUbZE1pf
         9pqQ==
X-Gm-Message-State: AC+VfDyuxKyVuN4g/OnEMUHf8wRc1vzbVTBs0jPBEO3bWaG818kqEQfr
        YMmfJfQ3lNcr98H1KNcoLLdrL73l9zI=
X-Google-Smtp-Source: ACHHUZ6QOfrw0l3bdpvvlmXUNnamszuXXqEgiHjhlXZ1bthx0t+lBEyPW/rr7RnEuOk5SiS3J1yRldpoYHg=
X-Received: from yuzhao.bld.corp.google.com ([2620:15c:183:200:f582:c9e5:6c95:4461])
 (user=yuzhao job=sendgmr) by 2002:a5b:784:0:b0:bad:99d:f087 with SMTP id
 b4-20020a5b0784000000b00bad099df087mr697256ybq.6.1686272382836; Thu, 08 Jun
 2023 17:59:42 -0700 (PDT)
Date:   Thu,  8 Jun 2023 18:59:39 -0600
In-Reply-To: <20230526234435.662652-1-yuzhao@google.com>
Message-Id: <20230609005940.42722-1-yuzhao@google.com>
Mime-Version: 1.0
References: <20230526234435.662652-1-yuzhao@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Subject: kvm/powerpc: memcached benchmark
From:   Yu Zhao <yuzhao@google.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alistair Popple <apopple@nvidia.com>,
        Anup Patel <anup@brainfault.org>,
        Ben Gardon <bgardon@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Gaosheng Cui <cuigaosheng1@huawei.com>,
        Gavin Shan <gshan@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        James Morse <james.morse@arm.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jonathan Corbet <corbet@lwn.net>,
        Marc Zyngier <maz@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michael Larabel <michael@michaellarabel.com>,
        Mike Rapoport <rppt@kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Paul Mackerras <paulus@ozlabs.org>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thomas Huth <thuth@redhat.com>, Will Deacon <will@kernel.org>,
        Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
        linux-trace-kernel@vger.kernel.org, x86@kernel.org,
        linux-mm@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TLDR
====
Memcached achieved 10% more operations per second (in ~4 hours) after this patchset [1].

Hardware
========
HOST $ lscpu
Architecture:          ppc64le
  Byte Order:          Little Endian
CPU(s):                184
  On-line CPU(s) list: 0-183
Model name:            POWER9 (raw), altivec supported
  Model:               2.2 (pvr 004e 1202)
  Thread(s) per core:  4
  Core(s) per socket:  23
  Socket(s):           2
  CPU max MHz:         3000.0000
  CPU min MHz:         2300.0000
Caches (sum of all):
  L1d:                 1.4 MiB (46 instances)
  L1i:                 1.4 MiB (46 instances)
  L2:                  12 MiB (24 instances)
  L3:                  240 MiB (24 instances)
NUMA:
  NUMA node(s):        2
  NUMA node0 CPU(s):   0-91
  NUMA node1 CPU(s):   92-183
Vulnerabilities:
  Itlb multihit:       Not affected
  L1tf:                Mitigation; RFI Flush, L1D private per thread
  Mds:                 Not affected
  Meltdown:            Mitigation; RFI Flush, L1D private per thread
  Mmio stale data:     Not affected
  Retbleed:            Not affected
  Spec store bypass:   Mitigation; Kernel entry/exit barrier (eieio)
  Spectre v1:          Mitigation; __user pointer sanitization, ori31 speculation barrier enabled
  Spectre v2:          Mitigation; Indirect branch serialisation (kernel only), Indirect branch cache disabled, Software link stack flush
  Srbds:               Not affected
  Tsx async abort:     Not affected

HOST $ numactl -H
available: 2 nodes (0-1)
node 0 cpus: 0-91
node 0 size: 261659 MB
node 0 free: 259152 MB
node 1 cpus: 92-183
node 1 size: 261713 MB
node 1 free: 261076 MB
node distances:
node   0   1
  0:  10  40
  1:  40  10

HOST $ cat /sys/class/nvme/nvme0/model
INTEL SSDPF21Q800GB

HOST $ cat /sys/class/nvme/nvme0/numa_node
0

Software
========
HOST $ cat /etc/lsb-release
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=22.04
DISTRIB_CODENAME=jammy
DISTRIB_DESCRIPTION="Ubuntu 22.04 LTS"

HOST $ uname -a
Linux ppc 6.3.0 #1 SMP Sun Jun  4 18:26:37 UTC 2023 ppc64le ppc64le ppc64le GNU/Linux

HOST $ cat /proc/swaps
Filename          Type         Size         Used    Priority
/dev/nvme0n1p2    partition	    466838272    0       -2

HOST $ cat /sys/kernel/mm/lru_gen/enabled
0x0009

HOST $ cat /sys/kernel/mm/transparent_hugepage/enabled
always madvise [never]

HOST $ cat /sys/kernel/mm/transparent_hugepage/defrag
always defer defer+madvise madvise [never]

HOST $ qemu-system-ppc64 --version
QEMU emulator version 6.2.0 (Debian 1:6.2+dfsg-2ubuntu6.6)
Copyright (c) 2003-2021 Fabrice Bellard and the QEMU Project developers

GUEST $ cat /etc/lsb-release
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=22.04
DISTRIB_CODENAME=jammy
DISTRIB_DESCRIPTION="Ubuntu 22.04.1 LTS"

GUEST $ cat /etc/memcached.conf
...
-t 92
-m 262144
-B binary
-s /var/run/memcached/memcached.sock
-a 0766

GUEST $ memtier_benchmark -v
memtier_benchmark 1.4.0
Copyright (C) 2011-2022 Redis Ltd.
This is free software.  You may redistribute copies of it under the terms of
the GNU General Public License <http://www.gnu.org/licenses/gpl.html>.
There is NO WARRANTY, to the extent permitted by law.

Procedure
=========
HOST $ sudo numactl -N 0 -m 0 qemu-system-ppc64 \
    -M pseries,accel=kvm,kvm-type=HV -cpu host -smp 92 -m 270g
    -nographic -nic user \
    -drive if=virtio,format=raw,file=/dev/nvme0n1p1

GUEST $ memtier_benchmark -S /var/run/memcached/memcached.sock \
    -P memcache_binary -c 1 -t 92 --pipeline 1 --ratio 1:0 \
    --key-minimum=1 --key-maximum=120000000 --key-pattern=P:P \
    -n allkeys -d 2000

GUEST $ memtier_benchmark -S /var/run/memcached/memcached.sock \
    -P memcache_binary -c 1 -t 92 --pipeline 1 --ratio 0:1 \
    --key-minimum=1 --key-maximum=120000000 --key-pattern=R:R \
    -n allkeys --randomize --distinct-client-seed

Results
=======
                Before [1]    After        Change
-------------------------------------------------
Ops/sec         721586.10     800210.12    +10%
Avg. Latency    0.12546       0.11260      -10%
p50 Latency     0.08700       0.08700      N/C
p99 Latency     0.28700       0.24700      -13%

Notes
=====
[1] "mm: rmap: Don't flush TLB after checking PTE young for page
    reference" was included so that the comparison is apples to
    Apples.
    https://lore.kernel.org/r/20220706112041.3831-1-21cnbao@gmail.com/
