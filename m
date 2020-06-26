Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A34220ACE0
	for <lists+kvm@lfdr.de>; Fri, 26 Jun 2020 09:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728277AbgFZHTH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Jun 2020 03:19:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40113 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725884AbgFZHTG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Jun 2020 03:19:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593155945;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Kd8no0/JYBBJaey3wsd+KD3bY5C0EF+almWIUr0Z1a8=;
        b=cP8wQtSaOKjTab5sd8KrT775qfRVi+zp5yMsg+2AhbL63nVuw50cXjC1CdCa5PlcBZC2oH
        OXWbdhcknLmsRWsL8TsFdwomQ+jFRH+/Jd1DTxf3wVqE660fhjL10vwSoqmrkVfe0ljHl6
        qVXwWI1O3LVLyBT6Puq7U/XYBGtpkDA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-1-D9phEzF5PuykqpQkHWiDSg-1; Fri, 26 Jun 2020 03:19:00 -0400
X-MC-Unique: D9phEzF5PuykqpQkHWiDSg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CB2AEEC1B3
        for <kvm@vger.kernel.org>; Fri, 26 Jun 2020 07:18:59 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8CE405F9DB
        for <kvm@vger.kernel.org>; Fri, 26 Jun 2020 07:18:59 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Subject: [PATCH kvm-unit-tests] x86: map bottom 2G 1:1 into page tables
Date:   Fri, 26 Jun 2020 03:18:59 -0400
Message-Id: <20200626071859.6827-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Right now only addresses up to the highest RAM memory address are
are mapped 1:1 into the 32-bit page tables, but this also excludes
ACPI-reserved areas that are higher than the highest RAM memory
address.  Depending on the memory layout, this may prevent the
tests from accessing the ACPI tables after setup_vm.  Unconditionally
including the bottom 2G of memory fixes that.  We do rely on the
ACPI tables being in the first 2GB of memory, which is not necessarily
true on bare metal; fixing that requires adding calls to something like
Linux's kmap/kunmap.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 lib/x86/vm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/lib/x86/vm.c b/lib/x86/vm.c
index edbbe82..2bc2a39 100644
--- a/lib/x86/vm.c
+++ b/lib/x86/vm.c
@@ -154,8 +154,7 @@ void *setup_mmu(phys_addr_t end_of_memory)
     if (end_of_memory > (1ul << 31))
 	    end_of_memory = (1ul << 31);
 
-    /* 0 - 2G memory, 2G-3G valloc area, 3G-4G mmio */
-    setup_mmu_range(cr3, 0, end_of_memory);
+    setup_mmu_range(cr3, 0, (2ul << 30));
     setup_mmu_range(cr3, 3ul << 30, (1ul << 30));
     init_alloc_vpage((void*)(3ul << 30));
 #endif
-- 
2.26.2

