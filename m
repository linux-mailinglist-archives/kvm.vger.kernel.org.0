Return-Path: <kvm+bounces-3896-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A5491809A85
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 04:35:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 376B42814EB
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 03:35:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32C3F46B4;
	Fri,  8 Dec 2023 03:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RLU0IP24"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F8751712
	for <kvm@vger.kernel.org>; Thu,  7 Dec 2023 19:35:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702006524;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=vh3S+Lns+sOh+ZFwSTFTZocc8C/FbBJ0BQFWEGhlNzI=;
	b=RLU0IP24r/9dSwfV6/YhFSEBXzx25jTQftuuUlkUl5DN6Tg+v+g2wjhGytVp78DZoF4xz+
	rC58IbPL+O/EWmhWJvtowxfKqiFYa6EabvHYU6iRpUsrlnenazb+kzr7maHZOgUTNc74Dv
	un0acSvzn8SJyfVcnv6zJVEeNb+n6Z8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-168-QbWSTXDmMXmiBdhqKILqdw-1; Thu,
 07 Dec 2023 22:35:21 -0500
X-MC-Unique: QbWSTXDmMXmiBdhqKILqdw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E778A1C04322;
	Fri,  8 Dec 2023 03:35:20 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (virt-mtcollins-01.lab.eng.rdu2.redhat.com [10.8.1.196])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D8143492BC6;
	Fri,  8 Dec 2023 03:35:20 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: kvm@vger.kernel.org
Cc: Shaoqin Huang <shahuang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1] KVM: selftests: Fix Assertion on non-x86_64 platforms
Date: Thu,  7 Dec 2023 22:35:05 -0500
Message-Id: <20231208033505.2930064-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

When running the set_memory_region_test on arm64 platform, it causes the
below assert:

==== Test Assertion Failure ====
  set_memory_region_test.c:355: r && errno == EINVAL
  pid=40695 tid=40695 errno=0 - Success
     1	0x0000000000401baf: test_invalid_memory_region_flags at set_memory_region_test.c:355
     2	 (inlined by) main at set_memory_region_test.c:541
     3	0x0000ffff951c879b: ?? ??:0
     4	0x0000ffff951c886b: ?? ??:0
     5	0x0000000000401caf: _start at ??:?
  KVM_SET_USER_MEMORY_REGION should have failed on v2 only flag 0x2

This is because the arm64 platform also support the KVM_MEM_READONLY flag, but
the current implementation add it into the supportd_flags only on x86_64
platform, so this causes assert on other platform which also support the
KVM_MEM_READONLY flag.

Fix it by using the __KVM_HAVE_READONLY_MEM macro to detect if the
current platform support the KVM_MEM_READONLY, thus fix this problem on
all other platform which support KVM_MEM_READONLY.

Fixes: 5d74316466f4 ("KVM: selftests: Add a memory region subtest to validate invalid flags")
Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
---
This patch is based on the latest kvm-next[1] branch.

[1] https://git.kernel.org/pub/scm/virt/kvm/kvm.git/log/?h=next
---
 tools/testing/selftests/kvm/set_memory_region_test.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/testing/selftests/kvm/set_memory_region_test.c
index 6637a0845acf..1ce710fd7a5a 100644
--- a/tools/testing/selftests/kvm/set_memory_region_test.c
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c
@@ -333,9 +333,11 @@ static void test_invalid_memory_region_flags(void)
 	struct kvm_vm *vm;
 	int r, i;
 
-#ifdef __x86_64__
+#ifdef __KVM_HAVE_READONLY_MEM
 	supported_flags |= KVM_MEM_READONLY;
+#endif
 
+#ifdef __x86_64__
 	if (kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM))
 		vm = vm_create_barebones_protected_vm();
 	else
-- 
2.40.1


