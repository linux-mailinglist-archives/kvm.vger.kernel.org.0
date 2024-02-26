Return-Path: <kvm+bounces-9876-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EED688678CE
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 15:40:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9E18A288647
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 14:40:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E77B130AE3;
	Mon, 26 Feb 2024 14:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ioavjcri"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53834130AC9;
	Mon, 26 Feb 2024 14:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708958121; cv=none; b=oJzPqdfaBtzb0mKizJ+7Wj2m2peZ+fBr71m/6XmJNuf3Qz8ZrEP+KhSMKxtdEvSyjoUxNJpQo+GtX7ySUAKUa5Sr2jtKSQf8776ZzR4LB8QAOUnLisK0RIRPAFKvKkzyXSglbY7NUJLo3X41fogusfhrhrqEGezTi3P3JiH7Ecg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708958121; c=relaxed/simple;
	bh=ZRftprPhA+Ho5+u0w8l6wtMzwvZBZSuQdUzsf46+o4E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WKUF33lsAaHY1wabWaVoEnyCfIExGx4itJYJZfw+TmZnhOh4+ZjuFAD4dGKQVvxov8CDLh/ejkWPE1jLQfJx07igAyXl1dIQ8DPX3AH52zZOrkiy+cIVXSMr84lyHXOtfXExXZ+F6s5Y3ldk0QYasG6DFrhMorQb818wJ18Uzcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ioavjcri; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-1dc09556599so27193095ad.1;
        Mon, 26 Feb 2024 06:35:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708958119; x=1709562919; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TfQmPSzBj4Fo3ydJK18pQVJpu7jjOOVodiv0WFv/iog=;
        b=IoavjcriLGSpOwaBMKnP3g1xUQudQL7wBAPYtyBmN4ASdWI6YMyElDpfjFjEaS0Vuh
         F6ZI9TFneMSHVc6V+dyz2veZY+qyot83CLc4PFZkZvh8uxiNyVo29jRbSCONMaiJHsmw
         ganQv6YHifIcCkXjiP5rPPO1wYo4zRT2AP3t0ijciHYbtfAl2IZbhmSQ2otHwk9SzPt7
         rhYehM7agczxcb6qC+nR6BN31dIKx/4dYQ9wnotMTSgC4KDlmGyKaIkL+fCnS81aJD2v
         lz5mzc1QCOcI0C+DwIHQVz/fyQ216ip1VDy+QXKH6ULn+ZaQ7s94YMPawyF6dzwvK7Oa
         WcVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708958119; x=1709562919;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TfQmPSzBj4Fo3ydJK18pQVJpu7jjOOVodiv0WFv/iog=;
        b=a0m7U02+vaXgB1uUOyvIrA38v0AnsERiKYeA2sqtmmhhcppZnFOvxZl9DhIpDA/roY
         Gki+/eDBf8SHT5Swcqrg8c34I8avcVUX55ZQFFfMrvUmLWL6R1cMa2HbZVdYpGuAVshl
         YuY+cuLrVVzf2jG2M3pkqqbGP3SB7gUHEYyw8hdDkyH0hPj+hsb2YE4eV/VikGotwji2
         gviulTcGulM3maZQjtW5o2sfWYGlAEJwxA4Mm8Yc/0tLZdFsDl08YGhHKeaQxc/RQnNv
         HTAfZ/2WWXQLjZ4YGWWg/kuvFlh+GLqPdeFD4gxTba+Q3LKeXwo74qSPEpawjd7YAnmt
         FszQ==
X-Forwarded-Encrypted: i=1; AJvYcCVV51VsDNKGc8zHOICux2KElu39o2xp5PQPSY/99xWo7JFWGvbNhscpN98q2Ip99X+otusguBt+QKiECgXd0wrKsDJv
X-Gm-Message-State: AOJu0Yw7DYIFakPRzDmt4dGQuKPMG05+kJct640CPC3sOhONAZgWVegs
	2fEiqTtIK6RmPfgTINwxKdilVC+4G6kQeRHV+/V2MiFRToGThPYzpDaAfdQT
X-Google-Smtp-Source: AGHT+IHldQr53EBhTOxhBVe+CUB5Y00wRU3RJwgsiwc9/HvQeCqAwP/KKcj86yTFl3OFFeND7E+IQw==
X-Received: by 2002:a17:902:6e01:b0:1dc:8508:8e35 with SMTP id u1-20020a1709026e0100b001dc85088e35mr6453645plk.68.1708958119044;
        Mon, 26 Feb 2024 06:35:19 -0800 (PST)
Received: from localhost ([198.11.176.14])
        by smtp.gmail.com with ESMTPSA id v4-20020a1709028d8400b001dc90b62393sm2882249plo.216.2024.02.26.06.35.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Feb 2024 06:35:18 -0800 (PST)
From: Lai Jiangshan <jiangshanlai@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Lai Jiangshan <jiangshan.ljs@antgroup.com>,
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
Subject: [RFC PATCH 13/73] KVM: x86/emulator: Reinject #GP if instruction emulation failed for PVM
Date: Mon, 26 Feb 2024 22:35:30 +0800
Message-Id: <20240226143630.33643-14-jiangshanlai@gmail.com>
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

From: Hou Wenlong <houwenlong.hwl@antgroup.com>

The privilege instruction in PVM guest supervisor mode will trigger a
instruction triggers a #GP in PVM guest supervisor mode and is not
implemented in the emulator, the emulator will currently exit to
userspace, and VMM may not be able to handle it. This can be triggered
by guest userspace, e.g., a guest userspace process can corrupt the
XSTATE header in a signal frame and the XRSTOR in the guest kernel will
trigger a #GP, but XRSTOR is not implemented in the emulator now.
Therefore, a new emulate type for PVM is added to instruct the emulator
to reinject the #GP into the guest.

Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
Signed-off-by: Lai Jiangshan <jiangshan.ljs@antgroup.com>
---
 arch/x86/include/asm/kvm_host.h | 8 ++++++++
 arch/x86/kvm/x86.c              | 5 +++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index a90807f676b9..3e6f27865528 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1954,6 +1954,13 @@ u64 vcpu_tsc_khz(struct kvm_vcpu *vcpu);
  *			     the gfn, i.e. retrying the instruction will hit a
  *			     !PRESENT fault, which results in a new shadow page
  *			     and sends KVM back to square one.
+ *
+ * EMULTYPE_PVM_GP - Set when emulating an intercepted #GP for PVM. Privilege
+ *		     instruction in PVM guest supervisor mode will trigger a
+ *		     #GP and be emulated by PVM. But if a non-privilege
+ *		     instruction triggers a #GP in PVM guest supervisor mode
+ *		     and is not implemented in the emulator, the emulator
+ *		     should reinject the #GP into guest.
  */
 #define EMULTYPE_NO_DECODE	    (1 << 0)
 #define EMULTYPE_TRAP_UD	    (1 << 1)
@@ -1964,6 +1971,7 @@ u64 vcpu_tsc_khz(struct kvm_vcpu *vcpu);
 #define EMULTYPE_PF		    (1 << 6)
 #define EMULTYPE_COMPLETE_USER_EXIT (1 << 7)
 #define EMULTYPE_WRITE_PF_TO_SP	    (1 << 8)
+#define EMULTYPE_PVM_GP		    (1 << 9)
 
 int kvm_emulate_instruction(struct kvm_vcpu *vcpu, int emulation_type);
 int kvm_emulate_instruction_from_buffer(struct kvm_vcpu *vcpu,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 89bf368085a9..29413cb2f090 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8664,7 +8664,7 @@ static int handle_emulation_failure(struct kvm_vcpu *vcpu, int emulation_type)
 	++vcpu->stat.insn_emulation_fail;
 	trace_kvm_emulate_insn_failed(vcpu);
 
-	if (emulation_type & EMULTYPE_VMWARE_GP) {
+	if (emulation_type & (EMULTYPE_VMWARE_GP | EMULTYPE_PVM_GP)) {
 		kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
 		return 1;
 	}
@@ -8902,7 +8902,8 @@ static bool kvm_vcpu_check_code_breakpoint(struct kvm_vcpu *vcpu,
 	 * and without a prefix.
 	 */
 	if (emulation_type & (EMULTYPE_NO_DECODE | EMULTYPE_SKIP |
-			      EMULTYPE_TRAP_UD | EMULTYPE_VMWARE_GP | EMULTYPE_PF))
+			      EMULTYPE_TRAP_UD | EMULTYPE_VMWARE_GP |
+			      EMULTYPE_PVM_GP | EMULTYPE_PF))
 		return false;
 
 	if (unlikely(vcpu->guest_debug & KVM_GUESTDBG_USE_HW_BP) &&
-- 
2.19.1.6.gb485710b


