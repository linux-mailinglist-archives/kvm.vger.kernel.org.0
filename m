Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDCBE587FB4
	for <lists+kvm@lfdr.de>; Tue,  2 Aug 2022 18:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237144AbiHBQIQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Aug 2022 12:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235161AbiHBQIO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Aug 2022 12:08:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F05D71CB1E
        for <kvm@vger.kernel.org>; Tue,  2 Aug 2022 09:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659456492;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ow/ki+GUzQ6gWVPV1phdAr6J1HN7/hLJqPdnEVDbah0=;
        b=TCQhe4kpCQVb7HFTq8i4U/EIIi8c+hEW+Dq+mGCKsGQDml6IYdelJZb14qRBUfx8glc8Sk
        zeXzLz5DiZ0KyxaOiin2WEu3A049ZjiE4WLS33Z9JkqGAyCUCEWHAwfNKc8VJjZx7X4BvS
        dOoKQ4ylmJ8EDe23wlsJq5k1BX5oqTY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-538-TAvU9MilM1Gp6Ib10pWXzw-1; Tue, 02 Aug 2022 12:08:08 -0400
X-MC-Unique: TAvU9MilM1Gp6Ib10pWXzw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6D9D0811E81;
        Tue,  2 Aug 2022 16:08:08 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.108])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 370D12166B26;
        Tue,  2 Aug 2022 16:08:06 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 03/26] x86/hyperv: Update 'struct hv_enlightened_vmcs' definition
Date:   Tue,  2 Aug 2022 18:07:33 +0200
Message-Id: <20220802160756.339464-4-vkuznets@redhat.com>
In-Reply-To: <20220802160756.339464-1-vkuznets@redhat.com>
References: <20220802160756.339464-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Updated Hyper-V Enlightened VMCS specification lists several new
fields for the following features:

- PerfGlobalCtrl
- EnclsExitingBitmap
- Tsc Scaling
- GuestLbrCtl
- CET
- SSP

Update the definition. The updated definition is available only when
CPUID.0x4000000A.EBX BIT(0) is '1'. Add a define for it as well.

Note: The latest TLFS is available at
https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/tlfs/tlfs

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 arch/x86/include/asm/hyperv-tlfs.h | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
index 6f0acc45e67a..ebc27017fa48 100644
--- a/arch/x86/include/asm/hyperv-tlfs.h
+++ b/arch/x86/include/asm/hyperv-tlfs.h
@@ -138,6 +138,17 @@
 #define HV_X64_NESTED_GUEST_MAPPING_FLUSH		BIT(18)
 #define HV_X64_NESTED_MSR_BITMAP			BIT(19)
 
+/*
+ * Nested quirks. These are HYPERV_CPUID_NESTED_FEATURES.EBX bits.
+ *
+ * Note: HV_X64_NESTED_EVMCS1_2022_UPDATE is not currently documented in any
+ * published TLFS version. When the bit is set, nested hypervisor can use
+ * 'updated' eVMCSv1 specification (perf_global_ctrl, s_cet, ssp, lbr_ctl,
+ * encls_exiting_bitmap, tsc_multiplier fields which were missing in 2016
+ * specification).
+ */
+#define HV_X64_NESTED_EVMCS1_2022_UPDATE		BIT(0)
+
 /*
  * This is specific to AMD and specifies that enlightened TLB flush is
  * supported. If guest opts in to this feature, ASID invalidations only
@@ -559,9 +570,20 @@ struct hv_enlightened_vmcs {
 	u64 partition_assist_page;
 	u64 padding64_4[4];
 	u64 guest_bndcfgs;
-	u64 padding64_5[7];
+	u64 guest_ia32_perf_global_ctrl;
+	u64 guest_ia32_s_cet;
+	u64 guest_ssp;
+	u64 guest_ia32_int_ssp_table_addr;
+	u64 guest_ia32_lbr_ctl;
+	u64 padding64_5[2];
 	u64 xss_exit_bitmap;
-	u64 padding64_6[7];
+	u64 encls_exiting_bitmap;
+	u64 host_ia32_perf_global_ctrl;
+	u64 tsc_multiplier;
+	u64 host_ia32_s_cet;
+	u64 host_ssp;
+	u64 host_ia32_int_ssp_table_addr;
+	u64 padding64_6;
 } __packed;
 
 #define HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE			0
-- 
2.35.3

