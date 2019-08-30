Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3237A2C68
	for <lists+kvm@lfdr.de>; Fri, 30 Aug 2019 03:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbfH3Bgv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 21:36:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51930 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727729AbfH3Bgu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 21:36:50 -0400
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2C3ACC05AA52
        for <kvm@vger.kernel.org>; Fri, 30 Aug 2019 01:36:50 +0000 (UTC)
Received: by mail-pf1-f198.google.com with SMTP id r130so4023103pfc.0
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2019 18:36:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wO2GMpLb1bdxi4bwIo0mHdhRTE5FQJFDOzBJpObz9Ms=;
        b=GPF+I+N0kvzwMnHP98Q3Q0NwMGOs7X1lmRFY6buDvA5KCedtNQJ9aUocWZ+rd0db2w
         mLpBRavIfqWPKIcoduVOaYyV1yiLh2rtONSLdqkyk18UC/fknXoQxULAC2HRpqJ5hM33
         Rkwle8ABLFgQ7lYQoD+lVu7BnKSC1JbvE61O3KobKp5oiVFdSno7YpVonCCcz4STrObU
         dlZJSP5hZnuWArKJrQ+J7n6VgBHqn3GZiefLc4E8P0VqX+ItWqsgCEW21MUbY0W+Jrsz
         jg++15TWgiSVRjxUlf6Z2TAXXcpUqvKaJwJVEhaLE4SUx8ofQi3j3d2RsY1jwObmIihY
         4oJA==
X-Gm-Message-State: APjAAAUWap6mLuiTn3Nf8SVIqrHkj7jediU45M7v7oPMgdVpAqJecDv+
        FrTa82ioFxkXriFGr9wCm55QC1uzAgUK+VznXlFfTO23nIbovNYOAXYzzBaALzWv/CYkGGwYf6X
        Oqshyg0UrTEri
X-Received: by 2002:a62:4e05:: with SMTP id c5mr15114399pfb.66.1567129009610;
        Thu, 29 Aug 2019 18:36:49 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxxaqylATIJy8c3slsQVqewhoSYe10uh4TIWa/vhS9CJbzx7epJD9YpbPR2k2cd0sISm1WeEg==
X-Received: by 2002:a62:4e05:: with SMTP id c5mr15114380pfb.66.1567129009365;
        Thu, 29 Aug 2019 18:36:49 -0700 (PDT)
Received: from xz-x1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l3sm3426323pjq.24.2019.08.29.18.36.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 18:36:48 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Andrew Jones <drjones@redhat.com>, peterx@redhat.com
Subject: [PATCH v3 4/4] KVM: selftests: Remove duplicate guest mode handling
Date:   Fri, 30 Aug 2019 09:36:19 +0800
Message-Id: <20190830013619.18867-5-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190830013619.18867-1-peterx@redhat.com>
References: <20190830013619.18867-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove the duplication code in run_test() of dirty_log_test because
after some reordering of functions now we can directly use the outcome
of vm_create().

Meanwhile, with the new VM_MODE_PXXV48_4K, we can safely revert
b442324b58 too where we stick the x86_64 PA width to 39 bits for
dirty_log_test.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c  | 52 ++-----------------
 .../testing/selftests/kvm/include/kvm_util.h  |  4 ++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 17 ++++++
 3 files changed, 26 insertions(+), 47 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index c86f83cb33e5..89fac11733a5 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -234,10 +234,8 @@ static struct kvm_vm *create_vm(enum vm_guest_mode mode, uint32_t vcpuid,
 static void run_test(enum vm_guest_mode mode, unsigned long iterations,
 		     unsigned long interval, uint64_t phys_offset)
 {
-	unsigned int guest_pa_bits, guest_page_shift;
 	pthread_t vcpu_thread;
 	struct kvm_vm *vm;
-	uint64_t max_gfn;
 	unsigned long *bmap;
 
 	/*
@@ -252,60 +250,20 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
 		       2ul << (DIRTY_MEM_BITS - PAGE_SHIFT_4K),
 		       guest_code);
 
-	switch (mode) {
-	case VM_MODE_P52V48_4K:
-	case VM_MODE_PXXV48_4K:
-		guest_pa_bits = 52;
-		guest_page_shift = 12;
-		break;
-	case VM_MODE_P52V48_64K:
-		guest_pa_bits = 52;
-		guest_page_shift = 16;
-		break;
-	case VM_MODE_P48V48_4K:
-		guest_pa_bits = 48;
-		guest_page_shift = 12;
-		break;
-	case VM_MODE_P48V48_64K:
-		guest_pa_bits = 48;
-		guest_page_shift = 16;
-		break;
-	case VM_MODE_P40V48_4K:
-		guest_pa_bits = 40;
-		guest_page_shift = 12;
-		break;
-	case VM_MODE_P40V48_64K:
-		guest_pa_bits = 40;
-		guest_page_shift = 16;
-		break;
-	default:
-		TEST_ASSERT(false, "Unknown guest mode, mode: 0x%x", mode);
-	}
-
-	DEBUG("Testing guest mode: %s\n", vm_guest_mode_string(mode));
-
-#ifdef __x86_64__
-	/*
-	 * FIXME
-	 * The x86_64 kvm selftests framework currently only supports a
-	 * single PML4 which restricts the number of physical address
-	 * bits we can change to 39.
-	 */
-	guest_pa_bits = 39;
-#endif
-	max_gfn = (1ul << (guest_pa_bits - guest_page_shift)) - 1;
-	guest_page_size = (1ul << guest_page_shift);
+	guest_page_size = vm_get_page_size(vm);
 	/*
 	 * A little more than 1G of guest page sized pages.  Cover the
 	 * case where the size is not aligned to 64 pages.
 	 */
-	guest_num_pages = (1ul << (DIRTY_MEM_BITS - guest_page_shift)) + 16;
+	guest_num_pages = (1ul << (DIRTY_MEM_BITS -
+				   vm_get_page_shift(vm))) + 16;
 	host_page_size = getpagesize();
 	host_num_pages = (guest_num_pages * guest_page_size) / host_page_size +
 			 !!((guest_num_pages * guest_page_size) % host_page_size);
 
 	if (!phys_offset) {
-		guest_test_phys_mem = (max_gfn - guest_num_pages) * guest_page_size;
+		guest_test_phys_mem = (vm_get_max_gfn(vm) -
+				       guest_num_pages) * guest_page_size;
 		guest_test_phys_mem &= ~(host_page_size - 1);
 	} else {
 		guest_test_phys_mem = phys_offset;
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 8c71ec886aab..e7ee55853616 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -154,6 +154,10 @@ void vm_vcpu_add_default(struct kvm_vm *vm, uint32_t vcpuid, void *guest_code);
 
 bool vm_is_unrestricted_guest(struct kvm_vm *vm);
 
+unsigned int vm_get_page_size(struct kvm_vm *vm);
+unsigned int vm_get_page_shift(struct kvm_vm *vm);
+unsigned int vm_get_max_gfn(struct kvm_vm *vm);
+
 struct kvm_userspace_memory_region *
 kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
 				 uint64_t end);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index bb8f993b25fb..80a338b5403c 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -136,6 +136,8 @@ struct kvm_vm *_vm_create(enum vm_guest_mode mode, uint64_t phy_pages, int perm)
 {
 	struct kvm_vm *vm;
 
+	DEBUG("Testing guest mode: %s\n", vm_guest_mode_string(mode));
+
 	vm = calloc(1, sizeof(*vm));
 	TEST_ASSERT(vm != NULL, "Insufficient Memory");
 
@@ -1650,3 +1652,18 @@ bool vm_is_unrestricted_guest(struct kvm_vm *vm)
 
 	return val == 'Y';
 }
+
+unsigned int vm_get_page_size(struct kvm_vm *vm)
+{
+	return vm->page_size;
+}
+
+unsigned int vm_get_page_shift(struct kvm_vm *vm)
+{
+	return vm->page_shift;
+}
+
+unsigned int vm_get_max_gfn(struct kvm_vm *vm)
+{
+	return vm->max_gfn;
+}
-- 
2.21.0

