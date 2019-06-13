Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8433A44813
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 19:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404568AbfFMRED (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 13:04:03 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36746 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393369AbfFMREC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 13:04:02 -0400
Received: by mail-wr1-f68.google.com with SMTP id n4so21630482wrs.3;
        Thu, 13 Jun 2019 10:04:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=hiwCoGuMO+HGOrtpBphtyFwrRwIt3o789paugY4guB8=;
        b=T7XqC2pWYZ5GJe4DHzOPMuCNnFKB2oPkah3Yq8METimUsD/T2RHVp/UV1aMHxMesQ6
         DVu0HHXJF+2HZU8HbQboGKrCLBoMMSV3AMpniU7YqTOl0OvowdPQ4/aPm7fB4S19Lf2b
         3kSUEVDSehnkVi/D7vt6JcXwbPvqO/2H/WD1vu18UsOO83AQvyW8a2gdIw+MXCfYoWVm
         Z55Q2urBRbs7U+z6v00PRvOcUDk98EwWgZtvfx6pZ9R13KstZyoWc5qts30MHX5tR9nt
         WI64JqV8e7zcVrBl14QXx4FDCc9nKTYLolwE6AyWL7/Mo2igdHlsBhi2uYIOTXHajEjg
         kV3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=hiwCoGuMO+HGOrtpBphtyFwrRwIt3o789paugY4guB8=;
        b=rJZd0lHAfB+Gl0JK5g/dfjpFXb5hrBP2LH8ShOzB6BvNa4UrmZQSMTQpkIKS+IMlNp
         6cEEUzBGfCr1cuPigS8u8aZ9URCZFpatLoFQvutCHm9ADfEhkmY0L2s3+VhYNLR5Ghs/
         bePlgIBHlpIsfzOb1FChlZpz+CKdSkC0ZPV7DELAvZoFxlJAl1PKP2dh0PeOlyDBDFcu
         9Xo99wTM8utenF/PsVSux4G2GizRbXQsKIAB/JUB9RQIWxQzJoQ6auBXULOLLMNctuc0
         HqzgmaH3aalOlmXhFrVatf3nR39nf3ErVl+CJ04s/LNDPXvVnq703rG7vJFmBcVCJD4H
         wrNQ==
X-Gm-Message-State: APjAAAUJHklH3sViz76w0Y6ULvNO90TWIY28/z/ctIauONlObh4sAIbb
        yGwAXvsEz8Tza9UXn+DSXAw+dAPD
X-Google-Smtp-Source: APXvYqyiACdlF0pBcbULwHQ1Mb/L0rnANUHAVYyjaYZqMvRitnCBWDdnFB/V7gQtjypjSoUAhLaiZA==
X-Received: by 2002:a5d:4d06:: with SMTP id z6mr35027858wrt.343.1560445439539;
        Thu, 13 Jun 2019 10:03:59 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a10sm341856wrx.17.2019.06.13.10.03.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 10:03:58 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        vkuznets@redhat.com
Subject: [PATCH 26/43] KVM: nVMX: Update vmcs12 for SYSENTER MSRs when they're written
Date:   Thu, 13 Jun 2019 19:03:12 +0200
Message-Id: <1560445409-17363-27-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
References: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

For L2, KVM always intercepts WRMSR to SYSENTER MSRs.  Update vmcs12 in
the WRMSR handler so that they don't need to be (re)read from vmcs02 on
every nested VM-Exit.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 7 ++++---
 arch/x86/kvm/vmx/vmx.c    | 6 ++++++
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 4a91a86b5f0a..68c031e2cc4d 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3521,6 +3521,10 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 	vmcs12->guest_cs_ar_bytes = vmcs_read32(GUEST_CS_AR_BYTES);
 	vmcs12->guest_ss_ar_bytes = vmcs_read32(GUEST_SS_AR_BYTES);
 
+	vmcs12->guest_sysenter_cs = vmcs_read32(GUEST_SYSENTER_CS);
+	vmcs12->guest_sysenter_esp = vmcs_readl(GUEST_SYSENTER_ESP);
+	vmcs12->guest_sysenter_eip = vmcs_readl(GUEST_SYSENTER_EIP);
+
 	vmcs12->guest_interruptibility_info =
 		vmcs_read32(GUEST_INTERRUPTIBILITY_INFO);
 
@@ -3566,9 +3570,6 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 
 	if (vmcs12->vm_exit_controls & VM_EXIT_SAVE_IA32_EFER)
 		vmcs12->guest_ia32_efer = vcpu->arch.efer;
-	vmcs12->guest_sysenter_cs = vmcs_read32(GUEST_SYSENTER_CS);
-	vmcs12->guest_sysenter_esp = vmcs_readl(GUEST_SYSENTER_ESP);
-	vmcs12->guest_sysenter_eip = vmcs_readl(GUEST_SYSENTER_EIP);
 }
 
 /*
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 56783060449d..ede2ac670f5b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1831,12 +1831,18 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 #endif
 	case MSR_IA32_SYSENTER_CS:
+		if (is_guest_mode(vcpu))
+			get_vmcs12(vcpu)->guest_sysenter_cs = data;
 		vmcs_write32(GUEST_SYSENTER_CS, data);
 		break;
 	case MSR_IA32_SYSENTER_EIP:
+		if (is_guest_mode(vcpu))
+			get_vmcs12(vcpu)->guest_sysenter_eip = data;
 		vmcs_writel(GUEST_SYSENTER_EIP, data);
 		break;
 	case MSR_IA32_SYSENTER_ESP:
+		if (is_guest_mode(vcpu))
+			get_vmcs12(vcpu)->guest_sysenter_esp = data;
 		vmcs_writel(GUEST_SYSENTER_ESP, data);
 		break;
 	case MSR_IA32_BNDCFGS:
-- 
1.8.3.1


