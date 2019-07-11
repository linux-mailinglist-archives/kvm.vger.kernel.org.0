Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1211B654A9
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 12:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728384AbfGKKok (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 06:44:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45026 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728378AbfGKKok (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 06:44:40 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 16827308624A;
        Thu, 11 Jul 2019 10:44:40 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.36.118.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EF32360600;
        Thu, 11 Jul 2019 10:44:37 +0000 (UTC)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>, kvm@vger.kernel.org,
        Thomas Huth <thuth@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wei Yang <richardw.yang@linux.intel.com>
Subject: [PULL 08/19] migratioin/ram.c: reset complete_round when we gets a queued page
Date:   Thu, 11 Jul 2019 12:44:01 +0200
Message-Id: <20190711104412.31233-9-quintela@redhat.com>
In-Reply-To: <20190711104412.31233-1-quintela@redhat.com>
References: <20190711104412.31233-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Thu, 11 Jul 2019 10:44:40 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wei Yang <richardw.yang@linux.intel.com>

In case we gets a queued page, the order of block is interrupted. We may
not rely on the complete_round flag to say we have already searched the
whole blocks on the list.

Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Message-Id: <20190605010828.6969-1-richardw.yang@linux.intel.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 migration/ram.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/migration/ram.c b/migration/ram.c
index 96c84f770a..89eec7ee9d 100644
--- a/migration/ram.c
+++ b/migration/ram.c
@@ -2286,6 +2286,12 @@ static bool get_queued_page(RAMState *rs, PageSearchStatus *pss)
          */
         pss->block = block;
         pss->page = offset >> TARGET_PAGE_BITS;
+
+        /*
+         * This unqueued page would break the "one round" check, even is
+         * really rare.
+         */
+        pss->complete_round = false;
     }
 
     return !!block;
-- 
2.21.0

