Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73FCA2489AF
	for <lists+kvm@lfdr.de>; Tue, 18 Aug 2020 17:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgHRPYv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Aug 2020 11:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728025AbgHRPYs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Aug 2020 11:24:48 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05763C061389
        for <kvm@vger.kernel.org>; Tue, 18 Aug 2020 08:24:48 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id j11so7269909plj.6
        for <kvm@vger.kernel.org>; Tue, 18 Aug 2020 08:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=VvND+6fFOfTo9BuTLPzQfieTbn/IyIHYWxUcE7b9iOg=;
        b=L7An6vznRn/VW+Pk8nEziwqU0U0UH/z1pc2oXqyLk2XaFOzBGsI6LglZ5/4NEAFYDI
         JpUesSysvMlq2DaWEUTSbY8R/Fabc1UwEeoi1oOPFzAW3qsJIvdIz6tcO2AXt64cl244
         n4mkkwPAur/GU0fleEdtqxFGfPG70w7+DQkSXFUJhavjeTSoICM2MJBPobFVkujSjrBY
         lIN5FEN4n+2deIzbxZWnlRfhC3wLfFwb2Mrzvaaxw3VUSnYKLo9Kmh0Udp02ggIxyUzQ
         ySoL4Rch1doPdn34qSYP3Yd4ZY1i8QhURiclzFqXp/rsXHYex1sgZOAidS0v5eE7GV/K
         XPEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VvND+6fFOfTo9BuTLPzQfieTbn/IyIHYWxUcE7b9iOg=;
        b=lORpVBzYreeEX4phVB37cOksctCy18MUTL8wSrY2OgusPsyXCNBjXx0c4FypSnnfl2
         c0EY2RYRpAQ6fIPVhtfQrcVI2WdY4njlvzevWhjU/UzUTxEQmLJxi+FvJ1PLqKjWH08f
         thRc9ZdX4FeA13AeHVNXdqrNgi2V1ZzmvXZhdQ8RoM8gPRI8W3vUIM0f75PM0ym8TUpL
         eSSPi7oDljFOFsPPnk7GM8bSEjWc8E7vGPPLYS8Krk+xok7xAyRA4tc6Z4Z0cIIpZjWK
         t/JIhTy/wNxQD6JceCsC2PdKSIkGN/MeIWb3vE/KZaoM4pJBG9uxbhwzkd9g46yiC1EE
         2YmA==
X-Gm-Message-State: AOAM533hNrI2luc6olEzo9BdqN1y1aHyhO0qS/NJXXxyopPLzAGdrg4C
        0mtzRL5z+vph06cM52jf62550ykn5gOGv9EXil1P1IN4RXTJ+DRvCJ17TIH1vymTHHsMO4TrKE/
        2gpio5S78DSn2RrB+8wpGAPmfLFx6NHIqG0Jc7qN9BIEoeIlKr8mBJIsYHw==
X-Google-Smtp-Source: ABdhPJwxt5E4opAohrps2QKUPmOQFnNR9PiVSomeGgbw4fZmhCZZQ+zVXWHm/00gle1z4SH9QW3k1RShiQk=
X-Received: from oupton2.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:518e])
 (user=oupton job=sendgmr) by 2002:a17:90a:24e6:: with SMTP id
 i93mr352479pje.231.1597764287377; Tue, 18 Aug 2020 08:24:47 -0700 (PDT)
Date:   Tue, 18 Aug 2020 15:24:27 +0000
In-Reply-To: <20200818152429.1923996-1-oupton@google.com>
Message-Id: <20200818152429.1923996-3-oupton@google.com>
Mime-Version: 1.0
References: <20200818152429.1923996-1-oupton@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH v4 2/4] kvm: x86: set wall_clock in kvm_write_wall_clock()
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Small change to avoid meaningless duplication in the subsequent patch.
No functional change intended.

Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Peter Shier <pshier@google.com>
Signed-off-by: Oliver Upton <oupton@google.com>
Change-Id: I77ab9cdad239790766b7a49d5cbae5e57a3005ea
---
 arch/x86/kvm/x86.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b7ba8eb0c91b..e16c71fe1b48 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1791,6 +1791,8 @@ static void kvm_write_wall_clock(struct kvm *kvm, gpa_t wall_clock)
 	struct pvclock_wall_clock wc;
 	u64 wall_nsec;
 
+	kvm->arch.wall_clock = wall_clock;
+
 	if (!wall_clock)
 		return;
 
@@ -2998,7 +3000,6 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_KVM_WALL_CLOCK_NEW:
 	case MSR_KVM_WALL_CLOCK:
-		vcpu->kvm->arch.wall_clock = data;
 		kvm_write_wall_clock(vcpu->kvm, data);
 		break;
 	case MSR_KVM_SYSTEM_TIME_NEW:
-- 
2.28.0.220.ged08abb693-goog

