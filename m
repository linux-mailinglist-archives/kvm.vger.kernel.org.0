Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2397C022B
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 19:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233874AbjJJRFl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 13:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234005AbjJJRFf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 13:05:35 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BACC0B0
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 10:05:30 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1c760b34d25so41212675ad.3
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 10:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1696957530; x=1697562330; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4smwE6VqfYxKvfF0tqu7jNc/7OXpVUXHc/+OAD0MBRk=;
        b=FhwWGb5Xse7nvJyYxyIZeHfhdiov1sPmpAIyzOeoCGEf39LOxkt7wfJ2Z0P8A/m678
         rZFtelP2j0l+cFV4L9Fd5cfVSWv91bpzgvCS53XnUBi1zh9W1Xz36U8+NoWS9joAjSbI
         PIzEhCDhs/CTR2GXh1mg5mra4y83r13ciVymQInsYDZrGiCQZaGGVuYTeY9T7kjMtIJK
         aeud+i6Sr7MfTROpnE4KzDCOMsNYMbUUKOD2aJVn1Xog8btOol7bejKOotidRPs3u8N9
         cT7AmZcOJCLaEJ70+JIuVaq/Iqpb+vIlh89lPryRr+V5veLBho8HplAufaN1fMW6m+Ks
         6RwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696957530; x=1697562330;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4smwE6VqfYxKvfF0tqu7jNc/7OXpVUXHc/+OAD0MBRk=;
        b=wRs2R4DoIsfxcEgSaGxFEKtZIT6/1LjQ6+8AMTM84u+pL4Gx26Yg/jFKgiGGsk1pxB
         3gVnYVuz5NYRMiCinqMLufTufkKX8BwUXDzqYYEniM1u+jLMIFw0gzbzQXb4iicUIWQ+
         3BgDDuMTOTzviLitPRxSnGyWgeZL3gt6U715ZXUEQqUXfwig/2okCkHHrrQ/4MioL05b
         SOd7O/oJg9Bd4qmp9wT/dH6aPEJLJuAKomU2qHx1/gEF43hals/vsnzVCRRH/n5Pv+Uu
         BokiYm/p601LY/y8n3ARqbQuXSc88FlaWslgr2pIzt20i/sWKOE+aGQVimV9WhXS44LS
         I2VQ==
X-Gm-Message-State: AOJu0Yyy7YMtzYXa2sronzCU3gWMxgWAB4HFkWXsiFCNo1KNRubvxQbl
        Niv5aFB4B2g0K+d7YoC6ExQgVg==
X-Google-Smtp-Source: AGHT+IFYY1cb953bXOW6ABKFWxZoUNl8/jrL5sgqvn5jtayOnZj/D//5h5O6D4FNJ+IJsn/Z4jFWDA==
X-Received: by 2002:a17:902:a402:b0:1c7:7e00:809e with SMTP id p2-20020a170902a40200b001c77e00809emr15730697plq.67.1696957529924;
        Tue, 10 Oct 2023 10:05:29 -0700 (PDT)
Received: from anup-ubuntu-vm.localdomain ([103.97.165.210])
        by smtp.gmail.com with ESMTPSA id w19-20020a1709027b9300b001b89536974bsm11979868pll.202.2023.10.10.10.05.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 10:05:29 -0700 (PDT)
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
Subject: [PATCH 3/6] RISC-V: KVM: Forward SBI DBCN extension to user-space
Date:   Tue, 10 Oct 2023 22:35:00 +0530
Message-Id: <20231010170503.657189-4-apatel@ventanamicro.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231010170503.657189-1-apatel@ventanamicro.com>
References: <20231010170503.657189-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The SBI DBCN extension needs to be emulated in user-space so let
us forward console_puts() call to user-space.

Signed-off-by: Anup Patel <apatel@ventanamicro.com>
---
 arch/riscv/include/asm/kvm_vcpu_sbi.h |  1 +
 arch/riscv/include/uapi/asm/kvm.h     |  1 +
 arch/riscv/kvm/vcpu_sbi.c             |  4 ++++
 arch/riscv/kvm/vcpu_sbi_replace.c     | 31 +++++++++++++++++++++++++++
 4 files changed, 37 insertions(+)

diff --git a/arch/riscv/include/asm/kvm_vcpu_sbi.h b/arch/riscv/include/asm/kvm_vcpu_sbi.h
index 8d6d4dce8a5e..a85f95eb6e85 100644
--- a/arch/riscv/include/asm/kvm_vcpu_sbi.h
+++ b/arch/riscv/include/asm/kvm_vcpu_sbi.h
@@ -69,6 +69,7 @@ extern const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_ipi;
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
index 9cd97091c723..b54fe52c915a 100644
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
index 7c4d5d38a339..347c5856347e 100644
--- a/arch/riscv/kvm/vcpu_sbi_replace.c
+++ b/arch/riscv/kvm/vcpu_sbi_replace.c
@@ -175,3 +175,34 @@ const struct kvm_vcpu_sbi_extension vcpu_sbi_ext_srst = {
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
+	.handler = kvm_sbi_ext_dbcn_handler,
+};
-- 
2.34.1

