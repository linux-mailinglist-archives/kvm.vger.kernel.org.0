Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77D787B6208
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 09:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbjJCHEq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 03:04:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbjJCHEp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 03:04:45 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07CC183
        for <kvm@vger.kernel.org>; Tue,  3 Oct 2023 00:04:41 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id 2adb3069b0e04-5031ccf004cso623949e87.2
        for <kvm@vger.kernel.org>; Tue, 03 Oct 2023 00:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696316679; x=1696921479; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ck9fFBQ6PJmRxQ+9dHxfsblvqg5P8PS2Huy1TTlnqL4=;
        b=cWusvM89tihxVvoJeVAh62GKN9ZdzXdcn2U7bw1x9Io0j2A4moRrqY9vEgFTS1blru
         1cn2KGVKasYjL5C8t8ORhX+rkOanboBkhr7ljxRdWeG+f0I8S7Kw0aMJfawOeVZ7PMoU
         q214I6Z8HkPrIhe+qrm1wRnbcA3m18WUAksvVUGZkcBnzBwsGYPxRLaXNVN/l+dapJHF
         r1XYJCf/PN1MkK0w5Dm3Mrs93KoyALi63XVBFfxf8KNrISzpr0lQ40RdE/dW7Y6JF3wc
         YhD8SJr1K4/jMWQZOZvX+6M0QjxYgWHdkzKEiOZg29YkxmnkwvligRWwaZhO84JhzSJU
         Murg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696316679; x=1696921479;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ck9fFBQ6PJmRxQ+9dHxfsblvqg5P8PS2Huy1TTlnqL4=;
        b=WVRWgO7DBL57ra21pr86YC1g8n5LlCOIPOR9lrwvYBKjmEVqrw0TaSSz+BOAt09cCJ
         cBE5g6Kk+pxYuBMmZzehyrgcgwLRddVaqXqxdKp+ZIMwuxrXNHTB5SsIUnP89yz+PJ28
         Et574ULh6NJe5Gnn/3gqsmonoMMdMIcP5c9yI3N3vk9E8q+YVoqp/f3WBK09YMjI84QJ
         CfKY2H1DcWatAnO3nczymFX0/p5rACIUGcIF51ouG5CcjKDgGxeGhZCcHR/LSrDgrLb/
         PZ5w1WNGHesjtupKuDIpkaa4erJx0Yr6bWdin/MkIC2QZ5FN9NzL99N56inNuMW+Bymq
         yOMg==
X-Gm-Message-State: AOJu0YyWPEHV29PXYWR+Q5dFb4Q4TVv/7WluIdVYhDAOkqoeRCB6IgiA
        1+t+34alTgHaG/K+gAFDyRcOkQ==
X-Google-Smtp-Source: AGHT+IGryZXpTasDyIEnsH7yk7XUzG20teV6i2IANYrNa3Q4/4WtdfVUXfEaIbLjPIZ6q+as+mmEXw==
X-Received: by 2002:ac2:4567:0:b0:503:383c:996d with SMTP id k7-20020ac24567000000b00503383c996dmr10962753lfm.12.1696316679009;
        Tue, 03 Oct 2023 00:04:39 -0700 (PDT)
Received: from m1x-phil.lan (176-131-222-246.abo.bbox.fr. [176.131.222.246])
        by smtp.gmail.com with ESMTPSA id a8-20020a5d4d48000000b00324ae863ac1sm828475wru.35.2023.10.03.00.04.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 03 Oct 2023 00:04:38 -0700 (PDT)
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
Subject: [PATCH v2 1/4] sysemu/kvm: Restrict kvmppc_get_radix_page_info() to ppc targets
Date:   Tue,  3 Oct 2023 09:04:23 +0200
Message-ID: <20231003070427.69621-2-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231003070427.69621-1-philmd@linaro.org>
References: <20231003070427.69621-1-philmd@linaro.org>
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

kvm_get_radix_page_info() is only defined for ppc targets (in
target/ppc/kvm.c). The declaration is not useful in other targets,
reduce its scope.
Rename using the 'kvmppc_' prefix following other declarations
from target/ppc/kvm_ppc.h.

Suggested-by: Michael Tokarev <mjt@tls.msk.ru>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/sysemu/kvm.h | 1 -
 target/ppc/kvm.c     | 4 ++--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
index ee9025f8e9..3bcd8f45be 100644
--- a/include/sysemu/kvm.h
+++ b/include/sysemu/kvm.h
@@ -551,7 +551,6 @@ int kvm_set_one_reg(CPUState *cs, uint64_t id, void *source);
  * Returns: 0 on success, or a negative errno on failure.
  */
 int kvm_get_one_reg(CPUState *cs, uint64_t id, void *target);
-struct ppc_radix_page_info *kvm_get_radix_page_info(void);
 int kvm_get_max_memslots(void);
 
 /* Notify resamplefd for EOI of specific interrupts. */
diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index 51112bd367..19fe6d2d00 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -268,7 +268,7 @@ static void kvm_get_smmu_info(struct kvm_ppc_smmu_info *info, Error **errp)
                      "KVM failed to provide the MMU features it supports");
 }
 
-struct ppc_radix_page_info *kvm_get_radix_page_info(void)
+static struct ppc_radix_page_info *kvmppc_get_radix_page_info(void)
 {
     KVMState *s = KVM_STATE(current_accel());
     struct ppc_radix_page_info *radix_page_info;
@@ -2372,7 +2372,7 @@ static void kvmppc_host_cpu_class_init(ObjectClass *oc, void *data)
     }
 
 #if defined(TARGET_PPC64)
-    pcc->radix_page_info = kvm_get_radix_page_info();
+    pcc->radix_page_info = kvmppc_get_radix_page_info();
 
     if ((pcc->pvr & 0xffffff00) == CPU_POWERPC_POWER9_DD1) {
         /*
-- 
2.41.0

