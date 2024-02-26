Return-Path: <kvm+bounces-9893-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C3938678F3
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:48:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C4067298D3B
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:48:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CED7135A4E;
	Mon, 26 Feb 2024 14:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FHwQt2Gv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B32113664A;
	Mon, 26 Feb 2024 14:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958178; cv=none; b=cLEp03nAn0kXbJ5HgGIyu46zOmVfiljzg9a4QoqNRRwb3pXcG707rsIsQvOdE+2x3OtrmW8iA18S/tEB2GroXzisnGh99hBnW8drvN3GBxOaqNv/BlnFh3G5fyxLJwzO+QbjTNmRMW3VBLjDA78/iFK6FSoRuhUIqBW4UDz1IR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958178; c=relaxed/simple;
	bh=8gFP5rvdzZxmykD3GgHFtUmnYj+RZy2c2VA4Es1YSSs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cT0TDclyEUJaN2VFlVaxH1zLZHmShxOoAuEI/98RUBOMpyQAzucjzV0E4q/tcA0uYWXfHdCQvq4CoAQS1QBSEysWmofAySgs36mhqGOAZic2Rze2spE+PkghE/yebhDz1dTtX37YFItD0di7HQQ9QTYJ7uoAlgQjxJ9CmPb4uNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FHwQt2Gv; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3657dbe2008so10162675ab.1;
        Mon, 26 Feb 2024 06:36:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958176; x=1709562976; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0en7LuGGPdtEWR7o0ZKkW7B0C/vkNLQUW7iYqtMdnKQ=;
        b=FHwQt2GvLmnD7J+9eoMsAbHRGZkOiBEAZis4BhscMz/pGSjYyHVNfqKjrXHgdZ0t1P
         Cb06XDtr1W2LunueSHxwSNb7SAgF5vPj20rqpYmOtY8bFdS82wxxf2o81uG/86sCFfue
         1LdCSwhInuJr/iKmL7oVI/xJdRMBZU9SGlkOQPymKBUECbWrWyUGfUh6nBQKlUUyKIAz
         44SzK6TyVJDckFK8YEvGYG9TPoZ67LGZvTBJzE4nksOhiE5GpxT5ZbEuFUn7n+UnIWQY
         a5JQLZ/mHdfxNHJCdW2ec0eQ5Y8RG3bppdkw6DX+U+0fsVBoDupS5XV1m1Q9fOdlks3C
         3e0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958176; x=1709562976;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0en7LuGGPdtEWR7o0ZKkW7B0C/vkNLQUW7iYqtMdnKQ=;
        b=E+2MsHlclWUf0jxwMKDfG01yKENkS23Ni4bw8CHTAWlLpKCwjP38bsUrTk2fOdm+DZ
         1qyugHprBRwwpMVVYP8dDNTtPJ49mItK87J9JMcJvyVx27cD+tmCTzgaNImSmJsATxSX
         z4c2upcQh0ksCwU+7mF/tfCrTkxtf7it6Dwvad9HDl1L0rv2d49vAFnmrNJbkcwLpDV4
         0KRjM7clfyP6kBPjNFSAx/H0ALHRRXoTcqJ9lu4uMK5GNuYz8xA55cP8AMXsFhEKtBGw
         9D7p01QFv4X+H7nPJFS+4CMONDXOE0wof8eadzSkT530u5vRFIV5VbTHId4sQNioSz7l
         4nHg==
X-Forwarded-Encrypted: i=1; AJvYcCWpA0XHxGf/hT2m40OU26xLcc1QDbxyxE9PrHklLG+2tlESybpRtnCo6P56vfKw518FeMBOz6alEn+0D7XgeC8qTzfh
X-Gm-Message-State: AOJu0YyGIELOvZaGCLXBzSuYsi9TOfJivskvNA21SUR0AN5ryjzlzXlm
	yzOh52WDfhG6FePogWuRVqj3ocA6sPvENkqAFpIuA8NjUScYA0emHcXh/ZVU
X-Google-Smtp-Source: AGHT+IHnVwo7GYxJJDVczscbJVFNB9n7llcj1bxVQaALhIzn6VPejmlCoxnolZB4h9xn3TwoQmd4jw==
X-Received: by 2002:a05:6e02:2166:b0:365:13a8:4090 with SMTP id s6-20020a056e02216600b0036513a84090mr9791278ilv.27.1708958175892;
        Mon, 26 Feb 2024 06:36:15 -0800 (PST)
Received: from localhost ([47.89.225.180])
        by smtp.gmail.com with ESMTPSA id s35-20020a634523000000b005cfb6e7b0c7sm4049086pga.39.2024.02.26.06.36.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:36:15 -0800 (PST)
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
Subject: [RFC PATCH 30/73] KVM: x86/PVM: Implement segment related callbacks
Date: Mon, 26 Feb 2024 22:35:47 +0800
Message-Id: <20240226143630.33643-31-jiangshanlai@gmail.com>
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

Segmentation in PVM guest is generally disabled and is only available
for instruction emulation. The segment descriptors of segment registers
are just cached and do not take effect in hardware. Since the PVM guest
is only allowed to run in x86 long mode, the value of guest CS/SS is
fixed and depends on the current mode.

Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
---
 arch/x86/kvm/pvm/pvm.c | 128 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 128 insertions(+)

diff --git a/arch/x86/kvm/pvm/pvm.c b/arch/x86/kvm/pvm/pvm.c
index 26b2201f7dde..6f91dffb6c50 100644
--- a/arch/x86/kvm/pvm/pvm.c
+++ b/arch/x86/kvm/pvm/pvm.c
@@ -630,6 +630,52 @@ static int pvm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	return ret;
 }
 
+static void pvm_get_segment(struct kvm_vcpu *vcpu,
+			    struct kvm_segment *var, int seg)
+{
+	struct vcpu_pvm *pvm = to_pvm(vcpu);
+
+	// Update CS or SS to reflect the current mode.
+	if (seg == VCPU_SREG_CS) {
+		if (is_smod(pvm)) {
+			pvm->segments[seg].selector = kernel_cs_by_msr(pvm->msr_star);
+			pvm->segments[seg].dpl = 0;
+			pvm->segments[seg].l = 1;
+			pvm->segments[seg].db = 0;
+		} else {
+			pvm->segments[seg].selector = pvm->hw_cs >> 3;
+			pvm->segments[seg].dpl = 3;
+			if (pvm->hw_cs == __USER_CS) {
+				pvm->segments[seg].l = 1;
+				pvm->segments[seg].db = 0;
+			} else { // __USER32_CS
+				pvm->segments[seg].l = 0;
+				pvm->segments[seg].db = 1;
+			}
+		}
+	} else if (seg == VCPU_SREG_SS) {
+		if (is_smod(pvm)) {
+			pvm->segments[seg].dpl = 0;
+			pvm->segments[seg].selector = kernel_ds_by_msr(pvm->msr_star);
+		} else {
+			pvm->segments[seg].dpl = 3;
+			pvm->segments[seg].selector = pvm->hw_ss >> 3;
+		}
+	}
+
+	// Update DS/ES/FS/GS states from the hardware when the states are loaded.
+	pvm_switch_to_host(pvm);
+	*var = pvm->segments[seg];
+}
+
+static u64 pvm_get_segment_base(struct kvm_vcpu *vcpu, int seg)
+{
+	struct kvm_segment var;
+
+	pvm_get_segment(vcpu, &var, seg);
+	return var.base;
+}
+
 static int pvm_get_cpl(struct kvm_vcpu *vcpu)
 {
 	if (is_smod(to_pvm(vcpu)))
@@ -637,6 +683,80 @@ static int pvm_get_cpl(struct kvm_vcpu *vcpu)
 	return 3;
 }
 
+static void pvm_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg)
+{
+	struct vcpu_pvm *pvm = to_pvm(vcpu);
+	int cpl = pvm_get_cpl(vcpu);
+
+	// Unload DS/ES/FS/GS states from hardware before changing them.
+	// It also has to unload the VCPU when leaving PVM mode.
+	pvm_switch_to_host(pvm);
+	pvm->segments[seg] = *var;
+
+	switch (seg) {
+	case VCPU_SREG_CS:
+		if (var->dpl == 1 || var->dpl == 2)
+			goto invalid_change;
+		if (!kvm_vcpu_has_run(vcpu)) {
+			// CPL changing is only valid for the first changed
+			// after the vcpu is created (vm-migration).
+			if (cpl != var->dpl)
+				pvm_switch_flags_toggle_mod(pvm);
+		} else {
+			if (cpl != var->dpl)
+				goto invalid_change;
+			if (cpl == 0 && !var->l)
+				goto invalid_change;
+		}
+		break;
+	case VCPU_SREG_LDTR:
+		// pvm doesn't support LDT
+		if (var->selector)
+			goto invalid_change;
+		break;
+	default:
+		break;
+	}
+
+	return;
+
+invalid_change:
+	kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
+}
+
+static void pvm_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l)
+{
+	struct vcpu_pvm *pvm = to_pvm(vcpu);
+
+	if (pvm->hw_cs == __USER_CS) {
+		*db = 0;
+		*l = 1;
+	} else {
+		*db = 1;
+		*l = 0;
+	}
+}
+
+static void pvm_get_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
+{
+	*dt = to_pvm(vcpu)->idt_ptr;
+}
+
+static void pvm_set_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
+{
+	to_pvm(vcpu)->idt_ptr = *dt;
+}
+
+static void pvm_get_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
+{
+	*dt = to_pvm(vcpu)->gdt_ptr;
+}
+
+static void pvm_set_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
+{
+	to_pvm(vcpu)->gdt_ptr = *dt;
+}
+
 static void pvm_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 				  int trig_mode, int vector)
 {
@@ -1545,8 +1665,16 @@ static struct kvm_x86_ops pvm_x86_ops __initdata = {
 	.get_msr_feature = pvm_get_msr_feature,
 	.get_msr = pvm_get_msr,
 	.set_msr = pvm_set_msr,
+	.get_segment_base = pvm_get_segment_base,
+	.get_segment = pvm_get_segment,
+	.set_segment = pvm_set_segment,
 	.get_cpl = pvm_get_cpl,
+	.get_cs_db_l_bits = pvm_get_cs_db_l_bits,
 	.load_mmu_pgd = pvm_load_mmu_pgd,
+	.get_gdt = pvm_get_gdt,
+	.set_gdt = pvm_set_gdt,
+	.get_idt = pvm_get_idt,
+	.set_idt = pvm_set_idt,
 	.get_rflags = pvm_get_rflags,
 	.set_rflags = pvm_set_rflags,
 	.get_if_flag = pvm_get_if_flag,
-- 
2.19.1.6.gb485710b


