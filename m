Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7607C7007
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 16:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235734AbjJLOII (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 10:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235176AbjJLOII (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 10:08:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 771EFB8
        for <kvm@vger.kernel.org>; Thu, 12 Oct 2023 07:07:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697119641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=qlCZfTkqNOxM/nWc4shz1NXl1XUnP9vA0JMHEFMp3Tg=;
        b=de35OaPY9jNt/qkwPYDMmNuUFpHcYd4afeqBdxzR0QPBKQvwA3lnxFjzEwOiyauXu3XZ9M
        TIyl2DKf6jZcDmGu82vZQznMtmrY99ALe4MgxVEy3q/fs6qWdgZHQlfbPUnUHDO0rOCP95
        oYdrktYMYRhttMIgck8xieLfbaICx8o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-340-OOkfY9pBPmuKOeVgxWMc5Q-1; Thu, 12 Oct 2023 10:07:17 -0400
X-MC-Unique: OOkfY9pBPmuKOeVgxWMc5Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D37858DBAEF;
        Thu, 12 Oct 2023 14:07:15 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B656E4EA48;
        Thu, 12 Oct 2023 14:07:15 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH gmem FIXUP] selftests/kvm: guestmem: check fstat results on guestmem fd
Date:   Thu, 12 Oct 2023 10:07:15 -0400
Message-Id: <20231012140715.2445237-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Do a basic sanity cheeck for the st_size and st_ino fields of
a guestmem file descriptor.  The test would fail for example
if guestmem.c used the innocuous-sounding function
anon_inode_getfile() instead of the correct one,
anon_inode_getfile_secure().

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 .../testing/selftests/kvm/guest_memfd_test.c  | 26 +++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 75073645aaa1..9805b0f8f26a 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -91,6 +91,31 @@ static void test_fallocate(int fd, size_t page_size, size_t total_size)
 	TEST_ASSERT(!ret, "fallocate to restore punched hole should succeed");
 }
 
+static void test_create_guest_memfd_multiple(struct kvm_vm *vm)
+{
+	int fd1, fd2, ret;
+	struct stat st1, st2;
+
+	fd1 = __vm_create_guest_memfd(vm, 4096, 0);
+	TEST_ASSERT(fd1 != -1, "memfd creation should succeed");
+
+	ret = fstat(fd1, &st1);
+	TEST_ASSERT(ret != -1, "memfd fstat should succeed");
+	TEST_ASSERT(st1.st_size == 4096, "memfd st_size should match requested size");
+
+	fd2 = __vm_create_guest_memfd(vm, 8192, 0);
+	TEST_ASSERT(fd2 != -1, "memfd creation should succeed");
+
+	ret = fstat(fd2, &st2);
+	TEST_ASSERT(ret != -1, "memfd fstat should succeed");
+	TEST_ASSERT(st2.st_size == 8192, "second memfd st_size should match requested size");
+
+	ret = fstat(fd1, &st1);
+	TEST_ASSERT(ret != -1, "memfd fstat should succeed");
+	TEST_ASSERT(st1.st_size == 4096, "first memfd st_size should still match requested size");
+	TEST_ASSERT(st1.st_ino != st2.st_ino, "different memfd should have different inode numbers");
+}
+
 static void test_create_guest_memfd_invalid(struct kvm_vm *vm)
 {
 	uint64_t valid_flags = 0;
@@ -153,6 +178,7 @@ int main(int argc, char *argv[])
 	vm = vm_create_barebones();
 
 	test_create_guest_memfd_invalid(vm);
+	test_create_guest_memfd_multiple(vm);
 
 	fd = vm_create_guest_memfd(vm, total_size, 0);
 
-- 
2.39.1

