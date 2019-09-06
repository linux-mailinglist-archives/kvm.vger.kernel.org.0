Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BBB9AC1CF
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 23:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390140AbfIFVDb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 17:03:31 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:39609 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389992AbfIFVDb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 17:03:31 -0400
Received: by mail-pl1-f202.google.com with SMTP id d11so4239035plo.6
        for <kvm@vger.kernel.org>; Fri, 06 Sep 2019 14:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=F82gU2FvtpQ8URB34nFaQufQUb4iZ46jG4tIG0b8NEE=;
        b=vcIEhH0bWHonZUSACAHDEgBUk4gdUuZgZQuCGej8/RnTqK/SjI/X1YIxXUJNZ+SZq+
         QpK3kElpES3fGbE3vU1/TOQQ3u+AisKg5NVQs2ZzafInDrLPB14dEJvViIcdisk+xjAh
         HyOOxn5tRx3baXw5+Tw6DmGRFGyzWaLtbUZBDDyZuwKAIib1YrnnnCA0qrZqTQBSggP5
         4kYbtZ+KcKlxbKMo4wbfZr3RxLRulwCZWNZ7yeWavKPdzXP3ACsTuHiQAOwnsG6UgqbM
         5ipnlxuE7lpOQQ1o3IInGVlJ6fEmhrHzSYBvKvqb3XzikZNCkig6tZHSqHrwcoHWVOu7
         xojA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=F82gU2FvtpQ8URB34nFaQufQUb4iZ46jG4tIG0b8NEE=;
        b=P/kFzM+A/FRk4ertdUHivtFPRHA6B1E9j03pDJH/tHR+xntNtJDSudCEwlFlkIAGaf
         5PwwTs8v3DIlfr9LcHwMLfXugO+Y4vL5sMxtLqpfmawOmT7E592NTghjKWHCKoToqruq
         eQ5Krou+A0vTwanyt3zlpW+kcIxK1oG0YXu1RpH1d1pclQmTu/t2TenDeqx7+ab8g9o8
         JjheZI1WxArxaHPit9dmCxfIvp9fiykMvzFqLASgwnfjaHdntdWEfIiWwLcw8+lwjpSi
         Ra8gfq1h9k1JG8NQ68HgVEYo2GcZWj8/mZ5j0CzlMpwPvd3kO4JY2EsHf+Zmd8S5dVf3
         WV6g==
X-Gm-Message-State: APjAAAUOFZgF2Fd1HzhQe892LT6C/1ryM9hCkFMARjYb1u9C8wP5TtTj
        zRC4b9k3bxKWIAuxM5rnmPvIewMXg4cxehxk3Ocj6zr+xVxCJCDeBYNu88y25IS3YlAqkdOagC0
        nmmEf45Bb+V0C3Ocdk4fVbrxBb36KMO5MSsKZpfoSk2rzcqAZWWaX4v7GgQ==
X-Google-Smtp-Source: APXvYqwsQXEI2CotXMMd67Xi5BiQT5CnPI3FqossniK+/WqVymBFzubR/kFmEHB8t2j/fn+EV1+GrUPsGT0=
X-Received: by 2002:a65:68c9:: with SMTP id k9mr9668492pgt.28.1567803809989;
 Fri, 06 Sep 2019 14:03:29 -0700 (PDT)
Date:   Fri,  6 Sep 2019 14:03:08 -0700
In-Reply-To: <20190906210313.128316-1-oupton@google.com>
Message-Id: <20190906210313.128316-5-oupton@google.com>
Mime-Version: 1.0
References: <20190906210313.128316-1-oupton@google.com>
X-Mailer: git-send-email 2.23.0.187.g17f5b7556c-goog
Subject: [PATCH v4 4/9] KVM: nVMX: check GUEST_IA32_PERF_GLOBAL_CTRL on VM-Entry
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
Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
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

