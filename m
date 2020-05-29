Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5F71E7DCA
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 15:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgE2NER (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 09:04:17 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40173 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726467AbgE2NEQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 09:04:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590757455;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=NCNyaN4EF9S3QJCaspYw1c/k/yvFSDNyMWE1gpjKqBg=;
        b=d90acfDQ8fgJZ2I5aBvWBxtFKLVsSzP3sJq69iKlaaQoBjtDKd0immbFmKS9OfJroDxI5r
        XbxAHaqQIZAvAuqjAzgomrO1ec4VsqnIlg4f5rKmTEa7XLbMhts5gpY5vpP+1h3ocvBi6p
        e0oX0xExoK5pc88ou1J4cGODK6mmM8k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-477-C8NwSG5jPjutXSLASIAP7Q-1; Fri, 29 May 2020 09:04:11 -0400
X-MC-Unique: C8NwSG5jPjutXSLASIAP7Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 680711054F91;
        Fri, 29 May 2020 13:04:10 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.194.122])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5C0925D9D5;
        Fri, 29 May 2020 13:04:08 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 1/2] selftests: kvm: introduce cpu_has_svm() check
Date:   Fri, 29 May 2020 15:04:06 +0200
Message-Id: <20200529130407.57176-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

More tests may want to check if the CPU is Intel or AMD in
guest code, separate cpu_has_svm() and put it as static
inline to svm_util.h.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/include/x86_64/svm_util.h | 10 ++++++++++
 tools/testing/selftests/kvm/x86_64/state_test.c       |  9 +--------
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/svm_util.h b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
index cd037917fece..b1057773206a 100644
--- a/tools/testing/selftests/kvm/include/x86_64/svm_util.h
+++ b/tools/testing/selftests/kvm/include/x86_64/svm_util.h
@@ -35,4 +35,14 @@ void generic_svm_setup(struct svm_test_data *svm, void *guest_rip, void *guest_r
 void run_guest(struct vmcb *vmcb, uint64_t vmcb_gpa);
 void nested_svm_check_supported(void);
 
+static inline bool cpu_has_svm(void)
+{
+	u32 eax = 0x80000001, ecx;
+
+	asm volatile("cpuid" :
+		     "=a" (eax), "=c" (ecx) : "0" (eax) : "ebx", "edx");
+
+	return ecx & CPUID_SVM;
+}
+
 #endif /* SELFTEST_KVM_SVM_UTILS_H */
diff --git a/tools/testing/selftests/kvm/x86_64/state_test.c b/tools/testing/selftests/kvm/x86_64/state_test.c
index af8b6df6a13e..d43b6f99b66c 100644
--- a/tools/testing/selftests/kvm/x86_64/state_test.c
+++ b/tools/testing/selftests/kvm/x86_64/state_test.c
@@ -137,20 +137,13 @@ static void vmx_l1_guest_code(struct vmx_pages *vmx_pages)
 	GUEST_ASSERT(vmresume());
 }
 
-static u32 cpuid_ecx(u32 eax)
-{
-	u32 ecx;
-	asm volatile("cpuid" : "=a" (eax), "=c" (ecx) : "0" (eax) : "ebx", "edx");
-	return ecx;
-}
-
 static void __attribute__((__flatten__)) guest_code(void *arg)
 {
 	GUEST_SYNC(1);
 	GUEST_SYNC(2);
 
 	if (arg) {
-		if (cpuid_ecx(0x80000001) & CPUID_SVM)
+		if (cpu_has_svm())
 			svm_l1_guest_code(arg);
 		else
 			vmx_l1_guest_code(arg);
-- 
2.25.4

