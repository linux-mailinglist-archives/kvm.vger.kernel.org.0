Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ED113746CC
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 19:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237502AbhEER2J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 13:28:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41866 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235915AbhEERCY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 May 2021 13:02:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620234084;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7g2k8F+O24ILX6i9wlywTWqxuX2ak4LnZOnLn8IJqNY=;
        b=I0Acs7JkAFBGnjbE8cg/Ed4v4TpGNX+hKW6gXg9rfrvLDEC5VUREMhdQjZ11yJ1YkugWBi
        PNs0IC4b/N6wY7U30ZRX7LqayFAnVQQUiNY6rxqw9Dg3UQVnedQp1IXEzV0VwIVEeeTGVY
        FhdC/d24D/bVmKtiwbVOhFWn6hH8/HU=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-437-CCqmUhZyN6m7PTGLXZo43A-1; Wed, 05 May 2021 13:01:22 -0400
X-MC-Unique: CCqmUhZyN6m7PTGLXZo43A-1
Received: by mail-wr1-f71.google.com with SMTP id 65-20020adf82c70000b0290107593a42c3so953910wrc.5
        for <kvm@vger.kernel.org>; Wed, 05 May 2021 10:01:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7g2k8F+O24ILX6i9wlywTWqxuX2ak4LnZOnLn8IJqNY=;
        b=ojetDUjuou6o9lx60fC+/CQrZmtqRndNolXN6C8fy+i71/p1UYESYX7otilo1UIB4k
         OBeWMyr7J2aFojfeBl85IOTHZFRccaSUsJxb9ulDiNkiKL9tHA4zeclv5CAMJh6PmEZ4
         bBocrHGsXwQo6AfvllJSVeRIMyv8u1YuTEjbYRjkSBvH8YInuMY0aAF2xWvRHZL2wjlq
         kIHe/YjZXErGM403ZebXqb0eaT42umKrutVtCMiPDjDDrREwwFUUK/YK1/RGX++QYFkI
         e7t4yqabFnEDTiLfS7IR1oSMofI4vlnR6pDDiww/4WfNG4PnPTo2ZUJdlJ0HtY0ns1Gn
         aiDQ==
X-Gm-Message-State: AOAM530qDDdY6nj1DEZs7kTwJ3+HgpMmrFe0R2bqr7mxV70d1qwziwKS
        2Gb9ziPh3up6kXRsXW34wy7A3ihmsqiWRcSF8FERDEex0lztPvfFkK1/IlK2RPEyPJulmHZiEZR
        ch2n/u96cZ2bX
X-Received: by 2002:a1c:1d50:: with SMTP id d77mr11295070wmd.114.1620234081690;
        Wed, 05 May 2021 10:01:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzmgH4JwP3i9dHZjwwiWSGdQcazy8feE/fCrd6Xa/tz3JD28tBwB4MYsNyH0CmUS+lyRxh2hg==
X-Received: by 2002:a1c:1d50:: with SMTP id d77mr11295057wmd.114.1620234081584;
        Wed, 05 May 2021 10:01:21 -0700 (PDT)
Received: from x1w.redhat.com (astrasbourg-653-1-188-220.w90-13.abo.wanadoo.fr. [90.13.127.220])
        by smtp.gmail.com with ESMTPSA id q10sm15824317wre.92.2021.05.05.10.01.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 10:01:21 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Warner Losh <imp@bsdimp.com>, Kyle Evans <kevans@freebsd.org>,
        Greg Kurz <groug@kaod.org>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        qemu-ppc@nongnu.org (open list:PowerPC TCG CPUs),
        kvm@vger.kernel.org (open list:Overall KVM CPUs)
Subject: [PATCH 5/5] target/ppc/kvm: Replace alloca() by g_malloc()
Date:   Wed,  5 May 2021 19:00:55 +0200
Message-Id: <20210505170055.1415360-6-philmd@redhat.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210505170055.1415360-1-philmd@redhat.com>
References: <20210505170055.1415360-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The ALLOCA(3) man-page mentions its "use is discouraged".

Replace it by a g_malloc() call.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/ppc/kvm.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/target/ppc/kvm.c b/target/ppc/kvm.c
index 104a308abb5..ae62daddf7d 100644
--- a/target/ppc/kvm.c
+++ b/target/ppc/kvm.c
@@ -2698,11 +2698,11 @@ int kvmppc_save_htab(QEMUFile *f, int fd, size_t bufsize, int64_t max_ns)
 int kvmppc_load_htab_chunk(QEMUFile *f, int fd, uint32_t index,
                            uint16_t n_valid, uint16_t n_invalid, Error **errp)
 {
-    struct kvm_get_htab_header *buf;
-    size_t chunksize = sizeof(*buf) + n_valid * HASH_PTE_SIZE_64;
+    size_t chunksize = sizeof(struct kvm_get_htab_header)
+                       + n_valid * HASH_PTE_SIZE_64;
     ssize_t rc;
+    g_autofree struct kvm_get_htab_header *buf = g_malloc(chunksize);
 
-    buf = alloca(chunksize);
     buf->index = index;
     buf->n_valid = n_valid;
     buf->n_invalid = n_invalid;
@@ -2741,10 +2741,10 @@ void kvmppc_read_hptes(ppc_hash_pte64_t *hptes, hwaddr ptex, int n)
     i = 0;
     while (i < n) {
         struct kvm_get_htab_header *hdr;
+        char buf[sizeof(*hdr) + HPTES_PER_GROUP * HASH_PTE_SIZE_64];
         int m = n < HPTES_PER_GROUP ? n : HPTES_PER_GROUP;
-        char buf[sizeof(*hdr) + m * HASH_PTE_SIZE_64];
 
-        rc = read(fd, buf, sizeof(buf));
+        rc = read(fd, buf, sizeof(*hdr) + m * HASH_PTE_SIZE_64);
         if (rc < 0) {
             hw_error("kvmppc_read_hptes: Unable to read HPTEs");
         }
-- 
2.26.3

