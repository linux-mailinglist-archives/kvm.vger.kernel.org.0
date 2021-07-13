Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33E583C7205
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 16:20:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236880AbhGMOXl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 10:23:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:20933 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236884AbhGMOXl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Jul 2021 10:23:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626186051;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ODCACKiN6QCkZhzWLLA0L2Mc6+FY+1Xm7YVdgewvnSs=;
        b=XAYwbcEMEhWXXpoir+Dekj5UQgZXD16otORF5r0tmuRWRTnjo0EAbsa2Z9fYorlRaP4jDu
        J+EARY/hwBqPD9CN9GZNr4g80DTiE0boLrqksTfxK6W1lzLTAbKKRybFNCCfMuOtyU2oMb
        m0lqmep4u/HT9PE30RgBMS/J1ahqsTg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196-JoIXVxNxP9G4MJgSDMC9aw-1; Tue, 13 Jul 2021 10:20:50 -0400
X-MC-Unique: JoIXVxNxP9G4MJgSDMC9aw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 87D93100CA88;
        Tue, 13 Jul 2021 14:20:48 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6B30D5D6AB;
        Tue, 13 Jul 2021 14:20:44 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 4/8] KVM: x86: APICv: drop immediate APICv disablement on current vCPU
Date:   Tue, 13 Jul 2021 17:20:19 +0300
Message-Id: <20210713142023.106183-5-mlevitsk@redhat.com>
In-Reply-To: <20210713142023.106183-1-mlevitsk@redhat.com>
References: <20210713142023.106183-1-mlevitsk@redhat.com>
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

It also hides various assumptions that APIVc enable state matches
the APICv inhibit state, as this special case only makes those states
match on the current vCPU.

Previous patches fixed few such assumptions so now it should be safe
to drop this special case.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/x86.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 76dae88cf524..29b92f6cbad4 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9204,7 +9204,6 @@ EXPORT_SYMBOL_GPL(kvm_vcpu_update_apicv);
  */
 void kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
 {
-	struct kvm_vcpu *except;
 	unsigned long old, new, expected;
 
 	if (!kvm_x86_ops.check_apicv_inhibit_reasons ||
@@ -9230,16 +9229,7 @@ void kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
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
-	if (except)
-		kvm_vcpu_update_apicv(except);
+	kvm_make_all_cpus_request(kvm, KVM_REQ_APICV_UPDATE);
 }
 EXPORT_SYMBOL_GPL(kvm_request_apicv_update);
 
-- 
2.26.3

