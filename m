Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB19C5B9170
	for <lists+kvm@lfdr.de>; Thu, 15 Sep 2022 02:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbiIOAFQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Sep 2022 20:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbiIOAFH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Sep 2022 20:05:07 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E229713EA7
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 17:05:01 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id g63-20020a636b42000000b004305794e112so8192081pgc.20
        for <kvm@vger.kernel.org>; Wed, 14 Sep 2022 17:05:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date;
        bh=rhI1CHpHnoLTF9sMnY1velsatE7KzqpaHm2Zg/NlpWU=;
        b=csQ+wHtL/4fYR6KUnDudrTc0f7rZcbdEOOHzeTVhZIgqP16I2UHMCa4nKJvwkDmIa1
         04EiDNsGGYsa/ZoenTCo4pyTo5zKHaBi91efe9OaAlNaRgO+snXtratc/rVMkxsvUMAp
         31VMO3yfzfh6Cm4pENS/+J5g+8gNzyc0ln9enq47YOyqB9UBPrN61cTtiZFrII4Zm9dK
         uveTLe0u+t73xwiUy8LdyI3z8CSL2y+7uHVWryjbrvAmMzs+ImrIt3aSe3KOP9StVKdb
         rd0EjF6Ab8sNMS2PV4Ir+kXJLtvty5YMcWkjdEe9vCJ0JX+Qgw9g7PeYKlpbOg1nAy/X
         0K0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date;
        bh=rhI1CHpHnoLTF9sMnY1velsatE7KzqpaHm2Zg/NlpWU=;
        b=y7+rfZaofw/rFpTWTo0/XBiEFeJ6hu/EqGInFUIB+ehuAcbVcYbwi0y76kx+34Ns/h
         YV0TutNkynfBOKFWUBN5+w3mYL1MfT4CnJaI0MCwsc23psDTZqiOx7vPQtYTDrZqLO+f
         gCVYHYZHEJMjdkvxP1ZunHVmNsbRb6wVrTkn7w8Y1xp6Sn78gAdK3evro8OWsFEOR4v1
         BmFIGjyWzMilIheXvGx9cYerxacPo5s+3LzfJFLicoal+2/3FsIu3hz9Ci6+WT+6vb7X
         wklLUG+yzH6OhTUR2UrViizrrjsnIbnpRc0gImYAjzQnXbBDlnE8L3UwjaoJ9ovGDCEs
         T3gw==
X-Gm-Message-State: ACgBeo1apOi6ZwstG14eI6z58B+36+p4xQWFsbXqBlT7S2My0hSfeHIO
        S4PgabHkAk/j1kN7/srWD2h3GYvk7mQnTHuQ
X-Google-Smtp-Source: AA6agR4J+7XJTDvy3acXZ7Xp5xXcYKJyhmTX7ZLEn97ViM70m/5htdtIvuFapGYGrwQDbuzUWFwXekmcH4/ukG+F
X-Received: from vannapurve2.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:41f8])
 (user=vannapurve job=sendgmr) by 2002:a62:170b:0:b0:53b:93dc:966b with SMTP
 id 11-20020a62170b000000b0053b93dc966bmr40331680pfx.29.1663200301099; Wed, 14
 Sep 2022 17:05:01 -0700 (PDT)
Date:   Thu, 15 Sep 2022 00:04:44 +0000
In-Reply-To: <20220915000448.1674802-1-vannapurve@google.com>
Mime-Version: 1.0
References: <20220915000448.1674802-1-vannapurve@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220915000448.1674802-5-vannapurve@google.com>
Subject: [V2 PATCH 4/8] KVM: selftests: x86: Precompute the result for is_{intel,amd}_cpu()
From:   Vishal Annapurve <vannapurve@google.com>
To:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc:     pbonzini@redhat.com, shuah@kernel.org, bgardon@google.com,
        seanjc@google.com, oupton@google.com, peterx@redhat.com,
        vkuznets@redhat.com, dmatlack@google.com,
        Vishal Annapurve <vannapurve@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Cache the vendor CPU type in a global variable so that multiple calls
to is_intel_cpu() do not need to re-execute CPUID.

Add cpu vendor check in kvm_hypercall() so that it executes correct
vmcall/vmmcall instruction when running on Intel/AMD hosts. This avoids
exit to KVM which anyway tries to patch the instruction according to
the cpu type.

As part of this change, sync the global variable is_cpu_amd into the
guest so the guest can determine which hypercall instruction to use
without needing to re-execute CPUID for every hypercall.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Vishal Annapurve <vannapurve@google.com>
---
 .../testing/selftests/kvm/lib/x86_64/processor.c  | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 25ae972f5c71..c0ae938772f6 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -19,6 +19,7 @@
 #define MAX_NR_CPUID_ENTRIES 100
 
 vm_vaddr_t exception_handlers;
+static bool is_cpu_amd;
 
 static void regs_dump(FILE *stream, struct kvm_regs *regs, uint8_t indent)
 {
@@ -1019,7 +1020,7 @@ static bool cpu_vendor_string_is(const char *vendor)
 
 bool is_intel_cpu(void)
 {
-	return cpu_vendor_string_is("GenuineIntel");
+	return (is_cpu_amd == false);
 }
 
 /*
@@ -1027,7 +1028,7 @@ bool is_intel_cpu(void)
  */
 bool is_amd_cpu(void)
 {
-	return cpu_vendor_string_is("AuthenticAMD");
+	return (is_cpu_amd == true);
 }
 
 void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits)
@@ -1182,9 +1183,15 @@ uint64_t kvm_hypercall(uint64_t nr, uint64_t a0, uint64_t a1, uint64_t a2,
 {
 	uint64_t r;
 
-	asm volatile("vmcall"
+	if (is_amd_cpu())
+		asm volatile("vmmcall"
 		     : "=a"(r)
 		     : "a"(nr), "b"(a0), "c"(a1), "d"(a2), "S"(a3));
+	else
+		asm volatile("vmcall"
+		     : "=a"(r)
+		     : "a"(nr), "b"(a0), "c"(a1), "d"(a2), "S"(a3));
+
 	return r;
 }
 
@@ -1314,8 +1321,10 @@ bool vm_is_unrestricted_guest(struct kvm_vm *vm)
 
 void kvm_selftest_arch_init(void)
 {
+	is_cpu_amd = cpu_vendor_string_is("AuthenticAMD");
 }
 
 void kvm_arch_post_vm_elf_load(struct kvm_vm *vm)
 {
+	sync_global_to_guest(vm, is_cpu_amd);
 }
-- 
2.37.2.789.g6183377224-goog

