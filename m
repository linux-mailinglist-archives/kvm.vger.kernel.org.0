Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBC973A1CC0
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 20:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbhFISby (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 14:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbhFISbx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 14:31:53 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14919C061574
        for <kvm@vger.kernel.org>; Wed,  9 Jun 2021 11:29:59 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id ei4so1927878pjb.3
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 11:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xT/xCMfv6X50Ciw0TbJtgKfP8P+TTxjDjtOeU/rPLYE=;
        b=f3S6fGG5vQ/4ROEbXg1YJqkxvuguwSoL0zw839HCMNWsvJmRlSL9jQuHz8A9dI9Lgv
         H/PZXhRHS0ntLqQJG0Ywi9+8szK2N49xK+ziriSs1AQWwMMIoniUPN0MIwOIg8rfA9ta
         HtxIegAn2XPX0/2khpPhMpgzmO2hPl0K9871FDev6Beksig/YVLcal22HDSi7PfGbxQG
         s9ESU08g1jvRBOtUcyxs5q9bDjuTh2s9X25ZzyEi0c73y4xxYb+sVu7QfhH7ic5tWap1
         BueHv1bwO2PX/WKpSfw86F+XXO1Rt1iKywQRwxvCNIAAqaFnXH1LsRouRa5JM8x6nZOO
         JHmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xT/xCMfv6X50Ciw0TbJtgKfP8P+TTxjDjtOeU/rPLYE=;
        b=N9dKSjYyO7MHJlDX4kWBNOdP8StoyW5RdsffXQ3BqZ9sXVBo1CO8uLdaK+Kowzu4Ln
         JsqrDAkUPtR5CxV4LsRSABdvBk5aWcIPksZ9N3G9ALDSeDD5OTzUQwvDdyfLYpu+R/CG
         2Aj7hPwEvhBFIoP3/D0+5GiOoJSCmW5+TovtzKoW7iEmpAqA1yVZsjtJ/w3p14oHe09w
         ypK+2zPP4pYJ4+jsj+2cW+GKZKCMgo+YPyjbNTGFG6epM8P5J6gTuia9UPNpNZbbT0S6
         X0qB4bPRZdbEGkkSOBfz60BCK35RXTokgN6/F0UlYwiFu2xm6Zn7b3l36HWDtoE+0k6a
         CAOA==
X-Gm-Message-State: AOAM531xeF9c/fuseR/veWdm0dpv3YSwAWdbbOOcfSGtvY4kSc0r6/0P
        2pZnR5yTOe4ZGJATNHjzn3FGUwWbRIJ+rg==
X-Google-Smtp-Source: ABdhPJwapdk4B3vty2+2Zy3z/J6so4lHstIHbH/poEJcUW0ydBssJVJlMDgxFhAaCceib5U8w6dHXA==
X-Received: by 2002:a17:90a:de8a:: with SMTP id n10mr912994pjv.76.1623263397689;
        Wed, 09 Jun 2021 11:29:57 -0700 (PDT)
Received: from ubuntu-server-2004.vmware.com (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id y34sm249092pfa.181.2021.06.09.11.29.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 11:29:57 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>
Subject: [kvm-unit-tests PATCH 1/8] lib/x86: report result through serial console when no test device
Date:   Wed,  9 Jun 2021 18:29:38 +0000
Message-Id: <20210609182945.36849-2-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210609182945.36849-1-nadav.amit@gmail.com>
References: <20210609182945.36849-1-nadav.amit@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nadav Amit <nadav.amit@gmail.com>

If there are no test devices, we might be running on bare-metal or other
environment, in which port 0xF4, which reports the test result, is not
monitored. In such environments, print also the result of the test to
the serial console.

For realmode: just give a simple indication whether the test passed or
failed in a similar fashion.

This can allow automation tools to figure out the test is done and its
result.

Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 lib/x86/io.c   | 3 +++
 x86/realmode.c | 5 +++++
 2 files changed, 8 insertions(+)

diff --git a/lib/x86/io.c b/lib/x86/io.c
index f4ffb44..c21dfb8 100644
--- a/lib/x86/io.c
+++ b/lib/x86/io.c
@@ -1,5 +1,6 @@
 #include "libcflat.h"
 #include "smp.h"
+#include "fwcfg.h"
 #include "asm/io.h"
 #include "asm/page.h"
 #include "vmalloc.h"
@@ -99,6 +100,8 @@ void exit(int code)
 #else
         asm volatile("out %0, %1" : : "a"(code), "d"((short)0xf4));
 #endif
+	if (no_test_device)
+		printf("--- DONE: %d ---\n", code);
 
 	/* Fallback */
 	while (1) {
diff --git a/x86/realmode.c b/x86/realmode.c
index c8a6ae0..b4fa603 100644
--- a/x86/realmode.c
+++ b/x86/realmode.c
@@ -125,6 +125,11 @@ static void exit(int code)
 {
 	outb(code, 0xf4);
 
+	if (code == 0)
+		print_serial("--- DONE: 0 ---\n");
+	else
+		print_serial("--- DONE: 1 ---\n");
+
 	while (1) {
 		asm volatile("hlt" ::: "memory");
 	}
-- 
2.25.1

