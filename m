Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3517E369E1E
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 02:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244528AbhDXAxR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 20:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244612AbhDXAvt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 20:51:49 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F36AC061345
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:48:00 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id n11-20020a25808b0000b02904d9818b80e8so26106960ybk.14
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=JqcOnCGExfR3YjMtsB4lLkNrTfGGIsxEsg5SkDkGdDA=;
        b=hTIMu62j1JfVoMqUJDMRxt4mX6dRaa2v8VIO52tvPHuQXjRNo0B9jHOMT4XZ66Ge8h
         /OafbtDyprXRunXNaiH0JuDl+PhiPUF1F91bHHOkmTWu20fMrd+4/2lporx6mFkHLz/Q
         53/btJAj3u5jCLr4l8M/FVswWMOcZFPHi5yObFtdEf5FGPv/ntYqMDsE/6HUniIWceLa
         UDlZz/XxdEuF8pNOW75zu1kPSBXUOuDz3ztcQ1zlQkCziPqxlZU/JyzbnAme7Bc26E9b
         e0jzQLjBdMzi4QrKpoa/olCS85DNJsb9g3SuAF0rJ4yfVDujU0y29sqcGcFb8DLkBAKw
         YlDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=JqcOnCGExfR3YjMtsB4lLkNrTfGGIsxEsg5SkDkGdDA=;
        b=eEPJAsG040OT6SR2EOJVjPRiKLUPv0LUhHuXUpnmyRR1HcH0RYX2rki/8MiGLzzPGm
         sZ4yPsF5PC4XdrUKlsP7Dh1C4cQHmwgZBFAmvIVlkM+f0mnOsOT/KlrO7BlTyNhjRmWJ
         pDWHOfoVBlcndNPKJDje57M5Hf4iinDN6qv51/rkWgjBPY2Mnkmx00LCtO6A0s0L+v0g
         APY48apvADZ2Px/6ydSLbnVC9NQsCAt6iDZhXlaFaCkbRTsQ/j3072FInfiqxLw/76vI
         gbmb354QXO3LN8Ga9zQOsjV/p7xTBzIWYj/RLBMTtZFzlbfju+Kcr9+Tu4FBZ/FV1Fe1
         vSFA==
X-Gm-Message-State: AOAM531L/8SMTrJw10EpFlHXbsOB8C9kz0luvwqrT+J7Pf1ge5Zr44ta
        042ivsPU4OyVszWjQIHTEjhqnq9JMfc=
X-Google-Smtp-Source: ABdhPJwVdft0X93b33hr5Zga9hH9TiTwaqFgtZy6VqZeveX1PGKa6J1UAlQo8+Z0r4MKQLjWN2y5mbO25r8=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:ad52:3246:e190:f070])
 (user=seanjc job=sendgmr) by 2002:a25:d152:: with SMTP id i79mr10295563ybg.328.1619225279897;
 Fri, 23 Apr 2021 17:47:59 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Apr 2021 17:46:29 -0700
In-Reply-To: <20210424004645.3950558-1-seanjc@google.com>
Message-Id: <20210424004645.3950558-28-seanjc@google.com>
Mime-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 27/43] KVM: VMX: Skip emulation required checks during
 pmode/rmode transitions
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

Don't refresh "emulation required" when stuffing segments during
transitions to/from real mode when running without unrestricted guest.
The checks are unnecessary as vmx_set_cr0() unconditionally rechecks
"emulation required".  They also happen to be broken, as enter_pmode()
and enter_rmode() run with a stale vcpu->arch.cr0.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5f30181fd240..37bfa20a04dd 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2827,6 +2827,8 @@ static __init int alloc_kvm_area(void)
 	return 0;
 }
 
+static void __vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg);
+
 static void fix_pmode_seg(struct kvm_vcpu *vcpu, int seg,
 		struct kvm_segment *save)
 {
@@ -2843,7 +2845,7 @@ static void fix_pmode_seg(struct kvm_vcpu *vcpu, int seg,
 		save->dpl = save->selector & SEGMENT_RPL_MASK;
 		save->s = 1;
 	}
-	vmx_set_segment(vcpu, save, seg);
+	__vmx_set_segment(vcpu, save, seg);
 }
 
 static void enter_pmode(struct kvm_vcpu *vcpu)
@@ -2864,7 +2866,7 @@ static void enter_pmode(struct kvm_vcpu *vcpu)
 
 	vmx->rmode.vm86_active = 0;
 
-	vmx_set_segment(vcpu, &vmx->rmode.segs[VCPU_SREG_TR], VCPU_SREG_TR);
+	__vmx_set_segment(vcpu, &vmx->rmode.segs[VCPU_SREG_TR], VCPU_SREG_TR);
 
 	flags = vmcs_readl(GUEST_RFLAGS);
 	flags &= RMODE_GUEST_OWNED_EFLAGS_BITS;
@@ -3399,7 +3401,7 @@ static u32 vmx_segment_access_rights(struct kvm_segment *var)
 	return ar;
 }
 
-void vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg)
+static void __vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 	const struct kvm_vmx_segment_field *sf = &kvm_vmx_segment_fields[seg];
@@ -3412,7 +3414,7 @@ void vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg)
 			vmcs_write16(sf->selector, var->selector);
 		else if (var->s)
 			fix_rmode_seg(seg, &vmx->rmode.segs[seg]);
-		goto out;
+		return;
 	}
 
 	vmcs_writel(sf->base, var->base);
@@ -3434,9 +3436,13 @@ void vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg)
 		var->type |= 0x1; /* Accessed */
 
 	vmcs_write32(sf->ar_bytes, vmx_segment_access_rights(var));
+}
 
-out:
-	vmx->emulation_required = emulation_required(vcpu);
+void vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg)
+{
+	__vmx_set_segment(vcpu, var, seg);
+
+	to_vmx(vcpu)->emulation_required = emulation_required(vcpu);
 }
 
 static void vmx_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l)
-- 
2.31.1.498.g6c1eba8ee3d-goog

