Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB8183E84C6
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 22:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234134AbhHJUy1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 16:54:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42407 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234442AbhHJUyU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 16:54:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628628838;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PChJQ8YiZuqlKDf0pcp+09/gCb+c3SbgDQZ89cTtemM=;
        b=GKJM+Jv2Bf6UirFtnEE+q++lIBejy6nrOq5LGA4U4DSiPFeSDu9i4nSC6xYQrquzem32r5
        O97eEkiokm/Ed2yXB9XMDzKtz6weWlfKGw9DJL0IRZTQkVVqCDYQjsqRV8U2w5ZYl8Py7z
        NY1D+M+V14WhIXbAwP3Gf3WeEiMyUKg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-584-b9tqnjZgOnKLZHbbJIlNnA-1; Tue, 10 Aug 2021 16:53:57 -0400
X-MC-Unique: b9tqnjZgOnKLZHbbJIlNnA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 50F7D185302C;
        Tue, 10 Aug 2021 20:53:55 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9E4955B4BC;
        Tue, 10 Aug 2021 20:53:51 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v4 13/16] KVM: SVM: avoid refreshing avic if its state didn't change
Date:   Tue, 10 Aug 2021 23:52:48 +0300
Message-Id: <20210810205251.424103-14-mlevitsk@redhat.com>
In-Reply-To: <20210810205251.424103-1-mlevitsk@redhat.com>
References: <20210810205251.424103-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since AVIC can be inhibited and uninhibited rapidly it is possible that
we have nothing to do by the time the svm_refresh_apicv_exec_ctrl
is called.

Detect and avoid this, which will be useful when we will start calling
avic_vcpu_load/avic_vcpu_put when the avic inhibition state changes.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/x86.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b6185921fe44..e2ec45e3dc0a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9239,12 +9239,18 @@ void kvm_make_scan_ioapic_request(struct kvm *kvm)
 
 void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 {
+	bool activate;
+
 	if (!lapic_in_kernel(vcpu))
 		return;
 
 	mutex_lock(&vcpu->kvm->arch.apicv_update_lock);
 
-	vcpu->arch.apicv_active = kvm_apicv_activated(vcpu->kvm);
+	activate = kvm_apicv_activated(vcpu->kvm);
+	if (vcpu->arch.apicv_active == activate)
+		goto out;
+
+	vcpu->arch.apicv_active = activate;
 	kvm_apic_update_apicv(vcpu);
 	static_call(kvm_x86_refresh_apicv_exec_ctrl)(vcpu);
 
@@ -9257,6 +9263,7 @@ void kvm_vcpu_update_apicv(struct kvm_vcpu *vcpu)
 	if (!vcpu->arch.apicv_active)
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
 
+out:
 	mutex_unlock(&vcpu->kvm->arch.apicv_update_lock);
 }
 EXPORT_SYMBOL_GPL(kvm_vcpu_update_apicv);
-- 
2.26.3

