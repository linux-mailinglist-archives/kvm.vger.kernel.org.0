Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E39AE6CC75C
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 18:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233305AbjC1QCU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 12:02:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233029AbjC1QCQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 12:02:16 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D107AE184
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 09:02:08 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id q7-20020a05600c46c700b003ef6e809574so4570694wmo.4
        for <kvm@vger.kernel.org>; Tue, 28 Mar 2023 09:02:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680019327;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NmsSjup+xEQ0gc2TIeG2hC6j/mKEA8p4JNIyDCKCDnk=;
        b=TXS+Ym0GCybLQ+ER+7Oa64F9rrGVRrgJJHHwtCwuS35WZ4qfoTxmWr9K11Xw/xLIvC
         HyxDht7nCxqWeRQn1c1jnzfl4FIZs5Ue0uZY5GHM0kvyX4ai9P/BjvtiQVoHf+gEuaS+
         vffYGdeuaiGR7ecdBjMu0x0rXTwgv3MukciKmf7Ne52JOIHM8mNxZIDRZ7Gh8ZYeQcWO
         lzeM6dSuSYR1E02pRPkzet5emj1HYJk5xqrlMEhfihx2P1itD0KWD1HlqqDIeVUoMkhE
         pOhST29TgROk1lCDEy6wQ5b9G2A5T/uG2wGWxO/ZDPuPfSBsc7NugKZoE1BAtT8x9K/s
         IXYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680019327;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NmsSjup+xEQ0gc2TIeG2hC6j/mKEA8p4JNIyDCKCDnk=;
        b=ZIniQaAZCzBrnlrKs47yZZ+ULRfIw/ihC2qLwBz6P/E6dIkvWND02e+aSb5uDk/qkM
         iGUMHHRlz9N8R6ERBpykNsu/eB/Qf/FsTN+xoB8c599FMdE1nRBk1+VN+JeoA2PYePMV
         CP1tLLXW5aGpO4bIHiZcPgxn9CbhdYi6grtxPfeI8fH+j9oS92cEy5k1yBvZyu5r+/SH
         7znfH+txH9x2NDi6JjQqhdrwUfkc59lhqt56WRg24zWJuuhCLr352Fn6sDCqA0EMW/rQ
         cpDy8Jj6C1/W/1bkrUEyuaWfkeAv+vwOV1XWuWm8rYzQ9op0JlMmczIsulfDPw7xj0ZE
         99Mg==
X-Gm-Message-State: AO0yUKUWo7jvbaWD3XJ2SfXkTgGIZWD/hUq4UPanZPCwgrScNnrJ5pwa
        1CBfKsjOG7h5ygxXcnXILNFzOA==
X-Google-Smtp-Source: AK7set9QdPz+EVC4C8quH18Yt0Nyoa2yv+ZsJ7j72om3axKiVorYuqs2XM+85Et9x6gjQRM3bWSGKA==
X-Received: by 2002:a7b:ce08:0:b0:3ee:da1:135f with SMTP id m8-20020a7bce08000000b003ee0da1135fmr12778012wmc.7.1680019327311;
        Tue, 28 Mar 2023 09:02:07 -0700 (PDT)
Received: from localhost.localdomain ([176.187.210.212])
        by smtp.gmail.com with ESMTPSA id hg13-20020a05600c538d00b003ed793d9de0sm2937626wmb.1.2023.03.28.09.02.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 28 Mar 2023 09:02:06 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Eduardo Habkost <eduardo@habkost.net>, kvm@vger.kernel.org,
        qemu-s390x@nongnu.org, Fabiano Rosas <farosas@suse.de>,
        David Hildenbrand <david@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Greg Kurz <groug@kaod.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Yanan Wang <wangyanan55@huawei.com>, qemu-ppc@nongnu.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH-for-8.0 0/3] softmmu: Restore use of CPU watchpoint for non-TCG accelerators
Date:   Tue, 28 Mar 2023 18:02:00 +0200
Message-Id: <20230328160203.13510-1-philmd@linaro.org>
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

Commit 2609ec2868 ("softmmu: Extract watchpoint API from physmem.c")
restricted CPU watchpoints to TCG accelerator. This is wrong, as
other accelerators such KVM do use watchpoints. Revert (partially)
this commit.

https://lore.kernel.org/qemu-devel/4784948c-1a92-1991-d6a2-b4d1ee23136c@redhat.com/

Philippe Mathieu-Daudé (3):
  softmmu/watchpoint: Add missing 'qemu/error-report.h' include
  softmmu: Restrict cpu_check_watchpoint / address_matches to TCG accel
  softmmu: Restore use of CPU watchpoint for all accelerators

 include/hw/core/cpu.h         | 39 +------------------------------
 include/hw/core/tcg-cpu-ops.h | 43 +++++++++++++++++++++++++++++++++++
 softmmu/watchpoint.c          |  5 ++++
 softmmu/meson.build           |  2 +-
 4 files changed, 50 insertions(+), 39 deletions(-)

-- 
2.38.1

