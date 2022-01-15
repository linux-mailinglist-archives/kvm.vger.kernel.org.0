Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8273B48F4EF
	for <lists+kvm@lfdr.de>; Sat, 15 Jan 2022 06:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbiAOFYw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 15 Jan 2022 00:24:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231133AbiAOFYs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 15 Jan 2022 00:24:48 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C258DC061574
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 21:24:47 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id x22-20020a056a00189600b004be094fc848so3092577pfh.8
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 21:24:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=zBFe43I7VMUTibthY4x93V5uv4KS4bOv3WQS/qIwQ+s=;
        b=g+01sf9m9Ulf4f9Ttb+9XlFbl8Sodw80/7GtXlkbj2uTiJ8HrUEVxUDhfiiBm6mv4r
         pBWcUvQLwJ4qPtlbEzIMK1294MKn+wHj4OdQ/TzydNiAMGQD7ejl+GVeinCce+G4LaDq
         coDW4Wqhfj8nsE9E0XQcxqcJSNT8+vaH0AMh0TwvJsSDd1HrSh1K+qFTyXI/1ggUs8Vb
         rK3Yr811VdIwLm4f4q0qbFWFGrbQDoW9WA+asutxRIa0lKWfTOlrHkXAS9v9es599NL8
         HIWaoVCndQTqdK7Qq5zrRg8ofDCR8FNi7xO+PsWm/O45ipdBtdrtYqXPSTgefagFg4kX
         94rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zBFe43I7VMUTibthY4x93V5uv4KS4bOv3WQS/qIwQ+s=;
        b=aUIgT2UkIMRtY20eirMOhOsOUTLs53OCpzj2KL+PZNqpNUbVzQh/S/mqhwVDv3AcOh
         bXZ3JncLgJM+nm/SLPnu52S75rkndy7HcPlaE1LqInIXb0e+UgVVW3B2rRtyWpzU2nYI
         B3BJJzjH4SAcyAl9FJKLKw6VuhSOep/dW8uShqAJkJcvrhRk5Oi1n9pbuibDbc4fx1v9
         vBqxHWGTiPexEQI4S5QA9HMZA4Yt6ZHbri4P6n9diOQJWYta5P1Q5ZRVqQ2Brlb4RRZI
         8TpZQVH5gmkaEhVTma22hfeRny2E+dcJw8PNvJ7aTu0FaIA6XY6A+KY1+lYk4Cp39Gsn
         p8Jg==
X-Gm-Message-State: AOAM531JaozjdomXtBzp/qWh4J3qKFJdjIlBVxpGaSrdwWbU4vffITc6
        LYyUzBQtdWHNX+hQAll7iMj61m7qQenhH1M5HpaOQxhdrbPUBMiF1OMQmm+pSu+kYfAhRRjyA7K
        FNdaEz9BI2rghb/mIDJg+MZLrljxengK4FTGh1ogQnoVu09w6kuaJGlavtbZK1Yc=
X-Google-Smtp-Source: ABdhPJysyencEQP3Ym1KkF2SLpCNbJ7Qtv7a3Wex8YFd/yFuBB0ViKgRB3jSU4Vrvzflp0bHE3CgapKDBrbOYw==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a17:90a:680a:: with SMTP id
 p10mr14140149pjj.144.1642224287156; Fri, 14 Jan 2022 21:24:47 -0800 (PST)
Date:   Fri, 14 Jan 2022 21:24:28 -0800
In-Reply-To: <20220115052431.447232-1-jmattson@google.com>
Message-Id: <20220115052431.447232-4-jmattson@google.com>
Mime-Version: 1.0
References: <20220115052431.447232-1-jmattson@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH v3 3/6] selftests: kvm/x86: Introduce is_amd_cpu()
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com, like.xu.linux@gmail.com,
        daviddunn@google.com, cloudliang@tencent.com
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace the one ad hoc "AuthenticAMD" CPUID vendor string comparison
with a new function, is_amd_cpu().

Signed-off-by: Jim Mattson <jmattson@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h   |  1 +
 .../selftests/kvm/lib/x86_64/processor.c       | 18 +++++++++---------
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 05e65ca1c30c..69eaf9a69bb7 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -347,6 +347,7 @@ static inline unsigned long get_xmm(int n)
 }
 
 bool is_intel_cpu(void);
+bool is_amd_cpu(void);
 
 struct kvm_x86_state;
 struct kvm_x86_state *vcpu_save_state(struct kvm_vm *vm, uint32_t vcpuid);
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 355a3f6f1970..b969e38bc02e 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1218,6 +1218,14 @@ bool is_intel_cpu(void)
 	return cpu_vendor_string_is("GenuineIntel");
 }
 
+/*
+ * Exclude early K5 samples with a vendor string of "AMDisbetter!"
+ */
+bool is_amd_cpu(void)
+{
+	return cpu_vendor_string_is("AuthenticAMD");
+}
+
 uint32_t kvm_get_cpuid_max_basic(void)
 {
 	return kvm_get_supported_cpuid_entry(0)->eax;
@@ -1436,10 +1444,6 @@ struct kvm_cpuid2 *vcpu_get_supported_hv_cpuid(struct kvm_vm *vm, uint32_t vcpui
 	return cpuid;
 }
 
-#define X86EMUL_CPUID_VENDOR_AuthenticAMD_ebx 0x68747541
-#define X86EMUL_CPUID_VENDOR_AuthenticAMD_ecx 0x444d4163
-#define X86EMUL_CPUID_VENDOR_AuthenticAMD_edx 0x69746e65
-
 static inline unsigned x86_family(unsigned int eax)
 {
         unsigned int x86;
@@ -1461,11 +1465,7 @@ unsigned long vm_compute_max_gfn(struct kvm_vm *vm)
 	max_gfn = (1ULL << (vm->pa_bits - vm->page_shift)) - 1;
 
 	/* Avoid reserved HyperTransport region on AMD processors.  */
-	eax = ecx = 0;
-	cpuid(&eax, &ebx, &ecx, &edx);
-	if (ebx != X86EMUL_CPUID_VENDOR_AuthenticAMD_ebx ||
-	    ecx != X86EMUL_CPUID_VENDOR_AuthenticAMD_ecx ||
-	    edx != X86EMUL_CPUID_VENDOR_AuthenticAMD_edx)
+	if (!is_amd_cpu())
 		return max_gfn;
 
 	/* On parts with <40 physical address bits, the area is fully hidden */
-- 
2.34.1.703.g22d0c6ccf7-goog

