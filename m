Return-Path: <kvm+bounces-56769-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 09BEEB43518
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 10:12:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3DCFF6867DD
	for <lists+kvm@lfdr.de>; Thu,  4 Sep 2025 08:12:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16BEA2C0F76;
	Thu,  4 Sep 2025 08:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FPUby/Nn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD8D2BEFF1
	for <kvm@vger.kernel.org>; Thu,  4 Sep 2025 08:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756973496; cv=none; b=PFFee6ogZpiHZIaVTL0X2ka3oGsRLkp5Ngby3OpANWeWyns3cGcg5B677Obw2St/2VXI8KnFGbF2rhGbCt1pttwiO8GWHi1PgBHozCF5CI1/EA3UkuyvP3gPlI7wZQ66fkUo9cV3tcqPuJzcI3nvSe7KwwiXt2zy4SRp2CxibZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756973496; c=relaxed/simple;
	bh=ooLuSunCflugIF9FXH8ANy6tDu6gs6+DHIeeYTs79eA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=HEzMxJ3Cjo+xqpzLkbgF2m2GjNw4gXBGGLRGj03gCScGHaT64qLZy6JOOjeIJk7BVoIswnNytuixpXOdDitCbIZseBBBlJZ2D5Xv1T5LBvQdaF/DNHrdGDSY8SxFifJcgws8ozir9ZBiGod1EM6JuvwTUbjn0g0EsU/7GI/IvKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FPUby/Nn; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b046f6fb230so120548666b.1
        for <kvm@vger.kernel.org>; Thu, 04 Sep 2025 01:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756973490; x=1757578290; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XqhSfFZh32/LWATk0oNaMV37MMZwWogSp5tfK+xWIOE=;
        b=FPUby/NnT2Zrfxj3rb4nVRGCsZxDML81wkvTb2c7j0c5s5GQjhLFtVUHfNpuExoVhD
         ApEaGn0Qu+nAQXC+SDI9eaWmBIWblU69Mc1gJC56IW7QXvb16zc+j5Pbrl/5WhXG7Wyw
         raClHPZ7Jn4e2nplFB3hQXh33ur8hBcqtHdlPFy6aA6sStCDjbr07/AWJwiFmbDfo7Zk
         PqEbG4a/mWWxJVrLLXjKygg6ftyIynCp3sycW5gMErXdmyVx+nR/ZRGhsMgFPE+15N6I
         pEjZkmTUsrOCQzkhbQVp+Q49/y9NSpAocCo0rhreoVBMWbAx0W4KOfnStd5t8ShIeCga
         GkJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756973490; x=1757578290;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XqhSfFZh32/LWATk0oNaMV37MMZwWogSp5tfK+xWIOE=;
        b=n6EAm48RJRfyTftObQE73MHeWOGP4LvN8iEqaIWf0LIeGDSIcv7+e5rrxhnmV8OsSH
         Anuhzl8Ia4oT5SPkMYLucUlaYm1IDa78nsSEn1jafhliUp80BErFXKipixtznp0dcZcA
         XH5OlHHnZl3Mk9H6NVG5yLet6FKpWp00xNStsRtgREjQDpxv4lWvaaAm5hNJMynOCq76
         50xVYyf1QIcZ/aM03C6VLiiT/LCjatw169mv1FAsRxOYG80u+ofhzakKGZEM4nYtfPZ8
         UIBoj95+ViWXdDXnhKTblBV2Hws51M8sPtpP+M/cPkoguY4CBQki6/MH3zErFO5b8Dty
         JvkA==
X-Forwarded-Encrypted: i=1; AJvYcCWpyVFgcgQRG35wt8D2Hz8TNCsZv71im+tURJMIj04bBqwNbgEG477RBZE08dry/oLmkfU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQpLCUUrSYdYcXyn1BbPqRhlM742OMzCa0RRYfS/kRtHWCF865
	X1PSuefvt74uZ5QSAJ15+kr2JlQ9789cmmotimjZLgNWCIs4U5UKd2uVFqagb6BJshI=
X-Gm-Gg: ASbGncsAK7xba7aBSxRh7VtcgC9uEvqwVBwZF7xCCa0nRAXmvY2JCP6hvwtURKTlt0m
	cF05e1PgM1W7QG0zSW567QN0Bbx87MRrDDwiYy0N4c0q6eWAQjOikIWRD+nVX4BqLlLAtVux98K
	xTBZ+OrUkxVXbZi7U+lGQt7Ir4ICcfli76VNIu9QksuVyuVe92LlIfMEvGJ4KpesrsJHnAkOWR9
	M1FdQxtUv2NhXnXb4jYWgME0arxWQ2lIq7nDpBixvvTgiMlK9WxlMi2tvMxxx1BbFWJ/Mu7l2X9
	d6bh58ml78PQSzujZNyJ+jixEQKFWML4FGcAh2Ru7enSR0s8NZrkWfNL56HVCD4TS/lhX6JAIJU
	gCsDW1N7zNcVfSYJ468YrIuG5Z5sEL+1VVQ==
X-Google-Smtp-Source: AGHT+IHCRDcPbcPYrMBxXfMHRuLHbVgNL+dklCOKBJ1tfTxEKWGJRexXT1rY7CW2YtZIsy02KQ1rtA==
X-Received: by 2002:a17:907:c1f:b0:ad8:91e4:a931 with SMTP id a640c23a62f3a-b01d979e0c0mr1892442066b.26.1756973490109;
        Thu, 04 Sep 2025 01:11:30 -0700 (PDT)
Received: from draig.lan ([185.126.160.19])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b0427c0d4cbsm962714566b.45.2025.09.04.01.11.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Sep 2025 01:11:29 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 333B35F8DF;
	Thu, 04 Sep 2025 09:11:28 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Reinoud Zandijk <reinoud@netbsd.org>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	qemu-arm@nongnu.org,
	Fam Zheng <fam@euphon.net>,
	Helge Deller <deller@gmx.de>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Fabiano Rosas <farosas@suse.de>,
	qemu-rust@nongnu.org,
	Bibo Mao <maobibo@loongson.cn>,
	qemu-riscv@nongnu.org,
	Thanos Makatos <thanos.makatos@nutanix.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Riku Voipio <riku.voipio@iki.fi>,
	Cameron Esfahani <dirty@apple.com>,
	Alexander Graf <agraf@csgraf.de>,
	Laurent Vivier <lvivier@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	qemu-ppc@nongnu.org,
	Stafford Horne <shorne@gmail.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Jagannathan Raman <jag.raman@oracle.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Brian Cain <brian.cain@oss.qualcomm.com>,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	devel@lists.libvirt.org,
	Mads Ynddal <mads@ynddal.dk>,
	Elena Ufimtseva <elena.ufimtseva@oracle.com>,
	Peter Xu <peterx@redhat.com>,
	Jason Herne <jjherne@linux.ibm.com>,
	Michael Rolnik <mrolnik@gmail.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	qemu-block@nongnu.org,
	Peter Maydell <peter.maydell@linaro.org>,
	Kostiantyn Kostiuk <kkostiuk@redhat.com>,
	Kyle Evans <kevans@freebsd.org>,
	David Hildenbrand <david@redhat.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Warner Losh <imp@bsdimp.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	John Snow <jsnow@redhat.com>,
	Yoshinori Sato <yoshinori.sato@nifty.com>,
	Aleksandar Rikalo <arikalo@gmail.com>,
	Alistair Francis <alistair@alistair23.me>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Yonggang Luo <luoyonggang@gmail.com>,
	Radoslaw Biernacki <rad@semihalf.com>,
	Artyom Tarasenko <atar4qemu@gmail.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Richard Henderson <richard.henderson@linaro.org>,
	qemu-s390x@nongnu.org,
	Alex Williamson <alex.williamson@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Roman Bolshakov <rbolshakov@ddn.com>,
	Manos Pitsidianakis <manos.pitsidianakis@linaro.org>,
	Chinmay Rath <rathc@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Cleber Rosa <crosa@redhat.com>,
	kvm@vger.kernel.org,
	Song Gao <gaosong@loongson.cn>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Halil Pasic <pasic@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Michael Roth <michael.roth@amd.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	John Levon <john.levon@nutanix.com>
Subject: [PATCH v2 000/281] arm_load_dtb cleanups
Date: Thu,  4 Sep 2025 09:06:34 +0100
Message-ID: <20250904081128.1942269-1-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

This was prompted by a slop PR that came in via github and while
looking at it I thought what arm_load_dtb really needed was to be
modernised to:

  - use autofree to avoid goto fail
  - use error_setg to report errors
  - use error_fatal rather than open coding exit()

For v2

  - applied review tags
  - tweak to handle fdt != ms->fdt
  - put GStrv in a block
  - re-base fixes

Alex.

Alex Bennée (4):
  hw/arm: use g_autofree for filename in arm_load_dtb
  hw/arm: use g_autofree for fdt in arm_load_dtb
  hw/arm: use g_auto(GStrv) for node_path in arm_load_dtb
  hw/arm: expose Error * to arm_load_dtb

Ani Sinha (1):
  kvm/kvm-all: make kvm_park/unpark_vcpu local to kvm-all.c

Bibo Mao (14):
  target/loongarch: Move some function definition to kvm directory
  target/loongarch: Define function loongarch_cpu_post_init as static
  target/loongarch: Set page size in TLB entry with STLB
  target/loongarch: Add header file cpu-mmu.h
  target/loongarch: Add enum type TLBRet definition
  target/loongarch: Use vaddr in get_physical_address()
  target/loongarch: Use MMUAccessType in loongarch_map_tlb_entry()
  target/loongarch: Add common function loongarch_check_pte()
  target/loongarch: Use loongarch_check_pte in
    loongarch_page_table_walker
  target/loongarch: Use MMUConext in loongarch_map_tlb_entry()
  target/loongarch: Use MMUContext in loongarch_get_addr_from_tlb
  target/loongarch: Use MMUContext in loongarch_map_address()
  target/loongarch: Use MMUContext in get_physical_address()
  target/loongarch: Use correct address when flush tlb

Cornelia Huck (1):
  hw: add compat machines for 10.2

Denis V. Lunev (1):
  qga: fix potentially not initialized nr_volumes in qga_vss_fsfreeze()

Gustavo Romero (5):
  tests/functional: Fix reverse_debugging asset precaching
  tests/functional: Mark main in QemuBaseTest class as a static method
  target/arm: Clean up of register field definitions
  target/arm: Implement FEAT_SCTLR2 and enable with -cpu max
  target/arm: Implement FEAT_TCR2 and enable with -cpu max

Igor Mammedov (8):
  add cpu_test_interrupt()/cpu_set_interrupt() helpers and use them tree
    wide
  memory: reintroduce BQL-free fine-grained PIO/MMIO
  acpi: mark PMTIMER as unlocked
  hpet: switch to fine-grained device locking
  hpet: move out main counter read into a separate block
  hpet: make main counter read lock-less
  kvm: i386: irqchip: take BQL only if there is an interrupt
  tcg: move interrupt caching and single step masking closer to user

Joel Stanley (1):
  linux-user: Add strace for rseq

Kostiantyn Kostiuk (6):
  qga-vss: Replace asserts with condition and report error
  qga-vss: Remove unused dependencies
  qga: Fix channel initialization check in run_agent_once
  qga: ignore channel_init() fail if 'retry_path' is set
  qga-vss: Write hex value of error in log
  qga/installer: Remove QGA VSS if QGA installation failed

Manos Pitsidianakis (4):
  scripts/minikconf.py: fix invalid attribute access
  scripts/minikconf.py: s/Error/KconfigParserError
  rust: declare self as qemu_api for proc-macros
  hw/arm: add static NVDIMMs in device tree

Marc-André Lureau (1):
  rust/qemu-api-macros: make derive(Object) friendly when missing parent

Mark Cave-Ayland (19):
  hw/i386/pc_piix.c: restrict isapc machine to 32-bit CPUs
  hw/i386/pc_piix.c: restrict isapc machine to 3.5G memory
  hw/i386/pc_piix.c: remove include for loader.h
  hw/i386/pc_piix.c: inline pc_xen_hvm_init_pci() into pc_xen_hvm_init()
  hw/i386/pc_piix.c: duplicate pc_init1() into pc_isa_init()
  hw/i386/pc_piix.c: remove pcmc->pci_enabled dependent initialisation
    from pc_init_isa()
  hw/i386/pc_piix.c: remove igvm initialisation from pc_init_isa()
  hw/i386/pc_piix.c: remove SMI and piix4_pm initialisation from
    pc_init_isa()
  hw/i386/pc_piix.c: remove SGX initialisation from pc_init_isa()
  hw/i386/pc_piix.c: remove nvdimm initialisation from pc_init_isa()
  hw/i386/pc_piix.c: simplify RAM size logic in pc_init_isa()
  hw/i386/pc_piix.c: hardcode hole64_size to 0 in pc_init_isa()
  hw/i386/pc_piix.c: remove pc_system_flash_cleanup_unused() from
    pc_init_isa()
  hw/i386/pc_piix.c: always initialise ISA IDE drives in pc_init_isa()
  hw/i386/pc_piix.c: assume pcmc->pci_enabled is always true in
    pc_init1()
  hw/i386: move isapc machine to separate isapc.c file
  hw/i386/pc_piix.c: remove unused headers after isapc machine split
  hw/i386/pc_piix.c: replace rom_memory with pci_memory
  hw/i386/isapc.c: replace rom_memory with system_memory

Markus Armbruster (8):
  ui/keymaps: Avoid trace crash and improve error messages
  i386/kvm/vmsr_energy: Plug memory leak on failure to connect socket
  vfio scsi ui: Error-check qio_channel_socket_connect_sync() the same
    way
  qtest/qom-test: Shallow testing of qom-list / qom-get
  qtest/qom-test: Traverse entire QOM tree
  qtest/qom-test: Don't bother to execute QMP command quit
  MAINTAINERS: Cover tests/qtest/qom-test.c
  Revert "tests/qtest: use qos_printf instead of g_test_message"

Paolo Bonzini (7):
  python: mkvenv: fix messages printed by mkvenv
  MAINTAINERS: add a few more files to "Top Level Makefile and
    configure"
  rust: disable borrow_as_ptr warning
  rust: qemu-api-macros: support matching more than one error
  subprojects: update proc-macro2 and syn
  rust: move dependencies to rust/Cargo.toml
  user-exec: ensure interrupt_request is not used

Peter Maydell (14):
  tests/functional/test_aarch64_virt_gpu: Skip test if EGL won't
    initialize
  linux-user: Drop deprecated -p option
  target/arm: Implement CTZ, CNT, ABS
  scripts/kernel-doc: Avoid new Perl precedence warning
  docs/sphinx/kerneldoc.py: Handle new LINENO syntax
  tests/qtest/libqtest.h: Remove stray space from doc comment
  scripts: Import Python kerneldoc from Linux kernel
  scripts/kernel-doc: strip QEMU_ from function definitions
  scripts/kernel-doc: tweak for QEMU coding standards
  scripts/kerneldoc: Switch to the Python kernel-doc script
  scripts/kernel-doc: Delete the old Perl kernel-doc script
  MAINTAINERS: Put kernel-doc under the "docs build machinery" section
  target/arm: Correct condition of aa64_atomics feature function
  hw/arm/stm32f205_soc: Don't leak TYPE_OR_IRQ objects

Pierrick Bouvier (2):
  tests/functional/test_aarch64_device_passthrough: update image
  tests/functional/test_aarch64_rme: update image

Richard Henderson (146):
  semihosting: Retrieve stack top from image_info
  semihosting: Initialize heap once per process
  linux-user: Create target/elfload.c files
  linux-user: Move ppc uabi/asm/elf.h workaround to osdep.h
  linux-user: Move get_elf_cpu_model to target/elfload.c
  linux-user: Move get_elf_hwcap to {i386,x86_64}/elfload.c
  linux-user: Move hwcap functions to {arm,aarch64}/elfload.c
  linux-user: Move get_elf_hwcap to sparc/elfload.c
  linux-user: Move hwcap functions to ppc/elfload.c
  linux-user: Move get_elf_hwcap to loongarch64/elfload.c
  linux-user: Move get_elf_hwcap to mips/elfload.c
  linux-user: Move get_elf_hwcap to sh4/elfload.c
  linux-user: Move hwcap functions to s390x/elfload.c
  linux-user: Move get_elf_hwcap to riscv/elfload.c
  linux-user: Remove ELF_HWCAP
  linux-user: Remove ELF_HWCAP2
  linux-user: Move get_elf_platform to {i386,x86_64}/elfload.c
  linux-user/i386: Return const data from get_elf_platform
  linux-user: Move get_elf_platform to arm/elfload.c
  linux-user/loongarch64: Create get_elf_platform
  linux-user/hppa: Create get_elf_platform
  linux-user: Remove ELF_PLATFORM
  linux-user: Move get_elf_base_platform to mips/elfload.c
  linux-user: Move target_cpu_copy_regs decl to qemu.h
  linux-user: Create do_init_main_thread
  linux-user/i386: Create init_main_thread
  linux-user/arm: Create init_main_thread
  linux-user/arm: Remove a.out startup remenents
  linux-user/aarch64: Create init_main_thread
  linux-user/sparc: Create init_main_thread
  linux-user/ppc: Create init_main_thread
  linux-user/loongarch64: Create init_main_thread
  linux-user/mips: Create init_main_thread
  linux-user/microblaze: Create init_main_thread
  linux-user/openrisc: Create init_main_thread
  linux-user/sh4: Create init_main_thread
  linux-user/m68k: Create init_main_thread
  linux-user/alpha: Create init_main_thread
  linux-user/s390x: Create init_main_thread
  linux-user/riscv: Create init_main_thread
  linux-user/hppa: Create init_main_thread
  linux-user/xtensa: Create init_main_thread
  linux-user/hexagon: Create init_main_thread
  linux-user: Remove do_init_main_thread
  hw/core: Dump cpu_reset in the reset.exit phase
  hw/core: Use qemu_log_trylock/unlock in cpu_common_reset_exit
  linux-user: Tidy print_socket_protocol
  linux-user/x86_64: Convert target_elf_gregset_t to a struct
  linux-user/i386: Convert target_elf_gregset_t to a struct
  linux-user/arm: Convert target_elf_gregset_t to a struct
  linux-user/aarch64: Convert target_elf_gregset_t to a struct
  linux-user/ppc: Convert target_elf_gregset_t to a struct
  linux-user/loongarch64: Convert target_elf_gregset_t to a struct
  linux-user/mips: Convert target_elf_gregset_t to a struct
  linux-user/microblaze: Convert target_elf_gregset_t to a struct
  linux-user/openrisc: Convert target_elf_gregset_t to a struct
  linux-user/sh4: Convert target_elf_gregset_t to a struct
  linux-user/m68k: Convert target_elf_gregset_t to a struct
  linux-user/s390x: Convert target_elf_gregset_t to a struct
  linux-user/xtensa: Convert target_elf_gregset_t to a struct
  linux-user: Update comment for target_elf_gregset_t
  linux-user: Declare elf_core_copy_regs in loader.h
  linux-user: Rename USE_ELF_CORE_DUMP to HAVE_ELF_CORE_DUMP
  linux-user: Move elf_core_copy_regs to {i386,x86_64}/elfload.c
  linux-user: Move elf_core_copy_regs to arm/elfload.c
  linux-user: Move elf_core_copy_regs to aarch64/elfload.c
  linux-user: Move elf_core_copy_regs to ppc/elfload.c
  linux-user: Move elf_core_copy_regs to loongarch64/elfload.c
  linux-user: Move elf_core_copy_regs to mips/elfload.c
  linux-user: Move elf_core_copy_regs to microblaze/elfload.c
  linux-user: Move elf_core_copy_regs to openrisc/elfload.c
  linux-user: Move elf_core_copy_regs to sh4/elfload.c
  linux-user: Move elf_core_copy_regs to m68k/elfload.c
  linux-user: Move elf_core_copy_regs to s390x/elfload.c
  linux-user: Move elf_core_copy_regs to xtensa/elfload.c
  linux-user: Remove target_elf_greg_t, tswapreg from elfload.c
  linux-user/i386: Create target_ptrace.h
  linux-user/i386: Expand target_elf_gregset_t
  linux-user/x86_64: Create target_ptrace.h
  linux-user/x86_64: Expand target_elf_gregset_t
  linux-user/x86_64: Fix dump of fs_base, gs_base
  linux-user/aarch64: Create target_ptrace.h
  linux-user/aarch64: Expand target_elf_gregset_t
  linux-user/arm: Create target_ptrace.h
  linux-user/arm: Expand target_elf_gregset_t
  linux-user/loongarch64: Create target_ptrace.h
  linux-user/loongarch64: Expand target_elf_gregset_t
  linux-user/m68k: Expand target_elf_gregset_t
  linux-user/microblaze: Create target_ptrace.h
  linux-user/microblaze: Fold target_pt_regs.r* to an array
  linux-user/microblaze: Expand target_elf_gregset_t
  linux-user/mips: Create target_ptrace.h
  linux-user/mips: Use target_ulong for target_elf_greg_t
  linux-user/openrisc: Create target_ptrace.h
  linux-user/openrisc: Expand target_elf_gregset_t
  linux-user/ppc: Create target_ptrace.h
  linux-user/ppc: Expand target_elf_gregset_t
  linux-user/s390x: Create target_ptrace.h
  linux-user/s390x: Expand target_elf_gregset_t
  linux-user/sh4: Create target_ptrace.h
  linux-user/sh4: Expand target_elf_gregset_t
  linux-user/xtensa: Create target_ptrace.h
  linux-user/xtensa: Expand target_elf_gregset_t
  linux-user: Move init_guest_commpage to x86_64/elfload.c
  linux-user: Move init_guest_commpage to arm/elfload.c
  linux-user: Move init_guest_commpage to hppa/elfload.c
  linux-user: Replace init_guest_commpage macro with function
  linux-user: Move get_vdso_image_info to arm/elfload.c
  linux-user: Remove ELF_EXEC_PAGESIZE
  linux-user: Remove redundant ELF_DATA definitons
  linux-user: Move elf parameters to {i386,x86_64}/target_elf.h
  linux-user: Move elf parameters to {arm,aarch64}/target_elf.h
  linux-user: Move elf parameters to sparc/target_elf.h
  linux-user: Move elf parameters to ppc/target_elf.h
  linux-user: Move elf parameters to loongarch64/target_elf.h
  linux-user: Move elf parameters to {mips,mips64}/target_elf.h
  linux-user: Move elf parameters to microblaze/target_elf.h
  linux-user: Move elf parameters to openrisc/target_elf.h
  linux-user: Move elf parameters to sh4/target_elf.h
  linux-user: Move elf parameters to m68k/target_elf.h
  linux-user: Move elf parameters to alpha/target_elf.h
  linux-user: Move elf parameters to s390x/target_elf.h
  linux-user: Move elf parameters to riscv/target_elf.h
  linux-user: Move elf parameters to hppa/target_elf.h
  linux-user: Move elf parameters to xtensa/target_elf.h
  linux-user: Move elf parameters to hexagon/target_elf.h
  linux-user: Standardize on ELF_MACHINE not ELF_ARCH
  linux-user: Rename elf_check_arch
  linux-user: Remove ELIBBAD from elfload.c
  linux-user: Remove MAP_DENYWRITE from elfload.c
  linux-user: Move arch_parse_elf_property to aarch64/elfload.c
  linux-user: Remove a.out declarations from elfload.c
  linux-user/sparc: Create target_ptrace.h
  linux-user: Remove target_pt_regs from target_syscall.h
  target/arm: Add feature predicate for FEAT_CSSC
  target/arm: Implement MIN/MAX (immediate)
  target/arm: Implement MIN/MAX (register)
  target/arm: Split out gen_wrap2_i32 helper
  target/arm: Enable FEAT_CSSC for -cpu max
  qemu/atomic: Finish renaming atomic128-cas.h headers
  qemu/atomic: Add atomic16 primitives for xchg, fetch_and, fetch_or
  accel/tcg: Add cpu_atomic_*_mmu for 16-byte xchg, fetch_and, fetch_or
  tcg: Add tcg_gen_atomic_{xchg,fetch_and,fetch_or}_i128
  target/arm: Rename isar_feature_aa64_atomics
  target/arm: Implement FEAT_LSE128
  target/arm: Enable FEAT_LSE128 for -cpu max

Smail AIDER (1):
  target/arm: Trap PMCR when MDCR_EL2.TPMCR is set

Stefan Hajnoczi (2):
  Update version for the v10.1.0 release
  Open 10.2 development tree

Stefan Weil (1):
  CI: Use mingw-w64-x86_64-curl-winssl instead of mingw-w64-x86_64-curl
    for Windows build

Steve Sistare (1):
  hw/intc/arm_gicv3_kvm: preserve pending interrupts during cpr

Thomas Huth (28):
  tests/functional: Use more fine-grained locking when looking for free
    ports
  tests/functional: Rework the migration test to have target-specific
    files
  tests/functional: Rework the multiprocess test to have target-specific
    files
  tests/functional/meson.build: Split timeout settings by target
  tests/functional/meson.build: Allow tests to reside in subfolders
  tests/functional: Move aarch64 tests into architecture specific folder
  tests/functional: Move alpha tests into architecture specific folder
  tests/functional: Move arm tests into architecture specific folder
  tests/functional: Move avr tests into architecture specific folder
  tests/functional: Move hppa tests into architecture specific folder
  tests/functional: Move i386 tests into architecture specific folder
  tests/functional: Move loongarch64 tests into architecture specific
    folder
  tests/functional: Move m68k tests into architecture specific folder
  tests/functional: Move microblaze tests into architecture specific
    folder
  tests/functional: Move mips tests into target-specific folders
  tests/functional: Move or1k tests into target-specific folders
  tests/functional: Move ppc/ppc64 tests into target-specific folders
  tests/functional: Move riscv32/riscv64 tests into target-specific
    folders
  tests/functional: Move rx test into target-specific folders
  tests/functional: Move s390x tests into target-specific folders
  tests/functional: Move sh4/sh4eb tests into target-specific folders
  tests/functional: Move sparc/sparc64 tests into target-specific
    folders
  tests/functional: Move x86_64 tests into target-specific folder
  tests/functional: Move xtensa tests into target-specific folder
  tests/functional: Move the generic tests to a subfolder
  MAINTAINERS: Adjust wildcards for the migration, multiprocess and
    replay tests
  hw/intc/loongarch_pch_pic: Fix ubsan warning and endianness issue
  qga: Fix ubsan warning

WANG Rui (1):
  target/loongarch: Guard 64-bit-only insn translation with TRANS64
    macro

Xiaoyao Li (1):
  x86/loader: Don't update kernel header for CoCo VMs

Xin Wang (1):
  target/i386: Add support for save/load of exception error code

Zero Tang (1):
  i386/tcg/svm: fix incorrect canonicalization

minglei.liu (1):
  qga: Fix truncated output handling in guest-exec status reporting

Łukasz Stelmach (1):
  linux-user: do not print IP socket options by default

-- 
2.47.2


