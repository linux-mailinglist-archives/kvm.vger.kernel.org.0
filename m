Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0C451A79AA
	for <lists+kvm@lfdr.de>; Tue, 14 Apr 2020 13:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439359AbgDNLgd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Apr 2020 07:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2439354AbgDNLg3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 Apr 2020 07:36:29 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADD48C061A0C
        for <kvm@vger.kernel.org>; Tue, 14 Apr 2020 04:36:28 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id o81so7028914wmo.2
        for <kvm@vger.kernel.org>; Tue, 14 Apr 2020 04:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=abDDrXt9n4LOnvnvIGu8nDnT6fx9WYxogyMHMmUrooA=;
        b=PFdyJ2FfINhhxwNBW3a8Ixf4RvvY4apyDWTg2PEPa2AN/MPFA/Modurp4R9C3RJrQg
         cuzVxvEYEiDZ152R5gXK8U4yK5TE9Oi9EaNi1/iYPRjg/B8LCTu8MikPKiMDmhcpqtSl
         8PIkZuW8Gi+Th/9Hym58wpPGwbJhLoZ08fUpCnB6jmav9MhFJnCT3wPdojD+LlKS4OLs
         WwV0We751vSkoxv2zEUjkm6LltGo1WUlm4AaH482GbjDXi/jL6+QlKRoF3qt+bR7Kg2b
         DMF/AQFsSPcbjxSX2vs8aoFU0vwbW5gqRCQJmplzbFol5SibXwFs0oPDZS9INTzWo/9D
         P6qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=abDDrXt9n4LOnvnvIGu8nDnT6fx9WYxogyMHMmUrooA=;
        b=CHIhEmgO0Q/cbssGp0ca0G2kHKnRhXJ6BuoNSdkSkoMO/JiChGLIuA47ugWPmQTel9
         KeCVxXYSuNVbSmAaLs2ff/cF0iEw3PrvnRlmlon6wbChQ2BI0LzbFAllUAcAf11SZcyg
         nvbNksDxlZ2yhOMW+MDRVHD/KHUS0ZN4PriRCbAmeT5TWrryeFHfsdvopPNTrJPJ63Yq
         kr6caPJ6gy8qYMEoIkC9ZGNMfcCUsf82hrS/EPZjZu5XFGwoh/dSrsMEKjcaUAR2Epx9
         eNaWIcQ1AoAUR6tWRGOeIFgZ9fGll2WGGVHgeSkAByDC8RwoVV2UiMNl0KPj5XHC5A6N
         g22w==
X-Gm-Message-State: AGi0PuZRYZlrzPbc/1tUg5MgkjtZi9iS5UY0KEz/aomFrAWcDK8qu6pm
        KPx3DZtSSTNJc+cMbNLXKYOMhEYxGa4=
X-Google-Smtp-Source: APiQypLjDMW60tt9hAYguUpg8UQo5ZdfJWfkIbWKC+3ZQt17nduxKb/Oi9fYxwL4DLWlozBpQD7oug==
X-Received: by 2002:a1c:2056:: with SMTP id g83mr23054286wmg.179.1586864187099;
        Tue, 14 Apr 2020 04:36:27 -0700 (PDT)
Received: from localhost.localdomain (93-103-18-160.static.t-2.net. [93.103.18.160])
        by smtp.gmail.com with ESMTPSA id x23sm10832097wmj.6.2020.04.14.04.36.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2020 04:36:26 -0700 (PDT)
From:   Uros Bizjak <ubizjak@gmail.com>
To:     kvm@vger.kernel.org
Cc:     Uros Bizjak <ubizjak@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] KVM: SVM: Do not mark svm_vcpu_run with STACK_FRAME_NON_STANDARD
Date:   Tue, 14 Apr 2020 13:36:12 +0200
Message-Id: <20200414113612.104501-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

svm_vcpu_run does not change stack or frame pointer anymore.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
---
 arch/x86/kvm/svm/svm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index cd773f6261e3..200962c83b82 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3427,7 +3427,6 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	mark_all_clean(svm->vmcb);
 }
-STACK_FRAME_NON_STANDARD(svm_vcpu_run);
 
 static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long root)
 {
-- 
2.25.2

