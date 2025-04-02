Return-Path: <kvm+bounces-42457-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 466FDA789DD
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 10:29:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 043937A53E8
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 08:28:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE0B72356DA;
	Wed,  2 Apr 2025 08:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JVzo88t1"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAAEE23534D;
	Wed,  2 Apr 2025 08:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743582546; cv=none; b=BHN/4hxqwnZKU7BCuxPidOoX0rS66DAWfUFLcbIaFVKoQae+DKGRFVz5xkDXtq+bMdW/AdX/NFl4r+G1NYBL87dPKIUsfN2xRTK41B8KZzBxP41JRYhpuyVpRCpzkuQ8EIe0pPl9ENuxdtGKWG24msfMBPhVEgTHkHZKklp2MDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743582546; c=relaxed/simple;
	bh=iwE9zHuYFYjBKqHaIW4VF+tXUhWkWm+PMEJkvYVBaXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K3qAeflPJ52AwDKzhkNiZlhCGoF4oH0NDUmcMWbkcK5P+g8s1eMQGCk+k0Yl8fXcitxQCmd5/f72r35PSjRZEKoHWzrxBpvr5JX/AaAQncbWYTBOW50piXY+aHgKHiisxURka4GUbZF9+OFdrFUmMxiWr25CGcmlVVEt8dToc0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JVzo88t1; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5493CC4CEDD;
	Wed,  2 Apr 2025 08:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743582546;
	bh=iwE9zHuYFYjBKqHaIW4VF+tXUhWkWm+PMEJkvYVBaXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JVzo88t16ZjM8MszTZXtKtDlN21lEeGH7kxXO88WaaFLSaH94epzLs+irDfyHttl+
	 TtvAIejtRAU8Y0h6FTTUNekKciN+8Ftd25ra8Q/Z7+sqez+WV5fB0TQJpDZcQIRM6Y
	 q0dytxHMLbvhKZuyo+P/nNR0saaZqd2N0X6chj0QOqOkoOwtviL7snBO9+bgxSTFLM
	 L7eRtSDvSjuDd8tR4d1D0egE0J6563NNMhGjbXavkgWLtffE6HbPGPwzM1JCw6R3OR
	 QdT4VWB8xPwMOy3qKUMDy6kuD+rabltEby0LqtEw2jRnGO2cnTr7iFawd3hfEbrFWs
	 qFn7m+Yt66s4g==
From: Amit Shah <amit@kernel.org>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org,
	linux-doc@vger.kernel.org
Cc: amit.shah@amd.com,
	thomas.lendacky@amd.com,
	bp@alien8.de,
	tglx@linutronix.de,
	peterz@infradead.org,
	jpoimboe@kernel.org,
	pawan.kumar.gupta@linux.intel.com,
	corbet@lwn.net,
	mingo@redhat.com,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	daniel.sneddon@linux.intel.com,
	kai.huang@intel.com,
	sandipan.das@amd.com,
	boris.ostrovsky@oracle.com,
	Babu.Moger@amd.com,
	david.kaplan@amd.com,
	dwmw@amazon.co.uk,
	andrew.cooper3@citrix.com
Subject: [RFC PATCH v4 2/2] debug: add tracepoint for flush_rap_on_vmrun
Date: Wed,  2 Apr 2025 10:28:33 +0200
Message-ID: <20250402082833.9835-3-amit@kernel.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250402082833.9835-1-amit@kernel.org>
References: <20250402082833.9835-1-amit@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Amit Shah <amit.shah@amd.com>

---
 arch/x86/kvm/svm/svm.c |  4 +++-
 arch/x86/kvm/trace.h   | 16 ++++++++++++++++
 arch/x86/kvm/x86.c     |  1 +
 3 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index b5de6341080b..c47d4dfcc1d4 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3607,8 +3607,10 @@ static int svm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 
 		trace_kvm_nested_vmexit(vcpu, KVM_ISA_SVM);
 
-		if (vmcb_is_extended_rap(svm->vmcb01.ptr))
+		if (vmcb_is_extended_rap(svm->vmcb01.ptr)) {
 			vmcb_flush_guest_rap(svm->vmcb01.ptr);
+			trace_kvm_svm_eraps_flush_rap(svm->vmcb01.ptr);
+		}
 
 		vmexit = nested_svm_exit_special(svm);
 
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index ccda95e53f62..059dfc744a22 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -346,6 +346,22 @@ TRACE_EVENT(name,							     \
  */
 TRACE_EVENT_KVM_EXIT(kvm_exit);
 
+TRACE_EVENT(kvm_svm_eraps_flush_rap,					     \
+	TP_PROTO(struct vmcb *vmcb),					     \
+	TP_ARGS(vmcb),							     \
+									     \
+	TP_STRUCT__entry(						     \
+		__field( struct vmcb *,		vmcb		)	     \
+	),								     \
+									     \
+	TP_fast_assign(							     \
+		__entry->vmcb	= vmcb; 				     \
+	),								     \
+									     \
+	TP_printk("vmcb: 0x%p",						     \
+		  __entry->vmcb)					     \
+)
+
 /*
  * Tracepoint for kvm interrupt injection:
  */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c841817a914a..414a0e6c9c4b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -14024,6 +14024,7 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_msr_protocol_enter);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_vmgexit_msr_protocol_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_rmp_fault);
+EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_svm_eraps_flush_rap);
 
 static int __init kvm_x86_init(void)
 {
-- 
2.49.0


