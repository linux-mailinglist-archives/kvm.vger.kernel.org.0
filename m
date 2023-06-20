Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2F1E736642
	for <lists+kvm@lfdr.de>; Tue, 20 Jun 2023 10:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbjFTIdH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jun 2023 04:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231902AbjFTIcs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jun 2023 04:32:48 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB19510DB
        for <kvm@vger.kernel.org>; Tue, 20 Jun 2023 01:32:46 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-9875c2d949eso537213266b.0
        for <kvm@vger.kernel.org>; Tue, 20 Jun 2023 01:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687249965; x=1689841965;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hHeaAAV3ecaC5191lrrTDI3ODMtZRKyKR+rtQqyfdog=;
        b=iUJ4og1PJgdDP6JnKHhDGXUT//pbRS55dQgwdlVQtEZpmnboLcwkfCsd4/3IIMQ0dn
         GZplQoJWfNw0blvx+00gBvsyhl4XAMIP2Bk0cE6cPVUdu4uH3Qs3YWxMZGYsZKierlkG
         nE+mtGIEIO36AG6pUNQudPmEzXcDV6ppGefdT/gqVG4hvo42QOVgSJX9nMv+GcHNqC9c
         7sb8TbGyBYaxpB5W2MKsfKWQc9Yhx8twrfolQY8N8x2yjx46VR6VaG3sus2Pj1niLYMu
         zmh8pDLQv6KP5E1N8fND45TJhadTsU6n3ZpJTB9yFYclY9lwHrtGIdZAUl7DobIESibO
         LfSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687249965; x=1689841965;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hHeaAAV3ecaC5191lrrTDI3ODMtZRKyKR+rtQqyfdog=;
        b=fQsjEgacvMUVsps4Tuz0QTV95FRtvfmMzXeOUdoxiyFzoIrMlNGX3Ti3741n61A56S
         rfPqjIusz8kjdprWI4HKRChwJvVuk+/CDT69hCAhZAd0DlJFOllsrqNl7FTbuRu03zAf
         L0xwllF/Gm33Y0pb1hWByNtnejVhyJvPgwKooyCcronlhnGqeW2xq1wTKjB2zHZisQqE
         G4TOcUpoLcn2jXJUyLFt3sk7V9UlnpZVC/MsV3hES3uaCv1cZHjEA67XwCPw2XrywU30
         xCJaGL7Wxrh6/qFh/zDNkDXIK1kyC655aWOMrgLPU+oz2c2hM8xOM64FvYNCIdLYuIsa
         xKRw==
X-Gm-Message-State: AC+VfDwG6+xh8UffSs94ALvr45FPdtWD9zKHtzUKJQ9mjiW2qEdL+3au
        BPp5OWfZ0UBO3Ej3MmEEaRiMIw==
X-Google-Smtp-Source: ACHHUZ4UQEVkPGp1WAPzNmVO4iWeLfrCmRjmykMSyJoyHLqFKHxkyJYu5Z2v6NfXdbp8+JrvuiJMEw==
X-Received: by 2002:a17:907:7fa4:b0:977:e916:9b83 with SMTP id qk36-20020a1709077fa400b00977e9169b83mr14118889ejc.8.1687249965484;
        Tue, 20 Jun 2023 01:32:45 -0700 (PDT)
Received: from m1x-phil.lan ([176.176.183.29])
        by smtp.gmail.com with ESMTPSA id s19-20020a170906355300b0098921e1b064sm784307eja.181.2023.06.20.01.32.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 20 Jun 2023 01:32:45 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sergio Lopez <slp@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [RFC PATCH 2/2] hw/i386: Rename 'hw/kvm/clock.h' -> 'hw/i386/kvm/clock.h'
Date:   Tue, 20 Jun 2023 10:32:28 +0200
Message-Id: <20230620083228.88796-3-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230620083228.88796-1-philmd@linaro.org>
References: <20230620083228.88796-1-philmd@linaro.org>
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

kvmclock_create() is only implemented in hw/i386/kvm/clock.h.
Restrict the "hw/kvm/clock.h" header to i386 by moving it to
hw/i386/.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
RFC: No other arch had to implement this for 12 years,
     safe enough to restrict to x86?
---
 {include/hw => hw/i386}/kvm/clock.h | 4 ++--
 hw/i386/kvm/clock.c                 | 2 +-
 hw/i386/microvm.c                   | 2 +-
 hw/i386/pc_piix.c                   | 2 +-
 hw/i386/pc_q35.c                    | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)
 rename {include/hw => hw/i386}/kvm/clock.h (85%)

diff --git a/include/hw/kvm/clock.h b/hw/i386/kvm/clock.h
similarity index 85%
rename from include/hw/kvm/clock.h
rename to hw/i386/kvm/clock.h
index 3efe0a871c..401c7e445b 100644
--- a/include/hw/kvm/clock.h
+++ b/hw/i386/kvm/clock.h
@@ -10,8 +10,8 @@
  * See the COPYING file in the top-level directory.
  */
 
-#ifndef HW_KVM_CLOCK_H
-#define HW_KVM_CLOCK_H
+#ifndef HW_I386_KVM_CLOCK_H
+#define HW_I386_KVM_CLOCK_H
 
 void kvmclock_create(bool create_always);
 
diff --git a/hw/i386/kvm/clock.c b/hw/i386/kvm/clock.c
index 0824c6d313..34348a3324 100644
--- a/hw/i386/kvm/clock.c
+++ b/hw/i386/kvm/clock.c
@@ -22,7 +22,7 @@
 #include "kvm/kvm_i386.h"
 #include "migration/vmstate.h"
 #include "hw/sysbus.h"
-#include "hw/kvm/clock.h"
+#include "hw/i386/kvm/clock.h"
 #include "hw/qdev-properties.h"
 #include "qapi/error.h"
 
diff --git a/hw/i386/microvm.c b/hw/i386/microvm.c
index 6b762bc18e..8deeb62774 100644
--- a/hw/i386/microvm.c
+++ b/hw/i386/microvm.c
@@ -32,7 +32,7 @@
 
 #include "hw/loader.h"
 #include "hw/irq.h"
-#include "hw/kvm/clock.h"
+#include "hw/i386/kvm/clock.h"
 #include "hw/i386/microvm.h"
 #include "hw/i386/x86.h"
 #include "target/i386/cpu.h"
diff --git a/hw/i386/pc_piix.c b/hw/i386/pc_piix.c
index 715c063eec..85fe41327c 100644
--- a/hw/i386/pc_piix.c
+++ b/hw/i386/pc_piix.c
@@ -46,7 +46,7 @@
 #include "hw/ide/piix.h"
 #include "hw/irq.h"
 #include "sysemu/kvm.h"
-#include "hw/kvm/clock.h"
+#include "hw/i386/kvm/clock.h"
 #include "hw/sysbus.h"
 #include "hw/i2c/smbus_eeprom.h"
 #include "exec/memory.h"
diff --git a/hw/i386/pc_q35.c b/hw/i386/pc_q35.c
index a0553f70f7..9e6602dfde 100644
--- a/hw/i386/pc_q35.c
+++ b/hw/i386/pc_q35.c
@@ -35,7 +35,7 @@
 #include "hw/i2c/smbus_eeprom.h"
 #include "hw/rtc/mc146818rtc.h"
 #include "sysemu/kvm.h"
-#include "hw/kvm/clock.h"
+#include "hw/i386/kvm/clock.h"
 #include "hw/pci-host/q35.h"
 #include "hw/pci/pcie_port.h"
 #include "hw/qdev-properties.h"
-- 
2.38.1

