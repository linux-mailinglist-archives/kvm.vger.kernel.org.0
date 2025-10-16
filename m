Return-Path: <kvm+bounces-60213-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A3950BE50A9
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 20:22:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 23929581867
	for <lists+kvm@lfdr.de>; Thu, 16 Oct 2025 18:22:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F5052376F8;
	Thu, 16 Oct 2025 18:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UZQb3I8E"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0567022D4FF
	for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 18:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760638915; cv=none; b=bB+c+tGWtetsNSTMbUSaNVb6Wg04BQQX0oRs3Zy8ABQrI4Y5WS/iT30pPAC5VoUulb1a+iyFeyV75etX9SjS2ZF7vpIfMC1hrUJBnVcpO+h7rYvQIMQszDJPd0A9pCePjJ1bw1JEF4t7j6j3c5ctYjPL0gt6AYX1U3ohwP+5Fto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760638915; c=relaxed/simple;
	bh=uYpnbJuBmHSp7QJ67gj6MDeGEIKA9TFc51JDajZhu6A=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GTtrpvFKHV1TBIilmw3eyZA/CkvxRYe6ZQhnIhj/KJDS9PveNKDCh47DpyOnJCAFNacwpv5u5ddLlB9347mbgP4/J6JgGqP7+kCfABRSVzH8s7Y1+EUWcO1YzKPTywIncJYRIONdgoO9cc3ZYTObjfJpjmZIuYpxC7CZOB4Jqng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UZQb3I8E; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-339d5dbf58aso2443798a91.3
        for <kvm@vger.kernel.org>; Thu, 16 Oct 2025 11:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760638913; x=1761243713; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uUBwpQ9GQMbT81tR22zlfiB5L6CG6pQMTQyHLevdWto=;
        b=UZQb3I8EZ0L7yYNFFrelHNakazAUNrFjJ/1cGzSBtwG/oEjCpe7Iny7OVWz6bUaV+K
         3s/I23yJclWrdCRBabSusZF83oe3uJcZL20XSOYbrb67lQ0uRv3i1KCr2PPXEAMaugCc
         ngA07SSsOKHWsg9B99j/EpNHiii4Kn32WOTknzVaYTiOJ1rh64JY6TM/ap5nbj/IqYxr
         mZm21HaZCf8GT2HPRMy2Ygw8NQ2U5lmx+PCra90Iv9zcnObWFitGIRa5kAJpnhnBVBfc
         AkN9NPZhCvBZpBTljGRU2BoUKHL790HNOoqScrAgQWaVLYrFkVyfL8jR3ysA++vUnJgG
         og2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760638913; x=1761243713;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uUBwpQ9GQMbT81tR22zlfiB5L6CG6pQMTQyHLevdWto=;
        b=joBNoBDMEAML+6LFAn15GVtpnKl0UF0duJJunypsIpGE7X3K/EhGvWlf4cM4eUywns
         FeygNtvV/EvK6ncHQWlzEO7+WGCZ/6demIU3P9BBa1y8j7Sg7JRMigpLLhuPkvYoye6I
         vKPDh9AP8W3vuQUqCvTiK3+vS+yUis5zVgLC8lZwEcn/skt1QkFppgkhm36yrS8jUkOk
         ZPYKCb/8E6b5z+pjBSviB6b9i/hgL9oVdHRsLL+r6gH3tagpCOza7mZ2OZ9byTGIn/z2
         ww5+8CtLWpTNfk+WbxcHkxtBqmopalZmsQCSXy16dSsd+nA3iiz3raBYywsHRev+6gJT
         bOjw==
X-Gm-Message-State: AOJu0YyMTllbJ+9oKoi2LHQ73ecY4sg5Xjnf29W7sV9HTwPROC2gkLj8
	vGX/uKQMM3w65cqvhATUtQ2AXHDNNmlyAQcPOJUEEVtzM1YZ+CLvJA9DSwOEjv6mDUW23wp4vMD
	yAxtSSQ==
X-Google-Smtp-Source: AGHT+IGSCjzZCxLWWkxcWEdeWtPzVEdqwdS/VUOG+4Qi5BAqC1CvaJ2LaI2Tpxep8OdHj+RLQ9Y0bjdQcX4=
X-Received: from pjbsp13.prod.google.com ([2002:a17:90b:52cd:b0:332:8389:c569])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3848:b0:339:a243:e96d
 with SMTP id 98e67ed59e1d1-33bcf940649mr737873a91.36.1760638913246; Thu, 16
 Oct 2025 11:21:53 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu, 16 Oct 2025 11:21:47 -0700
In-Reply-To: <20251016182148.69085-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251016182148.69085-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251016182148.69085-2-seanjc@google.com>
Subject: [PATCH v2 1/2] KVM: VMX: Inject #UD if guest tries to execute
 SEAMCALL or TDCALL
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Dan Williams <dan.j.williams@intel.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Add VMX exit handlers for SEAMCALL and TDCALL to inject a #UD if a non-TD
guest attempts to execute SEAMCALL or TDCALL.  Neither SEAMCALL nor TDCALL
is gated by any software enablement other than VMXON, and so will generate
a VM-Exit instead of e.g. a native #UD when executed from the guest kernel.

Note!  No unprivileged DoS of the L1 kernel is possible as TDCALL and
SEAMCALL #GP at CPL > 0, and the CPL check is performed prior to the VMX
non-root (VM-Exit) check, i.e. userspace can't crash the VM. And for a
nested guest, KVM forwards unknown exits to L1, i.e. an L2 kernel can
crash itself, but not L1.

Note #2!  The Intel=C2=AE Trust Domain CPU Architectural Extensions spec's
pseudocode shows the CPL > 0 check for SEAMCALL coming _after_ the VM-Exit,
but that appears to be a documentation bug (likely because the CPL > 0
check was incorrectly bundled with other lower-priority #GP checks).
Testing on SPR and EMR shows that the CPL > 0 check is performed before
the VMX non-root check, i.e. SEAMCALL #GPs when executed in usermode.

Note #3!  The aforementioned Trust Domain spec uses confusing pseudocode
that says that SEAMCALL will #UD if executed "inSEAM", but "inSEAM"
specifically means in SEAM Root Mode, i.e. in the TDX-Module.  The long-
form description explicitly states that SEAMCALL generates an exit when
executed in "SEAM VMX non-root operation".  But that's a moot point as the
TDX-Module injects #UD if the guest attempts to execute SEAMCALL, as
documented in the "Unconditionally Blocked Instructions" section of the
TDX-Module base specification.

Cc: stable@vger.kernel.org
Cc: Kai Huang <kai.huang@intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/uapi/asm/vmx.h | 1 +
 arch/x86/kvm/vmx/nested.c       | 8 ++++++++
 arch/x86/kvm/vmx/vmx.c          | 8 ++++++++
 3 files changed, 17 insertions(+)

diff --git a/arch/x86/include/uapi/asm/vmx.h b/arch/x86/include/uapi/asm/vm=
x.h
index 9792e329343e..1baa86dfe029 100644
--- a/arch/x86/include/uapi/asm/vmx.h
+++ b/arch/x86/include/uapi/asm/vmx.h
@@ -93,6 +93,7 @@
 #define EXIT_REASON_TPAUSE              68
 #define EXIT_REASON_BUS_LOCK            74
 #define EXIT_REASON_NOTIFY              75
+#define EXIT_REASON_SEAMCALL            76
 #define EXIT_REASON_TDCALL              77
 #define EXIT_REASON_MSR_READ_IMM        84
 #define EXIT_REASON_MSR_WRITE_IMM       85
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 76271962cb70..bcea087b642f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6728,6 +6728,14 @@ static bool nested_vmx_l1_wants_exit(struct kvm_vcpu=
 *vcpu,
 	case EXIT_REASON_NOTIFY:
 		/* Notify VM exit is not exposed to L1 */
 		return false;
+	case EXIT_REASON_SEAMCALL:
+	case EXIT_REASON_TDCALL:
+		/*
+		 * SEAMCALL and TDCALL unconditionally VM-Exit, but aren't
+		 * virtualized by KVM for L1 hypervisors, i.e. L1 should
+		 * never want or expect such an exit.
+		 */
+		return false;
 	default:
 		return true;
 	}
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 546272a5d34d..d1b34b7ca4a3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6033,6 +6033,12 @@ static int handle_vmx_instruction(struct kvm_vcpu *v=
cpu)
 	return 1;
 }
=20
+static int handle_tdx_instruction(struct kvm_vcpu *vcpu)
+{
+	kvm_queue_exception(vcpu, UD_VECTOR);
+	return 1;
+}
+
 #ifndef CONFIG_X86_SGX_KVM
 static int handle_encls(struct kvm_vcpu *vcpu)
 {
@@ -6158,6 +6164,8 @@ static int (*kvm_vmx_exit_handlers[])(struct kvm_vcpu=
 *vcpu) =3D {
 	[EXIT_REASON_ENCLS]		      =3D handle_encls,
 	[EXIT_REASON_BUS_LOCK]                =3D handle_bus_lock_vmexit,
 	[EXIT_REASON_NOTIFY]		      =3D handle_notify,
+	[EXIT_REASON_SEAMCALL]		      =3D handle_tdx_instruction,
+	[EXIT_REASON_TDCALL]		      =3D handle_tdx_instruction,
 	[EXIT_REASON_MSR_READ_IMM]            =3D handle_rdmsr_imm,
 	[EXIT_REASON_MSR_WRITE_IMM]           =3D handle_wrmsr_imm,
 };
--=20
2.51.0.858.gf9c4a03a3a-goog


