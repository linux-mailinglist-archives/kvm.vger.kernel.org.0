Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E65936775A
	for <lists+kvm@lfdr.de>; Thu, 22 Apr 2021 04:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234272AbhDVCWR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Apr 2021 22:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233606AbhDVCWP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Apr 2021 22:22:15 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3908C06174A
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 19:21:40 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id p9-20020a2574090000b02904e2cb6a90e7so18286877ybc.17
        for <kvm@vger.kernel.org>; Wed, 21 Apr 2021 19:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=I0Pc+WtQCqohFg3KL72AUf+SIVAkRNg4ejFXFBQIKY8=;
        b=H0CqJwhhEVGt3OZ7zmk052Lw3nGLSiNFdL+CgD1B03FsuXEY0C0gFnwhet8PntI872
         Q9MoodaRpvytWq9vVyfyRLtUcUKNWit8lYcu4I0fHHgG/XUfpqJ7ErJdwWl7CDJg2PNc
         MNjB3PaBRxKotaVxXaNIr9eDwYKvlWmxqE/lFwB1GIq20KTtjvL+i/M1qP2Daj0xjxwQ
         1+Q2XclcP9g+x42/NjOi177KVLwNstR/MUfmFshal9ChaGbk6lP6ekCiEYcK/ru9Ouiz
         lqv7BzUOR2Prde6EZFhnAXGKnuP3kMF3p9zmyaNQlzdSKobjtgFHXt6zFfz/yWx/8JF7
         Scgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=I0Pc+WtQCqohFg3KL72AUf+SIVAkRNg4ejFXFBQIKY8=;
        b=V+qKuQLvbxIycXt9wIOnd5JJ2Aegu7y/iVCK42aVIm0L9GybfkOUgUNztO3eE0LlSx
         wHvS2Y9oIAVzcVCmlTsQ/ryXmFNQaR37BHMZb6x/1lU6ObUCaxGWe3QyUYPvgW8+D6YR
         I+1KNiDLvVd8bYvCmCySo4I9Av5iNC2O6KG1ZLNfi0Ujtj2hQwnlB0+W55gpmHH3Cxt4
         87oDGgvR5BzB0eVvtJbUKPenITfsgs2Z+5reD/5fVNpH+QzRDofc+QzbVnKoAU7/k7s5
         bH8wUsGOOHCxe1kSmDH5d5ojRs4CgLWlQncEYRwntT5yc8zCOJtq2x630dS7PBHKZIcm
         s2Zw==
X-Gm-Message-State: AOAM530gPeSUyR801Py6BMKeAugWh0u/9IESr7IwFLtCASWUEpJFLk8r
        RG7UqwLSKcCgwRFf7rSUogqh7coGzgA=
X-Google-Smtp-Source: ABdhPJz/m6k3D3uKftTpKJ5RTzO9n0WC+YUy1Du1c5pKALGSe+ONm/82GevhxcEbVE7jw34a1QP/FTkw4IQ=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e012:374c:592:6194])
 (user=seanjc job=sendgmr) by 2002:a05:6902:68a:: with SMTP id
 i10mr1456012ybt.0.1619058099879; Wed, 21 Apr 2021 19:21:39 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 21 Apr 2021 19:21:23 -0700
In-Reply-To: <20210422022128.3464144-1-seanjc@google.com>
Message-Id: <20210422022128.3464144-5-seanjc@google.com>
Mime-Version: 1.0
References: <20210422022128.3464144-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH v2 4/9] KVM: VMX: Truncate GPR value for DR and CR reads in
 !64-bit mode
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Babu Moger <babu.moger@amd.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        David Woodhouse <dwmw@amazon.co.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop bits 63:32 when storing a DR/CR to a GPR when the vCPU is not in
64-bit mode.  Per the SDM:

  The operand size for these instructions is always 32 bits in non-64-bit
  modes, regardless of the operand-size attribute.

CR8 technically isn't affected as CR8 isn't accessible outside of 64-bit
mode, but fix it up for consistency and to allow for future cleanup.

Fixes: 6aa8b732ca01 ("[PATCH] kvm: userspace interface")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6501d66167b8..7ef4c11d655b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5132,12 +5132,12 @@ static int handle_cr(struct kvm_vcpu *vcpu)
 		case 3:
 			WARN_ON_ONCE(enable_unrestricted_guest);
 			val = kvm_read_cr3(vcpu);
-			kvm_register_write(vcpu, reg, val);
+			kvm_register_writel(vcpu, reg, val);
 			trace_kvm_cr_read(cr, val);
 			return kvm_skip_emulated_instruction(vcpu);
 		case 8:
 			val = kvm_get_cr8(vcpu);
-			kvm_register_write(vcpu, reg, val);
+			kvm_register_writel(vcpu, reg, val);
 			trace_kvm_cr_read(cr, val);
 			return kvm_skip_emulated_instruction(vcpu);
 		}
@@ -5210,7 +5210,7 @@ static int handle_dr(struct kvm_vcpu *vcpu)
 		unsigned long val;
 
 		kvm_get_dr(vcpu, dr, &val);
-		kvm_register_write(vcpu, reg, val);
+		kvm_register_writel(vcpu, reg, val);
 		err = 0;
 	} else {
 		err = kvm_set_dr(vcpu, dr, kvm_register_readl(vcpu, reg));
-- 
2.31.1.498.g6c1eba8ee3d-goog

