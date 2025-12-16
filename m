Return-Path: <kvm+bounces-66068-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EE62CC3C29
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 15:54:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8C49330249EA
	for <lists+kvm@lfdr.de>; Tue, 16 Dec 2025 14:43:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F185413DBA0;
	Tue, 16 Dec 2025 13:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="DkVkBcd5";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="DkVkBcd5"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F177C36212B
	for <kvm@vger.kernel.org>; Tue, 16 Dec 2025 13:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765892526; cv=none; b=kpiMI+HH9AWFymQROmUKPat8Md6efzWSdYnzt+u71+FpizGgmg0YEym02qGf74wuADrUk9dUjWkxGt5jwZ1IA+V3XBFyk+Isn5ApySnlh9jYq20HxsAk/+4ReHQedfPzICcll4EChLXqMjo431Elv7f4K+yEl1CNGzrp0UsoER8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765892526; c=relaxed/simple;
	bh=GLEVDIIIoNKevzrg5ZYFlffDOMFy86HByRT68YVoFpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MwFp16lAOTa+WbOkn+0Pl79WtwSDe0maSgR7k4ewpUazoSsfixTod988N9LVCLN8rqtUiYFbZlqiG7EkU3A4to41Ct1jutM/sbcKa+sEpyvHWXajt9/ijGnE7xgdBGY+z+nDHYORE0eLnaRKN4fxGQ74tX1JJzGfmI6YwNguDsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=DkVkBcd5; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=DkVkBcd5; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 02B875BCD9;
	Tue, 16 Dec 2025 13:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1765892519; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AR9YJoS/ZrGpIqMtjrLccD/9zZj/TpZQABpLh6glIqg=;
	b=DkVkBcd5mBJQwy0RPRVIJHi8UZSzCLnz2M6ZC+CBmmUp2O9YgvKple7Q3Z5ycz/89MNVQv
	tySgursow+vR91U+STvdo4ph0OZfaipg9r6mNnD5zxK7T9zfi+j6nLzNrgot4OneY02lFm
	VO9LaqLa5t9rEqzYanEyIbB8A3jUldk=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1765892519; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AR9YJoS/ZrGpIqMtjrLccD/9zZj/TpZQABpLh6glIqg=;
	b=DkVkBcd5mBJQwy0RPRVIJHi8UZSzCLnz2M6ZC+CBmmUp2O9YgvKple7Q3Z5ycz/89MNVQv
	tySgursow+vR91U+STvdo4ph0OZfaipg9r6mNnD5zxK7T9zfi+j6nLzNrgot4OneY02lFm
	VO9LaqLa5t9rEqzYanEyIbB8A3jUldk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4FDEA3EA63;
	Tue, 16 Dec 2025 13:41:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id jRe6EaZhQWmJHwAAD6G6ig
	(envelope-from <jgross@suse.com>); Tue, 16 Dec 2025 13:41:58 +0000
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org
Cc: Juergen Gross <jgross@suse.com>,
	Thomas Gleixner <tglx@linutronix.de>,
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
Subject: [PATCH v2 1/5] x86/paravirt: Replace io_delay() hook with a bool
Date: Tue, 16 Dec 2025 14:41:45 +0100
Message-ID: <20251216134150.2710-2-jgross@suse.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251216134150.2710-1-jgross@suse.com>
References: <20251216134150.2710-1-jgross@suse.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-6.80 / 50.00];
	REPLY(-4.00)[];
	BAYES_HAM(-3.00)[100.00%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_MISSING_CHARSET(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-0.989];
	MIME_GOOD(-0.10)[text/plain];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[17];
	DKIM_SIGNED(0.00)[suse.com:s=susede1];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	R_RATELIMIT(0.00)[to_ip_from(RLfdszjqhz8kzzb9uwpzdm8png)];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -6.80

The io_delay() paravirt hook is in no way performance critical and all
users setting it to a different function than native_io_delay() are
using an empty function as replacement.

This enables to replace the hook with a bool indicating whether
native_io_delay() should be called.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 arch/x86/include/asm/io.h             |  7 +++++--
 arch/x86/include/asm/paravirt.h       | 11 +----------
 arch/x86/include/asm/paravirt_types.h |  3 +--
 arch/x86/kernel/cpu/vmware.c          |  2 +-
 arch/x86/kernel/kvm.c                 |  8 +-------
 arch/x86/kernel/paravirt.c            |  3 +--
 arch/x86/xen/enlighten_pv.c           |  6 +-----
 7 files changed, 11 insertions(+), 29 deletions(-)

diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index ca309a3227c7..0448575569b9 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -245,9 +245,14 @@ extern void io_delay_init(void);
 #if defined(CONFIG_PARAVIRT)
 #include <asm/paravirt.h>
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
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index b5e59a7ba0d0..0ab798d234cc 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -53,16 +53,7 @@ static inline u64 paravirt_steal_clock(int cpu)
 void __init paravirt_set_cap(void);
 #endif
 
-/* The paravirtualized I/O functions */
-static inline void slow_down_io(void)
-{
-	PVOP_VCALL0(cpu.io_delay);
-#ifdef REALLY_SLOW_IO
-	PVOP_VCALL0(cpu.io_delay);
-	PVOP_VCALL0(cpu.io_delay);
-	PVOP_VCALL0(cpu.io_delay);
-#endif
-}
+#define call_io_delay() pv_info.io_delay
 
 void native_flush_tlb_local(void);
 void native_flush_tlb_global(void);
diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 3502939415ad..b4c15856eab5 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -36,6 +36,7 @@ struct pv_info {
 #ifdef CONFIG_PARAVIRT_XXL
 	u16 extra_user_64bit_cs;  /* __USER_CS if none */
 #endif
+	bool io_delay;
 
 	const char *name;
 };
@@ -51,8 +52,6 @@ struct pv_lazy_ops {
 
 struct pv_cpu_ops {
 	/* hooks for various privileged instructions */
-	void (*io_delay)(void);
-
 #ifdef CONFIG_PARAVIRT_XXL
 	unsigned long (*get_debugreg)(int regno);
 	void (*set_debugreg)(int regno, unsigned long value);
diff --git a/arch/x86/kernel/cpu/vmware.c b/arch/x86/kernel/cpu/vmware.c
index cb3f900c46fc..47db25d63c8d 100644
--- a/arch/x86/kernel/cpu/vmware.c
+++ b/arch/x86/kernel/cpu/vmware.c
@@ -338,7 +338,7 @@ arch_initcall(activate_jump_labels);
 static void __init vmware_paravirt_ops_setup(void)
 {
 	pv_info.name = "VMware hypervisor";
-	pv_ops.cpu.io_delay = paravirt_nop;
+	pv_info.io_delay = false;
 
 	if (vmware_tsc_khz == 0)
 		return;
diff --git a/arch/x86/kernel/kvm.c b/arch/x86/kernel/kvm.c
index df78ddee0abb..24e403cdce69 100644
--- a/arch/x86/kernel/kvm.c
+++ b/arch/x86/kernel/kvm.c
@@ -74,12 +74,6 @@ DEFINE_PER_CPU_DECRYPTED(struct kvm_steal_time, steal_time) __aligned(64) __visi
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
@@ -313,7 +307,7 @@ static void __init paravirt_ops_setup(void)
 	pv_info.name = "KVM";
 
 	if (kvm_para_has_feature(KVM_FEATURE_NOP_IO_DELAY))
-		pv_ops.cpu.io_delay = kvm_io_delay;
+		pv_info.io_delay = false;
 
 #ifdef CONFIG_X86_IO_APIC
 	no_timer_check = 1;
diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index ab3e172dcc69..8ee952e7e7d4 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -113,6 +113,7 @@ struct pv_info pv_info = {
 #ifdef CONFIG_PARAVIRT_XXL
 	.extra_user_64bit_cs = __USER_CS,
 #endif
+	.io_delay = true,
 };
 
 /* 64-bit pagetable entries */
@@ -120,8 +121,6 @@ struct pv_info pv_info = {
 
 struct paravirt_patch_template pv_ops = {
 	/* Cpu ops. */
-	.cpu.io_delay		= native_io_delay,
-
 #ifdef CONFIG_PARAVIRT_XXL
 	.cpu.cpuid		= native_cpuid,
 	.cpu.get_debugreg	= pv_native_get_debugreg,
diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index 4806cc28d7ca..a43b525f25cd 100644
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
 
@@ -1253,7 +1250,6 @@ static const typeof(pv_ops) xen_cpu_ops __initconst = {
 		.invalidate_io_bitmap = xen_invalidate_io_bitmap,
 		.update_io_bitmap = xen_update_io_bitmap,
 #endif
-		.io_delay = xen_io_delay,
 
 		.start_context_switch = xen_start_context_switch,
 		.end_context_switch = xen_end_context_switch,
-- 
2.51.0


