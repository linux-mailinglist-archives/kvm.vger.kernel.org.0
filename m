Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 220DE1E8211
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 17:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbgE2PkM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 11:40:12 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:36191 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728018AbgE2Pjz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 May 2020 11:39:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590766794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hgPoFy52+vPkPxBv+KoenRhs6cvMN/XNodmMkjANQDo=;
        b=gWJbP/YNxtFLRRxSN04udJP9lXUQSISv+Hxsuwfzirfv+67ilx55QxTPwArugu7IOdeGEx
        i8BpZ0yLVwwr/Df15VwS1E6Nfu7anBi8Z+Gaa+f80RxWZrUt4aaWgxWkMZcnx159pWPaCb
        O2hTdGt08lCg2SKd6m4X0shSnaedNVk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-482-OonCHIUqMFKSbV9KDbbnUg-1; Fri, 29 May 2020 11:39:50 -0400
X-MC-Unique: OonCHIUqMFKSbV9KDbbnUg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 96B491005512;
        Fri, 29 May 2020 15:39:49 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3D10C10013C2;
        Fri, 29 May 2020 15:39:49 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH 27/30] selftests: kvm: introduce cpu_has_svm() check
Date:   Fri, 29 May 2020 11:39:31 -0400
Message-Id: <20200529153934.11694-28-pbonzini@redhat.com>
In-Reply-To: <20200529153934.11694-1-pbonzini@redhat.com>
References: <20200529153934.11694-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

Many tests will want to check if the CPU is Intel or AMD in
guest code, add cpu_has_svm() and put it as static
inline to svm_util.h.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Message-Id: <20200529130407.57176-1-vkuznets@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 tools/testing/selftests/kvm/include/x86_64/svm_util.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

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
+	asm("cpuid" :
+	    "=a" (eax), "=c" (ecx) : "0" (eax) : "ebx", "edx");
+
+	return ecx & CPUID_SVM;
+}
+
 #endif /* SELFTEST_KVM_SVM_UTILS_H */
-- 
2.26.2


