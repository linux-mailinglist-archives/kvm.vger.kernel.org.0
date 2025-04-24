Return-Path: <kvm+bounces-44190-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F71CA9B263
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 17:33:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 878F69A2578
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 15:32:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38BAC27B51C;
	Thu, 24 Apr 2025 15:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="ND1wILcE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f195.google.com (mail-pf1-f195.google.com [209.85.210.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68BD1A9B3D
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 15:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745508753; cv=none; b=oh4QPPLqGGf15WPNxcHK4IrDaR3+ZiSVK1ZmLt03kkT/hIAG7WK7E9mvgmnpyP5T/0HxCDSCD+TvT5sA3arI0JXR9ME3RH3P8aqgxwN3q2extZyrAHkXhG2/ZcQal1o+Y/NJ/FyivFS+oShv/S+lkFGgYohruAtNB5EfoDaGJAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745508753; c=relaxed/simple;
	bh=Hbpv2B3znjWkVr7BCdd4wLB9PMjGMLG2fdMhHTh2D+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u1sio242BvuGZwQwX/1vSjqMV1Qjaiz4lG9mlp7HCaUg8UihsUD6SJ/ZY2v3fSeLaorC6CJ12uTaS/m4eN4Mxc8CSztnU7SmSwOXw4Ec5mFmjjoU0wdlX/eiz7D7pWQU/ru9JRJN0dokWsRoaE0PzeMxH4SZuw4AP/BFxpPlVhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=ND1wILcE; arc=none smtp.client-ip=209.85.210.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pf1-f195.google.com with SMTP id d2e1a72fcca58-7370a2d1981so966168b3a.2
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 08:32:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745508751; x=1746113551; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ryJkTbKAwtM59V1O1MS/WywWNtwvLqWzyl4I1jgJpkI=;
        b=ND1wILcEq/C3o988WIx4zE9G8wCmrOwA+DPKXwr64FNYHibPP4bn7WtpJqT87/QAbv
         wtB8y01AWHCxiHWDUgLb4GUOuhS4iD8m+hSctwHmQBM0Y/BA8X3veK5rBv5Wf2LBWysR
         ZSopWyIezInRkvjyhk5x8GSrwJNZ/S7MpjyOP0PVaihI+2DqMaGXFSmugqhZcyi6QEwU
         /SaKsGvXY8zLE5mubhbkehxhrKCGnAU6N8ohPLDwMdmmX4ycHhUDUGzx7hZQIOl4hzPk
         8qARTJ96h0tfkHPIDs6vYom5NQAkbMNhaR7nVfw2wjhSW58hxXF/bbN2HwbdOOz44uW+
         nYvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745508751; x=1746113551;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ryJkTbKAwtM59V1O1MS/WywWNtwvLqWzyl4I1jgJpkI=;
        b=NOPmDILV5gKfobVHGdMOR+lwTtHMMZuRMjBPeMULxAnonq4VoMYLDz1ufCU3TeWXCx
         hFoptWEwQqKltA44iJ237ON13PgiFIIdipsb5Z8ChvolZLzEY8sfrMR05TvYJbbQ7yhM
         lXOW2XODjEXRC5nAu8Q/CXeVS9WSOwqVPG3XLthdRpqUhV+AKSirmOeX2l1LZaww65B7
         /Js1oP1m7rdL8HMGvp6FB1sTm1R0hW4MUQbYfHPkRuSGDj0fiWQNohSxrarg6ly0yjsE
         ziy/ty2D+ZO6kpAF2uhNYr15XH62Ux83y7APp1JtgUjQGX65ZiyRvgOedoZ7e5H252f1
         FmOw==
X-Forwarded-Encrypted: i=1; AJvYcCXFnFcUPL6qvE0Xk4GHEFmwtKpmCPDoWp86dGsSWD/cYzJXrwxy03o2T/HAsWsyU0UXU1Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRnqhVa0wj6CXTGD+Fwbt1yChHjDJK0EOqtK93tMmevQSRYGl1
	qmpI20gr6iZGN+zJyFuiLDUbrBBFNhlzdcM1W/W9Ugc6/EHdmAcpWMAzzaYv9nA=
X-Gm-Gg: ASbGnctALGXeHw8evGOL2NnADZQ9qlwYnsYr2E3g1Ps+z0VcDpmhyIAR4uv6Ls4pSk/
	6GiwtVPMY9E+ZsZ+Frrhk6usowIIP10utl6MmqiwvPzRYsskvHJMngwW8lRCQCSr2E7BhZQGgaa
	AjDzZQKvZR/rkNlN2hsZQsrpxxwCMbybFy+eIVRTz845ouZWNdAw7Tq3m9wZ5e2P+euFxePI1X0
	ZixOEwMk1mIarbaQ55fVkcxfOpuqmDn4OLCMBHD6vUlFmBDXFhNl+uxN5IrWsv0qQCKSoIRsleM
	pqepDLbBaENXoKZOVVCvpq0q6kgoE01GfupzyOesp/9kG6lsA/43x9t0pkZSmfyF1UIMdZgj/X6
	HJnAG
X-Google-Smtp-Source: AGHT+IGi9mHwnOeEIylVlG/uMwbn4WhtUFI2gns2yYhv2N27LasmqweDzDMmCCIezM+FrydARH7PJQ==
X-Received: by 2002:a05:6a21:78a3:b0:1f5:839e:ece8 with SMTP id adf61e73a8af0-20444e6fad7mr4314102637.2.1745508751087;
        Thu, 24 Apr 2025 08:32:31 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.166.196])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b15f8597f5csm1360610a12.43.2025.04.24.08.32.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 08:32:30 -0700 (PDT)
From: Anup Patel <apatel@ventanamicro.com>
To: Will Deacon <will@kernel.org>,
	julien.thierry.kdev@gmail.com,
	maz@kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Atish Patra <atishp@atishpatra.org>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	Anup Patel <apatel@ventanamicro.com>
Subject: [kvmtool PATCH v2 05/10] riscv: Add SBI system suspend support
Date: Thu, 24 Apr 2025 21:01:54 +0530
Message-ID: <20250424153159.289441-6-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250424153159.289441-1-apatel@ventanamicro.com>
References: <20250424153159.289441-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Andrew Jones <ajones@ventanamicro.com>

Provide a handler for SBI system suspend requests forwarded to the
VMM by KVM and enable system suspend by default. This is just for
testing purposes, so the handler only sleeps 5 seconds before
resuming the guest. Resuming a system suspend only requires running
the system suspend invoking hart again, everything else is handled by
KVM.

Note, resuming after a suspend doesn't work with 9p used for the
guest's rootfs. Testing with a disk works though, e.g.

  lkvm-static run --nodefaults -m 256 -c 2 -d rootfs.ext2 -k Image \
    -p 'console=ttyS0 rootwait root=/dev/vda ro no_console_suspend'

Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/include/kvm/kvm-config-arch.h |  3 +++
 riscv/include/kvm/sbi.h             |  9 ++++++++
 riscv/kvm-cpu.c                     | 36 +++++++++++++++++++++++++++++
 3 files changed, 48 insertions(+)

diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index 5badb74..0553004 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -238,6 +238,9 @@ struct kvm_config_arch {
 	OPT_BOOLEAN('\0', "disable-sbi-dbcn",				\
 		    &(cfg)->sbi_ext_disabled[KVM_RISCV_SBI_EXT_DBCN],	\
 		    "Disable SBI DBCN Extension"),			\
+	OPT_BOOLEAN('\0', "disable-sbi-susp",				\
+		    &(cfg)->sbi_ext_disabled[KVM_RISCV_SBI_EXT_SUSP],	\
+		    "Disable SBI SUSP Extension"),			\
 	OPT_BOOLEAN('\0', "disable-sbi-sta",				\
 		    &(cfg)->sbi_ext_disabled[KVM_RISCV_SBI_EXT_STA],	\
 		    "Disable SBI STA Extension"),
diff --git a/riscv/include/kvm/sbi.h b/riscv/include/kvm/sbi.h
index a0f2c70..10bbe1b 100644
--- a/riscv/include/kvm/sbi.h
+++ b/riscv/include/kvm/sbi.h
@@ -21,6 +21,7 @@ enum sbi_ext_id {
 	SBI_EXT_0_1_SHUTDOWN = 0x8,
 	SBI_EXT_BASE = 0x10,
 	SBI_EXT_DBCN = 0x4442434E,
+	SBI_EXT_SUSP = 0x53555350,
 };
 
 enum sbi_ext_base_fid {
@@ -39,6 +40,14 @@ enum sbi_ext_dbcn_fid {
 	SBI_EXT_DBCN_CONSOLE_WRITE_BYTE = 2,
 };
 
+enum sbi_ext_susp_fid {
+	SBI_EXT_SUSP_SYSTEM_SUSPEND = 0,
+};
+
+enum sbi_ext_susp_sleep_type {
+	SBI_SUSP_SLEEP_TYPE_SUSPEND_TO_RAM = 0,
+};
+
 #define SBI_SPEC_VERSION_DEFAULT	0x1
 #define SBI_SPEC_VERSION_MAJOR_OFFSET	24
 #define SBI_SPEC_VERSION_MAJOR_MASK	0x7f
diff --git a/riscv/kvm-cpu.c b/riscv/kvm-cpu.c
index 0c171da..ad68b58 100644
--- a/riscv/kvm-cpu.c
+++ b/riscv/kvm-cpu.c
@@ -1,3 +1,5 @@
+#include <unistd.h>
+
 #include "kvm/csr.h"
 #include "kvm/kvm-cpu.h"
 #include "kvm/kvm.h"
@@ -117,6 +119,17 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 				   KVM_RISCV_SBI_EXT_DBCN);
 	}
 
+	/* Force enable SBI system suspend if not disabled from command line */
+	if (!kvm->cfg.arch.sbi_ext_disabled[KVM_RISCV_SBI_EXT_SUSP]) {
+		id = 1;
+		reg.id = RISCV_SBI_EXT_REG(KVM_REG_RISCV_SBI_SINGLE,
+					   KVM_RISCV_SBI_EXT_SUSP);
+		reg.addr = (unsigned long)&id;
+		if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
+			pr_warning("KVM_SET_ONE_REG failed (sbi_ext %d)",
+				   KVM_RISCV_SBI_EXT_SUSP);
+	}
+
 	/* Populate the vcpu structure. */
 	vcpu->kvm		= kvm;
 	vcpu->cpu_id		= cpu_id;
@@ -203,6 +216,29 @@ static bool kvm_cpu_riscv_sbi(struct kvm_cpu *vcpu)
 			break;
 		}
 		break;
+	case SBI_EXT_SUSP:
+	{
+		unsigned long susp_type, ret = SBI_SUCCESS;
+
+		switch (vcpu->kvm_run->riscv_sbi.function_id) {
+		case SBI_EXT_SUSP_SYSTEM_SUSPEND:
+			susp_type = vcpu->kvm_run->riscv_sbi.args[0];
+			if (susp_type != SBI_SUSP_SLEEP_TYPE_SUSPEND_TO_RAM) {
+				ret = SBI_ERR_INVALID_PARAM;
+				break;
+			}
+
+			sleep(5);
+
+			break;
+		default:
+			ret = SBI_ERR_NOT_SUPPORTED;
+			break;
+		}
+
+		vcpu->kvm_run->riscv_sbi.ret[0] = ret;
+		break;
+	}
 	default:
 		dprintf(dfd, "Unhandled SBI call\n");
 		dprintf(dfd, "extension_id=0x%lx function_id=0x%lx\n",
-- 
2.43.0


