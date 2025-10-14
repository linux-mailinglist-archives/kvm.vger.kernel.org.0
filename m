Return-Path: <kvm+bounces-60044-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B7978BDBB9E
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 01:11:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id EE1474EC016
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 23:10:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77BCA2E0B74;
	Tue, 14 Oct 2025 23:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XS2fOYUf"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145802C1599
	for <kvm@vger.kernel.org>; Tue, 14 Oct 2025 23:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760483447; cv=none; b=hl1s04fiW54uTfw0SkPpWW9joxcAZVYlss7dJrn2f7DXbuqChfCmpj7VUU+QN7UBSB75rvP6HixIIHFiZJqjr6nUON91nMzWANIVZ59MXIZkQgtNjgSXzwHKdkvIxHzLVxAYe2qxs6LmHZUcCZLbK6ks2rk5pR967vsiKRhxFnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760483447; c=relaxed/simple;
	bh=VmNnAQhGgs9/uF3C65hkP1+an2UA+tXJAocLIm5KRmE=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=UH+0Tl/LzAbkhihaH43HHQi4FgitgvUfLAzhNNbcrcPhBXB+yiYaR4WOIF2B/UA947TbSXnx7CtN0EeHv23vYjWZzu8vs/Sm7fLqybsy/xoFsT+ooyx8up+0uCyH8itc6ZA56HJPfmCjk8DSCBB8xJ75bAeoGOV/Qhg0ulF99kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XS2fOYUf; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3307af9b55eso9147723a91.2
        for <kvm@vger.kernel.org>; Tue, 14 Oct 2025 16:10:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760483445; x=1761088245; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:reply-to:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Cack2dhxyf/zhiOzirzdf+5oJRildZDVoGUbS9moZIs=;
        b=XS2fOYUfk51TgPrNBgDnceYUJnMUEJLl7cWrrjiG/I8UkKwm/smAl5D5lBCx9sb0Aw
         hFeX6HZDqbHfJqM3495NTfRjc4tVd4MLDGAIS/iGpzgt3P+QSAb7sGoDfiPTmCNYVctt
         roH9IUeubVZKqBTAT05yH1gMsFtd2WnT1U+tQNtd+8gfDiJVygXiZgaDGanBosM8DJu9
         lEQdVWiQcLxKouA91mXU9ai933gdEfoYrKv7mr040JaaIai9UarH5CU/wlHRHN2z41ZV
         nZJd65vOvbxrDyIPFF7zcmLQHi2mxOwoM5dvxVkKchO5eEn5Pc5tZAMUP+ZStZw0ckOI
         C0Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760483445; x=1761088245;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:reply-to:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Cack2dhxyf/zhiOzirzdf+5oJRildZDVoGUbS9moZIs=;
        b=t+ciQx07qQPL56wh1L70CHy5NpzK+g9Tygghu/DAUhcfyDRgRIdaMExOmKrcygQBsR
         NpoZMO5DakZSkGXLjJMtIjPxbpiGkzix3gRktTZpQ1B5loXS5mDFi/RjnfI93NHZYNF6
         uWGRMrF+wGOSTUPOyCcPv5LybmVpIHqLk0PeeVfqzoaZChSvnO6N42DmllYNqTx8AFeP
         1sxREwNSupQEup+hCCKiDdgyBy0LfIop5nk5JrxkH6f87kiX4lxggPjbzazCKgQj5mrk
         O3BJNE2A9tJqdARsw5eVtO7/RoczuTLgn1RvHGBKIv0Dzez0EUAltmWKdj1xPB3qJr0B
         iTVQ==
X-Gm-Message-State: AOJu0YwmJ0NbvDpGE71a71+ltfA3qVYBGh9fp3Vj24ZVK83K7Oyu3t01
	zfIHxAuP57GH7gRyZdWTu2/ifFBsrrkovy300GaOP8xBntTFHWbLvEtAsPef1FwTbRxAIFusnt8
	6Hf9bvg==
X-Google-Smtp-Source: AGHT+IElxkSTvmF/luuohnJ0KSryNYvrS0+9ZbjPJHn7oKx3M4MnEXpmR9L9s6yrQb7rQTbfhtC+vCVwgAI=
X-Received: from pjbst8.prod.google.com ([2002:a17:90b:1fc8:b0:330:523b:2b23])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:38cc:b0:32e:f1c:e778
 with SMTP id 98e67ed59e1d1-33b51105f5dmr35482130a91.3.1760483445375; Tue, 14
 Oct 2025 16:10:45 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 14 Oct 2025 16:10:42 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.788.g6d19910ace-goog
Message-ID: <20251014231042.1399849-1-seanjc@google.com>
Subject: [PATCH] KVM: VMX: Inject #UD if guest tries to execute SEAMCALL or TDCALL
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kai Huang <kai.huang@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Add VMX exit handlers for SEAMCALL and TDCALL, and a SEAMCALL handler for
TDX, to inject a #UD if a non-TD guest attempts to execute SEAMCALL or
TDCALL, or if a TD guest attempst to execute SEAMCALL.  Neither SEAMCALL
nor TDCALL is gated by any software enablement other than VMXON, and so
will generate a VM-Exit instead of e.g. a native #UD when executed from
the guest kernel.

Note!  No unprivilege DoS of the L1 kernel is possible as TDCALL and
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

Note #3!  The aforementioned Trust Domain spec uses confusing pseudocde
that says that SEAMCALL will #UD if executed "inSEAM", but "inSEAM"
specifically means in SEAM Root Mode, i.e. in the TDX-Module.  The long-
form description explicitly states that SEAMCALL generates an exit when
executed in "SEAM VMX non-root operation".

Cc: stable@vger.kernel.org
Cc: Kai Huang <kai.huang@intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/uapi/asm/vmx.h | 1 +
 arch/x86/kvm/vmx/nested.c       | 8 ++++++++
 arch/x86/kvm/vmx/tdx.c          | 3 +++
 arch/x86/kvm/vmx/vmx.c          | 8 ++++++++
 4 files changed, 20 insertions(+)

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
index 76271962cb70..f64a1eb241b6 100644
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
+		return true;
 	default:
 		return true;
 	}
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 097304bf1e1d..7326c68f9909 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2127,6 +2127,9 @@ int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t=
 fastpath)
 		return tdx_emulate_mmio(vcpu);
 	case EXIT_REASON_EPT_VIOLATION:
 		return tdx_handle_ept_violation(vcpu);
+	case EXIT_REASON_SEAMCALL:
+		kvm_queue_exception(vcpu, UD_VECTOR);
+		return 1;
 	case EXIT_REASON_OTHER_SMI:
 		/*
 		 * Unlike VMX, SMI in SEAM non-root mode (i.e. when
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

base-commit: 6b36119b94d0b2bb8cea9d512017efafd461d6ac
--=20
2.51.0.788.g6d19910ace-goog


