Return-Path: <kvm+bounces-2201-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84F4B7F345C
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 17:59:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 40AF7282FBF
	for <lists+kvm@lfdr.de>; Tue, 21 Nov 2023 16:59:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C0EA56749;
	Tue, 21 Nov 2023 16:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZCOERRXz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2169A113
	for <kvm@vger.kernel.org>; Tue, 21 Nov 2023 08:59:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700585959;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=te+7SJJrn2ZP2JBi0ktcZa5AVQEsIzQSk/RVCYrsUho=;
	b=ZCOERRXzdVYCKnJwnfFjJ48by1aMIQMBoTOQxB96IeddeQShwcSxnKWd/j+eUwE5qGMZT5
	vs6Zz3WP23W4TGTXEXDXY5ryjkVsbTdx7Tc9rt2JwCJniEMyfh7JXTeBZitTwf5ycv29nr
	gVKT/a50gJuo4Nuh/KHCRqbQkLUOiIg=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-411-GeD7BnVpNNiKB6tUoXHLsA-1; Tue,
 21 Nov 2023 11:59:16 -0500
X-MC-Unique: GeD7BnVpNNiKB6tUoXHLsA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4E1051C07597;
	Tue, 21 Nov 2023 16:59:16 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 31BB61C060AE;
	Tue, 21 Nov 2023 16:59:16 +0000 (UTC)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: broonie@kernel.org
Subject: [PATCH] selftests/kvm: fix compilation on non-x86_64 platforms
Date: Tue, 21 Nov 2023 11:59:15 -0500
Message-Id: <20231121165915.1170987-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

MEM_REGION_SLOT and MEM_REGION_GPA are not really needed in
test_invalid_memory_region_flags; the VM never runs and there are no
other slots, so it is okay to use slot 0 and place it at address
zero.  This fixes compilation on architectures that do not
define them.

Fixes: 5d74316466f4 ("KVM: selftests: Add a memory region subtest to validate invalid flags", 2023-11-14)
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 tools/testing/selftests/kvm/set_memory_region_test.c | 12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index 1efee1cfcff0..6637a0845acf 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -349,8 +349,8 @@ static void test_invalid_memory_region_flags(void)
 		if ((supported_flags & BIT(i)) && !(v2_only_flags & BIT(i)))
 			continue;
 
-		r = __vm_set_user_memory_region(vm, MEM_REGION_SLOT, BIT(i),
-						MEM_REGION_GPA, MEM_REGION_SIZE, NULL);
+		r = __vm_set_user_memory_region(vm, 0, BIT(i),
+						0, MEM_REGION_SIZE, NULL);
 
 		TEST_ASSERT(r && errno == EINVAL,
 			    "KVM_SET_USER_MEMORY_REGION should have failed on v2 only flag 0x%lx", BIT(i));
@@ -358,16 +358,16 @@ static void test_invalid_memory_region_flags(void)
 		if (supported_flags & BIT(i))
 			continue;
 
-		r = __vm_set_user_memory_region2(vm, MEM_REGION_SLOT, BIT(i),
-						 MEM_REGION_GPA, MEM_REGION_SIZE, NULL, 0, 0);
+		r = __vm_set_user_memory_region2(vm, 0, BIT(i),
+						 0, MEM_REGION_SIZE, NULL, 0, 0);
 		TEST_ASSERT(r && errno == EINVAL,
 			    "KVM_SET_USER_MEMORY_REGION2 should have failed on unsupported flag 0x%lx", BIT(i));
 	}
 
 	if (supported_flags & KVM_MEM_GUEST_MEMFD) {
-		r = __vm_set_user_memory_region2(vm, MEM_REGION_SLOT,
+		r = __vm_set_user_memory_region2(vm, 0,
 						 KVM_MEM_LOG_DIRTY_PAGES | KVM_MEM_GUEST_MEMFD,
-						 MEM_REGION_GPA, MEM_REGION_SIZE, NULL, 0, 0);
+						 0, MEM_REGION_SIZE, NULL, 0, 0);
 		TEST_ASSERT(r && errno == EINVAL,
 			    "KVM_SET_USER_MEMORY_REGION2 should have failed, dirty logging private memory is unsupported");
 	}
-- 
2.39.1


