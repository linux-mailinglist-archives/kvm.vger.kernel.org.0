Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8B7559F1AC
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 05:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234413AbiHXDDh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Aug 2022 23:03:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231516AbiHXDDG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Aug 2022 23:03:06 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A19780358
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:01:44 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id a19-20020aa780d3000000b0052bccd363f8so6858273pfn.22
        for <kvm@vger.kernel.org>; Tue, 23 Aug 2022 20:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=+jwdH1M563+YQ2/rfbUaxWrTwU77bKucP44nkZPglGg=;
        b=AE8ZxuIN+XYqJxa/pXVBktsb2qB0T/5bSNN4RenCTNFlN9k5RgMcRyxOuLOkdFzkwv
         7tHFw7QRGQoybh1ruGhBi6M4YE9yVOOG/9yeC+lkT1gm9VSwgmX98j+VXb+W4+eNlBR1
         Dkc2uQmwGDHYdwEQDj7tI2nY0qXPpcCCGDKf/h96KaQFLhXBXlp+yT/McAN4GZEqmgIB
         GROOMtW+WHHckyLDs+VjLe9QPN9QOGXiybBwSbh2R7bTBCEKooI20VdEhFNyZgJ3wFtg
         r6+oQwv3jo+iGdi5/SYy+ZLZ1puyNtrehQhKqN1mES0o4+n/jZkiUEDDVXZYuj385azw
         MUAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=+jwdH1M563+YQ2/rfbUaxWrTwU77bKucP44nkZPglGg=;
        b=y0ExTlTGE/IFN5q2IAZffKpLaJDBGnXK/EsY1rKCQhG9nh0SBjwuIzNW4K8++W25++
         O+MsyxWzFNV9qhUpTeTcPdguhfRDp80NSX9bzxh/Bcdt/fCL0t18ahWWz1UcJcwLkrhC
         +A/Am5ZeVwuRiVadVpdi/DYzYZK8YzqMkrA/uYkRzNX5+OG3H4VjaOjNfBqDPOWmuqYS
         rjJJwaeYIaX9dvaNF5o/AY+ohQXmwU8osR/6w42q6XMxNcPvlfWI3+qplnfC9gdOlFC8
         DSKvzuztXPa6Xsk9Q9lAkzb/oLISA3rt/ewWgjMjr8ysHwlL1FiTVYSTEhXVNtCf51rj
         YBRg==
X-Gm-Message-State: ACgBeo2FqQm8J29EemGBsCUggxld3gUEuXavTVo0d5Q/+4xGsysTQ3R+
        xm6drW1FDb4dVNk9aSmKAdCalc5PrUE=
X-Google-Smtp-Source: AA6agR6r3rhht4pZNVhUcH4QRQMKf1oSueWwGaKyS6Doll/cRyX0up4hc59o6whKdd7U6ER2n2qSGJ7LqVI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:230f:b0:52f:6734:90fe with SMTP id
 h15-20020a056a00230f00b0052f673490femr28249580pfh.67.1661310104062; Tue, 23
 Aug 2022 20:01:44 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 24 Aug 2022 03:01:04 +0000
In-Reply-To: <20220824030138.3524159-1-seanjc@google.com>
Message-Id: <20220824030138.3524159-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220824030138.3524159-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [RFC PATCH v6 02/36] x86/hyperv: Update 'struct hv_enlightened_vmcs' definition
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Vitaly Kuznetsov <vkuznets@redhat.com>

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
2.37.1.595.g718a3a8f04-goog

