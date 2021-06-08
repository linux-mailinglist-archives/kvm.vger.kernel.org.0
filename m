Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A97DE39F898
	for <lists+kvm@lfdr.de>; Tue,  8 Jun 2021 16:12:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233185AbhFHOOE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 10:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233172AbhFHOOD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 10:14:03 -0400
Received: from mail-wr1-x449.google.com (mail-wr1-x449.google.com [IPv6:2a00:1450:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 027DAC061787
        for <kvm@vger.kernel.org>; Tue,  8 Jun 2021 07:12:10 -0700 (PDT)
Received: by mail-wr1-x449.google.com with SMTP id u5-20020adf9e050000b029010df603f280so9497462wre.18
        for <kvm@vger.kernel.org>; Tue, 08 Jun 2021 07:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=jp6fv0GP5OZMvO++5rX+YJvw+QWeN06SDMdZ+IsoUG0=;
        b=OPGc9RaxdbE4jC3Nv//QuI2Jsufzx1NecG16pksOv0KGZFsu+jQWG8OJ+DQZ/2CDb7
         LFyBKgXQSD1jXRXJSE9x5NaKjdXiIm+GtBtKKFt25YFO9mA79s+SF4YpGXZt1H15X2bx
         2mFt2oQz5XWvE06MsNy05geVWsUOMK7e0gvwzyMUMRKcY1GxXVSD6ET7BGv21Oo48p9W
         0QAvnB+NR2k52p+qiGx5aDr2ji0pztzmJJSg2gFz9Pxhn4VuD9KJA1FYmyETBfmJXzGS
         5o7NPPmVj1Nr/w/77PeoiO4acbt0s0rishsN36LfTVHRZVejvma+yDt8LCXCv2Q7Its8
         oHwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=jp6fv0GP5OZMvO++5rX+YJvw+QWeN06SDMdZ+IsoUG0=;
        b=KdysrBn+xCnReZ+Uy1WeBdckR3eAEX3tQlolUTNN9EqmKpB1a2hWfeOU4wn4SPZGV4
         iv8pgiHu0UVsTcPkADi272wMKMsYXxMtty34TVL+B+f7s6pVYdUZW+PAssvZqB9YOGW3
         9b3X1i5VURfNO1v1TqnKCuPI2DAgq2BKcw0i3TzXCBu0cEGoaILjkDbCuKYdjZN0Z8dM
         z0Qgr7uzf9AOO2Xi7jRxEIv/BEuUrQI/orbeWUMANGVtN4Jsr76njgErYQSY84n61/N/
         qvdBrCTpMvfO1h4oCEE+rovrxhFE32IAccPsLGNa90mqzc9hOjr7GKd2dXHyrnNjmaGy
         zolg==
X-Gm-Message-State: AOAM533/0XuMAVjmCIh6MpVYWp6Q6qEf7ZsDZyhzkmq270pZfidiYEXb
        tE+Pcsn4UOAIO0FrQfQNvnx39Hm77A==
X-Google-Smtp-Source: ABdhPJyHhizcjmweSCmSoFGB2PMDem+2OK12rFn1TS9WE8cTt6h356mgLMjU2sM0rpQ3SM5oD2nnES3tfw==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a7b:cc8f:: with SMTP id p15mr4535235wma.111.1623161528421;
 Tue, 08 Jun 2021 07:12:08 -0700 (PDT)
Date:   Tue,  8 Jun 2021 15:11:40 +0100
In-Reply-To: <20210608141141.997398-1-tabba@google.com>
Message-Id: <20210608141141.997398-13-tabba@google.com>
Mime-Version: 1.0
References: <20210608141141.997398-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH v1 12/13] KVM: arm64: Handle protected guests at 32 bits
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com,
        pbonzini@redhat.com, qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Protected KVM does not support protected AArch32 guests. However,
it is possible for the guest to force run AArch32, potentially
causing problems. Add an extra check so that if the hypervisor
catches the guest doing that, it can prevent the guest from
running again by resetting vcpu->arch.target and returning
ARM_EXCEPTION_IL.

Adapted from commit 22f553842b14 ("KVM: arm64: Handle Asymmetric
AArch32 systems")

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index d9f087ed6e02..672801f79579 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -447,6 +447,26 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 			write_sysreg_el2(read_sysreg_el2(SYS_ELR) - 4, SYS_ELR);
 	}
 
+	/*
+	 * Protected VMs are not allowed to run in AArch32. The check below is
+	 * based on the one in kvm_arch_vcpu_ioctl_run().
+	 * The ARMv8 architecture doesn't give the hypervisor a mechanism to
+	 * prevent a guest from dropping to AArch32 EL0 if implemented by the
+	 * CPU. If the hypervisor spots a guest in such a state ensure it is
+	 * handled, and don't trust the host to spot or fix it.
+	 */
+	if (unlikely(is_nvhe_hyp_code() &&
+		     kvm_vm_is_protected(kern_hyp_va(vcpu->kvm)) &&
+		     vcpu_mode_is_32bit(vcpu))) {
+		/*
+		 * As we have caught the guest red-handed, decide that it isn't
+		 * fit for purpose anymore by making the vcpu invalid.
+		 */
+		vcpu->arch.target = -1;
+		*exit_code = ARM_EXCEPTION_IL;
+		goto exit;
+	}
+
 	/*
 	 * We're using the raw exception code in order to only process
 	 * the trap if no SError is pending. We will come back to the
-- 
2.32.0.rc1.229.g3e70b5a671-goog

