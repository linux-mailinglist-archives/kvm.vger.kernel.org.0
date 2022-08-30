Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3A3B5A64F1
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 15:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbiH3NiG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 09:38:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiH3Nhw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 09:37:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EEFFAE22E
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 06:37:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661866668;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xT/Z1OVYlVoOOLO+opUmyDYeXUAC+ZDM47Iv2objFik=;
        b=An2spsmbK8QxEFwHpk/L40Gm5LIWrG/OfqdU+ejCRUlCw7Zmu3krU0V4smP5B2p/HOjwxj
        +ZBkX/MaVyAMjWAeUOPLwmnhJ+QKcOAxRivQRF0F+seCyQxNjRNE/fIMU/3lPtmjPGY6yZ
        dn8QAWsJC5GH1KLOsj12UAhjcj8vQ8w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-589-BW-Rh0rPNvSMZIxgjdL3yg-1; Tue, 30 Aug 2022 09:37:45 -0400
X-MC-Unique: BW-Rh0rPNvSMZIxgjdL3yg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ED1CD1020BA5;
        Tue, 30 Aug 2022 13:37:44 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1A7212166B26;
        Tue, 30 Aug 2022 13:37:42 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 02/33] x86/hyperv: Update 'struct hv_enlightened_vmcs' definition
Date:   Tue, 30 Aug 2022 15:37:06 +0200
Message-Id: <20220830133737.1539624-3-vkuznets@redhat.com>
In-Reply-To: <20220830133737.1539624-1-vkuznets@redhat.com>
References: <20220830133737.1539624-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
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

Update the definition.

Note, the updated spec also provides an additional CPUID feature flag,
CPUIDD.0x4000000A.EBX BIT(0), for PerfGlobalCtrl to workaround a Windows
11 quirk.  Despite what the TLFS says:

  Indicates support for the GuestPerfGlobalCtrl and HostPerfGlobalCtrl
  fields in the enlightened VMCS.

guests can safely use the fields if they are enumerated in the
architectural VMX MSRs.  I.e. KVM-on-HyperV doesn't need to check the
CPUID bit, but KVM-as-HyperV must ensure the bit is set if PerfGlobalCtrl
fields are exposed to L1.

https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/tlfs/tlfs

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
[sean: tweak CPUID name to make it PerfGlobalCtrl only]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/hyperv-tlfs.h | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/hyperv-tlfs.h b/arch/x86/include/asm/hyperv-tlfs.h
index 6f0acc45e67a..3089ec352743 100644
--- a/arch/x86/include/asm/hyperv-tlfs.h
+++ b/arch/x86/include/asm/hyperv-tlfs.h
@@ -138,6 +138,9 @@
 #define HV_X64_NESTED_GUEST_MAPPING_FLUSH		BIT(18)
 #define HV_X64_NESTED_MSR_BITMAP			BIT(19)
 
+/* Nested features #2. These are HYPERV_CPUID_NESTED_FEATURES.EBX bits. */
+#define HV_X64_NESTED_EVMCS1_PERF_GLOBAL_CTRL		BIT(0)
+
 /*
  * This is specific to AMD and specifies that enlightened TLB flush is
  * supported. If guest opts in to this feature, ASID invalidations only
@@ -559,9 +562,20 @@ struct hv_enlightened_vmcs {
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
2.37.2

