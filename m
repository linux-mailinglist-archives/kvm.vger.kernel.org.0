Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB0296D82F2
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 18:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238021AbjDEQFz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 12:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239059AbjDEQFu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 12:05:50 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F35F61A9
        for <kvm@vger.kernel.org>; Wed,  5 Apr 2023 09:05:45 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id n19so21204566wms.0
        for <kvm@vger.kernel.org>; Wed, 05 Apr 2023 09:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680710744;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1nroHqABUajLqRunlI+qD37HAN4v8HXiRYQrqBTvdwE=;
        b=qw5qTTc4CNQPm1h/LZ0mTTXy0OF7gIZq7jkcglSCTingvHz0cqXrBwBojetrVCnaEU
         V3XSlu7iPDyJb/v2VW6Mfo7ZEcibrTott+zYeXs/SZP1HCHBMI39vaj3sfGTFwJQbfZo
         bPbd459qPJhpcD9HW2tSPRWW6uWhsivNaPaKQ8L/mgDLhLP0gasJOaP/HIEJmenRuRRk
         umwaalz/6EAfiwgdglIA20tavSVgQWBEjmI01ISEOl/XiJZYm6MLszMBTX98bQRndoHx
         htVpU34jeAGTXaELsldCnNYgFUNan9n4kpcE+bf1j5dhHWTQfNnLz94EFHsmMlTBB75M
         MoXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680710744;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1nroHqABUajLqRunlI+qD37HAN4v8HXiRYQrqBTvdwE=;
        b=vuRRPaVT5JuYDYo7Kz2qxTtqV3+drfKKRji4vVyRyrn1rG0TiLCwhoc4zH0BSD002o
         TPtmaeUgBwe2d0kmYKj/Bnf73PBs2uWV9kVsICadeQ2pzw+oD1TUgoePSjSYo77HpstJ
         bDB3MJrz4v+DiCCR7lrVPDmEf4Az3WiJvVuHsL5FoUg3q/Hv3XoDbuhWa2GtFxttyp9w
         ZI82OXSAC1/nQxB8b3p6CHpfwFViHb/EIg2+mvPwKaO3DtDAzG4swHTciD0D4vQZFO3w
         O7CRTfvg7TO2W5DmPNzvvtyo99eRuQT+Kp0ywS/aNVq7pYYVlNMcSqqLfC6oJ/kTeedB
         mIvA==
X-Gm-Message-State: AAQBX9ciW6jmQJMV7lmAlH2q/TGP1e/VqB55NXn+SgHAKytk7Yye+AVz
        2XbKiJSpiMf1ncx4cmOJI9axPg==
X-Google-Smtp-Source: AKy350avtCPFICutt8vrOag6ZCtLMApHyjgYl5gdC/mIgFAzkBuA1jps8xP9/D8yQimuv1rVe3m43w==
X-Received: by 2002:a05:600c:20f:b0:3da:2ba4:b97 with SMTP id 15-20020a05600c020f00b003da2ba40b97mr2228281wmi.19.1680710743845;
        Wed, 05 Apr 2023 09:05:43 -0700 (PDT)
Received: from localhost.localdomain (4ab54-h01-176-184-52-81.dsl.sta.abo.bbox.fr. [176.184.52.81])
        by smtp.gmail.com with ESMTPSA id o11-20020a05600c4fcb00b003ebff290a52sm2565572wmq.28.2023.04.05.09.05.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 05 Apr 2023 09:05:43 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     qemu-s390x@nongnu.org, qemu-riscv@nongnu.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        qemu-arm@nongnu.org, kvm@vger.kernel.org, qemu-ppc@nongnu.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Greg Kurz <groug@kaod.org>
Subject: [PATCH 08/10] target/ppc: Restrict KVM-specific field from ArchCPU
Date:   Wed,  5 Apr 2023 18:04:52 +0200
Message-Id: <20230405160454.97436-9-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230405160454.97436-1-philmd@linaro.org>
References: <20230405160454.97436-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The 'kvm_sw_tlb' field shouldn't be accessed when KVM is not available.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/ppc/cpu.h        | 2 ++
 target/ppc/mmu_common.c | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/target/ppc/cpu.h b/target/ppc/cpu.h
index 557d736dab..0ec3957397 100644
--- a/target/ppc/cpu.h
+++ b/target/ppc/cpu.h
@@ -1148,7 +1148,9 @@ struct CPUArchState {
     int tlb_type;    /* Type of TLB we're dealing with */
     ppc_tlb_t tlb;   /* TLB is optional. Allocate them only if needed */
     bool tlb_dirty;  /* Set to non-zero when modifying TLB */
+#ifdef CONFIG_KVM
     bool kvm_sw_tlb; /* non-zero if KVM SW TLB API is active */
+#endif /* CONFIG_KVM */
     uint32_t tlb_need_flush; /* Delayed flush needed */
 #define TLB_NEED_LOCAL_FLUSH   0x1
 #define TLB_NEED_GLOBAL_FLUSH  0x2
diff --git a/target/ppc/mmu_common.c b/target/ppc/mmu_common.c
index 7235a4befe..21843c69f6 100644
--- a/target/ppc/mmu_common.c
+++ b/target/ppc/mmu_common.c
@@ -917,10 +917,12 @@ static void mmubooke_dump_mmu(CPUPPCState *env)
     ppcemb_tlb_t *entry;
     int i;
 
+#ifdef CONFIG_KVM
     if (kvm_enabled() && !env->kvm_sw_tlb) {
         qemu_printf("Cannot access KVM TLB\n");
         return;
     }
+#endif
 
     qemu_printf("\nTLB:\n");
     qemu_printf("Effective          Physical           Size PID   Prot     "
@@ -1008,10 +1010,12 @@ static void mmubooke206_dump_mmu(CPUPPCState *env)
     int offset = 0;
     int i;
 
+#ifdef CONFIG_KVM
     if (kvm_enabled() && !env->kvm_sw_tlb) {
         qemu_printf("Cannot access KVM TLB\n");
         return;
     }
+#endif
 
     for (i = 0; i < BOOKE206_MAX_TLBN; i++) {
         int size = booke206_tlb_size(env, i);
-- 
2.38.1

