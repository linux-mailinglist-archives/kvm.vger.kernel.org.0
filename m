Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C31EB2642D7
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 11:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730504AbgIJJvq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 05:51:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730361AbgIJJvF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 05:51:05 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C55FC061756;
        Thu, 10 Sep 2020 02:51:05 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id 5so3968666pgl.4;
        Thu, 10 Sep 2020 02:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5+FqItlch5fXU8bS1/CLLF6Rlk1KCJ6HSP/u17LZEpg=;
        b=Aaeqm3WFVgxo0hI9bAZyTv+C5cRXDd5iDOaTxdTyLIXZ+clzbAz42qQeWKI2f6tavq
         L/GsJ9MtAB/aGUronpyzAHKB6IJ9rsWptmtV5xNBACKPaGfxEUOdcAr9S/WrSrjBkAYb
         X6MyKNwYhWTBr4Jf6gbvfPAAvvpPTYCfCMqM7A3Ko+it2ABrqQ9NiytmHJrfUvzR8W5k
         xZM0G8KHVvHJg3oMPsVnTUIXyQNxkEThhbUICn8AJcgq5ZrrnIvAghaQR8pcOfzw6eQm
         URfvNVSHtXaKVIjRMl2o1RDHNFgbqVuvPwO3ucjx5DmKGHMrHqYcte5p4G2+D5SqdoC/
         Dk/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5+FqItlch5fXU8bS1/CLLF6Rlk1KCJ6HSP/u17LZEpg=;
        b=PhG31yeA4yye2PTbCwF9tb0tfF9mJvwFJP1K2DJ1LPhRMXAG1zO5lvLRgkzJbTeJrf
         +myg8+7k9gJYMnx4fdgJqBoe3/6MJWRpllNdnkhhocisCFz42/ylm/Tf+rru1ZO4hBo9
         StbcNdrY91+Avnqj5PZJ6cnmKD8Cd0UP+jJJNUNJf3nVmXWyVAoMfK1oO8NOltqS+yKv
         ReZGVHoO8mE5ocD2KdeqpdytsIH2ixSGbZus/Apm0VvOgAK1u2BS7TgYObNeYLNkGe2B
         LbwbATuaEgVBtq9s5LYatl8S5kX6X+iMjDnwRkc9YKP1elE6eBHRn9iK5c5UVl3t6iq2
         NW0w==
X-Gm-Message-State: AOAM532J3hvXSOfcp7qN9c2+T6YSSgLCiVRGbda9j3A6BuO3K9Ke9ZVN
        vYnDXRtA87UeA4i+jTn+N6WnhoKiLGU=
X-Google-Smtp-Source: ABdhPJwKETbw88dtvX26SyEyDJqeuANaiFEjg5cUIBWYLYvx7Q5v2Dfu7MvFSUqsduZ5VzQmzi8xDQ==
X-Received: by 2002:a63:4b63:: with SMTP id k35mr3916705pgl.142.1599731462899;
        Thu, 10 Sep 2020 02:51:02 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id e1sm2576534pfl.162.2020.09.10.02.51.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Sep 2020 02:51:02 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v2 2/9] KVM: LAPIC: Guarantee the timer is in tsc-deadline mode when setting
Date:   Thu, 10 Sep 2020 17:50:37 +0800
Message-Id: <1599731444-3525-3-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1599731444-3525-1-git-send-email-wanpengli@tencent.com>
References: <1599731444-3525-1-git-send-email-wanpengli@tencent.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Check apic_lvtt_tscdeadline() mode directly instead of apic_lvtt_oneshot()
and apic_lvtt_period() to guarantee the timer is in tsc-deadline mode when
wrmsr MSR_IA32_TSCDEADLINE.

Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 81bf6a8..33aab20 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2193,8 +2193,7 @@ void kvm_set_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu, u64 data)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 
-	if (!kvm_apic_present(vcpu) || apic_lvtt_oneshot(apic) ||
-			apic_lvtt_period(apic))
+	if (!kvm_apic_present(vcpu) || !apic_lvtt_tscdeadline(apic))
 		return;
 
 	hrtimer_cancel(&apic->lapic_timer.timer);
-- 
2.7.4

