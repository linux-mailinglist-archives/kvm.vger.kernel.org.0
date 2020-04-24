Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5C2E1B7339
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 13:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbgDXLiH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 07:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726667AbgDXLiG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 07:38:06 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A460C09B045;
        Fri, 24 Apr 2020 04:38:06 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id j2so10381800wrs.9;
        Fri, 24 Apr 2020 04:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mG9eU+aM3EiusgpSEHFIr98SypSKh+boePa08AAVfTc=;
        b=pBnlHnqWhwtUfuxB+KkmmcbKIFYM3zo+4df6l5pFF1lyemTYVKYtek0RpiVwHydvhN
         Q0VXcLlEuPDOixhiQMUXop6CEc9pQkHtHqYvRc00thuqow7QdkWKT+elWksyuvDv6tyg
         WvDDl0FXj+iENxEOo+bkpOiq09vdTDpLi531ZW29rlArBb7GoHo6OQFp7RcunxRo256s
         U9pUs0UQZ2XLd5m8x4tLdnQb9NvzLBcdfmMfogfzQpYBL7yd6UHV9+uYkrytlrqME/nh
         VP+85551i0tp8U31KHqvCQmFbWt/74sKRHY/yqc1YdgUVG/fFF/xo6W1jYptPp8Ju/13
         fzKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mG9eU+aM3EiusgpSEHFIr98SypSKh+boePa08AAVfTc=;
        b=TjrLd48JCZ2avz1T9FksV0Zo4nvDxeqi13qHmFL4GISQRMSwMkoGzKer1IW4P9n7c8
         oPaN8YrbL0AMsL0KEKk9Wzd4GwkmHmt1nD92DaKwYJ/1qgEdiWn90TYIvtdFcmOpjBbg
         q/KR1Yny4lLB/wYOtAXjglx2IxiuSCOEFN0fEoXRMhq22Sy9E0SV2sIFLQvldZhrlWby
         KBXb4neBNAuheGWP9bEoBBKzQeoyoamGmcfY8GjAARo+WRRI0G4fZiAA/QGK26Zw9mC3
         VSvvZg25HoH/zJ2K6RMsh7U4MpU8e5594hJT2RVUVnWwubWw5QOrnDsBjw2cx0+qXimA
         Jv0w==
X-Gm-Message-State: AGi0PuY8yA2Uk06/9YxEUVFw+9BfnTSqogMaRFqyAjcyPLlug1u6KC8x
        UB3HTHrbbyaEH+Ytfx+PPDpP2Qxh/ME=
X-Google-Smtp-Source: APiQypLtzruqxGMWb9iWkasbikxYsG/0rU/KRfjPLjHKXU3NafnPvqxWVI+Es/oGLYP2IQvWiRUigg==
X-Received: by 2002:adf:ee4c:: with SMTP id w12mr11643554wro.347.1587728284593;
        Fri, 24 Apr 2020 04:38:04 -0700 (PDT)
Received: from jondnuc.lan (IGLD-84-229-154-20.inter.net.il. [84.229.154.20])
        by smtp.gmail.com with ESMTPSA id w83sm2451007wmb.37.2020.04.24.04.38.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 04:38:03 -0700 (PDT)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com, Jon Doron <arilou@gmail.com>
Subject: [PATCH v11 2/7] x86/kvm/hyper-v: Simplify addition for custom cpuid leafs
Date:   Fri, 24 Apr 2020 14:37:41 +0300
Message-Id: <20200424113746.3473563-3-arilou@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200424113746.3473563-1-arilou@gmail.com>
References: <20200424113746.3473563-1-arilou@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Simlify the code to define a new cpuid leaf group by enabled feature.

This also fixes a bug in which the max cpuid leaf was always set to
HYPERV_CPUID_NESTED_FEATURES regardless if nesting is supported or not.

Any new CPUID group needs to consider the max leaf and be added in the
correct order, in this method there are two rules:
1. Each cpuid leaf group must be order in an ascending order
2. The appending for the cpuid leafs by features also needs to happen by
   ascending order.

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Jon Doron <arilou@gmail.com>
---
 arch/x86/kvm/hyperv.c | 46 ++++++++++++++++++++++++++++++-------------
 1 file changed, 32 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index bcefa9d4e57e..ab3e9dbcabbe 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1785,27 +1785,45 @@ int kvm_vm_ioctl_hv_eventfd(struct kvm *kvm, struct kvm_hyperv_eventfd *args)
 	return kvm_hv_eventfd_assign(kvm, args->conn_id, args->fd);
 }
 
+/* Must be sorted in ascending order by function */
+static struct kvm_cpuid_entry2 core_cpuid_entries[] = {
+	{ .function = HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS },
+	{ .function = HYPERV_CPUID_INTERFACE },
+	{ .function = HYPERV_CPUID_VERSION },
+	{ .function = HYPERV_CPUID_FEATURES },
+	{ .function = HYPERV_CPUID_ENLIGHTMENT_INFO },
+	{ .function = HYPERV_CPUID_IMPLEMENT_LIMITS },
+};
+
+static struct kvm_cpuid_entry2 evmcs_cpuid_entries[] = {
+	{ .function = HYPERV_CPUID_NESTED_FEATURES },
+};
+
+#define HV_MAX_CPUID_ENTRIES \
+	(ARRAY_SIZE(core_cpuid_entries) +\
+	 ARRAY_SIZE(evmcs_cpuid_entries))
+
 int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 				struct kvm_cpuid_entry2 __user *entries)
 {
 	uint16_t evmcs_ver = 0;
-	struct kvm_cpuid_entry2 cpuid_entries[] = {
-		{ .function = HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS },
-		{ .function = HYPERV_CPUID_INTERFACE },
-		{ .function = HYPERV_CPUID_VERSION },
-		{ .function = HYPERV_CPUID_FEATURES },
-		{ .function = HYPERV_CPUID_ENLIGHTMENT_INFO },
-		{ .function = HYPERV_CPUID_IMPLEMENT_LIMITS },
-		{ .function = HYPERV_CPUID_NESTED_FEATURES },
-	};
-	int i, nent = ARRAY_SIZE(cpuid_entries);
+	struct kvm_cpuid_entry2 cpuid_entries[HV_MAX_CPUID_ENTRIES];
+	int i, nent = 0;
+
+	/* Set the core cpuid entries required for Hyper-V */
+	memcpy(&cpuid_entries[nent], &core_cpuid_entries,
+	       sizeof(core_cpuid_entries));
+	nent = ARRAY_SIZE(core_cpuid_entries);
 
 	if (kvm_x86_ops.nested_get_evmcs_version)
 		evmcs_ver = kvm_x86_ops.nested_get_evmcs_version(vcpu);
 
-	/* Skip NESTED_FEATURES if eVMCS is not supported */
-	if (!evmcs_ver)
-		--nent;
+	if (evmcs_ver) {
+		/* EVMCS is enabled, add the required EVMCS CPUID leafs */
+		memcpy(&cpuid_entries[nent], &evmcs_cpuid_entries,
+		       sizeof(evmcs_cpuid_entries));
+		nent += ARRAY_SIZE(evmcs_cpuid_entries);
+	}
 
 	if (cpuid->nent < nent)
 		return -E2BIG;
@@ -1821,7 +1839,7 @@ int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
 		case HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS:
 			memcpy(signature, "Linux KVM Hv", 12);
 
-			ent->eax = HYPERV_CPUID_NESTED_FEATURES;
+			ent->eax = cpuid_entries[nent - 1].function;
 			ent->ebx = signature[0];
 			ent->ecx = signature[1];
 			ent->edx = signature[2];
-- 
2.24.1

