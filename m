Return-Path: <kvm+bounces-42025-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 77D47A710E7
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 07:59:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7C19C3B6013
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 06:57:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F02319CD17;
	Wed, 26 Mar 2025 06:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="icWrx+Nd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 029A219CC0E
	for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 06:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742972235; cv=none; b=bZZQXLZOjZj0VzjwdXX/wG2fusyFQf6qEUdABZz9zLMgxv0f6eJPzVZ1zsFjnflwoa3cGIih/4egtthLngbX9KFwH1/YBq/H+IBD/0KuY4m2lXVw+0VNtyRkNATQhqnncEm2P9bZIEuZp7CyRo06Em11uSq4RHzo5xdeHv/s9AI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742972235; c=relaxed/simple;
	bh=Hbpv2B3znjWkVr7BCdd4wLB9PMjGMLG2fdMhHTh2D+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O5F7Rjz9oa8s+nyp3AorCRLkS0zA5gFbTPaRoIQZW7t4LU6mdoiy+wVNzmWhI/O+tuBlMKPaEiRwWGhrXRLeYKbSkf4QMCTWlwblka8xP/ehRASELkjzilT6ffGCc0q1f3+tA0hvG32GyQQJHjZlXc/yMnm/ZDvQT1C2jXh05jA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=icWrx+Nd; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-224019ad9edso11276465ad.1
        for <kvm@vger.kernel.org>; Tue, 25 Mar 2025 23:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1742972233; x=1743577033; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ryJkTbKAwtM59V1O1MS/WywWNtwvLqWzyl4I1jgJpkI=;
        b=icWrx+NdPHdUVFWmb/9kaSr0XXDQ3oRn9PuX6f7YFh7HXoL6Mv9Iw6MbAo0mnxsLPe
         Kh/MjzLIsaUqeMLvu5Eukru3j1+wT46wzBQsct0OxAMj/Q15T2Fdfbg+56YOQIBXN2Pr
         dX6xPd0fxrmaySUOB5ivuXg++4qseuVTocQDWpr/hfTkJyKk/E1mRRZukJy7IeSNc3fg
         o3e5ExlG0xcXslI8C3aoIIIne0QkLBE7tMCmFvpD+mOw5zbjz/yrDK/PnwVHYs9OhoUt
         iGeL23soWg/3JrXYb1LcbJulfADp8ASBcsXpydIRksKPPGgL5Kn8/LNTBuQjJ89gpLrN
         WteQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742972233; x=1743577033;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ryJkTbKAwtM59V1O1MS/WywWNtwvLqWzyl4I1jgJpkI=;
        b=u5q/eIY0FFU7I33P5DrIMjo3RvZZYgRhD/DAH8aqpbd8fB650p/aDWUKfkm4bbrdd+
         zKZcFzhBPBSnvJGFyA6nYSCp7dzRvZimUB5/J53PSr5/cAFI1zjiOq4mfuQkZRnki7SB
         4l+Oh0xURUI/B4qWCq53tPFbQxDgofupS9D6yHNd4Xs24ucxjZszLLrPRfRUn3SChBN/
         A8pnCG+GJg+oqBWYr5300mXFLjQllpgYoecG6xf11Mi53MtXjwPRw/Hsz7GIyIgqP5LV
         qgf8h5hDCvRu8/jCtoJmbgMMnFormBm+1DLKUqF8kTP1lmYkWPAzWDtvXP9UeW8EaYpa
         b95Q==
X-Forwarded-Encrypted: i=1; AJvYcCUNitq0adjpWRjlwCM7eeUqfgtR9caMHrmdMwPm4eamWrubcQ3euslK3tev4h1AoVm6//k=@vger.kernel.org
X-Gm-Message-State: AOJu0YyugCZ8o2EtlcZWmxTVS+V1MBZRqqWgTLIYTqKPtAZ4zJzeUFJ0
	glG3DegC6eTKCZELzbDP10rrlNHJblPtUhocNMH58vPR2OdBlxxY4IqCYmjETUM=
X-Gm-Gg: ASbGncsygH8Kz90RgnQTXJh+0E6MfJYabHQCcKd2Yh/HHm2/4j+E9MDAxR9xas5zWSZ
	mjNrKbUKRjev0I1Cju6ryd2Zd3dTQRmst1VnKl6r+OVlNYEhMDfdsiUZrKRTKZu6Zk3Ucfd+aXn
	QF6ctj8pJqmjWT2hgWrEHMkSxi+gINsdeHsPFvx9QHkxnxvHc119HyIFk5AoaVoHiJ7ud9DMp5/
	q93QW36B/xuyAMvURP6JuAIIG5G/CrmPEJvcv8MGgt3R3mIHLc3hwaqohUvpab3OQd2A1jiO/ZO
	eB6RjSNQdq+OPG19dXuahZCeCMAVBgeMN2zOFBeynbZ5BP1kEPXmQMV2RAocCz0dKM2YJRJciet
	/GY1BaA==
X-Google-Smtp-Source: AGHT+IE5H6R3DTm7xbphAfgfH61QBnKNsHA6xAmpxpqbylWoeAt+hTlvTQPfzix0WAdlMrob9mLXig==
X-Received: by 2002:a05:6a00:808:b0:736:55ec:ea94 with SMTP id d2e1a72fcca58-73905a5255dmr35474402b3a.20.1742972233107;
        Tue, 25 Mar 2025 23:57:13 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([14.141.91.70])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7390611c8d1sm11788817b3a.105.2025.03.25.23.57.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Mar 2025 23:57:12 -0700 (PDT)
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
Subject: [kvmtool PATCH 05/10] riscv: Add SBI system suspend support
Date: Wed, 26 Mar 2025 12:26:39 +0530
Message-ID: <20250326065644.73765-6-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250326065644.73765-1-apatel@ventanamicro.com>
References: <20250326065644.73765-1-apatel@ventanamicro.com>
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


