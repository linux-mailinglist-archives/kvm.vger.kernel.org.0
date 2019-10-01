Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 384F0C35C4
	for <lists+kvm@lfdr.de>; Tue,  1 Oct 2019 15:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388433AbfJANdM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Oct 2019 09:33:12 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35531 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726710AbfJANdL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Oct 2019 09:33:11 -0400
Received: by mail-wr1-f67.google.com with SMTP id v8so15585966wrt.2;
        Tue, 01 Oct 2019 06:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=c4RlMElRapjcKytoDFpBCb3LWrmJDVBw/FZtdDDpZ7M=;
        b=ReaAukldOTH7DgxKYY1FpLm0deK+WPWVtPBXFNwMoZpHBlAqxrnJ5iwa7AlOltDiad
         ci5R/iWReKZ9jPh2M+b2zSrcl9Go4kGDztbpvC5uanP73qT5bxyQvH7Qw3BmkpwxkY4f
         6Uj8n9CEhlSSRKftU1ZwCUUtnu/mLjH/2+rrcbMKMcq+Swp2CVy9mWXEtocmMWwKK9YO
         204nTn+MhW9F5ogSr8xns5C/GiwxN5vuMLl+9g1ud1cpdFLLGssKcOmtrSUw5Z/+yamj
         pdL1zRC1GUCNHNQpsx6/gYnhMIjm0pgjL5hyWLa5lCAwpF6X7+9QzIIBtecfrgI2bnPW
         Kr5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=c4RlMElRapjcKytoDFpBCb3LWrmJDVBw/FZtdDDpZ7M=;
        b=iWPrQdhb+TDU+DPPBV5b3f39Wfv/FVtQnDthLEOOw3HA0YR5T23996lwvKg0e+bv3j
         6IwRWEtPrk6p7OutmjO5KQb1r1xrn0f4iql1PcbwqNWd3Xzv1WlwRI0bT7Wo4ZXJ3yp6
         0nhxpS/Tj3g3Yd/vxih1oREUhWJOzfSmCzFnFcFjkYOO3/25DF01HOGZy+hHsJ41euvR
         Ylexd9V4a1JYUnNu2AvEbC40IyZB5fzkZ2P3Jc0Maq5nG7PhaJAQYUlkiFvtQlwnlx0g
         3awJKkc+Sml/vluI+PPuNAWNeaWJ6q2z6TegLXHCRIHKAX2/ylq/aoSrgkSLGdCARsi+
         tdoA==
X-Gm-Message-State: APjAAAXxbzWij6oKK7ItzCClv5VVUKiz6m8qOp2UgUy4jYIlchiRWQBk
        eoM5L5c2lA+duaTFeNyaitTZT4TG
X-Google-Smtp-Source: APXvYqwC2c5XZwSfhL82+feZqCE+1GNRkJYO4+W95yyUGIENFaeaJrv0VmZlL3HZmbAfB6VThUyFMg==
X-Received: by 2002:adf:828d:: with SMTP id 13mr18346412wrc.115.1569936789559;
        Tue, 01 Oct 2019 06:33:09 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id u25sm3091302wml.4.2019.10.01.06.33.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Oct 2019 06:33:08 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, Jim Mattson <jamttson@google.com>
Subject: [PATCH] KVM: x86: omit "impossible" pmu MSRs from MSR list
Date:   Tue,  1 Oct 2019 15:33:07 +0200
Message-Id: <1569936787-56615-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

INTEL_PMC_MAX_GENERIC is currently 32, which exceeds the 18
contiguous MSR indices reserved by Intel for event selectors.
Since some machines actually have MSRs past the reserved range,
these may survive the filtering of msrs_to_save array and would
be rejected by KVM_GET/SET_MSR.  Cut the list to 18 entries to
avoid this.

Reported-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Jim Mattson <jamttson@google.com>
Fixes: e2ada66ec418 ("kvm: x86: Add Intel PMU MSRs to msrs_to_save[]", 2019-08-21)
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8072acaaf028..e6b5cfe3c345 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1169,13 +1169,6 @@ bool kvm_rdpmc(struct kvm_vcpu *vcpu)
 	MSR_ARCH_PERFMON_PERFCTR0 + 12, MSR_ARCH_PERFMON_PERFCTR0 + 13,
 	MSR_ARCH_PERFMON_PERFCTR0 + 14, MSR_ARCH_PERFMON_PERFCTR0 + 15,
 	MSR_ARCH_PERFMON_PERFCTR0 + 16, MSR_ARCH_PERFMON_PERFCTR0 + 17,
-	MSR_ARCH_PERFMON_PERFCTR0 + 18, MSR_ARCH_PERFMON_PERFCTR0 + 19,
-	MSR_ARCH_PERFMON_PERFCTR0 + 20, MSR_ARCH_PERFMON_PERFCTR0 + 21,
-	MSR_ARCH_PERFMON_PERFCTR0 + 22, MSR_ARCH_PERFMON_PERFCTR0 + 23,
-	MSR_ARCH_PERFMON_PERFCTR0 + 24, MSR_ARCH_PERFMON_PERFCTR0 + 25,
-	MSR_ARCH_PERFMON_PERFCTR0 + 26, MSR_ARCH_PERFMON_PERFCTR0 + 27,
-	MSR_ARCH_PERFMON_PERFCTR0 + 28, MSR_ARCH_PERFMON_PERFCTR0 + 29,
-	MSR_ARCH_PERFMON_PERFCTR0 + 30, MSR_ARCH_PERFMON_PERFCTR0 + 31,
 	MSR_ARCH_PERFMON_EVENTSEL0, MSR_ARCH_PERFMON_EVENTSEL1,
 	MSR_ARCH_PERFMON_EVENTSEL0 + 2, MSR_ARCH_PERFMON_EVENTSEL0 + 3,
 	MSR_ARCH_PERFMON_EVENTSEL0 + 4, MSR_ARCH_PERFMON_EVENTSEL0 + 5,
@@ -1185,13 +1178,6 @@ bool kvm_rdpmc(struct kvm_vcpu *vcpu)
 	MSR_ARCH_PERFMON_EVENTSEL0 + 12, MSR_ARCH_PERFMON_EVENTSEL0 + 13,
 	MSR_ARCH_PERFMON_EVENTSEL0 + 14, MSR_ARCH_PERFMON_EVENTSEL0 + 15,
 	MSR_ARCH_PERFMON_EVENTSEL0 + 16, MSR_ARCH_PERFMON_EVENTSEL0 + 17,
-	MSR_ARCH_PERFMON_EVENTSEL0 + 18, MSR_ARCH_PERFMON_EVENTSEL0 + 19,
-	MSR_ARCH_PERFMON_EVENTSEL0 + 20, MSR_ARCH_PERFMON_EVENTSEL0 + 21,
-	MSR_ARCH_PERFMON_EVENTSEL0 + 22, MSR_ARCH_PERFMON_EVENTSEL0 + 23,
-	MSR_ARCH_PERFMON_EVENTSEL0 + 24, MSR_ARCH_PERFMON_EVENTSEL0 + 25,
-	MSR_ARCH_PERFMON_EVENTSEL0 + 26, MSR_ARCH_PERFMON_EVENTSEL0 + 27,
-	MSR_ARCH_PERFMON_EVENTSEL0 + 28, MSR_ARCH_PERFMON_EVENTSEL0 + 29,
-	MSR_ARCH_PERFMON_EVENTSEL0 + 30, MSR_ARCH_PERFMON_EVENTSEL0 + 31,
 };
 
 static unsigned num_msrs_to_save;
-- 
1.8.3.1

