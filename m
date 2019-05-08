Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2DFB174D1
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 11:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbfEHJP4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 05:15:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51974 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726455AbfEHJPz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 05:15:55 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B399B3082AF4
        for <kvm@vger.kernel.org>; Wed,  8 May 2019 09:15:55 +0000 (UTC)
Received: from xz-x1.nay.redhat.com (dhcp-15-205.nay.redhat.com [10.66.15.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A4DD55C225;
        Wed,  8 May 2019 09:15:53 +0000 (UTC)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        peterx@redhat.com, "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Subject: [PATCH v2 1/3] KVM: Fix the bitmap range to copy during clear dirty
Date:   Wed,  8 May 2019 17:15:45 +0800
Message-Id: <20190508091547.11963-2-peterx@redhat.com>
In-Reply-To: <20190508091547.11963-1-peterx@redhat.com>
References: <20190508091547.11963-1-peterx@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Wed, 08 May 2019 09:15:55 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

kvm_dirty_bitmap_bytes() will return the size of the dirty bitmap of
the memslot rather than the size of bitmap passed over from the ioctl.
Here for KVM_CLEAR_DIRTY_LOG we should only copy exactly the size of
bitmap that covers kvm_clear_dirty_log.num_pages.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 53de2f946f9e..ad39c57de82d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1251,7 +1251,7 @@ int kvm_clear_dirty_log_protect(struct kvm *kvm,
 	if (!dirty_bitmap)
 		return -ENOENT;
 
-	n = kvm_dirty_bitmap_bytes(memslot);
+	n = ALIGN(log->num_pages, BITS_PER_LONG) / 8;
 
 	if (log->first_page > memslot->npages ||
 	    log->num_pages > memslot->npages - log->first_page ||
-- 
2.17.1

