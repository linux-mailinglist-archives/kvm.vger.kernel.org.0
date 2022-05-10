Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57039520E90
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 09:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232013AbiEJHhu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 03:37:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239476AbiEJHOH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 03:14:07 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D7552AC6FB;
        Tue, 10 May 2022 00:10:10 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id q76so13901752pgq.10;
        Tue, 10 May 2022 00:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nvBw6OQsd3gRusg0t9ALo2OMlbylQpVciIeUsEY5H/4=;
        b=T+qFWTxO629LWZdJnJq3bp3CM+liSSrAY3WpNo7uZbfNlwaOh63g7Z/odA38bzDoFM
         /mAt6v//a/cX1ea2lWReLCxd5d/34TeqOh9HqUa/YqEhdj1Booh/dap+NfTO9w40rqeO
         mTRnITr8cjT/8u36hwtU4CT31maq1xLM/35YvFUPCLXp/BUaovTPITiaMl23+CFQPRrb
         j/vJlhg4RakjtzcdAtBxJNvIW6KzG4oV/qCnVUJMfoZU3IO39O1xK2mJ5KRuxD5ZwW5c
         X7bjIEeup9pJjVH682ylswV6vilws/ZGLMYfAXFhfmLll1/lZUdW/SWZDcOyjxe474aJ
         zrPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nvBw6OQsd3gRusg0t9ALo2OMlbylQpVciIeUsEY5H/4=;
        b=WDxYrzAsWbF46rXekEKxaRdAXEF1YDxbftaW6kPdUhZ56qPwB26Tg+AXRc+FTiUjwy
         rVvwGcFoY4x/p3j00f3ikpTTmOm6jdYyF+iDbrnb0+Ta8FSY6YxC6lYlWEzi0p0Roq2p
         Cu/iK2fauI0BWmDFpJs3jUz2zJRgxtjc9HNU9OAV3IlRwfNRCFvIaZmioNquIHfuV8G1
         0yfOuWOkEywBwpetjfDXmczF3gWEP5MvB/hukULVbir5aJtnZovSgfYdd0WTjHwDkapL
         bmRpr+O6j3SaRBfne4ecjgIeWgruYxMjLQSc09Op4NYPLBu76C+YAfGEceefYD7ADli2
         wigA==
X-Gm-Message-State: AOAM532TZMcm5e9961QaBLoefthVdYfgDa6OIsmy+50YQeCEz2auLYyf
        Is5sng+BqSfD6/eVvfTl3ln118ZY5R0Tv3zvZUs=
X-Google-Smtp-Source: ABdhPJy3De2SOHraFvRmY+AxMAyt6ksdN+tsXD6BFVR4apRpDurzUoFx16dt1LXeTwflcMvHCKvNeA==
X-Received: by 2002:a63:cc4f:0:b0:3c5:fc22:f6a with SMTP id q15-20020a63cc4f000000b003c5fc220f6amr15904329pgi.67.1652166610010;
        Tue, 10 May 2022 00:10:10 -0700 (PDT)
Received: from localhost.localdomain ([125.131.156.123])
        by smtp.gmail.com with ESMTPSA id g24-20020a170902d5d800b0015e8d4eb2e2sm1105666plh.300.2022.05.10.00.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 00:10:09 -0700 (PDT)
From:   Wonhyuk Yang <vvghjk1234@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Cc:     Wonhyuk Yang <vvghjk1234@gmail.com>,
        Baik Song An <bsahn@etri.re.kr>,
        Hong Yeon Kim <kimhy@etri.re.kr>,
        Taeung Song <taeung@reallinux.co.kr>, linuxgeek@linuxgeek.io,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: Add extra information in kvm_page_fault trace point
Date:   Tue, 10 May 2022 16:10:00 +0900
Message-Id: <20220510071001.87169-1-vvghjk1234@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, kvm_page_fault trace point provide fault_address and error
code. However it is not enough to find which cpu and instruction
cause kvm_page_faults. So add vcpu id and instruction pointer in
kvm_page_fault trace point.

Cc: Baik Song An <bsahn@etri.re.kr>
Cc: Hong Yeon Kim <kimhy@etri.re.kr>
Cc: Taeung Song <taeung@reallinux.co.kr>
Cc: linuxgeek@linuxgeek.io
Signed-off-by: Wonhyuk Yang <vvghjk1234@gmail.com>
---
 arch/x86/kvm/mmu/mmu.c |  2 +-
 arch/x86/kvm/svm/svm.c |  2 +-
 arch/x86/kvm/trace.h   | 12 +++++++++---
 arch/x86/kvm/vmx/vmx.c |  2 +-
 4 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 311e4e1d7870..b9421060efa8 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4080,7 +4080,7 @@ int kvm_handle_page_fault(struct kvm_vcpu *vcpu, u64 error_code,
 
 	vcpu->arch.l1tf_flush_l1d = true;
 	if (!flags) {
-		trace_kvm_page_fault(fault_address, error_code);
+		trace_kvm_page_fault(vcpu, fault_address, error_code);
 
 		if (kvm_event_needs_reinjection(vcpu))
 			kvm_mmu_unprotect_page_virt(vcpu, fault_address);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 7e45d03cd018..9741cfbf47a4 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1784,7 +1784,7 @@ static int npf_interception(struct kvm_vcpu *vcpu)
 	u64 fault_address = svm->vmcb->control.exit_info_2;
 	u64 error_code = svm->vmcb->control.exit_info_1;
 
-	trace_kvm_page_fault(fault_address, error_code);
+	trace_kvm_page_fault(vcpu, fault_address, error_code);
 	return kvm_mmu_page_fault(vcpu, fault_address, error_code,
 			static_cpu_has(X86_FEATURE_DECODEASSISTS) ?
 			svm->vmcb->control.insn_bytes : NULL,
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index e3a24b8f04be..78d20d392904 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -383,20 +383,26 @@ TRACE_EVENT(kvm_inj_exception,
  * Tracepoint for page fault.
  */
 TRACE_EVENT(kvm_page_fault,
-	TP_PROTO(unsigned long fault_address, unsigned int error_code),
-	TP_ARGS(fault_address, error_code),
+	TP_PROTO(struct kvm_vcpu *vcpu, unsigned long fault_address,
+		 unsigned int error_code),
+	TP_ARGS(vcpu, fault_address, error_code),
 
 	TP_STRUCT__entry(
+		__field(	unsigned int,	vcpu_id		)
+		__field(	unsigned long,	guest_rip	)
 		__field(	unsigned long,	fault_address	)
 		__field(	unsigned int,	error_code	)
 	),
 
 	TP_fast_assign(
+		__entry->vcpu_id	= vcpu->vcpu_id;
+		__entry->guest_rip	= kvm_rip_read(vcpu);
 		__entry->fault_address	= fault_address;
 		__entry->error_code	= error_code;
 	),
 
-	TP_printk("address %lx error_code %x",
+	TP_printk("vcpu %u rip 0x%lx address 0x%lx error_code %x",
+		  __entry->vcpu_id, __entry->guest_rip,
 		  __entry->fault_address, __entry->error_code)
 );
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 610355b9ccce..0f1edd02b68b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5398,7 +5398,7 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
 		vmcs_set_bits(GUEST_INTERRUPTIBILITY_INFO, GUEST_INTR_STATE_NMI);
 
 	gpa = vmcs_read64(GUEST_PHYSICAL_ADDRESS);
-	trace_kvm_page_fault(gpa, exit_qualification);
+	trace_kvm_page_fault(vcpu, gpa, exit_qualification);
 
 	/* Is it a read fault? */
 	error_code = (exit_qualification & EPT_VIOLATION_ACC_READ)
-- 
2.30.2

