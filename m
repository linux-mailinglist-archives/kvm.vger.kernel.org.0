Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 332D05011B8
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 17:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244940AbiDNNgs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 09:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244937AbiDNN2T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 09:28:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0F0A69284F
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 06:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649942479;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ymMl8hA8K/esTw1tg/apm+DYb9LQJWsl4/Hevby8goQ=;
        b=e2afPMxAePQRG3SgtiPP5Kbs9xwEIwsbbzUOb5UczBUboDpd5ZN/xhhFdQ/hfB6v2WF198
        Urru3Ffe/HN4PCiRJrV9wKnkAo8OqssnTwsF99o5nlCp4ZzPUcT8GOp1+GtvrkJKGPyc/r
        3EsjQzo7cDFUBIJWM0P9GUylf+ltr88=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-480-9uE9hCFMNhWH1RBS7kJ8pQ-1; Thu, 14 Apr 2022 09:21:12 -0400
X-MC-Unique: 9uE9hCFMNhWH1RBS7kJ8pQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 39C212A5957A;
        Thu, 14 Apr 2022 13:20:53 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.195.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7A01C7C28;
        Thu, 14 Apr 2022 13:20:51 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 18/34] x86/hyperv: Fix 'struct hv_enlightened_vmcs' definition
Date:   Thu, 14 Apr 2022 15:19:57 +0200
Message-Id: <20220414132013.1588929-19-vkuznets@redhat.com>
In-Reply-To: <20220414132013.1588929-1-vkuznets@redhat.com>
References: <20220414132013.1588929-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Section 1.9 of TLFS v6.0b says:

"All structures are padded in such a way that fields are aligned
naturally (that is, an 8-byte field is aligned to an offset of 8 bytes
and so on)".

'struct enlightened_vmcs' has a glitch:

...
        struct {
                u32                nested_flush_hypercall:1; /*   836: 0  4 */
                u32                msr_bitmap:1;         /*   836: 1  4 */
                u32                reserved:30;          /*   836: 2  4 */
        } hv_enlightenments_control;                     /*   836     4 */
        u32                        hv_vp_id;             /*   840     4 */
        u64                        hv_vm_id;             /*   844     8 */
        u64                        partition_assist_page; /*   852     8 */
...

And the observed values in 'partition_assist_page' make no sense at
all. Fix the layout by padding the structure properly.

Fixes: 68d1eb72ee99 ("x86/hyper-v: define struct hv_enlightened_vmcs and clean field bits")
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/hyperv-tlfs.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
index 5225a85c08c3..e7ddae8e02c6 100644
--- a/arch/x86/include/asm/hyperv-tlfs.h
+++ b/arch/x86/include/asm/hyperv-tlfs.h
@@ -548,7 +548,7 @@ struct hv_enlightened_vmcs {
 	u64 guest_rip;
 
 	u32 hv_clean_fields;
-	u32 hv_padding_32;
+	u32 padding32_1;
 	u32 hv_synthetic_controls;
 	struct {
 		u32 nested_flush_hypercall:1;
@@ -556,7 +556,7 @@ struct hv_enlightened_vmcs {
 		u32 reserved:30;
 	}  __packed hv_enlightenments_control;
 	u32 hv_vp_id;
-
+	u32 padding32_2;
 	u64 hv_vm_id;
 	u64 partition_assist_page;
 	u64 padding64_4[4];
-- 
2.35.1

