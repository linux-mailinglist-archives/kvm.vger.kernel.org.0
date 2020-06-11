Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9B961F6D1D
	for <lists+kvm@lfdr.de>; Thu, 11 Jun 2020 20:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728204AbgFKSCH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jun 2020 14:02:07 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:55036 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727007AbgFKSCG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 11 Jun 2020 14:02:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591898526;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=TaFY/pzHC7fb3rV1r0JXiWmdM/VEPKtAIoA1+kwyi30=;
        b=OGGnElLTKoWlkh8Odk+bsPk0P3gbGdq9oRM7CASTEUD4RCY/uLyvUPHnThY6NN9tZnZLj2
        XPc0nLnkt8wI/er8uD5JEcrIHG1594tYJj+HwzGxfYXIH/CjywWEbHOLjZf0aVJVzXLu2s
        rtojLPNT7PczlpxMdHgy6LFL549Abls=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-465-nQF5lnqxMvidAmlmphna0Q-1; Thu, 11 Jun 2020 14:02:01 -0400
X-MC-Unique: nQF5lnqxMvidAmlmphna0Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 18933107ACF2;
        Thu, 11 Jun 2020 18:02:00 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9CE977F4DB;
        Thu, 11 Jun 2020 18:01:59 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH] KVM: x86: do not pass poisoned hva to __kvm_set_memory_region
Date:   Thu, 11 Jun 2020 14:01:59 -0400
Message-Id: <20200611180159.26085-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

__kvm_set_memory_region does not use the hva at all, so trying to
catch use-after-delete is pointless and, worse, it fails access_ok
now that we apply it to all memslots including private kernel ones.
This fixes an AVIC regression.

Fixes: 09d952c971a5 ("KVM: check userspace_addr for all memslots", 2020-06-01)
Reported-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 290784ba63e4..00c88c2f34e4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9951,13 +9951,8 @@ int __x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa, u32 size)
 		if (!slot || !slot->npages)
 			return 0;
 
-		/*
-		 * Stuff a non-canonical value to catch use-after-delete.  This
-		 * ends up being 0 on 32-bit KVM, but there's no better
-		 * alternative.
-		 */
-		hva = (unsigned long)(0xdeadull << 48);
 		old_npages = slot->npages;
+		hva = 0;
 	}
 
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
-- 
2.26.2

