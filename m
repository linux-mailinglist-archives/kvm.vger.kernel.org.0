Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 311EA474648
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 16:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235261AbhLNPSu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 10:18:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:27472 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235366AbhLNPSq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Dec 2021 10:18:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639495126;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=S9AF7OnmRk+OCSDWZ+0WFjDmpnGnCkenqOvglMBXsmE=;
        b=O0N/2ER5EQwwCEJgl/x3WdbpqQRI1ZHbDv6cfHZT63bn78EU0A+mLOUPqS0PHyQaiGPYm5
        ZgVQiN1+Jf11eR0rFPG4v5Z6Y3MerZSVlv+crBqd7o6LPY0WtSzMfFcQlKh1huxz7MQnsr
        b7agOGW+BFhycBJZQ7z5mgx+Ai7pn1g=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-549-8r1apI2ANy-9dG6U3QgixA-1; Tue, 14 Dec 2021 10:18:44 -0500
X-MC-Unique: 8r1apI2ANy-9dG6U3QgixA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 05631801B0C
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 15:18:44 +0000 (UTC)
Received: from gator.home (unknown [10.40.192.130])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1B8AE1042AAC;
        Tue, 14 Dec 2021 15:18:42 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com
Subject: [PATCH] selftests: KVM: Fix non-x86 compiling
Date:   Tue, 14 Dec 2021 16:18:42 +0100
Message-Id: <20211214151842.848314-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Attempting to compile on a non-x86 architecture fails with

include/kvm_util.h: In function ‘vm_compute_max_gfn’:
include/kvm_util.h:79:21: error: dereferencing pointer to incomplete type ‘struct kvm_vm’
  return ((1ULL << vm->pa_bits) >> vm->page_shift) - 1;
                     ^~

This is because the declaration of struct kvm_vm is in
lib/kvm_util_internal.h as an effort to make it private to
the test lib code. We can still provide arch specific functions,
though, by making the generic function symbols weak. Do that to
fix the compile error.

Fixes: c8cc43c1eae2 ("selftests: KVM: avoid failures due to reserved HyperTransport region")
Cc: stable@vger.kernel.org
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/include/kvm_util.h | 10 +---------
 tools/testing/selftests/kvm/lib/kvm_util.c     |  5 +++++
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index da2b702da71a..2d62edc49d67 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -71,15 +71,6 @@ enum vm_guest_mode {
 
 #endif
 
-#if defined(__x86_64__)
-unsigned long vm_compute_max_gfn(struct kvm_vm *vm);
-#else
-static inline unsigned long vm_compute_max_gfn(struct kvm_vm *vm)
-{
-	return ((1ULL << vm->pa_bits) >> vm->page_shift) - 1;
-}
-#endif
-
 #define MIN_PAGE_SIZE		(1U << MIN_PAGE_SHIFT)
 #define PTES_PER_MIN_PAGE	ptes_per_page(MIN_PAGE_SIZE)
 
@@ -330,6 +321,7 @@ bool vm_is_unrestricted_guest(struct kvm_vm *vm);
 
 unsigned int vm_get_page_size(struct kvm_vm *vm);
 unsigned int vm_get_page_shift(struct kvm_vm *vm);
+unsigned long vm_compute_max_gfn(struct kvm_vm *vm);
 uint64_t vm_get_max_gfn(struct kvm_vm *vm);
 int vm_get_fd(struct kvm_vm *vm);
 
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index daf6fdb217a7..53d2b5d04b82 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2328,6 +2328,11 @@ unsigned int vm_get_page_shift(struct kvm_vm *vm)
 	return vm->page_shift;
 }
 
+unsigned long __attribute__((weak)) vm_compute_max_gfn(struct kvm_vm *vm)
+{
+	return ((1ULL << vm->pa_bits) >> vm->page_shift) - 1;
+}
+
 uint64_t vm_get_max_gfn(struct kvm_vm *vm)
 {
 	return vm->max_gfn;
-- 
2.31.1

