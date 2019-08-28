Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18ED69FCC0
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 10:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbfH1ITI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 04:19:08 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:35107 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726292AbfH1ITI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 04:19:08 -0400
Received: by mail-pf1-f196.google.com with SMTP id d85so1228853pfd.2;
        Wed, 28 Aug 2019 01:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W7GKLPAGmCBm9bFk16i6qv/H1D4Ue6Mzr647i7CBlq8=;
        b=pWudp200xJPqLG8gbdZmOS6rC3AjwavyXDrm65Uh0QOIEuGy8SI1wF1eEfhT+GssFA
         nRJVI5i83WwNJ4r56NkhqF/Ieny0DrariGtiaT+yYu2zm5Q7zl6PShX4L0mzHpkIM9XT
         fQokuycnWDeZRJTLORLRPCPp/Ln/71vBoraawn3RVZfbZP+mUp3VIU9QYBL3MQVlBmSY
         mdAlt64YdiycL8cJYGsmzF7S3K662B9wgJrf/m8+xaMgNcPnT4y2I10XksQ6o+CyVBcq
         GwZBeZFZ2zm7+jraFi5t4XXTyrhgSB+iAMu9b4b0pO214BzYh1h0z9zrQEbM29h6GHwT
         qDeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W7GKLPAGmCBm9bFk16i6qv/H1D4Ue6Mzr647i7CBlq8=;
        b=PM0cGRcON27/5MK7z+iMxN6b8V1VMi+L/tfmi68OmgkDS0YYs3n7+kj7/gOwJayNoh
         oAZagQU4LKSBvQSsfNZH2catZ/rEvicmSVvjFbL1xKLaEhoNkTOzqxNKgIiUtKeME4UF
         qjNYmKffcn8cyrkfbkSFCArEPg8FXJ5bsJoudBuWet1UbIV/NNuedojGIKpXlqAqJNJD
         MHmTDL+yw3rdQ6bCAfuJQpvw4T4kdJPFo3cUuI30skIx2S84J5dnuchSyC33wabbOuLX
         MtmtpIfCgzssYkYvUUWaxYlvAU8xVj2N1M0ctLcUqSzC0oHyfNmhR/YEr/Drhq9WvTrI
         yd8g==
X-Gm-Message-State: APjAAAUKxIxjJpNesuj+W5ybm3z7ajkOYNZl/rVUppGrX980kWStIHGV
        9wP7K79WyVrfaIQORSw+hRSbhmSI
X-Google-Smtp-Source: APXvYqxHwaHzAOj0x1bmSnv3GB4eFOeCcWwCxN0e7YwF2BcgKx54IpxvhYZ9fB+7k8TSxktmU2sy8g==
X-Received: by 2002:a63:3148:: with SMTP id x69mr2244026pgx.300.1566980347471;
        Wed, 28 Aug 2019 01:19:07 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id g1sm1787263pgg.27.2019.08.28.01.19.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 28 Aug 2019 01:19:07 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH v3 1/2] KVM: LAPIC: Tune lapic_timer_advance_ns smoothly
Date:   Wed, 28 Aug 2019 16:19:01 +0800
Message-Id: <1566980342-22045-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Using a moving average based on per-vCPU lapic_timer_advance_ns to tune 
smoothly, filter out drastic fluctuation which prevents this before, 
let's assume it is 10000 cycles.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index e904ff0..181537a 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -69,6 +69,7 @@
 #define LAPIC_TIMER_ADVANCE_ADJUST_INIT 1000
 /* step-by-step approximation to mitigate fluctuation */
 #define LAPIC_TIMER_ADVANCE_ADJUST_STEP 8
+#define LAPIC_TIMER_ADVANCE_FILTER 10000
 
 static inline int apic_test_vector(int vec, void *bitmap)
 {
@@ -1484,23 +1485,28 @@ static inline void adjust_lapic_timer_advance(struct kvm_vcpu *vcpu,
 					      s64 advance_expire_delta)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
-	u32 timer_advance_ns = apic->lapic_timer.timer_advance_ns;
-	u64 ns;
+	u32 timer_advance_ns = apic->lapic_timer.timer_advance_ns, ns;
+
+	if (abs(advance_expire_delta) > LAPIC_TIMER_ADVANCE_FILTER)
+		/* filter out drastic fluctuations */
+		return;
 
 	/* too early */
 	if (advance_expire_delta < 0) {
 		ns = -advance_expire_delta * 1000000ULL;
 		do_div(ns, vcpu->arch.virtual_tsc_khz);
-		timer_advance_ns -= min((u32)ns,
-			timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP);
+		timer_advance_ns -= ns;
 	} else {
 	/* too late */
 		ns = advance_expire_delta * 1000000ULL;
 		do_div(ns, vcpu->arch.virtual_tsc_khz);
-		timer_advance_ns += min((u32)ns,
-			timer_advance_ns / LAPIC_TIMER_ADVANCE_ADJUST_STEP);
+		timer_advance_ns += ns;
 	}
 
+	timer_advance_ns = (apic->lapic_timer.timer_advance_ns *
+		(LAPIC_TIMER_ADVANCE_ADJUST_STEP - 1) + advance_expire_delta) /
+		LAPIC_TIMER_ADVANCE_ADJUST_STEP;
+
 	if (abs(advance_expire_delta) < LAPIC_TIMER_ADVANCE_ADJUST_DONE)
 		apic->lapic_timer.timer_advance_adjust_done = true;
 	if (unlikely(timer_advance_ns > 5000)) {
-- 
2.7.4

