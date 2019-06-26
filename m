Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C80156877
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 14:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbfFZMTE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 08:19:04 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38616 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbfFZMTE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 08:19:04 -0400
Received: by mail-wm1-f68.google.com with SMTP id s15so1878918wmj.3;
        Wed, 26 Jun 2019 05:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=uxFC8Siz5tUv6W0qIEzCn2Vx1+LVn+v99MjkyvCV8Uw=;
        b=W+b4IH/rvuhhRf3Wyd1S7q3HLYqqm74I1IrK32GN7Z83y1pb1EZGSGGn+40nObijjy
         jsfK2OrvpGSI5MDDLXZQmMwhNM1jcNck/CT9vgPPyaj1hvHVQR7EkPaYREYPjocEFurh
         a82vyFsPNuBi9GW9FBqCWJvTx3cYAWNYW/tNowfrtR4d0ZghgX+SzO5hBOUHMal6g038
         dPG1EEGQNr4lel57jsUb21MojZxsBrbJn4fXzGMN7K73YC0wYTn1YrADA1+FlEZax/m/
         nmCeEawFHYz5TYzcU8CkNKdtJQwTlq+j1BbxxUFarQ6HrxdU8JBIVwBqA7Ub/1q2v/uG
         Tf3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=uxFC8Siz5tUv6W0qIEzCn2Vx1+LVn+v99MjkyvCV8Uw=;
        b=aS/SrQAjJHtlnxvMpG1meO/vio8s0VCreZJr6SgfQILnMETgZn00gX2fO7FqLfXSWf
         514idChxpFci0PqFF7UpgDI9nY6lbq9MTEpIOE2iY1dbE/BHpzIRbKzjiVVWNFi5WFRa
         nOu9Yqumv7CMavv8MZoJmDGZVR616gJJm5ZuXea4LaARjq/uUGUOuHbK3tkOO4JzpG3Q
         cjTocmKLD3Q5nZakwKhZFfd/k0gFAuzdoETIJhWmiAMFKrBNLp6I57CUsiMqs9g+uWuT
         7eLEpiurBQ5vY19qJhYmtBr7amWFni171rC+Nz03nlzOKRdZJx/3Bu7f8L79bTMkiHnu
         7aGQ==
X-Gm-Message-State: APjAAAX3wjGbV5EbRLKJWsm1eBkmj7XfdEymH37ct3ORqdBfiBtPEi0e
        3KSoyceDSOq7Mf7PmkqnpW94NsFVI2Q=
X-Google-Smtp-Source: APXvYqy6AJwBgQK0/YqkpSO0nhjuap5TUFIyQRxLAvs5Djyn14AL9KZhCvPOe7bYJT5uiTy0ZVvbyw==
X-Received: by 2002:a7b:c776:: with SMTP id x22mr2555803wmk.55.1561551541418;
        Wed, 26 Jun 2019 05:19:01 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id z126sm2586704wmb.32.2019.06.26.05.19.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 05:19:00 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Alexander Potapenko <glider@google.com>
Subject: [PATCH v2] KVM: x86: degrade WARN to pr_warn_ratelimited
Date:   Wed, 26 Jun 2019 14:18:59 +0200
Message-Id: <1561551539-18251-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This warning can be triggered easily by userspace, so it should certainly not
cause a panic if panic_on_warn is set.

Suggested-by: Alexander Potapenko <glider@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/x86.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 83aefd759846..66585cf42d7f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1557,7 +1557,7 @@ static int set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz, bool scale)
 			vcpu->arch.tsc_always_catchup = 1;
 			return 0;
 		} else {
-			WARN(1, "user requested TSC rate below hardware speed\n");
+			pr_warn_ratelimited("user requested TSC rate below hardware speed\n");
 			return -1;
 		}
 	}
@@ -1567,8 +1567,8 @@ static int set_tsc_khz(struct kvm_vcpu *vcpu, u32 user_tsc_khz, bool scale)
 				user_tsc_khz, tsc_khz);
 
 	if (ratio == 0 || ratio >= kvm_max_tsc_scaling_ratio) {
-		WARN_ONCE(1, "Invalid TSC scaling ratio - virtual-tsc-khz=%u\n",
-			  user_tsc_khz);
+		pr_warn_ratelimited("Invalid TSC scaling ratio - virtual-tsc-khz=%u\n",
+			            user_tsc_khz);
 		return -1;
 	}
 
-- 
1.8.3.1

