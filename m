Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF8526296FE
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 12:16:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiKOLQS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 06:16:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiKOLQB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 06:16:01 -0500
Received: from mail-wm1-x349.google.com (mail-wm1-x349.google.com [IPv6:2a00:1450:4864:20::349])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C4041D317
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 03:15:52 -0800 (PST)
Received: by mail-wm1-x349.google.com with SMTP id x10-20020a05600c420a00b003cfa33f2e7cso8185328wmh.2
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 03:15:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cvPpR2F+tEbIsjOdTWxZyeLbkSo/LagbLW2D8ypevZY=;
        b=PUQnk9WPLhh/n8IxX1FEIepjld99wsmhlNBVZQ4ObMBcKbbavCbtoQRN20oETit7q6
         KkR+CGDu6Av8sT6uLyOPP27vpq5CCpaRNQ27f0Mq1nzQitXUowQXUkDifSsLvUgJONp6
         wl8Nh6s9cRriyoYDp/Ep5UuzkxHiWAmI5Q4AhV7ETjUURRU8I1j78qhQDvF468hb95Kq
         BK26tl4hsSTP0VmNqDiA2OrPLzrK5lsrMnnOWndKzObPi+IPzd+gvNz9GcKlXDzHusCf
         XQEwvR0SYaKhfuvHXSfAQinrUZWH5PmhYDYljlmGURB3v4o4mg10in2P71zSXJ8HMzPr
         vLeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cvPpR2F+tEbIsjOdTWxZyeLbkSo/LagbLW2D8ypevZY=;
        b=Qn3LYlVMDSZKwoJ4F36loWd7e4yh3g/SKvMfMgfCZd/uHUvraTUFqmWFNHQ8yhIYFr
         eT1oTu4Qf5uz9oKgewKSTFTWa34omq+PEE2q33XMYMI8Z1TBhg1LW+ey+Lf9Y9wBrPCQ
         hsBCy/XZPYoDS2Rlmse8BfNlrb56ZZ230oudUhJNoLw5+ltuzJCrCu3ZGLDbwyZvDyYN
         WPrdlZZ7CSVRgjCUadHqcbXigBo60sAnzJbZTZ0bJT+hxdfq/k/0Gg5RbciT1THR4VvX
         UCJeVFfw9vtvwQpKbfjnNhBJx19Y9MxYO1oTIFijyYTe9sgbuzK11tHMVr41WfbyDfGX
         avRg==
X-Gm-Message-State: ANoB5plxIhw5HPBJyYnAbwOoWf0IjYhciRVYDM/mGbkVJluBKg0h7btW
        3DPkVSttPemWDzv3aPiCjN6VDbeL47aA4Zpotm3JGnbgpJXqOq5cklaHIKbWLYNVrKG6svvS0sd
        v0+ChF/dL2mw54k6gJYZljMG0jFu1syXqSdOndiqOkrHQ6nVtWmtBRjI=
X-Google-Smtp-Source: AA0mqf5iCdXdz/Nrwkq/jCBFBzKTuOujCIbm4DbZMLn5RCLq/Fq5uzz8L8e6xsEOpE/CpA6DyaaywQO/EQ==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:a55:b0:3cf:d8b1:246c with SMTP id
 c21-20020a05600c0a5500b003cfd8b1246cmr1046645wmq.165.1668510951163; Tue, 15
 Nov 2022 03:15:51 -0800 (PST)
Date:   Tue, 15 Nov 2022 11:15:32 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221115111549.2784927-1-tabba@google.com>
Subject: [PATCH kvmtool v1 00/17] Use memfd for guest vm memory allocation
From:   Fuad Tabba <tabba@google.com>
To:     kvm@vger.kernel.org
Cc:     julien.thierry.kdev@gmail.com, andre.przywara@arm.com,
        alexandru.elisei@arm.com, will@kernel.org, tabba@google.com
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

This patch series moves kvmtool from allocating guest vm memory
using anonymous mmap to using memfd/ftruncate. The main
motivation is to ease the transition to the fd-based kvm guest
memory proposal [*]. It also facilitates using ipc memory sharing
should that be needed in the future. Moreover, it removes the
need for using temporary files if the memory is backed by
hugetlbfs.

In the process of this rework, this patch series fixes a bug
(uninitalized return value). It also adds a memory allocation
function that allocates aligned memory without the need to
over-map/allocate. This facilitates refactoring, which simplifies
the code and removes a lot of the arch-specific code.

Cheers,
/fuad

[*] https://lore.kernel.org/all/20221025151344.3784230-1-chao.p.peng@linux.intel.com/

Fuad Tabba (17):
  Initialize the return value in kvm__for_each_mem_bank()
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
  Replace kvm_arch_delete_ram with kvm_delete_ram
  Remove no-longer unused macro
  Factor out set_user_memory_region code
  Pass the memory file descriptor and offset when registering ram

 arm/aarch64/pvtime.c              |  20 ++++-
 arm/include/arm-common/kvm-arch.h |   7 --
 arm/kvm.c                         |  35 +++------
 framebuffer.c                     |   2 +
 hw/cfi_flash.c                    |   4 +-
 hw/vesa.c                         |  17 ++++-
 include/kvm/framebuffer.h         |   1 +
 include/kvm/kvm.h                 |  19 ++---
 include/kvm/util.h                |   7 +-
 kvm.c                             |  69 ++++++++++-------
 mips/kvm.c                        |  11 +--
 powerpc/kvm.c                     |   7 +-
 riscv/include/kvm/kvm-arch.h      |   7 --
 riscv/kvm.c                       |  26 ++-----
 util/util.c                       | 119 +++++++++++++++++++++++-------
 vfio/core.c                       |   3 +-
 x86/kvm.c                         |  11 +--
 17 files changed, 209 insertions(+), 156 deletions(-)


base-commit: e17d182ad3f797f01947fc234d95c96c050c534b
-- 
2.38.1.431.g37b22c650d-goog

