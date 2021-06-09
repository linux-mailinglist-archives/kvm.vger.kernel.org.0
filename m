Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 840BF3A0D92
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 09:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237200AbhFIHUb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 03:20:31 -0400
Received: from mail-pj1-f49.google.com ([209.85.216.49]:38636 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237197AbhFIHU2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 03:20:28 -0400
Received: by mail-pj1-f49.google.com with SMTP id m13-20020a17090b068db02901656cc93a75so845809pjz.3;
        Wed, 09 Jun 2021 00:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Cg8vN4m4UjDYZPCyoLn0Hc8/uX8h0VnIt9oJ71bSkSk=;
        b=PyFiwFEXAeWf/cZs/QHDibXj7WavIhu/OCxlEGKGRh3LgHI01/KUm62Xe1UnUxH+6M
         qV+99/MOpJWv2ZICrb+M89GJvXtCFVOV6ctwLxDXznw/8dEXXQNH+qSYvsMMRB4K+OW6
         UapyxrHpqilch+Z6JdGblAgC7jXxjduJ3UdIYxU09pTdVQSoar4xgISv/F2rTozwIrIe
         vAMYbHj7tJTksZ73x6Kxoh/ZuPlJ5uo1vVPX6jLR2yULVAU5dMgS3P5Vuk8cIGSGO1Hn
         igez93xQvxL91ceBlzkx82WCYlbL3kqFejNxLRTlRewy2pnIz7m+BjP90yNBoCTnhZ7a
         Cfag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Cg8vN4m4UjDYZPCyoLn0Hc8/uX8h0VnIt9oJ71bSkSk=;
        b=N/1QrkqiBgLvlNmORa2Igr/DivC5iBTKZJAGspqGzQF9w10rXvRIYMlYyKOKFScD7p
         eohtIDptpBiVkuZRTwUc9f2Sd6UMoReMSL71kflzI1SLNw7+uIMLWRSIS5C/4ASeP1bc
         03aaNEhNbNoCgmfYxLlEvSa99Px8ElR/Ho7VTZUXQ/aod/piYpj+qu2b3gYoYs2ZX3e+
         /wOW8q2EnzCmfWFjZcfb3RsXGbeqGFTEDfblcSfTRbmdhl60txOqDtFDHvLyBqMz7Zcl
         ARu9akmaJXhSR1YdeLs/a2qCiGrck/7HlChJpRwLRE486ICH6cCg1OMgxg5eFpQIc672
         /k7w==
X-Gm-Message-State: AOAM531tQ067UoKNvIFnUwaNvIOlI80EyacZ1gdn8j93kWfZ3IBt4M0a
        dZ8fKdurV2VV//VMsyn6cL+Qo0c3wLY=
X-Google-Smtp-Source: ABdhPJzcvHNVPC/gC3L8Jq+mvlNTCYpq82tOlS8SPuA+5xOrsUZTgjl2c2THbqsftoS/QqTWO9Hvrw==
X-Received: by 2002:a17:902:e04f:b029:eb:66b0:6d08 with SMTP id x15-20020a170902e04fb02900eb66b06d08mr3794454plx.50.1623223054027;
        Wed, 09 Jun 2021 00:17:34 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.40])
        by smtp.googlemail.com with ESMTPSA id c15sm13836164pgt.68.2021.06.09.00.17.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Jun 2021 00:17:33 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v3] KVM: LAPIC: Keep stored TMCCT register value 0 after KVM_SET_LAPIC
Date:   Wed,  9 Jun 2021 00:16:40 -0700
Message-Id: <1623223000-18116-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

KVM_GET_LAPIC stores the current value of TMCCT and KVM_SET_LAPIC's memcpy 
stores it in vcpu->arch.apic->regs, KVM_SET_LAPIC could store zero in 
vcpu->arch.apic->regs after it uses it, and then the stored value would 
always be zero. In addition, the TMCCT is always computed on-demand and 
never directly readable.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 6d72d8f43310..9bd29b3ca790 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2628,6 +2628,7 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 	apic_manage_nmi_watchdog(apic, kvm_lapic_get_reg(apic, APIC_LVT0));
 	update_divide_count(apic);
 	__start_apic_timer(apic, APIC_TMCCT);
+	kvm_lapic_set_reg(apic, APIC_TMCCT, 0);
 	kvm_apic_update_apicv(vcpu);
 	apic->highest_isr_cache = -1;
 	if (vcpu->arch.apicv_active) {
-- 
2.25.1

