Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26A2D2642F8
	for <lists+kvm@lfdr.de>; Thu, 10 Sep 2020 11:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730677AbgIJJzZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Sep 2020 05:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730400AbgIJJvG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Sep 2020 05:51:06 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A099C061757;
        Thu, 10 Sep 2020 02:51:06 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id 34so3935966pgo.13;
        Thu, 10 Sep 2020 02:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=aZ2ai2L5F/iERellRc/FhiA4bgMeRmHk5nCXIpo3Znc=;
        b=F8Am6Rdm3ufNw7+FDdsXU9EFqxzfXlTe1JDzL4WnKkbhHHoSJDBlS4br77nLfsZsUJ
         OCtihh7Upioru26Pzz7FyVeE7wN2KX2qF2UregF/sz6/gtVOEWfH/FaP6Q9Igp2EB/P4
         Cwsf2qE8vJFtHOsiccv2xUtFgNmsne1U+gT0XGLSwA6QoGK5f3paPzvxzvTDd0jtO0K6
         5WwxOhiLFl5XJhCotBITcB2V66n4pA6HVwSIXk4fda3QfiF5RwLJKqkpK7e0VlO9sM8u
         JL6/ibfIZk/oOINC0w+IUg4CBdCyCtMZ0QCCIbKW7wO1Q0Ai8Y7+7Pmv/zmfQKddHCTI
         Fj0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=aZ2ai2L5F/iERellRc/FhiA4bgMeRmHk5nCXIpo3Znc=;
        b=L3cJSgmCsa3QcwZjyzNJusJW5BvJS9KvvBm7wpvKZmeQEYtZdhj7Uz0lnWJAJ6iyWd
         Vbkc3cIz5+JQfcT9/w4dmVq6vn96sRfs6+KZ/6/G3K/4BZ8sLA8IIhcfWcMXy7FyyxEz
         jWJxMqaCrJQeMxJse6DGG3PeCZzTfZR25AGJWA4TmcaFs+h8PnUrn+Nh2jzkC/zF6sKp
         pBX/8Ug2QyVJId+un+BRtzGObOZM1TGzUbWbbTy05mt2CHywewHq432SJ1iy6fCQvDa7
         NaMnrRZorqBC0DevAXqpGk3WHSJFelh2YOmpOI6jTZNfVKmKN1awqx3O3be7F6TxvHej
         ib1w==
X-Gm-Message-State: AOAM531nHl/Izwd4AjpsAAXCY/ATNoBupOIfw356392M47LEsHJGyIwG
        urehle+zMvCoh6bgtiP8j+N5je8FynY=
X-Google-Smtp-Source: ABdhPJyozM0bNbb8hwh7gXPLyZTwZwjiImgWvel+Zpd64c+7bvUk9x6pBPd6KYjSAAro5RASbpBUTQ==
X-Received: by 2002:a62:fcc1:: with SMTP id e184mr4690330pfh.152.1599731465614;
        Thu, 10 Sep 2020 02:51:05 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id e1sm2576534pfl.162.2020.09.10.02.51.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Sep 2020 02:51:05 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v2 3/9] KVM: LAPIC: Fix updating DFR missing apic map recalculation
Date:   Thu, 10 Sep 2020 17:50:38 +0800
Message-Id: <1599731444-3525-4-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1599731444-3525-1-git-send-email-wanpengli@tencent.com>
References: <1599731444-3525-1-git-send-email-wanpengli@tencent.com>
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
index 33aab20..e446bdf 100644
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
 
@@ -2301,7 +2306,7 @@ void kvm_lapic_reset(struct kvm_vcpu *vcpu, bool init_event)
 			     SET_APIC_DELIVERY_MODE(0, APIC_MODE_EXTINT));
 	apic_manage_nmi_watchdog(apic, kvm_lapic_get_reg(apic, APIC_LVT0));
 
-	kvm_lapic_set_reg(apic, APIC_DFR, 0xffffffffU);
+	kvm_apic_set_dfr(apic, 0xffffffffU);
 	apic_set_spiv(apic, 0xff);
 	kvm_lapic_set_reg(apic, APIC_TASKPRI, 0);
 	if (!apic_x2apic_mode(apic))
-- 
2.7.4

