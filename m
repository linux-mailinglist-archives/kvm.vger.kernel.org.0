Return-Path: <kvm+bounces-9911-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D230D86791F
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:54:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 72C591F28A25
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:54:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8372E1420A6;
	Mon, 26 Feb 2024 14:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FVCO6XNH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A86141988;
	Mon, 26 Feb 2024 14:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958235; cv=none; b=C28g9083lhhBAqOx7Q0XTfw4Ph7aUSNdVJQ/PeLAUw2nf5K+A5zFQXWls1NBZKVZWc5CftTrNarsD9vJn4hSFvLXSIOzrHgErEeyc2YckWNdHadbRjd732hRrXp+2xWu1mpU2/g3snZ4j+TtLthP93tT2OXwIs4uJoL/skPCMYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958235; c=relaxed/simple;
	bh=yFTowSeo6zJ347eo3a63wiouXx/voA/dHD8YL405VJQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=L1CxWFP+xkIYr3PzU/+xgnKL5zZKJRia11A6Nz95vTgodxVfEUE9ZzfUOwJY0y/cZsSYKAOldAxiLtcM9+x0DzzYnrJysfiIY+4YRpaJybUMJU6LpGZCVHVWo7y0xaCcE0OlhTV5q0kVMhjvtgtfoJw0tFhojB3HUvN3ILkpAk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FVCO6XNH; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1dc3b4b9b62so26747325ad.1;
        Mon, 26 Feb 2024 06:37:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958233; x=1709563033; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7XTvgh4XHyCc0kVcHAEtjm6YqaHRshQPoue6SNYuJFs=;
        b=FVCO6XNHiXC7WQhTsUMklTYmkEvI2mHcjrx2e7rCyWEY8x0LQA01DCFFGz+rpCuoI+
         amAaTMjZsJg1UGJV24mug2JP6DuLJglpsmVABqwWkNClXyeIk2oN3XMjgWIB/PYuMmfx
         T6X3VkjSHeeOaAVWHGUN8Az7MSaRlc8mdaBKXKzfW8bJd6W/rgfJ8SkbUr7htx2QGlYZ
         Sbuus0+r23xCcPp2zu8rSuUNO1JSY2FH1BGhf+j3iNZuSrTPkO+FBCfnc2HsNhfx+GMK
         hh4dprnolUxKfct7FxDIDP/+zGFb7QSM6ZM2JlRm8FHC4a2XkPxmC8wPUYGilImHpLNB
         3I7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958233; x=1709563033;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7XTvgh4XHyCc0kVcHAEtjm6YqaHRshQPoue6SNYuJFs=;
        b=IOXAo4+JcPeFi4y5QoXQbJ3LrJ+cO0SNjcsP5Gl5IE6vfJ3NQp6DbUyhBcj13zPKOq
         bpWyNMpF0/doTs+ZWwuR+N80Khg+jEMWT7a0548+WSe8JL17A439LzI/6QkdEjm2bFX9
         oBKJ2FuywE/zM4f7KkzaYWbHXcn8tXWPz3i4fIMC1YtbAUob3Uh6XFRdaTwcMCfMGvUf
         acoSgEMwfB6cNjtgeFRrDjU5a/zNHb5dylgE5rzNB4vCoTYZQ5bbnNUpFA/YAIE+z5z0
         TVVcOjzWBSovWYRRSspmLB5kBqBXCnhS4mw9BJGgeVNiBcalF56NshitJmBlxFsw3vF9
         QQoA==
X-Forwarded-Encrypted: i=1; AJvYcCWYxXffqtpiJF4ak3LHylkoBWoXqnwveuPPklX8bbKZt08JpAJIny9tHwh5Uuu06BRkYNRDYJxBl0c1AmqI0Ocps0h/
X-Gm-Message-State: AOJu0YzA74egCDYz6Jdgw0kr0S40LWIEta5XC2yKQZs3rFY46sLYlnsC
	wNkrgQaa8BllMRd1tiQu8pYs8pYnFsr6Q75tXUdqGsvj9HdqN0I7j6Sa4B3n
X-Google-Smtp-Source: AGHT+IF5XSfJSZznMuAc9toziLAfWWGD+vFYIlYFoJV2gE5OD7aU82GBsy1OepFYT3Tcf3W2YRYEvw==
X-Received: by 2002:a17:903:4303:b0:1db:9ff1:b59b with SMTP id jz3-20020a170903430300b001db9ff1b59bmr6876540plb.23.1708958233553;
        Mon, 26 Feb 2024 06:37:13 -0800 (PST)
Received: from localhost ([47.254.32.37])
        by smtp.gmail.com with ESMTPSA id p6-20020a1709026b8600b001db7e3411f7sm3963697plk.134.2024.02.26.06.37.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:37:13 -0800 (PST)
From: Lai Jiangshan <jiangshanlai@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <jiangshan.ljs@antgroup.com>,
	Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	x86@kernel.org,
	Kees Cook <keescook@chromium.org>,
	Juergen Gross <jgross@suse.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [RFC PATCH 48/73] KVM: x86/PVM: Implement system registers setting callbacks
Date: Mon, 26 Feb 2024 22:36:05 +0800
Message-Id: <20240226143630.33643-49-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20240226143630.33643-1-jiangshanlai@gmail.com>
References: <20240226143630.33643-1-jiangshanlai@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lai Jiangshan <jiangshan.ljs@antgroup.com>

In PVM, the hardware CR0, CR3, and EFER are fixed, and the value of the
guest must match the fixed value; otherwise, the guest is not allowed to
run on the CPU.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/pvm/pvm.c | 51 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/arch/x86/kvm/pvm/pvm.c b/arch/x86/kvm/pvm/pvm.c
index a32d2728eb02..b261309fc946 100644
--- a/arch/x86/kvm/pvm/pvm.c
+++ b/arch/x86/kvm/pvm/pvm.c
@@ -1088,6 +1088,51 @@ static int pvm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	return ret;
 }
 
+static void pvm_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
+{
+	/* Nothing to do */
+}
+
+static int pvm_set_efer(struct kvm_vcpu *vcpu, u64 efer)
+{
+	vcpu->arch.efer = efer;
+
+	return 0;
+}
+
+static bool pvm_is_valid_cr0(struct kvm_vcpu *vcpu, unsigned long cr4)
+{
+	return true;
+}
+
+static void pvm_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
+{
+	if (vcpu->arch.efer & EFER_LME) {
+		if (!is_paging(vcpu) && (cr0 & X86_CR0_PG))
+			vcpu->arch.efer |= EFER_LMA;
+
+		if (is_paging(vcpu) && !(cr0 & X86_CR0_PG))
+			vcpu->arch.efer &= ~EFER_LMA;
+	}
+
+	vcpu->arch.cr0 = cr0;
+}
+
+static bool pvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
+{
+	return true;
+}
+
+static void pvm_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
+{
+	unsigned long old_cr4 = vcpu->arch.cr4;
+
+	vcpu->arch.cr4 = cr4;
+
+	if ((cr4 ^ old_cr4) & (X86_CR4_OSXSAVE | X86_CR4_PKE))
+		kvm_update_cpuid_runtime(vcpu);
+}
+
 static void pvm_get_segment(struct kvm_vcpu *vcpu,
 			    struct kvm_segment *var, int seg)
 {
@@ -2912,13 +2957,19 @@ static struct kvm_x86_ops pvm_x86_ops __initdata = {
 	.set_segment = pvm_set_segment,
 	.get_cpl = pvm_get_cpl,
 	.get_cs_db_l_bits = pvm_get_cs_db_l_bits,
+	.is_valid_cr0 = pvm_is_valid_cr0,
+	.set_cr0 = pvm_set_cr0,
 	.load_mmu_pgd = pvm_load_mmu_pgd,
+	.is_valid_cr4 = pvm_is_valid_cr4,
+	.set_cr4 = pvm_set_cr4,
+	.set_efer = pvm_set_efer,
 	.get_gdt = pvm_get_gdt,
 	.set_gdt = pvm_set_gdt,
 	.get_idt = pvm_get_idt,
 	.set_idt = pvm_set_idt,
 	.set_dr7 = pvm_set_dr7,
 	.sync_dirty_debug_regs = pvm_sync_dirty_debug_regs,
+	.cache_reg = pvm_cache_reg,
 	.get_rflags = pvm_get_rflags,
 	.set_rflags = pvm_set_rflags,
 	.get_if_flag = pvm_get_if_flag,
-- 
2.19.1.6.gb485710b


