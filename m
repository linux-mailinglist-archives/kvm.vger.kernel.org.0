Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01E936D796B
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 12:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237331AbjDEKST (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 06:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235049AbjDEKSR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 06:18:17 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11EFF211F
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 03:18:16 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id d11-20020a05600c3acb00b003ef6e6754c5so17956848wms.5
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 03:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680689894;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=R3c7APLhxJFNCqIErCGS2nhF3aw+HLHuokeVO/lFk00=;
        b=OBiO/iyMPp7HhyBZcX7fJgp2AA6LNBmXbyqspQfxTpbw5ifIhJkHachSnVGxiHum7T
         pDyTjdZU/TDYDH8YqIYCNPP2VKdx3wdUBLlBxM9gzo34nXlEfQws3UH3CuMpU0XuvBtJ
         BR0Y9rfffghCpUn3Lq722SfA08hTOExgU+rQvnILo+j+5Ft88ticBqenXwg5p/GlGvca
         41krEivQExeKbzC6OcydV1hPviKH9pwe4ul7G2ol7M0QTifUHh3PLePZ/6n5cypktE9F
         2KVXZ7OB0raOVG9XCJUMp3dAf1zpvJiqWUaGdW48AgcrjBnZSMXe3CucyEtdxru47k5Y
         KTzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680689894;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R3c7APLhxJFNCqIErCGS2nhF3aw+HLHuokeVO/lFk00=;
        b=m3xhZxeyu8i56+lkdZ2Cm09hJyuL9kqzAr411tM8XufivK7BXjkASD4bOGAsPMSYsc
         tB7ivF/RxzvNROd9ShvGxKUVrnc5/5V+0feGFTF4H34FgWhDO4Ux8lfypAEJwosH6SIh
         ZvICGon6MYa7oIGxCXtOeqqDmDMaiEZt1CgIodKnH7ewO0jJs4NhI6frgtyRzCRZp3X6
         bJSjonLvXVvbp3SR8bCnRy46p2753IFdoZ3Smesv+qahh0jeuogwSrlvtyCxxdUnn/tU
         wqcw2Z9s4aZANlAIDPcAwT9JrTMvu9P0zDWqLdY8VEEpCEI7vKX3xR6Z56qGuMnNXEm1
         Kl3A==
X-Gm-Message-State: AAQBX9dhoS4PlZib4qwvrnckIl3d6dOy+6uo/xkbykviiOFyziuGhFYl
        d8Tq9N9UpQ/KwCb/B+LxtTcODw==
X-Google-Smtp-Source: AKy350Ybve9k60nXpw2N7+saf2pFb1rgNJYM8Jf0Z78V3ulPWVpu1aVqOeAnHikWi6TcyhWdL0mjyg==
X-Received: by 2002:a7b:c4d3:0:b0:3ed:551b:b78f with SMTP id g19-20020a7bc4d3000000b003ed551bb78fmr4181570wmk.4.1680689894558;
        Wed, 05 Apr 2023 03:18:14 -0700 (PDT)
Received: from localhost.localdomain (4ab54-h01-176-184-52-81.dsl.sta.abo.bbox.fr. [176.184.52.81])
        by smtp.gmail.com with ESMTPSA id t16-20020a05600c451000b003ef66c89af0sm5203608wmo.0.2023.04.05.03.18.13
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 05 Apr 2023 03:18:14 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 00/14] accel: Share CPUState accel context (HAX/NVMM/WHPX/HVF)
Date:   Wed,  5 Apr 2023 12:17:57 +0200
Message-Id: <20230405101811.76663-1-philmd@linaro.org>
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

This series is part of the single binary effort.

All accelerator will share their per-vCPU context in
an opaque 'accel' pointer within the CPUState.

First handle HAX/NVMM/WHPX/HVF. KVM and TCG will follow
as two different (bigger) follow-up series.

Philippe Mathieu-Daudé (14):
  accel: Document generic accelerator headers
  accel: Remove unused hThread variable on TCG/WHPX
  accel: Fix a leak on Windows HAX
  accel: Destroy HAX vCPU threads once done
  accel: Rename 'hax_vcpu' as 'accel' in CPUState
  accel: Use a typedef for struct hax_vcpu_state
  accel: Rename struct hax_vcpu_state -> struct AccelvCPUState
  accel: Move HAX hThread to accelerator context
  accel: Allocate NVMM vCPU using g_try_FOO()
  accel: Rename NVMM struct qemu_vcpu -> struct AccelvCPUState
  accel: Inline NVMM get_qemu_vcpu()
  accel: Rename WHPX struct whpx_vcpu -> struct AccelvCPUState
  accel: Inline WHPX get_whpx_vcpu()
  accel: Rename HVF struct hvf_vcpu_state -> struct AccelvCPUState

 include/hw/core/cpu.h             | 11 ++---
 include/sysemu/hax.h              |  2 +
 include/sysemu/hvf_int.h          |  2 +-
 include/sysemu/kvm.h              |  2 +
 include/sysemu/nvmm.h             |  2 +
 include/sysemu/tcg.h              |  2 +
 include/sysemu/whpx.h             |  2 +
 include/sysemu/xen.h              |  2 +
 target/i386/hax/hax-i386.h        | 14 ++++---
 accel/hvf/hvf-accel-ops.c         | 16 +++----
 accel/tcg/tcg-accel-ops-mttcg.c   |  4 --
 accel/tcg/tcg-accel-ops-rr.c      |  3 --
 target/arm/hvf/hvf.c              | 70 +++++++++++++++----------------
 target/i386/hax/hax-accel-ops.c   |  5 ++-
 target/i386/hax/hax-all.c         | 26 +++++++-----
 target/i386/hax/hax-posix.c       |  4 +-
 target/i386/hax/hax-windows.c     |  6 +--
 target/i386/nvmm/nvmm-all.c       | 38 +++++++----------
 target/i386/whpx/whpx-accel-ops.c |  3 --
 target/i386/whpx/whpx-all.c       | 39 +++++++----------
 20 files changed, 123 insertions(+), 130 deletions(-)

-- 
2.38.1

