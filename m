Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9BA63C74A5
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 18:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233294AbhGMQgf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 12:36:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232250AbhGMQgd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 12:36:33 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBA76C0613DD
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:33:42 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id g3-20020a256b030000b0290551bbd99700so27767466ybc.6
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=qVAaYnz6pX9NpBAvuefpA8nWzJech9ezcBMh3QJZR+s=;
        b=OR7dSXpwFlC+X0W7OqUvl4kIpeBJF+qjuDAJSMu2iAijKG2W0OPADSYrJ2Wlhv48mZ
         fgMSwugGchIv/CKKT4x2ilhtNc+qnQcrk8hQjzYDiR7aefplm7QDZGvv2zo6cVjGOjkH
         LJFpRk2h0pTzxk4r4bO5Hx8r+ZbiIfNVl8V4MmUGHxgwRHLeiFFNp0AWc0xE5YRzqf8Z
         7MBdicd6KCU7NsaXNX9b173HANfizgOfHUWoNINcFEf7t5MwiKgUIAfFjddfkZKfGsZZ
         S2+xwdBV4MhtbNLKwVLAB74Mx6z2AoDjZr7nxIspW7L3xOtOosiEdu3KZx0hn8gDmtUs
         HB4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=qVAaYnz6pX9NpBAvuefpA8nWzJech9ezcBMh3QJZR+s=;
        b=QYqouLJ1jwO11ud9EXK+RoOgQPuNPND3s+gxTnrTFGkeeA9nhqxWq2h1L71WvUqV+P
         eX4TGwyBovZJBYpFVzrK6GcSSiSp/5iJVTIR6sf5g34AIdXNkVPtDJ9PbWPkaFl/KJag
         UX/E7eZJ+jHIKiqEXZywtlBK7RiNLuorWbBq3+uGQAk7QlhpaBrsP7wlzlY3tz2RpPPV
         Xv9sAZPgTtRfNd7f8C1LCowGxCkhLja3S747+g2ksASBeKRHIVqBLHGNwDO+BN1FXcJk
         Xe2wMc/SR6qAoxrKQyJHRojbRSN4qDJOMfQ8DggyMv1E+xDUAF0mPbO5eOOHC2Z6h8C8
         ev8Q==
X-Gm-Message-State: AOAM5335+4i8MPaDBL0BlmghJNYF1qMjlzu0j72MjO37/nkIgKPzKLFn
        wPCvtHRIH3GbYBoE8gl3Zjjgc5JbMDY=
X-Google-Smtp-Source: ABdhPJyiyPuUnBaRxZJxtDyjf+Sb+7Fe/yKqvjWGeg/m1vbZgaG2C17q3843vEj6qP4u2s+znFWM0FGOyAg=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:825e:11a1:364b:8109])
 (user=seanjc job=sendgmr) by 2002:a25:888b:: with SMTP id d11mr7526792ybl.385.1626194022140;
 Tue, 13 Jul 2021 09:33:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Jul 2021 09:32:42 -0700
In-Reply-To: <20210713163324.627647-1-seanjc@google.com>
Message-Id: <20210713163324.627647-5-seanjc@google.com>
Mime-Version: 1.0
References: <20210713163324.627647-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v2 04/46] KVM: VMX: Set EDX at INIT with CPUID.0x1, Family-Model-Stepping
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set EDX at RESET/INIT based on the userspace-defined CPUID model when
possible, i.e. when CPUID.0x1.EAX is defind by userspace.  At RESET/INIT,
all CPUs that support CPUID set EDX to the FMS enumerated in
CPUID.0x1.EAX.  If no CPUID match is found, fall back to KVM's default
of 0x600 (Family '6'), which is the least awful approximation of KVM's
virtual CPU model.

Fixes: 6aa8b732ca01 ("[PATCH] kvm: userspace interface")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 927a552393b9..825197f21700 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4394,6 +4394,7 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	struct msr_data apic_base_msr;
+	u32 eax, dummy;
 	u64 cr0;
 
 	vmx->rmode.vm86_active = 0;
@@ -4401,7 +4402,11 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 
 	vmx->msr_ia32_umwait_control = 0;
 
-	vmx->vcpu.arch.regs[VCPU_REGS_RDX] = get_rdx_init_val();
+	eax = 1;
+	if (!kvm_cpuid(vcpu, &eax, &dummy, &dummy, &dummy, true))
+		eax = get_rdx_init_val();
+	kvm_rdx_write(vcpu, eax);
+
 	vmx->hv_deadline_tsc = -1;
 	kvm_set_cr8(vcpu, 0);
 
-- 
2.32.0.93.g670b81a890-goog

