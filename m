Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 868A26D82E2
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 18:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238829AbjDEQFI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 12:05:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237481AbjDEQFF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 12:05:05 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598B96A6D
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 09:04:59 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id l12so36706071wrm.10
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 09:04:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680710698;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Vl/tcRzlSLFP8I0QYpufOB41zMuDYKv+twPlQw3+A7Y=;
        b=z2nGX/sbknCymlzrQ9v16a39LCmw2vWJ+052z8qCXp7C4jGf6bXcXu3B7SE2op86CM
         pZWCxIOp3+X8l3AJqCp2i3FP8bFOTsRw0XKW5Vu5GlUd7a77LW832HlQNzKVAQA6Unii
         ywjYKNh6fSPU47UFgAbZ/m+OdxIevSbiXkJMApc20LE9+QSxxrSbS2AhGEsWbiV30ZGs
         tGZCcSsg/j2+HjulCXVtZOqEQgLreXUOtJx3aVjPkjgdF5Gib/2iRwHJE/TDtzWp2cfI
         BCx9gnMsct8Sih+glmi6JpbVhwxn29093cKIRS61NExqCA4Hm2FHRQvku8it5hwfLWWG
         8qnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680710698;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Vl/tcRzlSLFP8I0QYpufOB41zMuDYKv+twPlQw3+A7Y=;
        b=fWx3nmxhd3y7UhRSnbEqHIX8q8YUvxbEXEDQauTNXxfMT1lvTf3JBVDl9inGHQjxf3
         sKHHwXk+bml8ZnPrgz7umvbtU9YfxLAROnmUWpnSVW8AsmWK7ayqHibQC7ZUbs4WF2x0
         Lom0G6082+xrmiSbjaOYVcluRhYJg3+780sZ+UWvBVaNB/Db7Y7Z3Jwnfsp6SBD0X6hE
         togxyB0LQrJ2GG7XkkBbVdO0uRiJmHHwf95NeEXeVhC1zR87zebZnIVhuoOm1lBJpYZE
         a7a4G+Tgrmk7zYSH52VeT/dR+K6A+5ZeZ55DhcMpvG/6wuwakdTaivb6kcencCuqF1pe
         qQDQ==
X-Gm-Message-State: AAQBX9e5LTqr+1RpzRkR1xFMj5wuJ80ou6xq7TCeBoKsBeUTtv/wQ4pL
        7yCula3SvNVCOYmV9gSJoHd5UetGtPZtNCBBkBA=
X-Google-Smtp-Source: AKy350a2v8x4w7quWU/H2xrgdicBj2Mb70/KyTRdW4r/bTcsFan0Cz9m9OOnUgEYSEuCthtLF8HE9g==
X-Received: by 2002:a5d:4f8d:0:b0:2d8:1aff:813 with SMTP id d13-20020a5d4f8d000000b002d81aff0813mr4655005wru.43.1680710697754;
        Wed, 05 Apr 2023 09:04:57 -0700 (PDT)
Received: from localhost.localdomain (4ab54-h01-176-184-52-81.dsl.sta.abo.bbox.fr. [176.184.52.81])
        by smtp.gmail.com with ESMTPSA id p2-20020a5d48c2000000b002e61923575csm14691415wrs.74.2023.04.05.09.04.56
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 05 Apr 2023 09:04:57 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     qemu-s390x@nongnu.org, qemu-riscv@nongnu.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 00/10] accel/kvm: Spring cleaning
Date:   Wed,  5 Apr 2023 18:04:44 +0200
Message-Id: <20230405160454.97436-1-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Misc KVM-related cleanup patches split from a bigger
"extract KVM specific fields from CPUState" series.

Philippe Mathieu-Daudé (10):
  sysemu/kvm: Remove unused headers
  accel/kvm: Declare kvm_direct_msi_allowed in stubs
  hw/intc/arm_gic: Un-inline GIC*/ITS class_name() helpers
  hw/intc/arm_gic: Rename 'first_cpu' argument
  hw/arm/sbsa-ref: Include missing 'sysemu/kvm.h' header
  target/arm: Reduce QMP header pressure by not including 'kvm_arm.h'
  target/arm: Restrict KVM-specific fields from ArchCPU
  target/ppc: Restrict KVM-specific field from ArchCPU
  target/riscv: Restrict KVM-specific fields from ArchCPU
  hw/s390x: Rename pv.c -> pv-kvm.c

 include/hw/intc/arm_gic.h              |  2 ++
 include/hw/intc/arm_gicv3_common.h     | 10 ++++++
 include/hw/intc/arm_gicv3_its_common.h |  9 ++++++
 include/sysemu/kvm.h                   |  3 --
 target/arm/cpu.h                       |  2 ++
 target/arm/kvm_arm.h                   | 45 --------------------------
 target/ppc/cpu.h                       |  2 ++
 target/riscv/cpu.h                     |  2 ++
 accel/stubs/kvm-stub.c                 |  1 +
 hw/arm/sbsa-ref.c                      |  1 +
 hw/arm/virt-acpi-build.c               |  2 +-
 hw/arm/virt.c                          |  1 +
 hw/intc/arm_gic_common.c               | 12 +++++--
 hw/intc/arm_gicv3_common.c             | 14 ++++++++
 hw/intc/arm_gicv3_its_common.c         | 12 +++++++
 hw/s390x/{pv.c => pv-kvm.c}            |  0
 target/arm/arm-qmp-cmds.c              |  3 +-
 target/ppc/mmu_common.c                |  4 +++
 target/riscv/machine.c                 |  4 +++
 hw/s390x/meson.build                   |  2 +-
 20 files changed, 78 insertions(+), 53 deletions(-)
 rename hw/s390x/{pv.c => pv-kvm.c} (100%)

-- 
2.38.1

