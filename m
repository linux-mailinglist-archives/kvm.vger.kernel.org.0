Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61E5B728CB6
	for <lists+kvm@lfdr.de>; Fri,  9 Jun 2023 02:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbjFIA7n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Jun 2023 20:59:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbjFIA7l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Jun 2023 20:59:41 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DCF61FDF
        for <kvm@vger.kernel.org>; Thu,  8 Jun 2023 17:59:40 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-561eb6c66f6so16449837b3.0
        for <kvm@vger.kernel.org>; Thu, 08 Jun 2023 17:59:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686272379; x=1688864379;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0D7F9pDbG9FXqs6+iQJrvOEyVDkJYxW5kzmn8NxTXSM=;
        b=BDzc1aMRHWXMiLk4E+pANQvv85EBP8Fbmqip6g4XnCghOWEy+T3hHMA98y7gu3MrzJ
         m9ZUmOHYqjH9lz2cLAdIslB62deMkVm5FAytrF1l0ADpuk18V34OtWN8S0hJyOMsYZKG
         DZ3FeQwAgU/HrpcxXBWW2H8tt/UuIX4ypLlLVKfqSh3rXART4r4Tw/QKjnEtg7JS8CHS
         CWcIW0q6hoRoggptEjKDZYq373BjG6IuT0/lhqlLaPYC66B04C52gE09wIc5hlW88owA
         Gr5feq82Y0tlKosId/vUE/V228jTsXcOxUsj2CaGmnAfl6wsi8uq3/SNbii3CwrF5QN8
         PobQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686272379; x=1688864379;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0D7F9pDbG9FXqs6+iQJrvOEyVDkJYxW5kzmn8NxTXSM=;
        b=PMuFh8jeIyJ1d8kkZltq53xwsoJ0iA+ZRk7Nomw6zxrtcfyvTKRmkhguqPNMWbmuIj
         kgTiIgCmLjEQzBuhpluah1Ybzm/4f+TqcHx2SU6E83+23DCOZmHN7jl+MvNFDn58bdtS
         8+etTKkSi5sP2IvQXOc9wzOIaGuYtVc95zYi23Vt2S1aW4E0XpIcLLoJ4FJ7qTP+IGjz
         wpMv20018v4YjmvDo3as5+WJ4rAQa7wgzHo1rukDMTgBPMMMHNgtKqeueMIvG55epYYD
         ILsj5OuPUKjvZVrPebnyb+GaYBKSDAZHmp0HU4dg4fuKjZD+uLnaafr/C+V96YdTONan
         Hv7Q==
X-Gm-Message-State: AC+VfDw/dRKgpSGFo87Bo6psf7U3nRbwoaNaU1vWTfcPF356ZiBFmgXL
        OU7PcVprwYWTHNv10uqkgOtXs/8s0mg=
X-Google-Smtp-Source: ACHHUZ4+oKNZvW2k4pUHaG+wjpqVYAXO5ZmY9/JryBcaWXlbxmXfyr05oUuxiW1jF2Vui38QPi/ByPbILxk=
X-Received: from yuzhao.bld.corp.google.com ([2620:15c:183:200:f582:c9e5:6c95:4461])
 (user=yuzhao job=sendgmr) by 2002:a81:ae60:0:b0:565:e712:422c with SMTP id
 g32-20020a81ae60000000b00565e712422cmr809562ywk.1.1686272379675; Thu, 08 Jun
 2023 17:59:39 -0700 (PDT)
Date:   Thu,  8 Jun 2023 18:59:35 -0600
In-Reply-To: <20230526234435.662652-1-yuzhao@google.com>
Message-Id: <20230609005935.42390-1-yuzhao@google.com>
Mime-Version: 1.0
References: <20230526234435.662652-1-yuzhao@google.com>
X-Mailer: git-send-email 2.41.0.162.gfafddb0af9-goog
Subject: kvm/arm64: Spark benchmark
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

TLDR
====
Apache Spark spent 12% less time sorting four billion random integers twenty times (in ~4 hours) after this patchset [1].

Hardware
========
HOST $ lscpu
Architecture:           aarch64
  CPU op-mode(s):       32-bit, 64-bit
  Byte Order:           Little Endian
CPU(s):                 128
  On-line CPU(s) list:  0-127
Vendor ID:              ARM
  Model name:           Neoverse-N1
    Model:              1
    Thread(s) per core: 1
    Core(s) per socket: 64
    Socket(s):          2
    Stepping:           r3p1
    Frequency boost:    disabled
    CPU max MHz:        2800.0000
    CPU min MHz:        1000.0000
    BogoMIPS:           50.00
    Flags:              fp asimd evtstrm aes pmull sha1 sha2 crc32 atomics fphp asimdhp cpuid asimdrdm lrcpc dcpop asimddp ssbs
Caches (sum of all):
  L1d:                  8 MiB (128 instances)
  L1i:                  8 MiB (128 instances)
  L2:                   128 MiB (128 instances)
NUMA:
  NUMA node(s):         2
  NUMA node0 CPU(s):    0-63
  NUMA node1 CPU(s):    64-127
Vulnerabilities:
  Itlb multihit:        Not affected
  L1tf:                 Not affected
  Mds:                  Not affected
  Meltdown:             Not affected
  Mmio stale data:      Not affected
  Retbleed:             Not affected
  Spec store bypass:    Mitigation; Speculative Store Bypass disabled via prctl
  Spectre v1:           Mitigation; __user pointer sanitization
  Spectre v2:           Mitigation; CSV2, BHB
  Srbds:                Not affected
  Tsx async abort:      Not affected

HOST $ numactl -H
available: 2 nodes (0-1)
node 0 cpus: 0-63
node 0 size: 257730 MB
node 0 free: 1447 MB
node 1 cpus: 64-127
node 1 size: 256877 MB
node 1 free: 256093 MB
node distances:
node   0   1
  0:  10  20
  1:  20  10

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
Linux arm 6.4.0-rc4 #1 SMP Sat Jun  3 05:30:06 UTC 2023 aarch64 aarch64 aarch64 GNU/Linux

HOST $ cat /proc/swaps
Filename				Type		Size		Used		Priority
/dev/nvme0n1p2                          partition	466838356	116922112	-2

HOST $ cat /sys/kernel/mm/lru_gen/enabled
0x000b

HOST $ cat /sys/kernel/mm/transparent_hugepage/enabled
always madvise [never]

HOST $ cat /sys/kernel/mm/transparent_hugepage/defrag
always defer defer+madvise madvise [never]

HOST $ qemu-system-aarch64 --version
QEMU emulator version 6.2.0 (Debian 1:6.2+dfsg-2ubuntu6.6)
Copyright (c) 2003-2021 Fabrice Bellard and the QEMU Project developers

GUEST $ cat /etc/lsb-release
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=22.04
DISTRIB_CODENAME=jammy
DISTRIB_DESCRIPTION="Ubuntu 22.04.2 LTS"

GUEST $ java --version
openjdk 17.0.7 2023-04-18
OpenJDK Runtime Environment (build 17.0.7+7-Ubuntu-0ubuntu122.04.2)
OpenJDK 64-Bit Server VM (build 17.0.7+7-Ubuntu-0ubuntu122.04.2, mixed mode, sharing)

GUEST $ spark-shell --version
Welcome to
      ____              __
     / __/__  ___ _____/ /__
    _\ \/ _ \/ _ `/ __/  '_/
   /___/ .__/\_,_/_/ /_/\_\   version 3.4.0
      /_/

Using Scala version 2.12.17, OpenJDK 64-Bit Server VM, 17.0.7
Branch HEAD
Compiled by user xinrong.meng on 2023-04-07T02:18:01Z
Revision 87a5442f7ed96b11051d8a9333476d080054e5a0
Url https://github.com/apache/spark
Type --help for more information.

Procedure
=========
HOST $ sudo numactl -N 0 -m 0 qemu-system-aarch64 \
    -M virt,accel=kvm -cpu host -smp 64 -m 300g -nographic -nic user \
    -bios /usr/share/qemu-efi-aarch64/QEMU_EFI.fd \
    -drive if=virtio,format=raw,file=/dev/nvme0n1p1

GUEST $ cat gen.scala
import java.io._
import scala.collection.mutable.ArrayBuffer

object GenData {
    def main(args: Array[String]): Unit = {
        val file = new File("/dev/shm/dataset.txt")
        val writer = new BufferedWriter(new FileWriter(file))
        val buf = ArrayBuffer(0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L, 0L)
        for(_ <- 0 until 400000000) {
            for (i <- 0 until 10) {
                buf.update(i, scala.util.Random.nextLong())
            }
            writer.write(s"${buf.mkString(",")}\n")
        }
        writer.close()
    }
}
GenData.main(Array())

GUEST $ cat sort.scala
import java.time.temporal.ChronoUnit
import org.apache.spark.sql.SparkSession

object SparkSort {
    def main(args: Array[String]): Unit = {
        val spark = SparkSession.builder().getOrCreate()
        val file = sc.textFile("/dev/shm/dataset.txt", 64)
        val results = file.flatMap(_.split(",")).map(x => (x, 1)).sortByKey().takeOrdered(10)
        results.foreach(println)
        spark.stop()
    }
}
SparkSort.main(Array())

GUEST $ cat run_spark.sh
export SPARK_LOCAL_DIRS=/dev/shm/

spark-shell <gen.scala

start=$SECONDS

for ((i=0; i<20; i++))
do
	spark-3.4.0-bin-hadoop3/bin/spark-shell --master "local[64]" --driver-memory 160g <sort.scala
done

echo "wall time: $((SECONDS - start))"

Results
=======
                       Before [1]    After    Change
----------------------------------------------------
Wall time (seconds)    14455         12865    -12%

Notes
=====
[1] "mm: rmap: Don't flush TLB after checking PTE young for page
    reference" was included so that the comparison is apples to
    Apples.
    https://lore.kernel.org/r/20220706112041.3831-1-21cnbao@gmail.com/
