Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1D315257C4
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 00:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359168AbiELW1Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 18:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359151AbiELW1X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 18:27:23 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C18A66948A
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 15:27:22 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id h23-20020a17090adb9700b001dcce3bb2d4so5196270pjv.7
        for <kvm@vger.kernel.org>; Thu, 12 May 2022 15:27:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=bSUiUXGuiZeZXDy6szRyl5Pb0BlIGgSml446k/D2EYc=;
        b=L4h+SAkPbx0grNeYQbaXxmVWIV5Ls1B38Oy26hddUO821qYdicU61uy4E2aQvj+5HO
         oNfcDCOz1Wbb/+FaJe+Ha0DZNYA10qc5mJbH5eesdxw6zZFIa7Nm43GG0Es5gefL4vmj
         3xoVEkQC7ji8RztiX7tBFxdj/E7NM9WfLqdtIfHTfCKAc1Cq7ccAIOQSS4TIHRRHeGQX
         KNWDY3TnfbQe0bLKrp5v/EWqNv3Uge1TI71goS9hgYf0tY2A0hT0IF0QGcswXN/x8mEG
         +XvoddC26T1aWtOmbw3JYMwh6Lbfj335+oXaXNXQ3DkNRKpwsEgFV81U/rviK+pIVNzy
         sc5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=bSUiUXGuiZeZXDy6szRyl5Pb0BlIGgSml446k/D2EYc=;
        b=D+B/0kivE2UGy9IlC/qIJ9m+Hf8QgtrvG9iiORw7uw11ORKvQrFCQizDk3Rsyam6UC
         bDHrgtNey4aWRxZRctrNkS8uqu03SHUfDOnSyU6WYbD9r3nNiNfZvGBqQsn52MkNhKV1
         yfUbIWOGIjGaJWEms5ZEuQ4Qa8UJxPVd91PJKyN5AjM7tGWXtEz1BI64LlqFzkG6rnYg
         vfq+hBbwMlu2Dh91t1rYUbmbUZ3T838wxsDTj5qlWVClmBUJFW3jJDrvwnoE0MRu8IPa
         85hr2bPPIPGvKLXFdQZ/pPeyzpeyDUTjNg3hNAwGn4OAxtpwKww6tSyBk4U9O03tB6I5
         /Vsw==
X-Gm-Message-State: AOAM532xMIrO7UPYGcr08skLO4RQ5YSgfFybVsDEsUnzLvpVAKfZjYGZ
        sJR8Z/e0WlxLKG4mR/9O4YFeVEp3cc0=
X-Google-Smtp-Source: ABdhPJy78pw9H01EQxvilUuvJI5YT+rh2PXQQ9qGJcQZE39wAkzjFRmskOhAGvnaE0zX4hrAicRF44HQIeo=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:903:41c9:b0:15e:ae15:294f with SMTP id
 u9-20020a17090341c900b0015eae15294fmr1914969ple.44.1652394442293; Thu, 12 May
 2022 15:27:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 12 May 2022 22:27:15 +0000
In-Reply-To: <20220512222716.4112548-1-seanjc@google.com>
Message-Id: <20220512222716.4112548-3-seanjc@google.com>
Mime-Version: 1.0
References: <20220512222716.4112548-1-seanjc@google.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
Subject: [PATCH 2/3] KVM: x86: Use explicit case-statements for MCx banks in {g,s}et_msr_mce()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jue Wang <juew@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use an explicit case statement to grab the full range of MCx bank MSRs
in {g,s}et_msr_mce(), and manually check only the "end" (the number of
banks configured by userspace may be less than the max).  The "default"
trick works, but is a bit odd now, and will be quite odd if/when support
for accessing MCx_CTL2 MSRs is added, which has near identical logic.

Hoist "offset" to function scope so as to avoid curly braces for the case
statement, and because MCx_CTL2 support will need the same variables.

Opportunstically clean up the comment about allowing bit 10 to be cleared
from bank 4.

No functional change intended.

Cc: Jue Wang <juew@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 71 ++++++++++++++++++++++++----------------------
 1 file changed, 37 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bc6db58975dc..7e685ea9882b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3206,6 +3206,7 @@ static int set_msr_mce(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	unsigned bank_num = mcg_cap & 0xff;
 	u32 msr = msr_info->index;
 	u64 data = msr_info->data;
+	u32 offset, last_msr;
 
 	switch (msr) {
 	case MSR_IA32_MCG_STATUS:
@@ -3219,32 +3220,33 @@ static int set_msr_mce(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 		vcpu->arch.mcg_ctl = data;
 		break;
+	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
+		last_msr = MSR_IA32_MCx_CTL(bank_num) - 1;
+		if (msr > last_msr)
+			return 1;
+
+		offset = array_index_nospec(msr - MSR_IA32_MC0_CTL,
+					    last_msr + 1 - MSR_IA32_MC0_CTL);
+
+		/*
+		 * Only 0 or all 1s can be written to IA32_MCi_CTL, all other
+		 * values are architecturally undefined.  But, some Linux
+		 * kernels clear bit 10 in bank 4 to workaround a BIOS/GART TLB
+		 * issue on AMD K8s, allow bit 10 to be clear when setting all
+		 * other bits in order to avoid an uncaught #GP in the guest.
+		 */
+		if ((offset & 0x3) == 0 &&
+		    data != 0 && (data | (1 << 10)) != ~(u64)0)
+			return 1;
+
+		/* MCi_STATUS */
+		if (!msr_info->host_initiated && (offset & 0x3) == 1 &&
+		    data != 0 && !can_set_mci_status(vcpu))
+			return 1;
+
+		vcpu->arch.mce_banks[offset] = data;
+		break;
 	default:
-		if (msr >= MSR_IA32_MC0_CTL &&
-		    msr < MSR_IA32_MCx_CTL(bank_num)) {
-			u32 offset = array_index_nospec(
-				msr - MSR_IA32_MC0_CTL,
-				MSR_IA32_MCx_CTL(bank_num) - MSR_IA32_MC0_CTL);
-
-			/* only 0 or all 1s can be written to IA32_MCi_CTL
-			 * some Linux kernels though clear bit 10 in bank 4 to
-			 * workaround a BIOS/GART TBL issue on AMD K8s, ignore
-			 * this to avoid an uncatched #GP in the guest
-			 */
-			if ((offset & 0x3) == 0 &&
-			    data != 0 && (data | (1 << 10)) != ~(u64)0)
-				return 1;
-
-			/* MCi_STATUS */
-			if (!msr_info->host_initiated &&
-			    (offset & 0x3) == 1 && data != 0) {
-				if (!can_set_mci_status(vcpu))
-					return 1;
-			}
-
-			vcpu->arch.mce_banks[offset] = data;
-			break;
-		}
 		return 1;
 	}
 	return 0;
@@ -3789,6 +3791,7 @@ static int get_msr_mce(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
 	u64 data;
 	u64 mcg_cap = vcpu->arch.mcg_cap;
 	unsigned bank_num = mcg_cap & 0xff;
+	u32 offset, last_msr;
 
 	switch (msr) {
 	case MSR_IA32_P5_MC_ADDR:
@@ -3806,16 +3809,16 @@ static int get_msr_mce(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata, bool host)
 	case MSR_IA32_MCG_STATUS:
 		data = vcpu->arch.mcg_status;
 		break;
-	default:
-		if (msr >= MSR_IA32_MC0_CTL &&
-		    msr < MSR_IA32_MCx_CTL(bank_num)) {
-			u32 offset = array_index_nospec(
-				msr - MSR_IA32_MC0_CTL,
-				MSR_IA32_MCx_CTL(bank_num) - MSR_IA32_MC0_CTL);
+	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
+		last_msr = MSR_IA32_MCx_CTL(bank_num) - 1;
+		if (msr > last_msr)
+			return 1;
 
-			data = vcpu->arch.mce_banks[offset];
-			break;
-		}
+		offset = array_index_nospec(msr - MSR_IA32_MC0_CTL,
+					    last_msr + 1 - MSR_IA32_MC0_CTL);
+		data = vcpu->arch.mce_banks[offset];
+		break;
+	default:
 		return 1;
 	}
 	*pdata = data;
-- 
2.36.0.550.gb090851708-goog

