Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 517163B18F8
	for <lists+kvm@lfdr.de>; Wed, 23 Jun 2021 13:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231127AbhFWLdN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Jun 2021 07:33:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49837 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231128AbhFWLdF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Jun 2021 07:33:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624447847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g2wFOyxPqoYZUXLCy4FsI2gd7mT6X/jVhqusv1aT0Sw=;
        b=QFoXpuVQPTyZbIJdr2h3WuiFGdqdyZP9chHjhXR88UtY0RS04p3jED245myCxdUWr19kVQ
        1mxG+Vtdyil0/rsv29nAuSqTY5c2+DEqaEYWoPwxPMZzP4Ok/OeFxR5+xd1q/DjHoikZFM
        xwTFs7ZGItq5w3qGsANs4INM6CxirXI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-AxUqDcDUPoSpFfjFxKYU1A-1; Wed, 23 Jun 2021 07:30:46 -0400
X-MC-Unique: AxUqDcDUPoSpFfjFxKYU1A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DECC1801596;
        Wed, 23 Jun 2021 11:30:44 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 15B951ABE6;
        Wed, 23 Jun 2021 11:30:40 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)),
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 08/10] KVM: x86: APICv: drop immediate APICv disablement on current vCPU
Date:   Wed, 23 Jun 2021 14:30:00 +0300
Message-Id: <20210623113002.111448-9-mlevitsk@redhat.com>
In-Reply-To: <20210623113002.111448-1-mlevitsk@redhat.com>
References: <20210623113002.111448-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Special case of disabling the APICv on the current vCPU right away in
kvm_request_apicv_update doesn't bring much benefit vs raising
KVM_REQ_APICV_UPDATE on it instead, since this request will be processed
on the next entry to the guest.
(the comment about having another #VMEXIT is wrong).

It also hides various assumptions, that APICv enable state matches
the APICv inhibit state, as this special case only makes those states
match on the current vCPU.

Previous patches fixed few such assumptions so now it should be safe
to drop this special case.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/x86.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6f0d9c231249..dcf06acdbf52 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9209,7 +9209,6 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_update_apicv);
  */
 void kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
 {
-	struct kvm_vcpu *except;
 	unsigned long old, new, expected;
 
 	if (!kvm_x86_ops.check_apicv_inhibit_reasons ||
@@ -9237,18 +9236,9 @@ void kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
 	if (kvm_x86_ops.pre_update_apicv_exec_ctrl)
 		static_call(kvm_x86_pre_update_apicv_exec_ctrl)(kvm, activate);
 
-	/*
-	 * Sending request to update APICV for all other vcpus,
-	 * while update the calling vcpu immediately instead of
-	 * waiting for another #VMEXIT to handle the request.
-	 */
-	except = kvm_get_running_vcpu();
-	kvm_make_all_cpus_request_except(kvm, KVM_REQ_APICV_UPDATE,
-					 except);
+	kvm_make_all_cpus_request(kvm, KVM_REQ_APICV_UPDATE);
 
 	kvm_allow_guest_entries(kvm);
-	if (except)
-		kvm_vcpu_update_apicv(except);
 }
 EXPORT_SYMBOL_GPL(kvm_request_apicv_update);
 
-- 
2.26.3

