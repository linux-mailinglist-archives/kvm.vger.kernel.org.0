Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3350979174D
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 14:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352815AbjIDMnq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 08:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350864AbjIDMnp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 08:43:45 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66CB31AD
        for <kvm@vger.kernel.org>; Mon,  4 Sep 2023 05:43:41 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id 38308e7fff4ca-2bd0a5a5abbso21118901fa.0
        for <kvm@vger.kernel.org>; Mon, 04 Sep 2023 05:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693831419; x=1694436219; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r6Qgqbn+d1/I+gSK8St7x7NRj+2INTDRnnggirvl8K4=;
        b=ZVR2Ww3eE3oRf6MWKRXd1kjuoV/8o0ln/+3JCOYPkHRMa1dtfOdi5HqliAQIMz9bTQ
         h2BEEGEOFqa1W5AZc/UFAgYpWhskZ4WjmakqgTtpm/MjEzcGaOyYn2whZzVyYdGl7UAy
         bxIu+u2yJ/fNNt6p+sUlH1osSdb1l4I2lLwtZL4AyGBNNKSwxWgcEVHuGQ+F+/Dwmr87
         BZbWYghx1RjnI/Nl0bMbfhmlHbq4WsNGjKGXoIVSqNfW7m7DCTHQbLJtnIF1uSabYl/n
         MZSbANaoC13g15t6ctFPuZtOSzxvfqKDZ3rLmNImbrlL81EG8dgKjWOGQouPTG2oaBOL
         Dl/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693831419; x=1694436219;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r6Qgqbn+d1/I+gSK8St7x7NRj+2INTDRnnggirvl8K4=;
        b=cf8mWUDeCTFecD7AJ4dhGDjzUzlmrcIgHbf2fbsmApoBPR45dgu4aRSiq/rcBCobEg
         Cbep807L3MKLf/tbyKKDTgbnBC0e1w92ebwNrwlcqgloi3+kwuDxnLqWbitYTJZjTKm+
         LqW/10Xp3LVh2qCcE3W/YupqtPo5uA7MauvJc3KsD4CxeePXsiR5Vga+HnJrjGu8Svv2
         C4K1dnXDoDrAoC8edTvhQt70GGWjSk2jMBJsYvaZL8rHKO1cFXv/AR3qt3xbd255nGhm
         nBEjYrYQaZuCgwtSTy+6Ocnctv/agT0Zq2MSuB1KNu/lvakc3DU7r35+miGWCZG+EgH3
         UrMg==
X-Gm-Message-State: AOJu0Ywp0zRaV5ttQ7sDpwwOjptkWQ97+wx/23HDmkqIj5EkOl5UChhz
        ezCz0Ke85PewRSxz3jUXmg5bUA==
X-Google-Smtp-Source: AGHT+IHAvtxselt1b1hV5LdDZn5OMGkxc7bjsWnN+/jQkXccg9G0McaZkj4DLfPBkIFLocObukSlqg==
X-Received: by 2002:a19:2d45:0:b0:4fd:f84f:83c1 with SMTP id t5-20020a192d45000000b004fdf84f83c1mr5836726lft.64.1693831419642;
        Mon, 04 Sep 2023 05:43:39 -0700 (PDT)
Received: from m1x-phil.lan ([176.187.209.227])
        by smtp.gmail.com with ESMTPSA id lg16-20020a170906f89000b009a0955a7ad0sm6087296ejb.128.2023.09.04.05.43.38
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 04 Sep 2023 05:43:39 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <eduardo@habkost.net>
Subject: [PATCH 02/13] hw/i386/pc: Include missing 'cpu.h' header
Date:   Mon,  4 Sep 2023 14:43:13 +0200
Message-ID: <20230904124325.79040-3-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230904124325.79040-1-philmd@linaro.org>
References: <20230904124325.79040-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Both pc_piix.c and pc_q35.c files use CPU_VERSION_LEGACY
which is defined in "target/i386/cpu.h".

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/i386/pc_piix.c | 1 +
 hw/i386/pc_q35.c  | 1 +
 2 files changed, 2 insertions(+)

diff --git a/hw/i386/pc_piix.c b/hw/i386/pc_piix.c
index ce1ac95274..f0df12f6fa 100644
--- a/hw/i386/pc_piix.c
+++ b/hw/i386/pc_piix.c
@@ -69,6 +69,7 @@
 #include "hw/mem/nvdimm.h"
 #include "hw/i386/acpi-build.h"
 #include "kvm/kvm-cpu.h"
+#include "target/i386/cpu.h"
 
 #define MAX_IDE_BUS 2
 #define XEN_IOAPIC_NUM_PIRQS 128ULL
diff --git a/hw/i386/pc_q35.c b/hw/i386/pc_q35.c
index 43413dd1ac..8ecc78c822 100644
--- a/hw/i386/pc_q35.c
+++ b/hw/i386/pc_q35.c
@@ -58,6 +58,7 @@
 #include "hw/hyperv/vmbus-bridge.h"
 #include "hw/mem/nvdimm.h"
 #include "hw/i386/acpi-build.h"
+#include "target/i386/cpu.h"
 
 /* ICH9 AHCI has 6 ports */
 #define MAX_SATA_PORTS     6
-- 
2.41.0

