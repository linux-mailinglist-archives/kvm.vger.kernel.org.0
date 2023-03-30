Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E54CD6CFAC1
	for <lists+kvm@lfdr.de>; Thu, 30 Mar 2023 07:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbjC3Fbq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 01:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjC3Fbp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 01:31:45 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99C9EB2
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 22:31:43 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id iw3so17069714plb.6
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 22:31:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1680154303; x=1682746303;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Fk1AZy2qFEyjvylQLY6jxHy9mB3bZFdpUzr5u7mcFDQ=;
        b=LVbSIGiTJLdBhYVCuUXDk99DIBOElZogkYo2xlFsP/RJY8AMviKhoOOc6Z8UxOlCe/
         ee6g7h23GyiqgeLSIz0eDl9GlgOAQi4AaAoIxAvX68k36p34gHbsf7RXLBPnGErK2Uwc
         PEBEc/zt3NmI8z44N9+Ra3hsk7OnH+FzACwfOsRvaaXfvhkjUjRrpmhCSqCeIumHy/Ro
         5KQtd2fEFaWlKO9N+io09140YeGxYMJY8g5NMDjMAympJYa1jKJm6QbeDkpuBZEboUm1
         xBVHMGwEDXRWRbynlkl6Bx590NxeURzo0TxSYSG90C6G7mLRqU0guWGjxCAoiCql/y1B
         oK3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680154303; x=1682746303;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Fk1AZy2qFEyjvylQLY6jxHy9mB3bZFdpUzr5u7mcFDQ=;
        b=yQZQpylTfYgnjPAK1sR4O+jECt/h0LiiquL1b7x9iXMf6/l95pUSmf8nL3qzMU3X+5
         k3AHUGVmtgtc0BdmXCPXdt1efTR2e0WKx6bRbgFrXa6ijrg9RzQCTU/ltNykrOEQKGsO
         4wKmnIzc8puRY7PQG6EY4E0ggqynXLJCzJU2yz38Ju5MSw1CU/YCnaZW5n1GDdFzBhG/
         jpPo56S1f2vNool3csazMUxRKHu8pvUFF7xmpfu9bCSLcxMIYKF+SzW4PdAcQg/+y4NI
         jFDVibkV3+9YBkEwigBg3vh60i+OBkGGMRKJJ64pmP6Z5ePluqoa84Ld/LyTshEjgfLc
         HkWQ==
X-Gm-Message-State: AAQBX9cAOfG7RIiwNdbc7Qx5kN+JoG932tI/WPwt9wRwePF84XEef7B2
        m0c4poVx688dsczWW3+5Xh5oPs4HWsSb7i6a320=
X-Google-Smtp-Source: AKy350aE7bdngjg5IIgS1UxGq8xDzvhDrXgy8lFpylzU6iEo9v1FLV/Nozx4DDYBl1fLzkcYKTfkAA==
X-Received: by 2002:a17:90b:1e08:b0:23d:1118:4e98 with SMTP id pg8-20020a17090b1e0800b0023d11184e98mr23520185pjb.23.1680154302983;
        Wed, 29 Mar 2023 22:31:42 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([171.76.80.30])
        by smtp.gmail.com with ESMTPSA id 17-20020a170902ee5100b0019339f3368asm24045679plo.3.2023.03.29.22.31.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 22:31:42 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH v2 0/1] RISC-V KVM ONE_REG interface for SBI
Date:   Thu, 30 Mar 2023 11:01:34 +0530
Message-Id: <20230330053135.1686577-1-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series does first does few cleanups/fixes (PATCH1 to PATCH5) and
adds ONE-REG interface for customizing the SBI interface visible to the
Guest/VM.

The testing of this series has been done with KVMTOOL changes in
riscv_sbi_imp_v1 branch at:
https://github.com/avpatel/kvmtool.git

These patches can also be found in the riscv_kvm_sbi_imp_v2 branch at:
https://github.com/avpatel/linux.git

Changes since v1:
 - Dropped patches 1 to 8 since these are already merged.
 - Rebased on Linux-6.3-rc4

Anup Patel (1):
  RISC-V: KVM: Add ONE_REG interface to enable/disable SBI extensions

 arch/riscv/include/asm/kvm_vcpu_sbi.h |   8 +-
 arch/riscv/include/uapi/asm/kvm.h     |  20 ++++
 arch/riscv/kvm/vcpu.c                 |   2 +
 arch/riscv/kvm/vcpu_sbi.c             | 150 +++++++++++++++++++++++---
 arch/riscv/kvm/vcpu_sbi_base.c        |   2 +-
 5 files changed, 163 insertions(+), 19 deletions(-)

-- 
2.34.1

