Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE62C369E24
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 02:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232742AbhDXAx7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 20:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244170AbhDXAwf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 20:52:35 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2E6EC06137D
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:48:04 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id p2-20020ad452e20000b0290177fba4b9d5so19500078qvu.6
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=8FPjB9kODcd44RP7aC0zZao6wso5dTHmRwxsyhm3GIU=;
        b=ozB2Ag/eEMci6Fo+7ypR3EpsxZvT2N3jckC41JPYLCyLZwWueyWwAysuxItZ2uzeKk
         dpjozZ5Nl/F2ZREDDjmNT8iq3zQb2GESNIkIBQG5Dwrf+mYRNAvaLnDCV/7DJiD44wBv
         YC2PMSKYAIOVLxE48ilkyk3/LA3WyNk6B9Jng9Sgwn/WOMIVOrU8Dm7fBiLo0XQO61f3
         EQxbHW1IJS+ehHCIvH06rMTYNo11dvUqMKFaf4eQ0c3CD7SAgujPQmMRdCm1ovOPxaOn
         IGJaOgkSTQEq2VrAL0BtxRe3J1J3zMrNtWainJ6cQo+NbgUMoSqVmShRfLKLmFQMc0Mb
         wL+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=8FPjB9kODcd44RP7aC0zZao6wso5dTHmRwxsyhm3GIU=;
        b=nSmrNrraezwdPH39Ww7sgUTfoN9YtwzXIOmRdyCFEYfzP/0NEs1KlpN9G6ORkHu5Ja
         Tro3tBegoUaOeq5ySLL0n9wdB+bnd3dENxISy21G/mW1K6hMNyYMy9TNWWVy9miriiSY
         L6QObF53p6LBd4i/bATvX6up+BBsnHefBqTR1lgrdoVH24knsbg2yPigwufTX0vv8bck
         svqx3FJ4lF74CxBqLZsSY5nn9AY4PyN7aMWYJ7MllR0J9HZ40aR6ctw4z2G/Ik0MC135
         z5/t+4+898ICKiaLOCfOBiEFUZCerS4wrWx2HEP1IolxNbcUlvSOL0OSw4eCZSR1sMd9
         aoTQ==
X-Gm-Message-State: AOAM531ON9kqA5cGNiURG49AdAlRGX37B/XKhTHthR3l/TxOASvjZQhJ
        4b9xufhejtpTExBqIQzEKxNsx44Iwr0=
X-Google-Smtp-Source: ABdhPJwIe4aMtREwCdKlN8Ejc4nv8qWnmoGL1M73/G1IxtPwJ/CZeAKF0LNUA6wkJbNTrlSMirS4uyZ9p+w=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:ad52:3246:e190:f070])
 (user=seanjc job=sendgmr) by 2002:ad4:4e01:: with SMTP id dl1mr7170885qvb.9.1619225284120;
 Fri, 23 Apr 2021 17:48:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Apr 2021 17:46:31 -0700
In-Reply-To: <20210424004645.3950558-1-seanjc@google.com>
Message-Id: <20210424004645.3950558-30-seanjc@google.com>
Mime-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 29/43] KVM: SVM: Tweak order of cr0/cr4/efer writes at RESET/INIT
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hoist svm_set_cr0() up in the sequence of register initialization during
vCPU RESET/INIT, purely to match VMX so that a future patch can move the
sequences to common x86.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 4ea100c08cb3..88d34fa93d8b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1204,18 +1204,13 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 	init_sys_seg(&save->ldtr, SEG_TYPE_LDT);
 	init_sys_seg(&save->tr, SEG_TYPE_BUSY_TSS16);
 
+	svm_set_cr0(vcpu, X86_CR0_NW | X86_CR0_CD | X86_CR0_ET);
 	svm_set_cr4(vcpu, 0);
 	svm_set_efer(vcpu, 0);
 	save->dr6 = 0xffff0ff0;
 	kvm_set_rflags(vcpu, X86_EFLAGS_FIXED);
 	vcpu->arch.regs[VCPU_REGS_RIP] = 0x0000fff0;
 
-	/*
-	 * svm_set_cr0() sets PG and WP and clears NW and CD on save->cr0.
-	 * It also updates the guest-visible cr0 value.
-	 */
-	svm_set_cr0(vcpu, X86_CR0_NW | X86_CR0_CD | X86_CR0_ET);
-
 	save->cr4 = X86_CR4_PAE;
 
 	if (npt_enabled) {
-- 
2.31.1.498.g6c1eba8ee3d-goog

