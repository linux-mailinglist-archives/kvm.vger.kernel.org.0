Return-Path: <kvm+bounces-44405-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 20A53A9DA4C
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 13:04:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 41CD31B662BC
	for <lists+kvm@lfdr.de>; Sat, 26 Apr 2025 11:04:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04F4B229B36;
	Sat, 26 Apr 2025 11:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="amZEpjIa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f195.google.com (mail-pl1-f195.google.com [209.85.214.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD09E1E519
	for <kvm@vger.kernel.org>; Sat, 26 Apr 2025 11:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745665464; cv=none; b=sA7fL3XIECksiO4vjHT2vxybBQ3mZMouS24KhQM7P31ANv+Fq8PKAeP60DQqwg4QnwRSBmtOfALJAPfe98zj/muOdvatcF35iq7o9H631GFoB8OLvXp0iqqtBhNq315+W2WlXnUWvdCx13Kg3znkir/6IUZc7YQVBcdcK7Bjq6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745665464; c=relaxed/simple;
	bh=Hbpv2B3znjWkVr7BCdd4wLB9PMjGMLG2fdMhHTh2D+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MFKUrKVGrIgHJjTFz64kfocpVIUiMDFP02/RnbcX2jJKXxYlSiz8bNx8ksOohAZL0QgoS6M7VLbYK+zvGxvxyn2+f0d/hFZd6BOp1t0moKIA5DhSyMxwTyt7botB3eTXxMN15sPm1hVoM/bkPVEJfKgDnxKuN+5+v8bMyKu3n4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=amZEpjIa; arc=none smtp.client-ip=209.85.214.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f195.google.com with SMTP id d9443c01a7336-227d6b530d8so35826615ad.3
        for <kvm@vger.kernel.org>; Sat, 26 Apr 2025 04:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1745665462; x=1746270262; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ryJkTbKAwtM59V1O1MS/WywWNtwvLqWzyl4I1jgJpkI=;
        b=amZEpjIaJoKKPCm/87w5D43+TCZ3oWAF9Gt6AsTjJ80pDQAWyq7fTrgITv/jpBlQHy
         TcwKVE0wEsV3Nhy7l4Om8gvqQsa62IOHuJkKx+H1UXwhzEuyl466N/jT6DdZy2a2iTBw
         l5bpw5vzUpU3oPUuM1LOo6aN1fDH+F53wjW+3xkdtLKo3mM0n9ohM5tkvVk9MUl0x9i3
         PrMXq6Yh6F7oQcXud93HN1bGEr4+nHxu4dpL/zjnVx8lo1acammej4T3XshdAF+MC/sQ
         /6gedBLEK+r9IzQ4FhJZNqbgjCbPIR+62qD3qFZNLq+CFpmYzhl0G5bcixJLAta2LBIQ
         +Atg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745665462; x=1746270262;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ryJkTbKAwtM59V1O1MS/WywWNtwvLqWzyl4I1jgJpkI=;
        b=LqJBqU4EvR2i45+t0FcMvMSWJ2MUwVHj9ODiI75Nx49BfK+bvo8H3g3vhUsaVDq6Gi
         KSMjcLM9k/YgbjDEoHUGcyrKDsOWIpzXKgKOdVq3mQA5Dq0m4J5hEBND9cdu8Fu7qTxM
         /5otv++JGEFrDI8h9CiYL8fD1w1mgse+p43RnLXu8iWrX+zP1dH4rw+njs733MHNlvHx
         BsbCy5kCwvGTveQqyIoWqQ56zkCMpHRTka2IeojOAwiOWXnKxK6XQ/QSZyGU0PrK7ThV
         G7HCKqHPO0ivJQ8a2oBc3UPaTLhgeUbwiTRt3YPTicS6CNN7zCubm/h6K0N0l37sgbaY
         tNFA==
X-Forwarded-Encrypted: i=1; AJvYcCUfm/bdO+wr9OmINkzES+yBuGBCxJGsZma6ELAXLgUfYxGhxhJBMpg6aDo83tdSyodgxAI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7wI3UUGDMhfl2Dfm/QvSoRHkH01pq++Dn4B614KussUTKh0ad
	Ghah/2TGo1fsN1NdEYjy3AxutZZMAS10D86OhtX4rbECw1/L4OH8P0Rxfp4n5fs=
X-Gm-Gg: ASbGncuv/YKfc84EXBBAKWqEvZIt0zRAyLeGMV4zT4nJQ1G22AUKwlPWcov2uJ9xf+q
	55bOXA9F8PE8Ip2F3JTYFZZuEEhEquhlo4Id5OMEQnJNdXXBs683RVuRqN+78YUpFdjidawGAdI
	cq/dX2h7pluFuij5AshmLn/ez0mms3hatGSh1cEN46z0zerq/Zas8AoWU4nbET4ul4OdR8/0MU0
	dEMjsKb1fzesDiYylR/R0wUumOg/NoED/J4jtq8DKwKgVVJZXKdviK2KA6Ize7FQXZI4dFj7F6P
	nYulomdrYOkjU45VAhtWqhKeGYY+f7PDD87amkOo8hiTU/mSE/36lVnpvmsxUtbgz9nGnIGvDxi
	bx3Gp
X-Google-Smtp-Source: AGHT+IFcbP/Gobc6EdjKBAcvU+RbmU/cZM/5SJ5fwyrfRrG6jZo/BtTL/v6N4krlr/CO4FcXcUIsxw==
X-Received: by 2002:a17:902:e74b:b0:21f:136a:a374 with SMTP id d9443c01a7336-22dbf742daamr91092785ad.43.1745665461875;
        Sat, 26 Apr 2025 04:04:21 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.166.196])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22dc8e24231sm10956725ad.125.2025.04.26.04.04.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Apr 2025 04:04:21 -0700 (PDT)
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
Subject: [kvmtool PATCH v3 05/10] riscv: Add SBI system suspend support
Date: Sat, 26 Apr 2025 16:33:42 +0530
Message-ID: <20250426110348.338114-6-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250426110348.338114-1-apatel@ventanamicro.com>
References: <20250426110348.338114-1-apatel@ventanamicro.com>
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


