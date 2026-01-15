Return-Path: <kvm+bounces-68165-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id A215ED23433
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 09:50:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3B18430ADD99
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 08:49:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1EE333E36E;
	Thu, 15 Jan 2026 08:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="OqSKW0h/";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="OqSKW0h/"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD3933A02F
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 08:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768466944; cv=none; b=OACYEHd0fnEY4hwo91yZImz77NNLoKs3wTiwpxeQ438VjUDlKZ/az/Xp+9Bob0h9fK3mnF58rDgqkfVlnqgsWHU8s9AMdsoTFf6UG1EgsK65agEf6hf3suqpWz30v5o8lBilWBtp+bk2S+2frTYbAsR++4pzlUGrB1F9e+7sfg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768466944; c=relaxed/simple;
	bh=iclbuSqykbLSDpF51iHz3rA9SaEpMPs3TWWgXxi13hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lEPRoaGEA92m779qO5mTc/iYOo+LwaHgIPwuZbPJR0FxUaCq/YSaztcXVUKn9PK5ikiolpEX85C6YmueDcqEnZOC9PoGqjZPHMez8oDmBtNTF4EBuu+cnfTFUIO8P7mOCyhsLNgDce9LqlFjtTrKJQhcCVkHdIxSTr+X+c/VcFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=OqSKW0h/; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=OqSKW0h/; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 024B05BD50;
	Thu, 15 Jan 2026 08:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1768466941; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IcAVv+KWnCRg/40DoITyiU2vnkn2NT3Rm2oPIYRObDo=;
	b=OqSKW0h/vTBTF5rxkK8jBk2q9SlrT+BMlkvp1CJtp/WTXpRALfw8fxy8tsdL3j99VTBm2E
	axEXjWeGzRk5Lpu4U283tMfbvwFKoQqBJq/HSFbufiaspchMqczltzIdIPomOzeSD3DNtb
	Yul6DYgFjlZDw5neu8XX3s+gzdIPYec=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1768466941; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IcAVv+KWnCRg/40DoITyiU2vnkn2NT3Rm2oPIYRObDo=;
	b=OqSKW0h/vTBTF5rxkK8jBk2q9SlrT+BMlkvp1CJtp/WTXpRALfw8fxy8tsdL3j99VTBm2E
	axEXjWeGzRk5Lpu4U283tMfbvwFKoQqBJq/HSFbufiaspchMqczltzIdIPomOzeSD3DNtb
	Yul6DYgFjlZDw5neu8XX3s+gzdIPYec=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D85283EA63;
	Thu, 15 Jan 2026 08:48:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UJZeMPupaGnWIAAAD6G6ig
	(envelope-from <jgross@suse.com>); Thu, 15 Jan 2026 08:48:59 +0000
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org
Cc: Juergen Gross <jgross@suse.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	xen-devel@lists.xenproject.org
Subject: [PATCH v3 1/5] x86/paravirt: Replace io_delay() hook with a bool
Date: Thu, 15 Jan 2026 09:48:45 +0100
Message-ID: <20260115084849.31502-2-jgross@suse.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260115084849.31502-1-jgross@suse.com>
References: <20260115084849.31502-1-jgross@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.999];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_TWO(0.00)[2];
	RCPT_COUNT_TWELVE(0.00)[17];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 

The io_delay() paravirt hook is in no way performance critical and all
users setting it to a different function than native_io_delay() are
using an empty function as replacement.

This enables to replace the hook with a bool indicating whether
native_io_delay() should be called.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
V3:
- rebase to tip/master kernel branch
---
 arch/x86/include/asm/io.h             |  9 ++++++---
 arch/x86/include/asm/paravirt-base.h  |  6 ++++++
 arch/x86/include/asm/paravirt.h       | 11 -----------
 arch/x86/include/asm/paravirt_types.h |  2 --
 arch/x86/kernel/cpu/vmware.c          |  2 +-
 arch/x86/kernel/kvm.c                 |  8 +-------
 arch/x86/kernel/paravirt.c            |  3 +--
 arch/x86/xen/enlighten_pv.c           |  6 +-----
 8 files changed, 16 insertions(+), 31 deletions(-)

diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index ca309a3227c7..8a9292ce7d2d 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -243,11 +243,16 @@ extern int io_delay_type;
 extern void io_delay_init(void);
 
 #if defined(CONFIG_PARAVIRT)
-#include <asm/paravirt.h>
+#include <asm/paravirt-base.h>
 #else
+#define call_io_delay() true
+#endif
 
 static inline void slow_down_io(void)
 {
+	if (!call_io_delay())
+		return;
+
 	native_io_delay();
 #ifdef REALLY_SLOW_IO
 	native_io_delay();
@@ -256,8 +261,6 @@ static inline void slow_down_io(void)
 #endif
 }
 
-#endif
-
 #define BUILDIO(bwl, type)						\
 static inline void out##bwl##_p(type value, u16 port)			\
 {									\
diff --git a/arch/x86/include/asm/paravirt-base.h b/arch/x86/include/asm/paravirt-base.h
index 982a0b93bc76..3b9e7772d196 100644
--- a/arch/x86/include/asm/paravirt-base.h
+++ b/arch/x86/include/asm/paravirt-base.h
@@ -15,6 +15,8 @@ struct pv_info {
 #ifdef CONFIG_PARAVIRT_XXL
 	u16 extra_user_64bit_cs;  /* __USER_CS if none */
 #endif
+	bool io_delay;
+
 	const char *name;
 };
 
@@ -26,6 +28,10 @@ u64 _paravirt_ident_64(u64);
 #endif
 #define paravirt_nop	((void *)nop_func)
 
+#ifdef CONFIG_PARAVIRT
+#define call_io_delay() pv_info.io_delay
+#endif
+
 #ifdef CONFIG_PARAVIRT_SPINLOCKS
 void paravirt_set_cap(void);
 #else
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index b21072af731d..f4885bd98a18 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -19,17 +19,6 @@
 #include <linux/cpumask.h>
 #include <asm/frame.h>
 
-/* The paravirtualized I/O functions */
-static inline void slow_down_io(void)
-{
-	PVOP_VCALL0(pv_ops, cpu.io_delay);
-#ifdef REALLY_SLOW_IO
-	PVOP_VCALL0(pv_ops, cpu.io_delay);
-	PVOP_VCALL0(pv_ops, cpu.io_delay);
-	PVOP_VCALL0(pv_ops, cpu.io_delay);
-#endif
-}
-
 void native_flush_tlb_local(void);
 void native_flush_tlb_global(void);
 void native_flush_tlb_one_user(unsigned long addr);
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 7ccd41628d36..3946d0f69921 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -30,8 +30,6 @@ struct pv_lazy_ops {
 
 struct pv_cpu_ops {
 	/* hooks for various privileged instructions */
-	void (*io_delay)(void);
-
 #ifdef CONFIG_PARAVIRT_XXL
 	unsigned long (*get_debugreg)(int regno);
 	void (*set_debugreg)(int regno, unsigned long value);
diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
index a3e6936839b1..eee0d1a48802 100644
--- a/arch/x86/kernel/cpu/vmware.c
+++ b/arch/x86/kernel/cpu/vmware.c
@@ -339,7 +339,7 @@ arch_initcall(activate_jump_labels);
 static void __init vmware_paravirt_ops_setup(void)
 {
 	pv_info.name = "VMware hypervisor";
-	pv_ops.cpu.io_delay = paravirt_nop;
+	pv_info.io_delay = false;
 
 	if (vmware_tsc_khz == 0)
 		return;
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index de550b12d9ab..8c3221048d9f 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -75,12 +75,6 @@ DEFINE_PER_CPU_DECRYPTED(struct kvm_steal_time, steal_time) __aligned(64) __visi
 static int has_steal_clock = 0;
 
 static int has_guest_poll = 0;
-/*
- * No need for any "IO delay" on KVM
- */
-static void kvm_io_delay(void)
-{
-}
 
 #define KVM_TASK_SLEEP_HASHBITS 8
 #define KVM_TASK_SLEEP_HASHSIZE (1<<KVM_TASK_SLEEP_HASHBITS)
@@ -314,7 +308,7 @@ static void __init paravirt_ops_setup(void)
 	pv_info.name = "KVM";
 
 	if (kvm_para_has_feature(KVM_FEATURE_NOP_IO_DELAY))
-		pv_ops.cpu.io_delay = kvm_io_delay;
+		pv_info.io_delay = false;
 
 #ifdef CONFIG_X86_IO_APIC
 	no_timer_check = 1;
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index a6ed52cae003..792fa96b3233 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -94,6 +94,7 @@ struct pv_info pv_info = {
 #ifdef CONFIG_PARAVIRT_XXL
 	.extra_user_64bit_cs = __USER_CS,
 #endif
+	.io_delay = true,
 };
 
 /* 64-bit pagetable entries */
@@ -101,8 +102,6 @@ struct pv_info pv_info = {
 
 struct paravirt_patch_template pv_ops = {
 	/* Cpu ops. */
-	.cpu.io_delay		= native_io_delay,
-
 #ifdef CONFIG_PARAVIRT_XXL
 	.cpu.cpuid		= native_cpuid,
 	.cpu.get_debugreg	= pv_native_get_debugreg,
diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index 8a19a88190ee..9c9695f5d158 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -1046,10 +1046,6 @@ static void xen_update_io_bitmap(void)
 }
 #endif
 
-static void xen_io_delay(void)
-{
-}
-
 static DEFINE_PER_CPU(unsigned long, xen_cr0_value);
 
 static unsigned long xen_read_cr0(void)
@@ -1209,6 +1205,7 @@ void __init xen_setup_vcpu_info_placement(void)
 
 static const struct pv_info xen_info __initconst = {
 	.extra_user_64bit_cs = FLAT_USER_CS64,
+	.io_delay = false,
 	.name = "Xen",
 };
 
@@ -1392,7 +1389,6 @@ asmlinkage __visible void __init xen_start_kernel(struct start_info *si)
 	pv_ops.cpu.invalidate_io_bitmap = xen_invalidate_io_bitmap;
 	pv_ops.cpu.update_io_bitmap = xen_update_io_bitmap;
 #endif
-	pv_ops.cpu.io_delay = xen_io_delay;
 	pv_ops.cpu.start_context_switch = xen_start_context_switch;
 	pv_ops.cpu.end_context_switch = xen_end_context_switch;
 
-- 
2.51.0


