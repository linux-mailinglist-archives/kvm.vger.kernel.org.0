Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A64BE360AD5
	for <lists+kvm@lfdr.de>; Thu, 15 Apr 2021 15:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233459AbhDONoW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Apr 2021 09:44:22 -0400
Received: from linux.microsoft.com ([13.77.154.182]:41532 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233389AbhDONoV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Apr 2021 09:44:21 -0400
Received: from viremana-dev.fwjladdvyuiujdukmejncen4mf.xx.internal.cloudapp.net (unknown [13.66.132.26])
        by linux.microsoft.com (Postfix) with ESMTPSA id A2E4820B8002;
        Thu, 15 Apr 2021 06:43:57 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A2E4820B8002
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1618494237;
        bh=zgpGiyGDi60pFC4qD9nG0XS7yB8eDhV4EULVqhMuJOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r013N2753/Bt4Mz7SOGaPTdZktqIW+RyyfknILC0UhlgvO2sy45QDHjH/numJGnm6
         1B74ebXrBxviT5EL//+CgA8XCGAkNTPP2xUOV8jFPMfIXuonIHKtDIVFml2juoyZWR
         8rnpghLmpk3IKeUPqs6ZUnskABrFtS6p3IndWIyo=
From:   Vineeth Pillai <viremana@linux.microsoft.com>
To:     Lan Tianyu <Tianyu.Lan@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Wei Liu <wei.liu@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Cc:     Vineeth Pillai <viremana@linux.microsoft.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Subject: [PATCH v2 1/7] hyperv: Detect Nested virtualization support for SVM
Date:   Thu, 15 Apr 2021 13:43:36 +0000
Message-Id: <9d12558549bc0c6f179b26f5b16c751bdfab3f74.1618492553.git.viremana@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1618492553.git.viremana@linux.microsoft.com>
References: <cover.1618492553.git.viremana@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Detect nested features exposed by Hyper-V if SVM is enabled.

Signed-off-by: Vineeth Pillai <viremana@linux.microsoft.com>
---
 arch/x86/kernel/cpu/mshyperv.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 3546d3e21787..c6f812851e37 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -252,6 +252,7 @@ static void __init hv_smp_prepare_cpus(unsigned int max_cpus)
 
 static void __init ms_hyperv_init_platform(void)
 {
+	int hv_max_functions_eax;
 	int hv_host_info_eax;
 	int hv_host_info_ebx;
 	int hv_host_info_ecx;
@@ -269,6 +270,8 @@ static void __init ms_hyperv_init_platform(void)
 	ms_hyperv.misc_features = cpuid_edx(HYPERV_CPUID_FEATURES);
 	ms_hyperv.hints    = cpuid_eax(HYPERV_CPUID_ENLIGHTMENT_INFO);
 
+	hv_max_functions_eax = cpuid_eax(HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS);
+
 	pr_info("Hyper-V: privilege flags low 0x%x, high 0x%x, hints 0x%x, misc 0x%x\n",
 		ms_hyperv.features, ms_hyperv.priv_high, ms_hyperv.hints,
 		ms_hyperv.misc_features);
@@ -298,8 +301,7 @@ static void __init ms_hyperv_init_platform(void)
 	/*
 	 * Extract host information.
 	 */
-	if (cpuid_eax(HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS) >=
-	    HYPERV_CPUID_VERSION) {
+	if (hv_max_functions_eax >= HYPERV_CPUID_VERSION) {
 		hv_host_info_eax = cpuid_eax(HYPERV_CPUID_VERSION);
 		hv_host_info_ebx = cpuid_ebx(HYPERV_CPUID_VERSION);
 		hv_host_info_ecx = cpuid_ecx(HYPERV_CPUID_VERSION);
@@ -325,9 +327,11 @@ static void __init ms_hyperv_init_platform(void)
 			ms_hyperv.isolation_config_a, ms_hyperv.isolation_config_b);
 	}
 
-	if (ms_hyperv.hints & HV_X64_ENLIGHTENED_VMCS_RECOMMENDED) {
+	if (hv_max_functions_eax >= HYPERV_CPUID_NESTED_FEATURES) {
 		ms_hyperv.nested_features =
 			cpuid_eax(HYPERV_CPUID_NESTED_FEATURES);
+		pr_info("Hyper-V: Nested features: 0x%x\n",
+			ms_hyperv.nested_features);
 	}
 
 	/*
-- 
2.25.1

