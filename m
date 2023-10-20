Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77A6B7D095B
	for <lists+kvm@lfdr.de>; Fri, 20 Oct 2023 09:22:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376491AbjJTHWW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Oct 2023 03:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376409AbjJTHWQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Oct 2023 03:22:16 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D131710CA
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 00:22:08 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d2e1a72fcca58-6bee11456baso463224b3a.1
        for <kvm@vger.kernel.org>; Fri, 20 Oct 2023 00:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1697786528; x=1698391328; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hO8QQxSKIIq22xFRYvu7Gu8eaqjv2hPcSOTMD/z9e94=;
        b=NF++K+IHtiFmgzrSHLZgrw41LakLY8FUKgQny7rh/tQlqYxqoIAw3AKCFRiZWavtif
         BMMFkeFZSDxixW4/Yb0ITH9n5zesJUE1Z1JbWE7+0ZUa9LzP7dR7BxshCbs9//6+Rs4U
         YMotsWDeueiyVfEDFKm1T8pyaltg5uHQG2SN+fxJIWrQSIPkDH1qxonOfwBpU2WK1LUM
         YOMXwJQhxG6JK0bJPmX7Etl3NMvR52RLmYtSjeE2LPYNaLyqSuqaGtWIEavZ3j3j5VwN
         rcUiu4zoUjtplmeGYDlwe2Yuh/Cw1kPLDbCKH1PS0yqmRDHsGryReQM+2Vp2wXmLCNBc
         cRQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697786528; x=1698391328;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hO8QQxSKIIq22xFRYvu7Gu8eaqjv2hPcSOTMD/z9e94=;
        b=MBIaZ8+npk542TkXBlKBU+coUAhudwIMJUmR9xAbv1zGcn3eAeqMJfhlkxV9/a0loW
         aZWRFPWTm9vUOJGHZvly9/mhSagkbQY4yOYPq6olv7N9ZDk9n2BSAWMPVnCxyGl/Ss/+
         nuNoKfC4/Bs0RHq5i8wVmC0klPlK0CUZhOTYhSg4kSurJgg0CydLgKzGxpaezli4IAaK
         7AKFmnzBFnEaNOomU8nPz5m+cHETDvb4VA+SrrG3RZztQLM0DD/9FOSiQhM8M1QyAIYc
         xldEPbzMI/iZ8sviMIYRi4UIUusH8TFJBZAIEcX6A8C7EiIV+fpp6Y7IAavw/ah7BUow
         yicw==
X-Gm-Message-State: AOJu0YzP93yB3BVVC2gFgu63afiGz1DJOdBA+sWV2hvfH6FDRhHwnb8K
        c3MrQqeeEiLRoEx1yj9iQ5gEkQ==
X-Google-Smtp-Source: AGHT+IEkj9caZAnNIJ+YKQHJFuBSd9R4KVCbXPxdNGw5YMPQO4SC5tQtDdGdQxSt48V7VnxE9x8JkQ==
X-Received: by 2002:aa7:9622:0:b0:68e:42c9:74e0 with SMTP id r2-20020aa79622000000b0068e42c974e0mr952140pfg.3.1697786528093;
        Fri, 20 Oct 2023 00:22:08 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([171.76.83.81])
        by smtp.gmail.com with ESMTPSA id v12-20020a63f20c000000b005b32d6b4f2fsm828204pgh.81.2023.10.20.00.22.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Oct 2023 00:22:07 -0700 (PDT)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>
Cc:     Conor Dooley <conor@kernel.org>,
        Andrew Jones <ajones@ventanamicro.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH v3 4/9] RISC-V: KVM: Forward SBI DBCN extension to user-space
Date:   Fri, 20 Oct 2023 12:51:35 +0530
Message-Id: <20231020072140.900967-5-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231020072140.900967-1-apatel@ventanamicro.com>
References: <20231020072140.900967-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The frozen SBI v2.0 specification defines the SBI debug console
(DBCN) extension which replaces the legacy SBI v0.1 console
functions namely sbi_console_getchar() and sbi_console_putchar().

The SBI DBCN extension needs to be emulated in the KVM user-space
(i.e. QEMU-KVM or KVMTOOL) so we forward SBI DBCN calls from KVM
guest to the KVM user-space which can then redirect the console
input/output to wherever it wants (e.g. telnet, file, stdio, etc).

The SBI debug console is simply a early console available to KVM
guest for early prints and it does not intend to replace the proper
console devices such as 8250, VirtIO console, etc.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
---
 arch/riscv/include/asm/kvm_vcpu_sbi.h |  1 +
 arch/riscv/include/uapi/asm/kvm.h     |  1 +
 arch/riscv/kvm/vcpu_sbi.c             |  4 ++++
 arch/riscv/kvm/vcpu_sbi_replace.c     | 32 +++++++++++++++++++++++++++
 4 files changed, 38 insertions(+)

diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
index c02bda5559d7..6a453f7f8b56 100644
--- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
+++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
@@ -73,6 +73,7 @@ extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_ipi;
 extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_rfence;
 extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_srst;
 extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_hsm;
+extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_dbcn;
 extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_experimental;
 extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_vendor;
 
diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index 917d8cc2489e..60d3b21dead7 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -156,6 +156,7 @@ enum KVM_RISCV_SBI_EXT_ID {
 	KVM_RISCV_SBI_EXT_PMU,
 	KVM_RISCV_SBI_EXT_EXPERIMENTAL,
 	KVM_RISCV_SBI_EXT_VENDOR,
+	KVM_RISCV_SBI_EXT_DBCN,
 	KVM_RISCV_SBI_EXT_MAX,
 };
 
diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index bda8b0b33343..a04ff98085d9 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -66,6 +66,10 @@ static const struct kvm_riscv_sbi_extension_entry sbi_ext[] = {
 		.ext_idx = KVM_RISCV_SBI_EXT_PMU,
 		.ext_ptr = &vcpu_sbi_ext_pmu,
 	},
+	{
+		.ext_idx = KVM_RISCV_SBI_EXT_DBCN,
+		.ext_ptr = &vcpu_sbi_ext_dbcn,
+	},
 	{
 		.ext_idx = KVM_RISCV_SBI_EXT_EXPERIMENTAL,
 		.ext_ptr = &vcpu_sbi_ext_experimental,
diff --git a/arch/riscv/kvm/vcpu_sbi_replace.c b/arch/riscv/kvm/vcpu_sbi_replace.c
index 7c4d5d38a339..23b57c931b15 100644
--- a/arch/riscv/kvm/vcpu_sbi_replace.c
+++ b/arch/riscv/kvm/vcpu_sbi_replace.c
@@ -175,3 +175,35 @@ const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_srst = {
 	.extid_end = SBI_EXT_SRST,
 	.handler = kvm_sbi_ext_srst_handler,
 };
+
+static int kvm_sbi_ext_dbcn_handler(struct kvm_vcpu *vcpu,
+				    struct kvm_run *run,
+				    struct kvm_vcpu_sbi_return *retdata)
+{
+	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
+	unsigned long funcid = cp->a6;
+
+	switch (funcid) {
+	case SBI_EXT_DBCN_CONSOLE_WRITE:
+	case SBI_EXT_DBCN_CONSOLE_READ:
+	case SBI_EXT_DBCN_CONSOLE_WRITE_BYTE:
+		/*
+		 * The SBI debug console functions are unconditionally
+		 * forwarded to the userspace.
+		 */
+		kvm_riscv_vcpu_sbi_forward(vcpu, run);
+		retdata->uexit = true;
+		break;
+	default:
+		retdata->err_val = SBI_ERR_NOT_SUPPORTED;
+	}
+
+	return 0;
+}
+
+const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_dbcn = {
+	.extid_start = SBI_EXT_DBCN,
+	.extid_end = SBI_EXT_DBCN,
+	.default_unavail = true,
+	.handler = kvm_sbi_ext_dbcn_handler,
+};
-- 
2.34.1

