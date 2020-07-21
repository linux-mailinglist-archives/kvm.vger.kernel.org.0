Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB2C4227BA5
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 11:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728632AbgGUJYj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 05:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbgGUJYj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 05:24:39 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51563C061794;
        Tue, 21 Jul 2020 02:24:39 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id o13so11687968pgf.0;
        Tue, 21 Jul 2020 02:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=4CU667nkvV00ipZaKMgd7BNRAsDjboapT6L5BW02bj8=;
        b=Q9qnbLp1dDGcoPGLtm89abpod6WY1ZGMxNJ2YnnwmafnEDB9+Ylou2LL6Sluy7IeAL
         seq4i+lgqzmj2CoSnRIYqG/QoMRbCd1oaaAkau5NxIkmWJr509ttZoK1IxhVznPA/T0U
         iR9weCEMN2EL/H6S+cyazSbUBMUaRhQe297qRWAGmTahQcsgFOPuDpXP0wpr0uB5zzyj
         Ki1c+fQwdlYFdvTm50XHCc0IJ1AjnmXj9EIvrPzUyp/6f7mz9i56QqWODsV+/VpMhdMY
         XdUGRwa2C3RbbJ+Ern5Nh0S7F/6m4WdAWRg5Xij/cESF/FfeMhmas+XmfKO+xqnPpRDe
         urqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=4CU667nkvV00ipZaKMgd7BNRAsDjboapT6L5BW02bj8=;
        b=gv60waYW88IKWITfujqsRkPog7aFO807NEbpGBpt+Qb0+9gVNPnYL6DRLl3ZFZzSD2
         U0q8u0dJjUGwgnx/cuRqfwbg0C5BT9xZOLdqxTB3IxPaoDCOWlVLLkkk5QZ4P/OuqgG3
         HvKr9768z5EE/BRDYFcimuJ2B2uMHRjbeR33zScqoWlR89HtoexuaxrWBIvL+HOXhByq
         eMpxL8iwd7ojXgfd6k4bVk/Fo9yO1pGC910XAv4wNnHqb0J9uZn0T9/gO2cQAYDok5dh
         MlaKX3eooo2V8DKPBI3YYEtZ6Wu3bR33ecHQouVljnxM37+CIWXYwOGLHkYAiCf2g/4y
         sAHA==
X-Gm-Message-State: AOAM531l0AIZDmxgitnXPe68atI/U4/R+tciRPIM0LkB0GPitJzdD7wn
        BYGXW42V4X917MmTvDSqkLf3Eewu
X-Google-Smtp-Source: ABdhPJwQ7uwVn4YaUJ0trVo3VulSj443x0CxxyZZktIAxMWDWRRi/5o9YakQzf2hxB1OlDyRceOZOQ==
X-Received: by 2002:aa7:930b:: with SMTP id 11mr24277068pfj.320.1595323478678;
        Tue, 21 Jul 2020 02:24:38 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id l9sm2337685pjy.2.2020.07.21.02.24.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Jul 2020 02:24:38 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 1/2] KVM: LAPIC: Prevent setting the tscdeadline timer if the lapic is hw disabled
Date:   Tue, 21 Jul 2020 17:24:27 +0800
Message-Id: <1595323468-4380-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Prevent setting the tscdeadline timer if the lapic is hw disabled.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 5bf72fc..4ce2ddd 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2195,7 +2195,7 @@ void kvm_set_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu, u64 data)
 {
 	struct kvm_lapic *apic = vcpu->arch.apic;
 
-	if (!lapic_in_kernel(vcpu) || apic_lvtt_oneshot(apic) ||
+	if (!kvm_apic_present(vcpu) || apic_lvtt_oneshot(apic) ||
 			apic_lvtt_period(apic))
 		return;
 
-- 
2.7.4

