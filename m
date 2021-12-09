Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DFE046E7CF
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 12:55:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236955AbhLIL64 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 06:58:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:26723 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236969AbhLIL64 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Dec 2021 06:58:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639050922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ttg3LOADV5MeuGDhCCWe/pEIYSBz8WcuKITTbGKKzx4=;
        b=TdkpR9PNkCwt10yCsHaEWZsV9iikyX0TinVHpDnHSQAXa4OhlL1OU7YFIFEWgOPxqL42i/
        +OdzssCqRDD6cPoOOi6cRPhrvvyaYOHf4TkBlbS53tLMzNzpYFGR4OqvmuXjrHrg+YxelZ
        MeF1qnqXvv9XxxqWApbL5GxYvfZ2sQc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-526-Pqg5FK5aNTO81bWi9XWhdA-1; Thu, 09 Dec 2021 06:55:19 -0500
X-MC-Unique: Pqg5FK5aNTO81bWi9XWhdA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D992D801B35;
        Thu,  9 Dec 2021 11:55:17 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8C4E767842;
        Thu,  9 Dec 2021 11:55:02 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)), Wanpeng Li <wanpengli@tencent.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 1/6] KVM: SVM: allow to force AVIC to be enabled
Date:   Thu,  9 Dec 2021 13:54:35 +0200
Message-Id: <20211209115440.394441-2-mlevitsk@redhat.com>
In-Reply-To: <20211209115440.394441-1-mlevitsk@redhat.com>
References: <20211209115440.394441-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Apparently on some systems AVIC is disabled in CPUID but still usable.

Allow the user to override the CPUID if the user is willing to
take the risk.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/svm.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index dde0106ffc47..6fbce42b9776 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -206,6 +206,9 @@ module_param(tsc_scaling, int, 0444);
 static bool avic;
 module_param(avic, bool, 0444);
 
+static bool force_avic;
+module_param_unsafe(force_avic, bool, 0444);
+
 bool __read_mostly dump_invalid_vmcb;
 module_param(dump_invalid_vmcb, bool, 0644);
 
@@ -1058,10 +1061,14 @@ static __init int svm_hardware_setup(void)
 			nrips = false;
 	}
 
-	enable_apicv = avic = avic && npt_enabled && boot_cpu_has(X86_FEATURE_AVIC);
+	enable_apicv = avic = avic && npt_enabled && (boot_cpu_has(X86_FEATURE_AVIC) || force_avic);
 
 	if (enable_apicv) {
-		pr_info("AVIC enabled\n");
+		if (!boot_cpu_has(X86_FEATURE_AVIC)) {
+			pr_warn("AVIC is not supported in CPUID but force enabled");
+			pr_warn("Your system might crash and burn");
+		} else
+			pr_info("AVIC enabled\n");
 
 		amd_iommu_register_ga_log_notifier(&avic_ga_log_notifier);
 	}
-- 
2.26.3

