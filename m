Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 068991D7D71
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 17:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728110AbgERPxU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 11:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728494AbgERPxT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 May 2020 11:53:19 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C38AC061A0C
        for <kvm@vger.kernel.org>; Mon, 18 May 2020 08:53:18 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id k13so10387422wrx.3
        for <kvm@vger.kernel.org>; Mon, 18 May 2020 08:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MwRjIJKrjZvOQLKRDS7bp2j+HXuefv0dlJUo1+WtTjQ=;
        b=egYB1VpdfFdcLU33RJfphrswTKxeIP4BjafZIjlthVmO7DNr1l7McScI+IvtmLndG9
         WjD9LpiJcPgoH1MQBUkML5lgSFY7x3NaGka7xlkROcXaUy0M0SBcrXd5T4VzdZLNz/tc
         JPL6wSS5HtdO9ff8Wg6X7bJESUkg8Ef8SEfUZKgdpq2BBN6kuw95k/w84PQl6K2QTuQC
         IfkMkWm7skqibMMRLPYi373AjZVNZgP9ah9kIfJgJMlSEaP6vC7XibL1zckb5Buz9xo2
         NTkPmJYYngauoD6KSjjGbIr3/BaenDgDt52tGVYYC0VdUp9L+LhUZnZUisxS9bM1br6K
         NHqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=MwRjIJKrjZvOQLKRDS7bp2j+HXuefv0dlJUo1+WtTjQ=;
        b=nzKuJg3kXUJnqFrGBHs4FQpsPZ+jg3Su7zTjS2R13N8v805XiaCk/87PoBsC4aayiX
         +3Zhp3ZehSJLgDUxepZO3ImQp1woZywWCb2a3zrauGwY7DmDPsIsfu6QT8pQ54jpbKF4
         jFlHTalT09P2le4KuhOhl/K07LJve9myjw4EGrOPoYOGEm+cvrFHzy8FVOmqiMFRwoLG
         vPUAoWUhFvY+JWIwrxhjDn3A5zNkAFTsZHXLgtAHUBcuBdZUOlWlpnjx72i0gmla3AkD
         Bh2HZXfCFUZOnWqNlZSabx5Z1KFlg568zVrhjeWBJ4Xjz82vTsvam/Y3EjAeC8bHWgF/
         SSOw==
X-Gm-Message-State: AOAM530WWcX1OEtJHdw/N0Tk69qXmH5i+VDtZ5B4Yc4knA/Al2tPKnqk
        CaKdaszq/L1tSHWjkcC0i1g=
X-Google-Smtp-Source: ABdhPJz1bQDAMP2DFoPgL6gHBe6UaVxFp/cuSu6npvqkdthflrPa4uaDYx8RUUQurNbZEJssxkBzSA==
X-Received: by 2002:a5d:6144:: with SMTP id y4mr21050664wrt.185.1589817197210;
        Mon, 18 May 2020 08:53:17 -0700 (PDT)
Received: from x1w.redhat.com (17.red-88-21-202.staticip.rima-tde.net. [88.21.202.17])
        by smtp.gmail.com with ESMTPSA id 7sm17647462wra.50.2020.05.18.08.53.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 08:53:16 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        qemu-arm@nongnu.org, Richard Henderson <rth@twiddle.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: [RFC PATCH v2 6/7] accel/kvm: Let KVM_EXIT_MMIO return error
Date:   Mon, 18 May 2020 17:53:07 +0200
Message-Id: <20200518155308.15851-7-f4bug@amsat.org>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20200518155308.15851-1-f4bug@amsat.org>
References: <20200518155308.15851-1-f4bug@amsat.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Give the hypervisor a possibility to catch any error
occuring during KVM_EXIT_MMIO.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
RFC because maybe we simply want to ignore this error instead
---
 accel/kvm/kvm-all.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
index d06cc04079..8dbcb8fda3 100644
--- a/accel/kvm/kvm-all.c
+++ b/accel/kvm/kvm-all.c
@@ -2357,6 +2357,7 @@ int kvm_cpu_exec(CPUState *cpu)
 
     do {
         MemTxAttrs attrs;
+        MemTxResult res;
 
         if (cpu->vcpu_dirty) {
             kvm_arch_put_registers(cpu, KVM_PUT_RUNTIME_STATE);
@@ -2429,12 +2430,12 @@ int kvm_cpu_exec(CPUState *cpu)
         case KVM_EXIT_MMIO:
             DPRINTF("handle_mmio\n");
             /* Called outside BQL */
-            address_space_rw(&address_space_memory,
-                             run->mmio.phys_addr, attrs,
-                             run->mmio.data,
-                             run->mmio.len,
-                             run->mmio.is_write);
-            ret = 0;
+            res = address_space_rw(&address_space_memory,
+                                   run->mmio.phys_addr, attrs,
+                                   run->mmio.data,
+                                   run->mmio.len,
+                                   run->mmio.is_write);
+            ret = res == MEMTX_OK ? 0 : -1;
             break;
         case KVM_EXIT_IRQ_WINDOW_OPEN:
             DPRINTF("irq_window_open\n");
-- 
2.21.3

