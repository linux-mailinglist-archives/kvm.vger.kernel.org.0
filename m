Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8AF539840B
	for <lists+kvm@lfdr.de>; Wed,  2 Jun 2021 10:26:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbhFBI1k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 04:27:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47988 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232553AbhFBI1k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 04:27:40 -0400
Received: from mail-pj1-f69.google.com ([209.85.216.69])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <po-hsu.lin@canonical.com>)
        id 1loMCK-00074h-IR
        for kvm@vger.kernel.org; Wed, 02 Jun 2021 08:25:56 +0000
Received: by mail-pj1-f69.google.com with SMTP id j8-20020a17090a8408b02901651fe80217so1010669pjn.1
        for <kvm@vger.kernel.org>; Wed, 02 Jun 2021 01:25:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xbQcGiodPWh6gOeS43hcB6RdC+/EN+hEVrh9/5lw9BA=;
        b=bULKexXwbK5DNrxIXJ4PEB2HuHy4ZlKgzGjtw/ZJo20mGUXBtqa5b/kZ1eVR34p1Zq
         f6iXDlcYhu0oARrYXjR8XpxEFNYX4/Mu3XFEE5GfFTbxUad6JN2sGVBnSWty1iPEvbIP
         KcEC8Au5vGF3ascRsoCK9WoEDE6URlEaSFxYS4HO96kxE8gRPZC9SVJzb17B+x8OJmur
         LQlCNM6JKyee71RP00nT5f6QMzSdojzPthhHcXF/CalOVLc29xa2oFv4n/njRP2nMxgG
         9cCaVEi6yXjBDctgBWj/iRZ4gtnbTaRXj26AVTcbSiM7nvw1x16K85bnHIn86wJS5smj
         qZqQ==
X-Gm-Message-State: AOAM533K+WD4OPwo2cDPY7roz4/5vx/LspKfJFHQR/LOGBj5HAupKMhg
        bLlnTnqOw3WZ6Lk1y5ZyYR+jHAeTot4UOgIPiCRtWljPVIrI+3Q8qEZTPa0ZgYXOoPcRA5D7y9V
        xiqpfeSwkXeBSx/EtJtu9Lrx82MMY
X-Received: by 2002:a63:e64b:: with SMTP id p11mr6991368pgj.25.1622622355300;
        Wed, 02 Jun 2021 01:25:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw1Xk3ivnQ2s1hesuZz9dgJxyx/v0DNQ4qR29fUNc4ubXtj7yGZBkuRuLkq9LZiCVUZnSZaDw==
X-Received: by 2002:a63:e64b:: with SMTP id p11mr6991352pgj.25.1622622355041;
        Wed, 02 Jun 2021 01:25:55 -0700 (PDT)
Received: from localhost.localdomain (223-136-96-51.emome-ip.hinet.net. [223.136.96.51])
        by smtp.gmail.com with ESMTPSA id t1sm15118388pjo.33.2021.06.02.01.25.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 01:25:54 -0700 (PDT)
From:   Po-Hsu Lin <po-hsu.lin@canonical.com>
To:     kvm@vger.kernel.org
Cc:     drjones@redhat.com, po-hsu.lin@canonical.com, pbonzini@redhat.com,
        thuth@redhat.com
Subject: [kvm-unit-tests PATCH] compiler: use __builtin_add_overflow_p for gcc >= 7.1.0
Date:   Wed,  2 Jun 2021 16:24:43 +0800
Message-Id: <20210602082443.20252-1-po-hsu.lin@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Compilation on Ubuntu Xenial 4.4.0-210-generic i386 with gcc version 5.4.0
20160609 (Ubuntu 5.4.0-6ubuntu1~16.04.12) will fail with:
  lib/linux/compiler.h:37:34: error: implicit declaration of function
    ‘__builtin_add_overflow_p’ [-Werror=implicit-function-declaration]

From the GCC document[1] it looks like this built-in function was only
introduced since 7.1.0

This can be fixed by simply changing the version check from 5.1.0 to 7.1.0

[1] https://gcc.gnu.org/onlinedocs/gcc-7.1.0/gcc/Integer-Overflow-Builtins.html

Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
---
 lib/linux/compiler.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/linux/compiler.h b/lib/linux/compiler.h
index 745792a..5d9552a 100644
--- a/lib/linux/compiler.h
+++ b/lib/linux/compiler.h
@@ -30,7 +30,7 @@
 	__builtin_mul_overflow(a, b, &__d);		\
 })
 #endif
-#elif GCC_VERSION >= 50100
+#elif GCC_VERSION >= 70100
 #define COMPILER_HAS_GENERIC_BUILTIN_OVERFLOW 1
 #define check_add_overflow(a, b) __builtin_add_overflow_p(a, b, (typeof((a) + (b)))0)
 #define check_sub_overflow(a, b) __builtin_add_overflow_p(a, b, (typeof((a) - (b)))0)
-- 
2.25.1

