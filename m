Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA257347F4
	for <lists+kvm@lfdr.de>; Sun, 18 Jun 2023 21:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbjFRTTy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 18 Jun 2023 15:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjFRTTx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 18 Jun 2023 15:19:53 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC639F5
        for <kvm@vger.kernel.org>; Sun, 18 Jun 2023 12:19:51 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id d75a77b69052e-3fddc620055so202251cf.1
        for <kvm@vger.kernel.org>; Sun, 18 Jun 2023 12:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687115991; x=1689707991;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JbR6FYiZlzxET1aZbxa1LnPa25BlJwTh4qhaLJ4bvzg=;
        b=eeTeUO735vurVqYffUSvtO4InMdD7ecrFouGxTvZhYEKJAFj+iNmhaN9tu2ONEh2zq
         89mW0ayvjTPwrfBsoKUi9fd5fr9ze0ICHF7BxV4woHO5JqvPZRPKLY2xrrn26G+NJH0x
         DUxE98voVWezGuxg9OUVAFu8rupSLoeVL/QnMQxAmb/k40sScPQjWMg9w2/P2DgTkMb8
         SHdvwblgqJJHWx+7iPLuQxgNy100g4QEuXp4/vYMvNUabSEKRH66I5WIJ93nZtC1CnKk
         7RYEIUbSVvCf3kGwuVSB8mzNNo/aPYY38t591pX2WAN2fS9n4tJiTPSz8cqRXqfOVBu7
         hOsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687115991; x=1689707991;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JbR6FYiZlzxET1aZbxa1LnPa25BlJwTh4qhaLJ4bvzg=;
        b=QPpLXgJpYEBJp0HXKnRiHo8FjDHRiTEuaNBPYxxcqKs0Bt7fiK/7OKt4AiPIl1UPc0
         yiRop8s1ru6N20LHxzjt7+kt8FrhIXPgGZAU8HlIoa0i+qFkxaJpc2puaXU5nfCInJjh
         BNi4E/Fr1oylEhXkNqyBPEFqSfqqqogAz8bMHE5Nel6TNZ7Fv2KkpkmrUDngQDOll15r
         KtAFr2k7MoEdoUtF4rEfXofZBPMRk2FezfBrm1iVchB/9LPerumb3inB62R0cLg8anFL
         41YYnGIRW7y9lOkvedBvCWhOLh4aRUgi96YOeo2DuYDfeJnAwMIrSKdfffo+4PlyAn6W
         4MiQ==
X-Gm-Message-State: AC+VfDy1CtgSjuxsJMPghJhgR4iN4BjpJrPKGc0FLf23KJLTxRfVYggR
        YrasK12EzK3rZar6EoT50s5b81HHJAdAn78FTTwUDg==
X-Google-Smtp-Source: ACHHUZ4amVIobuPycpFLC2fHeYKXTl1nn9tY9t3tZcZ8KQLrci6OwIYFpzYKhnwEJ6EGI3MQyCTT/zihLmvQ2yroRTk=
X-Received: by 2002:a05:622a:589:b0:3ed:210b:e698 with SMTP id
 c9-20020a05622a058900b003ed210be698mr754708qtb.7.1687115990926; Sun, 18 Jun
 2023 12:19:50 -0700 (PDT)
MIME-Version: 1.0
References: <20230526234435.662652-1-yuzhao@google.com> <20230609005943.43041-1-yuzhao@google.com>
In-Reply-To: <20230609005943.43041-1-yuzhao@google.com>
From:   Yu Zhao <yuzhao@google.com>
Date:   Sun, 18 Jun 2023 13:19:14 -0600
Message-ID: <CAOUHufZm9gDxRoVCc+hrZeyr=n9s-sa0i1DDGkWq2N_N9Sznmw@mail.gmail.com>
Subject: Re: kvm/x86: multichase benchmark
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
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 8, 2023 at 6:59=E2=80=AFPM Yu Zhao <yuzhao@google.com> wrote:
>
> TLDR
> =3D=3D=3D=3D
> Multichase in 64 microVMs achieved 6% more total samples (in ~4 hours) af=
ter this patchset [1].
>
> Hardware
> =3D=3D=3D=3D=3D=3D=3D=3D
> HOST $ lscpu
> Architecture:            x86_64
>   CPU op-mode(s):        32-bit, 64-bit
>   Address sizes:         43 bits physical, 48 bits virtual
>   Byte Order:            Little Endian
> CPU(s):                  128
>   On-line CPU(s) list:   0-127
> Vendor ID:               AuthenticAMD
>   Model name:            AMD Ryzen Threadripper PRO 3995WX 64-Cores
>     CPU family:          23
>     Model:               49
>     Thread(s) per core:  2
>     Core(s) per socket:  64
>     Socket(s):           1
>     Stepping:            0
>     Frequency boost:     disabled
>     CPU max MHz:         4308.3979
>     CPU min MHz:         2200.0000
>     BogoMIPS:            5390.20
>     Flags:               fpu vme de pse tsc msr pae mce cx8 apic sep mtrr=
 pge mca cmov pat pse36 clflush mmx fxsr sse sse2
>                          ...
> Virtualization features:
>   Virtualization:        AMD-V
> Caches (sum of all):
>   L1d:                   2 MiB (64 instances)
>   L1i:                   2 MiB (64 instances)
>   L2:                    32 MiB (64 instances)
>   L3:                    256 MiB (16 instances)
> NUMA:
>   NUMA node(s):          1
>   NUMA node0 CPU(s):     0-127
> Vulnerabilities:
>   Itlb multihit:         Not affected
>   L1tf:                  Not affected
>   Mds:                   Not affected
>   Meltdown:              Not affected
>   Mmio stale data:       Not affected
>   Retbleed:              Mitigation; untrained return thunk; SMT enabled =
with STIBP protection
>   Spec store bypass:     Mitigation; Speculative Store Bypass disabled vi=
a prctl
>   Spectre v1:            Mitigation; usercopy/swapgs barriers and __user =
pointer sanitization
>   Spectre v2:            Mitigation; Retpolines, IBPB conditional, STIBP =
always-on, RSB filling, PBRSB-eIBRS Not affected
>   Srbds:                 Not affected
>   Tsx async abort:       Not affected
>
> HOST $ numactl -H
> available: 1 nodes (0)
> node 0 cpus: 0-127
> node 0 size: 257542 MB
> node 0 free: 224855 MB
> node distances:
> node   0
>   0:  10
>
> HOST $ cat /sys/class/nvme/nvme0/model
> INTEL SSDPF21Q800GB
>
> HOST $ cat /sys/class/nvme/nvme0/numa_node
> 0
>
> Software
> =3D=3D=3D=3D=3D=3D=3D=3D
> HOST $ cat /etc/lsb-release
> DISTRIB_ID=3DUbuntu
> DISTRIB_RELEASE=3D22.04
> DISTRIB_CODENAME=3Djammy
> DISTRIB_DESCRIPTION=3D"Ubuntu 22.04.1 LTS"
>
> HOST $ uname -a
> Linux x86 6.4.0-rc5+ #1 SMP PREEMPT_DYNAMIC Wed Jun  7 22:17:47 UTC 2023 =
x86_64 x86_64 x86_64 GNU/Linux
>
> HOST $ cat /proc/swaps
> Filename          Type         Size         Used    Priority
> /dev/nvme0n1p2    partition    466838356    0       -2
>
> HOST $ cat /sys/kernel/mm/lru_gen/enabled
> 0x000f
>
> HOST $ cat /sys/kernel/mm/transparent_hugepage/enabled
> always madvise [never]
>
> HOST $ cat /sys/kernel/mm/transparent_hugepage/defrag
> always defer defer+madvise madvise [never]
>
> Procedure
> =3D=3D=3D=3D=3D=3D=3D=3D=3D
> HOST $ git clone https://github.com/google/multichase
>
> HOST $ <Build multichase>
> HOST $ <Unpack /boot/initrd.img into ./initrd/>
>
> HOST $ cp multichase/multichase ./initrd/bin/
> HOST $ sed -i \
>     "/^maybe_break top$/i multichase -t 2 -m 4g -n 28800; poweroff" \

I was reminded that I missed one parameter above, i.e.,

"/^maybe_break top$/i multichase -N -t 2 -m 4g -n 28800; poweroff" \
                                 ^^

>     ./initrd/init
>
> HOST $ <Pack ./initrd/ into ./initrd.img>
>
> HOST $ cat run_microvms.sh
> memcgs=3D64
>
> run() {
>     path=3D/sys/fs/cgroup/memcg$1
>
>     mkdir $path
>     echo $BASHPID >$path/cgroup.procs

And one line here:

echo 4000m >$path/memory.min # or the largest size that doesn't cause OOM k=
ills

>     qemu-system-x86_64 -M microvm,accel=3Dkvm -cpu host -smp 2 -m 6g \
>         -nographic -kernel /boot/vmlinuz -initrd ./initrd.img \
>         -append "console=3DttyS0 loglevel=3D0"
> }
>
> for ((memcg =3D 0; memcg < $memcgs; memcg++)); do
>     run $memcg &
> done
>
> wait
>
> Results
> =3D=3D=3D=3D=3D=3D=3D
>                  Before [1]    After    Change
> ----------------------------------------------
> Total samples    6824          7237     +6%
>
> Notes
> =3D=3D=3D=3D=3D
> [1] "mm: rmap: Don't flush TLB after checking PTE young for page
>     reference" was included so that the comparison is apples to
>     Apples.
>     https://lore.kernel.org/r/20220706112041.3831-1-21cnbao@gmail.com/
