Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD99048E217
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 02:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238638AbiANBVY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jan 2022 20:21:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236016AbiANBVX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jan 2022 20:21:23 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5930C061574
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 17:21:23 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id q185-20020a25d9c2000000b00611ae9c8773so11426317ybg.18
        for <kvm@vger.kernel.org>; Thu, 13 Jan 2022 17:21:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=zBFe43I7VMUTibthY4x93V5uv4KS4bOv3WQS/qIwQ+s=;
        b=VSncwXgfn5xowy0Dp4e/myeTusXVM/+UeJU6TKN8lO5YP7RK6SWKl6v4nQGZa0mwuF
         2xwduYVmq+Pl16D6ornJPap2b4v7FBjPWdid2GtGZE3R7EksXRVO2+w12YqFhF68Vp82
         0XnxLAxYdfLqKaok6v7kGcEZARPJVwSwRjs9rMWuWRkD3MEUuLq/DsSUKLtHIO/4U/T2
         NYM1SGCEP2cNKatL5G/faLAVU9W/m1IIkui3H10OrLoWpGyegi0XPg87rg1Uz9JfWHHa
         iU0CR2ZO2vzP6qxzS8TaHnEmMd212F82m2UkHJgNC6HYItt9UDu/bMkRK5JXHv/poyUb
         BYIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zBFe43I7VMUTibthY4x93V5uv4KS4bOv3WQS/qIwQ+s=;
        b=FGOfY2Dpn9ARCF3I1WaUr4wf7NzYb3l82F3bXakc4IFvlIR6VOUOvgYGMWoqScPs51
         QrIhiwlTBGgWeXaBVmm6jxVrmwXUEm7Gv+YX0UrXUKWxfDuDdZnNvvHwVg00ilNvf5Bd
         aAbfqgl6xWahBO7bFiQh1DY2ICAhTDS4n1o/Qhv9yIyzrtrx7C+3xdpeLtLorRiXWtZr
         b+itGhoFlEXKNoIAdcbFUTVonqy1Yy6xhPEVfHKRvHFOyXPTbgSZJyb5yGnJA+61Mj71
         LnDjgTiBLJTODFv3YBOfPWEospzOQ2kZB9hM42hqTaEWEUxUbTbmJJD10lj0BOVE7Vic
         mSbA==
X-Gm-Message-State: AOAM532gT7wmJBRZnntutVFjveMjVxIoAAy10DDwqtJPUK8AoD4URjeZ
        1jaMe+unJJO4qYITg2aWEjh2VKxtO+xQxsRJVLrRtH2GCor1noDKZdBj4R6w29C5543wcTCtmZn
        qaFeUUzwY9wjF4lUdwtfgEECjOFu58BoM6AdCrXWSqEPqHaHEUyQjIg78XN7WKR0=
X-Google-Smtp-Source: ABdhPJz9m3P9GxdFws+zUokY4fRQYKsdb7HJwuYshDXw/3bZVgEOya+ii6z2GLEN0tVQgeqZQvF2t6WwszyRRA==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a25:1007:: with SMTP id
 7mr9203783ybq.594.1642123282809; Thu, 13 Jan 2022 17:21:22 -0800 (PST)
Date:   Thu, 13 Jan 2022 17:21:06 -0800
In-Reply-To: <20220114012109.153448-1-jmattson@google.com>
Message-Id: <20220114012109.153448-4-jmattson@google.com>
Mime-Version: 1.0
References: <20220114012109.153448-1-jmattson@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [PATCH v2 3/6] selftests: kvm/x86: Introduce is_amd_cpu()
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

