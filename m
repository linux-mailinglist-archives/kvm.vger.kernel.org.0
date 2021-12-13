Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A8A472A99
	for <lists+kvm@lfdr.de>; Mon, 13 Dec 2021 11:48:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234458AbhLMKsK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 05:48:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:39503 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230033AbhLMKsJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 13 Dec 2021 05:48:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639392488;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jnXL5IiyKlqaAw3UKpSxxZyirByxfhySDRurZ1Ij+oA=;
        b=LSvT6HTwg1+tCPJReYwkLDU22+VgBlyu3xyhh01babzCRP/17R1CA1mHKUGRpUUNFO6l5Y
        j/sBmfB+zczxSdpYIR7pmt7UA2GKibQkRJWuFDRCVTT1Pl+5RQBhK4CEVtAOEj3YA/q4vv
        V4lvqLUyiMXJ9jwwOthP7mTR4LM+jkU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-537-XBVA_j1IOd2ehJoQPF96TQ-1; Mon, 13 Dec 2021 05:48:05 -0500
X-MC-Unique: XBVA_j1IOd2ehJoQPF96TQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9D49664083;
        Mon, 13 Dec 2021 10:48:03 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D46595F70B;
        Mon, 13 Dec 2021 10:47:49 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Joerg Roedel <joro@8bytes.org>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH v2 2/5] KVM: SVM: allow to force AVIC to be enabled
Date:   Mon, 13 Dec 2021 12:46:31 +0200
Message-Id: <20211213104634.199141-3-mlevitsk@redhat.com>
In-Reply-To: <20211213104634.199141-1-mlevitsk@redhat.com>
References: <20211213104634.199141-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
index c9668a3b51011..468cc385c35f0 100644
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
 
@@ -4656,10 +4659,14 @@ static __init int svm_hardware_setup(void)
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
 	} else {
-- 
2.26.3

