Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8069E458864
	for <lists+kvm@lfdr.de>; Mon, 22 Nov 2021 04:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238620AbhKVDiE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 Nov 2021 22:38:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232690AbhKVDiD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 Nov 2021 22:38:03 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AA2EC061574;
        Sun, 21 Nov 2021 19:34:57 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id r138so4535749pgr.13;
        Sun, 21 Nov 2021 19:34:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:organization:mime-version
         :content-transfer-encoding;
        bh=JGBn1lQayMnvk5SYEnWwopHGKPW7YJeqgCL9mkpoJ34=;
        b=GKuf5TJI6uvcJKJwjsXYULnUa66irwmLfzeztcZ8oAHAtL0PLYvORmDI/X0iWIxzdL
         HmMBaBNDfREaIiMwVvp+k7VUFuWM8nA8POMCFO9Hyjsno/6DXPwrYiW82gTxAo4LNBTP
         f12S6SkQyMVkPJNT6O8hLHtMkT1xpBw1uQzOLESDmz4dqvnoZgUsBbGIGySjTZZmMyYf
         QP3rZ1qLhNfzLsJeC0jJHDrUkghJ5uM4Gqjh+g2mqXAxoPzLSkqTKfzacOCnHFgdfzqk
         OpcIf7nkgJk+7PM5/sTU9suzJ1WYlBtmP3g4igBBUdnZ/tSfbrxO8XMGNl9SFLoSSk7f
         l+og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:organization
         :mime-version:content-transfer-encoding;
        bh=JGBn1lQayMnvk5SYEnWwopHGKPW7YJeqgCL9mkpoJ34=;
        b=a//yWCzauN0Jv5lM2pQMc1kIae+2r8yOkOnb21/di5d12Z7WBxjD+k4LEdJvb+xQNR
         WU7n8GVLSo34POn9E3XoSRlbXp3wRAsCYToqjb3FqqHwlApukspSOV2YdSOtGY/SY/m5
         +lqUD45RsZvuNiEShWA8t71cZma/MOHZnGepo6q6TLI5H7wOHRPSLtw4Q5eIzC074aHx
         iJcbyQowXGb6Yvo5xsH2Z4fEsjJFoaAEGPtUkATRwFMunCznAEw4H/j6sb3d/Y0WoswD
         jWHqh1KhZAcEirjHz4zzvd5SSw0zZ/1vRGPpQLrfy+DCu6fPb95DYZTGRuLncvCodQ0A
         PD+w==
X-Gm-Message-State: AOAM533cpGDojpkj5hiHAsqAXJnZ1ydkB5+VK2AdQwnnGsEY9cox4gRX
        npEQjFT+9GHdDXFDGp+xbLc=
X-Google-Smtp-Source: ABdhPJzbtMlHIwYNN2ppajgDSPNxu3KUwho2MEopPGg2LjwXiAjme+TJwfxsAur8aU+h8LTGasVMqA==
X-Received: by 2002:a63:f749:: with SMTP id f9mr31061332pgk.330.1637552096890;
        Sun, 21 Nov 2021 19:34:56 -0800 (PST)
Received: from ubuntu ([222.129.53.202])
        by smtp.gmail.com with ESMTPSA id k2sm7327273pfc.9.2021.11.21.19.34.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Nov 2021 19:34:56 -0800 (PST)
Date:   Mon, 22 Nov 2021 09:58:05 +0800
From:   Aili Yao <yaoaili126@gmail.com>
To:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com
Cc:     x86@kernel.org, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, yaoaili@kingsoft.com
Subject: [PATCH] KVM: LAPIC: Per vCPU control over
 kvm_can_post_timer_interrupt
Message-ID: <20211122095619.000060d2@gmail.com>
Organization: ksyun
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.29; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Aili Yao <yaoaili@kingsoft.com>

When we isolate some pyhiscal cores, We may not use them for kvm guests,
We may use them for other purposes like DPDK, or we can make some kvm
guests isolated and some not, the global judgement pi_inject_timer is
not enough; We may make wrong decisions:

In such a scenario, the guests without isolated cores will not be
permitted to use vmx preemption timer, and tscdeadline fastpath also be
disabled, both will lead to performance penalty.

So check whether the vcpu->cpu is isolated, if not, don't post timer
interrupt.

Signed-off-by: Aili Yao <yaoaili@kingsoft.com>
---
 arch/x86/kvm/lapic.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 759952dd1222..72dde5532101 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -34,6 +34,7 @@
 #include <asm/delay.h>
 #include <linux/atomic.h>
 #include <linux/jump_label.h>
+#include <linux/sched/isolation.h>
 #include "kvm_cache_regs.h"
 #include "irq.h"
 #include "ioapic.h"
@@ -113,7 +114,8 @@ static inline u32 kvm_x2apic_id(struct kvm_lapic *apic)
 
 static bool kvm_can_post_timer_interrupt(struct kvm_vcpu *vcpu)
 {
-	return pi_inject_timer && kvm_vcpu_apicv_active(vcpu);
+	return pi_inject_timer && kvm_vcpu_apicv_active(vcpu) &&
+		!housekeeping_cpu(vcpu->cpu, HK_FLAG_TIMER);
 }
 
 bool kvm_can_use_hv_timer(struct kvm_vcpu *vcpu)
-- 
2.25.1

