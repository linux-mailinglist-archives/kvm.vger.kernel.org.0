Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1FEAA769D
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2019 23:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727102AbfICV6P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Sep 2019 17:58:15 -0400
Received: from mail-qt1-f201.google.com ([209.85.160.201]:44879 "EHLO
        mail-qt1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726925AbfICV6P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Sep 2019 17:58:15 -0400
Received: by mail-qt1-f201.google.com with SMTP id x11so20493334qtm.11
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2019 14:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Opg5K1QfrL8nEMY8t4QOtAKo0xuR0xFxDl5Hh7Z9H/0=;
        b=kBn3nfztver7r9D+hzMmnoPglCIssZB2FdcQTAlHzxYOpqfSCCCGptkaBJZ9xdqO8J
         mV7LJKJ/vemFGcLOEsPz/J2fYtmKUTkCSnfC7bGnfYzQaLuyrUqoTbi5yF7Xwl1CcZ1M
         Wf23ltbOYiXIpPjWPWVae22mUX8UvZVFncszCdGw0+6TZ8dcgFL6PgIKZ9OS6j+UZQ/I
         CvF+Zde64wiRZzGm7aIlbNjhpPhrFTA+eHF4IwAvVPGS3TvYTns1NoBJSVZI6aUSTnNs
         FmwRZ8o8dYWKWnQ7b0K2m1amoIrlrYnejORBny7Rt97j9EbCMeGcxGE9qibzOnGTLO6u
         xsxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Opg5K1QfrL8nEMY8t4QOtAKo0xuR0xFxDl5Hh7Z9H/0=;
        b=oVcdtCY+R1drZAIyE01hBrR+ufGt2Hdf8A+ZR3y8DRKYuSahTnjtvmYy0SB3uJ35EN
         rPoYvQaOSh6f0tRIu+2JricppviqO2F1yE78H8WkNS8MnSxmGCoLIdFZpBLZ/AoeQEgq
         vVxWXTWyEPMbn5lzFT8ERYNYkHrfNjIddx1uH/6SYXY6P4BTX2njGUMmLVJvz9mBGcrq
         xr72rmCisiVnOiUZOE3a7NbTf+/eNYbQpRFNZX10BaLm76OGH+IgGFT8liALdV2oaG8j
         d4SQAd7bjSXWNv3p1Uust924a9QijXcB23sfcE8Ynga9qs10IaD4iPX2kpJlTWPyqDVi
         EiJA==
X-Gm-Message-State: APjAAAUfVrfxt29RpLlIIvgP1q9nI55o4RFvULqSzBDDLG5jxtp829uw
        HrFLefSoLOUrIDYLkQAZ2T0u9jTufgjfjBqKSwczRF1LX0UL+D5yLiMP5f0dhMisj4sg0xoUgeY
        yTJIXpmsOUweWRBX9f2rqno1jCgTUGChzXr4uKXqFkz0xoCx9aqO5w9VVNg==
X-Google-Smtp-Source: APXvYqws81C6DD7UQhkw6fevjmRA8koAn5oqA6UujleS/CsVshy/hkxW0TdDQqYJ1vH8ZiDmMsKbqeOADZg=
X-Received: by 2002:ad4:4152:: with SMTP id z18mr12996110qvp.236.1567547894129;
 Tue, 03 Sep 2019 14:58:14 -0700 (PDT)
Date:   Tue,  3 Sep 2019 14:57:57 -0700
In-Reply-To: <20190903215801.183193-1-oupton@google.com>
Message-Id: <20190903215801.183193-5-oupton@google.com>
Mime-Version: 1.0
References: <20190903215801.183193-1-oupton@google.com>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [PATCH v3 4/8] KVM: nVMX: check GUEST_IA32_PERF_GLOBAL_CTRL on VM-Entry
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

Add condition to nested_vmx_check_guest_state() to check the validity of
GUEST_IA32_PERF_GLOBAL_CTRL. Per Intel's SDM Vol 3 26.3.1.1:

  If the "load IA32_PERF_GLOBAL_CTRL" VM-entry control is 1, bits
  reserved in the IA32_PERF_GLOBAL_CTRL MSR must be 0 in the field for that
  register.

Suggested-by: Jim Mattson <jmattson@google.com>
Co-developed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/x86/kvm/vmx/nested.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 9ba90b38d74b..6c3aa3bcede3 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -10,6 +10,7 @@
 #include "hyperv.h"
 #include "mmu.h"
 #include "nested.h"
+#include "pmu.h"
 #include "trace.h"
 #include "x86.h"
 
@@ -2732,6 +2733,7 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 					u32 *exit_qual)
 {
 	bool ia32e;
+	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
 
 	*exit_qual = ENTRY_FAIL_DEFAULT;
 
@@ -2748,6 +2750,11 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 	}
 
+	if (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PERF_GLOBAL_CTRL &&
+	    !kvm_is_valid_perf_global_ctrl(pmu,
+					   vmcs12->guest_ia32_perf_global_ctrl))
+		return -EINVAL;
+
 	/*
 	 * If the load IA32_EFER VM-entry control is 1, the following checks
 	 * are performed on the field for the IA32_EFER MSR:
-- 
2.23.0.187.g17f5b7556c-goog

