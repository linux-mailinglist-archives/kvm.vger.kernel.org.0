Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8154A5872
	for <lists+kvm@lfdr.de>; Tue,  1 Feb 2022 09:23:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235467AbiBAIXz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Feb 2022 03:23:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235463AbiBAIXz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Feb 2022 03:23:55 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C38A0C06173E
        for <kvm@vger.kernel.org>; Tue,  1 Feb 2022 00:23:54 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id w25so31635724edt.7
        for <kvm@vger.kernel.org>; Tue, 01 Feb 2022 00:23:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T8jkwpaTNUs5ESeTMvPF9Tbpyy5JKY953H6W28s28Gw=;
        b=ngcy4rQ1Tpgrp9QzjvjPpqlVgEEEjqUKlV9f6VgLlo3oZPaCeQ7cPAESbm6F2HSzDM
         paNnr/LcQOSSotljA3esNoziLPThU5dSkiW4AQT1KrCJ9zkf1JDCYAN6aKYxd8akcqcX
         jvZxUF3iKLDGyAi9OE7LyyWgCLx3i7/oiQWaRChkSaQ1gOBdS9wRWZz6Ptio+n8+qEr8
         9X1Np23oxzKTJSrFLRSmuLariV7eZqgzOOOkc4O9OgvbIc36GNjHYi4hXo/br2l0I8Aa
         y3IYbsaAGoRHvL+OFw2J90Y6uFAA+dp+NYQxTJ6hzTuVNihOXwkIQevryg1IPiuLIAC/
         Dn1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T8jkwpaTNUs5ESeTMvPF9Tbpyy5JKY953H6W28s28Gw=;
        b=e9Ov7nfXhHXrJbpDxxsVKarW6dcv3k6oS7p0dtilkbpXv4gwCbwbEQBAFPOZYrBPxu
         NqrOrUdYC3pvuMZPZtYqQIr2NGY37CbmG+3+Fp2nnbx9Fpq4+uzquaiw5BGwVhgZIYYi
         eHamddcPwL1XzfV+I8t44tJs/Pl7hmBrL5hlnZH49wiuYzLRQu9KHLk2sm8nhEOPSe8P
         p4plwTDbrabUSXZ55HnZH1hfUGfCz/Gh2ekpEMlLxAVBUFwWXXOTY0fpZ8vyKLvNiiGH
         nGDxRtIYr4dBAW1ZrIMFZ1BjxjNRxpomkDiF5iriVOxphs1r0vje0POgXoHKsaBxQ4HR
         +QVg==
X-Gm-Message-State: AOAM532Ts/k9KHTwqesVwnq/DOHIUFOM92lPJH68SkhzS5mvwg3rPZG8
        +U1zYn8yZm6IObVVj4pmBuK8Iw==
X-Google-Smtp-Source: ABdhPJxMN4igBjnNAWqvjNJdPlsojVXp0jfP8pzdoErz1Lbcla7jF8s1hXlmk0ufOTGHDHY8aA6Zkg==
X-Received: by 2002:a05:6402:1774:: with SMTP id da20mr24004748edb.372.1643703833389;
        Tue, 01 Feb 2022 00:23:53 -0800 (PST)
Received: from localhost.localdomain ([122.179.76.38])
        by smtp.gmail.com with ESMTPSA id w8sm14312133ejq.220.2022.02.01.00.23.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 00:23:52 -0800 (PST)
From:   Anup Patel <apatel@ventanamicro.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <apatel@ventanamicro.com>
Subject: [PATCH 3/6] RISC-V: KVM: Implement SBI v0.3 SRST extension
Date:   Tue,  1 Feb 2022 13:52:24 +0530
Message-Id: <20220201082227.361967-4-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220201082227.361967-1-apatel@ventanamicro.com>
References: <20220201082227.361967-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The SBI v0.3 specification defines SRST (System Reset) extension which
provides a standard poweroff and reboot interface. This patch implements
SRST extension for the KVM Guest.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/kvm/vcpu_sbi.c         |  2 ++
 arch/riscv/kvm/vcpu_sbi_replace.c | 44 +++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index 11ae4f621f0d..a09ecb97b890 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -45,6 +45,7 @@ extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_base;
 extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_time;
 extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_ipi;
 extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_rfence;
+extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_srst;
 extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_hsm;
 extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_experimental;
 extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_vendor;
@@ -55,6 +56,7 @@ static const struct kvm_vcpu_sbi_extension *sbi_ext[] = {
 	&vcpu_sbi_ext_time,
 	&vcpu_sbi_ext_ipi,
 	&vcpu_sbi_ext_rfence,
+	&vcpu_sbi_ext_srst,
 	&vcpu_sbi_ext_hsm,
 	&vcpu_sbi_ext_experimental,
 	&vcpu_sbi_ext_vendor,
diff --git a/arch/riscv/kvm/vcpu_sbi_replace.c b/arch/riscv/kvm/vcpu_sbi_replace.c
index 1bc0608a5bfd..0f217365c287 100644
--- a/arch/riscv/kvm/vcpu_sbi_replace.c
+++ b/arch/riscv/kvm/vcpu_sbi_replace.c
@@ -130,3 +130,47 @@ const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_rfence = {
 	.extid_end = SBI_EXT_RFENCE,
 	.handler = kvm_sbi_ext_rfence_handler,
 };
+
+static int kvm_sbi_ext_srst_handler(struct kvm_vcpu *vcpu,
+				    struct kvm_run *run,
+				    unsigned long *out_val,
+				    struct kvm_cpu_trap *utrap, bool *exit)
+{
+	struct kvm_cpu_context *cp = &vcpu->arch.guest_context;
+	unsigned long funcid = cp->a6;
+	u32 reason = cp->a1;
+	u32 type = cp->a0;
+	int ret = 0;
+
+	switch (funcid) {
+	case SBI_EXT_SRST_RESET:
+		switch (type) {
+		case SBI_SRST_RESET_TYPE_SHUTDOWN:
+			kvm_riscv_vcpu_sbi_system_reset(vcpu, run,
+						KVM_SYSTEM_EVENT_SHUTDOWN,
+						reason);
+			*exit = true;
+			break;
+		case SBI_SRST_RESET_TYPE_COLD_REBOOT:
+		case SBI_SRST_RESET_TYPE_WARM_REBOOT:
+			kvm_riscv_vcpu_sbi_system_reset(vcpu, run,
+						KVM_SYSTEM_EVENT_RESET,
+						reason);
+			*exit = true;
+			break;
+		default:
+			ret = -EOPNOTSUPP;
+		}
+		break;
+	default:
+		ret = -EOPNOTSUPP;
+	}
+
+	return ret;
+}
+
+const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_srst = {
+	.extid_start = SBI_EXT_SRST,
+	.extid_end = SBI_EXT_SRST,
+	.handler = kvm_sbi_ext_srst_handler,
+};
-- 
2.25.1

