Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D34A079CFEA
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 13:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234567AbjILLav (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 07:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232345AbjILLam (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 07:30:42 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C22F510D2
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 04:30:38 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id 38308e7fff4ca-2bcb89b4767so90374381fa.3
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 04:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694518236; x=1695123036; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=21QMJ7GGkeglUQqOfSInY5x1p67Ji2fztTn3JUMzTjQ=;
        b=u1kCPa4UR0KdAj+q5r6ikP/fz6yMtAei4/3/fTBR8/YBlAqZFnVu+GTX1LEBUP6ORb
         gE7QMy5t3Fgl3HRxCEmvKQzdgy0eLfrtOkiLWH4dINk5SQr3UOWQlAOuKXqRvCkYWEBF
         IjfFM4r8J/g+gED+/dnZWDVEx0FkfHS7AzxWT6pbGet9SsjYuH5+8Dm5M7gl8Kd82tAO
         X9Hk2bAKX6g2vk33tUsotFWTUNL24vJiZRxcoKttT+VN/toD23fxMdmiILhdvNVMnttQ
         Tt2M4HCf2iXfqC0szs9ExcxAw279R4eXW1/h4cevk3WP2jJNi8hAaZYm7asocBW7k8GF
         zOOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694518236; x=1695123036;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=21QMJ7GGkeglUQqOfSInY5x1p67Ji2fztTn3JUMzTjQ=;
        b=FQn+Z0ILShQanay2B/mJFR4ZwTX4xrHZkgZd6T8Dvve9wvBQFYmAUMt0q8p7daBb87
         Rqt8UxO47H1k/ExoZ0DrVrhiq2QPeufGT5y4Z2nAM8IuX25frzHCKgi80ecdePZDezkX
         LVCoYi1DHmRZwn2jjfX3nLLYFrAO4LDdXsQeFTnn0jsIGtv8uMXL36pFK3JErYaxcD1X
         oHatKKDEGACW+RK0FQEOcypkZ0YMIT7g7gawRfdN/KqzXSmwSjn1DAQUsI+u3rgZ7fID
         vPnFb8KXzjA6vb2aRxB7PtdcENMdT1WshQIjJoC+l9Q7tffjGoQa4yAC/MfZyRl8Hrvi
         K83g==
X-Gm-Message-State: AOJu0YwwQupjFGIw4mj4QpIdMBJkSO0A/NlZfIf4AWAFuPpzFNxrdF3p
        LmC4cXtfh2xnvRE47UJ9O09rHz5EWOPEe1S42o8=
X-Google-Smtp-Source: AGHT+IGrmkxUF4fF6+bNXffo8F8gG9e/Ung4GKdfh9dcnF2dShXSPiBar0HZ/5nMx033pCom6oSwBw==
X-Received: by 2002:a2e:7c1a:0:b0:2bc:c846:aa17 with SMTP id x26-20020a2e7c1a000000b002bcc846aa17mr10295292ljc.41.1694518236658;
        Tue, 12 Sep 2023 04:30:36 -0700 (PDT)
Received: from m1x-phil.lan (cou50-h01-176-172-50-150.dsl.sta.abo.bbox.fr. [176.172.50.150])
        by smtp.gmail.com with ESMTPSA id l26-20020a1709061c5a00b009894b476310sm6628964ejg.163.2023.09.12.04.30.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 12 Sep 2023 04:30:36 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        qemu-ppc@nongnu.org,
        Richard Henderson <richard.henderson@linaro.org>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Michael Tokarev <mjt@tls.msk.ru>, Greg Kurz <groug@kaod.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 1/4] sysemu/kvm: Restrict kvmppc_get_radix_page_info() to ppc targets
Date:   Tue, 12 Sep 2023 13:30:23 +0200
Message-ID: <20230912113027.63941-2-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230912113027.63941-1-philmd@linaro.org>
References: <20230912113027.63941-1-philmd@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_get_radix_page_info() is only defined for ppc targets (in
target/ppc/kvm.c). The declaration is not useful in other targets.
Rename using the 'kvmppc_' prefix following other declarations
from target/ppc/kvm_ppc.h.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/sysemu/kvm.h | 1 -
 target/ppc/kvm_ppc.h | 2 ++
 target/ppc/kvm.c     | 4 ++--
 3 files changed, 4 insertions(+), 3 deletions(-)

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
diff --git a/target/ppc/kvm_ppc.h b/target/ppc/kvm_ppc.h
index 6a4dd9c560..440e93f923 100644
--- a/target/ppc/kvm_ppc.h
+++ b/target/ppc/kvm_ppc.h
@@ -89,6 +89,8 @@ void kvmppc_set_reg_tb_offset(PowerPCCPU *cpu, int64_t tb_offset);
 
 int kvm_handle_nmi(PowerPCCPU *cpu, struct kvm_run *run);
 
+struct ppc_radix_page_info *kvmppc_get_radix_page_info(void);
+
 #define kvmppc_eieio() \
     do {                                          \
         if (kvm_enabled()) {                          \
diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index 51112bd367..a58708cdfc 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -268,7 +268,7 @@ static void kvm_get_smmu_info(struct kvm_ppc_smmu_info *info, Error **errp)
                      "KVM failed to provide the MMU features it supports");
 }
 
-struct ppc_radix_page_info *kvm_get_radix_page_info(void)
+struct ppc_radix_page_info *kvmppc_get_radix_page_info(void)
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

