Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A07F45A3232
	for <lists+kvm@lfdr.de>; Sat, 27 Aug 2022 00:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343709AbiHZWsK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 18:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239972AbiHZWsJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 18:48:09 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FA38E927C
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 15:48:08 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id x7-20020a170902ec8700b00172eaf25822so1840775plg.12
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 15:48:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=/eKCroPzdUk+A4JmZaOfe/rMCDrjEsSkQ+h26/LDiwQ=;
        b=HkCZnpWSjZB9d+WvasUUZQZbornWSJehKq8FzIrCOvtvUdQwV+DxC5LNsW/EpvvnfJ
         nOltKtAnygk9wboSOqwWCoRaklA36f3kJFByWol7dcMqCz/F+wL6ck26xIgs5PkwjrTb
         r53elw7F1m+un2TKQ1ALq+SiXV2wN4IVkL7bx+TWlZTc1FYuXna9qZ5MNs40hwTm5+6F
         hqsueq47orIFWFFCTzRkZJzEDMMq9gN/NCMvfYubtQ7rooaWWxGjMtFAKgdv2AzWtYH9
         Zz2r3Nw/ZUOltQTNN1grlaaIS/bitC0kUdER/msdOv6jgJ3re2yYeomv5MarL8XJfAu9
         AQ7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=/eKCroPzdUk+A4JmZaOfe/rMCDrjEsSkQ+h26/LDiwQ=;
        b=thh/pZa4TYwceod1SUuiobxEPHzQfSO2aY2ScCjaO6pjZbrvVftpGmDXkziq8Ss44F
         SSceN1hWC1xQIUP18e/T0iYrixmESFp8hHS0d3VrnRtOJR/CpQ0OEoPsG93dmxjtbmEN
         9/xifBtxM/SUwV/YSmLw9adgH2jmDCCCBSKnoi4sGse+kn/K0Fx7DYyWUIqBpblTmOcI
         mh7azy/Jl8ESE1xb2+aIZ35gwopNQo5Lncee6Bo0vk1HKFJLLUYIQrrnPan9D+PZX8oE
         UVZ1iy4t9hFavoCOTVg8XYhy/FWKRqsmlre1IXwIju+d1ke2FmMSbfda/s+knO+8Jul0
         aD5g==
X-Gm-Message-State: ACgBeo3h19bxOGvxVpScT1X/7AFrbs364HU5SEVWOjUuodaK9qYj2sk6
        NiRppfQiBVnX8rE5gRvZuH5GvqYuowUxzOlY3MMI9OKrHxDxKWCehagJ+HxkK2qrw9MdqWrrpp9
        gWlyTCs/vHkjCKUN5p925GtnKcXEOoqcgxfLi+xciK3X8luV8S+4Cku5xlnfxlMU=
X-Google-Smtp-Source: AA6agR5wsb0MKi4BmtCnGqsfmKszCm13mQLNxi4OPAs8gX57sUpetaq3dftziw55hd08HiVAf0T7mcvSQbca6g==
X-Received: from loggerhead.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:29a])
 (user=jmattson job=sendgmr) by 2002:a17:902:b415:b0:172:a92c:8f9 with SMTP id
 x21-20020a170902b41500b00172a92c08f9mr5722470plr.31.1661554087876; Fri, 26
 Aug 2022 15:48:07 -0700 (PDT)
Date:   Fri, 26 Aug 2022 15:47:55 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
Message-ID: <20220826224755.1330512-1-jmattson@google.com>
Subject: [PATCH] KVM: x86: Mask off unsupported and unknown bits of IA32_ARCH_CAPABILITIES
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
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

KVM should not claim to virtualize unknown IA32_ARCH_CAPABILITIES
bits. When kvm_get_arch_capabilities() was originally written, there
were only a few bits defined in this MSR, and KVM could virtualize all
of them. However, over the years, several bits have been defined that
KVM cannot just blindly pass through to the guest without additional
work (such as virtualizing an MSR promised by the
IA32_ARCH_CAPABILITES feature bit).

Define a mask of supported IA32_ARCH_CAPABILITIES bits, and mask off
any other bits that are set in the hardware MSR.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Fixes: 5b76a3cff011 ("KVM: VMX: Tell the nested hypervisor to skip L1D flush on vmentry")
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 arch/x86/kvm/x86.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 205ebdc2b11b..ae6be8b2ecfe 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1557,12 +1557,32 @@ static const u32 msr_based_features_all[] = {
 static u32 msr_based_features[ARRAY_SIZE(msr_based_features_all)];
 static unsigned int num_msr_based_features;
 
+/*
+ * IA32_ARCH_CAPABILITIES bits deliberately omitted are:
+ *   10 - MISC_PACKAGE_CTRLS
+ *   11 - ENERGY_FILTERING_CTL
+ *   12 - DOITM
+ *   18 - FB_CLEAR_CTRL
+ *   21 - XAPIC_DISABLE_STATUS
+ *   23 - OVERCLOCKING_STATUS
+ */
+
+#define KVM_SUPPORTED_ARCH_CAP \
+	(ARCH_CAP_RDCL_NO | ARCH_CAP_IBRS_ALL | ARCH_CAP_RSBA | \
+	 ARCH_CAP_SKIP_VMENTRY_L1DFLUSH | ARCH_CAP_SSB_NO | ARCH_CAP_MDS_NO | \
+	 ARCH_CAP_PSCHANGE_MC_NO | ARCH_CAP_TSX_CTRL_MSR | ARCH_CAP_TAA_NO | \
+	 ARCH_CAP_SBDR_SSDP_NO | ARCH_CAP_FBSDP_NO | ARCH_CAP_PSDP_NO | \
+	 ARCH_CAP_FB_CLEAR | ARCH_CAP_RRSBA | ARCH_CAP_PBRSB_NO)
+
+
 static u64 kvm_get_arch_capabilities(void)
 {
 	u64 data = 0;
 
-	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES))
+	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES)) {
 		rdmsrl(MSR_IA32_ARCH_CAPABILITIES, data);
+		data &= KVM_SUPPORTED_ARCH_CAP;
+	}
 
 	/*
 	 * If nx_huge_pages is enabled, KVM's shadow paging will ensure that
@@ -1610,9 +1630,6 @@ static u64 kvm_get_arch_capabilities(void)
 		 */
 	}
 
-	/* Guests don't need to know "Fill buffer clear control" exists */
-	data &= ~ARCH_CAP_FB_CLEAR_CTRL;
-
 	return data;
 }
 
-- 
2.37.2.672.g94769d06f0-goog

