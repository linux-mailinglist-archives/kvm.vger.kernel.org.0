Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF617C6471
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 07:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377181AbjJLFQA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 01:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235335AbjJLFPx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 01:15:53 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7A73112
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 22:15:37 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1c5cd27b1acso5222505ad.2
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 22:15:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1697087737; x=1697692537; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5F82Co3/cdirw9N8c47oejx7W6gl4Raymf8m/hgF9mg=;
        b=Aa8pV8cmo1PCC0/FwyfvUQZbJPtmLkPsmt3DzZIZkibCUodWHn9RE7KnXVOv5dt2SU
         RQWrTvQeSPsO00eEjdIcS4AvOv2Vtevi6mF2c4L7FXWl83JbX1DtGN2y7oGIR05y2NUY
         Q3bPGo8jDAlYCxsnHZteeHzCbjCrfRDPmVJWn4f9mvc1BLU/RLGwK0IYZnf7qM7XTJnK
         rE/zjjn0mRowhqTQlb6q7h+4vWLDqtpIAZEmojxSoL7GPhUaAWaswytlV9A2w0LoZdpv
         hpz6YVrKA/+cF53/td7Zhb1v0sO2u4+61GEpflGdbIQd92XUDlFM1laQJvEiYNnuBFKy
         R1JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697087737; x=1697692537;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5F82Co3/cdirw9N8c47oejx7W6gl4Raymf8m/hgF9mg=;
        b=lC/NaLY7lvwvoaYbu4oltfZo0xHA2SLTeMoKHd5QOWluxRJL35GqwisQQ6TzokGJYU
         UaGHut5g0wOOtd3kqEVqhns5vORhK+gFbMDsZUEN7s8HhlEqoOVeik+QCNzmFASV3G9R
         7Eh1SRl5W75BMKGpgewnijY9DblSoBaY3J0Ch2wgyLyT/L/GfWh6p1WPmbZLvqRFSu4Q
         VsLmeRKyz+xaKOV70u26lBz27AcHzXhJgJS6KAQDRv/3f6BSWWgeDFfWsOkA6GqdD3YQ
         OCO2XGchyXR4K+Uo2Dix+WzwZXiO8cZPDR0TfidHS1QRNPEaLpgjCzTOSGRZiBYFG9FE
         55NQ==
X-Gm-Message-State: AOJu0YyqFdN5F4E9juAky13dCMW1xmkRxe4K2n8bBv7Jn/Zsl7V0zFF1
        SQigE4JEsUVZeUGQlpu5iv0hkg==
X-Google-Smtp-Source: AGHT+IFZ9PIs/5Xdz63daF5WgvnqI8HA2E47f1F59gFa33dzVCANlp1ZCJBRk4958EXc+DlXohYaDw==
X-Received: by 2002:a17:902:d48f:b0:1c9:d358:b3c9 with SMTP id c15-20020a170902d48f00b001c9d358b3c9mr2956911plg.19.1697087736652;
        Wed, 11 Oct 2023 22:15:36 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([106.51.83.242])
        by smtp.gmail.com with ESMTPSA id s18-20020a17090330d200b001b9d95945afsm851309plc.155.2023.10.11.22.15.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Oct 2023 22:15:36 -0700 (PDT)
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
Subject: [PATCH v2 4/8] RISC-V: KVM: Forward SBI DBCN extension to user-space
Date:   Thu, 12 Oct 2023 10:45:05 +0530
Message-Id: <20231012051509.738750-5-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231012051509.738750-1-apatel@ventanamicro.com>
References: <20231012051509.738750-1-apatel@ventanamicro.com>
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
index 1b1cee86efda..bb76c3cf633f 100644
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

