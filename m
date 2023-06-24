Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD1FD73CC16
	for <lists+kvm@lfdr.de>; Sat, 24 Jun 2023 19:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233141AbjFXRl3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Jun 2023 13:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjFXRl1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Jun 2023 13:41:27 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9198B1BC2
        for <kvm@vger.kernel.org>; Sat, 24 Jun 2023 10:41:26 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-3fa70ec8d17so26238365e9.1
        for <kvm@vger.kernel.org>; Sat, 24 Jun 2023 10:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687628485; x=1690220485;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9DD8JyzZ0D9c0TVJWROVlnDQP9z+YeCBvlalUwzeBRo=;
        b=S8HxrYQ2qhgw56X9JXNpzNmjfiViWtcbiWCpgQccPHZivixZ7QAzwnG0azVoU7xVwb
         akuxl0mdCTpThLPPNG44q2zM7WFBYRf++FIjeb7OZaKYcNCoxQVVFO06aKvqykPLZlYZ
         ZvpNiq98b5G8YgGvHvAodfNZ2LcJFFazSZG27b+pSB9bw6v7bdgijzZhhCtwRpACo7M0
         slPhBm89C1gJKR7y1ERfGhGue/oWbU0iTwXu9x0IUylVr99MqavVrVlJRD4xj8CSGUvm
         6za9HdL9/cV4dMDN2/DHhAKDF5i4CxvXeVSa4T7v0NhA1XGwrIFxIoVXTwJ+ThKpvofI
         84Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687628485; x=1690220485;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9DD8JyzZ0D9c0TVJWROVlnDQP9z+YeCBvlalUwzeBRo=;
        b=fHqY69rUIN+EB2gwKThOUMmBVwJASHogJYJ/8FzT/k/UYJb1DD8hIvB0Pl695grU7/
         lU68SD6cUDb8LeOPqkZFRndmun6EZb4OV3c2CHn7cEzdyctQtm8gTm+l6AGwwWETX14E
         J0a0y9QvmyVTeSLaexlWCDLVDMkAAsdep4qnnSjKCORf6VNrgVdmO9141yGReIMCdnP4
         6QaJl5aMcpaNz5ISQ2u0TLY1DMUd3RbIKs1IVBimvrTbx/H2RZGSzz0If54ZDlbPtSyh
         oP73rJHWMgmtrHIVTf1rjOYjYUkeLYjDeCfmg1kXjC8tM2xwm3xdU6BAsp1bbsGm8Tma
         gq5Q==
X-Gm-Message-State: AC+VfDxBE97n4LTR9parVTbb+lOZYGpUlPV0sR5V9wgXnexvyCUCeO9J
        FWYigaTlvtz9SmtqFmEfjJ+z4g==
X-Google-Smtp-Source: ACHHUZ4RU70EsAbLLa974X6kTmgNQb8jnG4vK1SD4DHwEek3Lg8HiGz7TW7mHUT/jA40wDP62z4cEA==
X-Received: by 2002:a05:600c:2942:b0:3f7:e7a2:25f6 with SMTP id n2-20020a05600c294200b003f7e7a225f6mr21913470wmd.17.1687628485030;
        Sat, 24 Jun 2023 10:41:25 -0700 (PDT)
Received: from m1x-phil.lan ([176.187.217.150])
        by smtp.gmail.com with ESMTPSA id p23-20020a1c7417000000b003f9b0f640b1sm2711760wmc.22.2023.06.24.10.41.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 24 Jun 2023 10:41:24 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Roman Bolshakov <rbolshakov@ddn.com>, qemu-arm@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Alexander Graf <agraf@csgraf.de>,
        xen-devel@lists.xenproject.org,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Yanan Wang <wangyanan55@huawei.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Paul Durrant <paul@xen.org>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Cameron Esfahani <dirty@apple.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v3 00/16] accel: Share CPUState accel context (HAX/NVMM/WHPX/HVF)
Date:   Sat, 24 Jun 2023 19:41:05 +0200
Message-Id: <20230624174121.11508-1-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series is part of the single binary effort.

All accelerator will share their per-vCPU context in
an opaque 'accel' pointer within the CPUState.

First handle HAX/NVMM/WHPX/HVF. KVM and TCG will follow
as two different (bigger) follow-up series.

Except HVF/intel, all has been (cross-)build tested.

I plan to send the PR myself.

Since v2:
- Addressed rth's review comments
- Added rth's R-b tag

Since v1:
- Addressed rth's review comments
- Added rth's R-b tag
- Converted HVF intel (untested)
- Rebased

Philippe Mathieu-Daudé (16):
  MAINTAINERS: Update Roman Bolshakov email address
  accel: Document generic accelerator headers
  accel: Remove unused hThread variable on TCG/WHPX
  accel: Fix a leak on Windows HAX
  accel: Destroy HAX vCPU threads once done
  accel: Rename 'hax_vcpu' as 'accel' in CPUState
  accel: Rename HAX 'struct hax_vcpu_state' -> AccelCPUState
  accel: Move HAX hThread to accelerator context
  accel: Remove NVMM unreachable error path
  accel: Rename NVMM 'struct qemu_vcpu' -> AccelCPUState
  accel: Inline NVMM get_qemu_vcpu()
  accel: Remove WHPX unreachable error path
  accel: Rename WHPX 'struct whpx_vcpu' -> AccelCPUState
  accel: Inline WHPX get_whpx_vcpu()
  accel: Rename 'cpu_state' -> 'cs'
  accel: Rename HVF 'struct hvf_vcpu_state' -> AccelCPUState

 MAINTAINERS                       |   4 +-
 include/hw/core/cpu.h             |  10 +-
 include/qemu/typedefs.h           |   1 +
 include/sysemu/hax.h              |   2 +
 include/sysemu/hvf_int.h          |   2 +-
 include/sysemu/kvm.h              |   2 +
 include/sysemu/nvmm.h             |   2 +
 include/sysemu/tcg.h              |   2 +
 include/sysemu/whpx.h             |   2 +
 include/sysemu/xen.h              |   2 +
 target/i386/hax/hax-i386.h        |  12 +-
 target/i386/hvf/vmx.h             |  22 +-
 target/i386/hvf/x86hvf.h          |  18 +-
 accel/hvf/hvf-accel-ops.c         |  18 +-
 accel/tcg/tcg-accel-ops-mttcg.c   |   4 -
 accel/tcg/tcg-accel-ops-rr.c      |   3 -
 target/arm/hvf/hvf.c              | 108 ++++-----
 target/i386/hax/hax-accel-ops.c   |   5 +-
 target/i386/hax/hax-all.c         |  26 ++-
 target/i386/hax/hax-posix.c       |   4 +-
 target/i386/hax/hax-windows.c     |   6 +-
 target/i386/hvf/hvf.c             | 104 ++++-----
 target/i386/hvf/x86.c             |  28 +--
 target/i386/hvf/x86_descr.c       |  26 +--
 target/i386/hvf/x86_emu.c         |  62 ++---
 target/i386/hvf/x86_mmu.c         |   4 +-
 target/i386/hvf/x86_task.c        |  10 +-
 target/i386/hvf/x86hvf.c          | 372 +++++++++++++++---------------
 target/i386/nvmm/nvmm-all.c       |  42 ++--
 target/i386/whpx/whpx-accel-ops.c |   3 -
 target/i386/whpx/whpx-all.c       |  45 ++--
 .mailmap                          |   3 +-
 32 files changed, 469 insertions(+), 485 deletions(-)

-- 
2.38.1

