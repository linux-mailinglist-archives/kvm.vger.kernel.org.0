Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53D91626104
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 19:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233552AbiKKSZr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 13:25:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232004AbiKKSZq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 13:25:46 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EE574C245
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 10:25:44 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id i10-20020a1c3b0a000000b003cfd36eff5fso1014068wma.3
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 10:25:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6dm7DBaeF2cZRUQRIT8/o6GsqUIEGkYXBsJF1ojYAj4=;
        b=AT72/gVzz/G3lnUWXnEtof6ozMWw4x/rYcZ9P5tmEt8Cu6ZfWVbPR4JWiqAOVi0kSF
         0ak7KsvpNktUhzJz13lTifofLWxlbO9X4d1qqHUooBLXsFL0hR7hekp1Olg2tR5cilU/
         b6iXsQt5WBuf6tozUsDooFYYVfGE96zxUHtmFAm3GhhF8htojljSqO2mDIwq8Nl1soof
         AlHzrb3HjERj8+N/Q7MbcLA0+qNFNrcU53c0MAAjvjkvFSpxkGADOGsIL0dlDR5r5ZkH
         HS7KEhrd9cniZIJbYVV7xIxugRsPJhb6XOT9LPSK288M1PDN9jDipvN3WExZ1ayAeDid
         Wi3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6dm7DBaeF2cZRUQRIT8/o6GsqUIEGkYXBsJF1ojYAj4=;
        b=0eJNnLuDGr/PKzPfOKU3oclQtNmPhbtS5dGMjQo1o0jK+U3x0FtD/FUQdFyvNJKIr1
         Q3HKfzdB6+G5reR3Oy75K70zJOdpxmCpVobAawCWvhiDYYpPBpaxzGW2BE28ZKoCSs/4
         zKYwKG+/X3PTaDGzm6hytmIRueGkVSK4mxSTOqFpOI9dhsF0uZ6h7P92u6Xif6fgvWhf
         Hqhmawz6rKmw7v7Hx/IOYrn+LqBgYPIFZyAHw1xhLppN3v0cjRWjGEZmGvDKWBIUc8T7
         QDC7ix08yqnd5QiuLL+brCHy3JNnF2+92ZD95ugMcoTFRAqaY2hKCZEjhIAIvK2t7H5u
         FXVw==
X-Gm-Message-State: ANoB5pnENIjClTJH00WdgqK2YaJn5Vk0kbzvpt0/cXd0a/sg1Ms2v0cB
        YzS8RGWADDbsbePqCBGUddhTvw==
X-Google-Smtp-Source: AA0mqf4adk2iYCplPi3wAvPHF1xVMIQj2fVItCLPwnWdOm1lfV0nOh2WKkQbDjmIATX0J8JMy80aDg==
X-Received: by 2002:a1c:4b0f:0:b0:3cf:4d14:5705 with SMTP id y15-20020a1c4b0f000000b003cf4d145705mr2152063wma.35.1668191143204;
        Fri, 11 Nov 2022 10:25:43 -0800 (PST)
Received: from zen.linaroharston ([185.81.254.11])
        by smtp.gmail.com with ESMTPSA id f24-20020a1cc918000000b003b4935f04a4sm4435427wmb.5.2022.11.11.10.25.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 10:25:39 -0800 (PST)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id 30F011FFC5;
        Fri, 11 Nov 2022 18:25:37 +0000 (GMT)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     f4bug@amsat.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        kvm@vger.kernel.org (open list:Overall KVM CPUs)
Subject: [PATCH  v5 15/20] hw/i386: update vapic_write to use MemTxAttrs
Date:   Fri, 11 Nov 2022 18:25:30 +0000
Message-Id: <20221111182535.64844-16-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221111182535.64844-1-alex.bennee@linaro.org>
References: <20221111182535.64844-1-alex.bennee@linaro.org>
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

This allows us to drop the current_cpu hack and properly model an
invalid access to the vapic.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 hw/i386/kvmvapic.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/hw/i386/kvmvapic.c b/hw/i386/kvmvapic.c
index 43f8a8f679..a76ed07199 100644
--- a/hw/i386/kvmvapic.c
+++ b/hw/i386/kvmvapic.c
@@ -635,20 +635,21 @@ static int vapic_prepare(VAPICROMState *s)
     return 0;
 }
 
-static void vapic_write(void *opaque, hwaddr addr, uint64_t data,
-                        unsigned int size)
+static MemTxResult vapic_write(void *opaque, hwaddr addr, uint64_t data,
+                               unsigned int size, MemTxAttrs attrs)
 {
     VAPICROMState *s = opaque;
+    CPUState *cs;
     X86CPU *cpu;
     CPUX86State *env;
     hwaddr rom_paddr;
 
-    if (!current_cpu) {
-        return;
+    if (attrs.requester_type != MTRT_CPU) {
+        return MEMTX_ACCESS_ERROR;
     }
-
-    cpu_synchronize_state(current_cpu);
-    cpu = X86_CPU(current_cpu);
+    cs = qemu_get_cpu(attrs.requester_id);
+    cpu_synchronize_state(cs);
+    cpu = X86_CPU(cs);
     env = &cpu->env;
 
     /*
@@ -708,6 +709,8 @@ static void vapic_write(void *opaque, hwaddr addr, uint64_t data,
         }
         break;
     }
+
+    return MEMTX_OK;
 }
 
 static uint64_t vapic_read(void *opaque, hwaddr addr, unsigned size)
@@ -716,7 +719,7 @@ static uint64_t vapic_read(void *opaque, hwaddr addr, unsigned size)
 }
 
 static const MemoryRegionOps vapic_ops = {
-    .write = vapic_write,
+    .write_with_attrs = vapic_write,
     .read = vapic_read,
     .endianness = DEVICE_NATIVE_ENDIAN,
 };
-- 
2.34.1

