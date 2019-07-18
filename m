Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 101866CD7A
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2019 13:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390195AbfGRLjS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jul 2019 07:39:18 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41267 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390092AbfGRLjQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jul 2019 07:39:16 -0400
Received: by mail-pl1-f194.google.com with SMTP id m9so13690244pls.8;
        Thu, 18 Jul 2019 04:39:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VDOpNg7e30z+8UVXeCnwHjFkxSm/l6mZSdia9FK/R+w=;
        b=C4SN7AQTPn4QlWvHwdFmGsZnJagnhpazBqcZQbp5cRc2OrODZW+y/r26U1QH14fbQw
         isrmi0DkonkpQkpiRNzrl04hW0i7jAh9th0SiHERSboSt/S9C6RQ61aiBwtQa3QEPhxx
         Vky/kmjgOgASoyzgieBHpTjGYALtxbiPHzSmMwjQPKkH6YiTYwZ8HetBfNXBBwYKVUdM
         sqlPXei0aBKwACgp8KULE7BfVTBH8Y8p+M39+XZrG8NVm5TuMK7dzVjhH+V1w84/hrWj
         PMvdAaBeFCsLWUMu0udI8KEYBPY/VdmqAf+Aa6Cg5kDKnAcUK6VhMFfUmi1mF3/XEXY6
         ltMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VDOpNg7e30z+8UVXeCnwHjFkxSm/l6mZSdia9FK/R+w=;
        b=juJxjhdfM3tdKtE5khzaIeyfTDbV0ROXlW6Bc4JKRxy4H6TtlY8Oot1J/MPjUYcdJS
         9gGK0b9tcHy+N3SaPxm5vv1kESkgW1f6YtQSDzNFqR5kO0i4rpT/X7VMcAomOu7i/jkN
         yBRyHwLIisdtW0n4aEjx2cmxuHrf+0mmPMjVwoq8u01o3E0KbcRl6RtfZgWNZT+kEfNG
         D94kzW/pRhJPmIoi6JRx0Qg8RbqEmugrzoPpQykQepjMtxiFgY4xm7nUFT/B8kYn05Ok
         gwaFb+RKJQ0pmymg5q67Ow5VNRDFMMMqU5dWX97BGtIkcktXedwds/PrOHEuR17KkgNw
         y28g==
X-Gm-Message-State: APjAAAW9ZIh4G1fWcTHn8LDT408IqI1zzWbqVRaX2iT02iYk4Rcn7fXf
        /pvuq1sB0JvhqykesYyZRzdKFxTejCw=
X-Google-Smtp-Source: APXvYqySc9AQVpF1vgciB3LhNwYLa2ShbrHBMZ+w+hyNAzWKCfXLB9c8RBnhe8s7vDSohh5kYtUgqA==
X-Received: by 2002:a17:902:24a2:: with SMTP id w31mr50712692pla.324.1563449955157;
        Thu, 18 Jul 2019 04:39:15 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id f15sm11908581pgu.2.2019.07.18.04.39.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 18 Jul 2019 04:39:14 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH v2 2/2] KVM:390: Use kvm_vcpu_wake_up in kvm_s390_vcpu_wakeup
Date:   Thu, 18 Jul 2019 19:39:07 +0800
Message-Id: <1563449947-7749-2-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1563449947-7749-1-git-send-email-wanpengli@tencent.com>
References: <1563449947-7749-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Use kvm_vcpu_wake_up() in kvm_s390_vcpu_wakeup().

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/s390/kvm/interrupt.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 26f8bf4..881cc5a 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -1229,21 +1229,8 @@ void kvm_s390_vcpu_wakeup(struct kvm_vcpu *vcpu)
 	 * in kvm_vcpu_block without having the waitqueue set (polling)
 	 */
 	vcpu->valid_wakeup = true;
-	/*
-	 * This is mostly to document, that the read in swait_active could
-	 * be moved before other stores, leading to subtle races.
-	 * All current users do not store or use an atomic like update
-	 */
-	smp_mb__after_atomic();
-	if (swait_active(&vcpu->wq)) {
-		/*
-		 * The vcpu gave up the cpu voluntarily, mark it as a good
-		 * yield-candidate.
-		 */
+	if (kvm_vcpu_wake_up(vcpu))
 		vcpu->ready = true;
-		swake_up_one(&vcpu->wq);
-		vcpu->stat.halt_wakeup++;
-	}
 	/*
 	 * The VCPU might not be sleeping but is executing the VSIE. Let's
 	 * kick it, so it leaves the SIE to process the request.
-- 
2.7.4

