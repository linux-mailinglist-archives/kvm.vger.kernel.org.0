Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8483942673C
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 11:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239274AbhJHKAY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 06:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238917AbhJHKAX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 06:00:23 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21251C061570;
        Fri,  8 Oct 2021 02:58:28 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id ls14-20020a17090b350e00b001a00e2251c8so7382919pjb.4;
        Fri, 08 Oct 2021 02:58:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Dl7BY6WNXJJR9fsH+L/LsbUXC1kBJ8G31nGkyKnWPnk=;
        b=i0zW1RkpVkhPeM+XnTF/oFumSHN7BZbp6ADLaHTvAp7OsWmj0XarVWungxSR9+81Hd
         A52R2UyvwoRFtydGAjdpnGTUXurGPjk6BlibAteLzsoCP5AkUqirZIcSyKSOIrhIqAQY
         w1Mpg5i26GxaRQX6tPY5DIrOXdlmlSnHUvbHIPpV8KWoUbd/aorJsm5VFcQdOXH5t1TZ
         o7AQDkLcvU4u7Ia6Ihe7kL113Qzowc1wQAlGnfY2O2RRehyzR39SbPARJgytJ7n2U9qE
         T9wb0OQwvazGEU7bBIHUSTXrntttzfw+7/FzyK8VXPtgWfHbnc5v6oOu3zJu1YsHsnry
         FZ/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Dl7BY6WNXJJR9fsH+L/LsbUXC1kBJ8G31nGkyKnWPnk=;
        b=nqIPEkK1GgC04zsmi+W3wIUHPIi9cPMpnaA25DV8qc1BDdxaL8pU72mtCDvJAQwicj
         7eZwozKnAql3EA+3Q9jho7/eXZUH1ME78s1n6rvAUwSSd8Gf7tjGX1tag5U107zjJhAK
         Mu+hbkv/nue0HL2KIaeNC+bzifGVYwzworvcKMz56gwWjxQyY8RMcT710IK4MtUBMG06
         OTkoXrKMMiz06krrXAVyHvPM/Rh8nYbAa8pjSDMDtLKAEuWwWlveu3uRlRW2GglicjWB
         tqQXzwY+w3+M9VFhexZ/mkVDlc2NSv3b8jnjnudgEh1NY3zj1/AKoMf8TIdbB3/ITbQY
         Jtxg==
X-Gm-Message-State: AOAM531757uW371u1VtG59PNnO8jJwPD1XQu/AO/8mAqIbSSj0lF4dny
        0vbjEuFkz3VJawjKbCQYfIYe8Il+YGR44Q==
X-Google-Smtp-Source: ABdhPJw/3xVjyJfbZbok1gzR3CkBi17qPMK9zFyU9VyOAl1ZVtaq4oOujGym6UVG4AGG4YTGaBdXjw==
X-Received: by 2002:a17:902:6849:b0:13e:97cf:416a with SMTP id f9-20020a170902684900b0013e97cf416amr8394395pln.79.1633687107468;
        Fri, 08 Oct 2021 02:58:27 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.117])
        by smtp.googlemail.com with ESMTPSA id mu7sm2121148pjb.12.2021.10.08.02.58.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Oct 2021 02:58:27 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 2/3] KVM: vPMU: Fill get_msr MSR_CORE_PERF_GLOBAL_OVF_CTRL w/ 0
Date:   Fri,  8 Oct 2021 02:57:33 -0700
Message-Id: <1633687054-18865-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1633687054-18865-1-git-send-email-wanpengli@tencent.com>
References: <1633687054-18865-1-git-send-email-wanpengli@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

SDM section 18.2.3 mentioned that:

  "IA32_PERF_GLOBAL_OVF_CTL MSR allows software to clear overflow indicator(s) of 
   any general-purpose or fixed-function counters via a single WRMSR."

It is R/W mentioned by SDM, we read this msr on bare-metal during perf testing, 
the value is always 0 for CLX/SKX boxes on hands. Let's fill get_msr
MSR_CORE_PERF_GLOBAL_OVF_CTRL w/ 0 as hardware behavior.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
Btw, xen also fills get_msr MSR_CORE_PERF_GLOBAL_OVF_CTRL 0.

 arch/x86/kvm/vmx/pmu_intel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 10cc4f65c4ef..47260a8563f9 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -365,7 +365,7 @@ static int intel_pmu_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		msr_info->data = pmu->global_ctrl;
 		return 0;
 	case MSR_CORE_PERF_GLOBAL_OVF_CTRL:
-		msr_info->data = pmu->global_ovf_ctrl;
+		msr_info->data = 0;
 		return 0;
 	default:
 		if ((pmc = get_gp_pmc(pmu, msr, MSR_IA32_PERFCTR0)) ||
-- 
2.25.1

