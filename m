Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8954245D2AF
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 02:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353091AbhKYCBL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 21:01:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348969AbhKYB7H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 20:59:07 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A0AC061375
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:09 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id x9-20020a056a00188900b0049fd22b9a27so2524737pfh.18
        for <kvm@vger.kernel.org>; Wed, 24 Nov 2021 17:29:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=IT/+WsvAmLQpCEvyPMWpEbRDq8GSRTFK2djNAmh3Cr4=;
        b=N+wT6whTTRKUvyTJm9MijpxNv2Qu3ERzcEXlwqFil8klc+73VWcCatmYB32+E3L3se
         /cgMECTiEn8WXv+omqbaImCSHthBlzDARCm7ECHAkpmmk9RJRT8zmWvmYMB2/aeJWW8L
         mKWEsgAjAUIY6DxjyfHOJTTYMfIWPpKMSPI/GJH1s5kibt95ngNDwR7c3J0h29wTf/uS
         VWIia5ZgaUM6B0H1UhtD1LlAHsPVu6S3XfPbmDTtdOYByJXFaELvQxf8z1AZzXf7HHb0
         uOjgdIpfgytbGvQXy0gpUJJfLjEA2eGdb+oY73RgunbU1SOyYW/+W4DPuDETOYheP9HT
         4Nwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=IT/+WsvAmLQpCEvyPMWpEbRDq8GSRTFK2djNAmh3Cr4=;
        b=VuZozytV4DGXxTVESRr7pT+8ASkjZHY2P5PMWYurr4LD9I7ezRj78T7EfH3kVd5wLT
         PS24LzFM54JtxUoJ72SQ26+y/OOzWm/NEmmLX36Etv1HSFXk8kxIPjCBSjV2HB2bAIBE
         GmyHWXoce8gFPgcHelFUV6EVWlCJLLd61GZcEeE6oD+2NWg36n5bou2lcEVUf+ns4Rj+
         qhnJCgT4sg7qo5uQvIoLnDTY9XZ2YuTuyspbQC4hi2Vi3Uxix5qdhr+0awRlqYiDyiUz
         nqoPQv+Cas9/PYobYsCXDXVXckouTyI7krYG8RjXrMfgp5RZUW+MQCBsrSybx2e3Pt0Q
         eCYg==
X-Gm-Message-State: AOAM530dK6hOvI5gjI8SuiNYB550u5o8lwwWNByMYr1zTZ5bMGph1sWX
        rsRgr9FuTQS19HqJhD5nTsA2m8OHTdo=
X-Google-Smtp-Source: ABdhPJzMMe0ft067zBVhdM4Qv5MU4MG+hl1EYS6zy2vZ24rRt+JAR0N2/vlD8R/cqlJExzrhsNNbaDZKMG8=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:b581:b0:144:e601:de7 with SMTP id
 a1-20020a170902b58100b00144e6010de7mr25238058pls.71.1637803748831; Wed, 24
 Nov 2021 17:29:08 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 25 Nov 2021 01:28:23 +0000
In-Reply-To: <20211125012857.508243-1-seanjc@google.com>
Message-Id: <20211125012857.508243-6-seanjc@google.com>
Mime-Version: 1.0
References: <20211125012857.508243-1-seanjc@google.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
Subject: [kvm-unit-tests PATCH 05/39] x86/access: Refactor so called "page
 table pool" logic
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Track the index instead of raw physical address in the page table pool
to make the "enough room" check a bit less magical.

Opportunistically append "_pa" to pt_pool to clarify that it's the base
physical address of the pool.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/access.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/x86/access.c b/x86/access.c
index 749b50c..47b3d00 100644
--- a/x86/access.c
+++ b/x86/access.c
@@ -159,8 +159,7 @@ static inline void *va(pt_element_t phys)
 }
 
 typedef struct {
-	pt_element_t pt_pool;
-	unsigned pt_pool_size;
+	pt_element_t pt_pool_pa;
 	unsigned pt_pool_current;
 } ac_pool_t;
 
@@ -276,8 +275,7 @@ static void ac_env_int(ac_pool_t *pool)
 	set_idt_entry(14, &page_fault, 0);
 	set_idt_entry(0x20, &kernel_entry, 3);
 
-	pool->pt_pool = AT_PAGING_STRUCTURES_PHYS;
-	pool->pt_pool_size = 120 * 1024 * 1024 - pool->pt_pool;
+	pool->pt_pool_pa = AT_PAGING_STRUCTURES_PHYS;
 	pool->pt_pool_current = 0;
 }
 
@@ -362,15 +360,18 @@ static int ac_test_bump(ac_test_t *at)
 
 static pt_element_t ac_test_alloc_pt(ac_pool_t *pool)
 {
-	pt_element_t ret = pool->pt_pool + pool->pt_pool_current;
-	pool->pt_pool_current += PAGE_SIZE;
-	memset(va(ret), 0, PAGE_SIZE);
-	return ret;
+	pt_element_t pt;
+
+	pt = pool->pt_pool_pa + (pool->pt_pool_current * PAGE_SIZE);
+	pool->pt_pool_current++;
+	memset(va(pt), 0, PAGE_SIZE);
+	return pt;
 }
 
 static _Bool ac_test_enough_room(ac_pool_t *pool)
 {
-	return pool->pt_pool_current + 5 * PAGE_SIZE <= pool->pt_pool_size;
+	/* '120' is completely arbitrary. */
+	return (pool->pt_pool_current + 5) < 120;
 }
 
 static void ac_test_reset_pt_pool(ac_pool_t *pool)
-- 
2.34.0.rc2.393.gf8c9666880-goog

