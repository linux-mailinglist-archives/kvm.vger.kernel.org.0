Return-Path: <kvm+bounces-2641-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C73227FBD85
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 15:57:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7CC1D282EE6
	for <lists+kvm@lfdr.de>; Tue, 28 Nov 2023 14:57:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58A1B5CD21;
	Tue, 28 Nov 2023 14:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="T5euO1eV"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F4C9127
	for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 06:57:20 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1cfb83211b9so25373025ad.3
        for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 06:57:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1701183440; x=1701788240; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xwIs8nEfIc4H0x0tyu7MTp0Kuhb4OwEwEqgm1x28cAE=;
        b=T5euO1eVi2NgiishN0SfMSQRbKyuF0fdOTklxf3dSFRHxQ6twtOp4Da6nPaBo40cy0
         Of8oB0FQHx5+e5VkqwiGbXxT5x69bPwuhrVvzc7VhGUlN5JSX61gAJirHVHhfM+XiE7B
         kWn4TnMIl047ZjyossbE97JOf8zO1eI/vIbkvePuXOnKgm06SXosyNlfSXr4EPzkWefA
         YrkG7RlDgYAGgBR6TTNbDDKTVIPK9K27zEOkFmmWk7hLH1XlrJdfF3FQ7tG0GpMteHxv
         YpDTXKCcsTMLUkGzU0I8Q0ss1GOGaF1W7JwpGBWobGnJHPYZPPnt669yErg5k1KPyzMS
         A9GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701183440; x=1701788240;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xwIs8nEfIc4H0x0tyu7MTp0Kuhb4OwEwEqgm1x28cAE=;
        b=NYUVGdSTX8nqxcWBhQt+2fdPwzcm7Qox+nh9+B+txC02XL7lJ7lvnsd18k0xPwKvT2
         LJiNS6x5QCb5Mx9G/tDsRiF3F0gKEaXkKfmt9ooJVomRHclmYF/KHsQ2cLC/scyD+uGH
         abjymozPsUadIfMtn5ZWntvOKtsVPbzNPGrmXkr9DzI+QPdd2tLEA8np7l4JiH1OH19w
         anQ7F8+/sRFKl1UVh4FPLfbdYmuqRoMehVn+y8EyW44Ot+K/k1pNtBeXpOn/AYkWsIYj
         6xrCQIvty8+Hh9UT8h3IPFeb/4V2/IixKALjHai38Ni5S9KRA+UYDkP9OA14uBy/q8so
         mzIA==
X-Gm-Message-State: AOJu0YzcWkau+p5mzy0zYkpy1hzAVWjOTIo2BsS0IsbzWoCTwRpef4Ig
	vGJfkQ8JQVf8QxjMtkc9XsTRHg==
X-Google-Smtp-Source: AGHT+IEoUvv3uxivYOxvLpY+oK4D/unmsQkf8bsG9mjdi57Yky23KzPLLC35z99Y2pc7vzOhucbR0w==
X-Received: by 2002:a17:902:db07:b0:1cf:c37f:7160 with SMTP id m7-20020a170902db0700b001cfc37f7160mr8898046plx.63.1701183439914;
        Tue, 28 Nov 2023 06:57:19 -0800 (PST)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id j1-20020a170902c08100b001ab39cd875csm9023580pld.133.2023.11.28.06.57.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Nov 2023 06:57:19 -0800 (PST)
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
Subject: [kvmtool PATCH 10/10] riscv: Handle SBI DBCN calls from Guest/VM
Date: Tue, 28 Nov 2023 20:26:28 +0530
Message-Id: <20231128145628.413414-11-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231128145628.413414-1-apatel@ventanamicro.com>
References: <20231128145628.413414-1-apatel@ventanamicro.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The new SBI DBCN functions are forwarded by in-kernel KVM RISC-V module
to user-space so let us handle these calls in kvm_cpu_riscv_sbi() function.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 riscv/include/kvm/kvm-config-arch.h |  5 ++-
 riscv/include/kvm/sbi.h             | 14 ++++++-
 riscv/kvm-cpu.c                     | 57 +++++++++++++++++++++++++++++
 3 files changed, 73 insertions(+), 3 deletions(-)

diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
index 48d0770..d2fc2d4 100644
--- a/riscv/include/kvm/kvm-config-arch.h
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -102,6 +102,9 @@ struct kvm_config_arch {
 		    "Disable SBI Experimental Extensions"),		\
 	OPT_BOOLEAN('\0', "disable-sbi-vendor",				\
 		    &(cfg)->sbi_ext_disabled[KVM_RISCV_SBI_EXT_VENDOR],	\
-		    "Disable SBI Vendor Extensions"),
+		    "Disable SBI Vendor Extensions"),			\
+	OPT_BOOLEAN('\0', "disable-sbi-dbcn",				\
+		    &(cfg)->sbi_ext_disabled[KVM_RISCV_SBI_EXT_DBCN],	\
+		    "Disable SBI DBCN Extension"),
 
 #endif /* KVM__KVM_CONFIG_ARCH_H */
diff --git a/riscv/include/kvm/sbi.h b/riscv/include/kvm/sbi.h
index f4b4182..a0f2c70 100644
--- a/riscv/include/kvm/sbi.h
+++ b/riscv/include/kvm/sbi.h
@@ -20,6 +20,7 @@ enum sbi_ext_id {
 	SBI_EXT_0_1_REMOTE_SFENCE_VMA_ASID = 0x7,
 	SBI_EXT_0_1_SHUTDOWN = 0x8,
 	SBI_EXT_BASE = 0x10,
+	SBI_EXT_DBCN = 0x4442434E,
 };
 
 enum sbi_ext_base_fid {
@@ -32,6 +33,12 @@ enum sbi_ext_base_fid {
 	SBI_BASE_GET_MIMPID,
 };
 
+enum sbi_ext_dbcn_fid {
+	SBI_EXT_DBCN_CONSOLE_WRITE = 0,
+	SBI_EXT_DBCN_CONSOLE_READ = 1,
+	SBI_EXT_DBCN_CONSOLE_WRITE_BYTE = 2,
+};
+
 #define SBI_SPEC_VERSION_DEFAULT	0x1
 #define SBI_SPEC_VERSION_MAJOR_OFFSET	24
 #define SBI_SPEC_VERSION_MAJOR_MASK	0x7f
@@ -41,8 +48,11 @@ enum sbi_ext_base_fid {
 #define SBI_SUCCESS		0
 #define SBI_ERR_FAILURE		-1
 #define SBI_ERR_NOT_SUPPORTED	-2
-#define SBI_ERR_INVALID_PARAM   -3
+#define SBI_ERR_INVALID_PARAM	-3
 #define SBI_ERR_DENIED		-4
-#define SBI_ERR_INVALID_ADDRESS -5
+#define SBI_ERR_INVALID_ADDRESS	-5
+#define SBI_ERR_ALREADY_AVAILABLE -6
+#define SBI_ERR_ALREADY_STARTED -7
+#define SBI_ERR_ALREADY_STOPPED -8
 
 #endif
diff --git a/riscv/kvm-cpu.c b/riscv/kvm-cpu.c
index 540baec..c4e83c4 100644
--- a/riscv/kvm-cpu.c
+++ b/riscv/kvm-cpu.c
@@ -105,6 +105,17 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 			die("KVM_SET_ONE_REG failed (sbi_ext %d)", i);
 	}
 
+	/* Force enable SBI debug console if not disabled from command line */
+	if (!kvm->cfg.arch.sbi_ext_disabled[KVM_RISCV_SBI_EXT_DBCN]) {
+		id = 1;
+		reg.id = RISCV_SBI_EXT_REG(KVM_REG_RISCV_SBI_SINGLE,
+					   KVM_RISCV_SBI_EXT_DBCN);
+		reg.addr = (unsigned long)&id;
+		if (ioctl(vcpu->vcpu_fd, KVM_SET_ONE_REG, &reg) < 0)
+			pr_warning("KVM_SET_ONE_REG failed (sbi_ext %d)",
+				   KVM_RISCV_SBI_EXT_DBCN);
+	}
+
 	/* Populate the vcpu structure. */
 	vcpu->kvm		= kvm;
 	vcpu->cpu_id		= cpu_id;
@@ -128,7 +139,9 @@ void kvm_cpu__delete(struct kvm_cpu *vcpu)
 static bool kvm_cpu_riscv_sbi(struct kvm_cpu *vcpu)
 {
 	char ch;
+	u64 addr;
 	bool ret = true;
+	char *str_start, *str_end;
 	int dfd = kvm_cpu__get_debug_fd();
 
 	switch (vcpu->kvm_run->riscv_sbi.extension_id) {
@@ -144,6 +157,50 @@ static bool kvm_cpu_riscv_sbi(struct kvm_cpu *vcpu)
 		else
 			vcpu->kvm_run->riscv_sbi.ret[0] = SBI_ERR_FAILURE;
 		break;
+	case SBI_EXT_DBCN:
+		switch (vcpu->kvm_run->riscv_sbi.function_id) {
+		case SBI_EXT_DBCN_CONSOLE_WRITE:
+		case SBI_EXT_DBCN_CONSOLE_READ:
+			addr = vcpu->kvm_run->riscv_sbi.args[1];
+#if __riscv_xlen == 32
+			addr |= (u64)vcpu->kvm_run->riscv_sbi.args[2] << 32;
+#endif
+			if (!vcpu->kvm_run->riscv_sbi.args[0])
+				break;
+			str_start = guest_flat_to_host(vcpu->kvm, addr);
+			addr += vcpu->kvm_run->riscv_sbi.args[0] - 1;
+			str_end = guest_flat_to_host(vcpu->kvm, addr);
+			if (!str_start || !str_end) {
+				vcpu->kvm_run->riscv_sbi.ret[0] =
+						SBI_ERR_INVALID_PARAM;
+				break;
+			}
+			vcpu->kvm_run->riscv_sbi.ret[1] = 0;
+			while (str_start <= str_end) {
+				if (vcpu->kvm_run->riscv_sbi.function_id ==
+				    SBI_EXT_DBCN_CONSOLE_WRITE) {
+					term_putc(str_start, 1, 0);
+				} else {
+					if (!term_readable(0))
+						break;
+					*str_start = term_getc(vcpu->kvm, 0);
+				}
+				vcpu->kvm_run->riscv_sbi.ret[1]++;
+				str_start++;
+			}
+			break;
+		case SBI_EXT_DBCN_CONSOLE_WRITE_BYTE:
+			ch = vcpu->kvm_run->riscv_sbi.args[0];
+			term_putc(&ch, 1, 0);
+			vcpu->kvm_run->riscv_sbi.ret[0] = 0;
+			vcpu->kvm_run->riscv_sbi.ret[1] = 0;
+			break;
+		default:
+			vcpu->kvm_run->riscv_sbi.ret[0] =
+						SBI_ERR_NOT_SUPPORTED;
+			break;
+		}
+		break;
 	default:
 		dprintf(dfd, "Unhandled SBI call\n");
 		dprintf(dfd, "extension_id=0x%lx function_id=0x%lx\n",
-- 
2.34.1


