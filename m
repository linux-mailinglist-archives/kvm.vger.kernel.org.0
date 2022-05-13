Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5D7D526924
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 20:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383294AbiEMSVW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 14:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383308AbiEMSVO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 14:21:14 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 886D9377CB
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 11:21:13 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 66-20020a630545000000b003db7de758adso2331588pgf.20
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 11:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1LwHlP1lxAYDUWazS91/RUyqdIhiEF6nGKwGXoUcdz4=;
        b=LlLn1l5NkZDIvjMnWvRzN74UbF4gT/6LeoycMeE1TlFhWwbS7U2ngGPJDq9lOpaQiW
         MgWLwnz2bYXA/nJMF6tweCaBpNwIIhCzylI5x7bYCyjFZI2iBHeTbUoxrgoyKFZGy0Cj
         pNVEYUttUkSY4tsYPMM+FWSB1q2PpdZ8JHBQcJsCESpDeZyh4Vi4dn6WrhT137IBbpu4
         JFkNlC6JFPSYJyEdELOK/l87sc4OEhxesLOI0Iml4T/jaW4dCId+TSNo/3EYv+1f+tPF
         lGSQWzysazw3BjLMLZXZuFeAVsKnrGzpS9Ua4yh/WzBH13Bo4XTqzHYe03i3/cwUpyGd
         EMtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1LwHlP1lxAYDUWazS91/RUyqdIhiEF6nGKwGXoUcdz4=;
        b=Q/vhB75gt9RCYaRLDOpm7thzGLVoKtMPrG9FqY94ju8C6PwtlzQHif3+OvVSlZSfOs
         sqjUX22l3p7qHmR5lMiiX7eXa+ackzhxKpkN3pnj1yYTV3o55YIEN2O/H7cfEXqzZrHb
         sBbjkKGeJMXQMoiCwu+qFhpQfJNbJlvl+lEdX3Iql49UwWu052orn3XIFHwlXuPlRlXW
         K7BqHZkzbXHif8wpltgPns100Sobb7j/8+yzqZOvCnPoLPkivDarpz8CkrtD9wBVWqio
         3FoN3fBOeUhVKOZIlMRVrgZZZZDjHqLn1G97uCzK+0gn/ReV01pjwdVdleHNrXz04rM6
         00Mw==
X-Gm-Message-State: AOAM533XC3Gb7UOIwBL22IwTAgOORICGKLWRbYdDBnigXd/GymnDRLs0
        ZWyKPUIfcZiZ8bD5efh0j3alKOiM
X-Google-Smtp-Source: ABdhPJxu8xIztj+FQ0uqpTIUEbLF/Z/Mr8+hEnhA1wQA+HGQaNDU7KvRxpweaCkD7dF3VB0WML+0ZPKR
X-Received: from juew-desktop.sea.corp.google.com ([2620:15c:100:202:d883:9294:4cf5:a395])
 (user=juew job=sendgmr) by 2002:a17:90a:e510:b0:1d9:ee23:9fa1 with SMTP id
 t16-20020a17090ae51000b001d9ee239fa1mr249701pjy.0.1652466071769; Fri, 13 May
 2022 11:21:11 -0700 (PDT)
Date:   Fri, 13 May 2022 11:20:38 -0700
In-Reply-To: <20220513182038.2564643-1-juew@google.com>
Message-Id: <20220513182038.2564643-8-juew@google.com>
Mime-Version: 1.0
References: <20220513182038.2564643-1-juew@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH v3 7/7] KVM: x86: Enable MCG_CMCI_P and handle injected UCNAs.
From:   Jue Wang <juew@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
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

This series adds the Corrected Machine Check Interrupt (CMCI) and
Uncorrectable Error No Action required (UCNA) emulation to KVM. The
former is implemented as a LVT CMCI vector. The emulation of UCNA share
the MCE emulation infrastructure.

Both CMCI and UCNA emulation do not depend on hardware. CMCI emulation
only depends on vcpu's lapic being available.

Signed-off-by: Jue Wang <juew@google.com>
---
 arch/x86/kvm/vmx/vmx.c |  1 +
 arch/x86/kvm/x86.c     | 50 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b730d799c26e..63aa2b3d30ca 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8035,6 +8035,7 @@ static __init int hardware_setup(void)
 	}
 
 	kvm_mce_cap_supported |= MCG_LMCE_P;
+	kvm_mce_cap_supported |= MCG_CMCI_P;
 
 	if (pt_mode != PT_MODE_SYSTEM && pt_mode != PT_MODE_HOST_GUEST)
 		return -EINVAL;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index eab1398cefa5..77b51c781998 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4797,6 +4797,52 @@ static int kvm_vcpu_ioctl_x86_setup_mce(struct kvm_vcpu *vcpu,
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
+static int kvm_vcpu_x86_set_ucna(struct kvm_vcpu *vcpu, struct kvm_x86_mce *mce)
+{
+	u64 mcg_cap = vcpu->arch.mcg_cap;
+	unsigned int bank_num = mcg_cap & 0xff;
+	u64 *banks = vcpu->arch.mce_banks;
+
+	if (mce->bank >= bank_num)
+		return -EINVAL;
+
+	if (!is_ucna(mce))
+		return -EINVAL;
+
+	banks += 4 * mce->bank;
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
@@ -4806,6 +4852,10 @@ static int kvm_vcpu_ioctl_x86_set_mce(struct kvm_vcpu *vcpu,
 
 	if (mce->bank >= bank_num || !(mce->status & MCI_STATUS_VAL))
 		return -EINVAL;
+
+	if (is_ucna(mce))
+		return kvm_vcpu_x86_set_ucna(vcpu, mce);
+
 	/*
 	 * if IA32_MCG_CTL is not all 1s, the uncorrected error
 	 * reporting is disabled
-- 
2.36.0.550.gb090851708-goog

