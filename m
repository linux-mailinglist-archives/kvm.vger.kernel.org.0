Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4194E64B53C
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 13:36:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234994AbiLMMgE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 07:36:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234740AbiLMMgC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 07:36:02 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87F6060EF
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 04:36:00 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id h16so6486166wrz.12
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 04:36:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jfoDaqyDi5g2SMMUF24M2o5M/2GLRFzHx+wauvWPlgQ=;
        b=RUnAyaXz2JFQXkf5dgXKJV9M0oDJESZyYkFT7wF9FlwaBHuPbbwscXuYCr6iatV0EW
         0cjPST/WmAs7jL+Ku7Sko0l9gWGIYm355S1wXkBrPAZYT6VwWBwwUaMRf8xwcTQqlpqW
         U6UKWAnIIPFnBTGoinUsbrcRFZQUKyLsjiSVAM2N10/nxVCUf6B5zLf23hI8I9ncKm9R
         A0QiEcXFmDIxm2/7EeZ7z3jN680gJMZPvbhKcbkbPnIt3csmMUvDIKym/FV6RlanBanf
         yVbX17Ng5k7SkpPfXSLjuh+Y0NI+2lpL7wGIDMgFGXx8X6fd6L7Cpf+/hhgxmZFSySuc
         YJqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jfoDaqyDi5g2SMMUF24M2o5M/2GLRFzHx+wauvWPlgQ=;
        b=kieSg9SrKqVO01x1Ql2M54Aecn5FxbD73NDOTNrqHfA8D4c+1IHocpX3tDCW1vVhgT
         4ZVjLD/WyCVPETjhuQNXbY4x5miYTnPy9ao0L79QiEVnc7wflMQiEX1edKdL5n5T+FIY
         Q4pMfuqd/HLc00ywYxHcnSw+0YK3xiKSYXOoQXFRsHgW3i7MEo5KjF11LBo2N+ECVjix
         XKAI/h8Y7h8abx8SEGBbdsMj40RwTRV5UTK1/Qui25bnDE93S85NN42s81XcYpWPkg1b
         yDzOUD6f2c3JZmKSAXpLcfz4pueDJ4aBsBzgleDitcOIFvCvdtQDXpe0YQ4AFyELuzP/
         wz4g==
X-Gm-Message-State: ANoB5pnmO37qPmmCZl8QrUARdptt2zZaBR04eI76NARCt/I4pqm3e/I9
        4AnV+dztyypzjb+ZrguQmSieAg==
X-Google-Smtp-Source: AA0mqf52yKem59QUTfrTjSFYRE9vr+JRXVc9MtIQxCiGer8yhcYzjgGgqwCKdD/1loTBA7u52JhqOQ==
X-Received: by 2002:a5d:6045:0:b0:242:24a7:c7f2 with SMTP id j5-20020a5d6045000000b0024224a7c7f2mr11925721wrt.58.1670934959132;
        Tue, 13 Dec 2022 04:35:59 -0800 (PST)
Received: from localhost.localdomain ([81.0.6.76])
        by smtp.gmail.com with ESMTPSA id e3-20020a5d5303000000b002366dd0e030sm11671653wrv.68.2022.12.13.04.35.57
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 13 Dec 2022 04:35:58 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        qemu-ppc@nongnu.org, David Gibson <david@gibson.dropbear.id.au>,
        kvm@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Greg Kurz <groug@kaod.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH-for-8.0 1/4] target/ppc/kvm: Add missing "cpu.h" and "exec/hwaddr.h"
Date:   Tue, 13 Dec 2022 13:35:47 +0100
Message-Id: <20221213123550.39302-2-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221213123550.39302-1-philmd@linaro.org>
References: <20221213123550.39302-1-philmd@linaro.org>
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

kvm_ppc.h is missing various declarations from "cpu.h":

  target/ppc/kvm_ppc.h:128:40: error: unknown type name 'CPUPPCState'; did you mean 'CPUState'?
  static inline int kvmppc_get_hypercall(CPUPPCState *env,
                                         ^~~~~~~~~~~
                                         CPUState
  include/qemu/typedefs.h:45:25: note: 'CPUState' declared here
  typedef struct CPUState CPUState;
                          ^
  target/ppc/kvm_ppc.h:134:40: error: unknown type name 'PowerPCCPU'
  static inline int kvmppc_set_interrupt(PowerPCCPU *cpu, int irq, int level)
                                         ^
  target/ppc/kvm_ppc.h:285:38: error: unknown type name 'hwaddr'
                                       hwaddr ptex, int n)
                                       ^
  target/ppc/kvm_ppc.h:220:15: error: unknown type name 'target_ulong'
  static inline target_ulong kvmppc_configure_v3_mmu(PowerPCCPU *cpu,
                ^
  target/ppc/kvm_ppc.h:286:38: error: unknown type name 'ppc_hash_pte64_t'
  static inline void kvmppc_read_hptes(ppc_hash_pte64_t *hptes,
                                       ^

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/ppc/kvm_ppc.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/target/ppc/kvm_ppc.h b/target/ppc/kvm_ppc.h
index ee9325bf9a..5fd9753953 100644
--- a/target/ppc/kvm_ppc.h
+++ b/target/ppc/kvm_ppc.h
@@ -9,6 +9,9 @@
 #ifndef KVM_PPC_H
 #define KVM_PPC_H
 
+#include "exec/hwaddr.h"
+#include "cpu.h"
+
 #define TYPE_HOST_POWERPC_CPU POWERPC_CPU_TYPE_NAME("host")
 
 #ifdef CONFIG_KVM
-- 
2.38.1

