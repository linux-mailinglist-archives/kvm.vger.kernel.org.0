Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB51352A83
	for <lists+kvm@lfdr.de>; Fri,  2 Apr 2021 14:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235348AbhDBMRK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Apr 2021 08:17:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:38202 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229932AbhDBMRJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 2 Apr 2021 08:17:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617365827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=0jaEPxLaJfReD8pxSOXnANRrSayp5U1dcLmAQj7CP5E=;
        b=b65z4Meu9/5m1HOQO/UQiMMM7gPtxy3UWh7exg5CfXIuAesEM3NVB7DNEBuNxIb168z2RW
        Yec+slbZqeL0276a0rcPT0d0A+AegmLEpdiLHZG4CpLs0IcECG5RVGnQaselS5CLWbpdFe
        Io4ruO+zfcoNU1MWszirwqDdtt+pOo4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-436-JItoow2QM461wIMIdOIiXQ-1; Fri, 02 Apr 2021 08:17:06 -0400
X-MC-Unique: JItoow2QM461wIMIdOIiXQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 70CAA1005D57;
        Fri,  2 Apr 2021 12:17:05 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 13D3F60BF1;
        Fri,  2 Apr 2021 12:17:05 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Ben Gardon <bgardon@google.com>
Subject: [PATCH] KVM: MMU: protect TDP MMU pages only down to required level
Date:   Fri,  2 Apr 2021 08:17:04 -0400
Message-Id: <20210402121704.3424115-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When using manual protection of dirty pages, it is not necessary
to protect nested page tables down to the 4K level; instead KVM
can protect only hugepages in order to split them lazily, and
delay write protection at 4K-granularity until KVM_CLEAR_DIRTY_LOG.
This was overlooked in the TDP MMU, so do it there as well.

Fixes: a6a0b05da9f37 ("kvm: x86/mmu: Support dirty logging for the TDP MMU")
Cc: Ben Gardon <bgardon@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index efb41f31e80a..0d92a269c5fa 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5538,7 +5538,7 @@ void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
 	flush = slot_handle_level(kvm, memslot, slot_rmap_write_protect,
 				start_level, KVM_MAX_HUGEPAGE_LEVEL, false);
 	if (is_tdp_mmu_enabled(kvm))
-		flush |= kvm_tdp_mmu_wrprot_slot(kvm, memslot, PG_LEVEL_4K);
+		flush |= kvm_tdp_mmu_wrprot_slot(kvm, memslot, start_level);
 	write_unlock(&kvm->mmu_lock);
 
 	/*
-- 
2.26.2

