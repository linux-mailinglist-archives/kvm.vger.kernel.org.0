Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C598A2C64
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2019 03:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727595AbfH3Bgm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 21:36:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44662 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727562AbfH3Bgm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 21:36:42 -0400
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4F1FA3CA13
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2019 01:36:41 +0000 (UTC)
Received: by mail-pf1-f198.google.com with SMTP id z13so986880pfr.15
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2019 18:36:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cG9laiQiwZAynctMYNHvaREftIm3iI6/rD0VII6FmvI=;
        b=fIT2pAf5hZdA3fA1/HBE5R1DeMccv/iCL8KeP0XlyejpThpGRAN21fH3niH0O7354M
         uHF0NRCXKgRc69c4Kziy3F/uYwYRuyZy2a7agsysZptsICcxwx/YlpBT+tzdOLY+dYSN
         qvB/S5bf5rXpf1wpqQCAvBhWqP3TYGcrmAJauB0SpCdAmQSRfgJL3pbe5i/WGpiO8zFj
         Ib250WIrbVpM3A1aLima8AM0Jz7vsymcim339ITDsbZKUg+ivWWCXDW6t679HrLFHD9U
         dyjvNOh7d9lV8q2jpNumjPqL3qtBu3zRWTGJELBDLtDnS7rpSVtuOayhSfKiv3zh8GEg
         js0A==
X-Gm-Message-State: APjAAAXwzxQpL/nyUC7Ny37TppxMBonfrNN+yonDorZo+28N7fNSTBbH
        oMZ8j/4+CMMk2jLXzg9w+QnEIwnLjHpbip1aGD1lIxiz9TxUIFlC0+zC96oUnyxjsQCvP4NbQUA
        ea45zmaTA+igY
X-Received: by 2002:a17:902:bc4c:: with SMTP id t12mr12769479plz.90.1567129000485;
        Thu, 29 Aug 2019 18:36:40 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwqi0mNP2BvypvBbTDJ2bf0BDP+L7sZO32gPMnpdcs3+HDqx9VFJs3wnzAMp4KWMDyc1kQt3w==
X-Received: by 2002:a17:902:bc4c:: with SMTP id t12mr12769467plz.90.1567129000329;
        Thu, 29 Aug 2019 18:36:40 -0700 (PDT)
Received: from xz-x1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l3sm3426323pjq.24.2019.08.29.18.36.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 18:36:39 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Andrew Jones <drjones@redhat.com>, peterx@redhat.com
Subject: [PATCH v3 2/4] KVM: selftests: Create VM earlier for dirty log test
Date:   Fri, 30 Aug 2019 09:36:17 +0800
Message-Id: <20190830013619.18867-3-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190830013619.18867-1-peterx@redhat.com>
References: <20190830013619.18867-1-peterx@redhat.com>
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

