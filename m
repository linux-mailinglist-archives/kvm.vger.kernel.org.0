Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 676BA592CFD
	for <lists+kvm@lfdr.de>; Mon, 15 Aug 2022 12:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242321AbiHOKOC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Aug 2022 06:14:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242379AbiHOKNh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Aug 2022 06:13:37 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8101723BC3
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 03:13:36 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id ch17-20020a17090af41100b001fa74771f61so1901317pjb.0
        for <kvm@vger.kernel.org>; Mon, 15 Aug 2022 03:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=jTYWp0STDqccCVecom1xyjouuUhupg0vLX0fgOim7yE=;
        b=Bj7GtZHx2IIFaiZESQaX+v8pGK3uPxre7HXpCjMzDshaH/4ZR+EVrhCJPM7waiIJKY
         n6/wiWdN3cKz8Icm03TGDcAuIofZ0Q6wq15aazoa4Z62a2nZdhOXB9NoKCOVnlX2ymV8
         tXL9QbotOG+In2Ew0WS2UV7BWjT5krFmbSKzkSYWdV+rppfPxFyBsdMTejWkxIXRoNqq
         r0hIgIZo0h/ebSw8+yvF1PZWxT0r8XMnaSRdQuz6/3FLbvyiFcVHvEh4IZW3xrOhuEBn
         RwhKiMyYcSc8znsxK0GwHtxvRHuRWyHWM7fRHwxx/WCgsz3Gf4wxgjYHIQ7gy3jmWsB/
         mbDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=jTYWp0STDqccCVecom1xyjouuUhupg0vLX0fgOim7yE=;
        b=LBE1X6Umd9/gFWJONhHTijw2sZ1nePYn06Ctyeu9MNKJM+4LMP7wzTDR56BmplGcB8
         GEmeEWy/ZY7SlW6Fxgpdpt6zBDZhS1B++/vouL8xww5t5K4luLst+xUInkK8MNzgibn4
         nEFKChrP5HyWrWpUh6QawImulLorY4XkZVhS5OddlWlA2STUqraUUKzOfOzOTaN4m3XJ
         j16Vt54BkHiw25hfpBiFyF7RL8NEbGbG0LRqDv7VDP7JYrggQVmO/hLvQBxrnm9cAlO5
         p97oF0g9LN8j+8o3yxe1AfpBEwUHCQYfwOv7kzvo85FfdrYP/E8sGTW/sH4G2gXQ6ooX
         xbQQ==
X-Gm-Message-State: ACgBeo1oggmsCXANFLIu2aOxq62f5CUtD3LbZPM5dpV14lI3keCl4jAr
        WTx6kzh/DicLuCZ533Erxos7wg==
X-Google-Smtp-Source: AA6agR5tQYX3b4bE0cTfPyGbwqBXSWLbT4LiwJWFjBLzIPzUCho2Oe6FfvCJ7cyCM2MHK0MTnm7vvQ==
X-Received: by 2002:a17:902:e5cf:b0:170:d0c9:2e6e with SMTP id u15-20020a170902e5cf00b00170d0c92e6emr16068158plf.64.1660558415683;
        Mon, 15 Aug 2022 03:13:35 -0700 (PDT)
Received: from anup-ubuntu64-vm.. ([171.76.84.46])
        by smtp.gmail.com with ESMTPSA id i190-20020a6254c7000000b0052d4f2e2f6asm6267437pfb.119.2022.08.15.03.13.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Aug 2022 03:13:34 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH kvmtool 0/5] KVMTOOL RISC-V Svpbmt and Sstc Support
Date:   Mon, 15 Aug 2022 15:43:20 +0530
Message-Id: <20220815101325.477694-1-apatel@ventanamicro.com>
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

The latest Linux-6.0-rc1 has support for Svpbmt and Sstc extensions
in KVM RISC-V. This series adds corresponding changes in KVMTOOL to
allow Guest/VM use these new RISC-V extensions.

The PATCH5 is an unrelated fix which was discovered while developing
this series.

These patches can also be found in the riscv_svpbmt_sstc_v1 branch
at: https://github.com/avpatel/kvmtool.git

Anup Patel (3):
  Update UAPI headers based on Linux-6.0-rc1
  riscv: Add Svpbmt extension support
  riscv: Fix serial0 alias path

Atish Patra (2):
  riscv: Append ISA extensions to the device tree
  riscv: Add Sstc extension support

 arm/aarch64/include/asm/kvm.h    |  36 ++++++
 include/linux/kvm.h              | 181 +++++++++++++++++++++++++++++--
 include/linux/virtio_9p.h        |   2 +-
 include/linux/virtio_config.h    |   7 +-
 include/linux/virtio_ids.h       |  14 +--
 include/linux/virtio_net.h       |  34 +++++-
 include/linux/virtio_pci.h       |   2 +
 riscv/fdt.c                      |  44 +++++++-
 riscv/include/asm/kvm.h          |  22 ++++
 riscv/include/kvm/kvm-cpu-arch.h |  11 ++
 riscv/kvm-cpu.c                  |  11 --
 x86/include/asm/kvm.h            |  33 +++---
 12 files changed, 352 insertions(+), 45 deletions(-)

-- 
2.34.1

