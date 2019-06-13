Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4EBA448A1
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 19:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393574AbfFMRJ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 13:09:59 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36691 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393266AbfFMRDg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 13:03:36 -0400
Received: by mail-wr1-f66.google.com with SMTP id n4so21629094wrs.3;
        Thu, 13 Jun 2019 10:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LNkyAGPk1iKZCEgQnBFbCeLjAmjPtNmmbmMQ3KLc/JY=;
        b=jH9THcz7JwqDftxHoT6yKTB3EfG2eMSMoQRA2zyxLVjXPtWqSn/aiq/+Fc0a9hUomU
         J+nIhekKfl0hGlWQ8KAcEqRePevH76QmFPp7y+LHN3LvREtM+TOYFZ4TtGU+D7xkT63F
         GqkKHs6dPhwfrxws3wPkWu6ga8eIVICmsijlAjzfDqrciF3KEOMA9FuOpWLZej22FxTR
         p9Dp9hzHk7erhotlnjt631nS82RVyUW/GrD0hJFOoI6OUDhFxKEwI17pyX6j0KGCUL3h
         Cw1GOa4YHrbLppJdt9/LH99YGgL1WjfV5Tt/pK8mo4YOpyDk2CaGUYeh/Aarjd87d+gk
         MhwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references;
        bh=LNkyAGPk1iKZCEgQnBFbCeLjAmjPtNmmbmMQ3KLc/JY=;
        b=Sfn/vuuDcy6cRsz8Lyxk1g08JWwybeJFrAt6bhuTAMxCab58S3YVH7JKGMVPAttSPC
         F99iNWmqEuv4hk/xaW4rwioheehdxu9BosiyV/pJKKmor8NPbHDOjqoPDkLRPeBWLgTn
         drIq3tgaKROh3Y3VM+DIlPzPvQxkL965BQCb1xO6PRjrFsJkuG+8M9Qb47mYr5Pt5/iy
         2LMG5wMdOEIm9OWjgSMQ7h6R7Mf7D/LfiJ4n9Ah5Cz4DDYVPn26tKkUciZFsBDHuIaVS
         DbxxIQZWc0/7T/fBfLsbaCuZAh8rJ1vbKhl0aiNPBYPENxY84Qdew+iybkFxPhbTaQuN
         mzsw==
X-Gm-Message-State: APjAAAWFy4mVkWvSkkacDF1CZB1TyzfIzbPjO4AGMb6TbmpcE0ZPaCC0
        lZwHyhZVsDa3pN1YbRrsYNstd2oT
X-Google-Smtp-Source: APXvYqzrmOSIeIRT3Hbew41lagbGcge6uoHXX4UaJu1fzQDFPwkiaFbYCAdm1MlLzN2ABLWaC/bvAg==
X-Received: by 2002:a05:6000:4b:: with SMTP id k11mr9221466wrx.82.1560445413938;
        Thu, 13 Jun 2019 10:03:33 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id a10sm341856wrx.17.2019.06.13.10.03.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 10:03:33 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        vkuznets@redhat.com
Subject: [PATCH 03/43] KVM: VMX: Read cached VM-Exit reason to detect external interrupt
Date:   Thu, 13 Jun 2019 19:02:49 +0200
Message-Id: <1560445409-17363-4-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
References: <1560445409-17363-1-git-send-email-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Generic x86 code invokes the kvm_x86_ops external interrupt handler on
all VM-Exits regardless of the actual exit type.  Use the already-cached
EXIT_REASON to determine if the VM-Exit was due to an interrupt, thus
avoiding an extra VMREAD (to query VM_EXIT_INTR_INFO) for all other
types of VM-Exit.

In addition to avoiding the extra VMREAD, checking the EXIT_REASON
instead of VM_EXIT_INTR_INFO makes it more obvious that
vmx_handle_external_intr() is called for all VM-Exits, e.g. someone
unfamiliar with the flow might wonder under what condition(s)
VM_EXIT_INTR_INFO does not contain a valid interrupt, which is
simply not possible since KVM always runs with "ack interrupt on exit".

WARN once if VM_EXIT_INTR_INFO doesn't contain a valid interrupt on
an EXTERNAL_INTERRUPT VM-Exit, as such a condition would indicate a
hardware bug.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/vmcs.h |  6 +++++
 arch/x86/kvm/vmx/vmx.c  | 62 ++++++++++++++++++++++++++-----------------------
 2 files changed, 39 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
index cb6079f8a227..971a46c69df4 100644
--- a/arch/x86/kvm/vmx/vmcs.h
+++ b/arch/x86/kvm/vmx/vmcs.h
@@ -115,6 +115,12 @@ static inline bool is_nmi(u32 intr_info)
 		== (INTR_TYPE_NMI_INTR | INTR_INFO_VALID_MASK);
 }
 
+static inline bool is_external_intr(u32 intr_info)
+{
+	return (intr_info & (INTR_INFO_VALID_MASK | INTR_INFO_INTR_TYPE_MASK))
+		== (INTR_INFO_VALID_MASK | INTR_TYPE_EXT_INTR);
+}
+
 enum vmcs_field_width {
 	VMCS_FIELD_WIDTH_U16 = 0,
 	VMCS_FIELD_WIDTH_U64 = 1,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index da6c829bad9f..b541fe2c6347 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6127,42 +6127,46 @@ static void vmx_complete_atomic_exit(struct vcpu_vmx *vmx)
 
 static void vmx_handle_external_intr(struct kvm_vcpu *vcpu)
 {
-	u32 exit_intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
-
-	if ((exit_intr_info & (INTR_INFO_VALID_MASK | INTR_INFO_INTR_TYPE_MASK))
-			== (INTR_INFO_VALID_MASK | INTR_TYPE_EXT_INTR)) {
-		unsigned int vector;
-		unsigned long entry;
-		gate_desc *desc;
-		struct vcpu_vmx *vmx = to_vmx(vcpu);
+	unsigned int vector;
+	unsigned long entry;
 #ifdef CONFIG_X86_64
-		unsigned long tmp;
+	unsigned long tmp;
 #endif
+	gate_desc *desc;
+	u32 intr_info;
 
-		vector =  exit_intr_info & INTR_INFO_VECTOR_MASK;
-		desc = (gate_desc *)vmx->host_idt_base + vector;
-		entry = gate_offset(desc);
-		asm volatile(
+	if (to_vmx(vcpu)->exit_reason != EXIT_REASON_EXTERNAL_INTERRUPT)
+		return;
+
+	intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
+	if (WARN_ONCE(!is_external_intr(intr_info),
+	    "KVM: unexpected VM-Exit interrupt info: 0x%x", intr_info))
+		return;
+
+	vector = intr_info & INTR_INFO_VECTOR_MASK;
+	desc = (gate_desc *)vmx->host_idt_base + vector;
+	entry = gate_offset(desc);
+
+	asm volatile(
 #ifdef CONFIG_X86_64
-			"mov %%" _ASM_SP ", %[sp]\n\t"
-			"and $0xfffffffffffffff0, %%" _ASM_SP "\n\t"
-			"push $%c[ss]\n\t"
-			"push %[sp]\n\t"
+		"mov %%" _ASM_SP ", %[sp]\n\t"
+		"and $0xfffffffffffffff0, %%" _ASM_SP "\n\t"
+		"push $%c[ss]\n\t"
+		"push %[sp]\n\t"
 #endif
-			"pushf\n\t"
-			__ASM_SIZE(push) " $%c[cs]\n\t"
-			CALL_NOSPEC
-			:
+		"pushf\n\t"
+		__ASM_SIZE(push) " $%c[cs]\n\t"
+		CALL_NOSPEC
+		:
 #ifdef CONFIG_X86_64
-			[sp]"=&r"(tmp),
+		[sp]"=&r"(tmp),
 #endif
-			ASM_CALL_CONSTRAINT
-			:
-			THUNK_TARGET(entry),
-			[ss]"i"(__KERNEL_DS),
-			[cs]"i"(__KERNEL_CS)
-			);
-	}
+		ASM_CALL_CONSTRAINT
+		:
+		THUNK_TARGET(entry),
+		[ss]"i"(__KERNEL_DS),
+		[cs]"i"(__KERNEL_CS)
+	);
 }
 STACK_FRAME_NON_STANDARD(vmx_handle_external_intr);
 
-- 
1.8.3.1


