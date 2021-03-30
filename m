Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5D034EE9E
	for <lists+kvm@lfdr.de>; Tue, 30 Mar 2021 19:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232319AbhC3RAU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 13:00:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48277 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231910AbhC3RAE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Mar 2021 13:00:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617123603;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ia9RiC+ShFIXJPCH922QqvDmZ58hKqtXlB2NuN0+x8M=;
        b=jMaEr3z2tzu7Yex7Dc8WkvKTJyev9ro4baa72U43JMzjmnW3tT+g6R4VG/se2F7cPJ8/iL
        q274IoPLN6c2hAWwdPof/A2PAxBH/8bd6GbNU8+n/iZfp2lZPu0dKl89tnC9quOfQU1N+W
        Aik1s+w1Rch3iwX+tgQceqLX3vH+m7o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-451-ZI0GqeLDP0GB28ZlAJTShA-1; Tue, 30 Mar 2021 13:00:01 -0400
X-MC-Unique: ZI0GqeLDP0GB28ZlAJTShA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 28023190A7A2;
        Tue, 30 Mar 2021 17:00:00 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A9BB163B8C;
        Tue, 30 Mar 2021 16:59:59 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mtosatti@redhat.com, vkuznets@redhat.com, dwmw@amazon.co.uk
Subject: [PATCH 1/2] KVM: x86: reduce pvclock_gtod_sync_lock critical sections
Date:   Tue, 30 Mar 2021 12:59:57 -0400
Message-Id: <20210330165958.3094759-2-pbonzini@redhat.com>
In-Reply-To: <20210330165958.3094759-1-pbonzini@redhat.com>
References: <20210330165958.3094759-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There is no need to include changes to vcpu->requests into
the pvclock_gtod_sync_lock critical section.  The changes to
the shared data structures (in pvclock_update_vm_gtod_copy)
already occur under the lock.

Cc: David Woodhouse <dwmw@amazon.co.uk>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fe806e894212..0a83eff40b43 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2562,10 +2562,12 @@ static void kvm_gen_update_masterclock(struct kvm *kvm)
 
 	kvm_hv_invalidate_tsc_page(kvm);
 
-	spin_lock(&ka->pvclock_gtod_sync_lock);
 	kvm_make_mclock_inprogress_request(kvm);
+
 	/* no guest entries from this point */
+	spin_lock(&ka->pvclock_gtod_sync_lock);
 	pvclock_update_vm_gtod_copy(kvm);
+	spin_unlock(&ka->pvclock_gtod_sync_lock);
 
 	kvm_for_each_vcpu(i, vcpu, kvm)
 		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
@@ -2573,8 +2575,6 @@ static void kvm_gen_update_masterclock(struct kvm *kvm)
 	/* guest entries allowed */
 	kvm_for_each_vcpu(i, vcpu, kvm)
 		kvm_clear_request(KVM_REQ_MCLOCK_INPROGRESS, vcpu);
-
-	spin_unlock(&ka->pvclock_gtod_sync_lock);
 #endif
 }
 
@@ -7740,16 +7740,14 @@ static void kvm_hyperv_tsc_notifier(void)
 		struct kvm_arch *ka = &kvm->arch;
 
 		spin_lock(&ka->pvclock_gtod_sync_lock);
-
 		pvclock_update_vm_gtod_copy(kvm);
+		spin_unlock(&ka->pvclock_gtod_sync_lock);
 
 		kvm_for_each_vcpu(cpu, vcpu, kvm)
 			kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 
 		kvm_for_each_vcpu(cpu, vcpu, kvm)
 			kvm_clear_request(KVM_REQ_MCLOCK_INPROGRESS, vcpu);
-
-		spin_unlock(&ka->pvclock_gtod_sync_lock);
 	}
 	mutex_unlock(&kvm_lock);
 }
-- 
2.26.2


