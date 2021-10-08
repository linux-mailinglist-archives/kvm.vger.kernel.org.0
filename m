Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FFA542673F
	for <lists+kvm@lfdr.de>; Fri,  8 Oct 2021 11:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239485AbhJHKA1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 06:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238917AbhJHKAZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 06:00:25 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB339C061570;
        Fri,  8 Oct 2021 02:58:30 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id g5so2785323plg.1;
        Fri, 08 Oct 2021 02:58:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=j2q5akxrmJ1uW+0AGmi44yh3ldXa7zUiHWRb/q4x2xg=;
        b=CUp0kbyb2DbyBRFmtl7ELnbt9XV1afFor5Db3z7mz42DwseAUsjls2ZQnKAgmDqOpX
         iAlmoptFfSBYTeFYl5n3aBUy/EHAV43DiR4W8xxflMJ2OdAYHWIV7Tx7Fc5mTGtf4wG4
         29JvTILaDTjM8anolQHloTyjdYNeTRZjdUekx1HtHxV682eslYu0kMVF1xR9iNthFECA
         uYE1jtHBFodVrKG4uG/vkSsKyqiacLwWFgrxI6w1xbwBr6y07tKnRQXIVeOv2d1+Eq1k
         haqZ2a6SfvQ9RGMDxIJ9XID156ZCPRhe/liz4vyUZ78hTh/NyT4TX1aMhhJuJjR+QPDs
         kN8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=j2q5akxrmJ1uW+0AGmi44yh3ldXa7zUiHWRb/q4x2xg=;
        b=UeRd0iIvEtMmxwwO5GG6pyy4q+j36eys6X/OmOGm4hPClzsHCn/drD2rzF/IqeHK2s
         PUBQ3SFuTi2X14iXd6DJNut2btUZuXl977RAxq83O8qD2CInYOOibj9n9N4/3IkzH1Vl
         yeW/rvrKCYXt68O0M9ltbjhuSLwQgGcjAUreGKI6UFY/nEqWOOurKKo8zfsUIOOu38tg
         ystZSDysMgMGWfFCupWCqxTPnIVoovKzNWJKMVo+YJKtz05Ak7t70ruIm+lZrcKLd+CG
         +iWjyI7CalzQEItvreoZf/O2KvZPcYWFvuJPsLdItMk+N74A8fPSe8SVBqvw1DhVPRly
         +WkA==
X-Gm-Message-State: AOAM531ykjoQvDvaiuVkFpbSC75Kfdasm7dlEVEfgM2+DGGdglPP2uhT
        v5zk23ctnrUDlkk21iWebHMg0Gcj3r6GdA==
X-Google-Smtp-Source: ABdhPJwhQQWgKsMw2vJaY3bOAzQPsJaoztggPFtM32i4WbyVXZeAeGaxa6uLCny4XD+JtTebXTrYZQ==
X-Received: by 2002:a17:902:7b98:b0:138:c171:c1af with SMTP id w24-20020a1709027b9800b00138c171c1afmr8589936pll.70.1633687110221;
        Fri, 08 Oct 2021 02:58:30 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.117])
        by smtp.googlemail.com with ESMTPSA id mu7sm2121148pjb.12.2021.10.08.02.58.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Oct 2021 02:58:29 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 3/3] KVM: LAPIC: Optimize PMI delivering overhead
Date:   Fri,  8 Oct 2021 02:57:34 -0700
Message-Id: <1633687054-18865-3-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1633687054-18865-1-git-send-email-wanpengli@tencent.com>
References: <1633687054-18865-1-git-send-email-wanpengli@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

The overhead of kvm_vcpu_kick() is huge since expensive rcu/memory
barrier etc operations in rcuwait_wake_up(). It is worse when local 
delivery since the vCPU is scheduled and we still suffer from this. 
We can observe 12us+ for kvm_vcpu_kick() in kvm_pmu_deliver_pmi() 
path by ftrace before the patch and 6us+ after the optimization. 

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/lapic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 76fb00921203..ec6997187c6d 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1120,7 +1120,8 @@ static int __apic_accept_irq(struct kvm_lapic *apic, int delivery_mode,
 	case APIC_DM_NMI:
 		result = 1;
 		kvm_inject_nmi(vcpu);
-		kvm_vcpu_kick(vcpu);
+		if (vcpu != kvm_get_running_vcpu())
+			kvm_vcpu_kick(vcpu);
 		break;
 
 	case APIC_DM_INIT:
-- 
2.25.1

