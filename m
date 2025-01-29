Return-Path: <kvm+bounces-36869-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F504A222BF
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 18:23:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EBC9F165F57
	for <lists+kvm@lfdr.de>; Wed, 29 Jan 2025 17:23:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D71151DFE39;
	Wed, 29 Jan 2025 17:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zEb13T+E"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435F01DFE01
	for <kvm@vger.kernel.org>; Wed, 29 Jan 2025 17:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738171406; cv=none; b=QJKe3sVZqbbbk5Mn3EQMnZgyoAhfp+SyP0mA+lDyJA4HYN9e5LEDDx5Ay+9UqtNwTXB5rRm1zUUysXccWtvGKPaaPf9C5bDJupuI/EYZQlBnUe7hQqnflGLFlX00nIa5tBuvXHck/aTxj7J+8x0MpoYBmrLon3+l2oWX4LRB4cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738171406; c=relaxed/simple;
	bh=X9PrKRRApKRRUuyeV4zb44U/EjiR7uazpkeOt44MQo8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=FVpqKVRgwkzUd2qg7vmeFgT7kfzd09tyXuDpaJ8qzr0SBtJB7FZvBM/oOffNFxFKxqsPqHos3VeR7ZT0NQFX8P13V78b4pOlvYXwkadj8lCeIw0+3jmLjgaIlb6qOjlPZGwuGUpJZmRKgQ6bQvdJjABOAOtzz3RWRU+hUdGSgY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zEb13T+E; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4359eb032c9so50902665e9.2
        for <kvm@vger.kernel.org>; Wed, 29 Jan 2025 09:23:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738171402; x=1738776202; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=e7jZ272MwG6ZSngomHi6wygNvtRM3NDIWJ5wIjYRFpM=;
        b=zEb13T+EWU9LLmZ801kGDVQUcSSYcRu5t36O/21cvd1oifOApFB1FyB6B/UQpuDil+
         q0cG7fsdwyIBbry2K4lBSyrN/xs4Cpm9/HQRVHXnEraLbgFlo2sY4hBUehaVGAXBvlKL
         MiCB0GIeiI1wwhY8yHF7+zxzO5fjjMmIMyrW55rfpyH28borV2EzAhTfcPCSOcepyZ3v
         lqawrBpQc/RXRfExfX+fF3yQNBIr+cnue8k5cBigdv59fPOznZi1pLMvOA4ijXjfTTFX
         vit/PSuLyTk/t/WR0ZwmGXr9Sn6ubVBu8tXpDxvr6vN3SgcPG5r8bPhTVBhvqYOLj6SL
         9Isg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738171402; x=1738776202;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e7jZ272MwG6ZSngomHi6wygNvtRM3NDIWJ5wIjYRFpM=;
        b=EC8IIVbwuO8dQ3Io2oVgwOkO7vefEvsyfXq0q2BLmCk5kLM8gwDRhCZ1QxTUr7jU3o
         kqePp0uczw9Ln6ypdbR1hSGv6N6TtAN4Cv2/Bkj8hZ5yOiz2TL0jhhJwZPgsxtLQNfpx
         SWO2tECCIBde8VfbqzGUHJyaoea5kYdeUOAF9vYbPFdIlx26khaU8h+hJ6W9SKk5NA4S
         t/9a+x+TOWk57ldymcVzEbb5MHza6PgvViIqVRhXY+YVhPZqaC0GBkIihOOnWvqyF1fH
         kw19tw5XRClaRLVVdM6vNHZ4zFld1jrcpjOodvBdlrkacgNknbNd5hKYn1sXd6QVpkuq
         iIlA==
X-Gm-Message-State: AOJu0Yxal5xweSivDPqNoxRkJEsguw2omMA83joGoSZPYdmj0nrcoq6l
	P+orIvpyWykAmX7wywmAydfu5lNai2v8bqDVlCyOCljLG4Ey9Opt1SuP3jqKtspTDbES9mKnuEN
	+UlP6QARTKEEMLHt3j+cTL05FWfnxrhIWFCkfPfeqDtCi7UBDaRopf5OS9XETsrXJBgZ6AMyCPn
	hxUKXkXZ+Ms7l3bGQ0FlQkyWY=
X-Google-Smtp-Source: AGHT+IFGcHNmqPkBkdOHisoptvfjVPA8qQ1v9Rp7boCnFq0xHETF9YJ177CDOBi8Rw9nEFkENUVOukdolg==
X-Received: from wmqc13.prod.google.com ([2002:a05:600c:a4d:b0:434:a050:ddcf])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4f55:b0:434:a746:9c82
 with SMTP id 5b1f17b1804b1-438dc3aa6c4mr38042595e9.5.1738171402339; Wed, 29
 Jan 2025 09:23:22 -0800 (PST)
Date: Wed, 29 Jan 2025 17:23:09 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.262.g85cc9f2d1e-goog
Message-ID: <20250129172320.950523-1-tabba@google.com>
Subject: [RFC PATCH v2 00/11] KVM: Mapping guest_memfd backed memory at the
 host for software protected VMs
From: Fuad Tabba <tabba@google.com>
To: kvm@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-mm@kvack.org
Cc: pbonzini@redhat.com, chenhuacai@kernel.org, mpe@ellerman.id.au, 
	anup@brainfault.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, seanjc@google.com, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, willy@infradead.org, akpm@linux-foundation.org, 
	xiaoyao.li@intel.com, yilun.xu@intel.com, chao.p.peng@linux.intel.com, 
	jarkko@kernel.org, amoorthy@google.com, dmatlack@google.com, 
	yu.c.zhang@linux.intel.com, isaku.yamahata@intel.com, mic@digikod.net, 
	vbabka@suse.cz, vannapurve@google.com, ackerleytng@google.com, 
	mail@maciej.szmigiero.name, david@redhat.com, michael.roth@amd.com, 
	wei.w.wang@intel.com, liam.merwick@oracle.com, isaku.yamahata@gmail.com, 
	kirill.shutemov@linux.intel.com, suzuki.poulose@arm.com, steven.price@arm.com, 
	quic_eberman@quicinc.com, quic_mnalajal@quicinc.com, quic_tsoni@quicinc.com, 
	quic_svaddagi@quicinc.com, quic_cvanscha@quicinc.com, 
	quic_pderrin@quicinc.com, quic_pheragu@quicinc.com, catalin.marinas@arm.com, 
	james.morse@arm.com, yuzenghui@huawei.com, oliver.upton@linux.dev, 
	maz@kernel.org, will@kernel.org, qperret@google.com, keirf@google.com, 
	roypat@amazon.co.uk, shuah@kernel.org, hch@infradead.org, jgg@nvidia.com, 
	rientjes@google.com, jhubbard@nvidia.com, fvdl@google.com, hughd@google.com, 
	jthoughton@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Main changes since v1 [1]:
- Added x86 support for mapping guest_memfd at the host, enabled
 only for the KVM_X86_SW_PROTECTED_VM type.
- Require setting memslot userspace_addr for guest_memfd slots
 even if shared, and remove patches that worked around that.
- Brought in more of the infrastructure from the patch series
 that allows restricted mapping of guest_memfd backed memory.
- Renamed references to "mappable" -> "shared".
- Expanded the selftests.
- Added instructions to test on x86 and arm64 (below).
- Rebased on Linux 6.13.

The purpose of this series is to serve as a base for _restricted_
mmap() support for guest_memfd backed memory at the host [2]. It
would allow experimentation with what that support would be like
in the safe environment of the software VM types, which are meant
for testing and experimentation.

This series adds a new VM type for arm64,
KVM_VM_TYPE_ARM_SW_PROTECTED, analogous to the x86
KVM_X86_SW_PROTECTED_VM. This type is to serve as a development
and testing vehicle for Confidential (CoCo) VMs.

Similar to its x86 counterpart, SW_PROTECTED is meant only for
development and testing. It's not meant to be used for "real"
VMs, and especially not in production. The behavior and effective
ABI for software-protected VMs is unstable.

This series enables mmap() and fault() support for guest_memfd
backed memory specifically for the software-protected VM types
(in x86 and arm64), only when explicitly enabled in the config.

The series is based on Linux 6.13 and much of the code within
is a subset of the latest series I sent [2], with the addition of
the new software protected vm type.

To test this series, I've pushed a kvmtool branch with support
for guest_memfd for x86 and arm64 and the new runtime options of
--guest_memfd and --sw_protected, which marks the VM as software
protected [3]. I plan on upstreaming this branch once I've tested
it more and tidied it up a bit (or a lot).

To test this patch series on x86 (I use a standard Debian image):

Build:

- Build the kernel with the following config options enabled:
defconfigs:
	x86_64_defconfig
	kvm_guest.config
config options:
	KVM
	KVM_INTEL
	KVM_PRIVATE_MEM
	KVM_SW_PROTECTED_VM
	KVM_GMEM_SHARED_MEM

- Build the kernel kvm selftest tools/testing/selftests/kvm, you
only need guest_memfd_test, e.g.:
	make EXTRA_CFLAGS="-static -DDEBUG" -C tools/testing/selftests/kvm

- Build kvmtool [3] lkvm-static (I build it on a different machine).
	make lkvm-static

Run:
Boot your Linux image with the kernel you built above.

The selftest you can run as it is:
	./guest_memfd_test

For kvmtool, where bzImage is the same as the host's:
	./lkvm-static run -c 2 -m 512 -p "break=mount" --kernel bzImage --debug --guest_memfd --sw_protected

To test this patch series on arm64 (I use a standard Debian image):

Build:

- Build the kernel with defconfig

- Build the kernel kvm selftest tools/testing/selftests/kvm, you
only need guest_memfd_test.

- Build kvmtool [3] lkvm-static (I cross compile it on a different machine).
You are likely to need libfdt as well.

For libfdt (in the same directory as kvmtool):
	git clone git://git.kernel.org/pub/scm/utils/dtc/dtc.git
	cd dtc
	export CC=aarch64-linux-gnu-gcc
	make
	cd ..

Then for kvmtool:
	make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- LIBFDT_DIR=./dtc/libfdt/ lkvm-static

Run:
Boot your Linux image with the kernel you built above.

The selftest you can run as it is:
	./guest_memfd_test

For kvmtool, where Image is the same as the host's, and rootfs is
your rootfs image (in case kvmtool can't figure it out):
	./lkvm-static run -c 2 -m 512 -d rootfs --kernel Image --force-pci --irqchip gicv3 --debug --guest_memfd --sw_protected

You can find (potentially slightly outdated) instructions on how
to a full arm64 system stack under QEMU here [4].

Cheers,
/fuad

[1] https://lore.kernel.org/all/20250122152738.1173160-1-tabba@google.com/
[2] https://lore.kernel.org/all/20250117163001.2326672-1-tabba@google.com/
[3] https://android-kvm.googlesource.com/kvmtool/+/refs/heads/tabba/guestmem-6.13
[4] https://mirrors.edge.kernel.org/pub/linux/kernel/people/will/docs/qemu/qemu-arm64-howto.html

Fuad Tabba (11):
  mm: Consolidate freeing of typed folios on final folio_put()
  KVM: guest_memfd: Handle final folio_put() of guest_memfd pages
  KVM: guest_memfd: Allow host to map guest_memfd() pages
  KVM: guest_memfd: Add KVM capability to check if guest_memfd is shared
  KVM: guest_memfd: Handle in-place shared memory as guest_memfd backed
    memory
  KVM: x86: Mark KVM_X86_SW_PROTECTED_VM as supporting guest_memfd
    shared memory
  KVM: arm64: Refactor user_mem_abort() calculation of force_pte
  KVM: arm64: Handle guest_memfd()-backed guest page faults
  KVM: arm64: Introduce KVM_VM_TYPE_ARM_SW_PROTECTED machine type
  KVM: arm64: Enable mapping guest_memfd in arm64
  KVM: guest_memfd: selftests: guest_memfd mmap() test when mapping is
    allowed

 Documentation/virt/kvm/api.rst                |  5 +
 arch/arm64/include/asm/kvm_host.h             | 10 ++
 arch/arm64/kvm/Kconfig                        |  1 +
 arch/arm64/kvm/arm.c                          |  5 +
 arch/arm64/kvm/mmu.c                          | 91 ++++++++++++-------
 arch/x86/include/asm/kvm_host.h               |  5 +
 arch/x86/kvm/Kconfig                          |  3 +-
 include/linux/kvm_host.h                      | 19 +++-
 include/linux/page-flags.h                    | 22 +++++
 include/uapi/linux/kvm.h                      |  7 ++
 mm/debug.c                                    |  1 +
 mm/swap.c                                     | 27 +++++-
 tools/testing/selftests/kvm/Makefile          |  1 +
 .../testing/selftests/kvm/guest_memfd_test.c  | 75 +++++++++++++--
 tools/testing/selftests/kvm/lib/kvm_util.c    |  3 +-
 virt/kvm/Kconfig                              |  4 +
 virt/kvm/guest_memfd.c                        | 90 ++++++++++++++++++
 virt/kvm/kvm_main.c                           |  9 +-
 18 files changed, 326 insertions(+), 52 deletions(-)


base-commit: ffd294d346d185b70e28b1a28abe367bbfe53c04
-- 
2.48.1.262.g85cc9f2d1e-goog


