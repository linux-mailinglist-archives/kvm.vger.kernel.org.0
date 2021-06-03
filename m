Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3730839A423
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 17:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbhFCPQh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 11:16:37 -0400
Received: from linux.microsoft.com ([13.77.154.182]:45620 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231899AbhFCPQf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 11:16:35 -0400
Received: from viremana-dev.fwjladdvyuiujdukmejncen4mf.xx.internal.cloudapp.net (unknown [13.66.132.26])
        by linux.microsoft.com (Postfix) with ESMTPSA id CE37020B7188;
        Thu,  3 Jun 2021 08:14:50 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com CE37020B7188
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1622733290;
        bh=O3R7ws0U1fc7rrTaS2RFaXACmChpTZ3DpIk2uE0vGg8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l8n2qhBE+IghZbV6I9D9skkltxgYO602PDn1sHiYTYlxYto/RwPzkGHTUHc5GLkJb
         TJH1e3/r6frNWDbPH2Qm2QHq5USEg+SbiHGClri1Mi4vqNwJ0exe0f6VWPMksvHUu3
         xikff++r0duXkS6PvuXkELZIwI/iLJ29qPmjQweM=
From:   Vineeth Pillai <viremana@linux.microsoft.com>
To:     Lan Tianyu <Tianyu.Lan@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
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
Subject: [PATCH v5 1/7] hyperv: Detect Nested virtualization support for SVM
Date:   Thu,  3 Jun 2021 15:14:34 +0000
Message-Id: <43b25ff21cd2d9a51582033c9bdd895afefac056.1622730232.git.viremana@linux.microsoft.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1622730232.git.viremana@linux.microsoft.com>
References: <cover.1622730232.git.viremana@linux.microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Previously, to detect nested virtualization enlightenment support,
we were using HV_X64_ENLIGHTENED_VMCS_RECOMMENDED feature bit of
HYPERV_CPUID_ENLIGHTMENT_INFO.EAX CPUID as docuemented in TLFS:
 "Bit 14: Recommend a nested hypervisor using the enlightened VMCS
  interface. Also indicates that additional nested enlightenments
  may be available (see leaf 0x4000000A)".

Enlightened VMCS, however, is an Intel only feature so the above
detection method doesn't work for AMD. So, use the
HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS.EAX CPUID information ("The
maximum input value for hypervisor CPUID information.") and this
works for both AMD and Intel.

Signed-off-by: Vineeth Pillai <viremana@linux.microsoft.com>
---
 arch/x86/kernel/cpu/mshyperv.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 22f13343b5da..c268c2730048 100644
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

