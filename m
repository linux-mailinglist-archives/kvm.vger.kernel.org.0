Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E67D1640C5E
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 18:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbiLBRoY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 12:44:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232550AbiLBRoW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 12:44:22 -0500
Received: from mail-ej1-x649.google.com (mail-ej1-x649.google.com [IPv6:2a00:1450:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 299CCDEA48
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 09:44:21 -0800 (PST)
Received: by mail-ej1-x649.google.com with SMTP id hs42-20020a1709073eaa00b007c00fb5a509so3773949ejc.17
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 09:44:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ELTfV489YYSjtyZnXqT7/AolaabuOtlMIhcgXvH8VeU=;
        b=I7TuXAoctAgeB1mXJ2K/ha5qYM8y39STgRq6R7rZGGpFPoW+fiaDr7LJh0w0TrBbjn
         wSOQBhugGRx+fviEsw6u/NrXg6Bog0L14TY4Gz3wQyeVkBz6ZR6haPM6ip6xVK7Zpr3v
         Si0z4bO758HMmZqJ5lAhyKxg/efd1vbl6RaumTgkwjjqteWi7HEf/44NV/42uHkIfqGU
         N5kjHG8TWufE0m1y7fJAzISkDzZjKO+HpXqri48Mvv1YligGn6+KDJubSqbTuBlsnfmj
         KrfMlMHAZ/W8VvWprU0nwB1d5HT2UPHsc8Oz50nrEbinqbrqco+4VxKD57oon800Fg/C
         KMjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ELTfV489YYSjtyZnXqT7/AolaabuOtlMIhcgXvH8VeU=;
        b=axxoLP/1KjFtA8SB3E5w3wcgqSB7ow0L5vwh/w53UQHfGC1488SVvOcG05/sFj8Y7q
         3qlj81GoRzbWjDxK6rY8sRzQwlo+OPoibeoZb8xVImQ5hugUoyLRPjyUL8LtC2kMMxyR
         ol1VWgc6qtPnWrxgQnQfzCorewsNrcga7niU/vncoh2P4ndaj4KO28w9puuHdCL9Jfbd
         BqPiVKYmg0qFec6MIKU18tBM17HrOdRnAq6vjG+f7USYhx5cYfEBLT5deVF6+Kcgt4z5
         uNVSkdkSQhiozFeMLUpJAGokpbpuLLnQD4g8iV2Lpa9ls635/oqeQKhmPak6h9TpRUqb
         UO0Q==
X-Gm-Message-State: ANoB5pnC2CBbDheyuqTidCmwHn8qq/OJeWfHu1h/Mx3RjF8ZF5fAT2Bv
        moDoznLECM9o/OGlIoEbMjXajrMMAvkp/9+G6JaUQdLzRy4OEPB+0i1wI0UAOiim1PQUZ7lWi3t
        d3BR5FQV+vMw434KhCxT2laKZl9+8KhhsgvrJ7pMBwRkW5Pu1TJk2AKc=
X-Google-Smtp-Source: AA0mqf7JKfJ4M88hOlbKL6cRcsExn1IxWYtL/RkfSZEUmQqfsK3atWZGQcaT6es1AZPQCbBTAmgeK9RiYg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a17:907:6daa:b0:7ba:e537:c64b with SMTP id
 sb42-20020a1709076daa00b007bae537c64bmr39114403ejc.180.1670003059545; Fri, 02
 Dec 2022 09:44:19 -0800 (PST)
Date:   Fri,  2 Dec 2022 17:43:45 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221202174417.1310826-1-tabba@google.com>
Subject: [RFC PATCH kvmtool v1 00/32] Add support for restricted guest memory
 in kvmtool
From:   Fuad Tabba <tabba@google.com>
To:     kvm@vger.kernel.org
Cc:     julien.thierry.kdev@gmail.com, andre.przywara@arm.com,
        alexandru.elisei@arm.com, alex.bennee@linaro.org, will@kernel.org,
        tabba@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The main goal of this patch series is to add support for the the
restricted guest memory proposali (V9) [1] to kvmtool (V10 was
released today [2]). This proposal is still being discussed, but
it seems to be close to its final form. The intention is that
the restricted guest memory would be used in various confidential
computing environments, such as TDX and pKVM.

This series is intended to work with the kernel in of the
V9 proposal [1], in addition to work to port it to
pKVM [3]. It has been tested on qemu/arm64.

The patch series is divided as follows:

Patches 1--4:
General fixes and tidying up

Patches 5--18:
Move kvmtool from allocating guest vm memory using anonymous mmap
to using memfd/ftruncate. The main motivation is to support the
fd-based kvm guest memory proposal [1, 2]. It also facilitates using
ipc memory sharing should that be needed in the future. It also
moves kvmtool to using only a file based backend for guest memory
allocation, with the file descriptor being the canonical
reference to guest memory. The idea is to refer to all allocated
guest memory via a file descriptor.

Patches 19--28:
Add architecture-independent framework to support restricted
guest memory.

Patches 29--32:
Add pKVM-specific (arm64) support for restricted guest memory.

I had posted a subset of this series earlier covering patches
1--18  [4]. This series incorporates fixes and suggestions from
Alex into those patches.

Cheers,
/fuad

[1] https://lore.kernel.org/all/20221025151344.3784230-1-chao.p.peng@linux.intel.com/
[2] https://lore.kernel.org/all/20221202061347.1070246-1-chao.p.peng@linux.intel.com/
[3] https://android-kvm.googlesource.com/kvmtool/+/refs/heads/tabba/fdmem-v9-core
[4] https://lore.kernel.org/all/20221115111549.2784927-1-tabba@google.com/

Fuad Tabba (31):
  Initialize the return value in kvm__for_each_mem_bank()
  Remove newline from end of die() aborts
  Make mmap_hugetlbfs() static
  Rename parameter in mmap_anon_or_hugetlbfs()
  Add hostmem va to debug print
  Factor out getting the hugetlb block size
  Use memfd for hugetlbfs when allocating guest ram
  Make blk_size a parameter and pass it to mmap_hugetlbfs()
  Use memfd for all guest ram allocations
  Allocate pvtime memory with memfd
  Allocate vesa memory with memfd
  Add a function that allocates aligned memory if specified
  Use new function to align memory
  Remove struct fields and code used for alignment
  Replace kvm__arch_delete_ram() with kvm__delete_ram()
  Remove no-longer used macro
  Factor out set_user_memory_region code
  Pass the memory file descriptor and offset when registering ram
  Add memfd_restricted system call
  Add kvm linux headers and structure extensions for restricted_fd
  Add option for enabling restricted memory for guests
  Change guest ram mapping from private to shared
  Change pvtime mapping from private to shared
  Change vesa mapping from private to shared
  Allocate guest memory as restricted if needed
  Use the new fd-based extended memory region
  Track the memfd in the bank
  Add functions for mapping/unmapping guest memory
  pkvm: Enable exit hypercall capability if supported
  pkvm: Handle (un)share hypercalls coming from the guest
  pkvm: Unmap all guest memory after initialization

Will Deacon (1):
  pkvm: Add option to spawn a protected vm in pkvm

 arm/aarch32/include/kvm/kvm-arch.h |   1 +
 arm/aarch64/include/asm/kvm.h      |   7 +
 arm/aarch64/include/kvm/kvm-arch.h |   1 +
 arm/aarch64/kvm.c                  |  26 +++
 arm/aarch64/pvtime.c               |  20 +-
 arm/fdt.c                          |  18 ++
 arm/include/arm-common/fdt-arch.h  |   2 +-
 arm/include/arm-common/kvm-arch.h  |   7 -
 arm/kvm-cpu.c                      |  58 ++++++
 arm/kvm.c                          |  41 ++--
 arm/pci.c                          |   3 +
 builtin-run.c                      |   7 +
 framebuffer.c                      |   2 +
 hw/cfi_flash.c                     |   4 +-
 hw/vesa.c                          |  17 +-
 include/kvm/framebuffer.h          |   1 +
 include/kvm/kvm-config.h           |   2 +
 include/kvm/kvm.h                  |  25 ++-
 include/kvm/util.h                 |   5 +-
 include/linux/kvm.h                |  19 ++
 kvm.c                              | 301 ++++++++++++++++++++++++++---
 mips/kvm.c                         |  11 +-
 powerpc/kvm.c                      |   7 +-
 riscv/include/kvm/kvm-arch.h       |   7 -
 riscv/kvm.c                        |  26 +--
 util/util.c                        | 131 ++++++++++---
 vfio/core.c                        |   3 +-
 virtio/pci-modern.c                |   3 +
 x86/kvm.c                          |  11 +-
 29 files changed, 606 insertions(+), 160 deletions(-)


base-commit: e17d182ad3f797f01947fc234d95c96c050c534b
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

