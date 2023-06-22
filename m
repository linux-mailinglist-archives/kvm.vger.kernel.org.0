Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 128D573A58C
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 18:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbjFVQIg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 12:08:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbjFVQIe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 12:08:34 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 912B51BD3
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 09:08:32 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-3f9ede60140so13029595e9.0
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 09:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687450110; x=1690042110;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/A79JoyFfC6huza+xbUxwLYTIgxFxi3HGGy1xW4nwf8=;
        b=yogdQdljLj0VC7TAdW5mlkO4xehQvvssX0cA2nch6oDaBprLzWiFgwagXbPBEJUPzI
         8OIBQRK96iDOUORSsMWxYq09FsUAl57K3U6Spr+laGQYD3up4utpggKFA6QLgT1pnzzE
         g09YvBAEWhT3Ne6uAEZ20ASjG6NJFVrE6dhCKSAE9ftFgL2VQh2k27lBfh/eH1PALh0Z
         TigFNL8HOV955rvc2CCDmdPvrqvFji3F59lOahxFByvvXG/hhrUnXerexENOEtvdDaP7
         6ovmIZ3Podq1bNUKQAn5JcJ6oFpTB2lBDcFo1YeGaK5hyp/SsBuz0JGuRcUMA00y2fZf
         V4aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687450110; x=1690042110;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/A79JoyFfC6huza+xbUxwLYTIgxFxi3HGGy1xW4nwf8=;
        b=N9YTPTlfm4l9a9wn/Kkzm4ATqftp2NCCoXPbbwieWV1VuOWKRWQ0iYB4QTwgxNZXDl
         7PDcj6Ralxhaz9BGc2vEzkHU5X9YbimXkbfjxvwcGCmyWsCdCS0ss9aoYuHfleokIUTc
         kEqI3uSS08IO2kkKmBsUyX0rX4VWkvuCriMU+8f+LmRcwIckby/gyLroHxe8YfOBZwe8
         WfAmyCPDt3+gzfDZw2TNEI25VAM8egwx99TvBZV8XxTdVZmX0Yxxc0Am0VZHv021XG0p
         qTjU9DPNCurQf8at/WLA6GAaNSune8+4X0Tvlp5uQZ7f6FS4WI/0PFgpSbDyjmVszGoN
         dHfg==
X-Gm-Message-State: AC+VfDyNrr+Bv06rkw0K8vxXnCqZL+pvhVIII45QCfXLIo88Y65AVCiT
        nDAUfoU0EGXcRCOaz6rwzXF7dQ==
X-Google-Smtp-Source: ACHHUZ5K2Rg4dqx8epN1plFR54zJdcZBY/04rfPHyMaRt+7mvQIveLbQzgFDlKqnployGGPzU7dMVw==
X-Received: by 2002:a05:600c:22d2:b0:3f9:b297:1804 with SMTP id 18-20020a05600c22d200b003f9b2971804mr8567893wmg.17.1687450110516;
        Thu, 22 Jun 2023 09:08:30 -0700 (PDT)
Received: from localhost.localdomain (230.red-88-28-3.dynamicip.rima-tde.net. [88.28.3.230])
        by smtp.gmail.com with ESMTPSA id k9-20020a7bc409000000b003f9b24cf881sm10466573wmi.16.2023.06.22.09.08.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 22 Jun 2023 09:08:30 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Reinoud Zandijk <reinoud@netbsd.org>, qemu-arm@nongnu.org,
        kvm@vger.kernel.org, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        Roman Bolshakov <rbolshakov@ddn.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Paul Durrant <paul@xen.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Alexander Graf <agraf@csgraf.de>,
        Richard Henderson <richard.henderson@linaro.org>,
        xen-devel@lists.xenproject.org,
        Eduardo Habkost <eduardo@habkost.net>,
        Cameron Esfahani <dirty@apple.com>
Subject: [PATCH v2 00/16] accel: Share CPUState accel context (HAX/NVMM/WHPX/HVF)
Date:   Thu, 22 Jun 2023 18:08:07 +0200
Message-Id: <20230622160823.71851-1-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
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

This series is part of the single binary effort.

All accelerator will share their per-vCPU context in
an opaque 'accel' pointer within the CPUState.

First handle HAX/NVMM/WHPX/HVF. KVM and TCG will follow
as two different (bigger) follow-up series.

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
  accel: Rename 'cpu_state' -> 'cpu'
  accel: Rename HVF 'struct hvf_vcpu_state' -> AccelCPUState

 MAINTAINERS                       |   4 +-
 include/hw/core/cpu.h             |  10 +-
 include/sysemu/hax.h              |   2 +
 include/sysemu/hvf_int.h          |   2 +-
 include/sysemu/kvm.h              |   2 +
 include/sysemu/nvmm.h             |   2 +
 include/sysemu/tcg.h              |   2 +
 include/sysemu/whpx.h             |   2 +
 include/sysemu/xen.h              |   2 +
 target/i386/hax/hax-i386.h        |  14 +-
 target/i386/hvf/vmx.h             |  22 +-
 target/i386/hvf/x86hvf.h          |  12 +-
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
 target/i386/hvf/x86hvf.c          | 364 +++++++++++++++---------------
 target/i386/nvmm/nvmm-all.c       |  42 ++--
 target/i386/whpx/whpx-accel-ops.c |   3 -
 target/i386/whpx/whpx-all.c       |  45 ++--
 .mailmap                          |   3 +-
 31 files changed, 462 insertions(+), 479 deletions(-)

-- 
2.38.1

