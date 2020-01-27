Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2914F14A88A
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2020 18:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbgA0REO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jan 2020 12:04:14 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:52488 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725845AbgA0REO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jan 2020 12:04:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580144653;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=MZLoh5Tjj+Hm+iXUIZGeRq3iuD5be54ScqNixZPGvlE=;
        b=U/7/WaBzq/JYHMNEOwA8oUOO/YEtzxpKe3gJRuUqbRDK8GkID+ipcPuUlnvAyXxnrNFfA7
        hwPtxVQHKP/q+4yoRhR9QzqjjCVNBBBVQHBJ7vmxluOK/81zaT7mwn3RYgYoEFxjwPO+aE
        vPXGQNe/gDepVlc8WuZkcLnLrw0F8uU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-W3tzF6zhOj2dqWmbncTGJg-1; Mon, 27 Jan 2020 12:04:09 -0500
X-MC-Unique: W3tzF6zhOj2dqWmbncTGJg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 62CB218C8C30;
        Mon, 27 Jan 2020 17:04:08 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3EC4710018FF;
        Mon, 27 Jan 2020 17:04:07 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, thuth@redhat.com, bgardon@google.com
Subject: [PATCH] kvm: selftests: Introduce num-pages conversion utilities
Date:   Mon, 27 Jan 2020 18:04:05 +0100
Message-Id: <20200127170405.17503-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Guests and hosts don't have to have the same page size. This means
calculations are necessary when selecting the number of guest pages
to allocate in order to ensure the number is compatible with the
host. Provide utilities to help with those calculations.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c  |  3 +--
 .../testing/selftests/kvm/include/kvm_util.h  |  3 +++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 26 +++++++++++++++++++
 3 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing=
/selftests/kvm/dirty_log_test.c
index 5614222a6628..c2bc4e4c91ec 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -295,8 +295,7 @@ static void run_test(enum vm_guest_mode mode, unsigne=
d long iterations,
 	guest_num_pages =3D (guest_num_pages + 0xff) & ~0xffUL;
 #endif
 	host_page_size =3D getpagesize();
-	host_num_pages =3D (guest_num_pages * guest_page_size) / host_page_size=
 +
-			 !!((guest_num_pages * guest_page_size) % host_page_size);
+	host_num_pages =3D vm_num_host_pages(vm, guest_num_pages);
=20
 	if (!phys_offset) {
 		guest_test_phys_mem =3D (vm_get_max_gfn(vm) -
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testi=
ng/selftests/kvm/include/kvm_util.h
index 29cccaf96baf..0d05ade3022c 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -158,6 +158,9 @@ unsigned int vm_get_page_size(struct kvm_vm *vm);
 unsigned int vm_get_page_shift(struct kvm_vm *vm);
 unsigned int vm_get_max_gfn(struct kvm_vm *vm);
=20
+unsigned int vm_num_host_pages(struct kvm_vm *vm, unsigned int num_guest=
_pages);
+unsigned int vm_num_guest_pages(struct kvm_vm *vm, unsigned int num_host=
_pages);
+
 struct kvm_userspace_memory_region *
 kvm_userspace_memory_region_find(struct kvm_vm *vm, uint64_t start,
 				 uint64_t end);
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/s=
elftests/kvm/lib/kvm_util.c
index 41cf45416060..5af9d7b1b7fc 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -1667,3 +1667,29 @@ unsigned int vm_get_max_gfn(struct kvm_vm *vm)
 {
 	return vm->max_gfn;
 }
+
+static unsigned int vm_calc_num_pages(unsigned int num_pages,
+				      unsigned int page_shift,
+				      unsigned int new_page_shift)
+{
+	unsigned int n =3D 1 << (new_page_shift - page_shift);
+
+	if (page_shift >=3D new_page_shift)
+		return num_pages * (1 << (page_shift - new_page_shift));
+
+	return num_pages / n + !!(num_pages % n);
+}
+
+unsigned int vm_num_host_pages(struct kvm_vm *vm, unsigned int num_guest=
_pages)
+{
+	return vm_calc_num_pages(num_guest_pages,
+				 vm_get_page_shift(vm),
+				 __builtin_ffs(getpagesize()) - 1);
+}
+
+unsigned int vm_num_guest_pages(struct kvm_vm *vm, unsigned int num_host=
_pages)
+{
+	return vm_calc_num_pages(num_host_pages,
+				 __builtin_ffs(getpagesize()) - 1,
+				 vm_get_page_shift(vm));
+}
--=20
2.21.1

