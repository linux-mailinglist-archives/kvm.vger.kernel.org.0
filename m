Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE64BE28E
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 18:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389108AbfIYQev (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 12:34:51 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33219 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbfIYQeu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 12:34:50 -0400
Received: by mail-wr1-f66.google.com with SMTP id b9so7725985wrs.0;
        Wed, 25 Sep 2019 09:34:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=s+6/bt73F0nPkh+ms30j0ei78DCt1MwVFFVQl9AGl+A=;
        b=smygSNg9FtLOVqPacXXLuBqzZgNquwgf502lQnDrZZV5nuuo1H5s/ex7lbhjMHm7or
         W5f9sP6CfAj+zLQVBgnlN1BNRQ/Yiu10T/wrAw9PtG28Eo1CRYdl+oeO4TROcZzQS2WE
         gwrlNPb6xbDF/I7/AqayB1DVxtgWwm6oW+212q5UpYOTFsHGtpRbSfxhya14GvH7272F
         xF2+lsaLwAtHatm8iRhPM6GjMO0HOy/Lav8cY4AoZlp9nsHLgUnJQE6d3hAwA4UFEoXP
         kHb+O9tMEzdTX6lw0EXzCGtD23AqF+/TwTcoyhi/gSKJqU3FW7uNrqAnrBsso92RRSjy
         L0DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=s+6/bt73F0nPkh+ms30j0ei78DCt1MwVFFVQl9AGl+A=;
        b=uZmx7b4QFSz0DPhpOGXmau4ueunQ4fmBukYnyHH5Wx0aemMq7K8b147ZLNuGZCGuu1
         PsE7xfmOBrZwtQ7zV2agv6PS39wJ/POvEP2Ouafi3tDFedFe404OY4M4MyXSeQ7mjJkk
         YzflGrgcJzNqYSQjQLKJQnpaRDufAqkCHe7nwQzxcBP3a++T/XBUSmxi4BU3ZdWTZuy7
         8rujjY9fEBkOuRxOdpmOiG5nw4WFUkA8uJ/Sy5M9NehHUyhXRspIgKoPsMN21ko+kJaM
         oAbWMQrKhMJs5wzViUhTA1MNKCA0tLexJg45x26wMBVss/iynnOecTfUFwcR5xqAOv3U
         gA4g==
X-Gm-Message-State: APjAAAVIQ6Ek0N7+KapieCSoO+7xpyCkIQGYKG6jTlr4sdhng1+qFSEN
        mNO4yyNrQvRW7VeOr413qewreHdI
X-Google-Smtp-Source: APXvYqzG9uZ++lfYDbCS8zeD0orJK6Hij8TVimAq9rhTUfa9PhmpSpHL6h6GyA04sZa+N/qoS5hQMw==
X-Received: by 2002:a5d:4f86:: with SMTP id d6mr10247057wru.384.1569429288225;
        Wed, 25 Sep 2019 09:34:48 -0700 (PDT)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id b16sm9170000wrh.5.2019.09.25.09.34.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Sep 2019 09:34:47 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Subject: [PATCH] KVM: nVMX: cleanup and fix host 64-bit mode checks
Date:   Wed, 25 Sep 2019 18:34:46 +0200
Message-Id: <1569429286-35157-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM was incorrectly checking vmcs12->host_ia32_efer even if the "load
IA32_EFER" exit control was reset.  Also, some checks were not using
the new CC macro for tracing.

Cleanup everything so that the vCPU's 64-bit mode is determined
directly from EFER_LMA and the VMCS checks are based on that, which
matches section 26.2.4 of the SDM.

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Jim Mattson <jmattson@google.com>
Cc: Krish Sadhukhan <krish.sadhukhan@oracle.com>
Fixes: 5845038c111db27902bc220a4f70070fe945871c
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 53 ++++++++++++++++++++---------------------------
 1 file changed, 22 insertions(+), 31 deletions(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 70d59d9304f2..e108847f6cf8 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2664,8 +2664,26 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
 	    CC(!kvm_pat_valid(vmcs12->host_ia32_pat)))
 		return -EINVAL;
 
-	ia32e = (vmcs12->vm_exit_controls &
-		 VM_EXIT_HOST_ADDR_SPACE_SIZE) != 0;
+#ifdef CONFIG_X86_64
+	ia32e = !!(vcpu->arch.efer & EFER_LMA);
+#else
+	if (CC(vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE))
+		return -EINVAL;
+
+	ia32e = false;
+#endif
+
+	if (ia32e) {
+		if (CC(!(vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE)) ||
+		    CC(!(vmcs12->host_cr4 & X86_CR4_PAE)))
+			return -EINVAL;
+	} else {
+		if (CC(vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE) ||
+		    CC(vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE) ||
+		    CC(vmcs12->host_cr4 & X86_CR4_PCIDE) ||
+		    CC(((vmcs12->host_rip) >> 32) & 0xffffffff))
+			return -EINVAL;
+	}
 
 	if (CC(vmcs12->host_cs_selector & (SEGMENT_RPL_MASK | SEGMENT_TI_MASK)) ||
 	    CC(vmcs12->host_ss_selector & (SEGMENT_RPL_MASK | SEGMENT_TI_MASK)) ||
@@ -2684,35 +2702,8 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
 	    CC(is_noncanonical_address(vmcs12->host_gs_base, vcpu)) ||
 	    CC(is_noncanonical_address(vmcs12->host_gdtr_base, vcpu)) ||
 	    CC(is_noncanonical_address(vmcs12->host_idtr_base, vcpu)) ||
-	    CC(is_noncanonical_address(vmcs12->host_tr_base, vcpu)))
-		return -EINVAL;
-
-	if (!(vmcs12->host_ia32_efer & EFER_LMA) &&
-	    ((vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE) ||
-	    (vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE))) {
-		return -EINVAL;
-	}
-
-	if ((vmcs12->host_ia32_efer & EFER_LMA) &&
-	    !(vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE)) {
-		return -EINVAL;
-	}
-
-	if (!(vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE) &&
-	    ((vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE) ||
-	    (vmcs12->host_cr4 & X86_CR4_PCIDE) ||
-	    (((vmcs12->host_rip) >> 32) & 0xffffffff))) {
-		return -EINVAL;
-	}
-
-	if ((vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE) &&
-	    ((!(vmcs12->host_cr4 & X86_CR4_PAE)) ||
-	    (is_noncanonical_address(vmcs12->host_rip, vcpu)))) {
-		return -EINVAL;
-	}
-#else
-	if (vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE ||
-	    vmcs12->vm_exit_controls & VM_EXIT_HOST_ADDR_SPACE_SIZE)
+	    CC(is_noncanonical_address(vmcs12->host_tr_base, vcpu)) ||
+	    CC(is_noncanonical_address(vmcs12->host_rip, vcpu)))
 		return -EINVAL;
 #endif
 
-- 
1.8.3.1

