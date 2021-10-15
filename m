Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47AE942ECCC
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 10:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234944AbhJOIyA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 04:54:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22613 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233729AbhJOIx7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Oct 2021 04:53:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634287913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=lf0in5Yit487S3UgW6DfUsaPo/c3rA66pC5gvHMVdJ8=;
        b=BKxrESXzeoNVSxZx14vheOYSRdFZU7OpXWg4bfPPKAObGOEGFs42bbjAufqdISKxJ/Y8Gm
        jKZ/kjHJoHbIcZ/BcyB0GAMRL8cfpWJ33nhKrSSOwXcXMkV7xWsfCWkGEZAeo3tPa/9i90
        6l+QyozIG9KivcZ9QHkHroe1p4EuYZo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-302-9Mrrryo2MICuyG19KOiv7w-1; Fri, 15 Oct 2021 04:51:51 -0400
X-MC-Unique: 9Mrrryo2MICuyG19KOiv7w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1496C9F933;
        Fri, 15 Oct 2021 08:51:50 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1123D10016F4;
        Fri, 15 Oct 2021 08:51:49 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     nathan@kernel.org, seanjc@google.com, torvic9@mailbox.org,
        Jim Mattson <jmattson@google.com>
Subject: [PATCH] KVM: x86: avoid warning with -Wbitwise-instead-of-logical
Date:   Fri, 15 Oct 2021 04:51:48 -0400
Message-Id: <20211015085148.67943-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a new warning in clang top-of-tree (will be clang 14):

In file included from arch/x86/kvm/mmu/mmu.c:27:
arch/x86/kvm/mmu/spte.h:318:9: error: use of bitwise '|' with boolean operands [-Werror,-Wbitwise-instead-of-logical]
        return __is_bad_mt_xwr(rsvd_check, spte) |
               ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                                                 ||
arch/x86/kvm/mmu/spte.h:318:9: note: cast one or both operands to int to silence this warning

Reported-by: torvic9@mailbox.org
Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/spte.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/spte.h b/arch/x86/kvm/mmu/spte.h
index eb7b227fc6cf..32bc7268c9ea 100644
--- a/arch/x86/kvm/mmu/spte.h
+++ b/arch/x86/kvm/mmu/spte.h
@@ -314,9 +314,12 @@ static __always_inline bool is_rsvd_spte(struct rsvd_bits_validate *rsvd_check,
 	 * Use a bitwise-OR instead of a logical-OR to aggregate the reserved
 	 * bits and EPT's invalid memtype/XWR checks to avoid an extra Jcc
 	 * (this is extremely unlikely to be short-circuited as true).
+	 *
+	 * (int) avoids clang's "use of bitwise '|' with boolean operands"
+	 * warning.
 	 */
-	return __is_bad_mt_xwr(rsvd_check, spte) |
-	       __is_rsvd_bits_set(rsvd_check, spte, level);
+	return (int)__is_bad_mt_xwr(rsvd_check, spte) |
+	       (int)__is_rsvd_bits_set(rsvd_check, spte, level);
 }
 
 static inline bool spte_can_locklessly_be_made_writable(u64 spte)
-- 
2.27.0

