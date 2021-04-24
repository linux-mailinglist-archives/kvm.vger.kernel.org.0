Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43EA6369E1B
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 02:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244445AbhDXAxK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 20:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244474AbhDXAvo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 20:51:44 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D439C061377
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:47:56 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id e8-20020a2587480000b02904e5857564e2so26353682ybn.16
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=BsJdegcuVAgkFqlKM15IX9VerfL7fgnioVjMhrNs33k=;
        b=vLlkN+LUxUzZtGrOzpsmPmPjsmrhAnES/tWoBJJAyibAJP7P+KimwEM8v/xj1BDKMC
         lXBRoAMO9dPZhq3w9t/iBTqjbi4qgn6+fD3Nrwqwu7RJu7eTeAX3GBs0sgulKAQHxGBC
         TCnXsZeo8VIbirryF19u2K/pH+fusn98DIKywWHtCeTR5cFWqrm+su5xf8Ai77gXGOYY
         Wf7h65B9fb4f6LJuWuPQRLIOmjkEOVHv0QluCrjL85hA9eDHjcp8h/bf35+Nzg40Kx/P
         4FmVIlL1eHGsjH4XBMx+8O7l2U8NzcI7oOWzah/msl0AKrrwW62V8OnCHuUQnPuOEAhw
         hgGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=BsJdegcuVAgkFqlKM15IX9VerfL7fgnioVjMhrNs33k=;
        b=DECXhpGiRdW/4sMVz6xtFY4SjCpv61YQWchSWdc3Wk0XiMa+IjIpDB7bdKa+CDdSVJ
         sd6a0a2iElO2CntfXvYxoYaIJAFXBOZLOZPwvkgXwsHj1apofB7AvXlcxaEKuAQKrWAY
         /lPPpHxj3HFaHKoKPOgw7uNnsobqaMYzePZFaVPvQFyVjjrTe8FjE6cGKRVe6hHxtV8J
         5YlWDmUTdNfOzKqoVdkFfqU9jPSHHMU2NmFFfXwMH4zoxrrLLMQS6TPMrvnzX1EGzgyf
         Mc63jhoqzkyZtS1tjyzpcdt8fVFA2AiXcBLGTdzhca5qgZthEc/C19UrA5h4rmFZb+5A
         XdpQ==
X-Gm-Message-State: AOAM533voybDatsC3hbBS8n+oOkZmyslQ+YDjDv12SzoQ+AbxrnNnZPm
        +cH/H2dk7W84aF+IrnsQ5TGTZYxLZOk=
X-Google-Smtp-Source: ABdhPJzyPJomgsq6ZqoDzIcmkO1nI1sk1jfKTrA9H1DUUKS9RODIf5HQq30YKdvPbZsH69RJwsrH5f8n32g=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:ad52:3246:e190:f070])
 (user=seanjc job=sendgmr) by 2002:a25:5883:: with SMTP id m125mr8938555ybb.171.1619225275305;
 Fri, 23 Apr 2021 17:47:55 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Apr 2021 17:46:27 -0700
In-Reply-To: <20210424004645.3950558-1-seanjc@google.com>
Message-Id: <20210424004645.3950558-26-seanjc@google.com>
Mime-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 25/43] KVM: VMX: Pull GUEST_CR3 from the VMCS iff CR3 load
 exiting is disabled
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

Tweak the logic for grabbing vmcs.GUEST_CR3 in vmx_cache_reg() to look
directly at the execution controls, as opposed to effectively inferring
the controls from vCPUs state.  Inferring the controls isn't wrong, but it
creates a very subtle dependency between the caching logic, the state of
vcpu->arch.cr0 (via is_paging()), and the behavior of vmx_set_cr0().

Using the execution controls doesn't completely eliminate the dependency
in vmx_set_cr0(), e.g. neglecting to cache CR3 before enabling
interception would still break the guest, but it does reduce the
code dependency and mostly eliminate the logical dependency (that CR3
loads are intercepted in certain scenarios).  Eliminating the sublte
read of vcpu->arch.cr0 will also allow for additional cleanup in
vmx_set_cr0().

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e42ae77e4b82..596c8f9766ac 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2370,8 +2370,11 @@ static void vmx_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
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
2.31.1.498.g6c1eba8ee3d-goog

