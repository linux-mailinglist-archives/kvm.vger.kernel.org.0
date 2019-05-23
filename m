Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E49D27951
	for <lists+kvm@lfdr.de>; Thu, 23 May 2019 11:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730516AbfEWJeI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 May 2019 05:34:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43564 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730461AbfEWJeH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 May 2019 05:34:07 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C7AFADF26
        for <kvm@vger.kernel.org>; Thu, 23 May 2019 09:34:07 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A12475DC1A;
        Thu, 23 May 2019 09:34:06 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, peterx@redhat.com
Subject: [PATCH] kvm: selftests: aarch64: dirty_log_test: fix unaligned memslot size
Date:   Thu, 23 May 2019 11:34:05 +0200
Message-Id: <20190523093405.17887-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Thu, 23 May 2019 09:34:07 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The memory slot size must be aligned to the host's page size. When
testing a guest with a 4k page size on a host with a 64k page size,
then 3 guest pages are not host page size aligned. Since we just need
a nearly arbitrary number of extra pages to ensure the memslot is not
aligned to a 64 host-page boundary for this test, then we can use
16, as that's 64k aligned, but not 64 * 64k aligned.

Fixes: 76d58e0f07ec ("KVM: fix KVM_CLEAR_DIRTY_LOG for memory slots of unaligned size", 2019-04-17)
Signed-off-by: Andrew Jones <drjones@redhat.com>

---
Note, the commit "KVM: fix KVM_CLEAR_DIRTY_LOG for memory slots of
unaligned size" was somehow committed twice. 76d58e0f07ec is the
first instance.

 tools/testing/selftests/kvm/dirty_log_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index f50a15c38f9b..bf85afbf1b5f 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -292,7 +292,7 @@ static void run_test(enum vm_guest_mode mode, unsigned long iterations,
 	 * A little more than 1G of guest page sized pages.  Cover the
 	 * case where the size is not aligned to 64 pages.
 	 */
-	guest_num_pages = (1ul << (30 - guest_page_shift)) + 3;
+	guest_num_pages = (1ul << (30 - guest_page_shift)) + 16;
 	host_page_size = getpagesize();
 	host_num_pages = (guest_num_pages * guest_page_size) / host_page_size +
 			 !!((guest_num_pages * guest_page_size) % host_page_size);
-- 
2.18.1

