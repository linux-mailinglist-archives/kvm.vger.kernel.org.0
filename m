Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 211F341788D
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 18:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244648AbhIXQdb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 12:33:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48571 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238015AbhIXQda (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Sep 2021 12:33:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632501116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pHxiD8QxANCttvyiT7gVT3Bljga6UHkvpi20YNkEKP4=;
        b=EYgHYGigjxdjJFKv3JCVvWdrzA2QQ6FmUEhog59iqwdBvviN9KA8FNMhqOUa21kDAHO8LG
        gYMPZNjyC+cSyHorYSWrJNB9RZw+K716XoQ6QQDFnha7E5I7UrAQb4lJ26l2Qwd3DpxoWt
        4Rtri+IUqBDfqENyYQMx70e63fa1LLU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-515-I4_du0zSN2qiT9pba9O2yg-1; Fri, 24 Sep 2021 12:31:55 -0400
X-MC-Unique: I4_du0zSN2qiT9pba9O2yg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 19FCC801E72;
        Fri, 24 Sep 2021 16:31:54 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AB98660E1C;
        Fri, 24 Sep 2021 16:31:53 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com
Subject: [PATCH v3 01/31] KVM: MMU: pass unadulterated gpa to direct_page_fault
Date:   Fri, 24 Sep 2021 12:31:22 -0400
Message-Id: <20210924163152.289027-2-pbonzini@redhat.com>
In-Reply-To: <20210924163152.289027-1-pbonzini@redhat.com>
References: <20210924163152.289027-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Do not bother removing the low bits of the gpa.  This masking dates back
to the very first commit of KVM but it is unnecessary, as exemplified
by the other call in kvm_tdp_page_fault.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 7ef9c001d1b6..376e90f4f413 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4018,7 +4018,7 @@ static int nonpaging_page_fault(struct kvm_vcpu *vcpu, gpa_t gpa,
 	pgprintk("%s: gva %lx error %x\n", __func__, gpa, error_code);
 
 	/* This path builds a PAE pagetable, we can map 2mb pages at maximum. */
-	return direct_page_fault(vcpu, gpa & PAGE_MASK, error_code, prefault,
+	return direct_page_fault(vcpu, gpa, error_code, prefault,
 				 PG_LEVEL_2M, false);
 }
 
-- 
2.27.0


