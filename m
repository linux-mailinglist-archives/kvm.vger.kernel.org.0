Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4E052498DF
	for <lists+kvm@lfdr.de>; Wed, 19 Aug 2020 10:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbgHSI5J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Aug 2020 04:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727114AbgHSIzn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Aug 2020 04:55:43 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B331C061342;
        Wed, 19 Aug 2020 01:55:41 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id y6so10506842plt.3;
        Wed, 19 Aug 2020 01:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=nDuiQiXTW962b08Ia0CPUyPMivpXBTRFVOWfM281t2I=;
        b=RaUObfPy9UGdUIMrmSu4v87RasnxOvjPoiDncMq5aYZjysFwPh6YqhgU4iv93cylyn
         6RiJkNEaH4sDneCCrfnuE/KV0QI0wS8QPKXaTUAfY9th/MDkoj34WxdhG5dYgejmGC2W
         CwzXXVGEDQdC9HFn1Y4hGYfwlwSLfU2IGVgMMobwATo4JiHupC1dav8/ZPt4Bgsc8DeI
         uA4zQXbLq+oBLGrUq/AodY6T7xCEOuF+MuiIXVhs6/9aglNYHhrwUE/Aad5ZOqTcVZ7M
         z8R+lzf+PjZnyuQ19L1PkpAJWvM+Y6K+z7UHtntlkzapeqOXbz+Tl6VjUOgaz5rXFi7k
         c+VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=nDuiQiXTW962b08Ia0CPUyPMivpXBTRFVOWfM281t2I=;
        b=Ct3JjnRL1m1BBKlsfGq0ICsRSp+yO7HfHSOwRxjyFUu3445nzmnCvzo41T2ydCcIfC
         TVKMYVxe30NT4VpLtQs5tVhf1+4DNJ5gUU9fUnqSjXvS5kG7jdambitPy1qw0giLcM4f
         t7wPk4Qc+xMezMQ8QVbV5cnzTwkXV2ccnu5j3nFAGO7PDqb77o+jLap4e5Or34WQ++en
         PuND8jZeTGURE3S2Rk4naICvyj0qdJJmeXDBxFdoKCsjavsiyOCwvycZRwkuEIqpVCxW
         vd1jweMVh6zKc3Am1HbNM12TGytmYwGKHcHhMJD03yvZxytPMvYs4b3Pza7WOcT/Y4XQ
         Jylw==
X-Gm-Message-State: AOAM5324nQ16BgW/dOtI3C73sqot5y1H8F34ag93R5i8awM+/b7B15MR
        gJLWW+ieBiGHps2ChsCwnuwTeV3oZyc=
X-Google-Smtp-Source: ABdhPJyZ2JC161afsEyKpInkW87mBHllTI27riaA07jogoWCDLFoujX/REj5Fq8SGRgRid1pyYIwRQ==
X-Received: by 2002:a17:90a:9405:: with SMTP id r5mr3416942pjo.74.1597827341075;
        Wed, 19 Aug 2020 01:55:41 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id m15sm20209991pgr.2.2020.08.19.01.55.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Aug 2020 01:55:40 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 1/2] KVM: LAPIC: Fix updating DFR missing apic map recalculation
Date:   Wed, 19 Aug 2020 16:55:26 +0800
Message-Id: <1597827327-25055-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

There is missing apic map recalculation after updating DFR, if it is 
INIT RESET, in x2apic mode, local apic is software enabled before. 
This patch fix it by introducing the function kvm_apic_set_dfr() to 
be called in INIT RESET handling path.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 5ccbee7..248095a 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -310,6 +310,12 @@ static inline void kvm_apic_set_ldr(struct kvm_lapic *apic, u32 id)
 	atomic_set_release(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
 }
 
+static inline void kvm_apic_set_dfr(struct kvm_lapic *apic, u32 val)
+{
+	kvm_lapic_set_reg(apic, APIC_DFR, val);
+	atomic_set_release(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
+}
+
 static inline u32 kvm_apic_calc_x2apic_ldr(u32 id)
 {
 	return ((id >> 4) << 16) | (1 << (id & 0xf));
@@ -1984,10 +1990,9 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 		break;
 
 	case APIC_DFR:
-		if (!apic_x2apic_mode(apic)) {
-			kvm_lapic_set_reg(apic, APIC_DFR, val | 0x0FFFFFFF);
-			atomic_set_release(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
-		} else
+		if (!apic_x2apic_mode(apic))
+			kvm_apic_set_dfr(apic, val | 0x0FFFFFFF);
+		else
 			ret = 1;
 		break;
 
@@ -2303,7 +2308,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 			     SET_APIC_DELIVERY_MODE(0, APIC_MODE_EXTINT));
 	apic_manage_nmi_watchdog(apic, kvm_lapic_get_reg(apic, APIC_LVT0));
 
-	kvm_lapic_set_reg(apic, APIC_DFR, 0xffffffffU);
+	kvm_apic_set_dfr(apic, 0xffffffffU);
 	apic_set_spiv(apic, 0xff);
 	kvm_lapic_set_reg(apic, APIC_TASKPRI, 0);
 	if (!apic_x2apic_mode(apic))
-- 
2.7.4

