Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10D0460688
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2019 15:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728545AbfGENYP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jul 2019 09:24:15 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44999 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727638AbfGENYO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jul 2019 09:24:14 -0400
Received: by mail-wr1-f65.google.com with SMTP id b2so8709321wrx.11;
        Fri, 05 Jul 2019 06:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=TJB2RTWPulLTRLLXY7TRiipk7F2VO6sEuWjT2mECMZc=;
        b=eBaJj5t9Vh7vXV+6/AWcm3bcSY6qaQpVxzf5xY0+RCnz9c6aW0RbG5zntpnmE8/lKh
         vm18z1/ac0HjV6KPkcJGv4T7XB/2/rzVVeqvXKo5CqlGMvsxE/DLC0MAd6qSGteSPF5P
         ggOKk4R9cebWHOAseQroACiL9Xr9iDk/TXWyH7qsjjM9BzcPMTLQKwsRdErjr8RkeJBj
         CKAH6H5sH3ijZHpD4tM3KEBLt9zcLN5YS1teO5LMSK+8/J1VIKzY3XlnXXVrSGK6imAe
         5vJIf1+h3tGfrw7xGbKnTqJnrBiA67ZYMiAVXCfEngxVrq7IRasgGrPhfwj7+FZaPewh
         D6xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=TJB2RTWPulLTRLLXY7TRiipk7F2VO6sEuWjT2mECMZc=;
        b=EfiSv9nAjpgVZQUPNLfr/PQRxmdb5gIde9pMz2Q4ywJEiEp6Si+ogSHoIsjSBS6400
         gJpi1/6CkYbJzgP6Lmi2dXbQziBaeTpyCccB+YTN0ZYET9D8zbbkcU+iMebC5JMH86Tg
         RgUnAbBVe0NWc9vrctsyt5lcOgReeSAmq4l8x0bnozcZqftgKZ+bP1YYYyDzyleRyrtN
         oBPl4jfrdCPnjXgC7r3+HuSNdcXU4XU5DgcuMDDyrI6Hq3BCe5+vMl/pevf8hiOjpz0E
         VHtshk/Ok7VGVAKELbcNorIRUWEShaJeMkOmUdKN84iij76OOCHvyKp5c27LWsNNK+Co
         4wHg==
X-Gm-Message-State: APjAAAUSYGYeNOW2xMT5ZksFkO2+ijHLW0w8qrO4DLw9IUIRYFA9SYCn
        PkvOBdHiY1TN9p9Bxi4aBGs+HS+/WaY=
X-Google-Smtp-Source: APXvYqztVaMAws9Nkb+c/1WXl9AxD1Zq34BWkiRhVLpdovI5Ur6r8SsqGJqDgtDNcJ8fVlAD/dxbhg==
X-Received: by 2002:adf:e588:: with SMTP id l8mr2570227wrm.139.1562333052230;
        Fri, 05 Jul 2019 06:24:12 -0700 (PDT)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id y7sm3649664wmm.19.2019.07.05.06.24.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 06:24:11 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     liran.alon@oracle.com
Subject: [PATCH] kvm: LAPIC: write down valid APIC registers
Date:   Fri,  5 Jul 2019 15:24:10 +0200
Message-Id: <1562333050-4745-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Replace a magic 64-bit mask with a list of valid registers, computing
the same mask in the end.

Suggested-by: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/lapic.c | 44 ++++++++++++++++++++++++++++++++------------
 1 file changed, 32 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 2e4470f2685a..e4227ceab0c6 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1312,25 +1312,45 @@ static inline struct kvm_lapic *to_lapic(struct kvm_io_device *dev)
 	return container_of(dev, struct kvm_lapic, dev);
 }
 
+#define APIC_REG_MASK(reg)	(1ull << ((reg) >> 4))
+#define APIC_REGS_MASK(first, count) \
+	(APIC_REG_MASK(first) * ((1ull << (count)) - 1))
+
 int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
 		void *data)
 {
 	unsigned char alignment = offset & 0xf;
 	u32 result;
 	/* this bitmask has a bit cleared for each reserved register */
-	u64 rmask = 0x43ff01ffffffe70cULL;
-
-	if ((alignment + len) > 4) {
-		apic_debug("KVM_APIC_READ: alignment error %x %d\n",
-			   offset, len);
-		return 1;
-	}
-
-	/* ARBPRI is also reserved on x2APIC */
-	if (apic_x2apic_mode(apic))
-		rmask &= ~(1 << (APIC_ARBPRI >> 4));
+	u64 valid_reg_mask =
+		APIC_REG_MASK(APIC_ID) |
+		APIC_REG_MASK(APIC_LVR) |
+		APIC_REG_MASK(APIC_TASKPRI) |
+		APIC_REG_MASK(APIC_PROCPRI) |
+		APIC_REG_MASK(APIC_LDR) |
+		APIC_REG_MASK(APIC_DFR) |
+		APIC_REG_MASK(APIC_SPIV) |
+		APIC_REGS_MASK(APIC_ISR, APIC_ISR_NR) |
+		APIC_REGS_MASK(APIC_TMR, APIC_ISR_NR) |
+		APIC_REGS_MASK(APIC_IRR, APIC_ISR_NR) |
+		APIC_REG_MASK(APIC_ESR) |
+		APIC_REG_MASK(APIC_ICR) |
+		APIC_REG_MASK(APIC_ICR2) |
+		APIC_REG_MASK(APIC_LVTT) |
+		APIC_REG_MASK(APIC_LVTTHMR) |
+		APIC_REG_MASK(APIC_LVTPC) |
+		APIC_REG_MASK(APIC_LVT0) |
+		APIC_REG_MASK(APIC_LVT1) |
+		APIC_REG_MASK(APIC_LVTERR) |
+		APIC_REG_MASK(APIC_TMICT) |
+		APIC_REG_MASK(APIC_TMCCT) |
+		APIC_REG_MASK(APIC_TDCR);
+
+	/* ARBPRI is not valid on x2APIC */
+	if (!apic_x2apic_mode(apic))
+		valid_reg_mask |= APIC_REG_MASK(APIC_ARBPRI);
 
-	if (offset > 0x3f0 || !(rmask & (1ULL << (offset >> 4)))) {
+	if (offset > 0x3f0 || !(valid_reg_mask & APIC_REG_MASK(offset))) {
 		apic_debug("KVM_APIC_READ: read reserved register %x\n",
 			   offset);
 		return 1;
-- 
1.8.3.1

