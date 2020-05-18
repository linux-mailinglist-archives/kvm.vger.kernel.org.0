Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19BD81D7D74
	for <lists+kvm@lfdr.de>; Mon, 18 May 2020 17:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728461AbgERPxQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 May 2020 11:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727050AbgERPxN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 May 2020 11:53:13 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6724EC061A0C
        for <kvm@vger.kernel.org>; Mon, 18 May 2020 08:53:13 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id m185so25450wme.3
        for <kvm@vger.kernel.org>; Mon, 18 May 2020 08:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WPXev8+IwguGZ8+5BAOfNLRRppnJCLUsP59v0te4Ye0=;
        b=GBNszTaaBEoLSKErf6Onp2KjlP2lFLTKTV4hGUyCnOMb7cgyVRocIEAPY8J3mCvb8Z
         vCLXgoCH3exBUN+Yjhpatnjh2Fa5e1ewx1l3wOj4/SrE8ApiJzbGKFBw2Fk0/ADaP63I
         bKZiVONe3xodATG6yQv3Mm0gvaazMRU/T7zFjIayETtffjPtUlcgjkmY4YHXL9KjPjUG
         8NwSfTHR05vPqYuItDiHZDYMDcHpYzEeXbnyBK2nu5eOha5ZGzFFsSAJhOruzapfQKPz
         24y236VkwWStBZHxoh2/GZN2xjsFUq8IM0KPfG/DLwlqaj2FIlz5EX4CG6JWCxKql8/O
         rSgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=WPXev8+IwguGZ8+5BAOfNLRRppnJCLUsP59v0te4Ye0=;
        b=Bg/vPV2C128Of0qT69sEReRvrrN+rKmRGMY7Um0HQNjxJ+M14WoGzvyQSF6TwX3kMN
         1Bfdhg5plF7vRUu6j9Gh3SY2VzQw9VAStp8XsyLB9VL71la9Nh3ZWyWkmlrCKS9CgniZ
         I/Ckr90WUjj+xw9v1fRxQG0pT+nJh9YRGlmdIu+77aK6HFH1mae2nCQdqdHG6psqdVy9
         4sdmmSlCyuPrtpIoSojaqE8NVUcl3+In6dXSibzMsNMZoHSffqunlVHBvAL4a73kk1U5
         dYsCX/bDldyd2iAyjNMJuGgvjnuSwuLr7eswPVUv7QZEpDCuNelXex3lTUx/HRusX00W
         hBgA==
X-Gm-Message-State: AOAM531o5S2soUAHfa97pcmc1pOFEN/+Y5Ny1+VJB/XciCx70tjFYUqF
        25JMSu8PuFS2hSYOp2uIXWQ=
X-Google-Smtp-Source: ABdhPJzmaRkrF6Y1/DbPQKadJiZELqBF4agH6qtXZaXxgNHiLJ/vIraP/94NcfVxkbXCvsz/IBZspw==
X-Received: by 2002:a7b:c8d4:: with SMTP id f20mr60869wml.72.1589817192193;
        Mon, 18 May 2020 08:53:12 -0700 (PDT)
Received: from x1w.redhat.com (17.red-88-21-202.staticip.rima-tde.net. [88.21.202.17])
        by smtp.gmail.com with ESMTPSA id 7sm17647462wra.50.2020.05.18.08.53.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2020 08:53:11 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
To:     qemu-devel@nongnu.org
Cc:     Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        qemu-arm@nongnu.org, Richard Henderson <rth@twiddle.net>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: [PATCH v2 2/7] exec: Propagate cpu_memory_rw_debug() error
Date:   Mon, 18 May 2020 17:53:03 +0200
Message-Id: <20200518155308.15851-3-f4bug@amsat.org>
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

Do not ignore the MemTxResult error type returned by
the address_space_rw() API.

Signed-off-by: Philippe Mathieu-Daudé <f4bug@amsat.org>
---
 include/exec/cpu-all.h |  1 +
 exec.c                 | 12 ++++++++----
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/exec/cpu-all.h b/include/exec/cpu-all.h
index d14374bdd4..fb4e8a8e29 100644
--- a/include/exec/cpu-all.h
+++ b/include/exec/cpu-all.h
@@ -413,6 +413,7 @@ void dump_exec_info(void);
 void dump_opcount_info(void);
 #endif /* !CONFIG_USER_ONLY */
 
+/* Returns: 0 on success, -1 on error */
 int cpu_memory_rw_debug(CPUState *cpu, target_ulong addr,
                         void *ptr, target_ulong len, bool is_write);
 
diff --git a/exec.c b/exec.c
index 877b51cc5c..ae5a6944ef 100644
--- a/exec.c
+++ b/exec.c
@@ -3769,6 +3769,7 @@ int cpu_memory_rw_debug(CPUState *cpu, target_ulong addr,
     while (len > 0) {
         int asidx;
         MemTxAttrs attrs;
+        MemTxResult res;
 
         page = addr & TARGET_PAGE_MASK;
         phys_addr = cpu_get_phys_page_attrs_debug(cpu, page, &attrs);
@@ -3781,11 +3782,14 @@ int cpu_memory_rw_debug(CPUState *cpu, target_ulong addr,
             l = len;
         phys_addr += (addr & ~TARGET_PAGE_MASK);
         if (is_write) {
-            address_space_write_rom(cpu->cpu_ases[asidx].as, phys_addr,
-                                    attrs, buf, l);
+            res = address_space_write_rom(cpu->cpu_ases[asidx].as, phys_addr,
+                                          attrs, buf, l);
         } else {
-            address_space_read(cpu->cpu_ases[asidx].as, phys_addr, attrs, buf,
-                               l);
+            res = address_space_read(cpu->cpu_ases[asidx].as, phys_addr,
+                                     attrs, buf, l);
+        }
+        if (res != MEMTX_OK) {
+            return -1;
         }
         len -= l;
         buf += l;
-- 
2.21.3

