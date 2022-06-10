Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37857546B84
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 19:15:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350190AbiFJRMF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 13:12:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349963AbiFJRMA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 13:12:00 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29516203D26
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 10:11:59 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2-20020aa78142000000b0051c394e5226so6073006pfn.19
        for <kvm@vger.kernel.org>; Fri, 10 Jun 2022 10:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=URENU4bgytSYSqzl5XO5s+M+HutB/NgBHP/HqZqxtRg=;
        b=fSmKyWGad1s5syipMpsdvEF+f/8FFRVBtRjqDTfYLzfWKGZbxAcMH2K2fKhXF3ZjeC
         q+/1kxQB+IXftFESOD+KUnLSFQMsu/li/Xu/h7UwjKgth3M/dB2vjgPUp8z0ctThHe/D
         DbHIP3/OMub5zcA932f7a4K5A9rUnq9AWnbWSBH/yz9XfUT+NopHbnZ1uDxkBSkegkIB
         tOsu+JPKimlqllfPdmdDfUP4K2VKo/DN4Dm2qiQysI7KNkEA0DUJaPoqG+jQaLnCDfrD
         piroLpSIINpF5LZKTjPeb3Fb3qpOl0BIY/Z8+O7BNqHzDGgkQ2T1etVk3QZlVpTIeNrW
         9d3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=URENU4bgytSYSqzl5XO5s+M+HutB/NgBHP/HqZqxtRg=;
        b=2ZDm5IsyXoCbMX1BGctN3wfJx+4Pl6ntYRkOSi5gH4ciDhEdTKgu/3myoDWSN38+/Y
         Qf360673TMw2wm67y+SrSoVU4L7tmsKkNihghEWKyo2AS8NFxJ2hhB3r6/iPIp+7ZUYs
         Y0Nk1bG0bdEKBTOmtYb5vCJaukdYzS7DTa2K/1IATFzQNKUwLG/loKdTj3W9yRrOU05c
         o3qs29plHP5ORiu4LBHDQ9m8+q85n28mfTfhnFfdvFLAc/dVkp2OwXOSBF5vii7tTQ7B
         bQFQ7vk/8sMnGgE9sHZIbzfIrtXtWJ/JEUsOYWFXJMQ2JgvsqROP+03/42hCTalU10Xa
         3L6Q==
X-Gm-Message-State: AOAM530k5oi/HszgwK4IDW3wLkjrW+xHkNaUdnm5w5eiBmdK+jRnzdXD
        XCPZVgsEe5l73mlh1jwU4YCC9RI4
X-Google-Smtp-Source: ABdhPJxbndLTeYsqbOT0vYnpqNctsS5JBKvwF5SgDy6e3irKctM8CXArwyXgzqdXuBYr1RsjxXuZWLKP
X-Received: from juew-desktop.sea.corp.google.com ([2620:15c:100:202:9a6e:681b:67df:5cc4])
 (user=juew job=sendgmr) by 2002:a63:4387:0:b0:3c6:9490:4e4b with SMTP id
 q129-20020a634387000000b003c694904e4bmr40250033pga.438.1654881118566; Fri, 10
 Jun 2022 10:11:58 -0700 (PDT)
Date:   Fri, 10 Jun 2022 10:11:33 -0700
In-Reply-To: <20220610171134.772566-1-juew@google.com>
Message-Id: <20220610171134.772566-8-juew@google.com>
Mime-Version: 1.0
References: <20220610171134.772566-1-juew@google.com>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
Subject: [PATCH v5 7/8] KVM: x86: Enable CMCI capability by default and handle
 injected UCNA errors
From:   Jue Wang <juew@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Matlack <dmatlack@google.com>
Cc:     Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org,
        Greg Thelen <gthelen@google.com>,
        Jiaqi Yan <jiaqiyan@google.com>, Jue Wang <juew@google.com>
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

This patch enables MCG_CMCI_P by default in kvm_mce_cap_supported. It
reuses ioctl KVM_X86_SET_MCE to implement injection of UnCorrectable
No Action required (UCNA) errors, signaled via Corrected Machine
Check Interrupt (CMCI).

Neither of the CMCI and UCNA emulations depends on hardware.

Signed-off-by: Jue Wang <juew@google.com>
---
 arch/x86/kvm/vmx/vmx.c |  1 +
 arch/x86/kvm/x86.c     | 44 +++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 610355b9ccce..1aed964ee4ee 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8037,6 +8037,7 @@ static __init int hardware_setup(void)
 	}
 
 	kvm_mce_cap_supported |= MCG_LMCE_P;
+	kvm_mce_cap_supported |= MCG_CMCI_P;
 
 	if (pt_mode != PT_MODE_SYSTEM && pt_mode != PT_MODE_HOST_GUEST)
 		return -EINVAL;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b18994907322..4322a1365f74 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4828,6 +4828,43 @@ static int kvm_vcpu_ioctl_x86_setup_mce(struct kvm_vcpu *vcpu,
 	return r;
 }
 
+/*
+ * Validate this is an UCNA error by checking the MCG_STATUS and MCi_STATUS
+ * registers that none of the bits for Machine Check Exceptions are set and
+ * both the VAL (valid) and UC (uncorrectable) bits are set.
+ * UCNA - UnCorrectable No Action required
+ * SRAR - Software Recoverable Action Required
+ * MCI_STATUS_PCC - Processor Context Corrupted
+ * MCI_STATUS_S - Signaled as a Machine Check Exception
+ * MCI_STATUS_AR - This MCE is "software recoverable action required"
+ */
+static bool is_ucna(struct kvm_x86_mce *mce)
+{
+	return	!mce->mcg_status &&
+		!(mce->status & (MCI_STATUS_PCC | MCI_STATUS_S | MCI_STATUS_AR)) &&
+		(mce->status & MCI_STATUS_VAL) &&
+		(mce->status & MCI_STATUS_UC);
+}
+
+static int kvm_vcpu_x86_set_ucna(struct kvm_vcpu *vcpu, struct kvm_x86_mce *mce, u64* banks)
+{
+	u64 mcg_cap = vcpu->arch.mcg_cap;
+
+	banks[1] = mce->status;
+	banks[2] = mce->addr;
+	banks[3] = mce->misc;
+	vcpu->arch.mcg_status = mce->mcg_status;
+
+	if (!(mcg_cap & MCG_CMCI_P) ||
+	    !(vcpu->arch.mci_ctl2_banks[mce->bank] & MCI_CTL2_CMCI_EN))
+		return 0;
+
+	if (lapic_in_kernel(vcpu))
+		kvm_apic_local_deliver(vcpu->arch.apic, APIC_LVTCMCI);
+
+	return 0;
+}
+
 static int kvm_vcpu_ioctl_x86_set_mce(struct kvm_vcpu *vcpu,
 				      struct kvm_x86_mce *mce)
 {
@@ -4837,6 +4874,12 @@ static int kvm_vcpu_ioctl_x86_set_mce(struct kvm_vcpu *vcpu,
 
 	if (mce->bank >= bank_num || !(mce->status & MCI_STATUS_VAL))
 		return -EINVAL;
+
+	banks += array_index_nospec(4 * mce->bank, 4 * bank_num);
+
+	if (is_ucna(mce))
+		return kvm_vcpu_x86_set_ucna(vcpu, mce, banks);
+
 	/*
 	 * if IA32_MCG_CTL is not all 1s, the uncorrected error
 	 * reporting is disabled
@@ -4844,7 +4887,6 @@ static int kvm_vcpu_ioctl_x86_set_mce(struct kvm_vcpu *vcpu,
 	if ((mce->status & MCI_STATUS_UC) && (mcg_cap & MCG_CTL_P) &&
 	    vcpu->arch.mcg_ctl != ~(u64)0)
 		return 0;
-	banks += 4 * mce->bank;
 	/*
 	 * if IA32_MCi_CTL is not all 1s, the uncorrected error
 	 * reporting is disabled for the bank
-- 
2.36.1.255.ge46751e96f-goog

