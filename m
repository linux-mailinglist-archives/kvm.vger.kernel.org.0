Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94A84533971
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 11:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234847AbiEYJGz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 05:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242769AbiEYJFs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 05:05:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 762EFA3396
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 02:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653469356;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O2ns/abyGGY2lUHqvbl8bWjfPO/YjY8976ue1eurT7I=;
        b=imsWsnVFca+8sDS3FS4YypsO+5ynNp/i7pyVW4FD8xHNJBC2vktCppI4kc0zWUrecsc6ti
        9MPv2CUI+65TWRZXo0FprTOG+8HY4gqVcOOiMB0ZFGaBDUwcnqcWZGkYbYUzT80UFAAJDj
        N6Wg4IAf0CjV1n44oKM7ncm5eZmgzeY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-653-YfjjwJiIMdqBzf6BKBQNIg-1; Wed, 25 May 2022 05:02:29 -0400
X-MC-Unique: YfjjwJiIMdqBzf6BKBQNIg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F404F2999B56;
        Wed, 25 May 2022 09:02:28 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.186])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 252E2405D4BF;
        Wed, 25 May 2022 09:02:27 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 25/37] KVM: selftests: Move the function doing Hyper-V hypercall to a common header
Date:   Wed, 25 May 2022 11:01:21 +0200
Message-Id: <20220525090133.1264239-26-vkuznets@redhat.com>
In-Reply-To: <20220525090133.1264239-1-vkuznets@redhat.com>
References: <20220525090133.1264239-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

All Hyper-V specific tests issuing hypercalls need this.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../selftests/kvm/include/x86_64/hyperv.h       | 15 +++++++++++++++
 .../selftests/kvm/x86_64/hyperv_features.c      | 17 +----------------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/hyperv.h b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
index f0a8a93694b2..e0a1b4c2fbbc 100644
--- a/tools/testing/selftests/kvm/include/x86_64/hyperv.h
+++ b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
@@ -185,6 +185,21 @@
 /* hypercall options */
 #define HV_HYPERCALL_FAST_BIT		BIT(16)
 
+static inline u64 hyperv_hypercall(u64 control, vm_vaddr_t input_address,
+			   vm_vaddr_t output_address)
+{
+	u64 hv_status;
+
+	asm volatile("mov %3, %%r8\n"
+		     "vmcall"
+		     : "=a" (hv_status),
+		       "+c" (control), "+d" (input_address)
+		     :  "r" (output_address)
+		     : "cc", "memory", "r8", "r9", "r10", "r11");
+
+	return hv_status;
+}
+
 /* Proper HV_X64_MSR_GUEST_OS_ID value */
 #define HYPERV_LINUX_OS_ID ((u64)0x8100 << 48)
 
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
index 98c020356925..788d570e991e 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
@@ -48,21 +48,6 @@ static void do_wrmsr(u32 idx, u64 val)
 static int nr_gp;
 static int nr_ud;
 
-static inline u64 hypercall(u64 control, vm_vaddr_t input_address,
-			    vm_vaddr_t output_address)
-{
-	u64 hv_status;
-
-	asm volatile("mov %3, %%r8\n"
-		     "vmcall"
-		     : "=a" (hv_status),
-		       "+c" (control), "+d" (input_address)
-		     :  "r" (output_address)
-		     : "cc", "memory", "r8", "r9", "r10", "r11");
-
-	return hv_status;
-}
-
 static void guest_gp_handler(struct ex_regs *regs)
 {
 	unsigned char *rip = (unsigned char *)regs->rip;
@@ -138,7 +123,7 @@ static void guest_hcall(vm_vaddr_t pgs_gpa, struct hcall_data *hcall)
 			input = output = 0;
 		}
 
-		res = hypercall(hcall->control, input, output);
+		res = hyperv_hypercall(hcall->control, input, output);
 		if (hcall->ud_expected)
 			GUEST_ASSERT(nr_ud == 1);
 		else
-- 
2.35.3

