Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D98ED358258
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 13:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbhDHLoX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 07:44:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35883 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229837AbhDHLoV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 8 Apr 2021 07:44:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617882249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nYGtSBURRU7WTSXl83fHRTlB7M6uxRtcmancVGQ+Jas=;
        b=TQD6blYOquErlYrV4vUzWyitqf58pz/aw9vtnk8TLYHB9KJInpymY2zTvXxvOff8TjkiVs
        upqwrajUEzRyp6tCUqOJdk937GT+bdQMbKnkBWB/G+qiI/z9LCZKXw5OjpYR3pL50jQTd+
        c9jcnkvmhSD38JZn1R5r+WRBU4T45Tg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-444-d7Y0XKD6PneSx2FsHBUBHQ-1; Thu, 08 Apr 2021 07:44:08 -0400
X-MC-Unique: d7Y0XKD6PneSx2FsHBUBHQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E76AD188352D;
        Thu,  8 Apr 2021 11:44:06 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-113-155.ams2.redhat.com [10.36.113.155])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 314A119CB4;
        Thu,  8 Apr 2021 11:43:49 +0000 (UTC)
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>,
        Alexander Graf <graf@amazon.com>,
        Andrew Jones <drjones@redhat.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [PATCH v4 3/4] selftests: add kvm_get_emulated_cpuid to processor.h
Date:   Thu,  8 Apr 2021 13:43:02 +0200
Message-Id: <20210408114303.30310-4-eesposit@redhat.com>
In-Reply-To: <20210408114303.30310-1-eesposit@redhat.com>
References: <20210408114303.30310-1-eesposit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

As the similar kvm_get_supported_cpuid(),
kvm_get_emulated_cpuid  allocates and gets
a struct kvm_cpuid2 filled with emulated features.

Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
---
 .../selftests/kvm/include/x86_64/processor.h  |  1 +
 .../selftests/kvm/lib/x86_64/processor.c      | 33 +++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 0b30b4e15c38..ae1b9530e187 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -353,6 +353,7 @@ void vcpu_load_state(struct kvm_vm *vm, uint32_t vcpuid,
 struct kvm_msr_list *kvm_get_msr_index_list(void);
 uint64_t kvm_get_feature_msr(uint64_t msr_index);
 struct kvm_cpuid2 *kvm_get_supported_cpuid(void);
+struct kvm_cpuid2 *kvm_get_emulated_cpuid(void);
 
 struct kvm_cpuid2 *vcpu_get_cpuid(struct kvm_vm *vm, uint32_t vcpuid);
 void vcpu_set_cpuid(struct kvm_vm *vm, uint32_t vcpuid,
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index e676fe40bfe6..2ea14421bdfe 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -669,6 +669,39 @@ struct kvm_cpuid2 *kvm_get_supported_cpuid(void)
 	return cpuid;
 }
 
+/*
+ * KVM Emulated CPUID Get
+ *
+ * Input Args: None
+ *
+ * Output Args:
+ *
+ * Return: The emulated KVM CPUID
+ *
+ * Get the guest CPUID emulated by KVM.
+ */
+struct kvm_cpuid2 *kvm_get_emulated_cpuid(void)
+{
+	static struct kvm_cpuid2 *cpuid;
+	int ret;
+	int kvm_fd;
+
+	if (cpuid)
+		return cpuid;
+
+	cpuid = allocate_kvm_cpuid2();
+	kvm_fd = open(KVM_DEV_PATH, O_RDONLY);
+	if (kvm_fd < 0)
+		exit(KSFT_SKIP);
+
+	ret = ioctl(kvm_fd, KVM_GET_EMULATED_CPUID, cpuid);
+	TEST_ASSERT(ret == 0, "KVM_GET_EMULATED_CPUID failed %d %d\n",
+		    ret, errno);
+
+	close(kvm_fd);
+	return cpuid;
+}
+
 /*
  * KVM Get MSR
  *
-- 
2.30.2

