Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25A2F3C74F3
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 18:36:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236088AbhGMQir (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 12:38:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235829AbhGMQii (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 12:38:38 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3805DC05BD32
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:34:58 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id l16-20020a25cc100000b0290558245b7eabso27775815ybf.10
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:34:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=kkwdoJIGvsW7E6rhoByJg5nAs3eFczhVd+MvdJJpI18=;
        b=qGHaSx/UlBq3fT7bOWw8v4WtpLzwISDRglaEYJFcQBgOupLdDvDCtvgvBQ5s3lmxSg
         Qnk6Tu/bMf2Ll24BFQNUi1QyXQyXTWeu/+GXQAOsUuZZt33XkS054wtvx/Nogp8zmLdH
         ZGFzFG0XyDq4qWw0pIZB9JcQwqO1FcbyVMdd7dv3M6rnorldK9rsMLTSW2F+yJ6YZ8h5
         km13PAJmaDBqmQn44DUtXDth1qM69k2l+o8Roz5hG4FDeBYbpGYxX61LZ18985TeeYMn
         2PczuNTLwAuC1inZ0rmuHUezMYE+P3Kuk30agrd5tyTGS+LDCXR4/JW7N35JG/izUPJq
         iM2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=kkwdoJIGvsW7E6rhoByJg5nAs3eFczhVd+MvdJJpI18=;
        b=Cfjdpnp+cQ6jrOhw92oiQzZGDvE+qNrHF788nrPEWqA6wMuIM+DSKS206Bnf/TaJqZ
         ImjkyNo+mRExqsKVDBR0nB1h0kaKJSWPWqm2ST6z89B2TsqTD3ffGsEihVtPzvPsw32x
         BbtAIAbFNvubE6i9seAlHsHdq9M8w7nco/XvZD3eQhCx2WFAg7G328eeC1ePV5KiRN3L
         fUL6vxY8sVq6ASYl5ibS5g8dFvnCzSMauuPyIHTu8dbiFpr+nw8NyA5AVPZFp6vMsODT
         vNsRKb8kshmpLvBYoMOdbcvJ0wVFS5EZiXUxQ/0oLT4VjvX+frWKs6d9ZR0ZQyTb7Tiy
         4DAA==
X-Gm-Message-State: AOAM532Ytyp8bTENc4kI5vrZvtwIp5mi2YlqzNlVT7TOVldOx93IxWRD
        /k2qpUyLJ++c0+gf1RO+VdysQVilqcQ=
X-Google-Smtp-Source: ABdhPJxrYd/echyvro/44ZRTVuasMTDq61J+3yCP8qTNghRGTn2OkROQt5Le6/N6bkpMboEQMwfaEed2LNU=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:825e:11a1:364b:8109])
 (user=seanjc job=sendgmr) by 2002:a25:9bc4:: with SMTP id w4mr6530083ybo.168.1626194097439;
 Tue, 13 Jul 2021 09:34:57 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Jul 2021 09:33:21 -0700
In-Reply-To: <20210713163324.627647-1-seanjc@google.com>
Message-Id: <20210713163324.627647-44-seanjc@google.com>
Mime-Version: 1.0
References: <20210713163324.627647-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v2 43/46] KVM: VMX: Move RESET-only VMWRITE sequences to init_vmcs()
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

Move VMWRITE sequences in vmx_vcpu_reset() guarded by !init_event into
init_vmcs() to make it more obvious that they're, uh, initializing the
VMCS.

No meaningful functional change intended (though the order of VMWRITEs
and whatnot is different).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 4acfb2f450e6..97fa2aa676bd 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4393,6 +4393,19 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 		vmcs_write64(GUEST_IA32_RTIT_CTL, 0);
 	}
 
+	vmcs_write32(GUEST_SYSENTER_CS, 0);
+	vmcs_writel(GUEST_SYSENTER_ESP, 0);
+	vmcs_writel(GUEST_SYSENTER_EIP, 0);
+	vmcs_write64(GUEST_IA32_DEBUGCTL, 0);
+
+	if (cpu_has_vmx_tpr_shadow()) {
+		vmcs_write64(VIRTUAL_APIC_PAGE_ADDR, 0);
+		if (cpu_need_tpr_shadow(&vmx->vcpu))
+			vmcs_write64(VIRTUAL_APIC_PAGE_ADDR,
+				     __pa(vmx->vcpu.arch.apic->regs));
+		vmcs_write32(TPR_THRESHOLD, 0);
+	}
+
 	vmx_setup_uret_msrs(vmx);
 }
 
@@ -4433,13 +4446,6 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	vmcs_write32(GUEST_LDTR_LIMIT, 0xffff);
 	vmcs_write32(GUEST_LDTR_AR_BYTES, 0x00082);
 
-	if (!init_event) {
-		vmcs_write32(GUEST_SYSENTER_CS, 0);
-		vmcs_writel(GUEST_SYSENTER_ESP, 0);
-		vmcs_writel(GUEST_SYSENTER_EIP, 0);
-		vmcs_write64(GUEST_IA32_DEBUGCTL, 0);
-	}
-
 	vmcs_writel(GUEST_GDTR_BASE, 0);
 	vmcs_write32(GUEST_GDTR_LIMIT, 0xffff);
 
@@ -4454,14 +4460,6 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 
 	vmcs_write32(VM_ENTRY_INTR_INFO_FIELD, 0);  /* 22.2.1 */
 
-	if (cpu_has_vmx_tpr_shadow() && !init_event) {
-		vmcs_write64(VIRTUAL_APIC_PAGE_ADDR, 0);
-		if (cpu_need_tpr_shadow(vcpu))
-			vmcs_write64(VIRTUAL_APIC_PAGE_ADDR,
-				     __pa(vcpu->arch.apic->regs));
-		vmcs_write32(TPR_THRESHOLD, 0);
-	}
-
 	kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
 
 	vpid_sync_context(vmx->vpid);
-- 
2.32.0.93.g670b81a890-goog

