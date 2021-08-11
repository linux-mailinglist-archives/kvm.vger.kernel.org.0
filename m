Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0FB3E8E83
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 12:24:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237177AbhHKKY2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 06:24:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27022 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237048AbhHKKYY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Aug 2021 06:24:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628677441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wLvJUk0EFS3fd/mE1+K8o0MnXd8FMnIzSzSgFYviWHk=;
        b=Q/0/OXujKO43ftPFciRmKlPoIqYVrBox4aM2ZTtg1hwY4sJ72gokSpRr7d2h8XuaxXmgOd
        +g4PI5Gegmx+QEEvY111baEkinI5yAABl4INCNKHNNP+r5tp0h1Djq8F3T0Y1iIAHGwFPa
        4trlSYI8Xq7DKfSbWF4GZfohV3ed9Bg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-163-4Q4uRU6KOMGCJ41EuNzv6A-1; Wed, 11 Aug 2021 06:23:59 -0400
X-MC-Unique: 4Q4uRU6KOMGCJ41EuNzv6A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D510018C89CF;
        Wed, 11 Aug 2021 10:23:58 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7579E5D9C6;
        Wed, 11 Aug 2021 10:23:58 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, mtosatti@redhat.com
Subject: [PATCH 1/2] KVM: KVM-on-hyperv: shorten no-entry section on reenlightenment
Date:   Wed, 11 Aug 2021 06:23:55 -0400
Message-Id: <20210811102356.3406687-2-pbonzini@redhat.com>
In-Reply-To: <20210811102356.3406687-1-pbonzini@redhat.com>
References: <20210811102356.3406687-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

During re-enlightenment, update kvmclock a VM at a time instead of
raising KVM_REQ_MASTERCLOCK_UPDATE for all VMs.  Because the guests
can now run after TSC emulation has been disabled, invalidate
their TSC page so that they refer to the reference time counter
MSR while the update is in progress.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bab8eb3e0a47..284afaa1db86 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8111,7 +8111,7 @@ static void kvm_hyperv_tsc_notifier(void)
 
 	mutex_lock(&kvm_lock);
 	list_for_each_entry(kvm, &vm_list, vm_list)
-		kvm_make_mclock_inprogress_request(kvm);
+		kvm_hv_invalidate_tsc_page(kvm);
 
 	hyperv_stop_tsc_emulation();
 
@@ -8123,6 +8123,7 @@ static void kvm_hyperv_tsc_notifier(void)
 	list_for_each_entry(kvm, &vm_list, vm_list) {
 		struct kvm_arch *ka = &kvm->arch;
 
+		kvm_make_mclock_inprogress_request(kvm);
 		spin_lock_irqsave(&ka->pvclock_gtod_sync_lock, flags);
 		pvclock_update_vm_gtod_copy(kvm);
 		spin_unlock_irqrestore(&ka->pvclock_gtod_sync_lock, flags);
-- 
2.27.0


