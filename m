Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C18C879174B
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 14:43:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237317AbjIDMnd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 08:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbjIDMnc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 08:43:32 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A0FC0
        for <kvm@vger.kernel.org>; Mon,  4 Sep 2023 05:43:29 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-9a645e54806so166600066b.0
        for <kvm@vger.kernel.org>; Mon, 04 Sep 2023 05:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693831408; x=1694436208; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KgdDAI5WJeQpNJ7fVmtYD+dCjS5FrBlY0naTS3cJ2cY=;
        b=filfKy5XWRtqSxvFwtnm9D2DvQT9L/IO0I3kGV//EFyDQrHAhOQWvrh4SpOcteRwYn
         7wfo/5oM/QABvH1rHt0sY49LcLhCrQoZhmjA707gbNLo/mxxsCrB3neWqhF3reDBJ/+o
         cxm6wQB8DZf8jFRsMtsszljg9wAnUekUWkwRkdXpXsx1f3qEg5/7ttfqymRZpq1Dtx1i
         69CRbMRX5LMzYY4DdFcc0D887hf9Dk6V8hf1bUx/0GHSvinnYTB5qytT7ytwzvMv3/Dq
         KtFZJHfG2OErRnVa07VfvQ2oXWeiKs1LvaIIWDDwykRG2a74zBKq0gdczzdld0nD6emR
         7PhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693831408; x=1694436208;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KgdDAI5WJeQpNJ7fVmtYD+dCjS5FrBlY0naTS3cJ2cY=;
        b=Si35lCocgbBbmCPur/BCLZJWSNh8ShBD3ptio+JJ8WB+RXguw0BcFRqbJVf4utxxNi
         bMiPfR6zwcVSNdsUIyRt80c7OzOAJVZ4k4TiBeaw0GUzhwRyx9/o0pRHqWPMEGhbAdJq
         3nTSxc1dxCtAqVGbUpXmNaBvNkKdffSrPHUihSCnuldBnsa5aQTwBXXuGA8OaHEs1fu1
         XoDCkGBOKBQA1CrCwU0RIIDVWtST1p4MXUTkHPg02MyJr8DeR7wEWWfinFQ7mjd88Luj
         kkCkba6JsAaiZMBqUlKx90kEuceN81YRHJR4Taok5AsKCviVFkS4Q+b2WYmwW0n0E7np
         B8yw==
X-Gm-Message-State: AOJu0YzcvcJYQQXfAmvov/hHvKX9ISPrBHAh4O/1A3ajU+6x9R90aArm
        V1yzyW6QhX8QWwYoEyBdpv6gXw==
X-Google-Smtp-Source: AGHT+IFhdp2S6dmdQU4L+6xLxXs/ra3AOIWeAuonsSZVIyQsXIqOo0I4pZ2Cuh3QLrH5FtcNOMpNIw==
X-Received: by 2002:a17:906:2d1:b0:99e:5d8:a6f9 with SMTP id 17-20020a17090602d100b0099e05d8a6f9mr6609163ejk.66.1693831407692;
        Mon, 04 Sep 2023 05:43:27 -0700 (PDT)
Received: from m1x-phil.lan ([176.187.209.227])
        by smtp.gmail.com with ESMTPSA id um16-20020a170906cf9000b00992d70f8078sm6099214ejb.106.2023.09.04.05.43.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 04 Sep 2023 05:43:27 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 00/13] target/i386: Cleanups around KVM declarations
Date:   Mon,  4 Sep 2023 14:43:11 +0200
Message-ID: <20230904124325.79040-1-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

Mostly trivial cleanups.

We want to have QEMU core code accel-agnostic.
(In particular, removing the KVM specific fields
from CPUState).

This serie contains the x86 specific patches
before starting with the generic KVM code.

FWIW, I couldn't test the 'HVF only' configuration
since I don't have access to such host.

Regards,

Phil.

Philippe Mathieu-Daudé (13):
  hw/i386/pc: Include missing 'sysemu/tcg.h' header
  hw/i386/pc: Include missing 'cpu.h' header
  hw/i386/fw_cfg: Include missing 'cpu.h' header
  target/i386/helper: Restrict KVM declarations to system emulation
  target/i386/cpu-sysemu: Inline kvm_apic_in_kernel()
  target/i386: Remove unused KVM stubs
  target/i386: Allow elision of kvm_enable_x2apic()
  target/i386: Allow elision of kvm_hv_vpindex_settable()
  target/i386: Restrict declarations specific to CONFIG_KVM
  sysemu/kvm: Restrict kvm_arch_get_supported_cpuid/msr() to x86 targets
  sysemu/kvm: Restrict kvm_get_apic_state() to x86 targets
  sysemu/kvm: Restrict kvm_has_pit_state2() to x86 targets
  sysemu/kvm: Restrict kvm_pc_setup_irq_routing() to x86 targets

 include/sysemu/kvm.h        | 10 --------
 target/i386/kvm/kvm_i386.h  | 36 ++++++++++++++++----------
 hw/i386/fw_cfg.c            |  1 +
 hw/i386/intel_iommu.c       |  2 +-
 hw/i386/kvm/i8254.c         |  1 +
 hw/i386/kvm/ioapic.c        |  1 +
 hw/i386/pc_piix.c           |  1 +
 hw/i386/pc_q35.c            |  2 ++
 hw/i386/x86.c               |  4 +--
 target/i386/cpu-sysemu.c    |  4 +--
 target/i386/helper.c        |  2 +-
 target/i386/kvm/kvm-stub.c  | 51 -------------------------------------
 target/i386/kvm/kvm.c       |  4 +--
 target/i386/kvm/meson.build |  2 --
 14 files changed, 37 insertions(+), 84 deletions(-)
 delete mode 100644 target/i386/kvm/kvm-stub.c

-- 
2.41.0

