Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FED858A27
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 20:46:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbfF0SqM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jun 2019 14:46:12 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40438 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbfF0SqM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jun 2019 14:46:12 -0400
Received: by mail-pg1-f194.google.com with SMTP id w10so1416532pgj.7
        for <kvm@vger.kernel.org>; Thu, 27 Jun 2019 11:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=b9WcdNAe93dgqdjuKIeOt+ko1Bg0iziPDcAFVrdFnSQ=;
        b=BFSZgXtWuw0zcAfXSQlD6E080SBXS3ekp1rhJt8nKr/Qq1LG2QFXmi6kHgLPa6UUwt
         tTlgZFnS3vHD4CWZdM9Qf5abjEveA8PpZw9W939g9zwCWCnfrsf3TMw93IOzYIcFVXwW
         0aoaif5HZ4FlToJIZAd2DfT7QpNr8KSHDOGQoj1N3jEjdpxRiChX45C1DRgFTN6WW10E
         8vyU/BOZX/PG+FGiZaBfVbnfB0/5hMf51du3Tj4rqxuwcJNlre5L8/nvJNFVJJG16S0a
         PGFYwCSgkebyr4NZJGAxNqganF40Ol03J2XCi8k5vjUbu+YE6bKsTPsJX4kQC2D0xznl
         XF3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=b9WcdNAe93dgqdjuKIeOt+ko1Bg0iziPDcAFVrdFnSQ=;
        b=iH8qtq1buhCQBGPU8ypnc3s7O0D74y9T+F0iaajW60Ly92G5ql9eUyYQc4WOP0LDuk
         ZUm4LcFHXqYn9prDkGz+DmsLx23YcAJzS6kV1cZL2Dtncs7xS5IVIyh4PlvgLPzp9w6G
         jZ1AAEW1r2hRoeBaAy04i9CFssR0bNQtaPUz8ugq9isfWz3h1HZRAK0H43oo+4dhWjWQ
         qfCZg5+EeBZQH+fg1qqOwLNEvsHwaZaAX1zY9hruFEZlYJt1A9/B9R6RL6yPVPmcqzai
         sKG65WynGMQWIUkTQ2j72lhNoMKFAIagmxKdRpZUObh4BXhEZFRhJTB4lptFT5sh3qXF
         stOQ==
X-Gm-Message-State: APjAAAWUmldLgwV5m79FMT3LgjX6BpCpT+MgxVElj8v2z+l+JvseEzkl
        nQDDy3VpHpthyAlqEjiYAxLToDNRm0o=
X-Google-Smtp-Source: APXvYqzKeTutXnioAbenMcbn+ji3hNnUDLZ7SswmJ04xcIod6MRBAh+BxxNs3dJRt4hqBsPq63dp4Q==
X-Received: by 2002:a63:460c:: with SMTP id t12mr2175301pga.69.1561661171143;
        Thu, 27 Jun 2019 11:46:11 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id cx22sm6212515pjb.25.2019.06.27.11.46.10
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 11:46:10 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>
Subject: [kvm-unit-tests PATCH] x86: Load segments after GDT loading
Date:   Thu, 27 Jun 2019 04:23:34 -0700
Message-Id: <20190627112334.3293-1-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Whenever we load the GDT, we need to reload the segment selectors so
their hidden data (base, limit, type, etc.) would be reloaded.

It appears that loading GS overwrites the GS bases, so reload GS base
after loading the segment to prevent per-cpu variable corruption.

Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
---
 x86/cstart64.S | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/x86/cstart64.S b/x86/cstart64.S
index c5561e7..9791282 100644
--- a/x86/cstart64.S
+++ b/x86/cstart64.S
@@ -118,6 +118,21 @@ MSR_GS_BASE = 0xc0000101
 	wrmsr
 .endm
 
+.macro setup_segments
+	mov $MSR_GS_BASE, %ecx
+	rdmsr
+
+	mov $0x10, %bx
+	mov %bx, %ds
+	mov %bx, %es
+	mov %bx, %fs
+	mov %bx, %gs
+	mov %bx, %ss
+
+	/* restore MSR_GS_BASE */
+	wrmsr
+.endm
+
 .globl start
 start:
 	mov %ebx, mb_boot_info
@@ -149,6 +164,7 @@ switch_to_5level:
 
 prepare_64:
 	lgdt gdt64_desc
+	setup_segments
 
 enter_long_mode:
 	mov %cr4, %eax
@@ -196,12 +212,7 @@ sipi_end:
 
 .code32
 ap_start32:
-	mov $0x10, %ax
-	mov %ax, %ds
-	mov %ax, %es
-	mov %ax, %fs
-	mov %ax, %gs
-	mov %ax, %ss
+	setup_segments
 	mov $-4096, %esp
 	lock/xaddl %esp, smp_stacktop
 	setup_percpu_area
-- 
2.17.1

