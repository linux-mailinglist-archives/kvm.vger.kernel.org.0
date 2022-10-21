Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A10B607B49
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 17:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231266AbiJUPjv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 11:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231329AbiJUPjS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 11:39:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F17527D4F4
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 08:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666366624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xjfiBlRnH5bRxvhiJsegFt2pqquYJdUJUbrJQOgmVu0=;
        b=Sw3w/+otVaD3MR/50tZVp+6X91OzSHbABcVGcpADm65ahM2Jd8Qm0KoZ+S2UBANSvkUgMp
        BvfoemMO9IOOaRRvS8Pc4pI9xT0Vg4uccV0Op14vCDXJ0mLs4CCz/dp+dgiong1aa40w80
        QXfIPZOZ8QkGHrUZwQaVdjDDlFWJULg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-39-mDH1TTbnP1am_kNw_p6a6g-1; Fri, 21 Oct 2022 11:37:01 -0400
X-MC-Unique: mDH1TTbnP1am_kNw_p6a6g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 579C8811E81;
        Fri, 21 Oct 2022 15:37:00 +0000 (UTC)
Received: from ovpn-192-65.brq.redhat.com (ovpn-192-65.brq.redhat.com [10.40.192.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3E3A440CA41F;
        Fri, 21 Oct 2022 15:36:58 +0000 (UTC)
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
Subject: [PATCH v12 38/46] KVM: selftests: Sync 'struct hv_enlightened_vmcs' definition with hyperv-tlfs.h
Date:   Fri, 21 Oct 2022 17:35:13 +0200
Message-Id: <20221021153521.1216911-39-vkuznets@redhat.com>
In-Reply-To: <20221021153521.1216911-1-vkuznets@redhat.com>
References: <20221021153521.1216911-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
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
 tools/testing/selftests/kvm/include/x86_64/evmcs.h | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/evmcs.h b/tools/testing/selftests/kvm/include/x86_64/evmcs.h
index 58db74f68af2..4b6840df2979 100644
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
@@ -195,13 +197,13 @@ struct hv_enlightened_vmcs {
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
 	u32 padding32_2;
 	u64 hv_vm_id;
@@ -222,7 +224,7 @@ struct hv_enlightened_vmcs {
 	u64 host_ssp;
 	u64 host_ia32_int_ssp_table_addr;
 	u64 padding64_6;
-};
+} __packed;
 
 #define HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE                     0
 #define HV_VMX_ENLIGHTENED_CLEAN_FIELD_IO_BITMAP                BIT(0)
-- 
2.37.3

