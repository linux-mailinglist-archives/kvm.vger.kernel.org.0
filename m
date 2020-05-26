Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B22881D7164
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 08:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgERG6M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 02:58:12 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42032 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbgERG6M (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 May 2020 02:58:12 -0400
Received: by mail-wr1-f66.google.com with SMTP id s8so10395725wrt.9;
        Sun, 17 May 2020 23:58:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=+D77RfiJOu4D1YxT/E/Zl3KQA8PQ7qtZd5MuZFWy0Z8=;
        b=bdQ/cCAZQ1MOKoBpBHIzjPaR/Gs+HaeYxxDKTceBSKIAfY6Lp/Ckpf5TdtCi+9jiRL
         3ToZI9zfsBEXd2+YYDoS95rHpzCVDZnY3eozuL7bDs1tfGBVeFiVmbNrXgPNBXPUUAHJ
         OxcGrIfOGTLDxVsNVtAS/hnK0AzMlGBQE+QokfCJPYxlDJnhv7C2JdXQGMpZuLWuU0xx
         axvJ/HAq7U8TjvAxnQ44qi5ONpPY/RiMmcyAFhUszR2B44iL8TK/iPl3stOkDNQbQppo
         pthc+LNsIsr0e9wqJ8EkgFlSoEyCyYKfNN7VkjKKIX3ZP3kAklDicAPPArWH1KVLZ2RO
         ai0w==
X-Gm-Message-State: AOAM532WIBFvWXcTgxYqh5UoqRr8XnUvXxhgkqjh6S/RVSLfTaNmRUTq
        f44DaoBVl2drKVqbN6T7QmI=
X-Google-Smtp-Source: ABdhPJyxw+2tvhwUPs5V0h23SzHGXLChNa2LJLySoY5UzfK9tiPx/GZscXXrz3LabEGdcG6dz3I77A==
X-Received: by 2002:adf:f981:: with SMTP id f1mr17802097wrr.244.1589785089337;
        Sun, 17 May 2020 23:58:09 -0700 (PDT)
Received: from bf.nubificus.co.uk ([2a02:587:b919:800:aaa1:59ff:fe09:f176])
        by smtp.gmail.com with ESMTPSA id x184sm15563684wmg.38.2020.05.17.23.58.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2020 23:58:08 -0700 (PDT)
Date:   Mon, 18 May 2020 09:58:05 +0300
From:   Anastassios Nanos <ananos@nubificus.co.uk>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 0/2] Expose KVM API to Linux Kernel
Message-ID: <cover.1589784221.git.ananos@nubificus.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To spawn KVM-enabled Virtual Machines on Linux systems, one has to use
QEMU, or some other kind of VM monitor in user-space to host the vCPU
threads, I/O threads and various other book-keeping/management mechanisms.
This is perfectly fine for a large number of reasons and use cases: for
instance, running generic VMs, running general purpose Operating systems
that need some kind of emulation for legacy boot/hardware etc.

What if we wanted to execute a small piece of code as a guest instance,
without the involvement of user-space? The KVM functions are already doing
what they should: VM and vCPU setup is already part of the kernel, the only
missing piece is memory handling.

With these series, (a) we expose to the Linux Kernel the bare minimum KVM
API functions in order to spawn a guest instance without the intervention
of user-space; and (b) we tweak the memory handling code of KVM-related
functions to account for another kind of guest, spawned in kernel-space.

PATCH #1 exposes the needed stub functions, whereas PATCH #2 introduces the
changes in the KVM memory handling code for x86_64 and aarch64.

An example of use is provided based on kvmtest.c
[https://lwn.net/Articles/658512/] at
https://github.com/cloudkernels/kvmmtest

Anastassios Nanos (2):
  KVMM: export needed symbols
  KVMM: Memory and interface related changes

 arch/arm64/include/asm/kvm_host.h   |   6 ++
 arch/arm64/kvm/fpsimd.c             |   8 +-
 arch/arm64/kvm/guest.c              |  48 +++++++++++
 arch/x86/include/asm/fpu/internal.h |  10 ++-
 arch/x86/kvm/cpuid.c                |  25 ++++++
 arch/x86/kvm/emulate.c              |   3 +-
 arch/x86/kvm/vmx/vmx.c              |   3 +-
 arch/x86/kvm/x86.c                  |  38 ++++++++-
 include/linux/kvm_host.h            |  36 +++++++++
 virt/kvm/arm/arm.c                  |  18 +++++
 virt/kvm/arm/mmu.c                  |  34 +++++---
 virt/kvm/async_pf.c                 |   4 +-
 virt/kvm/coalesced_mmio.c           |   6 ++
 virt/kvm/kvm_main.c                 | 120 ++++++++++++++++++++++------
 14 files changed, 316 insertions(+), 43 deletions(-)

-- 
2.20.1

