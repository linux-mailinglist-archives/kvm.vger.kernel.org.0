Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 744E53C71FF
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 16:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236795AbhGMOX3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 10:23:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45386 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236785AbhGMOX2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Jul 2021 10:23:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626186037;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=USi2neR0DzsSktw+Hla23BMDPYFAw2A7hH8ryXVbt+4=;
        b=X8J5J3wmArsj26Zr37pW9oXKiKn/bAk+snp8GgVyPtK5grVFzR91g+e9HqYDIwv9Qi9hYk
        c7xuWt/ZOLGBi4886clWGvOKX92sgRe4BVNv9StuVsRqQbOZ/4vqI1xRezYh5kpzrcCyVk
        OFMZzl11sYJGqGl0UwWa8Ug6SDyYf40=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-395-0v-X716FMSa4D9euX_Q_ZA-1; Tue, 13 Jul 2021 10:20:36 -0400
X-MC-Unique: 0v-X716FMSa4D9euX_Q_ZA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE7DD801AC5;
        Tue, 13 Jul 2021 14:20:34 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0BE915D6AB;
        Tue, 13 Jul 2021 14:20:29 +0000 (UTC)
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
Subject: [PATCH v2 1/8] KVM: SVM: svm_set_vintr don't warn if AVIC is active but is about to be deactivated
Date:   Tue, 13 Jul 2021 17:20:16 +0300
Message-Id: <20210713142023.106183-2-mlevitsk@redhat.com>
In-Reply-To: <20210713142023.106183-1-mlevitsk@redhat.com>
References: <20210713142023.106183-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It is possible for AVIC inhibit and AVIC active state to be mismatched.
Currently we disable AVIC right away on vCPU which started the AVIC inhibit
request thus this warning doesn't trigger but at least in theory,
if svm_set_vintr is called at the same time on multiple vCPUs,
the warning can happen.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 12c06ea28f5c..d4d14e318ab5 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1560,8 +1560,11 @@ static void svm_set_vintr(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control;
 
-	/* The following fields are ignored when AVIC is enabled */
-	WARN_ON(kvm_vcpu_apicv_active(&svm->vcpu));
+	/*
+	 * The following fields are ignored when AVIC is enabled
+	 */
+	WARN_ON(kvm_apicv_activated(svm->vcpu.kvm));
+
 	svm_set_intercept(svm, INTERCEPT_VINTR);
 
 	/*
-- 
2.26.3

