Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAA9E182DF1
	for <lists+kvm@lfdr.de>; Thu, 12 Mar 2020 11:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbgCLKlC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 06:41:02 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:42365 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725978AbgCLKlC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 12 Mar 2020 06:41:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584009661;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=r8/qYhcSrLmwzPMBf5VzmySM+Tb4H39EZs2TEBVhZP0=;
        b=gj7yo/sOKPfrK6jHhUbZxhoars0R8kw0DXD2QvwsG+QO6BHZWBo6zjeU25zbqNcv3JtTFz
        0M04aBD8qBFE79RG0HcFIRV8uH+DKjXVBQ6VEkgf3mvIrebL5VUUs9eSUbe+6BwYVs4GUs
        u9HalvQ1Wll1JoN+zx4tokjS8Ftu+QA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-448-CAjlSswtP_mugpyx_iXXjg-1; Thu, 12 Mar 2020 06:40:59 -0400
X-MC-Unique: CAjlSswtP_mugpyx_iXXjg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 839E8801E77;
        Thu, 12 Mar 2020 10:40:58 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D46245C545;
        Thu, 12 Mar 2020 10:40:56 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, borntraeger@de.ibm.com, frankja@linux.ibm.com,
        david@redhat.com, cohuck@redhat.com, thuth@redhat.com
Subject: [PATCH] KVM: selftests: s390x: Provide additional num-guest-pages adjustment
Date:   Thu, 12 Mar 2020 11:40:55 +0100
Message-Id: <20200312104055.8558-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

s390 requires 1M aligned guest sizes. Embedding the rounding in
vm_adjust_num_guest_pages() allows us to remove it from a few
other places.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/selftests/kvm/demand_paging_test.c | 4 ----
 tools/testing/selftests/kvm/dirty_log_test.c     | 5 +----
 tools/testing/selftests/kvm/include/kvm_util.h   | 8 +++++++-
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/demand_paging_test.c b/tools/tes=
ting/selftests/kvm/demand_paging_test.c
index c1e326d3ed7f..ae086c5dc118 100644
--- a/tools/testing/selftests/kvm/demand_paging_test.c
+++ b/tools/testing/selftests/kvm/demand_paging_test.c
@@ -378,10 +378,6 @@ static void run_test(enum vm_guest_mode mode, bool u=
se_uffd,
 	guest_num_pages =3D (vcpus * vcpu_memory_bytes) / guest_page_size;
 	guest_num_pages =3D vm_adjust_num_guest_pages(mode, guest_num_pages);
=20
-#ifdef __s390x__
-	/* Round up to multiple of 1M (segment size) */
-	guest_num_pages =3D (guest_num_pages + 0xff) & ~0xffUL;
-#endif
 	/*
 	 * If there should be more memory in the guest test region than there
 	 * can be pages in the guest, it will definitely cause problems.
diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing=
/selftests/kvm/dirty_log_test.c
index 518a94a7a8b5..8a79f5d6b979 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -296,10 +296,7 @@ static void run_test(enum vm_guest_mode mode, unsign=
ed long iterations,
 	guest_num_pages =3D (1ul << (DIRTY_MEM_BITS -
 				   vm_get_page_shift(vm))) + 3;
 	guest_num_pages =3D vm_adjust_num_guest_pages(mode, guest_num_pages);
-#ifdef __s390x__
-	/* Round up to multiple of 1M (segment size) */
-	guest_num_pages =3D (guest_num_pages + 0xff) & ~0xffUL;
-#endif
+
 	host_page_size =3D getpagesize();
 	host_num_pages =3D vm_num_host_pages(mode, guest_num_pages);
=20
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testi=
ng/selftests/kvm/include/kvm_util.h
index 707b44805149..ade5a40afbee 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -164,7 +164,13 @@ unsigned int vm_num_guest_pages(enum vm_guest_mode m=
ode, unsigned int num_host_p
 static inline unsigned int
 vm_adjust_num_guest_pages(enum vm_guest_mode mode, unsigned int num_gues=
t_pages)
 {
-	return vm_num_guest_pages(mode, vm_num_host_pages(mode, num_guest_pages=
));
+	unsigned int n;
+	n =3D vm_num_guest_pages(mode, vm_num_host_pages(mode, num_guest_pages)=
);
+#ifdef __s390x__
+	/* s390 requires 1M aligned guest sizes */
+	n =3D (n + 255) & ~255;
+#endif
+	return n;
 }
=20
 struct kvm_userspace_memory_region *
--=20
2.21.1

