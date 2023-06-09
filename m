Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32408728CB7
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 03:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230011AbjFIBAJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 21:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234429AbjFIA7s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 20:59:48 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F16F270F
        for <kvm@vger.kernel.org>; Thu,  8 Jun 2023 17:59:46 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-565a33c35b1so16338337b3.0
        for <kvm@vger.kernel.org>; Thu, 08 Jun 2023 17:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686272385; x=1688864385;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ddXgsJixIEMqGA5wc+jEsC/2PCjKU+k92CAoSHzENIQ=;
        b=2gQvv8Elto4XccdRwaHPDqIj9nLGBVTBNmb86njoPvqhsd0tjtN6HCelUzSemN7wyY
         71LauLyB1lnldzxzQTkfe6nQZecdjOxXtr/4StosXGI1CrlQDTJck4wzTXo8dKjjpnV4
         D20udOm2zFIzHEQ51hLEe5UarHwCpaC6lXinX2YwMS98bkU6dZgz2pBUAz+mzsFIorM8
         xdmbpgNfTyxvCAzBTy+SieKUu3Kw2LKLwSnetOswWodGDZgbdEkzkIsg0JKEhFrOZU8p
         T4WBKVoS8Yje74KiF7RZvIKnuSmaC0kPLDwvUqdU+Fm/Ozb38xa28j2ttI0hrtP0j54l
         z55w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686272385; x=1688864385;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ddXgsJixIEMqGA5wc+jEsC/2PCjKU+k92CAoSHzENIQ=;
        b=VJFE0zEyD6akb7t7gmJ09zDKg6jRTNvFvsvDvUbEZ0v3wy3xmRRqL1s1i7n6bRrIv5
         /6NEwOIklK5xnK42TAOMsf/3tCg6RPi3PThvLETc15VRJqHUR0fovefgToIJqwM3RSDv
         iNpSwo0AvloJQHpOAUdwGlsf4qegfH4Ar3xcMIyZZ/XuTBDLv9ijlJObBBqrrHXZNS24
         2syClOYFkIYhqyZ6Felke+CedQr7lZBR2kZKMqWr5XgdMWmMDKpVReAE3TIizDllEhyM
         tdKKVdw/DxGnPpiMQpLiT8ztBhefWielr0iwzHgtchl8zpmd+KuNLw04LIO7ya9nyCXQ
         Qsfg==
X-Gm-Message-State: AC+VfDwTnsuMeZFDpqDUBkwHg2z3ODQzecqfWNPX4MMzBr1Zg9b8Fe1B
        5BPR0tAAZ64WFjCv36SALli07yhZoUY=
X-Google-Smtp-Source: ACHHUZ48Ctq25/jOWo2nOrUYiTkPu+9cUUGT9KZFEWhgs36Jat11A7iC8UGGnM5T4c2tHVmOSHQ7ebLSwlw=
X-Received: from yuzhao.bld.corp.google.com ([2620:15c:183:200:f582:c9e5:6c95:4461])
 (user=yuzhao job=sendgmr) by 2002:a05:690c:702:b0:565:ebd4:304d with SMTP id
 bs2-20020a05690c070200b00565ebd4304dmr731769ywb.4.1686272385574; Thu, 08 Jun
 2023 17:59:45 -0700 (PDT)
Date:   Thu,  8 Jun 2023 18:59:43 -0600
In-Reply-To: <20230526234435.662652-1-yuzhao@google.com>
Message-Id: <20230609005943.43041-1-yuzhao@google.com>
Mime-Version: 1.0
References: <20230526234435.662652-1-yuzhao@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Subject: kvm/x86: multichase benchmark
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TLDR
====
Multichase in 64 microVMs achieved 6% more total samples (in ~4 hours) after this patchset [1].

Hardware
========
HOST $ lscpu
Architecture:            x86_64
  CPU op-mode(s):        32-bit, 64-bit
  Address sizes:         43 bits physical, 48 bits virtual
  Byte Order:            Little Endian
CPU(s):                  128
  On-line CPU(s) list:   0-127
Vendor ID:               AuthenticAMD
  Model name:            AMD Ryzen Threadripper PRO 3995WX 64-Cores
    CPU family:          23
    Model:               49
    Thread(s) per core:  2
    Core(s) per socket:  64
    Socket(s):           1
    Stepping:            0
    Frequency boost:     disabled
    CPU max MHz:         4308.3979
    CPU min MHz:         2200.0000
    BogoMIPS:            5390.20
    Flags:               fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2
                         ...
Virtualization features:
  Virtualization:        AMD-V
Caches (sum of all):
  L1d:                   2 MiB (64 instances)
  L1i:                   2 MiB (64 instances)
  L2:                    32 MiB (64 instances)
  L3:                    256 MiB (16 instances)
NUMA:
  NUMA node(s):          1
  NUMA node0 CPU(s):     0-127
Vulnerabilities:
  Itlb multihit:         Not affected
  L1tf:                  Not affected
  Mds:                   Not affected
  Meltdown:              Not affected
  Mmio stale data:       Not affected
  Retbleed:              Mitigation; untrained return thunk; SMT enabled with STIBP protection
  Spec store bypass:     Mitigation; Speculative Store Bypass disabled via prctl
  Spectre v1:            Mitigation; usercopy/swapgs barriers and __user pointer sanitization
  Spectre v2:            Mitigation; Retpolines, IBPB conditional, STIBP always-on, RSB filling, PBRSB-eIBRS Not affected
  Srbds:                 Not affected
  Tsx async abort:       Not affected

HOST $ numactl -H
available: 1 nodes (0)
node 0 cpus: 0-127
node 0 size: 257542 MB
node 0 free: 224855 MB
node distances:
node   0
  0:  10

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
DISTRIB_DESCRIPTION="Ubuntu 22.04.1 LTS"

HOST $ uname -a
Linux x86 6.4.0-rc5+ #1 SMP PREEMPT_DYNAMIC Wed Jun  7 22:17:47 UTC 2023 x86_64 x86_64 x86_64 GNU/Linux

HOST $ cat /proc/swaps
Filename          Type         Size         Used    Priority
/dev/nvme0n1p2    partition    466838356    0       -2

HOST $ cat /sys/kernel/mm/lru_gen/enabled
0x000f

HOST $ cat /sys/kernel/mm/transparent_hugepage/enabled
always madvise [never]

HOST $ cat /sys/kernel/mm/transparent_hugepage/defrag
always defer defer+madvise madvise [never]

Procedure
=========
HOST $ git clone https://github.com/google/multichase

HOST $ <Build multichase>
HOST $ <Unpack /boot/initrd.img into ./initrd/>

HOST $ cp multichase/multichase ./initrd/bin/
HOST $ sed -i \
    "/^maybe_break top$/i multichase -t 2 -m 4g -n 28800; poweroff" \
    ./initrd/init

HOST $ <Pack ./initrd/ into ./initrd.img>

HOST $ cat run_microvms.sh
memcgs=64

run() {
    path=/sys/fs/cgroup/memcg$1

    mkdir $path
    echo $BASHPID >$path/cgroup.procs

    qemu-system-x86_64 -M microvm,accel=kvm -cpu host -smp 2 -m 6g \
        -nographic -kernel /boot/vmlinuz -initrd ./initrd.img \
        -append "console=ttyS0 loglevel=0"
}

for ((memcg = 0; memcg < $memcgs; memcg++)); do
    run $memcg &
done

wait

Results
=======
                 Before [1]    After    Change
----------------------------------------------
Total samples    6824          7237     +6%

Notes
=====
[1] "mm: rmap: Don't flush TLB after checking PTE young for page
    reference" was included so that the comparison is apples to
    Apples.
    https://lore.kernel.org/r/20220706112041.3831-1-21cnbao@gmail.com/
