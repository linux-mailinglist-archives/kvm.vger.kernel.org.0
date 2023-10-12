Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F26E07C646F
	for <lists+kvm@lfdr.de>; Thu, 12 Oct 2023 07:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235371AbjJLFPz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Oct 2023 01:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235305AbjJLFPu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Oct 2023 01:15:50 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BE52E5
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 22:15:33 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id 98e67ed59e1d1-27d113508bfso451163a91.3
        for <kvm@vger.kernel.org>; Wed, 11 Oct 2023 22:15:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1697087732; x=1697692532; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UnnUYFylMM7osLHu6Gv9hbGwiUDTuyMbxo3uWzdsMQU=;
        b=dqE0nNGaOHUpekPXSfgZl7ELDKFozCRnkUzlU0U79v0qa1HjKV6VKTn94IdJwbs7Dx
         WBV/TEw69VackiL3io9W+O9SJwsvcYvVtefCIgaZoqRtZnERLNvu65TF/AgODJigZ47c
         280MMqvMu3EwXueYABWHYwTTE0vrpmw64V4PpYZ1mNhJCDxHoF9732oki6ogsw79wnMI
         cKAWequtAgEVA1UaAM8ryMEpuhk5DmWBr0U2XsK9sObQRyqiLxJuS72bVkcVKKe2bbsK
         V5Tn47JSKahVP3WomCV1qh0HsGySjZ9K9NFL40HoxkmMuhTLhikGx3gjT/2t9ahU4scX
         jQJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697087732; x=1697692532;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UnnUYFylMM7osLHu6Gv9hbGwiUDTuyMbxo3uWzdsMQU=;
        b=QlP8dylrMO4HMAZ+JjCmxnxd0De7EJ5QxJLBjck/eJSjJPcSbNoyyqh8KSieo66YnS
         5EVVJiW9DYs6x/MgLl6AqzRBqi+N4sIA4y+OqjeW+Vy9tZQutRzwK3NUm33v02Vt3dVH
         VzqvS5a4Db0+16sXzMksV5HxRsjwK3ClsF9O/P8dBqThZ8ipjFLwdvcOxtfuOVBCSI63
         qd5CWrQMqLBjgLycHaz3S/6S3Kt8G2AMy24M3lQ5031Z3qduACemfnBb87cRY0sdLBMR
         hEB3epV9oaabgeaHwETMS3CNMInPtwrn0N5iulkkN5oscyNZYJrxllMPbxG2raTBt/06
         Wbhw==
X-Gm-Message-State: AOJu0YwdvWz/598Lo++ie5JOVU0wytQPmCEONHYRPcGP6lerHE+RT2FE
        l7ENMsEdaAqSBJ2qxQQOGSyc6w==
X-Google-Smtp-Source: AGHT+IFfVbiUmgMwoeGwA3ZIdiIUuzVdm9gRZ3aJR2yt7ibzGaKFZJms3sDVibgDvTppejsGgzuaOA==
X-Received: by 2002:a17:90a:c254:b0:27d:1f9f:a57f with SMTP id d20-20020a17090ac25400b0027d1f9fa57fmr918230pjx.32.1697087732343;
        Wed, 11 Oct 2023 22:15:32 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([106.51.83.242])
        by smtp.gmail.com with ESMTPSA id s18-20020a17090330d200b001b9d95945afsm851309plc.155.2023.10.11.22.15.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Oct 2023 22:15:31 -0700 (PDT)
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
Subject: [PATCH v2 3/8] RISC-V: KVM: Allow some SBI extensions to be disabled by default
Date:   Thu, 12 Oct 2023 10:45:04 +0530
Message-Id: <20231012051509.738750-4-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231012051509.738750-1-apatel@ventanamicro.com>
References: <20231012051509.738750-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Currently, all SBI extensions are enabled by default which is
problematic for SBI extensions (such as DBCN) which are forwarded
to the KVM user-space because we might have an older KVM user-space
which is not aware/ready to handle newer SBI extensions. Ideally,
the SBI extensions forwarded to the KVM user-space must be
disabled by default.

To address above, we allow certain SBI extensions to be disabled
by default so that KVM user-space must explicitly enable such
SBI extensions to receive forwarded calls from Guest VCPU.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/asm/kvm_vcpu_sbi.h |  4 +++
 arch/riscv/kvm/vcpu.c                 |  6 ++++
 arch/riscv/kvm/vcpu_sbi.c             | 45 ++++++++++++++++-----------
 3 files changed, 36 insertions(+), 19 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
index 8d6d4dce8a5e..c02bda5559d7 100644
--- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
+++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
@@ -35,6 +35,9 @@ struct kvm_vcpu_sbi_return {
 struct kvm_vcpu_sbi_extension {
 	unsigned long extid_start;
 	unsigned long extid_end;
+
+	bool default_unavail;
+
 	/**
 	 * SBI extension handler. It can be defined for a given extension or group of
 	 * extension. But it should always return linux error codes rather than SBI
@@ -59,6 +62,7 @@ int kvm_riscv_vcpu_get_reg_sbi_ext(struct kvm_vcpu *vcpu,
 const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(
 				struct kvm_vcpu *vcpu, unsigned long extid);
 int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run);
+void kvm_riscv_vcpu_sbi_init(struct kvm_vcpu *vcpu);
 
 #ifdef CONFIG_RISCV_SBI_V01
 extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_v01;
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index c061a1c5fe98..e087c809073c 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -141,6 +141,12 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	if (rc)
 		return rc;
 
+	/*
+	 * Setup SBI extensions
+	 * NOTE: This must be the last thing to be initialized.
+	 */
+	kvm_riscv_vcpu_sbi_init(vcpu);
+
 	/* Reset VCPU */
 	kvm_riscv_reset_vcpu(vcpu);
 
diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
index 9cd97091c723..1b1cee86efda 100644
--- a/arch/riscv/kvm/vcpu_sbi.c
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -155,14 +155,8 @@ static int riscv_vcpu_set_sbi_ext_single(struct kvm_vcpu *vcpu,
 	if (!sext)
 		return -ENOENT;
 
-	/*
-	 * We can't set the extension status to available here, since it may
-	 * have a probe() function which needs to confirm availability first,
-	 * but it may be too early to call that here. We can set the status to
-	 * unavailable, though.
-	 */
-	if (!reg_val)
-		scontext->ext_status[sext->ext_idx] =
+	scontext->ext_status[sext->ext_idx] = (reg_val) ?
+			KVM_RISCV_SBI_EXT_AVAILABLE :
 			KVM_RISCV_SBI_EXT_UNAVAILABLE;
 
 	return 0;
@@ -337,18 +331,8 @@ const struct kvm_vcpu_sbi_extension *kvm_vcpu_sbi_find_ext(
 			    scontext->ext_status[entry->ext_idx] ==
 						KVM_RISCV_SBI_EXT_AVAILABLE)
 				return ext;
-			if (scontext->ext_status[entry->ext_idx] ==
-						KVM_RISCV_SBI_EXT_UNAVAILABLE)
-				return NULL;
-			if (ext->probe && !ext->probe(vcpu)) {
-				scontext->ext_status[entry->ext_idx] =
-					KVM_RISCV_SBI_EXT_UNAVAILABLE;
-				return NULL;
-			}
 
-			scontext->ext_status[entry->ext_idx] =
-				KVM_RISCV_SBI_EXT_AVAILABLE;
-			return ext;
+			return NULL;
 		}
 	}
 
@@ -419,3 +403,26 @@ int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
 
 	return ret;
 }
+
+void kvm_riscv_vcpu_sbi_init(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_sbi_context *scontext = &vcpu->arch.sbi_context;
+	const struct kvm_riscv_sbi_extension_entry *entry;
+	const struct kvm_vcpu_sbi_extension *ext;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(sbi_ext); i++) {
+		entry = &sbi_ext[i];
+		ext = entry->ext_ptr;
+
+		if (ext->probe && !ext->probe(vcpu)) {
+			scontext->ext_status[entry->ext_idx] =
+				KVM_RISCV_SBI_EXT_UNAVAILABLE;
+			continue;
+		}
+
+		scontext->ext_status[entry->ext_idx] = ext->default_unavail ?
+					KVM_RISCV_SBI_EXT_UNAVAILABLE :
+					KVM_RISCV_SBI_EXT_AVAILABLE;
+	}
+}
-- 
2.34.1

