Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23F142E08B2
	for <lists+kvm@lfdr.de>; Tue, 22 Dec 2020 11:23:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbgLVKXD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Dec 2020 05:23:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55902 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726218AbgLVKXD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 22 Dec 2020 05:23:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608632497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=+N230ZQEwlU/fhfKeKl8xLReA8ul9G84WY/PYPF4Snw=;
        b=HLd6pxb7Ml6Cmot3m+usNpPmc+5cBiisT1NDbXKn7XCdSfcBAq7hbUcNx/zH7JPNykmVGY
        EUmLa1g7COJzlyVaS/sJquvuYWkLZdaHVQdLFXUr6LzVs5zhgU+cUSWy0DcqwtTlKURD0w
        Rm3zNxgGLfmAlP26IOBoSX3Q/3WeKB8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-440-i7jEHEeuPp2GfpaDgC8mRw-1; Tue, 22 Dec 2020 05:21:34 -0500
X-MC-Unique: i7jEHEeuPp2GfpaDgC8mRw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CC218800D55;
        Tue, 22 Dec 2020 10:21:33 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5CC717A5CE;
        Tue, 22 Dec 2020 10:21:33 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     syzbot+e87846c48bf72bc85311@syzkaller.appspotmail.com
Subject: [PATCH] KVM: x86: fix shift out of bounds reported by UBSAN
Date:   Tue, 22 Dec 2020 05:21:32 -0500
Message-Id: <20201222102132.1920018-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since we know that e >= s, we can reassociate the left shift,
changing the shifted number from 1 to 2 in exchange for
decreasing the right hand side by 1.

Reported-by: syzbot+e87846c48bf72bc85311@syzkaller.appspotmail.com
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 9c4a9c8e43d9..581925e476d6 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -49,7 +49,7 @@ static inline u64 rsvd_bits(int s, int e)
 	if (e < s)
 		return 0;
 
-	return ((1ULL << (e - s + 1)) - 1) << s;
+	return ((2ULL << (e - s)) - 1) << s;
 }
 
 void kvm_mmu_set_mmio_spte_mask(u64 mmio_value, u64 access_mask);
-- 
2.26.2

