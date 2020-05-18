Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A64C1D7D73
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 17:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728500AbgERPxU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 11:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728493AbgERPxS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 May 2020 11:53:18 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 841D3C05BD09
        for <kvm@vger.kernel.org>; Mon, 18 May 2020 08:53:18 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id z4so27452wmi.2
        for <kvm@vger.kernel.org>; Mon, 18 May 2020 08:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AnPjL1oCKd4/b0PMNN6nSj2GzQNIyIXoJD4PkkEccRM=;
        b=Flh1kB0guv4yAbKeDYrp5crvlMR5ihhTkgC4sUeRwuaqgo7GD0MKjJWTUa6Hw2L8xS
         CIsyCqO5AvcZ8OwqPdLT8OmZa/ij6U5deh3S8uaWtf/VidtkoeX+VHIABeeardCArTHX
         XNSnRdTy+EpyBchdo7vAMIvPG9o1VFjX+MkOHh1KL+C8pX1vZ0yVTp7rYBokW9sBGV7p
         uaLB7O6eaQG+1utdhsPZlItO485bABIknYR8tYuO+twhZvT1wOLhGP6aF/ija6iTfvyZ
         QkiXHLZ+FGIYWRNLOIOko72PY6W/2aVr6hJAQD/zFfc6NyNFkhqADfHmd5GIQxeXeG49
         +otg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=AnPjL1oCKd4/b0PMNN6nSj2GzQNIyIXoJD4PkkEccRM=;
        b=BG5RaTet72lIkDFxtuVH9WQA0WJ+1pEuMpgYFRzHyxYbp2FxJINZVcy/X0P1mCWSiT
         Z0JescQusG+wzAOKfTUUdSu7RS4/EphvpIn+JxxeY9RbKdYA/mxz/cWEjltCfRBnG2Sj
         LgcOvhjWcjc/qXYaULPOErjth0qfK8z6VCUPwdv6tx4IWemQLcEyUTy5aC4//1XtWnKM
         5SkbQWYFXJ204udx8h04k8CAcVOjaw2Ydk40pixXinjfP/tGHvZWJxrOT8M+wLWiYoqC
         P0+GQh31oWbkZoOeX6UEDa1o+R3kF1d5M3l0ISI4rcNmIq5Q9oqKeF87/6gsgKv4MN8d
         j4tg==
X-Gm-Message-State: AOAM532qu3bDthAzZfvOhUpDJlqvlvlo1T9vhKkeVsEw86TPGDIrr/oC
        dyhtVjbIovUvyW40ErQqyr8=
X-Google-Smtp-Source: ABdhPJz/PtyrwAQIbRp4mpLoU+mt0aZlERs2l79lSNvZZ5pevIUK5/V9XwfG5nxxlERMi6Y3l+3eOA==
X-Received: by 2002:a1c:3187:: with SMTP id x129mr24994wmx.27.1589817196118;
        Mon, 18 May 2020 08:53:16 -0700 (PDT)
Received: from x1w.redhat.com (17.red-88-21-202.staticip.rima-tde.net. [88.21.202.17])
        by smtp.gmail.com with ESMTPSA id 7sm17647462wra.50.2020.05.18.08.53.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 08:53:15 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        qemu-arm@nongnu.org, Richard Henderson <rth@twiddle.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: [PATCH v2 5/7] hw/arm/boot: Abort if set_kernel_args() fails
Date:   Mon, 18 May 2020 17:53:06 +0200
Message-Id: <20200518155308.15851-6-f4bug@amsat.org>
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

If a address_space_write() fails while calling
set_kernel_args(), the guest kernel will boot
using crap data. Avoid that by aborting if this
ever occurs.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 hw/arm/boot.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/hw/arm/boot.c b/hw/arm/boot.c
index fef4072db1..7cc271034c 100644
--- a/hw/arm/boot.c
+++ b/hw/arm/boot.c
@@ -291,7 +291,8 @@ static inline bool have_dtb(const struct arm_boot_info *info)
 
 #define WRITE_WORD(p, value) do { \
     address_space_stl_notdirty(as, p, value, \
-                               MEMTXATTRS_UNSPECIFIED, NULL);  \
+                               MEMTXATTRS_UNSPECIFIED, &result); \
+    assert(result == MEMTX_OK); \
     p += 4;                       \
 } while (0)
 
@@ -300,6 +301,7 @@ static void set_kernel_args(const struct arm_boot_info *info, AddressSpace *as)
     int initrd_size = info->initrd_size;
     hwaddr base = info->loader_start;
     hwaddr p;
+    MemTxResult result;
 
     p = base + KERNEL_ARGS_ADDR;
     /* ATAG_CORE */
@@ -326,8 +328,9 @@ static void set_kernel_args(const struct arm_boot_info *info, AddressSpace *as)
         int cmdline_size;
 
         cmdline_size = strlen(info->kernel_cmdline);
-        address_space_write(as, p + 8, MEMTXATTRS_UNSPECIFIED,
-                            info->kernel_cmdline, cmdline_size + 1);
+        result = address_space_write(as, p + 8, MEMTXATTRS_UNSPECIFIED,
+                                     info->kernel_cmdline, cmdline_size + 1);
+        assert(result == MEMTX_OK);
         cmdline_size = (cmdline_size >> 2) + 1;
         WRITE_WORD(p, cmdline_size + 2);
         WRITE_WORD(p, 0x54410009);
@@ -341,8 +344,9 @@ static void set_kernel_args(const struct arm_boot_info *info, AddressSpace *as)
         atag_board_len = (info->atag_board(info, atag_board_buf) + 3) & ~3;
         WRITE_WORD(p, (atag_board_len + 8) >> 2);
         WRITE_WORD(p, 0x414f4d50);
-        address_space_write(as, p, MEMTXATTRS_UNSPECIFIED,
-                            atag_board_buf, atag_board_len);
+        result = address_space_write(as, p, MEMTXATTRS_UNSPECIFIED,
+                                     atag_board_buf, atag_board_len);
+        assert(result == MEMTX_OK);
         p += atag_board_len;
     }
     /* ATAG_END */
@@ -357,6 +361,7 @@ static void set_kernel_args_old(const struct arm_boot_info *info,
     const char *s;
     int initrd_size = info->initrd_size;
     hwaddr base = info->loader_start;
+    MemTxResult result;
 
     /* see linux/include/asm-arm/setup.h */
     p = base + KERNEL_ARGS_ADDR;
@@ -419,7 +424,9 @@ static void set_kernel_args_old(const struct arm_boot_info *info,
     }
     s = info->kernel_cmdline;
     if (s) {
-        address_space_write(as, p, MEMTXATTRS_UNSPECIFIED, s, strlen(s) + 1);
+        result = address_space_write(as, p, MEMTXATTRS_UNSPECIFIED,
+                                     s, strlen(s) + 1);
+        assert(result == MEMTX_OK);
     } else {
         WRITE_WORD(p, 0);
     }
-- 
2.21.3

