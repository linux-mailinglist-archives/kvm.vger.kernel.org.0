Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 115F5FBCEA
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 01:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbfKNARh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 19:17:37 -0500
Received: from mail-ua1-f73.google.com ([209.85.222.73]:36708 "EHLO
        mail-ua1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726195AbfKNARg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 19:17:36 -0500
Received: by mail-ua1-f73.google.com with SMTP id r39so1066066uad.3
        for <kvm@vger.kernel.org>; Wed, 13 Nov 2019 16:17:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=k+kFDmW+TZm9uAXFmGbrnJC5CPVNW5UAKaPtdur5YLA=;
        b=nb+hQLZC15W0K8WXRmuQy4fdq0rp5A4JbyupyxdXgL2X3VhQPx23GRz4EAcNgaCWlN
         wQ+aRlFjAJQ2MlwNjc5hIyqHU7HLxoNy1ts1s93b6f8JsgW1h6KIo47EDS1sX4ElD+Sy
         q06A8vJ7LWdUCphs18CBwzfh+XXgzRxnB7WvF0kGMjy0P3Arx8qhE/IRweOdUmbYlWlk
         Q2a4vTVh/uTOqqQv4eSD9IAzen8mdbyvt8gZMiOl7c66MdESQMTzBuwfU+A4Kk62sFTH
         sNR5oEKJdZUbEVcRBqatvxgLOHz3apKKscxYAhjP6QSf+0NRk64pSfLgofRWgW011NqA
         o0Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=k+kFDmW+TZm9uAXFmGbrnJC5CPVNW5UAKaPtdur5YLA=;
        b=uYVmRiP7FCO/fzEvxhGPuhZx/wyMZzHgdLYe0jfsgFksCqSU4bmM4IVUsbHcl1JoU/
         2+CZtcghE8BS2zU1RRk8T+kwAKun5l0JW6/RDHkOVIHQgqihMQqcVc8zbgI86HvFNhZu
         alouIqEy9S7r6UuUk2qdqDorGN8SlcbAb2Yq2vK446RVHGouJS1fs6xToyUjcwIVfj0R
         JStzecPd2TN5JVgM5thcMsYHVQxrVkkDIA4HDDNboCpvIPrXIURmch8nu8be4IgAbqpT
         1bY/XemFdjSs8d7KTAb7npYOfN75tDIDMGSdPSy7YeVR3NvUSgA2180KzwWcJ2U45sYx
         bCtQ==
X-Gm-Message-State: APjAAAUDxE5uYcW5xB4xk3/gPn0ly6y81boN95MKMZ3Z9dXvRtAZdzs3
        NUmc5WQNO/OcxdkZp2kH85dUIhUzclzDOLOwgWRymxaB+9S29h4w9VvCye8trRaP5KFd0hyQTDz
        jQdALkRCqY1oO2gXepbqyUO3YiHSqBTXVgX/Crs4q0JxLgUuPJfe5irLrxQ==
X-Google-Smtp-Source: APXvYqwna/gXQTrY9o3e39CR7hive+a2govJYQk8eL/5hYoyxFh3SYxseEVMt871AFGLc3oT3jqWQXPbWR8=
X-Received: by 2002:ab0:7d2:: with SMTP id d18mr4059285uaf.68.1573690653917;
 Wed, 13 Nov 2019 16:17:33 -0800 (PST)
Date:   Wed, 13 Nov 2019 16:17:15 -0800
In-Reply-To: <20191114001722.173836-1-oupton@google.com>
Message-Id: <20191114001722.173836-2-oupton@google.com>
Mime-Version: 1.0
References: <20191114001722.173836-1-oupton@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH v5 1/8] KVM: VMX: Add helper to check reserved bits in IA32_PERF_GLOBAL_CTRL
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

Per Intel's SDM, the reserved bits in IA32_PERF_GLOBAL_CTRL must be
cleared for the corresponding host/guest state fields.

Suggested-by: Jim Mattson <jmattson@google.com>
Co-developed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
---
 arch/x86/kvm/pmu.h           | 6 ++++++
 arch/x86/kvm/vmx/pmu_intel.c | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 58265f761c3b..1631ac852ce0 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -79,6 +79,12 @@ static inline bool pmc_is_enabled(struct kvm_pmc *pmc)
 	return kvm_x86_ops->pmu_ops->pmc_is_enabled(pmc);
 }
 
+static inline bool kvm_valid_perf_global_ctrl(struct kvm_pmu *pmu,
+						 u64 data)
+{
+	return !(pmu->global_ctrl_mask & data);
+}
+
 /* returns general purpose PMC with the specified MSR. Note that it can be
  * used for both PERFCTRn and EVNTSELn; that is why it accepts base as a
  * paramenter to tell them apart.
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 3e9c059099e9..8cd2cc2fe986 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -223,7 +223,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_CORE_PERF_GLOBAL_CTRL:
 		if (pmu->global_ctrl == data)
 			return 0;
-		if (!(data & pmu->global_ctrl_mask)) {
+		if (kvm_valid_perf_global_ctrl(pmu, data)) {
 			global_ctrl_changed(pmu, data);
 			return 0;
 		}
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

