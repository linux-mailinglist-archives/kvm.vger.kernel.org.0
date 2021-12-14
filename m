Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92E46473AF0
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 03:51:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244851AbhLNCum (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Dec 2021 21:50:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244830AbhLNCub (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Dec 2021 21:50:31 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E66E6C061748;
        Mon, 13 Dec 2021 18:50:30 -0800 (PST)
Message-ID: <20211214024948.108057289@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639450229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=SlagvVmM7GKanabo7JJfDiodZn7MWyey8x+4xe/zd+0=;
        b=MO4eLPYNokixAlehe7eQ6maGtFhDe080A7yLHONsn8oVH1HRKMc4neYD9qqXpoDqTZHvvs
        bPEWIzzd7GItB7r8PdSbG4KQSJrB11Hh1oX+yKJ9VtlT68HXV+NJwaZPDg4S1g9YcsErlC
        QE7loTmQ2atocO0iDSQ39d4YspxoH3sI/5nAvVBx27smH/1nckcYayJeJxb9M1jXi76jBY
        sNTICU8P/EhqU8Xq0YeMbyxTxkoJd4OiJnW6+OwV8MqFzbwiYS3OH3qPtALzcETW7Hm8Hg
        y+1F/QUYEEFNq18ri/5zM7MGkdinwCMpPJYQPesrJyKeeFPshVnyK40qobrlCQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639450229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         references:references; bh=SlagvVmM7GKanabo7JJfDiodZn7MWyey8x+4xe/zd+0=;
        b=3rU9YOXzfVQzXn+ovm3vW8gHT77DsWjsTeXzdobpi9c/NEEUUSBxGQLUbzbjQUR1cpOZTT
        J6X+svn+ePj0JTDw==
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Jing Liu <jing2.liu@linux.intel.com>,
        Yang Zhong <yang.zhong@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, x86@kernel.org,
        kvm@vger.kernel.org, Sean Christoperson <seanjc@google.com>,
        Jin Nakajima <jun.nakajima@intel.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: [patch 6/6] x86/fpu: Provide kvm_sync_guest_vmexit_xfd_state()
References: <20211214022825.563892248@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 14 Dec 2021 03:50:28 +0100 (CET)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM can disable the write emulation for the XFD MSR when the vCPU's fpstate
is already correctly sized to reduce the overhead.

When write emulation is disabled the XFD MSR state after a VMEXIT is
unknown and therefore not in sync with the software states in fpstate and
the per CPU XFD cache.

Provide kvm_sync_guest_vmexit_xfd_state() which has to be invoked after a
VMEXIT before enabling interrupts when write emulation is disabled for the
XFD MSR.

It could be invoked unconditionally even when write emulation is enabled
for the price of a pointless MSR read.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/fpu/api.h |    6 ++++++
 arch/x86/kernel/fpu/core.c     |   26 ++++++++++++++++++++++++++
 2 files changed, 32 insertions(+)

--- a/arch/x86/include/asm/fpu/api.h
+++ b/arch/x86/include/asm/fpu/api.h
@@ -194,6 +194,12 @@ static inline int fpu_update_guest_xfd(s
 	return __fpu_update_guest_features(guest_fpu, xcr0, xfd);
 }
 
+#ifdef CONFIG_X86_64
+extern void fpu_sync_guest_vmexit_xfd_state(void);
+#else
+static inline void fpu_sync_guest_vmexit_xfd_state(void) { }
+#endif
+
 extern void fpu_copy_guest_fpstate_to_uabi(struct fpu_guest *gfpu, void *buf, unsigned int size, u32 pkru);
 extern int fpu_copy_uabi_to_guest_fpstate(struct fpu_guest *gfpu, const void *buf, u64 xcr0, u32 *vpkru);
 
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -318,6 +318,32 @@ int __fpu_update_guest_features(struct f
 }
 EXPORT_SYMBOL_GPL(__fpu_update_guest_features);
 
+#ifdef CONFIG_X86_64
+/**
+ * fpu_sync_guest_vmexit_xfd_state - Synchronize XFD MSR and software state
+ *
+ * Must be invoked from KVM after a VMEXIT before enabling interrupts when
+ * XFD write emulation is disabled. This is required because the guest can
+ * freely modify XFD and the state at VMEXIT is not guaranteed to be the
+ * same as the state on VMENTER. So software state has to be udpated before
+ * any operation which depends on it can take place.
+ *
+ * Note: It can be invoked unconditionally even when write emulation is
+ * enabled for the price of a then pointless MSR read.
+ */
+void fpu_sync_guest_vmexit_xfd_state(void)
+{
+	struct fpstate *fps = current->thread.fpu.fpstate;
+
+	lockdep_assert_irqs_disabled();
+	if (fpu_state_size_dynamic()) {
+		rdmsrl(MSR_IA32_XFD, fps->xfd);
+		__this_cpu_write(xfd_state, fps->xfd);
+	}
+}
+EXPORT_SYMBOL_GPL(fpu_sync_guest_vmexit_xfd_state);
+#endif /* CONFIG_X86_64 */
+
 int fpu_swap_kvm_fpstate(struct fpu_guest *guest_fpu, bool enter_guest)
 {
 	struct fpstate *guest_fps = guest_fpu->fpstate;

