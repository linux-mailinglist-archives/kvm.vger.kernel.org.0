Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FBDF74A333
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 19:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232196AbjGFRik (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jul 2023 13:38:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231280AbjGFRia (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jul 2023 13:38:30 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E2F2129
        for <kvm@vger.kernel.org>; Thu,  6 Jul 2023 10:38:27 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id ca18e2360f4ac-77acb04309dso36876339f.2
        for <kvm@vger.kernel.org>; Thu, 06 Jul 2023 10:38:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1688665107; x=1691257107;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Je8gIEbT5s13GIAqKj2HB64wQADorHFR9nl9yaVe0Gc=;
        b=Oow7tc9eiiHyIK+wEJ7fqUlvDoPF6lexk4ADTOxvxv7RFXS4++X+T3gb4liMGDslBF
         UiS7iMcNsyQJTlt109e6XJCsFFYD7vXH+IxQndpLUyH6RFZGp7RS2UGSGaSP8TbtxCD4
         zTRrsz+84iL7miV2Hb54+gtYKoQyepy2HkDzoHxhfvAc11/C4jBMbv2Ke4eBLRNaDyy6
         Bqk80ItVqdH3aYG5LTnUwP2Dx5CdMiqEoKzLPew0BAVIbZdm5aVrlODOt1ISKTt2HoMG
         YLu85Ns8xeNDVTPKZ97PLOhCG55NAdCrDXeyakCCdUgsVaWF/kTNcEnENZ4cvFq4mTQ5
         aiwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688665107; x=1691257107;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Je8gIEbT5s13GIAqKj2HB64wQADorHFR9nl9yaVe0Gc=;
        b=ZHaXXp9ri6HSo/7pwQtZJ5JzDRn/4PO3soVgk8Ia145Sxk2HzdNqwvnSLg9hmCL1yg
         T4bh6Glr6HtMpBIvoR8WKXoTdFXcgdN0aKItJOn6Rwiehw8i9T4/KqnjsPEeN3xiHjPk
         3u4NzU6OoncqZE8up9/5htIBqhyGFmhHfqiDJe4LXj3+lKzGUPW45onFtq8KVmwZzVfX
         cf4kOB6ykPUQYSqj8zGBVCqAXygH+S6bvKJtmdwuwtsVLCv42w3ORf8e63lvOJNqyAMD
         RNO1c8V/w5z7ATBbEN3Qen5PRGvNjNGffRx6vgDyw2aqeULPTp0Yghb2SuQJxHY3otPp
         pqDA==
X-Gm-Message-State: ABy/qLakT0hshdpcaFbU7UVxtbUHTPYTu6ZVaOhZ1x2ZXMU4rJIGvQsL
        jlmSGM7KZFO+kEPEUEmgq9ll8Q==
X-Google-Smtp-Source: APBJJlGKegKZhhM78tj/W/IuVkLr8ajNow41J+hcDbMRxSild9nMbCVhNBjUO+2pzLxxWumEX/CeIA==
X-Received: by 2002:a05:6602:21cc:b0:786:6f34:d16a with SMTP id c12-20020a05660221cc00b007866f34d16amr4403325ioc.17.1688665106868;
        Thu, 06 Jul 2023 10:38:26 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id q8-20020a0566380ec800b0042b70c5d242sm633528jas.116.2023.07.06.10.38.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jul 2023 10:38:26 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH v3 0/8] RISC-V SBI enable/disable, Zbb, Zicboz, and Ssaia support
Date:   Thu,  6 Jul 2023 23:07:56 +0530
Message-Id: <20230706173804.1237348-1-apatel@ventanamicro.com>
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

The latest KVM in Linux-6.4 has support for:
1) Enabling/disabling SBI extensions from KVM user-space
2) Zbb ISA extension support
3) Zicboz ISA extension support
4) Ssaia ISA extension support

This series adds corresponding changes in KVMTOOL to use the above
mentioned features for Guest/VM.

These patches can also be found in the riscv_sbi_zbb_zicboz_ssaia_v3
branch at: https://github.com/avpatel/kvmtool.git

Changes since v2:
 - Rebased on commit 0b5e55fc032d1c6394b8ec7fe02d842813c903df
 - Updated PATCH1 to sync-up header with released Linux-6.4

Changes since v1:
 - Rebased on commit b17552ee6c9728c20c9d0bd037ef134277daaa40
 - Fixed compile error for KVMTOOL x86 by adding __DECLARE_FLEX_ARRAY()
   in include/linux/stddef.h

Andrew Jones (1):
  riscv: Add Zicboz extension support

Anup Patel (7):
  Sync-up headers with Linux-6.4
  riscv: Allow setting custom mvendorid, marchid, and mimpid
  riscv: Allow disabling SBI extensions for Guest
  riscv: Sort the ISA extension array alphabetically
  riscv: Add zbb extension support
  riscv: Add Ssaia extension support
  riscv: Fix guest RAM alloc size computation for RV32

 arm/aarch64/include/asm/kvm.h       |  38 ++++++++++
 include/linux/kvm.h                 |  57 +++++++++------
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
 12 files changed, 419 insertions(+), 47 deletions(-)

-- 
2.34.1

