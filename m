Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15DB7241172
	for <lists+kvm@lfdr.de>; Mon, 10 Aug 2020 22:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726500AbgHJUL6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 16:11:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726511AbgHJULx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Aug 2020 16:11:53 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C1EC061787
        for <kvm@vger.kernel.org>; Mon, 10 Aug 2020 13:11:53 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id h2so7273725pgc.19
        for <kvm@vger.kernel.org>; Mon, 10 Aug 2020 13:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=lANKPJQmUG0ftqWuRSW+TyNatCjqHLxhR7LE07lIvXY=;
        b=CiUPpx5TpPqcqPtLQO7X78wqB4rbvxu1Wr4VH9aUsfvZKfBXlvCu6siENfHareEIF4
         bB+7CpnccbM5jn/ImvKbSlcLJBoyP3HryW+lEgB2NSPjpjijTArBTT+mBMcwVB5/D6fh
         yLLEc9xG8jPwolcJg1rsYMehNMC1w54DqDDDGFHjlMlHFCJPgHvcoFPwE5oUp83JfngQ
         ClpOzPPMmguHhdHGIeheIlNngnk02plIQTwAcgD5Dqe8JiG1C3oWytX+xQ7EA/hY8u62
         RLZLbFjSK/6dOJQXkChkzmFT0L9i1XUg5xKNYHfjggwtzW8D+8f6fBM4oBo3GjCXKbu2
         AwFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=lANKPJQmUG0ftqWuRSW+TyNatCjqHLxhR7LE07lIvXY=;
        b=EIIK33/r/KQYjgiG1LLA64RGv0cotZxAPlUYWk7dTtSyWsVjcC2TuGm8aZ7BPGEWV8
         PBEXqqiI3w1UMNbrlBdB1NdZK1NdKwF+Qu/1EsgQ8CUcJnO5EzV1Jx9JhMhTsqM5Qphs
         3nFAviMRbRifSjxC9T4Zwzb184Za0sGxRl0Jymj5ITerRYWERjxPU0imXquikzJMgGvp
         Hw90kFILat3FQHxZfOB4PI3z7LEWC7aU/cyj88qQeOGoWTMPfm0uZ9CuaVIVneVMnoAj
         xTFFpFmsMnh40CcnNaTYkUKs7k0lWk1OryLUTqGCpfBiLEffWW3U6sUcGdPO4qCe2mwx
         dLPg==
X-Gm-Message-State: AOAM530YTuEZ9gUCyWm61kCRabovZTJiPnPIyT6/3/9gX+CuqEgPDWbw
        NI2TiDpbA62Y48b+uRmq6KmJ77qa6aL1/kbW
X-Google-Smtp-Source: ABdhPJyqQo8CSenEOesGM8PM9FKa1RMrif+xZZ1nXF7SHrJqH0DM8fWG2NWf1TpfFTvrjXwKcFUvx12apZBWspSs
X-Received: by 2002:a62:1c58:: with SMTP id c85mr2632185pfc.105.1597090311355;
 Mon, 10 Aug 2020 13:11:51 -0700 (PDT)
Date:   Mon, 10 Aug 2020 13:11:29 -0700
In-Reply-To: <20200810201134.2031613-1-aaronlewis@google.com>
Message-Id: <20200810201134.2031613-4-aaronlewis@google.com>
Mime-Version: 1.0
References: <20200810201134.2031613-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.28.0.236.gb10cc79966-goog
Subject: [PATCH v2 3/8] KVM: x86: Allow em_{rdmsr,wrmsr} to bounce to userspace
From:   Aaron Lewis <aaronlewis@google.com>
To:     jmattson@google.com, graf@amazon.com
Cc:     pshier@google.com, oupton@google.com, kvm@vger.kernel.org,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Refactor em_{rdmsr,wrmsr} to allow an MSR to bounce to userspace when it
exists in the list of MSRs userspace has requested to manage with the
ioctl KVM_SET_EXIT_MSRS.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
Based-on-patch-by: Alexander Graf <graf@amazon.com>
---
 arch/x86/kvm/emulate.c | 18 +++++++++--
 arch/x86/kvm/x86.c     | 70 ++++++++++++++++++++++++++++++------------
 2 files changed, 66 insertions(+), 22 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index d0e2825ae617..744ab9c92b73 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3689,11 +3689,18 @@ static int em_dr_write(struct x86_emulate_ctxt *ctxt)
 
 static int em_wrmsr(struct x86_emulate_ctxt *ctxt)
 {
+	u64 msr_index = reg_read(ctxt, VCPU_REGS_RCX);
 	u64 msr_data;
+	int r;
 
 	msr_data = (u32)reg_read(ctxt, VCPU_REGS_RAX)
 		| ((u64)reg_read(ctxt, VCPU_REGS_RDX) << 32);
-	if (ctxt->ops->set_msr(ctxt, reg_read(ctxt, VCPU_REGS_RCX), msr_data))
+	r = ctxt->ops->set_msr(ctxt, msr_index, msr_data);
+
+	if (r == X86EMUL_IO_NEEDED)
+		return r;
+
+	if (r)
 		return emulate_gp(ctxt, 0);
 
 	return X86EMUL_CONTINUE;
@@ -3701,9 +3708,16 @@ static int em_wrmsr(struct x86_emulate_ctxt *ctxt)
 
 static int em_rdmsr(struct x86_emulate_ctxt *ctxt)
 {
+	u64 msr_index = reg_read(ctxt, VCPU_REGS_RCX);
 	u64 msr_data;
+	int r;
+
+	r = ctxt->ops->get_msr(ctxt, msr_index, &msr_data);
+
+	if (r == X86EMUL_IO_NEEDED)
+		return r;
 
-	if (ctxt->ops->get_msr(ctxt, reg_read(ctxt, VCPU_REGS_RCX), &msr_data))
+	if (r)
 		return emulate_gp(ctxt, 0);
 
 	*reg_write(ctxt, VCPU_REGS_RAX) = (u32)msr_data;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 47619b49818a..4dff6147557e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1590,21 +1590,46 @@ static int complete_userspace_wrmsr(struct kvm_vcpu *vcpu)
 	return complete_userspace_msr(vcpu, true);
 }
 
+static int kvm_get_msr_user(struct kvm_vcpu *vcpu, u32 index)
+{
+	if (!kvm_msr_user_exit(vcpu->kvm, index))
+		return 0;
+
+	vcpu->run->exit_reason = KVM_EXIT_X86_RDMSR;
+	vcpu->run->msr.index = index;
+	vcpu->run->msr.data = 0;
+	vcpu->run->msr.inject_gp = 0;
+	memset(vcpu->run->msr.pad, 0, sizeof(vcpu->run->msr.pad));
+	vcpu->arch.complete_userspace_io =
+		complete_userspace_rdmsr;
+
+	return 1;
+}
+
+static int kvm_set_msr_user(struct kvm_vcpu *vcpu, u32 index, u64 data)
+{
+	if (!kvm_msr_user_exit(vcpu->kvm, index))
+		return 0;
+
+	vcpu->run->exit_reason = KVM_EXIT_X86_WRMSR;
+	vcpu->run->msr.index = index;
+	vcpu->run->msr.data = data;
+	vcpu->run->msr.inject_gp = 0;
+	memset(vcpu->run->msr.pad, 0, sizeof(vcpu->run->msr.pad));
+	vcpu->arch.complete_userspace_io =
+		complete_userspace_wrmsr;
+
+	return 1;
+}
+
 int kvm_emulate_rdmsr(struct kvm_vcpu *vcpu)
 {
 	u32 ecx = kvm_rcx_read(vcpu);
 	u64 data;
 
-	if (kvm_msr_user_exit(vcpu->kvm, ecx)) {
-		vcpu->run->exit_reason = KVM_EXIT_X86_RDMSR;
-		vcpu->run->msr.index = ecx;
-		vcpu->run->msr.data = 0;
-		vcpu->run->msr.inject_gp = 0;
-		memset(vcpu->run->msr.pad, 0, sizeof(vcpu->run->msr.pad));
-		vcpu->arch.complete_userspace_io =
-			complete_userspace_rdmsr;
+	if (kvm_get_msr_user(vcpu, ecx))
+		/* Bounce to user space */
 		return 0;
-	}
 
 	if (kvm_get_msr(vcpu, ecx, &data)) {
 		trace_kvm_msr_read_ex(ecx);
@@ -1625,16 +1650,9 @@ int kvm_emulate_wrmsr(struct kvm_vcpu *vcpu)
 	u32 ecx = kvm_rcx_read(vcpu);
 	u64 data = kvm_read_edx_eax(vcpu);
 
-	if (kvm_msr_user_exit(vcpu->kvm, ecx)) {
-		vcpu->run->exit_reason = KVM_EXIT_X86_WRMSR;
-		vcpu->run->msr.index = ecx;
-		vcpu->run->msr.data = data;
-		vcpu->run->msr.inject_gp = 0;
-		memset(vcpu->run->msr.pad, 0, sizeof(vcpu->run->msr.pad));
-		vcpu->arch.complete_userspace_io =
-			complete_userspace_wrmsr;
+	if (kvm_set_msr_user(vcpu, ecx, data))
+		/* Bounce to user space */
 		return 0;
-	}
 
 	if (kvm_set_msr(vcpu, ecx, data)) {
 		trace_kvm_msr_write_ex(ecx, data);
@@ -6442,13 +6460,25 @@ static void emulator_set_segment(struct x86_emulate_ctxt *ctxt, u16 selector,
 static int emulator_get_msr(struct x86_emulate_ctxt *ctxt,
 			    u32 msr_index, u64 *pdata)
 {
-	return kvm_get_msr(emul_to_vcpu(ctxt), msr_index, pdata);
+	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
+
+	if (kvm_get_msr_user(vcpu, msr_index))
+		/* Bounce to user space */
+		return X86EMUL_IO_NEEDED;
+
+	return kvm_get_msr(vcpu, msr_index, pdata);
 }
 
 static int emulator_set_msr(struct x86_emulate_ctxt *ctxt,
 			    u32 msr_index, u64 data)
 {
-	return kvm_set_msr(emul_to_vcpu(ctxt), msr_index, data);
+	struct kvm_vcpu *vcpu = emul_to_vcpu(ctxt);
+
+	if (kvm_set_msr_user(vcpu, msr_index, data))
+		/* Bounce to user space */
+		return X86EMUL_IO_NEEDED;
+
+	return kvm_set_msr(vcpu, msr_index, data);
 }
 
 static u64 emulator_get_smbase(struct x86_emulate_ctxt *ctxt)
-- 
2.28.0.236.gb10cc79966-goog

