Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCA663F2332
	for <lists+kvm@lfdr.de>; Fri, 20 Aug 2021 00:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236194AbhHSWhX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 18:37:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232906AbhHSWhX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Aug 2021 18:37:23 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85BFEC061575
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 15:36:46 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id f8-20020a2585480000b02905937897e3daso7962599ybn.2
        for <kvm@vger.kernel.org>; Thu, 19 Aug 2021 15:36:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=7MocV+zQPclsTGs3NFoQy/CJHXoVS8FPe3HyXWpOfLI=;
        b=JH+Naz2YWe6tlv1DbwAqHD8pyGp86U036FRjmuKxFKD3drI/nO6SVyjF9AYtfxkhSI
         9Yw6QFF8ihOvGTFaiJAYC8u5MSO3iwVmu31FiKHcJMRF4+/i8+B/rgZRIyABgFk7hgi1
         sIrpOPkuMVSSN2WN68NkilXSfz9okPy8eTkNAXNEkeB9CHySAlz/hRQzEjnSuR++RbzX
         CNbRx3Wp3rqlx4nmkSWegGRYNcKzlefd7b1qIHADD3Ca02pXvvRMDlOsNJDBV3XTLks0
         LAEBYRgJ83wHpXIR0LhlJNcNgaWXU3XxMbUGmnz4/+Yj3WJQEezr9f5p1AOJWhmePBMC
         g7MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=7MocV+zQPclsTGs3NFoQy/CJHXoVS8FPe3HyXWpOfLI=;
        b=mjKMisUMVkMx6ml5GnYQKvX5Neso+skFzKNCVK0nhgRTPFF1Zh621RxAxaHXSJZ71E
         3n9g+oeux7l3REw/exYY4aeJ/9BJME0tn4AxgkpU8YhSv3vDXirWer1Bup56wURG5kZw
         WzaDiO9dRxcBAIm0OMXx6SU1sl2ehqDYRZddVokajlZ/GKpSPyFWh1PzbNC00shYXBKp
         B7LcFuC/UcTISc/qpgoc3bS7uAzCDfY8pvC6pdXHV8UmjQ4tErrJcJPXadlGBmLo4gvt
         RDeQz3ucypc4LwEE6YqPClnsoNq4DICk85qFDLoWmGEQx9GNsS/6oW1lxfN60ZxhTgSc
         Yl1w==
X-Gm-Message-State: AOAM532ylXqlae2msnUJlXU6/K7XzV3fPhUwl9hxntITPcubmszDIS27
        Om3Nf8vwIANm1X8sj0IJ+qciXACEdUTorVgHxfDyv7xPXfs/H2UirngY6KBm3L36p6u84G+E6q/
        oUD1+6+YcxkMrWuW0V+WT7oLVMH08uCxQmp1iLmIEgrRF+Gf0VTkoVQI+IA==
X-Google-Smtp-Source: ABdhPJwt1ogHucAHaphAZBWzPxt0QIqGHZGzqIb/0MTJvBKznzm60whzPOY/xCxgZLsfY8ECcW2KM57MkAU=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a25:7ac6:: with SMTP id v189mr21050262ybc.485.1629412605729;
 Thu, 19 Aug 2021 15:36:45 -0700 (PDT)
Date:   Thu, 19 Aug 2021 22:36:36 +0000
In-Reply-To: <20210819223640.3564975-1-oupton@google.com>
Message-Id: <20210819223640.3564975-3-oupton@google.com>
Mime-Version: 1.0
References: <20210819223640.3564975-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
Subject: [PATCH 2/6] KVM: arm64: Clean up SMC64 PSCI filtering for AArch32 guests
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The only valid calling SMC calling convention from an AArch32 state is
SMC32. Disallow any PSCI function that sets the SMC64 function ID bit
when called from AArch32 rather than comparing against known SMC64 PSCI
functions.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/psci.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index d46842f45b0a..310b9cb2b32b 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -208,15 +208,11 @@ static void kvm_psci_narrow_to_32bit(struct kvm_vcpu *vcpu)
 
 static unsigned long kvm_psci_check_allowed_function(struct kvm_vcpu *vcpu, u32 fn)
 {
-	switch(fn) {
-	case PSCI_0_2_FN64_CPU_SUSPEND:
-	case PSCI_0_2_FN64_CPU_ON:
-	case PSCI_0_2_FN64_AFFINITY_INFO:
-		/* Disallow these functions for 32bit guests */
-		if (vcpu_mode_is_32bit(vcpu))
-			return PSCI_RET_NOT_SUPPORTED;
-		break;
-	}
+	/*
+	 * Prevent 32 bit guests from calling 64 bit PSCI functions.
+	 */
+	if ((fn & PSCI_0_2_64BIT) && vcpu_mode_is_32bit(vcpu))
+		return PSCI_RET_NOT_SUPPORTED;
 
 	return 0;
 }
-- 
2.33.0.rc2.250.ged5fa647cd-goog

