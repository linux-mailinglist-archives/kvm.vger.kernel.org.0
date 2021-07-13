Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA1A53C74D0
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 18:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235399AbhGMQhm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 12:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235293AbhGMQh2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 12:37:28 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18FA2C0613AC
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:34:22 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id h1-20020a255f410000b02905585436b530so27738425ybm.21
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=CgrSZBstNZwFy9Uo6jdcpFw84xBpoqNrT77cRxMhd+E=;
        b=dIYjzPGsJ6TLn2wVcO+Ux1e9QGqStPI+HZp8nyXUUAtU47hnu0NRDZeyBPGX0xFdOO
         CXTsHUJY33F6lOorYUZ0Llq6fkPEaeM4tReHGBoya2vw8YVLMng/27ngwKQy82UJdyvq
         41l7qU7Vk53muwMcq7TtV5Zh1c4lwHBklW7C9ce/5AfBsbN+9oAHO5/C60HoBLd8np7H
         K/rngvmcWlQFtWxii1lpF4dxVsiOTrn6nxvHagBhdOuPiTMMRZs7CM3/jFZazKs2aWkV
         G0kawCHRm+J0IE3KlcNr1SEAFRDRvWLkCRIksCBe0P6T4ZNiuZ0wsS2VYZwSWvUzLt0z
         qa6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=CgrSZBstNZwFy9Uo6jdcpFw84xBpoqNrT77cRxMhd+E=;
        b=Zl6fY8wg2w+rRlWNsnrBpr0FSF9BrC2G37/bBYSDK+AOxb1FO4RZpsFjHqpSDGybmh
         Fjodya8lr8g+xU4LhiJ5le9LOWCwU2xWMeX83xkbERkbH1afSGWE8yO4EMUUcMzS0z4a
         5SbwO4BDNl5jzsH0TNRTzMMKhJ09wM/VJ1T45VnfJP+IAHIRhT6L8UGG5CLt54Xm6wa0
         U54y1FERwTSCS6uz9vs2PvMe5OiYlslXPa5EZdY3pJ3kqJ/PHVWI2l0mBAIGI0MZX5eJ
         oHKlDmotNi6qvwYiXEIvMGG5Ln3IOopcaB5QV0PWMsoeWWD1Qd79aW+M7iiDzAFu1R/P
         16RA==
X-Gm-Message-State: AOAM533NnCcjm982DWm/gSSqk4f2WcC5XUTQCEDXkai0k2pqSImj8tgC
        DK7azB2f6eHRex/oO8caKEQcNomvySk=
X-Google-Smtp-Source: ABdhPJyAx6+D/2SdrYQx5dm7fHrEFUIbnOPmhfqtgcFzKyqmQ1LUZK792ZNmUj9molVy3SElH+EwUtvhOuY=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:825e:11a1:364b:8109])
 (user=seanjc job=sendgmr) by 2002:a25:258:: with SMTP id 85mr7222066ybc.109.1626194061338;
 Tue, 13 Jul 2021 09:34:21 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Jul 2021 09:33:03 -0700
In-Reply-To: <20210713163324.627647-1-seanjc@google.com>
Message-Id: <20210713163324.627647-26-seanjc@google.com>
Mime-Version: 1.0
References: <20210713163324.627647-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v2 25/46] KVM: VMX: Pull GUEST_CR3 from the VMCS iff CR3 load
 exiting is disabled
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

Tweak the logic for grabbing vmcs.GUEST_CR3 in vmx_cache_reg() to look
directly at the execution controls, as opposed to effectively inferring
the controls based on vCPUs.  Inferring the controls isn't wrong, but it
creates a very subtle dependency between the caching logic, the state of
vcpu->arch.cr0 (via is_paging()), and the behavior of vmx_set_cr0().

Using the execution controls doesn't completely eliminate the dependency
in vmx_set_cr0(), e.g. neglecting to cache CR3 before enabling
interception would still break the guest, but it does reduce the
code dependency and mostly eliminate the logical dependency (that CR3
loads are intercepted in certain scenarios).  Eliminating the subtle
read of vcpu->arch.cr0 will also allow for additional cleanup in
vmx_set_cr0().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 58c6d7b98624..d632c0a16f12 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2262,8 +2262,11 @@ static void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
 		vcpu->arch.cr0 |= vmcs_readl(GUEST_CR0) & guest_owned_bits;
 		break;
 	case VCPU_EXREG_CR3:
-		if (is_unrestricted_guest(vcpu) ||
-		    (enable_ept && is_paging(vcpu)))
+		/*
+		 * When intercepting CR3 loads, e.g. for shadowing paging, KVM's
+		 * CR3 is loaded into hardware, not the guest's CR3.
+		 */
+		if (!(exec_controls_get(to_vmx(vcpu)) & CPU_BASED_CR3_LOAD_EXITING))
 			vcpu->arch.cr3 = vmcs_readl(GUEST_CR3);
 		break;
 	case VCPU_EXREG_CR4:
-- 
2.32.0.93.g670b81a890-goog

