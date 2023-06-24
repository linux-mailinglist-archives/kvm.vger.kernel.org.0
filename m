Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED66C73CC29
	for <lists+kvm@lfdr.de>; Sat, 24 Jun 2023 19:42:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233016AbjFXRmh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 24 Jun 2023 13:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233192AbjFXRme (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 24 Jun 2023 13:42:34 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F7DA1BFC
        for <kvm@vger.kernel.org>; Sat, 24 Jun 2023 10:42:33 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id 4fb4d7f45d1cf-51bee0c0acbso1695264a12.1
        for <kvm@vger.kernel.org>; Sat, 24 Jun 2023 10:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687628551; x=1690220551;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wDJq03Cy4udm0BY/tdQJBSn7cYSDg3Mije1czkKCJYY=;
        b=RO2avB+FoBAH/Di/V4kIhFyDQH7uIlgC0gwfCgQrD89bwE83AmBBFg0CcRlHBZjeo8
         xf712Qc9aR38nPiF+uDaf5yc8gD19WEsCR2svxAprxd1bFxGUA2r4lMmJIlwctgs7QkB
         EUtMNoLLcY3J6LBbohSpdImmOm/n5GLZ+fA8stYV9O4SnDoSh8DTgNabJ/O9qfxzX4AN
         5t1XZJvA/e/bJFTTAZaWg85tev9gNfCnctzxCTxdaNAK3TWI6g6FLKy1iSyDWwm7ICVw
         UkmuMgdFFe7lQAMN+uYaq3GLpkAMayp43PGSU3d6bHrT+2SGnuNJPvNFppg8VTyk9Otn
         2Akg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687628551; x=1690220551;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wDJq03Cy4udm0BY/tdQJBSn7cYSDg3Mije1czkKCJYY=;
        b=IVtQYJk92pOObvsRHOzQbzsWNXI7QTrk0xN2IrwmpbTszf4ibB+7iugnuGZDh5BnNA
         37RnXzowIKUtSc+7oXxqqs5tB8xI1vR5DfBfNV0bvHE+twytKVG1Fekg4QmNCjljxGqP
         rUpzgl8m8ZOaS6duUVsihWluE2P1uTRO94ezuKH1TTxlj2ulxKm/5jNS0pdJwG8zlSyr
         xwyzrvXfVR8lIlZjnT9lcGrNSmNQgbnsxUd2CerJY20Tt+ZAxDqRmoqFvDkBABhOBh5o
         dqG2TXKLj8DxIUGbvb0odkFm6KIx50yiYSSthzxb05Ozob4F6WD/AKIet1MCUiOfRYPM
         KUJw==
X-Gm-Message-State: AC+VfDyabQAW/NbdRydnWMCEz/C1ZJkOivfYJ25s2zMvUukzDQQd0dmf
        BOLnFkjRo2hTaH3UV6bDC7Nz4A==
X-Google-Smtp-Source: ACHHUZ4FYM2a+yRGrt0ZR/p6B5z15VUL79T2BhspQcZnT7ZhY2JGOdCOYx1WSa4ydzRjjHwIT6bFeg==
X-Received: by 2002:aa7:cb47:0:b0:51d:9130:3c54 with SMTP id w7-20020aa7cb47000000b0051d91303c54mr196875edt.26.1687628551740;
        Sat, 24 Jun 2023 10:42:31 -0700 (PDT)
Received: from m1x-phil.lan ([176.187.217.150])
        by smtp.gmail.com with ESMTPSA id d15-20020a05640208cf00b0051a3e7d7996sm872902edz.83.2023.06.24.10.42.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 24 Jun 2023 10:42:31 -0700 (PDT)
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
Subject: [PATCH v3 09/16] accel: Remove NVMM unreachable error path
Date:   Sat, 24 Jun 2023 19:41:14 +0200
Message-Id: <20230624174121.11508-10-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230624174121.11508-1-philmd@linaro.org>
References: <20230624174121.11508-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

g_malloc0() can not fail. Remove the unreachable error path.

https://developer-old.gnome.org/glib/stable/glib-Memory-Allocation.html#glib-Memory-Allocation.description

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
---
 target/i386/nvmm/nvmm-all.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/target/i386/nvmm/nvmm-all.c b/target/i386/nvmm/nvmm-all.c
index b3c3adc59a..90e9e0a5b2 100644
--- a/target/i386/nvmm/nvmm-all.c
+++ b/target/i386/nvmm/nvmm-all.c
@@ -943,10 +943,6 @@ nvmm_init_vcpu(CPUState *cpu)
     }
 
     qcpu = g_malloc0(sizeof(*qcpu));
-    if (qcpu == NULL) {
-        error_report("NVMM: Failed to allocate VCPU context.");
-        return -ENOMEM;
-    }
 
     ret = nvmm_vcpu_create(mach, cpu->cpu_index, &qcpu->vcpu);
     if (ret == -1) {
-- 
2.38.1

