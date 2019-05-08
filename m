Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 529DA1707B
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 07:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727489AbfEHFoO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 01:44:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42034 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727478AbfEHFoO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 01:44:14 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 15F9C3082B4D
        for <kvm@vger.kernel.org>; Wed,  8 May 2019 05:44:14 +0000 (UTC)
Received: from xz-x1.nay.redhat.com (dhcp-15-205.nay.redhat.com [10.66.15.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F291E60139;
        Wed,  8 May 2019 05:44:11 +0000 (UTC)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        peterx@redhat.com, "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Subject: [PATCH 2/2] kvm: Fix loop of clear dirty with off-by-one
Date:   Wed,  8 May 2019 13:44:03 +0800
Message-Id: <20190508054403.7277-3-peterx@redhat.com>
In-Reply-To: <20190508054403.7277-1-peterx@redhat.com>
References: <20190508054403.7277-1-peterx@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Wed, 08 May 2019 05:44:14 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Just imaging the case where num_pages < BITS_PER_LONG, then the loop
will be skipped while it shouldn't.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 virt/kvm/kvm_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ad39c57de82d..15601a19a87a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1264,8 +1264,8 @@ int kvm_clear_dirty_log_protect(struct kvm *kvm,
 		return -EFAULT;
 
 	spin_lock(&kvm->mmu_lock);
-	for (offset = log->first_page,
-	     i = offset / BITS_PER_LONG, n = log->num_pages / BITS_PER_LONG; n--;
+	for (offset = log->first_page, i = offset / BITS_PER_LONG,
+		 n = (log->num_pages / BITS_PER_LONG + 1); n--;
 	     i++, offset += BITS_PER_LONG) {
 		unsigned long mask = *dirty_bitmap_buffer++;
 		atomic_long_t *p = (atomic_long_t *) &dirty_bitmap[i];
-- 
2.17.1

