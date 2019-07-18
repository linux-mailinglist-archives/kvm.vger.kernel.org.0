Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 900CB6CEFC
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2019 15:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403765AbfGRNhU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jul 2019 09:37:20 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39541 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390454AbfGRNhR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jul 2019 09:37:17 -0400
Received: by mail-wr1-f65.google.com with SMTP id x4so28718781wrt.6;
        Thu, 18 Jul 2019 06:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MFH03ifrjd37/Jli9Q9+Ane3me57PKZntHndUzE6BBo=;
        b=HX/K/FMyO4UzXj7s9k0gSYZFHPR7GOGdL/Gjx84AMw4cdGnFLUw642ucGixDxbo4KD
         FxlPtbPwV2DrIh3v+bszenUMBz+p8oyUFSVapF2Uo/wKQDSh532OR9xtItbrpn6OASod
         13+bDdeGFYZZz8WvlH7EH5+42MpzirbC/7U3HopHq6R2E+cHg3TSlJWMyk5w2s9pRJY4
         8z1bGheDMFjRtihQj3/O/9iM/BKWxHoITvqM/OVvX77HhYXSdpIjIJQg56Qwv0H2O4Mg
         dRpyp51z4M0ktUCD/utXIL/vd0DSSqjW4RdUJXcbmFkpFMkvfh8NiEU97K+QKQj2DRiL
         jBGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=MFH03ifrjd37/Jli9Q9+Ane3me57PKZntHndUzE6BBo=;
        b=PO5kLM+9ZQYMxzXZyQYx2guwAGTEn1fa+KwFlSds4T5VIkMF7S+YyrQkM2qGx7g+7I
         mA0bbdzjJ6PJjFbt+knHiWMb7uBq8qvjVfDt4AxN/zlIQ1zlNGGo9Q2swCaK5rIK9k4G
         +debdhbDPwSG2GVoVLkrJEzWXKxH1msu6S0zQ1QrQO0vO8w82q4LqUnmz6CG6ULmDxLw
         AG8/sVVUGvWb+kGbV6zeuD3Bs+/AAHWAsZcALTFY4cDaOs4tMzuvoBrdHi+lksvYz7Sd
         zb5xUFjijarAqkTiQ6XPsv8Qr0MSqqpbmfcUJItiWsMYOPPerLvwegk4E0Yd4RyXJGhZ
         Q1EQ==
X-Gm-Message-State: APjAAAVQJD5qLqvuOMfg6J0+4CXZjlyr/cvK5FRvgjVvCU6f7w7Gielc
        5xce/afBWedCI81oo/GFxhbI4OWTxc0=
X-Google-Smtp-Source: APXvYqz56M+LXSXys8qcBurl5iC50DjfDUEo3+/zHK2LZLb6JhFLPEElgAtvL8L4CRVrAoD+ffedqg==
X-Received: by 2002:adf:f088:: with SMTP id n8mr6607017wro.58.1563457035233;
        Thu, 18 Jul 2019 06:37:15 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id t185sm20479790wma.11.2019.07.18.06.37.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 06:37:14 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     wanpengli@tencent.com, rkrcmar@redhat.com, borntraeger@de.ibm.com,
        paulus@ozlabs.org, maz@kernel.org
Subject: [PATCH 2/2] KVM: s390: Use kvm_vcpu_wake_up in kvm_s390_vcpu_wakeup
Date:   Thu, 18 Jul 2019 15:37:11 +0200
Message-Id: <1563457031-21189-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1563457031-21189-1-git-send-email-pbonzini@redhat.com>
References: <1563457031-21189-1-git-send-email-pbonzini@redhat.com>
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
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
	v2->v3: no need to set vcpu->ready here
 arch/s390/kvm/interrupt.c | 23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
index 26f8bf4a22a7..b5fd6e85657c 100644
--- a/arch/s390/kvm/interrupt.c
+++ b/arch/s390/kvm/interrupt.c
@@ -1224,28 +1224,11 @@ int kvm_s390_handle_wait(struct kvm_vcpu *vcpu)
 
 void kvm_s390_vcpu_wakeup(struct kvm_vcpu *vcpu)
 {
-	/*
-	 * We cannot move this into the if, as the CPU might be already
-	 * in kvm_vcpu_block without having the waitqueue set (polling)
-	 */
 	vcpu->valid_wakeup = true;
+	kvm_vcpu_wake_up(vcpu);
+
 	/*
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
-		WRITE_ONCE(vcpu->ready, true);
-		swake_up_one(&vcpu->wq);
-		vcpu->stat.halt_wakeup++;
-	}
-	/*
-	 * The VCPU might not be sleeping but is executing the VSIE. Let's
+	 * The VCPU might not be sleeping but rather executing VSIE. Let's
 	 * kick it, so it leaves the SIE to process the request.
 	 */
 	kvm_s390_vsie_kick(vcpu);
-- 
1.8.3.1

