Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1C3494D5A
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 12:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232035AbiATLsc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jan 2022 06:48:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231245AbiATLsc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jan 2022 06:48:32 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB86C061574;
        Thu, 20 Jan 2022 03:48:32 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id n11so4997155plf.4;
        Thu, 20 Jan 2022 03:48:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:organization:in-reply-to
         :content-transfer-encoding;
        bh=seC6Kkrfn03WWvAoxpMMD58mY5Lutg3rpLxG7Rxl/FQ=;
        b=TWO2HWgjV5q3GaiSxIWxH0m/RaKLojeMeam3x7qU1ne7cPjrM2pyqnaYAN9E3LGqVU
         mHgWmJpX5sGYjqkfnPFDb3N4s88R07ao2huReJV+p1F3s8b+daKAXl6c4YwG8YqF4CVO
         8W+4020XryGs/4pVgwSOcMHN/PeapfSZqFF2A3njKlMxt+CIyWP7eA3n4zrqn3p65p9M
         eUaDzaZ1xa1EP4i9V+7BIR1AOybumKh8bNZSh6OMrigM3nSFDZ6uIx0+tHSNEnsCgksQ
         uMeDY1TKV7MY3Lt8r5o2BPwpmDUcozuROzD4jDXD2g95U0OC9KyhSD4bxFI5fDJ8lTcg
         erYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:organization:in-reply-to
         :content-transfer-encoding;
        bh=seC6Kkrfn03WWvAoxpMMD58mY5Lutg3rpLxG7Rxl/FQ=;
        b=BRho1ygiIArIFQuPoymdUQNir3jxvbJUn3b8e93kcPCLZrV4WEKE5AZVHAGuK8fBOX
         tFlKUWrBMY1Zpe3aw63RvEAZy1YjX45pEBF9POpdxczK7I75PipaaQgtRPxZC+O4B3Sk
         PCjUIMXJihEoXlDXwDGvgy5Sj6dlZFIQsaOeD73COT1uzJNAE9LTfo2Gtnbs/nWQ27IW
         e72kEYIfH9EO6gB+vb0Df2MldcfKVmUIJdjoZs8W5Zmzo2xFarARYtc/RKGdxGaNnwbr
         +IUXVm2gNw0Uv8UXvfX0GxeymLwPAbu83TzzbK7QrpdG8/olDWTP6espgy+KAXz0CfNo
         jMTg==
X-Gm-Message-State: AOAM5339f6Y+JTtmIGOseZPrmQodcui/XsjKCP2tn51KjGmQJ9H5adzb
        uBurCJZoS0JIriQ6oOWjvVM=
X-Google-Smtp-Source: ABdhPJxWML/DjpeeXhldOLuh4tbwmdxnolJz4O/r5vj1pmZ0N5mbOQGKT9nCjFPvyWcT+ZW05ZlGzg==
X-Received: by 2002:a17:90a:6409:: with SMTP id g9mr10319630pjj.108.1642679311673;
        Thu, 20 Jan 2022 03:48:31 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id r11sm3264966pff.81.2022.01.20.03.48.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jan 2022 03:48:31 -0800 (PST)
Message-ID: <885b4ace-42b5-824e-8e7c-a41c3e9fc514@gmail.com>
Date:   Thu, 20 Jan 2022 19:48:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: [PATCH v2] selftests: kvm/x86: Check if cpuid_d_0_ebx follows XCR0
 value change
Content-Language: en-US
From:   Like Xu <like.xu.linux@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220120094146.66525-1-likexu@tencent.com>
Organization: Tencent
In-Reply-To: <20220120094146.66525-1-likexu@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

Intel SDM says the CPUID.0xd.EBX reports the maximum size required by
enabled features in XCR0. Add a simple test that writes two different
non #GP values via  __xsetbv() and verify that the cpuid data is updated.

The oddity thing is that CPUID[0d, 00].ebx doesn't enumerate the
XFEATURE_SSE size if only set bits 0 and 1:

  XCR0 = 001B, ebx=00000240
  XCR0 = 011B, ebx=00000240
  XCR0 = 111B, ebx=00000340

Opportunistically, move the __x{s,g}etbv helpers  to the x86_64/processor.h

Signed-off-by: Like Xu <likexu@tencent.com>
---
  .../selftests/kvm/include/x86_64/processor.h  | 18 +++++++++
  tools/testing/selftests/kvm/x86_64/amx_test.c | 18 ---------
  .../testing/selftests/kvm/x86_64/cpuid_test.c | 40 +++++++++++++++++--
  3 files changed, 55 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h 
b/tools/testing/selftests/kvm/include/x86_64/processor.h
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

diff --git a/tools/testing/selftests/kvm/x86_64/amx_test.c 
b/tools/testing/selftests/kvm/x86_64/amx_test.c
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
diff --git a/tools/testing/selftests/kvm/x86_64/cpuid_test.c 
b/tools/testing/selftests/kvm/x86_64/cpuid_test.c
index 16d2465c5634..6f280a12b849 100644
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
@@ -55,6 +54,37 @@ static void test_cpuid_40000000(struct kvm_cpuid2 *guest_cpuid)
  	GUEST_ASSERT(eax == 0x40000001);
  }

+static void test_cpuid_d(struct kvm_cpuid2 *guest_cpuid)
+{
+	uint64_t cr4;
+	u32 eax, ebx, ecx, edx;
+	u32 size001, size011, size111;
+
+	cr4 = get_cr4();
+	cr4 |= X86_CR4_OSXSAVE;
+	set_cr4(cr4);
+
+	__xsetbv(0x0, 0x1);
+	eax = 0xd;
+	ebx = ecx = edx = 0;
+	cpuid(&eax, &ebx, &ecx, &edx);
+	size001 = ebx;
+
+	__xsetbv(0x0, 0x7);
+	eax = 0xd;
+	ebx = ecx = edx = 0;
+	cpuid(&eax, &ebx, &ecx, &edx);
+	size111 = ebx;
+
+	__xsetbv(0x0, 0x3);
+	eax = 0xd;
+	ebx = ecx = edx = 0;
+	cpuid(&eax, &ebx, &ecx, &edx);
+	size011 = ebx;
+
+	GUEST_ASSERT(size001 == size011 && size011 != size111);
+}
+
  static void guest_main(struct kvm_cpuid2 *guest_cpuid)
  {
  	GUEST_SYNC(1);
@@ -65,6 +95,10 @@ static void guest_main(struct kvm_cpuid2 *guest_cpuid)

  	test_cpuid_40000000(guest_cpuid);

+	GUEST_SYNC(3);
+
+	test_cpuid_d(guest_cpuid);
+
  	GUEST_DONE();
  }

@@ -200,7 +234,7 @@ int main(void)

  	vcpu_args_set(vm, VCPU_ID, 1, cpuid_gva);

-	for (stage = 0; stage < 3; stage++)
+	for (stage = 0; stage < 4; stage++)
  		run_vcpu(vm, VCPU_ID, stage);

  	set_cpuid_after_run(vm, cpuid2);
-- 
2.33.1


