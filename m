Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 859464178AC
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 18:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347790AbhIXQeO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 12:34:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23614 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347563AbhIXQdo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Sep 2021 12:33:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632501131;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qL/Fo69qHh5c5R89ouXW2U4KuN8yDIZo4UXDpb1Egt8=;
        b=cf9fT9i8QvVoABs+cfimqXqzXiRuVu+MIC1o+hoNQbGsJqP54bjt1W9NYbJnXLQmWS6qGI
        7hWxdr7e1eQ174IHvvltu8+P2uBoBcv2EZ8tlehQ1r4JbkZVgxIvbDphFKI1rjdt6dIEnw
        8xtcARSUH7UlM83IGyVOSVjv72ko/QM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-398-jQ6UNi3MPOa6GFVeQ7x5pw-1; Fri, 24 Sep 2021 12:32:09 -0400
X-MC-Unique: jQ6UNi3MPOa6GFVeQ7x5pw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BBDBE802EDD;
        Fri, 24 Sep 2021 16:32:08 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 19DEC79452;
        Fri, 24 Sep 2021 16:32:08 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     dmatlack@google.com, seanjc@google.com
Subject: [PATCH v3 26/31] KVM: MMU: set ad_disabled in TDP MMU role
Date:   Fri, 24 Sep 2021 12:31:47 -0400
Message-Id: <20210924163152.289027-27-pbonzini@redhat.com>
In-Reply-To: <20210924163152.289027-1-pbonzini@redhat.com>
References: <20210924163152.289027-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Prepare for removing the ad_disabled argument of make_spte; instead it can
be found in the role of a struct kvm_mmu_page.  First of all, the TDP MMU
must set the role accurately.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/mmu/tdp_mmu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 6de2c957edd6..1cdb5618bb76 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -167,6 +167,7 @@ static union kvm_mmu_page_role page_role_for_level(struct kvm_vcpu *vcpu,
 	role.direct = true;
 	role.gpte_is_8_bytes = true;
 	role.access = ACC_ALL;
+	role.ad_disabled = !shadow_accessed_mask;
 
 	return role;
 }
-- 
2.27.0


