Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 122581A2ABE
	for <lists+kvm@lfdr.de>; Wed,  8 Apr 2020 23:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729602AbgDHVAA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Apr 2020 17:00:00 -0400
Received: from mail-qv1-f47.google.com ([209.85.219.47]:38854 "EHLO
        mail-qv1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727984AbgDHVAA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Apr 2020 17:00:00 -0400
Received: by mail-qv1-f47.google.com with SMTP id p60so4449276qva.5
        for <kvm@vger.kernel.org>; Wed, 08 Apr 2020 13:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :cc:to;
        bh=dYstEsSqQX7IaGveGd4y7V+/6JpFwxf+9/QIg+c9QOM=;
        b=S3jXt6pLc/wXslGDPEq6psl8z356D2R2G0nWcbrgeI77RFmPglOXiN3H4kgwxZOny3
         3wFSB2J3EesPUNRP5+wjHlwkGEAnI3uu+Dxk4L1/atd2Yrp6RG3LwBIHhx2Doyegy/uB
         TpCFeRE/gUgdKi3IJWuTpKdeB/MsM7KmbbYSq4IklRQDW6in50yFb/IgDHyte4PjzrwB
         +Y8N8K0PfxhWl9IydlEE6snHpODT0vW9Q8M2pnWVk+HYK3XupoMa9h12NmBcAJU2KoCq
         aIRWTV7pWi6FnbnG3+lxLlZzzv/I4cVnVLYBy65KeOCkud76ElARd4Ab3LebFKk+KGu5
         YGDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:cc:to;
        bh=dYstEsSqQX7IaGveGd4y7V+/6JpFwxf+9/QIg+c9QOM=;
        b=SB+wd7+D84mcwTioCORtcVP/Kw44WBdplvmXcDQDo84AX3Ymko+MwHa94eOZmHIn0J
         kIntRNeL8WNvsPH8aXzKYHMcsCaNVIWZ7HhXzJJ/8KAVWCuL9KDG8sZnKIV9ExKsRBGU
         DQKuqqaXJJP70dnMjUMPigTMqZyrM7g+eNl6yTxCY+lWJi6fb9JcWe+mr3WUal7TGCcv
         J36XfR4Cco7KNvC1KaHk/byY49+UdwChXWpCvdJec3wa+d0jfHniLN6SdZoheQeJzQIN
         91iaEWopSMJ3DGUHcmfl4SmZQH3u84XCl8J2Y3gouDT3fmIWGXV3SjJW4s/FWv8UR5a3
         PsNg==
X-Gm-Message-State: AGi0PuZB56mvgqQ6feGl/LzGeRxU2Myf7UqkMm1CnWQBCM+MKXS0Exwv
        AguTyQdHo9D9PkFQKPDBJwHOpA==
X-Google-Smtp-Source: APiQypLC9SVGkIg4jeCqcn/cDoGKRO5MeBH2hjSY6kbDTRrnyXE+NxDN3kp7EFhkAp7pKNvSCcgv/g==
X-Received: by 2002:a0c:9e68:: with SMTP id z40mr9255056qve.242.1586379598529;
        Wed, 08 Apr 2020 13:59:58 -0700 (PDT)
Received: from [192.168.1.153] (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id w30sm21219394qtw.21.2020.04.08.13.59.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Apr 2020 13:59:57 -0700 (PDT)
From:   Qian Cai <cai@lca.pw>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: KCSAN + KVM = host reset
Message-Id: <E180B225-BF1E-4153-B399-1DBF8C577A82@lca.pw>
Date:   Wed, 8 Apr 2020 16:59:56 -0400
Cc:     "paul E. McKenney" <paulmck@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kasan-dev <kasan-dev@googlegroups.com>,
        LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
To:     Elver Marco <elver@google.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Running a simple thing on this AMD host would trigger a reset right =
away.
Unselect KCSAN kconfig makes everything work fine (the host would also
reset If only "echo off > /sys/kernel/debug/kcsan=E2=80=9D before =
running qemu-kvm).

/usr/libexec/qemu-kvm -name ubuntu-18.04-server-cloudimg -cpu host -smp =
2 -m 2G -hda ubuntu-18.04-server-cloudimg.qcow2 -cdrom =
ubuntu-18.04-server-cloudimg.iso -nic user,hostfwd=3Dtcp::2222-:22 =
-serial mon:stdio -nographic

With this config on today=E2=80=99s linux-next,

https://raw.githubusercontent.com/cailca/linux-mm/master/kcsan.config

Cherry-picked a few commits from -rcu (in case if it ever matters)

48b1fc1 kcsan: Add option to allow watcher interruptions
2402d0e kcsan: Add option for verbose reporting
43f7646 x86/mm/pat: Mark an intentional data race

=3D=3D=3D console output =3D=3D=3D
Kernel 5.6.0-next-20200408+ on an x86_64

hp-dl385g10-05 login:=20

<...host reset...>

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
HPE ProLiant System BIOS A40 v1.20 (03/09/2018)
(C) Copyright 1982-2018 Hewlett Packard Enterprise Development LP
Early system initialization, please wait...=20


iLO 5 IPv4: 10.73.196.44
iLO 5 IPv6: FE80::D6C9:EFFF:FECE:717E

  2%: Early Processor Initialization
  4%: Processor Root Ports Initialization
  8%: SMBIOS Table Initialization
 12%: HPE SmartMemory Initialization
 17%: iLO Embedded Health Initialization
 21%: ACPI Table Initialization
 25%: System Security Initialization
 30%: BIOS Configuration Initialization
 39%: Early PCI Initialization - Start
 47%: Early PCI Initialization - Complete
 60%: Switching console output to Primary Video. Please wait=E2=80=A6
=3D=3D=3D=3D=3D=3D=3D=3D

# lscpu
Architecture:        x86_64
CPU op-mode(s):      32-bit, 64-bit
Byte Order:          Little Endian
CPU(s):              32
On-line CPU(s) list: 0-31
Thread(s) per core:  2
Core(s) per socket:  8
Socket(s):           2
NUMA node(s):        8
Vendor ID:           AuthenticAMD
CPU family:          23
Model:               1
Model name:          AMD EPYC 7251 8-Core Processor
Stepping:            2
CPU MHz:             2830.383
CPU max MHz:         2100.0000
CPU min MHz:         1200.0000
BogoMIPS:            4191.58
Virtualization:      AMD-V
L1d cache:           32K
L1i cache:           64K
L2 cache:            512K
L3 cache:            4096K
NUMA node0 CPU(s):   0,1,16,17
NUMA node1 CPU(s):   2,3,18,19
NUMA node2 CPU(s):   4,5,20,21
NUMA node3 CPU(s):   6,7,22,23
NUMA node4 CPU(s):   8,9,24,25
NUMA node5 CPU(s):   10,11,26,27
NUMA node6 CPU(s):   12,13,28,29
NUMA node7 CPU(s):   14,15,30,31
Flags:               fpu vme de pse tsc msr pae mce cx8 apic sep mtrr =
pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext =
fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc cpuid =
extd_apicid amd_dcm aperfmperf pni pclmulqdq monitor ssse3 fma cx16 =
sse4_1 sse4_2 movbe popcnt aes xsave avx f16c rdrand lahf_lm cmp_legacy =
svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw skinit =
wdt tce topoext perfctr_core perfctr_nb bpext perfctr_llc mwaitx cpb =
hw_pstate ssbd ibpb vmmcall fsgsbase bmi1 avx2 smep bmi2 rdseed adx smap =
clflushopt sha_ni xsaveopt xsavec xgetbv1 xsaves clzero irperf =
xsaveerptr arat npt lbrv svm_lock nrip_save tsc_scale vmcb_clean =
flushbyasid decodeassists pausefilter pfthreshold avic v_vmsave_vmload =
vgif overflow_recov succor smca

# cat /sys/kernel/debug/kcsan=20
enabled: 1
used_watchpoints: 0
setup_watchpoints: 13777602
data_races: 47
assert_failures: 0
no_capacity: 598865
report_races: 0
races_unknown_origin: 226
unencodable_accesses: 0
encoding_false_positives: 0=
