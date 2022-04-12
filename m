Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19CC34FEA6B
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 01:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbiDLX3g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 19:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231464AbiDLX2Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 19:28:25 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 830EC8595E
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 15:32:05 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id n22-20020a056a00213600b005056a13e1c1so155359pfj.20
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 15:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=kOUHSno4yyMxYzbXMdnr+GTVp/mtCVXbcLGHrdX0jEU=;
        b=VrgktD2fAbXyjo0m3hu0GKLEnKI3aoSsmfpjxnqR59DPs6ev9Ge9n07TcFA1ltNaOI
         cfrGpRCtLFt/rCkuJyAyxA1/cBTW6CWK8KqxNDaBHNAgRVnVJAxgiP5cs9cTVxSew6/U
         0iQaF7Ul7vlYvIPcpBODKT+Mt8Rzd4yYRd6XhAw3q9N/uZ19yMFhCEgWHwH1kuOtysKy
         zFkHfibdFBFmrg0XxFXdDPdd0zTL3g9oArM1aC47EpDpIdJKZ/6oPRI8fYJ6owF89nvM
         YSnmuIIs4TAN5S7fHoxw8E8obIwLo74WvCUiPbY3aPMFVZuaJHyic/JgkrISCYRnLC+7
         ZZOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=kOUHSno4yyMxYzbXMdnr+GTVp/mtCVXbcLGHrdX0jEU=;
        b=XFNVJjf+O8GqsBtVvXLcL/1H4/SIEXYLJCbj/jh6mzxONzEs7CynigMf7CX71ZFW6P
         nF3rvBIFBU/v0UovCnxQvlfhZ6fZ2jzbQMc3Whmxa/U/6Fq8dZ/Yc6mhb285kesDvFGF
         aJ6AI7HlUFSA662TLADDGCzOclW9mJBYEXV2druEhs2ebxRFiuwDZDkf70GIW+r6qVEg
         mrUt1DKyXSL22kNjU00S4KG7c9/huywYSoSjg1GmJh07d8CSe9Zu4hmTucigYjPh4y0J
         dXON9ZzdphwQkF+hVYg2bArn1SR+eW+HSReRbS2a11tg0ZlnczEB91amAr2WILfGqFpT
         iNUw==
X-Gm-Message-State: AOAM533Rz0rRdlQ9mdXh4P/zK1O5mhkeYlwikgg9IECXwkiF7dhQ/6Jg
        U6VJCXvyEpncy6hEL3Q/Zr3mM/fB
X-Google-Smtp-Source: ABdhPJwBMeMgnk+HeGxyv1oFOewB3zmAxUZXI6mnwFY3Ka9/2KsAjmPIcibBIJE+YUKnxs3rYIPDsWwI
X-Received: from juew-desktop.sea.corp.google.com ([2620:15c:100:202:6315:7654:72ee:17c3])
 (user=juew job=sendgmr) by 2002:a17:90b:2384:b0:1cb:5223:9dc4 with SMTP id
 mr4-20020a17090b238400b001cb52239dc4mr184046pjb.1.1649802724632; Tue, 12 Apr
 2022 15:32:04 -0700 (PDT)
Date:   Tue, 12 Apr 2022 15:31:34 -0700
In-Reply-To: <20220412223134.1736547-1-juew@google.com>
Message-Id: <20220412223134.1736547-5-juew@google.com>
Mime-Version: 1.0
References: <20220412223134.1736547-1-juew@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v2 4/4] KVM: x86: Add support for MCG_CMCI_P and handling of
 injected UCNAs.
From:   Jue Wang <juew@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org,
        Jue Wang <juew@google.com>
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

Note prior to this patch, the UCNA type of signaling can already be
processed by kvm_vcpu_ioctl_x86_set_mce and does not result in correct
CMCI signaling semantic.

Signed-off-by: Jue Wang <juew@google.com>
---
 arch/x86/kvm/vmx/vmx.c |  1 +
 arch/x86/kvm/x86.c     | 48 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 49 insertions(+)

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
index 73c64d2b9e60..eb6058ca1e70 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4775,6 +4775,50 @@ static int kvm_vcpu_ioctl_x86_setup_mce(struct kvm_vcpu *vcpu,
 	return r;
 }
 
+static bool is_ucna(u64 mcg_status, u64 mci_status)
+{
+	return !mcg_status &&
+		!(mci_status & (MCI_STATUS_PCC | MCI_STATUS_S | MCI_STATUS_AR));
+}
+
+static int kvm_vcpu_x86_set_ucna(struct kvm_vcpu *vcpu,
+		struct kvm_x86_mce *mce)
+{
+	u64 mcg_cap = vcpu->arch.mcg_cap;
+	unsigned int bank_num = mcg_cap & 0xff;
+	u64 *banks = vcpu->arch.mce_banks;
+
+	/* Check for legal bank number in guest */
+	if (mce->bank >= bank_num)
+		return -EINVAL;
+
+	/*
+	 * UCNA signals should not set bits that are only used for machine check
+	 * exceptions.
+	 */
+	if (mce->mcg_status ||
+		(mce->status & (MCI_STATUS_PCC | MCI_STATUS_S | MCI_STATUS_AR)))
+		return -EINVAL;
+
+	/* UCNA must have VAL and UC bits set */
+	if (!(mce->status & MCI_STATUS_VAL) || !(mce->status & MCI_STATUS_UC))
+		return -EINVAL;
+
+	banks += 4 * mce->bank;
+	banks[1] = mce->status;
+	banks[2] = mce->addr;
+	banks[3] = mce->misc;
+	vcpu->arch.mcg_status = mce->mcg_status;
+
+	if (!(mcg_cap & MCG_CMCI_P) || !(vcpu->arch.mci_ctl2_banks[mce->bank] & MCI_CTL2_CMCI_EN))
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
@@ -4784,6 +4828,10 @@ static int kvm_vcpu_ioctl_x86_set_mce(struct kvm_vcpu *vcpu,
 
 	if (mce->bank >= bank_num || !(mce->status & MCI_STATUS_VAL))
 		return -EINVAL;
+
+	if (is_ucna(mce->mcg_status, mce->status))
+		return kvm_vcpu_x86_set_ucna(vcpu, mce);
+
 	/*
 	 * if IA32_MCG_CTL is not all 1s, the uncorrected error
 	 * reporting is disabled
-- 
2.35.1.1178.g4f1659d476-goog

