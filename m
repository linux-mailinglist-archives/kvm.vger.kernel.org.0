Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAEC1588D9D
	for <lists+kvm@lfdr.de>; Wed,  3 Aug 2022 15:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238282AbiHCNqz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 09:46:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238342AbiHCNq1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 09:46:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EBA371C936
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 06:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659534372;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F94Tm16Pv+6X1Qxpix8Ro059dU0Hc/OW94AtIQA4pXw=;
        b=cfS/Pi0gRhsxd2d/f5EXJyBilF/YUPa6ltMmom/J4jo/qvpmGEsDZZhuiWU9G1PpTQDLqK
        PG7s1XIOS6SdF+3bsQveikIy/50vyyvMZiVTq31N3/cuIfopT/EHiNXjW67Z/8BvKnUmV3
        r2/T2wDLnLcfz5/Wck0wugQtr5Kk/kk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-180-jTzDZpKTN5eVWPaT7i_e_A-1; Wed, 03 Aug 2022 09:46:08 -0400
X-MC-Unique: jTzDZpKTN5eVWPaT7i_e_A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C7E811035373;
        Wed,  3 Aug 2022 13:46:07 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.195.93])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E4DC71415116;
        Wed,  3 Aug 2022 13:46:04 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v9 19/40] x86/hyperv: Fix 'struct hv_enlightened_vmcs' definition
Date:   Wed,  3 Aug 2022 15:46:04 +0200
Message-Id: <20220803134604.399306-1-vkuznets@redhat.com>
In-Reply-To: <20220803134110.397885-1-vkuznets@redhat.com>
References: <20220803134110.397885-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
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
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
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
2.35.3

