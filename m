Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12D9F4C4027
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 09:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238487AbiBYIbK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 03:31:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238511AbiBYIbE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 03:31:04 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10CE924CCCA;
        Fri, 25 Feb 2022 00:30:32 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id w37so4024132pga.7;
        Fri, 25 Feb 2022 00:30:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=08dZnPcbcEjsLsixEKzvBr6t5PDEzmVzsuJpexpNdVM=;
        b=T7B/Sav0v4MFvOOdwjzlV51pmJ00ntJj+hYf7wwrfzx+ybuR+/UaDuLgiVWSiOIBZd
         uTC70KX6L4pbRS3/vyh09c2GHIrG/mtSvpDnBZD9xc69RHFQOrjmFwY7TGmpetqFgGOA
         I8Yy20M78T0HOfkpGoJDFhUW118qDcpRmb7PZA/fNRsvqaNxX7noBteJYDob7eOFmTtQ
         yW/yBDVBydi4vZsDFSaPyizKoJtEn40vLsN0q31D6dNmKYVuAu4zw0ZAPUyS9HBSJyA7
         MltI/y9onP+7e2kLxb/5M/45H0J9K47nqfLqx3bbqHzNax5w26rG1xsmSnl1UoFGqUVM
         b3qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=08dZnPcbcEjsLsixEKzvBr6t5PDEzmVzsuJpexpNdVM=;
        b=itolMYfVk4+8++1L4bDMRrCEc2QvtXkqTqmk8wVgxXnSgY1C748i+z1SzJsXnPo2oW
         IzdBxeb7Vazd5zcHNXeHzOsf5L6/qfqb/zPH42NT/nQTDVI4X04KPZH8Teps5EpLKAU+
         AXDMvRmKC+ZMJoklaIIWz1rjgRUwD87cVxm1XXsNG/Rg441S+IhVmuhpcVz+hcTig/xx
         vf+OfpJ5vDvsgDF1Q4QNT4s3acX4PH4TjcQrVwvchOPOljyKvITUvrxLlH8ufksEPWmT
         8WaHCAXermpdePpek0++NehcRPZU97KoG4o3lO7hl27HOYRBfyrmJ1ksuFXw+1NiUmoP
         GvuA==
X-Gm-Message-State: AOAM530eZs7CGbEj5gUblkPrs9Lew3B0yKjR99u+SREjeR9ZJ8iq1Nqx
        AsY255uxb2KsV03CDhO+sLIkwPCy6ew=
X-Google-Smtp-Source: ABdhPJyz1uwmHJ/MQKkVuXJ9x5qn3LF0V/es/hM4FXOSm0nn1OsOW8SHF0cbvXLEXgHt2sog5I4qzw==
X-Received: by 2002:a63:4405:0:b0:376:a781:c9da with SMTP id r5-20020a634405000000b00376a781c9damr1981235pga.40.1645777831340;
        Fri, 25 Feb 2022 00:30:31 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.118])
        by smtp.googlemail.com with ESMTPSA id j2-20020a655582000000b00372b2b5467asm1870851pgs.10.2022.02.25.00.30.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 25 Feb 2022 00:30:30 -0800 (PST)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH] x86/kvm: Don't use PV TLB/yield when mwait is advertised
Date:   Fri, 25 Feb 2022 00:29:40 -0800
Message-Id: <1645777780-2581-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

MWAIT is advertised in host is not overcommitted scenario, however, PV
TLB/sched yield should be enabled in host overcommitted scenario. Let's 
add the MWAIT checking when enabling PV TLB/sched yield.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kernel/kvm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index f734e3b0cfec..491e1d9ca750 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -463,6 +463,7 @@ static bool pv_tlb_flush_supported(void)
 	return (kvm_para_has_feature(KVM_FEATURE_PV_TLB_FLUSH) &&
 		!kvm_para_has_hint(KVM_HINTS_REALTIME) &&
 		kvm_para_has_feature(KVM_FEATURE_STEAL_TIME) &&
+		!boot_cpu_has(X86_FEATURE_MWAIT) &&
 		(num_possible_cpus() != 1));
 }
 
@@ -477,6 +478,7 @@ static bool pv_sched_yield_supported(void)
 	return (kvm_para_has_feature(KVM_FEATURE_PV_SCHED_YIELD) &&
 		!kvm_para_has_hint(KVM_HINTS_REALTIME) &&
 	    kvm_para_has_feature(KVM_FEATURE_STEAL_TIME) &&
+	    !boot_cpu_has(X86_FEATURE_MWAIT) &&
 	    (num_possible_cpus() != 1));
 }
 
-- 
2.25.1

