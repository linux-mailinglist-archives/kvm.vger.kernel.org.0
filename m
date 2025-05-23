Return-Path: <kvm+bounces-47579-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BE67AC220B
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 13:37:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C77D3A22ED
	for <lists+kvm@lfdr.de>; Fri, 23 May 2025 11:36:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8C39238C07;
	Fri, 23 May 2025 11:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="Xrh4wYB9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13082356B2
	for <kvm@vger.kernel.org>; Fri, 23 May 2025 11:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748000175; cv=none; b=kQ4pLKD25aSSUlVK0GatcaWScNucpqOfQWpTgZqHYLH5BGbzt7cqhd2CLxCM9dyczMRCD0Lzz3H5f6Xm+ZBKv2RYD8YcahuLZhFWHC0D5Aaa7g9n4hsvBlwRjPmeacR8mUxGxtiT7AkgoAbTpT7I5Hxxgt64MuO5kaVeUqHaQPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748000175; c=relaxed/simple;
	bh=5osHyV21by3EPnFM/B87KOZI5Ors1zitCYB5PcM/luk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=HBWkt/jMa+u0f4uxs/y4qzsnXqjgLxjuSb9eyDhwbXP0LjOV/5pAsFXTz+J1xD9K4OFbgBqfm0NbXsjXmiYjRt2d4mRSfLlWpU44Q0nrx1MG5TqTuIAurYS6wH5LiKByqo2MlsfQt4x14dM1Nd4kGJRdh8wTxy2jaQafoktUQws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=Xrh4wYB9; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3a4c2e42ce0so66825f8f.3
        for <kvm@vger.kernel.org>; Fri, 23 May 2025 04:36:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1748000172; x=1748604972; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=VPjovNDjW6+EQ4LMpESmH+B/L0gygzy/uxelrXjYBg8=;
        b=Xrh4wYB9eJtr9DWwSS4xd5adpaYq9zmg89Jhn8G/8wD1IH468nKEPdS+etZcsfXube
         CvoErKsdwtLpjrzTrhX0r72c5Qv1bzFEsQ0Fm4+1RvqGY/I/SEwR2fI+wv8bFMRLKH+6
         9XaxCBAqy021IVcUcOfLF97C3N+bhWhHqmWJ+PB2Wq7qbIr5lSlbHopi4lSSDce4vwQS
         yk2AD7eKljt3EjfUCUNgt8HyXlgQ/GNisg8jf/aPGTw45BZ8nfPmcBVqLU0eJ+wADcF4
         QhsLH2EplMFIvPVvsos9PApgWFsZtfr1p1+n9UpDSMiQaPn9yWuezyHuH1ir+ip+xGJL
         y4lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748000172; x=1748604972;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VPjovNDjW6+EQ4LMpESmH+B/L0gygzy/uxelrXjYBg8=;
        b=rSuKST3nJ0XVQWN1oUsPoGXP5qOdj3v0LYM4nV1OYZu4Eo9HD0uwAscr5u0jbzEvHd
         3tSIQa92L3BXqtfMXIRfoFJroH9wzcT4Mk56gwt/thvoXKEstl6340j7aCFp7Q08KmWQ
         3cDkWZGjgz7Mi1eRPZHae156jpu2TNMCuyzTl3UPdBiE2wG22LaBXdS4yzXOTe1ebqte
         beDXDGMXfbFxJ3ZKdAZpcINxLfxl7IgXYuvo02Oth58LADpg1aJDE3ZgcqjCgHPD/8nY
         6zVfEa/W+nmQ3xkg1piHbVM+RzItnSkSv1AUcFkwqmWh80sLSkFcdWZRMF/IR9HHtumT
         7TNQ==
X-Gm-Message-State: AOJu0YzeGs3u/WnOR+Vab3W+c9793GKpIGQxLR5Kk6EOGbhqi4O+0cNW
	OYcjHN9wgAAFl+GivqKQuoY217ZSftb6kaiSEKjxyjh0YqhfNWRWPg6iLhn3o0AIxDM=
X-Gm-Gg: ASbGnctpeEsAKY8gC3jv7PpRGoayQwXD8rai5GL4k5XKRbAvmD9CI1df7cJj0JQOYwo
	Ryoybm2jHtPNj5kMW9jZqCRVsLzf15l1z7rKBtJHR2wG8WgVVEgzsXcvo3fO1+/xjEQSnZWRXqL
	OzEdw2i6wUqFacPJoR+2Dvcki/r52K2BR6qr6N3O1x/x6OLKb/Xt7+l4eEw9yatt9cBYtBfeSFe
	a5RH1JmI36cC9j6uIc25E5E/ee72yQqqpWkaVGqwH+1cvdXMcCPLnHtf4NL6w8pJSgos9yL8WeF
	4VSSctcAFReRd91QlUxhML2U9AA9jgSszgVPOeIhlJyiKkycgSWeETbG6p0=
X-Google-Smtp-Source: AGHT+IF2ZQShD6Bzg9HopdSxCvsBVk+Vm5DBLVCqW0pMilB6flZ85+PDQSUHNACKnOikFlZ7WJIovg==
X-Received: by 2002:a05:6000:188f:b0:3a3:71fb:7903 with SMTP id ffacd0b85a97d-3a371fb829emr6202649f8f.10.1748000171649;
        Fri, 23 May 2025 04:36:11 -0700 (PDT)
Received: from localhost ([2a02:8308:a00c:e200:be84:d9ad:e5e6:f60b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-447f3814262sm136898265e9.25.2025.05.23.04.36.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 May 2025 04:36:11 -0700 (PDT)
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>
To: kvm-riscv@lists.infradead.org
Cc: kvm@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andrew Jones <ajones@ventanamicro.com>
Subject: [PATCH v4] RISC-V: KVM: add KVM_CAP_RISCV_USERSPACE_SBI
Date: Fri, 23 May 2025 13:33:49 +0200
Message-ID: <20250523113347.2898042-3-rkrcmar@ventanamicro.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The new capability allows userspace to implement SBI extensions that KVM
does not handle.  This allows userspace to implement any SBI ecall as
userspace already has the ability to disable acceleration of selected
SBI extensions.
The base extension is made controllable as well, but only with the new
capability, because it was previously handled specially for some reason.
*** The related compatibility TODO in the code needs addressing. ***

This is a VM capability, because userspace will most likely want to have
the same behavior for all VCPUs.  We can easily make it both a VCPU and
a VM capability if there is demand in the future.

Signed-off-by: Radim Krčmář <rkrcmar@ventanamicro.com>
---
v4:
* forward base extension as well
* change the id to 242, because 241 is already taken in linux-next
* QEMU example: https://github.com/radimkrcmar/qemu/tree/mp_state_reset
v3: new
---
 Documentation/virt/kvm/api.rst    | 11 +++++++++++
 arch/riscv/include/asm/kvm_host.h |  3 +++
 arch/riscv/include/uapi/asm/kvm.h |  1 +
 arch/riscv/kvm/vcpu_sbi.c         | 17 ++++++++++++++---
 arch/riscv/kvm/vm.c               |  5 +++++
 include/uapi/linux/kvm.h          |  1 +
 6 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index e107694fb41f..c9d627d13a5e 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8507,6 +8507,17 @@ given VM.
 When this capability is enabled, KVM resets the VCPU when setting
 MP_STATE_INIT_RECEIVED through IOCTL.  The original MP_STATE is preserved.
 
+7.44 KVM_CAP_RISCV_USERSPACE_SBI
+--------------------------------
+
+:Architectures: riscv
+:Type: VM
+:Parameters: None
+:Returns: 0 on success, -EINVAL if arg[0] is not zero
+
+When this capability is enabled, KVM forwards ecalls from disabled or unknown
+SBI extensions to userspace.
+
 8. Other capabilities.
 ======================
 
diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 85cfebc32e4c..6f17cd923889 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -122,6 +122,9 @@ struct kvm_arch {
 
 	/* KVM_CAP_RISCV_MP_STATE_RESET */
 	bool mp_state_reset;
+
+	/* KVM_CAP_RISCV_USERSPACE_SBI */
+	bool userspace_sbi;
 };
 
 struct kvm_cpu_trap {
diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index 5f59fd226cc5..dd3a5dc53d34 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -204,6 +204,7 @@ enum KVM_RISCV_SBI_EXT_ID {
 	KVM_RISCV_SBI_EXT_DBCN,
 	KVM_RISCV_SBI_EXT_STA,
 	KVM_RISCV_SBI_EXT_SUSP,
+	KVM_RISCV_SBI_EXT_BASE,
 	KVM_RISCV_SBI_EXT_MAX,
 };
 
diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index 31fd3cc98d66..497d5b023153 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -39,7 +39,7 @@ static const struct kvm_riscv_sbi_extension_entry sbi_ext[] = {
 		.ext_ptr = &vcpu_sbi_ext_v01,
 	},
 	{
-		.ext_idx = KVM_RISCV_SBI_EXT_MAX, /* Can't be disabled */
+		.ext_idx = KVM_RISCV_SBI_EXT_BASE,
 		.ext_ptr = &vcpu_sbi_ext_base,
 	},
 	{
@@ -217,6 +217,11 @@ static int riscv_vcpu_set_sbi_ext_single(struct kvm_vcpu *vcpu,
 	if (!sext || scontext->ext_status[sext->ext_idx] == KVM_RISCV_SBI_EXT_STATUS_UNAVAILABLE)
 		return -ENOENT;
 
+	// TODO: probably remove, the extension originally couldn't be
+	// disabled, but it doesn't seem necessary
+	if (!vcpu->kvm->arch.userspace_sbi && sext->ext_id == KVM_RISCV_SBI_EXT_BASE)
+		return -ENOENT;
+
 	scontext->ext_status[sext->ext_idx] = (reg_val) ?
 			KVM_RISCV_SBI_EXT_STATUS_ENABLED :
 			KVM_RISCV_SBI_EXT_STATUS_DISABLED;
@@ -471,8 +476,14 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
 #endif
 		ret = sbi_ext->handler(vcpu, run, &sbi_ret);
 	} else {
-		/* Return error for unsupported SBI calls */
-		cp->a0 = SBI_ERR_NOT_SUPPORTED;
+		if (vcpu->kvm->arch.userspace_sbi) {
+			next_sepc = false;
+			ret = 0;
+			kvm_riscv_vcpu_sbi_forward(vcpu, run);
+		} else {
+			/* Return error for unsupported SBI calls */
+			cp->a0 = SBI_ERR_NOT_SUPPORTED;
+		}
 		goto ecall_done;
 	}
 
diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
index b27ec8f96697..0b6378b83955 100644
--- a/arch/riscv/kvm/vm.c
+++ b/arch/riscv/kvm/vm.c
@@ -217,6 +217,11 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
 			return -EINVAL;
 		kvm->arch.mp_state_reset = true;
 		return 0;
+	case KVM_CAP_RISCV_USERSPACE_SBI:
+		if (cap->flags)
+			return -EINVAL;
+		kvm->arch.userspace_sbi = true;
+		return 0;
 	default:
 		return -EINVAL;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 454b7d4a0448..bf23deb6679e 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -931,6 +931,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_X86_GUEST_MODE 238
 #define KVM_CAP_ARM_WRITABLE_IMP_ID_REGS 239
 #define KVM_CAP_RISCV_MP_STATE_RESET 240
+#define KVM_CAP_RISCV_USERSPACE_SBI 242
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
-- 
2.49.0


