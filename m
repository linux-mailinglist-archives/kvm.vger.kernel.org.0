Return-Path: <kvm+bounces-44145-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BC883A9B054
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 16:14:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E92297A3591
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 14:13:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F4CA19E7E2;
	Thu, 24 Apr 2025 14:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="L30fUIYb"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45BBC19C558
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 14:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745504029; cv=none; b=A8EbCozelEuMks0sbQG7U4I8MtT4vHvKAqpnVPKq438mzMhlrYvBHkhKpJhU/tNsr+3/YooezUV28Aw9Lf0i239Gu9X0uarnZkZH+yuiiYqqQB1p5Cn5X9WnMYR7mbRBUghIOxKR+ZgXUWPzgik0hqojD3h+cdts1EFUckVsH6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745504029; c=relaxed/simple;
	bh=gE5B+DRuvYdm1Xx80LASYKx8JQnPdEVc7dWEXx/LEcw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=GjWqdF1+Wxywf3J2xq5WWrUVcVTYLaqeZ2hNGjiszq0ShFq021Gj3khxZC6QzuO/NCUTlejd89N0ptBxkpr6yG64jw09KepQ0odtZQzzW+n8/rV8YzrTzdo0HT0ThZepuaDDTQs/+NnpNREGfNDhdp1zXuT+V3AZh+enS729YUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=L30fUIYb; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-39ee57c0b8cso1148130f8f.0
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 07:13:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745504025; x=1746108825; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+Gp3+Ahd9oztFC0Ee90Z+LBETEK7lh7obhrs3g0E+vA=;
        b=L30fUIYb5JBN77jCSMwgyW5pKUwPqUM4yzfK8KF1xgSViaHtNmTFByb/Xrw22XVTol
         OhNIBDAjhDqFQoFFbUOo/9MV2kx0iC5Zwb/kYO4CWG2YFyTspcbJ3zq+D8s393xt8TNP
         lOb8BXDv8XiK9aHG1j6brRnyMulh9TmXmQt5Ggx+NM3QDsW1u9UnMDQgMS0dVywh6uQL
         I7Nslb69i/TLlBemvu/3YYL2vI3yXR8t4N9r+IrVMGbRFLqXrvqZF11pk0TkqUade2T7
         sDJ+Y3K2v6GPCwyCntKP0LorzPsJWQDtLEFX3vfOjNaZxB0nSUnzflSyzyTHihzkv6wX
         JjfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745504025; x=1746108825;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+Gp3+Ahd9oztFC0Ee90Z+LBETEK7lh7obhrs3g0E+vA=;
        b=mElvp5/FXDge4KkiYxAqEvKmfrRJOcRIjFQxUYAbPuPgMQHx8ZB0M6EGkAld0+SyQI
         enMm3ssTsxYJrXbpc26UtkHTDtlu4a4ayfknzf1B7UupE4uMtWG1Ia1Svd58m/IeD1p0
         mlECFsuw/2yasyR2YlvApIhhSyOukOHQaLcWPVv3KiVolTJm405DLrYQfgzN1qSXP+Ru
         C6BxtSsQrxcBK3QZGcqHTEs5WBn3V+X+LgE6FKvvzZ/AQQN9hR5lV3ZxYgXW147WRW0Q
         s9EL2WnP5y/pXVSoGR+gJX6PZjgHWyjPoFSdK2SVyx/2Vt+WvX4uPy9qwBqgreqvA8J1
         WaHw==
X-Forwarded-Encrypted: i=1; AJvYcCUM2tZcYmI/nAdp3gh0dCxP5oqdKcKp7C4Z3Lr8ex5MUMOOqm3ciZ8G/lVsN+V7e2rS4PY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwXxZdocXLFkbjoQDZOGNJzXGzQW5yljXt0RopRrcb9mPtKjBmT
	5Qz1fa73chqL+gUf4EpLv67+U3McCjhBXXGrFCgr4OMLFUfZ3mOXA1P9Ay0NSFM=
X-Gm-Gg: ASbGncvkKlaziDdHZB15vSb2wXodm3yQIjQTEWyEYWFrWc/B3W7Zx/p/Q1+YognR8jC
	owwGi9zQal8djiMaA2eLseS/HyYlwi5KTA+1qnWcWOdUeZAdP1cDaoHBv61wMzfPOkvWNf5QZ0R
	LU31cFU2CppmQRn9w5slFm8zAy/oC/lU+qyJumys9G9fxSOsvVdXBHDTSnub4C7jhKSJnn/PW6l
	1Gyu4RUsZIfEikUlAPvkeV83XGbbPZNGGiCEr7tlMonQp144Az+QiDV3cO7kLgyT7WaDqcyUaIl
	j1lwNmyioFBw4C03t0urLEPaQiYiD5YCFg+veH77Upa2Pyj3Y0zSHbo2p3ZJsAp5lFhaVvnKCDD
	fD7B1oSnkmiAC1cmL
X-Google-Smtp-Source: AGHT+IG84/KbH73HJzgia5gWQQPbSCf6KDXX629rg6dbolYAjXdYgdIHXLTmBvWlH/T2NybxvuuICA==
X-Received: by 2002:a05:6000:4304:b0:39c:1257:cd40 with SMTP id ffacd0b85a97d-3a06cfb31damr2275855f8f.58.1745504025160;
        Thu, 24 Apr 2025 07:13:45 -0700 (PDT)
Received: from seksu.systems-nuts.com (stevens.inf.ed.ac.uk. [129.215.164.122])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d4a8150sm2199951f8f.7.2025.04.24.07.13.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 07:13:44 -0700 (PDT)
From: Karim Manaouil <karim.manaouil@linaro.org>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Karim Manaouil <karim.manaouil@linaro.org>,
	Alexander Graf <graf@amazon.com>,
	Alex Elder <elder@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Prakruthi Deepak Heragu <quic_pheragu@quicinc.com>,
	Quentin Perret <qperret@google.com>,
	Rob Herring <robh@kernel.org>,
	Srinivas Kandagatla <srini@kernel.org>,
	Srivatsa Vaddagiri <quic_svaddagi@quicinc.com>,
	Will Deacon <will@kernel.org>,
	Haripranesh S <haripran@qti.qualcomm.com>,
	Carl van Schaik <cvanscha@qti.qualcomm.com>,
	Murali Nalajala <mnalajal@quicinc.com>,
	Sreenivasulu Chalamcharla <sreeniva@qti.qualcomm.com>,
	Trilok Soni <tsoni@quicinc.com>,
	Stefan Schmidt <stefan.schmidt@linaro.org>
Subject: [RFC PATCH 00/34] Running Qualcomm's Gunyah Guests via KVM in EL1
Date: Thu, 24 Apr 2025 15:13:07 +0100
Message-Id: <20250424141341.841734-1-karim.manaouil@linaro.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This series introduces the capability of running Gunyah guests via KVM on
Qualcomm SoCs shipped with Gunyah hypervisor [1] (e.g. RB3 Gen2).

The goal of this work is to port the existing Gunyah hypervisor support from a
standalone driver interface [2] to KVM, with the aim of leveraging as much of the
existing KVM infrastructure as possible to reduce duplication of effort around
memory management (e.g. guest_memfd), irqfd, and other core components.

In short, Gunyah is a Type-1 hypervisor, meaning that it runs independently of any
high-level OS kernel such as Linux and runs in a higher CPU privilege level than VMs.
Gunyah is shipped as firmware and guests typically talk with Gunyah via hypercalls.
KVM is designed to run as Type-2 hypervisor. This port allows KVM to run in EL1 and
serve as the interface for VM lifecycle management,while offloading virtualization
to Gunyah.

This series is heavily based on previous work from Elliot Berman and others,
available at:
https://lore.kernel.org/lkml/20240222-gunyah-v17-0-1e9da6763d38@quicinc.com/

Many commits in this series are identical to or derived from previous work. To
preserve authorship and attribution, original `Author:` and `Signed-off-by:` tags
have been retained where appropriate, and occasionally `Reviewed-by:` lines were
kept as well.

While this series builds on much of the original Gunyah implementation, it drops
certain parts in favor of existing upstream features:
  - `gunyah_memfd` is dropped (currently using pinned anonymous pages — see below).
  - `gunyah_irqfd` is dropped in favor of KVM's irqfd.
  - Resource management, vCPU creation, and VM lifecycle are integrated directly
    into KVM’s architecture hooks.

At this stage, the port is functional but still **work in progress**. Notably:
  - Memory for guests is currently backed by **pinned anonymous pages**. This is a
    temporary solution: we intend to migrate to `guest_memfd`.
  - Memory compaction or swap must be avoided for now, as pages donated to Gunyah
    are no longer accessible from the host once mapped into the guest.
  - SMP boot is not available at the moment because Gunyah does not yet
    forward PSCI hypercalls to the host.
  - Virtio is not supported yet.

There is a lot of room for performance improvment. For example, ATM.
there is a lot of privilege level switching between EL1, EL2 (and
possible EL3). As well as context swicthing between guest kernel space
and guest userspace. For those interested, I have a compiled some slides
here to summarise the issues:
https://docs.google.com/presentation/d/1fL1TM1oxBrWFSL8KKw4jQtMDh7NOvyqbWWVu8iQxvoI/edit?usp=sharing

To test the port, a modified version of Qemu is needed. A version can be
found here:
https://github.com/karim-manaouil/qemu-for-gunyah

The series is based on linux-next as of today. A git tree is also
available here (gunyah-kvm branch):
https://github.com/karim-manaouil/linux-next

To test the guest, run (with the modified qemu):
./qemu-system-aarch64 \
	-enable-kvm \
	-machine virt,highmem=off \
	-cpu host \
	-smp 1 \
	-m 1G \
	-nographic \
	-kernel Image \
	-initrd initrd.img \
	-append "console=ttyAMA0 earlycon rdinit=/bin/sh"

Feedback Welcome!

[1] https://www.qualcomm.com/developer/blog/2024/08/learn-about-gunyah--qualcomm-s-open-source--lightweight-hypervis
[2] https://lore.kernel.org/lkml/20240222-gunyah-v17-0-1e9da6763d38@quicinc.com/

Elliot Berman (20):
  docs: gunyah: Introduce Gunyah Hypervisor
  dt-bindings: Add binding for gunyah hypervisor
  gunyah: Common types and error codes for Gunyah hypercalls
  gunyah: Add hypercalls to identify Gunyah
  gunyah: Add hypervisor driver
  gunyah: Add hypercalls to send and receive messages
  gunyah: Add resource manager RPC core
  gunyah: Add VM lifecycle RPC
  gunyah: Translate gh_rm_hyp_resource into gunyah_resource
  gunyah: Add resource tickets
  gunyah: Add hypercalls for running a vCPU
  gunyah: Add hypercalls for demand paging
  gunyah: Add memory parcel RPC
  gunyah: Add interfaces to map memory into guest address space
  gunyah: Add platform ops on mem_lend/mem_reclaim
  gunyah: Add Qualcomm Gunyah platform ops
  gunyah: Share guest VM dtb configuration to Gunyah
  gunyah: Add RPC to enable demand paging
  gunyah: Add RPC to set VM boot context
  gunyah: Add hypercalls for sending doorbell

Karim Manaouil (14):
  KVM: Allow arch-specific vCPU allocation and freeing
  KVM: irqfd: Add architecture hooks for irqfd allocation and
    initialization
  KVM: irqfd: Allow KVM backends to override IRQ injection via set_irq
    callback
  KVM: Add weak stubs for irqchip-related functions for Gunyah builds
  KVM: Add KVM_SET_DTB_ADDRESS ioctl to pass guest DTB address from
    userspace
  KVM: gunyah: Add initial Gunyah backend support
  KVM: gunyah: Pin guest memory
  gunyah: Add basic VM lifecycle management
  gunyah: add proxy-scheduled vCPUs
  gunyah: Share memory parcels
  gunyah: Enable demand paging
  gunyah: allow userspace to set boot cpu context
  KVM: gunyah: Implement irqfd interface
  KVM: gunyah: enable KVM for Gunyah

 .../bindings/firmware/gunyah-hypervisor.yaml  |   82 +
 Documentation/virt/gunyah/index.rst           |  135 ++
 Documentation/virt/gunyah/message-queue.rst   |   68 +
 Documentation/virt/index.rst                  |    1 +
 arch/arm64/Kbuild                             |    1 +
 arch/arm64/gunyah/Makefile                    |    3 +
 arch/arm64/gunyah/gunyah_hypercall.c          |  279 +++
 arch/arm64/include/asm/gunyah.h               |   57 +
 arch/arm64/include/asm/kvm_host.h             |   10 +-
 arch/arm64/include/asm/virt.h                 |    7 +
 arch/arm64/kernel/cpufeature.c                |    4 +
 arch/arm64/kernel/image-vars.h                |    2 +-
 arch/arm64/kvm/Kconfig                        |   22 +-
 arch/arm64/kvm/Makefile                       |   14 +-
 arch/arm64/kvm/gunyah.c                       | 2085 +++++++++++++++++
 drivers/virt/Kconfig                          |    2 +
 drivers/virt/Makefile                         |    1 +
 drivers/virt/gunyah/Kconfig                   |   29 +
 drivers/virt/gunyah/Makefile                  |    7 +
 drivers/virt/gunyah/gunyah.c                  |   55 +
 drivers/virt/gunyah/gunyah_platform_hooks.c   |  117 +
 drivers/virt/gunyah/gunyah_qcom.c             |  220 ++
 drivers/virt/gunyah/rsc_mgr.c                 |  792 +++++++
 drivers/virt/gunyah/rsc_mgr_rpc.c             |  572 +++++
 include/kvm/arm_pmu.h                         |    2 +-
 include/linux/gunyah.h                        |  425 ++++
 include/linux/gunyah_rsc_mgr.h                |  182 ++
 include/linux/irqchip/arm-vgic-info.h         |    2 +-
 include/linux/kvm_host.h                      |    3 +
 include/linux/kvm_irqfd.h                     |    5 +
 include/linux/perf/arm_pmu.h                  |    2 +-
 include/uapi/linux/kvm.h                      |   14 +-
 virt/kvm/eventfd.c                            |   56 +-
 virt/kvm/kvm_main.c                           |   24 +-
 34 files changed, 5258 insertions(+), 22 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/firmware/gunyah-hypervisor.yaml
 create mode 100644 Documentation/virt/gunyah/index.rst
 create mode 100644 Documentation/virt/gunyah/message-queue.rst
 create mode 100644 arch/arm64/gunyah/Makefile
 create mode 100644 arch/arm64/gunyah/gunyah_hypercall.c
 create mode 100644 arch/arm64/include/asm/gunyah.h
 create mode 100644 arch/arm64/kvm/gunyah.c
 create mode 100644 drivers/virt/gunyah/Kconfig
 create mode 100644 drivers/virt/gunyah/Makefile
 create mode 100644 drivers/virt/gunyah/gunyah.c
 create mode 100644 drivers/virt/gunyah/gunyah_platform_hooks.c
 create mode 100644 drivers/virt/gunyah/gunyah_qcom.c
 create mode 100644 drivers/virt/gunyah/rsc_mgr.c
 create mode 100644 drivers/virt/gunyah/rsc_mgr_rpc.c
 create mode 100644 include/linux/gunyah.h
 create mode 100644 include/linux/gunyah_rsc_mgr.h

-- 
2.39.5


