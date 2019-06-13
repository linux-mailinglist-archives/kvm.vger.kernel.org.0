Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A88F44810
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 19:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404541AbfFMREC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 13:04:02 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36969 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393356AbfFMREA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 13:04:00 -0400
Received: by mail-wm1-f66.google.com with SMTP id 22so10899332wmg.2;
        Thu, 13 Jun 2019 10:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6frhBg5HfhrV+PE9A95yhtehkieS04QOaLeH3DNydrU=;
        b=F1r80rLFjjtqqyi1EZj7IGMYTN+WiC4M2tN/VxRQipq6FfPmjT+tEbJOconmEl2ddT
         4nuMFXOLB82A3xxqppvVP5vkTilRmca5d3wsFq2UWAQVvRjKmoQxOp5ME9RyIaBdoqUa
         oX3+6EtDga+6b5dExhc0tlZl1DgIIZqytaL8Vt+yyW2hHSgDjKlU024u+vjxUG+5Kisk
         AN2kQE80frTiWn8LRJDLa6qOA9pvpScHagtMPIRwRojIkuU/RtPhy2altQ7pKD8t1g82
         rOuBNpPwGYhigr66hC0wYeFNp7wDy3WRG3nHpQbt5oD8CqTdnt4UQqeVlsph1MOEfVNH
         /utg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=6frhBg5HfhrV+PE9A95yhtehkieS04QOaLeH3DNydrU=;
        b=EJjw76S+jkWZnxhBQL0fGYHy6s/iUs2ozyN66sF3n/lT1UXSjZuzkjk4w+jP4vV/IR
         yQ48FGiSwK5g/9Jzd0ljzIOKt954XIPiTlk6J0p3OFO0/d9UdvHbsFvmElCnvZmoiXwm
         ePHO2/FLeZDFzDBKouo7tBqdhl8gBayuFzGBZNnHIbFq1r9sHng5g2r6ALo2zsufse9z
         qX+Yf1wFUi7MViHOqi/yTo6IgdVKYumSqjkDfHh/uSWZtjhTnoRgs2BurMA7aTCxoG3I
         EkATzcEsyd0onuPGG0Cz2k9c/xjLwiYEqxKNs7iJG/nYNN0OGcofFqwi/EgM3Dgoecb9
         GUiw==
X-Gm-Message-State: APjAAAXUUKI8+yQM3Fod0CTSzNIms5XHADrABk9xpbc/IWfI2c0po3ir
        IDNttPg7cRXR4VckHNjWc70LapbU
X-Google-Smtp-Source: APXvYqwOfKKf83nSjVaIyk/79CqkFvbYTw7OGW2Af3Mp/7GfXb4+scOasrQ0KrECBdWp+kfGLzcx5A==
X-Received: by 2002:a7b:c94a:: with SMTP id i10mr4396643wml.97.1560445438618;
        Thu, 13 Jun 2019 10:03:58 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a10sm341856wrx.17.2019.06.13.10.03.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 10:03:58 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        vkuznets@redhat.com
Subject: [PATCH 25/43] KVM: nVMX: Update vmcs12 for MSR_IA32_CR_PAT when it's written
Date:   Thu, 13 Jun 2019 19:03:11 +0200
Message-Id: <1560445409-17363-26-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
References: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

As alluded to by the TODO comment, KVM unconditionally intercepts writes
to the PAT MSR.  In the unlikely event that L1 allows L2 to write L1's
PAT directly but saves L2's PAT on VM-Exit, update vmcs12 when L2 writes
the PAT.  This eliminates the need to VMREAD the value from vmcs02 on
VM-Exit as vmcs12 is already up to date in all situations.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 4 ----
 arch/x86/kvm/vmx/vmx.c    | 4 ++++
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index a012118e6c8c..4a91a86b5f0a 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3564,10 +3564,6 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 		vmcs12->guest_ia32_debugctl = vmcs_read64(GUEST_IA32_DEBUGCTL);
 	}
 
-	/* TODO: These cannot have changed unless we have MSR bitmaps and
-	 * the relevant bit asks not to trap the change */
-	if (vmcs12->vm_exit_controls & VM_EXIT_SAVE_IA32_PAT)
-		vmcs12->guest_ia32_pat = vmcs_read64(GUEST_IA32_PAT);
 	if (vmcs12->vm_exit_controls & VM_EXIT_SAVE_IA32_EFER)
 		vmcs12->guest_ia32_efer = vcpu->arch.efer;
 	vmcs12->guest_sysenter_cs = vmcs_read32(GUEST_SYSENTER_CS);
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 7a2d9a4b828c..56783060449d 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1910,6 +1910,10 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (!kvm_pat_valid(data))
 			return 1;
 
+		if (is_guest_mode(vcpu) &&
+		    get_vmcs12(vcpu)->vm_exit_controls & VM_EXIT_SAVE_IA32_PAT)
+			get_vmcs12(vcpu)->guest_ia32_pat = data;
+
 		if (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PAT) {
 			vmcs_write64(GUEST_IA32_PAT, data);
 			vcpu->arch.pat = data;
-- 
1.8.3.1


