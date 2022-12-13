Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6580864B53F
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 13:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234999AbiLMMgV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 07:36:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234798AbiLMMgS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 07:36:18 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C028D164BD
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 04:36:16 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id bg10so8194103wmb.1
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 04:36:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EIWqF960/rg6gqFejdnkrSGn2PEdfww2KszocKY9NPM=;
        b=h+gcwRarxYHjDQt6eSyU6mMb0ymg/ujMpr/wyp/9NOXKwuVevsa2yuezcU38aA6uR6
         EgIrEBN6stZqv94xqIx1RCw3f2THn/jyeyfS3pp8+5l4OVRciFQf4RGrOJcsrgOZrb+W
         /UgIenJ71XQQYqRl07SuUEGXJFw3kRU5W4AP6MNJlgUVyH+IQBn8P/gBnYW/8PyXFjjT
         7qrpQPkacbCf7KNPFamMzHqj6FSCnjenY/SZwxTNqpgykDjL3eS5PQBeFY2AATyiFpcm
         UA4WpWOcvjMpG62XkYMzgJriRHmuK97wk4cyMPnuYWKn2rrBYZ8fHqx1FNQ77WpX9igD
         myZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EIWqF960/rg6gqFejdnkrSGn2PEdfww2KszocKY9NPM=;
        b=DTenl8J9ljL+vYg33frRL17PPMKD+Ewq6GgpASS6tBG+h9Mw2AB1Uhz6WpxwmkaOx1
         XpcPVrxC/Q1GFuTogq36Qdiq/5c9HkiaALP+PrR5V+1OKMVvPz4Beu4M9wKt2SJGXNci
         487JxSEDrYWc1nV1vvMuHfgiFe0nU6l52/GBEGZbrtrFHxGSWncOoXQ3Uyn40Rrv5PZU
         o/pvC4OVRid3lOQ/Z8XuMZUk0T/C7m7R3mP5z6SlQkb2CvStNJYeI5fzTGhB6oBYCWhW
         d0ZRZALFhveJo5lZGkOJoitOZTtMYyqotRPxBNuPhHiGFBez3oYFRr5n0l0fv6UQZSHR
         fKhQ==
X-Gm-Message-State: ANoB5pnVwjrvXadFFGZ+LS9ifs5Gzj537VFnZ6v8FQ3Q+1HV1SZ1914V
        baHOtauhfWoMLfhah/YWsXwTIg==
X-Google-Smtp-Source: AA0mqf7dkCjTxnH6apRlWOJdUMUEZAV5hp9evrnE4rLoQ6DaTgUx1600ij+Ta4YGbtEpSlYE+HcuzA==
X-Received: by 2002:a05:600c:1c06:b0:3cf:71f9:3b4c with SMTP id j6-20020a05600c1c0600b003cf71f93b4cmr14756046wms.23.1670934975281;
        Tue, 13 Dec 2022 04:36:15 -0800 (PST)
Received: from localhost.localdomain ([81.0.6.76])
        by smtp.gmail.com with ESMTPSA id j17-20020a05600c1c1100b003cfd42821dasm14467122wms.3.2022.12.13.04.36.14
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 13 Dec 2022 04:36:14 -0800 (PST)
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
Subject: [PATCH-for-8.0 4/4] hw/ppc/spapr_ovec: Avoid target_ulong spapr_ovec_parse_vector()
Date:   Tue, 13 Dec 2022 13:35:50 +0100
Message-Id: <20221213123550.39302-5-philmd@linaro.org>
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

spapr_ovec.c is a device, but it uses target_ulong which is
target specific. The hwaddr type (declared in "exec/hwaddr.h")
better fits hardware addresses.

Change spapr_ovec_parse_vector() to take a hwaddr argument,
allowing the removal of "cpu.h" in a device header.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 hw/ppc/spapr_ovec.c         | 3 ++-
 include/hw/ppc/spapr_ovec.h | 4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/hw/ppc/spapr_ovec.c b/hw/ppc/spapr_ovec.c
index b2567caa5c..a18a751b57 100644
--- a/hw/ppc/spapr_ovec.c
+++ b/hw/ppc/spapr_ovec.c
@@ -19,6 +19,7 @@
 #include "qemu/error-report.h"
 #include "trace.h"
 #include <libfdt.h>
+#include "cpu.h"
 
 #define OV_MAXBYTES 256 /* not including length byte */
 #define OV_MAXBITS (OV_MAXBYTES * BITS_PER_BYTE)
@@ -176,7 +177,7 @@ static target_ulong vector_addr(target_ulong table_addr, int vector)
     return table_addr;
 }
 
-SpaprOptionVector *spapr_ovec_parse_vector(target_ulong table_addr, int vector)
+SpaprOptionVector *spapr_ovec_parse_vector(hwaddr table_addr, int vector)
 {
     SpaprOptionVector *ov;
     target_ulong addr;
diff --git a/include/hw/ppc/spapr_ovec.h b/include/hw/ppc/spapr_ovec.h
index c3e8b98e7e..d756b916e4 100644
--- a/include/hw/ppc/spapr_ovec.h
+++ b/include/hw/ppc/spapr_ovec.h
@@ -37,7 +37,7 @@
 #ifndef SPAPR_OVEC_H
 #define SPAPR_OVEC_H
 
-#include "cpu.h"
+#include "exec/hwaddr.h"
 
 typedef struct SpaprOptionVector SpaprOptionVector;
 
@@ -73,7 +73,7 @@ void spapr_ovec_set(SpaprOptionVector *ov, long bitnr);
 void spapr_ovec_clear(SpaprOptionVector *ov, long bitnr);
 bool spapr_ovec_test(SpaprOptionVector *ov, long bitnr);
 bool spapr_ovec_empty(SpaprOptionVector *ov);
-SpaprOptionVector *spapr_ovec_parse_vector(target_ulong table_addr, int vector);
+SpaprOptionVector *spapr_ovec_parse_vector(hwaddr table_addr, int vector);
 int spapr_dt_ovec(void *fdt, int fdt_offset,
                   SpaprOptionVector *ov, const char *name);
 
-- 
2.38.1

