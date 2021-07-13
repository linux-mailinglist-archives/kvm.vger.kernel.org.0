Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 157EF3C74D4
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 18:36:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235413AbhGMQhy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 12:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235114AbhGMQhk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 12:37:40 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0924C0611C4
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:34:25 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id o11-20020a056902110bb029055b266be219so27630092ybu.13
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=kqLCR8V7aHa3dOA8rm3sPsU8TE7Ylyd+IJ7q57+xdpQ=;
        b=L0uvO4Nv9mAWXOcCpamXUEqDt0dP2pLlpducZY/pkFLDNBb6CisQgY7KLoL4NAcPOt
         RQ3XWNG9KLTBSp+/jdBa2P2c1hCV+9Au3q5140kAxu1K2Rf3LyTPI68qZvgOWJljZZhq
         ICuDR47ZPk0YAsRREQ6ml0daxIhdHSGWt347Fm5yM1H/OYZP5G6GYrVYoodnbEolG/FG
         78tilrrB2SzFuOiAKU+pZsbwv/bEhk2d47GdogRw2w9gfFX1btQ8clLivylD4I/68S5q
         RM1WZv4axMrGE2U1gDQIZ03n8cZbE4Gd4QHuPEgw0bya3aldE4qeF1vtZ5pqZa6hJcrJ
         PZXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=kqLCR8V7aHa3dOA8rm3sPsU8TE7Ylyd+IJ7q57+xdpQ=;
        b=l7TJF+K6NUr1gwfvxw9oN0czETLcP/bbBW7FIRCJzb90K5R6iKInW4fd9NBkdLpZRY
         sD9DfLtUnfzqTEWQS7kjupe1JyeTaur3PlhVczuWeEn1CFG5tvYor2DdgMxhQYm7VlkQ
         E9GzVxdFpEQJsx0GpQRbCew67z6COm9unc5wp6067yshIIQHssrJ3eBndD2HmZJEBtcI
         OMtFWtIRP/qd2PH42B6nYn92KNe3Xx/YJo+TXiXd3lAG6Sj7V2URqd7s0RkhHQQcDtoY
         qqkrpJYX93rIBQc0fapn/F0lCtooIMktSO20/DtfHgPHrdZCAA5uYGzUhh3+y/y9Pf3K
         IVPw==
X-Gm-Message-State: AOAM531ux8BJ3yNF0g1hhpVRz5dsioQQr4vZuWO/ruNOIu8BQ4A99a0F
        ibbp5EasDfCrlX08teH5FGpfnx95zTA=
X-Google-Smtp-Source: ABdhPJyNNaY8GZpqQWIROfW9H0Rs0iusOrbZZt+VBtotb51SY27UM28YNDro4AqvL8BXrBUDivtbq+/vp5w=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:825e:11a1:364b:8109])
 (user=seanjc job=sendgmr) by 2002:a25:be8a:: with SMTP id i10mr6997224ybk.176.1626194065180;
 Tue, 13 Jul 2021 09:34:25 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Jul 2021 09:33:05 -0700
In-Reply-To: <20210713163324.627647-1-seanjc@google.com>
Message-Id: <20210713163324.627647-28-seanjc@google.com>
Mime-Version: 1.0
References: <20210713163324.627647-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v2 27/46] KVM: VMX: Process CR0.PG side effects after setting
 CR0 assets
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

Move the long mode and EPT w/o unrestricted guest side effect processing
down in vmx_set_cr0() so that the EPT && !URG case doesn't have to stuff
vcpu->arch.cr0 early.  This also fixes an oddity where CR0 might not be
marked available, i.e. the early vcpu->arch.cr0 write would appear to be
in danger of being overwritten, though that can't actually happen in the
current code since CR0.TS is the only guest-owned bit, and CR0.TS is not
read by vmx_set_cr4().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index d632c0a16f12..45b123bb5aaa 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3003,9 +3003,11 @@ void ept_save_pdptrs(struct kvm_vcpu *vcpu)
 void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	unsigned long hw_cr0;
+	unsigned long hw_cr0, old_cr0_pg;
 	u32 tmp;
 
+	old_cr0_pg = kvm_read_cr0_bits(vcpu, X86_CR0_PG);
+
 	hw_cr0 = (cr0 & ~KVM_VM_CR0_ALWAYS_OFF);
 	if (is_unrestricted_guest(vcpu))
 		hw_cr0 |= KVM_VM_CR0_ALWAYS_ON_UNRESTRICTED_GUEST;
@@ -3021,11 +3023,16 @@ void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 			enter_rmode(vcpu);
 	}
 
+	vmcs_writel(CR0_READ_SHADOW, cr0);
+	vmcs_writel(GUEST_CR0, hw_cr0);
+	vcpu->arch.cr0 = cr0;
+	kvm_register_mark_available(vcpu, VCPU_EXREG_CR0);
+
 #ifdef CONFIG_X86_64
 	if (vcpu->arch.efer & EFER_LME) {
-		if (!is_paging(vcpu) && (cr0 & X86_CR0_PG))
+		if (!old_cr0_pg && (cr0 & X86_CR0_PG))
 			enter_lmode(vcpu);
-		if (is_paging(vcpu) && !(cr0 & X86_CR0_PG))
+		else if (old_cr0_pg && !(cr0 & X86_CR0_PG))
 			exit_lmode(vcpu);
 	}
 #endif
@@ -3066,17 +3073,11 @@ void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 			exec_controls_set(vmx, tmp);
 		}
 
-		if (!is_paging(vcpu) != !(cr0 & X86_CR0_PG)) {
-			vcpu->arch.cr0 = cr0;
+		/* Note, vmx_set_cr4() consumes the new vcpu->arch.cr0. */
+		if ((old_cr0_pg ^ cr0) & X86_CR0_PG)
 			vmx_set_cr4(vcpu, kvm_read_cr4(vcpu));
-		}
 	}
 
-	vmcs_writel(CR0_READ_SHADOW, cr0);
-	vmcs_writel(GUEST_CR0, hw_cr0);
-	vcpu->arch.cr0 = cr0;
-	kvm_register_mark_available(vcpu, VCPU_EXREG_CR0);
-
 	/* depends on vcpu->arch.cr0 to be set to a new value */
 	vmx->emulation_required = emulation_required(vcpu);
 }
-- 
2.32.0.93.g670b81a890-goog

