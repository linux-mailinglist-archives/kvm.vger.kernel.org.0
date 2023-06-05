Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 766C7722818
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 16:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234235AbjFEOCj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 10:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233559AbjFEOCf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 10:02:35 -0400
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D270C18E
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 07:02:19 -0700 (PDT)
Received: by mail-oo1-xc33.google.com with SMTP id 006d021491bc7-557ca32515eso3498678eaf.3
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 07:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1685973739; x=1688565739;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jQHhQgHLFcTI+oySPFMDOXN/mdm0QKm0Mn5l2cgpLRc=;
        b=dbTkkETUoOppg3JrY9KNdnqyE0GjjhH1HxWWABQ+9NRUztKHxjeLm5DfZVOxr5CKZm
         BudHhva880TPQVtPJzJLT+Ae4uhVfgJXDGA6F6cWcKBvwn1sXSxGoaCv3/h08vvV3YdV
         /lCr1UQrc7YB/IJzWsOXfu3ejbLnCwhAeJeJfa250LrOVpRMrixNC51dkmy/eOHxAYT7
         EiI5yCDFKLgehfhhrhgm7ABpMO8m6DwWyjbpWFTEn6HEpOLAf1WhGif3wqDQXrbR3Rjz
         ILDSbLoym5MboPo+9RgwU7PvEda9LYvhNGsvgB9ClEHL8WF6NVPvnEQ/GbX3kt9Nozx/
         tstg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685973739; x=1688565739;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jQHhQgHLFcTI+oySPFMDOXN/mdm0QKm0Mn5l2cgpLRc=;
        b=TzCqeo4ekT1wy3u9LK2zjZecwiGKLtMig+21gaMvzUfzOWaIL2UJV9y4J+VWdSN8yv
         kZltmfHXcfVIj5JrKF5ul3wPyCX85fwG7kwVGC4v1/Slm7VtfbjJIie/gLSzJlZd/kPm
         QxMe1+9ipBvicnr/tLzdTBzQ0UO1YWAoDo8bceUZxmijU4g3c8JVcmndGtYkDPvO39NN
         +LomHhBFeLAxGWAWQHnGtQrUEqY+6lgEsc0eLGsNw/aTeu51cjAfQWt+/FswFp9BCV+I
         E7PnVH/BioyZ/z7oCgZ3p/FYvlYfy7qDZPmdAflXI221z5+ZB/jg2VWlmZMNsBl0l+Om
         XuFg==
X-Gm-Message-State: AC+VfDxA9MPAnQMnwN072nEPoWO31O+vEpXQCE09ierSBSHXI8U6f3Yu
        285dQFR5t8+RIDpPSTpSj9kT2w==
X-Google-Smtp-Source: ACHHUZ4ra0t3UGxeflg68VgwHyNFQWfHICOi/IYSU5ECbzyvdRWaiB4XbXUgIbmM5l5Cy3lGY51Jew==
X-Received: by 2002:a4a:d0a7:0:b0:558:cb7e:c52e with SMTP id t7-20020a4ad0a7000000b00558cb7ec52emr2240469oor.8.1685973738471;
        Mon, 05 Jun 2023 07:02:18 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id f12-20020a4ace8c000000b0055ab0abaf31sm454787oos.19.2023.06.05.07.02.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 07:02:18 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH v2 0/8] RISC-V SBI enable/disable, Zbb, Zicboz, and Ssaia support
Date:   Mon,  5 Jun 2023 19:32:00 +0530
Message-Id: <20230605140208.272027-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The latest KVM in Linux-6.4-rc5 has support for:
1) Enabling/disabling SBI extensions from KVM user-space
2) Zbb ISA extension support
3) Zicboz ISA extension support
4) Ssaia ISA extension support

This series adds corresponding changes in KVMTOOL to use the above
mentioned features for Guest/VM.

These patches can also be found in the riscv_sbi_zbb_zicboz_ssaia_v2
branch at: https://github.com/avpatel/kvmtool.git

Changes since v1:
 - Rebased on commit b17552ee6c9728c20c9d0bd037ef134277daaa40
 - Fixed compile error for KVMTOOL x86 by adding __DECLARE_FLEX_ARRAY()
   in include/linux/stddef.h

Andrew Jones (1):
  riscv: Add Zicboz extension support

Anup Patel (7):
  Sync-up headers with Linux-6.4-rc5
  riscv: Allow setting custom mvendorid, marchid, and mimpid
  riscv: Allow disabling SBI extensions for Guest
  riscv: Sort the ISA extension array alphabetically
  riscv: Add zbb extension support
  riscv: Add Ssaia extension support
  riscv: Fix guest RAM alloc size computation for RV32

 arm/aarch64/include/asm/kvm.h       |  38 ++++++++++
 include/linux/kvm.h                 |  57 +++++++++------
 include/linux/stddef.h              |  16 +++++
 include/linux/virtio_blk.h          | 105 ++++++++++++++++++++++++++++
 include/linux/virtio_config.h       |   6 ++
 include/linux/virtio_net.h          |   5 ++
 riscv/fdt.c                         |  19 ++++-
 riscv/include/asm/kvm.h             |  56 ++++++++++++++-
 riscv/include/kvm/kvm-config-arch.h |  51 +++++++++++++-
 riscv/include/kvm/kvm-cpu-arch.h    |  19 +++--
 riscv/kvm-cpu.c                     |  45 +++++++++++-
 riscv/kvm.c                         |  15 +++-
 x86/include/asm/kvm.h               |  50 ++++++++++---
 13 files changed, 435 insertions(+), 47 deletions(-)

-- 
2.34.1

