Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61FDA494AF4
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 10:42:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359604AbiATJl7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 04:41:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiATJl7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jan 2022 04:41:59 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C965C061574;
        Thu, 20 Jan 2022 01:41:59 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id q75so5123185pgq.5;
        Thu, 20 Jan 2022 01:41:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=od5lEluMiGvBUjmC4y/AtLj9FnkbJ2imydvHba8V9xo=;
        b=C1km0VG/pH//jLQuXC20a2R3wRb4D+dYENZXr9lnf5mT+cUYEkevy820XidXfr5Gnq
         Nv5cfdod5AqC+R1OaHCApj6XjDIDB0RiYQhB1H3jPzRcfUllkMTk+hiUdvawmNUtsZas
         AbVz2ZQFCsskgeipf6MG8pGmXmCfZncQslymqfZDAmkU6WyMGjbuxMYpEW/bSjIF79rc
         jFkFqk79ra1SWyabnTNfPPJOiAzYwoaI1geXc4QWwcbRGRf7b6RFbuXN8KFlRAQJRaxP
         NC2yXs+xdH9uKekso56PSD3sr6oMKw5zkTKuDy4zMtlj1k7xcYqAWk1zbRM8ZyT3B+uF
         EsSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=od5lEluMiGvBUjmC4y/AtLj9FnkbJ2imydvHba8V9xo=;
        b=rbQxHOM91nM6nEPVS3y0gtcJ1iHchUC40PUw8H/MwZtrXKL9t5sisoacybdbkpaK0m
         Kg7lMbWBrVrFBTHXzIt2W35S0okrGvueFWe26D4txlzKrzKD4Tm4p6/QtTyg9PAGhmZd
         O3WQ6zTt9pAR/TMZZRc0LUazqlEwV1tf0SdBwfKkIr1Fd12vvWnAFjuidfzFa9FEGsjj
         eNO/tRq0ix+ReX+GuUjk9xJEgCMz0KnQpWihCXxUxGOFX8BCtC5aGpG1fwkQdRNnW4aR
         do5EDgkOX6+YagZ/ZaUBKme6mMRmKqnMw0Q9kv8bOEk+igxEa+anfzKWcHYCwadyyd4D
         LOLA==
X-Gm-Message-State: AOAM533Ga6l0G94W+xzWx8hU8LBWhILqXhV7meT6WsPMPm+/xS8yAs+R
        yNUnKtIcUO+uEqqDM+2ws5U=
X-Google-Smtp-Source: ABdhPJw2NIBuh+JBCdphWcJLkjEVQFv/pHmY5GECLaJLfv1/EA6mDX5dpYukkkvFnigO43qosn29BA==
X-Received: by 2002:a05:6a00:2410:b0:4bc:dda9:2e92 with SMTP id z16-20020a056a00241000b004bcdda92e92mr34645915pfh.76.1642671717965;
        Thu, 20 Jan 2022 01:41:57 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id u9sm2745790pfi.14.2022.01.20.01.41.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 01:41:57 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] selftests: kvm/x86: Check if cpuid_d_0_ebx follows XCR0 value change
Date:   Thu, 20 Jan 2022 17:41:46 +0800
Message-Id: <20220120094146.66525-1-likexu@tencent.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Intel SDM says the CPUID.0xd.EBX reports the maximum size required by
enabled features in XCR0. Add a simple test that writes two different
non #GP values via  __xsetbv() and verify that the cpuid data is updated.

Opportunistically, move the __x{s,g}etbv helpers  to the x86_64/processor.h

Signed-off-by: Like Xu <likexu@tencent.com>
---
Related link: https://lore.kernel.org/kvm/20220119070427.33801-1-likexu@tencent.com/

 .../selftests/kvm/include/x86_64/processor.h  | 18 ++++++++++
 tools/testing/selftests/kvm/x86_64/amx_test.c | 18 ----------
 .../testing/selftests/kvm/x86_64/cpuid_test.c | 34 +++++++++++++++++--
 3 files changed, 49 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 122447827954..65097ca6d7b2 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -296,6 +296,24 @@ static inline void cpuid(uint32_t *eax, uint32_t *ebx,
 	    : "memory");
 }
 
+static inline u64 __xgetbv(u32 index)
+{
+	u32 eax, edx;
+
+	asm volatile("xgetbv;"
+		     : "=a" (eax), "=d" (edx)
+		     : "c" (index));
+	return eax + ((u64)edx << 32);
+}
+
+static inline void __xsetbv(u32 index, u64 value)
+{
+	u32 eax = value;
+	u32 edx = value >> 32;
+
+	asm volatile("xsetbv" :: "a" (eax), "d" (edx), "c" (index));
+}
+
 #define SET_XMM(__var, __xmm) \
 	asm volatile("movq %0, %%"#__xmm : : "r"(__var) : #__xmm)
 
diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c b/tools/testing/selftests/kvm/x86_64/amx_test.c
index 523c1e99ed64..c3cbb2dc450d 100644
--- a/tools/testing/selftests/kvm/x86_64/amx_test.c
+++ b/tools/testing/selftests/kvm/x86_64/amx_test.c
@@ -78,24 +78,6 @@ struct xtile_info {
 
 static struct xtile_info xtile;
 
-static inline u64 __xgetbv(u32 index)
-{
-	u32 eax, edx;
-
-	asm volatile("xgetbv;"
-		     : "=a" (eax), "=d" (edx)
-		     : "c" (index));
-	return eax + ((u64)edx << 32);
-}
-
-static inline void __xsetbv(u32 index, u64 value)
-{
-	u32 eax = value;
-	u32 edx = value >> 32;
-
-	asm volatile("xsetbv" :: "a" (eax), "d" (edx), "c" (index));
-}
-
 static inline void __ldtilecfg(void *cfg)
 {
 	asm volatile(".byte 0xc4,0xe2,0x78,0x49,0x00"
diff --git a/tools/testing/selftests/kvm/x86_64/cpuid_test.c b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
index 16d2465c5634..169ec54a928c 100644
--- a/tools/testing/selftests/kvm/x86_64/cpuid_test.c
+++ b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
@@ -20,8 +20,7 @@ struct {
 	u32 index;
 } mangled_cpuids[] = {
 	/*
-	 * These entries depend on the vCPU's XCR0 register and IA32_XSS MSR,
-	 * which are not controlled for by this test.
+	 * These entries depend on the vCPU's XCR0 register and IA32_XSS MSR.
 	 */
 	{.function = 0xd, .index = 0},
 	{.function = 0xd, .index = 1},
@@ -55,6 +54,31 @@ static void test_cpuid_40000000(struct kvm_cpuid2 *guest_cpuid)
 	GUEST_ASSERT(eax == 0x40000001);
 }
 
+static void test_cpuid_d(struct kvm_cpuid2 *guest_cpuid)
+{
+	uint64_t cr4;
+	u32 eax, ebx, ecx, edx;
+	u32 before, after;
+
+	cr4 = get_cr4();
+	cr4 |= X86_CR4_OSXSAVE;
+	set_cr4(cr4);
+
+	__xsetbv(0x0, 0x1);
+	eax = 0xd;
+	ebx = ecx = edx = 0;
+	cpuid(&eax, &ebx, &ecx, &edx);
+	before = ebx;
+
+	__xsetbv(0x0, 0x3);
+	eax = 0xd;
+	ebx = ecx = edx = 0;
+	cpuid(&eax, &ebx, &ecx, &edx);
+	after = ebx;
+
+	GUEST_ASSERT(before != after);
+}
+
 static void guest_main(struct kvm_cpuid2 *guest_cpuid)
 {
 	GUEST_SYNC(1);
@@ -65,6 +89,10 @@ static void guest_main(struct kvm_cpuid2 *guest_cpuid)
 
 	test_cpuid_40000000(guest_cpuid);
 
+	GUEST_SYNC(3);
+
+	test_cpuid_d(guest_cpuid);
+
 	GUEST_DONE();
 }
 
@@ -200,7 +228,7 @@ int main(void)
 
 	vcpu_args_set(vm, VCPU_ID, 1, cpuid_gva);
 
-	for (stage = 0; stage < 3; stage++)
+	for (stage = 0; stage < 4; stage++)
 		run_vcpu(vm, VCPU_ID, stage);
 
 	set_cpuid_after_run(vm, cpuid2);
-- 
2.33.1

