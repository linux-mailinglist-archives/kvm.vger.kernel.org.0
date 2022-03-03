Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 940F74CC64D
	for <lists+kvm@lfdr.de>; Thu,  3 Mar 2022 20:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236332AbiCCTl5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Mar 2022 14:41:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236278AbiCCTlT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Mar 2022 14:41:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2287E1965E0
        for <kvm@vger.kernel.org>; Thu,  3 Mar 2022 11:39:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646336365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6OVwiXgL2ne0o49NfEE9CnwiAA0pdzmfBWE8Lv2JZiI=;
        b=Zve3skZ+EvXR+ykl2miTbQRsmp52Y5UTqGOpmgPc0X+7aOTuUM29eTmVnkvfTMhxHTrv1+
        gPvy30MYtiCJ/bXnZsbVvUJngyCt75tm70nDIQdcl8RLhOXX96LFGOG8xiRuzHEoKtAkXw
        pCpkwfKgxw5E/qoCXRkUJw2bnSeQFzk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-452-z-x861ajMxmaonNqxfKzPA-1; Thu, 03 Mar 2022 14:39:24 -0500
X-MC-Unique: z-x861ajMxmaonNqxfKzPA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 48C921006AAC;
        Thu,  3 Mar 2022 19:39:20 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 759485F70B;
        Thu,  3 Mar 2022 19:39:19 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Hildenbrand <david@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Mingwei Zhang <mizhang@google.com>
Subject: [PATCH v4 29/30] KVM: selftests: Define cpu_relax() helpers for s390 and x86
Date:   Thu,  3 Mar 2022 14:38:41 -0500
Message-Id: <20220303193842.370645-30-pbonzini@redhat.com>
In-Reply-To: <20220303193842.370645-1-pbonzini@redhat.com>
References: <20220303193842.370645-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Add cpu_relax() for s390 and x86 for use in arch-agnostic tests.  arm64
already defines its own version.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220226001546.360188-28-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 tools/testing/selftests/kvm/include/s390x/processor.h  | 8 ++++++++
 tools/testing/selftests/kvm/include/x86_64/processor.h | 5 +++++
 2 files changed, 13 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/s390x/processor.h b/tools/testing/selftests/kvm/include/s390x/processor.h
index e0e96a5f608c..255c9b990f4c 100644
--- a/tools/testing/selftests/kvm/include/s390x/processor.h
+++ b/tools/testing/selftests/kvm/include/s390x/processor.h
@@ -5,6 +5,8 @@
 #ifndef SELFTEST_KVM_PROCESSOR_H
 #define SELFTEST_KVM_PROCESSOR_H
 
+#include <linux/compiler.h>
+
 /* Bits in the region/segment table entry */
 #define REGION_ENTRY_ORIGIN	~0xfffUL /* region/segment table origin	   */
 #define REGION_ENTRY_PROTECT	0x200	 /* region protection bit	   */
@@ -19,4 +21,10 @@
 #define PAGE_PROTECT	0x200		/* HW read-only bit  */
 #define PAGE_NOEXEC	0x100		/* HW no-execute bit */
 
+/* Is there a portable way to do this? */
+static inline void cpu_relax(void)
+{
+	barrier();
+}
+
 #endif
diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index 8a470da7b71a..37db341d4cc5 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -363,6 +363,11 @@ static inline unsigned long get_xmm(int n)
 	return 0;
 }
 
+static inline void cpu_relax(void)
+{
+	asm volatile("rep; nop" ::: "memory");
+}
+
 bool is_intel_cpu(void);
 bool is_amd_cpu(void);
 
-- 
2.31.1


