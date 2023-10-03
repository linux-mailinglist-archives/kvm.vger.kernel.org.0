Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E18717B6207
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 09:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbjJCHEj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 03:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbjJCHEh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 03:04:37 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D4BBD
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 00:04:33 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-406618d0992so5511175e9.0
        for <kvm@vger.kernel.org>; Tue, 03 Oct 2023 00:04:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696316672; x=1696921472; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=t7bRjku5e3F1u88Ym725On2StuO+R/NkzZcj5nwce/E=;
        b=hvv0WHOGcMs2wOAoyFzDA6cjL48D9oiEBgUUJZGzxhJAETDG78WZwa05325h1H0the
         6LM7Vp+aAsP/bGHaIERcZAFOcskfFWrr+1x+T3wjjxpY0pJ/3MebbHYyeqOs4xDkuvDW
         TMeKvSa56FTyGxC/Y9VM2rZtj+rSxmfIBs7NeYs6stO/ScaA657D02qAUU0KdCJNn/16
         1yA9NnpXocvPw+CjaUaYXiMDKid1Hk3lpOKIAkI2NbuInU/3oSQU/xMs/CJWn6nnTlMC
         nX/YGBrIIYzPbtAIEJy9Rv2ktb+PNdHR64Dm0G/C0c5cxjllmKUH1nuQ6MpNwR5gJNFm
         QFNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696316672; x=1696921472;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t7bRjku5e3F1u88Ym725On2StuO+R/NkzZcj5nwce/E=;
        b=XkGiQPoEqhMb/O96YwY/EcvHJAFidn8hoq8DVqhRpS3UcoyMAVjLWLwTci8QZigFPp
         yGh1TDz1jQuPzGz50WO7mkg6V/s8DuU4O9XkMNhsmcUo/8DnCrC8yN+fOW3NtHu97JMz
         q1/Lnfj1tXZXcXN9ZCIAd+/O5uEp7vlkpG2F32KfhmbPNORevV82yeKxBPf/JnvId1z0
         qdksTpMmEGyBag6pR+/eVqr7+Cmjth49sWFieisS5SWNAbglHIwXglAdfb3QXWV/L7Lk
         bDd8gBoSZQ7nyhuIogpLZXILaswUlGISxd1cq/BpZNRShwOcG01mL44wQbR33eGn9ssp
         VBqQ==
X-Gm-Message-State: AOJu0YzIYtijEUA9GA/dpgrio43x3iE7OiXIumIk8yf5JCipfZvXRej1
        g4U0EJe2EdyKUGf4weoBiUp9dw==
X-Google-Smtp-Source: AGHT+IEp17Lzh57Gx8VFBOlfoslRVPDGk0mKkvOGCp+wHJhaOAQkNaX7qg2XuEwgXd0EbxU8JqNFrw==
X-Received: by 2002:a05:600c:b59:b0:3ff:233f:2cfb with SMTP id k25-20020a05600c0b5900b003ff233f2cfbmr11266364wmr.23.1696316671193;
        Tue, 03 Oct 2023 00:04:31 -0700 (PDT)
Received: from m1x-phil.lan (176-131-222-246.abo.bbox.fr. [176.131.222.246])
        by smtp.gmail.com with ESMTPSA id t15-20020a1c770f000000b00406408dc788sm8666076wmi.44.2023.10.03.00.04.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 03 Oct 2023 00:04:30 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Richard Henderson <richard.henderson@linaro.org>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        qemu-ppc@nongnu.org, Kevin Wolf <kwolf@redhat.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Michael Tokarev <mjt@tls.msk.ru>, Greg Kurz <groug@kaod.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 0/4] target/ppc: Prohibit target specific KVM prototypes on user emulation
Date:   Tue,  3 Oct 2023 09:04:22 +0200
Message-ID: <20231003070427.69621-1-philmd@linaro.org>
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

Since v1:
- Addressed Michael review comments,
- Added Daniel R-b tag.

Implement Kevin's suggestion to remove KVM declarations
for user emulation builds, so if KVM prototype are used
we directly get a compile failure.

Philippe Mathieu-Daudé (4):
  sysemu/kvm: Restrict kvmppc_get_radix_page_info() to ppc targets
  hw/ppc/e500: Restrict ppce500_init_mpic_kvm() to KVM
  target/ppc: Restrict KVM objects to system emulation
  target/ppc: Prohibit target specific KVM prototypes on user emulation

 include/sysemu/kvm.h   |  1 -
 target/ppc/kvm_ppc.h   |  4 ++++
 hw/ppc/e500.c          |  4 ++++
 target/ppc/kvm-stub.c  | 19 -------------------
 target/ppc/kvm.c       |  4 ++--
 target/ppc/meson.build |  2 +-
 6 files changed, 11 insertions(+), 23 deletions(-)
 delete mode 100644 target/ppc/kvm-stub.c

-- 
2.41.0

