Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17BAC52F1BA
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 19:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352326AbiETRhG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 13:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352311AbiETRhC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 13:37:02 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00F9B84A08
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 10:36:59 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id me18-20020a17090b17d200b001dfa3d25c37so5890998pjb.8
        for <kvm@vger.kernel.org>; Fri, 20 May 2022 10:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=DV2RMsryiu11Btf+O0wwsjjvh9trhw/nWQ7OXrbtao8=;
        b=Mp7p/79Xi+0P9FW+2vqGO4EMCA3GVyk0XdRpgRPMpzaYw/KWkaXmBVOufpTf/65ES5
         ZIv74+4o9Mh4fvdl0gzjGZBPyQrQw/eKR13pPVSJqKVxIkakuHKMPWwqYjYYeROyh+7i
         Os9UThXKkSrS/erRbzl4ZmFLbWyn4DB/7Hz8ilze/lfNACwglaIS7WBNM7Y3swJtf6k6
         SHF7Ky+jxWXaxiYtjw+Spq6BByv7nINJEegt4YqtFYvVDFwnJb/semYyqXG3VqM64Bcc
         W9y1B5XIbcfHypV8Hbwp+fIH4S6dPS2AVFK0nH2OwpewrmNeEgIdgSdOY9vyLe20FRim
         6j7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=DV2RMsryiu11Btf+O0wwsjjvh9trhw/nWQ7OXrbtao8=;
        b=3pww7k2B6JqdJpCJogKVwF/45sthJn+5/XViIBlR/Ovw0iVzHM0J5+E3HVisJwewef
         ti1eAbqhukfmmaoa9RC97flNReE/9qvz5pK2b6g7JFvnrzluyxOSmG/eitpkkqQnzntq
         dLa0O6L64ZpvgK6HzVquIomKieNQ3BCuFCCsSVWZTscijaDB+2FYGZ9BOBPgVP0EWZVl
         Xcw+QM8bdVkiQ4H4q70JpHREBHB4QzFZDxkyV5yCZMqOQx0NZHcdoG9mP2DmPPgKaZdi
         ajv/8pjFv+Pv+Ko2NyEKw7TUjCzSUjT3nanX4mTf3Y9m9PEWRU1rDrjmrDudaljYcbl/
         MXpw==
X-Gm-Message-State: AOAM531bD53D5VfS+JM0OD/tbkyZDvXoEpsrSP/tQriOhXUdEDAb6LHy
        Jmv1mzX7Uhsk37MFkRC+6fteP0Rg
X-Google-Smtp-Source: ABdhPJw9TnfuptiNDRCpELFyZlALfBKb0SvjM8EcCkmc5pf4/llS/lf7n+hGP5SI1IoLSlFSMiO5YzDK
X-Received: from juew-desktop.sea.corp.google.com ([2620:15c:100:202:4c5:ddc5:8182:560f])
 (user=juew job=sendgmr) by 2002:a05:6a00:1348:b0:518:6ef5:ac3 with SMTP id
 k8-20020a056a00134800b005186ef50ac3mr4228587pfu.69.1653068218884; Fri, 20 May
 2022 10:36:58 -0700 (PDT)
Date:   Fri, 20 May 2022 10:36:37 -0700
In-Reply-To: <20220520173638.94324-1-juew@google.com>
Message-Id: <20220520173638.94324-8-juew@google.com>
Mime-Version: 1.0
References: <20220520173638.94324-1-juew@google.com>
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH v4 7/8] KVM: x86: Enable CMCI capability by default and handle
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

Make KVM support the CMCI capability by default by adding MCG_CMCI_P to
kvm_mce_cap_supported. A vCPU can request for this capability via
KVM_X86_SETUP_MCE. Uncorrectable Error No Action required (UCNA) injection
reuses the MCE injection ioctl KVM_X86_SET_MCE.

Neither of the CMCI and UCNA emulations depends on hardware.

Signed-off-by: Jue Wang <juew@google.com>
---
 arch/x86/kvm/vmx/vmx.c |  1 +
 arch/x86/kvm/x86.c     | 50 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+)

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
index f8ab592f519b..d0b1bb6e5e4a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4826,6 +4826,52 @@ static int kvm_vcpu_ioctl_x86_setup_mce(struct kvm_vcpu *vcpu,
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
@@ -4835,6 +4881,10 @@ static int kvm_vcpu_ioctl_x86_set_mce(struct kvm_vcpu *vcpu,
 
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
2.36.1.124.g0e6072fb45-goog

