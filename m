Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55B55A0F6E
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 04:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbfH2CVj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 22:21:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40328 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727188AbfH2CVj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 22:21:39 -0400
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CCD6B155E0
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2019 02:21:38 +0000 (UTC)
Received: by mail-pg1-f200.google.com with SMTP id b18so1086940pgg.8
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2019 19:21:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cG9laiQiwZAynctMYNHvaREftIm3iI6/rD0VII6FmvI=;
        b=qm5tfNp/d/B+1FJW7LkZA1Ze/+RD5pxg8hs97jlC5ieVG/i1juRphO7KauXUGvLNKS
         iQmavjjWCGO8jod8su+tNzX8OxQgYb7/p68916/dgVtzw0EZuuAsxYyro8gjmofj1+Pf
         nqFi+ZBLZ2akDLeZjpQpHDW0sYzrc95T9J06vGXLD7EsouE0akxZ3RvuqlDwy/TvUyOu
         D8P0RWBXog3yfF6PvNVyjKda3+RCElxzPb46TkcGqHWZEssjMvAh0eoFB1qg/inSuI9y
         OrSm6F8DM9lv0jzp7nri0M+n9lomQbKuSA9ApIRJ4jrvnG5R8RgezzNhuXI+eON59J0l
         5fNw==
X-Gm-Message-State: APjAAAUUyzOV9oFfiR1YGriQ5KsLZJJZBGOsKplfyeYpMZihBEHh3wx8
        Ex0PTyDv31JBF9IiYlsG5vyw4QgYNoYVaAuIWZvf3tdJQeROVx7aBMa1JUIFKgpwcEEy2HSoTIU
        OJP1aImIv4I4s
X-Received: by 2002:a65:6454:: with SMTP id s20mr6104233pgv.15.1567045298287;
        Wed, 28 Aug 2019 19:21:38 -0700 (PDT)
X-Google-Smtp-Source: APXvYqx/fwX5Wj8RbB303J6h4GpFkNemwBAOcjXKDMYBOeww1k/Tq5GnIbmk9x6Du/3iQlQaMsKr7Q==
X-Received: by 2002:a65:6454:: with SMTP id s20mr6104223pgv.15.1567045298037;
        Wed, 28 Aug 2019 19:21:38 -0700 (PDT)
Received: from xz-x1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j187sm750140pfg.178.2019.08.28.19.21.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 19:21:37 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Andrew Jones <drjones@redhat.com>, peterx@redhat.com
Subject: [PATCH v2 2/4] KVM: selftests: Create VM earlier for dirty log test
Date:   Thu, 29 Aug 2019 10:21:15 +0800
Message-Id: <20190829022117.10191-3-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190829022117.10191-1-peterx@redhat.com>
References: <20190829022117.10191-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since we've just removed the dependency of vm type in previous patch,
now we can create the vm much earlier.  Note that to move it earlier
we used an approximation of number of extra pages but it should be
fine.

This prepares for the follow up patches to finally remove the
duplication of guest mode parsings.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 135cba5c6d0d..efb7746a7e99 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -230,6 +230,9 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mode, uint32_t vcpuid,
 	return vm;
 }
 
+#define DIRTY_MEM_BITS 30 /* 1G */
+#define PAGE_SHIFT_4K  12
+
 static void run_test(enum vm_guest_mode mode, unsigned long iterations,
 		     unsigned long interval, uint64_t phys_offset)
 {
@@ -239,6 +242,18 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
 	uint64_t max_gfn;
 	unsigned long *bmap;
 
+	/*
+	 * We reserve page table for 2 times of extra dirty mem which
+	 * will definitely cover the original (1G+) test range.  Here
+	 * we do the calculation with 4K page size which is the
+	 * smallest so the page number will be enough for all archs
+	 * (e.g., 64K page size guest will need even less memory for
+	 * page tables).
+	 */
+	vm = create_vm(mode, VCPU_ID,
+		       2ul << (DIRTY_MEM_BITS - PAGE_SHIFT_4K),
+		       guest_code);
+
 	switch (mode) {
 	case VM_MODE_P52V48_4K:
 		guest_pa_bits = 52;
@@ -285,7 +300,7 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
 	 * A little more than 1G of guest page sized pages.  Cover the
 	 * case where the size is not aligned to 64 pages.
 	 */
-	guest_num_pages = (1ul << (30 - guest_page_shift)) + 16;
+	guest_num_pages = (1ul << (DIRTY_MEM_BITS - guest_page_shift)) + 16;
 	host_page_size = getpagesize();
 	host_num_pages = (guest_num_pages * guest_page_size) / host_page_size +
 			 !!((guest_num_pages * guest_page_size) % host_page_size);
@@ -302,8 +317,6 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
 	bmap = bitmap_alloc(host_num_pages);
 	host_bmap_track = bitmap_alloc(host_num_pages);
 
-	vm = create_vm(mode, VCPU_ID, guest_num_pages, guest_code);
-
 #ifdef USE_CLEAR_DIRTY_LOG
 	struct kvm_enable_cap cap = {};
 
-- 
2.21.0

