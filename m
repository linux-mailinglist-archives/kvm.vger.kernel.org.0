Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2DC617F32
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 15:16:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231633AbiKCOQI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 10:16:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231685AbiKCOPa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 10:15:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FB8D12600
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 07:14:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667484865;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZJCktf5q7jZ9/undR/aqzDAHm9J60Hmp1ceVzBBD+a0=;
        b=MT1Yf7LJd2a4IacGf/nCaca8QTHqrKliMOTdZjqZomesiiGvf0XO6IItPSoo48XNcKQQNy
        IyBc0H7NBDYgnuf+V7KmNfmX+ZRBr1IrEfrujz+WHWlnsHuANnq9VipV+6MgkOSPpF3qTj
        wE6uZbVWxsvZzNHXN1QsTVImBkAw/Nc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-13-wA31PaRqNXCLvYz9hD7aDg-1; Thu, 03 Nov 2022 10:14:17 -0400
X-MC-Unique: wA31PaRqNXCLvYz9hD7aDg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AF73485A5B6;
        Thu,  3 Nov 2022 14:14:16 +0000 (UTC)
Received: from amdlaptop.tlv.redhat.com (dhcp-4-238.tlv.redhat.com [10.35.4.238])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 30DD640C6EC3;
        Thu,  3 Nov 2022 14:14:13 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        Yang Zhong <yang.zhong@intel.com>, x86@kernel.org,
        Shuah Khan <shuah@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Colton Lewis <coltonlewis@google.com>,
        Borislav Petkov <bp@alien8.de>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kselftest@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Wei Wang <wei.w.wang@intel.com>,
        David Matlack <dmatlack@google.com>
Subject: [PATCH v2 5/9] KVM: selftests: move idt_entry to header
Date:   Thu,  3 Nov 2022 16:13:47 +0200
Message-Id: <20221103141351.50662-6-mlevitsk@redhat.com>
In-Reply-To: <20221103141351.50662-1-mlevitsk@redhat.com>
References: <20221103141351.50662-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

struct idt_entry will be used for a test which will break IDT on purpose.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 .../selftests/kvm/include/x86_64/processor.h        | 13 +++++++++++++
 tools/testing/selftests/kvm/lib/x86_64/processor.c  | 13 -------------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index e8ca0d8a6a7e0a..5da0c5e2a7afc4 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -748,6 +748,19 @@ struct ex_regs {
 	uint64_t rflags;
 };
 
+struct idt_entry {
+	uint16_t offset0;
+	uint16_t selector;
+	uint16_t ist : 3;
+	uint16_t : 5;
+	uint16_t type : 4;
+	uint16_t : 1;
+	uint16_t dpl : 2;
+	uint16_t p : 1;
+	uint16_t offset1;
+	uint32_t offset2; uint32_t reserved;
+};
+
 void vm_init_descriptor_tables(struct kvm_vm *vm);
 void vcpu_init_descriptor_tables(struct kvm_vcpu *vcpu);
 void vm_install_exception_handler(struct kvm_vm *vm, int vector,
diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 39c4409ef56a6a..41c1c73c464d48 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1074,19 +1074,6 @@ void kvm_get_cpu_address_width(unsigned int *pa_bits, unsigned int *va_bits)
 	}
 }
 
-struct idt_entry {
-	uint16_t offset0;
-	uint16_t selector;
-	uint16_t ist : 3;
-	uint16_t : 5;
-	uint16_t type : 4;
-	uint16_t : 1;
-	uint16_t dpl : 2;
-	uint16_t p : 1;
-	uint16_t offset1;
-	uint32_t offset2; uint32_t reserved;
-};
-
 static void set_idt_entry(struct kvm_vm *vm, int vector, unsigned long addr,
 			  int dpl, unsigned short selector)
 {
-- 
2.34.3

