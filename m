Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63A9545329D
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 14:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236558AbhKPNLN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 08:11:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36039 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236539AbhKPNLD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 16 Nov 2021 08:11:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637068086;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=85tu1V93/v6Qq49LU8YMu/X35SbnS4FMEWQpe6dLFTs=;
        b=QyrAji9iKFEAkVfefTkcMSfqH+I7KhWP+xr5YhRP9DEj2XahgOJJttso+C9PR/WcT5T38C
        QwgR4lQgUgd74BTm9CkmAL3gvOtVqVedc/nE0cUQD1EhA5LtyLCh8aGbaquomgXwplmiye
        mUCL7t0l/lWpZBx8Db4AAXF/KeBJaSM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-604-7y-BmI9QMTC1lCGF7NMKYw-1; Tue, 16 Nov 2021 08:08:02 -0500
X-MC-Unique: 7y-BmI9QMTC1lCGF7NMKYw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 12AB91054F91;
        Tue, 16 Nov 2021 13:08:02 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B3EFA60D30;
        Tue, 16 Nov 2021 13:08:01 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mlevitsk@redhat.com
Subject: [PATCH v2] KVM: MMU: update comment on the number of page role combinations
Date:   Tue, 16 Nov 2021 08:08:01 -0500
Message-Id: <20211116130801.706346-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix the number of bits in the role, and simplify the explanation of
why several bits or combinations of bits are redundant.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/include/asm/kvm_host.h | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e977634333d4..f69b100b23f4 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -291,19 +291,25 @@ struct kvm_kernel_irq_routing_entry;
  * the number of unique SPs that can theoretically be created is 2^n, where n
  * is the number of bits that are used to compute the role.
  *
- * But, even though there are 18 bits in the mask below, not all combinations
- * of modes and flags are possible.  The maximum number of possible upper-level
- * shadow pages for a single gfn is in the neighborhood of 2^13.
+ * But, even though there are 19 bits in the mask below, not all combinations
+ * of modes and flags are possible:
  *
- *   - invalid shadow pages are not accounted.
- *   - level is effectively limited to four combinations, not 16 as the number
- *     bits would imply, as 4k SPs are not tracked (allowed to go unsync).
- *   - level is effectively unused for non-PAE paging because there is exactly
- *     one upper level (see 4k SP exception above).
- *   - quadrant is used only for non-PAE paging and is exclusive with
- *     gpte_is_8_bytes.
- *   - execonly and ad_disabled are used only for nested EPT, which makes it
- *     exclusive with quadrant.
+ *   - invalid shadow pages are not accounted, so the bits are effectively 18
+ *
+ *   - quadrant will only be used if gpte_is_8_bytes=0 (non-PAE paging);
+ *     execonly and ad_disabled are only used for nested EPT which has
+ *     gpte_is_8_bytes=1.  Therefore, 2 bits are always unused.
+ *
+ *   - the 4 bits of level are effectively limited to the values 2/3/4/5,
+ *     as 4k SPs are not tracked (allowed to go unsync).  In addition non-PAE
+ *     paging has exactly one upper level, making level completely redundant
+ *     when gpte_is_8_bytes=0.
+ *
+ *   - on top of this, smep_andnot_wp and smap_andnot_wp are only set if
+ *     cr0_wp=0, therefore these three bits only give rise to 5 possibilities.
+ *
+ * Therefore, the maximum number of possible upper-level shadow pages for a
+ * single gfn is a bit less than 2^13.
  */
 union kvm_mmu_page_role {
 	u32 word;
-- 
2.27.0

