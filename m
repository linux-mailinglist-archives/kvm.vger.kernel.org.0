Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA7E7BF05E
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 03:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379347AbjJJBfU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 21:35:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379335AbjJJBfS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 21:35:18 -0400
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D15F8B7;
        Mon,  9 Oct 2023 18:35:16 -0700 (PDT)
Received: by mail-ua1-x92d.google.com with SMTP id a1e0cc1a2514c-7b0ec7417bdso1577623241.2;
        Mon, 09 Oct 2023 18:35:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696901716; x=1697506516; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PCAZZqWA7W34+FGu9Ma++VOrVCcKUa0dLdOQIBbdvOg=;
        b=Vo/aXdw75CUU09LGI521cdrFYFpqvySCGKdAuTT3ySLqW4ITMkZ2dFTBztyIbhxA6n
         dfyKU9PmEP8onH69KaWtzRMRoYoApZPOvOKAt6/vYBSKLr6qTuOdcxRy0g6dlk1M1IzR
         lvXvTkw52nbVyqsT/EWlMLl9tlJmnP21xYJntvP75O+ZrmVQ3vcF+RdxtnQY44RbIuxS
         i2Odkt0rPrrjtQeB/rJGc/VRbCjm71K0089/TVWS46GNWZjoWVB2OA9ysk4LwqqWwvST
         fJBRvgrA0Gnb4aZ3OYiq4narzKuw+RahY8dBG/C0rLyih1OCe46/5SnzF7YMp/35BYM6
         dEow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696901716; x=1697506516;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PCAZZqWA7W34+FGu9Ma++VOrVCcKUa0dLdOQIBbdvOg=;
        b=gKTvLGoErwNl/pH/zsSrc02EoTBIiOYuwSi9QIeT16+rz6eY7H/El+fwWqScuU2e7w
         dAlppMnGl8EEi5ezjQoDrSJw3MhVQD8Y+bxHgBJPyGZbx52m3YodsbDh+E69Af0bneyx
         jFGySE8OH/3mSE5voGG+SUbEhE5jA/md5tulvJ+lDy1NNo0PGI2m6X9VzzmbrCIqhVhR
         MzqBI7InmTDt0mrFuyDmhjzBd3ZgUkJIJF5JV1Y2NwSfFHY2VmyQXDzdI7INZkgkc5jl
         tYSJSAw5p/f0Oy+QD5UxMFsEpe0pA11Oe4Bfe8HM3bKIuk3cMNt82AsYMPu8IhEXfO3J
         a4Mw==
X-Gm-Message-State: AOJu0YwE15TnMZorr/NtBZNI9sxPsdTrPKy2Rxjtfc6KWMqKLgH8SkCA
        VvzWXDBVkk4vGDA1g4DemayBRXKLgy47ORghDkjeXL8BhHFbcQ==
X-Google-Smtp-Source: AGHT+IEut4+8+Z49thmsIFFh4fyKsHauFIJ1lzCZ8BgcshepaYfEYGxa95v2w2ueKfUdHTDpUZBMLcZbb9EdqBshZqA=
X-Received: by 2002:a05:6102:34ce:b0:44e:9a71:279e with SMTP id
 a14-20020a05610234ce00b0044e9a71279emr14141727vst.31.1696901715764; Mon, 09
 Oct 2023 18:35:15 -0700 (PDT)
MIME-Version: 1.0
From:   Hyeonggon Yoo <42.hyeyoo@gmail.com>
Date:   Tue, 10 Oct 2023 10:35:03 +0900
Message-ID: <CAB=+i9S4NSJ7iNvqguWKvFvo=cMQC21KeNETsqmJoEpj+iDmig@mail.gmail.com>
Subject: Accessing emulated CXL memory is unstable
To:     Davidlohr Bueso <dave@stgolabs.net>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Alison Schofield <alison.schofield@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-cxl@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello folks,

I experienced strange application crashes/internal KVM errors
while playing with emulated type 3 CXL memory. I would like to know
if this is a real issue or I missed something during setup.

TL;DR: applications crash when accessing emulated CXL memory,
and stressing VM subsystem causes KVM internal error
(stressing via stress-ng --bigheap)

[ Details ]
qemu version is 8.1.50,
kernel version is 6.5.0,
ndctl version is 78.

the qemu command line is:
qemu-system-x86_64 \
       -accel kvm \
        -cpu host \
        -smp 1 \
        -M q35,cxl=on \
        -m 4G,maxmem=8G,slots=4 \
        -object memory-backend-ram,id=vmem0,share=on,size=4G \
        -device pxb-cxl,bus_nr=12,bus=pcie.0,id=cxl.1 \
        -device cxl-rp,port=0,bus=cxl.1,id=root_port13,chassis=0,slot=2 \
        -device cxl-type3,bus=root_port13,volatile-memdev=vmem0,id=cxl-vmem0 \
        -M cxl-fmw.0.targets.0=cxl.1,cxl-fmw.0.size=4G \
        -kernel ../linux/arch/x86/boot/bzImage \
        -append 'console=ttyS0 nokaslr root=/dev/vda5' \
        -netdev user,id=n1 \
        -device virtio-net,netdev=n1,bus=pcie.0 \
        -blockdev
driver=qcow2,file.filename=./rocky.qcow2,file.driver=file,node-name=blk1
\
        -device virtio-blk,drive=blk1,bus=pcie.0 \
        -nographic

[ Before creating a CXL RAM Region ]

# free -h
               total        used        free      shared  buff/cache   available
Mem:           3.8Gi       275Mi       3.6Gi       8.0Mi       120Mi       3.6Gi
Swap:             0B          0B          0B
# numactl --hardware
available: 1 nodes (0)
node 0 cpus: 0
node 0 size: 3923 MB
node 0 free: 3713 MB
node distances:
node   0
  0:  10

[ After creating a CXL RAM Region ]

# cxl enable-memdev mem0
# cxl create-region -t ram -m mem0 -w 1 -d decoder0.0

I enabled DEV_DAX_CXL=y and DEV_DAX_KMEM=y so when I create a CXL RAM Region,
so it is onlined right away.

# free -h
               total        used        free      shared  buff/cache   available
Mem:           7.8Gi       389Mi       7.5Gi       8.0Mi       122Mi       7.5Gi
Swap:             0B          0B          0B

# numactl --hardware
available: 2 nodes (0-1)
node 0 cpus: 0
node 0 size: 3923 MB
node 0 free: 3631 MB
node 1 cpus:
node 1 size: 4096 MB
node 1 free: 4096 MB
node distances:
node   0   1
  0:  10  20
  1:  20  10

So far, everything looks fine,
until an application actually accesses this onlined CXL memory.

# numactl --membind=1 --show
[  139.495065] traps: numactl[493] trap invalid opcode ip:7f58d44b8f64
sp:7ffc2a273128 error:0 in libc.so.6[7f58d4428000+175000]
Illegal instruction (core dumped)

Hmm... it crashed, and it's 'invalid opcode'.
Is this because the fetched instruction is different from what's
written to memory during exec()?

I don't know yet, but let's just continue.

Let's stress the VM subsystem by allocating lots of heap memory:
# stress-ng --bigheap 1

stress-ng: info:  [496] defaulting to a 86400 second (1 day, 0.00
secs) run per stressor
stress-ng: info:  [496] dispatching hogs: 1 bigheap

^C
KVM internal error. Suberror: 1
extra data[0]: 0x0000000000000001
extra data[1]: 0x41c03127ae0f480f
extra data[2]: 0x8b4865ca010fc489
extra data[3]: 0x0000000000000031
extra data[4]: 0x0000000000000000
extra data[5]: 0x0000000000000000
extra data[6]: 0x0000000000000000
extra data[7]: 0x0000000000000000
emulation failure
RAX=0000000000000207 RBX=ffff88810cfb6a80 RCX=0000000000000000
RDX=0000000000000000
RSI=0000000000000207 RDI=00007f526d41b540 RBP=00007f526d41b540
RSP=ffffc90000a23d90
R8 =ffffc90000a23e88 R9 =0000000008000000 R10=0000000000000000
R11=0000000000000001
R12=0000000000000207 R13=00007f526d41b540 R14=0000000000000000
R15=ffff88810cfb5e80
RIP=ffffffff8103e626 RFL=00050246 [---Z-P-] CPL=0 II=0 A20=1 SMM=0 HLT=0
ES =0000 0000000000000000 ffffffff 00c00000
CS =0010 0000000000000000 ffffffff 00a09b00 DPL=0 CS64 [-RA]
SS =0000 0000000000000000 ffffffff 00c00000
DS =0000 0000000000000000 ffffffff 00c00000
FS =0000 00007f526d41c740 ffffffff 00c00000
GS =0000 ffff88817bc00000 ffffffff 00c00000
LDT=0000 0000000000000000 ffffffff 00c00000
TR =0040 fffffe0000003000 00004087 00008b00 DPL=0 TSS64-busy
GDT=     fffffe0000001000 0000007f
IDT=     fffffe0000000000 00000fff
CR0=80050033 CR2=00007f526d41b740 CR3=0000000104e62000 CR4=00750ef0
DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000
DR3=0000000000000000
DR6=00000000ffff0ff0 DR7=0000000000000400
EFER=0000000000000d01
Code=5a 14 00 00 0f 01 cb 4c 89 e2 48 89 ef 44 89 e0 48 c1 ea 20 <48>
0f ae 27 31 c0 41 89 c4 0f 01 ca 65 48 8b 04 25 c0 ac 02 00 83 a8 54
0a 00 00 01 be 00

This time I pressed CTRL+C and it caused KVM internal error 1.

Hmm on another try I increased the number of threads and just waited,
and then KVM internal error 3 occurred.

# stress-ng --bigheap 12
stress-ng: info:  [484] defaulting to a 86400 second (1 day, 0.00
secs) run per stressor
stress-ng: info:  [484] dispatching hogs: 12 bigheap

[   15.408360] traps: setroubleshootd[251] trap invalid opcode
ip:7fc7e92ff3eb sp:7ffc760f98a0 error:0 in
libpython3.9.so.1.0[7fc7e925a000+1b5000]
qemu-system-x86_64: virtio: bogus descriptor or out of resources
[   16.526518] virtio_blk virtio1: [vda] new size: 209715200 512-byte
logical blocks (107 GB/100 GiB)
[   16.611852] traps: systemd-udevd[131] trap invalid opcode
ip:7fe3c84bc58f sp:7ffefca00588 error:0 in
libc.so.6[7fe3c8428000+175000]
[   16.625903] traps: systemd[1] trap invalid opcode ip:7fe89c6ba1c0
sp:7ffdd9331b88 error:0 in libc.so.6[7fe89c628000+175000]

KVM internal error. Suberror: 3
extra data[0]: 0x0000000080000b0e
extra data[1]: 0x0000000000000031
extra data[2]: 0x0000000000000d82
extra data[3]: 0x0000000418442c90
extra data[4]: 0x0000000000000008
RAX=aaaaaaaaaaaaaaab RBX=0000000000000000 RCX=000000000000000c
RDX=0000000000000533
RSI=ffffffff828c80a0 RDI=ffffc900008bf018 RBP=ffffffff81f5bd54
RSP=ffffc900008bf000
R8 =ffffffff81f5bd50 R9 =0000000000000000 R10=0000000000000000
R11=0000000000000000
R12=000000000000000e R13=ffffffff81f5bd54 R14=ffffc900008bf0c8
R15=0000000000000001
RIP=ffffffff815dfbe8 RFL=00010096 [--S-AP-] CPL=0 II=0 A20=1 SMM=0 HLT=0
ES =0000 0000000000000000 ffffffff 00c00000
CS =0010 0000000000000000 ffffffff 00a09b00 DPL=0 CS64 [-RA]
SS =0000 0000000000000000 ffffffff 00c00000
DS =0000 0000000000000000 ffffffff 00c00000
FS =0000 00007fe89c80cb40 ffffffff 00c00000
GS =0000 ffff88817bc00000 ffffffff 00c00000
LDT=0000 0000000000000000 ffffffff 00c00000
TR =0040 fffffe0000003000 00004087 00008b00 DPL=0 TSS64-busy
GDT=     fffffe0000001000 0000007f
IDT=     fffffe0000000000 00000fff
CR0=80050033 CR2=ffffffff815dfbe8 CR3=0000000418442000 CR4=00750ef0
DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000
DR3=0000000000000000
DR6=00000000ffff0ff0 DR7=0000000000000400
EFER=0000000000000d01
Code=90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 41 57 41 56 <41>
55 41 54 55 53 48 83 ec 08 4c 89 04 24 48 85 d2 74 4d 49 89 ff 49 89
f5 48 89 d3 49 89

--
Hyeonggon
