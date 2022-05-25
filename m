Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0638F5339A3
	for <lists+kvm@lfdr.de>; Wed, 25 May 2022 11:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238681AbiEYJNS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 May 2022 05:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231698AbiEYJNG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 May 2022 05:13:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7FC5C9B1A9
        for <kvm@vger.kernel.org>; Wed, 25 May 2022 02:09:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653469740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SdqS0NQPZCKEUwD2dIY/ynaHh6p2yecQUXwSGu03RVo=;
        b=DxEFPlDL507+wFgFUERaaUpye27dalKppd1TaJpncwOUs4ErtZLBzDonW3qbmTGADGlVtp
        g0gZoM0ZmZ0PA1Zeo3XGQDbOxK815yDGlO+Yp4mO+HjapU1LJtiRZtWq40QO3ojUfI2Kd/
        4jXSksQzzp4NZp5WxwkdBYW4Fyh8fmU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-156-2N4YNbCxM3iQzzLdZh1WnA-1; Wed, 25 May 2022 05:02:41 -0400
X-MC-Unique: 2N4YNbCxM3iQzzLdZh1WnA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DE02429DD995;
        Wed, 25 May 2022 09:02:40 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.186])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 332DA405D4BF;
        Wed, 25 May 2022 09:02:39 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 31/37] KVM: selftests: Sync 'struct hv_enlightened_vmcs' definition with hyperv-tlfs.h
Date:   Wed, 25 May 2022 11:01:27 +0200
Message-Id: <20220525090133.1264239-32-vkuznets@redhat.com>
In-Reply-To: <20220525090133.1264239-1-vkuznets@redhat.com>
References: <20220525090133.1264239-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

'struct hv_enlightened_vmcs' definition in selftests is not '__packed'
and so we rely on the compiler doing the right padding. This is not
obvious so it seems beneficial to use the same definition as in kernel.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/include/x86_64/evmcs.h | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/evmcs.h b/tools/testing/selftests/kvm/include/x86_64/evmcs.h
index cc5d14a45702..b6067b555110 100644
--- a/tools/testing/selftests/kvm/include/x86_64/evmcs.h
+++ b/tools/testing/selftests/kvm/include/x86_64/evmcs.h
@@ -41,6 +41,8 @@ struct hv_enlightened_vmcs {
 	u16 host_gs_selector;
 	u16 host_tr_selector;
 
+	u16 padding16_1;
+
 	u64 host_ia32_pat;
 	u64 host_ia32_efer;
 
@@ -159,7 +161,7 @@ struct hv_enlightened_vmcs {
 	u64 ept_pointer;
 
 	u16 virtual_processor_id;
-	u16 padding16[3];
+	u16 padding16_2[3];
 
 	u64 padding64_2[5];
 	u64 guest_physical_address;
@@ -195,15 +197,15 @@ struct hv_enlightened_vmcs {
 	u64 guest_rip;
 
 	u32 hv_clean_fields;
-	u32 hv_padding_32;
+	u32 padding32_1;
 	u32 hv_synthetic_controls;
 	struct {
 		u32 nested_flush_hypercall:1;
 		u32 msr_bitmap:1;
 		u32 reserved:30;
-	} hv_enlightenments_control;
+	}  __packed hv_enlightenments_control;
 	u32 hv_vp_id;
-
+	u32 padding32_2;
 	u64 hv_vm_id;
 	u64 partition_assist_page;
 	u64 padding64_4[4];
@@ -211,7 +213,7 @@ struct hv_enlightened_vmcs {
 	u64 padding64_5[7];
 	u64 xss_exit_bitmap;
 	u64 padding64_6[7];
-};
+} __packed;
 
 #define HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE                     0
 #define HV_VMX_ENLIGHTENED_CLEAN_FIELD_IO_BITMAP                BIT(0)
-- 
2.35.3

