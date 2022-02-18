Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 313814BB3F1
	for <lists+kvm@lfdr.de>; Fri, 18 Feb 2022 09:11:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232406AbiBRILs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 03:11:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229938AbiBRILr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 03:11:47 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C650A6527;
        Fri, 18 Feb 2022 00:11:30 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id f8so7193867pgc.8;
        Fri, 18 Feb 2022 00:11:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=bXsJR1hdtDvMtwp7yRC+IBrb2NPsW+Emms20iVxrSMU=;
        b=AaBFLmiOGsUkw4+8UvUdL+L5kkVxHOj1Npl1IXE6YoKWXYSl/9K3tUdIfZ4RO6foc5
         fonKpoD6m+5CQSiabZVRp2mpP0AEIycjGJHGIuxkpBRbgoFtbzS6jl0R2XZadf34rg04
         BEtiiX6bSLhmQsgz/61xruiUuQMCe9vD69ARsBpJekQRpqt8cOSobfTjaHFWITJerM97
         07WsrQVX/pvu4jBCyzwicR4yAgM4ZQ8fZV/k4hj5Nx1pC7v8kaoRZLW6+gGRVfnoCG9V
         noWENnvIpDCzOyl07mlvHCv7Sz1a0MQ9LcP0rwB+gHx4WUw2J9e2tw/s2BPSS1xc9tfb
         e/aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=bXsJR1hdtDvMtwp7yRC+IBrb2NPsW+Emms20iVxrSMU=;
        b=r75EKQn9zJFIzalGKrtWLhJDL9DK6N1FfYzWrm3qG7b7SRDsoSi97sQq+iDdmiBaed
         htJstcVYAUPq5/6iGlIBol1cPtKqDMeVBjW7EI5X8RLYMfWaImzKOqktUlf/M/VbxWIw
         EHiOOVVJQwpftONDgYxfwTCOU6kT/ykCcAB+/NGZlAGg/JB2K8XCojNVMMz0Wq3UMGpe
         Ok56KTkQqWJUXKMvPxsMiYsCkDfsYXlqxbkv7ki//tg4aFHvxGquFiVy065nPVFimAyE
         Y0SySgfDGILxlnUlrM/iN5vpqo4ZbiFwAdscCVKbGu8E5ikYVOJWFzvQQwvFyqD+bk3I
         ngGw==
X-Gm-Message-State: AOAM532bvpKWGq3PdZlQNBnPpsHgtymsB/ha/OOrepCi74U8LFS6rL8d
        j+yzRLoD1nevlCOzKtVt0m243n94o6U=
X-Google-Smtp-Source: ABdhPJwRUo2LbLZ8iHn9ZB7+3ee+Hfk4AOhSTzpGDqcHJojFIKF0Ywl1WCJUSiXWUQjWfHRD5nxCfQ==
X-Received: by 2002:a63:f00e:0:b0:373:9fdb:ce03 with SMTP id k14-20020a63f00e000000b003739fdbce03mr5474869pgh.518.1645171889241;
        Fri, 18 Feb 2022 00:11:29 -0800 (PST)
Received: from localhost.localdomain ([203.205.141.110])
        by smtp.googlemail.com with ESMTPSA id l8sm10673665pgt.77.2022.02.18.00.11.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Feb 2022 00:11:28 -0800 (PST)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH] x86/kvm: Don't use pv tlb/ipi/sched_yield if on 1 vCPU
Date:   Fri, 18 Feb 2022 00:10:38 -0800
Message-Id: <1645171838-2855-1-git-send-email-wanpengli@tencent.com>
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

Inspired by commit 3553ae5690a (x86/kvm: Don't use pvqspinlock code if
only 1 vCPU), on a VM with only 1 vCPU, there is no need to enable 
pv tlb/ipi/sched_yield and we can save the memory for __pv_cpu_mask.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kernel/kvm.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index a438217cbfac..f734e3b0cfec 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -462,19 +462,22 @@ static bool pv_tlb_flush_supported(void)
 {
 	return (kvm_para_has_feature(KVM_FEATURE_PV_TLB_FLUSH) &&
 		!kvm_para_has_hint(KVM_HINTS_REALTIME) &&
-		kvm_para_has_feature(KVM_FEATURE_STEAL_TIME));
+		kvm_para_has_feature(KVM_FEATURE_STEAL_TIME) &&
+		(num_possible_cpus() != 1));
 }
 
 static bool pv_ipi_supported(void)
 {
-	return kvm_para_has_feature(KVM_FEATURE_PV_SEND_IPI);
+	return (kvm_para_has_feature(KVM_FEATURE_PV_SEND_IPI) &&
+	       (num_possible_cpus() != 1));
 }
 
 static bool pv_sched_yield_supported(void)
 {
 	return (kvm_para_has_feature(KVM_FEATURE_PV_SCHED_YIELD) &&
 		!kvm_para_has_hint(KVM_HINTS_REALTIME) &&
-	    kvm_para_has_feature(KVM_FEATURE_STEAL_TIME));
+	    kvm_para_has_feature(KVM_FEATURE_STEAL_TIME) &&
+	    (num_possible_cpus() != 1));
 }
 
 #define KVM_IPI_CLUSTER_SIZE	(2 * BITS_PER_LONG)
-- 
2.25.1

