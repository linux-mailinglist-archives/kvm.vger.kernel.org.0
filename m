Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAF2FA769C
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 23:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbfICV6N (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 17:58:13 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:52931 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbfICV6N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 17:58:13 -0400
Received: by mail-pf1-f201.google.com with SMTP id r17so13825059pfr.19
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2019 14:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=JSryJzYZ9PIhYaiF8Id4XIwHE6X9RIx2Lk1b+qLQLNs=;
        b=ks/oEu66jZHhGVVy5s0324/EZ7rOy3Ql6s3n4x/MEqRMZrzn+OUzaTcb1u3QNiSbFg
         cNk5EC7wUqB88Ambim1v+dBj72q5rtiIr+xNJT9Kq6/iL2YkrHqZSfZkNrVpmQgprItC
         Ane/Nyqh/BKuJR4lriyo92sIbYqZuMjn9CuyV2CuehJ5cbSWns3JVjIaT6UJpHklskPC
         B5AZ06WhDPSrV1F/vdfeDCsVpi+yLobXZHmbhbRSDfC+ZlWVR/EWC4fPBBtJ1Mz1iDaP
         8N73HyiMKYeBF8AuIUpGm2qh1VMmy1uhk47GSIG0IJ5v4oKpAhLI0ioyi2IE0t8nGerY
         UMUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=JSryJzYZ9PIhYaiF8Id4XIwHE6X9RIx2Lk1b+qLQLNs=;
        b=aFS0Fl7nwEVnQyCWF0YgssqDQZB2qT/Ogdvup12ffNstG5Bg2FAsKEfr+M7EqX0HsM
         IqO1dTgBVyBaEh5HoqnUuxwJd2/vaOzVHxnEOxvpgwvE2N90LGq9GePDEdm9ByNTDhOS
         tzB80tJ6tjcsBIs5DFY7Q2rNHYkKqHXnJrv0l6wU9L712rWPkajBl/oQeubK//dqDO6N
         eemtghU24jSpejM2H/Pv6iXt3BTo44ikvAS9pckpxWaUg8ryZtJON+SKOSerOEA0dL5x
         nYMjqMMEqA+2V72m8qgAJQntEqEMXlJEylubvulASnifZPA8xh9C5M2D9PqHTMOh6z3N
         W0Jg==
X-Gm-Message-State: APjAAAVqbd6vwmuhNEVJyKkTQM3v+7t2QT0H0IcnRLIXfzef+2EnXtYQ
        HePxtM1ZwwiZ4ycpBT+X86mDRuMt5UvaykKBNli+uaGuDHQbClCbeuikMEslSE7wLVPOSHCJfOs
        1m+Hz7vShOdDLpCugPaxknNsX4ELs/85fEFZHwfNO9BtlBuzk8wQYk9epPQ==
X-Google-Smtp-Source: APXvYqxAkxLsaAqjDGK3fMNdYwwrHtOMVVexaOGxjd1TziFl84bKa8uAWVC67iEv9N5/G+fsS7P9l2DzhJo=
X-Received: by 2002:a65:50c5:: with SMTP id s5mr32209259pgp.368.1567547891904;
 Tue, 03 Sep 2019 14:58:11 -0700 (PDT)
Date:   Tue,  3 Sep 2019 14:57:56 -0700
In-Reply-To: <20190903215801.183193-1-oupton@google.com>
Message-Id: <20190903215801.183193-4-oupton@google.com>
Mime-Version: 1.0
References: <20190903215801.183193-1-oupton@google.com>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [PATCH v3 3/8] KVM: VMX: Add helper to check reserved bits in IA32_PERF_GLOBAL_CTRL
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
---
 arch/x86/kvm/pmu.h           | 6 ++++++
 arch/x86/kvm/vmx/pmu_intel.c | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 58265f761c3b..67a0f6da567c 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -79,6 +79,12 @@ static inline bool pmc_is_enabled(struct kvm_pmc *pmc)
 	return kvm_x86_ops->pmu_ops->pmc_is_enabled(pmc);
 }
 
+static inline bool kvm_is_valid_perf_global_ctrl(struct kvm_pmu *pmu,
+						 u64 data)
+{
+	return !(pmu->global_ctrl_mask & data);
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

