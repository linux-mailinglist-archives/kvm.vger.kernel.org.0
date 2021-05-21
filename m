Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDE0538C40D
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 11:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237710AbhEUJ4a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 05:56:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22703 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237302AbhEUJzB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 May 2021 05:55:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621590818;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9e8wzu7GoZtGmD6BK6u6R8FO/asla9x3dkoyRinjgVM=;
        b=Fnb+isfyLRk396YcWCBd4vzWE2RN3zBrIWAg0HAvakDGt95Y/zEE9TtWJ3Rh/pzpRMOvNc
        kKi+Zh7yKgjdxxQdHcwvkkcL6rszaUogAr+0g5EbPt6PQjApNlmntIumXw4hKBQRgAB5ea
        3LvO/tLsoxKEvmtn/VbHczVkn7dBRhg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-7-0QbI0c_hNaOU84AqJdvnKw-1; Fri, 21 May 2021 05:53:36 -0400
X-MC-Unique: 0QbI0c_hNaOU84AqJdvnKw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F0B6A3E77E;
        Fri, 21 May 2021 09:53:34 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0883A6A04D;
        Fri, 21 May 2021 09:53:32 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 28/30] KVM: selftests: move Hyper-V MSR definitions to hyperv.h
Date:   Fri, 21 May 2021 11:52:02 +0200
Message-Id: <20210521095204.2161214-29-vkuznets@redhat.com>
In-Reply-To: <20210521095204.2161214-1-vkuznets@redhat.com>
References: <20210521095204.2161214-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These defines can be shared by multiple tests, move them to a dedicated
header.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 .../selftests/kvm/include/x86_64/hyperv.h     | 19 +++++++++++++++++++
 .../selftests/kvm/x86_64/hyperv_clock.c       |  8 +-------
 2 files changed, 20 insertions(+), 7 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/x86_64/hyperv.h

diff --git a/tools/testing/selftests/kvm/include/x86_64/hyperv.h b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
new file mode 100644
index 000000000000..443c6572512b
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/x86_64/hyperv.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * tools/testing/selftests/kvm/include/x86_64/hyperv.h
+ *
+ * Copyright (C) 2021, Red Hat, Inc.
+ *
+ */
+
+#ifndef SELFTEST_KVM_HYPERV_H
+#define SELFTEST_KVM_HYPERV_H
+
+#define HV_X64_MSR_GUEST_OS_ID			0x40000000
+#define HV_X64_MSR_TIME_REF_COUNT		0x40000020
+#define HV_X64_MSR_REFERENCE_TSC		0x40000021
+#define HV_X64_MSR_TSC_FREQUENCY		0x40000022
+#define HV_X64_MSR_REENLIGHTENMENT_CONTROL	0x40000106
+#define HV_X64_MSR_TSC_EMULATION_CONTROL	0x40000107
+
+#endif /* !SELFTEST_KVM_HYPERV_H */
diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_clock.c b/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
index 7f1d2765572c..489625acc9cf 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_clock.c
@@ -7,6 +7,7 @@
 #include "test_util.h"
 #include "kvm_util.h"
 #include "processor.h"
+#include "hyperv.h"
 
 struct ms_hyperv_tsc_page {
 	volatile u32 tsc_sequence;
@@ -15,13 +16,6 @@ struct ms_hyperv_tsc_page {
 	volatile s64 tsc_offset;
 } __packed;
 
-#define HV_X64_MSR_GUEST_OS_ID			0x40000000
-#define HV_X64_MSR_TIME_REF_COUNT		0x40000020
-#define HV_X64_MSR_REFERENCE_TSC		0x40000021
-#define HV_X64_MSR_TSC_FREQUENCY		0x40000022
-#define HV_X64_MSR_REENLIGHTENMENT_CONTROL	0x40000106
-#define HV_X64_MSR_TSC_EMULATION_CONTROL	0x40000107
-
 /* Simplified mul_u64_u64_shr() */
 static inline u64 mul_u64_u64_shr64(u64 a, u64 b)
 {
-- 
2.31.1

