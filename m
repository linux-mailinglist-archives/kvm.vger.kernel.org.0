Return-Path: <kvm+bounces-69461-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +LfAJUG1emma9QEAu9opvQ
	(envelope-from <kvm+bounces-69461-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:17:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 18C26AA960
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 02:17:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D7A1B305F215
	for <lists+kvm@lfdr.de>; Thu, 29 Jan 2026 01:16:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D86D33D6D8;
	Thu, 29 Jan 2026 01:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sItXTfVk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B65333D4E2
	for <kvm@vger.kernel.org>; Thu, 29 Jan 2026 01:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769649351; cv=none; b=UM0+XMR/S2OvhNdhBOJLD+6h8csKIIWtdcXa8060XcHAX1laAszLqHzSp9V5BIPXlChDgHJr88sU4n8AtNaOT9Be8SjWEaGJhrFaD0ZlOVQC3vE21//9P93e6zW5DMptZPgZmLh1RhJrnGYrhM/EnE4YRdT5exfE4wTgHvkkY9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769649351; c=relaxed/simple;
	bh=jwnKR9cuhHsfDDyjwAVTOJTLz/mxQ0s0U+yG6VaemLA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dhQGUtRGbTfS5kuT+CM+dRI2M+yhOlm02rucEE+911DTz93X9o7CH/Pop2fJFWDSmrT/HDueu/0B2T+fqCLbQIc3Mlt1O402GZT6Whaqt1ECYXa49wO1qJcQZQ5X1n16ky430xJOg7IWMNyVBFCFKyomGxyuFPcje0wreqjghls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sItXTfVk; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-822426d844aso298312b3a.0
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 17:15:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769649348; x=1770254148; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RZIzGBaOGIQvS0LzrR6Lm7I/m6+6T72pqVRnN87itMs=;
        b=sItXTfVkV4RlW9Grht34ebDSwyu+Ozu4fgcXS3dXiP+8HnleHEgPRnzI7SsIP6zU+o
         XM/NLeEIQLjXgLdct/IlOi+YbJLE3/MdNLEvcSLlC/8UlKaeRSbee54hzFkhNxYKQ9ps
         ebmAiMRnOXOZTOv13DUtXuhxmNg+NenGmlsJi0rTdsgpSJbHPoBPEENFrh2j80M86NMb
         Jz+tkjLbiBD2bpanLtlPifub5iVsAKdYHD4JrnrdjIR6BGm5UalpUshSPciA0cRolkFw
         zqaih1M81QAICexHDouqqmw3T3R40TRlEHzuR8/WxMTlZiipSHg6NysoutUZE3zxwzqx
         Lm6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769649348; x=1770254148;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RZIzGBaOGIQvS0LzrR6Lm7I/m6+6T72pqVRnN87itMs=;
        b=HnNHtSqHPe6wS78tr2rj+jIgPI+ntQhlqw9xAgNZBN+YuzP2KcEIwBiryyShngSKgI
         yvAUTdAlNiAhSScQJO2QePOxvZaQfIHgKGIBrjc7w4HALtK7dv0uKQ3RtSOLqsaz+uSB
         GxAsBRy7fe216oN8gVajjjKbe4oCrfRjRpbP4vjG++q4yW5A7TwzehuFmAWJJzKYUnBR
         3zynBmhpip98YJbXPzkUULr3TmQPhcHzCw83LzBPVORIZQhXgP94HbMOoW5tdiHyL1HW
         DQxhiG4XD3OK2rGBiWHdASSTYLqg6y6sPGMD6coqvGIBXc3cGQgFvNMiQJfb6Tx7nodU
         PASA==
X-Forwarded-Encrypted: i=1; AJvYcCU6MAubQXi89Ksjq7bq2bqaNt3pCNpyIU0ZxzF2Mr+zMrbsRYbydlLGeEANaYiOPEvviyY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQhUFRg9y2X2lj6sceJActzdsN/l9qRAreWmAKJNj52Z76vBN+
	Kcq8Nf2qgiUlEx9xTF+rmcstguzhT/QmYdNCSh8bCKrO/eq7PU74tXEbhtDNXDuiJeCt05jHbkj
	MLoZrxQ==
X-Received: from pfbln17.prod.google.com ([2002:a05:6a00:3cd1:b0:823:20e0:dd18])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2451:b0:823:ec5:430c
 with SMTP id d2e1a72fcca58-823921185efmr1036212b3a.29.1769649348476; Wed, 28
 Jan 2026 17:15:48 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 28 Jan 2026 17:14:43 -0800
In-Reply-To: <20260129011517.3545883-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260129011517.3545883-1-seanjc@google.com>
X-Mailer: git-send-email 2.53.0.rc1.217.geba53bf80e-goog
Message-ID: <20260129011517.3545883-12-seanjc@google.com>
Subject: [RFC PATCH v5 11/45] x86/tdx: Add helpers to check return status codes
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	kvm@vger.kernel.org, Kai Huang <kai.huang@intel.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Yan Zhao <yan.y.zhao@intel.com>, 
	Vishal Annapurve <vannapurve@google.com>, Ackerley Tng <ackerleytng@google.com>, 
	Sagi Shahar <sagis@google.com>, Binbin Wu <binbin.wu@linux.intel.com>, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69461-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	HAS_REPLYTO(0.00)[seanjc@google.com];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	REPLYTO_EQ_FROM(0.00)[]
X-Rspamd-Queue-Id: 18C26AA960
X-Rspamd-Action: no action

From: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

The TDX error code has a complex structure. The upper 32 bits encode the
status code (higher level information), while the lower 32 bits provide
clues about the error, such as operand ID, CPUID leaf, MSR index, etc.

In practice, the kernel logic cares mostly about the status code. Whereas
the error details are more often dumped to warnings to be used as
debugging breadcrumbs. This results in a lot of code that masks the status
code and then checks the resulting value. Future code to support Dynamic
PAMT will add yet more SEAMCALL error code checking. To prepare for this,
do some cleanup to reduce the boiler plate error code parsing.

Since the lower bits that contain details are needed for both error
printing and a few cases where the logical code flow does depend on them,
don=E2=80=99t reduce the boiler plate by masking the detail bits inside the
SEAMCALL wrappers, returning only the status code. Instead, create some
helpers to perform the needed masking and comparisons.

For the status code based checks, create a macro for generating the
helpers based on the name. Name the helpers IS_TDX_FOO(), based on the
discussion in the Link.

Many of the checks that consult the error details are only done in a
single place. It could be argued that there is not any code savings by
adding helpers for these checks. Add helpers for them anyway so that the
checks look consistent when uses with checks that are used in multiple
places (e.g. sc_retry_prerr()).

Finally, update the code that previously open coded the bit math to use
the helpers.

Link: https://lore.kernel.org/kvm/aJNycTvk1GEWgK_Q@google.com/
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
[Enhance log]
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Tested-by: Sagi Shahar <sagis@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/coco/tdx/tdx.c                 | 10 +++---
 arch/x86/include/asm/shared/tdx_errno.h | 47 ++++++++++++++++++++++++-
 arch/x86/include/asm/tdx.h              |  2 +-
 arch/x86/kvm/vmx/tdx.c                  | 40 +++++++++------------
 arch/x86/virt/vmx/tdx/tdx.c             |  8 ++---
 5 files changed, 73 insertions(+), 34 deletions(-)

diff --git a/arch/x86/coco/tdx/tdx.c b/arch/x86/coco/tdx/tdx.c
index 7b2833705d47..167c5b273c40 100644
--- a/arch/x86/coco/tdx/tdx.c
+++ b/arch/x86/coco/tdx/tdx.c
@@ -129,9 +129,9 @@ int tdx_mcall_get_report0(u8 *reportdata, u8 *tdreport)
=20
 	ret =3D __tdcall(TDG_MR_REPORT, &args);
 	if (ret) {
-		if (TDCALL_RETURN_CODE(ret) =3D=3D TDCALL_INVALID_OPERAND)
+		if (IS_TDX_OPERAND_INVALID(ret))
 			return -ENXIO;
-		else if (TDCALL_RETURN_CODE(ret) =3D=3D TDCALL_OPERAND_BUSY)
+		else if (IS_TDX_OPERAND_BUSY(ret))
 			return -EBUSY;
 		return -EIO;
 	}
@@ -165,9 +165,9 @@ int tdx_mcall_extend_rtmr(u8 index, u8 *data)
=20
 	ret =3D __tdcall(TDG_MR_RTMR_EXTEND, &args);
 	if (ret) {
-		if (TDCALL_RETURN_CODE(ret) =3D=3D TDCALL_INVALID_OPERAND)
+		if (IS_TDX_OPERAND_INVALID(ret))
 			return -ENXIO;
-		if (TDCALL_RETURN_CODE(ret) =3D=3D TDCALL_OPERAND_BUSY)
+		if (IS_TDX_OPERAND_BUSY(ret))
 			return -EBUSY;
 		return -EIO;
 	}
@@ -316,7 +316,7 @@ static void reduce_unnecessary_ve(void)
 {
 	u64 err =3D tdg_vm_wr(TDCS_TD_CTLS, TD_CTLS_REDUCE_VE, TD_CTLS_REDUCE_VE)=
;
=20
-	if (err =3D=3D TDX_SUCCESS)
+	if (IS_TDX_SUCCESS(err))
 		return;
=20
 	/*
diff --git a/arch/x86/include/asm/shared/tdx_errno.h b/arch/x86/include/asm=
/shared/tdx_errno.h
index 3aa74f6a6119..e302aed31b50 100644
--- a/arch/x86/include/asm/shared/tdx_errno.h
+++ b/arch/x86/include/asm/shared/tdx_errno.h
@@ -5,7 +5,7 @@
 #include <asm/trapnr.h>
=20
 /* Upper 32 bit of the TDX error code encodes the status */
-#define TDX_SEAMCALL_STATUS_MASK		0xFFFFFFFF00000000ULL
+#define TDX_STATUS_MASK				0xFFFFFFFF00000000ULL
=20
 /*
  * TDX SEAMCALL Status Codes
@@ -54,4 +54,49 @@
 #define TDX_OPERAND_ID_SEPT			0x92
 #define TDX_OPERAND_ID_TD_EPOCH			0xa9
=20
+#ifndef __ASSEMBLER__
+#include <linux/bits.h>
+#include <linux/types.h>
+
+static inline u64 TDX_STATUS(u64 err)
+{
+	return err & TDX_STATUS_MASK;
+}
+
+static inline bool IS_TDX_NON_RECOVERABLE(u64 err)
+{
+	return (err & TDX_NON_RECOVERABLE) =3D=3D TDX_NON_RECOVERABLE;
+}
+
+static inline bool IS_TDX_SEAMCALL_VMFAILINVALID(u64 err)
+{
+	return (err & TDX_SEAMCALL_VMFAILINVALID) =3D=3D
+		TDX_SEAMCALL_VMFAILINVALID;
+}
+
+static inline bool IS_TDX_SEAMCALL_GP(u64 err)
+{
+	return err =3D=3D TDX_SEAMCALL_GP;
+}
+
+static inline bool IS_TDX_SEAMCALL_UD(u64 err)
+{
+	return err =3D=3D TDX_SEAMCALL_UD;
+}
+
+#define DEFINE_TDX_ERRNO_HELPER(error)			\
+	static inline bool IS_##error(u64 err)	\
+	{						\
+		return TDX_STATUS(err) =3D=3D error;	\
+	}
+
+DEFINE_TDX_ERRNO_HELPER(TDX_SUCCESS);
+DEFINE_TDX_ERRNO_HELPER(TDX_RND_NO_ENTROPY);
+DEFINE_TDX_ERRNO_HELPER(TDX_OPERAND_INVALID);
+DEFINE_TDX_ERRNO_HELPER(TDX_OPERAND_BUSY);
+DEFINE_TDX_ERRNO_HELPER(TDX_VCPU_NOT_ASSOCIATED);
+DEFINE_TDX_ERRNO_HELPER(TDX_FLUSHVP_NOT_DONE);
+DEFINE_TDX_ERRNO_HELPER(TDX_SW_ERROR);
+
+#endif /* __ASSEMBLER__ */
 #endif /* _X86_SHARED_TDX_ERRNO_H */
diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index c3c574511094..441a26988d3b 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -117,7 +117,7 @@ static __always_inline u64 sc_retry(sc_func_t func, u64=
 fn,
 		preempt_disable();
 		ret =3D __seamcall_dirty_cache(func, fn, args);
 		preempt_enable();
-	} while (ret =3D=3D TDX_RND_NO_ENTROPY && --retry);
+	} while (IS_TDX_RND_NO_ENTROPY(ret) && --retry);
=20
 	return ret;
 }
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 66bc3ceb5e17..4ef414ee27b4 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -220,12 +220,6 @@ static DEFINE_MUTEX(tdx_lock);
=20
 static atomic_t nr_configured_hkid;
=20
-static bool tdx_operand_busy(u64 err)
-{
-	return (err & TDX_SEAMCALL_STATUS_MASK) =3D=3D TDX_OPERAND_BUSY;
-}
-
-
 /*
  * A per-CPU list of TD vCPUs associated with a given CPU.
  * Protected by interrupt mask. Only manipulated by the CPU owning this pe=
r-CPU
@@ -312,7 +306,7 @@ static inline void tdx_disassociate_vp(struct kvm_vcpu =
*vcpu)
 	lockdep_assert_held_write(&kvm->mmu_lock);				\
 										\
 	__err =3D tdh_func(args);							\
-	if (unlikely(tdx_operand_busy(__err))) {				\
+	if (unlikely(IS_TDX_OPERAND_BUSY(__err))) {				\
 		WRITE_ONCE(__kvm_tdx->wait_for_sept_zap, true);			\
 		kvm_make_all_cpus_request(kvm, KVM_REQ_OUTSIDE_GUEST_MODE);	\
 										\
@@ -400,7 +394,7 @@ static void tdx_flush_vp(void *_arg)
 		 * migration.  No other thread uses TDVPR in those cases.
 		 */
 		err =3D tdh_vp_flush(&to_tdx(vcpu)->vp);
-		if (unlikely(err && err !=3D TDX_VCPU_NOT_ASSOCIATED)) {
+		if (unlikely(!IS_TDX_VCPU_NOT_ASSOCIATED(err))) {
 			/*
 			 * This function is called in IPI context. Do not use
 			 * printk to avoid console semaphore.
@@ -467,7 +461,7 @@ static void smp_func_do_phymem_cache_wb(void *unused)
 	/*
 	 * TDH.PHYMEM.CACHE.WB flushes caches associated with any TDX private
 	 * KeyID on the package or core.  The TDX module may not finish the
-	 * cache flush but return TDX_INTERRUPTED_RESUMEABLE instead.  The
+	 * cache flush but return TDX_ERR_INTERRUPTED_RESUMEABLE instead.  The
 	 * kernel should retry it until it returns success w/o rescheduling.
 	 */
 	for (i =3D TDX_SEAMCALL_RETRIES; i > 0; i--) {
@@ -522,7 +516,7 @@ void tdx_mmu_release_hkid(struct kvm *kvm)
 	 * associations, as all vCPU fds have been released at this stage.
 	 */
 	err =3D tdh_mng_vpflushdone(&kvm_tdx->td);
-	if (err =3D=3D TDX_FLUSHVP_NOT_DONE)
+	if (IS_TDX_FLUSHVP_NOT_DONE(err))
 		goto out;
 	if (TDX_BUG_ON(err, TDH_MNG_VPFLUSHDONE, kvm)) {
 		pr_err("tdh_mng_vpflushdone() failed. HKID %d is leaked.\n",
@@ -937,7 +931,7 @@ static __always_inline u32 tdx_to_vmx_exit_reason(struc=
t kvm_vcpu *vcpu)
 	struct vcpu_tdx *tdx =3D to_tdx(vcpu);
 	u32 exit_reason;
=20
-	switch (tdx->vp_enter_ret & TDX_SEAMCALL_STATUS_MASK) {
+	switch (TDX_STATUS(tdx->vp_enter_ret)) {
 	case TDX_SUCCESS:
 	case TDX_NON_RECOVERABLE_VCPU:
 	case TDX_NON_RECOVERABLE_TD:
@@ -1011,7 +1005,7 @@ static fastpath_t tdx_exit_handlers_fastpath(struct k=
vm_vcpu *vcpu)
 	 * EXIT_FASTPATH_REENTER_GUEST to exit fastpath, otherwise, the
 	 * requester may be blocked endlessly.
 	 */
-	if (unlikely(tdx_operand_busy(vp_enter_ret)))
+	if (unlikely(IS_TDX_OPERAND_BUSY(vp_enter_ret)))
 		return EXIT_FASTPATH_EXIT_HANDLED;
=20
 	return EXIT_FASTPATH_NONE;
@@ -1107,7 +1101,7 @@ fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, u64 ru=
n_flags)
 	if (unlikely(tdx->vp_enter_ret =3D=3D EXIT_REASON_EPT_MISCONFIG))
 		return EXIT_FASTPATH_NONE;
=20
-	if (unlikely((tdx->vp_enter_ret & TDX_SW_ERROR) =3D=3D TDX_SW_ERROR))
+	if (unlikely(IS_TDX_SW_ERROR(tdx->vp_enter_ret)))
 		return EXIT_FASTPATH_NONE;
=20
 	trace_kvm_exit(vcpu, KVM_ISA_VMX);
@@ -1636,7 +1630,7 @@ static int tdx_mem_page_add(struct kvm *kvm, gfn_t gf=
n, enum pg_level level,
=20
 	err =3D tdh_mem_page_add(&kvm_tdx->td, gpa, pfn_to_page(pfn),
 			       kvm_tdx->page_add_src, &entry, &level_state);
-	if (unlikely(tdx_operand_busy(err)))
+	if (unlikely(IS_TDX_OPERAND_BUSY(err)))
 		return -EBUSY;
=20
 	if (TDX_BUG_ON_2(err, TDH_MEM_PAGE_ADD, entry, level_state, kvm))
@@ -1655,7 +1649,7 @@ static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gf=
n,
 	u64 err;
=20
 	err =3D tdh_mem_page_aug(&kvm_tdx->td, gpa, level, page, &entry, &level_s=
tate);
-	if (unlikely(tdx_operand_busy(err)))
+	if (unlikely(IS_TDX_OPERAND_BUSY(err)))
 		return -EBUSY;
=20
 	if (TDX_BUG_ON_2(err, TDH_MEM_PAGE_AUG, entry, level_state, kvm))
@@ -1690,7 +1684,7 @@ static int tdx_sept_link_private_spt(struct kvm *kvm,=
 gfn_t gfn,
=20
 	err =3D tdh_mem_sept_add(&to_kvm_tdx(kvm)->td, gpa, level, external_spt,
 			       &entry, &level_state);
-	if (unlikely(tdx_operand_busy(err)))
+	if (unlikely(IS_TDX_OPERAND_BUSY(err)))
 		return -EBUSY;
=20
 	if (TDX_BUG_ON_2(err, TDH_MEM_SEPT_ADD, entry, level_state, kvm))
@@ -2011,7 +2005,7 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t=
 fastpath)
 	 * Handle TDX SW errors, including TDX_SEAMCALL_UD, TDX_SEAMCALL_GP and
 	 * TDX_SEAMCALL_VMFAILINVALID.
 	 */
-	if (unlikely((vp_enter_ret & TDX_SW_ERROR) =3D=3D TDX_SW_ERROR)) {
+	if (unlikely(IS_TDX_SW_ERROR(vp_enter_ret))) {
 		KVM_BUG_ON(!kvm_rebooting, vcpu->kvm);
 		goto unhandled_exit;
 	}
@@ -2022,7 +2016,7 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t=
 fastpath)
 		 * not enabled, TDX_NON_RECOVERABLE must be set.
 		 */
 		WARN_ON_ONCE(vcpu->arch.guest_state_protected &&
-				!(vp_enter_ret & TDX_NON_RECOVERABLE));
+			     !IS_TDX_NON_RECOVERABLE(vp_enter_ret));
 		vcpu->run->exit_reason =3D KVM_EXIT_FAIL_ENTRY;
 		vcpu->run->fail_entry.hardware_entry_failure_reason =3D exit_reason.full=
;
 		vcpu->run->fail_entry.cpu =3D vcpu->arch.last_vmentry_cpu;
@@ -2036,7 +2030,7 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t=
 fastpath)
 	}
=20
 	WARN_ON_ONCE(exit_reason.basic !=3D EXIT_REASON_TRIPLE_FAULT &&
-		     (vp_enter_ret & TDX_SEAMCALL_STATUS_MASK) !=3D TDX_SUCCESS);
+		     !IS_TDX_SUCCESS(vp_enter_ret));
=20
 	switch (exit_reason.basic) {
 	case EXIT_REASON_TRIPLE_FAULT:
@@ -2470,7 +2464,7 @@ static int __tdx_td_init(struct kvm *kvm, struct td_p=
arams *td_params,
 	err =3D tdh_mng_create(&kvm_tdx->td, kvm_tdx->hkid);
 	mutex_unlock(&tdx_lock);
=20
-	if (err =3D=3D TDX_RND_NO_ENTROPY) {
+	if (IS_TDX_RND_NO_ENTROPY(err)) {
 		ret =3D -EAGAIN;
 		goto free_packages;
 	}
@@ -2511,7 +2505,7 @@ static int __tdx_td_init(struct kvm *kvm, struct td_p=
arams *td_params,
 	kvm_tdx->td.tdcs_pages =3D tdcs_pages;
 	for (i =3D 0; i < kvm_tdx->td.tdcs_nr_pages; i++) {
 		err =3D tdh_mng_addcx(&kvm_tdx->td, tdcs_pages[i]);
-		if (err =3D=3D TDX_RND_NO_ENTROPY) {
+		if (IS_TDX_RND_NO_ENTROPY(err)) {
 			/* Here it's hard to allow userspace to retry. */
 			ret =3D -EAGAIN;
 			goto teardown;
@@ -2523,7 +2517,7 @@ static int __tdx_td_init(struct kvm *kvm, struct td_p=
arams *td_params,
 	}
=20
 	err =3D tdh_mng_init(&kvm_tdx->td, __pa(td_params), &rcx);
-	if ((err & TDX_SEAMCALL_STATUS_MASK) =3D=3D TDX_OPERAND_INVALID) {
+	if (IS_TDX_OPERAND_INVALID(err)) {
 		/*
 		 * Because a user gives operands, don't warn.
 		 * Return a hint to the user because it's sometimes hard for the
@@ -2837,7 +2831,7 @@ static int tdx_td_finalize(struct kvm *kvm, struct kv=
m_tdx_cmd *cmd)
 		return -EINVAL;
=20
 	cmd->hw_error =3D tdh_mr_finalize(&kvm_tdx->td);
-	if (tdx_operand_busy(cmd->hw_error))
+	if (IS_TDX_OPERAND_BUSY(cmd->hw_error))
 		return -EBUSY;
 	if (TDX_BUG_ON(cmd->hw_error, TDH_MR_FINALIZE, kvm))
 		return -EIO;
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 22c0f832cb37..783bf704f2cd 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -82,16 +82,16 @@ static __always_inline int sc_retry_prerr(sc_func_t fun=
c,
 {
 	u64 sret =3D sc_retry(func, fn, args);
=20
-	if (sret =3D=3D TDX_SUCCESS)
+	if (IS_TDX_SUCCESS(sret))
 		return 0;
=20
-	if (sret =3D=3D TDX_SEAMCALL_VMFAILINVALID)
+	if (IS_TDX_SEAMCALL_VMFAILINVALID(sret))
 		return -ENODEV;
=20
-	if (sret =3D=3D TDX_SEAMCALL_GP)
+	if (IS_TDX_SEAMCALL_GP(sret))
 		return -EOPNOTSUPP;
=20
-	if (sret =3D=3D TDX_SEAMCALL_UD)
+	if (IS_TDX_SEAMCALL_UD(sret))
 		return -EACCES;
=20
 	err_func(fn, sret, args);
--=20
2.53.0.rc1.217.geba53bf80e-goog


