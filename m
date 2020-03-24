Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 136DE190680
	for <lists+kvm@lfdr.de>; Tue, 24 Mar 2020 08:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbgCXHoD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Mar 2020 03:44:03 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33442 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727382AbgCXHoC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Mar 2020 03:44:02 -0400
Received: by mail-wr1-f68.google.com with SMTP id a25so20183954wrd.0;
        Tue, 24 Mar 2020 00:44:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FBo/I3IjqW13xQQdz3zV+8bxe09vH48ZTko2t8Zublw=;
        b=n6Du4zX64jXbBhAFj+HUxCeTsD+ZU/UY+/zB5tGufs0ZJieXdgRU+cJDSFjvWvbGOQ
         bEVNLS5K5jUHuJx+5XrH78ew2mDYpd+VJ0DXVKARLRP0HCQpoO8rlTyO1zxiA9hB6lO6
         Ull9OEHa0vKoSip3ZXMwwOhtZqGq2G9YkQq1HhycJfc59pnA/EAQiFpYttMaOyVJwLJt
         iKtcG+aABY1vAiWGNe34nCaFB5BZhSiivlq+gyUbIv6MrUc+894cIrWa8Y/AWtsYWCIm
         Tla0Td7jFgI5EVgjXJ+ZIGfiN0YgGzj46IO4YVOQTeTH/I0i7casd5FK2aIThXjTbAgS
         ec9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FBo/I3IjqW13xQQdz3zV+8bxe09vH48ZTko2t8Zublw=;
        b=XBM6ZNkd5ui5Z5jiAmToyrs+pWzy4f41On6NCWfsHTdBJMHz0UX/+H4uF31tiw4CRQ
         Dk21yN1kT7T6cF15PcW3L/TOa35QF7pbG2guyGvGQgmE6JnH7g5qBstawyxcMCVVnZAQ
         vGWXZnMaEVBp0H9rrD0yiCvpRcko+R8gyu54Z/5cvdKlWnhx7UZq3kZToNJEnbviRFbd
         VxrKFaZgAZmosxehLAkBs7o3Hdor03AIF3cBUT9fO0TIqzovmU4dr1gVw5geTrUM3k5m
         h4ZXHSgqZYji1/MjjVVoidEb2hqiYngANL30CwLMSkWjCA7Ppuxetkv0fpjAcXOIZ7cY
         qn7Q==
X-Gm-Message-State: ANhLgQ0d841vUZ8KdNLchKoHDh6t9rf1DoBz6Q1+nKCoeIaRLJAaib5V
        T/3237GaQHN47r2zYgkBctH/RkV1zps=
X-Google-Smtp-Source: ADFU+vsuYP4shgP01AJMsSA06SW7flAqEmfitsM6qWS2i1/dCOLrGVawD9qXHDJnEB0RPXb+eQkcJQ==
X-Received: by 2002:adf:82a6:: with SMTP id 35mr35445699wrc.307.1585035839550;
        Tue, 24 Mar 2020 00:43:59 -0700 (PDT)
Received: from jondnuc.lan (IGLD-84-229-155-229.inter.net.il. [84.229.155.229])
        by smtp.gmail.com with ESMTPSA id r15sm22066122wra.19.2020.03.24.00.43.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 00:43:59 -0700 (PDT)
From:   Jon Doron <arilou@gmail.com>
To:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org
Cc:     vkuznets@redhat.com, Jon Doron <arilou@gmail.com>
Subject: [PATCH v10 2/7] x86/kvm/hyper-v: Simplify addition for custom cpuid leafs
Date:   Tue, 24 Mar 2020 09:43:36 +0200
Message-Id: <20200324074341.1770081-3-arilou@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200324074341.1770081-1-arilou@gmail.com>
References: <20200324074341.1770081-1-arilou@gmail.com>
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
index a86fda7a1d03..5a7336d6b8ca 100644
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
 
 	if (kvm_x86_ops->nested_get_evmcs_version)
 		evmcs_ver = kvm_x86_ops->nested_get_evmcs_version(vcpu);
 
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

