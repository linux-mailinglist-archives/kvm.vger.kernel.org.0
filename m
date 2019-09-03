Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28458A7636
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 23:31:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbfICVbM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 17:31:12 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:49834 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbfICVbM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 17:31:12 -0400
Received: by mail-pf1-f202.google.com with SMTP id i28so8942279pfq.16
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2019 14:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=fni4sbTk3PDo/Mafy67bUGgpDjVb3g2Zd09Nxf1c4FY=;
        b=JbYTNAMfo2u1zQ9YMFr6fcRZRUrhZBU7wJv7DCi+dRJaewbehbh0Xacf2Cx/+YfKdA
         CP9UwevzmmZR10VkqCd2iVURcn5tK/MsEdXVp7MrlYSB1EFro0v8x0merGSxbdwniNS9
         mcENNy3n/OThC5XfJ2Ir061qXohiK3CuxRMJ32BlEX3vGlpOaIhD/vXiVPWJWyp4cVOn
         GH97rWltADTH13uBmGGi7Sw2R1pbYuB0FThVp7a4k9cmhrIS+xG+0Et/+cMB2qDUbYOP
         zvzcDHNM+HH/nd/CIrvojGgDm/vspbgUL4KoiGG7SVI+dT6FGk0Wkl/ptrOz8URIuoEq
         +iqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=fni4sbTk3PDo/Mafy67bUGgpDjVb3g2Zd09Nxf1c4FY=;
        b=nvm7N6lTjCkqLJpzYkFtULUltggUgaQeEszaDm6F/Fcf/1aTVKywmDqgO+v8a4OKAm
         8cw3mvlKewIqf07VjfpHzTYXEPjL5xdM1YI1WK8MH7ZidZaqDM3xqi/3Pl/C005BHoHb
         XFZOkk0Cgx0qgXzYlCKgKBe+Nk+sUEc6QNezoMppJ7RdaOlUZcVR6f+wS33z56HTH06b
         q3gEuqUD85tmzT92oSE2oARI4gamCCGHmI7aryoZdmAKpY4/tT94VfPgpddEuMOnJk7F
         3dEl7nbub9tp7bw1T86rfvn4W4G3C5SrznIS3f8tVXBEU2NKGJP8qukAlrV37NBKFfUd
         aAFA==
X-Gm-Message-State: APjAAAV/026nxkQdV5F7iKR3KYD/7SWOYVtUDbjJKv7DQENwbKv3yJQE
        fH/9Nf3IaDDOr0gF6fZdojLVe75E0TxNigumvO8zCpTPwWbHohvjJYOb14BAL7CSnAH5Y21Ewwr
        yMoFfQZHV61ZTYDbzdQfcFDY/z8OPmAUcWMf3LvzEUDY4OgIPCDfd5axNiw==
X-Google-Smtp-Source: APXvYqw0k0hIQrYZT7goF8yKV9HAziZqZMQ+SrmvBzDftKhJ7dYfENRVx1oBCpF6ht3GE/ZKZOjeJcYHkaU=
X-Received: by 2002:a63:fe15:: with SMTP id p21mr32407276pgh.149.1567546271062;
 Tue, 03 Sep 2019 14:31:11 -0700 (PDT)
Date:   Tue,  3 Sep 2019 14:30:39 -0700
In-Reply-To: <20190903213044.168494-1-oupton@google.com>
Message-Id: <20190903213044.168494-4-oupton@google.com>
Mime-Version: 1.0
References: <20190903213044.168494-1-oupton@google.com>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [PATCH v2 3/8] KVM: VMX: Add helper to check reserved bits in IA32_PERF_GLOBAL_CTRL
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        "=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?=" <rkrcmar@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Create a helper function to check the validity of a proposed value for
IA32_PERF_GLOBAL_CTRL from the existing check in intel_pmu_set_msr().

Suggested-by: Jim Mattson <jmattson@google.com>
Co-developed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/pmu.h           | 6 ++++++
 arch/x86/kvm/vmx/pmu_intel.c | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 58265f761c3b..779427b44c2f 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -79,6 +79,12 @@ static inline bool pmc_is_enabled(struct kvm_pmc *pmc)
 	return kvm_x86_ops->pmu_ops->pmc_is_enabled(pmc);
 }
 
+static inline bool kvm_is_valid_perf_global_ctrl(struct kvm_pmu *pmu,
+						 u64 data)
+{
+	return pmu->global_ctrl == data || !(pmu->global_ctrl_mask & data);
+}
+
 /* returns general purpose PMC with the specified MSR. Note that it can be
  * used for both PERFCTRn and EVNTSELn; that is why it accepts base as a
  * paramenter to tell them apart.
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 4dea0e0e7e39..963766d631ad 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -223,7 +223,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_CORE_PERF_GLOBAL_CTRL:
 		if (pmu->global_ctrl == data)
 			return 0;
-		if (!(data & pmu->global_ctrl_mask)) {
+		if (kvm_is_valid_perf_global_ctrl(pmu, data)) {
 			global_ctrl_changed(pmu, data);
 			return 0;
 		}
-- 
2.23.0.187.g17f5b7556c-goog

